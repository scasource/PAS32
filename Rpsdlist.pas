unit RpSDlist;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Types, RPDefine, (*Progress, *)RPTXFilr, TabNotBk,
  ComCtrls;

type
  TotalsRecord = record
    Acres,
    Frontage,
    Depth : Double;
    Count : LongInt;
    TotalAssessedVal : Comp;
    Amount : Extended;
    Units : Extended;
    SecondaryUnits : Extended;
  end;  {TotalsRecord = record}

  SDInformationRecord = record
    SDCode : String;
    CalcCode : String;
    Amount : Extended;
    Units : Extended;
    SecondaryUnits : Extended;
  end;
  SDInformationPointer = ^SDInformationRecord;

type
  TSpecialDistrictReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    ParcelSDTable: TTable;
    ParcelTable: TTable;
    SwisCodeTable: TTable;
    PrintDialog: TPrintDialog;
    SortSDTable: TTable;
    ParcelSDLookupTable: TTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    AssessmentTable: TTable;
    TextFiler: TTextFiler;
    Label5: TLabel;
    ParcelExemptionTable: TTable;
    EXCodeTable: TTable;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SchoolCodeTable: TTable;
    SDCodeTable: TTable;
    ClassTable: TTable;
    PageControl: TPageControl;
    OptionsTabSheet: TTabSheet;
    AssessmentYearRadioGroup: TRadioGroup;
    HistoryEdit: TEdit;
    PrintOrderRadioGroup: TRadioGroup;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label1: TLabel;
    PrintSection1CheckBox: TCheckBox;
    PrintBySwisCodeCheckBox: TCheckBox;
    PrintSection2CheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    DisplayExceptionAmountCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    PrintOldSBLCheckBox: TCheckBox;
    PrintMailingAddressCheckBox: TCheckBox;
    EachSDCodeIsAColumnCheckBox: TCheckBox;
    ExtractAllNameAddressFieldsCheckBox: TCheckBox;
    Swis_School_RS_TabSheet: TTabSheet;
    PropertyClassTabSheet: TTabSheet;
    DistrictsTabSheet: TTabSheet;
    Label15: TLabel;
    Label9: TLabel;
    Label18: TLabel;
    RollSectionListBox: TListBox;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    SDCodeListBox: TListBox;
    Panel3: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel8: TPanel;
    Label2: TLabel;
    Panel9: TPanel;
    PropertyClassListBox: TListBox;
    PropertyClassTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure TextReportPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure TextFilerBeforePrint(Sender: TObject);
    procedure AssessmentYearRadioGroupClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    AssessmentYear : String;
    ReportCancelled : Boolean;
    PartName,
    SubHeader : String;
    CurrentSwisCode : String;
    ReportTime : TDateTime;
    PrintBySwisCode : Boolean;
    CreateParcelList : Boolean;
    DisplayExceptionAmountDistrictsOnly, ExtractAllNameAddressFields : Boolean;
    PrintOrder : Integer;
    OrigSortFileName : String;
    SelectedSchoolCodes, SelectedRollSections : TStringList;
    ProcessingType : Integer;

    EachSDCodeIsAColumn,
    PrintMailingAddress, PrintOldSBL,
    ExtractToExcel, ParcelsExtracted : Boolean;
    ExtractFile : TextFile;
    SelectedSwisCodes, SelectedSDCodes, SelectedPropertyClasses : TStringList;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure AddOneSDSortRecord(    TaxRollYr : String;
                                     SwisSBLKey : String;
                                     HomesteadCode : String;
                                     SplitDistrict : Boolean;
                                     ParcelTable,
                                     AssessmentTable,
                                     ParcelSDTable,
                                     SDCodeTable,
                                     ParcelExemptionTable,
                                     EXCodeTable,
                                     SortSDTable : TTable;
                                 var Quit : Boolean);
    {Insert one record in the special district sort table.}

    Procedure FillSortFiles(var Quit : Boolean);
    {Fill all the sort files needed for the assessor's report.}

    Procedure InsertSDCode(SelectedSwisCodes : TStringList;
                           SDCode : String);

    Procedure PrintTotals(Sender : TObject;
                          TotalsRec : TotalsRecord;
                          HeaderStr,
                          AmountFormatStr : String);

    Procedure InsertSDInExtractFile(var ExtractFile : TextFile;
                                        AmountFormatStr : String;
                                        SortSDTable : TTable);

    Procedure InsertSDInSDCodeColumnExtractFile(var ExtractFile : TextFile;
                                                    SDSortTable : TTable;
                                                    SelectedSDCodes : TStringList;
                                                    SDCodesThisParcel : TList;
                                                    LastEntry : Boolean);

    Procedure PrintHeader(Sender : TObject);

    Procedure PrintSection1Header(Sender : TObject);

    Procedure PrintSection1(    Sender : TObject;
                            var Quit : Boolean);
    {Print the SD codes by SBL. Break by swis.}

    Procedure PrintSection2Header(Sender : TObject);

    Procedure PrintSection2(    Sender : TObject;
                            var Quit : Boolean);
    {Print the SD codes by SDCode \SBL. Break by swis.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst, PasTypes,
     PRCLLIST, RptDialg,
     Prog,
     Preview, DataAccessUnit, DataModule;  {Report preview form}

const
  TrialRun = False;

  poParcelID = 0;
  poName = 1;
  poLegalAddress = 2;

  ayThisYear = 0;
  ayNextYear = 1;
  ayHistory = 2;

{$R *.DFM}

{===================================================================}
Procedure TSpecialDistrictReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TSpecialDistrictReportForm.InitializeForm;

var
  Quit : Boolean;

begin
  Quit := False;
  UnitName := 'RPSDLIST';  {mmm}

    {Default assessment year.}

  If (GlblProcessingType = NextYear)
    then AssessmentYearRadioGroup.ItemIndex := 1
    else AssessmentYearRadioGroup.ItemIndex := 0;

    {Default swis code table to NY esp. since it rarely changes.}

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             NextYear, Quit);

  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             NextYear, Quit);

  OpenTableForProcessingType(PropertyClassTable, PropertyClassCodeTableName,
                             NextYear, Quit);

  OpenTableForProcessingType(SDCodeTable, SdistCodeTableName,
                             GlblProcessingType, Quit);

  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName', 20,
                 True, True, NextYear, GlblNextYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable,
                 'SchoolCode', 'SchoolName', 15,
                  True, True, NextYear, GlblNextYear);

  FillOneListBox(SDCodeListBox, SDCodeTable,
                 'SDistCode', 'Description', 15,
                  True, True, ProcessingType, GetTaxRollYearForProcessingType(GlblProcessingType));

    {CHG10192005-1(2.9.3.6): Add property class selection to the report.}

  FillOneListBox(PropertyClassListBox, PropertyClassTable, 'MainCode',
                 'Description', 17, True, True, NextYear, GlblNextYear);

  OrigSortFileName := SortSDTable.TableName;

    {CHG03282002-6: Allow for roll section selection on sd, ex reports.}

  SelectedRollSections := TStringList.Create;
  SelectItemsInListBox(RollSectionListBox);

    {CHG08212003-1(2.07i): Allow for school code selection on the sd report.}

  SelectedSchoolCodes := TStringList.Create;

    {CHG09252002-1: Add ability to print mailing address, old SBL, and extract to excel.}

  If GlblLocateByOldParcelID
    then PrintOldSBLCheckBox.Visible := True;

end;  {InitializeForm}

{===================================================================}
Procedure TSpecialDistrictReportForm.AssessmentYearRadioGroupClick(Sender: TObject);

{FXX12021998-1: Load the SD box with that year's sd codes.}
{CHG03232005-1(2.8.3.13)[2084]: Allow SD report to be run for history.}

begin
  HistoryEdit.Visible := False;

  case AssessmentYearRadioGroup.ItemIndex of
    ayThisYear :
      begin
        ProcessingType := ThisYear;
        AssessmentYear := GlblThisYear;
      end;

    ayNextYear :
      begin
        ProcessingType := NextYear;
        AssessmentYear := GlblNextYear;
      end;

    ayHistory :
      begin
        ProcessingType := History;
        HistoryEdit.Visible := True;
        HistoryEdit.Text := GlblHistYear;
        HistoryEdit.SetFocus;
      end;

  end;  {case AssessmentYearRadioGroup.ItemIndex of}

  If SDCodeTable.Active
    then FillOneListBox(SDCodeListBox, SDCodeTable,
                        'SDistCode', 'Description', 15,
                         True, True, ProcessingType, AssessmentYear);

end;  {AssessmentYearRadioGroupClick}

{===================================================================}
Procedure TSpecialDistrictReportForm.AddOneSDSortRecord(    TaxRollYr : String;
                                                            SwisSBLKey : String;
                                                            HomesteadCode : String;
                                                            SplitDistrict : Boolean;
                                                            ParcelTable,
                                                            AssessmentTable,
                                                            ParcelSDTable,
                                                            SDCodeTable,
                                                            ParcelExemptionTable,
                                                            EXCodeTable,
                                                            SortSDTable : TTable;
                                                        var Quit : Boolean);

{Insert one record in the special district sort table.}

var
  SDExtensionCodes, SDCC_OMFlags,
  SDValues, HomesteadCodesList, slAssessedValues : TStringList;
  ParcelExemptionList, ExemptionCodeList : TList;
  I : Integer;
  SDExtensionType : Char;
  Value : Extended;
  NAddrArray : NameAddrArray;
  dTaxableValue : Double;

begin
  SDExtensionCodes := TStringList.Create;
  SDCC_OMFlags := TStringList.Create;
  SDValues := TStringList.Create;
  ParcelExemptionList := TList.Create;
  ExemptionCodeList := TList.Create;
  HomesteadCodesList := TStringList.Create;
  slAssessedValues := TStringList.Create;

  with SortSDTable do
    try
      Insert;

      FieldByName('SwisCode').Text := Copy(SwisSBLKey, 1, 6);

        {FXX12021998-6: Had fields reversed.}

      If PrintBySwisCode
        then FieldByName('SwisCodeKey').Text := FieldByName('SwisCode').Text;

      FieldByName('SBLKey').Text := Copy(SwisSBLKey, 7, 20);

        {CHG09252002-1: Add ability to print mailing address, old SBL, and extract to excel.}

      GetNameAddress(ParcelTable, NAddrArray);
      FieldByName('Name').Text := Take(25, NAddrArray[1]);
      FieldByName('Name2').Text := Take(25, NAddrArray[2]);
      FieldByName('Address1').Text := Take(25, NAddrArray[3]);
      FieldByName('Address2').Text := Take(25, NAddrArray[4]);
      FieldByName('Address3').Text := Take(25, NAddrArray[5]);
      FieldByName('Address4').Text := Take(25, NAddrArray[6]);

      If ExtractAllNameAddressFields
        then
          try
            FieldByName('Name2').Text := ParcelTable.FieldByName('Name2').Text;
            FieldByName('Address1').Text := ParcelTable.FieldByName('Address1').Text;
            FieldByName('Address2').Text := ParcelTable.FieldByName('Address2').Text;
            FieldByName('Street').Text := ParcelTable.FieldByName('Street').Text;
            FieldByName('City').Text := ParcelTable.FieldByName('City').Text;
            FieldByName('State').Text := ParcelTable.FieldByName('State').Text;
            FieldByName('Zip').Text := ParcelTable.FieldByName('Zip').Text;
          except
          end;

      If GlblLocateByOldParcelID
        then FieldByName('RemapOldSBL').Text := ConvertSBLOnlyToOldDashDot(Copy(ParcelTable.FieldByName('RemapOldSBL').Text, 7, 20),
                                                                           PASDataModule.TYAssessmentYearControlTable);

      FieldByName('LegalAddrInt').AsString := ParcelTable.FieldByName('LegalAddrInt').AsString;
      FieldByName('LegalAddrNo').Text := Take(10, ParcelTable.FieldByName('LegalAddrNo').Text);
      FieldByName('LegalAddr').Text := Take(30, ParcelTable.FieldByName('LegalAddr').Text);

      FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
      FieldByName('PropertyClass').Text := Take(3, ParcelTable.FieldByName('PropertyClassCode').Text);
      FieldByName('SchoolCode').Text := Take(6, ParcelTable.FieldByName('SchoolCode').Text);
      TCurrencyField(FieldByName('TotalAssessedVal')).Value :=
          TCurrencyField(AssessmentTable.FieldByName('TotalAssessedVal')).Value;
      FieldByName('SDCode').Text := ParcelSDTable.FieldByName('SDistCode').Text;
      FieldByName('CalcCode').Text := ParcelSDTable.FieldByName('CalcCode').Text;
      FieldByName('Acres').AsFloat := ParcelTable.FieldByName('Acreage').AsFloat;

        {FXX07271998-2: Add frontage and depth.}

      FieldByName('Frontage').AsFloat := ParcelTable.FieldByName('Frontage').AsFloat;
      FieldByName('Depth').AsFloat := ParcelTable.FieldByName('Depth').AsFloat;

        {FXX07251998-1: Add SD extension amounts.}

      LoadExemptions(TaxRollYr, SwisSBLKey,
                     ParcelExemptionList, ExemptionCodeList,
                     ParcelExemptionTable, EXCodeTable);

      CalculateSpecialDistrictAmounts(ParcelTable, AssessmentTable,
                                      ClassTable, ParcelSDTable, SDCodeTable,
                                      ParcelExemptionList,
                                      ExemptionCodeList,
                                      SDExtensionCodes,
                                      SDCC_OMFlags,
                                      slAssessedValues,
                                      SDValues,
                                      HomesteadCodesList);

      FieldByName('HomesteadCode').Text := HomesteadCode;
      dTaxableValue := 0;

      For I := 0 to (SDExtensionCodes.Count - 1) do
        begin
          SDExtensionType := SdExtType(SDExtensionCodes[I]);

            {FXX12162004-2(2.8.1.3): Make sure to have a try..except in case the SDValue is blank
                                     when formatted.}

          try
            Value := StrToFloat(SDValues[I]);
          except
            Value := 0;
          end;

          dTaxableValue := Value;

          case SDExtensionType of
            SDExtCatA : If SplitDistrict
                          then
                            begin
                              If (HomesteadCode = HomesteadCodesList[I])
                                then FieldByName('Amount').AsFloat := Value;

                            end
                          else FieldByName('Amount').AsFloat := Value;

            SDExtCatF : FieldByName('Amount').AsFloat := Value;

            SDExtCatU : If (SDExtensionCodes[I] = SDistECUn)
                          then FieldByName('Units').AsFloat := Value
                          else FieldByName('SecondaryUnits').AsFloat := Value;

            SDExtCatD : FieldByName('Acres').AsFloat := Value;

          end;  {case SDExtensionType of}

        end;  {For I := 0 to (SDExtensionCodes.Count - 1) do}

        {CHG12082004-1(2.8.1.2)[2017]: Add account #, village, and zip code to the extract.}

      FieldByName('AccountNo').Text := ParcelTable.FieldByName('AccountNo').Text;
      FieldByName('Zip').Text := ParcelTable.FieldByName('Zip').Text;

        {CHG05132009-1(2.20.1.1)[F899]: Option to show taxable values.}

      try
        FieldByName('TaxableValue').AsFloat := dTaxableValue;
      except
      end;

        {CHG03282002-4: Let them just print special districts where the
                        advalorum amount does not match the assessed value.}

      If DisplayExceptionAmountDistrictsOnly
        then
          begin
            If (Roundoff(FieldByName('Amount').AsFloat, 0) =
                Roundoff(AssessmentTable.FieldByName('TotalAssessedVal').AsFloat, 0))
              then Cancel
              else Post;

          end
        else Post;

    except
      Quit := True;
      SystemSupport(005, SortSDTable, 'Error inserting special district sort record.',
                    'RPSDLIST', GlblErrorDlgBox);
    end;

  HomesteadCodesList.Free;
  SDExtensionCodes.Free;
  SDCC_OMFlags.Free;
  SDValues.Free;
  slAssessedValues.Free;
  FreeTList(ParcelExemptionList, SizeOf(ParcelExemptionRecord));
  FreeTList(ExemptionCodeList, SizeOf(ExemptionCodeRecord));

end;  {AddOneSDSortRecord}

{===================================================================}
Function RecMeetsCriteria(ParcelSDTable : TTable;
                          SwisSBLKey : String;
                          SelectedSwisCodes : TStringList) : Boolean;

begin
  Result := True;

    {In the selected swis list?}

  If (SelectedSwisCodes.IndexOf(Copy(SwisSBLKey, 1, 6)) = -1)
    then Result := False;

end;  {RecMeetsCriteria}

{==========================================================================================}
Procedure TSpecialDistrictReportForm.InsertSDCode(SelectedSwisCodes : TStringList;
                                                  SDCode : String);

var
  Quit, Found, FirstTimeThrough, Done, SplitDistrict : Boolean;
  LastSwisSBLKey, SwisSBLKey, HomesteadCode : String;

begin
  LastSwisSBLKey := '';

  SDCode := Trim(StringReplace(SDCode, '-', '', [rfReplaceAll]));

    {Now go through the next year parcel file.}

  FirstTimeThrough := True;
  Quit := False;
  ParcelSDTable.Filtered := False;
  ParcelSDTable.CancelRange;
  SetRangeOld(ParcelSDTable, ['SDistCode'], [SDCode], [SDCode]);

    {CHG03232005-1(2.8.3.13)[2084]: Allow SD report to be run for history.}

  If (ProcessingType = History)
    then SetFilterForHistoryYear(ParcelSDTable, AssessmentYear);

  FindKeyOld(SDCodeTable, ['SDistCode'], [SDCode]);

  ParcelSDTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelSDTable.Next;

    Application.ProcessMessages;

    Done := ParcelSDTable.EOF;
    SwisSBLKey := ParcelSDTable.FieldByName('SwisSBLKey').Text;

    ProgressDialog.Update(Self, SDCode + '  Parcel: ' + ConvertSwisSBLToDashDot(SwisSBLKey));

      {Insert records into the sort files where appropriate.}
      {FXX05051998-3: Let them choose which special districts they want to see.}

    If (Done or
        RecMeetsCriteria(ParcelSDTable, SwisSBLKey, SelectedSwisCodes))
      then
        begin
          If not Done
            then
              begin
                  {FXX10251999-2: Make sure that the parcel is active.}
                  {CHG03282002-6: Allow for roll section selection on sd, ex reports.}
                  {CHG08222003-1(2.07i): Add support for school code selection to the SD report.}

                Found := _Locate(ParcelTable, [AssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey]);

                If (Found and
                    (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
                    (SelectedRollSections.IndexOf(ParcelTable.FieldByName('RollSection').Text) > -1) and
                    (SelectedSchoolCodes.IndexOf(ParcelTable.FieldByName('SchoolCode').Text) > -1) and
                    (_Compare(SelectedPropertyClasses.IndexOf(ParcelTable.FieldByName('PropertyClassCode').Text), -1, coGreaterThan) or
                     _Compare(SelectedPropertyClasses.Count, PropertyClassListBox.Items.Count, coEqual)))
                  then
                    begin
                      FindKeyOld(AssessmentTable,
                                 ['TaxRollYr', 'SwisSBLKey'],
                                 [AssessmentYear, SwisSBLKey]);

                      HomesteadCode := '';
                      SplitDistrict := False;

                      If ((ParcelTable.FieldByName('HomesteadCode').Text = SplitParcel) and
                          SDCodeTable.FieldByName('SDHomestead').AsBoolean)
                        then
                          begin
                            HomesteadCode := 'H';
                            SplitDistrict := True;
                          end;

                      AddOneSDSortRecord(AssessmentYear, SwisSBLKey,
                                         HomesteadCode, SplitDistrict, ParcelTable,
                                         AssessmentTable, ParcelSDTable,
                                         SDCodeTable, ParcelExemptionTable,
                                         EXCodeTable, SortSDTable, Quit);

                        {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}
                        {If this is a split parcel in a split district, add a second record with
                         the split amounts.}

                      If ((ParcelTable.FieldByName('HomesteadCode').Text = SplitParcel) and
                          SDCodeTable.FieldByName('SDHomestead').AsBoolean)
                        then
                          begin
                            HomesteadCode := 'N';

                            AddOneSDSortRecord(AssessmentYear, SwisSBLKey,
                                               HomesteadCode, SplitDistrict, ParcelTable,
                                               AssessmentTable, ParcelSDTable,
                                               SDCodeTable, ParcelExemptionTable,
                                               EXCodeTable, SortSDTable, Quit);

                          end;  {If ((ParcelTable.FieldByName('HomesteadCode').Text = SplitParcel) and ...}

                        {CHG03101999-1: Send info to a list.}

                      If CreateParcelList
                        then ParcelListDialog.AddOneParcel(SwisSBLKey);

                    end;  {If Found}

              end;  {If not Done}

        end;  {If not Done}

    LastSwisSBLKey := SwisSBLKey;

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or Quit or ReportCancelled);

end;  {InsertSDCode}

{===================================================================}
Procedure TSpecialDistrictReportForm.FillSortFiles(var Quit : Boolean);

var
  I : Integer;

begin
  ProgressDialog.UserLabelCaption := 'Sorting Special District File.';

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

    {FXX07211998-2: Speed up the report by only looking at those parcels with the given SD's.}

  with SelectedSDCodes do
    For I := 0 to (Count - 1) do
      If not ProgressDialog.Cancelled
        then InsertSDCode(SelectedSwisCodes, SelectedSDCodes[I]);

end;  {FillSortFiles}

{====================================================================}
Procedure TSpecialDistrictReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'sdlist.spd', 'Special District Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TSpecialDistrictReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'sdlist.spd', 'Special District Report');

end;  {LoadButtonClick}

{===================================================================}
Procedure TSpecialDistrictReportForm.StartButtonClick(Sender: TObject);

var
  Quit : Boolean;
  TextFileName, SortFileName, NewFileName, SpreadsheetFileName : String;
  I : Integer;

begin
  ExtractAllNameAddressFields := ExtractAllNameAddressFieldsCheckBox.Checked;
  GlblCurrentCommaDelimitedField := 0;
  Quit := False;
  ReportCancelled := False;
  ParcelsExtracted := False;

  SelectedSwisCodes := TStringList.Create;

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    If SwisCodeListBox.Selected[I]
      then SelectedSwisCodes.Add(Copy(SwisCodeListBox.Items[I], 1, 6));

  SelectedPropertyClasses := TStringList.Create;

  with PropertyClassListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then SelectedPropertyClasses.Add(Take(3, Items[I]));

    {FXX05051998-3: Let them choose which special districts they want to see.}

  SelectedSDCodes := TStringList.Create;

  For I := 0 to (SDCodeListBox.Items.Count - 1) do
    If SDCodeListBox.Selected[I]
      then SelectedSDCodes.Add(Take(5, SDCodeListBox.Items[I]));

    {CHG03282002-4: Let them just print special districts where the
                    advalorum amount does not match the assessed value.}

  DisplayExceptionAmountDistrictsOnly := DisplayExceptionAmountCheckBox.Checked;

    {FXX03181999-1: Make sure they select a report type to print.}

  If ((not PrintSection1CheckBox.Checked) and
      (not PrintSection2CheckBox.Checked))
    then MessageDlg('Please select what report type(s) to print.' + #13 +
                    'You can select to view parcels within a special district code,' + #13 +
                    'special districts within a parcel, or both.', mtError, [mbOK], 0)
    else
      begin
          {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

        StartButton.Enabled := False;
        Application.ProcessMessages;

          {CHG09252002-1: Add ability to print mailing address, old SBL, and extract to excel.}

        PrintMailingAddress := PrintMailingAddressCheckBox.Checked;
        PrintOldSBL := PrintOldSBLCheckBox.Checked;

          {CHG01022003-2: Option to make each SD a seperate column in Excel extract.}

        EachSDCodeIsAColumn := EachSDCodeIsAColumnCheckBox.Checked;
        ExtractToExcel := ExtractToExcelCheckBox.Checked;

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

                {Write the headers.}

              If EachSDCodeIsAColumn
                then
                  begin
                    WriteCommaDelimitedLine(ExtractFile,
                                            ['Swis Code',
                                             'Parcel ID',
                                             'SwisSBLKey',
                                             'Name']);

                    If PrintMailingAddress
                      then WriteCommaDelimitedLine(ExtractFile,
                                                   ['Name2',
                                                    'Address1',
                                                    'Address2',
                                                    'Address3',
                                                    'Address4']);

                    If PrintOldSBL
                      then WriteCommaDelimitedLine(ExtractFile, ['OldParcelID']);

                    WriteCommaDelimitedLine(ExtractFile,
                                            ['LegalAddress',
                                             'RollSection',
                                             'PropertyClass',
                                             'SchoolCode',
                                             'Frontage',
                                             'Depth',
                                             'Acreage',
                                             'AssessedValue']);

                    For I := 0 to (SelectedSDCodes.Count - 1) do
                      WriteCommaDelimitedLine(ExtractFile, [SelectedSDCodes[I],
                                                            'Calc Cd',
                                                            'Amount',
                                                            'Units',
                                                            '2nd Units']);

                    WritelnCommaDelimitedLine(ExtractFile, []);

                    WritelnCommaDelimitedLine(ExtractFile,
                                              ['', '', '', 'Sample']);

                  end
                else
                  begin
                    WriteCommaDelimitedLine(ExtractFile,
                                            ['Swis Code',
                                             'Village',
                                             'Parcel ID',
                                             'SwisSBLKey',
                                             'SD Code',
                                             'Name']);

                    If PrintMailingAddress
                      then WriteCommaDelimitedLine(ExtractFile,
                                                   ['Name 2',
                                                    'Address 1',
                                                    'Address 2',
                                                    'Address 3',
                                                    'Address 4']);

                    If ExtractAllNameAddressFields
                      then WriteCommaDelimitedLine(ExtractFile,
                                                   ['Name 2',
                                                    'Address 1',
                                                    'Address 2',
                                                    'Street',
                                                    'City',
                                                    'State',
                                                    'Zip']);

                    If PrintOldSBL
                      then WriteCommaDelimitedLine(ExtractFile, ['Old Parcel ID'])
                      else WriteCommaDelimitedLine(ExtractFile, []);

                      {CHG12082004-1(2.8.1.2)[2017]: Add account #, village, and zip code to the extract.}

                    WritelnCommaDelimitedLine(ExtractFile,
                                              ['Legal Address',
                                               'Roll Section',
                                               'Property Class',
                                               'School Code',
                                               'Frontage',
                                               'Depth',
                                               'Acreage',
                                               'Assessed Value',
                                               'Account #',
                                               'Zip Code',
                                               'Calc Code',
                                               'Homestead',
                                               'Amount',
                                               'Units',
                                               '2nd Units']);

                    WritelnCommaDelimitedLine(ExtractFile,
                                              ['', '', '', 'Sample']);

                  end;  {else of If EachSDCodeIsAColumn}

            end;  {If ExtractToExcel}

          {CHG03282002-6: Allow for roll section selection on sd, ex reports.}

        SelectedRollSections.Clear;
        with RollSectionListBox do
          For I := 0 to (Items.Count - 1) do
            If Selected[I]
              then SelectedRollSections.Add(Take(1, Items[I]));

        SelectedSchoolCodes.Clear;
        with SchoolCodeListBox do
          For I := 0 to (Items.Count - 1) do
            If Selected[I]
              then SelectedSchoolCodes.Add(Take(6, Items[I]));

          {CHG10121998-1: Add user options for default destination and show vet max msg.}

        SetPrintToScreenDefault(PrintDialog);

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
              PrintBySwisCode := PrintBySwisCodeCheckBox.Checked;
              PrintOrder := PrintOrderRadioGroup.ItemIndex;

                {CHG10131998-1: Set the printer settings based on what printer they selected
                                only - they no longer need to worry about paper or landscape
                                mode.}

              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

              If (ReportPrinter.Orientation = poLandscape)
                then
                  If (MessageDlg('Do you want to print on letter size paper?',
                                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
                    then
                      begin
                        ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
                        ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                        ReportPrinter.Orientation := poLandscape;
                        ReportFiler.Orientation := poLandscape;

                        ReportPrinter.ScaleX := 77;
                        ReportPrinter.ScaleY := 70;
                        ReportPrinter.SectionLeft := 1.5;
                        ReportFiler.ScaleX := 77;
                        ReportFiler.ScaleY := 70;
                        ReportFiler.SectionLeft := 1.5;

                      end;  {If (MessageDlg('Do you want to...}

              If not Quit
                then
                  begin
                      {Copy the sort table and open the tables.}

                       {FXX12011997-1: Name the sort files with the date and time and
                                       extension of .SRT.}

                    SortSDTable.IndexName := '';

                    CopyAndOpenSortFile(SortSDTable, 'SDList',
                                        OrigSortFileName,
                                        SortFileName,
                                        True, True, Quit);

                      {We have to open the tables manually since we are opening both this year and next year.}

                    OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                               ProcessingType, Quit);
                    OpenTableForProcessingType(ClassTable, ClassTableName,
                                               ProcessingType, Quit);
                    OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                               ProcessingType, Quit);
                    OpenTableForProcessingType(ParcelSDTable, SpecialDistrictTableName,
                                               ProcessingType, Quit);
                    OpenTableForProcessingType(SDCodeTable, SdistCodeTableName,
                                               ProcessingType, Quit);
                    OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                               ProcessingType, Quit);
                    OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName,
                                               ProcessingType, Quit);
                    OpenTableForProcessingType(EXCodeTable, ExemptionCodesTableName,
                                               ProcessingType, Quit);

                    SDCodeTable.Filtered := False;
                    EXCodeTable.Filtered := False;

                      {CHG03232005-1(2.8.3.13)[2084]: Allow SD report to be run for history.}

                    If (ProcessingType = History)
                      then
                        begin
                          AssessmentYear := HistoryEdit.Text;
                          SetFilterForHistoryYear(SDCodeTable, AssessmentYear);
                          SetFilterForHistoryYear(EXCodeTable, AssessmentYear);
                        end;

                    ProgressDialog.Start(GetRecordCount(ParcelSDTable), True, True);

                    FillSortFiles(Quit);

                    Quit := False;
                    ReportCancelled := False;

                      {Now print the report.}

                    If not (Quit or ReportCancelled)
                      then
                        begin

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

                            {FXX09071999-6: Tell people that printing is starting and
                                            done.}

                          ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

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

                          ShowReportDialog('SDLIST.RPT', TextFiler.FileName, True);

                        end;  {If not Quit}

                    ProgressDialog.Finish;

                      {Make sure to close and delete the sort file.}

                    SortSDTable.Close;

                      {Now delete the file.}
                    try
                      ChDir(GlblDataDir);
(*                      OldDeleteFile(SortFileName); *)
                    finally
                      {We don't care if it does not get deleted, so we won't put up an
                       error message.}

                      ChDir(GlblProgramDir);
                    end;

                      {FXX09071999-6: Tell people that printing is starting and
                                      done.}

                    DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

                  end;  {If not Quit}

              ResetPrinter(ReportPrinter);
              If CreateParcelList
                then ParcelListDialog.Show;

              If ExtractToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If ExtractToExcel}

            end;  {If PrintDialog.Execute}

        StartButton.Enabled := True;

        SelectedSwisCodes.Free;
        SelectedPropertyClasses.Free;
        SelectedSDCodes.Free;
        
      end;  {else of If ((not PrintSection1CheckBox.Checked) and ...}

end;  {StartButtonClick}

{===================================================================}
{===============  THE FOLLOWING ARE PRINTING PROCEDURES ============}
{===================================================================}
Procedure InitTotalsRec(var TotalsRec : TotalsRecord);

begin
  with TotalsRec do
    begin
      Acres := 0;
      TotalAssessedVal := 0;
      Frontage := 0;
      Depth := 0;
      Count := 0;
      Amount := 0;
      Units := 0;
      SecondaryUnits := 0;
    end;  {with TotalsRec do}

end;  {InitTotalsRec}

{===================================================================}
Procedure UpdateTotals(var TotalsRec : TotalsRecord;
                           SortSDTable : TTable);

begin
  with TotalsRec, SortSDTable do
    begin
      Acres := Acres + FieldByName('Acres').AsFloat;
      Frontage := Frontage + FieldByName('Frontage').AsFloat;
      Depth := Depth + FieldByName('Depth').AsFloat;
      TotalAssessedVal := TotalAssessedVal + FieldByName('TotalAssessedVal').AsFloat;
      Amount := Amount + FieldByName('Amount').AsFloat;
      Units := Units + FieldByName('Units').AsFloat;
      SecondaryUnits := SecondaryUnits + FieldByName('SecondaryUnits').AsFloat;
      Count := Count + 1;

    end;  {with TotalsRec do}

end;  {UpdateTotals}

{===================================================================}
Procedure TSpecialDistrictReportForm.PrintTotals(Sender : TObject;
                                                 TotalsRec : TotalsRecord;
                                                 HeaderStr,
                                                 AmountFormatStr : String);

begin
  with TotalsRec, Sender as TBaseReport do
    begin
      If (LinesLeft < 8)
        then
          begin
            NewPage;
            PrintSection2Header(Sender);
          end;

      ClearTabs;
      SetTab(0.3, pjLeft, 3.0, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(3.4, pjLeft, 2.2, 0, BoxLineNone, 0);  {Col1}
      SetTab(5.8, pjLeft, 2.2, 0, BoxLineNone, 0);  {Col2}
      SetTab(8.2, pjLeft, 2.2, 0, BoxLineNone, 0);  {Col3}
      SetTab(10.6, pjLeft, 2.2, 0, BoxLineNone, 0);  {Col4}

      Println(' ');
      Println(#9 + HeaderStr +
              #9 + 'FRONTAGE:' +
                   ShiftRightAddBlanks(Take(13, FormatFloat(DecimalDisplay_BlankZero, Frontage))) +
              #9 + 'ACRES:' +
                   ShiftRightAddBlanks(Take(16, FormatFloat(DecimalDisplay_BlankZero, Acres))) +
              #9 + 'AMOUNT:' +
                   ShiftRightAddBlanks(Take(15, FormatFloat(AmountFormatStr, Amount))) +
              #9 + '2ND UNITS:' +
                   ShiftRightAddBlanks(Take(12, FormatFloat(DecimalDisplay_BlankZero, SecondaryUnits))));

      Println(#9 + '  PARCELS:' +
                   ShiftRightAddBlanks(Take(12, IntToStr(Count))) +
              #9 + 'DEPTH:' +
                   ShiftRightAddBlanks(Take(16, FormatFloat(DecimalDisplay_BlankZero, Depth))) +
              #9 + 'ASSESSED:' +
                   ShiftRightAddBlanks(Take(13, FormatFloat(NoDecimalDisplay_BlankZero, TotalAssessedVal))) +
              #9 + 'UNITS:' +
                   ShiftRightAddBlanks(Take(16, FormatFloat(DecimalDisplay_BlankZero, TotalsRec.Units))));

    end;  {with Sender as TBaseReport do}

end;  {PrintTotals}

{===================================================================}
Procedure TSpecialDistrictReportForm.TextFilerBeforePrint(Sender: TObject);

begin
  SortSDTable.First;
  CurrentSwisCode := SortSDTable.FieldByName('SwisCode').Text;
  PartName := 'SPECIAL DISTRICT REPORT';
  Subheader := 'SPECIAL DISTRICT CODES WITHIN PARCEL';
  ReportTime := Now;
end;  {TextFilerBeforePrint}

{===================================================================}
Procedure TSpecialDistrictReportForm.PrintHeader(Sender: TObject);

{Print the overall report header.}

var
  TempStr, TempStr2 : String;

{FXX09081999-5: Add in year of printing and skip one line at beginning.}

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.2;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;

      Println('');
      TempStr := 'COUNTY OF ' + GlblCountyName;
      Println(Take(43, TempStr) +
              Center(PartName, 43) +
              RightJustify('DATE: ' + DateToStr(Date) +
                           '  TIME: ' + TimeToStr(ReportTime), 44));

      TempStr := UpcaseStr(GetMunicipalityName);
      TempStr2 := 'PAGE: ' + IntToStr(CurrentPage);

      Println(Take(43, TempStr) +
              Center(Subheader, 43) +
              RightJustify(TempStr2, 44));

        {FXX12021998-3: Print the village name.}

      FindKeyOld(SwisCodeTable, ['SwisCode'], [CurrentSwisCode]);

      If PrintBySwisCode
        then TempStr := 'SWIS - ' + CurrentSwisCode + '  (' +
                        Trim(SwisCodeTable.FieldByName('MunicipalityName').Text) + ')'
        else TempStr := '';

      Println(Take(43, TempStr) +
              Center(AssessmentYear + ' ASSESSMENT YEAR', 43));

    end;  {with Sender as TBaseReport do}

end;  {PrintHeader}

{===================================================================}
Procedure TSpecialDistrictReportForm.InsertSDInExtractFile(var ExtractFile : TextFile;
                                                               AmountFormatStr : String;
                                                               SortSDTable : TTable);

{CHG12082004-1(2.8.1.2)[2017]: Add account #, village, and zip code to the extract.}

begin
  with SortSDTable do
    begin
      FindKeyOld(SwisCodeTable, ['SwisCode'], [FieldByName('SwisCode').Text]);

      WriteCommaDelimitedLine(ExtractFile,
                              [FieldByName('SwisCode').Text,
                               SwisCodeTable.FieldByName('MunicipalityName').Text,
                               ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text),
                               FieldByName('SBLKey').Text,
                               FieldByName('SDCode').Text,
                               FieldByName('Name').Text]);

      If ExtractAllNameAddressFields
        then
          try
            WriteCommaDelimitedLine(ExtractFile,
                                    [FieldByName('Name2').Text,
                                     FieldByName('Address1').Text,
                                     FieldByName('Address2').Text,
                                     FieldByName('Street').Text,
                                     FieldByName('City').Text,
                                     FieldByName('State').Text,
                                     FieldByName('Zip').Text]);
          except
          end;

      If PrintMailingAddress
        then WriteCommaDelimitedLine(ExtractFile,
                                     [FieldByName('Name2').Text,
                                      FieldByName('Address1').Text,
                                      FieldByName('Address2').Text,
                                      FieldByName('Address3').Text,
                                      FieldByName('Address4').Text]);

        {CHG09252002-1: Add ability to print mailing address, old SBL, and extract to excel.}

      If PrintOldSBL
        then WriteCommaDelimitedLine(ExtractFile, [FieldByName('RemapOldSBL').Text])
        else WriteCommaDelimitedLine(ExtractFile, []);

      WritelnCommaDelimitedLine(ExtractFile,
                                [GetLegalAddressFromTable(SortSDTable),
                                 FieldByName('RollSection').Text,
                                 FieldByName('PropertyClass').Text,
                                 FieldByName('SchoolCode').Text,
                                 FormatFloat(DecimalDisplay_BlankZero,
                                             FieldByName('Frontage').AsFloat),
                                 FormatFloat(DecimalDisplay_BlankZero,
                                             FieldByName('Depth').AsFloat),
                                 FormatFloat(DecimalDisplay_BlankZero,
                                             FieldByName('Acres').AsFloat),
                                 FieldByName('TotalAssessedVal').AsInteger,
                                 FieldByName('AccountNo').Text,
                                 FieldByName('Zip').Text,
                                 FieldByName('CalcCode').Text,
                                 FieldByName('HomesteadCode').Text,
                                 FormatFloat(AmountFormatStr,
                                             FieldByName('Amount').AsFloat),
                                 FormatFloat(DecimalDisplay_BlankZero,
                                             FieldByName('Units').AsFloat),
                                 FormatFloat(DecimalDisplay_BlankZero,
                                             FieldByName('SecondaryUnits').AsFloat)]);

    end;  {with SortSDTable do}

end;  {InsertSDInExtractFile}

{===================================================================}
Function FindSDCodeInList(SDCodesThisParcel : TList;
                          _SDCode : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (SDCodesThisParcel.Count - 1) do
    with SDInformationPointer(SDCodesThisParcel[I])^ do
      If _Compare(SDCode, _SDCode, coEqual)
        then Result := I;

end;  {FindSDCodeInList}

{===================================================================}
Procedure TSpecialDistrictReportForm.InsertSDInSDCodeColumnExtractFile(var ExtractFile : TextFile;
                                                                           SDSortTable : TTable;
                                                                           SelectedSDCodes : TStringList;
                                                                           SDCodesThisParcel : TList;
                                                                           LastEntry : Boolean);

var
  I, Index : Integer;

begin
    {If this is not the last entry in the file, we are past the record we want.}

  If not LastEntry
    then SDSortTable.Prior;

  with SDSortTable do
    begin
      WriteCommaDelimitedLine(ExtractFile, [FieldByName('SwisCode').Text,
                                            ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text),
                                            FieldByName('SwisCode').Text + FieldByName('SBLKey').Text,
                                            FieldByName('Name').Text]);

      If PrintMailingAddress
        then WriteCommaDelimitedLine(ExtractFile, [FieldByName('Name2').Text,
                                                   FieldByName('Address1').Text,
                                                   FieldByName('Address2').Text,
                                                   FieldByName('Address3').Text,
                                                   FieldByName('Address4').Text]);

        {CHG09252002-1: Add ability to print mailing address, old SBL, and extract to excel.}

      If PrintOldSBL
        then WriteCommaDelimitedLine(ExtractFile, [FieldByName('RemapOldSBL').Text])
        else WriteCommaDelimitedLine(ExtractFile, []);

      WriteCommaDelimitedLine(ExtractFile, [GetLegalAddressFromTable(SortSDTable),
                                            FieldByName('RollSection').Text,
                                            FieldByName('PropertyClass').Text,
                                            FieldByName('SchoolCode').Text,
                                            FormatFloat(DecimalDisplay_BlankZero,
                                                        FieldByName('Frontage').AsFloat),
                                            FormatFloat(DecimalDisplay_BlankZero,
                                                        FieldByName('Depth').AsFloat),
                                            FormatFloat(DecimalDisplay_BlankZero,
                                                        FieldByName('Acres').AsFloat),
                                            FormatFloat(NoDecimalDisplay,
                                                        TCurrencyField(FieldByName('TotalAssessedVal')).Value)]);

      For I := 0 to (SelectedSDCodes.Count - 1) do
        begin
          Index := FindSDCodeInList(SDCodesThisParcel, SelectedSDCodes[I]);

          If _Compare(Index, -1, coGreaterThan)
            then
              with SDInformationPointer(SDCodesThisParcel[Index])^ do
                WriteCommaDelimitedLine(ExtractFile, ['X',
                                                      CalcCode,
                                                      FormatFloat(DecimalDisplay_BlankZero, Amount),
                                                      FormatFloat(DecimalDisplay_BlankZero, Units),
                                                      FormatFloat(DecimalDisplay_BlankZero, SecondaryUnits)])
            else WriteCommaDelimitedLine(ExtractFile, ['', '', '', '', '']);

        end;  {For I := 0 to (SelectedSDCodes.Count - 1) do}

      WritelnCommaDelimitedLine(ExtractFile, ['']);

    end;  {with SortSDTable do}

    {Don't forget to move back to the right position!}

  If not LastEntry
    then SDSortTable.Next;

end;  {InsertSDInSDCodeColumnExtractFile}

{===================================================================}
Procedure TSpecialDistrictReportForm.PrintSection1Header(Sender : TObject);

{Print the header for the SD listing by SBL.}

begin
  PrintHeader(Sender);

  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjCenter, 1.7, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.1, pjCenter, 1.4, 0, BoxLineNone, 0);  {Name}
      SetTab(3.6, pjCenter, 1.1, 0, BoxLineNone, 0);  {Address}
      SetTab(4.8, pjCenter, 0.2, 0, BoxLineNone, 0);  {R\S}
      SetTab(5.1, pjCenter, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(5.5, pjCenter, 0.6, 0, BoxLineNone, 0);  {School code}
      SetTab(6.2, pjCenter, 0.7, 0, BoxLineNone, 0);  {Frontage}
      SetTab(7.0, pjCenter, 0.7, 0, BoxLineNone, 0);  {Depth}
      SetTab(7.8, pjCenter, 0.7, 0, BoxLineNone, 0);  {Acres}
      SetTab(8.6, pjCenter, 1.0, 0, BoxLineNone, 0);  {Total AV}
      SetTab(9.7, pjCenter, 0.6, 0, BoxLineNone, 0);  {SD Code}
      SetTab(10.4, pjRight, 0.4, 0, BoxLineNone, 0);  {Calc code}
      SetTab(10.9, pjRight, 0.2, 0, BoxLineNone, 0);  {Homestead Code}
      SetTab(11.2, pjRight, 1.0, 0, BoxLineNone, 0);  {Amount}
      SetTab(12.3, pjRight, 0.6, 0, BoxLineNone, 0);  {Units}
      SetTab(13.0, pjRight, 0.5, 0, BoxLineNone, 0);  {2nd units}

      Println('');
      Println(#9 + #9 + #9 + #9 +
              #9 + 'PRP' +
              #9 + 'SCHOOL' +
              #9 + #9 + #9 + #9 + 'TOTAL' +
              #9 + 'SD' +
              #9 + 'CALC' +
              #9 + #9 + #9 + #9 + '2ND');
      Println(#9 + 'PARCEL ID' +
              #9 + 'NAME' +
              #9 + 'ADDRESS' +
              #9 + 'RS' +
              #9 + 'CLS' +
              #9 + 'CODE' +
              #9 + 'FRONT' +
              #9 + 'DEPTH' +
              #9 + 'ACRES' +
              #9 + 'AV' +
              #9 + 'CODE' +
              #9 + 'CODE' +
              #9 + 'HC' +
              #9 + 'AMOUNT' +
              #9 + 'UNITS' +
              #9 + 'UNITS');

      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.7, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.1, pjLeft, 1.4, 0, BoxLineNone, 0);  {Name}
      SetTab(3.6, pjLeft, 1.1, 0, BoxLineNone, 0);  {Address}
      SetTab(4.8, pjLeft, 0.2, 0, BoxLineNone, 0);  {R\S}
      SetTab(5.1, pjCenter, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(5.5, pjLeft, 0.6, 0, BoxLineNone, 0);  {School code}
      SetTab(6.2, pjRight, 0.7, 0, BoxLineNone, 0);  {Frontage}
      SetTab(7.0, pjRight, 0.7, 0, BoxLineNone, 0);  {Depth}
      SetTab(7.8, pjRight, 0.7, 0, BoxLineNone, 0);  {Acres}
      SetTab(8.6, pjRight, 1.0, 0, BoxLineNone, 0);  {Total AV}
      SetTab(9.7, pjLeft, 0.6, 0, BoxLineNone, 0);  {SD Code}
      SetTab(10.4, pjRight, 0.4, 0, BoxLineNone, 0);  {Calc code}
      SetTab(10.9, pjRight, 0.2, 0, BoxLineNone, 0);  {Homestead Code}
      SetTab(11.2, pjRight, 1.0, 0, BoxLineNone, 0);  {Amount}
      SetTab(12.3, pjRight, 0.6, 0, BoxLineNone, 0);  {Units}
      SetTab(13.0, pjRight, 0.5, 0, BoxLineNone, 0);  {2nd units}

    end;  {with Sender as TBaseReport do}

end;  {PrintSDSection1Header}

{===================================================================}
Procedure TSpecialDistrictReportForm.PrintSection1(    Sender : TObject;
                                                   var Quit : Boolean);

{Print the SDs by SBL. Break by swis.}

var
  FirstEntryOnPage,
  IsMoveTax, Done, FirstTimeThrough : Boolean;
  PreviousSBLKey : String;
  PreviousSwisCode : String;
  I : Integer;
  TempIndex, TempStr, AmountFormatStr : String;
  SDCodesThisParcel : TList;
  SDInformationPtr : SDInformationPointer;

begin
  SDCodesThisParcel := TList.Create;
  Done := False;
  FirstTimeThrough := True;
  FirstEntryOnPage := True;
  ParcelsExtracted := True;
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortSDTable);

  ProgressDialog.UserLabelCaption := 'Special Districts In S\B\L.';

    {FXX09071999-1: Add print by name and addr.}

  case PrintOrder of
    poParcelID : TempIndex := 'SwisCodeKey+SBLKey+SDCode';
    poName : TempIndex := 'SwisCodeKey+Name+SDCode';
    poLegalAddress : TempIndex := 'SwisCodeKey+LegalAddr+LegalAddrNo+SDCode';
  end;

  SortSDTable.AddIndex('SDReportSearchIndex1',
                       TempIndex, [ixExpression]);

  with Sender as TBaseReport do
    begin
      try
        SortSDTable.First;
      except
        Quit := True;
        SystemSupport(050, SortSDTable, 'Error getting SD sort record.',
                      UnitName, GlblErrorDlgBox);
      end;

      PreviousSwisCode := SortSDTable.FieldByName('SwisCode').Text;
      PreviousSBLKey := '';

      PrintSection1Header(Sender);

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else
            try
              SortSDTable.Next;
            except
              Quit := True;
              SystemSupport(050, SortSDTable, 'Error getting SD sort record.',
                            UnitName, GlblErrorDlgBox);
            end;

        Application.ProcessMessages;

        If SortSDTable.EOF
          then Done := True;

        If not (Done or Quit)
          then
            begin
              ProgressDialog.Update(Self,
                                    'S\B\L: ' + ConvertSBLOnlyToDashDot(SortSDTable.FieldByName('SBLKey').Text));

                {If they switched swis codes or they are at
                 the end of this page, start a new page.}

              If ((not Done) and
                  (PrintBySwisCode and
                   (Take(6, PreviousSwisCode) <> Take(6, SortSDTable.FieldByName('SwisCode').Text))) or
                   (LinesLeft < 10))
                then
                  begin
                    CurrentSwisCode := SortSDTable.FieldByName('SwisCode').Text;
                    NewPage;
                    FirstEntryOnPage := True;
                    PrintSection1Header(Sender);

                  end;  {If (LinesLeft < 5)}

                {Determine the format for the amount printing.}

              FindKeyOld(SDCodeTable, ['SDistCode'],
                         [SortSDTable.FieldByName('SDCode').Text]);

              IsMoveTax := False;

                {Search through the extensions to see if this is a move tax.}

              For I := 1 to 10 do
                begin
                  TempStr := 'ECd' + IntToStr(I);
                  If ((SDCodeTable.FieldByName(TempStr).Text = SdistEcMT) or
                      (SDCodeTable.FieldByName(TempStr).Text = SdistEcFE))
                    then IsMoveTax := True;
                end;  {For I := 1 to 10 do}

              If IsMoveTax
                then AmountFormatStr := DecimalDisplay_BlankZero
                else AmountFormatStr := NoDecimalDisplay_BlankZero;

                {Only print the SBL, name ... assessment if this is the
                 first SD for this parcel.}

              with SortSDTable do
                begin
                    {CHG01022003-2: Option to make each SD a seperate column in Excel extract.}

                  If ExtractToExcel
                    then
                      If EachSDCodeIsAColumn
                        then
                          begin
                            If ((Deblank(PreviousSBLKey) <> '') and
                                (Take(20, PreviousSBLKey) <> Take(20, FieldByName('SBLKey').Text)))
                              then
                                begin
                                  InsertSDInSDCodeColumnExtractFile(ExtractFile, SortSDTable,
                                                                    SelectedSDCodes, SDCodesThisParcel, False);

                                  ClearTList(SDCodesThisParcel, SizeOf(SDInformationRecord));

                                end;  {If ((Deblank(PreviousSBLKey) <> '') and ...}

                          end
                        else InsertSDInExtractFile(ExtractFile, AmountFormatStr, SortSDTable);

                  New(SDInformationPtr);

                  with SDInformationPtr^ do
                    begin
                      SDCode := FieldByName('SDCode').Text;
                      CalcCode := FieldByName('CalcCode').Text;
                      Amount := FieldByName('Amount').AsFloat;
                      Units := FieldByName('Units').AsFloat;
                      SecondaryUnits := FieldByName('SecondaryUnits').AsFloat;

                    end;  {with SDInformationPtr^ do}

                  SDCodesThisParcel.Add(SDInformationPtr);

                  If ((Take(20, PreviousSBLKey) <> Take(20, FieldByName('SBLKey').Text)) or
                      FirstEntryOnPage)
                    then Print(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text) +
                               #9 + Take(13, FieldByName('Name').Text) +
                               #9 + Take(10, GetLegalAddressFromTable(SortSDTable)) +
                               #9 + FieldByName('RollSection').Text +
                               #9 + FieldByName('PropertyClass').Text +
                               #9 + FieldByName('SchoolCode').Text +
                               #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                FieldByName('Frontage').AsFloat) +
                               #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                FieldByName('Depth').AsFloat) +
                               #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                FieldByName('Acres').AsFloat) +
                               #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                TCurrencyField(FieldByName('TotalAssessedVal')).Value))
                    else Print(#9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9);  {Skip these fields.}

                    {Now print the SD amounts.}

                  Println(#9 + FieldByName('SDCode').Text +
                          #9 + FieldByName('CalcCode').Text +
                          #9 + FieldByName('HomesteadCode').Text +
                          #9 + FormatFloat(AmountFormatStr,
                                           FieldByName('Amount').AsFloat) +
                          #9 + FormatFloat(DecimalDisplay_BlankZero,
                                           FieldByName('Units').AsFloat) +
                          #9 + FormatFloat(DecimalDisplay_BlankZero,
                                           FieldByName('SecondaryUnits').AsFloat));

                    {CHG09252002-1: Add ability to print mailing address, old SBL, and extract to excel.}

                  If PrintOldSBL
                    then Println(#9 + FieldByName('RemapOldSBL').Text);

                  FirstEntryOnPage := False;

                end;  {with SortSDTable do}

            end;  {If not Done or Quit}

        PreviousSwisCode := SortSDTable.FieldByName('SwisCode').Text;
        PreviousSBLKey := SortSDTable.FieldByName('SBLKey').Text;

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

    end;  {with Sender as TBaseReport do}

  If ExtractToExcel
    then
      If EachSDCodeIsAColumn
        then InsertSDInSDCodeColumnExtractFile(ExtractFile, SortSDTable,
                                               SelectedSDCodes, SDCodesThisParcel, True)
        else InsertSDInExtractFile(ExtractFile, AmountFormatStr, SortSDTable);

  SDCodesThisParcel.Free;

end;  {PrintSection1}

{===================================================================}
Procedure TSpecialDistrictReportForm.PrintSection2Header(Sender : TObject);

{Print the header for the special district listing by SBL.}

begin
  PrintHeader(Sender);

    {CHG09252002-1: Add ability to print mailing address, old SBL, and extract to excel.}

  with Sender as TBaseReport do
    If PrintMailingAddress
      then
        begin
          ClearTabs;
          SetTab(0.3, pjCenter, 0.6, 0, BoxLineNone, 0);  {SD Code}
          SetTab(1.0, pjCenter, 1.7, 0, BoxLineNone, 0);  {Parcel ID}
          SetTab(2.8, pjCenter, 2.5, 0, BoxLineNone, 0);  {Name}
          SetTab(5.4, pjCenter, 1.2, 0, BoxLineNone, 0);  {Address}
          SetTab(6.7, pjCenter, 0.2, 0, BoxLineNone, 0);  {R\S}
          SetTab(7.0, pjCenter, 0.7, 0, BoxLineNone, 0);  {Prop class \ school code}
          SetTab(7.8, pjCenter, 0.8, 0, BoxLineNone, 0);  {Frontage \ Depth}
          SetTab(8.7, pjCenter, 0.8, 0, BoxLineNone, 0);  {Acres}
          SetTab(9.6, pjCenter, 1.2, 0, BoxLineNone, 0);  {Total AV}
          SetTab(10.9, pjRight, 0.4, 0, BoxLineNone, 0);  {Calc code}
          SetTab(11.4, pjRight, 1.2, 0, BoxLineNone, 0);  {Amount}
          SetTab(12.7, pjRight, 0.6, 0, BoxLineNone, 0);  {Units}
          SetTab(13.4, pjCenter, 0.5, 0, BoxLineNone, 0);  {2nd units}

          Println('');
          Println(#9 + 'SD' +
                  #9 + #9 + #9 + #9 +
                  #9 + 'PRP CLS' +
                  #9 + 'FRONT' +
                  #9 + #9 + 'TOTAL' +
                  #9 + 'CALC' +
                  #9 + #9 + #9 + '2ND');
          Println(#9 + 'CODE' +
                  #9 + 'PARCEL ID' +
                  #9 + 'NAME' +
                  #9 + 'ADDRESS' +
                  #9 + 'RS' +
                  #9 + 'SCHOOL' +
                  #9 + 'DEPTH' +
                  #9 + 'ACRES' +
                  #9 + 'ASSSESSMENT' +
                  #9 + 'CODE' +
                  #9 + 'AMOUNT' +
                  #9 + 'UNITS' +
                  #9 + 'UNITS');

          Println('');

          ClearTabs;
          SetTab(0.3, pjLeft, 0.6, 0, BoxLineNone, 0);  {SD Code}
          SetTab(1.0, pjLeft, 1.7, 0, BoxLineNone, 0);  {Parcel ID}
          SetTab(2.8, pjLeft, 2.5, 0, BoxLineNone, 0);  {Name}
          SetTab(5.4, pjLeft, 1.2, 0, BoxLineNone, 0);  {Address}
          SetTab(6.7, pjLeft, 0.2, 0, BoxLineNone, 0);  {R\S}
          SetTab(7.0, pjRight, 0.7, 0, BoxLineNone, 0);  {Prop class \ School Code}
          SetTab(7.8, pjRight, 0.8, 0, BoxLineNone, 0);  {Frontage \ Depth}
          SetTab(8.7, pjRight, 0.8, 0, BoxLineNone, 0);  {Acres}
          SetTab(9.6, pjRight, 1.2, 0, BoxLineNone, 0);  {Total AV}
          SetTab(10.9, pjRight, 0.4, 0, BoxLineNone, 0);  {Calc code}
          SetTab(11.4, pjRight, 1.2, 0, BoxLineNone, 0);  {Amount}
          SetTab(12.7, pjRight, 0.6, 0, BoxLineNone, 0);  {Units}
          SetTab(13.4, pjRight, 0.5, 0, BoxLineNone, 0);  {2nd units}

        end
      else
        begin
          ClearTabs;
          SetTab(0.3, pjCenter, 0.6, 0, BoxLineNone, 0);  {SD Code}
          SetTab(1.0, pjCenter, 1.7, 0, BoxLineNone, 0);  {Parcel ID}
          SetTab(2.8, pjCenter, 1.4, 0, BoxLineNone, 0);  {Name}
          SetTab(4.3, pjCenter, 1.1, 0, BoxLineNone, 0);  {Address}
          SetTab(5.5, pjCenter, 0.2, 0, BoxLineNone, 0);  {R\S}
          SetTab(5.8, pjCenter, 0.3, 0, BoxLineNone, 0);  {Prop class}
          SetTab(6.2, pjCenter, 0.6, 0, BoxLineNone, 0);  {School code}
          SetTab(6.9, pjCenter, 0.7, 0, BoxLineNone, 0);  {Frontage}
          SetTab(7.7, pjCenter, 0.7, 0, BoxLineNone, 0);  {Depth}
          SetTab(8.5, pjCenter, 0.7, 0, BoxLineNone, 0);  {Acres}
          SetTab(9.3, pjCenter, 1.1, 0, BoxLineNone, 0);  {Total AV}
          SetTab(10.5, pjRight, 0.4, 0, BoxLineNone, 0);  {Calc code}
          SetTab(11.0, pjRight, 0.2, 0, BoxLineNone, 0);  {Homestead Code}
          SetTab(11.3, pjRight, 1.0, 0, BoxLineNone, 0);  {Amount}
          SetTab(12.4, pjRight, 0.6, 0, BoxLineNone, 0);  {Units}
          SetTab(13.2, pjCenter, 0.5, 0, BoxLineNone, 0);  {2nd units}

          Println('');
          Println(#9 + 'SD' +
                  #9 + #9 + #9 + #9 +
                  #9 + 'PRP' +
                  #9 + 'SCHOOL' +
                  #9 + #9 + #9 + #9 + 'TOTAL' +
                  #9 + 'CALC' +
                  #9 + #9 + #9 + #9 + '2ND');
          Println(#9 + 'CODE' +
                  #9 + 'PARCEL ID' +
                  #9 + 'NAME' +
                  #9 + 'ADDRESS' +
                  #9 + 'RS' +
                  #9 + 'CLS' +
                  #9 + 'CODE' +
                  #9 + 'FRONT' +
                  #9 + 'DEPTH' +
                  #9 + 'ACRES' +
                  #9 + 'ASSSESSMENT' +
                  #9 + 'CODE' +
                  #9 + 'HC' +
                  #9 + 'AMOUNT' +
                  #9 + 'UNITS' +
                  #9 + 'UNITS');

          Println('');

          ClearTabs;
          SetTab(0.3, pjLeft, 0.6, 0, BoxLineNone, 0);  {SD Code}
          SetTab(1.0, pjLeft, 1.7, 0, BoxLineNone, 0);  {Parcel ID}
          SetTab(2.8, pjLeft, 1.4, 0, BoxLineNone, 0);  {Name}
          SetTab(4.3, pjLeft, 1.1, 0, BoxLineNone, 0);  {Address}
          SetTab(5.5, pjLeft, 0.2, 0, BoxLineNone, 0);  {R\S}
          SetTab(5.8, pjLeft, 0.3, 0, BoxLineNone, 0);  {Prop class}
          SetTab(6.2, pjLeft, 0.6, 0, BoxLineNone, 0);  {School code}
          SetTab(6.9, pjRight, 0.7, 0, BoxLineNone, 0);  {Frontage}
          SetTab(7.7, pjRight, 0.7, 0, BoxLineNone, 0);  {Depth}
          SetTab(8.5, pjRight, 0.7, 0, BoxLineNone, 0);  {Acres}
          SetTab(9.3, pjRight, 1.1, 0, BoxLineNone, 0);  {Total AV}
          SetTab(10.5, pjRight, 0.4, 0, BoxLineNone, 0);  {Calc code}
          SetTab(11.0, pjRight, 0.2, 0, BoxLineNone, 0);  {Homestead Code}
          SetTab(11.3, pjRight, 1.0, 0, BoxLineNone, 0);  {Amount}
          SetTab(12.4, pjRight, 0.6, 0, BoxLineNone, 0);  {Units}
          SetTab(13.2, pjCenter, 0.5, 0, BoxLineNone, 0);  {2nd units}

        end;  {else of If PrintMailingAddress}

end;  {PrintSection2Header}

{===================================================================}
Procedure TSpecialDistrictReportForm.PrintSection2(    Sender : TObject;
                                                   var Quit : Boolean);

{Print the special districts by SDCode \SBL. Break by swis.}

var
  Done, FirstTimeThrough, NewSDCode,
  IsMoveTax, FirstLineOnPage : Boolean;
  PreviousSwisCode : String;
  PreviousSDCode : String;
  I : Integer;
  SwisTotalsRec, SDTotalsRec : TotalsRecord;
  TempStr, AmountFormatStr, TempFieldName : String;

begin
  Done := False;
  FirstTimeThrough := True;
  FirstLineOnPage := True;

  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortSDTable);

  ProgressDialog.UserLabelCaption := 'Special Districts by SD Code.';

  InitTotalsRec(SwisTotalsRec);
  InitTotalsRec(SDTotalsRec);

  with Sender as TBaseReport do
    begin
      PreviousSwisCode := SortSDTable.FieldByName('SwisCode').Text;
      PreviousSDCode := '';

      CurrentSwisCode := PreviousSwisCode;
      PartName := 'SPECIAL DISTRICT REPORT';
      Subheader := 'PARCELS WITHIN SPECIAL DISTRICT CODE';

      PrintSection2Header(Sender);

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else
            try
              SortSDTable.Next;
            except
              Quit := True;
              SystemSupport(050, SortSDTable, 'Error getting special district sort record.',
                            UnitName, GlblErrorDlgBox);
            end;

        Application.ProcessMessages;

        If SortSDTable.EOF
          then Done := True;

          {Check to see if we need to print totals or start a new page.}

        If not Quit
          then
            begin
              NewSDCode := False;

                {If we are on a different exemption code, then print out the totals
                 for the last exemption code.}

              If (((Take(5, PreviousSDCode) <> Take(5, SortSDTable.FieldByName('SDCode').Text)) and
                   (Deblank(PreviousSDCode) <> '')) or
                  Done)
                then
                  begin
                    NewSDCode := True;

                       {Determine the format for the amount printing.}

                    FindKeyOld(SDCodeTable, ['SDistCode'],
                               [SortSDTable.FieldByName('SDCode').Text]);

                    IsMoveTax := False;

                      {Search through the extensions to see if this is a move tax.}

                    For I := 1 to 10 do
                      begin
                        TempStr := 'ECd' + IntToStr(I);
                        If ((SDCodeTable.FieldByName(TempStr).Text = SdistEcMT) or
                            (SDCodeTable.FieldByName(TempStr).Text = SdistEcFE))
                          then IsMoveTax := True;
                      end;  {For I := 1 to 10 do}

                    If IsMoveTax
                      then AmountFormatStr := DecimalDisplay_BlankZero
                      else AmountFormatStr := NoDecimalDisplay_BlankZero;

                    PrintTotals(Sender, SwisTotalsRec,
                                'SWIS: ' + PreviousSwisCode +
                                ' SD: ' + PreviousSDCode,
                                AmountFormatStr);
                    InitTotalsRec(SwisTotalsRec);

                    PrintTotals(Sender, SDTotalsRec,
                                'TOTAL SD ' + PreviousSDCode + ':',
                                AmountFormatStr);
                    InitTotalsRec(SDTotalsRec);

                    If not Done
                      then
                        begin
                          NewPage;
                          PrintSection2Header(Sender);
                        end;

                    FirstLineOnPage := True;

                  end;  {If (Take(5, PreviousSDCode) <> Take(5, SortSDTable.FieldByName('SDCode').Text))}

                {If they switched swis codes or they are at
                 the end of this page, start a new page.}

              If (((PrintBySwisCode and
                    (Take(6, PreviousSwisCode) <> Take(6, SortSDTable.FieldByName('SwisCode').Text))) or
                   (LinesLeft < 10)) and
                  (not NewSDCode))
                then
                  begin
                    If (PrintBySwisCode and
                        (Take(6, PreviousSwisCode) <> Take(6, SortSDTable.FieldByName('SwisCode').Text)))
                      then
                        begin
                          PrintTotals(Sender, SwisTotalsRec,
                                      'SWIS: ' + PreviousSwisCode +
                                      ' SD: ' + PreviousSDCode,
                                      AmountFormatStr);
                          InitTotalsRec(SwisTotalsRec);
                        end;

                    If not Done
                      then
                        begin
                          NewPage;
                          CurrentSwisCode := SortSDTable.FieldByName('SwisCode').Text;
                          PrintSection2Header(Sender);
                          FirstLineOnPage := True;
                        end;

                  end;  {If (LinesLeft < 9)}

            end;  {If not Quit}

        If not Done or Quit
          then
            begin
              ProgressDialog.Update(Self,
                                    'SD Code: ' +
                                    SortSDTable.FieldByName('SDCode').Text);

                {Only print the SD code if this is the
                 first parcel for this SD.}

              If (ExtractToExcel and
                  (not ParcelsExtracted))
                then InsertSDInExtractFile(ExtractFile, AmountFormatStr, SortSDTable);

              with SortSDTable do
                begin
                  If ((Take(5, PreviousSDCode) <> Take(5, FieldByName('SDCode').Text)) or
                      FirstLineOnPage)
                    then Print(#9 + FieldByName('SDCode').Text)
                    else Print(#9);  {Skip the SD code.}

                    {Now print the SD amounts.}

                    {CHG09252002-1: Add ability to print mailing address, old SBL, and extract to excel.}

                  If PrintMailingAddress
                    then
                      begin
                        Println(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text) +
                                #9 + Take(25, FieldByName('Name').Text) +
                                #9 + Take(12, GetLegalAddressFromTable(SortSDTable)) +
                                #9 + FieldByName('RollSection').Text +
                                #9 + FieldByName('PropertyClass').Text +
                                #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                 FieldByName('Frontage').AsFloat) +
                                #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                 FieldByName('Acres').AsFloat) +
                                #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                 TCurrencyField(FieldByName('TotalAssessedVal')).Value) +
                                #9 + FieldByName('CalcCode').Text +
                                #9 + FormatFloat(AmountFormatStr,
                                                 FieldByName('Amount').AsFloat) +
                                #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                 FieldByName('Units').AsFloat) +
                                #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                 FieldByName('SecondaryUnits').AsFloat));

                        If PrintOldSBL
                          then Print(#9 + #9 + FieldByName('RemapOldSBL').Text)
                          else Print(#9 + #9);

                        Println(#9 + Take(25, FieldByName('Name2').Text) +
                                #9 + #9 +
                                #9 + FieldByName('SchoolCode').Text +
                                #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                 FieldByName('Depth').AsFloat));

                        For I := 1 to 4 do
                          begin
                            TempFieldName := 'Address' + IntToStr(I);

                            If (Deblank(FieldByName(TempFieldName).Text) <> '')
                              then Println(#9 + #9 + #9 + Take(25, FieldByName(TempFieldName).Text));

                          end;  {For I := 1 to 4 do}

                        Println('');

                      end
                    else
                      begin
                        Println(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text) +
                                #9 + Take(13, FieldByName('Name').Text) +
                                #9 + Take(10, GetLegalAddressFromTable(SortSDTable)) +
                                #9 + FieldByName('RollSection').Text +
                                #9 + FieldByName('PropertyClass').Text +
                                #9 + FieldByName('SchoolCode').Text +
                                #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                 FieldByName('Frontage').AsFloat) +
                                #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                 FieldByName('Depth').AsFloat) +
                                #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                 FieldByName('Acres').AsFloat) +
                                #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                 TCurrencyField(FieldByName('TotalAssessedVal')).Value) +
                                #9 + FieldByName('CalcCode').Text +
                                #9 + FieldByName('HomesteadCode').Text +
                                #9 + FormatFloat(AmountFormatStr,
                                                 FieldByName('Amount').AsFloat) +
                                #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                 FieldByName('Units').AsFloat) +
                                #9 + FormatFloat(DecimalDisplay_BlankZero,
                                                 FieldByName('SecondaryUnits').AsFloat));

                        If PrintOldSBL
                          then
                            begin
                              Println(#9 + FieldByName('RemapOldSBL').Text);
                              Println('');
                            end;

                      end;  {else of If PrintMailingAddress}

                  FirstLineOnPage := False;

                  UpdateTotals(SDTotalsRec, SortSDTable);
                  UpdateTotals(SwisTotalsRec, SortSDTable);

                end;  {with SortSDTable do}

            end;  {If not Done or Quit}

        PreviousSwisCode := SortSDTable.FieldByName('SwisCode').Text;
        PreviousSDCode := SortSDTable.FieldByName('SDCode').Text;

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

    end;  {with Sender as TBaseReport do}

end;  {PrintSection2}

{===================================================================}
Procedure TSpecialDistrictReportForm.TextReportPrint(Sender: TObject);

{To print the report, we will print each of the segments seperately.
 We will not use the normal paging event driven methods.
 We will control all paging.}

var
  Quit : Boolean;
  TempIndex : String;

begin
  Quit := False;

    {FXX10091998-5: Allow them to select which section(s) to print.}

  If ((not (Quit or ReportCancelled)) and
      PrintSection1CheckBox.Checked)
    then
      begin
        SortSDTable.IndexName := 'BYSWISCODE_SBLKEY_SDCODE';
        PrintSection1(Sender, Quit);
      end;

    {FXX06231998-2: Allow them to not print section 2.}
    {FXX07271998-4: Actually, we always want to print ID by SD code, maybe not
                    other way.}

  If ((not (Quit or ReportCancelled)) and
      PrintSection2CheckBox.Checked)
    then
      begin
        CurrentSwisCode := SortSDTable.FieldByName('SwisCode').Text;
        PartName := 'SPECIAL DISTRICT REPORT';
        Subheader := 'PARCELS WITHIN SPECIAL DISTRICT CODE';

          {FXX12021998-5: If printing both sections, need to form feed.}

        If PrintSection1CheckBox.Checked
          then TBaseReport(Sender).NewPage;

          {FXX09071999-1: Add print by name and addr.}
          {FXX03202000-1: Had the First before the changing of the indexes.}
          {FXX0513200903(2.20.1.1): Do address order in actual legal addr int # order.}

        case PrintOrder of
          poParcelID : TempIndex := 'SwisCodeKey+SDCode+SBLKey';
          poName : TempIndex := 'SwisCodeKey+SDCode+Name';
          poLegalAddress : TempIndex := 'SwisCodeKey+SDCode+LegalAddr+LegalAddrInt';
        end;

        SortSDTable.AddIndex('SDReportSearchIndex2',
                             TempIndex, [ixExpression]);
        SortSDTable.IndexName := 'SDReportSearchIndex2';

        SortSDTable.First;

        PrintSection2(Sender, Quit);

      end;  {If ((not (Quit or ReportCancelled)) and ...}

end;  {ReportPrint}

{==================================================================}
Procedure TSpecialDistrictReportForm.ReportPrint(Sender: TObject);

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
Procedure TSpecialDistrictReportForm.FormClose(    Sender: TObject;
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