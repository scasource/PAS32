unit usth995;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DB, BtrConv, DBTables, Mask, Types,
  ExtCtrls;

type
  TForm1 = class(TForm)
    StartButton: TBitBtn;
    AssessmentTable: TTable;
    Label2: TLabel;
    SwisSBLKeyLabel: TLabel;
    RecCountLabel: TLabel;
    CurrentYearEdit: TEdit;
    ParcelTable: TTable;
    Label1: TLabel;
    OpenDialog: TOpenDialog;
    ClassTable: TTable;
    procedure StartButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

uses Utilitys, PasUtils, PASTypes, GlblCnst, GlblVars, WinUtils, DCONVUTL;

{$R *.DFM}

{==============================================================}
Procedure TForm1.StartButtonClick(Sender: TObject);

var
  Found, Quit, Done, FirstTimeThrough : Boolean;
  SwisSBLKey : Str26;
  RecCount : LongInt;
  ChangeFile : TextFile;
  SBLRec : SBLRecord;
  ReadBuff : RPSImportRec;
  RPSFile : File;
  ReturnCode, Count : Integer;
  TempStr : String;

begin
  RecCount := 0;
  Count := 1;
  StringPaddedSpaces := True;

  AssessmentTable.Open;
  ParcelTable.Open;
  ClassTable.Open;

    {First blank out the hold prior values already there for safety.}

  Label1.Caption := 'Assessment: Clearing Values';
  Done := False;
  FirstTimeThrough := True;

  AssessmentTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else AssessmentTable.Next;

    If AssessmentTable.EOF
      then Done := True;

    SwisSBLKey := AssessmentTable.FieldByName('SwisSBLKey').Text;

    If not Done
      then
        with AssessmentTable do
          try
            Edit;

            FieldByName('HoldPriorValue').AsFloat := 0;

            Post;
          except
            MessageDlg('Error setting prior hold field for ' + SwisSBLKey,
                       mtError, [mbOK], 0);
          end;

    RecCount := RecCount + 1;
    RecCountLabel.Caption := IntToStr(RecCount);
    SwisSBLKeyLabel.Caption := SwisSBLKey;
    Application.ProcessMessages;

  until Done;

  Label1.Caption := 'Class: Clearing Values';
  Done := False;
  FirstTimeThrough := True;

  ClassTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ClassTable.Next;

    If ClassTable.EOF
      then Done := True;

    SwisSBLKey := ClassTable.FieldByName('SwisSBLKey').Text;

    If not Done
      then
        with ClassTable do
          try
            Edit;

            FieldByName('HstdHoldPriorVal').AsFloat := 0;
            FieldByName('NonhstdHoldPriorVal').AsFloat := 0;

            Post;
          except
            MessageDlg('Error setting prior hold field for ' + SwisSBLKey,
                       mtError, [mbOK], 0);
          end;

    RecCount := RecCount + 1;
    RecCountLabel.Caption := IntToStr(RecCount);
    SwisSBLKeyLabel.Caption := SwisSBLKey;
    Application.ProcessMessages;

  until Done;

    {First blank out the hold prior values already there for safety.}

  Label1.Caption := 'Parcel: Clearing Values';
  Done := False;
  FirstTimeThrough := True;

  ParcelTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If ParcelTable.EOF
      then Done := True;

    SwisSBLKey := ExtractSSKey(ParcelTable);

    If not Done
      then
        with ParcelTable do
          try
            Edit;

            FieldByName('HoldPriorHomestead').Text := '';
            FieldByName('HoldPriorRollSection').Text := '';
            FieldByName('HoldPriorPropClass').Text := '';
            FieldByName('HoldPriorStatus').Text := '';

            Post;
          except
            MessageDlg('Error setting prior hold field for ' + SwisSBLKey,
                       mtError, [mbOK], 0);
          end;

    RecCount := RecCount + 1;
    RecCountLabel.Caption := IntToStr(RecCount);
    SwisSBLKeyLabel.Caption := SwisSBLKey;
    Application.ProcessMessages;

  until Done;

    {Set the values.}

  RecCount := 0;
  Done := False;
  FirstTimeThrough := True;
  Label1.Caption := 'Setting values';

  If OpenDialog.Execute
    then
      begin
        AssignFile(RPSFile, OpenDialog.FileName);
        Reset(RpsFile, RPSImportRecordLength);

        repeat
          try
            BlockRead(RpsFile, ReadBuff, Count, ReturnCode);
          except
            Done := True;
          end;

          Application.ProcessMessages;

          If EOF(RpsFile)
            then Done := True;

          RecCount := RecCount + 1;
          RecCountLabel.Caption := 'Tot Rec Count = ' + IntToStr(RecCount);

          SwisSBLKey := GetField(26, 1, 26, ReadBuff);
          SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

          Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                              [CurrentYearEdit.Text, SwisSBLKey]);

          with SBLRec do
            FindKeyOld(ParcelTable,
                       ['TaxRollYr', 'SwisCode', 'Section',
                        'Subsection', 'Block', 'Lot',
                        'Sublot', 'Suffix'],
                       [CurrentYearEdit.Text, SwisCode, Section, Subsection,
                        Block, Lot, Sublot, Suffix]);

          If ((not Done) and
              (ReadBuff[32] = 'P') and
              (ReadBuff[821] = '1'))
            then
              begin
                with AssessmentTable do
                  try
                    Edit;

                    try
(*                      TempStr := ConvNumToDec(12, 519, 530, ReadBuff);*)
                      TempStr := ConvNumToDec(12, 543, 554, ReadBuff);
                      FieldByName('HoldPriorValue').Text:= Trim(TempStr);
                    except
                      MessageDlg('Error converting prior value ' + TempStr +
                                 ' to numeric for ' + SwisSBLKey, mtError, [mbOK], 0);
                    end;

                    Post;
                  except
                    MessageDlg('Error setting prior hold field for ' + SwisSBLKey,
                               mtError, [mbOK], 0);
                  end;

                with ParcelTable do
                  try
                    Edit;

                    FieldByName('HoldPriorHomestead').Text := GetField(1, 271, 271, ReadBuff);
                    FieldByName('HoldPriorRollSection').Text := GetField(1, 447, 447, ReadBuff);
                    FieldByName('HoldPriorPropClass').Text := GetField(3, 265, 267, ReadBuff);
                    FieldByName('HoldPriorStatus').Text := GetField(1,740,740,ReadBuff);

                    Post;
                  except
                    MessageDlg('Error setting prior hold field for ' + SwisSBLKey,
                               mtError, [mbOK], 0);
                  end;

                RecCount := RecCount + 1;
                RecCountLabel.Caption := IntToStr(RecCount);

              end;  {If not Done}

             {Class values.}

          If ((not Done) and
              (ReadBuff[32] = 'H') and
              (ReadBuff[821] = '2'))
            then
              begin
                FindKeyOld(ClassTable, ['TaxRollYr', 'SwisSBLKey'],
                           [CurrentYearEdit.Text, SwisSBLKey]);

                with ClassTable do
                  try
                    Edit;

                    try
                      TempStr := ConvNumToDec(12, 91, 102, ReadBuff);
                      FieldByName('HstdHoldPriorVal').Text := Trim(TempStr);
                      TempStr := ConvNumToDec(12, 349, 360, ReadBuff);
                      FieldByName('NonhstdHoldPriorVal').Text := Trim(TempStr);
                    except
                      MessageDlg('Error converting prior class value ' + TempStr +
                                 ' to numeric for ' + SwisSBLKey, mtError, [mbOK], 0);
                    end;

                    Post;
                  except
                    MessageDlg('Error setting prior class hold field for ' + SwisSBLKey,
                               mtError, [mbOK], 0);
                  end;

              end;  {If ((not Done) and ...}

          SwisSBLKeyLabel.Caption := SwisSBLKey;
          Application.ProcessMessages;

        until Done;

      end;  {If OpenDialog.Execute}

  AssessmentTable.Close;
  ParcelTable.Close;
  ClassTable.Close;

  MessageDlg('Done.', mtInformation, [mbOk], 0);

  CloseFile(RPSFile);

end;  {StartButtonClick}

end.