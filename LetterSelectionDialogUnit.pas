unit LetterSelectionDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, DBCtrls, jpeg, ExtCtrls, ComCtrls;

type
  TLetterSelectionDialogForm = class(TForm)
    InsertCodeButton: TBitBtn;
    LetterListView: TListView;
    Label1: TLabel;
    Label2: TLabel;
    AddImage: TImage;
    Label3: TLabel;
    Image1: TImage;
    procedure InsertCodeButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LetterSelectionDialogForm: TLetterSelectionDialogForm;

implementation

{$R *.DFM}

uses LetterInsertCodesUnit;

{===========================================================}
Procedure TLetterSelectionDialogForm.InsertCodeButtonClick(Sender: TObject);

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
