unit NewLetterDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, DBCtrls;

type
  TForm1 = class(TForm)
    InsertCodeButton: TBitBtn;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    procedure InsertCodeButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses LetterInsertCodesUnit;

{===========================================================}
Procedure TForm1.InsertCodeButtonClick(Sender: TObject);

{CHG01082004-1(MDT): Add letter inserts.}

begin
  try
    LetterInsertCodesForm := TLetterInsertCodesForm.Create(nil);
    LetterInsertCodesForm.ShowModal;
  finally
    LetterInsertCodesForm.Free;
  end;

end;  {InsertCodeButtonClick}

end.
