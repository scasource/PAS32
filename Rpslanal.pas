unit Rpslanal;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, TabNotBk,
  RPFiler, RPCanvas, RPrinter, RPDefine, RPBase, RPTXFilr, Types, ComCtrls,
  CheckLst(*, Progress*);

type
  DetailedSaleRecord = record
    SwisCode : String;
    SBLKey : String;
    Section : String;
    SalesNumber : Integer;
    SchoolCode : String;
    LegalAddrNo : String;
    LegalAddr : String;
    CurrentOwner : String;
    PriorOwner : String;
    NeighborhoodCode : String;
    Frontage : Real;
    Depth : Real;
    Acreage : Real;
    AccountNumber : String;
    SaleControlNumber : String;
    ArmsLength : Boolean;
    SaleCondition : String;
    PropertyClassCode : String;
    PropertyClassDifferent : Boolean;
    SaleDate : TDateTime;
    ValidSale : Boolean;
    SalePrice : Comp;
    CurrentAssessedValue : Comp;
    AssessedValueAtTimeOfSale : Comp;
    AdjustedSalesPrice : Comp;
    AV_SP_Ratio : Real;
    OwnershipCode : String;
    SqFootLivingArea : LongInt;
    SP_SFLA_Ratio : Double;
    AV_SFLA_Ratio : Double;

  end;  {DetailedSaleRecord = record}

  PDetailedSaleRecord = ^DetailedSaleRecord;

type
  TSalesAnalysisForm = class(TForm)
    V: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    SwisCodeTable: TTable;
    SchoolCodeTable: TTable;
    NeighborhoodCodeTable: TTable;
    SalesTable: TTable;
    NYParcelTable: TTable;
    NYAssessmentTable: TTable;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    TYParcelTable: TTable;
    TYAssessmentTable: TTable;
    Label19: TLabel;
    TextFiler: TTextFiler;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    SortTable: TTable;
    NYResidentialSiteTable: TTable;
    NYCommercialSiteTable: TTable;
    Label22: TLabel;
    Label23: TLabel;
    PrintDialog: TPrintDialog;
    PropertyClassTable: TTable;
    SalesResidentialSiteTable: TTable;
    SalesCommercialSiteTable: TTable;
    Label25: TLabel;
    Label26: TLabel;
    Label29: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SalesResidentialBuildingTable: TTable;
    Panel1: TPanel;
    CloseButton: TBitBtn;
    PrintButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    PageControl: TPageControl;
    RangesTabSheet: TTabSheet;
    SalePriceGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    StartSalePriceEdit: TEdit;
    EndSalePriceEdit: TEdit;
    AllSalePricesCheckBox: TCheckBox;
    ToEndOfSalePricesCheckBox: TCheckBox;
    AVPriceGroupBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    StartAVPriceEdit: TEdit;
    EndAVPriceEdit: TEdit;
    AllAVPricesCheckBox: TCheckBox;
    ToEndOfAVPricesCheckBox: TCheckBox;
    SaleDateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    AV_SPRatioGroupBox: TGroupBox;
    Label27: TLabel;
    Label28: TLabel;
    AllAV_SPRatiosCheckBox: TCheckBox;
    ToEndOfAV_SPRatiosCheckBox: TCheckBox;
    StartAV_SPRatioEdit: TEdit;
    EndAV_SPRatioEdit: TEdit;
    DisplaySFLACheckBox: TCheckBox;
    Label30: TLabel;
    OptionsTabSheet: TTabSheet;
    NeighborhoodCodeTypeRadioGroup: TRadioGroup;
    MiscellaneousGroupBox: TGroupBox;
    ShowHistorySalesCheckBox: TCheckBox;
    ArmsLengthCheckBox: TCheckBox;
    ValidSaleCheckBox: TCheckBox;
    ExcludeSalesOnMoreThan1ParcelCheckBox: TCheckBox;
    AVTypeRadioGroup: TRadioGroup;
    CoopTypeRadioGroup: TRadioGroup;
    CondoTypeFor210RadioGroup: TRadioGroup;
    CondoTypeFor411RadioGroup: TRadioGroup;
    ReportTypeTabSheet: TTabSheet;
    ReportTypeRadioGroup: TRadioGroup;
    ReportGroupingRadioGroup: TRadioGroup;
    PrintOrderRadioGroup: TRadioGroup;
    cb_ExtractToExcel: TCheckBox;
    LoadFromParcelListCheckBox: TCheckBox;
    Swis_SchoolTabSheet: TTabSheet;
    PropertyClassTabSheet: TTabSheet;
    NeighborhoodsTabSheet: TTabSheet;
    SectionTabSheet: TTabSheet;
    Panel8: TPanel;
    Label3: TLabel;
    Panel9: TPanel;
    PropertyClassListBox: TListBox;
    Panel3: TPanel;
    Label13: TLabel;
    Panel4: TPanel;
    NeighborhoodCodeListBox: TListBox;
    Label9: TLabel;
    Label10: TLabel;
    AllSectionsCheckBox: TCheckBox;
    SectionsStringGrid: TStringGrid;
    Label5: TLabel;
    Label4: TLabel;
    SchoolCodeListBox: TListBox;
    SwisCodeListBox: TListBox;
    AccountNumberGroupBox: TGroupBox;
    Label6: TLabel;
    Label14: TLabel;
    StartAccountNumberEdit: TEdit;
    AllAccountNumbersCheckBox: TCheckBox;
    ToEndOfAccountNumbersCheckBox: TCheckBox;
    EndAccountNumberEdit: TEdit;
    SalesCommercialBuildingTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure AllSalePricesCheckBoxClick(Sender: TObject);
    procedure ToEndOfSalePricesCheckBoxClick(Sender: TObject);
    procedure AllAVPricesCheckBoxClick(Sender: TObject);
    procedure ToEndOfAVPricesCheckBoxClick(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure ToEndofDatesCheckBoxClick(Sender: TObject);
    procedure SectionsStringGridKeyPress(Sender: TObject; var Key: Char);
    procedure AllSectionsCheckBoxClick(Sender: TObject);
    procedure TextFilerPrintHeader(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure AllAV_SPRatiosCheckBoxClick(Sender: TObject);
    procedure ToEndOfAV_SPRatiosCheckBoxClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    SelectedPropertyClasses,
    SelectedSections,
    SelectedSwisCodes,
    SelectedSchoolCodes,
    SelectedNeighborhoodCodes : TStringList;

    ReportType,
    ReportGroupType,
    PrintOrder : Integer;

     {FXX05151998-1: Add AV/SP ratio range.}

    PrintAllSections,
    PrintAllDates,
    PrintAllSalePrices,
    PrintAllAVPrices,
    PrintAllAV_SPRatios,
    PrintToEndOfDates,
    PrintToEndOfSalePrices,
    PrintToEndOfAVPrices,
    PrintToEndOfAV_SPRatios : Boolean;

    StartDate,
    EndDate : TDateTime;
    StartAVPrice,
    EndAVPrice,
    StartSalePrice,
    EndSalePrice : Comp;
    StartAV_SPRatio,
    EndAV_SPRatio : Extended;

    PrintHistorySales,
    PrintArmsLengthSalesOnly,
    PrintValidSalesOnly,
    ShowPartialSales,
    UseCurrentAssessedValue,
    SalePricesHaveBeenAdjusted,
    UseCurrentNeighborhoodCodes : Boolean;

    ReportCancelled : Boolean;

    CurrentSwisCode,
    CurrentSchoolCode : String;
    CurrentPropertyClass,
    CurrentSection : String;
    CurrentNeighborhoodCode : String;
    CurrentSwisCodeName,
    CurrentSchoolCodeName,
    CurrentPropertyClassName : String;

    MedianAV_SP_RatioThisGroup : Real;
    CondominiumTypeFor210,
    CondominiumTypeFor411,
    CooperativeType : Integer;

    FirstPagePrinted : Boolean;
    OrigSortFileName : String;
    ExtractToExcel : Boolean;

    ExtractFile : TextFile;
    SpreadsheetFileName : String;
    LoadFromParcelList,
    DisplaySFLA, ExcludeSalesForMoreThan1Parcel : Boolean;

    PrintAllAccountNumbers,
    PrintToEndOfAccountNumbers : Boolean;
    StartAccountNumber,
    EndAccountNumber : String;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function ValidSelections : Boolean;
    {Did they enter all the necessary information?}

    Function RecordInRange(var NeighborhoodCode : String;
                           var CurrentAssessedValue : Comp;
                           var ParcelExistsNow : Boolean) : Boolean;
    {Check all the range options to see if this sale should go in the sort file.}

    Function TimeAdjustedSalesPrice(SalePrice : Comp) : Comp;
    {Adjust the sales price according to the time adjustments that they
     entered.}

    Procedure FillSortFileForRange(SalesTable : TTable;
                                   UpdateProgressDialog : Boolean);

    Procedure FillSortFile(var Quit : Boolean);
    {Go through all the sales records and find the ones that match and
     put them in the sort file.}

    Function DetermineKey(DetailedSaleRec : DetailedSaleRecord) : String;
    {Assemble a print order key from a group record.}

(*    Function Compare(Item1,
                     Item2 : PDetailedSaleRecord;
                     ComparisonType : Integer) : Boolean;

    Procedure Quicksort(List : TList;
                        LeftIndex,
                        RightIndex : Integer); *)

    Procedure SortListForPrintOrder(GroupList : TList);
    {Sort this group into the order that they want to see the group in.}

    Procedure PrintOneParcel(Sender : TObject;
                             DetailedSaleRec : DetailedSaleRecord;
                             Median_AV_SP_Ratio : Real);
    {Print one individual parcel for the detailed report.}

    Procedure PrintGroup(Sender : TObject;
                         GroupList : TList;
                         OverallSalesPriceList,
                         OverallAV_SP_RatioList : TStringList);
    {Print all the parcels for a group including the totals.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, UTILEXSD,  Prog,
     PASTypes, Preview, RptDialg, PrclList, DataAccessUnit;

const
  LinesLeftAtBottom = 12;

    {Report types}
  rtDetailed = 0;
  rtTotalsOnly = 1;
  rtDetailedNoOwner = 2;
  rtSubsequent = 3;

    {Groupings}
  goSwisCode = 0;
  goPropertyClass = 1;
  goNeighborhoodCode = 2;
  goSection = 3;
  goSchoolCode = 4;
  goNone = 5;

    {Print orders}
  poParcelID = 0;
  poLegalAddrNumber = 1;
  poLegalAddrName = 2;
  poSaleDate = 3;
  poSalePrice = 4;
  poAV_SP_Ratio = 5;

  ctOnlyCoops = 0;
  ctNoCoops = 1;
  ctEither = 2;

  cntOnlyCondosFor210 = 0;
  cntNoCondosFor210 = 1;
  cntEitherFor210 = 2;

  cntOnlyCondosFor411 = 0;
  cntNoCondosFor411 = 1;
  cntEitherFor411 = 2;

  LessThan = 0;
  GreaterThan = 1;

  TrialRun = False;

{$R *.DFM}

{========================================================}
Procedure TSalesAnalysisForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TSalesAnalysisForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'RPSLANAL';  {mmm}
  Quit := False;

    {Most of the tables we use will be next year except for
     the TY Parcel and TY AV tables which we need in case a parcel
     does not exist in NY.}

  OpenTablesForForm(Self, NextYear);

  OpenTableForProcessingType(TYParcelTable, ParcelTableName,
                             ThisYear, Quit);

  OpenTableForProcessingType(TYAssessmentTable, AssessmentTableName,
                             ThisYear, Quit);

  OpenTableForProcessingType(SalesCommercialSiteTable, CommercialSiteTableName,
                             SalesInventory, Quit);

  OpenTableForProcessingType(SalesResidentialSiteTable, ResidentialSiteTableName,
                             SalesInventory, Quit);

    {Now fill the swis, school, and neighborhood codes.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 15, True, True, GlblProcessingType,
                 GlblThisYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 15, True, True, GlblProcessingType,
                 GlblThisYear);

  FillOneListBox(NeighborhoodCodeListBox, NeighborhoodCodeTable, 'MainCode',
                 'Description', 0, True, False, GlblProcessingType,
                 GlblThisYear);

  FillOneListBox(PropertyClassListBox, PropertyClassTable, 'MainCode',
                 'Description', 15, True, True, GlblProcessingType,
                 GlblThisYear);

  OrigSortFileName := SortTable.TableName;

end;  {InitializeForm}

{===================================================================}
Procedure TSalesAnalysisForm.FormKeyPress(    Sender: TObject;
                                          var Key: Char);

begin
  If (Key = #13)
    then
      If (ActiveControl is TStringGrid)
        then
          with ActiveControl as TStringGrid do
            begin
              Key := #0;
              Col := Col + 1;

              If (Col > ColCount)
                then
                  begin
                    Col := 0;
                    Row := Row + 1;

                    If (Row > RowCount)
                      then Row := RowCount;

                  end;  {If (Col > ColCount)}

            end
        else
          begin
            Key := #0;
            Perform(WM_NEXTDLGCTL, 0, 0);
          end;

end;  {FormKeyPress}

{===============================================================}
Procedure TSalesAnalysisForm.AllSalePricesCheckBoxClick(Sender: TObject);

begin
  If AllSalePricesCheckBox.Checked
    then
      begin
        ToEndofSalePricesCheckBox.Checked := False;
        ToEndofSalePricesCheckBox.Enabled := False;
        StartSalePriceEdit.Text := '';
        StartSalePriceEdit.Enabled := False;
        StartSalePriceEdit.Color := clBtnFace;
        EndSalePriceEdit.Text := '';
        EndSalePriceEdit.Enabled := False;
        EndSalePriceEdit.Color := clBtnFace;

      end
    else EnableSelectionsInGroupBoxOrPanel(SalePriceGroupBox);

end;  {AllSalePricesCheckBoxClick}

{===============================================================}
Procedure TSalesAnalysisForm.ToEndOfSalePricesCheckBoxClick(Sender: TObject);

begin
  If ToEndOfSalePricesCheckBox.Checked
    then
      begin
        EndSalePriceEdit.Text := '';
        EndSalePriceEdit.Enabled := False;
        EndSalePriceEdit.Color := clBtnFace;
      end
    else
      begin
        EndSalePriceEdit.Enabled := True;
        EndSalePriceEdit.Color := clWindow;

      end;  {If ToEndOfSalePricesCheckBox.Checked}

end;  {ToEndOfSalePricesCheckBoxClick}

{===============================================================}
Procedure TSalesAnalysisForm.AllAVPricesCheckBoxClick(Sender: TObject);

begin
  If AllAVPricesCheckBox.Checked
    then
      begin
        ToEndofAVPricesCheckBox.Checked := False;
        ToEndofAVPricesCheckBox.Enabled := False;
        StartAVPriceEdit.Text := '';
        StartAVPriceEdit.Enabled := False;
        StartAVPriceEdit.Color := clBtnFace;
        EndAVPriceEdit.Text := '';
        EndAVPriceEdit.Enabled := False;
        EndAVPriceEdit.Color := clBtnFace;

      end
    else EnableSelectionsInGroupBoxOrPanel(AVPriceGroupBox);

end;  {AllAVPricesCheckBoxClick}

{===============================================================}
Procedure TSalesAnalysisForm.ToEndOfAVPricesCheckBoxClick(Sender: TObject);

begin
  If ToEndOfAVPricesCheckBox.Checked
    then
      begin
        EndAVPriceEdit.Text := '';
        EndAVPriceEdit.Enabled := False;
        EndAVPriceEdit.Color := clBtnFace;
      end
    else
      begin
        EndAVPriceEdit.Enabled := True;
        EndAVPriceEdit.Color := clWindow;

      end;  {If ToEndOfAVPricesCheckBox.Checked}

end;  {ToEndOfAVPricesCheckBoxClick}

{===============================================================}
Procedure TSalesAnalysisForm.AllDatesCheckBoxClick(Sender: TObject);

begin
  If AllDatesCheckBox.Checked
    then
      begin
        ToEndofDatesCheckBox.Checked := False;
        ToEndofDatesCheckBox.Enabled := False;
        StartDateEdit.Text := '';
        StartDateEdit.Enabled := False;
        StartDateEdit.Color := clBtnFace;
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;

      end
    else EnableSelectionsInGroupBoxOrPanel(SaleDateGroupBox);

end;  {AllDatesCheckBoxClick}

{===============================================================}
Procedure TSalesAnalysisForm.ToEndofDatesCheckBoxClick(Sender: TObject);

begin
  If ToEndOfDatesCheckBox.Checked
    then
      begin
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else
      begin
        EndDateEdit.Enabled := True;
        EndDateEdit.Color := clWindow;

      end;  {If ToEndOfDatesCheckBox.Checked}

end;  {ToEndofDatesCheckBoxClick}

{FXX05151998-1: Add AV_SP ratio range.}
{=========================================================================}
Procedure TSalesAnalysisForm.AllAV_SPRatiosCheckBoxClick(Sender: TObject);

begin
  If AllAV_SPRatiosCheckBox.Checked
    then
      begin
        ToEndofAV_SPRatiosCheckBox.Checked := False;
        ToEndofAV_SPRatiosCheckBox.Enabled := False;
        StartAV_SPRatioEdit.Text := '';
        StartAV_SPRatioEdit.Enabled := False;
        StartAV_SPRatioEdit.Color := clBtnFace;
        EndAV_SPRatioEdit.Text := '';
        EndAV_SPRatioEdit.Enabled := False;
        EndAV_SPRatioEdit.Color := clBtnFace;

      end
    else EnableSelectionsInGroupBoxOrPanel(AV_SPRatioGroupBox);

end;  {AllAV_SPRatiosCheckBoxClick}

{===============================================================}
Procedure TSalesAnalysisForm.ToEndOfAV_SPRatiosCheckBoxClick(Sender: TObject);

begin
  If ToEndOfAV_SPRatiosCheckBox.Checked
    then
      begin
        EndAV_SPRatioEdit.Text := '';
        EndAV_SPRatioEdit.Enabled := False;
        EndAV_SPRatioEdit.Color := clBtnFace;
      end
    else
      begin
        EndAV_SPRatioEdit.Enabled := True;
        EndAV_SPRatioEdit.Color := clWindow;

      end;  {If ToEndOfAV_SPRatiosCheckBox.Checked}

end;  {ToEndofAV_SPRatiosCheckBoxClick}

{===============================================================}
Procedure TSalesAnalysisForm.SectionsStringGridKeyPress(    Sender: TObject;
                                                        var Key: Char);

{If the check box is on for all sections and they start typing in the grid
 to enter individual sections, then turn the check off.}

begin
  If AllSectionsCheckBox.Checked
    then AllSectionsCheckBox.Checked := False;

end;  {SectionsStringGridKeyPress}

{===============================================================}
Procedure TSalesAnalysisForm.AllSectionsCheckBoxClick(Sender: TObject);

{If they click the all sections check box, be sure to clear the grid.}

var
  I, J : Integer;

begin
  If not AllSectionsCheckBox.Checked
    then
      with SectionsStringGrid do
        For I := 0 to (Col - 1) do
          For J := 0 to (Row - 1) do
            Cells[I, J] := '';

end;  {AllSectionsCheckBoxClick}

{===============================================================}
Function TSalesAnalysisForm.ValidSelections : Boolean;

{Did they enter all the necessary information?}

var
  I, J : Integer;
  SectionFound : Boolean;

begin
  Result := True;

    {First make sure that they selected a swis code.}

  If (SwisCodeListBox.SelCount = 0)
    then
      begin
        Result := False;
        MessageDlg('Please select the swis codes that you want.',
                   mtError, [mbOK], 0);
      end;

    {Now make sure that they selected a school code.}

  If (Result and
      (SchoolCodeListBox.SelCount = 0))
    then
      begin
        Result := False;
        MessageDlg('Please select the school codes that you want.',
                   mtError, [mbOK], 0);
      end;

    {Now make sure that they selected a property class code.}

  If (Result and
      (PropertyClassListBox.SelCount = 0))
    then
      begin
        Result := False;
        MessageDlg('Please select the property classes that you want.',
                   mtError, [mbOK], 0);
      end;

    {Now make sure that they selected a neighborhood code if there are any.}

  If (Result and
      (NeighborhoodCodeListBox.SelCount = 0) and
      (NeighborhoodCodeListBox.Items.Count > 0))
    then
      begin
        Result := False;
        MessageDlg('Please select the neighborhood codes that you want.',
                   mtError, [mbOK], 0);
      end;

    {Now make sure that they selected the sections they want.}

  If (Result and
      (not AllSectionsCheckBox.Checked))
    then
      begin
        SectionFound := False;

        with SectionsStringGrid do
          For I := 0 to (ColCount - 1) do
            For J := 0 to (RowCount - 1) do
              If (Deblank(Cells[I,J]) <> '')
                then SectionFound := True;

        If not SectionFound
          then
            begin
              Result := False;
              MessageDlg('Please enter the sections that you want included or check All to select all sections.',
                         mtError, [mbOK], 0);

            end;

      end;  {If (Result and ...}

    {Now make sure that they selected a report type.}

  If (Result and
      (ReportTypeRadioGroup.ItemIndex = -1))
    then
      begin
        Result := False;
        MessageDlg('Please select the report type that you want.',
                   mtError, [mbOK], 0);
      end;

    {Now make sure that they selected a group type.}
    {Not required for subsequent sales analysis.}

  If (Result and
      (ReportGroupingRadioGroup.ItemIndex = -1) and
      (ReportTypeRadioGroup.ItemIndex <> rtSubsequent))
    then
      begin
        Result := False;
        MessageDlg('Please select the group type that you want.',
                   mtError, [mbOK], 0);
      end;

    {Now make sure that they selected a print order.}
    {Not required for subsequent sales analysis.}

  If (Result and
      (PrintOrderRadioGroup.ItemIndex = -1) and
      (ReportTypeRadioGroup.ItemIndex <> rtSubsequent))
    then
      begin
        Result := False;
        MessageDlg('Please select the print order that you want.',
                   mtError, [mbOK], 0);
      end;

    {Now make sure that they selected an AV type to compare sales to.}
    {Not required for subsequent sales analysis.}

  If (Result and
      (AVTypeRadioGroup.ItemIndex = -1) and
      (ReportTypeRadioGroup.ItemIndex <> rtSubsequent))
    then
      begin
        Result := False;
        MessageDlg('Please select which assessed value the sales price should be compared against - ' + #13 +
                   'the current assessed value or the assessed value at the time of the sale.',
                   mtError, [mbOK], 0);
      end;

    {Now make sure that they selected a sales price range.}

  If Result
    then
      begin
        Result := False;

        If AllSalePricesCheckBox.Checked
          then Result := True
          else
            begin
              If ((Deblank(StartSalePriceEdit.Text) <> '') and
                  ((Deblank(EndSalePriceEdit.Text) <> '') or
                   ToEndOfSalePricesCheckBox.Checked))
                then Result := True;

              If ((Deblank(StartSalePriceEdit.Text) = '') and
                  (Deblank(EndSalePriceEdit.Text) = '') and
                  (not ToEndOfSalePricesCheckBox.Checked))
                then
                  begin
                    AllSalePricesCheckBox.Checked := True;
                    Result := True;
                  end;

            end;  {else of If AllSalePricesCheckBox.Checked}

        If not Result
          then MessageDlg('Please enter a sales price range.',
                          mtError, [mbOK], 0);

      end;  {If Result}

    {Now make sure that they selected an assessed value range.}

  If Result
    then
      begin
        Result := False;

        If AllAVPricesCheckBox.Checked
          then Result := True
          else
            begin
              If ((Deblank(StartAVPriceEdit.Text) <> '') and
                  ((Deblank(EndAVPriceEdit.Text) <> '') or
                   ToEndOfAVPricesCheckBox.Checked))
                then Result := True;

              If ((Deblank(StartAVPriceEdit.Text) = '') and
                  (Deblank(EndAVPriceEdit.Text) = '') and
                  (not ToEndOfAVPricesCheckBox.Checked))
                then
                  begin
                    Result := True;
                    AllAVPricesCheckBox.Checked := True;
                  end;

            end;  {else of If AllAVPricesCheckBox.Checked}

        If not Result
          then MessageDlg('Please enter an assessed value range.',
                          mtError, [mbOK], 0);

      end;  {If Result}

    {Now make sure that they selected a sales date range.}

  If Result
    then
      begin
        Result := False;

        If AllDatesCheckBox.Checked
          then Result := True
          else
            If (StartDateEdit.Text = '  /  /    ')
              then
                begin
                  If (EndDateEdit.Text = '  /  /    ')
                    then
                      begin
                        Result := True;
                        AllDatesCheckBox.Checked := True;
                      end;

                end
              else
                begin  {Start date filled in}
                  If (EndDateEdit.Text = '  /  /    ')
                    then
                      begin
                        If ToEndofDatesCheckBox.Checked
                          then Result := True;
                      end
                    else Result := True;

                end;  {else of If (StartDateEdit.Text = '  /  /    ')}

        If not Result
          then MessageDlg('Please enter a date range.',
                          mtError, [mbOK], 0);

      end;  {If Result}

    {FXX05151998-1: Allow for selection of AV/SP ratio range.}
    {Now make sure that they selected a AV/SP ratio range.}

  If Result
    then
      begin
        Result := False;

        If AllAV_SPRatiosCheckBox.Checked
          then Result := True
          else
            If ((Deblank(StartAV_SPRatioEdit.Text) <> '') and
                ((Deblank(EndAV_SPRatioEdit.Text) <> '') or
                 ToEndOfAV_SPRatiosCheckBox.Checked))
              then Result := True;

        If not Result
          then MessageDlg('Please enter a AV/SP Ratio range.',
                          mtError, [mbOK], 0);

      end;  {If Result}

    {CHG01172005-1(2.8.3.1)[2009]: Add account number range.}

  If Result
    then
      If ((Deblank(StartAccountNumberEdit.Text) <> '') or
          (Deblank(EndAccountNumberEdit.Text) <> '') or
          AllAccountNumbersCheckBox.Checked or
          ToEndofAccountNumbersCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofAccountNumbersCheckBox.Checked or
                 (Deblank(EndAccountNumberEdit.Text) <> '')) and
                (Deblank(StartAccountNumberEdit.Text) = ''))
              then
                begin
                  MessageDlg('Please select a starting account number or chose all AccountNumber"s.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((Deblank(StartAccountNumberEdit.Text) <> '') and
                ((Deblank(EndAccountNumberEdit.Text) = '') and
                 (not ToEndofAccountNumbersCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending account number or chose to print to the end of the AccountNumber"s on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllAccountNumbersCheckBox.Checked := True;

end;  {ValidSelections}

{===============================================================}
Function TSalesAnalysisForm.RecordInRange(var NeighborhoodCode : String;
                                          var CurrentAssessedValue : Comp;
                                          var ParcelExistsNow : Boolean) : Boolean;

{Check all the range options to see if this sale should go in the sort file.}
{FXX12302004-1(2.8.1.7): Adjustments to not compare on blank data such as school code.}

var
  OwnershipCode : String;
  SwisCode, SchoolCode : String;
  Section, PropertyClass : String;
  _Found : Boolean;
  I, SalesNumber : Integer;
  ValidStatuses : Charset;
  SwisSBLKey : String;
  TempStr : String;
  TempRatio : Extended;
  SalesPrice : Comp;

begin
  Result := False;

  SwisCode := Copy(SalesTable.FieldByName('SwisSBLKey').Text, 1, 6);
  SchoolCode := SalesTable.FieldByName('SchoolDistCode').Text;
  Section := Copy(SalesTable.FieldByName('SwisSBLKey').Text, 7, 3);
  PropertyClass := SalesTable.FieldByName('PropClass').Text;
  OwnershipCode := SalesTable.FieldByName('OwnershipCode').Text;

  with SalesTable do
    SwisSBLKey := FieldByName('SwisSBLKey').Text;

  TempStr := ConvertSwisSBLToDashDot(SwisSBLKey);

    {First check the swis code.}

  For I := 0 to (SelectedSwisCodes.Count - 1) do
    If (Take(6, SwisCode) = Take(6, SelectedSwisCodes[I]))
      then Result := True;

    {Next check the school code.}

  If (Result and
      (not _Compare(SchoolCode, '', coEqual)))
    then
      begin
        Result := False;

        For I := 0 to (SelectedSchoolCodes.Count - 1) do
          If _Compare(SchoolCode, SelectedSchoolCodes[I], coEqual)
            then Result := True;

      end;  {If Result}

    {Next check property classes. Note that we only check on the first
     number of the property class since it is general classes only.}
    {CHG04132001-1: Allow for better selection of property classes -
                    Actually is on all 3 numbers of code now.}

  If (Result and
      (not _Compare(PropertyClass, '', coEqual)))
    then
      begin
        Result := False;

        For I := 0 to (SelectedPropertyClasses.Count - 1) do
          If _Compare(PropertyClass, SelectedPropertyClasses[I], coEqual)
            then Result := True;

      end;  {If Result}

    {Next check sections.}

  If Result
    then
      begin
        Result := False;

        If AllSectionsCheckBox.Checked
          then Result := True
          else
            For I := 0 to (SelectedSections.Count - 1) do
              If (Take(3, Section) = Take(3, SelectedSections[I]))
                then Result := True;

      end;  {If Result}

     {Check the sales date.}

  If Result
    then
      begin
        Result := False;

          {FXX04081998-3: Wrong field name.}

        If PrintAllDates
          then Result := True
          else
            If ((SalesTable.FieldByName('SaleDate').AsDateTime >= StartDate) and
                (PrintToEndOfDates or
                 (SalesTable.FieldByName('SaleDate').AsDateTime <= EndDate)))
              then Result := True;

      end;  {If Result}

     {Check the sales Price.}

  If Result
    then
      begin
        Result := False;

        If PrintAllSalePrices
          then Result := True
          else
            If ((SalesTable.FieldByName('SalePrice').AsFloat >= StartSalePrice) and
                (PrintToEndOfSalePrices or
                 (SalesTable.FieldByName('SalePrice').AsFloat <= EndSalePrice)))
              then Result := True;

      end;  {If Result}

    {Make sure this has a sale status code of 'A', 'R', 'M', 'T', or 'N'.
     If they want to see history sales, 'H' is valid too.}

  If Result
    then
      begin
        Result := False;

          {FXX07301998-5: Missing sales status 'I'.}

        ValidStatuses := ['A', 'R', 'M', 'T', 'N', 'I', ' '];

        If PrintHistorySales
          then ValidStatuses := ValidStatuses + ['H'];

        If (Take(1, SalesTable.FieldByName('SaleStatusCode').Text)[1] in ValidStatuses)
          then Result := True;

        TempStr := SalesTable.FieldByName('SaleStatusCode').Text;

      end;  {If Result}

    {If they want to see arms length only, eliminate non-arms length sales.}

  If (Result and
      PrintArmsLengthSalesOnly)
    then Result := SalesTable.FieldByName('ArmsLength').AsBoolean;

    {If they want to see valid sales only, eliminate non-valid sales.}

  If (Result and
      PrintValidSalesOnly)
    then Result := SalesTable.FieldByName('ValidSale').AsBoolean;

    {FXX07151998-6: This test was incorrect.}

  If (Result and
      (not ShowPartialSales))
    then
      If (Pos('E', SalesTable.FieldByName('SaleConditionCode').Text) > 0)
        then Result := False;

    {CHG04152003-3(2.07): Option to exclude sales that have NumParcels > 1.}

  If (Result and
      ExcludeSalesForMoreThan1Parcel and
      (SalesTable.FieldByName('NoParcels').AsInteger > 1))
    then Result := False;

     {FXX01292000-1: Never use the NY assessed value - it is a projected value.}

     {Now get the current assessed value.  We will first look in
      the next year file. If it is not there, then we will use ThisYear.
      If it is not there, we will return a Boolean. Then check it against
      the range that they want to see.}

  If Result
    then
      begin
        ParcelExistsNow := False;
        CurrentAssessedValue := 0;
        _Found := False;

     (*   try
          _Found := NYAssessmentTable.FindKey([GlblNextYear,
                                              SalesTable.FieldByName('SwisSBLKey').Text]);
        except
          SystemSupport(025, NYAssessmentTable, 'Error getting NY assessment.',
                        UnitName, GlblErrorDlgBox);
        end;

        If _Found
          then
            begin
              CurrentAssessedValue := NYAssessmentTable.FieldByName('TotalAssessedVal').AsFloat;
              ParcelExistsNow := True;
            end; *)

          {Check This Year}

        If not _Found
          then
            begin
              try
                _Found := FindKeyold(TYAssessmentTable,
                                     ['TaxRollYr', 'SwisSBLKey'],
                                     [GlblThisYear,
                                      SalesTable.FieldByName('SwisSBLKey').Text]);
              except
                SystemSupport(025, TYAssessmentTable, 'Error getting TY assessment.',
                              UnitName, GlblErrorDlgBox);
              end;

              If _Found
                then
                  begin
                    CurrentAssessedValue := TYAssessmentTable.FieldByName('TotalAssessedVal').AsFloat;
                    ParcelExistsNow := True;
                  end;

            end;  {If not _Found}

         {Now actually compare the assessed value against the range that
          they wish to see.  If this parcel does not exist now, then don't
          use AV as criteria.}

        Result := False;

        If ParcelExistsNow
          then
            begin
              If PrintAllAVPrices
                then Result := True
                else
                  If ((CurrentAssessedValue >= StartAVPrice) and
                      (PrintToEndOfAVPrices or
                       (CurrentAssessedValue <= EndAVPrice)))
                    then Result := True;

            end
          else Result := True;

      end;  {If Result}

     {FXX05151998-1: Add AV/SP ratio range.}

  If Result
    then
      begin
        Result := False;
        SalesPrice := SalesTable.FieldByName('SalePrice').AsFloat;

         {FXX07201998-1: Need exception handler in case of divide by 0.}
         {FXX01032000-1: As extra precaution, don't even allow exception.}

        If (Roundoff(SalesPrice, 0) > 0)
          then
            try
              If UseCurrentAssessedValue
                then TempRatio := CurrentAssessedValue / SalesPrice
                else TempRatio := SalesTable.FieldByName('TotAssessedVal').AsFloat /
                                  SalesPrice;
            except
              TempRatio := 0;
            end
          else TempRatio := 0;

        If PrintAllAV_SPRatios
          then Result := True
          else
            If ((TempRatio >= StartAV_SPRatio) and
                (PrintToEndOfAV_SPRatios or
                 (TempRatio <= EndAV_SPRatio)))
              then Result := True;

      end;  {If Result}

     {Finally see if the neighborhood code is in range.  To do this,
      look to see if there is a residential or commercial inv
      record for this site so that we can get the neighborhood code.
      Note that they can select to either use the neighborhood code at
      time of sale or the current.  We will only check for a neighborhood
      code if there is any inventory.}

  If Result
    then
      If UseCurrentNeighborhoodCodes
        then
          begin
            If ((NeighborhoodCodeListBox.Items.Count > 0) and
                ((GetRecordCount(NYCommercialSiteTable) > 0) or
                 (GetRecordCount(NYResidentialSiteTable) > 0)))
              then
                begin

                    {FXX01252001-1: Be sure to default the Result to False
                                    so that it does not include all neighborhoods.}

                  Result := False;
                  _Found := False;

                  try
                    FindNearestOld(NYResidentialSiteTable,
                                   ['TaxRollYr', 'SwisSBLKey'],
                                   [GlblNextYear, SwisSBLKey]);

                    with NYResidentialSiteTable do
                      If (FieldByName('SwisSBLKey').Text = SwisSBLKey)
                        then
                          begin
                            NeighborhoodCode := FieldByName('NeighborhoodCode').Text;
                            _Found := True;
                          end;

                  except
                    _Found := False;
                  end;

                  If not _Found
                    then
                      try
                        FindNearestOld(NYCommercialSiteTable,
                                       ['TaxRollYr', 'SwisSBLKey'],
                                       [GlblNextYear, SwisSBLKey]);

                        with NYCommercialSiteTable do
                          If (FieldByName('SwisSBLKey').Text = SwisSBLKey)
                            then
                              begin
                                NeighborhoodCode := FieldByName('NeighborhoodCode').Text;
                                _Found := True;
                              end;

                      except
                        _Found := False;
                      end;

                    {If we _Found a neighborhood code, then see if it is in the
                     list of codes that they want.}
                    {FXX05232003-1(2.07b): If this is vacant land, there probably is not
                                           a site and no neighborhood code, so don't exclude it.}
                    {FXX02242004-1(2.08): If all the neighborhoods are selected, then ignore this.}

                  If _Found
                    then
                      begin
                        If (SelectedNeighborhoodCodes.Count = NeighborhoodCodeListBox.Items.Count)
                          then Result := True
                          else
                            For I := 0 to (SelectedNeighborhoodCodes.Count - 1) do
                              If (Take(5, SelectedNeighborhoodCodes[I]) =
                                  Take(5, NeighborhoodCode))
                                then Result := True;
                      end
                    else
                      try
                        If (PropertyClass[1] = '3')
                          then Result := True;
                      except
                      end;

                end  {If ((NYCommercialSiteTable.RecordCount > 0) or ...}
              else
                begin
                     {The municipality has no inventory and no neighborhood codes,
                      so this is not a selection basis.}

                  Result := True;
                  NeighborhoodCode := '';

                end;  {If ((NYCommercialSiteTable.RecordCount > 0) or ...}

          end
        else
          begin
            If ((NeighborhoodCodeListBox.Items.Count > 0) and
                ((GetRecordCount(SalesCommercialSiteTable) > 0) or
                 (GetRecordCount(SalesResidentialSiteTable) > 0)))
              then
                begin
                  Result := False;
                  _Found := False;
                  SalesNumber := SalesTable.FieldByName('SaleNumber').AsInteger;

                  try
                    FindNearestOld(SalesResidentialSiteTable,
                                   ['SwisSBLKey', 'SalesNumber'],
                                   [SwisSBLKey, IntToStr(SalesNumber)]);

                    with SalesResidentialSiteTable do
                      If ((FieldByName('SwisSBLKey').Text = SwisSBLKey) and
                          (FieldByName('SalesNumber').AsInteger = SalesNumber))
                        then
                          begin
                            NeighborhoodCode := FieldByName('NeighborhoodCode').Text;
                            _Found := True;
                          end;

                  except
                    _Found := False;
                  end;

                  If not _Found
                    then
                      try
                        FindNearestOld(SalesCommercialSiteTable,
                                       ['SwisSBLKey', 'SalesNumber'],
                                       [SwisSBLKey, IntToStr(SalesNumber)]);

                        with SalesCommercialSiteTable do
                          If ((FieldByName('SwisSBLKey').Text = SwisSBLKey) and
                              (FieldByName('SalesNumber').AsInteger = SalesNumber))
                            then
                              begin
                                NeighborhoodCode := FieldByName('NeighborhoodCode').Text;
                                _Found := True;
                              end;

                      except
                        _Found := False;
                      end;

                    {If we _Found a neighborhood code, then see if it is in the
                     list of codes that they want.}
                    {FXX05232003-1(2.07b): If this is vacant land, there probably is not
                                           a site and no neighborhood code, so don't exclude it.}

                  If _Found
                    then
                      begin
                        For I := 0 to (SelectedNeighborhoodCodes.Count - 1) do
                          If (Take(5, SelectedNeighborhoodCodes[I]) =
                              Take(5, NeighborhoodCode))
                            then Result := True;

                      end
                    else
                      try
                        If (PropertyClass[1] = '3')
                          then Result := True;
                      except
                      end;

                end  {If ((SalesCommercialSiteTable.RecordCount > 0) or ...}
              else
                begin
                     {The municipality has no inventory and no neighborhood codes,
                      so this is not a selection basis.}

                  Result := True;
                  NeighborhoodCode := '';

                end;  {If ((SalesCommercialSiteTable.RecordCount > 0) or ...}

          end;  {else of If UseCurrentNeighborhoodCodes}

    {CHG04032001-1: Allow for a selection of cooperatives and condos.}

  If (Result and
      (PropertyClass = '411'))
    then
      begin
        case CooperativeType of
          ctOnlyCoops : Result := (OwnershipCode = 'P');
          ctNoCoops : Result := (OwnershipCode <> 'P');

        end;  {case CooperativeType of}

      end;  {If (Result and ...}

    {FXX04122001-1: Seperate the 411 from the 210 property class for
                    condominiums.}

  If (Result and
      (PropertyClass = '411'))
    then
      begin
        case CondominiumTypeFor411 of
          cntOnlyCondosFor411 : Result := (OwnershipCode = 'C');
          cntNoCondosFor411 : Result := (OwnershipCode <> 'C');

        end;  {case CondimiumTypeFor411 of}

      end;  {If (Result and ...}

  If (Result and
      (PropertyClass = '210'))
    then
      begin
        case CondominiumTypeFor210 of
          cntOnlyCondosFor210 : Result := (OwnershipCode = 'C');
          cntNoCondosFor210 : Result := (OwnershipCode <> 'C');

        end;  {case CondimiumTypeFor210 of}

      end;  {If (Result and ...}

    {CHG02052005-1(2.8.3.5)[2009]: Add account number range.}

  If Result
    then
      begin
        Result := False;

        If PrintAllAccountNumbers
          then Result := True
          else
            If ((SalesTable.FieldByName('AccountNo').Text >= StartAccountNumber) and
                (PrintToEndOfAccountNumbers or
                 (SalesTable.FieldByName('AccountNo').Text <= EndAccountNumber)))
              then Result := True;

      end;  {If Result}


  try
    with SalesTable do
    If (Result and
        (FieldByName('RAR_Excluded').AsBoolean or
         FieldByName('COD_Excluded').AsBoolean))
    then Result := False;
  except
  end;

end;  {RecordInRange}

{===============================================================}
Function TSalesAnalysisForm.TimeAdjustedSalesPrice(SalePrice : Comp) : Comp;

{Adjust the sales price according to the time adjustments that they
 entered.}

begin
  Result := SalePrice;
end;  {TimeAdjustedSalesPrice}

{===============================================================}
Procedure TSalesAnalysisForm.FillSortFileForRange(SalesTable : TTable;
                                                  UpdateProgressDialog : Boolean);

var
  Quit, Done, _Found,
  PropertyClassFound, PropertyClassDifferent,
  FirstTimeThrough, ParcelExistsNow : Boolean;
  NeighborhoodCode, ParcelPropertyClass,
  SwisSBLKey, TempStr : String;
  CurrentAssessedValue, TimeAdjSalePrice : Comp;
  SBLRec : SBLRecord;
  TempNum, Ratio : Double;
  ResidentialBldgTable, CommercialBldgTable : TTable;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SalesTable.Next;

    If SalesTable.EOF
      then Done := True;

    Application.ProcessMessages;

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SalesTable.FieldByName('SwisSBLKey').Text));

    TempStr := ConvertSwisSBLToDashDot(SalesTable.FieldByName('SwisSBLKey').Text);

    If (not (Done or Quit) and
        RecordInRange(NeighborhoodCode,
                      CurrentAssessedValue, ParcelExistsNow))
      then
        with SortTable do
          try
            Insert;
            SwisSBLKey := SalesTable.FieldByName('SwisSBLKey').Text;

            FieldByName('SwisCode').Text := Copy(SwisSBLKey, 1, 6);
            FieldByName('SBLKey').Text := Copy(SwisSBLKey, 7, 20);
            FieldByName('Section').Text := Copy(SwisSBLKey, 7, 3);
            FieldByName('SchoolCode').Text := SalesTable.FieldByName('SchoolDistCode').Text;
            FieldByName('CurrentOwner').Text := SalesTable.FieldByName('NewOwnerName').Text;
            FieldByName('PriorOwner').Text := SalesTable.FieldByName('OldOwnerName').Text;
            FieldByName('Frontage').AsFloat := Roundoff(SalesTable.FieldByName('Frontage').AsFloat, 2);
            FieldByName('Depth').AsFloat := Roundoff(SalesTable.FieldByName('Depth').AsFloat, 2);
            FieldByName('Acreage').AsFloat := Roundoff(SalesTable.FieldByName('Acreage').AsFloat, 2);
            FieldByName('AccountNumber').Text := SalesTable.FieldByName('AccountNo').Text;
            FieldByName('SaleControlNumber').Text := SalesTable.FieldByName('ControlNo').Text;
            FieldByName('ArmsLength').AsBoolean := SalesTable.FieldByName('ArmsLength').AsBoolean;
            FieldByName('SaleCondition').Text := SalesTable.FieldByName('SaleConditionCode').Text;
            FieldByName('NeighborhoodCode').Text := ShiftRightAddZeroes(Take(5, NeighborhoodCode));
            FieldByName('PropertyClass').Text := SalesTable.FieldByName('PropClass').Text;
            FieldByName('SalesNumber').AsInteger := SalesTable.FieldByName('SaleNumber').AsInteger;
            FieldByName('OwnershipCode').Text := SalesTable.FieldByName('OwnershipCode').Text;

              {See if the property class code matches the current property
               class - we will check the next year parcel first.}

            PropertyClassFound := False;
            ParcelPropertyClass := '';

            SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

            try
              with SBLRec do
                PropertyClassFound := FindKeyOld(NYParcelTable,
                                                 ['TaxRollYr', 'SwisCode', 'Section',
                                                  'Subsection', 'Block', 'Lot', 'Sublot',
                                                  'Suffix'],
                                                 [GlblNextYear, SwisCode,
                                                  Section, Subsection,
                                                  Block, Lot, Sublot,
                                                  Suffix]);
              If PropertyClassFound
                then ParcelPropertyClass := NYParcelTable.FieldByName('PropertyClassCode').Text;

            except
            end;

              {If no next year parcel, try this year.}

            If not PropertyClassFound
              then
                try
                  with SBLRec do
                    PropertyClassFound := FindKeyOld(TYParcelTable,
                                                     ['TaxRollYr', 'SwisCode', 'Section',
                                                      'Subsection', 'Block', 'Lot', 'Sublot',
                                                      'Suffix'],
                                                     [GlblThisYear, SwisCode,
                                                      Section, Subsection,
                                                      Block, Lot, Sublot,
                                                      Suffix]);
                  If PropertyClassFound
                    then ParcelPropertyClass := TYParcelTable.FieldByName('PropertyClassCode').Text;

                except
                end;

            PropertyClassDifferent := (FieldByName('PropertyClass').Text <> ParcelPropertyClass);

            FieldByName('PropertyClassDiff').AsBoolean := PropertyClassDifferent;

            FieldByName('SaleDate').Text := SalesTable.FieldByName('SaleDate').Text;
            FieldByName('ValidSale').AsBoolean := SalesTable.FieldByName('ValidSale').AsBoolean;
            FieldByName('SalePrice').AsFloat := SalesTable.FieldByName('SalePrice').AsFloat;
            FieldByName('AssessedValAtSale').AsFloat := SalesTable.FieldByName('TotAssessedVal').AsFloat;
            FieldByName('CurrentAssessedValue').AsFloat := CurrentAssessedValue;
            FieldByName('ParcelExistsNow').AsBoolean := ParcelExistsNow;
            FieldByName('LegalAddr').Text := SalesTable.FieldByName('LegalAddr').Text;
            FieldByName('LegalAddrNo').Text := SalesTable.FieldByName('LegalAddrNo').Text;

              {Default the time adjusted sales price to the actual sales
               price.}

            TimeAdjSalePrice := SalesTable.FieldByName('SalePrice').AsFloat;


            If ParcelExistsNow
              then FieldByName('AdjustedSalesPrice').AsFloat :=
                                   TimeAdjustedSalesPrice(TimeAdjSalePrice);

             {FXX07201998-1: Need exception handler in case of divide by 0.}
             {FXX01032000-1: As extra precaution, don't even allow exception.}

            If (Roundoff(TimeAdjSalePrice, 0) > 0)
              then
                try
                  If UseCurrentAssessedValue
                    then Ratio := CurrentAssessedValue / TimeAdjSalePrice
                    else Ratio := FieldByName('AssessedValAtSale').AsFloat / TimeAdjSalePrice;
                except
                  Ratio := 0;
                end
              else Ratio := 0;

              {FXX07301998-4: Limit high ratios to 999.99.}

            TempNum := Roundoff(Ratio * 100, 3);

            If (TempNum > 999.99)
              then TempNum := 999.99;

            FieldByName('AV_SP_Ratio').AsFloat := TempNum;

              {CHG03212003-1(2.06q1): Option to display / extract SFLA.}
              {FXX08032003-1(2.07h): Check the sales inventory tables first.}

            If DisplaySFLA
              then
                begin
                  _Found := FindKeyOld(SalesResidentialBuildingTable, ['SwisSBLKey', 'SalesNumber'],
                                       [FieldByName('SwisCode').Text + FieldByName('SBLKey').Text,
                                        FieldByName('SalesNumber').Text]);

                  If _Found
                    then
                      try
                        FieldByName('SqFootLivingArea').AsInteger := SalesResidentialBuildingTable.FieldByName('SqFootLivingArea').AsInteger;
                      except
                        FieldByName('SqFootLivingArea').AsInteger := 0;
                      end;

                    {CHG10242005(2.9.3.7): Check the commercial inventory for the SFLA.}

                  If _Compare(FieldByName('SqFootLivingArea').AsInteger, 0, coEqual)
                    then
                      begin
                        _Found := FindKeyOld(SalesCommercialBuildingTable, ['SwisSBLKey', 'SalesNumber'],
                                             [FieldByName('SwisCode').Text + FieldByName('SBLKey').Text,
                                              FieldByName('SalesNumber').Text]);

                        If _Found
                          then
                            try
                              FieldByName('SqFootLivingArea').AsInteger := SalesCommercialBuildingTable.FieldByName('GrossFloorArea').AsInteger;
                            except
                              FieldByName('SqFootLivingArea').AsInteger := 0;
                            end;

                      end;  {If _Compare(FieldByName('SqFootLivingArea').AsInteger, 0, coEqual)}

                    {CHG12072003-1(2.07k1): If the SFLA is 0 coming out of the sales inventory,
                                            let's check the current inventory in case the sales
                                            occured before the SFLA was entered on the parcel.}

                  If ((not _Found) or
                      (FieldByName('SqFootLivingArea').AsInteger = 0))
                    then
                      begin
                        ResidentialBldgTable := FindTableInDataModuleForProcessingType(DataModuleResidentialBuildingTableName,
                                                                                       NextYear);

                        _Found := FindKeyOld(ResidentialBldgTable, ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                             [GlblNextYear, SwisSBLKey, '1']);

                        If _Found
                          then
                            try
                              FieldByName('SqFootLivingArea').AsInteger := ResidentialBldgTable.FieldByName('SqFootLivingArea').AsInteger;
                            except
                              FieldByName('SqFootLivingArea').AsInteger := 0;
                            end
                          else FieldByName('SqFootLivingArea').AsInteger := 0;

                      end;  {else of If _Found}

                    {Check the current commercial inventory.}

                  If ((not _Found) or
                      (FieldByName('SqFootLivingArea').AsInteger = 0))
                    then
                      begin
                        CommercialBldgTable := FindTableInDataModuleForProcessingType(DataModuleCommercialBuildingTableName,
                                                                                      NextYear);

                        _Found := (_Locate(CommercialBldgTable,
                                           [GlblNextYear, SwisSBLKey, '1', '1', '1'], '', [loPartialKey]) and
                                   _Compare(SwisSBLKey, CommercialBldgTable.FieldByName('SwisSBLKey').Text, coEqual));

                        If _Found
                          then
                            try
                              FieldByName('SqFootLivingArea').AsInteger := CommercialBldgTable.FieldByName('GrossFloorArea').AsInteger;
                            except
                              FieldByName('SqFootLivingArea').AsInteger := 0;
                            end
                          else FieldByName('SqFootLivingArea').AsInteger := 0;

                      end;  {else of If _Found}

                end
              else
                try
                  FieldByName('SqFootLivingArea').AsInteger := 0;
                except
                end;

            Post;
          except
            Quit := True;
            SystemSupport(001, SortTable, 'Error adding sort record.',
                          UnitName, GlblErrorDlgBox);
          end;  {try}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or Quit or ReportCancelled);

end;

{===============================================================}
Procedure TSalesAnalysisForm.FillSortFile(var Quit : Boolean);

{Go through all the sales records and find the ones that match and
 put them in the sort file.}

var
  Done, FirstTimeThrough, Cancelled : Boolean;
  Index : Integer;
  SwisSBLKey : String;

begin
  ProgressDialog.UserLabelCaption := 'Creating sort file.';

    {CHG04222003-2(2.07): Option to load from parcel list.}

  If LoadFromParcelList
    then
      begin
        Index := 1;
        ParcelListDialog.GetParcel(TYParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);

        Done := False;
        FirstTimeThrough := True;
        SwisSBLKey := ExtractSSKey(TYParcelTable);

        SetRangeOld(SalesTable, ['SwisSBLKey'], [SwisSBLKey], [SwisSBLKey]);

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else
              begin
                Index := Index + 1;
                ParcelListDialog.GetParcel(TYParcelTable, Index);
                SwisSBLKey := ExtractSSKey(TYParcelTable);
                SetRangeOld(SalesTable, ['SwisSBLKey'], [SwisSBLKey], [SwisSBLKey]);

              end;  {else of If FirstTimeThrough}

          If (Index > ParcelListDialog.NumItems)
            then Done := True;

          ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index));

          If not Done
            then FillSortFileForRange(SalesTable, False);

          Cancelled := ProgressDialog.Cancelled;

        until (Done or Cancelled);

      end
    else
      begin
        SalesTable.First;
        ProgressDialog.Start(GetRecordCount(SalesTable), True, True);

          {Note that in the normal case this is the whole file.}

        FillSortFileForRange(SalesTable, True);

      end;  {else of If LoadFromParcelList}

end;  {FillSortFile}

{====================================================================}
Procedure TSalesAnalysisForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'salesanl.sal', 'Sales Analysis Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TSalesAnalysisForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'salesanl.sal', 'Sales Analysis Report');

end;  {LoadButtonClick}

{===============================================================}
Procedure TSalesAnalysisForm.PrintButtonClick(Sender: TObject);

var
  Quit : Boolean;
  TextFileName, SortFileName, NewFileName : String;
  I, J : Integer;

begin
  LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
  Quit := False;
  ReportCancelled := False;
  DisplaySFLA := DisplaySFLACheckBox.Checked;
  ExcludeSalesForMoreThan1Parcel := ExcludeSalesOnMoreThan1ParcelCheckBox.Checked;

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  PrintButton.Enabled := False;
  Application.ProcessMessages;
  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If (ValidSelections and
      PrintDialog.Execute)
    then
      begin
          {FXX10071999-1: To solve the problem of printing to the high speed,
                          we need to set the font to a TrueType even though it
                          doesn't matter in the actual printing.  The reason for this
                          is that without setting it, the default font is System for
                          the Generic printer which has a baseline descent of 0.5
                          which messes up printing to a text file.  We needed a font
                          with no descent.}

        TextFiler.SetFont('Courier New', 10);

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

          {CHG03122007-1(MDT)[2.11.1.18]: Prompt for letter size print.}

        If (ReportPrinter.Orientation = poLandscape)
          then PromptForLetterSize(ReportPrinter, ReportFiler, 75, 78, 1.5);
        
        SelectedSwisCodes := TStringList.Create;
        SelectedSchoolCodes := TStringList.Create;
        SelectedPropertyClasses := TStringList.Create;
        SelectedNeighborhoodCodes := TStringList.Create;
        SelectedSections := TStringList.Create;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

        For I := 0 to (PropertyClassListBox.Items.Count - 1) do
          If PropertyClassListBox.Selected[I]
            then SelectedPropertyClasses.Add(Take(3, PropertyClassListBox.Items[I]));

        For I := 0 to (NeighborhoodCodeListBox.Items.Count - 1) do
          If NeighborhoodCodeListBox.Selected[I]
            then SelectedNeighborhoodCodes.Add(Take(5, NeighborhoodCodeListBox.Items[I]));

        ReportType := ReportTypeRadioGroup.ItemIndex;

        ReportGroupType := ReportGroupingRadioGroup.ItemIndex;

        PrintOrder := PrintOrderRadioGroup.ItemIndex;

        PrintAllSections := AllSectionsCheckBox.Checked;

        If not PrintAllSections
          then
            with SectionsStringGrid do
              For I := 0 to (ColCount - 1) do
                For J := 0 to (RowCount - 1) do
                  If (Deblank(Cells[I,J]) <> '')
                    then SelectedSections.Add(Trim(Cells[I,J]));

          {Figure out the date range that they want to see.}

        PrintAllDates := AllDatesCheckBox.Checked;
        PrintToEndOfDates := ToEndofDatesCheckBox.Checked;

        try
          If (StartDateEdit.Text <> '  /  /    ')
            then StartDate := StrToDate(StartDateEdit.Text);
        except
          StartDate := 0;
        end;

        try
          If (EndDateEdit.Text <> '  /  /    ')
            then EndDate := StrToDate(EndDateEdit.Text);
        except
          EndDate := 0;
        end;

          {Figure out the sales price range that they want to see.}

        PrintAllSalePrices := AllSalePricesCheckBox.Checked;
        PrintToEndOfSalePrices := ToEndofSalePricesCheckBox.Checked;

        try
          StartSalePrice := StrToInt(StartSalePriceEdit.Text);
        except
          StartSalePrice := 0;
        end;

        try
          EndSalePrice := StrToInt(EndSalePriceEdit.Text);
        except
          EndSalePrice := 0;
        end;

          {Figure out the AV range that they want to see.}

        PrintAllAVPrices := AllAVPricesCheckBox.Checked;
        PrintToEndOfAVPrices := ToEndofAVPricesCheckBox.Checked;

        try
          StartAVPrice := StrToInt(StartAVPriceEdit.Text);
        except
          StartAVPrice := 0;
        end;

        try
          EndAVPrice := StrToInt(EndAVPriceEdit.Text);
        except
          EndAVPrice := 0;
        end;

             {FXX05151998-1: Add AV/SP ratio range.}
             {FXX07301998-2: Need to do StrToFloat instead of StrToInt.}

          {Figure out the AV/SP range that they want to see.}

        PrintAllAV_SPRatios := AllAV_SPRatiosCheckBox.Checked;
        PrintToEndOfAV_SPRatios := ToEndofAV_SPRatiosCheckBox.Checked;

        try
          StartAV_SPRatio := StrToFloat(StartAV_SPRatioEdit.Text);
        except
          StartAV_SPRatio := 0;
        end;

        try
          EndAV_SPRatio := StrToFloat(EndAV_SPRatioEdit.Text);
        except
          EndAV_SPRatio := 0;
        end;

        UseCurrentAssessedValue := (AVTypeRadioGroup.ItemIndex = 0);

        PrintValidSalesOnly := ValidSaleCheckBox.Checked;
        PrintHistorySales := ShowHistorySalesCheckBox.Checked;
        PrintArmsLengthSalesOnly := ArmsLengthCheckBox.Checked;

          {04152003 - Inactivated the partial sales option since condition 'E' is never used.}

        ShowPartialSales := (*PartialSalesCheckBox.Checked;*)False;

        UseCurrentNeighborhoodCodes := (NeighborhoodCodeTypeRadioGroup.ItemIndex = 0);

          {CHG04032001-1: Allow for a selection of cooperatives and condos.}

        CooperativeType := CoopTypeRadioGroup.ItemIndex;
        CondominiumTypeFor210 := CondoTypeFor210RadioGroup.ItemIndex;
        CondominiumTypeFor411 := CondoTypeFor411RadioGroup.ItemIndex;

          {CHG02052005-1(2.8.3.5)[2005]: Add account number range.}

        PrintAllAccountNumbers := AllAccountNumbersCheckBox.Checked;
        PrintToEndOfAccountNumbers := ToEndOfAccountNumbersCheckBox.Checked;
        StartAccountNumber := StartAccountNumberEdit.Text;
        EndAccountNumber := EndAccountNumberEdit.Text;

          {CHG05212002-1: Allow print to Excel.}

        ExtractToExcel := cb_ExtractToExcel.Checked;

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

                {CHG03252007-1(2.11.1.22): Enable extract to Excel for subsequent sales report.}

              If _Compare(ReportType, rtSubsequent, coEqual)
                then WritelnCommaDelimitedLine(ExtractFile,
                                               ['Swis',
                                                'Parcel ID',
                                                'Nbhd',
                                                'Legal Addr',
                                                'School',
                                                'Sale 1 Date',
                                                'Sale 1 Price',
                                                'Sale 1 Class',
                                                'Sale 2 Date',
                                                'Sale 2 Price',
                                                'Sale 2 Class',
                                                'Months Diff',
                                                'Monthly % Change',
                                                'Annual % Change'])
                else
                  begin
                    Write(ExtractFile,
                          '"Swis",', '"Parcel ID",',
                          '"Current Owner",', '"Legal Address",',
                          '"Sale #",', '"Sale Date",',
                          '"Prop Class",', '"Ownership",',
                          '"Arms Length",', '"Conditions",',
                          '"Valid",', '"Sale Price",',
                          '"AV at Sale",', '"Current AV",',
                          '"AV/SP Ratio",', '"Diff from Mean",',
                          '"Acres",', '"Frontage",', '"Depth",',
                          '"Nbhd Code",', '"Acct #",',
                          '"Sale Ctl #",', '"Prior Owner"');

                      {CHG03212003-1(2.06q1): Option to display / extract SFLA.}
                      {CHG04152003-1(2.07): Display Sales price per square foot and
                                            assessment per square foot.}

                    If DisplaySFLA
                      then Writeln(ExtractFile, ',"SFLA","Price/Foot","AV/Foot"')
                      else Writeln(ExtractFile);

                  end;  {else of If _Compare(ReportType, rtSubsequent, coEqual)}

            end;  {If ExtractToExcel}

          {Copy the sort table.}

           {FXX12011997-1: Name the sort files with the date and time and
                           extension of .SRT.}

        CopyAndOpenSortFile(SortTable, 'SalesAnalysis',
                            OrigSortFileName, SortFileName,
                            True, True, Quit);

        with SortTable do
          case ReportGroupType of
            goSwisCode,
            goNone : IndexName := 'BYSWISCODE';
            goPropertyClass : IndexName := 'BYPROPERTYCLASS';
            goNeighborhoodCode : IndexName := 'BYNEIGHBORHOODCODE';
            goSection : IndexName := 'BYSECTION';
            goSchoolCode : IndexName := 'BYSCHOOLCODE';

          end;  {with SortTable do}

        If (ReportType = rtSubsequent)
          then SortTable.IndexName := 'BYSWISSBLKEY';

        FillSortFile(Quit);

          {Now print the report.}

        If not (Quit or ReportCancelled)
          then
            begin
              ProgressDialog.UserLabelCaption := 'Printing report.';
              GlblPreviewPrint := False;

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
                {FXX07221998-1: So that more than one person can run the report
                                at once, use a time based name first and then
                                rename.}

              TextFileName := GetPrintFileName(Self.Caption, True);
              TextFiler.FileName := TextFileName;

                {FXX01211998-1: Need to set the LastPage property so that
                                long rolls aren't a problem.}

              TextFiler.LastPage := 30000;

              TextFiler.Execute;

                {If they want to see it on the screen, start the preview.}

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

                      ReportFiler.Execute;
                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;
                    end;

                      {Delete the temporary report filer file.}

                    try
                      Chdir(GlblReportDir);
                      OldDeleteFile(NewFileName);
                    except
                    end;

                  end
                else ReportPrinter.Execute;

               {CHG01182000-3: Allow them to choose a different name or copy right away.}

              ShowReportDialog('SALESANL.RPT', TextFiler.FileName, True);
              ResetPrinter(ReportPrinter);

            end;  {If not Quit}

          {Make sure to close and delete the sort file.}

        SortTable.Close;

        ProgressDialog.Finish;

          {Now delete the file.}
        try
          ChDir(GlblDataDir);
          OldDeleteFile(SortFileName);
        finally
          {We don't care if it does not get deleted, so we won't put up an
           error message.}

          ChDir(GlblProgramDir);
        end;

        SelectedSwisCodes.Free;
        SelectedSchoolCodes.Free;
        SelectedPropertyClasses.Free;
        SelectedNeighborhoodCodes.Free;
        SelectedSections.Free;

          {CHG05212002-1: Allow print to Excel.}

        If ExtractToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

                {If we created a temporary file to send to Excel, delete it.}

              try
                Chdir(GlblReportDir);
                OldDeleteFile(SpreadsheetFileName);
              except
              end;

            end;  {ExtractToExcel}

      end;  {If PrintDialog.Execute}

  PrintButton.Enabled := True;

end;  {PrintButtonClick}

{====================================================================}
Function TSalesAnalysisForm.DetermineKey(DetailedSaleRec : DetailedSaleRecord) : String;

{Assemble a print order key from a group record.}

var
  TempStr : String;

begin
    {FXX01131999-1: Add key by legal addr name.}

  with DetailedSaleRec do
    case PrintOrder of
      poParcelID : Result := Take(6, SwisCode) + Take(20, SBLKey) +
                             IntToStr(SalesNumber);
      poLegalAddrNumber : Result := Take(10, ShiftRightAddZeroes(LegalAddrNo)) + Take(30, LegalAddr) +
                                    IntToStr(SalesNumber);
      poLegalAddrName : Result := Take(30, LegalAddr) + Take(10, ShiftRightAddZeroes(LegalAddrNo)) +
                                   IntToStr(SalesNumber);
      poSaleDate : Result := MakeYYYYMMDD(MakeMMDDYYYYFromDateTime(SaleDate)) +
                             IntToStr(SalesNumber);

        {FXX04081998-6: Sort for sales price and AV_SP ratio not working.}

      poSalePrice : begin
                      TempStr := FormatFloat(CurrencyEditDisplay,
                                             AdjustedSalesPrice);

                      Result := ShiftRightAddZeroes(Take(12, TempStr));

                    end;  {poSalePrice}

      poAV_SP_Ratio : begin
                        TempStr := FormatFloat(DecimalDisplay, AV_SP_Ratio);

                        Result := ShiftRightAddZeroes(Take(12, TempStr));

                          {In order to make positives colate after negatives,
                           we will make the first char of positives 'Z'.}

                        If (AV_SP_Ratio > 0)
                          then Result[1] := 'Z';

                      end;  {poAV_SP_Ratio}

    end;  {case PrintOrder of}

end;  {DetermineKey}

(*{========================================================================================}
Procedure Swap(List : TList;
               I, J : Integer);

var
  TempPtr : Pointer;

begin
  TempPtr := List[I];
  List[I] := List[J];
  List[J] := TempPtr;
end;  {Swap}

{========================================================================================}
Function TSalesAnalysisForm.Compare(Item1,
                                    Item2 : PDetailedSaleRecord;
                                    ComparisonType : Integer) : Boolean;

var
  Item1Key, Item2Key : String;

begin
  Result := False;
  Item1Key := DetermineKey(PDetailedSaleRecord(Item1)^);
  Item2Key := DetermineKey(PDetailedSaleRecord(Item2)^);

  case ComparisonType of
    LessThan : Result := (Item1Key < Item2Key);
    GreaterThan : Result := (Item1Key > Item2Key);
  end;

end;  {Compare}

{========================================================================================}
Procedure TSalesAnalysisForm.Quicksort(List : TList;
                                       LeftIndex,
                                       RightIndex : Integer);

const
  Mid = 4;

var
  I, J : Integer;
  TempPtr : PDetailedSaleRecord;

begin
  If ((RightIndex - 1) > Mid)
    then
      begin
        I := (RightIndex + 1) DIV 2;

        If Compare(List[1], List[I], GreaterThan)
          then Swap(List, 1, I);

        If Compare(List[1], List[RightIndex], GreaterThan)
          then Swap(List, 1, RightIndex);

        If Compare(List[I], List[RightIndex], GreaterThan)
          then Swap(List, I, RightIndex);

        J := RightIndex - 1;
        Swap(List, I, J);

        I := 1;
        TempPtr := List[J];

        while (Compare(List[I], TempPtr, LessThan) and
               Compare(List[J], TempPtr, GreaterThan) and
               (J >= I)) do
          begin
            Swap(List, I, J);
            I := I + 1;
            J := J - 1;
          end;

        Swap(List, I, (RightIndex - 1));
        Quicksort(List, 1, J);
        Quicksort(List, (I + 1), RightIndex);

      end;  {If ((RightIndex - 1) > Mid)}

end;  {Quicksort}

{===================================================================}
Procedure TSalesAnalysisForm.SortListForPrintOrder(GroupList : TList);

{Sort this group into the order that they want to see the group in.}
{Quicksort}

begin
  Quicksort(GroupList, 0 , GroupList.Count - 1);

end;  {SortListForPrintOrder} *)

{===================================================================}
Procedure TSalesAnalysisForm.SortListForPrintOrder(GroupList : TList);

{Sort this group into the order that they want to see the group in.}
{Bubble sort}

var
  I, J : Integer;
  OldKey, NewKey : String;
  TempPtr : Pointer;

begin
  For I := 0 to (GroupList.Count - 1) do
    begin
        {First determine the key string of the ith element.}

      OldKey := DetermineKey(PDetailedSaleRecord(GroupList[I])^);


      For J := (I + 1) to (GroupList.Count - 1) do
        begin
            {Now determine the key string of this element.}

          NewKey := DetermineKey(PDetailedSaleRecord(GroupList[J])^);

          If (NewKey < OldKey)
            then
              begin
                TempPtr := GroupList[I];
                GroupList[I] := GroupList[J];
                GroupList[J] := TempPtr;

                OldKey := NewKey;

              end;  {If (NewKey < OldKey)}

        end;  {For J := (I + 1) to (GroupList.Count - 1) do}

    end;  {For I := 0 to (GroupList.Count - 1) do}

end;  {SortListForPrintOrder}

{===================================================================}
Procedure TSalesAnalysisForm.PrintOneParcel(Sender : TObject;
                                            DetailedSaleRec : DetailedSaleRecord;
                                            Median_AV_SP_Ratio : Real);

{Print one individual parcel for the detailed report.}

var
  TempStr, TempLegalAddress : String;
  TempDifference : Real;

begin
  with Sender as TBaseReport, DetailedSaleRec do
    begin
      If (LinesLeft < LinesLeftAtBottom)
        then NewPage;

      Println('');
      TempDifference := AV_SP_Ratio - Median_AV_SP_Ratio;
      TempLegalAddress := Trim(LegalAddrNo) + ' ' + LTrim(LegalAddr);

        {CHG05212002-1: Allow print to Excel.}

      If ExtractToExcel
        then
          begin
            Write(ExtractFile,
                     '"' + SwisCode + '"',
                     FormatExtractField('"' + ConvertSBLOnlyToDashDot(SBLKey) + '"'),
                     FormatExtractField(CurrentOwner),
                     FormatExtractField(TempLegalAddress),
                     FormatExtractField(IntToStr(SalesNumber)),
                     FormatExtractField(DateToStr(SaleDate)),
                     FormatExtractField(PropertyClassCode),
                     FormatExtractField(OwnershipCode),
                     FormatExtractField(BoolToChar(ArmsLength)),
                     FormatExtractField(SaleCondition),
                     FormatExtractField(BoolToChar(ValidSale)),
                     FormatExtractField(FormatFloat(CurrencyEditDisplay, SalePrice)),
                     FormatExtractField(FormatFloat(CurrencyEditDisplay, AssessedValueAtTimeOfSale)),
                     FormatExtractField(FormatFloat(CurrencyEditDisplay, CurrentAssessedValue)),
                     FormatExtractField(FormatFloat(DecimalEditDisplay, AV_SP_Ratio)),
                     FormatExtractField(FormatFloat(DecimalEditDisplay, TempDifference)),
                     FormatExtractField(FormatFloat(DecimalEditDisplay, Acreage)),
                     FormatExtractField(FormatFloat(DecimalEditDisplay, Frontage)),
                     FormatExtractField(FormatFloat(DecimalEditDisplay, Depth)),
                     FormatExtractField(NeighborhoodCode),
                     FormatExtractField('"' + AccountNumber + '"'),
                     FormatExtractField(SaleControlNumber),
                     FormatExtractField(PriorOwner));

              {CHG03212003-1(2.06q1): Option to display / extract SFLA.}
              {CHG04152003-1(2.07): Display Sales price per square foot and
                                    assessment per square foot.}

            If DisplaySFLA
              then Writeln(ExtractFile, FormatExtractField(FormatFloat(IntegerDisplay, SqFootLivingArea)),
                                        FormatExtractField(FormatFloat(DecimalEditDisplay, SP_SFLA_Ratio)),
                                        FormatExtractField(FormatFloat(DecimalEditDisplay, AV_SFLA_Ratio)))
              else Writeln(ExtractFile);

          end;  {If ExtractToExcel}

      Print(#9 + Copy(SwisCode, 5, 2) + '/' +
                 ConvertSBLOnlyToDashDot(SBLKey) +
            #9 + Take(2, IntToStr(SalesNumber)) + '  ');

      If (Roundoff(Acreage, 2) > 0)
        then TempStr := FormatFloat(DecimalDisplay, Acreage) + ' AC'
        else TempStr := FormatFloat(DecimalDisplay, Frontage) + ' FR' + '   ' +
                        FormatFloat(DecimalDisplay, Depth) + ' DP';

      Print(ShiftRightAddBlanks(Take(27, TempStr)) +
            #9 + PropertyClassCode);

        {FXX04042001-2: Print the ownership code if it is there.}

      If (Deblank(OwnershipCode) <> '')
        then Print(OwnershipCode);

      If PropertyClassDifferent
        then Print('*');

      Print(#9 + DateTimeToMMDDYYYY(SaleDate) +
            #9 + FormatFloat(NoDecimalDisplay_BlankZero, SalePrice) +
            #9 + FormatFloat(NoDecimalDisplay_BlankZero, AssessedValueAtTimeOfSale) +
            #9 + FormatFloat(NoDecimalDisplay_BlankZero, CurrentAssessedValue) +
            #9 + FormatFloat(NoDecimalDisplay_BlankZero, AdjustedSalesPrice) +
            #9 + FormatFloat(DecimalDisplay, AV_SP_Ratio));

      Println(#9 + FormatFloat(DecimalDisplay, TempDifference));

        {Second line}

        {Address}

      Print(#9 + Take(22, TempLegalAddress));

        {Neighborhood code, acct #, ctl #, Arms length indicator}
        {FXX04081998-4: Had a semicolon instead of a '+' in front of
                        arms length.}

      TempStr := Take(5, NeighborhoodCode) + ' ' +
                 Take(11, AccountNumber) + ' ' +
                 Take(8, SaleControlNumber) + ' ' +
                 BoolToChar(ArmsLength);
      TempStr := Take(28, TempStr);

     Print(#9 + TempStr +
           #9 + SaleCondition +
           #9 + Center(BoolToChar(ValidSale), 10));

       {CHG03212003-1(2.06q1): Option to display / extract SFLA.}
       {CHG04152003-1(2.07): Display Sales price per square foot and
                             assessment per square foot.}

     If DisplaySFLA
       then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, SqFootLivingArea) +
                    #9 + FormatFloat(DecimalEditDisplay_BlankZero, SP_SFLA_Ratio) +
                    #9 + FormatFloat(DecimalEditDisplay_BlankZero, AV_SFLA_Ratio))
       else Println('');

        {Now show the owners if they want to see it.}

      If (ReportType <> rtDetailedNoOwner)
        then Println(#9 + Take(22, CurrentOwner) +
                     #9 + PriorOwner);

    end;  {with Sender as TBaseReport, DetailedSaleRec do}

end;  {PrintOneParcel}

{===================================================================}
Procedure PrintGroupTotals(Sender : TObject;
                           GroupHeader : String;
                           GrandTotal : Boolean;
                           SalesPriceList,
                           AV_SP_RatioList : TStringList);

{Print the totals for one group.}

var
  Mean, Median, COD : Double;

begin
  with Sender as TBaseReport do
    begin
      If (LinesLeft < (LinesLeftAtBottom + 6))
        then NewPage;

      Println('');

      ClearTabs;
      SetTab(1.0, pjLeft, 7.0, 0, BOXLINENone, 0);

      Println(#9 + GroupHeader);

      ClearTabs;
      SetTab(1.5, pjLeft, 2.5, 0, BOXLINENone, 0);
      SetTab(4.2, pjRight, 1.2, 0, BOXLINENone, 0);

      Println('');
      Println(#9 + 'Number of Sales = ' +
              #9 + IntToStr(SalesPriceList.Count));

      If (SalesPriceList.Count > 0)
        then
          begin
            Println('');

            SortListAndGetStats(SalesPriceList, Median, Mean, COD);

            Println(#9 + 'Minimum Sale Price = ' +
                    #9 + FormatFloat(CurrencyNormalDisplay,
                                     StrToFloat(SalesPriceList[0])));

            Println('');
            Println(#9 + 'Maximum Sale Price = ' +
                    #9 + FormatFloat(CurrencyNormalDisplay,
                                     StrToFloat(SalesPriceList[SalesPriceList.Count - 1])));

            Println('');
            Println(#9 + 'Mean Sale Price = ' +
                    #9 + FormatFloat(CurrencyNormalDisplay, Mean));

              {CHG04152003-2(2.07): Include median sales price and mean AV/SP ratio.}

            Println('');
            Println(#9 + 'Median Sale Price = ' +
                    #9 + FormatFloat(CurrencyNormalDisplay, Median));

            SortListAndGetStats(AV_SP_RatioList, Median, Mean, COD);

            Println('');
            Println(#9 + 'Mean AV/SP Ratio = ' +
                    #9 + FormatFloat(_3DecimalEditDisplay, Mean));

            Println('');
            Println(#9 + 'Median AV/SP Ratio = ' +
                    #9 + FormatFloat(_3DecimalEditDisplay, Median));

            Println('');
            Println(#9 + 'Coefficient of Dispersion = ' +
                    #9 + FormatFloat(_3DecimalEditDisplay, COD));

          end;  {If (SalesPriceList.Count > 0)}

    end;  {with Sender as TBaseReport do}

end;  {PrintGroupTotals}

{===================================================================}
Procedure TSalesAnalysisForm.PrintGroup(Sender : TObject;
                                        GroupList : TList;
                                        OverallSalesPriceList,
                                        OverallAV_SP_RatioList : TStringList);

{Print all the parcels for a group including the totals.}

var
  SalesPriceList,
  AV_SP_RatioList : TStringList;
  I : Integer;
  Median_AV_SP_Ratio, Mean, COD : Double;
  TempStr : String;

begin
  SalesPriceList := TStringList.Create;
  AV_SP_RatioList := TStringList.Create;

  If (ReportType <> rtTotalsOnly)
    then SortListForPrintOrder(GroupList);

    {Fill in the sales price and AV_SP ratio lists for this group.}

  For I := 0 to (GroupList.Count - 1) do
    begin
      SalesPriceList.Add(FloatToStr(PDetailedSaleRecord(GroupList[I])^.SalePrice));
      AV_SP_RatioList.Add(FloatToStr(PDetailedSaleRecord(GroupList[I])^.AV_SP_Ratio));
    end;  {For I := 0 to (GroupList.Count - 1) do}

  SortListAndGetStats(AV_SP_RatioList, Median_AV_SP_Ratio, Mean, COD);

  MedianAV_SP_RatioThisGroup := Median_AV_SP_Ratio;

    {Go to a new page now so that we can set the median for the group first
     and it will appear in the header.}

  with Sender as TBaseReport do
    NewPage;

    {Now if they want to see the parcels, print them.}

  If (ReportType <> rtTotalsOnly)
    then
      For I := 0 to (GroupList.Count - 1) do
        PrintOneParcel(Sender, PDetailedSaleRecord(GroupList[I])^,
                       Median_AV_SP_Ratio);

    {Print the totals for this group.}

  TempStr := '>>>>> Totals for';

  case ReportGroupType of
    goSwisCode : TempStr := Tempstr +
                 ' Swis Code ' + CurrentSwisCode + ' (' +
                 LTrim(CurrentSwisCodeName) + ')';
    goSection : TempStr := TempStr +
                           ' Section ' + DezeroOnLeft(CurrentSection);
    goSchoolCode : TempStr := TempStr +
                              ' School Code ' + CurrentSchoolCode + ' (' +
                              LTrim(CurrentSchoolCodeName) + ')';
    goNeighborhoodCode : TempStr := TempStr +
                                    ' Neighborhood ' + DezeroOnLeft(CurrentNeighborhoodCode);

      {FXX04081998-5: Show property class name in parentheses.}

    goPropertyClass : TempStr := TempStr +
                                 ' Property Class ' + CurrentPropertyClass +
                                 ' (' + LTrim(CurrentPropertyClassName) + ')';

      {CHG04032001-2: Allow for no group.}

    goNone : TempStr := TempStr + ' All Parcels';

  end;  {case ReportGroupType of}

  TempStr := TempStr + ' <<<<<';

  PrintGroupTotals(Sender, TempStr, False, SalesPriceList, AV_SP_RatioList);

    {Now add all the sales prices and ratios to the overall totals lists.}

  For I := 0 to (SalesPriceList.Count - 1) do
    OverallSalesPriceList.Add(SalesPriceList[I]);

  For I := 0 to (AV_SP_RatioList.Count - 1) do
    OverallAV_SP_RatioList.Add(AV_SP_RatioList[I]);

  SalesPriceList.Free;
  AV_SP_RatioList.Free;

    {Clear the group list.}

  ClearTList(GroupList, SizeOf(DetailedSaleRecord));

end;  {PrintGroup}

{===================================================================}
Procedure AddParcelToGroup(GroupList : TList;
                           SortTable : TTable;
                           DisplaySFLA : Boolean;
                           UseCurrentAssessedValue : Boolean);

{Add one parcel to the group list.}

var
  PDetailedSaleRec : PDetailedSaleRecord;

begin
  New(PDetailedSaleRec);

  with SortTable, PDetailedSaleRec^ do
    begin
      SwisCode := FieldByName('SwisCode').Text;
      SBLKey := FieldByName('SBLKey').Text;
      Section := FieldByName('Section').Text;
      SalesNumber := FieldByName('SalesNumber').AsInteger;
      SchoolCode := FieldByName('SchoolCode').Text;
      LegalAddrNo := FieldByName('LegalAddrNo').Text;
      LegalAddr := FieldByName('LegalAddr').Text;
      CurrentOwner := FieldByName('CurrentOwner').Text;
      PriorOwner := FieldByName('PriorOwner').Text;
      NeighborhoodCode := FieldByName('NeighborhoodCode').Text;
      Frontage := FieldByName('Frontage').AsFloat;
      Depth := FieldByName('Depth').AsFloat;
      Acreage := FieldByName('Acreage').AsFloat;
      AccountNumber := FieldByName('AccountNumber').Text;
      SaleControlNumber := FieldByName('SaleControlNumber').Text;
      ArmsLength := FieldByName('ArmsLength').AsBoolean;
      SaleCondition := FieldByName('SaleCondition').Text;
      PropertyClassCode := FieldByName('PropertyClass').Text;
      PropertyClassDifferent := FieldByName('PropertyClassDiff').AsBoolean;
      SaleDate := FieldByName('SaleDate').AsDateTime;
      ValidSale := FieldByName('ValidSale').AsBoolean;
      SalePrice := FieldByName('SalePrice').AsFloat;
      CurrentAssessedValue := FieldByName('CurrentAssessedValue').AsFloat;
      AssessedValueAtTimeOfSale := FieldByName('AssessedValAtSale').AsFloat;
      AdjustedSalesPrice := FieldByName('AdjustedSalesPrice').AsFloat;
      AV_SP_Ratio := FieldByName('AV_SP_Ratio').AsFloat;
      OwnershipCode := FieldByName('OwnershipCode').Text;

         {CHG03212003-1(2.06q1): Option to display / extract SFLA.}
         {CHG04152003-1(2.07): Display Sales price per square foot and
                               assessment per square foot.}

      If DisplaySFLA
        then
          begin
            try
              SqFootLivingArea := FieldByName('SqFootLivingArea').AsInteger;
            except
              SqFootLivingArea := 0;
            end;

            try
              SP_SFLA_Ratio := SalePrice / SqFootLivingArea;
            except
              SP_SFLA_Ratio := 0;
            end;

            try
              If UseCurrentAssessedValue
                then AV_SFLA_Ratio := CurrentAssessedValue / SqFootLivingArea
                else AV_SFLA_Ratio := AssessedValueAtTimeOfSale / SqFootLivingArea;
            except
              AV_SFLA_Ratio := 0;
            end;

          end;  {If DisplaySFLA}

    end;  {with SortTable, PDetailedSaleRec^ do}

  GroupList.Add(PDetailedSaleRec);

end;  {AddParcelToGroup}

{===================================================================}
Procedure TSalesAnalysisForm.TextFilerPrintHeader(Sender: TObject);

var
  TempStr, TempStr1, TempStr2 : String;

begin
  with Sender as TBaseReport do
    begin
        {CHG04192001-1: Subsequent sales analysis.}

      If (ReportType = rtSubsequent)
        then
          begin
            TempStr := 'DATE: ' + DateToStr(Date) + '  TIME: ' + TimeToStr(Now);
            Println(TempStr +
                    ShiftRightAddBlanks(Take((130 - Length(TempStr)), 'PAGE: ' + IntToStr(CurrentPage))));

            TempStr := 'County of ' + Trim(GlblCountyName);
            Println(UpcaseStr(TempStr) +
                    Center('SUBSEQUENT SALES ANALYSIS REPORT', (130 - 2 * Length(TempStr))));
            Println(UpcaseStr(GetMunicipalityName));

            Println('');

            ClearTabs;
            SetTab(5.6, pjLeft, 1.5, 0, BOXLINENone, 0);   {Class sale 1}
            SetTab(7.4, pjLeft, 1.5, 0, BOXLINENone, 0);   {Class sale 2}
            SetTab(10.3, pjCenter, 1.5, 0, BOXLINENone, 0);   {Percent per month}

            Println(#9 + '**** SALE 1 ****' +
                    #9 + '**** SALE 2 ****' +
                    #9 + 'PERCENT CHANGE');

            ClearTabs;
            SetTab(0.1, pjCenter, 2.3, 0, BOXLINENone, 0);   {SBL}
            SetTab(2.4, pjCenter, 0.5, 0, BOXLINENone, 0);   {Nbhd}
            SetTab(3.0, pjCenter, 2.5, 0, BOXLINENone, 0);   {Location/School}
            SetTab(5.6, pjLeft, 0.5, 0, BOXLINENone, 0);   {Class sale 1}
            SetTab(6.2, pjRight, 1.1, 0, BOXLINENone, 0);   {Date / Price sale 1}
            SetTab(7.5, pjLeft, 0.3, 0, BOXLINENone, 0);   {Class sale 2}
            SetTab(7.9, pjRight, 1.1, 0, BOXLINENone, 0);   {Date / Print sale 2}
            SetTab(9.2, pjLeft, 1.0, 0, BOXLINENone, 0);   {# months / dollar change}
            SetTab(10.3, pjLeft, 0.7, 0, BOXLINENone, 0);   {Percent per month}
            SetTab(11.1, pjLeft, 0.7, 0, BOXLINENone, 0);   {Percent per year}

            Println(#9 + 'PARCEL ID' +
                    #9 + 'NBHD' +
                    #9 + 'LOCATION' +
                    #9 + 'CLASS' +
                    #9 + 'DATE' +
                    #9 + 'CLASS' +
                    #9 + 'DATE' +
                    #9 + '# MONTHS' +
                    #9 + 'PER' +
                    #9 + 'PER');

            Println(#9 + #9 + #9 + 'SCHOOL CODE' +
                    #9 + #9 + 'PRICE' +
                    #9 + #9 + 'PRICE' +
                    #9 + '$ CHANGE' +
                    #9 + 'MONTH' +
                    #9 + 'YEAR');

            ClearTabs;
            SetTab(0.1, pjLeft, 2.3, 0, BOXLINENone, 0);   {SBL}
            SetTab(2.4, pjLeft, 0.5, 0, BOXLINENone, 0);   {Nbhd}
            SetTab(3.0, pjLeft, 2.5, 0, BOXLINENone, 0);   {Location/School}
            SetTab(5.6, pjLeft, 0.5, 0, BOXLINENone, 0);   {Class sale 1}
            SetTab(6.2, pjRight, 1.1, 0, BOXLINENone, 0);   {Date / Price sale 1}
            SetTab(7.5, pjLeft, 0.3, 0, BOXLINENone, 0);   {Class sale 2}
            SetTab(7.9, pjRight, 1.1, 0, BOXLINENone, 0);   {Date / Print sale 2}
            SetTab(9.2, pjRight, 1.0, 0, BOXLINENone, 0);   {# months / dollar change}
            SetTab(10.3, pjRight, 0.7, 0, BOXLINENone, 0);   {Percent per month}
            SetTab(11.1, pjRight, 0.7, 0, BOXLINENone, 0);   {Percent per year}

            Println('');

          end
        else
          begin
            ClearTabs;
            SetTab(0.1, pjLeft, 4.3, 0, BOXLINENone, 0);   {Column 1}
            SetTab(4.4, pjCenter, 4.3, 0, BOXLINENone, 0);   {Column 1}
            SetTab(8.7, pjRight, 4.3, 0, BOXLINENone, 0);   {Column 3}

            TempStr := 'DATE: ' + DateToStr(Date) + '  TIME: ' + TimeToStr(Now);
            Println(#9 + TempStr +
                    #9 + 'SALES ANALYSIS REPORT' +
                    #9 + 'PAGE: ' + IntToStr(CurrentPage));

            ClearTabs;
            SetTab(0.1, pjLeft, 5.0, 0, BOXLINENone, 0);   {SBL}
            SetTab(8.0, pjRight, 5.0, 0, BOXLINENone, 0);   {Nbhd}

            TempStr := 'County of ' + Trim(GlblCountyName);

            TempStr2 := 'Sales for';

            case ReportGroupType of
              goSwisCode : TempStr2 := TempStr2 +
                           ' Swis Code ' + CurrentSwisCode + ' (' +
                           LTrim(CurrentSwisCodeName) + ')';
              goSection : TempStr2 := TempStr2 +
                                     ' Section ' + DezeroOnLeft(CurrentSection);
              goSchoolCode : TempStr2 := TempStr2 +
                                        ' School Code ' + CurrentSchoolCode + ' (' +
                                        LTrim(CurrentSchoolCodeName) + ')';
              goNeighborhoodCode : TempStr2 := TempStr2 +
                                              ' Neighborhood ' +
                                              DezeroOnLeft(CurrentNeighborhoodCode);

                {FXX04081998-5: Show property class name in parentheses.}

              goPropertyClass : TempStr2 := TempStr2 +
                                           ' Property Class ' + CurrentPropertyClass +
                                           ' (' + LTrim(CurrentPropertyClassName) + ')';

                {CHG04032001-2: Allow for no group.}

              goNone : TempStr2 := TempStr2 + ' All Parcels';

            end;  {case ReportGroupType of}

            Println(#9 + UpcaseStr(TempStr) +
                    #9 + TempStr2);

            TempStr1 := Trim(UpcaseStr(GetMunicipalityName));
            case PrintOrder of
              poParcelID : TempStr2 := 'In Parcel ID Order';
              poLegalAddrNumber : TempStr2 := 'In Legal Address Number Order';
              poLegalAddrName : TempStr2 := 'In Legal Address Name Order';
              poSaleDate : TempStr2 := 'In Sale Date Order';
              poSalePrice : TempStr2 := 'In Sale Price Order';
              poAV_SP_Ratio : TempStr2 := 'In AV/SP Ratio Order';

            end;  {case PrintOrder of}

            Println(#9 + TempStr1 +
                    #9 + TempStr2);

              {CHG04222003-3(2.07): Add more header info.}

            TempStr := 'For Sale Prices:';
            If PrintAllSalePrices
              then Print(#9 + TempStr + ' All')
              else
                begin
                  TempStr := TempStr + FormatFloat(CurrencyNormalDisplay, StartSalePrice) +
                             ' to ';

                  If PrintToEndOfSalePrices
                    then Print(#9 + TempStr + 'Last Sale Price.')
                    else Print(#9 + TempStr + FormatFloat(CurrencyNormalDisplay, EndSalePrice) + '.');

                end;  {If PrintAllSalesPrices}

            TempStr := 'For Assessed Values: ';
            If PrintAllAVPrices
              then Println(#9 + TempStr + 'All')
              else
                begin
                  TempStr := TempStr + FormatFloat(CurrencyNormalDisplay, StartAVPrice) +
                             ' to ';

                  If PrintToEndOfAVPrices
                    then Println(#9 + TempStr + 'Last Assessed Value.')
                    else Println(#9 + TempStr + FormatFloat(CurrencyNormalDisplay, EndAVPrice) + '.');

                end;  {If PrintAllAVsPrices}

            TempStr := 'For Sale Dates: ';
            If PrintAllDates
              then Print(#9 + TempStr + 'All')
              else
                begin
                  TempStr := TempStr + DateTimetoMMDDYYYY(StartDate) + ' to ';

                  If PrintToEndOfDates
                    then Print(#9 + TempStr + 'Last Sale Date.')
                    else Print(#9 + TempStr + DateTimetoMMDDYYYY(EndDate) + '.');

                end;  {If PrintAllAVsPrices}

            TempStr := 'For Assessment \ Price Ratios: ';
            If PrintAllAV_SPRatios
              then Println(#9 + TempStr + 'All')
              else
                begin
                  TempStr := TempStr + FormatFloat(_3DecimalEditDisplay, StartAV_SPRatio) +
                             ' to ';

                  If PrintToEndOfAV_SPRatios
                    then Println(#9 + TempStr + 'Last Ratio.')
                    else Println(#9 + TempStr + FormatFloat(_3DecimalEditDisplay, EndAV_SPRatio) + '.');

                end;  {If PrintAllAVsPrices}

            TempStr := 'Median AV/SP Ratio = ' +
                       FormatFloat(_3DecimalEditDisplay, MedianAV_SP_RatioThisGroup);

            If UseCurrentAssessedValue
              then TempStr := TempStr + ' \  Using Current Assessed Value'
              else TempStr := TempStr + ' \  Using Assessed Value at Sale';

            Println(Center(TempStr, 130));

            If SalePricesHaveBeenAdjusted
              then Println(Center('The Sales Prices Have Been Time Adjusted.', 130));

            Println('');

            If (ReportType in [rtDetailed, rtDetailedNoOwner])
              then
                begin
                  ClearTabs;
                  SetTab(0.1, pjLeft, 2.3, 0, BOXLINENone, 0);   {SBL}
                  SetTab(2.4, pjLeft, 3.2, 0, BOXLINENone, 0);   {Prop dimen, etc.}
                  SetTab(5.7, pjLeft, 0.5, 0, BOXLINENone, 0);   {Class/Cond}
                  SetTab(6.2, pjLeft, 1.0, 0, BOXLINENone, 0);   {Sale Date}
                  SetTab(7.3, pjRight, 1.1, 0, BOXLINENone, 0);   {Sale Price}
                  SetTab(8.5, pjRight, 1.1, 0, BOXLINENone, 0);   {AV at sale}
                  SetTab(9.7, pjRight, 1.1, 0, BOXLINENone, 0);   {Current AV}
                  SetTab(10.9, pjRight, 1.0, 0, BOXLINENone, 0);   {Adj price}
                  SetTab(12.1, pjRight, 0.5, 0, BOXLINENone, 0);   {Ratio}
                  SetTab(12.7, pjRight, 0.5, 0, BOXLINENone, 0);   {Difference}

                  Println(#9 + 'PARCEL ID' +
                          #9 + 'SALE #     PARCEL DIMENSIONS' +
                          #9 + 'CLS' +
                          #9 + 'SALE DATE' +
                          #9 + 'SALE PRICE' +
                          #9 + 'AV AT SALE' +
                          #9 + 'CURRENT AV' +
                          #9 + 'ADJ PRICE' +
                          #9 + 'RATIO' +
                          #9 + 'DIFF');

                  Print(#9 + 'LEGAL ADDRESS' +
                        #9 + 'NBHD    ACCT #    CTL #     A/L' +
                        #9 + 'COND' +
                        #9 + 'VALID');

                    {CHG03212003-1(2.06q1): Option to display / extract SFLA.}
                   {CHG04152003-1(2.07): Display Sales price per square foot and
                                         assessment per square foot.}

                  If DisplaySFLA
                    then Println(#9 + 'SFLA' +
                                 #9 + 'SP\SFLA' +
                                 #9 + 'AV\SFLA')
                    else Println('');

                  If (ReportType <> rtDetailedNoOwner)
                    then Println(#9 + 'BUYER' +
                                 #9 + 'SELLER');

                end;  {If (ReportType in [rtDetailed, rtDetailedNoOwner])}

          end;  {else of If (ReportType = rtSubsequent)}

    end;  {with Sender as TBaseReport do}

end;  {TextFilerPrintHeader}

{===================================================================}
Procedure TSalesAnalysisForm.TextFilerPrint(Sender: TObject);

var
  GroupChanged, Quit, Done, FirstTimeThrough : Boolean;
  TempStr : String;
  I, LinePos : Integer;

    {A list of all the parcels in this group.}

  GroupList : TList;

   {Lists containing the sales prices and av_sp ratios for all parcels
    in the report in order to do an overall total.}

  OverallSalesPriceList, OverallAV_SP_RatioList : TStringList;

  FirstDate, SecondDate : TDateTime;
  FirstPropertyClass, SecondPropertyClass : String;
  PriceDifference, FirstSalesPrice, SecondSalesPrice : Comp;
  ThisSwisSBLKey, NextSwisSBLKey : String;
  PercentDifference,
  PercentChangePerMonth, PercentChangePerYear : Double;
  NumberOfMonthsDifference : Integer;

begin
  Quit := False;
  Done := False;
  FirstTimeThrough := True;

  SortTable.First;
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);
  ProgressDialog.UserLabelCaption := 'Printing report.';

  OverallSalesPriceList := TStringList.Create;
  OverallAV_SP_RatioList := TStringList.Create;

  GroupList := TList.Create;

    {Print out a list of the options.}

  with Sender as TBaseReport do
    begin
      Println('');
      Println('Options selected: ');
      Println('');

      TempStr := 'For Sale Prices:';
      If PrintAllSalePrices
        then Println(TempStr + ' All')
        else
          begin
            TempStr := TempStr + FormatFloat(CurrencyNormalDisplay, StartSalePrice) +
                       ' to ';

            If PrintToEndOfSalePrices
              then Println(TempStr + 'Last Sale Price.')
              else Println(TempStr + FormatFloat(CurrencyNormalDisplay, EndSalePrice) + '.');

          end;  {If PrintAllSalesPrices}

      TempStr := 'For Assessed Values: ';
      If PrintAllAVPrices
        then Println(TempStr + 'All')
        else
          begin
            TempStr := TempStr + FormatFloat(CurrencyNormalDisplay, StartAVPrice) +
                       ' to ';

            If PrintToEndOfAVPrices
              then Println(TempStr + 'Last Assessed Value.')
              else Println(TempStr + FormatFloat(CurrencyNormalDisplay, EndAVPrice) + '.');

          end;  {If PrintAllAVsPrices}

      TempStr := 'For Sale Dates: ';
      If PrintAllDates
        then Println(TempStr + 'All')
        else
          begin
            TempStr := TempStr + DateTimetoMMDDYYYY(StartDate) + ' to ';

            If PrintToEndOfDates
              then Println(TempStr + 'Last Sale Date.')
              else Println(TempStr + DateTimetoMMDDYYYY(EndDate) + '.');

          end;  {If PrintAllAVsPrices}

      TempStr := 'For Assessed Value \ Sales Price Ratios: ';
      If PrintAllAV_SPRatios
        then Println(TempStr + 'All')
        else
          begin
            TempStr := TempStr + FormatFloat(_3DecimalEditDisplay, StartAV_SPRatio) +
                       ' to ';

            If PrintToEndOfAV_SPRatios
              then Println(TempStr + 'Last Ratio.')
              else Println(TempStr + FormatFloat(_3DecimalEditDisplay, EndAV_SPRatio) + '.');

          end;  {If PrintAllAVsPrices}

        {CHG02052005-1(2.8.3.5)[2009]: Add account number range.}

      TempStr := 'For Account Number Range: ';
      If PrintAllAccountNumbers
        then Println(TempStr + 'All')
        else
          begin
            TempStr := TempStr + StartAccountNumber + ' to ';

            If PrintToEndOfAccountNumbers
              then Println(TempStr + 'Last Account Number.')
              else Println(TempStr + EndAccountNumber + '.');

          end;  {If PrintAllAccountNumbers}

(*      If (SelectedPropertyClasses.Count = PropertyClassListBox.Items.Count)
        then Println('For Property Classes: All.')
        else
          begin
            Print('For Property Classes: ');
            For I := 0 to (SelectedPropertyClasses.Count - 1) do
              Print(SelectedPropertyClasses[I] + ' ');

            Println('');

          end;  {else of If (SelectedPropertyClasses.Count ...} *)

      If PrintAllSections
        then Println('For Sections: All.')
        else
          begin
            LinePos := 15;
            Print('For Sections: ');

            For I := 0 to (SelectedSections.Count - 1) do
              begin
                Print(SelectedSections[I] + ' ');
                LinePos := LinePos + Length(SelectedSections[I]) + 1;

                  {Goto the next line.}

                If (LinePos > 125)
                  then
                    begin
                      Println('');
                      Print(Take(14, ''));
                      LinePos := 15;

                    end;  {If (LinePos > 125)}

              end;  {For I := 0 to (SelectedSections.Count - 1) do}

            Println('');

          end;  {else of If PrintAllSections}

      If (SelectedSwisCodes.Count = SwisCodeListBox.Items.Count)
        then Println('For Swis Codes: All.')
        else
          begin
            LinePos := 17;
            Print('For Swis Codes: ');

            For I := 0 to (SelectedSwisCodes.Count - 1) do
              begin
                Print(SelectedSwisCodes[I] + ' ');
                LinePos := LinePos + Length(SelectedSwisCodes[I]) + 1;

                  {Goto the next line.}

                If (LinePos > 125)
                  then
                    begin
                      Println('');
                      Print(Take(16, ''));
                      LinePos := 17;

                    end;  {If (LinePos > 125)}

              end;  {For I := 0 to (SelectedSwisCodes.Count - 1) do}

            Println('');

          end;  {else of If (SelectedSwisCodes.Count ...}

      If (SelectedSchoolCodes.Count = SchoolCodeListBox.Items.Count)
        then Println('For School Codes: All.')
        else
          begin
            LinePos := 18;
            Print('For School Codes: ');

            For I := 0 to (SelectedSchoolCodes.Count - 1) do
              begin
                Print(SelectedSchoolCodes[I] + ' ');
                LinePos := LinePos + Length(SelectedSchoolCodes[I]) + 1;

                  {Goto the next line.}

                If (LinePos > 125)
                  then
                    begin
                      Println('');
                      Print(Take(17, ''));
                      LinePos := 18;

                    end;  {If (LinePos > 125)}

              end;  {For I := 0 to (SelectedSchoolCodes.Count - 1) do}

            Println('');

          end;  {else of If (SelectedSchoolCodes.Count ...}

      If (SelectedNeighborhoodCodes.Count = NeighborhoodCodeListBox.Items.Count)
        then Println('For Neighborhood Codes: All.')
        else
          begin
            LinePos := 25;
            Print('For Neighborhood Codes: ');

            For I := 0 to (SelectedNeighborhoodCodes.Count - 1) do
              begin
                Print(SelectedNeighborhoodCodes[I] + ' ');
                LinePos := LinePos + Length(SelectedNeighborhoodCodes[I]) + 1;

                  {Goto the next line.}

                If (LinePos > 125)
                  then
                    begin
                      Println('');
                      Print(Take(24, ''));
                      LinePos := 25;

                    end;  {If (LinePos > 125)}

              end;  {For I := 0 to (SelectedNeighborhoodCodes.Count - 1) do}

            Println('');

          end;  {else of If (SelectedNeighborhoodCodes.Count ...}

      Println('');

      If PrintHistorySales
        then Println('Print History Sales.')
        else Println('Do Not Print History Sales.');

      If PrintArmsLengthSalesOnly
        then Println('Print Arms Length Sales Only.');

      If PrintValidSalesOnly
        then Println('Print Valid Sales Only.');

      If ShowPartialSales
        then Println('Show Partial Sales.');

      If UseCurrentAssessedValue
        then Println('Compare Sales Price to Current Assessed Value.')
        else Println('Compare Sales Price to Assessed Value at Time of Sale.');

        {CHG04032001-1: Allow for a selection of cooperatives.}

      case CooperativeType of
        ctOnlyCoops : Println('Show Only Cooperatives for 411 Property Class.');
        ctNoCoops : Println('Do Not Show Cooperatives for 411 Property Class.');
      end;

      case CondominiumTypeFor411 of
        cntOnlyCondosFor411 : Println('Show Only Condominiums for 411 Property Class.');
        cntNoCondosFor411 : Println('Do Not Show Condominiums for 411 Property Class.');
      end;

      case CondominiumTypeFor210 of
        cntOnlyCondosFor210 : Println('Show Only Condominiums for 210 Property Class.');
        cntNoCondosFor210 : Println('Do Not Show Condominiums for 210 Property Class.');
      end;

      If ExcludeSalesForMoreThan1Parcel
        then Println('Exclude sales with number of parcels greater than 1.');

      FirstPagePrinted := True;

    end;  {with Sender as TBaseReport do}

      {Print the reports.}

    If (ReportType = rtSubsequent)
      then
        begin
          with Sender as TBaseReport do
            NewPage;

          repeat
            If FirstTimeThrough
              then FirstTimeThrough := False
              else SortTable.Next;

            If SortTable.EOF
              then Done := True;

            Application.ProcessMessages;
            ReportCancelled := ProgressDialog.Cancelled;

            If not Done
              then
                with SortTable, Sender as TBaseReport do
                  begin
                    ThisSwisSBLKey := FieldByName('SwisCode').Text +
                                      FieldByName('SBLKey').Text;
                    FirstDate := FieldByName('SaleDate').AsDateTime;
                    FirstSalesPrice := FieldByName('SalePrice').AsInteger;
                    FirstPropertyClass := FieldByName('PropertyClass').Text +
                                          FieldByName('OwnershipCode').Text;

                    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ThisSwisSBLKey));

                      {Check the next record.}

                    Next;

                    If EOF
                      then Done := True
                      else NextSwisSBLKey := FieldByName('SwisCode').Text +
                                             FieldByName('SBLKey').Text;

                    If ((not EOF) and
                        (Take(26, ThisSwisSBLKey) = Take(26, NextSwisSBLKey)))
                      then
                        begin
                          If (LinesLeft < LinesLeftAtBottom)
                            then NewPage;

                          SecondDate := FieldByName('SaleDate').AsDateTime;
                          SecondSalesPrice := FieldByName('SalePrice').AsInteger;
                          SecondPropertyClass := FieldByName('PropertyClass').Text +
                                                 FieldByName('OwnershipCode').Text;

                          PriceDifference := SecondSalesPrice - FirstSalesPrice;

                            {FXX11092005-1(2.9.3.14): The percent should be based on the
                                                      1st sales price, not the 2nd.}

                          try
                            PercentDifference := (PriceDifference / FirstSalesPrice) * 100;
                          except
                            PercentDifference := 9999.99;
                          end;

                          NumberOfMonthsDifference := CalcMonthsDifference(FirstDate, SecondDate);

                          try
                            PercentChangePerMonth := Roundoff((PercentDifference /
                                                               NumberOfMonthsDifference), 2);
                          except
                            PercentChangePerMonth := 0;
                          end;

                          try
                            PercentChangePerYear := Roundoff((PercentDifference /
                                                             (NumberOfMonthsDifference / 12)), 2);
                          except
                            PercentChangePerYear := 0;
                          end;

                          Println(#9 + ConvertSwisSBLToDashDot(ThisSwisSBLKey) +
                                  #9 + FieldByName('NeighborhoodCode').Text +
                                  #9 + FieldByName('LegalAddr').Text +
                                  #9 + FirstPropertyClass +
                                  #9 + DateToStr(FirstDate) +
                                  #9 + SecondPropertyClass +
                                  #9 + DateToStr(SecondDate) +
                                  #9 + IntToStr(NumberOfMonthsDifference) +
                                  #9 + FormatFloat(DecimalEditDisplay,
                                                   PercentChangePerMonth) +
                                  #9 + FormatFloat(DecimalEditDisplay,
                                                   PercentChangePerYear));

                          Println(#9 + #9 +
                                  #9 + FieldByName('SchoolCode').Text +
                                  #9 + #9 + FormatFloat(CurrencyNormalDisplay,
                                                        FirstSalesPrice) +
                                  #9 + #9 + FormatFloat(CurrencyNormalDisplay,
                                                        SecondSalesPrice) +
                                  #9 + FormatFloat(CurrencyNormalDisplay,
                                                   PriceDifference));

                          Println('');

                            {CHG03252007-1(2.11.1.22): Enable extract to Excel for subsequent sales report.}

                          If ExtractToExcel
                            then WritelnCommaDelimitedLine(ExtractFile,
                                                           [FieldByName('SwisCode').AsString,
                                                            ConvertSwisSBLToDashDot(ThisSwisSBLKey),
                                                            FieldByName('NeighborhoodCode').AsString,
                                                            FieldByName('LegalAddr').AsString,
                                                            FieldByName('SchoolCode').AsString,
                                                            DateToStr(FirstDate),
                                                            FirstSalesPrice,
                                                            FirstPropertyClass,
                                                            DateToStr(SecondDate),
                                                            SecondSalesPrice,
                                                            SecondPropertyClass,
                                                            NumberOfMonthsDifference,
                                                            PercentChangePerMonth,
                                                            PercentChangePerYear]);

                        end;  {If ((not EOF) and ...}

                      {Move back to our original record.}

                    Prior;

                  end;  {with SortTable do}

          until (Done or ReportCancelled);

        end
      else
        begin
            {Set up the initial values for this group.}
          with SortTable do
            case ReportGroupType of
              goSwisCode :
                begin
                  CurrentSwisCode := FieldByName('SwisCode').Text;
                  FindKeyOld(SwisCodeTable, ['SwisCode'], [CurrentSwisCode]);
                  CurrentSwisCodeName := SwisCodeTable.FieldByName('MunicipalityName').Text;

                end;  {goSwisCode}

              goPropertyClass :
                begin
                     {FXX05151998-2: Compare on the whole property class.}

                  CurrentPropertyClass := FieldByName('PropertyClass').Text;
                  FindKeyOld(PropertyClassTable, ['MainCode'],
                             [CurrentPropertyClass]);
                  CurrentPropertyClassName := PropertyClassTable.FieldByName('Description').Text;

                end;  {goPropertyClass}

              goNeighborhoodCode : CurrentNeighborhoodCode := FieldByName('NeighborhoodCode').Text;
              goSection : CurrentSection := FieldByName('Section').Text;

              goSchoolCode :
                begin
                  CurrentSchoolCode := FieldByName('SchoolCode').Text;
                  FindKeyOld(SchoolCodeTable, ['SchoolCode'],
                             [CurrentSchoolCode]);
                  CurrentSchoolCodeName := SchoolCodeTable.FieldByName('SchoolName').Text;

                end;  {goSchoolCode}

            end;  {case ReportGroupType of}

          repeat
            If FirstTimeThrough
              then FirstTimeThrough := False
              else SortTable.Next;

            If SortTable.EOF
              then Done := True;

            Application.ProcessMessages;

            If not Quit
              then
                begin
                  case ReportGroupType of
                    goSwisCode : TempStr := 'Swis Code ' + CurrentSwisCode;
                    goPropertyClass : TempStr := 'Prop Class ' + CurrentPropertyClass;
                    goSchoolCode : TempStr := 'School Code ' + CurrentSchoolCode;
                    goSection : TempStr := 'Section ' + CurrentSection;
                    goNeighborhoodCode : TempStr := 'Nghbrhd Code ' + CurrentNeighborhoodCode;
                    goNone : TempStr := 'Parcel ' + SortTable.FieldByName('SBLKey').Text;

                  end;  {case ReportGroupType of}

                  ProgressDialog.Update(Self, TempStr);

                    {See if the group changed.  If so, then we want to print the group
                     and figure out the stats.}

                  GroupChanged := False;

                  with SortTable do
                    case ReportGroupType of
                      goSwisCode : If (CurrentSwisCode <> FieldByName('SwisCode').Text)
                                     then GroupChanged := True;

                        {FXX05151998-2: Compare on the whole property class.}

                      goPropertyClass : If (CurrentPropertyClass <> FieldByName('PropertyClass').Text)
                                          then GroupChanged := True;

                      goNeighborhoodCode : If (CurrentNeighborhoodCode <> FieldByName('NeighborhoodCode').Text)
                                             then GroupChanged := True;

                      goSection : If (CurrentSection <> FieldByName('Section').Text)
                                    then GroupChanged := True;

                      goSchoolCode : If (CurrentSchoolCode <> FieldByName('SchoolCode').Text)
                                       then GroupChanged := True;

                    end;  {case ReportGroupType of}

                  If (GroupChanged or Done)
                    then
                      begin
                        PrintGroup(Sender, GroupList, OverallSalesPriceList,
                                   OverallAV_SP_RatioList);

                          {Reset the current group.}

                        with SortTable do
                          case ReportGroupType of
                            goSwisCode :
                              begin
                                CurrentSwisCode := FieldByName('SwisCode').Text;
                                FindKeyOld(SwisCodeTable, ['SwisCode'],
                                           [CurrentSwisCode]);
                                CurrentSwisCodeName := SwisCodeTable.FieldByName('MunicipalityName').Text;

                              end;  {goSwisCode}

                            goPropertyClass :
                              begin
                                  {FXX05151998-2: Compare on the whole property class.}

                                CurrentPropertyClass := FieldByName('PropertyClass').Text;
                                FindKeyOld(PropertyClassTable, ['MainCode'],
                                           [CurrentPropertyClass]);
                                CurrentPropertyClassName := PropertyClassTable.FieldByName('Description').Text;

                              end;  {goPropertyClass}

                            goNeighborhoodCode : CurrentNeighborhoodCode := FieldByName('NeighborhoodCode').Text;
                            goSection : CurrentSection := FieldByName('Section').Text;

                            goSchoolCode :
                              begin
                                CurrentSchoolCode := FieldByName('SchoolCode').Text;
                                FindKeyOld(SchoolCodeTable, ['SchoolCode'],
                                           [CurrentSchoolCode]);
                                CurrentSchoolCodeName := SchoolCodeTable.FieldByName('SchoolName').Text;

                              end;  {goSchoolCode}

                          end;  {case ReportGroupType of}

                      end;  {If GroupChanged}

                  If not Done
                    then AddParcelToGroup(GroupList, SortTable, DisplaySFLA, UseCurrentAssessedValue);

                end;  {If not (Done or Quit)}

            ReportCancelled := ProgressDialog.Cancelled;

          until (Done or Quit or ReportCancelled);

          with Sender as TBaseReport do
            NewPage;

          PrintGroupTotals(Sender, '>>>>> GRAND TOTALS <<<<<', True,
                           OverallSalesPriceList, OverallAV_SP_RatioList);

        end;  {else of If (ReportType = rtSubsequent)}

  OverallSalesPriceList.Free;
  OverallAV_SP_RatioList.Free;
  FreeTList(GroupList, SizeOf(DetailedSaleRecord));

end;  {TextFilerPrint}

{==================================================================}
Procedure TSalesAnalysisForm.ReportPrint(Sender: TObject);

var
  TempTextFile : TextFile;

begin
  AssignFile(TempTextFile, TextFiler.FileName);
  Reset(TempTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, TempTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(TempTextFile);

end;  {ReportPrint}

{===================================================================}
Procedure TSalesAnalysisForm.FormClose(    Sender: TObject;
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