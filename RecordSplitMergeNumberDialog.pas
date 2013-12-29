unit RecordSplitMergeNumberDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBTables;

type
  TRecordSplitMergeNumberDialogForm = class(TForm)
    Label1: TLabel;
    SplitMergeNumberEdit: TEdit;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SplitMergeNumber : String;
  end;

var
  RecordSplitMergeNumberDialogForm: TRecordSplitMergeNumberDialogForm;

implementation

{$R *.DFM}

uses GlblVars, WinUtils;

{===============================================}
Procedure TRecordSplitMergeNumberDialogForm.OKButtonClick(Sender: TObject);

begin
  SplitMergeNumber := SplitMergeNumberEdit.Text;

  If (SplitMergeNumber = '')
    then
      begin
        MessageDlg('Please enter a split\merge number.', mtError,
                   [mbOK], 0);
        SplitMergeNumberEdit.SetFocus;
      end
    else ModalResult := idOK;

end;  {OKButtonClick}

end.
