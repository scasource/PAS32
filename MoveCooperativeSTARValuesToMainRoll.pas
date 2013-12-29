unit MoveCooperativeSTARValuesToMainRoll;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, (*Progress,*)
  RPCanvas, RPrinter, RPDefine, RPBase, RPFiler;

type
  TCooperativeSTARSavingsValuesTransferForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    tb_Parcel: TTable;
    CoopParcelTable: TTable;
    CoopAssessmentTable: TTable;
    GroupBox1: TGroupBox;
    TrialRunCheckBox: TCheckBox;
    PrintDetailsCheckBox: TCheckBox;
    PrintToExcelCheckBox: TCheckBox;
    cbPageBreakBetweenCoops: TCheckBox;
    Label7: TLabel;
    Panel2: TPanel;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure ReportHeader(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ProcessingType : Integer;
    PrintToExcel,
    TrialRun, PrintDetails, ReportCancelled, bPageBreakBetweenCoops : Boolean;
    AssessmentYear : String;
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}
    Procedure PrintCoopHeader(Sender : TObject);
    Procedure PrintOneCoop(Sender : TObject;
                           OldCoopSBL : String;
                           AssessedValueThisCoop,
                           ParcelsThisCoop : LongInt;
                           STARSavingsDetailList,
                           STARSavingsThisCoop : TList);
    Procedure UpdateOneCoop(SwisCode : String;
                            OldCoopSBL : String;
                            sThisCoopAccountNumber : String;
                            AssessedValueThisCoop : LongInt;
                            STARSavingsThisCoop : TList);

  end;

  STARSavingsTotalsRecord = record
    BasicSTARSavings,
    EnhancedSTARSavings : Double;
    Count : Integer;
  end;
  STARSavingsTotalsPointer = ^STARSavingsTotalsRecord;

  STARSavingsDetailRecord = record
    SwisSBLKey : String;
    BasicSTARSavings,
    EnhancedSTARSavings : Double;
  end;
  STARSavingsDetailPointer = ^STARSavingsDetailRecord;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, UTILEXSD,  Types,
     PASTypes, Prog, RTCalcul, DataAccessUnit, Preview;

{$R *.DFM}

{========================================================}
Procedure TCooperativeSTARSavingsValuesTransferForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TCooperativeSTARSavingsValuesTransferForm.InitializeForm;

begin
  UnitName := 'MoveCooperativeRollValuesToMainRoll';  {mmm}

end;  {InitializeForm}

{=================================================================}
Procedure TCooperativeSTARSavingsValuesTransferForm.StartButtonClick(Sender: TObject);

var
  SpreadsheetFileName, NewFileName : String;
  TempFile : File;

begin
  TrialRun := TrialRunCheckBox.Checked;
  ProcessingType := -1;
  ReportCancelled := False;
  PrintDetails := PrintDetailsCheckBox.Checked;
  PrintToExcel := PrintToExcelCheckBox.Checked;
  bPageBreakBetweenCoops := cbPageBreakBetweenCoops.Checked;

  ProcessingType := ThisYear;
  AssessmentYear := GlblThisYear;

  If ((ProcessingType <> -1) and
      (TrialRun or
       ((not TrialRun) and
        (MessageDlg('Are you sure you want to transfer the STAR Savings values?',
                    mtConfirmation, [mbYes, mbNo], 0) = idYes))) and
      PrintDialog.Execute)
    then
      begin
        OpenTablesForForm(Self, ProcessingType);

          {FXX12232003-1(2.07k2): The main roll files should not be opened
                                  through OpenTablesForForm since it sets the
                                  database to PASSystem.}

        try
          tb_Parcel.Close;
          tb_Parcel.TableName := ParcelTableName;
          SetTableNameForProcessingType(tb_Parcel, ProcessingType);
          tb_Parcel.Open;
        except
          SystemSupport(032, tb_Parcel, 'Error opening parcel table for main roll.',
                        UnitName, GlblErrorDlgBox);
        end;

          {CHG08032003-1(2.07h): Extract coop info to Excel.}

        If PrintToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName('CP', True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

                {Write the headers.}

              Writeln(ExtractFile, 'Parcel ID,',
                                   'Basic Savings,',
                                   'Enhanced Savings');

            end;  {If PrintToExcel}

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
                PreviewForm.ShowModal;
              finally
                PreviewForm.Free;

                  {Now delete the file.}
                try
                  AssignFile(TempFile, NewFileName);
                  OldDeleteFile(NewFileName);
                finally
                  {We don't care if it does not get deleted, so we won't put up an
                   error message.}

                  ChDir(GlblProgramDir);
                end;

              end;  {If PrintRangeDlg.PreviewPrint}

            end  {They did not select preview, so we will go
                  right to the printer.}
          else ReportPrinter.Execute;

        CloseTablesForForm(Self);

        If PrintToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If PrintToExcel}

      end;  {If ((MessageDlg(' ...}

end;  {StartButtonClick}

{===================================================================}
Procedure TCooperativeSTARSavingsValuesTransferForm.PrintCoopHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Underline := False;
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BOXLINENone, 0);   {Parcel ID}

      If PrintDetails
        then
          begin
            Println(#9 + ConstStr('-', 200));
            Println('');
          end;

      ClearTabs;
      Bold := True;
      SetTab(0.3, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Parcel ID}
      SetTab(1.7, pjCenter, 0.6, 0, BOXLINEBOTTOM, 0);   {Parcel Count}
      SetTab(2.4, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {Total AV}
      SetTab(3.7, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {Basic STAR Savings}
      SetTab(4.7, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {Enhanced STAR Savings}

      Println(#9 + 'Parcel ID' +
              #9 + '# Parc' +
              #9 + 'Total AV' +
              #9 + 'Basic Savings' +
              #9 + 'Enh Savings');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.3, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(1.7, pjRight, 0.6, 0, BOXLINENone, 0);   {Parcel Count}
      SetTab(2.4, pjRight, 1.2, 0, BOXLINENone, 0);   {Total AV}
      SetTab(3.7, pjRight, 0.9, 0, BOXLINENone, 0);   {Basic Savings}
      SetTab(4.7, pjRight, 0.9, 0, BOXLINENone, 0);   {Enhanced Savings}

    end;  {with Sender as TBaseReport do}

end;  {PrintCoopHeader}

{===================================================================}
Procedure PrintDetailHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Underline := False;
      Bold := True;
      Println('');
      ClearTabs;
      SetTab(1.0, pjCenter, 1.6, 0, BOXLINEBOTTOM, 0);   {Parcel ID}
      SetTab(3.4, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {Basic Savings}
      SetTab(4.4, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {Enhanced Savings}

      Println(#9 + 'Parcel ID' +
              #9 + 'Basic Savings' +
              #9 + 'Enh Savings');
      Bold := False;

      ClearTabs;
      SetTab(1.0, pjLeft, 1.6, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(3.4, pjRight, 0.9, 0, BOXLINENone, 0);   {Basic}
      SetTab(4.4, pjRight, 0.9, 0, BOXLINENone, 0);   {Enh}

    end;  {with Sender as TBaseReport do}

end;  {PrintDetailHeader}

{===================================================================}
Procedure PrintSummaryHeader(Sender : TObject;
                             CoopSBL : String;
                             PrintDetails : Boolean);

begin
  with Sender as TBaseReport do
    begin
      Underline := False;
      Bold := True;
      ClearTabs;
      SetTab(0.7, pjLeft, 0.5, 0, BOXLINENone, 0);   {EX Code}

      Underline := True;
      Println('');
      If (Deblank(CoopSBL) = '')
        then Println(#9 + 'Overall STAR Savings Totals')
        else
          If PrintDetails
            then Println(#9 + 'STAR Savings Totals for ' + ConvertSBLOnlyToDashDot(CoopSBL));

      Underline := False;

      ClearTabs;
      SetTab(1.6, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {# Parc}
      SetTab(2.3, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {Basic}
      SetTab(3.3, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {Enh}

      Println(#9 + '# Parc' +
              #9 + 'Basic' +
              #9 + 'Enhanced');
      Bold := False;

      ClearTabs;
      SetTab(1.6, pjRight, 0.6, 0, BOXLINENone, 0);   {# Parc}
      SetTab(2.3, pjRight, 0.9, 0, BOXLINENone, 0);   {Basic}
      SetTab(3.3, pjRight, 0.9, 0, BOXLINENone, 0);   {Enh}

    end;  {with Sender as TBaseReport do}

end;  {PrintSummaryHeader}

{===================================================================}
Function FindSTARSavingsInList(STARSavingsList : TList) : Integer;

begin
  Result := -1;

  If _Compare(STARSavingsList.Count, 0, coGreaterThan)
  then Result := 0;

end;  {FindSTARSavingsInList}

{===================================================================}
Procedure UpdateSTARSavingsList(CoopParcelTable : TTable;
                                STARSavingsList : TList);

var
  Index : Integer;
  STARSavingsTotalsPtr : STARSavingsTotalsPointer;

begin
  Index := FindSTARSavingsInList(STARSavingsList);

  If (Index = -1)
    then
      begin
        New(STARSavingsTotalsPtr);

        with STARSavingsTotalsPtr^, CoopParcelTable do
          begin
            BasicSTARSavings := 0;
            EnhancedSTARSavings := 0;
            Count := 0;

          end;

        STARSavingsList.Add(STARSavingsTotalsPtr);

        Index := FindSTARSavingsInList(STARSavingsList);

      end;  {If (Index = -1)}

  with STARSavingsTotalsPointer(STARSavingsList[Index])^, CoopParcelTable do
    begin
      BasicSTARSavings := BasicSTARSavings + FieldByName('BasicSTARSavings').AsFloat;
      EnhancedSTARSavings := EnhancedSTARSavings + FieldByName('EnhancedSTARSavings').AsFloat;
      Count := Count + 1;

    end;

end;  {UpdateSTARSavingsList}

{===================================================================}
Procedure CombineTotals(STARSavingsThisCoop,
                        OverallSTARSavings : TList);

var
  I, Index : Integer;
  STARSavingsTotalsPtr : STARSavingsTotalsPointer;

begin
  For I := 0 to (STARSavingsThisCoop.Count - 1) do
    begin
      Index := FindSTARSavingsInList(OverallSTARSavings);

      If (Index = -1)
        then
          begin
            New(STARSavingsTotalsPtr);

            with STARSavingsTotalsPtr^ do
              begin
                BasicSTARSavings := 0;
                EnhancedSTARSavings := 0;
                Count := 0;

              end;  {with ExemptionTotalsPtr^, ExemptionTable do}

            OverallSTARSavings.Add(STARSavingsTotalsPtr);

            Index := FindSTARSavingsInList(OverallSTARSavings);

          end;  {If (Index = -1)}

      with STARSavingsTotalsPointer(OverallSTARSavings[Index])^ do
        begin
          BasicSTARSavings := BasicSTARSavings +
                              STARSavingsTotalsPointer(STARSavingsThisCoop[I])^.BasicSTARSavings;
          EnhancedSTARSavings := EnhancedSTARSavings +
                                 STARSavingsTotalsPointer(STARSavingsThisCoop[I])^.EnhancedSTARSavings;

          Count := Count + STARSavingsTotalsPointer(STARSavingsThisCoop[I])^.Count;

        end;

    end;  {For I := 0 to (STARSavingsThisCoop.Count - 1) do}

end;  {CombineTotals}

{===================================================================}
Procedure TCooperativeSTARSavingsValuesTransferForm.PrintOneCoop(Sender : TObject;
                                                      OldCoopSBL : String;
                                                      AssessedValueThisCoop,
                                                      ParcelsThisCoop : LongInt;
                                                      STARSavingsDetailList,
                                                      STARSavingsThisCoop : TList);

var
  I : Integer;
  TotalBasicSTARSavings, TotalEnhancedSTARSavings : Double;

begin
  TotalBasicSTARSavings := 0;
  TotalEnhancedSTARSavings := 0;

  with Sender as TBaseReport do
    begin
      If (LinesLeft < 10)
        then NewPage;

      Println('');
      PrintCoopHeader(Sender);

      For I := 0 to (STARSavingsThisCoop.Count - 1) do
        with STARSavingsTotalsPointer(STARSavingsThisCoop[I])^ do
          begin
            TotalBasicSTARSavings := TotalBasicSTARSavings + BasicSTARSavings;
            TotalEnhancedSTARSavings := TotalEnhancedSTARSavings + EnhancedSTARSavings;

          end;  {with STARSavingsTotalsPointer(STARSavingsThisCoop[I])^ do}

      Bold := True;
      If (Deblank(OldCoopSBL) = '')
        then Print(#9 + 'GRAND TOTALS:')
        else Print(#9 + ConvertSBLOnlyToDashDot(OldCoopSBL));

      Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               ParcelsThisCoop) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               AssessedValueThisCoop) +
              #9 + FormatFloat(DecimalDisplay, TotalBasicSTARSavings) +
              #9 + FormatFloat(DecimalDisplay, TotalEnhancedSTARSavings));

      Bold := False;

      If (PrintDetails and
          (Deblank(OldCoopSBL) <> ''))
        then
          begin
            PrintDetailHeader(Sender);

            For I := 0 to (STARSavingsDetailList.Count - 1) do
              with STARSavingsDetailPointer(STARSavingsDetailList[I])^ do
                begin
                  If (LinesLeft < 5)
                    then
                      begin
                        NewPage;
                        PrintDetailHeader(Sender);
                        Bold := True;
                        Println(#9 + ConvertSBLOnlyToDashDot(OldCoopSBL) + ' CONTINUED');
                        Bold := False;

                      end;  {If (LinesLeft < 5)}

                  Println(#9 + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)) +
                          #9 + FormatFloat(DecimalDisplay, BasicSTARSavings) +
                          #9 + FormatFloat(DecimalDisplay, EnhancedSTARSavings));

                end;  {with STARSavingsDetailRecord(STARSavingsDetailList[I])^ do}

          end;  {If PrintDetails}

      Bold := False;

        {Now print the exemptions for this coop.}

      If (STARSavingsThisCoop.Count > 0)
        then
          begin
              {FXX04232009-13(4.20.1.1)[D336]: Allow for more room for coop exemption totals.}

            If (LinesLeft < 12)
              then NewPage;

            PrintSummaryHeader(Sender, OldCoopSBL, PrintDetails);

            For I := 0 to (STARSavingsThisCoop.Count - 1) do
              with STARSavingsTotalsPointer(STARSavingsThisCoop[I])^ do
                Println(#9 + IntToStr(Count) +
                        #9 + FormatFloat(DecimalDisplay, BasicSTARSavings) +
                        #9 + FormatFloat(DecimalDisplay, EnhancedSTARSavings));

          end;  {with STARSavingsTotalsPointer(STARSavingsThisCoop[I])^ do}

        {CHG05132010(2.24.2.2)[I7427]: Add an option for a page break between coops.}

      If bPageBreakBetweenCoops
      then NewPage;

    end;  {with Sender as TBaseReport do}

end;  {PrintOneCoop}

{===================================================================}
Procedure TCooperativeSTARSavingsValuesTransferForm.UpdateOneCoop(SwisCode : String;
                                                       OldCoopSBL : String;
                                                       sThisCoopAccountNumber : String;
                                                       AssessedValueThisCoop : LongInt;
                                                       STARSavingsThisCoop : TList);

var
  TempSwisSBLKey, TempCoopBase, MainCoopBase : String;
  bLocatedByAccountNumber : Boolean;

begin
  MainCoopBase := '';
  bLocatedByAccountNumber := False;

    {FXX10252006-1(2.10.3.2): Get the swis code from the parcel table.}

  TempCoopBase := GetCooperativeBase(OldCoopSBL, '', True, GlblCoopBaseSBLHasSubblock);

  If _Locate(tb_Parcel, [AssessmentYear, TempCoopBase], '', [loPartialKey, loParseSBLOnly])
    then
      begin
        TempSwisSBLKey := ExtractSSKey(tb_Parcel);
        MainCoopBase := GetCooperativeBase(Copy(TempSwisSBLKey, 7, 20), '', True, GlblCoopBaseSBLHasSubblock);
      end;

  If _Compare(MainCoopBase, TempCoopBase, coNotEqual)
    then
      begin
        TempCoopBase := GetCooperativeBase(OldCoopSBL, '', True, False);

        If _Locate(tb_Parcel, [AssessmentYear, TempCoopBase], '', [loPartialKey, loParseSBLOnly])
          then
            begin
              TempSwisSBLKey := ExtractSSKey(tb_Parcel);
              MainCoopBase := GetCooperativeBase(Copy(TempSwisSBLKey, 7, 20), '', True, False);
            end;

      end;  {else of If _Locate(tb_Parcel...}

    {Try by account # if it hasn't been located yet.}

  If _Compare(MainCoopBase, TempCoopBase, coNotEqual)
    then
      begin
        tb_Parcel.IndexName := 'BYAccountNo';

        If _Locate(tb_Parcel, [sThisCoopAccountNumber], '', [])
          then
            begin
              TempSwisSBLKey := ExtractSSKey(tb_Parcel);
              MainCoopBase := GetCooperativeBase(Copy(TempSwisSBLKey, 7, 20), '', True, False);
              bLocatedByAccountNumber := True;
            end;

        tb_Parcel.IndexName := 'BYTAXROLLYR_SBLKEY';

      end;  {If _Compare(MainCoopBase, TempCoopBase, coNotEqual)}

  If (bLocatedByAccountNumber or
      _Compare(MainCoopBase, TempCoopBase, coEqual))
  then
    with STARSavingsTotalsPointer(STARSavingsThisCoop[0])^, tb_Parcel do
    try
      Edit;
      FieldByName('BasicSTARSavings').AsFloat := BasicSTARSavings;
      FieldByName('EnhancedSTARSavings').AsFloat := EnhancedSTARSavings;
      Post;
    except
      Cancel;
      SystemSupport(005, tb_Parcel, 'Error inserting\updating main exemption record.',
                    UnitName, GlblErrorDlgBox);
    end;

end;  {UpdateOneCoop}

{===================================================================}
Procedure AddAnSTARSavingsToDetailList(STARSavingsDetailList : TList;
                                       CoopParcelTable : TTable);

var
  STARSavingsDetailPtr : STARSavingsDetailPointer;

begin
  New(STARSavingsDetailPtr);

  with STARSavingsDetailPtr^, CoopParcelTable do
    begin
      SwisSBLKey := FieldByName('SwisSBLKey').Text;
      BasicSTARSavings := FieldByName('BasicSTARSavings').AsFloat;
      EnhancedSTARSavings := FieldByName('EnhancedSTARSavings').AsFloat;

    end;  {with STARSavingsDetailPtr^, CoopParcelExemptionTable do}

  STARSavingsDetailList.Add(STARSavingsDetailPtr);

end;  {AddAnExemptionToDetailList}

{===================================================================}
Procedure TCooperativeSTARSavingsValuesTransferForm.ReportHeader(Sender: TObject);

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
      PrintCenter('STAR Savings Values Transferred to Main Roll', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;

    end;  {with Sender as TBaseReport do}

end;  {ReportHeader}

{===================================================================}
Procedure TCooperativeSTARSavingsValuesTransferForm.ReportPrint(Sender: TObject);

{CHG11241997-2: Print an audit trail.}

var
  FirstTimeThrough, Done : Boolean;
  AssessmentYear, SwisSBLKey,
  SwisCode, OldCoopSBL, ThisCoopSBL, sThisCoopAccountNumber : String;
  STARSavingsDetailList,
  STARSavingsThisCoop, OverallSTARSavings : TList;
  AssessedValueThisCoop, OverallAssessedValue,
  ParcelsThisCoop, OverallParcelCount : LongInt;

begin
  FirstTimeThrough := True;
  Done := False;
  OverallAssessedValue := 0;
  AssessedValueThisCoop := 0;
  ParcelsThisCoop := 0;
  OverallParcelCount := 0;
  STARSavingsThisCoop := TList.Create;
  OverallSTARSavings := TList.Create;
  STARSavingsDetailList := TList.Create;
  AssessmentYear := GetTaxRollYearForProcessingType(ProcessingType);

  ProgressDialog.UserLabelCaption := 'Transferring STAR Values.';
  ProgressDialog.Start(GetRecordCount(CoopParcelTable), True, True);

  CoopParcelTable.First;
  SwisSBLKey := ExtractSSKey(CoopParcelTable);
  OldCoopSBL := GetCooperativeBase(Copy(SwisSBLKey, 7, 20), '', True, GlblCoopBaseSBLHasSubblock);  {Minus the Swis and sublot/suffix}
  sThisCoopAccountNumber := CoopParcelTable.FieldByName('AccountNo').AsString;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CoopParcelTable.Next;

    If CoopParcelTable.EOF
      then Done := True;

    Application.ProcessMessages;

    SwisSBLKey := ExtractSSKey(CoopParcelTable);
    SwisCode := Copy(SwisSBLKey, 1, 6);
    ThisCoopSBL := GetCooperativeBase(Copy(SwisSBLKey, 7, 20), '', True, GlblCoopBaseSBLHasSubblock);  {Minus the Swis and suffix}
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));

      {Did we switch coops?}

    If (Done or
        (_Compare(ThisCoopSBL, OldCoopSBL, coNotEqual) and
         _Compare(ParcelsThisCoop, 0, coGreaterThan)))
      then
        begin
          OverallAssessedValue := OverallAssessedValue + AssessedValueThisCoop;
          OverallParcelCount := OverallParcelCount + ParcelsThisCoop;
          CombineTotals(STARSavingsThisCoop, OverallSTARSavings);

          PrintOneCoop(Sender, OldCoopSBL, AssessedValueThisCoop,
                       ParcelsThisCoop, STARSavingsDetailList, STARSavingsThisCoop);

          If not TrialRun
            then UpdateOneCoop(SwisCode, OldCoopSBL,
                               sThisCoopAccountNumber,
                               AssessedValueThisCoop,
                               STARSavingsThisCoop);

          AssessedValueThisCoop := 0;
          ParcelsThisCoop := 0;
          ClearTList(STARSavingsThisCoop, SizeOf(STARSavingsTotalsRecord));
          ClearTList(STARSavingsDetailList, SizeOf(STARSavingsDetailRecord));

        end;  {If (Done or}

    If ((not Done) and
        (CoopParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
      then
        with Sender as TBaseReport do
          begin
            ParcelsThisCoop := ParcelsThisCoop + 1;
            If (PrintDetails and
                (LinesLeft < 5))
              then NewPage;

            FindKeyOld(CoopAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                       [AssessmentYear, SwisSBLKey]);

            AssessedValueThisCoop := AssessedValueThisCoop +
                                     CoopAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;

            UpdateSTARSavingsList(CoopParcelTable, STARSavingsThisCoop);

            If PrintDetails
            then AddAnSTARSavingsToDetailList(STARSavingsDetailList,
                                              CoopParcelTable);

                      {CHG08032003-1(2.07h): Extract coop info to Excel.}

            If PrintToExcel
              then
                with CoopParcelTable do
                  Writeln(ExtractFile, ConvertSwisSBLToDashDot(SwisSBLKey),
                                       FormatExtractField(FieldByName('BasicSTARSavings').Text),
                                       FormatExtractField(FieldByName('EnhancedSTARSavings').Text));

            OldCoopSBL := ThisCoopSBL;

          end;  {with Sender as TBaseReport do}

    ReportCancelled := ProgressDialog.Cancelled;
    sThisCoopAccountNumber := CoopParcelTable.FieldByName('AccountNo').AsString;

  until (Done or ReportCancelled);

  ClearTList(STARSavingsDetailList, SizeOf(STARSavingsDetailRecord));

    {FXX04232009-12(4.20.1.1)[D269]: Do form feed before printing the totals.}

  If not ReportCancelled
    then
      begin
        with Sender as TBaseReport do
          NewPage;

        PrintOneCoop(Sender, '', OverallAssessedValue,
                     OverallParcelCount, STARSavingsDetailList, OverallSTARSavings);

      end;  {If not ReportCancelled}

  ProgressDialog.Finish;

  FreeTList(STARSavingsThisCoop, SizeOf(STARSavingsTotalsRecord));
  FreeTList(OverallSTARSavings, SizeOf(STARSavingsTotalsRecord));
  FreeTList(STARSavingsDetailList, SizeOf(STARSavingsDetailRecord));

end;  {ReportPrint}

{===================================================================}
Procedure TCooperativeSTARSavingsValuesTransferForm.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.