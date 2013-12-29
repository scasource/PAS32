unit SetSiteValuesFrom995Unit;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DB, BtrConv, DBTables, Mask, Types,
  ExtCtrls;

type
  TForm1 = class(TForm)
    StartButton: TBitBtn;
    Label2: TLabel;
    SwisSBLKeyLabel: TLabel;
    RecCountLabel: TLabel;
    CurrentYearEdit: TEdit;
    Label1: TLabel;
    OpenDialog: TOpenDialog;
    ResidentialSiteTable: TTable;
    CommercialSiteTable: TTable;
    AssessmentTable: TTable;
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
  Key : Str2;
  Found, Quit, Done, FirstTimeThrough : Boolean;
  SwisSBLKey : Str26;
  KeyNum, RecCount, SalesNumber : LongInt;
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
  ResidentialSiteTable.Open;
  CommercialSiteTable.Open;

    {First blank out the hold prior values already there for safety.}

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

          Key := ReadBuff[33] + ReadBuff[34];

          If (Deblank(Key) = '')
            then KeyNum := -1
            else
              try
                KeyNum := StrToInt(Key);
              except
                KeyNum := - 1;
              end;

          Key := ReadBuff[27] + ReadBuff[28];

          If (Deblank(Key) = '')
            then SalesNumber := 0
            else
              try
                SalesNumber := StrToInt(Key);
              except
                SalesNumber := 0;
              end;

          If ((ReadBuff[32] = 'R') and  {Site rec.}
              (SalesNumber = 0) and
              (KeyNum = 0))    {Record number = 00 -> base record}
            then
              begin
                Found := FindKeyOld(ResidentialSiteTable, ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                    [CurrentYearEdit.Text, SwisSBLKey, '1']);

                If Found
                  then
                    with ResidentialSiteTable do
                      try
                        Edit;

                        try
                          FieldByName('FinalLandValue').AsFloat := StrToFloat(GetField(12, 99, 110, ReadBuff));
                        except
                          FieldByName('FinalLandValue').AsFloat := 0;
                        end;

                        try
                          FieldByName('FinalTotalValue').AsFloat := StrToFloat(GetField(12, 87, 98, ReadBuff));
                        except
                          FieldByName('FinalTotalValue').AsFloat := 0;
                        end;

                        Post;
                      except
                        MessageDlg('Error posting res values for ' + SwisSBLKey + '.',
                                   mtError, [mbOK], 0);
                      end
                  else MessageDlg('Res site not found for ' + SwisSBLKey + '.',
                                  mtError, [mbOK], 0);


                Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                                    [CurrentYearEdit.Text, SwisSBLKey]);

                If Found
                  then
                    with AssessmentTable do
                      try
                        Edit;
                        FieldByName('LandAssessedVal').AsInteger := ResidentialSiteTable.FieldByName('FinalLandValue').AsInteger;
                        FieldByName('TotalAssessedVal').AsInteger := ResidentialSiteTable.FieldByName('FinalTotalValue').AsInteger;
                        Post;
                      except
                        MessageDlg('Error assessment values for ' + SwisSBLKey + '.',
                                   mtError, [mbOK], 0);
                      end
                  else MessageDlg('Assessment rec not found for ' + SwisSBLKey + '.',
                                  mtError, [mbOK], 0);

              end;  {If ((ReadBuff[32] = 'R') and ...}

          If ((ReadBuff[32] = 'C') and  {Site rec.}
              (SalesNumber = 0) and
              (KeyNum = 0))    {Record number = 00 -> base record}
            then
              begin
                Found := FindKeyOld(CommercialSiteTable, ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                    [CurrentYearEdit.Text, SwisSBLKey, '1']);

                If Found
                  then
                    with CommercialSiteTable do
                      try
                        Edit;

                        try
                          FieldByName('FinalLandValue').AsFloat := StrToFloat(GetField(12, 110, 121, ReadBuff));
                        except
                          FieldByName('FinalLandValue').AsFloat := 0;
                        end;

                        try
                          FieldByName('FinalTotalValue').AsFloat := StrToFloat(GetField(12, 98, 109, ReadBuff));
                        except
                          FieldByName('FinalTotalValue').AsFloat := 0;
                        end;

                        Post;
                      except
                        MessageDlg('Error posting com values for ' + SwisSBLKey + '.',
                                   mtError, [mbOK], 0);
                      end
                  else MessageDlg('Com site not found for ' + SwisSBLKey + '.',
                                  mtError, [mbOK], 0);


                Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                                    [CurrentYearEdit.Text, SwisSBLKey]);

                If Found
                  then
                    with AssessmentTable do
                      try
                        Edit;
                        FieldByName('LandAssessedVal').AsInteger := CommercialSiteTable.FieldByName('FinalLandValue').AsInteger;
                        FieldByName('TotalAssessedVal').AsInteger := CommercialSiteTable.FieldByName('FinalTotalValue').AsInteger;
                        Post;
                      except
                        MessageDlg('Error assessment values for ' + SwisSBLKey + '.',
                                   mtError, [mbOK], 0);
                      end
                  else MessageDlg('Assessment rec not found for ' + SwisSBLKey + '.',
                                  mtError, [mbOK], 0);

              end;  {If ((ReadBuff[32] = 'R') and ...}


          SwisSBLKeyLabel.Caption := SwisSBLKey;
          Application.ProcessMessages;

        until Done;

      end;  {If OpenDialog.Execute}

  AssessmentTable.Close;
  ResidentialSiteTable.Close;
  CommercialSiteTable.Close;

  MessageDlg('Done.', mtInformation, [mbOk], 0);

  CloseFile(RPSFile);

end;  {StartButtonClick}

end.