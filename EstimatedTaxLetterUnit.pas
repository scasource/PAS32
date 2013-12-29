unit EstimatedTaxLetterUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBTables;

type
  TEstimatedTaxLetterForm = class(TForm)
    Label1: TLabel;
    EditNewAssessmentAmount: TEdit;
    PrintButton: TBitBtn;
    RAVEEstimatedTaxLetterHeaderTable: TTable;
    RAVEEstimatedTaxLetterDetailsTable: TTable;
    ParcelTable: TTable;
    SwisCodeTable: TTable;
    AssessmentYearControlTable: TTable;
    procedure PrintButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SwisSBLKey : String;
  end;

var
  EstimatedTaxLetterForm: TEstimatedTaxLetterForm;

implementation

{$R *.DFM}

uses PASUtils, GlblVars, GlblCnst, PASTypes, DataAccessUnit,
     WinUtils, Utilitys, UtilEstimatedTaxComputation;

{==============================================================}
Procedure FillInHeaderInformation(ParcelTable : TTable;
                                  SwisCodeTable : TTable;
                                  AssessmentYearControlTable : TTable;
                                  RAVEEstimatedTaxLetterHeaderTable : TTable;
                                  SwisSBLKey : String;
                                  NewAssessedValue : LongInt;
                                  CombinedTaxRate : Double;
                                  EstimatedTax : Double);

var
  NAddrArray : NameAddrArray;

begin
  GetNameAddress(ParcelTable, NAddrArray);

  with RAVEEstimatedTaxLetterHeaderTable do
    try
      Insert;
      FieldByName('LetterDate').Text := DateToStr(Date);
      FieldByName('ParcelID').Text := ConvertSwisSBLToDashDot(SwisSBLKey);
      FieldByName('AccountNumber').Text := ParcelTable.FieldByName('AccountNo').Text;
      FieldByName('LegalAddress').Text := GetLegalAddressFromTable(ParcelTable);
      FieldByName('SwisCode').Text := ParcelTable.FieldByName('SwisCode').Text;
      FieldByName('SchoolCode').Text := ParcelTable.FieldByName('SchoolCode').Text;
      FieldByName('PropertyClass').Text := ParcelTable.FieldByName('PropertyClassCode').Text;
      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('MortgageNumber').Text := ParcelTable.FieldByName('MortgageNumber').Text;
      FieldByName('BankCode').Text := ParcelTable.FieldByName('BankCode').Text;
      FieldByName('FullMarketValue').Text := FormatFloat(CurrencyDisplayNoDollarSign,
                                                         ComputeFullValue(NewAssessedValue,
                                                                          SwisCodeTable,
                                                                          ParcelTable.FieldByName('PropertyClassCode').Text,
                                                                          ParcelTable.FieldByName('OwnershipCode').Text,
                                                                          False));
      FieldByName('ValuationDate').Text := AssessmentYearControlTable.FieldByName('ValuationDate').Text;
      FieldByName('AssessedValue').Text := FormatFloat(CurrencyDisplayNoDollarSign, NewAssessedValue);
      FieldByName('UniformPercentOfValue').Text := FormatFloat(DecimalEditDisplay,
                                                               SwisCodeTable.FieldByName('UniformPercentValue').AsFloat);
      FieldByName('NameAddr1').Text := NAddrArray[1];
      FieldByName('NameAddr2').Text := NAddrArray[2];
      FieldByName('NameAddr3').Text := NAddrArray[3];
      FieldByName('NameAddr4').Text := NAddrArray[4];
      FieldByName('NameAddr5').Text := NAddrArray[5];
      FieldByName('NameAddr6').Text := NAddrArray[6];
      FieldByName('CombinedTaxRate').Text := FormatFloat(DecimalDisplay, CombinedTaxRate);
      FieldByName('EstimatedTax').Text := FormatFloat(DecimalDisplay, EstimatedTax);
      Post;
    except
    end;  {with RAVEEstimatedTaxLetterHeaderTable do}

end;  {FillInHeaderInformation}

{==============================================================}
Procedure FillInDetailInformation(    ParcelTable : TTable;
                                      RAVEEstimatedTaxLetterDetailTable : TTable;
                                      SwisSBLKey : String;
                                      NewAssessedValue : LongInt;
                                  var CombinedTaxRate : Double;
                                  var EstimatedTax : Double);

var
  TaxInformationList : TList;
  I : Integer;

begin
  TaxInformationList := TList.Create;

  EstimatedTax := GetProjectedTaxInformation(NewAssessedValue, 0,
                                             SwisSBLKey,
                                             ParcelTable.FieldByName('SchoolCode').Text,
                                             TaxInformationList,
                                             [ltMunicipal, ltSchool],
                                             trAny,
                                             False);

  For I := 0 to (TaxInformationList.Count - 1) do
    with TaxInformationPointer(TaxInformationList[I])^, RAVEEstimatedTaxLetterDetailTable do
      try
        Insert;
        FieldByName('LevyDescription').AsString := LevyCode + '  ' + LevyDescription;
        FieldByName('TaxableValue').AsString := FormatFloat(CurrencyDisplayNoDollarSign, TaxableValue);
        FieldByName('TaxRate').AsString := FormatFloat(ExtendedDecimalDisplay, TaxRate);
        FieldByName('TaxRateUnits').AsString := TaxRateDescription;

        If _Compare(ExtensionCode, SDistEcTO, coEqual)
          then CombinedTaxRate := CombinedTaxRate + TaxRate;

        FieldByName('TaxAmount').AsString := FormatFloat(DecimalDisplay, TaxAmount);
        Post;
      except
      end;

  FreeTList(TaxInformationList, SizeOf(TaxInformationRecord));

end;  {FillInDetailInformation}

{==============================================================}
Procedure TEstimatedTaxLetterForm.PrintButtonClick(Sender: TObject);

var
  NewAssessedValue : LongInt;
  CombinedTaxRate, EstimatedTax : Double;
  RAVEEstimatedTaxLetterHeaderTableSortFileName,
  RAVEEstimatedTaxLetterDetailsTableSortFileName : String;
  Quit : Boolean;

begin
  NewAssessedValue := 0;

  try
    NewAssessedValue := StrToInt(EditNewAssessmentAmount.Text);
  except
    MessageDlg('Please enter a valid assessment amount.', mtError, [mbOK], 0);
    EditNewAssessmentAmount.SetFocus;
    Abort;
  end;

  CopyAndOpenSortFile(RAVEEstimatedTaxLetterHeaderTable,
                      'RAVE_EstTaxLetterHdr',
                      RAVEEstimatedTaxLetterHeaderTable.TableName,
                      RAVEEstimatedTaxLetterHeaderTableSortFileName,
                      False, True, Quit);

  CopyAndOpenSortFile(RAVEEstimatedTaxLetterDetailsTable,
                      'RAVE_EstTaxLetterDtl',
                      RAVEEstimatedTaxLetterDetailsTable.TableName,
                      RAVEEstimatedTaxLetterDetailsTableSortFileName,
                      False, True, Quit);

  _OpenTablesForForm(Self, ThisYear, [toNoReopen]);

  _OpenTable(ParcelTable, ParcelTableName, '', '', NextYear, []);

  _Locate(ParcelTable, [GlblNextYear, SwisSBLKey], '', [loParseSwisSBLKey]);
  _Locate(SwisCodeTable, [Copy(SwisSBLKey, 1, 6)], '', []);
  _Locate(AssessmentYearControlTable, [GlblThisYear], '', []);

  FillInDetailInformation(ParcelTable, RAVEEstimatedTaxLetterDetailsTable, SwisSBLKey, NewAssessedValue,
                          CombinedTaxRate, EstimatedTax);

  FillInHeaderInformation(ParcelTable, SwisCodeTable, AssessmentYearControlTable,
                          RAVEEstimatedTaxLetterHeaderTable, SwisSBLKey,
                          NewAssessedValue, CombinedTaxRate, EstimatedTax);

  _CloseTablesForForm(Self);

  LaunchRAVE('letter_yorktown_what_if.rav', ['HEADER', 'DETAIL'],
             [RAVEEstimatedTaxLetterHeaderTableSortFileName,
              RAVEEstimatedTaxLetterDetailsTableSortFileName],
             rltLetter);

  Close;

end;  {PrintButtonClick}

end.
