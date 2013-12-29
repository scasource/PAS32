unit YorktownNameAddressExtract;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask,
  Types, ComCtrls;

type
  TYorktownNameAddressExtractForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    TitleLabel: TLabel;
    MainParcelTable: TTable;
    PublicParcelTable: TTable;
    PublicSystemTable: TTable;
    NameAddressUpdateTable: TTable;
    MainSalesTable: TTable;
    MainAssessmentTable: TTable;
    tb_CodeEnforcementParcel: TTable;
    tb_ParcelNY: TTable;
    tb_PublicSales: TTable;
    pbrSales: TProgressBar;
    Label1: TLabel;
    ExtractTypeRadioGroup: TRadioGroup;
    OptionsGroupBox: TGroupBox;
    Label2: TLabel;
    UpdatePublicStationCheckBox: TCheckBox;
    EditExtractDirectory: TEdit;
    cb_UpdateBuildingDepartment: TCheckBox;
    cb_TransferSalesData: TCheckBox;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    Cancelled, UpdateBuildingDepartment : Boolean;
    ExtractType : Integer;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure ExtractCommaDelimitedLine(    TempTable : TTable;
                                            MainParcelTable : TTable;
                                        var NameAddressUpdateFile : TextFile);

    Procedure UpdateNameAddressTable(TempTable : TTable;
                                     MainParcelTable : TTable;
                                     NameAddressUpdateTable : TTable);

    Procedure UpdatePublicParcelTable(MainParcelTable : TTable;
                                      PublicParcelTable : TTable;
                                      TempParcelTable : TTable;
                                      PublicAssessmentYear : String);

    Procedure UpdateCodeEnforcementParcelTable(var CodeEnforcementUpdateLog : TextFile;
                                                   tb_PASParcel : TTable;
                                                   tb_CodeEnforcementParcel : TTable;
                                                   tb_Assessment : TTable);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, UtilEXSD,
     Prog, DataAccessUnit, PASTypes;

{$R *.DFM}

const
  etCommaDelimited = 0;
  etDBase = 1;

{========================================================}
Procedure TYorktownNameAddressExtractForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'YorktownNameAddressExtract';

    {CHG01172010-1(2.22.1.6y)[I6869]: Make the address extract path flexible.}

  EditExtractDirectory.Text := glblOwnerAddressUpdateFilePath;
  OpenTableForProcessingType(MainParcelTable, ParcelTableName, ThisYear, Quit);
  OpenTableForProcessingType(MainAssessmentTable, AssessmentTableName, ThisYear, Quit);
  OpenTableForProcessingType(tb_ParcelNY, ParcelTableName, NextYear, Quit);
  OpenTableForProcessingType(MainSalesTable, SalesTableName, NoProcessingType, Quit);
  tb_PublicSales.Open;

end;  {InitializeForm}

{===================================================================}
Procedure TYorktownNameAddressExtractForm.UpdateNameAddressTable(TempTable : TTable;
                                                                 MainParcelTable : TTable;
                                                                 NameAddressUpdateTable : TTable);

var
  NAddrArray : NameAddrArray;
  I : Integer;
  TempFieldName : String;

begin
  GetNameAddress(TempTable, NAddrArray);

  with NameAddressUpdateTable do
    try
      Insert;
      FieldByName('Swiss').Text := MainParcelTable.FieldByName('SwisCode').Text;
      FieldByName('Bank').Text := MainParcelTable.FieldByName('BankCode').Text;
      FieldByName('PrintKey').Text := ConvertSwisSBLToDashDot(ExtractSSKey(MainParcelTable));
      FieldByName('AcntNo').Text := MainParcelTable.FieldByName('AccountNo').Text;
      FieldByName('OldKey').Text := MainParcelTable.FieldByName('RemapOldSBL').Text;
      FieldByName('Owner').Text := NAddrArray[1];

      For I := 1 to 5 do
        begin
          TempFieldName := 'Address_' + IntToStr(I);
          FieldByName(TempFieldName).Text := NAddrArray[I];
        end;

      Post;
    except
      SystemSupport(1, NameAddressUpdateTable,
                    'Error updating name \ address update table.',
                    UnitName, GlblErrorDlgBox);
    end;

end;  {UpdateNameAddressTable}

{===================================================================}
Procedure TYorktownNameAddressExtractForm.ExtractCommaDelimitedLine(    TempTable : TTable;
                                                                        MainParcelTable : TTable;
                                                                    var NameAddressUpdateFile : TextFile);

var
  NAddrArray : NameAddrArray;
  I : Integer;
  LandValue, TotalValue : LongInt;

begin
  GetNameAddress(TempTable, NAddrArray);

  with MainParcelTable do
    If _Compare(FieldByName('ActiveFlag').AsString, 'D', coNotEqual)
      then
        begin
          WriteCommaDelimitedLine(NameAddressUpdateFile,
                                  [FieldByName('SwisCode').Text,
                                   TempTable.FieldByName('BankCode').Text,
                                   ConvertSwisSBLToDashDot(ExtractSSKey(MainParcelTable)),
                                   FieldByName('AccountNo').Text,
                                   FieldByName('RemapOldSBL').Text]);

          For I := 1 to 6 do
            WriteCommaDelimitedLine(NameAddressUpdateFile,
                                    [Trim(NAddrArray[I])]);

            {CHG08242005-1(2.9.2.4): Add fields to the extract:
                                     Property value, Assessed value, roll section,
                                     school code, frontage, depth, acreage, area}

          LandValue := 0;
          TotalValue := 0;

          If _Locate(MainAssessmentTable, [GlblThisYear, ExtractSSKey(MainParcelTable)], '', [])
            then
              with MainAssessmentTable do
                begin
                  LandValue := FieldByName('LandAssessedVal').AsInteger;
                  TotalValue := FieldByName('TotalAssessedVal').AsInteger;
                end;

          with MainParcelTable do
            WritelnCommaDelimitedLine(NameAddressUpdateFile, [LandValue,
                                                              TotalValue,
                                                              FieldByName('RollSection').Text,
                                                              FieldByName('SchoolCode').Text,
                                                              FieldByName('Frontage').AsFloat,
                                                              FieldByName('Depth').AsFloat,
                                                              FieldByName('Acreage').AsFloat,
                                                              GetAcres(FieldByName('Acreage').AsFloat,
                                                                       FieldByName('Frontage').AsFloat,
                                                                       FieldByName('Depth').AsFloat),
                                                              FieldByName('LegalAddrNo').Text,
                                                              FieldByName('LegalAddr').Text,
                                                              FieldByName('PropertyClassCode').Text]);

        end;  {with MainParcelTable do}

end;  {ExtractCommaDelimitedLine}

{===================================================================}
Procedure TYorktownNameAddressExtractForm.UpdatePublicParcelTable(MainParcelTable : TTable;
                                                                  PublicParcelTable : TTable;
                                                                  TempParcelTable : TTable;
                                                                  PublicAssessmentYear : String);

var
  SBLRec : SBLRecord;

begin
  SBLRec := ExtractSwisSBLFromSwisSBLKey(ExtractSSKey(MainParcelTable));

  with SBLRec do
    If FindKeyOld(PublicParcelTable, ['TaxRollYr', 'SwisCode',
                                      'Section', 'Subsection', 'Block',
                                      'Lot', 'Sublot', 'Suffix'],
                                     [PublicAssessmentYear, SwisCode, Section, SubSection,
                                      Block, Lot, Sublot, Suffix])
      then
        with PublicParcelTable do
          try
            Edit;
            FieldByName('Name1').Text := MainParcelTable.FieldByName('Name1').Text;
            FieldByName('Name2').Text := MainParcelTable.FieldByName('Name2').Text;
            FieldByName('Address1').Text := MainParcelTable.FieldByName('Address1').Text;
            FieldByName('Address2').Text := MainParcelTable.FieldByName('Address2').Text;
            FieldByName('Street').Text := MainParcelTable.FieldByName('Street').Text;
            FieldByName('City').Text := MainParcelTable.FieldByName('City').Text;
            FieldByName('State').Text := MainParcelTable.FieldByName('State').Text;
            FieldByName('Zip').Text := MainParcelTable.FieldByName('Zip').Text;
            FieldByName('ZipPlus4').Text := MainParcelTable.FieldByName('ZipPlus4').Text;
            FieldByName('LegalAddr').Text := TempParcelTable.FieldByName('LegalAddr').Text;
            FieldByName('LegalAddrNo').Text := TempParcelTable.FieldByName('LegalAddrNo').Text;
            FieldByName('LegalAddrInt').Text := TempParcelTable.FieldByName('LegalAddrInt').Text;
            Post;
          except
          end;

end;  {UpdatePublicParcelTable}

{===================================================================}
Procedure TYorktownNameAddressExtractForm.UpdateCodeEnforcementParcelTable(var CodeEnforcementUpdateLog : TextFile;
                                                                               tb_PASParcel : TTable;
                                                                               tb_CodeEnforcementParcel : TTable;
                                                                               tb_Assessment : TTable);

var
  SwisSBLKey : String;
  NameAddressArray : NameAddrArray;

begin
  SwisSBLKey := ExtractSSKey(tb_PASParcel);
  GetNameAddress(tb_PASParcel, NameAddressArray);

  with tb_CodeEnforcementParcel do
    try
      If _Locate(tb_CodeEnforcementParcel, [Copy(SwisSBLKey, 7, 20)], '', [])
        then Edit
        else
          begin
            Insert;
            FieldByName('SwisCode').AsString := tb_PASParcel.FieldByName('SwisCode').AsString;
            FieldByName('SBL').AsString := Copy(SwisSBLKey, 7, 20);

          end;  {else of If _Locate...}

      _Locate(tb_Assessment, [GlblThisYear, SwisSBLKey], '', []);

      FieldByName('Owner').AsString := tb_PASParcel.FieldByName('Name1').AsString;
      FieldByName('LegalAddrNo').AsString := tb_PASParcel.FieldByName('LegalAddrNo').AsString;
      FieldByName('LegalAddr').AsString := tb_PASParcel.FieldByName('LegalAddr').AsString;
      FieldByName('MailAddr1').AsString := NameAddressArray[2];
      FieldByName('MailAddr2').AsString := NameAddressArray[3];
      FieldByName('MailAddr3').AsString := NameAddressArray[4];
      FieldByName('MailAddr4').AsString := NameAddressArray[5];
      FieldByName('MailAddr5').AsString := NameAddressArray[6];
      FieldByName('BankCode').AsString := tb_PASParcel.FieldByName('BankCode').AsString;
      FieldByName('Frontage').AsString := tb_PASParcel.FieldByName('Frontage').AsString;
      FieldByName('Depth').AsString := tb_PASParcel.FieldByName('Depth').AsString;
      FieldByName('Acreage').AsString := tb_PASParcel.FieldByName('Acreage').AsString;
      FieldByName('DeedBook').AsString := tb_PASParcel.FieldByName('DeedBook').AsString;
      FieldByName('DeedPage').AsString := tb_PASParcel.FieldByName('DeedPage').AsString;
      FieldByName('OldSBL').AsString := tb_PASParcel.FieldByName('RemapOldSBL').AsString;
      FieldByName('AccountNo').AsString := tb_PASParcel.FieldByName('AccountNo').AsString;
      FieldByName('LegalAddrInt').AsInteger := tb_PASParcel.FieldByName('LegalAddrInt').AsInteger;
      FieldByName('PropertyClass').AsString := tb_PASParcel.FieldByName('PropertyClassCode').AsString;
      FieldByName('SchoolDistrict').AsString := tb_PASParcel.FieldByName('SchoolCode').AsString;
      FieldByName('RollSection').AsString := FieldByName('RollSection').AsString;
      FieldByName('LandValue').AsInteger := tb_Assessment.FieldByName('LandAssessedVal').AsInteger;
      FieldByName('TotalValue').AsInteger := tb_Assessment.FieldByName('TotalAssessedVal').AsInteger;

      If (State = dsInsert)
        then Writeln(CodeEnforcementUpdateLog,
                     'Insert parcel: ' + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)) +
                     '  Date: ' + DateToStr(Date) +
                     '  Time: ' + TimeToStr(Now));
      Post;
    except
      Cancel;
      SystemSupport(2, tb_CodeEnforcementParcel,
                    'Error editing \ inserting ' + SwisSBLKey + ' into CodeEnforcement parcel table.',
                    UnitName, GlblErrorDlgBox);

    end;

end;  {UpdateCodeEnforcementParcelTable}

{===================================================================}
Procedure TYorktownNameAddressExtractForm.StartButtonClick(Sender: TObject);

var
  Cancelled, UpdatePublicStation,
  TransferSalesData, FirstTimeThrough, Done : Boolean;
  PublicAssessmentYear, ExtractDirectory,
  NextYearAssessmentYear, CodeEnforcementUpdateLogFileName : String;
  NameAddressUpdateFile, CodeEnforcementUpdateLog : TextFile;
  TempTable : TTable;

begin
  NextYearAssessmentYear := tb_ParcelNY.FieldByName('TaxRollYr').AsString;
  FirstTimeThrough := True;
  Done := False;
  ExtractType := ExtractTypeRadioGroup.ItemIndex;
  ExtractDirectory := AddDirectorySlashes(EditExtractDirectory.Text);
  UpdatePublicStation := UpdatePublicStationCheckBox.Checked;
  UpdateBuildingDepartment := cb_UpdateBuildingDepartment.Checked;
  TransferSalesData := cb_TransferSalesData.Checked;
  MainParcelTable.First;

  If UpdatePublicStation
    then
      begin
        PublicParcelTable.Open;
        PublicSystemTable.Open;
        PublicAssessmentYear := PublicSystemTable.FieldByName('SysNextYear').Text;

      end;  {If UpdatePublicStation}

    {CHG10282007-1(2.11.4.10): Name\address update should run completely off NY for
                               building department so that they get new NY parcels, too.}

  If UpdateBuildingDepartment
    then
      begin
        CodeEnforcementUpdateLogFileName := ExtractDirectory + 'CodeEnforcementUpdates.log';
        AssignFile(CodeEnforcementUpdateLog, CodeEnforcementUpdateLogFileName);

        If FileExists(CodeEnforcementUpdateLogFileName)
          then
            begin
              Append(CodeEnforcementUpdateLog);
              Writeln(CodeEnforcementUpdateLog, 'Update: ' +
                                                '  Date: ' + DateToStr(Date) +
                                                '  Time: ' + TimeToStr(Now));

            end
          else Rewrite(CodeEnforcementUpdateLog);

        tb_CodeEnforcementParcel.Open;

        with tb_ParcelNY do
          begin
            ProgressDialog.Start(RecordCount, True, True);
            First;

            while (not EOF) do
              begin
                If (_Compare(FieldByName('ActiveFlag').AsString, 'D', coNotEqual) and
                    _Compare(FieldByName('Name1').AsString, coNotBlank))
                  then UpdateCodeEnforcementParcelTable(CodeEnforcementUpdateLog, tb_ParcelNY,
                                                        tb_CodeEnforcementParcel,
                                                        MainAssessmentTable);

                ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(tb_ParcelNY)));
                Application.ProcessMessages;

                Next;

              end;  {while (not EOF) do}

            ProgressDialog.Finish;

          end;  {with tb_ParcelNY do}

        ProgressDialog.Finish;

      end;  {If UpdateBuildingDepartment}

  case ExtractType of
    etCommaDelimited :
      begin
        AssignFile(NameAddressUpdateFile, ExtractDirectory + 'AddressUpdate.csv');
        Rewrite(NameAddressUpdateFile);
      end;

    etDBase :
      begin
        NameAddressUpdateTable.Close;

        try
          NameAddressUpdateTable.EmptyTable;
        except
          NameAddressUpdateTable.Open;
          DeleteTable(NameAddressUpdateTable);
        end;

        If (not NameAddressUpdateTable.Active)
          then NameAddressUpdateTable.Open;

      end;  {etDBase}

  end;  {case ExtractType of}

  ProgressDialog.Start(MainParcelTable.RecordCount, True, True);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else MainParcelTable.Next;

    If MainParcelTable.EOF
      then Done := True;

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(MainParcelTable)));
    Application.ProcessMessages;

    If not Done
      then
        begin
          with MainParcelTable do
            If _Locate(tb_ParcelNY,
                       [NextYearAssessmentYear,
                        FieldByName('SwisCode').AsString,
                        FieldByName('Section').AsString,
                        FieldByName('Subsection').AsString,
                        FieldByName('Block').AsString,
                        FieldByName('Lot').AsString,
                        FieldByName('Sublot').AsString,
                        FieldByName('Suffix').AsString], '', [])
              then TempTable := tb_ParcelNY
              else TempTable := MainParcelTable;

          case ExtractType of
            etCommaDelimited : ExtractCommaDelimitedLine(TempTable, MainParcelTable, NameAddressUpdateFile);
            etDBase : UpdateNameAddressTable(TempTable, MainParcelTable, NameAddressUpdateTable);
          end;

          If UpdatePublicStation
            then UpdatePublicParcelTable(MainParcelTable, PublicParcelTable, TempTable, PublicAssessmentYear);

        end;  {If not Done}

    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled);

  ProgressDialog.Finish;

    {CHG05212007(2.11.1.33): Transfer the sales data.}
    {CHG08092008-1(2.15.1.3): If the sales table is locked, then empty manually.}

  If (UpdatePublicStation and
      TransferSalesData)
    then
      begin
        pbrSales.Position := 0;
        pbrSales.Max := 2 * MainSalesTable.RecordCount;

        with tb_PublicSales do
        begin
          First;

          while (RecordCount >= 1) do
          begin
            Delete;

            If not EOF
            then Next;

            Application.ProcessMessages;
            pbrSales.StepIt;

          end;  {while (RecordCount >= 1) do}

        end;  {with tb_PublicSales do}

        (*CopyTableRange(MainSalesTable, tb_PublicSales, 'SwisSBLKey', [], []); *)

        with MainSalesTable do
        begin
          First;

          while (not EOF) do
          begin
            CopyTable_OneRecord(MainSalesTable, tb_PublicSales, [], []);

            Application.ProcessMessages;
            pbrSales.StepIt;
            Next;

          end;  {while (RecordCount >= 1) do}

        end;  {with MainSalesTable do}

      end;  {If (UpdatePublicStation and ...}

  If Cancelled
    then MessageDlg('The update was cancelled.' + #13 +
                    'Please run it again in order to make sure that all name and address updates occur.',
                    mtError, [mbOK], 0)
    else MessageDlg('The name \ address update is now complete.', mtInformation, [mbOK], 0);

  If (ExtractType = etCommaDelimited)
    then CloseFile(NameAddressUpdateFile);

end;  {StartButtonClick}

{===================================================================}
Procedure TYorktownNameAddressExtractForm.FormClose(    Sender: TObject;
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