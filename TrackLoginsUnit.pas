unit TrackLoginsUnit;

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, DB, DBTables;

Procedure TrackUserLogin(UserID : String;
                         ActionType : Integer);

const
  lgIn = 0;
  lgOut = 1;

implementation

{===================================================================}
Function GetComputerNameAsString : String;

const
  MAX_COMPUTERNAME_LENGTH = 15;

var
  Name : array[0..MAX_COMPUTERNAME_LENGTH] of Char;
  Size : DWORD;

begin
  Size := SizeOf(Name) div SizeOf(Name[0]);

  try
    If GetComputerName(Name, Size)
      then Result := Name
      else Result := '';
  except
    Result := '';
  end;

end;  {GetComputerNameAsString}

{===================================================================}
Procedure TrackUserLogin(UserID : String;
                         ActionType : Integer);

{CHG03222004-1(2.08): Track user logins.}

var
  LoginTable : TTable;

begin
  LoginTable := TTable.Create(nil);

  with LoginTable do
    begin
      DatabaseName := 'PASsystem';
      TableName := 'LoginTrackingTable';
      TableType := ttDBase;

      try
        Open;
        Insert;
        FieldByName('UserID').Text := UserID;
        FieldByName('Action').AsInteger := ActionType;
        FieldByName('Date').AsDateTime := Date;
        FieldByName('Time').AsDateTime := Now;
        FieldByName('MachineName').Text := GetComputerNameAsString;
        Post;
      except
        {Ignore the exception.}
      end;

    end;  {with LoginTable do}

end;  {TrackUserLogins}

end.
