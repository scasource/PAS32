unit GrievanceDenialReasonDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables, Wwkeycb, Grids, Wwdbigrd,
  Wwdbgrid, ComCtrls, wwriched, wwrichedspell;

type
  TGrievanceDenialReasonDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    GrievanceDenialReasonCodeTable: TTable;
    GrievanceDenialDataSource: TDataSource;
    GrievanceDenialReasonGrid: TwwDBGrid;
    GrievanceCodeIncrementalSearch: TwwIncrementalSearch;
    Label3: TLabel;
    ReasonRichEdit: TwwDBRichEditMSWord;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    GrievanceDenialCode : String;
  end;

var
  GrievanceDenialReasonDialog: TGrievanceDenialReasonDialog;

implementation

{$R *.DFM}

{===============================================================}
Procedure TGrievanceDenialReasonDialog.FormCreate(Sender: TObject);

begin
  try
    GrievanceDenialReasonCodeTable.Open;
  except
    MessageDlg('Error opening grievance denial reason code table.',
               mtError, [mbOK], 0);
  end;

end;  {FormCreate}

{===============================================================}
Procedure TGrievanceDenialReasonDialog.OKButtonClick(Sender: TObject);

begin
  GrievanceDenialCode := GrievanceDenialReasonCodeTable.FieldByName('MainCode').Text;
  ModalResult := mrOK;
end;


end.
