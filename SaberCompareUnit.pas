unit SaberCompareUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBTables, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    StartButton: TBitBtn;
    CancelButton: TBitBtn;
    ParcelTable: TTable;
    ResidentialBuildingTable: TTable;
    ResidentialImprovementTable: TTable;
    SaberParcelTable: TTable;
    SaberResidentialBuildingTable: TTable;
    SaberResidentialImprovementTable: TTable;
    Label9: TLabel;
    SwisCodeListBox: TListBox;
    ProgressBar: TProgressBar;
    SwisCodeTable: TTable;
    InitializationTimer: TTimer;
    SystemTable: TTable;
    AssessmentYearControlTable: TTable;
    BuildingStyleCodeTable: TTable;
    procedure FormCreate(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure InitializationTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Cancelled : Boolean;

    Procedure InitializeForm;
    Procedure GetDifferencesThisParcel(DifferencesThisParcel : TList);
    Procedure PrintThisParcel(var ExtractFile : TextFile;
                                  SwisSBLKey : String;
                                  Owner : String;
                                  Location : String;
                                  DifferencesThisParcel : TList);
  end;

  DifferenceRecord = record
    DifferenceField : Integer;
    PASValue : String;
    SaberValue : String;
  end;

  DifferencePointer = ^DifferenceRecord;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses GlblVars, GlblCnst, Winutils, Utilitys, PASUtils, Types, PASTypes;

const
  dfParcelExists = 0;
  dfBathrooms = 1;
  dfFireplaces = 2;
  dfKitchens = 3;
  dfStories = 4;
  dfSFLA = 5;
  dfHalfStory = 6;
  dfFirstFloor = 7;
  dfSecondFloor = 8;
  dfThirdFloor = 9;
  dfBuildingStyle = 10;
  dfGarageType = 11;
  dfFinishedAttic = 12;
  dfFinishedBasement = 13;
  dfFinishedRecRoom = 14;
  dfFinishedOverGarage = 15;
  dfPorchType = 16;
  dfPorchSquareFeet = 17;
  dfInGroundPool = 18;
  dfAcreage = 19;
  dfPropertyClass = 20;

  DecimalEditDisplay = '0.00';

{=============================================}
Procedure TForm1.FormCreate(Sender: TObject);

begin
  InitializationTimer.Enabled := True;
end;

{=============================================}
Procedure TForm1.InitializationTimerTimer(Sender: TObject);

begin
  InitializationTimer.Enabled := False;
  InitializeForm;
end;

{=============================================}
Procedure TForm1.InitializeForm;

begin
  ParcelTable.Open;
  ResidentialBuildingTable.Open;
  ResidentialImprovementTable.Open;
  SaberParcelTable.Open;
  SaberResidentialBuildingTable.Open;
  SaberResidentialImprovementTable.Open;
  SystemTable.Open;
  SwisCodeTable.Open;
  AssessmentYearControlTable.Open;
  BuildingStyleCodeTable.Open;

  SetGlobalSystemVariables(SystemTable);
  SetGlobalSBLSegmentFormats(AssessmentYearControlTable);

  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName', 20,
                 True, True, ThisYear, GlblThisYear);

end;  {InitializeForm}

{===========================================}
Function Power10(Places : Byte):Double;
  {DS: Raise 10 to the indicated power (limited to 0,1,2,3,4,or 5) }

Var
  Res : Double;

begin
  Res := 0;
  {ensure argument is in range...}
  If Places > 5 then Places := 5;

  Case Places of
  0: Res := 1.0;
  1: Res := 10.0;
  2: Res := 100.0;
  3: Res := 1000.0;
  4: Res := 10000.0;
  5: Res := 100000.0;
  end; {case}

  Power10 := Res;
end;  { function Power10}

{==================================================================}
Function Roundoff(Number : Extended;
                  NumPlaces : Integer) : Extended;

var
  I, FirstPlaceAfterDecimalPos, Pos,
  DeterminingDigit, DigitInt, ReturnCode : Integer;
  Digit : Real;
  Answer : Extended;
  AnswerStr, NumString : Str14;
  AddOne : Boolean;
  DigitStr : Str1;

begin
     {They can only round off up to 5 places.}

  If (NumPlaces > 5)
    then NumPlaces := 5;

  Str(Number:14:6, NumString);
  NumString := LTrim(NumString);

      {Find the decimal point.}

  Pos := 1;
  while ((Pos <= Length(NumString)) and (NumString[Pos] <> '.')) do
    Pos := Pos + 1;

  FirstPlaceAfterDecimalPos := Pos + 1;

    {Now let's look at the place that we need to in order to determine
     whether to round up or round down.}

  DeterminingDigit := FirstPlaceAfterDecimalPos + NumPlaces;
  Val(NumString[DeterminingDigit], DigitInt, ReturnCode);
  (*DigitInt := Trunc(Digit);*)

       {If the determining digit is >= 5, then round up. Otherwise, round
        down.}

  If (DigitInt >= 5)
    then
      begin
        AnswerStr := '';
        AddOne := True;

           {We are rounding up, so first let's add one to the digit to
            the left of the determining digit. If it takes us to ten,
            continue working to the left until we don't roll over a
            digit to ten.}

        For I := (DeterminingDigit - 1) downto 1 do
          begin
            If (NumString[I] = '.')
              then AnswerStr := '.' + AnswerStr
              else
                begin  {The character is a digit.}
                    {FXX05261998-1: Not leaving the negative sign if
                                    this is a negative number.}

                  If (NumString[I] = '-')
                    then AnswerStr := '-' + AnswerStr
                    else
                      begin
                        Val(NumString[I], Digit, ReturnCode);
                        DigitInt := Trunc(Digit);

                        If AddOne
                          then DigitInt := DigitInt + 1;

                        If (DigitInt = 10)
                          then AnswerStr := '0' + AnswerStr
                          else
                            begin
                              AddOne := False;
                              Str(DigitInt:1, DigitStr);
                              AnswerStr := DigitStr + AnswerStr;
                            end;  {else of If (((DigitInt + 1) = 10) and AddOne)}

                      end;  {else of If (NumString[I] = '-')}

                end;  {else of If (NumString[I] = '.')}

          end;  {For I := Pos to 1 do}

        If AddOne
          then AnswerStr := '1' + AnswerStr;

      end  {If (DigitInt >= 5)}
    else AnswerStr := Copy(NumString, 1, (DeterminingDigit - 1));

  Val(AnswerStr, Answer, ReturnCode);
  Roundoff := Answer;

end; { function Roundoff....}

{=============================================}
Procedure AddDifferenceEntry(DifferencesThisParcel : TList;
                             _DifferenceField : Integer;
                             _PASValue : String;
                             _SaberValue : String;
                             Numeric : Boolean;
                             Float : Boolean);

var
  DifferencePtr : DifferencePointer;
  TempIntPAS, TempIntSaber : LongInt;
  TempFloatPAS, TempFloatSaber : Double;

begin
  New(DifferencePtr);

  If Numeric
    then
      begin
        If Float
          then
            begin
              try
                TempFloatPAS := StrToFloat(_PASValue);
              except
                TempFloatPAS := 0;
              end;

              try
                TempFloatSaber := StrToFloat(_SaberValue);
              except
                TempFloatSaber := 0;
              end;

              If ((Roundoff(TempFloatPAS, 2) = 0) and
                  (Roundoff(TempFloatSaber, 2) = 0))
                then
                  begin
                    _PASValue := '';
                    _SaberValue := '';
                  end
                else
                  begin
                    If (Roundoff(TempFloatPAS, 2) = 0)
                      then _PASValue := '0'
                      else _PASValue := FormatFloat(DecimalEditDisplay,
                                                    TempFloatPAS);

                    If (Roundoff(TempFloatSaber, 2) = 0)
                      then _SaberValue := '0'
                      else _SaberValue := FormatFloat(DecimalEditDisplay,
                                                      TempFloatSaber);

                  end;  {else of If ((TempFloatPAS = 0) and ...}

            end  {If Float}
          else
            begin
              try
                TempIntPAS := StrToInt(_PASValue);
              except
                TempIntPAS := 0;
              end;

              try
                TempIntSaber := StrToInt(_SaberValue);
              except
                TempIntSaber := 0;
              end;

              If ((TempIntPAS = 0) and
                  (TempIntSaber = 0))
                then
                  begin
                    _PASValue := '';
                    _SaberValue := '';
                  end
                else
                  begin
                    If (TempIntPAS = 0)
                      then _PASValue := '0';

                    If (TempIntSaber = 0)
                      then _SaberValue := '0';

                  end;  {else of If ((TempIntPAS = 0) and ...}

            end;  {else of If Float}

      end;  {If Numeric}

  with DifferencePtr^ do
    begin
      DifferenceField := _DifferenceField;
      PASValue := _PASValue;
      SaberValue := _SaberValue;
    end;

  DifferencesThisParcel.Add(DifferencePtr);

end;  {AddDifferenceEntry}

{=============================================}
Procedure CompareOneField(DifferencesThisParcel : TList;
                          DifferenceType : Integer;
                          FieldName : String;
                          PASTable : TTable;
                          SaberTable : TTable;
                          Numeric : Boolean;
                          Float : Boolean);

var
  PASValue, SaberValue : String;
  PASFloat, SaberFloat : Double;
  DifferencesExists : Boolean;

begin
  try
    PASValue := Trim(PASTable.FieldByName(FieldName).Text);
  except
    PASValue := '';
  end;

  try
    SaberValue := Trim(SaberTable.FieldByName(FieldName).Text);
  except
    SaberValue := '';
  end;

  DifferencesExists := (PASValue <> SaberValue);

  If (Numeric and Float)
    then
      begin
        try
          PASFloat := Roundoff(StrToFloat(PASValue), 2);
        except
          PASFloat := 0;
        end;

        try
          SaberFloat := Roundoff(StrToFloat(SaberValue), 2);
        except
          SaberFloat := 0;
        end;

        DifferencesExists := (Roundoff(PASFloat, 2) <> Roundoff(SaberFloat, 2));

      end;  {If (Numeric and Float)}

  If DifferencesExists
    then AddDifferenceEntry(DifferencesThisParcel, DifferenceType,
                            PASValue, SaberValue, Numeric, Float);

end;  {CompareOneField}

{=============================================}
Procedure TForm1.GetDifferencesThisParcel(DifferencesThisParcel : TList);

var
  ParcelFound, Done, FirstTimeThrough : Boolean;
  PASBuildingStyle, SaberBuildingStyle,
  PASBuildingStyleDesc, SaberBuildingStyleDesc,
  SwisSBLKey, PASPoolType, SaberPoolType : String;
  SBLRec : SBLRecord;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    ParcelFound := FindKeyOld(SaberParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                              ['2002', SwisCode, Section,
                               SubSection, Block, Lot, Sublot, Suffix]);

  If ParcelFound
    then
      begin
        SetRangeOld(ResidentialBuildingTable, ['TaxRollYr', 'SwisSBLKey'],
                    [GlblThisYear, SwisSBLKey], [GlblThisYear, SwisSBLKey]);

        SetRangeOld(SaberResidentialBuildingTable, ['TaxRollYr', 'SwisSBLKey'],
                    ['2002', SwisSBLKey], ['2002', SwisSBLKey]);

        SetRangeOld(ResidentialImprovementTable, ['TaxRollYr', 'SwisSBLKey'],
                    [GlblThisYear, SwisSBLKey], [GlblThisYear, SwisSBLKey]);

        SetRangeOld(SaberResidentialImprovementTable, ['TaxRollYr', 'SwisSBLKey'],
                    ['2002', SwisSBLKey], ['2002', SwisSBLKey]);

        CompareOneField(DifferencesThisParcel, dfBathrooms, 'NumberOfBathrooms',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, False);

        CompareOneField(DifferencesThisParcel, dfFireplaces, 'NumberOfFireplaces',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfKitchens, 'NumberOfKitchens',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, False);

        CompareOneField(DifferencesThisParcel, dfStories, 'NumberOfStories',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, False);

        CompareOneField(DifferencesThisParcel, dfSFLA, 'SqFootLivingArea',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfHalfStory, 'HalfStoryArea',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfFirstFloor, 'FirstStoryArea',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfSecondFloor, 'SecondStoryArea',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfThirdFloor, 'ThirdStoryArea',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, True);

(*        CompareOneField(DifferencesThisParcel, dfBuildingStyle, 'BuildingStyleCode',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, False, False);*)

          {Always show building style and do it as the description.}

        PASBuildingStyle := ResidentialBuildingTable.FieldByName('BuildingStyleCode').Text;
        SaberBuildingStyle := SaberResidentialBuildingTable.FieldByName('BuildingStyleCode').Text;
        PASBuildingStyleDesc := '';
        SaberBuildingStyleDesc := '';

        If ((Deblank(PASBuildingStyle) <> '') and
            FindKeyOld(BuildingStyleCodeTable, ['MainCode'], [PASBuildingStyle]))
          then PASBuildingStyleDesc := BuildingStyleCodeTable.FieldByName('Description').Text;

        If ((Deblank(SaberBuildingStyle) <> '') and
            FindKeyOld(BuildingStyleCodeTable, ['MainCode'], [SaberBuildingStyle]))
          then SaberBuildingStyleDesc := BuildingStyleCodeTable.FieldByName('Description').Text;

        AddDifferenceEntry(DifferencesThisParcel, dfBuildingStyle,
                           PASBuildingStyleDesc, SaberBuildingStyleDesc, False, False);

        CompareOneField(DifferencesThisParcel, dfFinishedAttic, 'FinishedAtticArea',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfFinishedBasement, 'FinishedBasementArea',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfFinishedRecRoom, 'FinishedRecRoom',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfFinishedOverGarage, 'FinishedAreaOverGara',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfPorchType, 'PorchTypeCode',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, False, False);

        CompareOneField(DifferencesThisParcel, dfPorchSquareFeet, 'PorchArea',
                        ResidentialBuildingTable, SaberResidentialBuildingTable, True, True);

          {Do the pool type.}

        PASPoolType := '';
        SaberPoolType := '';

        Done := False;
        FirstTimeThrough := True;
        ResidentialImprovementTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ResidentialImprovementTable.Next;

          If ResidentialImprovementTable.EOF
            then Done := True;

          If ((not Done) and
              (Copy(ResidentialImprovementTable.FieldByName('StructureCode').Text, 1, 2) = 'LS'))
            then PASPoolType := ResidentialImprovementTable.FieldByName('StructureCode').Text;

        until Done;

        Done := False;
        FirstTimeThrough := True;
        SaberResidentialImprovementTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SaberResidentialImprovementTable.Next;

          If SaberResidentialImprovementTable.EOF
            then Done := True;

          If ((not Done) and
              (Copy(SaberResidentialImprovementTable.FieldByName('StructureCode').Text, 1, 2) = 'LS'))
            then SaberPoolType := SaberResidentialImprovementTable.FieldByName('StructureCode').Text;

        until Done;

        If (PASPoolType <> SaberPoolType)
          then AddDifferenceEntry(DifferencesThisParcel, dfInGroundPool,
                                  PASPoolType, SaberPoolType, False, False);

        CompareOneField(DifferencesThisParcel, dfAcreage, 'Acreage',
                        ParcelTable, SaberParcelTable, True, True);

        CompareOneField(DifferencesThisParcel, dfPropertyClass, 'PropertyClassCode',
                        ParcelTable, SaberParcelTable, False, False);

      end  {If ParcelFound}
    else AddDifferenceEntry(DifferencesThisParcel, dfParcelExists,
                           ConvertSwisSBLToDashDotNoSwis(SwisSBLKey), '', False, False);

end;  {GetDifferencesThisParcel}

{=============================================}
Function FindDifferenceItem(    DifferencesThisParcel : TList;
                                _DifferenceField : Integer;
                            var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Result := False;
  Index := -1;

  For I := 0 to (DifferencesThisParcel.Count - 1) do
    If ((Index = -1) and
        (DifferencePointer(DifferencesThisParcel[I])^.DifferenceField = _DifferenceField))
      then
        begin
          Index := I;
          Result := True;
        end;

end;  {FindDifferenceItem}

{=============================================}
Procedure WriteOneDifference(var ExtractFile : TextFile;
                                 DifferencesThisParcel : TList;
                                 _DifferenceField : Integer);

var
  _PASValue, _SaberValue : String;
  I : Integer;

begin
  _PASValue := '';
  _SaberValue := '';

  If FindDifferenceItem(DifferencesThisParcel, _DifferenceField, I)
    then
      with DifferencePointer(DifferencesThisParcel[I])^ do
        begin
          _PASValue := PASValue;
          _SaberValue := SaberValue;
        end;

  Write(ExtractFile, FormatExtractField(_PASValue),
                     FormatExtractField(_SaberValue));

end;  {WriteOneDifference}

{=============================================}
Procedure TForm1.PrintThisParcel(var ExtractFile : TextFile;
                                     SwisSBLKey : String;
                                     Owner : String;
                                     Location : String;
                                     DifferencesThisParcel : TList);

var
  I : Integer;

begin
  Write(ExtractFile, Copy(SwisSBLKey, 1, 6),
                     FormatExtractField(ConvertSwisSBLToDashDotNoSwis(SwisSBLKey)),
                     FormatExtractField(Owner),
                     FormatExtractField(Location));

  If FindDifferenceItem(DifferencesThisParcel, dfParcelExists, I)
    then Writeln(ExtractFile, FormatExtractField('No Saber parcel found.'))
    else
      begin
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfBathrooms);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfFireplaces);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfKitchens);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfStories);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfSFLA);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfHalfStory);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfFirstFloor);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfSecondFloor);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfThirdFloor);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfBuildingStyle);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfGarageType);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfFinishedAttic);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfFinishedBasement);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfFinishedRecRoom);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfFinishedOverGarage);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfPorchType);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfPorchSquareFeet);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfInGroundPool);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfAcreage);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfPropertyClass);

        Writeln(ExtractFile);

      end;  {else of If FindDifferenceItem(DifferencesThisParcel, dfParcelExists, I)}

end;  {PrintThisParcel}

{=============================================}
Procedure TForm1.StartButtonClick(Sender: TObject);

var
  ExtractFile : TextFile;
  SpreadsheetFileName : String;
  Done, FirstTimeThrough : Boolean;
  DifferencesThisParcel : TList;
  SelectedSwisCodes : TStringList;
  I : Integer;

begin
  Cancelled := False;
  SelectedSwisCodes := TStringList.Create;
  DifferencesThisParcel := TList.Create;
  SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
  AssignFile(ExtractFile, SpreadsheetFileName);
  Rewrite(ExtractFile);

  Writeln(ExtractFile, ',,,,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber,',
                       'PAS,',
                       'Saber');

  Writeln(ExtractFile, 'Swis,',
                       'Parcel ID,',
                       'Owner,',
                       'Legal Address,',
                       '# Bathrooms,',
                       '# Bathrooms,',
                       '# Fireplaces,',
                       '# Fireplaces,',
                       '# Kitchens,',
                       '# Kitchens,',
                       '# Stories,',
                       '# Stories,',
                       'SFLA,',
                       'SFLA,',
                       'Half Story,',
                       'Half Story,',
                       'First Floor,',
                       'First Floor,',
                       'Second Floor,',
                       'Second Floor,',
                       'Third Floor,',
                       'Third Floor,',
                       'Bldg Style,',
                       'Bldg Style,',
                       'Garage Type,',
                       'Garage Type,',
                       'Fin Attic,',
                       'Fin Attic,',
                       'Fin Bsmt,',
                       'Fin Bsmt,',
                       'Fin Rec Room,',
                       'Fin Rec Room,',
                       'Fin Over Gar,',
                       'Fin Over Gar,',
                       'Porch Type,',
                       'Porch Type,',
                       'Prch Area,',
                       'Prch Area,',
                       'Pool Type,',
                       'Pool Type,',
                       'Acreage,',
                       'Acreage,',
                       'Class,',
                       'Class');

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    If SwisCodeListBox.Selected[I]
      then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

  Done := False;
  FirstTimeThrough := True;
  ParcelTable.First;

  ProgressBar.Max := GetRecordCount(ParcelTable);
  ProgressBar.Position := 0;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    ProgressBar.Position := ProgressBar.Position + 1;
    Application.ProcessMessages;

    If ParcelTable.EOF
      then Done := True;

    If ((not Done) and
        (SelectedSwisCodes.IndexOf(ParcelTable.FieldByName('SwisCode').Text) > -1))
      then
        begin
          ClearTList(DifferencesThisParcel, SizeOf(DifferenceRecord));
          GetDifferencesThisParcel(DifferencesThisParcel);

          If (DifferencesThisParcel.Count > 0)
            then PrintThisParcel(ExtractFile,
                                 ExtractSSKey(ParcelTable),
                                 ParcelTable.FieldByName('Name1').Text,
                                 GetLegalAddressFromTable(ParcelTable),
                                 DifferencesThisParcel);

        end;  {If not Done}

  until (Done or Cancelled);

  FreeTList(DifferencesThisParcel, SizeOf(DifferenceRecord));

  CloseFile(ExtractFile);
  SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                 False, '');

  SelectedSwisCodes.Free;
  ProgressBar.Position := 0;

end;  {StartButtonClick}

{=================================================================}
Procedure TForm1.CancelButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to cancel the comparison?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then Cancelled := True;

end;  {CancelButtonClick}


end.