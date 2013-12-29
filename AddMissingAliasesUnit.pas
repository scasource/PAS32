unit AddMissingAliasesUnit;

interface

uses BDE, DBTables, Classes, SysUtils, Forms, Dialogs;

Procedure AddMissingAliases(Session : TSession;
                            Application : TApplication);

implementation

{===================================================}
Function CreateBDEAlias(    Session : TSession;
                            AliasName : String;
                            AliasPath : String;
                        var ResultMsg : String) : Boolean;

var
  Error : Boolean;

begin
  Error := False;
  Result := True;

  with Session do
    try
      ConfigMode := cmPersistent;
      AddStandardAlias(AliasName, AliasPath, 'DBASE');
      SaveConfigFile;
    except
      Error := True;
      ResultMsg := 'Alias ' + AliasName + ' was NOT added successfully.';
      Result := False;
    end;

  If not Error
    then
      begin
        Result := True;
        ResultMsg := 'Alias ' + AliasName + ' was added successfully.'
      end;

end;  {CreateBDEAlias}

{$H+}
{===========================================================================}
Function StripLeadingAndEndingDuplicateChar(TempStr : String;
                                            CharToStrip : Char) : String;

begin
  Result := TempStr;

  If ((Length(Result) > 1) and
      (Result[1] = CharToStrip) and
      (Result[Length(Result)] = CharToStrip))
    then
      begin
        Delete(Result, Length(Result), 1);
        Delete(Result, 1, 1);
      end;

end;  {StripLeadingAndEndingDuplicateChar}
{$H-}


{$H+}
{===========================================================================}
Procedure ParseCommaDelimitedStringIntoFields(TempStr : String;
                                              FieldList : TStringList;
                                              CapitalizeStrings : Boolean);

var
  InEmbeddedQuote : Boolean;
  CurrentField : String;
  I : Integer;

begin
  FieldList.Clear;
  InEmbeddedQuote := False;
  CurrentField := '';

  For I := 1 to Length(TempStr) do
    begin
      If (TempStr[I] = '"')
        then InEmbeddedQuote := not InEmbeddedQuote;

        {New field if we have found comma and we are not in an embedded quote.}

      If ((TempStr[I] = ',') and
          (not InEmbeddedQuote))
        then
          begin
              {If the field starts and ends with a double quote, strip it.}

            CurrentField := StripLeadingAndEndingDuplicateChar(CurrentField, '"');

            If CapitalizeStrings
              then CurrentField := ANSIUpperCase(CurrentField);

            FieldList.Add(CurrentField);
            CurrentField := '';

          end
        else CurrentField := CurrentField + TempStr[I];

    end;  {For I := 1 to Length(TempStr) do}

  CurrentField := StripLeadingAndEndingDuplicateChar(CurrentField, '"');

  If CapitalizeStrings
    then CurrentField := ANSIUpperCase(CurrentField);

  FieldList.Add(CurrentField);

end;  {ParseCommaDelimitedStringIntoFields}
{$H-}

{================================================================================}
Procedure AddMissingAliases(Session : TSession;
                            Application : TApplication);

var
  AliasFile : TextFile;
  DatabaseList, FieldList : TStringList;
  TempStr, AliasName, ResultMsg, AppPath : String;
  Done : Boolean;

begin
  Done := False;
  FieldList := TStringList.Create;
  DatabaseList := TStringList.Create;
  Session.GetDatabaseNames(DatabaseList);
  AppPath := ExtractFilePath(ExpandFileName(Application.ExeName));

  try
    AssignFile(AliasFile, AppPath + 'Aliases.txt');

    Reset(AliasFile);

    repeat
      Readln(AliasFile, TempStr);

      If EOF(AliasFile)
        then Done := True;

      ParseCommaDelimitedStringIntoFields(TempStr, FieldList, False);

      AliasName := FieldList[0];

      If (DatabaseList.IndexOf(AliasName) = -1)
        then CreateBDEAlias(Session, AliasName, FieldList[1], ResultMsg);

    until Done;

    CloseFile(AliasFile);
  except
  end;
  
  DatabaseList.Free;
  FieldList.Free;

end;  {AddMissingAliases}


end.
