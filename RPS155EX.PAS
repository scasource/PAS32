unit RPS155EX;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  Types, (*Progress,*) Zipcopy;

const
  RPS155ExtractRecordLength = 910;

type
  SDRateRecord = record
    RateNumber : Integer;
    SDCode : String;
    Extension : String;
    CC_OMFlag : String;
    Rate : Extended;
    HomesteadCode : String;
    BillPrintGroup : String;
    BillPrintGroupOrder : Integer;

  end;  {SDRateRecord = record}

  PSDRateRecord = ^SDRateRecord;

  EXRateRecord = record
    RateNumber : Integer;
    EXCode : String;
  end;  {EXRateRecord = record}

  PEXRateRecord = ^EXRateRecord;

  GeneralRateRecord = record
    RateNumber,
    PrintOrder : Integer;
    SwisCode : String;
    RateType : Char;  {(G)eneral or special (F)ee}
    BillPrintGroup : String;
    BillPrintGroupOrder : Integer;
  end;  {GeneralRateRecord = record}

  PGeneralRateRecord = ^GeneralRateRecord;


  RPS155ExtractRec = Array[1..RPS155ExtractRecordLength] of Char;

  StrException = class(Exception);

type
  TRPS155FileExtractForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    label16: TLabel;
    Label18: TLabel;
    Label1: TLabel;
    LookupCollectionType: TwwDBLookupCombo;
    EditCollectionNumber: TEdit;
    EditTaxRollYear: TEdit;
    BillCollTypeLookupTable: TwwTable;
    SDCodeTable: TTable;
    EXCodeTable: TTable;
    BillControlTable: TTable;
    BillGeneralRateTable: TTable;
    BillSDRateTable: TTable;
    SwisTable: TTable;
    BLExemptionTaxTable: TTable;
    BLSpecialDistrictTaxTable: TTable;
    BLGeneralTaxTable: TTable;
    BLHeaderTaxTable: TTable;
    BillCollTypeLookupTableMainCode: TStringField;
    BillCollTypeLookupTableDescription: TStringField;
    BillSpecialFeeRateTable: TTable;
    BLSpecialFeeTaxTable: TTable;
    SDExtensionCodeTable: TTable;
    SchoolExtractOrderRadioGroup: TRadioGroup;
    TYParcelTable: TTable;
    SchoolTable: TTable;
    ZipCopyDlg: TZipCopyDlg;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    IncludeRemappedParcelIDCheckBox: TCheckBox;
    EditSDRateOffset: TEdit;
    IncludeAdditionalLotsCheckBox: TCheckBox;
    NoAddressInformationInSecondLineCheckBox: TCheckBox;
    ForceCityStateZipToLastLineCheckBox: TCheckBox;
    Label4: TLabel;
    dlg_SaveTaxExtractFile: TSaveDialog;
    dlg_SaveBillRateExtractFile: TSaveDialog;
    cb_OnlyIncludeNonZeroBills: TCheckBox;
    cbxExcludeUnbilledDistricts: TCheckBox;
    cbxBreakOutDistrictsByExtension: TCheckBox;
    cbxIncludeBillPrintGroupInformation: TCheckBox;
    cbxFullSwisIn147: TCheckBox;
    tbTaxBillNameAddress: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure LookupCollectionTypeChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ExtractCancelled : Boolean;
    CollectionNum : Integer;
    CollectionType : String;
    TaxRollYear : String;
    IncludeRemappedParcelID, bFullSwisIn147 : Boolean;

      {These are the tables that will be needed for the extract.}

    SalesTable,
    ThisYearParcelTable, NextYearParcelTable,
    ThisYearAssessmentTable, NextYearAssessmentTable,
    ThisYearSDTable, NextYearSDTable,
    ThisYearEXTable, NextYearEXTable,
    ComSiteTable, ComBldgTable, ComRentTable,
    ComLandTable, ComImprovementTable, ComIncExpTable,
    ResSiteTable, ResBldgTable,
    ResLandTable, ResImprovementTable, ResForestTable : TTable;
    SDRateList, EXRateList, GeneralRateList : TList;
    SDRateOffset : Integer;
    IncludeAdditionalLots,
    NoAddressInformationOnSecondLine,
    ForceCityStateZipToLastLine,
    OnlyIncludeNonZeroBills : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure AddSDRateToList(    SDRateList : TList;
                                  PSDRateRec : PSDRateRecord;
                              var RateNum : Integer;
                                  _SDCode : String;
                                  _ExtensionType : String;
                                  _CCOMFlag : String;
                                  _Rate : Extended;
                                  _HomesteadCode : String;
                                  _BillPrintGroup : String;
                                  _BillPrintGroupOrder : Integer);
   {Add an SD rate to the list from the present SD rate pointed to in the SD
    rate table.}

    Procedure Create147ExtractFile(    _147FileName : String;
                                       TaxRollYear : String;
                                       CollectionType : String;
                                       CollectionNum : Integer;
                                   var Quit : Boolean);

    Procedure OpenBillingFiles(    TaxRollYear : String;
                                   CollectionType : String;
                                   CollectionNum : Integer;
                               var Quit : Boolean);

    Procedure Add155ExtensionRecHeader(var Line : RPS155ExtractRec;
                                           SwisSBLKey : String;
                                           RecNumber : Integer);
    {Add the header information to the front of a 155 extension (02, ...) record.}

    Function FindGeneralRate(RateType : Char;  {(G)eneral, Spcl (F)ee}
                             PrintOrder : Integer;
                             SwisCode : String) : Integer;
    {Given the rate type and print order, return the rate number in the 147 file.}

    Function FindSDCodeRate(SDCode : String;
                            Extension : String;
                            CC_OMFlag,
                            HomesteadCode : String) : Integer;
    {Given the SD code, extension code, CC_OM flag, and homestead code
     find the rate number in the SD rate list.}

    Procedure AddExtension(var Line : RPS155ExtractRec;
                               ExtensionType : String;  {(G)eneral, Special (F)ee, Spcl (D)ist}
                               PurposePointer : Integer;
                               DesignationCode : String; {(H)std, (N)onhstd, (F)ee, Spcl (D)ist, ' '}
                               SDExtensionDesc,
                               AssessedValue,
                               TaxableValue,
                               TaxAmount : String);
    {Add all the extension information to a 155 extension (02, ...) record.}

    Procedure AddAmountDue(var Line : RPS155ExtractRec;
                               PaymentNumber : Integer);
    {Add the information to a 155 extension record (02, 03, ...)
     for a single payment - amount due, date due, and penalty %.}

    Procedure Add155ExtensionRecFooter(var Line : RPS155ExtractRec;
                                           SwisSBLKey : String;
                                           SpecialCharges : Extended);
   {Add the footer information to the end of a 155 extension (02, ...) record.}

    Procedure ExtractOneParcelFor155File(var RPS155File : TextFile;
                                         var RPS155D9File : TextFile;
                                         var TotalTax,
                                             TotalSpecialDistricts,
                                             TotalExemptions,
                                             TotalSpecialFees : Extended;
                                         var Quit : Boolean);
    {Extract all the information for one parcel including parcel information,
    taxes, special districts and exemptions.}

    Procedure Create155ExtractFile(var TotalTax,
                                       TotalSpecialDistricts,
                                       TotalExemptions,
                                       TotalSpecialFees : Extended;
                                       _155D1FileName : String;
                                   var _155D9FileName : String;
                                   var Quit : Boolean);
    Function FindSDPurpPtr(SDCode : String) : Integer;  {FXX12121998-1}
    Function ProrataParcelBilledThisCycle(BLHeaderTaxTable : TTable;
                                          SwisSBLKey : String) : Boolean;


  end;


implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst, PASTypes,
     Prog, DataAccessUnit, UtilBill;  {Billing specific routines}

const
  TrialRun = False;

{$R *.DFM}

{========================================================}
Procedure TRPS155FileExtractForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TRPS155FileExtractForm.InitializeForm;

var
  Quit : Boolean;

begin
  ExtractCancelled := False;
  UnitName := 'RPS155EX';

  try
    dlg_SaveBillRateExtractFile.InitialDir := GlblDrive + ':' + GlblExportDir;
  except
  end;

  OpenTablesForForm(Self, GlblProcessingType);

  GeneralRateList := TList.Create;
  EXRateList := TList.Create;
  SDRateList := TList.Create;
  EditTaxRollYear.Text := GlblThisYear;

    {FXX08212002-1: Make sure to make the remapped parcel ID option
                    visible if they use remapped IDs.}

  If GlblLocateByOldParcelID
    then
      begin
        IncludeRemappedParcelIDCheckBox.Visible := True;
        IncludeRemappedParcelIDCheckBox.Checked := True;
      end;

    {CHG05192003-2(2.07b): Include additional lots in the 155 for Lawrence.}

  If GlblExtractAdditionalLotsIn155File
    then
      begin
        IncludeAdditionalLotsCheckBox.Visible := True;
        IncludeAdditionalLotsCheckBox.Checked := True;
      end;

  If glblUsesTaxBillNameAddr
  then OpenTableForProcessingType(tbTaxBillNameAddress, TaxBillAddressTableName, NextYear, Quit);

end;  {InitializeForm}

{===================================================================}
Procedure TRPS155FileExtractForm.FormKeyPress(    Sender: TObject;
                                              var Key: Char);

{FXX05111998-6: Add enter to tab.}

begin
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
Procedure TRPS155FileExtractForm.LookupCollectionTypeChange(Sender: TObject);

{If this is a school collection type, let them select the order of printing.}

begin
  If (LookupCollectionType.Text = 'SC')
    then SchoolExtractOrderRadioGroup.Visible := True
    else SchoolExtractOrderRadioGroup.Visible := False;

end;  {LookupCollectionTypeChange}

{===================================================================}
{===================  147 File Extract Routines =====================}
{===================================================================}
Procedure TRPS155FileExtractForm.AddSDRateToList(    SDRateList : TList;
                                                     PSDRateRec : PSDRateRecord;
                                                 var RateNum : Integer;
                                                     _SDCode : String;
                                                     _ExtensionType : String;
                                                     _CCOMFlag : String;
                                                     _Rate : Extended;
                                                     _HomesteadCode : String;
                                                     _BillPrintGroup : String;
                                                     _BillPrintGroupOrder : Integer);


{Add an SD rate to the list from the present SD rate pointed to in the SD
 rate table.}

begin
  with BillSDRateTable do
    with PSDRateRec^ do
      begin
        RateNumber := RateNum;
        SDCode := Take(5, _SDCode);
        Extension := Take(2, _ExtensionType);
        CC_OMFlag := Take(1, _CCOMFlag);
        Rate := _Rate;
        HomesteadCode := Take(1, _HomesteadCode);
        BillPrintGroup := _BillPrintGroup;
        BillPrintGroupOrder := _BillPrintGroupOrder;

      end;  {with PSDRateRec^ do}

  SDRateList.Add(PSDRateRec);

  RateNum := RateNum + 1;

end;  {AddSDRateToList}

{======================================================================}
Function CreateType2Record(SDCodeTable : TTable;
                           SwisTable : TTable;
                           BillSDRateTable : TTable;
                           _Found : Boolean;
                           SDNum : Integer;
                           StartRateNum : Integer;
                           EndRateNum : Integer;
                           CurrentTaxLevy : Comp;
                           PriorTaxLevy : Comp;
                           bFullSwisIn147 : Boolean) : String;

var
  TaxLevyPercentChange : Double;
  TempDesc : String;

begin
  Result := '';
  with SDCodeTable do
    begin
      If bFullSwisIn147
      then Result := Result + SwisTable.FieldByName('SwisCode').Text
      else Result := Result + Copy(SwisTable.FieldByName('SwisCode').Text, 1, 4) + '  ';  {1-6: Municipal code}
      Result := Result + '2';  {7: Record type}
      Result := Result + ShiftRightAddZeroes(Take(4, IntToStr(SDNum)));  {8-11: Key}
      Result := Result + Take(11, '');  {12-22: Filler}
      Result := Result + Take(5, FieldByName('SDistCode').Text);  {23-27: SD code}

        {FXX12011999-6: Use the description from the sd rate file.}
        {FXX11062001-2: If this SD is not in the rate file, get the
                        description from the code file.}

      If _Found
        then TempDesc := BillSDRateTable.FieldByName('SdistDescr').Text
        else TempDesc := SDCodeTable.FieldByName('Description').Text;

      Result := Result + Take(20, TempDesc);  {28-47: Description}
      Result := Result + Take(1, FieldByName('DistrictType').Text);  {48: District type}
      Result := Result + BoolToChar(FieldByName('Section490').AsBoolean);  {49: Section 490?}
      Result := Result + BoolToChar(FieldByName('Chapter562').AsBoolean);  {50: Chapter 562?}
      Result := Result + ShiftRightAddZeroes(Take(3, IntToStr(StartRateNum))); {51-53: Start pointer}
      Result := Result + ShiftRightAddZeroes(Take(3, IntToStr(EndRateNum))); {54-56: End pointer}
      Result := Result + Take(1, FieldByName('SDHomestead').Text);  {57: Homestead?}
      Result := Result + BoolToChar(FieldByName('SDRs9').AsBoolean);  {58: Does it apply to RS 9?}
      Result := Result + Take(1, FieldByName('VillagePurpose').Text);  {59: Village purpose}
      Result := Result + BoolToChar(FieldByName('AppliesToSchool').AsBoolean);  {60: School flag}

        {FXX03291999-1: Not printing current levy for districts with many extensions.}

      Result := Result + FormatRPSNumericString(FloatToStr(CurrentTaxLevy), 15, 0);  {61-75}
      TaxLevyPercentChange := ComputeTaxLevyPercentChange(CurrentTaxLevy, PriorTaxLevy);
      Result := Result + FormatRPSNumericString(FloatToStr(TaxLevyPercentChange),
                                            5, 2); {76-80}

      Result := Result + Take(20, '');  {Filler, skip school SD flag}

    end;  {with SDCodeTable do}

end;  {}

{===================================================================}
Procedure TRPS155FileExtractForm.Create147ExtractFile(    _147FileName : String;
                                                          TaxRollYear : String;
                                                          CollectionType : String;
                                                          CollectionNum : Integer;
                                                      var Quit : Boolean);

var
  _Found, FirstTimeThrough, Done,
  bSupressUnbilledDistricts, bDistrictBilled,
  bBreakOutDistrictsByExtension, bIncludeBillPrintGroupInformation : Boolean;
  RPS147File : TextFile;
  Line : String;
  I, J, SDNum, RateNum, EXNum, NumRecs,
  NumRates, StartRateNum, EndRateNum, iBillPrintGroupOrder : Integer;
  PSDRateRec : PSDRateRecord;
  PEXRateRec : PEXRateRecord;
  PGeneralRateRec : PGeneralRateRecord;
  TempStr, CCOMTempStr, TempDesc, sTaxType, sFieldName : String;
  TaxLevyPercentChange : Double;
  CurrentTaxLevy, PriorTaxLevy : Comp;

begin
  NumRecs := 0;
  _Found := False;
  bSupressUnbilledDistricts := cbxExcludeUnbilledDistricts.Checked;
  bBreakOutDistrictsByExtension := cbxBreakOutDistrictsByExtension.Checked;
  bIncludeBillPrintGroupInformation := cbxIncludeBillPrintGroupInformation.Checked;

    {CHG11262006-1(2.11.1.1): Allow for specification of file name for tax extract files.}

  AssignFile(RPS147File, _147FileName);
  Rewrite(RPS147File);

    {CHG08212009-1(2.20.1.16)[999]:  Add the type 0 record.}

  SwisTable.Last;

  If bFullSwisIn147
  then Line := SwisTable.FieldByName('SwisCode').AsString  {1-6: Municipal code}
  else Line := Copy(SwisTable.FieldByName('SwisCode').Text, 1, 4) + '  ';  {1-6: Municipal code}

  Line := Line + '0';  {7: Record type}
  Line := Line + '0001'; {8-11: Key}
  Line := Line + ConstStr(' ', 11);  {12-22: Filler}
  Line := Line + 'A';  {23: Control ID}
  Line := Line + '00000'; {24-28: Starting page #}
  Line := Line + '99999';  {29-33: Ending page #}
  Line := Line + ' '; {34: Totals break override}
  Line := Line + '1';  {35: RSS Totals option}
  Line := Line + '01';  {36-37: Tax bill sequence}
  Line := Line + '1';  {38: Payment interest option}
  Line := Line + ' ';  {39: Penalty option}

  with BillControlTable do
    begin
      Line := Line + FieldByName('NumberOfPayments').AsString;  {40: # of payments}

      For I := 1 to 4 do
        begin
          sFieldName := 'PayDate' + IntToStr(I);
          Line := Line + MakeMMDDYY(FieldByName(sFieldName).AsDateTime);
          sFieldName := 'PenPercent' + IntToStr(I);
          Line := Line + FormatRPSNumericString(FormatFloat(DecimalDisplay, FieldByName(sFieldName).AsFloat),
                                                3, 0);

        end;  {For I := 1 to 4 do}

    end;  { with BillControlTable do}

  Line := Line + ConstStr('0', 12);  {77-88: Additional interest fields}
  Line := Line + ConstStr(' ', 12);  {89-100: Rest of line}

  Writeln(RPS147File, Line);
  
    {First write out the general tax rates.}

  SetRangeOld(BillGeneralRateTable,
              ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
              [TaxRollYear, CollectionType, IntToStr(CollectionNum), '0'],
              [TaxRollYear, CollectionType, IntToStr(CollectionNum), '32000']);

  FirstTimeThrough := True;
  Done := False;
  RateNum := 1;

  BillGeneralRateTable.First;

  repeat
    Application.ProcessMessages;

    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          BillGeneralRateTable.Next;
        except
          Quit := True;
          SystemSupport(001, BillGeneralRateTable, 'Error getting general rate record.',
                        UnitName, GlblErrorDlgBox);
        end;

    If (BillGeneralRateTable.EOF or
        (BillGeneralRateTable.FieldByName('CollectionNo').AsInteger <> CollectionNum))
      then Done := True;

    If not (Done or Quit)
      then
        begin
          with BillGeneralRateTable do
            begin
              Line := '';

              If bFullSwisIn147
              then Line := SwisTable.FieldByName('SwisCode').AsString {1-6: Municipal code}
              else Line := Copy(SwisTable.FieldByName('SwisCode').Text, 1, 4) + '  ';  {1-6: Municipal code}

              Line := Line + '1';  {7: Record type}

                {FXX12171998-3: Make field after general tax type a count of the rates
                                so far instead of the print order.}

              Line := Line + Take(2, FieldByName('GeneralTaxType').Text) +
                             ShiftRightAddZeroes(Take(2, IntToStr(RateNum)));  {8-11: Key}
              Line := Line + Take(11, '');  {12-22: Filler}

                {FXX05132009-4(2.20.1.1): Add the tax type indicator.}

              sTaxType := ' ';

              If _Compare(FieldByName('GeneralTaxType').AsString, CountyTaxType, coEqual)
                then sTaxType := '1';

              If _Compare(FieldByName('GeneralTaxType').AsString, [TownTaxType, VillageTaxType, MunicipalTaxType], coEqual)
                then sTaxType := '2';

              If _Compare(FieldByName('GeneralTaxType').AsString, SchoolTaxType, coEqual)
                then sTaxType := '3';

              Line := Line + sTaxType;
              Line := Line + ShiftRightAddZeroes(Take(2, IntToStr(RateNum)));
              (* Line := Line + Take(2, '');  {24-25: Skip} *)
              Line := Line + Take(6, FieldByName('SwisCode').Text); {26-31: Swis code}
              Line := Line + Take(6, FieldByName('SchoolCode').Text);  {32-37: School code}
              Line := Line + Take(20, FieldByName('Description').Text);  {38-57: Description}
              Line := Line + FormatRPSNumericString(FieldByName('HomesteadRate').Text,
                                                    10, 6);  {58-67: Rate #1}
              Line := Line + 'H'; {68: Previous rate is homestead}

                 {FXX11191999-12: If a munic does not have dual rates, put
                                  the hstd rate in non-hstd.}

              If GlblMunicipalityUsesTwoTaxRates
                then TempStr := FormatRPSNumericString(FieldByName('NonhomesteadRate').Text, 10, 6)
                else TempStr := FormatRPSNumericString(FieldByName('HomesteadRate').Text, 10, 6);

                {FXX12131999-1: Not printing the second rate.}

              Line := Line + TempStr; {69-78: Rate #2}

              Line := Line + 'N'; {79: Previous rate is nonhomestead}
              Line := Line + 'N'; {80: No county resolution}
              Line := Line + 'Y'; {81: STAR applies}
              Line := Line + FormatRPSNumericString(FieldByName('CurrentTaxLevy').Text,
                                                    15, 0);  {82-96}
              TaxLevyPercentChange := ComputeTaxLevyPercentChange(FieldByName('CurrentTaxLevy').AsFloat,
                                                                  FieldByName('PriorTaxLevy').AsFloat);
              Line := Line + FormatRPSNumericString(FloatToStr(TaxLevyPercentChange),
                                                    5, 2); {97-101}

                {CHG12072009-1(2.22.1.1)[I6784]: Bill changes for Ramapo.}

              If bIncludeBillPrintGroupInformation
                then
                begin
                  Line := Line + Take(5, FieldByName('BillPrintGroup').AsString);  {102-106}
                  try
                    Line := Line + ShiftRightAddZeroes(FieldByName('BillPrintGroupOrder').AsString, 3);  {107-109}
                  except
                    Line := Line + '   ';
                  end;
                end;

                {Create an entry in the rate list for this type.}

              New(PGeneralRateRec);

              with PGeneralRateRec^ do
                begin
                  PrintOrder := FieldByName('PrintOrder').AsInteger;
                  RateType := 'G';  {General}
                  RateNumber := RateNum;

                    {FXX03122002-1: Need to include the swis code in the
                                    rate record to distinguish between
                                    rates with same print order.}

                  SwisCode := FieldByName('SwisCode').Text;

                end;  {with PGeneralRateRec^ do}

              GeneralRateList.Add(PGeneralRateRec);

            end;  {with BillGeneralRateTable do}

            RateNum := RateNum + 1;

            Writeln(RPS147File, Line);

          end;  {If not (Done or Quit)}

(*    ExtractCancelled := ProgressDialog.Cancelled;*)

  until (Done or Quit or ExtractCancelled);

    {Now continue the general rates (type '1' records) with the
     special fees. Note that we are going to put any fixed amount
     in rate #1 and any percentage in the rate #2 field.
     There is no special record type for special fees, so we will
     put these rates on the same list as the general taxes.}

  SetRangeOld(BillSpecialFeeRateTable,
              ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
              [TaxRollYear, CollectionType, IntToStr(CollectionNum), '0'],
              [TaxRollYear, CollectionType, IntToStr(CollectionNum), '32000']);

  FirstTimeThrough := True;
  Done := False;

  BillSpecialFeeRateTable.First;

  repeat
    Application.ProcessMessages;

    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          BillSpecialFeeRateTable.Next;
        except
          Quit := True;
          SystemSupport(001, BillSpecialFeeRateTable, 'Error getting SpecialFee rate record.',
                        UnitName, GlblErrorDlgBox);
        end;

    If (BillSpecialFeeRateTable.EOF or
        (BillSpecialFeeRateTable.FieldByName('CollectionNo').AsInteger <> CollectionNum))
      then Done := True;

    If not (Done or Quit)
      then
        begin
          with BillSpecialFeeRateTable do
            begin
              Line := '';
              If bFullSwisIn147
              then Line := SwisTable.FieldByName('SwisCode').AsString  {1-6: Municipal code}
              else Line := Copy(SwisTable.FieldByName('SwisCode').Text, 1, 4) + '  ';  {1-6: Municipal code}

              Line := Line + '1';  {7: Record type}
              Line := Line + ShiftRightAddZeroes(Take(2, FieldByName('PrintOrder').Text)) +
                             ShiftRightAddZeroes(Take(2, IntToStr(RateNum)));  {8-11: Key}
              Line := Line + Take(11, '');  {12-22: Filler}
              Line := Line + Take(3, '');  {23-25: Skip}
              Line := Line + Take(6, ''); {26-31: Skip}
              Line := Line + Take(6, '');  {32-37: Skip}
              Line := Line + Take(20, FieldByName('Description').Text);  {38-57: Description}
              Line := Line + FormatRPSNumericString(FieldByName('FixedAmount').Text,
                                                    10, 6);  {58-67: FixedAmount}
              Line := Line + 'F'; {68: Previous rate is fixed special fee}
              Line := Line + FormatRPSNumericString(FieldByName('Percentage').Text,
                                                    10, 6);  {69-78: Percentage}
              Line := Line + 'P'; {79: Previous rate is percentage special fee}
              Line := Line + Take(21, '');  {80-100: Skip the rest.}

                {Create an entry in the rate list for this type.}

              New(PGeneralRateRec);

              with PGeneralRateRec^ do
                begin
                  PrintOrder := FieldByName('PrintOrder').AsInteger;
                  RateType := 'F';  {Special fee.}
                  RateNumber := RateNum;
                end;

              GeneralRateList.Add(PGeneralRateRec);

            end;  {with BillSpecialFeeRateTable do}

            RateNum := RateNum + 1;

            Writeln(RPS147File, Line);

          end;  {If not (Done or Quit)}

(*    ExtractCancelled := ProgressDialog.Cancelled;*)

  until (Done or Quit or ExtractCancelled);

    {Now do the SD codes and put the rates in a TList.}

  If not (Quit or ExtractCancelled)
    then
      begin
        FirstTimeThrough := True;
        Done := False;

         {CHG12232002-1: Allow for SD rate pointers to start at different offsets.}
        RateNum := SDRateOffset + 1;
        SDNum := SDRateOffset + 1;
        SDRateList := TList.Create;

        SDCodeTable.First;

        Line := '';

        repeat
          Application.ProcessMessages;

          If FirstTimeThrough
            then FirstTimeThrough := False
            else SDCodeTable.Next;

          If SDCodeTable.EOF
            then Done := True;

            {For each special district in the special district file,
             we will look up each extension in the rate file and add a
             rate to the SDRateList for each.}

          If not (Done or Quit)
            then
              begin
                CurrentTaxLevy := 0;
                PriorTaxLevy := 0;

                  {First create the entries in the rate list for
                   this special district.}

                StartRateNum := RateNum;
                bDistrictBilled := False;

                with SDCodeTable do
                  For I := 1 to 10 do
                    begin
                      TempStr := 'ECd' + IntToStr(I);
                      CCOMTempStr := 'ECFlg' + IntToStr(I);

                        {If the extension code is filled in, then
                         look it up in the rate file and create a rate record.}

                      If _Compare(FieldByName(TempStr).Text, coNotBlank)
                        then
                          begin
                            _Locate(BillSDRateTable,
                                    [TaxRollYear, CollectionType,
                                     IntToStr(CollectionNum),
                                     FieldByName('SDistCode').Text,
                                     FieldByName(TempStr).Text,
                                     FieldByName(CCOMTempStr).Text], '', [loPartialKey]);

                            _Found := (_Compare(BillSDRateTable.FieldByName('TaxRollYr').AsString, TaxRollYear, coEqual) and
                                       _Compare(BillSDRateTable.FieldByName('CollectionType').AsString, CollectionType, coEqual) and
                                       _Compare(BillSDRateTable.FieldByName('CollectionNo').AsInteger, CollectionNum, coEqual) and
                                       _Compare(BillSDRateTable.FieldByName('SDistCode').AsString, SDCodeTable.FieldByName('SDistCode').AsString, coEqual) and
                                       _Compare(BillSDRateTable.FieldByName('ExtCode').AsString, SDCodeTable.FieldByName(TempStr).AsString, coEqual) and
                                       _Compare(BillSDRateTable.FieldByName('CMFlag').AsString, SDCodeTable.FieldByName(CCOMTempStr).AsString, coEqual));

                              {Here is some bad programming, because, frankly, dBase sucks!}

                            If not _Found
                              then
                                begin
                                    {Try the previous record if for no good reason, dBase fails to locate the
                                     record and ends up 1 past.}

                                  BillSDRateTable.Prior;

                                  _Found := (_Compare(BillSDRateTable.FieldByName('TaxRollYr').AsString, TaxRollYear, coEqual) and
                                             _Compare(BillSDRateTable.FieldByName('CollectionType').AsString, CollectionType, coEqual) and
                                             _Compare(BillSDRateTable.FieldByName('CollectionNo').AsInteger, CollectionNum, coEqual) and
                                             _Compare(BillSDRateTable.FieldByName('SDistCode').AsString, SDCodeTable.FieldByName('SDistCode').AsString, coEqual) and
                                             _Compare(BillSDRateTable.FieldByName('ExtCode').AsString, SDCodeTable.FieldByName(TempStr).AsString, coEqual) and
                                             _Compare(BillSDRateTable.FieldByName('CMFlag').AsString, SDCodeTable.FieldByName(CCOMTempStr).AsString, coEqual));

                                end;  {If not _Found}

                              {Create an SD rate record which we will later
                               write to file.}
                              {FXX05061998-2: Allocating too many pointers.}

                            try
                              iBillPrintGroupOrder := BillSDRateTable.FieldByName('BillPrintGroupOrder').AsInteger;
                            except
                              iBillPrintGroupOrder := 0;
                            end;

                            If not Quit
                              then
                                If _Found
                                  then
                                    begin
                                        {FXX03291999-1: Not printing current levy for districts with many extensions.}

                                      If (Roundoff(BillSDRateTable.FieldByName('CurrentTaxLevy').AsFloat, 0) >
                                          Roundoff(CurrentTaxLevy, 0))
                                        then CurrentTaxLevy := BillSDRateTable.FieldByName('CurrentTaxLevy').AsFloat;

                                      If (Roundoff(BillSDRateTable.FieldByName('PriorTaxLevy').AsFloat, 0) >
                                          Roundoff(PriorTaxLevy, 0))
                                        then PriorTaxLevy := BillSDRateTable.FieldByName('PriorTaxLevy').AsFloat;

                                      If (Roundoff(BillSDRateTable.FieldByName('HomesteadRate').AsFloat, 6) > 0)
                                        then
                                          begin
                                            bDistrictBilled := True;
                                            New(PSDRateRec);
                                            AddSDRateToList(SDRateList,
                                                            PSDRateRec,
                                                            RateNum,
                                                            FieldByName('SDistCode').Text,
                                                            FieldByName(TempStr).Text,
                                                            FieldByName(CCOMTempStr).Text,
                                                            BillSDRateTable.FieldByName('HomesteadRate').AsFloat,
                                                            'H',
                                                            BillSDRateTable.FieldByName('BillPrintGroup').AsString,
                                                            iBillPrintGroupOrder);

                                          end {If (Roundoff(BillSDRateTable...}
                                        else
                                          If (BillSDRateTable.FieldByName('SDistCode').Text = 'PS005')
                                            then
                                              begin
                                                New(PSDRateRec);
                                                AddSDRateToList(SDRateList,
                                                                PSDRateRec,
                                                                RateNum,
                                                                FieldByName('SDistCode').Text,
                                                                FieldByName(TempStr).Text,
                                                                FieldByName(CCOMTempStr).Text,
                                                                1,
                                                                'H',
                                                                BillSDRateTable.FieldByName('BillPrintGroup').AsString,
                                                                iBillPrintGroupOrder);

                                              end;  {else of If (Roundoff(BillSDRateTable.FieldByName('HomesteadRate').AsFloat, 6) > 0)}

                                      If (Roundoff(BillSDRateTable.FieldByName('NonhomesteadRate').AsFloat, 6) > 0)
                                        then
                                          begin
                                            New(PSDRateRec);
                                            bDistrictBilled := True;
                                            AddSDRateToList(SDRateList,
                                                             PSDRateRec,
                                                             RateNum,
                                                             FieldByName('SDistCode').Text,
                                                             FieldByName(TempStr).Text,
                                                             FieldByName(CCOMTempStr).Text,
                                                             BillSDRateTable.FieldByName('NonhomesteadRate').AsFloat,
                                                             'N',
                                                             BillSDRateTable.FieldByName('BillPrintGroup').AsString,
                                                             iBillPrintGroupOrder);

                                          end;

                                         {FXX05071998-3: Put in a zero rate for zero rate dists.}
                                         {CHG08212009-2(2.20.1.16)[F1000]: Option to suppress unbilled districts.}

                                      If ((not bSupressUnbilledDistricts) and
                                          ((Roundoff(BillSDRateTable.FieldByName('HomesteadRate').AsFloat, 6) = 0) and
                                           (Roundoff(BillSDRateTable.FieldByName('NonhomesteadRate').AsFloat, 6) = 0)))
                                        then
                                          begin
                                            bDistrictBilled := True;
                                            New(PSDRateRec);
                                            AddSDRateToList(SDRateList,
                                                            PSDRateRec,
                                                            RateNum,
                                                            FieldByName('SDistCode').Text,
                                                            FieldByName(TempStr).Text,
                                                            FieldByName(CCOMTempStr).Text,
                                                            0, ' ',
                                                            BillSDRateTable.FieldByName('BillPrintGroup').AsString,
                                                            iBillPrintGroupOrder);

                                          end; {If (Roundoff(BillSDRateTable...}


                                    end
                                  else
                                    If not bSupressUnbilledDistricts
                                      then
                                        begin
                                          bDistrictBilled := True;
                                          New(PSDRateRec);
                                          AddSDRateToList(SDRateList,
                                                           PSDRateRec,
                                                           RateNum,
                                                           FieldByName('SDistCode').Text,
                                                           FieldByName(TempStr).Text,
                                                           FieldByName(CCOMTempStr).Text,
                                                           0, 'H',
                                                           BillSDRateTable.FieldByName('BillPrintGroup').AsString,
                                                           iBillPrintGroupOrder);
                                        end;

                          end;  {If _Compare(FieldByName(TempStr).Text, coNotBlank)}

                    end;  {For I := 1 to 10 do}

                EndRateNum := RateNum - 1;

                Line := '';

                If ((not bSupressUnbilledDistricts) or
                    bDistrictBilled)
                  then
                  begin
                    If bBreakOutDistrictsByExtension
                    then
                      with SDCodeTable do
                        For J := StartRateNum to EndRateNum do
                          begin
                            I := (J - StartRateNum) + 1;
                            TempStr := 'ECd' + IntToStr(I);
                            CCOMTempStr := 'ECFlg' + IntToStr(I);

                              {If the extension code is filled in, then
                               look it up in the rate file and create a rate record.}

                            If _Compare(FieldByName(TempStr).Text, coNotBlank)
                              then
                                begin
                                  _Locate(BillSDRateTable,
                                          [TaxRollYear, CollectionType,
                                           IntToStr(CollectionNum),
                                           FieldByName('SDistCode').Text,
                                           FieldByName(TempStr).Text,
                                           FieldByName(CCOMTempStr).Text], '', [loPartialKey]);

                                  _Found := (_Compare(BillSDRateTable.FieldByName('TaxRollYr').AsString, TaxRollYear, coEqual) and
                                             _Compare(BillSDRateTable.FieldByName('CollectionType').AsString, CollectionType, coEqual) and
                                             _Compare(BillSDRateTable.FieldByName('CollectionNo').AsInteger, CollectionNum, coEqual) and
                                             _Compare(BillSDRateTable.FieldByName('SDistCode').AsString, SDCodeTable.FieldByName('SDistCode').AsString, coEqual) and
                                             _Compare(BillSDRateTable.FieldByName('ExtCode').AsString, SDCodeTable.FieldByName(TempStr).AsString, coEqual) and
                                             _Compare(BillSDRateTable.FieldByName('CMFlag').AsString, SDCodeTable.FieldByName(CCOMTempStr).AsString, coEqual));

                                    {Here is some bad programming, because, frankly, dBase sucks!}

                                  If not _Found
                                    then
                                      begin
                                          {Try the previous record if for no good reason, dBase fails to locate the
                                           record and ends up 1 past.}

                                        BillSDRateTable.Prior;

                                        _Found := (_Compare(BillSDRateTable.FieldByName('TaxRollYr').AsString, TaxRollYear, coEqual) and
                                                   _Compare(BillSDRateTable.FieldByName('CollectionType').AsString, CollectionType, coEqual) and
                                                   _Compare(BillSDRateTable.FieldByName('CollectionNo').AsInteger, CollectionNum, coEqual) and
                                                   _Compare(BillSDRateTable.FieldByName('SDistCode').AsString, SDCodeTable.FieldByName('SDistCode').AsString, coEqual) and
                                                   _Compare(BillSDRateTable.FieldByName('ExtCode').AsString, SDCodeTable.FieldByName(TempStr).AsString, coEqual) and
                                                   _Compare(BillSDRateTable.FieldByName('CMFlag').AsString, SDCodeTable.FieldByName(CCOMTempStr).AsString, coEqual));

                                      end;  {If not _Found}

                            Line := CreateType2Record(SDCodeTable, SwisTable, BillSDRateTable,
                                                      _Found, SDNum, J, J,
                                                      BillSDRateTable.FieldByName('CurrentTaxLevy').AsInteger,
                                                      BillSDRateTable.FieldByName('PriorTaxLevy').AsInteger,
                                                      bFullSwisIn147);

                            inc(SDNum);

                            Writeln(RPS147File, Line);

                          end;  {For J := StartRateNum to EndRateNum do}

                      end
                    else
                    begin
                      Line := CreateType2Record(SDCodeTable, SwisTable, BillSDRateTable,
                                                _Found, SDNum, StartRateNum, EndRateNum,
                                                CurrentTaxLevy, PriorTaxLevy, bFullSwisIn147);

                      inc(SDNum);

                      Writeln(RPS147File, Line);

                    end;  {else of If bBreakOutDistrictsByExtension}

                  end;  {If ((not bSupressUnbilledDistricts) or ...}

              end;  {If not (Done or Quit)}

(*          ExtractCancelled := ProgressDialog.Cancelled;*)

        until (Done or Quit or ExtractCancelled);

      end;  {If not (Quit or ExtractCancelled)}

    {Now actually write the rates to file.}

  If not (Quit or ExtractCancelled)
    then
      For I := 0 to (SDRateList.Count - 1) do
        begin
          with PSDRateRecord(SDRateList[I])^ do
            begin
              Line := '';

              If bFullSwisIn147
              then Line := SwisTable.FieldByName('SwisCode').AsString  {1-6: Municipal code}
              else Line := Copy(SwisTable.FieldByName('SwisCode').Text, 1, 4) + '  ';  {1-6: Municipal code}

              Line := Line + '3';  {7: Record type}
              Line := Line + ShiftRightAddZeroes(Take(4, IntToStr(I + SDRateOffset + 1)));  {8-11: Key}
              Line := Line + Take(11, '');  {12-22: Filler}
              Line := Line + Take(2, Extension);  {23-24: Extension type}
              Line := Line + Take(1, CC_OMFlag);  {25: CC_OM flag}
              Line := Line + FormatRPSNumericString(FloatToStr(Roundoff(Rate, 6)), 11, 6);  {26-36: Rate}
              Line := Line + Take(1, HomesteadCode);  {37: Homestead code}

                {CHG12072009-1(2.22.1.1)[I6784]: Bill changes for Ramapo.}

              If bIncludeBillPrintGroupInformation
                then
                  begin
                    Line := Line + Take(5, BillPrintGroup);  {38-42}
                    Line := Line + ShiftRightAddZeroes(IntToStr(BillPrintGroupOrder), 3);  {43-45}
                  end
                else Line := Line + ConstStr(' ', 8);

              Line := Line + Take(55, '');  {46-100: Filler}

            end;  {with PSDRateRecord(SDRateList[I])^ do}

          Writeln(RPS147File, Line);

        end;  {For I := 0 to (SDRateList.Count - 1) do}

    {Finally, do the exemption codes.}

  If not (Quit or ExtractCancelled)
    then
      begin
        FirstTimeThrough := True;
        Done := False;
        EXNum := 1;

        EXCodeTable.First;

        Line := '';

        repeat
          Application.ProcessMessages;

          If FirstTimeThrough
            then FirstTimeThrough := False
            else
              try
                EXCodeTable.Next;
              except
                Quit := True;
                SystemSupport(002, EXCodeTable, 'Error getting EX code record.',
                              UnitName, GlblErrorDlgBox);
              end;

          If EXCodeTable.EOF
            then Done := True;

            {For each special district in the special district file,
             we will look up each extension in the rate file and add a
             rate to the EXRateList for each.}

          If not (Done or Quit)
            then
              begin
                Line := '';

                with EXCodeTable do
                  begin
                    If bFullSwisIn147
                    then Line := SwisTable.FieldByName('SwisCode').AsString  {1-6: Municipal code}
                    else Line := Copy(SwisTable.FieldByName('SwisCode').Text, 1, 4) + '  ';  {1-6: Municipal code}

                    Line := Line + '4';  {7: Record type}
                    Line := Line + ShiftRightAddZeroes(Take(4, IntToStr(EXNum)));  {8-11: Key}
                    Line := Line + Take(11, FieldByName('EXCode').Text +
                                            FieldByName('SW1').Text);  {12-22: Exemption\Swis}
                    Line := Line + Take(1, '');  {23: Skip}
                    Line := Line + Take(10, FieldByName('Description').Text);  {24-33: Description}
                    Line := Line + Take(1, FieldByName('CalcMethod').Text);  {34: Calculation method}
                    Line := Line + Take(1, FieldByName('AmtVerification').Text);  {35: Calculation method}
                    Line := Line + FormatRPSNumericString(FieldByName('FixedAmount').Text, 6, 0);
                    Line := Line + Take(59, '');  {Filler, skip Appl codes}

                  end;  {with EXCodeTable do}

                  {Add a record to the EX rate list so that when we do
                   the 155, we can put in the rate pointer.}

                New(PEXRateRec);

                with PExRateRec^ do
                  begin
                    RateNumber := EXNum;
                    EXCode := EXCodeTable.FieldByName('EXCode').Text;
                  end;  {with PExRateRec^ do}

                EXRateList.Add(PEXRateRec);

                EXNum := EXNum + 1;

                Writeln(RPS147File, Line);

              end;  {If not (Done or Quit)}

(*          ExtractCancelled := ProgressDialog.Cancelled;*)

        until (Done or Quit or ExtractCancelled);

      end;  {If not (Quit or ExtractCancelled)}

     {FXX07271998-6: Write out swis and school codes.}

     {First do a county record.}

  Line := SwisTable.FieldByName('SwisCode').Text;
  Line := Line + '5';
  Line := Line + ShiftRightAddZeroes(Take(4, IntToStr(NumRecs)));
  Line := Line + Take(11, '');  {Filler}
  Line := Line + SwisTable.FieldByName('SwisCode').Text;
  Line := Line + Take(20, GlblCountyName);
  Line := Line + Take(3, '');
  Line := Line + Take(20, GlblCountyName);
  Line := Line + Take(29, '');

  Writeln(RPS147File, Line);

    {Now do swis codes.}

  SwisTable.First;
  Done := False;
  FirstTimeThrough := True;
  NumRecs := 2;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwisTable.Next;

    If SwisTable.EOF
      then Done := True;

    If not Done
      then
        with SwisTable do
          begin
            Line := FieldByName('SwisCode').Text;
            Line := Line + '5';  {Rec type}
            Line := Line + ShiftRightAddZeroes(Take(4, IntToStr(NumRecs)));
            Line := Line + Take(11, '');  {Filler}
            Line := Line + FieldByName('SwisCode').Text;
            Line := Line + Take(20, FieldByName('MunicipalityName').Text);

            Line := Line + BoolToChar_Blank_1(FieldByName('Classified').AsBoolean);

            If FieldByName('AssessingVillage').AsBoolean
              then Line := Line + 'V'
              else Line := Line + ' ';

            If GlblMunicipalityUsesTwoTaxRates
              then Line := Line + '2'
              else Line := Line + '1';

            Line := Line + Take(20, GlblCountyName);

            Line := Line + FormatRPSNumericString(FieldByName('UniformPercentValue').Text, 3, 0);

            Line := Line + Take(26, '');  {Filler}

            Writeln(RPS147File, Line);

            NumRecs := NumRecs + 1;

          end;  {with SwisTable do}

  until Done;

    {Now do school codes}

  SchoolTable.First;
  SwisTable.First;
  Done := False;
  FirstTimeThrough := True;
  NumRecs := 1;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SchoolTable.Next;

    If SchoolTable.EOF
      then Done := True;

    If not Done
      then
        with SchoolTable do
          begin
            Line := SwisTable.FieldByName('SwisCode').Text;
            Line := Line + '6';  {Rec type}
            Line := Line + ShiftRightAddZeroes(Take(4, IntToStr(NumRecs)));
            Line := Line + Take(11, '');  {Filler}
            Line := Line + FieldByName('SchoolCode').Text;
            Line := Line + Take(20, FieldByName('SchoolName').Text);
            Line := Line + Take(1, FieldByName('Homestead').Text);
            If GlblMunicipalityUsesTwoTaxRates
              then Line := Line + '2'
              else Line := Line + '1';

            Line := Line + ' ';  {School cons flag}
            Line := Line + FieldByName('TaxFinanceCode').Text;

            Line := Line + Take(46, '');  {Filler}

            Writeln(RPS147File, Line);

            NumRecs := NumRecs + 1;

          end;  {with SchoolTable do}

  until Done;

  CloseFile(RPS147File);

end;  {Create147ExtractFile}

{===================================================================}
{===================  155 File Extract Routines =====================}
{===========================================================}
Procedure InitializeRPSExtractString(var RPSString : RPS155ExtractRec);

{Initialize all the characters in the string to #0. This
 will let us know how far into the string we have copied
 (See the next function).}

var
  I : Integer;

begin
  For I := 1 to RPS155ExtractRecordLength do
    RPSString[I] := #0;

end;  {InitializeRPSExtractString}

{===========================================================}
Procedure RPSExtractStrCat(var RPSSourceString : RPS155ExtractRec;
                               StringToAdd : String);

{Add the StringToAdd to the end of RPSSourceString. We will
 start with wherever the first #0 occurs. If we go past the
 end of the string, we will raise an exception.}

var
  I, StartPos : Integer;
  RaiseException : Boolean;

begin
  I := 1;
  StartPos := 0;
  RaiseException := False;

  If (Pos(#0, StringToAdd) > 0)
    then Raise StrException.Create('Well, Dod, you''re right. A string was passed in with a null char.' +
                                   StringToAdd);

  while ((RPSSourceString[I] <> #0) and
         (I <= RPS155ExtractRecordLength)) do
    I := I + 1;

  If (I > RPS155ExtractRecordLength)
    then RaiseException := True
    else StartPos := I;

  If not RaiseException
    then
      begin
        If ((StartPos + Length(StringToAdd) - 1) > RPS155ExtractRecordLength)
          then RaiseException := True
          else
            For I := 1 to Length(StringToAdd) do
              RPSSourceString[I + StartPos - 1] := StringToAdd[I];

      end;  {If not RaiseException}

  If RaiseException
    then Raise StrException.Create('Source string is too long for RPS extract record.');

end;  {RPSExtractStrCat}

{============================================================}
Procedure WriteOneRPS155ExtractRecToFile(var RPSFile : TextFile;
                                             RPSRec : RPS155ExtractRec);

{Write one record of type RPS155ExtractRec to the given file.}

var
  I : Integer;

begin
  For I := 1 to RPS155ExtractRecordLength do
    Write(RPSFile, RPSRec[I]);

  Writeln(RPSFile);

end;  {WriteOneRPS155ExtractRecToFile}

{===================================================================}
Procedure TRPS155FileExtractForm.OpenBillingFiles(    TaxRollYear : String;
                                                      CollectionType : String;
                                                      CollectionNum : Integer;
                                                  var Quit : Boolean);

{Open the billing files for this tax year\municipal type\ collection #.}

var
  HeaderFileName, GeneralFileName,
  EXFileName, SDFileName, SpecialFeeFileName : String;

begin
  GetBillingFileNames(TaxRollYear, CollectionType,
                      ShiftRightAddZeroes(Take(2, IntToStr(CollectionNum))),
                      HeaderFileName, GeneralFileName,
                      EXFileName, SDFileName, SpecialFeeFileName);

  BLHeaderTaxTable.TableName := HeaderFileName;
  BLGeneralTaxTable.TableName := GeneralFileName;
  BLExemptionTaxTable.TableName := EXFileName;
  BLSpecialDistrictTaxTable.TableName := SDFileName;
  BLSpecialFeeTaxTable.TableName := SpecialFeeFileName;

  try
    BLHeaderTaxTable.Open;
  except
    SystemSupport(001, BLHeaderTaxTable, 'Error opening billing header tax table.',
                  UnitName, GlblErrorDlgBox);
  end;

  try
    BLGeneralTaxTable.Open;
  except
    SystemSupport(001, BLGeneralTaxTable, 'Error opening billing general tax table.',
                  UnitName, GlblErrorDlgBox);
  end;

  try
    BLExemptionTaxTable.Open;
  except
    SystemSupport(001, BLExemptionTaxTable, 'Error opening billing exemption tax table.',
                  UnitName, GlblErrorDlgBox);
  end;

  try
    BLSpecialDistrictTaxTable.Open;
  except
    SystemSupport(001, BLSpecialDistrictTaxTable, 'Error opening billing special district tax table.',
                  UnitName, GlblErrorDlgBox);
  end;

  try
    BLSpecialFeeTaxTable.Open;
  except
    SystemSupport(001, BLSpecialFeeTaxTable, 'Error opening billing special fee tax table.',
                  UnitName, GlblErrorDlgBox);
  end;

end;  {OpenBillingFiles}

{===================================================================}
Procedure TRPS155FileExtractForm.Add155ExtensionRecHeader(var Line : RPS155ExtractRec;
                                                              SwisSBLKey : String;
                                                              RecNumber : Integer);

{Add the header information to the front of a 155 extension (02, ...) record.}

begin
  with BLHeaderTaxTable do
    begin
      RPSExtractStrCat(Line, Take(6, FieldByName('SwisCode').Text));  {1-6: Swis}
      RPSExtractStrCat(Line, Take(1, FieldByName('RollSection').Text));  {7: Roll sect}
      RPSExtractStrCat(Line, Take(1, ''));  {8 : Skip Roll subsect}
      RPSExtractStrCat(Line, Take(35, SwisSBLKey +
                                      FieldByName('CheckDigit').Text));  {9-43 : SWIS SBL.}
      RPSExtractStrCat(Line, ShiftRightAddZeroes(Take(2, IntToStr(RecNumber))));  {44-45: Rec type}
      RPSExtractStrCat(Line, ShiftRightAddBlanks(Take(7, FieldByName('BankCode').Text)));  {46-52}

   end;  {with BLHeaderTaxTable do}

end;  {Add155ExtensionRecHeader}

{===================================================================}
Function TRPS155FileExtractForm.FindGeneralRate(RateType : Char;  {(G)eneral, Spcl (F)ee}
                                                PrintOrder : Integer;
                                                SwisCode : String) : Integer;

{Given the rate type and print order, return the rate number in the 147 file.}

var
  I, SwisCodeLen : Integer;

begin
  Result := -1;

   {FXX03122002-1: Need to include the swis code in the
                    rate record to distinguish between
                    rates with same print order.}

  For I := 0 to (GeneralRateList.Count - 1) do
    If ((PGeneralRateRecord(GeneralRateList[I])^.RateType = RateType) and
        (PGeneralRateRecord(GeneralRateList[I])^.PrintOrder = PrintOrder) and
        (Result = -1))
      then
        begin
          SwisCodeLen := Length(Trim(PGeneralRateRecord(GeneralRateList[I])^.SwisCode));

          If ((RateType = 'F') or
              (Take(SwisCodeLen, SwisCode) = Take(SwisCodeLen, PGeneralRateRecord(GeneralRateList[I])^.SwisCode)))
            then Result := PGeneralRateRecord(GeneralRateList[I])^.RateNumber;

        end;  {If ((PGeneralRateRecord(GeneralRateList[I])^.RateType = RateType) and ...}

end;  {FindGeneralRate}

{===================================================================}
Function TRPS155FileExtractForm.FindSDCodeRate(SDCode : String;
                                               Extension : String;
                                               CC_OMFlag,
                                               HomesteadCode : String) : Integer;

{Given the SD code, extension code, CC_OM flag, and homestead code
 find the rate number in the SD rate list.}


 var
   I : Integer;

begin
  Result := 0;

  For I := 0 to (SDRateList.Count - 1) do
    If ((Take(5, PSDRateRecord(SDRateList[I])^.SDCode) = Take(5, SDCode)) and
        (Take(2, PSDRateRecord(SDRateList[I])^.Extension) = Take(2, Extension)) and
        (Take(1, PSDRateRecord(SDRateList[I])^.CC_OMFlag) = Take(1, CC_OMFlag)) and
        (Take(1, PSDRateRecord(SDRateList[I])^.HomesteadCode) = Take(1, HomesteadCode)))
      then Result := PSDRateRecord(SDRateList[I])^.RateNumber;

end;  {FindSDCodeRate}

{===================================================================}
Function GetSDBillingRate(SDCode : String;
                          Extension : String;
                          CC_OMFlag,
                          HomesteadCode : String;
                          SDRateList : TList) : Extended;

{Given the SD code, extension code, CC_OM flag, and homestead code
 find the billing rate number in the SD rate list.}


var
  I : Integer;

begin
  Result := 0;

  For I := 0 to (SDRateList.Count - 1) do
    If ((Take(5, PSDRateRecord(SDRateList[I])^.SDCode) = Take(5, SDCode)) and
        (Take(2, PSDRateRecord(SDRateList[I])^.Extension) = Take(2, Extension)) and
        (Take(1, PSDRateRecord(SDRateList[I])^.CC_OMFlag) = Take(1, CC_OMFlag)) and
        (Take(1, PSDRateRecord(SDRateList[I])^.HomesteadCode) = Take(1, HomesteadCode)))
      then Result := PSDRateRecord(SDRateList[I])^.Rate;

end;  {GetSDBillingRate}

{===================================================================}
Function TRPS155FileExtractForm.FindSDPurpPtr(SDCode : String): Integer;  {FXX12121998-1}

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (SDRateList.Count - 1) do
    If _Compare(PSDRateRecord(SDRateList[I])^.SDCode, SDCode, coEqual)
      then Result := PSDRateRecord(SDRateList[I])^.RateNumber;

end;  {FindSDPurpptr}

{===================================================================}
Procedure TRPS155FileExtractForm.AddExtension(var Line : RPS155ExtractRec;
                                                  ExtensionType : String;  {(G)eneral, Special (F)ee, Spcl (D)ist}
                                                  PurposePointer : Integer;
                                                  DesignationCode : String; {(H)std, (N)onhstd, (F)ee, Spcl (D)ist, ' '}
                                                  SDExtensionDesc,
                                                  AssessedValue,
                                                  TaxableValue,
                                                  TaxAmount : String);

{Add all the extension information to a 155 extension (02, ...) record.}

var
  TempString,
  TempStr : String;
  SDistPurpPtr : Integer;  {FXX12121998-1}

begin
  SdistPurpPtr := -1;

    {For special districts, the rate pointer is the same as the purpose pointer.
     For general taxes and special fees, it is 000.}

  TempStr := '';
     {FXX12121998-1 miekmike....better way to get sd code into this routine?}
  If (ExtensionType = 'D')
    then
    begin
    TempString :=  BLSpecialDistrictTaxTable.FieldByName('SDistCode').Text;
    SDistPurpPtr := FindSDPurpPtr(BLSpecialDistrictTaxTable.FieldByName('SDistCode').Text);(* +
                    SDRateOffset; *)
    TempStr := IntToStr(PurposePointer);
    end;

  RPSExtractStrCat(Line, Take(1, DesignationCode));
    {FXX12121998-1...if sdist, must dedupe sd code to get purp ptr index}
   If (ExtensionType <> 'D')      {FXX12121998-1}
    then RPSExtractStrCat(Line, ShiftRightAddZeroes(Take(3, IntToStr(PurposePointer))))
    else RPSExtractStrCat(Line, ShiftRightAddZeroes(Take(3, IntToStr(SdistPurpPtr))));

  RPSExtractStrCat(Line, ShiftRightAddZeroes(Take(3, TempStr)));  {Rate pointer}

  RPSExtractStrCat(Line, FormatRPSNumericString(AssessedValue, 14, 2));  {Assessed value}

    {For special districts, the taxable value is a text description of
     the extension code. If it is a general tax, it is the taxable value.
     For special fees, it is 0.}

  If (ExtensionType = 'D')
    then RPSExtractStrCat(Line, Take(14, SDExtensionDesc))
    else RPSExtractStrCat(Line, FormatRPSNumericString(TaxableValue, 14, 2));

  RPSExtractStrCat(Line, FormatRPSNumericString(TaxAmount, 14, 2));

end;  {AddExtension}

{===================================================================}
Procedure TRPS155FileExtractForm.AddAmountDue(var Line : RPS155ExtractRec;
                                                  PaymentNumber : Integer);

{Add the information to a 155 extension record (02, 03, ...)
 for a single payment - amount due, date due, and penalty %.}

var
  TempStr, TempFieldName : String;
  TempNum : Double;

begin
    {First the date due.}

  TempFieldName := 'Paydate' + IntToStr(PaymentNumber);
  TempStr := MakeMMDDYYYYFromDateTime(TDateField(BillControlTable.FieldByName(TempFieldName)).AsDateTime);
  TempFieldName := 'TaxPayment' + IntToStr(PaymentNumber);
  TempNum := BLHeaderTaxTable.FieldByName(TempFieldName).AsFloat;

    {If the date is blank or the payment is zero, don't print a date.}
    {FXX06291998-5: Payment date is 8.}

  If ((TempStr = '0000') or
      (Roundoff(TempNum, 2) = 0))
    then TempStr := Take(8, '');

  RPSExtractStrCat(Line, TempStr);

    {Now do the tax amount.}

  TempFieldName := 'TaxPayment' + IntToStr(PaymentNumber);
  TempStr := BLHeaderTaxTable.FieldByName(TempFieldName).Text;
  RPSExtractStrCat(Line, FormatRPSNumericString(TempStr, 14, 2));

    {Finally do the penalty percent.}

  TempFieldName := 'PenPercent' + IntToStr(PaymentNumber);
  TempStr := BillControlTable.FieldByName(TempFieldName).Text;

  If ((Deblank(TempStr) = '') or
      (Roundoff(StrToFloat(TempStr), 2) = 0))
    then RPSExtractStrCat(Line, Take(14, ''))
    else RPSExtractStrCat(Line, FormatRPSNumericString(TempStr, 14, 2));

end;  {AddAmountDue}

{===================================================================}
Procedure TRPS155FileExtractForm.Add155ExtensionRecFooter(var Line : RPS155ExtractRec;
                                                              SwisSBLKey : String;
                                                              SpecialCharges : Extended);

{Add the footer information to the end of a 155 extension (02, ...) record.}

var
  I : Integer;
  Subtotal : Extended;
  Found : Boolean;
  SBLRec : SBLRecord;

begin
   {Total due}

  RPSExtractStrCat(Line, FormatRPSNumericString(BLHeaderTaxTable.FieldByName('TotalTaxOwed').Text, 14, 2));  {641-654}

    {4 amounts due with due date and penalty %}

  with BillControlTable do
    For I := 1 to 4 do
      AddAmountDue(Line, I);

    {Subtotal (total w\out special charge.}

  Subtotal := BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat -
              SpecialCharges;
  Subtotal := Roundoff(Subtotal, 2);

  RPSExtractStrCat(Line, FormatRPSNumericString(FloatToStr(Subtotal), 14, 2));  {791-804}

    {2 more amounts due with due date and penalty %}

  with BillControlTable do
    For I := 5 to 6 do
      AddAmountDue(Line, I);

    {Filler}
      {FXX12171998-2: Not getting parcel record correctly.}

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    Found := FindKeyOld(TYParcelTable,
                        ['TaxRollYr', 'SwisCode', 'Section',
                         'Subsection', 'Block', 'Lot', 'Sublot',
                         'Suffix'],
                        [GlblThisYear, SwisCode, Section, Subsection,
                         Block, Lot, Sublot, Suffix]);

  If IncludeRemappedParcelID
  then RPSExtractStrCat(Line, Take(26, TYParcelTable.FieldByName('RemapOldSBL').Text))
  else RPSExtractStrCat(Line, Take(16, ''));

(*  If Found
    then
    begin
        {FXX12171998-1: Put the rs9 linked parcel back in.}
        {CHG12101999-1: Include remapped SBL.}

      If IncludeRemappedParcelID
        then RPSExtractStrCat(Line, Take(26, TYParcelTable.FieldByName('RemapOldSBL').Text))
        else
          If (TYParcelTable.FieldByName('RollSection').Text = '9')
            then RPSExtractStrCat(Line, Take(26, TYParcelTable.FieldByName('RS9LinkedSBL').Text))  {885-910: prorata}
            else
              If IncludeAdditionalLots
                then RPSExtractStrCat(Line, Take(26, TYParcelTable.FieldByName('AdditionalLots').Text))
                else RPSExtractStrCat(Line, Take(26, ''));  {885-910}
    end
    else
    begin
      RPSExtractStrCat(Line, Take(26, ''));
    end;  {} *)

end;  {Add155ExtensionRecFooter}

{===================================================================}
Procedure TRPS155FileExtractForm.ExtractOneParcelFor155File(var RPS155File : TextFile;
                                                            var RPS155D9File : TextFile;
                                                            var TotalTax,
                                                                TotalSpecialDistricts,
                                                                TotalExemptions,
                                                                TotalSpecialFees : Extended;
                                                            var Quit : Boolean);

{Extract all the information for one parcel including parcel information,
 taxes, special districts and exemptions.}

var
  Line : RPS155ExtractRec;
  MunicipalityType, RateIndex,
  ExtensionNum, RecNum, Index,
  ExemptionAmount, FullExemptionValue,
  NumExemptions, I, J, RatePointer, RPS155D9Items : Integer;
  ExemptionList, ExemptionAmountList, ExemptionFullValueList : TStringList;
  SwisSBLKey : String;
  TaxesDue, HeaderAddedToRecord,
  _Found, Done, FirstTimeThrough, RPS155D9HeaderPrinted : Boolean;
  NameAddrInfoArray : NameAddrArray;
  HstdAssessedVal, NonhstdAssessedVal,
  LandAssessedVal, TotalAssessedVal : Comp;
  Acreage : Real;
  ExtensionDesc : String;
  TempStr, LegalAddrNo, AssessedValStr : String;
  SpecialCharges : Extended;
  TempHomesteadCode, DisplayHomesteadCode, sTaxDue : String;
  Category : String;
  ExemptionAppliesArray : ExemptionAppliesArrayType;
  CountySeniorAmount, SchoolSeniorAmount, FullValue : Comp;
  Rate, STARSavings : Extended;
  HomesteadCode : Char;
  Amount : LongInt;

begin
  ExemptionList := TStringList.Create;
  ExemptionAmountList := TStringList.Create;
  ExemptionFullValueList := TStringList.Create;
  SpecialCharges := 0;
  RatePointer := 0;
  TotalAssessedVal := 0;
  RPS155D9HeaderPrinted := False;

     {First create the '01' record with the base parcel information
      and the exemptions.}

  InitializeRPSExtractString(Line);

  with BLHeaderTaxTable do
    begin
      SwisSBLKey := Take(6, FieldByName('SwisCode').Text) +
                    Take(20, FieldByName('SBLKey').Text);

      TaxesDue := (Roundoff(FieldByName('TotalTaxOwed').AsFloat, 2) > 0);
      HstdAssessedVal := TCurrencyField(FieldByName('HstdTotalVal')).Value;
      NonhstdAssessedVal := TCurrencyField(FieldByName('NonhstdTotalVal')).Value;
      HomesteadCode := Take(1, FieldByName('HomesteadCode').Text)[1];

        {FXX12271999-2: Need to handle split parcels.}

      case HomesteadCode of
        'N' : begin
                Acreage := FieldByName('NonhstdAcreage').AsFloat;
                LandAssessedVal := TCurrencyField(FieldByName('NonhstdLandVal')).Value;
                TotalAssessedVal := TCurrencyField(FieldByName('NonhstdTotalVal')).Value;
              end;

        ' ',
        'H' : begin
                Acreage := FieldByName('HstdAcreage').AsFloat;
                LandAssessedVal := TCurrencyField(FieldByName('HstdLandVal')).Value;
                TotalAssessedVal := TCurrencyField(FieldByName('HstdTotalVal')).Value;
              end;

        'S' : begin
                Acreage := FieldByName('NonhstdAcreage').AsFloat +
                           FieldByName('HstdAcreage').AsFloat;
                LandAssessedVal := TCurrencyField(FieldByName('NonhstdLandVal')).Value +
                                   TCurrencyField(FieldByName('HstdLandVal')).Value;
                TotalAssessedVal := TCurrencyField(FieldByName('NonhstdTotalVal')).Value +
                                    TCurrencyField(FieldByName('HstdTotalVal')).Value;
              end;

      end;  {case HomesteadCode of}

        {Fill up the name and address array so that the information
         is packed towards the top.}
        {CHG06202003-2(2.07d): Add options on name\address formatting for Accuzip.}

      Index := 1;

      For I := 1 to 6 do
        NameAddrInfoArray[I] := '';

      If (Deblank(FieldByName('Name1').Text) <> '')
        then
          begin
            NameAddrInfoArray[Index] := Take(30, FieldByName('Name1').Text);
            Index := Index + 1;
          end;

      If (Deblank(FieldByName('Name2').Text) = '')
        then
          begin
              {If they want to make sure that only name 2 goes on the second
               line, then skip this line.}

            If NoAddressInformationOnSecondLine
              then
                begin
                  NameAddrInfoArray[Index] := '';
                  Index := Index + 1;
                end;

          end
        else
          begin
            NameAddrInfoArray[Index] := Take(30, FieldByName('Name2').Text);
            Index := Index + 1;
          end;

      If (Deblank(FieldByName('Address1').Text) <> '')
        then
          begin
            NameAddrInfoArray[Index] := Take(30, FieldByName('Address1').Text);
            Index := Index + 1;
          end;

      If (Deblank(FieldByName('Address2').Text) <> '')
        then
          begin
            NameAddrInfoArray[Index] := Take(30, FieldByName('Address2').Text);
            Index := Index + 1;
          end;

      If (Deblank(FieldByName('Street').Text) <> '')
        then
          begin
            NameAddrInfoArray[Index] := Take(30, FieldByName('Street').Text);
            Index := Index + 1;
          end;

      If ForceCityStateZipToLastLine
        then Index := 6;

      NameAddrInfoArray[Index] := Take(30, Trim(FieldByName('City').Text) + ' ' +
                                           Trim(FieldByName('State').Text) + ' ' +
                                           Trim(FieldByName('Zip').Text));

      If (glblUsesTaxBillNameAddr and
          _Locate(tbTaxBillNameAddress, [glblNextYear, SwisSBLKey], '', []))
        then GetNameAddress(tbTaxBillNameAddress, NameAddrInfoArray);

       {Now start filling in the output record.}

      RPSExtractStrCat(Line, Take(6, FieldByName('SwisCode').Text));  {1-6: Swis}
      RPSExtractStrCat(Line, Take(1, FieldByName('RollSection').Text));  {7: Roll sect}
      RPSExtractStrCat(Line, Take(1, ''));  {8 : Skip Roll subsect}
      RPSExtractStrCat(Line, Take(35, SwisSBLKey +
                                      FieldByName('CheckDigit').Text));  {9-43 : SWIS SBL.}
      RPSExtractStrCat(Line, '01');  {44-45: Rec type}
      RPSExtractStrCat(Line, ShiftRightAddBlanks(Take(7, FieldByName('BankCode').Text)));  {46-52}
      RPSExtractStrCat(Line, Take(6, FieldByName('SwisCode').Text));  {53-58: Swis}
      RPSExtractStrCat(Line, Take(20, Copy(SwisSBLKey, 7, 20)));  {59-78: SwisSBLKey}
      RPSExtractStrCat(Line, Take(2, FieldByName('CheckDigit').Text));  {79-80: Check digit}
      RPSExtractStrCat(Line, Take(30, NameAddrInfoArray[1]));  {81-110: Owner1}
      RPSExtractStrCat(Line, Take(30, NameAddrInfoArray[2]));  {111-140: Owner2}
      RPSExtractStrCat(Line, Take(30, NameAddrInfoArray[3]));  {141-170: Addr1}
      RPSExtractStrCat(Line, Take(30, NameAddrInfoArray[4]));  {171-200: Addr2}
      RPSExtractStrCat(Line, Take(30, NameAddrInfoArray[5]));  {201-230: Addr 3}
      RPSExtractStrCat(Line, Take(30, NameAddrInfoArray[6]));  {231-260: Addr4}
      RPSExtractStrCat(Line, Take(30, FieldByName('PropDescr1').Text));  {261-290}
      RPSExtractStrCat(Line, Take(30, FieldByName('PropDescr2').Text));  {291-320}
      RPSExtractStrCat(Line, Take(30, FieldByName('PropDescr3').Text));  {321-350}
      RPSExtractStrCat(Line, FormatRPSNumericString(FieldByName('Frontage').Text,
                                                    7, 2));  {351-357: Front feet}
      RPSExtractStrCat(Line, FormatRPSNumericString(FieldByName('Depth').Text,
                                                    7, 2));  {358-364: Depth}
      RPSExtractStrCat(Line, FormatRPSNumericString(FloatToStr(Acreage), 7, 2));  {365-371: Acres}
      RPSExtractStrCat(Line, Take(6, FieldByName('SchoolDistCode').Text));  {372-377: School code}
      RPSExtractStrCat(Line, ShiftRightAddBlanks(Take(7, FieldByName('BankCode').Text)));  {378-384}
      RPSExtractStrCat(Line, Take(11, FieldByName('AccountNumber').Text));  {385-395}
      RPSExtractStrCat(Line, Take(3, FieldByName('PropertyClassCode').Text));  {396-398}
      RPSExtractStrCat(Line, Take(6, ''));  {399-404: Skip Decode for Ownership}
      RPSExtractStrCat(Line, ShiftRightAddZeroes(Take(6, FieldByName('BillNo').Text)) + ' ');  {405-411}
      RPSExtractStrCat(Line, Take(1, FieldByName('RollSection').Text));  {412: Roll sect}
      RPSExtractStrCat(Line, Take(1, ''));  {413 : Skip Roll subsect}

        {We will conform to present 155\995 legal addr number format for
         file comparison purposes. The rule is: If this is a numeric legal
         addr number, put it to the right in nine spaces and leave one
         blank space. Otherwise, put it to the right in 10 spaces.}

      LegalAddrNo := Trim(FieldByName('LegalAddrNo').Text);

      If (LegalAddrNo[Length(LegalAddrNo)] in Numbers)
        then LegalAddrNo := ShiftRightAddBlanks(Take(9, LegalAddrNo)) + ' '
        else LegalAddrNo := ShiftRightAddBlanks(Take(10, LegalAddrNo));

      RPSExtractStrCat(Line, LegalAddrNo);  {414-423}
      RPSExtractStrCat(Line, Take(25, FieldByName('LegalAddr').Text));  {424-448}
      RPSExtractStrCat(Line, Take(3, ''));  {449-451: Skip Direction abbr, street side}
      RPSExtractStrCat(Line, Take(9, FieldByName('MortgageNumber').Text));  {452-460}

        {Now do the exemption pointers.}
        {First put all the exemptions and corresponding amounts into 2 lists.}

      SetRangeOld(BLExemptionTaxTable,
                  ['SwisSBLKey', 'HomesteadCode', 'EXCode'],
                  [SwisSBLKey, ' ', '     '],
                  [SwisSBLKey, 'Z', '99999']);

      NumExemptions := 0;
      FirstTimeThrough := True;
      Done := False;
      CountySeniorAmount := 0;
      SchoolSeniorAmount := 0;

      with BLExemptionTaxTable do
        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else
              try
                Next;
              except
                SystemSupport(001, BLExemptionTaxTable, 'Error getting exemption tax record.',
                              UnitName, GlblErrorDlgBox);
              end;

          If (EOF or
              (Take(26, FieldByName('SwisSBLKey').Text) <> SwisSBLKey))
            then Done := True;

          If not (Done or Quit)
            then
              begin
                ExemptionList.Add(FieldByName('ExCode').Text);

                If (CollectionType = 'MU')
                  then MunicipalityType := GetMunicipalityType(GlblMunicipalityType)
                  else
                    If (CollectionType = 'SC')
                      then MunicipalityType := MTSchool
                      else MunicipalityType := MTVillage;

                case MunicipalityType of
                  MTCity,
                  MTTown : begin
                             ExemptionAppliesArray := EXApplies(FieldByName('ExCode').Text, False);
                             Amount := 0;

                               {FXX01112005-1(2.8.2.2)[2041]: The amount was not being filled in for county \ school collections.}

                             If ((Amount = 0) and
                                 ExemptionAppliesArray[EXTown] and
                                 (FieldByName('TownAmount').AsInteger > 0))
                               then Amount := FieldByName('TownAmount').AsInteger;

                             If ((Amount = 0) and
                                 ExemptionAppliesArray[EXCounty] and
                                 (FieldByName('CountyAmount').AsInteger > 0))
                               then Amount := FieldByName('CountyAmount').AsInteger;

                             If ((Amount = 0) and
                                 ExemptionAppliesArray[EXSchool] and
                                 (FieldByName('SchoolAmount').AsInteger > 0))
                               then Amount := FieldByName('SchoolAmount').AsInteger;

                               {FXX05142009-1(2.20.1.1): If village only exemption, need to include it.}

                             If ((Amount = 0) and
                                 ExemptionAppliesArray[EXVillage] and
                                 (FieldByName('VillageAmount').AsInteger > 0))
                               then Amount := FieldByName('VillageAmount').AsInteger;

                             ExemptionAmountList.Add(IntToStr(Amount));

                           end;  {EXCity, EXTown}

                  MTSchool : ExemptionAmountList.Add(FieldByName('SchoolAmount').Text);
                  MTVillage : ExemptionAmountList.Add(FieldByName('VillageAmount').Text);

                  MTCounty : begin
                             ExemptionAmountList.Add(FieldByName('CountyAmount').Text);
                             end;

                end;  {case MunicipalityType of}

                try
                  ExemptionFullValueList.Add(FieldByName('FullValue').Text);
                except
                  ExemptionFullValueList.Add('0');
                end;

                TotalExemptions := TotalExemptions + TCurrencyField(FieldByName('TownAmount')).Value;

                  {Save the county and school senior amounts for later use.}

                If (Take(4, FieldByName('ExCode').Text) = '4180')
                  then
                    begin
                      ExemptionAppliesArray := EXApplies(FieldByName('ExCode').Text,
                                                         False);

                      If ExemptionAppliesArray[EXCounty]
                        then CountySeniorAmount := FieldByName('CountyAmount').AsFloat;

                      If ExemptionAppliesArray[EXSchool]
                        then SchoolSeniorAmount := FieldByName('SchoolAmount').AsFloat;

                    end;  {If (Take(4, FieldByName('ExCode').Text) = '4180')}

              end;  {If not (Done or Quit)}

        until (Done or Quit);

        {Now actually write out the exemption information up to 5 exemptions.}
        {CHG05071998-1: There is no longer just 5 exemptions and an overflow rec -
                        there are now 21 exemptions in rec 0 with no overflow.}

      RPS155D9Items := 0;

      For I := 1 to 21 do
        If (ExemptionList.Count >= I)
          then
            begin
                 {Figure out the rate pointer for this exemption.}

              For J := 0 to (EXRateList.Count - 1) do
                If (PEXRateRecord(ExRateList[J])^.EXCode = ExemptionList[I -1])
                  then RatePointer := PEXRateRecord(ExRateList[J])^.RateNumber;

              RPSExtractStrCat(Line, ShiftRightAddZeroes(Take(3, IntToStr(RatePointer))));
              RPSExtractStrCat(Line, FormatRPSNumericString(ExemptionAmountList[I - 1],
                                                            12, 0));

                {CHG11302006-1(2.11.1.4): Accomodate new full value of exemption requirements.}

              If _Compare(RPS155D9Items, 0, coEqual)
                then
                  begin
                    Write(RPS155D9File, Take(6, FieldByName('SwisCode').Text));  {1-6: Swis}
                    Write(RPS155D9File, Take(1, FieldByName('RollSection').Text));  {7: Roll sect}
                    Write(RPS155D9File, Take(1, ''));  {8 : Skip Roll subsect}
                    Write(RPS155D9File, Take(35, SwisSBLKey +
                                        FieldByName('CheckDigit').Text));  {9-43 : SWIS SBL.}
                    Write(RPS155D9File, '01');  {44-45: Rec type}
                    Write(RPS155D9File, ShiftRightAddBlanks(Take(7, FieldByName('BankCode').Text)));  {46-52}
                    Write(RPS155D9File, Take(6, FieldByName('SwisCode').Text));  {53-58: Swis}
                    Write(RPS155D9File, Take(20, Copy(SwisSBLKey, 7, 20)));  {59-78: SwisSBLKey}

                  end;  {If _Compare(RPS155D9Items, 0, coEqual)}

              Inc(RPS155D9Items);

              Write(RPS155D9File, ShiftRightAddZeroes(Take(3, IntToStr(RatePointer))));
              Write(RPS155D9File, FormatRPSNumericString(ExemptionAmountList[I - 1],
                                                            12, 0));
              Write(RPS155D9File, FormatRPSNumericString(ExemptionFullValueList[I-1], 12, 0));

            end  {If (ExRateList.Count <= I)}
          else RPSExtractStrCat(Line, ShiftRightAddZeroes(Take(15, '')));  {No exemption, so put out blanks.}

      If _Compare(RPS155D9Items, 0, coGreaterThan)
        then
          begin
            For I := (RPS155D9Items + 1) to 21 do
              Write(RPS155D9File, ShiftRightAddZeroes('', 27));

            Writeln(RPS155D9File);

          end;  {If _Compare(RPS155D9Items, 0, coGreaterThan)}

        {Continue with record 01.}
        {CHG05071998-1: Because of additional exemptions above, all the following
                        positions change and the amount of fill changes.}

      (*If glblUseExactPrintKey
      then RPSExtractStrCat(Line, Take(25, FieldByName('PrintKey').AsString))
      else *)

      RPSExtractStrCat(Line, Take(25, ConvertSwisSBLToDashDotNoSwis(SwisSBLKey)));  {776-800: Print key}

      RPSExtractStrCat(Line, ShiftRightAddZeroes(Take(7, FieldByName('GridCordNorth').Text)));  {801-807}
      RPSExtractStrCat(Line, ShiftRightAddZeroes(Take(7, FieldByName('GridCordEast').Text)));  {808-814}
      RPSExtractStrCat(Line, Take(5, FieldByName('DeedBook').Text));  {815-819}
      RPSExtractStrCat(Line, Take(5, FieldByName('DeedPage').Text));  {820-824}
      RPSExtractStrCat(Line, FormatRPSNumericString(FloatToStr(LandAssessedVal),
                                                    12, 0));  {825-836}
      RPSExtractStrCat(Line, FormatRPSNumericString(FloatToStr(TotalAssessedVal),
                                                    12, 0));  {837-848}
      RPSExtractStrCat(Line, Take(1, FieldByName('HomesteadCode').Text));  {849}
      RPSExtractStrCat(Line, Take(1, FieldByName('CommitmentCode').Text));  {850}
      RPSExtractStrCat(Line, Take(2, Copy(FieldByName('CommTermYear').Text, 3, 2)));  {851-52}

        {FXX07271998-5: Add new 155 fields.}
        {FXX12232002-1: Make the arrears flag output 0/1 instead of Y/N.}

      RPSExtractStrCat(Line, BoolToChar_0_1(FieldByName('ArrearsFlag').AsBoolean));  {853}

         {Full value of parcel}

      FindKeyOld(SwisTable, ['SwisCode'], [FieldByName('SwisCode').Text]);
      FullValue := ComputeFullValue(TotalAssessedVal,
                                    SwisTable,
                                    FieldByName('PropertyClassCode').Text,
                                    ' ', True);
      RPSExtractStrCat(Line, FormatRPSNumericString(FloatToStr(FullValue),
                                                    14, 0));  {854-867}

         {STAR savings - found in 1st line of general tax extension.}

      BLGeneralTaxTable.CancelRange;
      SetRangeOld(BLGeneralTaxTable,
                  ['SwisSBLKey', 'HomesteadCode', 'PrintOrder'],
                  [SwisSBLKey, ' ', '0'],
                  [SwisSBLKey, 'Z', '32000']);
      BLGeneralTaxTable.First;
      STARSavings := BLGeneralTaxTable.FieldByName('STARSavings').AsFloat;

      RPSExtractStrCat(Line, FormatRPSNumericString(FloatToStr(STARSavings),
                                                    14, 2));  {868-881}

         {County and school senior amount}

      RPSExtractStrCat(Line, FormatRPSNumericString(FloatToStr(CountySeniorAmount),
                                                    9, 0));  {882-890}
      RPSExtractStrCat(Line, FormatRPSNumericString(FloatToStr(SchoolSeniorAmount),
                                                    9, 0));  {891-899}

        {FXX12171998-1: Need to expand rec 1 length, too for prorata SBL.}

      If _Compare(FieldByName('BillNo').Text, coBlank)
      then sTaxDue := 'N'
      else sTaxDue := 'Y';

      RPSExtractStrCat(Line, Take(1, sTaxDue));  {900 - 910: Filler}

    end;  {with BLHeaderTaxTable do}

  WriteOneRPS155ExtractRecToFile(RPS155File, Line);

    {Now put out all the general taxes, special fees, and special
     districts for this file, using as many 155 records as needed.}

  RecNum := 2;
  ExtensionNum := 1;

  InitializeRPSExtractString(Line);

    {First do the general rates.}

  SetRangeOld(BLGeneralTaxTable,
              ['SwisSBLKey', 'HomesteadCode', 'PrintOrder'],
              [SwisSBLKey, ' ',  '0'],
              [SwisSBLKey, 'Z', '32000']);
  BLGeneralTaxTable.First;

  HeaderAddedToRecord := False;
  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          BLGeneralTaxTable.Next;
        except
          Quit := True;
          SystemSupport(020, BLGeneralTaxTable, 'Error getting general tax record.',
                        UnitName, GlblErrorDlgBox);
        end;

    If (BLGeneralTaxTable.EOF or
        (Take(26, BLGeneralTaxTable.FieldByName('SwisSBLKey').Text) <> Take(26, SwisSBLKey)))
      then Done := True;

      {If this record is OK, then add this extension to the file.}

    If not (Done or Quit)
      then
        with BLGeneralTaxTable do
          begin
              {If we have not put a header on this record, put it on now.}

            If not HeaderAddedToRecord
              then
                begin
                  Add155ExtensionRecHeader(Line, SwisSBLKey, RecNum);
                  HeaderAddedToRecord := True;
                end;

            AddExtension(Line, 'G',
                         FindGeneralRate('G', FieldByName('PrintOrder').AsInteger,
                                         Take(6, FieldByName('SwisSBLKey').Text)),
                         FieldByName('HomesteadCode').Text, '',
                         FloatToStr(TotalAssessedVal),
                         FieldByName('TaxableValue').Text,
                         FieldByName('TaxAmount').Text);

            ExtensionNum := ExtensionNum + 1;

            TotalTax := TotalTax + TCurrencyField(FieldByName('TaxAmount')).Value;

              {If we are past the number of extension allowed
               per record, then put the footer on the record (payment
               amounts and total due).
               Then write the record to file and initialize a new 155 record.}

            If (ExtensionNum > 12)
              then
                begin
                  Add155ExtensionRecFooter(Line, SwisSBLKey, SpecialCharges);

                  WriteOneRPS155ExtractRecToFile(RPS155File, Line);

                  InitializeRPSExtractString(Line);

                  HeaderAddedToRecord := False;

                  RecNum := RecNum + 1;
                  ExtensionNum := 1;

                end;  {If (ExtensionNum > 12)}

          end;  {with BLGeneralTaxTable do}

  until (Done or Quit);

      {Now do the Special Fee rates.}

  SetRangeOld(BLSpecialFeeTaxTable,
              ['SwisSBLKey', 'PrintOrder'],
              [SwisSBLKey, '0'],
              [SwisSBLKey, '32000']);
  BLSpecialFeeTaxTable.First;

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          BLSpecialFeeTaxTable.Next;
        except
          Quit := True;
          SystemSupport(020, BLSpecialFeeTaxTable, 'Error getting Special Fee tax record.',
                        UnitName, GlblErrorDlgBox);
        end;

    If (BLSpecialFeeTaxTable.EOF or
        (Take(26, BLSpecialFeeTaxTable.FieldByName('SwisSBLKey').Text) <> Take(26, SwisSBLKey)))
      then Done := True;

      {If this record is OK, then add this extension to the file.}

    If not (Done or Quit)
      then
        with BLSpecialFeeTaxTable do
          begin
            SpecialCharges := SpecialCharges + FieldByName('TaxAmount').AsFloat;

              {If we have not put a header on this record, put it on now.}

            If not HeaderAddedToRecord
              then
                begin
                  Add155ExtensionRecHeader(Line, SwisSBLKey, RecNum);
                  HeaderAddedToRecord := True;
                end;

            AddExtension(Line, 'F',
                         FindGeneralRate('F', FieldByName('PrintOrder').AsInteger, ''),
                         'F', '', FloatToStr(TotalAssessedVal), '0',
                         FieldByName('TaxAmount').Text);

            ExtensionNum := ExtensionNum + 1;

            TotalSpecialFees := TotalSpecialFees + TCurrencyField(FieldByName('TaxAmount')).Value;

              {If we are past the number of extension allowed
               per record, then put the footer on the record (payment
               amounts and total due).
               Then write the record to file and initialize a new 155 record.}

            If (ExtensionNum > 12)
              then
                begin
                  Add155ExtensionRecFooter(Line, SwisSBLKey, SpecialCharges);

                  WriteOneRPS155ExtractRecToFile(RPS155File, Line);

                  InitializeRPSExtractString(Line);

                  HeaderAddedToRecord := False;

                  RecNum := RecNum + 1;
                  ExtensionNum := 1;

                end;  {If (ExtensionNum > 12)}

          end;  {with BLSpecialFeeTaxTable do}

  until (Done or Quit);

      {Now do the Special District rates.}

  SetRangeOld(BLSpecialDistrictTaxTable,
              ['SwisSBLKey', 'SDistCode', 'HomesteadCode', 'ExtCode'],
              [SwisSBLKey, '     ', ' ', '  '],
              [SwisSBLKey, 'ZZZZZ', 'Z', 'ZZ']);
  BLSpecialDistrictTaxTable.First;

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          BLSpecialDistrictTaxTable.Next;
        except
          Quit := True;
          SystemSupport(020, BLSpecialDistrictTaxTable, 'Error getting Special District tax record.',
                        UnitName, GlblErrorDlgBox);
        end;

    If (BLSpecialDistrictTaxTable.EOF or
        (Take(26, BLSpecialDistrictTaxTable.FieldByName('SwisSBLKey').Text) <> Take(26, SwisSBLKey)))
      then Done := True;

      {If this record is OK, then add this extension to the file.}

    If not (Done or Quit)
      then
        with BLSpecialDistrictTaxTable do
          begin
              {If we have not put a header on this record, put it on now.}

            If not HeaderAddedToRecord
              then
                begin
                  Add155ExtensionRecHeader(Line, SwisSBLKey, RecNum);
                  HeaderAddedToRecord := True;
                end;

            ExtensionDesc := '';

            try
              _Found := FindKeyOld(SDExtensionCodeTable, ['MainCode'],
                                   [Take(2, FieldByName('ExtCode').Text)]);
            except
              SystemSupport(003, SDExtensionCodeTable, 'Error getting special district extension code record.',
                            UnitName, GlblErrorDlgBox);
            end;

            If _Found
              then
                begin
                  ExtensionDesc := SDExtensionCodeTable.FieldByName('Description').Text;
                  Category := SDExtensionCodeTable.FieldByName('Category').Text;
                end;

              {If there is no homestead code associated with this
               SD, then we will use the homestead rate.}

            If (Deblank(FieldByName('HomesteadCode').Text) = '')
              then TempHomesteadCode := 'H'
              else TempHomesteadCode := FieldByName('HomesteadCode').Text;

            If (Deblank(FieldByName('HomesteadCode').Text) = '')
              then DisplayHomesteadCode := 'H'
              else DisplayHomesteadCode := BLGeneralTaxTable.FieldByName('HomesteadCode').Text;

            {FXX12171998-6: Don't print an assessed value for a move tax.}

            If (FieldByName('ExtCode').Text = 'MT')
              then AssessedValStr := '0'
              else AssessedValStr := FieldByName('AVAmtUnitDim').Text;

              {FXX12232002-3: Do not print extensions that are not billed.}

            Rate := GetSDBillingRate(FieldByName('SDistCode').Text,
                                     FieldByName('ExtCode').Text,
                                     FieldByName('CMFlag').Text,
                                     TempHomesteadCode,
                                     SDRateList);

            If (Roundoff(Rate, 6) > 0)
              then
                begin
                  AddExtension(Line, 'D',
                               FindSDCodeRate(FieldByName('SDistCode').Text,
                                              FieldByName('ExtCode').Text,
                                              FieldByName('CMFlag').Text,
                                              TempHomesteadCode),
                               DisplayHomesteadCode, UpcaseStr(ExtensionDesc),
                               AssessedValStr, '',
                               FieldByName('TaxAmount').Text);

                  ExtensionNum := ExtensionNum + 1;

                  TotalSpecialDistricts := TotalSpecialDistricts + TCurrencyField(FieldByName('TaxAmount')).Value;

                end;  {If (Roundoff(PSDRateRecord(SDRateList[RateIndex])^.Rate, 6) > 0)}

              {If we are past the number of extension allowed
               per record, then put the footer on the record (payment
               amounts and total due).
               Then write the record to file and initialize a new 155 record.}

            If (ExtensionNum > 12)
              then
                begin
                  Add155ExtensionRecFooter(Line, SwisSBLKey, SpecialCharges);

                  WriteOneRPS155ExtractRecToFile(RPS155File, Line);

                  InitializeRPSExtractString(Line);

                  HeaderAddedToRecord := False;

                  RecNum := RecNum + 1;
                  ExtensionNum := 1;

                end;  {If (ExtensionNum > 12)}

          end;  {with BLSpecialDistrictTaxTable do}

  until (Done or Quit);

    {If we have ended in the middle of a 155 record, fill in blanks for the
     rest of the extensions, add a footer and write out the record.}

  If (ExtensionNum > 1)
    then
      begin
        For I := ExtensionNum to 12 do
          begin
            RPSExtractStrCat(Line, ' ');  {Designation code}
            RPSExtractStrCat(Line, ShiftRightAddZeroes(Take(48, '')));  {Purpose & rate pointer, av, tav, amount}

          end;  {For I := ExtensionNum to 12 do}

        Add155ExtensionRecFooter(Line, SwisSBLKey, SpecialCharges);

        WriteOneRPS155ExtractRecToFile(RPS155File, Line);

      end;  {If (ExtensionNum > 1)}

  ExemptionList.Free;
  ExemptionFullValueList.Free;

end;  {ExtractOneParcelFor155File}

{===================================================================}
Function TRPS155FileExtractForm.ProrataParcelBilledThisCycle(BLHeaderTaxTable : TTable;
                                                             SwisSBLKey : String) : Boolean;

{FXX12011999-5: Do not extract roll section 9 parcels if the prorated
                special district on it is not getting billed this time.}
{Look up each SD on the rs 9 parcel (it can only have pro-rata) and see if
 they are billed this cycle.}

var
  FirstTimeThrough, Done : Boolean;

begin
  Result := False;
  SetRangeOld(BLSpecialDistrictTaxTable,
              ['SwisSBLKey', 'SDistCode', 'HomesteadCode', 'ExtCode'],
              [SwisSBLKey, '     ', ' ', '  '],
              [SwisSBLKey, 'ZZZZZ', 'Z', 'ZZ']);

  BLSpecialDistrictTaxTable.First;

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else BLSpecialDistrictTaxTable.Next;

    If BLSpecialDistrictTaxTable.EOF
      then Done := True;

    If not Done
      then
        begin
          FindNearestOld(BillSDRateTable,
                         ['TaxRollYr', 'CollectionType',
                          'CollectionNo', 'SDistCode',
                          'ExtCode', 'CMFlag'],
                         [TaxRollYear, CollectionType,
                          IntToStr(CollectionNum),
                          BLSpecialDistrictTaxTable.FieldByName('SDistCode').Text,
                          '  ', ' ']);

          If (BLSpecialDistrictTaxTable.FieldByName('SDistCode').Text =
              BillSDRateTable.FieldByName('SDistCode').Text)
            then Result := True;

        end;  {If not Done}

  until Done;

end;  {ProrataParcelBilledThisCycle}

{===================================================================}
Procedure TRPS155FileExtractForm.Create155ExtractFile(var TotalTax,
                                                          TotalSpecialDistricts,
                                                          TotalExemptions,
                                                          TotalSpecialFees : Extended;
                                                          _155D1FileName : String;
                                                      var _155D9FileName : String;
                                                      var Quit : Boolean);

{Now actually create the 155 extract file.}

var
  Done, FirstTimeThrough, BillThisParcel : Boolean;
  RPS155File, RPS155D9File : TextFile;
  Extension, SwisSBLKey, RPS155D9FileName : String;

begin
  FirstTimeThrough := True;
  ProgressDialog.UserLabelCaption := 'Creating 155 file.';
  ProgressDialog.Start(GetRecordCount(BLHeaderTaxTable), True, True);

    {CHG11262006-1(2.11.1.1): Allow for specification of file name for tax extract files.}

  AssignFile(RPS155File, _155D1FileName);
  Rewrite(RPS155File);

  Extension := Copy(_155D1FileName, (Length(_155D1FileName) - 1), 2);

  If _Compare(Extension, 'D1', coEndsWith)
    then RPS155D9FileName := Copy(_155D1FileName, 1, (Length(_155D1FileName) - 2)) + 'D9'
    else RPS155D9FileName := dlg_SaveTaxExtractFile.FileName + 'D9';
  _155D9FileName := RPS155D9FileName;
  AssignFile(RPS155D9File, RPS155D9FileName);
  Rewrite(RPS155D9File);

  BLHeaderTaxTable.First;

  repeat
     Application.ProcessMessages;

     If FirstTimeThrough
       then FirstTimeThrough := False
       else BLHeaderTaxTable.Next;

    Done := BLHeaderTaxTable.EOF;

    with BLHeaderTaxTable do
      SwisSBLKey := Take(6, FieldByName('SwisCode').Text) +
                    Take(20, FieldByName('SBLKey').Text);

    with BLHeaderTaxTable do
      ProgressDialog.Update(Self, FieldByName('SwisCode').Text + '\' +
                            ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));

      {FXX12011999-5: Do not extract roll section 9 parcels if the prorated
                      special district on it is not getting billed this time.}

    If not (Done or Quit)
      then
        begin
          BillThisParcel := True;

          If ((BLHeaderTaxTable.FieldByName('RollSection').Text = '9') and
              (not ProrataParcelBilledThisCycle(BLHeaderTaxTable, SwisSBLKey)))
            then BillThisParcel := False;

          If (OnlyIncludeNonZeroBills and
              _Compare(BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat, 0, coEqual))
            then BillThisParcel := False;

          If BillThisParcel
            then ExtractOneParcelFor155File(RPS155File,
                                            RPS155D9File,
                                            TotalTax,
                                            TotalSpecialDistricts,
                                            TotalExemptions,
                                            TotalSpecialFees, Quit);

        end;  {If not (Done or Quit)}

    ExtractCancelled := ProgressDialog.Cancelled;

  until (Quit or Done or ExtractCancelled);

  ProgressDialog.Finish;

  CloseFile(RPS155File);
  CloseFile(RPS155D9File);

end;  {Create155ExtractFile}

{===================================================================}
Procedure TRPS155FileExtractForm.StartButtonClick(Sender: TObject);

var
  _147FileName, _155D1FileName, _155D9FileName : String;
  Found, OKToCreateFiles, Quit : Boolean;
  TotalTax, TotalSpecialDistricts,
  TotalExemptions, TotalSpecialFees : Extended;
(*  SelectedFiles : TStringList;
  TempFileName, ExtractDir, ZipFileName, MailSubject : String; *)

begin
  bFullSwisIn147 := cbxFullSwisIn147.Checked;
  OKToCreateFiles := True;
  ExtractCancelled := False;
  OnlyIncludeNonZeroBills := cb_OnlyIncludeNonZeroBills.Checked;

    {CHG06202003-2(2.07d): Add options on name\address formatting for Accuzip.}

  NoAddressInformationOnSecondLine := NoAddressInformationInSecondLineCheckBox.Checked;
  ForceCityStateZipToLastLine := ForceCityStateZipToLastLineCheckBox.Checked;

    {CHG12232002-1: Allow for SD rate pointers to start at different offsets.}

  try
    SDRateOffset := StrToInt(EditSDRateOffset.Text);
  except
    SDRateOffset := 0;
  end;

  If (Deblank(EditTaxRollYear.Text) = '')
    then
      begin
        MessageDlg('Please enter the tax roll year.', mtError, [mbOK], 0);
        OKToCreateFiles := False;
      end;

  If (Deblank(EditCollectionNumber.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection number.', mtError, [mbOK], 0);
        OKToCreateFiles := False;
      end;

  If (Deblank(LookupCollectionType.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection type.', mtError, [mbOK], 0);
        OKToCreateFiles := False;
      end;

    {If they have entered all the information, look it up in the bill
     control file to make sure that a collection exists for what they
     entered.}

  If OKToCreateFiles
    then
      begin
        TaxRollYear := Take(4, EditTaxRollYear.Text);
        CollectionType := Take(2, LookupCollectionType.Text);
        CollectionNum := StrToInt(Deblank(EditCollectionNumber.Text));

        Found := FindKeyOld(BillControlTable,
                            ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                            [TaxRollYear, CollectionType,
                             IntToStr(CollectionNum)]);

        If not Found
          then
            begin
              MessageDlg('The collection that you entered does not exist.' + #13 +
                         'Please try again.', mtError, [mbOK], 0);
              OKToCreateFiles := False;
            end;

      end;  {If OKToCreateFiles}

    {Now actually create the 147 and 155 files.}

  If OKToCreateFiles
    then
      begin
          {CHG12101999-1: Include remapped SBL.}

        IncludeRemappedParcelID := IncludeRemappedParcelIDCheckBox.Checked;
        Quit := False;
        TotalTax := 0;
        TotalSpecialDistricts := 0;
        TotalExemptions := 0;
        TotalSpecialFees := 0;

          {CHG05192003-2(2.07b): Include additional lots in the 155 for Lawrence.}

        IncludeAdditionalLots := IncludeAdditionalLotsCheckBox.Checked;

          {CHG06291998-1: Comment out index for now - just do by SBL.}
          {Set the index.}

(*        with BLHeaderTaxTable do
          If (CollectionType = 'SC')
            then
              begin
                If (SchoolExtractOrderRadioGroup.ItemIndex = 0)
                  then IndexFieldNames := 'SchoolDistCode;BillNo'
                  else IndexFieldNames := 'SwisCode;BillNo';

              end
            else IndexFieldNames := 'SwisCode;BillNo'; *)

          {First create the 147 file.}

        If dlg_SaveBillRateExtractFile.Execute
          then
            begin
              _147FileName := dlg_SaveBillRateExtractFile.FileName;
              Create147ExtractFile(_147FileName, TaxRollYear, CollectionType,
                                   CollectionNum, Quit);

            end;

          {Open the files for this tax year\municipal type\ collection #.}

        OpenBillingFiles(TaxRollYear, CollectionType,
                         CollectionNum, Quit);

          {Now do the 155 file.}

        try
          dlg_SaveTaxExtractFile.InitialDir := ReturnPath(dlg_SaveBillRateExtractFile.FileName);
        except
        end;

        If ((not (Quit or ExtractCancelled)) and
            dlg_SaveTaxExtractFile.Execute)
          then
            begin
              _155D1FileName := dlg_SaveTaxExtractFile.FileName;
              Create155ExtractFile(TotalTax, TotalSpecialDistricts,
                                   TotalExemptions, TotalSpecialFees,
                                   _155D1FileName, _155D9FileName,
                                   Quit);

            end;

          {FXX05111998-5: Include an overall total.}
          {FXX08201999-6: Add the special fees to the grand totals.}

        If (Quit or ExtractCancelled)
          then MessageDlg('The 147 and 155 files were NOT created successfully.', mtError, [mbOK], 0)
          else
            begin
              MessageDlg('The 147 and 155 files were created successfully.' + #13 + #13 +
                         'Total Special Districts = ' +
                         FormatFloat(CurrencyDecimalDisplay, TotalSpecialDistricts) + #13 +
                         'Total Exemptions = ' +
                         FormatFloat(CurrencyDecimalDisplay, TotalExemptions) + #13 +
                         'Total Special Fees = ' +
                         FormatFloat(CurrencyDecimalDisplay, TotalSpecialFees) + #13 +
                         'Total Base Tax = ' +
                         FormatFloat(CurrencyDecimalDisplay, TotalTax) + #13 + #13 +
                         'Grand Total Tax = ' +
                         FormatFloat(CurrencyDecimalDisplay, (TotalSpecialDistricts + TotalTax +
                                                              TotalSpecialFees)),
                         mtInformation, [mbOK], 0);

                {CHG03232004-4(2.08): Change the email sending process and add it to all needed places.}

(*              If (MessageDlg('Do you want to email the billing files?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
                then
                  begin
                    ExtractDir := GlblDrive + ':' + GlblExportDir;
                    SelectedFiles := TStringList.Create;
                    TempFileName := ExtractDir + 'RPS147D1';
                    SelectedFiles.Add(TempFileName);
                    TempFileName := ExtractDir + 'RPS155D1';
                    SelectedFiles.Add(TempFileName);

                    ZipFileName := Trim(GlblMunicipalityName) +
                                   '_Billing_Files_' +
                                   MakeMMDDYYYYDate(Date) +
                                   '.zip';
                    ZipFileName := StringReplace(ZipFileName, ' ', '_', [rfReplaceAll]);

                    MailSubject := Trim(GlblMunicipalityName) + ' billing files extract ' + DateToStr(Date);

                    EMailFile(Self, ExtractDir, ExtractDir, ZipFileName, MailSubject, SelectedFiles, True);
                    SelectedFiles.Free;

                  end;  {If (MessageDlg('Do you want to email this file?' + #13 +} *)

                {CHG05131999-3: See if they want to copy\zip the file.}
                {CHG08301999-1: Change zip\copy to allow selections from other dirs.}
                {FXX08162007-1(2.11.3.2): Load the box with the file names that they assigned.}

              If (MessageDlg('Do you want to copy\zip the billing files to another drive or disk?',
                              mtConfirmation, [mbYes, mbNo], 0) = idYes)
                then
                  with ZipCopyDlg do
                    begin
                      InitialDrive := GlblDrive;
                      InitialDir := GlblExportDir;

                        {FXX05162008(2.13.1.2): Have it load the actual file name.}

                      SelectFile(_147FileName);
                      SelectFile(_155D1FileName);
                      SelectFile(_155D9FileName);
                      Execute;

                    end;  {with ZipCopyDlg do}

            end;  {else of If (Quit or ExtractCancelled)}

        BLHeaderTaxTable.Close;
        BLGeneralTaxTable.Close;
        BLExemptionTaxTable.Close;
        BLSpecialDistrictTaxTable.Close;
        BLSpecialFeeTaxTable.Close;

      end;  {If OKToCreateFiles}

end;  {StartButtonClick}

{===================================================================}
Procedure TRPS155FileExtractForm.FormClose(    Sender: TObject;
                                           var Action: TCloseAction);

begin
  FreeTList(GeneralRateList, SizeOf(GeneralRateRecord));
  FreeTList(SDRateList, SizeOf(SDRateRecord));
  FreeTList(EXRateList, SizeOf(PEXRateRecord));

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}



end.