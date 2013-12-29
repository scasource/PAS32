unit Rslsrept;

interface

uses
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress, *)RPTXFilr, Types, Zipcopy,
  AbArcTyp, AbZBrows, AbZipper, AbBase, AbBrowse, SysUtils, ComCtrls, PASTypes;

type
  TRptSalesReportingForm = class(TForm)
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    SalesTable: TwwTable;
    SwisCodeTable: TwwTable;
    SalesStatusTable: TwwTable;
    SalesStatusTableTaxRollYr: TStringField;
    SalesStatusTableMainCode: TStringField;
    SalesStatusTableDescription: TStringField;
    Label5: TLabel;
    ComSiteTable: TTable;
    ResSiteTable: TTable;
    ParcelTable: TTable;
    AssessmentTable: TTable;
    label99: TLabel;
    Label13: TLabel;
    TextFiler: TTextFiler;
    ZipCopyDlg: TZipCopyDlg;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    AbZipper: TAbZipper;
    ZipPanel: TPanel;
    Label16: TLabel;
    Gauge: TGauge;
    AssessmentYearCtlTable: TTable;
    SalesExtractLogTable: TTable;
    ReportLabelFiler: TReportFiler;
    ReportLabelPrinter: TReportPrinter;
    AssessmentYearControlTable: TTable;
    SchoolCodeTable: TTable;
    Panel3: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    Panel4: TPanel;
    PageControl1: TPageControl;
    OptionTabSheet: TTabSheet;
    Label1: TLabel;
    IndexRadioGroup: TRadioGroup;
    GroupBox1: TGroupBox;
    XmitCheckBox: TCheckBox;
    ArmsLengthOnlyCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    PrintToExcelCheckBox: TCheckBox;
    PrintLabelsCheckBox: TCheckBox;
    PrintConditionCodesCheckBox: TCheckBox;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    StatusCodeListBox: TListBox;
    MoreOptionsTabSheet: TTabSheet;
    LastChangeSalesDateGroupBox: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    AllLastChangeSalesDateCheckBox: TCheckBox;
    ToEndOfLastChangeSalesDateCheckBox: TCheckBox;
    EndLastChangeSalesDateEdit: TMaskEdit;
    StartLastChangeSalesDateEdit: TMaskEdit;
    SBLGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    StartSBLEdit: TEdit;
    EndSBLEdit: TEdit;
    AllSBLCheckBox: TCheckBox;
    ToEndOfSBLCheckBox: TCheckBox;
    EnteredSalesDateGroupBox: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    AllEnteredSalesDatesCheckBox: TCheckBox;
    ToEndOfEnteredSalesDatesCheckBox: TCheckBox;
    EndEnteredSalesDateEdit: TMaskEdit;
    StartEnteredSalesDateEdit: TMaskEdit;
    TransmittedSalesDateGroupBox: TGroupBox;
    Label6: TLabel;
    Label9: TLabel;
    AllTransmittedSalesDatesCheckBox: TCheckBox;
    ToEndOfTransmittedSalesDatesCheckBox: TCheckBox;
    EndTransmittedSalesDateEdit: TMaskEdit;
    StartTransmittedSalesDateEdit: TMaskEdit;
    SwisSchoolTabSheet: TTabSheet;
    Label10: TLabel;
    Label17: TLabel;
    SchoolCodeListBox: TListBox;
    SwisCodeListBox: TListBox;
    AccountNumberGroupBox: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    StartAccountNumberEdit: TEdit;
    AllAccountNumbersCheckBox: TCheckBox;
    ToEndOfAccountNumbersCheckBox: TCheckBox;
    EndAccountNumberEdit: TEdit;
    SalePriceGroupBox: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    StartSalePriceEdit: TEdit;
    EndSalePriceEdit: TEdit;
    AllSalePricesCheckBox: TCheckBox;
    ToEndOfSalePricesCheckBox: TCheckBox;
    tbsPropertyClass: TTabSheet;
    Panel8: TPanel;
    Label22: TLabel;
    PropertyClassListBox: TListBox;
    PropertyClassTable: TTable;
    cbxExtractInventory: TCheckBox;
    tbSalesResidentialBuildings: TTable;
    tbSalesResidentialSites: TTable;
    tbSalesResidentialLands: TTable;
    cbxPrintAllDimensions: TCheckBox;
    cbxIncludeInventoryOnTransmittal: TCheckBox;
    tbSalesResidentialImprovements: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TextReportPrintHeader(Sender: TObject);
    procedure SBLEditExit(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure AllSBLCheckBoxClick(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure XmitCheckBoxClick(Sender: TObject);
    procedure TextReportPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure TextFilerBeforePrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure AllLastChangeSalesDateCheckBoxClick(Sender: TObject);
    procedure AbZipperArchiveItemProgress(Sender: TObject;
      Item: TAbArchiveItem; Progress: Byte; var Abort: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure AllEnteredSalesDatesCheckBoxClick(Sender: TObject);
    procedure AllTransmittedSalesDatesCheckBoxClick(Sender: TObject);
    procedure ReportLabelPrintHeader(Sender: TObject);
    procedure ReportLabelPrint(Sender: TObject);
    procedure AllAccountNumbersCheckBoxClick(Sender: TObject);
    procedure AllSalePricesCheckBoxClick(Sender: TObject);
    procedure ToEndOfSalePricesCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public

    RPS035T1File,  {Sales extract equivalent to full file.}
    RPS035T2File : TextFile;  {Report information}

     {For printing status:}

    ArmsLengthOnly,
    TransmitReport,
    PrintConditionCodes,
    ReportCancelled,
    bPrintAllDimensions : Boolean;
    TotalSalesRecordCnt,
    IncompleteSalesCnt,
    TotalSalesXmittedCnt,
    ResidentialCnt,
    CommercialCnt : LongInt;
    PClassCntArray : Array [1..9] of LongInt;
    PClassCntArray_Condo : Array[1..10] of LongInt;  {This array has two entries for res prop class (200's) -
                                                      condo and other.}

    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;
    PrintAllAccountNumbers,
    PrintToEndOfAccountNumbers,
    PrintAllSwisSBLs,
    PrintToEndOfSwisSBLs,
    PrintAllSalePrices,
    PrintToEndOfSalePrices : Boolean;
    StartAccountNumber,
    EndAccountNumber,
    StartSwisSBL,
    EndSwisSBL, CurrentSwisCode : String;
    StartSalePrice,
    EndSalePrice : LongInt;


    PrintFinalPageHeader : Boolean;  {if true, print final page hdr}
                                   {for report}

    CreateParcelList : Boolean;
    PrintOrder : Integer;
    PrintToExcel : Boolean;
    ExtractFile : TextFile;
    _PrintLabels, bExtractInventory, bIncludeInventoryOnTransmittal : Boolean;

      {Label variables}
    LabelOptions : TLabelOptions;
    ParcelListForLabels : TStringList;
    SelectedSchoolCodes,
    SelectedSwisCodes,
    SelectedPropertyClassCodes : TStringList;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}
    Function ValidSelectionInformation : Boolean;
    {Have they filled in enough information in the selection boxes to print?}

    Function RecordInRange : Boolean;
    {Does this record fall within the set of parameters that they selected?}

    Procedure WriteExtractRecords(OldSwisSBLKey : String;
                                  FormattedOldSwisSBLKey : String);
    Procedure PrintSalesTotals(Sender : TObject;
                               SalesTotals : TStringList;
                               SwisCode : String);

  end;

implementation
Uses Utilitys,  {General utilitys}
     RPS995UT,  {Full file extract utilities}
     PASUTILS, UTILEXSD,   {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     PRCLLIST,
     RptDialg,
     Prog,
     DataAccessUnit,
     Preview;

{CHG10032008-1[2.15.1.18]: Add property class code, sales price selection to sales report.
                           Also, add time of sale inventory to extract.}

{$R *.DFM}

const
  poSwisSBLKey = 0;
  poOwnerName = 1;
  poSaleDate = 2;
  poLegalAddr_LegalAddrNo = 3;
  poLegalAddrNo_LegalAddr = 4;

{========================================================}
Procedure TRptSalesReportingForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TRptSalesReportingForm.InitializeForm;

var
  I : Integer;
  Quit, FirstTimeThrough, Done : Boolean;
  TempStr : String;

begin
  UnitName := 'RSLSREPT.PAS';  {mmm}

  OpenTablesForForm(Self, NextYear);

  OpenTableForProcessingType(AssessmentYearCtlTable, AssessmentYearControlTableName,
                             ThisYear, Quit);

  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SalesStatusTable.Next;

    If SalesStatusTable.EOF
      then Done := True;

    If not Done
      then
        begin
          TempStr := Take(1, SalesStatusTableMainCode.Text) + ' - ' +
                     Take(30, SalesStatusTableDescription.Text);

          StatusCodeListBox.Items.Add(TempStr);
        end;

  until Done;

  StatusCodeListBox.Repaint;

  TotalSalesRecordCnt := 1;  {set to one, since 'SalesTAble.First' is done}
  IncompleteSalesCnt  := 0;
  TotalSalesXmittedCnt := 0;
  ResidentialCnt := 0;
  CommercialCnt := 0;

  For I := 1 to 9 do
    PClassCntArray[I] := 0;

  For I := 1 to 10 do
    PClassCntArray_Condo[I] := 0;

  SelectItemsInListBox(StatusCodeListBox);

    {CHG02012004-3(2.08): Add swis and school choices to sales report.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName', 20,
                 True, True, NextYear, GlblNextYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable,
                 'SchoolCode', 'SchoolName', 20,
                 True, True, NextYear, GlblNextYear);

  FillOneListBox(PropertyClassListBox, PropertyClassTable, 'MainCode',
                 'Description', 15, True, True, GlblProcessingType,
                 GlblThisYear);

  SelectedSchoolCodes := TStringList.Create;
  SelectedSwisCodes := TStringList.Create;
  SelectedPropertyClassCodes := TStringList.Create;

end;  {InitializeForm}

{===================================================================}
Procedure TRptSalesReportingForm.FormKeyPress(    Sender: TObject;
                                              var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{======================================================================}
Procedure TRptSalesReportingForm.AllSBLCheckBoxClick(Sender: TObject);

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
Procedure TRptSalesReportingForm.AllDatesCheckBoxClick(Sender: TObject);

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
    else EnableSelectionsInGroupBoxOrPanel(DateGroupBox);

end;  {AllDatesCheckBoxClick}

{========================================================================}
Procedure TRptSalesReportingForm.AllLastChangeSalesDateCheckBoxClick(Sender: TObject);

{CHG10152003-2(2.07k): Add sales date entered, transmitted ranges.}

begin
  If AllLastChangeSalesDateCheckBox.Checked
    then
      begin
        ToEndofLastChangeSalesDateCheckBox.Checked := False;
        ToEndofLastChangeSalesDateCheckBox.Enabled := False;
        StartLastChangeSalesDateEdit.Text := '';
        StartLastChangeSalesDateEdit.Enabled := False;
        StartLastChangeSalesDateEdit.Color := clBtnFace;
        EndLastChangeSalesDateEdit.Text := '';
        EndLastChangeSalesDateEdit.Enabled := False;
        EndLastChangeSalesDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(LastChangeSalesDateGroupBox);

end;  {AllLastChangeSaleDatesCheckBoxClick}

{================================================================}
Procedure TRptSalesReportingForm.AllEnteredSalesDatesCheckBoxClick(Sender: TObject);

{CHG10152003-2(2.07k): Add sales date entered, transmitted ranges.}

begin
  If AllEnteredSalesDatesCheckBox.Checked
    then
      begin
        ToEndofEnteredSalesDatesCheckBox.Checked := False;
        ToEndofEnteredSalesDatesCheckBox.Enabled := False;
        StartEnteredSalesDateEdit.Text := '';
        StartEnteredSalesDateEdit.Enabled := False;
        StartEnteredSalesDateEdit.Color := clBtnFace;
        EndEnteredSalesDateEdit.Text := '';
        EndEnteredSalesDateEdit.Enabled := False;
        EndEnteredSalesDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(EnteredSalesDateGroupBox);

end;  {AllEnteredSalesDatesCheckBoxClick}

{================================================================}
Procedure TRptSalesReportingForm.AllTransmittedSalesDatesCheckBoxClick(Sender: TObject);

begin
  If AllTransmittedSalesDatesCheckBox.Checked
    then
      begin
        ToEndofTransmittedSalesDatesCheckBox.Checked := False;
        ToEndofTransmittedSalesDatesCheckBox.Enabled := False;
        StartTransmittedSalesDateEdit.Text := '';
        StartTransmittedSalesDateEdit.Enabled := False;
        StartTransmittedSalesDateEdit.Color := clBtnFace;
        EndTransmittedSalesDateEdit.Text := '';
        EndTransmittedSalesDateEdit.Enabled := False;
        EndTransmittedSalesDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(TransmittedSalesDateGroupBox);

end;  {AllTransmittedSalesDatesCheckBoxClick}

{================================================================}
Procedure TRptSalesReportingForm.AllAccountNumbersCheckBoxClick(Sender: TObject);

{CHG01172005-1(2.8.3.1)[2009]: Add account number range.}

begin
  If AllAccountNumbersCheckBox.Checked
    then
      begin
        ToEndofAccountNumbersCheckBox.Checked := False;
        ToEndofAccountNumbersCheckBox.Enabled := False;
        StartAccountNumberEdit.Text := '';
        StartAccountNumberEdit.Enabled := False;
        StartAccountNumberEdit.Color := clBtnFace;
        EndAccountNumberEdit.Text := '';
        EndAccountNumberEdit.Enabled := False;
        EndAccountNumberEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(AccountNumberGroupBox);

end;  {AllAccountNumbersCheckBoxClick}

{==================================================================}
Procedure TRptSalesReportingForm.AllSalePricesCheckBoxClick(Sender: TObject);

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

{==================================================================}
Procedure TRptSalesReportingForm.ToEndOfSalePricesCheckBoxClick(Sender: TObject);

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

{================================================================}
Procedure TRptSalesReportingForm.XmitCheckBoxClick(Sender: TObject);

var
  I : Integer;

begin
   {if doing xmit, no other selections valid}
  If XmitCheckBox.Checked
    then
      begin
        XmitCheckBox.Font.Color := clRed;
        XmitCheckBox.Repaint;

          {FXX06051998-2: Check the all SBL and date boxes.}

        AllSBLCheckBox.Checked := True;
        AllDatesCheckBox.Checked := True;
        IndexRadioGroup.Enabled := False;
        StartSBLEdit.Enabled := False;
        EndSBLEdit.Enabled := False;
        AllSBLCheckBox.Enabled := False;
        ToEndofSBLCheckBox.Enabled := False;
        StartDateEdit.Enabled := False;
        EndDateEdit.Enabled := False;
        AllDatesCheckBox.Enabled := False;
        ToEndofDatesCheckBox.Enabled := False;
        StatusCodeListBox.Enabled := False;
        StatusCodeListBox.Font.Color := clGray;
        For I := 0 to (StatusCodeListBox.Items.Count - 1) do
          StatusCodeListBox.Selected[I] := False;
        StatusCodeListBox.Repaint;

        AllEnteredSalesDatesCheckBox.Checked := True;
        AllTransmittedSalesDatesCheckBox.Checked := True;

          {FXX04242000-4: Make sure to gray out the last change sale
                          date box.}

        DisableSelectionsInGroupBoxOrPanel(LastChangeSalesDateGroupBox);
        ArmsLengthOnlyCheckBox.Enabled := False;
        CreateParcelListCheckBox.Enabled := False;

      end
    else
      begin
        XmitCheckBox.Font.Color := clNavy;
        XmitCheckBox.Repaint;
        IndexRadioGroup.Enabled := True;
        StartSBLEdit.Enabled := True;
        EndSBLEdit.Enabled := True;
        AllSBLCheckBox.Enabled := True;
        ToEndofSBLCheckBox.Enabled := True;
        StartDateEdit.Enabled := True;
        EndDateEdit.Enabled := True;
        AllDatesCheckBox.Enabled := True;
        ToEndofDatesCheckBox.Enabled := True;
        StatusCodeListBox.Enabled := True;
        StatusCodeListBox.Font.Color := clMaroon;
        StatusCodeListBox.Repaint;
        CreateParcelListCheckBox.Enabled := True;

          {FXX04242000-4: Make sure to gray out the last change sale
                          date box.}

        EnableSelectionsInGroupBoxOrPanel(LastChangeSalesDateGroupBox);
        ArmsLengthOnlyCheckBox.Enabled := True;
        CreateParcelListCheckBox.Enabled := True;

      end;  {else of If XmitCheckBox.Checked}

end;  {XmitCheckBoxClick}

{=========================================================================}
Procedure TRptSalesReportingForm.SBLEditExit(Sender: TObject);

var
  SwisSBLKey, SwisSBLEntry : String;
  ValidEntry : Boolean;

begin
  SwisSBLEntry := UpcaseStr(StartSBLEdit.Text);

  If (Deblank(SwisSBLEntry) <> '')
    then
      begin
        SwisSBLKey := ConvertSwisDashDotToSwisSBL(SwisSBLEntry,
                                                  SwisCodeTable, ValidEntry);

        If not ValidEntry
          then
            begin
               MessageDlg('Invalid Parcel ID. Please try again.', mtError, [mbOK], 0);
               TEdit(Sender).SetFocus;
               (*Abort;*)
             end;

      end;  {If (Deblank(SwisSBLEntry) <> '')}

end;  {SBLEditExit}

{=====================================================================}
Function TRptSalesReportingForm.ValidSelectionInformation : Boolean;

{Have they filled in enough information in the selection boxes to print?}

var
  I : Integer;
  StatusSelected : Boolean;

begin
  Result := True;

    { if we are not doing an xmit, then check all other screen selections}

  If not XmitCheckBox.Checked
    then
      begin
         {If they selected tickler or both note types, they need to fill in a notes
          status.}

        If (Result and
            (IndexRadioGroup.ItemIndex = -1))
          then
            begin
              MessageDlg('Please select a sort order (SBL, Date, or User)',
                         mtError, [mbOK], 0);
              Result := False;
            end;

         {Now make sure that the selections that they chose make sense. Note that if they do not
          select anything in a box, all is assumed, so we will check it.}

        If Result
          then
            If ((StartDateEdit.Text <> '  /  /    ') or
                (EndDateEdit.Text <> '  /  /    ') or
                AllDatesCheckBox.Checked or
                ToEndofDatesCheckBox.Checked)
              then
                begin
                   {Make sure if they clicked to end of range that they put in a start range.}

                  If ((ToEndofDatesCheckBox.Checked or
                       (EndDateEdit.Text <> '  /  /    ')) and
                      (StartDateEdit.Text = '  /  /    '))
                    then
                      begin
                        MessageDlg('Please select a starting date or chose all dates.', mtError, [mbOK], 0);
                        Result := False;
                      end;

                   {Make sure that if they entered a start range, there is an end range.}

                  If ((StartDateEdit.Text <> '  /  /    ') and
                      ((EndDateEdit.Text = '  /  /    ') and
                       (not ToEndofDatesCheckBox.Checked)))
                    then
                      begin
                        MessageDlg('Please select an ending date or chose to print to the end of the dates on file.',
                                   mtError, [mbOK], 0);
                        Result := False;
                      end;

                end
              else AllDatesCheckBox.Checked := True;

        If Result
          then
            If ((StartLastChangeSalesDateEdit.Text <> '  /  /    ') or
                (EndLastChangeSalesDateEdit.Text <> '  /  /    ') or
                AllLastChangeSalesDateCheckBox.Checked or
                ToEndofLastChangeSalesDateCheckBox.Checked)
              then
                begin
                   {Make sure if they clicked to end of range that they put in a start range.}

                  If ((ToEndofLastChangeSalesDateCheckBox.Checked or
                       (EndLastChangeSalesDateEdit.Text <> '  /  /    ')) and
                      (StartLastChangeSalesDateEdit.Text = '  /  /    '))
                    then
                      begin
                        MessageDlg('Please select a starting Last Change Sales Date ' +
                                   'or chose all Last Change Sales Dates.', mtError, [mbOK], 0);
                        Result := False;
                      end;

                   {Make sure that if they entered a start range, there is an end range.}

                  If ((StartLastChangeSalesDateEdit.Text <> '  /  /    ') and
                      ((EndLastChangeSalesDateEdit.Text = '  /  /    ') and
                       (not ToEndofLastChangeSalesDateCheckBox.Checked)))
                    then
                      begin
                        MessageDlg('Please select an ending Last Change Sales Date or chose ' +
                                   'to print to the end of the Last Change Sales Dates on file.',
                                   mtError, [mbOK], 0);
                        Result := False;
                      end;

                end
              else AllLastChangeSalesDateCheckBox.Checked := True;

          {CHG10152003-2(2.07k): Add sales date entered, transmitted ranges.}

        If Result
          then
            If ((StartEnteredSalesDateEdit.Text <> '  /  /    ') or
                (EndEnteredSalesDateEdit.Text <> '  /  /    ') or
                AllEnteredSalesDatesCheckBox.Checked or
                ToEndofEnteredSalesDatesCheckBox.Checked)
              then
                begin
                   {Make sure if they clicked to end of range that they put in a start range.}

                  If ((ToEndofEnteredSalesDatesCheckBox.Checked or
                       (EndEnteredSalesDateEdit.Text <> '  /  /    ')) and
                      (StartEnteredSalesDateEdit.Text = '  /  /    '))
                    then
                      begin
                        MessageDlg('Please select a starting EnteredSalesDate or chose all EnteredSalesDates.', mtError, [mbOK], 0);
                        Result := False;
                      end;

                   {Make sure that if they entered a start range, there is an end range.}

                  If ((StartEnteredSalesDateEdit.Text <> '  /  /    ') and
                      ((EndEnteredSalesDateEdit.Text = '  /  /    ') and
                       (not ToEndofEnteredSalesDatesCheckBox.Checked)))
                    then
                      begin
                        MessageDlg('Please select an ending EnteredSalesDate or chose to print to the end of the EnteredSalesDates on file.',
                                   mtError, [mbOK], 0);
                        Result := False;
                      end;

                end
              else AllEnteredSalesDatesCheckBox.Checked := True;

        If Result
          then
            If ((StartTransmittedSalesDateEdit.Text <> '  /  /    ') or
                (EndTransmittedSalesDateEdit.Text <> '  /  /    ') or
                AllTransmittedSalesDatesCheckBox.Checked or
                ToEndofTransmittedSalesDatesCheckBox.Checked)
              then
                begin
                   {Make sure if they clicked to end of range that they put in a start range.}

                  If ((ToEndofTransmittedSalesDatesCheckBox.Checked or
                       (EndTransmittedSalesDateEdit.Text <> '  /  /    ')) and
                      (StartTransmittedSalesDateEdit.Text = '  /  /    '))
                    then
                      begin
                        MessageDlg('Please select a starting TransmittedSalesDate or chose all TransmittedSalesDates.', mtError, [mbOK], 0);
                        Result := False;
                      end;

                   {Make sure that if they entered a start range, there is an end range.}

                  If ((StartTransmittedSalesDateEdit.Text <> '  /  /    ') and
                      ((EndTransmittedSalesDateEdit.Text = '  /  /    ') and
                       (not ToEndofTransmittedSalesDatesCheckBox.Checked)))
                    then
                      begin
                        MessageDlg('Please select an ending TransmittedSalesDate or chose to print to the end of the TransmittedSalesDates on file.',
                                   mtError, [mbOK], 0);
                        Result := False;
                      end;

                end
              else AllTransmittedSalesDatesCheckBox.Checked := True;

        If Result
          then
            If ((Deblank(StartSBLEdit.Text) <> '') or
                (Deblank(EndSBLEdit.Text) <> '') or
                AllSBLCheckBox.Checked or
                ToEndofSBLCheckBox.Checked)
              then
                begin
                    {Make sure if they clicked to end of range that they put in a start range.}

                  If ((ToEndofSBLCheckBox.Checked or
                       (Deblank(EndSBLEdit.Text) <> '')) and
                      (Deblank(StartSBLEdit.Text) = ''))
                    then
                      begin
                        MessageDlg('Please select a starting SBL or chose all SBL"s.', mtError, [mbOK], 0);
                        Result := False;
                      end;

                    {Make sure that if they entered a start range, there is an end range.}

                  If ((Deblank(StartSBLEdit.Text) <> '') and
                      ((Deblank(EndSBLEdit.Text) = '') and
                       (not ToEndofSBLCheckBox.Checked)))
                    then
                      begin
                        MessageDlg('Please select an ending SBL or chose to print to the end of the SBL"s on file.',
                                   mtError, [mbOK], 0);
                        Result := False;
                      end;

                end
              else AllSBLCheckBox.Checked := True;

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

            {FXX01151998-1: Need to check to make sure that they chose a sales
                            status code.}

        If Result
          then
            begin
              StatusSelected := False;

              with StatusCodeListBox do
                For I := 0 to (Items.Count - 1) do
                  If Selected[I]
                    then StatusSelected := True;

              If not StatusSelected
                then
                  begin
                    Result := False;
                    MessageDlg('Please select the status code(s) that you would like to see.',
                                mtError, [mbOK], 0);
                  end;

            end;  {If Result}

      end;  {If not XmitCheckBox.Checked}

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

end;  {ValidSelectionInformation}

{====================================================================}
Procedure TRptSalesReportingForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'sales.sal', 'Sales Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TRptSalesReportingForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'sales.sal', 'Sales Report');

end;  {LoadButtonClick}

{======================================================================}
Procedure TRptSalesReportingForm.AbZipperArchiveItemProgress(    Sender: TObject;
                                                                 Item: TAbArchiveItem;
                                                                 Progress: Byte;
                                                             var Abort: Boolean);

begin
  Gauge.Progress := Progress;
  Application.ProcessMessages;
end;

{======================================================================}
Procedure TRptSalesReportingForm.PrintButtonClick(Sender: TObject);

var
  NewFileName, TextFileName,
  NewLabelFileName, MailSubject,
  SpreadsheetFileName, YearStr, TempFileName : String;
  TempFile : File;
  Continue, Quit, ValidEntry,
  OrigGlblUserSeesReportDialog : Boolean;
  Year, Month, Day : Word;
  I : Integer;

begin
  bPrintAllDimensions := cbxPrintAllDimensions.Checked;
  bExtractInventory := cbxExtractInventory.Checked;
  bIncludeInventoryOnTransmittal := cbxIncludeInventoryOnTransmittal.Checked;
  ReportCancelled := False;
  Continue := False;
  PrintToExcel := PrintToExcelCheckBox.Checked;
  PrintConditionCodes := PrintConditionCodesCheckBox.Checked;

  _OpenTable(tbSalesResidentialSites, ResidentialSiteTableName, '', '',
             SalesInventory, []);
  _OpenTable(tbSalesResidentialBuildings, ResidentialBldgTableName, '', '',
             SalesInventory, []);
  _OpenTable(tbSalesResidentialLands, ResidentialLandTableName, '', '',
             SalesInventory, []);
  _OpenTable(tbSalesResidentialImprovements, ResidentialImprovementsTableName, '', '',
             SalesInventory, []);

    {CHG10212003-2(2.07k): Add ability to print labels from sales report.}

  _PrintLabels := PrintLabelsCheckBox.Checked;
  ParcelListForLabels := TStringList.Create;

  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If (ValidSelectionInformation and
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

        Continue := True;

        CreateParcelList := CreateParcelListCheckBox.Checked;
        TransmitReport := XmitCheckBox.Checked;

        with SwisCodeListBox do
          For I := 0 to (Items.Count - 1) do
            If Selected[I]
              then SelectedSwisCodes.Add(Copy(Items[I], 1, 6));

        SelectedSchoolCodes.Clear;
        with SchoolCodeListBox do
          For I := 0 to (Items.Count - 1) do
            If Selected[I]
              then SelectedSchoolCodes.Add(Take(6, Items[I]));

        FillSelectedItemList(PropertyClassListBox, SelectedPropertyClassCodes, 3);
        
          {CHG01172005-1(2.8.3.1)[2009]: Add account number range.}

        PrintAllAccountNumbers := AllAccountNumbersCheckBox.Checked;
        PrintToEndOfAccountNumbers := ToEndOfAccountNumbersCheckBox.Checked;
        StartAccountNumber := StartAccountNumberEdit.Text;
        EndAccountNumber := EndAccountNumberEdit.Text;

          {FXX03122007-1(MDT)[2.11.1.17]: Enable the parcel ID range.}

        PrintAllSwisSBLs := AllSBLCheckBox.Checked;
        PrintToEndOfSwisSBLs := ToEndOfSBLCheckBox.Checked;

        If _Compare(StartSBLEdit.Text, coBlank)
          then StartSwisSBL := ''
          else StartSwisSBL := ConvertSwisDashDotToSwisSBL(StartSBLEdit.Text, SwisCodeTable, ValidEntry);

        If _Compare(EndSBLEdit.Text, coBlank)
          then EndSwisSBL := ''
          else EndSwisSBL := ConvertSwisDashDotToSwisSBL(EndSBLEdit.Text, SwisCodeTable, ValidEntry);

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
        
          {FXX04071999-1: Warning about transmit overwriting sales info.}

        If TransmitReport
          then Continue := (MessageDlg('Running the transmittal will overwrite any' + #13 +
                                       'previous transmittal information.' + #13 +
                                       'Do you want to continue?', mtWarning, [mbYes, mbNo], 0) = idYes);

          {CHG08181999-2: Msg to make sure that all corrections are done.}

        If (TransmitReport and
            Continue)
          then Continue := (MessageDlg('Please make sure that you have done all corrections' + #13 +
                                       'to the sales file prior to transmission.' + #13 +
                                       'If you have not, please exit and do them.' + #13 +
                                       'Do you want to continue?', mtWarning, [mbYes, mbNo], 0) = idYes);

      end;  {If (ValidSelectionInformation and ...}

  If Continue
    then
      begin
        PrintFinalPageHeader := False;

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}
          {FXX07281999-3: Sales report can go to laser or dot matrix.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

          {CHG03122007-1(MDT)[2.11.1.18]: Prompt for letter size print.}

        If (ReportPrinter.Orientation = poLandscape)
          then PromptForLetterSize(ReportPrinter, ReportFiler, 75, 78, 1.5);
        
        If not Quit
          then
            begin
                {CHG07222003-2(2.07g): Add Excel capabilities to sales report.}

              If PrintToExcel
                then
                  begin
                    SpreadsheetFileName := GetPrintFileName('SL', True);
                    AssignFile(ExtractFile, SpreadsheetFileName);
                    Rewrite(ExtractFile);

                      {Write the headers.}
                      {CHG10272010(2.26.1.18)[I8222]: Add the Swis code to the extract.}

                    WriteCommaDelimitedLine(ExtractFile, ['SwisCode',
                                                          'Parcel ID']);

                      {CHG11182003-2(2.07k): Option to print the condition codes instead of the control #.}

                    If PrintConditionCodes
                      then WriteCommaDelimitedLine(ExtractFile, ['Conditions'])
                      else WriteCommaDelimitedLine(ExtractFile, ['Control #']);

                    WriteCommaDelimitedLine(ExtractFile,
                                            ['Deed Book',
                                             'Deed Page',
                                             'Deed Date',
                                             'Legal Address',
                                             'Legal Addr #',
                                             'Legal Addr Street',
                                             'Sales #',
                                             'New Owner',
                                             'Prior Owner',
                                             'Sale Date',
                                             'Sale Price',
                                             'Valid',
                                             'Status Code',
                                             'Sale Year',
                                             '# Parcels',
                                             'Land AV',
                                             'Total AV',
                                             'Frontage',
                                             'Depth',
                                             'Acreage',
                                             'Roll Sect',
                                             'Prop Class',
                                             'School Code',
                                             'Hstd Code',
                                             'Acct #',
                                             'Old SBL',
                                             'Additional Lots']);

                    If bExtractInventory
                      then
                      begin
                        WriteCommaDelimitedLine(ExtractFile,
                                                 ['# Bath',
                                                  '# 1/2 Baths',
                                                  '# Bedrooms',
                                                  '# Fireplaces',
                                                  '# Kitch',
                                                  '# Rooms',
                                                  '# Stories',
                                                  '% Good',
                                                  '1/2 Story',
                                                  '1st Story',
                                                  '2nd Story',
                                                  '3/4 Story',
                                                  '3rd Story',
                                                  'Att Gar',
                                                  'Bath Qual',
                                                  'Bldg Style',
                                                  'Bsmnt Gar',
                                                  'Detach Gar',
                                                  'Bsmnt Type',
                                                  'Cent Air',
                                                  'Condition',
                                                  'Ext Wall',
                                                  'Fin Attic',
                                                  'Fin Bsmnt',
                                                  'Fin Over Gar',
                                                  'Fin Rec Room',
                                                  'Fuel',
                                                  'Func Obs',
                                                  'Grade',
                                                  'Grade Adj',
                                                  'Heat',
                                                  'Kitch Qual',
                                                  'Porch Area',
                                                  'Porch Type',
                                                  'RCN',
                                                  'RCNLD',
                                                  'Tot Living Area',
                                                  'Unfin 1/2',
                                                  'Unfin 3/4',
                                                  'Unfin Room',
                                                  'Year Built',
                                                  'D\C Entry',
                                                  'Desirability',
                                                  'Elevation',
                                                  'Final Land Val',
                                                  'Final Total Val',
                                                  'Land Value',
                                                  'Market Est',
                                                  'Model Est',
                                                  'Nbrhd Rate',
                                                  'Neighborhd',
                                                  'Nghbrhd Type',
                                                  'Physical Chg',
                                                  'Prop Class',
                                                  'RCN - Deprec',
                                                  'Replac. Cost',
                                                  'Road Type',
                                                  'Route Num',
                                                  'Sewer',
                                                  'Traffic',
                                                  'Utilities',
                                                  'Water',
                                                  'Zoning',
                                                  'Land Type',
                                                  'Res. Frontage',
                                                  'Res. Depth',
                                                  'Res. Acreage',
                                                  'Soil Rating',
                                                  'Influence Code',
                                                  'Waterfront Type']);

                        For I := 1 to 25 do
                        WriteCommaDelimitedLine(ExtractFile,
                                                ['Structure Code #' + IntToStr(I),
                                                 'Year Built #' + IntToStr(I),
                                                 'Measure Code #' + IntToStr(I),
                                                 'Dimension 1 #' + IntToStr(I),
                                                 'Dimension 2 #' + IntToStr(I),
                                                 'Quantity #' + IntToStr(I),
                                                 'Grade Code #' + IntToStr(I),
                                                 'Condition Code #' + IntToStr(I)]);

                        WritelnCommaDelimitedLine(ExtractFile, []);

                      end
                      else WritelnCommaDelimitedLine(ExtractFile, []);

                  end;  {If PrintToExcel}

                {FXX06282002-4: Don't allow cancel when transmitting sales.}

              ProgressDialog.Start(GetRecordCount(SalesTable), (not TransmitReport),
                                   (not TransmitReport));

                {CHG1201999-2: Let the user select armsl ength only.}

              ArmsLengthOnly := ArmsLengthOnlyCheckBox.Checked;

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

                 {force xmit run to go to file so report will be }
                 {saved to disk with user-identifiable name in case}
                 {posting fails and we need to reconstruct posting results}
                 {CHG06171998-2: Add the RPS035T2 transmit.}

              If TransmitReport
                then
                  begin
                    PrintDialog.PrintToFile := True;
                    AssignFile(RPS035T1File, ExpandPASPath(GlblExportDir) + 'RPS035T1');
                    Rewrite(RPS035T1File);
                    AssignFile(RPS035T2File, ExpandPASPath(GlblExportDir) + 'RPS035T2');
                    Rewrite(RPS035T2File);

                       {Open the sales inventory tables.}
                       {Residential inventory tables.}

                    OpenTableForProcessingType(ResSiteTable, ResidentialSiteTableName,
                                               SalesInventory, Quit);

                      {Commercial inventory tables.}

                    OpenTableForProcessingType(ComSiteTable, CommercialSiteTableName,
                                               SalesInventory, Quit);

                    ResSiteTable.IndexName := InventorySwisSBL_SalesNumberKey;
                    ComSiteTable.IndexName := InventorySwisSBL_SalesNumberKey;

                  end;  {If XmitCheckBox.Checked}

                {CHG05072002-3: Allow print by legal address.}

              PrintOrder := IndexRadioGroup.ItemIndex;

              with SalesTable do
                case PrintOrder of
                  poSwisSBLKey : IndexName := 'BYSWISSBLKEY';
                  poOwnerName : IndexName := 'BYNEWOWNERNAME';
                  poSaleDate : IndexName := 'BYSALEDATE';
                  poLegalAddr_LegalAddrNo : IndexName := 'BYLEGALADDR_LEGALADDRINT';
                  poLegalAddrNo_LegalAddr : IndexName := 'BYLEGALADDRINT_LEGALADDR';

                end;  {case PrintOrder of}


                {FXX11271998-1: Print the sales report to text file 1st in
                                order to print to dot matrix.}

              TextFileName := GetPrintFileName(Self.Caption, True);
              TextFiler.FileName := TextFileName;

                {FXX01211998-1: Need to set the LastPage property so that
                                long rolls aren't a problem.}

              TextFiler.LastPage := 30000;

              TextFiler.Execute;

                {FXX10111999-3: Tell people that printing is starting and
                                done.}

              ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

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

              ProgressDialog.Finish;

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

                {CHG01182000-3: Allow them to choose a different name or copy right away.}
                {Don't give them the option to rename if this is a transmittal.}

              OrigGlblUserSeesReportDialog := GlblUserSeesReportDialog;
              If XmitCheckBox.Checked
                then GlblUserSeesReportDialog := False;

              ShowReportDialog('SALES.RPT', TextFiler.FileName, True);

              GlblUserSeesReportDialog := OrigGlblUserSeesReportDialog;

              If XmitCheckBox.Checked
                then
                  begin
                    CloseFile(RPS035T1File);
                    CloseFile(RPS035T2File);

                      {CHG05131999-3: See if they want to copy\zip the file.}

                    If (MessageDlg('Do you want to copy\zip the sales transmittal files to another drive or disk?',
                                    mtConfirmation, [mbYes, mbNo], 0) = idYes)
                      then
                        with ZipCopyDlg do
                          begin
                              {CHG08301999-1: Change zip\copy to allow selections from other dirs.}

                            InitialDrive := GlblDrive;
                            InitialDir := GlblExportDir;
                            SelectFile(ExpandPASPath(GlblExportDir) + 'RPS035T1');
                            SelectFile(ExpandPASPath(GlblExportDir) + 'RPS035T2');
                            SelectFile(ExpandPASPath(GlblReportDir) + 'SALES.RPT');

                            Execute;

                          end;  {with ZipCopyDlg do}

                      {CHG09021999-1: Save sales transmittals in a directory for history.}

                    DecodeDate(Date, Year, Month, Day);
                    YearStr := IntToStr(Year);
                    TempFileName := 'SL' + ShiftRightAddZeroes(Take(2, IntToStr(Month))) +
                                           ShiftRightAddZeroes(Take(2, IntToStr(Day))) +
                                           Copy(YearStr, 3, 2) + '.ZIP';

                    ZipPanel.Show;

                    with ABZipper do
                      begin
                        FileName := ExpandPASPath(GlblSavedSalesDir) + TempFileName;
                        AddFiles(ExpandPASPath(GlblExportDir) + 'RPS035T1', faReadOnly);
                        AddFiles(ExpandPASPath(GlblExportDir) + 'RPS035T2', 0);
                        AddFiles(ExpandPASPath(GlblReportDir) + 'SALES.RPT', 0);

                      end;  {with ABZipper do}

                    ZipPanel.Hide;

                      {CHG02062001-1: Log transmittals of sales.}

                    with SalesExtractLogTable do
                      try
                        Insert;
                        FieldByName('Date').AsDateTime := Date;
                        FieldByName('Time').AsDateTime := Now;
                        FieldByName('ParcelsExtracted').AsInteger := TotalSalesXmittedCnt;

                        try
                          FieldByName('ZipFileName').Text := ABZipper.FileName;
                        except
                          FieldByName('ZipFile').Text := ABZipper.FileName;
                        end;

                        Post;
                      except
                        SystemSupport(001, SalesExtractLogTable,
                                      'Error inserting sales extract log record.',
                                      UnitName, GlblErrorDlgBox);
                      end;

                    MessageDlg('PAS has created a copy of the sales files for archive purposes called ' +
                               ABZipper.FileName, mtInformation, [mbOk], 0);

                      {CHG11182003-1(2.07k): Option to email the sales transmittal.}

                    If (MessageDlg('Do you want to email this file?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
                      then
                        begin
                          MailSubject := Trim(GlblMunicipalityName) + ' sale transmittal file ' + DateToStr(Date);
                          EMailFile(Self, '', '', ABZipper.FileName, emlORPSExtract, '', MailSubject, '', nil, False);

                        end;  {If (MessageDlg('Do you want to email this file?' + #13 +}

                  end;  {If XmitCheckBox.Checked}

              If CreateParcelList
                then ParcelListDialog.Show;

                {FXX10111999-3: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

              ResetPrinter(ReportPrinter);

              If PrintToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

            end;  {If not Quit}

      end;  {If PrintDialog.Execute}

  ParcelListForLabels.Free;

end;  {PrintButtonClick}

{========================================================================}
Procedure TRptSalesReportingForm.TextFilerBeforePrint(Sender: TObject);

begin
  SalesTable.First;
  CurrentSwisCode := Copy(SalesTable.FieldByName('SwisSBLKey').Text, 1, 6);

end;  {TextFilerBeforePrint}

{========================================================================}
Procedure TRptSalesReportingForm.TextReportPrintHeader(Sender: TObject);

var
  PrintDeedPageBookColumn : Boolean;
  I : Integer;
  TempStr, TitleStr, TempStr1, TempStr2 : String;

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 12.9, 0, BoxLineNone, 0);
      Println('');

        {Print the date and page number.}

      TempStr1 := 'COUNTY OF ' + Trim(GlblCountyName);
      TempStr2 := 'DATE: ' + DateToStr(Date) + '  TIME: ' + TimeToStr(Now);
      Println(#9 + TempStr1 +
              ShiftRightAddBlanks(Take((130 - Length(TempStr1)), TempStr2)));

      If TransmitReport
        then TitleStr := 'TRANSMITTED SALES REPORT'
        else TitleStr := 'SALES REPORT';

      TempStr1 := Trim(UpcaseStr(GetMunicipalityName));
      TempStr2 := 'PAGE: ' + IntToStr(CurrentPage);
      Println(#9 + Take(43, UpcaseStr(TempStr1)) +
              Center(TitleStr, 43) +
              RightJustify(TempStr2, 43));

      If (TransmitReport and
          PrintFinalPageHeader)
        then TempStr := '5217 EXTRACT FILE/SALE CORRECTIONS TRANSMITTAL FORM'
        else TempStr := '';

      FindKeyOld(SwisCodeTable, ['SwisCode'], [CurrentSwisCode]);
      TempStr1 := 'SWIS CODE: ' + CurrentSwisCode + '  (' +
                  Trim(SwisCodeTable.FieldByName('MunicipalityName').Text) + ')';
      Println(#9 + TempStr1 + Center(TempStr, 115 - Length(TempStr1)));

         {Only show selections for non-transmit case}

      If not TransmitReport
        then
          begin
            Println('');
            ClearTabs;
            SetTab(0.3, pjLeft, 2.5, 0, BOXLINENONE, 0);   {SBL}
            SetTab(3.1, pjLeft, 1.7, 0, BOXLINENONE, 0);   {Tax roll yr}
            SetTab(4.8, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Dates}
            SetTab(6.3, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Users}

               {Print the selection information.}

            Print(#9 + 'Index:  ');
            case IndexRadioGroup.ItemIndex of
              0 : Print(' SBL');
              1 : Print(' Owner Name');
              2 : Print(' Date');
            end;  {case IndexRadioGroup of}

            Print(#9 + 'For Sales Dates: ');
            If AllDatesCheckBox.Checked
              then Println(' All')
              else
                begin
                  Print(' ' + StartDateEdit.Text + ' to ');

                  If ToEndOfDatesCheckBox.Checked
                    then Println(' End')
                    else Println(' ' + EndDateEdit.Text);
                end;  {else of If AllDatesCheckBox.Checked}

              {CHG10212003-1(2.07k): Don't print the sales change, entry, or transmittal dates if
                                     these are selected as all.}

            If not AllLastChangeSalesDateCheckBox.Checked
              then
                begin
                  Print(#9 + 'For Last Change Sales Dates: ');

                  Print(' ' + StartLastChangeSalesDateEdit.Text + ' to ');

                  If ToEndOfLastChangeSalesDateCheckBox.Checked
                    then Println(' End')
                    else Println(' ' + EndLastChangeSalesDateEdit.Text);

                end;  {If not AllLastChangeSalesDateCheckBox.Checked}

              {CHG10152003-2(2.07k): Add sales date entered, transmitted ranges.}

            If not AllEnteredSalesDatesCheckBox.Checked
              then
                begin
                  Print(#9 + 'For Sales Entered Dates: ');

                  Print(' ' + StartEnteredSalesDateEdit.Text + ' to ');

                  If ToEndOfEnteredSalesDatesCheckBox.Checked
                    then Println(' End')
                    else Println(' ' + EndEnteredSalesDateEdit.Text);

                end;  {If not AllEnteredSalesDateCheckBox.Checked}

            If not AllTransmittedSalesDatesCheckBox.Checked
              then
                begin
                  Print(#9 + 'For Sales Transmitted Dates: ');

                  Print(' ' + StartTransmittedSalesDateEdit.Text + ' to ');

                  If ToEndOfTransmittedSalesDatesCheckBox.Checked
                    then Println(' End')
                    else Println(' ' + EndTransmittedSalesDateEdit.Text);

                end;  {If not AllTransmittedSalesDateCheckBox.Checked}

            Print(#9 + 'For Parcels: ');
            If AllSBLCheckBox.Checked
              then Println(' All')
              else
                begin
                  Print(' ' + StartSBlEdit.Text + ' to ');

                  If ToEndOfSBLCheckBox.Checked
                    then Println(' End')
                    else Println(' ' + EndSBLEdit.Text);

                end;  {else of If AllSBLSCheckBox.Checked}

            If ArmsLengthOnly
              then Println(#9 + 'Arms Length Only.');

              {FXX12021999-1: Just list codes for status codes.}

            TempStr := '';

            with StatusCodeListBox do
              For I := 0 to (Items.Count - 1) do
                If Selected[I]
                  then TempStr := TempStr + Items[I][1] + ' ';

            Println(#9 + 'For Sales Status Codes: ' + TempStr);

          end;  {If not TransmitReport}

      If not PrintFinalPageHeader
        then
          begin
              {Print column headers.}

            CRLF;
            ClearTabs;
            SetTab(0.3, pjLeft, 1.0, 0, BOXLINENONE, 0);   {Ctl No & Deed Date}
            SetTab(1.4, pjLeft, 0.5, 0, BOXLINENONE, 0);   {DeedBook/Page}
            SetTab(2.0, pjLeft, 1.5, 0, BOXLINENONE, 0);   {SBL}
            SetTab(3.6, pjLeft, 0.3, 0, BOXLINENONE, 0);   {Sales No}
            SetTab(4.0, pjLeft, 1.8, 0, BOXLINENONE, 0);   {Current/Prior Owner}
            SetTab(5.9, pjLeft, 0.7, 0, BOXLINENONE, 0);   {Front OR acreage}
            SetTab(6.7, pjLeft, 0.7, 0, BOXLINENONE, 0);     {Depth}
            SetTab(7.5, pjCenter, 1.3, 0, BOXLINENONE, 0);   {SaleDate/Price}
            SetTab(8.9, pjLeft, 0.3, 0, BOXLINENONE, 0);   {Roll Section/Validity}
            SetTab(9.3, pjLeft, 0.8, 0, BOXLINENONE, 0);   {SchoolCde,S/S,prp cls}
            SetTab(10.2, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Hstd Cde, # parcels}
            SetTab(10.8, pjCenter, 1.3, 0, BOXLINENONE, 0);   {Land & Tot AV }
            SetTab(12.2, pjCenter, 0.3, 0, BOXLINENONE, 0);   {AV Year}
            SetTab(12.6, pjCenter, 0.3, 0, BOXLINENONE, 0);   {Status code}

              {CHG11182003-2(2.07k): Option to print the condition codes instead of the control #.}
              {CHG01162005-1(2.8.3.1)[2011]: Print the control # if they are a
                                             control # municipality.}

            PrintDeedPageBookColumn := True;

            If PrintConditionCodes
              then
                If GlblUseControlNumInsteadOfBook_Page
                  then
                    begin
                      Print(#9 + 'Ctl #' +
                            #9 + 'Cond');
                      PrintDeedPageBookColumn := False;
                    end
                  else Print(#9 + 'Conditions')
              else Print(#9 + 'Ctl #');

            If PrintDeedPageBookColumn
              then Print(#9 + 'Deed ');

            Println(#9 + 'Parcel ID' +
                    #9 + 'Sls' +
                    #9 + 'Curr Owner' +
                    #9 + 'Frntg' +
                    #9 + 'Depth' +
                    #9 + 'Sale Date' +
                    #9 + 'RS' +
                    #9 + 'School' +
                    #9 + 'Hstd' +
                    #9 + 'Land A/V' +
                    #9 + 'AV' +
                    #9 + 'ST');

              {FXX02081999-5: Add the legal address to the sales report.}

            Print(#9 + 'Deed Date');

            If PrintDeedPageBookColumn
              then Print(#9 + 'Bk/Pg')
              else Print(#9);

            Println(#9 + 'Legal Addr' +
                    #9 + '#' +
                    #9 + 'Prior Owner' +
                    #9 + 'Acres' +
                    #9 + '' +
                    #9 + 'Sale Price' +
                    #9 + 'Val' +
                    #9 + 'S/S Cls' +
                    #9 + '# Prc' +
                    #9 + 'Tot A/V' +
                    #9 + 'YR' +
                    #9 + 'CD');

             {CHG04062000-1: Use old parcel ID in sales.}

           If GlblUseOldParcelIDsForSales
             then Println(#9 + #9 + #9 + 'New Parcel ID');

                   {Set up the tabs for the info.}

           ClearTabs;
           SetTab(0.3, pjLeft, 1.0, 0, BOXLINENONE, 0);   {Ctl No & Deed Date}
           SetTab(1.4, pjRight, 0.5, 0, BOXLINENONE, 0);   {DeedBook/Page}
           SetTab(2.0, pjLeft, 1.5, 0, BOXLINENONE, 0);   {SBL}
           SetTab(3.6, pjCenter, 0.3, 0, BOXLINENONE, 0);   {Sales No}
           SetTab(4.0, pjLeft, 1.8, 0, BOXLINENONE, 0);   {Current/Prior Owner}
           SetTab(5.9, pjRight, 0.7, 0, BOXLINENONE, 0);   {Front OR acreage}
           SetTab(6.7, pjRight, 0.7, 0, BOXLINENONE, 0);     {Depth}
           SetTab(7.5, pjRight, 1.3, 0, BOXLINENONE, 0);   {SaleDate/Price}
           SetTab(8.9, pjCenter, 0.3, 0, BOXLINENONE, 0);   {Roll Section/Validity}
           SetTab(9.3, pjLeft, 0.8, 0, BOXLINENONE, 0);   {SchoolCde,S/S,prp cls}
           SetTab(10.2, pjCenter, 0.5, 0, BOXLINENONE, 0);   {Hstd Cde, # parcels}
           SetTab(10.8, pjRight, 1.3, 0, BOXLINENONE, 0);   {Land & Tot AV }
           SetTab(12.2, pjRight, 0.3, 0, BOXLINENONE, 0);   {AV Year}
           SetTab(12.6, pjRight, 0.3, 0, BOXLINENONE, 0);   {Status code}

           Println('');

         end;  {If not PrintFinalPageHeader}

    end;  {with Sender as TBaseReport do}

end;  {TextReportPrintHeader}

{==========================================================}
Function TRptSalesReportingForm.RecordInRange : Boolean;

{Does this record fall within the set of parameters that they selected?}

var
  SwisSBLKey, SchoolCode : String;
  I : Integer;
  StatusCode : String;

begin
  Result := False;
  StatusCode := Take(1, SalesTable.FieldByName('SaleStatusCode').Text);
  SwisSBLKey := SalesTable.FieldByName('SwisSBLKey').AsString;

   {if formal xmittal, do that report}

  If TransmitReport
    then
      begin
        If (StatusCode[1] in ['A', 'R', 'M'])
          then Result := True
      end
    else
      begin
        For I := 0 to (StatusCodeListBox.Items.Count - 1) do
          If (StatusCodeListBox.Selected[I] and
              (StatusCode = Copy(StatusCodeListBox.Items[I], 1, 1)))
            then Result := True;

           {Now see if they are in the date range (if any) specified.}

        If not AllDatesCheckBox.Checked
          then
            with SalesTable do
              begin
                If (FieldByName('SaleDate').AsDateTime < StrToDate(StartDateEdit.Text))
                  then Result := False;

                If ((not ToEndOfDatesCheckBox.Checked) and
                    (FieldByName('SaleDate').AsDateTime > StrToDate(EndDateEdit.Text)))
                  then Result := False;

              end;  {If not AllDatesCheckBox.Checked}

           {Now see if they are in the LastChangeSale range (if any) specified.}

        If not AllLastChangeSalesDateCheckBox.Checked
          then
            with SalesTable do
              begin
                If (FieldByName('LastChangeDate').AsDateTime < StrToDate(StartLastChangeSalesDateEdit.Text))
                  then Result := False;

                If ((not ToEndOfLastChangeSalesDateCheckBox.Checked) and
                    (FieldByName('LastChangeDate').AsDateTime > StrToDate(EndLastChangeSalesDateEdit.Text)))
                  then Result := False;

              end;  {If not AllLastChangeSalesDateCheckBox.Checked}

          {CHG10152003-2(2.07k): Add sales date entered, transmitted ranges.}

        If not AllEnteredSalesDatesCheckBox.Checked
          then
            with SalesTable do
              begin
                If (FieldByName('DateEntered').AsDateTime < StrToDate(StartEnteredSalesDateEdit.Text))
                  then Result := False;

                If ((not ToEndOfEnteredSalesDatesCheckBox.Checked) and
                    (FieldByName('DateEntered').AsDateTime > StrToDate(EndEnteredSalesDateEdit.Text)))
                  then Result := False;

              end;  {If not AllEnteredSalesDatesCheckBox.Checked}

        If not AllTransmittedSalesDatesCheckBox.Checked
          then
            with SalesTable do
              begin
                If (FieldByName('DateTransmitted').AsDateTime < StrToDate(StartTransmittedSalesDateEdit.Text))
                  then Result := False;

                If ((not ToEndOfTransmittedSalesDatesCheckBox.Checked) and
                    (FieldByName('DateTransmitted').AsDateTime > StrToDate(EndTransmittedSalesDateEdit.Text)))
                  then Result := False;

              end;  {If not AllTransmittedSalesDatesCheckBox.Checked}


          {CHG12011999-2: Allow arms length only selection.}

        If (ArmsLengthOnly and
            (not SalesTable.FieldByName('ArmsLength').AsBoolean))
          then Result := False;

          {CHG02012004-3(2.08): Add choice to select which swis or school code(s) to print.}

        If (SelectedSwisCodes.IndexOf(Copy(SwisSBLKey, 1, 6)) = -1)
          then Result := False;

        SchoolCode := SalesTable.FieldByName('SchoolDistCode').Text;

        If ((SelectedSchoolCodes.Count < SchoolCodeListBox.Items.Count) and {Only if not all selected}
            (Deblank(SchoolCode) <> '') and
            (SelectedSchoolCodes.IndexOf(SchoolCode) = -1))
          then Result := False;

        If _Compare(SelectedPropertyClassCodes.IndexOf(SalesTable.FieldByName('PropClass').AsString), -1, coEqual)
          then Result := False;

          {CHG01172005-1(2.8.3.1)[2009]: Add account number range.}

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

          {FXX03122007-1(MDT)[2.11.1.17]: Enable the parcel ID range.}

        If Result
          then
            begin
              Result := False;

              If PrintAllSwisSBLs
                then Result := True
                else
                  If (_Compare(SalesTable.FieldByName('SwisSBLKey').AsString, StartSwisSBL, coGreaterThanOrEqual) and
                      (PrintToEndOfAccountNumbers or
                       _Compare(SalesTable.FieldByName('SwisSBLKey').AsString, EndSwisSBL, coLessThanOrEqual)))
                    then Result := True;

            end;  {If Result}

    end;  {else of If TransmitReport}

end;  {RecordInRange}

{=================================================================}
Procedure TRptSalesReportingForm.WriteExtractRecords(OldSwisSBLKey : String;
                                                     FormattedOldSwisSBLKey : String);

var
  Index : Integer;
  SaleStatusCode : String;

begin
  with SalesTable do
    begin
       {use 1st digit of prop class code to index into }
       {prop class count array (1..9)  }
       {FXX11021999-2: Put the StrToInt of prop class in a try except so don't cause
                       a problem if blank.}

      try
        Index := StrToInt(Copy(FieldByName('PropClass').Text, 1, 1));
      except
        Index := 2;  {If error, default to res.}
      end;

      PClassCntArray[Index] := PClassCntArray[Index] + 1;

        {Now for the prop class array with a condo split, check the owner code.}

      If (((Index = 2) and
           (FieldByName('OwnershipCode').Text <> 'C')) or
          (Index > 2))
        then Index := Index + 1;

      PClassCntArray_Condo[Index] := PClassCntArray_Condo[Index] + 1;

        {count xmits after post}

      TotalSalesXmittedCnt := TotalSalesXmittedCnt + 1;

        {CHG06171998-2: Create extract RPS035T2 file.}

      Write(RPS035T2File, Copy(OldSwisSBLKey, 1, 6));
      Write(RPS035T2File, Take(7, FieldByName('ControlNo').Text));
      Write(RPS035T2File, Take(6, MakeMMDDYY(FieldByName('DeedDate').AsDateTime)));
      Write(RPS035T2File, Take(5, FieldByName('DeedBook').Text));
      Write(RPS035T2File, Take(5, FieldByName('DeedPage').Text));
      Write(RPS035T2File, Take(25, FormattedOldSwisSBLKey));
      Write(RPS035T2File, ShiftRightAddZeroes(Take(2, FieldByName('SaleNumber').Text)));
      Write(RPS035T2File, Take(10, FieldByName('NewOwnerName').Text));
      Write(RPS035T2File, Take(10, FieldByName('OldOwnerName').Text));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('Frontage').Text, 7, 2));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('Depth').Text, 7, 2));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('Acreage').Text, 7, 2));
      Write(RPS035T2File, Take(6, MakeMMDDYY(FieldByName('SaleDate').AsDateTime)));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('SalePrice').Text, 12, 0));
      Write(RPS035T2File, Take(1, FieldByName('RollSection').Text));
      Write(RPS035T2File, BoolToChar_0_1(FieldByName('ValidSale').AsBoolean));
      Write(RPS035T2File, Take(6, FieldByName('SchoolDistCode').Text));
      Write(RPS035T2File, Take(3, FieldByName('PropClass').Text));
      Write(RPS035T2File, Take(1, FieldByName('OwnershipCode').Text));
      Write(RPS035T2File, Take(1, FieldByName('HomesteadCode').Text));
      Write(RPS035T2File, ShiftRightAddZeroes(Take(3, FieldByName('NoParcels').Text)));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('LandAssessedVal').Text, 12, 0));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('TotAssessedVal').Text, 12, 0));
        {FXX12011998-3: If the sale status code is 'A', send as 'T'.}

      SaleStatusCode := FieldByName('SaleStatusCode').Text;

      If (SaleStatusCode = 'A')
        then SaleStatusCode := 'T';

      Write(RPS035T2File, Take(1, SaleStatusCode));  {Sale status code}
      Writeln(RPS035T2File, Copy(FieldByName('SaleAssessmentYear').Text, 3, 2));

        {Now extract to the T1 file if this is a sale with status
         'A', 'R', 'M'.}
        {CHG04292009-2(2.20.1.1)[F912]: Option to supress inventory on sales transmittal.}

      If (FieldByName('SaleStatusCode').Text[1] in ['A', 'R', 'M'])
        then ExtractInformationForOneSale(RPS035T1File,
                                          SalesTable,
                                          ParcelTable,
                                          AssessmentTable,
                                          AssessmentYearCtlTable,
                                          FieldByName('SwisSBLKey').Text,
                                          OldSwisSBLKey,
                                          GlblUseOldParcelIDsForSales,
                                          FieldByName('SaleNumber').AsInteger,
                                          bIncludeInventoryOnTransmittal, False, True);

        {FXX10091998-9: Need to actually add up the number of sites.}

      ResidentialCnt := ResidentialCnt +
                        CalculateNumSites(ResSiteTable, '',
                                          FieldByName('SwisSBLKey').Text,
                                          FieldByName('SaleNumber').AsInteger,
                                          True);

      CommercialCnt := CommercialCnt +
                        CalculateNumSites(ComSiteTable, '',
                                          FieldByName('SwisSBLKey').Text,
                                          FieldByName('SaleNumber').AsInteger,
                                          True);

    end;  {with SalesTable do}

end;  {WriteExtractRecords}

{=================================================================}
Procedure TRptSalesReportingForm.PrintSalesTotals(Sender : TObject;
                                                  SalesTotals : TStringList;
                                                  SwisCode : String);

{FXX12021999-2: Add totals for non-transmitted reports.}

var
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      If ((LinesLeft - SalesTotals.Count - 4) < 8)
        then NewPage;

      ClearTabs;
      SetTab(0.6, pjLeft, 4.0, 0, BOXLINEBottom, 0);   {Status}

      Println('');
      If (Deblank(SwisCode) = '')
        then Println(#9 + 'GRAND TOTALS')
        else Println(#9 + 'SWIS TOTALS (' + SwisCode + ')');
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {Status}
      SetTab(1.0, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Count}

      Println(#9 + 'Status' +
              #9 + 'Count');

      ClearTabs;
      SetTab(0.3, pjCenter, 0.6, 0, BOXLINENone, 0);   {Status}
      SetTab(1.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Count}

      For I := 0 to (SalesTotals.Count - 1) do
        Println(#9 + SalesTotals[I][1] +
                #9 + Copy(SalesTotals[I], 2, 10));

    end;  {with Sender as TBaseReport do}

end;  {PrintSalesTotals}

{=================================================================}
Procedure TRptSalesReportingForm.TextReportPrint(Sender: TObject);

var
  TransmittalTotalsRec : PRPSExtractRec;
  PreviousSwisCode, SaleStatus,
  ControlNumber, SwisSBLKey,
  SaleStatusCode, OldSwisSBLKey,
  FormattedOldSwisSBLKey,
  FrontStr, DepthStr, AcresStr : String;
  FirstTimeThrough, Done,
  FoundSaleStatus, PrintDeedPageBookColumn : Boolean;
  I, J, Index : Integer;
  NumFound, SaleCount, TotalSaleCount : LongInt;
  SalesThisSwisCode, SalesGrandTotal : TStringList;
  SBLRec : SBLRecord;

begin
  NumFound := 0;
  TotalSaleCount := 0;
  Index := 0;

   {if this is sales xmittal, must create RPS035T2 file}

  If XmitCheckBox.Checked
    then ProgressDialog.CancelButtonVisible := False
    else ProgressDialog.CancelButtonVisible := True;

    {CHG03101999-1: Send info to a list or load from a list.}

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

    {FXX12021999-2: Add totals for non-transmitted reports.}

  SalesThisSwisCode := TStringList.Create;
  SalesGrandTotal := TStringList.Create;

  with Sender as TBaseReport do
    begin
      Done := False;
      FirstTimeThrough := True;
      PreviousSwisCode := Copy(SalesTable.FieldByName('SwisSBLKey').Text, 1, 6);
      CurrentSwisCode := Copy(SalesTable.FieldByName('SwisSBLKey').Text, 1, 6);
      SalesTable.First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SalesTable.Next;

        TotalSalesRecordCnt := TotalSalesRecordCnt + 1;

        If (SalesTable.FieldByName('SaleStatusCode').Text = 'I')
          then IncompleteSalesCnt := IncompleteSalesCnt + 1;

        If SalesTable.EOF
          then Done := True;

        ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumFound);
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SalesTable.FieldByName('SwisSBLKey').Text));
        Application.ProcessMessages;
        CurrentSwisCode := Copy(SalesTable.FieldByName('SwisSBLKey').Text, 1, 6);

          {FXX12021999-2: Add totals for non-transmitted reports.}

        If ((PrintOrder = poSwisSBLKey) and
            (Done or
             (PreviousSwisCode <> CurrentSwisCode)) and
            (SalesThisSwisCode.Count > 0) and
            (not TransmitReport))
          then
            begin
              PrintSalesTotals(Sender, SalesThisSwisCode, PreviousSwisCode);

                {Update the overall totals.}
                {Stored as status code + count.}

              For I := 0 to (SalesThisSwisCode.Count - 1) do
                begin
                  SaleStatus := SalesThisSwisCode[I][1];
                  SaleCount := StrToInt(Copy(SalesThisSwisCode[I], 2, 10));

                  FoundSaleStatus := False;
                  For J := 0 to (SalesGrandTotal.Count - 1) do
                    If (SalesGrandTotal[J][1] = SaleStatus)
                      then
                        begin
                          FoundSaleStatus := True;
                          Index := J;
                          TotalSaleCount := StrToInt(Copy(SalesGrandTotal[J], 2, 10))

                        end;  {For J := 0 to (SalesGrandTotal.Count - 1) do}

                  If not FoundSaleStatus
                    then
                      begin
                        SalesGrandTotal.Add(SaleStatus);
                        Index := SalesGrandTotal.IndexOf(SaleStatus);
                        TotalSaleCount := 0;
                      end;  {If not FoundSaleStatus}

                  TotalSaleCount := TotalSaleCount + SaleCount;
                  SalesGrandTotal[Index] := SaleStatus + IntToStr(TotalSaleCount);

                end;  {For I := 0 to (SalesThisSwisCode.Count - 1) do}

              If not Done
                then
                  begin
                    NewPage;
                    SalesThisSwisCode.Clear;

                  end;  {If not Done}

            end;  {If (Done or ...}

        If ((not Done) and
            RecordInRange)
          then
            with SalesTable do
              begin
                If ((not Done) and
                    (LinesLeft < 4))
                  then NewPage;

                NumFound := NumFound + 1;
                  {FXX07011999-1: Need logic to print to parcel list.}

                If CreateParcelList
                  then ParcelListDialog.AddOneParcel(FieldByName('SwisSBLKey').Text);

                  {CHG04062000-1: Use old parcel ID in sales.}

                SBLRec := ExtractSwisSBLFromSwisSBLKey(FieldByName('SwisSBLKey').Text);

                with SBLRec do
                  FindKeyOld(ParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot', 'Sublot',
                              'Suffix'],
                             [GlblNextYear, SwisCode, Section,
                              Subsection, Block, Lot,
                              Sublot, Suffix]);

                If GlblUseOldParcelIDsForSales
                  then
                    begin
                      If (Length(Trim(ParcelTable.FieldByName('RemapOldSBL').Text)) = 26)  {Was it matched?}
                        then
                          begin
                            OldSwisSBLKey := ParcelTable.FieldByName('RemapOldSBL').Text;
                            FormattedOldSwisSBLKey := ConvertSwisSBLToOldDashDotNoSwis(OldSwisSBLKey,
                                                                                       AssessmentYearCtlTable);
                          end
                        else
                          begin
                            OldSwisSBLKey := FieldByName('SwisSBLKey').Text;  {Not matched yet}
                            FormattedOldSwisSBLKey := ConvertSBLOnlyToDashDot(Copy(OldSwisSBLKey, 7, 20));
                          end;  {else of If (Length(Trim(ParcelTable...}

                    end
                  else
                    begin
                      OldSwisSBLKey := FieldByName('SwisSBLKey').Text;
                      FormattedOldSwisSBLKey := ConvertSBLOnlyToDashDot(Copy(OldSwisSBLKey, 7, 20));

                    end;  {else of If GlblUseOldParcelIDsForSales}

                FrontStr := '';
                DepthStr := '';
                AcresStr := '';

                SwisSBLKey := FieldByName('SwisSBLKey').Text;
                If (_PrintLabels and
                    (ParcelListForLabels.IndexOf(SwisSBLKey) = -1))
                  then ParcelListForLabels.Add(SwisSBLKey);

                  {CHG01282009(2.16.1.17): Option to show all dimensions on the report.}

                If (bPrintAllDimensions or
                    (_Compare(FieldByName('Frontage').AsFloat, 0, coGreaterThan) or
                     _Compare(FieldByName('Depth').AsFloat, 0, coGreaterThan)))
                  then
                    begin
                      FrontStr := FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat);
                      DepthStr := FormatFloat(DecimalDisplay, FieldByName('Depth').AsFloat);
                    end;

                If (bPrintAllDimensions or
                    (_Compare(FieldByName('Frontage').AsFloat, 0, coEqual) and
                     _Compare(FieldByName('Depth').AsFloat, 0, coEqual)))
                  then AcresStr := FormatFloat(DecimalDisplay, FieldByName('Acreage').AsFloat);

                  {FXX12011998-3: If the sale status code is 'A', send as 'T'.}

                SaleStatusCode := FieldByName('SaleStatusCode').Text;

                If (TransmitReport and
                    (SaleStatusCode = 'A'))
                  then SaleStatusCode := 'T';

                  {CHG11182003-2(2.07k): Option to print the condition codes instead of the control #.}

                  {CHG01162005-1(2.8.3.1)[2011]: Print the control # if they are a
                                                 control # municipality.}

                PrintDeedPageBookColumn := True;

                If PrintConditionCodes
                  then
                    begin
                      If GlblUseControlNumInsteadOfBook_Page
                        then
                          begin
                            Print(#9 + FieldByName('ControlNo').Text);
                            PrintDeedPageBookColumn := False;
                          end;

                      Print(#9 + FieldByName('SaleConditionCode').Text);

                    end
                  else
                    If (DezeroOnLeft(FieldByName('ControlNo').Text) = '')
                      then Print(#9)
                      else Print(#9 + FieldByName('ControlNo').Text);

                If PrintDeedPageBookColumn
                  then Print(#9 + FieldByName('DeedBook').Text);

                Println(#9 + FormattedOldSwisSBLKey +
                        #9 + FieldByName('SaleNumber').Text +
                        #9 + Take(18, FieldByName('NewOwnerName').Text) +
                        #9 + FrontStr +
                        #9 + DepthStr +
                        #9 + FieldByName('SaleDate').Text +
                        #9 + FieldByName('RollSection').Text +
                        #9 + FieldByName('SchoolDistcode').Text +
                        #9 + FieldByName('HomeSteadcode').Text +
                        #9 + FormatFloat(CurrencyNormalDisplay,
                               (FieldByName('LandAssessedVal').AsFloat)) +
                        #9 + Copy(FieldByName('SaleAssessmentYear').Text,3,2) +
                        #9 + RTrim(FieldByName('SaleStatusCode').Text));

                  {FXX02081999-5: Add the legal address to the sales report.}
                  {CHG01162005-1(2.8.3.1)[2011]: Print the control # if they are a
                                                 control # municipality.}

                Print(#9 + FieldByName('DeedDate').Text);

                If PrintDeedPageBookColumn
                  then Print(#9 + FieldByName('DeedPage').Text)
                  else Print(#9);

                Println(#9 + Take(15, GetLegalAddressFromTable(SalesTable)) +
                        #9 +
                        #9 + Take(18, FieldByName('OldOwnerName').Text) +
                        #9 + AcresStr +
                        #9 +
                        #9 + FormatFloat(CurrencyNormalDisplay,
                                         FieldByName('SalePrice').AsFloat) +
                        #9 + BoolToChar_0_1(FieldByName('ValidSale').AsBoolean) +
                        #9 + SaleStatusCode +
                             '  ' + FieldByName('PropClass').Text +
                        #9 + FieldByName('NoParcels').Text +
                        #9 + FormatFloat(CurrencyNormalDisplay,
                             FieldByName('TotAssessedVal').AsFloat));

                  {CHG04062000-1: Use old parcel ID in sales.}

                If GlblUseOldParcelIDsForSales
                  then Println(#9 + #9 +
                               #9 + ConvertSBLOnlyToDashDot(Copy(FieldByName('SwisSBLKey').Text, 7, 20)));

                If GlblPrintAccountNumbersOnReports
                  then Println(#9 + #9 +
                               #9 + FieldByName('AccountNo').Text);

                Println('');  {space one line between parcels}

                If TransmitReport
                  then WriteExtractRecords(OldSwisSBLKey, FormattedOldSwisSBLKey);

                  {CHG07222003-2(2.07g): Add Excel capabilities to sales report.}

                If PrintToExcel
                  then
                    begin
                      If (DezeroOnLeft(FieldByName('ControlNo').Text) = '')
                        then ControlNumber := ''
                        else ControlNumber := FieldByName('ControlNo').AsString;

                        {CHG10272010(2.26.1.18)[I8222]: Add the Swis code to the extract.}

                      WriteCommaDelimitedLine(ExtractFile, [CurrentSwisCode,
                                                            FormattedOldSwisSBLKey]);

                        {CHG11182003-2(2.07k): Option to print the condition codes instead of the control #.}

                      If PrintConditionCodes
                        then WriteCommaDelimitedLine(ExtractFile, [FieldByName('SaleConditionCode').AsString])
                        else WriteCommaDelimitedLine(ExtractFile, [ControlNumber]);

                      WriteCommaDelimitedLine(ExtractFile,
                                              [FieldByName('DeedBook').AsString,
                                               FieldByName('DeedPage').AsString,
                                               FieldByName('DeedDate').AsString,
                                               GetLegalAddressFromTable(SalesTable),
                                               FieldByName('LegalAddrNo').AsString,
                                               FieldByName('LegalAddr').AsString,
                                               FieldByName('SaleNumber').AsString,
                                               FieldByName('NewOwnerName').AsString,
                                               FieldByName('OldOwnerName').AsString,
                                               FieldByName('SaleDate').AsString,
                                               FieldByName('SalePrice').AsString,
                                               BoolToChar_0_1(FieldByName('ValidSale').AsBoolean),
                                               FieldByName('SaleStatusCode').AsString,
                                               FieldByName('SaleAssessmentYear').AsString,
                                               FieldByName('NoParcels').AsString,
                                               FieldByName('LandAssessedVal').AsString,
                                               FieldByName('TotAssessedVal').AsString,
                                               FrontStr,
                                               DepthStr,
                                               AcresStr,
                                               FieldByName('RollSection').AsString,
                                               FieldByName('PropClass').AsString,
                                               FieldByName('SchoolDistcode').AsString,
                                               FieldByName('HomeSteadcode').AsString,
                                               FieldByName('AccountNo').AsString,
                                               ParcelTable.FieldByName('RemapOldSBL').AsString,
                                               ParcelTable.FieldByName('AdditionalLots').AsString]);

                      If (bExtractInventory and
                          _Locate(tbSalesResidentialSites,
                                  [FieldByName('SwisSBLKey').AsString, FieldByName('SaleNumber').AsString,
                                   1], '', []))
                        then
                          begin
                            If _Locate(tbSalesResidentialBuildings,
                                       [FieldByName('SwisSBLKey').AsString, FieldByName('SaleNumber').AsString,
                                        1], '', [])
                              then
                                begin
                                  with tbSalesResidentialBuildings do
                                    WriteCommaDelimitedLine(ExtractFile,
                                                            [FieldByName('NumberOfBathrooms').AsString,
                                                             FieldByName('NumHalfBathrooms').AsString,
                                                             FieldByName('NumberOfBedrooms').AsString,
                                                             FieldByName('NumberOfFireplaces').AsString,
                                                             FieldByName('NumberOfKitchens').AsString,
                                                             FieldByName('NumberOfRooms').AsString,
                                                             FieldByName('NumberOfStories').AsString,
                                                             FieldByName('PercentGood').AsString,
                                                             FieldByName('HalfStoryArea').AsString,
                                                             FieldByName('FirstStoryArea').AsString,
                                                             FieldByName('SecondStoryArea').AsString,
                                                             FieldByName('ThreeQuarterStoryAre').AsString,
                                                             FieldByName('ThirdStoryArea').AsString,
                                                             FieldByName('AttachedGarCapacity').AsString,
                                                             FieldByName('BathroomQualityCode').AsString,
                                                             FieldByName('BuildingStyleCode').AsString,
                                                             FieldByName('BasementGarCapacity').AsString,
                                                             FieldByName('DetachedGarCapacity').AsString,
                                                             FieldByName('BasementTypeCode').AsString,
                                                             FieldByName('CentralAir').AsString,
                                                             FieldByName('ConditionCode').AsString,
                                                             FieldByName('ExtWallMaterialCode').AsString,
                                                             FieldByName('FinishedAtticArea').AsString,
                                                             FieldByName('FinishedBasementArea').AsString,
                                                             FieldByName('FinishedAreaOverGara').AsString,
                                                             FieldByName('FinishedRecRoom').AsString,
                                                             FieldByName('FuelTypeCode').AsString,
                                                             FieldByName('FunctionalObsolescen').AsString,
                                                             FieldByName('OverallGradeCode').AsString,
                                                             FieldByName('GradeAdjustment').AsString,
                                                             FieldByName('HeatTypeCode').AsString,
                                                             FieldByName('KitchenQualityCode').AsString,
                                                             FieldByName('PorchArea').AsString,
                                                             FieldByName('PorchTypeCode').AsString,
                                                             FieldByName('ReplacementCostNew').AsString,
                                                             FieldByName('RCNLessDepreciation').AsString,
                                                             FieldByName('SqFootLivingArea').AsString,
                                                             FieldByName('UnfinishedHalfStory').AsString,
                                                             FieldByName('Unfinished3_4Story').AsString,
                                                             FieldByName('UnfinishedRoom').AsString,
                                                             FieldByName('ActualYearBuilt').AsString]);
                                end
                              else WriteCommaDelimitedLine(ExtractFile,
                                                           ['',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '']);

                            with tbSalesResidentialSites do
                              WriteCommaDelimitedLine(ExtractFile,
                                                      [FieldByName('D_CEntryTypeCode').AsString,
                                                       FieldByName('DesirabilityCode').AsString,
                                                       FieldByName('ElevationCode').AsString,
                                                       FieldByName('FinalLandValue').AsString,
                                                       FieldByName('FinalTotalValue').AsString,
                                                       FieldByName('LandValue').AsString,
                                                       FieldByName('MarketEstimate').AsString,
                                                       FieldByName('ModelEstimate').AsString,
                                                       FieldByName('NghbrhdRatingCode').AsString,
                                                       FieldByName('NeighborhoodCode').AsString,
                                                       FieldByName('NghbrhdTypeCode').AsString,
                                                       FieldByName('PhysicalChangeCode').AsString,
                                                       FieldByName('PropertyClassCode').AsString,
                                                       FieldByName('RCNLessDepreciation').AsString,
                                                       FieldByName('ReplacementCost').AsString,
                                                       FieldByName('RoadTypeCode').AsString,
                                                       FieldByName('RouteNumber').AsString,
                                                       FieldByName('SewerTypeCode').AsString,
                                                       FieldByName('TrafficCode').AsString,
                                                       FieldByName('UtilityTypeCode').AsString,
                                                       FieldByName('WaterSupplyCode').AsString,
                                                       FieldByName('ZoningCode').AsString]);

                            If _Locate(tbSalesResidentialLands,
                                       [FieldByName('SwisSBLKey').AsString, FieldByName('SaleNumber').AsString,
                                        1, 1], '', [])
                              then
                                begin
                                  with tbSalesResidentialLands do
                                    WriteCommaDelimitedLine(ExtractFile,
                                                            [FieldByName('LandTypeCode').AsString,
                                                             FieldByName('Frontage').AsString,
                                                             FieldByName('Depth').AsString,
                                                             FieldByName('Acreage').AsString,
                                                             FieldByName('SoilRatingCode').AsString,
                                                             FieldByName('InfluenceCode').AsString,
                                                             FieldByName('WaterfrontTypeCode').AsString]);
                                end
                              else WriteCommaDelimitedLine(ExtractFile,
                                                           ['',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '',
                                                            '']);

                              {CHG032302010(2.22.2.6)[I7219]: Include the residential structures in the sales extract.}

                            _SetRange(tbSalesResidentialImprovements,
                                      [FieldByName('SwisSBLKey').AsString, FieldByName('SaleNumber').AsString, 1, 1],
                                      [FieldByName('SwisSBLKey').AsString, FieldByName('SaleNumber').AsString, 99, 99],
                                      '', []);

                            with tbSalesResidentialImprovements do
                            begin
                              First;

                              while not EOF do
                              begin
                                WriteCommaDelimitedLine(ExtractFile,
                                                        [FieldByName('StructureCode').AsString,
                                                         FieldByName('YearBuilt').AsString,
                                                         FieldByName('MeasureCode').AsString,
                                                         FieldByName('Dimension1').AsInteger,
                                                         FieldByName('Dimension2').AsInteger,
                                                         FieldByName('Quantity').AsInteger,
                                                         FieldByName('GradeCode').AsString,
                                                         FieldByName('ConditionCode').AsString]);

                                Next;

                              end;  {while not EOF do}

                            end;  {with tbSalesResidentialImprovements do}

                            WritelnCommaDelimitedLine(ExtractFile, []);

                          end  {If bExtractInventory}
                        else WritelnCommaDelimitedLine(ExtractFile, []);

                    end;  {If PrintToExcel}

                  {Update the swis sales totals.}
                  {FXX12021999-2: Add totals for non-transmitted reports.}

                SaleStatus := RTrim(FieldByName('SaleStatusCode').Text);

                FoundSaleStatus := False;
                For I := 0 to (SalesThisSwisCode.Count - 1) do
                  If (SalesThisSwisCode[I][1] = SaleStatus)
                    then
                      begin
                        FoundSaleStatus := True;
                        Index := I;
                        TotalSaleCount := StrToInt(Copy(SalesThisSwisCode[I], 2, 10))

                      end;  {For I := 0 to (SalesThisSwisCode.Count - 1) do}

                If not FoundSaleStatus
                  then
                    begin
                      SalesThisSwisCode.Add(SaleStatus);
                      Index := SalesThisSwisCode.IndexOf(SaleStatus);
                      TotalSaleCount := 0;
                    end;  {If not FoundSaleStatus}

                SalesThisSwisCode[Index] := SaleStatus + IntToStr(TotalSaleCount + 1);

              end;  {with SalesTable do}

        PreviousSwisCode := Copy(SalesTable.FieldByName('SwisSBLKey').Text, 1, 6);

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or ReportCancelled);

        {FXX12021999-2: Add totals for non-transmitted reports.}

      If not TransmitReport
        then PrintSalesTotals(Sender, SalesGrandTotal, '');
      SalesThisSwisCode.Free;
      SalesGrandTotal.Free;

        {Write out totals for transmittal report and files.}

      If TransmitReport
        then
          begin
            NewPage;
            CRLF;
            CRLF;
            ClearTabs;

            ClearTabs;
            SetTab(0.5, pjLeft, 2.5, 0, BOXLINENONE, 0);   {totals prose}
            SetTab(3.5, pjLeft, 0.5, 0, BOXLINENONE, 0);   {count column}
            SetTab(5.0, pjLeft, 3.0, 0, BOXLINENONE, 0);   {Prose column}

            Println(#9 + '* * * * TOTALS FOR ' +  Copy(CurrentSwisCode, 1, 4) + ' * * * *' +
                    #9 +
                    #9 + 'AUTHORIZED AGENT (ASSESSOR OR COUNTY DIRECTOR)');
            Println(#9 + #9 + #9  +'PLEASE COMPLETE THE FOLLOWING');
            Println(#9 + 'SALES TRANSMITTED:' +
                    #9 + IntToStr(TotalSalesXmittedCnt) +
                    #9 + '----------------------------------------------------');
            Println('');
            Println(#9 + 'RESIDENTIAL INV RECORDS: ' +
                    #9 + IntToStr(ResidentialCnt) +
                    #9 + '1. I CERTIFY THAT, TO THE BEST OF MY KNOWLEDGE, ALL ITEMS');
            Println(#9 + #9 +
                    #9 + '   OF INFORMATION ENTERED ON THE ENCLOSED EA-5217 (SALES');
            Println(#9 + 'COMMERCIAL INV RECORDS: ' +
                    #9 + IntToStr(CommercialCnt) +
                    #9 + '   TRANSMITTAL FILE) ARE TRUE AND CORRECT.');
            Println('');
            Println('');
            Println(#9 + #9 +
                    #9 + '   SIGNATURE:___________________________________________');
            Println('');
            Println(#9 + '100''s - AGRICULTURE ' +
                    #9 + IntToStr(PClassCntArray[1]) +
                    #9 + '   TITLE:___________________________________________________');
            Println('');
            Println(#9 + '200''s - RESIDENTIAL ' +
                    #9 + IntToStr(PClassCntArray[2]) +
                    #9 + '   DATE: ___________________________________________________');
            Println('');
            Println(#9 + '300''s - VACANT LAND ' +
                    #9 + IntToStr(PClassCntArray[3]));
            Println('');
            Println(#9 + '400''s - COMMERCIAL  ' +
                    #9 + IntToStr(PClassCntArray[4]) +
                    #9 + '2. FOR FURTHER INFORMATION CONTACT:' );
            Println('');
            Println(#9 + '500''s - AMUSEMENT   ' +
                    #9 + IntToStr(PClassCntArray[5]) );
            Println('');
            Println(#9 + '600''s - COMMUNITY SERVICE' +
                    #9 + IntToStr(PClassCntArray[6]) +
                    #9 + '   NAME: ___________________________________________________');
            Println('');
            Println(#9 + '700''s - INDUSTRIAL ' +
                    #9 + IntToStr(PClassCntArray[7]) +
                    #9 + '   TELEPHONE: (______) _____________________________________________');
            Println('');
            Println(#9 + '800''s - PUBLIC SERVICE' +
                    #9 + IntToStr(PClassCntArray[8]));
            Println('');
            Println(#9 + '900''s - WILD & FORESTED' +
                    #9 + IntToStr(PClassCntArray[9]) +
                    #9 + '3. IF THE CORRECTED SALES REPORT IS ENCLOSED,');
            Println(#9 + #9 +
                    #9 + '   PLEASE ENCLOSE AN EXPLANATION FOR ANY SALES');
            Println(#9 + #9 +
                    #9 + '   WHERE CONDITION CODE ''I'' IS INDICATED (OTHER');
            Println(#9 + #9 +
                    #9 + '   UNUSUAL FACTORS AFFECTING SALE PRICE).');

              {now print final page summary}

            PrintFinalPageHeader := True;  {print spcl final pg hdr}
            NewPage;
            CRLF;
            CRLF;
            ClearTabs;

            ClearTabs;
            SetTab(0.5, pjLeft, 2.5, 0, BOXLINENONE, 0);   {totals prose}
            SetTab(3.5, pjLeft, 0.5, 0, BOXLINENONE, 0);   {count column}
            SetTab(5.0, pjLeft, 3.0, 0, BOXLINENONE, 0);   {Prose column}

            Println(#9 + 'SALES RECORDS READ:' +
                    #9 + IntToStr(TotalSalesRecordCnt));
            Println('');
            Println(#9 + 'SALES TRANSMITTED:' +
                    #9 + IntToStr(TotalSalesXmittedCnt));
            Println('');
            Println(#9 + 'INCOMPLETE SALES ON MASTER:' +
                    #9 + IntToStr(IncompleteSalesCnt));
            Println('');

                 {FXX06231998-1: Write out the totals record to the T1 file.}

            New(TransmittalTotalsRec);
            InitializeRPSExtractString(TransmittalTotalsRec);
            RPSExtractStrCat(TransmittalTotalsRec, Take(4, CurrentSwisCode) + '99');
            RPSExtractStrCat(TransmittalTotalsRec,
                             ShiftRightAddZeroes(Take(6, IntToStr(TotalSalesXmittedCnt))));
            RPSExtractStrCat(TransmittalTotalsRec,
                             ShiftRightAddZeroes(Take(6, IntToStr(ResidentialCnt))));
            RPSExtractStrCat(TransmittalTotalsRec,
                             ShiftRightAddZeroes(Take(6, IntToStr(CommercialCnt))));
            For I := 1 to 10 do
              RPSExtractStrCat(TransmittalTotalsRec,
                               ShiftRightAddZeroes(Take(6, IntToStr(PClassCntArray_Condo[I]))));

            RPSExtractStrCat(TransmittalTotalsRec, Take(15, 'PAS'));
            RPSExtractStrCat(TransmittalTotalsRec, Take(255, ''));
            RPSExtractStrCat(TransmittalTotalsRec, Take(255, ''));
            RPSExtractStrCat(TransmittalTotalsRec, Take(213, ''));

            WriteOneRPSExtractRecToFile(RPS035T1File, TransmittalTotalsRec, '', False);
            Dispose(TransmittalTotalsRec);

          end;  {If TransmitReport}

    end;  {with Sender as TBaseReport do}

    {if this is a transmittal, we must post A's & R's to T's in sales file}
    {posting is done after the print file is created so there is a record}
    {of what should have gotten posted if this posting loop fails}

  If TransmitReport
    then
      begin
         {get code description for 'T'}

        FindKeyOld(SalesStatusTable, ['MainCode'], ['T']);

        SalesTable.First;

        FirstTimeThrough := True;
        Done := False;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SalesTable.Next;

          If SalesTable.EOF
            then Done := True;

          If ((not Done) and
              RecordInRange)
            then
              with SalesTable do
                try
                  Edit;
                    {FXX04071999-2: Store transmitted date and code.}

                  FieldByName('DateTransmitted').AsDateTime := Date;
                  FieldByName('PriorStatusCode').Text := FieldByName('SaleStatusCode').Text;
                  FieldByName('SaleStatusCode').Text := 'T';
                  FieldByName('SaleStatusDesc').Text := SalesStatusTableDescription.Text;

                  Post;
                except
                  SystemSupport(002, SalesTable, 'Error Updating Sales Status to Xmitted.',
                              UnitName, GlblErrorDlgBox);
                  Done := True;
                end;

        until Done;

      end;  {If TransmitReport}

end;  {TextReportPrint}

{=============================================================}
Procedure TRptSalesReportingForm.ReportPrint(Sender: TObject);

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

{==================================================================}
Procedure TRptSalesReportingForm.ReportLabelPrintHeader(Sender: TObject);


begin
  PrintLabelHeader(Sender, LabelOptions);
end;  {ReportLabelPrintHeader}

{==================================================================}
Procedure TRptSalesReportingForm.ReportLabelPrint(Sender: TObject);

begin
  PrintLabels(Sender, ParcelListForLabels, ParcelTable,
              SwisCodeTable, AssessmentYearControlTable,
              GlblNextYear, LabelOptions);
end;  {ReportLabelPrint}

{===================================================================}
Procedure TRptSalesReportingForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TRptSalesReportingForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  SelectedSchoolCodes.Free;
  SelectedSwisCodes.Free;
  SelectedPropertyClassCodes.Free;

  CloseTablesForForm(Self);
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;

  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.