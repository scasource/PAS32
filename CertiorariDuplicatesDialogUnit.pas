unit CertiorariDuplicatesDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables, ExtCtrls;

type
  TCertiorariDuplicatesDialog = class(TForm)
    YesButton: TBitBtn;
    NoButton: TBitBtn;
    CertiorariTable: TTable;
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
    CertiorariYear : String;
    CertiorariNumber : LongInt;
    AskForConfirmation : Boolean;

  end;

var
  CertiorariDuplicatesDialog: TCertiorariDuplicatesDialog;

implementation

{$R *.DFM}

uses PASUtils, WinUtils;

{===============================================================}
Procedure TCertiorariDuplicatesDialog.FormShow(Sender: TObject);

var
  FirstTimeThrough, Done : Boolean;

begin
  Caption := 'Parcels with certiorari #' + IntToStr(CertiorariNumber) + '.';
  DescriptionLabel.Caption := 'The following parcels all have certiorari #' +
                              IntToStr(CertiorariNumber) + '.';

  try
    CertiorariTable.Open;
  except
    MessageDlg('Error opening Certiorari table.', mtError, [mbOK], 0);
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

  SetRangeOld(CertiorariTable, ['TaxRollYr', 'CertiorariNumber'],
              [CertiorariYear, IntToStr(CertiorariNumber)],
              [CertiorariYear, IntToStr(CertiorariNumber)]);

  Done := False;
  FirstTimeThrough := True;
  CertiorariTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CertiorariTable.Next;

    If CertiorariTable.EOF
      then Done := True;

    If not Done
      then DuplicateCertiorariList.Items.Add(ConvertSwisSBLToDashDot(CertiorariTable.FieldByName('SwisSBLKey').Text));

  until Done;

end;  {FormShow}

{==============================================================}
Procedure TCertiorariDuplicatesDialog.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
  CertiorariTable.Close;
  Action := caFree;
end;

end.
