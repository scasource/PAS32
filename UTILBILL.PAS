unit Utilbill;

{General bill collection routines.}

interface

USES Types, Glblvars, SysUtils, WinTypes, WinProcs, BtrvDlg,
     Messages, Dialogs, Forms, wwTable, Classes, DB, DBTables,
     Controls,DBCtrls,StdCtrls, PASTypes, WinUtils, GlblCnst, Utilitys,
     wwDBLook, Graphics, PASUTILS, UTILEXSD,  RPBase, RPDefine, DataAccessUnit;

Procedure SetRollTabs(Margin : Double);

Function DetermineBillingTaxYear : String;

Function GetBillingFileName(sBaseFileName : String;
                            sAssessmentYear : String;
                            sCollectionType : String;
                            sCollectionNumber : String) : String;

Procedure GetBillingFileNames(    TaxRollYear : String;
                                  CollectionType,
                                  CollectionNum : String;  {For tax rolls a SRAZ num, for assess, 'TN' or 'FI'}
                              var HeaderFileName,
                                  GeneralFileName,
                                  EXFileName,
                                  SDFileName,
                                  SpecialFeeFileName : String);
{Given the tax roll year, collection type, and collection number,
 figure out the file names for the tax files for this collection.
 Note that the Resource name is appended to the end.}

Procedure OpenBillingFiles(    HeaderFileName,
                               GeneralFileName,
                               EXFileName,
                               SDFileName,
                               SpecialFeeFileName : String;
                               BLHeaderTaxTable,
                               BLGeneralTaxTable,
                               BLExemptionTaxTable,
                               BLSpecialDistrictTaxTable,
                               BLSpecialFeeTaxTable : TTable;
                           var Quit : Boolean);
{Given the billing file names and the billing tax tables,
 open all the billing files.}

Procedure CopyAndOpenBillingFiles(    TaxRollYear : String;
                                      CollectionType,
                                      CollectionNum : String;  {For tax rolls a SRAZ num, for assess, 'TN' or 'FI'}
                                      BLHeaderTaxTable,
                                      BLGeneralTaxTable,
                                      BLExemptionTaxTable,
                                      BLSpecialDistrictTaxTable,
                                      BLSpecialFeeTaxTable : TTable;
                                  var HeaderFileName,
                                      GeneralFileName,
                                      EXFileName,
                                      SDFileName,
                                      SpecialFeeFileName : String;
                                      CopyFiles : Boolean;
                                  var Quit : Boolean);
{Open up the billing files for this tax roll year, collection type
 and collection number.}

Procedure GetTotalsFileNames(    TaxRollYear : String;
                                 CollectionType,
                                 CollectionNum : String;  {For tax rolls a SRAZ num, for assess, 'TN' or 'FI'}
                                 RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                             var GeneralTotFileName,
                                 SchoolTotFileName,
                                 EXTotFileName,
                                 SDTotFileName,
                                 SpecialFeeTotFileName : String);
{Given the tax roll year, collection type, and collection number,
 figure out the file names for the totals files for this collection.
 Note that the Resource name is appended to the end.}

Procedure OpenTotalsFiles(    GeneralTotFileName,
                              EXTotFileName,
                              SDTotFileName,
                              SchoolTotFileName,
                              SpecialFeeTotFileName : String;
                              GeneralTotalsTable,
                              EXTotalsTable,
                              SDTotalsTable,
                              SchoolTotalsTable,
                              SpecialFeeTotalsTable : TTable;
                              AssessmentRoll : Boolean;
                          var Quit : Boolean);
{Given the totals file names and the totals files, open them.}

Procedure CopyAndOpenTotalsFiles(    TaxRollYear : String;
                                     CollectionType,
                                     CollectionNum : String;  {For tax rolls a SRAZ num, for assess, 'TN' or 'FI'}
                                     RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                     GeneralTotalsTable,
                                     SDTotalsTable,
                                     SchoolTotalsTable,
                                     EXTotalsTable,
                                     SpecialFeeTotalsTable : TTable;
                                 var GeneralTotFileName,
                                     SchoolTotFileName,
                                     SDTotFileName,
                                     EXTotFileName,
                                     SpecialFeeTotFileName : String;
                                     AssessmentRoll : Boolean;
                                     CopyFiles : Boolean;
                                 var Quit : Boolean);
{Open up the totals files for this tax roll year, collection type
 and collection number.}

Function GetRollHeaderTitle(RollType : Char; {'X' = Tax roll, 'T' = tenative assessment}
                            CollectionType : String;  {(SC)hool, (MU)nicipal, (VI)llage}
                            RollPrintingYear : String) : String;

Procedure LoadRateListsFromRateFiles(    TaxRollYear : String;
                                         CollectionType : String;
                                         CollectionNum : Integer;
                                         GeneralRateList,
                                         SDRateList,
                                         SpecialFeeRateList,
                                         BillControlDetailList : TList;
                                         IsBillCalculationOrPrint : Char;  {'C' = calc, 'P' = print}
                                     var Quit : Boolean);
{Load the different rates into TLists so that we don't have to keep looking
 them up in a file.}

Function FoundSDRate(    SDRateList : TList;
                         _SDCode : String;
                         _ExtCode : String;
                         _CMFlag : String;
                     var I : Integer) : Boolean;
{Match sd code, ext code and cm flag to get rate record}

Procedure LoadSDExtCategoryList(    SDExtCategoryList : TList;
                                var Quit : Boolean);
{Load the SD extension categories into a list.}

Function GetSDExtCategory(ExtCode : String;
                          ExtCatList : TList) : String;
{Given an extension, what is the category.}

Function GetGeneralTaxDesc(    PrintOrder : Integer;
                               GeneralRateList : TList;
                           var GeneralTaxType : String) : String;
{Given a print order for a general tax, return the description.}

Function GetGeneralTaxType(PrintOrder : Integer;
                           GeneralRateList : TList) : String;
{Given a print order for a general tax, return the tax type}

Function GetSPFeeTaxDesc(PrintOrder : Integer;
                         SpFeeRateList : TList) : String;

Function FindSpecialFeeRate(PrintOrder : Integer;
                            SpFeeRateList : TList) : Integer;

Function FindGeneralRate(PrintOrder : Integer;
                         GeneralTaxType : String;
                         SwisCode : String;
                         GeneralRateList : TList) : Integer;
{Find the index of the rate with this print order, tax type and swis code in the general rate list.}


Procedure LoadTaxesForParcel(    SwisSBLKey : String;
                                 GeneralTaxTable,
                                 SDTaxTable,
                                 EXTaxTable,
                                 SPFeeTaxTable : TTable;
                                 SDCodeDescList,
                                 EXCodeDescList,
                                 GeneralRateList,
                                 SDRateList,
                                 SPFeeRateList,
                                 GnTaxList,
                                 SDTaxList,
                                 SpFeeTaxList,
                                 ExTaxList : TList;
                             var Quit : Boolean);
{Get all taxes, special districts, exemptions and special fees for this
 parcel and put them in memory lists.}

Function GetAndSetMaxLines(CL1List,
                           CL2List,
                           CL3List,
                           CL4List,
                           CL5List,
                           CL6List,
                           CL7List,
                           LineTypeList : TStringList) : Integer;
{return elements of largest str list, = most lines to be printed}
{and set elements of all strlists to that same amount}

Procedure FillInExemptions(CL4List,
                           CL5List,
                           CL6List,
                           CL7List,
                           LineTypeList : TSTringList;
                           HomesteadCode : String;
                           CollectionType : String;
                           ExTaxList : TList);
{Put all the exemptions in columns 4-7 decending.}

Procedure FillInGeneralTaxes(CL2List,
                             CL4List,
                             CL5List,
                             CL6List,
                             CL7List,
                             LineTypeList : TStringList;
                             RollType : Char;  {'X' = Tax roll; 'T' = tenative, 'F' = final}
                             HomesteadCode : String;
                             GnTaxList : TList);
{Put the general tax amounts into columns 4-7 decending.}

Procedure FillInSDTaxes(CL4List,
                        CL5List,
                        CL6List,
                        CL7List,
                        LineTypeList : TStringList;
                        RollType : Char;  {'X' = Tax roll; 'T' = tenative, 'F' = final}
                        TotalAssessedVal : Comp;
                        SuppressSDExtensions : Boolean;
                        SDExtCategoryList,
                        SDTaxList : TList;
                        _HomesteadCode : String);
{Put all the SD taxes in columns 4 - 7 decending.}

Procedure FillInSPFeeTaxes(CL4List,
                           CL5List,
                           CL6List,
                           CL7List,
                           LineTypeList : TStringList;
                           SPTaxList : TList);
{Fill in the special fee taxes in columns 4-7.}

Procedure FillInPropertyInformation(HeaderTaxTable,
                                    AssessmentYearCtlTable,
                                    SwisCodeTable,
                                    ParcelTable : TTable;
                                    SwisSBLKey : String;
                                    RollType : Char;  {'X' = Tax, 'T' = Tenative, 'F' = Final}
                                    PropertyClassDescList,
                                    SchoolCodeDescList,
                                    ExTaxList : TList;
                                    CL1List,
                                    CL2List,
                                    CL3List,
                                    CL4List,
                                    CL5List,
                                    CL6List,
                                    CL7List,
                                    LineTypeList : TStringList;
                                    PrintZoningCode,
                                    PrintAdditionalLots,
                                    PrintPermits,
                                    UseNassauPrintKeyFormat : Boolean);
{Fill in the property information into columns 1 - 3}

Procedure FillInClassInformation(CL1List,
                                 CL2List,
                                 CL3List,
                                 CL4List,
                                 CL5List,
                                 CL6List,
                                 CL7List,
                                 LineTypeList : TStringList; {What type of line is each tax line?}
                                 BLHeaderTaxTable : TTable;
                                 CollectionType : String;
                                 RollType : Char;
                                 SuppressSDExtensions : Boolean;
                                 ExTaxList,
                                 GNTaxList,
                                 SDExtCategoryList,
                                 SDTaxList,
                                 SPTaxList : TList);
{The setup for split parcels is different and can not be worked into the
 normal procesdures.}

Function GetUniformPercentOfValue(SwisCode : String;
                                  SwisCodeDescList : TList) : Real;
{Given a swis code description list and a swis code, return the uniform % of value.}

Procedure StartNewPage(    Sender : TObject;  {Report printer or filer object}
                           RollType : Char; {'X' = Tax roll, 'T' = tenative assessment}
                           SchoolCode,
                           SwisCode : String;
                           RollSection : String;
                           CollectionType : String;  {(SC)hool, (MU)nicipal, (VI)llage}
                           RollPrintingYear : String;
                           AssessmentYearCtlTable : TTable;
                           SchoolCodeDescList,
                           SwisCodeDescList : TList;
                           SequenceStr : String;  {Text for what order roll is printing in.}
                       var PageNo,
                           LineNo : Integer);
{Start a new page by formfeeding, reseting the counters and printing the
 header.}

Procedure PrintRollHeader(    Sender : TObject;  {Report printer or filer object}
                              RollType : Char; {'X' = Tax roll, 'T' = tenative assessment}
                              SchoolCode,
                              SwisCode : String;
                              RollSection : String;
                              CollectionType : String;  {(SC)hool, (MU)nicipal, (VI)llage}
                              RollPrintingYear : String;
                              AssessmentYearCtlTable : TTable;
                              SchoolCodeDescList,
                              SwisCodeDescList : TList;
                              SequenceStr : String;  {Text for what order roll is printing in.}
                              PageNo : Integer;
                          var LineNo : Integer);
{Print the header for this type of roll.}

Procedure PrintParcelPageSubheader(    Sender : TObject;  {Report printer or filer object}
                                       RollType : Char; {'X' = Tax roll, 'T' = tenative assessment}
                                       CollectionType : String;
                                   var LineNo : Integer);
{Print the column headers for this parcel page.}

Procedure PrintOneParcel(    Sender : TObject;  {Report printer or filer object}
                             RollType : Char; {'X' = Tax roll, 'T' = tenative assessment}
                             BLHeaderTaxTable,
                             CollectionLookupTable : TTable;
                             MaxLines : Integer;
                             CL1List,
                             CL2List,
                             CL3List,
                             CL4List,
                             CL5List,
                             CL6List,
                             CL7List,
                             LineTypeList : TStringList;
                             NumExemptions : Integer;  {We have to use different tabs for exemptions, so how many?}
                         var LineNo : Integer);
{Given the information for a parcel in 7 column lists, print it along
 with the amounts due and due dates.}

Procedure PrintEndingParcelLine(Sender : TObject);
{Print a line of asteriks after the last parcel on a page.}

Function VerifyDatesAndPercentOfValueFilledIn(    AssessmentYearCtlFile,
                                                  SwisCodeTable : TTable;
                                              var UniformPercentOfValue,
                                                  EqualizationRate : Real) : Boolean;

Procedure GetStateAidAmounts(    GeneralRateList : TList;
                                 SwisCode : String;
                             var CountyStateAid,
                                 TownStateAid,
                                 SchoolStateAid,
                                 VillageStateAid : Comp);

Function ConfirmRollSetup(AssessmentYearCtlTable,
                          EXCodeTable,
                          SwisCodeTable : TTable;
                          RollTypeStr,
                          ActionTypeStr,
                          PrintedDate : String) : Boolean;

Function GetCollectionTypeCategory(CollectionType : String) : String;

Procedure GetDistrictNameAndRate(    tbBillSpecialDistricts : TTable;
                                     tbBillSpecialDistrictRates : TTable;
                                     tbSpecialDistrictCodes : TTable;
                                     sSwisSBLKey : String;
                                     sTaxYear : String;
                                     sCollectionType : String;
                                     iCollectionNumber : String;
                                     iSpecialDistrictType : Integer;
                                 var sDistrictName : String;
                                 var fDistrictRate : Double);

Function GetBaseTaxRate(tbBillGeneralRates : TTable;
                        sTaxYear : String;
                        sCollectionType : String;
                        sCollectionNumber : String;
                        sTaxRateType : String) : Double;
                                 

var
  NumLinesPerPage,
  NumColsPerPage : Integer;
  PrintUniformPercentOfValue : Boolean;
  RollPrintingDate : TDateTime;
  RollHeaderTitle : String;
  MunicipalitiesToPrint : MunicipalityTypes;

const
       {constants for printing lines on roll}

  MRG = 0;

     {Column widths}
     {FXX06251998-15: Add 1 space to column 1, remove one from column 3 for ag dist law warning.}

  CL1W = 2.6; {SBL}
  CL2W = 2.6; {column 2..prprloc,schldis,prclsize}
  CL3W = 1.6; {column 3..assessment, land , total}
  CL4W = 2.3; {column 4, ex codes,taxdescri}
  CL5W = 1.7; {column 5, taxable val}
  CL6W = 0.4; {column 6, SD Ext Codes}
  CL7W = 1.3; {column 7, tax amts}

  EX4W = 2.0; {column 4, ex codes, desc}
  EX5W = 1.0; {column 5, county ex amt}
  EX6W = 1.0; {column 6, town ex amt}
  EX7W = 1.0; {column 7, school amt}

   {constants for printing  TOTALS lines on roll}

  TL1W = 0.7; {column 1..name}
  TL2W = 1.8; {column 2..desc}
  TL3W = 0.8; {column 3 parcel count}
  TL4W = 1.3; {column 4, }
  TL5W = 1.3; {column 5, }
  TL6W = 1.3; {column 6,}
  TL7W = 1.3; {column 7,}
  TL8W = 1.3; {column 8,}
  TL9W = 1.4; {totals column}
  TL10W = 1.4; {totals column}

    {constants for Payment Info  eg tottax
     Note we work from the third column backwards, i.e. if
     there are two payments, the first payment is in column 2,
     the second in column 3.}

  DueDateStartPos = 6.3;

  PDP1W = 0.8; {DATE DUE Column 1}
  PDA1W = 1.2; {amt due 1}
  PDP2W = 0.8; {'DATE DUE 2'}
  PDA2W = 1.2; {amt due 2}
  PDP3W = 0.8; {'DATE DUE 3'}
  PDA3W = 1.2; {amt due 3}

  TotalTaxStartPos = 9.8;

  TT1W = 2.0;  {Total Tax label}
  TT2W = 1.5;  {Total tax due}

   {Note that the actual positions are calculated in the initialization
    section.}

type
  SDTotalsArray = Array[1..9] of Extended;  {Total SD by roll section}

{Var the column positions up here so that we don't have to pass them
 everywhere.}

var
  CL1, CL2, CL3, CL4, CL5, CL6, CL7,
  EX5, EX6, EX7,
  TL1, TL2, TL3, TL4, TL5, TL6, TL7, TL8, TL9, TL10,
  PDP1, PDA1, PDP2, PDA2, PDP3, PDA3,
  TT1, TT2 : Double;
  LinesAtBottom : Integer;

implementation

var
  CollectionHasSchoolTax : Boolean;

{====================================================================}
Procedure SetRollTabs(Margin : Double);

begin
  CL1 := Margin;
  CL2 := CL1 + CL1W + 0.1;
  CL3 := CL2 + CL2W + 0.1;
  CL4 := CL3 + CL3W + 0.1;
  CL5 := CL4 + CL4W + 0.1;
  CL6 := CL5 + CL5W + 0.1;
  CL7 := CL6 + CL6W + 0.1;
  EX5 := CL4 + EX4W + 0.1;
  EX6 := EX5 + EX5W + 0.1;
  EX7 := EX6 + EX6W + 0.1;

  TL1 := Margin;
  TL2 := TL1 + TL1W + 0.1;
  TL3 := TL2 + TL2W + 0.1;
  TL4 := TL3 + TL3W + 0.2;
  TL5 := TL4 + TL4W + 0.1;
  TL6 := TL5 + TL5W + 0.1;
  TL7 := TL6 + TL6W + 0.1;
  TL8 := TL7 + TL7W + 0.1;
  TL9 := TL8 + TL8W + 0.1;
  TL10 := TL9 + TL9W + 0.1;
  PDP1 := DueDateStartPos;
  PDA1 := PDP1 + PDP1W + 0.1;
  PDP2 := PDA1 + PDA1W + 0.3;
  PDA2 := PDP2 + PDP2W + 0.1;
  PDP3 := PDA2 + PDA2W + 0.3;
  PDA3 := PDP3 + PDP3W + 0.1;
  TT1 := TotalTaxStartPos;
  TT2 := TT1 + TT1W;

end;  {SetRollTabs}

{====================================================================}
Function DetermineBillingTaxYear : String;

{FXX06231998-3: Put in changes to allow for Westchester billing off NY.}
{FXX06251998-1: Actually, Westchester bills of TY too.}

begin
(*  If (UpcaseStr(Trim(GlblCountyName)) = 'WESTCHESTER')
    then Result := GlblNextYear
    else Result := GlblThisYear;*)

  Result := GlblThisYear;

end;  {DetermineBillingTaxYear}

{====================================================================}
Function GetBillingFileName(sBaseFileName : String;
                            sAssessmentYear : String;
                            sCollectionType : String;
                            sCollectionNumber : String) : String;

begin
  Result := sBaseFileName + '_' +
            Take(2, sCollectionType) + '_' +
            Copy(sAssessmentYear, 3, 2) + '_' +
            ShiftRightAddZeroes(sCollectionNumber, 2);

end;  {GetBillingFileName}

{====================================================================}
Procedure GetBillingFileNames(    TaxRollYear : String;
                                  CollectionType,
                                  CollectionNum : String;  {For tax rolls a SRAZ num, for assess, 'TN' or 'FI'}
                              var HeaderFileName,
                                  GeneralFileName,
                                  EXFileName,
                                  SDFileName,
                                  SpecialFeeFileName : String);

{Given the tax roll year, collection type, and collection number,
 figure out the file names for the tax files for this collection.}

var
  EndString : String;

begin
  EndString := '_' + Take(2, CollectionType) + '_' +
               Copy(TaxRollYear, 3, 2) + '_' +
               ShiftRightAddZeroes(Take(2, CollectionNum)) + '.DBF';

  HeaderFileName := 'BillHeader' + EndString;
  GeneralFileName := 'BillGeneralTaxDetails' + EndString;
  EXFileName := 'BillExemptionDetails' + EndString;
  SDFileName := 'BillSDDetails' + EndString;
  SpecialFeeFileName := 'BillSpecialFeeDetails' + EndString;

end;  {GetBillingFileNames}

{====================================================================}
Procedure OpenOneBillingFile(    _Table : TTable;
                                 _TableName : String;
                             var Quit : Boolean);

begin
  If (_Table <> nil)
    then
      with _Table do
        try
          Close;
          TableName := _TableName;
          Exclusive := True;
          Open;
        except
          Quit := True;
          SystemSupport(001, _Table, 'Error opening billing table ' + _TableName + '.',
                        'UTILBILL.PAS', GlblErrorDlgBox);
        end;

end;  {OpenOneBillingFile}

{====================================================================}
Procedure OpenBillingFiles(    HeaderFileName,
                               GeneralFileName,
                               EXFileName,
                               SDFileName,
                               SpecialFeeFileName : String;
                               BLHeaderTaxTable,
                               BLGeneralTaxTable,
                               BLExemptionTaxTable,
                               BLSpecialDistrictTaxTable,
                               BLSpecialFeeTaxTable : TTable;
                           var Quit : Boolean);

{Given the billing file names and the billing tax tables,
 open all the billing files.}

begin
  OpenOneBillingFile(BLHeaderTaxTable, HeaderFileName, Quit);
  OpenOneBillingFile(BLGeneralTaxTable, GeneralFileName, Quit);
  OpenOneBillingFile(BLExemptionTaxTable, EXFileName, Quit);
  OpenOneBillingFile(BLSpecialDistrictTaxTable, SDFileName, Quit);
  OpenOneBillingFile(BLSpecialFeeTaxTable, SpecialFeeFileName, Quit);

end;  {OpenBillingFiles}

{====================================================================}
Procedure CopyAndOpenBillingFiles(    TaxRollYear : String;
                                      CollectionType,
                                      CollectionNum : String;  {For tax rolls a SRAZ num, for assess, 'TN' or 'FI'}
                                      BLHeaderTaxTable,
                                      BLGeneralTaxTable,
                                      BLExemptionTaxTable,
                                      BLSpecialDistrictTaxTable,
                                      BLSpecialFeeTaxTable : TTable;
                                  var HeaderFileName,
                                      GeneralFileName,
                                      EXFileName,
                                      SDFileName,
                                      SpecialFeeFileName : String;
                                      CopyFiles : Boolean;
                                  var Quit : Boolean);
{Open up the billing files for this tax roll year, collection type
 and collection number.}

begin
  GetBillingFileNames(TaxRollYear, CollectionType, CollectionNum,
                      HeaderFileName, GeneralFileName,
                      EXFileName, SDFileName, SpecialFeeFileName);

    {CHG07172004-3(2.08): Allow print of history assessment rolls.}

  If CopyFiles
    then
      begin
        CopySortFile(BLHeaderTaxTable, HeaderFileName);
        CopySortFile(BLGeneralTaxTable, GeneralFileName);
        CopySortFile(BLExemptionTaxTable, EXFileName);
        CopySortFile(BLSpecialDistrictTaxTable, SDFileName);
        CopySortFile(BLSpecialFeeTaxTable, SpecialFeeFileName);

      end;  {If CopyFiles}

    {Now open the tax files that we just copied.}

  If not Quit
    then OpenBillingFiles(HeaderFileName, GeneralFileName, EXFileName,
                          SDFileName, SpecialFeeFileName, BLHeaderTaxTable,
                          BLGeneralTaxTable, BLExemptionTaxTable,
                          BLSpecialDistrictTaxTable,
                          BLSpecialFeeTaxTable, Quit);

end;  {CopyAndOpenBillingFiles}

{=========================================================================}
Procedure CopyAndOpenTotalsFiles(    TaxRollYear : String;
                                     CollectionType,
                                     CollectionNum : String;  {For tax rolls a SRAZ num, for assess, 'TN' or 'FI'}
                                     RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                     GeneralTotalsTable,
                                     SDTotalsTable,
                                     SchoolTotalsTable,
                                     EXTotalsTable,
                                     SpecialFeeTotalsTable : TTable;
                                 var GeneralTotFileName,
                                     SchoolTotFileName,
                                     SDTotFileName,
                                     EXTotFileName,
                                     SpecialFeeTotFileName : String;
                                     AssessmentRoll : Boolean;
                                     CopyFiles : Boolean;
                                 var Quit : Boolean);

{Open up the totals files for this tax roll year, collection type
 and collection number.}

begin
  GetTotalsFileNames(TaxRollYear, CollectionType, CollectionNum, RollType,
                     GeneralTotFileName, SchoolTotFileName,
                     EXTotFileName, SDTotFileName, SpecialFeeTotFileName);

  If CopyFiles
    then
      begin
        CopySortFile(GeneralTotalsTable, GeneralTotFileName);
        CopySortFile(SDTotalsTable, SDTotFileName);
        CopySortFile(SchoolTotalsTable, SchoolTotFileName);
        CopySortFile(EXTotalsTable, EXTotFileName);
        CopySortFile(SpecialFeeTotalsTable, SpecialFeeTotFileName);

      end;  {If CopyFiles}

    {Now open the tax files that we just copied.}

  If not Quit
    then OpenTotalsFiles(GeneralTotFileName, EXTotFileName, SDTotFileName,
                         SchoolTotFileName, SpecialFeeTotFileName,
                         GeneralTotalsTable, EXTotalsTable, SDTotalsTable,
                         SchoolTotalsTable, SpecialFeeTotalsTable, AssessmentRoll, Quit);

end;  {CopyAndOpenTotalsFiles}

{====================================================================}
Procedure GetTotalsFileNames(    TaxRollYear : String;
                                 CollectionType,
                                 CollectionNum : String;  {For tax rolls a SRAZ num, for assess, 'TN' or 'FI'}
                                 RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                             var GeneralTotFileName,
                                 SchoolTotFileName,
                                 EXTotFileName,
                                 SDTotFileName,
                                 SpecialFeeTotFileName : String);

{Given the tax roll year, collection type, and collection number,
 figure out the file names for the totals files for this collection.
 Note that the Resource name is appended to the end.}

var
  EndString : String;

begin
  EndString := '_' + Take(2, CollectionType) + '_' +
               Copy(TaxRollYear, 3, 2) + '_' +
               Take(2, CollectionNum) + '.DBF';

  If (RollType = 'X')
    then GeneralTotFileName := 'BillGeneralTaxTotals' + EndString
    else GeneralTotFileName := 'BillGeneralAssessmentTotals' + EndString;

  EXTotFileName := 'BillExemptionTotals' + EndString;
  SDTotFileName := 'BillSDTotals' + EndString;
  SpecialFeeTotFileName := 'BillSpecialFeeTotals' + EndString;
  SchoolTotFileName := 'BillSchoolTotals' + EndString;

end;  {GetTotalsFileNames}

{==================================================================}
Procedure OpenTotalsFiles(    GeneralTotFileName,
                              EXTotFileName,
                              SDTotFileName,
                              SchoolTotFileName,
                              SpecialFeeTotFileName : String;
                              GeneralTotalsTable,
                              EXTotalsTable,
                              SDTotalsTable,
                              SchoolTotalsTable,
                              SpecialFeeTotalsTable : TTable;
                              AssessmentRoll : Boolean;
                          var Quit : Boolean);

{Given the totals file names and the totals files, open them.}

var
  CollectionType : String;

begin
  CollectionType := Copy(GeneralTotFileName, 3, 2);

  GeneralTotalsTable.Close;
  EXTotalsTable.Close;
  SDTotalsTable.Close;
  SchoolTotalsTable.Close;
  SpecialFeeTotalsTable.Close;

  GeneralTotalsTable.DatabaseName := 'PASsystem';
  EXTotalsTable.DatabaseName := 'PASsystem';
  SDTotalsTable.DatabaseName := 'PASsystem';
  SchoolTotalsTable.DatabaseName := 'PASsystem';
  SpecialFeeTotalsTable.DatabaseName := 'PASsystem';

  GeneralTotalsTable.TableType := ttdBase;
  EXTotalsTable.TableType := ttdBase;
  SDTotalsTable.TableType := ttdBase;
  SchoolTotalsTable.TableType := ttdBase;
  SpecialFeeTotalsTable.TableType := ttdBase;

  GeneralTotalsTable.TableName := GeneralTotFileName;
  EXTotalsTable.TableName := EXTotFileName;
  SDTotalsTable.TableName := SDTotFileName;
  SchoolTotalsTable.TableName := SchoolTotFileName;
  SpecialFeeTotalsTable.TableName := SpecialFeeTotFileName;

    {FXX09091998-1: Different keys for the assessment versus billing roll.}

  with GeneralTotalsTable do
    If AssessmentRoll
      then
        begin
          If (CollectionType = 'SC')
            then IndexName := 'BYSCHOOLCODE_RS_HC'
            else IndexName := 'BYSWISCODE_RS_HC';
        end
      else
        If (CollectionType = 'SC')
          then IndexName := 'BYSCHOOLCODE_RS_HC_PRINTORDER'
          else IndexName := 'BYSWISCODE_RS_HC_PRINTORDER';

  with SchoolTotalsTable do
    If (CollectionType = 'SC')
      then IndexName := 'BYSCHOOL_SWIS_RS_HC'
      else IndexName := 'BYSWIS_RS_HC_SCHOOL';

  with SDTotalsTable do
    If (CollectionType = 'SC')
      then IndexName := 'BYSCHOOL_SWIS_RS_HC_SD_EXT_CM'
      else IndexName := 'BYSWISCODE_RS_HC_SD_EXT_CM';

  with EXTotalsTable do
    If (CollectionType = 'SC')
      then IndexName := 'BYSCHOOL_RS_HC_EXCODE'
      else IndexName := 'BYSWIS_RS_HC_EXCODE';

  try
    GeneralTotalsTable.Open;
  except
    Quit := True;
    SystemSupport(001, GeneralTotalsTable, 'Error opening billing general totals table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
  end;

  try
    SchoolTotalsTable.Open;
  except
    Quit := True;
    SystemSupport(001, SchoolTotalsTable, 'Error opening billing school totals table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
  end;

  try
    EXTotalsTable.Open;
  except
    Quit := True;
    SystemSupport(001, EXTotalsTable, 'Error opening billing exemption totals table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
  end;

  try
    SDTotalsTable.Open;
  except
    Quit := True;
    SystemSupport(001, SDTotalsTable, 'Error opening billing SD totals table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
  end;

  try
    SpecialFeeTotalsTable.Open;
  except
    Quit := True;
    SystemSupport(001, SpecialFeeTotalsTable, 'Error opening billing special fee totals table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
  end;

end;  {OpenTotalsFiles}

{==================================================================}
Procedure LoadRateListsFromRateFiles(    TaxRollYear : String;
                                         CollectionType : String;
                                         CollectionNum : Integer;
                                         GeneralRateList,
                                         SDRateList,
                                         SpecialFeeRateList,
                                         BillControlDetailList : TList;
                                         IsBillCalculationOrPrint : Char;  {'C' = calc, 'P' = print}
                                     var Quit : Boolean);

{Load the different rates into TLists so that we don't have to keep looking
 them up in a file.}

var
  FirstTimeThrough, Done : Boolean;
  TempTable : TTable;
  NumRates : Integer;
  GeneralRatePtr : GeneralRatePointer;
  SDRatePtr : SDRatePointer;
  SpecialFeeRatePtr : SpecialFeePointer;
  ControlDetailRatePtr : ControlDetailRecordPointer;
  Insert1, Insert2 : String;

begin
  If (IsBillCalculationOrPrint = 'C')
    then
      begin
        Insert1 := 'bill calculation';
        Insert2 := 'calculate';
      end
    else
      begin
        Insert1 := 'roll print';
        Insert2 := 'print';

      end;  {If (IsBillCalculationOrPrint = 'C')}

  TempTable := TTable.Create(nil);

     {Set up general rate table in the TList.}

  OpenTableForProcessingType(TempTable, 'BCollGeneralRateFile',
                             GlblProcessingType, Quit);
  TempTable.IndexName := 'BYYEAR_COLLTYPE_NUM_ORDER';

  try
    SetRangeOld(TempTable,
                ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
                [TaxRollYear, CollectionType, IntToStr(CollectionNum), '0'],
                [TaxRollYear, CollectionType, IntToStr(CollectionNum), '32000']);

  except
    SystemSupport(002, TempTable, 'Error setting range in general rate table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
    Quit := True;
  end;

  try
    TempTable.First;
  except
    SystemSupport(003, TempTable, 'Error reading 1st record in general rate table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
    Quit := True;
  end;

  NumRates := 0;
  Done := False;
  FirstTimeThrough := True;
  CollectionHasSchoolTax := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          TempTable.Next;
        except
          SystemSupport(004, TempTable, 'Error getting next record in general rate table.',
                        'UTILBILL.PAS', GlblErrorDlgBox);
          Quit := True;
        end;

      {If this is EOF or a different collection, we are done.}

    If (TempTable.EOF or
        (TempTable.FieldByName('CollectionNo').AsInteger <> CollectionNum))
      then Done := True;

      {If this is a rate for this collection, add it to the list.}

    If not (Done or Quit)
      then
        begin
          New(GeneralRatePtr);

            {CHG06241998-2: Load the prior and current levy amounts.}

          with GeneralRatePtr^ do
            begin
              PrintOrder := TempTable.FieldByName('PrintOrder').AsInteger;
              GeneralTaxType  := Take(2, TempTable.FieldByName('GeneralTaxType').Text);

              If (GeneralTaxType = 'SC')
                then CollectionHasSchoolTax := True;

              SwisCode  := Take(6, TempTable.FieldByName('SwisCode').Text);
              SchoolCode := Take(6, TempTable.FieldByName('SchoolCode').Text);
              Description := TempTable.FieldByName('Description').Text;
              HomesteadRate:= TempTable.FieldByName('HomesteadRate').AsFloat;
              NonHomesteadRate  := TempTable.FieldByName('NonHomesteadRate').AsFloat;
              PriorTaxLevy := TempTable.FieldByName('PriorTaxLevy').AsFloat;
              CurrentTaxLevy := TempTable.FieldByName('CurrentTaxLevy').AsFloat;

                {FXX07011998-1: Add state aid field.}

              EstimatedStateAid := TempTable.FieldByName('EstimatedStateAid').AsFloat;

                {FXX11101998-1: Add apply STAR field.}

              ApplySTAR := TempTable.FieldByName('ApplySTAR').AsBoolean;
              BasicSTARCap := TempTable.FieldByName('BasicSTARCap').AsFloat;
              EnhancedSTARCap := TempTable.FieldByName('EnhancedSTARCap').AsFloat;
              NonHstdBasicSTARCap := TempTable.FieldByName('NonHstdBasicSTARCap').AsFloat;
              NonHstdEnhancedSTARCap := TempTable.FieldByName('NonHstdEnhancedSTARCap').AsFloat;

              try
                BillPrintOrder := TempTable.FieldByName('BillPrintGroupOrder').AsInteger;
              except
              end;

            end;  {with GeneralRatePtr do}

          GeneralRateList.Add(GeneralRatePtr);
          NumRates := NumRates + 1;

        end;  {If not (Done or Quit)}

  until (Done or Quit);

    {If there were no tax rates, warn them and ask them if they want to proceed.}

(*  If ((NumRates = 0) and
      (MessageDlg('There are no general tax rates for this collection.' + #13 +
                  'It is strongly recommended that you do not proceed with this ' +
                  Insert1 + '.' + #13 +
                  'Do you want to ' + Insert2 + ' anyway?', mtConfirmation,
                  [mbYes, mbNo], 0) = idNo))
    then Quit := True; *)

     {Set up SD rate table in the TList.}

  TempTable.IndexName := '';
  OpenTableForProcessingType(TempTable, 'BCollSDistRateFile',
                             GlblProcessingType, Quit);
  TempTable.IndexName := 'BYYEAR_TYPE_NUM_SD_EX_CM';

  try
    SetRangeOld(TempTable,
                ['TaxRollYr', 'CollectionType', 'CollectionNo',
                 'SDistCode', 'ExtCode', 'CMFlag'],
                [TaxRollYear, CollectionType, IntToStr(CollectionNum),
                 'AAAAA', '', ''],
                [TaxRollYear, CollectionType, IntToStr(CollectionNum),
                 'ZZZZZ', '', '']);

  except
    SystemSupport(002, TempTable, 'Error setting range in the special district rate table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
    Quit := True;
  end;

  try
    TempTable.First;
  except
    SystemSupport(003, TempTable, 'Error reading 1st record in special district rate table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
    Quit := True;
  end;

  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          TempTable.Next;
        except
          SystemSupport(004, TempTable, 'Error getting next record in special district rate table.',
                        'UTILBILL.PAS', GlblErrorDlgBox);
          Quit := True;
        end;

      {If this is EOF or a different collection, we are done.}

    If (TempTable.EOF or
        (TempTable.FieldByName('CollectionNo').AsInteger <> CollectionNum))
      then Done := True;

      {If this is a rate for this collection, add it to the list.}

    If not (Done or Quit)
      then
        begin
          New(SDRatePtr);

            {CHG06241998-2: Load the prior and current levy amounts.}

          with SDRatePtr^ do
            begin
              SDistCode := Take(5, TempTable.FieldByName('SdistCode').Text);
              ExtCode := Take(2, TempTable.FieldByName('ExtCode').Text);
              CmFlag := TempTable.FieldByName('CmFlag').Text;
              HomesteadRate := TempTable.FieldByName('HomesteadRate').AsFloat;
              NonHomesteadRate := TempTable.FieldByName('NonHomesteadRate').AsFloat;
              PriorTaxLevy := TempTable.FieldByName('PriorTaxLevy').AsFloat;
              CurrentTaxLevy := TempTable.FieldByName('CurrentTaxLevy').AsFloat;

                {FXX03142002-3: Not filling in the SD rate description.}

              Description := TempTable.FieldByName('SDistDescr').Text;

              try
                BillPrintOrder := TempTable.FieldByName('BillPrintGroupOrder').AsInteger;
              except
              end;

            end;  {with SDRatePtr do}

          SDRateList.Add(SDRatePtr);

        end;  {If not (Done or Quit)}

  until (Done or Quit);

    {If there were no SD rates, warn them and ask them if they want to proceed.}
    {CHG08172004-1(2.08.08182004): Cut out this annoying message.}

(*  If ((NumRates = 0) and
      (MessageDlg('There are no special district tax rates for this collection.' + #13 +
                  'It is strongly recommended that you do not proceed with this ' + Insert1 +
                  '.' + #13 +
                  #13 +
                  'Do you want to ' + Insert2 + ' anyway?', mtConfirmation,
                  [mbYes, mbNo], 0) = idNo))
    then Quit := True; *)

     {Set up SpecialFee rate table in the TList.}

  TempTable.IndexName := '';
  OpenTableForProcessingType(TempTable, 'BCollSpclFeeFile',
                             GlblProcessingType, Quit);
  TempTable.IndexName := 'BYYEAR_TYPE_NUM_ORDER';

  try
    SetRangeOld(TempTable,
                ['TaxRollYr', 'CollectionType', 'CollectionNo', 'PrintOrder'],
                [TaxRollYear, CollectionType, IntToStr(CollectionNum), '0'],
                [TaxRollYear, CollectionType, IntToStr(CollectionNum), '32000']);

  except
    SystemSupport(002, TempTable, 'Error setting range in special fee rate table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
    Quit := True;
  end;

  try
    TempTable.First;
  except
    SystemSupport(003, TempTable, 'Error reading 1st record in special fee rate table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
    Quit := True;
  end;

  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          TempTable.Next;
        except
          SystemSupport(004, TempTable, 'Error getting next record in special fee rate table.',
                        'UTILBILL.PAS', GlblErrorDlgBox);
          Quit := True;
        end;

      {If this is EOF or a different collection, we are done.}

    If (TempTable.EOF or
        (TempTable.FieldByName('CollectionNo').AsInteger <> CollectionNum))
      then Done := True;

      {If this is a rate for this collection, add it to the list.}

    If not (Done or Quit)
      then
        begin
          New(SpecialFeeRatePtr);

            {CHG06241998-2: Load the prior and current levy amounts.}

          with SpecialFeeRatePtr^ do
            begin
              PrintOrder := TempTable.FieldByName('PrintOrder').AsInteger;
              FixedAmount  := TempTable.FieldByName('FixedAmount').AsFloat;
              Description := TempTable.FieldByName('Description').Text;
              Percentage := TempTable.FieldByName('Percentage').AsFloat;
              AmtInFirstPayment := TempTable.FieldByName('AmtInFirstPayment').AsBoolean;
              AmtDistribAllPayment:= TempTable.FieldByName('AmtDistribAllPayment').AsBoolean;
              PriorTaxLevy := TempTable.FieldByName('PriorTaxLevy').AsFloat;
              CurrentTaxLevy := TempTable.FieldByName('CurrentTaxLevy').AsFloat;

            end;  {with SpecialFeeRatePtr do}

          SpecialFeeRateList.Add(SpecialFeeRatePtr);

        end;  {If not (Done or Quit)}

  until (Done or Quit);

    {If there were no tax rates, warn them and ask them if they want to proceed.}
    {CHG08172004-1(2.08.08182004): Cut out this annoying message, too.}

(*  If ((NumRates = 0) and
      (IsBillCalculationOrPrint = 'C') and {Don't tell them if this is the print}
      (MessageDlg('There are no special fees for this collection.' + #13 +
                  'If you want to have special fees, please exit and set the special fees.' + #13
                  + #13 +
                  'Do you still want to ' + Insert2 + '?', mtConfirmation,
                  [mbYes, mbNo], 0) = idNo))
    then Quit := True; *)

     {Set up Control Detail rate table in the TList.}

  TempTable.IndexName := '';
  OpenTableForProcessingType(TempTable, 'BCollControlDtlFile',
                             GlblProcessingType, Quit);
  TempTable.IndexName := 'BYYEAR_COLLTYPE_NUM';

  try
    SetRangeOld(TempTable,
                ['TaxRollYr', 'CollectionType', 'CollectionNo'],
                [TaxRollYear, CollectionType, IntToStr(CollectionNum)],
                [TaxRollYear, CollectionType, IntToStr(CollectionNum)]);

  except
    SystemSupport(002, TempTable, 'Error setting range in control detail rate table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
    Quit := True;
  end;

  try
    TempTable.First;
  except
    SystemSupport(003, TempTable, 'Error reading 1st record in control detail rate table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
    Quit := True;
  end;

  NumRates := 0;
  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          TempTable.Next;
        except
          SystemSupport(004, TempTable, 'Error getting next record in control detail rate table.',
                        'UTILBILL.PAS', GlblErrorDlgBox);
          Quit := True;
        end;

      {If this is EOF or a different collection, we are done.}

    If (TempTable.EOF or
        (TempTable.FieldByName('CollectionNo').AsInteger <> CollectionNum))
      then Done := True;

      {If this is a rate for this collection, add it to the list.}

    If not (Done or Quit)
      then
        begin
          New(ControlDetailRatePtr);

          with ControlDetailRatePtr^ do
            begin
              SwisCode := TempTable.FieldByName('SwisCode').Text;
              SchoolCode := TempTable.FieldByName('SchoolCode').Text;
              StartingBillNo := TempTable.FieldByName('StartingBillNo').AsInteger;
              CurrentBillNo := TempTable.FieldByName('StartingBillNo').AsInteger;

            end;  {with ControlDetailRatePtr do}

          BillControlDetailList.Add(ControlDetailRatePtr);
          NumRates := NumRates + 1;

        end;  {If not (Done or Quit)}

  until (Done or Quit);

    {If there were no swis or school codes,
     warn them and ask them if they want to proceed.}

  If ((NumRates = 0) and
      (MessageDlg('There are no swis or school codes specified for this collection.' + #13 +
                  'It is strongly recommended that you do not proceed with this ' + Insert2 + '.' + #13 +
                  #13 +
                  'Do you want to ' + Insert2 + ' anyway?', mtConfirmation,
                  [mbYes, mbNo], 0) = idNo))
    then Quit := True;

  TempTable.Close;
  TempTable.Free;

end;  {LoadRateListsFromRateFiles}

{=======================================================================}
Function FoundSDRate(    SDRateList : TList;
                         _SDCode : String;
                         _ExtCode : String;
                         _CMFlag : String;
                     var I : Integer) : Boolean;

{Match sd code, ext code and cm flag to get rate record}

var
  J : Integer;

begin
  Result := False;

  For J :=  0 to (SDRateList.Count-1) do
    with SDRatePointer(SDRateList[J])^ do
      If ((Take(5, _SDCode) = Take(5, SDistCode)) and
          (Take(2, _ExtCode) = Take(2, ExtCode)) and
          (Take(1, _CMFlag) = Take(1, CMFlag)))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundSDRate}

{==================================================================}
Procedure LoadSDExtCategoryList(    SDExtCategoryList : TList;
                                var Quit : Boolean);

{Load the SD extension categories into a list.}

var
  FirstTimeThrough, Done : Boolean;
  TempTable : TTable;
  SDExtCategoryPtr : SDExtCategoryPointer;

begin
  TempTable := TTable.Create(nil);

     {Set up SD category list.}

  OpenTableForProcessingType(TempTable, 'ZSDExtCodeTbl',
                             GlblProcessingType, Quit);

  try
    TempTable.First;
  except
    SystemSupport(003, TempTable, 'Error reading 1st record in SD category table.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
    Quit := True;
  end;

  Done := False;
  FirstTimeThrough := True;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          TempTable.Next;
        except
          SystemSupport(004, TempTable, 'Error getting next record in SD category table.',
                        'UTILBILL.PAS', GlblErrorDlgBox);
          Quit := True;
        end;

      {If this is EOF, we are done.}

    If TempTable.EOF
      then Done := True;

      {Add it to the list.}

    If not (Done or Quit)
      then
        begin
          New(SDExtCategoryPtr);

          with SDExtCategoryPtr^ do
            begin
              ExtCode := TempTable.FieldByName('MainCode').Text;
              ExtCategory := TempTable.FieldByName('Category').Text;

            end;  {with SDExtCategoryRatePtr do}

          SDExtCategoryList.Add(SDExtCategoryPtr);

        end;  {If not (Done or Quit)}

  until (Done or Quit);

  TempTable.Close;
  TempTable.Free;

end;  {LoadSDExtCategoryList}

{===================================================================}
Function GetSDExtCategory(ExtCode : String;
                          ExtCatList : TList) : String;

{Given an extension, what is the category.}

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (ExtCatList.Count - 1) do
    If (Take(2, ExtCode) =
        Take(2, SDExtCategoryPointer(ExtCatList.Items[I])^.ExtCode))
      then Result := Take(5, SDExtCategoryPointer(ExtCatList.Items[I])^.ExtCategory);

end;  {GetSDExtCategory}

{===================================================================}
Function GetGeneralTaxDesc(    PrintOrder : Integer;
                               GeneralRateList : TList;
                           var GeneralTaxType : String) : String;

{Given a print order for a general tax, return the description.}

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (GeneralRateList.Count - 1) do
    If (GeneralRatePointer(GeneralRateList[I])^.PrintOrder = PrintOrder)
      then
        begin
          Result := Take(20, GeneralRatePointer(GeneralRateList[I])^.Description);
            {FXX12171998-8: Don't print taxable val for relevies.}
          GeneralTaxType := GeneralRatePointer(GeneralRateList[I])^.GeneralTaxType;
        end;

  If (Deblank(Result) = '')
    then Result := 'UNKNOWN';

end;  {GetGeneralTaxDesc}

{===================================================================}
Function GetGeneralTaxType(PrintOrder : Integer;
                           GeneralRateList : TList) : String;

{Given a print order for a general tax, return the description.}
{FXX01091998-6: Need to filter out relevies from hstd/non-hstd tots.}

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (GeneralRateList.Count - 1) do
    If (GeneralRatePointer(GeneralRateList[I])^.PrintOrder = PrintOrder)
      then Result := Take(2, GeneralRatePointer(GeneralRateList[I])^.GeneralTaxType);

end;  {GetGeneralTaxType}

{===================================================================}
Function GetSPFeeTaxDesc(PrintOrder : Integer;
                         SpFeeRateList : TList) : String;

var
  I : Integer;

begin
   Result := '';

  For I := 0 to (SPFeeRateList.Count - 1) do
    If (SpecialFeePointer(SpFeeRateList[I])^.PrintOrder = PrintOrder)
      then Result := Take(20, SpecialFeePointer(SPFeeRateList[I])^.Description);

  If (Deblank(Result) = '')
   then Result := 'UNKNOWN';

end;  {GetSPFTaxDesc}

{===================================================================}
Function FindSpecialFeeRate(PrintOrder : Integer;
                            SpFeeRateList : TList) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (SPFeeRateList.Count - 1) do
    If (SpecialFeePointer(SpFeeRateList[I])^.PrintOrder = PrintOrder)
      then Result := I;

end;  {GetSPFTaxDesc}

{=======================================================================}
Function FindGeneralRate(PrintOrder : Integer;
                         GeneralTaxType : String;
                         SwisCode : String;
                         GeneralRateList : TList) : Integer;

{Find the index of the rate with this print order, tax type and swis code in the general rate list.}

var
  J, CodeLen : Integer;
  TempSwisCode : String;
  _Found : Boolean;

begin
  Result := -1;
  _Found := False;

    {FXX08252004-2(2.08.0.08252004): Only return the index of the first matching rate.}
    {FXX03181999-4: Need to also look up on print order.}

  For J := 0 to (GeneralRateList.Count - 1) do
    If not _Found
      then
        begin
            {FXX03241999-2: The number of digits of swis is determind by the rate,
                            not the incoming swis, ie. a town wide town tax rate would
                            not work if other way around.}

          TempSwisCode := Trim(GeneralRatePointer(GeneralRateList[J])^.SwisCode);
          CodeLen := Length(TempSwisCode);


          If (  ((Deblank(GeneralTaxType) = '') or  {Don't search on tax type}
                  (GeneralRatePointer(GeneralRateList[J])^.GeneralTaxType = GeneralTaxType))
                               and
                ((PrintOrder = -1) or  {Don't search on print order.}
                  (GeneralRatePointer(GeneralRateList[J])^.PrintOrder = PrintOrder))
                                 and
                (Take(CodeLen, TempSwisCode) = Take(CodeLen, SwisCode))
              )
                 {FXX04011999-1 must support call from PrintOneGeneralTax in UTRTOTPT}
                 {  where srch for general rate is by print order only}

                               OR
            (   (GeneralRatePointer(GeneralRateList[J])^.PrintOrder = PrintOrder)
                              AND
                (Deblank(GeneralTaxtype) = '')
                              AND
                (Deblank(SwisCode) = '')
            )
            then
              begin
                Result := J;
                _Found := True;
              end;

        end;  {For J := 0 to (GeneralRateList.Count - 1) do}

end;  {FindGeneralRate}

{=====================================================================}
Procedure LoadTaxesForParcel(    SwisSBLKey : String;
                                 GeneralTaxTable,
                                 SDTaxTable,
                                 EXTaxTable,
                                 SPFeeTaxTable : TTable;
                                 SDCodeDescList,
                                 EXCodeDescList,
                                 GeneralRateList,
                                 SDRateList,
                                 SPFeeRateList,
                                 GnTaxList,
                                 SDTaxList,
                                 SpFeeTaxList,
                                 ExTaxList : TList;
                             var Quit : Boolean);

{Get all taxes, special districts, exemptions and special fees for this
 parcel and put them in memory lists.}

var
  RateIndex : Integer;
  FirstTimeThrough, Done : Boolean;
  GenTaxPtr : GeneralTaxPtr;
  SDTaxPtr : SDistTaxPtr;
  SPFeePtr : SPFeeTaxPtr;
  EXTaxPtr : ExemptTaxPtr;
  SwisCode : String;

begin
  FirstTimeThrough := True;

     {Set up general taxes in memory tlist.}

  SetRangeOld(GeneralTaxTable,
              ['SwisSBLKey', 'HomesteadCode', 'PrintOrder'],
              [Take(26, SwisSBLKey), ' ', '0'],
              [Take(26, SwisSBLKey), 'Z', '32000']);

  GeneralTaxTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else GeneralTaxTable.Next;

    Done := GeneralTaxTable.EOF;

    If not (Done or Quit)
      then
        begin
          New(GenTaxPtr);   {get new pptr for tlist array}

          with GenTaxPtr^ do
            begin
                {FXX12171998-8: Don't print taxable val for relevies.}

              Description := GetGeneralTaxDesc(GeneralTaxTable.FieldByName('PrintOrder').AsInteger,
                                               GeneralRateList, GeneralTaxType);

              TaxableVal := GeneralTaxTable.FieldByName('TaxableValue').AsFloat;
              TaxAmount := GeneralTaxTable.FieldByName('TaxAmount').AsFloat;

                {FXX01071998-2: We need to load the homestead code for
                                general taxes for split parcels. Also,
                                we need the print order so we can combine
                                for parcel totals for split parcels.}

              HomesteadCode := GeneralTaxTable.FieldByName('HomesteadCode').Text;
              PrintOrder := GeneralTaxTable.FieldByName('PrintOrder').AsInteger;

                {FXX06301998-20: Add STAR savings field.}

              STARSavings := Roundoff(GeneralTaxTable.FieldByName('STARSavings').AsFloat , 2);

                {FXX07061998-4: Load the general rates.}

              If (GeneralTaxType = 'CO')
                then SwisCode := Take(4, SwisSBLKey)
                else SwisCode := Take(6, SwisSBLKey);

              RateIndex := FindGeneralRate(PrintOrder, GeneralTaxType,
                                           SwisCode, GeneralRateList);

              If (HomesteadCode = 'N')
                then TaxRate := GeneralRatePointer(GeneralRateList[RateIndex])^.NonhomesteadRate
                else TaxRate := GeneralRatePointer(GeneralRateList[RateIndex])^.HomesteadRate;

            end;  {with GenTaxPtr^ do}

          GnTaxList.Add(GenTaxPtr);

        end;  {If not (Done or Quit)}

  until (Done or Quit);

     {Set up SD taxes in memory tlist.}

  Done := False;
  FirstTimeThrough := True;

  SDTaxTable.CancelRange;
(*  SetRangeOld(SDTaxTable,
              ['SwisSBLKey', 'SDistCode', 'HomesteadCode', 'ExtCode'],
              [SwisSBLKey, '     ', ' ', '  '],
              [SwisSBLKey, 'ZZZZZ', 'Z', 'ZZ']);

  try
    SDTaxTable.First;
  except
    SystemSupport(033, SDTaxTable, 'Error reading 1st record in SD Tax Table',
                  'UTILBILL.PAS', GlblErrorDlgBox);
    Quit := True;
  end; *)

  SDTaxTable.First;
  FindNearestOld(SDTaxTable,
                 ['SwisSBLKey', 'SDistCode', 'HomesteadCode', 'ExtCode'],
                 [Take(26, SwisSBLKey), '', '', '']);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SDTaxTable.Next;

    If (SDTaxTable.EOF or
        (Take(26, SDTaxTable.FieldByName('SwisSBLKey').Text) <> Take(26, SwisSBLKey)))
      then Done := True;

    If not (Done or Quit)
      then
        begin
          New(SDTaxPtr);   {get new pptr for tlist array}

          with SDTaxPtr^ do
            begin
              SDistCode := SDTaxTable.FieldByName('SDistCode').Text;
              Description := GetDescriptionFromList(SDistCode, SDCodeDescList);
              ExtCode := SDTaxTable.FieldByName('ExtCode').Text;
              CMFlag := SDTaxTable.FieldByName('CMFLag').Text;
              SDValue := SDTaxTable.FieldByName('AVAmtUnitDim').AsFloat;
              SDAmount := SDTaxTable.FieldByName('TaxAmount').AsFloat;

                {FXX03142002-2: Uninitialized.}
                {FXX12132004-1(2.8.1.3): Make sure that the homestead code is filled in.}

              HomesteadCode := SDTaxTable.FieldByName('HomesteadCode').Text;
              CombinedDistrictRecord := False;

            end;  {with SDTaxPtr^ do}

          SDTaxList.Add(SDTaxPtr);

        end;  {If not (Done or Quit)}

  until (Done or Quit);

     {Set up SPFee taxes in memory tlist.}

  FirstTimeThrough := True;

  SetRangeOld(SPFeeTaxTable,
              ['SwisSBLKey', 'PrintOrder'],
              [SwisSBLKey, '0'],
              [SwisSBLKey, '32000']);

  SPFeeTaxTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SPFeeTaxTable.Next;

    Done := SPFeeTaxTable.EOF;

    If not (Done or Quit)
      then
        begin
          New(SPFeePtr);   {get new pptr for tlist array}

          with SPFeePtr^ do
            begin
              PrintOrder := SPFeeTaxTable.FieldByName('PrintOrder').AsInteger;
              Description := GetSPFeeTaxDesc(PrintOrder, SpFeeRateList);
              SPAmount := SPFeeTaxTable.FieldByName('TaxAmount').AsFloat;

            end;  {with SPFeePtr^ do}

          SPFeeTaxList.Add(SPFeePtr);

        end;  {If not (Done or Quit)}

  until (Done or Quit);

     {Set up EX taxes in memory tlist.}

  FirstTimeThrough := True;

  SetRangeOld(EXTaxTable,
              ['SwisSBLKey', 'HomesteadCode', 'EXCode'],
              [SwisSBLKey, ' ', '     '],
              [SwisSBLKey, 'Z', 'ZZZZZ']);

  EXTaxTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else EXTaxTable.Next;

    Done := EXTaxTable.EOF;

    If not (Done or Quit)
      then
        begin
          New(EXTaxPtr);   {get new pptr for tlist array}

            {FXX01071998-1: We need the homestead code of the exemption
                            for split parcels.}

          with EXTaxPtr^ do
            begin
              EXCode := EXTaxTable.FieldByName('EXCode').Text;
              HomesteadCode := EXTaxTable.FieldByName('HomesteadCode').Text;
              Description := GetDescriptionFromList(EXCode, EXCodeDescList);
              CountyAmount := EXTaxTable.FieldByName('CountyAmount').AsFloat;
              TownAmount := EXTaxTable.FieldByName('TownAmount').AsFloat;
              SchoolAmount := EXTaxTable.FieldByName('SchoolAmount').AsFloat;
              VillageAmount := EXTaxTable.FieldByName('VillageAmount').AsFloat;

                {FXX01201998-4: Load the initial year for the commitment
                                warning.}

              InitialYear := EXTaxTable.FieldByName('InitialYear').Text;

                {CHG11302006-1(2.11.1.4): Accomodate new full value of exemption requirements.}

              try
                FullValue := EXTaxTable.FieldByName('FullValue').AsInteger;
              except
                FullValue := 0;
              end;

            end;  {with EXTaxPtr^ do}

          EXTaxList.Add(EXTaxPtr);

        end;  {If not (Done or Quit)}

  until (Done or Quit);

end;  {LoadTaxesForParcel}

{==================================================================}
Function GetAndSetMaxLines(CL1List,
                           CL2List,
                           CL3List,
                           CL4List,
                           CL5List,
                           CL6List,
                           CL7List,
                           LineTypeList : TStringList) : Integer;

{return elements of largest str list, = most lines to be printed}
{and set elements of all strlists to that same amount}

var
  I, Max : Integer;

begin
  Max := MaxInt2([CL1List.Count, CL2List.Count, CL3List.Count, CL4List.Count,
                  CL5List.Count, CL6List.Count, CL7List.Count]);

  If CL1List.count < Max
     then For I := 1 to (Max - CL1List.Count )
       do CL1List.Add('   ');
  If CL2List.count < Max
     then For I := 1 to (Max - CL2List.Count )
       do CL2List.Add('   ');
  If CL3List.count < Max
     then For I := 1 to (Max - CL3List.Count )
       do CL3List.Add('   ');
  If CL4List.count < Max
     then For I := 1 to (Max - CL4List.Count )
       do CL4List.Add('   ');
  If CL5List.count < Max
     then For I := 1 to (Max - CL5List.Count )
       do CL5List.Add('   ');
  If CL6List.count < Max
     then For I := 1 to (Max - CL6List.Count )
       do CL6List.Add('   ');
  If CL7List.count < Max
    then
      For I := 1 to (Max - CL7List.Count ) do
        begin
          CL7List.Add('   ');
          LineTypeList.Add('M');
        end;

  Result := Max;

end;  {GetAndSetMaxLines}

{==================================================================}
Procedure FillInExemptions(CL4List,
                           CL5List,
                           CL6List,
                           CL7List,
                           LineTypeList : TSTringList;
                           HomesteadCode : String;
                           CollectionType : String;
                           ExTaxList : TList);

{Put all the exemptions in columns 4-7 decending.}
{FXX01061998-8: Print only homestead, non-homestead or both in order
                to print split parcels.}

var
  I : Integer;
  TempStr1, TempStr2, TempStr3 : String;

begin
  For I := 0 to (ExTaxList.Count - 1) do
    If ((Deblank(HomesteadCode) = '') or  {Don't worry about homestead code}
        (ExemptTaxPtr(ExTaxList[I])^.HomesteadCode = HomesteadCode)) {or it matches.}
      then
        begin
          CL4List.Add(ExemptTaxPtr(ExTaxList[I])^.EXCode + ' ' +
                      Take(14, UpcaseStr(ExemptTaxPtr(ExTaxList[I])^.Description)));

          TempStr1 := '';
          TempStr2 := '';
          TempStr3 := '';

           {CHG10302000-1: Need to allow user to specify exactly which municipalities
                           print on the roll.}

          If (mtpCounty in MunicipalitiesToPrint)
            then TempStr1 := FormatFloat(IntegerDisplay,
                                         ExemptTaxPtr(ExTaxList[I])^.CountyAmount);

            {FXX05261998-7: Blank zeroes if an exemption does not apply
                            to a category.}

(*          TempStr1 := FormatFloat(IntegerDisplay,
                                  ExemptTaxPtr(ExTaxList[I])^.CountyAmount);*)

            {FXX12231997-3: If this is a school exemption don't show town ex
                            amount and vice-versa.}

(*          If (CollectionType = 'SC')
            then TempStr2 := ''
            else TempStr2 := FormatFloat(CurrencyDisplayNoDollarSign,
                                         ExemptTaxPtr(ExTaxList[I])^.TownAmount);

          If ((CollectionType = 'MU') or
              (CollectionType = 'VI'))
            then TempStr3 := ''
            else TempStr3 := FormatFloat(CurrencyDisplayNoDollarSign,
                                         ExemptTaxPtr(ExTaxList[I])^.SchoolAmount);

          CL5List.Add(TempStr1);
          CL6List.Add(TempStr2);
          CL7List.Add(TempStr3); *)

            {FXX05261998-5: Fill in all exemptions in the first 2 cols.}
            {FXX05271998-1: Only show the school ex amount for school roll.}
           {CHG10302000-1: Need to allow user to specify exactly which municipalities
                           print on the roll.}

          If (CollectionType = 'SC')
            then
              begin
                If (mtpSchool in MunicipalitiesToPrint)
                  then TempStr1 := FormatFloat(IntegerDisplay,
                                               ExemptTaxPtr(ExTaxList[I])^.SchoolAmount);
                TempStr3 := '';
              end
            else
              If (CollectionType = VillageTaxType)
                then
                  begin
                    If (mtpPartialVillage in MunicipalitiesToPrint)
                      then TempStr2 := FormatFloat(IntegerDisplay,
                                                   ExemptTaxPtr(ExTaxList[I])^.VillageAmount);

                  end
                else
                  begin
                    If (mtpTown in MunicipalitiesToPrint)
                      then TempStr2 := FormatFloat(IntegerDisplay,
                                                   ExemptTaxPtr(ExTaxList[I])^.TownAmount);

                    If (mtpSchool in MunicipalitiesToPrint)
                      then TempStr3 := FormatFloat(IntegerDisplay,
                                                   ExemptTaxPtr(ExTaxList[I])^.SchoolAmount);

                  end;  {If (CollectionType = 'SC')}

          CL5List.Add(TempStr1);
          CL6List.Add(TempStr2);
          CL7List.Add(TempStr3);

          LineTypeList.Add('E');

        end;  {For I := 0 to (ExTaxList.Count - 1) do}

end;  {FillInExemptions}

{==================================================================}
Procedure FillInGeneralTaxes(CL2List,
                             CL4List,
                             CL5List,
                             CL6List,
                             CL7List,
                             LineTypeList : TStringList;
                             RollType : Char;  {'X' = Tax roll; 'T' = tenative, 'F' = final}
                             HomesteadCode : String;
                             GnTaxList : TList);

{Put the general tax amounts into columns 4-7 decending.}
{FXX01061998-8: Print only homestead, non-homestead or both in order
                to print split parcels.}

var
  I : Integer;

begin
  For I := 0 to (GnTaxList.Count - 1) do
    If ((Deblank(HomesteadCode) = '') or  {Don't worry about homestead code}
        (GeneralTaxPtr(GnTaxList[I])^.HomesteadCode = HomesteadCode)) {or it matches.}
      then
        with GeneralTaxPtr(GnTaxList[I])^ do
          begin
              {CHG08222002-1: Add the STAR savings to the roll.}
              {FXX09172002-1: This was unititialized for assessment rolls.}

            If ((HomesteadCode <> 'S') or
                ((HomesteadCode = 'S') and
                 (GeneralTaxPtr(GnTaxList[I])^.HomesteadCode = 'H')))
            then
              try
                If (Roundoff(STARSavings, 2) > 0)
                  then CL2List.Add('STAR Savings: ' +
                                   FormatFloat(CurrencyDecimalDisplay,
                                               STARSavings));
              except
              end;

            (*If (GeneralTaxPtr(GnTaxList[I])^.GeneralTaxType = 'SC') *)

            CL4List.Add(UpcaseStr(Take(20, Description)));

              {FXX01061998-7: Make taxable value blank if none.}
              {FXX05271998-8: Don't make taxable value blank if none.}

             {FXX12171998-8: Don't print taxable val for relevies.}

            If ((GeneralTaxType = 'VR') or
                (GeneralTaxType = 'SR'))
              then CL5List.Add('')
              else CL5List.Add(FormatFloat(CurrencyDisplayNoDollarSign,
                                           TaxableVal));
            CL6List.Add(' ');

              {FXX12231997-1: If the tax amount is zero, display blank.}

            If (RollType = 'X')
              then CL7List.Add(FormatFloat(DecimalDisplay_BlankZero,
                                           TaxAmount))
              else CL7List.Add('');

            LineTypeList.Add('G');

          end;  {For I := 0 to (GnTaxList.Count - 1) do}

end;  {FillInGeneralTaxes}

{==================================================================}
Procedure FillInSDTaxes(CL4List,
                        CL5List,
                        CL6List,
                        CL7List,
                        LineTypeList : TStringList;
                        RollType : Char;  {'X' = Tax roll; 'T' = tenative, 'F' = final}
                        TotalAssessedVal : Comp;
                        SuppressSDExtensions : Boolean;
                        SDExtCategoryList,
                        SDTaxList : TList;
                        _HomesteadCode : String);

{Put all the SD taxes in columns 4 - 7 decending.}
{CHG12142004-1(2.8.1.3): Add homestead to special districts.}

type
    {This record combines the tax amount and the extensions for
     one special district code.}

  TempSDRecord = Record
    SDCode : String;
    SDDescription : String;
    ExtCodes : Array[1..10] of String;
    ExtCategories : Array[1..10] of String;
    CMFlags : Array[1..10] of String;
    HomesteadCodes : Array[1..10] of String;
    SDValues : Array[1..10] of Double;
    SDTaxAmount : Double;
    SDExemptionAmount : Comp;
  end;  {TempSDRecord = Record}

  PTempSDRecord = ^TempSDRecord;

var
  I, J, Index, NumExtensionsPrinted : Integer;
  LastSDCode : String;
  PTempSDRec : PTempSDRecord;
  TempSDList : TList;
  TempStr, TempVal : String;

begin
  LastSDCode := '';
  TempSDList := TList.Create;
  Index := 0;
  PTempSDRec := nil;

  For I := 0 to (SDTaxList.Count - 1) do
    with SDistTaxPtr(SDTaxList[I])^ do
      If ((Trim(_HomesteadCode) = '') or
          (_HomesteadCode = HomesteadCode))
        then
          If (LastSDCode = SDistCode)
            then
              begin
                  {This is another extension for the same SD code.}

                with PTempSDRec^ do
                  begin
                    ExtCodes[Index] := ExtCode;
                    ExtCategories[Index] := GetSDExtCategory(ExtCode, SDExtCategoryList);
                    CMFlags[Index] := CMFlag;
                    SDValues[Index] := SDValue;
                    HomesteadCodes[Index] := HomesteadCode;
                    SDTaxAmount := SDTaxAmount + SDAmount;

                      {FXX12231997-4: Figure out the SD exemption amount so
                                      that we can print it.}

                    If (ExtCode = 'TO')
                      then SDExemptionAmount := TotalAssessedVal - SDValue;

                  end;  {with PTempSDRec^ do}

                Index := Index + 1;

              end
            else
              begin
                  {Add the last SD rec pointer to the list if there was one.}

                If (Deblank(LastSDCode) <> '')
                  then TempSDList.Add(PTempSDRec);

                  {New SD code.}
                New(PTempSDRec);

                with PTempSDRec^ do
                  begin
                    SDCode := SDistCode;

                    For J := 1 to 10 do
                      begin
                        ExtCodes[J] := '';
                        ExtCategories[J] := '';
                        CMFlags[J] := '';
                        HomesteadCodes[J] := '';
                        SDValues[J] := 0;
                      end;  {For J := 1 to 10 do}

                    ExtCodes[1] := ExtCode;
                    ExtCategories[1] := GetSDExtCategory(ExtCode, SDExtCategoryList);
                    CMFlags[1] := CMFlag;
                    HomesteadCodes[1] := HomesteadCode;
                    SDValues[1] := SDValue;
                    SDTaxAmount := SDAmount;
                    SDDescription := Description;

                   {FXX12231997-4: Figure out the SD exemption amount so
                                      that we can print it.}

                    If (ExtCode = 'TO')
                      then SDExemptionAmount := TotalAssessedVal - SDValue
                      else SDExemptionAmount := 0;

                    Index := 2;

                  end;  {with PTempSDRec^ do}

                LastSDCode := SDistCode;

              end;  {For I := 0 to (SDTaxList.Count - 1) do}

    {Add the last SD rec pointer to the list if there was one.}

  If (Trim(LastSDCode) <> '')
    then TempSDList.Add(PTempSDRec);

    {Now print the special districts. Note that there will be one entry
     in the TempSDList for each SD code.}

  For I := 0 to (TempSDList.Count - 1) do
    with PTempSDRecord(TempSDList[I])^ do
      begin
        NumExtensionsPrinted := 1;

          {Print out the first line.}

        CL4List.Add(SDCode + ' ' +
                    UpcaseStr(Take(15, SDDescription)));

        If _Compare(ExtCategories[1], SDistCategoryADVL, coEqual)
          then CL5List.Add(FormatFloat(CurrencyDisplayNoDollarSign, SDValues[1]))
          else CL5List.Add(FormatFloat(DecimalDisplay, SDValues[1]));

          {CHG11022004-2(2.8.0.16)[1967]: Add the option to suppress the SD extensions on the roll.}

        If SuppressSDExtensions
          then CL6List.Add('')
          else CL6List.Add(ExtCodes[1] + ' ' + Take(1, CMFlags[1]));

          {FXX12231997-1: If the tax amount is zero, display blank.}

        If (RollType = 'X')
          then CL7List.Add(FormatFloat(DecimalDisplay_BlankZero, SDTaxAmount))
          else CL7List.Add('');

        LineTypeList.Add('D');

          {Now print out any additional extensions if there are any.}

        For J := 2 to 10 do
          If (Deblank(ExtCodes[J]) <> '')
            then
              If Odd(J)
                then
                  begin
                    If (ExtCategories[J] = SDistCategoryADVL)
                      then CL5List.Add(FormatFloat(CurrencyDisplayNoDollarSign, SDValues[J]))
                      else CL5List.Add(FormatFloat(DecimalDisplay, SDValues[J]));

                    CL6List.Add(ExtCodes[J] + ' ' + Take(1, CMFlags[J]));

                    CL7List.Add('');

                    LineTypeList.Add('D');

                    NumExtensionsPrinted := NumExtensionsPrinted + 1;

                  end
                else
                  begin
                      {If this is an even number exentsion, it goes underneath
                       the SD description.}

                    TempStr := Take(5, '');

                    If (ExtCategories[J] = SDistCategoryADVL)
                      then TempVal := FormatFloat(CurrencyDisplayNoDollarSign, SDValues[J])
                      else TempVal := FormatFloat(DecimalDisplay, SDValues[J]);

                    TempStr := TempStr + ShiftRightAddBlanks(Take(8, TempVal));

                    TempStr := TempStr + '  ' + ExtCodes[J] + ' ' + Take(1, CMFlags[J]);

                    CL4List.Add(TempStr);

                    NumExtensionsPrinted := NumExtensionsPrinted + 1;

                  end;  {else of If Odd(J)}

          {FXX02262002-1: This needs to be before the exemption extension
                          print in case the SD print ends on column 4 and
                          there is an exemption.}
          {If we finished printing out the extra extensions on an even
           extension, we have to fill the other columns so that they
           all have an even number of entries.}

        If ((NumExtensionsPrinted > 1) and
            (not Odd(NumExtensionsPrinted)))
          then
            begin
              CL5List.Add('');
              CL6List.Add('');
              CL7List.Add('');
              LineTypeList.Add('D');

            end;  {If ((NumExtensionsPrinted > 1) and ...}

          {FXX12231997-4: If there is an SD exemption amount, print it.}

        If (Roundoff(SDExemptionAmount, 0) > 0)
          then
            begin
              TempStr := Take(5, '');

              TempVal := FormatFloat(CurrencyDisplayNoDollarSign, SDExemptionAmount);
              TempStr := TempStr + ShiftRightAddBlanks(Take(8, TempVal));

              TempStr := TempStr + '  ' + 'EX' + ' ' + Take(1, '');

              CL4List.Add(TempStr);
              CL5List.Add('');
              CL6List.Add('');
              CL7List.Add('');
              LineTypeList.Add('D');

            end;  {If (Roundoff(SDExemptionAmount, 0) > 0)}

      end;  {with PTempSDRecord(TempSDList[I])^ do}

  FreeTList(TempSDList, SizeOf(TempSDRecord));

end;  {FillInSDTaxes}

{==================================================================}
Procedure FillInSPFeeTaxes(CL4List,
                           CL5List,
                           CL6List,
                           CL7List,
                           LineTypeList : TStringList;
                           SPTaxList : TList);

{Fill in the special fee taxes in columns 4-7.}

var
  I : Integer;

begin
  For I := 0 to (SPTaxList.Count - 1) do
    begin
      CL4List.Add(Take(10, UpcaseStr(SPFeeTaxPtr(SPTaxList[I])^.Description)));
      CL5List.Add(' ');
      CL6List.Add(' ');

        {FXX12231997-1: If the tax amount is zero, display blank.}

      CL7List.Add(FormatFloat(DecimalDisplay_BlankZero,
                              SPFeeTaxPtr(SPTaxList[I])^.SPAmount));

      LineTypeList.Add('F');

    end;  {For I := 0 to (SPTaxList.Count - 1) do}

end;  {FillInSPFeeTaxes}

{=====================================================================}
Procedure FillInPropertyInformation(HeaderTaxTable,
                                    AssessmentYearCtlTable,
                                    SwisCodeTable,
                                    ParcelTable : TTable;
                                    SwisSBLKey : String;
                                    RollType : Char;  {'X' = Tax, 'T' = Tenative, 'F' = Final}
                                    PropertyClassDescList,
                                    SchoolCodeDescList,
                                    ExTaxList : TList;
                                    CL1List,
                                    CL2List,
                                    CL3List,
                                    CL4List,
                                    CL5List,
                                    CL6List,
                                    CL7List,
                                    LineTypeList : TStringList;
                                    PrintZoningCode,
                                    PrintAdditionalLots,
                                    PrintPermits,
                                    UseNassauPrintKeyFormat : Boolean);

{Fill in the property information into columns 1 - 3}
{CHG03082003-1: Allow them to print the zoning code on the assessment roll.}

var
  TempHomesteadCode, CommitmentCode : String;
  TempStr : String;
  I, TempLen, TempYearInt : Integer;
  TempYear, CommitmentTermYear : String;
  AgExemptionFound, ForestExemptionFound,
  FarmBuildingExemptionFound : Boolean;
  UniformPercentOfValue, FullMarketValue : Extended;
  SBLRec : SBLRecord;

begin
  with HeaderTaxTable do
    begin
      TempHomesteadCode := Take(1, FieldByName('HomesteadCode').Text);

        {column 1 SBL, name, address}

      CL1List.Add(''); {null}

        {Append the check digit to the SBL so that it always comes
         out in the last two spaces of this column.}
        {CHG04042004-1(2.07l2): Allow for Nassau formatting and ordering on assessment roll.}

      If UseNassauPrintKeyFormat
        then
          try
            TempStr := FieldByName('PrintKey').Text;
          except
            TempStr := '';
          end
        else TempStr := ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text);
      TempLen := Length(Trim(TempStr));

      For I := (TempLen + 1) to 22 do
        TempStr := TempStr + ' ';

      TempStr := TempStr + FieldByName('CheckDigit').Text;

      CL1List.Add(TempStr);

      If (Deblank(FieldByName('Name1').Text) <> '')
        then CL1List.Add(FieldByName('Name1').Text);

      If (Deblank(FieldByName('Name2').Text) <> '')
        then CL1List.Add(FieldByName('Name2').Text);

      If (Deblank(FieldByName('Address1').Text) <> '')
        then CL1List.Add(FieldByName('Address1').Text);

      If (Deblank(FieldByName('Address2').Text) <> '')
        then CL1List.Add(FieldByName('Address2').Text);

      If (Deblank(FieldByName('Street').Text) <> '')
        then CL1List.Add(FieldByName('Street').Text);

      CL1List.Add(Rtrim(FieldByName('City').Text) + ' ' +
                  FieldByName('State').Text + ' ' +
                  FieldByName('Zip').Text);

        {CHG06212000-1: Print Old Parcel IDs.}

      If GlblUseOldParcelIDsForSales
        then
          begin
            SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

            with SBLRec do
              FindKeyOld(ParcelTable,
                         ['TaxRollYr', 'SwisCode', 'Section',
                          'Subsection', 'Block', 'Lot', 'Sublot',
                          'Suffix'],
                         [HeaderTaxTable.FieldByName('TaxRollYr').Text,
                          SwisCode, Section, Subsection, Block, Lot, Sublot, Suffix]);

            CL1List.Add('Old ID: ' +
                        ConvertSBLOnlyToOldDashDot(Copy(ParcelTable.FieldByName('RemapOldSBL').Text, 7, 20),
                                                    AssessmentYearCtlTable));

          end;  {If GlblUseOldParcelIDsForSales}

        {FXX01061998-4: Print the prior owner.}

      If (Deblank(FieldByName('PriorOwner').Text) <> '')
        then
          begin
            Cl1List.Add('');
            CL1List.Add('PRIOR OWNER ON ' +
                        AssessmentYearCtlTable.FieldByName('TaxableStatusDate').Text);
            Cl1List.Add(FieldByName('PriorOwner').Text);

          end;  {If (Deblank(FieldByName('PriorOwner').Text <> '')}

       {column 2: legal addr, prop cls, school, prop desc 1,
           frt/depth or acreage, coordinates,deedbk/pg, bank code}
        {FXX04182004-2(2.08): Make sure to trim the legal addr no + legal addr in case
                              the legal addr no is blank.}

      CL2List.Add(Take(25, Trim(RTrim(FieldByName('LegalAddrNo').Text) + ' ' +
                                FieldByName('LegalAddr').Text)));

      CL2List.Add(FieldByName('PropertyClassCode').Text + ' ' +
                  Take(20, UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                        PropertyClassDescList))));

      CL2List.Add(Take(19, UpcaseStr(GetDescriptionFromList(FieldByName('SchoolDistCode').Text,
                                                        SchoolCodeDescList)) + ' ' +
                  FieldByName('SchoolDistCode').Text));

      If (Deblank(FieldByName('PropDescr1').Text) <> '')
        then CL2List.Add(FieldByName('PropDescr1').Text);

        {FXX05301998-1: Need the other property descriptions, too.}

      If (Deblank(FieldByName('PropDescr2').Text) <> '')
        then CL2List.Add(FieldByName('PropDescr2').Text);

      If (Deblank(FieldByName('PropDescr3').Text) <> '')
        then CL2List.Add(FieldByName('PropDescr3').Text);

      case TempHomesteadCode[1] of
        ' ',
        'H' : If (FieldByName('HstdAcreage').AsFloat > 0)
                then CL2List.Add('ACREAGE  ' +
                                 FormatFloat(DecimalDisplay,
                                             FieldByName('HstdAcreage').AsFloat));

        'N' : If (FieldByName('NonHstdAcreage').AsFloat > 0)
                then CL2List.Add('ACREAGE  ' +
                                 FormatFloat(DecimalDisplay,
                                             FieldByName('NonHstdAcreage').AsFloat));

        'S' : If (FieldByName('NonHstdAcreage').AsFloat > 0)
                then CL2List.Add('ACREAGE  ' +
                                 FormatFloat(DecimalDisplay,
                                             (FieldByName('HstdAcreage').AsFloat +
                                              FieldByName('NonHstdAcreage').AsFloat)));

      end;  {case TempHomesteadCode of}

      If ((Roundoff(FieldByName('Frontage').AsFloat, 2) > 0) or
          (Roundoff(FieldByName('Depth').AsFloat, 2) > 0))
        then CL2List.Add('FRNT ' +
                         FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) + ' ' +
                         'DPTH ' +
                         FormatFloat(DecimalDisplay, FieldByName('Depth').AsFloat));

      If ((FieldByName('GridCordEast').AsInteger <> 0) or
          (FieldByName('GridCordNorth').AsInteger <> 0))
        then CL2List.Add('EAST  ' + FieldByName('GridCordEast').Text +
                         '  NRTH  ' + FieldByName('GridCordNorth').Text);

        {FXX12231997-5: Sometimes the deed book or page is just zeroes -
                        don't print it.}

      If ((Deblank(DezeroOnLeft(FieldByName('DeedBook').Text)) <> '') or
          (Deblank(DezeroOnLeft(FieldByName('DeedPage').Text)) <> ''))
        then CL2List.Add('DEED BK  ' + FieldByName('DeedBook').Text +
                         '  PG  ' + FieldByName('DeedPage').Text);

      If (Deblank(FieldByName('BankCode').Text) <> '')
         then CL2List.Add('BANK ' + FieldByName('BankCode').Text);

        {CHG04032000-1: Print full market value on rolls.}

      If GlblPrintFullMarketValue
        then
          begin
            FindKeyOld(SwisCodeTable, ['SwisCode'], [Take(6, SwisSBLKey)]);
            FullMarketValue := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                                 FieldByName('NonhstdTotalVal').AsFloat),
                                                SwisCodeTable,
                                                FieldByName('PropertyClassCode').Text,
                                                ' ', True);
            CL2List.Add('FULL MKT VAL  ' +
                        FormatFloat(CurrencyDisplayNoDollarSign, FullMarketValue));

          end;  {If GlblPrintFullMarketValue}

       {CHG03082003-1(2.06q): Allow them to print the zoning code on the assessment roll.}

      If (PrintZoningCode and
          (Deblank(FieldByName('ZoningCode').Text) <> ''))
        then
          try
            CL2List.Add('ZONING: ' + FieldByName('ZoningCode').Text);
          except
          end;

      {Column 3, Homestead caption, land, and total value}

        {FXX01061998-8: If class, do seperately.}

      If (TempHomesteadCode <> 'S')
        then
          begin
            case TempHomesteadCode[1] of
              ' ' : CL3List.Add('');  {Blank}
              'H' : CL3List.Add('HOMESTEAD');
              'N' : CL3List.Add('NON-HOMESTEAD');

            end;  {case TempHomesteadCode[1] of}

            CL3List.Add(' '); {null 2n line}

            case TempHomesteadCode[1] of
              ' ',
              'H' : CL3List.Add(FormatFloat(CurrencyDisplayNoDollarSign,
                                            FieldByName('HstdLandVal').AsFloat));
              'N' : CL3List.Add(FormatFloat(CurrencyDisplayNoDollarSign,
                                            FieldByName('NonhstdLandVal').AsFloat));

            end;  {case TempHomesteadCode of}

            CL3List.Add(' '); {null 4TH Line}

            case TempHomesteadCode[1] of
              ' ',
              'H' : CL3List.Add(FormatFloat(CurrencyDisplayNoDollarSign,
                                            FieldByName('HstdTotalVal').AsFloat));
              'N' : CL3List.Add(FormatFloat(CurrencyDisplayNoDollarSign,
                                            FieldByName('NonhstdTotalVal').AsFloat));

            end;  {case TempHomesteadCode of}

                {rest of col 3 will be filled out}

            CL4List.Add(' ');

            If (Deblank(FieldByName('AccountNumber').Text) = '')
              then CL5List.Add('')
              else CL5List.Add('ACCT: ' + FieldByName('AccountNumber').Text);

            CL6List.Add(' ');

            If (RollType = 'X')
              then
                begin
                    {FXX01201998-9: If the bill number is blank, don't print the word bill.}
                    {FXX08201999-4: But do include a space.}

                  If (Deblank(DezeroOnLeft(FieldByName('BillNo').Text)) <> '')
                    then CL7List.Add('BILL ' + ShiftRightAddBlanks(Take(6, DezeroOnLeft(FieldByName('BillNo').Text))))
                    else CL7List.Add('');
                end
              else CL7List.Add('');

            LineTypeList.Add('M');

          end;  {If (TempHomesteadCode <> 'S')}

        {FXX01131998-1: Add land commitment warnings.}

      CommitmentCode := FieldByName('CommitmentCode').Text;
      CommitmentTermYear := FieldByName('CommTermYear').Text;

        {First do the agdist law.}

      AgExemptionFound := False;

        {FXX06251998-3: Remove the word 'LAW' from the ag dist warnings - it takes up too much room.}
        {FXX06251998-16: To figure out the commitment termination year, use the
                        assessment year.}

      For I := 0 to (EXTaxList.Count - 1) do
        If ((ExemptTaxPtr(EXTaxList[I])^.EXCode = '41720') or
            (ExemptTaxPtr(EXTaxList[I])^.EXCode = '41730'))
          then
            begin
              AgExemptionFound := True;

                {If there is no commitment term year filled in,
                 do 8 years beyond the init of the ag exemption -
                 as per Rose Ripple in Ramapo. - Don't forget to include
                 the starting year.}

              If (Deblank(CommitmentTermYear) = '')
                then
                  begin
                    TempYear := GlblThisYear;

                      {FXX01201998-3: Add an exception handler in case
                                      the initial year was no good.}

                    try
                      TempYearInt := StrToInt(TempYear);
                      TempYearInt := TempYearInt + 7;  {7 includes that year}
                      CommitmentTermYear := IntToStr(TempYearInt);
                    except
                      CommitmentTermYear := '';
                    end;

                  end;  {If (Deblank(CommitmentTermYear) = '')}

            end;  {If ((ExemptTaxRecord(EXTaxList[I])^.EXCode = '41720') or ...}

        {FXX06291998-1: Change 'PENALTY' to 'PAYMENT'.}

      If ((CommitmentCode[1] in ['D', 'P']) or
          AgExemptionFound)
        then
          begin
            CL1List.Add('');
            CL1List.Add('MAY BE SUBJECT TO PAYMENT');
            CL1List.Add('UNDER AGDIST TIL ' + CommitmentTermYear);

          end;  {If ((CommitmentCode[1] in ['D', 'P']) or ...}

        {Now do the forest commitment law.}

      ForestExemptionFound := False;

      For I := 0 to (EXTaxList.Count - 1) do
        If (ExemptTaxPtr(EXTaxList[I])^.EXCode = '47460')
          then
            begin
              ForestExemptionFound := True;

                {FXX06251998-8: Forest commitment is 10 years.}
                {If there is no commitment term year filled in,
                 do 10 years beyond the init of the forest exemption}

              If (Deblank(CommitmentTermYear) = '')
                then
                  begin
                    TempYear := GlblThisYear;
                    TempYearInt := StrToInt(TempYear);
                    TempYearInt := TempYearInt + 9;  {9 includes that year}
                    CommitmentTermYear := IntToStr(TempYearInt);

                  end;  {If (Deblank(CommitmentTermYear) = '')}

            end;  {If ((ExemptTaxRecord(EXTaxList[I])^.EXCode = '41720') or ...}

      If ((CommitmentCode = 'F') or
          ForestExemptionFound)
        then
          begin
            CL1List.Add('');
            CL1List.Add('MAY BE SUBJECT TO PAYMENT');
            CL1List.Add('UNDER RPTL480A TIL ' + CommitmentTermYear);

          end;  {If ((CommitmentCode = 'F') ...}

        {Now do the farm building law.}

      FarmBuildingExemptionFound := False;

      For I := 0 to (EXTaxList.Count - 1) do
        If (ExemptTaxPtr(EXTaxList[I])^.EXCode = '41700')
          then
            begin
              FarmBuildingExemptionFound := True;

                {If there is no commitment term year filled in,
                 do 8 years beyond the init of the ag exemption -
                 as per Rose Ripple in Ramapo. - Don't forget to include
                 the starting year.}

              If (Deblank(CommitmentTermYear) = '')
                then
                  begin
                    TempYear := ExemptTaxPtr(EXTaxList[I])^.InitialYear;

                    try
                      TempYearInt := StrToInt(TempYear);
                      TempYearInt := TempYearInt + 7;  {7 includes that year}
                      CommitmentTermYear := IntToStr(TempYearInt);
                    except
                      CommitmentTermYear := '';
                    end;

                  end;  {If (Deblank(CommitmentTermYear) = '')}

            end;  {If ((ExemptTaxRecord(EXTaxList[I])^.EXCode = '41720') or ...}

      If ((CommitmentCode = 'B') or
          FarmBuildingExemptionFound)
        then
          begin
            CL1List.Add('');
            CL1List.Add('MAY BE SUBJECT TO PAYMENT');
            CL1List.Add('UNDER RPTL483 LAW TIL ' + CommitmentTermYear);

          end;  {If ((CommitmentCode = 'F') ...}

        {CHG06122003-1(2.07c): Add the ability to print additional lots on the roll.}

      If (PrintAdditionalLots and
          (Deblank(FieldByName('AdditionalLots').Text) <> ''))
        then CL1List.Add('ADD LOT: ' + FieldByName('AdditionalLots').Text);

        {CHG01282004-4(2.07l1): Allow them to print the physical increase as
                                a building permit.}

      If (PrintPermits and
          (FieldByName('BuildingPermitAmount').AsInteger > 0))
        then CL2List.Add('BUILDING PERMIT: ' +
                         FormatFloat(CurrencyDisplayNoDollarSign,
                                            FieldByName('BuildingPermitAmount').AsFloat));

    end;  {with HeaderTaxTable do}

    {FXX05301998-1: Make sure that everything fits in the first column.}

  For I := 0 to (CL1List.Count - 1) do
    CL1List[I] := Take((Trunc(CL1W * 10) - 1), CL1List[I]);

end;  {FillInPropertyInformation}

{===================================================================}
Function FoundGeneralTax(    GeneralTaxList : TList;
                             PrintOrder : Integer;
                         var Index : Integer) : Boolean;

{Search through the general tax list for this print order.}

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (GeneralTaxList.Count - 1) do
    If (GeneralTaxPtr(GeneralTaxList[I])^.PrintOrder = PrintOrder)
      then
        begin
          Result := True;
          Index := I;
        end;

end;  {FoundGeneralTax}

{===================================================================}
Procedure CombineGeneralTaxes(GeneralTaxList,
                              CombinedGeneralTaxList : TList);

var
  GenTaxPtr : GeneralTaxPtr;
  I, Index : Integer;

begin
  For I := 0 to (GeneralTaxList.Count - 1) do
    If FoundGeneralTax(CombinedGeneralTaxList,
                       GeneralTaxPtr(GeneralTaxList[I])^.PrintOrder, Index)
      then
        begin
          with GeneralTaxPtr(CombinedGeneralTaxList[Index])^ do
            begin
              TaxableVal := TaxableVal + GeneralTaxPtr(GeneralTaxList[I])^.TaxableVal;
              TaxAmount := TaxAmount + GeneralTaxPtr(GeneralTaxList[I])^.TaxAmount;
            end;

        end
      else
        begin
          New(GenTaxPtr);   {get new pptr for tlist array}

          with GenTaxPtr^ do
            begin
              Description := GeneralTaxPtr(GeneralTaxList[I])^.Description;
              TaxableVal := GeneralTaxPtr(GeneralTaxList[I])^.TaxableVal;
              TaxAmount := GeneralTaxPtr(GeneralTaxList[I])^.TaxAmount;
              HomesteadCode := GeneralTaxPtr(GeneralTaxList[I])^.HomesteadCode;
              PrintOrder := GeneralTaxPtr(GeneralTaxList[I])^.PrintOrder;

            end;  {with GenTaxPtr^ do}

          CombinedGeneralTaxList.Add(GenTaxPtr);

        end;  {else of If FoundGeneralTax(CombinedGeneralTaxList, ...}

end;  {CombineGeneralTaxes}

{=================================================================}
Procedure FillInClassInformation(CL1List,
                                 CL2List,
                                 CL3List,
                                 CL4List,
                                 CL5List,
                                 CL6List,
                                 CL7List,
                                 LineTypeList : TStringList; {What type of line is each tax line?}
                                 BLHeaderTaxTable : TTable;
                                 CollectionType : String;
                                 RollType : Char;
                                 SuppressSDExtensions : Boolean;
                                 ExTaxList,
                                 GNTaxList,
                                 SDExtCategoryList,
                                 SDTaxList,
                                 SPTaxList : TList);

{The setup for split parcels is different and can not be worked into the
 normal layout.}
{CHG12142004-1(2.8.1.3): Add homestead to special districts.}

var
  TotalAssessedVal : Comp;
  CombinedGeneralTaxList : TList;

begin
  TotalAssessedVal := 0;
  CombinedGeneralTaxList := TList.Create;

    {First print the 'Homestead Portion' header and the account and bill
     number.}

  with BLHeaderTaxTable do
    begin
       CL3List.Add(' ');
       CL4List.Add('* HOMESTEAD PORTION *');

       If (Deblank(FieldByName('AccountNumber').Text) = '')
         then CL5List.Add('')
         else CL5List.Add('ACCT: ' + FieldByName('AccountNumber').Text);

       CL6List.Add(' ');

       If (RollType = 'X')
         then CL7List.Add('BILL ' + ShiftRightAddBlanks(Take(6, DezeroOnLeft(FieldByName('BillNo').Text))))
         else CL7List.Add('');

       LineTypeList.Add('M');

       CL3List.Add('AC ' +
                   FormatFloat(DecimalDisplay,
                               FieldByName('HstdAcreage').AsFloat));
         {Add the assessed values.}

       CL3List.Add(FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('HstdLandVal').AsFloat));
       CL3List.Add('');
       CL3List.Add(FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('HstdTotalVal').AsFloat));

     end;  {with BLHeaderTaxTable do}

     {Now do the homestead exemptions.}

  FillInExemptions(CL4List, CL5List, CL6List, CL7List, LineTypeList,
                   'H', CollectionType, ExTaxList);

     {Now do general totals for homestead.}

  FillInGeneralTaxes(CL2List, CL4List, CL5List, CL6List, CL7List, LineTypeList,
                     RollType, 'H', GNTaxList);

  FillInSDTaxes(CL4List, CL5List, CL6List, CL7List, LineTypeList, 'X',
                TotalAssessedVal, SuppressSDExtensions, SDExtCategoryList, SDTaxList, 'H');

    {Even up the lines so far.}

  GetAndSetMaxLines(CL1List, CL2List, CL3List, CL4List, CL5List,
                    CL6List, CL7List, LineTypeList);

     {Break line.}

  CL3List.Add('- - - - - - -');
  CL4List.Add('- - - - - - - - - - - - - -');
  CL5List.Add('- - - - - - -');
  CL6List.Add('- - - - - - -');
  CL7List.Add('- - ');
  LineTypeList.Add('M');

    {Non-homestead portion.}

  CL3List.Add('');
  CL4List.Add('* NON-HOMESTEAD PORTION *');
  CL5List.Add('');
  CL6List.Add('');
  CL7List.Add('');
  LineTypeList.Add('M');

  with BLHeaderTaxTable do
    begin
      CL3List.Add('AC ' +
                  FormatFloat(DecimalDisplay,
                              FieldByName('NonhstdAcreage').AsFloat));

         {Add the assessed values.}

       CL3List.Add(FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('NonHstdLandVal').AsFloat));
       CL3List.Add('');
       CL3List.Add(FormatFloat(CurrencyDisplayNoDollarSign,
                               FieldByName('NonHstdTotalVal').AsFloat));

      end;  {with BLHeaderTaxTable do}

     {Now do the non-homestead exemptions.}

  FillInExemptions(CL4List, CL5List, CL6List, CL7List, LineTypeList,
                   'N', CollectionType, ExTaxList);

     {Now do general totals for non-homestead.}

  FillInGeneralTaxes(CL2List, CL4List, CL5List, CL6List, CL7List, LineTypeList,
                     RollType, 'N', GNTaxList);

  FillInSDTaxes(CL4List, CL5List, CL6List, CL7List, LineTypeList, 'X',
                TotalAssessedVal, SuppressSDExtensions, SDExtCategoryList, SDTaxList, 'N');

    {Even up the lines so far.}

  GetAndSetMaxLines(CL1List, CL2List, CL3List, CL4List, CL5List,
                    CL6List, CL7List, LineTypeList);

     {Break line.}

  CL3List.Add('- - - - - - -');
  CL4List.Add('- - - - - - - - - - - - - -');
  CL5List.Add('- - - - - - -');
  CL6List.Add('- - - - - - -');
  CL7List.Add('- - ');
  LineTypeList.Add('M');

    {Non-homestead portion.}

  CL3List.Add('');
  CL4List.Add('* PARCEL TOTALS *');
  CL5List.Add('');
  CL6List.Add('');
  CL7List.Add('');
  LineTypeList.Add('M');

     {Now do overall general totals.  To do this, combine the
      homestead and non-homestead amounts in the general tax list.}

  CombineGeneralTaxes(GNTaxList, CombinedGeneralTaxList);

    {Add the assessed values.}

  with BLHeaderTaxTable do
    begin
      TotalAssessedVal := FieldByName('HstdTotalVal').AsFloat +
                          FieldByName('NonhstdTotalVal').AsFloat;

      CL3List.Add(FormatFloat(CurrencyDisplayNoDollarSign,
                              (FieldByName('HstdLandVal').AsFloat +
                               FieldByName('NonhstdLandVal').AsFloat)));
      CL3List.Add('');
      CL3List.Add(FormatFloat(CurrencyDisplayNoDollarSign,
                              TotalAssessedVal));

    end;  {with BLHeaderTaxTable do}

  FillInGeneralTaxes(CL2List, CL4List, CL5List, CL6List, CL7List, LineTypeList,
                     RollType, ' ', CombinedGeneralTaxList);

  FillInSDTaxes(CL4List, CL5List, CL6List, CL7List, LineTypeList, 'X',
                TotalAssessedVal, SuppressSDExtensions, SDExtCategoryList, SDTaxList, '');

  FillInSPFeeTaxes(CL4List, CL5List, CL6List, CL7List, LineTypeList, SPTaxList);

  FreeTList(CombinedGeneralTaxList, SizeOf(GeneralTaxRecord));

end;  {FillInClassInformation}

{====================================================================================================}
Function GetUniformPercentOfValue(SwisCode : String;
                                  SwisCodeDescList : TList) : Real;

{Given a swis code description list and a swis code, return the uniform % of value.}
{FXX06251998-7: Need to store the uniform % of value for each swis code and print it out.}

var
  I : Integer;

begin
  Result := 0;

  For I := 0 to (SwisCodeDescList.Count - 1) do
    If (Take(6, SwisCode) = Take(6, PCodeRecord(SwisCodeDescList[I])^.Code))
      then Result := PCodeRecord(SwisCodeDescList[I])^.UniformPercentOfValue;

end;  {GetUniformPercentOfValue}

{==================================================================}
Procedure StartNewPage(    Sender : TObject;  {Report printer or filer object}
                           RollType : Char; {'X' = Tax roll, 'T' = tenative assessment}
                           SchoolCode,
                           SwisCode : String;
                           RollSection : String;
                           CollectionType : String;  {(SC)hool, (MU)nicipal, (VI)llage}
                           RollPrintingYear : String;
                           AssessmentYearCtlTable : TTable;
                           SchoolCodeDescList,
                           SwisCodeDescList : TList;
                           SequenceStr : String;  {Text for what order roll is printing in.}
                       var PageNo,
                           LineNo : Integer);

{Start a new page by formfeeding, reseting the counters and printing the
 header.}

begin
  with Sender as TBaseReport do
    begin
      NewPage;

      LineNo := 1;
      PageNo := PageNo + 1;
      PrintRollHeader(Sender, RollType, SchoolCode, SwisCode,
                      RollSection, CollectionType,
                      RollPrintingYear,
                      AssessmentYearCtlTable,
                      SchoolCodeDescList,
                      SwisCodeDescList, SequenceStr,
                      PageNo, LineNo);

  end;  {with Sender as TBaseReport do}

end;  {StartNewPage}

{==================================================================}
Function GetRollHeaderTitle(RollType : Char; {'X' = Tax roll, 'T' = tenative assessment}
                            CollectionType : String;  {(SC)hool, (MU)nicipal, (VI)llage}
                            RollPrintingYear : String) : String;

{CHG02122000-1: Allow them to edit the title on the roll.}

var
  RollTypeStr : String;

begin
  case RollType of
    'F' : RollTypeStr := 'F I N A L';
    'T' : RollTypeStr := 'T E N A T I V E';
    'X' : RollTypeStr := 'T A X';

  end;  {case RollType of}

   {FXX01201998-6: Let them choose the year that will appear on the roll.}

  If (CollectionType = 'SC')
    then Result := RollPrintingYear + '   S C H O O L   ' + RollTypeStr + '   R O L L';

  If (CollectionType = 'MU')
    then
      begin
        If (GlblMunicipalityType = MTTown)
          then Result := RollPrintingYear + '   T O W N   ' + RollTypeStr + '   R O L L';

        If (GlblMunicipalityType = MTCity)
          then Result := RollPrintingYear + '   C I T Y   ' + RollTypeStr + '   R O L L';

        If (GlblMunicipalityType = MTVillage)
          then Result := RollPrintingYear + '   V I L L A G E   ' + RollTypeStr + '   R O L L';

      end;  {If (CollectionType = 'MU')}

  If (CollectionType = 'VI')
    then Result := RollPrintingYear + '   V I L L A G E   ' + RollTypeStr + '   R O L L';

  If (CollectionType = 'CO')
    then Result := RollPrintingYear + '   C O U N T Y   ' + RollTypeStr + '   R O L L';

end;  {GetRollHeaderTitle}

{==================================================================}
Procedure PrintRollHeader(    Sender : TObject;  {Report printer or filer object}
                              RollType : Char; {'X' = Tax roll, 'T' = tenative assessment}
                              SchoolCode,
                              SwisCode : String;
                              RollSection : String;
                              CollectionType : String;  {(SC)hool, (MU)nicipal, (VI)llage}
                              RollPrintingYear : String;
                              AssessmentYearCtlTable : TTable;
                              SchoolCodeDescList,
                              SwisCodeDescList : TList;
                              SequenceStr : String;  {Text for what order roll is printing in.}
                              PageNo : Integer;
                          var LineNo : Integer);

{Print the header for this type of roll.}

var
  UniformPercentOfValue : Real;
  Column1, Column2, Column3, Column4 : Double;

begin
  GlblCurrentTabNo := 1;
  GlblCurrentLinePos := 1;
  Column1 := GlblReportReprintLeftMargin;
  Column2 := Column1 + 4.5;
  Column3 := Column1 + 10.0;
  Column4 := Column1 + 12.4;

  with Sender as TBaseReport do
    begin
      ClearTabs;
        {1st header line}
      SetTab(Column1, pjLeft, 2.0, 0, BOXLINENONE, 0);   {cOUNTY}
      SetTab(Column2, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
      SetTab(Column3, pjLeft, 2.0, 0, BOXLINENONE, 0);   {VALUATION Date prose}
      SetTab(Column4, pjRight, 0.9, 0, BOXLINENONE, 0);   {VALUATION Date}
      Println('');

        {CHG02122000-1: Allow them to edit the title on the roll.}

      Println(#9 + 'STATE OF NEW YORK' +
                  #9 + RollHeaderTitle +
                  #9 + 'PAGE: ' +
                  #9 + IntToStr(PageNo));

      Print(#9 + 'COUNTY: ' + GlblCountyName);

        {FXX12231997-2: Missing headers for rs 3 and 7.}

        {FXX04231998-9: Instead of print the roll section hdr for
                        the totals sections, print the section type.}

      try
        case RollSection[1] of
          '1': Print(#9 + 'T A X A B L E SECTION OF THE ROLL  - 1');
          '3': Print(#9 + 'TAXABLE STATE LANDS SECTION OF THE ROLL  - 3');
          '5': Print(#9 + 'SPECIAL FRANCHISE SECTION OF THE ROLL  - 5');
          '6': Print(#9 + 'UTILITY & R. R.  SECTION OF THE ROLL  - 6');
          '7': Print(#9 + 'CEILING RAILROAD SECTION OF THE ROLL  - 7');
          '8': Print(#9 + 'WHOLLY EXEMPT SECTION OF THE ROLL  - 8');
          '9': Print(#9 + 'PRO-RATA SECTION OF THE ROLL  - 9');
          'R' : Print(#9 + 'R O L L    S E C T I O N    T O T A L S');
          'S' : Print(#9 + 'S W I S    T O T A L S');
          'C' : Print(#9 + 'S C H O O L    T O T A L S');
          'G' : Print(#9 + 'M U N I C I P A L I T Y    T O T A L S');
          else Print(#9);
        end;  {case StrToInt(RollSection) of}
      except
        Print(#9 + 'U N K N O W N');
      end;

        {FXX01051998-2: Print the date of roll printing.}
        {FXX06181999-12: Allow the user to select the date of the roll printing.}

      Println(#9 + 'ROLL PRINT DATE: ' + #9 + DateToStr(RollPrintingDate));

       {2ND HDR LINE}
        {Print the selection information.}

           {QQQQ DECIDE HOW TO DO SCHOOL LABEL IF SCHOOL COLLECTION}

        {FXX12291997-1: Change 'MUNICIPALITY' to 'CITY' or 'TOWN'.}
        {FXX05251998-5: Always print municipality name even for schools.}

      Print(#9 + UpcaseStr(GetMunicipalityName));

      Println(#9 + SequenceStr + #9 + 'VALUATION DATE:' +
                          #9 + AssessmentYearCtlTable.FieldByName('ValuationDate').Text);


       {3RD HDR LINE}
        {Print the selection information.}

           {QQQQ DECIDE HOW TO DO SCHOOL LABEL IF SCHOOL COLLECTION}

        {FXX01051998-3: Trim the swis or school desc.}
        {FXX04291998-3: If the swis is 4 chars, don't try to print desc,
                        it is whole munic.}

      If (CollectionType = 'SC')
        then Print(#9 + 'SCHOOL: ' + Trim(SchoolCode) + ' (' +
                   Trim(GetDescriptionFromList(SchoolCode, SchoolCodeDescList)) + ')')
        else
          If (Length(Trim(SwisCode)) = 6)
            then Print(#9 + 'SWIS: ' + SwisCode + '  ('+
                   Trim(GetDescriptionFromList(SwisCode, SwisCodeDescList)) + ')')
            else Print(#9 + 'SWIS: ' + SwisCode);

         {FXX06251998-7: Need to store the uniform % of value for each swis code and print it out.}

      UniformPercentOfValue := GetUniformPercentOfValue(SwisCode, SwisCodeDescList);

        {FXX06031999-1: Option to print uniform % of value.}

      If ((Roundoff(UniformPercentOfValue, 2) = 0) or
          (not PrintUniformPercentOfValue))
        then Print(#9)
        else Print(#9 + 'UNIFORM PERCENT OF VALUE = ' +
                   FormatFloat(DecimalDisplay, UniformPercentOfValue));

      Println(#9 + 'TAXABLE STATUS DATE: ' +
              #9 + AssessmentYearCtlTable.FieldByName('TaxableStatusDate').Text);

        {FXX05301998-3: Also print out the swis for school rolls (i.e.
                        swis within school.}

      If (CollectionType = 'SC')
        then
          begin
            If (Length(Trim(SwisCode)) = 6)
              then Print(#9 + 'SWIS: ' + SwisCode + '  ('+
                     Trim(GetDescriptionFromList(SwisCode, SwisCodeDescList)) + ')')
              else Print(#9 + 'SWIS: ' + SwisCode);
            Println('');
            Println('');
          end
        else
          begin
            Println('');
            Println('');
          end;

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 7;

end;  {PrintRollHeader}

{=========================================================================}
Procedure PrintParcelPageSubheader(    Sender : TObject;  {Report printer or filer object}
                                       RollType : Char; {'X' = Tax roll, 'T' = tenative assessment}
                                       CollectionType : String;
                                   var LineNo : Integer);

{Print the column headers for this parcel page.}

var
  ExemptionString, TempStr : String;


begin
  with Sender as TBaseReport do
    begin
        {1st PARCEL HDR LINE}

      If (GlblMunicipalityType = MTCity)
        then TempStr := 'CITY'
        else
          If (GlblMunicipalityType = MTVillage)
            then TempStr := 'VILL'
            else TempStr := 'TOWN';

      ClearTabs;
      SetTab(CL1, pjLeft, CL1W, 0, BOXLINENONE, 0);   {SBL,CKDIG}
      SetTab(CL2, pjLeft, CL2W, 0, BOXLINENONE, 0);   {PROP LOC & CLS}
      SetTab(CL3, pjRight, CL3W, 0, BOXLINENONE, 0);   {ASSESSMENT}
      SetTab(CL4, pjLeft, 6.3, 0, BOXLINENONE, 0);   {EXEM, CTY TOWN}

        {FXX12231997-6: Don't print SCHOOL in ex header if munic or village
                        billing and vice versa.}
        {FXX05271998-1: Only show school for school roll.}

      If (CollectionType = 'SC')
        then ExemptionString := 'EXEMPTION CODE-----------SCHOOL-----'
        else
          begin
              {CHG10302000-1: Need to allow user to specify exactly which municipalities
                              print on the roll.}

            If (mtpCounty in MunicipalitiesToPrint)
              then ExemptionString := 'EXEMPTION CODE-----------COUNTY-----' + TempStr
              else ExemptionString := 'EXEMPTION CODE----------------------' + TempStr;

            If (((RollType in ['F', 'T']) or
                 CollectionHasSchoolTax) and
                (mtpSchool in MunicipalitiesToPrint))
              then ExemptionString := ExemptionString + '-----SCHOOL';

          end;

      Println(#9 + 'TAX MAP PARCEL ID     CD' +
              #9 + 'PROPERTY LOCATION & CLASS' +
              #9 + 'ASSESSMENT' +
              #9 + ExemptionString);

     {2ND PARCEL HDR LINE}
      ClearTabs;
      SetTab(CL1, pjLeft, CL1W, 0, BOXLINENONE, 0);   {OWNER NAME}
      SetTab(CL2, pjLeft, CL2W, 0, BOXLINENONE, 0);   {SCHL DIST}
      SetTab(CL3, pjRight, CL3W, 0, BOXLINENONE, 0);   {LAND AV}
      SetTab(CL4, pjLeft, CL4W, 0, BOXLINENONE, 0);   {TAX DESCR}
      SetTab(CL5, pjRight, CL5W, 0, BOXLINENONE, 0);   {TAXABLE VAL}
      Println(#9 + 'CURRENT OWNERS NAME' +
                          #9 + 'SCHOOL DISTRICT' +
                          #9 + '---LAND---' +
                          #9 + 'TAX DESCRIPTION' +
                          #9 + 'TAXABLE VALUE');

      {3RD PARCEL HDR LINE}
      ClearTabs;
      SetTab(CL1, pjLeft, CL1W, 0, BOXLINENONE, 0);   {OWNER ADDR}
      SetTab(CL2, pjLeft, CL2W, 0, BOXLINENONE, 0);   {PARCEL SIZE/GRID}
      SetTab(CL3, pjRight, CL3W, 0, BOXLINENONE, 0);   {TOTAL AV}
      SetTab(CL4, pjLeft, CL4W, 0, BOXLINENONE, 0);   {SPCL DIST dESCR}
      SetTab(CL5, pjLeft, CL5W, 0, BOXLINENONE, 0);   {TAXABLE VAL}
      SetTab(CL6, pjLeft, CL6W, 0, BOXLINENONE, 0);   {SD FLGS}
      SetTab(CL7, pjRight, CL7W, 0, BOXLINENONE, 0);   {TAX AMT}


      Print(#9 + 'CURRENT OWNERS ADDRESS' +
              #9 + 'PARCEL SIZE/GRID COORD' +
              #9 + '--TOTAL---' +
              #9 + 'SPECIAL DISTRICTS');

      If (RollType = 'X')
        then Println(#9 +  {SD TXABL VAL}
                                 #9 +  {SD FLAGS}
                                 #9 + 'TAX AMT')
        else Println('');

      ClearTabs;

      LineNo := LineNo + 3;

     end;  {with Sender as TBaseReport do}

end;  {PrintParcelPageSubHeader}

{=========================================================================}
Procedure PrintOneParcel(    Sender : TObject;  {Report printer or filer object}
                             RollType : Char; {'X' = Tax roll, 'T' = tenative 'F' = Final}
                             BLHeaderTaxTable,
                             CollectionLookupTable : TTable;
                             MaxLines : Integer;
                             CL1List,
                             CL2List,
                             CL3List,
                             CL4List,
                             CL5List,
                             CL6List,
                             CL7List,
                             LineTypeList : TStringList;
                             NumExemptions : Integer;  {We have to use different tabs for exemptions, so how many?}
                         var LineNo : Integer);

{Given the information for a parcel in 7 column lists, print it along
 with the amounts due and due dates.}

var
  I, NumPaymentsThisParcel : Integer;
  TempStr, TempSBLKey : String;
  TempField : TField;

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(CL1, pjLeft, 13, 0, BOXLINENONE, 0);   {OWNER ADDR}

      TempSBLKey := ConvertSBLOnlyToDashDot(BLHeaderTaxTable.FieldByName('SBLKey').Text);

      Print(#9 + ConstStr('*', 94) + ' ' + Trim(TempSBLKey) + ' ' +
            ConstStr('*', (35 - Length(Trim(TempSBLKey)))));
      Println('');

      LineNo := LineNo + 1;

        {FXX01071998-4: Each tax line has a line type so that we can
                        set the tabs up correctly since exemptions are
                        different.}

      For I := 0 to (CL1List.Count - 1) do
        begin
          If (LineTypeList[I] = 'E')
            then
              begin
                ClearTabs;
                SetTab(CL1, pjLeft, CL1W, 0, BOXLINENONE, 0);   {OWNER ADDR}
                SetTab(CL2, pjLeft, CL2W, 0, BOXLINENONE, 0);   {PARCEL SIZE/GRID}
                SetTab(CL3, pjRight, CL3W, 0, BOXLINENONE, 0);   {TOTAL AV}
                SetTab(CL4, pjLeft, EX4W, 0, BOXLINENONE, 0);   {EX desc}
                SetTab(EX5, pjRight, EX5W, 0, BOXLINENONE, 0);   {EX county}
                SetTab(EX6, pjRight, EX6W, 0, BOXLINENONE, 0);   {EX town}
                SetTab(EX7, pjRight, EX7W, 0, BOXLINENONE, 0);   {EX school}

              end
            else
              begin
                  {Set up the tabs for the first line of printing.}

                ClearTabs;
                SetTab(CL1, pjLeft, CL1W, 0, BOXLINENONE, 0);   {OWNER ADDR}
                SetTab(CL2, pjLeft, CL2W, 0, BOXLINENONE, 0);   {PARCEL SIZE/GRID}
                SetTab(CL3, pjRight, CL3W, 0, BOXLINENONE, 0);   {TOTAL AV}
                SetTab(CL4, pjLeft, CL4W, 0, BOXLINENONE, 0);   {SPCL DIST dESCR}
                SetTab(CL5, pjRight, CL5W, 0, BOXLINENONE, 0);   {TAXABLE VAL}
                SetTab(CL6, pjLeft, CL6W, 0, BOXLINENONE, 0);   {SD FLGS}
                SetTab(CL7, pjRight, CL7W, 0, BOXLINENONE, 0);   {TAX AMT}

              end;

          Println(#9 + CL1List[I] +
                  #9 + CL2List[I] +
                  #9 + CL3List[I] +
                  #9 + CL4List[I] +
                  #9 + CL5List[I] +
                  #9 + CL6List[I] +
                  #9 + CL7List[I]);

          LineNo := LineNo + 1;

        end;  {For I := 0 to (CL1List.Count - 1) do}

        {NOW PRINT 3 SUMMARY LINES FOR THIS BILL, only for tax roll.}

      If (RollType = 'X')
        then
          begin
            ClearTabs;
            SetTab(TT1, pjLeft, TT1W, 0, BOXLINENONE, 0);   {TOTAL TAX PROSE}
            SetTab(TT2, pjRight, TT2W, 0, BOXLINENONE, 0);   {TOTAL TAX}

            Println(#9 + 'TOTAL TAX ---' + #9 +
                                FormatFloat(DecimalDisplay,
                                            BLHeaderTaxTable.FieldByName('TotalTaxOwed').AsFloat) +
                                '**');

            LineNo := LineNo + 1;

              {Go through the tax payments to see how many installments they have
               to pay. Note that this is not necessarily the number of payments
               for the municipality. This is because if the municipality has
               a max or minimum option, the payment may be all in one even though
               the municipality is 2 pay.}

            NumPaymentsThisParcel := 0;

            For I := 1 to 8 do
              begin
                TempStr := 'TaxPayment' + IntToStr(I);
                TempField := BLHeaderTaxTable.FieldByName(TempStr);

                If (Roundoff(TempField.AsFloat, 2) > 0)
                  then NumPaymentsThisParcel := NumPaymentsThisParcel + 1;

              end;  {For I := 1 to 8 do}

            ClearTabs;
            SetTab(PDP1, pjLeft, PDP1W, 0, BOXLINENONE, 0);   {amt due prose}
            SetTab(PDA1, pjRight, PDA1W, 0, BOXLINENONE, 0);   {amt due}
            SetTab(PDP2, pjLeft, PDP2W, 0, BOXLINENONE, 0);   {amt due prose}
            SetTab(PDA2, pjRight, PDA2W, 0, BOXLINENONE, 0);   {amt due}
            SetTab(PDP3, pjLeft, PDP3W, 0, BOXLINENONE, 0);   {amt due prose}
            SetTab(PDA3, pjRight, PDA3W, 0, BOXLINENONE, 0);   {amt due}

            If (NumPaymentsThisParcel = 1)
              then
                begin
                  Println(#9 + #9 + #9 + #9 + #9 + 'DATE #1:' + #9 +
                          CollectionLookupTable.FieldByname('PayDate1').Text);
                  Println(#9 + #9 + #9 + #9 + #9 + 'AMT DUE:' + #9 +
                          FormatFloat(DecimalDisplay,
                                      BLHeaderTaxTable.FieldByName('TaxPayment1').AsFloat));

                end;  {If (NumPayments = 1)}

            If (NumPaymentsThisParcel = 2)
              then
                begin
                  Println(#9 + #9 + #9 + 'DATE #1:' + #9 +
                                      CollectionLookupTable.FieldByName('PayDate1').Text +
                                      #9 + 'DATE #2:' + #9 +
                                      CollectionLookupTable.FieldByName('PayDate2').Text);

                  Println(#9 + #9 + #9 + 'AMT DUE:' + #9 +
                                      FormatFloat(DecimalDisplay,
                                                  BLHeaderTaxTable.FieldByName('TaxPayment1').AsFloat) +#9 +
                                      'AMT DUE:' + #9 +
                                      FormatFloat(DecimalDisplay,
                                                  BLHeaderTaxTable.FieldByName('TaxPayment2').AsFloat));

                end;  {If (NumPayments = 2)}

            If (NumPaymentsThisParcel = 3)
              then
                begin
                  Println(#9 + 'DATE #1:' + #9 +
                          CollectionLookupTable.FieldByName('PayDate1').Text +
                          #9 + 'DATE #2:' + #9 +
                          CollectionLookupTable.FieldByName('PayDate2').Text +
                          #9 + 'DATE #3:' + #9 +
                          CollectionLookupTable.FieldByName('PayDate3').Text);

                  Println(#9 + 'AMT DUE:' + #9 +
                          FormatFloat(DecimalDisplay,
                                      BLHeaderTaxTable.FieldByName('TaxPayment1').AsFloat) +#9 +
                          'AMT DUE:' + #9 +
                          FormatFloat(DecimalDisplay,
                                      BLHeaderTaxTable.FieldByName('TaxPayment2').AsFloat) +#9+
                          'AMT DUE:' + #9 +
                          FormatFloat(DecimalDisplay,
                                      BLHeaderTaxTable.FieldByName('TaxPayment3').AsFloat));

                end;  {If (NumPayments = 3)}

            LineNo := LineNo + 2;

          end;  {If (RollType = 'X')}

    end;  {with Sender as TBaseReport do}

end;  {PrintOneParcel}

{=======================================================================}
Procedure PrintEndingParcelLine(Sender : TObject);

{Print a line of asteriks after the last parcel on a page.}

var
  I : Integer;

begin
  I := Trunc(GlblReportReprintLeftMargin * 10);

  with Sender as TBaseReport do
    begin
      For I := 1 to I do
        Print(' ');

      Println(ConstStr('*', 132));

    end;  {with Sender as TBaseReport do}

end;  {PrintEndingParcelLine}

{==================================================================================}
Function VerifyDatesAndPercentOfValueFilledIn(    AssessmentYearCtlFile,
                                                  SwisCodeTable : TTable;
                                              var UniformPercentOfValue,
                                                  EqualizationRate : Real) : Boolean;

{FXX12171998-7: Make sure that the dates in the assessment year control
                file are filled in and the uniform % of value.}

var
  MessageList : TStringList;
  FirstTimeThrough, Done : Boolean;
  TempStr : String;
  TempStrings : Array[1..3] of String;
  I : Integer;

begin
  Result := True;
  MessageList := TStringList.Create;

  with AssessmentYearCtlFile do
    begin
        {Reaccess the record in case they filled it in after seeing the
         message once.}

      First;

      If (Deblank(FieldByName('TaxableStatusDate').Text) = '')
        then
          begin
            MessageList.Add('Taxable status date in the assessment year control table.');
            Result := False;
          end;

      If (Deblank(FieldByName('ValuationDate').Text) = '')
        then
          begin
            MessageList.Add('Valuation date in the assessment year control table.');
            Result := False;
          end;

    end;  {with AssessmentYearCtlFile do}

  Done := False;
  FirstTimeThrough := True;
  TempStr := '';

  SwisCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwisCodeTable.Next;

    If SwisCodeTable.EOF
      then Done := True;

    If ((not Done) and
        (Roundoff(SwisCodeTable.FieldByName('UniformPercentValue').AsFloat, 3) = 0))
      then
        begin
          If (Deblank(TempStr) = '')
            then TempStr := 'Uniform % of values in swis code(s): '
            else TempStr := TempStr + ', ';

          TempStr := TempStr + SwisCodeTable.FieldByName('SWISShortCode').Text;

        end
      else
        begin
          UniformPercentOfValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
          EqualizationRate := SwisCodeTable.FieldByName('EqualizationRate').AsFloat;
        end;

  until Done;

  If (Deblank(TempStr) <> '')
    then
      begin
        TempStr := TempStr + '.';
        MessageList.Add(TempStr);
        Result := False;
      end;

  If (MessageList.Count > 0)
    then
      begin
        For I := 1 to 3 do
          TempStrings[I] := '';

        For I := 0 to (MessageList.Count - 1) do
          TempStrings[I + 1] := MessageList[I];

        MessageDlg('The following information must be filled in:' + #13 +
                   '     ' + TempStrings[1] + #13 +
                   '     ' + TempStrings[2] + #13 +
                   '     ' + TempStrings[3],
                   mtError, [mbOK], 0);

      end;  {If (MessageList.Count > 0)}

  MessageList.Free;

end;  {If OKToStartPrinting}

{======================================================================}
Procedure GetStateAidAmounts(    GeneralRateList : TList;
                                 SwisCode : String;
                             var CountyStateAid,
                                 TownStateAid,
                                 SchoolStateAid,
                                 VillageStateAid : Comp);

var
  RateIndex : Integer;

begin
  CountyStateAid := 0;
  TownStateAid := 0;
  SchoolStateAid := 0;
  VillageStateAid := 0;

  RateIndex := FindGeneralRate(-1, 'CO', SwisCode, GeneralRateList);

  If (RateIndex > -1)
    then CountyStateAid := GeneralRatePointer(GeneralRateList[RateIndex])^.EstimatedStateAid;

  RateIndex := FindGeneralRate(-1, 'TO', SwisCode, GeneralRateList);

  If (RateIndex > -1)
    then TownStateAid := GeneralRatePointer(GeneralRateList[RateIndex])^.EstimatedStateAid;

    {Check for a city rate.}

  If (TownStateAid = 0)
    then
      begin
        RateIndex := FindGeneralRate(-1, 'CI', SwisCode, GeneralRateList);

        If (RateIndex > -1)
          then TownStateAid := GeneralRatePointer(GeneralRateList[RateIndex])^.EstimatedStateAid;

      end;  {If (TownStateAid = 0)}

  RateIndex := FindGeneralRate(-1, 'SC', SwisCode, GeneralRateList);

  If (RateIndex > -1)
    then SchoolStateAid := GeneralRatePointer(GeneralRateList[RateIndex])^.EstimatedStateAid;

  RateIndex := FindGeneralRate(-1, 'VI', SwisCode, GeneralRateList);

  If (RateIndex > -1)
    then VillageStateAid := GeneralRatePointer(GeneralRateList[RateIndex])^.EstimatedStateAid;

end;  {GetStateAidAmounts}

{======================================================================}
Function ConfirmRollSetup(AssessmentYearCtlTable,
                          EXCodeTable,
                          SwisCodeTable : TTable;
                          RollTypeStr,
                          ActionTypeStr,
                          PrintedDate : String) : Boolean;

{CHG11062001-1: Confirm the billing \ roll values.}

var
  TempStr : String;
  Found, Done, FirstTimeThrough : Boolean;
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  UniformPercentOfValue, EqualizationRate : Real;

begin
  UniformPercentOfValue := 0;
  EqualizationRate := 0;

  If (Deblank(PrintedDate) = '')
    then TempStr := ''
    else TempStr := '      Roll Date = ' + PrintedDate;

    {Get the basic and enhanced STAR amounts.}

  Found := FindKeyOld(EXCodeTable, ['EXCode'],
                      [BasicSTARExemptionCode]);

  If Found
    then BasicSTARAmount := EXCodeTable.FieldByName('FixedAmount').AsFloat
    else BasicSTARAmount := 0;

  Found := FindKeyOld(EXCodeTable, ['EXCode'],
                      [EnhancedSTARExemptionCode]);

  If Found
    then EnhancedSTARAmount := EXCodeTable.FieldByName('FixedAmount').AsFloat
    else EnhancedSTARAmount := 0;

    {Get the uniform % of value and equalization rate.}

  Done := False;
  FirstTimeThrough := True;

  SwisCodeTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwisCodeTable.Next;

    If SwisCodeTable.EOF
      then Done := True;

    If ((not Done) and
        (Roundoff(SwisCodeTable.FieldByName('UniformPercentValue').AsFloat, 3) <> 0))
      then
        begin
          UniformPercentOfValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
          EqualizationRate := SwisCodeTable.FieldByName('EqualizationRate').AsFloat;
        end;

  until Done;

  Result := (MessageDlg('Are you sure you want to ' + ActionTypeStr + ' the ' + RollTypeStr + ' roll?' + #13 + #13 +
                        'Info: Taxable Status Date = ' + AssessmentYearCtlTable.FieldByName('TaxableStatusDate').Text +
                        '  Valuation Date = ' + AssessmentYearCtlTable.FieldByName('ValuationDate').Text + #13 +
                        '      Basic STAR = ' + FormatFloat(CurrencyNormalDisplay, BasicSTARAmount) +
                        '  Enhanced STAR = ' + FormatFloat(CurrencyNormalDisplay, EnhancedSTARAmount) + #13 +
                        '      Eq rate = ' + FormatFloat(ExtendedDecimalDisplay, EqualizationRate) +
                        '  Uniform % = ' + FormatFloat(ExtendedDecimalDisplay, UniformPercentOfValue) + #13 +
                        TempStr,
                        mtConfirmation, [mbYes, mbNo], 0) = idYes);

end;  {ConfirmRollSetup}

{==================================================================================}
Function GetCollectionTypeCategory(CollectionType : String) : String;

begin
  Result := '';

  If _Compare(CollectionType, CountyTaxType, coEqual)
    then Result := 'COUNTY';

  If _Compare(CollectionType, [TownTaxType, MunicipalTaxType], coEqual)
    then Result := ANSIUpperCase(GetMunicipalityTypeName(GlblMunicipalityType));

  If _Compare(CollectionType, VillageTaxType, coEqual)
    then Result := 'VILLAGE';

  If _Compare(CollectionType, SchoolTaxType, coEqual)
    then Result := 'SCHOOL';

  If _Compare(CollectionType, SchoolMunicipalTaxType, coEqual)
    then Result := 'SCHOOL';

  If _Compare(CollectionType, SchoolMunicipalTaxType, coEqual)
    then Result := mtfnSchoolMunicipal;

end;  {GetCollectionTypeCategory}

{===========================================================================}
Function SpecialDistrictMatchesType(tbSpecialDistrictCodes : TTable;
                                    iSpecialDistrictType : Integer) : Boolean;

begin
  Result := False;

  with tbSpecialDistrictCodes do
  begin
    If (_Compare(iSpecialDistrictType, sdtSolidWaste, coEqual) and
        FieldByName('SolidWaste').AsBoolean)
      then Result := True;

    If (_Compare(iSpecialDistrictType, sdtWater, coEqual) and
        FieldByName('Water').AsBoolean)
      then Result := True;

    If (_Compare(iSpecialDistrictType, sdtSewer, coEqual) and
        FieldByName('Sewer').AsBoolean)
      then Result := True;

  end;  {with tbSpecialDistrictCodes do}

end;  {SpecialDistrictMatchesType}

{===========================================================================}
Procedure GetDistrictNameAndRate(    tbBillSpecialDistricts : TTable;
                                     tbBillSpecialDistrictRates : TTable;
                                     tbSpecialDistrictCodes : TTable;
                                     sSwisSBLKey : String;
                                     sTaxYear : String;
                                     sCollectionType : String;
                                     iCollectionNumber : String;
                                     iSpecialDistrictType : Integer;
                                 var sDistrictName : String;
                                 var fDistrictRate : Double);

var
  bFound : Boolean;

begin
  bFound := False;
  sDistrictName := 'N/A';
  fDistrictRate := 0;

  _SetRange(tbBillSpecialDistricts, [sSwisSBLKey, ''], [sSwisSBLKey, 'zzzzz'], '', []);

  with tbBillSpecialDistricts do
  begin
    First;

    while not (EOF or bFound) do
    begin
      If (_Locate(tbSpecialDistrictCodes, [FieldByName('SDistCode').AsString], '', []) and
          SpecialDistrictMatchesType(tbSpecialDistrictCodes, iSpecialDistrictType) and
          _Locate(tbBillSpecialDistrictRates,
                  [sTaxYear, sCollectionType, iCollectionNumber,
                   FieldByName('SDistCode').AsString, FieldByName('ExtCode').AsString, FieldByName('CMFlag').AsString], '', []))
        then
        begin
          bFound := True;
          sDistrictName := tbBillSpecialDistrictRates.FieldByName('SDistDescr').AsString;
          fDistrictRate := tbBillSpecialDistrictRates.FieldByName('HomesteadRate').AsFloat;

        end;  {If (_Locate(tbSpecialDistrictCodes...}

      Next;

    end;  {while not (EOF or Found) do}

  end;  {with tbBillSpecialDistricts do}

end;  {GetDistrictNameAndRate}

{========================================================================================}
Function GetBaseTaxRate(tbBillGeneralRates : TTable;
                        sTaxYear : String;
                        sCollectionType : String;
                        sCollectionNumber : String;
                        sTaxRateType : String) : Double;

begin
  Result := 0;

  _SetRange(tbBillGeneralRates, [sTaxYear, sCollectionType, sCollectionNumber, 0],
            [sTaxYear, sCollectionType, sCollectionNumber, 999], '', []);

  with tbBillGeneralRates do
  begin
    First;

    while not EOF do
    begin
      If _Compare(FieldByName('GeneralTaxType').AsString, sTaxRateType, coEqual)
        then Result := FieldByName('HomesteadRate').AsFloat;

      Next;

    end;  {while not EOF do}

  end;  {with tbBillGeneralRates do}

end;  {GetBaseTaxRate}

INITIALIZATION

begin
end;

end.
