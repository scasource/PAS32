unit MoveCooperativeRollValuesToMainRoll;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, (*Progress,*)
  RPCanvas, RPrinter, RPDefine, RPBase, RPFiler;

type
  TCooperativeValuesTransferForm = class(TForm)
    CoopParcelExemptionTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    ParcelExemptionTable: TTable;
    tb_Parcel: TTable;
    CoopParcelTable: TTable;
    ExemptionCodeTable: TTable;
    CoopAssessmentTable: TTable;
    GroupBox1: TGroupBox;
    TrialRunCheckBox: TCheckBox;
    PrintDetailsCheckBox: TCheckBox;
    PrintToExcelCheckBox: TCheckBox;
    cbPageBreakBetweenCoops: TCheckBox;
    ChooseTaxYearRadioGroup: TRadioGroup;
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
    slExemptionCodesUsed : TStringList;

    Procedure InitializeForm;  {Open the tables and setup.}
    Procedure PrintCoopHeader(Sender : TObject);
    Procedure PrintOneCoop(Sender : TObject;
                           OldCoopSBL : String;
                           AssessedValueThisCoop,
                           ParcelsThisCoop : LongInt;
                           ExemptionDetailList,
                           ExemptionsThisCoop : TList);
    Procedure UpdateOneCoop(SwisCode : String;
                            OldCoopSBL : String;
                            sThisCoopAccountNumber : String;
                            AssessedValueThisCoop : LongInt;
                            ExemptionsThisCoop : TList);

  end;

  ExemptionTotalsRecord = record
    ExemptionCode : String;
    SchoolAmount,
    TownAmount,
    CountyAmount : LongInt;
    Count : Integer;
  end;
  ExemptionTotalsPointer = ^ExemptionTotalsRecord;

  ExemptionDetailRecord = record
    SwisSBLKey : String;
    Owner : String;
    Shares : Double;
    AssessedValue : LongInt;
    ExemptionCode : String;
    SchoolAmount,
    TownAmount,
    CountyAmount : LongInt;
  end;
  ExemptionDetailPointer = ^ExemptionDetailRecord;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, UTILEXSD,  Types,
     PASTypes, Prog, RTCalcul, DataAccessUnit, Preview;

{$R *.DFM}

{========================================================}
Procedure TCooperativeValuesTransferForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TCooperativeValuesTransferForm.InitializeForm;

begin
  UnitName := 'MoveCooperativeRollValuesToMainRoll';  {mmm}

  If (GlblProcessingType = ThisYear)
    then ChooseTaxYearRadioGroup.ItemIndex := 0;

  If (GlblProcessingType = NextYear)
    then ChooseTaxYearRadioGroup.ItemIndex := 1;

end;  {InitializeForm}

{=================================================================}
Procedure TCooperativeValuesTransferForm.StartButtonClick(Sender: TObject);

var
  SpreadsheetFileName, NewFileName : String;
  TempFile : File;
  I, J : Integer;

begin
  slExemptionCodesUsed := TStringList.Create;
  TrialRun := TrialRunCheckBox.Checked;
  ProcessingType := -1;
  ReportCancelled := False;
  PrintDetails := PrintDetailsCheckBox.Checked;
  PrintToExcel := PrintToExcelCheckBox.Checked;
  bPageBreakBetweenCoops := cbPageBreakBetweenCoops.Checked;

  case ChooseTaxYearRadioGroup.ItemIndex of
    0 : begin
          ProcessingType := ThisYear;
          AssessmentYear := GlblThisYear;
        end;

    1 : begin
          ProcessingType := NextYear;
          AssessmentYear := GlblNextYear;
        end;

    else MessageDlg('Please choose an assessment year.', mtError, [mbOK], 0);

  end;  {case ChooseTaxYearRadioGroup.ItemIndex of}

  If ((ProcessingType <> -1) and
      (TrialRun or
       ((not TrialRun) and
        (MessageDlg('Are you sure you want to transfer the exemption values?',
                    mtConfirmation, [mbYes, mbNo], 0) = idYes))) and
      PrintDialog.Execute)
    then
      begin
        OpenTablesForForm(Self, ProcessingType);

          {FXX12232003-1(2.07k2): The main roll files should not be opened
                                  through OpenTablesForForm since it sets the
                                  database to PASSystem.}

        try
          ExemptionCodeTable.Close;
          ExemptionCodeTable.TableName := ExemptionCodesTableName;
          SetTableNameForProcessingType(ExemptionCodeTable, ProcessingType);
          ExemptionCodeTable.Open;
        except
          SystemSupport(030, ExemptionCodeTable, 'Error opening exemption code table for main roll.',
                        UnitName, GlblErrorDlgBox);
        end;

        try
          ParcelExemptionTable.Close;
          ParcelExemptionTable.TableName := ExemptionsTableName;
          SetTableNameForProcessingType(ParcelExemptionTable, ProcessingType);
          ParcelExemptionTable.Open;
        except
          SystemSupport(031, ParcelExemptionTable, 'Error opening parcel exemption table for main roll.',
                        UnitName, GlblErrorDlgBox);
        end;

        try
          tb_Parcel.Close;
          tb_Parcel.TableName := ParcelTableName;
          SetTableNameForProcessingType(tb_Parcel, ProcessingType);
          tb_Parcel.Open;
        except
          SystemSupport(032, tb_Parcel, 'Error opening parcel table for main roll.',
                        UnitName, GlblErrorDlgBox);
        end;

          {Determine the list of exemption codes actually used on the coop roll.}

        with CoopParcelExemptionTable do
        begin
          First;

          while not EOF do
          begin
            If _Compare(slExemptionCodesUsed.IndexOf(FieldByName('ExemptionCode').AsString), -1, coEqual)
            then slExemptionCodesUsed.Add(FieldByName('ExemptionCode').AsString);

            Next;
          end;

        end;  {with CoopParcelExemptionTable do}

        slExemptionCodesUsed.Sort;

          {CHG08032003-1(2.07h): Extract coop info to Excel.}

        If PrintToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName('CP', True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

                {Write the headers.}

              WriteCommaDelimitedLine(ExtractFile,
                                      ['Parcel ID',
                                       'Owner',
                                       'Shares',
                                       'Assessed Value']);

              For I := 0 to (slExemptionCodesUsed.Count - 1) do
                For J := 1 to 3 do
                  WriteCommaDelimitedLine(ExtractFile,
                                          [slExemptionCodesUsed[I]]);

              WritelnCommaDelimitedLine(ExtractFile, []);

              WriteCommaDelimitedLine(ExtractFile,
                                      ['',
                                       '',
                                       '',
                                       '']);

              For I := 0 to (slExemptionCodesUsed.Count - 1) do
                WriteCommaDelimitedLine(ExtractFile,
                                        ['County Amount',
                                         'Municipal Amount',
                                         'School Amount']);

              WritelnCommaDelimitedLine(ExtractFile, []);

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
Procedure TCooperativeValuesTransferForm.PrintCoopHeader(Sender : TObject);

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
      SetTab(3.7, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {County}
      SetTab(4.7, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {Town}
      SetTab(5.7, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {School}

      Println(#9 + 'Parcel ID' +
              #9 + '# Parc' +
              #9 + 'Total AV' +
              #9 + 'County EX' +
              #9 + GetMunicipalityTypeName(GlblMunicipalityType) + ' EX' +
              #9 + 'School EX');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.3, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(1.7, pjRight, 0.6, 0, BOXLINENone, 0);   {Parcel Count}
      SetTab(2.4, pjRight, 1.2, 0, BOXLINENone, 0);   {Total AV}
      SetTab(3.7, pjRight, 0.9, 0, BOXLINENone, 0);   {County}
      SetTab(4.7, pjRight, 0.9, 0, BOXLINENone, 0);   {Town}
      SetTab(5.7, pjRight, 0.9, 0, BOXLINENone, 0);   {School}

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
      SetTab(2.7, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {EX Code}
      SetTab(3.4, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {County}
      SetTab(4.4, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {Town}
      SetTab(5.4, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {School}

      Println(#9 + 'Parcel ID' +
              #9 + 'EX Code' +
              #9 + 'County' +
              #9 + 'Town' +
              #9 + 'School');
      Bold := False;

      ClearTabs;
      SetTab(1.0, pjLeft, 1.6, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(2.7, pjLeft, 0.6, 0, BOXLINENone, 0);   {EX Code}
      SetTab(3.4, pjRight, 0.9, 0, BOXLINENone, 0);   {County}
      SetTab(4.4, pjRight, 0.9, 0, BOXLINENone, 0);   {Town}
      SetTab(5.4, pjRight, 0.9, 0, BOXLINENone, 0);   {School}

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
        then Println(#9 + 'Overall Exemption Totals')
        else
          If PrintDetails
            then Println(#9 + 'Exemption Totals for ' + ConvertSBLOnlyToDashDot(CoopSBL));

      Underline := False;

      ClearTabs;
      SetTab(1.0, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {EX Code}
      SetTab(1.6, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {# Parc}
      SetTab(2.3, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {County}
      SetTab(3.3, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {Town}
      SetTab(4.3, pjCenter, 0.9, 0, BOXLINEBottom, 0);   {School}

      Println(#9 + 'EX Code' +
              #9 + '# Parc' +
              #9 + 'County' +
              #9 + 'Town' +
              #9 + 'School');
      Bold := False;

      ClearTabs;
      SetTab(1.0, pjLeft, 0.5, 0, BOXLINENone, 0);   {EX Code}
      SetTab(1.6, pjRight, 0.6, 0, BOXLINENone, 0);   {# Parc}
      SetTab(2.3, pjRight, 0.9, 0, BOXLINENone, 0);   {County}
      SetTab(3.3, pjRight, 0.9, 0, BOXLINENone, 0);   {Town}
      SetTab(4.3, pjRight, 0.9, 0, BOXLINENone, 0);   {School}

    end;  {with Sender as TBaseReport do}

end;  {PrintSummaryHeader}

{===================================================================}
Function FindExemptionInList(ExemptionList : TList;
                             _ExemptionCode : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (ExemptionList.Count - 1) do
    If (ExemptionTotalsPointer(ExemptionList[I])^.ExemptionCode = _ExemptionCode)
      then Result := I;

end;  {FindExemptionInList}

{===================================================================}
Procedure UpdateExemptionList(ExemptionTable : TTable;
                              ExemptionList : TList);

var
  Index : Integer;
  ExemptionTotalsPtr : ExemptionTotalsPointer;

begin
  Index := FindExemptionInList(ExemptionList, ExemptionTable.FieldByName('ExemptionCode').Text);

  If (Index = -1)
    then
      begin
        New(ExemptionTotalsPtr);

        with ExemptionTotalsPtr^, ExemptionTable do
          begin
            ExemptionCode := FieldByName('ExemptionCode').Text;
            SchoolAmount := 0;
            TownAmount := 0;
            CountyAmount := 0;
            Count := 0;

          end;  {with ExemptionTotalsPtr^, ExemptionTable do}

        ExemptionList.Add(ExemptionTotalsPtr);

        Index := FindExemptionInList(ExemptionList, ExemptionTable.FieldByName('ExemptionCode').Text);

      end;  {If (Index = -1)}

  with ExemptionTotalsPointer(ExemptionList[Index])^, ExemptionTable do
    begin
      SchoolAmount := SchoolAmount + FieldByName('SchoolAmount').AsInteger;
      TownAmount := TownAmount + FieldByName('TownAmount').AsInteger;
      CountyAmount := CountyAmount + FieldByName('CountyAmount').AsInteger;
      Count := Count + 1;

    end;  {with ExemptionTotalsPtr^, ExemptionTable do}

end;  {UpdateExemptionList}

{===================================================================}
Procedure CombineTotals(ExemptionsThisCoop,
                        OverallExemptions : TList);

var
  I, Index : Integer;
  ExemptionTotalsPtr : ExemptionTotalsPointer;

begin
  For I := 0 to (ExemptionsThisCoop.Count - 1) do
    begin
      Index := FindExemptionInList(OverallExemptions,
                                   ExemptionTotalsPointer(ExemptionsThisCoop[I])^.ExemptionCode);

      If (Index = -1)
        then
          begin
            New(ExemptionTotalsPtr);

            with ExemptionTotalsPtr^ do
              begin
                ExemptionCode := ExemptionTotalsPointer(ExemptionsThisCoop[I])^.ExemptionCode;
                SchoolAmount := 0;
                TownAmount := 0;
                CountyAmount := 0;
                Count := 0;

              end;  {with ExemptionTotalsPtr^, ExemptionTable do}

            OverallExemptions.Add(ExemptionTotalsPtr);

            Index := FindExemptionInList(OverallExemptions,
                                         ExemptionTotalsPointer(ExemptionsThisCoop[I])^.ExemptionCode);

          end;  {If (Index = -1)}

      with ExemptionTotalsPointer(OverallExemptions[Index])^ do
        begin
          SchoolAmount := SchoolAmount +
                          ExemptionTotalsPointer(ExemptionsThisCoop[I])^.SchoolAmount;
          TownAmount := TownAmount +
                        ExemptionTotalsPointer(ExemptionsThisCoop[I])^.TownAmount;
          CountyAmount := CountyAmount +
                          ExemptionTotalsPointer(ExemptionsThisCoop[I])^.CountyAmount;
          Count := Count + ExemptionTotalsPointer(ExemptionsThisCoop[I])^.Count;

        end;  {with ExemptionTotalsPtr^, ExemptionTable do}

    end;  {For I := 0 to (ExemptionsThisCoop.Count - 1) do}

end;  {CombineTotals}

{===================================================================}
Procedure SortExemptionTotals(ExemptionsThisCoop : TList);

var
  I, J : Integer;
  ExemptionTotalsPtr : ExemptionTotalsPointer;

begin
  For I := 0 to (ExemptionsThisCoop.Count - 1) do
    For J := (I + 1) to (ExemptionsThisCoop.Count - 1) do
      If _Compare(ExemptionTotalsPointer(ExemptionsThisCoop[J])^.ExemptionCode,
                  ExemptionTotalsPointer(ExemptionsThisCoop[I])^.ExemptionCode, coLessThan)
        then
          begin
            ExemptionTotalsPtr := ExemptionTotalsPointer(ExemptionsThisCoop[I]);
            ExemptionsThisCoop[I] := ExemptionsThisCoop[J];
            ExemptionsThisCoop[J] := ExemptionTotalsPtr;

          end;  {If _Compare(ExemptionTotalsPointer ...}

end;  {SortExemptionTotals}

{===================================================================}
Procedure TCooperativeValuesTransferForm.PrintOneCoop(Sender : TObject;
                                                      OldCoopSBL : String;
                                                      AssessedValueThisCoop,
                                                      ParcelsThisCoop : LongInt;
                                                      ExemptionDetailList,
                                                      ExemptionsThisCoop : TList);

var
  I : Integer;
  TotalSchoolAmount,
  TotalTownAmount, TotalCountyAmount : LongInt;

begin
  TotalSchoolAmount := 0;
  TotalTownAmount := 0;
  TotalCountyAmount := 0;

  with Sender as TBaseReport do
    begin
      If (LinesLeft < 10)
        then NewPage;

      Println('');
      PrintCoopHeader(Sender);

      For I := 0 to (ExemptionsThisCoop.Count - 1) do
        with ExemptionTotalsPointer(ExemptionsThisCoop[I])^ do
          begin
            TotalSchoolAmount := TotalSchoolAmount + SchoolAmount;
            TotalTownAmount := TotalTownAmount + TownAmount;
            TotalCountyAmount := TotalCountyAmount + CountyAmount;

          end;  {with ExemptionTotalsPointer(ExemptionsThisCoop[I])^ do}

      Bold := True;
      If (Deblank(OldCoopSBL) = '')
        then Print(#9 + 'GRAND TOTALS:')
        else Print(#9 + ConvertSBLOnlyToDashDot(OldCoopSBL));

      Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               ParcelsThisCoop) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               AssessedValueThisCoop) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalCountyAmount) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalTownAmount) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalSchoolAmount));

      Bold := False;

      If (PrintDetails and
          (Deblank(OldCoopSBL) <> ''))
        then
          begin
            PrintDetailHeader(Sender);

            For I := 0 to (ExemptionDetailList.Count - 1) do
              with ExemptionDetailPointer(ExemptionDetailList[I])^ do
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
                          #9 + ExemptionCode +
                          #9 + FormatFloat(CurrencyDisplayNoDollarSign, CountyAmount) +
                          #9 + FormatFloat(CurrencyDisplayNoDollarSign, TownAmount) +
                          #9 + FormatFloat(CurrencyDisplayNoDollarSign, SchoolAmount));

                end;  {with ExemptionDetailPointer(ExemptionDetailList[I])^ do}

          end;  {If PrintDetails}

      Bold := False;

        {Now print the exemptions for this coop.}

      If (ExemptionsThisCoop.Count > 0)
        then
          begin
              {FXX04232009-13(4.20.1.1)[D336]: Allow for more room for coop exemption totals.}

            If (LinesLeft < 12)
              then NewPage;

            PrintSummaryHeader(Sender, OldCoopSBL, PrintDetails);

              {FXX04232009-14(4.20.1.1)[D1527]: Sort the exemption totals.}

            SortExemptionTotals(ExemptionsThisCoop);

            For I := 0 to (ExemptionsThisCoop.Count - 1) do
              with ExemptionTotalsPointer(ExemptionsThisCoop[I])^ do
                Println(#9 + ExemptionCode +
                        #9 + IntToStr(Count) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign, CountyAmount) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign, TownAmount) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign, SchoolAmount));

          end;  {with ExemptionTotalsPointer(ExemptionsThisCoop[I])^ do}

        {CHG05132010(2.24.2.2)[I7427]: Add an option for a page break between coops.}

      If bPageBreakBetweenCoops
      then NewPage;

    end;  {with Sender as TBaseReport do}

end;  {PrintOneCoop}

{===================================================================}
Procedure TCooperativeValuesTransferForm.UpdateOneCoop(SwisCode : String;
                                                       OldCoopSBL : String;
                                                       sThisCoopAccountNumber : String;
                                                       AssessedValueThisCoop : LongInt;
                                                       ExemptionsThisCoop : TList);

var
  I : Integer;
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
      begin
          {First delete all current exemptions on this parcel.}

        SetRangeOld(ParcelExemptionTable, ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                    [AssessmentYear, TempSwisSBLKey, '     '],
                    [AssessmentYear, TempSwisSBLKey, '99999']);

        DeleteTableRange(ParcelExemptionTable);

        For I := 0 to (ExemptionsThisCoop.Count - 1) do
          with ExemptionTotalsPointer(ExemptionsThisCoop[I])^, ParcelExemptionTable do
            begin
              try
                Insert;
                FieldByName('ExemptionCode').Text := ExemptionCode;
                FieldByName('TaxRollYr').Text := AssessmentYear;
                FieldByName('SwisSBLKey').Text := TempSwisSBlKey;
                FieldByName('InitialDate').AsDateTime := Date;

                If (TownAmount > 0)
                  then FieldByName('Amount').AsInteger := TownAmount
                  else
                    If (CountyAmount > 0)
                      then FieldByName('Amount').AsInteger := CountyAmount
                      else FieldByName('Amount').AsInteger := SchoolAmount;

                FieldByName('SchoolAmount').AsInteger := SchoolAmount;
                FieldByName('TownAmount').AsInteger := TownAmount;
                FieldByName('CountyAmount').AsInteger := CountyAmount;

                Post;
              except
                Cancel;
                SystemSupport(005, ParcelExemptionTable, 'Error inserting\updating main exemption record.',
                              UnitName, GlblErrorDlgBox);
              end;

            end;  {with ExemptionTotalsPointer(ExemptionsThisCoop[I])^ do}

      end
    else SystemSupport(010, tb_Parcel, 'Could not locate base parcel for ' + OldCoopSBL + ',',
                       UnitName, GlblErrorDlgBox);

end;  {UpdateOneCoop}

{===================================================================}
Procedure AddAnExemptionToDetailList(ExemptionDetailList : TList;
                                     CoopParcelTable : TTable;
                                     CoopParcelExemptionTable : TTable;
                                     CoopAssessmentTable : TTable);

var
  ExemptionDetailPtr : ExemptionDetailPointer;

begin
  New(ExemptionDetailPtr);

  with ExemptionDetailPtr^  do
    begin
      SwisSBLKey := CoopParcelExemptionTable.FieldByName('SwisSBLKey').Text;
      Owner := CoopParcelTable.FieldByName('Name1').AsString;
      Shares := CoopParcelTable.FieldByName('CoopShares').AsFloat;
      AssessedValue := CoopAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
      ExemptionCode := CoopParcelExemptionTable.FieldByName('ExemptionCode').Text;
      SchoolAmount := CoopParcelExemptionTable.FieldByName('SchoolAmount').AsInteger;
      CountyAmount := CoopParcelExemptionTable.FieldByName('CountyAmount').AsInteger;
      TownAmount := CoopParcelExemptionTable.FieldByName('TownAmount').AsInteger;

    end;  {with ExemptionDetailPtr^ do}

  ExemptionDetailList.Add(ExemptionDetailPtr);

end;  {AddAnExemptionToDetailList}

{===================================================================}
Procedure TCooperativeValuesTransferForm.ReportHeader(Sender: TObject);

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
      PrintCenter('Exemption Values Transferred to Main Roll', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;

    end;  {with Sender as TBaseReport do}

end;  {ReportHeader}

{===================================================================}
Procedure TCooperativeValuesTransferForm.ReportPrint(Sender: TObject);

{CHG11241997-2: Print an audit trail.}

var
  FirstTimeThrough, Done,
  DoneExemptionDetails,
  FirstTimeThroughExemptionDetails : Boolean;
  AssessmentYear, SwisSBLKey,
  SwisCode, OldCoopSBL, ThisCoopSBL, sThisCoopAccountNumber : String;
  ExemptionDetailList,
  ExemptionsThisCoop, OverallExemptions : TList;
  AssessedValueThisCoop, OverallAssessedValue,
  ParcelsThisCoop, OverallParcelCount : LongInt;
  I, iPos : Integer;

begin
  FirstTimeThrough := True;
  Done := False;
  OverallAssessedValue := 0;
  AssessedValueThisCoop := 0;
  ParcelsThisCoop := 0;
  OverallParcelCount := 0;
  ExemptionsThisCoop := TList.Create;
  OverallExemptions := TList.Create;
  ExemptionDetailList := TList.Create;
  AssessmentYear := GetTaxRollYearForProcessingType(ProcessingType);

  ProgressDialog.UserLabelCaption := 'Transferring Exemption Values.';
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
          CombineTotals(ExemptionsThisCoop, OverallExemptions);

          PrintOneCoop(Sender, OldCoopSBL, AssessedValueThisCoop,
                       ParcelsThisCoop, ExemptionDetailList, ExemptionsThisCoop);

          If not TrialRun
            then UpdateOneCoop(SwisCode, OldCoopSBL,
                               sThisCoopAccountNumber,
                               AssessedValueThisCoop,
                               ExemptionsThisCoop);

          AssessedValueThisCoop := 0;
          ParcelsThisCoop := 0;
          ClearTList(ExemptionsThisCoop, SizeOf(ExemptionTotalsRecord));
          ClearTList(ExemptionDetailList, SizeOf(ExemptionDetailRecord));

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

            SetRangeOld(CoopParcelExemptionTable,
                        ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                        [AssessmentYear, SwisSBLKey, '     '],
                        [AssessmentYear, SwisSBLKey, '99999']);

            DoneExemptionDetails := False;
            FirstTimeThroughExemptionDetails := True;
            CoopParcelExemptionTable.First;

            repeat
              If FirstTimeThroughExemptionDetails
                then FirstTimeThroughExemptionDetails := False
                else CoopParcelExemptionTable.Next;

              If CoopParcelExemptionTable.EOF
                then DoneExemptionDetails := True;

                {Update the totals for this coop and print them if they want it.}

              If not DoneExemptionDetails
                then
                  begin
                    UpdateExemptionList(CoopParcelExemptionTable, ExemptionsThisCoop);

                    If PrintDetails
                      then AddAnExemptionToDetailList(ExemptionDetailList,
                                                      CoopParcelTable,
                                                      CoopParcelExemptionTable,
                                                      CoopAssessmentTable);


                    If PrintToExcel
                    then
                    begin
                      with CoopParcelExemptionTable do
                      begin
                        WriteCommaDelimitedLine(ExtractFile,
                                                [ConvertSwisSBLToDashDot(SwisSBLKey),
                                                 CoopParcelTable.FieldByName('Name1').AsString,
                                                 FormatFloat(IntegerDisplay, CoopParcelTable.FieldByName('CoopShares').AsInteger),
                                                 FormatFloat(IntegerDisplay, CoopAssessmentTable.FieldByName('TotalAssessedVal').ASInteger)]);

                        iPos := slExemptionCodesUsed.IndexOf(FieldByName('ExemptionCode').AsString);

                        For I := 0 to (iPos - 1) do
                          WriteCommaDelimitedLine(ExtractFile,
                                                  ['', '', '']);

                        WritelnCommaDelimitedLine(ExtractFile,
                                                  [FieldByName('CountyAmount').AsFloat,
                                                   FieldByName('TownAmount').AsFloat,
                                                   FieldByName('SchoolAmount').AsFloat]);

                      end;  {with CoopParcelExemptionTable do}

                    end;  {If PrintToExcel}

                  end;  {If not DoneExemptionDetails}

            until DoneExemptionDetails;

            OldCoopSBL := ThisCoopSBL;

          end;  {with Sender as TBaseReport do}

    ReportCancelled := ProgressDialog.Cancelled;
    sThisCoopAccountNumber := CoopParcelTable.FieldByName('AccountNo').AsString;

  until (Done or ReportCancelled);

  ClearTList(ExemptionDetailList, SizeOf(ExemptionDetailRecord));

    {FXX04232009-12(4.20.1.1)[D269]: Do form feed before printing the totals.}

  If not ReportCancelled
    then
      begin
        with Sender as TBaseReport do
          NewPage;

        PrintOneCoop(Sender, '', OverallAssessedValue,
                     OverallParcelCount, ExemptionDetailList, OverallExemptions);

      end;  {If not ReportCancelled}

    {CHG01012004-1(MDT): Recalculate the roll totals once the transfer is done.}

  If not TrialRun
    then CreateRollTotals(ProcessingType, AssessmentYear,
                          ProgressDialog, Self,
                          False, True);

  ProgressDialog.Finish;

  FreeTList(ExemptionsThisCoop, SizeOf(ExemptionTotalsRecord));
  FreeTList(OverallExemptions, SizeOf(ExemptionTotalsRecord));
  FreeTList(ExemptionDetailList, SizeOf(ExemptionDetailRecord));

end;  {ReportPrint}

{===================================================================}
Procedure TCooperativeValuesTransferForm.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.