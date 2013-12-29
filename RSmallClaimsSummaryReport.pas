unit RSmallClaimsSummaryReport;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls;

type
  TSmallClaimsSummaryReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    SmallClaimsTable: TwwTable;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ParcelTable: TTable;
    SmallClaimsExemptionsAskedTable: TwwTable;
    RepresentativeCodesTable: TTable;
    tbSmallClaimsCalendar: TTable;
    tbNYAssessments: TTable;
    tbTYAssessments: TTable;
    tbParcels: TTable;
    tbAssessmentYearControl: TTable;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    SmallClaimTypeRadioGroup: TRadioGroup;
    PrintOrderRadioGroupBox: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    CreateParcelListCheckBox: TCheckBox;
    IncludeResultsCheckBox: TCheckBox;
    SmallClaimsYearEdit: TEdit;
    ExtractToExcelCheckBox: TCheckBox;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    RepresentativeCodeListBox: TListBox;
    Panel3: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    tbsSwisSchool: TTabSheet;
    Label2: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    Label4: TLabel;
    SchoolCodeTable: TTable;
    SwisCodeTable: TTable;
    tbsPropertyClass: TTabSheet;
    Panel9: TPanel;
    lbxPropertyClassCodes: TListBox;
    Panel8: TPanel;
    Label5: TLabel;
    tbPropertyClass: TTable;
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
    CreateParcelList, ExtractToExcel : Boolean;
    SelectedRepresentativeCodes : TStringList;

    SmallClaimsYear, sParcelLocateYear : String;
    PrintOrder, SmallClaimsProcessingType, SmallClaimsStatusType : Integer;
    ExtractFile : TextFile;
    SelectedSchoolCodes,
    SelectedSwisCodes,
    slSelectedPropertyClassCodes : TStringList;  {What swis codes did they select?}
    bAllPropertyClassCodesSelected : Boolean;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Function MeetsStatusCriteria(    SwisSBLKey : String;
                                     SchoolCode : String;
                                     sPropertyClassCode : String;
                                     SmallClaimsYear : String;
                                     bAllPropertyClassCodesSelected : Boolean;
                                 var StatusThisSmallClaims : Integer) : Boolean;

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
  poIndexNumber = 0;
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
Procedure TSmallClaimsSummaryReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TSmallClaimsSummaryReportForm.InitializeForm;

begin
  UnitName := 'RCertiorariSummaryReport';  {mmm}

    {FXX10062002-1: In Westchester, the certs are on This Year.}

(*  If GlblIsWestchesterCounty
    then
      begin
        SmallClaimsYear := GlblNextYear;
        SmallClaimsProcessingType := NextYear;
      end
    else
      begin*)
        SmallClaimsYear := GlblThisYear;
        SmallClaimsProcessingType := ThisYear;
(*      end;*)

  sParcelLocateYear := SmallClaimsYear;
  OpenTablesForForm(Self, SmallClaimsProcessingType);

  _OpenTable(tbTYAssessments, AssessmentTableName, '', '', ThisYear, []);
  _OpenTable(tbNYAssessments, AssessmentTableName, '', '', NextYear, []);

  SmallClaimsYearEdit.Text := SmallClaimsYear;

  FillOneListBox(RepresentativeCodeListBox, RepresentativeCodesTable,
                 'Code', 'Name1', 20, True, True,
                 SmallClaimsProcessingType, SmallClaimsYear);

    {CHG06182010-1(2.27.1)[I6332]: Add Swis and school selection.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType,
                 GetTaxRlYr);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, GlblProcessingType,
                 GetTaxRlYr);

    {CHG06182010-2(2.27.1)[I7526]: Add the property class as a selection for grievance / small claims / cert reports.}

  FillOneListBox(lbxPropertyClassCodes, tbPropertyClass, 'MainCode',
                 'Description', 17, True, True, NextYear, GlblNextYear);

  SelectItemsInListBox(lbxPropertyClassCodes);
  SelectItemsInListBox(SwisCodeListBox);
  SelectItemsInListBox(SchoolCodeListBox);

end;  {InitializeForm}

{===================================================================}
Procedure TSmallClaimsSummaryReportForm.FormKeyPress(    Sender: TObject;
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
Procedure TSmallClaimsSummaryReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Small Claims Summary.grs', 'Small Claims Summary Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TSmallClaimsSummaryReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Small Claims Summary.grs', 'Small Claims Summary Report');

end;  {LoadButtonClick}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TSmallClaimsSummaryReportForm.PrintButtonClick(Sender: TObject);

var
  NewFileName, TempStr, SpreadsheetFileName : String;
  Quit : Boolean;
  I, TempPos : Integer;

begin
  ReportCancelled := False;
  Quit := False;
  SmallClaimsYear := SmallClaimsYearEdit.Text;

  SelectedRepresentativeCodes := TStringList.Create;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        PrintOrder := PrintOrderRadioGroupBox.ItemIndex;
        SmallClaimsTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

        case PrintOrder of
          poIndexNumber : SmallClaimsTable.IndexName := 'BYYEAR_INDEXNUM';
          poParcelID : SmallClaimsTable.IndexName := 'BYSWISSBLKEY';
          poOwnerName : SmallClaimsTable.IndexName := 'BYOWNERNAME';
          poLegalAddress : SmallClaimsTable.IndexName := 'BYLEGALADDR_LEGALADDRINT';

        end;  {case PrintOrder of}

          {CHG06182010-1(2.27.1)[I6332]: Add Swis and school selection.}

        SelectedSwisCodes := TStringList.Create;
        SelectedSchoolCodes := TStringList.Create;
        slSelectedPropertyClassCodes := TStringList.Create;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

          {CHG05162000-1: Add school codes option.}

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

        FillSelectedItemList(lbxPropertyClassCodes, slSelectedPropertyClassCodes, 3);

        bAllPropertyClassCodesSelected := _Compare(lbxPropertyClassCodes.Items.Count, slSelectedPropertyClassCodes.Count, coEqual);

        CreateParcelList := CreateParcelListCheckBox.Checked;
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

        IncludeResults := IncludeResultsCheckBox.Checked;

        SmallClaimsStatusType := SmallClaimTypeRadioGroup.ItemIndex;
        ExtractToExcel := ExtractToExcelCheckBox.Checked;

        For I := 0 to (RepresentativeCodeListBox.Items.Count - 1) do
          If RepresentativeCodeListBox.Selected[I]
            then
              begin
                TempStr := RepresentativeCodeListBox.Items[I];
                TempPos := Pos('-', TempStr);

                SelectedRepresentativeCodes.Add(Take((TempPos - 2), TempStr));

              end;  {If RepresentativeCodeListBox.Selected[I])}

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}
          {CHG10312005-1(2.9.3.10): Add the representative.  This makes it always a wide carriage report.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                              True, Quit);

        If not Quit
          then
            begin
              ProgressDialog.UserLabelCaption := '';

              case PrintOrder of
                poIndexNumber : ProgressDialog.Start(GetRecordCount(SmallClaimsTable), True, True);
                else ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
              end;

                {Now print the report.}

              If not (Quit or ReportCancelled)
                then
                  begin
                    If ExtractToExcel
                      then
                        begin
                          SpreadsheetFileName := GetPrintFileName('SL', True);
                          AssignFile(ExtractFile, SpreadsheetFileName);
                          Rewrite(ExtractFile);

                          WriteCommaDelimitedLine(ExtractFile,
                                                  ['Year',
                                                   'Index #',
                                                   'Swis Code',
                                                   'School Code',
                                                   'Print Key',
                                                   'Owner',
                                                   'Legal Address',
                                                   'Legal Address #',
                                                   'Legal Addr Street',
                                                   'Representative',
                                                   'Petit Name 1',
                                                   'Petit Name 2',
                                                   'Petit Address 1',
                                                   'Petit Address 2',
                                                   'Petit Address 3',
                                                   'Petit Address 4',
                                                   GlblThisYear + ' Value',
                                                   GlblNextYear + ' Value',
                                                   'Tentative Value',
                                                   'Asking Value',
                                                   'Hearing Date',
                                                   'Account #',
                                                   'Old Print Key',
                                                   'Additional Lots']);

                          If IncludeResults
                            then WritelnCommaDelimitedLine(ExtractFile,
                                                           ['Disposition Date',
                                                            'Disposition',
                                                            'Granted Value',
                                                            'Reduction Amount'])
                            else WritelnCommaDelimitedLine(ExtractFile, []);

                        end;  {If ExtractToExcel}

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

                            PreviewForm.FilePreview.ZoomFactor := 100;

                            ReportFiler.Execute;

                            ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                            PreviewForm.ShowModal;
                          finally
                            PreviewForm.Free;
                          end;

                          ShowReportDialog('Small Claims Summary Report.RPT', NewFileName, True);

                        end
                      else ReportPrinter.Execute;

                  end;  {If not Quit}

                {Clear the selections.}

              ProgressDialog.Finish;

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

              If CreateParcelList
                then ParcelListDialog.Show;

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
  slSelectedPropertyClassCodes.Free;
  SelectedSwisCodes.Free;
  SelectedSchoolCodes.Free;

end;  {PrintButtonClick}

{====================================================================}
Function TSmallClaimsSummaryReportForm.MeetsStatusCriteria(    SwisSBLKey : String;
                                                               SchoolCode : String;
                                                               sPropertyClassCode : String;
                                                               SmallClaimsYear : String;
                                                               bAllPropertyClassCodesSelected : Boolean;
                                                           var StatusThisSmallClaims : Integer) : Boolean;

begin
  Result := True;

  If ((Deblank(SmallClaimsYear) <> '') and
      (SmallClaimsTable.FieldByName('TaxRollYr').Text <> SmallClaimsYear))
    then Result := False;

  If Result
    then
      begin
        GetCert_Or_SmallClaimStatus(SmallClaimsTable, StatusThisSmallClaims);

        If (SmallClaimsStatusType = cstAll)
          then Result := True
          else
            begin
              case SmallClaimsStatusType of
                cstOpen : Result := (StatusThisSmallClaims = csOpen);

                cstClosed : Result := (StatusThisSmallClaims in [csApproved,
                                                                csDenied,
                                                                csWithdrawn,
                                                                csDismissed]);

                cstApproved : Result := (StatusThisSmallClaims = csApproved);

                cstDenied : Result := (StatusThisSmallClaims = csDenied);

                cstWithdrawn : Result := (StatusThisSmallClaims = csWithdrawn);

                cstDismissed : Result := (StatusThisSmallClaims = csDismissed);

              end;  {case StatusThisSmallClaims of}

            end;  {else of If (SmallClaimsStatusType = gsAll)}

      end;  {If Result}

    {Check the representative.}

  If Result
    then Result := ((SelectedRepresentativeCodes.Count =
                     RepresentativeCodeListBox.Items.Count) or  {All items selected}
                    (SelectedRepresentativeCodes.IndexOf(SmallClaimsTable.FieldByName('LawyerCode').Text) > -1));

    {CHG06182010-1(2.27.1)[I6332]: Add Swis and school selection.}

  If (Result and
      (SelectedSwisCodes.IndexOf(Copy(SwisSBLKey, 1, 6)) = -1))
    then Result := False;

  If (Result and
      (Deblank(SchoolCode) <> '') and
      (SelectedSchoolCodes.IndexOf(SchoolCode) = -1))
    then Result := False;

  If (Result and
      ((not bAllPropertyClassCodesSelected) and
       _Compare(slSelectedPropertyClassCodes.IndexOf(ParcelTable.FieldByName('PropertyClassCode').Text), -1, coGreaterThan)))
  then Result := False;

end;  {MeetsCertiorariStatusCriteria}

{====================================================================}
Procedure TSmallClaimsSummaryReportForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;

      Println('');
      Println('');

        {Print the date and page number.}

      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '    ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman',12);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Small Claims Listing for ' + SmallClaimsYear, (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',10);
      ClearTabs;

        {CHG02092010-1(2.22.1.13): Add the hearing date.}

      If IncludeResults
        then
          begin
            SetTab(5.7, pjCenter, 0.8, 0, BoxLineNone, 0);  {Tenative amount}
            SetTab(6.6, pjCenter, 0.8, 0, BoxLineNone, 0);  {Petitioner value}
            SetTab(7.5, pjCenter, 0.8, 0, BoxLineNone, 0);  {Hearing date}
            SetTab(8.4, pjCenter, 0.8, 0, BoxLineNone, 0);   {Decision date (Stipulation or BOAR)}
            SetTab(9.3, pjCenter, 1.0, 0, BoxLineNone, 0);   {Decision code}
            SetTab(10.4, pjCenter, 0.7, 0, BoxLineNone, 0);   {Granted total value}
            SetTab(11.2, pjCenter, 0.6, 0, BoxLineNone, 0);  {Reduction}
            SetTab(11.9, pjCenter, 1.3, 0, BoxLineNone, 0);  {Granted exemption information}
            SetTab(13.3, pjCenter, 0.5, 0, BoxLineNone, 0);  {School Code}

            Println(#9 + 'Tentative' +
                    #9 + 'Petitioner' +
                    #9 + 'Hearing' +
                    #9 + 'Decision' +
                    #9 + 'Decision' +
                    #9 + 'Granted' +
                    #9 + 'Reduction' +
                    #9 + 'Granted' +
                    #9 + 'School');

            ClearTabs;
            SetTab(0.3, pjCenter, 0.4, 0, BoxLineBottom, 0);  {Index #}
            SetTab(0.8, pjCenter, 1.0, 0, BoxLineBottom, 0);  {Lawyer}
            SetTab(1.9, pjCenter, 1.5, 0, BoxLineBottom, 0);  {Owner name}
            SetTab(3.5, pjCenter, 1.1, 0, BoxLineBottom, 0);  {Parcel ID}
            SetTab(4.6, pjCenter, 1.1, 0, BoxLineBottom, 0);  {Legal address}
            SetTab(5.7, pjCenter, 0.8, 0, BoxLineBottom, 0);  {Tenative amount}
            SetTab(6.6, pjCenter, 0.8, 0, BoxLineBottom, 0);  {Petitioner value}
            SetTab(7.5, pjCenter, 0.8, 0, BoxLineBottom, 0);  {Hearing date}

            SetTab(8.4, pjCenter, 0.8, 0, BoxLineBottom, 0);   {Decision date (Stipulation or BOAR)}
            SetTab(9.3, pjCenter, 1.0, 0, BoxLineBottom, 0);   {Decision code}
            SetTab(10.4, pjCenter, 0.7, 0, BoxLineBottom, 0);   {Granted total value}
            SetTab(11.2, pjCenter, 0.6, 0, BoxLineBottom, 0);  {Reduction}
            SetTab(11.9, pjCenter, 1.3, 0, BoxLineBottom, 0);  {Granted exemption information}
            SetTab(13.3, pjCenter, 0.5, 0, BoxLineBottom, 0);  {School Code}

            Println(#9 + 'Index #' +
                    #9 + 'Rep' +
                    #9 + 'Owner Name' +
                    #9 + 'Parcel ID' +
                    #9 + 'Legal Address' +
                    #9 + 'Amount' +
                    #9 + 'Amount' +
                    #9 + 'Date' +
                    #9 + 'Date' +
                    #9 + 'Code' +
                    #9 + 'Amount' +
                    #9 + 'Amount' +
                    #9 + 'Exemption' +
                    #9 + 'Code');

            ClearTabs;

            SetTab(0.3, pjLeft, 0.4, 0, BoxLineNone, 0);   {Index #}
            SetTab(0.8, pjLeft, 1.0, 0, BoxLineNone, 0);   {Lawyer}
            SetTab(1.9, pjLeft, 1.5, 0, BoxLineNone, 0);   {Owner name}
            SetTab(3.5, pjLeft, 1.1, 0, BoxLineNone, 0);   {Parcel ID}
            SetTab(4.6, pjLeft, 1.1, 0, BoxLineNone, 0);   {Legal address}

            SetTab(5.7, pjRight, 0.8, 0, BoxLineNone, 0);  {Tenative amount}
            SetTab(6.6, pjRight, 0.8, 0, BoxLineNone, 0);  {Petitioner value}
            SetTab(7.5, pjRight, 0.8, 0, BoxLineNone, 0);  {Hearing date}

            SetTab(8.4, pjLeft, 0.8, 0, BoxLineNone, 0);   {Decision date (Stipulation or BOAR)}
            SetTab(9.3, pjLeft, 1.0, 0, BoxLineNone, 0);   {Decision code}
            SetTab(10.4, pjRight, 0.7, 0, BoxLineNone, 0);   {Granted total value}
            SetTab(11.2, pjRight, 0.6, 0, BoxLineNone, 0);  {Reduction}
            SetTab(11.9, pjLeft, 1.3, 0, BoxLineNone, 0);   {Granted exemption information}
            SetTab(13.3, pjLeft, 0.5, 0, BoxLineNone, 0);   {School Code}

          end
        else
          begin
            SetTab(8.2, pjCenter, 1.1, 0, BoxLineNone, 0);   {Tentative Amount}
            SetTab(9.4, pjCenter, 1.1, 0, BoxLineNone, 0);   {Amount}
            SetTab(10.6, pjCenter, 0.8, 0, BoxLineNone, 0);   {Hearing date}

            Println(#9 + 'Tentative' +
                    #9 + 'Petitioner' +
                    #9 + 'Hearing');

            ClearTabs;

            SetTab(0.3, pjCenter, 0.4, 0, BoxLineBottom, 0);   {Year}
            SetTab(0.8, pjCenter, 0.6, 0, BoxLineBottom, 0);   {Index #}
            SetTab(1.5, pjCenter, 1.4, 0, BoxLineBottom, 0);   {Parcel ID}
            SetTab(3.0, pjCenter, 2.0, 0, BoxLineBottom, 0);   {Owner name}
            SetTab(5.1, pjCenter, 1.8, 0, BoxLineBottom, 0);   {Legal address}
            SetTab(7.0, pjCenter, 1.1, 0, BoxLineBottom, 0);   {Representative}
            SetTab(8.2, pjCenter, 1.1, 0, BoxLineBottom, 0);   {Tentative Amount}
            SetTab(9.4, pjCenter, 1.1, 0, BoxLineBottom, 0);   {Amount}
            SetTab(10.6, pjCenter, 0.8, 0, BoxLineBottom, 0);   {Hearing date}

            Println(#9 + 'Year' +
                     #9 + 'Index #' +
                     #9 + 'Parcel ID' +
                     #9 + 'Owner Name' +
                     #9 + 'Legal Address' +
                     #9 + 'Representative' +
                     #9 + 'Amount' +
                     #9 + 'Amount' +
                     #9 + 'Date');

            ClearTabs;

            SetTab(0.3, pjLeft, 0.4, 0, BoxLineNone, 0);   {Year}
            SetTab(0.8, pjLeft, 0.6, 0, BoxLineNone, 0);   {Index #}
            SetTab(1.5, pjLeft, 1.4, 0, BoxLineNone, 0);   {Parcel ID}
            SetTab(3.0, pjLeft, 2.0, 0, BoxLineNone, 0);   {Owner name}
            SetTab(5.1, pjLeft, 1.8, 0, BoxLineNone, 0);   {Legal address}
            SetTab(7.0, pjLeft, 1.1, 0, BoxLineNone, 0);   {Representative}
            SetTab(8.2, pjRight, 1.1, 0, BoxLineNone, 0);   {Tentative Amount}
            SetTab(9.4, pjRight, 1.1, 0, BoxLineNone, 0);   {Amount}
            SetTab(10.6, pjRight, 1.1, 0, BoxLineNone, 0);   {Hearing date}

          end;  {else of If IncludeResults}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {TextFilerPrintHeader}

{====================================================================}
Procedure TSmallClaimsSummaryReportForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit,
  ProcessThisRecord : Boolean;
  SwisSBLKey, sTrialDate, sGrantedExemption : String;
  NumFound, StatusThisSmallClaims : Integer;
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

(*  case PrintOrder of
    poIndexNumber : SmallClaimsTable.First;
    else ParcelTable.First;
  end; *)

  SmallClaimsTable.First;

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SmallClaimsTable.Next;
            (*case PrintOrder of
              poIndexNumber : SmallClaimsTable.Next;
              else ParcelTable.Next;
            end; *)

        If SmallClaimsTable.EOF
          then Done := True;
(*        case PrintOrder of
          poIndexNumber :
            If SmallClaimsTable.EOF
              then Done := True;

          else
            If ParcelTable.EOF
              then Done := True;

        end;  {case PrintOrder of} *)

        Application.ProcessMessages;
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));

          {Print the present record.}

        ProcessThisRecord := True;
        SwisSBLKey := SmallClaimsTable.FieldByName('SwisSBLKey').Text;

        (*case PrintOrder of
          poIndexNumber : SwisSBLKey := SmallClaimsTable.FieldByName('SwisSBLKey').Text;
          else SwisSBLKey := ExtractSSKey(ParcelTable);
        end; *)

       (* If ((PrintOrder <> poIndexNumber) and
            (not FindKeyOld(SmallClaimsTable, ['TaxRollYr', 'SwisSBLKey'],
                            [SmallClaimsYear, SwisSBLKey])))
          then ProcessThisRecord := False; *)

        _Locate(tbParcels, [sParcelLocateYear, SwisSBLKey], '', [loParseSwisSBLKey]);

          {Check to see if it matches the status type asked for.}

        If (ProcessThisRecord and
            (not MeetsStatusCriteria(SwisSBLKey,
                                     tbParcels.FieldByName('SchoolCode').AsString,
                                     SmallClaimsTable.FieldByName('PropertyClassCode').AsString,
                                     SmallClaimsYear,
                                     bAllPropertyClassCodesSelected, StatusThisSmallClaims)))
          then ProcessThisRecord := False;

        If (ProcessThisRecord and
            (not (Done or Quit)))
          then
            begin
              UpdateSmallClaims_Certiorari_TotalsRecord(TotalsRec, StatusThisSmallClaims);
              NumFound := NumFound + 1;
              ProgressDialog.UserLabelCaption := 'Found = ' + IntToStr(NumFound);

              (*case PrintOrder of
                poIndexNumber : SwisSBLKey := SmallClaimsTable.FieldByName('SwisSBLKey').Text;
                else SwisSBLKey := ExtractSSKey(ParcelTable);
              end; *)

              with SmallClaimsTable do
                begin
                  _SetRange(tbSmallClaimsCalendar,
                            [FieldByName('TaxRollYr').AsString,
                             FieldByName('SwisSBLKey').AsString,
                             FieldByName('IndexNumber').AsInteger,
                             '1/1/1900'],
                            [FieldByName('TaxRollYr').AsString,
                             FieldByName('SwisSBLKey').AsString,
                             FieldByName('IndexNumber').AsInteger,
                             '1/1/2100'],
                            '', []);

                  sTrialDate := '';

                  If _Compare(tbSmallClaimsCalendar.RecordCount, 0, coGreaterThan)
                    then
                      begin
                        tbSmallClaimsCalendar.Last;
                        sTrialDate := tbSmallClaimsCalendar.FieldByName('Date').AsString;
                      end;

                    {CHG10312005-1(2.9.3.10): Add the representative.}
                    {CHG06032008-1(2.13.1.8): Add a column for the reduction amount.}

                  If _Compare(FieldByName('GrantedTotalValue').AsInteger, 0, coGreaterThan)
                    then iReduction := FieldByName('CurrentTotalValue').AsInteger -
                                       FieldByName('GrantedTotalValue').AsInteger
                    else iReduction := 0;

                  iTotalReduction := iTotalReduction + iReduction;

                  sGrantedExemption := FieldByName('GrantedEXCode').AsString;

                  If _Compare(sGrantedExemption, coNotBlank)
                  then sGrantedExemption := sGrantedExemption + '-' +
                                            FormatFloat(IntegerDisplay,
                                                        FieldByName('GrantedEXAmount').AsInteger);

                  _Locate(tbTYAssessments, [GlblThisYear, SwisSBLKey], '', []);
                  _Locate(tbNYAssessments, [GlblNextYear, SwisSBLKey], '', []);

                  If IncludeResults
                    then Println(#9 + FieldByName('IndexNumber').Text +
                                 #9 + FieldByName('LawyerCode').Text +
                                 #9 + Take(15, FieldByName('CurrentName1').Text) +
                                 #9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                                 #9 + Take(10, GetLegalAddressFromTable(SmallClaimsTable)) +
                                 #9 + FormatFloat(IntegerDisplay,
                                                  FieldByName('CurrentTotalValue').AsInteger) +
                                 #9 + FormatFloat(IntegerDisplay,
                                                  FieldByName('PetitTotalValue').AsInteger) +
                                 #9 + sTrialDate +
                                 #9 + FieldByName('DispositionDate').AsString +
                                 #9 + FieldByName('Disposition').AsString +
                                 #9 + FormatFloat(IntegerDisplay,
                                                  FieldByName('GrantedTotalValue').AsInteger) +
                                 #9 + FormatFloat(IntegerDisplay, iReduction) +
                                 #9 + sGrantedExemption +
                                 #9 + tbParcels.FieldByName('SchoolCode').AsString)
                    else Println(#9 + FieldByName('TaxRollYr').Text +
                                 #9 + FieldByName('IndexNumber').Text +
                                 #9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                                 #9 + Take(20, FieldByName('CurrentName1').Text) +
                                 #9 + GetLegalAddressFromTable(SmallClaimsTable) +
                                 #9 + FieldByName('LawyerCode').Text +
                                 #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                  FieldByName('CurrentTotalValue').AsInteger) +
                                 #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                                  FieldByName('PetitTotalValue').AsFloat) +
                                 #9 + sTrialDate);

                  If ExtractToExcel
                    then
                      begin
                        WriteCommaDelimitedLine(ExtractFile,
                                                [FieldByName('TaxRollYr').Text,
                                                 FieldByName('IndexNumber').Text,
                                                 Copy(SwisSBLKey, 1, 6),
                                                 FieldByName('SchoolCode').AsString,
                                                 ConvertSwisSBLToDashDot(SwisSBLKey),
                                                 FieldByName('CurrentName1').Text,
                                                 GetLegalAddressFromTable(SmallClaimsTable),
                                                 FieldByName('LegalAddrNo').AsString,
                                                 FieldByName('LegalAddr').AsString,
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
                                                 tbTYAssessments.FieldByName('TotalAssessedVal').AsInteger,
                                                 tbNYAssessments.FieldByName('TotalAssessedVal').AsInteger,
                                                 FieldByName('CurrentTotalValue').AsInteger,
                                                 FieldByName('PetitTotalValue').AsInteger,
                                                 sTrialDate,
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

                end;  {with SmallClaimsTable do}

              If (CreateParcelList and
                  (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                then ParcelListDialog.AddOneParcel(SwisSBLKey);

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 6)
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
Procedure TSmallClaimsSummaryReportForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TSmallClaimsSummaryReportForm.FormClose(    Sender: TObject;
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