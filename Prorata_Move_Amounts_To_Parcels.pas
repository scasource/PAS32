unit Prorata_Move_Amounts_To_Parcels;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, wwdblook, ComCtrls;

type
  TTransferProrataAmountsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    PageControl1: TPageControl;
    LetterOptionsTabSheet: TTabSheet;
    Panel3: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    ProrataTable: TTable;
    ProrataDetailsTable: TTable;
    ParcelTable: TTable;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    CreateParcelListCheckBox: TCheckBox;
    ProrataYearEdit: TEdit;
    TrialRunCheckBox: TCheckBox;
    CollectionTypeComboBox: TComboBox;
    SDCodeTable: TTable;
    ProrataSDCodeLookupCombo: TwwDBLookupCombo;
    Label2: TLabel;
    Label7: TLabel;
    TransferDateEdit: TMaskEdit;
    SpecialDistrictTable: TTable;
    SchoolCodeTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
  private
    { Private declarations }
  public
    ReportCancelled, CreateParcelList, TrialRun : Boolean;
    UnitName, ProrataYear, CollectionType, Category, ProrataSDCode : String;
    iProcessingType : Integer;
    TransferDate : TDateTime;

    Procedure InitializeForm;

    Procedure PrintProrataTotals(Sender : TObject;
                                 ProrataTotalsList : TList);

  end;

  ProrataTotalsRecord = record
    SchoolCode : String;
    Description : String;
    Amount : Double;
    Count : Integer;
  end;

  ProrataTotalsPointer = ^ProrataTotalsRecord;

implementation
Uses Utilitys,  {General utilitys}
     PASUTILS, {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     Prog,
     RptDialg,
     PRCLLIST,
     Preview,
     UtilBill,
     UtilExSd,
     DataAccessUnit;

{$R *.DFM}
{========================================================}
Procedure TTransferProrataAmountsForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TTransferProrataAmountsForm.InitializeForm;

begin
  UnitName := 'Prorata_Move_Amounts_To_Parcels';  {mmm}

  _OpenTable(SDCodeTable, SdistCodeTableName, '', '', ThisYear, []);

  ProrataYearEdit.Text := IntToStr(GetYearFromDate(Date));
  TransferDateEdit.Text := DateToStr(Date);

end;  {InitializeForm}

{===================================================================}
Procedure TTransferProrataAmountsForm.FormKeyPress(    Sender: TObject;
                                                   var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{======================================================================}
Function TransferThisProrata(    ProrataTable : TTable;
                                 ProrataDetailsTable : TTable;
                                 SwisSBLKey : String;
                                 ProrataYear : String;
                                 Category : String;
                                 CollectionType : String;
                             var MunicipalCategoryCode : String;
                             var CountyProrataAmount : Double;
                             var MunicipalProrataAmount : Double;
                             var SchoolProrataAmount : Double;
                             var CountyProrataTransferred : Boolean;
                             var MunicipalProrataTransferred : Boolean;
                             var SchoolProrataTransferred : Boolean) : Boolean;

var
  Done, FirstTimeThrough : Boolean;
  ProrataAmount : Double;

begin
  Result := False;
  FirstTimeThrough := True;
  CountyProrataAmount := 0;
  MunicipalProrataAmount := 0;
  SchoolProrataAmount := 0;
  MunicipalCategoryCode := '';
  CountyProrataTransferred := False;
  MunicipalProrataTransferred := False;
  SchoolProrataTransferred := False;

  _SetRange(ProrataTable, [SwisSBLKey, ProrataYear, ''], [SwisSBLKey, ProrataYear, 'zzzzz'], '', []);

  ProrataTable.First;

  with ProrataTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If ((not Done) and
           CategoryMeetsCollectionTypeRequirements(CollectionType, FieldByName('Category').Text) and
           _Compare(FieldByName('TransferDate').Text, coBlank))
        then
          begin
            _SetRange(ProrataDetailsTable,
                      [FieldByName('SwisSBLKey').Text,
                       FieldByName('ProrataYear').Text,
                       FieldByName('Category').Text], [], '', [loSameEndingRange]);

            ProrataAmount := SumTableColumn(ProrataDetailsTable, 'TaxAmount');

            If _Compare(FieldByName('Category').Text, mtfnCity, coEqual)
              then
                begin
                  MunicipalProrataAmount := ProrataAmount;
                  MunicipalCategoryCode := mtfnCity;
                  MunicipalProrataTransferred := True;
                end;

            If _Compare(FieldByName('Category').Text, mtfnTown, coEqual)
              then
                begin
                  MunicipalProrataAmount := ProrataAmount;
                  MunicipalCategoryCode := mtfnTown;
                  MunicipalProrataTransferred := True;
                end;

            If _Compare(FieldByName('Category').Text, mtfnVillage, coEqual)
              then
                begin
                  MunicipalProrataAmount := ProrataAmount;
                  MunicipalCategoryCode := mtfnVillage;
                  MunicipalProrataTransferred := True;
                end;

            If _Compare(FieldByName('Category').Text, mtfnSchool, coEqual)
              then
                begin
                  SchoolProrataAmount := ProrataAmount;
                  SchoolProrataTransferred := True;
                end;

            If _Compare(FieldByName('Category').Text, mtfnCounty, coEqual)
              then
                begin
                  CountyProrataAmount := ProrataAmount;
                  CountyProrataTransferred := True;
                end;

            Result := True;

          end;  {If ((not Done) and ...}

    until Done;

end;  {TransferThisProrata}

{======================================================================}
Procedure MarkProrataTransferred(ProrataTable : TTable;
                                 ProrataYear : String;
                                 SwisSBLKey : String;
                                 Category : String;
                                 TransferDate : TDateTime);

begin
  If _Locate(ProrataTable, [ProrataYear, SwisSBLKey, ANSIUpperCase(Category)], '', [])
    then
      with ProrataTable do
        try
          Edit;
          FieldByName('TransferDate').AsDateTime := TransferDate;
          Post;
        except
        end;

end;  {MarkProrataTransferred}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TTransferProrataAmountsForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  Quit : Boolean;

begin
  case CollectionTypeComboBox.ItemIndex of
    0 : CollectionType := MunicipalTaxType;
    1 : CollectionType := CountyTaxType;
    2 : CollectionType := SchoolTaxType;
    3 : CollectionType := VillageTaxType;

  end;  {case CollectionTypeComboBox of}

  Category := GetCollectionTypeCategory(CollectionType);
  ReportCancelled := False;
  Quit := False;

  ProrataYear := ProrataYearEdit.Text;
  TrialRun := TrialRunCheckBox.Checked;
  CreateParcelList := CreateParcelListCheckBox.Checked;
  ProrataSDCode := ProrataSDCodeLookupCombo.Text;

  try
    TransferDate := StrToDate(TransferDateEdit.Text);
  except
    TransferDate := Date;
  end;

    {FXX11202008-1(2.16.1.3): The processing year should be determined by the prorata year.}

  iProcessingType := GetProcessingTypeForTaxRollYear(ProrataYear);

  _OpenTable(ParcelTable, ParcelTableName, '', '', iProcessingType, []);
  _OpenTable(SchoolCodeTable, SchoolCodeTableName, '', '', iProcessingType, []);
  _OpenTable(SpecialDistrictTable, SpecialDistrictTableName, '', '', iProcessingType, []);
  _OpenTable(SDCodeTable, SdistCodeTableName, '', '', iProcessingType, []);
  _OpenTable(ProrataTable, ProrataHeaderTableName, '', '', iProcessingType, []);
  _OpenTable(ProrataDetailsTable, ProrataDetailsTableName, '', '', iProcessingType, []);

  If (MessageDlg('Are you sure you want to transfer the ' + GetCollectionTypeCategory(CollectionType) + ' prorata amounts?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        ProgressDialog.UserLabelCaption := '';
        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

        SetPrintToScreenDefault(PrintDialog);

        If PrintDialog.Execute
          then
            begin
              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                                    False, Quit);

              If not Quit
                then
                  begin
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

                                  PreviewForm.FilePreview.ZoomFactor := 100;

                                  ReportFiler.Execute;

                                  ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                                  PreviewForm.ShowModal;
                                finally
                                  PreviewForm.Free;
                                end;

                                ShowReportDialog('Prorata Amounts Transferred.rpt', NewFileName, True);

                              end
                            else ReportPrinter.Execute;

                        end;  {If not Quit}

                    ProgressDialog.Finish;

                  end;  {If not Quit}

              ResetPrinter(ReportPrinter);

            end;  {If PrintDialog.Execute}

      end;  {If (MessageDlg...}

end;  {PrintButtonClick}

{===================================================================}
Function FindTotalsRecordInTotalsList(ProrataTotalsList : TList;
                                      _SchoolCode : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (ProrataTotalsList.Count - 1) do
    with ProrataTotalsPointer(ProrataTotalsList[I])^ do
      If _Compare(SchoolCode, _SchoolCode, coEqual)
        then Result := I;

end;  {FindTotalsRecordInTotalsList}

{====================================================================}
Procedure UpdateProrataTotalsList(ProrataTotalsList : TList;
                                  SchoolCodeTable : TTable;
                                  _SchoolCode : String;
                                  _Amount : Double);

var
  Index : Integer;
  ProrataTotalsPtr : ProrataTotalsPointer;

begin
  Index := FindTotalsRecordInTotalsList(ProrataTotalsList, _SchoolCode);

  If _Compare(Index, -1, coEqual)
    then
      begin
        New(ProrataTotalsPtr);

        with ProrataTotalsPtr^ do
          begin
            SchoolCode := _SchoolCode;

            If _Locate(SchoolCodeTable, [_SchoolCode], '', [])
              then Description := SchoolCodeTable.FieldByName('SchoolName').Text;

            Amount := 0;
            Count := 0;

          end;  {with ProrataTotalsPtr^ do}

        ProrataTotalsList.Add(ProrataTotalsPtr);

        Index := FindTotalsRecordInTotalsList(ProrataTotalsList, _SchoolCode);

      end;  {If _Compare(Index, -1, coEqual)}

  with ProrataTotalsPointer(ProrataTotalsList[Index])^ do
    begin
      Inc(Count);
      Amount := Amount + _Amount;
    end;

end;  {UpdateProrataTotalsList}

{===================================================================}
Procedure PrintProrataTotalsHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      Underline := True;
      Println(#9 + 'Prorata Total Details:');
      Bold := False;
      Underline := False;

      ClearTabs;
      SetTab(0.4, pjCenter, 0.7, 0, BOXLINEBottom, 0);   {School Code}
      SetTab(1.2, pjCenter, 2.0, 0, BOXLINEBottom, 0);   {School Name}
      SetTab(3.3, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {Count}
      SetTab(3.9, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Amount}

      Bold := True;
      Println(#9 + 'School Code' +
              #9 + 'School Name' +
              #9 + 'Count' +
              #9 + 'Amount');
      Bold := False;

      ClearTabs;
      SetTab(0.4, pjLeft, 0.7, 0, BOXLINENone, 0);   {School Code}
      SetTab(1.2, pjLeft, 2.0, 0, BOXLINENone, 0);   {School Name}
      SetTab(3.3, pjRight, 0.5, 0, BOXLINENone, 0);   {Count}
      SetTab(3.9, pjRight, 1.0, 0, BOXLINENone, 0);   {Amount}

    end;  {with Sender as TBaseReport do}

end;  {PrintProrataTotalsHeader}

{===================================================================}
Procedure TTransferProrataAmountsForm.PrintProrataTotals(Sender : TObject;
                                                         ProrataTotalsList : TList);

var
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      Println('');
      If (LinesLeft < 12)
        then NewPage;
      PrintProrataTotalsHeader(Sender);

      For I := 0 to (ProrataTotalsList.Count - 1) do
        with ProrataTotalsPointer(ProrataTotalsList[I])^ do
          begin
            If (LinesLeft < 5)
              then
                begin
                  NewPage;
                  PrintProrataTotalsHeader(Sender);
                end;

            Println(#9 + SchoolCode +
                    #9 + Description +
                    #9 + IntToStr(Count) +
                    #9 + FormatFloat(DecimalDisplay, Amount));

          end;  {with ProrataTotalsPointer(ProrataTotalsList[I])^ do}

    end;  {with Sender as TBaseReport do}

end;  {PrintProrataTotals}

{====================================================================}
Procedure TTransferProrataAmountsForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;

      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);

        {Print the date and page number.}

      SetFont('Times New Roman',8);
      Println('');
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '    ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman', 12);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Prorata Amounts Transferred Report', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',10);
      Bold := True;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.0, 0, BoxLineNone, 0);
      Underline := True;

      Println(#9 + 'Collection transferred: ' + CollectionType);
      Underline := False;
      Println('');

      Bold := True;
      ClearTabs;
      SetTab(0.3, pjCenter, 2.0, 0, BoxLineBottom, 0);  {Parcel ID}
      SetTab(2.4, pjCenter, 2.0, 0, BoxLineBottom, 0);  {Owner}
      SetTab(4.5, pjCenter, 0.6, 0, BoxLineBottom, 0);  {School code}
      SetTab(5.2, pjCenter, 0.8, 0, BoxLineBottom, 0);  {Prorata code}
      SetTab(6.1, pjCenter, 1.0, 0, BoxLineBottom, 0);  {Amount}

      Println(#9 + 'Parcel ID' +
              #9 + 'Owner' +
              #9 + 'School' +
              #9 + 'SD Code' +
              #9 + 'Amount');

      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.4, pjLeft, 2.0, 0, BoxLineNone, 0);  {Owner}
      SetTab(4.5, pjLeft, 0.6, 0, BoxLineNone, 0);  {School code}
      SetTab(5.2, pjLeft, 0.8, 0, BoxLineNone, 0);  {Prorata code}
      SetTab(6.1, pjRight, 1.0, 0, BoxLineNone, 0);  {Amount}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{====================================================================}
Procedure TTransferProrataAmountsForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough,
  CountyProrataTransferred, MunicipalProrataTransferred, SchoolProrataTransferred : Boolean;
  SwisSBLKey, MunicipalCategoryCode, SchoolCode : String;
  TotalProrataAmount, ProrataAmount,
  CountyProrataAmount, MunicipalProrataAmount, SchoolProrataAmount : Double;
  ProratasTransferredCount : LongInt;
  ProrataTotalsList : TList;

begin
  FirstTimeThrough := True;
  ProrataTotalsList := TList.Create;
  ProratasTransferredCount := 0;
  TotalProrataAmount := 0;
  ParcelTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    Done := ParcelTable.EOF;

    SwisSBLKey := ExtractSSKey(ParcelTable);
    ProgressDialog.Update(Self, 'Parcel ID = ' + ConvertSwisSBLToDashDot(SwisSBLKey));
    ProgressDialog.UserLabelCaption := 'Proratas Transferred = ' + IntToStr(ProratasTransferredCount);
    Application.ProcessMessages;

    If ((not Done) and
        TransferThisProrata(ProrataTable, ProrataDetailsTable, SwisSBLKey, ProrataYear, Category,
                            CollectionType, MunicipalCategoryCode,
                            CountyProrataAmount, MunicipalProrataAmount, SchoolProrataAmount,
                            CountyProrataTransferred, MunicipalProrataTransferred, SchoolProrataTransferred))
      then
        begin
          with Sender as TBaseReport do
            begin
              Inc(ProratasTransferredCount);
              If (LinesLeft < 6)
                then NewPage;

              ProrataAmount := Max([CountyProrataAmount, MunicipalProrataAmount, SchoolProrataAmount]);
              TotalProrataAmount := TotalProrataAmount + ProrataAmount;
              SchoolCode := ParcelTable.FieldByName('SchoolCode').Text;

              Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                      #9 + ProrataTable.FieldByName('Name1').Text +
                      #9 + SchoolCode +
                      #9 + ProrataSDCode +
                      #9 + FormatFloat(CurrencyDecimalDisplay, ProrataAmount));

              If _Compare(CollectionType, SchoolTaxType, coEqual)
                then UpdateProrataTotalsList(ProrataTotalsList, SchoolCodeTable, SchoolCode, ProrataAmount);

            end;  {with Sender as TBaseReport do}

            {FXX11202008-1(2.16.1.3): The processing year should be determined by the prorata year.}

          If not TrialRun
            then
              begin
                AddOneSpecialDistrict(SpecialDistrictTable,
                                      ['TaxRollYr', 'SwisSBLKey', 'SDistCode', 'CalcCode',
                                       'CalcAmount', 'DateAdded'],
                                      [ProrataYear, SwisSBLKey, ProrataSDCode, 'T',
                                       ProrataAmount, DateToStr(TransferDate)], GlblUserName);

                If CountyProrataTransferred
                  then MarkProrataTransferred(ProrataTable, ProrataYear, SwisSBLKey, mtfnCounty, TransferDate);

                If MunicipalProrataTransferred
                  then MarkProrataTransferred(ProrataTable, ProrataYear, SwisSBLKey, MunicipalCategoryCode, TransferDate);

                If SchoolProrataTransferred
                  then MarkProrataTransferred(ProrataTable, ProrataYear, SwisSBLKey, mtfnSchool, TransferDate);

              end;  {If not TrialRun}

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
      Println(#9 + 'Total Transferred' +
              #9 +
              #9 +
              #9 + FormatFloat(CurrencyDecimalDisplay, TotalProrataAmount));
      Println(#9 + 'Total Count = ' + IntToStr(ProratasTransferredCount));
      Println('');

      If  _Compare(CollectionType, SchoolTaxType, coEqual)
        then PrintProrataTotals(Sender, ProrataTotalsList);

    end;  {with Sender as TBaseReport do}

  ProgressDialog.Finish;
  FreeTList(ProrataTotalsList, SizeOf(ProrataTotalsRecord));

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TTransferProrataAmountsForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TTransferProrataAmountsForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.