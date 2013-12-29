unit RProrataLetters;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls, OleCtnrs, Word97, OleServer,
  FileCtrl, UtilOLE, CheckLst;

type
  TProrataLettersForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    PageControl1: TPageControl;
    LetterOptionsTabSheet: TTabSheet;
    LettersTabSheet: TTabSheet;
    MergeLetterDefinitionsTable: TwwTable;
    LetterOleContainer: TOleContainer;
    Label2: TLabel;
    MergeFieldsAvailableTable: TTable;
    LettersGrid: TwwDBGrid;
    MergeLetterTable: TwwTable;
    LetterFileNameLabel: TDBText;
    Label4: TLabel;
    WordDocument: TWordDocument;
    WordApplication: TWordApplication;
    OLEItemNameTimer: TTimer;
    MergeLetterDataSource: TDataSource;
    Panel3: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    ProrataTable: TTable;
    ProrataDetailsTable: TTable;
    tb_ProrataExemptions: TTable;
    ParcelTable: TTable;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    CreateParcelListCheckBox: TCheckBox;
    PrintReportCheckBox: TCheckBox;
    ProrataYearEdit: TEdit;
    ReprintLettersCheckBox: TCheckBox;
    TrialRunCheckBox: TCheckBox;
    LetterDateEdit: TMaskEdit;
    CollectionTypeComboBox: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure MergeLetterTableAfterScroll(DataSet: TDataSet);
    procedure OLEItemNameTimerTimer(Sender: TObject);
    procedure LetterOleContainerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    ReportCancelled, CreateParcelList, PrintAllCollections,
    TrialRun, PrintReport, ReprintLetters, InitializingForm : Boolean;
    UnitName, LetterName, ProrataYear, Category, CollectionType : String;
    MergeFieldsToPrint, LettersPrinted : TStringList;
    LetterDate : TDateTime;

    Procedure InitializeForm;
    Procedure PrintLetters;

  end;

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
     DataAccessUnit;

{$R *.DFM}
{========================================================}
Procedure TProrataLettersForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TProrataLettersForm.InitializeForm;

begin
  UnitName := 'RProrataLetters';  {mmm}

  InitializingForm := True;
  OpenTablesForForm(Self, NextYear);

  MergeFieldsToPrint := TStringList.Create;
  LettersPrinted := TStringList.Create;

  ProrataYearEdit.Text := IntToStr(GetYearFromDate(Date));
  LetterDateEdit.Text := DateToStr(Date);
  InitializingForm := False;

  MergeLetterTableAfterScroll(MergeLetterTable);

end;  {InitializeForm}

{===================================================================}
Procedure TProrataLettersForm.FormKeyPress(    Sender: TObject;
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
Procedure TProrataLettersForm.OLEItemNameTimerTimer(Sender: TObject);

begin
  If GlblApplicationIsActive
    then
      begin
        OLEItemNameTimer.Enabled := False;
        MergeLetterTableAfterScroll(MergeLetterTable);
      end
    else
      If (MergeLetterTable.State in [dsEdit, dsInsert])
        then
          try
            MergeLetterTable.FieldByName('FileName').Text := WordDocument.FullName;
          except
          end;

end;  {OLEItemNameTimerTimer}

{========================================================================}
Procedure TProrataLettersForm.MergeLetterTableAfterScroll(DataSet: TDataSet);

var
  TemplateName : OLEVariant;

begin
  If not InitializingForm
    then
      begin
        TemplateName := MergeLetterTable.FieldByName('FileName').Text;

          {FXX07252002-2: Make sure to have a try..except around the container create.}

        If (Deblank(MergeLetterTable.FieldByName('LetterName').Text) <> '')
          then
            try
              LetterOLEContainer.CreateObjectFromFile(TemplateName, False);
            except
              LetterOLEContainer.DestroyObject;
              LetterOLEContainer.SizeMode := smClip;
              LetterOLEContainer.CreateObjectFromFile(TemplateName, False);
            end;

        _SetRange(MergeLetterDefinitionsTable, [MergeLetterTable.FieldByName('LetterName').Text],
                  [], '', [loSameEndingRange]);

      end;  {If not InitializingForm}

end;  {MergeLetterTableAfterScroll}

{======================================================================}
Procedure TProrataLettersForm.LetterOleContainerMouseDown(Sender: TObject;
                                                            Button: TMouseButton;
                                                            Shift: TShiftState;
                                                            X, Y: Integer);

{Bring up the document for editing.}

var
  FileName : OLEVariant;

begin
  FileName := MergeLetterTable.FieldByName('FileName').Text;

  try
    LetterOLEContainer.DestroyObject;
  except
  end;

  OpenWordDocument(WordApplication, WordDocument, FileName);

end;  {LetterOleContainerMouseDown}

{======================================================================}
Procedure AddMergeFieldsToExtractFile(var LetterExtractFile : TextFile;
                                          MergeFieldsToPrint : TStringList;
                                          ProrataTable : TTable;
                                          MergeFieldsAvailableTable : TTable;
                                          tb_ProrataExemptions : TTable;
                                          Form : TForm;
                                          LetterDate : TDateTime;
                                          CountyProrataAmount : Double;
                                          MunicipalProrataAmount : Double;
                                          SchoolProrataAmount : Double;
                                      var CountyProrataPrinted : Boolean;
                                      var MunicipalProrataPrinted : Boolean;
                                      var SchoolProrataPrinted : Boolean);

var
  Handled : Boolean;
  I, J : Integer;
  FieldValue, MergeFieldName, _TableName,
  ProrataYear, SwisSBLKey, Category : String;
  NAddrArray : NameAddrArray;
  TempTable : TTable;
  sl_Exemptions : TStringList;

begin
  Handled := False;
  CountyProrataPrinted := False;
  MunicipalProrataPrinted := False;
  SchoolProrataPrinted := False;
  ProrataTable.CancelRange;

  with ProrataTable do
    begin
      ProrataYear := FieldByName('ProrataYear').Text;
      SwisSBLKey := FieldByName('SwisSBLKey').Text;
      Category := FieldByName('Category').Text;

    end;  {with ProrataTable do}

  with ProrataTable do
    FillInNameAddrArray(FieldByName('Name1').Text,
                        FieldByName('Name2').Text,
                        FieldByName('Address1').Text,
                        FieldByName('Address2').Text,
                        FieldByName('Street').Text,
                        FieldByName('City').Text,
                        FieldByName('State').Text,
                        FieldByName('Zip').Text,
                        FieldByName('ZipPlus4').Text,
                        True, False, NAddrArray);

  For I := 0 to (MergeFieldsToPrint.Count - 1) do
    begin
      FindKeyOld(MergeFieldsAvailableTable, ['MergeFieldName'],
                 [MergeFieldsToPrint[I]]);

      with MergeFieldsAvailableTable do
        begin
          MergeFieldName := FieldByName('MergeFieldName').Text;
          _TableName := FieldByName('TableName').Text;
          FieldValue := '';

          If (FieldByName('TableName').Text = 'Special')
            then
              begin
                If (MergeFieldName = 'ThisYear')
                  then FieldValue := GlblThisYear;

                If (MergeFieldName = 'NextYear')
                  then FieldValue := GlblNextYear;

                If (MergeFieldName = 'SwisCode')
                  then FieldValue := Copy(SwisSBLKey, 1, 6);

                If (MergeFieldName = 'ParcelID')
                  then FieldValue := ConvertSwisSBLToDashDot(SwisSBLKey);

                If (MergeFieldName = 'ParcelID_No_Swis')
                  then FieldValue := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                If (MergeFieldName = 'LegalAddress')
                  then FieldValue := GetLegalAddressFromTable(ProrataTable);

                If (MergeFieldName = 'Name1')
                  then FieldValue := NAddrArray[1];

                If (MergeFieldName = 'Name2')
                  then FieldValue := NAddrArray[2];

                If (MergeFieldName = 'Address1')
                  then FieldValue := NAddrArray[3];

                If (MergeFieldName = 'Address2')
                  then FieldValue := NAddrArray[4];

                If (MergeFieldName = 'Address3')
                  then FieldValue := NAddrArray[5];

                If (MergeFieldName = 'Address4')
                  then FieldValue := NAddrArray[6];

                If (MergeFieldName = 'LetterDate')
                  then FieldValue := DateToStr(LetterDate);

                If _Compare(MergeFieldName, 'CountyProrataAmount', coEqual)
                  then
                    begin
                      FieldValue := FormatFloat(CurrencyDecimalDisplay, CountyProrataAmount);
                      MunicipalProrataPrinted := True;

                    end;  {If _Compare(MergeFieldName, 'CountyProrataAmount', coEqual)}

                If _Compare(MergeFieldName, 'MunicipalProrataAmount', coEqual)
                  then
                    begin
                      FieldValue := FormatFloat(CurrencyDecimalDisplay, MunicipalProrataAmount);
                      MunicipalProrataPrinted := True;

                    end;  {If _Compare(MergeFieldName, 'MunicipalProrataAmount', coEqual)}

                If _Compare(MergeFieldName, 'SchoolProrataAmount', coEqual)
                  then
                    begin
                      FieldValue := FormatFloat(CurrencyDecimalDisplay, SchoolProrataAmount);
                      SchoolProrataPrinted := True;

                    end;  {If _Compare(MergeFieldName, 'SchoolProrataAmount', coEqual)}

                If _Compare(MergeFieldName, 'TotalProrataAmount', coEqual)
                  then FieldValue := FormatFloat(CurrencyDecimalDisplay,
                                                 (CountyProrataAmount + MunicipalProrataAmount + SchoolProrataAmount));

                If _Compare(MergeFieldName, 'ProrataExemptions', coEqual)
                  then
                    begin
                      sl_Exemptions := TStringList.Create;

                      FillDistinctStringListFromTable(sl_Exemptions, tb_ProrataExemptions,
                                                      'ExemptionCode', 5, True);
                      FieldValue := StringListToString(sl_Exemptions, ';');
                      sl_Exemptions.Free;

                    end;  {If _Compare(MergeFieldName, 'MunicipalProrataAmount', coEqual)}

              end
            else
              If not Handled
                then
                  begin
                    TempTable := nil;

                    For J := 0 to (Form.ComponentCount - 1) do
                      If ((Form.Components[J] is TTable) and
                          _Compare(TTable(Form.Components[J]).TableName, _TableName, coEqual))
                        then TempTable := TTable(Form.Components[J]);

                    If (TempTable <> nil)
                      then FieldValue := TempTable.FieldByName(MergeFieldsAvailableTable.FieldByName('FieldName').Text).Text;

                  end;  {If not Handled}

        end;  {with MergeFieldsAvailableTable do}

      If (I > 0)
        then Write(LetterExtractFile, ',');

      Write(LetterExtractFile, '"', FieldValue, '"');

    end;  {For I := 0 to (MergeFieldsToAdd.Count - 1) do}

  Writeln(LetterExtractFile);

end;  {AddMergeFieldsToExtractFile}

{======================================================================}
Function CategoryMeetsCollectionTypeRequirements(CollectionType : String;
                                                 Category : String) : Boolean;

begin
  Result := False;

  If (_Compare(CollectionType, CountyTaxType, coEqual) and
      _Compare(Category, mtfnCounty, coEqual))
    then Result := True;

  If (_Compare(CollectionType, [MunicipalTaxType, TownTaxType, VillageTaxType], coEqual) and
      _Compare(Category, [mtfnCity, mtfnTown, mtfnVillage], coEqual))
    then Result := True;

  If (_Compare(CollectionType, SchoolTaxType, coEqual) and
      _Compare(Category, mtfnSchool, coEqual))
    then Result := True;

  If (_Compare(CollectionType, SchoolMunicipalTaxType, coEqual) and
      _Compare(Category, [mtfnSchool, mtfnCity, mtfnTown, mtfnVillage], coEqual))
    then Result := True;

end;  {CategoryMeetsCollectionTypeRequirements}

{======================================================================}
Function LetterPrintedForCategory(ProrataTable : TTable;
                                  CollectionType : String) : Boolean;

begin
  Result := False;

  with ProrataTable do
    begin
      If (_Compare(CollectionType, mtfnCounty, coEqual) and
          _Compare(FieldByName('CountyLetterDate').AsString, coNotBlank))
        then Result := True;

      If (_Compare(CollectionType, [mtfnCity, mtfnTown, mtfnVillage], coEqual) and
          _Compare(FieldByName('MunicipalLetterDate').AsString, coNotBlank))
        then Result := True;

      If (_Compare(CollectionType, [mtfnSchool, mtfnSchoolMunicipal], coEqual) and
          _Compare(FieldByName('SchoolLetterDate').AsString, coNotBlank))
        then Result := True;

    end;  {with ProrataTable do}

end;  {LetterPrintedForCategory}

{======================================================================}
Function PrintThisLetter(    ProrataTable : TTable;
                             ProrataDetailsTable : TTable;
                             SwisSBLKey : String;
                             ProrataYear : String;
                             Category : String;
                             CollectionType : String;
                             ReprintLetters : Boolean;
                             PrintAllCollections : Boolean;
                         var MunicipalCategoryCode : String;
                         var CountyProrataAmount : Double;
                         var MunicipalProrataAmount : Double;
                         var SchoolProrataAmount : Double) : Boolean;

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

  _SetRange(ProrataTable, [SwisSBLKey, ProrataYear, ''], [SwisSBLKey, ProrataYear, 'zzzzz'], '', []);

  ProrataTable.First;

  with ProrataTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If ((not Done) and
          (PrintAllCollections or
           CategoryMeetsCollectionTypeRequirements(CollectionType, FieldByName('Category').Text)) and
          (ReprintLetters or
           (not LetterPrintedForCategory(ProrataTable, FieldByName('Category').Text))))
        then
          begin
            _SetRange(ProrataDetailsTable,
                      [FieldByName('SwisSBLKey').Text,
                       FieldByName('ProrataYear').Text,
                       FieldByName('Category').Text], [], '', [loSameEndingRange]);

            ProrataAmount := SumTableColumn(ProrataDetailsTable, 'TaxAmount');

            If (PrintAllCollections or
                _Compare(CollectionType, SchoolMunicipalTaxType, coEqual))
              then Category := FieldByName('Category').AsString;

            If _Compare(Category, mtfnCity, coEqual)
              then
                begin
                  MunicipalProrataAmount := ProrataAmount;
                  MunicipalCategoryCode := mtfnCity;
                end;

            If _Compare(Category, mtfnTown, coEqual)
              then
                begin
                  MunicipalProrataAmount := ProrataAmount;
                  MunicipalCategoryCode := mtfnTown;
                end;

            If _Compare(Category, mtfnVillage, coEqual)
              then
                begin
                  MunicipalProrataAmount := ProrataAmount;
                  MunicipalCategoryCode := mtfnVillage;
                end;

            If _Compare(Category, mtfnSchool, coEqual)
              then SchoolProrataAmount := ProrataAmount;

            If _Compare(Category, mtfnSchoolMunicipal, coEqual)
              then
                begin
                  SchoolProrataAmount := ProrataAmount;

                  _SetRange(ProrataDetailsTable,
                            [FieldByName('SwisSBLKey').Text,
                             FieldByName('ProrataYear').Text,
                             ANSIUpperCase(mtfnTown)], [], '', [loSameEndingRange]);

                  MunicipalProrataAmount := SumTableColumn(ProrataDetailsTable, 'TaxAmount');

                end;  {If _Compare(Category, mtfnSchoolMunicipal, coEqual)}

            If _Compare(Category, mtfnCounty, coEqual)
              then CountyProrataAmount := ProrataAmount;

            Result := True;

          end;  {If ((not Done) and ...}

    until Done;

end;  {PrintThisLetter}

{======================================================================}
Procedure MarkProrataPrinted(ProrataTable : TTable;
                             ProrataYear : String;
                             SwisSBLKey : String;
                             Category : String;
                             CountyProrataPrinted : Boolean;
                             MunicipalProrataPrinted : Boolean;
                             SchoolProrataPrinted : Boolean;
                             LetterDate : TDateTime);

begin
  If _Locate(ProrataTable, [SwisSBLKey, ProrataYear, ANSIUpperCase(Category)], '', [])
    then
      with ProrataTable do
        try
          Edit;

          If CountyProrataPrinted
            then FieldByName('CountyLetterDate').AsDateTime := LetterDate;
          If MunicipalProrataPrinted
            then FieldByName('MunicipalLetterDate').AsDateTime := LetterDate;
          If SchoolProrataPrinted
            then FieldByName('SchoolLetterDate').AsDateTime := LetterDate;

          Post;
        except
        end;

end;  {MarkProrataPrinted}

{======================================================================}
Procedure TProrataLettersForm.PrintLetters;

var
  Done, FirstTimeThrough,
  CountyProrataPrinted, MunicipalProrataPrinted, SchoolProrataPrinted : Boolean;
  LetterExtractFile : TextFile;
  FileExtension, NewFileName,
  LetterExtractFileName, SwisSBLKey, MunicipalCategoryCode : String;
  I, ExtensionPos : Integer;
  CountyProrataAmount, MunicipalProrataAmount, SchoolProrataAmount : Double;

begin
  FirstTimeThrough := True;
  LetterExtractFileName := GetPrintFileName(Caption, True);

  try
    AssignFile(LetterExtractFile, LetterExtractFileName);
    Rewrite(LetterExtractFile);
  except
    SystemSupport(001, ProrataTable, 'Error creating linked text file.',
                  UnitName, GlblErrorDlgBox);
  end;

    {Create the header record.}

  For I := 0 to (MergeFieldsToPrint.Count - 1) do
    begin
      If (I > 0)
        then Write(LetterExtractFile, ',');

      Write(LetterExtractFile, '"', MergeFieldsToPrint[I], '"');

    end;  {For I := 0 to (MergeFieldsToPrint.Count - 1) do}

  Writeln(LetterExtractFile);

  ParcelTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    Done := ParcelTable.EOF;

    SwisSBLKey := ExtractSSKey(ParcelTable);
    ProgressDialog.Update(Self, 'Parcel ID = ' + ConvertSwisSBLToDashDot(SwisSBLKey));
    ProgressDialog.UserLabelCaption := 'Proratas Printed = ' + IntToStr(LettersPrinted.Count);
    Application.ProcessMessages;

    If ((not Done) and
        PrintThisLetter(ProrataTable, ProrataDetailsTable, SwisSBLKey, ProrataYear, Category,
                        CollectionType, ReprintLetters, PrintAllCollections, MunicipalCategoryCode,
                        CountyProrataAmount, MunicipalProrataAmount, SchoolProrataAmount))
      then
        begin
          LettersPrinted.Add(SwisSBLKey);

          _SetRange(tb_ProrataExemptions, [SwisSBLKey, ProrataYear, Category], [], '', [loSameEndingRange]);

          AddMergeFieldsToExtractFile(LetterExtractFile, MergeFieldsToPrint,
                                      ProrataTable, MergeFieldsAvailableTable,
                                      tb_ProrataExemptions, Self, LetterDate,
                                      CountyProrataAmount, MunicipalProrataAmount, SchoolProrataAmount,
                                      CountyProrataPrinted, MunicipalProrataPrinted, SchoolProrataPrinted);

            {Mark that this letter was mailed.}

          If not TrialRun
            then
              begin
                ProrataTable.CancelRange;
                If CountyProrataPrinted
                  then MarkProrataPrinted(ProrataTable, ProrataYear, SwisSBLKey, Category,
                                          CountyProrataPrinted, MunicipalProrataPrinted, SchoolProrataPrinted, LetterDate);

                If MunicipalProrataPrinted
                  then MarkProrataPrinted(ProrataTable, ProrataYear, SwisSBLKey, Category,
                                          CountyProrataPrinted, MunicipalProrataPrinted, SchoolProrataPrinted, LetterDate);

                If SchoolProrataPrinted
                  then MarkProrataPrinted(ProrataTable, ProrataYear, SwisSBLKey, Category,
                                          CountyProrataPrinted, MunicipalProrataPrinted, SchoolProrataPrinted, LetterDate);

              end;  {If not TrialRun}

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

  ProgressDialog.Finish;
  CloseFile(LetterExtractFile);

  If not ReportCancelled
    then
      If (LettersPrinted.Count = 0)
        then MessageDlg('There were no prorata letters to print.',
                        mtWarning, [mbOK], 0)
        else
          begin
            SendTextFileToExcelSpreadsheet(LetterExtractFileName, False,
                                           True, ChangeFileExt(LetterExtractFileName, '.XLS'));

            FileExtension := ExtractFileExt(MergeLetterTable.FieldByName('FileName').Text);
            NewFileName := MergeLetterTable.FieldByName('FileName').Text;
            ExtensionPos := Pos(FileExtension, NewFileName);
            Delete(NewFileName, ExtensionPos, 200);
            NewFileName := NewFileName + '_Template' + FileExtension;

            CopyOneFile(MergeLetterTable.FieldByName('FileName').Text, NewFileName);

            PerformWordMailMerge(NewFileName,
                                 ChangeFileExt(LetterExtractFileName, '.XLS'));

          end;  {If not ReportCancelled}

end;  {PrintLetters}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TProrataLettersForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  Quit : Boolean;

begin
  PrintAllCollections := False;

  case CollectionTypeComboBox.ItemIndex of
    0 : CollectionType := MunicipalTaxType;
    1 : CollectionType := CountyTaxType;
    2 : CollectionType := SchoolTaxType;
    3 : CollectionType := SchoolMunicipalTaxType;
    4 : CollectionType := VillageTaxType;
    5 : PrintAllCollections := True;

  end;  {case CollectionTypeComboBox of}

  If not PrintAllCollections
    then Category := GetCollectionTypeCategory(CollectionType);

  try
    LetterOLEContainer.DestroyObject;
  except
  end;

  ReportCancelled := False;
  Quit := False;

  ProrataYear := ProrataYearEdit.Text;
  PrintReport := PrintReportCheckBox.Checked;
  ReprintLetters := ReprintLettersCheckBox.Checked;
  TrialRun := TrialRunCheckBox.Checked;
  CreateParcelList := CreateParcelListCheckBox.Checked;
  LetterName := MergeLetterTable.FieldByName('LetterName').Text;

  try
    LetterDate := StrToDate(LetterDateEdit.Text);
  except
    LetterDate := Date;
  end;

  LettersPrinted.Clear;
  _SetRange(MergeLetterDefinitionsTable, [LetterName], [], '', [loSameEndingRange]);
  FillStringListFromTableField(MergeFieldsToPrint, MergeLetterDefinitionsTable, 'MergeFieldName');

  If (MessageDlg('Are you sure you want to print the ' + MergeLetterTable.FieldByName('LetterName').Text + ' letter?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        ProgressDialog.UserLabelCaption := '';
        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
        PrintLetters;

        SetPrintToScreenDefault(PrintDialog);

        If (PrintReport and
            PrintDialog.Execute)
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
                          ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

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

                                ShowReportDialog('Prorata Letters.RPT', NewFileName, True);

                              end
                            else ReportPrinter.Execute;

                        end;  {If not Quit}

                    ProgressDialog.Finish;

                  end;  {If not Quit}

              ResetPrinter(ReportPrinter);

            end;  {If PrintDialog.Execute}

        MergeLetterTableAfterScroll(MergeLetterTable);

      end;  {If (MessageDlg...}

end;  {PrintButtonClick}

{====================================================================}
Procedure TProrataLettersForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);

        {Print the date and page number.}

      SetFont('Times New Roman',8);
      Println('');
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '    ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman',14);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Prorata Letters Printed Report', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',10);
      Bold := True;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.0, 0, BoxLineBottom, 0);

      Println(#9 + 'Letter printed: ' + MergeLetterTable.FieldByName('LetterName').Text);

      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BoxLineNone, 0);
      SetTab(2.3, pjLeft, 2.0, 0, BoxLineNone, 0);
      SetTab(4.3, pjLeft, 2.0, 0, BoxLineNone, 0);

      Println('');
      Println('');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{====================================================================}
Procedure TProrataLettersForm.ReportPrint(Sender: TObject);

var
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      For I := 0 to (LettersPrinted.Count - 1) do
        begin
          If ((I mod 3) = 0)
            then Println('');

          If (LinesLeft < 5)
            then NewPage;

          Print(#9 + ConvertSwisSBLToDashDot(LettersPrinted[I]));

        end;  { For I := 0 to (LettersPrinted.Count - 1) do}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TProrataLettersForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TProrataLettersForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  MergeFieldsToPrint.Free;
  CloseTablesForForm(Self);

  Action := caFree;

  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.