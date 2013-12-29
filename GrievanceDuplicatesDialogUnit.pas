unit GrievanceDuplicatesDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables, ExtCtrls;

type
  TGrievanceDuplicatesDialog = class(TForm)
    YesButton: TBitBtn;
    NoButton: TBitBtn;
    GrievanceTable: TTable;
    DescriptionLabel: TLabel;
    DuplicateGrievanceList: TListBox;
    OKButton: TBitBtn;
    PromptLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    AssessmentYear : String;
    GrievanceNumber : LongInt;
    AskForConfirmation : Boolean;

  end;

var
  GrievanceDuplicatesDialog: TGrievanceDuplicatesDialog;

implementation

{$R *.DFM}

uses PASUtils, WinUtils;

{===============================================================}
Procedure TGrievanceDuplicatesDialog.FormShow(Sender: TObject);

var
  FirstTimeThrough, Done : Boolean;

begin
  Caption := 'Parcels with grievance #' + IntToStr(GrievanceNumber) + '.';
  DescriptionLabel.Caption := 'The following parcels all have grievance #' +
                              IntToStr(GrievanceNumber) + '.';

  try
    GrievanceTable.Open;
  except
    MessageDlg('Error opening grievance table.', mtError, [mbOK], 0);
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

  SetRangeOld(GrievanceTable, ['TaxRollYr', 'GrievanceNumber'],
              [AssessmentYear, IntToStr(GrievanceNumber)],
              [AssessmentYear, IntToStr(GrievanceNumber)]);

  Done := False;
  FirstTimeThrough := True;
  GrievanceTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else GrievanceTable.Next;

    If GrievanceTable.EOF
      then Done := True;

    If not Done
      then DuplicateGrievanceList.Items.Add(ConvertSwisSBLToDashDot(GrievanceTable.FieldByName('SwisSBLKey').Text));

  until Done;

end;  {FormShow}

{==============================================================}
Procedure TGrievanceDuplicatesDialog.FormClose(    Sender: TObject;
                                               var Action: TCloseAction);

begin
  GrievanceTable.Close;
  Action := caFree;
end;

end.
