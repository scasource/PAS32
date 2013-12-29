
unit Dataconv;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DB, DBTables, Wwtable, Wwdatsrc,BtrvDlg,
  Buttons, Types, ExtCtrls, PasTypes, BDE;

type
  TDataConvertForm = class(TForm)
    CloseButton: TBitBtn;
    ExemptionCodeLabel: TLabel;
    SDCodeLabel: TLabel;
    SwisCodeLabel: TLabel;
    ParcelRecordLabel: TLabel;
    ParcelSDRecordLabel: TLabel;
    ParcelEXRecordLabel: TLabel;
    ParcelsButton: TButton;
    ResSitesRecordCountLabel : TLabel;
    SalesButton: TButton;
    SalesCtLabel: TLabel;
    CommSitesRecordCountLabel: TLabel;
    SalesResSitesRecordCountLabel: TLabel;
    SalesCommSitesRecordCountLabel: TLabel;
    CodeTable: TTable;
    CancelButton: TBitBtn;
    GroupBox1: TGroupBox;
    StartTimeLabel: TLabel;
    EndTimeLabel: TLabel;
    TotRecLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    TYParcelCountLabel: TLabel;
    NYParcelCountLabel: TLabel;
    TYParcelSDCountLabel: TLabel;
    NYParcelSDCountLabel: TLabel;
    TYParcelEXCountLabel: TLabel;
    NYParcelEXCountLabel: TLabel;
    TYSwisCodeCountLabel: TLabel;
    NYSwisCodeCountLabel: TLabel;
    TYEXCodeCountLabel: TLabel;
    NYEXCodeCountLabel: TLabel;
    TYSDCodeCountLabel: TLabel;
    NYSDCodeCountLabel: TLabel;
    TYSchoolCodeCountLabel: TLabel;
    NYSchoolCodeCountLabel: TLabel;
    TYResSitesCountLabel: TLabel;
    NYResSitesCountLabel: TLabel;
    TYComSitesCountLabel: TLabel;
    NYComSitesCountLabel: TLabel;
    SalesRecCountLabel: TLabel;
    SalesResSiteCountLabel: TLabel;
    SalesComSiteCountLabel: TLabel;
    Label4: TLabel;
    AllButton: TBitBtn;
    Label5: TLabel;
    TYClassCountLabel: TLabel;
    NYClassCountLabel: TLabel;
    ExemptionsOnlyButton: TButton;
    Label6: TLabel;
    TYUserDataLabel: TLabel;
    NYUserDataLabel: TLabel;
    AssessmentYearControlTable: TTable;
    LocationOfFilesEdit: TEdit;
    Label7: TLabel;
    Open995Dialog: TOpenDialog;
    Open060Dialog: TOpenDialog;
    SysRecTable: TTable;
    GroupBox2: TGroupBox;
    ConvertInventoryCheckBox: TCheckBox;
    ConvertSalesCheckBox: TCheckBox;
    CreateNYCheckBox: TCheckBox;
    CreateCodeCheckBox: TCheckBox;
    RecalculateExemptionsCheckBox: TCheckBox;
    LoadCodesCheckBox: TCheckBox;
    ExtractSalesToFileCheckBox: TCheckBox;
    AllDataToCSVCheckBox: TCheckBox;
    FileNameLabel: TLabel;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label8: TLabel;
    EditThisYear: TEdit;
    EditNextYear: TEdit;
    AS400CheckBox: TCheckBox;
    TotalAssessmentLabel: TLabel;
    ConvertExemptionsOnlyCheckBox: TCheckBox;
    ParcelLookupTable: TTable;

    procedure ParcelFileClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SDExButtonClick(Sender: TObject);
    procedure ParcelsButtonClick(Sender: TObject);
    procedure InventoryButtonClick(Sender: TObject);
    procedure SalesButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure AllButtonClick(Sender: TObject);
    procedure UserDataButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ConversionCancelled, RecalculateExemptions : Boolean;
    LoadingFromAS400File : Boolean;
    LocationOfFiles : String;

    Procedure InsertParcelRecord(    ParcelTable : TTable;
                                     TaxRollYear : String;
                                     ReadBuff : RPSImportRec;
                                     ProcessingType : Integer;
                                     PropClassList,
                                     HomesteadCodeList,
                                     OwnershipCodeList,
                                     EasementCodeList,
                                     LandCommitmentCodeList : TList;
                                     RecordNo : LongInt;
                                     SwisCodeTable : TTable;
                                     SchoolCodeTable : TTable;
                                     CreateCodes : Boolean;
                                 var SwisSBLKey : String;
                                 var StateScan,
                                     ErrorLog : Text);

     Procedure InsertAssessmentRecord(    AssessmentTable : TTable;
                                          TaxRollYear : String;
                                          ReadBuff : RPSImportRec;
                                          ProcessingType : Integer;
                                          SwisSBLKey : String;
                                          OrigCurrYrValCodeList,
                                          RevisedCurrYrValCodeList : TList;
                                      var ThisParcelAssessment : LongInt;
                                          RecordNo : LongInt;
                                      var ErrorLog : Text);
     {Insert one assessment record.}

    Procedure AddSalesRecord(    SalesRecTable : TTable;
                                 ReadBuff : RPSImportRec;
                                 RecordCount : Integer;
                                 SlsDeedTypeCodeList,
                                 SlsStatusCodeList,
                                 SlsVerifyCodeList,
                                 SlsSalesTypeCodeList,
                                 SlsArmsLengthCodeList,
                                 SlsValidityCodeList : TList;
                             var ErrorLog : Text);

    Procedure InsertExemptionRecords(    ParcelEXTable : TTable;
                                         TaxRollYr : String;
                                         ProcessingType : Integer;
                                         ReadBuff : RPSImportRec;
                                         RecordCount : LongInt;
                                     var ThisYearParcelEXCount,
                                         NextYearParcelEXCount : LongInt;
                                         EXCodeTable : TTable;
                                         CreateCodes : Boolean;
                                     var ErrorLog : TextFile);
     {Insert all the exemptions in one 995 EX record.}

    Procedure InsertSpecialDistrictRecords(    ParcelSDTable : TTable;
                                               TaxRollYr : String;
                                               ProcessingType : Integer;
                                               ReadBuff : RPSImportRec;
                                               RecordCount : LongInt;
                                           var ThisYearParcelSDCount,
                                               NextYearParcelSDCount : LongInt;
                                               SDCodeTable : TTable;
                                               CreateCodes : Boolean;
                                           var ErrorLog : TextFile);
    {Insert all the special districts in one 995 SD record.}

    Procedure InsertClassRecord(    ClassTable :  TTable;
                                    TaxRollYr : String;
                                    ProcessingType : Integer;
                                    ReadBuff : RPSImportRec;
                                    RecordCount : LongInt;
                                var ThisYearClassCount,
                                    NextYearClassCount : LongInt;
                                var ErrorLog : TextFile);

    {Insert one class record.}

  end;  {TDataConvertForm = class(TForm)}

var
  DataConvertForm : TDataConvertForm;

implementation


Uses Utilitys,WinUtils,GlblVars,PASUTILS, UTILEXSD,  GlblCnst,
     DCONVUTL, DataModule, Prclocat, Prog, RTCalcul;  {Data conversion specific utilitys such as inventory conversion and
                 field extraction.}

{$R *.DFM}

type
  UserDefinitionsRecord = record
    Description : String;
    FieldName : String;
    RecType,  {'P'arcel, 'R'esidential, 'C'ommercial}
    FieldType : Char;  {'I'nteger, 'L'ogical, 'S'tring, 'F'loat}
    StartPos : Integer;
    FieldLength : Integer;
    ResidentialField : Boolean;
  end;  {UserDefinitionsRecord = record}

  PUserDefinitionsRecord = ^UserDefinitionsRecord;

  ResSiteRecord = record
    PhysicalChangeCode : String;
    PhysicalChangeDesc : String;
    TrafficCode : String;
    TrafficDesc : String;
    ElevationCode : String;
    ElevationDesc : String;
  end;

  ResBldgRecord = record
    KitchenQualCode : String;
    KitchenQualDesc : String;
    BathQualityCode : String;
    BathQualityDesc : String;
    NumRooms : Integer;
  end;

  UserDataRecord = record
    StringFields : Array[1..10] of String;
    IntegerFields : Array[1..10] of Integer;
    LogicalFields : Array[1..10] of Boolean;
    FloatFields : Array[1..10] of Double;
  end;  {UserDataRecord = record}

const
  MaxNumSDPerLine = 25;
  StartSDCodePos = 40;
  MaxNumEXPerLine = 27;
  StartEXCodePos = 40;
  TrialRun = False;
var
  ErrorLog : Text;
  E : TObject;
  ProcessingType : Integer;  {History, ThisYear, NextYear}
  QualityTypeList,
  TrafficTypeList,
  ElevationList,
  PhysicalChangeList : TList;

{=================================================================}
Procedure TDataConvertForm.FormCreate(Sender: TObject);

begin
  SysRecTable.Open;
  SetGlobalSystemVariables(SysRecTable);

    {Initialize the global error dialog box.}

  GlblErrorDlgBox := TSCAErrorDialogBox.Create(Self);
  GlblErrorDlgBox.ShowSCAPhoneNumbers := True;
  GlblErrorDlgBox.ErrorFileDirectory := GlblDrive + ':' + GlblErrorFileDir;

  SysRecTable.Close;

end;  {FormCreate}

{=================================================================}
Procedure WriteInformationToExtractFile(var ExtractFile : TextFile;
                                            Table : TTable);

var
  TempStr : String;
  I : Integer;

begin
  with Table do
    For I := 0 to (FieldCount - 1) do
      begin
        TempStr := FormatExtractField(FieldByName(Fields[I].FieldName).Text);

        If (I = 0)
          then System.Delete(TempStr, 1, 1);

        Write(ExtractFile, TempStr);

      end;  {For I := 0 to (FieldCount - 1) do}

  Writeln(ExtractFile);

end;  {WriteInformationToExtractFile}

{=================================================================}
Procedure TDataConvertForm.InsertParcelRecord(    ParcelTable : TTable;
                                                  TaxRollYear : String;
                                                  ReadBuff : RPSImportRec;
                                                  ProcessingType : Integer;
                                                  PropClassList,
                                                  HomesteadCodeList,
                                                  OwnershipCodeList,
                                                  EasementCodeList,
                                                  LandCommitmentCodeList : TList;
                                                  RecordNo : LongInt;
                                                  SwisCodeTable : TTable;
                                                  SchoolCodeTable : TTable;
                                                  CreateCodes : Boolean;
                                              var SwisSBLKey : String;
                                              var StateScan,
                                                  ErrorLog : Text);

{Convert one parcel record and insert it into the parcel file.}
{8\14\97 - If this is PAS TY, we will fill in the prior
           value fields from the prior value fields in RPS.
           This is in lieu of creating a history year. Whenever we need these
           prior values (such as the assessor's report), we will look to see if
           there is a history year. If there is not, we will use these prior
           values.}

var
  TempCity : String;
  SwisCode, SchoolCode,
  PartialAssessmentText, TempStr : String;
  TempNum : Integer;
  StreetSide : String;
  PartialAssessment, FilledIn : Boolean;

begin
  with ParcelTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYear);
      FieldByName('SwisCode').Text := GetField(6,1,6,ReadBuff);
      SwisCode := FieldByName('SwisCode').Text;
      FieldByName('Section').Text := Take(3, GetField(3,7,9,ReadBuff));
      FieldByName('Subsection').Text:= Take(3, GetField(3,10,12,ReadBuff));
      FieldByName('Block').Text := Take(4, GetField(4,13,16,ReadBuff));
      FieldByName('Lot').Text := Take(3, GetField(3,17,19,ReadBuff));
      FieldByName('Sublot').Text := Take(3, GetField(3,20,22,ReadBuff));
      FieldByName('Suffix').Text := Take(4, GetField(4,23,26,ReadBuff));
      FieldByName('SwisSBLKey').Text := GetField(26, 1, 26, ReadBuff);

(*      If FindKeyOld(ParcelLookupTable, ['SwisSBLKey'], [FieldByName('SwisSBLKey').Text])
        then
          begin
            FieldByName('Section').Text := '8' + Take(2, GetField(2,8,9,ReadBuff));
            FieldByName('SwisSBLKey').Text := GetField(6, 1, 6, ReadBuff) + '8' + GetField(19, 8, 26, ReadBuff);
          end; *)

      SwisSBLKey := FieldByName('SwisSBLKey').Text;

      FieldByName('ActiveFlag').Text := GetField(1,740,740,ReadBuff);

      FieldByName('CheckDigit').Text := GetField(2,35,36,ReadBuff);

      FieldByName('SchoolCode').Text := GetField(6,149,154,ReadBuff);
      SchoolCode := FieldByName('SchoolCode').Text;
      If (ProcessingType = ThisYear)
        then FieldByName('PriorSchoolDistrict').Text := GetField(6,143,148,ReadBuff);

      FieldByName('ConsolidatedSchlDist').Text := GetField(6,155,160,ReadBuff);
      FieldByName('DescriptionPrintCode').Text := GetField(1,161,161,ReadBuff);

        {The lot has an irregular shape if the dimensions code
         is 'I'.}

      TempStr := GetField(1,237,237,ReadBuff);
      If (TempStr = 'I')
        then FieldByName('IrregularShape').AsBoolean := True;

      TempStr := GetField(25,40,64,ReadBuff);

      If (Trim(TempStr) <> 'NONE')
        then FieldByName('RemapOldSBL').Text := TempStr;

      FieldByName('Name1').Text := GetField(25,277,301,ReadBuff);
      FieldByName('Name2').Text := Trim(GetField(25,302,326,ReadBuff));
      FieldByName('Address1').Text := Trim(GetField(25,327,351,ReadBuff));
      FieldByName('Address2').Text := Trim(GetField(25,352,376,ReadBuff));

      FieldByName('Street').Text := Trim(GetField(25,377,401,ReadBuff));
      FieldByName('City').Text := Trim(GetField(25,402,426,ReadBuff));

        {parse state abbrev out of RPS field into PAS-dedicated}
        {state field}

      TempCity := Take(25,FieldByName('City').Text);
      FieldByName('State').AsString := Take(2, MoveStateToStateField(TempCity));
      FieldByName('City').Text := Take(25,TempCity);

        {If state field is blank, write it to an error log.}

      If (Deblank(FieldByName('State').Text) = '')
        then Writeln(StateScan, FieldByName('State').Text,'   ',
                                FieldByName('City').Text,'     ',
                                FieldByName('Section').Text,'-',
                                FieldByName('SubSection').Text,'-',
                                FieldByName('Block').Text,'-',
                                FieldByName('Lot').Text,'-',
                                FieldByName('Sublot').Text,'-',
                                FieldByName('Suffix').Text,
                                '  Record = ', IntToStr(RecordNo));

      FieldByName('Zip').Text := Trim(GetField(5,427,431,ReadBuff));
      FieldByName('ZipPlus4').Text := Trim(GetField(4,432,435,ReadBuff));

      FieldByName('PropDescr1').Text := Trim(GetField(25,162,186,ReadBuff));
      FieldByName('PropDescr2').Text := Trim(GetField(25,187,211,ReadBuff));
      FieldByName('PropDescr3').Text := Trim(GetField(25,212,236,ReadBuff));

      If (ProcessingType = ThisYear)
        then FieldByName('PriorPropertyClass').Text := Trim(GetField(3,265,267,ReadBuff));
      FieldByName('PropertyClassCode').Text := Trim(GetField(3,268,270,ReadBuff));

      FieldByName('PropertyClassDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('PropertyClassCode').Text,
                                        PropClassList,
                                        ErrorLog);

      If (ProcessingType = ThisYear)
        then FieldByName('PriorHomesteadCode').Text := Trim(GetField(1,271,271,ReadBuff));
      FieldByName('HomeSteadCode').Text := Trim(GetField(1,272,272,ReadBuff));

      FieldByName('HomesteadDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('HomesteadCode').Text,
                                        HomesteadCodeList,
                                        ErrorLog);

      If (ProcessingType = ThisYear)
        then FieldByName('PriorOwnershipCode').Text := GetField(1,263,263,ReadBuff);
      FieldByName('OwnershipCode').Text := GetField(1,264,264,ReadBuff);

      FieldByName('OwnershipDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('OwnershipCode').Text,
                                        OwnershipCodeList,
                                        ErrorLog);

      FieldByName('EasementCode').Text := GetField(1,476,476,ReadBuff);
      FieldByName('EasementDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('EasementCode').Text,
                                        EasementCodeList,
                                        ErrorLog);

      FieldByName('LandCommitmentCode').Text := GetField(1,477,477,ReadBuff);
      FieldByName('LandCommitmentDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('LandCommitmentCode').Text,
                                        LandCommitmentCodeList,
                                        ErrorLog);

         {Commitment termination year (YY). If it is less than 90,
          we will assume it is the 21st century. Otherwise, assume 20th century.}

      TempStr := Take(2, GetField(2,478,479,ReadBuff));

      If (Deblank(TempStr) <> '')
        then
          begin
            try
              TempNum := StrToInt(TempStr);
            except
              TempNum := 0;
            end;

            If (TempNum < 90)
              then FieldByName('CommitmentTermYear').Text := '20' + ShiftRightAddZeroes(TempStr)
              else FieldByName('CommitmentTermYear').Text := '19' + ShiftRightAddZeroes(TempStr);

          end;  {If (Deblank(TempStr) <> '')}

      TempStr := GetField(4,726,729,ReadBuff);

      try
        FieldByName('AllocationFactor').AsFloat := StrToFloat(TempStr) / 10000;  {Four decimal places.}
      except
        FieldByName('AllocationFactor').AsFloat := 0;
      end;

      TempStr := Take(10, LTrim(GetField(10,133,142,ReadBuff)));
      FieldByName('LegalAddrNo').Text := TempStr;

      FieldByName('LegalAddr').Text := GetField(25,108,132,ReadBuff);

      FieldByName('LegalAddrInt').AsInteger := GetLegalAddressInt(FieldByName('LegalAddrNo').Text);

      try
        FieldByName('LastChangeDate').Text := MakeYYYYMMDDSlashed(ConvYYDate(772,777,ReadBuff))
      except
      end;

      FieldByName('LastChangeByName').Text := Take(10,' ');

      TempStr := GetField(6,760,765,ReadBuff);
         {FXX10041997-1 ..stop error exit and skip of parcel post when get }
         {invalid date, left roll totals short}
      If TempStr <> '000000'
         then FieldByName('ParcelCreatedDate').Text := MakeYYYYMMDDSlashed(ConvYYDate(760,765,ReadBuff))
         else FieldByName('ParcelCreatedDate').Text := '01/01/1998';
      TempStr := GetField(8, 730, 737, ReadBuff);

      If (TempStr <> '00000000')
        then FieldByName('SplitMergeNo').Text := TempStr;

      If (ProcessingType = ThisYear)
        then FieldByName('PriorRollSection').Text := Trim(GetField(1,447,447,ReadBuff));
      FieldByName('RollSection').Text := Trim(GetField(1,448,448,ReadBuff));

      FieldByName('RollSubsection').Text := Trim(GetField(1,449,449,ReadBuff));
      FieldByName('BankCode').Text := Trim(GetField(7,450,456,ReadBuff));
      FieldByName('DeedBook').Text := Trim(GetField(5,466,470,ReadBuff));
      FieldByName('DeedPage').Text := Trim(GetField(5,471,475,ReadBuff));
      FieldByName('Frontage').Text := Trim(ConvNumTo2Dec(7,238,244,ReadBuff));
      FieldByName('Depth').Text := ConvNumTo2Dec(7,245,251,ReadBuff);
      FieldByName('Acreage').Text := ConvNumTo2Dec(7,252,258,ReadBuff);

        {FXX10121997-4: Grid coord east and north were mixed up.}

      FieldByName('GridCordEast').Text := Getfield(7,90,96,ReadBuff);
      FieldByName('GridCordNorth').Text := Getfield(7,97,103,ReadBuff);
      FieldByName('AccountNo').Text := Trim(GetField(11,436,446,ReadBuff));

      try
        If (ProcessingType = ThisYear)
          then FieldByName('PriorResPercent').AsFloat := StrToFloat(GetField(2,259,260,ReadBuff));

        FieldByName('ResidentialPercent').AsFloat := StrToFloat(GetField(2,261,262,ReadBuff));
      except
        FieldByName('ResidentialPercent').AsFloat := 0;
      end;

      FieldByName('HoldPriorHomestead').Text := Getfield(1,783,783,ReadBuff);

        {FXX01071998-9: The relevy amounts are 100x too high.}

      try
        FieldByName('SchoolRelevy').Text := Getfield(9,742,750,ReadBuff);
        FieldByName('SchoolRelevy').AsFloat := FieldByName('SchoolRelevy').AsFloat / 100;
      except
        FieldByName('SchoolRelevy').AsFloat := 0;
      end;

      try
        FieldByName('VillageRelevy').Text := Getfield(9,751,759,ReadBuff);
        FieldByName('VillageRelevy').AsFloat := FieldByName('VillageRelevy').AsFloat / 100;
      except
        FieldByName('VillageRelevy').AsFloat := 0;
      end;

      FieldByName('MortgageNumber').Text := Getfield(9,457,465,ReadBuff);
      FieldByName('AssociatedSaleNumber').Text := Getfield(2,818,819,ReadBuff);

        {Specific to Malta - get the street side and partial assessment data from the RPS user
                             data.}

(*      If SetMaltaFields.Checked
        then
          begin
            StreetSide := GetField(1, 784, 784, ReadBuff);

            PartialAssessment := (GetField(3, 792, 794, ReadBuff) = '299');
            If PartialAssessment
              then
                begin
                  If (Deblank(StreetSide) = '')
                    then PartialAssessmentText := 'Partial Assessment'
                    else PartialAssessmentText := '; Partial Assessment';
                end
              else PartialAssessmentText := '';

            FilledIn := False;

            If (PartialAssessment or
                (Deblank(StreetSide) <> ''))
              then
                begin
                  If (Deblank(FieldByName('PropDescr1').Text) = '')
                    then
                      begin
                        FieldByName('PropDescr1').Text := 'Side: ' + StreetSide + PartialAssessmentText;
                        FilledIn := True;
                      end;

                  If ((not FilledIn) and
                      (Deblank(FieldByName('PropDescr2').Text) = ''))
                    then
                      begin
                        FieldByName('PropDescr2').Text := 'Side: ' + StreetSide + PartialAssessmentText;
                        FilledIn := True;
                      end;

                  If ((not FilledIn) and
                      (Deblank(FieldByName('PropDescr3').Text) = ''))
                    then
                      begin
                        FieldByName('PropDescr3').Text := 'Side: ' + StreetSide + PartialAssessmentText;
                        FilledIn := True;
                      end;

                  If not FilledIn
                    then Writeln(MaltaFieldsFile, ExtractSSKey(ParcelTable),
                                                  ' Side: ' + StreetSide + PartialAssessmentText);

                end;

          end;  {If SetMaltaFields.Checked} *)

      try
        If ExtractAllData
          then
            begin
              WriteInformationToExtractFile(ParcelExtractFile, ParcelTable);
              Cancel;
            end
          else Post;
      except
        Cancel;
        SystemSupport(001, ParcelTable, 'Error Attempting to Post Parcel Table',
                           UnitName, GlblErrorDlgBox);
      end;

    except
      E := ExceptObject;
      Writeln(ErrorLog, 'Error in parcel record ' + IntToStr(RecordNo),
                        '  Exception: ', Exception(E).Message);
    end;

    If (CreateCodes and
        (SwisCode <> '') and
        (not FindKeyOld(SwisCodeTable, ['SwisCode'], [SwisCode])))
      then
        with SwisCodeTable do
          try
            Insert;
            FieldByName('SwisCode').Text := SwisCode;
            FieldByName('TaxRollYr').Text := TaxRollYear;
            Post;
          except
            Cancel;
          end;

    If (CreateCodes and
        (SchoolCode <> '') and
        (not FindKeyOld(SchoolCodeTable, ['SchoolCode'], [SchoolCode])))
      then
        with SchoolCodeTable do
          try
            Insert;
            FieldByName('SchoolCode').Text := SchoolCode;
            FieldByName('TaxRollYr').Text := TaxRollYear;
            Post;
          except
            Cancel;
          end;

end;  {InsertParcelRecord}

{=================================================================}
Procedure TDataConvertForm.InsertAssessmentRecord(    AssessmentTable : TTable;
                                                      TaxRollYear : String;
                                                      ReadBuff : RPSImportRec;
                                                      ProcessingType : Integer;
                                                      SwisSBLKey : String;
                                                      OrigCurrYrValCodeList,
                                                      RevisedCurrYrValCodeList : TList;
                                                  var ThisParcelAssessment : LongInt;
                                                      RecordNo : LongInt;
                                                  var ErrorLog : Text);

{Insert one assessment record.}
{8\14\97 - The correct way to load the RPS data is the assessed value (land
           and total) is gotten from the RPS current values whether this is
           (PAS) TY or NY. If this is PAS TY, we will fill in the prior
           assessed value fields from the prior assessed value fields in RPS.
           This is in lieu of creating a history year. Whenever we need these
           prior values (such as the assessor's report), we will look to see if
           there is a history year. If there is not, we will use these prior
           values.}

var
  TempStr : String;

begin
  with AssessmentTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYear);
      FieldByName('SwisSBLKey').Text := SwisSBLKey;

      try
        FieldByName('LandAssessedVal').AsFloat := StrToFloat(GetField(12,531,542,ReadBuff));

        If (ProcessingType = ThisYear)
          then FieldByName('PriorLandValue').AsFloat := StrToFloat(GetField(12,507,518,ReadBuff));

      except
        FieldByName('LandAssessedVal').AsFloat := 0;
        FieldByName('PriorLandValue').AsFloat := 0;

        E := ExceptObject;
        Writeln(ErrorLog, 'Error in assessment record - no land assessed val: ' + IntToStr(RecordNo),
                          '  Exception: ', Exception(E).Message);
      end;

      try
        FieldByName('TotalAssessedVal').AsFloat := StrToFloat(GetField(12,543,554,ReadBuff));
        ThisParcelAssessment := FieldByName('TotalAssessedVal').AsInteger;

        If (ProcessingType = ThisYear)
          then FieldByName('PriorTotalValue').AsFloat := StrToFloat(GetField(12,519,530,ReadBuff));

      except
        FieldByName('TotalAssessedVal').AsFloat := 0;
        FieldByName('PriorTotalValue').AsFloat := 0;

        E := ExceptObject;
        Writeln(ErrorLog, 'Error in assessment record - no total assessed val: ' + IntToStr(RecordNo),
                          '  Exception: ', Exception(E).Message);
      end;

        {The increase and decrease fields are for the year that we are working on -
         i.e. if this is a NY record, then these are NY assessment inc\dec.
         Similarly for TY. Note that if there is not an NY record in RPS, then
         we will set these fields to 0 when we copy them forward, because the
         changes would be for the TY assessment change.}

      try
        FieldByName('IncreaseForEqual').AsFloat := StrToFloat(GetField(12,555,566,ReadBuff));
      except
        FieldByName('IncreaseForEqual').AsFloat := 0;
      end;

      try
        FieldByName('DecreaseForEqual').AsFloat := StrToFloat(GetField(12,567,578,ReadBuff));
      except
        FieldByName('DecreaseForEqual').AsFloat := 0;
      end;

      try
        FieldByName('PhysicalQtyIncrease').AsFloat := StrToFloat(GetField(12,579,590,ReadBuff));
      except
        FieldByName('PhysicalQtyIncrease').AsFloat := 0;
      end;

      try
        FieldByName('PhysicalQtyDecrease').AsFloat := StrToFloat(GetField(12,591,602,ReadBuff));
      except
        FieldByName('PhysicalQtyDecrease').AsFloat := 0;
      end;

      try
        FieldByName('RevalLandVal').AsFloat := StrToFloat(GetField(12,603,614,ReadBuff));
      except
        FieldByName('RevalLandVal').AsFloat := 0;
      end;

      try
        FieldByName('RevalTotalVal').AsFloat := StrToFloat(GetField(12,615,626,ReadBuff));
      except
        FieldByName('RevalTotalVal').AsFloat := 0;
      end;

      try
        FieldByName('ImpactTotalVal').AsFloat := StrToFloat(GetField(12,627,638,ReadBuff));
      except
        FieldByName('ImpactTotalVal').AsFloat := 0;
      end;

        {Initialize TY and NY assessment dates based on tax roll year.}

(*      If (ProcessingType = NextYear)
        then FieldByName('AssessmentDate').AsDateTime := StrToDate('1/1/' + TaxRollYear)
        else FieldByName('AssessmentDate').AsDateTime := StrToDate('1/1/' + TaxRollYear); *)

      FieldByName('OrigCurrYrValCode').Text := GetField(1,477,477,ReadBuff);
      FieldByName('OrigCurrYrValDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('OrigCurrYrValCode').Text,
                                        OrigCurrYrValCodeList,
                                        ErrorLog);

      FieldByName('RevisedCurrYrValCode').Text := GetField(1,477,477,ReadBuff);
      FieldByName('RevisedCurrYrValDesc').Text := SetDescription(
                                        RecordNo,
                                        FieldByName('RevisedCurrYrValCode').Text,
                                        RevisedCurrYrValCodeList,
                                        ErrorLog);

        {If there is a character in the building permit field, put out
         a line in the error log so they can investigate.}

      FieldByName('BuildingPermits').Text := GetField(1,482,482,ReadBuff);
      If (Deblank(FieldByName('BuildingPermits').Text) <> '')
        then Writeln(ErrorLog, 'Parcel ' + FieldByName('SwisSBLKey').Text +
                               ' has a building permit.');

      try
        If ExtractAllData
          then
            begin
              WriteInformationToExtractFile(AssessmentExtractFile, AssessmentTable);
              Cancel;
            end
          else Post;
      except
        SystemSupport(002, AssessmentTable, 'Error Attempting to Post Assessmt. Table',
                      UnitName, GlblErrorDlgBox);
      end;

    except
      E := ExceptObject;
      TempStr := Exception(E).Message;
      Writeln(ErrorLog, 'Error in assessment record ' + IntToStr(RecordNo),
                        '  Exception: ', Exception(E).Message);
    end;

end;  {InsertAssessmentRecord}

{=================================================================}
Procedure TDataConvertForm.InsertExemptionRecords(    ParcelEXTable : TTable;
                                                      TaxRollYr : String;
                                                      ProcessingType : Integer;
                                                      ReadBuff : RPSImportRec;
                                                      RecordCount : LongInt;
                                                  var ThisYearParcelEXCount,
                                                      NextYearParcelEXCount : LongInt;
                                                      EXCodeTable : TTable;
                                                      CreateCodes : Boolean;
                                                  var ErrorLog : TextFile);

{Insert all the exemptions in one 995 EX record.}

var
  Index, Offset, ReturnCode, YearInt : Integer;
  TempStr, ExemptionCode : String;
  TempNum : Real;
  Year, Century : String;

begin
  Offset := StartEXCodePos;

    {Now go through all of the exemptions in this exemption record.
     If the exemption code is all zeroes, then skip this one.
     If it is not, process the information.}

  For Index := 1 to MaxNumEXPerLine do
    begin
      ExemptionCode := '';

      If ((GetField(5, Offset, (Offset + 4), ReadBuff) <> '00000') and
          (Deblank(GetField(5, Offset, (Offset + 4), ReadBuff)) <> ''))
        then
          with ParcelEXTable do
            try
              If (ProcessingType = ThisYear)
                then
                  begin
                    ThisYearParcelEXCount := ThisYearParcelEXCount + 1;
                    TYParcelEXCountLabel.Caption := IntToStr(ThisYearParcelEXCount);
                  end
                else
                  begin
                    NextYearParcelEXCount := NextYearParcelEXCount + 1;
                    NYParcelEXCountLabel.Caption := IntToStr(NextYearParcelEXCount);
                  end;

              Insert;

              FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
              FieldByName('SwisSBLKey').Text := GetField(26,1,26,ReadBuff);
              FieldByName('ExemptionCode').Text := GetField(5, Offset, (Offset + 4), ReadBuff);
              ExemptionCode := FieldByName('ExemptionCode').Text;

              try
                FieldByName('TownAmount').AsFloat := StrToFloat(GetField(12, (Offset + 5), (Offset + 16), ReadBuff));
              except
                FieldByName('TownAmount').AsFloat := 0;
                E := ExceptObject;
                Writeln(ErrorLog, 'Error in exemption record - no amount: ' + IntToStr(RecordCount),
                                  '  Exception: ', Exception(E).Message);
              end;

                {FXX08051998-2: Be sure to fill in amount field for exemptions that have
                                no town amount.}

              try
                FieldByName('Amount').AsFloat := StrToFloat(GetField(12, (Offset + 5), (Offset + 16), ReadBuff));
              except
                FieldByName('Amount').AsFloat := 0;
                E := ExceptObject;
                Writeln(ErrorLog, 'Error in exemption record - no amount: ' + IntToStr(RecordCount),
                                  '  Exception: ', Exception(E).Message);
              end;

              try
                FieldByName('Percent').AsFloat := StrToFloat(GetField(3, (Offset + 17), (Offset + 19), ReadBuff));
              except
                FieldByName('Percent').AsFloat := 0;
              end;

              Year := GetField(2, (Offset + 20), (Offset + 21), ReadBuff);

              try
                YearInt := StrToInt(Year);
              except
                YearInt := 0;
              end;

              If (YearInt < 10)
                then Century := '20'
                else Century := '19';

              FieldByName('InitialDate').Text := '1/1/' + Century + Year;

                {Note: Due to an RPS limitation where a user is not
                       allowed to put on a duplicate exemption on a
                       parcel, the termination date field is sometimes
                       alpha. (This is so that RPS could create a
                       unique key, I think). So, we will leave the
                       termination date blank in such a case and
                       put it in an error log.}

              TempStr := GetField(2, (Offset + 22), (Offset + 23), ReadBuff);

              If (Deblank(TempStr) <> '')
                then
                  begin
                    Val(TempStr, TempNum, ReturnCode);

                      {FXX04071998-4: The termination date on some parcels
                                      goes into 2000, so can't assume 19th cetury.}
                      {Actually the century is 20 now.}

                    If (ReturnCode = 0)
                      then
                        begin
                          If (TempStr = '49')
                            then FieldByName('AutoRenew').AsBoolean := True
                            else
                              begin
                                Century := '20';

                                FieldByName('TerminationDate').Text := '1/1/' +
                                                                       Century +
                                                                       TempStr;

                              end;

                        end
                      else Writeln(ErrorLog, 'Alphabetic exemption termination date in record ' +
                                             IntToStr(RecordCount) +
                                             '.  Offset = ' +
                                             IntToStr(Offset) +
                                             '. SBL = ' +
                                             FieldByName('SwisSBLKey').Text);

                  end;  {If (Deblank(TempStr) <> '')}

              TempStr := Take(1,' ');
              TempStr := GetField(1, (Offset +14), (Offset + 14), ReadBuff);

              If (TempStr = 'Y')
                then FieldByName('ApplyToVillage').AsBoolean := True;

              FieldByName('HomeSteadCode').Text :=
                              GetField(1, (Offset+25), (Offset + 25), ReadBuff);

              try
                FieldByName('OwnerPercent').AsFloat := StrToFloat(GetField(2, (OffSet + 26), (Offset + 27), ReadBuff));
              except
                FieldByName('OwnerPercent').AsFloat := 0;
              end;

              try
                If ExtractAllData
                  then
                    begin
                      WriteInformationToExtractFile(ExemptionExtractFile, ParcelEXTable);
                      Cancel;
                    end
                  else Post;
              except
                SystemSupport(003, ParcelEXTable, 'Error Attempting to Post exemption Table',
                              UnitName, GlblErrorDlgBox);
              end;

            except  {If ((ReadBuff[32] = 'E') and ...}
              E := ExceptObject;
              Writeln(ErrorLog, 'Error in exemption record ' + IntToStr(RecordCount),
                                '  Exception: ', Exception(E).Message);
            end;  {else of If (GetField(5, ...}

      If (CreateCodes and
          (ExemptionCode <> '') and
          (not FindKeyOld(EXCodeTable, ['EXCode'], [ExemptionCode])))
        then
          with EXCodeTable do
            try
              Insert;
              FieldByName('EXCode').Text := ExemptionCode;
              FieldByName('TaxRollYr').Text := TaxRollYr;
              Post;
            except
              Cancel;
            end;

      Offset := Offset + 28;

    end;  {For Index := 1 to MaxNumEXPerLine do}

end;  {InsertExemptionRecords}

{=================================================================}
Procedure TDataConvertForm.InsertSpecialDistrictRecords(    ParcelSDTable : TTable;
                                                            TaxRollYr : String;
                                                            ProcessingType : Integer;
                                                            ReadBuff : RPSImportRec;
                                                            RecordCount : LongInt;
                                                        var ThisYearParcelSDCount,
                                                            NextYearParcelSDCount : LongInt;
                                                            SDCodeTable : TTable;
                                                            CreateCodes : Boolean;
                                                        var ErrorLog : TextFile);

{Insert all the special districts in one 995 SD record.}

var
  Index, Offset : Integer;
  SpecialDistrictCode : String;

begin
  Offset := StartSDCodePos;

  For Index := 1 to MaxNumSDPerLine do
    begin
      SpecialDistrictCode := '';
      If (Deblank(GetField(5, Offset, (Offset + 4), ReadBuff)) <> '')
        then
          try
            If (ProcessingType = ThisYear)
              then
                begin
                  ThisYearParcelSDCount := ThisYearParcelSDCount + 1;
                  TYParcelSDCountLabel.Caption := IntToStr(ThisYearParcelSDCount);
                end
              else
                begin
                  NextYearParcelSDCount := NextYearParcelSDCount + 1;
                  NYParcelSDCountLabel.Caption := IntToStr(NextYearParcelSDCount);
                end;

            with ParcelSDTable do
              begin
                Insert;
                FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
                FieldByName('SwisSBLKey').Text := GetField(26,1,26,ReadBuff);
                FieldByName('SdistCode').Text := GetField(5, Offset, (Offset + 4), ReadBuff);
                SpecialDistrictCode := FieldByName('SdistCode').Text;

                   {four decimal points}

                try
                  FieldByName('SdPercentage').AsFloat :=
                        Roundoff((StrToFloat(GetField(4, (Offset + 11), (Offset + 14), ReadBuff)) / 100),2);
                except
                  FieldByName('SdPercentage').AsFloat := 0;
                end;

                FieldByName('CalcCode').Text := GetField(1, (Offset + 15), (Offset + 15), ReadBuff);

                  {FXX03201998-1: If there is a U calc code, then the number
                                  in the amount field is actually secondary
                                  units.  Before we were putting the number in
                                  both amount AND secondary units.}

                try
                  If (FieldByName('CalcCode').Text <> PrclSDCcU)
                    then FieldByName('CalcAmount').AsFloat :=
                                      StrToFloat(GetField(12, (Offset + 16), (Offset + 27), ReadBuff));
                except
                  FieldByName('CalcAmount').AsFloat := 0;
                end;

                    {if type is T(Precalcd tax) or R(relevey tax)}
                    {then decimal point is assumed in amt field}
                    {and we must divide to get it}
                    {if type is S(Assessedval override)}
                    {OR E(Taxable val override) no decimal, no divide}

                If ((FieldByName('CalcCode').Text = PrclSDCcT) or
                    (FieldByName('CalcCode').Text = PrclSDCcR))
                  then FieldByName('CalcAmount').AsFloat :=
                           FieldByName('CalcAmount').AsFloat / 100
                  else
                    begin
                         {Since PAS does not need to maintain secondary unit due}
                         {to its ability to hold large #'s (> 9999.99) in the}
                         {primary unit field we will get units from}
                         {units field unless U is the Type Code in the}
                         {record in which case we get units (>9999.99) from}
                         {the raw record Amount field (fld has dbl use in RPS)}
                      Try
                      FieldByName('PrimaryUnits').AsFloat :=
                                  Roundoff((StrToFloat(GetField(6, (Offset+5), (Offset + 10), ReadBuff))/100),2);
                      Except
                      FieldByName('PrimaryUnits').AsFloat := 0;
                      end;

                      try
                        If (FieldByName('CalcCode').Text = PrclSDCcU)
                          then FieldByName('SecondaryUnits').AsFloat :=
                                    RoundOff((StrToFloat(GetField(12, (Offset + 16), (Offset + 27), ReadBuff))/100),2);

                        except
                        FieldByName('SecondaryUnits').AsFloat := 0;
                      end;

                    end;  {else of If ((FieldByName('CalcCode').Text = PrclSDCcT) or ...}

                try
                  If ExtractAllData
                    then
                      begin
                        WriteInformationToExtractFile(SpecialDistrictExtractFile, ParcelSDTable);
                        Cancel;
                      end
                    else Post;
                except
                  Cancel;
(*                  SystemSupport(004, ParcelSDTable, 'Error Attempting to Post special district Table',
                                UnitName, GlblErrorDlgBox); *)
                end;

              end;  {with ParcelSDTable do}

          except  {If ((ReadBuff[32] = 'E') and ...}
            ParcelSDTable.Cancel;
            E := ExceptObject;
            Writeln(ErrorLog, 'Error in SD record ' + IntToStr(RecordCount),
                              '  Exception: ', Exception(E).Message);
          end;  {else of If (GetField(5, ...}

      If (CreateCodes and
          (SpecialDistrictCode <> '') and
          (not FindKeyOld(SDCodeTable, ['SDistCode'], [SpecialDistrictCode])))
        then
          with SDCodeTable do
            try
              Insert;
              FieldByName('SDistCode').Text := SpecialDistrictCode;
              FieldByName('TaxRollYr').Text := TaxRollYr;
              Post;
            except
              Cancel;
            end;

      Offset := Offset + 28;

    end;  {For Index := 1 to MaxNumSDPerLine do}

end;  {InsertSpecialDistrictRecords}

{=================================================================}
Procedure TDataConvertForm.AddSalesRecord(    SalesRecTable : TTable;
                                              ReadBuff : RPSImportRec;
                                              RecordCount : Integer;
                                              SlsDeedTypeCodeList,
                                              SlsStatusCodeList,
                                              SlsVerifyCodeList,
                                              SlsSalesTypeCodeList,
                                              SlsArmsLengthCodeList,
                                              SlsValidityCodeList : TList;
                                          var ErrorLog : Text);

var
  TempStr : String;

begin
  with SalesRecTable do
    try
      Append;
      FieldByName('SwisSBLKey').Text := GetField(26,1,26,ReadBuff);
      FieldByName('SaleNumber').AsInteger := StrToInt(GetField(2, 27, 28, ReadBuff));
      FieldByName('ControlNo').Text := GetField(7, 210, 216, ReadBuff);

        {FXX10201997-4: Store blank if the control number is zero.}

      If (DezeroOnLeft(FieldByName('ControlNo').Text) = '')
        then FieldByName('ControlNo').Text := '';

      FieldByName('DeedTypeCode').Text := GetField(1,203,203, ReadBuff);
      FieldByName('DeedTypeDesc').Text := SetDescription(
                                        RecordCount,
                                        FieldByName('DeedTypeCode').Text,
                                        SlsDeedTypeCodeList,
                                        ErrorLog);

      FieldByName('CheckDigit').Text := GetField(2, 35, 36, ReadBuff);
      FieldByName('AssessorChangeFlag').Text := GetField(4, 243, 246, ReadBuff);

      try
        FieldByName('LastChangeDate').Text := MakeYYYYMMDDSlashed(ConvYYDate(315,320,ReadBuff));
      except
        FieldByName('LastChangeDate').Text := '';
      end;

      FieldByName('ActiveFlag').Text := GetField(1, 311, 311, ReadBuff);

      FieldByName('LegalAddr').Text := GetField(25, 83, 107, ReadBuff);

      FieldByName('LegalAddrNo').Text := Take(10, LTrim(GetField(10, 108, 117, ReadBuff)));
      TempStr := FieldByName('LegalAddrNo').Text;
      FieldByName('AccountNo').Text := GetField(11, 180, 190, ReadBuff);

      FieldByName('SaleTypeCode').Text := GetField(1, 235,235, ReadBuff);
      FieldByName('SaleTypeDesc').Text := SetDescription(
                                                    RecordCount,
                                                    FieldByName('SaleTypeCode').Text,
                                                    SlsSalesTypeCodeList,
                                                    ErrorLog);

      try
        FieldByName('SalePrice').AsFloat := StrToFloat(GetField(12,223,234, ReadBuff));
      except
        FieldByName('SalePrice').AsFloat := 0;
      end;

      TempStr := Take(6,(GetField(6,217,222,readBuff)));
      If (Take(6,Tempstr) <> TAke(6,'000000'))
         then
           try
             FieldByName('SaleDate').Text :=
                MakeYYYYMMDDSlashed(ConvYYDate(217,222,ReadBuff))
           except
             FieldByName('SaleDate').Text := '';
           end
         else  Writeln(ErrorLog, 'Sale Date Error in record ' + IntToStr(RecordCount) +
          '  ' + FieldByName('SwisSBLKey').Text +
          '   date = ' + Tempstr);


      FieldByName('VerifyCode').Text := GetField(1, 247, 247, ReadBuff);
      FieldByName('VerifyDesc').Text := SetDescription(
                                        RecordCount,
                                        FieldByName('VerifyCode').Text,
                                        SlsVerifyCodeList,
                                        ErrorLog);

      FieldByName('SaleConditionCode').Text := GetField(4,238,241, ReadBuff);



      FieldByName('DeedBook').Text := GetField(5,193,197, ReadBuff);
      FieldByName('DeedPage').Text := GetField(5,198, 202, ReadBuff);
      FieldByName('SaleStatusCode').Text := GetField(1, 242, 242, ReadBuff);
      FieldByName('SaleStatusDesc').Text := SetDescription(
                                        RecordCount,
                                        FieldByName('SaleStatusCode').Text,
                                        SlsStatusCodeList,
                                        ErrorLog);


      FieldByName('Acreage').Text := ConvNumTo2Dec(7, 139,145, ReadBuff);
      FieldByName('Frontage').Text := ConvNumTo2Dec(7, 125,131, ReadBuff);
      FieldByName('Depth').Text := ConvNumTo2Dec(7, 132,138, ReadBuff);

      FieldByName('SaleAssessmentYear').Text := '19' + GetField(2, 284, 285, ReadBuff);
      FieldByName('NewOwnerName').Text := GetField(25,155,179, ReadBuff);
      FieldByName('OldOwnerName').Text := (GetField(25,286, 310, ReadBuff));

        {FXX10201997-3: Change the arms length and validity codes to
                        booleans because of problems in the CHECK BOXES.}

      FieldByName('ArmsLength').AsBoolean := StrToBool(GetField(1, 237, 237, ReadBuff));
      FieldByName('ValidSale').AsBoolean := StrToBool_0_1(GetField(1,236,236, ReadBuff));

      try
        FieldByName('EastCoord').AsInteger := StrToInt(GetField(7,65,71, ReadBuff));
      except
        FieldByName('EastCoord').AsInteger := 0;
      end;

      try
        FieldByName('NorthCoord').AsInteger := StrToInt (GetField(7,72,78, ReadBuff));
      except
        FieldByName('NorthCoord').AsInteger := 0;
      end;

      TempStr := Take(6,(GetField(6,204,209,readBuff)));
      If (Take(6,Tempstr) <> '000000')
         then
           try
             FieldByName('DeedDate').Text :=
                    MakeYYYYMMDDSlashed(ConvYYDate(204,209,ReadBuff));
           except
             FieldByName('DeedDate').Text := '';
           end;

      FieldByName('EA5217Code').Text := GetField(4,243,246, ReadBuff);

        {The lot has an irregular shape if the dimensions code
         is 'I'.}

      TempStr := GetField(1,124,124,ReadBuff);
      If (TempStr = 'I')
        then FieldByName('IrregularShape').AsBoolean := True;

      FieldByName('OwnershipCode').Text := GetField(1,146,146, ReadBuff);
      FieldByName('RollSection').Text := GetField(1,191,191, ReadBuff);
      FieldByName('RollSubsection').Text := GetField(1,192,192, ReadBuff);
      FieldByName('SchoolDistCode').Text := GetField(6,118,123, ReadBuff);

      try
        FieldByName('NoParcels').AsInteger := StrToInt(GetField(3,248,250, ReadBuff));
      except
        FieldByName('NoParcels').AsInteger := 0;
      end;

      FieldByName('PropClass').Text := (GetField(3,147, 149, ReadBuff));
      FieldByName('HomeSteadcode').Text := GetField(1,150,150, ReadBuff);

      Tempstr := Take(9,(GetField(9,251,259, ReadBuff)));

      If (Deblank(TempStr) <> '')   {skip empty values, found in LBeach}
        then
          try
            FieldByName('PersonalPropVal').AsFloat := StrToFloat(GetField(9,251,259, ReadBuff));
          except
            FieldByName('PersonalPropVal').AsFloat := 0;
          end;

      FieldByName('ActiveFlag').Text := GetField(1,311,311, ReadBuff);

      try
        FieldByName('NumResSites').AsInteger := StrToInt(GetField(2,348,349, ReadBuff));
      except
        FieldByName('NumResSites').AsInteger := 0;
      end;

      try
        FieldByName('NumComSites').AsInteger := StrToInt(GetField(2,350,351, ReadBuff));
      except
        FieldByName('NumComSites').AsInteger := 0;
      end;

      try
        FieldByName('LandAssessedVal').AsFloat := StrToFloat(GetField(12,260,271, ReadBuff));
      except
        FieldByName('LandAssessedVal').AsFloat := 0;
      end;

      try
        FieldByName('TotAssessedVal').AsFloat := StrToFloat(GetField(12,272,283, ReadBuff));
      except
        FieldByName('TotAssessedVal').AsFloat := 0;
      end;

      If (ExtractAllData or
          ExtractSalesToFile)
        then
          begin
            WriteInformationToExtractFile(SalesExtractFile, SalesRecTable);
            Cancel;
          end
        else Post;

(*      If ExtractSalesToFile
        then
          begin
            Writeln(SalesExtractFile, FieldByName('SwisSBLKey').Text,
                                      FormatExtractField(FieldByName('SaleNumber').Text),
                                      FormatExtractField(FieldByName('ControlNo').Text),
                                      FormatExtractField(FieldByName('SaleTypeCode').Text),
                                      FormatExtractField(FieldByName('SaleTypeDesc').Text),
                                      FormatExtractField(FieldByName('SalePrice').Text),
                                      FormatExtractField(MakeYYYYMMDD(MakeMMDDYYYYDate(FieldByName('SaleDate').AsDateTime))),
                                      FormatExtractField(FieldByName('VerifyCode').Text),
                                      FormatExtractField(FieldByName('VerifyDesc').Text),
                                      FormatExtractField(FieldByName('SaleConditionCode').Text),
                                      FormatExtractField(FieldByName('DeedTypeCode').Text),
                                      FormatExtractField(FieldByName('DeedTypeDesc').Text),
                                      FormatExtractField(FieldByName('DeedBook').Text),
                                      FormatExtractField(FieldByName('DeedPage').Text),
                                      FormatExtractField(FieldByName('SaleStatusCode').Text),
                                      FormatExtractField(FieldByName('SaleStatusDesc').Text),
                                      FormatExtractField(FieldByName('Acreage').Text),
                                      FormatExtractField(FieldByName('Frontage').Text),
                                      FormatExtractField(FieldByName('Depth').Text),
                                      FormatExtractField(FieldByName('SaleAssessmentYear').Text),
                                      FormatExtractField(FieldByName('NewOwnerName').Text),
                                      FormatExtractField(FieldByName('OldOwnerName').Text),
                                      FormatExtractField(BoolToChar_Blank_Y(FieldByName('ArmsLength').AsBoolean)),
                                      FormatExtractField(FieldByName('EastCoord').Text),
                                      FormatExtractField(FieldByName('NorthCoord').Text),
                                      FormatExtractField(MakeYYYYMMDD(MakeMMDDYYYYDate(FieldByName('DeedDate').AsDateTime))),
                                      FormatExtractField(BoolToChar_Blank_Y(FieldByName('ValidSale').AsBoolean)),
                                      FormatExtractField(FieldByName('EA5217Code').Text),
                                      FormatExtractField(FieldByName('EA5217Descr').Text),
                                      FormatExtractField(FieldByName('OwnershipCode').Text),
                                      FormatExtractField(FieldByName('OwnershipDesc').Text),
                                      FormatExtractField(FieldByName('RollSection').Text),
                                      FormatExtractField(FieldByName('RollSubsection').Text),
                                      FormatExtractField(FieldByName('NoParcels').Text),
                                      FormatExtractField(FieldByName('PropClass').Text),
                                      FormatExtractField(FieldByName('HomesteadCode').Text),
                                      FormatExtractField(FieldByName('SchoolDistCode').Text),
                                      FormatExtractField(FieldByName('PersonalPropVal').Text),
                                      FormatExtractField(FieldByName('NumResSites').Text),
                                      FormatExtractField(FieldByName('NumComSites').Text),
                                      FormatExtractField(FieldByName('LandAssessedVal').Text),
                                      FormatExtractField(FieldByName('TotAssessedVal').Text),
                                      FormatExtractField(FieldByName('LegalAddrNo').Text),
                                      FormatExtractField(FieldByName('LegalAddr').Text),
                                      FormatExtractField(FieldByName('AccountNo').Text),
                                      FormatExtractField(FieldByName('AssessorChangeFlag').Text),
                                      FormatExtractField(FieldByName('ActiveFlag').Text),
                                      FormatExtractField(FieldByName('CheckDigit').Text),
                                      FormatExtractField(BoolToChar_Blank_Y(FieldByName('IrregularShape').AsBoolean)),
                                      FormatExtractField(MakeYYYYMMDD(MakeMMDDYYYYDate(FieldByName('LastChangeDate').AsDateTime))),
                                      FormatExtractField(FieldByName('LastChangeByName').Text));

            Cancel;

          end
        else
          try
            Post;
          except
            SystemSupport(005, SalesRecTable, 'Error Attempting to Post SalesRec Table',
                          UnitName, GlblErrorDlgBox);
          end; *)

  except
    E := ExceptObject;
    Writeln(ErrorLog, 'Error in sales record ' + IntToStr(RecordCount),
                      '  Exception: ', Exception(E).Message);
  end;

end;  {AddSalesRecord}

{=================================================================}
Procedure AddHstdClassInformation(ClassTable : TTable;
                                  ProcessingType : Integer;
                                  ReadBuff : RPSImportRec;
                                  Offset : Integer);

{Fill in the homestead information from the RPS buffer starting at
 position offset.}

begin
  with ClassTable do
    begin
      FieldByName('HstdAcres').Text := ConvNumTo2Dec(7, (OffSet + 2),
                                                     (Offset + 8), ReadBuff);

        {FXX11051997-1: The percent should be converted as whole numbers.
                        They are stored in RPS as x.xx
                        We were storing them in the same form, but this is
                        not consistent with the rest of PAS.}

      FieldByName('HstdLandPercent').Text := GetField(3, (OffSet + 9),
                                                      (Offset + 11), ReadBuff);
      FieldByName('HstdTotalPercent').Text := GetField(3, (OffSet + 12),
                                                       (Offset + 14), ReadBuff);
      FieldByName('HstdLandVal').Text := GetField(12, (Offset + 63),
                                                  (Offset + 74), ReadBuff);
      FieldByName('HstdTotalVal').Text := GetField(12, (Offset + 75),
                                                   (Offset + 86), ReadBuff);
      FieldByName('HstdEqualInc').Text := GetField(12, (Offset + 87),
                                                   (Offset + 98), ReadBuff);
      FieldByName('HstdEqualDec').Text := GetField(12, (Offset + 99),
                                                   (Offset + 110), ReadBuff);
      FieldByName('HstdPhysQtyInc').Text := GetField(12, (Offset + 111),
                                                     (Offset + 122), ReadBuff);
      FieldByName('HstdPhysQtyDec').Text := GetField(12, (Offset + 123),
                                                     (Offset + 134), ReadBuff);
      FieldByName('HstdImpactVal').Text := GetField(12, (Offset + 159),
                                                     (Offset + 170), ReadBuff);
      FieldByName('HstdHoldPriorVal').Text := GetField(12, (Offset + 171),
                                                       (Offset + 182), ReadBuff);
      FieldByName('HstdStatusCode').Text := GetField(1, (Offset + 259),
                                                     (Offset + 259), ReadBuff);

         {If this is a this year record, fill in the prior fields.}

      If (ProcessingType = ThisYear)
        then
          begin
            FieldByName('HstdPriorLandVal').Text := GetField(12, (Offset + 39),
                                                             (Offset + 50), ReadBuff);
            FieldByName('HstdPriorTotalVal').Text := GetField(12, (Offset + 51),
                                                              (Offset + 62), ReadBuff);

          end;  {If (ProcessingType = ThisYear)}

    end;  {with ClassTable do}

end;  {AddHstdClassInformation}

{=================================================================}
Procedure AddNonhstdClassInformation(ClassTable : TTable;
                                     ProcessingType : Integer;
                                     ReadBuff : RPSImportRec;
                                     Offset : Integer);

{Fill in the non-homestead information from the RPS buffer starting at
 position offset.}

begin
  with ClassTable do
    begin
      FieldByName('NonhstdAcres').Text := ConvNumTo2Dec(7, (OffSet + 2),
                                                        (Offset + 8), ReadBuff);

        {FXX11051997-1: The percent should be converted as whole numbers.
                        They are stored in RPS as x.xx
                        We were storing them in the same form, but this is
                        not consistent with the rest of PAS.}

      FieldByName('NonhstdLandPercent').Text := GetField(3, (OffSet + 9),
                                                         (Offset + 11), ReadBuff);
      FieldByName('NonhstdTotalPercent').Text := GetField(3, (OffSet + 12),
                                                          (Offset + 14), ReadBuff);
      FieldByName('NonhstdLandVal').Text := GetField(12, (Offset + 63),
                                                     (Offset + 74), ReadBuff);
      FieldByName('NonhstdTotalVal').Text := GetField(12, (Offset + 75),
                                                      (Offset + 86), ReadBuff);
      FieldByName('NonhstdEqualInc').Text := GetField(12, (Offset + 87),
                                                      (Offset + 98), ReadBuff);
      FieldByName('NonhstdEqualDec').Text := GetField(12, (Offset + 99),
                                                      (Offset + 110), ReadBuff);
      FieldByName('NonhstdPhysQtyInc').Text := GetField(12, (Offset + 111),
                                                        (Offset + 122), ReadBuff);
      FieldByName('NonhstdPhysQtyDec').Text := GetField(12, (Offset + 123),
                                                        (Offset + 134), ReadBuff);
      FieldByName('NonhstdImpactVal').Text := GetField(12, (Offset + 159),
                                                       (Offset + 170), ReadBuff);
      FieldByName('NonhstdHoldPriorVal').Text := GetField(12, (Offset + 171),
                                                          (Offset + 182), ReadBuff);
      FieldByName('NonhstdStatusCode').Text := GetField(1, (Offset + 259),
                                                        (Offset + 259), ReadBuff);

         {If this is a this year record, fill in the prior fields.}

      If (ProcessingType = ThisYear)
        then
          begin
            FieldByName('NonhstdPriorLandVal').Text := GetField(12, (Offset + 39),
                                                                (Offset + 50), ReadBuff);
            FieldByName('NonhstdPriorTotalVal').Text := GetField(12, (Offset + 51),
                                                                 (Offset + 62), ReadBuff);

          end;  {If (ProcessingType = ThisYear)}

    end;  {with ClassTable do}

end;  {AddHstdClassInformation}

{=================================================================}
Procedure TDataConvertForm.InsertClassRecord(    ClassTable :  TTable;
                                                 TaxRollYr : String;
                                                 ProcessingType : Integer;
                                                 ReadBuff : RPSImportRec;
                                                 RecordCount : LongInt;
                                             var ThisYearClassCount,
                                                 NextYearClassCount : LongInt;
                                             var ErrorLog : TextFile);

{Insert one class record.}

begin
  If (ProcessingType = ThisYear)
    then
      begin
        ThisYearClassCount := ThisYearClassCount + 1;
        TYClassCountLabel.Caption := IntToStr(ThisYearClassCount);
      end
    else
      begin
        NextYearClassCount := NextYearClassCount + 1;
        NYClassCountLabel.Caption := IntToStr(NextYearClassCount);
      end;

  with ClassTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYr);
      FieldByName('SwisSBLKey').Text := GetField(26, 1, 26, ReadBuff);

        {We don't want to assume that the homestead information will
         always appear first, so we will check position 40 to see if
         this is the homestead or non-homestead information and put it
         in the corresponding spots.}

      If (ReadBuff[40] = 'N')
        then AddNonhstdClassInformation(ClassTable, ProcessingType, ReadBuff, 40)
        else AddHstdClassInformation(ClassTable, ProcessingType, ReadBuff, 40);

      If (ReadBuff[298] = 'N')
        then AddNonhstdClassInformation(ClassTable, ProcessingType, ReadBuff, 298)
        else AddHstdClassInformation(ClassTable, ProcessingType, ReadBuff, 298);

      try
        If (ExtractAllData or
            ExtractSalesToFile)
          then
            begin
              WriteInformationToExtractFile(ClassExtractFile, ClassTable);
              Cancel;
            end
          else Post;

      except
        SystemSupport(006, ClassTable, 'Error Attempting to Post Class Table',
                      UnitName, GlblErrorDlgBox);
      end;

  except
    E := ExceptObject;
    Writeln(ErrorLog, 'Error in class record ' + IntToStr(RecordCount),
                      '  Exception: ', Exception(E).Message);
  end;



end;  {InsertClassRecord}

{=================================================================}
Procedure TDataConvertForm.ParcelFileClick(Sender: TObject);

var
  SalesRecCount,
  ThisYearParcelCount,
  NextYearParcelCount,
  ThisYearParcelSDCount,
  NextYearParcelSDCount,
  ThisYearParcelExCount,
  NextYearParcelExCount,
  ThisYearClassCount,
  NextYearClassCount,
  TotalRecCount, I : LongInt;

  ReadBuff : RPSImportRec;
  RPSFile : File;
  StateScan : TextFile;
  Quit, Done, Found,
  ExemptionsOnly,  {Do we only want to conver the exemptions?}
  BuildAllFiles,  {Is this only one step of building all the files?}
  CreateCodes, LastParcelHadNYRecord : Boolean;  {Did we encounter an NY record for this parcel. If not, create one.}

  SlsDeedTypeCodeList,
  SlsStatusCodeList,
  SlsVerifyCodeList,
  SlsSalesTypeCodeList,
  SlsArmsLengthCodeList,
  SlsValidityCodeList,
  PropClassList,
  HomesteadCodeList,
  OwnershipCodeList,
  EasementCodeList,
  LandCommitmentCodeList,
  OrigAssessedValueCodeList,
  RevisedAssessedValueCodeList : TList;

  TempSalesTable,
  SalesTable,
  ThisYearParcelTable,
  NextYearParcelTable,
  ThisYearAssessmentTable,
  NextYearAssessmentTable,
  ThisYearSDTable,
  NextYearSDTable,
  ThisYearEXTable,
  NextYearEXTable,
  ThisYearSchoolCodeTable,
  NextYearSchoolCodeTable,
  ThisYearClassTable,
  NextYearClassTable,
  ThisYearEXCodeTable,
  ThisYearSwisCodeTable,
  NextYearEXCodeTable,
  NextYearSwisCodeTable,
  ThisYearSDCodeTable,
  NextYearSDCodeTable : TTable;

  CurrentSwisSBLKey, LastSwisSBLKey, SwisSBLKey : String;
  Count, NumCopied : Integer;
  ReturnCode : Integer;
  SBLRec : SBLRecord;
  TempStr, SwisCode, SchoolCode : String;
  InventoryOnly : Boolean;
  TotalAssessedValue : Double;
  ThisParcelAssessment : LongInt;
  ExemptionsNotRecalculatedList : TStringList;

begin
  ExemptionsNotRecalculatedList := TStringList.Create;
  RecalculateExemptions := RecalculateExemptionsCheckBox.Checked;
  CreateCodes := CreateCodeCheckBox.Checked;
  TotalAssessedValue := 0;

  BuildAllFiles := (TComponent(Sender).Name = 'AllButton');

  ExemptionsOnly := ConvertExemptionsOnlyCheckBox.Checked;

  ConversionCancelled := False;
  Count := 1;

  LastSwisSBLKey := '';
  LastParcelHadNYRecord := False;

  TotalRecCount := 0;
  I := 0;
  SalesRecCount := 0;
  ThisYearParcelCount := 0;
  NextYearParcelCount := 0;
  ThisYearParcelSDCount := 0;
  NextYearParcelSDCount := 0;
  ThisYearParcelExCount := 0;
  NextYearParcelExCount := 0;
  ThisYearClassCount := 0;
  NextYearClassCount := 0;

  ParcelRecordLabel.Visible := True;
  ParcelSDRecordLabel.Visible := True;
  ParcelExRecordLabel.Visible := True;

  Done := False;
  Quit := False;
  StartTimeLabel.Caption := 'Start Time = ' + TimeToStr(Now);
  StartTimeLabel.Refresh;

    {Open the state file, RPS995 file, and error file.}

  try
    AssignFile(StateScan,'STATSCAN.SCN');
    Rewrite(StateScan);
  except
  end;

  Open995Dialog.InitialDir := LocationOfFiles;

  If Open995Dialog.Execute
    then
      begin
        FileNameLabel.Caption := Open995Dialog.FileName;

         {Close all the tables in the data module.}

(*        with PASDataModule do
          For I := 0 to (ComponentCount - 1) do
            If ((Components[I] is TwwTable) and
                (Deblank(TwwTable(Components[I]).TableName) <> ''))
              then TwwTable(Components[I]).Close;

        LocateParcelForm.ParcelTable.Close;
        LocateParcelForm.ParcelLookupTable.Close;
        LocateParcelForm.AssessmentTable.Close; *)

        AssignFile(RPSFile, Open995Dialog.FileName);
        Reset(RpsFile, RPSImportRecordLength);

          {If we are building all files, the error log is already open.}

        If not BuildAllFiles
          then
            begin
              AssignFile(ErrorLog, 'ERROR.TXT');
              Rewrite(ErrorLog);
            end;

          {Create and open the this year and next year files.}

        SalesTable := TTable.Create(nil);
        TempSalesTable := TTable.Create(nil);
        ThisYearParcelTable := TTable.Create(nil);
        NextYearParcelTable := TTable.Create(nil);
        ThisYearAssessmentTable := TTable.Create(nil);
        NextYearAssessmentTable := TTable.Create(nil);
        ThisYearSDTable := TTable.Create(nil);
        NextYearSDTable := TTable.Create(nil);
        ThisYearEXTable := TTable.Create(nil);
        NextYearEXTable := TTable.Create(nil);
        ThisYearClassTable := TTable.Create(nil);
        NextYearClassTable := TTable.Create(nil);
        ThisYearEXCodeTable := TTable.Create(nil);
        ThisYearSwisCodeTable := TTable.Create(nil);
        NextYearEXCodeTable := TTable.Create(nil);
        NextYearSwisCodeTable := TTable.Create(nil);
        ThisYearSchoolCodeTable := TTable.Create(nil);
        NextYearSchoolCodeTable := TTable.Create(nil);
        ThisYearSDCodeTable := TTable.Create(nil);
        NextYearSDCodeTable := TTable.Create(nil);

(*        SalesTable.Exclusive := True;
        ThisYearParcelTable.Exclusive := True;
        NextYearParcelTable.Exclusive := True;
        ThisYearAssessmentTable.Exclusive := True;
        NextYearAssessmentTable.Exclusive := True;
        ThisYearSDTable.Exclusive := True;
        NextYearSDTable.Exclusive := True;
        ThisYearEXTable.Exclusive := True;
        NextYearEXTable.Exclusive := True;
        ThisYearClassTable.Exclusive := True;
        NextYearClassTable.Exclusive := True; *)

        OpenTableForProcessingType(SalesTable, SalesTableName,
                                   GlblProcessingType, Quit);

        If ExtractSalesToFile
          then OpenTableForProcessingType(TempSalesTable, 'PTempSalesRec',
                                          GlblProcessingType, Quit);
        OpenTableForProcessingType(ThisYearParcelTable, ParcelTableName,
                                   ThisYear, Quit);
        OpenTableForProcessingType(NextYearParcelTable, ParcelTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(ThisYearAssessmentTable, AssessmentTableName,
                                   ThisYear, Quit);
        OpenTableForProcessingType(NextYearAssessmentTable, AssessmentTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(ThisYearSDTable, SpecialDistrictTableName,
                                   ThisYear, Quit);
        OpenTableForProcessingType(NextYearSDTable, SpecialDistrictTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(ThisYearEXTable, ExemptionsTableName,
                                   ThisYear, Quit);
        OpenTableForProcessingType(NextYearEXTable, ExemptionsTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(ThisYearClassTable, ClassTableName,
                                   ThisYear, Quit);
        OpenTableForProcessingType(NextYearClassTable, ClassTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(ThisYearEXCodeTable, 'TExCodeTbl',
                                   ThisYear, Quit);
        OpenTableForProcessingType(ThisYearSwisCodeTable, 'TSwisTbl',
                                   ThisYear, Quit);
        OpenTableForProcessingType(NextYearEXCodeTable, 'TExCodeTbl',
                                   NextYear, Quit);
        OpenTableForProcessingType(NextYearSwisCodeTable, 'TSwisTbl',
                                   NextYear, Quit);
        OpenTableForProcessingType(ThisYearSchoolCodeTable, 'TSchoolTbl',
                                   ThisYear, Quit);
        OpenTableForProcessingType(NextYearSchoolCodeTable, 'TSchoolTbl',
                                   NextYear, Quit);
        OpenTableForProcessingType(ThisYearSDCodeTable, 'TSDCodeTbl',
                                   ThisYear, Quit);
        OpenTableForProcessingType(NextYearSDCodeTable, 'TSDCodeTbl',
                                   NextYear, Quit);

        OpenTableForProcessingType(ParcelLookupTable, ParcelTableName,
                                   ThisYear, Quit);

        LocationOfFiles := ReturnPath(Open995Dialog.FileName);
        If ExtractAllData
          then
            try
              ChDir(LocationOfFiles);
              AssignFile(ParcelExtractFile, ThisYearParcelTable.TableName + '.csv');
              AssignFile(SalesExtractFile, SalesTable.TableName + '.csv');
              AssignFile(AssessmentExtractFile, ThisYearAssessmentTable.TableName + '.csv');
              AssignFile(ClassExtractFile, ThisYearClassTable.TableName + '.csv');
              AssignFile(ExemptionExtractFile, ThisYearEXTable.TableName + '.csv');
              AssignFile(SpecialDistrictExtractFile, ThisYearSDTable.TableName + '.csv');

              If FileExists(LocationOfFilesEdit.Text + ThisYearParcelTable.TableName + '.csv')
                then
                  begin
                    Append(ParcelExtractFile);
                    Append(SalesExtractFile);
                    Append(AssessmentExtractFile);
                    Append(ClassExtractFile);
                    Append(ExemptionExtractFile);
                    Append(SpecialDistrictExtractFile);
                  end
                else
                  begin
                    Rewrite(ParcelExtractFile);
                    Rewrite(SalesExtractFile);
                    Rewrite(AssessmentExtractFile);
                    Rewrite(ClassExtractFile);
                    Rewrite(ExemptionExtractFile);
                    Rewrite(SpecialDistrictExtractFile);
                  end;

            except
            end;

(*        SalesTable.EmptyTable;
        ThisYearParcelTable.EmptyTable;
        NextYearParcelTable.EmptyTable;
        ThisYearAssessmentTable.EmptyTable;
        NextYearAssessmentTable.EmptyTable;
        ThisYearSDTable.EmptyTable;
        NextYearSDTable.EmptyTable;
        ThisYearEXTable.EmptyTable;
        NextYearEXTable.EmptyTable;
        ThisYearClassTable.EmptyTable;
        NextYearClassTable.EmptyTable;*)

(*        DeleteTable(SalesTable);
        DeleteTable(ThisYearParcelTable);
        DeleteTable(NextYearParcelTable);
        DeleteTable(ThisYearAssessmentTable);
        DeleteTable(NextYearAssessmentTable);
        DeleteTable(ThisYearSDTable);
        DeleteTable(NextYearSDTable);
        DeleteTable(ThisYearEXTable);
        DeleteTable(NextYearEXTable);
        DeleteTable(ThisYearClassTable);
        DeleteTable(NextYearClassTable);*)

        ThisYearParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        NextYearParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        ThisYearAssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        NextYearAssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        ThisYearClassTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        NextYearClassTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

        ThisYearSDTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SD';
        NextYearSDTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SD';

        ThisYearEXTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';
        NextYearExTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';

        ThisYearEXCodeTable.IndexName := 'ByEXCode';
        NextYearEXCodeTable.IndexName := 'ByEXCode';

        ThisYearSDCodeTable.IndexName := 'BYSDISTCODE';
        NextYearSDCodeTable.IndexName := 'BYSDISTCODE';

        ThisYearSwisCodeTable.IndexName := 'BYSWISCODE';
        NextYearSwisCodeTable.IndexName := 'BYSWISCODE';

        ThisYearSchoolCodeTable.IndexName := 'BYSCHOOLCODE';
        NextYearSchoolCodeTable.IndexName := 'BYSCHOOLCODE';

        PropClassList := TList.Create;
        HomesteadCodeList := TList.Create;
        OwnershipCodeList := TList.Create;
        EasementCodeList := TList.Create;
        LandCommitmentCodeList := TList.Create;
        OrigAssessedValueCodeList := TList.Create;
        RevisedAssessedValueCodeList := TList.Create;

        SlsDeedTypeCodeList := TList.Create;
        SlsStatusCodeList := TList.Create;
        SlsVerifyCodeList := TList.Create;
        SlsSalesTypeCodeList := TList.Create;
        SlsArmsLengthCodeList := TList.Create;
        SlsValidityCodeList := TList.Create;

        LoadCodeList(PropClassList, 'ZPropClsTbl', 'MainCode', 'Description', Quit);
        LoadCodeList(HomesteadCodeList, 'ZHomesteadCodeTbl', 'MainCode', 'Description', Quit);
        LoadCodeList(OwnershipCodeList, 'ZOwnershipTbl', 'MainCode', 'Description', Quit);
        LoadCodeList(EasementCodeList, 'ZEasementTbl', 'MainCode', 'Description', Quit);
        LoadCodeList(LandCommitmentCodeList, 'ZLandCommitmentTbl', 'MainCode', 'Description', Quit);
        LoadCodeList(OrigAssessedValueCodeList, 'ZOrigAssValTbl', 'MainCode', 'Description', Quit);
        LoadCodeList(RevisedAssessedValueCodeList, 'ZRevisedAssValTbl', 'MainCode', 'Description', Quit);

        LoadCodeList(SlsDeedTypeCodeList, 'ZSlsDeedTypeTbl', 'MainCode', 'Description', Quit);
        LoadCodeList(SlsStatusCodeList, 'ZSlsStatusTbl', 'MainCode', 'Description', Quit);
        LoadCodeList(SlsVerifyCodeList, 'ZSlsVerifyTbl', 'MainCode', 'Description', Quit);
        LoadCodeList(SlsSalesTypeCodeList, 'ZSlsSalesTypeTbl', 'MainCode', 'Description', Quit);
        LoadCodeList(SlsArmsLengthCodeList, 'ZSlsArmsLengthTbl', 'MainCode', 'Description', Quit);
        LoadCodeList(SlsValidityCodeList, 'ZSlsValidityTbl', 'MainCode', 'Description', Quit);

          {FXX080051998-5: Make sure that the county vet limits are loaded for any county
                           only vet exemptions.}

        AssessmentYearControlTable.Open;

        with AssessmentYearControlTable do
          begin
            GlblCountyVeteransMax := FieldByName('VeteranCntyMax').AsFloat;
            GlblCountyCombatVeteransMax := FieldByName('CombatVetCntyMax').AsFloat;
            GlblCountyDisabledVeteransMax := FieldByName('DisabledVetCntyMax').AsFloat;
          end;  {with AssessmentYearControlTable do}

        AssessmentYearControlTable.Close;

(*        If ExtractSalesToFile
          then SalesTable.Insert;*)

        repeat
          try
            BlockRead(RpsFile, ReadBuff, Count, ReturnCode);
          except
            Done := True;
          end;

          Application.ProcessMessages;

          If (EOF(RpsFile) or
              (TrialRun and
               (ThisYearParcelCount > 200)))
            then Done := True;

          TotalRecCount := TotalRecCount + 1;
          TotRecLabel.Caption := 'Tot Rec Count = ' + IntToStr(TotalRecCount);

            {This year parcel record.}

            {FXX10101997-1: We were not creating a next year parcel for the last parcel.}
            {FXX08051998-3: Need to check for copying forward whether this is a next year
                            or a this year parcel so don't have problems with case where
                            NY only follows TY only.}

          CurrentSwisSBLKey := GetField(26, 1, 26, ReadBuff);

            If (Done or
              ((ReadBuff[32] = 'P') and
               (CurrentSwisSBLKey <> LastSwisSBLKey) and
               (Deblank(LastSwisSBLKey) <> '')))
            then
              begin
                If ExemptionsOnly
                  then
                    begin
                      SBLRec := ExtractSwisSBLFromSwisSBLKey(CurrentSwisSBLKey);

                      with SBLRec do
                        FindKeyOld(ThisYearParcelTable,
                                   ['TaxRollYr', 'SwisCode', 'Section',
                                    'Subsection', 'Block', 'Lot',
                                    'Sublot', 'Suffix'],
                                   [GlblThisYear, SwisCode, Section, Subsection,
                                    Block, Lot, Sublot, Suffix]);

                      If (LastParcelHadNYRecord and
                          CreateNYCheckBox.Checked)
                        then
                          with SBLRec do
                            Found := FindKeyOld(NextYearParcelTable,
                                                ['TaxRollYr', 'SwisCode', 'Section',
                                                 'Subsection', 'Block', 'Lot',
                                                 'Sublot', 'Suffix'],
                                                [GlblNextYear, SwisCode, Section, Subsection,
                                                 Block, Lot, Sublot, Suffix]);

                    end;

                  {If the last parcel had no NY record and the TY parcel
                   is active, then insert all the NY information -
                   parcel, SD, Ex.}

                  {CHG11051997-1: Build only exemptions since this file had an index change.}

                If ((not LastParcelHadNYRecord) and
                    (ThisYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
                    (not ExemptionsOnly) and
                    CreateNYCheckBox.Checked)
                  then
                    begin
                        {FXX02031999-5: Don't copy forward any spilt\merge or old SBL info.}

                      CopyTable_OneRecord(ThisYearParcelTable, NextYearParcelTable,
                                         ['TaxRollYr', 'RemapOldSBL', 'SplitMergeNo'],
                                         [GlblNextYear, '', '']);
                      CopyTable_OneRecord(ThisYearAssessmentTable, NextYearAssessmentTable,
                                          ['TaxRollYr',
                                           'IncreaseForEqual', 'DecreaseForEqual',
                                           'PhysicalQtyIncrease', 'PhysicalQtyDecrease',
                                           'AssessmentDate'],
                                          [GlblNextYear,
                                           '0', '0', '0', '0',
                                           '1/1/' + GlblNextYear]);

                        {FXX10201997-2: Copy the class records ahead to NY.}

                      Found := FindKeyOld(ThisYearClassTable,
                                          ['TaxRollYr', 'SwisSBLKey'],
                                          [GlblThisYear, LastSwisSBLKey]);

                      If Found
                        then
                          begin
                            CopyTable_OneRecord(ThisYearClassTable, NextYearClassTable,
                                                ['TaxRollYr'], [GlblNextYear]);
                            NextYearClassCount := NextYearClassCount + 1;
                            NYClassCountLabel.Caption := IntToStr(NextYearClassCount);

                          end;  {If Found}

                      NextYearParcelCount := NextYearParcelCount + 1;
                      NYParcelCountLabel.Caption := IntToStr(NextYearParcelCount);

                      SetRangeOld(ThisYearSDTable,
                                  ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                                  [GlblThisYear, LastSwisSBLKey, '     '],
                                  [GlblThisYear, LastSwisSBLKey, 'ZZZZZ']);
                      NumCopied := CopyTableRange(ThisYearSDTable, NextYearSDTable,
                                                  'SDistCode',
                                                  ['TaxRollYr'], [GlblNextYear]);

                      NextYearParcelSDCount := NextYearParcelSDCount + NumCopied;
                      NYParcelSDCountLabel.Caption := IntToStr(NextYearParcelSDCount);

                    end;  {If ((not LastParcelHadNYRecord) and ...}

                If ((not LastParcelHadNYRecord) and
                    (ThisYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
                    CreateNYCheckBox.Checked)
                  then
                    begin
                         {Now copy the exemptions and special districts
                          from this year to next year.}

                      SetRangeOld(ThisYearEXTable,
                                  ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                  [GlblThisYear, LastSwisSBLKey, '     '],
                                  [GlblThisYear, LastSwisSBLKey, 'ZZZZZ']);

                        {FXX02261998-5: Do not copy the auto increment ID forward.
                                        It causes dup key errors if the # of TY
                                        and NY exemptions do not match.}

                      NumCopied := CopyTableRange(ThisYearEXTable, NextYearEXTable,
                                                  'ExemptionCode',
                                                  ['TaxRollYr'],
                                                  [GlblNextYear]);

                      NextYearParcelEXCount := NextYearParcelEXCount + NumCopied;
                      NYParcelEXCountLabel.Caption := IntToStr(NextYearParcelEXCount);

                        {FXX02121998-2: We need to recalculate the exemptions
                                        for next year even if we are just copying
                                        them forward since STAR limits are different
                                        by year.}

                      If RecalculateExemptions
                        then RecalculateExemptionsForParcel(NextYearExCodeTable,
                                                            NextYearExTable,
                                                            NextYearAssessmentTable,
                                                            NextYearClassTable,
                                                            NextYearSwisCodeTable,
                                                            NextYearParcelTable,
                                                            GlblNextYear,
                                                            LastSwisSBLKey,
                                                            ExemptionsNotRecalculatedList);

                    end;  {If ((not LastParcelHadNYRecord) and ...}

                LastParcelHadNYRecord := False;

              end;  {If (Done or ...}

            {Insert a ThisYear parcel. Note that the number of
             parcels and assessment records are always the same.}

          If ((not Done) and
              (ReadBuff[32] = 'P') and  {Parcel rec.}
              (ReadBuff[821] = '1') and
              (not ExemptionsOnly))    {Next year}
            then
              begin
                ThisYearParcelCount := ThisYearParcelCount + 1;
                TYParcelCountLabel.Caption := IntToStr(ThisYearParcelCount);

                InsertParcelRecord(ThisYearParcelTable, GlblThisYear,
                                   ReadBuff, ThisYear, PropClassList,
                                   HomesteadCodeList, OwnershipCodeList,
                                   EasementCodeList,
                                   LandCommitmentCodeList, TotalRecCount,
                                   ThisYearSwisCodeTable, ThisYearSchoolCodeTable,
                                   CreateCodes, SwisSBLKey, StateScan, ErrorLog);

                If CreateCodes
                  then
                    begin
                      SwisCode := ThisYearParcelTable.FieldByName('SwisCode').Text;
                      SchoolCode := ThisYearParcelTable.FieldByName('SchoolCode').Text;

                      If not FindKeyOld(ThisYearSwisCodeTable, ['SwisCode'], [SwisCode])
                        then
                          with ThisYearSwisCodeTable do
                            try
                              Insert;
                              FieldByName('SwisCode').Text := SwisCode;
                              FieldByName('TaxRollYr').Text := GlblThisYear;
                              Post;
                            except
                              Cancel;
                            end;

                      If not FindKeyOld(ThisYearSchoolCodeTable, ['SchoolCode'], [SchoolCode])
                        then
                          with ThisYearSchoolCodeTable do
                            try
                              Insert;
                              FieldByName('SchoolCode').Text := SchoolCode;
                              FieldByName('TaxRollYr').Text := GlblThisYear;
                              Post;
                            except
                              Cancel;
                            end;

                    end;  {If CreateCodes}

                InsertAssessmentRecord(ThisYearAssessmentTable, GlblThisYear,
                                       ReadBuff, ThisYear, SwisSBLKey,
                                       OrigAssessedValueCodeList,
                                       RevisedAssessedValueCodeList,
                                       ThisParcelAssessment,
                                       TotalRecCount,
                                       ErrorLog);

                TotalAssessedValue := TotalAssessedValue + ThisParcelAssessment;
                TotalAssessmentLabel.Caption := 'Total AV = ' + FormatFloat(CurrencyDisplayNoDollarSign,
                                                                            TotalAssessedValue);
                LastSwisSBLKey := GetField(26, 1, 26, ReadBuff);

              end;  {If not Done}

            {Next year parcel record.}

          If ((not Done) and
              (ReadBuff[32] = 'P') and  {Parcel rec.}
              (ReadBuff[821] = '3') and
              CreateNYCheckBox.Checked)    {Next year}
            then
              begin
                LastParcelHadNYRecord := True;

                   {Insert a NextYear parcel. Note that the number of
                    parcels and assessment records are always the same.}

                If not ExemptionsOnly
                  then
                    begin
                      NextYearParcelCount := NextYearParcelCount + 1;
                      NYParcelCountLabel.Caption := IntToStr(NextYearParcelCount);

                      InsertParcelRecord(NextYearParcelTable, GlblNextYear,
                                         ReadBuff, NextYear, PropClassList,
                                         HomesteadCodeList, OwnershipCodeList,
                                         EasementCodeList,
                                         LandCommitmentCodeList, TotalRecCount,
                                         NextYearSwisCodeTable, NextYearSchoolCodeTable, CreateCodes,
                                         SwisSBLKey, StateScan, ErrorLog);

                      InsertAssessmentRecord(NextYearAssessmentTable, GlblNextYear,
                                             ReadBuff, NextYear, SwisSBLKey,
                                             OrigAssessedValueCodeList,
                                             RevisedAssessedValueCodeList,
                                             ThisParcelAssessment,
                                             TotalRecCount, ErrorLog);

                    end;  {If not ExemptionsOnly}

                LastSwisSBLKey := GetField(26, 1, 26, ReadBuff);

              end;  {Next year Parcel, assessment record}

            {This year exemption record.}

          If ((not Done) and
              (ReadBuff[32] = 'E') and  {Exemption rec.}
              (ReadBuff[821] = '2'))    {2 = This year,4 = nxt yr}
            then InsertExemptionRecords(ThisYearEXTable, GlblThisYear,
                                        ThisYear, ReadBuff, TotalRecCount,
                                        ThisYearParcelEXCount,
                                        NextYearParcelEXCount,
                                        ThisYearEXCodeTable,
                                        CreateCodes, ErrorLog);

            {Next year exemption record.}

          If ((not Done) and
              (ReadBuff[32] = 'E') and  {Exemption rec.}
              (ReadBuff[821] = '4') and
              CreateNYCheckBox.Checked)    {2 = Next year,4 = nxt yr}
            then InsertExemptionRecords(NextYearEXTable, GlblNextYear,
                                        NextYear, ReadBuff, TotalRecCount,
                                        ThisYearParcelEXCount,
                                        NextYearParcelEXCount,
                                        NextYearEXCodeTable,
                                        CreateCodes, ErrorLog);

            {This year special district record.}

          If ((not Done) and
              (ReadBuff[32] = 'D') and  {special district rec.}
              (ReadBuff[821] = '2') and    {2 = This year,4 = nxt yr}
              (not ExemptionsOnly))
            then InsertSpecialDistrictRecords(ThisYearSDTable, GlblThisYear,
                                              ThisYear, ReadBuff, TotalRecCount,
                                              ThisYearParcelSDCount,
                                              NextYearParcelSDCount,
                                              ThisYearSDCodeTable,
                                              CreateCodes,
                                              ErrorLog);

            {Next year special district record.}

          If ((not Done) and
              (ReadBuff[32] = 'D') and  {special district rec.}
              (ReadBuff[821] = '4') and    {2 = Next year,4 = nxt yr}
              (not ExemptionsOnly) and
              CreateNYCheckBox.Checked)
            then InsertSpecialDistrictRecords(NextYearSDTable, GlblNextYear,
                                              NextYear, ReadBuff, TotalRecCount,
                                              ThisYearParcelSDCount,
                                              NextYearParcelSDCount,
                                              NextYearSDCodeTable,
                                              CreateCodes,
                                              ErrorLog);

            {This year class record.}

          If ((not Done) and
              (ReadBuff[32] = 'H') and  {Class rec.}
              (ReadBuff[821] = '2') and    {2 = This year,4 = nxt yr}
              (not ExemptionsOnly))
            then
              begin
                InsertClassRecord(ThisYearClassTable, GlblThisYear,
                                  ThisYear, ReadBuff, TotalRecCount,
                                  ThisYearClassCount,
                                  NextYearClassCount,
                                  ErrorLog);

              end;  {If ((not Done) and ...}

            {Next year class record.}

            {FXX10201997-6: A next year class record was being inserted if
                            the year indicator was 2.}

          If ((not Done) and
              (ReadBuff[32] = 'H') and  {Class rec.}
              (ReadBuff[821] = '4') and    {2 = Next year,4 = nxt yr}
              (not ExemptionsOnly) and
              CreateNYCheckBox.Checked)
            then
              begin
                InsertClassRecord(NextYearClassTable, GlblNextYear,
                                  NextYear, ReadBuff, TotalRecCount,
                                  NextYearClassCount,
                                  NextYearClassCount,
                                  ErrorLog);

              end;  {If ((not Done) and ...}


             {Sales records}
             {CHG11171997-1: Only convert 500 sales recs in trial run.}

          If ((ReadBuff[32] = 'S') and  {Sales rec.}
              (ReadBuff[821] = '1') and    {always 1 regardless of year}
              (not ExemptionsOnly) and
              ConvertSalesCheckBox.Checked and
              ((not TrialRun) or
               (SalesRecCount < 200)))
            then
              begin
                SalesRecCount := SalesRecCount + 1;
                SalesRecCountLabel.Caption := IntToStr(SalesRecCount);

                AddSalesRecord(SalesTable, ReadBuff, TotalRecCount,
                               SlsDeedTypeCodeList, SlsStatusCodeList,
                               SlsVerifyCodeList, SlsSalesTypeCodeList,
                               SlsArmsLengthCodeList, SlsValidityCodeList,
                               ErrorLog);

              end;  {If ((ReadBuff[32] = 'S') and ...}

        until (Done or ConversionCancelled);

        ProgressDialog.Start(1, False, False);

        If RecalculateExemptions
          then RecalculateAllExemptions(Self, ProgressDialog,
                                        ThisYear, GlblThisYear, True, ConversionCancelled);

        CreateRollTotals(ThisYear, GlblThisYear, ProgressDialog, Self,
                         False, True);

        If CreateNYCheckBox.Checked
          then
            begin
              ProgressDialog.Reset;
              ProgressDialog.Start(1, False, False);
              If RecalculateExemptions
                then RecalculateAllExemptions(Self, ProgressDialog,
                                              NextYear, GlblNextYear, True, ConversionCancelled);

              CreateRollTotals(NextYear, GlblNextYear, ProgressDialog, Self,
                               False, True);

              ProgressDialog.Finish;

            end;  {If CreateNYCheckBox.Checked}

(*        If ExtractSalesToFile
          then SalesTable.Cancel;*)

        If not BuildAllFiles
          then EndTimeLabel.Caption := 'End Time = ' + TimeToStr(Now);

        CloseFile(RPSFile);
        CloseFile(ErrorLog);
        CloseFile(StateScan);

        FreeTList(PropClassList, SizeOf(CodeRecord));
        FreeTList(HomesteadCodeList, SizeOf(CodeRecord));
        FreeTList(OwnershipCodeList, SizeOf(CodeRecord));
        FreeTList(EasementCodeList, SizeOf(CodeRecord));
        FreeTList(LandCommitmentCodeList, SizeOf(CodeRecord));
        FreeTList(OrigAssessedValueCodeList, SizeOf(CodeRecord));
        FreeTList(RevisedAssessedValueCodeList, SizeOf(CodeRecord));

        FreeTList(SlsDeedTypeCodeList, SizeOf(CodeRecord));
        FreeTList(SlsStatusCodeList, SizeOf(CodeRecord));
        FreeTList(SlsVerifyCodeList, SizeOf(CodeRecord));
        FreeTList(SlsSalesTypeCodeList, SizeOf(CodeRecord));
        FreeTList(SlsArmsLengthCodeList, SizeOf(CodeRecord));
        FreeTList(SlsValidityCodeList, SizeOf(CodeRecord));

        SalesTable.Close;

        If ExtractSalesToFile
          then TempSalesTable.Close;
        ThisYearParcelTable.Close;
        NextYearParcelTable.Close;
        ThisYearAssessmentTable.Close;
        NextYearAssessmentTable.Close;
        ThisYearSDTable.Close;
        NextYearSDTable.Close;
        ThisYearEXTable.Close;
        NextYearEXTable.Close;
        ThisYearClassTable.Close;
        NextYearClassTable.Close;
        ThisYearSwisCodeTable.Close;
        ThisYearExCodeTable.Close;
        NextYearSwisCodeTable.Close;
        NextYearExCodeTable.Close;
        ThisYearSchoolCodeTable.Close;
        ThisYearSDCodeTable.Close;
        NextYearSchoolCodeTable.Close;
        NextYearSDCodeTable.Close;

        SalesTable.Free;
        TempSalesTable.Free;
        ThisYearParcelTable.Free;
        NextYearParcelTable.Free;
        ThisYearAssessmentTable.Free;
        NextYearAssessmentTable.Free;
        ThisYearSDTable.Free;
        NextYearSDTable.Free;
        ThisYearEXTable.Free;
        NextYearEXTable.Free;
        ThisYearClassTable.Free;
        NextYearClassTable.Free;
        ThisYearSwisCodeTable.Free;
        ThisYearExCodeTable.Free;
        NextYearSwisCodeTable.Free;
        NextYearExCodeTable.Free;
        ThisYearSchoolCodeTable.Free;
        ThisYearSDCodeTable.Free;
        NextYearSchoolCodeTable.Free;
        NextYearSDCodeTable.Free;

        try
          CloseFile(ParcelExtractFile);
          CloseFile(AssessmentExtractFile);
          CloseFile(ClassExtractFile);
          CloseFile(ExemptionExtractFile);
          CloseFile(SpecialDistrictExtractFile);
          CloseFile(SalesExtractFile);
        except
        end;

      end;  {If Open995Dialog.Execute}

  If not BuildAllFiles
    then MessageDlg('Parcel conversion complete.', mtInformation, [mbOK], 0);

  ExemptionsNotRecalculatedList.Free;

end;  {ParcelFileClick}

{=====================================================}
Procedure TDataConvertForm.ParcelsButtonClick(Sender: TObject);

var
  Count : Integer;
  ParcelCount, RecordCount : LongInt;
  ReadBuff : RPSImportRec;
  RPSFile : File;
  Done : Boolean;
  ProcessingType : Integer;
  TaxRollYear, SwisSBLKey : String;
  ParcelTable : TTable;
  PropClassList,
  HomesteadCodeList,
  OwnershipCodeList,
  EasementCodeList,
  LandCommitmentCodeList : TList;
  StateScan : TextFile;
  Quit : Boolean;

begin
  RecordCount := 0;
  Quit := False;
  ParcelTable := TTable.Create(nil);

  AssignFile(StateScan,'STATSCAN.SCN');
  Rewrite(StateScan);

  OpenTableForProcessingType(ParcelTable, ParcelTableName, ThisYear, Quit);

  PropClassList := TList.Create;
  HomesteadCodeList := TList.Create;
  OwnershipCodeList := TList.Create;
  EasementCodeList := TList.Create;
  LandCommitmentCodeList := TList.Create;

  LoadCodeList(PropClassList, 'ZPropClsTbl', 'MainCode', 'Description', Quit);
  LoadCodeList(HomesteadCodeList, 'ZHomesteadCodeTbl', 'MainCode', 'Description', Quit);
  LoadCodeList(OwnershipCodeList, 'ZOwnershipTbl', 'MainCode', 'Description', Quit);
  LoadCodeList(EasementCodeList, 'ZEasementTbl', 'MainCode', 'Description', Quit);
  LoadCodeList(LandCommitmentCodeList, 'ZLandCommitmentTbl', 'MainCode', 'Description', Quit);

  AssignFile(RPSFile, GlblRPSDataDir + 'RPS995T1');
  Reset(RpsFile, RPSImportRecordLength);

  AssignFile(ErrorLog, GlblRPSDataDir + 'ERROR.TXT');
  Rewrite(ErrorLog);

  ParcelCount := 0;
  ParcelRecordLabel.Visible := True;

  Done := False;
  Count := 1;
  StartTimeLabel.Caption := 'Start Time = ' + TimeToStr(Now);
  StartTimeLabel.Refresh;

  repeat
    BlockRead(RpsFile, ReadBuff, Count);
    Application.ProcessMessages;

    RecordCount := RecordCount + 1;
    TotRecLabel.Caption := 'Tot Rec Count = ' + IntToStr(Recordcount);
    TotRecLabel.Repaint;

    If EOF(RpsFile)
      then Done := True;

    If ((ReadBuff[32] = 'P') and  {Parcel rec.}
        (ReadBuff[821] = '1'))    {This year}
      then
        begin
          ParcelCount := ParcelCount + 1;
          TYParcelCountLabel.Caption := IntToStr(ParcelCount);
          ParcelRecordLabel.Refresh;

          InsertParcelRecord(ParcelTable, GlblThisYear,
                             ReadBuff, ThisYear, PropClassList,
                             HomesteadCodeList, OwnershipCodeList,
                             EasementCodeList,
                             LandCommitmentCodeList, ParcelCount,
                             nil, nil, False,
                             SwisSBLKey, StateScan, ErrorLog);

        end;  {Parcel, assessment record}

  until Done;

  ParcelTable.Close;
  ParcelTable.Free;
  EndTimeLabel.Caption := 'End Time = ' + TimeToStr(Now);
  CloseFile(RPSFile);
  CloseFile(ErrorLog);
  CloseFile(StateScan);

  FreeTList(PropClassList, SizeOf(CodeRecord));
  FreeTList(HomesteadCodeList, SizeOf(CodeRecord));
  FreeTList(OwnershipCodeList, SizeOf(CodeRecord));
  FreeTList(EasementCodeList, SizeOf(CodeRecord));
  FreeTList(LandCommitmentCodeList, SizeOf(CodeRecord));

end;  {AssessmentButtonClick}

{======================================================================}
Procedure SetVeteransLimits(SwisCodeTable,
                            AssessmentYearControlTable,
                            VeteransLimitTable : TTable;
                            TaxRollYr : String;
                            EqualizationRate : Double;
                            CountyVetLimitSet,
                            VetLimitSet : String);

{FXX04081998-1: Do different county vs. town vet limits for TY and NY in
                one common code.}

var
  EligibleFundsMax : Comp;
  Found, Done, FirstTimeThrough : Boolean;

begin
  EligibleFundsMax := 5000;

    {First set the county limits in the assessment year ctl file.}

  Found := FindKeyOld(VeteransLimitTable, ['Code'],
                      [CountyVetLimitSet]);

  If Found
    then
      with AssessmentYearControlTable do
        begin
          If (RecordCount = 0)
            then
              begin
                Insert;
                FieldByName('TaxRollYr').Text := TaxRollYr;
              end
            else Edit;

          FieldByName('EligibleFundsCntyMax').AsFloat := EligibleFundsMax;
          FieldByName('VeteranCntyMax').AsFloat := VeteransLimitTable.FieldByName('BasicVetLimit').AsFloat;
          FieldByName('CombatVetCntyMax').AsFloat := VeteransLimitTable.FieldByName('CombatVetLimit').AsFloat;
          FieldByName('DisabledVetCntyMax').AsFloat := VeteransLimitTable.FieldByName('DisabledVetLimit').AsFloat;
          FieldByName('VeteransLimitSet').Text := CountyVetLimitSet;

          Post;

        end;  {with AssessmentYearControlTable, VeteransLimitTable do}

  If (Deblank(VetLimitSet) = '')
    then VetLimitSet := CountyVetLimitSet;

  FindKeyOld(VeteransLimitTable, ['Code'], [VetLimitSet]);

    {Fill in the equalization rate and vet limits for all the swis codes.}

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
      then
        with SwisCodeTable do
          try
            Edit;

            FieldByName('EqualizationRate').AsFloat := EqualizationRate;

            FieldByName('VeteransLimitSet').Text := VetLimitSet;

            FieldByName('EligibleFundsTownMax').AsFloat := EligibleFundsMax;
            FieldByName('VeteranTownMax').AsFloat := VeteransLimitTable.FieldByName('BasicVetLimit').AsFloat;
            FieldByName('CombatVetTownMax').AsFloat := VeteransLimitTable.FieldByName('CombatVetLimit').AsFloat;
            FieldByName('DisabledVetTownMax').AsFloat := VeteransLimitTable.FieldByName('DisabledVetLimit').AsFloat;

            FieldByName('VeteranCalcPercent').AsFloat := 15;
            FieldByName('CombatVetCalcPercent').AsFloat := 25;

            Post;
          except
            MessageDlg('Error posting vet limits in Swis code table.',
                       mtError, [mbOK], 0);
          end;

  until Done;

end;  {SetVeteransLimits}

{=====================================================}
Procedure LoadDefinitions(UserDefinitionsTable : TTable;
                          UserDefinitionsList : TList);

{Load the preentered user definitions into a TList and add the definitions
 from the 060 on top.}

var
  FirstTimeThrough, Done : Boolean;
  TempStr, TempFieldName, TempDesc : String;
  RPS060File : TextFile;
  Line : String;
  RecType : String;
  RecordNo : LongInt;
  I, Index : Integer;
  PUserDefinitionsRec : PUserDefinitionsRecord;
  TempPtr : PUserDefinitionsRecord;

begin
    {First load the PAS user definitions.}

  FirstTimeThrough := True;
  Done := False;
  UserDefinitionsTable.First;

  repeat
    Application.ProcessMessages;
    If FirstTimeThrough
      then FirstTimeThrough := False
      else UserDefinitionsTable.Next;

    If UserDefinitionsTable.EOF
      then Done := True;

    If ((not Done) and
        (Deblank(UserDefinitionsTable.FieldByName('UserSpecifiedDescr').Text) <> '') and
        UserDefinitionsTable.FieldByName('Active').AsBoolean)
      then
        begin
          New(PUserDefinitionsRec);

          with PUserDefinitionsRec^, UserDefinitionsTable do
            begin
              Description := FieldByName('UserSpecifiedDescr').Text;

              ResidentialField := (FieldByName('Reserved').Text[1] = 'R');

              TempStr := FieldByName('Reserved').Text[1];

                {Figure out which physical field this corresponds to in the
                 user data file.}

              TempStr := FieldByName('ComponentFieldName').Text;

              If (Pos('Str', TempStr) > 0)
                then
                  begin
                    If (TempStr[5] = '0')
                      then TempFieldName := 'String10Field'
                      else TempFieldName := 'String' + TempStr[4] + 'Field';
                    FieldType := 'S';
                  end;

              If (Pos('Flt', TempStr) > 0)
                then
                  begin
                    If (TempStr[5] = '0')
                      then TempFieldName := 'Float10Field'
                      else TempFieldName := 'Float' + TempStr[4] + 'Field';
                    FieldType := 'F';
                  end;

              If (Pos('Int', TempStr) > 0)
                then
                  begin
                    If (TempStr[5] = '0')
                      then TempFieldName := 'Integer10Field'
                      else TempFieldName := 'Integer' + TempStr[4] + 'Field';
                    FieldType := 'I';
                  end;

              If (Pos('DBCheckBox', TempStr) > 0)
                then
                  begin
                    If (TempStr[12] = '0')
                      then TempFieldName := 'Logical10Field'
                      else TempFieldName := 'Logical' + TempStr[11] + 'Field';
                    FieldType := 'L';
                  end;

              FieldName := TempFieldName;

            end;  {with PUserDefinitionsRec do}

          UserDefinitionsList.Add(PUserDefinitionsRec);

        end;  {If ((not Done) and ...}

  until Done;

    {Now go through the 060 file and load the rec type in the 995 file
     to find the data and where to find it.}

  AssignFile(RPS060File, GlblRPSDataDir + 'RPS060I1');
  Reset(Rps060File);
  Done := False;

  repeat
    Readln(RPS060File, Line);
    Application.ProcessMessages;

    If EOF(RPS060File)
      then Done := True;

    RecType := Copy(Line, 1, 2);

    If (RecType = '50')
      then
        begin
          TempDesc := Copy(Line, 18, 12);
          Index := -1;

            {Find the loaded user definition.}

          For I := 0 to (UserDefinitionsList.Count - 1) do
            If (Take(12, PUserDefinitionsRecord(UserDefinitionsList[I])^.Description) =
                Take(12, TempDesc))
              then Index := I;

          If (Index = -1)
            then MessageDlg('Could not find field ' + TempDesc, mtError, [mbOK], 0)
            else
              with PUserDefinitionsRecord(UserDefinitionsList[Index])^ do
                begin
                  TempPtr := PUserDefinitionsRecord(UserDefinitionsList[Index]);
                  RecType := Copy(Line, 7, 1)[1];
                  StartPos := StrToInt(Copy(Line, 31, 3));
                  FieldLength := StrToInt(Copy(Line, 37, 2));

                end;  {with PUserDefinitionsRecord(UserDefinitionsList[I])^ do}

        end;  {If (RecType = '50')}

  until Done;

  CloseFile(RPS060File);

end;  {LoadDefinitions}

{======================================================================}
Procedure LoadUserCodeTableLists(CodeTable : TTable);

{Load in all the codes and descriptions needed for inventory data conversion.}

var
  Quit : Boolean;

begin
  Quit := False;

  QualityTypeList := TList.Create;
  TrafficTypeList := TList.Create;
  ElevationList := TList.Create;
  PhysicalChangeList := TList.Create;

  LoadCodeList(QualityTypeList, QualityTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(TrafficTypeList, TrafficTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(ElevationList, ElevationTableName, 'MainCode', 'Description', Quit);
  LoadCodeList(PhysicalChangeList, PhysicalChangeTableName, 'MainCode', 'Description', Quit);

end;  {LoadUserCodeTables}

{==================================================================================}
Procedure FreeUserCodeTableLists;

{Free up the code table lists that we have loaded.}

begin
  FreeTList(QualityTypeList, SizeOf(PCodeRecord));
  FreeTList(ElevationList, SizeOf(PCodeRecord));
  FreeTList(PhysicalChangeList, SizeOf(PCodeRecord));
  FreeTList(TrafficTypeList, SizeOf(PCodeRecord));

end;  {FreeUserCodeTableLists}

{=====================================================}
Procedure GetAUserField(    UserDefinitionsRec : UserDefinitionsRecord;
                            Offset : Integer;
                            ReadBuff : RPSImportRec;
                        var _FieldType : Char;
                        var TempStr : String;
                        var TempInt : Integer;
                        var TempFloat : Double;
                        var TempBool : Boolean;
                        var Index : Integer);

begin
  with UserDefinitionsRec do
    begin
      _FieldType := FieldType;

      case FieldType of
        'S' : begin
                TempStr := GetField(FieldLength, (Offset + StartPos - 1) ,
                                    (Offset + StartPos + FieldLength - 1),
                                    ReadBuff);

                If (FieldName[8] = '0')
                  then Index := 10
                  else Index := StrToInt(FieldName[7]);

              end;  {String}

        'I' : begin
                TempStr := GetField(FieldLength, (Offset + StartPos - 1) ,
                                    (Offset + StartPos + FieldLength - 1),
                                    ReadBuff);

                If (FieldName[9] = '0')
                  then Index := 10
                  else Index := StrToInt(FieldName[8]);

                If (Deblank(TempStr) <> '')
                  then
                    try
                      TempInt := StrToInt(Deblank(TempStr));
                    except
                      TempInt := 0;
                      If (Deblank(TempStr) <> '')
                        then MessageDlg('Failure to convert integer field: ' + TempStr, mtError, [mbOK], 0);
                    end
                  else TempInt := 0;

              end;  {Integer}

        'F' : begin
                TempStr := GetField(FieldLength, (Offset + StartPos - 1) ,
                                    (Offset + StartPos + FieldLength - 1),
                                    ReadBuff);

                If (FieldName[7] = '0')
                  then Index := 10
                  else Index := StrToInt(FieldName[6]);

                try
                  TempFloat := StrToFloat(Deblank(TempStr));
                except
                  TempFloat := 0;
                  If (Deblank(TempStr) <> '')
                    then MessageDlg('Failure to convert float field: ' + TempStr, mtError, [mbOK], 0);
                end;

              end;  {Float}

        'L' : begin
                TempStr := GetField(FieldLength, (Offset + StartPos - 1) ,
                                    (Offset + StartPos + FieldLength - 1),
                                    ReadBuff);

                If (FieldName[9] = '0')
                  then Index := 10
                  else Index := StrToInt(FieldName[8]);

                If (TempStr[1] in ['T', 'Y', '1'])
                  then TempBool := True
                  else TempBool := False;

              end;  {Logical}

      end;  {case FieldType of}

    end;  {with UserDefinitionsRec do}

end;  {GetAUserField}

{=====================================================}
Procedure GetUserDataFromRPSRec(    ReadBuff : RPSImportRec;
                                var UserDataRec : UserDataRecord;
                                var ResSiteRec : ResSiteRecord;
                                var ResBldgRec : ResBldgRecord;
                                    _RecType : Char;
                                    RecordNo : LongInt;
                                    UserDefinitionsList : TList);


var
  I, Offset, Index : Integer;
  _FieldName, TempStr : String;
  TempFloat : Double;
  TempInt : Integer;
  TempBool : Boolean;
  TempPtr : PUserDefinitionsRecord;
  _FieldType : Char;

begin
  case _RecType of
    'P' : Offset := 784;
    'R' : Offset := 622;
    'C' : Offset := 778;
  end;  {case _RecType of}

  For I := 0 to (UserDefinitionsList.Count - 1) do
    with PUserDefinitionsRecord(UserDefinitionsList[I])^ do
      If ((RecType = _RecType) and
          (not ResidentialField))
        then
          begin
            GetAUserField(PUserDefinitionsRecord(UserDefinitionsList[I])^,
                          Offset, ReadBuff, _FieldType, TempStr, TempInt,
                          TempFloat, TempBool, Index);

            case FieldType of
              'S' : UserDataRec.StringFields[Index] := TempStr;
              'I' : UserDataRec.IntegerFields[Index] := TempInt;
              'F' : UserDataRec.FloatFields[Index] := TempFloat;
              'L' : UserDataRec.LogicalFields[Index] := TempBool;

            end;  {case FieldType of}

          end;  {If (RecType = _RecType)}

    {Some of the user data gets stored directly into the file.}

  For I := 0 to (UserDefinitionsList.Count - 1) do
    with PUserDefinitionsRecord(UserDefinitionsList[I])^ do
      If ((RecType = 'R') and
          ResidentialField)
        then
          begin
            TempPtr := PUserDefinitionsRecord(UserDefinitionsList[I]);
            GetAUserField(PUserDefinitionsRecord(UserDefinitionsList[I])^,
                          Offset, ReadBuff, _FieldType, TempStr,
                          TempInt, TempFloat, TempBool, Index);

            case FieldType of
              'S' : begin
                       If (Description = 'PHYSICAL CHG')
                         then
                           begin
                             ResSiteRec.PhysicalChangeCode := TempStr;
                             ResSiteRec.PhysicalChangeDesc :=
                                     SetDescription(RecordNo,
                                                    TempStr,
                                                    PhysicalChangeList,
                                                    ErrorLog);
                           end;  {If (Description = 'PHYSICAL CHG')}

                       If (Description = 'TRAFFIC')
                         then
                           begin
                             ResSiteRec.TrafficCode := TempStr;
                             ResSiteRec.TrafficDesc :=
                                     SetDescription(RecordNo,
                                                    TempStr,
                                                    TrafficTypeList,
                                                    ErrorLog);
                           end;  {If (Description = 'TRAFFIC')}

                       If (Description = 'ELEVATION')
                         then
                           begin
                             ResSiteRec.ElevationCode := TempStr;
                             ResSiteRec.ElevationDesc :=
                                     SetDescription(RecordNo,
                                                    TempStr,
                                                    ElevationList,
                                                    ErrorLog);
                           end;  {If (Description = 'Elevation')}

                       If (Description = 'KITCHEN QUAL')
                         then
                           begin
                             ResBldgRec.KitchenQualCode := TempStr;
                             ResBldgRec.KitchenQualDesc :=
                                     SetDescription(RecordNo,
                                                    TempStr,
                                                    QualityTypeList,
                                                    ErrorLog);
                           end;  {If (Description = 'Kitchen Qual')}

                       If (Description = 'BATH QUALITY')
                         then
                           begin
                             ResBldgRec.BathQualityCode := TempStr;
                             ResBldgRec.BathQualityDesc :=
                                     SetDescription(RecordNo,
                                                    TempStr,
                                                    QualityTypeList,
                                                    ErrorLog);
                           end;  {If (Description = 'Bath Quality')}

                         {If year is 0000 then make it blank.}

                      If (Take(4, TempStr) = '0000')
                        then TempStr := '';

                    end;  {String}

              'I' : If (Description = 'NO. OF ROOMS')
                      then ResBldgRec.NumRooms := TempInt;

            end;  {case FieldType of}

          end;  {If ((RecType = 'R') and ...}

end;  {GetUserDataFromRPSRec}

{==================================================================}
Procedure UpdateResBldgTable(ResBldgTable : TTable;
                             ResBldgRec : ResBldgRecord;
                             TaxRollYr : String;
                             SwisSBLKey : String;
                             SiteNumber : Integer);

var
  ResBldgFound : Boolean;

begin
  with ResBldgTable, ResBldgRec do
    begin
      ResBldgFound := FindKeyOld(ResBldgTable,
                                 ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                 [TaxRollYr, SwisSBLKey, IntToStr(SiteNumber)]);

      If ResBldgFound
        then
          try
            Edit;

            If (Deblank(FieldByName('KitchenQualityCode').Text) = '')
              then
                begin
                  FieldByName('KitchenQualityCode').Text := KitchenQualCode;
                  FieldByName('KitchenQualityDesc').Text := KitchenQualDesc;
                end;

            If (Deblank(FieldByName('BathroomQualityCode').Text) = '')
              then
                begin
                  FieldByName('BathroomQualityCode').Text := BathQualityCode;
                  FieldByName('BathroomQualityDesc').Text := BathQualityDesc;
                end;

            If (FieldByName('NumberOfRooms').AsInteger = 0)
              then FieldByName('NumberOfRooms').AsInteger := NumRooms;

            Post;
          except
            SystemSupport(104, ResBldgTable, 'Error posting res bldg table.',
                          'DATACONV', GlblErrorDlgBox);
          end;

    end;  {with ResBldgTable do}

end;  {UpdateResBldgTable}

{=======================================================================}
Procedure UpdateResSiteTable(ResSiteTable : TTable;
                             ResSiteRec : ResSiteRecord;
                             TaxRollYr : String;
                             SwisSBLKey : String;
                             SiteNumber : Integer);

var
  ResSiteFound : Boolean;

begin
  with ResSiteTable, ResSiteRec do
    begin
      ResSiteFound := FindKeyOld(ResSiteTable,
                                 ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                 [TaxRollYr, SwisSBLKey, IntToStr(SiteNumber)]);

      If ResSiteFound
        then
          try
            Edit;

            If (Deblank(FieldByName('PhysicalChangeCode').Text) = '')
              then
                begin
                  FieldByName('PhysicalChangeCode').Text := PhysicalChangeCode;
                  FieldByName('PhysicalChangeDesc').Text := PhysicalChangeDesc;
                end;

            If (Deblank(FieldByName('TrafficCode').Text) = '')
              then
                begin
                  FieldByName('TrafficCode').Text := TrafficCode;
                  FieldByName('TrafficDesc').Text := TrafficDesc;
                end;

            If (Deblank(FieldByName('ElevationCode').Text) = '')
              then
                begin
                  FieldByName('ElevationCode').Text := ElevationCode;
                  FieldByName('ElevationDesc').Text := ElevationDesc;
                end;

            Post;
          except
            SystemSupport(104, ResSiteTable, 'Error posting res Site table.',
                          'DATACONV', GlblErrorDlgBox);
          end;

    end;  {with ResSiteTable do}

end;  {UpdateResSiteTable}

{=====================================================}
Function BlankUserDataRec(UserDataRec : UserDataRecord) : Boolean;

var
  I : Integer;
  FieldFilledIn : Boolean;

begin
  FieldFilledIn := False;

  with UserDataRec do
    begin
      For I := 1 to 10 do
        If (Deblank(StringFields[I]) <> '')
          then FieldFilledIn := True;

      For I := 1 to 10 do
        If (IntegerFields[I] <> 0)
          then FieldFilledIn := True;

      For I := 1 to 10 do
        If (FloatFields[I] <> 0)
          then FieldFilledIn := True;

      For I := 1 to 10 do
        If LogicalFields[I]
          then FieldFilledIn := True;

    end;  {with UserDataRec do}

  Result := not FieldFilledIn;

end;  {BlankUserDataRec}

{=====================================================}
Procedure TDataConvertForm.UserDataButtonClick(Sender: TObject);

var
  TYUserDataTable, UserDefinitionsTable,
  NYUserDataTable,
  TYResBldgTable, TYResSiteTable,
  NYResBldgTable, NYResSiteTable : TTable;
  UserDefinitionList : TList;
  RPS995File : File;
  Quit, Done, LastParcelHadNYRecord : Boolean;
  ThisYearUserDataCount,
  NextYearUserDataCount,
  RecordNo, TotalRecCount : LongInt;
  ReadBuff : RPSImportRec;
  TempInteger, SiteNumber,
  KeyNum, SalesNumber, Count, ReturnCode, I : Integer;
  SwisSBLKey, LastSwisSBLKey : String;
  UserDataRec : UserDataRecord;
  TempFieldName : String;
  Key : String;
  TempFloat : Real;
  ResBldgFound, ResSiteFound, TempLogical : Boolean;
  ResSiteRec : ResSiteRecord;
  ResBldgRec : ResBldgRecord;

begin
  Count := 1;
  RecordNo := 0;
  TotalRecCount := 0;
  ThisYearUserDataCount := 0;
  NextYearUserDataCount := 0;
  LastSwisSBLKey := '';
  SwisSBLKey := '';

  LastParcelHadNYRecord := False;
  AssignFile(RPS995File, GlblRPSDataDir + 'RPS995T1');
  Reset(Rps995File);

  AssignFile(ErrorLog, GlblRPSDataDir + 'ERROR.TXT');
  Rewrite(ErrorLog);

  TYUserDataTable := TTable.Create(nil);
  UserDefinitionsTable := TTable.Create(nil);
  NYUserDataTable := TTable.Create(nil);
  (*NYUserDefinitionsTable := TTable.Create(nil);*)

  TYResBldgTable := TTable.Create(nil);
  TYResSiteTable := TTable.Create(nil);
  NYResBldgTable := TTable.Create(nil);
  NYResSiteTable := TTable.Create(nil);

  OpenTableForProcessingType(TYUserDataTable, UserDataTableName,
                             ThisYear, Quit);
  OpenTableForProcessingType(UserDefinitionsTable, UserDefinitionsTableName,
                             NextYear, Quit);
  OpenTableForProcessingType(NYUserDataTable, UserDataTableName,
                             NextYear, Quit);
  (*OpenTableForProcessingType(NYUserDefinitionsTable, UserDefinitionsTableName,
                             NextYear, Quit);*)
  OpenTableForProcessingType(TYResBldgTable, ResidentialBldgTableName,
                             ThisYear, Quit);
  OpenTableForProcessingType(TYResSiteTable, ResidentialSiteTableName,
                             ThisYear, Quit);
  OpenTableForProcessingType(NYResBldgTable, ResidentialBldgTableName,
                             NextYear, Quit);
  OpenTableForProcessingType(NYResSiteTable, ResidentialSiteTableName,
                             NextYear, Quit);

  TYResSiteTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SITE';
  NYResSiteTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SITE';
  TYResBldgTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SITE';
  TYResBldgTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SITE';

  UserDefinitionList := TList.Create;
  (*NYUserDefinitionList := TList.Create;*)

  LoadDefinitions(UserDefinitionsTable, UserDefinitionList);
(*  LoadDefinitions(NYUserDefinitionsTable, NYUserDefinitionList);*)

  LoadUserCodeTableLists(CodeTable);

    {Now go through the 995 file and check each parcel record for user data.}

  AssignFile(RPS995File, GlblRPSDataDir + 'RPS995T1');
  Reset(Rps995File, RPSImportRecordLength);
  Done := False;

  For I := 1 to 10 do
    with UserDataRec do
      begin
        StringFields[I] := '';
        IntegerFields[I] := 0;
        FloatFields[I] := 0;
        LogicalFields[I] := False;
      end;  {with UserDataRec[I] do}

  repeat
    try
      BlockRead(Rps995File, ReadBuff, Count);
    except
      Done := True;
    end;

    Application.ProcessMessages;

    If EOF(Rps995File)
      then Done := True;

    TotalRecCount := TotalRecCount + 1;
    TotRecLabel.Caption := 'Tot Rec Count = ' + IntToStr(TotalRecCount);

      {Check this year parcel record for user data.}

    If (Done or
        ((ReadBuff[32] = 'P') and  {Parcel rec.}
         (ReadBuff[821] = '1')))    {This year}
      then
        begin
          If ((not LastParcelHadNYRecord) and
              (Deblank(LastSwisSBLKey) <> ''))
            then
              begin

              end;  {If not Done}

          LastParcelHadNYRecord := False;

          LastSwisSBLKey := GetField(26, 1, 26, ReadBuff)

        end;  {Next year parcel, assessment record}

      {Now look in the inventory site records for user data.}

    Key := ReadBuff[33] + ReadBuff[34];

    If (Deblank(Key) = '')
      then KeyNum := -1
      else
        try
          KeyNum := StrToInt(Key);
        except
          KeyNum := - 1;
        end;

    Key := ReadBuff[27] + ReadBuff[28];

    If (Deblank(Key) = '')
      then SalesNumber := 0
      else
        try
          SalesNumber := StrToInt(Key);
        except
          SalesNumber := 0;
        end;

    Key := ReadBuff[30] + ReadBuff[31];

    If (Deblank(Key) = '')
      then SiteNumber := 0
      else
        try
          SiteNumber := StrToInt(Key);
        except
          SiteNumber := 0;
        end;

      {Residential}

    If ((ReadBuff[32] = 'R') and  {Site rec.}
        (KeyNum = 0) and
        (SiteNumber = 1) and
        (SalesNumber = 0))    {Record number = 00 -> base record}
      then
        begin
          SwisSBLKey := GetField(26, 1, 26, ReadBuff);
          with ResSiteRec do
            begin
              PhysicalChangeCode := '';
              PhysicalChangeDesc := '';
              TrafficCode := '';
              TrafficDesc := '';
              ElevationCode := '';
              ElevationDesc := '';
            end;

          with ResBldgRec do
            begin
              KitchenQualCode := '';
              KitchenQualDesc := '';
              BathQualityCode := '';
              BathQualityDesc := '';
              NumRooms := 0;
            end;

          GetUserDataFromRPSRec(ReadBuff, UserDataRec,
                                ResSiteRec, ResBldgRec,
                                'R', TotalRecCount, UserDefinitionList);

             {Insert a ThisYear parcel. Note that the number of
              parcels and assessment records are always the same.}

          If not BlankUserDataRec(UserDataRec)
            then
              begin
                ThisYearUserDataCount := ThisYearUserDataCount + 1;
                TYUserDataLabel.Caption := IntToStr(ThisYearUserDataCount);

                  {Fill in a user definition record based on what user info
                   we have gotten from parcel and inventory records.}

                with TYUserDataTable do
                  begin
                    Insert;

                    For I := 1 to 10 do
                      begin
                        FieldByName('TaxRollYr').Text := GlblThisYear;
                        FieldByName('SwisSBLKey').Text := lastSwisSBLKey;
                        TempFieldName := 'String' + IntToStr(I) + 'Field';
                        FieldByName(TempFieldName).Text := UserDataRec.StringFields[I];

                        TempFieldName := 'Float' + IntToStr(I) + 'Field';
                        FieldByName(TempFieldName).AsFloat := UserDataRec.FloatFields[I];
                        TempFloat := FieldByName(TempFieldName).AsFloat;

                        TempFieldName := 'Logical' + IntToStr(I) + 'Field';
                        FieldByName(TempFieldName).AsBoolean := UserDataRec.LogicalFields[I];
                        TempLogical := FieldByName(TempFieldName).AsBoolean;

                        TempFieldName := 'Integer' + IntToStr(I) + 'Field';
                        FieldByName(TempFieldName).AsInteger := UserDataRec.IntegerFields[I];
                        TempInteger := FieldByName(TempFieldName).AsInteger;

                      end;  {For I := 1 to 10 do}

                    try
                      Post;
                    except
                      SystemSupport(037, TYUserDataTable,
                                    'Error posting User Data record.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                  end;  {with ThisYearUserDataTable do}

                CopyTable_OneRecord(TYUserDataTable, NYUserDataTable,
                                    ['TaxRollYr'], [GlblNextYear]);
                NextYearUserDataCount := NextYearUserDataCount + 1;
                NYUserDataLabel.Caption := IntToStr(NextYearUserDataCount);

              end;  {If not BlankUserDataRec(UserDataRec)}

             {Now load in the res bldg and site table.}

          UpdateResBldgTable(TYResBldgTable, ResBldgRec, GlblThisYear,
                             SwisSBLKey, SiteNumber);
          UpdateResBldgTable(NYResBldgTable, ResBldgRec, GlblNextYear,
                             SwisSBLKey, SiteNumber);
          UpdateResSiteTable(TYResSiteTable, ResSiteRec, GlblThisYear,
                             SwisSBLKey, SiteNumber);
          UpdateResSiteTable(NYResSiteTable, ResSiteRec, GlblNextYear,
                             SwisSBLKey, SiteNumber);

             {Now see if there is any user data in this parcel.}

          For I := 1 to 10 do
            with UserDataRec do
              begin
                StringFields[I] := '';
                IntegerFields[I] := 0;
                FloatFields[I] := 0;
                LogicalFields[I] := False;

              end;  {with UserDataRec[I] do}

        end;  {If ((ReadBuff[32] = 'R') and ...}

  until (Done or ConversionCancelled);

  CloseFile(RPS995File);
  CloseFile(ErrorLog);

  TYUserDataTable.Close;
  UserDefinitionsTable.Close;
  NYUserDataTable.Close;
  (*NYUserDefinitionsTable.Close;*)

  TYUserDataTable.Free;
  UserDefinitionsTable.Free;
  NYUserDataTable.Free;
(*  NYUserDefinitionsTable.Free;*)

  FreeTList(UserDefinitionList, SizeOf(UserDefinitionsRecord));
(*  FreeTList(NYUserDefinitionList, SizeOf(UserDefinitionsRecord));*)

end;  {UserDataButtonClick}

{===================================================}
Function PackTable(    Table : TTable;
                   var ResultMsg : String) : Boolean;

var
  ActionResult : DBIResult;

begin
  ActionResult := dbiPackTable(Table.DBHandle, Table.Handle, nil, szDBASE, True);

  If (ActionResult = DBIERR_NONE)
    then
      begin
        Result := True;
        ResultMsg := 'Table ' + Table.TableName + ' packed successfully.';
      end
    else
      begin
        Result := False;
        ResultMsg := 'Table ' + Table.TableName + ' was not packed successfully: ';

        case ActionResult of
          DBIERR_INVALIDHNDL : ResultMsg := ResultMsg +
                                            'The table handle is not valid.  It probably does not point to a real table.';

          DBIERR_NEEDEXCLACCESS : ResultMsg := ResultMsg +
                                               'The table must be opened exclusive.  Please make sure not one else is using the table.';

          DBIERR_INVALIDPARAM : ResultMsg := ResultMsg +
                                            'The table name or pointer to the table name is NULL.';

          DBIERR_UNKNOWNTBLTYPE : ResultMsg := ResultMsg +
                                               'Unknown table type.';

          DBIERR_NOSUCHTABLE : ResultMsg := ResultMsg +
                                            'The table does not exist.';

        end;  {case ActionResult of}

      end;  {else of If (ActionResult = DBIERR_NONE)}

end;  {PackTable}

{===================================================}
Function ReindexTable(    Table : TTable;
                      var ResultMsg : String) : Boolean;

var
  ActionResult : DBIResult;

begin
  ActionResult := dbiRegenIndexes(Table.Handle);

  If (ActionResult = DBIERR_NONE)
    then
      begin
        Result := True;
        ResultMsg := 'Table ' + Table.TableName + ' was reindexed successfully.';
      end
    else
      begin
        Result := False;
        ResultMsg := 'Table ' + Table.TableName + ' was not reindexed successfully: ';

        case ActionResult of
          DBIERR_INVALIDHNDL : ResultMsg := ResultMsg +
                                            'The table handle is not valid.  It probably does not point to a real table.';

          DBIERR_NEEDEXCLACCESS : ResultMsg := ResultMsg +
                                               'The table must be opened exclusive.  Please make sure not one else is using the table.';

          DBIERR_NOTSUPPORTED : ResultMsg := ResultMsg +
                                             'Can not regenerate the indexes - they are not supported.';

        end;  {case ActionResult of}

      end;  {else of If (ActionResult = DBIERR_NONE)}

end;  {ReindexTable}

{=====================================================}
Procedure TDataConvertForm.SDExButtonClick(Sender: TObject);

var
  BuildAllFiles,  {Is this only one step of building all the files?}
  FirstTimeThrough, Done, Quit : Boolean;
  RPSFile : TextFile;
  RecType : String;
  I, NumTYExRecs,
  NumTYSDRecs,
  NumTYSchoolRecs,
  NumTYSwisRecs,
  NumNYExRecs,
  NumNYSDRecs,
  NumNYSchoolRecs,
  NumNYSwisRecs,
  SwisAS400Offset, EXAS400Offset, SDAS400Offset : Integer;
  RecordNo : LongInt;
  ResultMsg, Line : String;
  TYAssessmentYearControlTable,
  NYAssessmentYearControlTable,
  TYSDTable, TYExTable,
  TYSwisCodeTable, TYSchoolTable,
  NYSDTable, NYExTable,
  NYSwisCodeTable, NYSchoolTable,
  VeteransLimitTable : TTable;
  E : TObject;
  CountyVetLimitSet, VetLimitSet : String;
  EqualizationRate : Double;
  EXCode, SDistCode : String;

begin
  BuildAllFiles := (TComponent(Sender).Name = 'AllButton');
  Done := False;
  Quit := False;

  NumTYEXRecs := 0;
  NumTYSDRecs := 0;
  NumTYSchoolRecs := 0;
  NumTYSwisRecs := 0;
  NumNYEXRecs := 0;
  NumNYSDRecs := 0;
  NumNYSchoolRecs := 0;
  NumNYSwisRecs := 0;
  RecordNo := 0;
  VetLimitSet := ' ';
  EqualizationRate := 0;
  LoadingFromAS400File := AS400CheckBox.Checked;

  If LoadingFromAS400File
    then
      begin
        SwisAS400Offset := 1;
        EXAS400Offset := 2;
      end
    else
      begin
        SwisAS400Offset := 0;
        EXAS400Offset := 0;
      end;

  Open060Dialog.InitialDir := LocationOfFilesEdit.Text;
  If Open060Dialog.Execute
    then
      begin
(*        with PASDataModule do
          For I := 0 to (ComponentCount - 1) do
            If ((Components[I] is TwwTable) and
                (Deblank(TwwTable(Components[I]).TableName) <> ''))
              then TwwTable(Components[I]).Close;

        LocateParcelForm.SwisCodeTable.Close; *)

        AssignFile(RPSFile, Open060Dialog.FileName);
        Reset(RpsFile);

          {If we are building all files, the error log is already open.}

        If not BuildAllFiles
          then
            begin
              AssignFile(ErrorLog, GlblRPSDataDir + 'ERROR.TXT');
              Rewrite(ErrorLog);
            end;

        try
            {Create the tables.}
          TYSDTable := TTable.Create(self);
          TYExTable := TTable.Create(self);
          TYSwisCodeTable := TTable.Create(self);
          TYSchoolTable := TTable.Create(self);
          NYSDTable := TTable.Create(self);
          NYExTable := TTable.Create(self);
          NYSwisCodeTable := TTable.Create(self);
          NYSchoolTable := TTable.Create(self);
          TYAssessmentYearControlTable := TTable.Create(nil);
          NYAssessmentYearControlTable := TTable.Create(nil);
          VeteransLimitTable := TTable.Create(nil);
        except
          MessageDlg('Error creating tables.', mtError, [mbOK], 0);
        end;

(*        TYSwisCodeTable.Exclusive := True;
        TYExTable.Exclusive := True;
        TYSDTable.Exclusive := True;
        TYSchoolTable.Exclusive := True;
        NYSwisCodeTable.Exclusive := True;
        NYExTable.Exclusive := True;
        NYSDTable.Exclusive := True;
        NYSchoolTable.Exclusive := True;*)

            {Now set the name and database for each table.}

        OpenTableForProcessingType(TYSDTable, 'TSDCodeTbl',
                                   ThisYear, Quit);
        OpenTableForProcessingType(TYExTable, 'TExCodeTbl',
                                   ThisYear, Quit);
        OpenTableForProcessingType(TYSwisCodeTable, 'TSwisTbl',
                                   ThisYear, Quit);
        OpenTableForProcessingType(TYSchoolTable, 'TSchoolTbl',
                                   ThisYear, Quit);
        OpenTableForProcessingType(NYSDTable, 'TSDCodeTbl',
                                   NextYear, Quit);
        OpenTableForProcessingType(NYExTable, 'TExCodeTbl',
                                   NextYear, Quit);
        OpenTableForProcessingType(NYSwisCodeTable, 'TSwisTbl',
                                   NextYear, Quit);
        OpenTableForProcessingType(NYSchoolTable, 'TSchoolTbl',
                                   NextYear, Quit);

          {FXX06241998-1: The veterans maximums need to be at the county and swis level.}

        OpenTableForProcessingType(TYAssessmentYearControlTable, AssessmentYearControlTableName,
                                   ThisYear, Quit);
        OpenTableForProcessingType(NYAssessmentYearControlTable, AssessmentYearControlTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(VeteransLimitTable, 'ZVeteransLimitCodes',
                                   ThisYear, Quit);

          {Clear the tables before building them.}
        try
          DeleteTable(TYSwisCodeTable);
          DeleteTable(TYExTable);
          DeleteTable(TYSDTable);
          DeleteTable(TYSchoolTable);
          DeleteTable(NYSwisCodeTable);
          DeleteTable(NYExTable);
          DeleteTable(NYSDTable);
          DeleteTable(NYSchoolTable);
        except
        end;

        TYSDTable.IndexName := 'BYTAXROLLYR_SD';
        TYExTable.IndexName := 'BYTAXROLLYR_EXCODE';
        TYSwisCodeTable.IndexName := 'BYTAXROLLYR_SWISCODE';
        TYSchoolTable.IndexName := 'BYTAXROLLYR_SCHOOLCODE';
        NYSDTable.IndexName := 'BYTAXROLLYR_SD';
        NYExTable.IndexName := 'BYTAXROLLYR_EXCODE';
        NYSwisCodeTable.IndexName := 'BYTAXROLLYR_SWISCODE';
        NYSchoolTable.IndexName := 'BYTAXROLLYR_SCHOOLCODE';
        TYAssessmentYearControlTable.IndexName := 'BYTAXROLLYR';
        NYAssessmentYearControlTable.IndexName := 'BYTAXROLLYR';
        VeteransLimitTable.IndexName := 'BYVETLIMITCODE';

        repeat
          Readln(RPSFile, Line);
          RecordNo := RecordNo + 1;
          Application.ProcessMessages;

          If EOF(RPSFile)
            then Done := True;

          RecType := Copy(Line, 1, 2);

            {CHG10091997-3: Convert diff town and county vet limits.}

          If (RecType = '01')
            then CountyVetLimitSet := Copy(Line, (36 + SwisAS400Offset), 1);

            {Swis codes.}

          If (RecType = '10')
            then
              with TYSwisCodeTable do
                try
                  Insert;
                  FieldByName('TaxRollYr').Text := GlblThisYear;
                  FieldByName('SwisCode').Text := Take(6, Copy(Line, 3, 6));
                  FieldByName('MunicipalityName').Text := Copy(Line, (16 + SwisAS400Offset), 20);
                  FieldByName('Classified').AsBoolean := (Deblank(Copy(Line, (56 + SwisAS400Offset), 1)) <> '');
                  FieldByName('AssessingVillage').AsBoolean := StrToBool_Blank_1(Copy(Line, (57 + SwisAS400Offset), 1));
                  FieldByName('SWISShortCode').Text := Take(2, Copy(Line, 7, 2));
                  FieldByName('SplitVillageCode').Text := Copy(Line, (58 + SwisAS400Offset), 4);
                  FieldByName('MunicipalTypeDesc').Text := Take(30, 'Town\City');  {Default to town}
                  FieldByName('MunicipalTypeCode').Text := Take(2, '1');  {Default to town}

                  try
                    EqualizationRate := StrToFloat(Copy(Line, (63 + SwisAS400Offset), 5)) / 100;
                  except
                    EqualizationRate := 0;
                  end;

                    {CHG06241998-1: Store uniform % of value.}

                  try
                    FieldByName('UniformPercentValue').AsFloat := StrToFloat(Copy(Line, (68 + SwisAS400Offset), 5)) / 100;
                  except
                    FieldByName('UniformPercentValue').AsFloat := 0;
                  end;

                  VetLimitSet := Copy(Line, (62 + SwisAS400Offset), 1);

                  try
                    Post;
                  except
                    MessageDlg('Error posting swis code table.' + #13 +
                               'Line = ' + Line, mtError, [mbOK], 0);
                  end;

                  CopyTable_OneRecord(TYSwisCodeTable, NYSwisCodeTable, ['TaxRollYr'], [GlblNextYear]);

                  NumTYSwisRecs := NumTYSwisRecs + 1;
                  NumNYSwisRecs := NumNYSwisRecs + 1;

                except
                  E := ExceptObject;
                  Writeln(ErrorLog, 'Error in swis code record (' + IntToStr(RecordNo) + ') error = ' +
                          Exception(E).Message);

                end;  {with TYSwisCodeTable do}

            {Exemptions}

          If (RecType = '20')
            then
              with TYExTable do
                try
                  EXCode := Copy(Line, 3, 6);

                  If not FindKeyOld(TYEXTable, ['TaxRollYr', 'EXCode'],
                                    [GlblThisYear, EXCode])
                    then
                      begin
                        Insert;
                        FieldByName('TaxRollYr').Text := GlblThisYear;
                        FieldByName('ExCode').Text := Copy(Line, 3, 6);
                        FieldByName('SW1').Text := Copy(Line, 8, 6);
                        FieldByName('Description').Text := Copy(Line, (16 + EXAS400Offset), 10);
                        FieldByName('CalcMethod').Text := Copy(Line, (26 + EXAS400Offset), 1);
                        FieldByName('AmtVerification').Text := Copy(Line, (27 + EXAS400Offset), 1);
                        If (Deblank(Copy(Line, (28 + EXAS400Offset),6)) <> '' )
                           then
                             try
                               FieldByName('FixedAmount').AsFloat := StrToFloat(Copy(Line,(28 + EXAS400Offset),6));
                             except
                               FieldByName('FixedAmount').AsFloat := 0;
                             end;

                        If (Deblank(Copy(Line,(34 + EXAS400Offset),4)) <> '' )
                          then
                            try
                              FieldByName('FixedPercentage').AsFloat := ((StrToFloat(Copy(Line,(34 + EXAS400Offset),4))/100));
                            except
                              FieldByName('FixedPercentage').AsFloat := 0;
                            end;

                        FieldByName('Section490').AsBoolean := StrToBool(Copy(Line, (38 + EXAS400Offset), 1));
                        FieldByName('AdValorum').AsBoolean := StrToBool(Copy(Line, (39 + EXAS400Offset), 1));
                        FieldByName('ApplySpclAssessmentD').AsBoolean := StrToBool(Copy(Line, (40 + EXAS400Offset), 1));
                        FieldByName('ApplyChap562').AsBoolean := StrToBool(Copy(Line, (41 + EXAS400Offset), 1));
                        FieldByName('ExpirationDateReqd').AsBoolean := StrToBool(Copy(Line, (42 + EXAS400Offset), 1));
                        FieldByName('ResidentialType').Text := DetermineExemptionResidentialType(FieldByName('EXCode').Text);

                        try
                          Post;
                        except
                          MessageDlg('Error posting exemption code table.' + #13 +
                                     'Line = ' + Line, mtError, [mbOK], 0);
                        end;

                        CopyTable_OneRecord(TYExTable, NYExTable, ['TaxRollYr'], [GlblNextYear]);

                        NumTYEXRecs := NumTYExRecs + 1;
                        NumNYEXRecs := NumNYExRecs + 1;

                      end;  {If not FindKeyOld(TYEXTable, ['TaxRollYr', 'EXCode'], ...}

                except
                  E := ExceptObject;
                  Writeln(ErrorLog, 'Error in exemption code record (' + IntToStr(RecordNo) + ') error = ' +
                          Exception(E).Message);
                end;

            {School codes}
            {Line 'A' is the base card.
             Line 'B' is extra swis codes.}

          If (RecType = '30')
            then
              with TYSchoolTable do
                try
                  If (LoadingFromAS400File or
                      (Line[9] = 'A'))
                    then
                      begin
                        Insert;
                        FieldByName('TaxRollYr').Text := GlblThisYear;

                        If LoadingFromAS400File
                          then
                            begin
                              FieldByName('SchoolCode').Text := Copy(Line, 9, 6);
                              FieldByName('SchoolName').Text := Copy(Line, 17, 20);
                              FieldByName('Swis1').Text := Copy(Line, 3, 6);
                            end
                          else
                            begin
                              FieldByName('SchoolCode').Text := Copy(Line, 3, 6);
                              FieldByName('SchoolName').Text := Copy(Line, 22, 20);
                              FieldByName('Swis1').Text := Copy(Line, 16, 6);
                            end;

                        FieldByName('TaxFinanceCode').Text := '';

                        try
                          Post;
                        except
                          MessageDlg('Error posting school code table.' + #13 +
                                     'Line = ' + Line, mtError, [mbOK], 0);
                        end;

                        CopyTable_OneRecord(TYSchoolTable, NYSchoolTable,
                                            ['TaxRollYr'], [GlblNextYear]);

                        NumTYSchoolRecs := NumTYSchoolRecs + 1;
                        NumNYSchoolRecs := NumNYSchoolRecs + 1;

                      end;  {If (Line[9] = 'A')}

                except
                  E := ExceptObject;
                  Writeln(ErrorLog, 'Error in school code record (' + IntToStr(RecordNo) + ') error = ' +
                          Exception(E).Message);
                end;

            {Special districts}
            {CHG04161998-3: Add FireDistrict and AppliesToSchool flag.}

          If (RecType = '40')
            then
              with TYSDTable do
                try
                  SDistCode := Copy(Line, 3, 5);

                  If not FindKeyOld(TYSDTable, ['TaxRollYr', 'SDistCode'],
                                    [GlblThisYear, SDistCode])
                    then
                      begin
                        Insert;

                        If LoadingFromAS400File
                          then
                            begin
                              FieldByName('SDistCode').Text := Copy(Line, 9, 5);
                              FieldByName('SW1').Text := Copy(Line, 3, 6);
                              SDAS400Offset := 2;
                            end
                          else
                            begin
                              FieldByName('SDistCode').Text := Copy(Line, 3, 5);
                              FieldByName('SW1').Text := Copy(Line, 8, 6);
                              SDAS400Offset := 0;
                            end;

                        FieldByName('TaxRollYr').Text := GlblThisYear;
                        FieldByName('Description').Text := Copy(Line, 16, 20);
                        FieldByName('AppliesToSchool').AsBoolean := StrToBool(Copy(Line, (14 + SDAS400Offset), 1));
                        FieldByName('FireDistrict').AsBoolean := StrToBool(Copy(Line, (15+ SDAS400Offset), 1));
                        FieldByName('SDHomeStead').AsBoolean := StrToBool(Copy(Line, (36 + SDAS400Offset), 1));
                        FieldByName('SDRS9').AsBoolean := StrToBool(Copy(Line, (37 + SDAS400Offset), 1));
                        FieldByName('DistrictType').AsString := Copy(Line, (38 + SDAS400Offset), 1);
                        FieldByName('Section490').AsBoolean := StrToBool(Copy(Line, (39 + SDAS400Offset), 1));
                        FieldByName('Chapter562').AsBoolean := StrToBool(Copy(Line, (40 + SDAS400Offset), 1));
                        FieldByName('VillagePurpose').AsString := ' '; {??? not in 060 ,pg 25, but in
                                                                                  apendix rec layout, not
                                                                                  in actual data}

                        If LoadingFromAS400File
                          then SDAS400Offset := 3;

                        FieldByName('ECd1').Text := Copy(Line, (41 + SDAS400Offset), 2);
                        FieldByName('ECFlg1').Text := Take(2,Copy(Line, (43 + SDAS400Offset), 1));
                        FieldByName('ECd2').Text := Copy(Line, (44 + SDAS400Offset), 2);
                        FieldByName('ECFlg2').Text := Take(2,Copy(Line, (46 + SDAS400Offset), 1));
                        FieldByName('ECd3').Text := Copy(Line, (47 + SDAS400Offset), 2);
                        FieldByName('ECFlg3').Text := Take(2,Copy(Line, (49 + SDAS400Offset), 1));
                        FieldByName('ECd4').Text := Copy(Line, (50 + SDAS400Offset), 2);
                        FieldByName('ECFlg4').Text := Take(2,Copy(Line, (52 + SDAS400Offset), 1));
                        FieldByName('ECd5').Text := Copy(Line, (53 + SDAS400Offset), 2);
                        FieldByName('ECFlg5').Text := Take(2,Copy(Line, (55 + SDAS400Offset), 1));
                        FieldByName('ECd6').Text := Copy(Line, (56 + SDAS400Offset), 2);
                        FieldByName('ECFlg6').Text := Take(2,Copy(Line, (58 + SDAS400Offset), 1));
                        FieldByName('ECd7').Text := Copy(Line, (59 + SDAS400Offset), 2);
                        FieldByName('ECFlg7').Text := Take(2,Copy(Line, (61 + SDAS400Offset), 1));

                        try
                          Post;
                          CopyTable_OneRecord(TYSDTable, NYSDTable, ['TaxRollYr'], [GlblNextYear]);
                          NumTYSDRecs := NumTYSDRecs + 1;
                          NumNYSDRecs := NumNYSDRecs + 1;

                        except
                          Cancel;
                          (*MessageDlg('Error posting special district table.' + #13 +
                                     'Line = ' + Line, mtError, [mbOK], 0);*)
                        end;

                      end;  {If not FindKeyOld(TYSDTable, ['TaxRollYr', 'SDistCode'], ...}

                except
                  E := ExceptObject;
                  Writeln(ErrorLog, 'Error in SD code record (' + IntToStr(RecordNo) + ') error = ' +
                          Exception(E).Message);
                end;  {Special districts}

          TYSwisCodeCountLabel.Caption := IntToStr(NumTYSwisRecs);
          TYExCodeCountLabel.Caption := IntToStr(NumTYExRecs);
          TYSDCodeCountLabel.Caption := IntToStr(NumTYSDRecs);
          TYSchoolCodeCountLabel.Caption := IntToStr(NumTYSchoolRecs);
          NYSwisCodeCountLabel.Caption := IntToStr(NumNYSwisRecs);
          NYExCodeCountLabel.Caption := IntToStr(NumNYExRecs);
          NYSDCodeCountLabel.Caption := IntToStr(NumNYSDRecs);
          NYSchoolCodeCountLabel.Caption := IntToStr(NumNYSchoolRecs);

        until Done;

          {FXX04081998-1: Make common proc for setting TY and NY vet limits
                          so that both years get set.}

        SetVeteransLimits(TYSwisCodeTable, TYAssessmentYearControlTable, VeteransLimitTable,
                          GlblThisYear, EqualizationRate, CountyVetLimitSet, VetLimitSet);

        SetVeteransLimits(NYSwisCodeTable, NYAssessmentYearControlTable, VeteransLimitTable,
                          GlblNextYear, EqualizationRate, CountyVetLimitSet, VetLimitSet);

          {Now create system exemptions 50000-50007. The user will not be
           allowed to put them on in the parcel exemption page- this will
           only be done on a parcel which has one exemption and is made wholly
           exempt by changing the roll section to 8.
           Note that it appears that 5000x exemptions do apply to special
           assessment districts.}

        For I := 0 to 7 do
          begin
            EXCode := '5000' + IntToStr(I);

            If not FindKeyOld(TYEXTable, ['TaxRollYr', 'EXCode'],
                              [GlblThisYear, EXCode])
              then
                with TYExTable do
                  try
                    Insert;
                    FieldByName('TaxRollYr').Text := GlblThisYear;
                    FieldByName('ExCode').Text := EXCode;
                    FieldByName('SW1').Text := '';
                    FieldByName('Description').Text := 'WHOLLY EXEMPT';
                    FieldByName('CalcMethod').Text := ' ';  {Special case}
                    FieldByName('AmtVerification').Text := ' ';

                    FieldByName('FixedAmount').AsFloat := 0;
                    FieldByName('FixedPercentage').AsFloat := 0;
                    FieldByName('Section490').AsBoolean := False;

                      {FXX11071997-2: AdValorum is true for 50000 exemptions.}

                    FieldByName('AdValorum').AsBoolean := True;
                    FieldByName('ApplySpclAssessmentD').AsBoolean := True;
                    FieldByName('ApplyChap562').AsBoolean := False;
                    FieldByName('ExpirationDateReqd').AsBoolean := False;
                    FieldByName('ResidentialType').Text := DetermineExemptionResidentialType(FieldByName('EXCode').Text);

                    try
                      Post;
                    except
                      MessageDlg('Error posting exemption code table.' + #13 +
                                 'Line = ' + Line, mtError, [mbOK], 0);
                    end;

                    CopyTable_OneRecord(TYExTable, NYExTable, ['TaxRollYr'], [GlblNextYear]);

                    NumTYEXRecs := NumTYExRecs + 1;
                    NumNYEXRecs := NumNYExRecs + 1;

                  except
                    E := ExceptObject;
                    Writeln(ErrorLog, 'Error in exemption code record (' + IntToStr(RecordNo) + ') error = ' +
                            Exception(E).Message);
                  end;

          end;  {For I := 0 to 7 do}

        CloseFile(RPSFile);

        TYSDTable.Close;
        TYExTable.Close;
        TYSwisCodeTable.Close;
        TYSchoolTable.Close;
        NYSDTable.Close;
        NYExTable.Close;
        NYSwisCodeTable.Close;
        NYSchoolTable.Close;
        TYAssessmentYearControlTable.Close;
        NYAssessmentYearControlTable.Close;
        VeteransLimitTable.Close;

        PackTable(TYSDTable, ResultMsg);
        ReindexTable(TYSDTable, ResultMsg);
        PackTable(TYExTable, ResultMsg);
        ReindexTable(TYExTable, ResultMsg);
        PackTable(TYSwisCodeTable, ResultMsg);
        ReindexTable(TYSwisCodeTable, ResultMsg);
        PackTable(TYSchoolTable, ResultMsg);
        ReindexTable(TYSchoolTable, ResultMsg);

        PackTable(NYSDTable, ResultMsg);
        ReindexTable(NYSDTable, ResultMsg);
        PackTable(NYExTable, ResultMsg);
        ReindexTable(NYExTable, ResultMsg);
        PackTable(NYSwisCodeTable, ResultMsg);
        ReindexTable(NYSwisCodeTable, ResultMsg);
        PackTable(NYSchoolTable, ResultMsg);
        ReindexTable(NYSchoolTable, ResultMsg);

        TYSDTable.Free;
        TYExTable.Free;
        TYSwisCodeTable.Free;
        TYSchoolTable.Free;
        NYSDTable.Free;
        NYExTable.Free;
        NYSwisCodeTable.Free;
        NYSchoolTable.Free;
        TYAssessmentYearControlTable.Free;
        NYAssessmentYearControlTable.Free;
        VeteransLimitTable.Free;

      end;  {If OpenDialog.Execute}

end;  {SDExButtonClick}

{=====================================================}
Procedure TDataConvertForm.InventoryButtonClick(Sender: TObject);

var
  TYCommSiteCount, TYResSiteCount,
  NYCommSiteCount, NYResSiteCount,
  SalesResSiteCount, SalesCommSiteCount,
  TotalRecCount : LongInt;
  ReadBuff : RPSImportRec;
  RPSFile : File;
  BuildAllFiles,  {Is this only one step of building all the files?}
  CopyToNextYear, Quit, Done : Boolean;
  Key : String;
  KeyNum, I, Offset, Count,
  ImprovementNumber, LandNumber,
  StandNumber, BuildingNumber,
  UseNumber, SalesNumber : Integer;
  TempStr : String;

  ThisYearParcelTable,

    {The regular inventory tables.}

  ThisYearResidentialSiteTable,
  ThisYearResidentialBldgTable,
  ThisYearResidentialImprovementsTable,
  ThisYearResidentialLandTable,
  ThisYearResidentialForestTable,
  ThisYearCommercialSiteTable,
  ThisYearCommercialBldgTable,
  ThisYearCommercialImprovementsTable,
  ThisYearCommercialLandTable,
  ThisYearCommercialRentTable,
  ThisYearCommercialIncomeExpenseTable,
  NextYearResidentialSiteTable,
  NextYearResidentialBldgTable,
  NextYearResidentialImprovementsTable,
  NextYearResidentialLandTable,
  NextYearResidentialForestTable,
  NextYearCommercialSiteTable,
  NextYearCommercialBldgTable,
  NextYearCommercialImprovementsTable,
  NextYearCommercialLandTable,
  NextYearCommercialRentTable,
  NextYearCommercialIncomeExpenseTable,

    {The sales inventory tables.}

  SalesResidentialSiteTable,
  SalesResidentialBldgTable,
  SalesResidentialImprovementsTable,
  SalesResidentialLandTable,
  SalesResidentialForestTable,
  SalesCommercialSiteTable,
  SalesCommercialBldgTable,
  SalesCommercialImprovementsTable,
  SalesCommercialLandTable,
  SalesCommercialRentTable,
  SalesCommercialIncomeExpenseTable : TTable;

begin
  BuildAllFiles := (TComponent(Sender).Name = 'AllButton');
  Quit := False;

  If not BuildAllFiles
    then Open995Dialog.Execute;

    {Load in all the codes that we will need into TLists. Note that the TLists
     with the codes are contained completely within UTILCONV.}

  LoadCodeTableLists(CodeTable);

   {Now create the sales inventory tables.}
   {Since all the sales inventory appears first, we will only open up
    the sales inventory files and then when we hit the first non-sales
    inventory, we will close the sales inventory files and open the
    ThisYear and NextYear files.}

  try
    SalesResidentialSiteTable := TTable.Create(nil);
    SalesResidentialBldgTable := TTable.Create(nil);
    SalesResidentialImprovementsTable := TTable.Create(nil);
    SalesResidentialLandTable := TTable.Create(nil);
    SalesResidentialForestTable := TTable.Create(nil);
    SalesCommercialSiteTable := TTable.Create(nil);
    SalesCommercialBldgTable := TTable.Create(nil);
    SalesCommercialImprovementsTable := TTable.Create(nil);
    SalesCommercialLandTable := TTable.Create(nil);
    SalesCommercialRentTable := TTable.Create(nil);
    SalesCommercialIncomeExpenseTable := TTable.Create(nil);
  except
    MessageDlg('Error creating sales inventory tables.', mtError, [mbOK], 0);
  end;

  OpenInventoryTables(SalesResidentialSiteTable,
                      SalesResidentialBldgTable,
                      SalesResidentialImprovementsTable,
                      SalesResidentialLandTable,
                      SalesResidentialForestTable,
                      SalesCommercialSiteTable,
                      SalesCommercialBldgTable,
                      SalesCommercialImprovementsTable,
                      SalesCommercialLandTable,
                      SalesCommercialRentTable,
                      SalesCommercialIncomeExpenseTable,
                      SalesInventory);

     {Create the this year and next year inventory
      tables.}

   try
     ThisYearResidentialSiteTable := TTable.Create(nil);
     ThisYearResidentialBldgTable := TTable.Create(nil);
     ThisYearResidentialImprovementsTable := TTable.Create(nil);
     ThisYearResidentialLandTable := TTable.Create(nil);
     ThisYearResidentialForestTable := TTable.Create(nil);
     ThisYearCommercialSiteTable := TTable.Create(nil);
     ThisYearCommercialBldgTable := TTable.Create(nil);
     ThisYearCommercialImprovementsTable := TTable.Create(nil);
     ThisYearCommercialLandTable := TTable.Create(nil);
     ThisYearCommercialRentTable := TTable.Create(nil);
     ThisYearCommercialIncomeExpenseTable := TTable.Create(nil);
   except
     MessageDlg('Error creating ThisYear inventory tables.', mtError, [mbOK], 0);
   end;

   try
     NextYearResidentialSiteTable := TTable.Create(nil);
     NextYearResidentialBldgTable := TTable.Create(nil);
     NextYearResidentialImprovementsTable := TTable.Create(nil);
     NextYearResidentialLandTable := TTable.Create(nil);
     NextYearResidentialForestTable := TTable.Create(nil);
     NextYearCommercialSiteTable := TTable.Create(nil);
     NextYearCommercialBldgTable := TTable.Create(nil);
     NextYearCommercialImprovementsTable := TTable.Create(nil);
     NextYearCommercialLandTable := TTable.Create(nil);
     NextYearCommercialRentTable := TTable.Create(nil);
     NextYearCommercialIncomeExpenseTable := TTable.Create(nil);
   except
     MessageDlg('Error creating NextYear inventory tables.', mtError, [mbOK], 0);
   end;

     {Open the this year and next year inventory tables.}

   OpenInventoryTables(ThisYearResidentialSiteTable,
                       ThisYearResidentialBldgTable,
                       ThisYearResidentialImprovementsTable,
                       ThisYearResidentialLandTable,
                       ThisYearResidentialForestTable,
                       ThisYearCommercialSiteTable,
                       ThisYearCommercialBldgTable,
                       ThisYearCommercialImprovementsTable,
                       ThisYearCommercialLandTable,
                       ThisYearCommercialRentTable,
                       ThisYearCommercialIncomeExpenseTable,
                       ThisYear);

   OpenInventoryTables(NextYearResidentialSiteTable,
                       NextYearResidentialBldgTable,
                       NextYearResidentialImprovementsTable,
                       NextYearResidentialLandTable,
                       NextYearResidentialForestTable,
                       NextYearCommercialSiteTable,
                       NextYearCommercialBldgTable,
                       NextYearCommercialImprovementsTable,
                       NextYearCommercialLandTable,
                       NextYearCommercialRentTable,
                       NextYearCommercialIncomeExpenseTable,
                       NextYear);

    If ExtractAllData
      then
        try
          ChDir(LocationOfFilesEdit.Text);
          AssignFile(ResidentialSiteExtractFile, ThisYearResidentialSiteTable.TableName + '.csv');
          AssignFile(ResidentialBuildingExtractFile, ThisYearResidentialBldgTable.TableName + '.csv');
          AssignFile(ResidentialImprovementExtractFile, ThisYearResidentialImprovementsTable.TableName + '.csv');
          AssignFile(ResidentialLandExtractFile, ThisYearResidentialLandTable.TableName + '.csv');
          AssignFile(CommercialSiteExtractFile, ThisYearCommercialSiteTable.TableName + '.csv');
          AssignFile(CommercialBuildingExtractFile, ThisYearCommercialBldgTable.TableName + '.csv');
          AssignFile(CommercialImprovementExtractFile, ThisYearCommercialImprovementsTable.TableName + '.csv');
          AssignFile(CommercialLandExtractFile, ThisYearCommercialLandTable.TableName + '.csv');
          AssignFile(CommercialRentExtractFile, ThisYearCommercialRentTable.TableName + '.csv');
          AssignFile(CommercialIncomeExpenseExtractFile, ThisYearCommercialIncomeExpenseTable.TableName + '.csv');

          If FileExists(LocationOfFilesEdit.Text + ThisYearResidentialSiteTable.TableName + '.csv')
            then
              begin
                Append(ResidentialSiteExtractFile);
                Append(ResidentialBuildingExtractFile);
                Append(ResidentialImprovementExtractFile);
                Append(ResidentialLandExtractFile);
                Append(CommercialSiteExtractFile);
                Append(CommercialBuildingExtractFile);
                Append(CommercialImprovementExtractFile);
                Append(CommercialLandExtractFile);
                Append(CommercialRentExtractFile);
                Append(CommercialIncomeExpenseExtractFile);
              end
            else
              begin
                Rewrite(ResidentialSiteExtractFile);
                Rewrite(ResidentialBuildingExtractFile);
                Rewrite(ResidentialImprovementExtractFile);
                Rewrite(ResidentialLandExtractFile);
                Rewrite(CommercialSiteExtractFile);
                Rewrite(CommercialBuildingExtractFile);
                Rewrite(CommercialImprovementExtractFile);
                Rewrite(CommercialLandExtractFile);
                Rewrite(CommercialRentExtractFile);
                Rewrite(CommercialIncomeExpenseExtractFile);
              end;

        except
        end;

    If ExtractAllData
      then
        try
          ChDir(LocationOfFilesEdit.Text);
          AssignFile(SalesResidentialSiteExtractFile, SalesResidentialSiteTable.TableName + '.csv');
          AssignFile(SalesResidentialBuildingExtractFile, SalesResidentialBldgTable.TableName + '.csv');
          AssignFile(SalesResidentialImprovementExtractFile, SalesResidentialImprovementsTable.TableName + '.csv');
          AssignFile(SalesResidentialLandExtractFile, SalesResidentialLandTable.TableName + '.csv');
          AssignFile(SalesCommercialSiteExtractFile, SalesCommercialSiteTable.TableName + '.csv');
          AssignFile(SalesCommercialBuildingExtractFile, SalesCommercialBldgTable.TableName + '.csv');
          AssignFile(SalesCommercialImprovementExtractFile, SalesCommercialImprovementsTable.TableName + '.csv');
          AssignFile(SalesCommercialLandExtractFile, SalesCommercialLandTable.TableName + '.csv');
          AssignFile(SalesCommercialRentExtractFile, SalesCommercialRentTable.TableName + '.csv');
          AssignFile(SalesCommercialIncomeExpenseExtractFile, SalesCommercialIncomeExpenseTable.TableName + '.csv');

          If FileExists(LocationOfFilesEdit.Text + SalesResidentialSiteTable.TableName + '.csv')
            then
              begin
                Append(SalesResidentialSiteExtractFile);
                Append(SalesResidentialBuildingExtractFile);
                Append(SalesResidentialImprovementExtractFile);
                Append(SalesResidentialLandExtractFile);
                Append(SalesCommercialSiteExtractFile);
                Append(SalesCommercialBuildingExtractFile);
                Append(SalesCommercialImprovementExtractFile);
                Append(SalesCommercialLandExtractFile);
                Append(SalesCommercialRentExtractFile);
                Append(SalesCommercialIncomeExpenseExtractFile);
              end
            else
              begin
                Rewrite(SalesResidentialSiteExtractFile);
                Rewrite(SalesResidentialBuildingExtractFile);
                Rewrite(SalesResidentialImprovementExtractFile);
                Rewrite(SalesResidentialLandExtractFile);
                Rewrite(SalesCommercialSiteExtractFile);
                Rewrite(SalesCommercialBuildingExtractFile);
                Rewrite(SalesCommercialImprovementExtractFile);
                Rewrite(SalesCommercialLandExtractFile);
                Rewrite(SalesCommercialRentExtractFile);
                Rewrite(SalesCommercialIncomeExpenseExtractFile);
              end;

        except
        end;

  ThisYearParcelTable := TTable.Create(nil);
  OpenTableForProcessingType(ThisYearParcelTable, ParcelTableName,
                             ThisYear, Quit);

  AssignFile(RPSFile, Open995Dialog.FileName);
  Reset(RpsFile, RPSImportRecordLength);

  AssignFile(ErrorLog, LocationOfFilesEdit.Text + 'ERROR.TXT');
  Rewrite(ErrorLog);

  CopyToNextYear := CreateNYCheckBox.Checked;

  TYResSiteCount := 0;
  TYCommSiteCount := 0;
  NYResSiteCount := 0;
  NYCommSiteCount := 0;
  SalesResSiteCount := 0;
  SalesCommSiteCount := 0;
  Count := 1;

  Done := False;
  TotalRecCount := 0;

  If not BuildAllFiles
    then
      begin
        StartTimeLabel.Caption := 'Start Time = ' + TimeToStr(Now);
        StartTimeLabel.Refresh;
      end;

  repeat
    try
      BlockRead(RpsFile, ReadBuff, Count);
    except
      Done := True;
    end;

    Application.ProcessMessages;
    TotalRecCount := TotalRecCount + 1;
    TotRecLabel.Caption := 'Tot Rec Count = ' + IntToStr(TotalRecCount);

    If (EOF(RpsFile) or
        (TrialRun and
         (TYResSiteCount > 200)))
      then Done := True;

    If not Done
      then
        begin
            {First figure out the the record number. This determines what kind of residential
             or commercial record it is.}

          Key := ReadBuff[33] + ReadBuff[34];

          If (Deblank(Key) = '')
            then KeyNum := -1
            else
              try
                KeyNum := StrToInt(Key);
              except
                KeyNum := - 1;
              end;

            {Now figure out the the sales number. If the sales number is zero, this is regular
             inventory. If it is > 0, then this is sales inventory.}

          Key := ReadBuff[27] + ReadBuff[28];

          If (Deblank(Key) = '')
            then SalesNumber := 0
            else
              try
                SalesNumber := StrToInt(Key);
              except
                SalesNumber := 0;
              end;

            {Residential}

          If ((ReadBuff[32] = 'R') and  {Site rec.}
              (KeyNum = 0))    {Record number = 00 -> base record}
            then
              try
                AddResidentialSite(ThisYearParcelTable,
                                   ThisYearResidentialSiteTable,
                                   NextYearResidentialSiteTable,
                                   SalesResidentialSiteTable,
                                   ReadBuff,
                                   SalesNumber, TotalRecCount,
                                   TYResSiteCount,
                                   NYResSiteCount,
                                   SalesResSiteCount,
                                   CopyToNextYear,
                                   ErrorLog);


                TYResSitesCountLabel.Caption := IntToStr(TYResSiteCount);
                NYResSitesCountLabel.Caption := IntToStr(NYResSiteCount);
                SalesResSiteCountLabel.Caption := IntToStr(SalesResSiteCount);

                AddResidentialBuilding(ThisYearParcelTable,
                                       ThisYearResidentialBldgTable,
                                       NextYearResidentialBldgTable,
                                       SalesResidentialBldgTable, ReadBuff, SalesNumber,
                                       TotalRecCount, CopyToNextYear, ErrorLog);

                  {Now let's look through the 2 Land records stored in the
                   base residential record. Only if the Land number is greater
                   than 0 is this actually an Land record that we need to fill in.}

                Offset := 0;

                For I := 1 to 2 do
                  begin
                    Offset := (I - 1) * 56;

                    TempStr := GetField(2, (183 + Offset), (184 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then LandNumber := 0
                      else LandNumber := StrToInt(TempStr);

                    If (LandNumber > 0)
                      then AddLandRecord(ThisYearParcelTable,
                                         ThisYearResidentialLandTable,
                                         NextYearResidentialLandTable,
                                         SalesResidentialLandTable,
                                         ReadBuff, 183, Offset,
                                         SalesNumber, TotalRecCount,
                                         CopyToNextYear, True, ErrorLog);

                  end;  {For I := 1 to 2 do}

                  {Now let's look through the 4 improvement records stored in the
                   base residential record. Only if the improvement number is greater
                   than 0 is this actually an improvement record that we need to fill in.}

                Offset := 0;

                For I := 1 to 4 do
                  begin
                    Offset := (I - 1) * 51;

                    TempStr := GetField(2, (418 + Offset), (419 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then ImprovementNumber := 0
                      else ImprovementNumber := StrToInt(TempStr);

                    If (ImprovementNumber > 0)
                      then AddImprovementRecord(ThisYearParcelTable,
                                                ThisYearResidentialImprovementsTable,
                                                NextYearResidentialImprovementsTable,
                                                SalesResidentialImprovementsTable,
                                                ReadBuff, 418,
                                                Offset, SalesNumber,
                                                TotalRecCount,
                                                CopyToNextYear, True, ErrorLog);

                  end;  {For I := 1 to 4 do}

              except  {If ((ReadBuff[32] = 'P') and ...}
                Writeln(ErrorLog, 'Error in record ' + IntToStr(TotalRecCount));
              end;

            {If this is an overflow record, then we want to process the land and
             improvements in it, if any.}

          If ((ReadBuff[32] = 'R') and  {Site rec.}
              (KeyNum in [1..92]))    {Record number = 1-92 -> overflow record}
            then
              begin
                  {Now let's look through the 5 Land records stored in the
                   overflow residential record. Only if the Land number is greater
                   than 0 is this actually an Land record that we need to fill in.}

                Offset := 0;

                For I := 1 to 5 do
                  begin
                    Offset := (I - 1) * 56;

                    TempStr := GetField(2, (49 + Offset), (50 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then LandNumber := 0
                      else LandNumber := StrToInt(TempStr);

                    If (LandNumber > 0)
                      then AddLandRecord(ThisYearParcelTable,
                                         ThisYearResidentialLandTable,
                                         NextYearResidentialLandTable,
                                         SalesResidentialLandTable,
                                         ReadBuff, 49, Offset,
                                         SalesNumber, TotalRecCount,
                                         CopyToNextYear, True, ErrorLog);

                  end;  {For I := 1 to 6 do}

                  {Now let's look through the 6 improvement records stored in the
                   overflow residential record. Only if the improvement number is greater
                   than 0 is this actually an improvement record that we need to fill in.}

                Offset := 0;

                For I := 1 to 6 do
                  begin
                    Offset := (I - 1) * 51;

                    TempStr := GetField(2, (329 + Offset), (330 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then ImprovementNumber := 0
                      else ImprovementNumber := StrToInt(TempStr);

                    If (ImprovementNumber > 0)
                      then AddImprovementRecord(ThisYearParcelTable,
                                                ThisYearResidentialImprovementsTable,
                                                NextYearResidentialImprovementsTable,
                                                SalesResidentialImprovementsTable,
                                                ReadBuff, 329,
                                                Offset, SalesNumber,
                                                TotalRecCount,
                                                CopyToNextYear, True, ErrorLog);

                  end;  {For I := 1 to 6 do}

             end;  {If ((ReadBuff[32] = 'R') and ...}

            {If this is an forest record, then we want to process it.}

          If ((ReadBuff[32] = 'R') and  {Site rec.}
              (KeyNum in [94..99]))    {Record number = 94-99 -> forest record}
            then
              begin
                  {Now let's look through the 19 Forest records stored in the
                   overflow residential record. Only if the stand number is greater
                   than 0 is this actually an forest record that we need to fill in.}

                Offset := 0;

                For I := 1 to 19 do
                  begin
                    Offset := (I - 1) * 32;

                    StandNumber := StrToInt(GetField((51 + Offset), 2, (51 + Offset), ReadBuff));

                    If (StandNumber > 0)
                      then AddResidentialForestRecord(ThisYearParcelTable,
                                                      ThisYearResidentialForestTable,
                                                      NextYearResidentialForestTable,
                                                      SalesResidentialForestTable,
                                                      ReadBuff, 51,
                                                      Offset, SalesNumber,
                                                      TotalRecCount,
                                                      CopyToNextYear, ErrorLog);
                  end;  {For I := 1 to 19 do}

             end;  {If ((ReadBuff[32] = 'R') and ...}

            {Commercial site and building records.}


          If ((ReadBuff[32] = 'C') and  {Commercial rec.}
              (KeyNum = 0))    {Record number = 00 -> base record}
            then
              try
                AddCommercialSite(ThisYearParcelTable,
                                  ThisYearCommercialSiteTable,
                                  NextYearCommercialSiteTable,
                                  SalesCommercialSiteTable,
                                  ReadBuff,
                                  SalesNumber, TotalRecCount,
                                  TYCommSiteCount,
                                  NYCommSiteCount,
                                  SalesCommSiteCount,
                                  CopyToNextYear, ErrorLog);

                TYComSitesCountLabel.Caption := IntToStr(TYCommSiteCount);
                NYComSitesCountLabel.Caption := IntToStr(NYCommSiteCount);
                SalesComSiteCountLabel.Caption := IntToStr(SalesCommSiteCount);

                  {Now let's look through the 2 Land records stored in the
                   base commercial record. Only if the Land number is greater
                   than 0 is this actually an Land record that we need to fill in.}

                For I := 1 to 2 do
                  begin
                    Offset := (I - 1) * 56;

                    TempStr := GetField(2, (188 + Offset), (189 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then LandNumber := 0
                      else LandNumber := StrToInt(TempStr);

                    If (LandNumber > 0)
                      then AddLandRecord(ThisYearParcelTable,
                                         ThisYearCommercialLandTable,
                                         NextYearCommercialLandTable,
                                         SalesCommercialLandTable,
                                         ReadBuff, 188, Offset,
                                         SalesNumber, TotalRecCount,
                                         CopyToNextYear, False, ErrorLog);

                  end;  {For I := 1 to 2 do}

                  {Add the 2 commercial buildings in the base record.}

                For I := 1 to 2 do
                  begin
                    Offset := (I - 1) * 71;

                    TempStr := GetField(2, (300 + Offset), (301 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then BuildingNumber := 0
                      else BuildingNumber := StrToInt(TempStr);

                    If (BuildingNumber > 0)
                      then AddCommercialBldgRecord(ThisYearParcelTable,
                                                   ThisYearCommercialBldgTable,
                                                   NextYearCommercialBldgTable,
                                                   SalesCommercialBldgTable,
                                                   ReadBuff, 300, Offset,
                                                   SalesNumber, TotalRecCount,
                                                   CopyToNextYear, ErrorLog);

                  end;  {For I := 1 to 2 do}

                  {Now let's look through the 4 improvement records stored in the
                   base commercial record. Only if the improvement number is greater
                   than 0 is this actually an improvement record that we need to fill in.}

                For I := 1 to 4 do
                  begin
                    Offset := (I - 1) * 51;

                    TempStr := GetField(2, (442 + Offset), (443 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then ImprovementNumber := 0
                      else ImprovementNumber := StrToInt(TempStr);

                    If (ImprovementNumber > 0)
                      then AddImprovementRecord(ThisYearParcelTable,
                                                ThisYearCommercialImprovementsTable,
                                                NextYearCommercialImprovementsTable,
                                                SalesCommercialImprovementsTable,
                                                ReadBuff, 442,
                                                Offset, SalesNumber,
                                                TotalRecCount,
                                                CopyToNextYear, False, ErrorLog);

                  end;  {For I := 1 to 4 do}

                  {Now add the 2 commercial use records stored in the
                   base commercial record. Only if the use number is greater
                   than 0 is this actually an use record that we need to fill in.}

                For I := 1 to 2 do
                  begin
                    Offset := (I - 1) * 66;

                    TempStr := GetField(2, (646 + Offset), (647 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then UseNumber := 0
                      else UseNumber := StrToInt(TempStr);

                    If (UseNumber > 0)
                      then AddCommercialUseRecord(ThisYearParcelTable,
                                                  ThisYearCommercialRentTable,
                                                  NextYearCommercialRentTable,
                                                  SalesCommercialRentTable,
                                                  ReadBuff, 646,
                                                  Offset, SalesNumber,
                                                  TotalRecCount,
                                                  CopyToNextYear, ErrorLog);

                  end;  {For I := 1 to 2 do}

              except  {If ((ReadBuff[32] = 'C') and ...}
                Writeln(ErrorLog, 'Error in record ' + IntToStr(TotalRecCount));
              end;


          {If this is a commercial overflow record, then we want to process the land, buildings,
           improvements, and uses in it, if any.}


          If ((ReadBuff[32] = 'C') and  {Commercial rec.}
              (KeyNum in [1..97]))    {Record number = 1-97 -> commercial overflow record}
            then
              begin
                   {First is 1 land record.}

                 For I := 1 to 1 do
                  begin
                    Offset := (I - 1) * 56;

                    TempStr := GetField(2, (49 + Offset), (50 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then LandNumber := 0
                      else LandNumber := StrToInt(TempStr);

                    If (LandNumber > 0)
                      then AddLandRecord(ThisYearParcelTable,
                                         ThisYearCommercialLandTable,
                                         NextYearCommercialLandTable,
                                         SalesCommercialLandTable,
                                         ReadBuff, 49, Offset,
                                         SalesNumber, TotalRecCount,
                                         CopyToNextYear, False, ErrorLog);

                  end;  {For I := 1 to 1 do}

                  {Add the 2 commercial buildings in the base record.}

                For I := 1 to 2 do
                  begin
                    Offset := (I - 1) * 71;

                    TempStr := GetField(2, (105 + Offset), (106 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then BuildingNumber := 0
                      else BuildingNumber := StrToInt(TempStr);

                    If (BuildingNumber > 0)
                      then AddCommercialBldgRecord(ThisYearParcelTable,
                                                   ThisYearCommercialBldgTable,
                                                   NextYearCommercialBldgTable,
                                                   SalesCommercialBldgTable,
                                                   ReadBuff, 105, Offset,
                                                   SalesNumber, TotalRecCount,
                                                   CopyToNextYear, ErrorLog);

                  end;  {For I := 1 to 2 do}

                  {Now let's look through the 7 improvement records stored in the
                   overflow commercial record. Only if the improvement number is greater
                   than 0 is this actually an improvement record that we need to fill in.}

                For I := 1 to 7 do
                  begin
                    Offset := (I - 1) * 51;

                    TempStr := GetField(2, (247 + Offset), (248 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then ImprovementNumber := 0
                      else ImprovementNumber := StrToInt(TempStr);

                    If (ImprovementNumber > 0)
                      then AddImprovementRecord(ThisYearParcelTable,
                                                ThisYearCommercialImprovementsTable,
                                                NextYearCommercialImprovementsTable,
                                                SalesCommercialImprovementsTable,
                                                ReadBuff, 247,
                                                Offset, SalesNumber,
                                                TotalRecCount,
                                                CopyToNextYear, False, ErrorLog);

                   end;  {For I := 1 to 7 do}

                  {Now add the 3 commercial use records stored in the
                   overflow commercial record. Only if the use number is greater
                   than 0 is this actually an use record that we need to fill in.}

                For I := 1 to 3 do
                  begin
                    Offset := (I - 1) * 66;

                    TempStr := GetField(2, (604 + Offset), (605 + Offset), ReadBuff);

                    If (Deblank(TempStr) = '')
                      then UseNumber := 0
                      else UseNumber := StrToInt(TempStr);

                    If (UseNumber > 0)
                      then AddCommercialUseRecord(ThisYearParcelTable,
                                                  ThisYearCommercialRentTable,
                                                  NextYearCommercialRentTable,
                                                  SalesCommercialRentTable,
                                                  ReadBuff, 604,
                                                  Offset, SalesNumber,
                                                  TotalRecCount,
                                                  CopyToNextYear, ErrorLog);

                  end;  {For I := 1 to 4 do}

             end;  {If ((ReadBuff[32] = 'C') and ...}

          If ((ReadBuff[32] = 'C') and  {Commercial rec.}
              (KeyNum = 99))    {Record number = 99 -> income\expense}
            then AddCommercialIncomeExpenseRecord(ThisYearParcelTable,
                                                  ThisYearCommercialIncomeExpenseTable,
                                                  NextYearCommercialIncomeExpenseTable,
                                                  SalesCommercialIncomeExpenseTable,
                                                  ReadBuff, SalesNumber,
                                                  TotalRecCount,
                                                  CopyToNextYear, ErrorLog);

        end;  {If not Done}

  until (Done or ConversionCancelled);

  If CopyToNextYear
    then
      begin
        CopyTableRange(ThisYearResidentialSiteTable,
                       NextYearResidentialSiteTable,
                       'SwisSBLKey', ['TaxRollYr'], [GlblNextYear]);

        CopyTableRange(ThisYearResidentialBldgTable,
                       NextYearResidentialBldgTable,
                       'SwisSBLKey', ['TaxRollYr'], [GlblNextYear]);

        CopyTableRange(ThisYearResidentialImprovementsTable,
                       NextYearResidentialImprovementsTable,
                       'SwisSBLKey', ['TaxRollYr'], [GlblNextYear]);

        CopyTableRange(ThisYearResidentialLandTable,
                       NextYearResidentialLandTable,
                       'SwisSBLKey', ['TaxRollYr'], [GlblNextYear]);

        CopyTableRange(ThisYearResidentialForestTable,
                       NextYearResidentialForestTable,
                       'SwisSBLKey', ['TaxRollYr'], [GlblNextYear]);

        CopyTableRange(ThisYearCommercialSiteTable,
                       NextYearCommercialSiteTable,
                       'SwisSBLKey', ['TaxRollYr'], [GlblNextYear]);

        CopyTableRange(ThisYearCommercialBldgTable,
                       NextYearCommercialBldgTable,
                       'SwisSBLKey', ['TaxRollYr'], [GlblNextYear]);

        CopyTableRange(ThisYearCommercialImprovementsTable,
                       NextYearCommercialImprovementsTable,
                       'SwisSBLKey', ['TaxRollYr'], [GlblNextYear]);

        CopyTableRange(ThisYearCommercialLandTable,
                       NextYearCommercialLandTable,
                       'SwisSBLKey', ['TaxRollYr'], [GlblNextYear]);

        CopyTableRange(ThisYearCommercialRentTable,
                       NextYearCommercialRentTable,
                       'SwisSBLKey', ['TaxRollYr'], [GlblNextYear]);

        CopyTableRange(ThisYearCommercialIncomeExpenseTable,
                       NextYearCommercialIncomeExpenseTable,
                       'SwisSBLKey', ['TaxRollYr'], [GlblNextYear]);

      end;  {If CopyToNextYear}

    {Close and free the this year and next year inventory tables.}

  CloseInventoryTables(SalesResidentialSiteTable,
                       SalesResidentialBldgTable,
                       SalesResidentialImprovementsTable,
                       SalesResidentialLandTable,
                       SalesResidentialForestTable,
                       SalesCommercialSiteTable,
                       SalesCommercialBldgTable,
                       SalesCommercialImprovementsTable,
                       SalesCommercialLandTable,
                       SalesCommercialRentTable,
                       SalesCommercialIncomeExpenseTable);

    {Free the sales inventory tables.}

  SalesResidentialSiteTable.Free;
  SalesResidentialBldgTable.Free;
  SalesResidentialImprovementsTable.Free;
  SalesResidentialLandTable.Free;
  SalesResidentialForestTable.Free;
  SalesCommercialSiteTable.Free;
  SalesCommercialBldgTable.Free;
  SalesCommercialImprovementsTable.Free;
  SalesCommercialLandTable.Free;
  SalesCommercialIncomeExpenseTable.Free;
  SalesCommercialRentTable.Free;

  CloseInventoryTables(ThisYearResidentialSiteTable,
                       ThisYearResidentialBldgTable,
                       ThisYearResidentialImprovementsTable,
                       ThisYearResidentialLandTable,
                       ThisYearResidentialForestTable,
                       ThisYearCommercialSiteTable,
                       ThisYearCommercialBldgTable,
                       ThisYearCommercialImprovementsTable,
                       ThisYearCommercialLandTable,
                       ThisYearCommercialRentTable,
                       ThisYearCommercialIncomeExpenseTable);

  CloseInventoryTables(NextYearResidentialSiteTable,
                       NextYearResidentialBldgTable,
                       NextYearResidentialImprovementsTable,
                       NextYearResidentialLandTable,
                       NextYearResidentialForestTable,
                       NextYearCommercialSiteTable,
                       NextYearCommercialBldgTable,
                       NextYearCommercialImprovementsTable,
                       NextYearCommercialLandTable,
                       NextYearCommercialRentTable,
                       NextYearCommercialIncomeExpenseTable);

    {Free the ThisYear inventory tables.}

  ThisYearResidentialSiteTable.Free;
  ThisYearResidentialBldgTable.Free;
  ThisYearResidentialImprovementsTable.Free;
  ThisYearResidentialLandTable.Free;
  ThisYearResidentialForestTable.Free;
  ThisYearCommercialSiteTable.Free;
  ThisYearCommercialBldgTable.Free;
  ThisYearCommercialImprovementsTable.Free;
  ThisYearCommercialLandTable.Free;
  ThisYearCommercialIncomeExpenseTable.Free;
  ThisYearCommercialRentTable.Free;

    {Free the NextYear inventory tables.}

  NextYearResidentialSiteTable.Free;
  NextYearResidentialBldgTable.Free;
  NextYearResidentialImprovementsTable.Free;
  NextYearResidentialLandTable.Free;
  NextYearResidentialForestTable.Free;
  NextYearCommercialSiteTable.Free;
  NextYearCommercialBldgTable.Free;
  NextYearCommercialImprovementsTable.Free;
  NextYearCommercialLandTable.Free;
  NextYearCommercialIncomeExpenseTable.Free;
  NextYearCommercialRentTable.Free;

  ThisYearParcelTable.Close;
  ThisYearParcelTable.Free;

  try
    CloseFile(ResidentialSiteExtractFile);
    CloseFile(ResidentialBuildingExtractFile);
    CloseFile(ResidentialImprovementExtractFile);
    CloseFile(ResidentialLandExtractFile);
    CloseFile(CommercialSiteExtractFile);
    CloseFile(CommercialBuildingExtractFile);
    CloseFile(CommercialImprovementExtractFile);
    CloseFile(CommercialLandExtractFile);
    CloseFile(CommercialRentExtractFile);
    CloseFile(CommercialIncomeExpenseExtractFile);

    CloseFile(SalesResidentialSiteExtractFile);
    CloseFile(SalesResidentialBuildingExtractFile);
    CloseFile(SalesResidentialImprovementExtractFile);
    CloseFile(SalesResidentialLandExtractFile);
    CloseFile(SalesCommercialSiteExtractFile);
    CloseFile(SalesCommercialBuildingExtractFile);
    CloseFile(SalesCommercialImprovementExtractFile);
    CloseFile(SalesCommercialLandExtractFile);
    CloseFile(SalesCommercialRentExtractFile);
    CloseFile(SalesCommercialIncomeExpenseExtractFile);
  except
  end;

  EndTimeLabel.Caption := 'End Time = ' + TimeToStr(Now);
  CloseFile(RPSFile);
  CloseFile(ErrorLog);

  If BuildAllFiles
    then MessageDlg('The entire data conversion is complete.', mtInformation, [mbOK], 0)
    else MessageDlg('The inventory conversion is complete.', mtInformation,
                    [mbOK], 0);

end;  {InventoryButtonClick}

{===================================================================}
Procedure TDataConvertForm.SalesButtonClick(Sender: TObject);

var
  Count : Integer;
  SalesRecCount, RecordCount : LongInt;
  ReadBuff : RPSImportRec;
  RPSFile : File;
  Quit, Done : Boolean;
  ErrorLog : TextFile;
  SlsDeedTypeCodeList,
  SlsStatusCodeList,
  SlsVerifyCodeList,
  SlsSalesTypeCodeList,
  SlsArmsLengthCodeList,
  SlsValidityCodeList : TList;
  SalesTable : TTable;
  X,Y : Integer;

begin
  RecordCount := 0;
  Quit := False;
  SalesTable := TTable.Create(nil);
  OpenTableForProcessingType(SalesTable, SalesTableName,
                             GlblProcessingType, Quit);

  SlsDeedTypeCodeList := TList.Create;
  SlsStatusCodeList := TList.Create;
  SlsVerifyCodeList := TList.Create;
  SlsSalesTypeCodeList := TList.Create;
  SlsArmsLengthCodeList := TList.Create;
  SlsValidityCodeList := TList.Create;

  LoadCodeList(SlsDeedTypeCodeList, 'ZSlsDeedTypeTbl', 'MainCode', 'Description', Quit);
  LoadCodeList(SlsStatusCodeList, 'ZSlsStatusTbl', 'MainCode', 'Description', Quit);
  LoadCodeList(SlsVerifyCodeList, 'ZSlsVerifyTbl', 'MainCode', 'Description', Quit);
  LoadCodeList(SlsSalesTypeCodeList, 'ZSlsSalesTypeTbl', 'MainCode', 'Description', Quit);
  LoadCodeList(SlsArmsLengthCodeList, 'ZSlsArmsLengthTbl', 'MainCode', 'Description', Quit);
  LoadCodeList(SlsValidityCodeList, 'ZSlsValidityTbl', 'MainCode', 'Description', Quit);

  If Open995Dialog.Execute
    then AssignFile(RPSFile, Open995Dialog.FileName);
  Reset(RpsFile, RPSImportRecordLength);

  AssignFile(ErrorLog, '\ERROR.TXT');
  Rewrite(ErrorLog);

  SalesRecCount := 0;

  Done := False;
  Count := 1;
  StartTimeLabel.Caption := 'Start Time = ' + TimeToStr(Now);
  StartTimeLabel.Refresh;

  repeat
    try
      BlockRead(RpsFile, ReadBuff, Count);
    except
      Done := True;
    end;

    Application.ProcessMessages;

    RecordCount := RecordCount + 1;
    TotRecLabel.Caption := 'Tot Rec Count = ' + IntToStr(Recordcount);

    If (EOF(RpsFile))
      then Done := True;

    If ((not Done) and
        ((ReadBuff[32] = 'S') and  {Parcel rec.}
        (ReadBuff[821] = '1')))    {always 1 regardless of year}
      then
        begin
          SalesRecCount := SalesRecCount + 1;
          SalesRecCountLabel.Caption := InttoStr(SalesRecCount);

(*          AddSalesRecord(SalesTable, ReadBuff, RecordCount,
                         SlsDeedTypeCodeList, SlsStatusCodeList,
                         SlsVerifyCodeList, SlsSalesTypeCodeList,
                         SlsArmsLengthCodeList, SlsValidityCodeList,
                         ErrorLog);*)

        end;  {If ((ReadBuff[32] = 'S') and }

  until (Done or ConversionCancelled);

  EndTimeLabel.Caption := 'End Time = ' + TimeToStr(Now);

  SalesTable.Close;
  SalesTable.Free;

  CloseFile(ErrorLog);
  CloseFile(RPSFile);

  FreeTList(SlsDeedTypeCodeList, SizeOf(PCodeRecord));
  FreeTList(SlsStatusCodeList, SizeOf(PCodeRecord));
  FreeTList(SlsVerifyCodeList, SizeOf(PCodeRecord));
  FreeTList(SlsSalesTypeCodeList, SizeOf(PCodeRecord));
  FreeTList(SlsArmsLengthCodeList, SizeOf(PCodeRecord));
  FreeTList(SlsValidityCodeList, SizeOf(PCodeRecord));

  MessageDlg('Sales conversion is complete.', mtInformation, [mbOk], 0);

end;  {SalesButtonClick}

{==========================================================}
Procedure TDataConvertForm.AllButtonClick(Sender: TObject);

begin
  Open995Dialog.InitialDir := LocationOfFilesEdit.Text;
  ExtractSalesToFile := ExtractSalesToFileCheckBox.Checked;
  ExtractAllData := AllDataToCSVCheckBox.Checked;

  GlblThisYear := EditThisYear.Text;
  GlblNextYear := EditNextYear.Text;

  If (MessageDlg('The system record must be set up before converting the data.' + #13 +
                 'Has it been set up?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        GlblRPSDataDir := LocationOfFilesEdit.Text;
        AssignFile(ErrorLog, GlblRPSDataDir + 'ERROR.TXT');
        Rewrite(ErrorLog);

        If LoadCodesCheckBox.Checked
          then SDExButtonClick(Sender);

        LocationOfFiles := ReturnPath(Open060Dialog.FileName);

        ParcelFileClick(Sender);

        If ConvertInventoryCheckBox.Checked
          then InventoryButtonClick(Sender);

      end;  {If (MessageDlg('The system ...}

end;  {AllButtonClick}

{==========================================================}
Procedure TDataConvertForm.CancelButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to cancel the conversion?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then ConversionCancelled := True;

end;  {CancelButtonClick}

{=====================================================}
Procedure TDataConvertForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{=====================================================}
Procedure TDataConvertForm.FormClose(    Sender: TObject;
                                     var Action: TCloseAction);
begin
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}




end.