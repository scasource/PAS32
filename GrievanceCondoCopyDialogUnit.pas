unit GrievanceCondoCopyDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables, ExtCtrls, Grids, Wwtable;

type
  TGrievanceCondoCopyDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    GrievanceTable: TTable;
    InformationLabel: TLabel;
    ParcelGroupBox: TGroupBox;
    ParcelGrid: TStringGrid;
    ClearButton: TBitBtn;
    AddButton: TBitBtn;
    DeleteButton: TBitBtn;
    CurrentExemptionsTable: TTable;
    GrievanceExemptionsTable: TTable;
    CurrentAssessmentTable: TTable;
    GrievanceExemptionsAskedTable: TwwTable;
    GrievanceSpecialDistrictsTable: TTable;
    CurrentSpecialDistrictsTable: TTable;
    ParcelTable: TTable;
    SwisCodeTable: TTable;
    PriorAssessmentTable: TTable;
    LawyerCodeTable: TTable;
    GrievanceLookupTable: TTable;
    GrievanceExemptionsAskedLookupTable: TTable;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditAskingPercent: TEdit;
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClearButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LawyerCode, UnitName,
    OriginalSwisSBLKey,
    PriorYear, GrievanceYear : String;
    GrievanceNumber : LongInt;
    AskingPercent : Double;
    SwisSBLKeyList : TStringList;

    Procedure SetNumParcelsLabel(NumParcels : Integer);
    Procedure AddOneParcel(SwisSBLKey : String);
    Procedure CreateOneGrievance(SwisSBLKey : String;
                                 AskingPercent : Double);

  end;

var
  GrievanceCondoCopyDialog: TGrievanceCondoCopyDialog;

implementation

{$R *.DFM}

uses WinUtils, Utilitys, PASUtils, GlblVars, GlblCnst,
     PASTypes, GrievanceUtilitys, Prog;

{===============================================================}
Procedure TGrievanceCondoCopyDialog.FormShow(Sender: TObject);

var
  TempRepresentative : String;
  PriorProcessingType, GrievanceProcessingType : Integer;
  Quit : Boolean;

begin
  UnitName := 'GrievanceCondoCopyDialogUnit';
  SwisSBLKeyList := TStringList.Create;

    {FXX10082003-1(2.07j1): Don't base the processing type of the current and prior on
                            the current grievance year, but the year of this grievance.}

  GrievanceProcessingType := GetProcessingTypeForTaxRollYear(GrievanceYear);
  PriorYear := IntToStr(StrToInt(GrievanceYear) - 1);
  PriorProcessingType := GetProcessingTypeForTaxRollYear(PriorYear);

  OpenTablesForForm(Self, GrievanceProcessingType);

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             GrievanceProcessingType, Quit);

  OpenTableForProcessingType(CurrentAssessmentTable, AssessmentTableName,
                             GrievanceProcessingType, Quit);

  OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                             PriorProcessingType, Quit);

  OpenTableForProcessingType(CurrentExemptionsTable, ExemptionsTableName,
                             GrievanceProcessingType, Quit);

  OpenTableForProcessingType(CurrentSpecialDistrictsTable, SpecialDistrictTableName,
                             GrievanceProcessingType, Quit);

  If (Trim(LawyerCode) = '')
    then TempRepresentative := LawyerCode
    else TempRepresentative := '';

  InformationLabel.Caption := 'Please enter the additional parcels that should have a grievance created ' +
                              'with grievance # ' + IntToStr(GrievanceNumber);

  If (TempRepresentative = '')
    then InformationLabel.Caption := InformationLabel.Caption + '.'
    else InformationLabel.Caption := InformationLabel.Caption + ' and representative = ' +
                                     TempRepresentative;

end;  {FormShow}

{============================================================}
Procedure TGrievanceCondoCopyDialog.SetNumParcelsLabel(NumParcels : Integer);

begin
  ParcelGroupBox.Caption := ' ' + IntToStr(NumParcels) + ' Parcels: ';
end;  {SetNumParcelsLabel}

{============================================================}
Function FindLastItem(ParcelGrid : TStringGrid) : Integer;

var
  I : Integer;

begin
  Result := 0;

  with ParcelGrid do
    For I := 0 to (RowCount - 1) do
      If (Deblank(Cells[0, I]) <> '')
        then Result := Result + 1;

end;  {FindLastItem}

{============================================================}
Procedure TGrievanceCondoCopyDialog.AddOneParcel(SwisSBLKey : String);

var
  LastItem : Integer;

begin
  LastItem := FindLastItem(ParcelGrid);

  with ParcelGrid do
    begin
      If (LastItem = (RowCount - 1))
        then RowCount := RowCount + 1;

      Cells[0, LastItem] := ConvertSwisSBLToDashDot(SwisSBLKey);

    end;  {with ParcelGrid do}

  ParcelGrid.Row := LastItem + 1;

end;  {AddOneParcel}

{===============================================================}
Procedure TGrievanceCondoCopyDialog.ClearButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure that you want to clear all of the parcel IDs?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then ClearStringGrid(ParcelGrid);

  SetNumParcelsLabel(FindLastItem(ParcelGrid));

end;  {ClearButtonClick}

{===============================================================}
Procedure TGrievanceCondoCopyDialog.AddButtonClick(Sender: TObject);

var
  SwisSBLKey : String;
  I : Integer;

begin
  If ExecuteParcelLocateDialog(SwisSBLKey, True, False, 'Locate Parcel(s)',
                               True, SwisSBLKeyList)
    then
      For I := 0 to (SwisSBLKeyList.Count - 1) do
        If (Deblank(SwisSBLKeyList[I]) <> '')
          then AddOneParcel(SwisSBLKeyList[I]);

  SetNumParcelsLabel(FindLastItem(ParcelGrid));

end;  {AddButtonClick}

{===============================================================}
Procedure TGrievanceCondoCopyDialog.DeleteButtonClick(Sender: TObject);

var
  TempRow, I : Integer;

begin
  TempRow := ParcelGrid.Row;

    {FXX07211999-5: Delete leaves 'X' in grid.}

  with ParcelGrid do
    begin
      For I := (TempRow + 1) to (RowCount - 1) do
        Cells[0, (I - 1)] := Cells[0, I];

          {Blank out the last row.}

      Cells[0, (RowCount - 1)] := '';

    end;  {with ParcelGrid do}

  SetNumParcelsLabel(FindLastItem(ParcelGrid));

end;  {DeleteButtonClick}

{===============================================================}
Procedure TGrievanceCondoCopyDialog.CreateOneGrievance(SwisSBLKey : String;
                                                       AskingPercent : Double);

var
  SBLRec : SBLRecord;
  PriorAssessmentFound, GrievanceExists : Boolean;

begin
  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section',
                'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
               [GrievanceYear, SwisCode, Section,
                SubSection, Block, Lot, Sublot, Suffix]);

  FindKeyOld(SwisCodeTable, ['SwisCode'], [Copy(SwisSBLKey, 1, 6)]);

  FindKeyOld(CurrentAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
             [GrievanceYear, SwisSBLKey]);

  with SBLRec do
    PriorAssessmentFound := FindKeyOld(PriorAssessmentTable,
                                       ['TaxRollYr', 'SwisSBLKey'],
                                       [PriorYear, SwisSBLKey]);

  SetRangeOld(CurrentExemptionsTable, ['TaxRollYr', 'SwisSBLKey'],
              [GrievanceYear, SwisSBLKey], [GrievanceYear, SwisSBLKey]);

  SetRangeOld(CurrentSpecialDistrictsTable, ['TaxRollYr', 'SwisSBLKey'],
              [GrievanceYear, SwisSBLKey], [GrievanceYear, SwisSBLKey]);

  SetRangeOld(GrievanceExemptionsAskedLookupTable,
              ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ExemptionCode'],
              [OriginalSwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '     '],
              [OriginalSwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber), '99999']);

    {FXX01222004-1(2.07l1): Check to make sure that the grievance does not exist before copying it.}

  GrievanceExists := FindKeyOld(GrievanceTable, ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber'],
                                [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber)]);

  FindKeyOld(GrievanceTable, ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber'],
             [OriginalSwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber)]);

  If GrievanceExists
    then MessageDlg('This grievance already exists on parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '.' + #13 +
                    'No new grievance was created on this parcel.' + #13 +
                    'Press OK to continue the copy.', mtWarning, [mbOK], 0) 
    else
      with GrievanceLookupTable do
        try
          Append;
          FieldByName('TaxRollYr').Text := GrievanceYear;
          FieldByName('GrievanceNumber').AsInteger := GrievanceNumber;
          FieldByName('SwisSBLKey').Text := SwisSBLKey;
          FieldByName('LawyerCode').Text := LawyerCode;

          FieldByName('CurrentName1').Text := ParcelTable.FieldByName('Name1').Text;
          FieldByName('CurrentName2').Text := ParcelTable.FieldByName('Name2').Text;
          FieldByName('CurrentAddress1').Text := ParcelTable.FieldByName('Address1').Text;
          FieldByName('CurrentAddress2').Text := ParcelTable.FieldByName('Address2').Text;
          FieldByName('CurrentStreet').Text := ParcelTable.FieldByName('Street').Text;
          FieldByName('CurrentCity').Text := ParcelTable.FieldByName('City').Text;
          FieldByName('CurrentState').Text := ParcelTable.FieldByName('State').Text;
          FieldByName('CurrentZip').Text := ParcelTable.FieldByName('Zip').Text;
          FieldByName('CurrentZipPlus4').Text := ParcelTable.FieldByName('ZipPlus4').Text;

          If (Deblank(LawyerCode) = '')
            then
              begin
                  {They are representing themselves.}

                FieldByName('PetitName1').Text := ParcelTable.FieldByName('Name1').Text;
                FieldByName('PetitName2').Text := ParcelTable.FieldByName('Name2').Text;
                FieldByName('PetitAddress1').Text := ParcelTable.FieldByName('Address1').Text;
                FieldByName('PetitAddress2').Text := ParcelTable.FieldByName('Address2').Text;
                FieldByName('PetitStreet').Text := ParcelTable.FieldByName('Street').Text;
                FieldByName('PetitCity').Text := ParcelTable.FieldByName('City').Text;
                FieldByName('PetitState').Text := ParcelTable.FieldByName('State').Text;
                FieldByName('PetitZip').Text := ParcelTable.FieldByName('Zip').Text;
                FieldByName('PetitZipPlus4').Text := ParcelTable.FieldByName('ZipPlus4').Text;

              end
            else SetPetitionerNameAndAddress(GrievanceLookupTable, LawyerCodeTable, LawyerCode);

          FieldByName('PropertyClassCode').Text := ParcelTable.FieldByName('PropertyClassCode').Text;
          FieldByName('OwnershipCode').Text := ParcelTable.FieldByName('OwnershipCode').Text;
          FieldByName('ResidentialPercent').AsFloat := ParcelTable.FieldByName('ResidentialPercent').AsFloat;
          FieldByName('RollSection').Text := ParcelTable.FieldByName('RollSection').Text;
          FieldByName('HomesteadCode').Text := ParcelTable.FieldByName('HomesteadCode').Text;
          FieldByName('LegalAddr').Text := ParcelTable.FieldByName('LegalAddr').Text;
          FieldByName('LegalAddrNo').Text := ParcelTable.FieldByName('LegalAddrNo').Text;

            {FXX01162003-3: Need to include the legal address integer.}

          try
            FieldByName('LegalAddrInt').AsInteger := ParcelTable.FieldByName('LegalAddrInt').AsInteger;
          except
          end;

          FieldByName('CurrentLandValue').AsInteger := CurrentAssessmentTable.FieldByName('LandAssessedVal').AsInteger;
          FieldByName('CurrentTotalValue').AsInteger := CurrentAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
          FieldByName('CurrentFullMarketVal').AsInteger := Round(ComputeFullValue(CurrentAssessmentTable.FieldByName('TotalAssessedVal').AsInteger,
                                                                                  SwisCodeTable,
                                                                                  ParcelTable.FieldByName('PropertyClassCode').Text,
                                                                                  ParcelTable.FieldByName('OwnershipCode').Text,
                                                                                  False));
          If PriorAssessmentFound
            then
              begin
                FieldByName('PriorLandValue').AsInteger := PriorAssessmentTable.FieldByName('LandAssessedVal').AsInteger;
                FieldByName('PriorTotalValue').AsInteger := PriorAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
              end;

          FieldByName('PetitReason').Text := GrievanceTable.FieldByName('PetitReason').Text;
          FieldByName('PetitSubreasonCode').Text := GrievanceTable.FieldByName('PetitSubreasonCode').Text;
          TMemoField(FieldByName('PetitSubreason')).Assign(TMemoField(GrievanceTable.FieldByName('PetitSubreason')));
          TMemoField(FieldByName('Notes')).Assign(TMemoField(GrievanceTable.FieldByName('Notes')));
          FieldByName('PreventUpdate').AsBoolean := GrievanceTable.FieldByName('PreventUpdate').AsBoolean;
          FieldByName('NoHearing').AsBoolean := GrievanceTable.FieldByName('NoHearing').AsBoolean;
          FieldByName('AppearanceNumber').AsInteger := GrievanceTable.FieldByName('AppearanceNumber').AsInteger;

            {CHG12152005-1(2.9.4.3): Add the ability to put in an asking value.}

          If _Compare(AskingPercent, 0, coGreaterThan)
            then FieldByName('PetitTotalValue').AsInteger := Round(FieldByName('CurrentTotalValue').AsInteger * (AskingPercent / 100));

          Post;

          CopyTableRange(GrievanceExemptionsAskedLookupTable, GrievanceExemptionsAskedTable,
                         'TaxRollYr', ['SwisSBLKey'], [SwisSBLKey]);

          CopyTableRange(CurrentExemptionsTable, GrievanceExemptionsTable,
                         'TaxRollYr', ['GrievanceNumber'], [IntToStr(GrievanceNumber)]);

          CopyTableRange(CurrentSpecialDistrictsTable, GrievanceSpecialDistrictsTable,
                         'TaxRollYr', ['GrievanceNumber'], [IntToStr(GrievanceNumber)]);

        except
          SystemSupport(005, GrievanceTable,
                        'Error adding grievance for parcel ' +
                        ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                        UnitName, GlblErrorDlgBox);

        end;

end;  {CreateOneGrievance}

{===============================================================}
Procedure TGrievanceCondoCopyDialog.OKButtonClick(Sender: TObject);

var
  Continue : Boolean;
  I : Integer;

begin
  Continue := True;

  If (SwisSBLKeyList.Count = 0)
    then
      begin
        MessageDlg('No parcels have been specified to create grievances for.',
                   mtError, [mbOK], 0);
        Continue := False
      end
    else
      begin
        try
          AskingPercent := StrToFloat(EditAskingPercent.Text);
        except
          AskingPercent := 0;
        end;

        ProgressDialog.UserLabelCaption := 'Copying grievance #' + IntToStr(GrievanceNumber);
        ProgressDialog.Start(SwisSBLKeyList.Count, True, True);

        For I := 0 to (SwisSBLKeyList.Count - 1) do
          begin
            ProgressDialog.Update(Self, SwisSBLKeyList[I]);
            Application.ProcessMessages;
            CreateOneGrievance(SwisSBLKeyList[I], AskingPercent);

          end;  {For I := 0 to (SwisSBLKeyList.Count - 1) do}

        ProgressDialog.Finish;

      end;  {else of If (SwisSBLKeyList.Count = 0)}

  If Continue
    then
      begin
        MessageDlg('The grievance has been copied to all of the specified parcels.',
                   mtInformation, [mbOK], 0);
        ModalResult := mrOK;
      end;

end;  {OKButtonClick}

{======================================================}
Procedure TGrievanceCondoCopyDialog.FormClose(    Sender: TObject;
                                        var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  SwisSBLKeyList.Free;
  Action := caFree;
end;

end.
