unit Frprtext;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, Types;

type
  TFreeportTaxExtractForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    ExtractTypeRadioGroup: TRadioGroup;
    Label1: TLabel;
    SaveDialog: TSaveDialog;
    TYParcelTable: TTable;
    NYParcelTable: TTable;
    AssessmentTable: TTable;
    EXCodeTable: TTable;
    ParcelExemptionTable: TTable;
    OptionsGroupBox: TGroupBox;
    ExtractMarkedParcelsCheckBox: TCheckBox;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    tbSmallClaims: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure ExtractTypeRadioGroupClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    Action : Integer;
    Cancelled,
    ExtractParcelsAlreadyIncludedInExtract : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Function RecMeetsCriteria(ParcelTable : TTable;
                              AssessmentTable : TTable;
                              tbSmallClaims : TTable) : Boolean;

    Procedure ExtractOneParcel(var ExtractFile : TextFile;
                                   SwisSBLKey : String;
                               var TotalAssessedValue,
                                   TotalTaxableValue : Comp;
                               var NumInactiveParcels,
                                   NumActiveParcels : Integer;
                                   bIncludeExemptions : Boolean);

    Procedure ExtractTaxes(var ExtractFile : TextFile;
                               FileName : String);

    Procedure ExtractAssessments(var ExtractFile : TextFile;
                                     FileName : String);

    Procedure ExtractNameAddrChanges(var ExtractFile : TextFile;
                                         FileName : String);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, UtilEXSD,
     PASTypes, Prog, DataAccessUnit;

{$R *.DFM}

const
  acTaxExtract = 0;
  acNameAddrUpdate = 1;
  acAssessmentUpdate = 2;

{========================================================}
procedure TFreeportTaxExtractForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TFreeportTaxExtractForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'FRPRTEXT';  {mmm}

  OpenTablesForForm(Self, ThisYear);

  OpenTableForProcessingType(NYParcelTable, ParcelTableName, NextYear, Quit);

end;  {InitializeForm}

{===================================================================}
Procedure TFreeportTaxExtractForm.ExtractTypeRadioGroupClick(Sender: TObject);

begin
  case ExtractTypeRadioGroup.ItemIndex of
    acTaxExtract : OptionsGroupBox.Visible := False;
    acNameAddrUpdate :
    begin
      OptionsGroupBox.Visible := True;
      ExtractMarkedParcelsCheckBox.Visible := True;
    end;

    acAssessmentUpdate :
    begin
      OptionsGroupBox.Visible := True;
      ExtractMarkedParcelsCheckBox.Visible := False;
    end;

  end;

end;  {ExtractTypeRadioGroupClick}

{===================================================================}
Function TFreeportTaxExtractForm.RecMeetsCriteria(ParcelTable : TTable;
                                                  AssessmentTable : TTable;
                                                  tbSmallClaims : TTable) : Boolean;

var
  TempDate : TDateTime;
  sSwisSBLKey, sSmallClaimsYear : String;
  myYear, myMonth, myDay : Word;

begin
  Result := True;
  sSwisSBLKey := ExtractSSKey(ParcelTable);

    {CHG03302000-1: Include the AV changes in the extract.}

  If (Action = acNameAddrUpdate)
    then
      begin
        TempDate := ParcelTable.FieldByName('DateChangedForExtract').AsDateTime;

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
            ParcelTable.FieldByName('ChangeExtracted').AsBoolean and
            (not ExtractParcelsAlreadyIncludedInExtract))
          then Result := False;

      end;  {If (Action = acNameAddrUpdate)}

    {Has an assessment record and a small claims.}

  If ((Action = acAssessmentUpdate) and
      _Locate(AssessmentTable, [glblThisYear, sSwisSBLKey], '', []))
    then
      begin
        TempDate := AssessmentTable.FieldByName('AssessmentDate').AsDateTime;

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

        If Result
        then
        begin
          TempDate := StrToDate(StartDateEdit.Text);
          DecodeDate(TempDate, myYear, myMonth, myDay);
          sSmallClaimsYear := IntToStr(myYear);

          Result := _Locate(tbSmallClaims, [sSmallClaimsYear, sSwisSBLKey], '', []);

        end;  {If Result}

      end;  {If (Action = acAssessmentUpdate)}

end;  {RecMeetsCriteria}

{==============================================================}
Procedure TFreeportTaxExtractForm.ExtractOneParcel(var ExtractFile : TextFile;
                                                       SwisSBLKey : String;
                                                   var TotalAssessedValue,
                                                       TotalTaxableValue : Comp;
                                                   var NumInactiveParcels,
                                                       NumActiveParcels : Integer;
                                                       bIncludeExemptions : Boolean);

var
  AssessedValue, TotalExemption : Comp;
  ExemptionCodes,
  ResidentialTypes,
  ExemptionHomesteadCodes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  TempTable : TTable;
  SBLRec : SBLRecord;
  TempStr : String;
  I : Integer;
  NYParcelFound : Boolean;

begin
  ExemptionCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
             [GlblThisYear, SwisSBLKey]);
  AssessedValue := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

  TotalExemptionsForParcel(GlblThisYear, SwisSBLKey,
                           ParcelExemptionTable,
                           EXCodeTable,
                           TYParcelTable.FieldByName('HomesteadCode').Text,
                           'A',
                           ExemptionCodes,
                           ExemptionHomesteadCodes,
                           ResidentialTypes,
                           CountyExemptionAmounts,
                           TownExemptionAmounts,
                           SchoolExemptionAmounts,
                           VillageExemptionAmounts,
                           BasicSTARAmount,
                           EnhancedSTARAmount);

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    NYParcelFound := FindKeyOld(NYParcelTable,
                                ['TaxRollYr', 'SwisCode', 'Section',
                                 'Subsection', 'Block', 'Lot',
                                 'Sublot', 'Suffix'],
                                [GlblNextYear, SwisCode, Section, Subsection,
                                 Block, Lot, Sublot, Suffix]);

    {If the parcel doesn't exist in NY, use the TY info.}

  If NYParcelFound
    then TempTable := NYParcelTable
    else TempTable := TYParcelTable;

  with TempTable do
    begin
      Write(ExtractFile, ShiftRightAddZeroes(Take(11, FieldByName('AccountNo').Text)));
      Write(ExtractFile, Take(30, FieldByName('Name1').Text));
      Write(ExtractFile, Take(30, FieldByName('Name2').Text));
      Write(ExtractFile, Take(30, FieldByName('Address1').Text));
      Write(ExtractFile, Take(30, FieldByName('Address2').Text));
(*              Write(ExtractFile, Take(30, FieldByName('Street').Text)); *)
      Write(ExtractFile, Take(30, Trim(FieldByName('City').Text) + ' ' +
                                  FieldByName('State').Text));
      Write(ExtractFile, Take(5, FieldByName('Zip').Text));
      Write(ExtractFile, Take(4, FieldByName('ZipPlus4').Text));
      Write(ExtractFile, Take(30, FieldByName('Name1').Text));

    end;  { with TempTable do}

  TotalExemption := 0;
  For I := 0 to (TownExemptionAmounts.Count - 1) do
    TotalExemption := TotalExemption + StrToInt(TownExemptionAmounts[I]);

  If (TYParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
    then
      begin
        TempStr := 'D';
        NumInactiveParcels := NumInactiveParcels + 1;
      end
    else
      begin
        TempStr := 'A';
        NumActiveParcels := NumActiveParcels + 1;
        TotalAssessedValue := TotalAssessedValue + AssessedValue;
        TotalTaxableValue := TotalTaxableValue +
                             (AssessedValue - TotalExemption);

      end;  {else of If (TYParcelTable.FieldByName('ActiveFlag') ...}

  Write(ExtractFile, Take(1, TempStr));
  Write(ExtractFile, Take(7, TempTable.FieldByName('BankCode').Text));

  Write(ExtractFile, FormatRPSNumericString(FloatToStr(AssessedValue),
                                            12, 0));
  Write(ExtractFile, FormatRPSNumericString(FloatToStr(AssessedValue),
                                            12, 0));
  Write(ExtractFile, FormatRPSNumericString(AssessmentTable.FieldByName('LandAssessedVal').Text,
                                            12, 0));
  Write(ExtractFile, FormatRPSNumericString(FloatToStr(AssessedValue),
                                            12, 0));

  Write(ExtractFile, FormatRPSNumericString(FloatToStr(TotalExemption),
                                            12, 0));

  Write(ExtractFile, Take(3, TYParcelTable.FieldByName('PropertyClassCode').Text));
  Write(ExtractFile, Take(1, TYParcelTable.FieldByName('RollSection').Text));
  Write(ExtractFile, Take(9, TYParcelTable.FieldByName('MortgageNumber').Text));
  Write(ExtractFile, Take(26, ExtractSSKey(TYParcelTable)));

  If not bIncludeExemptions
  then
  begin
    ExemptionCodes.Clear;
    TownExemptionAmounts.Clear;
  end;

  For I := 1 to 8 do
    If (I <= ExemptionCodes.Count)
      then
        begin
          Write(ExtractFile, Take(5, ExemptionCodes[I - 1]));
          Write(ExtractFile, FormatRPSNumericString(TownExemptionAmounts[I - 1],
                                                    12, 0));

        end
      else Write(ExtractFile, ConstStr(' ', 5),
                              ConstStr('0', 12));

  Writeln(ExtractFile);

  ExemptionCodes.Free;
  ResidentialTypes.Free;
  ExemptionHomesteadCodes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {ExtractOneParcel}

{==============================================================}
Procedure TFreeportTaxExtractForm.ExtractTaxes(var ExtractFile : TextFile;
                                                   FileName : String);

var
  FirstTimeThrough, Done : Boolean;
  SwisSBLKey : String;
  TotalAssessedValue, TotalTaxableValue : Comp;
  NumActiveParcels, NumInactiveParcels : Integer;

begin
  FirstTimeThrough := True;
  Done := False;
  Cancelled := False;
  ProgressDialog.Start(GetRecordCount(TYParcelTable), True, True);
  TYParcelTable.First;
  TotalAssessedValue := 0;
  TotalTaxableValue := 0;
  NumActiveParcels := 0;
  NumInactiveParcels := 0;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else TYParcelTable.Next;

    If TYParcelTable.EOF
      then Done := True;

    SwisSBLKey := ExtractSSKey(TYParcelTable);
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

    If not Done
      then ExtractOneParcel(ExtractFile, SwisSBLKey, TotalAssessedValue,
                            TotalTaxableValue, NumInactiveParcels, NumActiveParcels, True);

    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled);

  ProgressDialog.Finish;

  If Cancelled
    then MessageDlg('The extract was cancelled.' + #13 +
                    'Please do not compute the taxes from this file.',
                    mtError, [mbOK], 0)
    else MessageDlg('The extract ' + FileName + ' was successfully completed.' + #13 +
                    'Number of active parcels = ' + IntToStr(NumActiveParcels) + #13 +
                    'Number of inactive parcels = ' + IntToStr(NumInactiveParcels) + #13 +
                    'Assessed Value = ' + FormatFloat(CurrencyNormalDisplay,
                                                      TotalAssessedValue) +
                    '  Taxable Value = ' + FormatFloat(CurrencyNormalDisplay,
                                                       TotalTaxableValue),
                    mtInformation, [mbOK], 0);

end;  {ExtractTaxes}

{==============================================================}
Procedure TFreeportTaxExtractForm.ExtractAssessments(var ExtractFile : TextFile;
                                                         FileName : String);

var
  FirstTimeThrough, Done : Boolean;
  SwisSBLKey : String;
  TotalAssessedValue, TotalTaxableValue : Comp;
  NumActiveParcels, NumInactiveParcels : Integer;

begin
  FirstTimeThrough := True;
  Done := False;
  Cancelled := False;
  ProgressDialog.Start(GetRecordCount(TYParcelTable), True, True);
  TYParcelTable.First;
  TotalAssessedValue := 0;
  TotalTaxableValue := 0;
  NumActiveParcels := 0;
  NumInactiveParcels := 0;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else TYParcelTable.Next;

    If TYParcelTable.EOF
      then Done := True;

    SwisSBLKey := ExtractSSKey(TYParcelTable);
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

    SetRangeOld(ParcelExemptionTable,
                ['TaxRollYr', 'SwisSBLKey'],
                [glblThisYear, SwisSBLKey],
                [glblThisYear, SwisSBLKey]);

    If (_Compare(ParcelExemptionTable.RecordCount, 0, coEqual) and
        RecMeetsCriteria(TYParcelTable, AssessmentTable, tbSmallClaims) and
        (not Done))
      then ExtractOneParcel(ExtractFile, SwisSBLKey, TotalAssessedValue,
                            TotalTaxableValue, NumInactiveParcels, NumActiveParcels, True);

    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled);

  ProgressDialog.Finish;

  If Cancelled
    then MessageDlg('The extract was cancelled.' + #13 +
                    'Please do not compute the taxes from this file.',
                    mtError, [mbOK], 0)
    else MessageDlg('The Assessment Extract file was created succesfully.' + #13 +
                    'There were ' + IntToStr(NumActiveParcels) + ' parcels.' + #13 +
                    'The file is ' + FileName + '.', mtInformation,
                    [mbOK], 0);

  CloseFile(ExtractFile);

end;  {ExtractAssessments}


{===================================================================}
Procedure TFreeportTaxExtractForm.ExtractNameAddrChanges(var ExtractFile : TextFile;
                                                             FileName : String);

var
  TYParcelFound, FirstTimeThrough, Done : Boolean;
  TotalAssessedValue, TotalTaxableValue : Comp;
  SwisSBLKey : String;
  NumActiveParcels, NumInactiveParcels : Integer;
  SBLRec : SBLRecord;

begin
  ProgressDialog.Start(GetRecordCount(NYParcelTable), True, True);
  NYParcelTable.First;

  FirstTimeThrough := True;
  Done := False;
  TotalAssessedValue := 0;
  TotalTaxableValue := 0;
  NumActiveParcels := 0;
  NumInactiveParcels := 0;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else NYParcelTable.Next;

     If NYParcelTable.EOF
       then Done := True;

     If ((not Done) and
         RecMeetsCriteria(NYParcelTable, AssessmentTable, tbSmallClaims))
       then
         begin
           SwisSBLKey := ExtractSSKey(NYParcelTable);

           SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

           with SBLRec do
             TYParcelFound := FindKeyOld(TYParcelTable,
                                         ['TaxRollYr', 'SwisCode', 'Section',
                                          'Subsection', 'Block', 'Lot',
                                          'Sublot', 'Suffix'],
                                         [GlblThisYear, SwisCode, Section, Subsection,
                                          Block, Lot, Sublot, Suffix]);

           If TYParcelFound
             then ExtractOneParcel(ExtractFile, SwisSBLKey, TotalAssessedValue,
                                   TotalTaxableValue, NumInactiveParcels,
                                   NumActiveParcels, True);

           If (Action = acNameAddrUpdate)
             then
               with NYParcelTable do
                 try
                   Edit;
                   FieldByName('ChangeExtracted').AsBoolean := True;
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
    else MessageDlg('The monthly update file was created succesfully.' + #13 +
                    'There were ' + IntToStr(NumActiveParcels) + ' parcels.' + #13 +
                    'The file is ' + FileName + '.', mtInformation,
                    [mbOK], 0);

end;  {ExtractNameAddrChanges}

{==============================================================}
Procedure TFreeportTaxExtractForm.StartButtonClick(Sender: TObject);

var
  ExtractFile : TextFile;
  FileName, DefaultFileName, TempDate : String;

begin
  Action := ExtractTypeRadioGroup.ItemIndex;
  ExtractParcelsAlreadyIncludedInExtract := ExtractMarkedParcelsCheckBox.Checked;

  case Action of
    acTaxExtract : DefaultFileName := 'FRPRTTAX.TXT';

    acNameAddrUpdate :
      begin
        TempDate := MakeMMDDYY(Date);
        DefaultFileName := 'UPDT' + Take(4, TempDate) + '.TXT';
      end;

    acAssessmentUpdate :
      begin
        TempDate := MakeMMDDYY(Date);
        DefaultFileName := 'ASSMT_UPDT' + Take(4, TempDate) + '.TXT';
      end;

  end;  {case Action of}

  SaveDialog.FileName := DefaultFileName;
  SaveDialog.InitialDir := GlblExportDir;

  If SaveDialog.Execute
    then
      begin
        FileName := SaveDialog.FileName;

        AssignFile(ExtractFile, FileName);
        Rewrite(ExtractFile);

        case Action of
          acTaxExtract : ExtractTaxes(ExtractFile, FileName);
          acNameAddrUpdate : ExtractNameAddrChanges(ExtractFile, FileName);
          acAssessmentUpdate : ExtractAssessments(ExtractFile, FileName);
        end;

      end;  {If SaveDialog.Execute}

end;  {StartButtonClick}

{===================================================================}
Procedure TFreeportTaxExtractForm.FormClose(    Sender: TObject;
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