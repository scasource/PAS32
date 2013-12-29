unit GrievanceAddDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables, ExtCtrls;

type
  TGrievanceAddDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    LawyerCodeTable: TTable;
    RepresentativeGroupBox: TGroupBox;
    Label2: TLabel;
    LawyerCodeLookupCombo: TwwDBLookupCombo;
    Label1: TLabel;
    GrievanceNumberGroupBox: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    GrievanceTable: TTable;
    EditGrievanceNumber: TEdit;
    GrievanceYearGroupBox: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    EditGrievanceYear: TEdit;
    NewLawyerButton: TBitBtn;
    procedure OKButtonClick(Sender: TObject);
    procedure LawyerCodeLookupComboNotInList(Sender: TObject;
      LookupTable: TDataSet; NewValue: String; var Accept: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NewLawyerButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LawyerCode : String;
    AssessmentYear : String;
    GrievanceNumber : LongInt;
  end;

var
  GrievanceAddDialog: TGrievanceAddDialog;

implementation

{$R *.DFM}

uses GrievanceDuplicatesDialogUnit, WinUtils, NewLawyerDialog;

{===============================================================}
Procedure TGrievanceAddDialog.FormShow(Sender: TObject);

begin
  try
    LawyerCodeTable.Open;
  except
    MessageDlg('Error opening lawyer code table.', mtError, [mbOK], 0);
  end;

  try
    GrievanceTable.Open;
  except
    MessageDlg('Error opening grievance table.', mtError, [mbOK], 0);
  end;

  EditGrievanceNumber.Text := IntToStr(GrievanceNumber);
  EditGrievanceYear.Text := AssessmentYear;

end;  {FormShow}

{===============================================================}
Procedure TGrievanceAddDialog.OKButtonClick(Sender: TObject);

var
  Continue : Boolean;

begin
  Continue := True;
  LawyerCode := LawyerCodeLookupCombo.Text;
  AssessmentYear := EditGrievanceYear.Text;

  try
    GrievanceNumber := StrToInt(EditGrievanceNumber.Text);
  except
    Continue := False;
    MessageDlg('Sorry, ' + EditGrievanceNumber.Text + ' is not a valid grievance number.' + #13 +
               'Please correct it.', mtError, [mbOK], 0);
    EditGrievanceNumber.SetFocus;
  end;

    {See if there are other parcels already with this grievance number.
     If so, warn them, but let them continue.}

  If Continue
    then
      begin
        SetRangeOld(GrievanceTable, ['TaxRollYr', 'GrievanceNumber'],
                    [AssessmentYear, IntToStr(GrievanceNumber)],
                    [AssessmentYear, IntToStr(GrievanceNumber)]);

        GrievanceTable.First;

        If not GrievanceTable.EOF
          then
            try
              GrievanceDuplicatesDialog := TGrievanceDuplicatesDialog.Create(nil);
              GrievanceDuplicatesDialog.GrievanceNumber := GrievanceNumber;
              GrievanceDuplicatesDialog.AssessmentYear := AssessmentYear;
              GrievanceDuplicatesDialog.AskForConfirmation := True;

              If (GrievanceDuplicatesDialog.ShowModal = idNo)
                then Continue := False;

            finally
              GrievanceDuplicatesDialog.Free;
            end;

      end;  {If Continue}

  If Continue
    then ModalResult := mrOK;

end;  {OKButtonClick}

{===============================================================}
Procedure TGrievanceAddDialog.NewLawyerButtonClick(Sender: TObject);

{CHG01262004-1(2.07l1): Let them create a new representative right from the add screen.}

begin
  try
    NewLawyerForm := TNewLawyerForm.Create(nil);
    NewLawyerForm.InitializeForm;

    If (NewLawyerForm.ShowModal = idOK)
      then
        begin
          LawyerCodeLookupCombo.Text := NewLawyerForm.LawyerSelected;
          FindKeyOld(LawyerCodeTable, ['Code'], [NewLawyerForm.LawyerSelected]);
        end;

  finally
    NewLawyerForm.Free;
  end;

end;  {NewLawyerButtonClick}

{===============================================================}
Procedure TGrievanceAddDialog.LawyerCodeLookupComboNotInList(    Sender: TObject;
                                                                        LookupTable: TDataSet;
                                                                        NewValue: String;
                                                                    var Accept: Boolean);

begin
  If (NewValue = '')
    then Accept := True;

end;  {LawyerCodeLookupComboNotInList}

{======================================================}
Procedure TGrievanceAddDialog.FormClose(    Sender: TObject;
                                        var Action: TCloseAction);

begin
  GrievanceTable.Close;
  Action := caFree;
end;


end.
