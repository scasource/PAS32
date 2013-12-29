unit MapRangeSelectDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, PASTypes, Mask;

type
  TMapRangeSelectDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    ColorDialog: TColorDialog;
    Panel1: TPanel;
    StartValueLabel: TLabel;
    EndValueLabel: TLabel;
    StartColorShape: TShape;
    IncrementsLabel: TLabel;
    Label4: TLabel;
    EndColorShape: TShape;
    Label5: TLabel;
    ValueRangeHeaderLabel: TLabel;
    ValueRangeHeaderLabel2: TLabel;
    StartValueEdit: TEdit;
    EndValueEdit: TEdit;
    LevelsEdit: TEdit;
    StartColorButton: TButton;
    EndColorButton: TButton;
    StartYearLabel: TLabel;
    EndYearLabel: TLabel;
    CodeRangeHeaderLabel: TLabel;
    StartYearEdit: TMaskEdit;
    EndYearEdit: TMaskEdit;
    MapSizeRadioGroup: TRadioGroup;
    DisplayLabelsCheckBox: TCheckBox;
    Label1: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure SetColorButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RangeType : Integer;
    StartYear, EndYear : String;
    MapRangeRec : MapRangeRecord;
    StartDate, EndDate : TDateTime;
    SelectedCodesList : TStringList;

    Procedure InitializeForm(MapRangeRec : MapRangeRecord;
                             FillInCurrentValues : Boolean;
                             _SelectedCodesList : TStringList);

  end;

var
  MapRangeSelectDialog: TMapRangeSelectDialog;

implementation

uses Utilitys, GlblCnst, MapRangeCodeSelectDialogUnit;

{$R *.DFM}

{================================================================}
Procedure TMapRangeSelectDialog.InitializeForm(MapRangeRec : MapRangeRecord;
                                               FillInCurrentValues : Boolean;
                                               _SelectedCodesList : TStringList);

begin
  SelectedCodesList := _SelectedCodesList;

  case RangeType of
    rtAssessmentChange :
      begin
        StartYearEdit.Visible := True;
        StartYearLabel.Visible := True;
        EndYearEdit.Visible := True;
        EndYearLabel.Visible := True;
      end;

    rtSalesPrice :
      begin
        StartYearEdit.Visible := True;
        StartYearLabel.Visible := True;
        StartYearLabel.Caption := 'Start Date';
        StartYearEdit.EditMask := DateMask;
        StartYearEdit.Text := DateToStr(MoveDateTimeBackwards(Date, 2, 0, 0));

        EndYearEdit.Visible := True;
        EndYearLabel.Visible := True;
        EndYearLabel.Caption := 'End Date';
        EndYearEdit.EditMask := DateMask;
        EndYearEdit.Text := DateToStr(Date);

      end;  {rtSalesPrice}

    rtZoningCodes,
    rtNeighborhoodCodes,
    rtPropertyClass :
      begin
        ValueRangeHeaderLabel.Visible := False;
        ValueRangeHeaderLabel2.Visible := False;
        CodeRangeHeaderLabel.Visible := True;
        StartValueEdit.Visible := False;
        EndValueEdit.Visible := False;
        LevelsEdit.Visible := False;
        StartValueLabel.Visible := False;
        EndValueLabel.Visible := False;
        IncrementsLabel.Visible := False;
        Label1.Visible := False;

      end;  {rtZoningCodes,...}

  end;  {case RangeType of}

    {Fill in the values from last time.}

  If FillInCurrentValues
    then
      with MapRangeRec do
        begin
          StartValueEdit.Text := FloatToStr(StartValue);
          EndValueEdit.Text := FloatToStr(EndValue);
          LevelsEdit.Text := IntToStr(NumberOfIncrements);
          StartColorShape.Brush.Color := StartColor;
          EndColorShape.Brush.Color := EndColor;

          If (Deblank(StartYear) <> '')
            then
              begin
                StartYearEdit.Text := StartYear;
                EndYearEdit.Text := EndYear;
              end;

          try
            If (EndDate > StrToDate('1/1/1910'))
              then
                begin
                  StartYearEdit.Text := DateToStr(StartDate);
                  EndYearEdit.Text := DateToStr(EndDate);
                end;
          except
          end;

          If UseFullMapExtent
            then MapSizeRadioGroup.ItemIndex := 1
            else MapSizeRadioGroup.ItemIndex := 0;

          DisplayLabelsCheckBox.Checked := UseFullMapExtent;

        end;  {If (FillInCurrentValue and ...}

end;  {InitializeForm}

{================================================================}
Procedure TMapRangeSelectDialog.SetColorButtonClick(Sender: TObject);

begin
  If ColorDialog.Execute
    then
      If (Pos('Start', TButton(Sender).Name) > 0)
        then
          begin
            StartColorShape.Brush.Color := ColorDialog.Color;
            StartColorShape.Refresh;
          end
        else
          begin
            EndColorShape.Brush.Color := ColorDialog.Color;
            EndColorShape.Refresh;
          end;

end;  {SetColorButtonClick}

{================================================================}
Procedure TMapRangeSelectDialog.OKButtonClick(Sender: TObject);

var
  Continue : Boolean;
  _EndValue, _StartValue : Double;
  _Increments : Integer;
  MapRangeCodeSelectDialog: TMapRangeCodeSelectDialog;

begin
  try
    _StartValue := StrToFloat(StartValueEdit.Text);
  except
    _StartValue := 0;
  end;

  try
    _EndValue := StrToFloat(EndValueEdit.Text);
  except
    _EndValue := 0;
  end;

  try
    _Increments := StrToInt(LevelsEdit.Text);
  except
    _Increments := 0;
  end;

  Continue := True;

  If not (RangeType in [rtZoningCodes, rtNeighborhoodCodes, rtPropertyClass])
    then
      begin
        If (_StartValue >= _EndValue)
          then
            begin
              StartValueEdit.SetFocus;
              Continue := False;
              MessageDlg('The starting value must be less than the ending value.',
                         mtError, [mbOK], 0);

            end;  {If (StartValue >= EndValue)}

        If (Continue and
            (Roundoff(_Increments, 2) = 0))
          then
            begin
              LevelsEdit.SetFocus;
              Continue := False;
              MessageDlg('Please enter the number of value breaks you want (levels).', mtError, [mbOK], 0);
            end;

      end;  {If not (RangeType in [rtZoningCodes, rtNeighborhoodCodes])}

  If (Continue and
      (RangeType = rtAssessmentChange) and
      (Deblank(StartYearEdit.Text) = ''))
    then
      begin
        StartYearEdit.SetFocus;
        Continue := False;
        MessageDlg('Please enter the first year to compare for the assessment percent change.',
                   mtError, [mbOK], 0);
      end;

  If (Continue and
      (RangeType = rtAssessmentChange) and
      (Deblank(EndYearEdit.Text) = ''))
    then
      begin
        EndYearEdit.SetFocus;
        Continue := False;
        MessageDlg('Please enter the second year to compare for the assessment percent change.',
                   mtError, [mbOK], 0);
      end;

  If Continue
    then
      with MapRangeRec do
        begin
          StartValue := _StartValue;
          EndValue := _EndValue;
          NumberOfIncrements := _Increments;
          StartColor := StartColorShape.Brush.Color;
          EndColor := EndColorShape.Brush.Color;
          DisplayLabels := DisplayLabelsCheckBox.Checked;

          case RangeType of
            rtAssessmentChange :
              begin
                StartYear := StartYearEdit.Text;
                EndYear := EndYearEdit.Text;
              end;

            rtSalesPrice :
              begin
                try
                  StartDate := StrToDate(StartYearEdit.Text);
                except
                end;

                try
                  EndDate := StrToDate(EndYearEdit.Text);
                except
                end;

              end;  {rtSalesPrice}

          end;  {case RangeType of}

          UseFullMapExtent := (MapSizeRadioGroup.ItemIndex = 1);
          Continue := True;

          If (RangeType in [rtZoningCodes,
                            rtNeighborhoodCodes,
                            rtPropertyClass])
            then
              try
                MapRangeCodeSelectDialog := TMapRangeCodeSelectDialog.Create(nil);
                MapRangeCodeSelectDialog.InitializeForm(RangeType, SelectedCodesList);

                If (MapRangeCodeSelectDialog.ShowModal = idOK)
                  then SelectedCodesList := MapRangeCodeSelectDialog.SelectedCodesList
                  else Continue := False;

              finally
                MapRangeCodeSelectDialog.Free;
              end;

          If Continue
            then ModalResult := mrOK;

        end;  {with RangeRec do}

end;  {OKButtonClick}

{==================================================================}
Procedure TMapRangeSelectDialog.CancelButtonClick(Sender: TObject);

begin
  ModalResult := mrCancel;
end;


end.
