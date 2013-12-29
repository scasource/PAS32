unit Bcollctl;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,PasTypes,types,
  wwdblook, Mask, TabNotBk, ComCtrls;

type
  TBillFileControlForm = class(TForm)
    BillCtlDataSource: TwwDataSource;
    BillCtlTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    BillCollTypeLookupTable: TwwTable;
    CollectionLookupTable: TwwTable;
    CollDtlDataSource: TwwDataSource;
    CollDtlTable: TwwTable;
    SwissCdLookupTable: TwwTable;
    SchlCodeLookupTable: TwwTable;
    SDLookupDataSource: TwwDataSource;
    SchCodeDataSource: TwwDataSource;
    BillCtlLookupTable: TwwTable;
    NotebookChangeTimer: TTimer;
    BillCollArrearsTable: TwwTable;
    BillCollArrearsDataSource: TwwDataSource;
    BillControlLookupTable: TTable;
    GeneralRatesTable: TTable;
    GeneralRatesLookupTable: TTable;
    SpecialChargesTable: TTable;
    SpecialChargesLookupTable: TTable;
    ArrearsMessageLookupTable: TTable;
    ParcelTable: TTable;
    Panel3: TPanel;
    AddNewBillCycleButton: TBitBtn;
    CtlRecDBNavigator: TDBNavigator;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label1: TLabel;
    CollectionNumber: TDBEdit;
    NoPaymentsDBEdit: TDBEdit;
    TaxRollYr: TDBEdit;
    CollTypeDBLookupCombo: TwwDBLookupCombo;
    Panel5: TPanel;
    Notebook: TTabbedNotebook;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Pen8: TDBEdit;
    Pen7: TDBEdit;
    Pen6: TDBEdit;
    Pen5: TDBEdit;
    Pen4: TDBEdit;
    Pen3: TDBEdit;
    Pen2: TDBEdit;
    Pen1: TDBEdit;
    Date8: TDBEdit;
    Date7: TDBEdit;
    Date6: TDBEdit;
    Date5: TDBEdit;
    Date4: TDBEdit;
    Date3: TDBEdit;
    Date2: TDBEdit;
    Date1: TDBEdit;
    SDPaymentTypeRadioGroup: TDBRadioGroup;
    ApplyPenniesOptionRadioGroup: TDBRadioGroup;
    BillNumberRadioGroup: TDBRadioGroup;
    MinimumMaximumGroupBox: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Amount: TLabel;
    UseMinimumOptionCheckBox: TDBCheckBox;
    EditMinimumAmount: TDBEdit;
    UseMaximumOptionCheckBox: TDBCheckBox;
    EditMaximumAmount: TDBEdit;
    MiscGroupBox: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    CalcProrataOptionCheckBox: TDBCheckBox;
    UseArrearsFlagCheckBox: TDBCheckBox;
    RS9BankCodeEdit: TDBEdit;
    DtlsNavLabel: TLabel;
    CollDtlDBGrid: TwwDBGrid;
    SwCodeDBLookupCombo: TwwDBLookupCombo;
    SchlCdDBLookupCombo: TwwDBLookupCombo;
    DtlsDBNavigator: TDBNavigator;
    Label25: TLabel;
    ArrearsMemo: TDBMemo;
    SaveArrearsButton: TBitBtn;
    CancelArrearsButton: TBitBtn;
    Label26: TLabel;
    cbx_MaximumAppliesToCoops: TDBCheckBox;
    tbSchoolCodes: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CloseButtonClick(Sender: TObject);
    procedure BillCtlTableAfterInsert(DataSet: TDataset);
    procedure CollDtlTableBeforePost(DataSet: TDataset);
    procedure SwCodeDBLookupComboExit(Sender: TObject);
    procedure CollDtlTableBeforeInsert(DataSet: TDataset);
    procedure BillCtlTableBeforePost(DataSet: TDataset);
    procedure NoPaymentsDBEditChange(Sender: TObject);
    procedure CollTypeDBLookupComboChange(Sender: TObject);
    procedure UseMinimumOptionCheckBoxClick(Sender: TObject);
    procedure UseMaximumOptionCheckBoxClick(Sender: TObject);
    procedure NotebookChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure NotebookChangeTimerTimer(Sender: TObject);
    procedure NotebookEnter(Sender: TObject);
    procedure SaveArrearsButtonClick(Sender: TObject);
    procedure CancelArrearsButtonClick(Sender: TObject);
    procedure BillCtlTableAfterEdit(DataSet: TDataset);
    procedure BillCtlTableAfterDelete(DataSet: TDataset);
    procedure BillCtlTableBeforeDelete(DataSet: TDataset);
    procedure CollDtlTableNewRecord(DataSet: TDataset);
    procedure FormActivate(Sender: TObject);
    procedure BillCollArrearsTableNewRecord(DataSet: TDataSet);
    procedure BillCtlTableAfterPost(DataSet: TDataSet);
    procedure AddNewBillCycleButtonClick(Sender: TObject);
    procedure BillCtlTableAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }

    CollectionType, OldCollectionType : String;
    CollectionNum, OldCollectionNum : Integer;
    CopyingSetup, InitializingForm : Boolean;
    TaxRollYear : String;  {What tax roll year should we use for this collection?}
    ProcessingType : Integer;
    NewCycleAdded : Boolean;

    UnitName : String;
    ShowEditWarningMessage : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;  {Open the tables and setup.}
    Function ValidSwis(Swcode : String) : boolean;
  end;

implementation

uses GlblVars, WinUtils, Utilitys,GlblCnst,PasUtils, UTILBILL, Prog, DataAccessUnit;

{$R *.DFM}

{========================================================}
Procedure TBillFileControlForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TBillFileControlForm.InitializeForm;

{FXX12201997-3: TaxRollYear was declared local in addition to above, so
                setting it here meant it was undefined elsewhere.}

var
  I : Integer;

begin
  UnitName := 'BCOLLCTL.PAS';  {mmm}
  InitializingForm := True;
  CopyingSetup := False;
  ShowEditWarningMessage := True;

    {FXX06231998-3: Put in changes to allow for Westchester billing off NY.}

  TaxRollYear := DetermineBillingTaxYear;
  ProcessingType := GetProcessingTypeForTaxRollYear(TaxRollYear);

    {Open the tables.}

  If (FormAccessRights = raReadOnly)
    then BillCtlTable.ReadOnly := True;  {mmm}

  OpenTablesForForm(Self, ProcessingType);

    {FXX11151999-3: Go to the most recent billing cycle.}

  BillCtlTable.Last;

  If (GlblProcessingType = History)
    then
      begin
        MessageDlg('A tax bill cycle can only be created in this year processing.' + #13 +
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

  If (CollTypeDBLookupCombo.Text = 'SC')
    then
      begin
         {set up school appearance on screen}
        CollDtlTable.FieldByName('SchoolCode').Index := 0;
        CollDtlTable.FieldByName('SwisCode').Index := 1;
        Notebook.Pages[3] := 'School Code Sel';
        DtlsNavLabel.Caption := '<= School Code Navigator';
      end
    else
      begin
          {setup munic/village appearance on screen}
        Notebook.Pages[3] := 'Swis Code Sel';
        DtlsNavLabel.Caption := '<= Swis Code Navigator';
        CollDtlTable.FieldByName('SchoolCode').Index := 1;
        CollDtlTable.FieldByName('SwisCode').Index := 0;

      end;  {else of If (CollTypeDBLookupCombo.Text = 'SC')}

    {synchronize dtls grid display to master collection record}

  If (CollTypeDBLookupCombo.Text) = 'SC'
    then CollDtlTAble.IndexName := 'BYYEAR_TYPE_NO_SCHOOL_SWIS'
    else CollDtlTable.IndexName := 'BYYEAR_COLLTYPE_COLLNO_SWIS';

    {FXX11151999-2: Only force an assessment year if no previous records.}

  If BillCtlTable.EOF
    then TaxRollYr.Text := TaxRollYear;

  InitializingForm := False;
  NewCycleAdded := False;

end;  {InitializeForm}

{=============================================================}
Function TBillFileControlForm.ValidSwis(Swcode : String) : boolean;
(*Var
  SDLen : Integer;
  TempSWcode : String;
  ValidSW,
  SWFound : Boolean; *)

Begin
  Result := True;
(*If (Deblank(SwCode) = '')
           AND
           {allow blank swis for school collection}
   (Take(2,CollTypeDBLookupCombo.Text) <> 'SC')
 then ValidSW := False
 else If (Length(Rtrim(SWCode)) < 6)
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
                Try
                FindNearestOld(SwissCdLookupTable, ['SwisCode'],
                               [SWcode]);
                Except on EDataBAseError
                do
                 begin
                 SystemSupport(002, SwissCdLookupTable, 'Error Accessing Swis Code table.', UnitName,
                  GlblErrorDlgBox);

                 end;
                end;
               TempSWCode := Take(SDLen,SwissCdLookupTable.FieldByName('SwisCode').Text);
               If (Take(SDLen,TempSwCode)) =
                 (TAke(SDLen,SWCode))
                 then VAlidSW := True
                 else ValidSW := False;
               end;

            end
            else
            begin {validate 6 char swis}
             SWFound := FindKeyOld(SwissCdLookupTable, ['SwisCode'],
                                   [SWcode]);
            VAlidSW := SwFound;
            end;
ValidSwis := ValidSW; *)
end;

{===================================================================}
Procedure TBillFileControlForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{===================================================================}
Procedure TBillFileControlForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

procedure TBillFileControlForm.CloseButtonClick(Sender: TObject);
begin
Close;
end;

{======================================================================}
Procedure TBillFileControlForm.BillCtlTableAfterInsert(DataSet: TDataset);

begin
  If not CopyingSetup
    then
      begin
        TaxRollYr.ReadOnly := False;
        TaxRollYr.Text := TaxRollYear;  {always set year to this year}
        TaxRollYr.ReadOnly := True;     {make sure user does not alter tx year}
        BillCtlTable.FieldByName('TaxRollYr').AsString := TaxRollYear;  {so be sure}
        TAxRollYr. Repaint;
        NewCycleAdded := True;

      end;  {If not CopyingSetup}

end;  {BillCtlTableAfterInsert}

{======================================================================}
Procedure TBillFileControlForm.BillCtlTableAfterEdit(DataSet: TDataset);

begin
    {FXX04081999-5: Warn if modifying old bill cycle.}

  with BillCtlTable do
    If (ShowEditWarningMessage and
        (MessageDlg('Warning! You are attempting to modify an existing bill cycle:' + #13 +
                    'Tax Year - ' + FieldByName('TaxRollYr').Text +
                    '  Collection Type - ' + FieldByName('CollectionType').Text +
                    '  Collection # - ' + FieldByName('CollectionNo').Text + #13 +
                    'Is this correct?', mtConfirmation, [mbYes, mbNo], 0) = idNo))
      then BillCtlTable.Cancel;

end;  {BillCtlTableAfterEdit}

{======================================================================}
Procedure TBillFileControlForm.CollTypeDBLookupComboChange(Sender: TObject);

var
  Found, Done, FirstTimeThrough : Boolean;
  PriorTaxYear : String;
  CollectionType : String;
  I, StartNo, CollectionNum : Integer;
  Year, Month, Day : Word;
  TempStr, HomesteadRateStr, NonhomesteadRateStr, sSchoolCode : String;
  TempDate : TDateTime;
  BasicSTARCap, EnhancedSTARCap : Double;

begin
  CollectionType := CollTypeDBLookupCombo.Text;

  If not CopyingSetup
    then
      begin
        If (BillCtlTable.State = dsInsert)
          then
            begin
                  {find any rec for this billing type?}

              SetRangeOld(BillCtlLookupTable,
                          ['TaxRollYr', 'CollectionType'],
                          [Take(4, TaxRollYear),
                           Take(2, CollectionType)],
                          [Take(4, TaxRollYear),
                           Take(2, CollectionType)]);
                           
              Found := FindKeyOld(CollectionLookupTable,
                                  ['TaxRollYr', 'CollectionType'],
                                  [TaxRollYear, CollectionType]);

              If not Found
                then StartNo := 1
                else
                  begin
                    CollectionLookupTable.IndexName := 'BYYEAR_COLLTYPE_NUM';

                    CollectionLookupTable.Last;

                      {bump start no from first record}
                      {Search until the end of the range.}

                    StartNo := CollectionLookupTable.FieldByName('CollectionNo').AsInteger + 1;

                  end;  {else of If not Found}

              CollectionNumber.ReadOnly := False;
              CollectionNumber.Text := IntToStr(StartNo);

              BillCtlTable.FieldByName('CollectionNo').AsInteger := StartNo;
              BillCtlTable.FieldByName('TaxRollYr').AsString := TaxRollYear;
              CollectionNumber.ReadOnly := True;
              CollectionNumber.Repaint;

                {FXX07011998-5: Reset the collection number.}

              CollectionNum := StartNo;

                {CHG11151999-1: Allow user to say if they want to copy from an existing
                                template.}

              If (Deblank(CollTypeDBLookupCombo.Text) <> '')
                then
                  begin
                    PriorTaxYear := IntToStr(StrToInt(GlblThisYear) - 1);
                    CollectionType := CollTypeDBLookupCombo.Text;

                    CollectionLookupTable.IndexName := 'BYYEAR_COLLTYPE_NUM';
                    Found := FindKeyOld(CollectionLookupTable,
                                        ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                                        [PriorTaxYear, CollectionType,
                                         IntToStr(CollectionNum)]);
                    If (Found and
                        (MessageDlg('Do you want to start with the billing setup from last year?',
                                    mtConfirmation, [mbYes, mbNo], 0) = idYes))
                      then
                        begin
                            {Copy the control file.}

                          BillCtlTable.Cancel;
                          CopyingSetup := True;

                          CopyTable_OneRecord(CollectionLookupTable, BillCtlTable,
                                              ['TaxRollYr'], [GlblThisYear]);

                            {Move the pay dates ahead one year.}

                          NewCycleAdded := False;
                          ShowEditWarningMessage := False;

                          with BillCtlTable do
                            try
                              Edit;

                              For I := 1 to 8 do
                                begin
                                  TempStr := 'Paydate' + IntToStr(I);

                                  If (Deblank(FieldByName(TempStr).Text) <> '')
                                    then
                                      begin
                                        TempDate := FieldByName(TempStr).AsDateTime;
                                        DecodeDate(TempDate, Year, Month, Day);
                                        Year := Year + 1;
                                        TempDate := EncodeDate(Year, Month, Day);
                                        FieldByName(TempStr).AsDateTime := TempDate;

                                      end;  {If (Deblank(FieldByName(TempStr).Text) <> '')}

                                end;  {For I := 1 to 8 do}

                            except
                              SystemSupport(003, BillCtlTable, 'Error updating payment dates.',
                                            UnitName, GlblErrorDlgBox);
                            end;

                          ShowEditWarningMessage := True;

                            {Position to this new record.}

                          FindKeyOld(BillCtlTable,
                                     ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                                     [TaxRollYear, CollectionType, IntToStr(CollectionNum)]);

                          NoPaymentsDBEdit.Text := BillCtlTable.FieldByName('NumberOfPayments').Text;
                          NoPaymentsDBEditChange(Sender);

                            {Now copy the details.}

                          CollDtlTable.Cancel;
                          BillControlLookupTable.CancelRange;

                          SetRangeOld(BillControlLookupTable,
                                      ['TaxRollYr', 'CollectionType', 'CollectionNo', 'SwisCode'],
                                      [PriorTaxYear, CollectionType, IntToStr(CollectionNum), '      '],
                                      [PriorTaxYear, CollectionType, IntToStr(CollectionNum), '999999']);
                          sSchoolCode := BillControlLookupTable.FieldByName('SchoolCode').AsString;

                          CopyTableRange(BillControlLookupTable, CollDtlTable,
                                         'TaxRollYr', ['TaxRollYr'], [GlblThisYear]);
                          BillControlLookupTable.CancelRange;

                            {Now copy the general rates.}
                            {FXX08082001-2: Wrong field name for SetRange.}

                          SetRangeOld(GeneralRatesLookupTable,
                                      ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
                                      [PriorTaxYear, CollectionType, IntToStr(CollectionNum), '0'],
                                      [PriorTaxYear, CollectionType, IntToStr(CollectionNum), '32000']);

                          Done := False;
                          FirstTimeThrough := True;
                          GeneralRatesLookupTable.First;

                          repeat
                            If FirstTimeThrough
                              then FirstTimeThrough := False
                              else GeneralRatesLookupTable.Next;

                            If GeneralRatesLookupTable.EOF
                              then Done := True;

                            If not Done
                              then
                                begin
                                  If ((GeneralRatesLookupTable.FieldByName('GeneralTaxType').Text = 'SR') or  {School relevy}
                                      (GeneralRatesLookupTable.FieldByName('GeneralTaxType').Text = 'VR'))
                                    then
                                      begin
                                        HomesteadRateStr := '1';
                                        If GlblMunicipalityUsesTwoTaxRates
                                          then NonhomesteadRateStr := '1'
                                          else NonhomesteadRateStr := '0';

                                      end
                                    else
                                      begin
                                        HomesteadRateStr := '0';
                                        NonhomesteadRateStr := '0';
                                      end;

                                    {Also Copy forward old levy amount.}

                                  BasicSTARCap := 0;
                                  EnhancedSTARCap := 0;

                                  _Locate(tbSchoolCodes, [sSchoolCode], '', []);

                                  BasicSTARCap := tbSchoolCodes.FieldByName('BasicSTARCap').AsFloat;
                                  EnhancedSTARCap := tbSchoolCodes.FieldByName('EnhancedSTARCap').AsFloat;

                                  CopyTable_OneRecord(GeneralRatesLookupTable,
                                                      GeneralRatesTable,
                                                      ['TaxRollYr', 'HomesteadRate', 'NonhomesteadRate',
                                                       'PriorTaxLevy', 'CurrentTaxLevy', 'EstimatedStateAid',
                                                       'BasicSTARCap', 'EnhancedSTARCap'],
                                                      [GlblThisYear,
                                                       HomesteadRateStr,
                                                       NonhomesteadRateStr,
                                                       GeneralRatesLookupTable.FieldByName('CurrentTaxLevy').Text,
                                                       '0', '0', FloatToStr(BasicSTARCap), FloatToStr(EnhancedSTARCap)]);

                                end;  {If not Done}

                          until Done;

                          GeneralRatesLookupTable.CancelRange;

                            {Now copy the special charges.}

                          SetRangeOld(SpecialChargesLookupTable,
                                      ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
                                      [PriorTaxYear, CollectionType, IntToStr(CollectionNum), '0'],
                                      [PriorTaxYear, CollectionType, IntToStr(CollectionNum), '32000']);

                          CopyTableRange(SpecialChargesLookupTable, SpecialChargesTable,
                                         'TaxRollYr', ['TaxRollYr'], [GlblThisYear]);
                          SpecialChargesLookupTable.CancelRange;

                            {Now copy the Arrears message.}

                          SetRangeOld(ArrearsMessageLookupTable,
                                      ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                                      [PriorTaxYear, CollectionType, IntToStr(CollectionNum)],
                                      [PriorTaxYear, CollectionType, IntToStr(CollectionNum)]);

                          CopyTableRange(ArrearsMessageLookupTable, BillCollArrearsTable,
                                         'TaxRollYr', ['TaxRollYr'], [GlblThisYear]);
                          ArrearsMessageLookupTable.CancelRange;

                          CopyingSetup := False;

                          MessageDlg('The billing setup from (' + PriorTaxYear +
                                     ' Type: ' + CollectionType +
                                     ' Num: ' + IntToStr(CollectionNum) +
                                     ') has been copied.' + #13 +
                                     'Note that no rates were copied - they are all zero.' + #13 + #13 +
                                     'Please review all billing information.',
                                     mtInformation, [mbOK], 0);

                        end;  {If (Found and ...}

                    CollectionLookupTable.IndexName := 'BYYEAR_COLLTYPE';

                  end;  {If (Deblank(CollTypeDBLookupCombo.Text) <> '')}

            end;  {If (BillCtlTable.State = dsInsert)}

        If not InitializingForm
          then
            begin
(*              If (CollTypeDBLookupCombo.Text = 'SC')
                then
                  begin
                      {set up school appearance on screen}

                    CollDtlTableSchoolCode.Index := 0;
                    CollDtlTableSwisCode.Index := 1;
                    Notebook.Pages[3] := 'School Code Sel';

                      {FXX05081998-1: Need to set the index and range for town or school so
                                      don't get details from other collections.}
                      {FXX08131998-7: Index was wrong.}

                    CollDtlTable.IndexName := 'BYYEAR_TYPE_NO_SCHOOL_SWIS';
                  end
                else
                  begin
                     {setup munic/village appearance on screen}
                    Notebook.Pages[3] := 'Swis Code Selection';
                    CollDtlTableSchoolCode.Index := 1;
                    CollDtlTableSwisCode.Index := 0;

                      {FXX05081998-1: Need to set the index and range for town or school so
                                      don't get details from other collections.}

                    CollDtlTable.IndexName := 'BYYEAR_COLLTYPE_COLLNO_SWIS';

                  end;  {else of If (CollTypeDBLookupCombo.Text = 'SC')} *)

                {Set up the payment information and general options available based on
                 the number of payments.}

              NoPaymentsDBEditChange(Sender);

            end;  {If not InitializingForm}

      end;  {If not CopyingSetup}

end;  {CollTypeDBLookupComboChange}

{======================================================================}
Procedure TBillFileControlForm.CollDtlTableBeforePost(DataSet: TDataset);

begin
    {CHG12191997-1: Instead of telling the person to post the header
                    before the detail, let's just automatically post
                    the header if it is not posted yet.}

  If (BillCtlTable.State in [dsEdit, dsInsert])
    then
      try
        BillCtlTable.Post;
      except
        SystemSupport(200, BillCtlTable, 'Error posting bill control record.',
                      UnitName, GlblErrorDlgBox);
      end;

(*  If Not ValidSwis(CollDtlTAble.FieldByName('SwisCode').text)
   then
   begin
    MessageDlg('You Must Enter A Valid Swis Code.' + #13 +
                'Please Try Again.', mtError, [mbOK], 0);
   Abort;

   end
   else
   begin *)
     {set up rest of key fields for correct collection type}

   CollDtlTAble.FieldByName('TaxRollYr').AsString := Take(4,TaxRollYear);
   CollDtlTAble.FieldByName('CollectionType').AsString := Take(2,CollTypeDBLookupCombo.Text);
   CollDtlTAble.FieldByName('CollectionNo').AsInteger :=
      StrToInt(CollectionNumber.Text);

(*   end; *)

end;

procedure TBillFileControlForm.SwCodeDBLookupComboExit(Sender: TObject);
begin

(*If Not ValidSwis(SwcodeDBLookupCombo.text)
   then
   begin
    MessageDlg('You Must Enter A Valid Swis Code.' + #13 +
                'Please Try Again.', mtError, [mbOK], 0);
    Abort;

   end; *)

end;

{========================================================================}
Procedure TBillFileControlForm.CollDtlTableBeforeInsert(DataSet: TDataset);

begin
  If not CopyingSetup
    then
      begin
         {FXX04231998-3: If the hdr is not posted, then post it.}

        If (BillCtlTable.State in [dsEdit, dsInsert])
          then
            begin
              try
                BillCtlTable.Post;
              except
                SystemSupport(073, BillCtlTable, 'Error posting billing header rec.',
                              UnitName, GlblErrorDlgBox);
              end;

                {FXX07011998-3: Resissue the insert command for the detail table since
                                the above took it out of insert mode.}

              CollDtlTable.Insert;

            end;  {If (BillCtlTable.State in [dsEdit, dsInsert])}

          {FXX04231998-2: Set focus to grid after clicking insert.}
          {FXX05061998-1: Also, set to the first column.}

        CollDtlDBGrid.SetFocus;

        If (CollectionType = 'SC')
          then CollDtlDBGrid.SetActiveField('SchoolCode')
          else CollDtlDBGrid.SetActiveField('SwisCode');

      end;  {If not CopyingSetup}

end;  {CollDtlTableBeforeInsert}

{============================================================}
Procedure TBillFileControlForm.CollDtlTableNewRecord(DataSet: TDataset);

{FXX11301999-4: Default the starting bill number to 1.}

begin
  CollDtlTable.FieldByName('StartingBillNo').AsInteger := 1;

    {FXX09192001-1: If the header table is not yet posted, do it.}

  If (BillCtlTable.State in [dsInsert, dsEdit])
    then
      try
        BillCtlTable.Post;
      except
        SystemSupport(057, BillCtlTable, 'Error posting bill control table.',
                      UnitName, GlblErrorDlgBox); 
      end;

end;  {CollDtlTableNewRecord}

procedure TBillFileControlForm.BillCtlTableBeforePost(DataSet: TDataset);

begin
If (BillCtlTable.FieldByName('NumberOfPayments').AsInteger <=0)
   then
   begin
     MessageDlg('No. Of Payments Must Be Greater Than 0.' + #13 +
                'Please Try Again.', mtError, [mbOK], 0);
     Abort;
   end ;

If (BillCtlTable.FieldByName('NumberOfPayments').AsInteger =1)
                AND
    (Deblank(Date1.Text) ='')
    then
    begin
    MessageDlg('You Must Enter Date 1 For 1 Payment Collection.' + #13 +
                'Please Try Again.', mtError, [mbOK], 0);
    Abort;
    end ;


If (BillCtlTable.FieldByName('NumberOfPayments').value =2)
                AND
            (  (Deblank(Date1.Text) ='')
                      OR
               (Deblank(Date2.Text) ='')
             )
    then
    begin
    MessageDlg('You Must Enter Dates 1 and 2 ' + #13 +
                ' For 2 Payment Collection.Please Try Again.', mtError, [mbOK], 0);
    Abort;
    end;
If (BillCtlTable.FieldByName('NumberOfPayments').value =3)
                AND
            (  (Deblank(Date1.Text) ='')
                      OR
               (Deblank(Date2.Text) ='')
                        OR
               (Deblank(Date3.Text) ='')
             )
    then
    begin
    MessageDlg('You Must Enter Dates 1,2 and 3 ' + #13 +
                ' For 3 Payment Collection.Please Try Again.', mtError, [mbOK], 0);
    Abort;
    end;
If (BillCtlTable.FieldByName('NumberOfPayments').value =4)
                AND
            (  (Deblank(Date1.Text) ='')
                      OR
               (Deblank(Date2.Text) ='')
                        OR
               (Deblank(Date3.Text) ='')
                               OR
               (Deblank(Date4.Text) ='')
             )
    then
    begin
    MessageDlg('You Must Enter Dates 1,2,3 and 4 ' + #13 +
                ' For 4 Payment Collection.Please Try Again.', mtError, [mbOK], 0);
    Abort;
    end;
If (BillCtlTable.FieldByName('NumberOfPayments').value =5)
                AND
            (  (Deblank(Date1.Text) ='')
                      OR
               (Deblank(Date2.Text) ='')
                     OR
               (Deblank(Date3.Text) ='')
                     OR
               (Deblank(Date4.Text) ='')
                     OR
               (Deblank(Date5.Text) ='')
             )
    then
    begin
    MessageDlg('You Must Enter Dates 1,2,3,4 and 5 ' + #13 +
                ' For 5 Payment Collection.Please Try Again.', mtError, [mbOK], 0);
    Abort;
    end;

If (BillCtlTable.FieldByName('NumberOfPayments').value =6)
                AND
            (  (Deblank(Date1.Text) ='')
                      OR
               (Deblank(Date2.Text) ='')
                     OR
               (Deblank(Date3.Text) ='')
                     OR
               (Deblank(Date4.Text) ='')
                     OR
               (Deblank(Date5.Text) ='')
                      OR
               (Deblank(Date6.TExt) ='')
             )
    then
    begin
    MessageDlg('You Must Enter Dates 1,2,3,4,5 and 6 ' + #13 +
                ' For 6 Payment Collection.Please Try Again.', mtError, [mbOK], 0);
    Abort;
    end;

If (BillCtlTable.FieldByName('NumberOfPayments').value =7)
                AND
            (  (Deblank(Date1.Text) ='')
                      OR
               (Deblank(Date2.Text) ='')
                     OR
               (Deblank(Date3.Text) ='')
                     OR
               (Deblank(Date4.Text) ='')
                     OR
               (Deblank(Date5.TEXT) ='')
                      OR
               (Deblank(Date6.Text) ='')
                         OR
               (Deblank(Date7.TExt) ='')
             )
    then
    begin
    MessageDlg('You Must Enter Dates 1,2,3,4,5,6 and 7 ' + #13 +
                ' For 7 Payment Collection.Please Try Again.', mtError, [mbOK], 0);
    Abort;
    end;

If (BillCtlTable.FieldByName('NumberOfPayments').value =8)
                AND
            (  (Deblank(Date1.Text) ='')
                      OR
               (Deblank(Date2.Text) ='')
                     OR
               (Deblank(Date3.Text) ='')
                     OR
               (Deblank(Date4.Text) ='')
                     OR
               (Deblank(Date5.TExt) ='')
                      OR
               (Deblank(Date6.Text) ='')
                         OR
               (Deblank(Date7.TExt) ='')
                           OR
               (Deblank(Date8.Text) ='')
             )
    then
    begin
    MessageDlg('You Must Enter Dates 1,2,3,4,5,6,7 and 8 ' + #13 +
                ' For 8 Payment Collection.Please Try Again.', mtError, [mbOK], 0);
    Abort;
    end;



end;

{=================================================================}
Procedure TBillFileControlForm.BillCtlTableAfterScroll(DataSet: TDataSet);

{FXX04232009-16(4.20.1.1)[D482]: Make sure that the arrears message is synchronized to the correct cycle.}

begin
  CollectionType := CollTypeDBLookupCombo.Text;

  try
    CollectionNum := BillCtlTable.FieldByName('CollectionNo').AsInteger;
  except
    CollectionNum := 0;
  end;

  If CollDtlTable.Active
    then
      If (CollTypeDBLookupCombo.Text = 'SC')
        then
          begin
              {set up school appearance on screen}

            CollDtlTable.FieldByName('SchoolCode').Index := 0;
            CollDtlTable.FieldByName('SwisCode').Index := 1;
            Notebook.Pages[3] := 'School Code Sel';

              {FXX05081998-1: Need to set the index and range for town or school so
                              don't get details from other collections.}
              {FXX08131998-7: Index was wrong.}

            CollDtlTable.IndexName := 'BYYEAR_TYPE_NO_SCHOOL_SWIS';
            SetRangeOld(CollDtlTable,
                        ['TaxRollYr', 'CollectionType', 'CollectionNo', 'SchoolCode', 'SwisCode'],
                        [TaxRollYear, CollectionType, IntToStr(CollectionNum), '      ', '      '],
                        [TaxRollYear, CollectionType, IntToStr(CollectionNum), 'ZZZZZZ', 'ZZZZZZ']);
          end
        else
          begin
             {setup munic/village appearance on screen}
            Notebook.Pages[3] := 'Swis Code Selection';
            CollDtlTable.FieldByName('SchoolCode').Index := 1;
            CollDtlTable.FieldByName('SwisCode').Index := 0;

              {FXX05081998-1: Need to set the index and range for town or school so
                              don't get details from other collections.}

            CollDtlTable.IndexName := 'BYYEAR_COLLTYPE_COLLNO_SWIS';
            SetRangeOld(CollDtlTable,
                        ['TaxRollYr', 'CollectionType', 'CollectionNo', 'SwisCode'],
                        [TaxRollYear, CollectionType, IntToStr(CollectionNum), '      '],
                        [TaxRollYear, CollectionType, IntToStr(CollectionNum), 'ZZZZZZ']);

          end;  {else of If (CollTypeDBLookupCombo.Text = 'SC')}

  If BillCollArrearsTable.Active
    then _Locate(BillCollArrearsTable, [TaxRollYear, CollectionType, CollectionNum], '', []);

end;  {BillCtlTableAfterScroll}

{==========================================================================}
Procedure TBillFileControlForm.NoPaymentsDBEditChange(Sender: TObject);

{Either enable or disable the minimum\maximum and penny options depending
 on if they have 1 payment or more than 1 payment.}

var
  I, NumPayments : Integer;
  StrDefault, TempStr : String;
  TempEditBox : TDBEdit;
  NumDefault : Comp;

begin
  StrDefault := '';
  NumDefault := 0;

  try
    NumPayments := StrToInt(Deblank(NoPaymentsDBEdit.Text));
  except
    NumPayments := -1;  {Not a valid integer}
  end;

  If (NumPayments <> -1)
    then
      begin
          {FXX04231998-7: Also enable\disable SD payment split option
                          depending on number of payments.}

        SDPaymentTypeRadioGroup.Enabled := (NumPayments > 1);
        MinimumMaximumGroupBox.Enabled := (NumPayments > 1);
        ApplyPenniesOptionRadioGroup.Enabled := (NumPayments > 1);

           {Now make sure that they can only put in dates and penalties for
            payments that are in this collection.}

        For I := 8 downto 1 do
          If (I > NumPayments)
            then
              begin
                  {Turn these edit boxes off.}
                  {Date}

                TempStr := 'Date' + IntToStr(I);
                TempEditBox := TDBEdit(FindComponent(TempStr));
                MakeEditReadOnly(TempEditBox, BillCtlTable, True, StrDefault);

                  {Penalty}

                TempStr := 'Pen' + IntToStr(I);
                TempEditBox := TDBEdit(FindComponent(TempStr));
                MakeEditReadOnly(TempEditBox, BillCtlTable, True, NumDefault);

              end
            else
              begin
                  {Turn these edit box on.}
                  {Date}

                TempStr := 'Date' + IntToStr(I);
                TempEditBox := TDBEdit(FindComponent(TempStr));
                MakeEditNotReadOnly(TempEditBox);

                  {Penalty}

                TempStr := 'Pen' + IntToStr(I);
                TempEditBox := TDBEdit(FindComponent(TempStr));
                MakeEditNotReadOnly(TempEditBox);

              end;  {else of If (I > NumPayments)}

      end;  {If (NumPayments <> -1)}

end;  {NoPaymentsDBEditChange}

{=======================================================================}
Procedure TBillFileControlForm.UseMinimumOptionCheckBoxClick(Sender: TObject);

{Either turn the minimum amount box on or off depending on the state of the
 use minimum check box.}

var
  NumDefault : Comp;

begin
  NumDefault := 0;

  If UseMinimumOptionCheckBox.Checked
    then
      begin
        If EditMinimumAmount.ReadOnly
          then MakeEditNotReadOnly(EditMinimumAmount);

      end
    else
      begin
        If not EditMinimumAmount.ReadOnly
          then MakeEditReadOnly(EditMinimumAmount, BillCtlTable, True,
                                NumDefault);

      end;  {else of If UseMinimumOptionCheckBox.Checked}

end;  {UseMinimumOptionCheckBoxClick}

{====================================================================}
Procedure TBillFileControlForm.UseMaximumOptionCheckBoxClick(Sender: TObject);

{Either turn the Maximum amount box on or off depending on the state of the
 use Maximum check box.}

var
  NumDefault : Comp;

begin
  NumDefault := 0;

  If UseMaximumOptionCheckBox.Checked
    then
      begin
        If EditMaximumAmount.ReadOnly
          then MakeEditNotReadOnly(EditMaximumAmount);

      end
    else
      begin
        If not EditMaximumAmount.ReadOnly
          then MakeEditReadOnly(EditMaximumAmount, BillCtlTable, True,
                                NumDefault);

      end;  {else of If UseMaximumOptionCheckBox.Checked}

end;  {UseMaximumOptionCheckBoxClick}

{====================================================================}
Procedure TBillFileControlForm.NotebookChange(    Sender: TObject;
                                                  NewTab: Integer;
                                              var AllowChange: Boolean);

{FXX04231998-5: Set focus to the first component of each notebook page.}

begin
  NotebookChangeTimer.Enabled := True;
end;  {NotebookChange}

{================================================================}
Procedure TBillFileControlForm.NotebookEnter(Sender: TObject);

begin
  NotebookChangeTimerTimer(Sender);
end;

{======================================================================}
Procedure TBillFileControlForm.NotebookChangeTimerTimer(Sender: TObject);

{In order to avoid an error focusing disabled window message, need to set focus
 after page is changed.}

var
  NumPayments : Integer;

begin
  NotebookChangeTimer.Enabled := False;

  try
    NumPayments := BillCtlTable.FieldByName('NumberOfPayments').AsInteger;
  except
    NumPayments := 0;
  end;

  case Notebook.PageIndex of
    0 : Date1.SetFocus;
    1 : If (NumPayments = 1)
          then BillNumberRadioGroup.SetFocus
          else SDPaymentTypeRadioGroup.SetFocus;
    2 : If (NumPayments = 1)
          then CalcProrataOptionCheckBox.SetFocus
          else UseMinimumOptionCheckBox.SetFocus;
    3 : CollDtlDBGrid.SetFocus;

  end;  {case Notebook.PageIndex of}

end;  {NotebookChangeTimerTimer}

{=======================================================================}
Procedure TBillFileControlForm.SaveArrearsButtonClick(Sender: TObject);

{CHG03161999-1: Add ability to enter arrears messages.}

begin
  BillCollArrearsTable.Post;
end;

{=======================================================================}
Procedure TBillFileControlForm.CancelArrearsButtonClick(Sender: TObject);

begin
  BillCollArrearsTable.Cancel;
end;

{===================================================================}
Procedure TBillFileControlForm.BillCtlTableBeforeDelete(DataSet: TDataset);

begin
  OldCollectionType := CollectionType;
  OldCollectionNum := CollectionNum;
end;  {BillCtlTableBeforeDelete}

{===================================================================}
Procedure TBillFileControlForm.BillCtlTableAfterDelete(DataSet: TDataset);

{If cycle is deleted, delete all details.}

begin
  SetRangeOld(BillControlLookupTable,
              ['TaxRollYr', 'CollectionType', 'CollectionNo'],
              [TaxRollYear, OldCollectionType, IntToStr(OldCollectionNum)],
              [TaxRollYear, OldCollectionType, IntToStr(OldCollectionNum)]);

  DeleteTableRange(BillControlLookupTable);
  BillControlLookupTable.CancelRange;

    {Now copy the general rates.}

  SetRangeOld(GeneralRatesLookupTable,
              ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
              [TaxRollYear, OldCollectionType, IntToStr(OldCollectionNum), '0'],
              [TaxRollYear, OldCollectionType, IntToStr(OldCollectionNum), '32000']);

  DeleteTableRange(GeneralRatesLookupTable);
  GeneralRatesLookupTable.CancelRange;

    {Now copy the special charges.}

  SetRangeOld(SpecialChargesLookupTable,
              ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
              [TaxRollYear, OldCollectionType, IntToStr(OldCollectionNum), '0'],
              [TaxRollYear, OldCollectionType, IntToStr(OldCollectionNum), '32000']);

  DeleteTableRange(SpecialChargesLookupTable);
  SpecialChargesLookupTable.CancelRange;

    {Now copy the Arrears message.}

  SetRangeOld(ArrearsMessageLookupTable,
              ['TaxRollYr', 'CollectionType', 'CollectionNo'],
              [TaxRollYear, OldCollectionType, IntToStr(OldCollectionNum)],
              [TaxRollYear, OldCollectionType, IntToStr(OldCollectionNum)]);

  DeleteTableRange(ArrearsMessageLookupTable);
  ArrearsMessageLookupTable.CancelRange;

end;  {BillCtlTableAfterDelete}

{===============================================================}
Procedure TBillFileControlForm.BillCollArrearsTableNewRecord(DataSet: TDataSet);

begin
  with BillCollArrearsTable do
    begin
      FieldByName('TaxRollYr').Text := TaxRollYear;
      FieldByName('CollectionNo').AsInteger := CollectionNum;
      FieldByName('CollectionType').Text := CollectionType;

    end;  {with BillCollArrearsTable do}

end;  {BillCollArrearsTableNewRecord}

{===============================================================}
Procedure TBillFileControlForm.BillCtlTableAfterPost(DataSet: TDataSet);

{CHG07172001-2: Ask them right away if they want to clear arrears flags.}

var
  Done, FirstTimeThrough : Boolean;
  NumCleared : Integer;

begin
  If (NewCycleAdded and
      (MessageDlg('Do you want to clear the arrears flags from the last billing?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        Done := False;
        FirstTimeThrough := True;
        NumCleared := 0;

        ProgressDialog.UserLabelCaption := 'Clearing Arrears Flags';
        ProgressDialog.Start(GetRecordCount(ParcelTable), False, False);
        ParcelTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelTable.Next;

          If ParcelTable.EOF
            then Done := True;

          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));
          Application.ProcessMessages;

          If not Done
            then
              with ParcelTable do
                If FieldByName('Arrears').AsBoolean
                  then
                    try
                      Edit;
                      FieldByName('Arrears').AsBoolean := False;
                      Post;
                      NumCleared := NumCleared + 1;
                    except
                      SystemSupport(003, ParcelTable, 'Error clearing arrears flag.',
                                    UnitName, GlblErrorDlgBox);
                    end;

        until Done;

        MessageDlg('There were ' + IntToStr(NumCleared) + ' arrears flags cleared.',
                   mtInformation, [mbOK], 0);

        ProgressDialog.Finish;

        NewCycleAdded := False;

      end;  {If (MessageDlg ...}

end;  {BillCtlTableAfterPost}

{==================================================================}
Procedure TBillFileControlForm.AddNewBillCycleButtonClick(Sender: TObject);

{CHG09192001-1: Make sure that it is obvious how to add a new cycle.}

begin
  BillCtlTable.Insert;
  CollTypeDBLookupCombo.SetFocus;
end;

end.