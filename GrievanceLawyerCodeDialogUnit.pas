unit GrievanceLawyerCodeDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables;

type
  TGrievanceLawyerCodeDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    LawyerCodeTable: TTable;
    LawyerCodeLookupCombo: TwwDBLookupCombo;
    procedure OKButtonClick(Sender: TObject);
    procedure LawyerCodeLookupComboNotInList(Sender: TObject;
      LookupTable: TDataSet; NewValue: String; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LawyerCode : String;
  end;

var
  GrievanceLawyerCodeDialog: TGrievanceLawyerCodeDialog;

implementation

{$R *.DFM}

{===============================================================}
Procedure TGrievanceLawyerCodeDialog.FormCreate(Sender: TObject);

begin
  try
    LawyerCodeTable.Open;
  except
    MessageDlg('Error opening lawyer code table.', mtError, [mbOK], 0);
  end;

end;  {FormCreate}

{===============================================================}
Procedure TGrievanceLawyerCodeDialog.OKButtonClick(Sender: TObject);

begin
  LawyerCode := LawyerCodeLookupCombo.Text;
end;

{===============================================================}
Procedure TGrievanceLawyerCodeDialog.LawyerCodeLookupComboNotInList(    Sender: TObject;
                                                                        LookupTable: TDataSet;
                                                                        NewValue: String;
                                                                    var Accept: Boolean);

begin
  If (NewValue = '')
    then Accept := True;

end;  {LawyerCodeLookupComboNotInList}


end.
