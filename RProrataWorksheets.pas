unit RProrataWorksheets;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler, locatdir, Mask, CheckLst, PASTypes;

type
  Tfm_ProrataWorksheets = class(TForm)
    Panel2: TPanel;
    ReportFiler: TReportFiler;
    dlg_Print: TPrintDialog;
    ReportPrinter: TReportPrinter;
    tb_ProrataHeader: TTable;
    tb_ProrataDetails: TTable;
    tb_ProrataExemptions: TTable;
    Panel1: TPanel;
    Label1: TLabel;
    gb_Options: TGroupBox;
    Label2: TLabel;
    Label6: TLabel;
    cmb_CollectionType: TComboBox;
    ed_ProrataYear: TEdit;
    Panel4: TPanel;
    btn_Print: TBitBtn;
    btn_Close: TBitBtn;
    cb_SeparateIntoCollectionTypes: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    cb_PrintThisIsNotABill: TCheckBox;
    tb_SchoolCode: TTable;
    Label5: TLabel;
    cb_CombineSimilarLevies: TCheckBox;
    tb_ExemptionCode: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_PrintClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName, ProrataYear, CollectionType : String;
    ReportCancelled, PrintAllCollections, CombineSimilarLevies,
    SeparateIntoCollectionTypes, PrintThisIsNotABill : Boolean;
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure LoadProrataInformation(ProrataDetailsList : TList;
                                     ProrataExemptionsList : TList;
                                     Category : String);

  end;


implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, DataAccessUnit, UtilBill;

{$R *.DFM}

{========================================================}
Procedure Tfm_ProrataWorksheets.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure Tfm_ProrataWorksheets.InitializeForm;

begin
  UnitName := 'RProrataInformation';  {mmm}

  _OpenTablesForForm(Self, GlblProcessingType, []);

  If GlblAssessmentYearIsSameAsTaxYearForMunicipal
    then ed_ProrataYear.Text := IntToStr(GetYearFromDate(Date))
    else ed_ProrataYear.Text := IncrementNumericString(IntToStr(GetYearFromDate(Date)), 1);

end;  {InitializeForm}

{===================================================================}
Function ProrataExemptionInList(ProrataExemptionsList : TList;
                                _ExemptionCode : String;
                                _AssessmentYear : String) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (ProrataExemptionsList.Count - 1) do
    with ProrataRemovedExemptionPointer(ProrataExemptionsList[I])^ do
      If (_Compare(_ExemptionCode, ExemptionCode, coEqual) and
          _Compare(_AssessmentYear, AssessmentYear, coEqual))
        then Result := True;
        
end;  {ProrataExemptionInList}

{===================================================================}
Procedure AddOneProrataExemptionToList(tb_ProrataExemptions : TTable;
                                       ProrataExemptionsList : TList);

var
  ProrataExemptionPtr : ProrataRemovedExemptionPointer;

begin
  If not ProrataExemptionInList(ProrataExemptionsList,
                                tb_ProrataExemptions.FieldByName('ExemptionCode').AsString,
                                tb_ProrataExemptions.FieldByName('TaxRollYr').AsString)
    then
      begin
        New(ProrataExemptionPtr);

        with tb_ProrataExemptions, ProrataExemptionPtr^ do
          begin
            ExemptionCode := FieldByName('ExemptionCode').AsString;
            AssessmentYear := FieldByName('TaxRollYr').AsString;
            HomesteadCode := FieldByName('HomesteadCode').AsString;
            CountyAmount := FieldByName('CountyAmount').AsInteger;
            MunicipalAmount := FieldByName('TownAmount').AsInteger;
            SchoolAmount := FieldByName('SchoolAmount').AsInteger;

          end;  {with tb_ProrataExemptions, ProrataExemptionPtr^ do}

        ProrataExemptionsList.Add(ProrataExemptionPtr);

      end;  {If not ProrataExemptionInList...}
      
end;  {AddOneProrataExemptionToList}

{===================================================================}
Procedure AddOneProrataDetailToList(tb_ProrataDetails : TTable;
                                    ProrataDetailsList : TList);

var
  ProrataDetailPtr : ProrataDetailPointer;

begin
  New(ProrataDetailPtr);

  with tb_ProrataDetails, ProrataDetailPtr^ do
    begin
      ProrataYear := FieldByName('ProrataYear').AsString;
      AssessmentYear := FieldByName('TaxRollYr').AsString;
      GeneralTaxType := FieldByName('GeneralTaxType').AsString;
      HomesteadCode := FieldByName('HomesteadCode').AsString;
      LevyDescription := FieldByName('LevyDescription').AsString;
      CalculationDays := FieldByName('Days').AsInteger;
      TaxRate := FieldByName('TaxRate').AsFloat;
      ExemptionAmount := FieldByName('ExemptionAmount').AsInteger;
      TaxAmount := FieldByName('TaxAmount').AsFloat;

    end;  {with tb_ProrataDetails, ProrataDetailPtr^ do}

  ProrataDetailsList.Add(ProrataDetailPtr);

end;  {AddOneProrataDetailToList}

{===================================================================}
Procedure CombineProrataDetails(ProrataDetailsList : TList);

var
  I, J : Integer;

begin
  For I := 0 to (ProrataDetailsList.Count - 1) do
    For J := (ProrataDetailsList.Count - 1) downto (I + 1) do
      If ((ProrataDetailsList[I] <> nil) and
          (ProrataDetailsList[J] <> nil))
        then
          with ProrataDetailPointer(ProrataDetailsList[I])^ do
            If (_Compare(ProrataYear, ProrataDetailPointer(ProrataDetailsList[J])^.ProrataYear, coEqual) and
                _Compare(GeneralTaxType, ProrataDetailPointer(ProrataDetailsList[J])^.GeneralTaxType, coEqual) and
                _Compare(LevyDescription, ProrataDetailPointer(ProrataDetailsList[J])^.LevyDescription, coEqual) and
                _Compare(CalculationDays, ProrataDetailPointer(ProrataDetailsList[J])^.CalculationDays, coEqual) and
                _Compare(TaxRate, ProrataDetailPointer(ProrataDetailsList[J])^.TaxRate, coEqual))
              then
                begin
                  ExemptionAmount := ExemptionAmount + ProrataDetailPointer(ProrataDetailsList[J])^.ExemptionAmount;
                  TaxAmount := TaxAmount + ProrataDetailPointer(ProrataDetailsList[J])^.TaxAmount;

                  FreeMem(ProrataDetailsList[J], SizeOf(ProrataDetailRecord));
                  ProrataDetailsList[J] := nil;

                end;  {If (_Compare(ProrataYear,}

  For I := (ProrataDetailsList.Count - 1) downto 0 do
    If (ProrataDetailsList[I] = nil)
      then ProrataDetailsList.Delete(I);

end;  {CombineProrataDetails}

{===================================================================}
Procedure Tfm_ProrataWorksheets.LoadProrataInformation(ProrataDetailsList : TList;
                                                       ProrataExemptionsList : TList;
                                                       Category : String);

var
  Done, FirstTimeThrough : Boolean;
  StartCategory, EndCategory : String;

begin
  ClearTList(ProrataExemptionsList, SizeOf(ProrataRemovedExemptionRecord));
  ClearTList(ProrataDetailsList, SizeOf(ProrataDetailRecord));

  If _Compare(Category, coBlank)
    then
      begin
        StartCategory := '';
        EndCategory := 'zzz';
      end
    else
      begin
        StartCategory := Category;
        EndCategory := Category;
      end;

  with tb_ProrataHeader do
    begin
      _SetRange(tb_ProrataDetails,
                [FieldByName('SwisSBLKey').AsString, FieldByName('ProrataYear').AsString, StartCategory],
                [FieldByName('SwisSBLKey').AsString, FieldByName('ProrataYear').AsString, EndCategory], '', []);

      _SetRange(tb_ProrataExemptions,
                [FieldByName('SwisSBLKey').AsString, FieldByName('ProrataYear').AsString, StartCategory],
                [FieldByName('SwisSBLKey').AsString, FieldByName('ProrataYear').AsString, EndCategory], '', []);

      FirstTimeThrough := True;
      tb_ProrataDetails.First;

      with tb_ProrataDetails do
        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else Next;

          Done := EOF;

          If not Done
            then AddOneProrataDetailToList(tb_ProrataDetails, ProrataDetailsList);

        until Done;

      FirstTimeThrough := True;
      tb_ProrataExemptions.First;

      with tb_ProrataExemptions do
        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else Next;

          Done := EOF;

          If not Done
            then AddOneProrataExemptionToList(tb_ProrataExemptions, ProrataExemptionsList);

        until Done;

    end;  {with tb_ProrataHeader do}

end;  {LoadProrataInformation}

{===================================================================}
Procedure PrintExemptionsHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      ClearTabs;
      SetTab(1.0, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {Exemption Code}
      SetTab(1.6, pjCenter, 1.5, 0, BOXLINEBottom, 0);   {Exemption Description}
      SetTab(3.2, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {Assessment Year}
      SetTab(3.9, pjCenter, 0.4, 0, BOXLINEBottom, 0);   {Homestead code}
      SetTab(4.4, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {County Amount}
      SetTab(5.5, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Municipal Amount}
      SetTab(6.6, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {School Amount}

      Bold := True;
      Print(#9 + 'EX Code' +
            #9 + 'EX Description' +
            #9 + 'Year' +
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

      Bold := False;

      ClearTabs;
      SetTab(1.0, pjLeft, 0.5, 0, BOXLINENone, 0);   {Exemption Code}
      SetTab(1.6, pjLeft, 1.5, 0, BOXLINENone, 0);   {Exemption Description}
      SetTab(3.2, pjLeft, 0.6, 0, BOXLINENone, 0);   {Assessment Year}
      SetTab(3.9, pjLeft, 0.4, 0, BOXLINENone, 0);   {Homestead code}
      SetTab(4.4, pjRight, 1.0, 0, BOXLINENone, 0);   {County Amount}
      SetTab(5.5, pjRight, 1.0, 0, BOXLINENone, 0);   {Municipal Amount}
      SetTab(6.6, pjRight, 1.0, 0, BOXLINENone, 0);   {School Amount}

    end;  {with Sender as TBaseReport do}

end;  {PrintExemptionsHeader}

{===================================================================}
Procedure PrintExemptions(Sender : TObject;
                          ProrataExemptionsList : TList;
                          tb_ExemptionCode : TTable);

var
  I : Integer;
  ExemptionDescription : String;

begin
  with Sender as TBaseReport do
    For I := 0 to (ProrataExemptionsList.Count - 1) do
      with ProrataRemovedExemptionPointer(ProrataExemptionsList[I])^ do
        begin
          If _Locate(tb_ExemptionCode, [ExemptionCode], '', [])
            then ExemptionDescription := tb_ExemptionCode.FieldByName('Description').AsString
            else ExemptionDescription := '';

          Print(#9 + ExemptionCode +
                #9 + ExemptionDescription +
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
Procedure PrintDetailsHeader(Sender : TObject;
                             CollectionType : String;
                             tb_SchoolCode : TTable);

begin
  with Sender as TBaseReport do
    begin
      Println('');

      If _Compare(CollectionType, coNotBlank)
        then
          begin
            ClearTabs;
            SetTab(1.0, pjLeft, 2.0, 0, BOXLINENone, 0);   {Header}
            Bold := True;
            Underline := True;

            If _Compare(CollectionType, SchoolTaxType, coEqual)
              then Println(#9 + 'School Collection (' + tb_SchoolCode.FieldByName('SchoolName').AsString + '):');

            If _Compare(CollectionType, [MunicipalTaxType, TownTaxType, VillageTaxType], coEqual)
              then Println(#9 + 'Municipal Collection:');

            Bold := False;
            Underline := False;
            Println('');

          end;  {If _Compare(CollectionType, coNotBlank)}

      ClearTabs;
      SetTab(1.0, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {Assessment Year}
      SetTab(1.7, pjCenter, 2.0, 0, BOXLINEBottom, 0);   {Levy Description}
      SetTab(3.8, pjCenter, 0.4, 0, BOXLINEBottom, 0);   {Homestead code}
      SetTab(4.3, pjCenter, 0.4, 0, BOXLINEBottom, 0);   {Calculation Days}
      SetTab(4.8, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Exemption Amt}
      SetTab(5.9, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Tax Rate}
      SetTab(7.0, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Tax Amount}

      Bold := True;
      Println(#9 + 'Year' +
              #9 + 'Levy Description' +
              #9 + 'Hstd' +
              #9 + 'Days' +
              #9 + 'Exempt Amt' +
              #9 + 'Tax Rate' +
              #9 + 'Tax Amount');
      Bold := False;

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
Procedure PrintDetails(Sender : TObject;
                       ProrataDetailsList : TList;
                       CollectionType : String;
                       tb_SchoolCode : TTable);

var
  I : Integer;
  TotalProrata : Double;
  DetailPrinted : Boolean;

begin
  TotalProrata := 0;
  DetailPrinted := False;

  with Sender as TBaseReport do
    begin
      For I := 0 to (ProrataDetailsList.Count - 1) do
        with ProrataDetailPointer(ProrataDetailsList[I])^ do
          If (_Compare(CollectionType, coBlank) or
              (_Compare(CollectionType, SchoolTaxType, coEqual) and
               _Compare(GeneralTaxType, SchoolTaxType, coEqual)) or
              (_Compare(CollectionType, [MunicipalTaxType, TownTaxType, VillageTaxType], coEqual) and
               _Compare(GeneralTaxType, [MunicipalTaxType, TownTaxType, VillageTaxType, CountyTaxType], coEqual)))
            then
              begin
                If not DetailPrinted
                  then
                    begin
                      PrintDetailsHeader(Sender, CollectionType, tb_SchoolCode);
                      DetailPrinted := True;
                    end;

                Println(#9 + AssessmentYear +
                        #9 + LevyDescription +
                        #9 + HomesteadCode +
                        #9 + IntToStr(CalculationDays) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign, ExemptionAmount) +
                        #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                        #9 + FormatFloat(DecimalDisplay, TaxAmount));

                TotalProrata := TotalProrata + TaxAmount;

              end;  {If (_Compare(CollectionType, coBlank) or ...}

        If _Compare(TotalProrata, 0, coGreaterThan)
          then
            begin
              Bold := True;
              Println(#9 + #9 + #9 + #9 + #9 +
                      #9 + 'Subtotal: ' +
                      #9 + FormatFloat(DecimalDisplay, TotalProrata));
              Bold := False;
              Println('');

            end;  {If (_Compare(CollectionType, coNotBlank)}

      end;  {with Sender as TBaseReport do}

end;  {PrintDetails}

{===================================================================}
Procedure PrintOneWorksheet(Sender : TObject;
                            tb_ProrataHeader : TTable;
                            tb_SchoolCode : TTable;
                            tb_ExemptionCode : TTable;
                            ProrataDetailsList : TList;
                            ProrataExemptionsList : TList;
                            SeperateIntoCollectionTypes : Boolean;
                            PrintThisIsNotABill : Boolean;
                            CombineSimilarLevies : Boolean);

var
  I : Integer;
  NAddrArray : NameAddrArray;
  TotalThisProrata : Double;

begin
  with Sender as TBaseReport, tb_ProrataHeader do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;

      Println('');
      SetFont('Times New Roman', 14);
      PrintCenter('Prorata Taxes Worksheet', (PageWidth / 2));

      SetFont('Times New Roman', 10);

      ClearTabs;
      SetTab(0.3, pjLeft, 0.7, 0, BOXLINENone, 0);   {Header}
      SetTab(1.0, pjLeft, 2.0, 0, BOXLINENone, 0);   {Data}

      Println('');
      Println('');
      Println('');
      _Locate(tb_SchoolCode, [FieldByName('SchoolCode').AsString], '', []);

      Println(#9 + 'Parcel ID:' +
              #9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').AsString));
      Println(#9 + 'Sale Date:' +
              #9 + FieldByName('SaleDate').AsString);
      Println(#9 + 'School:' +
              #9 + FieldByName('SchoolCode').AsString +
              #9 + '(' + tb_SchoolCode.FieldByName('SchoolName').AsString + ')');
      Println('');
      Println('');

      ClearTabs;
      SetTab(0.7, pjLeft, 3.0, 0, BOXLINENone, 0);   {Header}

      GetNameAddress(tb_ProrataHeader, NAddrArray);

      For I := 1 to 6 do
        Println(#9 + NAddrArray[I]);

      PrintExemptionsHeader(Sender);
      PrintExemptions(Sender, ProrataExemptionsList, tb_ExemptionCode);

      If CombineSimilarLevies
        then CombineProrataDetails(ProrataDetailsList);

      If SeperateIntoCollectionTypes
        then
          begin
            PrintDetails(Sender, ProrataDetailsList, 'SC', tb_SchoolCode);
            PrintDetails(Sender, ProrataDetailsList, 'MU', tb_SchoolCode);

          end
        else PrintDetails(Sender, ProrataDetailsList, '', tb_SchoolCode);

      TotalThisProrata := 0;

      For I := 0 to (ProrataDetailsList.Count - 1) do
        with ProrataDetailPointer(ProrataDetailsList[I])^ do
          TotalThisProrata := TotalThisProrata + TaxAmount;

      Println('');
      Bold := True;
      Println(#9 + #9 + #9 + #9 + #9 +
              #9 + 'GRAND TOTAL: ' +
              #9 + FormatFloat(DecimalDisplay, TotalThisProrata));
      Bold := False;

      If PrintThisIsNotABill
        then
          begin
            GotoXY(1, 10);
            Bold := True;
            SetFont('Times New Roman', 12);
            PrintCenter('T H I S   I S   N O T   A   B I L L', (PageWidth / 2));
            Bold := False;

          end;  {If PrintThisIsNotABill}

      NewPage;

    end;  {with Sender as TBaseReport do}

end;  {PrintOneParcel}

{===================================================================}
Procedure Tfm_ProrataWorksheets.ReportPrint(Sender: TObject);

var
  SwisSBLKey, LastSwisSBLKey, Category : String;
  ProrataDetailsList, ProrataExemptionsList : TList;
  ProratasFound : Integer;

begin
  ProratasFound := 0;
  LastSwisSBLKey := '';
  tb_ProrataHeader.First;
  ProrataDetailsList := TList.Create;
  ProrataExemptionsList := TList.Create;

  with tb_ProrataHeader do
    begin
      First;

      while (not (EOF or ReportCancelled)) do
        begin
          SwisSBLKey := FieldByName('SwisSBLKey').AsString;
          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          ProgressDialog.UserLabelCaption := 'Proratas Found = ' + IntToStr(ProratasFound);
          Application.ProcessMessages;

          If (_Compare(FieldByName('ProrataYear').AsString, ProrataYear, coEqual) and
              _Compare(SwisSBLKey, LastSwisSBLKey, coNotEqual) and
              (PrintAllCollections or
               CategoryMeetsCollectionTypeRequirements(CollectionType, FieldByName('Category').AsString)))
            then
              begin
                Inc(ProratasFound);

                If PrintAllCollections
                  then Category := ''
                  else Category := FieldByName('Category').AsString;

                LoadProrataInformation(ProrataDetailsList, ProrataExemptionsList, Category);

                If _Compare(ProrataDetailsList.Count, 0, coGreaterThan)
                  then PrintOneWorksheet(Sender, tb_ProrataHeader,
                                         tb_SchoolCode, tb_ExemptionCode,
                                         ProrataDetailsList, ProrataExemptionsList,
                                         SeparateIntoCollectionTypes, PrintThisIsNotABill,
                                         CombineSimilarLevies);

              end;  {If (_Compare(FieldByName('ProrataYear') ...}

          ReportCancelled := ProgressDialog.Cancelled;
          LastSwisSBLKey := SwisSBLKey;

          Next;

        end;  {while (not (EOF or ReportCancelled)) do}

    end;  {with tb_ProrataHeader do}

  FreeTList(ProrataExemptionsList, SizeOf(ProrataRemovedExemptionRecord));
  FreeTList(ProrataDetailsList, SizeOf(ProrataDetailRecord));

end;  {ReportPrint}

{===================================================================}
Procedure Tfm_ProrataWorksheets.btn_PrintClick(Sender: TObject);

var
  Quit, Continue : Boolean;
  NewFileName : String;
  TempFile : File;

begin
  Continue := True;
  Quit := False;
  ReportCancelled := False;
  PrintAllCollections := False;
  PrintThisIsNotABill := cb_PrintThisIsNotABill.Checked;
  SeparateIntoCollectionTypes := cb_SeparateIntoCollectionTypes.Checked;
  CombineSimilarLevies := cb_CombineSimilarLevies.Checked;

  btn_Print.Enabled := False;
  Application.ProcessMessages;

  SetPrintToScreenDefault(dlg_Print);

  If _Compare(cmb_CollectionType.Text, coBlank)
    then
      begin
        MessageDlg('Please select a collection type.', mtError, [mbOK], 0);
        cmb_CollectionType.SetFocus;
        Continue := False;

      end;  {If _Compare ...}

  ProrataYear := ed_ProrataYear.Text;

  If (Continue and
      dlg_Print.Execute)
    then
      begin
        case cmb_CollectionType.ItemIndex of
          0 : CollectionType := MunicipalTaxType;
          1 : CollectionType := CountyTaxType;
          2 : CollectionType := SchoolTaxType;
          3 : CollectionType := VillageTaxType;
          4 : PrintAllCollections := True;

        end;  {case cmb_CollectionType.ItemIndex of}

        AssignPrinterSettings(dlg_Print, ReportPrinter, ReportFiler,
                              [ptLaser], False, Quit);

        ProgressDialog.Start(GetRecordCount(tb_ProrataHeader), True, True);

          {Now print the report.}

        If not (Quit or ReportCancelled)
          then
            begin
              If dlg_Print.PrintToFile
                then
                  begin
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    ReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      ReportFiler.Execute;

                      ProgressDialog.StartPrinting(dlg_Print.PrintToFile);

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

            end;  {If not Quit}

        DisplayPrintingFinishedMessage(dlg_Print.PrintToFile);

      end;  {If PrintDialog.Execute}

  btn_Print.Enabled := True;

end; {PrintButtonClick}

{===================================================================}
Procedure Tfm_ProrataWorksheets.FormClose(    Sender: TObject;
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