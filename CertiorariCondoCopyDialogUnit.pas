unit CertiorariCondoCopyDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables, ExtCtrls, Grids, Wwtable;

type
  TCertiorariCondoCopyDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    CertiorariTable: TTable;
    InformationLabel: TLabel;
    ParcelGroupBox: TGroupBox;
    ParcelGrid: TStringGrid;
    ClearButton: TBitBtn;
    AddButton: TBitBtn;
    DeleteButton: TBitBtn;
    CurrentExemptionsTable: TTable;
    CertiorariExemptionsTable: TTable;
    CurrentAssessmentTable: TTable;
    CertiorariExemptionsAskedTable: TwwTable;
    CertiorariSpecialDistrictsTable: TTable;
    CurrentSpecialDistrictsTable: TTable;
    ParcelTable: TTable;
    SwisCodeTable: TTable;
    PriorAssessmentTable: TTable;
    LawyerCodeTable: TTable;
    CertiorariLookupTable: TTable;
    CertiorariExemptionsAskedLookupTable: TTable;
    GrievanceTable: TTable;
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
    PriorYear, CertiorariYear : String;
    CertiorariNumber : LongInt;
    SwisSBLKeyList : TStringList;

    Procedure SetNumParcelsLabel(NumParcels : Integer);
    Procedure AddOneParcel(SwisSBLKey : String);
    Procedure CreateOneCertiorari(SwisSBLKey : String);

  end;

var
  CertiorariCondoCopyDialog: TCertiorariCondoCopyDialog;

implementation

{$R *.DFM}

uses WinUtils, Utilitys, PASUtils, GlblVars, GlblCnst,
     PASTypes, GrievanceUtilitys, Prog, DataAccessUnit;

{===============================================================}
Procedure TCertiorariCondoCopyDialog.FormShow(Sender: TObject);

var
  TempRepresentative : String;
  PriorProcessingType, CertiorariProcessingType : Integer;
  Quit : Boolean;

begin
  UnitName := 'CertiorariCondoCopyDialogUnit';
  SwisSBLKeyList := TStringList.Create;

    {FXX10082003-1(2.07j1): Don't base the processing type of the current and prior on
                            the current grievance year, but the year of this grievance.}

  CertiorariProcessingType := GetProcessingTypeForTaxRollYear(CertiorariYear);
  PriorYear := IntToStr(StrToInt(CertiorariYear) - 1);
  PriorProcessingType := GetProcessingTypeForTaxRollYear(PriorYear);

  OpenTablesForForm(Self, CertiorariProcessingType);

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             CertiorariProcessingType, Quit);

  OpenTableForProcessingType(CurrentAssessmentTable, AssessmentTableName,
                             CertiorariProcessingType, Quit);

  OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                             PriorProcessingType, Quit);

  OpenTableForProcessingType(CurrentExemptionsTable, ExemptionsTableName,
                             CertiorariProcessingType, Quit);

  OpenTableForProcessingType(CurrentSpecialDistrictsTable, SpecialDistrictTableName,
                             CertiorariProcessingType, Quit);

  If (Trim(LawyerCode) = '')
    then TempRepresentative := LawyerCode
    else TempRepresentative := '';

  InformationLabel.Caption := 'Please enter the additional parcels that should have a certiorari created ' +
                              'with certiorari # ' + IntToStr(CertiorariNumber);

  If (TempRepresentative = '')
    then InformationLabel.Caption := InformationLabel.Caption + '.'
    else InformationLabel.Caption := InformationLabel.Caption + ' and representative = ' +
                                     TempRepresentative;

end;  {FormShow}

{============================================================}
Procedure TCertiorariCondoCopyDialog.SetNumParcelsLabel(NumParcels : Integer);

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
Procedure TCertiorariCondoCopyDialog.AddOneParcel(SwisSBLKey : String);

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
Procedure TCertiorariCondoCopyDialog.ClearButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure that you want to clear all of the parcel IDs?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then ClearStringGrid(ParcelGrid);

  SetNumParcelsLabel(FindLastItem(ParcelGrid));

end;  {ClearButtonClick}

{===============================================================}
Procedure TCertiorariCondoCopyDialog.AddButtonClick(Sender: TObject);

var
  SwisSBLKey : String;
  I : Integer;

begin
  If ExecuteParcelLocateDialog(SwisSBLKey, True, False, 'Locate Parcel(s)',
                               True, SwisSBLKeyList)
    then
      For I := 0 to (SwisSBLKeyList.Count - 1) do
        If _Compare(SwisSBLKeyList[I], coNotBlank)
          then AddOneParcel(SwisSBLKeyList[I]);

  SetNumParcelsLabel(FindLastItem(ParcelGrid));

end;  {AddButtonClick}

{===============================================================}
Procedure TCertiorariCondoCopyDialog.DeleteButtonClick(Sender: TObject);

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
Function FindGrievanceForCertiorari(GrievanceTable : TTable;
                                    CertiorariYear : String;
                                    SwisSBLKey : String;
                                    LawyerCode : String) : Boolean;

{FXX05182005-2(2.8.4.5)[2127]: There may be multiple grievances for this year, so select by attorney.}

var
  Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  Result := False;

  _SetRange(GrievanceTable, [CertiorariYear, SwisSBLKey], [], '', [loSameEndingRange]);

  GrievanceTable.First;

  If _Compare(GrievanceTable.RecordCount, 1, coEqual)
    then Result := True
    else
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else GrievanceTable.Next;

        If GrievanceTable.EOF
          then Done := True;

        If ((not Done) and
            _Compare(GrievanceTable.FieldByName('LawyerCode').Text, LawyerCode, coEqual))
          then Result := True;

      until (Done or Result);

end;  {FindGrievanceForCertiorari}

{===============================================================}
Procedure TCertiorariCondoCopyDialog.CreateOneCertiorari(SwisSBLKey : String);

var
  SBLRec : SBLRecord;
  PriorAssessmentFound, CertiorariExists : Boolean;

begin
  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section',
                'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
               [CertiorariYear, SwisCode, Section,
                SubSection, Block, Lot, Sublot, Suffix]);

  FindKeyOld(SwisCodeTable, ['SwisCode'], [Copy(SwisSBLKey, 1, 6)]);

  FindKeyOld(CurrentAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
             [CertiorariYear, SwisSBLKey]);

  with SBLRec do
    PriorAssessmentFound := FindKeyOld(PriorAssessmentTable,
                                       ['TaxRollYr', 'SwisSBLKey'],
                                       [PriorYear, SwisSBLKey]);

  SetRangeOld(CurrentExemptionsTable, ['TaxRollYr', 'SwisSBLKey'],
              [CertiorariYear, SwisSBLKey], [CertiorariYear, SwisSBLKey]);

  SetRangeOld(CurrentSpecialDistrictsTable, ['TaxRollYr', 'SwisSBLKey'],
              [CertiorariYear, SwisSBLKey], [CertiorariYear, SwisSBLKey]);

  SetRangeOld(CertiorariExemptionsAskedLookupTable,
              ['TaxRollYr', 'SwisSBLKey', 'CertiorariNumber', 'ExemptionCode'],
              [CertiorariYear, OriginalSwisSBLKey, IntToStr(CertiorariNumber), '     '],
              [CertiorariYear, OriginalSwisSBLKey, IntToStr(CertiorariNumber), '99999']);

    {FXX01222004-1(2.07l1): Check to make sure that the grievance does not exist before copying it.}

  CertiorariExists := FindKeyOld(CertiorariTable, ['TaxRollYr', 'SwisSBLKey', 'CertiorariNumber'],
                                [CertiorariYear, SwisSBLKey, IntToStr(CertiorariNumber)]);

  FindKeyOld(CertiorariTable, ['TaxRollYr', 'SwisSBLKey', 'CertiorariNumber'],
             [CertiorariYear, OriginalSwisSBLKey, IntToStr(CertiorariNumber)]);

  If CertiorariExists
    then MessageDlg('This certiorari already exists on parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '.' + #13 +
                    'No new certiorari was created on this parcel.' + #13 +
                    'Press OK to continue the copy.', mtWarning, [mbOK], 0)
    else
      with CertiorariLookupTable do
        try
          Append;
          FieldByName('TaxRollYr').Text := CertiorariYear;
          FieldByName('CertiorariNumber').AsInteger := CertiorariNumber;
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

          If ((Deblank(LawyerCode) = '') or
              GlblGrievanceSeperateRepresentativeInfo)
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
            else SetPetitionerNameAndAddress(CertiorariLookupTable, LawyerCodeTable, LawyerCode);

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

          FieldByName('PetitReason').Text := CertiorariTable.FieldByName('PetitReason').Text;
          FieldByName('PetitSubreasonCode').Text := CertiorariTable.FieldByName('PetitSubreasonCode').Text;
          TMemoField(FieldByName('PetitSubreason')).Assign(TMemoField(CertiorariTable.FieldByName('PetitSubreason')));
          TMemoField(FieldByName('Notes')).Assign(TMemoField(CertiorariTable.FieldByName('Notes')));
          FieldByName('NumberOfParcels').AsInteger := CertiorariTable.FieldByName('NumberOfParcels').AsInteger;

          try
            If (FieldByName('NoticeOfPetition').AsDateTime > StrToDate('1/1/1950'))
              then FieldByName('NoticeOfPetition').AsDateTime := CertiorariTable.FieldByName('NoticeOfPetition').AsDateTime
              else FieldByName('NoticeOfPetition').Text := '';
          except
            FieldByName('NoticeOfPetition').Text := '';
          end;

          try
            If (FieldByName('NoteOfIssue').AsDateTime > StrToDate('1/1/1950'))
              then FieldByName('NoteOfIssue').AsDateTime := CertiorariTable.FieldByName('NoteOfIssue').AsDateTime
              else FieldByName('NoteOfIssue').Text := '';
          except
            FieldByName('NoteOfIssue').Text := '';
          end;

          try
            If (FieldByName('MunicipalAuditDate').AsDateTime > StrToDate('1/1/1950'))
              then FieldByName('MunicipalAuditDate').AsDateTime := CertiorariTable.FieldByName('MunicipalAuditDate').AsDateTime
              else FieldByName('MunicipalAuditDate').Text := '';
          except
            FieldByName('MunicipalAuditDate').Text := '';
          end;

          FieldByName('AlternateID').Text := CertiorariTable.FieldByName('AlternateID').Text;
          FieldByName('ArticleType').Text := CertiorariTable.FieldByName('ArticleType').Text;

          FieldByName('SchoolCode').Text := ParcelTable.FieldByName('SchoolCode').Text;

          FieldByName('CurrentEqRate').AsFloat := SwisCodeTable.FieldByName('EqualizationRate').AsFloat;
          FieldByName('CurrentUniformPercent').AsFloat := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
          FieldByName('CurrentRAR').AsFloat := SwisCodeTable.FieldByName('ResAssmntRatio').AsFloat;

            {CHG07262004-1(2.08): Option to have attorney information seperate.}

          If GlblGrievanceSeperateRepresentativeInfo
            then
              try
                FieldByName('AttyName1').Text := CertiorariTable.FieldByName('AttyName1').Text;
                FieldByName('AttyName2').Text := CertiorariTable.FieldByName('AttyName2').Text;
                FieldByName('AttyAddress1').Text := CertiorariTable.FieldByName('AttyAddress1').Text;
                FieldByName('AttyAddress2').Text := CertiorariTable.FieldByName('AttyAddress2').Text;
                FieldByName('AttyStreet').Text := CertiorariTable.FieldByName('AttyStreet').Text;
                FieldByName('AttyCity').Text := CertiorariTable.FieldByName('AttyCity').Text;
                FieldByName('AttyState').Text := CertiorariTable.FieldByName('AttyState').Text;
                FieldByName('AttyZip').Text := CertiorariTable.FieldByName('AttyZip').Text;
                FieldByName('AttyZipPlus4').Text := CertiorariTable.FieldByName('AttyZipPlus4').Text;
                FieldByName('AttyPhoneNumber').Text := CertiorariTable.FieldByName('AttyPhoneNumber').Text;

              except
              end;

            {FXX05182005-2(2.8.4.5)[2127]: There may be multiple grievances for this year, so select by attorney.}

          If FindGrievanceForCertiorari(GrievanceTable, CertiorariYear, SwisSBLKey, LawyerCode)
            then
              begin
                FieldByName('PetitLandValue').AsInteger := GrievanceTable.FieldByName('PetitLandValue').AsInteger;
                FieldByName('PetitTotalValue').AsInteger := GrievanceTable.FieldByName('PetitTotalValue').AsInteger;
                FieldByName('PetitFullMarketVal').AsInteger := GrievanceTable.FieldByName('PetitFullMarketVal').AsInteger;

              end;  {If _Locate(GrievanceTable, [CertiorariYear, SwisSBLKey], '', [])}

          Post;

          CopyTableRange(CertiorariExemptionsAskedLookupTable, CertiorariExemptionsAskedTable,
                         'TaxRollYr', ['SwisSBLKey'], [SwisSBLKey]);

          CopyTableRange(CurrentExemptionsTable, CertiorariExemptionsTable,
                         'TaxRollYr', ['CertiorariNumber'], [IntToStr(CertiorariNumber)]);

          CopyTableRange(CurrentSpecialDistrictsTable, CertiorariSpecialDistrictsTable,
                         'TaxRollYr', ['CertiorariNumber'], [IntToStr(CertiorariNumber)]);

        except
          SystemSupport(005, CertiorariTable,
                        'Error adding certiorari for parcel ' +
                        ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                        UnitName, GlblErrorDlgBox);

        end;

end;  {CreateOneCertiorari}

{===============================================================}
Procedure TCertiorariCondoCopyDialog.OKButtonClick(Sender: TObject);

var
  Continue : Boolean;
  I : Integer;

begin
  Continue := True;

  If (SwisSBLKeyList.Count = 0)
    then
      begin
        MessageDlg('No parcels have been specified to create certioraris for.',
                   mtError, [mbOK], 0);
        Continue := False
      end
    else
      begin
        ProgressDialog.UserLabelCaption := 'Copying certiorari #' + IntToStr(CertiorariNumber);
        ProgressDialog.Start(SwisSBLKeyList.Count, True, True);

        For I := 0 to (SwisSBLKeyList.Count - 1) do
          begin
            ProgressDialog.Update(Self, SwisSBLKeyList[I]);
            Application.ProcessMessages;
            CreateOneCertiorari(SwisSBLKeyList[I]);

          end;  {For I := 0 to (SwisSBLKeyList.Count - 1) do}

        ProgressDialog.Finish;

      end;  {else of If (SwisSBLKeyList.Count = 0)}

  If Continue
    then
      begin
        MessageDlg('The certiorari has been copied to all of the specified parcels.',
                   mtInformation, [mbOK], 0);
        ModalResult := mrOK;
      end;

end;  {OKButtonClick}

{======================================================}
Procedure TCertiorariCondoCopyDialog.FormClose(    Sender: TObject;
                                        var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  SwisSBLKeyList.Free;
  Action := caFree;
end;

end.
