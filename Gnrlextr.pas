unit Gnrlextr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids, Types,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, TabNotBk,
  ComCtrls;

type
  TGeneralizedExtractForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    ExtractSaveDialog: TSaveDialog;
    LoadButton: TBitBtn;
    SaveOptionsButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    TabbedNotebook1: TTabbedNotebook;
    Label2: TLabel;
    ScreenListBox: TListBox;
    Label3: TLabel;
    FieldListBox: TListBox;
    AddFieldsButton: TBitBtn;
    RemoveFieldsButton: TBitBtn;
    DefinedListBox: TListBox;
    MoveUpButton: TBitBtn;
    MoveDownButton: TBitBtn;
    Label1: TLabel;
    UserFieldDefinitionTable: TTable;
    ScreenLabelTable: TTable;
    AssessmentYearRadioGroup: TRadioGroup;
    ExtractTypeRadioGroup: TRadioGroup;
    AddSeperatorButton: TBitBtn;
    ParcelTable: TTable;
    ClearButton: TBitBtn;
    LineHeaderRadioGroup: TRadioGroup;
    MiscellaneousOptionsGroupBox: TGroupBox;
    AddRecordTypeCheckBox: TCheckBox;
    LoadFromParcelListCheckBox: TCheckBox;
    SeperateLinesForMultipleRecordsCheckBox: TCheckBox;
    PutHeaderCheckBox: TCheckBox;
    ActiveParcelCheckBox: TCheckBox;
    IncludeSwisOnParcelIDCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure AddFieldsButtonClick(Sender: TObject);
    procedure ScreenListBoxClick(Sender: TObject);
    procedure MoveUpButtonClick(Sender: TObject);
    procedure MoveDownButtonClick(Sender: TObject);
    procedure RemoveFieldsButtonClick(Sender: TObject);
    procedure AddSeperatorButtonClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveOptionsButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ScreenLabelList : TList;
    IncludeSwisOnParcelID,
    LoadFromParcelList, ActiveParcelsOnly,
    IncludeRecordType, IncludeHeaderLine,
    SeperateLinesForMultipleRecords, Cancelled : Boolean;
    ProcessingType, ExtractFileType, FirstFieldsOnLine : Integer;
    Procedure InitializeForm;  {Open the tables and setup.}

    Function GetTableName(Item : String) : String;
    Function GetFieldName(Item : String) : String;
    Procedure WriteThisScreen(var ExtractFile : TextFile;
                                  TableList : TList;
                                  FieldNameList,
                                  TableNameList : TStringList;
                                  ProcessingType  : Integer;
                                  AssessmentYear : String;
                                  SwisSBLKey : String;
                              var Index : Integer;
                              var FirstFieldOnLine,
                                  FieldsWritten : Boolean;
                                  SeperateRecords : Boolean);

    Procedure WriteHeaderLine(var ExtractFile : TextFile);
    Procedure CreateExtractFile(var ExtractFile : TextFile);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, PASTypes, Prog,
     PrclList;

{$R *.DFM}

const
  Seperator = '---------------';

  ftCommaDelimited = 1;
  ftColumnar = 0;

  ffSwisSBL = 0;
  ffPrintKey = 1;
  ffSwisSBL_PrintKey = 2;
  ffPrintKey_SwisSBL = 3;

{========================================================}
Procedure TGeneralizedExtractForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TGeneralizedExtractForm.InitializeForm;

var
  I : Integer;

begin
  UnitName := 'GNRLEXTR';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

  If (GlblProcessingType = History)
    then SetRangeOld(UserFieldDefinitionTable, ['TaxRollYr', 'DisplayOrder'],
                     [GlblHistYear, '0'], [GlblHistYear, '9999']);

  ScreenLabelList := TList.Create;

  LoadScreenLabelList(ScreenLabelList, ScreenLabelTable, UserFieldDefinitionTable, True,
                      False, False, [slAll]);

  ScreenListBox.Items.Clear;

  For I := 0 to (ScreenLabelList.Count - 1) do
    If (ScreenListBox.Items.IndexOf(RTrim(ScreenLabelPtr(ScreenLabelList[I])^.ScreenName)) = -1)
      then ScreenListBox.Items.Add(RTrim(ScreenLabelPtr(ScreenLabelList[I])^.ScreenName));

  ExtractSaveDialog.InitialDir := GlblExportDir;

  If (GlblProcessingType = NextYear)
    then AssessmentYearRadioGroup.ItemIndex := 1
    else AssessmentYearRadioGroup.ItemIndex := 0;

end;  {InitializeForm}

{===================================================================}
Procedure TGeneralizedExtractForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{==========================================================================}
Function GetSelectedItem(ListBox : TListBox) : Integer;

var
  I : Integer;

begin
  Result := -1;

  with ListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then Result := I;

end;  {GetSelectedItem}

{==========================================================================}
Procedure TGeneralizedExtractForm.ScreenListBoxClick(Sender: TObject);

var
  I(*, ScreenSelectedIndex*) : Integer;

begin
//  ScreenSelectedIndex := GetSelectedItem(ScreenListBox);
  FieldListBox.Items.Clear;

  For I := 0 to (ScreenLabelList.Count - 1) do
    If (RTrim(ScreenLabelPtr(ScreenLabelList[I])^.ScreenName) =
        ScreenListBox.Items[ScreenListBox.ItemIndex])
      then FieldListBox.Items.Add(RTrim(ScreenLabelPtr(ScreenLabelList[I])^.LabelName));

end;  {ScreenListBoxClick}

{==========================================================================}
Procedure TGeneralizedExtractForm.AddFieldsButtonClick(Sender: TObject);

var
  I, ScreenSelectedIndex : Integer;

begin
  ScreenSelectedIndex := GetSelectedItem(ScreenListBox);

  If (ScreenSelectedIndex > -1)
    then
      with FieldListBox do
        For I := 0 to (Items.Count - 1) do
          If Selected[I]
            then
              begin
                DefinedListBox.Items.Add(ScreenListBox.Items[ScreenSelectedIndex] + '\' +
                                         FieldListBox.Items[I]);
                DefinedListBox.ItemIndex := DefinedListBox.Items.Count - 1;
              end;

end;  {AddFieldsButtonClick}

{====================================================================}
Procedure TGeneralizedExtractForm.RemoveFieldsButtonClick(Sender: TObject);

begin
  DefinedListBox.Items.Delete(DefinedListBox.ItemIndex);
end;

{==================================================================}
Procedure TGeneralizedExtractForm.MoveUpButtonClick(Sender: TObject);

var
  TempStr : String;
  Index : Integer;

begin
  Index := GetSelectedItem(DefinedListBox);

  with DefinedListBox do
    If (Index > 0)
      then
        begin
          TempStr := Items[Index];
          Items[Index] := Items[Index - 1];
          Items[Index - 1] := TempStr;
          Index := Index - 1;
          ItemIndex := Index;

        end;  {If (ItemIndex > 0)}

end;  {MoveUpButtonClick}

{======================================================================}
Procedure TGeneralizedExtractForm.MoveDownButtonClick(Sender: TObject);

var
  TempStr : String;
  Index : Integer;

begin
  Index := GetSelectedItem(DefinedListBox);

  with DefinedListBox do
    If (Index < (Items.Count - 1))
      then
        begin
          TempStr := Items[Index];
          Items[Index] := Items[Index + 1];
          Items[Index + 1] := TempStr;
          Index := Index + 1;
          ItemIndex := Index;

        end;  {If (Index < (Items.Count - 1))}

end;  {MoveDownButtonClick}

{====================================================================}
Procedure TGeneralizedExtractForm.AddSeperatorButtonClick(Sender: TObject);

var
  Index : Integer;

begin
  Index := GetSelectedItem(DefinedListBox);

    {If there are no fields selected, then add it to the end.}

  If (Index = -1)
    then Index := DefinedListBox.Items.Count - 2;

  with DefinedListBox do
    begin
      Items.Insert((Index + 1), Seperator);
      ItemIndex := Index;
    end;

end;  {AddSeperatorButtonClick}

{================================================================}
Procedure TGeneralizedExtractForm.ClearButtonClick(Sender: TObject);

{FXX03012000-1: Add a clear button to the screen.}

begin
  DefinedListBox.Items.Clear;
end;

{==========================================================}
Procedure TGeneralizedExtractForm.LoadButtonClick(Sender: TObject);

{FXX03012000-2: Clear defined items before load new ones.}

begin
  ClearButtonClick(Sender);
  LoadReportOptions(Self, OpenDialog, 'genextr.ext', 'Generalized Extract');
end;

{==========================================================}
Procedure TGeneralizedExtractForm.SaveOptionsButtonClick(Sender: TObject);

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'genextr.ext', 'Generalized Extract');
end;

{===============================================================}
Procedure TGeneralizedExtractForm.StartButtonClick(Sender: TObject);

var
  ExtractFile : TextFile;
  FileName : String;
  Quit : Boolean;

begin
  If ExtractSaveDialog.Execute
    then
      begin
        Cancelled := False;
        FileName := ExtractSaveDialog.FileName;

        case AssessmentYearRadioGroup.ItemIndex of
          0 : ProcessingType := ThisYear;
          1 : ProcessingType := NextYear;
        end;

        IncludeRecordType := AddRecordTypeCheckBox.Checked;
        IncludeHeaderLine := PutHeaderCheckBox.Checked;
        LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
        ActiveParcelsOnly := ActiveParcelCheckBox.Checked;
        SeperateLinesForMultipleRecords := SeperateLinesForMultipleRecordsCheckBox.Checked;
        ExtractFileType := ExtractTypeRadioGroup.ItemIndex;

          {CHG03012000-1: Allow choice of parcel ID type.}

        FirstFieldsOnLine := LineHeaderRadioGroup.ItemIndex;

          {CHG10162003-1(2.07j1): Allow them to not include the swis on the parcel ID.}

        IncludeSwisOnParcelID := IncludeSwisOnParcelIDCheckBox.Checked;

        OpenTableForProcessingType(ParcelTable, ParcelTableName, ProcessingType, Quit);

        AssignFile(ExtractFile, FileName);
        Rewrite(ExtractFile);

        CreateExtractFile(ExtractFile);

        CloseFile(ExtractFile);

        If Cancelled
          then MessageDlg('The file ' + FileName + ' was not completed.',
                          mtWarning, [mbOK], 0)
          else MessageDlg('The file ' + FileName + ' was created succesfully.',
                          mtInformation, [mbOK], 0);

(*        TempStr := 'C:\Progra~1\Micros~1\Office\EXCEL.EXE ' + FileName;

        GetMem(TempPChar, Length(TempStr) + 1);
        StrPCopy(TempPChar, TempStr);
        ReturnCode := WinExec(TempPChar, SW_Show);
        FreeMem(TempPChar, Length(TempStr) + 1);

        If (ReturnCode < 32)
          then MessageDlg('Word pad failed to bring up the report. Error = ' + IntToStr(ReturnCode) + '.',
                          mtError, [mbOK], 0);*)

      end;  {If ExtractSaveDialog.Execute}

end;  {StartButtonClick}

{===============================================================}
Procedure WriteOneField(var ExtractFile : TextFile;
                            Value : String;
                            Size : Integer;
                            ExtractFileType : Integer;
                        var FirstFieldOnLine : Boolean);

begin
  If FirstFieldOnLine
    then FirstFieldOnLine := False
    else
      If (ExtractFileType = ftCommaDelimited)
        then Write(ExtractFile, ',');  {Insert comma between fields}

  case ExtractFileType of
    ftCommaDelimited : Write(ExtractFile, '"', RTrim(Value), '"');

    ftColumnar : Write(ExtractFile, Take(Size, Value));

  end;  {case ExtractFileType of}

end;  {WriteOneField}

{===============================================================}
Function GetScreenName(Item : String) : String;

{Get the screen listed in the extract item.}

var
  Index : Integer;

begin
  Index := Pos('\', Item);
  Result := Copy(Item, 1, (Index - 1));

end;  {GetScreenName}

{===============================================================}
Function GetLabelName(Item : String) : String;

{Get the label listed in the extract item.}

var
  Index : Integer;

begin
  Index := Pos('\', Item);
  Result := RTrim(Copy(Item, (Index + 1), 30));

end;  {GetLabelName}

{===============================================================}
Function TGeneralizedExtractForm.GetTableName(Item : String) : String;

{Get the table for the screen listed in the extract item.}

var
  ScreenName : String;
  I : Integer;

begin
  Result := '';

  If (Item <> Seperator)
    then
      begin
        ScreenName := GetScreenName(Item);

        For I := 0 to (ScreenLabelList.Count - 1) do
          If (Take(30, ScreenName) = Take(30, ScreenLabelPtr(ScreenLabelList[I])^.ScreenName))
            then Result := RTrim(ScreenLabelPtr(ScreenLabelList[I])^.TableName);

      end;  {If (Item <> Seperator)}

end;  {GetTableName}

{===============================================================}
Function TGeneralizedExtractForm.GetFieldName(Item : String) : String;

{Get the field for the label listed in the extract item.}

var
  LabelName, ScreenName : String;
  I : Integer;

begin
  Result := '';

  If (Item <> Seperator)
    then
      begin
        ScreenName := GetScreenName(Item);
        LabelName := GetLabelName(Item);

        For I := 0 to (ScreenLabelList.Count - 1) do
          If ((Take(30, ScreenName) = Take(30, ScreenLabelPtr(ScreenLabelList[I])^.ScreenName)) and
              (Take(30, LabelName) = Take(30, ScreenLabelPtr(ScreenLabelList[I])^.LabelName)))
            then Result := RTrim(ScreenLabelPtr(ScreenLabelList[I])^.FieldName);

      end;  {If (Item <> Seperator)}

end;  {GetFieldName}

{===============================================================}
Function GetRecordType(TableName : String) : String;

{For each table type, come up with a 4 char record type.}

begin
  If (TableName = ParcelTableName)
    then Result := 'Parcel';

  If (TableName = AssessmentTableName)
    then Result := 'Assess';

  If (TableName = ClassTableName)
    then Result := 'Class';

  If (TableName = SpecialDistrictTableName)
    then Result := 'Spcl Dist';

  If (TableName = ExemptionsTableName)
    then Result := 'Exempt';

  If (TableName = ExemptionsDenialTableName)
    then Result := 'EX Denial';

  If (TableName = SalesTableName)
    then Result := 'Sales';

  If (TableName = ResidentialSiteTableName)
    then Result := 'Res Site';

  If (TableName = ResidentialBldgTableName)
    then Result := 'Res Bldg';

  If (TableName = ResidentialLandTableName)
    then Result := 'Res Land';

  If (TableName = ResidentialForestTableName)
    then Result := 'Res Forst';

  If (TableName = ResidentialImprovementsTableName)
    then Result := 'Res Imp';

  If (TableName = CommercialSiteTableName)
    then Result := 'Com Site';

  If (TableName = CommercialBldgTableName)
    then Result := 'Com Bldg';

  If (TableName = CommercialLandTableName)
    then Result := 'Com Land';

  If (TableName = CommercialImprovementsTableName)
    then Result := 'Com Imp';

  If (TableName = CommercialRentTableName)
    then Result := 'Com Rent';

  If (TableName = CommercialIncomeExpenseTableName)
    then Result := 'Com IncExp';

  If (TableName = NotesTableName)
    then Result := 'Notes';

  If (TableName = PictureTableName)
    then Result := 'Picture';

  If (TableName = DocumentTableName)
    then Result := 'Document';

  If (TableName = UserDataTableName)
    then Result := 'User Data';

end;  {GetRecordType}

{===============================================================}
Function FormatField(ExtractTable : TTable;
                     FieldName : String;
                     Size,
                     ExtractFileType : Integer;
                     DataType : TFieldType) : String;

begin
  with ExtractTable do
    case DataType of
      ftCurrency,
      ftFloat :
        begin
          Result := FormatFloat(DecimalEditDisplay, FieldByName(FieldName).AsFloat);

          If (ExtractFileType = ftColumnar)
            then Result := RightJustify(Result, Size);
        end;

      ftInteger,
      ftDate,
      ftDateTime,
      ftTime : If (ExtractFileType = ftColumnar)
                 then Result := RightJustify(FieldByName(FieldName).Text, Size)
                 else Result := FieldByName(FieldName).Text;

      else Result := FieldByName(FieldName).Text;

    end;  {case DataType of}

end;  {FormatField}

{===============================================================}
Procedure TGeneralizedExtractForm.WriteThisScreen(var ExtractFile : TextFile;
                                                      TableList : TList;
                                                      FieldNameList,
                                                      TableNameList : TStringList;
                                                      ProcessingType  : Integer;
                                                      AssessmentYear : String;
                                                      SwisSBLKey : String;
                                                  var Index : Integer;
                                                  var FirstFieldOnLine,
                                                      FieldsWritten : Boolean;
                                                      SeperateRecords : Boolean);

{For all entries with this screen name, write all records for it. For example,
 if there are 3 fields in a row from the exemption screen, then for each
 exemption, write all 3 fields.}

var
  TempParcelID, OrigTableName,
  FieldName, RecordType : String;
  IsParcelTable, Done, FirstTimeThrough : Boolean;
  TempSize, I, OrigIndex : Integer;
  SBLRec : SBLRecord;
  TempStr1, TempStr2 : String;
  ExtractTable : TTable;

begin
  ExtractTable := nil;
(*  OrigTableName := GetTableName(DefinedListBox.Items[Index]);*)
  OrigTableName := TableNameList[Index];

(*  OpenTableForProcessingType(ExtractTable, OrigTableName, ProcessingType, Quit);*)

  For I := 0 to (TableList.Count - 1) do
    If (DetermineTableNameForProcessingType(GetTableName(DefinedListBox.Items[Index]),
                                            ProcessingType) =
        TTable(TableList[I]).TableName)
      then ExtractTable := TTable(TableList[I]);

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

    {FXX12022001-1: Need to determine if it is a parcel table better.}

  IsParcelTable := (Pos('PARCELREC', ANSIUpperCase(ExtractTable.TableName)) > 0);

  If ((OrigTableName = SalesTableName) or
      (OrigTableName = NotesTableName))
    then
      begin
        ExtractTable.IndexName := 'BYSWISSBLKEY';
        SetRangeOld(ExtractTable, ['SwisSBLKey'],
                    [SwisSBLKey], [SwisSBLKey])
      end
    else
      begin
        ExtractTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

        If IsParcelTable
          then
            with SBLRec do
              FindKeyOld(ExtractTable,
                         ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                          'Block', 'Lot', 'Sublot', 'Suffix'],
                         [AssessmentYear, SwisCode, Section, Subsection,
                          Block, Lot, Sublot, Suffix])
          else SetRangeOld(ExtractTable, ['TaxRollYr', 'SwisSBLKey'],
                           [AssessmentYear, SwisSBLKey], [AssessmentYear, SwisSBLKey]);

      end;  {else of If ((OrigTableName = SalesTableName) or ...}

  OrigIndex := Index;
  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ExtractTable.Next;

    If ExtractTable.EOF
      then Done := True;

    If not Done
      then
        begin
          FieldsWritten := True;

            {For the header of this record, write a type if they want one.}
            {Write Parcel ID on the front of every line.}

            {CHG03012000-1: Allow choice of parcel ID type.}

          TempStr1 := '';
          TempStr2 := '';

            {CHG10162003-1(2.07j1): Allow them to not include the swis on the parcel ID.}

          If IncludeSwisOnParcelID
            then TempParcelID := ConvertSwisSBLToDashDot(SwisSBLKey)
            else TempParcelID := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));


          case FirstFieldsOnLine of
            ffSwisSBL : TempStr1 := SwisSBLKey;
            ffPrintKey : TempStr1 := TempParcelID;

            ffSwisSBL_PrintKey :
              begin
                TempStr1 := SwisSBLKey;
                TempStr2 := TempParcelID;
              end;

            ffPrintKey_SwisSBL :
              begin
                TempStr1 := TempParcelID;
                TempStr2 := SwisSBLKey;
              end;

          end;  {case FirstFieldsOnLine of}

          If FirstFieldOnLine
            then
              begin
                WriteOneField(ExtractFile, TempStr1, 26,
                              ExtractFileType, FirstFieldOnLine);

                If (Deblank(TempStr2) <> '')
                  then WriteOneField(ExtractFile, TempStr2, 26,
                                     ExtractFileType, FirstFieldOnLine);

              end;  {If FirstFieldOnLine}

          (*RecordType := GetRecordType(GetTableName(DefinedListBox.Items[Index]));*)
          RecordType := GetRecordType(TableNameList[Index]);

          If IncludeRecordType
            then WriteOneField(ExtractFile, RecordType, 10,
                               ExtractFileType, FirstFieldOnLine);

          while ((Index <= (DefinedListBox.Items.Count - 1)) and
                 (OrigTableName = TableNameList[Index])) do
            begin
(*              FieldName := GetFieldName(DefinedListBox.Items[Index]); *)
              FieldName := FieldNameList[Index];

                {FXX03012000-3: Data fields are listed as size 8,
                                but print out as size 10.}

              TempSize := ExtractTable.FieldByName(FieldName).DataSize;

              If (ExtractFileType = ftColumnar)
                then
                  case ExtractTable.FieldByName(FieldName).DataType of
                    ftDate,
                    ftTime,
                    ftDateTime : TempSize := 10;

                    ftInteger,
                    ftFloat,
                    ftCurrency : TempSize := 12;
                    ftSmallInt : TempSize := 6;

                  end;  {case ExtractTable.FieldByName(FieldName).DataType of}

              WriteOneField(ExtractFile,
                            FormatField(ExtractTable, FieldName, TempSize, ExtractFileType,
                                        ExtractTable.FieldByName(FieldName).DataType),
                            TempSize, ExtractFileType, FirstFieldOnLine);

              Index := Index + 1;

            end;  { while ((Index < (DefinedListBox.Items.Count - 1)) and ...}

            {Go back to the original field for the next record of this type.}

          Index := OrigIndex;

          If {SeperateRecords}SeperateLinesForMultipleRecords
            then
              begin
                Writeln(ExtractFile);
                FirstFieldOnLine := True;
                FieldsWritten := False;
              end;

        end;  {If not Done}

      {No set range for parcel table - only one parcel.}

    If IsParcelTable
      then Done := True;

  until Done;

    {Advance to the next screen}

  while ((Index <= (DefinedListBox.Items.Count - 1)) and
         (OrigTableName = TableNameList[Index])) do
    Index := Index + 1;

    {If we are now on a record seperator, then end this line.}

 (* If ((Index < (DefinedListBox.Items.Count - 1)) and      (DefinedListBox.Items[Index] = Seperator) and {Not the last item}
      (not FirstFieldOnLine))  {Something actually printed on this line.}
    then
      begin
        Writeln(ExtractFile);
        Index := Index + 1;
      end; *)

(*  ExtractTable.Close;*)

end;  {WriteThisScreen}

{===============================================================}
Procedure TGeneralizedExtractForm.WriteHeaderLine(var ExtractFile : TextFile);

var
  I : Integer;
  FieldName : String;

begin
  Write(ExtractFile, '"Parcel ID"');

  with DefinedListBox do
    For I := 0 to (Items.Count - 1) do
      If (Items[I] <> Seperator)
        then
          begin
            FieldName := GetFieldName(DefinedListBox.Items[I]);

            If (I > 0)
              then Write(ExtractFile, ',');

            Write(ExtractFile, '"', FieldName, '"');

          end;  {If (Items[I] <> Seperator)}

  Writeln(ExtractFile);

end;  {WriteHeaderLine}

{===============================================================}
Procedure TGeneralizedExtractForm.CreateExtractFile(var ExtractFile : TextFile);

var
  FieldsWritten, SeperateRecords, AllFieldsFromOneTable,
  FirstFieldOnLine, FirstTimeThrough, Done, Quit, FoundTable : Boolean;
  I, J, Index : Integer;
  NumExtracted : LongInt;
  SwisSBLKey : String;
  TempTable, LookupTable : TTable;
  FoundTableName, FieldName, TableName : String;
  AssessmentYear : String;
  TableList : TList;
  FieldNameList, TableNameList : TStringList;

begin
  Done := False;
  FirstTimeThrough := True;
  FieldsWritten := False;
  NumExtracted := 0;
  AssessmentYear := GetTaxRollYearForProcessingType(ProcessingType);
  LookupTable := TTable.Create(nil);
  TableName := '';
  Index := 1;

    {CHG03012000-2: In order to speed things up, if there is only one screen in
                    this extract, only try to extract parcels that have this record.}

  AllFieldsFromOneTable := False;

(*  AllFieldsFromOneTable := True;

  with DefinedListBox do
    For I := 0 to (Items.Count - 1) do
      If (Deblank(TableName) = '')
        then TableName := GetTableName(Items[I])
        else
          If (TableName <> GetTableName(Items[I]))
            then AllFieldsFromOneTable := False;

  If (AllFieldsFromOneTable and
      (TableName <> ParcelTableName))
    then OpenTableForProcessingType(LookupTable, TableName, ProcessingType, Quit); *)

    {FXX03102001-1: Create a table name list which corresponds to the
                    Item List.}

  TableList := TList.Create;
  TableNameList := TStringList.Create;
  FieldNameList := TStringList.Create;

  with DefinedListBox do
    For I := 0 to (Items.Count - 1) do
      If (Items[I] <> Seperator)
        then
          begin
            FoundTable := False;

            For J := 0 to (TableList.Count - 1) do
              If (DetermineTableNameForProcessingType(GetTableName(Items[I]),
                                                      ProcessingType) =
                  TTable(TableList[J]).TableName)
                then
                  begin
                    FoundTable := True;
                    FoundTableName := TTable(TableList[J]).TableName;
                  end;

            If FoundTable
              then TableNameList.Add(FoundTableName)
              else
                begin
                  TempTable := TTable.Create(nil);
                  OpenTableForProcessingType(TempTable, GetTableName(Items[I]),
                                             ProcessingType, Quit);
                  TableList.Add(TempTable);
                  TableNameList.Add(TempTable.TableName);

                end;  {else of If FoundTable}

            FieldName := GetFieldName(Items[I]);
            FieldNameList.Add(FieldName);

          end;  {For I := 0 to (Items.Count - 1) do}

  ProgressDialog.UserLabelCaption := 'Preparing extract, please wait ...';
  ProgressDialog.Start(0, True, True);
  ProgressDialog.TotalNumRecords := GetRecordCount(ParcelTable);
  ProgressDialog.UserLabelCaption := '';

  If IncludeHeaderLine
    then WriteHeaderLine(ExtractFile);

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else ParcelTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If (ParcelTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    SwisSBLKey := ExtractSSKey(ParcelTable);

    If ((not Done) and
        ((not ActiveParcelsOnly) or
         (ActiveParcelsOnly and
          (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))) and
        ((not AllFieldsFromOneTable) or
         (TableName = ParcelTableName) or
         (AllFieldsFromOneTable and
          FindKeyOld(LookupTable, ['TaxRollYr', 'SwisSBLKey'],
                     [AssessmentYear, SwisSBLKey]))))
      then
        begin
          If LoadFromParcelList
            then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
            else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

          Application.ProcessMessages;
          FirstFieldOnLine := True;
          FieldsWritten := False;
          SeperateRecords := False;
          I := 0;

          with DefinedListBox do
            while (I <= (Items.Count - 1)) do
              If (Items[I] = Seperator)
                then
                  begin
                    Writeln(ExtractFile);
                    FieldsWritten := False;
                    FirstFieldOnLine := True;
                    SeperateRecords := True;
                    I := I + 1;
                  end
                else
                  begin
                    WriteThisScreen(ExtractFile, TableList,
                                    FieldNameList, TableNameList,
                                    ProcessingType, AssessmentYear,
                                    SwisSBLKey, I,
                                    FirstFieldOnLine, FieldsWritten, SeperateRecords);
                    SeperateRecords := False;
                  end;

            {If they did not want multiple lines, then issue a carriage return now.
             Otherwise, it has already been done.  Only do this if actual
             data was written for this parcel.}

          If FieldsWritten
            then
              begin
                Writeln(ExtractFile);
                NumExtracted := NumExtracted + 1;
                ProgressDialog.UserLabelCaption := 'Num Extracted ' + IntToStr(NumExtracted);
              end;

        end;  {If not Done}

    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled);

  ProgressDialog.Finish;
  LookupTable.Close;
  LookupTable.Free;
  TableNameList.Free;
  FieldNameList.Free;

  For J := (TableList.Count - 1) downto 0 do
    TTable(TableList[J]).Free;

end;  {CreateExtractFile}

{===================================================================}
Procedure TGeneralizedExtractForm.FormClose(    Sender: TObject;
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