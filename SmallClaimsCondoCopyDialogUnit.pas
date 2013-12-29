unit SmallClaimsCondoCopyDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdblook, Db, DBTables, ExtCtrls, Grids, Wwtable;

type
  TSmallClaimsCondoCopyDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    SmallClaimsTable: TTable;
    InformationLabel: TLabel;
    ParcelGroupBox: TGroupBox;
    ParcelGrid: TStringGrid;
    ClearButton: TBitBtn;
    AddButton: TBitBtn;
    DeleteButton: TBitBtn;
    CurrentExemptionsTable: TTable;
    SmallClaimsExemptionsTable: TTable;
    CurrentAssessmentTable: TTable;
    SmallClaimsExemptionsAskedTable: TwwTable;
    SmallClaimsSpecialDistrictsTable: TTable;
    CurrentSpecialDistrictsTable: TTable;
    ParcelTable: TTable;
    SwisCodeTable: TTable;
    PriorAssessmentTable: TTable;
    LawyerCodeTable: TTable;
    SmallClaimsLookupTable: TTable;
    SmallClaimsExemptionsAskedLookupTable: TTable;
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
    PriorYear, SmallClaimsYear : String;
    IndexNumber : LongInt;
    SwisSBLKeyList : TStringList;

    Procedure SetNumParcelsLabel(NumParcels : Integer);
    Procedure AddOneParcel(SwisSBLKey : String);
    Procedure CreateOneSmallClaims(SwisSBLKey : String);

  end;

var
  SmallClaimsCondoCopyDialog: TSmallClaimsCondoCopyDialog;

implementation

{$R *.DFM}

uses WinUtils, Utilitys, PASUtils, GlblVars, GlblCnst,
     PASTypes, GrievanceUtilitys, Prog;

{===============================================================}
Procedure TSmallClaimsCondoCopyDialog.FormShow(Sender: TObject);

var
  TempRepresentative : String;
  PriorProcessingType, SmallClaimsProcessingType : Integer;
  Quit : Boolean;

begin
  UnitName := 'SmallClaimsCondoCopyDialogUnit';
  SwisSBLKeyList := TStringList.Create;

    {FXX10082003-1(2.07j1): Don't base the processing type of the current and prior on
                            the current grievance year, but the year of this grievance.}

  SmallClaimsProcessingType := GetProcessingTypeForTaxRollYear(SmallClaimsYear);
  PriorYear := IntToStr(StrToInt(SmallClaimsYear) - 1);
  PriorProcessingType := GetProcessingTypeForTaxRollYear(PriorYear);

  OpenTablesForForm(Self, SmallClaimsProcessingType);

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             SmallClaimsProcessingType, Quit);

  OpenTableForProcessingType(CurrentAssessmentTable, AssessmentTableName,
                             SmallClaimsProcessingType, Quit);

  OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                             PriorProcessingType, Quit);

  OpenTableForProcessingType(CurrentExemptionsTable, ExemptionsTableName,
                             SmallClaimsProcessingType, Quit);

  OpenTableForProcessingType(CurrentSpecialDistrictsTable, SpecialDistrictTableName,
                             SmallClaimsProcessingType, Quit);

  If (Trim(LawyerCode) = '')
    then TempRepresentative := LawyerCode
    else TempRepresentative := '';

  InformationLabel.Caption := 'Please enter the additional parcels that should have a small claims created ' +
                              'with Index # ' + IntToStr(IndexNumber);

  If (TempRepresentative = '')
    then InformationLabel.Caption := InformationLabel.Caption + '.'
    else InformationLabel.Caption := InformationLabel.Caption + ' and representative = ' +
                                     TempRepresentative;

end;  {FormShow}

{============================================================}
Procedure TSmallClaimsCondoCopyDialog.SetNumParcelsLabel(NumParcels : Integer);

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
Procedure TSmallClaimsCondoCopyDialog.AddOneParcel(SwisSBLKey : String);

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
Procedure TSmallClaimsCondoCopyDialog.ClearButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure that you want to clear all of the parcel IDs?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then ClearStringGrid(ParcelGrid);

  SetNumParcelsLabel(FindLastItem(ParcelGrid));

end;  {ClearButtonClick}

{===============================================================}
Procedure TSmallClaimsCondoCopyDialog.AddButtonClick(Sender: TObject);

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
Procedure TSmallClaimsCondoCopyDialog.DeleteButtonClick(Sender: TObject);

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
Procedure TSmallClaimsCondoCopyDialog.CreateOneSmallClaims(SwisSBLKey : String);

var
  SBLRec : SBLRecord;
  SmallClaimsExists, PriorAssessmentFound : Boolean;

begin
  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section',
                'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
               [SmallClaimsYear, SwisCode, Section,
                SubSection, Block, Lot, Sublot, Suffix]);

  FindKeyOld(SwisCodeTable, ['SwisCode'], [Copy(SwisSBLKey, 1, 6)]);

  FindKeyOld(CurrentAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
             [SmallClaimsYear, SwisSBLKey]);

  with SBLRec do
    PriorAssessmentFound := FindKeyOld(PriorAssessmentTable,
                                       ['TaxRollYr', 'SwisSBLKey'],
                                       [PriorYear, SwisSBLKey]);

  SetRangeOld(CurrentExemptionsTable, ['TaxRollYr', 'SwisSBLKey'],
              [SmallClaimsYear, SwisSBLKey], [SmallClaimsYear, SwisSBLKey]);

  SetRangeOld(CurrentSpecialDistrictsTable, ['TaxRollYr', 'SwisSBLKey'],
              [SmallClaimsYear, SwisSBLKey], [SmallClaimsYear, SwisSBLKey]);

  SetRangeOld(SmallClaimsExemptionsAskedLookupTable,
              ['TaxRollYr', 'SwisSBLKey', 'IndexNumber', 'ExemptionCode'],
              [SmallClaimsYear, OriginalSwisSBLKey, IntToStr(IndexNumber), '     '],
              [SmallClaimsYear, OriginalSwisSBLKey, IntToStr(IndexNumber), '99999']);

  FindKeyOld(SmallClaimsTable, ['TaxRollYr', 'SwisSBLKey', 'IndexNumber'],
             [SmallClaimsYear, OriginalSwisSBLKey, IntToStr(IndexNumber)]);

    {FXX01222004-1(2.07l1): Check to make sure that the small claims does not exist before copying it.}

  SmallClaimsExists := FindKeyOld(SmallClaimsTable, ['TaxRollYr', 'SwisSBLKey', 'IndexNumber'],
                                  [SmallClaimsYear, SwisSBLKey, IntToStr(IndexNumber)]);

  If SmallClaimsExists
    then MessageDlg('This small claims already exists on parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '.' + #13 +
                    'No new small claims was created on this parcel.' + #13 +
                    'Press OK to continue the copy.', mtWarning, [mbOK], 0)
    else
  with SmallClaimsLookupTable do
    try
      Append;
      FieldByName('TaxRollYr').Text := SmallClaimsYear;
      FieldByName('IndexNumber').AsInteger := IndexNumber;
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
        else SetPetitionerNameAndAddress(SmallClaimsLookupTable, LawyerCodeTable, LawyerCode);

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

      FieldByName('PetitReason').Text := SmallClaimsTable.FieldByName('PetitReason').Text;
      FieldByName('PetitSubreasonCode').Text := SmallClaimsTable.FieldByName('PetitSubreasonCode').Text;
      TMemoField(FieldByName('PetitSubreason')).Assign(TMemoField(SmallClaimsTable.FieldByName('PetitSubreason')));
      TMemoField(FieldByName('Notes')).Assign(TMemoField(SmallClaimsTable.FieldByName('Notes')));
      FieldByName('NumberOfParcels').AsInteger := SmallClaimsTable.FieldByName('NumberOfParcels').AsInteger;

      try
        If (FieldByName('NoticeOfPetition').AsDateTime > StrToDate('1/1/1950'))
          then FieldByName('NoticeOfPetition').AsDateTime := SmallClaimsTable.FieldByName('NoticeOfPetition').AsDateTime
          else FieldByName('NoticeOfPetition').Text := '';
      except
        FieldByName('NoticeOfPetition').Text := '';
      end;

      try
        If (FieldByName('NoteOfIssue').AsDateTime > StrToDate('1/1/1950'))
          then FieldByName('NoteOfIssue').AsDateTime := SmallClaimsTable.FieldByName('NoteOfIssue').AsDateTime
          else FieldByName('NoteOfIssue').Text := '';
      except
        FieldByName('NoteOfIssue').Text := '';
      end;

      FieldByName('ArticleType').Text := SmallClaimsTable.FieldByName('ArticleType').Text;

      FieldByName('SchoolCode').Text := ParcelTable.FieldByName('SchoolCode').Text;

      FieldByName('CurrentEqRate').AsFloat := SwisCodeTable.FieldByName('EqualizationRate').AsFloat;
      FieldByName('CurrentUniformPercent').AsFloat := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
      FieldByName('CurrentRAR').AsFloat := SwisCodeTable.FieldByName('ResAssmntRatio').AsFloat;

            {CHG07262004-1(2.08): Option to have attorney information seperate.}

          If GlblGrievanceSeperateRepresentativeInfo
            then
              try
                FieldByName('AttyName1').Text := SmallClaimsTable.FieldByName('AttyName1').Text;
                FieldByName('AttyName2').Text := SmallClaimsTable.FieldByName('AttyName2').Text;
                FieldByName('AttyAddress1').Text := SmallClaimsTable.FieldByName('AttyAddress1').Text;
                FieldByName('AttyAddress2').Text := SmallClaimsTable.FieldByName('AttyAddress2').Text;
                FieldByName('AttyStreet').Text := SmallClaimsTable.FieldByName('AttyStreet').Text;
                FieldByName('AttyCity').Text := SmallClaimsTable.FieldByName('AttyCity').Text;
                FieldByName('AttyState').Text := SmallClaimsTable.FieldByName('AttyState').Text;
                FieldByName('AttyZip').Text := SmallClaimsTable.FieldByName('AttyZip').Text;
                FieldByName('AttyZipPlus4').Text := SmallClaimsTable.FieldByName('AttyZipPlus4').Text;
                FieldByName('AttyPhoneNumber').Text := SmallClaimsTable.FieldByName('AttyPhoneNumber').Text;

              except
              end;

      Post;

      CopyTableRange(SmallClaimsExemptionsAskedLookupTable, SmallClaimsExemptionsAskedTable,
                     'TaxRollYr', ['SwisSBLKey'], [SwisSBLKey]);

      CopyTableRange(CurrentExemptionsTable, SmallClaimsExemptionsTable,
                     'TaxRollYr', ['IndexNumber'], [IntToStr(IndexNumber)]);

      CopyTableRange(CurrentSpecialDistrictsTable, SmallClaimsSpecialDistrictsTable,
                     'TaxRollYr', ['IndexNumber'], [IntToStr(IndexNumber)]);

    except
      SystemSupport(005, SmallClaimsTable,
                    'Error adding SmallClaims for parcel ' +
                    ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                    UnitName, GlblErrorDlgBox);

    end;

end;  {CreateOneSmallClaims}

{===============================================================}
Procedure TSmallClaimsCondoCopyDialog.OKButtonClick(Sender: TObject);

var
  Continue : Boolean;
  I : Integer;

begin
  Continue := True;

  If (SwisSBLKeyList.Count = 0)
    then
      begin
        MessageDlg('No parcels have been specified to create small claims for.',
                   mtError, [mbOK], 0);
        Continue := False
      end
    else
      begin
        ProgressDialog.UserLabelCaption := 'Copying small claims #' + IntToStr(IndexNumber);
        ProgressDialog.Start(SwisSBLKeyList.Count, True, True);

        For I := 0 to (SwisSBLKeyList.Count - 1) do
          begin
            ProgressDialog.Update(Self, SwisSBLKeyList[I]);
            Application.ProcessMessages;
            CreateOneSmallClaims(SwisSBLKeyList[I]);

          end;  {For I := 0 to (SwisSBLKeyList.Count - 1) do}

        ProgressDialog.Finish;

      end;  {else of If (SwisSBLKeyList.Count = 0)}

  If Continue
    then
      begin
        MessageDlg('The small claims has been copied to all of the specified parcels.',
                   mtInformation, [mbOK], 0);
        ModalResult := mrOK;
      end;

end;  {OKButtonClick}

{======================================================}
Procedure TSmallClaimsCondoCopyDialog.FormClose(    Sender: TObject;
                                        var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  SwisSBLKeyList.Free;
  Action := caFree;
end;

end.
