unit Warnbox;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, DB, DBTables, Wwtable, Wwdatsrc, Grids, Wwdbigrd,
  Wwdbgrid, Sysutils, Types;

type
  TWarningMessageDialog = class(TForm)
    OKBtn: TBitBtn;
    CaptionLabel1: TLabel;
    Panel1: TPanel;
    WarningsStringGrid: TStringGrid;
    CancelButton: TBitBtn;
    Label2: TLabel;
    CaptionLabel2: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    Cancelled : Boolean;
    Procedure DisplayWarnings(AssessmentYear : String;
                              SwisSBLKey : String;
                              WarningCodeList,
                              WarningDescList : TStringList);

  end;

var
  WarningMessageDialog: TWarningMessageDialog;

implementation

uses Utilitys, PASUTILS, UTILEXSD,  GlblCnst, Glblvars, WinUtils;

{$R *.DFM}

{================================================================}
Procedure TWarningMessageDialog.FormShow(Sender: TObject);

begin
  UnitName := 'WARNBOX';

end;  {FormShow}

{================================================================}
Procedure TWarningMessageDialog.DisplayWarnings(AssessmentYear : String;
                                                SwisSBLKey : String;
                                                WarningCodeList,
                                                WarningDescList : TStringList);

var
  I : Integer;

begin
  Cancelled := False;
  ClearStringGrid(WarningsStringGrid);

  WarningMessageDialog.Caption := 'Warning messages for ' + ConvertSwisSBLToDashDot(SwisSBLKey);
  CaptionLabel1.Caption := 'The following warning messages were received for parcel ' +
                           ConvertSwisSBLToDashDot(SwisSBLKey);
  CaptionLabel2.Caption := 'for assessment year ' + AssessmentYear + ':';

  with WarningsStringGrid do
    begin
      Cells[0, 0] := '  #';
      Cells[1, 0] := 'Description';
    end;

  For I := 0 to (WarningCodeList.Count - 1) do
    with WarningsStringGrid do
      begin
        Cells[0, (I + 1)] := WarningCodeList[I];
        Cells[1, (I + 1)] := WarningDescList[I];
      end;

end;  {DisplayWarnings}

{================================================================}
Procedure TWarningMessageDialog.OKBtnClick(Sender: TObject);

begin
  Close;
end;

{===================================================}
Procedure TWarningMessageDialog.CancelButtonClick(Sender: TObject);

begin
  Cancelled := True;
  Close;
end;

end.
