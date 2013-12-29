unit SeniorPercentCalculationForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBTables;

type
  TSeniorIncomePercentCalculationForm = class(TForm)
    Label1: TLabel;
    IncomeEdit: TEdit;
    Label2: TLabel;
    OKButton: TBitBtn;
    SeniorIncomeLevelsTable: TTable;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    ExemptionPercent : Double;
  end;

var
  SeniorIncomePercentCalculationForm: TSeniorIncomePercentCalculationForm;

implementation

{$R *.DFM}

uses GlblVars, WinUtils;

{========================================================}
Procedure TSeniorIncomePercentCalculationForm.FormShow(Sender: TObject);

begin
  try
    SeniorIncomeLevelsTable.Open;
  except
    SystemSupport(001, SeniorIncomeLevelsTable,
                  'Error opening senior income limits table.',
                  'SeniorPercentCalculationForm', GlblErrorDlgBox);

  end;

end;  {FormShow}

{===============================================}
Procedure TSeniorIncomePercentCalculationForm.OKButtonClick(Sender: TObject);

var
  Income : LongInt;
  FoundPercent, Quit,
  Done, FirstTimeThrough : Boolean;

begin
  Income := 0;
  Quit := False;

  try
    Income := StrToInt(IncomeEdit.Text);
  except
    MessageDlg('Please enter an income.', mtError, [mbOK], 0);
    IncomeEdit.SetFocus;
    Quit := True;
  end;

  If not Quit
    then
      begin
        Done := False;
        FirstTimeThrough := True;
        FoundPercent := False;
        SeniorIncomeLevelsTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SeniorIncomeLevelsTable.Next;

          If SeniorIncomeLevelsTable.EOF
            then Done := True;

          If not Done
            then
              with SeniorIncomeLevelsTable do
                If ((Income >= FieldByName('LowLimit').AsInteger) and
                    (Income <= FieldByName('UpperLimit').AsInteger))
                  then
                    begin
                      ExemptionPercent := FieldByName('Percent').AsFloat;
                      FoundPercent := True;
                    end;

        until Done;

        If FoundPercent
          then ModalResult := mrOK
          else
            begin
              ExemptionPercent := 0;
              MessageDlg('The income amount $' + IncomeEdit.Text +
                         ' is higher than allowed for a senior exemption.' + #13 +
                         'This person is not entitled to a senior exemption.',
                         mtError, [mbOK], 0);
              ModalResult := mrCancel;

            end;  {If not FoundPercent}

      end;  {If not Quit}

end;  {OKButtonClick}

{===================================================================}
Procedure TSeniorIncomePercentCalculationForm.FormKeyPress(    Sender: TObject;
                                                           var Key: Char);

{CHG04272005-1(2.8.4.4): Remove cancel buttons and allow for Esc instead.}

begin
(*  If (Key = vk_Esc)
    then Close; *)

end;  {FormKeyPress}

{===================================================================}
Procedure TSeniorIncomePercentCalculationForm.FormClose(    Sender: TObject;
                                                        var Action: TCloseAction);
begin
  SeniorIncomeLevelsTable.Close;
end;


end.
