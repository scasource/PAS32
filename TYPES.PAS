Unit Types;
{DS: This unit contains all of the data Types, key constants, etc
     for all applications }

INTERFACE


  type
(*    Str255 = String[255];
    anystr = string[255];
    Str251 = String[251];
    Str150= string[150];
    Str120= string[120];
    Str100= string[100];
    str80 = string[80];
    Str78 = String[78];
    Str77 = String[77];
    Str75 = String[75];
    Str70 = String[70];
    Str60 = String[60];
    Str65 = String[65];
    Str64 = String[64];
    Str55 = String[55];
    Str52 = String[52];
    Str51 = String[51];
    Str50 = String[50];
    str49 = string[49];
    str48 = string[48];
    str46 = string[46];
    Str45 = String[45];
    Str44 = String[44];
    Str42 = String[42];
    Str41 = String[41];
    Str40 = string[40];
    Str38 = String[38];
    Str37 = String[37];
    Str36 = String[36];
    Str35 = String[35];
    Str34 = String[34];
    str33 = string[33];
    str32 = string[32];
    str31 = string[31];
    str30 = string[30];
    str29 = string[29];
    str28 = string[28];
    str26 = string[26];
    Str25 = string[25];
    str24 = string[24];
    str23 = string[23];
    str22 = string[22];
    Str21 = string[21];
    str20 = string[20];
    Str19 = String[19];
    Str18 = String[18];
    str17 = string[17];
    str16 = string[16];
    str15 = string[15];
    str14 = String[14];
    str13 = String[13];
    str12 = string[12];
    Str11 = String[11];
    str10 = string[10];
    str9  = string[9];
    str8  = string[8];
    str7  = string[7];
    str6  = string[6];
    str5  = string[5];
    str4  = string[4];
    str3  = string[3];
    str2  = string[2];
    str1  = string[1];

    ArrayC1           = Array[1..1] of Char;
    ArrayC2           = Array[1..2] of Char;
    ArrayC3           = Array[1..3] of Char;
    ArrayC4           = Array[1..4] of Char;
    ArrayC5           = Array[1..5] of Char;
    ArrayC6           = Array[1..6] of Char;
    ArrayC7           = Array[1..7] of Char;
    ArrayC8           = Array[1..8] of Char;
    ArrayC9           = Array[1..9] of Char;
    ArrayC10          = Array[1..10] of Char;
    ArrayC11          = Array[1..11] of Char;
    ArrayC12          = Array[1..12] of Char;
    ArrayC13          = Array[1..13] of Char;
    ArrayC14          = Array[1..14] of Char;
    ArrayC15          = Array[1..15] of Char;
    ArrayC16          = Array[1..16] of Char;
    ArrayC17          = Array[1..17] of Char;
    ArrayC18          = Array[1..18] of Char;
    ArrayC19          = Array[1..19] of Char;
    ArrayC20          = Array[1..20] of Char;
    ArrayC21          = Array[1..21] of Char;
    ArrayC22          = Array[1..22] of Char;
    ArrayC23          = Array[1..23] of Char;
    ArrayC25          = Array[1..25] of Char;
    ArrayC26          = Array[1..26] of Char;
    ArrayC28          = Array[1..28] of Char;
    ArrayC30          = Array[1..30] of Char;
    ArrayC31          = Array[1..31] of Char;
    ArrayC32          = Array[1..32] of Char;
    ArrayC34          = Array[1..34] of Char;
    ArrayC35          = Array[1..35] of Char;
    ArrayC36          = Array[1..36] of Char;
    ArrayC37          = Array[1..37] of Char;
    ArrayC40          = Array[1..40] of Char;
    ArrayC41          = Array[1..41] of Char;
    ArrayC42          = Array[1..42] of Char;
    ArrayC44          = Array[1..44] of Char;
    ArrayC45          = Array[1..45] of Char;
    ArrayC46          = Array[1..46] of Char;
    ArrayC48          = Array[1..48] of Char;
    ArrayC49          = Array[1..49] of Char;
    ArrayC50          = Array[1..50] of Char;
    ArrayC51          = Array[1..51] of Char;
    ArrayC52          = Array[1..52] of Char;
    ArrayC54          = Array[1..54] of Char;
    ArrayC60          = Array[1..60] of Char;
    ArrayC80          = Array[1..80] of Char; *)

    charset = set of char;

    MenuArray = Array[1..15] of string;

Const
    ScanRecLen = 400;
    MaxNumChars = 5000;

Type
    RecField1 = Array[1..ScanRecLen] of char;  {temp buffer for raw record}

         {x for prompt, len, x for input, y, Text Prompt len}
   ScrArr = Array[1..5] of Integer;
   MonthArr = Array[1..12] of String;
   LongMonthArr = Array[1..12] of String;
   MonthLenArray = Array[1..12] of Integer;

   LongString = Array[1..MaxNumChars] of Char;
   LineStringType = Array[1..MaxNumChars] of Char;

const
  WaitArray : Array[1..4] of Char = ('\', Chr(196), '/', Chr(196));

  LengthOfMonths : MonthLenArray = (31, 28, 31, 30, 31, 30, 31, 31,
                                    30, 31, 30, 31);

  Months : MonthArr = ('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG',
                       'SEP', 'OCT', 'NOV', 'DEC');

  LongMonths:LongMonthArr = ('January  ', 'February ', 'March    ', 'April    ',
                             'May      ', 'June     ', 'July     ', 'August   ',
                             'September', 'October  ', 'November ', 'December ');
      AllKeys : set of Chr(0)..Chr(255) = [Chr(0)..Chr(255)];

      Numbers : CharSet = ['0', '1', '2', '3', '4', '5', '6', '7',
                           '8', '9'];

      NonFunctionKeys : set of '!'..'~' = ['!'..'~'];

      Letters : Set of 'A'..'z' = ['A'..'Z', 'a'..'z'];

      LettersPreceededBy_An_ : Charset = ['a', 'e', 'f', 'h', 'i', 'l', 'm',
                                          'n', 'o', 'r', 's', 'x', 'A', 'E',
                                          'F', 'H', 'I', 'L', 'M', 'N', 'O',
                                          'R', 'S', 'X'];


    Zero = 0.0;
    ZeroInt = 0;


const
  ExitButtonXOffset = 5;
  ExitButtonYOffset = 8;

IMPLEMENTATION { Implementation section is vacuous }

END.