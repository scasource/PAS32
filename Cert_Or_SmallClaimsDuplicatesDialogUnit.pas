unit Cert_Or_SmallClaimsDuplicatesDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables, ExtCtrls;

type
  TCert_Or_SmallClaimsDuplicatesDialog = class(TForm)
    YesButton: TBitBtn;
    NoButton: TBitBtn;
    Table: TTable;
    DescriptionLabel: TLabel;
    DuplicateCertiorariList: TListBox;
    OKButton: TBitBtn;
    PromptLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    CurrentYear : String;
    IndexNumber : LongInt;
    AskForConfirmation : Boolean;
    Source : Char;  {(C)ertiorari, (S)mall Claim}
    ActionTypeName, IndexNumberFieldName : String;

  end;

var
  Cert_Or_SmallClaimsDuplicatesDialog: TCert_Or_SmallClaimsDuplicatesDialog;

implementation

{$R *.DFM}

uses PASUtils, WinUtils, GlblCnst;

{===============================================================}
Procedure TCert_Or_SmallClaimsDuplicatesDialog.FormShow(Sender: TObject);

var
  FirstTimeThrough, Done : Boolean;

begin
  case Source of
    'C' : begin
            ActionTypeName := 'certiorari';
            IndexNumberFieldName := 'CertiorariNumber';
            Table.TableName := CertiorariTableName;
            Table.IndexName := 'BYYEAR_CERTNUM';
          end;  {'C'}

    'S' : begin
            ActionTypeName := 'small claims';
            IndexNumberFieldName := 'IndexNumber';
            Table.TableName := SmallClaimsTableName;
            Table.IndexName := 'BYYEAR_INDEXNUM';
          end;  {'S'}

  end;  {case Source of}

  Caption := 'Parcels with ' + ActionTypeName + ' #' +
             IntToStr(IndexNumber) + '.';
  DescriptionLabel.Caption := 'The following parcels all have ' + ActionTypeName +
                              ' #' + IntToStr(IndexNumber) + '.';
  PromptLabel.Caption := 'Do you want to add this ' + ActionTypeName + ' anyway?';

  try
    Table.Open;
  except
    MessageDlg('Error opening ' + ActionTypeName + ' table.', mtError, [mbOK], 0);
  end;

  If AskForConfirmation
    then
      begin
        PromptLabel.Visible := True;
        YesButton.Visible := True;
        NoButton.Visible := True;
      end
    else
      begin
        OKButton.Visible := True;
        OKButton.Default := True;
      end;

  SetRangeOld(Table, ['TaxRollYr', IndexNumberFieldName],
              [CurrentYear, IntToStr(IndexNumber)],
              [CurrentYear, IntToStr(IndexNumber)]);

  Done := False;
  FirstTimeThrough := True;
  Table.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Table.Next;

    If Table.EOF
      then Done := True;

    If not Done
      then DuplicateCertiorariList.Items.Add(ConvertSwisSBLToDashDot(Table.FieldByName('SwisSBLKey').Text));

  until Done;

end;  {FormShow}

{==============================================================}
Procedure TCert_Or_SmallClaimsDuplicatesDialog.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
  Table.Close;
  Action := caFree;
end;

end.
