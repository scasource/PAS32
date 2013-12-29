unit DeleteFileOnCloseUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TDeleteFilesOnCloseForm = class(TForm)
    DeleteFilesLabel: TLabel;
    DeleteFileTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure DeleteFileTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DeleteFileName, DeleteFileDirectory, LabelCaption : String;

  end;

var
  DeleteFilesOnCloseForm: TDeleteFilesOnCloseForm;

implementation

{$R *.DFM}

{================================================}
Procedure TDeleteFilesOnCloseForm.FormCreate(Sender: TObject);

var
  I, EqualsPos : Integer;

begin
  For I := 1 to ParamCount do
    begin
      If (Pos('FILENAME', ANSIUppercase(ParamStr(I))) > 0)
        then
          begin
            EqualsPos := Pos('=', ParamStr(I));
            DeleteFileName := Copy(ParamStr(I), (EqualsPos + 1), 200);
            DeleteFileName := Trim(DeleteFileName);

          end;  {If (Pos('FILENAME', ANSIUppercase(ParamStr(I))) > 0)}

      If (Pos('FILEDIRECTORY', ANSIUppercase(ParamStr(I))) > 0)
        then
          begin
            EqualsPos := Pos('=', ParamStr(I));
            DeleteFileDirectory := Copy(ParamStr(I), (EqualsPos + 1), 200);
            DeleteFileDirectory := Trim(DeleteFileDirectory);
            DeleteFileDirectory := StringReplace(DeleteFileDirectory,
                                                 '"', '', [rfReplaceAll]);

          end;  {If (Pos('FILEDIRECTORY', ANSIUppercase(ParamStr(I))) > 0)}

      If (Pos('LABEL', ANSIUppercase(ParamStr(I))) > 0)
        then
          begin
            EqualsPos := Pos('=', ParamStr(I));
            LabelCaption := Copy(ParamStr(I), (EqualsPos + 1), 200);
            DeleteFilesLabel.Caption := Trim(LabelCaption);

          end;  {If (Pos('LABEL', ANSIUppercase(ParamStr(I))) > 0)}

    end;  {For I := 1 to ParamCount do}

  DeleteFileTimer.Enabled := True;

end;  {FormCreate}

{================================================}
Procedure TDeleteFilesOnCloseForm.DeleteFileTimerTimer(Sender: TObject);

var
  Return : Integer;
  Done, FirstTimeThrough : Boolean;
  SearchRec : TSearchRec;

begin
  DeleteFileTimer.Enabled := False;

  Done := False;
  Return := 0;
  FirstTimeThrough := True;
  FindFirst(DeleteFileDirectory + DeleteFileName + '.*', faAnyFile, SearchRec);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Return := FindNext(SearchRec);

    If (Return <> 0)
      then Done := True;

    If ((not Done) and
        (SearchRec.Name <> '.') and
        (SearchRec.Name <> '..'))
      then
        try
          DeleteFile(DeleteFileDirectory + SearchRec.Name);
        except
        end;

  until Done;

  Close;

end;  {DeleteFileTimerTimer}

end.
