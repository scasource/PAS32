unit Coop_TaxRoll;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Btrvdlg, wwdblook, Mask,types,pastypes,
  Glblcnst, Gauges,Printrng, RPMemo, RPDBUtil, RPDefine, (*Progress, *)RPTXFilr,
  RPFPrint, RPreview;

type
  Tfm_CooperativeRollPrint = class(TForm)
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
    SwisCodeTable: TTable;
    DatePrintedEdit: TMaskEdit;
    Label27: TLabel;
    EXCodeTable: TTable;
    Label6: TLabel;
    RollHeaderTitleEdit: TEdit;
    PrintFullMarketValueCheckBox: TCheckBox;
    ParcelTable: TTable;
    PrintAdditionalLotsCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
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
    rg_PrintOrder: TRadioGroup;
    cb_TotalsOnly: TCheckBox;
    cbxSuppressTaxAmounts: TCheckBox;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
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
    CollectionHasSchoolTax, PrintAdditionalLots, ExtractToExcel : Boolean;
    ExtractFile : TextFile;
    Duplexing, SuppressSDExtensions,
    bSuppressTaxAmounts, GroupByAccountNumber : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function ParcelShouldBePrinted : Boolean;
    {We should print this parcel if
      1. They are not showing just roll totals.
      2. It is in a roll section that they want to see.}

    Procedure AddRecordToExtractFile(var ExtractFile : TextFile;
                                         BLHeaderTaxTable : TTable;
                                         BaseTaxList,
                                         ExemptionTaxList,
                                         SpecialDistrictTaxList,
                                         SpecialFeeTaxList : TList;
                                         STARSavings : Double);

    Procedure PrintSelectedRollSections(    Sender : TObject;
                                            SelectedRollSections : TStringList;
                                        var FirstPageOfReport : Boolean;
                                        var TotalTax : Extended;
                                            lst_TotalsByCooperative : TList);
    {FXX01061998-2: Print only the roll sections they choose and print
                   sections 7 and 9 seperately.}

    Procedure PrintTotalsByBuilding(Sender : TObject;
                                    lst_TotalsByCooperative : TList);

  end;

  rec_TotalsByCooperative = record
    BuildingID : String;
    Amount : Double;
  end;

  ptr_TotalsByCooperative = ^rec_TotalsByCooperative;


implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview,
     Prog, RptDialg,
     UtilBill,  {Billing specific utilities.}
     Utrtotpt;  {Section totals print unit}

const
  poParcelID = 0;
  poAccountNumber = 1;

{$R *.DFM}

{========================================================}
Procedure Tfm_CooperativeRollPrint.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure Tfm_CooperativeRollPrint.InitializeForm;

var
  I : Integer;

begin
  UnitName := 'Coop_TaxRoll';  {mmm}

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
Procedure Tfm_CooperativeRollPrint.HeaderInformationExit(Sender: TObject);

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
Procedure Tfm_CooperativeRollPrint.FormKeyPress(    Sender: TObject;
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
Procedure Tfm_CooperativeRollPrint.PrintButtonClick(Sender: TObject);

var
  TextFileName, NewFileName,
  TaxRollYear, SpreadsheetFileName,
  HeaderFileName, GeneralFileName,
  EXFileName, SDFileName, SpecialFeeFileName,
  GeneralTotFileName, SDTotFileName,
  SchoolTotFileName, EXTotFileName,
  SpecialFeeTotFileName, IndexName : String;

  Found, OKToStartPrinting, Quit : Boolean;
  I, CollectionNum : Integer;
  UniformPercentOfValue, EqualizationRate : Real;

begin
  Duplexing := False;
  ExtractToExcel := ExtractToExcelCheckBox.Checked;
  OKToStartPrinting := True;
  GlblCurrentTabNo := 0;
  TotalsOnly := cb_TotalsOnly.Checked;
  bSuppressTaxAmounts := cbxSuppressTaxAmounts.Checked;

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

    {FXX12171998-7: Make sure that the dates in the assessment year control
                    file are filled in and the uniform % of value.}
    {FXX07191999-6: Display all info for verification before printing.}

  If OKToStartPrinting
    then
      begin
        PrintOrder := rg_PrintOrder.ItemIndex;
        OKToStartPrinting := VerifyDatesAndPercentOfValueFilledIn(AssessmentYearCtlTable,
                                                                   SwisCodeTable,
                                                                   UniformPercentOfValue,
                                                                   EqualizationRate);

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

        SetRollTabs(GlblReportReprintLeftMargin);

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], True, Quit);

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

        case PrintOrder of
          poParcelID : BLHeaderTaxTable.IndexName := 'BYSCHOOL_SWIS_RS_SBL';

          poAccountNumber :
            begin
              IndexName := 'BYACCOUNTNUMBER';

              If _Compare(BLHeaderTaxTable.IndexDefs.IndexOf(IndexName), -1, coEqual)
                then
                  try
                    BLHeaderTaxTable.AddIndex(IndexName,
                                              'AccountNumber',
                                              [ixExpression]);
                  except
                  end;

              BLHeaderTaxTable.IndexName := IndexName;

            end;  {poAccountNumber}

          end;  {case PrintOrder of}

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

              If (ReportPrinter.Orientation = poLandscape)
                then
                  begin
                    If (MessageDlg('Do you want to print on letter size paper?',
                                   mtConfirmation, [mbYes, mbNo], 0) = idYes)
                      then
                        begin
                          Duplexing := True;
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
                                then ReportPrinter.Duplex := dupVertical
                                else ReportPrinter.Duplex := dupHorizontal;

                          ReportPrinter.ScaleX := 77;
                          ReportPrinter.ScaleY := 70;
                          ReportPrinter.SectionLeft := 1.5;
                          ReportFiler.ScaleX := 77;
                          ReportFiler.ScaleY := 70;
                          ReportFiler.SectionLeft := 1.5;
                          NumLinesPerPage := 66;
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

              PrintingCancelled := False;
              GlblPreviewPrint := False;

              If ExtractToExcel
                then
                  begin
                    SpreadsheetFileName := GetPrintFileName('CoopTaxRoll', True);
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
                                       'TotalTaxOwed,',
                                       'STARSavings');

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


              TextFileName := GetPrintFileName(Self.Caption + '123', True);
              TextFiler.FileName := TextFileName;

                {FXX01211998-1: Need to set the LastPage property so that
                                long rolls aren't a problem.}

              TextFiler.LastPage := 30000;

              TextFiler.Execute;
              ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

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

        If ExtractToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If ExtractToExcel}

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

end;  {PrintButtonClick}

{====================================================================}
Procedure Tfm_CooperativeRollPrint.ReportPrint(Sender: TObject);

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
Function Tfm_CooperativeRollPrint.ParcelShouldBePrinted : Boolean;

{We should print this parcel if
  1. They are not showing just roll totals.
  2. It is in a roll section that they want to see.}

begin
  Result := True;

    {If they only want totals, don't print the parcel.}

  If TotalsOnly
    then Result := False;

    {Make sure that the roll section is not blank.}

  If (Deblank(BLHeaderTaxTable.FieldByName('RollSection').AsString) = '')
    then Result := False;

    {FXX08131998-6: If this is roll section 9 with no bill amount - don't print it.}

  with BLHeaderTaxTable do
    If ((Deblank(FieldByName('RollSection').AsString) = '9') and
        (Roundoff(FieldByName('TotalTaxOwed').AsFloat, 2) = 0))
      then Result := False;

end;  {ParcelShouldBePrinted}

{===================================================================}
{=====================  PRINTING LOGIC  ============================}
{===================================================================}
Procedure Tfm_CooperativeRollPrint.AddRecordToExtractFile(var ExtractFile : TextFile;
                                                              BLHeaderTaxTable : TTable;
                                                              BaseTaxList,
                                                              ExemptionTaxList,
                                                              SpecialDistrictTaxList,
                                                              SpecialFeeTaxList : TList;
                                                              STARSavings : Double);

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
      Write(ExtractFile, FieldByName('SwisCode').AsString,
                         '''' +
                         FormatExtractField(FieldByName('SBLKey').AsString) +
                         '''',
                         FormatExtractField(ConvertSBLOnlyToDashDot(FieldByName('SBLKey').AsString)),
                         FormatExtractField(FieldByName('CheckDigit').AsString));

      GetNameAddress(BLHeaderTaxTable, NAddrArray);

      For I := 1 to 6 do
        Write(ExtractFile, FormatExtractField(NAddrArray[I]));

      PropertyClassDescription := UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').AsString,
                                                                   PropertyClassDescList));

      SchoolName := UpcaseStr(GetDescriptionFromList(FieldByName('SchoolDistCode').AsString,
                                                     SchoolCodeDescList));

      FindKeyOld(SwisCodeTable, ['SwisCode'], [FieldByName('SwisCode').AsString]);
      FullMarketValue := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                           FieldByName('NonhstdTotalVal').AsFloat),
                                          SwisCodeTable,
                                          FieldByName('PropertyClassCode').AsString,
                                          ' ', True);

      Write(ExtractFile, FormatExtractField(GetLegalAddressFromTable(BLHeaderTaxTable)),
                         FormatExtractField(FieldByName('PropertyClassCode').AsString),
                         FormatExtractField(PropertyClassDescription),
                         FormatExtractField(FieldByName('SchoolDistCode').AsString),
                         FormatExtractField(SchoolName),
                         FormatExtractField(''),  {Old ID not used for now.}
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        (FieldByName('HstdAcreage').AsFloat +
                                                         FieldByName('NonhstdAcreage').AsFloat))),
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        FieldByName('Frontage').AsFloat)),
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        FieldByName('Depth').AsFloat)),
                         FormatExtractField(FieldByName('GridCordEast').AsString),
                         FormatExtractField(FieldByName('GridCordNorth').AsString),
                         FormatExtractField(FieldByName('DeedBook').AsString),
                         FormatExtractField(FieldByName('DeedPage').AsString),
                         FormatExtractField(FieldByName('BankCode').AsString),
                         FormatExtractField(FieldByName('HomesteadCode').AsString),
                         FormatExtractField(FieldByName('AccountNumber').AsString),
                         FormatExtractField(FieldByName('PropDescr1').AsString),
                         FormatExtractField(FieldByName('PropDescr2').AsString),
                         FormatExtractField(FieldByName('PropDescr3').AsString));

      Write(ExtractFile, FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        (FieldByName('HstdLandVal').AsFloat +
                                                         FieldByName('NonhstdLandVal').AsFloat))),
                         FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        (FieldByName('HstdTotalVal').AsFloat +
                                                         FieldByName('NonhstdTotalVal').AsFloat))),
                         FormatExtractField(FormatFloat(NoDecimalDisplay,
                                                        FullMarketValue)),
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        FieldByName('TotalTaxOwed').AsFloat)),
                         FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                        STARSavings)));

        {Individual payment amounts.}

      For I := 1 to CollectionLookupTable.FieldByName('NumberOfPayments').AsInteger do
        begin
          TempPayAmountField := 'TaxPayment' + IntToStr(I);
          TempPayDateField := 'PayDate' + IntToStr(I);

          Write(ExtractFile, FormatExtractField(FormatFloat(DecimalEditDisplay,
                                                            FieldByName(TempPayAmountField).AsFloat)),
                             FormatExtractField(CollectionLookupTable.FieldByName(TempPayDateField).AsString));

        end;  {For I := 1 to CollectionLookupTable.FieldByName('NumberOfPayments').AsInteger do}

    end;  {with BLHeaderTaxTable do}

    {Now do the exemptions.}

  ExemptionsExtracted := 0;

  For I := 0 to (ExemptionTaxList.Count - 1) do
    with ExemptTaxPtr(ExemptionTaxList[I])^ do
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

      end;  {with ExemptTaxRecord(ExemptionTaxList)^ do}

  For I := (ExemptionsExtracted + 1) to 8 do
    Write(ExtractFile, FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''));

  BaseTaxesExtracted := 0;
  For I := 0 to (BaseTaxList.Count - 1) do
    with GeneralTaxPtr(BaseTaxList[I])^ do
      begin
        Write(ExtractFile, FormatExtractField(Description),
                           FormatExtractField(FormatFloat(NoDecimalDisplay, TaxableVal)),
                           FormatExtractField(FormatFloat(DecimalDisplay, TaxAmount)));

        BaseTaxesExtracted := BaseTaxesExtracted + 1;

      end;  {with GeneralTaxPtr(BaseTaxList[I])^ do}

  For I := (BaseTaxesExtracted + 1) to NumberGeneralRates do
    Write(ExtractFile, FormatExtractField(''),
                       FormatExtractField(''),
                       FormatExtractField(''));

    {Now write special districts.}

  For I := 0 to (SpecialDistrictTaxList.Count - 1) do
    with SDistTaxPtr(SpecialDistrictTaxList[I])^ do
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

      end;  {For I := 0 to (SpecialDistrictTaxList.Count - 1) do}

  For I := 0 to (SpecialFeeTaxList.Count - 1) do
    with SPFeeTaxPtr(SpecialFeeTaxList[I])^ do
      Write(ExtractFile, FormatExtractField(Description),
                         FormatExtractField(FormatFloat(DecimalEditDisplay, SPAmount)));

  Writeln(ExtractFile);

end;  {AddRecordToExtractFile}

{===============================================================}
Function GetBaseTaxTotalItemFromList(CooperativeBaseTaxTotalsList : TList;
                                     _PrintOrder : Integer) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (CooperativeBaseTaxTotalsList.Count - 1) do
    with GeneralTotPtr(CooperativeBaseTaxTotalsList[I])^ do
      If _Compare(PrintOrder, _PrintOrder, coEqual)
        then Result := I;

end;  {GetBaseTaxTotalItemFromList}

{===============================================================}
Function GetSpecialDistrictTaxItemFromList(CooperativeSpecialDistrictTaxTotalsList : TList;
                                           _SDistCode : String;
                                           _ExtCode : String;
                                           _CMFlag : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (CooperativeSpecialDistrictTaxTotalsList.Count - 1) do
    with SDistTotPtr(CooperativeSpecialDistrictTaxTotalsList[I])^ do
      If (_Compare(SDCode, _SDistCode, coEqual) and
          _Compare(ExtCode, _ExtCode, coEqual) and
          _Compare(CMFlag, _CMFlag, coEqual))
        then Result := I;

end;  {GetSpecialDistrictTaxItemFromList}

{===============================================================}
Function GetExemptionTotalItemFromList(CooperativeExemptionTotalsList : TList;
                                       _EXCode : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (CooperativeExemptionTotalsList.Count - 1) do
    with ExemptTotPtr(CooperativeExemptionTotalsList[I])^ do
      If _Compare(EXCode, _EXCode, coEqual)
        then Result := I;

end;  {GetExemptionTotalItemFromList}

{===============================================================}
Procedure UpdateCooperativeTotals(    BLHeaderTaxTable : TTable;
                                      CooperativeBaseTaxTotalsList : TList;
                                      CooperativeSpecialDistrictTaxTotalsList : TList;
                                      CooperativeExemptionTotalsList : TList;
                                      BaseTaxList : TList;
                                      SpecialDistrictTaxList : TList;
                                      ExemptionList : TList;
                                  var _STARSavings : Double);

var
  I, ItemIndex : Integer;
  CooperativeBaseTaxTotalPtr : GeneralTotPtr;
  CooperativeSpecialDistrictTaxTotalPtr : SDistTotPtr;
  CooperativeExemptionTotalPtr : ExemptTotPtr;
  AssessedValue, _STARAmount : LongInt;

begin
  _STARAmount := 0;
  _STARSavings := 0;

  For I := 0 to (ExemptionList.Count - 1) do
    begin
      ItemIndex := GetExemptionTotalItemFromList(CooperativeExemptionTotalsList,
                                                 ExemptTaxPtr(ExemptionList[I])^.EXCode);

      If _Compare(ItemIndex, -1, coEqual)
        then
          begin
            New(CooperativeExemptionTotalPtr);

            with CooperativeExemptionTotalPtr^ do
              begin
                EXCode := ExemptTaxPtr(ExemptionList[I])^.EXCode;
                HomesteadCode := ExemptTaxPtr(ExemptionList[I])^.HomesteadCode;
                PartCt := 0;
                ParcelCt := 0;
                CountyExAmt := 0;
                TownExAmt := 0;
                SchoolExAmt := 0;
                VillageExAmt := 0;

                CooperativeExemptionTotalsList.Add(CooperativeExemptionTotalPtr);

                ItemIndex := GetExemptionTotalItemFromList(CooperativeExemptionTotalsList, EXCode);

              end;  {with CooperativeExemptionTotalPtr^ do}

          end;  {If _Compare(ItemIndex, -1, coEqual)}

      with ExemptTotPtr(CooperativeExemptionTotalsList[ItemIndex])^ do
        begin
          ParcelCt := ParcelCt + 1;
          CountyExAmt := CountyExAmt + ExemptTaxPtr(ExemptionList[I])^.CountyAmount;
          TownExAmt := TownExAmt + ExemptTaxPtr(ExemptionList[I])^.TownAmount;
          SchoolExAmt := SchoolExAmt + ExemptTaxPtr(ExemptionList[I])^.SchoolAmount;
          VillageExAmt := VillageExAmt + ExemptTaxPtr(ExemptionList[I])^.VillageAmount;

        end;  {with ExemptTaxPtr(CooperativeExemptionTotalsList[ItemIndex])^ do}

      with ExemptTaxPtr(ExemptionList[I])^ do
        If ExemptionIsSTAR(EXCode)
          then _STARAmount := _STARAmount + Trunc(SchoolAmount);

    end;  {For I := 0 to (ExemptionTaxList.Count - 1) do}

  For I := 0 to (BaseTaxList.Count - 1) do
    begin
      ItemIndex := GetBaseTaxTotalItemFromList(CooperativeBaseTaxTotalsList,
                                               GeneralTaxPtr(BaseTaxList[I])^.PrintOrder);

      If _Compare(ItemIndex, -1, coEqual)
        then
          begin
            New(CooperativeBaseTaxTotalPtr);

            with CooperativeBaseTaxTotalPtr^, BLHeaderTaxTable do
              begin
                SwisCode := FieldByName('SwisCode').AsString;
                RollSection := FieldByName('RollSection').AsString;
                HomesteadCode := GeneralTaxPtr(BaseTaxList[I])^.HomesteadCode;
                PrintOrder := GeneralTaxPtr(BaseTaxList[I])^.PrintOrder;
                PartCt := 0;
                ParcelCt := 0;
                LandAv := 0;
                TotalAV := 0;
                ExemptAmt := 0;
                TaxableVal := 0;
                STARAmount := 0;
                TaxableValAfterSTAR := 0;
                TotalTax := 0;
                STARSavings := 0;

              end;  {with CooperativeBaseTaxPtr^, BLHeaderTaxTable do}

            CooperativeBaseTaxTotalsList.Add(CooperativeBaseTaxTotalPtr);

            ItemIndex := GetBaseTaxTotalItemFromList(CooperativeBaseTaxTotalsList,
                                                     CooperativeBaseTaxTotalPtr^.PrintOrder);

          end;  {If _Compare(ItemIndex, -1, coEqual)}

      with GeneralTotPtr(CooperativeBaseTaxTotalsList[ItemIndex])^, BLHeaderTaxTable do
        begin
          AssessedValue := FieldByName('HstdTotalVal').AsInteger + FieldByName('NonHstdTotalVal').AsInteger;
          ParcelCt := ParcelCt + 1;
          LandAV := LandAV + FieldByName('HstdLandVal').AsInteger + FieldByName('NonHstdLandVal').AsInteger;
          TotalAV := TotalAV + AssessedValue;
          ExemptAmt := ExemptAmt + (AssessedValue - GeneralTaxPtr(BaseTaxList[I])^.TaxableVal - _STARAmount);
          TaxableVal := TaxableVal + (GeneralTaxPtr(BaseTaxList[I])^.TaxableVal + _STARAmount);
          STARAmount := STARAmount + _STARAmount;
          TaxableValAfterSTAR := TaxableValAfterSTAR + GeneralTaxPtr(BaseTaxList[I])^.TaxableVal;
          TotalTax := TotalTax + GeneralTaxPtr(BaseTaxList[I])^.TaxAmount;
          STARSavings := STARSavings + GeneralTaxPtr(BaseTaxList[I])^.STARSavings;
          _STARSavings := _STARSavings + GeneralTaxPtr(BaseTaxList[I])^.STARSavings;

        end;  {with GeneralTaxPtr(CooperativeBaseTaxPtr[ItemIndex])^ do}

    end;  {For I := 0 to (BaseTaxList.Count - 1) do}

  For I := 0 to (SpecialDistrictTaxList.Count - 1) do
    begin
      with SDistTaxPtr(SpecialDistrictTaxList[I])^ do
        ItemIndex := GetSpecialDistrictTaxItemFromList(CooperativeSpecialDistrictTaxTotalsList,
                                                       SDistCode, ExtCode, CMFlag);

      If _Compare(ItemIndex, -1, coEqual)
        then
          begin
            New(CooperativeSpecialDistrictTaxTotalPtr);

            with CooperativeSpecialDistrictTaxTotalPtr^ do
              begin
                SwisCode := BLHeaderTaxTable.FieldByName('SwisCode').AsString;
                RollSection := BLHeaderTaxTable.FieldByName('RollSection').AsString;
                SchoolCode := '';
                SDCode := SDistTaxPtr(SpecialDistrictTaxList[I])^.SDistCode;
                ExtCode := SDistTaxPtr(SpecialDistrictTaxList[I])^.ExtCode;
                CMFlag := SDistTaxPtr(SpecialDistrictTaxList[I])^.CMFlag;
                HomesteadCode := SDistTaxPtr(SpecialDistrictTaxList[I])^.HomesteadCode;
                Value := 0;
                ADValue := 0;
                TaxableVal := 0;
                ExemptAmt := 0;
                TotalTax := 0;

                CooperativeSpecialDistrictTaxTotalsList.Add(CooperativeSpecialDistrictTaxTotalPtr);

                ItemIndex := GetSpecialDistrictTaxItemFromList(CooperativeSpecialDistrictTaxTotalsList,
                                                               SDCode, ExtCode, CMFlag);

              end;  {with CooperativeSpecialDistrictTaxTotalPtr^ do}

          end;  {If _Compare(ItemIndex, -1, coEqual)}

      with SDistTotPtr(CooperativeSpecialDistrictTaxTotalsList[ItemIndex])^ do
        begin
          Value := Value + SDistTaxPtr(SpecialDistrictTaxList[I])^.SDValue;
          ADValue := 0;
          TaxableVal := 0;
          ExemptAmt := 0;
          TotalTax := TotalTax + SDistTaxPtr(SpecialDistrictTaxList[I])^.SDAmount;;

        end;  {with SDistTaxPtr(CooperativeSpecialDistrictTaxTotalsList[ItemIndex])^ do}

    end;  {with SDistTaxPtr(BaseTaxList[I])^ do}

end;  {UpdateCooperativeTotals}

{===============================================================}
Procedure Tfm_CooperativeRollPrint.PrintSelectedRollSections(    Sender : TObject;
                                                                 SelectedRollSections : TStringList;
                                                             var FirstPageOfReport : Boolean;
                                                             var TotalTax : Extended;
                                                                 lst_TotalsByCooperative : TList);


{FXX01061998-2: Print only the roll sections they choose and print
                sections 7 and 9 seperately.}

var
  HeaderPrinted, ParcelSubheaderPrinted,
  ParcelPrintedThisPage, FirstTimeThrough, Quit, Done : Boolean;
  CurrentSchoolCode, CurrentSwisCode, CurrentRollSection,
  SwisSBLKey, CurrentCooperative, LastCooperative : String;
  cRollType : Char;
  TotalAssessedVal : Comp;
  LineTypeList : TStringList;  {What type of line is each tax line?}
  TaxAmount, STARSavings : Double;

  PageNo, LineNo, MaxLines : Integer;
  CooperativeBaseTaxTotalsList,
  CooperativeSpecialDistrictTaxTotalsList,
  CooperativeExemptionTotalsList,
  CooperativeSchoolTotalsList,
  CooperativeSpecialFeeTotalsList,
  BaseTaxList, SpecialDistrictTaxList, SpecialFeeTaxList, ExemptionTaxList : TList;
  ptrTotalsByCooperative : ptr_TotalsByCooperative;

begin
  TotalTax := 0;
  LineNo := 1;
  PageNo := 1;
  Done := False;
  Quit := False;
  ParcelSubheaderPrinted := False;
  FirstTimeThrough := True;
  HeaderPrinted := False;
  ParcelPrintedThisPage := False;

    {FXX08202009-1(2.20.1.15): The tax amounts were not printing out.}

  If bSuppressTaxAmounts
    then cRollType := 'F'
    else cRollType := 'X';

  BaseTaxList := TList.Create;
  SpecialDistrictTaxList := TList.Create;
  SpecialFeeTaxList := TList.Create;
  ExemptionTaxList := TList.Create;
  LineTypeList := TStringList.Create;

  CooperativeBaseTaxTotalsList := TList.Create;
  CooperativeSpecialDistrictTaxTotalsList := TList.Create;
  CooperativeExemptionTotalsList := TList.Create;
  CooperativeSchoolTotalsList := TList.Create;
  CooperativeSpecialFeeTotalsList := TList.Create;

  case PrintOrder of
    poParcelID : SequenceStr := 'PARCEL ID ORDER';
    poAccountNumber : SequenceStr := 'ACCOUNT NUMBER ORDER';
  end;

  with Sender as TBaseReport, BLHeaderTaxTable do
    begin
      Bold := False;
      First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else Next;

        If EOF
          then Done := True;

        case PrintOrder of
          poParcelID : ProgressDialog.Update(Self, ConvertSBLOnlyToDashDot(FieldByName('SBLKey').AsString));
          poAccountNumber : ProgressDialog.Update(Self, FieldByName('AccountNumber').AsString);
        end;
        Application.ProcessMessages;

          {FXX08192007-1(2.11.3.4)[D972]: GetCooperativeBase needs the sublot for Eastchester.}

        SwisSBLKey := FieldByName('SwisCode').AsString + FieldByName('SBLKey').AsString;
        CurrentCooperative := GetCooperativeBase(FieldByName('SBLKey').AsString,
                                                 FieldByName('AccountNumber').AsString,
                                                 _Compare(PrintOrder, poParcelID, coEqual),
                                                 GlblCoopBaseSBLHasSubblock);

        If (Done or
            (_Compare(CurrentCooperative, LastCooperative, coNotEqual) and
             _Compare(LastCooperative, coNotBlank)))
          then
            begin
(*              with Sender as TBaseReport do
                begin
                  PrintEndingParcelLine(Sender);
                  ClearTabs;
                  SetTab(0.1, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Cooperative}
                  Println(#9 + 'Cooperative: ' + LastCooperative);
                  Println('');

                end;  {with Sender as TBaseReport do} *)

              TaxAmount := PrintSectionTotals_FromTotalsLists(Sender, cRollType, 'S',
                                                              LastRollSection, LastSwisCode, LastSchoolCode,
                                                              ConvertSBLOnlyToDashDot(LastCooperative),
                                                              GeneralRateList, SDRateList, SpecialFeeRateList,
                                                              CooperativeSpecialDistrictTaxTotalsList,
                                                              CooperativeExemptionTotalsList,
                                                              CooperativeSchoolTotalsList,
                                                              CooperativeBaseTaxTotalsList,
                                                              CooperativeSpecialFeeTotalsList,
                                                              CollectionType, RollPrintingYear,
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

                {CHG08192007-1(2.11.3.4)[F666]: Add a totals summary by building at the end of the coop tax roll.}

              New(ptrTotalsByCooperative);
              ptrTotalsByCooperative^.BuildingID := LastCooperative;
              ptrTotalsByCooperative^.Amount := TaxAmount;
              lst_TotalsByCooperative.Add(ptrTotalsByCooperative);

              ClearTList(CooperativeBaseTaxTotalsList, SizeOf(GeneralTaxRecord));
              ClearTList(CooperativeSpecialDistrictTaxTotalsList, SizeOf(SDistTaxRecord));
              ClearTList(CooperativeExemptionTotalsList, SizeOf(ExemptTaxRecord));

              If not Done
                then
                  begin
                    If not TotalsOnly
                      then
                        with Sender as TBaseReport do
                          begin
                            NewPage;

                              {CHG08192007-2(2.11.3.4)[F667]: If they are duplexing, make sure they start each building on an odd page.}

                            If (Duplexing and
                                Even(CurrentPage))
                              then NewPage;

                          end;  {with Sender as TBaseReport do}

                    LineNo := 1;
                    HeaderPrinted := False;
                    ParcelPrintedThisPage := False;

                  end;  {If not Done}

            end;  {If (Done or ...}

        If not Done
          then
            begin
              CurrentSwisCode := FieldByName('SwisCode').AsString;
              CurrentSchoolCode := FieldByName('SchoolDistCode').AsString;
              CurrentRollSection := FieldByName('RollSection').AsString;
              
              If (not (HeaderPrinted or TotalsOnly))
                then
                  begin
                    HeaderPrinted := True;

                    If FirstPageOfReport
                      then
                        begin
                          PrintRollHeader(Sender, cRollType, CurrentSchoolCode, CurrentSwisCode,
                                          CurrentRollSection,
                                          CollectionLookupTable.FieldByName('CollectionType').AsString,
                                          RollPrintingYear,
                                          AssessmentYearCtlTable,
                                          SchoolCodeDescList,
                                          SwisCodeDescList, SequenceStr,
                                          PageNo, LineNo);
                          FirstPageOfReport := False;
                        end
                      else StartNewPage(Sender, cRollType, CurrentSchoolCode, CurrentSwisCode,
                                        CurrentRollSection,
                                        CollectionLookupTable.FieldByName('CollectionType').AsString,
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

              ClearTList(BaseTaxList, SizeOf(GeneralTaxRecord));
              ClearTList(SpecialDistrictTaxList, SizeOf(SDistTaxRecord));
              ClearTList(SpecialFeeTaxList, SizeOf(SPFeeTaxRecord));
              ClearTList(ExemptionTaxList, SizeOf(ExemptTaxRecord));

                {FXX01111998-2: I forgot to clear the line type list
                                each time.}

              LineTypeList.Clear;

              LoadTaxesForParcel(SwisSBLKey, BLGeneralTaxTable,
                                 BLSpecialDistrictTaxTable,
                                 BLExemptionTaxTable,
                                 BLSpecialFeeTaxTable,
                                 SDCodeDescList, EXCodeDescList,
                                 GeneralRateList, SDRateList,
                                 SpecialFeeRateList, BaseTaxList,
                                 SpecialDistrictTaxList, SpecialFeeTaxList, ExemptionTaxList, Quit);

              UpdateCooperativeTotals(BLHeaderTaxTable,
                                      CooperativeBaseTaxTotalsList,
                                      CooperativeSpecialDistrictTaxTotalsList,
                                      CooperativeExemptionTotalsList,
                                      BaseTaxList, SpecialDistrictTaxList, ExemptionTaxList,
                                      STARSavings);

                {CHG09152004-1(2.8.0.11): Extract the tax roll to Excel.}

              If ExtractToExcel
                then AddRecordToExtractFile(ExtractFile,
                                            BLHeaderTaxTable,
                                            BaseTaxList,
                                            ExemptionTaxList, SpecialDistrictTaxList, SpecialFeeTaxList,
                                            STARSavings);

                {FXX01061998-4: Print the prior owner - pass in ass year ctl tbl.}
                {CHG04032000-1: Pass in the swis code table to show full value.}

              FillInPropertyInformation(BLHeaderTaxTable, AssessmentYearCtlTable,
                                        SwisCodeTable, ParcelTable, SwisSBLKey, cRollType,
                                        PropertyClassDescList, SchoolCodeDescList,
                                        ExemptionTaxList, CL1List, CL2List, CL3List,
                                        CL4List, CL5List, CL6List, CL7List,
                                        LineTypeList, False, PrintAdditionalLots, False, False);

                {NOW FILL IN REST OF COLUMNS FOR THIS PARCEL}

                {column 4, tax descriptions}
                {Column 5, taxable vals}
                {column 6, sd flgs or null}
                {column 7, billno, amts}

               {FXX12231997-3: If this is a school exemption don't show town ex
                               amount and vice-versa, so we need to pass
                               in the collection type.}

                {FXX01061998-8: If class, do seperately.}

              If (BLHeaderTaxTable.FieldByName('HomesteadCode').AsString = 'S')
                then
                  begin
                    FillInClassInformation(CL1List, CL2List,
                                           CL3List, CL4List, CL5List,
                                           CL6List, CL7List,
                                           LineTypeList,
                                           BLHeaderTaxTable,
                                           CollectionType, cRollType,
                                           SuppressSDExtensions,
                                           ExemptionTaxList, BaseTaxList,
                                           SDExtCategoryList, SpecialDistrictTaxList,
                                           SpecialFeeTaxList);
                  end
                else
                  begin
                    FillInExemptions(CL4List, CL5List, CL6List, CL7List,
                                     LineTypeList, ' ', CollectionType,
                                     ExemptionTaxList);
                    FillInGeneralTaxes(CL2List, CL4List, CL5List, CL6List, CL7List,
                                       LineTypeList, cRollType, ' ', BaseTaxList);

                       {FXX12231997-4: Figure out the SD exemption amount so that
                                       we can print it.}

                    with BLHeaderTaxTable do
                      TotalAssessedVal := FieldByName('HstdTotalVal').AsFloat +
                                          FieldByName('NonhstdTotalVal').AsFloat;

                    FillInSDTaxes(CL4List, CL5List, CL6List, CL7List,
                                  LineTypeList, cRollType, TotalAssessedVal,
                                  SuppressSDExtensions, SDExtCategoryList,
                                  SpecialDistrictTaxList, '');
                    FillInSPFeeTaxes(CL4List, CL5List, CL6List, CL7List,
                                     LineTypeList, SpecialFeeTaxList);

                  end;  {If (BLHeaderTaxTable.FieldByName ...}

                 {figure out max lines to print from longest column then
                  add lines so all string lists of equal length}

              MaxLines := GetAndSetMaxLines(CL1List, CL2List, CL3List, CL4List,
                                            CL5List, CL6List, CL7List, LineTypeList);

              with Sender as TBaseReport do
                If (((NumLinesPerPage - LineNo) - (MaxLines + 2)) < LinesAtBottom)
                   then
                     begin
                         {First print an ending line.}

                       PrintEndingParcelLine(Sender);

                       StartNewPage(Sender, cRollType, LastSchoolCode, LastSwisCode,
                                    LastRollSection,
                                    CollectionLookupTable.FieldByName('CollectionType').AsString,
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
                      If not ParcelSubheaderPrinted
                       then
                         begin
                           PrintParcelPageSubheader(Sender, cRollType,
                                                    CollectionType, LineNo);
                           ParcelSubheaderPrinted := True;
                         end;

                      PrintOneParcel(Sender, cRollType, BLHeaderTaxTable,
                                     CollectionLookupTable, MaxLines, CL1List, CL2List,
                                     CL3List, CL4List, CL5List, CL6List, CL7List,
                                     LineTypeList, ExemptionTaxList.Count, LineNo);
                      NumBillsPrinted := NumBillsPrinted + 1;
                      ParcelPrintedThisPage := True;

                    end;  {If ParcelShouldBePrinted}

            end;  {If not Done}

        LastCooperative := CurrentCooperative;

      until (Done or ProgressDialog.Cancelled);

    end;  {with Sender as TBaseReport do}

    {FXX04241998-5: Need to free the tax TLists.}

  FreeTList(BaseTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SpecialDistrictTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpecialFeeTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExemptionTaxList, SizeOf(ExemptTaxRecord));

  FreeTList(CooperativeBaseTaxTotalsList, SizeOf(GeneralTaxRecord));
  FreeTList(CooperativeSpecialDistrictTaxTotalsList, SizeOf(SDistTaxRecord));
  FreeTList(CooperativeExemptionTotalsList, SizeOf(ExemptTaxRecord));

end;  {PrintSelectedRollSections}

{===============================================================}
Procedure PrintTotalsHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjCenter, 8.0, 0, BoxLineBottom, 0);   {Title}
      Println(#9 + RollHeaderTitle);
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.5, 0, BoxLineBottom, 0);   {Building ID}
      SetTab(1.9, pjCenter, 1.2, 0, BoxLineBottom, 0);   {Amount}

      Println(#9 + 'Cooperative ID' +
              #9 + 'Amount');
      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.5, 0, BoxLineNone, 0);   {Building ID}
      SetTab(1.9, pjRight, 1.2, 0, BoxLineNone, 0);   {Amount}

    end;  {with Sender as TBaseReport do}

end;  {PrintTotalsHeader}

{===============================================================}
Procedure Tfm_CooperativeRollPrint.PrintTotalsByBuilding(Sender : TObject;
                                                         lst_TotalsByCooperative : TList);

{CHG08192007-1(2.11.3.4)[F666]: Add a totals summary by building at the end of the coop tax roll.}

var
  I : Integer;

begin
  I := 0;

  with Sender as TBaseReport do
    begin
      NewPage;

        {CHG08192007-2(2.11.3.4)[F667]: If they are duplexing, make sure they start each building on an odd page.}

      If (Duplexing and
          Even(CurrentPage))
        then NewPage;

      PrintTotalsHeader(Sender);

      while _Compare(I, (lst_TotalsByCooperative.Count - 1), coLessThanOrEqual) do
        begin
          If _Compare(LinesLeft, 5, coLessThan)
            then
              begin
                NewPage;
                PrintTotalsHeader(Sender);
              end;

          with ptr_TotalsByCooperative(lst_TotalsByCooperative[I])^ do
            Println(#9 + ConvertSBLOnlyToDashDot(BuildingID) +
                    #9 + FormatFloat(DecimalDisplay, Amount));

          Inc(I);

        end;  {while _Compare(I, (lst_TotalsByCooperative.Count - 1), coLessThanOrEqual) do}

    end;  {with Sender as TBaseReport do}

end;  {PrintTotalsByBuilding}

{===============================================================}
Procedure Tfm_CooperativeRollPrint.TextFilerPrint(Sender: TObject);

var
  SelectedRollSections : TStringList;
  TaxTheseRollSections : Extended;
  FirstPageOfReport : Boolean;
  lst_TotalsByCooperative : TList;

begin
  lst_TotalsByCooperative := TList.Create;
  GlblCurrentTabNo := 1;
  GlblCurrentLinePos := 1;
  ProgressDialog.Start(GetRecordCount(BLHeaderTaxTable), True, True);

  NumColsPerPage := 130;

  RollPrintingYear := TaxRollYearEdit.Text;
  TaxTheseRollSections := 0;
  SelectedRollSections := TStringList.Create;
  SelectedRollSections.Add('1');
  FirstPageOfReport := True;

  If ((SelectedRollSections.Count > 0) and
      (not ProgressDialog.Cancelled))
    then PrintSelectedRollSections(Sender, SelectedRollSections,
                                   FirstPageOfReport, TaxTheseRollSections,
                                   lst_TotalsByCooperative);

    {CHG08192007-1(2.11.3.4)[F666]: Add a totals summary by building at the end of the coop tax roll.}

  If not bSuppressTaxAmounts
    then PrintTotalsByBuilding(Sender, lst_TotalsByCooperative);

  SelectedRollSections.Free;
  FreeTList(lst_TotalsByCooperative, SizeOf(rec_TotalsByCooperative));

end;  {ReportFilerPrint}

{===============================================================}
Procedure Tfm_CooperativeRollPrint.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure Tfm_CooperativeRollPrint.FormClose(    Sender: TObject;
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
