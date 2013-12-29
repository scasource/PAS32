unit Mtvrtxex;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

{FXX02171999-7: Store the name address information to see if it changed.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, (*Progress, *)Mask,
  Types;

type
  TMtVernonTaxExtractForm = class(TForm)
    ParcelTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ExemptionTable: TTable;
    SDTable: TTable;
    StartButton: TBitBtn;
    Label1: TLabel;
    SaveDialog: TSaveDialog;
    AssessmentTable: TTable;
    SalesTable: TTable;
    ExemptionCodeTable: TTable;
    NYParcelTable: TTable;
    OptionsNotebook: TNotebook;
    ExtractTypeRadioGroup: TRadioGroup;
    ActionRadioGroup: TRadioGroup;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    ExtractMarkedParcelsCheckBox: TCheckBox;
    SwisCodeListBox: TListBox;
    Label3: TLabel;
    SwisCodeTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure ActionRadioGroupClick(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    Cancelled : Boolean;
    Action, ExtractType : Integer;
    ExtractParcelsAlreadyIncludedInExtract : Boolean;
    SelectedSwisCodes : TStringList;

    Procedure InitializeForm;  {Open the tables and setup.}
    Function ValidSelectionInformation : Boolean;
    Function RecMeetsCriteria(ParcelTable : TTable) : Boolean;
    Procedure ExtractOneParcel(var ExtractFile : TextFile;
                                   SwisSBLKey : String;
                               var TotalAssessedValue,
                                   TotalTaxableValue : Comp);
    Procedure ExtractTaxes(var ExtractFile : TextFile;
                               FileName : String);
    Procedure ExtractNameAddrChanges(var ExtractFile : TextFile;
                                         FileName : String);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, UtilEXSD,
     Prog,
     PASTypes;

{$R *.DFM}

const
  etCounty = 0;
  etCity = 1;
  etSchool = 2;

  acTaxExtract = 0;
  acNameAddrUpdate = 1;

  MaximumNumberOfExemptions = 8;
  
{========================================================}
Procedure TMtVernonTaxExtractForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'MTVRTXEX';  {mmm}

  OpenTablesForForm(Self, ThisYear);

  OpenTableForProcessingType(NYParcelTable, ParcelTableName, NextYear, Quit);

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, ThisYear, GlblThisYear);

end;  {InitializeForm}

{================================================================}
Procedure TMtVernonTaxExtractForm.ActionRadioGroupClick(Sender: TObject);

begin
  OptionsNotebook.Visible := True;

  If (ActionRadioGroup.ItemIndex = acTaxExtract)
    then OptionsNotebook.PageIndex := 0
    else OptionsNotebook.PageIndex := 1;

end;  {ActionRadioGroupClick}

{======================================================================}
Procedure TMtVernonTaxExtractForm.AllDatesCheckBoxClick(Sender: TObject);

begin
 If AllDatesCheckBox.Checked
    then
      begin
        ToEndofDatesCheckBox.Checked := False;
        ToEndofDatesCheckBox.Enabled := False;
        StartDateEdit.Text := '';
        StartDateEdit.Enabled := False;
        StartDateEdit.Color := clBtnFace;
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(DateGroupBox);

end;  {AllDatesCheckBoxClick}

{===================================================================}
Function TMtVernonTaxExtractForm.ValidSelectionInformation : Boolean;

begin
  Result := True;
  Action := ActionRadioGroup.ItemIndex;
  ExtractType := ExtractTypeRadioGroup.ItemIndex;

  If ((Action = acTaxExtract) and
      (ExtractType = -1))
    then
      begin
        Result := False;
        MessageDlg('Please select which tax extract to run - city, county, or school.',
                   mtError, [mbOK], 0);
      end;

  If (Action = acNameAddrUpdate)
    then
      If ((StartDateEdit.Text <> '  /  /    ') or
           (EndDateEdit.Text <> '  /  /    ') or
           AllDatesCheckBox.Checked or
           ToEndofDatesCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofDatesCheckBox.Checked or
                 (EndDateEdit.Text <> '  /  /    ')) and
                (StartDateEdit.Text = '  /  /    '))
              then
                begin
                  MessageDlg('Please select a starting date or chose all dates.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((StartDateEdit.Text <> '  /  /    ') and
                ((EndDateEdit.Text = '  /  /    ') and
                 (not ToEndofDatesCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending date or chose to print to the end of the dates on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllDatesCheckBox.Checked := True;

  ExtractParcelsAlreadyIncludedInExtract := ExtractMarkedParcelsCheckBox.Checked;

end;  {ValidSelectionInformation}

{===================================================================}
Procedure TMtVernonTaxExtractForm.ExtractOneParcel(var ExtractFile : TextFile;
                                                       SwisSBLKey : String;
                                                   var TotalAssessedValue,
                                                       TotalTaxableValue : Comp);

{CHG12072004-1(2.8.1.2): Expand the maximum number of exemptions to 8.}

var
  I, Index : Integer;
  ExemptionCodeArray : Array[1..MaximumNumberOfExemptions] of String;
  ExemptionValues : Array[1..MaximumNumberOfExemptions] of Comp;
  Amount, TempStr : String;
  ExemptionTotArray : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  TotalExemptions, AssessedValue, TaxableValue,
  TempNum, BasicSTARAmount, EnhancedSTARAmount : Comp;
  TempParcelTable : TTable;
  SBLRec : SBLRecord;
  Found : Boolean;

begin
  TotalExemptions := 0;

    {FXX12071998-1: Use the next year name, addr, and bank code if it exists.}

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    Found := FindKeyOld(NYParcelTable,
                        ['TaxRollYr', 'SwisCode', 'Section',
                         'Subsection', 'Block', 'Lot',
                         'Sublot', 'Suffix'],
                        [GlblNextYear, SwisCode, Section, Subsection,
                         Block, Lot, Sublot, Suffix]);

  If Found
    then TempParcelTable := NYParcelTable
    else TempParcelTable := ParcelTable;

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section',
                'Subsection', 'Block', 'Lot',
                'Sublot', 'Suffix'],
               [GlblThisYear, SwisCode, Section, Subsection,
                Block, Lot, Sublot, Suffix]);

  FindKeyOld(AssessmentTable,
             ['TaxRollYr', 'SwisSBLKey'],
             [GlblThisYear, SwisSBLKey]);

  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  ExemptionTotArray := TotalExemptionsForParcel(GlblThisYear, SwisSBLKey,
                                                ExemptionTable,
                                                ExemptionCodeTable,
                                                ParcelTable.FieldByName('HomesteadCode').Text,
                                                'A', ExemptionCodes,
                                                ExemptionHomesteadCodes,
                                                ResidentialTypes,
                                                CountyExemptionAmounts,
                                                TownExemptionAmounts,
                                                SchoolExemptionAmounts,
                                                VillageExemptionAmounts,
                                                BasicSTARAmount,
                                                EnhancedSTARAmount);

    {Fill in the applicable exemptions and amounts.}

  For I := 1 to MaximumNumberOfExemptions do
    begin
      ExemptionCodeArray[I] := '';
      ExemptionValues[I] := 0;
    end;

  Index := 1;

    {FXX06251999-1: Include STAR amounts.}

  If (Roundoff(BasicSTARAmount, 0) > 0)
    then
      begin
        ExemptionCodeArray[Index] := BasicSTARExemptionCode;
        ExemptionValues[Index] := BasicSTARAmount;
        Index := Index + 1;
      end;  {If (Roundoff(BasicSTARAmount, 0) > 0)}

  If (Roundoff(EnhancedSTARAmount, 0) > 0)
    then
      begin
        ExemptionCodeArray[Index] := EnhancedSTARExemptionCode;
        ExemptionValues[Index] := EnhancedSTARAmount;
        Index := Index + 1;
      end;  {If (Roundoff(EnhancedSTARAmount, 0) > 0)}

    {FXX03241999-2: Show all exemptions for a parcel.}
    {FXX06141999-3: Sum the exemptions only for the applicable tax type
                    for total taxable value.}

  For I := 0 to (ExemptionCodes.Count - 1) do
    begin
      case ExtractType of
        etSchool :
          If (StrToFloat(SchoolExemptionAmounts[I]) > 0)
            then
              begin
                Amount := SchoolExemptionAmounts[I];
                TotalExemptions := TotalExemptions + StrToFloat(Amount);
              end
            else
              If (StrToFloat(TownExemptionAmounts[I]) > 0)
                then Amount := TownExemptionAmounts[I]
                else Amount := CountyExemptionAmounts[I];

        etCity :
          If (StrToFloat(TownExemptionAmounts[I]) > 0)
            then
              begin
                Amount := TownExemptionAmounts[I];
                TotalExemptions := TotalExemptions + StrToFloat(Amount);
              end
            else
              If (StrToFloat(CountyExemptionAmounts[I]) > 0)
                then Amount := CountyExemptionAmounts[I]
                else Amount := SchoolExemptionAmounts[I];

        etCounty :
          If (StrToFloat(CountyExemptionAmounts[I]) > 0)
            then
              begin
                Amount := CountyExemptionAmounts[I];
                TotalExemptions := TotalExemptions + StrToFloat(Amount);
              end
            else
              If (StrToFloat(TownExemptionAmounts[I]) > 0)
                then Amount := TownExemptionAmounts[I]
                else Amount := SchoolExemptionAmounts[I];

      end;  {case ExtractType of}

        {CHG12072004-1(2.8.1.2): Expand the maximum number of exemptions to 8.}

      If (Index > MaximumNumberOfExemptions)
        then
          begin
            MessageDlg('The tax extract only allows for ' + IntToStr(MaximumNumberOfExemptions) +
                       ' exemptions on a parcel and this parcels has more.' + #13 +
                       'The following exemption will not be included in the extract:' + #13 +
                       ExemptionCodes[I] + ' in the amount of $' +
                       Amount + ' on parcel ' +
                       ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                       mtWarning, [mbOK], 0);
          end
        else
          begin
            ExemptionCodeArray[Index] := ExemptionCodes[I];
            ExemptionValues[Index] := StrToFloat(Amount);
          end;

      Index := Index + 1;

    end;  {For I := 0 to (ExemptionCodes.Count - 1) do}

  with ParcelTable do
    begin
      Write(ExtractFile, Take(4, FieldByName('Block').Text));
      Write(ExtractFile, Take(3, FieldByName('Lot').Text));

        {FXX12141998-1: This field, though called suffix in the extract layout is
                        actually the sublot.}

      Write(ExtractFile, ShiftRightAddZeroes(Take(3, DezeroOnLeft(FieldByName('Sublot').Text))));
      Write(ExtractFile, Take(4, FieldByName('LegalAddrNo').Text));
      Write(ExtractFile, Take(20, FieldByName('LegalAddr').Text));

        {FXX12071998-1: Use the next year name, addr, and bank code if it exists.}

      Write(ExtractFile, Take(24, TempParcelTable.FieldByName('Name1').Text));

      Write(ExtractFile, Take(6, FieldByName('AccountNo').Text));
      Write(ExtractFile, Take(1, FieldByName('RollSection').Text));

        {Fill in the exemptions.}
        {FXX04271999-1: Make room for a 5th slot.}

      For I := 1 to MaximumNumberOfExemptions do
        Write(ExtractFile, Take(5, ExemptionCodeArray[I]));

        {Refuse code. - N/A}

      Write(ExtractFile, Take(1, '0'));

        {Area}
        {FXX04271999-2: Print acreage.}
        {FXX05161999-2: Switch back to square feet.}

      TempNum := GetSquareFeet(FieldByName('Acreage').AsFloat, FieldByName('Frontage').AsFloat,
                          FieldByName('Depth').AsFloat);
      Write(ExtractFile, FormatRPSNumericString(FloatToStr(TempNum), 7, 0));

      Write(ExtractFile, Take(3, FieldByName('PropertyClassCode').Text));
      Write(ExtractFile, Take(1, FieldByName('OwnershipCode').Text));

        {Sewer district - N/A}

      Write(ExtractFile, Take(1, '0'));

        {FXX12071998-1: Use the next year name, addr, and bank code if it exists.}
        {CHG12282001-1: Expand the bank code to 2 characters.}

      Write(ExtractFile, Take(3, TempParcelTable.FieldByName('BankCode').Text));
      Write(ExtractFile, Take(6, FieldByName('DeedBook').Text));
      Write(ExtractFile, Take(5, FieldByName('DeedPage').Text));

        {FXX02051999-1: If the addr 1 is not blank, use addr 1 and 2. Otherwise,
                        use name 1 and 2.}
        {FXX04271999-3: Use regular fields - no longer test to see whether
                        this is a bank address.}
        {FXX06101999-3: Switch back to this method.}

      If ((Deblank(TempParcelTable.FieldByName('Address1').Text) = '') and
          (Deblank(TempParcelTable.FieldByName('Address2').Text) = ''))
        then
          begin
            Write(ExtractFile, Take(26, TempParcelTable.FieldByName('Name1').Text));
            Write(ExtractFile, Take(26, TempParcelTable.FieldByName('Name2').Text));
          end
        else
          begin
            Write(ExtractFile, Take(26, TempParcelTable.FieldByName('Address1').Text));
            Write(ExtractFile, Take(26, TempParcelTable.FieldByName('Address2').Text));
          end;

      Write(ExtractFile, Take(26, TempParcelTable.FieldByName('Street').Text));

(*      Write(ExtractFile, Take(26, TempParcelTable.FieldByName('Name1').Text));
      Write(ExtractFile, Take(26, TempParcelTable.FieldByName('Name2').Text));
      Write(ExtractFile, Take(26, TempParcelTable.FieldByName('Address1').Text)); *)

      Write(ExtractFile, Take(16, TempParcelTable.FieldByName('City').Text));
      Write(ExtractFile, Take(2, TempParcelTable.FieldByName('State').Text));

      TempStr := TempParcelTable.FieldByName('Zip').Text;

      If (Deblank(TempParcelTable.FieldByName('ZipPlus4').Text) <> '')
        then TempStr := TempStr + '-' + TempParcelTable.FieldByName('ZipPlus4').Text;

      Write(ExtractFile, Take(10, TempStr));
      Write(ExtractFile, Take(26, TempParcelTable.FieldByName('Street').Text));  {Put street name in additional street #}

        {Fill in the exemption values.}
        {FXX04271999-1: Make room for a 5th slot.}

      For I := 1 to MaximumNumberOfExemptions do
        Write(ExtractFile, FormatRPSNumericString(FloatToStr(ExemptionValues[I]), 12, 0));

    end;  {with ParcelTable do}

  with AssessmentTable do
    begin
      Write(ExtractFile, FormatRPSNumericString(FieldByName('LandAssessedVal').Text, 12, 0));
      TempNum := FieldByName('TotalAssessedVal').AsFloat - FieldByName('LandAssessedVal').AsFloat;
      Write(ExtractFile, FormatRPSNumericString(FloatToStr(TempNum), 12, 0));

    end;  {with AssessmentTable do}

  Write(ExtractFile, Take(32, ParcelTable.FieldByName('PropDescr1').Text));

    {Blanks for dates.}

  For I := 1 to 10 do
    Write(ExtractFile, Take(9, ''));

    {Blanks for the taxable values.}

  For I := 1 to 5 do
    Write(ExtractFile, ShiftRightAddZeroes(Take(12, '')));

    {Blanks for the tax amounts.}

  For I := 1 to 5 do
    Write(ExtractFile, ShiftRightAddZeroes(Take(9, '')));

  SetRangeOld(SalesTable, ['SwisSBLKey'],
              [SwisSBLKey], [SwisSBLKey]);
  SalesTable.Last;

  with SalesTable do
    begin
      Write(ExtractFile, FormatRPSNumericString(FieldByName('SalePrice').Text, 12, 0));

      TempStr := MakeMMDDYYYYFromDateTime(FieldByName('SaleDate').AsDateTime);
      If (Deblank(TempStr) = '')
        then TempStr := '00000';  {For consistency with PAS v1.}

      Write(ExtractFile, Take(9, TempStr));

    end;  {with SalesTable do}

    {Blank for exemption flag and litigation}

  For I := 1 to 2 do
    Write(ExtractFile, Take(5, ''));

    {Blank for housing units.}

  For I := 1 to 4 do
    Write(ExtractFile, Take(3, ''));

  with ParcelTable do
    begin
      Write(ExtractFile, Take(9, MakeMMDDYYYYFromDateTime(FieldByName('LastChangeDate').AsDateTime)));
      Write(ExtractFile, Take(3, FieldByName('Section').Text));
      Write(ExtractFile, Take(3, FieldByName('Subsection').Text));

      TempStr := MakeMMDDYYYYFromDateTime(SalesTable.FieldByName('DeedDate').AsDateTime);

      If (Deblank(TempStr) = '')
        then Write(ExtractFile, Take(6, '0000'))  {For consistency with PAS v1.}
        else Write(ExtractFile, Copy(TempStr, 1, 4) + Copy(TempStr, 7, 2));
      Write(ExtractFile, ShiftRightAddZeroes(Take(6, FieldByName('GridCordEast').Text)));
      Write(ExtractFile, ShiftRightAddZeroes(Take(6, FieldByName('GridCordNorth').Text)));

        {FXX12031998-5: Zero fill this field.}

      Writeln(ExtractFile, ShiftRightAddZeroes(Take(7, '')));

    end;  {with ParcelTable do}

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

    {FXX12101998-1: Display the taxable and assessed values extracted.}

  AssessedValue := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

    {FXX06141999-3: Sum the exemptions only for the applicable tax type
                    for total taxable value.}

(*  TotalExemptions := 0;

  For I := 1 to 4 do
    TotalExemptions := TotalExemptions + ExemptionValues[I]; *)

  TaxableValue := AssessedValue - TotalExemptions;

  TotalAssessedValue := TotalAssessedValue + AssessedValue;
  TotalTaxableValue := TotalTaxableValue + TaxableValue;

end;  {ExtractOneParcel}

{===================================================================}
Function TMtVernonTaxExtractForm.RecMeetsCriteria(ParcelTable : TTable) : Boolean;

var
  TempDate : TDateTime;

begin
  Result := True;

  If (Action = acNameAddrUpdate)
    then
      begin
        TempDate := ParcelTable.FieldByName('DateAddressChanged').AsDateTime;

          {Now see if they are in the date range (if any) specified.}

        If AllDatesCheckBox.Checked
          then
            begin
              If (TempDate = 0)
                then Result := False;
            end
          else
            begin
              If (TempDate < StrToDate(StartDateEdit.Text))
                then Result := False;

              If ((not ToEndOfDatesCheckBox.Checked) and
                  (TempDate > StrToDate(EndDateEdit.Text)))
                then Result := False;

            end;  {else of If AllDatesCheckBox.Checked}

          {Now see if it was already extracted.}

        If (Result and
            ParcelTable.FieldByName('AddressExtracted').AsBoolean and
            (not ExtractParcelsAlreadyIncludedInExtract))
          then Result := False;

      end;  {If (Action = acNameAddrUpdate)}

    {FXX11081999-1: Don't report inactive parcels.}

  If (Result and
      (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag))
    then Result := False;

    {CHG09042000-1: Allow them to select which swis code to extract for.}

  If (Result and
      (SelectedSwisCodes.IndexOf(ParcelTable.FieldByName('SwisCode').Text) = -1))
    then Result := False;

end;  {RecMeetsCriteria}

{===================================================================}
Procedure TMtVernonTaxExtractForm.ExtractTaxes(var ExtractFile : TextFile;
                                                   FileName : String);

var
  FirstTimeThrough, Done : Boolean;
  TotalAssessedValue, TotalTaxableValue : Comp;
  NumParcels : LongInt;
  SwisSBLKey : String;

begin
  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
  ParcelTable.First;

  FirstTimeThrough := True;
  Done := False;
  NumParcels := 0;
  TotalAssessedValue := 0;
  TotalTaxableValue := 0;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

     If ParcelTable.EOF
       then Done := True;

     If ((not Done) and
         RecMeetsCriteria(ParcelTable))
       then
         begin
           SwisSBLKey := ExtractSSKey(ParcelTable);
           ExtractOneParcel(ExtractFile, SwisSBLKey, TotalAssessedValue,
                            TotalTaxableValue);
           NumParcels := NumParcels + 1;

         end;

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));
    Application.ProcessMessages;
    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled);

  CloseFile(ExtractFile);

  ProgressDialog.Finish;

  If Cancelled
    then MessageDlg('The extract file was cancelled.', mtWarning, [mbOK], 0)
    else MessageDlg('The extract file was created succesfully and has ' +
                    IntToStr(NumParcels) + ' parcels.' + #13 +
                    'Assessed Value = ' + FormatFloat(CurrencyNormalDisplay, TotalAssessedValue) + #13 +
                    'Taxable Value = ' + FormatFloat(CurrencyNormalDisplay, TotalTaxableValue) + #13 +
                    'The file is ' + FileName + '.', mtInformation,
                    [mbOK], 0)

end;  {ExtractTaxes}

{===================================================================}
Procedure TMtVernonTaxExtractForm.ExtractNameAddrChanges(var ExtractFile : TextFile;
                                                             FileName : String);

var
  FirstTimeThrough, Done : Boolean;
  TotalAssessedValue, TotalTaxableValue : Comp;
  NumParcels : LongInt;
  SwisSBLKey : String;

begin
  ProgressDialog.Start(GetRecordCount(NYParcelTable), True, True);
  NYParcelTable.First;

  FirstTimeThrough := True;
  Done := False;
  NumParcels := 0;
  TotalAssessedValue := 0;
  TotalTaxableValue := 0;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else NYParcelTable.Next;

     If NYParcelTable.EOF
       then Done := True;

     If ((not Done) and
         RecMeetsCriteria(NYParcelTable))
       then
         begin
           SwisSBLKey := ExtractSSKey(NYParcelTable);
           ExtractOneParcel(ExtractFile, SwisSBLKey, TotalAssessedValue,
                            TotalTaxableValue);
           NumParcels := NumParcels + 1;

           If (Action = acNameAddrUpdate)
             then
               with NYParcelTable do
                 try
                   Edit;
                   FieldByName('AddressExtracted').AsBoolean := True;
                   Post;
                 except
                   SystemSupport(015, NYParcelTable, 'Error marking parcel extracted.',
                                 UnitName, GlblErrorDlgBox);
                 end;

         end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(NYParcelTable)));
    Application.ProcessMessages;
    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled);

  CloseFile(ExtractFile);
  ProgressDialog.Finish;

  If Cancelled
    then MessageDlg('The extract file was cancelled.', mtWarning, [mbOK], 0)
    else MessageDlg('The name \ address\ bank code update file was created succesfully.' + #13 +
                    'There were ' + IntToStr(NumParcels) + ' parcels.' + #13 +
                    'The file is ' + FileName + '.', mtInformation,
                    [mbOK], 0)

end;  {ExtractNameAddrChanges}

{===================================================================}
Procedure TMtVernonTaxExtractForm.StartButtonClick(Sender: TObject);

var
  ExtractFile : TextFile;
  FileName, DefaultFileName, TempDate : String;
  I : Integer;

begin
  Cancelled := False;

  If ValidSelectionInformation
    then
      begin
         {CHG09042000-1: Allow them to select which swis code to extract for.}

        SelectedSwisCodes := TStringList.Create;

        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        If (Action = acTaxExtract)
          then
            begin
              case ExtractType of
                etCity : DefaultFileName := 'CITYTAX.TXT';
                etCounty : DefaultFileName := 'CNTYTAX.TXT';
                etSchool : DefaultFileName := 'SCHLTAX.TXT';
              end;
            end
          else
            begin
              TempDate := MakeMMDDYY(Date);
              DefaultFileName := 'UPDT' + Take(4, TempDate) + '.TXT';

                {FXX05141999-1: The name\addr update needs an extract type.}

              ExtractType := etCity;

            end;  {else of If (Action = acTaxExtract)}

        SaveDialog.FileName := DefaultFileName;
        SaveDialog.InitialDir := GlblExportDir;

        If SaveDialog.Execute
          then
            begin
              FileName := SaveDialog.FileName;

              AssignFile(ExtractFile, FileName);
              Rewrite(ExtractFile);

              If (Action = acTaxExtract)
                then ExtractTaxes(ExtractFile, FileName)
                else ExtractNameAddrChanges(ExtractFile, FileName);

            end;  {If SaveDialog.Execute}

        SelectedSwisCodes.Free;

      end;  {If ValidSelectionInformation}

end;  {StartButtonClick}

{===================================================================}
Procedure TMtVernonTaxExtractForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.