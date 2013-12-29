Unit Utilitys;

{$N+}

Interface

Uses Types, SysUtils, Graphics, Classes, Glblcnst, Controls, ShellAPI, Dialogs;

Function  Take(len:integer;vec:String): String;
Function  Rtrim(Arg : String) : String;
Function  LTrim(Arg : String) : String;
Function  DeBlank(s: String): String;
Procedure Beep;
Function  UpcaseStr(S : String) : String;
Function  LowerCase(S : String) : String;
Function  ConstStr(C : Char; N : Integer) : String;
Function  Power10(Places : Byte):Double;
Function Roundoff(Number : Extended;
                  NumPlaces : Integer) : Extended;
Function  MakeYYYYMMDD (DateToConvert : String) : String;
Function  MakeMMDDYYYY (DateToConvert : String) : String;

Function MakeMMDDYYYYSlashed (Date : String) : String;
Function MakeMMDDYYYYSlashedShort(Date : String) : String;

Function MakeYYYYMMDDSlashed (Date : String) : String;
Function MakeYYYYMMDDSlashedShort(Date : String) : String;
Function MMDDYYYYDateToYYYYMMDDSlashed (Date : String) : String;

Function ShiftRightAddZeroes(SourceStr : String) : String; overload;
Function ShiftRightAddZeroes(SourceStr : String;
                             StrLength : Integer) : String; overload;

Function ShiftRightAddBlanks(SourceStr : String): String;
Function BoolToChar(AnyBoolean : Boolean) : Char;
Function BoolToChar_Blank_1(AnyBoolean : Boolean) : Char;
Function BoolToChar_Blank_Y(AnyBoolean : Boolean) : Char;
Function BoolToChar_Blank_X(AnyBoolean : Boolean) : Char;
Function BoolToChar_0_1(AnyBoolean : Boolean) : Char;
Function CharToBool(YNChar : Char) : Boolean;
Function BoolToStr(AnyBoolean : Boolean) : String;
Function BoolToStr_True_False(AnyBoolean : Boolean) : String;
{Return 'Yes' or 'No'}
Function StrToBool(YNStr : String) : Boolean;
Function StrToBool_Blank_1(TempStr : String) : Boolean;
{Given a string where blank = false, 1 = true, convert it to
 a boolean.}
Function StrToBool_0_1(TempStr : String) : Boolean;
{Given a string where 0 = false, 1 = true, convert it to
 a boolean.}
Function ConvertNumberToText(Number : Integer) : String;
(*Function DeZeroOnLeft(Arg : String) : String;*)
Function DezeroOnLeft(TempStr : String) : String;

Function DeZeroOnRight(Arg : String) : String;
Function MakeYYYYMMDDTextDate(Date : String) : String;
Function MakeMMDDYYYYTextDate(Date : String) : String;
Function ConvertToDisplayTime(Time : String) : String;
Procedure CheckTimeStr(    Time : String;
                       var ReturnCode : Integer);
Function ConvertTo24HourTime(Time : String) : String;

Function MoveDateAhead(Date : String;  {MMDDYYYY}
                       Interval : Integer;  {In months}
                       RollAhead : Boolean) : String;   {Returns MMDDYYYY}

Function NumMembersInSet(Subset : CharSet) : Integer;

Function ListMembers(Subset : Charset) : String;

Function ListMembersFormatted(Subset : Charset) : String;

Procedure Permute(FixedChars,
                  ToBePermuted : String);

Function ValidYearEntry(Year : String) : Boolean;

Function Format24HourTime(Time : String) : String;
Function CalcYearsDiff(Date1, Date2 : String) : Integer;  {MMDDYYYY}

Function GetCommandLine : String;

Function MaxInt(Int1,
                Int2 : Integer) : Integer;
Function MinInt(Int1,
                Int2 : Integer) : Integer;
Function MaxComp(Comp1,
                 Comp2 : Comp) : Comp;
Function MaxExtended(Extended1,
                     Extended2 : Extended) : Extended;
Function MaxInt2(const IntArray : Array of Integer) : Integer;
{Find the largest integer of any number of integers.}
Function MaxExtended2(const ExtendedArray : Array of Extended) : Extended;
{Find the largest Extended of any number of Extended.}

Function ReturnOrdinal(Num : Integer) : String;
Function StartsWith(Substring,
                    MainString : String) : Boolean;
Function ContainedIn(Substring,
                     MainString : String) : Boolean;
Function ExtractField(SearchRec : String;
                      StartPos,
                      Len : Integer) : String;
Procedure ReadLineFromTextFile(var OutputFile : Text;
                               var FirstCharOfNextLine : Char;
                               var LineFeedLastLine : Boolean;
                               var PrintLine : String);
Function IntPower(Base, Exponent : Integer) : LongInt;
Function StripColon(MainString : String) : String;

Function StringIsNumeric(Text : String) : Boolean;
Function StringIsAlphabetic(Text : String) : Boolean;
Function StripChar(Text : String;
                   CharToRemove,
                   ReplacementChar : Char;
                   ReplaceChar : Boolean) : String;
Function StripChars(sSource : String;
                    aCharsToRemove : Charset;
                    cReplacement : Char;
                    bReplaceCharacter : Boolean) : String;
Function ParseIntoLines(Source : String;
                        LineLength : Integer) : String; overload;
Procedure ParseIntoLines(Source : String;
                         LineLength : Integer;
                         LineList : TStringList;
                         BreakOnAmpersand : Boolean); overload;

Function YearEntryIsValid(Year : String) : Boolean;
Function DeleteChars(Text : String;
                     CharsToRemove : CharSet) : String;
{Delete all characters which are in the CharsToRemove set.}

Function MakeMMDDYY(Date : TDateTime) : String;
{Given a date in the form of TDateTime, return a string
 MMDDYY.}

Function MakeMMDDYYYYFromDateTime(Date : TDateTime) : String;
{Given a date in the form of TDateTime, return a string
 MMDDYYYY.}

Function FormatRPSNumericString(Source : String;
                                SourceLen,
                                NumPlacesAfterDecimal : Integer) : String;
{Given a string with a real number (i.e. 9.87), format it
 according to RPS extract standards. The format is shifted
 right, zero filled, no decimal point with the last
 NumPlacesAfterDecimal digits being the mantissa (decimal part).}

Function Center(S: String;
                Width : Integer): String;
{ Function Center removes leading and trailing blanks from }
{ a string, then pads it with blanks to center it within   }
{ a string of length Width.                                }

Function AddDirectorySlashes(Directory : String) : String;
{Make sure that this directory name starts and ends with a slash.
 If not, add it.}

Function UpperCaseFirstChars(Source : String) : String;
{Upper case the first letters of each word, i.e. The Fox Jumps Over ...}

Function RightJustify(SourceStr : String;
                      FinalLength : Integer) : String;
Function LeftJustify(SourceStr : String;
                     FinalLength : Integer) : String;
                     
 Function GetAcres(Acres, Frontage, Depth : Double) : Double;
 Function GetSquareFeet(Acres, Frontage, Depth : Double) : Double;
Function MoveDateTimeAhead(SourceDate : TDateTime;
                           YearsToAdd,
                           MonthsToAdd,
                           DaysToAdd : Integer) : TDateTime;

Function MoveDateTimeBackwards(SourceDate : TDateTime;
                               YearsToSubtract,
                               MonthsToSubtract,
                               DaysToSubtract : Integer) : TDateTime;

Function StripPath(Path : String) : String;
Function ReturnPath(Path : String) : String;
Function DeleteUpToChar(Substr,
                        SourceStr : String;
                        Inclusive : Boolean) : String;
Function GetUpToChar(Substr,
                     SourceStr : String;
                     Inclusive : Boolean) : String;

Procedure ReadLine(var TempFile : Text;
                   var TempStr : LineStringType);

Function ParseField(var TempStr : LineStringType;
                        FieldNo : Integer;
                    var EndOfLine : Boolean) : String;
Function CalcMonthsDifference(FirstDate,
                              SecondDate : TDateTime) : Integer;
Function FindFirstNonNumberInText(TempStr : String) : Integer;
Function ChangeLocationToLocalDrive(Location : String) : String;
Function GetExcelCellName(ColumnNumber,
                          RowNumber : Integer) : String;

Function HexToInt(HexValue : String) : Integer;
Procedure GetRGBValues(    Color : TColor;
                       var RedAmount : Integer;
                       var GreenAmount : Integer;
                       var BlueAmount : Integer);

Function AddOneYear(TempDate : TDateTime) : TDateTime;
Function BooleanToX_Blank(TempBoolean : Boolean) : String;
Function ExpandAddress(TempAddress : String) : String;
Function AddressMeetsRangeCriteria(StreetNumber : LongInt;
                                   Street : String;
                                   StartingStreetNumber : String;
                                   StartingStreet : String;
                                   EndingStreetNumber : String;
                                   EndingStreet : String) : Boolean;

{$H+}
Function FormatExtractField(TempStr : String) : String;
Function VarRecToStr(VarRec : TVarRec) : String;
Procedure WriteCommaDelimitedLine(var ExtractFile : TextFile;
                                      Fields : Array of const);
Procedure WritelnCommaDelimitedLine(var ExtractFile : TextFile;
                                        Fields : Array of const);
{$H-}

Function GetTemporaryFileName(Caption : String) : String;
Function GetNextWord(var TempStr : String) : String;
Function ExpandStreetNameType(TempStr : String) : String;
Function ExtractPlainTextFromRichText(RichText : String;
                                      StripCarriageReturns : Boolean) : String;
Function RemoveExtension(FileName : String) : String;
Function GetExtension(FileName : String) : String;

{$H+}
Procedure ParseCommaDelimitedStringIntoFields(TempStr : String;
                                              FieldList : TStringList;
                                              CapitalizeStrings : Boolean);
{$H-}

{$H+}
Procedure ParseTabDelimitedStringIntoFields(TempStr : String;
                                            FieldList : TStringList;
                                            CapitalizeStrings : Boolean);
{$H-}

{$H+}
Procedure ParseStringIntoFields(TempStr : String;
                                FieldList : TStringList;
                                Delimiter : String;
                                CapitalizeStrings : Boolean);
{$H-}

Function GetMonthNumberForShortMonthName(Month : String) : Integer;

Procedure ParseCityIntoCityAndState(var City : String;
                                   var State : String);

Function _Compare(String1,
                  String2 : String;
                  Comparison : Integer) : Boolean; overload;

Function _Compare(Char1,
                  Char2 : Char;
                  Comparison : Integer) : Boolean; overload;

Function _Compare(      String1 : String;
                  const ComparisonValues : Array of const;
                        Comparison : Integer) : Boolean; overload;

Function _Compare(String1 : String;
                  Comparison : Integer) : Boolean; overload;

Function _Compare(Int1,
                  Int2 : LongInt;
                  Comparison : Integer) : Boolean; overload;

Function _Compare(      Int1 : LongInt;
                  const ComparisonValues : Array of const;
                        Comparison : Integer) : Boolean; overload;

Function _Compare(Real1,
                  Real2 : Extended;
                  Comparison : Integer) : Boolean; overload;

Function _Compare(Logical1 : Boolean;
                  Logical2String : String;
                  Comparison : Integer) : Boolean; overload;

Function _Compare(DateTime1,
                  DateTime2 : TDateTime;
                  Comparison : Integer) : Boolean; overload;

Procedure ParseName(    _Name : String;
                    var FirstName : String;
                    var LastName : String);
                    
Procedure ParseFullName(    _Name : String;
                        var FirstName : String;
                        var MiddleInitial : String;
                        var LastName : String;
                        var Suffix : String);

Procedure GetFileSpecifications(    FileName : String;
                                var FileDate : TDateTime;
                                var FileTime : TTime;
                                var FileSize : LongInt);

Function ConvertStringListToString(StringList : TStringList;
                                   SeparatorCharacter : String) : String;

Procedure SortDateStringList(DateList : TStringList);

Function DataInRange(DataItem : String;
                     StartRange : String;
                     EndRange : String;
                     PrintAllInRange : Boolean;
                     PrintToEndOfRange : Boolean) : Boolean; overload;

Procedure DeleteFolder(Directory_Name : String;
                       _RemoveDirectory : Boolean);

Function DaysInYear(Year : String) : Integer;

Function IncrementNumericString(NumericStr : String;
                                Increment : LongInt) : String;

Function Max(const Values : Array of const) : Extended; overload;

Function FormatSQLString(TempStr : String) : String;

Function FormatSQLString2(TempStr : String) : String;

Function FormatFilterString(TempStr : String) : String;

Function FormatwwFilterString(TempStr : String) : String;

{$H+}
Function CountOfCharacter(TempStr : String;
                          _Char : Char) : LongInt;
{$H-}

Function ComputePercent(NewValue : Double;
                        BaseValue : Double) : Double;

Procedure WritePipeDelimitedLine(var ExtractFile : TextFile;
                                     Fields : Array of const);

Procedure WritelnPipeDelimitedLine(var ExtractFile : TextFile;
                                       Fields : Array of const);

Function Mod10(const Value: string): Integer;

Function CalculateCheckDigit_Mod10_7532(sSomeNumber: String): String;

Function AddressIsPOBox(Address : String) : Boolean;

Function AddressIsUnit(Address : String) : Boolean;

Function AddressIsDesignation(Address : String) : Boolean;

Function Even(Number : LongInt) : Boolean;

Procedure LogTime(sFileName : String;
                  sLocator : String);

Function PromptForExcelExtract : Boolean;

Function CreateMailingZipCode(sZipCode : String;
                              sZipCodePlus4 : String) : String;

Function NumOccurrences(cSearch : Char;
                        sSource : String) : Integer;

Function RoundToNearest(iNumber : LongInt;
                        iNearest : LongInt) : LongInt;

Function StringContainsNumber(sTemp : String) : Boolean;

Function GetNegativeAS400Integer(sAS400Number : String) : LongInt;

var
  GlblCurrentCommaDelimitedField : Integer;

IMPLEMENTATION
{===================================================================}
Function take(len:integer;vec:String): String;

begin
  vec:=copy(vec,1,len);
  while length(vec)<len do vec:=concat(vec,' ');
  take:=vec;
end;

{===================================================================}
Function Rtrim(Arg : String): String;

{DS: trim trailing blanks off of a string }

var
  Lgn, Pos : Integer;

begin
  Lgn := Length(Arg);
  Pos := Lgn;

  while ((Pos >= 1) and
         (Arg[Pos] = ' ')) do
    begin
      Delete(Arg, Pos, 1);
      Pos := Pos - 1;
    end;

  RTrim := Arg;

end; {of Function Rtrim }

{===================================================================}
Function LTrim(Arg : String) : String;
{DS: trim Leading blanks off of a string }

var
  Pos, Lgn :Integer;

begin
  Lgn := Length(Arg);

  Pos := 1;

    {Delete spaces off the front.}

  while ((Pos <= Lgn) and
         (Arg[1] = ' ')) do
    begin
      Delete(Arg, 1, 1);
      Pos := Pos + 1;
    end;

  LTrim := Arg;

end;  {LTrim}

{=================================================================}

Function DeBlank(s: String): String;

begin
  repeat
   delete(s,pos(' ',s),1)
  until (0 = pos(' ',s));
  deblank:=s;
end;  {of DeBlank}

{=======================================================================}
Procedure Beep;

begin
  Write(^G);
end;

{============================================================================}
Function UpcaseStr(S : String) : String;

(*  UpcaseStr converts a string to upper case *)

var
  I : Integer;
begin
  for I := 1 to Length(S) do
    S[I] := Upcase(S[I]);
  UpcaseStr := S;
end;

{============================================================================}
Function LowerCase(S : String) : String;

var
  I : Integer;

begin
  for I := 1 to Length(S) do
    If (S[I] in ['A'..'Z'])
      then S[I] := Chr(Ord(S[I]) + 32);

  LowerCase := S;

end;

{===================================================================}
Function ConstStr(C : Char; N : Integer) : String;

(*  ConstStr returns a string with N characters of value C *)

var
  S : String;

begin
  if N < 0 then
    N := 0;
  S := Take(N,S);
  FillChar(S[1],N,C);
  ConstStr := S;
end;

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
end;  { Function Power10}

{==================================================================}
Function Roundoff(Number : Extended;
                  NumPlaces : Integer) : Extended;

var
  I, FirstPlaceAfterDecimalPos, Pos,
  DeterminingDigit, DigitInt, ReturnCode : Integer;
  Digit : Real;
  Answer : Extended;
  AnswerStr, NumString : String;
  AddOne : Boolean;
  DigitStr : String;

begin
     {They can only round off up to 5 places.}

  If (NumPlaces > 6)
    then NumPlaces := 6;

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

end; { Function Roundoff....}

{============================================================================}
Function MakeYYYYMMDD (DateToConvert : String) : String;
{this procedure takes a key of form mmddyyyy and changes it to yyyymmdd}

begin
  Result := Copy(DateToConvert, 5, 4) + Copy(DateToConvert, 1, 5);
end;

{============================================================================}
Function MakeMMDDYYYY (DateToConvert : String) : String;
{this procedure takes a key of form YYYYMMDD and changes it to MMDDYYYY}

begin
  Result := Copy(DateToConvert, 5, 4) + Copy(DateToConvert, 1, 5);
end;

{============================================================================}
Function MakeMMDDYYYYSlashed (Date : String) : String;

{This takes a date in the form MMDDYYYY and returns a date in the form
 MM/DD/YYYY.}

Begin
  If (Deblank(Date) = '')
    then MakeMMDDYYYYSlashed := Take(10, '')
    else MakeMMDDYYYYSlashed := Copy(Date,1,2)+'/'+Copy(Date,3,2)+
                                '/'+Copy(Date,5,4);
end;

{============================================================================}
Function MakeMMDDYYYYSlashedShort(Date : String) : String;

{This takes a date in the form MMDDYYYY and returns a date in the form
 MM/DD/YY.}

Begin
  If (Deblank(Date) = '')
    then MakeMMDDYYYYSlashedShort := Take(8, '')
    else MakeMMDDYYYYSlashedShort := Copy(Date,1,2)+'/'+Copy(Date,3,2)+
                                     '/'+Copy(Date,7,2);
end;

{============================================================================}
Function MakeYYYYMMDDSlashed (Date : String) : String;

{This takes a date in the form  and returns a date in the form
 MM/DD/YYYY.}

Begin
  If (Deblank(Date) = '')
    then MakeYYYYMMDDSlashed := Take(10, '')
    else MakeYYYYMMDDSlashed := Copy(Date,5,2)+'/'+Copy(Date,7,2)+
                                '/'+Copy(Date,1,4);
end;

{============================================================================}
Function MMDDYYYYDateToYYYYMMDDSlashed (Date : String) : String;

{This takes a date in the form MM/DD/YYYY and returns a date in the form
 YYYY/MM/DD}

var
  MonthDay, Year : String;
  iLen : Integer;

begin
  If (Deblank(Date) = '')
    then Result := Take(10, '')
    else
    begin
      iLen := Length(Date);
      Year := Copy(Date, (iLen - 3), iLen);
      MonthDay := Copy(Date, 1, (iLen - 5));
      Result := Year + '/' + MonthDay;
    end;

end;  {MMDDYYYYDateToYYYYMMDDSlashed}

{============================================================================}
Function MakeYYYYMMDDSlashedShort(Date : String) : String;

{This takes a date in the form YYYYMMDD and returns a date in the form
 MM/DD/YY.}

Begin
  If (Deblank(Date) = '')
    then MakeYYYYMMDDSlashedShort := Take(8, '')
    else MakeYYYYMMDDSlashedShort := Copy(Date,5,2)+'/'+Copy(Date,7,2)+
                                     '/'+Copy(Date,3,2);
end;

{============================================================================}
Function ShiftRightAddZeroes(SourceStr : String) : String; overload;

var
  TempLen : Integer;

begin
  TempLen := Length(SourceStr);

  If (Deblank(SourceStr) = '')
    then SourceStr := ConstStr('0', TempLen)
    else
      while (SourceStr[TempLen] = ' ') do
        begin
          Delete(SourceStr, TempLen, 1);
          SourceStr := '0' + SourceStr;
        end;

  Result := SourceStr;

end;   {ShiftRightAddZeroes}

{============================================================================}
Function ShiftRightAddZeroes(SourceStr : String;
                             StrLength : Integer) : String; overload;

var
  TempLen : Integer;

begin
  SourceStr := Take(StrLength, Trim(SourceStr));
  TempLen := Length(SourceStr);

  If (Deblank(SourceStr) = '')
    then SourceStr := ConstStr('0', TempLen)
    else
      while (SourceStr[TempLen] = ' ') do
        begin
          Delete(SourceStr, TempLen, 1);
          SourceStr := '0' + SourceStr;
        end;

  Result := SourceStr;

end;   {ShiftRightAddZeroes}

{============================================================}
Function ShiftRightAddBlanks(SourceStr : String) : String;

var
  TempLen : Integer;

begin
  TempLen := Length(SourceStr);

  If (Deblank(SourceStr) = '')
    then SourceStr := Take(TempLen, SourceStr)
    else
      while (SourceStr[TempLen] = ' ') do
        begin
          Delete(SourceStr, TempLen, 1);
          SourceStr := ' ' + SourceStr;
        end;

  Result := SourceStr;

end;  {ShiftRightAddBlanks}

{============================================================================}
Function BoolToChar(AnyBoolean : Boolean) : Char;

begin

  If AnyBoolean
     then BoolToChar := 'Y'
     else BoolToChar := 'N';

end;  {BoolToChar}

{============================================================================}
Function BoolToChar_Blank_1(AnyBoolean : Boolean) : Char;

{Return blank for false and 1 for true.}

begin

  If AnyBoolean
     then Result := '1'
     else Result := ' ';

end;  {BoolToChar_Blank_1}

{============================================================================}
Function BoolToChar_Blank_Y(AnyBoolean : Boolean) : Char;

{Return blank for false and Y for true.}

begin

  If AnyBoolean
     then Result := 'Y'
     else Result := ' ';

end;  {BoolToChar_Blank_Y}

{============================================================================}
Function BoolToChar_Blank_X(AnyBoolean : Boolean) : Char;

{Return blank for false and X for true.}

begin

  If AnyBoolean
     then Result := 'X'
     else Result := ' ';

end;  {BoolToChar_Blank_X}

{FXX10201997-3: The ValidSaleCode was converted to a Boolean to fix a
                check box problem.}
{============================================================================}
Function BoolToChar_0_1(AnyBoolean : Boolean) : Char;

{Return blank for 0 and 1 for true.}

begin

  If AnyBoolean
     then Result := '1'
     else Result := '0';

end;  {BoolToChar_0_1}

{===========================================================================}
Function CharToBool(YNChar : Char) : Boolean;

begin
  If (YNChar = 'Y')
     then CharToBool := True
     else CharToBool := False;

end;  {CharToBool}

{===========================================================================}
Function BoolToStr(AnyBoolean : Boolean) : String;

{Return 'Yes' or 'No'}

begin
  If AnyBoolean
    then Result := 'Yes'
    else Result := 'No';

end;  {StrToBool}

{===========================================================================}
Function BoolToStr_True_False(AnyBoolean : Boolean) : String;

{Return 'True' or 'False'}

begin
  If AnyBoolean
    then Result := 'True'
    else Result := 'False';

end;  {BoolToStr_True_False}

{===========================================================================}
Function StrToBool(YNStr : String) : Boolean;

{FXX05151998-4: Return a True for a '1', 'Yes', 'Y', 'T' or 'True'.}

begin
  YNStr := Deblank(UpcaseStr(YNStr));

  If ((YNStr = 'Y') or
      (YNStr = 'YES') or
      (YNStr = '1') or
      (YNStr = 'T') or
      (YNStr = 'TRUE'))
     then StrToBool := True
     else StrToBool := False;

end;  {StrToBool}

{===========================================================================}
Function StrToBool_Blank_1(TempStr : String) : Boolean;

{Given a string where blank = false, 1 = true, convert it to
 a boolean.}

begin
  If (TempStr[1] = '1')
     then StrToBool_Blank_1 := True
     else StrToBool_Blank_1 := False;

end;  {StrToBool_Blank_1}

{===========================================================================}
Function StrToBool_0_1(TempStr : String) : Boolean;

{Given a string where 0 = false, 1 = true, convert it to
 a boolean.}

begin
  If (TempStr[1] = '1')
     then StrToBool_0_1 := True
     else StrToBool_0_1 := False;

end;  {StrToBool_0_1}

{==========================================================================}
Function ConvertNumberToText(Number : Integer) : String;

{Convert any number up to 9999 to text, i.e., 1 to 'one'.}

var
  NumberStr : String;
  Place,   {What place we are on right now, i.e. 1 = tens, 2 = hundreds, etc.}
  PlaceNum,  {The actual number in that place.}
  TempNumber : Integer;
  NeedExtraSpace, NeedDash, InTeens : Boolean;

begin
  NumberStr := '';
  NeedDash := False;
  NeedExtraSpace := False;

            {Find out the order of the number, and set the place setting :)
             i.e. 1 - tens, 2 - hundreds.}

  Place := 0;
  TempNumber := Number;

  repeat
    TempNumber := TempNumber Div 10;
    Place := Place + 1;
  until (TempNumber < 1);

      {Take care of zero seperately, since there is no other time that
       we want the phrase 'zero' to appear'.}

  If (Number = 0)
    then NumberStr := 'zero';

  repeat
    InTeens := False;

    Place := Place - 1;

    PlaceNum := Number Div Trunc(Power10(Place));

       {If the number is above one hundred, or below 10, then the leading
        part is 'one', 'two', etc. Between 10 and 99 is a special case.}

    If ((Number >= 100) or (Number < 10))
      then
        begin
          If NeedExtraSpace
            then NumberStr := NumberStr + ' ';

          If NeedDash
            then NumberStr := NumberStr + '-';

          case PlaceNum of
            1 : NumberStr := NumberStr + 'one';
            2 : NumberStr := NumberStr + 'two';
            3 : NumberStr := NumberStr + 'three';
            4 : NumberStr := NumberStr + 'four';
            5 : NumberStr := NumberStr + 'five';
            6 : NumberStr := NumberStr + 'six';
            7 : NumberStr := NumberStr + 'seven';
            8 : NumberStr := NumberStr + 'eight';
            9 : NumberStr := NumberStr + 'nine';
          end;  {case PlaceNum of}

        end;  {If ((Number > 100) or (Number < 10))}

    case Place of
              {Take care of numbers in the double digits.}
      1 : begin
            NeedExtraSpace := False;

                 {Don't want a dash if there is no entry in the second place.}
            If (PlaceNum <> 0)
              then NeedDash := True;

            case PlaceNum of
                1 : InTeens := True;
                2 : NumberStr := NumberStr + ' twenty';
                3 : NumberStr := NumberStr + ' thirty';
                4 : NumberStr := NumberStr + ' forty';
                5 : NumberStr := NumberStr + ' fifty';
                6 : NumberStr := NumberStr + ' sixty';
                7 : NumberStr := NumberStr + ' seventy';
                8 : NumberStr := NumberStr + ' eighty';
                9 : NumberStr := NumberStr + ' ninety';
            end;  {case PlaceNum of}

          end;  {Tens place}

      2 : begin
            NeedExtraSpace := True;
            NeedDash := False;
            NumberStr := NumberStr + ' hundred';
          end;

      3 : begin
            NeedExtraSpace := True;
            NeedDash := False;
            NumberStr := NumberStr + ' thousand';
          end;
    end;  {case Place of}

    If InTeens
      then
        begin
          Place := 0;  {Want to put this phrase, and then end.}

          case Number of
            10 : NumberStr := NumberStr + ' ten';
            11 : NumberStr := NumberStr + ' eleven';
            12 : NumberStr := NumberStr + ' twelve';
            13 : NumberStr := NumberStr + ' thirteen';
            14 : NumberStr := NumberStr + ' fourteen';
            15 : NumberStr := NumberStr + ' fifteen';
            16 : NumberStr := NumberStr + ' sixteen';
            17 : NumberStr := NumberStr + ' seventeen';
            18 : NumberStr := NumberStr + ' eighteen';
            19 : NumberStr := NumberStr + ' nineteen';
          end;  {case Number of}

        end;  {If InTeens}

        {Now reduce number by this amount.}
    Number := Number - (PlaceNum * Trunc(Power10(Place)));

  until ((Place = 0) or (Number = 0));

  NumberStr := LTrim(NumberStr);
  ConvertNumberToText := Take(Length(NumberStr), NumberStr);

end;  {ConvertNumberToText}

{============================================================================}
Function DezeroOnLeft(TempStr : String) : String;

var
  Done : Boolean;

begin
  Done := False;
  Result := Trim(TempStr);

  If (Result <> '')
    then
      repeat
        try
          If (Result[1] = '0')
            then Delete(Result, 1, 1);
        except
          Done := True;
        end;

        try
          If ((Result[1] <> '0') or
              (Result = ''))
            then Done := True;
        except
          Done := True;
        end;

      until Done;

  Result := Trim(Result);

end;  {DezeroOnLeft}

{============================================================================}
Function DeZeroOnRight(Arg : String) : String;

{DS: Strips leading zeros from a section block and lot string - each
     sub part individually...}
Var
  L : Integer;
  Stop : Boolean;
  Lgn, Pos : Integer;

Begin
  L := Length(Arg); { set length}
  Stop := False;

  If (Arg[L] <> '0')
    then Stop := True;

  If (not Stop)
    then
      begin
        repeat {Until we hit a non zero character or get to End of string    }
          Delete(Arg,L,1); { delete leading char, It was a zero }
          L := L - 1; { the string just got one byte shorter..}

          If (L = 0)
            then Stop := True;

          If (Arg[L] <> '0')
            then Stop := True;

        until Stop;

      end; { If Not Stop }

    {Move RTrim to here.}
    {FXX05041998-5: Call stack was getting too deep, had to move some code here.}

  Lgn := Length(Arg);
  Pos := Lgn;

  while ((Pos >= 1) and
         (Arg[Pos] = ' ')) do
    begin
      Delete(Arg, Pos, 1);
      Pos := Pos - 1;
    end;

  {FXX05051998-2: Fix change made in 05041998-5 - setting to wrong result.}

(*  Res := Rtrim(Arg); *)
  DeZeroOnRight := Arg; { Set Function Value }

end;  {DezeroOnRight}

{============================================================================}
Function MakeYYYYMMDDTextDate(Date : String) : String;

{Take a date in the form YYYYMMDD and make into text such as March 17, 1994.}

var
  DateStr : String;
  Month, Code : Integer;
  MonthStr, DayStr : String;
  YearStr : String;

begin
  If (Deblank(Date) <> '')
    then
      begin
        DateStr := '';

             {Figure out what month this is.}
        MonthStr := Copy(Date, 5, 2);
        Val(MonthStr, Month, Code);

        DateStr := DateStr + RTrim(LongMonths[Month]);

             {Now do the day.}
        DayStr := Copy(Date, 7, 2);
        DateStr := DateStr + ' ' + DeZeroOnLeft(DayStr);

             {Now do the year.}
        YearStr := Copy(Date, 1, 4);
        DateStr := DateStr + ', ' + YearStr;

      end;  {If (Deblank(Date) <> '')}

  MakeYYYYMMDDTextDate := DateStr;

end;  {MakeYYYYMMDDTextDate}

{============================================================================}
Function MakeMMDDYYYYTextDate(Date : String) : String;

{Take a date in the form MMDDYYYY and make into text such as March 17, 1994.}

var
  DateStr : String;
  Month, Code : Integer;
  MonthStr, DayStr : String;
  YearStr : String;

begin
  If (Deblank(Date) <> '')
    then
      begin
        DateStr := '';

             {Figure out what month this is.}
        MonthStr := Copy(Date, 1, 2);
        Val(MonthStr, Month, Code);

        DateStr := DateStr + RTrim(LongMonths[Month]);

             {Now do the day.}
        DayStr := Copy(Date, 3, 2);
        DateStr := DateStr + ' ' + DeZeroOnLeft(DayStr);

             {Now do the year.}
        YearStr := Copy(Date, 5, 4);
        DateStr := DateStr + ', ' + YearStr;

    end;  {If (Deblank(Date) <> '')}

  MakeMMDDYYYYTextDate := DateStr;

end;  {MakeMMDDYYYYTextDate}

{============================================================================}
Function ConvertToDisplayTime(Time : String) : String;

var
  DisplayTime : String;
  Hour, Min : String;
  HourInt, ReturnCode : Integer;

begin
  DisplayTime := Take(5, '');

  Hour := Copy(Time, 1, 2);
  Val(Hour, HourInt, ReturnCode);

  If (HourInt = 0)
    then Hour := ShiftRightAddZeroes(Hour)
    else Hour := ShiftRightAddBlanks(Take(2, DezeroOnLeft(Hour)));

  Min := Copy(Time, 3, 2);

  DisplayTime := Take(2, Hour) + ':' + Take(2, Min);

  If (Deblank(Time) = '')
    then ConvertToDisplayTime := Take(5, '')
    else ConvertToDisplayTime := Take(5, DisplayTime);

end;  {ConvertToDisplayTime}

{============================================================================}
Procedure CheckTimeStr(    Time : String;
                       var ReturnCode : Integer);

{This procedure checks to see if the person entered a valid 24-hour time
 in the form HH:MM. H:MM is also a valid entry. If the entry was valid,
 the return code is zero. Otherwise, the return is non-zero.}

var
  Hour, Min : String;
  ValidTime : Boolean;
  I, Len, Code, ColonPos : Integer;
  HourInt, MinInt : Integer;

begin
  ValidTime := True;
  ColonPos := 0;

  Time := RTrim(Time);
  Time := LTrim(Time);

  Len := Length(Time);

  If (Len > 5)
    then ValidTime := False;

  If ValidTime
    then
      For I := 1 to Len do
        If (Time[I] = ':')
          then ColonPos := I;

  If ((ColonPos <> 2) and
      (ColonPos <> 3))
    then ValidTime := False;

  If ValidTime
    then
      begin
        Hour := Copy(Time, 1, (ColonPos - 1));
        Min := Copy(Time, (ColonPos + 1), (Len - ColonPos));

        Val(Hour, HourInt, Code);

        If ((Code <> 0) or
            (HourInt > 23) or (HourInt < 0))
          then ValidTime := False;

        Val(Min, MinInt, Code);

        If ((Code <> 0) or
            (MinInt > 59) or (MinInt < 0))
          then ValidTime := False;

      end;

  If ValidTime
    then ReturnCode := 0
    else ReturnCode := 99;

end;  {CheckTimeStr}

{============================================================================}
Function ConvertTo24HourTime(Time : String) : String;

{This Function takes a 24-hour time in the form HH:MM and returns HHMM.}

var
  TwentyFourHourTime : String;
  Hour, Min : String;
  I, Len, ColonPos : Integer;

begin
  ColonPos := 0;

  Time := RTrim(Time);
  Time := LTrim(Time);

  Len := Length(Time);

  For I := 1 to Len do
    If (Time[I] = ':')
      then ColonPos := I;

  Hour := Copy(Time, 1, (ColonPos - 1));
  Hour := ShiftRightAddZeroes(Take(2, Hour));

  Min := Copy(Time, (ColonPos + 1), (Len - ColonPos));
  Min := ShiftRightAddZeroes(Take(2, Min));

  TwentyFourHourTime := Hour + Min;

  ConvertTo24HourTime := Take(4, TwentyFourHourTime);

end;  {ConvertTo24HourTime}

{===========================================================================}
Function MoveDateAhead(Date : String;  {MMDDYYYY}
                       Interval : Integer;  {In months}
                       RollAhead : Boolean) : String;   {Returns MMDDYYYY}

{The RollAhead variable says whether or not a date at the end of the month
 should move ahead to the next month if a date ends up past the end of the
 month. For instance, if the date is January 31st and we want to move ahead
 one month, RollAhead=true will return a date of March 1, but RollAhead=false
 will return a date of February 28th.}

var
  NewDate : String;
  Year : String;
  Month, Day : String;
  ReturnCode, YearInt, MonthInt, DayInt : Integer;

begin
  Year := Copy(Date, 5, 4);
  Month := Copy(Date, 1, 2);
  Day := Copy(Date, 3, 2);

  Val(Year, YearInt, ReturnCode);
  Val(Month, MonthInt, ReturnCode);
  Val(Day, DayInt, ReturnCode);

     {Add the interval to the month. If greater than 13, we are in a new year.}

  MonthInt := MonthInt + Interval;

  while (MonthInt > 12) do
    begin
      MonthInt := MonthInt - 12;
      YearInt := YearInt + 1;
    end;

  If (DayInt > LengthOfMonths[MonthInt])
    then
      If RollAhead
        then
          begin
            DayInt := 1;
            MonthInt := MonthInt + 1;

            while (MonthInt > 13) do
              begin
                MonthInt := MonthInt - 12;
                YearInt := YearInt + 1;
              end;

          end
        else DayInt := LengthOfMonths[MonthInt];

  Str(DayInt:2, Day);
  Day := ShiftRightAddZeroes(Take(2, Day));
  Str(MonthInt:2, Month);
  Month := ShiftRightAddZeroes(Take(2, Month));
  Str(YearInt:4, Year);

  NewDate := Take(2, Month) + Take(2, Day) + Take(4, Year);

  MoveDateAhead := Take(8, NewDate);

end;  {MoveDateAhead}

{============================================================================}
Function NumMembersInSet(Subset : CharSet) : Integer;

var
  I, NumMembers : Integer;

begin
  NumMembers := 0;

  For I := 0 to 255 do
    If (Chr(I) in Subset)
      then NumMembers := NumMembers + 1;

  NumMembersInSet := NumMembers;

end;  {NumMembersInSet}

{============================================================================}
Function ListMembers(Subset : Charset) : String;

{Given a set of characters, return a string listing those characters.}

var
  MemberStr : String;
  I : Integer;

begin
  MemberStr := '';

  For I := 0 to 255 do
    If (Chr(I) in Subset)
      then MemberStr := MemberStr + Chr(I);

  ListMembers := MemberStr;

end;  {ListMembers}

{============================================================================}
Function ListMembersFormatted(Subset : Charset) : String;

{Given a set of characters, return a string listing those characters, seperated
 by commas.}

var
  MemberStr : String;
  I : Integer;

begin
  MemberStr := '';

  For I := 0 to 255 do
    If (Chr(I) in Subset)
      then
        If (Deblank(MemberStr) = '')
          then MemberStr := MemberStr + Chr(I)
          else MemberStr := MemberStr + ', ' + Chr(I);

  ListMembersFormatted := MemberStr;

end;  {ListMembersFormatted}

{===========================================================================}
Procedure Permute(FixedChars,
                  ToBePermuted : String);

{Permute numbers or letters (up to 9 of them easily, and more then that with
 a little trickery). To use this, pass call the procedure with a blank string
 for the FixedChars var, and the string with the items to be permuted
 for the ToBePermuted var. For example, to permute the numbers 1 to 5,
 use Permute('', '12345'), or 'A' -> 'G', use Permute('', 'ABCDEFG').
 (Note that the order does not matter -> '21345' works the same as '12345').
 To do more than 9 objects, or to permute groups, use one char. representations,
 i.e. for 12 objects, try Permute('', '123456789ABC') and substitute 10 for A,
 etc. after it runs. Sorry if this seems a bit awkward -> Lisp is a better
 language for this type of operation.}

var
  I, ToBePermutedStrLen : Integer;
  TempToBePermuted : String;

begin
  ToBePermutedStrLen := Length(ToBePermuted);

  If (ToBePermutedStrLen = 2)
    then
      begin
        Writeln(FixedChars, ToBePermuted[1], ToBePermuted[2]);
        Writeln(FixedChars, ToBePermuted[2], ToBePermuted[1]);
      end
    else
      For I := 1 to ToBePermutedStrLen do
        begin
          TempToBePermuted := ToBePermuted;
          Delete(TempToBePermuted, I, 1);
          Permute((FixedChars + ToBePermuted[I]), TempToBePermuted);
        end;

end;  {Permute}

{============================================================================}
Function ValidYearEntry(Year : String) : Boolean;

var
  ReturnCode, YearNum : Integer;
  ValidEntry : Boolean;

begin
  ValidEntry := False;

  Val(Year, YearNum, ReturnCode);

  If (ReturnCode = 0)
    then
      If ((YearNum > 1980) and (YearNum < 2100))
        then ValidEntry := True;

  ValidYearEntry := ValidEntry;

end;  {ValidYearEntry}

{==========================================================================}
Function Format24HourTime(Time : String) : String;

{This Function takes a 24 hr time input in the form HHMMSS and returns
 HH:MM:SS am (or pm).}

var
  FormatedTime : String;
  Hour,
  Suffix : String;
  HourInt,
  ReturnCode : Integer;

begin
  Hour := Copy(Time, 1, 2);
  Val(Hour, HourInt, ReturnCode);

  If (HourInt < 12)
    then Suffix := 'am'
    else Suffix := 'pm';

  If (HourInt = 0)
    then HourInt := 12;

  If (HourInt > 12)
    then HourInt := HourInt - 12;

  Str(HourInt:2, Hour);

  FormatedTime := Take(2, Hour) + ':' + Copy(Time, 3, 2) + '.' +
                  Copy(Time, 5, 2) + ' ' + Take(2, Suffix);

  Format24HourTime := Take(11, FormatedTime);

end;  {Format24HourTime}

{===========================================================================}
Function CalcYearsDiff(Date1, Date2 : String) : Integer;

{Given two dates in the form MMDDYYYY, calculate the difference between
 the two dates. If Date1 > Date2, then the answer is negative.}

var
  NumYears : Integer;

begin
  If ((Date1 = Date2) or
      (Deblank(Date1) = '') or
      (Deblank(Date2) = ''))
    then NumYears := 0
    else
      If (MakeYYYYMMDD(Date1) > MakeYYYYMMDD(Date2))
        then NumYears := -1 * CalcYearsDiff(Date2, Date1)
        else
          begin
            NumYears := 0;

            repeat
                {Move the lower date ahead 1 year and see if it is greater
                 then the later date. If not, add one year.}

              Date1 := MoveDateAhead(Date1, 12, False);

              If (MakeYYYYMMDD(Date1) <= MakeYYYYMMDD(Date2))
                then NumYears := NumYears + 1;

            until ((MakeYYYYMMDD(Date1) > MakeYYYYMMDD(Date2)))

          end;  {else of If (Date1 > Date2)}

  CalcYearsDiff := NumYears;

end;  {CalcYearsDiff}


{==========================================================================}
Function GetCommandLine : String;

var
  I : Integer;
  CommandLine : String;

begin
  CommandLine := '';

  For I := 1 to ParamCount do
    CommandLine := CommandLine + ParamStr(I) + ' ';

  GetCommandLine := CommandLine;

end;  {GetCommandLine}

{==========================================================================}
Function MaxInt(Int1,
                Int2 : Integer) : Integer;

begin
  If (Int1 > Int2)
    then MaxInt := Int1
    else MaxInt := Int2;

end;  {MaxInt}

{==========================================================================}
Function MaxComp(Comp1,
                 Comp2 : Comp) : Comp;

begin
  If (Comp1 > Comp2)
    then MaxComp := Comp1
    else MaxComp := Comp2;

end;  {MaxComp}

{==========================================================================}
Function MaxExtended(Extended1,
                 Extended2 : Extended) : Extended;

begin
  If (Extended1 > Extended2)
    then MaxExtended := Extended1
    else MaxExtended := Extended2;

end;  {MaxExtended}

{==========================================================================}
Function MinInt(Int1,
                Int2 : Integer) : Integer;

begin
  If (Int1 < Int2)
    then MinInt := Int1
    else MinInt := Int2;

end;  {MinInt}

{==========================================================================}
Function MaxInt2(const IntArray : Array of Integer) : Integer;

{Find the largest integer of any number of integers.}

var
  I, Largest : Integer;

begin
  Largest := -32000;

  For I := 0 to High(IntArray) do
    If (IntArray[I] > Largest)
      then Largest := IntArray[I];

  MaxInt2 := Largest;

end;  {MaxInt2}

{==========================================================================}
Function MaxExtended2(const ExtendedArray : Array of Extended) : Extended;

{Find the largest Extended of any number of Extended.}

var
  I : Integer;
  Largest : Extended;

begin
  Largest := -99999999999.;

  For I := 0 to High(ExtendedArray) do
    If (ExtendedArray[I] > Largest)
      then Largest := ExtendedArray[I];

  MaxExtended2 := Largest;

end;  {MaxExtended2}

{==========================================================================}
Function ReturnOrdinal(Num : Integer) : String;

begin
  case Num of
    1 : ReturnOrdinal := 'First';
    2 : ReturnOrdinal := 'Second';
    3 : ReturnOrdinal := 'Third';
    4 : ReturnOrdinal := 'Fourth';
    5 : ReturnOrdinal := 'Fifth';
    6 : ReturnOrdinal := 'Sixth';
    7 : ReturnOrdinal := 'Seventh';
    8 : ReturnOrdinal := 'Eighth';
    9 : ReturnOrdinal := 'Ninth';
    10: ReturnOrdinal := 'Tenth';

  end;  {case Num of}

end;  {ReturnOrdinal}

{==========================================================================}
Function StartsWith(Substring,
                    MainString : String) : Boolean;

{Does the main string start with the substring?}

var
  Found : Boolean;
  LengthSubString : Integer;

begin
  Found := False;
  LengthSubString := Length(SubString);

  If (Take(LengthSubString, SubString) = Take(LengthSubString, Copy(MainString, 1, LengthSubString)))
    then Found := True;

  StartsWith := Found;

end;  {StartsWith}

{==========================================================================}
Function ContainedIn(Substring,
                     MainString : String) : Boolean;

{Can we find the substring anywhere in the mainstring?}

var
  Found : Boolean;
  I, LengthSubString, LengthMainString : Integer;

begin
  Found := False;
  LengthSubString := Length(SubString);
  LengthMainString := Length(MainString);

  For I := 1 to (LengthMainString - LengthSubString + 1) do
    If StartsWith(SubString, Take(LengthSubString, Copy(MainString, I, LengthSubString)))
      then Found := True;

  ContainedIn := Found;

end;  {ContainedIn}

{=========================================================================}
Function ExtractField(SearchRec : String;
                      StartPos,
                      Len : Integer) : String;

var
  Pos, LenSearchRec : Integer;
  ExtractedString : String;

begin
  ExtractedString := '';
  Pos := StartPos;
  LenSearchRec := Length(SearchRec);

    {Now let's get either the new Len characters from the search string
     or just until we hit the end of the string.}

  while ((Pos <= (StartPos + Len - 1)) and
         (Pos <= LenSearchRec)) do
    begin
      ExtractedString := ExtractedString + SearchRec[Pos];
      Pos := Pos + 1;
    end;

  ExtractField := Take(Len, ExtractedString);

end;  {ExtractField}

{============================================================================}
Procedure ReadLineFromTextFile(var OutputFile : Text;
                               var FirstCharOfNextLine : Char;
                               var LineFeedLastLine : Boolean;
                               var PrintLine : String);

{Read a line from a text file char. by char. so that we are sure to get any
 carriage return (#13) or line feed at the end of the line.}

var
  TempChar : Char;
  DoneLine : Boolean;

begin
  PrintLine := '';
  DoneLine := False;

  If not LineFeedLastLine
    then PrintLine := FirstCharOfNextLine;

  repeat
    Read(OutputFile, TempChar);

    PrintLine := PrintLine + TempChar;

    If EOF(OutputFile)
      then DoneLine := True;

      {If we found a carriage return (#13), then we need to see if the
       next char. is a line feed #10. If it is, then include it in the
       line. If not, then we need to keep track of the last character
       read since this is the first char. of the next line.}

    If ((TempChar = #13) and (not DoneLine))
      then
        begin
          Read(OutputFile, TempChar);

          If (TempChar = #10)
            then
              begin
                PrintLine := PrintLine + TempChar;
                LineFeedLastLine := True;
              end
            else
              begin
                FirstCharOfNextLine := TempChar;
                LineFeedLastLine := False;
              end;

          DoneLine := True;

        end;  {If ((TempChar = #13) and (not Done))}

  until DoneLine;

end;  {ReadLineFromTextFile}

{============================================================================}
Function IntPower(Base, Exponent : Integer) : LongInt;

var
  I : Integer;
  Value : Longint;

begin
  Value := 1;

  For I := 1 to Exponent do
    Value := Value * Base;

  IntPower := Value;

end;  {IntPower}

{================================================================================}
Function StripColon(MainString : String) : String;

begin
  If (MainString[Length(MainString)] = ':')
    then Delete(MainString, Length(MainString), 1);

  Result := MainString;

end;

{===============================================================}
Function StringIsNumeric(Text : String) : Boolean;

var
  I : Integer;

begin
  Result := True;

  For I := 1 to Length(Text) do
    If not (Text[I] in Numbers)
      then Result := False;

end;  {StringIsNumeric}

{===============================================================}
Function StringIsAlphabetic(Text : String) : Boolean;

var
  I : Integer;

begin
  Result := True;
  Text := Trim(Text);

  For I := 1 to Length(Text) do
    If not (Text[I] in Letters)
      then Result := False;

end;  {StringIsAlphabetic}

{=======================================================================}
Function StripChar(Text : String;
                   CharToRemove,
                   ReplacementChar : Char;
                   ReplaceChar : Boolean) : String;

{Strip out any occurrences of CharToRemove in Text and replace it with
 ReplacementChar.
 -- Only replace if ReplaceChar is True}

var
  I, Position, Len : Integer;

begin
  Len := Length(Text);
  Position := -1;

  For I := 1 to Len do
    If (Text[I] = CharToRemove)
      then Position := I;

  If (Position > 0)
    then
      If ReplaceChar
        then Text[Position] := ReplacementChar
        else Delete(Text, Position, 1);

  Result := Text;

end;  {StripTildes}

{=======================================================================}
Function StripChars(sSource : String;
                    aCharsToRemove : Charset;
                    cReplacement : Char;
                    bReplaceCharacter : Boolean) : String;

{Strip out any occurrences of any character in the aCharsToRemove in sSource and replace it with
 cReplacement.
 -- Only replace if bReplaceCharacter is True}

var
  I, iLen : Integer;

begin
  iLen := Length(sSource);

  For I := iLen downto 1 do
    If (sSource[I] in aCharsToRemove)
      then
        If bReplaceCharacter
          then sSource[I] := cReplacement
          else Delete(sSource, I, 1);

  Result := sSource;

end;  {StripChars}

{================================================================}
Function FindLastSpace(Source : String) : Integer;

{What is the position of the last space in the string?
 A return of zero means no space was found.}

var
  I : Integer;
  SpaceFound : Boolean;

begin
  Result := 0;
  SpaceFound := False;
  I := Length(Source);

  while ((I > 0) and
         (not SpaceFound)) do
    begin
      If (Source[I] = ' ')
        then
          begin
            SpaceFound := True;
            Result := I;
          end;

      I := I - 1;

    end;  {while ((I > 0) and ...}


end;  {FindLastSpace}

{================================================================}
Function ParseIntoLines(Source : String;
                        LineLength : Integer) : String; overload;

{Given a string with words in it, divide up the string into as
 many lines as necessary in order to fit it in lines of width
 LineLength. To do this, we will search through the string and
 insert CR where necessary.}

var
  LastSpacePos, SourcePos : Integer;
  SubStr : String;

begin
  Result := '';
  SubStr := '';
  SourcePos := 1;

    {The approach is this: Go through creating a substring of length
     LineLength. Then determine if this line should be split across two
     lines. If it should be, then split it and set the cursor back
     to the start of the word that is split across lines.}

  while (SourcePos <= Length(Source)) do
    begin
      SubStr := SubStr + Source[SourcePos];

      If (Length(SubStr) = LineLength)
        then
          begin
              {Find out where the last space in the sub string is.
               This tells us where to break the line.}

            LastSpacePos := FindLastSpace(SubStr);

              {If the last char. in the substring is a space,
               then we will break right here.}

            If (LastSpacePos = LineLength)
              then
                begin
                  If (SourcePos = Length(Source))
                    then Result := Result + SubStr
                    else Result := Result + SubStr + #13;
                end
              else
                begin
                    {The last character is not a space, so we want
                     to put a carriage return right before this word
                     occurred. Then we will position the cursor
                     (SourcePos) to start with this word that was broken across
                     lines. The exception is if there is one word which takes up
                     the whole line in which case we will make a cr after this
                     word and move the cursor one space forward to skip the
                     blank after this word.}

                  If (LastSpacePos = 0)
                    then Result := Result + Copy(SubStr, 1, LineLength) + #13
                    else Result := Result + Copy(SubStr, 1, (LastSpacePos - 1)) + #13;

                    {Reset the source pos to be the beggining of the
                     word that was cut off.}

                  If (LastSpacePos = 0)
                    then SourcePos := SourcePos + 1
                    else SourcePos := SourcePos - (LineLength - LastSpacePos);

                end;  {else of If (Source[I] = ' ')}

            SubStr := '';

          end;  {If (Length(SubStr) = LineLength)}

      SourcePos := SourcePos + 1;

    end;  {while (I <= Length(Source)) do}

  Result := Result + SubStr;

end;  {ParseIntoLines}

{================================================================}
Procedure ParseIntoLines(Source : String;
                         LineLength : Integer;
                         LineList : TStringList;
                         BreakOnAmpersand : Boolean); overload;

{Given a string with words in it, divide up the string into as
 many lines as necessary in order to fit it in lines of width
 LineLength. To do this, we will search through the string and
 insert CR where necessary.}

var
  LastSpacePos, SourcePos, AmpersandPos : Integer;
  SubStr, CurrentString : String;
  HasAmpersand : Boolean;

begin
  LineList.Clear;
  SubStr := '';
  SourcePos := 1;
  CurrentString := '';

    {The approach is this: Go through creating a substring of length
     LineLength. Then determine if this line should be split across two
     lines. If it should be, then split it and set the cursor back
     to the start of the word that is split across lines.}

  while (SourcePos <= Length(Source)) do
    begin
      SubStr := SubStr + Source[SourcePos];

      If (Length(SubStr) = LineLength)
        then
          begin
              {Find out where the last space in the sub string is.
               This tells us where to break the line.}

            LastSpacePos := FindLastSpace(SubStr);
            AmpersandPos := Pos('&', SubStr);

              {If the last char. in the substring is a space,
               then we will break right here.}

            If ((BreakOnAmpersand and
                 (AmpersandPos = LineLength)) or
                (LastSpacePos = LineLength))
              then
                begin
                  CurrentString := CurrentString + SubStr;

                  If (SourcePos <> Length(Source))
                    then
                      begin
                        LineList.Add(Trim(CurrentString));
                        CurrentString := '';
                      end;

                end
              else
                begin
                    {The last character is not a space, so we want
                     to put a carriage return right before this word
                     occurred. Then we will position the cursor
                     (SourcePos) to start with this word that was broken across
                     lines. The exception is if there is one word which takes up
                     the whole line in which case we will make a cr after this
                     word and move the cursor one space forward to skip the
                     blank after this word.}

                  HasAmpersand := (BreakOnAmpersand and
                                   (AmpersandPos > 0));

                  If ((not HasAmpersand) and
                      (LastSpacePos = 0))
                    then CurrentString := CurrentString + Copy(SubStr, 1, LineLength)
                    else
                      If HasAmpersand
                        then CurrentString := CurrentString + Copy(SubStr, 1, AmpersandPos)
                        else CurrentString := CurrentString + Copy(SubStr, 1, (LastSpacePos - 1));

                  LineList.Add(Trim(CurrentString));
                  CurrentString := '';

                    {Reset the source pos to be the beggining of the
                     word that was cut off.}

                  If ((not HasAmpersand) and
                      (LastSpacePos = 0))
                    then SourcePos := SourcePos + 1
                    else
                      If HasAmpersand
                        then SourcePos := SourcePos - (LineLength - AmpersandPos)
                        else SourcePos := SourcePos - (LineLength - LastSpacePos);

                end;  {else of If (Source[I] = ' ')}

            SubStr := '';

          end;  {If (Length(SubStr) = LineLength)}

      SourcePos := SourcePos + 1;

    end;  {while (I <= Length(Source)) do}

  CurrentString := CurrentString + SubStr;
  LineList.Add(Trim(CurrentString));

end;  {ParseIntoLines}

{===============================================================}
Function YearEntryIsValid(Year : String) : Boolean;

{Check for a valid entry. Returns true if year is blank.}

var
  YearInt, ReturnCodeInt : Integer;

begin
  If (Deblank(Year) = '')
    then Result := True
    else
      begin
        Val(Year, YearInt, ReturnCodeInt);

        If (ReturnCodeInt = 0)
          then Result := (YearInt > 1500) and (YearInt < 3000)
          else Result := False;

      end;  {else of If (Deblank(Year) = '')}

end;  {YearEntryIsValid}

{==========================================================================}
Function DeleteChars(Text : String;
                     CharsToRemove : CharSet) : String;

{Delete all characters which are in the CharsToRemove set.}

var
  I, Len : Integer;

begin
  Len := Length(Text);

  For I := Len downto 1 do
    If (Text[I] in CharsToRemove)
      then Delete(Text, I, 1);

  Result := Text;

end;  {DeleteChars}

{===========================================================}
Function MakeMMDDYY(Date : TDateTime) : String;

{Given a date in the form of TDateTime, return a string
 MMDDYY.}

var
  Year, Month, Day : Word;
  YearStr, MonthStr, DayStr : String;

begin
  If (Date = 0)
    then Result := Take(6, '')
    else
      begin
        DecodeDate(Date, Year, Month, Day);
        YearStr := Copy(IntToStr(Year), 3, 2);
        MonthStr := ShiftRightAddZeroes(Take(2, IntToStr(Month)));
        DayStr := ShiftRightAddZeroes(Take(2, IntToStr(Day)));

        Result := MonthStr + DayStr + YearStr;
        Result := Take(6, Result);

      end;  {else of If (Date = 0)}

end;  {MakeMMDDYY}

{===========================================================}
Function MakeMMDDYYYYFromDateTime(Date : TDateTime) : String;

{Given a date in the form of TDateTime, return a string
 MMDDYYYY.}

var
  Year, Month, Day : Word;
  YearStr : String;
  MonthStr, DayStr : String;

begin
  If (Date = 0)
    then Result := Take(8, '')
    else
      begin
        DecodeDate(Date, Year, Month, Day);
        YearStr := IntToStr(Year);
        MonthStr := ShiftRightAddZeroes(Take(2, IntToStr(Month)));
        DayStr := ShiftRightAddZeroes(Take(2, IntToStr(Day)));

        Result := MonthStr + DayStr + YearStr;
        Result := Take(8, Result);

      end;  {else of If (Date = 0)}

end;  {MakeMMDDYYYYFromDateTime}

{===========================================================}
Function FormatRPSNumericString(Source : String;
                                SourceLen,
                                NumPlacesAfterDecimal : Integer) : String;

{Given a string with a real number (i.e. 9.87), format it
 according to RPS extract standards. The format is shifted
 right, zero filled, no decimal point with the last
 NumPlacesAfterDecimal digits being the mantissa (decimal part).}
{FXX12272001-1: Changed the type of TempInt from LongInt to Int64 because
                a source value in the 10 millions overflowed the LongInt.}

var
  TempNum : Double;
  TempInt : Int64;

begin
  If (Trim(Source) = '')
    then TempInt := 0
    else
      begin
          {Strip any $ or commas.}

        Source := StringReplace(Source, '$', '', [rfReplaceAll]);
        Source := StringReplace(Source, ',', '', [rfReplaceAll]);

        try
          TempNum := StrToFloat(Source);
          TempNum := Roundoff(TempNum, NumPlacesAfterDecimal);
        except
          TempNum := 0;
        end;

          {FXX03041998-14: To accomodate a bogus sales price of 999,999,999,999,
                           we need an exception handler to throw it away.}

        try
          TempInt := Trunc(Roundoff((TempNum * IntPower(10, NumPlacesAfterDecimal)), 0));
        except
          TempInt := 0;
        end;

      end;  {else of If (Deblank(Source) = '')}

  Result := ShiftRightAddZeroes(Take(SourceLen, IntToStr(TempInt)));

end;  {FormatRPSNumericString}

{===================================================================}
Function Center(S: String;
                Width : Integer): String;

{ Function Center removes leading and trailing blanks from }
{ a string, then pads it with blanks to center it within   }
{ a string of length Width.                                }


var
  I, J: Integer;

begin
  S:= Trim(S);
  {If String to Be centered is longer than width, adjust accordingly }
  If Length(S) > Width then S := Copy(S,1,Width);
  J:= (Width - Length(S)) div 2;
  for I:= 1 to J do
    S:= ' ' + S;
  while Length(S) < Width do
    S:= S + ' ';
  Center:= S;

end;  {Center}

{=======================================================================}
Function AddDirectorySlashes(Directory : String) : String;

{Make sure that this directory name starts and ends with a slash.
 If not, add it.}

begin
  If ((Directory[2] <> ':') and
      (Directory[1] <> '\'))
    then Directory := '\' + Directory;

  If (Directory[Length(Directory)] <> '\')
    then Directory := Directory + '\';

  Result := Directory;

end;  {AddDirectorySlashes}

{=======================================================================}
Function UpperCaseFirstChars(Source : String) : String;

{Upper case the first letters of each word, i.e. The Fox Jumps Over ...}

var
  I : Integer;

begin
  Source := LowerCase(Source);
  Result := '';

    {FXX03031999-1: Also upcase char if prev char was a dash.}

  For I := 1 to Length(Source) do
    If ((I = 1) or  {First char.}
        (Source[I - 1] = #32) or {or last char was blank }
        (Source[I - 1] = '-'))
      then Result := Result + Upcase(Source[I])
      else Result := Result + Source[I];

end;  {UpperCaseFirstChars}

{========================================================================}
Function RightJustify(SourceStr : String;
                      FinalLength : Integer) : String;

begin
  Result := ShiftRightAddBlanks(Take(FinalLength, SourceStr));
end;

{========================================================================}
Function LeftJustify(SourceStr : String;
                     FinalLength : Integer) : String;

begin
  Result := Take(FinalLength, SourceStr);
end;

{===========================================================================}
 Function GetAcres(Acres, Frontage, Depth : Double) : Double;


 begin
   If (Acres > 0)
     then Result := Roundoff(Acres, 3)
     else Result := Roundoff(((Frontage * Depth) / 43560), 3);

 end;  {GetAcres}

{===========================================================================}
 Function GetSquareFeet(Acres, Frontage, Depth : Double) : Double;


 begin
   If (Acres > 0)
     then Result := Acres * 43560
     else Result := Frontage * Depth;

 end;  {GetSquareFeet}

{===================================================================}
Function MoveDateTimeAhead(SourceDate : TDateTime;
                           YearsToAdd,
                           MonthsToAdd,
                           DaysToAdd : Integer) : TDateTime;

var
  Year, Month, Day: Word;

begin
  DecodeDate(SourceDate, Year, Month, Day);
  Year := Year + YearsToAdd;

  Day := Day + DaysToAdd;

  If (Day > 31)
    then
      begin
        Day := Day - 31;
        Month := Month + 1;
      end;

  Month := Month + MonthsToAdd;

  If (Month > 12)
    then
      begin
        Month := Month - 12;
        Year := Year + 1;
      end;

  Result := EncodeDate(Year, Month, Day);

end;  {MoveDateTimeAhead}

{===================================================================}
Function MoveDateTimeBackwards(SourceDate : TDateTime;
                               YearsToSubtract,
                               MonthsToSubtract,
                               DaysToSubtract : Integer) : TDateTime;

var
  Year, Month, Day: Word;

begin
  DecodeDate(SourceDate, Year, Month, Day);
  Year := Year - YearsToSubtract;

  Day := Day - DaysToSubtract;

  If (Day < 1)
    then
      begin
        Day := 31 - Day;
        Month := Month - 1;
      end;

  Month := Month + MonthsToSubtract;

  If (Month < 1)
    then
      begin
        Month := 12;
        Year := Year - 1;
      end;

  Result := EncodeDate(Year, Month, Day);

end;  {MoveDateTimeBackwards}

{====================================================================}
Function StripPath(Path : String) : String;

var
  Index : Integer;

begin
  while (Pos('\', Path) > 0) do
    begin
      Index := Pos('\', Path);
      Path := Copy(Path, (Index + 1), 100);
    end;

  Result := Path;

end;  {StripPath}

{====================================================================}
Function ReturnPath(Path : String) : String;

{Remove the file name from a path.}

var
  TempLen, Index : Integer;
  SlashFound : Boolean;

begin
  TempLen := Length(Path);
  Index := TempLen;
  SlashFound := False;

  while ((Index > 0) and
         (not SlashFound)) do
    If (Path[Index] = '\')
      then SlashFound := True
      else Index := Index - 1;

  If (Index = 0)
    then Result := ''
    else Result := Copy(Path, 1, Index);

end;  {ReturnPath}

{===============================================================================}
Function DeleteUpToChar(Substr,
                        SourceStr : String;
                        Inclusive : Boolean) : String;

var
  Index : Integer;

begin
  Index := Pos(Substr, SourceStr);

  If (Index = 0)
    then Result := ''
    else
      begin
        Result := SourceStr;

        If Inclusive
          then Delete(Result, 1, Index)
          else Delete(Result, 1, (Index - 1));

      end;  {else of If (Index = 0)}

end;  {DeleteUpToChar}

{===============================================================================}
Function GetUpToChar(Substr,
                     SourceStr : String;
                     Inclusive : Boolean) : String;

var
  Index : Integer;

begin
  Index := Pos(Substr, SourceStr);

  If (Index = 0)
    then Result := ''
    else
      If Inclusive
        then Result := Copy(SourceStr, 1, Index)
        else Result := Copy(SourceStr, 1, (Index - 1));

end;  {GetUpToChar}

{=======================================================================}
Procedure ReadLine(var TempFile : Text;
                   var TempStr : LineStringType);

var
  I, Index : Integer;
  TempChar : Char;

begin
  Index := 1;
  For I := 1 to MaxNumChars do
    TempStr[I] := #0;

  repeat
    Read(TempFile, TempChar);

    If not (TempChar in [#10, #13, #26])
      then
        begin
          TempStr[Index] := TempChar;
          Index := Index + 1;
        end;

  until (TempChar in [#10, #26]);  {LF or EOF}

end;  {ReadLine}

{=======================================================}
Function FindOccurrence(var TempStr : LineStringType;
                            StringToFind : String;
                            OccurrenceNo : Integer) : Integer;

var
  StrLength, I, J, NumFound : Integer;
  Matched : Boolean;

begin
  Result := 0;
  NumFound := 0;
  I := 1;
  StrLength := Length(StringToFind);

  while ((I <= (MaxNumChars - StrLength + 1)) and
         (NumFound < OccurrenceNo)) do
    begin
      Matched := True;

      For J := 0 to (StrLength - 1) do
        If (TempStr[I + J] <> StringToFind[J + 1])
          then Matched := False;

      If Matched
        then NumFound := NumFound + 1;

      If (NumFound = OccurrenceNo)
        then Result := I;

      I := I + 1;

    end;  {while ((I <= MaxNumChars) and ...}

end;  {FindOccurrence}

{===============================================================}
Function LineLength(var TempStr : LineStringType) : Integer;

var
  I : Integer;

begin
  Result := 0;
  For I := 1 to MaxNumChars do
    If (TempStr[I] <> #0)
      then Result := I;

end;  {LineLength}

{=======================================================}
Function ParseField(var TempStr : LineStringType;
                        FieldNo : Integer;
                    var EndOfLine : Boolean) : String;

{Return the FieldNo(th) field in a comma seperated string.}

var
  EndPos, TempPos, I, StartPos : Integer;

begin
  Result := '';
  EndOfLine := False;

  TempPos := Pos(',', TempStr);

    {CHG12232002-1: Allow for fixed column imports.}

  If (TempPos = 0)
    then
      begin
        EndPos := LineLength(TempStr);
        For I := 1 to EndPos do
          Result := Result + TempStr[I];
        EndOfLine := True;
        Result := Trim(Result);
      end
    else
      begin
        If (FieldNo = 1)
          then
            begin
              If (TempStr[1] = '"')
                then StartPos := 2
                else StartPos := 1;

            end
          else
            begin
              StartPos := FindOccurrence(TempStr, '",', (FieldNo - 1));

                {Skip the comma and ".}

              If (StartPos > 0)
                then StartPos := StartPos + 3;

            end;  {If (FieldNo = 1)}

        If (StartPos > 0)
          then
            begin
              EndPos := FindOccurrence(TempStr, '",', FieldNo);  {Find the next comma.}

              If (EndPos = 0)
                then
                  begin
                    EndPos := LineLength(TempStr) - 1;
                    EndOfLine := True;
                  end
                else EndPos := EndPos - 1;

              Result := '';

              For I := StartPos to EndPos do
                Result := Result + TempStr[I];

            end;  {If (StartPos > 0)}

      end;  {else of If (TempPos = 0)}

end;  {ParseField}

{==============================================================}
Function CalcMonthsDifference(FirstDate,
                              SecondDate : TDateTime) : Integer;

{Note this Function calculates the number of months difference without
 regard to the actual day in the month.}

var
  FirstYear, FirstMonth, FirstDay,
  SecondYear, SecondMonth, SecondDay : Word;

begin
  DecodeDate(FirstDate, FirstYear, FirstMonth, FirstDay);
  DecodeDate(SecondDate, SecondYear, SecondMonth, SecondDay);
  Result := SecondMonth - FirstMonth + 12 * (SecondYear - FirstYear);

end;  {CalcMonthsDifference}


{==============================================================}
Function FindFirstNonNumberInText(TempStr : String) : Integer;

var
  I : Integer;

begin
  Result := 0;

  For I := 1 to Length(TempStr) do
    If ((not (TempStr[I] in Numbers)) and
        (Result = 0))
      then Result := I;

end;  {FindFirstNonNumberInText}

{==============================================================}
Function ChangeLocationToLocalDrive(Location : String) : String;

begin
  If (Location[2] = ':')
    then Result := 'C' + Copy(Location, 2, 255)
    else Result := 'C:\' + Location;

end;  {ChangeLocationToLocalDrive}

{===============================================================}
Function GetExcelCellName(ColumnNumber,
                          RowNumber : Integer) : String;

var
  I, OrdValueForA : Integer;
  Found : Boolean;

begin
  Result := '';
  OrdValueForA := Ord('A');
  Found := False;

  I := 1;

  If (ColumnNumber > 26)
    then
      while (not Found) do
        begin
          If ((ColumnNumber >= ((I * 26) + 1)) and
              (ColumnNumber <= ((I + 1) * 26)))
             then
              begin
                Found := True;
                Result := Result + Chr(OrdValueForA + I - 1);
                ColumnNumber := ColumnNumber - (I * 26);
              end;  {For I := 1 to 25 do}

          I := I + 1;

        end;  {while (not Found) do}

  Result := Result + Chr(OrdValueForA + ColumnNumber - 1);

  Result := Result + IntToStr(RowNumber);

end;  {GetExcelCellName}

{======================================================================}
Function HexToInt(HexValue : String) : Integer;

begin
  Result := StrToInt('$' + HexValue);
end;

{======================================================================}
Procedure GetRGBValues(    Color : TColor;
                       var RedAmount : Integer;
                       var GreenAmount : Integer;
                       var BlueAmount : Integer);

var
  HexColor : String;

begin
  HexColor := IntToHex(Color, 6);
  RedAmount := HexToInt(Copy(HexColor, 5, 2));
  GreenAmount := HexToInt(Copy(HexColor, 3, 2));
  BlueAmount := HexToInt(Copy(HexColor, 1, 2));

end;  {GetRGBValues}

{===========================================================}
Function AddOneYear(TempDate : TDateTime) : TDateTime;

var
  Year, Month, Day : Word;

begin
  DecodeDate(TempDate, Year, Month, Day);
  Result := EncodeDate((Year + 1), Month, Day);
end;

{=============================================================}
Function BooleanToX_Blank(TempBoolean : Boolean) : String;

begin
  If TempBoolean
    then Result := 'X'
    else Result := ' ';

end;  {BooleanToX_Blank}

{==============================================================}
Procedure ReplaceOneStreetAbbreviation(var TempAddress : String;
                                           Abbreviation : String;
                                           Substitute : String);

begin
  If ((Pos(Abbreviation, TempAddress) > 0) and
      (Pos(Substitute, TempAddress) = 0))  {Don't make it STSTREET.}
    then TempAddress := StringReplace(TempAddress, Abbreviation, Substitute, [rfReplaceAll, rfIgnoreCase]);

end;  {ReplaceOneStreetAbbreviation}

{==============================================================}
Function ExpandAddress(TempAddress : String) : String;

{Now look for certain abbreviations in both strings and
 expand them, i.e. 'ST', 'RD', 'DR', 'CIR', 'CT'}

begin
  ReplaceOneStreetAbbreviation(TempAddress, 'ST', 'STREET');
  ReplaceOneStreetAbbreviation(TempAddress, 'DR', 'DRIVE');
  ReplaceOneStreetAbbreviation(TempAddress, 'CIR', 'CIRCLE');
  ReplaceOneStreetAbbreviation(TempAddress, 'CT', 'COURT');
  ReplaceOneStreetAbbreviation(TempAddress, 'RD', 'ROAD');
  ReplaceOneStreetAbbreviation(TempAddress, 'PL', 'PLACE');
  ReplaceOneStreetAbbreviation(TempAddress, 'AVE', 'AVENUE');
  ReplaceOneStreetAbbreviation(TempAddress, 'HWY', 'HIGHWAY');
  ReplaceOneStreetAbbreviation(TempAddress, 'RT', 'ROUTE');
  ReplaceOneStreetAbbreviation(TempAddress, 'LN', 'LANE');
  ReplaceOneStreetAbbreviation(TempAddress, 'LK', 'LAKE');
  ReplaceOneStreetAbbreviation(TempAddress, 'LA', 'LANE');
  ReplaceOneStreetAbbreviation(TempAddress, 'N ', 'NORTH ');
  ReplaceOneStreetAbbreviation(TempAddress, 'NO', 'NORTH');
  ReplaceOneStreetAbbreviation(TempAddress, 'E ', 'EAST ');
  ReplaceOneStreetAbbreviation(TempAddress, 'EA', 'EAST');
  ReplaceOneStreetAbbreviation(TempAddress, 'S ', 'SOUTH ');
  ReplaceOneStreetAbbreviation(TempAddress, 'SO', 'SOUTH');
  ReplaceOneStreetAbbreviation(TempAddress, 'W ', 'WEST ');
  ReplaceOneStreetAbbreviation(TempAddress, 'WE', 'WEST');
  Result := TempAddress;

end;  {ExpandAddress}

{========================================================================}
Function AddressMeetsRangeCriteria(StreetNumber : LongInt;
                                   Street : String;
                                   StartingStreetNumber : String;
                                   StartingStreet : String;
                                   EndingStreetNumber : String;
                                   EndingStreet : String) : Boolean;

var
  CompareStreetNumbers : Boolean;
  iStartingStreetNumber, iEndingStreetNumber : LongInt;

begin
  Result := False;

  try
    iStartingStreetNumber := StrToInt(StartingStreetNumber);
  except
    iStartingStreetNumber := 0;
  end;

  try
    iEndingStreetNumber := StrToInt(EndingStreetNumber);
  except
    iEndingStreetNumber := 0;
  end;

  Street := DeleteChars(Street, [',', '.', ':', '"']);
  StartingStreet := DeleteChars(StartingStreet, [',', '.', ':', '"']);
  EndingStreet := DeleteChars(EndingStreet, [',', '.', ':', '"']);

  Street := ExpandAddress(Street);
  StartingStreet := ExpandAddress(StartingStreet);
  EndingStreet := ExpandAddress(EndingStreet);

  CompareStreetNumbers := (_Compare(StartingStreetNumber, coNotBlank) or
                           _Compare(EndingStreetNumber, coNotBlank));

  If ((CompareStreetNumbers and
       _Compare(StreetNumber, iStartingStreetNumber, coGreaterThanOrEqual) and
       _Compare(StreetNumber, iEndingStreetNumber, coLessThanOrEqual)) or
      (not CompareStreetNumbers))
    then
      If (_Compare(Street, StartingStreet, coGreaterThanOrEqual) and
          _Compare(Street, EndingStreet, coLessThanOrEqual))
        then Result := True;

end;  {AddressMeetsRangeCriteria}

{$H+}
{==================================================================}
Function FormatExtractField(TempStr : String) : String;

begin
    {If there is an embedded quote, surrond the field in double quotes.}

  If (Pos(',', TempStr) > 0)
    then TempStr := '"' + TempStr + '"';

  Result := ',' + TempStr;

  {FXX02222013: Suppress CR\LF from extracts.}
  
  Result := StringReplace(Result, #13+#10, '  ', [rfReplaceAll]);

end;  {FormatExtractField}

{=================================================================}
Function VarRecToStr(VarRec : TVarRec) : String;

const
  BoolChars : Array[Boolean] of Char = ('F', 'T');

begin
  Result := '';

  with VarRec do
    case VType of
      vtInteger    : Result := IntToStr(VInteger);
      vtBoolean    : Result := BoolChars[VBoolean];
      vtChar       : Result := VChar;
      vtExtended   : Result := FloatToStr(VExtended^);
      vtString     : Result := VString^;
      vtPChar      : Result := VPChar;
      vtObject     : Result := VObject.ClassName;
      vtClass      : Result := VClass.ClassName;
      vtAnsiString : Result := string(VANSIString);
      vtCurrency   : Result := CurrToStr(VCurrency^);
      vtVariant    : Result := string(VVariant^);
      vtInt64      : Result := IntToStr(VInt64^);

    end;  {VarRec.VType}

end;  {VarRecToStr}

{==================================================================}
Procedure WriteCommaDelimitedLine(var ExtractFile : TextFile;
                                      Fields : Array of const);

var
  I : Integer;
  TempStr : String;

begin
  For I := 0 to High(Fields) do
    begin
      GlblCurrentCommaDelimitedField := GlblCurrentCommaDelimitedField + 1;
      TempStr := VarRecToStr(Fields[I]);

      If (GlblCurrentCommaDelimitedField = 1)
        then
          begin
            If (Pos(',', TempStr) > 0)
              then TempStr := '"' + TempStr + '"';

            Write(ExtractFile, TempStr);
          end
        else Write(ExtractFile, FormatExtractField(TempStr));

    end;  {For I := 0 to High(Fields) do}

end;  {WriteCommaDelimitedLine}

{==================================================================}
Procedure WritelnCommaDelimitedLine(var ExtractFile : TextFile;
                                        Fields : Array of const);

begin
  If (High(Fields) > -1)
    then WriteCommaDelimitedLine(ExtractFile, Fields);

  Writeln(ExtractFile);
  GlblCurrentCommaDelimitedField := 0;

end;  {WritelnCommaDelimitedLine}

{$H-}

{==========================================================================}
Function GetTemporaryFileName(Caption : String) : String;

{We want a unique file name, so we will use the first two letters of the
 form name plus the time down to the millisecond.}
{The form of the file name is xxHHMMSS.MM (Two letters\Hour\minute\second.millisecond)}

var
  Hour, Minute,
  Second, Millisecond : Word;

begin
  DecodeTime(Time, Hour, Minute, Second, Millisecond);

  Result := Caption +
            ShiftRightAddZeroes(Take(2, IntToStr(Hour))) +
            ShiftRightAddZeroes(Take(2, IntToStr(Minute))) +
            ShiftRightAddZeroes(Take(2, IntToStr(Second))) + '.' +
            ShiftRightAddZeroes(Take(2, IntToStr(Millisecond)));

end;  {GetTemporaryFileName}

{=============================================================}
Function GetNextWord(var TempStr : String) : String;

var
  I, DeleteLength : Integer;
  Done : Boolean;

begin
  Result := '';
  I := 1;
  DeleteLength := Length(TempStr);
  Done := False;

  while ((I <= Length(TempStr)) and
         (not Done)) do
    begin
      If (TempStr[I] = ' ')
        then
          begin
            Done := True;
            DeleteLength := I;
          end;

      If not Done
        then Result := Result + TempStr[I];

      I := I + 1;

    end;  {while ((I <= Length(TempStr)) and ...}

  Delete(TempStr, 1, DeleteLength);

    {Make sure to remove leading spaces.}

  TempStr := LTrim(TempStr);

end;  {GetNextWord}

{================================================}
Function ExpandStreetNameType(TempStr : String) : String;

begin
  Result := TempStr;

  If (TempStr = 'RD')
    then Result := 'ROAD';

  If (TempStr = 'CT')
    then Result := 'COURT';

  If (TempStr = 'PL')
    then Result := 'PLACE';

  If ((TempStr = 'AVE') or
      (TempStr = 'AV'))
    then Result := 'AVENUE';

  If (TempStr = 'ST')
    then Result := 'STREET';

  If (TempStr = 'WY')
    then Result := 'WAY';

  If (TempStr = 'W')
    then Result := 'WEST';

  If (TempStr = 'N')
    then Result := 'NORTH';

  If (TempStr = 'E')
    then Result := 'EAST';

  If (TempStr = 'S')
    then Result := 'SOUTH';

  If (TempStr = 'HGWY')
    then Result := 'HIGHWAY';

  If ((TempStr = 'RT') or
      (TempStr = 'RTE'))
    then Result := 'ROUTE';

  If (TempStr = 'CIR')
    then Result := 'CIRCLE';

  If (TempStr = 'BLVD')
    then Result := 'BOULEVARD';

  If ((TempStr = 'LN') or
      (TempStr = 'LA'))
    then Result := 'LANE';

  If (TempStr = 'PK')
    then Result := 'PARK';

  If (TempStr = 'JUNC')
    then Result := 'JUNCTION';

  If (TempStr = 'DR')
    then Result := 'DRIVE';

  If (TempStr = 'TERR')
    then Result := 'TERRACE';

end;  {ExpandStreetNameType}

{======================================================================}
Function ExtractPlainTextFromRichText(RichText : String;
                                      StripCarriageReturns : Boolean) : String;

var
  Index : Integer;

begin
  If (RichText = '')
    then Result := ''
    else
      begin
        Index := Pos('\fs', RichText);

        If (Index > 0)
          then
            begin
              Delete(RichText, 1, (Index + 5));
              Index := Pos('\f', RichText);

              If (Index > 0)
                then
                  begin
                    Delete(RichText, Index, 200);
                    Result := RichText;
                  end
                else Result := '';

              If (Result <> '')
                then Result := StringReplace(Result, '\par', '', [rfReplaceAll, rfIgnoreCase]);

            end
          else Result := RichText;

          {FXX07222003-2(2.07g): Make sure that the returned string is not the full 255 or it will not
                                 be able to put quotes on the beginning and end if it needs it.}

        If (Length(Result) > 250)
          then Result := Trim(Copy(Result, 1, 250));

        If (Result <> '')
          then Result := StringReplace(Result, Chr(13) + Chr(10), ' ', [rfReplaceAll, rfIgnoreCase]);

        If (StripCarriageReturns and
            (Result <> ''))
          then Result := StringReplace(Result, Chr(13), ' ', [rfReplaceAll, rfIgnoreCase]);

        If (StripCarriageReturns and
            (Result <> ''))
          then Result := StringReplace(Result, Chr(10), ' ', [rfReplaceAll, rfIgnoreCase]);

      end;  {else of If (RichText = '')}

end;  {ExtractPlainTextFromRichText(}

{========================================================================}
Function RemoveExtension(FileName : String) : String;

{Given a file name, return the file name without any extension.}

var
  I, DotPos : Integer;

begin
  DotPos := -1;
  Result := FileName;

  For I := Length(FileName) downto 1 do
    If ((DotPos = -1) and
        (FileName[I] = '.'))
      then DotPos := I;

    {If we found an extension, delete it.}

  If (DotPos > -1)
    then Delete(Result, DotPos, 255);

end;  {RemoveExtension}

{========================================================================}
Function GetExtension(FileName : String) : String;

{Given a file name, return the extension.}

var
  I, DotPos : Integer;

begin
  DotPos := -1;
  Result := '';

  For I := Length(FileName) downto 1 do
    If ((DotPos = -1) and
        (FileName[I] = '.'))
      then DotPos := I;

    {If we found an extension, delete it.}

  If (DotPos > -1)
    then Result := Copy(FileName, (DotPos + 1), 255);

end;  {GetExtension}


{$H+}
{===========================================================================}
Function StripLeadingAndEndingDuplicateChar(TempStr : String;
                                            CharToStrip : Char) : String;

begin
  Result := TempStr;

  If ((Length(Result) > 1) and
      (Result[1] = CharToStrip) and
      (Result[Length(Result)] = CharToStrip))
    then
      begin
        Delete(Result, Length(Result), 1);
        Delete(Result, 1, 1);
      end;

end;  {StripLeadingAndEndingDuplicateChar}
{$H-}

{$H+}
{===========================================================================}
Procedure ParseCommaDelimitedStringIntoFields(TempStr : String;
                                              FieldList : TStringList;
                                              CapitalizeStrings : Boolean);

var
  InEmbeddedQuote : Boolean;
  CurrentField : String;
  I : Integer;

begin
  FieldList.Clear;
  InEmbeddedQuote := False;
  CurrentField := '';

  For I := 1 to Length(TempStr) do
    begin
      If (TempStr[I] = '"')
        then InEmbeddedQuote := not InEmbeddedQuote;

        {New field if we have found comma and we are not in an embedded quote.}

      If ((TempStr[I] = ',') and
          (not InEmbeddedQuote))
        then
          begin
              {If the field starts and ends with a double quote, strip it.}

            CurrentField := StripLeadingAndEndingDuplicateChar(CurrentField, '"');

            If CapitalizeStrings
              then CurrentField := ANSIUpperCase(CurrentField);

            FieldList.Add(CurrentField);
            CurrentField := StringReplace(CurrentField, #255, '', [rfReplaceAll]);
            CurrentField := '';

          end
        else CurrentField := CurrentField + TempStr[I];

    end;  {For I := 1 to Length(TempStr) do}

  CurrentField := StripLeadingAndEndingDuplicateChar(CurrentField, '"');

  If CapitalizeStrings
    then CurrentField := ANSIUpperCase(Trim(CurrentField));

  CurrentField := StringReplace(CurrentField, #255, '', [rfReplaceAll]);

  FieldList.Add(Trim(CurrentField));

end;  {ParseCommaDelimitedStringIntoFields}
{$H-}

{$H+}
{===========================================================================}
Procedure ParseTabDelimitedStringIntoFields(TempStr : String;
                                            FieldList : TStringList;
                                            CapitalizeStrings : Boolean);

var
  CurrentField : String;
  TabPos : Integer;
  Done : Boolean;

begin
  FieldList.Clear;
  CurrentField := '';
  Done := False;

  while ((not Done) and
         (SysUtils.Trim(TempStr) <> '')) do
    begin
      TabPos := Pos(Chr(9), TempStr);

      If (TabPos = 0)
        then
          begin
            Done := True;
            CurrentField := TempStr;
          end
        else
          begin
            CurrentField := Copy(TempStr, 1, (TabPos - 1));
            Delete(TempStr, 1, TabPos);
          end;

      CurrentField := StripLeadingAndEndingDuplicateChar(CurrentField, '"');

      If CapitalizeStrings
        then CurrentField := ANSIUpperCase(CurrentField);

      CurrentField := StringReplace(CurrentField, #255, '', [rfReplaceAll]);

      FieldList.Add(Trim(CurrentField));
      CurrentField := '';

    end;  {while ((not Done) and ...}

end;  {ParseTabDelimitedStringIntoFields}
{$H-}

{$H+}
{===========================================================================}
Procedure ParseStringIntoFields(TempStr : String;
                                FieldList : TStringList;
                                Delimiter : String;
                                CapitalizeStrings : Boolean);

var
  CurrentField : String;
  DelimiterPos : Integer;
  Done : Boolean;

begin
  FieldList.Clear;
  CurrentField := '';
  Done := False;

  while ((not Done) and
         (SysUtils.Trim(TempStr) <> '')) do
    begin
      DelimiterPos := Pos(Delimiter, TempStr);

      If (DelimiterPos = 0)
        then
          begin
            Done := True;
            CurrentField := TempStr;
          end
        else
          begin
            CurrentField := Copy(TempStr, 1, (DelimiterPos - 1));
            Delete(TempStr, 1, DelimiterPos);
          end;

      CurrentField := StripLeadingAndEndingDuplicateChar(CurrentField, '"');

      If CapitalizeStrings
        then CurrentField := ANSIUpperCase(CurrentField);

      CurrentField := StringReplace(CurrentField, #255, '', [rfReplaceAll]);

      FieldList.Add(Trim(CurrentField));
      CurrentField := '';

    end;  {while ((not Done) and ...}

end;  {ParseStringIntoFields}
{$H-}

{===========================================================================}
Function GetMonthNumberForShortMonthName(Month : String) : Integer;

begin
  Result := 0;
  Month := ANSIUpperCase(Month);

  If (Month = 'JAN')
    then Result := 1;
  If (Month = 'FEB')
    then Result := 2;
  If (Month = 'MAR')
    then Result := 3;
  If (Month = 'APR')
    then Result := 4;
  If (Month = 'MAY')
    then Result := 5;
  If (Month = 'JUN')
    then Result := 6;
  If (Month = 'JUL')
    then Result := 7;
  If (Month = 'AUG')
    then Result := 8;
  If (Month = 'SEP')
    then Result := 9;
  If (Month = 'OCT')
    then Result := 10;
  If (Month = 'NOV')
    then Result := 11;
  If (Month = 'DEC')
    then Result := 12;

end;  {GetMonthNumberForShortMonthName}

{============================================================================}
Procedure ParseCityIntoCityAndState(var City : String;
                                    var State : String);

var
  LastTwoChars : String;
  ThirdToLastCharIsBlank : Boolean;

begin
  City := Trim(StringReplace(City, ',', '', [rfReplaceAll]));

    {Remove trailing period.}
    
  If _Compare(City[Length(City)], '.', coEqual)
    then Delete(City, Length(City), 1);

    {If the zip code is at the end, get rid of it.}

  while ((City[Length(City)] in Numbers) and
         _Compare(Length(City), 0, coGreaterThan)) do
    Delete(City, Length(City), 1);

  City := Trim(City);

  State := '';
  LastTwoChars := ANSIUpperCase(Copy(City, (Length(City) - 1), 2));

  ThirdToLastCharIsBlank := (City[Length(City) - 2] = ' ');

  If ((LastTwoChars[1] in Letters) and
      (LastTwoChars[2] in Letters) and
      ThirdToLastCharIsBlank)
    then
      begin
        State := LastTwoChars;
        Delete(City, (Length(City) - 2), 3);
        City := Trim(City);

      end;  {If ((LastTwoChars[1] in Letters) and ...}

end;  {ParseCityIntoCityAndState}

{============================================================================}
Function _Compare(String1,
                  String2 : String;
                  Comparison : Integer) : Boolean; overload;

{String compare}

var
  SubstrLen : Integer;

begin
  Result := False;
  String1 := ANSIUpperCase(Trim(String1));
  String2 := ANSIUpperCase(Trim(String2));

  case Comparison of
    coEqual : Result := (String1 = String2);
    coGreaterThan : Result := (String1 > String2);
    coLessThan : Result := (String1 < String2);
    coGreaterThanOrEqual : Result := (String1 >= String2);
    coLessThanOrEqual : Result := (String1 <= String2);
    coNotEqual :
    begin
      Result := (String1 <> String2);

      If (Result and
          (((String1 = '') and (String2 = '0')) or
           ((String1 = '0') and (String2 = ''))))
        then Result := False;

    end;

      {CHG11251997-2: Allow for selection on blank or not blank.}

    coBlank : Result := (Deblank(String1) = '');
    coNotBlank : Result := (Deblank(String1) <> '');
    coContains : Result := (Pos(Trim(String2), String1) > 0);

      {CHG09111999-1: Add starts with.}

    coStartsWith :
      begin
        String2 := Trim(String2);
        SubstrLen := Length(String2);
        Result := (Take(SubstrLen, String1) = Take(SubstrLen, String2));
      end;

    coDoesNotStartWith :
      begin
        String2 := Trim(String2);
        SubstrLen := Length(String2);
        Result := (Take(SubstrLen, String1) <> Take(SubstrLen, String2));
      end;

    coMatchesOrFirstItemBlank :
      begin
        If _Compare(String1, coBlank)
          then Result := True
          else Result := _Compare(String1, String2, coEqual);

      end;  {coMatchesOrFirstItemBlank}

    coMatchesPartialOrFirstItemBlank :
      begin
        If _Compare(String1, coBlank)
          then Result := True
          else
            If (Length(String1) > Length(String2))
              then Result := _Compare(String1, String2, coStartsWith)
              else Result := _Compare(String2, String1, coStartsWith);

      end;  {coMatchesPartialOrBlank}

    coEndsWith :
      begin
        String2 := Trim(String2);
        SubstrLen := Length(String2);
        Result := (Take(SubstrLen, Copy(String1, (Length(String1) - SubstrLen + 1), SubstrLen)) = Take(SubstrLen, String2));
      end;

  end;  {case Comparison of}

end;  {_Compare}

{============================================================================}
Function _Compare(Char1,
                  Char2 : Char;
                  Comparison : Integer) : Boolean; overload;

{Character compare}

begin
  Result := False;
  Char1 := UpCase(Char1);
  Char2 := UpCase(Char2);

  case Comparison of
    coEqual : Result := (Char1 = Char2);
    coGreaterThan : Result := (Char1 > Char2);
    coLessThan : Result := (Char1 < Char2);
    coGreaterThanOrEqual : Result := (Char1 >= Char2);
    coLessThanOrEqual : Result := (Char1 <= Char2);
    coNotEqual : Result := (Char1 <> Char2);
    coBlank : Result := (Char1 = ' ');
    coNotBlank : Result := (Char1 <> ' ');

  end;  {case Comparison of}

end;  {_Compare}

{============================================================================}
Function _Compare(      String1 : String;
                  const ComparisonValues : Array of const;
                        Comparison : Integer) : Boolean; overload;

{String compare - multiple values}

var
  I : Integer;
  String2 : String;

begin
  Result := False;
  String1 := ANSIUpperCase(Trim(String1));

  For I := 0 to High(ComparisonValues) do
    try
      String2 := ANSIUpperCase(Trim(VarRecToStr(ComparisonValues[I])));

      Result := Result or _Compare(String1, String2, Comparison);
    except
    end;

end;  {_Compare}

{============================================================================}
Function _Compare(String1 : String;
                  Comparison : Integer) : Boolean; overload;

{Special string version for blank \ non blank compare.
 Note that the regular string _Compare can be used too if the 2nd string is blank.}

begin
  Result := False;
  String1 := ANSIUpperCase(Trim(String1));

  case Comparison of
    coBlank : Result := (Deblank(String1) = '');
    coNotBlank : Result := (Deblank(String1) <> '');

  end;  {case Comparison of}

end;  {_Compare}

{============================================================================}
Function _Compare(Int1,
                  Int2 : LongInt;
                  Comparison : Integer) : Boolean; overload;

{Integer version}

begin
  Result := False;
  case Comparison of
    coEqual : Result := (Int1 = Int2);
    coGreaterThan : Result := (Int1 > Int2);
    coLessThan : Result := (Int1 < Int2);
    coGreaterThanOrEqual : Result := (Int1 >= Int2);
    coLessThanOrEqual : Result := (Int1 <= Int2);
    coNotEqual : Result := (Int1 <> Int2);

  end;  {case Comparison of}

end;  {_Compare}

{============================================================================}
Function _Compare(      Int1 : LongInt;
                  const ComparisonValues : Array of const;
                        Comparison : Integer) : Boolean; overload;

{Integer version}

var
  I : Integer;
  Int2 : LongInt;

begin
  Result := False;

  For I := 0 to High(ComparisonValues) do
    try
      Int2 := StrToInt(VarRecToStr(ComparisonValues[I]));
      Result := Result or _Compare(Int1, Int2, Comparison);
    except
    end;

end;  {_Compare}

{============================================================================}
Function _Compare(Real1,
                  Real2 : Extended;
                  Comparison : Integer) : Boolean; overload;

{Float version}

begin
  Result := False;
  case Comparison of
    coEqual : Result := (Roundoff(Real1, 4) = Roundoff(Real2, 4));
    coGreaterThan : Result := (Roundoff(Real1, 4) > Roundoff(Real2, 4));
    coLessThan : Result := (Roundoff(Real1, 4) < Roundoff(Real2, 4));
    coGreaterThanOrEqual : Result := (Roundoff(Real1, 4) >= Roundoff(Real2, 4));
    coLessThanOrEqual : Result := (Roundoff(Real1, 4) <= Roundoff(Real2, 4));
    coNotEqual : Result := (Roundoff(Real1, 4) <> Roundoff(Real2, 4));

  end;  {case Comparison of}

end;  {_Compare}

{============================================================================}
Function _Compare(Logical1 : Boolean;
                  Logical2String : String;
                  Comparison : Integer) : Boolean; overload;

{For booleans only coEqual and coNotEqual apply.}

var
  Logical2 : Boolean;

begin
  Result := False;
    {CHG04102003-3(2.06r): Allow for Yes/No in boolean fields.}

  Logical2 := False;
  Logical2String := Trim(ANSIUpperCase(Logical2String));

    {FXX04292003-1(2.07): Added Yes and Y, but made it so that True and T did not work.}

  If ((Logical2String = 'YES') or
      (Logical2String = 'Y') or
      (Logical2String = 'NO') or
      (Logical2String = 'N') or
      (Logical2String = 'TRUE') or
      (Logical2String = 'T'))
    then Logical2 := True;

  case Comparison of
    coEqual : Result := (Logical1 = Logical2);
    coNotEqual : Result := (Logical1 <> Logical2);

  end;  {case Comparison of}

end;  {_Compare}

{============================================================================}
Function _Compare(DateTime1,
                  DateTime2 : TDateTime;
                  Comparison : Integer) : Boolean; overload;

{Date \ time version}

begin
  Result := False;
  case Comparison of
    coEqual : Result := (DateTime1 = DateTime2);
    coGreaterThan : Result := (DateTime1 > DateTime2);
    coLessThan : Result := (DateTime1 < DateTime2);
    coGreaterThanOrEqual : Result := (DateTime1 >= DateTime2);
    coLessThanOrEqual : Result := (DateTime1 <= DateTime2);
    coNotEqual : Result := (DateTime1 <> DateTime2);

  end;  {case Comparison of}

end;  {_Compare}

{=================================================================}
Procedure ParseName(    _Name : String;
                    var FirstName : String;
                    var LastName : String);

{CHG03172004-2(2.07l2): Add first name and last name inserts.}

var
  CommaPos : Integer;

begin
  CommaPos := Pos(',', _Name);

  If (CommaPos = 0)
    then
      begin
        FirstName := '';
        LastName := _Name;
      end
    else
      begin
        LastName := Copy(_Name, 1, (CommaPos - 1));
        FirstName := Copy(_Name, (CommaPos + 1), 255);
      end;  {else of If (CommaPos = 0)}

end;  {ParseName}


{=================================================================}
Procedure ParseFullName(    _Name : String;
                        var FirstName : String;
                        var MiddleInitial : String;
                        var LastName : String;
                        var Suffix : String);

var
  CommaPos, SpacePos : Integer;
  sTempLastName : String;

begin
  FirstName := '';
  MiddleInitial := '';
  LastName := '';
  Suffix := '';

  CommaPos := Pos(',', _Name);

  If _Compare(CommaPos, 0, coGreaterThan)
  then
  begin
    LastName := Trim(Copy(_Name, 1, (CommaPos - 1)));
    _Name := Trim(Copy(_Name, (CommaPos + 1), 255));
  end
  else
  begin
    SpacePos := Pos(' ', _Name);

    If _Compare(SpacePos, 0, coGreaterThan)
    then
    begin
      LastName := Trim(Copy(_Name, 1, (SpacePos - 1)));
      _Name := Trim(Copy(_Name, (SpacePos + 1), 255));
    end
    else
    begin
      LastName := _Name;
      _Name := '';
    end;

  end;

  If _Compare(_Name, coNotBlank)
  then
  begin
    SpacePos := Pos(' ', _Name);

      {Allow for a 2 part first name.}

    If (_Compare(SpacePos, 0, coGreaterThan) and
        _Compare(Length(Trim(Copy(_Name, (SpacePos + 1), 255))), 1, coEqual))
    then
    begin
      FirstName := Trim(Copy(_Name, 1, (SpacePos - 1)));
      MiddleInitial := Trim(Copy(_Name, (SpacePos + 1), 255));
    end
    else FirstName := _Name;

  end;  {If _Compare(_Name, coNotBlank)}


    {Suffix}

  SpacePos := Pos(' ', LastName);

  If (_Compare(SpacePos, 0, coGreaterThan) and
      _Compare(Length(Trim(Copy(_Name, (SpacePos + 1), 255))), 3, coLessThanOrEqual))
  then
  begin
    sTempLastName := LastName;
    LastName := Trim(Copy(sTempLastName, 1, (SpacePos - 1)));
    Suffix := Trim(Copy(sTempLastName, (SpacePos + 1), 255));
  end;

end;  {ParseName}

{=========================================================================}
Procedure GetFileSpecifications(    FileName : String;
                                var FileDate : TDateTime;
                                var FileTime : TTime;
                                var FileSize : LongInt);

var
  FileHandle : Integer;
  FileRec : TSearchRec;

begin
  FileRec.Name := '';
  FindFirst(FileName, faAnyFile, FileRec);

  If (Deblank(FileRec.Name) = '')
    then
      begin
        FileTime := 0;
        FileDate := 0;
        FileSize := 0;
      end
    else
      begin
        FileTime := FileDateToDateTime(FileRec.Time);
        FileHandle := FileOpen(FileName, 0);
        FileDate := FileDateToDateTime(FileGetDate(FileHandle));
        FileSize := FileRec.Size;
        FileClose(FileHandle);

      end;  {else of If (Deblank(FileRec.Name) = '')}

end;  {GetFileSpecifications}

{=========================================================================}
Function ConvertStringListToString(StringList : TStringList;
                                   SeparatorCharacter : String) : String;

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (StringList.Count - 1) do
    If (I = 0)
      then Result := StringList[I]
      else Result := SeparatorCharacter + StringList[I];

end;  {ConvertStringListToString}

{=========================================================================}
Procedure SortDateStringList(DateList : TStringList);

var
  I, J : LongInt;
  Date1, Date2 : TDateTime;
  TempStr : String;

begin
  For I := (DateList.Count - 1) downto 0 do
    begin
      try
        Date1 := StrToDate(DateList[I]);
      except
        Date1 := 0;
      end;

      For J := (I - 1) downto 0 do
        begin
          try
            Date2 := StrToDate(DateList[J]);
          except
            Date2 := 0;
          end;

          If (Date2 < Date1)
            then
              begin
                TempStr := DateList[I];
                DateList[I] := DateList[J];
                DateList[J] := TempStr;
              end;

        end;  {For J := (I - 1) downto 0 do}

    end;  {For I := (DateList.Count - 1) downto 0 do}

end;  {SortDateStringList}

{==========================================================================}
Function DataInRange(DataItem : String;
                     StartRange : String;
                     EndRange : String;
                     PrintAllInRange : Boolean;
                     PrintToEndOfRange : Boolean) : Boolean; overload;

begin
  Result := False;

  If PrintAllInRange
    then Result := True
    else
      If (_Compare(DataItem, StartRange, coGreaterThanOrEqual) and
          (PrintToEndOfRange or
           _Compare(DataItem, EndRange, coLessThanOrEqual)))
        then Result := True;

end;  {DataInRange}

(*
{======================================================}
Procedure Delete_all_files_in_dir(dir_name : string);

var
  T:TSHFileOpStruct;
  s_from : string;
  p_from : pchar;

begin
  ZeroMemory( @t, sizeof(T) );
  p_from := stralloc(255);
  s_from := dir_name + '\*.*';
  strpcopy ( p_from, s_from );
  t.Wnd:= 0;
  t.wFunc := FO_DELETE;
  t.pfrom := p_from;
  t.pto := nil;
  t.fFlags:=FOF_ALLOWUNDO or FOF_FILESONLY
             or FOF_SILENT or FOF_NOCONFIRMATION;
  SHFileOperation(T);
  strdispose (p_from);
end; *)

{===============================================================}
Procedure DeleteFolder(Directory_Name : String;
                       _RemoveDirectory : Boolean);

var
  DirInfo: TSearchRec;
  FindResult : Integer;

begin
  Directory_Name := AddDirectorySlashes(Directory_Name);

  FindResult := FindFirst(Directory_Name + '\*.*', FaAnyfile, DirInfo);

  while (FindResult = 0) do
    begin
      If (((DirInfo.Attr and FaDirectory) <> FaDirectory) and
          ((DirInfo.Attr and FaVolumeId) <> FaVolumeID))
        then
          If not DeleteFile(pChar(Directory_Name + DirInfo.Name))
            then ShowMessage('Unable to delete : ' + DirInfo.Name);

      FindResult := FindNext(DirInfo);

    end;  {while (FindResult = 0) do}

  SysUtils.FindClose(DirInfo);

  If (_RemoveDirectory and
      (not RemoveDir(Directory_Name)))
    then ShowMessage('Unable to delete directory ' + Directory_Name + '.');

end;  {DeleteFolder}

{==========================================================================}
Function DaysInYear(Year : String) : Integer;

var
  StartOfYear, EndOfYear : TDateTime;

begin
  try
    StartOfYear := EncodeDate(StrToInt(Year), 1, 1);
    EndOfYear := EncodeDate(StrToInt(Year), 12, 31);
    Result := Trunc(EndOfYear) - Trunc(StartOfYear) + 1;
  except
    Result := 0;
  end;

end;  {DaysInYear}

{===================================================================}
Function IncrementNumericString(NumericStr : String;
                                Increment : LongInt) : String;

begin
  try
    Result := IntToStr(StrToInt(NumericStr) + Increment);
  except
    Result := '';
  end;

end;  {IncNumericStr}

{==========================================================================}
Function Max(const Values : Array of const) : Extended; overload;

{Find the maximum value in an array of values.  Invalid numbers are ignored.}

var
  I : LongInt;
  TempNum : Extended;

begin
  Result := 0;

  For I := 0 to High(Values) do
    try
      TempNum := StrToFloat(VarRecToStr(Values[I]));

      If _Compare(TempNum, Result, coGreaterThan)
        then Result := TempNum;

    except
    end;

end;  {Max}

{=======================================================================}
Function FormatSQLString(TempStr : String) : String;

begin
  TempStr := StringReplace(TempStr, Chr(39), SQLQuote + SQLQuote, [rfReplaceAll]);
  Result := SQLQuote + TempStr + SQLQuote;
end;

{=======================================================================}
Function FormatSQLString2(TempStr : String) : String;

begin
  Result := '''' + TempStr + '''';
end;

{=======================================================================}
Function FormatFilterString(TempStr : String) : String;

begin
  Result := '''' + TempStr + '''';
end;

{=======================================================================}
Function FormatwwFilterString(TempStr : String) : String;

begin
  Result := '"' + TempStr + '"';
end;

{$H+}
{=======================================================================}
Function CountOfCharacter(TempStr : String;
                          _Char : Char) : LongInt;

var
  I : LongInt;

begin
  Result := 0;

  For I := 1 to Length(TempStr) do
    If _Compare(TempStr[I], _Char, coEqual)
      then Inc(Result);

end;  {CountOfCharacter}
{$H-}

{=============================================================================}
Function ComputePercent(NewValue : Double;
                        BaseValue : Double) : Double;

begin
  If _Compare(BaseValue, 0, coEqual)
    then Result := 0
    else
      try
        Result := ((NewValue - BaseValue) / BaseValue) * 100;
      except
        Result := 0;
      end;

end;  {ComputePercent}

{$H+}
{==================================================================}
Function FormatPipeExtractField(TempStr : String;
                                StringField : Boolean) : String;

begin
  Result := TempStr;

    {For pipe delimited files, double quote the string field.}

  If (_Compare(TempStr, coNotBlank) and
      StringField)
    then Result := '"' + Result + '"';

  If _Compare(GlblCurrentCommaDelimitedField, 1, coGreaterThan)
    then Result := '|' + Result;

end;  {FormatPipeExtractField}

{==================================================================}
Procedure WritePipeDelimitedLine(var ExtractFile : TextFile;
                                     Fields : Array of const);

var
  I : Integer;
  TempStr : String;
  StringField : Boolean;

begin
  For I := 0 to High(Fields) do
    begin
      GlblCurrentCommaDelimitedField := GlblCurrentCommaDelimitedField + 1;
      TempStr := VarRecToStr(Fields[I]);

      StringField := ((Fields[I].VType = vtChar) or
                      (Fields[I].VType = vtString) or
                      (Fields[I].VType = vtAnsiString));

      Write(ExtractFile, FormatPipeExtractField(TempStr, StringField));

    end;  {For I := 0 to High(Fields) do}

end;  {WritePipeDelimitedLine}

{==================================================================}
Procedure WritelnPipeDelimitedLine(var ExtractFile : TextFile;
                                       Fields : Array of const);

begin
  If (High(Fields) > 0)
    then WritePipeDelimitedLine(ExtractFile, Fields);

  Writeln(ExtractFile);
  GlblCurrentCommaDelimitedField := 0;

end;  {WritelnCommaDelimitedLine}

{$H-}

{========================================================}
Function Mod10(const Value: string): Integer;

{Mod10 algorithm from scalabium.com.}

var
  i, intOdd, intEven: Integer;

begin
  {add all odd seq numbers}
  intOdd := 0;
  i := 1;
  while (i < Length(Value)) do
  begin
    Inc(intOdd, StrToIntDef(Value[i], 0));
    Inc(i, 2);
  end;

  {add all even seq numbers}
  intEven := 0;
  i := 2;
  while (i < Length(Value)) do
  begin
    Inc(intEven, StrToIntDef(Value[i], 0));
    Inc(i, 2);
  end;

  Result := 3*intOdd + intEven;
  {modulus by 10 to get}
  Result := Result mod 10;
  if Result <> 0 then
    Result := 10 - Result

end;  {Mod10}

{=============================================================}
Function CalculateCheckDigit_Mod10_7532(sSomeNumber: String): String;
(* created 07/12/2006
   modified 07/13/2006 -- Deleted Code to remove leading zeros and
                       -- Added Code to accomodate zero remainders

 This function Calculates and Returns a Check Digit String
  for a string of numbers.

 This Check Digit Routine is Modulus 10, Sum of Digits, with
  Weights of 7 5 3 2 -- per Wachovia OCR Scanline Check Digit
  Specifications, printed 06/29/2006

 This functions assumes that the number string contains
  digits only.  That is, no spaces, special character, etc.*)

  var
    iNumberLength, iX, iW: Integer;
    aOriginalNumber: Array of Integer;
    sDigit: String;

  const
    aWeights: Array [0..3] of Integer = (7, 5, 3, 2);
    iModulus: Integer = 10;

begin
  sSomeNumber := StringReplace(sSomeNumber, '-', '', [rfReplaceAll]);
    sSomeNumber := Trim(sSomeNumber);

    //Store Length of the Original Number String
    iNumberLength := Length(sSomeNumber);

    //Specify the number of Elements for the Array.  Add one Extra for Sum
    SetLength (aOriginalNumber, iNumberLength+1);

    //Add each Digit to an Element of the Array
    For iX := 0 to (iNumberLength - 1) do
      aOriginalNumber [iX] :=  StrToInt(Copy(sSomeNumber, iX+1, 1));

    //Calculate Check Digit

    //Step 1 -- Multiply each Digit by the appropriate Weight
    sSomeNumber := '';
    iW := 0;
    For iX := 0 to (iNumberLength - 1) do
    begin
      aOriginalNumber [iX] :=  aOriginalNumber [iX] * aWeights[iW];
      sSomeNumber := Trim(IntToStr(aOriginalNumber[iX]));

      //If Result of Digit * Weight is a 2 Digit Number -- then add the Digits, else leave it
      If Length(sSomeNumber) > 1 then
        aOriginalNumber [iX] := StrToInt(Copy(sSomeNumber, 1, 1)) + StrToInt(Copy(sSomeNumber, 2, 1));

      iW := iW +1;
      if iW > 3 then
        iW := 0;
    end;

    //Step 2 -- Sum the Values of the Array.  Put Sum in Last unused Element of Array
    aOriginalNumber [iNumberLength] := 0;
    For iX := 0 to (iNumberLength - 1) do
     aOriginalNumber [iNumberLength] := aOriginalNumber [iNumberLength] + aOriginalNumber [iX];

    //Step3  and Step 4:
    //Divide Sum by Modulus to get Remainder & subtract Remainder from Modulus
    sDigit := IntToStr(iModulus - (aOriginalNumber [iNumberLength] Mod iModulus));

    //Per Step 3 above -->  If Remainder is Zero, then sDigit will be Ten
    //Therefore, the Check Digit should be corrected to Zero
    if sDigit = '10' then
      sDigit := '0';

    //Return the Check Digit
    Result := sDigit;
end;  {CalculateCheckDigit_Mod10_7532}

{=========================================================================}
Function AddressIsPOBox(Address : String) : Boolean;

begin
  Result := _Compare(Address, ['POBox', 'P.O.', 'P O'], coContains);
end;

{=========================================================================}
Function AddressIsUnit(Address : String) : Boolean;

begin
  Result := _Compare(Address, ['Unit', 'Ste', 'Rm', 'Apt', 'Fl'], coStartsWith);
end;

{=========================================================================}
Function AddressIsDesignation(Address : String) : Boolean;

begin
  Result := _Compare(Address, ['Trust', 'Life Use', 'Et Al'], coContains);
end;

{=========================================================================}
Function Even(Number : LongInt) : Boolean;

begin
  Result := _Compare((Number mod 2), 0, coEqual);
end;

{=========================================================================}
Procedure LogTime(sFileName : String;
                  sLocator : String);

var
  fLogFile : TextFile;

begin
  (*AssignFile(fLogFile, sFileName);
  If FileExists(sFileName)
    then Append(fLogFile)
    else Rewrite(fLogFile);

  WritelnCommaDelimitedLine(fLogFile,
                            [sLocator, DateToStr(Date),
                             FormatDateTime(TimeFormatMillisecond, Now)]);
  CloseFile(fLogFile); *) 

end;  {LogTime}

{=========================================================================}
Function PromptForExcelExtract : Boolean;

begin
  Result := (MessageDlg('Do you want to extract to Excel?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
end;

{=========================================================================}
Function CreateMailingZipCode(sZipCode : String;
                              sZipCodePlus4 : String) : String;

begin
  Result := sZipCode;

  If _Compare(sZipCodePlus4, coNotBlank)
    then Result := Result + sZipCodePlus4;

end;  {CreateMailingZipCode}

{=======================================================================}
Function NumOccurrences(cSearch : Char;
                        sSource : String) : Integer;

var
  I : Integer;

begin
  Result := 0;

  For I := 1 to Length(sSource) do
    If _Compare(sSource[I], cSearch, coEqual)
      then Inc(Result);

end;  {NumOccurrences}

{==================================================================}
Function RoundToNearest(iNumber : LongInt;
                        iNearest : LongInt) : LongInt;

var
  iHighBound, iMultiple : LongInt;

begin
  iMultiple := (iNumber DIV iNearest);

  If _Compare((iNumber MOD iNearest), 0, coEqual)
    then Result := iNumber
    else
      begin
        iHighBound := iNumber + (iNearest DIV 2);

        If _Compare(iHighBound, (iNearest * (iMultiple + 1)), coGreaterThan)
          then Result := iNearest * (iMultiple + 1)
          else Result := iNearest * iMultiple;

      end;  {else of If _Compare(iMultiple, o, coEqual)}

end;  {RoundToNearest}

{=====================================================================}
Function StringContainsNumber(sTemp : String) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 1 to Length(sTemp) do
  If (sTemp[I] in Numbers)
  then Result := True;

end;  {StringContainsNumber}

{==============================================================}
Function GetNegativeAS400Integer(sAS400Number : String) : LongInt;

var
  iLength : Integer;
  sLastDigit : Char;

begin
  sAS400Number := Trim(sAS400Number);
  iLength := Length(sAS400Number);

  case sAS400Number[iLength] of
    'J' : sLastDigit := '1';
    'K' : sLastDigit := '2';
    'L' : sLastDigit := '3';
    'M' : sLastDigit := '4';
    'N' : sLastDigit := '5';
    'O' : sLastDigit := '6';
    'P' : sLastDigit := '7';
    'Q' : sLastDigit := '8';
    'R' : sLastDigit := '9';
    '}' : sLastDigit := '0';
  end;

  sAS400Number := Copy(sAS400Number, 1, (iLength - 1)) + sLastDigit;

  try
    Result := -1 * StrToInt(sAS400Number);
  except
    Result := 0;
  end;

end;  {GetNegativeAS400Integer}

begin
  GlblCurrentCommaDelimitedField := 0;
end.