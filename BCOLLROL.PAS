unit Bcollrol;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Btrvdlg, wwdblook, Mask,types,pastypes,
  Glblcnst, Gauges,Printrng, RPMemo, RPDBUtil, RPDefine, (*Progress, *)RPTXFilr,
  RPFPrint, RPreview;

type
  TBillPrintRollForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    PrintDialog: TPrintDialog;
    Label18: TLabel;
    CollectionLookupTable: TwwTable;
    label16: TLabel;
    Label2: TLabel;
    ScrollBox2: TScrollBox;
    BillCollTypeLookupTable: TwwTable;
    BLSpecialDistrictTaxTable: TTable;
    BLExemptionTaxTable: TTable;
    BLGeneralTaxTable: TTable;
    BLHeaderTaxTable: TTable;
    BLSpecialFeeTaxTable: TTable;
    SchoolTotalsTable: TTable;
    EXTotalsTable: TTable;
    SDTotalsTable: TTable;
    SpecialFeeTotalsTable: TTable;
    RollSectionListBox: TListBox;
    Label21: TLabel;
    ShowRollSectionTotalsCheckBox: TCheckBox;
    AssessmentYearCtlTable: TTable;
    TextFiler: TTextFiler;
    SDCodeTable: TTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    TaxRollYearEdit: TEdit;
    Label25: TLabel;
    GeneralTotalsTable: TwwTable;
    Label26: TLabel;
    SwisCodeTable: TTable;
    DatePrintedEdit: TMaskEdit;
    Label27: TLabel;
    STARReportPrinter: TReportPrinter;
    STARReportFiler: TReportFiler;
    STARTextFiler: TTextFiler;
    EXCodeTable: TTable;
    Label6: TLabel;
    RollHeaderTitleEdit: TEdit;
    PrintFullMarketValueCheckBox: TCheckBox;
    ParcelTable: TTable;
    PrintAdditionalLotsCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    SuppressSDExtensionsCheckBox: TCheckBox;
    Panel4: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditTaxRollYear: TEdit;
    LookupCollectionType: TwwDBLookupCombo;
    EditCollectionNumber: TEdit;
    Panel5: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    IndexRadioGroup: TRadioGroup;
    GroupByAccountNumberCheckBox: TCheckBox;
    cb_PrintOnlyNonZeroBills: TCheckBox;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure STARTextFilerPrint(Sender: TObject);
    procedure STARReportPrint(Sender: TObject);
    procedure HeaderInformationExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    PrintingCancelled : Boolean;

    GeneralRateList,
    SDRateList,
    SpecialFeeRateList,
    BillControlDetailList,
    SDExtCategoryList,
    PropertyClassDescList,
    RollSectionDescList,
    EXCodeDescList,
    SDCodeDescList,
    SDExtCodeDescList,
    SwisCodeDescList,
    SchoolCodeDescList : TList;

    SelectedRollSections,
    CL1List,
    CL2List,
    CL3List,
    CL4List,
    CL5List,
    CL6List,
    CL7List : TStringList;

    FoundCollectionRec : Boolean;
    CollectionType : String;
    NumBillsPrinted : LongInt;
    LastRollSection : String;
    LastSwisCode,
    LastSchoolCode : String;
    SequenceStr : String;  {Text of what order the roll is printing in.}
    RollPrintingYear : String;
    TaxRollYr : String;  {What tax roll year should we use for this collection?}
    ProcessingType, NumberGeneralRates, PrintOrder : Integer;
    TotalsOnly : Boolean;
    TotalTaxRS1_8, TotalTaxRS9 : Extended;
    CollectionHasSchoolTax, PrintAdditionalLots, ExtractToExcel : Boolean;
    ExtractFile : TextFile;
    SuppressSDExtensions, GroupByAccountNumber, PrintOnlyNonZeroBills : Boolean;
    AccountNumberList : TStringList;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function ParcelShouldBePrinted : Boolean;
    {We should print this parcel if
      1. They are not showing just roll totals.
      2. It is in a roll section that they want to see.}

    Procedure AddRecordToExtractFile(var ExtractFile : TextFile;
                                         BLHeaderTaxTable : TTable;
                                         GnTaxList,
                                         ExTaxList,
                                         SDTaxList,
                                         SPTaxList : TList);

    Procedure PrintSelectedRollSections(    Sender : TObject;
                                            SelectedRollSections : TStringList;
                                            AccountNumberToPrint : String;
                                        var FirstPageOfReport : Boolean;
                                        var TotalTax : Extended);
    {FXX01061998-2: Print only the roll sections they choose and print
                   sections 7 and 9 seperately.}

  end;


implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview,
     Prog, RptDialg,
     UtilBill,  {Billing specific utilities.}
     Utrtotpt;  {Section totals print unit}

const
  poParcelID = 0;
  poOwner = 1;
  poLegalAddress = 2;
  poAccountNumber = 3;

{$R *.DFM}

{========================================================}
Procedure TBillPrintRollForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TBillPrintRollForm.InitializeForm;

var
  I : Integer;

begin
    {FXX05182012-2(2.28.4.25)[PAS-336]: Print the uniform percent of value.  The capability already existed, it just was not enabled.}

  Utilbill.PrintUniformPercentOfValue := True;

  UnitName := 'BCOLLROL.PAS';  {mmm}

    {FXX06231998-3: Put in changes to allow for Westchester billing off NY.}

  TaxRollYr := DetermineBillingTaxYear;
  ProcessingType := GetProcessingTypeForTaxRollYear(TaxRollYr);

    {Note that the billing tax and totals files do not get opened below.
     They get opened once the person fills in the collection type and
     number.}

  OpenTablesForForm(Self, ProcessingType);

  EditTaxRollYear.Text := TaxRollYr;

    {Select all the roll selections as a default.}

  For I := 0 to (RollSectionListBox.Items.Count - 1) do
    RollSectionListBox.Selected[I] := True;

    {FXX06301998-6: Default the tax roll year to Next year, but let them change.}
    {FXX06181999-11: Set tax roll year to NY for Westchester, TY otherwise.}

  If GlblIsWestchesterCounty
    then TaxRollYearEdit.Text := GlblNextYear
    else TaxRollYearEdit.Text := GlblThisYear;

   {FXX06181999-12: Allow the user to select the date of the roll printing.}

  DatePrintedEdit.Text := DateToStr(Date);

end;  {InitializeForm}

{===================================================================}
Procedure TBillPrintRollForm.HeaderInformationExit(Sender: TObject);

{CHG02122000-1: Allow them to edit the title on the roll.}

begin
  If ((Deblank(LookupCollectionType.Text) <> '') and
      (Deblank(EditCollectionNumber.Text) <> '') and
      (Deblank(TaxRollYearEdit.Text) <> ''))
    then RollHeaderTitleEdit.Text := GetRollHeaderTitle('X',
                                                        LookupCollectionType.Text,
                                                        TaxRollYearEdit.Text);

end;  {HeaderInformationExit}

{===================================================================}
Procedure TBillPrintRollForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{=====================================================================}
Procedure TBillPrintRollForm.PrintButtonClick(Sender: TObject);

var
  TextFileName, NewFileName : String;
  I : Integer;

  GeneralTotFileName,
  SDTotFileName,
  SchoolTotFileName,
  EXTotFileName,
  SpecialFeeTotFileName : String;

  ReducedSize, Found, OKToStartPrinting,
  WholeRollPrinted, Quit : Boolean;
  CollectionNum : Integer;
  TaxRollYear : String;
  SpreadsheetFileName,
  HeaderFileName, GeneralFileName,
  EXFileName, SDFileName, SpecialFeeFileName : String;
  UniformPercentOfValue, EqualizationRate : Real;
  DuplexType : TDuplex;

begin
  AccountNumberList := TStringList.Create;
  ExtractToExcel := ExtractToExcelCheckBox.Checked;
  SuppressSDExtensions := SuppressSDExtensionsCheckBox.Checked;
  WholeRollPrinted := False;
  OKToStartPrinting := True;
  GlblCurrentTabNo := 0;
  GroupByAccountNumber := GroupByAccountNumberCheckBox.Checked;
  ReducedSize := False;
  DuplexType := dupSimplex;
  PrintOnlyNonZeroBills := cb_PrintOnlyNonZeroBills.Checked;

  TaxRollYear := Take(4, EditTaxRollYear.Text);
  CollectionType := Take(2, LookupCollectionType.Text);

  try
    CollectionNum := StrToInt(Deblank(EditCollectionNumber.Text));
  except
    CollectionNum := 1;
  end;


  If (Deblank(EditTaxRollYear.Text) = '')
    then
      begin
        MessageDlg('Please enter the tax roll year.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

  If (Deblank(EditCollectionNumber.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection number.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

  If (Deblank(LookupCollectionType.Text) = '')
    then
      begin
        MessageDlg('Please enter the collection type.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

    {If they have entered all the information, look it up in the bill
     control file to make sure that a collection exists for what they
     entered.}

  If OKToStartPrinting
    then
      begin
        If (CollectionType = 'SC')
          then MunicipalitiesToPrint := [mtpSchool]
          else MunicipalitiesToPrint := [mtpCounty, mtpTown];

        try
          Found := FindKeyOld(CollectionLookupTable,
                              ['TaxRollYr', 'CollectionType',
                               'CollectionNo'],
                              [TaxRollYear, CollectionType,
                               IntToStr(CollectionNum)]);
        except
          Found := False;
          OKToStartPrinting := False;
          SystemSupport(010, CollectionLookupTable, 'Error getting bill control record.',
                        UnitName, GlblErrorDlgBox);
        end;

        If Found
          then
            begin
              If (MessageDlg('You are going to print the roll for collection type ' + CollectionType + ',' + #13 +
                             'collection number ' + IntToStr(CollectionNum) + '.' + #13
                             + #13 +
                             'Do you want to proceed?',
                             mtConfirmation, [mbYes, mbNo], 0) = idNo)
                then OKToStartPrinting := False;

            end
          else
            begin
              MessageDlg('The collection that you entered does not exist.' + #13 +
                         'Please try again.', mtError, [mbOK], 0);
              OKToStartPrinting := False;
            end;

      end;  {If OKToStartPrinting}

    {Set the print index.}

  If OKToStartPrinting
    then
      begin
        PrintOrder := IndexRadioGroup.ItemIndex;

        with BLHeaderTaxTable do
          case PrintOrder of
            poParcelID : IndexName := 'BYSCHOOL_SWIS_RS_SBL';
            poOwner : IndexName := 'BYSCHOOL_SWIS_RS_NAME';
            poLegalAddress : IndexName := 'BYSCHOOL_SWIS_RS_ADDR';
            poAccountNumber : IndexName := 'BYSCHOOL_SWIS_RS_AccountNumber';

            else
              begin
                MessageDlg('You must select a print order for the roll.',
                           mtError, [mbOK], 0);
                OKToStartPrinting := False;
              end;

          end;  {case PrintOrder of}

      end;  {If OKToStartPrinting}

    {FXX12171998-7: Make sure that the dates in the assessment year control
                    file are filled in and the uniform % of value.}
    {FXX07191999-6: Display all info for verification before printing.}

  If OKToStartPrinting
    then OKToStartPrinting := VerifyDatesAndPercentOfValueFilledIn(AssessmentYearCtlTable,
                                                                   SwisCodeTable,
                                                                   UniformPercentOfValue,
                                                                   EqualizationRate);

    {FXX06181999-12: Allow the user to select the date of the roll printing.}

  If OKToStartPrinting
    then
      try
        RollPrintingDate := StrToDate(DatePrintedEdit.Text);
      except
        MessageDlg('Please enter a valid tax roll printing date.', mtError, [mbOK], 0);
        OKToStartPrinting := False;
      end;

  If (OKToStartPrinting and
      (not ConfirmRollSetup(AssessmentYearCtlTable, EXCodeTable, SwisCodeTable,
                            RollHeaderTitleEdit.Text, 'print', DatePrintedEdit.Text)))
    then OKToStartPrinting := False;

    {If they entered a collection that exists, then open the billing and
     totals files, get the rates, and start the billing.}

  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If (OKToStartPrinting and
      PrintDialog.Execute)
    then
      begin
        If (CollectionType = 'SC')
          then MunicipalitiesToPrint := [mtpSchool];

        If (CollectionType = 'MU')
          then MunicipalitiesToPrint := [mtpCounty, mtpTown];

        If (CollectionType = 'VI')
          then MunicipalitiesToPrint := [mtpTown];

          {CHG04032000-1: Print full market value on rolls.}
        GlblPrintFullMarketValue := PrintFullMarketValueCheckBox.Checked;

          {CHG02122000-1: Allow them to edit the title on the roll.}

        RollHeaderTitle := RollHeaderTitleEdit.Text;
        PrintAdditionalLots := PrintAdditionalLotsCheckBox.Checked;

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser, ptDotMatrix], True, Quit);

          {FXX12291999-1: Allow them to specify the number of blank lines at
                          the bottom of the roll. Note that we can tell if it
                          is going to a dot matrix or laser jet by looking at the
                          print orientation - it will be landscape for laser and
                          portrait for dot matrix.}

        If (ReportPrinter.Orientation = poLandscape)
          then LinesAtBottom := GlblLinesLeftOnRollLaserJet
          else LinesAtBottom := GlblLinesLeftOnRollDotMatrix;

          {FXX10071999-1: To solve the problem of printing to the high speed,
                          we need to set the font to a TrueType even though it
                          doesn't matter in the actual printing.  The reason for this
                          is that without setting it, the default font is System for
                          the Generic printer which has a baseline descent of 0.5
                          which messes up printing to a text file.  We needed a font
                          with no descent.}

        TextFiler.SetFont('Courier New', 10);

        Quit := False;
        NumBillsPrinted := 0;
        PrintingCancelled := False;

          {Create the rate lists.}

        GeneralRateList := TList.Create;
        SDRateList := TList.Create;
        SpecialFeeRateList := TList.Create;
        BillControlDetailList := TList.Create;

          {Description lists}

        SDExtCategoryList := TList.Create;
        PropertyClassDescList := TList.Create;
        EXCodeDescList := TList.Create;
        SDCodeDescList := TList.Create;
        SwisCodeDescList := TList.Create;
        SchoolCodeDescList := TList.Create;
        SDExtCodeDescList := TList.Create;
        RollSectionDescList := TList.Create;

          {create string list for each bill image}
          {columns 1 -7 spread across each line of tax bill}

        CL1List := TStringList.Create;
        CL2List := TStringList.Create;
        CL3List := TStringList.Create;
        CL4List := TStringList.Create;
        CL5List := TStringList.Create;
        CL6List := TStringList.Create;
        CL7List := TStringList.Create;

          {Get the file names and open the billing files for this
           tax year\municipal type\collection #.}

        GetBillingFileNames(TaxRollYear, CollectionType,
                            ShiftRightAddZeroes(Take(2, IntToStr(CollectionNum))),
                            HeaderFileName, GeneralFileName,
                            EXFileName, SDFileName, SpecialFeeFileName);

        OpenBillingFiles(HeaderFileName, GeneralFileName, EXFileName,
                         SDFileName, SpecialFeeFileName, BLHeaderTaxTable,
                         BLGeneralTaxTable, BLExemptionTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLSpecialFeeTaxTable, Quit);

        If GroupByAccountNumber
          then FillDistinctStringListFromTable(AccountNumberList, BLHeaderTaxTable, 'AccountNumber', 6, True);

          {Get the file names and open the totals files for this
           tax year\municipal type\collection #.}

        If not Quit
          then
            begin
              GetTotalsFileNames(TaxRollYear, CollectionType,
                                 ShiftRightAddZeroes(Take(2, IntToStr(CollectionNum))),
                                 'X', GeneralTotFileName, SchoolTotFileName,
                                 EXTotFileName, SDTotFileName,
                                 SpecialFeeTotFileName);

              OpenTotalsFiles(GeneralTotFileName, EXTotFileName, SDTotFileName,
                              SchoolTotFileName, SpecialFeeTotFileName,
                              GeneralTotalsTable, EXTotalsTable, SDTotalsTable,
                              SchoolTotalsTable, SpecialFeeTotalsTable, False, Quit);

            end;  {If not Quit}

          {Now load the rate and description lists.}

        If not Quit
          then
            begin
              LoadRateListsFromRateFiles(TaxRollYear, CollectionType,
                                         CollectionNum, GeneralRateList,
                                         SDRateList,
                                         SpecialFeeRateList,
                                         BillControlDetailList, 'P', Quit);

              LoadSDExtCategoryList(SDExtCategoryList, Quit);

              LoadCodeList(PropertyClassDescList, 'ZPropClsTbl',
                           'MainCode', 'Description', Quit);

              LoadCodeList(RollSectionDescList, 'ZRollSectionTbl',
                           'MainCode', 'Description', Quit);

              LoadCodeList(EXCodeDescList, 'TExCodeTbl',
                           'ExCode', 'Description', Quit);

              LoadCodeList(SDCodeDescList, 'TSDCodeTbl',
                           'SDistCode', 'Description', Quit);

                {FXX06251998-7: Need to store the uniform % of value for each swis code.}

              LoadCodeList(SwisCodeDescList, 'TSwisTbl',
                           'SwisCode', 'MunicipalityName', Quit);

              LoadCodeList(SchoolCodeDescList, 'TSchoolTbl',
                           'SchoolCode', 'SchoolName', Quit);

              LoadCodeList(SDExtCodeDescList, 'ZSDExtCodeTbl',
                           'MainCode', 'Description', Quit);

                {FXX11291999-4: In order to allow city and school at the same time,
                                check the tax type of the individual line.}

              CollectionHasSchoolTax := False;
              For I := 0 to (GeneralRateList.Count - 1) do
                with GeneralRatePointer(GeneralRateList[I])^ do
                  If (GeneralTaxType = 'SC')
                    then CollectionHasSchoolTax := True;

            end;  {If not Quit}

          {Now, print the roll.}
          {CHG12301997-1: Change the report printer and filer to the
                          TextPrinter component.}
          {CHG06301999-1: Automatically print the totals and the full roll.}
          {First print a totals report.}

        If not Quit
          then
            begin
              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

              SetRollTabs(GlblReportReprintLeftMargin);

              If (ReportPrinter.Orientation = poLandscape)
                then
                  begin
(*                    If (MessageDlg('Do you want to print on letter size paper?',
                                   mtConfirmation, [mbYes, mbNo], 0) = idYes)
                      then
                        begin   *)
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

                          ReportPrinter.ScaleX := 77;
                          ReportPrinter.ScaleY := 70;
                          ReportPrinter.SectionLeft := 1.5;
                          ReportFiler.ScaleX := 77;
                          ReportFiler.ScaleY := 70;
                          ReportFiler.SectionLeft := 1.5;
                          NumLinesPerPage := 66;
                          LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
(*                        end
                      else
                        begin
                          LinesAtBottom := GlblLinesLeftOnRollLaserJet;
                          NumLinesPerPage := 51;
                        end;     *)


                  end
                else
                  begin
                    LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
                    NumLinesPerPage := 66;
                  end;

              MessageDlg('The tax roll totals will be printed first, followed by the full tax roll.' + #13 +
                         'You will have the option of whether or not to print the whole roll before' +
                         ' it is printed.' + #13 + 'Click OK to start printing.',
                         mtInformation, [mbOK], 0);
              TotalsOnly := True;
              PrintingCancelled := False;
              GlblPreviewPrint := False;

                {First generate the text file for the report.
                 Then either send to the printer or to the screen.}

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
                else ReportPrinter.Execute;

              ProgressDialog.Finish;

                {CHG01182000-3: Allow them to choose a different name or copy right away.}

              ShowReportDialog('XROLLTOT.RPT', TextFiler.FileName, True);

            end;  {If not Quit}

          {Now print the full roll if they want it.}
          {CHG09152004-1(2.8.0.11): Extract the tax roll to Excel.}

        If ((not (Quit or PrintingCancelled)) and
            (MessageDlg('Do you want to print the whole tax roll?', mtConfirmation, [mbYes, mbNo], 0) =
             idYes) and
            PrintDialog.Execute)
          then
            begin
              WholeRollPrinted := True;

              If ExtractToExcel
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

                    Write(ExtractFile, 'LandValue,',
                                       'TotalValue,',
                                       'FullMarketValue,',
                                       'TotalTaxOwed');

                      {Individual payment amounts.}

                    For I := 1 to CollectionLookupTable.FieldByName('NumberOfPayments').AsInteger do
                      Write(ExtractFile, ',Pay' + IntToStr(I) + 'Amount' + ',',
                                         'Pay' + IntToStr(I) + 'Date');

                      {Now allow 8 slots for exemptions.}

                    For I := 1 to 8 do
                      Write(ExtractFile, ',ExCode' + IntToStr(I) + ',',
                                         'ExDesc' + IntToStr(I) + ',',
                                         'ExCountyAmount' + IntToStr(I) + ',',
                                         'ExTownAmount' + IntToStr(I) + ',',
                                         'ExSchoolAmount' + IntToStr(I));

                    NumberGeneralRates := GeneralRateList.Count;

                    If GlblMunicipalityUsesTwoTaxRates
                      then NumberGeneralRates := NumberGeneralRates * 2;

                    For I := 1 to NumberGeneralRates do
                      Write(ExtractFile, ',BaseTaxDesc' + IntToStr(I) + ',',
                                         'BaseTaxable' + IntToStr(I) + ',',
                                         'BaseAmount' + IntToStr(I));

                    For I := 1 to SDRateList.Count do
                      Write(ExtractFile, ',SDCode' + IntToStr(I) + ',',
                                         'SDDesc' + IntToStr(I) + ',',
                                         'SDExtension' + IntToStr(I) + ',',
                                         'SD_CMFlag' + IntToStr(I) + ',',
                                         'SDValue' + IntToStr(I) + ',',
                                         'SDTax' + IntToStr(I));

                    For I := 1 to SpecialFeeRateList.Count do
                      Write(ExtractFile, ',FeeDesc' + IntToStr(I) + ',',
                                         'FeeTax' + IntToStr(I));

                    Writeln(ExtractFile);

                  end;  {If PrintToExcel}

              (*AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);  *)

                {FXX07022002-1: Need the reduction logic here too.}

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
                          ReportPrinter.ScaleY := 70;
(*                          ReportPrinter.SectionLeft := 1.5;*)
                          ReportFiler.ScaleX := 90;
                          ReportFiler.ScaleY := 70;
                          NumLinesPerPage := 66;
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

              TotalsOnly := False;
              PrintingCancelled := False;
              ProgressDialog.Start(GetRecordCount(BLHeaderTaxTable) * 2, True, True);
              GlblPreviewPrint := False;

                {First generate the text file for the report.
                 Then either send to the printer or to the screen.}

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
                else ReportPrinter.Execute;

              ProgressDialog.Finish;

                {CHG01182000-3: Allow them to choose a different name or copy right away.}

              ShowReportDialog('XROLL.RPT', TextFiler.FileName, True);

            end;  {If not Quit}

          {CHG09131999-1: Print the STAR certification report.}

        If ((not (Quit or PrintingCancelled)) and
            CollectionHasSchoolTax and
            (MessageDlg('Do you want to print the STAR Reimbursement Application Form?', mtConfirmation, [mbYes, mbNo], 0) =
             idYes) and
            PrintDialog.Execute)
          then
            begin
              AssignPrinterSettings(PrintDialog, STARReportPrinter, STARReportFiler, [ptBoth], True, Quit);

                {FXX08232004-1(2.08.0.08302004): Need the reduction logic here too.}

              If (STARReportPrinter.Orientation = poLandscape)
                then
                  begin
                    If ReducedSize
                      then
                        begin
                          STARReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
                          STARReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                          STARReportPrinter.Orientation := poLandscape;
                          STARReportFiler.Orientation := poLandscape;

                          If STARReportPrinter.SupportDuplex
                            then STARReportPrinter.Duplex := DuplexType;

                           {FXX08242005-1(2.9.2.4): Reduce the size of the STAR report when printed on letter size.}

                          STARReportPrinter.ScaleX := 80;
                          STARReportPrinter.ScaleY := 75;
(*                          STARReportPrinter.SectionLeft := 1.5;*)
                          STARReportFiler.ScaleX := 80;
                          STARReportFiler.ScaleY := 75;
                          NumLinesPerPage := 66;
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

              TotalsOnly := False;
              PrintingCancelled := False;
              ProgressDialog.Start(GetRecordCount(BLExemptionTaxTable), True, True);
              GlblPreviewPrint := False;

                {First generate the text file for the report.
                 Then either send to the printer or to the screen.}

                {FXX07221998-1: So that more than one person can run the report
                                at once, use a time based name first and then
                                rename.}

              STARTextFiler.FileName := GetPrintFileName(Self.Caption, True);
              STARTextFiler.FileName := TextFileName;

                {FXX01211998-1: Need to set the LastPage property so that
                                long rolls aren't a problem.}

              STARTextFiler.LastPage := 30000;

              STARTextFiler.Execute;

                {If they want to see it on the screen, start the preview.}

                {If they want to see it on the screen, start the preview.}

              If PrintDialog.PrintToFile
                then
                  begin
                    GlblPreviewPrint := True;
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    STARReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      PreviewForm.FilePreview.ZoomFactor := 130;

                      STARReportFiler.Execute;
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
                else STARReportPrinter.Execute;

              ProgressDialog.Finish;

                {CHG01182000-3: Allow them to choose a different name or copy right away.}

              ShowReportDialog('XROLSTAR.RPT', TextFiler.FileName, True);

            end;

          {CHG09152004-1(2.8.0.11): Extract the tax roll to Excel.}

        If (ExtractToExcel and
            WholeRollPrinted)
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If ExtractToExcel}

          {FXX04231998-13: Don't print "There were 0 bills printed if this
                           is a totals run.}

        If not (Quit or PrintingCancelled)
          then MessageDlg('The tax roll was printed sucessfully.' + #13 +
                          'There were ' + IntToStr(NumBillsPrinted) + ' bills in this roll printing.',
                          mtInformation, [mbOK], 0)
          else MessageDlg('The tax roll was NOT printed successfully.',
                          mtError, [mbOK], 0);

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
        FreeTList(BillControlDetailList, SizeOf(ControlDetailRecord));

        FreeTList(SDExtCategoryList, SizeOf(SDExtCategoryRecord));

          {FXX01191998-2: Freeing the wrong record size.}
          {FXX01211998-2: Was freeing the RollSectionDescList 2x.}

        FreeTList(RollSectionDescList, SizeOf(CodeRecord));
        FreeTList(EXCodeDescList, SizeOf(CodeRecord));
        FreeTList(SDCodeDescList, SizeOf(CodeRecord));
        FreeTList(SwisCodeDescList, SizeOf(CodeRecord));
        FreeTList(SchoolCodeDescList, SizeOf(CodeRecord));
        FreeTList(SDExtCodeDescList, SizeOf(CodeRecord));
        FreeTList(PropertyClassDescList, SizeOf(CodeRecord));

        CL1List.Free;
        CL2List.Free;
        CL3List.Free;
        CL4List.Free;
        CL5List.Free;
        CL6List.Free;
        CL7List.Free;

        ResetPrinter(ReportPrinter);

      end;  {If OKToStartPrinting}

  AccountNumberList.Free;

end;  {PrintButtonClick}

{====================================================================}
Procedure TBillPrintRollForm.ReportPrint(Sender: TObject);

{FXX01051998-1: Go through the text file generated by text filer and
                either print to screen or to printer.}

var
  RollTextFile : TextFile;

begin
  AssignFile(RollTextFile, TextFiler.FileName);
  Reset(RollTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, RollTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(RollTextFile);

end;  {ReportFilerPrint}

{===================================================================}
Function TBillPrintRollForm.ParcelShouldBePrinted : Boolean;

{We should print this parcel if
  1. They are not showing just roll totals.
  2. It is in a roll section that they want to see.}

begin
  Result := True;

    {If they only want totals, don't print the parcel.}

  If TotalsOnly
    then Result := False;

    {Make sure that the roll section is not blank.}

  If (Deblank(BLHeaderTaxTable.FieldByName('RollSection').Text) = '')
    then Result := False;

    {FXX08131998-6: If this is roll section 9 with no bill amount - don't print it.}

  with BLHeaderTaxTable do
    If ((Deblank(FieldByName('RollSection').Text) = '9') and
        (Roundoff(FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
      then Result := False;

  with BLHeaderTaxTable do
    If (PrintOnlyNonZeroBills and
        _Compare(FieldByName('TotalTaxOwed').AsFloat, 0, coEqual))
      then Result := False;

end;  {ParcelShouldBePrinted}

{===================================================================}
{=====================  PRINTING LOGIC  ============================}
{===================================================================}
Procedure TBillPrintRollForm.AddRecordToExtractFile(var ExtractFile : TextFile;
                                                        BLHeaderTaxTable : TTable;
                                                        GnTaxList,
                                                        ExTaxList,
                                                        SDTaxList,
                                                        SpTaxList : TList);

{CHG09152004-1(2.8.0.11): Extract the tax roll to Excel.}

var
  NAddrArray : NameAddrArray;
  I, ExemptionsExtracted,
  BaseTaxesExtracted: Integer;
  TempSDValue,
  TempPayAmountField, TempPayDateField,
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

      Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        (FieldByName('HstdLandVal').AsFloat +
                                                         FieldByName('NonhstdLandVal').AsFloat))),
                         FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        (FieldByName('HstdTotalVal').AsFloat +
                                                         FieldByName('NonhstdTotalVal').AsFloat))),
                         FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        FullMarketValue)),
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        FieldByName('TotalTaxOwed').AsFloat)));

        {Individual payment amounts.}

      For I := 1 to CollectionLookupTable.FieldByName('NumberOfPayments').AsInteger do
        begin
          TempPayAmountField := 'TaxPayment' + IntToStr(I);
          TempPayDateField := 'PayDate' + IntToStr(I);

          Write(ExtractFile, FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                            FieldByName(TempPayAmountField).AsFloat)),
                             FormatExtractField(CollectionLookupTable.FieldByName(TempPayDateField).Text));

        end;  {For I := 1 to CollectionLookupTable.FieldByName('NumberOfPayments').AsInteger do}

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

  BaseTaxesExtracted := 0;
  For I := 0 to (GnTaxList.Count - 1) do
    with GeneralTaxPtr(GnTaxList[I])^ do
      begin
        Write(ExtractFile, FormatExtractField(Description),
                           FormatExtractField(FormatFloat(NoDecimalDisplay, TaxableVal)),
                           FormatExtractField(FormatFloat(DecimalDisplay, TaxAmount)));

        BaseTaxesExtracted := BaseTaxesExtracted + 1;

      end;  {with GeneralTaxPtr(GnTaxList[I])^ do}

  For I := (BaseTaxesExtracted + 1) to NumberGeneralRates do
    Write(ExtractFile, FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''));

    {Now write special districts.}

  For I := 0 to (SDTaxList.Count - 1) do
    with SDistTaxPtr(SDTaxList[I])^ do
      begin
        If (ExtCode = 'TO')
          then TempSDValue := FormatFloat(NoDecimalDisplay,
                                          SDValue)
          else TempSDValue := FormatFloat(DecimalEditDisplay,
                                          SDValue);

        Write(ExtractFile, FormatExtractField(SDistCode),
                           FormatExtractField(Description),
                           FormatExtractField(ExtCode),
                           FormatExtractField(CMFlag),
                           FormatExtractField(TempSDValue),
                           FormatExtractField(FormatFloat(DecimalEditDisplay, SDAmount)));

      end;  {For I := 0 to (SDTaxList.Count - 1) do}

  For I := 0 to (SpTaxList.Count - 1) do
    with SPFeeTaxPtr(SPTaxList[I])^ do
      Write(ExtractFile, FormatExtractField(Description),
                         FormatExtractField(FormatFloat(DecimalEditDisplay, SPAmount)));

  Writeln(ExtractFile);

end;  {AddRecordToExtractFile}

{===============================================================}
Procedure TBillPrintRollForm.PrintSelectedRollSections(    Sender : TObject;
                                                           SelectedRollSections : TStringList;
                                                           AccountNumberToPrint : String;
                                                       var FirstPageOfReport : Boolean;
                                                       var TotalTax : Extended);


{FXX01061998-2: Print only the roll sections they choose and print
                sections 7 and 9 seperately.}

var
  HeaderPrinted,
  ParcelSubheaderPrinted,
  FirstTimeThrough,
  ParcelPrintedThisPage,  {Has a parcel been printed on this page?}
  TotalsPrinted, Quit, DoneWithReport : Boolean;
  SwisSBLKey : String;
  CurrentRollSection : String;
  CurrentSwisCode, CurrentSchoolCode : String;
  TotalAssessedVal : Comp;
  LineTypeList : TStringList;  {What type of line is each tax line?}

  PageNo, LineNo, MaxLines : Integer;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  NumPrinted, NumPrintedThisRollSection,
  NumPrintedThisSwisCode, NumPrintedThisSchoolCode : LongInt;
  TempStr : String;
  TaxThisSchool : Extended;

begin
  TotalTax := 0;
  NumPrinted := 0;
  NumPrintedThisRollSection := 0;
  NumPrintedThisSwisCode := 0;
  NumPrintedThisSchoolCode := 0;
  LineNo := 1;
  PageNo := 1;
  DoneWithReport := False;
  Quit := False;
  ParcelSubheaderPrinted := False;
  FirstTimeThrough := True;
  HeaderPrinted := False;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;
  ParcelPrintedThisPage := False;
  LineTypeList := TStringList.Create;

  LastSwisCode := '';
  LastSchoolCode := '';
  LastRollSection := '';

    {FXX06251998-11: Start at the beginning for each pass.}

  BLHeaderTaxTable.First;

    {FXX06251998-6: Change 'SECTION/BLOCK/LOT SEQUENCE' to "Parcel ID" order.}

  case IndexRadioGroup.ItemIndex of
    0: SequenceStr := 'PARCEL ID ORDER';
    1: SequenceStr := 'OWNER NAME ORDER';
    2: SequenceStr := 'LEGAL ADDRESS ORDER';
  end;  {case IndexRadioGroup.ItemIndex of}

  with Sender as TBaseReport do
    begin
      Bold := False;

      repeat
        Application.ProcessMessages;

        If FirstTimeThrough
          then FirstTimeThrough := False
          else BLHeaderTaxTable.Next;

          {If we have printed all the records, then we are done.}

        PrintingCancelled := ProgressDialog.Cancelled;

        If (BLHeaderTaxTable.EOF or
            (Quit or PrintingCancelled))
          then DoneWithReport := True;

        If CollectionHasSchoolTax
          then ProgressDialog.UserLabelCaption := 'Printing for School: ' + CurrentSchoolCode +
                                                  '  Roll Sect: ' + CurrentRollSection
          else ProgressDialog.UserLabelCaption := 'Printing for Swis: ' + CurrentSwisCode +
                                                  '  Roll Sect: ' + CurrentRollSection;

        with BLHeaderTaxTable do
          case IndexRadioGroup.ItemIndex of
            0 : ProgressDialog.Update(Self, ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));
            1 : ProgressDialog.Update(Self, FieldByName('Name1').Text);
            2 : ProgressDialog.Update(Self, FieldByName('LegalAddress').Text);
            3 : ProgressDialog.Update(Self, FieldByName('AccountNumber').Text);

          end;  {case IndexRadioGroup.ItemIndex of}

        with BLHeaderTaxTable do
          begin
            CurrentSwisCode := FieldByName('SwisCode').Text;
            CurrentSchoolCode := FieldByName('SchoolDistCode').Text;
            CurrentRollSection := FieldByName('RollSection').Text;

          end;  {with BLHeaderTaxTable do}

        TempStr := ConvertSBLOnlyToDashDot(BLHeaderTaxTable.FieldByName('SBLKey').Text);

        with BLHeaderTaxTable do
          SwisSBLKey := Take(6, FieldByName('SwisCode').Text) +
                        Take(20, FieldByName('SBLKey').Text);

        TotalsPrinted := False;

          {Should we print the roll section totals?}
          {FXX01021998-8: We need to pass in the sd code table to determine
                          how many extensions each SD code has.}
          {FXX04241998-1: Only load the roll sections that we want in this section
                          of the roll.}
          {FXX07011998-8: Don't forget to check change in swis or school (if this
                          is a school billing).}

        If (ShowRollSectionTotalsCheckBox.Checked and
            (DoneWithReport or
             (((Deblank(LastRollSection) <> '') and
               (LastRollSection <> CurrentRollSection)) or
              (CollectionHasSchoolTax and
               (LastSchoolCode <> CurrentSchoolCode)) or
              (LastSwisCode <> CurrentSwisCode))) and
            (NumPrintedThisRollSection > 0) and
            (SelectedRollSections.IndexOf(LastRollSection) > - 1)) {Only print tots for selected rs}
          then
            begin
              TotalsPrinted := True;

                {FXX06261998-1: If the roll header for the 1st page has not been
                                printed yet, then print it.}
                {FXX06301998-1: Fix roll printing problem where r.s. that do not apply
                                are getting totals breaks.}

              If not HeaderPrinted
                then
                  begin
                    HeaderPrinted := True;

                    If FirstPageOfReport
                      then
                        begin
                          PrintRollHeader(Sender, 'X', LastSchoolCode, LastSwisCode,
                                          LastRollSection,
                                          CollectionLookupTable.FieldByName('CollectionType').Text,
                                          RollPrintingYear, AssessmentYearCtlTable,
                                          SchoolCodeDescList,
                                          SwisCodeDescList, SequenceStr, PageNo, LineNo);
                          FirstPageOfReport := False;
                        end
                      else StartNewPage(Sender, 'X', LastSchoolCode, LastSwisCode,
                                        LastRollSection,
                                        CollectionLookupTable.FieldByName('CollectionType').Text,
                                        RollPrintingYear, AssessmentYearCtlTable,
                                        SchoolCodeDescList,
                                        SwisCodeDescList, SequenceStr, PageNo, LineNo);

                     {Set up the tabs for the info.}

                    ClearTabs;

                  end;  {If not HeaderPrinted}

              PrintSectionTotals(Sender, 'X', 'R',
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

              NumPrintedThisRollSection := 0;

            end;  {If (DoneWithReport or ...}

           {FXX06301998-1: Fix roll printing problem where r.s. that do not apply
                           are getting totals breaks.}
           {FXX07011998-8: Also check for changes in school code if this is a school
                           billing.}

                {Should we print the swis totals?}

        If ((NumPrintedThisSwisCode > 0) and
            (DoneWithReport or
             ((Deblank(LastSwisCode) <> '') and
              (LastSwisCode <> CurrentSwisCode)) or
             (CollectionHasSchoolTax and
              (LastSchoolCode <> CurrentSchoolCode))))
          then
            begin
              TotalsPrinted := True;

              PrintSectionTotals(Sender, 'X', 'S',
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

              NumPrintedThisSwisCode := 0;

            end;  {If (DoneWithReport or ...}

           {FXX06301998-1: Fix roll printing problem where r.s. that do not apply
                           are getting totals breaks.}
          {Should we print the School totals?}

        If (CollectionHasSchoolTax and
            (NumPrintedThisSchoolCode > 0) and
            (DoneWithReport or
             ((Deblank(LastSchoolCode) <> '') and
              (LastSchoolCode <> CurrentSchoolCode))))
          then
            begin
              TotalsPrinted := True;

                {FXX06251998-2: Only print the 4 char swis (county\town) for school
                                totals.}

              TotalTax := PrintSectionTotals(Sender, 'X', 'C',
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

              NumPrintedThisSchoolCode := 0;

            end;  {If (DoneWithReport or ...}

           {FXX06301998-1: Fix roll printing problem where r.s. that do not apply
                           are getting totals breaks.}
          {Should we print the grand totals?}
          {FXX06301998-9: Don't print municipal totals for school collection.}

        If ((NumPrinted > 0) and
            (CollectionType <> 'SC') and
            DoneWithReport)
          then
            begin
              TotalsPrinted := True;

                {FXX04291998-2: Only send in the first 4 chars of the swis code
                                for grand totals.}
                {FXX04291998-4: Figure out the total tax for these roll sections.}

              TaxThisSchool := PrintSectionTotals(Sender, 'X', 'G',
                                  LastRollSection,
                                  Take(2, LastSwisCode), LastSchoolCode,
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

                {If there is a school tax line in this billing, don't
                 include the amount - will be double counted.}

              If CollectionHasSchoolTax
                then TaxThisSchool := 0;

              TotalTax := TotalTax + TaxThisSchool;

            end;  {If (DoneWithReport or ...}

        If ((Deblank(LastRollSection) = '') or
            (SelectedRollSections.IndexOf(BLHeaderTaxTable.FieldByName('RollSection').Text) > -1))
          then
            with BLHeaderTaxTable do
              begin
                LastSwisCode := FieldByName('SwisCode').Text;
                LastSchoolCode := FieldByName('SchoolDistCode').Text;
                LastRollSection := FieldByName('RollSection').Text;

              end;  {with BLHeaderTaxTable do}

          {If we printed any totals, reset the variables we use to
           keep track of section breaks and go to a new page.}

        If TotalsPrinted
          then
            begin
                {Reset the "last" variables.}

              LastSwisCode := CurrentSwisCode;
              LastSchoolCode := CurrentSchoolCode;
              If ((Deblank(LastRollSection) = '') and
                  (SelectedRollSections.IndexOf(CurrentRollSection) <> -1))
                then LastRollSection := CurrentRollSection;

             ParcelSubheaderPrinted := False;
             ParcelPrintedThisPage := False;

             If not DoneWithReport
               then HeaderPrinted := False;

            end;  {If TotalsPrinted}

        If ((not DoneWithReport) and
            (SelectedRollSections.IndexOf(CurrentRollSection) > - 1))
          then
            begin
              NumPrinted := NumPrinted + 1;
              NumPrintedThisRollSection := NumPrintedThisRollSection + 1;
              NumPrintedThisSwisCode := NumPrintedThisSwisCode + 1;
              NumPrintedThisSchoolCode := NumPrintedThisSchoolCode + 1;
            end;

          {FXX06261998-4: If the last roll section is blank and this is a roll section
                          that we want, then set the alst roll section so that the
                          header prints OK.}

        If ((Deblank(LastRollSection) = '') and
            (SelectedRollSections.IndexOf(CurrentRollSection) <> -1))
          then LastRollSection := CurrentRollSection;

           {load general, sdist, spcl fee, and exmpt info into tlists}
           {FXX04281998-7: Don't go into this section if only printing totals.}
           {FXX06181998-4: Looking at show rs check box, not totals only.}

        If ((not DoneWithReport) and
            (not TotalsOnly) and
            (SelectedRollSections.IndexOf(CurrentRollSection) > -1) and
            (_Compare(AccountNumberToPrint, coBlank) or
             _Compare(BLHeaderTaxTable.FieldByName('AccountNumber').AsString, AccountNumberToPrint, coStartsWith)))
          then
            begin
               {FXX06261998-1: If the roll header for the 1st page has not been
                               printed yet, then print it.}

              If not HeaderPrinted
                then
                  begin
                    HeaderPrinted := True;

                      {FXX06301998-2: Start a new page instead of just printing
                                      the roll header.}
                      {FXX07011998-9: On the first page of the report, print just the
                                      roll header so 1st page is not blank.}
                      {FXX07021998-1: Print the current variables instead of the lasts.}

                    If FirstPageOfReport
                      then
                        begin
                          PrintRollHeader(Sender, 'X', CurrentSchoolCode, CurrentSwisCode,
                                 CurrentRollSection,
                                 CollectionLookupTable.FieldByName('CollectionType').Text,
                                 RollPrintingYear,
                                 AssessmentYearCtlTable,
                                 SchoolCodeDescList,
                                 SwisCodeDescList, SequenceStr,
                                 PageNo, LineNo);
                          FirstPageOfReport := False;
                        end
                      else StartNewPage(Sender, 'X', CurrentSchoolCode, CurrentSwisCode,
                                 CurrentRollSection,
                                 CollectionLookupTable.FieldByName('CollectionType').Text,
                                 RollPrintingYear,
                                 AssessmentYearCtlTable,
                                 SchoolCodeDescList,
                                 SwisCodeDescList, SequenceStr,
                                 PageNo, LineNo);

                    FirstPageOfReport := False;

                     {Set up the tabs for the info.}

                    ClearTabs;

                  end;  {If not HeaderPrinted}

                 {clear out print stringlists for this parcel}
              CL1List.Clear;
              CL2List.Clear;
              CL3List.Clear;
              CL4List.Clear;
              CL5List.Clear;
              CL6List.Clear;
              CL7List.Clear;

                 {clear out tax details for this parcel}
                 {FXX04241998-4: Need to clear lists with ClearTList proc
                                 to avoid memory probs.}

              ClearTList(GnTaxList, SizeOf(GeneralTaxRecord));
              ClearTList(SDTaxList, SizeOf(SDistTaxRecord));
              ClearTList(SpTaxList, SizeOf(SPFeeTaxRecord));
              ClearTList(ExTaxList, SizeOf(ExemptTaxRecord));

                {FXX01111998-2: I forgot to clear the line type list
                                each time.}

              LineTypeList.Clear;

              LoadTaxesForParcel(SwisSBLKey, BLGeneralTaxTable,
                                 BLSpecialDistrictTaxTable,
                                 BLExemptionTaxTable,
                                 BLSpecialFeeTaxTable,
                                 SDCodeDescList, EXCodeDescList,
                                 GeneralRateList, SDRateList,
                                 SpecialFeeRateList, GnTaxList,
                                 SDTaxList, SpTaxList, ExTaxList, Quit);

                {CHG09152004-1(2.8.0.11): Extract the tax roll to Excel.}

              If ExtractToExcel
                then AddRecordToExtractFile(ExtractFile,
                                            BLHeaderTaxTable,
                                            GnTaxList,
                                            ExTaxList, SDTaxList, SpTaxList);

                {FXX01061998-4: Print the prior owner - pass in ass year ctl tbl.}
                {CHG04032000-1: Pass in the swis code table to show full value.}

              FillInPropertyInformation(BLHeaderTaxTable, AssessmentYearCtlTable,
                                        SwisCodeTable, ParcelTable, SwisSBLKey, 'X',
                                        PropertyClassDescList, SchoolCodeDescList,
                                        ExTaxList, CL1List, CL2List, CL3List,
                                        CL4List, CL5List, CL6List, CL7List,
                                        LineTypeList, False, PrintAdditionalLots, False, False);

                {NOW FILL IN REST OF COLUMNS FOR THIS PARCEL}

                {column 4, tax descriptions}
                {Column 5, taxable vals}
                {column 6, sd flgs or null}
                {column 7, billno, amts}

                  {QQQ...FORMAT EXEMPTIONS, WITH COUNTY AND TOWN AMTS,
                     AND WHAT ABOUT SCHOOL FORMAT, AND WHAT IF MULT
                     EXEMPTIONS??}

               {FXX12231997-3: If this is a school exemption don't show town ex
                               amount and vice-versa, so we need to pass
                               in the collection type.}

                {FXX01061998-8: If class, do seperately.}

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
                    FillInExemptions(CL4List, CL5List, CL6List, CL7List,
                                     LineTypeList, ' ', CollectionType,
                                     ExTaxList);
                    FillInGeneralTaxes(CL2List, CL4List, CL5List, CL6List, CL7List,
                                       LineTypeList, 'X', ' ', GNTaxList);

        {CHG08212002-2: Add the STAR savings to the tax roll.}

(*      If ((RollType = 'X') and
          (Roundoff(FieldByName('STARSavings').AsFloat, 2) > 0))
        then CL1List.Add('STAR Savings: ' +
                         FormatFloat(CurrencyDecimalDisplay,
                                     FieldByName('STARSavings').AsFloat));*)

                       {FXX12231997-4: Figure out the SD exemption amount so that
                                       we can print it.}

                    with BLHeaderTaxTable do
                      TotalAssessedVal := FieldByName('HstdTotalVal').AsFloat +
                                          FieldByName('NonhstdTotalVal').AsFloat;

                    FillInSDTaxes(CL4List, CL5List, CL6List, CL7List,
                                  LineTypeList, 'X', TotalAssessedVal,
                                  SuppressSDExtensions, SDExtCategoryList,
                                  SDTaxList, '');
                    FillInSPFeeTaxes(CL4List, CL5List, CL6List, CL7List,
                                     LineTypeList, SPTaxList);

                  end;  {If (BLHeaderTaxTable.FieldByName ...}

                 {figure out max lines to print from longest column then
                  add lines so all string lists of equal length}

              MaxLines := GetAndSetMaxLines(CL1List, CL2List, CL3List, CL4List,
                                            CL5List, CL6List, CL7List, LineTypeList);

                 {allow 3 lines for tot tax, date due, and half payment amts
                  plus 4th line for  line of  *********}

                {FXX06261998-3: Test LinesLeft for page break.}
                {FXX01131998-1: Was forgetting to add in the asterisk line, 2 lines for
                                tax amounts, and one blank line.}
                {FXX07062002-1: Set the lines per page iby code rather than
                                relying on ReportPrinter.}

              with Sender as TBaseReport do
                If (((NumLinesPerPage - LineNo) - (MaxLines + 2)) < LinesAtBottom)
                   then
                     begin
                         {First print an ending line.}

                       PrintEndingParcelLine(Sender);

                       StartNewPage(Sender, 'X', LastSchoolCode, LastSwisCode,
                                    LastRollSection,
                                    CollectionLookupTable.FieldByName('CollectionType').Text,
                                    RollPrintingYear,
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
                           PrintParcelPageSubheader(Sender, 'X',
                                                    CollectionType, LineNo);
                           ParcelSubheaderPrinted := True;
                         end;

                      PrintOneParcel(Sender, 'X', BLHeaderTaxTable,
                                     CollectionLookupTable, MaxLines, CL1List, CL2List,
                                     CL3List, CL4List, CL5List, CL6List, CL7List,
                                     LineTypeList, EXTaxList.Count, LineNo);
                      NumBillsPrinted := NumBillsPrinted + 1;

                    end;  {If ParcelShouldBePrinted}

            end;  {If not DoneWithReport}

      until DoneWithReport;

      If ((NumLinesPerPage - 6) < LinesAtBottom)
         then StartNewPage(Sender, 'X', LastSchoolCode, LastSwisCode,
                           LastRollSection,
                           CollectionLookupTable.FieldByName('CollectionType').Text,
                           RollPrintingYear,
                           AssessmentYearCtlTable,
                           SchoolCodeDescList,
                           SwisCodeDescList, SequenceStr,
                           PageNo, LineNo);

    end;  {with Sender as TBaseReport do}

    {FXX04241998-5: Need to free the tax TLists.}

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

end;  {PrintSelectedRollSections}

{===============================================================}
Procedure TBillPrintRollForm.TextFilerPrint(Sender: TObject);

var
  SelectedRollSections : TStringList;
  I, AccountNumberIndex : Integer;
  TaxTheseRollSections : Extended;
  RollSectionsStr, AccountNumberToPrint : String;
  FirstPageOfReport : Boolean;
  TotalSTARSavings : Double;

begin
  AccountNumberToPrint := '';
  AccountNumberIndex := 0;

  If GroupByAccountNumber
    then
      try
        AccountNumberToPrint := AccountNumberList[AccountNumberIndex];
      except
        AccountNumberToPrint := '';
      end;

(*  while (_Compare(AccountNumberIndex, 0, coEqual) or
         _Compare(AccountNumberToPrint, coNotBlank) and
         (not ProgressDialog.Cancelled)) do
    begin *)
      GlblCurrentTabNo := 1;
      GlblCurrentLinePos := 1;
      ProgressDialog.Start(GetRecordCount(BLHeaderTaxTable) * 2, True, True);

(*      If GroupByAccountNumber
        then ProgressDialog.UserLabelCaption := 'Account = ' + AccountNumberToPrint; *)

      with Sender as TBaseReport do
        begin
          NumColsPerPage := 130;

          BLHeaderTaxTable.First;

          with BLHeaderTaxTable do
            begin
              LastSwisCode := FieldByName('SwisCode').Text;
              LastSchoolCode := FieldByName('SchoolDistCode').Text;
              LastRollSection := FieldByName('RollSection').Text;

            end;  {with BLHeaderTaxTable do}

        end;  {with Sender as TBaseReport do}

      RollPrintingYear := TaxRollYearEdit.Text;
      SelectedRollSections := TStringList.Create;
      FirstPageOfReport := True;

        {FXX06291998-3: Show totals rs 1-8 and then rs 1-9.}

      TotalTaxRS1_8 := 0;
      TotalTaxRS9 := 0;

         {First print 1,3,5,6,8 if they want to see them.}
         {FXX11051998-5: Include rs 7 in totals.}

      with RollSectionListBox do
        For I := 0 to (Items.Count - 1) do
          If (Selected[I] and
              (not (Items[I][1] in ['9'])))
            then SelectedRollSections.Add(Items[I][1]);  {Add everything they select
                                                          other than 9.}

      TaxTheseRollSections := 0;

      If (SelectedRollSections.Count > 0)
        then PrintSelectedRollSections(Sender, SelectedRollSections, AccountNumberToPrint,
                                       FirstPageOfReport, TaxTheseRollSections);

      TotalTaxRS1_8 := TaxTheseRollSections;

        {Print roll section 9 if they selected it.}

      SelectedRollSections.Clear;
      TaxTheseRollSections := 0;

      with RollSectionListBox do
        For I := 0 to (Items.Count - 1) do
          If (Selected[I] and
              (Items[I][1] in ['9']))
            then SelectedRollSections.Add(Items[I][1]);

        {FXX04291998-4: Figure out the total tax for these roll sections.}

      If ((SelectedRollSections.Count > 0) and
          (not ProgressDialog.Cancelled))
        then PrintSelectedRollSections(Sender, SelectedRollSections, AccountNumberToPrint,
                                       FirstPageOfReport, TaxTheseRollSections);

      TotalTaxRS9 := TaxTheseRollSections;

        {FXX04291998-5: Print the grand overall total.}

      with Sender as TBaseReport do
        begin
          ClearTabs;
          SetTab(TL1, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Roll Section}
          SetTab(TL9, pjRight, TL9W, 0, BOXLINENONE, 0);   {Total tax}

          SelectedRollSections.Clear;

          with RollSectionListBox do
            For I := 0 to (Items.Count - 1) do
              If Selected[I]
                then SelectedRollSections.Add(Items[I][1]);  {Add everything they select}

          RollSectionsStr := '';

            {FXX06291998-3: Show totals rs 1-8 and then rs 1-9.}

          For I := 0 to (SelectedRollSections.Count - 1) do
            If (SelectedRollSections[I] <> '9')
              then
                begin
                  RollSectionsStr := RollSectionsStr + SelectedRollSections[I];
                  If (I < (SelectedRollSections.Count - 1))
                    then RollSectionsStr := RollSectionsStr + ',';

                end;  {For I := 0 to (SelectedRollSections.Count - 1) do}

          BLGeneralTaxTable.CancelRange;
          TotalSTARSavings := SumTableColumn(BLGeneralTaxTable, 'BasicSTARSavings') +
                              SumTableColumn(BLGeneralTaxTable, 'EnhancedSTARSavings');

          TotalTaxRS1_8 := TotalTaxRS1_8 - TotalSTARSavings;

          Println('');
          Println(#9 + 'GRAND TOTAL RS ' + RollSectionsStr + ': ' +
                  #9 + FormatFloat(DecimalDisplay, TotalTaxRS1_8));

            {Now print the overall total including rs 9.}
            {FXX06301998-4: Forgot to include rs 1-8 in overall total.}

          If (SelectedRollSections.IndexOf('9') <> -1)
            then
              begin
                Println('');
                Println(#9 + 'GRAND TOTAL RS 1-9: ' +
                        #9 + FormatFloat(DecimalDisplay, (TotalTaxRS1_8 + TotalTaxRS9)));
              end;

        end;  {with Sender as TBaseReport do}

      SelectedRollSections.Free;

(*      If GroupByAccountNumber
        then
          begin
            Inc(AccountNumberIndex);
            try
              AccountNumberToPrint := AccountNumberList[AccountNumberIndex];
            except
              AccountNumberToPrint := '';
            end;

            with Sender as TBaseReport do
              NewPage;

          end;  {If GroupByAccountNumber}

    end;  {while (_Compare(AccountNumberIndex, 0, coEqual) or ...} *)

end;  {ReportFilerPrint}

{===============================================================}
Procedure TBillPrintRollForm.STARTextFilerPrint(Sender: TObject);

var
  HstdEnhancedCount, HstdBasicCount,
  NonhstdEnhancedCount, NonhstdBasicCount : LongInt;
  BasicSTARAmount, EnhancedSTARAmount,
  HstdEnhancedTotal, HstdBasicTotal,
  NonhstdEnhancedTotal, NonhstdBasicTotal : Comp;
  HstdReimbursementAmount, NonhstdReimbursementAmount,
  HstdTaxRate, NonhstdTaxRate : Extended;
  _SchoolCode, SchoolName, CurrentTaxYear, NextTaxYear : String;
  Done, FirstTimeThrough : Boolean;
  Year, Month, Day : Word;
  I : Integer;
  flSTAR : TextFile;

begin
  (*AssignFile(flSTAR, 'c:\temp\EXSTAR.txt');
  Rewrite(flSTAR); *)
  DecodeDate(Date, Year, Month, Day);
  CurrentTaxYear := IntToStr(Year);
  NextTaxYear := IntToStr(Year + 1);

  HstdTaxRate := 0;
  NonhstdTaxRate := 0;

  For I := 0 to (GeneralRateList.Count - 1) do
    with GeneralRatePointer(GeneralRateList[I])^ do
      If ApplySTAR
        then
          begin
            HstdTaxRate := HomesteadRate;

            If GlblMunicipalityUsesTwoTaxRates
              then NonhstdTaxRate := NonhomesteadRate
              else NonhstdTaxRate := HomesteadRate;

            _SchoolCode := SchoolCode;

          end;  {If ApplySTAR}

  SchoolName := Trim(GetDescriptionFromList(_SchoolCode, SchoolCodeDescList));

  EXCodeTable.IndexName := 'BYEXCODE';

  FindKeyOld(EXCodeTable, ['EXCode'], [BasicSTARExemptionCode]);
  BasicSTARAmount := EXCodeTable.FieldByName('FixedAmount').AsFloat;
  FindKeyOld(EXCodeTable, ['EXCode'], [EnhancedSTARExemptionCode]);
  EnhancedSTARAmount := EXCodeTable.FieldByName('FixedAmount').AsFloat;

  Done := False;
  FirstTimeThrough := True;
  BLExemptionTaxTable.CancelRange;
  BLExemptionTaxTable.First;

  ProgressDialog.UserLabelCaption := 'Creating STAR Reimbursement Form.';

  HstdEnhancedCount := 0;
  HstdEnhancedTotal := 0;
  HstdBasicCount := 0;
  HstdBasicTotal := 0;
  NonhstdEnhancedCount := 0;
  NonhstdEnhancedTotal := 0;
  NonhstdBasicCount := 0;
  NonhstdBasicTotal := 0;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else BLExemptionTaxTable.Next;

    If BLExemptionTaxTable.EOF
      then Done := True;

    If not Done
      then
        with BLExemptionTaxTable do
          begin
            ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
            Application.ProcessMessages;

            If (FieldByName('EXCode').Text = BasicSTARExemptionCode)
              then
                If (FieldByName('HomesteadCode').Text = 'N')
                  then
                    begin
                      NonhstdBasicCount := NonhstdBasicCount + 1;
                      NonhstdBasicTotal := NonhstdBasicTotal + FieldByName('SchoolAmount').AsFloat;
                    end
                  else
                    begin
                      HstdBasicCount := HstdBasicCount + 1;
                      HstdBasicTotal := HstdBasicTotal + FieldByName('SchoolAmount').AsFloat;
                      (*Writeln(flSTAR, FieldByName('SwisSBLKey').AsString, ',', FieldByName('EXCode').AsString, ',', FieldByName('SchoolAmount').AsInteger); *)
                    end;

            If (FieldByName('EXCode').Text = EnhancedSTARExemptionCode)
              then
                If (FieldByName('HomesteadCode').Text = 'N')
                  then
                    begin
                      NonhstdEnhancedCount := NonhstdEnhancedCount + 1;
                      NonhstdEnhancedTotal := NonhstdEnhancedTotal + FieldByName('SchoolAmount').AsFloat;
                    end
                  else
                    begin
                      HstdEnhancedCount := HstdEnhancedCount + 1;
                      HstdEnhancedTotal := HstdEnhancedTotal + FieldByName('SchoolAmount').AsFloat;
                      (*Writeln(flSTAR, FieldByName('SwisSBLKey').AsString, ',', FieldByName('EXCode').AsString, ',', FieldByName('SchoolAmount').AsInteger); *)
                    end;

          end;  {If not Done}

    until Done;

  (*CloseFile(flSTAR); *)

  (*HstdReimbursementAmount := Roundoff((HstdBasicTotal + HstdEnhancedTotal) / 1000 * HstdTaxRate, 2);
  NonhstdReimbursementAmount := Roundoff((NonhstdBasicTotal + NonhstdEnhancedTotal) / 1000 * NonhstdTaxRate, 2); *)

  Done := False;
  FirstTimeThrough := True;
  HstdReimbursementAmount := 0;
  NonhstdReimbursementAmount := 0;
(*  AssignFile(flSTAR, 'c:\temp\TaxSTAR.txt');
  Rewrite(flSTAR); *)

  BLGeneralTaxTable.CancelRange;
  BLGeneralTaxTable.First;
  ProgressDialog.Start(BLGeneralTaxTable.RecordCount, True, True);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else BLGeneralTaxTable.Next;

    If BLGeneralTaxTable.EOF
      then Done := True;

    If not Done
      then
        with BLGeneralTaxTable do
          begin
            ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
            Application.ProcessMessages;

            (*If (_Compare(FieldByName('BasicSTARSavings').AsFloat, 0, coGreaterThan) or
                _Compare(FieldByName('EnhancedSTARSavings').AsFloat, 0, coGreaterThan))
            then Writeln(flSTAR, FieldByName('SwisSBLKey').AsString, ',',
                                 FormatFloat(DecimalEditDisplay, FieldByName('BasicSTARSavings').AsFloat), ',',
                                 FormatFloat(DecimalEditDisplay, FieldByName('EnhancedSTARSavings').AsFloat)); *)

            If (FieldByName('HomesteadCode').Text = 'N')
            then NonhstdReimbursementAmount := NonhstdReimbursementAmount +
                                               FieldByName('BasicSTARSavings').AsFloat +
                                               FieldByName('EnhancedSTARSavings').AsFloat
            else HstdReimbursementAmount := HstdReimbursementAmount +
                                            FieldByName('BasicSTARSavings').AsFloat +
                                            FieldByName('EnhancedSTARSavings').AsFloat;

          end;  {If not Done}

    until Done;

 (*  CloseFile(flSTAR); *)

  with Sender as TBaseReport do
    begin
      Println('');
      Println(Center('STATE OF NEW YORK', 132));
      Println(Center('STAR REIMBURSEMENT APPLICATION FORM', 132));
      Println(Center('SCHOOL TAX LEVY FOR THE ' + CurrentTaxYear + '-' + NextTaxYear +
                     ' FISCAL YEAR', 132));

      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 2.5, 0, BoxLineNone, 0);  {School dist code}
      SetTab(9.0, pjRight, 3.0, 0, BoxLineNone, 0); {School dist name}

      Println(#9 + 'SCHOOL DISTRICT CODE: ' + _SchoolCode +
              #9 + 'SCHOOL DISTRICT NAME: ' + SchoolName);

      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.5, 0, BoxLineNone, 0);  {Municipal}
      SetTab(1.9, pjCenter, 0.1, 0, BoxLineNone, 0); {Class}
      SetTab(2.1, pjCenter, 1.0, 0, BoxLineNone, 0); {# Basics}
      SetTab(3.2, pjCenter, 1.1, 0, BoxLineNone, 0); {Tot amt of Basics}
      SetTab(4.4, pjCenter, 1.0, 0, BoxLineNone, 0);  {Amt of 1 basic}
      SetTab(5.5, pjCenter, 1.0, 0, BoxLineNone, 0);  {# enh}
      SetTab(6.6, pjCenter, 1.1, 0, BoxLineNone, 0);  {Tot amt of enh}
      SetTab(7.8, pjCenter, 1.0, 0, BoxLineNone, 0);  {Amt of 1 enh}
      SetTab(8.9, pjCenter, 1.1, 0, BoxLineNone, 0);  {Tot STAR}
      SetTab(10.1, pjCenter, 1.2, 0, BoxLineNone, 0);  {Tax rate}
      SetTab(11.4, pjCenter, 1.4, 0, BoxLineNone, 0);  {STAR Reimbursement}

      Println(#9 + #9 +
              #9 + '(1)' +
              #9 + '(2)' +
              #9 + '(3)' +
              #9 + '(4)' +
              #9 + '(5)' +
              #9 + '(6)' +
              #9 + '(7)' +
              #9 + '(8)' +
              #9 + '(9)');

      Println(#9 + #9 + #9 + #9 + #9 + #9 + #9 +
              #9 + 'CERTIFIED');

      Println(#9 + #9 + 'C' +
              #9 + #9 +
              #9 + 'CERTIFIED' +
              #9 + 'NUMBER' +
              #9 + 'ENHANCED' +
              #9 + 'ENHANCED');

      Println(#9 + #9 + 'L' +
              #9 + 'NUMBER' +
              #9 + 'BASIC STAR' +
              #9 + 'BASIC STAR' +
              #9 + 'OF' +
              #9 + 'STAR' +
              #9 + 'STAR' +
              #9 + 'TOTAL STAR' +
              #9 + 'TAX RATE');

      Println(#9 + #9 + 'A' +
              #9 + 'OF' +
              #9 + 'EXEMPT' +
              #9 + 'EXEMPT' +
              #9 + 'ENHANCED' +
              #9 + 'EXEMPT' +
              #9 + 'EXEMPT' +
              #9 + 'EXEMPT' +
              #9 + 'PER $1000 OF' +
              #9 + 'STAR');

      Println(#9 + #9 + 'S' +
              #9 + 'BASIC STAR' +
              #9 + 'ASSESSED' +
              #9 + 'ASSESSED' +
              #9 + 'STAR' +
              #9 + 'ASSESSED' +
              #9 + 'ASSESSED' +
              #9 + 'ASSESSED' +
              #9 + 'ASSESSED' +
              #9 + 'REIMBURSEMENT');

      Println(#9 + 'MUNICIPALITY' +
              #9 + 'S' +
              #9 + 'EXEMPTIONS' +
              #9 + 'VALUE' +
              #9 + 'VALUE' +
              #9 + 'EXEMPTIONS' +
              #9 + 'VALUE' +
              #9 + 'VALUE' +
              #9 + 'VALUE' +
              #9 + 'VALUE*' +
              #9 + 'AMOUNT');

      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.5, 0, BoxLineNone, 0);  {Municipal}
      SetTab(1.9, pjCenter, 0.1, 0, BoxLineNone, 0); {Class}
      SetTab(2.1, pjRight, 1.0, 0, BoxLineNone, 0); {# Basics}
      SetTab(3.2, pjRight, 1.1, 0, BoxLineNone, 0); {Tot amt of Basics}
      SetTab(4.4, pjRight, 1.0, 0, BoxLineNone, 0);  {Amt of 1 basic}
      SetTab(5.5, pjRight, 1.0, 0, BoxLineNone, 0);  {# enh}
      SetTab(6.6, pjRight, 1.1, 0, BoxLineNone, 0);  {Tot amt of enh}
      SetTab(7.8, pjRight, 1.0, 0, BoxLineNone, 0);  {Amt of 1 enh}
      SetTab(8.9, pjRight, 1.1, 0, BoxLineNone, 0);  {Tot STAR}
      SetTab(10.1, pjRight, 1.2, 0, BoxLineNone, 0);  {Tax rate}
      SetTab(11.4, pjRight, 1.4, 0, BoxLineNone, 0);  {STAR Reimbursement}

      Print(#9 + Take(15, GlblMunicipalityName));

      If GlblMunicipalityIsClassified
        then Print(#9 + 'H')
        else Print(#9 + ' ');

      Println(#9 + IntToStr(HstdBasicCount) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, HstdBasicTotal) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, BasicSTARAmount) +
              #9 + IntToStr(HstdEnhancedCount) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, HstdEnhancedTotal) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, EnhancedSTARAmount) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, (HstdBasicTotal + HstdEnhancedTotal)) +
              #9 + FormatFloat(ExtendedDecimalDisplay, HstdTaxRate) +
              #9 + FormatFloat(CurrencyDecimalDisplay, HstdReimbursementAmount));

      If GlblMunicipalityIsClassified
        then Println(#9 + Take(15, GlblMunicipalityName) +
                     #9 + 'N' +
                     #9 + IntToStr(NonhstdBasicCount) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign, NonhstdBasicTotal) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign, BasicSTARAmount) +
                     #9 + IntToStr(NonhstdEnhancedCount) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign, NonhstdEnhancedTotal) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign, EnhancedSTARAmount) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign, (NonhstdBasicTotal + NonhstdEnhancedTotal)) +
                     #9 + FormatFloat(ExtendedDecimalDisplay, NonhstdTaxRate) +
                     #9 + FormatFloat(CurrencyDecimalDisplay, NonhstdReimbursementAmount));

      Println('');

      Println(#9 + 'DISTRICT TOTALS' +
              #9 +
              #9 + IntToStr(HstdBasicCount + NonhstdBasicCount) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, HstdBasicTotal +
                                                            NonhstdBasicTotal) +
              #9 +
              #9 + IntToStr(HstdEnhancedCount + NonhstdEnhancedCount) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, HstdEnhancedTotal +
                                                            NonhstdEnhancedTotal) +
              #9 +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, (HstdBasicTotal + HstdEnhancedTotal) +
                                                           (NonhstdBasicTotal + NonhstdEnhancedTotal)) +
              #9 + FormatFloat(ExtendedDecimalDisplay, NonhstdTaxRate) +
              #9 + FormatFloat(CurrencyDecimalDisplay, (HstdReimbursementAmount +
                                                        NonhstdReimbursementAmount)));

      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 10.5, 0, BoxLineNone, 0);  {Municipal}

      Println(#9 + 'TOTAL TAX LEVY:  ' +
              FormatFloat(CurrencyDecimalDisplay, (TotalTaxRS1_8 + TotalTaxRS9 +
                                                   HstdReimbursementAmount +
                                                   NonhstdReimbursementAmount)));

      Println('');

      Println(#9 + '(10) I HEREBY CERTIFY THAT THE INFORMATION CONTAINED IN THIS REPORT CONSTITUTES A TRUE' +
                   ' STATEMENT OF FACT:');

      Println('');


      ClearTabs;
      SetTab(0.6, pjLeft, 10.5, 0, BoxLineNone, 0);  {Municipal}

      Println(#9 + '(11) NAME(PLEASE PRINT)___________________________');

      Println('');
      Println('');
      Println('');

      Println(#9 + ' _____________________________________________TITLE___________________________________');
      Println(#9 + '        SIGNATURE OF STATE AID DESIGNEE');

      Println('');
      Println('');

      Println(#9 + 'DATE_____________________________________    TELEPHONE NUMBER' +
                   '_______________________ FAX NUMBER_______________________');

      Println('');
      Println(#9 + '*EXCLUDES LIBRARY TAX');

    end;  {with Sender as TBaseReport do}

end;  {STARTextFilerPrint}

{===============================================================}
Procedure TBillPrintRollForm.STARReportPrint(Sender: TObject);

var
  RollTextFile : TextFile;

begin
  AssignFile(RollTextFile, STARTextFiler.FileName);
  Reset(RollTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, RollTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(RollTextFile);

end;  {STARReportPrint}

{===============================================================}
Procedure TBillPrintRollForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TBillPrintRollForm.FormClose(    Sender: TObject;
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