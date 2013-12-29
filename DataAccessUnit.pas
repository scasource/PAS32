unit DataAccessUnit;

interface

Uses WinUtils, PASTypes, DBTables, PASUtils, SysUtils, Utilitys, Classes, GlblVars, Forms,
     GlblCnst, DB, StdCtrls, Dialogs, Mask, ComCtrls, ADODB;

type
  TLocateOptionTypes = (loPartialKey, loChangeIndex, loParseSwisSBLKey, loParseSBLOnly, loSameEndingRange);
  TLocateOptions = set of TLocateOptionTypes;

  TTableOpenOptionTypes = (toExclusive, toReadOnly, toOpenAsIs, toNoReopen);
  TTableOpenOptions = set of TTableOpenOptionTypes;

  TInsertRecordOptionTypes = (irSuppressInitializeFields, irSuppressPost);
  TInsertRecordOptions = set of TInsertRecordOptionTypes;

  TSQLFormatOptionTypes = (sqlfParenthesis);
  TSQLFormatOptions = set of TSQLFormatOptionTypes;

Function _Locate(      Table : TTable;
                 const KeyFieldValues : Array of const;
                       IndexName : String;
                       LocateOptions : TLocateOptions) : Boolean;

Function _SetRange(      Table : TTable;
                   const StartKeyFieldValues : Array of const;
                   const EndKeyFieldValues : Array of const;
                         IndexName : String;
                         LocateOptions : TLocateOptions) : Boolean;

Procedure InitializeFieldsForRecord(Table : TDataset);

Function _InsertRecord(      Table : TTable;
                       const _FieldNames : Array of const;
                       const _FieldValues : Array of const;
                             InsertRecordOptions : TInsertRecordOptions) : Boolean;

Function _UpdateRecord(      Table : TTable;
                       const _FieldNames : Array of const;
                       const _FieldValues : Array of const;
                             UpdateRecordOptions : TInsertRecordOptions) : Boolean;

Function _SetFilter(Table : TTable;
                    _Filter : String) : Boolean;
                             
Function _OpenTable(Table : TTable;
                    _TableName : String;
                    _DatabaseName : String;  {Blank means PASSystem.}
                    _IndexName : String;
                    ProcessingType : Integer;
                    TableOpenOptions : TTableOpenOptions) : Boolean;

Function _OpenTablesForForm(Form : TForm;
                            ProcessingType : Integer;
                            TableOpenOptions : TTableOpenOptions) : Boolean;

Procedure _CloseTablesForForm(Form : TForm);


Function FormatSQLConditional(      FieldName : String;
                              const _FieldValues : Array of const;
                                    Comparison : Integer;
                                    SQLFormatOptions : TSQLFormatOptions) : String;

Function FormatSQLOrderBy(const _FieldNames : Array of const) : String;

Procedure DatasetLoadToForm(Form : TForm;
                            Dataset : TDataset);

Function SQLUpdateFromForm(Form : TForm;
                           Dataset : TQuery;
                           TableName : String;
                           WhereClause : String) : Boolean;

Function GetUniqueSQLID(_DatabaseName : String;
                        _TableName : String) : LongInt;

Procedure _Query(      Query : TQuery;
                 const Expression : Array of String);

Procedure _ADOQuery(      Query : TADOQuery;
                    const Expression : Array of String);

Procedure _QueryExec(      Query : TQuery;
                     const Expression : Array of String);

Procedure _ADOQueryExec(      Query : TADOQuery;
                        const Expression : Array of String);

implementation

type
  TFindKeyFunction = Function(      Table : TTable;
                                    IndexFieldNameList : TStringList;
                              const Values : Array of const) : Boolean;

{===================================================}
Function FindKeyDBase(      Table : TTable;
                            IndexFieldNameList : TStringList;
                      const Values : Array of const) : Boolean;

var
  I : Integer;
  TempValue : String;

begin
  with Table do
    begin
      SetKey;

      For I := 0 to High(Values) do
        try
          TempValue := VarRecToStr(Values[I]);
          FieldByName(IndexFieldNameList[I]).Text := TempValue;
        except
        end;

      Result := GotoKey;

    end;  {with Table do}

end;  {FindKeyDBase}

{===================================================}
Function FindNearestDBase(      Table : TTable;
                                IndexFieldNameList : TStringList;
                          const Values : Array of const) : Boolean;

var
  I : Integer;

begin
  Result := True;

  with Table do
    begin
      SetKey;

      For I := 0 to High(Values) do
        try
          FieldByName(IndexFieldNameList[I]).Text := VarRecToStr(Values[I]);
        except
        end;

      GotoNearest;

    end;  {with Table do}

end;  {FindNearestDBase}

{==========================================================================}
Procedure ParseIndexExpressionIntoFields(Table : TTable;
                                         IndexFieldNameList : TStringList);

var
  IndexPosition, PlusPos : Integer;
  IndexExpression, TempFieldName : String;

begin
  IndexFieldNameList.Clear;
  IndexPosition := Table.IndexDefs.IndexOf(Table.IndexName);

  IndexExpression := Table.IndexDefs[IndexPosition].FieldExpression;

    {Strip out the ')', 'DTOS(', 'STR('.}

  IndexExpression := StringReplace(IndexExpression, ')', '', [rfReplaceAll, rfIgnoreCase]);
  IndexExpression := StringReplace(IndexExpression, 'DTOS(', '', [rfReplaceAll, rfIgnoreCase]);
  IndexExpression := StringReplace(IndexExpression, 'TTOS(', '', [rfReplaceAll, rfIgnoreCase]);
  IndexExpression := StringReplace(IndexExpression, 'STR(', '', [rfReplaceAll, rfIgnoreCase]);

  If _Compare(IndexExpression, coNotBlank)
    then
      repeat
        PlusPos := Pos('+', IndexExpression);

        If (PlusPos > 0)
          then TempFieldName := Copy(IndexExpression, 1, (PlusPos - 1))
          else TempFieldName := IndexExpression;

        IndexFieldNameList.Add(TempFieldName);
        If (PlusPos > 0)
          then Delete(IndexExpression, 1, PlusPos)
          else IndexExpression := '';

      until (IndexExpression = '');

end;  {ParseIndexExpressionIntoFields}

{==========================================================================}
Function _Locate(      Table : TTable;
                 const KeyFieldValues : Array of const;
                       IndexName : String;
                       LocateOptions : TLocateOptions) : Boolean;

{Note that IndexName can be blank if you want to use the current index.}

var
  SBLRec : SBLRecord;
  LocateFunction : TFindKeyFunction;
  IndexFieldNameList : TStringList;

begin
  IndexFieldNameList := TStringList.Create;
  LocateFunction := FindKeyDBase;

  If (loPartialKey in LocateOptions)
    then LocateFunction := FindNearestDBase;

  If ((loChangeIndex in LocateOptions) and
      (Trim(IndexName) <> ''))
    then Table.IndexName := IndexName;

  ParseIndexExpressionIntoFields(Table, IndexFieldNameList);

  If (loParseSwisSBLKey in LocateOptions)
    then
      begin
        SBLRec := ExtractSwisSBLFromSwisSBLKey(VarRecToStr(KeyFieldValues[1]));

        with SBLRec do
          Result := LocateFunction(Table,
                                   IndexFieldNameList,
                                   [VarRecToStr(KeyFieldValues[0]), SwisCode, Section, Subsection, Block,
                                    Lot, Sublot, Suffix]);

      end
    else
      If (loParseSBLOnly in LocateOptions)
        then
          begin
            SBLRec := ExtractSBLFromSBLKey(VarRecToStr(KeyFieldValues[1]));

            with SBLRec do
              Result := LocateFunction(Table,
                                       IndexFieldNameList,
                                       [VarRecToStr(KeyFieldValues[0]), Section, Subsection, Block,
                                        Lot, Sublot, Suffix]);

          end
        else Result := LocateFunction(Table, IndexFieldNameList, KeyFieldValues);

  IndexFieldNameList.Free;

end;  {_Locate}

{==========================================================================}
Function _SetRange(      Table : TTable;
                   const StartKeyFieldValues : Array of const;
                   const EndKeyFieldValues : Array of const;
                         IndexName : String;
                         LocateOptions : TLocateOptions) : Boolean;

{Note that IndexName can be blank if you want to use the current index.}

var
  IndexFieldNameList : TStringList;
  TempValue : String;
  I : Integer;

begin
  Result := True;
  IndexFieldNameList := TStringList.Create;

  If ((loChangeIndex in LocateOptions) and
      (Trim(IndexName) <> ''))
    then Table.IndexName := IndexName;

  ParseIndexExpressionIntoFields(Table, IndexFieldNameList);

    {Now do the set range.}

  with Table do
    try
      LogTime('c:\trace.txt', '_SetRange - before ' + TableName);

      CancelRange;
      SetRangeStart;

      For I := 0 to (IndexFieldNameList.Count - 1) do
        FieldByName(IndexFieldNameList[I]).Text := VarRecToStr(StartKeyFieldValues[I]);

      SetRangeEnd;

      For I := 0 to (IndexFieldNameList.Count - 1) do
        begin
          If (loSameEndingRange in LocateOptions)
            then TempValue := VarRecToStr(StartKeyFieldValues[I])
            else TempValue := VarRecToStr(EndKeyFieldValues[I]);

          FieldByName(IndexFieldNameList[I]).Text := TempValue;

        end;  {For I := 0 to (IndexFieldNameList.Count - 1) do}

      ApplyRange;

      LogTime('c:\trace.txt', '_SetRange - after ' + TableName);

    except
      Result := False;
    end;  {with Table do}

  IndexFieldNameList.Free;

end;  {_SetRange}

{====================================================================}
Procedure InitializeFieldsForRecord(Table : TDataset);

var
  I : Integer;

begin
  with Table do
    For I := 0 to (Fields.Count - 1) do
      begin
        If (Fields[I].DataType in [ftString])
          then
            try
              Fields[I].Value := '';
            except
            end;

        If (Fields[I].DataType in [ftSmallInt, ftInteger, ftWord,
                                   ftFloat, ftCurrency, ftLargeInt, ftBCD])
          then
            try
              Fields[I].Value := 0;
            except
            end;

        If (Fields[I].DataType = ftBoolean)
          then
            try
              Fields[I].AsBoolean := False;
            except
            end;

      end;  {For I := 0 to (Fields.Count) do}

end;  {InitializeFieldsForRecord}

{===============================================================}
Function _InsertRecord(      Table : TTable;
                       const _FieldNames : Array of const;
                       const _FieldValues : Array of const;
                             InsertRecordOptions : TInsertRecordOptions) : Boolean;

var
  I : Integer;

begin
  Result := True;

  with Table do
    try
      Insert;

      If not (irSuppressInitializeFields in InsertRecordOptions)
        then InitializeFieldsForRecord(Table);

      For I := 0 to High(_FieldNames) do
        If (FindField(VarRecToStr(_FieldNames[I])) <> nil)
          then
            try
              FieldByName(VarRecToStr(_FieldNames[I])).AsString := VarRecToStr(_FieldValues[I]);
            except
            end;

      If not (irSuppressPost in InsertRecordOptions)
        then Post;
    except
      Cancel;
      Result := False;
    end;

end;  {_InsertRecord}

{===============================================================}
Function _UpdateRecord(      Table : TTable;
                       const _FieldNames : Array of const;
                       const _FieldValues : Array of const;
                             UpdateRecordOptions : TInsertRecordOptions) : Boolean;

var
  I : Integer;

begin
  Result := True;

  with Table do
    try
      Edit;

      For I := 0 to High(_FieldNames) do
        try
          FieldByName(VarRecToStr(_FieldNames[I])).AsString := VarRecToStr(_FieldValues[I]);
        except
        end;

      If not (irSuppressPost in UpdateRecordOptions)
        then Post;
    except
      Cancel;
      Result := False;
    end;

end;  {_UpdateRecord}

{=========================================================================}
Function _SetFilter(Table : TTable;
                    _Filter : String) : Boolean;

begin
  Result := True;

  with Table do
    try
      Filtered := False;
      Filter := _Filter;
      Filtered := True;
    except
      Result := False;
    end;

end;  {_SetFilter}

{===============================================================}
Function GetTableNameForProcessingType(TableName : String;
                                       ProcessingType : Integer) : String;

begin
  Result := TableName;

  try
    If _Compare(TableName, 'T', coStartsWith)
      then
        case ProcessingType of
          History : Result[1] := 'H';
          NextYear : Result[1] := 'N';
          SalesInventory : Result[1] := 'S';
        end;

  except
  end;

end;  {GetTableNameForProcessingType}

{==============================================================================}
Function _OpenTable(Table : TTable;
                    _TableName : String;
                    _DatabaseName : String;  {Blank means PASSystem.}
                    _IndexName : String;
                    ProcessingType : Integer;
                    TableOpenOptions : TTableOpenOptions) : Boolean;

begin
  Result := True;

  with Table do
    try
      Close;
      TableType := ttDBase;

      If _Compare(_TableName, coNotBlank)
        then TableName := GetTableNameForProcessingType(_TableName, ProcessingType);

      If not (toOpenAsIs in TableOpenOptions)
        then
          begin
            If _Compare(_DatabaseName, coBlank)
              then DatabaseName := 'PASSystem'
              else DatabaseName := _DatabaseName;

            If _Compare(_IndexName, coNotBlank)
              then IndexName := _IndexName;

              {FXX04232009-2(2.20.1.1)[D143]: Make sure to preserve original table options if not specified.}

            If (toExclusive in TableOpenOptions)
              then Exclusive := True;

            If (toReadOnly in TableOpenOptions)
              then ReadOnly := True;

          end;  {If not (toOpenAsIs in TableOpenOptions)}

      Open;
    except
      Result := False;
      SystemSupport(1, Table, 'Error opening table ' + Table.TableName + '.',
                    'DataAccessUnit', GlblErrorDlgBox);
    end;

end;  {_OpenTable}

{=======================================================================}
Function _OpenTablesForForm(Form : TForm;
                            ProcessingType : Integer;
                            TableOpenOptions : TTableOpenOptions) : Boolean;

var
  I, TempProcessingType : Integer;
  TableName : String;

begin
  Result := True;

  with Form do
    begin
      For I := 1 to (ComponentCount - 1) do
        If ((Components[I] is TTable) and
            _Compare(TTable(Components[I]).TableName, coNotBlank) and
            ((not (toNoReOpen in TableOpenOptions)) or
             (not TTable(Components[I]).Active)))
          then
            begin
              TableName := TTable(Components[I]).TableName;
              LogTime('c:\trace.txt', '_OpenTablesForForm - before ' + TableName);
              TempProcessingType := ProcessingType;

                {If this a sales inventory page, and this is an inventory file, then
                 we will change the table name so that it is a sales inventory file
                 (i.e. starts with 'S'). However, if this is sales inventory, but the file
                 is not inventory (i.e. TParcelRec), then we want to open it with the GlblTaxYrFlg as
                 the ProcessingType because SalesInventory can only be viewed for the current Processing year.
                 However, if this is not sales, we will just adjust the first letter of any year
                 dependant files to match the processing type of this instance.}

              If ((ProcessingType = SalesInventory) and
                  (_Compare(TableName, 'TPRes', coStartsWith) or
                   _Compare(TableName, 'TPCom', coStartsWith)))
                then TempProcessingType := DetermineProcessingType(GlblTaxYearFlg);

              If not _OpenTable(TTable(Components[I]), TableName, TTable(Components[I]).DatabaseName, '', TempProcessingType, TableOpenOptions)
                then Result := False;

              LogTime('c:\trace.txt', '_OpenTablesForForm - after ' + TableName);

            end;  {If ((Components[I] is TTable) and ...}

    end;  {with Form do}

end;  {_OpenTablesForForm}

{================================================================================}
Procedure _CloseTablesForForm(Form : TForm);

{Close all the tables on the form.}

var
  I : Integer;

begin
  with Form do
    For I := 1 to (ComponentCount - 1) do
      If (Components[I] is TTable)
        then
          try
            with Components[I] as TTable do
              If Active
                then Close;

          except
          end;

end;  {CloseTablesForForm}

{====================================================================}
Function FormatSQLConditional(      FieldName : String;
                              const _FieldValues : Array of const;
                                    Comparison : Integer;
                                    SQLFormatOptions : TSQLFormatOptions) : String;

const
  SingleQuote = '''';
  BoolChars : Array[Boolean] of Char = ('F', 'T');

var
  I : Integer;
  TempValue : String;

begin
  Result := FieldName + ' ';

  case Comparison of
    coEqual : Result := Result + '= ';
    coGreaterThan : Result := Result + '> ';
    coLessThan : Result := Result + '< ';
    coGreaterThanOrEqual : Result := Result + '>= ';
    coLessThanOrEqual : Result := Result + '<= ';
    coNotEqual : Result := Result + '<> ';

  end;  {case Comparison of}

  TempValue := '';
  For I := 0 to High(_FieldValues) do
    try
      with _FieldValues[I] do
        case VType of
          vtInteger    : TempValue := IntToStr(VInteger);
          vtBoolean    : If _Compare(BoolChars[VBoolean], 'T', coEqual)
                          then TempValue := 'True'
                          else TempValue := 'False';
          vtChar       : TempValue := SingleQuote + VChar + SingleQuote;
          vtExtended   : TempValue := FloatToStr(VExtended^);
          vtString     : TempValue := SingleQuote + VString^ + SingleQuote;
          vtPChar      : TempValue := SingleQuote + VPChar + SingleQuote;
          vtCurrency   : TempValue := CurrToStr(VCurrency^);
          vtInt64      : TempValue := IntToStr(VInt64^);

        end;  {with Values[I] do}

    except
    end;

  Result := Result + TempValue;

end;  {FormatSQLConditional}

{====================================================================}
Function FormatSQLOrderBy(const _FieldNames : Array of const) : String;

var
  I : Integer;

begin
  Result := 'Order By ';

  For I := 0 to High(_FieldNames) do
    begin
      If (I > 0)
        then Result := Result + ',';

      Result := Result + VarRecToStr(_FieldNames[I]);

    end;  {For I := 0 to High(_FieldNames) do}

end;  {FormatSQLOrderBy}

{=========================================================================}
Procedure DatasetLoadToForm(Form : TForm;
                            Dataset : TDataset);

{This depends on the components being named with the fields.}

var
  I : Integer;
  TempValue, FieldName : String;
  Component : TComponent;

begin
  Dataset.FieldDefs.Update;
  For I := 0 to (Dataset.FieldCount - 1) do
    begin
      FieldName := Dataset.Fields[I].FieldName;
      Component := Form.FindComponent(FieldName);

      If (Component <> nil)
        then
          begin
            TempValue := Dataset.FieldByName(FieldName).AsString;

            If (Component is TCustomEdit)
              then
                begin
                  If (((Dataset.Fields[I].DataType = ftDateTime) or
                       (Dataset.Fields[I].DataType = ftTime)) and
                      _Compare(FieldName, 'Time', coContains))
                    then TempValue := FormatDateTime(TimeFormat, Dataset.FieldByName(FieldName).AsDateTime);

                    {Special code for date mask edits.}

                  If ((Dataset.Fields[I].DataType = ftDate) and
                      _Compare(FieldName, 'Date', coContains) and
                      _Compare(TempValue, coNotBlank) and
                      (Component is TMaskEdit))
                    then
                      begin
                        TempValue := FormatDateTime(_LongDateFormat, Dataset.FieldByName(FieldName).AsDateTime);
                        (*TempValue := StringReplace(TempValue, '/', '', [rfReplaceAll]); *)
                      end;

                  If _Compare(TempValue, '1/1/1900', coEqual)
                    then TempValue := '';
                      
                  try
                    TCustomEdit(Component).Text := TempValue;
                  except
                  end;

                end;  {If (Component is TCustomEdit)}

            If ((Component is TDateTimePicker) and
                _Compare(TempValue, coNotBlank))
              then
                try
                  TDateTimePicker(Component).Date := Dataset.FieldByName(FieldName).AsDateTime;
                except
                end;

            If (Component is TCheckBox)
              then
                try
                  TCheckBox(Component).Checked := Dataset.FieldByName(FieldName).AsBoolean;
                except
                end;

          end;  {If (Component <> nil)}

    end;  {For I := 0 to (FieldCount - 1) do}

end;  {FillScreenComponentsFromDataSet}

{=================================================================}
Function SQLUpdateFromForm(Form : TForm;
                           Dataset : TQuery;
                           TableName : String;
                           WhereClause : String) : Boolean;

var
  I, NumAdded : Integer;
  TempValue, FieldName, TempSQLLine : String;
  Component : TComponent;
  SetField : Boolean;
  SQLStatement : TStringList;

begin
  Result := True;
  NumAdded := 0;
  SQLStatement := TStringList.Create;

  SQLStatement.Add('Update ' + TableName);

  For I := 0 to (Dataset.FieldCount - 1) do
    begin
      FieldName := DataSet.Fields[I].FieldName;
      Component := Form.FindComponent(FieldName);

      If (Component <> nil)
        then
          begin
            SetField := True;
            
            If (Component is TCustomEdit)
              then
                begin
                  TempValue := TCustomEdit(Component).Text;

                    {Replace embeded single quotes with ''''.}

                  TempValue := StringReplace(TempValue, '''', '''''', [rfReplaceAll]);

                  If (Dataset.Fields[I].DataType = ftTime)
                    then
                      try
                        StrToTime(TempValue);
                      except
                        SetField := False;
                      end;

                  If (Dataset.Fields[I].DataType = ftDate)
                    then
                      If (_Compare(TempValue, BlankMaskDate, coEqual) or
                          _Compare(TempValue, BlankMaskDateUnderscore, coEqual) or
                          _Compare(TempValue, coBlank))
                        then SetField := False
                        else
                          try
                            StrToDate(TempValue);
                          except
                            SetField := False;
                          end;

                end;  {If (Component is TCustomEdit)}

            If (Component is TCheckBox)
              then
                try
                  TempValue := BoolToStr_True_False(TCheckBox(Component).Checked);
                except
                  SetField := False;
                end;

            If (Component is TDateTimePicker)
              then
                try
                  TempValue := DateToStr(TDateTimePicker(Component).Date);
                except
                  SetField := False;
                end;

            If SetField
              then
                begin
                    {Make sure to put a comma on the last set line.}

                  If _Compare(NumAdded, 0, coGreaterThan)
                    then SQLStatement[NumAdded] := SQLStatement[NumAdded] + ',';

                  TempSQLLine := '';

                  If _Compare(NumAdded, 0, coEqual)
                    then TempSQLLine := 'Set ';

                  TempSQLLine := TempSQLLine + FieldName + ' = ' + FormatSQLString(TempValue);
                  SQLStatement.Add(TempSQLLine);

                  Inc(NumAdded);

                end;  {If SetField}

          end;  {If (Component <> nil)}

    end;  {For I := 0 to (FieldCount - 1) do}

  with Dataset do
    try
      SQLStatement.Add('where ' + WhereClause);
      SQL.Assign(SQLStatement);
      ExecSQL;
    except
      on E: Exception do
        begin
          MessageDlg(E.Message, mtError, [mbOK], 0);
          Result := False;
        end;

    end;

  SQLStatement.Free;

end;  {SQLUpdateFromForm}

{========================================================================}
Function GetUniqueSQLID(_DatabaseName : String;
                        _TableName : String) : LongInt;

var
  Query : TQuery;

begin
  Result := 0;
  Query := TQuery.Create(nil);

  with Query do
    try
      DatabaseName := _DatabaseName;
      SQL.Add('SELECT COUNT(*) FROM ' + _TableName);
      Open;
    except
      Abort;
    end;

  try
    Result := Trunc(Query.FieldByName('COUNT___').AsFloat);
  except
  end;

end;  {GetUniqueSQLID}

{========================================================================}
Procedure _Query(      Query : TQuery;
                 const Expression : Array of String);

var
  I : Integer;

begin
  with Query.SQL do
    begin
      Clear;

      For I := 0 to High(Expression) do
        Add(Expression[I]);

    end;

  try
    Query.Open;
  except
  end;

end;  {_Query}

{========================================================================}
Procedure _ADOQuery(      Query : TADOQuery;
                    const Expression : Array of String);

var
  I : Integer;

begin
  with Query do
    If Active
      then
        try
          If _Compare(RecordCount, 0, coGreaterThan)
            then
              If EOF
                then First
                else
                  If BOF
                    then Last;
        finally
          Close;
        end;  {If Active}

  with Query.SQL do
    begin
      Clear;

      For I := 0 to High(Expression) do
        Add(Expression[I]);

    end;

  (*try *)
    Query.Open;
  (*except
  end; *)

end;  {_ADOQuery}

{========================================================================}
Procedure _QueryExec(      Query : TQuery;
                     const Expression : Array of String);

var
  I : Integer;

begin
  with Query.SQL do
    begin
      Clear;

      For I := 0 to High(Expression) do
        Add(Expression[I]);

    end;

  try
    Query.ExecSQL;
  except
  end;

end;  {_QueryExec}

{========================================================================}
Procedure _ADOQueryExec(      Query : TADOQuery;
                        const Expression : Array of String);

var
  I : Integer;
  sSQL : String;
  TempFile : TextFile;

begin
  (*AssignFile(TempFile, 'c:\temp3\SQL.txt');
  Rewrite(TempFile);   *)
  Query.Close;
  with Query.SQL do
    begin
      Clear;
      sSQL := '';

      For I := 0 to High(Expression) do
      begin
        Add(Expression[I]);
        (*System.Append(TempFile);
        Writeln(TempFile, Expression[I]);
        CloseFile(TempFile); 
        sSQL := sSQL + ' ' + Expression[I]; *)
      end;

      //MessageDlg(sSQL, mtInformation, [mbOK], 0);
    end;
    
{$H-}

  try
    Query.ExecSQL;
  except
  end;    

end;  {_ADOQueryExec}

end.
