unit Billprnt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Btrvdlg, wwdblook, Mask,types,pastypes,
  Glblcnst, Gauges,Printrng, RPMemo, RPDBUtil, RPDefine, (*Progress,*) RPTXFilr,
  RPFPrint, RPreview, TabNotBk, Prog, ComCtrls, RPRave, RPCon, RPConDS;

type
  TPrintBillsForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    PrintDialog: TPrintDialog;
    CollectionLookupTable: TwwTable;
    BillCollTypeLookupTable: TwwTable;
    BLSpecialDistrictTaxTable: TTable;
    BLExemptionTaxTable: TTable;
    BLGeneralTaxTable: TTable;
    BLHeaderTaxTable: TTable;
    BLSpecialFeeTaxTable: TTable;
    AssessmentYearCtlTable: TTable;
    SDCodeTable: TTable;
    ReportPrinter: TReportPrinter;
    BillParameterTable: TTable;
    BillParamDataSource: TDataSource;
    SwisCodeTable: TTable;
    SchoolCodeTable: TTable;
    SysRecTable: TTable;
    ParcelTable: TTable;
    ArrearsMessageTable: TTable;
    ArrearsMessageDataSource: TDataSource;
    ThirdPartyNotificationTable: TTable;
    RaveBillInfoHeaderTable: TTable;
    RaveBillCollectionInfoTable: TTable;
    RaveBillBaseSDDetailsTable: TTable;
    RaveBillEXDetailsTable: TTable;
    ReportFiler: TReportFiler;
    Panel4: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditTaxRollYear: TEdit;
    LookupCollectionType: TwwDBLookupCombo;
    EditCollectionNumber: TEdit;
    Panel5: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    BillTabbedNotebook: TTabbedNotebook;
    PrintOrderRadioGroup: TRadioGroup;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    StartDataLabel: TLabel;
    StartDetailLabel: TLabel;
    StartDetailLabel2: TLabel;
    ZipPlus4Label: TLabel;
    StartingBankLabel: TLabel;
    NameSBLEdit: TEdit;
    StartDataEdit: TEdit;
    LATextEdit: TEdit;
    LANoEdit: TEdit;
    ZipPlus4Edit: TEdit;
    StartingBankEdit: TEdit;
    BankCodesExcludedStringGrid: TStringGrid;
    Label9: TLabel;
    SwisCodeListBox: TListBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label7: TLabel;
    AssessmentRollDateDBEdit: TDBEdit;
    FullMktValDBEdit: TDBEdit;
    FiscalYearDBEdit: TDBEdit;
    WarrantDateYrDBEdit: TDBEdit;
    EditTaxYear: TDBEdit;
    SaveBillParamterButton: TBitBtn;
    CancelBillParameterButton: TBitBtn;
    EditDelinquencyDate: TDBEdit;
    EditEndOfCollection: TDBEdit;
    GroupBox2: TGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    TopSectionEdit: TEdit;
    DetailsEdit: TEdit;
    MPSchoolDetailsEdit: TEdit;
    BankCodedBillsOptionRadioGroup: TRadioGroup;
    ArrearsMemo: TDBMemo;
    UseAccuzipCheckBox: TCheckBox;
    Label2: TLabel;
    EndOfNoPenaltyDateEdit: TDBEdit;
    Label8: TLabel;
    EditBillingDate: TDBEdit;
    OpenDialog: TOpenDialog;
    AccuzipValidationTypeRadioGroup: TRadioGroup;
    LastYearGeneralTaxTable: TTable;
    LastYearSpecialDistrictTaxTable: TTable;
    RAVELevyChangeTable: TTable;
    GeneralTaxRateTable: TTable;
    cb_PrintPositiveBillsOnly: TCheckBox;
    Label13: TLabel;
    Label14: TLabel;
    edLowUniformPercent: TDBEdit;
    edHighUniformPercent: TDBEdit;
    GroupBox3: TGroupBox;
    edPageStart: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    edPageEnd: TEdit;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ProgressDialogCancel(Sender: TObject);
    procedure PrintOrderRadioGroupClick(Sender: TObject);
    procedure ReportPrinterBeforePrint(Sender: TObject);
    procedure ReportPrinterPrint(Sender: TObject);
    procedure BillParameterTableNewRecord(DataSet: TDataset);
    procedure SaveBillParamterButtonClick(Sender: TObject);
    procedure CancelBillParameterButtonClick(Sender: TObject);
    procedure SetBillingCycle(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    GeneralRateList,
    SDRateList,
    SpecialFeeRateList,
    BillControlDetailList,
    SDExtCategoryList,
    PropertyClassDescList,
    RollSectionDescList,
    EXCodeDescList,
    SDCodeDescList,
    SDExtCodeDescList,
    SwisCodeDescList,
    SchoolCodeDescList : TList;

    ExcludedBankCodes, SelectedSwisCodes : TStringList;

    TotalBilled, TotalNotBilled : Extended;
    TotalRS8_NoBill, TotalRS9_NoBill,
    NumBilled, NumNotBilled, NumBankCoded, NumBillsPrinted : LongInt;

    CollectionType, TaxRollYear,
    LastRollSection, LastSwisCode,
    LastSchoolCode, SequenceStr,  {Text of what order the roll is printing in.}
    UnitName, RollPrintingYear : String;

    LoadFromParcelList, FoundCollectionRec,
    CurrentlyPrintingThirdPartyNotices, PrintingCancelled : Boolean;
    CollectionNum, BillType,
    NumThirdPartyNotices, BankCodedBillsOption, AccuzipValidationType : Integer;
    UseAccuzip, PrintPositiveBillsOnly : Boolean;

    iCurrentPage, iPageRangeStart, iPageRangeEnd : LongInt;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function ParcelShouldBePrinted(BLHeaderTaxTable : TTable;
                                   SelectedSwisCodes : TStringList;
                                   CurrentlyPrintingThirdPartyNotices : Boolean;
                                   BankCodedBillsOption : Integer;
                                   UseAccuzip : Boolean;
                                   AccuzipValidationType : Integer;
                                   PrintPositiveBillsOnly : Boolean) : Boolean;

    Procedure InterfaceWithAccuzip;
                                       
    Procedure GenerateOrPrintBills(Sender : TObject);

    Procedure PrintRAVEBills;

  end;

const
  btHastings = 0;
  btWesleyHills = 1;
  btMtPleasantSchool = 2;
  btMtPleasantTown = 3;
  btSomersTown = 4;
  btRyeCity = 5;
  btRyeCounty = 6;
  btRyeSchool = 7;
  btSomersSchool = 8;
  btLawrenceVillage = 9;
  btBrookvilleVillage = 10;
  btScarsdaleVillage_County = 11;
  btRyeCity_County = 12;
  btMalverne = 13;
  btEastchesterSchool = 14;
  btScarsdaleSchool = 15;
  btSuffernSewer = 16;
  btEastchesterTown = 17;
  btSuffernSewer2ndHalf = 18;
  btLakeSuccess = 19;
  btEastHampton = 20;
  btSouthampton = 21;
  btTarrytown = 22;
  btMasticBeach = 23;

  bcbBankCodedBillsOnly = 0;
  bcbNoBankCodedBills = 1;
  bcbAllBills = 2;

  TrialRun = False;

  actValid = 0;
  actInvalid = 1;
  actEither = 2;

implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview,
     DataAccessUnit,
     PRCLLIST,  {Parcel list}
     BLPRTUNT,  {Actual bill printing procedures}
     UtilBill,  {Billing specific utilities.}
     Utrtotpt;  {Section totals print unit}

{$R *.DFM}

{========================================================}
Procedure TPrintBillsForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TPrintBillsForm.InitializeForm;

var
  I : Integer;
  FirstTimeThrough, Done : Boolean;

begin
  UnitName := 'BCOLLBIL.PAS';  {mmm}

      {Only let them print bills in this year.}

    {FXX10131997-1: Don't open the tables if not this year - causes error.}

  If (GlblTaxYearFlg = 'T')
    then
      begin
          {Note that the billing tax files do not get opened below.
           They get opened once the person fills in the collection type and
           number.}

        OpenTablesForForm(Self, ThisYear);

          {FXX03181999-6: Let them choose the swis code(s) to print.}

          {Fill in the swis code list.}

        SwisCodeTable.First;

        FirstTimeThrough := True;
        Done := False;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SwisCodeTable.Next;

          If SwisCodeTable.EOF
            then Done := True;

          If not Done
            then SwisCodeListBox.Items.Add(SwisCodeTable.FieldByName('SwisCode').Text);

        until Done;

          {Default to all swis codes.}

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          SwisCodeListBox.Selected[I] := True;

        SelectedSwisCodes := TStringList.Create;

      end
    else
      begin
        MessageDlg('The tax bills can only be printed in this year processing.' + #13 +
                   'Please choose the "This Year" assessment year from the main menu.',
                   mtError, [mbOK], 0);
        Close;

     end;  {If (GlblTaxYearFlg <> 'T')}

  EditTaxRollYear.Text := GlblThisYear;

    {FXX03032004-2(2.07l2): Set the top section position of Mt. Pleasant to 0.1.}

  case BillType of
    btHastings :
      begin
        TopSectionEdit.Text := '0.5';
        DetailsEdit.Text := '4.9';
        MPSchoolDetailsEdit.Text := '7.52';
      end;

    btMtPleasantSchool :
    begin
      TopSectionEdit.Text := '0.795';
      MPSchoolDetailsEdit.Text := '6.18';
    end;

    btMtPleasantTown : TopSectionEdit.Text := '0.1';
    btLawrenceVillage : TopSectionEdit.Text := '1.1625';
    btWesleyHills : TopSectionEdit.Text := '0.575';

    btSomersTown :
      begin
        TopSectionEdit.Text := '0.66';
        DetailsEdit.Text := '3.00';
        MPSchoolDetailsEdit.Text := '5.6';
      end;

    btSomersSchool :
      begin
        TopSectionEdit.Text := '0.528';
        DetailsEdit.Text := '3.00';
        MPSchoolDetailsEdit.Text := '6.88';
      end;


  end;  {case BillType of}

end;  {InitializeForm}

{===================================================================}
Procedure TPrintBillsForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{========================================================================}
Procedure TPrintBillsForm.PrintOrderRadioGroupClick(Sender: TObject);

begin
       {set starting/ending data prompts based on key selected}

  case PrintOrderRadioGroup.ItemIndex of
    0 : begin
          StartDataEdit.Visible := False;
          StartDataLabel.Visible := False;
          StartDetailLabel2.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          LANoEdit.Visible := False;
          LATextEdit.Visible := False;

          StartDetailLabel.Caption := 'Starting Parcel ID';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;

        end;  {SBL}

    1 : begin
          StartDataEdit.Visible := False;
          StartDataLabel.Visible := False;
          LANoEdit.Visible := False;
          LATextEdit.Visible := False;
          StartDetailLabel2.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          StartDetailLabel.Caption := 'Starting Name';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;
          LANoEdit.Text := '';
          LATextEdit.Text := '';

        end;  {Name}

    2 : begin
          StartDataEdit.Visible := False;
          StartDataLabel.Visible := False;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := False;
          StartDetailLabel.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          StartDetailLabel2.Caption := 'Starting Address (# and Street)';
          StartDetailLabel2.Visible := True;

          LANoEdit.Text := '';
          LATextEdit.Text := '';
          LANoEdit.Visible := True;
          LATextEdit.Visible := True;

        end;  {Address}

    3 : begin
          StartDataEdit.Visible := True;
          ZipPlus4Edit.Visible := True;
          ZipPlus4Label.Visible := True;
          ZipPlus4Edit.Text := '';
          StartDataLabel.Caption := 'Starting Zip';
          StartDataLabel.Visible := True;
          LANoEdit.Visible := False;
          LATextEdit.Visible := False;
          StartDetailLabel2.Visible := False;

          StartDetailLabel.Caption := 'Starting Parcel ID';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;

        end;  {Zip / SBL}

    4 : begin
          StartDataEdit.Visible := True;
          ZipPlus4Label.Visible := True;
          ZipPlus4Edit.Visible := True;
          ZipPlus4Edit.Text := '';
          StartDataLabel.Caption := 'Starting Zip';
          StartDataLabel.Visible := True;
          LANoEdit.Visible := False;
          LATextEdit.Visible := False;
          StartDetailLabel2.Visible := False;

          StartDetailLabel.Caption := 'Starting Name';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;

        end;  {Zip \ Name}

    5 : begin
          StartDataEdit.Visible := True;
          StartDataLabel.Caption := 'Starting Zip';
          StartDataLabel.Visible := True;
          ZipPlus4Edit.Visible := True;
          ZipPlus4Label.Visible := True;
          ZipPlus4Edit.Text := '';
          NameSBLEdit.Visible := False;
          StartDetailLabel.Visible := False;

          StartDetailLabel2.Caption := 'Starting Address (# and Street)';
          StartDetailLabel2.Visible := True;

          LANoEdit.Text := '';
          LATextEdit.Text := '';
          LANoEdit.Visible := True;
          LATextEdit.Visible := True;

        end;  {Zip \ addr}

    6 : begin
          StartDataEdit.Text := '';
          StartDataEdit.Visible := True;
          StartDataLabel.Caption := 'Starting Bank';
          StartDataLabel.Visible := True;
          LANoEdit.Visible := False;
          LATextEdit.Visible := False;
          StartDetailLabel2.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          StartDetailLabel.Caption := 'Starting Parcel ID';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;

        end; {Bank \ SBL}

    7 : begin
          StartDataEdit.Text := '';
          StartDataEdit.Visible := True;
          StartDataLabel.Caption := 'Starting Bank';
          StartDataLabel.Visible := True;
          LANoEdit.Visible := False;
          LATextEdit.Visible := False;
          StartDetailLabel2.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          StartDetailLabel.Caption := 'Starting Name';
          StartDetailLabel.Visible := True;
          NameSBLEdit.Text := '';
          NameSBLEdit.Visible := True;

        end;  {Bank / name}

    8 : begin
          StartDataEdit.Text := '';
          StartDataEdit.Visible := True;
          StartDataLabel.Caption := 'Starting Bank';
          StartDataLabel.Visible := True;
          NameSBLEdit.Visible := False;
          StartDetailLabel.Visible := False;
          ZipPlus4Edit.Visible := False;
          ZipPlus4Label.Visible := False;
          ZipPlus4Edit.Text := '';

          StartDetailLabel2.Caption := 'Starting Address (# and Street)';
          StartDetailLabel2.Visible := True;

          LANoEdit.Text := '';
          LATextEdit.Text := '';
          LANoEdit.Visible := True;
          LATextEdit.Visible := True;

        end;  {Bank / addr}

       {CHG01162001-1: Add bank\zip\sbl sort order for Rye.}

    9 : begin
          StartDataEdit.Text := '';
          StartDataEdit.Visible := True;
          StartDataLabel.Caption := 'Starting Zip';
          StartDataLabel.Visible := True;
          NameSBLEdit.Visible := True;
          NameSBLEdit.Text := '';
          StartDetailLabel.Visible := False;
          ZipPlus4Edit.Visible := True;
          ZipPlus4Label.Visible := True;
          ZipPlus4Edit.Text := '';
          StartingBankLabel.Visible := True;
          StartingBankEdit.Visible := True;
          StartingBankEdit.Text := '';

          StartDetailLabel.Caption := 'Starting Parcel ID';
          StartDetailLabel.Visible := True;

          LANoEdit.Text := '';
          LATextEdit.Text := '';
          LANoEdit.Visible := False;
          LATextEdit.Visible := False;

        end;  {Bank \ Zip \ SBL}

  end;  {end Case}

end;  {PrintOrderRadioGroupClick}

{===================================================================}
Procedure TPrintBillsForm.SaveBillParamterButtonClick(Sender: TObject);

{FXX0318199-5: Allow for save or cancel of billing parameters.}

begin
  try
    BillParameterTable.Post;
  except
  end;

end;

{====================================================================}
Procedure TPrintBillsForm.CancelBillParameterButtonClick(Sender: TObject);

begin
  try
    BillParameterTable.Cancel;
  except
  end;
end;

{=====================================================================}
Procedure TPrintBillsForm.BillParameterTableNewRecord(DataSet: TDataset);

begin
  with BillParameterTable do
    begin
      FieldByName('TaxRollYr').Text := GlblThisYear;
      FieldByName('CollectionType').Text := LookupCollectionType.Text;
    end;  {with BillParameterTable do}

end;  {BillParameterTableNewRecord}

{========================================================================}
Procedure TPrintBillsForm.SetBillingCycle(Sender: TObject;
                                                      LookupTable,
                                                      FillTable: TDataSet;
                                                      modified: Boolean);

{Once they select the collection type, load the parameter file. If there is
 not one, put it in insert mode.}

var
  _Found : Boolean;

begin
  If (Deblank(LookupCollectionType.Text) <> '')
    then
      begin
        with BillParameterTable do
          begin
              {If the last table they were working on is not posted, then post it.}

            If (State in [dsEdit, dsInsert])
              then Post;

            _Found := FindKeyOld(BillParameterTable, ['TaxRollYr', 'CollectionType'],
                                 [GlblThisYear, LookupCollectionType.Text]);

            If _Found
              then Edit
              else Insert;

          end;  {with BillParameterTable do}

      end;  {If ((Deblank(LookupCollectionType.Text) <> '')}

end;  {SetBillingCycle}

{=====================================================================}
Procedure TPrintBillsForm.PrintButtonClick(Sender: TObject);

var
  I, J, IndexPos : Integer;
  BankExcluded,
  Found, OKToStartPrinting, Quit : Boolean;
  TempIndex, NewFileName, TempIndexName,
  HeaderFileName, GeneralFileName,
  EXFileName, SDFileName, SpecialFeeFileName : String;

begin
  iCurrentPage := 0;

  try
    iPageRangeStart := StrToInt(edPageStart.Text);
  except
    iPageRangeStart := 1;
  end;

  try
    iPageRangeEnd := StrToInt(edPageEnd.Text);
  except
    iPageRangeEnd := 29999;
  end;

  UseAccuzip := UseAccuzipCheckBox.Checked;
  AccuzipValidationType := AccuzipValidationTypeRadioGroup.ItemIndex;
  PrintPositiveBillsOnly := cb_PrintPositiveBillsOnly.Checked;

  CollectionNum := 0;
  Found := False;
  BankCodedBillsOption := BankCodedBillsOptionRadioGroup.ItemIndex;
  OKToStartPrinting := True;
  GlblCurrentTabNo := 0;

  If (Deblank(EditTaxRollYear.Text) = '')
    then
      begin
        MessageDlg('Please enter the tax roll year.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

  If (Deblank(EditCollectionNumber.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection number.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

  If (Deblank(LookupCollectionType.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection type.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

    {If they have entered all the information, look it up in the bill
     control file to make sure that a collection exists for what they
     entered.}

  If OKToStartPrinting
    then
      begin
        TaxRollYear := Take(4, EditTaxRollYear.Text);
        CollectionType := Take(2, LookupCollectionType.Text);
        CollectionNum := StrToInt(Deblank(EditCollectionNumber.Text));

        try
          Found := FindKeyOld(CollectionLookupTable,
                              ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                              [TaxRollYear, CollectionType,
                               IntToStr(CollectionNum)]);
        except
          OKToStartPrinting := False;
          SystemSupport(010, CollectionLookupTable, 'Error getting bill control record.',
                        UnitName, GlblErrorDlgBox);
        end;

        If Found
          then
            begin
              If (MessageDlg('You are going to print tax bills for collection type ' + CollectionType + ',' + #13 +
                             'collection number ' + IntToStr(CollectionNum) + '.' + #13 + #13 +
                             'Do you want to proceed?',
                             mtConfirmation, [mbYes, mbNo], 0) = idNo)
                then OKToStartPrinting := False;

            end
          else
            begin
              MessageDlg('The collection that you entered does not exist.' + #13 +
                         'Please try again.', mtError, [mbOK], 0);
              OKToStartPrinting := False;
            end;

      end;  {If OKToStartPrinting}

       {allow user to stop if no bank codes were excluded}

  If OKToStartPrinting
    then
      begin
        BankExcluded := False;

        with BankCodesExcludedStringGrid do
          For I := 0 to (ColCount - 1) do
            For J := 0 to (RowCount - 1) do
              If (Deblank(Cells[I,J]) <> '')
                then BankExcluded := True;

        If ((not BankExcluded) and
            (MessageDlg('You have not excluded any bank codes for this '+ #13 +
                        'bill print run.' + #13 + #13 + 'Do you want to proceed?',
                        mtConfirmation, [mbYes, mbNo], 0) = idNo))
          then OKToStartPrinting := False;

      end;  {If OKToStartPrinting}

    {Set the print index.}

  LoadFromParcelList := False;
  TempIndex := '';

  If OKToStartPrinting
    then
      with BLHeaderTaxTable do
        case PrintOrderRadioGroup.ItemIndex of
          0 : begin
                TempIndex := 'SBLKey';
                TempIndexName := 'BySBLKey';
              end;
          1 : begin
                TempIndex := 'Name1';
                TempIndexName := 'ByName1';
              end;
          2 : begin
                TempIndex := 'LegalAddr+LegalAddrNo';
                TempIndexName := 'ByLegalAddr';
              end;
          3 : begin
                TempIndex := 'Zip+ZipPlus4+SBLKey';
                TempIndexName := 'ByZip_SBL';
              end;
          4 : begin
                TempIndex := 'Zip+ZipPlus4+Name1';
                TempIndexName := 'ByZip_Name1';
              end;
          5 : begin
                TempIndex := 'Zip+ZipPlus4+LegalAddr+LegalAddrNo';
                TempIndexName := 'ByZip_LegalAddr';
              end;
          6 : begin
                TempIndex := 'BankCode+SBLKey';
                TempIndexName := 'ByBank_SBL';
              end;
          7 : begin
                TempIndex := 'BankCode+Name1';
                TempIndexName := 'ByBank_Name';
              end;
          8 : begin
                TempIndex := 'BankCode+LegalAddr+LegalAddrNo';
                TempIndexName := 'ByBank_LegalAddr';
              end;
          9 : begin
                TempIndex := 'BankCode+Zip+ZipPlus4+SBLKey';
                TempIndexName := 'ByBank_Zip_SBL';
              end;
          10 : LoadFromParcelList := True;
          11 : begin
                TempIndex := 'BillNO';
                TempIndexName := 'ByBillNo';
              end;
          else
            begin
              MessageDlg('You must select a print order for the bills.',
                         mtError, [mbOK], 0);
              OKToStartPrinting := False;
            end;

        end;  {case IndexRadioGroup.ItemIndex of}

    {If they entered a collection that exists, then open the billing and
     totals files, get the rates, and start the billing.}

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

    {Instead of printing a bill, we will add it to the RAVE sort files
     and invoke RAVE later to do the actual printing.}

  If (OKToStartPrinting and
(*      (_Compare(BillType, [btBrookvilleVillage, btScarsdaleVillage_County, btRyeCity_County,
                           btMalverne, btEastchesterSchool, btScarsdaleSchool,
                           btSuffernSewer, btEastchesterTown, btSuffernSewer2ndHalf,
                           btLakeSuccess, btEastHampton, btSouthampton, btTarrytown], coEqual) or *)
      (glblUsesRAVEBills or
       PrintDialog.Execute))
    then
      begin
        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(SwisCodeListBox.Items[I]);

          {Post the parameter file if we need to.}

        with BillParameterTable do
          If (State in [dsEdit, dsInsert])
            then Post;

        Quit := False;
        NumBillsPrinted := 0;
        PrintingCancelled := False;

         {create the excluded bank code list}
         {and fill it in from excluded bank string grid}

        ExcludedBankCodes := TStringList.Create;

        with BankCodesExcludedStringGrid do
          For I := 0 to (ColCount - 1) do
            For J := 0 to (RowCount - 1) do
              If (Deblank(Cells[I,J]) <> '')
                then ExcludedBankCodes.Add(Trim(Cells[I,J]));


        TotalBilled := 0;
        TotalNotBilled := 0;
        NumBilled := 0;
        NumNotBilled := 0;
        NumBankCoded := 0;

          {CHG03221999-1: Include count of number of rs 8, no bill.}

        TotalRS8_NoBill := 0;
        TotalRS9_NoBill := 0;

          {Create the rate lists.}

        GeneralRateList := TList.Create;
        SDRateList := TList.Create;
        SpecialFeeRateList := TList.Create;
        BillControlDetailList := TList.Create;

          {Description lists}

        SDExtCategoryList := TList.Create;
        PropertyClassDescList := TList.Create;
        EXCodeDescList := TList.Create;
        SDCodeDescList := TList.Create;
        SwisCodeDescList := TList.Create;
        SchoolCodeDescList := TList.Create;
        SDExtCodeDescList := TList.Create;
        RollSectionDescList := TList.Create;

        OpenTableForProcessingType(ParcelTable, ParcelTableName, ThisYear, Quit);

          {CHG03161999-1: Add in an arrears message.}

        ArrearsMessageTable.Open;

        FindKeyOld(ArrearsMessageTable,
                   ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                   [TaxRollYear, CollectionType, IntToStr(CollectionNum)]);

          {Get the file names and open the billing files for this
           tax year\municipal type\collection #.}

        GetBillingFileNames(TaxRollYear, CollectionType,
                            ShiftRightAddZeroes(Take(2, IntToStr(CollectionNum))),
                            HeaderFileName, GeneralFileName,
                            EXFileName, SDFileName, SpecialFeeFileName);

        OpenBillingFiles(HeaderFileName, GeneralFileName, EXFileName,
                         SDFileName, SpecialFeeFileName, BLHeaderTaxTable,
                         BLGeneralTaxTable, BLExemptionTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLSpecialFeeTaxTable, Quit);

          {Set to the correct index if it exists or create it.}

        IndexPos := BLHeaderTaxTable.IndexDefs.IndexOf(TempIndex);

        If (IndexPos = -1)
          then
            try
              BLHeaderTaxTable.AddIndex(TempIndexName,
                                        TempIndex,
                                        [ixExpression]);
            except
            end;

        BLHeaderTaxTable.IndexName := TempIndexName;

          {Now load the rate and description lists.}

        If not Quit
          then
            begin
              LoadRateListsFromRateFiles(TaxRollYear, CollectionType,
                                         CollectionNum, GeneralRateList,
                                         SDRateList,
                                         SpecialFeeRateList,
                                         BillControlDetailList, 'P', Quit);

              LoadSDExtCategoryList(SDExtCategoryList, Quit);

              LoadCodeList(PropertyClassDescList, 'ZPropClsTbl',
                           'MainCode', 'Description', Quit);

              LoadCodeList(RollSectionDescList, 'ZRollSectionTbl',
                           'MainCode', 'Description', Quit);

              LoadCodeList(EXCodeDescList, 'TExCodeTbl',
                           'ExCode', 'Description', Quit);

              LoadCodeList(SDCodeDescList, 'TSDCodeTbl',
                           'SDistCode', 'Description', Quit);

              LoadCodeList(SwisCodeDescList, 'TSwisTbl',
                           'SwisCode', 'MunicipalityName', Quit);

              LoadCodeList(SchoolCodeDescList, 'TSchoolTbl',
                           'SchoolCode', 'SchoolName', Quit);

              LoadCodeList(SDExtCodeDescList, 'ZSDExtCodeTbl',
                           'MainCode', 'Description', Quit);

            end;  {If not Quit}

          {Now, print the bills.}
          {CHG12301997-1: Change the report printer and filer to the
                          TextPrinter component.}

        If not Quit
          then
            begin
              PrintingCancelled := False;

              If LoadFromParcelList
                then ProgressDialog.Start(ParcelListDialog.NumItems, True, True)
                else ProgressDialog.Start(GetRecordCount(BLHeaderTaxTable), True, True);

              GlblPreviewPrint := False;
              CurrentlyPrintingThirdPartyNotices := False;

(*              If _Compare(BillType, [btBrookvilleVillage, btScarsdaleVillage_County, btRyeCity_County,
                                     btMalverne, btEastchesterSchool, btScarsdaleSchool,
                                     btSuffernSewer, btEastchesterTown, btSuffernSewer2ndHalf,
                                     btLakeSuccess, btEastHampton, btSouthampton, btTarrytown], coEqual) *)
              If glblUsesRaveBills
                then PrintRAVEBills
                else
                  begin
                    AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

                    If ((BillType = btHastings) or
                        (BillType = btSomersSchool) or
                        (BillType = btMtPleasantSchool) or
                        (BillType = btMtPleasantTown))
                      then
                        begin
                          ReportPrinter.SetPaperSize(dmPaper_Legal,0,0);  {SET PAPER TO LEGAL SIZE FOR MT PLEASANT BILL}
                          ReportFiler.SetPaperSize(dmPaper_Legal,0,0);  {SET PAPER TO LEGAL SIZE FOR MT PLEASANT BILL}
                        end;

                    If PrintDialog.PrintToFile
                      then
                        begin
                          GlblPreviewPrint := True;
                          NewFileName := GetPrintFileName(Self.Caption, True);
                          ReportFiler.FileName := NewFileName;

                            {link preview form to file}
                          try
                            PreviewForm := TPreviewForm.Create(self);
                            PreviewForm.FilePrinter.FileName := NewFileName;
                            PreviewForm.FilePreview.FileName := NewFileName;

                            PreviewForm.FilePreview.ZoomFactor := 130;

                            ReportFiler.Execute;
                            PreviewForm.ShowModal;
                          finally
                            PreviewForm.Free;
                          end;

                            {Delete the report printer file.}

                          try
                            Chdir(GlblReportDir);
                            OldDeleteFile(NewFileName);
                          except
                          end;

                        end
                      else ReportPrinter.Execute;

                  end;  {else of If (BillType = btBrookvilleVillage)}

                {CHG03221999-1: Include count of number of rs 8, no bill.}

              MessageDlg('Total printed = ' +
                         FormatFloat(CurrencyDecimalDisplay, TotalBilled) +
                         '  (' + IntToStr(NumBilled) + ' bills)' + #13 +
                         'Total not printed = ' +
                         FormatFloat(CurrencyDecimalDisplay, TotalNotBilled) +
                         '  (' + IntToStr(NumNotBilled) + ' bills)' + #13 +
                         'Bills excluded by bank code = ' +
                         IntToStr(NumBankCoded) + #13 +
                         'Roll 8 bills not printed (no tax) = ' +
                         IntToStr(TotalRS8_NoBill),
                         mtInformation, [mbOK], 0);

                {CHG01092002-1: 3rd party notifications.}

              If ((ThirdPartyNotificationTable.RecordCount > 0) and
                  (MessageDlg('Do you want to print third party notifications?',
                              mtConfirmation, [mbYes, mbNo], 0) = idYes))
                then
                  begin
                    ProgressDialog.Reset;

                    If LoadFromParcelList
                      then ProgressDialog.TotalNumRecords := ParcelListDialog.NumItems
                      else ProgressDialog.TotalNumRecords := GetRecordCount(BLHeaderTaxTable);

                    GlblPreviewPrint := False;
                    CurrentlyPrintingThirdPartyNotices := True;
                    NumThirdPartyNotices := 0;

(*                    If _Compare(BillType, [btBrookvilleVillage, btScarsdaleVillage_County, btRyeCity_County,
                                           btMalverne, btEastchesterSchool, btScarsdaleSchool,
                                           btSuffernSewer, btEastchesterTown, btSuffernSewer2ndHalf,
                                           btLakeSuccess, btEastHampton, btSouthampton, byTarrytown], coEqual) *)
                    If glblUsesRAVEBills 
                      then PrintRAVEBills
                      else
                        If PrintDialog.PrintToFile
                          then
                            begin
                              GlblPreviewPrint := True;
                              NewFileName := GetPrintFileName(Self.Caption, True);
                              ReportFiler.FileName := NewFileName;

                                {link preview form to file}
                              try
                                PreviewForm := TPreviewForm.Create(self);
                                PreviewForm.FilePrinter.FileName := NewFileName;
                                PreviewForm.FilePreview.FileName := NewFileName;

                                PreviewForm.FilePreview.ZoomFactor := 130;

                                ReportFiler.Execute;
                                PreviewForm.ShowModal;
                              finally
                                PreviewForm.Free;
                              end;

                                {Delete the report printer file.}

                              try
                                Chdir(GlblReportDir);
                                OldDeleteFile(NewFileName);
                              except
                              end;

                            end
                          else ReportPrinter.Execute;

                    MessageDlg('There were ' + IntToStr(NumThirdPartyNotices) +
                               ' third party notices printed.', mtInformation, [mbOK], 0);

                  end;  {If (PrintThirdPartyNotices and ...}

              ProgressDialog.Finish;

            end;  {If not Quit}

          {Close the billing files.}

        BLHeaderTaxTable.Close;
        BLGeneralTaxTable.Close;
        BLExemptionTaxTable.Close;
        BLSpecialDistrictTaxTable.Close;
        BLSpecialFeeTaxTable.Close;

          {Finally free up the rate and totals TLists.}

        FreeTList(GeneralRateList, SizeOf(GeneralRateRecord));
        FreeTList(SDRateList, SizeOf(SDRateRecord));
        FreeTList(SpecialFeeRateList, SizeOf(SpecialFeeRecord));
        FreeTList(BillControlDetailList, SizeOf(ControlDetailRecord));

        FreeTList(SDExtCategoryList, SizeOf(SDExtCategoryRecord));

          {FXX01191998-2: Freeing the wrong record size.}
          {FXX01211998-2: Was freeing the RollSectionDescList 2x.}

        FreeTList(RollSectionDescList, SizeOf(CodeRecord));
        FreeTList(EXCodeDescList, SizeOf(CodeRecord));
        FreeTList(SDCodeDescList, SizeOf(CodeRecord));
        FreeTList(SwisCodeDescList, SizeOf(CodeRecord));
        FreeTList(SchoolCodeDescList, SizeOf(CodeRecord));
        FreeTList(SDExtCodeDescList, SizeOf(CodeRecord));
        FreeTList(PropertyClassDescList, SizeOf(CodeRecord));

        ExcludedBankCodes.Free;

      end;  {If OKToStartPrinting}

end;  {PrintButtonClick}

{==================================================================}
Procedure TPrintBillsForm.ProgressDialogCancel(Sender: TObject);

{FXX01021998-4: Handle pressing the cancel button.}

begin
  PrintingCancelled := True;
end;

{===================================================================}
Function MatchesAccuzipValidationType(AccuzipValidationType : Integer;
                                      CASSStatus : String) : Boolean;

begin
  Result := False;

  case AccuzipValidationType of
    actValid : Result := _Compare(CASSStatus, 'V', coEqual);
    actInvalid : Result := _Compare(CASSStatus, 'V', coNotEqual);
    actEither : Result := True;

  end;  {case AccuzipValidationType of}

end;  {MatchesAccuzipValidationType}

{===================================================================}
Function TPrintBillsForm.ParcelShouldBePrinted(BLHeaderTaxTable : TTable;
                                               SelectedSwisCodes : TStringList;
                                               CurrentlyPrintingThirdPartyNotices : Boolean;
                                               BankCodedBillsOption : Integer;
                                               UseAccuzip : Boolean;
                                               AccuzipValidationType : Integer;
                                               PrintPositiveBillsOnly : Boolean) : Boolean;

{We should print this parcel if it does not have a bank code in the exclusion list.}

var
  I, BankCodeLen : Integer;
  TotalOwed : Extended;
  SwisSBLKey : String;

begin
  Result := True;

    {CHG12312003-1(2.07l): Add option to print no bank coded bills or bank coded bills only in a run.}

  If Result
    then
      begin
        If ((BankCodedBillsOption = bcbBankCodedBillsOnly) and
            (Deblank(BLHeaderTaxTable.FieldByName('BankCode').Text) = ''))
          then Result := False;

        If ((BankCodedBillsOption = bcbNoBankCodedBills) and
            (Deblank(BLHeaderTaxTable.FieldByName('BankCode').Text) <> ''))
          then Result := False;

      end;  {If Result}

  If (Result and
      (BLHeaderTaxTable.FieldByName('RollSection').Text = '8') and
      (Roundoff(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
    then Result := False;

    {FXX03181999-6: Allow them to select the swis code.}

  If (Result and
      (SelectedSwisCodes.IndexOf(BLHeaderTaxTable.FieldByName('SwisCode').Text) = -1))
    then Result := False;

  If Result
    then
      For I := 0 to (ExcludedBankCodes.Count - 1) do
        begin
          BankCodeLen := Length(Trim(ExcludedBankCodes[I]));

          If (Take(BankCodeLen, BLHeaderTaxTable.FieldByName('BankCode').Text) =
              Take(BankCodeLen, ExcludedBankCodes[I]))
            then
              begin
                Result := False;
                NumBankCoded := NumBankCoded + 1;
              end;

        end;  {For I := 0 to (ExcludedBankCodes.Count - 1) do}

    {CHG03221999-1: Track # of rs 8, no bills.}

  If ((BLHeaderTaxTable.FieldByName('RollSection').Text = '8') and
      (Roundoff(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
   then TotalRS8_NoBill := TotalRS8_NoBill + 1;

  If ((BLHeaderTaxTable.FieldByName('RollSection').Text = '9') and
      (Roundoff(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
   then TotalRS9_NoBill := TotalRS9_NoBill + 1;

    {If this is a pro-rata parcel without any amount owed, don't print.}

  If (Result and
      (BLHeaderTaxTable.FieldByName('RollSection').Text = '9') and
      (Roundoff(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
    then Result := False
    else
      begin
        TotalOwed := BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat;

        If Result
          then
            begin
              NumBilled := NumBilled + 1;
              TotalBilled := TotalBilled + TotalOwed;
            end
          else
            begin
              NumNotBilled := NumNotBilled + 1;
              TotalNotBilled := TotalNotBilled + TotalOwed;
            end;

      end;  {If (Result and...}

    {CHG01092002-1: Print 3rd party notifications.}
    {If there is a 3rd party notice record for this parcel, print it.}

  If (Result and
      CurrentlyPrintingThirdPartyNotices)
    then
      begin
        SwisSBLKey := BLHeaderTaxTable.FieldByName('SwisCode').Text +
                      BLHeaderTaxTable.FieldByName('SBLKey').Text;

        SetRangeOld(ThirdPartyNotificationTable,
                    ['SwisSBLKey', 'NoticeNumber'],
                    [SwisSBLKey, '0'], [SwisSBLKey, '999']);

        ThirdPartyNotificationTable.First;

        Result := not ThirdPartyNotificationTable.EOF;

      end;  {If CurrentlyPrintingThirdPartyNotices}

  If (Result and
      UseAccuzip and
      (not MatchesAccuzipValidationType(AccuzipValidationType, BLHeaderTaxTable.FieldByName('CASSStatus').Text)))
    then Result := False;

  If (Result and
      PrintPositiveBillsOnly and
      _Compare(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 0, coEqual))
    then Result := False;

end;  {ParcelShouldBePrinted}

{=========================================================================}
Procedure TPrintBillsForm.GenerateOrPrintBills(Sender : TObject);

var
  Done, FirstTimeThrough, Found, TaxRatePerHundred,
  FirstParcelPositionSet, ValidEntry, bUserDefinedPrintOrder,
  Quit, PadDetailLines, bDisplayCommasInExemptionAmount, bIncludeOrCurrentOwner : Boolean;
  SwisSBLKey, FormattedSwisSBLKey, SchoolCode,
  Name, LANumber, LAStreet, BankCode,
  ZipCode, ZipPlus4Code, sTaxRateDisplayFormat : String;
  Index, I, BillsPrinted : Integer;
  ReportObjectToUse : Char;
  ArrearsMessage : TStringList;
  TotalOwed : Extended;
  TopSectionStart, BaseDetailsStart,
  BottomSectionStart, MPSchoolBaseDetailsStart : Double;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;

begin
  Index := 1;
  bIncludeOrCurrentOwner := False;
  BillsPrinted := 0;
  ReportObjectToUse := 'P';
  Quit := False;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

  try
    TopSectionStart := StrToFloat(TopSectionEdit.Text);
    BaseDetailsStart := StrToFloat(DetailsEdit.Text);
    MPSchoolBaseDetailsStart := StrToFloat(MPSchoolDetailsEdit.Text);
    BottomSectionStart := StrToFloat(MPSchoolDetailsEdit.Text);
  except
    TopSectionStart := 0;
    BaseDetailsStart := 0;
    MPSchoolBaseDetailsStart := 0;
    BottomSectionStart := 0;
  end;

  ArrearsMessage := TStringList.Create;

  with ArrearsMemo do
    For I := 0 to (Lines.Count - 1) do
      ArrearsMessage.Add(Lines[I]);

  If (Sender <> nil)
    then
      with Sender as TBaseReport do
        SetFont('Times New Roman', 10);

  Done := False;
  FirstTimeThrough := True;

  ProgressDialog.UserLabelCaption := 'Printing Bills.';

     {FXX07061998-7: Start at the parcel they want to start at.}

  FirstParcelPositionSet := False;

    {CHG03161999-2: Print from the parcel list.}

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(ParcelTable, Index);
        BLHeaderTaxTable.IndexName := 'BYSCHOOL_SWIS_RS_SBL';
      end
    else
      begin
        case PrintOrderRadioGroup.ItemIndex of
          0 : If (Deblank(NameSBLEdit.Text) <> '')
                then
                  begin
                    SwisSBLKey := ConvertSwisDashDotToSwisSBL(NameSBLEdit.Text,
                                                              SwisCodeTable,
                                                              ValidEntry);
                    If not ValidEntry
                      then MessageDlg('The starting parcel ID entry was invalid.' + #13 +
                                      'Please try again.', mtError, [mbOK], 0);

                    FindNearestOld(BLHeaderTaxTable,
                                   ['SBLKey'],
                                   [Copy(SwisSBLKey, 7, 20)]);
                    FirstParcelPositionSet := True;

                  end;  {Parcel ID}

          1 : If (Deblank(NameSBLEdit.Text) <> '')
                then
                  begin
                    Name := NameSBLEdit.Text;
                    FindNearestOld(BLHeaderTaxTable, ['Name1'],
                                   [Name]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          2 : If ((Deblank(LANoEdit.Text) <> '') or
                  (Deblank(LATextEdit.Text) <> ''))
                then
                  begin
                    LANumber := Trim(LANoEdit.Text);
                    LAStreet := Trim(LATextEdit.Text);
                    FindNearestOld(BLHeaderTaxTable,
                                   ['LegalAddr','LegalAddrNo'],
                                   [LAStreet, LANumber]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          3 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(NameSBLEdit.Text) <> ''))
                then
                  begin
                    ZipCode := Trim(StartDataEdit.Text);
                    ZipPlus4Code := Trim(ZipPlus4Edit.Text);

                    If (Deblank(NameSBLEdit.Text) = '')
                      then SwisSBLKey := ''
                      else SwisSBLKey := ConvertSwisDashDotToSwisSBL(NameSBLEdit.Text,
                                                                     SwisCodeTable,
                                                                     ValidEntry);
                    If not ValidEntry
                      then MessageDlg('The starting parcel ID entry was invalid.' + #13 +
                                      'Please try again.', mtError, [mbOK], 0);

                    FindNearestOld(BLHeaderTaxTable,
                                   ['Zip','ZipPlus4','SBLKey'],
                                   [ZipCode, ZipPlus4Code, Copy(SwisSBLKey, 7, 20)]);
                    FirstParcelPositionSet := True;

                  end;  {Zip\Parcel ID}

          4 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(NameSBLEdit.Text) <> ''))
                then
                  begin
                    ZipCode := Trim(StartDataEdit.Text);
                    ZipPlus4Code := Trim(ZipPlus4Edit.Text);
                    Name := NameSBLEdit.Text;
                    FindNearestOld(BLHeaderTaxTable,
                                   ['Zip','ZipPlus4','Name1'],
                                   [ZipCode, ZipPlus4Code, Name]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          5 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(LANoEdit.Text) <> '') or
                  (Deblank(LATextEdit.Text) <> ''))
                then
                  begin
                    ZipCode := Trim(StartDataEdit.Text);
                    ZipPlus4Code := Trim(ZipPlus4Edit.Text);
                    LANumber := Trim(LANoEdit.Text);
                    LAStreet := Trim(LATextEdit.Text);
                    FindNearestOld(BLHeaderTaxTable,
                                   ['Zip','ZipPlus4','LegalAddr','LegalAddrNo'],
                                   [ZipCode, ZipPlus4Code, LAStreet, LANumber]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          6 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(NameSBLEdit.Text) <> ''))
                then
                  begin
                    BankCode := Trim(StartDataEdit.Text);

                    If (Deblank(NameSBLEdit.Text) = '')
                      then SwisSBLKey := ''
                      else SwisSBLKey := ConvertSwisDashDotToSwisSBL(NameSBLEdit.Text,
                                                                     SwisCodeTable,
                                                                     ValidEntry);

                    If not ValidEntry
                      then MessageDlg('The starting parcel ID entry was invalid.' + #13 +
                                      'Please try again.', mtError, [mbOK], 0);

                    FindNearestOld(BLHeaderTaxTable,
                                   ['BankCode','SBLKey'],
                                   [BankCode, Copy(SwisSBLKey, 7, 20)]);
                    FirstParcelPositionSet := True;

                  end;  {Bank\Parcel ID}

          7 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(NameSBLEdit.Text) <> ''))
                then
                  begin
                    BankCode := Trim(StartDataEdit.Text);
                    Name := NameSBLEdit.Text;
                    FindNearestOld(BLHeaderTaxTable,
                                   ['BankCode','Name1'],
                                   [BankCode, Name]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          8 : If ((Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(LANoEdit.Text) <> '') or
                  (Deblank(LATextEdit.Text) <> ''))
                then
                  begin
                    BankCode := Trim(StartDataEdit.Text);
                    LANumber := Trim(LANoEdit.Text);
                    LAStreet := Trim(LATextEdit.Text);
                    FindNearestOld(BLHeaderTaxTable,
                                   ['BankCode','LegalAddr','LegalAddrNo'],
                                   [BankCode, LAStreet, LANumber]);
                    FirstParcelPositionSet := True;
                  end;  {Name}

          9 : If ((Deblank(StartingBankEdit.Text) <> '') or
                  (Deblank(StartDataEdit.Text) <> '') or
                  (Deblank(NameSBLEdit.Text) <> ''))
                then
                  begin
                    ZipCode := Trim(StartDataEdit.Text);
                    ZipPlus4Code := Trim(ZipPlus4Edit.Text);
                    BankCode := Trim(StartingBankEdit.Text);

                    If (Deblank(NameSBLEdit.Text) = '')
                      then SwisSBLKey := ''
                      else SwisSBLKey := ConvertSwisDashDotToSwisSBL(NameSBLEdit.Text,
                                                                     SwisCodeTable,
                                                                     ValidEntry);
                    If not ValidEntry
                      then MessageDlg('The starting parcel ID entry was invalid.' + #13 +
                                      'Please try again.', mtError, [mbOK], 0);

                    FindNearestOld(BLHeaderTaxTable,
                                   ['BankCode','Zip','ZipPlus4','SBLKey'],
                                   [BankCode, ZipCode, ZipPlus4Code,
                                    Copy(SwisSBLKey, 7, 20)]);
                    FirstParcelPositionSet := True;

                  end;  {Zip\Parcel ID}

          end;  {case PrintOrderRadioGroup.ItemIndex of}

       If not FirstParcelPositionSet
         then BLHeaderTaxTable.First;

      end;  {else of If LoadFromParcelList}

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
          else BLHeaderTaxTable.Next;

    If (BLHeaderTaxTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    with BLHeaderTaxTable do
      begin
        SwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBLKey').Text;

          {Update the progress dialog.}

        case PrintOrderRadioGroup.ItemIndex of
          0 : ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          1 : ProgressDialog.Update(Self, FieldByName('Name1').Text);
          2 : ProgressDialog.Update(Self, RTrim(FieldByName('LegalAddr').Text) + ' ' +
                                          FieldByName('LegalAddrNo').Text);
          3 : ProgressDialog.Update(Self, FieldByName('Zip').Text + '\' +
                                          ConvertSwisSBLToDashDot(SwisSBLKey));
          4 : ProgressDialog.Update(Self, FieldByName('Zip').Text + '\' +
                                          FieldByName('Name1').Text);
          5 : ProgressDialog.Update(Self, FieldByName('Zip').Text + '\' +
                                          RTrim(FieldByName('LegalAddr').Text) + ' ' +
                                          FieldByName('LegalAddrNo').Text);
          6 : ProgressDialog.Update(Self, FieldByName('BankCode').Text + '\' +
                                          ConvertSwisSBLToDashDot(SwisSBLKey));
          7 : ProgressDialog.Update(Self, FieldByName('BankCode').Text + '\' +
                                          FieldByName('Name1').Text);
          8 : ProgressDialog.Update(Self, FieldByName('BankCode').Text + '\' +
                                          RTrim(FieldByName('LegalAddr').Text) + ' ' +
                                          FieldByName('LegalAddrNo').Text);
          9 : ProgressDialog.Update(Self, FieldByName('BankCode').Text + '\' +
                                          RTrim(FieldByName('Zip').Text) + '-' +
                                          FieldByName('ZipPlus4').Text + '\' +
                                          ConvertSwisSBLToDashDot(SwisSBLKey));
          10 : ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));
          11 : ProgressDialog.Update(Self, FieldByName('BillNo').Text);

        end;  {case Index of}

      end;  {with BLHeaderTaxTable do}

    Application.ProcessMessages;

    If ((not Done) and
        (LoadFromParcelList or
         ParcelShouldBePrinted(BLHeaderTaxTable, SelectedSwisCodes,
                               CurrentlyPrintingThirdPartyNotices, BankCodedBillsOption,
                               UseAccuzip, AccuzipValidationType, PrintPositiveBillsOnly)))
      then
        begin
          Inc(BillsPrinted);
          inc(iCurrentPage);

          If (_Compare(iCurrentPage, iPageRangeStart, coGreaterThanOrEqual) and
              _Compare(iCurrentPage, iPageRangeEnd, coLessThanOrEqual))
          then
          begin
            If CurrentlyPrintingThirdPartyNotices
              then NumThirdPartyNotices := NumThirdPartyNotices + 1;

            If LoadFromParcelList
              then
                begin
                    {Get the bill for this parcel in the list.}

                  SwisSBLKey := ExtractSSKey(ParcelTable);

                  If (CollectionType = 'SC')
                    then SchoolCode := ParcelTable.FieldByName('SchoolCode').Text
                    else SchoolCode := '999999';

                  Found := FindKeyOld(BLHeaderTaxTable,
                                      ['SchoolCodeKey', 'SwisCode', 'RollSection', 'SBLKey'],
                                      [SchoolCode,
                                       Take(6, SwisSBLKey),
                                       ParcelTable.FieldByName('RollSection').Text,
                                       Copy(SwisSBLKey, 7, 20)]);

                  If not Found
                    then SystemSupport(020, BLHeaderTaxTable, 'Error finding bill for ' + SwisSBLKey + '.',
                                       UnitName, GlblErrorDlgBox);

                  TotalOwed := BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat;

                  NumBilled := NumBilled + 1;
                  TotalBilled := TotalBilled + TotalOwed;

                end;  {If LoadFromParcelList}

            FormattedSwisSBLKey := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey,7,20));

            _Locate(ParcelTable, [TaxRollYear, SwisSBLKey], '', [loParseSwisSBLKey]);

              {If we are printing through RAVE, we will load the tax information here
               and pass it in to the DLL since the DLL was not properly freeing the pointers
               on the TList.}

            If (Sender = nil)
              then
                begin
                  ClearTList(GnTaxList, SizeOf(GeneralTaxRecord));
                  ClearTList(SDTaxList, SizeOf(SDistTaxRecord));
                  ClearTList(SpTaxList, SizeOf(SPFeeTaxRecord));
                  ClearTList(ExTaxList, SizeOf(ExemptTaxRecord));

                  LoadTaxesForParcel(SwisSBLKey,
                                     BLGeneralTaxTable,
                                     BLSpecialDistrictTaxTable,
                                     BLExemptionTaxTable,
                                     BLSpecialFeeTaxTable,
                                     SDCodeDescList, EXCodeDescList,
                                     GeneralRateList, SDRateList,
                                     SpecialFeeRateList, GnTaxList,
                                     SDTaxList, SpTaxList, ExTaxList, Quit);

                end
              else
                begin
                  If (TBaseReport(Sender).Name = 'ReportPrinter')
                    then ReportObjectToUse := 'P'
                    else ReportObjectToUse := 'F';

                end;  {else of If (Sender = nil)}

            If glblUsesRaveBills
            then
              begin
                case BillType of
                  btBrookvilleVillage :
                    AddOneBrookvilleRAVEBill(SwisSBLKey,
                                             RaveBillCollectionInfoTable,
                                             RaveBillInfoHeaderTable,
                                             RaveBillBaseSDDetailsTable,
                                             RaveBillEXDetailsTable,
                                             BLHeaderTaxTable,
                                             BLGeneralTaxTable,
                                             BLExemptionTaxTable,
                                             BLSpecialDistrictTaxTable,
                                             BLSpecialFeeTaxTable,
                                             CollectionLookupTable,
                                             BillParameterTable,
                                             SwisCodeTable,
                                             GeneralRateList,
                                             SDRateList,
                                             SpecialFeeRateList,
                                             BillControlDetailList,
                                             PropertyClassDescList,
                                             RollSectionDescList,
                                             EXCodeDescList,
                                             SDCodeDescList,
                                             SwisCodeDescList,
                                             SchoolCodeDescList,
                                             SDExtCodeDescList,
                                             GnTaxList, SDTaxList,
                                             SpTaxList, ExTaxList,
                                             ArrearsMessage);

                  btScarsdaleVillage_County,
                  btScarsdaleSchool :
                    AddOneScarsdaleRAVEBill(SwisSBLKey,
                                            CollectionType,
                                            TaxRollYear,
                                            CollectionNum,
                                            RaveBillCollectionInfoTable,
                                            RaveBillInfoHeaderTable,
                                            RaveBillBaseSDDetailsTable,
                                            RaveBillEXDetailsTable,
                                            BLHeaderTaxTable,
                                            BLGeneralTaxTable,
                                            BLExemptionTaxTable,
                                            BLSpecialDistrictTaxTable,
                                            BLSpecialFeeTaxTable,
                                            CollectionLookupTable,
                                            BillParameterTable,
                                            ArrearsMessageTable,
                                            SchoolCodeTable,
                                            SwisCodeTable,
                                            GeneralRateList,
                                            SDRateList,
                                            SpecialFeeRateList,
                                            BillControlDetailList,
                                            PropertyClassDescList,
                                            RollSectionDescList,
                                            EXCodeDescList,
                                            SDCodeDescList,
                                            SwisCodeDescList,
                                            SchoolCodeDescList,
                                            SDExtCodeDescList,
                                            GnTaxList, SDTaxList,
                                            SpTaxList, ExTaxList,
                                            ArrearsMessage);

                  else
                  begin
                    TaxRatePerHundred := False;
                    PadDetailLines := True;
                    bDisplayCommasInExemptionAmount := True;
                    sTaxRateDisplayFormat := '';
                    bUserDefinedPrintOrder := False;

                    case BillType of
                      btEastchesterTown :
                      begin
                        PadDetailLines := False;
                        bUserDefinedPrintOrder := True;
                      end;

                      btEastchesterSchool,
                      btLakeSuccess : PadDetailLines := False;

                      btEastHampton,
                      btSouthampton :
                        begin
                          PadDetailLines := False;
                          TaxRatePerHundred := True;
                          sTaxRateDisplayFormat := DecimalEditDisplay;
                        end;

                      btMasticBeach :
                        begin
                          PadDetailLines := False;
                          TaxRatePerHundred := True;
                          sTaxRateDisplayFormat := DecimalEditDisplay;
                          bIncludeOrCurrentOwner := True;
                        end;

                      btMalverne : TaxRatePerHundred := True;

                      btTarrytown : PadDetailLines := False;

                    end;  {case BillType of}

                    If _Compare(BillType, btEastHampton, coEqual)
                      then bDisplayCommasInExemptionAmount := False;

                    AddOneStandardRAVEBill(SwisSBLKey,
                                           CollectionType,
                                           TaxRollYear,
                                           CollectionNum,
                                           RaveBillCollectionInfoTable,
                                           RaveBillInfoHeaderTable,
                                           RaveBillBaseSDDetailsTable,
                                           RaveBillEXDetailsTable,
                                           RAVELevyChangeTable,
                                           BLHeaderTaxTable,
                                           BLGeneralTaxTable,
                                           BLExemptionTaxTable,
                                           BLSpecialDistrictTaxTable,
                                           BLSpecialFeeTaxTable,
                                           CollectionLookupTable,
                                           BillParameterTable,
                                           ArrearsMessageTable,
                                           SchoolCodeTable,
                                           SwisCodeTable,
                                           LastYearGeneralTaxTable,
                                           LastYearSpecialDistrictTaxTable,
                                           GeneralTaxRateTable,
                                           ThirdPartyNotificationTable,
                                           AssessmentYearCtlTable,
                                           CurrentlyPrintingThirdPartyNotices,
                                           GeneralRateList,
                                           SDRateList,
                                           SpecialFeeRateList,
                                           BillControlDetailList,
                                           PropertyClassDescList,
                                           RollSectionDescList,
                                           EXCodeDescList,
                                           SDCodeDescList,
                                           SwisCodeDescList,
                                           SchoolCodeDescList,
                                           SDExtCodeDescList,
                                           GnTaxList, SDTaxList,
                                           SpTaxList, ExTaxList,
                                           ArrearsMessage,
                                           BillsPrinted,
                                           TaxRatePerHundred,
                                           PadDetailLines,
                                           ParcelTable.FieldByName('RemapOldSBL').AsString,
                                           bDisplayCommasInExemptionAmount,
                                           sTaxRateDisplayFormat, bUserDefinedPrintOrder,
                                           bIncludeOrCurrentOwner);

                  end;  {else}

                end;  {case BillType of}

              end
            else
            case BillType of
              btHastings :
                PrintOneHastingsBill(Sender, ReportPrinter, ReportFiler, ReportObjectToUse,
                                     SwisSBLKey,
                                     FormattedSwisSBLKey,
                                     SchoolCodeTable,
                                     SwisCodeTable,
                                     CollectionLookupTable,
                                     BLHeaderTaxTable,
                                     BLGeneralTaxTable,
                                     BLSpecialDistrictTaxTable,
                                     BLExemptionTaxTable,
                                     BLSpecialFeeTaxTable,
                                     BillParameterTable,
                                     SDCodeDescList, EXCodeDescList,
                                     PropertyClassDescList,
                                     GeneralRateList, SDRateList,
                                     SpecialFeeRateList, ArrearsMessage,
                                     ThirdPartyNotificationTable,
                                     CurrentlyPrintingThirdPartyNotices,
                                     TopSectionStart, BaseDetailsStart,
                                     BottomSectionStart);

              btWesleyHills :
                PrintOneWesleyBill(Sender, ReportPrinter, ReportFiler, ReportObjectToUse,
                                   SwisSBLKey,
                                   FormattedSwisSBLKey,
                                   SchoolCodeTable,
                                   SwisCodeTable,
                                   CollectionLookupTable,
                                   BLHeaderTaxTable,
                                   BLGeneralTaxTable,
                                   BLSpecialDistrictTaxTable,
                                   BLExemptionTaxTable,
                                   BLSpecialFeeTaxTable,
                                   BillParameterTable, ParcelTable,
                                   SDCodeDescList, EXCodeDescList,
                                   PropertyClassDescList,
                                   GeneralRateList, SDRateList,
                                   SpecialFeeRateList, ArrearsMessage,
                                   ThirdPartyNotificationTable,
                                   CurrentlyPrintingThirdPartyNotices,
                                   TopSectionStart);

                btSomersTown :
                PrintOneSomersTownBill(Sender, ReportPrinter, ReportFiler,
                                  ReportObjectToUse,
                                  SwisSBLKey,
                                  FormattedSwisSBLKey,
                                  SchoolCodeTable,
                                  SwisCodeTable,
                                  CollectionLookupTable,
                                  BLHeaderTaxTable,
                                  BLGeneralTaxTable,
                                  BLSpecialDistrictTaxTable,
                                  BLExemptionTaxTable,
                                  BLSpecialFeeTaxTable,
                                  BillParameterTable,
                                  ParcelTable,
                                  SDCodeDescList,
                                  EXCodeDescList,
                                  PropertyClassDescList,
                                  GeneralRateList,
                                  SDRateList,
                                  SpecialFeeRateList,
                                  ArrearsMessage,
                                  ThirdPartyNotificationTable,
                                  CurrentlyPrintingThirdPartyNotices,
                                  TopSectionStart, BaseDetailsStart, BottomSectionStart);

                btSomersSchool :
                PrintOneSomersSchoolBill(Sender, ReportPrinter, ReportFiler,
                                  ReportObjectToUse,
                                  SwisSBLKey,
                                  FormattedSwisSBLKey,
                                  SchoolCodeTable,
                                  SwisCodeTable,
                                  CollectionLookupTable,
                                  BLHeaderTaxTable,
                                  BLGeneralTaxTable,
                                  BLSpecialDistrictTaxTable,
                                  BLExemptionTaxTable,
                                  BLSpecialFeeTaxTable,
                                  BillParameterTable,
                                  ParcelTable,
                                  SDCodeDescList,
                                  EXCodeDescList,
                                  PropertyClassDescList,
                                  GeneralRateList,
                                  SDRateList,
                                  SpecialFeeRateList,
                                  ArrearsMessage,
                                  ThirdPartyNotificationTable,
                                  CurrentlyPrintingThirdPartyNotices,
                                  TopSectionStart, BaseDetailsStart, BottomSectionStart);

                btRyeCity,
                btRyeCounty,
                btRyeSchool :
                PrintOneRyeBill(Sender, ReportPrinter, ReportFiler,
                                  ReportObjectToUse,
                                  CollectionType,
                                  SwisSBLKey,
                                  FormattedSwisSBLKey,
                                  SchoolCodeTable,
                                  SwisCodeTable,
                                  CollectionLookupTable,
                                  BLHeaderTaxTable,
                                  BLGeneralTaxTable,
                                  BLSpecialDistrictTaxTable,
                                  BLExemptionTaxTable,
                                  BLSpecialFeeTaxTable,
                                  BillParameterTable,
                                  ParcelTable,
                                  SDCodeDescList,
                                  EXCodeDescList,
                                  PropertyClassDescList,
                                  GeneralRateList,
                                  SDRateList,
                                  SpecialFeeRateList,
                                  ArrearsMessage,
                                  ThirdPartyNotificationTable,
                                  CurrentlyPrintingThirdPartyNotices);

              btMtPleasantSchool:
                PrintOneMtPleasantSchoolBill(ReportPrinter, ReportFiler,
                                             ReportObjectToUse,
                                             SwisSBLKey,
                                             FormattedSwisSBLKey,
                                             SchoolCodeTable,
                                             SwisCodeTable,
                                             CollectionLookupTable,
                                             BLHeaderTaxTable,
                                             BLGeneralTaxTable,
                                             BLSpecialDistrictTaxTable,
                                             BLExemptionTaxTable,
                                             BLSpecialFeeTaxTable,
                                             BillParameterTable,
                                             SDCodeDescList, EXCodeDescList,
                                             PropertyClassDescList,
                                             GeneralRateList, SDRateList,
                                             SpecialFeeRateList, ArrearsMessage,
                                             ThirdPartyNotificationTable,
                                             CurrentlyPrintingThirdPartyNotices,
                                             MPSchoolBaseDetailsStart,
                                             TopSectionStart);

              btMtPleasantTown:
                PrintOneMtPleasantTownBill(ReportPrinter, ReportFiler,
                                           ReportObjectToUse,
                                           SwisSBLKey,
                                           FormattedSwisSBLKey,
                                           SchoolCodeTable,
                                           SwisCodeTable,
                                           CollectionLookupTable,
                                           BLHeaderTaxTable,
                                           BLGeneralTaxTable,
                                           BLSpecialDistrictTaxTable,
                                           BLExemptionTaxTable,
                                           BLSpecialFeeTaxTable,
                                           BillParameterTable,
                                           SDCodeDescList, EXCodeDescList,
                                           PropertyClassDescList,
                                           GeneralRateList, SDRateList,
                                           SpecialFeeRateList, ArrearsMessage,
                                           ThirdPartyNotificationTable,
                                           CurrentlyPrintingThirdPartyNotices,
                                           TopSectionStart, BaseDetailsStart);

              btLawrenceVillage :
                PrintOneLawrenceBill(Sender, SwisSBLKey,
                                     SwisCodeTable,
                                     CollectionLookupTable,
                                     BLHeaderTaxTable,
                                     BLGeneralTaxTable,
                                     BLSpecialDistrictTaxTable,
                                     BLExemptionTaxTable,
                                     BLSpecialFeeTaxTable,
                                     BillParameterTable, ParcelTable,
                                     SDCodeDescList, EXCodeDescList,
                                     PropertyClassDescList,
                                     GeneralRateList, SDRateList,
                                     SpecialFeeRateList, ArrearsMessage,
                                     ThirdPartyNotificationTable,
                                     CurrentlyPrintingThirdPartyNotices,
                                     TopSectionStart);

            end;  {case BillType of}

          end;  {If (_Compare(iCurrentPage, iPageRangeStart}
          
        end;  {If ((not Done) and ...}

    PrintingCancelled := ProgressDialog.Cancelled;

  until (Done or PrintingCancelled);

  ArrearsMessage.Free;

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

end;  {GenerateOrPrintBills}

{================================================================}
Procedure OpenRAVETables(var RAVEBillCollectionInfoTableName,
                             RAVEBillHeaderInfoTableName,
                             RAVEBillBaseSDDetailsTableName,
                             RAVEBillEXDetailsTableName,
                             RAVELevyChangeTableName : String;
                             RAVEBillCollectionInfoTable,
                             RAVEBillInfoHeaderTable,
                             RAVEBillBaseSDDetailsTable,
                             RAVEBillEXDetailsTable,
                             RAVELevyChangeTable : TTable;
                             OpenBaseSDDetailsTable,
                             OpenEXDetailsTable,
                             OpenRAVELevyChangeTable : Boolean);

var
  Quit : Boolean;

begin
  Quit := False;

    {Copy the RAVE template tables to temporary sort files so that
     more than 1 person can print bills at a time.}

  CopyAndOpenSortFile(RAVEBillCollectionInfoTable, 'RAVEBillCollInfo',
                      'RAVEBillCollectionInfo',
                      RAVEBillCollectionInfoTableName,
                      False, True, Quit);

  CopyAndOpenSortFile(RAVEBillInfoHeaderTable, 'RAVEBillInfoHdr',
                      'RAVEBillInfoHeader',
                      RAVEBillHeaderInfoTableName,
                      False, True, Quit);

  If OpenBaseSDDetailsTable
    then CopyAndOpenSortFile(RAVEBillBaseSDDetailsTable, 'RAVEBillLevies',
                             'RAVEBillLevies',
                             RAVEBillBaseSDDetailsTableName,
                             False, True, Quit)
    else RAVEBillBaseSDDetailsTableName := 'NONE';

  If OpenEXDetailsTable
    then CopyAndOpenSortFile(RAVEBillEXDetailsTable, 'RAVEBillExemptions',
                             'RAVEBillExemptions',
                             RAVEBillEXDetailsTableName,
                             False, True, Quit)
    else RAVEBillEXDetailsTableName := 'NONE';

  If OpenRAVELevyChangeTable
    then CopyAndOpenSortFile(RAVELevyChangeTable, 'RaveLevyChanges',
                             'RaveLevyChanges',
                             RAVELevyChangeTableName,
                             False, True, Quit)
    else RAVELevyChangeTableName := 'NONE';

end;  {OpenRAVETables}

{==================================================================}
Procedure TPrintBillsForm.InterfaceWithAccuzip;

var
  Done, FirstTimeThrough : Boolean;
  AccuzipImportFile, AccuzipExportFile : TextFile;
  CASSCertifiedCount, CASSInvalidCount : Integer;
  TempIndexName : String;
  {$H+}
  ImportLine : String;
  {H-}
  _FieldList : TStringList;

begin
  _FieldList := TStringList.Create;
  FirstTimeThrough := True;
  AssignFile(AccuzipExportFile, GlblProgramDir + 'accuzip\AccuzipExport.csv');
  Rewrite(AccuzipExportFile);

(*  WritelnCommaDelimitedLine(AccuzipImportFile,
                            ['Name1', 'Name2', 'Address1', 'Address2',
                             'Street', 'City', 'State', 'Zip',
                             'ZipPlus4']); *)

  (*WritelnCommaDelimitedLine(AccuzipImportFile,
                            ['SBL', 'Street', 'City', 'State',
                             'Zip']); *)

  with BLHeaderTaxTable do
    begin
      First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else Next;

        Done := EOF;

        If ((not Done) and
            ParcelShouldBePrinted(BLHeaderTaxTable, SelectedSwisCodes,
                                  CurrentlyPrintingThirdPartyNotices, BankCodedBillsOption,
                                  UseAccuzip, AccuzipValidationType, PrintPositiveBillsOnly))
          then WritelnCommaDelimitedLine(AccuzipExportFile,
                                         [FieldByName('Street').Text, FieldByName('City').Text, FieldByName('State').Text,
                                          FieldByName('Zip').Text, FieldByName('SBLKey').Text]);

      until Done;

    end;  {with BLHeaderTaxTable do}

  CloseFile(AccuzipExportFile);

    {Now import the file.}

  MessageDlg('Please run the Accuzip program from your desktop.' + #13 +
             'When it has completed, return to PAS to continue the bill printing.',
             mtInformation, [mbOK], 0);

  If OpenDialog.Execute
    then
      begin
        AssignFile(AccuzipImportFile, OpenDialog.FileName);
        Reset(AccuzipImportFile);
        TempIndexName := BLHeaderTaxTable.IndexName;
        BLHeaderTaxTable.IndexName := 'BySBL';
        CASSCertifiedCount := 0;
        CASSInvalidCount := 0;

        {$H+}

        while not EOF(AccuzipImportFile) do
          begin
            Readln(AccuzipImportFile, ImportLine);

            ParseCommaDelimitedStringIntoFields(ImportLine, _FieldList, True);

            If _Locate(BLHeaderTaxTable, [_FieldList[0]], '', [])
              then
                begin
                  with BLHeaderTaxTable do
                    try
                      Edit;
                      FieldByName('Street').Text := _FieldList[1];
                      FieldByName('City').Text := _FieldList[2];
                      FieldByName('State').Text := _FieldList[3];

                        {CHG08252008-1(2.15.1.8):  The CASS zip export went from 2 fields to 1.}

                      FieldByName('Zip').Text := Copy(_FieldList[4], 1, 5);
                      FieldByName('ZipPlus4').Text := Copy(_FieldList[4], 7, 4);
                      FieldByName('CASSCarierRoute').Text := _FieldList[5];
                      FieldByName('CASSStatus').Text := _FieldList[6];
                      FieldByName('CASSErrorNumber').Text := _FieldList[7];
                      FieldByName('CASSDPC').Text := _FieldList[8];
                      FieldByName('CASSBarCode').Text := _FieldList[9];

(*                      FieldByName('ZipPlus4').Text := _FieldList[5];
                      FieldByName('CASSCarierRoute').Text := _FieldList[6];
                      FieldByName('CASSStatus').Text := _FieldList[7];
                      FieldByName('CASSErrorNumber').Text := _FieldList[8];
                      FieldByName('CASSDPC').Text := _FieldList[9];
                      FieldByName('CASSBarCode').Text := _FieldList[10]; *)
                      Post;

                      If _Compare(FieldByName('CASSStatus').Text, 'V', coEqual)
                        then Inc(CASSCertifiedCount)
                        else Inc(CASSInvalidCount);

                    except
                      SystemSupport(004, BLHeaderTaxTable,
                                    'Error updating bill during Accuzip update.' + #13 +
                                    'SBL = ' + _FieldList[0] + '.', UnitName, GlblErrorDlgBox);
                    end;

                end;  {If _Locate(BLHeaderTaxTable, [_FieldList[0]], '', [])}

          end;  {while not EOF(AccuzipImportFile) do}

        {$H-}

        CloseFile(AccuzipImportFile);
        BLHeaderTaxTable.IndexName := TempIndexName;
        MessageDlg(IntToStr(CASSCertifiedCount) + ' addresses were CASS certified.' + #13 +
                   IntToStr(CASSInvalidCount) + ' addresses were invalid.',
                   mtInformation, [mbOK], 0);

      end;  {If OpenDialog.Execute}

  _FieldList.Free;

end;  {InterfaceWithAccuzip}

{==================================================================}
Procedure TPrintBillsForm.PrintRAVEBills;

var
  TempLen : Integer;
  RAVELauncherPChar : PChar;
  Quit : Boolean;
  {$H+}
  RAVELauncherCommandLine : String;
  {$H-}
  RAVELevyChangeTableName,
  RAVECollectionInfoTableName, RAVEHeaderInfoTableName,
  RAVEBaseSDDetailsTableName, RAVEEXDetailsTableName,
  HeaderFileName, GeneralFileName,
  EXFileName, SDFileName, SpecialFeeFileName : String;
  OpenRAVELevyTable, OpenRAVEExemptionTable, OpenRAVELevyChangeTable : Boolean;

begin
  Quit := False;
  RAVECollectionInfoTableName := '';
  RAVEHeaderInfoTableName := '';
  RAVEBaseSDDetailsTableName := '';
  RAVEEXDetailsTableName := '';
  RAVELevyChangeTableName := '';

    {Instead of printing a bill, we will add it to the RAVE sort files
     and invoke RAVE later to do the actual printing.}

  If not Quit
    then
      begin
        OpenRAVELevyTable := False;
        OpenRAVEExemptionTable := False;
        OpenRAVELevyChangeTable := False;

        case BillType of
          btBrookvilleVillage :
            begin
              OpenRAVELevyTable := False;
              OpenRAVEExemptionTable := False;
              OpenRAVELevyChangeTable := False;
              If _Compare(GlblRAVEBillName, coBlank)
                then GlblRAVEBillName := GlblProgramDir + '\taxbill_village_of_brookville.rav';

            end;  {btBrookvilleVillage}

          btScarsdaleVillage_County :
            begin
              OpenRAVELevyTable := True;
              OpenRAVEExemptionTable := True;
              OpenRAVELevyChangeTable := False;
              If _Compare(GlblRAVEBillName, coBlank)
                then GlblRAVEBillName := GlblProgramDir + '\taxbill_village+county_scarsdale.rav';

            end;  {btScarsdaleVillage_County}

          btScarsdaleSchool :
            begin
              OpenRAVELevyTable := True;
              OpenRAVEExemptionTable := True;
              OpenRAVELevyChangeTable := False;
              If _Compare(GlblRAVEBillName, coBlank)
                then GlblRAVEBillName := GlblProgramDir + '\taxbill_school_scarsdale.rav';

            end;  {btScarsdaleSchool}

          btRyeCity_County :
            begin
              OpenRAVELevyTable := True;
              OpenRAVEExemptionTable := True;
              OpenRAVELevyChangeTable := True;
              If _Compare(GlblRAVEBillName, coBlank)
                then GlblRAVEBillName := GlblProgramDir + '\taxbill_city+county_rye.rav';

            end;  {btRyeCity_County}

          btMalverne :
            begin
              OpenRAVELevyTable := True;
              OpenRAVEExemptionTable := True;
              OpenRAVELevyChangeTable := False;
              If _Compare(GlblRAVEBillName, coBlank)
                then GlblRAVEBillName := GlblProgramDir + '\taxbill_malverne.rav';

            end;  {btMalverne}

          btEastchesterSchool :
            begin
              OpenRAVELevyTable := True;
              OpenRAVEExemptionTable := True;
              OpenRAVELevyChangeTable := False;
              If _Compare(GlblRAVEBillName, coBlank)
                then GlblRAVEBillName := GlblProgramDir + '\taxbill_school_eastchester.rav';

            end;  {btEastchesterSchool}

          btEastchesterTown :
            begin
              OpenRAVELevyTable := True;
              OpenRAVEExemptionTable := True;
              OpenRAVELevyChangeTable := False;
              If _Compare(GlblRAVEBillName, coBlank)
                then GlblRAVEBillName := GlblProgramDir + '\taxbill_town_eastchester.rav';

            end;  {btEastchesterTown}

          btSuffernSewer :
            begin
              OpenRAVELevyTable := True;
              OpenRAVEExemptionTable := True;
              OpenRAVELevyChangeTable := False;
              If _Compare(GlblRAVEBillName, coBlank)
                then GlblRAVEBillName := GlblProgramDir + '\taxbill_sewer_suffern.rav';

            end;  {btSuffernSewer}

          btSuffernSewer2ndHalf :
            begin
              OpenRAVELevyTable := True;
              OpenRAVEExemptionTable := True;
              OpenRAVELevyChangeTable := False;
              If _Compare(GlblRAVEBillName, coBlank)
                then GlblRAVEBillName := GlblProgramDir + '\taxbill_sewer_suffern_2nd_billing.rav';

            end;  {btSuffernSewer2ndHalf}

          btLakeSuccess,
          btEastHampton,
          btSouthampton,
          btTarrytown,
          btMasticBeach :
            begin
              OpenRAVELevyTable := True;
              OpenRAVEExemptionTable := True;
              OpenRAVELevyChangeTable := False;

            end;  {btLakeSuccess}

        end;  {case BillType of}

        If UseAccuzip
          then InterfaceWithAccuzip;

        OpenRAVETables(RAVECollectionInfoTableName, RAVEHeaderInfoTableName,
                       RAVEBaseSDDetailsTableName, RAVEEXDetailsTableName,
                       RAVELevyChangeTableName,
                       RAVEBillCollectionInfoTable, RAVEBillInfoHeaderTable,
                       RAVEBillBaseSDDetailsTable, RAVEBillEXDetailsTable,
                       RAVELevyChangeTable,
                       OpenRAVELevyTable, OpenRAVEExemptionTable,
                       OpenRAVELevyChangeTable);

        If OpenRAVELevyChangeTable
          then
            begin
              GetBillingFileNames(IncrementNumericString(TaxRollYear, -1),
                                  CollectionType, ShiftRightAddZeroes(Take(2, IntToStr(CollectionNum))),
                                  HeaderFileName, GeneralFileName,
                                  EXFileName, SDFileName, SpecialFeeFileName);

              OpenBillingFiles(HeaderFileName, GeneralFileName,
                               EXFileName, SDFileName, SpecialFeeFileName,
                               nil,
                               LastYearGeneralTaxTable,
                               nil,
                               LastYearSpecialDistrictTaxTable,
                               nil, Quit);

            end;  {If OpenRAVELevyChangeTable}

          {Generate the bills.}

        GenerateOrPrintBills(nil);

          {Invoke RAVE to do the printing.}

        RaveBillInfoHeaderTable.Close;
        RaveBillCollectionInfoTable.Close;
        RaveBillBaseSDDetailsTable.Close;
        RaveBillEXDetailsTable.Close;
        RaveLevyChangeTable.Close;

        If OpenRAVELevyChangeTable
          then
            begin
              LastYearGeneralTaxTable.Close;
              LastYearSpecialDistrictTaxTable.Close;
            end;

        {$H+}
        RAVELauncherCommandLine := GlblProgramDir + 'RAVEBILLLauncher.exe' +
                                   ' HEADERINFO=' + RAVEHeaderInfoTableName +
                                   ' COLLECTIONINFO=' + RAVECollectionInfoTableName +
                                   ' BASESDINFO=' + RAVEBaseSDDetailsTableName +
                                   ' EXINFO=' + RAVEEXDetailsTableName +
                                   ' LEVYCHANGE=' + RAVELevyChangeTableName +
                                   ' PROJECT=' + GlblRAVEBillName;

        TempLen := Length(RAVELauncherCommandLine);
        RAVELauncherPChar := StrAlloc(TempLen + 1);
        StrPCopy(RAVELauncherPChar, RAVELauncherCommandLine);

        WinExec(RAVELauncherPChar, SW_SHOW);
        StrDispose(RAVELauncherPChar);
        {$H-}

      end;  {If not Quit}

end;  {PrintRAVEBills}

{==================================================================}
Procedure TPrintBillsForm.ReportPrinterBeforePrint(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.325;
      SectionLeft := 0.2;
      SectionRight := PageWidth - 0.2;

      ClearTabs;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterBeforePrint}

{=========================================================================}
Procedure TPrintBillsForm.ReportPrinterPrint(Sender: TObject);

begin
  GenerateOrPrintBills(Sender);
end;  {ReportPrinterPrint}

{===============================================================}
Procedure TPrintBillsForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TPrintBillsForm.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

  If (SelectedSwisCodes <> nil)
    then SelectedSwisCodes.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.