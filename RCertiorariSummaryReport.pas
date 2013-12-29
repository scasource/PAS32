unit RCertiorariSummaryReport;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls;

type
  TCertiorariSummaryReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    CertiorariTable: TwwTable;
    PrintButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    CertiorariExemptionsAskedTable: TwwTable;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    CertiorariTypeRadioGroup: TRadioGroup;
    PrintOrderRadioGroupBox: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    CreateParcelListCheckBox: TCheckBox;
    IncludeResultsCheckBox: TCheckBox;
    CertiorariYearEdit: TEdit;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    RepresentativeCodeListBox: TListBox;
    RepresentativeCodesTable: TTable;
    UseAlternateIDCheckBox: TCheckBox;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    Label4: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    SwisCodeTable: TTable;
    SchoolCodeTable: TTable;
    CombineCondosCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    tbAssessmentYearControl: TTable;
    tbParcels: TTable;
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

    IncludeResults,
    UseAlternateID,
    CombineCondos,
    CreateParcelList, ExtractToExcel : Boolean;
    SelectedRepresentativeCodes : TStringList;

    CertiorariYear, SpecificCertiorariYear, sParcelLocateYear : String;
    PrintOrder, CertiorariProcessingType, CertiorariStatusType : Integer;

    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;  {What swis codes did they select?}
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Function MeetsCertiorariStatusCriteria(    SwisSBLKey : String;
                                               SchoolCode : String;
                                               SpecificCertiorariYear : String;
                                           var StatusThisCertiorari : Integer) : Boolean;

  end;

implementation
Uses Utilitys,  {General utilitys}
     PASUTILS, {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     Prog,
     RptDialg,
     GrievanceUtilitys,
     DataAccessUnit,
     PRCLLIST,
     Preview;

{$R *.DFM}

const
  poCertiorariNumber = 0;
  poParcelID = 1;
  poOwnerName = 2;
  poLegalAddress = 3;

  cstOpen = 0;
  cstClosed = 1;
  cstApproved = 2;
  cstDenied = 3;
  cstDismissed = 4;
  cstWithdrawn = 5;
  cstAll = 6;

{========================================================}
Procedure TCertiorariSummaryReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TCertiorariSummaryReportForm.InitializeForm;

begin
  UnitName := 'RCertiorariSummaryReport';  {mmm}

    {FXX10062002-1: In Westchester, the certs are on This Year.}

(*  If GlblIsWestchesterCounty
    then
      begin
        CertiorariYear := GlblNextYear;
        CertiorariProcessingType := NextYear;
      end
    else
      begin*)
        CertiorariYear := GlblThisYear;
        CertiorariProcessingType := ThisYear;
(*      end;*)

  sParcelLocateYear := CertiorariYear;

  OpenTablesForForm(Self, CertiorariProcessingType);

(*  CertiorariYearEdit.Text := CertiorariYear;*)

  FillOneListBox(RepresentativeCodeListBox, RepresentativeCodesTable,
                 'Code', 'Name1', 20, True, True,
                 CertiorariProcessingType, CertiorariYear);

    {CHG12242002-1: Add swis and school selection to notes report.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType,
                 GetTaxRlYr);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, GlblProcessingType,
                 GetTaxRlYr);

  SelectItemsInListBox(SwisCodeListBox);
  SelectItemsInListBox(SchoolCodeListBox);

    {CHG02012004-1(2.07l1): Allow for the alternate ID to default to on or off.}

  UseAlternateIDCheckBox.Checked := GlblCertiorariReportsUseAlternateID;

end;  {InitializeForm}

{===================================================================}
Procedure TCertiorariSummaryReportForm.FormKeyPress(    Sender: TObject;
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
Procedure TCertiorariSummaryReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Certiorari Summary.grs', 'Certiorari Summary Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TCertiorariSummaryReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Certiorari Summary.grs', 'Certiorari Summary Report');

end;  {LoadButtonClick}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TCertiorariSummaryReportForm.PrintButtonClick(Sender: TObject);

var
  NewFileName, TempStr, SpreadsheetFileName : String;
  Quit, WideCarriage : Boolean;
  I, TempPos : Integer;

begin
  ReportCancelled := False;
  Quit := False;

  SelectedRepresentativeCodes := TStringList.Create;
  UseAlternateID := UseAlternateIDCheckBox.Checked;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        PrintOrder := PrintOrderRadioGroupBox.ItemIndex;

        case PrintOrder of
          poCertiorariNumber : CertiorariTable.IndexName := 'BYCERTNUM';
          poParcelID : CertiorariTable.IndexName := 'BYSWISSBLKEY';
          poOwnerName : CertiorariTable.IndexName := 'BYOWNERNAME';
          poLegalAddress : CertiorariTable.IndexName := 'BYLEGALADDR_LEGALADDRINT';

        end;  {case PrintOrder of}

          {CHG12242002-1: Add swis and school selection.}

        SelectedSwisCodes := TStringList.Create;
        SelectedSchoolCodes := TStringList.Create;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

          {CHG05162000-1: Add school codes option.}

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

        CreateParcelList := CreateParcelListCheckBox.Checked;
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

        IncludeResults := IncludeResultsCheckBox.Checked;

        CertiorariStatusType := CertiorariTypeRadioGroup.ItemIndex;

        SpecificCertiorariYear := CertiorariYearEdit.Text;
        ExtractToExcel := ExtractToExcelCheckBox.Checked;

        For I := 0 to (RepresentativeCodeListBox.Items.Count - 1) do
          If RepresentativeCodeListBox.Selected[I]
            then
              begin
                TempStr := RepresentativeCodeListBox.Items[I];
                TempPos := Pos('-', TempStr);

                SelectedRepresentativeCodes.Add(Take((TempPos - 2), TempStr));

              end;  {If RepresentativeCodeListBox.Selected[I])}

        WideCarriage := IncludeResults;

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                              WideCarriage, Quit);

        If not Quit
          then
            begin
              If ExtractToExcel
                then
                  begin
                    SpreadsheetFileName := GetPrintFileName('SL', True);
                    AssignFile(ExtractFile, SpreadsheetFileName);
                    Rewrite(ExtractFile);
                    GlblCurrentCommaDelimitedField := 0;

                    WriteCommaDelimitedLine(ExtractFile,
                                              ['Year',
                                               'Index #',
                                               'Parcel ID',
                                               'Owner',
                                               'Legal Address',
                                               'Representative',
                                               'Petit Name 1',
                                               'Petit Name 2',
                                               'Petit Address 1',
                                               'Petit Address 2',
                                               'Petit Address 3',
                                               'Petit Address 4',
                                               'Tentative Value',
                                               'Asking Value',
                                               'Account #',
                                               'Old Print Key',
                                               'Additional Lots']);

                    If IncludeResults
                    then WritelnCommaDelimitedLine(ExtractFile,
                                                 ['Disposition Date',
                                                  'Disposition',
                                                  'Granted Amount',
                                                  'Reduction Amount'])
                    else WritelnCommaDelimitedLine(ExtractFile, []);

                  end;  {If ExtractToExcel}

              ProgressDialog.UserLabelCaption := '';
              ProgressDialog.Start(GetRecordCount(CertiorariTable), True, True);

                {Now print the report.}

              If not (Quit or ReportCancelled)
                then
                  begin
                    GlblPreviewPrint := False;

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

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

              If CreateParcelList
                then ParcelListDialog.Show;

                {CHG01252005-1(2.8.3.1): Extract the Certiorari summary report to Excel.}

              If ExtractToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

  SelectedRepresentativeCodes.Free;

end;  {PrintButtonClick}

{====================================================================}
Function TCertiorariSummaryReportForm.MeetsCertiorariStatusCriteria(    SwisSBLKey : String;
                                                                        SchoolCode : String;
                                                                        SpecificCertiorariYear : String;
                                                                    var StatusThisCertiorari : Integer) : Boolean;

begin
  Result := True;

  If ((Deblank(SpecificCertiorariYear) <> '') and
      (CertiorariTable.FieldByName('TaxRollYr').Text <> SpecificCertiorariYear))
    then Result := False;

  If Result
    then
      begin
        GetCert_Or_SmallClaimStatus(CertiorariTable, StatusThisCertiorari);

        case CertiorariStatusType of
          cstOpen : Result := ((StatusThisCertiorari = csOpen) and
                               (CertiorariTable.FieldByName('CertiorariNumber').AsInteger <> 0));

          cstClosed : Result := (StatusThisCertiorari in [csApproved,
                                                          csDenied,
                                                          csDiscontinued,
                                                          csWithdrawn,
                                                          csDismissed]);

          cstApproved : Result := (StatusThisCertiorari = csApproved);

          cstDenied : Result := (StatusThisCertiorari = csDiscontinued);

          cstWithdrawn : Result := (StatusThisCertiorari = csWithdrawn);

          cstDismissed : Result := (StatusThisCertiorari = csDismissed);

        end;  {case StatusThisCertiorari of}

      end;  {If Result}

          {Check the representative.}

  If Result
    then Result := ((SelectedRepresentativeCodes.Count =
                     RepresentativeCodeListBox.Items.Count) or  {All items selected}
                    (SelectedRepresentativeCodes.IndexOf(CertiorariTable.FieldByName('LawyerCode').Text) > -1));

    {CHG12242002-1: Allow for selection of swis and school codes.}

  If (Result and
      (SelectedSwisCodes.IndexOf(Copy(SwisSBLKey, 1, 6)) = -1))
    then Result := False;

  If (Result and
      (Deblank(SchoolCode) <> '') and
      (SelectedSchoolCodes.IndexOf(SchoolCode) = -1))
    then Result := False;

(*      end;  {If (CertiorariStatusType = gsAll)}*)

end;  {MeetsCertiorariStatusCriteria}

{====================================================================}
Procedure TCertiorariSummaryReportForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);
      SectionTop := 0.25;

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
      PrintCenter('Certiorari List', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',10);
      ClearTabs;

      If IncludeResults
        then
          begin
            SetTab(6.2, pjCenter, 0.8, 0, BoxLineNone, 0);  {Tenative amount}
            SetTab(7.1, pjCenter, 0.8, 0, BoxLineNone, 0);  {Petitioner value}
            SetTab(8.0, pjCenter, 0.8, 0, BoxLineNone, 0);   {Decision date (Stipulation or BOAR)}
            SetTab(8.9, pjCenter, 1.0, 0, BoxLineNone, 0);   {Decision code}
            SetTab(10.0, pjCenter, 0.8, 0, BoxLineNone, 0);   {Granted total value}
            SetTab(10.9, pjCenter, 0.7, 0, BoxLineNone, 0);  {Reduction}
            SetTab(11.7, pjCenter, 1.0, 0, BoxLineNone, 0);  {Granted exemption information}

            Println(#9 + 'Tentative' +
                    #9 + 'Petitioner' +
                    #9 + 'Decision' +
                    #9 + 'Decision' +
                    #9 + 'Granted' +
                    #9 + 'Reduction' +
                    #9 + 'Granted');

            ClearTabs;
            SetTab(0.3, pjCenter, 0.9, 0, BoxLineBottom, 0);  {Index #}
            SetTab(1.3, pjCenter, 1.0, 0, BoxLineBottom, 0);  {Lawyer}
            SetTab(2.4, pjCenter, 1.5, 0, BoxLineBottom, 0);  {Owner name}
            SetTab(4.0, pjCenter, 1.1, 0, BoxLineBottom, 0);  {Parcel ID}
            SetTab(5.1, pjCenter, 1.1, 0, BoxLineBottom, 0);  {Legal address}
            SetTab(6.2, pjCenter, 0.8, 0, BoxLineBottom, 0);  {Tenative amount}
            SetTab(7.1, pjCenter, 0.8, 0, BoxLineBottom, 0);  {Petitioner value}

            SetTab(8.0, pjCenter, 0.8, 0, BoxLineBottom, 0);   {Decision date (Stipulation or BOAR)}
            SetTab(8.9, pjCenter, 1.0, 0, BoxLineBottom, 0);   {Decision code}
            SetTab(10.0, pjCenter, 0.8, 0, BoxLineBottom, 0);   {Granted total value}
            SetTab(10.9, pjCenter, 0.7, 0, BoxLineBottom, 0);  {Reduction}
            SetTab(11.7, pjCenter, 1.0, 0, BoxLineBottom, 0);  {Granted exemption information}

            Println(#9 + 'Index #' +
                    #9 + 'Rep' +
                    #9 + 'Owner Name' +
                    #9 + 'Parcel ID' +
                    #9 + 'Legal Address' +
                    #9 + 'Amount' +
                    #9 + 'Amount' +
                    #9 + 'Date' +
                    #9 + 'Code' +
                    #9 + 'Amount' +
                    #9 + 'Amount' +
                    #9 + 'Exemption');

            ClearTabs;

            SetTab(0.3, pjLeft, 0.9, 0, BoxLineNone, 0);   {Index #}
            SetTab(1.3, pjLeft, 1.0, 0, BoxLineNone, 0);   {Lawyer}
            SetTab(2.4, pjLeft, 1.5, 0, BoxLineNone, 0);   {Owner name}
            SetTab(4.0, pjLeft, 1.1, 0, BoxLineNone, 0);   {Parcel ID}
            SetTab(5.1, pjLeft, 1.1, 0, BoxLineNone, 0);   {Legal address}

            SetTab(6.2, pjRight, 0.8, 0, BoxLineNone, 0);  {Tenative amount}
            SetTab(7.1, pjRight, 0.8, 0, BoxLineNone, 0);  {Petitioner value}

            SetTab(8.0, pjLeft, 0.8, 0, BoxLineNone, 0);   {Decision date (Stipulation or BOAR)}
            SetTab(8.9, pjLeft, 1.0, 0, BoxLineNone, 0);   {Decision code}
            SetTab(10.0, pjRight, 0.8, 0, BoxLineNone, 0);   {Granted total value}
            SetTab(10.9, pjRight, 0.7, 0, BoxLineNone, 0);  {Reduction}
            SetTab(11.7, pjLeft, 1.0, 0, BoxLineNone, 0);   {Granted exemption information}

          end
        else
          begin
            SetTab(8.9, pjCenter, 1.1, 0, BoxLineNone, 0);   {Tentative Amount}
            SetTab(9.9, pjCenter, 1.1, 0, BoxLineNone, 0);   {Amount}

            Println(#9 + 'Tentative' +
                    #9 + 'Petitioner');

            ClearTabs;

            SetTab(0.3, pjCenter, 0.9, 0, BoxLineBottom, 0);   {Year}
            SetTab(1.3, pjCenter, 0.6, 0, BoxLineBottom, 0);   {Index #}
            SetTab(1.8, pjCenter, 1.4, 0, BoxLineBottom, 0);   {Parcel ID}
            SetTab(3.5, pjCenter, 2.0, 0, BoxLineBottom, 0);   {Owner name}
            SetTab(5.6, pjCenter, 1.8, 0, BoxLineBottom, 0);   {Legal address}
            SetTab(7.5, pjCenter, 1.1, 0, BoxLineBottom, 0);   {Representative}
            SetTab(8.7, pjCenter, 1.1, 0, BoxLineBottom, 0);   {Tentative Amount}
            SetTab(9.9, pjCenter, 1.1, 0, BoxLineBottom, 0);   {Amount}

            Println(#9 + 'Year' +
                     #9 + 'Index #' +
                     #9 + 'Parcel ID' +
                     #9 + 'Owner Name' +
                     #9 + 'Legal Address' +
                     #9 + 'Representative' +
                     #9 + 'Amount' +
                     #9 + 'Amount');

            ClearTabs;

            SetTab(0.3, pjLeft, 0.9, 0, BoxLineNone, 0);   {Year}
            SetTab(1.3, pjLeft, 0.6, 0, BoxLineNone, 0);   {Index #}
            SetTab(2.0, pjLeft, 1.4, 0, BoxLineNone, 0);   {Parcel ID}
            SetTab(3.5, pjLeft, 2.0, 0, BoxLineNone, 0);   {Owner name}
            SetTab(5.6, pjLeft, 1.8, 0, BoxLineNone, 0);   {Legal address}
            SetTab(7.5, pjLeft, 1.1, 0, BoxLineNone, 0);   {Representative}
            SetTab(8.7, pjRight, 1.1, 0, BoxLineNone, 0);   {Tentative Amount}
            SetTab(9.9, pjRight, 1.1, 0, BoxLineNone, 0);   {Amount}

          end;  {else of If IncludeResults}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {TextFilerPrintHeader}

{====================================================================}
Procedure TCertiorariSummaryReportForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit : Boolean;
  SwisSBLKey, ParcelID : String;
  NumFound, StatusThisCertiorari : Integer;
  iReduction, iTotalReduction : LongInt;
  TotalsRec : GrievanceTotalsRecord;
  NAddrArray : NameAddrArray;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  NumFound := 0;
  iTotalReduction := 0;
  InitGrievanceTotalsRecord(TotalsRec);

  CertiorariTable.First;

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else CertiorariTable.Next;

        If CertiorariTable.EOF
          then Done := True;

        Application.ProcessMessages;
        SwisSBLKey := CertiorariTable.FieldByName('SwisSBLKey').Text;
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));

        If ((not Done) and
            MeetsCertiorariStatusCriteria(SwisSBLKey,
                                          CertiorariTable.FieldByName('SchoolCode').Text,
                                          SpecificCertiorariYear,
                                          StatusThisCertiorari))
          then
            begin
              NumFound := NumFound + 1;
              ProgressDialog.UserLabelCaption := 'Found = ' + IntToStr(NumFound);
              UpdateSmallClaims_Certiorari_TotalsRecord(TotalsRec, StatusThisCertiorari);

              If (UseAlternateID and
                  _Compare(CertiorariTable.FieldByName('AlternateID').Text, coNotBlank))
                then ParcelID := CertiorariTable.FieldByName('AlternateID').Text
                else ParcelID := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

              with CertiorariTable do
                begin
                  If _Compare(FieldByName('GrantedTotalValue').AsInteger, 0, coGreaterThan)
                    then iReduction := FieldByName('CurrentTotalValue').AsInteger -
                                       FieldByName('GrantedTotalValue').AsInteger
                    else iReduction := 0;

                  iTotalReduction := iTotalReduction + iReduction;

                  If IncludeResults
                    then Println(#9 + FieldByName('TaxRollYr').Text + '/' +
                                      FieldByName('CertiorariNumber').Text +
                                 #9 + FieldByName('LawyerCode').Text +
                                 #9 + Take(15, FieldByName('CurrentName1').Text) +
                                 #9 + ParcelID +
                                 #9 + Take(10, GetLegalAddressFromTable(CertiorariTable)) +
                                 #9 + FormatFloat(IntegerDisplay,
                                                  FieldByName('CurrentTotalValue').AsInteger) +
                                 #9 + FormatFloat(IntegerDisplay,
                                                  FieldByName('PetitTotalValue').AsInteger) +
                                 #9 + FieldByName('DispositionDate').AsString +
                                 #9 + FieldByName('Disposition').AsString +
                                 #9 + FormatFloat(IntegerDisplay,
                                                  FieldByName('GrantedTotalValue').AsInteger) +
                                 #9 + FormatFloat(IntegerDisplay, iReduction))
                    else Println(#9 + FieldByName('TaxRollYr').Text +
                                 #9 + FieldByName('CertiorariNumber').Text +
                                 #9 + ParcelID +
                                 #9 + Take(20, FieldByName('CurrentName1').Text) +
                                 #9 + GetLegalAddressFromTable(CertiorariTable) +
                                 #9 + FieldByName('LawyerCode').Text +
                                 #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                  FieldByName('CurrentTotalValue').AsInteger) +
                                 #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                  FieldByName('PetitTotalValue').AsFloat));

                  If ExtractToExcel
                    then
                      begin
                        _Locate(tbParcels, [sParcelLocateYear, SwisSBLKey], '', [loParseSwisSBLKey]);

                        WriteCommaDelimitedLine(ExtractFile,
                                                [FieldByName('TaxRollYr').Text,
                                                 FieldByName('CertiorariNumber').Text,
                                                 ConvertSwisSBLToDashDot(SwisSBLKey),
                                                 FieldByName('CurrentName1').Text,
                                                 GetLegalAddressFromTable(CertiorariTable),
                                                 FieldByName('LawyerCode').Text]);

                        FillInNameAddrArray(FieldByName('PetitName1').AsString,
                                            FieldByName('PetitName2').AsString,
                                            FieldByName('PetitAddress1').AsString,
                                            FieldByName('PetitAddress2').AsString,
                                            FieldByName('PetitStreet').AsString,
                                            FieldByName('PetitCity').AsString,
                                            FieldByName('PetitState').AsString,
                                            FieldByName('PetitZip').AsString,
                                            FieldByName('PetitZipPlus4').AsString,
                                            True, False, NAddrArray);

                        WriteCommaDelimitedLine(ExtractFile,
                                                [NAddrArray[1],
                                                 NAddrArray[2],
                                                 NAddrArray[3],
                                                 NAddrArray[4],
                                                 NAddrArray[5],
                                                 NAddrArray[6],
                                                 FieldByName('CurrentTotalValue').AsInteger,
                                                 FieldByName('PetitTotalValue').AsInteger,
                                                 tbParcels.FieldByName('AccountNo').AsString,
                                                 ConvertSBLOnlyToOldDashDot(tbParcels.FieldByName('RemapOldSBL').AsString,
                                                                            tbAssessmentYearControl),
                                                 tbParcels.FieldByName('AdditionalLots').AsString]);

                        If IncludeResults
                        then WritelnCommaDelimitedLine(ExtractFile,
                                                       [FieldByName('DispositionDate').AsString,
                                                        FieldByName('Disposition').AsString,
                                                        FieldByName('GrantedTotalValue').AsInteger,
                                                        iReduction])
                        else WritelnCommaDelimitedLine(ExtractFile, []);

                      end;  {If ExtractToExcel}

                end;  {with CertiorariTable do}

              If (CreateParcelList and
                  (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                then ParcelListDialog.AddOneParcel(SwisSBLKey);

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 5)
                then NewPage;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

      Bold := True;
      If IncludeResults
        then Println(#9 +
                     #9 + 'Totals: ' +
                     #9 + #9 + #9 +
                     #9 + #9 + #9 +
                     #9 + #9 +
                     #9 + FormatFloat(IntegerDisplay, iTotalReduction));

      Bold := False;

      PrintGrievanceTotals(Sender, TotalsRec);

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TCertiorariSummaryReportForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TCertiorariSummaryReportForm.FormClose(    Sender: TObject;
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