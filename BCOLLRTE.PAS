unit Bcollrte;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,PasTypes,types,
  wwdblook, Mask, TabNotBk, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter,
  RPMemo, RPDBUtil, ComCtrls;

type
  TBillRatesForm = class(TForm)
    BillCtlDataSource: TwwDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    BillCollTypeLookupTable: TwwTable;
    CollectionLookupTable: TwwTable;
    SDistRateTable: TwwTable;
    SDistDataSource: TwwDataSource;
    GeneralRateDataSource: TwwDataSource;
    SwissCdLookUpTable: TwwTable;
    SchoolCdLookupTable: TwwTable;
    SDCodeLookupTable: TwwTable;
    SDExtCdLookupTable: TwwTable;
    SpclFeeDataSource: TwwDataSource;
    SpclFeeTable: TwwTable;
    GenRateTaxTypeLUpTable: TwwTable;
    SpclFeeLookupTable: TwwTable;
    SwissCdLookUpTableMunicipalityName: TStringField;
    SwissCdLookUpTableClassified: TBooleanField;
    GeneralRateLookupTable: TTable;
    NotebookChangeTimer: TTimer;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    Label29: TLabel;
    CollDtlTable: TwwTable;
    CollDtlTableSwisCode: TStringField;
    CollDtlTableSchoolCode: TStringField;
    CollDtlTableStartingBillno: TIntegerField;
    CollDtlTableTaxRollYr: TStringField;
    CollDtlTableCollectionType: TStringField;
    CollDtlTableCollectionNo: TSmallintField;
    BillCollArrearsTable: TwwTable;
    BillCollArrearsTableTaxRollYr: TStringField;
    BillCollArrearsTableCollectionType: TStringField;
    BillCollArrearsTableCollectionNo: TSmallintField;
    BillCollArrearsTableArrearsMessage: TMemoField;
    SDRateLookupTable: TTable;
    GeneralRateTable: TwwTable;
    SDistRateTableTaxRollYr: TStringField;
    SDistRateTableCollectionType: TStringField;
    SDistRateTableCollectionNo: TIntegerField;
    SDistRateTableSDistCode: TStringField;
    SDistRateTableSDistDescr: TStringField;
    SDistRateTableExtCode: TStringField;
    SDistRateTableSDistExtDescr: TStringField;
    SDistRateTableCMFlag: TStringField;
    SDistRateTableHomesteadRate: TFloatField;
    SDistRateTableNonhomesteadRate: TFloatField;
    SDistRateTablePriorTaxLevy: TIntegerField;
    SDistRateTableCurrentTaxLevy: TIntegerField;
    GeneralRateTableTaxRollYr: TStringField;
    GeneralRateTableCollectionType: TStringField;
    GeneralRateTableCollectionNo: TIntegerField;
    GeneralRateTablePrintOrder: TIntegerField;
    GeneralRateTableGeneralTaxType: TStringField;
    GeneralRateTableSwisCode: TStringField;
    GeneralRateTableSchoolCode: TStringField;
    GeneralRateTableDescription: TStringField;
    GeneralRateTableHomesteadRate: TFloatField;
    GeneralRateTableNonhomesteadRate: TFloatField;
    GeneralRateTablePriorTaxLevy: TIntegerField;
    GeneralRateTableCurrentTaxLevy: TIntegerField;
    GeneralRateTableEstimatedStateAid: TIntegerField;
    CollectionLookupTableTaxRollYr: TStringField;
    CollectionLookupTableCollectionType: TStringField;
    CollectionLookupTableCollectionNo: TIntegerField;
    CollectionLookupTableNumberOfPayments: TIntegerField;
    CollectionLookupTableCollectionTitle: TStringField;
    CollectionLookupTablePayDate1: TDateField;
    CollectionLookupTablePayDate2: TDateField;
    CollectionLookupTablePayDate3: TDateField;
    CollectionLookupTablePayDate4: TDateField;
    CollectionLookupTablePayDate5: TDateField;
    CollectionLookupTablePayDate6: TDateField;
    CollectionLookupTablePayDate7: TDateField;
    CollectionLookupTablePayDate8: TDateField;
    CollectionLookupTablePenPercent1: TFloatField;
    CollectionLookupTablePenPercent2: TFloatField;
    CollectionLookupTablePenPercent3: TFloatField;
    CollectionLookupTablePenPercent4: TFloatField;
    CollectionLookupTablePenPercent5: TFloatField;
    CollectionLookupTablePenPercent6: TFloatField;
    CollectionLookupTablePenPercent7: TFloatField;
    CollectionLookupTablePenPercent8: TFloatField;
    CollectionLookupTableCalculationComplete: TBooleanField;
    CollectionLookupTableSDApplicationOption: TIntegerField;
    CollectionLookupTablePennyDistOption: TIntegerField;
    CollectionLookupTableUseMinimumPayment: TBooleanField;
    CollectionLookupTableMinPaymentAmount: TIntegerField;
    CollectionLookupTableUseMaximumPayment: TBooleanField;
    CollectionLookupTableMaxPaymentAmount: TIntegerField;
    CollectionLookupTableSpFeeApplicOption: TIntegerField;
    CollectionLookupTableBillingOrder: TIntegerField;
    CollectionLookupTableNumberRS9AfterBase: TBooleanField;
    CollectionLookupTableUseArrearsFlag: TBooleanField;
    CollectionLookupTableRS9BankCode: TStringField;
    GeneralRateTableApplyStar: TBooleanField;
    SpclFeeTableTaxRollYr: TStringField;
    SpclFeeTableCollectionType: TStringField;
    SpclFeeTableCollectionNo: TIntegerField;
    SpclFeeTablePrintOrder: TIntegerField;
    SpclFeeTableDescription: TStringField;
    SpclFeeTableFixedAmount: TFloatField;
    SpclFeeTablePercentage: TFloatField;
    SpclFeeTableAmtInFirstPayment: TBooleanField;
    SpclFeeTableAmtDistribAllPayment: TBooleanField;
    SpclFeeTablePriorTaxLevy: TIntegerField;
    SpclFeeTableCurrentTaxLevy: TIntegerField;
    SwissCdLookUpTableSwisCode: TStringField;
    SwissCdLookUpTableTaxRollYr: TStringField;
    Panel3: TPanel;
    CloseButton: TBitBtn;
    PrintButton: TBitBtn;
    PrintBlankRatesCheckBox: TCheckBox;
    Panel4: TPanel;
    label16: TLabel;
    Label18: TLabel;
    Label1: TLabel;
    CollTypeDBLookupCombo: TwwDBLookupCombo;
    CollectionNumber: TEdit;
    TaxRollYr: TEdit;
    Panel5: TPanel;
    RatesNotebook: TTabbedNotebook;
    Panel6: TPanel;
    DBNavigator1: TDBNavigator;
    Panel7: TPanel;
    GeneralRateDBGrid: TwwDBGrid;
    SchCodeDBLookupCombo: TwwDBLookupCombo;
    SwisDBLookupCombo: TwwDBLookupCombo;
    GenlRateTaxtypeDBLookupCombo: TwwDBLookupCombo;
    Panel8: TPanel;
    DBNavigator2: TDBNavigator;
    Panel9: TPanel;
    SDRateDBGrid: TwwDBGrid;
    SDDBLookupCombo: TwwDBLookupCombo;
    SdExtDBLookupCombo: TwwDBLookupCombo;
    Panel10: TPanel;
    SpFeeDBNavigator: TDBNavigator;
    Panel11: TPanel;
    SpclFeeDBGrid: TwwDBGrid;
    GeneralRateTableBillPrintGroup: TStringField;
    GeneralRateTableBillPrintGroupOrder: TStringField;
    cbxGeneralRateBillPrintGroup: TwwDBLookupCombo;
    tbBillPrintGroup: TTable;
    SDistRateTableBillPrintGroup: TStringField;
    SDistRateTableBillPrintGroupOrder: TStringField;
    btnOpenCollection: TBitBtn;
    cbxSpecialDistrictRateBillPrintGroup: TwwDBLookupCombo;
    SDCodeLookupTableTaxRollYr: TStringField;
    SDCodeLookupTableSDistCode: TStringField;
    SDCodeLookupTableDescription: TStringField;
    SDCodeLookupTableSDHomestead: TBooleanField;
    SDCodeLookupTableSDRs9: TBooleanField;
    SDCodeLookupTableDistrictType: TStringField;
    SDCodeLookupTableSection490: TBooleanField;
    SDCodeLookupTableChapter562: TBooleanField;
    SDCodeLookupTableVillagePurpose: TStringField;
    SDCodeLookupTableECd1: TStringField;
    SDCodeLookupTableECd2: TStringField;
    SDCodeLookupTableECd3: TStringField;
    SDCodeLookupTableECd4: TStringField;
    SDCodeLookupTableECd5: TStringField;
    SDCodeLookupTableECd6: TStringField;
    SDCodeLookupTableECd7: TStringField;
    SDCodeLookupTableECd8: TStringField;
    SDCodeLookupTableECd9: TStringField;
    SDCodeLookupTableECd10: TStringField;
    SDCodeLookupTableSW1: TStringField;
    SDCodeLookupTableSW2: TStringField;
    SDCodeLookupTableSW3: TStringField;
    SDCodeLookupTableSW4: TStringField;
    SDCodeLookupTableSW5: TStringField;
    SDCodeLookupTableSW6: TStringField;
    SDCodeLookupTableSW7: TStringField;
    SDCodeLookupTableSW8: TStringField;
    SDCodeLookupTableSW9: TStringField;
    SDCodeLookupTableSW10: TStringField;
    SDCodeLookupTableSW11: TStringField;
    SDCodeLookupTableSW12: TStringField;
    SDCodeLookupTableSW13: TStringField;
    SDCodeLookupTableSW14: TStringField;
    SDCodeLookupTableSW15: TStringField;
    SDCodeLookupTableSW16: TStringField;
    SDCodeLookupTableSW17: TStringField;
    SDCodeLookupTableSW18: TStringField;
    SDCodeLookupTableSW19: TStringField;
    SDCodeLookupTableSW20: TStringField;
    SDCodeLookupTableECFlg1: TStringField;
    SDCodeLookupTableECFlg2: TStringField;
    SDCodeLookupTableECFlg3: TStringField;
    SDCodeLookupTableECFlg4: TStringField;
    SDCodeLookupTableECFlg5: TStringField;
    SDCodeLookupTableECFlg6: TStringField;
    SDCodeLookupTableECFlg7: TStringField;
    SDCodeLookupTableECFlg8: TStringField;
    SDCodeLookupTableECFlg9: TStringField;
    SDCodeLookupTableECFlg10: TStringField;
    SDCodeLookupTableStep1: TFloatField;
    SDCodeLookupTableStep2: TFloatField;
    SDCodeLookupTableStep3: TFloatField;
    SDCodeLookupTableFireDistrict: TBooleanField;
    SDCodeLookupTableAppliesToSchool: TBooleanField;
    SDCodeLookupTableProRataOmit: TBooleanField;
    SDCodeLookupTableReserved: TStringField;
    SDCodeLookupTableDefaultUnits: TFloatField;
    SDCodeLookupTableDefault2ndUnits: TFloatField;
    SDCodeLookupTableVolFireAmbApplies: TBooleanField;
    SDCodeLookupTableLateralDistrict: TBooleanField;
    SDCodeLookupTableOperatingDistrict: TBooleanField;
    SDCodeLookupTableTreatmentDistrict: TBooleanField;
    SDCodeLookupTableExtensionDescription1: TStringField;
    SDCodeLookupTableExtensionGroupOrder1: TIntegerField;
    SDCodeLookupTableExtensionDescription2: TStringField;
    SDCodeLookupTableExtensionGroupOrder2: TIntegerField;
    SDCodeLookupTableExtensionDescription3: TStringField;
    SDCodeLookupTableExtensionGroupOrder3: TIntegerField;
    SDCodeLookupTableExtensionDescription4: TStringField;
    SDCodeLookupTableExtensionGroupOrder4: TIntegerField;
    SDCodeLookupTableExtensionDescription5: TStringField;
    SDCodeLookupTableExtensionGroupOrder5: TIntegerField;
    SDCodeLookupTableExtensionDescription6: TStringField;
    SDCodeLookupTableExtensionGroupOrder6: TIntegerField;
    SDCodeLookupTableExtensionDescription7: TStringField;
    SDCodeLookupTableExtensionGroupOrder7: TIntegerField;
    SDCodeLookupTableExtensionDescription8: TStringField;
    SDCodeLookupTableExtensionGroupOrder8: TIntegerField;
    SDCodeLookupTableExtensionDescription9: TStringField;
    SDCodeLookupTableExtensionGroupOrder9: TIntegerField;
    SDCodeLookupTableExtensionDescription10: TStringField;
    SDCodeLookupTableExtensionGroupOrder10: TIntegerField;
    SDCodeLookupTableBillPrintGroup: TStringField;
    grdLevyView: TwwDBGrid;
    tbSortBillLevyView: TTable;
    dsSortBillLevyView: TDataSource;
    GeneralRateTableEnhancedSTARCap: TFloatField;
    GeneralRateTableBasicSTARCap: TFloatField;
    GeneralRateTableNonHstdBasicSTARCap: TFloatField;
    GeneralRateTableNonHstdEnhancedSTARCap: TFloatField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CloseButtonClick(Sender: TObject);
    procedure RatesNotebookEnter(Sender: TObject);
    procedure CollectionNumberExit(Sender: TObject);
    procedure GeneralRateTableBeforePost(DataSet: TDataset);
    procedure GeneralRateDBGridColExit(Sender: TObject);
    procedure GeneralRateTableAfterInsert(DataSet: TDataset);
    procedure SdExtDBLookupComboExit(Sender: TObject);
    procedure SDDBLookupComboExit(Sender: TObject);
    procedure SpclFeeTableBeforePost(DataSet: TDataset);
    procedure SpclFeeDBGridColExit(Sender: TObject);
    procedure SDistRateTableBeforePost(DataSet: TDataset);
    procedure SpclFeeTableNewRecord(DataSet: TDataset);
    procedure RatesNotebookChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure SDistDataSourceDataChange(Sender: TObject; Field: TField);
    procedure NotebookChangeTimerTimer(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure ReportBeforePrint(Sender: TObject);
    procedure BillCtlDataSourceDataChange(Sender: TObject; Field: TField);
    procedure FormActivate(Sender: TObject);


  private
    { Private declarations }
  public
    CollectionNum : Integer;
    ReportCancelled, InitializingForm : Boolean;
    ReportSection : String;

    ECMArray : EcdCmArray;
    CollCtlRecFound : Boolean;  {we are working with a valid coll rec}
    CloseThisForm : Boolean;

    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    TaxRollYear : String;  {What tax roll year should we use for this collection?}
    ProcessingType : Integer;

    Procedure InitializeForm;  {Open the tables and setup.}
    Function ValidSwis(Swcode : String) : boolean;
    Procedure SetupExtArray (Var EcmArray : ECdCMArray;
                         Var Ecct : Integer);
    Function GetSDDescription (SDCode : String;
                               SDTable : TTable) : String;
    Function GetSDExtDescription (SDExtCode : String;
                               SDExtTable : TTable) : String;

    Procedure PrintGeneralSetup(Sender : TObject);
    {FXX11301999-4: Print the general setup.}

    Procedure PrintGeneralRateSection(Sender : TObject);
    {Print the general rates.}

    Procedure PrintSpecialDistrictSection(Sender : TObject);
    {Print the special district rates.}

    Procedure PrintSpecialFeeSection(Sender : TObject);
    {Print the special fees.}

    Procedure FillInLevyViewTable;
  end;


implementation

uses GlblVars, WinUtils, Utilitys,GlblCnst,PasUtils, Preview, Prog, UTILBILL, DataAccessUnit;

var
  CollectionType : String;
  PrintBlankRates : Boolean;

const
  ApplySDAmountsEqually = 0;  {Split all SD amounts between all payments.}
  ApplyMoveTaxToFirstPayment = 1;  {Apply the move tax to the 1st payment,
                                    split the rest of the SD amount equally
                                    between all payments.}
  ApplySDAmountToFirstPayment = 2; {Apply the whole SD amount to the 1st payment.}

{$R *.DFM}

{========================================================}
Procedure TBillRatesForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TBillRatesForm.InitializeForm;

var
  I : Integer;
  FirstTimeThrough, Done, HasClassifiedSwis : Boolean;

begin
  InitializingForm := True;
  RatesNoteBook.Visible := False;  {no notebook till user picks ctl record}
  CollCtlRecFound := False;  {user hasnt selected collection rec yet}
  UnitName := 'BCOLLRTE.PAS';  {mmm}

    {FXX06231998-3: Put in changes to allow for Westchester billing off NY.}

  TaxRollYear := DetermineBillingTaxYear;
  ProcessingType := GetProcessingTypeForTaxRollYear(TaxRollYear);

    {Open the tables.}

  If (FormAccessRights = raReadOnly)
    then GeneralRateTable.ReadOnly := True;  {mmm}

  OpenTablesForForm(Self, ProcessingType);

    {FXX12221997-2: If there are not two tax rates, only show
                    one field.}

  If not GlblMunicipalityUsesTwoTaxRates
    then
      begin
        GeneralRateTableNonHomesteadRate.Visible := False;
        GeneralRateTableHomesteadRate.DisplayLabel := 'Rate';
        SDistRateTableNonHomeSteadRate.Visible := False;
        SDistRateTableHomesteadRate.DisplayLabel := 'Rate';
        GeneralRateTableNonHstdBasicSTARCap.Visible := False;
        GeneralRateTableNonHstdEnhancedSTARCap.Visible := False;

      end;  {If not GlblMunicipalityUsesTwoTaxRates}

  If (GlblProcessingType = History)
    then
      begin
        MessageDlg('The tax bill rates can only be set in this year processing.' + #13 +
                   'You are allowed to view history billing cycles, but not modify them.',
                   mtError, [mbOK], 0);

        For I := 1 to (ComponentCount - 1) do
          If ((Components[I] is TTable) and
              (Deblank(TTable(Components[I]).TableName) <> ''))
            then
              begin
                TTable(Components[I]).ReadOnly := True;

              end;  {If ((Components[I] is TTable) and ...}

      end;  {If (GlblProcessingType = History)}

  TaxRollYr.Text := TaxRollYear;
  TaxRollYr.Repaint;

    {If there are no classified swis codes in this municipality, then we
     will only display one rate column in the general and SD rate grids.}

  HasClassifiedSwis := False;
  Done := False;
  FirstTimeThrough := True;
  SwissCdLookUpTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwissCdLookUpTable.Next;

    If SwissCdLookUpTable.EOF
      then Done := True;

    If ((not Done) and
        SwissCdLookUpTable.FieldByName('Classified').AsBoolean)
      then HasClassifiedSwis := True;

  until SwissCdLookUpTable.EOF;

  If not HasClassifiedSwis
    then
      begin
        GeneralRateTableNonHomeSteadRate.Visible := False;
        GeneralRateTableHomeSteadRate.DisplayLabel := 'Rate';
        SDistRateTableNonHomeSteadRate.Visible := False;
        SDistRateTableHomeSteadRate.DisplayLabel := 'Rate';

      end;  {If not HasClassifiedSwis}

    {FXX07021998-6: Format the floats.}

  GeneralRateTableHomesteadRate.DisplayFormat := ExtendedDecimalDisplay;
  GeneralRateTableNonhomesteadRate.DisplayFormat := ExtendedDecimalDisplay;
  GeneralRateTableCurrentTaxLevy.DisplayFormat := CurrencyNormalDisplay;
  GeneralRateTablePriorTaxLevy.DisplayFormat := CurrencyNormalDisplay;
  GeneralRateTableEstimatedStateAid.DisplayFormat := CurrencyNormalDisplay;

  SDistRateTableHomesteadRate.DisplayFormat := ExtendedDecimalDisplay;
  SDistRateTableNonhomesteadRate.DisplayFormat := ExtendedDecimalDisplay;
  SDistRateTableCurrentTaxLevy.DisplayFormat := CurrencyNormalDisplay;
  SDistRateTablePriorTaxLevy.DisplayFormat := CurrencyNormalDisplay;

  SpclFeeTableCurrentTaxLevy.DisplayFormat := CurrencyNormalDisplay;
  SpclFeeTablePriorTaxLevy.DisplayFormat := CurrencyNormalDisplay;

  InitializingForm := False;

  with tbSortBillLevyView do
    begin
      TFloatField(FieldByName('Rate')).DisplayFormat := ExtendedDecimalDisplay_BlankZero;
      TFloatField(FieldByName('CurrentLevy')).DisplayFormat := CurrencyNormalDisplay;
      TFloatField(FieldByName('TaxIncreasePercent')).DisplayFormat := _1DecimalDisplay;

    end;  {with tbSortBillLevyView do}

end;  {InitializeForm}

{===================================================================}
Procedure TBillRatesForm.BillCtlDataSourceDataChange(Sender: TObject;
                                                     Field: TField);

begin
  If not InitializingForm
    then
      with CollectionLookupTable do
        begin
          SetRangeOld(CollDtlTable,
                      ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                      [FieldByName('TaxRollYr').Text,
                       FieldByName('CollectionType').Text,
                       FieldByName('CollectionNo').Text],
                      [FieldByName('TaxRollYr').Text,
                       FieldByName('CollectionType').Text,
                       FieldByName('CollectionNo').Text]);

          SetRangeOld(SDistRateTable,
                      ['TaxRollYr', 'CollectionType', 'CollectionNo',
                       'SDistCode', 'ExtCode', 'CMFlag'],
                      [FieldByName('TaxRollYr').Text,
                       FieldByName('CollectionType').Text,
                       FieldByName('CollectionNo').Text, 'AAAAA', '', ''],
                      [FieldByName('TaxRollYr').Text,
                       FieldByName('CollectionType').Text,
                       FieldByName('CollectionNo').Text, 'ZZZZZ', '', '']);

          SetRangeOld(BillCollArrearsTable,
                      ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                      [FieldByName('TaxRollYr').Text,
                       FieldByName('CollectionType').Text,
                       FieldByName('CollectionNo').Text],
                      [FieldByName('TaxRollYr').Text,
                       FieldByName('CollectionType').Text,
                       FieldByName('CollectionNo').Text]);

          SetRangeOld(GeneralRateTable,
                      ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
                      [FieldByName('TaxRollYr').Text,
                       FieldByName('CollectionType').Text,
                       FieldByName('CollectionNo').Text, '0'],
                      [FieldByName('TaxRollYr').Text,
                       FieldByName('CollectionType').Text,
                       FieldByName('CollectionNo').Text, '32000']);

          SetRangeOld(SpclFeeTable,
                      ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
                      [FieldByName('TaxRollYr').Text,
                       FieldByName('CollectionType').Text,
                       FieldByName('CollectionNo').Text, '0'],
                      [FieldByName('TaxRollYr').Text,
                       FieldByName('CollectionType').Text,
                       FieldByName('CollectionNo').Text, '32000']);

        end;  {with CollectionLookupTable do}

end;  {BillCtlDataSourceDataChange}

{===================================================================}
Function TBillRatesForm.GetSDDescription (SDCode : String;
                                          SDTable : TTable) : String;
Var
  Found : Boolean;
Begin
SdTAble.INdexName := 'BYSDISTCODE';

Found := FindKeyOld(SDTable, ['SDistCode'],
                    [TAke(5,SDCode)]);
If Found
   then GetSDDescription := Take(20,SDTAble.FieldByName('Description').AsString)
   else GEtSDDEscription := Take(20,'UNKNOWN');

end;

{===================================================================}
Function TBillRatesForm.GetSDExtDescription(SDExtCode : String;
                                            SDExtTable : TTable) : String;
Var
  Found : Boolean;
Begin
Found := FindKeyOld(SDExtTable, ['MainCode'], [TAke(2,SDExtCode)]);
If Found
   then GetSDExtDescription := Take(20,SDExtTAble.FieldByName('Description').AsString)
   else GEtSDExtDEscription := Take(20,'UNKNOWN ');

end;

{===================================================================}
Procedure TBillRatesForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
    {FXX12231997-9: Convert enter to tab in rate grids.}

  If (Key = #13)
    then
      If not (ActiveControl is TwwDBGrid)
        then
          begin
           {not a grid so go to next control on form}
            Perform(WM_NEXTDLGCTL, 0, 0);
            Key := #0;
          end;

end;  {FormKeyPress}

{===================================================================}
Procedure TBillRatesForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

procedure TBillRatesForm.CloseButtonClick(Sender: TObject);
begin
Close;
end;

{========================================================================}
Procedure TBillRatesForm.RatesNotebookEnter(Sender: TObject);

begin
  If CollCtlRecFound
    then GeneralRateDBGrid.SetFocus
    else
      begin
        MessageDlg('You Must Select A Tax Billing Cycle Before' + #13 +
                   'Entering Tax Rates.' ,
                    mtError, [mbOK], 0);
        (*Abort;*)
      end;

end;

{===================================================================}
Procedure TBillRatesForm.SetupExtArray (Var Ecmarray : ECdCMArray;
                         Var Ecct : Integer);
Begin

      ECCt := 0;
      If Deblank(SDCodeLookupTableEcd1.AsSTring) <> ''
         then
         begin
         ECMArray[ecct+1].Ecde := Take(2,SDCodeLookupTableEcd1.AsSTring);
         ECMArray[ecct+1].Ecflg := Take(1,SDCodeLookupTableEcflg1.AsSTring);

         ECCt := ECCt + 1;
         end;
      If Deblank(SDCodeLookupTableEcd2.AsString) <> ''
         then
         begin
         ECMArray[Ecct + 1].Ecde:= Take(2,SDCodeLookupTableEcd2.AsString);
          ECMArray[ecct+1].Ecflg := Take(1,SDCodeLookupTableEcflg2.AsSTring);
         ECCt := ECCt + 1;
         end;
      If Deblank(SDCodeLookupTableEcd3.AsString) <> ''
         then
         begin
         ECMArray[Ecct + 1].Ecde:= Take(2,SDCodeLookupTableEcd3.AsString);
          ECMArray[ecct+1].Ecflg := Take(1,SDCodeLookupTableEcflg3.AsSTring);
         ECCt := ECCt + 1;
         end;
      If Deblank(SDCodeLookupTableEcd4.AsString) <> ''
         then
         begin
         ECMArray[Ecct + 1].Ecde:= Take(2,SDCodeLookupTableEcd4.AsString);
          ECMArray[ecct+1].Ecflg := Take(1,SDCodeLookupTableEcflg4.AsSTring);
         ECCt := ECCt + 1;
         end;
      If Deblank(SDCodeLookupTableEcd5.AsString) <> ''
         then
         begin
         ECMArray[Ecct + 1].Ecde:= Take(2,SDCodeLookupTableEcd5.AsString);
          ECMArray[ecct+1].Ecflg := Take(1,SDCodeLookupTableEcflg5.AsSTring);
         ECCt := ECCt + 1;
         end;
      If Deblank(SDCodeLookupTableEcd6.AsString) <> ''
         then
         begin
         ECMArray[Ecct + 1].Ecde:= Take(2,SDCodeLookupTableEcd6.AsString);
          ECMArray[ecct+1].Ecflg := Take(1,SDCodeLookupTableEcflg6.AsSTring);
         ECCt := ECCt + 1;
         end;
      If Deblank(SDCodeLookupTableEcd7.AsString) <> ''
         then
         begin
         ECMArray[Ecct + 1].Ecde:= Take(2,SDCodeLookupTableEcd7.AsString);
          ECMArray[ecct+1].Ecflg := Take(1,SDCodeLookupTableEcflg7.AsSTring);
         ECCt := ECCt + 1;
         end;
      If Deblank(SDCodeLookupTableEcd8.AsString) <> ''
         then
         begin
         ECMArray[Ecct + 1].Ecde:= Take(2,SDCodeLookupTableEcd8.AsString);
          ECMArray[ecct+1].Ecflg := Take(1,SDCodeLookupTableEcflg8.AsSTring);
         ECCt := ECCt + 1;
         end;

        If Deblank(SDCodeLookupTableEcd9.AsString) <> ''
         then
         begin
         ECMArray[Ecct + 1].Ecde:= Take(2,SDCodeLookupTableEcd9.AsString);
          ECMArray[ecct+1].Ecflg := Take(1,SDCodeLookupTableEcflg9.AsSTring);
         ECCt := ECCt + 1;
         end;
      If Deblank(SDCodeLookupTableEcd10.AsString) <> ''
         then
         begin
         ECMArray[Ecct + 1].Ecde:= Take(2,SDCodeLookupTableEcd10.AsString);
          ECMArray[ecct+1].Ecflg := Take(1,SDCodeLookupTableEcflg10.AsSTring);
         Ecct := Ecct + 1;
         end;
end;

{===================================================================}
Procedure TBillRatesForm.CollectionNumberExit(Sender: TObject);

var
  SDPresentForthisCollection,
  _Found, FirstTimeThrough, SDApplies, Done : Boolean;
  EcdIdx, Ecct : Integer;
  PriorTaxYear, sExtensionDescriptionFieldName,
  sBillPrintGroupOrderFieldName : String;

begin
  CollectionType := CollTypeDBLookupCombo.Text;
  CollectionNum := StrToInt(CollectionNumber.Text);

  _Found := FindKeyOld(CollectionLookupTable,
                       ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                       [TaxRollYr.Text, CollectionType,
                        IntToStr(CollectionNum)]);

  If _Found
    then
      begin
        RatesNoteBook.Visible := True;

        CollCtlRecFound := True;

          {FXX05081998-3: The ranges were not being set correctly for the tables.}

(*        SDistRateTAble.CancelRange;
        SpclFeeTable.CancelRange;
        GeneralRateTable.CancelRange;

        GeneralRateTable.SetRange([TaxRollYear, CollectionType, CollectionNum],
                                  [TaxRollYear, CollectionType, CollectionNum]);

        SDistRateTable.SetRange([TaxRollYear, CollectionType, CollectionNum],
                                [TaxRollYear, CollectionType, CollectionNum]);

        SpclFeeTable.SetRange([TaxRollYear, CollectionType, CollectionNum],
                              [TaxRollYear, CollectionType, CollectionNum]); *)

      end
    else
      begin
        MessageDlg('That Collection Cycle Record Cannot Be Found.' + #13 +
                   'Please Try Again.', mtError, [mbOK], 0);

        CollTypeDBLookupCombo.SetFocus;
        (*Abort;*)
      end;

    {see if we should read in SD recs, do not do it if any present}
    {already for this collection}

  SDPresentForThiscollection := False;

  SDistRateTable.First;

  If ((Take(4, SDistRateTableTaxRollYr.Text) = Take(4, TaxRollYear)) and
      (Take(2, SDistRateTableCollectionType.Text) = Take(2, CollectionType)) and
      (SDistRateTableCollectionNo.AsInteger = CollectionNum))
    then SDPresentForThisCollection := True;

  {FXX05081998-2: For school, only do pro-rata special districts.}

  If not SDPresentForThiscollection
    then
      begin
        Done := False;
        SDCodeLookupTable.First;
        FirstTimeThrough := True;

          {FXX05091998-1: Set the sd rate read only fields to not read only so
                          can fill in.}

        SDistRateTableSDistCode.ReadOnly := False;
        SDistRateTableSdistDescr.ReadOnly := False;
        SDistRateTableExtCode.ReadOnly := False;
        SDistRateTableSDistExtDescr.ReadOnly := False;
        SDistRateTableCMFlag.ReadOnly := False;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SDCodeLookupTable.Next;

          If SDCodeLookupTable.EOF
            then Done := True;

            {FXX05081998-3: Some special districts do apply to school such as
                            pro-rata. Look at the "AppliesToSchool" flag.}
            {FXX07021998-5: Check RS9 flag, not AppliesToSchool for applicability
                            to school.}

          SDApplies := True;

            {FXX11062001-1: Include a special district for a school roll if
                            it is marked RS9, prorata or school roll.}

          If (CollectionType = 'SC')
            then
              begin
                SDApplies := False;

                If (SDCodeLookupTable.FieldByName('SDRS9').AsBoolean or
                    SDCodeLookupTable.FieldByName('AppliesToSchool').AsBoolean or
                    SDCodeLookupTable.FieldByName('ProrataOmit').AsBoolean)
                  then SDApplies := True;

              end;  {If (CollectionType = 'SC')}

          If ((not Done) and
              SDApplies)
            then
              begin
                   {get ext codes for this sd code}
                SetupExtArray(EcmArray, Ecct);

                EcdIdx := 1;

                while (EcdIdx <= Ecct) do
                  begin
                    try
                      SdistRateTable.Insert;

                      SdistRateTableSdistCode.Text := SdCodeLookupTable.FieldByName('SDistCode').AsString;
                      SdistRateTableSdistDescr.Text := GetSDDescription(SdistRateTableSdistCode.Text,
                                                                        SDCodeLookupTable);
                      SdistRateTableExtCode.Text := EcmArray[EcdIdx].Ecde;
                      SdistRateTableSdistExtDescr.Text := GetSDExtDescription(SdistRateTableExtCode.Text,
                                                                              SDEXtCdLookupTable);
                      SdistRateTableCMFlag.Text := EcmArray[EcdIdx].Ecflg;
                      SdistRateTable.FieldByName('TaxRollYr').Text := TaxRollYear;
                      SdistRateTable.FieldByName('CollectionType').Text := CollectionType;
                      SdistRateTable.FieldByName('CollectionNo').AsInteger := CollectionNum;

                        {FXX12231997-8: Must allow move taxes into rate table so can
                                        determine if this move tax applies to this billing
                                        by having either a rate of 1 or 0.}

                      PriorTaxYear := IntToStr(SdistRateTable.FieldByName('TaxRollYr').AsInteger - 1);

                      with SDistRateTable do
                        _Found := FindKeyOld(SDRateLookupTable,
                                             ['TaxRollYr', 'CollectionType',
                                              'CollectionNo', 'SDistCode',
                                              'ExtCode', 'CMFlag'],
                                             [PriorTaxYear,
                                              FieldByName('CollectionType').Text,
                                              FieldByName('CollectionNo').Text,
                                              FieldByName('SdistCode').Text,
                                              FieldByName('ExtCode').Text,
                                              FieldByName('CMFlag').Text]);

                        {CHG12081999-1: Load the current levy from last year into prior levy
                                        if it exists.}

                      If _Found
                        then SDistRateTable.FieldByName('PriorTaxLevy').AsFloat :=
                                  SDRateLookupTable.FieldByName('CurrentTaxLevy').AsFloat;

                        {CHG12072009-1(2.22.1.1)[I6784]: Bill changes for Ramapo.}

                      try
                        SDistRateTable.FieldByName('BillPrintGroup').AsString := SDCodeLookupTable.FieldByName('BillPrintGroup').AsString;
                        sBillPrintGroupOrderFieldName := 'ExtensionGroupOrder' + IntToStr(EcdIdx);
                        SDistRateTable.FieldByName('BillPrintGroupOrder').AsInteger := SDCodeLookupTable.FieldByName(sBillPrintGroupOrderFieldName).AsInteger;

                        sExtensionDescriptionFieldName := 'ExtensionDescription' + IntToStr(EcdIdx);
                        If _Compare(SDCodeLookupTable.FieldByName(sExtensionDescriptionFieldName).AsString, coNotBlank)
                          then SDistRateTable.FieldByName('SDistDescr').AsString := SDCodeLookupTable.FieldByName(sExtensionDescriptionFieldName).AsString;
                      except
                      end;

                      SdistRateTable.Post;
                    except
                      SystemSupport(005, SdistRateTable, 'Post Error On SD Rate Table.',
                                    UnitName, GlblErrorDlgBox);
                      (*Abort;*)
                    end;

                  EcdIdx := EcdIdx + 1;

                end;  {while (EcdIdx <= Ecct) do}

              end;  {If not Done}

        until Done;

        SDistRateTableSDistCode.ReadOnly := True;
        SDistRateTableSdistDescr.ReadOnly := True;
        SDistRateTableExtCode.ReadOnly := True;
        SDistRateTableSDistExtDescr.ReadOnly := True;
        SDistRateTableCMFlag.ReadOnly := True;

      end;  {If not SDPresentForThiscollection}

  RatesNotebook.SetFocus;

end;  {CollectionNumberExit}

{========================================================}
Function TBillRatesForm.ValidSwis(Swcode : String) : boolean;

Var
  SDLen : Integer;
  TempSWcode : String;
  ValidSW,
  SWFound : Boolean;

Begin
  If (Deblank(SwCode) = '')
    then ValidSW := False
    else
      If (Length(Rtrim(SWCode)) < 6)
        then
          begin  {validate 2char or 4char swis}
            SDLen := Length(Rtrim(SWCode));
            If  ( (SDLen <> 2)
                     AND
                  (SDLen <> 4)
                     AND
                  (SDLen <> 6)
                     AND
                  (Take(2,CollTypeDBLookupCombo.Text) <> 'SC')
                 )
                      OR
                    {allow blank swis for school collection}
                ( (Take(2,CollTypeDBLookupCombo.Text) = 'SC')
                         AND
                   (Deblank(SWCode) <> '')
                 )

               then
               begin
               VAlidSW := False;
               end
               else
               begin
                 FindNearestOld(SwissCdLookupTable, ['SwisCode'], [SWcode]);
                 TempSWCode := Take(SDLen,SwissCdLookupTableSwisCode.Text);
                 If (Take(SDLen,TempSwCode)) =
                     (TAke(SDLen,SWCode))
                   then VAlidSW := True
                   else ValidSW := False;

               end;

          end
        else
          begin
            SWFound := FindKeyOld(SwissCdLookupTable, ['SwisCode'], [SWcode]);
            ValidSW := SwFound;
          end;

  ValidSwis := ValidSW;

end;

{====================================================================}
Procedure TBillRatesForm.GeneralRateTableBeforePost(DataSet: TDataset);

begin
  CollectionType := Take(2,CollTypeDBLookupCombo.Text);

  {set up key fields correctly for this rate record}

  with GeneralRateTable do
    begin
      FieldByName('TaxRollYr').Text := Take(4,TaxRollYear);
      FieldByName('CollectionType').Text := CollectionType;
      FieldByName('CollectionNo').AsInteger := StrToInt(CollectionNumber.Text);

       {must have genl tax type, eg county, town, schol,village}
       {so when billing we know how to appley exemptions based}
       {on collection type}
      If (Deblank(FieldByName('GeneralTaxType').Text) = '')
        then
          begin
            MessageDlg('Please enter a general tax type.', mtError, [mbOK], 0);
            Abort;
        end;

      If ((CollectionType  = 'SC') and
          (Deblank(FieldByName('SchoolCode').Text) = ''))
        then
          begin
            MessageDlg('Please enter a school code.', mtError, [mbOK], 0);
            Abort;
          end;

      If (((CollectionType = 'MU') or
           (CollectionType = 'VI')) and
          (not ValidSwis(FieldByName('SwisCode').Text)))
        then
          begin
            MessageDlg('Please enter a swis code.', mtError, [mbOK], 0);
            Abort;
          end;

        {FXX04102001-1: Make sure that if they enter a 6 digit swis for the county,
                        we truncate to 4 digits to avoid a problem later.}

      If (FieldByName('GeneralTaxType').Text = 'CO')
        then FieldByName('SwisCode').Text := Take(4, FieldByName('SwisCode').Text);

    end;  {with GeneralRateTable do}

end;  {GeneralRateTableBeforePost}

{==========================================================================}
Procedure TBillRatesForm.GeneralRateDBGridColExit(Sender: TObject);

var
  SWCode : String;

begin
  {FXX12231997-10: Don't tell the person they must have a swis or school
                   here. Do it before post to allow the person more
                   flexibility in entering.}

  If (GeneralRateDBGrid.SelectedIndex = 2)
    then
      with GeneralRateDBGrid do
        begin
          SWCode := Take(6, SelectedField.Text);

          If (Deblank(SWCode) <> '') and
             (not ValidSwis(SWCode))
            then MessageDlg(SWCode + ' is not a valid swis code.' + #13 +
                            'Please enter a 2, 4, or 6 digit swis code.',
                            mtError, [mbOK], 0);

        end;  {If (GeneralRatedDBGrid.SelectedIndex = 2)}

end;  {GeneralRateDBGridColExit}

{==================================================================}
Procedure TBillRatesForm.GeneralRateTableAfterInsert(DataSet: TDataset);

begin
  GeneralRateTableTaxRollYr.AsString := TaxRollYear;
  TaxRollYr.Text := TaxRollYear;
  TaxRollYr.Repaint;

    {FXX12231997-11: Default the print order to next.}

  with GeneralRateLookupTable do
    begin
      GeneralRateLookupTable.CancelRange;
      SetRangeOld(GeneralRateLookupTable,
                  ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
                  [TaxRollYear, CollectionType, IntToStr(CollectionNum), '0'],
                  [TaxRollYear, CollectionType, IntToStr(CollectionNum), '32000']);

      Last;

        {FXX07021998-4: Don't set print order unless is 0.}

      If (GeneralRateTablePrintOrder.AsInteger = 0)
        then GeneralRateTablePrintOrder.AsInteger := FieldByName('PrintOrder').AsInteger + 1;

    end;  {with GeneralRateLookupTable do}

      {FXX04231998-1: Put in print order field.}

  GeneralRateDBGrid.SetActiveField('PrintOrder');
  GeneralRateDBGrid.SetFocus;

end;  {GeneralRateTableAfterInsert}

procedure TBillRatesForm.SdExtDBLookupComboExit(Sender: TObject);
begin
If (SdistRateTable.State = dsInsert)
              OR
   (SdistRateTable.State = dsEdit)
    then
    begin
     SdistRateTableSdistExtDescr.AsString  :=
        GetSDExtDescription(SdistRateTableExtCode.AsString,
                         SDEXtCdLookupTable);
     GeneralRatedbgrid.Repaint;
     end;
end;

procedure TBillRatesForm.SDDBLookupComboExit(Sender: TObject);
begin
If (SdistRateTable.State = dsInsert)
              OR
   (SdistRateTable.State = dsEdit)
    then SdistRateTableSdistDescr.AsString  :=
        GetSDDescription(SdistRateTableSdistCode.AsString,
                         SDCodeLookupTable);
GeneralRatedbgrid.Repaint;
end;

procedure TBillRatesForm.SpclFeeTableBeforePost(DataSet: TDataset);
begin

With SpclFeeTable do
 Begin
 If (Deblank(SpclFeeTableDescription.AsString) = '')
    then
    begin
    MessageDlg('You Must Provide A Special Fee Description.' + #13 +
               'Please Try Again.' ,
                   mtError, [mbOK], 0);
    (*Abort;*)
    end
    else If  (RoundOff(SpclFeeTableFixedAmount.Value,2) >0)
                   AND
          (RoundOff(SpclFeeTablePercentage.Value,2) >0)

          then
          begin
          MessageDlg('You cannot specify both a Fixed Amount' +#13 +
             'and a Percentage For Special Fees. Please try again.', mtError, [mbOK], 0);
          (*Abort;*)
          end

     else  If  (RoundOff(SpclFeeTableFixedAmount.Value,2) <=0)
                   AND
          (RoundOff(SpclFeeTablePercentage.Value,2) <=0)

          then
          begin
          MessageDlg('You must specify either a Fixed Amount' +#13 +
             'or a Percentage greater than 0. Please try again.', mtError, [mbOK], 0);
          (*Abort;*)
          end
          else
          begin
          SpclFeeTAble.FieldByName('TaxRollYr').AsString := Take(4,TaxRollYear);
          SpclFeeTAble.FieldByName('CollectionType').AsString := Take(2,CollTypeDBLookupCombo.Text);
          SpclFeeTAble.FieldByName('CollectionNo').AsInteger :=
          StrToInt(CollectionNumber.Text);
          end;
    end;  {end description not blank}

end;

{==========================================================}
Procedure TBillRatesForm.SpclFeeDBGridColExit(Sender: TObject);

var
  _Found : Boolean;

begin
    {be sure for printorder, no dupes}

  If (SpclFeeDBGrid.SelectedIndex = 0)
    then
      begin
        with SpclFeeTable do
          _Found := FindKeyOld(SpclFeeLookupTable,
                               ['PrintOrder'],
                               [SpclFeeDBGrid.SelectedField.Text]);

            {if descr not equal, must be diff record}

         If (_Found and
             (SpclFeeTable.FieldByName('Description').AsString <>
              SpclFeeLookupTable.FieldByName('Description').AsString))
            then
              begin
                MessageDlg('A special fee with this print order already exists' + #13 +
                           'Please chose a different print order.' ,
                           mtError, [mbOK], 0);
                (*Abort;*)
              end;

       end;  {If (SpclFeeDBGrid.SelectedIndex = 0)}

end;  {SpclFeeDBGridColExit}

{===========================================================}
Procedure TBillRatesForm.SDistRateTableBeforePost(DataSet: TDataset);

begin
  {fill in key fields}
  SdistRateTable.FieldByName('TaxRollYr').AsString := Take(4,TaxRollYear);
  SdistRateTable.FieldByName('CollectionType').AsString := Take(2,CollTypeDBLookupCombo.Text);
  SdistRateTable.FieldByName('CollectionNo').AsInteger := StrToInt(CollectionNumber.Text);

end;  {SDistRateTableBeforePost}

{=========================================================}
Procedure TBillRatesForm.SpclFeeTableNewRecord(DataSet: TDataset);

{Fill in the tax roll year, collection type and collection number.}

begin
  with SpclFeeTable do
    begin
      FieldByName('TaxRollYr').AsString := Take(4, TaxRollYear);
      FieldByName('CollectionType').AsString := Take(2, CollTypeDBLookupCombo.Text);
      FieldByName('CollectionNo').AsInteger := StrToInt(CollectionNumber.Text);

    end;  {with SpclFeeTable do}

    {FXX12231997-11: Default the print order to next.}

  with SpclFeeLookupTable do
    begin
(*      SetRange([TaxRollYear, CollectionType, CollectionNum],
               [TaxRollYear, CollectionType, CollectionNum]); *)

      Last;

      SpclFeeTablePrintOrder.AsInteger := FieldByName('PrintOrder').AsInteger + 1;

    end;  {with GeneralRateLookupTable do}

end;  {SpclFeeTableNewRecord}

{================================================================}
Procedure TBillRatesForm.RatesNotebookChange(    Sender: TObject;
                                                 NewTab: Integer;
                                             var AllowChange: Boolean);

{FXX04231998-4: Set focus to the grid when page is changed.}

begin
  NotebookChangeTimer.Enabled := True;
end;  {RatesNotebookChange}

{==================================================================}
Procedure TBillRatesForm.FillInLevyViewTable;

begin
  with tbSortBillLevyView do
    begin
      DisableControls;
      Winutils.DeleteTable(tbSortBillLevyView);
      Open;

      GeneralRateTable.First;
      while not GeneralRateTable.EOF do
        begin
          If (_Compare(GeneralRateTable.FieldByName('HomesteadRate').AsFloat, 0, coGreaterThan) or
              _Compare(GeneralRateTable.FieldByName('NonHomesteadRate').AsFloat, 0, coGreaterThan))
            then
              try
                Insert;
                FieldByName('BillPrintGroup').AsString := GeneralRateTable.FieldByName('BillPrintGroup').AsString;

                If _Locate(tbBillPrintGroup, [GeneralRateTable.FieldByName('BillPrintGroup').AsString], '', [])
                  then FieldByName('PrintGroupOrder').AsInteger := tbBillPrintGroup.FieldByName('GroupOrder').AsInteger;

                FieldByName('LevyPrintOrder').AsInteger := GeneralRateTable.FieldByName('BillPrintGroupOrder').AsInteger;

                If _Compare(GeneralRateTable.FieldByName('CollectionType').AsString, 'SC', coEqual)
                  then FieldByName('TaxingEntity').AsString := GeneralRateTable.FieldByName('SchoolCode').AsString
                  else FieldByName('TaxingEntity').AsString := GeneralRateTable.FieldByName('SwisCode').AsString;

                FieldByName('LevyDescription').AsString := GeneralRateTable.FieldByName('Description').AsString;
                FieldByName('Rate').AsFloat := GeneralRateTable.FieldByName('HomesteadRate').AsFloat;
                FieldByName('CurrentLevy').AsInteger := GeneralRateTable.FieldByName('CurrentTaxLevy').AsInteger;

                FieldByName('TaxIncreasePercent').AsFloat := ComputeTaxLevyPercentChange(GeneralRateTable.FieldByName('CurrentTaxLevy').AsInteger,
                                                                                         GeneralRateTable.FieldByName('PriorTaxLevy').AsInteger);
                Post;
              except
              end;

          GeneralRateTable.Next;

        end;  {while not GeneralRateTable.EOF do}

      GeneralRateTable.First;

      SDistRateTable.First;
      while not SDistRateTable.EOF do
        begin
          If (_Compare(SDistRateTable.FieldByName('HomesteadRate').AsFloat, 0, coGreaterThan) or
              _Compare(SDistRateTable.FieldByName('NonHomesteadRate').AsFloat, 0, coGreaterThan))
            then
              try
                Insert;
                FieldByName('BillPrintGroup').AsString := SDistRateTable.FieldByName('BillPrintGroup').AsString;

                If _Locate(tbBillPrintGroup, [SDistRateTable.FieldByName('BillPrintGroup').AsString], '', [])
                  then FieldByName('PrintGroupOrder').AsInteger := tbBillPrintGroup.FieldByName('GroupOrder').AsInteger;

                FieldByName('TaxingEntity').AsString := SDistRateTable.FieldByName('SDistCode').AsString;
                FieldByName('LevyPrintOrder').AsInteger := SDistRateTable.FieldByName('BillPrintGroupOrder').AsInteger;
                FieldByName('LevyDescription').AsString := SDistRateTable.FieldByName('SDistDescr').AsString;
                FieldByName('Rate').AsFloat := SDistRateTable.FieldByName('HomesteadRate').AsFloat;
                FieldByName('CurrentLevy').AsInteger := SDistRateTable.FieldByName('CurrentTaxLevy').AsInteger;

                FieldByName('TaxIncreasePercent').AsFloat := ComputeTaxLevyPercentChange(SDistRateTable.FieldByName('CurrentTaxLevy').AsInteger,
                                                                                         SDistRateTable.FieldByName('PriorTaxLevy').AsInteger);
                Post;
              except
              end;

          SDistRateTable.Next;

        end;  {while not GeneralRateTable.EOF do}

      SDistRateTable.First;
      EnableControls;
      First;

    end;  {with tbSortBillLevyView do}

end;  {FillInLevyViewTable}

{==================================================================}
Procedure TBillRatesForm.NotebookChangeTimerTimer(Sender: TObject);

{In order to avoid an error focusing disabled window message, need to set focus
 after page is changed.}

begin
  NotebookChangeTimer.Enabled := False;

  case RatesNotebook.PageIndex of
    0 : GeneralRateDBGrid.SetFocus;
    1 : SDRateDBGrid.SetFocus;
    2 : SpclFeeDBGrid.SetFocus;
    3 : FillInLevyViewTable;

  end;  {case RatesNotebook.PageIndex of}

end;  {NotebookChangeTimerTimer}

{==============================================================}
Procedure TBillRatesForm.SDistDataSourceDataChange(Sender: TObject;
                                                   Field: TField);

{FXX04231998-6: When go to next record in SD rate grid, make sure in
                hstd rate field.}

begin
  If ((RatesNotebook.PageIndex = 1) and
      (Field = nil))
          and
      (SDistRateTable.State = dsInsert)  {FXX12121998-2 allow edit of total budget flds}
    then SDRateDBGrid.SetActiveField('HomesteadRate');

end;  {SDistDataSourceDataChange}

{CHG05011998-1: Print out the rates.}

{================================================================}
Procedure TBillRatesForm.PrintGeneralSetup(Sender : TObject);

{FXX11301999-4: Print the general setup.}

var
  I : Integer;
  FieldName : String;
  DBMemoBuf : TDBMemoBuf;
  Done, FirstTimeThrough : Boolean;

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      SetTab(0.5, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Penalty date}
      Underline := True;
      Println('');
      Println(#9 + 'GENERAL SETUP:');
      Underline := False;
      Println('');
      Bold := False;

      ClearTabs;
      SetTab(0.5, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Print order}
      SetTab(2.6, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Penalty %}

      with CollectionLookupTable do
        begin
          For I := 1 to 8 do
            begin
              FieldName := 'Paydate' + IntToStr(I);

              If (Deblank(FieldByName(FieldName).Text) <> '')
                then
                  begin
                    Print(#9 + 'Penalty ' + IntToStr(I) + ' date: ' +
                               FieldByName(FieldName).Text);

                    FieldName := 'PenPercent' + IntToStr(I);

                    If (FieldByName(FieldName).AsFloat <> 0)
                      then Println(#9 + 'Percent: ' + FieldByName(FieldName).Text)
                      else Println('');

                  end;  {If (Deblank(CollectionLookupTable.FieldByName(FieldName).Text) <> '')}

            end;  {For I := 1 to 8 do}

          Println('');
          Print('Bill numbering order: ');
          case FieldByName('BillingOrder').AsInteger of
            0 : Println('Parcel ID');
            1 : Println('Name');
            2 : Println('Address');
            3 : Println('Zip Code \ Parcel ID');
            4 : Println('Zip Code \ Name');
            5 : Println('Zip Code \ Address');
            6 : Println('Bank Code \ Parcel ID');
            7 : Println('Bank Code \ Name');
            8 : Println('Bank Code \ Address');

          end;  {case FieldByName('BillingOrder').AsInteger of}

          If (FieldByName('NumberOfPayments').AsInteger > 1)
            then
              begin
                ClearTabs;
                SetTab(0.5, pjLeft, 6.0, 0, BOXLINENONE, 0);
                Println('');
                Print(#9 + 'Special district application option: ');

                case FieldByName('SDApplicationOption').AsInteger of
                  ApplySDAmountsEqually : Println('Apply special district amounts equally among all payments.');
                  ApplyMoveTaxToFirstPayment : Println('Apply move taxes to first payment.');
                  ApplySDAmountToFirstPayment : Println('Apply all special districts to first payment.');

                end;  {case CollectionControlTable. ...}

                Println('');
                Print(#9 + 'Extra penny distribution: ');

                case FieldByName('PennyDistOption').AsInteger of
                  0 : Println('Forward');
                  1 : Println('Backwards');
                end;

                Println('');

                If FieldByName('UseMinimumPayment').AsBoolean
                  then Println(#9 + 'Use minimimum amount of ' +
                                    FormatFloat(CurrencyNormalDisplay, FieldByName('MinPaymentAmount').AsFloat) +
                                    '.');

                Println('');

                If FieldByName('UseMaximumPayment').AsBoolean
                  then Println(#9 + 'Use maximimum amount of ' +
                                    FormatFloat(CurrencyNormalDisplay, FieldByName('MaxPaymentAmount').AsFloat) +
                                    '.');

              end;  {If (FieldByName('NumberOfPayments').AsInteger > 1)}

          Println('');
          Println(#9 + 'Number pro-rata bill after base bill: ' +
                       FieldByName('NumberRS9AfterBase').Text);

          Println('');
          Println(#9 + 'Set bank code to ''ARREARS'' if the Arrears flag is on for a parcel: ' +
                       FieldByName('UseArrearsFlag').Text);

          If (Deblank(FieldByName('RS9BankCode').Text) <> '')
            then
              begin
                Println('');
                Println(#9 + 'Bank code to print for roll section 9 parcels: ' +
                             FieldByName('RS9BankCode').Text);
              end;

          Println('');

        end;  {with CollectionLookupTable do}

        {Now print out the collection details.}

      CollDtlTable.First;
      Done := False;
      FirstTimeThrough := True;

      ClearTabs;
      SetTab(0.5, pjCenter, 1.0, 0, BOXLINEBottom, 0);  {Swis code}
      SetTab(1.6, pjCenter, 1.0, 0, BOXLINEBottom, 0);  {School code}
      SetTab(2.7, pjCenter, 1.3, 0, BOXLINEBottom, 0);  {Starting bill #}

      Bold := True;
      Println(#9 + 'Swis Code' +
              #9 + 'School Code' +
              #9 + 'Starting Bill');
      Bold := False;

      ClearTabs;
      SetTab(0.5, pjLeft, 1.0, 0, BOXLINENone, 0);  {Swis code}
      SetTab(1.6, pjLeft, 1.0, 0, BOXLINENone, 0);  {School code}
      SetTab(2.7, pjRight, 1.3, 0, BOXLINENone, 0);  {Starting bill #}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else CollDtlTable.Next;

        If CollDtlTable.EOF
          then Done := True;

        If not Done
          then
            with CollDtlTable do
              Println(#9 + FieldByName('SwisCode').Text +
                      #9 + FieldByName('SchoolCode').Text +
                      #9 + FieldByName('StartingBillNo').Text);

      until Done;

      Println('');

        {Print the arrears message.}

      If not BillCollArrearsTable.EOF
        then
          begin
            Println(#9 + 'Arrears Message:');

            DBMemoBuf := TDBMemoBuf.Create;
            DBMemoBuf.Field := BillCollArrearsTableArrearsMessage;
            DBMemoBuf.PrintStart := 0.8;
            DBMemoBuf.PrintEnd := 7.9;

            PrintMemo(DBMemoBuf, 0, False);

          end;  {If not BillCollArrearsTable.EOF}

    end;  {with Sender as TBaseReport do}

end;  {PrintGeneralSetup}

{===========================================================================}
Procedure SetupGeneralRateSection(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      SetTab(0.5, pjLeft, 2.5, 0, BOXLINENONE, 0);   {Print order}
      Underline := True;
      Println('');
      Println(#9 + 'GENERAL RATES:');
      Underline := False;
      Println('');

      ClearTabs;
      SetTab(0.5, pjCenter, 0.5, 0, BOXLINENONE, 0);   {Print order}
      SetTab(1.1, pjCenter, 0.4, 0, BOXLINENONE, 0);   {Tax type}
      SetTab(1.6, pjCenter, 0.8, 0, BOXLINENONE, 0);   {Swis code}
      SetTab(2.5, pjCenter, 0.8, 0, BOXLINENONE, 0);   {School code}
      SetTab(3.4, pjCenter, 2.0, 0, BOXLINENONE, 0);   {Description}
      SetTab(5.5, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Hstd rate}
      SetTab(6.8, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Nonhstd rate}
      SetTab(8.1, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Current Levy}
      SetTab(9.4, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Prior Levy}
      SetTab(10.7, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Est school aid}

      Print(#9 + 'PRINT' +
            #9 + 'TAX' +
            #9 + 'SWIS' +
            #9 + 'SCHOOL');

      If GlblMunicipalityUsesTwoTaxRates
        then Print(#9 + #9 + 'HSTD' +
                   #9 + 'NON-HSTD')
        else Print(#9 + #9);

        {FXX12181998-1: Switch the current and prior to match the screen.}

      Print(#9 + 'CURRENT' +
            #9 + 'PRIOR');

      If (CollectionType = 'SC')
        then Println(#9 + 'ESTIMATED')
        else Println('');

      ClearTabs;
      SetTab(0.5, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {Print order}
      SetTab(1.1, pjCenter, 0.4, 0, BOXLINEBOTTOM, 0);   {Tax type}
      SetTab(1.6, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Swis code}
      SetTab(2.5, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {School code}
      SetTab(3.4, pjCenter, 2.0, 0, BOXLINEBOTTOM, 0);   {Description}
      SetTab(5.5, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {Hstd rate}
      SetTab(6.8, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {Nonhstd rate}
      SetTab(8.1, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Prior Levy}
      SetTab(9.4, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Current Levy}
      SetTab(10.7, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Est school aid}

      Print(#9 + 'ORDER' +
            #9 + 'TYPE' +
            #9 + 'CODE' +
            #9 + 'CODE' +
            #9 + 'DESCRIPTION' +
            #9 + 'RATE');

      If GlblMunicipalityUsesTwoTaxRates
        then Print(#9 + 'RATE');

      Print(#9 + 'LEVY' +
            #9 + 'LEVY');

      Println(#9 + 'STATE AID');

      ClearTabs;
      SetTab(0.5, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Print order}
      SetTab(1.1, pjCenter, 0.4, 0, BOXLINENONE, 0);   {Tax type}
      SetTab(1.6, pjLeft, 0.8, 0, BOXLINENONE, 0);   {Swis code}
      SetTab(2.5, pjLeft, 0.8, 0, BOXLINENONE, 0);   {School code}
      SetTab(3.4, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Description}

      If PrintBlankRates
        then
          begin
            SetTab(5.5, pjRight, 1.2, 0, BOXLINENone, 0);   {Hstd rate}
            SetTab(6.8, pjRight, 1.2, 0, BOXLINENone, 0);   {Nonhstd rate}
            SetTab(8.1, pjRight, 1.2, 0, BOXLINENone, 0);   {Prior Levy}
            SetTab(9.4, pjRight, 1.2, 0, BOXLINENone, 0);   {Current Levy}
            SetTab(10.7, pjRight, 1.2, 0, BOXLINENone, 0);   {Est school aid}
          end
        else
          begin
            SetTab(5.5, pjRight, 1.2, 0, BOXLINEBottom, 0);   {Hstd rate}
            SetTab(6.8, pjRight, 1.2, 0, BOXLINEBottom, 0);   {Nonhstd rate}
            SetTab(8.1, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Prior Levy}
            SetTab(9.4, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Current Levy}
            SetTab(10.7, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Est school aid}

          end;  {else of If PrintBlankRates}

      Println('');

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {SetupGeneralRateSection}

{========================================================================}
Procedure TBillRatesForm.PrintGeneralRateSection(Sender : TObject);

{Print the general rates.}

var
  Done, FirstTimeThrough, Quit : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  GeneralRateTable.First;
  ProgressDialog.UserLabelCaption := 'General Rates.';

  with Sender as TBaseReport do
    begin
      NewPage;
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
         then FirstTimeThrough := False
          else
            try
              GeneralRateTable.Next;
            except
              Quit := True;
              SystemSupport(050, GeneralRateTable, 'Error getting general rate record.',
                            UnitName, GlblErrorDlgBox);
            end;

        If GeneralRateTable.EOF
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              {Update the progress panel.}

              with GeneralRateTable do
                begin
                    {FXX05041998-3: Incorrect field name.}

                  ProgressDialog.Update(Self, 'Print Order: ' +
                                              FieldByName('PrintOrder').Text);

                  ReportCancelled := ProgressDialog.Cancelled;

                  Print(#9 + FieldByName('PrintOrder').Text +
                        #9 + FieldByName('GeneralTaxType').Text +
                        #9 + FieldByName('SwisCode').Text +
                        #9 + FieldByName('SchoolCode').Text +
                        #9 + FieldByName('Description').Text);

                  If PrintBlankRates
                    then
                      begin
                        Underline := True;
                        Println(#9 + Take(35, '') +
                                #9 + Take(35, '') +
                                #9 + Take(35, '') +
                                #9 + #9);
                        Println('');
                        Underline := False;
                      end
                    else
                      begin
                        Print(#9 + FormatFloat(ExtendedDecimalDisplay_BlankZero,
                                               FieldByName('HomesteadRate').AsFloat));

                        If GlblMunicipalityUsesTwoTaxRates
                          then Print(#9 + FormatFloat(ExtendedDecimalDisplay_BlankZero,
                                                      Roundoff(FieldByName('NonhomesteadRate').AsFloat, 6)));

                        Println(#9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                                 FieldByName('CurrentTaxLevy').AsFloat) +
                                #9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                                 FieldByName('PriorTaxLevy').AsFloat) +
                                #9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                                 FieldByName('EstimatedStateAid').AsFloat));

                        Println('');

                      end;  {else of If PrintBlankRates}

                end;  {with GeneralRateTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 3)
                then NewPage;

            end;  {If not (Done or Quit)}

      until (Done or Quit or ReportCancelled);

    end;  {with Sender as TBaseReport do}

end;  {PrintGeneralRateSection}

{===========================================================================}
Procedure SetupSpecialDistrictSection(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      SetTab(0.5, pjLeft, 2.5, 0, BOXLINENONE, 0);   {Print order}
      Underline := True;
      Println('');
      Println(#9 + 'SPECIAL DISTRICT RATES:');
      Underline := False;
      Println('');

      ClearTabs;
      SetTab(0.5, pjCenter, 0.6, 0, BOXLINENONE, 0);   {SD code}
      SetTab(1.2, pjCenter, 2.0, 0, BOXLINENONE, 0);   {SD desc}
      SetTab(3.3, pjCenter, 0.3, 0, BOXLINENONE, 0);   {EXT code}
      SetTab(3.7, pjCenter, 1.0, 0, BOXLINENONE, 0);   {EXT desc}
      SetTab(4.8, pjCenter, 0.3, 0, BOXLINENONE, 0);   {CM flag}
      SetTab(5.2, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Hstd rate}
      SetTab(6.5, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Nonhstd rate}
      SetTab(7.8, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Prior Levy}
      SetTab(9.1, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Current Levy}

      Print(#9 + 'SD' +
            #9 + 'SPECIAL DISTRICT' +
            #9 + 'EXT' +
            #9 + 'EXTENSION' +
            #9 + 'C/M');

      If GlblMunicipalityUsesTwoTaxRates
        then Print(#9 + #9 + 'HSTD' +
                     #9 + 'NON-HSTD')
        else Print(#9);

        {FXX12181998-1: Switch the current and prior to match the screen.}

      Println(#9 + 'CURRENT' +
              #9 + 'PRIOR');

      ClearTabs;
      SetTab(0.5, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {SD code}
      SetTab(1.2, pjCenter, 2.0, 0, BOXLINEBottom, 0);   {SD desc}
      SetTab(3.3, pjCenter, 0.3, 0, BOXLINEBottom, 0);   {EXT code}
      SetTab(3.7, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {EXT desc}
      SetTab(4.8, pjCenter, 0.3, 0, BOXLINEBottom, 0);   {CM flag}
      SetTab(5.2, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Hstd rate}
      SetTab(6.5, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Nonhstd rate}
      SetTab(7.8, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Prior Levy}
      SetTab(9.1, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Current Levy}

      Print(#9 + 'CODE' +
            #9 + 'DESCRIPTION' +
            #9 + 'CD' +
            #9 + 'DESCRIPTION' +
            #9 + 'FLAG' +
            #9 + 'RATE');

      If GlblMunicipalityUsesTwoTaxRates
        then Print(#9 + 'RATE');

      Println(#9 + 'LEVY' +
              #9 + 'LEVY');

      ClearTabs;
      SetTab(0.5, pjLeft, 0.6, 0, BOXLINENONE, 0);   {SD code}
      SetTab(1.2, pjLeft, 2.0, 0, BOXLINENONE, 0);   {SD desc}
      SetTab(3.3, pjLeft, 0.3, 0, BOXLINENONE, 0);   {EXT code}
      SetTab(3.7, pjLeft, 1.0, 0, BOXLINENONE, 0);   {EXT desc}
      SetTab(4.8, pjCenter, 0.3, 0, BOXLINENONE, 0);   {CM flag}

      If PrintBlankRates
        then
          begin
            SetTab(5.2, pjRight, 1.2, 0, BOXLINENone, 0);   {Hstd rate}
            SetTab(6.5, pjRight, 1.2, 0, BOXLINENone, 0);   {Nonhstd rate}
            SetTab(7.8, pjRight, 1.2, 0, BOXLINENone, 0);   {Prior Levy}
            SetTab(9.1, pjRight, 1.2, 0, BOXLINENone, 0);   {Current Levy}
          end
        else
          begin
            SetTab(5.2, pjRight, 1.2, 0, BOXLINEBottom, 0);   {Hstd rate}
            SetTab(6.5, pjRight, 1.2, 0, BOXLINEBottom, 0);   {Nonhstd rate}
            SetTab(7.8, pjRight, 1.2, 0, BOXLINEBottom, 0);   {Prior Levy}
            SetTab(9.1, pjRight, 1.2, 0, BOXLINEBottom, 0);   {Current Levy}
          end;

      Bold := False;

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {SetupSpecialDistrictSection}

{========================================================================}
Procedure TBillRatesForm.PrintSpecialDistrictSection(Sender : TObject);

{Print the special district rates.}

var
  Done, FirstTimeThrough, Quit : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  SDistRateTable.First;
  ProgressDialog.UserLabelCaption := 'Special District Rates.';

  with Sender as TBaseReport do
    begin
      NewPage;

        {First print the individual changes.}

      repeat
        If FirstTimeThrough
         then FirstTimeThrough := False
          else
            try
              SDistRateTable.Next;
            except
              Quit := True;
              SystemSupport(050, SDistRateTable, 'Error getting SD rate record.',
                            UnitName, GlblErrorDlgBox);
            end;

        If SDistRateTable.EOF
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              {Update the progress panel.}

              with SDistRateTable do
                begin
                  ProgressDialog.Update(Self, 'SD code: ' +
                                              FieldByName('SDistCode').Text);

                  ReportCancelled := ProgressDialog.Cancelled;

                  Print(#9 + FieldByName('SDistCode').Text +
                          #9 + Take(18, FieldByName('SDistDescr').Text) +
                          #9 + FieldByName('ExtCode').Text +
                          #9 + Take(12, FieldByName('SDistExtDescr').Text) +
                          #9 + FieldByName('CMFlag').Text);

                  If PrintBlankRates
                    then
                      begin
                        Underline := True;
                        Println(#9 + Take(35, '') +
                                #9 + Take(35, '') +
                                #9 + Take(35, '') + #9);
                        Println('');
                        Underline := False;
                      end
                    else
                      begin
                        Print(#9 + FormatFloat(ExtendedDecimalDisplay_BlankZero,
                                               FieldByName('HomesteadRate').AsFloat));

                        If GlblMunicipalityUsesTwoTaxRates
                          then Print(#9 + FormatFloat(ExtendedDecimalDisplay_BlankZero,
                                                      Roundoff(FieldByName('NonhomesteadRate').AsFloat, 6)));

                        Println(#9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                                 FieldByName('CurrentTaxLevy').AsFloat) +
                                #9 + FormatFloat(CurrencyNormalDisplay_BlankZero,
                                                 FieldByName('PriorTaxLevy').AsFloat));

                        Println('');

                      end;  {else of If PrintBlankRates}

                end;  {with SDistRateTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 3)
                then NewPage;

            end;  {If not (Done or Quit)}

      until (Done or Quit or ReportCancelled);

    end;  {with Sender as TBaseReport do}

end;  {PrintSpecialDistrictSection}

{===========================================================================}
Procedure SetupSpecialFeeSection(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      SetTab(0.5, pjLeft, 2.5, 0, BOXLINENONE, 0);   {Print order}
      Underline := True;
      Println('');
      Println(#9 + 'SPECIAL FEES:');
      Underline := False;
      Println('');

      ClearTabs;
      SetTab(0.5, pjCenter, 0.6, 0, BOXLINENONE, 0);   {Print order}
      SetTab(1.2, pjCenter, 2.0, 0, BOXLINENONE, 0);   {Desc}
      SetTab(3.3, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Fixed amt}
      SetTab(4.4, pjCenter, 0.6, 0, BOXLINENONE, 0);   {%}
      SetTab(5.1, pjCenter, 0.5, 0, BOXLINENONE, 0);   {Amt in 1st payment}

      Println(#9 + 'PRINT' +
              #9 + #9 + #9 + #9 + '1st');

      ClearTabs;
      SetTab(0.5, pjCenter, 0.6, 0, BOXLINENONE, 0);   {Print order}
      SetTab(1.2, pjCenter, 2.0, 0, BOXLINENONE, 0);   {Desc}
      SetTab(3.3, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Fixed amt}
      SetTab(4.4, pjCenter, 0.6, 0, BOXLINENONE, 0);   {%}
      SetTab(5.1, pjCenter, 0.5, 0, BOXLINENONE, 0);   {Amt in 1st payment}

      Println(#9 + 'ORDER' +
              #9 + 'DESCRIPTION' +
              #9 + 'AMOUNT' +
              #9 + 'PERCENT' +
              #9 + 'PAY ?');

      ClearTabs;
      SetTab(0.5, pjLeft, 0.6, 0, BOXLINENONE, 0);   {Print order}
      SetTab(1.2, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Desc}
      SetTab(3.3, pjRight, 1.2, 0, BOXLINENONE, 0);   {Fixed amt}
      SetTab(4.4, pjRight, 0.6, 0, BOXLINENONE, 0);   {%}
      SetTab(5.1, pjCenter, 0.5, 0, BOXLINENONE, 0);   {Amt in 1st payment}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {SetupSpecialFeeSection}

{========================================================================}
Procedure TBillRatesForm.PrintSpecialFeeSection(Sender : TObject);

{Print the special Fee rates.}

var
  TempStr : String;
  Done, FirstTimeThrough, Quit : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  SpclFeeTable.First;
  ProgressDialog.UserLabelCaption := 'Special Fees.';

  with Sender as TBaseReport do
    begin
      NewPage;

        {First print the individual changes.}

      repeat
        If FirstTimeThrough
         then FirstTimeThrough := False
          else
            try
              SpclFeeTable.Next;
            except
              Quit := True;
              SystemSupport(050, SpclFeeTable, 'Error getting special fee rate record.',
                            UnitName, GlblErrorDlgBox);
            end;

        If SpclFeeTable.EOF
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              {Update the progress panel.}

              with SpclFeeTable do
                begin
                  ProgressDialog.Update(Self, 'Print Order: ' +
                                              FieldByName('PrintOrder').Text);

                  ReportCancelled := ProgressDialog.Cancelled;

                  TempStr := '';
                  If FieldByName('AmtInFirstPayment').AsBoolean
                    then TempStr := 'X';

                  Println(#9 + FieldByName('PrintOrder').Text +
                          #9 + Take(18, FieldByName('Description').Text) +
                          #9 + FormatFloat(CurrencyDecimalDisplay_BlankZero,
                                           FieldByName('FixedAmount').AsFloat) +
                          #9 + FormatFloat(DecimalDisplay_BlankZero,
                                           FieldByName('Percentage').AsFloat) +
                          #9 + TempStr);

                end;  {with SpclFeeTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 3)
                then NewPage;

            end;  {If not (Done or Quit)}

      until (Done or Quit or ReportCancelled);

    end;  {with Sender as TBaseReport do}

end;  {PrintSpecialFeeSection}

{===========================================================================}
Procedure TBillRatesForm.ReportPrintHeader(Sender: TObject);

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
      SetFont('Times New Roman',10);
      Bold := True;
      Home;
      PrintCenter('BILL CALCULATION RATES', (PageWidth / 2));
      Bold := False;
      CRLF;
      CRLF;

      Underline := False;
      ClearTabs;
      SetTab(0.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Roll year}
      SetTab(2.1, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Collection type}
      SetTab(4.2, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Collection Num}

      Println(#9 + 'Roll Year: ' + TaxRollYear +
              #9 + 'Collection Type: ' + CollectionType +
              #9 + 'Collection Num: ' + IntToStr(CollectionNum));

      If (ReportSection = 'GN')  {General rates}
        then SetupGeneralRateSection(Sender);

      If (ReportSection = 'SD')  {Special district rates}
        then SetupSpecialDistrictSection(Sender);

      If (ReportSection = 'SF')  {Special fee rates}
        then SetupSpecialFeeSection(Sender);

    end;  {with Sender as TBaseReport do}

end;  {with Sender as TBaseReport do}

{===========================================================================}
Procedure TBillRatesForm.PrintButtonClick(Sender: TObject);

{CHG05011998-1: Print out the rates.}

var
  NewFileName : String;
  TempFile : File;
  Quit : Boolean;

begin
  ReportCancelled := False;

  If PrintDialog.Execute
    then
      begin
          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], True, Quit);

          {FXX12141998-4: Allow printing of rates with empty slots so person
                          can fill in.}

        PrintBlankRates := PrintBlankRatesCheckBox.Checked;

        ProgressDialog.Start(GetRecordCount(GeneralRateTable) +
                             GetRecordCount(SDistRateTable) +
                             GetRecordCount(SpclFeeTable), True, True);

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

        If PrintDialog.PrintToFile
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
          else ReportPrinter.Execute;

          {Clear the selections.}

        ProgressDialog.Finish;

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{================================================================}
Procedure TBillRatesForm.ReportBeforePrint(Sender: TObject);

begin
  ReportSection := 'GR';
end;

{================================================================}
Procedure TBillRatesForm.ReportPrint(Sender: TObject);

begin
    {FXX11301999-4: Print the general setup.}

  PrintGeneralSetup(Sender);

  ReportSection := 'GN';
  PrintGeneralRateSection(Sender);

  ReportSection := 'SD';
  If not ReportCancelled
    then PrintSpecialDistrictSection(Sender);

  ReportSection := 'SF';
  If ((not ReportCancelled) and
      (SpclFeeTable.RecordCount > 0) and
      (not SpclFeeTable.EOF))
    then PrintSpecialFeeSection(Sender);

end;  {ReportPrint}



end.