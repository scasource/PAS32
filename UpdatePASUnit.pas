unit UpdatePASUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Buttons, ShellAPI;

type
  TUpdatePASForm = class(TForm)
    StartCopyTimer: TTimer;
    Label1: TLabel;
    CancelButton: TBitBtn;
    TryLabel: TLabel;
    FileCopyAnimate: TAnimate;
    procedure FormCreate(Sender: TObject);
    procedure StartCopyTimerTimer(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SourceFileName, LocalFileName, StartingDirectory : String;
    FileSize : LongInt;
    Cancelled : Boolean;
    NumberOfTries : Integer;

    Procedure RestartPAS(Parameter : String);
  end;

var
  UpdatePASForm: TUpdatePASForm;

implementation

{$R *.DFM}

{==================================================================}
Function CopyOneFile(SourceName,
                     DestinationName : String) : Boolean;

{Actual copy of file routine that copies from a fully qualified source file name
 to a fully qualified destination name.}

var
  SourceLen, DestLen : Integer;
  SourceNamePChar, DestNamePChar : PChar;

begin
  SourceLen := Length(SourceName);
  DestLen := Length(DestinationName);

  SourceNamePChar := StrAlloc(SourceLen + 1);
  DestNamePChar := StrAlloc(DestLen + 1);

  StrPCopy(SourceNamePChar, SourceName);
  StrPCopy(DestNamePChar, DestinationName);

  Result := CopyFile(SourceNamePChar, DestNamePChar, False);

  StrDispose(SourceNamePChar);
  StrDispose(DestNamePChar);

end;  {CopyOneFile}

{======================================================}
Procedure TUpdatePASForm.RestartPAS(Parameter : String);

{Start PAS up again.}

var
  ProgramToExecutePChar, ParameterPChar, StartingDirectoryPChar : PChar;
  TempLen : Integer;

begin
  TempLen := Length(LocalFileName);
  ProgramToExecutePChar := StrAlloc(TempLen + 1);
  StrPCopy(ProgramToExecutePChar, LocalFileName);

  If (Parameter = '')
    then ParameterPChar := nil
    else
      begin
        TempLen := Length(Parameter);
        ParameterPChar := StrAlloc(TempLen + 1);
        StrPCopy(ParameterPChar, Parameter);
      end;

  TempLen := Length(StartingDirectory);
  StartingDirectoryPChar := StrAlloc(TempLen + 1);
  StrPCopy(StartingDirectoryPChar, StartingDirectory);

(*  WinExec(ProgramToExecutePChar, SW_SHOW);*)

    {FXX05082003-2(2.07a): Actually, start it using ShellExecute so that we can specify the directory.}

  ShellExecute(Handle, 'open', ProgramToExecutePChar, ParameterPChar, StartingDirectoryPChar, SW_SHOW);

  StrDispose(ProgramToExecutePChar);
  StrDispose(ParameterPChar);
  Close;
  Application.Terminate;

end;  {RestartPAS}

{====================================================================}
Function ReturnPath(Path : String) : String;

{Remove the file name from a path.}

var
  TempLen, Index : Integer;
  SlashFound : Boolean;

begin
  TempLen := Length(Path);
  Index := TempLen;
  SlashFound := False;

  while ((Index > 0) and
         (not SlashFound)) do
    If (Path[Index] = '\')
      then SlashFound := True
      else Index := Index - 1;

  If (Index = 0)
    then Result := ''
    else Result := Copy(Path, 1, Index);

end;  {ReturnPath}

{======================================================}
Procedure TUpdatePASForm.FormCreate(Sender: TObject);

var
  I, EqualsPOS : Integer;

begin
  Cancelled := False;
  NumberOfTries := 0;
  For I := 1 to ParamCount do
    begin
      If (Pos('SOURCEFILE', ANSIUppercase(ParamStr(I))) > 0)
        then
          begin
            EqualsPos := Pos('=', ParamStr(I));
            SourceFileName := Copy(ParamStr(I), (EqualsPos + 1), 200);
            SourceFileName := Trim(SourceFileName);

          end;  {If (Pos('SOURCEFILE', ANSIUppercase(ParamStr(I))) > 0)}

      If (Pos('LOCALFILE', ANSIUppercase(ParamStr(I))) > 0)
        then
          begin
            EqualsPos := Pos('=', ParamStr(I));
            LocalFileName := Copy(ParamStr(I), (EqualsPos + 1), 200);
            LocalFileName := Trim(LocalFileName);

          end;  {If (Pos('LOCALFILE', ANSIUppercase(ParamStr(I))) > 0)}

    end;  {For I := 1 to ParamCount do}

  try
    Application.Icon.LoadFromFile('PASUpdate.ico');
  except
  end;

  StartingDirectory := ReturnPath(SourceFileName);

  FileCopyAnimate.Active := True;
  StartCopyTimer.Enabled := True;

end;  {FormCreate}

{======================================================}
Procedure TUpdatePASForm.StartCopyTimerTimer(Sender: TObject);

begin
  StartCopyTimer.Enabled := False;

  Refresh;
  Application.ProcessMessages;

  If CopyOneFile(SourceFileName, LocalFileName)
    then RestartPAS('')
    else
      begin
        TryLabel.Visible := True;
        NumberOfTries := NumberOfTries + 1;
        TryLabel.Caption := 'Attempt #' + IntToStr(NumberOfTries);
        Application.ProcessMessages;

        If not Cancelled
          then StartCopyTimer.Enabled := True;

      end;  {else of If CopyOneFile(SourceFileName, LocalFileName)}

end;  {StartCopyTimerTimer}

{======================================================}
Procedure TUpdatePASForm.CancelButtonClick(Sender: TObject);

begin
  Cancelled := True;
  RestartPAS('CANCELUPDATE');

end;  {CancelButtonClick}

end.
