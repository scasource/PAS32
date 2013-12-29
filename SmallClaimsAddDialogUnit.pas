unit SmallClaimsAddDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables, ExtCtrls, ComCtrls;

type
  TSmallClaimsAddDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    LawyerCodeTable: TTable;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    LawyerCodeLookupCombo: TwwDBLookupCombo;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    SmallClaimsTable: TTable;
    EditIndexNumber: TEdit;
    CheckForGrievanceTimer: TTimer;
    GrievanceTable: TTable;
    ProgressBar: TProgressBar;
    SwisCodeTable: TTable;
    HistorySwisCodeTable: TTable;
    PriorAssessmentTable: TTable;
    CurrentAssessmentTable: TTable;
    PriorSwisCodeTable: TTable;
    ParcelTable: TTable;
    SmallClaimsExemptionsAskedTable: TTable;
    SmallClaimsExemptionsTable: TTable;
    CurrentSalesTable: TTable;
    CurrentExemptionsTable: TTable;
    SmallClaimsSpecialDistrictsTable: TTable;
    CurrentSpecialDistrictsTable: TTable;
    SmallClaimsSalesTable: TTable;
    GrievanceExemptionsAskedTable: TTable;
    GrievanceYearGroupBox: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    EditSmallClaimsYear: TEdit;
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
    procedure EditSmallClaimsYearExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LawyerCode : String;
    SmallClaimsYear,
    PriorYear, SwisSBLKey : String;
    GrievanceNumber,
    SmallClaimsCopyType,
    TotalParcelsWithThisGrievance,
    IndexNumber : LongInt;
    AlreadyCopied : Boolean;
    SmallClaimsProcessingType,
    PriorProcessingType : Integer;

    Function OpenTables(SmallClaimsProcessingType : Integer;
                        PriorProcessingType : Integer) : Boolean;

  end;

var
  SmallClaimsAddDialog: TSmallClaimsAddDialog;

implementation

{$R *.DFM}

uses Cert_Or_SmallClaimsDuplicatesDialogUnit, GrievanceUtilitys, WinUtils,
     PASUtils, PASTypes, GlblCnst, GlblVars, Utilitys, NewLawyerDialog;

const
  ctNone = 0;
  ctThisParcel = 1;
  ctAllParcels = 2;

{===============================================================}
Procedure TSmallClaimsAddDialog.CheckForGrievanceTimerTimer(Sender: TObject);

var
  iGrievanceNumber : Integer;

begin
  CheckForGrievanceTimer.Enabled := False;
  SmallClaimsCopyType := ctNone;
  GrievanceTable.IndexName := 'BYSWISSBLKEY_TAXROLLYR_GREVNUM';
  SetRangeOld(GrievanceTable, ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber'],
              [SwisSBLKey, SmallClaimsYear, '0'],
              [SwisSBLKey, SmallClaimsYear, '9999']);

  If (GrievanceTable.RecordCount > 0)
    then
      If (GrievanceTable.RecordCount > 1)
        then MessageDlg('The grievance information can not be copied to the small claims system because' + #13 +
                        'there is more than 1 grievance entered for this assessment year.' + #13 +
                        'Please enter the small claims information by hand.', mtWarning, [mbOK], 0)
        else
          begin
              {Check to see if this grievance number is on more than 1 parcel.}

            iGrievanceNumber := GrievanceTable.FieldByName('GrievanceNumber').AsInteger;
            GrievanceTable.IndexName := 'BYTAXROLLYR_GREVNUM';

            SetRangeOld(GrievanceTable, ['TaxRollYr', 'GrievanceNumber'],
                        [SmallClaimsYear, IntToStr(iGrievanceNumber)],
                        [SmallClaimsYear, IntToStr(iGrievanceNumber)]);

            If (GrievanceTable.RecordCount = 1)
              then
                begin
                  If (MessageDlg('Do you want to copy the grievance information already entered for this parcel ' +
                                 'to this new small claims?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
                    then SmallClaimsCopyType := ctThisParcel;

                end
              else
                If (MessageDlg('The grievance that is already on this parcel is also on ' +
                               IntToStr(GrievanceTable.RecordCount - 1) + ' other parcels.' + #13 +
                               'Do you want to create small claims on all parcels with this grievance number?',
                               mtConfirmation, [mbYes, mbNo], 0) = idYes)
                  then
                    begin
                      SmallClaimsCopyType := ctAllParcels;
                      TotalParcelsWithThisGrievance := GrievanceTable.RecordCount;
                    end
                  else
                    If (MessageDlg('Do you want to copy the grievance information already entered for this parcel ' +
                                   'to this new small claims?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
                      then SmallClaimsCopyType := ctThisParcel;

              {FXX10142009-2(2.20.1.20)[I6595]: Reaccess the grievance with the grievance # and the SBL.}

            GrievanceTable.IndexName := 'BYSWISSBLKEY_TAXROLLYR_GREVNUM';
            SetRangeOld(GrievanceTable, ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber'],
                        [SwisSBLKey, SmallClaimsYear, '0'],
                        [SwisSBLKey, SmallClaimsYear, '9999']);

          end;  {else of If (GrievanceTable.RecordCount > 1)}

  If (SmallClaimsCopyType <> ctNone)
    then
      begin
        If (SmallClaimsCopyType = ctAllParcels)
          then GrievanceTable.First;

        LawyerCodeLookupCombo.Text := GrievanceTable.FieldByName('LawyerCode').Text;

      end;  {If (SmallClaimsCopyType <> ctNone)}

end;  {CheckForGrievanceTimerTimer}

{===============================================================}
Function TSmallClaimsAddDialog.OpenTables(SmallClaimsProcessingType : Integer;
                                          PriorProcessingType : Integer) : Boolean;

begin
  Result := False;

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             SmallClaimsProcessingType, Result);

  OpenTableForProcessingType(CurrentAssessmentTable, AssessmentTableName,
                             SmallClaimsProcessingType, Result);

  OpenTableForProcessingType(PriorSwisCodeTable, SwisCodeTableName,
                             PriorProcessingType, Result);

  OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                             PriorProcessingType, Result);

  OpenTableForProcessingType(CurrentExemptionsTable, ExemptionsTableName,
                             SmallClaimsProcessingType, Result);

  OpenTableForProcessingType(CurrentSpecialDistrictsTable, SpecialDistrictTableName,
                             SmallClaimsProcessingType, Result);

end;  {OpenTables}

{===============================================================}
Procedure TSmallClaimsAddDialog.FormShow(Sender: TObject);

var
  SBLRec : SBLRecord;

begin
  AlreadyCopied := False;
  EditSmallClaimsYear.Text := SmallClaimsYear;

  OpenTablesForForm(Self, SmallClaimsProcessingType);

    {First let's find this parcel in the parcel table.}

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section',
                'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
               [SmallClaimsYear, SwisCode, Section,
                SubSection, Block, Lot, Sublot, Suffix]);

  GrievanceTable.IndexName := 'BYSWISSBLKEY_TAXROLLYR_GREVNUM';
  SetRangeOld(GrievanceTable, ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber'],
              [SwisSBLKey, SmallClaimsYear, '0'],
              [SwisSBLKey, SmallClaimsYear, '9999']);
  GrievanceNumber := GrievanceTable.FieldByName('GrievanceNumber').AsInteger;

  OpenTables(SmallClaimsProcessingType, PriorProcessingType);

  CheckForGrievanceTimer.Enabled := True;

end;  {FormShow}

{===============================================================}
Procedure TSmallClaimsAddDialog.EditSmallClaimsYearExit(Sender: TObject);

{Check to see if we can copy a grievance based on the year they entered if the
 year is other than the ThisYear.}

begin
  If _Compare(EditSmallClaimsYear.Text, GlblThisYear, coNotEqual)
    then
      begin
        SmallClaimsYear := EditSmallClaimsYear.Text;
        CheckForGrievanceTimer.Enabled := True;

      end;

end;  {EditSmallClaimsYearExit}

{===============================================================}
Procedure TSmallClaimsAddDialog.OKButtonClick(Sender: TObject);

var
  FirstTimeThrough, Done, Continue : Boolean;
  NumParcelsCopiedTo : Integer;
  ThisSwisSBLKey : String;

begin
  Continue := True;
  LawyerCode := LawyerCodeLookupCombo.Text;
  SmallClaimsYear := EditSmallClaimsYear.Text;

    {FXX10122009-2(2.20.1.20): Make sure to adjust the prior year.}

  PriorYear := IntToStr(StrToInt(SmallClaimsYear) - 1);

  try
    IndexNumber := StrToInt(EditIndexNumber.Text);
  except
    Continue := False;
    MessageDlg('Sorry, ' + EditIndexNumber.Text + ' is not a valid SmallClaims number.' + #13 +
               'Please correct it.', mtError, [mbOK], 0);
    EditIndexNumber.SetFocus;
  end;

    {See if there are other parcels already with this SmallClaims number.
     If so, warn them, but let them continue.}

  If Continue
    then
      begin
        SetRangeOld(SmallClaimsTable, ['TaxRollYr', 'IndexNumber'],
                    [SmallClaimsYear, IntToStr(IndexNumber)],
                    [SmallClaimsYear, IntToSTr(IndexNumber)]);

        SmallClaimsTable.First;

        If not SmallClaimsTable.EOF
          then
            try
              Cert_Or_SmallClaimsDuplicatesDialog := TCert_Or_SmallClaimsDuplicatesDialog.Create(nil);
              Cert_Or_SmallClaimsDuplicatesDialog.IndexNumber := IndexNumber;
              Cert_Or_SmallClaimsDuplicatesDialog.CurrentYear := SmallClaimsYear;
              Cert_Or_SmallClaimsDuplicatesDialog.AskForConfirmation := True;
              Cert_Or_SmallClaimsDuplicatesDialog.Source := 'S';

              If (Cert_Or_SmallClaimsDuplicatesDialog.ShowModal = idNo)
                then Continue := False;

            finally
              Cert_Or_SmallClaimsDuplicatesDialog.Free;
            end;

      end;  {If Continue}

  If Continue
    then
      begin
          {FXX10142009-1(2.20.1.20)[D1562]: Need to set the processing types based on the
                                            year entered.}
                                            
        SmallClaimsProcessingType := GetProcessingTypeForTaxRollYear(SmallClaimsYear);
        case SmallClaimsProcessingType of
          NextYear : PriorProcessingType := ThisYear;
          ThisYear : PriorProcessingType := History;
          History : PriorProcessingType := History;
        end;

        OpenTables(SmallClaimsProcessingType, PriorProcessingType);
        FindKeyOld(LawyerCodeTable, ['Code'],
                   [LawyerCode]);

        case SmallClaimsCopyType of
          ctThisParcel :
            begin
              AlreadyCopied := True;

              CopyGrievanceToCert_Or_SmallClaim(IndexNumber,
                                                GrievanceNumber,
                                                SmallClaimsYear,
                                                PriorYear,
                                                SwisSBLKey,
                                                LawyerCode, 1,
                                                GrievanceTable,
                                                SmallClaimsTable,
                                                LawyerCodeTable,
                                                ParcelTable,
                                                CurrentAssessmentTable,
                                                PriorAssessmentTable,
                                                SwisCodeTable,
                                                PriorSwisCodeTable,
                                                CurrentExemptionsTable,
                                                SmallClaimsExemptionsTable,
                                                CurrentSpecialDistrictsTable,
                                                SmallClaimsSpecialDistrictsTable,
                                                CurrentSalesTable,
                                                SmallClaimsSalesTable,
                                                GrievanceExemptionsAskedTable,
                                                SmallClaimsExemptionsAskedTable,
                                                GrievanceResultsTable,
                                                GrievanceDispositionCodeTable, 'S');

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
                          [SmallClaimsYear, IntToStr(GrievanceNumber)],
                          [SmallClaimsYear, IntToStr(GrievanceNumber)]);

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

                      CopyGrievanceToCert_Or_SmallClaim(IndexNumber,
                                                        GrievanceNumber,
                                                        SmallClaimsYear,
                                                        PriorYear,
                                                        ThisSwisSBLKey,
                                                        LawyerCode,
                                                        TotalParcelsWithThisGrievance,
                                                        GrievanceTable,
                                                        SmallClaimsTable,
                                                        LawyerCodeTable,
                                                        ParcelTable,
                                                        CurrentAssessmentTable,
                                                        PriorAssessmentTable,
                                                        SwisCodeTable,
                                                        PriorSwisCodeTable,
                                                        CurrentExemptionsTable,
                                                        SmallClaimsExemptionsTable,
                                                        CurrentSpecialDistrictsTable,
                                                        SmallClaimsSpecialDistrictsTable,
                                                        CurrentSalesTable,
                                                        SmallClaimsSalesTable,
                                                        GrievanceExemptionsAskedTable,
                                                        SmallClaimsExemptionsAskedTable,
                                                        GrievanceResultsTable,
                                                        GrievanceDispositionCodeTable, 'S');

                    end;  {If not Done}

              until Done;

              MessageDlg('The small claims was copied to ' +
                         IntToStr(TotalParcelsWithThisGrievance) +
                         ' parcels (including this one).', mtInformation, [mbOK], 0);

            end;  {ctAllParcels}

        end;  {case SmallClaimsCopyType of}

        ModalResult := mrOK;

      end;  {If Continue}

end;  {OKButtonClick}

{===============================================================}
Procedure TSmallClaimsAddDialog.NewLawyerButtonClick(Sender: TObject);

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
Procedure TSmallClaimsAddDialog.LawyerCodeLookupComboNotInList(    Sender: TObject;
                                                                        LookupTable: TDataSet;
                                                                        NewValue: String;
                                                                    var Accept: Boolean);

begin
  If (NewValue = '')
    then Accept := True;

end;  {LawyerCodeLookupComboNotInList}

{======================================================}
Procedure TSmallClaimsAddDialog.FormClose(    Sender: TObject;
                                        var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  Action := caFree;
end;

end.
