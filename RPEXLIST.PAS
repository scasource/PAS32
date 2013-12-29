unit Rpexlist;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Types, RPDefine, (*Progress,*) TabNotBk, RPTXFilr,
  PASTypes, Zipcopy, ComCtrls;

type
  TExemptionReportForm = class(TForm)
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    ExemptionTable: TTable;
    ExemptionCodeTable: TTable;
    ParcelTable: TTable;
    NextYearAssessmentTable: TTable;
    Label3: TLabel;
    SwisCodeTable: TTable;
    PrintDialog: TPrintDialog;
    SortEXTable: TTable;
    Label13: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    ExemptionLookupTable: TTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    Notebook: TTabbedNotebook;
    AssessmentYearRadioGroup: TRadioGroup;
    TextFiler: TTextFiler;
    ExemptionCodeListBox: TListBox;
    ThisYearAssessmentTable: TTable;
    PrintOrderRadioGroup: TRadioGroup;
    OptionsGroupBox: TGroupBox;
    Label12: TLabel;
    PrintSection1CheckBox: TCheckBox;
    Label10: TLabel;
    PrintSection2CheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    HistoryEdit: TEdit;
    ZipCopyDlg: TZipCopyDlg;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    LoadFromParcelListCheckBox: TCheckBox;
    Label14: TLabel;
    SchoolCodeListBox: TListBox;
    Label9: TLabel;
    SwisCodeListBox: TListBox;
    PrintPercentCheckBox: TCheckBox;
    Label15: TLabel;
    SchoolCodeTable: TTable;
    Label17: TLabel;
    RollSectionListBox: TListBox;
    GenerateRPS220CheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    PrintTaxableValuesCheckBox: TCheckBox;
    Panel3: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel1: TPanel;
    Label5: TLabel;
    cbxTotalsOnly: TCheckBox;
    cbxPrintAccountNumber: TCheckBox;
    HistoryAssessmentTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrintButtonClick(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure AssessmentYearRadioGroupClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    TaxRollYear : String;
    ReportCancelled : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    EnhancedSTARType,
    ProcessingType : Integer;
    GenerateRPS220 : Boolean;
    EXTotalsByCodeList,
    EXTotalsBySwisRollSectionList,
    EXTotalsBySwisSchoolRollSectionList : TList;  {For the 220 extract}
    SelectedExemptionCodes,
    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;

      {As per RPS 220 extract, the full STAR amount is given on an individual
       parcel, but a reduced STAR amount is included in totals if the STAR
       amount would make TV negative.}

    FullBasicSTARAmount,
    FullEnhancedSTARAmount : Comp;

    PrintOrder : Integer;

    RPS220File : TextFile;

    LoadFromParcelList,
    CreateParcelList : Boolean;

    OrigSortFileName : String;
    SelectedRollSections : TStringList;
    PrintToExcel : Boolean;
    ExtractFile : TextFile;
    ExemptionsAlreadyExtracted : Boolean;
    PrintTaxableValues, bTotalsOnly, bPrintAccountNumber : Boolean;
    IVPEnrollmentStatusType : Integer;
    ReportTime : TDateTime;
    PageNum : Integer;
    PreviousSwisCode : String;
    
    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure UpdateExemptionSortTable(     TaxRollYear : String;
                                            ParcelTable,
                                            AssessmentTable,
                                            ExemptionTable,
                                            ExemptionCodeTable : TTable;
                                            EXTotArray : ExemptionTotalsArrayType;
                                            ExemptionCodes,
                                            ExemptionHomesteadCodes,
                                            ResidentialTypes,
                                            CountyExemptionAmounts,
                                            TownExemptionAmounts,
                                            SchoolExemptionAmounts,
                                            VillageExemptionAmounts : TStringList;
                                            BasicSTARAmount,
                                            EnhancedSTARAmount : Comp;
                                            SelectedExemptionCodes : TStringList;
                                            UpdateForParcel : Boolean;  {Put in all ex for parc?}
                                        var Quit : Boolean);    {Insert detail records for all exemptions for this parcel.}

    Procedure AddOne220Rec3Detail(var RPS220File : TextFile;
                                      ExemptionTable : TTable;
                                  var Quit : Boolean);

    Procedure FillSortFiles(var Quit : Boolean);
    {Fill all the sort files needed for the assessor's report.}

    Procedure PrintReportHeader(Sender : TObject;
                                ReportTime : TDateTime;
                                PageNum : Integer;
                                PartName,
                                SubHeader : String;
                                SwisCode : String);
    {Print the overall report header.}


    Procedure PrintExemptionSection1(    Sender : TObject;
                                         ReportTime : TDateTime;
                                     var PageNum : Integer;
                                     var Quit : Boolean);
    {Print the exemptions by SBL. Break by swis.}

    Procedure PrintExemptionTotals(Sender : TObject;
                                   lstTotals : TList;
                                   sHeader : String;
                                   bSingleExemptionTotal : Boolean);

    Procedure PrintExemptionSection2(    Sender : TObject;
                                         ReportTime : TDateTime;
                                     var PageNum : Integer;
                                     var Quit : Boolean);
    {Print the exemptions by EXCode \SBL. Break by swis.}

    Procedure PrintSelectionsPage(    Sender : TObject;
                                      ReportTime : TDateTime;
                                  var PageNum : Integer);
    Procedure FillListBoxes(ProcessingType : Integer;
                            TaxRollYear : String);
  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst,
     PRCLLIST, Prog, EnStarTy, RptDialg, DataAccessUnit, Preview;

const
  NumRec4DetailRecsPerLine = 7;
  LinesAtBottom = 8;

  poParcelID = 0;
  poName = 1;
  poLegalAddress = 2;
  poAccountNumber = 3;

type
  EXTotalsByCodeRecord = record
    EXCode : String;
    CountyEXAmount,
    TownEXAmount,
    SchoolEXAmount,
    VillageEXAmount : Comp;
    Count : LongInt;

  end;  {EXTotalsByCodeRecord = record}

  PEXTotalsByCodeRecord = ^EXTotalsByCodeRecord;

    {FXX06081998-2: Finish up 220 extract.}

  EXTotalsBySwisRollSectionRecord = record
    SwisCode : String;
    RollSection : String;
    AssessedVal,
    CountyEXAmount,
    TownEXAmount,
    SchoolEXAmount,
    VillageEXAmount : Comp;
    Count : LongInt;
  end;  {EXTotalsBySwisRollSectionRecord = record}

  PEXTotalsBySwisRollSectionRecord = ^EXTotalsBySwisRollSectionRecord;


  EXTotalsBySwisSchoolRollSectionRecord = record
    SwisCode : String;
    SchoolCode : String;
    RollSection : String;
    AssessedVal,
    SchoolEXAmount : Comp;
    Count : LongInt;
  end;  {EXTotalsBySwisSchoolRollSection = record}

  PEXTotalsBySwisSchoolRollSectionRecord = ^EXTotalsBySwisSchoolRollSectionRecord;

var
  PrintPercent : Boolean;

{$R *.DFM}

{========================================================}
Procedure TExemptionReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TExemptionReportForm.FillListBoxes(ProcessingType : Integer;
                                             TaxRollYear : String);

var
  Quit : Boolean;

begin
  OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             ProcessingType, Quit);

  FillOneListBox(ExemptionCodeListBox, ExemptionCodeTable,
                 'EXCode', 'Description', 10,
                 True, True, ProcessingType, TaxRollYear);

  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName', 20,
                 True, True, ProcessingType, TaxRollYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable,
                 'SchoolCode', 'SchoolName', 20,
                 True, True, ProcessingType, TaxRollYear);

end;  {LoadEXListBox}

{========================================================}
Procedure TExemptionReportForm.InitializeForm;

begin
  UnitName := 'RPEXLIST';  {mmm}

    {Default assessment year.}

  case GlblProcessingType of
    History : begin
                AssessmentYearRadioGroup.ItemIndex := 2;
                HistoryEdit.Text := GlblHistYear;
                ProcessingType := History;
                TaxRollYear := GlblHistYear;
              end;  {History}

    NextYear : begin
                 AssessmentYearRadioGroup.ItemIndex := 1;
                 ProcessingType := NextYear;
                 TaxRollYear := GlblNextYear;
               end;  {NextYear}

    ThisYear : begin
                 AssessmentYearRadioGroup.ItemIndex := 0;
                 ProcessingType := ThisYear;
                 TaxRollYear := GlblThisYear;
               end;  {This Year}

  end;  {case GlblProcessingType of}

  FillListBoxes(ProcessingType, TaxRollYear);

  OrigSortFileName := SortEXTable.TableName;

    {CHG03282002-6: Allow for roll section selection on sd, ex reports.}

  SelectedRollSections := TStringList.Create;
  SelectItemsInListBox(RollSectionListBox);

end;  {InitializeForm}

{===========================================================================}
Procedure TExemptionReportForm.AssessmentYearRadioGroupClick(Sender: TObject);

{FXX12021998-1: Load the EX box with that year's sd codes.}

var
  ProcessingType : Integer;

begin
  ProcessingType := GlblProcessingType;

    {FXX04251999-2: Allow the user to print from history.}

  case AssessmentYearRadioGroup.ItemIndex of
    0 : begin
          ProcessingType := ThisYear;
          TaxRollYear := GlblThisYear;
          HistoryEdit.Visible := False;
        end;

    1 : begin
          ProcessingType := NextYear;
          TaxRollYear := GlblNextYear;
          HistoryEdit.Visible := False;
        end;

    2 : begin
          ProcessingType := History;
          TaxRollYear := HistoryEdit.Text;
          HistoryEdit.Visible := True;
        end;

  end;  {case AssessmentYearRadioGroup.ItemIndex of}

  If (_Compare(ProcessingType, ThisYear, coEqual) or
      _Compare(ProcessingType, NextYear, coEqual))
    then FillListBoxes(ProcessingType, TaxRollYear);

end;  {AssessmentYearRadioGroupClick}

{===================================================================}
Procedure AddOneEXSortRecord(    SwisSBLKey : String;
                                 TaxRollYear : String;
                                 ParcelTable,
                                 AssessmentTable,
                                 ExemptionTable,
                                 SortEXTable : TTable;
                                 ExemptionCode : String;
                                 CountyAmount,
                                 TownAmount,
                                 SchoolAmount,
                                 VillageAmount : Comp;
                                 PrintToExcel,
                                 ExemptionsAlreadyExtracted,
                                 PrintTaxableValues : Boolean;
                             var ExtractFile : TextFile;
                             var Quit : Boolean);

{Insert one record in the exemption sort table.}

var
  Percent : Double;
  AssessedValue : LongInt;

begin
  Percent := 0;
  with SortEXTable do
    try
      Insert;

      FieldByName('SwisCode').Text := Copy(SwisSBLKey, 1, 6);
      FieldByName('SBLKey').Text := Copy(SwisSBLKey, 7, 20);
      FieldByName('Name').Text := ParcelTable.FieldByName('Name1').Text;
      FieldByName('LegalAddr').AsString := ParcelTable.FieldByName('LegalAddr').AsString;
      FieldByName('LegalAddrNo').AsString := ParcelTable.FieldByName('LegalAddrNo').AsString;

      try
        FieldByName('LegalAddrInt').AsInteger := ParcelTable.FieldByName('LegalAddrInt').AsInteger;
      except
      end;
      
      FieldByName('AccountNo').AsString := ParcelTable.FieldByName('AccountNo').AsString;
      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('PropertyClass').Text := ParcelTable.FieldByName('PropertyClassCode').Text;
      FieldByName('SchoolCode').Text := ParcelTable.FieldByName('SchoolCode').Text;
      FieldByName('ExemptionCode').Text := ExemptionCode;

      TCurrencyField(FieldByName('TotalAssessedVal')).Value :=
          TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).Value;

      TCurrencyField(FieldByName('CountyEXAmount')).Value := CountyAmount;
      TCurrencyField(FieldByName('TownEXAmount')).Value := TownAmount;
      TCurrencyField(FieldByName('SchoolEXAmount')).Value := SchoolAmount;
      TCurrencyField(FieldByName('VillageEXAmount')).Value := VillageAmount;

        {CHG11241999-1: Allow them to select school code(s), print %
                        instead of village amount.}

      If PrintPercent
        then
          begin
            FindKeyOld(ExemptionTable,
                       ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                       [TaxRollYear, SwisSBLKey, ExemptionCode]);

            FieldByName('Percent').AsFloat := ExemptionTable.FieldByName('Percent').AsFloat;
            Percent := ExemptionTable.FieldByName('Percent').AsFloat;
            FieldByName('InitialDate').AsDateTime := ExemptionTable.FieldByName('InitialDate').AsDateTime;

          end;  {If PrintPercent}

      If (PrintToExcel and
          (not ExemptionsAlreadyExtracted))
        then
          begin
            AssessedValue := FieldByName('TotalAssessedVal').AsInteger;

            Write(ExtractFile,
                  FieldByName('SwisCode').Text,
                  FormatExtractField(ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text)),
                  FormatExtractField(FieldByName('ExemptionCode').Text),
                  FormatExtractField(FieldByName('Name').Text),
                  FormatExtractField(FieldByName('LegalAddr').AsString),
                  FormatExtractField(FieldByName('LegalAddrNo').AsString),
                  FormatExtractField(FieldByName('LegalAddrInt').AsString),
                  FormatExtractField(FieldByName('AccountNo').AsString),
                  FormatExtractField(FieldByName('RollSection').Text),
                  FormatExtractField(FieldByName('PropertyClass').Text),
                  FormatExtractField(FieldByName('SchoolCode').Text),
                  FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign,
                                                 FieldByName('TotalAssessedVal').AsFloat)),
                  FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign,
                                                 FieldByName('CountyEXAmount').AsFloat)),
                  FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign,
                                                 FieldByName('TownEXAmount').AsFloat)),
                  FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign,
                                                 FieldByName('SchoolEXAmount').AsFloat)),
                  FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign,
                                                 FieldByName('VillageEXAmount').AsFloat)),
                  FormatExtractField(FormatFloat(CurrencyEditDisplay,
                                                 Percent)));

                    {CHG10122003-1(2.07j2): Allow taxable values to be printed on the exemption report.}

                  If PrintTaxableValues
                    then
                      begin
                        Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                          (AssessedValue - FieldByName('CountyEXAmount').AsInteger))),
                                           FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                          (AssessedValue - FieldByName('TownEXAmount').AsInteger))),
                                           FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                          (AssessedValue - FieldByName('SchoolEXAmount').AsInteger))));

                        If PrintPercent
                          then Writeln(ExtractFile)
                          else Writeln(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                                   (AssessedValue - FieldByName('VillageEXAmount').AsInteger))));

                      end
                    else Writeln(ExtractFile);


          end;  {If (PrintToExcel and ...}

      Post;

    except
      Cancel;
      Quit := True;
      SystemSupport(005, SortEXTable, 'Error inserting excemption sort record.',
                    'RPEXLIST', GlblErrorDlgBox);
    end;

end;  {AddOneEXSortRecord}

{===================================================================}
Function EXTotalsByCodeRecFound(    EXTotalsByCodeList : TList;
                                    ExemptionCode : String;
                                var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (EXTotalsByCodeList.Count - 1) do
    with PEXTotalsByCodeRecord(EXTotalsByCodeList[I])^ do
      If (EXCode = ExemptionCode)
        then
          begin
            Result := True;
            Index := I;
          end;

end;  {EXTotalsRecFound}

{===================================================================}
Function EXTotalsBySwisRollSectionRecFound(    EXTotalsBySwisRollSectionList : TList;
                                               _SwisCode : String;
                                               _RollSection : String;
                                               CombineRollSections : Boolean;
                                           var Index : Integer) : Boolean;

var
  I, SwisCodeLen : Integer;

begin
  Result := False;
  SwisCodeLen := Length(Trim(_SwisCode));

  For I := 0 to (EXTotalsBySwisRollSectionList.Count - 1) do
    with PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[I])^ do
      If ((Take(SwisCodeLen, SwisCode) = Take(SwisCodeLen, _SwisCode)) and
          (CombineRollSections or
           (RollSection = _RollSection)))
        then
          begin
            Result := True;
            Index := I;
          end;

end;  {EXTotalsBySwisRollSectionRecFound}

{===================================================================}
Function EXTotalsBySwisSchoolRollSectionRecFound(    EXTotalsBySwisSchoolRollSectionList : TList;
                                                     _SwisCode,
                                                     _SchoolCode : String;
                                                     _RollSection : String;
                                                 var Index : Integer) : Boolean;

var
  I, SwisCodeLen, SchoolCodeLen : Integer;

begin
  Result := False;

  SwisCodeLen := Length(Trim(_SwisCode));
  SchoolCodeLen := Length(Trim(_SchoolCode));

  For I := 0 to (EXTotalsBySwisSchoolRollSectionList.Count - 1) do
    with PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[I])^ do
      If ((Take(SwisCodeLen, SwisCode) = Take(SwisCodeLen, _SwisCode)) and
          (Take(SchoolCodeLen, SchoolCode) = Take(SchoolCodeLen, _SchoolCode)) and
          (RollSection = _RollSection))
        then
          begin
            Result := True;
            Index := I;
          end;

end;  {EXTotalsBySwisSchoolRollSectionRecFound}

{=======================================================================}
Procedure UpdateEXCodeTotals(EXTotalsByCodeList : TList;
                             _ExCode : String;
                             _CountyEXAmount,
                             _TownEXAmount,
                             _SchoolEXAmount,
                             _VillageEXAmount : Comp);

{FXX06081998-2: Finish the 220 extract.}

var
  Index : Integer;
  PEXTotalsByCodeRec : PEXTotalsByCodeRecord;

begin
    {Update the totals by ex code.}

  If not EXTotalsByCodeRecFound(EXTotalsByCodeList,
                                _EXCode, Index)
    then
      begin
        New(PEXTotalsByCodeRec);

        with PEXTotalsByCodeRec^ do
          begin
            Count := 0;
            CountyEXAmount := 0;
            SchoolEXAmount := 0;
            TownEXAmount := 0;
            VillageEXAmount := 0;
            EXCode := _EXCode;

          end;  {with PEXTotalsByCodeRec^ do}

        EXTotalsByCodeList.Add(PEXTotalsByCodeRec);

        EXTotalsByCodeRecFound(EXTotalsByCodeList, _EXCode, Index);

      end;  {If not EXTotalsRecFound(EXTotalsByCodeList, ExemptionCodes[I], Index)}

  with PEXTotalsByCodeRecord(EXTotalsByCodeList[Index])^ do
    begin
      Count := Count + 1;
      CountyEXAmount := CountyEXAmount + _CountyEXAmount;
      TownEXAmount := TownEXAmount + _TownEXAmount;
      SchoolEXAmount := SchoolEXAmount + _SchoolEXAmount;

        {No village amount unless is an assessing village.}

      (*VillageEXAmount := VillageEXAmount + _VillageEXAmount;*)

    end;  {with PEXTotalsByCodeRecord(EXTotalsByCodeList[Index])^ do}

end;  {UpdateEXCodeTotals}

{=======================================================================}
Procedure UpdateGeneralTotals(EXTotalsBySwisRollSectionList,
                              EXTotalsBySwisSchoolRollSectionList : TList;
                              ParcelTable,
                              AssessmentTable : TTable;
                              _CountyEXAmount,
                              _SchoolEXAmount,
                              _TownEXAmount,
                              _VillageEXAmount : Comp);

{FXX06081998-2: Finish the 220 extract.}

var
  Index : Integer;
  _SwisCode, _SchoolCode : String;
  _RollSection : String;
  _AssessedVal : Comp;
  PEXTotalsBySwisRollSectionRec : PEXTotalsBySwisRollSectionRecord;
  PEXTotalsBySwisSchoolRollSectionRec : PEXTotalsBySwisSchoolRollSectionRecord;

begin
    {Now do the totals by swis\roll section}

  with ParcelTable do
    begin
      _SwisCode := FieldByName('SwisCode').Text;
      _SchoolCode := FieldByName('SchoolCode').Text;
      _RollSection := FieldByName('RollSection').Text;
    end;  {with ParcelTable do}

  _AssessedVal := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

  If not EXTotalsBySwisRollSectionRecFound(EXTotalsBySwisRollSectionList,
                                           _SwisCode, _RollSection, False, Index)
    then
      begin
        New(PEXTotalsBySwisRollSectionRec);

        with PEXTotalsBySwisRollSectionRec^ do
          begin
            Count := 0;
            CountyEXAmount := 0;
            SchoolEXAmount := 0;
            TownEXAmount := 0;
            VillageEXAmount := 0;
            AssessedVal := 0;
            SwisCode := _SwisCode;
            RollSection := _RollSection;

          end;  {with PEXTotalsBySwisRollSectionRec^ do}

        EXTotalsBySwisRollSectionList.Add(PEXTotalsBySwisRollSectionRec);

        EXTotalsBySwisRollSectionRecFound(EXTotalsBySwisRollSectionList,
                                          _SwisCode, _RollSection,
                                          False, Index);

      end;  {If not EXTotalsRecFound(EXTotalsBySwisRollSectionList, ExemptionCodes[I], Index)}

  with PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[Index])^ do
    begin
      Count := Count + 1;
      CountyEXAmount := CountyEXAmount + _CountyEXAmount;
      TownEXAmount := TownEXAmount + _TownEXAmount;
      SchoolEXAmount := SchoolEXAmount + _SchoolEXAmount;

        {No village amount unless is an assessing village.}

      (*VillageEXAmount := VillageEXAmount + _VillageEXAmount;*)

      AssessedVal := AssessedVal + _AssessedVal;

    end;  {with PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[Index])^ do}

    {Now do the totals by swis\School\roll section}

  If not EXTotalsBySwisSchoolRollSectionRecFound(EXTotalsBySwisSchoolRollSectionList,
                                                 _SwisCode, _SchoolCode,
                                                 _RollSection, Index)
    then
      begin
        New(PEXTotalsBySwisSchoolRollSectionRec);

        with PEXTotalsBySwisSchoolRollSectionRec^ do
          begin
            Count := 0;
            SchoolEXAmount := 0;
            AssessedVal := 0;
            SwisCode := _SwisCode;
            SchoolCode := _SchoolCode;
            RollSection := _RollSection;

          end;  {with PEXTotalsBySwisSchoolRollSectionRec^ do}

        EXTotalsBySwisSchoolRollSectionList.Add(PEXTotalsBySwisSchoolRollSectionRec);

        EXTotalsBySwisSchoolRollSectionRecFound(EXTotalsBySwisSchoolRollSectionList,
                                                _SwisCode, _SchoolCode,
                                                _RollSection, Index);

      end;  {If not EXTotalsRecFound(EXTotalsBySwisSchoolRollSectionList, ExemptionCodes[I], Index)}

  with PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[Index])^ do
    begin
      Count := Count + 1;
      SchoolEXAmount := SchoolEXAmount + _SchoolEXAmount;
      AssessedVal := AssessedVal + _AssessedVal;

    end;  {with PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[Index])^ do}

end;  {UpdateTotals}

{===================================================================}
Procedure TExemptionReportForm.UpdateExemptionSortTable(     TaxRollYear : String;
                                                             ParcelTable,
                                                             AssessmentTable,
                                                             ExemptionTable,
                                                             ExemptionCodeTable : TTable;
                                                             EXTotArray : ExemptionTotalsArrayType;
                                                             ExemptionCodes,
                                                             ExemptionHomesteadCodes,
                                                             ResidentialTypes,
                                                             CountyExemptionAmounts,
                                                             TownExemptionAmounts,
                                                             SchoolExemptionAmounts,
                                                             VillageExemptionAmounts : TStringList;
                                                             BasicSTARAmount,
                                                             EnhancedSTARAmount : Comp;
                                                             SelectedExemptionCodes : TStringList;
                                                             UpdateForParcel : Boolean;  {Put in all ex for parc?}
                                                         var Quit : Boolean);

{Insert detail records for all exemptions for this parcel.}

var
  SwisSBLKey : String;
  I : Integer;
  _Found, ProcessThisExemption, ExemptionStored, ParcelHasSenior : Boolean;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);

  If UpdateForParcel
    then
      begin
        If GenerateRPS220
          then UpdateGeneralTotals(EXTotalsBySwisRollSectionList,
                                   EXTotalsBySwisSchoolRollSectionList,
                                   ParcelTable, AssessmentTable,
                                   EXTotArray[EXCounty],
                                   EXTotArray[EXSchool] +
                                   BasicSTARAmount +
                                   EnhancedSTARAmount,
                                   EXTotArray[EXTown],
                                   EXTotArray[EXVillage]);

          {Don't forget STAR exemptions.}

        If (Roundoff(BasicSTARAmount, 0) > 0)
          then
            begin
              ExemptionCodes.Add(BasicSTARExemptionCode);
              CountyExemptionAmounts.Add('0');
              TownExemptionAmounts.Add('0');
              SchoolExemptionAmounts.Add(FloatToStr(BasicSTARAmount));
              VillageExemptionAmounts.Add('0');

            end;  {If (Roundoff(BasicSTARAmount, 0) > 0)}

        If (Roundoff(EnhancedSTARAmount, 0) > 0)
          then
            begin
              ExemptionCodes.Add(EnhancedSTARExemptionCode);
              CountyExemptionAmounts.Add('0');
              TownExemptionAmounts.Add('0');
              SchoolExemptionAmounts.Add(FloatToStr(EnhancedSTARAmount));
              VillageExemptionAmounts.Add('0');

            end;  {If (Roundoff(EnhancedSTARAmount, 0) > 0)}

          {We want to make sure we count all parcels in the swis and
           school totals, so if exemption count is 0, then update with
           0 exemption amounts.}

        ExemptionStored := False;

          {CHG11011999-2: If they just selected 41834 to print, ask if
                          they want seniors too.}

        ParcelHasSenior := False;

        For I := 0 to (ExemptionCodes.Count - 1) do
          If (Take(4, ExemptionCodes[I]) = '4180')
            then ParcelHasSenior := True;

          {FXX12281999-1: Use the enhanced STAR dialog.}

        For I := 0 to (ExemptionCodes.Count - 1) do
          begin
            ProcessThisExemption := False;

              {FXX01222001-1: If they selected enh senior only, was also showing other
                              exemptions too like vets.}

            If ((SelectedExemptionCodes.Count = 1) and
                (SelectedExemptionCodes[0] = EnhancedSTARExemptionCode) and
                (ExemptionCodes[I] = EnhancedSTARExemptionCode))
              then
                begin
                  case EnhancedSTARType of
                    enSeniorSTAROnly :
                          ProcessThisExemption := ((ExemptionCodes.IndexOf(EnhancedSTARExemptionCode) > -1) and
                                                   (not ParcelHasSenior));
                    enWithSeniorandSTARExemption :
                          ProcessThisExemption := ((ExemptionCodes.IndexOf(EnhancedSTARExemptionCode) > -1) and
                                                   ParcelHasSenior);
                    enAnySeniorSTAR :
                          ProcessThisExemption := (ExemptionCodes.IndexOf(EnhancedSTARExemptionCode) > -1);

                  end;  {case EnhancedSTARType of}

                    {CHG07212003-1(2.07g): Don't print enhanced STARs in the IVP program.
                                           Save them up to print out later as a list.}

                  If ProcessThisExemption
                    then
                      begin
                        _Found := FindKeyOld(ExemptionTable, ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                             [TaxRollYear, SwisSBLKey, EnhancedSTARExemptionCode]);

                          {CHG01212004-1(2.08): Add ability to select IVP enrollment status as a choice.}

                        If _Found
                          then
                            case IVPEnrollmentStatusType of
                              ivpEnrolledOnly : ProcessThisExemption := ExemptionTable.FieldByName('AutoRenew').AsBoolean;
                              ivpNotEnrolledOnly : ProcessThisExemption := (not ExemptionTable.FieldByName('AutoRenew').AsBoolean);
                            end;  {case IVPEnrollmentStatusType of}

                      end;  {If (Result and ...}

                end
              else
                 If (SelectedExemptionCodes.IndexOf(ExemptionCodes[I]) <> -1)
                   then ProcessThisExemption := True;

            If ProcessThisExemption
              then
                begin
                  ExemptionStored := True;
                  AddOneEXSortRecord(SwisSBLKey, TaxRollYear,
                                     ParcelTable, AssessmentTable, ExemptionTable,
                                     SortEXTable, ExemptionCodes[I],
                                     StrToFloat(CountyExemptionAmounts[I]),
                                     StrToFloat(TownExemptionAmounts[I]),
                                     StrToFloat(SchoolExemptionAmounts[I]),
                                     StrToFloat(VillageExemptionAmounts[I]),
                                     PrintToExcel, ExemptionsAlreadyExtracted,
                                     PrintTaxableValues, ExtractFile, Quit);

                    {CHG11071997-1: Add support for RPS 220.}
                    {FXX06081998-2: Finish the 220 extract.}

                  If GenerateRPS220
                    then UpdateEXCodeTotals(EXTotalsByCodeList,
                                            ExemptionCodes[I],
                                            StrToFloat(CountyExemptionAmounts[I]),
                                            StrToFloat(TownExemptionAmounts[I]),
                                            StrToFloat(SchoolExemptionAmounts[I]),
                                            StrToFloat(VillageExemptionAmounts[I]));

                end;  {If ProcessThisExemption}

          end;  {For I := 0 to (ExemptionCodes.Count - 1) do}

          {CHG03101999-1: Send info to a list.}

        If (ExemptionStored and CreateParcelList)
          then ParcelListDialog.AddOneParcel(SwisSBLKey);

      end
    else
      with ExemptionTable do
        AddOneEXSortRecord(SwisSBLKey, TaxRollYear,
                           ParcelTable, AssessmentTable, ExemptionTable,
                           SortEXTable, FieldByName('ExemptionCode').Text,
                           FieldByName('CountyAmount').AsFloat,
                           FieldByName('TownAmount').AsFloat,
                           FieldByName('SchoolAmount').AsFloat,
                           FieldByName('VillageAmount').AsFloat,
                           PrintToExcel, ExemptionsAlreadyExtracted,
                           PrintTaxableValues, ExtractFile, Quit);

end;  {UpdateExemptionSortTable}

{===================================================================}
Function RecMeetsCriteria(ExemptionTable,
                          ParcelTable : TTable;
                          SwisSBLKey : String;
                          SelectedSwisCodes,
                          SelectedSchoolCodes,
                          SelectedRollSections : TStringList) : Boolean;

{CHG11071997-1: Add support for showing 5000x exemptions option,
                showing village only exemptions options, and
                generating RPS 220.}
{CHG11241999-1: Allow them to select school code(s), print %
                instead of village amount.}

begin
  Result := True;

    {In the selected swis list?}

  If (SelectedSwisCodes.IndexOf(Copy(SwisSBLKey, 1, 6)) = -1)
    then Result := False;

    {In the selected school list?}

  If (SelectedSchoolCodes.IndexOf(ParcelTable.FieldByName('SchoolCode').Text) = -1)
    then Result := False;

    {Don't include rs 9.}

  If (ParcelTable.FieldByName('RollSection').Text = '9')
    then Result := False;

    {FXX09161998-3: Don't include inactive parcels.}

  If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
    then Result := False;

    {CHG03282002-6: Allow for roll section selection on sd, ex reports.}

  If (Result and
      (SelectedRollSections.IndexOf(ParcelTable.FieldByName('RollSection').Text) = -1))
    then Result := False;

end;  {RecMeetsCriteria}

{===================================================================}
Procedure Add220Rec3Header(var RPS220File : TextFile;
                               TaxRollYear : String;
                               SwisSBLKey : String;
                               ParcelTable,
                               ThisYearAssessmentTable,
                               NextYearAssessmentTable,
                               ExemptionLookupTable,
                               ExemptionCodeTable : TTable;
                           var Quit : Boolean);


{CHG11071997-1: Add support for showing 5000x exemptions option,
                showing village only exemptions options, and
                generating RPS 220.}

var
  LegalAddrNo : String;
  ExemptionTotArray : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  TempNum,
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  AssessmentTable : TTable;
  ThisYearAssessmentFound,
  NextYearAssessmentFound : Boolean;

begin
  ThisYearAssessmentFound := FindKeyOld(ThisYearAssessmentTable,
                                        ['TaxRollYr', 'SwisSBLKey'],
                                        [GlblThisYear, SwisSBLKey]);
  NextYearAssessmentFound := FindKeyOld(NextYearAssessmentTable,
                                        ['TaxRollYr', 'SwisSBLKey'],
                                        [GlblNextYear, SwisSBLKey]);

  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  Write(RPS220File, Take(26, SwisSBLKey));  {1-26: SwisSBL}
  Write(RPS220File, Take(2, '00')); {27-28: Seq num - alway '00'}

  If (TaxRollYear = GlblThisYear)
    then Write(RPS220File, Take(1, '1')) {29: Year}
    else Write(RPS220File, Take(1, '3')); {29: Year}

  Write(RPS220File, Take(2, ParcelTable.FieldByName('CheckDigit').Text)); {30-31: CD}
  Write(RPS220File, Take(3, 'P00')); {32-34: Parcel rec type, rec # 0}
  Write(RPS220File, Take(5, '')); {35-39: Filler}
  Write(RPS220File, Take(1, '3')); {40-40: EX rec type}
  Write(RPS220File, ShiftRightAddBlanks(Take(10, 'EX-DETAIL'))); {41-50: EX rec desc}

  Write(RPS220File, ShiftRightAddZeroes(Take(7, ParcelTable.FieldByName('GridCordEast').Text)));  {51-57}
  Write(RPS220File, ShiftRightAddZeroes(Take(7, ParcelTable.FieldByName('GridCordNorth').Text)));  {58-64}

    {We will conform to present 155\220\995 legal addr number format for
     file comparison purposes. The rule is: If this is a numeric legal
     addr number, put it to the right in nine spaces and leave one
     blank space. Otherwise, put it to the right in 10 spaces.}

  with ParcelTable do
    begin
      LegalAddrNo := Trim(FieldByName('LegalAddrNo').Text);

      If (LegalAddrNo[Length(LegalAddrNo)] in Numbers)
        then LegalAddrNo := ShiftRightAddBlanks(Take(9, LegalAddrNo)) + ' '
        else LegalAddrNo := ShiftRightAddBlanks(Take(10, LegalAddrNo));

      Write(RPS220File, Take(10, LegalAddrNo)); {65-74: Legal Addr No}
      Write(RPS220File, Take(25, FieldByName('LegalAddr').Text)); {75-99: LegalAddr}
      Write(RPS220File, Take(7, FormatRPSNumericString(FieldByName('Frontage').Text, 7, 2))); {100-106: Frontage}
      Write(RPS220File, Take(7, FormatRPSNumericString(FieldByName('Depth').Text, 7, 2))); {107-113: Depth}
      Write(RPS220File, Take(7, FormatRPSNumericString(FieldByName('Acreage').Text, 7, 2))); {114-120: Acres}
      Write(RPS220File, Take(3, FieldByName('PropertyClassCode').Text)); {121-123: Prop class}
      Write(RPS220File, Take(1, FieldByName('OwnershipCode').Text)); {124-124: Ownership code}
      Write(RPS220File, Take(30, FieldByName('Name1').Text)); {125-154: Name}
      Write(RPS220File, Take(6, FieldByName('SchoolCode').Text)); {155-160: School dist}
      Write(RPS220File, Take(1, FieldByName('RollSection').Text)); {161-161: RS}
      Write(RPS220File, Take(1, '')); {162-162: Filler}
      Write(RPS220File, Take(11, FieldByName('AccountNo').Text)); {163-173: Account No}
      Write(RPS220File, Take(1, FieldByName('HomesteadCode').Text)); {174-174: Hstd}

    end;  {with ParcelTable do}

  If ThisYearAssessmentFound
    then
      with ThisYearAssessmentTable do
        begin
          Write(RPS220File, FormatRPSNumericString(FieldByName('LandAssessedVal').Text, 12, 0));  {175-186}
          Write(RPS220File, FormatRPSNumericString(FieldByName('TotalAssessedVal').Text, 12, 0));  {187-198}
        end
    else
      begin
        Write(RPS220File, ConstStr('0', 12));  {175-186}
        Write(RPS220File, ConstStr('0', 12));  {187-198}
      end;

  If NextYearAssessmentFound
    then
      with NextYearAssessmentTable do
        begin
          Write(RPS220File, FormatRPSNumericString(FieldByName('LandAssessedVal').Text, 12, 0));  {199-210}
          Write(RPS220File, FormatRPSNumericString(FieldByName('TotalAssessedVal').Text, 12, 0));  {211-222}
        end
    else
      begin
        Write(RPS220File, ConstStr('0', 12));  {199-210}
        Write(RPS220File, ConstStr('0', 12));  {211-222}
      end;

    {Use the assessment table for the year they are processing in order to
     determine the taxable values.}

  If (TaxRollYear = GlblThisYear)
    then AssessmentTable := ThisYearAssessmentTable
    else AssessmentTable := NextYearAssessmentTable;

  with AssessmentTable do
    begin
      Write(RPS220File, Take(25, ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)))); {223-247: SBL in dash dot format}

         {Now do taxable and senior amounts.}
         {CHG12011997-2: STAR support}
         {FXX02091998-1: Pass the residential type of each exemption.}

      ExemptionTotArray := TotalExemptionsForParcel(TaxRollYear, SwisSBLKey,
                                                    ExemptionLookupTable,
                                                    ExemptionCodeTable,
                                                    ParcelTable.FieldByName('HomesteadCode').Text,
                                                    'A', ExemptionCodes,
                                                    ExemptionHomesteadCodes,
                                                    ResidentialTypes,
                                                    CountyExemptionAmounts,
                                                    TownExemptionAmounts,
                                                    SchoolExemptionAmounts,
                                                    VillageExemptionAmounts,
                                                    BasicSTARAmount,
                                                    EnhancedSTARAmount);

      If ParcelIsActive(ParcelTable)
        then TempNum := FieldByName('TotalAssessedVal').AsFloat - ExemptionTotArray[ExSchool]
        else TempNum := 0;
      Write(RPS220File, FormatRPSNumericString(FloatToStr(TempNum), 12, 0));  {248-259}

      If ParcelIsActive(ParcelTable)
        then TempNum := FieldByName('TotalAssessedVal').AsFloat - ExemptionTotArray[ExTown]
        else TempNum := 0;
      Write(RPS220File, FormatRPSNumericString(FloatToStr(TempNum), 12, 0));  {260-271}

      If ParcelIsActive(ParcelTable)
        then TempNum := FieldByName('TotalAssessedVal').AsFloat - ExemptionTotArray[ExCounty]
        else TempNum := 0;
      Write(RPS220File, FormatRPSNumericString(FloatToStr(TempNum), 12, 0));  {272-283}

      If (ParcelIsActive(ParcelTable) and
          (GlblMunicipalityType = MTVillage))  {Only print village taxable if munic is vill}
        then TempNum := FieldByName('TotalAssessedVal').AsFloat - ExemptionTotArray[ExVillage]
        else TempNum := 0;
      Write(RPS220File, FormatRPSNumericString(FloatToStr(TempNum), 12, 0));  {284-295}

    end;  {with AssessmentTable do}

  Write(RPS220File, ShiftRightAddZeroes(Take(2, ParcelTable.FieldByName('ResidentialPercent').Text))); {296-297: Res %}

    {Total senior exemptions.}
    {FXX02091998-1: Pass the residential type of each exemption.}

  ExemptionTotArray := TotalExemptionsForParcel(TaxRollYear, SwisSBLKey,
                                                ExemptionLookupTable,
                                                ExemptionCodeTable,
                                                ParcelTable.FieldByName('HomesteadCode').Text,
                                                'G', ExemptionCodes,
                                                ExemptionHomesteadCodes,
                                                ResidentialTypes,
                                                CountyExemptionAmounts,
                                                TownExemptionAmounts,
                                                SchoolExemptionAmounts,
                                                VillageExemptionAmounts,
                                                BasicSTARAmount,
                                                EnhancedSTARAmount);

  Write(RPS220File, FormatRPSNumericString(FloatToStr(ExemptionTotArray[ExSchool]), 9, 0));  {298-306}
  Write(RPS220File, FormatRPSNumericString(FloatToStr(ExemptionTotArray[ExCounty]), 9, 0));  {307-315}
  Write(RPS220File, FormatRPSNumericString(FloatToStr(ExemptionTotArray[ExVillage]), 9, 0));  {316-324}

  Write(RPS220File, Copy(TaxRollYear, 3, 2)); {325-326: Roll Year}

    {FXX02091998-3: Need to free up the exemption lists.}

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {Add220Rec3Header}

{===================================================================}
Procedure TExemptionReportForm.AddOne220Rec3Detail(var RPS220File : TextFile;
                                                       ExemptionTable : TTable;
                                                   var Quit : Boolean);

{CHG11071997-1: Add support for showing 5000x exemptions option,
                showing village only exemptions options, and
                generating RPS 220.}

var
  InitialDate, TerminationDate : String;
  EXCode : String;
  Amount : Comp;

begin
  with ExemptionTable do
    begin
      EXCode := FieldByName('ExemptionCode').Text;

      Write(RPS220File, Take(5, EXCode)); {1-5: EX Code}

      {As per RPS 220 extract, the full STAR amount is given on an individual
       parcel, but a reduced STAR amount is included in totals if the STAR
       amount would make TV negative.}

      Amount := FieldByName('Amount').AsFloat;

      If (EXCode = BasicSTARExemptionCode)
        then Amount := FullBasicSTARAmount;

      If (EXCode = EnhancedSTARExemptionCode)
        then Amount := FullEnhancedSTARAmount;

      Write(RPS220File, Take(12, FormatRPSNumericString(FloatToStr(Amount), 12, 0))); {6-17: Amount}
      Write(RPS220File,
            Take(3, FormatRPSNumericString(FloatToStr(FieldByName('Percent').AsFloat / 100), 3, 2))); {18-20: Percent}

      InitialDate := FieldByName('InitialDate').Text;

      If (Deblank(InitialDate) = '')
        then Write(RPS220File, Take(2, '')) {21-22: Initial date}
        else Write(RPS220File, Take(2, Copy(InitialDate, (Length(InitialDate) - 1), 2))); {21-22: Initial date}

      TerminationDate := FieldByName('TerminationDate').Text;

      If (Deblank(TerminationDate) = '')
        then Write(RPS220File, Take(2, '')) {23-24: Termination date}
        else Write(RPS220File, Take(2, Copy(TerminationDate, (Length(TerminationDate) - 1), 2))); {23-24: Term date}

      Write(RPS220File, Take(1, BoolToChar_Blank_1(FieldByName('ApplyToVillage').AsBoolean))); {25-25: Village?}

      Write(RPS220File, Take(1, FieldByName('HomesteadCode').Text)); {26-26: HC}

      Write(RPS220File, Take(2, FormatRPSNumericString(FieldByName('OwnerPercent').Text, 2, 0))); {27-28: Own Percent}

    end;  {with ExemptionTable do}

end;  {AddOne220Rec3Detail}

{===================================================================}
Procedure Add220Rec3Footer(var RPS220File : TextFile;
                               ParcelTable : TTable;
                               SwisSBLKey : String;
                               TaxRollYear : String;
                               NumExemptionsThisParcel : Integer);

{CHG11071997-1: Add support for showing 5000x exemptions option,
                showing village only exemptions options, and
                generating RPS 220.}

var
  I : Integer;

begin
    {Fill in the blank ex spots.}

  For I := (NumExemptionsThisParcel + 1) to 7 do
    Write(RPS220File, ConstStr('0', 22) + Take(4, '') + ConstStr('0', 2));

  Write(RPS220File, Take(79, '')); {523-601: Filler}

  Write(RPS220File, Take(2, '01')); {602-603: Filler}

  Write(RPS220File, Take(26, SwisSBLKey));  {604-629: SwisSBL}
  Write(RPS220File, Take(2, '00')); {630-631: Seq num - alway '00'}

  If (TaxRollYear = GlblThisYear)
    then Write(RPS220File, Take(1, '1')) {632: Year}
    else Write(RPS220File, Take(1, '3')); {632: Year}

  Write(RPS220File, Take(3, 'P00')); {633-635: Parcel rec type, rec # 0}
  Writeln(RPS220File, Take(1, '')); {636-636: Filler}

end;  {Add220Rec3Footer}

{===================================================================}
Procedure SortEXCodeList(EXTotalsByCodeList : TList);

{Sort the exemption code totals list into ex order.}

var
  I, J : Integer;
  TempPtr : PEXTotalsByCodeRecord;
  OldKey, NewKey : String;

begin
  For I := 0 to (EXTotalsByCodeList.Count - 1) do
    begin
      OldKey := PEXTotalsByCodeRecord(EXTotalsByCodeList[I])^.EXCode;

      For J := (I + 1) to (EXTotalsByCodeList.Count - 1) do
        begin
          NewKey := PEXTotalsByCodeRecord(EXTotalsByCodeList[J])^.EXCode;

          If (NewKey < OldKey)
            then
              begin
                TempPtr := EXTotalsByCodeList[I];
                EXTotalsByCodeList[I] := EXTotalsByCodeList[J];
                EXTotalsByCodeList[J] := TempPtr;
                OldKey := NewKey;
              end;  {If (NewKey < OldKey)}

        end;  {For J := (I + 1) to (EXTotalsByCodeList.Count - 1) do}

    end;  {For I := 0 to (EXTotalsByCodeList.Count - 1) do}

end;  {SortEXCodeList}

{===================================================================}
Procedure WriteRec4Footer(var RPS220File : TextFile;
                              RecsThisLine : Integer;
                          var RecNum : Integer);

var
  I : Integer;

begin
    {Fill out any remaining details with zeroes.}

  For I := (RecsThisLine + 1) to NumRec4DetailRecsPerLine do
    Write(RPS220File, ConstStr('0', 71));

  RecNum := RecNum + 1;
  Write(RPS220File, ShiftRightAddBlanks(Take(2, IntToStr(RecNum))));
  Writeln(RPS220File, Take(16, ''));

end;  {WriteRec4Footer}

{===================================================================}
Procedure WriteRec4Totals(var RPS220File : TextFile;
                              SwisCode : String;
                              EXTotalsByCodeList : TList);

{These are the totals by ex-code.}

var
  I, RecNum, RecsThisLine : Integer;
  NewLine : Boolean;

begin
  NewLine := True;
  RecsThisLine := 0;
  RecNum := 0;

  SortEXCodeList(EXTotalsByCodeList);

  For I := 0 to (EXTotalsByCodeList.Count - 1) do
    begin
      If NewLine
        then
          begin
            NewLine := False;

              {Finish out the previous line.}

            If (I > 0)
              then WriteRec4Footer(RPS220File, (RecsThisLine - 1), RecNum);

              {Start the next line.}

            RecsThisLine := 0;
            Write(RPS220File, Take(4, SwisCode) + Take(2, '99'));  {1-6: Munic code}
            Write(RPS220File, Take(33, ''));  {7-39: Filler}
            Write(RPS220File, Take(2, '4 ')); {40-41: Rec type}
            Write(RPS220File, Take(9, 'EXEMPT')); {42-50}

          end;  {If NewLine}

        {Write the detail for this line.}

      RecsThisLine := RecsThisLine + 1;

      with PEXTotalsByCodeRecord(EXTotalsByCodeList[I])^ do
        begin
          Write(RPS220File, Take(5, EXCode));
          Write(RPS220File, FormatRPSNumericString(FloatToStr(CountyEXAmount), 15, 0));
          Write(RPS220File, FormatRPSNumericString(FloatToStr(TownEXAmount), 15, 0));
          Write(RPS220File, FormatRPSNumericString(FloatToStr(SchoolEXAmount), 15, 0));
          Write(RPS220File, FormatRPSNumericString(FloatToStr(VillageEXAmount), 15, 0));
          Write(RPS220File, FormatRPSNumericString(IntToStr(Count), 6, 0));

        end;  {with PEXTotalsByCodeRecord(EXTotalsByCodeList[I])^ do}

        {Do we need to go to a new line? Actually only have 6 real and 1 blank
         entries per line.}

      If (RecsThisLine > (NumRec4DetailRecsPerLine - 1))
        then NewLine := True;

    end;  {For I := 0 to (EXTotalsByCodeList.Count - 1) do}

  WriteRec4Footer(RPS220File, (RecsThisLine - 1), RecNum);

end;  {WriteRec4Totals}

{=======================================================================}
Procedure CombineEXTotalsBySwisRollSection(EXTotalsBySwisRollSectionList,
                                           TempEXTotalsBySwisRollSectionList : TList;
                                           _SwisCode : String;
                                           CombineRollSections : Boolean);

var
  I, Index, SwisCodeLen : Integer;
  _RollSection : String;
  PEXTotalsBySwisRollSectionRec : PEXTotalsBySwisRollSectionRecord;

begin
  SwisCodeLen := Length(Trim(_SwisCode));

  For I := 0 to (EXTotalsBySwisRollSectionList.Count - 1) do
    begin
      _RollSection := PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[I])^.RollSection;

      If ((not CombineRollSections) or
          (CombineRollSections and  {If total rec, don't include rs8 as per RPS220 extract.}
           (_RollSection <> '8')))
        then
          with PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[I])^ do
            begin
                {Is this the right swis code?  If so, either add it to the
                 list if this is a new roll section or update the existing one.}

              If (Take(SwisCodeLen, _SwisCode) = Take(SwisCodeLen, SwisCode))
                then
                  begin
                    If not EXTotalsBySwisRollSectionRecFound(TempEXTotalsBySwisRollSectionList,
                                                             _SwisCode, _RollSection,
                                                             CombineRollSections,
                                                             Index)
                      then
                        begin
                          New(PEXTotalsBySwisRollSectionRec);

                          with PEXTotalsBySwisRollSectionRec^ do
                            begin
                              Count := 0;
                              CountyEXAmount := 0;
                              SchoolEXAmount := 0;
                              TownEXAmount := 0;
                              VillageEXAmount := 0;
                              AssessedVal := 0;
                              SwisCode := _SwisCode;
                              RollSection := _RollSection;

                            end;  {with PEXTotalsBySwisRollSectionRec^ do}

                          TempEXTotalsBySwisRollSectionList.Add(PEXTotalsBySwisRollSectionRec);

                          EXTotalsBySwisRollSectionRecFound(TempEXTotalsBySwisRollSectionList,
                                                            _SwisCode, _RollSection,
                                                            CombineRollSections, Index);

                        end;  {If not EXTotalsRecFound(EXTotalsBySwisRollSectionList, ExemptionCodes[I], Index)}

                    with PEXTotalsBySwisRollSectionRecord(TempEXTotalsBySwisRollSectionList[Index])^ do
                      begin
                        Count := Count +
                                 PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[I])^.Count;
                        CountyEXAmount := CountyEXAmount +
                                 PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[I])^.CountyEXAmount;
                        TownEXAmount := TownEXAmount +
                                 PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[I])^.TownEXAmount;
                        SchoolEXAmount := SchoolEXAmount +
                                 PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[I])^.SchoolEXAmount;

                          {No village amount unless is an assessing village.}

                        (*VillageEXAmount := VillageEXAmount +
                          PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[I])^.VillageEXAmount;*)

                        AssessedVal := AssessedVal +
                           PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[I])^.AssessedVal;

                      end;  {with PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[Index])^ do}

                  end;  {If (Take(SwisCodeLen, _SwisCode) = Take(SwisCodeLen, SwisCode))}

            end;  {with PEXTotalsBySwisRollSectionRecord(EXTotalsBySwisRollSectionList[I])^ do}

    end;  {For I := 0 to (EXTotalsBySwisRollSectionList.Count - 1) do}

end;  {CombineEXTotalsBySwisRollSection}

{===================================================================}
Procedure WriteOneRec1Detail(var RPS220File : TextFile;
                                 TempEXTotalsBySwisRollSectionList : TList;
                                 Index : Integer);

begin
    {Write out this roll section.}

  with PEXTotalsBySwisRollSectionRecord(TempEXTotalsBySwisRollSectionList[Index])^ do
    begin
      Write(RPS220File, ShiftRightAddZeroes(Take(6, IntToStr(Count))));
      Write(RPS220File, ShiftRightAddZeroes(Take(15, FormatFloat(NoDecimalDisplay, AssessedVal))));
      Write(RPS220File, ShiftRightAddZeroes(Take(15, FormatFloat(NoDecimalDisplay, AssessedVal - CountyEXAmount))));
      Write(RPS220File, ShiftRightAddZeroes(Take(15, FormatFloat(NoDecimalDisplay, AssessedVal - TownEXAmount))));
      Write(RPS220File, ShiftRightAddZeroes(Take(15, FormatFloat(NoDecimalDisplay, AssessedVal - SchoolEXAmount))));
      Write(RPS220File, ShiftRightAddZeroes(Take(15, FormatFloat(NoDecimalDisplay, VillageEXAmount))));
    end;  {with PEXTotalsBySwisRollSectionRecord ...}

end;  {WriteOneRec1Detail}

{===================================================================}
Procedure WriteRec1Totals(var RPS220File : TextFile;
                              EXTotalsBySwisRollSectionList : TList;
                              RollSectionList : TStringList;
                              SwisCode : String;
                              TaxRollYear : String;
                              GrandTotals : Boolean);

{Write the totals by swis \ roll section.}

var
  TempEXTotalsBySwisRollSectionList : TList;
  I, Index : Integer;

begin
  TempEXTotalsBySwisRollSectionList := TList.Create;

  CombineEXTotalsBySwisRollSection(EXTotalsBySwisRollSectionList,
                                   TempEXTotalsBySwisRollSectionList,
                                   SwisCode, False);

  If GrandTotals
    then Write(RPS220File, SwisCode + '99')
    else Write(RPS220File, SwisCode);

  Write(RPS220File, Take(33, ''));  {Filler}
  Write(RPS220File, Take(2, '1'));  {Rec type}
  Write(RPS220File, Take(9, 'TAXABLE'));  {Description}

    {Actually only do rs 1->8}

  For I := 0 to 5 do
    If EXTotalsBySwisRollSectionRecFound(TempEXTotalsBySwisRollSectionList,
                                         SwisCode, RollSectionList[I], False, Index)
      then WriteOneRec1Detail(RPS220File, TempEXTotalsBySwisRollSectionList, Index)
      else Write(RPS220File, ConstStr('0', 81));  {Zero filled blanks if no entries for rs.}

    {Now write out an overall total for all roll sections.}

  FreeTList(TempEXTotalsBySwisRollSectionList, SizeOf(EXTotalsBySwisRollSectionRecord));

  TempEXTotalsBySwisRollSectionList := TList.Create;

  CombineEXTotalsBySwisRollSection(EXTotalsBySwisRollSectionList,
                                   TempEXTotalsBySwisRollSectionList,
                                   SwisCode, True);

    {There should only be one of these totals records.}

  WriteOneRec1Detail(RPS220File, TempEXTotalsBySwisRollSectionList, 0);

  FreeTList(TempEXTotalsBySwisRollSectionList, SizeOf(EXTotalsBySwisRollSectionRecord));

    {Footer}

  Write(RPS220File, Take(4, TaxRollYear));
  Writeln(RPS220File, Take(15, 'PAS'));

end;  {WriteRec1Totals}

{=======================================================================}
Procedure CombineEXTotalsBySwisSchoolRollSection(EXTotalsBySwisSchoolRollSectionList,
                                                 TempEXTotalsBySwisSchoolRollSectionList : TList;
                                                 _SwisCode : String;
                                                 CombineSchoolCodes : Boolean);  {Sep entries for each school code?}

var
  I, Index, SwisCodeLen : Integer;
  _RollSection : String;
  _SchoolCode : String;
  PEXTotalsBySwisSchoolRollSectionRec : PEXTotalsBySwisSchoolRollSectionRecord;

begin
  SwisCodeLen := Length(Trim(_SwisCode));

  For I := 0 to (EXTotalsBySwisSchoolRollSectionList.Count - 1) do
    begin
      _RollSection := PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[I])^.RollSection;
      _SchoolCode := PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[I])^.SchoolCode;

        {If this is a total record for the swis, then blank out school code -
         we don't want to compare on school code.}

      If CombineSchoolCodes
        then _SchoolCode := '';

        {Is this the right swis code?  If so, either add it to the
         list if this is a new roll section or update the existing one.}

      If (Take(SwisCodeLen, _SwisCode) =
          Take(SwisCodeLen, PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[I])^.SwisCode))
        then
          begin
            If not EXTotalsBySwisSchoolRollSectionRecFound(TempEXTotalsBySwisSchoolRollSectionList,
                                                           _SwisCode,
                                                           _SchoolCode,
                                                           _RollSection,
                                                           Index)
              then
                begin
                  New(PEXTotalsBySwisSchoolRollSectionRec);

                  with PEXTotalsBySwisSchoolRollSectionRec^ do
                    begin
                      Count := 0;
                      SchoolEXAmount := 0;
                      AssessedVal := 0;
                      SwisCode := _SwisCode;
                      SchoolCode := _SchoolCode;
                      RollSection := _RollSection;

                    end;  {with PEXTotalsBySwisSchoolRollSectionRec^ do}

                  TempEXTotalsBySwisSchoolRollSectionList.Add(PEXTotalsBySwisSchoolRollSectionRec);

                  EXTotalsBySwisSchoolRollSectionRecFound(TempEXTotalsBySwisSchoolRollSectionList,
                                                          _SwisCode,
                                                          _SchoolCode,
                                                          _RollSection, Index);

                end;  {If not EXTotalsRecFound(EXTotalsBySwisSchoolRollSectionList, ExemptionCodes[I], Index)}

            with PEXTotalsBySwisSchoolRollSectionRecord(TempEXTotalsBySwisSchoolRollSectionList[Index])^ do
              begin
                Count := Count +
                         PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[I])^.Count;
                SchoolEXAmount := SchoolEXAmount +
                    PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[I])^.SchoolEXAmount;
                AssessedVal := AssessedVal +
                    PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[I])^.AssessedVal;

              end;  {with PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[Index])^ do}

          end;  {If (Take(SwisCodeLen, _SwisCode) = Take(SwisCodeLen, SwisCode))}

    end;  {with PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[I])^ do}

end;  {CombineEXTotalsBySwisSchoolRollSection}

{===================================================================}
Procedure GetSchoolCodeList(EXTotalsBySwisSchoolRollSectionList : TList;
                            SchoolCodeList : TStringList);

{Return a sorted list of the school codes in this list.}

var
  I : Integer;

begin
  For I := 0 to (EXTotalsBySwisSchoolRollSectionList.Count - 1) do
    with PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[I])^ do
      If (SchoolCodeList.IndexOf(SchoolCode) = -1)
        then SchoolCodeList.Add(SchoolCode);

  SchoolCodeList.Sort;

end;  {GetSchoolCodeList}

{===================================================================}
Procedure WriteOneRec2Total(var RPS220File : TextFile;
                                EXTotalsBySwisSchoolRollSectionList : TList;
                                RollSectionList : TStringList;
                                SchoolCode,
                                SwisCode : String;
                                TotalLine,
                                GrandTotalsSection : Boolean);

var
  TempStr : String;
  I, Index : Integer;

begin
  If GrandTotalsSection
    then Write(RPS220File, SwisCode + '99')
    else Write(RPS220File, SwisCode);

  Write(RPS220File, Take(33, ''));  {Filler}
  Write(RPS220File, Take(2, '2'));  {Rec type}

  If GrandTotalsSection
    then Write(RPS220File, Take(9, 'SCHL/MUN'))  {Description}
    else Write(RPS220File, Take(9, 'SCHL/SWIS'));  {Description}

  If TotalLine
    then TempStr := 'TOTAL'
    else TempStr := SchoolCode;

  Write(RPS220File, Take(6, TempStr));

  For I := 0 to 6 do
    If EXTotalsBySwisSchoolRollSectionRecFound(EXTotalsBySwisSchoolRollSectionList,
                                               SwisCode, SchoolCode,
                                               RollSectionList[I], Index)
      then
        begin
            {Write out this roll section.}

          with PEXTotalsBySwisSchoolRollSectionRecord(EXTotalsBySwisSchoolRollSectionList[Index])^ do
            begin
              Write(RPS220File, ShiftRightAddZeroes(Take(6, IntToStr(Count))));
              Write(RPS220File, ShiftRightAddZeroes(Take(15, FormatFloat(NoDecimalDisplay, AssessedVal))));
              Write(RPS220File, ShiftRightAddZeroes(Take(15, FormatFloat(NoDecimalDisplay, AssessedVal - SchoolEXAmount))));
            end;  {with PEXTotalsBySwisSchoolRollSectionRecord ...}

        end
      else Write(RPS220File, ConstStr('0', 36));  {Zero filled blanks if no entries for rs.}

    {Footer}

  Write(RPS220File, Take(200, ''));
  Write(RPS220File, Take(93, ''));

  If TotalLine
    then TempStr := '999999'
    else TempStr := SchoolCode;

  Write(RPS220File, Take(6, TempStr));
  Writeln(RPS220File, Take(29, ''));

end;  {WriteOneRec2Total}

{===================================================================}
Procedure WriteRec2Totals(var RPS220File : TextFile;
                              EXTotalsBySwisSchoolRollSectionList : TList;
                              RollSectionList : TStringList;
                              SwisCode : String;
                              GrandTotals : Boolean);

{Write the totals by swis \ roll section.}

var
  TempEXTotalsBySwisSchoolRollSectionList : TList;
  I : Integer;
  SchoolCodeList : TStringList;

begin
  TempEXTotalsBySwisSchoolRollSectionList := TList.Create;
  SchoolCodeList := TStringList.Create;

  CombineEXTotalsBySwisSchoolRollSection(EXTotalsBySwisSchoolRollSectionList,
                                         TempEXTotalsBySwisSchoolRollSectionList,
                                         SwisCode, False);

  GetSchoolCodeList(TempEXTotalsBySwisSchoolRollSectionList,
                    SchoolCodeList);

    {Now go through each school code and write out the totals.}

  For I := 0 to (SchoolCodeList.Count - 1) do
    WriteOneRec2Total(RPS220File, TempEXTotalsBySwisSchoolRollSectionList,
                      RollSectionList, SchoolCodeList[I],
                      SwisCode, False, GrandTotals);

  FreeTList(TempEXTotalsBySwisSchoolRollSectionList, SizeOf(EXTotalsBySwisSchoolRollSectionRecord));
  SchoolCodeList.Free;

    {Now do an overall total.}

  TempEXTotalsBySwisSchoolRollSectionList := TList.Create;
  SchoolCodeList := TStringList.Create;

  CombineEXTotalsBySwisSchoolRollSection(EXTotalsBySwisSchoolRollSectionList,
                                         TempEXTotalsBySwisSchoolRollSectionList,
                                         SwisCode, True);

  GetSchoolCodeList(TempEXTotalsBySwisSchoolRollSectionList,
                    SchoolCodeList);

    {Now go through each school code and write out the totals.}

  For I := 0 to (SchoolCodeList.Count - 1) do
    WriteOneRec2Total(RPS220File, TempEXTotalsBySwisSchoolRollSectionList,
                      RollSectionList, SchoolCodeList[I],
                      SwisCode, True, GrandTotals);

  FreeTList(TempEXTotalsBySwisSchoolRollSectionList, SizeOf(EXTotalsBySwisSchoolRollSectionRecord));
  SchoolCodeList.Free;

end;  {WriteRec2Totals}

{===================================================================}
Procedure Print220Totals(var RPS220File : TextFile;
                             SwisCode : String;
                             EXTotalsByCodeList,
                             EXTotalsBySwisRollSectionList,
                             EXTotalsBySwisSchoolRollSectionList : TList;
                             RollSectionList : TStringList;
                             TaxRollYear : String;
                             GrandTotals : Boolean);

{Only print the ex totals if this is the grand total print.}

begin
     {First print the totals by swis \ roll section - 1 record only.}

  WriteRec1Totals(RPS220File, EXTotalsBySwisRollSectionList,
                  RollSectionList, SwisCode, TaxRollYear, GrandTotals);

     {Next print the swis\school\roll section totals.}

  WriteRec2Totals(RPS220File, EXTotalsBySwisSchoolRollSectionList,
                  RollSectionList, SwisCode, GrandTotals);

    {If these are the grand totals, then print the totals by ex code.}

  If GrandTotals
    then WriteRec4Totals(RPS220File, SwisCode, EXTotalsByCodeList);

end;  {Print220Totals}

{===================================================================}
Procedure TExemptionReportForm.FillSortFiles(var Quit : Boolean);

{Fill all the sort files needed for the assessor's report.}

var
  FirstTimeThrough,
  HeaderPrinted, Done, DoneExemptions : Boolean;
  Index, NumExemptionsThisParcel, ExemptionsPrinted : Integer;
  LastSwisSBLKey, SwisSBLKey : String;
  LastSwisCode, CurrentSwisCode : String;
  AssessmentTable : TTable;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  EXTotArray : ExemptionTotalsArrayType;

begin
  ExemptionCodes:= nil;
  ExemptionHomesteadCodes:= nil;
  ResidentialTypes:= nil;
  CountyExemptionAmounts:= nil;
  TownExemptionAmounts:= nil;
  SchoolExemptionAmounts:= nil;
  VillageExemptionAmounts := nil;

  ProgressDialog.UserLabelCaption := 'Sorting Exemption File.';

    {CHG03101999-1: Send info to a list or load from a list.}

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

  LastSwisSBLKey := '';

    {Now go through the exemption file.}

  FirstTimeThrough := True;
  Done := False;
  LastSwisCode := '';
  Index := 0;

    {Use the assessment table for the year they are processing in order to
     determine the taxable values.}
    {FXX10152011(2.28.1u): History roll year showed the incorrect AVs.}

  case ProcessingType of
    ThisYear : AssessmentTable := ThisYearAssessmentTable;
    NextYear : AssessmentTable := NextYearAssessmentTable;
    History : AssessmentTable := HistoryAssessmentTable;
  end;

  If LoadFromParcelList
    then
      begin
        Index := 1;
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        ParcelTable.First;
        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
      end;

  repeat
    Application.ProcessMessages;

    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              ParcelListDialog.GetParcel(ParcelTable, Index);
            end
          else ParcelTable.Next;

    If (ParcelTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

    SwisSBLKey := ExtractSSKey(ParcelTable);

      {Insert records into the sort files where appropriate.}

      {CHG11071997-1: Add support for showing 5000x exemptions option,
                      showing village only exemptions options, and
                      generating RPS 220.}

    If (Done or
        RecMeetsCriteria(ExemptionTable, ParcelTable, SwisSBLKey, SelectedSwisCodes,
                         SelectedSchoolCodes, SelectedRollSections))
      then
        begin
          NumExemptionsThisParcel := 0;

          If not Done
            then
              begin
                FindKeyOld(AssessmentTable,
                           ['TaxRollYr', 'SwisSBLKey'],
                           [TaxRollYear, SwisSBLKey]);

                CurrentSwisCode := ParcelTable.FieldByName('SwisCode').Text;

                ExemptionCodes := TStringList.Create;
                ExemptionHomesteadCodes := TStringList.Create;
                ResidentialTypes := TStringList.Create;
                CountyExemptionAmounts := TStringList.Create;
                TownExemptionAmounts := TStringList.Create;
                SchoolExemptionAmounts := TStringList.Create;
                VillageExemptionAmounts := TStringList.Create;

                 {CHG12011997-2: STAR support}
                 {FXX02091998-1: Pass the residential type of each exemption.}

                EXTotArray := TotalExemptionsForParcel(TaxRollYear, SwisSBLKey,
                                         ExemptionLookupTable,
                                         ExemptionCodeTable,
                                         ParcelTable.FieldByName('HomesteadCode').Text,
                                         'A',
                                         ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         ResidentialTypes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         BasicSTARAmount, EnhancedSTARAmount);

                NumExemptionsThisParcel := ExemptionCodes.Count;

                  {Get the assessment and parcel table for this exemption.}

                UpdateExemptionSortTable(TaxRollYear, ParcelTable, AssessmentTable,
                                         ExemptionLookupTable, ExemptionCodeTable,
                                         EXTotArray,
                                         ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         ResidentialTypes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         BasicSTARAmount,
                                         EnhancedSTARAmount,
                                         SelectedExemptionCodes, True,
                                         Quit);

              end;  {If not Done}

            {Add to the 220 file.}
            {FXX06081998-2: Finish out the 220 extract.}

          If GenerateRPS220
            then
              begin
                If (Deblank(LastSwisCode) = '')
                  then LastSwisCode := Copy(SwisSBLKey, 1, 6);

                  {If we changed swis codes, write out the totals.}

                If (Done or
                    (LastSwisCode <> CurrentSwisCode))
                  then Print220Totals(RPS220File,
                                      LastSwisCode,
                                      EXTotalsByCodeList,
                                      EXTotalsBySwisRollSectionList,
                                      EXTotalsBySwisSchoolRollSectionList,
                                      SelectedRollSections, TaxRollYear,
                                      False);

                  {If there are exemptions for this parcel, put them in the
                   file. Don't forget to look for STAR amounts.}

                If ((not Done) and
                    ((NumExemptionsThisParcel > 0) or
                     (Roundoff(BasicSTARAmount, 0) > 0) or
                     (Roundoff(EnhancedSTARAmount, 0) > 0)))
                  then
                    begin
                        {Now go through each exemption and write it out.}

                      FirstTimeThrough := True;
                      DoneExemptions := False;
                      HeaderPrinted := False;
                      ExemptionsPrinted := 0;
                      SetRangeOld(ExemptionTable,
                                  ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                  [TaxRollYear, SwisSBLKey, '     '],
                                  [TaxRollYear, SwisSBLKey, 'ZZZZZ']);

                      repeat
                        If FirstTimeThrough
                          then FirstTimeThrough := False
                          else ExemptionTable.Next;

                        If ExemptionTable.EOF
                          then DoneExemptions := True;

                        If ((not DoneExemptions) and
                            (SelectedExemptionCodes.IndexOf(ExemptionTable.FieldByName('ExemptionCode').Text) <> -1))
                          then
                            begin
                              If not HeaderPrinted
                                then
                                  begin
                                    HeaderPrinted := True;
                                    Add220Rec3Header(RPS220File, TaxRollYear,
                                                     SwisSBLKey, ParcelTable,
                                                     ThisYearAssessmentTable,
                                                     NextYearAssessmentTable,
                                                     ExemptionLookupTable,
                                                     ExemptionCodeTable, Quit);

                                  end;  {If not HeaderPrinted}

                              AddOne220Rec3Detail(RPS220File, ExemptionTable, Quit);

                              ExemptionsPrinted := ExemptionsPrinted + 1;

                            end;  {If not DoneExemptions}

                      until DoneExemptions;

                      If (ExemptionsPrinted > 0)
                        then Add220Rec3Footer(RPS220File, ParcelTable,
                                              SwisSBLKey, TaxRollYear,
                                              ExemptionsPrinted);

                    end;  {If (NumExemptionsThisParcel > 0)}

                LastSwisCode := CurrentSwisCode;

              end;  {If GenerateRPS220}

          If not Done
            then
              begin
                ExemptionCodes.Free;
                ExemptionHomesteadCodes.Free;
                ResidentialTypes.Free;
                CountyExemptionAmounts.Free;
                TownExemptionAmounts.Free;
                SchoolExemptionAmounts.Free;
                VillageExemptionAmounts.Free;

              end;  {If not Done}

        end;  {If Done ...}

    LastSwisSBLKey := SwisSBLKey;

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or Quit or ReportCancelled);

    {CHG11071997-1: If they want the 220, then write out the totals records.}
    {Write out the overall municipality totals.}

  If (Done and GenerateRPS220)
    then Print220Totals(RPS220File, Take(4, LastSwisCode),
                        EXTotalsByCodeList,
                        EXTotalsBySwisRollSectionList,
                        EXTotalsBySwisSchoolRollSectionList,
                        SelectedRollSections, TaxRollYear, True);

end;  {FillSortFiles}

{===================================================================}
Function ExemptionIsVillageOrSystem(EXCode : String) : Boolean;

{If generating the 220 extract, we don't want any system exemptions (5xxxx) or
 village exemptions (xxxx7).}

begin
  Result := (EXCode[1] = '5') or (EXCode[5] = '7');
end;  {ExemptionIsNotVillageOrSystem}

{====================================================================}
Procedure TExemptionReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'exlist.exr', 'Exemption Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TExemptionReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'exlist.exr', 'Exemption Report');

end;  {LoadButtonClick}

{===================================================================}
Procedure TExemptionReportForm.PrintButtonClick(Sender: TObject);

var
  Quit, Proceed : Boolean;
  TextFileName, SpreadsheetFileName, SortFileName, NewFileName : String;
  I : Integer;

begin
  Quit := False;
  ReportCancelled := False;
  Proceed := True;
  bPrintAccountNumber := cbxPrintAccountNumber.Checked;

    {CHG10122003-1(2.07j2): Allow taxable values to be printed on the exemption report.}

  PrintTaxableValues := PrintTaxableValuesCheckBox.Checked;

    {FXX03181999-1: Make sure they select a report type to print.}

  If ((not PrintSection1CheckBox.Checked) and
      (not PrintSection2CheckBox.Checked))
    then
      begin
        Proceed := False;
        MessageDlg('Please select what report type(s) to print.' + #13 +
                   'You can select to view parcels within a special district code,' + #13 +
                   'special districts within a parcel, or both.', mtError, [mbOK], 0)
      end;

  If (Proceed and
      (AssessmentYearRadioGroup.ItemIndex = 2) and
      (Deblank(HistoryEdit.Text) = ''))
    then
      begin
        Proceed := False;
        MessageDlg('In order to print from history, please select' + #13 +
                   'which history year to print.', mtError, [mbOK], 0);
        HistoryEdit.SetFocus;
      end;

  If Proceed
    then
      begin
          {CHG10121998-1: Add user options for default destination and show vet max msg.}

        SetPrintToScreenDefault(PrintDialog);

          {CHG03282002-6: Allow for roll section selection on sd, ex reports.}

        SelectedRollSections.Clear;
        with RollSectionListBox do
          For I := 0 to (Items.Count - 1) do
            If Selected[I]
              then SelectedRollSections.Add(Take(1, Items[I]));

        If PrintDialog.Execute
          then
            begin
                {FXX10071999-1: To solve the problem of printing to the high speed,
                                we need to set the font to a TrueType even though it
                                doesn't matter in the actual printing.  The reason for this
                                is that without setting it, the default font is System for
                                the Generic printer which has a baseline descent of 0.5
                                which messes up printing to a text file.  We needed a font
                                with no descent.}

              TextFiler.SetFont('Courier New', 10);

              CreateParcelList := CreateParcelListCheckBox.Checked;
              LoadFromParcelList := LoadFromParcelListCheckBox.Checked;

                {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

              PrintButton.Enabled := False;
              Application.ProcessMessages;

                {CHG10131998-1: Set the printer settings based on what printer they selected
                                only - they no longer need to worry about paper or landscape
                                mode.}

              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

                {CHG03122007-1(MDT)[2.11.1.18]: Prompt for letter size print.}

              If (ReportPrinter.Orientation = poLandscape)
                then PromptForLetterSize(ReportPrinter, ReportFiler, 95, 78, 1.5);

              If not Quit
                then
                  begin
                    ProcessingType := GlblProcessingType;

                      {FXX11181997-2: The TY and NY radio buttons were switched below.}
                      {FXX04251999-2: Allow the user to print from history.}

                    case AssessmentYearRadioGroup.ItemIndex of
                      0 : begin
                            ProcessingType := ThisYear;
                            TaxRollYear := GlblThisYear;
                          end;

                      1 : begin
                            ProcessingType := NextYear;
                            TaxRollYear := GlblNextYear;
                          end;

                      2 : begin
                            ProcessingType := History;
                            TaxRollYear := HistoryEdit.Text;
                          end;

                    end;  {case AssessmentYearRadioGroup.ItemIndex of}

                      {220 file totals lists.}

                    EXTotalsByCodeList := TList.Create;
                    EXTotalsBySwisRollSectionList := TList.Create;
                    EXTotalsBySwisSchoolRollSectionList := TList.Create;

                    SelectedSwisCodes := TStringList.Create;
                    SelectedExemptionCodes := TStringList.Create;
                    SelectedSchoolCodes := TStringList.Create;

                    GenerateRPS220 := GenerateRPS220CheckBox.Checked;

                    For I := 0 to (SwisCodeListBox.Items.Count - 1) do
                      If SwisCodeListBox.Selected[I]
                        then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

                       {CHG11241999-1: Allow them to select school code(s), print %
                                       instead of village amount.}

                    PrintPercent := PrintPercentCheckBox.Checked;

                    For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
                      If SchoolCodeListBox.Selected[I]
                        then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

                     {FXX06081998-1: Allow selection of exemption codes.}
                     {However, if the 220 extract is being generated, don't include village
                      or system exemptions,}
                     {FXX09171998-1: System exemptions seem to be in the 220 file.}

                    For I := 0 to (ExemptionCodeListBox.Items.Count - 1) do
                      If (ExemptionCodeListBox.Selected[I]) (*and
                          ((not GenerateRPS220) or
                           (GenerateRPS220 and
                            (not ExemptionIsVillageOrSystem(Take(5, ExemptionCodeListBox.Items[I]))))))*)
                         then SelectedExemptionCodes.Add(Take(5, ExemptionCodeListBox.Items[I]));

                      {CHG11011999-2: If they just selected 41834 to print, ask if
                                      they want seniors too.}

                    (*IncludeSeniorsWithEnhanced := True;

                    If ((not GenerateRPS220) and
                        (SelectedExemptionCodes.Count = 1) and
                        (SelectedExemptionCodes[0] = '41834'))
                      then IncludeSeniorsWithEnhanced :=
                                not (MessageDlg('Do you want to print only parcels that have ' +
                                                'an enhanced STAR but not a senior exemption?', mtConfirmation,
                                                [mbYes, mbNo], 0) = idYes); *)

                    If ((not GenerateRPS220) and
                        (SelectedExemptionCodes.Count = 1) and
                        (SelectedExemptionCodes[0] = '41834'))
                      then
                        begin
                          EnhancedSTARTypeDialog.ShowModal;
                          EnhancedSTARType := EnhancedSTARTypeDialog.EnhancedSTARType;

                            {CHG01212004-1(2.08): Add ability to select IVP enrollment status as a choice.}

                          IVPEnrollmentStatusType := EnhancedSTARTypeDialog.IVPEnrollmentStatusType;

                        end;  {If ((not GenerateRPS220) and...}

                      {CHG09222003-1(2.07j): Option to print to Excel.}

                    PrintToExcel := ExtractToExcelCheckBox.Checked;

                    If PrintToExcel
                      then
                        begin
                          ExemptionsAlreadyExtracted := False;
                          SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
                          AssignFile(ExtractFile, SpreadsheetFileName);
                          Rewrite(ExtractFile);

                          Write(ExtractFile, 'Swis Cd,',
                                             'Parcel ID,',
                                             'EX Code,',
                                             'Owner Name,',
                                             'Legal Address,',
                                             'Legal Address #,',
                                             'Legal Address Int,',
                                             'Account #,',
                                             'RS,',
                                             'Prop Class,',
                                             'School,',
                                             'Assessment,',
                                             'County EX Amt,',
                                             GetMunicipalityTypeName(GlblMunicipalityType) + ' EX Amt,',
                                             'School EX Amt,',
                                             'Village EX Amt,',
                                             'EX Percent');

                            {CHG10122003-1(2.07j2): Allow taxable values to be printed on the exemption report.}

                          If PrintTaxableValues
                            then Writeln(ExtractFile, ',County Taxable,',
                                                      GetMunicipalityTypeName(GlblMunicipalityType) + ' Taxable,',
                                                      'School Taxable')
                            else Writeln(ExtractFile);

                        end;  {If PrintToExcel}

                    PrintOrder := PrintOrderRadioGroup.ItemIndex;

                      {Copy the sort table and open the tables.}

                       {FXX12011997-1: Name the sort files with the date and time and
                                       extension of .SRT.}

                    CopyAndOpenSortFile(SortEXTable, 'ExemptionList',
                                        OrigSortFileName, SortFileName,
                                        True, True, Quit);

                      {We have to open the tables manually since we are opening both this year and next year.}

                    OpenTableForProcessingType(ThisYearAssessmentTable, AssessmentTableName,
                                               ThisYear, Quit);
                    OpenTableForProcessingType(NextYearAssessmentTable, AssessmentTableName,
                                               NextYear, Quit);
                    OpenTableForProcessingType(HistoryAssessmentTable, AssessmentTableName,
                                               History, Quit);
                    OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                               ProcessingType, Quit);
                    OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                               ProcessingType, Quit);
                    OpenTableForProcessingType(ExemptionLookupTable, ExemptionsTableName,
                                               ProcessingType, Quit);
                    OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                                               ProcessingType, Quit);
                    OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                               ProcessingType, Quit);

                      {As per RPS 220 extract, the full star amount is given on an individual
                       parcel, but a reduced star amount is included in totals if the star
                       amount would make TV negative.}

                    FindKeyOld(ExemptionCodeTable, ['EXCode'],
                               [BasicSTARExemptionCode]);
                    FullBasicSTARAmount := ExemptionCodeTable.FieldByName('FixedAmount').AsFloat;
                    FindKeyOld(ExemptionCodeTable, ['EXCode'],
                               [EnhancedSTARExemptionCode]);
                    FullEnhancedSTARAmount := ExemptionCodeTable.FieldByName('FixedAmount').AsFloat;

                      {FXX07202005-1(2.9.1.2): The print for history was not setting a filter.}

                    If _Compare(ProcessingType, History, coEqual)
                      then _SetRange(ParcelTable, [TaxRollYear, '', '', '', '', '', '', ''],
                                     [TaxRollYear, 'zzzzzzzz', '', '', '', '', '', ''], '', []);

                      {CHG11071997-1: Add support for showing 5000x exemptions option,
                                      showing village only exemptions options, and
                                      generating RPS 220.}

                    If GenerateRPS220
                      then
                        begin
                          AssignFile(RPS220File, GlblDrive + ':' + GlblExportDir +
                                                 'RPS220T1');
                          Rewrite(RPS220File);

                        end;  {If GenerateRPS220}

                    FillSortFiles(Quit);

                      {Add the totals to the 220 file.}

                    If GenerateRPS220
                      then
                        begin
                          CloseFile(RPS220File);

                        end;  {If GenerateRPS220}

                      {Now print the report.}

                    If not (Quit or ReportCancelled)
                      then
                        begin
                            {FXX07221998-1: So that more than one person can run the report
                                            at once, use a time based name first and then
                                            rename.}

                          TextFileName := GetPrintFileName(Self.Caption, True);
                          TextFiler.FileName := TextFileName;
                          GlblPreviewPrint := False;

                            {FXX01211998-1: Need to set the LastPage property so that
                                            long rolls aren't a problem.}

                          TextFiler.LastPage := 30000;

                          TextFiler.Execute;

                            {FXX10111999-3: Make sure they know its done.}

                          ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

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
                                GlblPreviewPrint := True;

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
                                    Chdir(GlblReportDir);
                                    OldDeleteFile(NewFileName);
                                  finally
                                    {We don't care if it does not get deleted, so we won't put up an
                                     error message.}

                                    ChDir(GlblProgramDir);
                                  end;

                                end;  {try PreviewForm := ...}

                              end  {If PrintDialog.PrintToFile}
                            else ReportPrinter.Execute;

                            {CHG01182000-3: Allow them to choose a different name or copy right away.}

                          ShowReportDialog('EXLIST.RPT', TextFiler.FileName, True);

                        end;  {If not Quit}

                    ProgressDialog.Finish;

                      {FXX10111999-3: Tell people that printing is starting and
                                      done.}

                    DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

                      {Make sure to close and delete the sort file.}

                    SortEXTable.Close;

                      {Now delete the file.}
                    try
                      ChDir(GlblDataDir);
                      OldDeleteFile(SortFileName);
                    finally
                      {We don't care if it does not get deleted, so we won't put up an
                       error message.}

                      ChDir(GlblProgramDir);
                    end;

                    SelectedSwisCodes.Free;
                    SelectedExemptionCodes.Free;
                    SelectedSchoolCodes.Free;

                    FreeTList(EXTotalsByCodeList, SizeOf(EXTotalsByCodeRecord));
                    FreeTList(EXTotalsBySwisRollSectionList, SizeOf(EXTotalsBySwisRollSectionRecord));
                    FreeTList(EXTotalsBySwisSchoolRollSectionList, SizeOf(EXTotalsBySwisSchoolRollSectionRecord));

                      {CHG05131999-3: See if they want to copy\zip the file.}

                    If (GenerateRPS220 and
                        (MessageDlg('Do you want to copy\zip the exemption extract file to another drive or disk?',
                                     mtConfirmation, [mbYes, mbNo], 0) = idYes))
                      then
                        with ZipCopyDlg do
                          begin
                              {CHG08301999-1: Change zip\copy to allow selections from other dirs.}

                            InitialDrive := GlblDrive;
                            InitialDir := GlblExportDir;
                            SelectFile(ExpandPASPath(GlblExportDir) + 'RPS220T1');
                            SelectFile(ExpandPASPath(GlblReportDir) + 'EXLIST.RPT');
                            Execute;

                          end;  {with ZipCopyDlg do}


                    If CreateParcelList
                      then ParcelListDialog.Show;

                    If PrintToExcel
                      then
                        begin
                          CloseFile(ExtractFile);
                          SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                         False, '');

                        end;  {If PrintToExcel}

                  end;  {If not Quit}

            end;  {If PrintDialog.Execute}

        PrintButton.Enabled := True;
        ResetPrinter(ReportPrinter);

      end;  {If ((not PrintSection1CheckBox.Checked) and ...}

end;  {StartButtonClick}

{===================================================================}
{===============  THE FOLLOWING ARE PRINTING PROCEDURES ============}
{===================================================================}
Procedure TExemptionReportForm.PrintReportHeader(Sender : TObject;
                                                 ReportTime : TDateTime;
                                                 PageNum : Integer;
                                                 PartName,
                                                 SubHeader : String;
                                                 SwisCode : String);

{Print the overall report header.}

var
  TempStr, TempStr2, LineStr : String;
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      TempStr := 'County of ' + Trim(GlblCountyName);
      TempStr2 := 'DATE: ' + DateToStr(Date) + '  TIME: ' + TimeToStr(Now);

      LineStr := UpcaseStr(TempStr) +
                 Center(PartName, (130 - 2 * Length(TempStr)));
      LineStr := Take(130, LineStr);

        {Put the date and time on the end.}

      For I := Length(TempStr2) downto 1 do
        LineStr[130 - (Length(TempStr2) - I)] := TempStr2[I];
      Println(LineStr);

      TempStr := Trim(UpcaseStr(GetMunicipalityName));
      TempStr2 := 'PAGE: ' + IntToStr(CurrentPage);
      LineStr := UpcaseStr(TempStr) +
                 Center(Subheader, (130 - 2 * Length(TempStr)));
      LineStr := Take(130, LineStr);
        {Put the page # on the end.}

      For I := Length(TempStr2) downto 1 do
        LineStr[130 - (Length(TempStr2) - I)] := TempStr2[I];
      Println(LineStr);

        {FXX10271998-4: Incorrect swis code printing in header.}
        {FXX10111999-2: Make sure the assessment year is in the header.}

      SwisCode := SortEXTable.FieldByName('SwisCode').Text;
      FindKeyOld(SwisCodeTable, ['SwisCode'], [SwisCode]);
      TempStr := 'Swis - ' + SwisCode;
      Println(Take(43, UpcaseStr(TempStr) +
                       ' (' + Trim(SwisCodeTable.FieldByName('MunicipalityName').Text + ')')) +
              Center(TaxRollYear + ' ASSESSMENT YEAR', 43));

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintReportHeader}

{===================================================================}
Procedure PrintExemptionSection1Header(Sender : TObject;
                                       PrintTaxableValues : Boolean);

{Print the header for the exemption listing by SBL.}

var
  TempStr1, TempStr2, TempStr3 : String;

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjCenter, 1.9, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.3, pjCenter, 1.3, 0, BoxLineNone, 0);  {Name}
      SetTab(3.7, pjCenter, 1.3, 0, BoxLineNone, 0);  {Location}
      SetTab(5.1, pjCenter, 0.2, 0, BoxLineNone, 0);  {R\S}
      SetTab(5.4, pjCenter, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(5.8, pjCenter, 0.6, 0, BoxLineNone, 0);  {School code}
      SetTab(6.5, pjCenter, 1.1, 0, BoxLineNone, 0);  {Total AV}
      SetTab(7.7, pjCenter, 0.6, 0, BoxLineNone, 0);  {EX Code}
      SetTab(8.4, pjCenter, 1.1, 0, BoxLineNone, 0);  {County amt}
      SetTab(9.6, pjCenter, 1.1, 0, BoxLineNone, 0);  {Town amt}
      SetTab(10.8, pjCenter, 1.1, 0, BoxLineNone, 0);  {School amt}
      SetTab(12.0, pjCenter, 1.1, 0, BoxLineNone, 0);  {Village amt}

        {CHG11241999-1: Allow them to select school code(s), print %
                        instead of village amount.}

      If PrintPercent
        then
          begin
            TempStr1 := '';
            TempStr2 := 'PERCENT';
            TempStr3 := '';
          end
        else
          begin
            TempStr1 := 'VILLAGE';
            TempStr2 := 'EX AMOUNT';
            TempStr3 := 'TAXABLE VAL';

          end;  {else of If PrintPercent}

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      Print(#9 + #9 + #9 + #9 +
              #9 + 'PRP' +
              #9 + 'SCHOOL' +
              #9 + 'TOTAL' +
              #9 + 'EXEMPT');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'COUNTY')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + ANSIUpperCase(GetMunicipalityTypeName(GlblMunicipalityType)))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + 'SCHOOL')
        else Print(#9);
      Println(#9 + TempStr1);

      Print(#9 + 'PARCEL ID' +
            #9 + 'NAME' +
            #9 + 'LOCATION' +
            #9 + 'RS' +
            #9 + 'CLS' +
            #9 + 'CODE' +
            #9 + 'ASSSESSMENT' +
            #9 + 'CODE');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'EX AMOUNT')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + 'EX AMOUNT')
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + 'EX AMOUNT')
        else Print(#9);
      Println(#9 + TempStr2);

        {CHG10122003-1(2.07j2): Allow taxable values to be printed on the exemption report.}

      If PrintTaxableValues
        then
          begin
            Print(#9 + #9 + #9 + #9 +
                  #9 + #9 + #9 + #9);

            If (rtdCounty in GlblRollTotalsToShow)
              then Print(#9 + 'TAXABLE VAL')
              else Print(#9);

            If (rtdMunicipal in GlblRollTotalsToShow)
              then Print(#9 + 'TAXABLE VAL')
              else Print(#9);

            If (rtdSchool in GlblRollTotalsToShow)
              then Print(#9 + 'TAXABLE VAL')
              else Print(#9);

            Println(#9 + TempStr3);

          end;  {If PrintTaxableValues}

      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.9, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.3, pjLeft, 1.3, 0, BoxLineNone, 0);  {Name}
      SetTab(3.7, pjLeft, 1.3, 0, BoxLineNone, 0);  {Location}
      SetTab(5.1, pjCenter, 0.2, 0, BoxLineNone, 0);  {R\S}
      SetTab(5.4, pjCenter, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(5.8, pjCenter, 0.6, 0, BoxLineNone, 0);  {School code}
      SetTab(6.5, pjRight, 1.1, 0, BoxLineNone, 0);  {Total AV}
      SetTab(7.7, pjLeft, 0.6, 0, BoxLineNone, 0);  {EX Code}
      SetTab(8.4, pjRight, 1.1, 0, BoxLineNone, 0);  {County amt}
      SetTab(9.6, pjRight, 1.1, 0, BoxLineNone, 0);  {Town amt}
      SetTab(10.8, pjRight, 1.1, 0, BoxLineNone, 0);  {School amt}
      SetTab(12.0, pjRight, 1.1, 0, BoxLineNone, 0);  {Village amt}

    end;  {with Sender as TBaseReport do}

end;  {PrintExemptionSection1Header}

{===================================================================}
Procedure PrintEXSection1Totals(Sender : TObject;
                                SwisCode : String;
                                TotalType : Char;  {'S' = Swis, 'M' = munic}
                                CountyAmount,
                                TownAmount,
                                SchoolAmount,
                                VillageAmount : Comp;
                                PrintPercent : Boolean);

begin
  with Sender as TBaseReport do
    begin
      Println('');

      case TotalType of
        'M' : Print(#9 + 'GRAND TOTAL ' + Copy(SwisCode, 1, 4));
        'S' : Print(#9 + 'TOTAL SWIS ' + SwisCode);
      end;

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      Print(#9 + #9 + #9 + #9 + #9 + #9 + #9);

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, CountyAmount))
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, TownAmount))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, SchoolAmount))
        else Print(#9);

      If PrintPercent
        then Println('')
        else Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, VillageAmount));

    end;  {with Sender as TBaseReport do}

end;  {PrintEXSection1Totals}

{===================================================================}
Procedure TExemptionReportForm.PrintExemptionSection1(    Sender : TObject;
                                                          ReportTime : TDateTime;
                                                      var PageNum : Integer;
                                                      var Quit : Boolean);

{Print the exemptions by SBL. Break by swis.}

var
  FirstEntryOnPage,
  Done, FirstTimeThrough : Boolean;
  PreviousSBLKey : String;
  PreviousSwisCode : String;
  SwisCountyAmount, SwisTownAmount,
  SwisSchoolAmount, SwisVillageAmount,
  TotalCountyAmount, TotalTownAmount,
  TotalSchoolAmount, TotalVillageAmount, AssessedValue : Comp;
  iPercent : Integer;

begin
  Done := False;
  FirstTimeThrough := True;
  FirstEntryOnPage := True;
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortEXTable);
  ProgressDialog.UserLabelCaption := 'Exemptions By S\B\L.';

  SwisCountyAmount := 0;
  SwisTownAmount := 0;
  SwisSchoolAmount := 0;
  SwisVillageAmount := 0;
  TotalCountyAmount := 0;
  TotalTownAmount := 0;
  TotalSchoolAmount := 0;
  TotalVillageAmount := 0;

    {FXX02031999-3: Add print by name and addr.}

  case PrintOrder of
    poParcelID : SortEXTable.IndexName := 'BYSWIS_SBL_EXCODE';
    poName : SortEXTable.IndexName := 'BYSWIS_NAME_EXCODE';
    poLegalAddress : SortEXTable.IndexName := 'BySwis_LegalAddr_EXCode';
    poAccountNumber : SortEXTable.IndexName := 'BYACCOUNTNO';
  end;

  with Sender as TBaseReport do
    begin
      SortEXTable.First;

      PreviousSwisCode := SortEXTable.FieldByName('SwisCode').Text;
      PreviousSBLKey := '';

      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'EXEMPTION REPORT',
                        'EXEMPTION CODES WITHIN PARCEL',
                        PreviousSwisCode);
      PrintExemptionSection1Header(Sender, PrintTaxableValues);

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortEXTable.Next;

          {FXX02021998-4: Need an app.procmsgs to allow concurrent processing.}

        Application.ProcessMessages;

        If SortEXTable.EOF
          then Done := True;

        If (Done or
            (Take(6, PreviousSwisCode) <> Take(6, SortEXTable.FieldByName('SwisCode').Text)))
          then
            begin
              PrintEXSection1Totals(Sender, PreviousSwisCode, 'S',
                                    SwisCountyAmount,
                                    SwisTownAmount,
                                    SwisSchoolAmount,
                                    SwisVillageAmount, PrintPercent);

              TotalCountyAmount := TotalCountyAmount + SwisCountyAmount;
              TotalTownAmount := TotalTownAmount + SwisTownAmount;
              TotalSchoolAmount := TotalSchoolAmount + SwisSchoolAmount;
              TotalVillageAmount := TotalVillageAmount + SwisVillageAmount;

              SwisCountyAmount := 0;
              SwisTownAmount := 0;
              SwisSchoolAmount := 0;
              SwisVillageAmount := 0;

            end;  {If (Take(6, PreviousSwisCode) ...}

        If not Done or Quit
          then
            begin
              ProgressDialog.Update(Self,
                                    'S\B\L: ' + ConvertSBLOnlyToDashDot(SortEXTable.FieldByName('SBLKey').Text));

                {If they switched swis codes or they are at
                 the end of this page, start a new page.}

              If ((Take(6, PreviousSwisCode) <> Take(6, SortEXTable.FieldByName('SwisCode').Text)) or
                  (LinesLeft < LinesAtBottom))
                then
                  begin
                    NewPage;
                    FirstEntryOnPage := True;
                    PageNum := PageNum + 1;
                    PrintReportHeader(Sender, ReportTime, PageNum,
                                      'EXEMPTION REPORT',
                                      'EXEMPTION CODES WITHIN PARCEL',
                                      SortEXTable.FieldByName('SwisCode').Text);
                    PrintExemptionSection1Header(Sender, PrintTaxableValues);

                  end;  {If (LinesLeft < 5)}

                {Only print the SBL, name ... assessment if this is the
                 first exemption for this parcel.}

              with SortEXTable do
                begin
                  If ((Take(20, PreviousSBLKey) <> Take(20, FieldByName('SBLKey').Text)) or
                      FirstEntryOnPage)
                    then Print(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text) +
                               #9 + Take(13, FieldByName('Name').Text) +
                               #9 + Take(13, GetLegalAddressFromTable(SortEXTable)) +
                               #9 + FieldByName('RollSection').Text +
                               #9 + FieldByName('PropertyClass').Text +
                               #9 + FieldByName('SchoolCode').Text +
                               #9 + FormatFloat(NoDecimalDisplay,
                                                TCurrencyField(FieldByName('TotalAssessedVal')).Value))
                    else Print(#9 + #9 + #9 + #9 + #9 + #9 + #9);  {Skip these fields.}

                    {Now print the exemption amounts.}

                  Print(#9 + FieldByName('ExemptionCode').Text);

                    {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

                  If (rtdCounty in GlblRollTotalsToShow)
                    then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                TCurrencyField(FieldByName('CountyEXAmount')).Value))
                    else Print(#9);

                  If (rtdMunicipal in GlblRollTotalsToShow)
                    then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                TCurrencyField(FieldByName('TownEXAmount')).Value))
                    else Print(#9);

                  If (rtdSchool in GlblRollTotalsToShow)
                    then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                TCurrencyField(FieldByName('SchoolEXAmount')).Value))
                    else Print(#9);

                    {CHG11241999-1: Allow them to select school code(s), print %
                                    instead of village amount.}

                  If PrintPercent
                    then
                      begin
                          {CHG01152009-1(2.16.1.14): If the exemption percent is blank, print 100.}
                        try
                          iPercent := FieldByName('Percent').AsInteger;
                        except
                          iPercent := 100;
                        end;

                        If (_Compare(iPercent, 0, coEqual) and
                            _Compare(FieldByName('TotalAssessedVal').AsInteger,
                                     FieldByName('TownEXAmount').AsInteger, coEqual))
                          then iPercent := 100;

                        Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, iPercent))
                      end
                    else Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                  TCurrencyField(FieldByName('VillageEXAmount')).Value));

                    {CHG10122003-1(2.07j2): Allow taxable values to be printed on the exemption report.}

                  If PrintTaxableValues
                    then
                      begin
                        AssessedValue := FieldByName('TotalAssessedVal').AsInteger;

                        Print(#9 + #9 + #9 + #9 +
                              #9 + #9 + #9 + #9);

                          {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

                        If (rtdCounty in GlblRollTotalsToShow)
                          then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                      (AssessedValue - FieldByName('CountyEXAmount').AsInteger)))
                          else Print(#9);

                        If (rtdMunicipal in GlblRollTotalsToShow)
                          then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                      (AssessedValue - FieldByName('TownEXAmount').AsInteger)))
                          else Print(#9);

                        If (rtdSchool in GlblRollTotalsToShow)
                          then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                      (AssessedValue - FieldByName('SchoolEXAmount').AsInteger)))
                          else Print(#9);

                        If PrintPercent
                          then Println('')
                          else Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                        (AssessedValue - FieldByName('VillageEXAmount').AsInteger)));

                      end;  {If PrintTaxableValues}

                  SwisCountyAmount := SwisCountyAmount + TCurrencyField(FieldByName('CountyEXAmount')).Value;
                  SwisTownAmount := SwisTownAmount + TCurrencyField(FieldByName('TownEXAmount')).Value;
                  SwisSchoolAmount := SwisSchoolAmount + TCurrencyField(FieldByName('SchoolEXAmount')).Value;
                  SwisVillageAmount := SwisVillageAmount + TCurrencyField(FieldByName('VillageEXAmount')).Value;
                  FirstEntryOnPage := False;

                end;  {with SortEXTable do}

            end;  {If not Done or Quit}

        PreviousSwisCode := SortEXTable.FieldByName('SwisCode').Text;
        PreviousSBLKey := SortEXTable.FieldByName('SBLKey').Text;
        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

    end;  {with Sender as TBaseReport do}

  PrintEXSection1Totals(Sender, PreviousSwisCode, 'M',
                        TotalCountyAmount,
                        TotalTownAmount,
                        TotalSchoolAmount,
                        TotalVillageAmount, PrintPercent);

  ExemptionsAlreadyExtracted := True;

end;  {PrintExemptionSection1}

{===================================================================}
Procedure SetSection2Tabs(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 0.6, 0, BoxLineNone, 0);  {EX Code}
      SetTab(1.0, pjLeft, 1.7, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.8, pjLeft, 1.3, 0, BoxLineNone, 0);  {Name}
      SetTab(4.3, pjLeft, 1.4, 0, BoxLineNone, 0);  {Location}
      SetTab(5.8, pjCenter, 0.2, 0, BoxLineNone, 0);  {R\S}
      SetTab(6.1, pjCenter, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(6.5, pjCenter, 0.6, 0, BoxLineNone, 0);  {School code}
      SetTab(7.2, pjRight, 1.1, 0, BoxLineNone, 0);  {Total AV}
      SetTab(8.4, pjRight, 1.0, 0, BoxLineNone, 0);  {County amt}
      SetTab(9.6, pjRight, 1.0, 0, BoxLineNone, 0);  {Town amt}
      SetTab(10.8, pjRight, 1.0, 0, BoxLineNone, 0);  {School amt}
      SetTab(12.0, pjRight, 1.0, 0, BoxLineNone, 0);  {Village amt}
      SetTab(13.1, pjRight, 0.9, 0, BoxLineNone, 0);  {Account #}

    end;  {with Sender as TBaseReport do}

end;  {SetSection2Tabs}

{===================================================================}
Procedure PrintExemptionSection2Header(Sender : TObject;
                                       PrintTaxableValues : Boolean;
                                       bPrintAccountNumber : Boolean);

{Print the header for the exemption listing by SBL.}

var
  TempStr1, TempStr2, TempStr3 : String;

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjCenter, 0.6, 0, BoxLineNone, 0);  {EX Code}
      SetTab(1.0, pjCenter, 1.7, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.8, pjCenter, 1.3, 0, BoxLineNone, 0);  {Name}
      SetTab(4.3, pjCenter, 1.4, 0, BoxLineNone, 0);  {Location}
      SetTab(5.8, pjCenter, 0.2, 0, BoxLineNone, 0);  {R\S}
      SetTab(6.1, pjCenter, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(6.5, pjCenter, 0.6, 0, BoxLineNone, 0);  {School code}
      SetTab(7.2, pjCenter, 1.1, 0, BoxLineNone, 0);  {Total AV}
      SetTab(8.4, pjCenter, 1.0, 0, BoxLineNone, 0);  {County amt}
      SetTab(9.6, pjCenter, 1.0, 0, BoxLineNone, 0);  {Town amt}
      SetTab(10.8, pjCenter, 1.0, 0, BoxLineNone, 0);  {School amt}
      SetTab(12.0, pjCenter, 1.0, 0, BoxLineNone, 0);  {Village amt}
      SetTab(13.1, pjCenter, 0.9, 0, BoxLineNone, 0);  {Village amt}

        {CHG11241999-1: Allow them to select school code(s), print %
                        instead of village amount.}

      If PrintPercent
        then
          begin
            TempStr1 := '';
            TempStr2 := 'PERCENT';
            TempStr3 := '';
          end
        else
          begin
            TempStr1 := 'VILLAGE';
            TempStr2 := 'EX AMOUNT';
            TempStr3 := 'TAXABLE VAL';

          end;  {else of If PrintPercent}

      Print(#9 + 'EXEMPT' +
            #9 + #9 + #9 + #9 +
            #9 + 'PRP' +
            #9 + 'SCHOOL' +
            #9 + 'TOTAL' +
            #9 + 'COUNTY' +
            #9 + ANSIUpperCase(GetMunicipalityTypeName(GlblMunicipalityType)) +
            #9 + 'SCHOOL' +
            #9 + TempStr1);
      If bPrintAccountNumber
        then Println(#9 + 'ACCOUNT')
        else Println('');

      Print(#9 + 'CODE' +
            #9 + 'PARCEL ID' +
            #9 + 'NAME' +
            #9 + 'LOCATION' +
            #9 + 'RS' +
            #9 + 'CLS' +
            #9 + 'CODE' +
            #9 + 'ASSSESSMENT' +
            #9 + 'EX AMOUNT' +
            #9 + 'EX AMOUNT' +
            #9 + 'EX AMOUNT' +
            #9 + TempStr2);
      If bPrintAccountNumber
        then Println(#9 + 'NUMBER')
        else Println('');

        {CHG10122003-1(2.07j2): Allow taxable values to be printed on the exemption report.}

      If PrintTaxableValues
        then Println(#9 + #9 + #9 + #9 +
                     #9 + #9 + #9 + #9 +
                     #9 + 'TAXABLE VAL' +
                     #9 + 'TAXABLE VAL' +
                     #9 + 'TAXABLE VAL' +
                     #9 + TempStr3);

      Println('');

      SetSection2Tabs(Sender);

    end;  {with Sender as TBaseReport do}

end;  {PrintExemptionSection2Header}

{===================================================================}
Procedure PrintEXTotals(Sender : TObject;  {Report printer}
                        TotalType : Char;  {'X' = exemption code, 'S' = swis code, 'T' = overall total}
                        TotalCode : String;  {The exemption or swis code this total is for.}
                        TotalNumParcels : LongInt;
                        TotalCountyAmount,
                        TotalTownAmount,
                        TotalSchoolAmount,
                        TotalVillageAmount : Comp);

var
  TotalHeader : String;

begin
  case TotalType of
    'X' : TotalHeader := 'Total for EX ' + Trim(TotalCode) + ':';
    'S' : TotalHeader := 'Total for Swis ' + Trim(TotalCode) + ':';
    'T' : TotalHeader := 'Overall Total: ';
  end;

  with Sender as TBaseReport do
    begin
      Println('');
      Print(#9 + #9 + TotalHeader + #9 +
            #9 + 'Num Exemptions:  ' + IntToStr(TotalNumParcels) +
            #9 + #9 + #9 + #9 +
            #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                             TotalCountyAmount) +
            #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                             TotalTownAmount) +
            #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                             TotalSchoolAmount));

        {CHG11241999-1: Allow them to select school code(s), print %
                        instead of village amount.}

      If PrintPercent
        then Println('')
        else Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                      TotalVillageAmount));
      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintEXTotals}

{=============================================================}
Procedure PrintOneExemptionTotalsLine(Sender : TObject;
                                      EXCode : String;
                                      Count : LongInt;
                                      CountyEXAmount : LongInt;
                                      TownEXAmount : LongInt;
                                      SchoolEXAmount : LongInt;
                                      VillageEXAmount : LongInt);

begin
  with Sender as TBaseReport do
    begin
      Print(#9 + EXCode +
            #9 + FormatFloat(IntegerDisplay, Count));

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, CountyEXAmount))
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, TownEXAmount))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, SchoolEXAmount))
        else Print(#9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, VillageEXAmount))
        else Println(#9);

    end;  {with Sender as TBaseReport do}

end;  {PrintOneExemptionTotalsLine}

{===================================================================}
Procedure TExemptionReportForm.PrintExemptionTotals(Sender : TObject;
                                                    lstTotals : TList;
                                                    sHeader : String;
                                                    bSingleExemptionTotal : Boolean);

var
  I : Integer;
  iTotalCount,
  iCountyExemptionTotal, iMunicipalExemptionTotal,
  iSchoolExemptionTotal, iVillageExemptionTotal : LongInt;

begin
  iCountyExemptionTotal := 0;
  iMunicipalExemptionTotal := 0;
  iSchoolExemptionTotal := 0;
  iVillageExemptionTotal := 0;
  iTotalCount := 0;

  with Sender as TBaseReport do
    begin
      If _Compare(LinesLeft, 12, coLessThan)
        then
          begin
            NewPage;
            PrintReportHeader(Sender, ReportTime, PageNum,
                              'EXEMPTION REPORT',
                              'PARCELS WITHIN EXEMPTION CODE',
                              PreviousSwisCode);

          end;  {If _Compare(LinesLeft, 12, coLessThan)}

      ClearTabs;
      SetTab(0.3, pjCenter, 0.6, 0, BoxLineNone, 0);  {EX Code}
      SetTab(1.0, pjCenter, 0.8, 0, BoxLineNone, 0);  {Count}
      SetTab(2.0, pjCenter, 1.2, 0, BoxLineNone, 0);  {County}
      SetTab(3.3, pjCenter, 1.2, 0, BoxLineNone, 0);  {Municipal}
      SetTab(4.6, pjCenter, 1.2, 0, BoxLineNone, 0);  {School}
      SetTab(5.9, pjCenter, 1.2, 0, BoxLineNone, 0);  {Village}

      Println('');
      Println(#9 + sHeader);
      Println('');

      Print(#9 + 'EXEMPT' +
            #9 + 'COUNT');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'COUNTY')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + ANSIUpperCase(GetMunicipalityTypeName(GlblMunicipalityType)))
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + 'SCHOOL')
        else Print(#9);

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + 'VILLAGE')
        else Println(#9);

      ClearTabs;
      SetTab(0.3, pjCenter, 0.6, 0, BoxLineNone, 0);  {EX Code}
      SetTab(1.0, pjRight, 0.8, 0, BoxLineNone, 0);  {Count}
      SetTab(2.0, pjRight, 1.2, 0, BoxLineNone, 0);  {County}
      SetTab(3.3, pjRight, 1.2, 0, BoxLineNone, 0);  {Municipal}
      SetTab(4.6, pjRight, 1.2, 0, BoxLineNone, 0);  {School}
      SetTab(5.9, pjRight, 1.2, 0, BoxLineNone, 0);  {Village}

      For I := 0 to (lstTotals.Count - 1) do
        with PEXTotalsByCodeRecord(lstTotals[I])^ do
          begin
            PrintOneExemptionTotalsLine(Sender, EXCode, Count,
                                        Trunc(CountyEXAmount), Trunc(TownEXAmount),
                                        Trunc(SchoolEXAmount), Trunc(VillageEXAmount));

            Inc(iCountyExemptionTotal, Trunc(CountyEXAmount));
            Inc(iMunicipalExemptionTotal, Trunc(TownEXAmount));
            Inc(iSchoolExemptionTotal, Trunc(SchoolEXAmount));
            Inc(iVillageExemptionTotal, Trunc(VillageEXAmount));
            Inc(iTotalCount, Count);

          end;  {with PEXTotalsByCodeRecord(EXTotalsByCodeList[I])^ do}

      If not bSingleExemptionTotal
        then
          begin
            Println('');
            PrintOneExemptionTotalsLine(Sender, 'Overall', iTotalCount,
                                        iCountyExemptionTotal, iMunicipalExemptionTotal,
                                        iSchoolExemptionTotal, iVillageExemptionTotal);

          end;  {If not bSingleExemptionTotal}

      If _Compare(LinesLeft, 15, coLessThan)
        then
          begin
            NewPage;
            PrintReportHeader(Sender, ReportTime, PageNum,
                              'EXEMPTION REPORT',
                              'PARCELS WITHIN EXEMPTION CODE',
                              PreviousSwisCode);
            PrintExemptionSection2Header(Sender, PrintTaxableValues, bPrintAccountNumber);
          end
        else
          If bSingleExemptionTotal
            then
              begin
                Println('');
                Println('');

                PrintExemptionSection2Header(Sender, PrintTaxableValues, bPrintAccountNumber);

              end;  {If bSingleExemptionTotal}

    end;  {with Sender as TBaseReport do}

  SetSection2Tabs(Sender);

end;  {PrintExemptionTotals}

{===================================================================}
Procedure TExemptionReportForm.PrintExemptionSection2(    Sender : TObject;
                                                          ReportTime : TDateTime;
                                                      var PageNum : Integer;
                                                      var Quit : Boolean);

{Print the exemptions by EXCode \SBL. Break by swis.}

var
  Done, FirstTimeThrough, FirstLineOnPage : Boolean;
  PreviousEXCode : String;
  AssessedValue : Comp;
  lstExemptionSubtotals, lstSwisSubtotals, lstExemptionGrandTotals : TList;
  iPercent : Integer;

begin
  Done := False;
  FirstTimeThrough := True;
  FirstLineOnPage := True;
  lstExemptionSubtotals := TList.Create;
  lstSwisSubtotals := TList.Create;
  lstExemptionGrandTotals := TList.Create;

  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortEXTable);
  ProgressDialog.UserLabelCaption := 'Exemptions By Exemption Code.';

  case PrintOrder of
    poParcelID : SortEXTable.IndexName := 'BYSWIS_EXCODE_SBL';
    poName : SortEXTable.IndexName := 'BYSWIS_EXCODE_NAME';
    poLegalAddress : SortEXTable.IndexName := 'BYSWIS_LEGALADDR_EXCODE';
    poAccountNumber : SortEXTable.IndexName := 'ByAccountNumber';
  end;

  with Sender as TBaseReport, SortEXTable do
    begin
      First;

      PreviousSwisCode := FieldByName('SwisCode').AsString;
      PreviousEXCode := '';

      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'EXEMPTION REPORT',
                        'PARCELS WITHIN EXEMPTION CODE',
                        PreviousSwisCode);
      PrintExemptionSection2Header(Sender, PrintTaxableValues, bPrintAccountNumber);

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else Next;

        Application.ProcessMessages;

        If EOF
          then Done := True;

          {Check to see if we need to print totals or start a new page.}

        If not Quit
          then
            begin
                {If we are on a different exemption code, then print out the totals
                 for the last exemption code.}

              If ((_Compare(PreviousEXCode, FieldByName('ExemptionCode').AsString, coNotEqual) and
                   _Compare(PreviousEXCode, coNotBlank)) or
                  Done)
                then
                  begin
                    PrintExemptionTotals(Sender, lstExemptionSubtotals,
                                         'Totals for ' + PreviousEXCode, True);
                    ClearTList(lstExemptionSubtotals, SizeOf(EXTotalsByCodeRecord));

                  end;  {If ((_Compare(PreviousEXCode...}

                {If this is a different swis code, print out the totals for
                 the swis.}

              If (_Compare(PreviousSwisCode, FieldByName('SwisCode').AsString, coNotEqual) or
                  Done)
                then
                  begin
                    PrintExemptionTotals(Sender, lstSwisSubtotals,
                                         'Totals for Swis ' + PreviousSwisCode, False);
                    ClearTList(lstSwisSubtotals, SizeOf(EXTotalsByCodeRecord));

                  end;  {If (_Compare(PreviousSwisCode...}

                {If they switched swis codes or they are at
                 the end of this page, start a new page.}

              If ((Take(6, PreviousSwisCode) <> Take(6, FieldByName('SwisCode').AsString)) or
                  (LinesLeft < LinesAtBottom))
                then
                  begin
                    NewPage;
                    PageNum := PageNum + 1;
                    PrintReportHeader(Sender, ReportTime, PageNum,
                                      'EXEMPTION REPORT',
                                      'PARCELS WITHIN EXEMPTION CODE',
                                      FieldByName('SwisCode').AsString);
                    PrintExemptionSection2Header(Sender, PrintTaxableValues, bPrintAccountNumber);

                    FirstLineOnPage := True;

                  end;  {If (LinesLeft < 5)}

            end;  {If not Quit}

        If not Done or Quit
          then
            begin
              ProgressDialog.Update(Self,
                                    'EX Code: ' +
                                    FieldByName('ExemptionCode').AsString);

                {Only print the Exemption code if this is the
                 first parcel for this exemption.}

              with SortEXTable do
                begin
                  UpdateEXCodeTotals(lstExemptionSubtotals,
                                     FieldByName('ExemptionCode').AsString,
                                     FieldByName('CountyEXAmount').AsInteger,
                                     FieldByName('TownEXAmount').AsInteger,
                                     FieldByName('SchoolEXAmount').AsInteger,
                                     FieldByName('VillageEXAmount').AsInteger);

                  UpdateEXCodeTotals(lstSwisSubtotals,
                                     FieldByName('ExemptionCode').AsString,
                                     FieldByName('CountyEXAmount').AsInteger,
                                     FieldByName('TownEXAmount').AsInteger,
                                     FieldByName('SchoolEXAmount').AsInteger,
                                     FieldByName('VillageEXAmount').AsInteger);

                  UpdateEXCodeTotals(lstExemptionGrandTotals,
                                     FieldByName('ExemptionCode').AsString,
                                     FieldByName('CountyEXAmount').AsInteger,
                                     FieldByName('TownEXAmount').AsInteger,
                                     FieldByName('SchoolEXAmount').AsInteger,
                                     FieldByName('VillageEXAmount').AsInteger);

                  If ((Take(5, PreviousEXCode) <> Take(5, FieldByName('ExemptionCode').AsString)) or
                      FirstLineOnPage)
                    then Print(#9 + FieldByName('ExemptionCode').AsString)
                    else Print(#9);  {Skip the ex code.}

                    {Now print the exemption amounts.}

                  Print(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').AsString) +
                        #9 + Take(13, FieldByName('Name').AsString) +
                        #9 + Take(13, GetLegalAddressFromTable(SortEXTable)) +
                        #9 + FieldByName('RollSection').AsString +
                        #9 + FieldByName('PropertyClass').AsString +
                        #9 + FieldByName('SchoolCode').AsString +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         TCurrencyField(FieldByName('TotalAssessedVal')).Value) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         TCurrencyField(FieldByName('CountyEXAmount')).Value) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         TCurrencyField(FieldByName('TownEXAmount')).Value) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         TCurrencyField(FieldByName('SchoolEXAmount')).Value));

                    {CHG11241999-1: Allow them to select school code(s), print %
                                    instead of village amount.}

                  If PrintPercent
                    then
                      begin
                          {CHG01152009-1(2.16.1.14): If the exemption percent is blank, print 100.}
                        try
                          iPercent := FieldByName('Percent').AsInteger;
                        except
                          iPercent := 100;
                        end;

                        If (_Compare(iPercent, 0, coEqual) and
                            _Compare(FieldByName('TotalAssessedVal').AsInteger,
                                     FieldByName('TownEXAmount').AsInteger, coEqual))
                          then iPercent := 100;

                        Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, iPercent));

                        If bPrintAccountNumber
                          then Println(#9 + FieldByName('AccountNo').AsString)
                          else Println('');
                      end
                    else
                      begin
                        Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                               TCurrencyField(FieldByName('VillageEXAmount')).Value));
                        If bPrintAccountNumber
                          then Println(#9 + FieldByName('AccountNo').AsString)
                          else Println('');

                      end;  {else of If PrintPercent}

                    {CHG10122003-1(2.07j2): Allow taxable values to be printed on the exemption report.}

                  If PrintTaxableValues
                    then
                      begin
                        AssessedValue := FieldByName('TotalAssessedVal').AsInteger;

                        Print(#9 + #9 + #9 + #9 +
                              #9 + #9 + #9 + #9 +
                              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                               (AssessedValue - FieldByName('CountyEXAmount').AsInteger)) +
                              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                               (AssessedValue - FieldByName('TownEXAmount').AsInteger)) +
                              #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                               (AssessedValue - FieldByName('SchoolEXAmount').AsInteger)));

                        If PrintPercent
                          then Println('')
                          else Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                                        (AssessedValue - FieldByName('VillageEXAmount').AsInteger)));

                      end;  {If PrintTaxableValues}

                  FirstLineOnPage := False;

                end;  {with SortEXTable do}

            end;  {If not Done or Quit}

        PreviousSwisCode := FieldByName('SwisCode').AsString;
        PreviousEXCode := FieldByName('ExemptionCode').AsString;

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

      PrintExemptionTotals(Sender, lstExemptionGrandTotals, 'Grand Totals:', False);

    end;  {with Sender as TBaseReport do}

  FreeTList(lstExemptionSubtotals, SizeOf(EXTotalsByCodeRecord));
  FreeTList(lstSwisSubtotals, SizeOf(EXTotalsByCodeList));
  FreeTList(lstExemptionGrandTotals, SizeOf(EXTotalsByCodeList));

end;  {PrintExemptionSection2}

{===================================================================}
Procedure TExemptionReportForm.PrintSelectionsPage(    Sender : TObject;
                                                       ReportTime : TDateTime;
                                                   var PageNum : Integer);

var
  TempStr : String;
  I, NumSelected : Integer;

begin
  with Sender as TBaseReport do
    begin
      NewPage;
      PageNum := PageNum + 1;
      PrintReportHeader(Sender, ReportTime, PageNum,
                        'EXEMPTION REPORT',
                        'Report Selections', '');

      Println('');
      Println('');

      If GenerateRPS220
        then
          begin
            Println('Creating RPS 220 exemption extract file.');
            Println('   >>> System and village exemptions excluded.  <<<');
          end;

      Println('');

      If (SelectedSwisCodes.Count = SwisCodeListBox.Items.Count)
        then Println('All Swis codes printed.')
        else
          begin
            Println('Swis codes printed:');

            TempStr := '';

            For I := 0 to (SelectedSwisCodes.Count - 1) do
              begin
                TempStr := TempStr + SelectedSwisCodes[I] + '  ';

                If (((I + 1) MOD 7) = 0)
                  then
                    begin
                      Println('     ' + TempStr);
                      TempStr := '';
                    end;

              end;  {For I := 0 to (SelectedSwisCodes.Count - 1) do}

            If (Deblank(TempStr) <> '')
              then Println('     ' + TempStr);

          end;  {else of If (SelectedSwisCodes.Count = SwisCodeListBox.Count)}

      Println('');

      If (SelectedSchoolCodes.Count = SchoolCodeListBox.Items.Count)
        then Println('All school codes printed.')
        else
          begin
            Println('School codes printed:');

            TempStr := '';

            For I := 0 to (SelectedSchoolCodes.Count - 1) do
              begin
                TempStr := TempStr + SelectedSchoolCodes[I] + '  ';

                If (((I + 1) MOD 7) = 0)
                  then
                    begin
                      Println('     ' + TempStr);
                      TempStr := '';
                    end;

              end;  {For I := 0 to (SelectedSchoolCodes.Count - 1) do}

            If (Deblank(TempStr) <> '')
              then Println('     ' + TempStr);

          end;  {else of If (SelectedSchoolCodes.Count = SchoolCodeListBox.Count)}

      Println('');

      NumSelected := 0;
      For I := 0 to (ExemptionCodeListBox.Items.Count - 1) do
        If ExemptionCodeListBox.Selected[I]
          then NumSelected := NumSelected + 1;

      If (NumSelected = ExemptionCodeListBox.Items.Count)
        then Println('All exemption codes printed.')
        else
          begin
            Println('Exemption codes printed:');

            TempStr := '';

            For I := 0 to (SelectedExemptionCodes.Count - 1) do
              begin
                TempStr := TempStr + SelectedExemptionCodes[I] + '  ';

                If (((I + 1) MOD 7) = 0)
                  then
                    begin
                      Println('     ' + TempStr);
                      TempStr := '';
                    end;

              end;  {For I := 0 to (SelectedExemptionCodes.Count - 1) do}

            If (Deblank(TempStr) <> '')
              then Println('     ' + TempStr);

          end;  {else of If (SelectedExemptionCodes.Count = ExemptionCodeListBox.Count)}

      If ((SelectedExemptionCodes.Count = 1) and
          (SelectedExemptionCodes[0] = '41834'))
        then
          case EnhancedSTARType of
            enSeniorSTAROnly : Println(#9 + 'Print parcels with senior STAR but no senior exemption.');
            enWithSeniorandSTARExemption : Println(#9 + 'Print parcels with both senior STAR and senior exemptions.');
          end;

    end;  {with Sender as TBaseReport do}

end;  {PrintSelectionsPage}

{===================================================================}
Procedure TExemptionReportForm.TextFilerPrint(Sender: TObject);

{To print the report, we will print each of the segments seperately.
 We will not use the normal paging event driven methods.
 We will control all paging.}

var
  Quit : Boolean;

begin
  Quit := False;
  PageNum := 1;
  ReportTime := Now;

    {FXX10091998-5: Allow them to select which section(s) to print.}

  If ((not (Quit or ReportCancelled)) and
      PrintSection1CheckBox.Checked)
    then PrintExemptionSection1(Sender, ReportTime, PageNum, Quit);

    {FXX06231998-2: Allow them to not print section 2.}

  If ((not (Quit or ReportCancelled)) and
      PrintSection2CheckBox.Checked)
    then
      begin
          {FXX12021998-5: If printing both sections, need to form feed.}

        If PrintSection1CheckBox.Checked
          then TBaseReport(Sender).NewPage;

        PrintExemptionSection2(Sender, ReportTime, PageNum, Quit);

      end;  {If ((not (Quit or ReportCancelled)) and ...}

  If not (Quit or ReportCancelled)
    then PrintSelectionsPage(Sender, ReportTime, PageNum);

end;  {TextFilerPrint}

{==================================================================}
Procedure TExemptionReportForm.ReportPrint(Sender: TObject);

var
  TempTextFile : TextFile;

begin
  AssignFile(TempTextFile, TextFiler.FileName);
  Reset(TempTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, TempTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(TempTextFile);

end;  {ReportPrint}

{===================================================================}
Procedure TExemptionReportForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  SelectedRollSections.Free;
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.