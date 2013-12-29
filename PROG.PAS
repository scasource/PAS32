unit Prog;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Gauges, SysUtils, Dialogs;

type
  TProgressDialog = class(TForm)
    GroupBox1: TGroupBox;
    Gauge: TGauge;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CurrentlyPrintingLabel: TLabel;
    TimeElapsedLabel: TLabel;
    TimeRemainingLabel: TLabel;
    UserLabel: TLabel;
    CancelButton: TBitBtn;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FCurrentRecordNo : LongInt;
    FConfirmCancel : Boolean;
    FStartTime,
    FLastTimeUpdated : TDateTime;

  public
    UserLabelCaption : String;
    FActive,
    CancelButtonVisible,
    Cancelled : Boolean;
    TotalNumRecords : LongInt;

    { Public declarations }
    Procedure Start(_TotalNumRecords : LongInt;
                    _CancelButtonVisible,
                    _ConfirmCancel : Boolean);
    Procedure Update(Form : TForm;
                     CurrentlyPrintingStr : String);
    Procedure Reset;  {Reset everything back to 0.}
    Procedure StartPrinting(PrintToScreen : Boolean);
    Procedure Finish;

  end;

var
  ProgressDialog: TProgressDialog;

implementation

{$R *.DFM}

{===================================================================}
Function LTrim(Arg : String) : String;
{DS: trim Leading blanks off of a string }

var
  Pos, Lgn :Integer;

begin
  Lgn := Length(Arg);

  Pos := 1;

    {Delete spaces off the front.}

  while ((Pos <= Lgn) and
         (Arg[1] = ' ')) do
    begin
      Delete(Arg, 1, 1);
      Pos := Pos + 1;
    end;

  LTrim := Arg;

end;  {LTrim}

{===========================================}
Function Power10(Places : Byte):Double;
  {DS: Raise 10 to the indicated power (limited to 0,1,2,3,4,or 5) }

Var
  Res : Double;

begin
  Res := 0;
  {ensure argument is in range...}
  If Places > 5 then Places := 5;

  Case Places of
  0: Res := 1.0;
  1: Res := 10.0;
  2: Res := 100.0;
  3: Res := 1000.0;
  4: Res := 10000.0;
  5: Res := 100000.0;
  end; {case}

  Power10 := Res;
end;  { function Power10}

{==================================================================}
Function Roundoff(Number : Extended;
                  NumPlaces : Integer) : Extended;

var
  I, FirstPlaceAfterDecimalPos, Pos,
  DeterminingDigit, DigitInt, ReturnCode : Integer;
  Digit : Real;
  Answer : Extended;
  AnswerStr, NumString : String;
  AddOne : Boolean;
  DigitStr : String;

begin
     {They can only round off up to 5 places.}

  If (NumPlaces > 5)
    then NumPlaces := 5;

  Str(Number:14:6, NumString);
  NumString := LTrim(NumString);

      {Find the decimal point.}

  Pos := 1;
  while ((Pos <= Length(NumString)) and (NumString[Pos] <> '.')) do
    Pos := Pos + 1;

  FirstPlaceAfterDecimalPos := Pos + 1;

    {Now let's look at the place that we need to in order to determine
     whether to round up or round down.}

  DeterminingDigit := FirstPlaceAfterDecimalPos + NumPlaces;
  Val(NumString[DeterminingDigit], DigitInt, ReturnCode);
  (*DigitInt := Trunc(Digit);*)

       {If the determining digit is >= 5, then round up. Otherwise, round
        down.}

  If (DigitInt >= 5)
    then
      begin
        AnswerStr := '';
        AddOne := True;

           {We are rounding up, so first let's add one to the digit to
            the left of the determining digit. If it takes us to ten,
            continue working to the left until we don't roll over a
            digit to ten.}

        For I := (DeterminingDigit - 1) downto 1 do
          begin
            If (NumString[I] = '.')
              then AnswerStr := '.' + AnswerStr
              else
                begin  {The character is a digit.}
                    {FXX05261998-1: Not leaving the negative sign if
                                    this is a negative number.}

                  If (NumString[I] = '-')
                    then AnswerStr := '-' + AnswerStr
                    else
                      begin
                        Val(NumString[I], Digit, ReturnCode);
                        DigitInt := Trunc(Digit);

                        If AddOne
                          then DigitInt := DigitInt + 1;

                        If (DigitInt = 10)
                          then AnswerStr := '0' + AnswerStr
                          else
                            begin
                              AddOne := False;
                              Str(DigitInt:1, DigitStr);
                              AnswerStr := DigitStr + AnswerStr;
                            end;  {else of If (((DigitInt + 1) = 10) and AddOne)}

                      end;  {else of If (NumString[I] = '-')}

                end;  {else of If (NumString[I] = '.')}

          end;  {For I := Pos to 1 do}

        If AddOne
          then AnswerStr := '1' + AnswerStr;

      end  {If (DigitInt >= 5)}
    else AnswerStr := Copy(NumString, 1, (DeterminingDigit - 1));

  Val(AnswerStr, Answer, ReturnCode);
  Roundoff := Answer;

end; { function Roundoff....}

{===========================================================================}
Procedure TProgressDialog.Start(_TotalNumRecords : LongInt;
                                _CancelButtonVisible,
                                _ConfirmCancel : Boolean);

begin
  TotalNumRecords := _TotalNumRecords;
  FConfirmCancel := _ConfirmCancel;
  CancelButtonVisible := _CancelButtonVisible;
  FActive := True;
  Cancelled := False;

  Show;
  BringToFront;
  Gauge.Progress := 0;
  FConfirmCancel := _ConfirmCancel;
  CancelButton.Visible := _CancelButtonVisible;
  UserLabel.Caption := UserLabelCaption;

  CurrentlyPrintingLabel.Caption := '';
  TimeElapsedLabel.Caption := '';
  TimeRemainingLabel.Caption := '';

  FStartTime := Time;
  FLastTimeUpdated := Time;
  FCurrentRecordNo := 0;
  Refresh;
  Application.ProcessMessages;

end;  {Start}

{===========================================================================}
Procedure TProgressDialog.Update(Form : TForm;
                                 CurrentlyPrintingStr : String);

var
  Progress, TimeRemaining, Rate : Real;
  Hour, Min, ThisSec, LastSec, MSec : Word;
  ShowProgress : Boolean;

begin
  ShowProgress := False;

   {Update the progress panel.}

  FCurrentRecordNo := FCurrentRecordNo + 1;

  {FXX10211997-4: Make it so that progress panel does not prevent
                  people from going to other apps - check the
                  application.active.}

  If (Form.Active and
      FActive and
      Application.Active and
      (FCurrentRecordNo <= TotalNumRecords))  {FXX04191998-2: Don't show if alredy done.}
    then
      begin
        ShowProgress := True;
        ProgressDialog.SetFocus;
      end;

  If (ShowProgress and FActive)
    then
      with ProgressDialog do
        begin
          UserLabel.Caption := UserLabelCaption;

          CurrentlyPrintingLabel.Caption := CurrentlyPrintingStr;
          TimeElapsedLabel.Caption := FormatDateTime('n:ss', Time - FStartTime);

          {    BUMP BAR IF CURRE REC LESS THAN TOTAL RECS}
          If ( FCurrentRecordNo  <= TotalNumRecords)
            then
              begin
                If (TotalNumRecords = 0)
                  then Progress := 0
                    {DFXX09151997-1 if only one recorc in file must avoid div by 0 error}
                  else
                      {FXX04191998-1: For every division, include a try
                                      except in case of div by 0.}
                    If ((TotalNumRecords - FCurrentRecordNo) > 0)
                      then
                        try
                          Progress := 100 -
                                      ((TotalNumRecords - FCurrentRecordNo) /
                                       TotalNumRecords * 100)
                        except
                          Progress := 0;
                        end
                      else Progress := 100;

                  {We only want to update the time estimate every second.}

                DecodeTime(Time, Hour, Min, ThisSec, MSec);
                DecodeTime(FLastTimeUpdated, Hour, Min, LastSec, MSec);

                If (ThisSec <> LastSec)
                  then
                    begin
                      FLastTimeUpdated := Time;

                      {FXX04191998-1: For every division, include a try
                                      except in case of div by 0.}

                      If (Roundoff((Time - FStartTime), 4) > 0)
                        then
                          try
                            Rate := FCurrentRecordNo / (Time - FStartTime);  {Number per second}
                          except
                            Rate := 0;
                          end
                        else Rate := 0;

                      If (TotalNumRecords = FCurrentRecordNo)
                        then TimeRemaining := 0
                        else
                          begin
                          {DFXX09151997-1  avoid div by 0 for 1 rec files}
                          {FXX04191998-1: For every division, include a try
                                      except in case of div by 0.}

                            If (((TotalNumRecords - FCurrentRecordNo) > 0) and
                                (Roundoff(Rate, 2) > 0.00))
                              then
                                try
                                  TimeRemaining := (TotalNumRecords - FCurrentRecordNo) *
                                                   (1 / Rate);
                                except
                                  TimeRemaining := 0;
                                end
                              else
                                If (Roundoff(Rate, 2) <> 0.00)
                                  then
                                    try
                                      TimeRemaining := (1 / Rate);
                                    except
                                      TimeRemaining := 0;
                                    end
                                  else TimeRemaining := 0;

                          end;  {else of If (TotalNumRecords = FCurrentRecordNo)}

                      try
                        TimeRemainingLabel.Caption := FormatDateTime('n:ss', TimeRemaining);
                      except
                        TimeRemainingLabel.Caption := '';
                      end;

                    end;  {If (FLastTimeUpdated <> Time)}

                If (Roundoff(Progress, 0) < 0)
                  then Progress := 0;

                Gauge.Progress := Trunc(Progress);

              end;  {If (TotalNumRecords <= FCurrentRecordNo)}

          Application.ProcessMessages;

        end;  {with ProgressDialog do}

end;  {Update}

{===========================================================================}
Procedure TProgressDialog.Reset;

{Reset everything back to 0.}

begin
  Gauge.Progress := 0;
  CancelButton.Visible := CancelButtonVisible;
  UserLabel.Caption := UserLabelCaption;

  CurrentlyPrintingLabel.Caption := '';
  TimeElapsedLabel.Caption := '';
  TimeRemainingLabel.Caption := '';

  FStartTime := Time;
  FLastTimeUpdated := Time;
  FCurrentRecordNo := 0;

  Cancelled := False;

end;  {Reset}

{==============================================================}
Procedure TProgressDialog.CancelButtonClick(Sender: TObject);

begin
  If FConfirmCancel
    then Cancelled := (MessageDlg('Are you sure you want to cancel?', mtConfirmation,
                                  [mbYes, mbNo], 0) = idYes)
    else Cancelled := True;

end;  {CancelButtonClick}

{==============================================================}
Procedure TProgressDialog.StartPrinting(PrintToScreen : Boolean);

begin
  Gauge.Progress := 100;
  TimeRemainingLabel.Caption := 'Done';
  CurrentlyPrintingLabel.Caption := '';
  FActive := False;

  If PrintToScreen
    then UserLabel.Caption := 'Please wait while the report is printed to the screen.'
    else UserLabel.Caption := 'Please wait while the report is sent to the printer.';

  Visible := False;

end;  {StartPrinting}

{===========================================================================}
Procedure TProgressDialog.Finish;

begin
  UserLabel.Caption := '';
  Close;
end;

{========================================================================}
Procedure TProgressDialog.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
  SendToBack;
  FActive := False;
end;

end.
