unit Coop_TaxRateCopy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Wwtable, StdCtrls, wwdblook, Buttons;

type
  TfmCopyTaxRatesToCoopRoll = class(TForm)
    Label1: TLabel;
    btnCopy: TBitBtn;
    GroupBox1: TGroupBox;
    Label18: TLabel;
    Label17: TLabel;
    cbCollectionType: TwwDBLookupCombo;
    edAssessmentYear: TEdit;
    tbBillCycleTypes: TwwTable;
    dsBillCycleTypes: TDataSource;
    procedure btnCopyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils,
     Preview, PASTypes, DataAccessUnit;

{$R *.DFM}

{============================================================}
Procedure CopyBillInformation(sSourceAssessmentYear : String;
                              sCollectionType : String;
                              iCollectionNumber : Integer;  {0 = all collections for the year \ type}
                              sDestinationAssessmentYear : String;
                              sSourceDatabaseName : String;
                              sDestinationDatabaseName : String;
                              bDisplayMessage : Boolean);

var
  I, iEndCollectionNumber : Integer;
  fHomesteadRate, fNonhomesteadRate : Double;
  iMonth, iDay, iYear : Word;
  dtTempDate : TDateTime;
  sTempFieldName : String;
  bAssessmentYearsDifferent : Boolean;
  tbSourceCycleHeader, tbSourceCycleDetails,
  tbSourceGeneralRates, tbSourceSpecialDistrictRates,
  tbSourceSpecialFeeRates, tbSourceArrearsMessage,
  tbDestinationCycleHeader, tbDestinationCycleDetails,
  tbDestinationGeneralRates, tbDestinationSpecialDistrictRates,
  tbDestinationSpecialFeeRates, tbDestinationArrearsMessage : TTable;

begin
  If _Compare(iCollectionNumber, 0, coEqual)
    then iEndCollectionNumber := 999
    else iEndCollectionNumber := iCollectionNumber;

  bAssessmentYearsDifferent := _Compare(sSourceAssessmentYear, sDestinationAssessmentYear, coNotEqual);

  tbSourceCycleHeader := TTable.Create(nil);
  tbSourceCycleDetails := TTable.Create(nil);
  tbSourceGeneralRates := TTable.Create(nil);
  tbSourceSpecialDistrictRates := TTable.Create(nil);
  tbSourceSpecialFeeRates := TTable.Create(nil);
  tbSourceArrearsMessage := TTable.Create(nil);

  tbDestinationCycleHeader := TTable.Create(nil);
  tbDestinationCycleDetails := TTable.Create(nil);
  tbDestinationGeneralRates := TTable.Create(nil);
  tbDestinationSpecialDistrictRates := TTable.Create(nil);
  tbDestinationSpecialFeeRates := TTable.Create(nil);
  tbDestinationArrearsMessage := TTable.Create(nil);

  _OpenTable(tbSourceCycleHeader, BillControlHeaderTableName,
             sSourceDatabaseName, 'BYYEAR_COLLTYPE_NUM',
             NoProcessingType, []);

  _OpenTable(tbSourceCycleDetails, BillControlDetailTableName,
             sSourceDatabaseName, 'BYYEAR_COLLTYPE_COLLNO_SWIS',
             NoProcessingType, []);

  _OpenTable(tbSourceGeneralRates, BillGeneralRateTableName,
             sSourceDatabaseName, 'BYYEAR_COLLTYPE_NUM_ORDER',
             NoProcessingType, []);

  _OpenTable(tbSourceSpecialDistrictRates, BillSpecialDistrictRateTableName,
             sSourceDatabaseName, 'BYYEAR_TYPE_NUM_SD_EX_CM',
             NoProcessingType, []);

  _OpenTable(tbSourceSpecialFeeRates, BillSpecialFeeRateTableName,
             sSourceDatabaseName, 'BYYEAR_TYPE_NUM_ORDER',
             NoProcessingType, []);

  _OpenTable(tbSourceArrearsMessage, BillArrearsMessageTableName,
             sSourceDatabaseName, 'BYTAXROLLYR_COLLTYPE_COLLNO',
             NoProcessingType, []);

  _OpenTable(tbDestinationCycleHeader, BillControlHeaderTableName,
             sDestinationDatabaseName, '',
             NoProcessingType, []);

  _OpenTable(tbDestinationCycleDetails, BillControlDetailTableName,
             sDestinationDatabaseName, '',
             NoProcessingType, []);

  _OpenTable(tbDestinationGeneralRates, BillGeneralRateTableName,
             sDestinationDatabaseName, '',
             NoProcessingType, []);

  _OpenTable(tbDestinationSpecialDistrictRates, BillSpecialDistrictRateTableName,
             sDestinationDatabaseName, '',
             NoProcessingType, []);

  _OpenTable(tbDestinationSpecialFeeRates, BillSpecialFeeRateTableName,
             sDestinationDatabaseName, '',
             NoProcessingType, []);

  _OpenTable(tbDestinationArrearsMessage, BillArrearsMessageTableName,
             sDestinationDatabaseName, '',
             NoProcessingType, []);

    {Set the ranges to copy.}

(*  _SetRange(tbSourceCycleHeader, [sSourceAssessmentYear, sCollectionType, iCollectionNumber],
            [sSourceAssessmentYear, sCollectionType, iEndCollectionNumber], '', []);

  _SetRange(tbSourceCycleDetails, [sSourceAssessmentYear, sCollectionType, iCollectionNumber, ''],
            [sSourceAssessmentYear, sCollectionType, iEndCollectionNumber, '999999'], '', []);

  _SetRange(tbSourceGeneralRates, [sSourceAssessmentYear, sCollectionType, iCollectionNumber, 0],
            [sSourceAssessmentYear, sCollectionType, iEndCollectionNumber, 999], '', []);

  _SetRange(tbSourceSpecialDistrictRates, [sSourceAssessmentYear, sCollectionType, iCollectionNumber, '', '', ''],
            [sSourceAssessmentYear, sCollectionType, iEndCollectionNumber, 'ZZZZZ', '', ''], '', []);

  _SetRange(tbSourceSpecialFeeRates, [sSourceAssessmentYear, sCollectionType, iCollectionNumber, 0],
            [sSourceAssessmentYear, sCollectionType, iEndCollectionNumber, 999], '', []);

  _SetRange(tbSourceArrearsMessage, [sSourceAssessmentYear, sCollectionType, iCollectionNumber],
            [sSourceAssessmentYear, sCollectionType, iEndCollectionNumber], '', []); *)

    {Do the copy.}

  DeleteTable(tbDestinationCycleHeader);

  DeleteTable(tbDestinationCycleDetails);

  DeleteTable(tbDestinationGeneralRates);

  DeleteTable(tbDestinationSpecialDistrictRates);

  DeleteTable(tbDestinationSpecialFeeRates);

  DeleteTable(tbDestinationArrearsMessage);


  CopyTableRange(tbSourceCycleHeader, tbDestinationCycleHeader,
                 '', [], []);

  CopyTableRange(tbSourceCycleDetails, tbDestinationCycleDetails,
                 '', [], []);

  CopyTableRange(tbSourceGeneralRates, tbDestinationGeneralRates,
                 '', [], []);

  CopyTableRange(tbSourceSpecialDistrictRates, tbDestinationSpecialDistrictRates,
                 '', [], []);

  CopyTableRange(tbSourceSpecialFeeRates, tbDestinationSpecialFeeRates,
                 '', [], []);

  CopyTableRange(tbSourceArrearsMessage, tbDestinationArrearsMessage,
                 '', [], []);

(*  with tbSourceGeneralRates do
    begin
      First;

      while (not EOF) do
        begin
          If bAssessmentYearsDifferent
            then
              begin
                If (_Compare(FieldByName('GeneralTaxType').AsString, 'SR', coEqual) or  {Relevies}
                    _Compare(FieldByName('GeneralTaxType').AsString, 'VR', coEqual))
                  then
                    begin
                      fHomesteadRate := 1;
                      If GlblMunicipalityUsesTwoTaxRates
                        then fNonhomesteadRate := 1
                        else fNonhomesteadRate := 0;

                    end
                  else
                    begin
                      fHomesteadRate := 0;
                      fNonhomesteadRate := 0;
                    end;

              end
            else
              begin
                fHomesteadRate := FieldByName('HomesteadRate').AsFloat;
                fNonhomesteadRate := FieldByName('NonhomesteadRate').AsFloat;
              end;

            {Also Copy forward old levy amount.}

          CopyTable_OneRecord(tbSourceGeneralRates, tbDestinationGeneralRates,
                              ['TaxRollYr', 'HomesteadRate',
                               'NonhomesteadRate', 'PriorTaxLevy',
                               'CurrentTaxLevy', 'EstimatedStateAid'],
                              [sDestinationAssessmentYear, FloatToStr(fHomesteadRate),
                               FloatToStr(fNonhomesteadRate), FieldByName('CurrentTaxLevy').AsString,
                               '0', '0']);

          Next;

        end;  {while (not EOF) do}

    end;  {with tbSourceGeneralRates do}   *)

    {Only copy the special district rates if this is a copy between rolls (i.e. the same assessment year).}

(*  If not bAssessmentYearsDifferent
    then
      with tbSourceSpecialDistrictRates do
        begin
          First;

          while (not EOF) do
            begin
              If bAssessmentYearsDifferent
                then
                  begin
                    fHomesteadRate := 0;
                    fNonhomesteadRate := 0;
                  end
                else
                  begin
                    fHomesteadRate := FieldByName('HomesteadRate').AsFloat;
                    fNonhomesteadRate := FieldByName('NonhomesteadRate').AsFloat;
                  end;

              CopyTable_OneRecord(tbSourceSpecialDistrictRates, tbDestinationSpecialDistrictRates,
                                  ['TaxRollYr', 'HomesteadRate',
                                   'NonhomesteadRate', 'PriorTaxLevy', 'CurrentTaxLevy'],
                                  [sDestinationAssessmentYear, FloatToStr(fHomesteadRate),
                                   FloatToStr(fNonhomesteadRate), FieldByName('CurrentTaxLevy').AsString, '0']);

              Next;

            end;  {while (not EOF) do}

        end;  {with tbSourceSpecialDistrictRates do}    *)

(*  CopyTableRange(tbSourceSpecialFeeRates, tbDestinationSpecialFeeRates,
                 'TaxRollYr', ['TaxRollYr'], [sDestinationAssessmentYear]);

  CopyTableRange(tbSourceArrearsMessage, tbDestinationArrearsMessage,
                 'TaxRollYr', ['TaxRollYr'], [sDestinationAssessmentYear]);

    {Update dates if necessary.}

  If bAssessmentYearsDifferent
    then
      begin
        _SetRange(tbDestinationCycleHeader, [sDestinationAssessmentYear, sCollectionType, iCollectionNumber],
                  [sDestinationAssessmentYear, sCollectionType, iEndCollectionNumber], '', []);

        with tbDestinationCycleHeader do
          while (not EOF) do
            begin
              try
                Edit;

                For I := 1 to 8 do
                  begin
                    sTempFieldName := 'Paydate' + IntToStr(I);

                    If _Compare(FieldByName(sTempFieldName).AsString, coNotBlank)
                      then
                        begin
                          dtTempDate := FieldByName(sTempFieldName).AsDateTime;
                          DecodeDate(dtTempDate, iYear, iMonth, iDay);
                          iYear := iYear + 1;
                          dtTempDate := EncodeDate(iYear, iMonth, iDay);
                          FieldByName(sTempFieldName).AsDateTime := dtTempDate;

                        end;  {If (Deblank(FieldByName(TempStr).Text) <> '')}

                  end;  {For I := 1 to 8 do}

              except
              end;

            Next;

          end;  {while (not EOF) do}

      end;  {If bAssessmentYearsDifferent}*)

  If bDisplayMessage
    then MessageDlg('The billing setup from the main roll has been copied.',
                     mtInformation, [mbOK], 0);

end;  {CopyOneBillCycle}

{===============================================================}
Procedure TfmCopyTaxRatesToCoopRoll.FormCreate(Sender: TObject);

begin
  _OpenTablesForForm(Self, NoProcessingType, []);
end;

{============================================================}
Procedure TfmCopyTaxRatesToCoopRoll.btnCopyClick(Sender: TObject);

var
  sAssessmentYear, sCollectionType : String;

begin
(*  sAssessmentYear := edAssessmentYear.Text;
  sCollectionType := cbCollectionType.Text;

  If (_Compare(sAssessmentYear, coBlank) or
      _Compare(sCollectionType, coBlank))
    then MessageDlg('Please enter an assessment year and collection type.', mtError, [mbOK], 0)
    else
      begin *)
        CopyBillInformation(sAssessmentYear, sCollectionType, 0,
                            sAssessmentYear, 'PropertyAssessmentSystem',
                            'PropertyAssessmentSystemCoops', False);

        MessageDlg('The billing information has been copied.', mtInformation, [mbOK], 0);

        Close;

(*      end;  {else of If (_Compare(sAssessmentYear, coBlank) or...} *)

end;  {btnCopyClick}

end.
