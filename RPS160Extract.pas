unit RPS160Extract;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Btrvdlg, wwdblook, Mask,types,pastypes,
  Glblcnst, Gauges,Printrng, RPMemo, RPDBUtil, RPDefine, (*Progress,*) RPTXFilr,
  RPFPrint, RPreview, TabNotBk, ComCtrls, Zipcopy, Math;

type
  PaymentRecord = record
    PayDate : String;
    Penalty : Double;
    BaseAmount : Double;
    TotalAmount : Double;
  end;

  PaymentRecordArrayType = Array[1..6] of PaymentRecord;

type
  TCreateRPS160ExtractForm = class(TForm)
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    Label18: TLabel;
    CollectionLookupTable: TwwTable;
    label16: TLabel;
    Label2: TLabel;
    ScrollBox2: TScrollBox;
    BillCollTypeLookupTable: TwwTable;
    BLSpecialDistrictTaxTable: TTable;
    BLExemptionTaxTable: TTable;
    BLGeneralTaxTable: TTable;
    BLHeaderTaxTable: TTable;
    BLSpecialFeeTaxTable: TTable;
    Label13: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    AssessmentYearCtlTable: TTable;
    Label23: TLabel;
    SDCodeTable: TTable;
    Label24: TLabel;
    BillParameterTable: TTable;
    BillParamDataSource: TDataSource;
    SwisCodeTable: TTable;
    SchoolCodeTable: TTable;
    SysRecTable: TTable;
    ParcelTable: TTable;
    ArrearsMessageTable: TTable;
    ArrearsMessageTableTaxRollYr: TStringField;
    ArrearsMessageTableCollectionType: TStringField;
    ArrearsMessageTableCollectionNo: TSmallintField;
    ArrearsMessageTableArrearsMessage: TMemoField;
    ArrearsMessageDataSource: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label10: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    Label21: TLabel;
    FirstLinePrintsRadioGroup: TRadioGroup;
    FirstLineMessageEdit: TEdit;
    PrintOrderRadioGroup: TRadioGroup;
    TabSheet3: TTabSheet;
    BankCodesExcludedStringGrid: TStringGrid;
    ZipCopyDlg: TZipCopyDlg;
    PenaltyInfoTabSheet: TTabSheet;
    Label9: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    PenaltyDate1Edit: TMaskEdit;
    PenaltyPercent1Edit: TEdit;
    PenaltyDate2Edit: TMaskEdit;
    PenaltyPercent2Edit: TEdit;
    PenaltyDate3Edit: TMaskEdit;
    PenaltyPercent3Edit: TEdit;
    PenaltyDate4Edit: TMaskEdit;
    PenaltyPercent4Edit: TEdit;
    MoreOptionsTabSheet: TTabSheet;
    MiscellaneousOptionsGroupBox: TGroupBox;
    Label6: TLabel;
    IncludeRS8ParcelCheckBox: TCheckBox;
    Label8: TLabel;
    IncludeLabelOnStateAidCheckBox: TCheckBox;
    Label20: TLabel;
    ExcludeAllBankCodesCheckBox: TCheckBox;
    Label22: TLabel;
    ExcludeRollSection3CheckBox: TCheckBox;
    Label25: TLabel;
    UsePenaltySceduleCheckBox: TCheckBox;
    Label28: TLabel;
    IncludeTatEndOfSpecialMessageCheckBox: TCheckBox;
    MessageTabSheet: TTabSheet;
    QuarterlyAmountsCheckBox: TCheckBox;
    Label26: TLabel;
    Label27: TLabel;
    EditPlacedSpecialMessage: TEdit;
    EditPlacedSpecialMessageLineNumber: TEdit;
    Label29: TLabel;
    Label30: TLabel;
    EditPlacedArrearsMessage: TEdit;
    EditPlacedArrearsMessageLineNumber: TEdit;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Label31: TLabel;
    CombineAllSDExtensionsCheckBox: TCheckBox;
    Label32: TLabel;
    SeperateBillsForMultiPageBillsCheckBox: TCheckBox;
    Label33: TLabel;
    ListSplitGeneralTaxesSeperatelyCheckBox: TCheckBox;
    Label34: TLabel;
    DisplaySpecialDistrictExtensionsCheckBox: TCheckBox;
    dlg_SaveTaxExtractFile: TSaveDialog;
    Label35: TLabel;
    cb_ExcludeZeroBills: TCheckBox;
    Panel4: TPanel;
    Label3: TLabel;
    EditTaxRollYear: TEdit;
    Label5: TLabel;
    LookupCollectionType: TwwDBLookupCombo;
    Label4: TLabel;
    EditCollectionNumber: TEdit;
    Panel1: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    Label1: TLabel;
    cbxBillZeroSDRates: TCheckBox;
    Label36: TLabel;
    cbxIncludeOldSBL: TCheckBox;
    Label37: TLabel;
    cbIncludeTownFeeAmounts: TCheckBox;
    tbTaxBillNameAddress: TTable;
    Label38: TLabel;
    cbDecimalsOnTaxableValues: TCheckBox;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure StartButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FirstLinePrintsRadioGroupClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;

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
    GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
    FirstLine : Integer;
    SpecialMessage : String;

    ExcludedBankCodes : TStringList;

    TotalBilled, TotalNotBilled : Extended;
    TotalRS8_NoBill, TotalRS9_NoBill,
    NumBilled, NumNotBilled, NumBankCoded : LongInt;

    FoundCollectionRec, DisplaySpecialDistrictExtensions : Boolean;
    CollectionType : String;
    NumBillsPrinted : LongInt;
    RollPrintingYear : String;
    SelectedSwisCodes,
    SelectedSchoolCodes : TStringList;
    IncludeRS8Parcels : Boolean;

    PenaltyDate1, PenaltyDate2,
    PenaltyDate3, PenaltyDate4 : TDateTime;
    PenaltyPercent1, PenaltyPercent2,
    PenaltyPercent3, PenaltyPercent4, fTownFee : Double;

    IncludeLabelOnStateAid : Boolean;
    IsCitySchoolCollection, bBillZeroSDRates,
    ExcludeRollSection3, ExcludeAllBankCodes : Boolean;

    UsePenaltySchedule, IncludeTatEndOfSpecialMessage : Boolean;
    PlacedSpecialMessage, PlacedArrearsMessage : String;
    PlacedSpecialMessageLineNumber, PlacedArrearsMessageLineNumber : Integer;
    CombineAllSDExtensions, PrintQuarterlyAmounts,
    ListSplitGeneralTaxesSeperately, bShowDecimalsOnTaxableValue,
    ExcludeZeroBills, CreateSeperateFileForMultiPageBills, bIncludeTownFeeAmounts : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function ParcelShouldBePrinted(BLHeaderTaxTable : TTable;
                                   SelectedSwisCodes : TStringList) : Boolean;

    Procedure PrintOneExemption(var RPS160File : TextFile;
                                    CollectionType : String;
                                    EXTaxRecord : ExemptTaxRecord);

    Procedure PrintOneGeneralTaxDetail(var RPS160File : TextFile;
                                           GnTaxRecord : GeneralTaxRecord;
                                           SwisSBLKey : String;
                                       var GeneralTaxLinesPrinted : Integer);

    Procedure PrintOneSDTaxDetail(var RPS160File : TextFile;
                                      SDTaxRecord : SDistTaxRecord;
                                  var SDIndex : Integer);

    Procedure PrintOneSpecialFeeDetail(var RPS160File : TextFile;
                                           SpecialFeeRec : SPFeeTaxRecord;
                                       var SpecialFeeIndex : Integer);

    Procedure Create160File;

    Procedure Write160Header(var RPS160File : TextFile;
                                 SwisSBLKey : String;
                                 RecordNumber : Integer;
                                 CurrentPageNumber : Integer;
                                 TotalPages : Integer);

    Procedure WriteExemptions(var RPS160File : TextFile;
                                  SwisSBLKey : String;
                                  RecordNumber : Integer;
                                  sPropertyClassCode : String);

    Procedure WriteDetails(var RPS160File : TextFile;
                               SwisSBLKey : String;
                               RecordNumber : Integer;
                           var SDIndex : Integer;
                               TotalQuarterlyServiceCharge : Double);

    Procedure WriteFooter(var RPS160File : TextFile;
                              SwisSBLKey : String;
                              RecordNumber : Integer;
                              PaymentArray : PaymentRecordArrayType;
                              TotalQuarterlyCharge : Double);

    Procedure ExtractIt(var RPS160File : TextFile;
                            SwisSBLKey : String;
                            RecordNumber : LongInt;
                            TotalPages : Integer;
                            TotalQuarterlyCharge : Double;
                            PaymentArray : PaymentRecordArrayType);

    Procedure ExtractOneParcel(var RPS160File : TextFile;
                               var RPS160MultiPageFile : TextFile;
                                   SwisSBLKey : String;
                                   RecordNumber : Integer);
  end;

implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview, Prog,
     UtilBill, DataAccessUnit;  {Billing specific utilities.}

{$R *.DFM}

const
  flNormal = 0;
  flHomesteadStatus = 1;
  flSpecialMessage = 2;

{========================================================}
Procedure TCreateRPS160ExtractForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TCreateRPS160ExtractForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'RPS160Extract';  {mmm}

  try
    dlg_SaveTaxExtractFile.InitialDir := GlblDrive + ':' + GlblExportDir;
  except
  end;

    {Note that the billing tax files do not get opened below.
     They get opened once the person fills in the collection type and
     number.}
  OpenTablesForForm(Self, ThisYear);

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, ThisYear, GlblThisYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, ThisYear, GlblThisYear);

  SelectItemsInListBox(SwisCodeListBox);
  SelectItemsInListBox(SchoolCodeListBox);

  EditTaxRollYear.Text := GlblThisYear;
  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;

  If glblUsesTaxBillNameAddr
  then OpenTableForProcessingType(tbTaxBillNameAddress, TaxBillAddressTableName, NextYear, Quit);

end;  {InitializeForm}

{===================================================================}
Procedure TCreateRPS160ExtractForm.FormKeyPress(    Sender: TObject;
                                                var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{================================================================}
Procedure TCreateRPS160ExtractForm.FirstLinePrintsRadioGroupClick(Sender: TObject);

begin
  case FirstLinePrintsRadioGroup.ItemIndex of
    flNormal,
    flHomesteadStatus :
      with FirstLineMessageEdit do
        begin
          ReadOnly := False;
          Text := '';
          ReadOnly := True;
          Color := clBtnFace;

        end;  {with FirstLineMessageEdit do}

    flSpecialMessage :
      with FirstLineMessageEdit do
        begin
          ReadOnly := False;
          Color := clWindow;

        end;  {with FirstLineMessageEdit do}

  end;  {case FirstLinePrintsRadioGroup of}

end;  {FirstLinePrintsRadioGroupClick}

{=====================================================================}
Procedure TCreateRPS160ExtractForm.StartButtonClick(Sender: TObject);

var
  I, J, IndexPos : Integer;

  HasMunicipalRate, HasSchoolRate,
  Found, OKToStart, Quit, BankExcluded, bIncludeOldSBL : Boolean;
  CollectionNum : Integer;
  TaxRollYear : String;

(*  SelectedFiles : TStringList;
  TempFileName, ExtractDir, ZipFileName, MailSubject, *)
  TempIndex, TempIndexName,
  HeaderFileName, GeneralFileName,
  EXFileName, SDFileName, SpecialFeeFileName : String;

begin
  bShowDecimalsOnTaxableValue := cbDecimalsOnTaxableValues.Checked;
  CollectionNum := 0;
  bBillZeroSDRates := cbxBillZeroSDRates.Checked;
  DisplaySpecialDistrictExtensions := DisplaySpecialDistrictExtensionsCheckBox.Checked;
  ExcludeRollSection3 := ExcludeRollSection3CheckBox.Checked;
  ExcludeAllBankCodes := ExcludeAllBankCodesCheckBox.Checked;
  OKToStart := True;
  GlblCurrentTabNo := 0;
  CombineAllSDExtensions := CombineAllSDExtensionsCheckBox.Checked;
  CreateSeperateFileForMultiPageBills := SeperateBillsForMultiPageBillsCheckBox.Checked;
  ListSplitGeneralTaxesSeperately := ListSplitGeneralTaxesSeperatelyCheckBox.Checked;

    {CHG01102010-1[F1030]: Add the old SBL to the 160 extract.}

  bIncludeOldSBL := cbxIncludeOldSBL.Checked;

    {CHG08262004-4(2.8.0.9): Option to suppress 'T' at end of line for a first line special message or homestead message.}

  IncludeTatEndOfSpecialMessage := IncludeTatEndOfSpecialMessageCheckBox.Checked;

    {CHG08262004-2(2.8.0.9): Add the penalty schedule logic.}

  UsePenaltySchedule := UsePenaltySceduleCheckBox.Checked;
  ExcludeZeroBills := cb_ExcludeZeroBills.Checked;

    {CHG08262004-3(2.8.0.9): Allow for a placed message (i.e. a certain tax line.}

  PlacedSpecialMessage := Trim(EditPlacedSpecialMessage.Text);

  try
    PlacedSpecialMessageLineNumber := StrToInt(EditPlacedSpecialMessageLineNumber.Text);
  except
    PlacedSpecialMessageLineNumber := 0;
  end;

    {CHG12192004-1(2.8.1.5): Add an arrears message.}

  PlacedArrearsMessage := Trim(EditPlacedArrearsMessage.Text);

  try
    PlacedArrearsMessageLineNumber := StrToInt(EditPlacedArrearsMessageLineNumber.Text);
  except
    PlacedArrearsMessageLineNumber := 0;
  end;

  bIncludeTownFeeAmounts := cbIncludeTownFeeAmounts.Checked;

    {CHG12192004-2(2.8.1.5): Print quarterly amounts.}

  PrintQuarterlyAmounts := QuarterlyAmountsCheckBox.Checked;

  If (Deblank(EditTaxRollYear.Text) = '')
    then
      begin
        MessageDlg('Please enter the tax roll year.', mtError, [mbOK], 0);
        OKToStart := False;
      end;

  If (Deblank(EditCollectionNumber.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection number.', mtError, [mbOK], 0);
        OKToStart := False;
      end;

  If (Deblank(LookupCollectionType.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection type.', mtError, [mbOK], 0);
        OKToStart := False;
      end;

    {If they have entered all the information, look it up in the bill
     control file to make sure that a collection exists for what they
     entered.}

  If OKToStart
    then
      begin
        TaxRollYear := EditTaxRollYear.Text;
        CollectionType := LookupCollectionType.Text;

        try
          CollectionNum := StrToInt(Trim(EditCollectionNumber.Text));
        except
        end;

        Found := False;
        try
          Found := FindKeyOld(CollectionLookupTable,
                              ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                              [TaxRollYear, CollectionType,
                               IntToStr(CollectionNum)]);
        except
          OKToStart := False;
          SystemSupport(010, CollectionLookupTable, 'Error getting bill control record.',
                        UnitName, GlblErrorDlgBox);
        end;

        If not Found
          then
            begin
              MessageDlg('The collection that you entered does not exist.' + #13 +
                         'Please try again.', mtError, [mbOK], 0);
              OKToStart := False;
            end;

      end;  {If OKToStart}

       {allow user to stop if no bank codes were excluded}

  If OKToStart
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
          then OKToStart := False;

      end;  {If OKToStart}

  TempIndex := '';

  If OKToStart
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

          else
            begin
              MessageDlg('You must select a print order for the bills.',
                         mtError, [mbOK], 0);
              OKToStart := False;
            end;

        end;  {case IndexRadioGroup.ItemIndex of}

  If OKToStart
    then
      begin
        IncludeRS8Parcels := IncludeRS8ParcelCheckBox.Checked;
        FirstLine := FirstLinePrintsRadioGroup.ItemIndex;
        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        SelectedSchoolCodes.Clear;

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

         {create the excluded bank code list}
         {and fill it in from excluded bank string grid}

        ExcludedBankCodes := TStringList.Create;

        with BankCodesExcludedStringGrid do
          For I := 0 to (ColCount - 1) do
            For J := 0 to (RowCount - 1) do
              If (Deblank(Cells[I,J]) <> '')
                then ExcludedBankCodes.Add(Trim(Cells[I,J]));

          {CHG08072002-1: Allow them to specify a penalty table.}
          {CHG08262004-1(2.8.0.9): Activate the penalty date.}

        try
          PenaltyDate1 := StrToDate(PenaltyDate1Edit.Text);
        except
        end;

        try
          PenaltyDate2 := StrToDate(PenaltyDate2Edit.Text);
        except
        end;

        try
          PenaltyDate3 := StrToDate(PenaltyDate3Edit.Text);
        except
        end;

        try
          PenaltyDate4 := StrToDate(PenaltyDate4Edit.Text);
        except
        end;

        try
          PenaltyPercent1 := StrToFloat(PenaltyPercent1Edit.Text);
        except
        end;

        try
          PenaltyPercent2 := StrToFloat(PenaltyPercent2Edit.Text);
        except
        end;

        try
          PenaltyPercent3 := StrToFloat(PenaltyPercent3Edit.Text);
        except
        end;

        try
          PenaltyPercent4 := StrToFloat(PenaltyPercent4Edit.Text);
        except
        end;

          {CHG08072002-1: Option of whether or not to include labels such as 'SCHL'
                          in the estimated state aid column.}

        IncludeLabelOnStateAid := IncludeLabelOnStateAidCheckBox.Checked;

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

        If ((not Quit) and
            dlg_SaveTaxExtractFile.Execute)
          then
            begin
              LoadRateListsFromRateFiles(TaxRollYear, CollectionType,
                                         CollectionNum, GeneralRateList,
                                         SDRateList,
                                         SpecialFeeRateList,
                                         BillControlDetailList, 'P', Quit);

                {CHG05242004-1(2.07l5): Is this a city\schcollection?}

              HasMunicipalRate := False;
              HasSchoolRate := False;

              For I := 0 to (GeneralRateList.Count - 1) do
                with GeneralRatePointer(GeneralRateList[I])^ do
                  begin
                    If (GeneralTaxType = 'TO')
                      then HasMunicipalRate := True;

                    If (GeneralTaxType = 'SC')
                      then HasSchoolRate := True;

                  end;  {For I := 0 to (GeneralRateList.Count - 1) do}

              IsCitySchoolCollection := (HasMunicipalRate and HasSchoolRate);

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

              ProgressDialog.Start(GetRecordCount(BLHeaderTaxTable), True, True);

              Create160File;

              ProgressDialog.Finish;

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

              If (MessageDlg('Do you want to copy\zip the laser billing file to another drive or disk?',
                              mtConfirmation, [mbYes, mbNo], 0) = idYes)
                then
                  with ZipCopyDlg do
                    begin
                      InitialDrive := GlblDrive;
                      InitialDir := GlblExportDir;
                      SelectFile(dlg_SaveTaxExtractFile.FileName);
                      Execute;

                    end;  {with ZipCopyDlg do}

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

          {CHG03232004-4(2.08): Change the email sending process and add it to all needed places.}

(*        If (MessageDlg('Do you want to email the laser bill file?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            begin
              ExtractDir := GlblDrive + ':' + GlblExportDir;
              TempFileName := ExtractDir + 'RPS160D1';
              SelectedFiles := TStringList.Create;
              SelectedFiles.Add(TempFileName);

              ZipFileName := Trim(GlblMunicipalityName) +
                             '_Laser_Bill_File_' +
                             MakeMMDDYYYYDate(Date) +
                             '.zip';
              ZipFileName := StringReplace(ZipFileName, ' ', '_', [rfReplaceAll]);

              MailSubject := Trim(GlblMunicipalityName) + ' laser bill file extract ' + DateToStr(Date);

              EMailFile(Self, ExtractDir, ExtractDir, ZipFileName, MailSubject, SelectedFiles, True);
              SelectedFiles.Free;

            end;  {If (MessageDlg('Do you want to email this file?' + #13 +} *)

      end;  {If OKToStart}

end;  {PrintButtonClick}

{===================================================================}
Function TCreateRPS160ExtractForm.ParcelShouldBePrinted(BLHeaderTaxTable : TTable;
                                                   SelectedSwisCodes : TStringList) : Boolean;

{We should print this parcel if it does not have a bank code in the exclusion list.}

var
  I, BankCodeLen : Integer;
  TotalOwed : Extended;

begin
  Result := True;

    {FXX03182009-1(2.17.1.9): Don't exclude rs 8, no tax bills.  That is taken care of by the option below.}

(*  If (Result and
      (BLHeaderTaxTable.FieldByName('RollSection').Text = '8') and
      (Roundoff(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
    then Result := False; *)

    {CHG12052007(2.11.5.2): Add option to exlcude zero bills.}

  If (Result and
      ExcludeZeroBills and
      _Compare(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 0, coEqual))
    then Result := False;

    {CHG05072002-1: Allow them to exclude all roll seciton 8 parcels.}

  If (Result and
      (not IncludeRS8Parcels) and
      (BLHeaderTaxTable.FieldByName('RollSection').Text = '8'))
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

    {CHG08252004-1(2.08.0.08302004): Option to exclude all roll section 3 bills.}

  If (Result and
      ExcludeRollSection3 and
      (BLHeaderTaxTable.FieldByName('RollSection').Text = '3'))
    then Result := False;

    {CHG08252004-1(2.08.0.08302004): Option to exclude all bank coded bills from the 160.}

  If (Result and
      ExcludeAllBankCodes and
      (Deblank(BLHeaderTaxTable.FieldByName('BankCode').Text) <> ''))
    then Result := False;
    
end;  {ParcelShouldBePrinted}

{=========================================================================}
Procedure TCreateRPS160ExtractForm.PrintOneExemption(var RPS160File : TextFile;
                                                         CollectionType : String;
                                                         EXTaxRecord : ExemptTaxRecord);

var
  Amount : Comp;
  TownAbbreviated, TownFull, PurposeStr : String;

begin
  with EXTaxRecord do
    begin
        {CHG05242004-1(2.07l5): Is this a city\schcollection?
                                If it is, then print the school amount if there is no city.}
        {FXX01042006-1(2.9.4.7): The amount was not showing for town only exemptions.}

      If ((CollectionType = 'SC') or
          (IsCitySchoolCollection and
           (TownAmount = 0) and
           (CountyAmount = 0)))
        then Amount := SchoolAmount
        else
          If _Compare(CollectionType, VillageTaxType, coEqual)
            then
              begin
                Amount := VillageAmount;
                TownAbbreviated := 'VIL';
                TownFull := 'VILLAGE';
              end
            else
              begin
                If ((CollectionType = 'TO') or
                    (CollectionType = 'CI') or
                    IsCitySchoolCollection or
                    (_Compare(CollectionType, MunicipalTaxType, coEqual) and
                     _Compare(CountyAmount, 0, coEqual)))
                  then Amount := TownAmount
                  else Amount := CountyAmount;

                If (GlblMunicipalityType = mtCity)
                  then
                    begin
                      TownAbbreviated := 'CIT';
                      TownFull := 'CITY';
                    end
                  else
                    begin
                      TownAbbreviated := 'TWN';
                      TownFull := 'TOWN';
                    end;

              end;  {else of If _Compare(CollectionType, VillageTaxType, coEqual)}

      case ExCode[5] of
        '0' : PurposeStr := 'CTY/' + TownAbbreviated + '/SCH';
        '1' : PurposeStr := 'CTY/' + TownAbbreviated;
        '2' : PurposeStr := 'COUNTY';
        '3' : PurposeStr := TownFull;
        '4' : PurposeStr := 'SCHOOL';
        '5' : PurposeStr := 'CTY/SCH';
        '6' : PurposeStr := TownAbbreviated + '/SCH';
        '7' : PurposeStr := 'VILLAGE';

      end;  {case ExCode[5] of}

          {CHG11302006-1(2.11.1.4): Accomodate new full value of exemption requirements.}
        {Now only extract 6 exemptions with the following format:
           Literal (10)
           Value (14)
           Purpose (11)
           Full Value (14).}

      Write(RPS160File, Take(10, Description),
                        ShiftRightAddBlanks(Take(14, FormatFloat(CurrencyDisplayNoDollarSign, Amount))),
                        Take(11, PurposeStr),
                        ShiftRightAddBlanks(Take(14, FormatFloat(CurrencyDisplayNoDollarSign, FullValue))));

    end;  {with EXTaxRecord do}

end;  {PrintOneExemption}

{=========================================================================}
Procedure TCreateRPS160ExtractForm.PrintOneGeneralTaxDetail(var RPS160File : TextFile;
                                                                GnTaxRecord : GeneralTaxRecord;
                                                                SwisSBLKey : String;
                                                            var GeneralTaxLinesPrinted : Integer);

var
  SwisCode, sFormat : String;
  RateIndex : Integer;
  _TaxRate : Extended;
  PercentChange : Double;

begin
  with GnTaxRecord do
    begin
      SwisCode := Copy(SwisSBLKey, 1, 6);

        {Only search on the first 4 digits of swis code.}

      If (GeneralTaxType = 'CO')
        then SwisCode := Take(4, SwisCode);

      RateIndex := FindGeneralRate(PrintOrder, GeneralTaxType, SwisCode, GeneralRateList);

      with GeneralRatePointer(GeneralRateList[RateIndex])^ do
        begin
          If GlblMunicipalityUsesTwoTaxRates
            then
              begin                   
                If (HomesteadCode = 'N')
                  then _TaxRate := NonhomesteadRate
                  else _TaxRate := HomesteadRate;

              end
            else _TaxRate := HomesteadRate;

          Write(RPS160File, Take(20, Description),
                            ConstStr(' ', 7),
                            ShiftRightAddBlanks(Take(17, FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy))));

          PercentChange := ComputeTaxLevyPercentChange(CurrentTaxLevy, PriorTaxLevy);

          If (Roundoff(PercentChange, 2) <> 0)
            then Write(RPS160File, ShiftRightAddBlanks(Take(5, FormatFloat(DecimalEditDisplay, PercentChange))))
            else Write(RPS160File, ConstStr(' ', 5));

          (*Write(RPS160File, ShiftRightAddBlanks(Take(16, FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal))),
                            ShiftRightAddBlanks(Take(12, FormatFloat(ExtendedDecimalDisplay, _TaxRate))),
                            ShiftRightAddBlanks(Take(16, FormatFloat(DecimalDisplay, TaxAmount))));   *)

          If bShowDecimalsOnTaxableValue
          then sFormat := DecimalDisplay
          else sFormat := CurrencyDisplayNoDollarSign;

          Write(RPS160File, ShiftRightAddBlanks(Take(16, FormatFloat(sFormat, TaxableVal))),
                            ShiftRightAddBlanks(Take(12, FormatFloat(ExtendedDecimalDisplay, _TaxRate))),
                            ShiftRightAddBlanks(Take(16, FormatFloat(DecimalDisplay, TaxAmount))));

        end;  {with GeneralRatePointer(GeneralRateList[RateIndex])^ do}

    end;  {with GnTaxRecord do}

  GeneralTaxLinesPrinted := GeneralTaxLinesPrinted + 1;

end;  {PrintOneGeneralTaxDetail}

{=========================================================================}
Procedure TCreateRPS160ExtractForm.PrintOneSDTaxDetail(var RPS160File : TextFile;
                                                           SDTaxRecord : SDistTaxRecord;
                                                       var SDIndex : Integer);

var
  Index : Integer;
  PercentChange : Real;
  TaxableValStr : String;

begin
  with SDTaxRecord do
    begin
      SDIndex := SDIndex + 1;
      FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, Index);

      If (HomesteadCode = 'N')
        then TaxRate := SDRatePointer(SDRateList[Index])^.NonHomesteadRate
        else TaxRate := SDRatePointer(SDRateList[Index])^.HomesteadRate;

        {FXX03142002-1: Have to round to 6 places to handle rates less than 1.}

      with SDRatePointer(SDRateList[Index])^ do
        begin
            {FXX12282005-1(2.9.4.5): Option to print the special district extensions.}

          If DisplaySpecialDistrictExtensions
            then Write(RPS160File, Take(20, Description),
                                   ShiftRightAddBlanks(Take(7, GetSDExtCategory(ExtCode, SDExtCodeDescList))))
            else Write(RPS160File, Take(27, Description));

          Write(RPS160File, ShiftRightAddBlanks(Take(17, FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy))));

          PercentChange := ComputeTaxLevyPercentChange(CurrentTaxLevy, PriorTaxLevy);

          If (Roundoff(PercentChange, 2) <> 0)
            then Write(RPS160File, ShiftRightAddBlanks(Take(5, FormatFloat(DecimalEditDisplay, PercentChange))))
            else Write(RPS160File, ConstStr(' ', 5));

          If (ExtCode = 'TO')
            then TaxableValStr := FormatFloat(CurrencyDisplayNoDollarSign, SdValue)
            else TaxableValStr := FormatFloat(DecimalDisplay, SdValue);

          (*If (ExtCode = 'TO')
            then TaxableValStr := FormatFloat(DecimalDisplay, SdValue)
            else TaxableValStr := FormatFloat(DecimalDisplay, SdValue);  *)

          If CombinedDistrictRecord
            then
              begin
                TaxRate := 0;
                TaxableValStr := '';
              end;

            {FXX12282005-2(2.9.4.5): Make float format for rate be blank for zero for combined districts.}

          Write(RPS160File, ShiftRightAddBlanks(Take(16, TaxableValStr)),
                            ShiftRightAddBlanks(Take(12, FormatFloat(ExtendedDecimalDisplay, TaxRate))),
                            ShiftRightAddBlanks(Take(16, FormatFloat(DecimalDisplay, SDAmount))));

        end;  {with SDRatePointer(SDRateList[Index])^ do}

    end;  {with SDTaxRecord do}

end;  {PrintOneSDTaxDetail}

{=========================================================================}
Procedure TCreateRPS160ExtractForm.PrintOneSpecialFeeDetail(var RPS160File : TextFile;
                                                                SpecialFeeRec : SPFeeTaxRecord;
                                                            var SpecialFeeIndex : Integer);

begin
  with SpecialFeeRec do
    begin
      SpecialFeeIndex := SpecialFeeIndex + 1;

      Write(RPS160File, Take(27, Description),
                        ConstStr(' ', 17),
                        ConstStr(' ', 5),
                        ConstStr(' ', 16),
                        ConstStr(' ', 12),
                        ShiftRightAddBlanks(Take(16, FormatFloat(DecimalDisplay, SPAmount))));

    end;  {with SpecialFeeRec do}

end;  {PrintOneSpecialFeeDetail}

{=========================================================================}
Procedure TCreateRPS160ExtractForm.Write160Header(var RPS160File : TextFile;
                                                      SwisSBLKey : String;
                                                      RecordNumber : Integer;
                                                      CurrentPageNumber : Integer;
                                                      TotalPages : Integer);

var
  LegalAddrNo, FormattedSwisSBLKey : String;
  NAddrArray : NameAddrArray;
  I : Integer;
  UniformPercentValue, FullValue : Double;

begin
  with BLHeaderTaxTable do
    begin
      FormattedSwisSBLKey := ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text);

      SwisSBLKey := Take(6, FieldByName('SwisCode').Text) +
                    Take(20, FieldByName('SBLKey').Text);

      Write(RPS160File, Take(26, SwisSBLKey),                             {1-26: Key Swis SBL}
                        Take(2, FieldByName('CheckDigit').Text),           {27-28: Check digit}
                        ShiftRightAddZeroes(Take(6, IntToStr(RecordNumber))),          {29-34: Sequence number}
                        ShiftRightAddZeroes(Take(2, IntToStr(CurrentPageNumber))),     {35-36: Current page}
                        ShiftRightAddZeroes(Take(2, IntToStr(TotalPages))),     {37-38: Total pages}
                        ShiftRightAddZeroes(Take(6, FieldByName('BillNo').Text)), ' ', {39-45: Bill with 1 space at end}
                        Take(25, FormattedSwisSBLKey), {46-70: Print key}
                        FormatRPSNumericString(FieldByName('Frontage').Text, 7, 2),    {71-77: Frontage}
                        FormatRPSNumericString(FieldByName('Depth').Text, 7, 2),       {78-84: Depth}
                        FormatRPSNumericString(FloatToStr(FieldByName('HstdAcreage').AsFloat +
                                                          FieldByName('NonhstdAcreage').AsFloat), 7, 2)); {85-91: Acreage}

        {We will conform to present 155\995 legal addr number format for
         file comparison purposes. The rule is: If this is a numeric legal
         addr number, put it to the right in nine spaces and leave one
         blank space. Otherwise, put it to the right in 10 spaces.}

      LegalAddrNo := Trim(FieldByName('LegalAddrNo').Text);

      (*If (LegalAddrNo[Length(LegalAddrNo)] in Numbers)
        then LegalAddrNo := ShiftRightAddBlanks(Take(9, LegalAddrNo)) + ' '
        else *) LegalAddrNo := ShiftRightAddBlanks(Take(10, LegalAddrNo));

      Write(RPS160File, Take(10, LegalAddrNo),                    {92-101: Legal addr no}
                        Take(25, FieldByName('LegalAddr').Text)); {102-126: Legal addr}

      FindKeyOld(SwisCodeTable, ['SwisCode'], [FieldByName('SwisCode').Text]);
      FindKeyOld(SchoolCodeTable, ['SchoolCode'], [FieldByName('SchoolDistCode').Text]);

      Write(RPS160File, Take(20, SwisCodeTable.FieldByName('MunicipalityName').Text),  {127-146: Town Name}
                        Take(12, UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,  {147-158: Property Class Desc}
                                                                  PropertyClassDescList))),
                        ' ',  {159: Filler}
                        Take(1, FieldByName('RollSection').Text),                     {160: Roll Section}
                        Take(20, SchoolCodeTable.FieldByName('SchoolName').Text),     {161-180: School Name}
                        Take(3, SchoolCodeTable.FieldByName('TaxFinanceCode').Text),  {181-183: Finance code}
                        Take(11, FieldByName('MortgageNumber').Text),                 {184-194: Mortgage Number}
                        Take(11, FieldByName('AccountNumber').Text),                  {195-205: Account Number}
                        ShiftRightAddBlanks(Take(7, Trim(FieldByName('BankCode').Text))),   {206-212: Bank Code}
                        Take(7, ''),                                                   {213-219: Bank sub code}
                        Take(25, FieldByName('PropDescr1').Text),                     {220-244: Prop Desc 1}
                        Take(25, FieldByName('PropDescr2').Text),                     {245-269: Prop Desc 2}
                        Take(25, FieldByName('PropDescr3').Text));                    {270-294: Prop Desc 3}

      If glblUsesTaxBillNameAddr
      then
      begin
        If _Locate(tbTaxBillNameAddress, [glblNextYear, SwisSBLKey], '', [])
        then GetNameAddress(tbTaxBillNameAddress, NAddrArray)
        else GetNameAddress(BLHeaderTaxTable, NAddrArray)
      end
      else GetNameAddress(BLHeaderTaxTable, NAddrArray);

        {CHG07232006-1(2.9.8.1): Expand name \ address field to 30.}

      For I := 1 to 6 do
        Write(RPS160File, Take(30, NAddrArray[I]));  {295-474: Name\addr 25 chars each.}

      UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
      FullValue := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                     FieldByName('NonHstdTotalVal').AsFloat),
                                    SwisCodeTable,
                                    FieldByName('PropertyClassCode').Text,
                                    ' ', True);

      Write(RPS160File, FormatRPSNumericString(FloatToStr(FullValue), 12, 0),  {475-486: Full value}
                        FormatRPSNumericString(FloatToStr(UniformPercentValue), 5, 2));  {487-491: Uniform percent of value}

    end;  {with BLHeaderTaxTable do}

end;  {Write160Header}

{=========================================================================}
Procedure TCreateRPS160ExtractForm.WriteExemptions(var RPS160File : TextFile;
                                                       SwisSBLKey : String;
                                                       RecordNumber : Integer;
                                                       sPropertyClassCode : String);

var
  SeniorSchoolDescription : String;
  I : Integer;
  SeniorSchoolAmount : Comp;
  SeniorSchoolFullValue : LongInt;
  ExTaxPtr : ExemptTaxPtr;

begin
      {CHG11302006-1(2.11.1.4): Accomodate new full value of exemption requirements.}
    {Now only extract 6 exemptions with the following format:
       Literal (10)
       Value (14)
       Purpose (11)
       Full Value (14).}

    {Now extract up to 9 exemptions from 492 to 806, 35 chars each.}

    {CHG05242004-1(2.07l5): Is this a city\schcollection?
                            If it is, then print the school amount if there is no city.}

  If IsCitySchoolCollection
    then
      begin
        SeniorSchoolAmount := 0;
        SeniorSchoolFullValue := 0;

        For I := (ExTaxList.Count - 1) downto 0 do
          with ExemptTaxPtr(ExTaxList[I])^ do
            begin
                {If this is a senior exemption and the school amount is different from
                 the town amount, split them into 2 codes.}
                {FXX06182008-1(2.13.1.15): Make sure to recalculate the school full value.}

              If (ExemptionIsSenior(ExCode) and
                  (TownAmount <> SchoolAmount))
                then
                  begin
                    ExCode := '41803';
                    SeniorSchoolAmount := SchoolAmount;
                    SeniorSchoolDescription := Description;
                    SeniorSchoolFullValue := Trunc(ComputeFullValue(SeniorSchoolAmount,
                                                                    SwisCodeTable,
                                                                    sPropertyClassCode,
                                                                    ' ', True));

                  end;  {If (ExemptionIsSenior(ExCode) and ...}

                {First get rid of exemptions that don't apply.}

              If ((TownAmount = 0) and
                  (SchoolAmount = 0))
                then
                  begin
                    FreeMem(ExTaxList[I], SizeOf(ExemptTaxPtr));
                    ExTaxList.Delete(I);
                  end;

            end;  {with ExemptTaxPtr(ExTaxList[I])^ do}

        If (SeniorSchoolAmount > 0)
          then
            begin
              New(ExTaxPtr);

              with ExTaxPtr^ do
                begin
                  ExCode := '41804';
                  HomesteadCode := '';
                  Description := SeniorSchoolDescription;
                  InitialYear := '';
                  CountyAmount := 0;
                  TownAmount := 0;
                  SchoolAmount := SeniorSchoolAmount;
                  VillageAmount := 0;
                  FullValue := SeniorSchoolFullValue;

                end;  {with ExTaxPtr^ do}

              ExTaxList.Add(ExTaxPtr);

            end;  {If (SeniorSchoolAmount > 0)}

      end;  {If IsCitySchoolCollection}

  For I := 1 to 6 do
    If (I <= ExTaxList.Count)
      then PrintOneExemption(RPS160File, CollectionType,
                             ExemptTaxPtr(ExTaxList[I-1])^)
      else Write(RPS160File, ConstStr(' ', 49));

  Write(RPS160File, ConstStr(' ', 21));
  
end;  {WriteExemptions}

{=========================================================================}
Procedure TCreateRPS160ExtractForm.WriteDetails(var RPS160File : TextFile;
                                                    SwisSBLKey : String;
                                                    RecordNumber : Integer;
                                                var SDIndex : Integer;
                                                    TotalQuarterlyServiceCharge : Double);

var
  TempHomestead, TempStr : String;
  I, GeneralTaxLinesPrinted, SpecialFeeIndex : Integer;
  LinePrinted : Boolean;

begin
    {Now extract up to 16 tax detail lines from 807-2294, 93 chars each.}
    {CHG12192004-2(2.8.1.5): If printing the quarterly amounts, the 16th detail
                             is a summartion of the service charge.}

  GeneralTaxLinesPrinted := 0;
  SpecialFeeIndex := 0;

    {CHG08262004-3(2.8.0.9): Allow for a placed messge (i.e. a certain tax line.}

  If (SDIndex = 0)
    then
      begin
        with BLHeaderTaxTable do
          For I := 1 to 16 do
            begin
              LinePrinted := False;

              If ((I = 1) and
                  (FirstLine in [flHomesteadStatus, flSpecialMessage]))
                then
                  begin
                    TempHomestead := Take(1, FieldByName('HomesteadCode').Text);

                    If (FirstLine = flHomesteadStatus)
                      then
                        begin
                          case TempHomestead[1] of
                            ' ' : TempStr := '';
                            'H' : TempStr := '**HOMESTEAD PARCEL**';
                            'N' : TempStr := '**NON-HOMESTEAD PARCEL**';
                            'S' : TempStr := '**CLASSIFIED PARCEL**';

                          end;  {case TempHomestead[1] of}

                            {CHG08262004-4(2.8.0.9): Option to suppress 'T' at end of line for a first line special message or homestead message.}

                          Write(RPS160File, Take(92, TempStr));

                          If IncludeTatEndOfSpecialMessage
                            then Write(RPS160File, 'T')
                            else Write(RPS160File, ' ');

                        end;  {If (FirstLine = flHomesteadStatus)}

                    If (FirstLine = flSpecialMessage)
                      then
                        begin
                          Write(RPS160File, Take(92, FirstLineMessageEdit.Text));

                            {CHG08262004-4(2.8.0.9): Option to suppress 'T' at end of line for a first line special message or homestead message.}

                          If IncludeTatEndOfSpecialMessage
                            then Write(RPS160File, 'T')
                            else Write(RPS160File, ' ');

                        end;  {If (FirstLine = flSpecialMessage)}

                    LinePrinted := True;

                  end;  {If ((I = 1) and ...}

              If ((not LinePrinted) and
                  (Deblank(PlacedSpecialMessage) <> '') and
                  (I = PlacedSpecialMessageLineNumber))
                then
                  begin
                    Write(RPS160File, Take(93, PlacedSpecialMessage));
                    LinePrinted := True;
                  end;

                {CHG12192004-1(2.8.1.5): Add an arrears message.}

              If ((not LinePrinted) and
                  (Deblank(PlacedArrearsMessage) <> '') and
                  (I = PlacedArrearsMessageLineNumber) and
                  FieldByName('ArrearsFlag').AsBoolean)
                then
                  begin
                    LinePrinted := True;
                    Write(RPS160File, Take(93, PlacedArrearsMessage));
                  end;

              If (PrintQuarterlyAmounts and
                  (Roundoff(TotalQuarterlyServiceCharge, 2) > 0) and
                  (I = 16))
                then
                  begin
                    LinePrinted := True;
                    Write(RPS160File, Take(80, 'PARTIAL PAYMENT SERVICE CHARGE'),
                                      ShiftRightAddBlanks(Take(13, FormatFloat(DecimalEditDisplay, TotalQuarterlyServiceCharge))));

                  end;  {If (PrintQuarterlyAmounts and ...}

              If ((not LinePrinted) and
                  ((PlacedSpecialMessageLineNumber = 0) or
                   (I < PlacedSpecialMessageLineNumber)) and
                  (GeneralTaxLinesPrinted <= (GnTaxList.Count - 1)))
                then
                  begin
                    LinePrinted := True;
                    PrintOneGeneralTaxDetail(RPS160File,
                                             GeneralTaxPtr(GnTaxList[GeneralTaxLinesPrinted])^,
                                             SwisSBLKey,
                                             GeneralTaxLinesPrinted);

                  end;  {If ((not LinePrinted) and ...}

              If ((not LinePrinted) and
                  ((PlacedSpecialMessageLineNumber = 0) or
                   (I < PlacedSpecialMessageLineNumber)) and
                   (SDIndex <= (SDTaxList.Count - 1)))
                then
                  begin
                    LinePrinted := True;
                    PrintOneSDTaxDetail(RPS160File,
                                        SDistTaxPtr(SDTaxList[SDIndex])^,
                                        SDIndex);

                  end;  {If ((not LinePrinted) and ...}

                {FXX03042008-1(2.11.7.11): Include special fees in the 160.}

              If ((not LinePrinted) and
                  (not bIncludeTownFeeAmounts) and
                  ((PlacedSpecialMessageLineNumber = 0) or
                   (I < PlacedSpecialMessageLineNumber)) and
                   (SpecialFeeIndex <= (SPTaxList.Count - 1)))
                then
                  begin
                    LinePrinted := True;
                    PrintOneSpecialFeeDetail(RPS160File,
                                             SPFeeTaxPtr(SPTaxList[SpecialFeeIndex])^,
                                             SpecialFeeIndex);

                    If bIncludeTownFeeAmounts
                    then fTownFee := SPFeeTaxPtr(SPTaxList[SpecialFeeIndex])^.SPAmount;

                  end;  {If ((not LinePrinted) and ...}

              If not LinePrinted
                then Write(RPS160File, ConstStr(' ', 93));

            end;  {For I := 1 to NumDetailsToPrint do}

      end
    else
      For I := 1 to 16 do
        If (SDIndex <= (SDTaxList.Count - 1))
          then PrintOneSDTaxDetail(RPS160File,
                                   SDistTaxPtr(SDTaxList[SDIndex])^,
                                   SDIndex)
          else Write(RPS160File, ConstStr(' ', 93));

end;  {WriteDetails}

{========================================================================}
Procedure FigureQuarterlyPaymentAmounts(      Tottax: Double;
                                        var   FloorBase,
                                              FloorSC,
                                              BaseBreakage,
                                              SCBreakage : Double);  {qtrqtr}

{calculate the 4 I/P amts for rockland county....this is used for comupting}
{amts for Ramapo tax build (RPSImport) and for recalc in Acmfedit whenever}
{master file is edited for any rockland IP customer (eg rampapo, clarkstown, stp pt)}
Var
  StartSc, Temprl : Double;
   SCPCt : Double;

Begin
SCPct := 5; {get svc charge %}
StartSC := Tottax* (RoundOff( (ScPct/100),2));
StartSC := RoundOff(StartSc,2);

  {calc base install payment}
FloorBase := TotTax/4;
FloorBase := RoundOff(FloorBase,2);
TempRl := FloorBase * 4;
TempRl := RoundOff(TempRl,2);
  {for Ramampo only calc ip if total tax > 50.00, else ips = 0}
If (RoundOff(Tottax,2) > 50.00)
  then
  begin
   {if 4 times base > taxes owed, bac, off 1 cent to get floor base payment}
   {....then add pennies in to 1st payment if any}
  If (Roundoff(TempRl,2) > RoundOff(TOtTax,2) )

   then
   begin
     {get highest install paymt which doesnt exceed tot tax when mult by 4}
   FloorBase := FloorBase - 0.01;
   FloorBase := RoundOff(FloorBase,2);
   TempRl := FloorBAse * 4;
   BaseBreakage := TotTAx - Temprl;
   BaseBreakage := RoundOff(BaseBreakage,2);
   end
   else
   begin

    {floor base * 4 < = total taxes case}
   If  (Roundoff(TempRl,2) < RoundOff(TotTax,2) )
       then
       begin
       BaseBreakage :=  RoundOff(TotTax,2) -
                                   (Roundoff(TempRl,2));
       end
       else BaseBreakage := 0;
   end;

  {calc base install payment}
  FloorSC := StartSC / 4;
  FloorSC := RoundOff(FloorSC,2);
  TempRl := FloorSC * 4;
  TempRl := RoundOff(TempRl,2);

   {if 4 times install SC > taxes owed, bac, off 1 cent to get floor sc payment}
   {....then add pennies in to 1st payment if any}
  If (Roundoff(TempRl,2) > RoundOff(StartSC,2) )
   then
   begin
     {get highest install paymt which doesnt exceed tot tax when mult by 4}
   FloorSC := FloorSC - 0.01;
   FloorSC := RoundOff(FloorSC,2);
   TempRl := FloorSC * 4;
   SCBreakage := StartSC - Temprl;
   SCBreakage := RoundOff(SCBreakage,2);
   end
   else
   begin

    {floor base * 4 < = total taxes case}
   If  (Roundoff(TempRl,2) < RoundOff(StartSC,2) )
       then
       begin
       SCBreakage :=  RoundOff(StartSC,2) -
                                   (Roundoff(TempRl,2));
       end
       else SCBreakage := 0;
   end;
  end
  else
   {if tot tax < 50.00 ip amounts are 0}
  begin
  FloorBase := 0.0;
  FloorSC := 0.0;
  BaseBreakage := 0.0;
  SCBreakage := 0.0;

  end;

end;

{=========================================================================}
Procedure TCreateRPS160ExtractForm.WriteFooter(var RPS160File : TextFile;
                                                   SwisSBLKey : String;
                                                   RecordNumber : Integer;
                                                   PaymentArray : PaymentRecordArrayType;
                                                   TotalQuarterlyCharge : Double);

var
  TempStr, TempFieldName, ArrearsFlag : String;
  NumberOfPayments,
  I : Integer;
  STARSavings : Double;
  AssessedValue : LongInt;
  CountyStateAid, TownStateAid, SchoolStateAid, VillageStateAid : Comp;
  TempEditBox : TEdit;
  TempEditBoxName : String;
  CurrentPenaltyIndex : Integer;
  PenaltyPercent, PenaltyAmount, TotalBase : Double;

begin
  with BLHeaderTaxTable do
    begin
        {FXX08212001-2: Make sure to go through all the rate indexes so that
                        if the main rate with the star savings is not first, we get it.}

      STARSavings := 0;

      For I := 0 to (GnTaxList.Count - 1) do
        STARSavings := STARSavings + GeneralTaxPtr(GnTaxList[I])^.StarSavings;

      Write(RPS160File, FormatRPSNumericString(FieldByName('TotalTaxOwed').Text, 14, 2),  {2295-2308: Total Tax Due}
                        FormatRPSNumericString(FloatToStr(STARSavings), 14, 2));  {2309-2322: STAR Savings}

        {CHG08262004-2(2.8.0.9): Add the penalty schedule logic.}

      If (PrintQuarterlyAmounts and
          (Roundoff(TotalQuarterlyCharge, 2) > 0))
        then
          begin
              {6 payment amounts from 2333-2335, 13 chars each.}

            For I := 1 to 6 do
              Write(RPS160File, ShiftRightAddBlanks(Take(13, FormatFloat(DecimalDisplay_BlankZero,
                                                                         PaymentArray[I].BaseAmount))));

              {5 blank interests from 2401 - 2465: No interest on quarterlies.}

            For I := 1 to 5 do
              Write(RPS160File, Take(13, ''));

              {6 total payment amounts, ignoring interest from 2466-2543, 13 chars each.}

            For I := 1 to 6 do
              Write(RPS160File, ShiftRightAddBlanks(Take(13, FormatFloat(DecimalDisplay_BlankZero,
                                                                         PaymentArray[I].TotalAmount))));

              {6 Due dates 2544 - 2594, 10 chars each.}

            For I := 1 to 6 do
              Write(RPS160File, Take(10, PaymentArray[I].PayDate));

          end
        else
          If UsePenaltySchedule
            then
              begin
                NumberOfPayments := CollectionLookupTable.FieldByName('NumberOfPayments').AsInteger;
                TotalBase := 0;

                  {First fill in the standard payments (non-penalty).}

                  {For town fee, put subtotal (base + town fee - star savings) in Payment Amount #5,
                   town fee in Int \ Pen #5}

                If bIncludeTownFeeAmounts
                then
                begin
                  For I := 1 to 2 do
                    with PaymentArray[I] do
                      begin
                        TempFieldName := 'TaxPayment' + IntToStr(I);
                        BaseAmount := FieldByName('TaxPayment1').AsFloat - fTownFee;
                        TotalBase := BaseAmount;

                        If _Compare(I, 1, coEqual)
                        then Penalty := fTownFee
                        else
                        begin
                          CurrentPenaltyIndex := I - 1;

                          TempEditBoxName := 'PenaltyPercent' + IntToStr(CurrentPenaltyIndex) + 'Edit';
                          TempEditBox := nil;

                          try
                            TempEditBox := TEdit(Self.FindComponent(TempEditBoxName));
                          except
                          end;

                          If ((TempEditBox <> nil) and
                              (Deblank(TEdit(TempEditBox).Text) <> ''))
                            then
                              begin
                                PenaltyPercent := 0;
                                try
                                  PenaltyPercent := StrToFloat(TEdit(TempEditBox).Text);
                                except
                                end;

                                PenaltyAmount := Roundoff((TotalBase * (PenaltyPercent / 100)), 2);

                                TempEditBoxName := 'PenaltyDate' + IntToStr(CurrentPenaltyIndex) + 'Edit';

                                try
                                  TempEditBox := TEdit(Self.FindComponent(TempEditBoxName));
                                except
                                end;

                                with PaymentArray[I] do
                                  begin
                                    PayDate := TEdit(TempEditBox).Text;
                                    Penalty := PenaltyAmount;

                                  end;  {with PaymentArray[I] do}

                              end;  {If ((TempEditBox <> nil) and ...}

                        end;  {else of If _Compare(I, 1, coEqual)}

                        TotalAmount := TotalBase + Penalty;

                        TempFieldName := 'PayDate' + IntToStr(I);
                        PayDate := CollectionLookupTable.FieldByName(TempFieldName).Text;

                      end;  {with PaymentArray[I] do}

                end  {If bIncludeTownFeeAmounts}
                else
                begin
                  For I := 1 to NumberOfPayments do
                    with PaymentArray[I] do
                      begin
                        TempFieldName := 'TaxPayment' + IntToStr(I);
                        BaseAmount := FieldByName(TempFieldName).AsFloat;
                        TotalBase := TotalBase + BaseAmount;
                        Penalty := 0;
                        TotalAmount := FieldByName(TempFieldName).AsFloat;

                        TempFieldName := 'PayDate' + IntToStr(I);
                        PayDate := CollectionLookupTable.FieldByName(TempFieldName).Text;

                      end;  {with PaymentArray[I] do}

                    {Now do the penalty amounts.}

                  CurrentPenaltyIndex := 1;

                  For I := (NumberOfPayments + 1) to 6 do
                    begin
                      TempEditBoxName := 'PenaltyPercent' + IntToStr(CurrentPenaltyIndex) + 'Edit';
                      TempEditBox := nil;

                      try
                        TempEditBox := TEdit(Self.FindComponent(TempEditBoxName));
                      except
                      end;

                      If ((TempEditBox <> nil) and
                          (Deblank(TEdit(TempEditBox).Text) <> ''))
                        then
                          begin
                            PenaltyPercent := 0;
                            try
                              PenaltyPercent := StrToFloat(TEdit(TempEditBox).Text);
                            except
                            end;

                            PenaltyAmount := Roundoff((TotalBase * (PenaltyPercent / 100)), 2);

                            TempEditBoxName := 'PenaltyDate' + IntToStr(CurrentPenaltyIndex) + 'Edit';

                            try
                              TempEditBox := TEdit(Self.FindComponent(TempEditBoxName));
                            except
                            end;

                            with PaymentArray[I] do
                              begin
                                PayDate := TEdit(TempEditBox).Text;
                                Penalty := PenaltyAmount;
                                BaseAmount := TotalBase;
                                TotalAmount := PenaltyAmount + TotalBase;

                              end;  {with PaymentArray[I] do}

                          end;  {If ((TempEditBox <> nil) and ...}

                      CurrentPenaltyIndex := CurrentPenaltyIndex + 1;

                    end;  {For I := (NumberOfPayments + 1) to 6 do}

                end;  {else of If bIncludeTownFeeAmounts}

                  {6 payment amounts from 2323-2335, 13 chars each.}


                For I := 1 to 6 do
                  Write(RPS160File, ShiftRightAddBlanks(Take(13, FormatFloat(DecimalDisplay_BlankZero,
                                                                             PaymentArray[I].BaseAmount))));

                  {CHG08262004-1(2.8.0.9): Activate the penalty date.}
                  {5 blank interests from 2401 - 2465: not supported for now.}
                  {Note: For now, I am printing the first interest amount (i.e. associated with the first penalty payment)
                   in the second penalty/interest column because the printer can't deal with it the correct way.}

                For I := 1 to 5 do
                  Write(RPS160File, ShiftRightAddBlanks(Take(13, FormatFloat(DecimalDisplay_BlankZero,
                                                                             PaymentArray[I].Penalty))));

                  {6 total payment amounts, ignoring interest from 2466-2543, 13 chars each.}

                For I := 1 to 6 do
                  Write(RPS160File, ShiftRightAddBlanks(Take(13, FormatFloat(DecimalDisplay_BlankZero,
                                                                             PaymentArray[I].TotalAmount))));

                  {6 Due dates 2544 - 2594, 10 chars each.}

                For I := 1 to 6 do
                  Write(RPS160File, Take(10, PaymentArray[I].PayDate));

              end
            else
              begin
                  {6 payment amounts from 2323-2335, 13 chars each.}

                For I := 1 to 6 do
                  begin
                    TempFieldName := 'TaxPayment' + IntToStr(I);

                    Write(RPS160File, ShiftRightAddBlanks(Take(13, FormatFloat(DecimalDisplay_BlankZero,
                                                                               FieldByName(TempFieldName).AsFloat))));

                  end;  {For I := 1 to 6 do}

                  {CHG08262004-1(2.8.0.9): Activate the penalty date.}
                  {5 blank interests from 2401 - 2465: not supported for now.}

                For I := 1 to 5 do
                  Write(RPS160File, ConstStr(' ', 13));

                  {6 total payment amounts, ignoring interest from 2466-2543, 13 chars each.}

                For I := 1 to 6 do
                  begin
                    TempFieldName := 'TaxPayment' + IntToStr(I);

                    Write(RPS160File, ShiftRightAddBlanks(Take(13, FormatFloat(DecimalDisplay_BlankZero,
                                                                               FieldByName(TempFieldName).AsFloat))));

                  end;  {For I := 1 to 6 do}

                  {6 Due dates 2544 - 2594, 10 chars each.}

                For I := 1 to 6 do
                  begin
                    TempFieldName := 'PayDate' + IntToStr(I);

                    If (Deblank(CollectionLookupTable.FieldByName(TempFieldName).Text) = '')
                      then TempStr := ConstStr(' ', 10)
                      else TempStr := FormatDateTime(_LongDateFormat,
                                                     CollectionLookupTable.FieldByName(TempFieldName).AsDateTime);

                    Write(RPS160File, TempStr);

                  end;  {For I := 1 to 6 do}

              end;  {else of If UsePenaltySchedule}

        {FXX08212001-1: Make sure to pass the swis code in in order to find the rate.}

      GetStateAidAmounts(GeneralRateList, FieldByName('SwisCode').Text,
                         CountyStateAid, TownStateAid,
                         SchoolStateAid, VillageStateAid);

        {CHG08072002-1: Option of whether or not to include labels such as 'SCHL'
                        in the estimated state aid column.}

      If (Roundoff(CountyStateAid, 0) > 0)
        then
          begin
            If IncludeLabelOnStateAid
              then Write(RPS160File, 'CNTY')
              else Write(RPS160File, '    ');

            Write(RPS160File, ShiftRightAddBlanks(Take(12, FormatFloat(NoDecimalDisplay_BlankZero,
                                                                       CountyStateAid))));  {2604-2619: County Aid}
          end
        else Write(RPS160File, ConstStr(' ', 16));

      If _Compare(CollectionType, VillageTaxType, coEqual)
        then TempStr := 'VILL'
        else
          If (GlblMunicipalityType = mtCity)
            then TempStr := 'CITY'
            else TempStr := 'TOWN';

      If (Roundoff(TownStateAid, 0) > 0)
        then
          begin
            If IncludeLabelOnStateAid
              then Write(RPS160File, TempStr)
              else Write(RPS160File, '    ');

            Write(RPS160File, ShiftRightAddBlanks(Take(12, FormatFloat(NoDecimalDisplay_BlankZero,
                                                                       TownStateAid))));    {2620-2635: Town Aid}
          end
        else Write(RPS160File, ConstStr(' ', 16));

      If (Roundoff(SchoolStateAid, 0) > 0)
        then
          begin
            If IncludeLabelOnStateAid
              then Write(RPS160File, 'SCHL')
              else Write(RPS160File, '    ');

            Write(RPS160File, ShiftRightAddBlanks(Take(12, FormatFloat(NoDecimalDisplay_BlankZero,
                                                                       SchoolStateAid))));  {2636-2651: School Aid}
          end
        else Write(RPS160File, ConstStr(' ', 16));

      If (Roundoff(VillageStateAid, 0) > 0)
        then
          begin
            If IncludeLabelOnStateAid
              then Write(RPS160File, 'VILL')
              else Write(RPS160File, '    ');

            Write(RPS160File, ShiftRightAddBlanks(Take(12, FormatFloat(NoDecimalDisplay_BlankZero,
                                                                       VillageStateAid)))); {2652-2667: Village Aid}
          end
        else Write(RPS160File, ConstStr(' ', 16));

      AssessedValue := FieldByName('HstdTotalVal').AsInteger +
                       FieldByName('NonhstdTotalVal').AsInteger;

      If FieldByName('ArrearsFlag').AsBoolean
        then ArrearsFlag := 'Y'
        else ArrearsFlag := ' ';

      Writeln(RPS160File, FormatRPSNumericString(FloatToStr(AssessedValue), 12, 0),  {2668-2679: Assessed value}
                          Take(1, ArrearsFlag),                                      {2680: Arrears}
                          Take(3, FieldByName('PropertyClassCode').Text),            {2681-2683: Property class code}
                          ConstStr(' ', 16),                                         {2684-2699: Filler}
                          ' ');                                                      {2700: Owner name/addr 01 rec, blank}

    end;  {with BLHeaderTaxTable do}

end;  {WriteFooter}

{=========================================================================}
Procedure CombineSDTaxes(SDTaxList : TList);

var
  I, J : Integer;

begin
  For I := (SDTaxList.Count - 1) downto 0 do
    For J := (I - 1) downto 0 do
      If ((SDTaxList[J] <> nil) and
          (SDTaxList[I] <> nil) and
          (SDistTaxPtr(SDTaxList[I])^.SDistCode =
           SDistTaxPtr(SDTaxList[J])^.SDistCode))
        then
          begin
            with SDistTaxPtr(SDTaxList[I])^ do
              begin
                CombinedDistrictRecord := True;
                SDAmount := SDAmount + SDistTaxPtr(SDTaxList[J])^.SDAmount;

              end;  {with SDistTaxPtr(SDTaxList[I])^ do}

            FreeMem(SDTaxList[J], SizeOf(SDistTaxRecord));
            SDTaxList[J] := nil;

          end;  {If ((SDTaxList[J] <> nil) and ...}

  SDTaxList.Pack;

end;  {CombineSDTaxes}

{=========================================================================}
Procedure EliminateZeroRateSDTaxes(SDTaxList : TList;
                                   SDRateList : TList);

var
  I, Index : Integer;
  TaxRate : Double;
  _Found : Boolean;

begin
  For I := (SDTaxList.Count - 1) downto 0 do
    begin
      with SDistTaxPtr(SDTaxList[I])^ do
        _Found := FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, Index);

      If _Found
        then
          begin
            If (SDistTaxPtr(SDTaxList[I])^.HomesteadCode = 'N')
              then TaxRate := SDRatePointer(SDRateList[Index])^.NonHomesteadRate
              else TaxRate := SDRatePointer(SDRateList[Index])^.HomesteadRate;

            If (Roundoff(TaxRate, 6) = 0)
              then
                begin
                  FreeMem(SDTaxList[I], SizeOf(SDistTaxRecord));
                  SDTaxList[I] := nil;
                end;

          end;  {If _Found}

    end;  {with SDistTaxPtr(SDTaxList[I])^ do}

  SDTaxList.Pack;

end;  {EliminateZeroRateSDTaxes}

{=========================================================================}
Procedure TCreateRPS160ExtractForm.ExtractIt(var RPS160File : TextFile;
                                                 SwisSBLKey : String;
                                                 RecordNumber : LongInt;
                                                 TotalPages : Integer;
                                                 TotalQuarterlyCharge : Double;
                                                 PaymentArray : PaymentRecordArrayType);

var
  SDIndex, CurrentPageNumber, NumberOfSpecialDistricts : Integer;

begin
  SDIndex := 0;
  CurrentPageNumber := 1;

    {FXX03122005-1(2.8.3.11)[2078]: This loop did not work if there were no special districts since
                                    SDIndex (0) was greater than SDTaxList.Count - 1.} 

  NumberOfSpecialDistricts := Max(0, (SDTaxList.Count - 1));

  while (SDIndex <= NumberOfSpecialDistricts) do
    begin
      Write160Header(RPS160File, SwisSBLKey, RecordNumber, CurrentPageNumber, TotalPages);

      WriteExemptions(RPS160File, SwisSBLKey, RecordNumber,
                      BLHeaderTaxTable.FieldByName('PropertyClassCode').AsString);

      WriteDetails(RPS160File, SwisSBLKey, RecordNumber, SDIndex, TotalQuarterlyCharge);

      WriteFooter(RPS160File, SwisSBLKey, RecordNumber, PaymentArray, TotalQuarterlyCharge);

      CurrentPageNumber := CurrentPageNumber + 1;

      If (SDTaxList.Count = 0)
        then SDIndex := 1;

    end;  {while (SDTaxLinesPrinted < SDTaxList) do}

end;  {ExtractIt}

{=========================================================================}
Procedure TCreateRPS160ExtractForm.ExtractOneParcel(var RPS160File : TextFile;
                                                    var RPS160MultiPageFile : TextFile;
                                                        SwisSBLKey : String;
                                                        RecordNumber : Integer);

var
  I, LinesPerPage, TotalDetails, TotalPages : Integer;
  PaymentArray : PaymentRecordArrayType;
  TempFieldName : String;
  FloorBase, FloorSC, BaseBreakage,
  SCBreakage, TotalQuarterlyCharge : Double;

begin
  TotalPages := 0;
  TotalQuarterlyCharge := 0;

  If CombineAllSDExtensions
    then CombineSDTaxes(SDTaxList);

  If not bBillZeroSDRates
    then EliminateZeroRateSDTaxes(SDTaxList, SDRateList);

  TotalDetails := GnTaxList.Count + SDTaxList.Count;

  LinesPerPage := PlacedSpecialMessageLineNumber - 1;

  If (FirstLine in [flHomesteadStatus, flSpecialMessage])
    then LinesPerPage := LinesPerPage - 1;

  If (LinesPerPage <= 0)
    then LinesPerPage := 12;

  repeat
    TotalPages := TotalPages + 1;
    TotalDetails := TotalDetails - LinesPerPage;
  until (TotalDetails <= 0);

  For I := 1 to 6 do
    with PaymentArray[I] do
      begin
        PayDate := '';
        Penalty := 0;
        BaseAmount := 0;
        TotalAmount := 0;
      end;

  If PrintQuarterlyAmounts
    then
      begin
        TotalQuarterlyCharge := 0;
        FigureQuarterlyPaymentAmounts(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat,
                                      FloorBase, FloorSC, BaseBreakage, SCBreakage);

        For I := 1 to 4 do
          with PaymentArray[I] do
            begin
              Penalty := 0;

              If (I = 1)
                then
                  begin
                    BaseAmount := FloorBase + FloorSC + BaseBreakage + SCBreakage;
                    TotalQuarterlyCharge := TotalQuarterlyCharge + FloorSC + SCBreakage;
                  end
                else
                  begin
                    BaseAmount := FloorBase + FloorSC;
                    TotalQuarterlyCharge := TotalQuarterlyCharge + FloorSC;
                  end;

              TotalAmount := BaseAmount;

              TempFieldName := 'PayDate' + IntToStr(I);
              PayDate := CollectionLookupTable.FieldByName(TempFieldName).Text;

            end;  {with PaymentArray[I] do}

      end;  {If PrintQuarterlyAmounts}

  If (CreateSeperateFileForMultiPageBills and
      (TotalPages > 1))
    then ExtractIt(RPS160MultiPageFile, SwisSBLKey, RecordNumber, TotalPages,
                   TotalQuarterlyCharge, PaymentArray)
    else ExtractIt(RPS160File, SwisSBLKey, RecordNumber, TotalPages,
                   TotalQuarterlyCharge, PaymentArray);

end;  {ExtractOneParcel}

{=========================================================================}
Procedure TCreateRPS160ExtractForm.Create160File;

var
  Quit, Cancelled, Done, FirstTimeThrough : Boolean;
  NumPrinted : LongInt;
  SwisSBLKey : String;
  RPS160File, RPS160MultiPageFile : TextFile;
  Index, I, J : Integer;
(*  ArrearsMessage : TStringList; *)

begin
  Quit := False;
  NumPrinted := 0;
  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

(*  ArrearsMessage := TStringList.Create;

  with ArrearsMemo do
    For I := 0 to (Lines.Count - 1) do
      ArrearsMessage.Add(Lines[I]);*)

    {CHG11262006-1(2.11.1.1): Allow for specification of file name for tax extract files.}

  AssignFile(RPS160File, dlg_SaveTaxExtractFile.FileName);
  Rewrite(RPS160File);
  AssignFile(RPS160MultiPageFile, dlg_SaveTaxExtractFile.FileName + '_MultiPage');
  Rewrite(RPS160MultiPageFile);

  Done := False;
  FirstTimeThrough := True;

  ProgressDialog.UserLabelCaption := 'Creating RPS 160 File.';
  BLHeaderTaxTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else BLHeaderTaxTable.Next;

    If BLHeaderTaxTable.EOF
      then Done := True;

    with BLHeaderTaxTable do
      SwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBLKey').Text;

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

    If ((not Done) and
        ParcelShouldBePrinted(BLHeaderTaxTable, SelectedSwisCodes))
      then
        begin
          NumPrinted := NumPrinted + 1;

          LoadTaxesForParcel(SwisSBLKey, BLGeneralTaxTable,
                             BLSpecialDistrictTaxTable,
                             BLExemptionTaxTable,
                             BLSpecialFeeTaxTable,
                             SDCodeDescList, EXCodeDescList,
                             GeneralRateList, SDRateList,
                             SpecialFeeRateList, GnTaxList,
                             SDTaxList, SpTaxList, ExTaxList, Quit);

            {FXX08212001-3: For split parcels, combine the homestead and non-homestead parts.}

          If ((not ListSplitGeneralTaxesSeperately) and
              (BLHeaderTaxTable.FieldByName('HomesteadCode').Text = 'S'))
            then
              begin
                Index := 0;

                  {Copy the information from the non-homestead rates into the homestead rates.}

                while (Index < (GnTaxList.Count - 1)) do
                  begin
                    For J := (Index + 1) to (GnTaxList.Count - 1) do
                      If (GeneralTaxPtr(GnTaxList[J])^.PrintOrder =
                          GeneralTaxPtr(GnTaxList[Index])^.PrintOrder)
                        then
                          begin
                            GeneralTaxPtr(GnTaxList[Index])^.TaxableVal :=
                                GeneralTaxPtr(GnTaxList[Index])^.TaxableVal +
                                GeneralTaxPtr(GnTaxList[J])^.TaxableVal;

                            GeneralTaxPtr(GnTaxList[Index])^.TaxAmount :=
                                GeneralTaxPtr(GnTaxList[Index])^.TaxAmount +
                                GeneralTaxPtr(GnTaxList[J])^.TaxAmount;

                              {FXX12212004-1(2.8.1.5): Don't show the tax rate since it is not correct.}

                            If GlblMunicipalityUsesTwoTaxRates
                              then GeneralTaxPtr(GnTaxList[Index])^.TaxRate := 0;

                          end;  {If (GeneralTaxPtr(GnTaxList[J])^.PrintOrder = ...}

                    Index := Index + 1;

                  end;  {while (Index < (GnTaxList.Count - 1)) do}

                  {Remove the second set of non-homestead rates.  They are redundant.}

                For J := (GnTaxList.Count - 1) downto (GnTaxList.Count DIV 2) do
                  begin
                    FreeMem(GnTaxList[J], SizeOf(GeneralTaxRecord));
                    GnTaxList.Delete(J);
                  end;

              end;  {If ((not ListSplitGeneralTaxesSeperately) and ...}

          fTownFee := 0;
          If (bIncludeTownFeeAmounts and
              _Compare(SPTaxList.Count, 0, coGreaterThan))
          then
            For I := 0 to (SPTaxList.Count - 1) do
            fTownFee := fTownFee + SPFeeTaxPtr(SPTaxList[0])^.SPAmount;

          ExtractOneParcel(RPS160File, RPS160MultiPageFile, SwisSBLKey, NumPrinted);

          ClearTList(GnTaxList, SizeOf(GeneralTaxRecord));
          ClearTList(SDTaxList, SizeOf(SDistTaxRecord));
          ClearTList(SpTaxList, SizeOf(SPFeeTaxRecord));
          ClearTList(ExTaxList, SizeOf(ExemptTaxRecord));

        end;  {If ((not Done) and ...}

    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled);

  CloseFile(RPS160File);
  CloseFile(RPS160MultiPageFile);

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

(*  ArrearsMessage.Free; *)

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TCreateRPS160ExtractForm.LoadButtonClick(Sender: TObject);

begin
  LoadReportOptions(Self, OpenDialog, 'Laser_Bill_Extract.ext', '160 Laser Bill Extract');
end;

{===============================================================}
Procedure TCreateRPS160ExtractForm.SaveButtonClick(Sender: TObject);

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Laser_Bill_Extract.ext', '160 Laser Bill Extract');
end;

{===============================================================}
Procedure TCreateRPS160ExtractForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TCreateRPS160ExtractForm.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

  If (SelectedSwisCodes <> nil)
    then SelectedSwisCodes.Free;

  If (SelectedSchoolCodes <> nil)
    then SelectedSchoolCodes.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
