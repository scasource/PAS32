unit RProrataInformation;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler, locatdir, Mask, CheckLst, PASTypes;

type
  TProrataReportForm = class(TForm)
    Panel2: TPanel;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ProrataHeaderTable: TTable;
    ProrataDetailsTable: TTable;
    ProrataExemptionsTable: TTable;
    Panel1: TPanel;
    Label1: TLabel;
    OptionsGroupBox: TGroupBox;
    Label2: TLabel;
    Label6: TLabel;
    CollectionTypeComboBox: TComboBox;
    EditProrataYear: TEdit;
    ExtractToExcelCheckBox: TCheckBox;
    PrintDetailsCheckBox: TCheckBox;
    Panel4: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    tbParcel: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName, ProrataYear, CollectionType : String;
    ReportCancelled, ExtractToExcel, PrintDetailInformation : Boolean;
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure LoadProrataInformation(ProrataDetailsList : TList;
                                     ProrataExemptionsList : TList);

    Procedure PrintProrataTotals(Sender : TObject;
                                 ProrataTotalsList : TList);

  end;


implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, DataAccessUnit, UtilBill;

{$R *.DFM}

{========================================================}
Procedure TProrataReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TProrataReportForm.InitializeForm;

begin
  UnitName := 'RProrataInformation';  {mmm}

  _OpenTablesForForm(Self, GlblProcessingType, []);

  EditProrataYear.Text := IntToStr(GetYearFromDate(Date));

end;  {InitializeForm}

{===================================================================}
Procedure AddOneProrataExemptionToList(ProrataExemptionsTable : TTable;
                                       ProrataExemptionsList : TList);

var
  ProrataExemptionPtr : ProrataRemovedExemptionPointer;

begin
  New(ProrataExemptionPtr);

  with ProrataExemptionsTable, ProrataExemptionPtr^ do
    begin
      ExemptionCode := FieldByName('ExemptionCode').Text;
      AssessmentYear := FieldByName('TaxRollYr').Text;
      HomesteadCode := FieldByName('HomesteadCode').Text;
      CountyAmount := FieldByName('CountyAmount').AsInteger;
      MunicipalAmount := FieldByName('TownAmount').AsInteger;
      SchoolAmount := FieldByName('SchoolAmount').AsInteger;

    end;  {with ProrataExemptionsTable, ProrataExemptionPtr^ do}

  ProrataExemptionsList.Add(ProrataExemptionPtr);

end;  {AddOneProrataExemptionToList}

{===================================================================}
Procedure AddOneProrataDetailToList(ProrataDetailsTable : TTable;
                                    ProrataDetailsList : TList);

var
  ProrataDetailPtr : ProrataDetailPointer;

begin
  New(ProrataDetailPtr);

  with ProrataDetailsTable, ProrataDetailPtr^ do
    begin
      ProrataYear := FieldByName('ProrataYear').Text;
      AssessmentYear := FieldByName('TaxRollYr').Text;
      GeneralTaxType := FieldByName('GeneralTaxType').Text;
      HomesteadCode := FieldByName('HomesteadCode').Text;
      LevyDescription := FieldByName('LevyDescription').Text;
      CalculationDays := FieldByName('Days').AsInteger;
      TaxRate := FieldByName('TaxRate').AsFloat;
      ExemptionAmount := FieldByName('ExemptionAmount').AsInteger;
      TaxAmount := FieldByName('TaxAmount').AsFloat;

    end;  {with ProrataDetailsTable, ProrataDetailPtr^ do}

  ProrataDetailsList.Add(ProrataDetailPtr);

end;  {AddOneProrataDetailToList}

{===================================================================}
Procedure TProrataReportForm.LoadProrataInformation(ProrataDetailsList : TList;
                                                    ProrataExemptionsList : TList);

var
  Done, FirstTimeThrough : Boolean;

begin
  ClearTList(ProrataExemptionsList, SizeOf(ProrataRemovedExemptionRecord));
  ClearTList(ProrataDetailsList, SizeOf(ProrataDetailRecord));

  with ProrataHeaderTable do
    begin
      _SetRange(ProrataDetailsTable,
                [FieldByName('SwisSBLKey').Text, FieldByName('ProrataYear').Text, FieldByName('Category').Text],
                [], '', [loSameEndingRange]);

      _SetRange(ProrataExemptionsTable,
                [FieldByName('SwisSBLKey').Text, FieldByName('ProrataYear').Text, FieldByName('Category').Text],
                [], '', [loSameEndingRange]);

      FirstTimeThrough := True;
      ProrataDetailsTable.First;

      with ProrataDetailsTable do
        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else Next;

          Done := EOF;

          If not Done
            then AddOneProrataDetailToList(ProrataDetailsTable, ProrataDetailsList);

        until Done;

      FirstTimeThrough := True;
      ProrataExemptionsTable.First;

      with ProrataExemptionsTable do
        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else Next;

          Done := EOF;

          If not Done
            then AddOneProrataExemptionToList(ProrataExemptionsTable, ProrataExemptionsList);

        until Done;

    end;  {with ProrataHeaderTable do}

end;  {LoadProrataInformation}

{===================================================================}
Procedure PrintParcelHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      Bold := True;
      SetTab(0.4, pjCenter, 1.2, 0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(1.7, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Account #}
      SetTab(2.8, pjCenter, 1.5, 0, BOXLINEBottom, 0);   {Owner}
      SetTab(4.4, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {School code}
      SetTab(5.0, pjCenter, 0.8, 0, BOXLINEBottom, 0);   {Category}
      SetTab(5.9, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Effective Date}
      SetTab(7.0, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Amount}

      Println(#9 + 'Parcel ID' +
              #9 + 'Account #' +
              #9 + 'Owner' +
              #9 + 'School' +
              #9 + 'Category' +
              #9 + 'Effective Date' +
              #9 + 'Amount');

      ClearTabs;
      SetTab(0.4, pjLeft, 1.2, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(1.7, pjLeft, 1.0, 0, BOXLINENone, 0);   {Account #}
      SetTab(2.8, pjLeft, 1.5, 0, BOXLINENone, 0);   {Owner}
      SetTab(4.4, pjLeft, 0.5, 0, BOXLINENone, 0);   {School code}
      SetTab(5.0, pjLeft, 0.8, 0, BOXLINENone, 0);   {Category}
      SetTab(5.9, pjRight, 1.0, 0, BOXLINENone, 0);   {Effective Date}
      SetTab(7.0, pjRight, 1.0, 0, BoxLINENone, 0);   {Amount}
      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {PrintParcelHeader}

{===================================================================}
Procedure TProrataReportForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Arial',12);
      Bold := True;
      Home;
      PrintCenter('Prorata Information', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;
      Println('');

      If not PrintDetailInformation
        then PrintParcelHeader(Sender);

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Function FindTotalsRecordInTotalsList(ProrataTotalsList : TList;
                                      _LevyDescription : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (ProrataTotalsList.Count - 1) do
    with ProrataTotalsPointer(ProrataTotalsList[I])^ do
      If _Compare(LevyDescription, _LevyDescription, coEqual)
        then Result := I;

end;  {FindTotalsRecordInTotalsList}

{===================================================================}
Procedure UpdateTotalsList(ProrataTotalsList : TList;
                           _LevyDescription : String;
                           _ExemptionAmount : LongInt;
                           _TaxAmount : Double);

var
  Index : Integer;
  ProrataTotalsPtr : ProrataTotalsPointer;

begin
  Index := FindTotalsRecordInTotalsList(ProrataTotalsList, _LevyDescription);

  If _Compare(Index, -1, coEqual)
    then
      begin
        New(ProrataTotalsPtr);

        with ProrataTotalsPtr^ do
          begin
            LevyDescription := _LevyDescription;
            AssessedValue := 0;
            TaxAmount := 0;
            Count := 0;

          end;  {with ProrataTotalsPtr^ do}

        ProrataTotalsList.Add(ProrataTotalsPtr);

        Index := FindTotalsRecordInTotalsList(ProrataTotalsList, _LevyDescription);

      end;  {If _Compare(Index, -1, coEqual)}

  with ProrataTotalsPointer(ProrataTotalsList[Index])^ do
    begin
      Inc(Count);
      AssessedValue := AssessedValue + _ExemptionAmount;
      TaxAmount := TaxAmount + _TaxAmount;
    end;

end;  {UpdateTotalsList}

{===================================================================}
Procedure PrintProrataTotalsHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      Underline := True;
      Println(#9 + 'Prorata Total Details:');
      Println('');
      Bold := False;
      Underline := False;

      ClearTabs;
      SetTab(0.4, pjCenter, 2.0, 0, BOXLINEBottom, 0);   {Levy Description}
      SetTab(2.5, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {Count}
      SetTab(3.1, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Assessed Value}
      SetTab(4.2, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Amount}

      Println(#9 + 'Levy Description' +
              #9 + 'Count' +
              #9 + 'Assessed Value' +
              #9 + 'Amount');

      ClearTabs;
      SetTab(0.4, pjLeft, 2.0, 0, BOXLINENone, 0);   {Levy Description}
      SetTab(2.5, pjRight, 0.5, 0, BOXLINENone, 0);   {Count}
      SetTab(3.1, pjRight, 1.0, 0, BOXLINENone, 0);   {Assessed Value}
      SetTab(4.2, pjRight, 1.0, 0, BOXLINENone, 0);   {Amount}

    end;  {with Sender as TBaseReport do}

end;  {PrintProrataTotalsHeader}

{===================================================================}
Procedure TProrataReportForm.PrintProrataTotals(Sender : TObject;
                                                ProrataTotalsList : TList);

var
  I : Integer;
  TotalProrataAmount : Double;

begin
  TotalProrataAmount := 0;
  with Sender as TBaseReport do
    begin
      Println('');
      If (LinesLeft < 12)
        then NewPage;
      PrintProrataTotalsHeader(Sender);

      If ExtractToExcel
        then
          begin
            WritelnCommaDelimitedLine(ExtractFile, ['']);
            WritelnCommaDelimitedLine(ExtractFile,
                                      ['Levy Description',
                                       'Count',
                                       'Assessed Value',
                                       'Amount']);

          end;  {If ExtractToExcel}

      For I := 0 to (ProrataTotalsList.Count - 1) do
        with ProrataTotalsPointer(ProrataTotalsList[I])^ do
          begin
            If (LinesLeft < 5)
              then
                begin
                  NewPage;
                  PrintProrataTotalsHeader(Sender);
                end;

            Println(#9 + LevyDescription +
                    #9 + IntToStr(Count) +
                    #9 + FormatFloat(IntegerDisplay, AssessedValue) +
                    #9 + FormatFloat(DecimalDisplay, TaxAmount));

            TotalProrataAmount := TotalProrataAmount + TaxAmount;

            If ExtractToExcel
              then WritelnCommaDelimitedLine(ExtractFile,
                                             [LevyDescription,
                                              Count,
                                              AssessedValue,
                                              TaxAmount]);

          end;  {with ProrataTotalsPointer(ProrataTotalsList[I])^ do}

      Bold := True;
      Println(#9 + 'Total:' +
              #9 + #9 +
              #9 + FormatFloat(DecimalDisplay, TotalProrataAmount));
      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {PrintProrataTotals}

{===================================================================}
Procedure PrintExemptionsHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      ClearTabs;
      SetTab(1.0, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {Exemption Code}
      SetTab(1.6, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {Assessment Year}
      SetTab(2.3, pjCenter, 0.4, 0, BOXLINEBottom, 0);   {Homestead code}
      SetTab(2.8, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {County Amount}
      SetTab(3.9, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Municipal Amount}
      SetTab(5.0, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {School Amount}

      Print(#9 + 'EX Code' +
            #9 + 'Asmt Yr' +
            #9 + 'Hstd');

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'County Amt')
        else Print(#9);

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + GetMunicipalityTypeName(GlblMunicipalityType) + ' Amt')
        else Print(#9);

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + 'School Amt')
        else Println(#9);

      ClearTabs;
      SetTab(1.0, pjLeft, 0.5, 0, BOXLINENone, 0);   {Exemption Code}
      SetTab(1.6, pjLeft, 0.6, 0, BOXLINENone, 0);   {Assessment Year}
      SetTab(2.3, pjLeft, 0.4, 0, BOXLINENone, 0);   {Homestead code}
      SetTab(2.8, pjRight, 1.0, 0, BOXLINENone, 0);   {County Amount}
      SetTab(3.9, pjRight, 1.0, 0, BOXLINENone, 0);   {Municipal Amount}
      SetTab(5.0, pjRight, 1.0, 0, BOXLINENone, 0);   {School Amount}

    end;  {with Sender as TBaseReport do}

end;  {PrintExemptionsHeader}

{===================================================================}
Procedure PrintExemptions(Sender : TObject;
                          ProrataExemptionsList : TList);

var
  I : Integer;

begin
  with Sender as TBaseReport do
    For I := 0 to (ProrataExemptionsList.Count - 1) do
      with ProrataRemovedExemptionPointer(ProrataExemptionsList[I])^ do
        begin
          Print(#9 + ExemptionCode +
                #9 + AssessmentYear +
                #9 + HomesteadCode);

          If (rtdCounty in GlblRollTotalsToShow)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, CountyAmount))
            else Print(#9);

          If (rtdMunicipal in GlblRollTotalsToShow)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, MunicipalAmount))
            else Print(#9);

          If (rtdSchool in GlblRollTotalsToShow)
            then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, SchoolAmount))
            else Println(#9);

        end;  {with ProrataRemovedExemptionPointer(ProrataExemptionsList[I])^ do}

end;  {PrintExemptions}

{===================================================================}
Procedure PrintDetailsHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      ClearTabs;
      SetTab(1.0, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {Assessment Year}
      SetTab(1.7, pjCenter, 2.0, 0, BOXLINEBottom, 0);   {Levy Description}
      SetTab(3.8, pjCenter, 0.4, 0, BOXLINEBottom, 0);   {Homestead code}
      SetTab(4.3, pjCenter, 0.4, 0, BOXLINEBottom, 0);   {Calculation Days}
      SetTab(4.8, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Exemption Amt}
      SetTab(5.9, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Tax Rate}
      SetTab(7.0, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Tax Amount}

      Println(#9 + 'Asmt Yr' +
              #9 + 'Levy Description' +
              #9 + 'Hstd' +
              #9 + 'Days' +
              #9 + 'Exempt Amt' +
              #9 + 'Tax Rate' +
              #9 + 'Tax Amount');

      ClearTabs;
      SetTab(1.0, pjLeft, 0.6, 0, BOXLINENone, 0);   {Assessment Year}
      SetTab(1.7, pjLeft, 2.0, 0, BOXLINENone, 0);   {Levy Description}
      SetTab(3.8, pjLeft, 0.4, 0, BOXLINENone, 0);   {Homestead code}
      SetTab(4.3, pjRight, 0.4, 0, BOXLINENone, 0);   {Calculation Days}
      SetTab(4.8, pjRight, 1.0, 0, BOXLINENone, 0);   {Exemption Amt}
      SetTab(5.9, pjRight, 1.0, 0, BOXLINENone, 0);   {Tax Rate}
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Tax Amount}

    end;  {with Sender as TBaseReport do}

end;  {PrintDetailsHeader}

{===================================================================}
Procedure PrintDetails(var ExtractFile : TextFile;
                           ExtractToExcel : Boolean;
                           Sender : TObject;
                           ProrataDetailsList : TList;
                           ProrataHeaderTable : TTable;
                           tbParcel : TTable);

var
  I : Integer;

begin
  with Sender as TBaseReport do
    For I := 0 to (ProrataDetailsList.Count - 1) do
      with ProrataDetailPointer(ProrataDetailsList[I])^ do
      begin
        Println(#9 + AssessmentYear +
                #9 + LevyDescription +
                #9 + HomesteadCode +
                #9 + IntToStr(CalculationDays) +
                #9 + FormatFloat(CurrencyDisplayNoDollarSign, ExemptionAmount) +
                #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                #9 + FormatFloat(DecimalDisplay, TaxAmount));

        If ExtractToExcel
        then
        begin
          WritelnCommaDelimitedLine(ExtractFile,
                                    [ConvertSBLOnlyToDashDot(Copy(ProrataHeaderTable.FieldByName('SwisSBLKey').Text, 7, 20)),
                                     tbParcel.FieldByName('AccountNo').AsString,
                                     ProrataHeaderTable.FieldByName('Name1').Text,
                                     ProrataHeaderTable.FieldByName('SchoolCode').Text,
                                     ProrataHeaderTable.FieldByName('SaleDate').Text,
                                     AssessmentYear,
                                     LevyDescription,
                                     HomesteadCode,
                                     IntToStr(CalculationDays),
                                     FormatFloat(CurrencyDisplayNoDollarSign, ExemptionAmount),
                                     FormatFloat(ExtendedDecimalDisplay, TaxRate),
                                     FormatFloat(DecimalDisplay, TaxAmount)]);

          end;

      end;  {with ProrataDetailPointer(ProrataDetailsList[I])^ do}
      
end;  {PrintDetails}

{===================================================================}
Procedure PrintOneParcel(var ExtractFile : TextFile;
                             tbParcel : TTable;
                             Sender : TObject;
                             ExtractToExcel : Boolean;
                             ProrataHeaderTable : TTable;
                             ProrataDetailsList : TList;
                             ProrataExemptionsList : TList;
                             PrintDetailInformation : Boolean;
                             Amount : Double);

var
  LinesThisParcel : Integer;

begin
  _Locate(tbParcel, [GetTaxRlYr, ProrataHeaderTable.FieldByName('SwisSBLKey').AsString], '', [loParseSwisSBLKey]);

  with Sender as TBaseReport do
    begin
      If PrintDetailInformation
        then
          begin
            LinesThisParcel := 7 + (ProrataExemptionsList.Count - 1) + (ProrataDetailsList.Count - 1);

            If ((LinesLeft - LinesThisParcel) < 4)
              then NewPage;

            Println('');
            PrintParcelHeader(Sender);
          end
        else
          If (LinesLeft < 6)
            then NewPage;

      with ProrataHeaderTable do
        begin
          If PrintDetailInformation
            then Bold := True;

          Println(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                  #9 + tbParcel.FieldByName('AccountNo').AsString +
                  #9 + Copy(FieldByName('Name1').Text, 1, 17) +
                  #9 + FieldByName('SchoolCode').Text +
                  #9 + FieldByName('Category').Text +
                  #9 + FieldByName('SaleDate').Text +
                  #9 + FormatFloat(DecimalDisplay, Amount));

          Bold := False;

          If (ExtractToExcel and
              (not PrintDetailInformation))
            then WritelnCommaDelimitedLine(ExtractFile,
                                           [ConvertSBLOnlyToDashDot(Copy(FieldByName('SwisSBLKey').Text, 7, 20)),
                                            tbParcel.FieldByName('AccountNo').AsString,
                                            FieldByName('Name1').Text,
                                            FieldByName('SchoolCode').Text,
                                            FieldByName('Category').Text,
                                            FieldByName('SaleDate').Text,
                                            FormatFloat(DecimalDisplay, Amount)]);

        end;  {with ProrataHeaderTable do}

      If PrintDetailInformation
        then
          begin
            PrintExemptionsHeader(Sender);
            PrintExemptions(Sender, ProrataExemptionsList);

            PrintDetailsHeader(Sender);
            PrintDetails(ExtractFile, ExtractToExcel, Sender, ProrataDetailsList, ProrataHeaderTable, tbParcel);

          end;  {If PrintDetailInformation}

    end;  {with Sender as TBaseReport do}

end;  {PrintOneParcel}

{===================================================================}
Procedure TProrataReportForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  SwisSBLKey : String;
  ProrataDetailsList, ProrataExemptionsList, ProrataTotalsList : TList;
  I, ProratasFound : Integer;
  TotalProrata, TotalThisProrata: Double;

begin
  TotalProrata := 0;
  ProratasFound := 0;
  ProrataHeaderTable.First;
  Done := False;
  FirstTimeThrough := True;
  ProrataDetailsList := TList.Create;
  ProrataExemptionsList := TList.Create;
  ProrataTotalsList := TList.Create;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ProrataHeaderTable.Next;

    If ProrataHeaderTable.EOF
      then Done := True;

    SwisSBLKey := ProrataHeaderTable.FieldByName('SwisSBLKey').Text;
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    ProgressDialog.UserLabelCaption := 'Proratas Found = ' + IntToStr(ProratasFound);
    Application.ProcessMessages;

    If ((not Done) and
        _Compare(ProrataHeaderTable.FieldByName('ProrataYear').AsString, ProrataYear, coEqual) and
        CategoryMeetsCollectionTypeRequirements(CollectionType,
                                                ProrataHeaderTable.FieldByName('Category').Text))
      then
        begin
          Inc(ProratasFound);
          LoadProrataInformation(ProrataDetailsList, ProrataExemptionsList);

          If _Compare(ProrataDetailsList.Count, 0, coGreaterThan)
            then
              begin
                TotalThisProrata := 0;

                For I := 0 to (ProrataDetailsList.Count - 1) do
                  with ProrataDetailPointer(ProrataDetailsList[I])^ do
                    begin
                      UpdateTotalsList(ProrataTotalsList, LevyDescription, ExemptionAmount, TaxAmount);

                      TotalThisProrata := TotalThisProrata + TaxAmount;

                    end;  {with ProrataDetailPointer(ProrataDetailsList[I])^ do}

                PrintOneParcel(ExtractFile, tbParcel,
                               Sender, ExtractToExcel, ProrataHeaderTable,
                               ProrataDetailsList, ProrataExemptionsList,
                               PrintDetailInformation, TotalThisProrata);

                TotalProrata := TotalProrata + TotalThisProrata;

              end;  {If _Compare(ProrataDetailsList.Count, 0, coGreaterThan)}

          with Sender as TBaseReport do
            If (LinesLeft < 8)
              then NewPage;

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

  with Sender as TBaseReport do
    begin
      Bold := True;
      Println('');
      Println(#9 + 'Total Prorata:' +
              #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 + #9 +
              #9 + FormatFloat(DecimalDisplay, TotalProrata));
      Bold := False;

      PrintProrataTotals(Sender, ProrataTotalsList);

    end;  {with Sender as TBaseReport do}

  FreeTList(ProrataExemptionsList, SizeOf(ProrataRemovedExemptionRecord));
  FreeTList(ProrataDetailsList, SizeOf(ProrataDetailRecord));
  FreeTList(ProrataTotalsList, SizeOf(ProrataTotalsRecord));

end;  {ReportPrint}

{===================================================================}
Procedure TProrataReportForm.PrintButtonClick(Sender: TObject);

var
  Quit, Continue : Boolean;
  NewFileName, SpreadsheetFileName : String;
  TempFile : File;

begin
  Continue := True;
  Quit := False;
  ReportCancelled := False;
  ExtractToExcel := ExtractToExcelCheckBox.Checked;
  PrintDetailInformation := PrintDetailsCheckBox.Checked;

  PrintButton.Enabled := False;
  Application.ProcessMessages;
  Quit := False;

  SetPrintToScreenDefault(PrintDialog);

  If _Compare(CollectionTypeComboBox.Text, coBlank)
    then
      begin
        MessageDlg('Please select a collection type.', mtError, [mbOK], 0);
        CollectionTypeComboBox.SetFocus;
        Continue := False;

      end;  {If _Compare ...}

  ProrataYear := EditProrataYear.Text;

  If (Continue and
      PrintDialog.Execute)
    then
      begin
        case CollectionTypeComboBox.ItemIndex of
          0 : CollectionType := MunicipalTaxType;
          1 : CollectionType := CountyTaxType;
          2 : CollectionType := SchoolTaxType;
          3 : CollectionType := VillageTaxType;
          4 : CollectionType := AllTaxTypes;

        end;  {case CollectionTypeComboBox of}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler,
                              [ptLaser], False, Quit);

        ReportFiler.Orientation := poLandscape;
        ReportPrinter.Orientation := poLandscape;
        ProgressDialog.Start(GetRecordCount(ProrataHeaderTable), True, True);

          {Now print the report.}

        If not (Quit or ReportCancelled)
          then
            begin
              If ExtractToExcel
                then
                  begin
                    SpreadsheetFileName := GetPrintFileName('Prorata_Calc_', True);
                    AssignFile(ExtractFile, SpreadsheetFileName);
                    Rewrite(ExtractFile);

                    If PrintDetailInformation
                    then WritelnCommaDelimitedLine(ExtractFile,
                                                   ['Parcel ID',
                                                    'Account #',
                                                    'Owner',
                                                    'School Code',
                                                    'Effective Date',
                                                    'Year',
                                                    'Levy Desc',
                                                    'Hstd Code',
                                                    'Calc Days',
                                                    'Exmpt Amount',
                                                    'Tax Rate',
                                                    'Tax Amount'])
                    else WritelnCommaDelimitedLine(ExtractFile,
                                                   ['Parcel ID',
                                                    'Account #',
                                                    'Owner',
                                                    'School Code',
                                                    'Category',
                                                    'Effective Date',
                                                    'Tax Amount']);


                    end;  {If ExtractToExcel}

              If PrintDialog.PrintToFile
                then
                  begin
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    ReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      ReportFiler.Execute;

                      ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;

                        {Now delete the file.}
                      try
                        AssignFile(TempFile, NewFileName);
                        OldDeleteFile(NewFileName);
                      finally
                        ChDir(GlblProgramDir);
                      end;

                    end;  {try PreviewForm := ...}

                  end  {If PrintDialog.PrintToFile}
                else ReportPrinter.Execute;

              ProgressDialog.Finish;

              ResetPrinter(ReportPrinter);

              If ExtractToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

            end;  {If not Quit}

        DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

      end;  {If PrintDialog.Execute}

  PrintButton.Enabled := True;

end; {PrintButtonClick}

{===================================================================}
Procedure TProrataReportForm.FormClose(    Sender: TObject;
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