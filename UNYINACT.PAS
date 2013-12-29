unit UNYINACT;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Types,
  GlblCnst, PASUTILS, UTILEXSD,  WinUtils, Utilitys, GlblVars, PASTypes, DCONVUTL;

type
  TInactiveNYParcelsForm = class(TForm)
    Button1: TButton;
    RecCountLabel: TLabel;
    NYFoundLabel: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Cancelled : Boolean;
  end;

implementation

{$R *.DFM}

procedure TInactiveNYParcelsForm.Button1Click(Sender: TObject);

const
  MaxNumSDPerLine = 25;
  StartSDCodePos = 40;
  MaxNumEXPerLine = 27;
  StartEXCodePos = 40;

var
  ErrorFile : TextFile;
  RPSFile : File;
  PASAmount, RPSExAmount : Double;
  EXCode : Str5;
  ReadBuff : RPSImportRec;
  Found, Done, Has2Exemptions,
  FirstExMatches, SecondExMatches : Boolean;
  Index, Offset, ReturnCode, Count : Integer;
  NYFound, RecCount : LongInt;
  SwisSBLKey : Str26;
  TempStr : String;

begin
  Cancelled := False;

  Done := False;
  Count := 1;
  RecCount := 0;
  NYFound := 0;
  AssignFile(RPSFile, 'E:\PASYSTEM\RPSDATA\RPS995T1');
  Reset(RpsFile, RPSImportRecordLength);

  AssignFile(ErrorFile, 'E:\PASYSTEM\RPSDATA\NYINACT.TXT');
  Rewrite(ErrorFile);

  repeat
    Application.ProcessMessages;

    try
      BlockRead(RpsFile, ReadBuff, Count, ReturnCode);
    except
      Done := True;
    end;

    If EOF(RpsFile)
      then Done := True;

    RecCount := RecCount + 1;
    RecCountLabel.Caption := IntToStr(RecCount);

    If ((not Done) and
        (ReadBuff[32] = 'P') and  {parcel rec.}
        (ReadBuff[821] = '3'))    {2 = Next year,4 = nxt yr}
      then
        begin
          NYFound := NYFound + 1;
          NYFoundLabel.Caption := IntToStr(NYFound);

          TempStr := GetField(1, 740, 740, ReadBuff);
          SwisSBLKey := GetField(26, 1, 26, ReadBuff);

          If (TempStr = 'D')
            then Writeln(ErrorFile, SwisSBLKey, ' ', TempStr);

        end;  {For Index := 1 to MaxNumEXPerLine do}

  until (Done or Cancelled);

  CloseFile(ErrorFile);
  CloseFile(RPSFile);

end;

end.