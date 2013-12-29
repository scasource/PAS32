unit Coop_Asmtroll;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids, Printers,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Btrvdlg, wwdblook, Mask,types,pastypes,
  Glblcnst, Gauges,Printrng, RPMemo, RPDBUtil, RPDefine, (*Progress, *)RPTXFilr,
  RPDevice, TabNotBk, ComCtrls, Zipcopy, wwdbedit, Wwdotdot, Wwdbcomb;

type
  TfmCoopAssessmentRoll = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    PrintDialog: TPrintDialog;
    ReportFiler: TReportFiler;
    Label18: TLabel;
    NYParcelTable: TwwTable;
    label16: TLabel;
    Label2: TLabel;
    ScrollBox2: TScrollBox;
    ParcelSDTable: TwwTable;
    Label8: TLabel;
    BLSpecialDistrictTaxTable: TTable;
    BLExemptionTaxTable: TTable;
    BLGeneralTaxTable: TTable;
    ParcelExemptionTable: TTable;
    GeneralTotalsTable: TTable;
    SchoolTotalsTable: TTable;
    EXTotalsTable: TTable;
    SDTotalsTable: TTable;
    AssessmentYearCtlTable: TTable;
    TYParcelTable: TTable;
    SDCodeTable: TTable;
    ClassTable: TTable;
    AssessmentTable: TTable;
    BLHeaderTaxTable: TTable;
    EXCodeTable: TTable;
    SpecialFeeTotalsTable: TTable;
    BLSpecialFeeTaxTable: TTable;
    TextFiler: TTextFiler;
    ReportPrinter: TReportPrinter;
    SwisCodeTable: TTable;
    ReportTabbedNotebook: TTabbedNotebook;
    Label3: TLabel;
    EditTaxRollYear: TEdit;
    RollTypeRadioGroup: TRadioGroup;
    Label6: TLabel;
    Label9: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    SchoolCodeTable: TTable;
    TypePrintGroupBox: TGroupBox;
    CountyCheckBox: TCheckBox;
    MunicipalCheckBox: TCheckBox;
    SchoolCheckBox: TCheckBox;
    SystemTable: TTable;
    Panel4: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    Label4: TLabel;
    PartialVillageCheckBox: TCheckBox;
    GroupBox1: TGroupBox;
    Label30: TLabel;
    LoadFromParcelListCheckBox: TCheckBox;
    UniformPercentOfValueCheckBox: TCheckBox;
    DatePrintedEdit: TMaskEdit;
    PrintFullMarketValueCheckBox: TCheckBox;
    PrintToExcelCheckBox: TCheckBox;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrintButtonClick(Sender: TObject);
    procedure TextFilerBeforePrint(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CollectionTypeLookupChange(Sender: TObject);
    procedure PrinterComboBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    PrintingCancelled : Boolean;

    GeneralRateList,
    SDRateList,
    SpecialFeeRateList,  {Rate lists}
    SDExtCategoryList,
    PropertyClassDescList,
    EXCodeDescList,
    SDCodeDescList,
    SDExtCodeDescList,
    SwisCodeDescList,
    SchoolCodeDescList,
    RollSectionDescList : TList;  {Code lists}

    SelectedRollSections : TStringList;
    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;

    FoundCollectionRec : Boolean;
    CollectionType : String;
    NumParcelsPrinted : LongInt;
    LastRollSection : String;
    LastSwisCode,
    LastSchoolCode : String;
    SequenceStr : String;  {Text of what order the roll is printing in.}
    RollType : Char;
    RollPrintingYear : String;
    LoadFromParcelList,
    TotalsOnly : Boolean;
    PrintCoopTotals : Boolean;
    CoopTotalsList : TList;

    OrigHeaderFileName, OrigGeneralFileName,
    OrigEXFileName, OrigSDFileName, OrigSpecialFeeFileName : String;

    OrigGeneralTotFileName,
    OrigSDTotFileName,
    OrigSchoolTotFileName,
    OrigEXTotFileName,
    OrigSpecialFeeTotFileName : String;
    PrintToExcel : Boolean;
    ExtractFile : TextFile;
    MaxSpecialDistricts, ProcessingType : Integer;
    UseNassauPrintKeyFormat, PrintZoningCode,
    PrintAdditionalLots, PrintPermits : Boolean;
    TaxRollYear : String;
    PrintHistoryAssessmentRoll : Boolean;
    SuppressSDExtensions : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure LoadSDRateList(    SDRateList : TList;
                                 SelectedRollSections : TStringList;
                             var Quit : Boolean);

    Function ParcelToBeBilled(    ParcelTable : TTable;
                                  RollSectionsSelected : TStringList;
                              var NumInactive : LongInt) : Boolean;
    {Check to see if this parcel should get a bill or not. The criteria are:
       1. The parcel must be active.
       2. This is a roll section that they want to see.}

    Procedure SaveEXTaxTotals(ExemptionCodes,
                              ExemptionHomesteadCodes,
                              CountyExemptionAmounts,
                              TownExemptionAmounts,
                              SchoolExemptionAmounts,
                              VillageExemptionAmounts : TStringList;
                              CollectionType : String;
                              EXTotList : TList);
    {Save the exemption totals for this parcel.}

    Procedure SaveGenTaxTotals(LandAssessedVal,
                               TotalAssessedVal,
                               _TaxableVal,
                               ExemptionAmount,
                               BasicSTARAmount,
                               EnhancedSTARAmount : Comp;
                               CollectionType : String;
                               PrintOrder : Integer;
                               _HomesteadCode : String;
                               ClassRecordFound,
                               FirstTimeForParcel : Boolean;
                               GeneralTotList : TList);
    {Save one general tax total for this parcel.}

    Procedure SaveSchTaxTotals(LandAssessedVal,
                               TotalAssessedVal,
                               ExemptionAmount,
                               BasicSTARAmount,
                               EnhancedSTARAmount : Comp;
                               CollectionType : String;
                               _HomesteadCode : String;
                               ClassRecordFound,
                               FirstTimeForParcel : Boolean;
                               SchoolTotList : TList);
    {Save one school tax total.}

    Procedure InsertGeneralTaxRecord(    ParcelTable : TTable;
                                         TaxRollYr : String;
                                         GeneralRateRec : GeneralRateRecord;
                                         HomesteadCode : String;
                                         EXTotArray : ExemptionTotalsArrayType;
                                         EXIdx : Integer;  {EXCounty, EXTown, EXSchool, EXVillage}
                                         LandAssessedVal,
                                         TotalAssessedVal,
                                         BasicSTARAmount,
                                         EnhancedSTARAmount : Comp;
                                         CollectionType : String;
                                         GeneralTotalsList,
                                         SchoolTotalsList : TList;
                                         ClassRecordFound,
                                         FirstTimeForParcel : Boolean;
                                     var Quit : Boolean);
    {Insert one general tax record for this parcel.}

    Function ConvertSDValue(     ExtCode : String;
                                 SDValue : String;
                                 ExtCatList : TList;
                             var ExtCategory : String) : Double;
    {convert the spcl dist string list value to numeric depending on }
    {spcl dist type, with appropriate decimal points, eg all types but}
    {advalorum get 2 decimal points, eg acreage, fixed, unitary}

    Procedure GetSDValues(    SDExtCategory : String;
                              SDExtension : String;
                              HomesteadCode : String;
                              HstdLandVal,
                              NonhstdLandVal,
                              HstdAssessedVal,
                              NonhstdAssessedVal,
                              TaxableVal : Comp;
                          var ExemptionAmount : Comp;
                          var ADValorumAmount,
                              ValueAmount : Extended);

    {Given the extension category, figure out the advalorum amount or value amount,
     exemption amount and total tax for this special district.}

    Procedure SaveSDistTaxTotals(ExtCode : String;
                                 TaxableValAmount : Double;
                                 _HomesteadCode : String;
                                 SDExtCategory: String;
                                 HstdLandVal,
                                 NonhstdLandVal,
                                 HstdAssessedVal,
                                 NonhstdAssessedVal : Comp;
                                 ParcelHomesteadCode : String;
                                 SDTotList : TList);
    {Save the special district totals for this extension.}

    Procedure SaveInfoThisParcel(     CollectionType : String;
                                      GeneralRateList,
                                      SDRateList,
                                      SDExtCategoryList,
                                      GeneralTotalsList,
                                      SDTotalsList,
                                      SchoolTotalsList,
                                      EXTotalsList : TList;
                                      ParcelTable : TTable;
                                      TaxRollYear : String;
                                      ProcessingType : Integer;
                                      PrintCoopTotals : Boolean;
                                      CoopTotalsList : TList;
                                      PrintPermits : Boolean;
                                  var Quit : Boolean);
    {Calculate the bill for one parcel and store the totals in the totals lists.}

    Procedure SaveBillingTotals(    GeneralTotalsList,
                                    SDTotalsList,
                                    SchoolTotalsList,
                                    EXTotalsList : TList;
                                var Quit : Boolean);
    {Save the billing totals in the totals files}

    Procedure SortFiles(    GeneralRateList,
                            SDRateList,
                            SDExtCategoryList : TList;
                            ParcelTable : TTable;
                            TaxRollYear : String;
                            ProcessingType : Integer;
                        var Quit : Boolean);
    {Place the roll information into the temporary billing files.}

    Function ParcelShouldBePrinted : Boolean;
    {We should print this parcel if
       1. They are not showing just roll totals.}

    Procedure AddRecordToExtractFile(var ExtractFile : TextFile;
                                         BLHeaderTaxTable : TTable;
                                         GnTaxList,
                                         ExTaxList,
                                         SDTaxList : TList);

  end;


implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview,
     PrclList, Prog, RptDialg,
     UtilBill,  {Billing specific utilities.}
     RPS995EX,  {To generate the 995T1}
     Utrtotpt;  {Section totals print unit}

type
  CoopTotalsRecord = record
    SwisSBLKey : String;
    LandAssessedValue,
    TotalAssessedValue,
    CountyTaxableValue,
    TownTaxableValue,
    SchoolTaxableValue,
    BasicSTARValue,
    EnhancedSTARValue : Comp;
    EnhancedSTARCount,
    BasicSTARCount : LongInt;
    Count : LongInt;
  end;

  CoopTotalsPointer = ^CoopTotalsRecord;

const
  TrialRun = False;

{$R *.DFM}

{========================================================}
Procedure TfmCoopAssessmentRoll.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TfmCoopAssessmentRoll.InitializeForm;

var
  I : Integer;
  Quit : Boolean;

begin
  UnitName := 'ASMTROLL.PAS';  {mmm}

    {Select all the roll selections as a default.}

  with RollSectionListBox do
    For I := 0 to (Items.Count - 1) do
      If (Take(1, Items[I]) <> '9')
        then Selected[I] := True;

   {FXX06181999-12: Allow the user to select the date of the roll printing.}

  DatePrintedEdit.Text := DateToStr(Date);

  If GlblIsWestchesterCounty
    then ProcessingType := NextYear
    else ProcessingType := ThisYear;

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             ProcessingType, Quit);

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, ThisYear, GlblThisYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, ThisYear, GlblThisYear);

  OrigHeaderFileName := BLHeaderTaxTable.TableName;
  OrigGeneralFileName := BLGeneralTaxTable.TableName;
  OrigEXFileName := BLExemptionTaxTable.TableName;
  OrigSDFileName := BLSpecialDistrictTaxTable.TableName;
  OrigSpecialFeeFileName := BLSpecialFeeTaxTable.TableName;

  OrigGeneralTotFileName := GeneralTotalsTable.TableName;
  OrigSDTotFileName := SDTotalsTable.TableName;
  OrigSchoolTotFileName := SchoolTotalsTable.TableName;
  OrigEXTotFileName := EXTotalsTable.TableName;
  OrigSpecialFeeTotFileName := SpecialFeeTotalsTable.TableName;

  PrinterComboBox.Items.Assign(Printer.Printers);
  PrinterComboBox.Text := Printer.Printers[Printer.PrinterIndex];
  PrinterComboBoxChange(PrinterComboBox);

  try
    PrinterSettingsTable.TableName := PrinterSettingsTableName;
    PrinterSettingsTable.Open;
    FindKeyOld(PrinterSettingsTable, ['ReportName'], ['ASSESSMENTROLL']);
  except
      {FXX02012004-1(2.07l): Make sure to clear the table name so that an OpenTablesForForm
                             does not cause problems later.}

    PrinterSettingsTable.TableName := '';

      {FXX07282004-1(2.08): Deleting the wrong notebook page.}

    ReportTabbedNotebook.Pages.Delete(3);
  end;

    {CHG03232004-1(2.08): Fix up taxable value type selection \ printing on rolls.}

  MunicipalCheckBox.Caption := GetMunicipalityTypeName(GlblMunicipalityType);

  If not (rtdCounty in GlblRollTotalsToShow)
    then
      begin
        CountyCheckBox.Checked := False;
        CountyCheckBox.Visible := False;
      end;

  If not (rtdMunicipal in GlblRollTotalsToShow)
    then
      begin
        MunicipalCheckBox.Checked := False;
        MunicipalCheckBox.Visible := False;
      end;

  If not (rtdSchool in GlblRollTotalsToShow)
    then
      begin
        SchoolCheckBox.Checked := False;
        SchoolCheckBox.Visible := False;
      end;

  If not (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
    then
      begin
        PartialVillageCheckBox.Checked := False;
        PartialVillageCheckBox.Visible := False;
      end;

    {CHG04042004-1(2.07l2): Allow for Nassau formatting and ordering on assessment roll.}

  UseNassauPrintKeyFormatCheckBox.Visible := (ANSIUpperCase(Trim(GlblCountyName)) = 'NASSAU');

end;  {InitializeForm}

{==================================================================}
Procedure TfmCoopAssessmentRoll.PrinterComboBoxChange(Sender: TObject);

begin
  ReportPrinter.SelectPrinter(PrinterComboBox.Text);
  PaperSizeComboBox.Items.Assign(ReportPrinter.Papers);
  PaperSizeComboBox.ItemIndex := 0;

end;  {PrinterComboBoxChange}

{==================================================================}
Procedure TfmCoopAssessmentRoll.CollectionTypeLookupChange(Sender: TObject);

{CHG10302000-1: Need to allow user to specify exactly which municipalities
                print on the roll.}
{CHG03232004-1(2.08): Fix up taxable value type selection \ printing on rolls - comment this out.}

begin
(*  If (CollectionTypeLookup.Text = 'School')
    then
      begin
        CountyCheckBox.Checked := False;
        SchoolCheckBox.Checked := True;
        MunicipalCheckBox.Checked := False;
      end;

  If (CollectionTypeLookup.Text = 'Municipal')
    then
      begin
        CountyCheckBox.Checked := True;
        SchoolCheckBox.Checked := True;
        MunicipalCheckBox.Checked := True;
      end;

  If (CollectionTypeLookup.Text = 'Village')
    then
      begin
        CountyCheckBox.Checked := False;
        SchoolCheckBox.Checked := False;
        MunicipalCheckBox.Checked := True;
      end; *)

end;  {CollectionTypeLookupChange}

{==================================================================}
Procedure LoadGeneralRateList(_SwisCode : String;
                              GeneralRateList : TList;
                              CollectionType : String);

{Add the following "General" taxes - county taxable val, town, school,
 village. This is because the tenative and final rolls show the
 taxable values rather than any general tax amount.}

var
  PGeneralRatePtr : GeneralRatePointer;

begin
    {FXX05271998-2: Only show school taxable value for school roll.}
    {FXX06021998-2: Actually show school taxable val in all cases,
                    but only show county and town in munic.}
    {FXX03241999-1: Need to add in the general tax type.}
    {FXX03241999-2: Need to add in swis - do 1st 4 digits since no actual rate.}

    {FXX10312001-1: Not limiting the individual values printed.}

  If (mtpSchool in MunicipalitiesToPrint)
    then
      begin
        New(PGeneralRatePtr);
        with PGeneralRatePtr^ do
          begin
            SwisCode := _SwisCode;
            PrintOrder := 4;
            Description := 'SCHOOL TAXABLE';
            HomesteadRate := 0;
            NonhomesteadRate := 0;
            GeneralTaxType := 'SC';
          end;  {with PGeneralRatePtr^ do}

        GeneralRateList.Add(PGeneralRatePtr);

      end;  {If (mtpSchool in MunicipalitiesToPrint)}

  If (mtpCounty in MunicipalitiesToPrint)
    then
      begin
        New(PGeneralRatePtr);
        with PGeneralRatePtr^ do
          begin
            SwisCode := _SwisCode;
            PrintOrder := 1;
            Description := 'COUNTY TAXABLE';
            HomesteadRate := 0;
            NonhomesteadRate := 0;
            GeneralTaxType := 'CO';
          end;  {with PGeneralRatePtr^ do}

        GeneralRateList.Add(PGeneralRatePtr);

      end;  {If (mtpCounty in MunicipalitiesToPrint)}

  If (mtpTown in MunicipalitiesToPrint)
    then
      begin
        New(PGeneralRatePtr);
        with PGeneralRatePtr^ do
          begin
            SwisCode := _SwisCode;
            PrintOrder := 2;

            case GlblMunicipalityType of
              MTCity : Description := 'CITY TAXABLE';
              MTVillage : Description := 'VILLAGE TAXABLE';
              else Description := 'TOWN TAXABLE';
            end;  {case GlblMunicipalityType of}

            HomesteadRate := 0;
            NonhomesteadRate := 0;

            GeneralTaxType := 'TO';

          end;  {with PGeneralRatePtr^ do}
        GeneralRateList.Add(PGeneralRatePtr);

      end;  {If (mtpTown in MunicipalitiesToPrint)}

    {CHG03232004-1(2.08): Fix up taxable value type selection \ printing on rolls.}

  If (mtpPartialVillage in MunicipalitiesToPrint)
    then
      begin
        New(PGeneralRatePtr);
        with PGeneralRatePtr^ do
          begin
            SwisCode := _SwisCode;
            PrintOrder := 3;
            Description := 'VILLAGE TAXABLE';
            HomesteadRate := 0;
            NonhomesteadRate := 0;
            GeneralTaxType := 'VI';

          end;  {with PGeneralRatePtr^ do}
          
        GeneralRateList.Add(PGeneralRatePtr);

      end;  {If (mtpPartialVillage in MunicipalitiesToPrint)}

end;  {LoadGeneralRateList}

{==================================================================}
Procedure TfmCoopAssessmentRoll.LoadSDRateList(    SDRateList : TList;
                                                 SelectedRollSections : TStringList;
                                             var Quit : Boolean);

var
  Done, FirstTimeThrough, AddSDRateToList : Boolean;
  TempFieldName : String;
  I : Integer;
  SDRatePtr : SDRatePointer;
  ExtensionCode : String;

begin
  Done := False;
  FirstTimeThrough := True;

  SDCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          SDCodeTable.Next;
        except
          Quit := True;
          SystemSupport(003, SDCodeTable, 'Error getting parcel record.',
                        UnitName, GlblErrorDlgBox);
        end;

    If SDCodeTable.EOF
      then Done := True;

      {FXX052 71998-5: Only include SDs in the list for school if
                      they apply to school.}

    AddSDRateToList := False;

    If (CollectionType = 'SC')
      then
        begin
          If SDCodeTable.FieldByName('AppliesToSchool').AsBoolean
            then AddSDRateToList := True;
        end
      else AddSDRateToList := True;

      {If rs 9 print, only show pro-rata sd's.}

    If (AddSDRateToList and
        (SelectedRollSections.Count = 1) and
        (SelectedRollSections[0] = '9'))
      then AddSDRateToList :=  SDCodeTable.FieldByName('SDRs9').AsBoolean;

    If ((not (Done or Quit)) and
        AddSDRateToList)
      then
        For I := 1 to 10 do
          begin
            TempFieldName := 'ECd' + IntToStr(I);
            ExtensionCode := SDCodeTable.FieldByName(TempFieldName).Text;

            TempFieldName := 'ECFlg' + IntToStr(I);

            If (Deblank(ExtensionCode) <> '')
              then
                begin
                  New(SDRatePtr);

                  with SDRatePtr^ do
                    begin
                      SDistCode := SDCodeTable.FieldByName('SDistCode').Text;
                      ExtCode := Take(2, ExtensionCode);
                      CMFlag := Take(1, SDCodeTable.FieldByName(TempFieldName).Text);
                      Description := Take(20, SDCodeTable.FieldByName('Description').Text);
                      HomesteadRate := 0;
                      NonhomesteadRate := 0;

                    end;  {with SDRatePtr^ do}

                  SDRateList.Add(SDRatePtr);

                end;  {If (Deblank(ExtensionCode) <> '')}

          end;  {For I := 1 to 10 do}

  until (Done or Quit);

end;  {LoadSDRateList}

{==================================================================}
{===============   FILL THE SORT FILES ============================}
{===================================================================}
Function TfmCoopAssessmentRoll.ParcelToBeBilled(    ParcelTable : TTable;
                                                  RollSectionsSelected : TStringList;
                                              var NumInactive : LongInt) : Boolean;

{Check to see if this parcel should get a bill or not. The criteria are:
   1. The parcel must be active.
   2. This is a roll section that they want to see.}

var
  I : Integer;
  Found : Boolean;
  SwisSBLKey : String;

begin
  Result := False;

  For I := 0 to (RollSectionsSelected.Count - 1) do
    If (ParcelTable.FieldByName('RollSection').Text = RollSectionsSelected[I])
      then Result := True;

    {Make sure that the parcel is active.}

  If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
    then
      begin
        Result := False;
        NumInactive := NumInactive + 1;
      end;

    {FXX01232000-2: Allow select of swis \ school codes for assessment roll.}

  If (Result and
      ((SelectedSwisCodes.IndexOf(ParcelTable.FieldByName('SwisCode').Text) = -1) or
       (SelectedSchoolCodes.IndexOf(ParcelTable.FieldByName('SchoolCode').Text) = -1)))
    then Result := False;

    {FXX04191999-2: For parcel list, make sure that we do not use
                    same parcel twice.}

  If (Result and
      LoadFromParcelList)
    then
      begin
        SwisSBLKey := ExtractSSKey(ParcelTable);

        Found := FindKeyOld(BLHeaderTaxTable,
                            ['SchoolCodeKey', 'SwisCode', 'RollSection', 'SBLKey'],
                            ['999999', Take(6, SwisSBLKey),
                             ParcelTable.FieldByName('RollSection').Text,
                             Copy(SwisSBLKey, 7, 20)]);

        Result := not Found;

      end;  {If (Result and ...}

end;  {ParcelToBeBilled}

{===================================================================}
Function FoundEXEntry(    SwisCode : String;
                          SchoolCode : String;
                          RollSection : String;
                          HomeSteadCode : String;
                          ExCode : String;
                          EXTotList : Tlist;
                      var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Index := -1;
  Result := False;

  For I := 0 to (EXTotList.Count - 1) do
    If ((Take(6, SwisCode) = ExemptTotPtr(EXTotList[I])^.SwisCode) and
        (Take(6, SchoolCode) = ExemptTotPtr(EXTotList[I])^.SchoolCode) and
        (Take(1, RollSection) = ExemptTotPtr(EXTotList[I])^.RollSection) and
        (Take(1, HomesteadCode) = ExemptTotPtr(EXTotList[I])^.HomesteadCode) and
        (Take(5, EXCode) = ExemptTotPtr(EXTotList[I])^.EXCode))
       then
         begin
           Index := I;
           Result := True;
         end;

end;  {FoundEXEntry}

{===================================================================}
Procedure TfmCoopAssessmentRoll.SaveEXTaxTotals(ExemptionCodes,
                                              ExemptionHomesteadCodes,
                                              CountyExemptionAmounts,
                                              TownExemptionAmounts,
                                              SchoolExemptionAmounts,
                                              VillageExemptionAmounts : TStringList;
                                              CollectionType : String;
                                              EXTotList : TList);

{Save the exemption totals for this parcel.}

var
  Index, I : Integer;
  EXTotPtr : ExemptTotPtr;
  _SchoolCode : String;
  Amount1, Amount2, Amount3 : Comp;

begin
     {We will only fill in the school code if this is a school
      collection for this totals type. This way, we don't end up
      with totals records broken down by swis and school for
      municipal or village collections.}

  If (CollectionType = 'SC')
    then _SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text
    else _SchoolCode := Take(6, '');

  For I := 0 to (ExemptionCodes.Count - 1) do
    begin
        {FXX05301998-2: Don't show the exemption if it is zero for this
                        taxing purpose.}

      Amount1 := 0;
      Amount2 := 0;
      Amount3 := 0;

      If (CollectionType = 'MU')
        then
          begin
            Amount1 := StrToFloat(CountyExemptionAmounts[I]);
            Amount2 := StrToFloat(TownExemptionAmounts[I]);
            Amount3 := StrToFloat(SchoolExemptionAmounts[I]);
          end;

      If (CollectionType = 'SC')
        then Amount1 := StrToFloat(SchoolExemptionAmounts[I]);

      If (CollectionType = 'VI')
        then Amount1 := StrToFloat(VillageExemptionAmounts[I]);

      If ((Amount1 > 0) or
          (Amount2 > 0) or
          (Amount3 > 0))
        then
          with BLHeaderTaxTable do
            If FoundEXEntry(FieldByName('SwisCode').Text,
                            _SchoolCode,
                            FieldByName('RollSection').Text,
                            ExemptionHomesteadCodes[I],
                            ExemptionCodes[I], EXTotList, Index)
              then
                with ExemptTotPtr(EXTotList[Index])^ do
                  begin
                       {Item exists so add to totals}

                    ParcelCt := ParcelCt + 1;
                    CountyExAmt := CountyExAmt + StrToFloat(CountyExemptionAmounts[I]);
                    TownExAmt := TownExAmt + StrToFloat(TownExemptionAmounts[I]);
                    SchoolExAmt := SchoolExAmt + StrToFloat(SchoolExemptionAmounts[I]);
                    VillageExAmt := VillageExAmt + StrToFloat(VillageExemptionAmounts[I]);

                  end
              else
                begin
                    {Add a new item to the list.}

                  New(EXTotPtr);

                  with EXTotPtr^ do
                     begin
                       SwisCode := FieldByName('SwisCode').Text;
                       SchoolCode := _SchoolCode;
                       RollSection := FieldByName('RollSection').Text;
                       HomesteadCode := ExemptionHomesteadCodes[I];
                       EXCode := ExemptionCodes[I];
                       ParcelCt := 1;
                       CountyExAmt := StrToFloat(CountyExemptionAmounts[I]);
                       TownExAmt := StrToFloat(TownExemptionAmounts[I]);
                       SchoolExAmt := StrToFloat(SchoolExemptionAmounts[I]);
                       VillageExAmt := StrToFloat(VillageExemptionAmounts[I]);

                     end;  {with EXTotPtr^. do}

                  EXTotList.add(EXTotPtr);

                end;  {else of If FoundEXEntry(FieldByName('SwisCode').Text, ...}

    end;  {For I := 0 to (ExemptionCodes.Count - 1) do}

end;  {SaveEXTaxTotals}

{===================================================================}
Function FoundGeneralEntry(    SwisCode : String;
                               SchoolCode : String;
                               RollSection : String;
                               HomesteadCode : String;
                               GNTotList : Tlist;
                           var Index : Integer) : Boolean;

{Look through the general totals list for this particular general tax.}

var
  I : Integer;

begin
  Index := -1;
  Result := False;

  For I := 0 to (GNTotList.Count - 1) do
    If ((Take(6, SwisCode) = GeneralAssessmentTotPtr(GnTotList[I])^.SwisCode) and
        (Take(6,SchoolCode) = GeneralAssessmentTotPtr(GnTotList[I])^.SchoolCode) and
        (Take(1, RollSection) = GeneralAssessmentTotPtr(GnTotList[I])^.RollSection) and
        (Take(1, HomesteadCode) = GeneralAssessmentTotPtr(GnTotList[I])^.HomesteadCode))
      then
        begin
          Index := I;
          Result := True;
        end;

end;  {FoundGeneralEntry}

{===================================================================}
Procedure TfmCoopAssessmentRoll.SaveGenTaxTotals(LandAssessedVal,
                                               TotalAssessedVal,
                                               _TaxableVal,
                                               ExemptionAmount,
                                               BasicSTARAmount,
                                               EnhancedSTARAmount : Comp;
                                               CollectionType : String;
                                               PrintOrder : Integer;
                                               _HomesteadCode : String;
                                               ClassRecordFound,
                                               FirstTimeForParcel : Boolean;
                                               GeneralTotList : TList);

{Save one general tax total for this parcel.}

var
  Index : Integer;
  GnTotPtr : GeneralAssessmentTotPtr;
  _SchoolCode : String;
  TempSTARAmount : Comp;

begin
     {We will only fill in the school code if this is a school
      collection for this totals type. This way, we don't end up
      with totals records broken down by swis and school for
      municipal or village collections.}

  If (CollectionType = 'SC')
    then _SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text
    else _SchoolCode := Take(6, '');

  If FoundGeneralEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text,
                       _SchoolCode,
                       BLHeaderTaxTable.FieldByName('RollSection').Text,
                       _HomesteadCode,
                       GeneralTotList, Index)
    then
      with GeneralAssessmentTotPtr(GeneralTotList[Index])^ do
        begin
             {item exists so add to totals}
             {FXX01191998-9: Don't increase the parcel count or AV
                             since this was already recorded.}

          If FirstTimeForParcel
            then
              begin
                ParcelCt := ParcelCt + 1;
                LandAV := LandAV + LandAssessedVal;
                TotalAV := TotalAV + TotalAssessedVal;

                  {FXX01191998-10: Track splits.}

                If ClassRecordFound
                  then PartCt := PartCt + 1;

              end;  {If FirstTimeForParcel}

          case PrintOrder of
            EXCounty : CountyTaxableVal := CountyTaxableVal + _TaxableVal;
            EXTown : TownTaxableVal := TownTaxableVal + _TaxableVal;
            EXSchool :
              begin
                   {FXX06021998-5: Show STAR amounts for all rolls.}

                TempSTARAmount := BasicSTARAmount + EnhancedSTARAmount;
                STARAmount := STARAmount + TempSTARAmount;

                  {FXX05141998-5: Don't subtract the variable STARAmount since
                                  it is a total of STAR so far.}

                ExemptAmt := ExemptAmt + ExemptionAmount - TempSTARAmount;

                  {FXX05141998-4: Need to subtract ExemptionAmount - STARAmount
                                  rather than
                                  ExemptionAmount because ExemptionAmount includes
                                  STAR and we want to get TV before STAR.}

                SchoolTaxableVal := SchoolTaxableVal + TotalAssessedVal -
                                    (ExemptionAmount - TempSTARAmount);

                  {FXX05141998-3: Should be subtracting, not adding exemption
                                  amt. since taking from orig AV.}

                TaxableValAfterSTAR := TaxableValAfterSTAR +
                                       (TotalAssessedVal - ExemptionAmount);

              end;  {EXSchool}

            EXVillage : VillageTaxableVal := VillageTaxableVal + _TaxableVal;

          end;  {case BLHeaderTaxTable.FieldByName('PrintOrder')AsInteger of}


        end
    else
      begin
        New(GnTotPtr);

        with GnTotPtr^ do
          begin
            SwisCode := BLHeaderTaxTable.FieldByName('SwisCode').Text;
            SchoolCode := _SchoolCode;
            RollSection := BLHeaderTaxTable.FieldByName('RollSection').Text;
            HomesteadCode := _HomesteadCode;
            ParcelCt := 1;

              {FXX01191998-10: Track parcel split count.}

            If ClassRecordFound
              then PartCt := 1
              else PartCt := 0;

            LandAV := LandAssessedVal;
            TotalAV := TotalAssessedVal;
            ExemptAmt := 0;
            CountyTaxableVal := 0;
            TownTaxableVal := 0;
            SchoolTaxableVal := 0;

              {FXX06021998-5: Show STAR amounts for all rolls.}

            case PrintOrder of
              EXCounty : CountyTaxableVal := _TaxableVal;
              EXTown : TownTaxableVal := _TaxableVal;
              EXSchool :
                begin
                  STARAmount := BasicSTARAmount + EnhancedSTARAmount;
                  ExemptAmt := ExemptionAmount - STARAmount;

                    {FXX05141998-4: Need to subtract ExemptAmt above rather than
                                    ExemptionAmount because ExemptionAmount includes
                                    STAR and we want to get TV before STAR.}

                  SchoolTaxableVal := TotalAssessedVal - ExemptAmt;
                  TaxableValAfterSTAR := TotalAssessedVal - ExemptionAmount -
                                         STARAmount;

                end;  {EXSchool}

              EXVillage : VillageTaxableVal := _TaxableVal;

            end;  {case PrintOrder of}

          end;  {with GnTotPtr^ do}

        GeneralTotList.Add(GNTotPtr);

      end;  {else of If FoundGeneralEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text, ...}

end;  {SaveGenTaxTotals}

{===================================================================}
Procedure TfmCoopAssessmentRoll.InsertGeneralTaxRecord(    ParcelTable : TTable;
                                                         TaxRollYr : String;
                                                         GeneralRateRec : GeneralRateRecord;
                                                         HomesteadCode : String;
                                                         EXTotArray : ExemptionTotalsArrayType;
                                                         EXIdx : Integer;  {EXCounty, EXTown, EXSchool, EXVillage}
                                                         LandAssessedVal,
                                                         TotalAssessedVal,
                                                         BasicSTARAmount,
                                                         EnhancedSTARAmount : Comp;
                                                         CollectionType : String;
                                                         GeneralTotalsList,
                                                         SchoolTotalsList : TList;
                                                         ClassRecordFound,
                                                         FirstTimeForParcel : Boolean;
                                                     var Quit : Boolean);

{Insert one general tax record for this parcel.}

begin
  with BLGeneralTaxTable do
    try
      Insert;

      FieldByName('TaxRollYr').Text := TaxRollYr;
      FieldByName('SwisSBLKey').Text := Take(26, ExtractSSKey(ParcelTable));
      FieldByName('PrintOrder').AsInteger := GeneralRateRec.PrintOrder;
      FieldByName('HomesteadCode').Text := Take(1, HomesteadCode);

        {subtract exemption amt from assessed val to get taxable val}

      FieldByName('TaxableValue').AsFloat := (TotalAssessedVal - ExTotArray[ExIdx]);

      Post;
    except
      Quit := True;
      SystemSupport(051, BLGeneralTaxTable, 'Error inserting general tax record.',
                    UnitName, GlblErrorDlgBox);
    end;

        {Save this general tax in tax totals memory array.}

  SaveGenTaxTotals(LandAssessedVal, TotalAssessedVal,
                   TotalAssessedVal - ExTotArray[ExIdx], EXTotArray[EXIdx],
                   BasicSTARAmount, EnhancedSTARAmount, CollectionType,
                   BLGeneralTaxTable.FieldByName('PrintOrder').AsInteger,
                   HomesteadCode, ClassRecordFound,
                   FirstTimeForParcel, GeneralTotalsList);

    {Save school totals even though this may be a munic collection
     because school av, tv, ex are reported on city/town roll}

  SaveSchTaxTotals(LandAssessedVal, TotalAssessedVal, ExTotArray[ExSchool],
                   BasicSTARAmount, EnhancedSTARAmount, CollectionType,
                   HomesteadCode, ClassRecordFound,
                   FirstTimeForParcel, SchoolTotalsList);

end;  {InsertGeneralTaxRecord}

{===================================================================}
Function FoundSchoolEntry(    SwisCode : String;
                              RollSection : String;
                              HomeSteadCode : String;
                              SchoolCode : String;
                              ScTotList : TList;
                          var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Index := -1;
  Result := False;

  For I := 0 to (ScTotList.Count - 1) do
    If ((Take(6, SwisCode) = SchoolTotPtr(ScTotList[I])^.SwisCode) and
        (Take(1,RollSection) = SchoolTotPtr(ScTotList[I])^.RollSection) and
        (Take(1,HomeSteadCode) = SchoolTotPtr(ScTotList[I])^.HomesteadCode) and
        (Take(6,Schoolcode) = SchoolTotPtr(ScTotList[I])^.SchoolCode))
      then
        begin
           Index := I;
           Result := True;
         end;

end;  {FoundSchoolEntry}

{===================================================================}
Procedure TfmCoopAssessmentRoll.SaveSchTaxTotals(LandAssessedVal,
                                               TotalAssessedVal,
                                               ExemptionAmount,
                                               BasicSTARAmount,
                                               EnhancedSTARAmount : Comp;
                                               CollectionType : String;
                                               _HomesteadCode : String;
                                               ClassRecordFound,
                                               FirstTimeForParcel : Boolean;
                                               SchoolTotList : TList);

{Save one school tax total.}

var
  Index : Integer;
  ScTotPtr : SchoolTotPtr;
  TempSTARAmount : Comp;

begin
  If FoundSchoolEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text,
                      BLHeaderTaxTable.FieldByName('RollSection').Text,
                      _HomesteadCode,
                      BLHeaderTaxTable.FieldByName('SchoolDistCode').Text,
                      SchoolTotList, Index)
    then
      begin
          {item exists so add to totals}
        with SchoolTotPtr(SchoolTotList[Index])^ do
          begin
               {FXX01191998-9: Don't increase the parcel count or AV
                               since this was already recorded.}

            If FirstTimeForParcel
              then
                begin
                  ParcelCt := ParcelCt + 1;
                  LandAV := LandAV + LandAssessedVal;
                  TotalAV := TotalAV + TotalAssessedVal;

                    {FXX06021998-5: PrintSTAR amounts for all rolls.}

                  TempSTARAmount := BasicSTARAmount + EnhancedSTARAmount;
                  STARAmount := STARAmount + TempSTARAmount;

                    {FXX05141998-5: Don't subtract the variable STARAmount since
                                    it is a total of STAR so far.}

                  ExemptAmt := ExemptAmt + ExemptionAmount - TempSTARAmount;

                    {FXX05141998-4: Need to subtract ExemptionAmount - STARAmount
                                    rather than
                                    ExemptionAmount because ExemptionAmount includes
                                    STAR and we want to get TV before STAR.}

                  TaxableVal := TaxableVal + TotalAssessedVal -
                                (ExemptionAmount - TempSTARAmount);

                    {FXX05141998-3: Should be subtracting, not adding exemption
                                    amt. since taking from orig AV.}

                  TaxableValAfterSTAR := TaxableValAfterSTAR +
                                         (TotalAssessedVal - ExemptionAmount);

                    {FXX01191998-10: Track splits.}

                  If ClassRecordFound
                    then PartCt := PartCt + 1;

                end;  {If FirstTimeForParcel}

          end;  {with SchoolTotPtr(SchoolTotList[Index])^ do}

      end
    else
      begin
          {Add a new item.}

        New(ScTotPtr);

        with SCTotPtr^ do
          begin
            SwisCode := BLHeaderTaxTable.FieldByName('SwisCode').Text;
            SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text;
            RollSection := BLHeaderTaxTable.FieldByName('RollSection').Text;
            HomesteadCode := _HomesteadCode;
            ParcelCt := 1;

              {FXX01191998-10: Track split count.}

            If ClassRecordFound
              then PartCt := 1
              else PartCt := 0;

            LandAV := LandAssessedVal;
            TotalAV := TotalAssessedVal;

              {Print STAR amounts for all rolls.}

            STARAmount := BasicSTARAmount + EnhancedSTARAmount;
            ExemptAmt := ExemptionAmount - STARAmount;

              {FXX05141998-4: Need to subtract ExemptAmt above rather than
                              ExemptionAmount because ExemptionAmount includes
                              STAR and we want to get TV before STAR.}

            TaxableVal := TotalAssessedVal - ExemptAmt;
            TaxableValAfterSTAR := TotalAssessedVal - ExemptionAmount -
                                   STARAmount;

            TotalTax := 0;

          end;  {with SCTotPtr do}

        SchoolTotList.Add(ScTotPtr);

      end;  {If FoundScEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text, ...}

end;  {SaveSchTaxTotals}

{===================================================================}
Function TfmCoopAssessmentRoll.ConvertSDValue(     ExtCode : String;
                                                 SDValue : String;
                                                 ExtCatList : Tlist;
                                             var ExtCategory : String) : Double;

{convert the spcl dist string list value to numeric depending on }
{spcl dist type, with appropriate decimal points, eg all types but}
{advalorum get 2 decimal points, eg acreage, fixed, unitary}

var
  TempReal : Double;

begin
  Result := 0;

  ExtCategory := GetSDExtCategory(ExtCode, ExtCatList);

  If (Deblank(ExtCategory) <> '')
    then
      begin
           {Ad Valorum assessval has no decimal pts, all other do}

        If _Compare(SDValue, coNotBlank)
          then
            try
              TempReal := StrToFloat(Trim(SDValue));
            except
              TempReal := 0;
            end
          else TempReal := 0;

        If (Take(4, ExtCategory) = SDistCategoryADVL)
          then Result := RoundOff(TempReal, 0)
          else Result := RoundOff(TempReal, 3);

      end
    else
      begin
        NonBtrvSystemSupport(998, 99,
                             'SD Ext Code TAble Lacks Category Code: code =  ' + ExtCode ,
                             UnitName, GlblErrorDlgBox);
        Abort;
     end;

end;  {ConvertSDValue}

{===================================================================}
Function FoundSDEntry(    SwisCode : String;
                          SchoolCode : String;
                          RollSection : String;
                          HomeSteadCode : String;
                          SDCode : String;
                          ExtCode : String;
                          CMFlag : String;
                          SDTotList : TList;
                      var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Index := -1;
  Result := False;

  For I := 0 to (SdTotList.Count - 1) do
    If ((Take(6, SwisCode) = Take(6, SDistTotPtr(SdTotList[I])^.SwisCode)) and
        (Take(6, SchoolCode) = Take(6, SDistTotPtr(SdTotList[I])^.SchoolCode)) and
        (Take(1, RollSection) = Take(1, SDistTotPtr(SdTotList[I])^.RollSection)) and
        (Take(1, HomeSteadCode) = Take(1, SDistTotPtr(SdTotList[I])^.HomesteadCode)) and
        (Take(5, SDCode) = Take(5, SDistTotPtr(SdTotList[I])^.SDCode)) and
        (Take(2, ExtCode) = Take(2, SDistTotPtr(SdTotList[I])^.ExtCode)) and
        (Take(1, CMFlag) = Take(1, SDistTotPtr(SdTotList[I])^.CMFlag)))
      then
        begin
          Index := I;
          Result := True;
        end;

end;  {FoundSDEntry}

{===================================================================}
Procedure TfmCoopAssessmentRoll.GetSDValues(    SDExtCategory : String;
                                              SDExtension : String;
                                              HomesteadCode : String;
                                              HstdLandVal,
                                              NonhstdLandVal,
                                              HstdAssessedVal,
                                              NonhstdAssessedVal,
                                              TaxableVal : Comp;
                                          var ExemptionAmount : Comp;
                                          var ADValorumAmount,
                                              ValueAmount : Extended);

{Given the extension category, figure out the advalorum amount or value amount,
 exemption amount and total tax for this special district.}

begin
  ADValorumAmount := 0;
  ValueAmount := 0;
  ExemptionAmount := 0;

   {get AV value override from SD record if > 0,
    else get it from parcel assesssed value}

  with BLSpecialDistrictTaxTable do
    If (SDExtCategory = SDistCategoryADVL)
      then
        begin
          If (RoundOff(FieldByName('AVAmtUnitDim').AsFloat, 2) > 0)
            then
              begin
                ADValorumAmount := FieldByName('AVAmtUnitDim').AsFloat;

                  {infer exmpt amt from assed val - taxable val}

                ExemptionAmount := (FieldByName('AVAmtUnitDim').AsFloat -
                                    TaxableVal);

              end
            else
              begin
                  {Now, if this is a nonhomestead special district,
                   we will get the nonhomestead assessed value.
                   Otherwise (if it is homestead or blank), we
                   will use the homestead assessed value.}
                  {FXX01292002-1: Change for land value special district.}

                If (SDExtension = SDistEcLD)
                  then
                    begin
                      If (HomesteadCode = 'N')
                        then
                          begin
                              {Use the nonhomestead value.}

                            ADValorumAmount := NonhstdLandVal;

                               {infer exmpt amt from assed val - taxable val}

                            ExemptionAmount := NonhstdLandVal - TaxableVal;

                          end
                        else
                          begin
                              {Use the homestead value.}

                            ADValorumAmount := ADValorumAmount + HstdLandVal;

                               {infer exmpt amt from assed val - taxable val}

                            ExemptionAmount := HstdLandVal - TaxableVal;

                          end;  {else of If (HomesteadCode = 'N')}
                    end
                  else
                    begin
                      If (HomesteadCode = 'N')
                        then
                          begin
                              {Use the nonhomestead value.}

                            ADValorumAmount := NonhstdAssessedVal;

                               {infer exmpt amt from assed val - taxable val}

                            ExemptionAmount := NonhstdAssessedVal - TaxableVal;

                          end
                        else
                          begin
                              {Use the homestead value.}

                            ADValorumAmount := ADValorumAmount + HstdAssessedVal;

                               {infer exmpt amt from assed val - taxable val}

                            ExemptionAmount := HstdAssessedVal - TaxableVal;

                          end;  {else of If (HomesteadCode = 'N')}

                    end;  {else of If (SDExtension = SDistEcLD)}

              end;  {else of If (RoundOff(FieldByName('AVAmtUnitDim').AsFloat, 2) > 0)}

        end
      else
        begin
             {all non-advalorums go in value field}
          ValueAmount := FieldByName('AVAmtUnitDim').AsFloat;

        end;  {else of If (SDExtCategory = SDistCategoryADVL)}

end;  {GetSDValues}

{===================================================================}
Procedure TfmCoopAssessmentRoll.SaveSDistTaxTotals(ExtCode : String;
                                                 TaxableValAmount : Double;
                                                 _HomesteadCode : String;
                                                 SDExtCategory: String;
                                                 HstdLandVal,
                                                 NonhstdLandVal,
                                                 HstdAssessedVal,
                                                 NonhstdAssessedVal : Comp;
                                                 ParcelHomesteadCode : String;
                                                 SDTotList : TList);

{Save the special district totals for this extension.}

var
  Index : Integer;
  ExemptionAmount : Comp;
  ADValorumAmount, ValueAmount : Extended;
  SDTotPtr : SDistTotPtr;
  _SchoolCode : String;

begin
     {We will only fill in the school code if this is a school
      collection for this totals type. This way, we don't end up
      with totals records broken down by swis and school for
      municipal or village collections.}

  If (CollectionType = 'SC')
    then _SchoolCode := BLHeaderTaxTable.FieldByName('SchoolDistCode').Text
    else _SchoolCode := Take(6, '');

  GetSDValues(SDExtCategory, ExtCode, _HomesteadCode,
              HstdLandVal, NonhstdLandVal,
              HstdAssessedVal, NonhstdAssessedVal,
              TaxableValAmount, ExemptionAmount,
              ADValorumAmount, ValueAmount);

  If FoundSDEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text,
                  _SchoolCode,
                  BLHeaderTaxTable.FieldByName('RollSection').Text,
                  _HomesteadCode,
                  BLSpecialDistrictTaxTable.FieldByName('SDistCode').Text,
                  BLSpecialDistrictTaxTable.FieldByName('ExtCode').Text,
                  BLSpecialDistrictTaxTable.FieldByName('CMFlag').Text,
                  SDTotList, Index)
    then
      begin
          {item exists so add to totals}

        with SDistTotPtr(SDTotList[Index])^ do
          begin
            ParcelCt := ParcelCt + 1;
            Value := Value + ValueAmount;
            ADValue := ADValue + ADValorumAmount;
            ExemptAmt := ExemptAmt + ExemptionAmount;
            TaxableVal := TaxableVal + TaxableValAmount;

            If (_Compare(ParcelHomesteadCode, 'S', coEqual) and
                _Compare(_HomesteadCode, 'H', coEqual))
              then PartCount := PartCount + 1;

          end;  {with SDistTotPtr(SDTotList[TLIdx])^ do}

      end
    else
      begin
        New(SDTotPtr);

        with SDTotPtr^ do
          begin
            SwisCode := BLHeaderTaxTable.FieldByName('SwisCode').Text;
            SchoolCode := _SchoolCode;
            RollSection := BLHeaderTaxTable.FieldByName('RollSection').Text;
            HomesteadCode := _HomesteadCode;
            SDCode := BLSpecialDistrictTaxTable.FieldByName('SDistCode').Text;
            ExtCode := Take(6, BLSpecialDistrictTaxTable.FieldByName('ExtCode').Text);
            CMFlag := Take(1, BLSpecialDistrictTaxTable.FieldByName('CMFlag').Text);
            ParcelCt := 1;

            If (_Compare(ParcelHomesteadCode, 'S', coEqual) and
                _Compare(_HomesteadCode, 'H', coEqual))
              then PartCount := 1
              else PartCount := 0;

            Value := ValueAmount;
            ADValue := ADValorumAmount;
            ExemptAmt := ExemptionAmount;
            TaxableVal := TaxableValAmount;
            TotalTax := 0;

          end;  {with SDTotPtr^ do}

        SDTotList.Add(SDTotPtr);

    end;  {If FoundSDEntry(BLHeaderTaxTable.FieldByName('SwisCode').Text, ...}

end;  {SaveSDistTaxTotals}

{===================================================================}
Function FoundSDRateEntry(SDCode : String;
                          SDRateList : TList) : Boolean;

{FXX05281998-6: Don't store SD records if not in rate list.}

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (SDRateList.Count - 1) do
    If (SDRatePointer(SDRateList[I])^.SDistCode = SDCode)
      then Result := True;

end;  {FoundSDRateEntry}

{===================================================================}
Function FindCoopInCoopTotalsList(    CoopTotalsList : TList;
                                      SwisSBLKey : String;
                                  var Index : Integer) : Boolean;

{CHG05292001-1: Add totals by coop.}

var
  I : Integer;

begin
  Result := False;
  Index := -1;

  For I := 0 to (CoopTotalsList.Count - 1) do
    If (Take(19, CoopTotalsPointer(CoopTotalsList[I])^.SwisSBLKey) =
        Take(19, SwisSBLKey))
      then
        begin
          Result := True;
          Index := I;
        end;

end;  {FindCoopInCoopTotalsList}

{===================================================================}
Procedure UpdateCoopTotals(CoopTotalsList : TList;
                           _SwisSBLKey : String;
                           _LandValue,
                           _AssessedValue,
                           _CountyExemptionAmount,
                           _TownExemptionAmount,
                           _SchoolExemptionAmount,
                           _EnhancedSTARAmount,
                           _BasicSTARAmount : Comp);  {Includes STAR}

{CHG05292001-1: Add totals by coop.}

var
  Index : Integer;
  CoopTotalsPtr : CoopTotalsPointer;

begin
  If not FindCoopInCoopTotalsList(CoopTotalsList, _SwisSBLKey, Index)
    then
      begin
        New(CoopTotalsPtr);

        with CoopTotalsPtr^ do
          begin
            SwisSBLKey := Copy(_SwisSBLKey, 1, 19);  {Don't include the sublot or suffix.}
            LandAssessedValue := 0;
            TotalAssessedValue := 0;
            CountyTaxableValue := 0;
            TownTaxableValue := 0;
            SchoolTaxableValue := 0;
            EnhancedSTARValue := 0;
            BasicSTARValue := 0;
            EnhancedSTARCount := 0;
            BasicSTARCount := 0;
            Count := 0;

          end;  {with CoopTotalsPtr^ do}

        CoopTotalsList.Add(CoopTotalsPtr);
        FindCoopInCoopTotalsList(CoopTotalsList, _SwisSBLKey, Index);

      end;  {FindCoopInCoopTotalsList}

    {Update the values.}

  with CoopTotalsPointer(CoopTotalsList[Index])^ do
    begin
      LandAssessedValue := LandAssessedValue + _LandValue;
      TotalAssessedValue := TotalAssessedValue + _AssessedValue;
      CountyTaxableValue := CountyTaxableValue + (_AssessedValue - _CountyExemptionAmount);
      TownTaxableValue := TownTaxableValue + (_AssessedValue - _TownExemptionAmount);
      SchoolTaxableValue := SchoolTaxableValue + (_AssessedValue - _SchoolExemptionAmount);
      EnhancedSTARValue := EnhancedSTARValue + _EnhancedSTARAmount;

      If (Roundoff(_EnhancedSTARAmount, 0) > 0)
        then EnhancedSTARCount := EnhancedSTARCount + 1;

      BasicSTARValue := BasicSTARValue + _BasicSTARAmount;

      If (Roundoff(_BasicSTARAmount, 0) > 0)
        then BasicSTARCount := BasicSTARCount + 1;

      Count := Count + 1;

    end;  {with CoopTotalsPointer(CoopTotalsList[Index]^) do}

end;  {UpdateCoopTotals}

{===================================================================}
Procedure TfmCoopAssessmentRoll.SaveInfoThisParcel(     CollectionType : String;
                                                      GeneralRateList,
                                                      SDRateList,
                                                      SDExtCategoryList,
                                                      GeneralTotalsList,
                                                      SDTotalsList,
                                                      SchoolTotalsList,
                                                      EXTotalsList : TList;
                                                      ParcelTable : TTable;
                                                      TaxRollYear : String;
                                                      ProcessingType : Integer;
                                                      PrintCoopTotals : Boolean;
                                                      CoopTotalsList : TList;
                                                      PrintPermits : Boolean;
                                                  var Quit : Boolean);

{Calculate the bill for one parcel and store the totals in the totals lists.}

var
  I, J, EXIdx, NumResSites, NumComSites : Integer;
  HstdAssessedVal, NonhstdAssessedVal,
  HstdLandVal, NonhstdLandVal, EXAmount : Comp;
  HstdAcres, NonhstdAcres : Real;
  AssessmentRecordFound, ClassRecordFound,
  _Found, FoundTYParcel, FoundNYParcel : Boolean;
  HstdEXTotArray, NonhstdEXTotArray, ExTotArray : ExemptionTotalsArrayType;
  SDAmounts : TList;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  SwisSBLKey : String;
  TempHomesteadCode : String;
  SDExtCategory, HomesteadCode : String;
  BasicSTARAmount, EnhancedSTARAmount,
  CountyAmount, TownAmount,
  SchoolAmount, VillageAmount : Comp;
  TempParcelTable : TTable;
  SBLRec : SBLRecord;
  FirstTimeForParcel : Boolean;
  TempStr, TempDate, TempYear, ZoningCode : String;
  ResidentialSiteTable, CommercialSiteTable : TTable;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);
  HomesteadCode := ParcelTable.FieldByName('HomesteadCode').AsString;

  SDAmounts := TList.Create;
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

    {Get the assessed values.}
    {CHG01121998-1: Allow for the user to choose roll off of This Year or
                    Next Year.}

  CalculateHstdAndNonhstdAmounts(TaxRollYear,
                                 ExtractSSKey(ParcelTable),
                                 AssessmentTable,
                                 ClassTable, ParcelTable,
                                 HstdAssessedVal, NonhstdAssessedVal,
                                 HstdLandVal, NonhstdLandVal,
                                 HstdAcres, NonhstdAcres,
                                 AssessmentRecordFound,
                                 ClassRecordFound);

    {Set up the informational part of the header tax table.}

  with BLHeaderTaxTable do
    try
      Insert;

        {CHG01121998-1: Allow for the user to choose roll of This Year or
                        Next Year.}

      FieldByName('TaxRollYr').Text := Take(4, TaxRollYear);
      FieldByName('SwisCode').Text := ParcelTable.FieldByName('SwisCode').Text;
      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('SBLKey').Text := ExtractSBL(ParcelTable);
      FieldByName('CheckDigit').Text := ParcelTable.FieldByName('CheckDigit').Text;
      FieldByName('SchoolDistCode').Text := ParcelTable.FieldByName('SchoolCode').Text;

      If (CollectionType = 'SC')
        then FieldByName('SchoolCodeKey').Text := ParcelTable.FieldByName('SchoolCode').Text
        else FieldByName('SchoolCodeKey').Text := '999999';

      FieldByName('PropertyClassCode').Text := ParcelTable.FieldByName('PropertyClassCode').Text;

        {If there is no class record, put the acreage in the homestead amount
         if it is 'H' or blank. Put the acreage in non-homestead if this
         is a non-homestead parcel.}

      If ClassRecordFound
        then
          begin
            FieldByName('HstdAcreage').Text := ClassTable.FieldByName('HstdAcres').Text;
            FieldByName('NonhstdAcreage').Text := ClassTable.FieldByName('NonhstdAcres').Text;
          end
        else
          If (ParcelTable.FieldByName('HomesteadCode').Text = 'N')
            then FieldByName('NonhstdAcreage').Text := ParcelTable.FieldByName('Acreage').Text
            else FieldByName('HstdAcreage').Text := ParcelTable.FieldByName('Acreage').Text;

      FieldByName('Frontage').Text := ParcelTable.FieldByName('Frontage').Text;
      FieldByName('Depth').Text := ParcelTable.FieldByName('Depth').Text;
      FieldByName('GridCordNorth').Text := ParcelTable.FieldByName('GridCordNorth').Text;
      FieldByName('GridCordEast').Text := ParcelTable.FieldByName('GridCordEast').Text;
      FieldByName('DeedBook').Text := ParcelTable.FieldByName('DeedBook').Text;
      FieldByName('DeedPage').Text := ParcelTable.FieldByName('DeedPage').Text;
      FieldByName('LegalAddr').Text := ParcelTable.FieldByName('LegalAddr').Text;
      FieldByName('LegalAddrNo').Text := ParcelTable.FieldByName('LegalAddrNo').Text;
      FieldByName('HomesteadCode').Text := ParcelTable.FieldByName('HomesteadCode').Text;
      FieldByName('AccountNumber').Text := ParcelTable.FieldByName('AccountNo').Text;
      FieldByName('MortgageNumber').Text := ParcelTable.FieldByName('MortgageNumber').Text;

      TCurrencyField(FieldByName('HstdTotalVal')).Value := HstdAssessedVal;
      TCurrencyField(FieldByName('NonhstdTotalVal')).Value := NonhstdAssessedVal;
      TCurrencyField(FieldByName('HstdLandVal')).Value := HstdLandVal;
      TCurrencyField(FieldByName('NonhstdLandVal')).Value := NonhstdLandVal;

        {CHG01282004-4(2.07l1): Allow them to print the physical increase as
                                a building permit.}

      If (PrintPermits and
          (AssessmentTable.FieldByName('PhysicalQtyIncrease').AsInteger > 0))
        then FieldByName('BuildingPermitAmount').AsInteger := AssessmentTable.FieldByName('PhysicalQtyIncrease').AsInteger;

        {The name, address, and bank code fields come from the next
         year parcel file if this parcel exists in NY. Otherwise, it
         comes from the TY file.}

       {CHG01121998-1: Allow for the user to choose roll off of This Year or
                       Next Year.}

      SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);
      FoundTYParcel := False;
      FoundNYParcel := False;

      If (ProcessingType = ThisYear)
        then
          begin
            FoundTYParcel := True;

            with SBLRec do
              FoundNYParcel := FindKeyOld(NYParcelTable,
                                          ['TaxRollYr', 'SwisCode', 'Section',
                                           'Subsection', 'Block', 'Lot', 'Sublot',
                                           'Suffix'],
                                          [GlblNextYear, SwisCode,
                                           Section, Subsection,
                                           Block, Lot, Sublot, Suffix]);

            If FoundNYParcel
              then TempParcelTable := NYParcelTable
              else TempParcelTable := TYParcelTable;

          end  {If (ProcessingType = ThisYear)}
        else
          begin
              {Get the TY parcel record to print change of ownership.}

            FoundNYParcel := True;

            with SBLRec do
              FoundTYParcel := FindKeyOld(TYParcelTable,
                                          ['TaxRollYr', 'SwisCode', 'Section',
                                           'Subsection', 'Block', 'Lot', 'Sublot',
                                           'Suffix'],
                                          [GlblThisYear, SwisCode,
                                           Section, Subsection,
                                           Block, Lot, Sublot,
                                           Suffix]);

            TempParcelTable := NYParcelTable;

          end;  {else of If (ProcessingType = ThisYear)}

      FieldByName('Name1').Text := TempParcelTable.FieldByName('Name1').Text;
      FieldByName('Name2').Text := TempParcelTable.FieldByName('Name2').Text;
      FieldByName('Address1').Text := TempParcelTable.FieldByName('Address1').Text;
      FieldByName('Address2').Text := TempParcelTable.FieldByName('Address2').Text;
      FieldByName('Street').Text := TempParcelTable.FieldByName('Street').Text;
      FieldByName('City').Text := TempParcelTable.FieldByName('City').Text;
      FieldByName('State').Text := TempParcelTable.FieldByName('State').Text;
      FieldByName('Zip').Text := TempParcelTable.FieldByName('Zip').Text;
      FieldByName('ZipPlus4').Text := TempParcelTable.FieldByName('ZipPlus4').Text;
      FieldByName('BankCode').Text := TempParcelTable.FieldByName('BankCode').Text;
      FieldByName('PropDescr1').Text := TempParcelTable.FieldByName('PropDescr1').Text;
      FieldByName('PropDescr2').Text := TempParcelTable.FieldByName('PropDescr2').Text;
      FieldByName('PropDescr3').Text := TempParcelTable.FieldByName('PropDescr3').Text;

        {FXX01201998-1: Add land commitment warnings.}

      FieldByName('CommitmentCode').Text := TempParcelTable.FieldByName('LandCommitmentCode').Text;
      FieldByName('CommTermYear').Text := TempParcelTable.FieldByName('CommitmentTermYear').Text;

        {CHG03082003-1: Allow for printing zoning code on the roll and in
                        the extract.}

      If PrintZoningCode
        then
          begin
            ZoningCode := '';
            ResidentialSiteTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
                                                                           ProcessingType);

            NumResSites := CalculateNumSites(ResidentialSiteTable, TaxRollYear,
                                             SwisSBLKey, 0, False);

            If (NumResSites > 0)
              then ZoningCode := ResidentialSiteTable.FieldByName('ZoningCode').Text
              else
                begin
                  CommercialSiteTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                                                ProcessingType);

                  NumComSites := CalculateNumSites(CommercialSiteTable, TaxRollYear,
                                                   SwisSBLKey, 0, False);

                  If (NumComSites > 0)
                    then ZoningCode := CommercialSiteTable.FieldByName('ZoningCode').Text;

                end;  {else of If (NumResSites > 0)}

            try
              FieldByName('ZoningCode').Text := ZoningCode;
            except
            end;

          end;  {If PrintZoningCode}

      If PrintAdditionalLots
        then
          try
            FieldByName('AdditionalLots').Text := ParcelTable.FieldByName('AdditionalLots').text;
          except
          end;

        {CHG04042004-1(2.07l2): Allow for Nassau formatting and ordering on assessment roll.}

      If UseNassauPrintKeyFormat
        then FieldByName('PrintKey').Text := ConvertSwisSBLToNassauDashDot(SwisSBLKey)
        else FieldByName('PrintKey').Text := '';

        {If the next year name is different from the this year name, we
         will print it, but only if they are doing the roll for ThisYear.}

   (*   If ((ProcessingType = NextYear) and
          (Take(30, TYParcelTable.FieldByName('Name1').Text) <>
           Take(30, NYParcelTable.FieldByName('Name1').Text)) and
          (FoundTYParcel and FoundNYParcel))
        then FieldByName('PriorOwner').Text := TYParcelTable.FieldByName('Name1').Text; *)

      Post;
    except
      Quit := True;
      SystemSupport(070, BLHeaderTaxTable, 'Error inserting tax header record.',
                    UnitName, GlblErrorDlgBox);
    end;

    {Make sure that there is an assessment record for this parcel.}

  If not AssessmentRecordFound
    then
      begin
(*        Writeln(CalcMessageFile, 'No Assessment Record For Parcel ' +
                ExtractSSKey(ParcelTable), '.');*)
(*        Quit := True;*)

      end;  {If not AssessmentRecordFound}

    {If the parcel is split, it should have a class record.}

  If ((ParcelTable.FieldByName('HomesteadCode').Text = 'S') and
      (not ClassRecordFound))
    then
      begin
(*        Writeln(CalcMessageFile, 'Parcel is split and has no class record. Parcel = ' +
                ExtractSSKey(ParcelTable), '. No Bill Generated.');
        Quit := True;*)

      end;  {If ((ParcelTable.FieldByName('HomesteadCode').Text = 'S') and ...}

    {Calc exemption amounts, county, town schl, village for this parcel.}
    {CHg12011997-2: STAR support}

        {CHG01121998-1: Allow for the user to choose roll of This Year or
                        Next Year.}
        {FXX02091998-1: Pass the residential type of each exemption.}

  EXTotArray := TotalExemptionsForParcel(TaxRollYear,
                                         Take(26, ExtractSSKey(ParcelTable)),
                                         ParcelExemptionTable,
                                         ExCodeTable,
                                         BLHeaderTaxTable.FieldByName('HomesteadCode').Text,
                                         'A',
                                         ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         ResidentialTypes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         BasicSTARAmount, EnhancedSTARAmount);

   {Now save the exemptions for this parcel in the totals record.}
   {FXX05061998-3: Save the STAR amounts for school billings.
                   To do this, we will insert a STAR exemption code
                   if the amount > 0 and we are in a school billing.
                   This is because on an individual parcel, a STAR exemption
                   is treated like any other exemption, but is seperate for
                   roll totals.}

    {FXX06021998-5: Print STAR amounts for all rolls.}

  If (Roundoff(BasicSTARAmount, 0) > 0)
    then
      begin
        ExemptionCodes.Add(BasicSTARExemptionCode);
        ExemptionHomesteadCodes.Add('H');
        CountyExemptionAmounts.Add('0');
        TownExemptionAmounts.Add('0');
        SchoolExemptionAmounts.Add(FloatToStr(BasicSTARAmount));
        VillageExemptionAmounts.Add('0');

      end;  {If (Roundoff(BasicSTARAmount, 0) > 0)}

  If (Roundoff(EnhancedSTARAmount, 0) > 0)
    then
      begin
        ExemptionCodes.Add(EnhancedSTARExemptionCode);
        ExemptionHomesteadCodes.Add('H');
        CountyExemptionAmounts.Add('0');
        TownExemptionAmounts.Add('0');
        SchoolExemptionAmounts.Add(FloatToStr(EnhancedSTARAmount));
        VillageExemptionAmounts.Add('0');

      end;  {If (Roundoff(EnhancedSTARAmount, 0) > 0)}

   {Now save the exemptions for this parcel in the totals record.}

  SaveEXTaxTotals(ExemptionCodes, ExemptionHomesteadCodes,
                  CountyExemptionAmounts, TownExemptionAmounts,
                  SchoolExemptionAmounts, VillageExemptionAmounts,
                  CollectionType, ExTotalsList);

    {A single exemptions may apply to homestead or non-homestead, so
     the totals will be different on a split parcel. If this is not
     a designated parcel, the total exemption amount will go in
     the HstdEXTotArray - that is, the homestead amount.}

  GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         HstdEXTotArray,
                                         NonhstdEXTotArray);

   {Save the individual exemptions.}
   {FXX06011998-1: Don't print exemptions for rs9.}

  If (BLHeaderTaxTable.FieldByName('RollSection').Text <> '9')
    then
      For I := 0 to (ExemptionCodes.Count - 1) do
        with BLExemptionTaxTable do
          try
            Insert;

            CountyAmount := StrToFloat(CountyExemptionAmounts[I]);
            TownAmount := StrToFloat(TownExemptionAmounts[I]);
            SchoolAmount := StrToFloat(SchoolExemptionAmounts[I]);
            VillageAmount := StrToFloat(VillageExemptionAmounts[I]);

            FieldByName('HomesteadCode').Text := ExemptionHomesteadCodes[I];

            {CHG01121998-1: Allow for the user to choose roll of This Year or
                            Next Year.}

            FieldByName('TaxRollYr').Text := TaxRollYear;
            FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
            FieldByName('EXCode').Text := ExemptionCodes[I];
            TCurrencyField(FieldByName('CountyAmount')).Value := CountyAmount;
            TCurrencyField(FieldByName('TownAmount')).Value := TownAmount;
            TCurrencyField(FieldByName('SchoolAmount')).Value := SchoolAmount;
            TCurrencyField(FieldByName('VillageAmount')).Value := VillageAmount;

              {FXX01131998-1: Add land commitment warnings.}
              {To do this, we will look up the exemption in the exemption
               table rather than returning it in GetExemptionCode.}

            If ((FieldByName('EXCode').Text = '41720') or
                (FieldByName('EXCode').Text = '41730') or
                (FieldByName('EXCode').Text = '47460') or
                (FieldByName('EXCode').Text = '41700'))
              then
                begin
                  _Found := FindKeyOld(ParcelExemptionTable,
                                       ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                       [GlblThisYear,
                                        Take(26, SwisSBLKey),
                                        FieldByName('EXCode').Text]);

                  If _Found
                    then
                      begin
                        TempDate := ParcelExemptionTable.FieldByName('InitialDate').Text;

                        TempYear := Copy(TempDate, (Length(TempDate) - 3), 4);

                        FieldByName('InitialYear').Text := TempYear;

                      end;  {If Found}

                end;  {If ((FieldByName('EXCode').Text = '41720') or ...}

            Post;
          except
            Quit := True;
          end;

    {Now do the general taxes, i.e. Town, County, etc.}

  FirstTimeForParcel := True;

  For I := 0 to (GeneralRateList.Count - 1) do
    begin
        {FXX05311999-1: Forgot to do a take and caused a problem in
                        non-classified municipalities.}

      TempHomesteadCode := Take(1, ParcelTable.FieldByName('HomesteadCode').Text);
      ExIDX := GeneralRatePointer(GeneralRateList[I])^.PrintOrder;

        {If there is any homestead assessed value, insert it.
         This may be a nonclassified parcel, a homestead parcel,
         or the homestead part of a split parcel.}

      If (TempHomesteadCode <> 'N')
        then
          begin
              {FXX04191999-4: Accidently setting TempHomesteadCode to 'H' here
                              and causing split parcels to skip non-hstd
                              portion.}

            InsertGeneralTaxRecord(ParcelTable, TaxRollYear,
                                   GeneralRatePointer(GeneralRateList[I])^,
                                   'H', HstdEXTotArray,
                                   EXIdx, HstdLandVal, HstdAssessedVal,
                                   BasicSTARAmount, EnhancedSTARAmount,
                                   CollectionType,
                                   GeneralTotalsList, SchoolTotalsList,
                                   ClassRecordFound,
                                   FirstTimeForParcel, Quit);

          end;  {If (Roundoff(HstdAssessedVal, 0) > 0)}

        {If there is any nonhomestead assessed value, insert it.
         Note that this will always get stored with a homestead code of 'N'.}

      If (TempHomesteadCode[1] in ['S', 'N'])
        then
          begin
            InsertGeneralTaxRecord(ParcelTable, TaxRollYear,
                                   GeneralRatePointer(GeneralRateList[I])^,
                                   'N', NonhstdEXTotArray,
                                   EXIdx, NonhstdLandVal, NonhstdAssessedVal,
                                   0, 0, CollectionType,  {Nonhstd can not have STAR}
                                   GeneralTotalsList, SchoolTotalsList,
                                   ClassRecordFound,
                                   FirstTimeForParcel, Quit);

          end;  {If (Roundoff(NonhstdAssessedVal, 0) > 0)}

      FirstTimeForParcel := False;

    end;  {For I := 0 to (GeneralRateList.Count - 1) do}

    {Get all the special districts - see PASTYPES for the layout of
     the elements in the SDAmounts list.}

        {CHG01121998-1: Allow for the user to choose roll of This Year or
                        Next Year.}

  TotalSpecialDistrictsForParcel(TaxRollYear, SwisSBLKey,
                                 ParcelTable, AssessmentTable,
                                 ParcelSDTable, SDCodeTable,
                                 ParcelExemptionTable,
                                 ExCodeTable,
                                 SDAmounts);

  TempStr := ExtractSBL(ParcelTable);

    {Now go through each of the entries in the SDAmounts list and
     calculate the tax and store a record in the SD tax table.}
    {FXX05281998-6: Don't store SD records if not in rate list.}
    {FXX09111998-2: Don't check for sd rate - there are no rates in the
                    assessment roll.}

  For I := 0 to (SDAmounts.Count - 1) do
    If FoundSDRateEntry(PParcelSDValuesRecord(SDAmounts[I])^.SDCode,
                        SDRateList)
      then
        For J := 1 to 10 do {For each of the possible extension codes insert a record if it is filled in.}
          If (Deblank(PParcelSDValuesRecord(SDAmounts[I])^.SDExtensionCodes[J]) <> '')
            then
              begin
                with BLSpecialDistrictTaxTable do
                  try
                    Insert;

                    with PParcelSDValuesRecord(SDAmounts[I])^ do
                      begin
                         {CHG01121998-1: Allow for the user to choose roll of This Year or
                                         Next Year.}

                        FieldByName('TaxRollYr').Text := Take(4, TaxRollYear);
                        FieldByName('SwisSBLKey').Text := SwisSBLKey;
                        FieldByName('SdistCode').Text := Take(5, SDCode);
                        FieldByName('ExtCode').Text := Take(2, SDExtensionCodes[J]);
                        FieldByName('CMFlag').Text := Take(1, SDCC_OMFlags[J]);

                          {convert value to appropriate type, eg for advalorum ext code}
                          {convert sdvalue to taxable value, no decimal pts, for }
                          {acreage convert to 2 decimal points, etc}

                        FieldByName('AVAmtUnitDIM').AsFloat :=
                                 ConvertSDValue(Take(2, SDExtensionCodes[J]),
                                                SDValues[J],
                                                SDExtCategoryList, SDExtCategory);

                      end;  {with PParcelSDValuesRecord(SDAmounts[I])^ do}

                    Post;
                  except
                    Quit := True;
                    SystemSupport(050, BLSpecialDistrictTaxTable, 'Error posting SD tax amount.',
                                  UnitName, GlblErrorDlgBox);
                  end;  {with BLSpecialDistrictTaxTable do}

                    {Save this SDist tax in tax totals memory array.}
                    {FXX07102007-1(2.11.2.2)[D905]: The assessment roll homestead \ non-homestead amounts
                                                    are incorrect.  The parcel homestead code was being
                                                    used instead of the SD homestead code.}

                with PParcelSDValuesRecord(SDAmounts[I])^ do
                  SaveSDistTaxTotals(SDExtensionCodes[J],
                                     BLSpecialDistrictTaxTable.FieldByName('AVAmtUnitDIM').AsFloat,
(*                                     ParcelTable.FieldByName('HomesteadCode').Text, *)
                                     HomesteadCodes[J], 
                                     SDExtCategory,
                                     HstdLandVal, NonhstdLandVal,
                                     HstdAssessedVal, NonhstdAssessedVal,
                                     HomesteadCode,
                                     SDTotalsList);

              end;  {If (Deblank(PParcelSDValuesRecord(SDAmounts[I])^.SDExtensionCodes[J]) <> '')}

    {CHG05292001-1: Add totals by coop.}
    {FXX10182007-1(2.11.4.8): For coop rolls, don't worry about ownership code.}

  If (PrintCoopTotals and
      (_Compare(ParcelTable.FieldByName('OwnershipCode').AsString, 'P', coEqual) or
       GlblIsCoopRoll))
    then UpdateCoopTotals(CoopTotalsList, SwisSBLKey, (HstdLandVal + NonhstdLandVal),
                          (HstdAssessedVal + NonhstdAssessedVal),
                          EXTotArray[EXCounty], EXTotArray[EXTown],
                          (EXTotArray[EXSchool] + BasicSTARAmount + EnhancedSTARAmount),
                          EnhancedSTARAmount, BasicSTARAmount);

  FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {SaveInfoThisParcel}

{===================================================================}
Procedure TfmCoopAssessmentRoll.SaveBillingTotals(    GeneralTotalsList,
                                                    SDTotalsList,
                                                    SchoolTotalsList,
                                                    EXTotalsList : TList;
                                                var Quit : Boolean);

{Save the billing totals in the totals files}

var
  I : Integer;

begin
     {SAVE GENERAL TAX TOTALS}

  For I := 0 to (GeneralTotalsList.Count - 1) do
    begin
      GeneralTotalsTable.Insert;

        {The items on the left are fields of the table.
         The items on the right are fields in the pointer record.}

      with GeneralTotalsTable, GeneralAssessmentTotPtr(GeneralTotalsList[I])^ do
        begin
          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection;
          FieldByName('HomesteadCode').Text := HomesteadCode;
          FieldByName('ParcelCt').AsInteger := ParcelCt;

            {FXX01191998-10: Track split count.}

          FieldByName('SplitParcelCt').AsInteger := PartCt;
          FieldByName('LandAV').AsFloat := LandAV;
          FieldByName('TotalAV').AsFloat := TotalAV;
          FieldByName('CountyTaxableVal').AsFloat := CountyTaxableVal;
          FieldByName('TownTaxableVal').AsFloat := TownTaxableVal;
          FieldByName('SchoolTaxableVal').AsFloat := SchoolTaxableVal;
          FieldByName('VillageTaxableVal').AsFloat := VillageTaxableVal;

          FieldByName('STARAmount').AsFloat := STARAmount;
          FieldByName('TaxableValAfterSTAR').AsFloat := TaxableValAfterSTAR;

        end;  {with GeneralTotalsTable, GeneralTotPtr(GeneralTotalsList[I])^ do}

      try
        GeneralTotalsTable.Post;
      except
        Quit := True;
        SystemSupport(043, GeneralTotalsTable,
                      'Post Error on General Tax Total Table, PrintOrder =  ' +
                      GeneralTotalsTable.FieldByName('PrintOrder').Text,
                      UnitName, GlblErrorDlgBox);
      end;  {end try}

    end;  {For I := 0 to (GeneralTotalsList.Count - 1) do}

     {SAVE SDIST TAX TOTALS}

  For I := 0 to (SdTotalsList.Count - 1) do
    begin
       {The items on the left are fields of the table.
        The items on the right are fields in the pointer record.}

      with SDTotalsTable, SDistTotPtr(SDTotalsList[I])^ do
        try
          Insert;

          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection;
          FieldByName('HomesteadCode').Text := HomesteadCode;
          FieldByName('SdCode').Text := SdCode;
          FieldByName('ExtCode').Text := ExtCode;
          FieldByName('ParcelCt').AsInteger := ParcelCt;
          FieldByName('SplitParcelCt').AsInteger := PartCount;
          FieldByName('Value').AsFloat := Value;
          FieldByName('AdValue').AsFloat := ADValue;
          FieldByName('ExemptAmt').AsFloat := ExemptAmt;
          FieldByName('TaxableVal').AsFloat := TaxableVal;
          FieldByName('TotalTax').AsFloat := 0;

          Post;
        except
          Quit := True;
          SystemSupport(044, SDTotalsTable,
                        'Post Error on Sdist Total Table, SdCode  =  ' +
                        FieldByName('SdCode').Text +
                        ' - ' + FieldByName('ExtCode').Text,
                        UnitName, GlblErrorDlgBox);
        end;

    end;  {For I := 0 to (SdTotalsList.Count - 1) do}

     {SAVE SCHOOL TAX TOTALS}

  For I := 0 to (SchoolTotalsList.Count - 1) do
    begin
       {The items on the left are fields of the table.
        The items on the right are fields in the pointer record.}

      with SchoolTotalsTable, SchoolTotPtr(SchoolTotalsList[I])^ do
        try
          Insert;

          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection ;
          FieldByName('HomesteadCode').Text := HomesteadCode ;
          FieldByName('SchoolCode').Text := SchoolCode ;
          FieldByName('ParcelCt').AsInteger := ParcelCt;

            {FXX01191998-10: Track split count.}

          FieldByName('SplitParcelCt').AsInteger := PartCt;
          FieldByName('LandAV').AsFloat := LandAV;
          FieldByName('TotalAV').AsFloat := TotalAV;
          FieldByName('ExemptAmt').AsFloat := ExemptAmt;
          FieldByName('TaxableVal').AsFloat := TaxableVal;
          FieldByName('TotalTax').AsFloat := 0;

          FieldByName('STARAmount').AsFloat := STARAmount;
          FieldByName('TaxableValAfterSTAR').AsFloat := TaxableValAfterSTAR;

          Post;
        except
          Quit := True;
          SystemSupport(045, SchoolTotalsTable,
                        'Post Error on School Total Table, PrintOrder =  ' +
                        FieldByName('PrintOrder').Text,
                        UnitName, GlblErrorDlgBox);
        end;  {end try}

    end;  {For I := 0 to (SchoolTotalsList.Count - 1) do}

     {SAVE EXEMPTION  TAX TOTALS}

  For I := 0 to (ExTotalsList.Count - 1) do
    begin
       {The items on the left are fields of the table.
        The items on the right are fields in the pointer record.}

      with EXTotalsTable, ExemptTotPtr(ExTotalsList[I])^ do
        try
          Insert;

          FieldByName('SwisCode').Text := SwisCode;
          FieldByName('SchoolCode').Text := SchoolCode;
          FieldByName('RollSection').Text := RollSection;
          FieldByName('HomesteadCode').Text := HomesteadCode;
          FieldByName('ExCode').Text := ExCode;
          FieldByName('ParcelCt').AsInteger := ParcelCt;
          FieldByName('CountyExAmt').AsFloat := CountyExAmt;
          FieldByName('TownExAmt').AsFloat := TownExAmt;
          FieldByName('VillageExAmt').AsFloat := VillageExAmt;
          FieldByName('SchoolExAmt').AsFloat := SchoolExAmt;

          Post;
        except
          Quit := True;
          SystemSupport(046, EXTotalsTable,
                        'Post Error on Exemption Total Table, ExCode  =  ' +
                        FieldByName('ExCode').Text, UnitName,
                        GlblErrorDlgBox);
        end;

    end;  {For I := 0 to (ExTotalsList.Count - 1) do}

end;  {SaveBillingTotals}

{===================================================================}
Procedure TfmCoopAssessmentRoll.SortFiles(    GeneralRateList,
                                            SDRateList,
                                            SDExtCategoryList : TList;
                                            ParcelTable : TTable;
                                            TaxRollYear : String;
                                            ProcessingType : Integer;
                                        var Quit : Boolean);

{Place the roll information into the temporary billing files.}

var
  Done, FirstTimeThrough : Boolean;
  NumInactive : LongInt;
  RollSectionsSelected : TStringList;
  I, Index : Integer;
  GeneralTotalsList,
  SDTotalsList,
  SchoolTotalsList,
  EXTotalsList : TList;
  TempStr : String;

begin
  Done := False;
  FirstTimeThrough := True;
  NumInactive := 0;
  RollSectionsSelected := TStringList.Create;
  Application.ProcessMessages;

  GeneralTotalsList := TList.Create;
  SDTotalsList := TList.Create;
  SchoolTotalsList := TList.Create;
  EXTotalsList := TList.Create;
  Index := 1;

  with RollSectionListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then RollSectionsSelected.Add(Items[I][1]);

  ProgressDialog.UserLabelCaption := 'Creating Sort Files.';

    {FXX04181999-2: Let the assessment roll be loaded from a list, too.}

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        ParcelTable.First;
        ProgressDialog.Start(GetRecordCount(NYParcelTable), True, True);
      end;

    {CHG01121998-1: Allow for the user to choose roll of This Year or
                    Next Year.}

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
          else ParcelTable.Next;

    If (ParcelTable.EOF or
        PrintingCancelled or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    TempStr := ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable));
    PrintingCancelled := ProgressDialog.Cancelled;

    Application.ProcessMessages;
    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

    If (not (Done or Quit) and
        (ParcelToBeBilled(ParcelTable, RollSectionsSelected, NumInactive) or
         LoadFromParcelList))
      then
        begin
          SaveInfoThisParcel(CollectionType, GeneralRateList, SDRateList,
                             SDExtCategoryList, GeneralTotalsList,
                             SDTotalsList, SchoolTotalsList, EXTotalsList,
                             ParcelTable, TaxRollYear, ProcessingType,
                             PrintCoopTotals, CoopTotalsList,
                             PrintPermits, Quit);

        end;  {If not (Done or Quit)}

  until (Done or Quit or PrintingCancelled);

  RollSectionsSelected.Free;

  SaveBillingTotals(GeneralTotalsList, SDTotalsList, SchoolTotalsList,
                    EXTotalsList, Quit);

  FreeTList(GeneralTotalsList, SizeOf(GeneralAssessmentTotRecord));
  FreeTList(SDTotalsList, SizeOf(SDistTotRecord));
  FreeTList(SchoolTotalsList, SizeOf(SchoolTotRecord));
  FreeTList(EXTotalsList, SizeOf(ExemptTotRecord));

  Application.ProcessMessages;

end;  {SortFiles}

{=====================================================================}
Procedure TfmCoopAssessmentRoll.PrintButtonClick(Sender: TObject);

var
  TextFileName, NewFileName : String;
  I : Integer;
  HeaderFileName, GeneralFileName,
  EXFileName, SDFileName, SpecialFeeFileName : String;

  GeneralTotFileName,
  SDTotFileName,
  SchoolTotFileName,
  EXTotFileName,
  SpecialFeeTotFileName : String;

  ReducedSize, OKToStartPrinting,
  Quit : Boolean;
  ShortRollType : String;  {For naming files - 'TN' or 'FI'}
  RollTypeStr : String;
  ParcelTable : TTable;
  UniformPercentOfValue, EqualizationRate : Real;
  DuplexType : TDuplex;
  SpreadsheetFileName : String;
  IncludeInventory, OverridePrintingDefaults : Boolean;
  ExtractDir, RPS995FileName, RPS060FileName,
  MailSubject, ZipFileName : String;
  SelectedFiles : TStringList;
  PrintToScreen : Boolean;

begin
  ParcelTable := nil;
  ReducedSize := False;
  DuplexType := dupSimplex;
  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;
  OKToStartPrinting := True;
  GlblCurrentTabNo := 0;
  PrintZoningCode := PrintZoningCodeCheckBox.Checked;
  PrintAdditionalLots := PrintAdditionalLotsCheckBox.Checked;
  UseNassauPrintKeyFormat := UseNassauPrintKeyFormatCheckBox.Checked;
  SuppressSDExtensions := SuppressSDExtensionsCheckBox.Checked;

    {Set the print index.}

  If OKToStartPrinting
    then
      {FXX05061998-4: In order to avoid having 2 sets of keys - one
                      starting with swis and one with school\swis,
                      I created a dummy SchoolCodeKey field which is blank
                      in a municipal billing and has no effect and filled
                      in in a school billing.  We can't just use the regular
                      school code field since we need it in municipal billings
                      to show what school this is.}

        {CHG04042004-1(2.07l2): Allow for Nassau formatting and ordering on assessment roll.}

      with BLHeaderTaxTable do
        case IndexRadioGroup.ItemIndex of
          0 : If UseNassauPrintKeyFormat
                then IndexName := 'BYSCHOOL_SWIS_RS_PRINTKEY'
                else IndexName := 'BYSCHOOL_SWIS_RS_SBL';
          1 : IndexName := 'BYSCHOOL_SWIS_RS_NAME';
          2 : IndexName := 'BYSCHOOL_SWIS_RS_ADDR';
          else
            begin
              MessageDlg('You must select a print order for the roll.',
                         mtError, [mbOK], 0);
              OKToStartPrinting := False;
            end;

        end;  {case IndexRadioGroup.ItemIndex of}

  If OKToStartPrinting
    then
      case RollTypeRadioGroup.ItemIndex of
        0 : begin
              RollTypeStr := 'tentative';
              ShortRollType := 'TN';
            end;

        1 : begin
              RollTypeStr := 'final';
              ShortRollType := 'FI';
            end;

        else
          begin
            MessageDlg('You must select a roll type.',
                       mtError, [mbOK], 0);
            OKToStartPrinting := False;
          end;

      end;  {case RollTypeRadioGroup.ItemIndex of}

    {They must select a collection type.}

  If OKToStartPrinting
    then
      begin
          {FXX06031999-1: Option to print uniform % of value.}

        PrintUniformPercentOfValue := UniformPercentOfValueCheckBox.Checked;

          {CHG03232004-1(2.08): Fix up taxable value type selection \ printing on rolls.
                                This means that there is only one collection type - 'MU'.
                                So, the user no longer needs to choose.}

        CollectionType := 'MU';

(*        If (CollectionTypeLookup.Text = 'Municipal')
          then CollectionType := 'MU';

        If (CollectionTypeLookup.Text = 'School')
          then CollectionType := 'SC';

        If (CollectionTypeLookup.Text = 'Village')
          then CollectionType := 'MU';

        If (Deblank(CollectionType) = '')
          then
            begin
              OKToStartPrinting := False;
              MessageDlg('Please select a collection type.', mtError, [mbOK], 0);
            end; *)

      end;  {If OKToStartPrinting}

    {FXX06181999-12: Allow the user to select the date of the roll printing.}

  If OKToStartPrinting
    then
      try
        RollPrintingDate := StrToDate(DatePrintedEdit.Text);
      except
        MessageDlg('Please enter a valid tax roll printing date.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

    {CHG01121998-1: Allow for the user to choose roll of This Year or
                    Next Year.}
    {FXX01201998-5: Actually, don't let them choose the assessment year -
                    always use TY amounts since this is what will be billed.
                    However, I will leave all the logic in place in case there
                    is a municipality where this is not the case.}

  If OKToStartPrinting
    then
      begin
          {CHG04032000-1: Print full market value on rolls.}
        GlblPrintFullMarketValue := PrintFullMarketValueCheckBox.Checked;

         {FXX01232000-2: Allow select of swis \ school codes for assessment roll.}

        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        SelectedSchoolCodes.Clear;

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

          {FXX05221998-3: The assessment roll is off of next year.}
          {CHG07172004-3(2.08): Allow print of history assessment rolls.
                                We must set a filter on all year based code
                                tables in order to do this.}

        RollPrintingYear := EditTaxRollYear.Text;
        PrintHistoryAssessmentRoll := PrintHistoryRollCheckBox.Checked;

        If ((RollPrintingYear <> GlblThisYear) and
            (RollPrintingYear <> GlblNextYear) and
            PrintHistoryAssessmentRoll)
          then
            begin
              ProcessingType := History;
              TaxRollYear := RollPrintingYear;
              GlblHistYear := TaxRollYear;
              ParcelTable := TYParcelTable;
            end
          else
            If GlblIsWestchesterCounty
              then
                begin
                  ProcessingType := NextYear;
                  TaxRollYear := GlblNextYear;
                  ParcelTable := NYParcelTable;

                end
              else
                begin
                  ProcessingType := ThisYear;
                  TaxRollYear := GlblThisYear;
                  ParcelTable := TYParcelTable;
                end;

        If not NYParcelTable.Active
          then OpenTablesForForm(Self, ProcessingType);

          {Set the history filters.}

        If PrintHistoryAssessmentRoll
          then
            begin
              SetFilterForHistoryYear(SwisCodeTable, TaxRollYear);
              SetFilterForHistoryYear(SDCodeTable, TaxRollYear);
              SetFilterForHistoryYear(AssessmentYearCtlTable, TaxRollYear);
              SetFilterForHistoryYear(SchoolCodeTable, TaxRollYear);
              SetFilterForHistoryYear(EXCodeTable, TaxRollYear);

            end;  {If PrintHistoryAssessmentRoll}

          {FXX03241999-5: Need to make sure the NY parcel table is opened for
                          NextYear.}

        OpenTableForProcessingType(NYParcelTable, ParcelTableName, NextYear, Quit);

      end;  {If OKToStartPrinting}

    {FXX01201998-6: Let them choose the year that will appear on the roll.}

  If (OKToStartPrinting and
      (Deblank(EditTaxRollYear.Text) = ''))
    then
      begin
        OKToStartPrinting := False;
        MessageDlg('Please enter the assessment year that will appear on the roll.',
                   mtError, [mbOK], 0);
        EditTaxRollYear.SetFocus;

      end;  {If (OKToStartPrinting and ...}

    {FXX12171998-7: Make sure that the dates in the assessment year control
                    file are filled in and the uniform % of value.}
    {FXX07191999-6: Display all info for verification before printing.}

  If OKToStartPrinting
    then OKToStartPrinting := VerifyDatesAndPercentOfValueFilledIn(AssessmentYearCtlTable,
                                                                   SwisCodeTable,
                                                                   UniformPercentOfValue,
                                                                   EqualizationRate);

  If (OKToStartPrinting and
      (not ConfirmRollSetup(AssessmentYearCtlTable, EXCodeTable, SwisCodeTable,
                            RollTypeStr, 'print', DatePrintedEdit.Text)))
    then OKToStartPrinting := False;

    {If they entered a collection that exists, then open the billing and
     totals files, get the rates, and start the billing.}

  Quit := False;

    {CHG05292001-1: Add totals by coop.}

  PrintCoopTotals := PrintCoopTotalsCheckBox.Checked;
  CoopTotalsList := TList.Create;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}
    {CHG12182003-1(2.07l): Add printing default options.}

  try
    OverridePrintingDefaults := OverridePrinterDefaultsCheckBox.Checked;
  except
    OverridePrintingDefaults := False;
  end;

  SetPrintToScreenDefault(PrintDialog);

  If (OKToStartPrinting and
      (OverridePrintingDefaults or
       PrintDialog.Execute))
    then
      begin
          {CHG07162002-1: Send assessment roll to Excel.}

        PrintToExcel := PrintToExcelCheckBox.Checked;

        SetRollTabs(GlblReportReprintLeftMargin);

        If PrintToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

                {Write the headers.}

              Write(ExtractFile, 'SwisCode,',
                                 'SBL,',
                                 'ParcelID,',
                                 'CheckDigit,',
                                 'NameAddr1,',
                                 'NameAddr2,',
                                 'NameAddr3,',
                                 'NameAddr4,',
                                 'NameAddr5,',
                                 'NameAddr6,',
                                 'LegalAddress,',
                                 'PropertyClass,',
                                 'PropertyClassDesc,',
                                 'SchoolCode,',
                                 'SchoolDistrictName,',
                                 'OldParcelID,',
                                 'Acreage,',
                                 'Frontage,',
                                 'Depth,',
                                 'EastCoord,',
                                 'NorthCoord,',
                                 'DeedBook,',
                                 'DeedPage,',
                                 'BankCode,',
                                 'HomesteadCode,',
                                 'AccountNumber,',
                                 'PropertyDescription1,',
                                 'PropertyDescription2,',
                                 'PropertyDescription3,');

                {CHG03082003-1: Allow for printing zoning code on the roll and in
                                the extract.}

              If PrintZoningCode
                then Write(ExtractFile, 'Zoning,');

              Write(ExtractFile, 'LandValue,',
                                 'TotalValue,',
                                 'FullMarketValue,',
                                 'CountyTaxableValue,',
                                 'TownTaxableValue,',
                                 'SchoolTaxableValue,',
                                 'VillageTaxableValue');

                {Now allow 8 slots for exemptions.}

              For I := 1 to 8 do
                Write(ExtractFile, ',ExCode' + IntToStr(I) + ',',
                                   'ExDesc' + IntToStr(I) + ',',
                                   'ExCountyAmount' + IntToStr(I) + ',',
                                   'ExTownAmount' + IntToStr(I) + ',',
                                   'ExSchoolAmount' + IntToStr(I));

              MaxSpecialDistricts := GetRecordCount(SDCodeTable);

              For I := 1 to MaxSpecialDistricts do
                Write(ExtractFile, ',SDCode' + IntToStr(I) + ',',
                                   'SDDesc' + IntToStr(I) + ',',
                                   'SDExtension' + IntToStr(I) + ',',
                                   'SD_CMFlag' + IntToStr(I) + ',',
                                   'SDAmount' + IntToStr(I) + ',');

              Writeln(ExtractFile);

            end;  {If PrintToExcel}

          {FXX02172000-3: Disable print button in assessment roll.}

        PrintButton.Enabled := False;

          {FXX10071999-1: To solve the problem of printing to the high speed,
                          we need to set the font to a TrueType even though it
                          doesn't matter in the actual printing.  The reason for this
                          is that without setting it, the default font is System for
                          the Generic printer which has a baseline descent of 0.5
                          which messes up printing to a text file.  We needed a font
                          with no descent.}

        TextFiler.SetFont('Courier New', 10);

        Quit := False;
        NumParcelsPrinted := 0;
        PrintingCancelled := False;
        case RollTypeRadioGroup.ItemIndex of
          0 : RollType := 'T';
          1 : RollType := 'F';
        end;

          {CHG10302000-1: Need to allow user to specify exactly which municipalities
                          print on the roll.}

        MunicipalitiesToPrint := [];

        If CountyCheckBox.Checked
          then MunicipalitiesToPrint := MunicipalitiesToPrint + [mtpCounty];

        If MunicipalCheckBox.Checked
          then MunicipalitiesToPrint := MunicipalitiesToPrint + [mtpTown];

        If SchoolCheckBox.Checked
          then MunicipalitiesToPrint := MunicipalitiesToPrint + [mtpSchool];

          {CHG03232004-1(2.08): Fix up taxable value type selection \ printing on rolls.}

        If PartialVillageCheckBox.Checked
          then MunicipalitiesToPrint := MunicipalitiesToPrint + [mtpPartialVillage];

        If (MunicipalitiesToPrint = [mtpPartialVillage])
          then CollectionType := VillageTaxType;

        PrintPermits := PrintPermitsCheckBox.Checked;

          {CHG02122000-1: Allow them to edit the title on the tax roll.}

        RollHeaderTitle := GetRollHeaderTitle(RollType, CollectionType,
                                              RollPrintingYear);

        LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
        OpenTableForProcessingType(TYParcelTable, ParcelTableName,
                                   ThisYear, Quit);

          {Create the rate lists.}

        GeneralRateList := TList.Create;
        SDRateList := TList.Create;
        SpecialFeeRateList := TList.Create;

          {Description lists}

        SDExtCategoryList := TList.Create;
        PropertyClassDescList := TList.Create;
        EXCodeDescList := TList.Create;
        SDCodeDescList := TList.Create;
        SwisCodeDescList := TList.Create;
        SchoolCodeDescList := TList.Create;
        SDExtCodeDescList := TList.Create;
        RollSectionDescList := TList.Create;

        ChDir(ExpandPASPath(GlblDataDir));

        BLHeaderTaxTable.Close;
        BLGeneralTaxTable.Close;
        BLExemptionTaxTable.Close;
        BLSpecialDistrictTaxTable.Close;
        BLSpecialFeeTaxTable.Close;

        BLHeaderTaxTable.TableName := OrigHeaderFileName;
        BLGeneralTaxTable.TableName := OrigGeneralFileName;
        BLExemptionTaxTable.TableName := OrigEXFileName;
        BLSpecialDistrictTaxTable.TableName := OrigSDFileName;
        BLSpecialFeeTaxTable.TableName := OrigSpecialFeeFileName;

          {CHG07172004-3(2.08): Allow print of history assessment rolls.}

        CopyAndOpenBillingFiles(TaxRollYear, CollectionType, ShortRollType,
                                BLHeaderTaxTable,
                                BLGeneralTaxTable, BLExemptionTaxTable,
                                BLSpecialDistrictTaxTable,
                                BLSpecialFeeTaxTable,
                                HeaderFileName, GeneralFileName, EXFileName,
                                SDFileName, SpecialFeeFileName,
                                (not PrintHistoryAssessmentRoll), Quit);

          {Get the file names and open the totals files for this
           tax year\municipal type\collection #.}

        If not Quit
          then
            begin
              GeneralTotalsTable.Close;
              SDTotalsTable.Close;
              SchoolTotalsTable.Close;
              EXTotalsTable.Close;
              SpecialFeeTotalsTable.Close;

              GeneralTotalsTable.TableName := OrigGeneralTotFileName;
              SDTotalsTable.TableName := OrigSDTotFileName;
              SchoolTotalsTable.TableName := OrigSchoolTotFileName;
              EXTotalsTable.TableName := OrigEXTotFileName;
              SpecialFeeTotalsTable.TableName := OrigSpecialFeeTotFileName;

              CopyAndOpenTotalsFiles(TaxRollYear, CollectionType, ShortRollType,
                                     RollType, GeneralTotalsTable, SDTotalsTable,
                                     SchoolTotalsTable, EXTotalsTable,
                                     SpecialFeeTotalsTable,
                                     GeneralTotFileName, SchoolTotFileName,
                                     SDTotFileName, EXTotFileName,
                                     SpecialFeeTotFileName, True,
                                     (not PrintHistoryAssessmentRoll), Quit);

            end;  {If not Quit}

          {Now load the rate and description lists.}

        If not Quit
          then
            begin
              SelectedRollSections := TStringList.Create;

              with RollSectionListBox do
                For I := 0 to (Items.Count - 1) do
                  If Selected[I]
                    then SelectedRollSections.Add(Take(1, Items[I]));

                {Note that we do not actually load any rates - just
                 dummy up four general entries - county, town, school,
                 village tv and for the SD's, the descriptions.}
                {FXX12262001-1: Only load the rate with the first 2 digits of
                                the swis to handle villages that go across 2 towns
                                like Pomona.}

              LoadGeneralRateList(Take(2, TYParcelTable.FieldByName('SwisCode').Text),
                                  GeneralRateList, CollectionType);
              LoadSDRateList(SDRateList, SelectedRollSections, Quit);

              LoadSDExtCategoryList(SDExtCategoryList, Quit);

              LoadCodeList(PropertyClassDescList, 'ZPropClsTbl',
                           'MainCode', 'Description', Quit);

              LoadCodeList(EXCodeDescList, 'TExCodeTbl',
                           'ExCode', 'Description', Quit);

              LoadCodeList(SDCodeDescList, 'TSDCodeTbl',
                           'SDistCode', 'Description', Quit);

              LoadCodeList(RollSectionDescList, 'ZRollSectionTbl',
                           'MainCode', 'Description', Quit);

              LoadCodeListWithProcessingType(SwisCodeDescList, 'TSwisTbl',
                                             'SwisCode', 'MunicipalityName',
                                             ProcessingType, Quit);

              If PrintHistoryAssessmentRoll
                then SetFilterForHistoryYear(SwisCodeTable, TaxRollYear);

              LoadCodeList(SchoolCodeDescList, 'TSchoolTbl',
                           'SchoolCode', 'SchoolName', Quit);

              LoadCodeList(SDExtCodeDescList, 'ZSDExtCodeTbl',
                           'MainCode', 'Description', Quit);

            end;  {If not Quit}

          {Now, print the roll.}
          {CHG08181999-1: Automatically print the totals and the full roll.}
          {First print a totals report.}

        If not Quit
          then
            begin
               {CHG10131998-1: Set the printer settings based on what printer they selected
                               only - they no longer need to worry about paper or landscape
                               mode.}

                {FXX12291999-1: Allow them to specify the number of blank lines at
                                the bottom of the roll. Note that we can tell if it
                                is going to a dot matrix or laser jet by looking at the
                                print orientation - it will be landscape for laser and
                                portrait for dot matrix.}

              ReducedSize := False;
              DuplexType := dupSimplex;

                {FXX06032002-1: The AssignPrinterSettings call was missing here.}

              If OverridePrintingDefaults
                then
                  begin
                    If PrinterSettingsTable.Modified
                      then
                        try
                          PrinterSettingsTable.Post;
                        except
                        end;

                    SetPrinterOverrides(PrinterSettingsTable, ReportPrinter, ReportFiler,
                                        PrintToScreenCheckBox, PrintToScreen,
                                        LinesAtBottom, NumLinesPerPage);

                  end
                else
                  begin
                    PrintToScreen := PrintDialog.PrintToFile;
                    AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

                    If (ReportPrinter.Orientation = poLandscape)
                      then
                        begin
                          If (MessageDlg('Do you want to print on letter size paper?',
                                         mtConfirmation, [mbYes, mbNo], 0) = idYes)
                            then
                              begin
                                ReducedSize := True;
                                ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
                                ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                                ReportPrinter.Orientation := poLandscape;
                                ReportFiler.Orientation := poLandscape;

                                If (ReportPrinter.SupportDuplex and
                                    (MessageDlg('Do you want to print on both sides of the paper?',
                                                mtConfirmation, [mbYes, mbNo], 0) = idYes))
                                  then
                                    If (MessageDlg('Do you want to vertically duplex this report?',
                                                    mtConfirmation, [mbYes, mbNo], 0) = idYes)
                                      then
                                        begin
                                          ReportPrinter.Duplex := dupVertical;
                                          DuplexType := dupVertical;
                                        end
                                      else
                                        begin
                                          ReportPrinter.Duplex := dupHorizontal;
                                          DuplexType := dupHorizontal;
                                        end;

                                NumLinesPerPage := 66;
                                ReportPrinter.ScaleX := 90;
                                ReportPrinter.ScaleY := 70;
      (*                          ReportPrinter.SectionLeft := 1.5;*)
                                ReportFiler.ScaleX := 90;
                                ReportFiler.ScaleY := 70;
      (*                          ReportFiler.SectionLeft := 1.5;*)
                                LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
                              end
                            else
                              begin
                                LinesAtBottom := GlblLinesLeftOnRollLaserJet;
                                NumLinesPerPage := 51;
                              end;

                        end
                      else
                        begin
                          LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
                          NumLinesPerPage := 66;
                        end;

                  end;  {else of If OverridePrintingDefaults}

              MessageDlg('The assessment roll totals will be printed first, followed by the full roll.' + #13 +
                         'You will have the option of whether or not to print the whole roll before' +
                         ' it is printed.' + #13 + 'Click OK to start printing.',
                         mtInformation, [mbOK], 0);
              TotalsOnly := True;

              PrintingCancelled := False;
              GlblPreviewPrint := False;

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

              If not Quit
                then
                  begin
                    If not PrintHistoryAssessmentRoll
                      then SortFiles(GeneralRateList, SDRateList, SDExtCategoryList,
                                     ParcelTable, TaxRollYear, ProcessingType, Quit);

                      {FXX07221998-1: So that more than one person can run the report
                                      at once, use a time based name first and then
                                      rename.}

                    TextFileName := GetPrintFileName(Self.Caption, True);
                    TextFiler.FileName := TextFileName;

                      {FXX01211998-1: Need to set the LastPage property so that
                                      long rolls aren't a problem.}

                    TextFiler.LastPage := 30000;

                    TextFiler.Execute;
                    ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                      {If they want to see it on the screen, start the preview.}

                    If PrintToScreen
                      then
                        begin
                          GlblPreviewPrint := True;
                          NewFileName := GetPrintFileName(Self.Caption, True);
                          ReportFiler.FileName := NewFileName;

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
                      else
                        begin
                          ReportPrinter.ResetPrinter;
                          ReportPrinter.Execute;
                        end;

                      {CHG01182000-3: Allow them to choose a different name or copy right away.}

                    ShowReportDialog(ShortRollType + 'ROLTOT.RPT', TextFiler.FileName, True);

                  end;  {If not PrintingCancelled}

            end;  {If not Quit}

          {Now print the full roll if they want it.}

        If ((not Quit) and
            (MessageDlg('Do you want to print the whole assessment roll?', mtConfirmation, [mbYes, mbNo], 0) =
             idYes) and
            (OverridePrintingDefaults or
              PrintDialog.Execute))
          then
            begin
              ProgressDialog.Reset;
              ProgressDialog.TotalNumRecords := GetRecordCount(BLHeaderTaxTable);
              TotalsOnly := False;
              PrintingCancelled := False;

              GlblPreviewPrint := False;

               {CHG10131998-1: Set the printer settings based on what printer they selected
                               only - they no longer need to worry about paper or landscape
                               mode.}

                {FXX06032002-1: The AssignPrinterSettings call was missing here.}

              If OverridePrintingDefaults
                then SetPrinterOverrides(PrinterSettingsTable, ReportPrinter, ReportFiler,
                                         PrintToScreenCheckBox, PrintToScreen,
                                         LinesAtBottom, NumLinesPerPage)
                else
                  begin
                    PrintToScreen := PrintDialog.PrintToFile;
                    AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

                    If (ReportPrinter.Orientation = poLandscape)
                      then
                        begin
                          If ReducedSize
                            then
                              begin
                                ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
                                ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                                ReportPrinter.Orientation := poLandscape;
                                ReportFiler.Orientation := poLandscape;

                                If ReportPrinter.SupportDuplex
                                  then ReportPrinter.Duplex := DuplexType;

                                ReportPrinter.ScaleX := 90;
                                ReportPrinter.ScaleY := 75;
                                ReportFiler.ScaleX := 90;
                                ReportFiler.ScaleY := 75;
                                LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
                              end
                            else LinesAtBottom := GlblLinesLeftOnRollLaserJet;

                        end
                      else LinesAtBottom := GlblLinesLeftOnRollDotMatrix;

                  end;  {else of If OverridePrintingDefaults}

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

              If not Quit
                then
                  begin
                      {FXX07221998-1: So that more than one person can run the report
                                      at once, use a time based name first and then
                                      rename.}

                    TextFileName := GetPrintFileName(Self.Caption, True);
                    TextFiler.FileName := TextFileName;

                      {FXX01211998-1: Need to set the LastPage property so that
                                      long rolls aren't a problem.}

                    TextFiler.LastPage := 30000;

                    TextFiler.Execute;
                    ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                      {If they want to see it on the screen, start the preview.}

                    If PrintToScreen
                      then
                        begin
                          GlblPreviewPrint := True;
                          NewFileName := GetPrintFileName(Self.Caption, True);
                          ReportFiler.FileName := NewFileName;

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
                      else
                        begin
                          ReportPrinter.ResetPrinter;
                          ReportPrinter.Execute;
                        end;

                      {CHG01182000-3: Allow them to choose a different name or copy right away.}

                    ShowReportDialog(ShortRollType + 'ROLL.RPT', TextFiler.FileName, True);

                  end;  {If not PrintingCancelled}

            end;  {If ((not (Quit or PrintingCancelled)) and ...}

        ProgressDialog.Finish;
        SelectedRollSections.Free;
        PrintButton.Enabled := True;

        If not (Quit or PrintingCancelled)
          then MessageDlg('The roll was printed sucessfully.' + #13 +
                          'There were ' + IntToStr(NumParcelsPrinted) + ' parcels in this roll printing.',
                          mtInformation, [mbOK], 0)
          else MessageDlg('The roll was NOT printed successfully.',
                          mtError, [mbOK], 0);

          {CHG06282002-1: After tenative roll in Westchester, see if they
                          want the searchers to see the NY values.}

        If ((RollType = 'T') and
            GlblIsWestchesterCounty and
            (not (Quit or PrintingCancelled)) and
            (MessageDlg('Do you want to make it so that searchers can now see the Next Year values?',
                        mtConfirmation, [mbYes, mbNo], 0) = idYes))
          then
            with SystemTable do
              try
                Open;
                Edit;
                FieldByName('SearcherCanViewNY').AsBoolean := True;
                Post;
              except
              end;

          {CHG04232003-1(2.07): The state now requires a 995 after tentative roll.}

        If (RollType = 'T')
          then
            If (MessageDlg('New York State ORPS now requires that a full file extract be sent to them after tentative roll.' + #13 +
                           'Do you wish to send the file now?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
              then
                begin
                  IncludeInventory := (MessageDlg('Do you wish to include parcel inventory in the extract?',
                                                  mtConfirmation, [mbYes, mbNo], 0) = idYes);

                  Generate995File(Self, SelectedSwisCodes, 'RPS995T1',
                                   ftParcelAndSales, False,
                                   GlblIsWestchesterCounty,
                                   IncludeInventory, False, True, False,
                                   ProgressDialog, ZipCopyDlg);


                  If (MessageDlg('Do you want to email this file?' + #13 +
                                 'Please note this works only for Microsoft Outlook at this point.', mtConfirmation, [mbYes, mbNo], 0) = idYes)
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

                        EMailFile(Self, ExtractDir, ExtractDir, ZipFileName, MailSubject, SelectedFiles, True);
                        SelectedFiles.Free;

                      end;  {If (MessageDlg('Do you want to email this file?' + #13 +}

                end
              else MessageDlg('In order to create the full file extract at a later date, please ' + #13 +
                              ' go to the' + '''' +
                              ' Import\Export' + '''' +
                              ' menu and select ' + '''' +
                              'Full File Extract (995)' + '''' + '.',
                              mtInformation, [mbOK], 0);

          {Close the billing files.}

        BLHeaderTaxTable.Close;
        BLGeneralTaxTable.Close;
        BLExemptionTaxTable.Close;
        BLSpecialDistrictTaxTable.Close;
        BLSpecialFeeTaxTable.Close;
        GeneralTotalsTable.Close;
        SchoolTotalsTable.Close;
        EXTotalsTable.Close;
        SDTotalsTable.Close;
        SpecialFeeTotalsTable.Close;

          {Finally free up the rate and totals TLists.}

        FreeTList(GeneralRateList, SizeOf(GeneralRateRecord));
        FreeTList(SDRateList, SizeOf(SDRateRecord));
        FreeTList(SpecialFeeRateList, SizeOf(SpecialFeeRecord));

        FreeTList(SDExtCategoryList, SizeOf(SDExtCategoryRecord));

          {FXX01191998-2: Freeing the wrong record size.}

        FreeTList(RollSectionDescList, SizeOf(CodeRecord));
        FreeTList(EXCodeDescList, SizeOf(CodeRecord));
        FreeTList(SDCodeDescList, SizeOf(CodeRecord));
        FreeTList(SwisCodeDescList, SizeOf(CodeRecord));
        FreeTList(SchoolCodeDescList, SizeOf(CodeRecord));
        FreeTList(SDExtCodeDescList, SizeOf(CodeRecord));
        FreeTList(PropertyClassDescList, SizeOf(CodeRecord));

          {Delete the temporary files.}
          {FXX02172000-4: Not deleting files properly.}

        try
          Chdir(GlblDataDir);
          OldDeleteFile(Copy(HeaderFileName, 1, 12));
          OldDeleteFile(Copy( GeneralFileName, 1, 12));
          OldDeleteFile(Copy(EXFileName, 1, 12));
          OldDeleteFile(Copy(SDFileName, 1, 12));
          OldDeleteFile(Copy(SpecialFeeFileName, 1, 12));
          OldDeleteFile(Copy(GeneralTotFileName, 1, 12));
          OldDeleteFile(Copy(SDTotFileName, 1, 12));
          OldDeleteFile(Copy(SchoolTotFileName, 1, 12));
          OldDeleteFile(Copy(EXTotFileName, 1, 12));
          OldDeleteFile(Copy(SpecialFeeTotFileName, 1, 12));
        except
          Chdir(GlblProgramDir);
        end;

        ResetPrinter(ReportPrinter);

          {CHG07162002-1: Send assessment roll to Excel.}

        If PrintToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If PrintToExcel}

      end;  {If OKToStartPrinting}

  SelectedSwisCodes.Free;
  SelectedSchoolCodes.Free;
  FreeTList(CoopTotalsList, SizeOf(CoopTotalsRecord));
(*  CloseFile(CalcMessageFile);*)

end;  {PrintButtonClick}

{===================================================================}
Function TfmCoopAssessmentRoll.ParcelShouldBePrinted : Boolean;

{We should print this parcel if
  1. They are not showing just roll totals.}

begin
  Result := True;

    {If they only want totals, don't print the parcel.}

  If TotalsOnly
    then Result := False;

end;  {ParcelShouldBePrinted}

{===================================================================}
Procedure TfmCoopAssessmentRoll.AddRecordToExtractFile(var ExtractFile : TextFile;
                                                         BLHeaderTaxTable : TTable;
                                                         GnTaxList,
                                                         ExTaxList,
                                                         SDTaxList : TList);

var
  NAddrArray : NameAddrArray;
  I, ExemptionsExtracted, SpecialDistrictsExtracted : Integer;
  TempStr, TempSDAmount,
  PropertyClassDescription, SchoolName : String;
  FullMarketValue : Extended;

begin
    {Add the general information first.}

  with BLHeaderTaxTable do
    begin
      Write(ExtractFile, FieldByName('SwisCode').Text,
                         '''' +
                         FormatExtractField(FieldByName('SBLKey').Text) +
                         '''',
                         FormatExtractField(ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text)),
                         FormatExtractField(FieldByName('CheckDigit').Text));

      GetNameAddress(BLHeaderTaxTable, NAddrArray);

      For I := 1 to 6 do
        Write(ExtractFile, FormatExtractField(NAddrArray[I]));

      PropertyClassDescription := UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                                   PropertyClassDescList));

      SchoolName := UpcaseStr(GetDescriptionFromList(FieldByName('SchoolDistCode').Text,
                                                     SchoolCodeDescList));

      FindKeyOld(SwisCodeTable, ['SwisCode'], [FieldByName('SwisCode').Text]);
      (*UniformPercentOfValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat; *)
      FullMarketValue := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                           FieldByName('NonhstdTotalVal').AsFloat),
                                          SwisCodeTable,
                                          FieldByName('PropertyClassCode').Text,
                                          ' ', True);

      Write(ExtractFile, FormatExtractField(GetLegalAddressFromTable(BLHeaderTaxTable)),
                         FormatExtractField(FieldByName('PropertyClassCode').Text),
                         FormatExtractField(PropertyClassDescription),
                         FormatExtractField(FieldByName('SchoolDistCode').Text),
                         FormatExtractField(SchoolName),
                         FormatExtractField(''),  {Old ID not used for now.}
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        (FieldByName('HstdAcreage').AsFloat +
                                                         FieldByName('NonhstdAcreage').AsFloat))),
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        FieldByName('Frontage').AsFloat)),
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        FieldByName('Depth').AsFloat)),
                         FormatExtractField(FieldByName('GridCordEast').Text),
                         FormatExtractField(FieldByName('GridCordNorth').Text),
                         FormatExtractField(FieldByName('DeedBook').Text),
                         FormatExtractField(FieldByName('DeedPage').Text),
                         FormatExtractField(FieldByName('BankCode').Text),
                         FormatExtractField(FieldByName('HomesteadCode').Text),
                         FormatExtractField(FieldByName('AccountNumber').Text),
                         FormatExtractField(FieldByName('PropDescr1').Text),
                         FormatExtractField(FieldByName('PropDescr2').Text),
                         FormatExtractField(FieldByName('PropDescr3').Text));

        {CHG03082003-1: Allow for printing zoning code on the roll and in
                        the extract.}

      If PrintZoningCode
        then
          try
            Write(ExtractFile, FormatExtractField(FieldByName('ZoningCode').Text));
          except
            Write(ExtractFile, FormatExtractField(''));
          end;

      Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        (FieldByName('HstdLandVal').AsFloat +
                                                         FieldByName('NonhstdLandVal').AsFloat))),
                         FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        (FieldByName('HstdTotalVal').AsFloat +
                                                         FieldByName('NonhstdTotalVal').AsFloat))),
                         FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        FullMarketValue)));

        {First try to find the county taxable.  Otherwise, leave it blank.}

      TempStr := '';
      For I := 0 to (GnTaxList.Count - 1) do
        with GeneralTaxPtr(GnTaxList[I])^ do
          If (GeneralTaxType = 'CO')
            then TempStr := FormatFloat(NoDecimalDisplay, TaxableVal);
      Write(ExtractFile, FormatExtractField(TempStr));

        {Next try to find the town taxable.  Otherwise, leave it blank.}

      TempStr := '';
      For I := 0 to (GnTaxList.Count - 1) do
        with GeneralTaxPtr(GnTaxList[I])^ do
          If (GeneralTaxType = 'TO')
            then TempStr := FormatFloat(NoDecimalDisplay, TaxableVal);
      Write(ExtractFile, FormatExtractField(TempStr));

        {Next try to find the school taxable.  Otherwise, leave it blank.}

      TempStr := '';
      For I := 0 to (GnTaxList.Count - 1) do
        with GeneralTaxPtr(GnTaxList[I])^ do
          If (GeneralTaxType = 'SC')
            then TempStr := FormatFloat(NoDecimalDisplay, TaxableVal);
      Write(ExtractFile, FormatExtractField(TempStr));

        {Leave the village taxable blank.}

      Write(ExtractFile, FormatExtractField(''));

    end;  {with BLHeaderTaxTable do}

    {Now do the exemptions.}

  ExemptionsExtracted := 0;

  For I := 0 to (EXTaxList.Count - 1) do
    with ExemptTaxPtr(ExTaxList[I])^ do
      begin
        Write(ExtractFile, FormatExtractField(EXCode),
                           FormatExtractField(Description),
                           FormatExtractField(FormatFloat(CurrencyEditDisplay,
                                                          CountyAmount)),
                           FormatExtractField(FormatFloat(CurrencyEditDisplay,
                                                          TownAmount)),
                           FormatExtractField(FormatFloat(CurrencyEditDisplay,
                                                          SchoolAmount)));

        ExemptionsExtracted := ExemptionsExtracted + 1;

      end;  {with ExemptTaxRecord(ExTaxList)^ do}

  For I := (ExemptionsExtracted + 1) to 8 do
    Write(ExtractFile, FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''));

    {Now write special districts.}

  SpecialDistrictsExtracted := 0;

  For I := 0 to (SDTaxList.Count - 1) do
    with SDistTaxPtr(SDTaxList[I])^ do
      begin
        If (ExtCode = 'TO')
          then TempSDAmount := FormatFloat(NoDecimalDisplay,
                                           SDAmount)
          else TempSDAmount := FormatFloat(DecimalEditDisplay,
                                           SDAmount);

        Write(ExtractFile, FormatExtractField(SDistCode),
                           FormatExtractField(Description),
                           FormatExtractField(ExtCode),
                           FormatExtractField(CMFlag),
                           FormatExtractField(TempSDAmount));

        SpecialDistrictsExtracted := SpecialDistrictsExtracted + 1;

      end;  {For I := 0 to (MaxSpecialDistricts - 1) do}

  For I := (SpecialDistrictsExtracted + 1) to (MaxSpecialDistricts - 1) do
    Write(ExtractFile, FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''));

  Writeln(ExtractFile);

end;  {AddRecordToExtractFile}

{===================================================================}
{=====================  PRINTING LOGIC  ============================}
{===================================================================}
Procedure TfmCoopAssessmentRoll.TextFilerBeforePrint(Sender: TObject);

begin
  GlblCurrentTabNo := 1;
  GlblCurrentLinePos := 1;

  with Sender as TBaseReport do
    begin
      NumColsPerPage := 130;

         {Get the first record.}

      try
        BLHeaderTaxTable.First;
      except
        SystemSupport(054, BLHeaderTaxTable, 'Error getting first Billing Record.',
                      UnitName, GlblErrorDlgBox);
        Abort;
      end;

      with BLHeaderTaxTable do
        begin
          LastSwisCode := FieldByName('SwisCode').Text;
          LastSchoolCode := FieldByName('SchoolDistCode').Text;
          LastRollSection := FieldByName('RollSection').Text;

        end;  {with BLHeaderTaxTable do}

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerBeforePrint}

{===============================================================}
Procedure TfmCoopAssessmentRoll.TextFilerPrint(Sender: TObject);

var
  ParcelSubheaderPrinted,
  FirstTimeThrough,
  ParcelPrintedThisPage,  {Has a parcel been printed on this page?}
  TotalsPrinted, Quit, DoneWithReport : Boolean;
  SwisSBLKey : String;
  CurrentRollSection : String;
  CurrentSwisCode, CurrentSchoolCode : String;

  I, PageNo, LineNo, MaxLines : Integer;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  NumPrinted : LongInt;
  ParcelTable, CollectionLookupTable : TTable;
  CL1List,
  CL2List,
  CL3List,
  CL4List,
  CL5List,
  CL6List,
  CL7List,
  LineTypeList : TStringList;
  TotalAssessedVal : Comp;

begin
  LineNo := 1;
  PageNo := 1;
  DoneWithReport := False;
  Quit := False;
  ParcelSubheaderPrinted := False;
  FirstTimeThrough := True;

  If GlblIsWestchesterCounty
    then ParcelTable := NYParcelTable
    else ParcelTable := TYParcelTable;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;
  ParcelPrintedThisPage := False;

    {create string list for each bill image}
    {columns 1 -7 spread across each line of tax bill}

  CL1List := TStringList.Create;
  CL2List := TStringList.Create;
  CL3List := TStringList.Create;
  CL4List := TStringList.Create;
  CL5List := TStringList.Create;
  CL6List := TStringList.Create;
  CL7List := TStringList.Create;
  LineTypeList := TStringList.Create;

  SequenceStr := 'PARCEL ID ORDER';

  with Sender as TBaseReport do
    begin
      Bold := False;

      PrintRollHeader(Sender, RollType, LastSchoolCode, LastSwisCode,
                      LastRollSection, CollectionType, RollPrintingYear,
                      AssessmentYearCtlTable, SchoolCodeDescList,
                      SwisCodeDescList, SequenceStr, PageNo, LineNo);

       {Set up the tabs for the info.}

      ClearTabs;
      ProgressDialog.Start(GetRecordCount(BLHeaderTaxTable), True, True);

      repeat
        Application.ProcessMessages;

        If FirstTimeThrough
          then FirstTimeThrough := False
          else BLHeaderTaxTable.Next;

        PrintingCancelled := ProgressDialog.Cancelled;

          {If we have printed all the records, then we are done.}

        If (BLHeaderTaxTable.EOF or
            (Quit or PrintingCancelled))
          then DoneWithReport := True;

        with BLHeaderTaxTable do
          SwisSBLKey := Take(6, FieldByName('SwisCode').Text) +
                        Take(20, FieldByName('SBLKey').Text);

        ProgressDialog.UserLabelCaption := ConvertSwisSBLToDashDot(SwisSBLKey);

        TotalsPrinted := False;

          {Should we print the roll section totals?}
          {FXX04241998-1: Only load the roll sections that we want in this section
                          of the roll.}

        If (ShowRollSectionTotalsCheckBox.Checked and
            (DoneWithReport or
             ((Deblank(LastRollSection) <> '') and
              (LastRollSection <> CurrentRollSection))))
          then
            begin
              TotalsPrinted := True;

              PrintSectionTotals(Sender, RollType, 'R',
                                  LastRollSection,
                                  LastSwisCode, LastSchoolCode,
                                  GeneralRateList,
                                  SDRateList,
                                  SpecialFeeRateList,
                                  GnTaxList, SDTaxList,
                                  SpTaxList, ExTaxList,
                                  GeneralTotalsTable,
                                  SchoolTotalsTable,
                                  EXTotalsTable,
                                  SDTotalsTable,
                                  SpecialFeeTotalsTable,
                                  CollectionType,
                                  RollPrintingYear,
                                  SDCodeTable,
                                  AssessmentYearCtlTable,
                                  SDCodeDescList,
                                  SDExtCodeDescList,
                                  EXCodeDescList,
                                  SchoolCodeDescList,
                                  SwisCodeDescList,
                                  RollSectionDescList,
                                  SelectedRollSections,
                                  SequenceStr, ParcelPrintedThisPage,
                                  PageNo, LineNo, Quit);

            end;  {If (DoneWithReport or ...}

                {Should we print the swis totals?}

        If (DoneWithReport or
            ((Deblank(LastSwisCode) <> '') and
             (LastSwisCode <> CurrentSwisCode)))
          then
            begin
              TotalsPrinted := True;

              PrintSectionTotals(Sender, RollType, 'S',
                                  LastRollSection,
                                  LastSwisCode, LastSchoolCode,
                                  GeneralRateList,
                                  SDRateList,
                                  SpecialFeeRateList,
                                  GnTaxList, SDTaxList,
                                  SpTaxList, ExTaxList,
                                  GeneralTotalsTable,
                                  SchoolTotalsTable,
                                  EXTotalsTable,
                                  SDTotalsTable,
                                  SpecialFeeTotalsTable,
                                  CollectionType,
                                  RollPrintingYear,
                                  SDCodeTable,
                                  AssessmentYearCtlTable,
                                  SDCodeDescList,
                                  SDExtCodeDescList,
                                  EXCodeDescList,
                                  SchoolCodeDescList,
                                  SwisCodeDescList,
                                  RollSectionDescList,
                                  SelectedRollSections,
                                  SequenceStr, ParcelPrintedThisPage,
                                  PageNo, LineNo, Quit);

            end;  {If (DoneWithReport or ...}

          {Should we print the School totals?}

        If ((CollectionType = 'SC') and
            (DoneWithReport or
             ((Deblank(LastSchoolCode) <> '') and
              (LastSchoolCode <> CurrentSchoolCode))))
          then
            begin
              TotalsPrinted := True;

              PrintSectionTotals(Sender, RollType, 'C',
                                  LastRollSection,
                                  LastSwisCode, LastSchoolCode,
                                  GeneralRateList,
                                  SDRateList,
                                  SpecialFeeRateList,
                                  GnTaxList, SDTaxList,
                                  SpTaxList, ExTaxList,
                                  GeneralTotalsTable,
                                  SchoolTotalsTable,
                                  EXTotalsTable,
                                  SDTotalsTable,
                                  SpecialFeeTotalsTable,
                                  CollectionType,
                                  RollPrintingYear,
                                  SDCodeTable,
                                  AssessmentYearCtlTable,
                                  SDCodeDescList,
                                  SDExtCodeDescList,
                                  EXCodeDescList,
                                  SchoolCodeDescList,
                                  SwisCodeDescList,
                                  RollSectionDescList,
                                  SelectedRollSections,
                                  SequenceStr, ParcelPrintedThisPage,
                                  PageNo, LineNo, Quit);

            end;  {If (DoneWithReport or ...}

          {Should we print the grand totals?}

        If DoneWithReport
          then
            begin
              TotalsPrinted := True;

                {FXX06031999-2: Only send in a 4 digit swis so prints first 4 of
                                swis in header for municipality.}

              PrintSectionTotals(Sender, RollType, 'G',
                                  LastRollSection,
                                  Take(4, LastSwisCode), LastSchoolCode,
                                  GeneralRateList,
                                  SDRateList,
                                  SpecialFeeRateList,
                                  GnTaxList, SDTaxList,
                                  SpTaxList, ExTaxList,
                                  GeneralTotalsTable,
                                  SchoolTotalsTable,
                                  EXTotalsTable,
                                  SDTotalsTable,
                                  SpecialFeeTotalsTable,
                                  CollectionType,
                                  RollPrintingYear,
                                  SDCodeTable,
                                  AssessmentYearCtlTable,
                                  SDCodeDescList,
                                  SDExtCodeDescList,
                                  EXCodeDescList,
                                  SchoolCodeDescList,
                                  SwisCodeDescList,
                                  RollSectionDescList,
                                  SelectedRollSections,
                                  SequenceStr, ParcelPrintedThisPage,
                                  PageNo, LineNo, Quit);

            end;  {If (DoneWithReport or ...}

          {If we printed any totals, reset the variables we use to
           keep track of section breaks and go to a new page.}

        If TotalsPrinted
          then
            begin
               {Reset the "last" variables.}

             LastSwisCode := CurrentSwisCode;
             LastSchoolCode := CurrentSchoolCode;
             LastRollSection := CurrentRollSection;

             ParcelSubheaderPrinted := False;
             ParcelPrintedThisPage := False;

             If not DoneWithReport
               then StartNewPage(Sender, RollType, LastSchoolCode, LastSwisCode,
                                 LastRollSection,
                                 CollectionType, RollPrintingYear,
                                 AssessmentYearCtlTable,
                                 SchoolCodeDescList,
                                 SwisCodeDescList,
                                 SequenceStr,
                                 PageNo, LineNo);

            end;  {If TotalsPrinted}

           {load general, sdist, spcl fee, and exmpt info into tlists}

        If (not (DoneWithReport or TotalsOnly))
          then
            begin
                 {clear out print stringlists for this parcel}
              CL1List.Clear;
              CL2List.Clear;
              CL3List.Clear;
              CL4List.Clear;
              CL5List.Clear;
              CL6List.Clear;
              CL7List.Clear;

              LineTypeList.Clear;

                 {clear out tax details for this parcel}

              ClearTList(GnTaxList, SizeOf(GeneralTaxRecord));
              ClearTList(SDTaxList, SizeOf(SDistTaxRecord));
              ClearTList(SpTaxList, SizeOf(SPFeeTaxRecord));
              ClearTList(ExTaxList, SizeOf(ExemptTaxRecord));

              LoadTaxesForParcel(SwisSBLKey, BLGeneralTaxTable,
                                 BLSpecialDistrictTaxTable,
                                 BLExemptionTaxTable,
                                 BLSpecialFeeTaxTable,
                                 SDCodeDescList, EXCodeDescList,
                                 GeneralRateList, SDRateList,
                                 SpecialFeeRateList, GnTaxList,
                                 SDTaxList, SpTaxList, ExTaxList, Quit);

              If PrintToExcel
                then AddRecordToExtractFile(ExtractFile,
                                            BLHeaderTaxTable,
                                            GnTaxList,
                                            ExTaxList, SDTaxList);

                {CHG04032000-1: Pass in the swis code table to show full value.}
                {CHG03082003-1: Allow them to print the zoning code on the assessment roll.}
                {CHG04042004-1(2.07l2): Allow for Nassau formatting and ordering on assessment roll.}

              FillInPropertyInformation(BLHeaderTaxTable,
                                        AssessmentYearCtlTable,
                                        SwisCodeTable, ParcelTable,
                                        SwisSBLKey, RollType,
                                        PropertyClassDescList, SchoolCodeDescList,
                                        ExTaxList, CL1List, CL2List, CL3List,
                                        CL4List, CL5List, CL6List, CL7List,
                                        LineTypeList, PrintZoningCode,
                                        PrintAdditionalLots, PrintPermits,
                                        UseNassauPrintKeyFormat);

                {Now fill in the rest of the information for this parcel, but
                 do split parcels seperately.}

              If (BLHeaderTaxTable.FieldByName('HomesteadCode').Text = 'S')
                then
                  begin
                    FillInClassInformation(CL1List, CL2List,
                                           CL3List, CL4List, CL5List,
                                           CL6List, CL7List,
                                           LineTypeList,
                                           BLHeaderTaxTable,
                                           CollectionType, 'X',
                                           SuppressSDExtensions,
                                           ExTaxList, GNTaxList,
                                           SDExtCategoryList, SDTaxList,
                                           SPTaxList);
                  end
                else
                  begin
                      {Note that there are no special fees on the
                       assessment rolls.}

                    FillInExemptions(CL4List, CL5List, CL6List, CL7List,
                                     LineTypeList, ' ', CollectionType,
                                     ExTaxList);
                    FillInGeneralTaxes(CL2List, CL4List, CL5List, CL6List, CL7List,
                                       LineTypeList, 'X', ' ', GNTaxList);

                       {FXX12231997-4: Figure out the SD exemption amount so that
                                       we can print it.}

                    with BLHeaderTaxTable do
                      TotalAssessedVal := FieldByName('HstdTotalVal').AsFloat +
                                          FieldByName('NonhstdTotalVal').AsFloat;

                    FillInSDTaxes(CL4List, CL5List, CL6List, CL7List,
                                  LineTypeList, 'X', TotalAssessedVal,
                                  SuppressSDExtensions, SDExtCategoryList, SDTaxList, '');

                  end;  {If (BLHeaderTaxTable.FieldByName ...}

                 {figure out max lines to print from longest column then
                  add lines so all string lists of equal length}

              MaxLines := GetAndSetMaxLines(CL1List, CL2List, CL3List, CL4List,
                                            CL5List, CL6List, CL7List,
                                            LineTypeList);

                 {allow 3 lines for tot tax, date due, and half payment amts
                  plus 4th line for  line of  *********}
               {FXX06302003(2.07e): The number of lines left on the assessment roll should not depend
                                    on the number of line left that Report Printer thinks there is.}

              with Sender as TBaseReport do
                If (((NumLinesPerPage - LineNo) - (MaxLines + 2)) < LinesAtBottom)
                 then
                   begin
                       {First print an ending line.}

                     PrintEndingParcelLine(Sender);

                     StartNewPage(Sender, RollType, LastSchoolCode, LastSwisCode,
                                  LastRollSection,
                                  CollectionType, RollPrintingYear,
                                  AssessmentYearCtlTable,
                                  SchoolCodeDescList,
                                  SwisCodeDescList, SequenceStr,
                                  PageNo, LineNo);

                     ParcelSubheaderPrinted := False;
                     ParcelPrintedThisPage := False;

                   end;  {If (LinesLeft < (MaxLines + 4))}

                {If they don't want to do just totals and this roll
                 section is in the section that they wanted, then print it.}

              If ParcelShouldBePrinted
                then
                  begin
                    ParcelPrintedThisPage := True;

                    If not ParcelSubheaderPrinted
                     then
                       begin
                         PrintParcelPageSubheader(Sender, RollType,
                                                  CollectionType, LineNo);
                         ParcelSubheaderPrinted := True;
                       end;

                    PrintOneParcel(Sender, RollType, BLHeaderTaxTable,
                                   CollectionLookupTable,  {This is a dummy table not needed for assessment rolls}
                                   MaxLines, CL1List, CL2List,
                                   CL3List, CL4List, CL5List, CL6List, CL7List,
                                   LineTypeList, EXTaxList.Count, LineNo);

                    NumParcelsPrinted := NumParcelsPrinted + 1;

                  end;  {If ParcelShouldBePrinted}

            end;  {If not DoneWithReport}

      until DoneWithReport;

        {CHG05292001-1: Add totals by coop.}

      If (PrintCoopTotals and
          (CoopTotalsList.Count > 0))
        then
          For I := 0 to (CoopTotalsList.Count - 1) do
            begin
              If ((I = 0) or
                  (LinesLeft < 5))
                then
                  begin
                    NewPage;

                    ClearTabs;
                    SetTab(Mrg, pjLeft, 2.0, 0, BOXLINENONE, 0);   {cOUNTY}
                    SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                    SetTab(10.0, pjLeft, 2.0, 0, BOXLINENONE, 0);   {VALUATION Date prose}
                    SetTab(12.4, pjRight, 0.9, 0, BOXLINENONE, 0);   {VALUATION Date}
                    Println('');

                      {CHG02122000-1: Allow them to edit the title on the roll.}

                    Println(#9 + 'STATE OF NEW YORK' +
                                #9 + RollHeaderTitle +
                                #9 + 'PAGE: ' +
                                #9 + IntToStr(PageNo));

                    Println(#9 + 'COUNTY: ' + GlblCountyName +
                            #9 + 'COOPERATIVE TOTALS' +
                            #9 + 'ROLL PRINT DATE: ' + #9 + DateToStr(RollPrintingDate));

                     {2ND HDR LINE}

                    Println(#9 + UpcaseStr(GetMunicipalityName));
                    Println('');

                    ClearTabs;
                    SetTab(Mrg, pjCenter, 2.0, 0, BOXLINENONE, 0);   {Swis SBL Key}
                    SetTab(2.2, pjCenter, 0.5, 0, BOXLINENONE, 0);   {Count}
                    SetTab(2.8, pjCenter, 1.1, 0, BOXLINENONE, 0);   {Land}
                    SetTab(4.0, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Total}
                    SetTab(5.3, pjCenter, 1.2, 0, BOXLINENONE, 0);   {County}
                    SetTab(6.6, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Town}
                    SetTab(7.9, pjCenter, 1.2, 0, BOXLINENONE, 0);   {School}
                    SetTab(9.2, pjCenter, 1.7, 0, BOXLINENONE, 0);   {Basic STAR}
                    SetTab(11.1, pjCenter, 1.7, 0, BOXLINENONE, 0);   {Enhanced STAR}

                    Println(#9 + #9 +
                            #9 + 'LAND' +
                            #9 + 'TOTAL' +
                            #9 + 'COUNTY' +
                            #9 + 'CITY' +
                            #9 + 'SCHOOL' +
                            #9 + ' BASIC STAR' +
                            #9 + ' ENHANCED STAR');

                    ClearTabs;
                    SetTab(Mrg, pjCenter, 2.0, 0, BOXLINENONE, 0);   {Swis SBL Key}
                    SetTab(2.2, pjCenter, 0.5, 0, BOXLINENONE, 0);   {Count}
                    SetTab(2.8, pjCenter, 1.1, 0, BOXLINENONE, 0);   {Land}
                    SetTab(4.0, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Total}
                    SetTab(5.3, pjCenter, 1.2, 0, BOXLINENONE, 0);   {County}
                    SetTab(6.6, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Town}
                    SetTab(7.9, pjCenter, 1.2, 0, BOXLINENONE, 0);   {School}
                    SetTab(9.2, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Basic STAR}
                    SetTab(10.5, pjCenter, 0.4, 0, BOXLINENONE, 0);   {Basic STAR Count}
                    SetTab(11.1, pjCenter, 1.2, 0, BOXLINENONE, 0);   {Enhanced STAR}
                    SetTab(12.4, pjCenter, 0.4, 0, BOXLINENONE, 0);   {Basic STAR Count}

                    Println(#9 + 'COOP PARCEL ID' +
                            #9 + 'COUNT' +
                            #9 + 'VALUE' +
                            #9 + 'VALUE' +
                            #9 + 'TAXABLE' +
                            #9 + 'TAXABLE' +
                            #9 + 'TAXABLE' +
                            #9 + 'AMOUNT' +
                            #9 + 'CNT' +
                            #9 + 'AMOUNT' +
                            #9 + 'CNT');

                    Println('');

                    ClearTabs;
                    SetTab(Mrg, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Swis SBL Key}
                    SetTab(2.2, pjRight, 0.5, 0, BOXLINENONE, 0);   {Count}
                    SetTab(2.8, pjRight, 1.1, 0, BOXLINENONE, 0);   {Land}
                    SetTab(4.0, pjRight, 1.2, 0, BOXLINENONE, 0);   {Total}
                    SetTab(5.3, pjRight, 1.2, 0, BOXLINENONE, 0);   {County}
                    SetTab(6.6, pjRight, 1.2, 0, BOXLINENONE, 0);   {Town}
                    SetTab(7.9, pjRight, 1.2, 0, BOXLINENONE, 0);   {School}
                    SetTab(9.2, pjRight, 1.2, 0, BOXLINENONE, 0);   {Basic STAR}
                    SetTab(10.5, pjRight, 0.4, 0, BOXLINENONE, 0);   {Basic STAR Count}
                    SetTab(11.1, pjRight, 1.2, 0, BOXLINENONE, 0);   {Enhanced STAR}
                    SetTab(12.4, pjRight, 0.4, 0, BOXLINENONE, 0);   {Basic STAR Count}

                  end;  {If ((I = 0) or ...}

              with CoopTotalsPointer(CoopTotalsList[I])^ do
                Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                        #9 + IntToStr(Count) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         LandAssessedValue) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         TotalAssessedValue) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         CountyTaxableValue) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         TownTaxableValue) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         SchoolTaxableValue) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         BasicSTARValue) +
                        #9 + IntToStr(BasicSTARCount) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         EnhancedSTARValue) +
                        #9 + IntToStr(EnhancedSTARCount));

            end;  {For I := 0 to (CoopTotalsList.Count - 1) do}

    end;  {with Sender as TBaseReport do}

  CL1List.Free;
  CL2List.Free;
  CL3List.Free;
  CL4List.Free;
  CL5List.Free;
  CL6List.Free;
  CL7List.Free;
  LineTypeList.Free;

    {FXX01191998-4: Need to free the tax TLists.}

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

end;  {ReportFilerPrint}

{=========================================================================}
Procedure TfmCoopAssessmentRoll.ReportPrint(Sender: TObject);

{Go through the text file generated by text filer and either print to
 screen or to printer.}

var
  RollTextFile : TextFile;

begin
  AssignFile(RollTextFile, TextFiler.FileName);
  Reset(RollTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, RollTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(RollTextFile);

end;  {ReportPrint}

{===============================================================}
Procedure TfmCoopAssessmentRoll.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TfmCoopAssessmentRoll.FormClose(    Sender: TObject;
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