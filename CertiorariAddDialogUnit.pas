unit CertiorariAddDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables, ExtCtrls, ComCtrls;

type
  TCertiorariAddDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    LawyerCodeTable: TTable;
    RepresentativeGroupBox: TGroupBox;
    Label2: TLabel;
    LawyerCodeLookupCombo: TwwDBLookupCombo;
    Label1: TLabel;
    IndexNumberGroupBox: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    CertiorariTable: TTable;
    EditCertiorariNumber: TEdit;
    CheckForGrievanceTimer: TTimer;
    GrievanceTable: TTable;
    ProgressBar: TProgressBar;
    SwisCodeTable: TTable;
    HistorySwisCodeTable: TTable;
    PriorAssessmentTable: TTable;
    CurrentAssessmentTable: TTable;
    PriorSwisCodeTable: TTable;
    ParcelTable: TTable;
    CertiorariExemptionsAskedTable: TTable;
    CertiorariExemptionsTable: TTable;
    CurrentSalesTable: TTable;
    CurrentExemptionsTable: TTable;
    CertiorariSpecialDistrictsTable: TTable;
    CurrentSpecialDistrictsTable: TTable;
    CertiorariSalesTable: TTable;
    GrievanceExemptionsAskedTable: TTable;
    GrievanceYearGroupBox: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    EditCertiorariYear: TEdit;
    GrievanceDispositionCodeTable: TTable;
    GrievanceResultsTable: TTable;
    NewLawyerButton: TBitBtn;
    procedure OKButtonClick(Sender: TObject);
    procedure LawyerCodeLookupComboNotInList(Sender: TObject;
      LookupTable: TDataSet; NewValue: String; var Accept: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckForGrievanceTimerTimer(Sender: TObject);
    procedure NewLawyerButtonClick(Sender: TObject);
    procedure EditCertiorariYearExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    LawyerCode : String;
    CertiorariYear,
    PriorYear, SwisSBLKey : String;
    GrievanceNumber,
    CertiorariCopyType,
    TotalParcelsWithThisGrievance,
    CertiorariNumber : LongInt;
    AlreadyCopied : Boolean;
    CertiorariProcessingType,
    PriorProcessingType : Integer;

    Function OpenTables(CertiorariProcessingType : Integer;
                        PriorProcessingType : Integer) : Boolean;
  end;

var
  CertiorariAddDialog: TCertiorariAddDialog;

implementation

{$R *.DFM}

uses Cert_Or_SmallClaimsDuplicatesDialogUnit, GrievanceUtilitys, WinUtils,
     PASUtils, PASTypes, GlblCnst, GlblVars, Utilitys, NewLawyerDialog,
     DataAccessUnit;

{===============================================================}
Procedure TCertiorariAddDialog.CheckForGrievanceTimerTimer(Sender: TObject);

begin
  CheckForGrievanceTimer.Enabled := False;
  CertiorariCopyType := ctNone;

  GrievanceTable.IndexName := 'BYSWISSBLKEY_TAXROLLYR_GREVNUM';
  SetRangeOld(GrievanceTable, ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber'],
              [SwisSBLKey, CertiorariYear, '0'],
              [SwisSBLKey, CertiorariYear, '9999']);
  GrievanceNumber := GrievanceTable.FieldByName('GrievanceNumber').AsInteger;

  If (GrievanceTable.RecordCount > 0)
    then
      If (GrievanceTable.RecordCount > 1)
        then MessageDlg('The grievance information can not be copied to the certiorari system because' + #13 +
                        'there is more than 1 grievance entered for this assessment year.' + #13 +
                        'Please enter the certiorari information by hand.', mtWarning, [mbOK], 0)
        else
          begin
              {Check to see if this grievance number is on more than 1 parcel.}

            GrievanceTable.IndexName := 'BYTAXROLLYR_GREVNUM';

            SetRangeOld(GrievanceTable, ['TaxRollYr', 'GrievanceNumber'],
                        [CertiorariYear, IntToStr(GrievanceNumber)],
                        [CertiorariYear, IntToStr(GrievanceNumber)]);

            If (GrievanceTable.RecordCount = 1)
              then
                begin
                  If (MessageDlg('Do you want to copy the grievance information already entered for this parcel ' +
                                 'to this new certiorari?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
                    then CertiorariCopyType := ctThisParcel;

                end
              else
                If (MessageDlg('The grievance that is already on this parcel is also on ' +
                               IntToStr(GrievanceTable.RecordCount - 1) + ' other parcels.' + #13 +
                               'Do you want to create certioraris on all parcels with this grievance number?',
                               mtConfirmation, [mbYes, mbNo], 0) = idYes)
                  then
                    begin
                      CertiorariCopyType := ctAllParcels;
                      TotalParcelsWithThisGrievance := GrievanceTable.RecordCount;
                    end
                  else
                    If (MessageDlg('Do you want to copy the grievance information already entered for this parcel ' +
                                   'to this new certiorari?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
                      then CertiorariCopyType := ctThisParcel;

              {FXX10252009-1(2.20.1.23)[I6595]: Reaccess the grievance with the grievance # and the SBL.}

            GrievanceTable.IndexName := 'BYSWISSBLKEY_TAXROLLYR_GREVNUM';
            SetRangeOld(GrievanceTable, ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber'],
                        [SwisSBLKey, CertiorariYear, '0'],
                        [SwisSBLKey, CertiorariYear, '9999']);

          end;  {else of If (GrievanceTable.RecordCount > 1)}

  If (CertiorariCopyType <> ctNone)
    then
      begin
        If (CertiorariCopyType = ctAllParcels)
          then GrievanceTable.First;

        LawyerCodeLookupCombo.Text := GrievanceTable.FieldByName('LawyerCode').Text;

      end;  {If (CertiorariCopyType <> ctNone)}

end;  {CheckForGrievanceTimerTimer}

{===============================================================}
Function TCertiorariAddDialog.OpenTables(CertiorariProcessingType : Integer;
                                         PriorProcessingType : Integer) : Boolean;

begin
  Result := False;

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             CertiorariProcessingType, Result);

  OpenTableForProcessingType(CurrentAssessmentTable, AssessmentTableName,
                             CertiorariProcessingType, Result);

  OpenTableForProcessingType(PriorSwisCodeTable, SwisCodeTableName,
                             PriorProcessingType, Result);

  OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                             PriorProcessingType, Result);

  OpenTableForProcessingType(CurrentExemptionsTable, ExemptionsTableName,
                             CertiorariProcessingType, Result);

  OpenTableForProcessingType(CurrentSpecialDistrictsTable, SpecialDistrictTableName,
                             CertiorariProcessingType, Result);

end;  {OpenTables}

{===============================================================}
Procedure TCertiorariAddDialog.FormShow(Sender: TObject);

begin
  AlreadyCopied := False;
  EditCertiorariYear.Text := CertiorariYear;

  OpenTablesForForm(Self, CertiorariProcessingType);

    {First let's find this parcel in the parcel table.}

  _Locate(ParcelTable, [CertiorariYear, SwisSBLKey], '', [loParseSwisSBLKey]);

  OpenTables(CertiorariProcessingType, PriorProcessingType);

  CheckForGrievanceTimer.Enabled := True;

end;  {FormShow}

{====================================================================}
Procedure TCertiorariAddDialog.FormKeyPress(    Sender: TObject;
                                            var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{===============================================================}
Procedure TCertiorariAddDialog.EditCertiorariYearExit(Sender: TObject);

{CHG10262005-1(2.9.3.8): If they change to a different cert year, check for
                         a grievance for that year.}

begin
  If (_Compare(CertiorariYear, EditCertiorariYear.Text, coNotEqual) and
      _Compare(CertiorariCopyType, ctNone, coEqual))
    then
      begin
        CertiorariYear := EditCertiorariYear.Text;
        CheckForGrievanceTimer.Enabled := True;
      end;

end;  {EditCertiorariYearExit}

{===============================================================}
Procedure TCertiorariAddDialog.OKButtonClick(Sender: TObject);

var
  FirstTimeThrough, Done, Continue : Boolean;
  NumParcelsCopiedTo : Integer;
  ThisSwisSBLKey : String;

begin
  Continue := True;
  LawyerCode := LawyerCodeLookupCombo.Text;
  CertiorariYear := EditCertiorariYear.Text;

    {FXX10252009-2(2.20.1.23): Make sure to adjust the prior year.}

  PriorYear := IntToStr(StrToInt(CertiorariYear) - 1);

  try
    CertiorariNumber := StrToInt(EditCertiorariNumber.Text);
  except
    Continue := False;
    MessageDlg('Sorry, ' + EditCertiorariNumber.Text + ' is not a valid Certiorari number.' + #13 +
               'Please correct it.', mtError, [mbOK], 0);
    EditCertiorariNumber.SetFocus;
  end;

    {See if there are other parcels already with this Certiorari number.
     If so, warn them, but let them continue.}

  If Continue
    then
      begin
        SetRangeOld(CertiorariTable, ['TaxRollYr', 'CertiorariNumber'],
                    [CertiorariYear, IntToStr(CertiorariNumber)],
                    [CertiorariYear, IntToSTr(CertiorariNumber)]);

        CertiorariTable.First;

        If not CertiorariTable.EOF
          then
            try
              Cert_Or_SmallClaimsDuplicatesDialog := TCert_Or_SmallClaimsDuplicatesDialog.Create(nil);
              Cert_Or_SmallClaimsDuplicatesDialog.IndexNumber := CertiorariNumber;
              Cert_Or_SmallClaimsDuplicatesDialog.CurrentYear := CertiorariYear;
              Cert_Or_SmallClaimsDuplicatesDialog.AskForConfirmation := True;
              Cert_Or_SmallClaimsDuplicatesDialog.Source := 'C';

              If (Cert_Or_SmallClaimsDuplicatesDialog.ShowModal = idNo)
                then Continue := False;

            finally
              Cert_Or_SmallClaimsDuplicatesDialog.Free;
            end;

      end;  {If Continue}

  If Continue
    then
      begin
          {FXX10252009-3(2.20.1.23)[D1562]: Need to set the processing types based on the
                                            year entered.}
                                            
        CertiorariProcessingType := GetProcessingTypeForTaxRollYear(CertiorariYear);
        case CertiorariProcessingType of
          NextYear : PriorProcessingType := ThisYear;
          ThisYear : PriorProcessingType := History;
          History : PriorProcessingType := History;
        end;

        OpenTables(CertiorariProcessingType, PriorProcessingType);

        FindKeyOld(LawyerCodeTable, ['Code'], [LawyerCode]);

        case CertiorariCopyType of
          ctThisParcel :
            begin
              AlreadyCopied := True;

              CopyGrievanceToCert_Or_SmallClaim(CertiorariNumber,
                                                GrievanceNumber,
                                                CertiorariYear,
                                                PriorYear,
                                                SwisSBLKey,
                                                LawyerCode, 1,
                                                GrievanceTable,
                                                CertiorariTable,
                                                LawyerCodeTable,
                                                ParcelTable,
                                                CurrentAssessmentTable,
                                                PriorAssessmentTable,
                                                SwisCodeTable,
                                                PriorSwisCodeTable,
                                                CurrentExemptionsTable,
                                                CertiorariExemptionsTable,
                                                CurrentSpecialDistrictsTable,
                                                CertiorariSpecialDistrictsTable,
                                                CurrentSalesTable,
                                                CertiorariSalesTable,
                                                GrievanceExemptionsAskedTable,
                                                CertiorariExemptionsAskedTable,
                                                GrievanceResultsTable,
                                                GrievanceDispositionCodeTable, 'C');

            end;  {ctThisParcel}

          ctAllParcels :
            begin
              AlreadyCopied := True;
              NumParcelsCopiedTo := 0;
              ProgressBar.Visible := True;
              ProgressBar.Max := TotalParcelsWithThisGrievance;
              GrievanceTable.IndexName := 'BYTAXROLLYR_GREVNUM';

              FirstTimeThrough := True;
              Done := False;

              SetRangeOld(GrievanceTable, ['TaxRollYr', 'GrievanceNumber'],
                          [CertiorariYear, IntToStr(GrievanceNumber)],
                          [CertiorariYear, IntToStr(GrievanceNumber)]);

              GrievanceTable.First;

              repeat
                If FirstTimeThrough
                  then FirstTimeThrough := False
                  else GrievanceTable.Next;

                If GrievanceTable.EOF
                  then Done := True;

                If not Done
                  then
                    begin
                      NumParcelsCopiedTo := NumParcelsCopiedTo + 1;
                      ProgressBar.Position := NumParcelsCopiedTo;
                      Application.ProcessMessages;

                      ThisSwisSBLKey := GrievanceTable.FieldByName('SwisSBLKey').Text;

                      CopyGrievanceToCert_Or_SmallClaim(CertiorariNumber,
                                                        GrievanceNumber,
                                                        CertiorariYear,
                                                        PriorYear,
                                                        ThisSwisSBLKey,
                                                        LawyerCode,
                                                        TotalParcelsWithThisGrievance,
                                                        GrievanceTable,
                                                        CertiorariTable,
                                                        LawyerCodeTable,
                                                        ParcelTable,
                                                        CurrentAssessmentTable,
                                                        PriorAssessmentTable,
                                                        SwisCodeTable,
                                                        PriorSwisCodeTable,
                                                        CurrentExemptionsTable,
                                                        CertiorariExemptionsTable,
                                                        CurrentSpecialDistrictsTable,
                                                        CertiorariSpecialDistrictsTable,
                                                        CurrentSalesTable,
                                                        CertiorariSalesTable,
                                                        GrievanceExemptionsAskedTable,
                                                        CertiorariExemptionsAskedTable,
                                                        GrievanceResultsTable,
                                                        GrievanceDispositionCodeTable, 'C');

                    end;  {If not Done}

              until Done;

              MessageDlg('The certiorari was copied to ' +
                         IntToStr(TotalParcelsWithThisGrievance) +
                         ' parcels (including this one).', mtInformation, [mbOK], 0);

            end;  {ctAllParcels}

        end;  {case CertiorariCopyType of}

        ModalResult := mrOK;

      end;  {If Continue}

end;  {OKButtonClick}

{===============================================================}
Procedure TCertiorariAddDialog.NewLawyerButtonClick(Sender: TObject);

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
Procedure TCertiorariAddDialog.LawyerCodeLookupComboNotInList(    Sender: TObject;
                                                                        LookupTable: TDataSet;
                                                                        NewValue: String;
                                                                    var Accept: Boolean);

begin
  If (NewValue = '')
    then Accept := True;

end;  {LawyerCodeLookupComboNotInList}

{======================================================}
Procedure TCertiorariAddDialog.FormClose(    Sender: TObject;
                                        var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  Action := caFree;
end;

end.
