unit USENRCHK;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus;

type
  TSeniorExemptionCheckForm = class(TForm)
    ExemptionTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    OKButton: TBitBtn;
    RecCountLabel: TLabel;
    TestEdit: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OKButtonClick(Sender: TObject);
    procedure TestEditExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, UTILEXSD,  DCONVUTL, Types,
     PASTypes;

{$R *.DFM}

{========================================================}
Procedure TSeniorExemptionCheckForm.InitializeForm;

begin
  UnitName := 'TEMPLATE.PAS';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

end;  {InitializeForm}

{===================================================================}
Procedure TSeniorExemptionCheckForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{=================================================================}
Procedure TSeniorExemptionCheckForm.OKButtonClick(Sender: TObject);

const
  MaxNumSDPerLine = 25;
  StartSDCodePos = 40;
  MaxNumEXPerLine = 27;
  StartEXCodePos = 40;

var
  ErrorFile : TextFile;
  RPSFile : File;
  PASAmount, RPSSeniorAmount : Double;
  ReadBuff : RPSImportRec;
  Found, Done : Boolean;
  Index, Offset, ReturnCode, Count : Integer;
  RecCount : LongInt;
  SwisSBLKey : Str26;

begin
  Done := False;
  Count := 1;
  RecCount := 0;
  AssignFile(RPSFile, GlblRPSDataDir + 'RPS995T1');
  Reset(RpsFile, RPSImportRecordLength);

  AssignFile(ErrorFile, GlblRPSDataDir + 'SNRERROR.TXT');
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
        (ReadBuff[32] = 'P') and  {Exemption rec.}
        (ReadBuff[821] = '1'))    {2 = This year,4 = nxt yr}
      then
        begin
          SwisSBLKey := GetField(26, 1, 26, ReadBuff);

          try
            RPSSeniorAmount := StrToFloat(GetField(9, 708, 716, ReadBuff));
          except
            RPSSeniorAmount := 0;
          end;

          If (Roundoff(RPSSeniorAmount, 0) > 0)
            then
              begin
                try
                  Found := ExemptionTable.FindKey([GlblThisYear, SwisSBLKey, '41800']);
                except
                  MessageDlg('Error finding parcel ' + SwisSBLKey, mtError,
                             [mbOK], 0);
                end;

                If not Found
                  then Writeln(ErrorFile, 'Exemption not found parcel ' + SwisSBLKey);

                with ExemptionTable do
                  PASAmount := FieldByName('SchoolAmount').AsFloat;

                If (Roundoff(PASAmount, 0) <> Roundoff(RPSSeniorAmount, 0))
                  then Writeln(ErrorFile, 'Exemption = 41800' +
                                          '  SBL = ' +
                                           ConvertSwisSBLToDashDot(SwisSBLKey) +
                                           '  RPS amount = ' + FormatFloat('0.', RPSSeniorAmount) +
                                           '  PAS amount = ' + FormatFloat('0.', PASAmount));

              end;  {If (Roundoff(RPSSeniorAmount, 0) > 0)}

        end;  {If ((not Done) and ...}

  until Done;

  CloseFile(ErrorFile);
  CloseFile(RPSFile);

end;  {OKButtonClick}

{===================================================================}
Procedure TSeniorExemptionCheckForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

procedure TSeniorExemptionCheckForm.TestEditExit(Sender: TObject);
begin
  TestEdit.Text := FloatToStr(Roundoff(StrToFloat(TestEdit.Text), 0));
end;

end.