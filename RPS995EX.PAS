unit Rps995ex;
{$F+}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Types, (*Progress,*)
  Zipcopy, Prog, ComCtrls, AbBase, AbBrowse, AbZBrows, AbZipper, AbMeter,ShellAPI,
  FileCtrl, OleServer, Outlook8;

const
  ftParcelOnly = 0;
  ftSalesOnly = 1;
  ftParcelAndSales = 2;

type
  TRPS995FileExtractForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    ZipCopyDlg: TZipCopyDlg;
    SwisCodeTable: TTable;
    Panel2: TPanel;
    CompressedFileProgressPanel: TPanel;
    Label4: TLabel;
    CurrentCompressedFileLabel: TLabel;
    AbMeter1: TAbMeter;
    FileTypeRadioGroup: TRadioGroup;
    YearRadioGroup: TRadioGroup;
    SwisCodeListBox: TListBox;
    Label1: TLabel;
    RollSectionListBox: TListBox;
    Label21: TLabel;
    gbxOptions: TGroupBox;
    Label2: TLabel;
    Label26: TLabel;
    Label3: TLabel;
    SuppressSalesPriceCheckBox: TCheckBox;
    IncludeInventoryCheckBox: TCheckBox;
    SetVillageExemptionFlagsToTrueCheckBox: TCheckBox;
    Panel3: TPanel;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    dlgSave060: TSaveDialog;
    dlgSave995: TSaveDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure StartButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    slSelectedRollSections : TStringList;
    { Public declarations }
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

Procedure Generate995File(Form : TForm;
                          SelectedSwisCodes : TStringList;
                          slSelectedRollSections : TStringList;
                          s060FileName : String;
                          s995FileName : String;
                          FileType : Integer;
                          ShowMessage,
                          ShowBothThisAndNextYear,
                          bShowNextYearOnly,
                          IncludeInventory,
                          SuppressSalesPrice,
                          AllowCancel,
                          SetVillageExemptionFlagsToTrue : Boolean;
                          ProgressDialog: TProgressDialog;
                          ZipCopyDlg: TZipCopyDlg);

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst,
     PASTypes,
     Rps995ut, DataModule;  {Utilities for the 995 extract.}

const
  TrialRun = False;

var
  ExtractCancelled : Boolean;
  UnitName : String;

{$R *.DFM}

{========================================================}
Procedure TRPS995FileExtractForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TRPS995FileExtractForm.InitializeForm;

var
  FirstTimeThrough, Done : Boolean;
  I : Integer;

begin
  UnitName := 'RPS995EX';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

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

  SelectItemsInListBox(RollSectionListBox);

end;  {InitializeForm}

{===================================================================}
Procedure TRPS995FileExtractForm.FormKeyPress(    Sender: TObject;
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
Function OpenTablesExclusive(    TablesToBeOpen : Char; {'S' = Sales, 'P' = Parcel, 'I'= Inventory only}
                                 OpenInventoryTables : Boolean;
                                 InventoryProcessingType : Integer;
                                 SalesTable,
                                 PriorParcelTable, ThisYearParcelTable, NextYearParcelTable,
                                 PriorAssessmentTable, ThisYearAssessmentTable, NextYearAssessmentTable,
                                 PriorClassTable, ThisYearClassTable, NextYearClassTable,
                                 ThisYearSDTable, NextYearSDTable,
                                 ThisYearEXTable, NextYearEXTable,
                                 ThisYearEXCodeTable, NextYearEXCodeTable,
                                 ThisYearSDCodeTable : TTable;
                             var Quit : Boolean) : Boolean;

{Open up the files for the sales or parcel portions of the 995 file extract. Note that
 we will try to open them exclusive. This will check to see if there is anybody else
 logged into PAS. If there is, the opens will fail and the function will return False.
 If the tables are opened successfully, then the function returns True.}

{Note that sales and parcel extracts will open the inventory tables also if
 OpenInventoryTables is true.}

begin
  Quit := False;

    {Open the tables for the sales extract.
     Also, set the keys for inventory sales to be for sales number.}

  If (TablesToBeOpen = 'S')
    then
      begin
        SalesTable := FindTableInDataModuleForProcessingType(DataModuleSalesTableName,
                                                             NoProcessingType);
        ThisYearParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                      ThisYear);
        NextYearParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                      NextYear);


      end;  {If (TablesToBeOpen = 'S')}

    {Open the tables for the parcel extract.
     Also, set the keys for the inventory tables to be for sites.}

  If (TablesToBeOpen = 'P')
    then
      begin
          {FXX03151999-2: All move tax SD's must have a calc code of 'T'.}

        GlblHistYear := IntToStr(StrToInt(GlblThisYear) - 1);

        SalesTable := FindTableInDataModuleForProcessingType(DataModuleSalesTableName,
                                                             NoProcessingType);
        PriorParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                   History);
        ThisYearParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                      ThisYear);
        NextYearParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                      NextYear);
        PriorClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                                  History);
        ThisYearClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                                     ThisYear);
        NextYearClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                                     NextYear);
        PriorAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                       History);
        ThisYearAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                          ThisYear);
        NextYearAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                          NextYear);

        ThisYearSDTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                                  ThisYear);
        NextYearSDTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                                  NextYear);
        ThisYearEXTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                  ThisYear);
        NextYearEXTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                  NextYear);
        ThisYearEXCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                      ThisYear);
        NextYearEXCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                      NextYear);
        ThisYearSDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                                      ThisYear);

        ThisYearSDCodeTable.IndexName := 'BYSDISTCODE';
        ThisYearEXCodeTable.IndexName := 'BYEXCODE';
        NextYearEXCodeTable.IndexName := 'BYEXCODE';

      end;  {If (TablesToBeOpen = 'P')}

  Result := not Quit;

end;  {OpenTablesExclusive}

{==============================================================================}
Procedure WriteMainRecordsForParcel(var RPSFile : TextFile;
                                        ParcelExtractRecs,
                                        ClassExtractRecs,
                                        EXExtractRecs,
                                        SDExtractRecs : TList);

{Actually write out the main parcel information to file.}

var
  I : Integer;

begin
    {CHG04062000-1: Use old parcel ID in sales.}

  For I := 0 to (ParcelExtractRecs.Count - 1) do
    WriteOneRPSExtractRecToFile(RPSFile, ParcelExtractRecs[I], '', False);

  For I := 0 to (ClassExtractRecs.Count - 1) do
    WriteOneRPSExtractRecToFile(RPSFile, ClassExtractRecs[I], '', False);

  For I := 0 to (ExExtractRecs.Count - 1) do
    WriteOneRPSExtractRecToFile(RPSFile, ExExtractRecs[I], '', False);

  For I := 0 to (SDExtractRecs.Count - 1) do
    WriteOneRPSExtractRecToFile(RPSFile, SDExtractRecs[I], '', False);

end;  {WriteMainRecordsForParcel}

{==============================================================================}
Function ExtractSDHdrRecord(SDTable : TTable;
                            ProcessingType,
                            _995RecordNo : Integer) : String;

{Return a string with the header for the SD record.}

begin
  Result := '';

  with SDTable do
    begin
      Result := Result + Take(26, FieldByName('SwisSBLKey').Text);  {1-26}
      Result := Result + Take(2, '00');  {27-28}

      If (ProcessingType = ThisYear)
        then Result := Result + Take(1, '2')  {29-29}
        else Result := Result + Take(1, '4');  {29-29}

      Result := Result + Take(2, '00');  {30-31}
      Result := Result + Take(1, 'D');  {32-32}
      Result := Result + ShiftRightAddZeroes(Take(2, IntToStr(_995RecordNo)));  {33-34}
      Result := Result + Take(2, '');  {35-36}
      Result := Result + Take(3, '');  {37-39}

    end;  {with SDTable do}

end;  {ExtractSDHdrRecord}

{=======================================================================}
Function ExtractOneSDRecord(SDTable,
                            SDCodeTable : TTable) : String;

{Extract the SD record that is presently pointed to in the SD table.}
{Note that the offsets are only within this record.}

var
  sTempCode : String;

begin
  Result := '';

  with SDTable do
    begin
      Result := Result + Take(5, FieldByName('SDistCode').Text);  {1-5}
      Result := Result + FormatRPSNumericString(FieldByName('PrimaryUnits').Text, 6, 2);  {6-11}
      Result := Result + FormatRPSNumericString(FloatToStr(FieldByName('SDPercentage').AsFloat * 100), 4, 0);  {12-15}

        {FXX12081998-4: If this SD has secondary units, need to have a calc code of
                        'U' and store the secondary units in the calc amount field.}

      If (Roundoff(FieldByName('SecondaryUnits').AsFloat, 2) > 0)
        then
          begin
            Result := Result + Take(1, 'U');  {16-16}

            Result := Result + FormatRPSNumericString(FieldByName('SecondaryUnits').Text, 12, 2);  {17-28}
          end
        else
          begin
              {FXX12081998-5: If this is a prorata sd, need to use a calc code of 'T'.}
              {FXX03151999-2: Any move tax must have a calc code of 'T'}

            FindKeyOld(SDCodeTable, ['SDistCode'],
                       [FieldByName('SDistCode').Text]);

            sTempCode := Take(1, SDCodeTable.FieldByName('ECd1').AsString);

            If (sTempCode[1] = SdistEcMT)
              then Result := Result + Take(1, 'T')  {16-16}
              else Result := Result + Take(1, FieldByName('CalcCode').Text);  {16-16}

              {FXX12201998-2: If the calc code is 'S' or 'E', this is
                              an assessed or taxable override, and there
                              are no decimals.}

            If (Take(1, FieldByName('CalcCode').Text)[1] in [PrclSDCcS, PrclSDCcE])
              then Result := Result + FormatRPSNumericString(FieldByName('CalcAmount').Text, 12, 0)  {17-28}
              else Result := Result + FormatRPSNumericString(FieldByName('CalcAmount').Text, 12, 2);  {17-28}

          end;  {If (Roundoff(FieldByName('SecondaryUnits').AsFloat, 2) > 0)}

    end;  {with SDTable do}

end;  {ExtractOneSDRecord}

{=======================================================================}
Function CreateBlankSDRecord : String;

{Create a blank SD record to be compatible with RPS995 - put zeroes in
 numeric fields and blanks in non-numeric fields.}
{Note that the offsets are only within this record.}

begin
  Result := '';
  Result := Result + Take(5, '');  {1-5}
  Result := Result + ShiftRightAddZeroes(Take(6, ''));  {6-11}
  Result := Result + ShiftRightAddZeroes(Take(4, ''));  {12-15}
  Result := Result + Take(1, '');  {16-16}
  Result := Result + ShiftRightAddZeroes(Take(12, ''));  {17-28}

end;  {CreateBlankSDRecord}

{==============================================================================}
Procedure ExtractSDRecords(    SDTable,
                               ThisYearSDCodeTable : TTable;
                               TaxRollYear : String;
                               ProcessingType : Integer;
                               SwisSBLKey : String;
                               SDRecords : TList;
                           var NumSDRecords : Integer); {This is the number of physical SD records we have gone through.}

var
  Done, Quit, FirstTimeThrough : Boolean;
  I, _995RecordNo : Integer; {This is the SD hdr record number -> 00 to 03}
  SDRecord : PRPSExtractRec;

begin
  SDRecord := nil;
  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  _995RecordNo := 0;
  NumSDRecords := 0;

  SetRangeOld(SDTable, ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
              [TaxRollYear, SwisSBLKey, '     '],
              [TaxRollYear, SwisSBLKey, 'ZZZZZ']);

  try
    SDTable.First;
  except
    Quit := True;
    SystemSupport(001, SDTable, 'Error getting first SD record.', 'EXTRUTIL.PAS',
                  GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          SDTable.Next;
        except
          Quit := True;
          SystemSupport(002, SDTable, 'Error getting first next record.', 'EXTRUTIL.PAS',
                        GlblErrorDlgBox);
        end;

    If SDTable.EOF
      then Done := True;

      {If this is a good SD record and should be extracted, then we will extract it.
       If we are including inventory, then we will add that, too.}

    If not (Done or Quit)
      then
        begin
          NumSDRecords := NumSDRecords + 1;

            {If the number of records is 1, 26, 51, or 76,
             then we need to go to a new record, so let's create
             a new record pointer, increment the RPS SD record number,
             and add the header to this new extract record.}

          If (((NumSDRecords - 1) MOD 25) = 0)
            then
              begin
                New(SDRecord);
                InitializeRPSExtractString(SDRecord);
                RPSExtractStrCat(SDRecord, ExtractSDHdrRecord(SDTable, ProcessingType,
                                                              _995RecordNo));
                _995RecordNo := _995RecordNo + 1;

              end;  {If (((NumRecords - 1) MOD 25) = 0)}

          RPSExtractStrCat(SDRecord, ExtractOneSDRecord(SDTable, ThisYearSDCodeTable));

            {If the number of records = 25, 50, 75, or 100,
             then the 995 SD extract record is full, so put it
             on the list.}

          If ((NumSDRecords MOD 25) = 0)
            then
              begin
                RPSExtractStrCat(SDRecord, Take(81, ''));

                If (ProcessingType = ThisYear)
                  then RPSExtractStrCat(SDRecord, '24')
                  else RPSExtractStrCat(SDRecord, '44');

                SDRecords.Add(SDRecord);

              end;  {If ((NumSDRecords MOD 25) = 0)}

        end;  {If not (Done or Quit)}

  until (Done or Quit);

    {If there were any SD records and it did not fill out a record, finish
     this record out and add it to the list.}

  If ((NumSDRecords MOD 25) <> 0)
    then
      begin
        I := NumSDRecords;

        while ((I MOD 25) <> 0) do
          begin
            RPSExtractStrCat(SDRecord, CreateBlankSDRecord);
            I := I + 1;

          end;  {while ((NumSDRecords MOD 25) <> 0) do}

        RPSExtractStrCat(SDRecord, Take(81, ''));

        If (ProcessingType = ThisYear)
          then RPSExtractStrCat(SDRecord, '24')
          else RPSExtractStrCat(SDRecord, '44');

        SDRecords.Add(SDRecord);

      end;  {If ((NumSDRecords MOD 25) <> 0)}

end;  {ExtractSDRecords}

{==============================================================================}
Procedure ExtractMainRecordsForParcel(    ParcelExtractRecs,
                                          ClassExtractRec,
                                          EXExtractRecs,
                                          SDExtractRecs : TList;
                                          SwisSBLKey : String;
                                          ParcelTable,
                                          AssessmentTable,
                                          ClassTable,
                                          SDTable,
                                          SDCodeTable,
                                          EXTable,
                                          EXCodeTable,
                                          SalesTable,
                                          SortAVChangesTable : TTable;
                                          NumResSites,
                                          NumComSites : Integer;
                                          TaxRollYear : String;
                                          ProcessingType : Integer; {ThisYear, NextYear}
                                          TaxableStatusDate : String;  {MMDDYY}
                                          PriorValues,
                                          TYValues,
                                          NYValues : BaseInfoRecord;
                                          PrintTYAndNY,
                                          Is210File : Boolean;
                                      var EqualizationInc,
                                          PhysicalQtyInc,
                                          EqualizationDec,
                                          PhysicalQtyDec,
                                          PriorHoldValue : Comp;
                                      var HoldPriorRollSection,
                                          HoldPriorStatus,
                                          HoldPriorHomestead : String;
                                      var HoldPriorPropClass : String;
                                          SetVillageExemptionFlagsToTrue : Boolean);

var
  I, NumEXRecs, NumSDRecs, NumSalesRecs : Integer;
  ParcelRec, ExemptionRec, ClassRec : PRPSExtractRec;
  Found : Boolean;
  TempStr : String;

begin
  NumEXRecs := 0;
  NumSDRecs := 0;
  NumSalesRecs := NumRecordsInRange(SalesTable, ['SwisSBLKey', 'SaleNumber'],
                                    [SwisSBLKey, '0'],
                                    [SwisSBLKey, '32000']);

      {We will do the exemption and special district records first
       so we can find out how many of each there are.}
      {Extract the this year exemption records.}

  New(ExemptionRec);

  ExtractExemptionRecord(ExemptionRec, EXTable, TaxRollYear,
                         ProcessingType, SwisSBLKey, NumEXRecs,
                         SetVillageExemptionFlagsToTrue);

    {FXX10081997-1: - Use FreeMem instead of Dispose in order to free the
                       exact amount.}

  If (NumEXRecs > 0)
    then EXExtractRecs.Add(ExemptionRec)
    else FreeMem(ExemptionRec, SizeOf(RPSExtractRec));

    {Extract the main SD records.}
    {FXX03151999-2: All move taxes must have a calc code of 'T'.}

  ExtractSDRecords(SDTable, SDCodeTable, TaxRollYear, ProcessingType,
                   SwisSBLKey, SDExtractRecs, NumSDRecs);

   {Extract the this year parcel record.}

  New(ParcelRec);
  ExtractOneParcelRecord(ParcelRec, ParcelTable, AssessmentTable,
                         EXTable, ExCodeTable, SortAVChangesTable, SwisSBLKey,
                         NumResSites, NumComSites,
                         NumEXRecs, NumSDRecs,
                         NumSalesRecs, ProcessingType, TaxableStatusDate,
                         PriorValues, TYValues, NYValues,
                         EqualizationInc, PhysicalQtyInc,
                         EqualizationDec, PhysicalQtyDec, PriorHoldValue,
                         HoldPriorRollSection, HoldPriorStatus,
                         HoldPriorHomestead, HoldPriorPropClass,
                         PrintTYAndNY, Is210File);

  ParcelExtractRecs.Add(ParcelRec);

      {Do the class record if needed.}

  TempStr := ConvertSwisSBLToDashDot(SwisSBLKey);

  Found := FindKeyOld(ClassTable, ['TaxRollYr', 'SwisSBLKey'],
                      [TaxRollYear, SwisSBLKey]);

  If Found
    then
      begin
        New(ClassRec);
        ExtractClassRecord(ClassTable, ParcelTable, EXTable,
                           EXCodeTable, TaxRollYear, ProcessingType,
                           SwisSBLKey, ClassRec, PriorValues, TYValues, NYValues);
        ClassExtractRec.Add(ClassRec);

      end;  {If Found}

end;  {ExtractMainRecordsForParcel}

{=======================================================================}
Procedure WriteSalesSectionHeaderRecord(var RPSFile : TextFile;
                                            SwisCode : String);

var
  SalesHeader : PRPSExtractRec;

begin
  New(SalesHeader);
  InitializeRPSExtractString(SalesHeader);
  RPSExtractStrCat(SalesHeader, '000001');
  RPSExtractStrCat(SalesHeader, Copy(SwisCode, 1, 2));
  RPSExtractStrCat(SalesHeader, Take(31, ''));
  RPSExtractStrCat(SalesHeader, 'A1');
  RPSExtractStrCat(SalesHeader, Take(89, ''));
  RPSExtractStrCat(SalesHeader, Take(16, 'RPS995/V03/PAS'));
  RPSExtractStrCat(SalesHeader, Take(6, MakeMMDDYY(Date)));
  RPSExtractStrCat(SalesHeader, ConstStr('0', 255));
  RPSExtractStrCat(SalesHeader, ConstStr('0', 255));
  RPSExtractStrCat(SalesHeader, ConstStr('0', 143));
  RPSExtractStrCat(SalesHeader, Take(16, ''));
  RPSExtractStrCat(SalesHeader, '1');
  WriteOneRPSExtractRecToFile(RPSFile, SalesHeader, '', False);

    {FXX10081997-1: - Use FreeMem instead of Dispose in order to free the
                       exact amount.}

  FreeMem(SalesHeader, SizeOf(RPSExtractRec));

end;  {WriteSalesSectionHeaderRecord}

{=======================================================================}
Procedure WriteParcelSectionHeaderRecord(var RPSFile : TextFile;
                                             SwisCode : String);

var
  ParcelHeader : PRPSExtractRec;

begin
  New(ParcelHeader);
  InitializeRPSExtractString(ParcelHeader);
  RPSExtractStrCat(ParcelHeader, '999999');
  RPSExtractStrCat(ParcelHeader, Copy(SwisCode, 1, 2));
  RPSExtractStrCat(ParcelHeader, Take(31, ''));
  RPSExtractStrCat(ParcelHeader, 'A1');
  RPSExtractStrCat(ParcelHeader, Take(89, ''));
  RPSExtractStrCat(ParcelHeader, Take(16, 'RPS995/V03/PAS'));
  RPSExtractStrCat(ParcelHeader, MakeMMDDYY(Date));
  RPSExtractStrCat(ParcelHeader, ConstStr('0', 255));
  RPSExtractStrCat(ParcelHeader, ConstStr('0', 255));
  RPSExtractStrCat(ParcelHeader, ConstStr('0', 143));
  RPSExtractStrCat(ParcelHeader, Take(16, ''));
  RPSExtractStrCat(ParcelHeader, '3');
  WriteOneRPSExtractRecToFile(RPSFile, ParcelHeader, '', False);

    {FXX10081997-1: - Use FreeMem instead of Dispose in order to free the
                       exact amount.}

  FreeMem(ParcelHeader, SizeOf(RPSExtractRec));

end;  {WriteParcelSectionHeaderRecord}

{==============================================================================}
Procedure InitBaseInfoRec(var BaseInfoRec : BaseInfoRecord);

begin
  with BaseInfoRec do
    begin
      TotalAssessedVal := 0;
      LandVal := 0;
      HstdAssessedVal := 0;
      HstdLandVal := 0;
      NonhstdAssessedVal := 0;
      NonhstdLandVal := 0;
      PriorHoldValue := 0;
      RollSection := '';
      HomesteadCode := '';
      OwnershipCode := '';
      SchoolDistrict := '';
      ResidentialPercent := 0;
      PriorHoldPropertyClass := '';
      PriorHoldStatus := '';
      PriorHoldHomesteadCode := '';
      PriorHoldRollSection := '';

    end;  {with BaseInfoRec do}

end;  {InitBaseInfoRec}

{==============================================================================}
Procedure FillInBaseInfoRec(var BaseInfoRec : BaseInfoRecord;
                                SwisSBLKey : String;
                                AssessmentYear,
                                GlblThisYear : String;
                                PriorParcelTable,
                                PriorAssessmentTable,
                                PriorClassTable,
                                ParcelTable,
                                AssessmentTable,
                                ClassTable : TTable;
                                PriorYearRec : Boolean);

var
  SBLRec : SBLRecord;
  ParcelFound, ClassRecFound : Boolean;
  TempParcelTable, TempAssessmentTable, TempClassTable : TTable;

begin
  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

    {FXX09091999-5: Need to initialize base info record.}

  with BaseInfoRec do
    begin
      TotalAssessedVal := 0;
      LandVal := 0;
      HstdAssessedVal := 0;
      HstdLandVal := 0;
      NonhstdAssessedVal := 0;
      NonhstdLandVal := 0;
      PriorHoldValue := 0;
      RollSection := '';
      HomesteadCode := '';
      OwnershipCode := '';
      SchoolDistrict := '';
      ResidentialPercent := 0;
      PropertyClass := '';
      PriorHoldPropertyClass := '';
      PriorHoldStatus := '';
      PriorHoldHomesteadCode := '';
      PriorHoldRollSection := '';

    end;  {with BaseInfoRec do}

  If PriorYearRec
    then
      begin
        TempParcelTable := PriorParcelTable;
        TempAssessmentTable := PriorAssessmentTable;
        TempClassTable := PriorClassTable;
      end
    else
      begin
        TempParcelTable := ParcelTable;
        TempAssessmentTable := AssessmentTable;
        TempClassTable := ClassTable;
      end;

  with SBLRec do
    ParcelFound := FindKeyOld(TempParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot',
                               'Sublot', 'Suffix'],
                              [AssessmentYear, SwisCode, Section,
                               Subsection, Block, Lot,
                               Sublot, Suffix]);

  If ParcelFound
    then
      begin
        FindKeyOld(TempAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                   [AssessmentYear, SwisSBLKey]);
        ClassRecFound := FindKeyOld(TempClassTable, ['TaxRollYr', 'SwisSBLKey'],
                                    [AssessmentYear, SwisSBLKey]);

        with TempParcelTable do
          begin
            BaseInfoRec.RollSection := FieldByName('RollSection').Text;
            BaseInfoRec.OwnershipCode := FieldByName('OwnershipCode').Text;
            BaseInfoRec.SchoolDistrict := FieldByName('SchoolCode').Text;
            BaseInfoRec.HomesteadCode := FieldByName('HomesteadCode').Text;
            BaseInfoRec.PropertyClass := FieldByName('PropertyClassCode').Text;
            BaseInfoRec.ResidentialPercent := FieldByName('ResidentialPercent').AsFloat;
            BaseInfoRec.PriorHoldPropertyClass := FieldByName('HoldPriorPropClass').Text;
            BaseInfoRec.PriorHoldStatus := FieldByName('HoldPriorStatus').Text;
            BaseInfoRec.PriorHoldHomesteadCode := FieldByName('HoldPriorHomestead').Text;
            BaseInfoRec.PriorHoldRollSection := FieldByName('HoldPriorRollSection').Text;

          end;  {with TempParcelTable do}

        with TempAssessmentTable do
          begin
            BaseInfoRec.LandVal := FieldByName('LandAssessedVal').AsFloat;
            BaseInfoRec.TotalAssessedVal := FieldByName('TotalAssessedVal').AsFloat;
            BaseInfoRec.PriorHoldValue := FieldByName('HoldPriorValue').AsFloat;
          end;

        If ClassRecFound
          then
              {FXX10121998-5: Wrong field names for assessed vals.}

            with TempClassTable do
              begin
                BaseInfoRec.HstdAssessedVal := FieldByName('HstdTotalVal').AsFloat;
                BaseInfoRec.HstdLandVal := FieldByName('HstdLandVal').AsFloat;
                BaseInfoRec.NonhstdAssessedVal := FieldByName('NonhstdTotalVal').AsFloat;
                BaseInfoRec.NonhstdLandVal := FieldByName('NonhstdLandVal').AsFloat;

              end;  {with TempClassTable do}

      end
    else
      If (PriorYearRec and
          (GetRecordCount(PriorParcelTable) = 0))  {FXX03212000-1: Only do this if no history at all.}
        then
          begin
              {The prior year rec was not found, but could be in ThisYear prior fields.}

            with SBLRec do
              FindKeyOld(ParcelTable,
                         ['TaxRollYr', 'SwisCode', 'Section',
                          'Subsection', 'Block', 'Lot',
                          'Sublot', 'Suffix'],
                         [GlblThisYear, SwisCode, Section,
                          Subsection, Block, Lot,
                          Sublot, Suffix]);

            FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                       [GlblThisYear, SwisSBLKey]);
            ClassRecFound := FindKeyOld(ClassTable,
                                        ['TaxRollYr', 'SwisSBLKey'],
                                        [GlblThisYear, SwisSBLKey]);

            with ParcelTable do
              begin
                BaseInfoRec.RollSection := FieldByName('PriorRollSection').Text;
                BaseInfoRec.OwnershipCode := FieldByName('PriorOwnershipCode').Text;
                BaseInfoRec.SchoolDistrict := FieldByName('PriorSchoolDistrict').Text;
                BaseInfoRec.HomesteadCode := FieldByName('PriorHomesteadCode').Text;
                BaseInfoRec.PropertyClass := FieldByName('PriorPropertyClass').Text;
                BaseInfoRec.ResidentialPercent := FieldByName('PriorResPercent').AsFloat;
                BaseInfoRec.PriorHoldPropertyClass := FieldByName('HoldPriorPropClass').Text;
                BaseInfoRec.PriorHoldStatus := FieldByName('HoldPriorStatus').Text;
                BaseInfoRec.PriorHoldHomesteadCode := FieldByName('HoldPriorHomestead').Text;
                BaseInfoRec.PriorHoldRollSection := FieldByName('HoldPriorRollSection').Text;

              end;  {with TempParcelTable do}

            with AssessmentTable do
              begin
                BaseInfoRec.LandVal := FieldByName('PriorLandValue').AsFloat;
                BaseInfoRec.TotalAssessedVal := FieldByName('PriorTotalValue').AsFloat;
                BaseInfoRec.PriorHoldValue := FieldByName('HoldPriorValue').AsFloat;
              end;

              {FXX10211998-13: Need to store prior class values, too.}

            If ClassRecFound
              then
                  {FXX10121998-5: Wrong field names for assessed vals.}

                with ClassTable do
                  begin
                    BaseInfoRec.HstdAssessedVal := FieldByName('HstdPriorTotalVal').AsFloat;
                    BaseInfoRec.HstdLandVal := FieldByName('HstdPriorLandVal').AsFloat;
                    BaseInfoRec.NonhstdAssessedVal := FieldByName('NonhstdPriorTotalVal').AsFloat;
                    BaseInfoRec.NonhstdLandVal := FieldByName('NonhstdPriorLandVal').AsFloat;

                  end;  {with TempClassTable do}

          end;  {If PriorYearRec}

end;  {FillInBaseInfoRec}

{==============================================================================}
Procedure ExtractInformationForOneParcel(var RPSFile : TextFile;
                                             Form : TForm;
                                             FileName : String;
                                         var SwisSBLKey : String;  {SBL Key that was processed.}
                                             SalesTable,
                                             PriorParcelTable, ThisYearParcelTable, NextYearParcelTable,
                                             PriorAssessmentTable, ThisYearAssessmentTable, NextYearAssessmentTable,
                                             PriorClassTable, ThisYearClassTable, NextYearClassTable,
                                             ThisYearSDTable, NextYearSDTable,
                                             ThisYearEXTable, NextYearEXTable,
                                             ThisYearEXCodeTable, NextYearEXCodeTable,
                                             ThisYearSDCodeTable,
                                             SortAVChangesTable : TTable;
                                             TYTaxableStatusDate,
                                             NYTaxableStatusDate : String;
                                             ShowBothThisAndNextYear,
                                             bShowNextYearOnly,
                                             IncludeParcelInventory,
                                             SetVillageExemptionFlagsToTrue : Boolean;
                                         var NumTYParcelsExtracted,
                                             NumNYParcelsExtracted,
                                             NumTYParcelsExtractActual : LongInt;
                                             SelectedSwisCodes : TStringList;
                                             slSelectedRollSections : TStringList;
                                         var Done,
                                             Quit : Boolean);

{Given a SwisSBL, write the extract information for this parcel. We will write
 either this year and next year or just this year depending on what they
 specified. Also, if they want inventory, we will put it out.}

var
  PrintTYAndNY, ParcelDifferencesExist,
  PrintTYParcel, PrintNYParcel, Is210File : Boolean;
  ProcessingType, I, NumResSites, NumComSites : Integer;
  TYParcelExtractRecs, TYClassExtractRec,
  TYEXExtractRecs, TYSDExtractRecs,
  NYParcelExtractRecs, NYClassExtractRec,
  NYEXExtractRecs, NYSDExtractRecs,
  ResInventoryRecords, ComInventoryRecords : TList;
  TaxRollYear : String;
  TYParcelSBL, NYParcelSBL : String;
  PriorValues, TYValues, NYValues : BaseInfoRecord;
  TYSwisCode, NYSwisCode : String;
  EqualizationInc, PhysicalQtyInc,
  EqualizationDec, PhysicalQtyDec, PriorHoldValue : Comp;
  HoldPriorRollSection, HoldPriorStatus, HoldPriorHomestead : String;
  HoldPriorPropClass : String;
  ResSiteTable, ResBldgTable,
  ResLandTable, ResImprovementTable, ResForestTable,
  ComSiteTable, ComBldgTable,
  ComRentTable, ComLandTable,
  ComImprovementTable, ComIncExpTable : TTable;
  TempString : String;

begin
  Is210File := (Pos('210', FileName) > 0);
  NumResSites := 0;
  NumComSites := 0;
  ResInventoryRecords := TList.Create;
  ComInventoryRecords := TList.Create;
  TYParcelExtractRecs := TList.Create;
  TYClassExtractRec := TList.Create;
  TYEXExtractRecs := TList.Create;
  TYSDExtractRecs := TList.Create;
  NYParcelExtractRecs := TList.Create;
  NYClassExtractRec := TList.Create;
  NYEXExtractRecs := TList.Create;
  NYSDExtractRecs := TList.Create;

  EqualizationInc := 0;
  PhysicalQtyInc := 0;
  EqualizationDec := 0;
  PhysicalQtyDec := 0;
  PriorHoldValue := 0;

    {First see what parcel SBL we are on in this year and next year and
     which table(s) we should get a new parcel for.}

  TYParcelSBL := ExtractSSKey(ThisYearParcelTable);
  NYParcelSBL := ExtractSSKey(NextYearParcelTable);

  If ((NumTYParcelsExtracted > 0) and
      ((not ShowBothThisAndNextYear) or  {If they don't want both TY and NY, we want to just go thru TY.}
       (Take(26, TYParcelSBL) <= Take(26, NYParcelSBL))))
    then
      try
        ThisYearParcelTable.Next;
      except
        SystemSupport(500, ThisYearParcelTable, 'Error getting parcel in this year file.',
                      'RPS995UT.PAS', GlblErrorDlgBox);
        Quit := True;
      end;

  If (ShowBothThisAndNextYear and
      (Take(26, NYParcelSBL) <= Take(26, TYParcelSBL)))
    then
      try
        NextYearParcelTable.Next;
      except
        SystemSupport(500, NextYearParcelTable, 'Error getting parcel in next year file.',
                      'RPS995UT.PAS', GlblErrorDlgBox);
        Quit := True;
      end;

    {FXX03041998-5: We need to check here for EOF, not in main routine.
                    We were getting duplicate of last SBL because
                    we were checking too late.}

    {If they are doing just this year, look for an EOF on
     the TY file to know that they are done. Otherwsie,
     we have to check both parcel files.}

    {FXX12071998-5: End if higher SBL than selected swis codes.}

    {FXX05072002-1: The TY and NY Parcel SBL vars were not being set before the text and
                    if it was run for one swis code, one extra parcel appeared.}

  TYParcelSBL := ExtractSSKey(ThisYearParcelTable);
  NYParcelSBL := ExtractSSKey(NextYearParcelTable);

  TYSwisCode := Take(6, TYParcelSBL);
  NYSwisCode := Take(6, NYParcelSBL);

  If ((not ShowBothThisAndNextYear) and
      (ThisYearParcelTable.EOF or
       (TYSwisCode > SelectedSwisCodes[SelectedSwisCodes.Count - 1])))
    then Done := True;

  If (ShowBothThisAndNextYear and
      ((ThisYearParcelTable.EOF or
        NextYearParcelTable.EOF) or
       (NYSwisCode > SelectedSwisCodes[SelectedSwisCodes.Count - 1])))
    then Done := True;

    {Now figure out the new SBL's for the next year and this year parcel
     tables. If the SBL of a table is less than the other table, we will
     print the lesser one only. If they are equal, they are the same
     parcel, so we will print both (if they want to see both).}

    {FXX12071998-2: Only extract the selected swis codes.}

  If ((SelectedSwisCodes.IndexOf(Take(6, TYParcelSBL)) > -1) and
      (not Done))
    then
      begin
        PrintTYParcel := False;
        PrintNYParcel := False;

        If ((not ShowBothThisAndNextYear) or  {If they don't want both TY and NY, we want to just go thru TY.}
            (Take(26, TYParcelSBL) <= Take(26, NYParcelSBL)))
          then PrintTYParcel := True;

        If ((ShowBothThisAndNextYear or
             bShowNextYearOnly) and
            (Take(26, NYParcelSBL) <= Take(26, TYParcelSBL)))
          then
            begin
                 {If the SBLs are the same, only print the NY parcel if there is a change to TY.}

               If (NYParcelSBL = TYParcelSBL)
                 then
                   begin
                     (*ParcelDifferencesExist := RecordsAreDifferent(ThisYearParcelTable, NextYearParcelTable);

                     If ((ThisYearParcelTable.FieldByName('LastChangeDate').AsDateTime <>
                          NextYearParcelTable.FieldByName('LastChangeDate').AsDateTime) or
                         ParcelDifferencesExist)
                       then *)PrintNYParcel := True;

                   end
                 else PrintNYParcel := True;

            end;  {If (ShowBothThisAndNextYear and ...}

        PrintTYAndNY := PrintTYParcel and PrintNYParcel;

          {Set the SBL of the parcel that we are going to print.}

        If PrintTYParcel
          then SwisSBLKey := TYParcelSBL
          else SwisSBLKey := NYParcelSBL;

          {Now get NY, current, and prior assessed values.}

        InitBaseInfoRec(PriorValues);
        InitBaseInfoRec(TYValues);
        InitBaseInfoRec(NYValues);

        FillInBaseInfoRec(PriorValues, SwisSBLKey, GlblHistYear, GlblThisYear,
                          PriorParcelTable, PriorAssessmentTable, PriorClassTable,
                          ThisYearParcelTable, ThisYearAssessmentTable, ThisYearClassTable, True);

        FillInBaseInfoRec(TYValues, SwisSBLKey, GlblThisYear, GlblThisYear,
                          PriorParcelTable, PriorAssessmentTable, PriorClassTable,
                          ThisYearParcelTable, ThisYearAssessmentTable, ThisYearClassTable, False);

        FillInBaseInfoRec(NYValues, SwisSBLKey, GlblNextYear, GlblThisYear,
                          PriorParcelTable, PriorAssessmentTable, PriorClassTable,
                          NextYearParcelTable, NextYearAssessmentTable, NextYearClassTable, False);

          {First, do the inventory for the parcel so that we know the
           number of residential and commercial sites for the parcel record.
           If there was no NextYear parcel or they wanted to see ThisYear only,
           (i.e. a deleted parcel only in ThisYear), then the inventory is
           only in ThisYear, so we will have to close the inventory tables and
           reopen them for ThisYear. If the parcel exists in both ThisYear and
           NextYear, we will use the NextYear inventory since this is the most
           recent and hopefully accurate.}

        If IncludeParcelInventory
          then
            begin
              If (PrintNYParcel and
                  ShowBothThisAndNextYear)
                then
                  begin
                    TaxRollYear := GlblNextYear;
                    ProcessingType := NextYear;
                  end
                else
                  begin
                    TaxRollYear := GlblThisYear;
                    ProcessingType := ThisYear;

                  end;  {If ((not FoundNYParcel) and ...}

              ResSiteTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
                                                                     ProcessingType);
              ResBldgTable := FindTableInDataModuleForProcessingType(DataModuleResidentialBuildingTableName,
                                                                     ProcessingType);
              ResLandTable := FindTableInDataModuleForProcessingType(DataModuleResidentialLandTableName,
                                                                     ProcessingType);
              ResImprovementTable := FindTableInDataModuleForProcessingType(DataModuleResidentialImprovementTableName,
                                                                            ProcessingType);
              ResForestTable := FindTableInDataModuleForProcessingType(DataModuleResidentialForestTableName,
                                                                       ProcessingType);

                {Commercial inventory tables.}

              ComSiteTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                                     ProcessingType);
              ComBldgTable := FindTableInDataModuleForProcessingType(DataModuleCommercialBuildingTableName,
                                                                     ProcessingType);
              ComLandTable := FindTableInDataModuleForProcessingType(DataModuleCommercialLandTableName,
                                                                     ProcessingType);
              ComImprovementTable := FindTableInDataModuleForProcessingType(DataModuleCommercialImprovementTableName,
                                                                            ProcessingType);
              ComRentTable := FindTableInDataModuleForProcessingType(DataModuleCommercialRentTableName,
                                                                     ProcessingType);
              ComIncExpTable := FindTableInDataModuleForProcessingType(DataModuleCommercialIncomeExpenseTableName,
                                                                       ProcessingType);

              NumResSites := CalculateNumSites(ResSiteTable, TaxRollYear,
                                               SwisSBLKey, 0, False);

              NumComSites := CalculateNumSites(ComSiteTable, TaxRollYear,
                                               SwisSBLKey, 0, False);

              ExtractResInventoryRecords(ResInventoryRecords,
                                         ResSiteTable,
                                         ResBldgTable,
                                         ResLandTable,
                                         ResImprovementTable,
                                         ResForestTable,
                                         SwisSBLKey, NumResSites, 0, False,
                                         TaxRollYear);

              ExtractComInventoryRecords(ComInventoryRecords,
                                         ComSiteTable,
                                         ComBldgTable,
                                         ComRentTable,
                                         ComLandTable,
                                         ComImprovementTable,
                                         ComIncExpTable,
                                         SwisSBLKey, NumComSites, 0, False,
                                         TaxRollYear);

            end;  {If IncludeParcelInventory}

        PriorHoldValue := 0;
        HoldPriorRollSection := '';
        HoldPriorStatus := '';
        HoldPriorHomestead := '';
        HoldPriorPropClass := '';

          {Extract the This Year parcel information if the parcel ID matches in the this year
           file or if the parcel ID is less than the parcel ID for the next year file.}
          {FXX06102009-1(2.17.1.25)[F983]: Add roll section selection to the 995.}

        If PrintTYParcel
          then
            begin
              NumTYParcelsExtracted := NumTYParcelsExtracted + 1;
              TempString := Take(6, TYParcelSBL);

                {FXX03151999-2: All move taxes must have a calc code of 'T'.}

              If ((not bShowNextYearOnly) and
                  _Compare(slSelectedRollSections.IndexOf(ThisYearParcelTable.FieldByName('RollSection').AsString), -1, coGreaterThan))
                then
                  begin
                    inc(NumTYParcelsExtractActual);
                    ExtractMainRecordsForParcel(TYParcelExtractRecs, TYClassExtractRec,
                                                TYEXExtractRecs, TYSDExtractRecs,
                                                SwisSBLKey, ThisYearParcelTable,
                                                ThisYearAssessmentTable,
                                                ThisYearClassTable,
                                                ThisYearSDTable, ThisYearSDCodeTable,
                                                ThisYearEXTable,
                                                ThisYearEXCodeTable,
                                                SalesTable, SortAVChangesTable, NumResSites,
                                                NumComSites, GlblThisYear, ThisYear,
                                                TYTaxableStatusDate, PriorValues,
                                                TYValues, NYValues, PrintTYAndNY,
                                                Is210File, EqualizationInc, PhysicalQtyInc,
                                                EqualizationDec, PhysicalQtyDec, PriorHoldValue,
                                                HoldPriorRollSection, HoldPriorStatus,
                                                HoldPriorHomestead, HoldPriorPropClass,
                                                SetVillageExemptionFlagsToTrue);

                  end;  {If _Compare(slSelectedRollSections...}


              ProgressDialog.Update(Form,
                                    ConvertSwisSBLToDashDot(SwisSBLKey));

            end;  {If PrintTYParcel}

        {If they want to see this year and next year in the 995 file extract and
        there is a next year parcel, then write out the
        parcel information for the NextYear parcel.}

        If (PrintNYParcel and
            (ShowBothThisAndNextYear or
             bShowNextYearOnly) and
            _Compare(slSelectedRollSections.IndexOf(NextYearParcelTable.FieldByName('RollSection').AsString), -1, coGreaterThan))
          then
            begin
              inc(NumNYParcelsExtracted);
              ExtractMainRecordsForParcel(NYParcelExtractRecs, NYClassExtractRec,
                                          NYEXExtractRecs, NYSDExtractRecs,
                                          SwisSBLKey, NextYearParcelTable,
                                          NextYearAssessmentTable,
                                          NextYearClassTable,
                                          NextYearSDTable, ThisYearSDCodeTable,
                                          NextYearEXTable,
                                          NextYearEXCodeTable,
                                          SalesTable, SortAVChangesTable, NumResSites,
                                          NumComSites, GlblNextYear, NextYear,
                                          NYTaxableStatusDate, PriorValues,
                                          TYValues, NYValues, PrintTYAndNY,
                                          Is210File, EqualizationInc, PhysicalQtyInc,
                                          EqualizationDec, PhysicalQtyDec, PriorHoldValue,
                                          HoldPriorRollSection, HoldPriorStatus,
                                          HoldPriorHomestead, HoldPriorPropClass,
                                          SetVillageExemptionFlagsToTrue);

              ProgressDialog.Update(Form,
                                    ConvertSwisSBLToDashDot(SwisSBLKey));

            end;  {If (PrintNYParcel and ...}

          {Now write out all the information to the file, starting with
           the parcel, class, exemption, and special district records.}

        If PrintTYParcel
          then
            begin
                {Before we start writing out data, figure out where the '999'
                 marking the last record for this parcel should go.}

              MarkLastRecordForParcel(TYParcelExtractRecs,
                                      TYClassExtractRec,
                                      TYEXExtractRecs, TYSDExtractRecs,
                                      ResInventoryRecords, ComInventoryRecords);

              WriteMainRecordsForParcel(RPSFile, TYParcelExtractRecs,
                                        TYClassExtractRec,
                                        TYEXExtractRecs, TYSDExtractRecs);

            end;  {If PrintTYParcel}

        If (PrintNYParcel and
            (ShowBothThisAndNextYear or
             bShowNextYearOnly))
          then
            begin
                {Before we start writing out data, figure out where the '999'
                 marking the last record for this parcel should go.}

              MarkLastRecordForParcel(NYParcelExtractRecs,
                                      NYClassExtractRec,
                                      NYEXExtractRecs, NYSDExtractRecs,
                                      ResInventoryRecords, ComInventoryRecords);

              WriteMainRecordsForParcel(RPSFile, NYParcelExtractRecs,
                                        NYClassExtractRec,
                                        NYEXExtractRecs, NYSDExtractRecs);

            end;  {If PrintNYParcel and ...}

          {Finally, if there was inventory, write it out.}

        If IncludeParcelInventory
          then
            begin
                 {First add the residential inventory records
                  to the file.}

              For I := 0 to (ResInventoryRecords.Count - 1) do
                WriteOneRPSExtractRecToFile(RPSFile, ResInventoryRecords[I], '', False);

                 {Now add the commercial inventory records.}

              For I := 0 to (ComInventoryRecords.Count - 1) do
                WriteOneRPSExtractRecToFile(RPSFile, ComInventoryRecords[I], '', False);

            end;  {If IncludeParcelInventory}

           {Now free the residential and commercial inventory record TLists.}

        FreeTList(ResInventoryRecords, SizeOf(RPSExtractRec));
        FreeTList(ComInventoryRecords, SizeOf(RPSExtractRec));
        FreeTList(TYParcelExtractRecs, SizeOf(RPSExtractRec));
        FreeTList(TYClassExtractRec, SizeOf(RPSExtractRec));
        FreeTList(TYEXExtractRecs, SizeOf(RPSExtractRec));
        FreeTList(TYSDExtractRecs, SizeOf(RPSExtractRec));
        FreeTList(NYParcelExtractRecs, SizeOf(RPSExtractRec));
        FreeTList(NYClassExtractRec, SizeOf(RPSExtractRec));
        FreeTList(NYEXExtractRecs, SizeOf(RPSExtractRec));
        FreeTList(NYSDExtractRecs, SizeOf(RPSExtractRec));

      end;  {If not Done}

end;  {ExtractInformationForOneParcel}

{=======================================================================}
Procedure WriteType01Record(var RPS060File : TextFile;
                                SwisCodeTable,
                                AssessmentYearCtlTable : TTable);

begin
  Write(RPS060File, '01');  {1-2: Rec type}
  Write(RPS060File, Take(2, SwisCodeTable.FieldByName('SwisCode').Text));  {3-4: County code}
  Write(RPS060File, Take(11, ''));  {5-15: Filler}
  Write(RPS060File, Take(20, GlblCountyName));  {16-35: County name}
  Writeln(RPS060File, AssessmentYearCtlTable.FieldByName('VeteransLimitSet').Text);  {36: Vet limit set}

end;  {WriteType01Record}

{=======================================================================}
Procedure WriteType10Records(var RPS060File : TextFile;
                                 SwisCodeTable : TTable);

{Write the Swis code records.}

var
  FirstTimeThrough, Done : Boolean;
  TempStr : String;

begin
  FirstTimeThrough := True;
  Done := False;

  SwisCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwisCodeTable.Next;

    If SwisCodeTable.EOF
      then Done := True;

    If not Done
      then
        with SwisCodeTable do
          begin
            Write(RPS060File, '10');  {1-2: Rec type}
            Write(RPS060File, FieldByName('SwisCode').Text);  {3-8: EX Code}
            Write(RPS060File, Take(7, ''));  {9-15: Filler}
            Write(RPS060File, Take(20, FieldByName('MunicipalityName').Text));  {16-35: Town name}
            Write(RPS060File, Take(20, GlblMunicipalityName));  {36-55: Munic name}

            If FieldByName('Classified').AsBoolean
              then
                begin
                  If GlblMunicipalityUsesTwoTaxRates
                    then TempStr := '1'
                    else TempStr := '2';
                end
              else TempStr := ' ';
            Write(RPS060File, Take(1, TempStr));  {56: Homestead designation}

            If FieldByName('AssessingVillage').AsBoolean
              then TempStr := 'V'
              else TempStr := ' ';
            Write(RPS060File, Take(1, TempStr));  {57: Village processing}

            Write(RPS060File, Take(4, FieldByName('SplitVillageCode').Text));  {58-61: Town name}

              {FXX12081998-2: Only write the vet limit and equalization rate
                              on the last swis.}
              {FXX04012002-3: If this is a village, include the veterans limit
                              set on all swis codes.}

            If ((Copy(FieldByName('SwisCode').Text, 5, 2) = '89') or
                (Copy(FieldByName('SwisCode').Text, 5, 2) = '00') or
                (GlblMunicipalityType = mtVillage))
              then
                begin
                  Write(RPS060File, FieldByName('VeteransLimitSet').Text);  {62: Vet limit set}
                  Write(RPS060File, FormatRPSNumericString(FieldByName('EqualizationRate').Text, 5, 2));  {63-67: Equal rate}
                end
              else Write(RPS060File, Take(6, ''));

            Writeln(RPS060File, FormatRPSNumericString(FieldByName('UniformPercentValue').Text,
                                                       5, 2)); {68-72: Uniform % of val}

          end;  {with SwisCodeTable do}

  until Done;

end;  {WriteType10Records}

{=======================================================================}
Function DetermineIfNumericSegment(Section : TSBLSegmentFormatType) : Char;

begin
  If fmNumeric in Section
    then Result := 'N'
    else Result := 'A';

end;  {DetermineIfNumericSegment}

{=======================================================================}
Function DetermineSuppressionRule(Section : TSBLSegmentFormatType) : Char;

begin
  If fmShiftRightAddZeroes in Section
    then Result := 'Z'
    else
      If fmLeftJustify in Section
        then Result := 'B'
        else Result := 'L';

end;  {DetermineSuppressionRule}

{=======================================================================}
Procedure WriteType11Record(var RPS060File : TextFile;
                                SwisCodeTable,
                                AssessmentYearCtlTable : TTable);

{FXX04012002-4: For a village, have a type '11' record for all
                swis codes.}

var
  FirstTimeThrough, Done : Boolean;

begin
  FirstTimeThrough := True;
  Done := False;

  If (GlblMunicipalityType = mtVillage)
    then SwisCodeTable.First
    else SwisCodeTable.Last;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwisCodeTable.Next;

    If (SwisCodeTable.EOF and
        (GlblMunicipalityType = mtVillage))
      then Done := True;

    If not Done
      then
        with SwisCodeTable do
          begin
            Write(RPS060File, '11');  {1-2: Rec type}
            Write(RPS060File, FieldByName('SwisCode').Text);  {3-8: County code}
            Write(RPS060File, Take(7, ''));  {9-15: Filler}

            with AssessmentYearCtlTable do
              begin
                Write(RPS060File, MakeMMDDYY(FieldByName('FinalRollDate').AsDateTime));  {16-21: Final roll date}
                Write(RPS060File, Copy(MakeMMDDYY(FieldByName('TaxableStatusDate').AsDateTime), 5, 2));  {22-23: Taxable status year}
              end;

            Write(RPS060File, 'Y');  {24: Next year processing}
            Write(RPS060File, 'Y');  {25: Sales transmittal option}

            Write(RPS060File, DetermineIfNumericSegment(GlblSectionFormat));
            Write(RPS060File, DetermineIfNumericSegment(GlblSubsectionFormat));
            Write(RPS060File, DetermineIfNumericSegment(GlblBlockFormat));
            Write(RPS060File, DetermineIfNumericSegment(GlblLotFormat));
            Write(RPS060File, DetermineIfNumericSegment(GlblSublotFormat));
            Write(RPS060File, DetermineIfNumericSegment(GlblSuffixFormat));

            Write(RPS060File, DetermineSuppressionRule(GlblSectionFormat));
            Write(RPS060File, GlblSectionSeparator);
            Write(RPS060File, DetermineSuppressionRule(GlblSubsectionFormat));
            Write(RPS060File, GlblSubsectionSeparator);
            Write(RPS060File, DetermineSuppressionRule(GlblBlockFormat));
            Write(RPS060File, GlblBlockSeparator);
            Write(RPS060File, DetermineSuppressionRule(GlblLotFormat));
            Write(RPS060File, GlblLotSeparator);
            Write(RPS060File, DetermineSuppressionRule(GlblSublotFormat));
            Write(RPS060File, GlblSublotSeparator);
            Writeln(RPS060File, DetermineSuppressionRule(GlblSuffixFormat));

          end;  {with SwisCodeTable do}

    If (GlblMunicipalityType <> mtVillage)
      then Done := True;

  until Done;

end;  {WriteType11Record}

{=========================================================================}
Procedure WriteType20Records(var RPS060File : TextFile;
                                 ExemptionCodeTable : TTable);

{Write the exemption records.}

var
  FirstTimeThrough, Done : Boolean;
  TempStr : String;

begin
  FirstTimeThrough := True;
  Done := False;

  ExemptionCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ExemptionCodeTable.Next;

    If ExemptionCodeTable.EOF
      then Done := True;

      {FXX12081998-1: Don't write system exemption codes.}

    If ((not Done) and
        (ExemptionCodeTable.FieldByName('EXCode').Text[1] <> '5'))
      then
        with ExemptionCodeTable do
          begin
            Write(RPS060File, '20');  {1-2: Rec type}
            Write(RPS060File, FieldByName('EXCode').Text);  {3-7: EX Code}
            Write(RPS060File, Take(6, FieldByName('SW1').Text));  {8-13: Swis code}
            Write(RPS060File, Take(2, ''));  {14-15: Filler}
            Write(RPS060File, Take(10, FieldByName('Description').Text));  {16-25: EX name}
            Write(RPS060File, Take(1, FieldByName('CalcMethod').Text));  {26: Calc code}
            Write(RPS060File, Take(1, FieldByName('AmtVerification').Text));  {27: Amt verification}

            TempStr := FormatRPSNumericString(FieldByName('FixedAmount').Text, 6, 0);
            If (DezeroOnLeft(TempStr) = '')
              then TempStr := Take(6, '');
            Write(RPS060File, TempStr);  {28-33: Fixed amount}

            TempStr := FormatRPSNumericString(FieldByName('FixedPercentage').Text, 4, 2);
            If (DezeroOnLeft(TempStr) = '')
              then TempStr := Take(4, '');
            Write(RPS060File, TempStr);  {34-37: Fixed %}

            Write(RPS060File, BoolToChar(FieldByName('Section490').AsBoolean));  {38: 490?}

            If FieldByName('Section490').AsBoolean
              then Write(RPS060File, Take(2, ''))  {39-40: Blank - has 490}
              else
                begin
                  Write(RPS060File, BoolToChar(FieldByName('AdValorum').AsBoolean));  {39: Ad valorum}
                  Write(RPS060File, BoolToChar(FieldByName('ApplySpclAssessmentD').AsBoolean));  {40: Special assmt}
                end;

            Write(RPS060File, BoolToChar(FieldByName('ApplyChap562').AsBoolean));  {41: 305/306}
            Writeln(RPS060File, BoolToChar_Blank_Y(FieldByName('ExpirationDateReqd').AsBoolean));  {42: Termination year?}

          end;  {with ExemptionCodeTable do}

  until Done;

end;  {WriteType20Records}

{=======================================================================}
Procedure WriteType30Records(var RPS060File : TextFile;
                                 SchoolCodeTable : TTable);

{Write the school code records.}

var
  FirstTimeThrough, Done : Boolean;

begin
  FirstTimeThrough := True;
  Done := False;

  SchoolCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SchoolCodeTable.Next;

    If SchoolCodeTable.EOF
      then Done := True;

    If not Done
      then
        with SchoolCodeTable do
          begin
            Write(RPS060File, '30');  {1-2: Rec type}
            Write(RPS060File, FieldByName('SchoolCode').Text);  {3-8: School Code}
            Write(RPS060File, 'A');  {9: A card}
            Write(RPS060File, Take(6, ''));  {10-15: Filler}
            Write(RPS060File, Take(6, FieldByName('Swis1').Text));  {16-21: 1st swis}
            Write(RPS060File, Take(20, FieldByName('SchoolName').Text));  {22-41: School name}
            Write(RPS060File, Take(1, FieldByName('Homestead').Text));  {42: Hstd?}
            Writeln(RPS060File, Take(1, ''));  {43: Consolidated - skip}

          end;  {with SchoolCodeTable do}

  until Done;

end;  {WriteType30Records}

{=======================================================================}
Procedure WriteType40Records(var RPS060File : TextFile;
                                 SDCodeTable : TTable);

{Write the special district records.}

var
  FirstTimeThrough, Done : Boolean;
  TempFieldName1, TempFieldName2 : String;
  I : Integer;

begin
  FirstTimeThrough := True;
  Done := False;

  SDCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SDCodeTable.Next;

    If SDCodeTable.EOF
      then Done := True;

    If not Done
      then
        with SDCodeTable do
          begin
            Write(RPS060File, '40');  {1-2: Rec type}
            Write(RPS060File, FieldByName('SDistCode').Text);  {3-7: SD Code}

              {FXX12201998-3: Make sure to do a take on the swis code since it may
                              be 4 chars.}

            Write(RPS060File, Take(6, FieldByName('SW1').Text));  {8-13: Swis code}
            Write(RPS060File, Take(2, ''));  {14-15: Filler}
            Write(RPS060File, Take(20, FieldByName('Description').Text));  {16-35: District name}
            Write(RPS060File, BoolToChar_Blank_Y(FieldByName('SDHomestead').AsBoolean));  {36: Hstd?}
            Write(RPS060File, BoolToChar_Blank_Y(FieldByName('SDRs9').AsBoolean));  {37: RS9}
            Write(RPS060File, Take(1, FieldByName('DistrictType').Text));  {38: Dist Type}
            Write(RPS060File, BoolToChar_Blank_Y(FieldByName('Section490').AsBoolean));  {39: Sec 490}
            Write(RPS060File, BoolToChar_Blank_Y(FieldByName('Chapter562').AsBoolean));  {40: Sec 305/306}

              {Now do the extensions and CC/OM flags.}

            For I := 1 to 7 do
              begin
                TempFieldName1 := 'ECd' + IntToStr(I);
                TempFieldName2 := 'ECFlg' + IntToStr(I);
                Write(RPS060File, Take(2, FieldByName(TempFieldName1).Text) +
                                  Take(1, FieldByName(TempFieldName2).Text));

              end;  {For I := 1 to 7 do}

            Write(RPS060File, FormatRPSNumericString(FieldByName('Step1').Text, 5, 0));  {62-66: Stepped amount 1}
            Write(RPS060File, FormatRPSNumericString(FieldByName('Step2').Text, 5, 0));  {67-71: Stepped amount 2}
            Writeln(RPS060File, FormatRPSNumericString(FieldByName('Step3').Text, 5, 0));  {72-76: Stepped amount 3}

          end;  {with SDCodeTable do}

  until Done;

end;  {WriteType40Records}

{=========================================================================}
Procedure Create060File(var RPS060File : TextFile;
                            AssessmentYearCtlTable : TTable);

{CHG06121998-1: Write out the 060 file.}

var
  SwisCodeTable, ExemptionCodeTable,
  SchoolCodeTable, SDCodeTable : TTable;

begin
  SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                          ThisYear);
  SchoolCodeTable := FindTableInDataModuleForProcessingType(DataModuleSchoolCodeTableName,
                                                            ThisYear);
  SDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                        ThisYear);
  ExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                               ThisYear);

    {Do the county '01' record.}

  WriteType01Record(RPS060File, SwisCodeTable, AssessmentYearCtlTable);

    {Do the swis code '10' records.}

  WriteType10Records(RPS060File, SwisCodeTable);

    {Write the system setup record.}

  WriteType11Record(RPS060File, SwisCodeTable, AssessmentYearCtlTable);

    {Write the exemption records.}

  WriteType20Records(RPS060File, ExemptionCodeTable);

    {Write the school records.}

  WriteType30Records(RPS060File, SchoolCodeTable);

    {Write the SD code records.}

  WriteType40Records(RPS060File, SDCodeTable);

    {FXX12081998-2: The 060 must have at least one password - make it MPT.}

  Writeln(RPS060File, '99' + SwisCodeTable.FieldByName('SwisCode').Text +
                      '01     MPT99');

end;  {Create060File}

{===========================================================================}
Procedure Generate995File(Form : TForm;
                          SelectedSwisCodes : TStringList;
                          slSelectedRollSections : TStringList;
                          s060FileName : String;
                          s995FileName : String;
                          FileType : Integer;
                          ShowMessage,
                          ShowBothThisAndNextYear,
                          bShowNextYearOnly,
                          IncludeInventory,
                          SuppressSalesPrice,
                          AllowCancel,
                          SetVillageExemptionFlagsToTrue : Boolean;
                          ProgressDialog: TProgressDialog;
                          ZipCopyDlg: TZipCopyDlg);

var
  SwisCodeTable: TTable;
  ThisYearSDTable: TTable;
  NextYearSDTable: TTable;
  ResSiteTable: TTable;
  ResBldgTable: TTable;
  ResImprovementTable: TTable;
  ResLandTable: TTable;
  ResForestTable: TTable;
  ThisYearParcelTable: TTable;
  NextYearParcelTable: TTable;
  ThisYearAssessmentTable: TTable;
  NextYearAssessmentTable: TTable;
  ThisYearClassTable: TTable;
  NextYearClassTable: TTable;
  ThisYearEXTable: TTable;
  NextYearEXTable: TTable;
  ComIncExpTable: TTable;
  ComImprovementTable: TTable;
  ComBldgTable: TTable;
  ComRentTable: TTable;
  ComLandTable: TTable;
  ComSiteTable: TTable;
  SalesTable: TTable;
  NextYearEXCodeTable: TTable;
  ThisYearEXCodeTable: TTable;
  AssessmentYearCtlTable: TTable;
  PriorClassTable: TTable;
  PriorAssessmentTable: TTable;
  PriorParcelTable: TTable;
  ThisYearSDCodeTable: TTable;
  SortAVChangesTable : TTable;

  RPS060File, RPS995File : TextFile;
  NumSalesExtracted, NumTYParcelsExtracted,
  I, NumNYParcelsExtracted, NumTYParcelsExtractedActual : LongInt;
  SwisSBLKey : String;
  SwisCode, TYTaxableStatusDate, NYTaxableStatusDate : String;

  Quit, Done, FirstTimeThrough, Is210File,
  AllUsersLoggedOffPAS, OpenInventoryTables : Boolean;
  ReturnCode, InventoryProcessingType : Integer;
  TablesToBeOpen : Char;
  TempStr : String;

begin
  Is210File := (Pos('210', s995FileName) > 0);

  (*SwisCodeTable:= TTable.Create(nil);
  ThisYearSDTable:= TTable.Create(nil);
  NextYearSDTable:= TTable.Create(nil);
  ResSiteTable:= TTable.Create(nil);
  ResBldgTable:= TTable.Create(nil);
  ResImprovementTable:= TTable.Create(nil);
  ResLandTable:= TTable.Create(nil);
  ResForestTable:= TTable.Create(nil);
  ThisYearParcelTable:= TTable.Create(nil);
  NextYearParcelTable:= TTable.Create(nil);
  ThisYearAssessmentTable:= TTable.Create(nil);
  NextYearAssessmentTable:= TTable.Create(nil);
  ThisYearClassTable:= TTable.Create(nil);
  NextYearClassTable:= TTable.Create(nil);
  ThisYearEXTable:= TTable.Create(nil);
  NextYearEXTable:= TTable.Create(nil);
  ComIncExpTable:= TTable.Create(nil);
  ComImprovementTable:= TTable.Create(nil);
  ComBldgTable:= TTable.Create(nil);
  ComRentTable:= TTable.Create(nil);
  ComLandTable:= TTable.Create(nil);
  ComSiteTable:= TTable.Create(nil);
  SalesTable:= TTable.Create(nil);
  NextYearEXCodeTable:= TTable.Create(nil);
  ThisYearEXCodeTable:= TTable.Create(nil);
  AssessmentYearCtlTable:= TTable.Create(nil);
  PriorClassTable:= TTable.Create(nil);
  PriorAssessmentTable:= TTable.Create(nil);
  PriorParcelTable:= TTable.Create(nil);
  ThisYearSDCodeTable:= TTable.Create(nil); *)

    {We have to prime the table variables so that they get returned
     properly in the OpenTablesExclusive routine.}

  SalesTable := FindTableInDataModuleForProcessingType(DataModuleSalesTableName,
                                                       NoProcessingType);
  PriorParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                             History);
  ThisYearParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                ThisYear);
  NextYearParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                NextYear);
  PriorClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                            History);
  ThisYearClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                               ThisYear);
  NextYearClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                               NextYear);
  PriorAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                 History);
  ThisYearAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                    ThisYear);
  NextYearAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                    NextYear);

  ThisYearSDTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                            ThisYear);
  NextYearSDTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                            NextYear);
  ThisYearEXTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                            ThisYear);
  NextYearEXTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                            NextYear);
  ThisYearEXCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                ThisYear);
  NextYearEXCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                NextYear);
  ThisYearSDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                                ThisYear);

  ResSiteTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
                                                         ThisYear);
  ResBldgTable := FindTableInDataModuleForProcessingType(DataModuleResidentialBuildingTableName,
                                                         ThisYear);
  ResLandTable := FindTableInDataModuleForProcessingType(DataModuleResidentialLandTableName,
                                                         ThisYear);
  ResImprovementTable := FindTableInDataModuleForProcessingType(DataModuleResidentialImprovementTableName,
                                                                ThisYear);
  ResForestTable := FindTableInDataModuleForProcessingType(DataModuleResidentialForestTableName,
                                                           ThisYear);

  ComSiteTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                         ThisYear);
  ComBldgTable := FindTableInDataModuleForProcessingType(DataModuleCommercialBuildingTableName,
                                                         ThisYear);
  ComLandTable := FindTableInDataModuleForProcessingType(DataModuleCommercialLandTableName,
                                                         ThisYear);
  ComImprovementTable := FindTableInDataModuleForProcessingType(DataModuleCommercialImprovementTableName,
                                                                ThisYear);
  ComRentTable := FindTableInDataModuleForProcessingType(DataModuleCommercialRentTableName,
                                                         ThisYear);
  ComIncExpTable := FindTableInDataModuleForProcessingType(DataModuleCommercialIncomeExpenseTableName,
                                                           ThisYear);

    {FXX11041999-1: Create a seperate table of the exact av + and - for the 210.}

  SortAVChangesTable := TTable.Create(nil);

  with SortAVChangesTable do
    begin
      DatabaseName := 'PASSystem';
      TableType := ttDBase;
      TableName := 'SortAsrAVChanges';
      IndexName := 'BYSWISSBLKEY';
      Open;

    end;  {with SortAVChangesTable do}

  Quit := False;
  ExtractCancelled := False;
  NumSalesExtracted := 0;
  NumTYParcelsExtracted := 0;
  NumNYParcelsExtracted := 0;
  NumTYParcelsExtractedActual := 0;

  SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                          ThisYear);
  AssessmentYearCtlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                   ThisYear);

  ProgressDialog.CancelButtonVisible := AllowCancel;

    {CHG12262001-2: Never show warning message.}

  ShowMessage := False;

  If ShowMessage
    then ReturnCode := MessageDlg('Please make sure that no other users are ' + #13 +
                                  'making changes in the Property Assessment System.' + #13 +
                                  'Then click OK to begin or Cancel to quit.', mtInformation, [mbOK, mbCancel], 0)
    else ReturnCode := idOK;

    {If they clicked OK to do it, let's start!}

  If (ReturnCode = idOK)
    then
      begin
          {CHG06121998-1: Write out the 060 file.}

        AssignFile(RPS060File, s060FileName);
        Rewrite(RPS060File);
        Create060File(RPS060File, AssessmentYearCtlTable);
        CloseFile(RPS060File);

          {First verify that no other users are in the PAS system by trying to open the
           tables exclusive. We will try to open the sales tables if they want to include the
           sales portion of the 995. Otherwise, we will open the parcel tables.
           If at any point we fail, we will close all tables
           and tell them to try again after logging everyone out.}

        If (FileType in [ftSalesOnly, ftParcelAndSales])
          then
            begin
              TablesToBeOpen := 'S';
              InventoryProcessingType := SalesInventory;
            end
          else
            begin
                 {Parcel info only}

              TablesToBeOpen := 'P';

                {If they want to extract both this year and next year,
                 then we will use the next year inventory since it will
                 be the most recent. If they want just this year
                 information, we will use this year inventory.}

              If ShowBothThisAndNextYear
                then InventoryProcessingType := NextYear
                else InventoryProcessingType := ThisYear;

            end;  {else of If (FileType in ...}

        OpenInventoryTables := IncludeInventory;

          {FXX03151999-2: All move tax SD's must have a calc code of 'T'.}
          {FXX08241999-1: Pass in the full file extract name since it has to be the 210T1 for the assessor's report.}

        AssignFile(RPS995File, s995FileName);
        Rewrite(RPS995File);

        OpenTablesExclusive(TablesToBeOpen,
                            OpenInventoryTables,
                            InventoryProcessingType,
                            SalesTable,
                            PriorParcelTable, ThisYearParcelTable, NextYearParcelTable,
                            PriorAssessmentTable, ThisYearAssessmentTable, NextYearAssessmentTable,
                            PriorClassTable, ThisYearClassTable, NextYearClassTable,
                            ThisYearSDTable, NextYearSDTable,
                            ThisYearEXTable, NextYearEXTable,
                            ThisYearEXCodeTable, NextYearEXCodeTable,
                            ThisYearSDCodeTable, Quit);

          {Setup the progress dialog.}

        case FileType of
          ftParcelOnly :
              begin  {Parcel only.}
                ProgressDialog.UserLabelCaption := 'Creating parcel extract.';

                If ShowBothThisAndNextYear
                  then ProgressDialog.Start(GetRecordCount(ThisYearParcelTable) +
                                            GetRecordCount(NextYearParcelTable), True, True)
                  else ProgressDialog.Start(14000, True, True);

              end;  {Parcel only}

          ftSalesOnly :
              begin  {Sales only.}
                ProgressDialog.UserLabelCaption := 'Creating sales extract.';
                ProgressDialog.Start(GetRecordCount(SalesTable), True, True);
              end;

          ftParcelAndSales :
              begin  {Parcel and Sales}
                ProgressDialog.UserLabelCaption := 'Creating sales extract.';

                If ShowBothThisAndNextYear
                  then ProgressDialog.Start(GetRecordCount(ThisYearParcelTable) +
                                            GetRecordCount(NextYearParcelTable) +
                                            GetRecordCount(SalesTable), True, True)
                  else ProgressDialog.Start(GetRecordCount(ThisYearParcelTable) +
                                            GetRecordCount(SalesTable), True, True);

              end;  {Parcel and Sales}

        end;  {case FileType of}

          {First do the sales extract part if the they want either sales only or sales and
           parcel.}

        I := 0;

        If (FileType in [ftSalesOnly, ftParcelAndSales])
          then
            begin
              Done := False;
              FirstTimeThrough := True;
              ProgressDialog.UserLabelCaption := 'Extracting sales information.';

                {FXX06162003-1(2.07d): Make sure to cancel the range in case one was set
                                       from before.}

              SalesTable.CancelRange;
              SalesTable.First;

              WriteSalesSectionHeaderRecord(RPS995File,
                                            SwisCodeTable.FieldByName('SwisCode').Text);

              repeat
                Application.ProcessMessages;
                ProgressDialog.Update(Form,
                                      ConvertSwisSBLToDashDot(SalesTable.FieldByName('SwisSBLKey').Text));

                TempStr := ConvertSwisSBLToDashDot(SalesTable.FieldByName('SwisSBLKey').Text);

                If FirstTimeThrough
                  then FirstTimeThrough := False
                  else SalesTable.Next;

                If SalesTable.EOF
                  then Done := True;

                I := I + 1;
                SwisCode := Take(6, SalesTable.FieldByName('SwisSBLKey').Text);

                If ((I > 10) and
                    TrialRun)
                  then Done := True;

                  {Extract this sales record.}
                  {FXX04262000-2: Only get sales for the selected swis codes.}

                If ((not Done) and
                    (SelectedSwisCodes.IndexOf(SwisCode) > -1))
                  then
                    begin
                      NumSalesExtracted := NumSalesExtracted + 1;

                        {FXX09231999-1: Need to include the final roll date in
                                        the sales extract.}

                      ExtractInformationForOneSale(
                                         RPS995File, SalesTable,
                                         NextYearParcelTable,
                                         NextYearAssessmentTable,
                                         AssessmentYearCtlTable,
                                         SalesTable.FieldByName('SwisSBLKey').Text,
                                         '', False,
                                         TIntegerField(SalesTable.FieldByName('SaleNumber')).AsInteger,
                                         IncludeInventory,
                                         SuppressSalesPrice,
                                         False);

                    end;  {If not Done}

                ExtractCancelled := ProgressDialog.Cancelled;

              until (Done or Quit or ExtractCancelled);

            end;  {If (FileTypeRadioGroup.ItemIndex in [1, 2]) - that is, sales extract}

          {Next do the parcel portion of the 995 extract if they want either parcel or
           parcel and sales.}

        If ((not (Quit or ExtractCancelled)) and
            (FileType in [ftParcelOnly, ftParcelAndSales]))
          then
            begin
              Done := False;
              I := 0;
              ProgressDialog.UserLabelCaption := 'Processing parcel information.';
              WriteParcelSectionHeaderRecord(RPS995File,
                                             SwisCodeTable.FieldByName('SwisCode').Text);

                {Get the taxable status dates.}

              with AssessmentYearCtlTable do
                TYTaxableStatusDate := MakeMMDDYY(FieldByName('TaxableStatusDate').AsDateTime);

              AssessmentYearCtlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                               NextYear);

              with AssessmentYearCtlTable do
                NYTaxableStatusDate := MakeMMDDYY(FieldByName('TaxableStatusDate').AsDateTime);

               {If they want to extract both this year and next year,
                then we will use the next year inventory since it will
                be the most recent. If they want just this year
                information, we will use this year inventory.}

              If ShowBothThisAndNextYear
                then InventoryProcessingType := NextYear
                else InventoryProcessingType := ThisYear;

                {If we extracted sales information then
                 we will need to reopen the tables for the
                 parcel extract.}

              If (FileType = ftParcelAndSales)
                then OpenTablesExclusive('P',
                                         OpenInventoryTables,
                                         InventoryProcessingType,
                                         SalesTable,
                                         PriorParcelTable, ThisYearParcelTable, NextYearParcelTable,
                                         PriorAssessmentTable, ThisYearAssessmentTable, NextYearAssessmentTable,
                                         PriorClassTable, ThisYearClassTable, NextYearClassTable,
                                         ThisYearSDTable, NextYearSDTable,
                                         ThisYearEXTable, NextYearEXTable,
                                         ThisYearEXCodeTable, NextYearEXCodeTable,
                                         ThisYearSDCodeTable, Quit);

                {FXX12071998-4: Start at the first selected swis code.}

              FindNearestOld(ThisYearParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot',
                              'Sublot', 'Suffix'],
                             [GlblThisYear, SelectedSwisCodes[0],
                              '', '', '', '', '', '']);
              FindNearestOld(NextYearParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot',
                              'Sublot', 'Suffix'],
                             [GlblNextYear, SelectedSwisCodes[0],
                              '', '', '', '', '', '']);

                {Now actually loop through and extract the
                 parcels. Note that the looping through parcel
                 SBL's is done in ExtractInformationForOneParcel.}

              repeat
                Application.ProcessMessages;

                ExtractInformationForOneParcel(
                                    RPS995File, Form, s995FileName,
                                    SwisSBLKey, SalesTable,
                                    PriorParcelTable, ThisYearParcelTable, NextYearParcelTable,
                                    PriorAssessmentTable, ThisYearAssessmentTable, NextYearAssessmentTable,
                                    PriorClassTable, ThisYearClassTable, NextYearClassTable,
                                    ThisYearSDTable, NextYearSDTable,
                                    ThisYearEXTable, NextYearEXTable,
                                    ThisYearEXCodeTable, NextYearEXCodeTable,
                                    ThisYearSDCodeTable,
                                    SortAVChangesTable,
                                    TYTaxableStatusDate,
                                    NYTaxableStatusDate,
                                    ShowBothThisAndNextYear,
                                    bShowNextYearOnly,
                                    IncludeInventory,
                                    SetVillageExemptionFlagsToTrue,
                                    NumTYParcelsExtracted,
                                    NumNYParcelsExtracted,
                                    NumTYParcelsExtractedActual,
                                    SelectedSwisCodes,
                                    slSelectedRollSections, Done, Quit);

                I := I + 1;

                If ((I > 10) and
                    TrialRun)
                  then Done := True;

                ExtractCancelled := ProgressDialog.Cancelled;

              until (Done or ExtractCancelled or Quit)

            end;  {If ((not (Quit or ExtractCancelled)) and ...}

        ProgressDialog.Finish;
        CloseFile(RPS995File);

        If (ExtractCancelled or Quit)
          then MessageDlg('The full file extract was NOT successful.' + #13 +
                          'Please do not transmit this file.', mtError, [mbOK], 0)
          else
            begin
              MessageDlg('The full file extract was successfully completed and is located in ' +
                         'the directory ' + GlblExportDir + '.' + #13 + #13 +
                         'Number of sales extracted = ' + IntToStr(NumSalesExtracted) + #13 +
                         'Number of this year parcels extracted = ' + IntToStr(NumTYParcelsExtractedActual) + #13 +
                         'Number of next year parcels extracted = ' + IntToStr(NumNYParcelsExtracted),
                         mtInformation, [mbOK], 0);

                {CHG05131999-3: See if they want to copy\zip the file.}
                {CHG08301999-1: Change zip\copy to allow selections from other dirs.}

              If (MessageDlg('Do you want to copy\zip the files to another drive or disk?',
                              mtConfirmation, [mbYes, mbNo], 0) = idYes)
                then
                  with ZipCopyDlg do
                    begin
                      InitialDrive := GlblDrive;
                      InitialDir := GlblExportDir;
                      SelectFile(s995FileName);
                      SelectFile(s060FileName);
                      Execute;

                    end;  {with ZipCopyDlg do}

            end;  {else of If (ExtractCancelled or Quit)}

      end;  {If (ReturnCode = idOK)}

end;  {Generate9995File}

{===================================================================}
Procedure TRPS995FileExtractForm.StartButtonClick(Sender: TObject);

var
  I, FileType : Integer;
  SelectedSwisCodes, SelectedFiles : TStringList;
  SuppressSalesPrice,
  ShowBothThisAndNextYear, IncludeInventory,
  SetVillageExemptionFlagsToTrue, bShowNextYearOnly : Boolean;
  ExtractDir, RPS995FileName, RPS060FileName,
  MailSubject, ZipFileName : String;

begin
  ShowBothThisAndNextYear := (YearRadioGroup.ItemIndex = 2);
  bShowNextYearOnly := _Compare(YearRadioGroup.ItemIndex, 1, coEqual);
  SelectedSwisCodes := TStringList.Create;
  slSelectedRollSections := TStringList.Create;

    {FXX12071998-2: Only extract the selected swis codes.}

  with SwisCodeListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then SelectedSwisCodes.Add(Items[I]);

  FillSelectedItemList(RollSectionListBox, slSelectedRollSections, 1);

  FileType := FileTypeRadioGroup.ItemIndex;

  SuppressSalesPrice := SuppressSalesPriceCheckBox.Checked;

  IncludeInventory := IncludeInventoryCheckBox.Checked;

  SetVillageExemptionFlagsToTrue := SetVillageExemptionFlagsToTrueCheckBox.Checked;

  dlgSave060.InitialDir := GlblDrive + ':' + GlblExportDir;
  dlgSave995.InitialDir := GlblDrive + ':' + GlblExportDir;

  If (dlgSave060.Execute and
      dlgSave995.Execute)
    then Generate995File(Self, SelectedSwisCodes, slSelectedRollSections,
                         dlgSave060.FileName,
                         dlgSave995.FileName,
                         FileType, True,
                         ShowBothThisAndNextYear, bShowNextYearOnly,
                         IncludeInventory,
                         SuppressSalesPrice, True,
                         SetVillageExemptionFlagsToTrue,
                         ProgressDialog, ZipCopyDlg);

    {CHG02272003-1(2.06p6): Add email attachment capabilities.}

  If (MessageDlg('Do you want to email this file?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        ExtractDir := GlblDrive + ':' + GlblExportDir;
        RPS995FileName := ExtractDir + 'RPS995T1';
        RPS060FileName := ExtractDir + 'RPS060I1';
        SelectedFiles := TStringList.Create;
        SelectedFiles.Add(RPS995FileName);
        SelectedFiles.Add(RPS060FileName);

        ZipFileName := Trim(GlblMunicipalityName) +
                       '_FullFile995_' +
                       MakeMMDDYYYYDate(Date) +
                       '.zip';
        ZipFileName := StringReplace(ZipFileName, ' ', '_', [rfReplaceAll]);

        MailSubject := Trim(GlblMunicipalityName) + ' full file extract ' + DateToStr(Date);

        EMailFile(Self, ExtractDir, ExtractDir, ZipFileName, emlORPSExtract, '',
                  MailSubject, '', SelectedFiles, True);
        SelectedFiles.Free;

      end;  {If (MessageDlg('Do you want to email this file?' + #13 +}

  SelectedSwisCodes.Free;
  slSelectedRollSections.Free;

end;  {StartButtonClick}

{===================================================================}
Procedure TRPS995FileExtractForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TRPS995FileExtractForm.FormClose(    Sender: TObject;
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