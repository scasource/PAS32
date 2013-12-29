unit SaberCommercialCompareUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBTables, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    StartButton: TBitBtn;
    CancelButton: TBitBtn;
    ParcelTable: TTable;
    CommercialBuildingTable: TTable;
    CommercialRentTable: TTable;
    SaberParcelTable: TTable;
    SaberCommercialBuildingTable: TTable;
    SaberCommercialRentTable: TTable;
    Label9: TLabel;
    SwisCodeListBox: TListBox;
    ProgressBar: TProgressBar;
    SwisCodeTable: TTable;
    InitializationTimer: TTimer;
    SystemTable: TTable;
    AssessmentYearControlTable: TTable;
    CommercialInventoryTable: TTable;
    SaberCommercialInventoryTable: TTable;
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
  dfYearBuilt = 1;
  dfFloorArea = 2;
  dfPerimeter = 3;
  dfStories = 4;
  dfUsedAsCode = 5;
  dfUsedAsDescription = 6;
  dfRentType = 7;
  dfRentalArea = 8;
  dfTotalUnits = 9;
  dfImprovementCode = 10;
  dfImprovementDescription = 11;
  dfDimension1 = 12;
  dfDimension2 = 13;
  dfQuantity = 14;

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
  CommercialBuildingTable.Open;
  CommercialRentTable.Open;
  CommercialImprovementTable.Open;
  SaberParcelTable.Open;
  SaberCommercialBuildingTable.Open;
  SaberCommercialRentTable.Open;
  SaberCommercialImprovementTable.Open;
  SystemTable.Open;
  SwisCodeTable.Open;
  AssessmentYearControlTable.Open;

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
        SetRangeOld(CommercialBuildingTable, ['TaxRollYr', 'SwisSBLKey'],
                    [GlblThisYear, SwisSBLKey], [GlblThisYear, SwisSBLKey]);

        SetRangeOld(SaberCommercialBuildingTable, ['TaxRollYr', 'SwisSBLKey'],
                    ['2002', SwisSBLKey], ['2002', SwisSBLKey]);

        SetRangeOld(CommercialRentTable, ['TaxRollYr', 'SwisSBLKey'],
                    [GlblThisYear, SwisSBLKey], [GlblThisYear, SwisSBLKey]);

        SetRangeOld(SaberCommercialRentTable, ['TaxRollYr', 'SwisSBLKey'],
                    ['2002', SwisSBLKey], ['2002', SwisSBLKey]);

        SetRangeOld(CommercialImprovementTable, ['TaxRollYr', 'SwisSBLKey'],
                    [GlblThisYear, SwisSBLKey], [GlblThisYear, SwisSBLKey]);

        SetRangeOld(SaberCommercialImprovementTable, ['TaxRollYr', 'SwisSBLKey'],
                    ['2002', SwisSBLKey], ['2002', SwisSBLKey]);

  dfYearBuilt = 1;
  dfFloorArea = 2;
  dfPerimeter = 3;
  dfStories = 4;
  dfUsedAsCode = 5;
  dfUsedAsDescription = 6;
  dfRentType = 7;
  dfRentalArea = 8;
  dfTotalUnits = 9;
  dfImprovementCode = 10;
  dfImprovementDescription = 11;
  dfDimension1 = 12;
  dfDimension2 = 13;
  dfQuantity = 14;


        CompareOneField(DifferencesThisParcel, dfYearBuilt, 'EffectiveYearBuilt',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, False);

        CompareOneField(DifferencesThisParcel, dfFloorArea, 'GrossFloorArea',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfPerimeter, 'BuildingPerimeter',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, False);

        CompareOneField(DifferencesThisParcel, dfStories, 'NumberStories',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, False);

        CompareOneField(DifferencesThisParcel, dfUsedAsCode, 'SqFootLivingArea',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfHalfStory, 'HalfStoryArea',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfFirstFloor, 'FirstStoryArea',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfSecondFloor, 'SecondStoryArea',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfThirdFloor, 'ThirdStoryArea',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, True);

(*        CompareOneField(DifferencesThisParcel, dfBuildingStyle, 'BuildingStyleCode',
                        CommercialBuildingTable, SaberCommercialBuildingTable, False, False);*)

          {Always show building style and do it as the description.}

        PASBuildingStyle := CommercialBuildingTable.FieldByName('BuildingStyleCode').Text;
        SaberBuildingStyle := SaberCommercialBuildingTable.FieldByName('BuildingStyleCode').Text;
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
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfFinishedBasement, 'FinishedBasementArea',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfFinishedRecRoom, 'FinishedRecRoom',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfFinishedOverGarage, 'FinishedAreaOverGara',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, True);

        CompareOneField(DifferencesThisParcel, dfPorchType, 'PorchTypeCode',
                        CommercialBuildingTable, SaberCommercialBuildingTable, False, False);

        CompareOneField(DifferencesThisParcel, dfPorchSquareFeet, 'PorchArea',
                        CommercialBuildingTable, SaberCommercialBuildingTable, True, True);

          {Do the pool type.}

        PASPoolType := '';
        SaberPoolType := '';

        Done := False;
        FirstTimeThrough := True;
        CommercialRentTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else CommercialRentTable.Next;

          If CommercialRentTable.EOF
            then Done := True;

          If ((not Done) and
              (Copy(CommercialRentTable.FieldByName('StructureCode').Text, 1, 2) = 'LS'))
            then PASPoolType := CommercialRentTable.FieldByName('StructureCode').Text;

        until Done;

        Done := False;
        FirstTimeThrough := True;
        SaberCommercialRentTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SaberCommercialRentTable.Next;

          If SaberCommercialRentTable.EOF
            then Done := True;

          If ((not Done) and
              (Copy(SaberCommercialRentTable.FieldByName('StructureCode').Text, 1, 2) = 'LS'))
            then SaberPoolType := SaberCommercialRentTable.FieldByName('StructureCode').Text;

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

  dfParcelExists = 0;
  dfYearBuilt = 1;
  dfFloorArea = 2;
  dfPerimeter = 3;
  dfStories = 4;
  dfUsedAsCode = 5;
  dfUsedAsDescription = 6;
  dfRentType = 7;
  dfRentalArea = 8;
  dfTotalUnits = 9;
  dfImprovementCode = 10;
  dfImprovementDescription = 11;
  dfDimension1 = 12;
  dfDimension2 = 13;
  dfQuantity = 14;

  If FindDifferenceItem(DifferencesThisParcel, dfParcelExists, I)
    then Writeln(ExtractFile, FormatExtractField('No Saber parcel found.'))
    else
      begin
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfYearBuilt);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfFloorArea);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfPerimeter);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfStories);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfUsedAsCode);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfusedAsDescription);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfRentType);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfRentalArea);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfTotalUnits);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfImprovementCode);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfImprovmentDescription);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfDimension1);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfDimension2);
        WriteOneDifference(ExtractFile, DifferencesThisParcel, dfQuantity);

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
                       'Saber');

  Writeln(ExtractFile, 'Swis,',
                       'Parcel ID,',
                       'Owner,',
                       'Legal Address,',
                       'Year Built,',
                       'Year Built,',
                       'Floor Area,',
                       'Floor Area,',
                       'Perimeter,',
                       'Perimeter,',
                       'Stories,',
                       'Stories,'
                       'Used As,',
                       'Used As,',
                       'Used As Desc,',
                       'Used As Desc,',
                       'Rent Type,',
                       'Rent Type,',
                       'Rental Area,',
                       'Rental Area,',
                       'Units,',
                       'Units,',
                       'Imp Code,',
                       'Imp Code,',
                       'Imp Desc,',
                       'Imp Desc,',
                       'Dim 1,',
                       'Dim 1,',
                       'Dim 2,',
                       'Dim 2,',
                       'Quantity,',
                       'Quantity')

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