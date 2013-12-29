unit Utotexmp;

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
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, BtrvDlg;

type
  TTotalExemptionsTestForm = class(TForm)
    ParcelTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    StartButton: TBitBtn;
    Label1: TLabel;
    ParcelLabel: TLabel;
    Label3: TLabel;
    NumErrorsLabel: TLabel;
    CancelButton: TBitBtn;
    Timer1: TTimer;
    SwisCodeTable: TTable;
    AssessmentTable: TTable;
    ParcelExemptionTable: TTable;
    ExemptionCodeTable: TTable;
    ClassTable: TTable;
    ParcelExLookupTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    NumErrors,
    NumParcels : LongInt;
    ErrorFile : TextFile;

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  PASTypes;

{$R *.DFM}

{========================================================}
Procedure TTotalExemptionsTestForm.InitializeForm;

begin
  UnitName := 'UTotExmp.PAS';  {mmm}

  NumErrors := 0;
  NumParcels := 0;

  OpenTablesForFOrm(Self, GlblProcessingType);

  AssignFile(ErrorFile, GlblErrorFileDir + 'EXERROR.TXT');
  Rewrite(ErrorFile);

end;  {InitializeForm}

{=======================================================================}
Procedure TTotalExemptionsTestForm.StartButtonClick(Sender: TObject);

begin
  ParcelTable.First;
  Timer1.Enabled := True;
end;

{=====================================================================}
Procedure TTotalExemptionsTestForm.CancelButtonClick(Sender: TObject);

begin
  Timer1.Enabled := False;
end;

{===================================================================}
Procedure TTotalExemptionsTestForm.Timer1Timer(Sender: TObject);

{Go through all the exemptions for this parcel and verify.}

var
  Done, Quit, FirstTimeThrough,
  VetMaxSet, VetEqualizationRateFilledIn : Boolean;
  SwisSBLKey, TempStr : String;
  FixedPercent, Amount : Comp;
  EXAmountsArray : ExemptionTotalsArrayType;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);
  NumParcels := NumParcels + 1;
  ParcelLabel.Caption := '(' + IntToStr(NumParcels) + ') ' + SwisSBLKey;

  ParcelExemptionTable.CancelRange;
  ParcelExemptionTable.SetRange([ParcelTable.FieldByName('TaxRollYr').Text,
                                 SwisSBLKey, '     '],
                                [ParcelTable.FieldByName('TaxRollYr').Text,
                                 SwisSBLKey, 'ZZZZZ']);

  Done := False;
  Quit := False;
  FirstTimeThrough := True;

  try
    ParcelExemptionTable.First;
  except
    If (GetBtrieveError(ParcelExemptionTable) = BRC_EndOfFile)
      then Done := True
      else
        begin
          Quit := True;
          SystemSupport(900, ParcelExemptionTable, 'Error getting exemption record.',
                        'PASUTILS.PAS', GlblErrorDlgBox);
        end;

  end;  {try}

  If not (Done or Quit)
    then
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else
            try
              ParcelExemptionTable.Next;
            except
              If (GetBtrieveError(ParcelExemptionTable) = BRC_EndOfFile)
                then Done := True
                else
                  begin
                    Quit := True;
                    SystemSupport(900, ParcelExemptionTable, 'Error getting next exemption record.',
                                  'PASUTILS.PAS', GlblErrorDlgBox);
                  end;

            end;

          {If the SBL changes or we are at the end of the range, we are done.}

        TempStr := ParcelExemptionTable.FieldByName('SwisSBLKey').Text;

        If (ParcelExemptionTable.EOF or
            (Take(26, ParcelExemptionTable.FieldByName('SwisSBLKey').Text) <>
             Take(26, SwisSBLKey)))
          then Done := True;

          {We have an exemption record, so calculate the exemption amount for this
           record and compare it to what RPS has. If they are different, then
           write a message to the error log.}

        If not (Done or Quit)
          then
            begin
              ExemptionCodeTable.FindKey([ParcelExemptionTable.FieldByName('ExemptionCode').Text]);

              EXAmountsArray := CalculateExemptionAmount(ExemptionCodeTable,
                                                 ParcelExemptionTable,
                                                 ParcelExLookupTable,
                                                 AssessmentTable,
                                                 ClassTable,
                                                 SwisCodeTable,
                                                 ParcelTable,
                                                 GetTaxRlYr,
                                                 ParcelExemptionTable.FieldByName('SwisSBLKey').Text,
                                                 FixedPercent,
                                                 VetMaxSet,
                                                 VetEqualizationRateFilledIn);

                {Only use the exemption amount for this municipality.}

              Amount := EXAmountsArray[GetMunicipalityType(GlblMunicipalityType)];

              If (Roundoff(Amount, 0) <>
                  Roundoff(TCurrencyField(ParcelExemptionTable.FieldByName('TownAmount')).Value, 0))
                then
                  begin
                    NumErrors := NumErrors + 1;
                    NumErrorsLabel.Caption := IntToStr(NumErrors);

                    Writeln(ErrorFile, 'Parcel = ' + SwisSBLKey +
                                       '  Exemption Code = ' + ParcelExemptionTable.FieldByName('ExemptionCode').Text +
                                       '  PAS Amount ' + FloatToStr(Amount) +
                                       '  RPS Amount ' +
                                       FloatToStr(TCurrencyField(ParcelExemptionTable.FieldByName('Amount')).Value));
                  end;

            end;  {If not (Done or Quit)}

      until (Done or Quit);

  ParcelTable.Next;

  If ParcelTable.EOF
    then Timer1.Enabled := False;

end;  {Timer1Timer}

{===================================================================}
Procedure TTotalExemptionsTestForm.FormClose(    Sender: TObject;
                                             var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

  CloseFile(ErrorFile);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}



end.
