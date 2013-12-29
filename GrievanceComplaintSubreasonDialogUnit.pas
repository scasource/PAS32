unit GrievanceComplaintSubreasonDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables, Wwkeycb, Grids, Wwdbigrd,
  Wwdbgrid, ComCtrls, wwriched, wwrichedspell;

type
  TGrievanceComplaintSubreasonDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    GrievanceComplaintSubReasonCodeTable: TTable;
    GrievanceComplaintSubreasonDataSource: TDataSource;
    GrievanceDenialReasonGrid: TwwDBGrid;
    GrievanceCodeIncrementalSearch: TwwIncrementalSearch;
    Label3: TLabel;
    ReasonRichEdit: TwwDBRichEditMSWord;
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Category,
    GrievanceComplaintSubreasonCode : String;
  end;

var
  GrievanceComplaintSubreasonDialog: TGrievanceComplaintSubreasonDialog;

implementation

{$R *.DFM}

uses WinUtils, Utilitys;

{===============================================================}
Procedure TGrievanceComplaintSubreasonDialog.FormShow(Sender: TObject);

begin
  try
    GrievanceComplaintSubReasonCodeTable.Open;
  except
    MessageDlg('Error opening grievance complaint subreason reason code table.',
               mtError, [mbOK], 0);
  end;

  SetRangeOld(GrievanceComplaintSubreasonCodeTable, ['Category', 'Code'],
              [Category, ConstStr(' ', 10)],
              [Category, ConstStr('Z', 10)]);

end;  {FormShow}

{===============================================================}
Procedure TGrievanceComplaintSubreasonDialog.OKButtonClick(Sender: TObject);

begin
  GrievanceComplaintSubreasonCode := GrievanceComplaintSubReasonCodeTable.FieldByName('Code').Text;
  ModalResult := mrOK;
end;

end.
