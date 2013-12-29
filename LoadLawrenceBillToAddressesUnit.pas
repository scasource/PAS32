unit LoadLawrenceBillToAddressesUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Db, DBTables, Buttons;

type
  TForm1 = class(TForm)
    StartButton: TBitBtn;
    ParcelTable: TTable;
    AssessmentRadioGroup: TRadioGroup;
    BillToNameAddressTable: TTable;
    RecCountLabel: TLabel;
    procedure StartButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{===================================================}
Function FindKeyOld(      Table : TTable;
                    const _Fields : Array of String;
                    const Values : Array of String) : Boolean;

{For backwards compatibility.}

var
  I : Integer;

begin
  with Table do
    begin
      SetKey;

      For I := 0 to High(_Fields) do
        FieldByName(_Fields[I]).Text := Values[I];

      Result := GotoKey;

    end;  {with Table do}

end;  {FindKeyOld}

{=========================================================}
Procedure TForm1.StartButtonClick(Sender: TObject);

var
  TableName : String;
  _Found, Done, FirstTimeThrough : Boolean;
  RecCount : Integer;

begin
  Done := False;
  FirstTimeThrough := True;
  RecCount := 0;

  case AssessmentRadioGroup.ItemIndex of
    0 : TableName := 'TParcelRec';
    1 : TableName := 'NParcelRec';
  end;

  ParcelTable.TableName := TableName;
  ParcelTable.Open;

  BillToNameAddressTable.Open;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else BillToNameAddressTable.Next;

    If BillToNameAddressTable.EOF
      then Done := True;

    RecCount := RecCount + 1;
    RecCountLabel.Caption := IntToStr(RecCount);
    Application.ProcessMessages;

    If not Done
      then
        begin
          _Found := FindKeyOld(ParcelTable, ['AccountNo'],
                               [BillToNameAddressTable.FieldByName('ParcelID').Text]);

          If _Found
            then
              with ParcelTable do
                try
                  Edit;
                  FieldByName('Name1').Text := BillToNameAddressTable.FieldByName('BillName1').Text;
                  FieldByName('Name2').Text := BillToNameAddressTable.FieldByName('BillName2').Text;
                  FieldByName('Address1').Text := BillToNameAddressTable.FieldByName('BillAddr1').Text;
                  FieldByName('Address2').Text := BillToNameAddressTable.FieldByName('BillAddr2').Text;
                  FieldByName('Street').Text := '';
                  FieldByName('City').Text := BillToNameAddressTable.FieldByName('BillCity').Text;
                  FieldByName('State').Text := BillToNameAddressTable.FieldByName('BillState').Text;
                  FieldByName('Zip').Text := Copy(BillToNameAddressTable.FieldByName('BillZip').Text, 1, 5);
                  FieldByName('ZipPlus4').Text := '';
                  Post;
                except
                  MessageDlg('Error posting for ' +
                             BillToNameAddressTable.FieldByName('ParcelID').Text + '.',
                             mtError, [mbOK], 0);
                end
              else MessageDlg('Error finding parcel for ' +
                              BillToNameAddressTable.FieldByName('ParcelID').Text + '.',
                              mtError, [mbOK], 0);

        end;  {If not Done}

  until Done;

  ParcelTable.Close;

end;

end.
