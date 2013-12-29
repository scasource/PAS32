unit UpdateBDEParametersUnit;

interface

uses BDE, DBTables, Classes, SysUtils, Forms, Dialogs, DB;

Procedure UpdateBDEParameters(Application : TApplication);

const
  DBASEVERSION = '\DRIVERS\DBASE\INIT\;VERSION';
  DBASETYPE = '\DRIVERS\DBASE\INIT\;TYPE';
  DBASELANGDRIVER = '\DRIVERS\DBASE\INIT\;LANGDRIVER';
  DBASELEVEL = '\DRIVERS\DBASE\TABLE CREATE\;LEVEL';
  DBASEMDXBLOCKSIZE = '\DRIVERS\DBASE\TABLE CREATE\;MDX BLOCK SIZE';
  DBASEMEMOFILEBLOCKSIZE = '\DRIVERS\DBASE\TABLE CREATE\;MEMO FILE BLOCK SIZE';
  AUTOODBC = '\SYSTEM\INIT\;AUTO ODBC';
  DATAREPOSITORY = '\SYSTEM\INIT\;DATA REPOSITORY';
  DEFAULTDRIVER = '\SYSTEM\INIT\;DEFAULT DRIVER';
  LANGDRIVER = '\SYSTEM\INIT\;LANGDRIVER';
  LOCALSHARE = '\SYSTEM\INIT\;LOCAL SHARE';
  LOWMEMORYUSAGELIMIT = '\SYSTEM\INIT\;LOW MEMORY USAGE LIMIT';
  MAXBUFSIZE = '\SYSTEM\INIT\;MAXBUFSIZE';
  MAXFILEHANDLES = '\SYSTEM\INIT\;MAXFILEHANDLES';
  MEMSIZE = '\SYSTEM\INIT\;MEMSIZE';
  MINBUFSIZE = '\SYSTEM\INIT\;MINBUFSIZE';
  MTSPOOLING = '\SYSTEM\INIT\;MTS POOLING';
  SHAREDMEMLOCATION = '\SYSTEM\INIT\;SHAREDMEMLOCATION';
  SHAREDMEMSIZE = '\SYSTEM\INIT\;SHAREDMEMSIZE';
  SQLQRYMODE = '\SYSTEM\INIT\;SQLQRYMODE';
  SYSFLAGS = '\SYSTEM\INIT\;SYSFLAGS';
  VERSION = '\SYSTEM\INIT\;VERSION';

implementation

{===================================================}
Function SetConfigParameter(    Param : string;
                                Value : string;
                            var ResultMsg : String) : Boolean;

var
  hCur: hDBICur;
  rslt: DBIResult;
  Config: CFGDesc;
  Path, Option: String;
  Temp: array[0..255] of char;
  TempStr : String;
  I : Integer;
  Successful : Boolean;

begin
  hCur := nil;
  Successful := True;

  try
    If (Pos(';', Param) = 0)
      then
        raise EDatabaseError.Create('Invalid parameter passed to' +
                                    'function.  There must be a semicolon delimited sting passed');

    Path := Copy(Param, 0, Pos(';', Param) - 1);
    Option := Copy(Param, Pos(';', Param) + 1, Length(Param) - Pos(';', Param));

    Check(DbiOpenCfgInfoList(nil, dbiREADWRITE, cfgPERSISTENT,
                             StrPCopy(Temp, Path), hCur));

    Check(DbiSetToBegin(hCur));

    repeat
      rslt := DbiGetNextRecord(hCur, dbiNOLOCK, @Config, nil);

      If (rslt = DBIERR_NONE)
        then
          begin
            TempStr := StrPas(Config.szNodeName);

            If (StrPas(Config.szNodeName) = Option)
              then
                begin
                    {To set the value, copy in byte by byte and make the following
                     byte null.}

                  For I := 0 to (Length(Value) - 1) do
                    Config.szValue[I] := Value[I + 1];

                  Config.szValue[Length(Value)] := #0;

                  rslt := dbiModifyRecord(hCur, @Config, True);

                  Successful := (Rslt = DBIERR_NONE);

                end;  {If (StrPas(Config.szNodeName) = Option)}

          end
        else
          If (rslt <> DBIERR_EOF)
            then Check(rslt);

    until (rslt <> DBIERR_NONE);

  finally
    If (hCur <> nil)
      then Check(DbiCloseCursor(hCur));
  end;

  If Successful
    then TempStr := 'was'
    else TempStr := 'was not';

  ResultMsg := 'The BDE parameter ' + Option + ' ' +
               TempStr + ' successfully set to ' +
               Value;

  Result := Successful;

end;  {SetConfigParameter}

{===================================================}
Function SetBDEConfigParameter(    ParameterName : String;
                                   ParameterValue : String;
                               var ResultMsg : String) : Boolean;

var
  ParameterPath : String;

begin
  ParameterName := ANSIUpperCase(ParameterName);
  
  If (ParameterName = 'DBASEVERSION')
    then ParameterPath := DBASEVERSION;
  If (ParameterName = 'DBASETYPE')
    then ParameterPath := DBASETYPE;
  If (ParameterName = 'DBASELANGDRIVER')
    then ParameterPath := DBASELANGDRIVER;
  If (ParameterName = 'DBASELEVEL')
    then ParameterPath := DBASELEVEL;
  If (ParameterName = 'DBASEMDXBLOCKSIZE')
    then ParameterPath := DBASEMDXBLOCKSIZE;
  If (ParameterName = 'DBASEMEMOFILEBLOCKSIZE')
    then ParameterPath := DBASEMEMOFILEBLOCKSIZE;
  If (ParameterName = 'AUTOODBC')
    then ParameterPath := AUTOODBC;
  If (ParameterName = 'DATAREPOSITORY')
    then ParameterPath := DATAREPOSITORY;
  If (ParameterName = 'DEFAULTDRIVER')
    then ParameterPath := DEFAULTDRIVER;
  If (ParameterName = 'LANGDRIVER')
    then ParameterPath := LANGDRIVER;
  If (ParameterName = 'LOCALSHARE')
    then ParameterPath := LOCALSHARE;
  If (ParameterName = 'LOWMEMORYUSAGELIMIT')
    then ParameterPath := LOWMEMORYUSAGELIMIT;
  If (ParameterName = 'MAXBUFSIZE')
    then ParameterPath := MAXBUFSIZE;
  If (ParameterName = 'MAXFILEHANDLES')
    then ParameterPath := MAXFILEHANDLES;
  If (ParameterName = 'MEMSIZE')
    then ParameterPath := MEMSIZE;
  If (ParameterName = 'MINBUFSIZE')
    then ParameterPath := MINBUFSIZE;
  If (ParameterName = 'MTSPOOLING')
    then ParameterPath := MTSPOOLING;
  If (ParameterName = 'SHAREDMEMLOCATION')
    then ParameterPath := SHAREDMEMLOCATION;
  If (ParameterName = 'SHAREDMEMSIZE')
    then ParameterPath := SHAREDMEMSIZE;
  If (ParameterName = 'SQLQRYMODE')
    then ParameterPath := SQLQRYMODE;
  If (ParameterName = 'SYSFLAGS')
    then ParameterPath := SYSFLAGS;
  If (ParameterName = 'VERSION')
    then ParameterPath := VERSION;

  If (Trim(ParameterPath) <> '')
    then Result := SetConfigParameter(ParameterPath, ParameterValue, ResultMsg)
    else Result := False;

end;  {SetBDEConfigParameter}

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
Procedure UpdateBDEParameters(Application : TApplication);

var
  ParameterFile : TextFile;
  FieldList : TStringList;
  TempStr, ResultMsg, AppPath : String;
  Done : Boolean;

begin
  Done := False;
  FieldList := TStringList.Create;
  AppPath := ExtractFilePath(ExpandFileName(Application.ExeName));

  try
    AssignFile(ParameterFile, AppPath + 'WorkstationParameters.txt');
    Reset(ParameterFile);

    repeat
      Readln(ParameterFile, TempStr);

      If EOF(ParameterFile)
        then Done := True;

      ParseCommaDelimitedStringIntoFields(TempStr, FieldList, False);

      If (FieldList.Count > 0)
        then SetBDEConfigParameter(FieldList[0], FieldList[1], ResultMsg);

    until Done;

    CloseFile(ParameterFile);
  except
  end;

  FieldList.Free;

end;  {UpdateBDEParameters}


end.
