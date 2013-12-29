unit RCertiorariHistoryReport;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls;

type
  TCertiorariHistoryReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    CertiorariTable: TwwTable;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SortCertiorariHeaderTable: TTable;
    SortCertiorariDetailTable: TTable;
    PageControl1: TPageControl;
    OptionsTabSheet: TTabSheet;
    PrintOrderRadioGroupBox: TRadioGroup;
    GroupBox1: TGroupBox;
    CreateParcelListCheckBox: TCheckBox;
    UseAlternateIDCheckBox: TCheckBox;
    PrintToExcelCheckBox: TCheckBox;
    BlankRepresentativeIsProSeCheckBox: TCheckBox;
    SwisSchoolTabSheet: TTabSheet;
    Label14: TLabel;
    SchoolCodeListBox: TListBox;
    SwisCodeListBox: TListBox;
    Label9: TLabel;
    SwisCodeTable: TTable;
    SchoolCodeTable: TTable;
    ExtractCurrentAndAskingValueCheckBox: TCheckBox;
    Label1: TLabel;
    LoadFromParcelListCheckBox: TCheckBox;
    ParcelTable: TTable;
    Panel3: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    tb_Assessments: TTable;
    cbExtractSpecialDistricts: TCheckBox;
    tbSpecialDistrictCodes: TTable;
    tbParcelSpecialDistricts: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
  private
    { Private declarations }
  public
    ReportCancelled : Boolean;

    { Public declarations }
    UnitName : String;

    UseAlternateID,
    BlankRepresentativeIsProSe,
    PrintToExcel, CreateParcelList, LoadFromParcelList : Boolean;

    PrintOrder, CertiorariStatusType : Integer;

    EarliestCertiorariYear, MostRecentCertiorariYear,
    OrigSortHeaderFileName, OrigSortDetailFileName : String;

    ExtractFile : TextFile;
    SelectedSchoolCodes,
    SelectedSwisCodes, slSpecialDistrictCodes : TStringList;
    ExtractCurrentAndAskingValue, bExtractSpecialDistricts : Boolean;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Procedure FillSortTable(var Quit : Boolean);

  end;

implementation
Uses Utilitys,  {General utilitys}
     PASUTILS, {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     DataAccessUnit,
     Prog,
     RptDialg,
     GrievanceUtilitys,
     PRCLLIST,
     Preview;

{$R *.DFM}

type
  TotalsRecord = record
    Year : String;
    TotalAskingReductionValue,
    TotalAssessedValue,
    TotalAskingValue : LongInt;
  end;

  TotalsPointer = ^TotalsRecord;

const
  poParcelID = 0;
  poOwnerName = 1;
  poLegalAddress = 2;
  poRepresentative = 3;


{========================================================}
Procedure TCertiorariHistoryReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TCertiorariHistoryReportForm.InitializeForm;

begin
  UnitName := 'RCertiorariHistoryReport';  {mmm}

  OpenTablesForForm(Self, NextYear);

  OrigSortHeaderFileName := 'sortcerthisthdrtable';
  OrigSortDetailFileName := 'SortCertHistDtlTable';

  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName', 20,
                 True, True, ThisYear, GlblThisYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable,
                 'SchoolCode', 'SchoolName', 20,
                 True, True, ThisYear, GlblThisYear);

    {CHG02012004-1(2.07l1): Allow for the alternate ID to default to on or off.}

  UseAlternateIDCheckBox.Checked := GlblCertiorariReportsUseAlternateID;

end;  {InitializeForm}

{===================================================================}
Procedure TCertiorariHistoryReportForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{====================================================================}
Procedure TCertiorariHistoryReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Certiorari History.grs', 'Certiorari History Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TCertiorariHistoryReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Certiorari History.grs', 'Certiorari History Report');

end;  {LoadButtonClick}

{========================================================================}
{==================  PRINTING  ==========================================}
{========================================================================}
{======================================================================}
Procedure TCertiorariHistoryReportForm.FillSortTable(var Quit : Boolean);

var
  Done, FirstTimeThrough,
  CertiorariOpen,
  HeaderInsertedForThisCertiorari : Boolean;
  StatusThisCertiorari, LegalAddressInt, Index : Integer;
  iCurrentValue : LongInt;
  PropertyClassCode, OwnershipCode,
  LawyerCode, OwnerName, LegalAddress,
  LegalAddressNo, SchoolCode,
  CurrentSwisSBLKey, LastSwisSBLKey, ParcelListSwisSBLKey : String;

begin
  Index := 1;
  Done := False;
  FirstTimeThrough := True;
  HeaderInsertedForThisCertiorari := False;
  LastSwisSBLKey := '';
  EarliestCertiorariYear := CertiorariTable.FieldByName('TaxRollYr').Text;
  MostRecentCertiorariYear := CertiorariTable.FieldByName('TaxRollYr').Text;

    {CHG10122004-1(2.8.0.14): Add the option to load from a parcel list.}

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
        ParcelListSwisSBLKey := ParcelListDialog.GetParcelSwisSBLKey(Index);
        FindNearestOld(CertiorariTable, ['SwisSBLKey', 'TaxRollYr'],
                       [ParcelListSwisSBLKey, '']);

      end
    else
      begin
        CertiorariTable.First;
        ProgressDialog.Start(GetRecordCount(CertiorariTable), True, True);
      end;

  OwnerName := '';
  LegalAddress := '';
  LegalAddressNo := '';
  SchoolCode := '';
  LawyerCode := '';
  LegalAddressInt := 0;
  PropertyClassCode := '';
  OwnershipCode := '';
  iCurrentValue := 0;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CertiorariTable.Next;

      {If we are loading from a parcel list, did we go to a new SBL?
       If so, go to the next parcle in the list.}

    If (LoadFromParcelList and
        (CertiorariTable.FieldByName('SwisSBLKey').Text <> ParcelListSwisSBLKey))
      then
        repeat
          Index := Index + 1;
          ParcelListSwisSBLKey := ParcelListDialog.GetParcelSwisSBLKey(Index);
          FindNearestOld(CertiorariTable, ['SwisSBLKey', 'TaxRollYr'],
                         [ParcelListSwisSBLKey, '']);

        until ((Index > ParcelListDialog.NumItems) or
               (CertiorariTable.FieldByName('SwisSBLKey').Text = ParcelListSwisSBLKey));

    If (CertiorariTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    CurrentSwisSBLKey := CertiorariTable.FieldByName('SwisSBLKey').Text;
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(CurrentSwisSBLKey));
    Application.ProcessMessages;

    If not Done
      then
        begin
          GetCert_Or_SmallClaimStatus(CertiorariTable, StatusThisCertiorari);

          CertiorariOpen := ((StatusThisCertiorari = csOpen) and
                             (CertiorariTable.FieldByName('CertiorariNumber').AsInteger <> 0));

          If CertiorariOpen
            then
              begin
                If (LastSwisSBLKey <> CurrentSwisSBLKey)
                  then
                    begin
                      HeaderInsertedForThisCertiorari := False;
                      OwnerName := '';
                      LegalAddress := '';
                      LegalAddressNo := '';
                      SchoolCode := '';
                      LawyerCode := '';
                      LegalAddressInt := 0;
                      PropertyClassCode := '';
                      OwnershipCode := '';
                      iCurrentValue := 0;

                    end;  {If (LastSwisSBLKey <> CurrentSwisSBLKey)}

                  {FXX02022004-5(2.07l): Make sure to use the most recent non-blank info
                                         for owner, representative, etc.}

                with CertiorariTable do
                  begin
                    If _Compare(FieldByName('LegalAddrInt').AsInteger, 0, coNotEqual)
                      then LegalAddressInt := FieldByName('LegalAddrInt').AsInteger;

                    If _Compare(FieldByName('CurrentName1').AsString, coNotBlank)
                      then OwnerName := FieldByName('CurrentName1').AsString;

                    If _Compare(FieldByName('LegalAddr').AsString, coNotBlank)
                      then LegalAddress := FieldByName('LegalAddr').AsString;

                    If _Compare(FieldByName('LegalAddrNo').AsString, coNotBlank)
                      then LegalAddressNo := FieldByName('LegalAddrNo').AsString;

                    If _Compare(FieldByName('SchoolCode').AsString, coNotBlank)
                      then SchoolCode := FieldByName('SchoolCode').AsString;

                    If _Compare(FieldByName('LawyerCode').AsString, coNotBlank)
                      then LawyerCode := FieldByName('LawyerCode').AsString;

                    try
                      If _Compare(FieldByName('PropertyClassCode').AsString, coNotBlank)
                        then PropertyClassCode := FieldByName('PropertyClassCode').AsString;

                      If _Compare(FieldByName('OwnershipCode').AsString, coNotBlank)
                        then OwnershipCode := FieldByName('OwnershipCode').AsString;
                    except
                    end;

                  end;  {with CertiorariTable do}

                If (CertiorariTable.FieldByName('TaxRollYr').Text < EarliestCertiorariYear)
                  then EarliestCertiorariYear := CertiorariTable.FieldByName('TaxRollYr').Text;

                If (CertiorariTable.FieldByName('TaxRollYr').Text > MostRecentCertiorariYear)
                  then MostRecentCertiorariYear := CertiorariTable.FieldByName('TaxRollYr').Text;

                If (LastSwisSBLKey <> CurrentSwisSBLKey)
                  then HeaderInsertedForThisCertiorari := False;

                  {FXX10152006-2(2.10.2.2): Only reset the LastSwisSBLKey if an open cert is found.}

                LastSwisSBLKey := CurrentSwisSBLKey;

                  {If we haven't inserted a header record for this parcel ID yet, do so.}

                If not HeaderInsertedForThisCertiorari
                  then
                    begin
                      HeaderInsertedForThisCertiorari := True;

                        {CHG10082006-1(2.10.2.1): Add property class \ ownership code.}
                        {CHG10082006-2(2.10.2.1): If the owner name is blank, choose the current owner.}

                      _Locate(ParcelTable,
                              [GlblNextYear, CertiorariTable.FieldByName('SwisSBLKey').AsString], '', [loParseSwisSBLKey]);

                      _Locate(tb_Assessments,
                              [GlblNextYear, CertiorariTable.FieldByName('SwisSBLKey').AsString], '', []);

                      with ParcelTable do
                        begin
                          If _Compare(OwnerName, coBlank)
                            then OwnerName := FieldByName('Name1').AsString;

                          If _Compare(PropertyClassCode, coBlank)
                            then PropertyClassCode := FieldByName('PropertyClassCode').AsString;

                          If _Compare(OwnershipCode, coBlank)
                            then OwnershipCode := FieldByName('OwnershipCode').AsString;

                          If _Compare(LegalAddressInt, 0, coEqual)
                            then LegalAddressInt := FieldByName('LegalAddrInt').AsInteger;

                          If _Compare(LegalAddress, coBlank)
                            then LegalAddress := FieldByName('LegalAddr').AsString;

                          If _Compare(LegalAddressNo, coBlank)
                            then LegalAddressNo := FieldByName('LegalAddrNo').AsString;

                          If _Compare(SchoolCode, coBlank)
                            then SchoolCode := FieldByName('SchoolCode').AsString;

                          If _Compare(iCurrentValue, 0, coEqual)
                            then iCurrentValue := tb_Assessments.FieldByName('TotalAssessedVal').AsInteger;

                        end;  {with ParcelTable do}

                        {FXX03192008-2(2.11.7.16): Add current value to the report.}

                      with SortCertiorariHeaderTable do
                        try
                          Insert;

                          FieldByName('SwisSBLKey').Text := CertiorariTable.FieldByName('SwisSBLKey').Text;
                          FieldByName('AlternateID').Text := CertiorariTable.FieldByName('AlternateID').Text;
                          FieldByName('OwnerName').Text := OwnerName;
                          FieldByName('LawyerCode').Text := LawyerCode;
                          FieldByName('LegalAddr').Text := LegalAddress;
                          FieldByName('LegalAddrNo').Text := LegalAddressNo;
                          FieldByName('LegalAddrInt').AsInteger := LegalAddressInt;
                          FieldByName('SchoolCode').Text := SchoolCode;
                          FieldByName('CurrentValue').AsInteger := iCurrentValue;

                          try
                            FieldByName('PropertyClassCode').AsString := PropertyClassCode;
                            FieldByName('OwnershipCode').AsString := OwnershipCode;
                          except
                          end;

                          try
                            FieldByName('AccountNumber').AsString := CertiorariTable.FieldByName('AccountNumber').AsString;
                          except
                          end;

                          Post;
                        except
                          SystemSupport(001, SortCertiorariHeaderTable, 'Error inserting into sort header file.',
                                        UnitName, GlblErrorDlgBox);
                        end;

                    end;  {If not HeaderInsertedForThisCertiorari}

                  {Now insert a detail record for this year.}

                with SortCertiorariDetailTable do
                  try
                    Insert;
                    FieldByName('SwisSBLKey').Text := CertiorariTable.FieldByName('SwisSBLKey').Text;
                    FieldByName('TaxRollYr').Text := CertiorariTable.FieldByName('TaxRollYr').Text;

                    try
                      FieldByName('AskingReductionValue').AsInteger := CertiorariTable.FieldByName('CurrentTotalValue').AsInteger -
                                                                       CertiorariTable.FieldByName('PetitTotalValue').AsInteger;
                    except
                    end;

                    try
                      FieldByName('AssessedValue').AsInteger := CertiorariTable.FieldByName('CurrentTotalValue').AsInteger;
                    except
                    end;

                    try
                      FieldByName('AskingValue').AsInteger := CertiorariTable.FieldByName('PetitTotalValue').AsInteger;
                    except
                    end;

                    Post;
                  except
                    SystemSupport(002, SortCertiorariDetailTable, 'Error inserting into sort detail file.',
                                  UnitName, GlblErrorDlgBox);
                  end;

              end;  {If CertiorariOpen}

        end;  {If not Done}

  until Done;

end;  {FillSortFile}

{================================================================================}
Procedure TCertiorariHistoryReportForm.PrintButtonClick(Sender: TObject);

var
  SortHeaderFileName,
  SortDetailFileName,
  SpreadsheetFileName,
  NewFileName : String;
  Quit : Boolean;
  I, J : Integer;

begin
  ReportCancelled := False;
  Quit := False;
  slSpecialDistrictCodes := TStringList.Create;

  UseAlternateID := UseAlternateIDCheckBox.Checked;
  BlankRepresentativeIsProSe := BlankRepresentativeIsProSeCheckBox.Checked;
  PrintToExcel := PrintToExcelCheckBox.Checked;
  LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
  bExtractSpecialDistricts := cbExtractSpecialDistricts.Checked;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        ProgressDialog.UserLabelCaption := 'Creating Sort File';

        SortCertiorariHeaderTable.Close;
        SortCertiorariHeaderTable.TableName := OrigSortHeaderFileName;

        SortHeaderFileName := GetSortFileName('CertHistoryHeader');

        SortCertiorariHeaderTable.IndexName := '';
        CopySortFile(SortCertiorariHeaderTable, SortHeaderFileName);
        SortCertiorariHeaderTable.Close;
        SortCertiorariHeaderTable.TableName := SortHeaderFileName;
        SortCertiorariHeaderTable.Exclusive := True;

        try
          SortCertiorariHeaderTable.Open;
        except
          Quit := True;
          SystemSupport(060, SortCertiorariHeaderTable, 'Error opening sort header table.',
                        UnitName, GlblErrorDlgBox);
        end;

        SortCertiorariDetailTable.Close;
        SortCertiorariDetailTable.TableName := OrigSortDetailFileName;

        SortDetailFileName := GetSortFileName('CertHistoryDetail');

        SortCertiorariDetailTable.IndexName := '';
        CopySortFile(SortCertiorariDetailTable, SortDetailFileName);
        SortCertiorariDetailTable.Close;
        SortCertiorariDetailTable.TableName := SortDetailFileName;
        SortCertiorariDetailTable.Exclusive := True;

        try
          SortCertiorariDetailTable.Open;
          SortCertiorariDetailTable.IndexName := 'BYYEAR_SWISSBLKEY';
        except
          Quit := True;
          SystemSupport(060, SortCertiorariDetailTable, 'Error opening sort Detail table.',
                        UnitName, GlblErrorDlgBox);
        end;

        SelectedSwisCodes := TStringList.Create;
        SelectedSchoolCodes := TStringList.Create;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

        FillSortTable(Quit);

        PrintOrder := PrintOrderRadioGroupBox.ItemIndex;

          {FXX10122004-1(2.8.0.14): The IndexName was being set on the wrong table.}

        with SortCertiorariHeaderTable do
          case PrintOrder of
            poParcelID : IndexName := 'BYSWISSBLKEY';
            poOwnerName : IndexName := 'BYNAME';
            poLegalAddress : IndexName := 'BYLEGALADDR_ADDRNO';
            poRepresentative : IndexName := 'BYREPRESENTATIVE';

          end;  {case PrintOrder of}

        CreateParcelList := CreateParcelListCheckBox.Checked;
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

          {CHG10022003-1(2.07j): Add ability to extract (only) current and asking value.}

        ExtractCurrentAndAskingValue := ExtractCurrentAndAskingValueCheckBox.Checked;

        If PrintToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

                {If we are also extracting the current and asking value,
                 then include the years on a first Excel line.}
                {CHG10022003-1(2.07j): Add ability to extract (only) current and asking value.}

              If ExtractCurrentAndAskingValue
                then
                  begin
                    Write(ExtractFile, ',,,,,,,');

                    For I := StrToInt(EarliestCertiorariYear) to StrToInt(MostRecentCertiorariYear) do
                      For J := 1 to 3 do
                        Write(ExtractFile, IntToStr(I) + ',');

                    Writeln(ExtractFile);

                  end;  {If ExtractCurrentAndAskingValue}

                {FXX09252011-1(MDT): There was an extra column in the header.}

              Write(ExtractFile, 'Name,',
                                 'Legal Address,');

              If (SortCertiorariHeaderTable.FindField('AccountNumber') <> nil)
              then Write(ExtractFile, 'Account #,');

              Write(ExtractFile, 'Representative,',
                                 'Parcel ID,',
                                 'Prop Class,',
                                 'Current AV,');

              For I := StrToInt(EarliestCertiorariYear) to StrToInt(MostRecentCertiorariYear) do
                If ExtractCurrentAndAskingValue
                  then Write(ExtractFile, 'Actual Assessed Value,',
                                          'Asking Value,',
                                          'Max Reduction,')
                  else Write(ExtractFile, IntToStr(I) + ',');

                {CHG07202010-2(2.27.1)[I7123]: Add option to extract special districts.}

              If bExtractSpecialDistricts
              then
              begin
                FillStringListFromFile(slSpecialDistrictCodes,
                                       tbSpecialDistrictCodes,
                                       'SDistCode', '', 0, False,
                                       NextYear, GlblNextYear);

                For I := 0 to (slSpecialDistrictCodes.Count - 1) do
                  Write(ExtractFile, slSpecialDistrictCodes[I] + ',');

              end;  {If bExtractSpecialDistricts}

              Writeln(ExtractFile);

            end;  {If PrintToExcel}

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                              True, Quit);

          {FXX02022004-3: Use legal paper.}

        ReportPrinter.SetPaperSize(dmPaper_Legal, 0, 0);
        ReportFiler.SetPaperSize(dmPaper_Legal, 0, 0);

        If not Quit
          then
            begin
              ProgressDialog.UserLabelCaption := '';

                {Now print the report.}

              If not (Quit or ReportCancelled)
                then
                  begin
                    GlblPreviewPrint := False;

                      {If they want to see it on the screen, start the preview.}

                    If PrintDialog.PrintToFile
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

                              {FXX09071999-6: Tell people that printing is starting and
                                              done.}

                            ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                            PreviewForm.ShowModal;
                          finally
                            PreviewForm.Free;
                          end;

                          ShowReportDialog('Certiorari Summary Report.RPT', NewFileName, True);

                        end
                      else ReportPrinter.Execute;

                  end;  {If not Quit}

                {Clear the selections.}

              ProgressDialog.Finish;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);


              If CreateParcelList
                then ParcelListDialog.Show;

              If PrintToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

              SelectedSwisCodes.Free;
              SelectedSchoolCodes.Free;

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

  slSpecialDistrictCodes.Free;

end;  {PrintButtonClick}

{====================================================================}
Function FoundTotalsRecord(    TotalsList : TList;
                               _Year : String;
                           var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Result := False;
  Index := -1;

  For I := 0 to (TotalsList.Count - 1) do
    with TotalsPointer(TotalsList[I])^ do
      If (Year = _Year)
        then
          begin
            Result := True;
            Index := I;
          end;

end;  {FoundTotalsRecord}

{====================================================================}
Procedure UpdateTotals(TotalsList : TList;
                       _Year : String;
                       _AskingReductionValue,
                       _AssessedValue,
                       _AskingValue : LongInt);

var
  Index : Integer;
  TotalsPtr : TotalsPointer;

begin
  If not FoundTotalsRecord(TotalsList, _Year, Index)
    then
      begin
        New(TotalsPtr);
        TotalsPtr^.Year := _Year;
        TotalsPtr^.TotalAskingReductionValue := 0;
        TotalsPtr^.TotalAskingValue := 0;
        TotalsPtr^.TotalAssessedValue := 0;
        TotalsList.Add(TotalsPtr);

      end;  {If not FoundTotalsRecord(TotalsList, _Year, Index)}

  FoundTotalsRecord(TotalsList, _Year, Index);

  with TotalsPointer(TotalsList[Index])^ do
    begin
      TotalAskingReductionValue := TotalAskingReductionValue + _AskingReductionValue;
      TotalAskingValue := TotalAskingValue + _AskingValue;
      TotalAssessedValue := TotalAssessedValue + _AssessedValue;

    end;  {with TotalsPointer(TotalsList[Index])^ do}

end;  {UpdateTotals}

{====================================================================}
Function RecordInRange(CertiorariHeaderTable : TTable;
                       SelectedSwisCodes : TStringList;
                       SelectedSchoolCodes : TStringList) : Boolean;

begin
  Result := True;

    {In the selected swis list?}

  If (SelectedSwisCodes.IndexOf(Copy(CertiorariHeaderTable.FieldByName('SwisSBLKey').Text, 1, 6)) = -1)
    then Result := False;

    {In the selected school list?}
    {FXX02012004-2(2.07l): If the school code is blank, ignore the school code criteria.}

  try
    If ((Deblank(CertiorariHeaderTable.FieldByName('SchoolCode').Text) <> '') and
        (SelectedSchoolCodes.IndexOf(CertiorariHeaderTable.FieldByName('SchoolCode').Text) = -1))
      then Result := False;
  except
  end;

end;  {RecordInRange}

{====================================================================}
Procedure TCertiorariHistoryReportForm.ReportPrintHeader(Sender: TObject);

var
  CurrentTabPos : Double;
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);

        {Print the date and page number.}
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;

      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '    ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman',12);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Certiorari Exposure Report', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman', 8);
      ClearTabs;
      SetTab(0.3, pjCenter, 1.6, 5, BoxLineAll, 0);   {Name}
      SetTab(1.9, pjCenter, 1.6, 5, BoxLineAll, 0);   {Legal address}
      SetTab(3.5, pjCenter, 0.9, 5, BoxLineAll, 0);   {Lawyer}
      SetTab(4.4, pjCenter, 0.3, 5, BoxLineAll, 0);   {C/C}
      SetTab(4.7, pjCenter, 0.9, 5, BoxLineAll, 0);   {Parcel ID}
      SetTab(5.6, pjCenter, 0.4, 5, BoxLineAll, 0);   {Property Class}

      Bold := True;
      CurrentTabPos := 6.0;

        {FXX02022004-4(2.07l): Reduce the size of the columns in order to fit more years (from 0.8 to 0.6)}

      For I := StrToInt(EarliestCertiorariYear) to StrToInt(MostRecentCertiorariYear) do
        begin
          SetTab(CurrentTabPos, pjCenter, 0.6, 5, BoxLineAll, 0);
          CurrentTabPos := CurrentTabPos + 0.6;
        end;

      Print(#9 + 'Name' +
            #9 + 'Legal Address' +
            #9 + 'Represented' +
            #9 + 'C/C' +
            #9 + 'Parcel ID' +
            #9 + 'Class');

      For I := StrToInt(EarliestCertiorariYear) to StrToInt(MostRecentCertiorariYear) do
        Print(#9 + IntToStr(I));

      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.6, 5, BoxLineAll, 0);   {Name}
      SetTab(1.9, pjLeft, 1.6, 5, BoxLineAll, 0);   {Legal address}
      SetTab(3.5, pjLeft, 0.9, 5, BoxLineAll, 0);   {Lawyer}
      SetTab(4.4, pjLeft, 0.3, 5, BoxLineAll, 0);   {C/C}
      SetTab(4.7, pjLeft, 0.9, 5, BoxLineAll, 0);   {Parcel ID}
      SetTab(5.6, pjLeft, 0.4, 5, BoxLineAll, 0);   {Property Class}

      CurrentTabPos := 6.0;

        {FXX02022004-4(2.07l): Reduce the size of the columns in order to fit more years (from 0.8 to 0.6)}

      For I := StrToInt(EarliestCertiorariYear) to StrToInt(MostRecentCertiorariYear) do
        begin
          SetTab(CurrentTabPos, pjRight, 0.6, 5, BoxLineAll, 0);
          CurrentTabPos := CurrentTabPos + 0.6;
        end;

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {TextFilerPrintHeader}

{====================================================================}
Procedure TCertiorariHistoryReportForm.ReportPrint(Sender: TObject);

var
  _Found, Done, FirstTimeThrough : Boolean;
  ParcelID, Representative, SwisSBLKey,
  TempAssessedValue, TempAskingValue,
  TempAskingReductionValue, TempTotalAskingReductionValue,
  TempTotalAssessedValue, TempTotalAskingValue : String;
  I, J, Index : Integer;
  TotalsList : TList;
  GrandTotalAskingReductionValue : LongInt;

begin
  Done := False;
  FirstTimeThrough := True;
  TotalsList := TList.Create;
  GrandTotalAskingReductionValue := 0;

  SortCertiorariHeaderTable.First;
  ProgressDialog.Start(GetRecordCount(CertiorariTable), True, True);

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortCertiorariHeaderTable.Next;

        If SortCertiorariHeaderTable.EOF
          then Done := True;

        Application.ProcessMessages;
        SwisSBLKey := SortCertiorariHeaderTable.FieldByName('SwisSBLKey').Text;
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));

        If ((not Done) and
            RecordInRange(SortCertiorariHeaderTable, SelectedSwisCodes, SelectedSchoolCodes))
          then
            begin
              If UseAlternateID
                then ParcelID := SortCertiorariHeaderTable.FieldByName('AlternateID').Text
                else ParcelID := Take(20, ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)));

              Representative := SortCertiorariHeaderTable.FieldByName('LawyerCode').Text;

              If (BlankRepresentativeIsProSe and
                  (Deblank(Representative) = ''))
                then Representative := 'PRO SE';

              Print(#9 + Take(20, SortCertiorariHeaderTable.FieldByName('OwnerName').Text) +
                    #9 + Trim(GetLegalAddressFromTable(SortCertiorariHeaderTable)) +
                    #9 + Representative +
                    #9 +
                    #9 + ParcelID +
                    #9 + GetPropertyClass_OwnershipCode(SortCertiorariHeaderTable));

              If PrintToExcel
                then
                  begin
                    WriteCommaDelimitedLine(ExtractFile,
                                            [SortCertiorariHeaderTable.FieldByName('OwnerName').Text,
                                             GetLegalAddressFromTable(SortCertiorariHeaderTable)]);

                    try
                      WriteCommaDelimitedLine(ExtractFile,
                                              [SortCertiorariHeaderTable.FieldByName('AccountNumber').AsString]);
                    except
                    end;

                    WriteCommaDelimitedLine(ExtractFile,
                                            [Representative,
                                             ParcelID,
                                             GetPropertyClass_OwnershipCode(SortCertiorariHeaderTable),
                                             SortCertiorariHeaderTable.FieldByName('CurrentValue').AsString]);

                  end;  {If PrintToExcel}

              For I := StrToInt(EarliestCertiorariYear) to StrToInt(MostRecentCertiorariYear) do
                begin
                  _Found := FindKeyOld(SortCertiorariDetailTable, ['SwisSBLKey', 'TaxRollYr'],
                                       [SwisSBLKey, IntToStr(I)]);

                  If _Found
                    then
                      begin
                        TempAskingReductionValue := FormatFloat(NoDecimalDisplay_BlankZero,
                                                                SortCertiorariDetailTable.FieldByName('AskingReductionValue').AsFloat);

                        TempAskingValue := FormatFloat(NoDecimalDisplay_BlankZero,
                                                       SortCertiorariDetailTable.FieldByName('AskingValue').AsFloat);

                        TempAssessedValue := FormatFloat(NoDecimalDisplay_BlankZero,
                                                         SortCertiorariDetailTable.FieldByName('AssessedValue').AsFloat);

                        UpdateTotals(TotalsList, IntToStr(I),
                                     SortCertiorariDetailTable.FieldByName('AskingReductionValue').AsInteger,
                                     SortCertiorariDetailTable.FieldByName('AssessedValue').AsInteger,
                                     SortCertiorariDetailTable.FieldByName('AskingValue').AsInteger);

                        GrandTotalAskingReductionValue := GrandTotalAskingReductionValue +
                                                          SortCertiorariDetailTable.FieldByName('AskingReductionValue').AsInteger;
                      end
                    else
                      begin
                        TempAskingReductionValue := '';
                        TempAskingValue := '';
                        TempAssessedValue := '';

                      end;  {else of For I := StrToInt(EarliestCertiorariYear) to StrToInt(MostRecentCertiorariYear) do}

                  Print(#9 + TempAskingReductionValue);

                    {CHG10022003-1(2.07j): Add ability to extract (only) current and asking value.}

                  If PrintToExcel
                    then
                      begin
                        If ExtractCurrentAndAskingValue
                          then WriteCommaDelimitedLine(ExtractFile,
                                                       [TempAssessedValue,
                                                        TempAskingValue]);

                        WriteCommaDelimitedLine(ExtractFile,
                                                [TempAskingReductionValue]);

                      end;  {If PrintToExcel}

                end;  {For I := StrToInt(EarliestCertiorariYear) ...}

                {CHG07202010-2(2.27.1)[I7123]: Add option to extract special districts.}

              If (PrintToExcel and
                  bExtractSpecialDistricts)
              then
              begin
                For J := 0 to (slSpecialDistrictCodes.Count - 1) do
                  If _Locate(tbParcelSpecialDistricts,
                             [GlblNextYear, SwisSBLKey, slSpecialDistrictCodes[J]], '', [])
                  then WriteCommaDelimitedLine(ExtractFile, ['X'])
                  else WriteCommaDelimitedLine(ExtractFile, ['']);

              end;  {If bExtractSpecialDistricts}

              Println('');
              WritelnCommaDelimitedLine(ExtractFile, []);

              If (CreateParcelList and
                  (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                then ParcelListDialog.AddOneParcel(SwisSBLKey);

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 5)
                then NewPage;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or ReportCancelled);

      Print(#9 + #9 + #9 + #9 +
            #9 + #9);

      For I := StrToInt(EarliestCertiorariYear) to StrToInt(MostRecentCertiorariYear) do
        Print(#9);

      Println('');

        {Print the totals.}

      Bold := True;
      Print(#9 + 'Totals' +
            #9 + #9 + #9 + #9);

        {FXX03192008-3(2.11.7.16): The totals were not lining up.}

      If PrintToExcel
        then
          begin
            Writeln(ExtractFile);
            Write(ExtractFile, 'Totals,',
                               ',,,,,');

          end;  {If PrintToExcel}

      For I := StrToInt(EarliestCertiorariYear) to StrToInt(MostRecentCertiorariYear) do
        begin
          If FoundTotalsRecord(TotalsList, IntToStr(I), Index)
            then
              begin
                TempTotalAskingReductionValue := FormatFloat(NoDecimalDisplay_BlankZero,
                                                             TotalsPointer(TotalsList[Index])^.TotalAskingReductionValue);
                TempTotalAssessedValue := FormatFloat(NoDecimalDisplay_BlankZero,
                                                      TotalsPointer(TotalsList[Index])^.TotalAssessedValue);
                TempTotalAskingValue := FormatFloat(NoDecimalDisplay_BlankZero,
                                                    TotalsPointer(TotalsList[Index])^.TotalAskingValue);
              end
            else
              begin
                TempTotalAskingReductionValue := '';
                TempTotalAssessedValue := '';
                TempTotalAskingValue := '';

              end;  {If FoundTotalsRecord(TotalsList, IntToStr(I), Index)}

            {CHG10022003-1(2.07j): Add ability to extract (only) current and asking value.}

          If PrintToExcel
            then
              begin
                If ExtractCurrentAndAskingValue
                  then Write(ExtractFile, FormatExtractField(TempTotalAssessedValue),
                                          FormatExtractField(TempTotalAskingValue));

                Write(ExtractFile, FormatExtractField(TempTotalAskingReductionValue));

              end  {If PrintToExcel}
            else Print(#9 + TempTotalAskingReductionValue);

        end;  {For I := StrToInt(EarliestCertiorariYear) ...}

      If PrintToExcel
        then
          begin
            Writeln(ExtractFile);
            WriteCommaDelimitedLine(ExtractFile,
                                    ['Grand Total Reduction',
                                     FormatFloat(NoDecimalDisplay_BlankZero,
                                                 GrandTotalAskingReductionValue)]);
          end;

      Println('');

        {CHG06102009-2(2.20.1.1)[F881]: Add a total reduction value to the Excel extract.}

      Print(#9 + 'Grand Total' +
            #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                             GrandTotalAskingReductionValue) +
            #9 + #9 + #9);

      For I := StrToInt(EarliestCertiorariYear) to StrToInt(MostRecentCertiorariYear) do
        Print(#9);

      Println('');

    end;  {with Sender as TBaseReport do}

  FreeTList(TotalsList, SizeOf(TotalsRecord));

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TCertiorariHistoryReportForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TCertiorariHistoryReportForm.FormClose(    Sender: TObject;
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