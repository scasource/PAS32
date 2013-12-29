unit ValuationTypes;

interface

uses DBTables, Classes, DB;

type
  GroupTotalsRecord = record
    MinimumSalePrice : LongInt;
    MaximumSalePrice : LongInt;
    MedianSalePrice : LongInt;
    AverageSalePrice : LongInt;
    MinimumPSF : Double;
    MaximumPSF : Double;
    MedianPSF : Double;
    AveragePSF : Double;
    ParcelCount : LongInt;
  end;

  WeightingRecord = record
    SwisCodePoints : LongInt;
    PropertyClassPoints : LongInt;
    NeighborhoodPoints : LongInt;
    BuildingStylePoints : LongInt;
    GradePoints : LongInt;
    ConditionPoints : LongInt;
    FireplacePoints : LongInt;
    GarageCapacityPoints : LongInt;
    SquareFootPoints : LongInt;
    YearPoints : LongInt;
    StoriesPoints : LongInt;
    BedroomPoints : LongInt;
    BathroomPoints : LongInt;
    AcreagePoints : LongInt;
  end;

  WeightingPointer = ^WeightingRecord;

  AdjustmentLevelRecord = record
    SalesPriceLow : LongInt;
    SalesPriceHigh : LongInt;
    FieldAdjustmentsList : TList;
  end;
  AdjustmentLevelPointer = ^AdjustmentLevelRecord;

  AdjustmentFieldRecord = record
    FieldName : String;
    Adjustment : LongInt;
    Linear : Boolean;
  end;
  AdjustmentFieldPointer = ^AdjustmentFieldRecord;

  TAdjustmentTemplateObject = class
  private
    FAdjustmentCode : String;
    FWeightingPtr : WeightingPointer;
    FAdjustments : TList;

    Procedure LoadWeights(FWeightingPtr : WeightingPointer);

  public
    Constructor Create;
    Function GetCurrentWeights : WeightingPointer;
    Function GetDefaultAdjustmentCode(ValuationAdjustmentHeaderTable : TTable) : String;
    Procedure SetAdjustmentCode(AdjustmentCode : String);
    Procedure LoadAdjustmentInformation(AdjustmentFieldsAvailableTable : TTable;
                                        AdjustmentDetailsTable : TTable);
    Function GetTimeAdjustedSalesPrice(SalePrice : LongInt;
                                       SaleDate : TDateTime) : LongInt;
    Function GetAdjustmentLevel(ResultsDetailsTable : TTable) : Integer;
    Function ComputeAdjustments(ResultsDetailsTable : TTable;
                                ResultsDetailsLookupTable : TTable) : LongInt;
    Destructor Destroy; override;
  end;

implementation

uses WinUtils, Utilitys;

{=============================================================}
Procedure TAdjustmentTemplateObject.LoadWeights(FWeightingPtr : WeightingPointer);

begin
  with FWeightingPtr^ do
    begin
      SwisCodePoints := 10000;
      PropertyClassPoints := 7500;
      NeighborhoodPoints := 5000;
      BuildingStylePoints := 15000;
      GradePoints := 4000;
      ConditionPoints := 2000;
      FireplacePoints := 500;
      GarageCapacityPoints := 500;
      SquareFootPoints := 10;
      YearPoints := 50;
      StoriesPoints := 2000;
      BedroomPoints := 200;
      BathroomPoints := 1000;
      AcreagePoints := 200;

    end;  {with FWeightingPtr^ do}

end;  {LoadWeights}

{=============================================================}
Constructor TAdjustmentTemplateObject.Create;

begin
  inherited Create;
  New(FWeightingPtr);
  LoadWeights(FWeightingPtr);
end;  {Create}

{=============================================================}
Function TAdjustmentTemplateObject.GetCurrentWeights : WeightingPointer;

begin
  Result := FWeightingPtr;
end;

{===================================================}
Procedure TAdjustmentTemplateObject.SetAdjustmentCode(AdjustmentCode : String);

begin
  FAdjustmentCode := AdjustmentCode;
end;  {SetAdjustmentCode}

{===================================================}
Function TAdjustmentTemplateObject.GetDefaultAdjustmentCode(ValuationAdjustmentHeaderTable : TTable) : String;

var
  Done, FirstTimeThrough : Boolean;

begin
  Result := '';
  Done := False;
  FirstTimeThrough := True;
  ValuationAdjustmentHeaderTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ValuationAdjustmentHeaderTable.Next;

    If ValuationAdjustmentHeaderTable.EOF
      then Done := True;

    If ((not Done) and
        ValuationAdjustmentHeaderTable.FieldByName('Default').AsBoolean)
      then Result := ValuationAdjustmentHeaderTable.FieldByName('AdjustmentCode').Text;

  until Done;

end;  {GetDefaultAdjustmentCode}

{===================================================}
Procedure TAdjustmentTemplateObject.LoadAdjustmentInformation(AdjustmentFieldsAvailableTable : TTable;
                                                              AdjustmentDetailsTable : TTable);

var
  ValidFieldNameList : TStringList;
  I : Integer;
  Done, FirstTimeThrough : Boolean;
  AdjustmentLevelPtr : AdjustmentLevelPointer;
  AdjustmentFieldPtr : AdjustmentFieldPointer;
  TempFieldName : String;

begin
  FindKeyOld(AdjustmentFieldsAvailableTable, ['AdjustmentCode'], [FAdjustmentCode]);
  SetRangeOld(AdjustmentDetailsTable, ['AdjustmentCode', 'SalesPriceLow'],
              [FAdjustmentCode, '0'], [FAdjustmentCode, '999999999']);

  If (FAdjustments = nil)
    then FAdjustments := TList.Create
    else ClearTList(FAdjustments, SizeOf(AdjustmentLevelRecord));

  ValidFieldNameList := TStringList.Create;

  with AdjustmentFieldsAvailableTable do
    For I := 0 to (FieldCount - 1) do
      If ((Fields[I] is TBooleanField) and
          (Pos('Linear', Fields[I].FieldName) = 0) and  {Don't include linear fields.}
          TBooleanField(Fields[I]).AsBoolean)
        then
          If (Fields[I].FieldName = 'SalesPrice')
            then
              begin
                  {Sales price is one field in the fields available but 2 in the
                   actual representation.}

                ValidFieldNameList.Add('SalesPriceHigh');
                ValidFieldNameList.Add('SalesPriceLow');
              end
            else ValidFieldNameList.Add(Fields[I].FieldName);

  Done := False;
  FirstTimeThrough := True;
  AdjustmentDetailsTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else AdjustmentDetailsTable.Next;

    If AdjustmentDetailsTable.EOF
      then Done := True;

    If not Done
      then
        begin
          New(AdjustmentLevelPtr);

          with AdjustmentLevelPtr^ do
            If (ValidFieldNameList.IndexOf('SalesPriceHigh') > -1)
              then
                begin
                  SalesPriceLow := AdjustmentDetailsTable.FieldByName('SalesPriceLow').AsInteger;
                  SalesPriceHigh := AdjustmentDetailsTable.FieldByName('SalesPriceHigh').AsInteger;
                end;

          AdjustmentLevelPtr^.FieldAdjustmentsList := TList.Create;

            {Now search through each field in the adjustment detail table to
             see if it is used.  If so, put the amount of the adjustment in the
             list.}

          with AdjustmentFieldsAvailableTable, AdjustmentLevelPtr^ do
            For I := 0 to (FieldCount - 1) do
              If (ValidFieldNameList.IndexOf(Fields[I].FieldName) > -1)
                then
                  begin
                    New(AdjustmentFieldPtr);

                    with AdjustmentFieldPtr^ do
                      begin
                        FieldName := Fields[I].FieldName;
                        Adjustment := AdjustmentDetailsTable.FieldByName(FieldName).AsInteger;
                        TempFieldName := FieldName + 'Linear';
                        Linear := AdjustmentFieldsAvailableTable.FieldByName(TempFieldName).AsBoolean;

                      end;  {with AdjustmentFieldPtr^ do}

                    FieldAdjustmentsList.Add(AdjustmentFieldPtr);

                  end;  {If (ValidFieldNameList.IndexOf(Fields[I].FieldName) > -1)}

          FAdjustments.Add(AdjustmentLevelPtr);

        end;  {If not Done}

  until Done;

  ValidFieldNameList.Free;

end;  {LoadAdjustmentInformationForCode}

{===================================================}
Function TAdjustmentTemplateObject.GetTimeAdjustedSalesPrice(SalePrice : LongInt;
                                                             SaleDate : TDateTime) : LongInt;

begin
  Result := SalePrice;
end;  {GetTimeAdjustedSalesPrice}

{===================================================}
Function TAdjustmentTemplateObject.GetAdjustmentLevel(ResultsDetailsTable : TTable) : Integer;

begin
  Result := 0;
end;

{===================================================}
Function TAdjustmentTemplateObject.ComputeAdjustments(ResultsDetailsTable : TTable;
                                                      ResultsDetailsLookupTable : TTable) : LongInt;

var
  Index, J : Integer;
  TempDifference, AdjustmentAmount : Double;
  AdjustmentFieldName : String;

begin
  Index := GetAdjustmentLevel(ResultsDetailsTable);
  Result := 0;

  with AdjustmentLevelPointer(FAdjustments[Index])^ do
    For J := 0 to (FieldAdjustmentsList.Count - 1) do
      with AdjustmentFieldPointer(FieldAdjustmentsList[J])^ do
        begin
          AdjustmentAmount := 0;

          If Linear
            then
              begin
                TempDifference := TableFloatFieldsDifference(ResultsDetailsLookupTable,
                                                             ResultsDetailsTable, FieldName,
                                                             False);

                AdjustmentAmount := Roundoff((-1 * (TempDifference * Adjustment)), 0);
              end
            else
              If not TableFieldsSame(ResultsDetailsLookupTable,
                                     ResultsDetailsTable, FieldName)
                then AdjustmentAmount := Adjustment;

          AdjustmentFieldName := FieldName + 'Adjustment';

          with ResultsDetailsTable do
            try
              If not (State in [dsEdit, dsInsert])
                then Edit;

              FieldByName(AdjustmentFieldName).AsInteger := Trunc(AdjustmentAmount);
            except
            end;

        end;  {with AdjustmentFieldPointer(FieldAdjustmentLists[J])^ do}

end;  {ComputeAdjustments}

{===================================================}
Destructor TAdjustmentTemplateObject.Destroy;

var
  I : Integer;

begin
  Dispose(FWeightingPtr);

    {To free the FAdjustments list, first go through and free the FieldAdjustments
     list on each item.}

  try
    For I := 0 to (FAdjustments.Count - 1) do
      with AdjustmentLevelPointer(FAdjustments[I])^ do
        FreeTList(FieldAdjustmentsList, SizeOf(AdjustmentFieldRecord));

    FreeTList(FAdjustments, SizeOf(AdjustmentLevelRecord));
  except
  end;

  inherited Destroy;
end;  {Destroy}


end.
