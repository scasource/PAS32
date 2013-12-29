unit Utrtotpt;

{Routines for printing the section totals for assessment and tax rolls.}

interface

USES Types, Glblvars, SysUtils, WinTypes, WinProcs, BtrvDlg,
     Messages, Dialogs, Forms, wwTable, Classes, DB, DBTables,
     Controls,DBCtrls,StdCtrls, PASTypes, WinUtils, GlblCnst, Utilitys,
     wwDBLook, Graphics, PASUTILS, UTILEXSD,  RPBase, RPDefine;


Function PrintSectionTotals(    Sender : TObject;  {Report printer or filer object}
                                RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                RollSection : String;
                                SwisCode,
                                SchoolCode : String;
                                GeneralRateList,
                                SDRateList,
                                SpecialFeeRateList,
                                GnTaxList,
                                SDTaxList,
                                SpFeeTaxList,
                                ExTaxList : TList;
                                GeneralTotalsTable,
                                SchoolTotalsTable,
                                EXTotalsTable,
                                SDTotalsTable,
                                SpecialFeeTotalsTable : TTable;
                                CollectionType : String;
                                RollPrintingYear : String;
                                SDCodeTable,
                                AssessmentYearCtlTable : TTable;
                                SDCodeDescList,  {Description lists}
                                SDExtCodeDescList,
                                EXCodeDescList,
                                SchoolCodeDescList,
                                SwisCodeDescList,
                                RollSectionList : TList;
                                SelectedRollSections : TStringList;
                                SequenceStr : String;  {Text for what order roll is printing in.}
                            var ParcelPrintedThisPage : Boolean;
                            var PageNo,
                                LineNo : Integer;
                            var Quit : Boolean) : Extended;

Function PrintSectionTotals_FromTotalsLists(    Sender : TObject;  {Report printer or filer object}
                                                RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                                SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                                RollSection : String;
                                                SwisCode : String;
                                                SchoolCode : String;
                                                LastCooperative : String;
                                                GeneralRateList,
                                                SDRateList,
                                                SpecialFeeRateList,
                                                SDTotalsList,
                                                EXTotalsList,
                                                SchoolTotalsList,
                                                GeneralTotalsList,
                                                SpecialFeeTotalsList : TList;
                                                CollectionType : String;
                                                RollPrintingYear : String;
                                                SDCodeTable,
                                                AssessmentYearCtlTable : TTable;
                                                SDCodeDescList,  {Description lists}
                                                SDExtCodeDescList,
                                                EXCodeDescList,
                                                SchoolCodeDescList,
                                                SwisCodeDescList,
                                                RollSectionList : TList;
                                                SelectedRollSections : TStringList;
                                                SequenceStr : String;  {Text for what order roll is printing in.}
                                            var ParcelPrintedThisPage : Boolean;
                                            var PageNo,
                                                LineNo : Integer;
                                            var Quit : Boolean) : Extended;

{Print the totals for this roll section, swis, school, or end of report
 break.}
{FXX04291998-4: Figure out the total tax for these roll sections, so make this
                a function that returns that amount.}

implementation

uses UtilBill;

var
  CollectionHasSchoolTax : Boolean;

{=======================================================================}
Function GetSectionHeader(SectionType,
                          RollSection : String) : String;

{For roll section headers, print the roll section description. Otherwise,
 print either "Swis Totals" or "Municipality Totals".}

begin
  If (SectionType = 'R')
    then Result := RollSection
    else Result := SectionType;

end;  {GetSectionHeader}

{=======================================================================}
Procedure PrintTotalsPageSubheader(    Sender : TObject;  {Report printer or filer object}
                                       SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                   var LineNo : Integer);

{This is a header that appears once at the top of each totals page.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      case SectionType of
        'R' : Println(Center('R O L L    S E C T I O N    T O T A L S', NumColsPerPage));
        'S' : Println(Center('S W I S    T O T A L S', NumColsPerPage));
        'C' : Println(Center('S C H O O L    T O T A L S', NumColsPerPage));
        'G' : Println(Center('M U N I C I P A L I T Y    T O T A L S', NumColsPerPage));

      end;  {case SectionType of}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintTotalsPageSubheader}

{=======================================================================}
Procedure PrintSectionHeader(    Sender : TObject;  {Report printer or filer object}
                                 TotalsType : Char;  {(G)eneral, S(c)hool, S(D), E(X), Spcl (F)ee}
                                 RollSection : String;
                             var LineNo : Integer);

{Print the totals section subheader.}

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      Println('');

      case TotalsType of
        'D' : If (RollSection = '9')
                then Println(Center('***  O U T S T A N D I N G   T A X   S U M M A R Y ***', NumColsPerPage))
                else Println(Center('***  S P E C I A L    D I S T R I C T   S U M M A R Y ***', NumColsPerPage));
        'X' : Println(Center('***  E X E M P T I O N   S U M M A R Y ***', NumColsPerPage));
        'C' : Println(Center('***  S C H O O L   S U M M A R Y ***', NumColsPerPage));
        'F' : Println(Center('***  S P E C I A L   F E E   S U M M A R Y ***', NumColsPerPage));
        'G' : Println(Center('***  G R A N D   T O T A L S ***', NumColsPerPage));

      end;  {case TotalsType of}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 2;

end;  {PrintSectionHeader}

{=======================================================================}
Procedure PrintSectionSubheader(    Sender : TObject;  {Report printer or filer object}
                                    SectionType : Char;  {(S)wis, S(c)hool, (G)rand, (H)std, (N)onhstd}
                                var LineNo : Integer);

{Print the totals section subheader.}

begin
    {FXX06291998-5: Only need subheaders if the municipality is classified.}

  If GlblMunicipalityIsClassified
    then
      with Sender as TBaseReport do
        begin
          ClearTabs;
          Println('');

          case SectionType of
            'S' : Println(Center('***  S W I S  ***', NumColsPerPage));
            'C' : Println(Center('***  S C H O O L  ***', NumColsPerPage));
            'G' : Println(Center('***  M U N I C I P A L I T Y  ***', NumColsPerPage));
            'H' : Println(Center('***  H O M E S T E A D  ***', NumColsPerPage));
            'N' : Println(Center('***  N O N - H O M E S T E A D  ***', NumColsPerPage));

          end;  {case SectionType of}

          LineNo := LineNo + 2;

        end;  {with Sender as TBaseReport do}

end;  {PrintSectionSubheader}

{CHG08171999-1: Add in special fee totals.}
{=======================================================================}
{======================  Special Fee TOTALS ROUTINES ===================}
{=======================================================================}
{======================================================================}
Function FoundSpecialFeeTotalRecord(    SpecialFeeTotalsList : TList;
                                        _PrintOrder : Integer;
                                        _RollSection : String;
                                        _SwisCode : String;
                                        _SchoolCode : String;
                                        CombineRollSections,
                                        CombineSwisCodes,
                                        CombineSchoolCodes : Boolean;
                                    var I : Integer) : Boolean;

{Search through the totals list for this print order, roll section,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

    {FXX01091998-7: Don't compare homestead codes if it is blank.}

  For J := 0 to (SpecialFeeTotalsList.Count - 1) do
    with SPFeeTotPtr(SpecialFeeTotalsList[J])^ do
      If ((PrintOrder = _PrintOrder) and
          (CombineRollSections or
           ((not CombineRollSections) and
            (Take(1, RollSection) = Take(1, _RollSection)))) and
          (CombineSwisCodes or
           ((not CombineSwisCodes) and
            (Take(6, SwisCode) = Take(6, _SwisCode)))) and
          (CombineSchoolCodes or
           ((not CombineSchoolCodes) and
            (Take(6, SchoolCode) = Take(6, _SchoolCode)))))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundSpecialFeeTotalRecord}

{=======================================================================}
Procedure LoadSpecialFeeTotals(    SpecialFeeTotalsTable : TTable;
                                   CollectionType : String;  {SC, MU, CO, VI}
                                   SpecialFeeTotalsList : TList;  {Broken up by homestead and non-homestead.}
                                   SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                   RollSection : String;
                                   SwisCode,
                                   SchoolCode : String;
                                   SelectedRollSections : TStringList;
                               var Quit : Boolean);

{Load all the General totals for this roll section, swis code, school code,
 (or all for grand totals) into two TLists which have General amounts.
 One for homestead and one for non-homestead. If this is not a classified
 municipality, the totals will go in the homestead list.}

var
  FirstTimeThrough, Done : Boolean;
  SpecialFeeTotalsPtr : SPFeeTotPtr;
  I : Integer;

begin
  Done := False;
  FirstTimeThrough := True;

    {FXX01091998-1: If we are loading swis or munic totals, make sure the
                    roll section is blank.  If we are loading munic totals,
                    make sure the swis and school are blank.}

  If (SectionType in ['S', 'G'])
    then RollSection := '';

  If (SectionType = 'G')
    then
      begin
        SwisCode := '';
        SchoolCode := '';
      end;

    {Set the index and range of the General table for this collection type.}
    {FXX04231998-10: Need to cancel last range so that munic totals don't show
                     swis totals.}

  SpecialFeeTotalsTable.CancelRange;

  with SpecialFeeTotalsTable do
    If (CollectionHasSchoolTax and
        (CollectionType = 'SC'))
      then
        begin
          DisableControls;
          IndexName := 'BYSCHOOL_SWIS_RS_PRINTORDER';

          case SectionType of
            'R' : SetRangeOld(SpecialFeeTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'PrintOrder'],
                              [SchoolCode, SwisCode, RollSection, '0'],
                              [SchoolCode, SwisCode, RollSection, '32000']);

            'S' : SetRangeOld(SpecialFeeTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'PrintOrder'],
                              [SchoolCode, SwisCode, '1', '0'],
                              [SchoolCode, SwisCode, '9', '32000']);

            'C' : SetRangeOld(SpecialFeeTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'PrintOrder'],
                              [SchoolCode, '      ', '1', '0'],
                              [SchoolCode, '999999', '9', '32000']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

          EnableControls;

        end
      else
        begin
          IndexName := 'BYSWISCODE_RS_PRINTORDER';

          case SectionType of
            'R' : SetRangeOld(SpecialFeeTotalsTable,
                              ['SwisCode', 'RollSection', 'PrintOrder'],
                              [SwisCode, RollSection, '0'],
                              [SwisCode, RollSection, '32000']);
            'S' : SetRangeOld(SpecialFeeTotalsTable,
                              ['SwisCode', 'RollSection', 'PrintOrder'],
                              [SwisCode, '1', '0'],
                              [SwisCode, '9', '32000']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

        end;  {else of If (CollectionType = 'SC')}

  try
    SpecialFeeTotalsTable.First;
  except
    Quit := True;
    SystemSupport(800, SpecialFeeTotalsTable, 'Error getting first special fee totals record.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          SpecialFeeTotalsTable.Next;
        except
          Quit := True;
          SystemSupport(800, SpecialFeeTotalsTable, 'Error getting next SpecialFee totals record.',
                        'UTILBILL.PAS', GlblErrorDlgBox);
        end;

    If SpecialFeeTotalsTable.EOF
      then Done := True;

      {FXX04241998-1: Only load the roll sections that we want in this section
                      of the roll.}

    If not Done
      then
        If (SelectedRollSections.IndexOf(SpecialFeeTotalsTable.FieldByName('RollSection').Text) <> -1)
          then
            begin
              with SpecialFeeTotalsTable do
                If FoundSpecialFeeTotalRecord(SpecialFeeTotalsList,
                                              FieldByName('PrintOrder').AsInteger,
                                              FieldByName('RollSection').Text,
                                              FieldByName('SwisCode').Text,
                                              FieldByName('SchoolCode').Text,
                                              False, False, False, I)
                  then
                    begin
                      with SPFeeTotPtr(SpecialFeeTotalsList[I])^ do
                        begin
                          ParcelCt := ParcelCt + FieldByName('ParcelCt').AsInteger;
                          TotalTax := TotalTax + FieldByName('TotalTax').AsFloat;

                        end;  {with SpecialFeeistTotPtr(SpecialFeeTotalsList[I])^ do}

                    end
                  else
                    begin
                      New(SpecialFeeTotalsPtr);   {get new pptr for tlist array}

                      with SpecialFeeTotalsPtr^ do
                        begin
                          SwisCode := FieldByName('SwisCode').Text;
                          SchoolCode := FieldByName('SchoolCode').Text;
                          RollSection := FieldByName('RollSection').Text;
                          PrintOrder := FieldByName('PrintOrder').AsInteger;
                          ParcelCt := FieldByName('ParcelCt').AsInteger;
                          TotalTax := FieldByName('TotalTax').AsFloat;

                        end;  {with SpecialFeeTotalsPtr^ do}

                      SpecialFeeTotalsList.Add(SpecialFeeTotalsPtr);

                    end;  {else of If FoundSpecialFeeRecord(SpecialFeeTotalsList,}

            end;  {If not Done}

  until (Done or Quit);

end;  {LoadSpecialFeeTotals}

{=======================================================================}
Procedure CombineSpecialFeeTotals(SpecialFeeTotalsList,  {List with totals broken down into hstd, nonhstd.}
                                  OverallTotalsList : TList;  {No hstd\nonhstd breakdown.}
                                  RollSection : String;
                                  SwisCode,
                                  SchoolCode : String;
                                  CombineRollSections : Boolean;  {Should we combine the
                                                                    tax for one tax type
                                                                    down into one line?}
                                  CombineSwisCodes : Boolean;
                                  CombineSchoolCodes : Boolean);

{The totals entries in the SpecialFeeTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the SpecialFeeTotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  SpecialFeeTotalsPtr : SPFeeTotPtr;

begin
  For I := 0 to (SpecialFeeTotalsList.Count - 1) do
    with SPFeeTotPtr(SpecialFeeTotalsList[I])^ do
      If FoundSpecialFeeTotalRecord(OverallTotalsList, PrintOrder, RollSection,
                                    SwisCode, SchoolCode,
                                    CombineRollSections, CombineSwisCodes,
                                    CombineSchoolCodes, J)  {Don't use hstd code as a key.}
        then
          begin
              {Note that we do not add the split count again since we
               would be double counting it then.}

            SPFeeTotPtr(OverallTotalsList[J])^.ParcelCt :=
                     SPFeeTotPtr(OverallTotalsList[J])^.ParcelCt + ParcelCt;
            SPFeeTotPtr(OverallTotalsList[J])^.TotalTax :=
                     SPFeeTotPtr(OverallTotalsList[J])^.TotalTax + TotalTax;

          end
        else
          begin
            New(SpecialFeeTotalsPtr);   {get new pptr for tlist array}

            SpecialFeeTotalsPtr^.SwisCode := SwisCode;
            SpecialFeeTotalsPtr^.SchoolCode := SchoolCode;

              {If this is a total across roll sections, don't save the
               roll section code.}

            If ((Deblank(RollSection) = '') and
                CombineRollSections)
              then SpecialFeeTotalsPtr^.RollSection := ''
              else SpecialFeeTotalsPtr^.RollSection := RollSection;

            SpecialFeeTotalsPtr^.ParcelCt := ParcelCt;

            SpecialFeeTotalsPtr^.PrintOrder := PrintOrder;
            SpecialFeeTotalsPtr^.TotalTax := TotalTax;

            OverallTotalsList.Add(SpecialFeeTotalsPtr);

          end;  {else of If FoundSpecialFeeRecord(OverallTotalsList, SpecialFeeCode, ExtCode, CMFlag,}

end;  {CombineSpecialFeeTotals}

{=======================================================================}
{======================  GENERAL TAX TOTALS ROUTINES ===================}
{=======================================================================}
{======================================================================}
Function FoundGeneralTaxTotalRecord(    GeneralTotalsList : TList;
                                        _PrintOrder : Integer;
                                        _RollSection,
                                        _HomesteadCode : String;
                                        CombineRollSections : Boolean;
                                    var I : Integer) : Boolean;

{Search through the totals list for this print order, roll section,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

    {FXX01091998-7: Don't compare homestead codes if it is blank.}

  For J := 0 to (GeneralTotalsList.Count - 1) do
    with GeneralTotPtr(GeneralTotalsList[J])^ do
      If ((PrintOrder = _PrintOrder) and
          (CombineRollSections or
           ((not CombineRollSections) and
            (Take(1, RollSection) = Take(1, _RollSection)))) and
          ((Deblank(_HomesteadCode) = '') or
           (Take(1, HomesteadCode) = Take(1, _HomesteadCode))))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundGeneralTaxTotalRecord}

{=======================================================================}
Procedure LoadGeneralTaxTotals(    GeneralTotalsTable : TTable;
                                   CollectionType : String;  {SC, MU, CO, VI}
                                   GeneralTotalsList : TList;  {Broken up by homestead and non-homestead.}
                                   SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                   RollSection : String;
                                   SwisCode,
                                   SchoolCode : String;
                                   SelectedRollSections : TStringList;
                               var Quit : Boolean);

{Load all the General totals for this roll section, swis code, school code,
 (or all for grand totals) into two TLists which have General amounts.
 One for homestead and one for non-homestead. If this is not a classified
 municipality, the totals will go in the homestead list.}

var
  FirstTimeThrough, Done : Boolean;
  GeneralTotalsPtr : GeneralTotPtr;
  I : Integer;

begin
  Done := False;
  FirstTimeThrough := True;

    {FXX01091998-1: If we are loading swis or munic totals, make sure the
                    roll section is blank.  If we are loading munic totals,
                    make sure the swis and school are blank.}

  If (SectionType in ['S', 'G'])
    then RollSection := '';

  If (SectionType = 'G')
    then
      begin
        SwisCode := '';
        SchoolCode := '';
      end;

    {Set the index and range of the General table for this collection type.}
    {FXX04231998-10: Need to cancel last range so that munic totals don't show
                     swis totals.}

  GeneralTotalsTable.CancelRange;

  with GeneralTotalsTable do
    If (CollectionHasSchoolTax and
        (CollectionType = 'SC'))
      then
        begin
          GeneralTotalsTable.DisableControls;
          IndexName := 'BYSCHOOLCODE_RS_HC_PRINTORDER';

            {FXX08082001-3: Missing HomesteadCode from range - caused roll section
                            totals not to print on a school roll.}

          case SectionType of
            'R' : SetRangeOld(GeneralTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode', 'PrintOrder'],
                              [SchoolCode, SwisCode, RollSection, ' ', '0'],
                              [SchoolCode, SwisCode, RollSection, 'Z', '']);

            'S' : SetRangeOld(GeneralTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode', 'PrintOrder'],
                              [SchoolCode, SwisCode, '1', '', ''],
                              [SchoolCode, SwisCode, '9', '', '']);

            'C' : SetRangeOld(GeneralTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode', 'PrintOrder'],
                              [SchoolCode, '      ', '', '', ''],
                              [SchoolCode, '999999', '', '', '']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

          GeneralTotalsTable.EnableControls;

        end
      else
        begin
          IndexName := 'BYSWISCODE_RS_HC_PRINTORDER';

          case SectionType of
            'R' : SetRangeOld(GeneralTotalsTable,
                              ['SwisCode', 'RollSection', 'HomesteadCode', 'PrintOrder'],
                              [SwisCode, RollSection, ' ', '0'],
                              [SwisCode, RollSection, 'Z', '32000']);
            'S' : SetRangeOld(GeneralTotalsTable,
                              ['SwisCode', 'RollSection', 'HomesteadCode', 'PrintOrder'],
                              [SwisCode, '1', ' ', '0'],
                              [SwisCode, '9', 'Z', '32000']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

        end;  {else of If CollectionHasSchoolTax}

  try
    GeneralTotalsTable.First;
  except
    Quit := True;
    SystemSupport(800, GeneralTotalsTable, 'Error getting first General totals record.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          GeneralTotalsTable.Next;
        except
          Quit := True;
          SystemSupport(800, GeneralTotalsTable, 'Error getting next General totals record.',
                        'UTILBILL.PAS', GlblErrorDlgBox);
        end;

    If GeneralTotalsTable.EOF
      then Done := True;

      {FXX04241998-1: Only load the roll sections that we want in this section
                      of the roll.}

    If not Done
      then
        If (SelectedRollSections.IndexOf(GeneralTotalsTable.FieldByName('RollSection').Text) <> -1)
          then
            begin
              with GeneralTotalsTable do
                If FoundGeneralTaxTotalRecord(GeneralTotalsList,
                                              FieldByName('PrintOrder').AsInteger,
                                              FieldByName('RollSection').Text,
                                              FieldByName('HomesteadCode').Text,
                                              False, I)
                  then
                    begin
                      with GeneralTotPtr(GeneralTotalsList[I])^ do
                        begin
                            {FXX01071998-7: Track the number of splits to
                                            subtract out of total.}

                          PartCt := PartCt + FieldByName('SplitParcelCt').AsInteger;
                          ParcelCt := ParcelCt + FieldByName('ParcelCt').AsInteger;
                          LandAV := LandAV + FieldByName('LandAV').AsFloat;
                          TotalAV := TotalAV + FieldByName('TotalAV').AsFloat;
                          ExemptAmt := ExemptAmt + FieldByName('ExemptAmt').AsFloat;
                          TaxableVal := TaxableVal + FieldByName('TaxableVal').AsFloat;
                          TotalTax := TotalTax + FieldByName('TotalTax').AsFloat;

                            {FXX05061998-3: Save the STAR amounts for school billings.}

                          STARAmount := STARAmount + FieldByName('STARAmount').AsFloat;
                          TaxableValAfterSTAR := TaxableValAfterSTAR +
                                                 FieldByName('TaxableValAfterSTAR').AsFloat;

                            {FXX06181998-6: Don't forget STAR savings.}

                          STARSavings := STARSavings +
                                         FieldByName('STARSavings').AsFloat;

                        end;  {with GeneralistTotPtr(GeneralTotalsList[I])^ do}

                    end
                  else
                    begin
                      New(GeneralTotalsPtr);   {get new pptr for tlist array}

                      with GeneralTotalsPtr^ do
                        begin
                          SwisCode := FieldByName('SwisCode').Text;
                          SchoolCode := FieldByName('SchoolCode').Text;
                          RollSection := FieldByName('RollSection').Text;
                          HomesteadCode := FieldByName('HomesteadCode').Text;
                          PrintOrder := FieldByName('PrintOrder').AsInteger;
                          ParcelCt := FieldByName('ParcelCt').AsInteger;
                            {FXX01071998-7: Track the number of splits to
                                            subtract out of total.}

                          PartCt := FieldByName('SplitParcelCt').AsInteger;

                          LandAV := FieldByName('LandAV').AsFloat;
                          TotalAV := FieldByName('TotalAV').AsFloat;
                          ExemptAmt := FieldByName('ExemptAmt').AsFloat;
                          TaxableVal := FieldByName('TaxableVal').AsFloat;
                          TotalTax := FieldByName('TotalTax').AsFloat;

                            {FXX05061998-3: Save the STAR amounts for school billings.}

                          STARAmount := FieldByName('STARAmount').AsFloat;
                          TaxableValAfterSTAR := FieldByName('TaxableValAfterSTAR').AsFloat;

                            {FXX06181998-6: Don't forget STAR savings.}

                          STARSavings := FieldByName('STARSavings').AsFloat;

                        end;  {with GeneralTotalsPtr^ do}

                      GeneralTotalsList.Add(GeneralTotalsPtr);

                    end;  {else of If FoundGeneralRecord(GeneralTotalsList,}

            end;  {If not Done}

  until (Done or Quit);

end;  {LoadGeneralTaxTotals}

{=======================================================================}
Procedure CombineGeneralTaxTotals(GeneralTotalsList,  {List with totals broken down into hstd, nonhstd.}
                                  OverallTotalsList : TList;  {No hstd\nonhstd breakdown.}
                                  CombineRollSections : Boolean;  {Should we combine the
                                                                    tax for one tax type
                                                                    down into one line?}
                                  CollectionType : String);

{The totals entries in the GeneralTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the GeneralTotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  GeneralTotalsPtr : GeneralTotPtr;

begin
  For I := 0 to (GeneralTotalsList.Count - 1) do
    with GeneralTotPtr(GeneralTotalsList[I])^ do
      If FoundGeneralTaxTotalRecord(OverallTotalsList, PrintOrder, RollSection,
                                    ' ', CombineRollSections, J)  {Don't use hstd code as a key.}
        then
          begin
              {Note that we do not add the split count again since we
               would be double counting it then.}

            GeneralTotPtr(OverallTotalsList[J])^.ParcelCt :=
                     GeneralTotPtr(OverallTotalsList[J])^.ParcelCt + ParcelCt;
            GeneralTotPtr(OverallTotalsList[J])^.LandAV :=
                     GeneralTotPtr(OverallTotalsList[J])^.LandAV + LandAV;
            GeneralTotPtr(OverallTotalsList[J])^.TotalAV :=
                     GeneralTotPtr(OverallTotalsList[J])^.TotalAV + TotalAV;
            GeneralTotPtr(OverallTotalsList[J])^.ExemptAmt :=
                     GeneralTotPtr(OverallTotalsList[J])^.ExemptAmt + ExemptAmt;
            GeneralTotPtr(OverallTotalsList[J])^.TaxableVal :=
                     GeneralTotPtr(OverallTotalsList[J])^.TaxableVal + TaxableVal;
            GeneralTotPtr(OverallTotalsList[J])^.TotalTax :=
                     GeneralTotPtr(OverallTotalsList[J])^.TotalTax + TotalTax;

              {FXX05061998-3: Save the STAR amounts for school billings.}

            If CollectionHasSchoolTax
              then
                begin
                  GeneralTotPtr(OverallTotalsList[J])^.TaxableValAfterSTAR :=
                           GeneralTotPtr(OverallTotalsList[J])^.TaxableValAfterSTAR +
                           TaxableValAfterSTAR;

                  GeneralTotPtr(OverallTotalsList[J])^.STARAmount :=
                           GeneralTotPtr(OverallTotalsList[J])^.STARAmount + STARAmount;

                    {FXX06181998-6: Don't forget STAR savings.}

                  GeneralTotPtr(OverallTotalsList[J])^.STARSavings :=
                           GeneralTotPtr(OverallTotalsList[J])^.STARSavings + STARSavings;

                end;  {If CollectionHasSchoolTax}

          end
        else
          begin
            New(GeneralTotalsPtr);   {get new pptr for tlist array}

            GeneralTotalsPtr^.SwisCode := SwisCode;
            GeneralTotalsPtr^.SchoolCode := SchoolCode;

              {If this is a total across roll sections, don't save the
               roll section code.}

            If CombineRollSections
              then GeneralTotalsPtr^.RollSection := ''
              else GeneralTotalsPtr^.RollSection := RollSection;

            GeneralTotalsPtr^.HomesteadCode := ' ';  {Blank out hstd code.}
            GeneralTotalsPtr^.PrintOrder := PrintOrder;
            GeneralTotalsPtr^.LandAV := LandAV;
            GeneralTotalsPtr^.TotalAV := TotalAV;
            GeneralTotalsPtr^.ParcelCt := ParcelCt;
            GeneralTotalsPtr^.PartCt := PartCt;
            GeneralTotalsPtr^.ExemptAmt := ExemptAmt;
            GeneralTotalsPtr^.TaxableVal := TaxableVal;
            GeneralTotalsPtr^.TotalTax := TotalTax;

              {FXX05061998-3: Save the STAR amounts for school billings.}

            If CollectionHasSchoolTax
              then
                begin
                  GeneralTotalsPtr^.STARAmount := STARAmount;
                  GeneralTotalsPtr^.TaxableValAfterSTAR := TaxableValAfterSTAR;

                    {FXX06181998-6: Don't forget STAR savings.}

                  GeneralTotalsPtr^.STARSavings := STARSavings;

                end;  {If CollectionHasSchoolTax}

            OverallTotalsList.Add(GeneralTotalsPtr);

          end;  {else of If FoundGeneralRecord(OverallTotalsList, GeneralCode, ExtCode, CMFlag,}

end;  {CombineGeneralTotals}

{=======================================================================}
Procedure UpdateGeneralTaxRollTotals(    SourceGeneralTotalsRec : GeneralTotRecord;
                                     var TempGeneralTotalRec : GeneralTotRecord);

{Update the running totals in the TempGeneralTotalRec from the source
 rec.}

begin
  with TempGeneralTotalRec do
    begin
      ParcelCt := ParcelCt + SourceGeneralTotalsRec.ParcelCt;
      LandAV := LandAv + SourceGeneralTotalsRec.LandAV;
      TotalAV := TotalAV + SourceGeneralTotalsRec.TotalAV;
      ExemptAmt := ExemptAmt + SourceGeneralTotalsRec.ExemptAmt;
      TaxableVal := TaxableVal + SourceGeneralTotalsRec.TaxableVal;
      TotalTax := TotalTax + SourceGeneralTotalsRec.TotalTax;

        {FXX05061998-3: Save the STAR amounts for school billings.}

      STARAmount := STARAmount + SourceGeneralTotalsRec.STARAmount;
      TaxableValAfterSTAR := TaxableValAfterSTAR +
                             SourceGeneralTotalsRec.TaxableValAfterSTAR;

    end;  {with TempGeneralTotalRec do}

end;  {UpdateGeneralTaxRollTotals}

{=======================================================================}
Procedure PrintGeneralTaxRollSubheader(    Sender : TObject;  {Report printer or filer object}
                                           RollType : Char;
                                           SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                           CollectionType : String;  {(MU)nicipal, (SC)hool, (VI)llage}
                                       var LineNo : Integer);

{Print the individual General totals section header and set the tabs for the
 General amounts columns.}

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hstd\nonhstd.}

      If (SubheaderType <> 'R')
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Roll Section}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjCenter, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjCenter, TL4W, 0, BOXLINENONE, 0);   {Land AV}
      SetTab(TL5, pjCenter, TL5W, 0, BOXLINENONE, 0);   {Total AV}
      SetTab(TL6, pjCenter, TL6W, 0, BOXLINENONE, 0);   {Exempt amount}
      SetTab(TL7, pjCenter, TL7W, 0, BOXLINENONE, 0);   {Taxable val}
      SetTab(TL8, pjCenter, TL8W, 0, BOXLINENONE, 0);   {Tax rate}
      SetTab(TL9, pjCenter, TL9W, 0, BOXLINENONE, 0);   {Total tax}

      Println('');
      Print(#9 +'ROLL' +
            #9 +
            #9 + 'TOTAL' +
            #9 + 'ASSESSED' +
            #9 + 'ASSESSED' +
            #9 + 'EXEMPT' +
            #9 + 'TOTAL');

      If _Compare(RollType, 'X', coEqual)
        then Println(#9 + 'TAX' +
                     #9 + 'TOTAL')
        else Println('');

      Print(#9 + 'SEC' +
            #9 + 'DESCRIPTION' +
            #9 + 'PARCELS' +
            #9 + 'LAND' +
            #9 + 'TOTAL' +
            #9 + 'AMOUNT' +
            #9 + 'TAXABLE');

      If _Compare(RollType, 'X', coEqual)
        then Println(#9 + 'RATE' +
                     #9 + 'TAX')
        else Println('');

        LineNo := LineNo + 3;

          {FXX06251998-8: Add the STAR amount fields to the tax roll.}

        If CollectionHasSchoolTax
          then
            begin
              Println(#9 + #9 + #9 + #9 + #9 +
                      #9 + '-----------' +
                      #9 + '------------');

              Println(#9 + #9 + #9 + #9 + #9 +
                      #9 + 'STAR AMOUNT' +
                      #9);
                      (*#9 + 'STAR TAXABLE'); *)

              LineNo := LineNo + 2;

            end;  {If CollectionHasSchoolTax}

         {If this is a homestead or nonhomestead section,
          print that this is the total number of parcels and parts.}

       If (SubheaderType in ['H', 'N'])
         then
           begin
             Println(#9 + #9 + #9 + '& PARTS');
             LineNo := LineNo + 1;
           end;

       {FXX12291997-2: Print a blank line between the header and the start
                       of the information.}

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintGeneralTaxRollSubheader}

{=======================================================================}
Function GetSDTaxForRollSection(SDTotList : TList;
                                RollSection : String;
                                SwisCode : String) : Extended;

{For the given roll section, add up all SD's in the swis code (or partial
 swis code).  If the roll section is blank, we don't care about roll
 section.}

var
  I, SwisCodeLen : Integer;

begin
  Result := 0;

  SwisCodeLen := Length(Trim(SwisCode));

  For I := 0 to (SDTotList.Count - 1) do
    If (((Deblank(RollSection) = '') or  {We want all SD's}
         (SDistTotPtr(SDTotList[I])^.RollSection = RollSection)) and
        (Take(SwisCodeLen, SDistTotPtr(SDTotList[I])^.SwisCode) =
         Take(SwisCodeLen, SwisCode)))
      then Result := Result + SDistTotPtr(SDTotList[I])^.TotalTax;

end;  {GetSDTaxForRollSection}

{=======================================================================}
Procedure PrintOneGeneralTax(    Sender : TObject;  {Report printer or filer object}
                                 RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                 SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                 CollectionType : String;  {(MU)nicipal, (SC)hool, (VI)llage}
                                 GeneralRateList : TList;
                                 GeneralTotalsRec : GeneralTotRecord;
                             var LineNo : Integer);

{Print one general tax total.}

var
  I : Integer;
  FoundRate : Boolean;

begin
  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Roll Section}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, TL4W, 0, BOXLINENONE, 0);   {Land AV}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {Total AV}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {Exempt amount}
      SetTab(TL7, pjRight, TL7W, 0, BOXLINENONE, 0);   {Taxable val}
      SetTab(TL8, pjRight, TL8W, 0, BOXLINENONE, 0);   {Tax rate}
      SetTab(TL9, pjRight, TL9W, 0, BOXLINENONE, 0);   {Total tax}

      with GeneralTotalsRec do
        begin
           {FXX05032000-8: Need to search on the swis code also so that we don't have a
                           problem with same print order for a tax type but diff rates.}

          I := FindGeneralRate(PrintOrder, '', GeneralTotalsRec.SwisCode, GeneralRateList);

          FoundRate := (I > -1);

            {FXX01021998-15: Only print the roll section for the
                             first tax line in a roll section.}
            {FXX01051998-5: Don't print the roll section on individual
                            lines.}
            {FXX04011999-1 DODCCC }

          Print(#9 + RollSection);

          If FoundRate
            then Print(#9 + Take(17, UpcaseStr(GeneralRatePointer(GeneralRateList[I])^.Description)))
            else Print(#9 + 'UNKNOWN');   {should we do system support}

            {FXX01071998-7: Subtract the number of splits out of the total.}

          If (SubheaderType in ['H', 'N'])
            then Print(#9 + IntToStr(ParcelCt))
            else Print(#9 + IntToStr(ParcelCt - PartCt));

          If (Roundoff(LandAV, 2) > 0)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, LandAV))
            else Print(#9);

          If (Roundoff(TotalAV, 2) > 0)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalAV))
            else Print(#9);

          If (Roundoff(ExemptAmt, 0) > 0)
             then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, ExemptAmt))
             else Print(#9);

          If (Roundoff(TaxableVal, 2) > 0)
             then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal))
             else Print(#9);

               {FXX06251998-8: Add the STAR amount fields to the tax roll.}
            {If school collection, go to the next line for STAR amounts.}

          If CollectionHasSchoolTax
            then
              begin
                Println('');
                Print(#9 + #9 + #9 + #9 + #9 +
                      #9 + FormatFloat(NoDecimalDisplay_BlankZero, STARAmount) +
                      #9);
                      (*#9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableValAfterSTAR)); *)
                LineNo := LineNo + 1;

              end;  {If CollectionHasSchoolTax}

            {If we can find an General rate in the list and this is
             the header for a homestead on non-homestead section,
             print the rate. Otherwise, it doesn't make sense to
             print the rate since the homestead and non-homestead may
             be different.}
            {FXX06251998-9: Subheader type can be blank if not classified.}

          If _Compare(RollType, 'X', coEqual)
            then
              begin
                If ((SubheaderType in ['N', 'H', ' ']) and
                    FoundRate)
                  then
                    begin
                      with GeneralRatePointer(GeneralRateList[I])^ do
                        If (HomesteadCode = 'N')
                          then
                            begin
                              If (Roundoff(NonhomesteadRate, 6) = 0)
                                then Print(#9)
                                else Print(#9 + FormatFloat(ExtendedDecimalDisplay,
                                                            NonhomesteadRate));

                            end
                          else
                            begin
                                {FXX05032000-6: If have dual rates, in totals, do not
                                                print a rate.}

                              If ((GlblMunicipalityUsesTwoTaxRates and
                                   (HomesteadCode = ' ')) or
                                  (Roundoff(HomesteadRate, 6) = 0))
                                then Print(#9)
                                else Print(#9 + FormatFloat(ExtendedDecimalDisplay,
                                                            HomesteadRate));

                            end;  {else of If (HomesteadCode = 'N')}

                    end  {If ((SubheaderType in ['N', 'H']) and ...}
                  else Print(#9);

                Println(#9 + FormatFloat(DecimalDisplay, TotalTax));

              end  {If _Compare(RollType, 'X', coEqual)}
            else Println('');

        end;  {with GeneralTotalsRec do}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintOneGeneralTaxRollTotal}

{=======================================================================}
Procedure PrintOneSpecialFeeTax(    Sender : TObject;  {Report printer or filer object}
                                    SpecialFeeRateList : TList;
                                    SpecialFeeTotalsRec : SPFeeTotRecord;
                                var LineNo : Integer);

{Print one SpecialFee tax total.}

var
  TempStr : String;

begin
  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Roll Section}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, TL4W, 0, BOXLINENONE, 0);   {Land AV}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {Total AV}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {Exempt amount}
      SetTab(TL7, pjRight, TL7W, 0, BOXLINENONE, 0);   {Taxable val}
      SetTab(TL8, pjRight, TL8W, 0, BOXLINENONE, 0);   {Tax rate}
      SetTab(TL9, pjRight, TL9W, 0, BOXLINENONE, 0);   {Total tax}

      with SpecialFeeTotalsRec do
        begin
          TempStr := GetSPFeeTaxDesc(PrintOrder, SpecialFeeRateList);

          Print(#9 + #9 + Take(17, UpcaseStr(TempStr)));

            {FXX01071998-7: Subtract the number of splits out of the total.}

          Print(#9 + IntToStr(ParcelCt));

          Println(#9 + #9 + #9 + #9 + #9 + #9 + FormatFloat(DecimalDisplay, TotalTax));

        end;  {with SpecialFeeTotalsRec do}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintOneSpecialFeeTaxRollTotal}

{=======================================================================}
Function GetRollSectionDescriptionForRollPrint(RollSection : String) : String;

{FXX01081998-3: Hardcode the roll section descriptions so they look nice.}

begin
  case RollSection[1] of
    '1' : Result := 'TAXABLE';
    '3' : Result := 'STATE LAND';
    '5' : Result := 'SPCL FRANCHISE';
    '6' : Result := 'UTILITY & R.R.';
    '7' : Result := 'CEILING RAILROAD';
    '8' : Result := 'WHOLLY EXEMPT';
    '9' : Result := 'OMITTED \ PRO-RATA';

  end;  {case RollSection[1] of}

end;  {GetRollSectionDescriptionForRollPrint}

{=======================================================================}
Procedure PrintGeneralTaxesOneRollSection(    Sender : TObject;
                                              RollType : Char;
                                              HomesteadCode : String;
                                              GeneralTotalsList,
                                              SpecialFeeTotalsList,
                                              SpecialFeeRateList,
                                              SDTotList,
                                              GeneralRateList,
                                              RollSectionDescList : TList;
                                              RollSection : String;
                                              PrintSDTax : Boolean;
                                          var HeaderPrinted,
                                              SubheaderPrinted : Boolean;
                                          var LineNo,
                                              PageNo : Integer;
                                              SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                              CollectionType : String;   {From here down is for printing the header.}
                                              RollPrintingYear : String;
                                              AssessmentYearCtlTable : TTable;
                                              SchoolCode,
                                              SwisCode : String;
                                              SchoolCodeDescList,
                                              SwisCodeDescList : TList;
                                              SequenceStr : String;
                                          var TotalTax : Extended);

{FXX04291998-4: Figure out the total tax for these roll sections, so make TotalTax
                a parameter.}

var
  FirstTaxPrinted : Boolean;
  TotalSDTax, TotalSpecialFees : Extended;
  TotalParcels, TotalParts, RollSectionPrintSize, HeaderSize : LongInt;
  I, TempNum : Integer;
  TempPtr : GeneralTotPtr;
  RollSectionDescription : String;
  SectionHeader : String;

begin
  TotalParcels := 0;
  TotalParts := 0;
  TotalTax := 0;
  TotalSpecialFees := 0;

  If CollectionHasSchoolTax
    then RollSectionPrintSize := 5 + (GeneralRateList.Count * 2) +
                                 SpecialFeeRateList.Count
    else RollSectionPrintSize := 5 + GeneralRateList.Count +
                                 SpecialFeeRateList.Count;

  HeaderSize := 6;

  If CollectionHasSchoolTax
    then HeaderSize := HeaderSize + 2;

    {FXX04291998-9: For swis and municipal totals, print that for the header.
                    For roll section totals, print the roll secion name.}

  SectionHeader := GetSectionHeader(SectionType, RollSection);

    {FXX08081999-2: Do a precheck to make sure there is enough space.}
    {FXX08232004-2(2.08.0.08302004): Fix up page breaks on the roll.}

  with Sender as TBaseReport do
    If ((NumLinesPerPage - LineNo - RollSectionPrintSize - HeaderSize) < LinesAtBottom)
      then
        begin
          StartNewPage(Sender, RollType,
                       SchoolCode, SwisCode,
                       SectionHeader,
                       CollectionType,
                       RollPrintingYear,
                       AssessmentYearCtlTable,
                       SchoolCodeDescList,
                       SwisCodeDescList,
                       SequenceStr,
                       PageNo, LineNo);

          HeaderPrinted := False;
          SubheaderPrinted := False;

        end;  {If (LinesLeft < 4)}

    {Print the lines that match the given roll section.}

  For I := 0 to (GeneralTotalsList.Count - 1) do
    If ((Deblank(RollSection) = '') or
        (GeneralTotPtr(GeneralTotalsList[I])^.RollSection = RollSection))
      then
        begin
          If not HeaderPrinted
            then
              begin
                PrintSectionHeader(Sender, 'G', RollSection, LineNo);
                HeaderPrinted := True;
              end;

          If not SubHeaderPrinted
            then
              begin
                PrintGeneralTaxRollSubheader(Sender, RollType, Take(1, HomesteadCode)[1],
                                             CollectionType, LineNo);
                SubheaderPrinted := True;
              end;

           {FXX01021998-16: Must break for roll section and show
                            totals.}

          PrintOneGeneralTax(Sender, RollType,
                             Take(1, HomesteadCode)[1],
                             CollectionType,
                             GeneralRateList,
                             GeneralTotPtr(GeneralTotalsList[I])^,
                             LineNo);

           {FXX01071998-8: Take the total number of parcels as the max of the
                           individual lines - don't add up all the tax lines.}

          TotalParcels := MaxInt(TotalParcels,
                                 GeneralTotPtr(GeneralTotalsList[I])^.ParcelCt);

          TotalParts := MaxInt(TotalParts,
                               GeneralTotPtr(GeneralTotalsList[I])^.PartCt);

          TotalTax := TotalTax +
                      GeneralTotPtr(GeneralTotalsList[I])^.TotalTax;

            {Do we need to go to a new page?}
            {FXX04231998-9: Instead of print the roll section hdr for
                            the totals sections, print the section type.}

          with Sender as TBaseReport do
            If ((NumLinesPerPage - LineNo - RollSectionPrintSize) < LinesAtBottom)
              then
                begin
                  StartNewPage(Sender, RollType,
                               SchoolCode, SwisCode,
                               SectionHeader,
                               CollectionType,
                               RollPrintingYear,
                               AssessmentYearCtlTable,
                               SchoolCodeDescList,
                               SwisCodeDescList,
                               SequenceStr,
                               PageNo, LineNo);

                  HeaderPrinted := False;
                  SubheaderPrinted := False;

                end;  {If (LinesLeft < 4)}

        end;  {For I := 0 to (GeneralTotalsList.Count - 1) do}

    {CHG08171999-1: Add in logic to print special fees, but only for overall totals.}

  If ((SpecialFeeTotalsList.Count > 0) and
      (Deblank(HomesteadCode) = ''))
    then
       For I := 0 to (SpecialFeeTotalsList.Count - 1) do
         If ((Deblank(RollSection) = '') or
             (SPFeeTotPtr(SpecialFeeTotalsList[I])^.RollSection = RollSection))
           then
             begin
               If not HeaderPrinted
                 then
                   begin
                     PrintSectionHeader(Sender, 'G', RollSection, LineNo);
                     HeaderPrinted := True;
                   end;

               If not SubHeaderPrinted
                 then
                   begin
                     PrintGeneralTaxRollSubheader(Sender, RollType, Take(1, HomesteadCode)[1],
                                                  CollectionType, LineNo);
                     SubheaderPrinted := True;
                   end;

                {FXX01021998-16: Must break for roll section and show
                                 totals.}

               PrintOneSpecialFeeTax(Sender, SpecialFeeRateList,
                                     SPFeeTotPtr(SpecialFeeTotalsList[I])^,
                                     LineNo);

               TotalSpecialFees := TotalSpecialFees +
                                   SPFeeTotPtr(SpecialFeeTotalsList[I])^.TotalTax;

                 {Do we need to go to a new page?}
                 {FXX04231998-9: Instead of print the roll section hdr for
                                 the totals sections, print the section type.}

               with Sender as TBaseReport do
                 If ((NumLinesPerPage - LineNo - RollSectionPrintSize) < LinesAtBottom)
                   then
                     begin
                       StartNewPage(Sender, RollType,
                                    SchoolCode, SwisCode,
                                    SectionHeader,
                                    CollectionType,
                                    RollPrintingYear,
                                    AssessmentYearCtlTable,
                                    SchoolCodeDescList,
                                    SwisCodeDescList,
                                    SequenceStr,
                                    PageNo, LineNo);

                       HeaderPrinted := False;
                       SubheaderPrinted := False;

                     end;  {If (LinesLeft < 4)}

             end;  {For I := 0 to (SpecialFeeTotalsList.Count - 1) do}

    {FXX06251998-11: If the page break was on the last tax item line, print
                     hdr and subheader before printing SD.}

  If ((RollType = 'X') and
      PrintSDTax)
    then
      begin
        If not HeaderPrinted
          then
            begin
              PrintSectionHeader(Sender, 'G', RollSection, LineNo);
              HeaderPrinted := True;
            end;

        If not SubHeaderPrinted
          then
            begin
              PrintGeneralTaxRollSubheader(Sender, RollType, Take(1, HomesteadCode)[1],
                                           CollectionType, LineNo);
              SubheaderPrinted := True;
            end;

      end;  {If ((RollType = 'X') and ...}

     {We printed out the individual details for this roll section
      (or combined roll section). Now, let's print out the SD tax
      if we need to.}
     {CHG01151998-1: Only print SD totals in gen tax for tax roll.}

    {FXX04241998-2: Move the reset or the tabs out of the SD line print
                    in case the SD amount is not printed.}

  with Sender as TBaseReport do
    begin
        {FXX01091998-2: Reset the tabs in case there was a page
                        break before the totals.}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Roll Section}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, TL4W, 0, BOXLINENONE, 0);   {Land AV}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {Total AV}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {Exempt amount}
      SetTab(TL7, pjRight, TL7W, 0, BOXLINENONE, 0);   {Taxable val}
      SetTab(TL8, pjRight, TL8W, 0, BOXLINENONE, 0);   {Tax rate}
      SetTab(TL9, pjRight, TL9W, 0, BOXLINENONE, 0);   {Total tax}

    end;  {with Sender as TBaseReport do}

  If ((RollType = 'X') and
      PrintSDTax)
    then
      begin
        TotalSDTax := GetSDTaxForRollSection(SDTotList, RollSection,
                                             SwisCode);

        TotalTax := TotalTax + TotalSDTax;

        with Sender as TBaseReport do
          Println(#9 + #9 + 'SP DIST TAXES'+
                  #9 + #9 + #9 + #9 + #9 + #9 +
                  #9 + FormatFloat(DecimalDisplay, TotalSDTax));

        LineNo := LineNo + 1;

      end;  {If PrintSDTax}

    {Now print an overall tax amount line.}

  If _Compare(RollType, 'X', coEqual)
    then
      with Sender as TBaseReport do
        begin
          If (Deblank(RollSection) = '')
            then Print(#9 + #9 + '* GRAND TOTAL *')
            else
              begin
                Print(#9 + RollSection);

                RollSectionDescription := GetRollSectionDescriptionForRollPrint(RollSection);

                Print(#9 + '* ' + RollSectionDescription);

              end;  {else of If (Deblank(RollSection) = '')}

          TotalTax := TotalTax + TotalSpecialFees;

          Println(#9 + IntToStr(TotalParcels - TotalParts) +
                  #9 + #9 + #9 + #9 + #9 +
                  #9 + FormatFloat(DecimalDisplay, TotalTax));

          LineNo := LineNo + 1;

        end;  {with Sender as TBaseReport do}

end;  {PrintGeneralTaxesOneRollSection}

{=======================================================================}
Procedure SortGeneralTaxTotals(GeneralTotalsList : TList);

{FXX07021998-3: Sort the general tax totals.}

var
  OldKey, NewKey : String;
  I, J : Integer;
  TempPtr : GeneralTotPtr;

begin
  For I := 0 to (GeneralTotalsList.Count - 1) do
    begin
      OldKey := GeneralTotPtr(GeneralTotalsList[I])^.RollSection;

      For J := (I + 1) to (GeneralTotalsList.Count - 1) do
        begin
          NewKey := GeneralTotPtr(GeneralTotalsList[J])^.RolLSection;

          If (NewKey < OldKey)
            then
              begin
                TempPtr := GeneralTotalsList[I];
                GeneralTotalsList[I] := GeneralTotalsList[J];
                GeneralTotalsList[J] := TempPtr;
                OldKey := NewKey;

              end;  {If (NewKey < OldKey)}

        end;  {For J := (I + 1) to (GeneralTotalsList.Count - 1) do}

    end;  {For I := 0 to (GeneralTotalsList.Count - 1) do}

end;  {SortGeneralTaxTotals}

{=======================================================================}
Procedure PrintGeneralTaxRollTotals(    Sender : TObject;  {Report printer or filer object}
                                        GeneralTotalsList,
                                        SpecialFeeTotalsList,
                                        SpecialFeeRateList,
                                        GeneralRateList,
                                        RollSectionDescList,
                                        SDTotList : TList;
                                        RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                        SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                        CollectionType : String;   {From here down is for printing the header.}
                                        RollPrintingYear : String;
                                        AssessmentYearCtlTable : TTable;
                                        SchoolCode,
                                        SwisCode : String;
                                        SchoolCodeDescList,
                                        SwisCodeDescList : TList;
                                        SequenceStr : String;
                                    var PageNo,
                                        LineNo : Integer;
                                    var TaxThisSection : Extended);

{Print the general totals in the TLists.}

var
  I : Integer;
  HstdGeneralTotalsList,
  NonhstdGeneralTotalsList,
  NoHstdBreakdownGeneralTotalsList,
  OverallGeneralTotalsList,
  OverallSpecialFeeTotalsList : TList;
  LastRollSection, RollSection : String;
  HeaderPrinted, SubheaderPrinted : Boolean;
  GeneralTotalsPtr : GeneralTotPtr;
  GeneralTaxType : String;
  SectionHeader : String;

begin
  HeaderPrinted := False;
  SubheaderPrinted := False;
  HstdGeneralTotalsList := TList.Create;
  NonhstdGeneralTotalsList := TList.Create;

    {FXX07021998-3: Sort the general tax totals.}

  SortGeneralTaxTotals(GeneralTotalsList);

  For I := 0 to (GeneralTotalsList.Count - 1) do
    with GeneralTotPtr(GeneralTotalsList[I])^ do
      begin
          {FXX01091998-6: Need to filter out relevies from hstd/non-hstd tots.}

        GeneralTaxType := GetGeneralTaxType(PrintOrder, GeneralRateList);

        If ((GeneralTaxType <> 'SR') and
            (GeneralTaxType <> 'VR'))
          then
            begin
              New(GeneralTotalsPtr);

              GeneralTotalsPtr^.SwisCode := SwisCode;
              GeneralTotalsPtr^.SchoolCode := SchoolCode;
              GeneralTotalsPtr^.RollSection := RollSection;
              GeneralTotalsPtr^.HomesteadCode := HomesteadCode;
              GeneralTotalsPtr^.PrintOrder := PrintOrder;
              GeneralTotalsPtr^.ParcelCt := ParcelCt;

                {FXX01091998-4: Not carrying part count forward.}

              GeneralTotalsPtr^.PartCt := PartCt;
              GeneralTotalsPtr^.LandAV := LandAV;
              GeneralTotalsPtr^.TotalAV := TotalAV;
              GeneralTotalsPtr^.ExemptAmt := ExemptAmt;
              GeneralTotalsPtr^.TaxableVal := TaxableVal;
              GeneralTotalsPtr^.TotalTax := TotalTax;

                {FXX11051998-3: Missing STAR fields here - was causing a floating
                                point error.}

              GeneralTotalsPtr^.STARAmount := STARAmount;
              GeneralTotalsPtr^.TaxableValAfterSTAR := TaxableValAfterSTAR;
              GeneralTotalsPtr^.STARSavings := STARSavings;

              If (HomesteadCode = 'N')
                then NonhstdGeneralTotalsList.Add(GeneralTotalsPtr)
                else HstdGeneralTotalsList.Add(GeneralTotalsPtr);

            end;  {If ((GeneralTaxType <> 'SR') and ...}

      end;  {with GeneralTotPtr(GeneralTotalsList[I])^ do}

  with Sender as TBaseReport do
    begin
        {First homestead part, but only if this is not a roll section summary.
         Note that we print the header and subheader only if there is an
         entry.}

        {FXX04231998-7: Don't print hstd/non-hstd if not classified.}
        {FXX04241998-3: Shouldn't have a "not" in front of GlblMunicipalityIsClassified.}

      If ((SectionType <> 'R') and
          GlblMunicipalityIsClassified)
        then
          begin
            If (HstdGeneralTotalsList.Count = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'H', RollSection, LineNo);
                  PrintGeneralTaxRollSubheader(Sender, RollType, 'N', CollectionType, LineNo);

                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TAX TOTALS AT THIS LEVEL');
                  Println('');
                  LineNo := LineNo + 3;
                end
              else
                begin
                    {FXX01021998-16: Must break for roll section and show
                                     totals.}

                  LastRollSection := '';

                   {FXX01081998-4: Don't need to compare homestead codes since
                                   already selected.}

                  For I := 0 to (HstdGeneralTotalsList.Count - 1) do
                    begin
                      RollSection := GeneralTotPtr(HstdGeneralTotalsList[I])^.RollSection;

                        {If we found another roll section in the totals,
                         print the last one.}

                      If (LastRollSection <> RollSection)
                        then
                          begin
                              {FXX01091998-3: Skip a line between roll sections.}

                            with Sender as TBaseReport do
                              Println('');
                            LineNo := LineNo + 1;

                              {FXX01091998-5: Need to set LastRollSection
                                              before printing.}

                            LastRollSection := GeneralTotPtr(HstdGeneralTotalsList[I])^.RollSection;

                            PrintGeneralTaxesOneRollSection(Sender, RollType, 'H',
                                                            HstdGeneralTotalsList,
                                                            SpecialFeeTotalsList,
                                                            SpecialFeeRateList,
                                                            SDTotList,
                                                            GeneralRateList,
                                                            RollSectionDescList,
                                                            LastRollSection,
                                                            False,
                                                            HeaderPrinted,
                                                            SubheaderPrinted,
                                                            LineNo,
                                                            PageNo,
                                                            SectionType,
                                                            CollectionType,
                                                            RollPrintingYear,
                                                            AssessmentYearCtlTable,
                                                            SchoolCode,
                                                            SwisCode,
                                                            SchoolCodeDescList,
                                                            SwisCodeDescList,
                                                            SequenceStr,
                                                            TaxThisSection);

                          end;  {If (LastRollSection <> RollSection)}

                    end;  {For I := 0 to (HstdGeneralTotalsList ...}

                    {Combine all the roll sections into one line per tax
                     type in order to print out the totals tax over
                     all roll sections.}

                  OverallGeneralTotalsList := TList.Create;
                  CombineGeneralTaxTotals(HstdGeneralTotalsList,
                                          OverallGeneralTotalsList, True,
                                          CollectionType);

                  Println('');
                  LineNo := LineNo + 1;

                    {FXX01111998-1: Was passing in the wrong list.}

                  PrintGeneralTaxesOneRollSection(Sender, RollType, 'H',
                                                  OverallGeneralTotalsList,
                                                  SpecialFeeTotalsList,
                                                  SpecialFeeRateList,
                                                  SDTotList,
                                                  GeneralRateList,
                                                  RollSectionDescList,
                                                  ' ',  {Blank rs means overall total.}
                                                  False,
                                                  HeaderPrinted,
                                                  SubheaderPrinted,
                                                  LineNo, PageNo,
                                                  SectionType,
                                                  CollectionType,
                                                  RollPrintingYear,
                                                  AssessmentYearCtlTable,
                                                  SchoolCode,
                                                  SwisCode,
                                                  SchoolCodeDescList,
                                                  SwisCodeDescList,
                                                  SequenceStr,
                                                  TaxThisSection);

                  FreeTList(OverallGeneralTotalsList, SizeOf(GeneralTotRecord));

                end;  {else of If (NumHomestead = 0)}

          end;  {If (SectionType <> 'R')}

        {Now the non-homestead part, if these are not roll section totals.}
        {FXX04291998-1: Don't print non-hstd if not classified.}

      If ((SectionType <> 'R') and
          GlblMunicipalityIsClassified)
        then
          begin
            SubheaderPrinted := False;

            If (NonhstdGeneralTotalsList.Count = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'N', RollSection, LineNo);
                  PrintGeneralTaxRollSubheader(Sender, RollType, 'N', CollectionType, LineNo);

                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TAX TOTALS AT THIS LEVEL');
                  Println('');
                  LineNo := LineNo + 3;
                end
              else
                begin
                    {FXX01021998-16: Must break for roll section and show
                                     totals.}

                  LastRollSection := '';

                   {FXX01081998-4: Don't need to compare homestead codes since
                                   already selected.}

                  For I := 0 to (NonhstdGeneralTotalsList.Count - 1) do
                    begin
                      RollSection := GeneralTotPtr(NonhstdGeneralTotalsList[I])^.RollSection;

                        {If we found another roll section in the totals,
                         print the last one.}

                      If (LastRollSection <> RollSection)
                        then
                          begin
                              {FXX01091998-3: Skip a line between roll sections.}

                            with Sender as TBaseReport do
                              Println('');
                            LineNo := LineNo + 1;

                              {FXX01091998-5: Need to set LastRollSection
                                              before printing.}

                            LastRollSection := GeneralTotPtr(NonHstdGeneralTotalsList[I])^.RollSection;

                            PrintGeneralTaxesOneRollSection(Sender, RollType, 'N',
                                                            NonhstdGeneralTotalsList,
                                                            SpecialFeeTotalsList,
                                                            SpecialFeeRateList,
                                                            SDTotList,
                                                            GeneralRateList,
                                                            RollSectionDescList,
                                                            LastRollSection,
                                                            False,
                                                            HeaderPrinted,
                                                            SubheaderPrinted,
                                                            LineNo, PageNo,
                                                            SectionType,
                                                            CollectionType,
                                                            RollPrintingYear,
                                                            AssessmentYearCtlTable,
                                                            SchoolCode,
                                                            SwisCode,
                                                            SchoolCodeDescList,
                                                            SwisCodeDescList,
                                                            SequenceStr,
                                                            TaxThisSection);

                          end;  {If (LastRollSection <> RollSection)}

                    end;  {For I := 0 to (NonhstdGeneralTotalsList.Count - 1) do}

                    {Combine all the roll sections into one line per tax
                     type in order to print out the totals tax over
                     all roll sections.}

                  OverallGeneralTotalsList := TList.Create;
                  CombineGeneralTaxTotals(NonhstdGeneralTotalsList,
                                          OverallGeneralTotalsList, True,
                                          CollectionType);

                  Println('');
                  LineNo := LineNo + 1;

                    {FXX01111998-1: Was passing in the wrong list.}

                  PrintGeneralTaxesOneRollSection(Sender, RollType, 'N',
                                                  OverallGeneralTotalsList,
                                                  SpecialFeeTotalsList,
                                                  SpecialFeeRateList,
                                                  SDTotList,
                                                  GeneralRateList,
                                                  RollSectionDescList,
                                                  ' ',  {Blank rs means overall total.}
                                                  False,
                                                  HeaderPrinted,
                                                  SubheaderPrinted,
                                                  LineNo, PageNo,
                                                  SectionType,
                                                  CollectionType,
                                                  RollPrintingYear,
                                                  AssessmentYearCtlTable,
                                                  SchoolCode,
                                                  SwisCode,
                                                  SchoolCodeDescList,
                                                  SwisCodeDescList,
                                                  SequenceStr,
                                                  TaxThisSection);

                  FreeTList(OverallGeneralTotalsList, SizeOf(GeneralTotRecord));

                end;  {else of If (NumHomestead = 0)}

          end;  {If (SectionType <> 'R')}

        {Finally, do the overall totals.}

      SubheaderPrinted := False;

      NoHstdBreakdownGeneralTotalsList := TList.Create;
      CombineGeneralTaxTotals(GeneralTotalsList,
                              NoHstdBreakdownGeneralTotalsList, False,
                              CollectionType);

        {FXX07021998-3: Sort the general tax totals.}

      SortGeneralTaxTotals(GeneralTotalsList);

      If (NoHstdBreakdownGeneralTotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'H', RollSection, LineNo);
            PrintGeneralTaxRollSubheader(Sender, RollType, 'N', CollectionType, LineNo);

            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO TAX TOTALS AT THIS LEVEL');
            Println('');
            LineNo := LineNo + 3;
          end
        else
          begin
            LastRollSection := '';

              {FXX01021998-16: Must break for roll section and show
                               totals.}

              {FXX01081998-4: Don't need to compare homestead codes since
                              already selected.}

            For I := 0 to (NoHstdBreakdownGeneralTotalsList.Count - 1) do
              begin
                RollSection := GeneralTotPtr(NoHstdBreakdownGeneralTotalsList[I])^.RollSection;

                  {If we found another roll section in the totals,
                   or this is the last one, print the last one.}

                If (LastRollSection <> RollSection)
                  then
                    begin
                        {FXX01091998-3: Skip a line between roll sections.}

                      with Sender as TBaseReport do
                        Println('');
                      LineNo := LineNo + 1;

                        {FXX01091998-5: Need to set LastRollSection
                                        before printing.}

                      LastRollSection := GeneralTotPtr(NoHstdBreakdownGeneralTotalsList[I])^.RollSection;

                      OverallSpecialFeeTotalsList := TList.Create;
                      CombineSpecialFeeTotals(SpecialFeeTotalsList,
                                              OverallSpecialFeeTotalsList,
                                              LastRollSection, SchoolCode, SwisCode,
                                              False, True, True);

                      PrintGeneralTaxesOneRollSection(Sender, RollType, ' ',
                                                      NoHstdBreakdownGeneralTotalsList,
                                                      OverallSpecialFeeTotalsList,
                                                      SpecialFeeRateList,
                                                      SDTotList,
                                                      GeneralRateList,
                                                      RollSectionDescList,
                                                      LastRollSection,
                                                      True,
                                                      HeaderPrinted,
                                                      SubheaderPrinted,
                                                      LineNo, PageNo,
                                                      SectionType,
                                                      CollectionType,
                                                      RollPrintingYear,
                                                      AssessmentYearCtlTable,
                                                      SchoolCode,
                                                      SwisCode,
                                                      SchoolCodeDescList,
                                                      SwisCodeDescList,
                                                      SequenceStr,
                                                      TaxThisSection);

                      LastRollSection := GeneralTotPtr(NoHstdBreakdownGeneralTotalsList[I])^.RollSection;

                      FreeTList(OverallSpecialFeeTotalsList, SizeOf(SPFeeTotRecord));

                    end;  {If (LastRollSection <> RollSection)}

              end;  {For I := 0 to (NoHstdBreakdownGeneralTotalsList ...}

              {Combine all the roll sections into one line per tax
               type in order to print out the totals tax over
               all roll sections.}

            If (SectionType <> 'R')
              then
                begin
                  OverallGeneralTotalsList := TList.Create;
                  CombineGeneralTaxTotals(NoHstdBreakdownGeneralTotalsList,
                                          OverallGeneralTotalsList, True,
                                          CollectionType);

                  OverallSpecialFeeTotalsList := TList.Create;
                  CombineSpecialFeeTotals(SpecialFeeTotalsList,
                                          OverallSpecialFeeTotalsList,
                                          ' ', SchoolCode, SwisCode,
                                          True, True, True);

                  Println('');
                  LineNo := LineNo + 1;

                  PrintGeneralTaxesOneRollSection(Sender, RollType, ' ',
                                                  OverallGeneralTotalsList,
                                                  OverallSpecialFeeTotalsList,
                                                  SpecialFeeRateList,
                                                  SDTotList,
                                                  GeneralRateList,
                                                  RollSectionDescList,
                                                  ' ',  {Blank rs means overall total.}
                                                  True,
                                                  HeaderPrinted,
                                                  SubheaderPrinted,
                                                  LineNo, PageNo,
                                                  SectionType,
                                                  CollectionType,
                                                  RollPrintingYear,
                                                  AssessmentYearCtlTable,
                                                  SchoolCode,
                                                  SwisCode,
                                                  SchoolCodeDescList,
                                                  SwisCodeDescList,
                                                  SequenceStr,
                                                  TaxThisSection);

                  FreeTList(OverallGeneralTotalsList, SizeOf(GeneralTotRecord));
                  FreeTList(OverallSpecialFeeTotalsList, SizeOf(SPFeeTotRecord));

                end;  {If (RollType <> 'R')}

          end;  {else of If (NumHomestead = 0)}

    end;  {with Sender as TBaseReport do}

  FreeTList(HstdGeneralTotalsList, SizeOf(GeneralTotRecord));
  FreeTList(NonhstdGeneralTotalsList, SizeOf(GeneralTotRecord));
  FreeTList(NoHstdBreakdownGeneralTotalsList, SizeOf(GeneralTotRecord));

end;  {PrintGeneralTaxRollTotals}

{=======================================================================}
        {Print General Totals For Assessment rolls}
{=======================================================================}
Function FoundGeneralAssessmentTotalRecord(    GeneralTotalsList : TList;
                                               _RollSection,
                                               _HomesteadCode : String;
                                           var I : Integer) : Boolean;

{Search through the totals list for this print order, roll section,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

  For J := 0 to (GeneralTotalsList.Count - 1) do
    with GeneralAssessmentTotPtr(GeneralTotalsList[J])^ do
      If ((Take(1, RollSection) = Take(1, _RollSection)) and
          (Take(1, HomesteadCode) = Take(1, _HomesteadCode)))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundGeneralAssessmentTotalRecord}

{=======================================================================}
Procedure LoadGeneralAssessmentTotals(    GeneralTotalsTable : TTable;
                                          CollectionType : String;  {SC, MU, CO, VI}
                                          GeneralTotalsList : TList;  {Broken up by homestead and non-homestead.}
                                          SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                          RollSection : String;
                                          SwisCode,
                                          SchoolCode : String;
                                          SelectedRollSections : TStringList;
                                      var Quit : Boolean);

{Load all the General assessment totals for this roll section, swis code, school code,
 (or all for grand totals) into two TLists which have General amounts.
 One for homestead and one for non-homestead. If this is not a classified
 municipality, the totals will go in the homestead list.}

var
  FirstTimeThrough, Done : Boolean;
  GeneralTotalsPtr : GeneralAssessmentTotPtr;
  I : Integer;

begin
  Done := False;
  FirstTimeThrough := True;

    {FXX01221998-1: Make sure to cancel the range so that no range is
                    left on for grand totals.}

  GeneralTotalsTable.CancelRange;

  If (SectionType in ['S', 'G'])
    then RollSection := '';

  If (SectionType = 'G')
    then
      begin
        SwisCode := '';
        SchoolCode := '';
      end;

    {Set the index and range of the General table for this collection type.}

  with GeneralTotalsTable do
    If (CollectionHasSchoolTax and
        (CollectionType = 'SC'))
      then
        begin
          IndexName := 'BYSCHOOLCODE_RS_HC';

          case SectionType of
            'R' : SetRangeOld(GeneralTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode'],
                              [SchoolCode, SwisCode, RollSection, ' '],
                              [SchoolCode, SwisCode, RollSection, 'Z']);

            'S' : SetRangeOld(GeneralTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode'],
                              [SchoolCode, SwisCode, '1', ' '],
                              [SchoolCode, SwisCode, '9', 'Z']);

            'C' : SetRangeOld(GeneralTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode'],
                              [SchoolCode, '      ', '1', ' '],
                              [SchoolCode, '999999', '9', 'Z']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

        end
      else
        begin
          IndexName := 'BYSWISCODE_RS_HC';

          case SectionType of
            'R' : SetRangeOld(GeneralTotalsTable,
                              ['SwisCode', 'RollSection', 'HomesteadCode'],
                              [SwisCode, RollSection, ' '],
                              [SwisCode, RollSection, 'Z']);
            'S' : SetRangeOld(GeneralTotalsTable,
                              ['SwisCode', 'RollSection', 'HomesteadCode'],
                              [SwisCode, '1', ' '],
                              [SwisCode, '9', 'Z']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

        end;  {else of If CollectionHasSchoolTax}

  try
    GeneralTotalsTable.First;
  except
    Quit := True;
    SystemSupport(800, GeneralTotalsTable, 'Error getting first General totals record.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          GeneralTotalsTable.Next;
        except
          Quit := True;
          SystemSupport(800, GeneralTotalsTable, 'Error getting next General totals record.',
                        'UTILBILL.PAS', GlblErrorDlgBox);
        end;

    If GeneralTotalsTable.EOF
      then Done := True;

    {FXX04241998-1: Only load the roll sections that we want in this section
                    of the roll.}

    If not Done
      then
        If (SelectedRollSections.IndexOf(GeneralTotalsTable.FieldByName('RollSection').Text) <> -1)
          then
            with GeneralTotalsTable do
              If FoundGeneralAssessmentTotalRecord(GeneralTotalsList,
                                                   FieldByName('RollSection').Text,
                                                   FieldByName('HomesteadCode').Text, I)
                then
                  begin
                    with GeneralAssessmentTotPtr(GeneralTotalsList[I])^ do
                      begin
                        ParcelCt := ParcelCt + FieldByName('ParcelCt').AsInteger;

                           {FXX01191998-10: Track split count.}

                        PartCt := PartCt + FieldByName('SplitParcelCt').AsInteger;
                        LandAV := LandAV + FieldByName('LandAV').AsFloat;
                        TotalAV := TotalAV + FieldByName('TotalAV').AsFloat;
                        CountyTaxableVal := CountyTaxableVal + FieldByName('CountyTaxableVal').AsFloat;
                        TownTaxableVal := TownTaxableVal + FieldByName('TownTaxableVal').AsFloat;
                        SchoolTaxableVal := SchoolTaxableVal + FieldByName('SchoolTaxableVal').AsFloat;
                        VillageTaxableVal := VillageTaxableVal + FieldByName('VillageTaxableVal').AsFloat;

                          {FXX05061998-3: Save the STAR amounts for school billings.}

                        STARAmount := STARAmount + FieldByName('STARAmount').AsFloat;
                        TaxableValAfterSTAR := TaxableValAfterSTAR +
                                               FieldByName('TaxableValAfterSTAR').AsFloat;

                      end;  {with GeneralistTotPtr(GeneralTotalsList[I])^ do}

                  end
                else
                  begin
                    New(GeneralTotalsPtr);   {get new pptr for tlist array}

                    with GeneralTotalsPtr^ do
                      begin
                        SwisCode := FieldByName('SwisCode').Text;
                        SchoolCode := FieldByName('SchoolCode').Text;
                        RollSection := FieldByName('RollSection').Text;
                        HomesteadCode := FieldByName('HomesteadCode').Text;
                        ParcelCt := FieldByName('ParcelCt').AsInteger;
                        LandAV := FieldByName('LandAV').AsFloat;
                        TotalAV := FieldByName('TotalAV').AsFloat;
                        CountyTaxableVal := FieldByName('CountyTaxableVal').AsFloat;
                        TownTaxableVal := FieldByName('TownTaxableVal').AsFloat;
                        SchoolTaxableVal := FieldByName('SchoolTaxableVal').AsFloat;
                        VillageTaxableVal := FieldByName('VillageTaxableVal').AsFloat;

                           {FXX01191998-10: Track split count.}

                        PartCt := FieldByName('SplitParcelCt').AsInteger;

                          {FXX05061998-3: Save the STAR amounts for school billings.}

                        STARAmount := FieldByName('STARAmount').AsFloat;
                        TaxableValAfterSTAR := FieldByName('TaxableValAfterSTAR').AsFloat;

                      end;  {with GeneralTotalsPtr^ do}

                    GeneralTotalsList.Add(GeneralTotalsPtr);

                  end;  {else of If FoundGeneralRecord(GeneralTotalsList,}

  until (Done or Quit);

end;  {LoadGeneralAssessmentTotals}

{=======================================================================}
Procedure CombineGeneralAssessmentTotals(GeneralTotalsList,  {List with totals broken down into hstd, nonhstd.}
                                         OverallTotalsList : TList);  {No hstd\nonhstd breakdown.}

{The totals entries in the GeneralTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the GeneralTotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  GeneralTotalsPtr : GeneralAssessmentTotPtr;

begin
  For I := 0 to (GeneralTotalsList.Count - 1) do
    with GeneralAssessmentTotPtr(GeneralTotalsList[I])^ do
      If FoundGeneralAssessmentTotalRecord(OverallTotalsList, RollSection,
                                           ' ', J)  {Don't use hstd code as a key.}
        then
          begin
            GeneralAssessmentTotPtr(OverallTotalsList[J])^.ParcelCt :=
                     GeneralAssessmentTotPtr(OverallTotalsList[J])^.ParcelCt + ParcelCt;
            GeneralAssessmentTotPtr(OverallTotalsList[J])^.LandAV :=
                     GeneralAssessmentTotPtr(OverallTotalsList[J])^.LandAV + LandAV;
            GeneralAssessmentTotPtr(OverallTotalsList[J])^.TotalAV :=
                     GeneralAssessmentTotPtr(OverallTotalsList[J])^.TotalAV + TotalAV;
            GeneralAssessmentTotPtr(OverallTotalsList[J])^.CountyTaxableVal :=
                     GeneralAssessmentTotPtr(OverallTotalsList[J])^.CountyTaxableVal + CountyTaxableVal;
            GeneralAssessmentTotPtr(OverallTotalsList[J])^.TownTaxableVal :=
                     GeneralAssessmentTotPtr(OverallTotalsList[J])^.TownTaxableVal + TownTaxableVal;
            GeneralAssessmentTotPtr(OverallTotalsList[J])^.SchoolTaxableVal :=
                     GeneralAssessmentTotPtr(OverallTotalsList[J])^.SchoolTaxableVal + SchoolTaxableVal;
            GeneralAssessmentTotPtr(OverallTotalsList[J])^.VillageTaxableVal :=
                     GeneralAssessmentTotPtr(OverallTotalsList[J])^.VillageTaxableVal + VillageTaxableVal;

                     {FXX05061998-3: Save the STAR amounts for school billings.}

            GeneralAssessmentTotPtr(OverallTotalsList[J])^.TaxableValAfterSTAR :=
                     GeneralAssessmentTotPtr(OverallTotalsList[J])^.TaxableValAfterSTAR +
                     TaxableValAfterSTAR;
            GeneralAssessmentTotPtr(OverallTotalsList[J])^.STARAmount :=
                     GeneralAssessmentTotPtr(OverallTotalsList[J])^.STARAmount +
                     STARAmount;

          end
        else
          begin
            New(GeneralTotalsPtr);   {get new pptr for tlist array}

            GeneralTotalsPtr^.SwisCode := SwisCode;
            GeneralTotalsPtr^.SchoolCode := SchoolCode;
            GeneralTotalsPtr^.RollSection := RollSection;
            GeneralTotalsPtr^.HomesteadCode := ' ';  {Blank out hstd code.}
            GeneralTotalsPtr^.LandAV := LandAV;
            GeneralTotalsPtr^.TotalAV := TotalAV;
            GeneralTotalsPtr^.ParcelCt := ParcelCt;
            GeneralTotalsPtr^.PartCt := PartCt;
            GeneralTotalsPtr^.CountyTaxableVal := CountyTaxableVal;
            GeneralTotalsPtr^.TownTaxableVal := TownTaxableVal;
            GeneralTotalsPtr^.SchoolTaxableVal := SchoolTaxableVal;
            GeneralTotalsPtr^.VillageTaxableVal := VillageTaxableVal;

              {FXX05061998-3: Save the STAR amounts for school billings.}

            GeneralTotalsPtr^.STARAmount := STARAmount;
            GeneralTotalsPtr^.TaxableValAfterSTAR := TaxableValAfterSTAR;

            OverallTotalsList.Add(GeneralTotalsPtr);

          end;  {else of If FoundGeneralRecord(OverallTotalsList, GeneralCode, ExtCode, CMFlag,}

end;  {CombineGeneralTotals}

{======================================================================}
Procedure UpdateGeneralAssessmentTotals(    SourceGeneralTotalsRec : GeneralAssessmentTotRecord;
                                        var TempGeneralTotalRec : GeneralAssessmentTotRecord);

{Update the running totals in the TempGeneralTotalRec from the source
 rec.}

begin
  with TempGeneralTotalRec do
    begin
      ParcelCt := ParcelCt + SourceGeneralTotalsRec.ParcelCt;
      PartCt := PartCt + SourceGeneralTotalsRec.PartCt;
      LandAV := LandAv + SourceGeneralTotalsRec.LandAV;
      TotalAV := TotalAV + SourceGeneralTotalsRec.TotalAV;
      CountyTaxableVal := CountyTaxableVal + SourceGeneralTotalsRec.CountyTaxableVal;
      TownTaxableVal := TownTaxableVal + SourceGeneralTotalsRec.TownTaxableVal;
      SchoolTaxableVal := SchoolTaxableVal + SourceGeneralTotalsRec.SchoolTaxableVal;
      VillageTaxableVal := VillageTaxableVal + SourceGeneralTotalsRec.VillageTaxableVal;

        {FXX05061998-3: Save the STAR amounts for school billings.}

      STARAmount := STARAmount + SourceGeneralTotalsRec.STARAmount;
      TaxableValAfterSTAR := TaxableValAfterSTAR +
                             SourceGeneralTotalsRec.TaxableValAfterSTAR;

    end;  {with TempGeneralTotalRec do}

end;  {UpdateGeneralAssessmentTotals}

{=======================================================================}
Procedure PrintGeneralAssessmentSubheader(    Sender : TObject;  {Report printer or filer object}
                                              SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                              CollectionType : String;   {From here down is for printing the header.}
                                          var LineNo : Integer);

{Print the individual General assessment totals section header and set the tabs for the
 General amounts columns.}

var
  TempStr : String;

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hstd\nonhstd.}

      If (SubheaderType <> 'R')
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Roll Section}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjCenter, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjCenter, TL4W, 0, BOXLINENONE, 0);   {Land AV}
      SetTab(TL5, pjCenter, TL5W, 0, BOXLINENONE, 0);   {Total AV}
      SetTab(TL6, pjCenter, TL6W, 0, BOXLINENONE, 0);   {Exempt amount}
      SetTab(TL7, pjCenter, TL7W, 0, BOXLINENONE, 0);   {County Taxable}
      SetTab(TL8, pjCenter, TL8W, 0, BOXLINENONE, 0);   {City Taxable}
      SetTab(TL9, pjCenter, TL9W, 0, BOXLINENONE, 0);   {School Taxable}

      If (GlblMunicipalityType = MTCity)
        then TempStr := 'CITY'
        else
          If (GlblMunicipalityType = MTVillage)
            then TempStr := 'VILL'
            else TempStr := 'TOWN';

      Println('');
      LineNo := LineNo + 1;

        {FXX05271998-3: Print STAR amounts in last two columns for school
                        assessment roll.}

      If CollectionHasSchoolTax
        then
          begin
            Println(#9 +'ROLL' +
                    #9 +
                    #9 + 'TOTAL' +
                    #9 + 'ASSESSED' +
                    #9 + 'ASSESSED' +
                    #9 + 'EXEMPT' +
                    #9 + 'TOTAL' +
                    #9 + 'STAR' +
                    #9 + 'STAR');
            Println(#9 + 'SEC' +
                    #9 + 'DESCRIPTION' +
                    #9 + 'PARCELS' +
                    #9 + 'LAND' +
                    #9 + 'TOTAL' +
                    #9 + 'AMOUNT' +
                    #9 + 'TAXABLE' +
                    #9 + 'AMOUNT' +
                    #9 + 'TAXABLE');
          end
        else
          begin
              {FXX06021998-3: County\town\schl hdr too far right.}
              {CHG10302000-1: Need to allow user to specify exactly which municipalities
                              print on the roll.}


            Print(#9 +'ROLL' +
                  #9 +
                  #9 + 'TOTAL' +
                  #9 + 'ASSESSED' +
                  #9 + 'ASSESSED');

            If (mtpCounty in MunicipalitiesToPrint)
              then Print(#9 + 'COUNTY')
              else Print(#9);

              {FXX04232009-10(4.20.1.1)[D1491]: The school total was printing in the wrong column for
                                                a school only roll.}

            If (mtpTown in MunicipalitiesToPrint)
              then Print(#9 + TempStr);

            If (mtpSchool in MunicipalitiesToPrint)
              then Println(#9 + 'SCHOOL' +
                           #9 + 'SCHOOL')
              else Println('');

            Print(#9 + 'SEC' +
                  #9 + 'DESCRIPTION' +
                  #9 + 'PARCELS' +
                  #9 + 'LAND' +
                  #9 + 'TOTAL');

            If (mtpCounty in MunicipalitiesToPrint)
              then Print(#9 + 'TAXABLE')
              else Print(#9);

            If (mtpTown in MunicipalitiesToPrint)
              then Print(#9 + 'TAXABLE');

            If (mtpSchool in MunicipalitiesToPrint)
              then Println(#9 + 'TAXABLE' +
                           #9 + 'AFTER STAR')
              else Println('');

          end;  {else of If CollectionHasSchoolTax}

        LineNo := LineNo + 2;

         {If this is a homestead or nonhomestead section,
          print that this is the total number of parcels and parts.}

       If (SubheaderType in ['H', 'N'])
         then
           begin
             Println(#9 + #9 + #9 + '& PARTS');
             LineNo := LineNo + 1;
           end;

       {FXX12291997-2: Print a blank line between the header and the start
                       of the information.}

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintGeneralAssessmentSubheader}

{=======================================================================}
Procedure PrintOneGeneralAssessmentTotal(    Sender : TObject;  {Report printer or filer object}
                                             RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                             SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                             CollectionType : String;
                                             GeneralTotalsRec : GeneralAssessmentTotRecord;
                                             RollSectionList : TList;
                                             IsTotalRecord : Boolean;  {Is this a 'TOTAL' line?}
                                         var LineNo : Integer);

{Print one general assessment total.}

var
  RollSectionDescription : String;

begin
  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Roll Section}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, TL4W, 0, BOXLINENONE, 0);   {Land AV}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {Total AV}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {Exempt amount - skip}
      SetTab(TL7, pjRight, TL7W, 0, BOXLINENONE, 0);   {County Taxable val}
      SetTab(TL8, pjRight, TL8W, 0, BOXLINENONE, 0);   {City taxable val}
      SetTab(TL9, pjRight, TL9W, 0, BOXLINENONE, 0);   {School taxable val}

      with GeneralTotalsRec do
        begin
          RollSectionDescription := GetRollSectionDescriptionForRollPrint(RollSection);

          If IsTotalRecord
            then Print(#9 + #9 + '** GRAND TOTAL')
            else Print(#9 + RollSection +
                       #9 + RollSectionDescription);

            {FXX01191998-10: Track split count.}

          If (SubheaderType in ['H', 'N'])
            then Print(#9 + IntToStr(ParcelCt))
            else Print(#9 + IntToStr(ParcelCt - PartCt));

          If (Roundoff(LandAV, 2) > 0)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, LandAV))
            else Print(#9);

          If (Roundoff(TotalAV, 2) > 0)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalAV))
            else Print(#9);

            {FXX05271998-3: Print STAR amounts in last two columns for school
                            assessment roll.}
            {CHG10302000-1: Need to allow user to specify exactly which municipalities
                            print on the roll.}

          If CollectionHasSchoolTax
            then
              begin
                Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                       (TotalAV - SchoolTaxableVal)));
                Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, SchoolTaxableVal));
                Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, STARAmount));
                Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, TaxableValAfterSTAR));
              end
            else
              begin
                If (mtpCounty in MunicipalitiesToPrint)
                   then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, CountyTaxableVal));

                If (mtpTown in MunicipalitiesToPrint)
                   then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, TownTaxableVal))
                   else
                     If (mtpPartialVillage in MunicipalitiesToPrint)
                       then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, VillageTaxableVal))
                       else Print(#9);

                If (mtpSchool in MunicipalitiesToPrint)
                   then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, SchoolTaxableVal));

                   {FXX06021998-4: Print STAR tax val even in munic roll.}

                If (mtpSchool in MunicipalitiesToPrint)
                  then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, TaxableValAfterSTAR));

              end;  {If CollectionHasSchoolTax}

          Println('');

        end;  {with GeneralTotalsRec do}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintOneGeneralAssessmentTotal}

{=======================================================================}
Procedure PrintGeneralAssessmentRollTotals(    Sender : TObject;  {Report printer or filer object}
                                               GeneralTotalsList,
                                               RollSectionList : TList;
                                               RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                               SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                               CollectionType : String;   {From here down is for printing the header.}
                                               RollPrintingYear : String;
                                               AssessmentYearCtlTable : TTable;
                                               SchoolCode,
                                               SwisCode : String;
                                               RollSection : String;
                                               SchoolCodeDescList,
                                               SwisCodeDescList : TList;
                                               SequenceStr : String;
                                           var PageNo,
                                               LineNo : Integer);

{Print the general totals in the TLists.}

var
  I, NumHomestead, NumNonhomestead : Integer;
  HeaderPrinted, SubheaderPrinted : Boolean;
  OverallGeneralTotalsList : TList;
  TempGeneralTotalRec : GeneralAssessmentTotRecord;  {For an overall total for this section.}
  SectionHeader : String;

begin
  HeaderPrinted := False;
  NumHomestead := 0;
  NumNonhomestead := 0;

  For I := 0 to (GeneralTotalsList.Count - 1) do
    with GeneralAssessmentTotPtr(GeneralTotalsList[I])^ do
      If (HomesteadCode = 'N')
        then NumNonhomestead := NumNonhomestead + 1
        else NumHomestead := NumHomestead + 1;

    {FXX04291998-9: For swis and municipal totals, print that for the header.
                    For roll section totals, print the roll secion name.}

  SectionHeader := GetSectionHeader(SectionType, RollSection);

  with Sender as TBaseReport do
    begin
        {First homestead part, but only if this is not a roll section summary.
         Note that we print the header and subheader only if there is an
         entry.}

        {FXX04231998-7: Don't print hstd/non-hstd if not classified.}
        {FXX04241998-3: Shouldn't have a "not" in front of GlblMunicipalityIsClassified.}

      If ((SectionType <> 'R') and
          GlblMunicipalityIsClassified)
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempGeneralTotalRec do
              begin
                  {FXX01221998-2: I forgot to initialize PartCt.}
                PartCt := 0;
                ParcelCt := 0;
                LandAV := 0;
                TotalAV := 0;
                CountyTaxableVal := 0;
                TownTaxableVal := 0;
                SchoolTaxableVal := 0;
                VillageTaxableVal := 0;

                  {FXX05271998-4: Initialize STAR fields.}

                STARAmount := 0;
                TaxableValAfterSTAR := 0;

              end;  {with TempGeneralTotalRec do}

            If (NumHomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'H', RollSection, LineNo);
                  PrintGeneralAssessmentSubheader(Sender, 'N',
                                                  CollectionType, LineNo);

                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TAX TOTALS AT THIS LEVEL');
                  Println('');
                  LineNo := LineNo + 3;
                end
              else
                begin
                  For I := 0 to (GeneralTotalsList.Count - 1) do
                    If (GeneralAssessmentTotPtr(GeneralTotalsList[I])^.HomesteadCode[1] in ['H', ' '])
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'G', RollSection, LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintGeneralAssessmentSubheader(Sender, 'H',
                                                                CollectionType, LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneGeneralAssessmentTotal(Sender, RollType, 'H',
                                                         CollectionType,
                                                         GeneralAssessmentTotPtr(GeneralTotalsList[I])^,
                                                         RollSectionList,
                                                         False, LineNo);

                            {Do we need to go to a new page?}
                            {FXX04231998-9: Instead of print the roll section hdr for
                                            the totals sections, print the section type.}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, RollType,
                                             SchoolCode, SwisCode,
                                             SectionHeader,
                                             CollectionType,
                                             RollPrintingYear,
                                             AssessmentYearCtlTable,
                                             SchoolCodeDescList,
                                             SwisCodeDescList,
                                             SequenceStr,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateGeneralAssessmentTotals(GeneralAssessmentTotPtr(GeneralTotalsList[I])^,
                                                        TempGeneralTotalRec);

                        end;  {If (GeneralTotPtr(GeneralTotalsList[I])^.HomesteadCode in ['H', ' '])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'G', RollSection, LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintGeneralAssessmentSubheader(Sender, 'H',
                                                         CollectionType, LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  LineNo := LineNo + 1;
                  PrintOneGeneralAssessmentTotal(Sender, RollType, 'H',
                                                 CollectionType,
                                                 TempGeneralTotalRec,
                                                 RollSectionList,
                                                 True, LineNo);

                end;  {else of If (NumHomestead = 0)}

          end;  {If (SectionType <> 'R')}

        {Now the non-homestead part, if these are not roll section totals.}
        {FXX04291998-1: Don't print non-hstd if not classified.}

      If ((SectionType <> 'R') and
          GlblMunicipalityIsClassified)
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempGeneralTotalRec do
              begin
                  {FXX01221998-2: I forgot to initialize PartCt.}
                PartCt := 0;
                ParcelCt := 0;
                LandAV := 0;
                TotalAV := 0;
                CountyTaxableVal := 0;
                TownTaxableVal := 0;
                SchoolTaxableVal := 0;
                VillageTaxableVal := 0;

                  {FXX05271998-4: Initialize STAR fields.}

                STARAmount := 0;
                TaxableValAfterSTAR := 0;

              end;  {with TempGeneralTotalRec do}

            If (NumNonhomestead = 0)
              then
                begin
                  PrintSectionHeader(Sender, 'G', RollSection, LineNo);
                  PrintGeneralAssessmentSubheader(Sender, 'N',
                                                  CollectionType, LineNo);
                  Println('');
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TAX TOTALS AT THIS LEVEL');
                  Println('');
                  LineNo := LineNo + 3;
                end
              else
                begin
                  For I := 0 to (GeneralTotalsList.Count - 1) do
                    If (GeneralAssessmentTotPtr(GeneralTotalsList[I])^.HomesteadCode[1] = 'N')
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'G', RollSection, LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintGeneralAssessmentSubheader(Sender, 'N',
                                                                CollectionType, LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneGeneralAssessmentTotal(Sender, RollType, 'N',
                                                         CollectionType,
                                                         GeneralAssessmentTotPtr(GeneralTotalsList[I])^,
                                                         RollSectionList,
                                                         False, LineNo);

                            {Do we need to go to a new page?}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, RollType,
                                             SchoolCode, SwisCode,
                                             SectionHeader,
                                             CollectionType,
                                             RollPrintingYear,
                                             AssessmentYearCtlTable,
                                             SchoolCodeDescList,
                                             SwisCodeDescList,
                                             SequenceStr,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateGeneralAssessmentTotals(GeneralAssessmentTotPtr(GeneralTotalsList[I])^,
                                                        TempGeneralTotalRec);

                        end;  {If (GeneralTotPtr(GeneralTotalsList[I])^.HomesteadCode in ['N'])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then PrintSectionHeader(Sender, 'G', RollSection, LineNo);

                  If not SubHeaderPrinted
                    then PrintGeneralAssessmentSubheader(Sender, 'N',
                                                         CollectionType, LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  LineNo := LineNo + 1;
                  PrintOneGeneralAssessmentTotal(Sender, RollType, 'N',
                                                 CollectionType,
                                                 TempGeneralTotalRec,
                                                 RollSectionList,
                                                 True, LineNo);

                end;  {else of If (NumNonhomestead = 0)}

              end;  {If (SectionType <> 'R')}

        {Finally, do the overall totals.}

      SubheaderPrinted := False;

      OverallGeneralTotalsList := TList.Create;
      CombineGeneralAssessmentTotals(GeneralTotalsList, OverallGeneralTotalsList);

        {Initialize the temporary record for the totals for this
         subsection.}

      with TempGeneralTotalRec do
        begin
            {FXX01221998-2: I forgot to initialize PartCt.}
          PartCt := 0;
          ParcelCt := 0;
          LandAV := 0;
          TotalAV := 0;
          CountyTaxableVal := 0;
          TownTaxableVal := 0;
          SchoolTaxableVal := 0;
          VillageTaxableVal := 0;

            {FXX05271998-4: Initialize STAR fields.}

          STARAmount := 0;
          TaxableValAfterSTAR := 0;

        end;  {with TempGeneralTotalRec do}

      If (OverallGeneralTotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'G', RollSection, LineNo);
            PrintGeneralAssessmentSubheader(Sender, SectionType,
                                            CollectionType, LineNo);
            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO TAX TOTALS AT THIS LEVEL');
            Println('');
            LineNo := LineNo + 3;
          end
        else
          begin
            Println('');
            LineNo := LineNo + 1;

            For I := 0 to (OverallGeneralTotalsList.Count - 1) do
              begin
                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                  If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                    then
                      begin
                        StartNewPage(Sender, RollType,
                                     SchoolCode, SwisCode,
                                     SectionHeader,
                                     CollectionType,
                                     RollPrintingYear,
                                     AssessmentYearCtlTable,
                                     SchoolCodeDescList,
                                     SwisCodeDescList,
                                     SequenceStr,
                                     PageNo, LineNo);

                        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                        HeaderPrinted := False;
                        SubheaderPrinted := False;

                      end;  {If (LinesLeft < 4)}

                If not HeaderPrinted
                  then
                    begin
                      PrintSectionHeader(Sender, 'G', RollSection, LineNo);
                      HeaderPrinted := True;
                    end;

                If not SubHeaderPrinted
                  then
                    begin
                      PrintGeneralAssessmentSubHeader(Sender, SectionType,
                                                      CollectionType, LineNo);
                      SubheaderPrinted := True;
                    end;

                PrintOneGeneralAssessmentTotal(Sender, RollType, ' ',
                                               CollectionType,
                                               GeneralAssessmentTotPtr(OverallGeneralTotalsList[I])^,
                                               RollSectionList,
                                               False, LineNo);

                UpdateGeneralAssessmentTotals(GeneralAssessmentTotPtr(OverallGeneralTotalsList[I])^,
                                              TempGeneralTotalRec);

              end;  {For I := 0 to OverallGeneralTotalsList do}

              {Make sure that if we had to switch pages between
               the details and the total line that we print the headers
               again.}

                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                  If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                    then
                      begin
                        StartNewPage(Sender, RollType,
                                     SchoolCode, SwisCode,
                                     SectionHeader,
                                     CollectionType,
                                     RollPrintingYear,
                                     AssessmentYearCtlTable,
                                     SchoolCodeDescList,
                                     SwisCodeDescList,
                                     SequenceStr,
                                     PageNo, LineNo);

                        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                        HeaderPrinted := False;
                        SubheaderPrinted := False;

                      end;  {If (LinesLeft < 4)}

            If not HeaderPrinted
              then PrintSectionHeader(Sender, 'G', RollSection, LineNo);

            If not SubHeaderPrinted
              then PrintGeneralAssessmentSubHeader(Sender, SectionType,
                                                   CollectionType, LineNo);

              {Print the totals for this subsection.}

            Println('');
            LineNo := LineNo + 1;
            PrintOneGeneralAssessmentTotal(Sender, RollType, ' ',
                                           CollectionType,
                                           TempGeneralTotalRec,
                                           RollSectionList,
                                           True, LineNo);

         end;  {else of GeneralTotRecord}

    {FXX01191998-3: Need to free up the general totals record according
                    to which type it is.}

      FreeTList(OverallGeneralTotalsList, SizeOf(GeneralAssessmentTotRecord));

    end;  {with Sender as TBaseReport do}

end;  {PrintGeneralAssessmentTotals}

{=======================================================================}
{======================  School TOTALS ROUTINES ========================}
{=======================================================================}
Function FoundSchoolRecord(    SchoolTotalsList : TList;
                               _SchoolCode : String;
                               _HomesteadCode : String;
                           var I : Integer) : Boolean;

{Search through the totals list for this school code,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

  For J := 0 to (SchoolTotalsList.Count - 1) do
    with SchoolTotPtr(SchoolTotalsList[J])^ do
      If ((Take(6, SchoolCode) = Take(6, _SchoolCode)) and
          (Take(1, HomesteadCode) = Take(1, _HomesteadCode)))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundSchoolRecord}

{=======================================================================}
Procedure LoadSchoolTotals(    SchoolTotalsTable : TTable;
                               CollectionType : String;  {SC, MU, CO, VI}
                               SchoolTotalsList : TList;  {Broken up by homestead and non-homestead.}
                               SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                               RollSection : String;
                               SwisCode,
                               SchoolCode : String;
                               SelectedRollSections : TStringList;
                           var Quit : Boolean);

{Load all the School totals for this roll section, swis code, school code,
 (or all for grand totals) into two TLists which have School amounts.
 One for homestead and one for non-homestead. If this is not a classified
 municipality, the totals will go in the homestead list.}

var
  FirstTimeThrough, Done : Boolean;
  SchoolTotalsPtr : SchoolTotPtr;
  I : Integer;

begin
  Done := False;
  FirstTimeThrough := True;

    {FXX04231998-10: Need to cancel last range so that munic totals don't show
                     swis totals.}

  SchoolTotalsTable.CancelRange;

    {Set the index and range of the School table for this collection type.}

  with SchoolTotalsTable do
    If (CollectionHasSchoolTax and
        (CollectionType = 'SC'))
      then
        begin
          IndexName := 'BYSCHOOL_SWIS_RS_HC';

          case SectionType of
            'R' : SetRangeOld(SchoolTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode'],
                              [SchoolCode, SwisCode, RollSection, ' '],
                              [SchoolCode, SwisCode, RollSection, 'Z']);

            'S' : SetRangeOld(SchoolTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode'],
                              [SchoolCode, SwisCode, '1', ' '],
                              [SchoolCode, SwisCode, '9', 'Z']);

              {FXX07122007-2(2.11.2.3)[D913]: The school totals should limit to the current SWIS.}

            'C' : SetRangeOld(SchoolTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode'],
                              [SchoolCode, SwisCode, '1', ' '],
                              [SchoolCode, SwisCode, '9', 'Z']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

        end
      else
        begin
          IndexName := 'BYSWIS_RS_HC_SCHOOL';

          case SectionType of
            'R' : SetRangeOld(SchoolTotalsTable,
                              ['SwisCode', 'RollSection', 'HomesteadCode', 'SchoolCode'],
                              [SwisCode, RollSection, ' ', '      '],
                              [SwisCode, RollSection, 'Z', '999999']);

              {FXX07122007-2(2.11.2.3)[D913]: The school totals should limit to the current SWIS.}

            'S' : SetRangeOld(SchoolTotalsTable,
                              ['SwisCode', 'RollSection', 'HomesteadCode', 'SchoolCode'],
                              [SwisCode, '', '', ''],
                              [SwisCode, 'Z', '', '']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

        end;  {else of If CollectionHasSchoolTax}

  try
    SchoolTotalsTable.First;
  except
    Quit := True;
    SystemSupport(800, SchoolTotalsTable, 'Error getting first School totals record.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          SchoolTotalsTable.Next;
        except
          Quit := True;
          SystemSupport(800, SchoolTotalsTable, 'Error getting next School totals record.',
                        'UTILBILL.PAS', GlblErrorDlgBox);
        end;

    If SchoolTotalsTable.EOF
      then Done := True;

    {FXX04241998-1: Only load the roll sections that we want in this section
                    of the roll.}

    If not Done
      then
        If (SelectedRollSections.IndexOf(SchoolTotalsTable.FieldByName('RollSection').Text) <> -1)
          then
            with SchoolTotalsTable do
              If FoundSchoolRecord(SchoolTotalsList,
                                   FieldByName('SchoolCode').Text,
                                   FieldByName('HomesteadCode').Text, I)
                then
                  begin
                    with SchoolTotPtr(SchoolTotalsList[I])^ do
                      begin
                          {FXX01071998-7: Track the number of splits to
                                          subtract out of total.}

                        PartCt := PartCt + FieldByName('SplitParcelCt').AsInteger;
                        ParcelCt := ParcelCt + FieldByName('ParcelCt').AsInteger;
                        LandAV := LandAV + FieldByName('LandAV').AsFloat;
                        TotalAV := TotalAV + FieldByName('TotalAV').AsFloat;
                        ExemptAmt := ExemptAmt + FieldByName('ExemptAmt').AsFloat;
                        TaxableVal := TaxableVal + FieldByName('TaxableVal').AsFloat;
                        TotalTax := TotalTax + FieldByName('TotalTax').AsFloat;

                          {FXX05061998-3: Save the STAR amounts for school billings.}

                        STARAmount := STARAmount + FieldByName('STARAmount').AsFloat;
                        TaxableValAfterSTAR := TaxableValAfterSTAR +
                                               FieldByName('TaxableValAfterSTAR').AsFloat;

                      end;  {with SchoolistTotPtr(SchoolTotalsList[I])^ do}

                  end
                else
                  begin
                    New(SchoolTotalsPtr);   {get new pptr for tlist array}

                    with SchoolTotalsPtr^ do
                      begin
                        SwisCode := FieldByName('SwisCode').Text;
                        SchoolCode := FieldByName('SchoolCode').Text;
                        RollSection := FieldByName('RollSection').Text;
                        HomesteadCode := FieldByName('HomesteadCode').Text;
                          {FXX01071998-7: Track the number of splits to
                                          subtract out of total.}

                        PartCt := FieldByName('SplitParcelCt').AsInteger;
                        ParcelCt := FieldByName('ParcelCt').AsInteger;
                        LandAV := FieldByName('LandAV').AsFloat;
                        TotalAV := FieldByName('TotalAV').AsFloat;
                        ExemptAmt := FieldByName('ExemptAmt').AsFloat;
                        TaxableVal := FieldByName('TaxableVal').AsFloat;
                        TotalTax := FieldByName('TotalTax').AsFloat;

                          {FXX05061998-3: Save the STAR amounts for school billings.}

                        STARAmount := FieldByName('STARAmount').AsFloat;
                        TaxableValAfterSTAR := FieldByName('TaxableValAfterSTAR').AsFloat;

                      end;  {with SchoolTotalsPtr^ do}

                    SchoolTotalsList.Add(SchoolTotalsPtr);

                  end;  {else of If FoundSchoolRecord(SchoolTotalsList,}

  until (Done or Quit);

end;  {LoadSchoolTotals}

{=======================================================================}
Procedure CombineSchoolTotals(SchoolTotalsList,  {List with totals broken down into hstd, nonhstd.}
                              OverallTotalsList : TList);  {No hstd\nonhstd breakdown.}

{The totals entries in the SchoolTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the SchoolTotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  SchoolTotalsPtr : SchoolTotPtr;

begin
  For I := 0 to (SchoolTotalsList.Count - 1) do
    with SchoolTotPtr(SchoolTotalsList[I])^ do
      If FoundSchoolRecord(OverallTotalsList, SchoolCode,
                            ' ', J)  {Don't use hstd code as a key.}
        then
          begin
              {Note that we do not add the split count again since we
               would be double counting it then.}

            SchoolTotPtr(OverallTotalsList[J])^.ParcelCt :=
                     SchoolTotPtr(OverallTotalsList[J])^.ParcelCt + ParcelCt;
            SchoolTotPtr(OverallTotalsList[J])^.LandAV :=
                     SchoolTotPtr(OverallTotalsList[J])^.LandAV + LandAV;
            SchoolTotPtr(OverallTotalsList[J])^.TotalAV :=
                     SchoolTotPtr(OverallTotalsList[J])^.TotalAV + TotalAV;
            SchoolTotPtr(OverallTotalsList[J])^.ExemptAmt :=
                     SchoolTotPtr(OverallTotalsList[J])^.ExemptAmt + ExemptAmt;
            SchoolTotPtr(OverallTotalsList[J])^.TaxableVal :=
                     SchoolTotPtr(OverallTotalsList[J])^.TaxableVal + TaxableVal;
            SchoolTotPtr(OverallTotalsList[J])^.TotalTax :=
                     SchoolTotPtr(OverallTotalsList[J])^.TotalTax + TotalTax;

              {FXX05061998-3: Save the STAR amounts for school billings.}

            SchoolTotPtr(OverallTotalsList[J])^.STARAmount :=
                     SchoolTotPtr(OverallTotalsList[J])^.STARAmount +
                     STARAmount;
            SchoolTotPtr(OverallTotalsList[J])^.TaxableValAfterSTAR :=
                     SchoolTotPtr(OverallTotalsList[J])^.TaxableValAfterSTAR +
                     TaxableValAfterSTAR;

          end
        else
          begin
            New(SchoolTotalsPtr);   {get new pptr for tlist array}

            SchoolTotalsPtr^.SwisCode := SwisCode;
            SchoolTotalsPtr^.SchoolCode := SchoolCode;
            SchoolTotalsPtr^.RollSection := RollSection;
            SchoolTotalsPtr^.HomesteadCode := ' ';  {Blank out hstd code.}
            SchoolTotalsPtr^.LandAV := LandAV;
            SchoolTotalsPtr^.TotalAV := TotalAV;
            SchoolTotalsPtr^.ParcelCt := ParcelCt;
            SchoolTotalsPtr^.PartCt := PartCt;
            SchoolTotalsPtr^.ExemptAmt := ExemptAmt;
            SchoolTotalsPtr^.TaxableVal := TaxableVal;
            SchoolTotalsPtr^.TotalTax := TotalTax;

              {FXX05061998-3: Save the STAR amounts for school billings.}

            SchoolTotalsPtr^.STARAmount := STARAmount;
            SchoolTotalsPtr^.TaxableValAfterSTAR := TaxableValAfterSTAR;

            OverallTotalsList.Add(SchoolTotalsPtr);

          end;  {else of If FoundSchoolRecord(OverallTotalsList, SchoolCode, ExtCode, CMFlag,}

end;  {CombineSchoolTotals}

{=======================================================================}
Procedure UpdateSchoolTaxTotals(    SourceSchoolTotalsRec : SchoolTotRecord;
                                var TempSchoolTotalRec : SchoolTotRecord);

{Update the running totals in the TempSchoolTotalRec from the source
 rec.}

begin
  with TempSchoolTotalRec do
    begin
      ParcelCt := ParcelCt + SourceSchoolTotalsRec.ParcelCt;
      PartCt := PartCt + SourceSchoolTotalsRec.PartCt;
      LandAV := LandAv + SourceSchoolTotalsRec.LandAV;
      TotalAV := TotalAV + SourceSchoolTotalsRec.TotalAV;
      ExemptAmt := ExemptAmt + SourceSchoolTotalsRec.ExemptAmt;
      TaxableVal := TaxableVal + SourceSchoolTotalsRec.TaxableVal;
      TotalTax := TotalTax + SourceSchoolTotalsRec.TotalTax;

        {FXX05061998-3: Save the STAR amounts for school billings.}

      STARAmount := STARAmount + SourceSchoolTotalsRec.STARAmount;
      TaxableValAfterSTAR := TaxableValAfterSTAR +
                             SourceSchoolTotalsRec.TaxableValAfterSTAR;

    end;  {with TempSchoolTotalRec do}

end;  {UpdateSchoolTaxTotals}

{=======================================================================}
Procedure PrintSchoolSubheader(    Sender : TObject;  {Report printer or filer object}
                                   RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                   CollectionType : String;
                                   SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                               var LineNo : Integer);

{Print the individual School totals section header and set the tabs for the
 School amounts columns.}

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hSchoolt\nonhstd so
         the following two lines are not needed.}

      If (SubheaderType <> 'R')
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Code}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjCenter, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjCenter, TL4W, 0, BOXLINENONE, 0);   {Land AV}
      SetTab(TL5, pjCenter, TL5W, 0, BOXLINENONE, 0);   {Total AV}
      SetTab(TL6, pjCenter, TL6W, 0, BOXLINENONE, 0);   {Exempt amount}
      SetTab(TL7, pjCenter, TL7W, 0, BOXLINENONE, 0);   {Taxable val}
      SetTab(TL8, pjCenter, TL8W, 0, BOXLINENONE, 0);   {Tax rate}
      SetTab(TL9, pjCenter, TL9W, 0, BOXLINENONE, 0);   {Total tax}

       {Don't show tax rate or tax total unless this is a school billing.}

      Println('');
      Print(#9 +'SCHL' +
            #9 +
            #9 + 'TOTAL' +
            #9 + 'ASSESSED' +
            #9 + 'ASSESSED' +
            #9 + 'EXEMPT' +
            #9 + 'TOTAL');

        {FXX05271998-3: Print STAR amounts in last two columns for school
                        assessment roll.}

      If CollectionHasSchoolTax
         then
           begin
             If (RollType = 'X')
               then Println(#9 + 'TAX' +
                            #9 + 'TOTAL')
               else Println(#9 + 'STAR' +
                            #9 + 'STAR');
           end
         else Println('');

      LineNo := LineNo + 2;

      Print(#9 + 'CODE' +
            #9 + 'DESCRIPTION' +
            #9 + 'PARCELS' +
            #9 + 'LAND' +
            #9 + 'TOTAL' +
            #9 + 'AMOUNT' +
            #9 + 'TAXABLE');

      If CollectionHasSchoolTax
        then
          begin
            If (RollType = 'X')
              then Println(#9 + 'RATE' +
                           #9 + 'TAX')
              else Println(#9 + 'AMOUNT' +
                           #9 + 'TAXABLE');
          end
        else Println('');

      LineNo := LineNo + 1;

         {If this is a homestead or nonhomestead section,
          print that this is the total number of parcels and parts.}

       If (SubheaderType in ['H', 'N'])
         then
           begin
             Println(#9 + #9 + #9 + '& PARTS');
             LineNo := LineNo + 1;
           end;

          {FXX06251998-8: Add the STAR amount fields to the tax roll.}

        If ((RollType = 'X') and
            CollectionHasSchoolTax)
          then
            begin
              Println(#9 + #9 + #9 + #9 + #9 +
                      #9 + '-----------' +
                      #9 + '------------');

              Println(#9 + #9 + #9 + #9 + #9 +
                      #9 + 'STAR AMOUNT' +
                      #9 + 'STAR TAXABLE');

              LineNo := LineNo + 2;

            end;  {If CollectionHasSchoolTax}

       {FXX12291997-2: Print a blank line between the header and the start
                       of the information.}

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintSchoolSubheader}

{=======================================================================}
Procedure PrintOneSchoolTotal(    Sender : TObject;  {Report printer or filer object}
                                  RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                  SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                                  CollectionType : String;
                                  SchoolCodeDescList : TList;
                                  SchoolTotalsRec : SchoolTotRecord;
                                  IsTotalRecord : Boolean;  {Is this a 'TOTAL' line?}
                              var LineNo : Integer);

{Print one school total.}

begin
  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {Code}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, TL4W, 0, BOXLINENONE, 0);   {Land AV}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {Total AV}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {Exempt amount}
      SetTab(TL7, pjRight, TL7W, 0, BOXLINENONE, 0);   {Taxable val}
      SetTab(TL8, pjRight, TL8W, 0, BOXLINENONE, 0);   {Tax rate}
      SetTab(TL9, pjRight, TL9W, 0, BOXLINENONE, 0);   {Total tax}

      with SchoolTotalsRec do
        begin
          If IsTotalRecord
            then Print(#9 + #9 + 'TOTAL')
            else Print(#9 + SchoolCode +
                       #9 + Take(18, (GetDescriptionFromList(SchoolCode, SchoolCodeDescList))));

            {FXX01071998-7: Subtract the number of splits out of the total.}

          If (SubheaderType in ['H', 'N'])
            then Print(#9 + IntToStr(ParcelCt))
            else Print(#9 + IntToStr(ParcelCt - PartCt));

          If (Roundoff(LandAV, 2) > 0)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, LandAV))
            else Print(#9);

          If (Roundoff(TotalAV, 2) > 0)
            then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalAV))
            else Print(#9);

          If (Roundoff(ExemptAmt, 0) > 0)
             then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, ExemptAmt))
             else Print(#9);

          If (Roundoff(TaxableVal, 2) > 0)
             then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal))
             else Print(#9);

          If (RollType = 'X')
            then
              begin
                    {FXX06251998-8: Add the STAR amount fields to the tax roll.}
                  {If school collection, go to the next line for STAR amounts.}

                If CollectionHasSchoolTax
                  then
                    begin
                      Println('');
                      LineNo := LineNo + 1;
                      Print(#9 + #9 + #9 + #9 + #9 +
                            #9 + FormatFloat(NoDecimalDisplay_BlankZero, STARAmount) +
                            #9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableValAfterSTAR));

                    end;  {If CollectionHasSchoolTax}

                  {There is no rate for school - it is part of general.}

                Print(#9);

                  {We will only print the tax amount if this is a school billing.}

                If CollectionHasSchoolTax
                  then Print(#9 + FormatFloat(DecimalDisplay, TotalTax))
                  else Print('');

              end  {If (RollType = 'X')}
            else
              If CollectionHasSchoolTax
                then
                  begin
                       {FXX05271998-3: Print STAR amounts.}
                    Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, STARAmount));
                    Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, TaxableValAfterSTAR));

                  end;  {If CollectionHasSchoolTax}

          Println('');

        end;  {with SchoolTotalsRec do}

      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintOneSchoolTotal}

{=======================================================================}
Procedure PrintSchoolTotals(    Sender : TObject;  {Report printer or filer object}
                                SchoolTotalsList : TList;
                                RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                CollectionType : String; {From here down is for printing the header.}
                                RollPrintingYear : String;
                                AssessmentYearCtlTable : TTable;
                                SchoolCode,
                                SwisCode : String;
                                RollSection : String;
                                SchoolCodeDescList,
                                SwisCodeDescList : TList;
                                SequenceStr : String;
                            var PageNo,
                                LineNo : Integer);

{Print the School totals in the TLists.}

var
  I, NumHomestead, NumNonhomestead : Integer;
  HeaderPrinted, SubheaderPrinted : Boolean;
  OverallSchoolTotalsList : TList;
  TempSchoolTotalRec : SchoolTotRecord;  {For an overall total for this section.}
  SectionHeader : String;

begin
  HeaderPrinted := False;
  NumHomestead := 0;
  NumNonhomestead := 0;

    {FXX04291998-9: For swis and municipal totals, print that for the header.
                    For roll section totals, print the roll secion name.}

  SectionHeader := GetSectionHeader(SectionType, RollSection);

  For I := 0 to (SchoolTotalsList.Count - 1) do
    with SchoolTotPtr(SchoolTotalsList[I])^ do
      If (HomesteadCode = 'N')
        then NumNonhomestead := NumNonhomestead + 1
        else NumHomestead := NumHomestead + 1;

  with Sender as TBaseReport do
    begin
        {First homestead part, but only if this is not a roll section summary.
         Note that we print the header and subheader only if there is an
         entry.}

        {FXX04231998-7: Don't print hstd/non-hstd if not classified.}
        {FXX04241998-3: Shouldn't have a "not" in front of GlblMunicipalityIsClassified.}

      If ((SectionType <> 'R') and
          GlblMunicipalityIsClassified)
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempSchoolTotalRec do
              begin
                ParcelCt := 0;
                LandAV := 0;
                TotalAV := 0;
                ExemptAmt := 0;
                TaxableVal := 0;
                TotalTax := 0;

                  {FXX05271998-4: Initialize STAR fields.}

                STARAmount := 0;
                TaxableValAfterSTAR := 0;

              end;  {with TempSchoolTotalRec do}

            If (NumHomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'C', RollSection, LineNo);
                  PrintSchoolSubheader(Sender, RollType,
                                       CollectionType, 'H', LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TAX TOTALS AT THIS LEVEL');
                  Println('');
                  LineNo := LineNo + 3;
                end
              else
                begin
                  For I := 0 to (SchoolTotalsList.Count - 1) do
                    If (SchoolTotPtr(SchoolTotalsList[I])^.HomesteadCode[1] in ['H', ' '])
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'C', RollSection, LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintSchoolSubheader(Sender, RollType,
                                                     CollectionType,
                                                     'H', LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneSchoolTotal(Sender, RollType, 'H',
                                              CollectionType,
                                              SchoolCodeDescList,
                                              SchoolTotPtr(SchoolTotalsList[I])^,
                                              False, LineNo);

                            {Do we need to go to a new page?}
                            {FXX04231998-9: Instead of print the roll section hdr for
                                            the totals sections, print the section type.}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, RollType,
                                             SchoolCode, SwisCode,
                                             SectionHeader,
                                             CollectionType,
                                             RollPrintingYear,
                                             AssessmentYearCtlTable,
                                             SchoolCodeDescList,
                                             SwisCodeDescList,
                                             SequenceStr,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateSchoolTaxTotals(SchoolTotPtr(SchoolTotalsList[I])^,
                                                TempSchoolTotalRec);

                        end;  {If (SchoolTotPtr(SchoolTotalsList[I])^.HomesteadCode in ['H', ' '])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'C', RollSection, LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintSchoolSubheader(Sender, RollType,
                                              CollectionType, 'H', LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  LineNo := LineNo + 1;
                  PrintOneSchoolTotal(Sender, RollType, 'H',
                                      CollectionType,
                                      SchoolCodeDescList,
                                      TempSchoolTotalRec,
                                      True, LineNo);

                end;  {else of If (NumHomestead = 0)}

          end;  {If (SectionType <> 'R')}

        {Now the non-homestead part, if these are not roll section totals.}
        {FXX04291998-1: Don't print non-hstd if not classified.}

      If ((SectionType <> 'R') and
          GlblMunicipalityIsClassified)
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempSchoolTotalRec do
              begin
                ParcelCt := 0;
                LandAV := 0;
                TotalAV := 0;
                ExemptAmt := 0;
                TaxableVal := 0;
                TotalTax := 0;

                  {FXX05271998-4: Initialize STAR fields.}

                STARAmount := 0;
                TaxableValAfterSTAR := 0;

              end;  {with TempSchoolTotalRec do}

            If (NumNonhomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'C', RollSection, LineNo);
                  PrintSchoolSubheader(Sender, RollType,
                                       CollectionType, 'N', LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO TAX TOTALS AT THIS LEVEL');
                  Println('');
                  LineNo := LineNo + 3;
                end
              else
                begin
                  For I := 0 to (SchoolTotalsList.Count - 1) do
                    If (SchoolTotPtr(SchoolTotalsList[I])^.HomesteadCode[1] = 'N')
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'C', RollSection, LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintSchoolSubheader(Sender, RollType,
                                                     CollectionType, 'N', LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneSchoolTotal(Sender, RollType, 'N',
                                              CollectionType,
                                              SchoolCodeDescList,
                                              SchoolTotPtr(SchoolTotalsList[I])^,
                                              False, LineNo);

                            {Do we need to go to a new page?}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, RollType,
                                             SchoolCode, SwisCode,
                                             SectionHeader,
                                             CollectionType,
                                             RollPrintingYear,
                                             AssessmentYearCtlTable,
                                             SchoolCodeDescList,
                                             SwisCodeDescList,
                                             SequenceStr,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType,
                                                         LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateSchoolTaxTotals(SchoolTotPtr(SchoolTotalsList[I])^,
                                                 TempSchoolTotalRec);

                        end;  {If (SchoolTotPtr(SchoolTotalsList[I])^.HomesteadCode in ['N'])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'C', RollSection, LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintSchoolSubheader(Sender, RollType,
                                              CollectionType, 'N', LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  LineNo := LineNo + 1;
                  PrintOneSchoolTotal(Sender, RollType, 'N',
                                      CollectionType,
                                      SchoolCodeDescList,
                                      TempSchoolTotalRec, True, LineNo);

                end;  {else of If (NumNonhomestead = 0)}

              end;  {If (SectionType <> 'R')}

        {Finally, do the overall totals.}

      SubheaderPrinted := False;

      OverallSchoolTotalsList := TList.Create;
      CombineSchoolTotals(SchoolTotalsList, OverallSchoolTotalsList);

        {Initialize the temporary record for the totals for this
         subsection.}

      with TempSchoolTotalRec do
        begin
          ParcelCt := 0;
          PartCt := 0;
          LandAV := 0;
          TotalAV := 0;
          ExemptAmt := 0;
          TaxableVal := 0;
          TotalTax := 0;

            {FXX05271998-4: Initialize STAR fields.}

          STARAmount := 0;
          TaxableValAfterSTAR := 0;

        end;  {with TempSchoolTotalRec do}

      If (OverallSchoolTotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'C', RollSection, LineNo);
            PrintSchoolSubheader(Sender, RollType,
                                 CollectionType, SectionType, LineNo);
            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO TAX TOTALS AT THIS LEVEL');
            Println('');
            LineNo := LineNo + 3;
          end
        else
          begin
            For I := 0 to (OverallSchoolTotalsList.Count - 1) do
              begin
                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                  If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                    then
                      begin
                        StartNewPage(Sender, RollType,
                                     SchoolCode, SwisCode,
                                     SectionHeader,
                                     CollectionType,
                                     RollPrintingYear,
                                     AssessmentYearCtlTable,
                                     SchoolCodeDescList,
                                     SwisCodeDescList,
                                     SequenceStr,
                                     PageNo, LineNo);

                        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                        HeaderPrinted := False;
                        SubheaderPrinted := False;

                      end;  {If (LinesLeft < 4)}

                If not HeaderPrinted
                  then
                    begin
                      PrintSectionHeader(Sender, 'C', RollSection, LineNo);
                      HeaderPrinted := True;
                    end;

                If not SubHeaderPrinted
                  then
                    begin
                      PrintSchoolSubHeader(Sender, RollType,
                                           CollectionType, SectionType, LineNo);
                      SubheaderPrinted := True;
                    end;

                PrintOneSchoolTotal(Sender, RollType, ' ',
                                    CollectionType, SchoolCodeDescList,
                                    SchoolTotPtr(OverallSchoolTotalsList[I])^,
                                    False, LineNo);

                UpdateSchoolTaxTotals(SchoolTotPtr(OverallSchoolTotalsList[I])^,
                                      TempSchoolTotalRec);

              end;  {For I := 0 to OverallSchoolTotalsList do}

              {Make sure that if we had to switch pages between
               the details and the total line that we print the headers
               again.}

                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                  If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                    then
                      begin
                        StartNewPage(Sender, RollType,
                                     SchoolCode, SwisCode,
                                     SectionHeader,
                                     CollectionType,
                                     RollPrintingYear,
                                     AssessmentYearCtlTable,
                                     SchoolCodeDescList,
                                     SwisCodeDescList,
                                     SequenceStr,
                                     PageNo, LineNo);

                        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                        HeaderPrinted := False;
                        SubheaderPrinted := False;

                      end;  {If (LinesLeft < 4)}

            If not HeaderPrinted
              then PrintSectionHeader(Sender, 'C', RollSection, LineNo);

            If not SubHeaderPrinted
              then PrintSchoolSubheader(Sender, RollType,
                                        CollectionType, SectionType, LineNo);

              {Print the totals for this subsection.}

            Println('');
            LineNo := LineNo + 1;
            PrintOneSchoolTotal(Sender, RollType, ' ',
                                CollectionType, SchoolCodeDescList,
                                TempSchoolTotalRec, True, LineNo);

         end;  {else of SchoolTotRecord}

      FreeTList(OverallSchoolTotalsList, SizeOf(SchoolTotRecord));

    end;  {with Sender as TBaseReport do}

end;  {PrintSchoolTotals}

{=======================================================================}
{==================  SPECIAL DISTRICT TOTAL ROUNTINES  =================}
{=======================================================================}
Function FoundSDRecord(    SDTotalsList : TList;
                           _SDCode : String;
                           _ExtCode : String;
                           _CMFlag : String;
                           _HomesteadCode,
                           _RollSection : String;
                           CombineRollSections : Boolean;
                       var I : Integer) : Boolean;

{Search through the totals list for this SD code, ext code,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

      {FXX04231998-12: Need to use roll section in key for totals recs, too.}
      {FXX04291998-6: Don't need to use roll section as criteria when showing
                      totals in SD sections.}

  For J := 0 to (SDTotalsList.Count - 1) do
    with SDistTotPtr(SDTotalsList[J])^ do
      If ((Take(5, SDCode) = Take(5, _SDCode)) and
          (Take(2, ExtCode) = Take(2, _ExtCode)) and
          (Take(1, CMFlag) = Take(1, _CMFlag)) and
(*          (Take(1, HomesteadCode) = Take(1, _HomesteadCode)) and *)
          (CombineRollSections or
           (Take(1, RollSection) = Take(1, _RollSection))))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundSDRecord}

{=======================================================================}
Procedure LoadSDTotals(    SDTotalsTable : TTable;
                           CollectionType : String;  {SC, MU, CO, VI}
                           SDTotalsList : TList;  {Broken up by homestead and non-homestead.}
                           SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                           RollSection : String;
                           SwisCode,
                           SchoolCode : String;
                           _HomesteadCode : String;
                           SelectedRollSections : TStringList;
                       var Quit : Boolean);

{Load all the SD totals for this roll section, swis code, school code,
 (or all for grand totals) into two TLists which have SD amounts.
 One for homestead and one for non-homestead. If this is not a classified
 municipality, the totals will go in the homestead list.}

var
  FirstTimeThrough, Done : Boolean;
  SDTotalsPtr : SDistTotPtr;
  I : Integer;

begin
  Done := False;
  FirstTimeThrough := True;

    {FXX04231998-10: Need to cancel last range so that munic totals don't show
                     swis totals.}

  SDTotalsTable.CancelRange;

    {Set the index and range of the SD table for this collection type.}

  with SDTotalsTable do
    If (CollectionHasSchoolTax and
        (CollectionType = 'SC'))
      then
        begin
          IndexName := 'BYSCHOOL_SWIS_RS_HC_SD_EXT_CM';

          case SectionType of
            'R' : SetRangeOld(SDTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection',
                               'HomesteadCode', 'SDCode', 'ExtCode', 'CMFlag'],
                              [SchoolCode, SwisCode, RollSection, ' ', '     ',
                               '  ', ' '],
                              [SchoolCode, SwisCode, RollSection, 'Z', 'ZZZZZ',
                               'ZZ', 'Z']);

            'S' : SetRangeOld(SDTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection',
                               'HomesteadCode', 'SDCode', 'ExtCode', 'CMFlag'],
                              [SchoolCode, SwisCode, '1', ' ', '     ',
                               '  ', ' '],
                              [SchoolCode, SwisCode, '9', 'Z', 'ZZZZZ',
                               'ZZ', 'Z']);

            'C' : SetRangeOld(SDTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection',
                               'HomesteadCode', 'SDCode', 'ExtCode', 'CMFlag'],
                              [SchoolCode, '      ', '1', ' ', '     ',
                               '  ', ' '],
                              [SchoolCode, '999999', '9', 'Z', 'ZZZZZ',
                               'ZZ', 'Z']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

        end
      else
        begin
          IndexName := 'BYSWISCODE_RS_HC_SD_EXT_CM';

          case SectionType of
            'R' : SetRangeOld(SDTotalsTable,
                              ['SwisCode', 'RollSection', 'HomesteadCode',
                               'SDCode', 'ExtCode', 'CMFlag'],
                              [SwisCode, RollSection, ' ', '     ',
                               '  ', ' '],
                              [SwisCode, RollSection, 'Z', 'ZZZZZ',
                               'ZZ', 'Z']);
            'S' : SetRangeOld(SDTotalsTable,
                              ['SwisCode', 'RollSection', 'HomesteadCode',
                               'SDCode', 'ExtCode', 'CMFlag'],
                              [SwisCode, '1', ' ', '     ',
                               '  ', ' '],
                              [SwisCode, '9', 'Z', 'ZZZZZ',
                               'ZZ', 'Z']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

        end;  {else of If CollectionHasSchoolTax}

  SDTotalsTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SDTotalsTable.Next;

    If SDTotalsTable.EOF
      then Done := True;

      {FXX04231998-12: Need to use roll section in key for totals recs, too.}

      {FXX04241998-1: Only load the roll sections that we want in this section
                      of the roll.}

    If not Done
      then
        If ((SelectedRollSections.IndexOf(SDTotalsTable.FieldByName('RollSection').Text) <> -1) and
            (_Compare(_HomesteadCode, coBlank) or
             _Compare(SDTotalsTable.FieldByName('HomesteadCode').Text, _HomesteadCode, coEqual)))
          then
            with SDTotalsTable do
              If FoundSDRecord(SDTotalsList,
                               FieldByName('SDCode').Text,
                               FieldByName('ExtCode').Text,
                               FieldByName('CMFlag').Text,
                               FieldByName('HomesteadCode').Text,
                               FieldByName('RollSection').Text, False, I)
                then
                  begin
                    with SDistTotPtr(SDTotalsList[I])^ do
                      begin
                        ParcelCt := ParcelCt + FieldByName('ParcelCt').AsInteger;

                          {FXX07122007-3(2.11.2.3)[D907]: The part count is incorrect for the split districts.}

                        If (_Compare(_HomesteadCode, coNotBlank) or
                            (_Compare(_HomesteadCode, coBlank) and
                             _Compare(SDTotalsTable.FieldByName('HomesteadCode').AsString, 'H', coEqual)))
                          then
                            try
                              PartCount := PartCount + FieldByName('SplitParcelCt').AsInteger;
                            except
                            end;

                        Value := Value + FieldByName('Value').AsFloat;
                        ADValue := ADValue + FieldByName('ADValue').AsFloat;
                        ExemptAmt := ExemptAmt + FieldByName('ExemptAmt').AsFloat;
                        TaxableVal := TaxableVal + FieldByName('TaxableVal').AsFloat;
                        TotalTax := TotalTax + FieldByName('TotalTax').AsFloat;

                      end;  {with SDistTotPtr(SDTotalsList[I])^ do}

                  end
                else
                  begin
                    New(SDTotalsPtr);   {get new pptr for tlist array}

                    with SDTotalsPtr^ do
                      begin
                        SwisCode := FieldByName('SwisCode').Text;
                        SchoolCode := FieldByName('SchoolCode').Text;
                        RollSection := FieldByName('RollSection').Text;
                        HomesteadCode := FieldByName('HomesteadCode').Text;
                        SDCode := FieldByName('SDCode').Text;
                        ExtCode := FieldByName('ExtCode').Text;
                        CMFlag := FieldByName('CMFlag').Text;
                        ParcelCt := FieldByName('ParcelCt').AsInteger;

                        If (_Compare(_HomesteadCode, coNotBlank) or
                            (_Compare(_HomesteadCode, coBlank) and
                             _Compare(SDTotalsTable.FieldByName('HomesteadCode').AsString, 'H', coEqual)))
                          then
                            try
                              PartCount := FieldByName('SplitParcelCt').AsInteger;
                            except
                              PartCount := 0;
                            end
                          else PartCount := 0;

                        Value := FieldByName('Value').AsFloat;
                        ADValue := FieldByName('ADValue').AsFloat;
                        ExemptAmt := FieldByName('ExemptAmt').AsFloat;
                        TaxableVal := FieldByName('TaxableVal').AsFloat;
                        TotalTax := FieldByName('TotalTax').AsFloat;

                      end;  {with SDTotalsPtr^ do}

                    SDTotalsList.Add(SDTotalsPtr);

                  end;  {else of If FoundSDRecord(SDTotalsList,}

  until (Done or Quit);

end;  {LoadSDTotals}

{=======================================================================}
Procedure CombineSDTotals(SDTotalsList,  {List with totals broken down into hstd, nonhstd.}
                          OverallTotalsList : TList;
                          _HomesteadCode : String);

{The totals entries in the SDTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the SDTotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  TempPtr, SDTotalsPtr : SDistTotPtr;
  MainKey, NewKey : String;

begin
   {FXX04231998-12: Need to use roll section in key for totals recs, too.}

  For I := 0 to (SDTotalsList.Count - 1) do
    with SDistTotPtr(SDTotalsList[I])^ do
      If ((Trim(_HomesteadCode) = '') or
          (HomesteadCode = _HomesteadCode))
        then
          If FoundSDRecord(OverallTotalsList, SDCode, ExtCode, CMFlag,
                           _HomesteadCode, RollSection, True, J)
            then
              begin
                SDistTotPtr(OverallTotalsList[J])^.ParcelCt :=
                         SDistTotPtr(OverallTotalsList[J])^.ParcelCt + ParcelCt;
                SDistTotPtr(OverallTotalsList[J])^.PartCount :=
                         SDistTotPtr(OverallTotalsList[J])^.PartCount + PartCount;
                SDistTotPtr(OverallTotalsList[J])^.Value :=
                         SDistTotPtr(OverallTotalsList[J])^.Value + Value;
                SDistTotPtr(OverallTotalsList[J])^.ADValue :=
                         SDistTotPtr(OverallTotalsList[J])^.ADValue + ADValue;
                SDistTotPtr(OverallTotalsList[J])^.ExemptAmt :=
                         SDistTotPtr(OverallTotalsList[J])^.ExemptAmt + ExemptAmt;
                SDistTotPtr(OverallTotalsList[J])^.TaxableVal :=
                         SDistTotPtr(OverallTotalsList[J])^.TaxableVal + TaxableVal;
                SDistTotPtr(OverallTotalsList[J])^.TotalTax :=
                         SDistTotPtr(OverallTotalsList[J])^.TotalTax + TotalTax;

              end
            else
              begin
                New(SDTotalsPtr);   {get new pptr for tlist array}

                SDTotalsPtr^.SwisCode := SwisCode;
                SDTotalsPtr^.SchoolCode := SchoolCode;
                SDTotalsPtr^.RollSection := RollSection;
                SDTotalsPtr^.HomesteadCode := _HomesteadCode;
                SDTotalsPtr^.SDCode := SDCode;
                SDTotalsPtr^.ExtCode := ExtCode;
                SDTotalsPtr^.CMFlag := CMFlag;
                SDTotalsPtr^.ParcelCt := ParcelCt;
                SDTotalsPtr^.PartCount := PartCount;
                SDTotalsPtr^.Value := Value;
                SDTotalsPtr^.ADValue := ADValue;
                SDTotalsPtr^.ExemptAmt := ExemptAmt;
                SDTotalsPtr^.TaxableVal := TaxableVal;
                SDTotalsPtr^.TotalTax := TotalTax;

                OverallTotalsList.Add(SDTotalsPtr);

              end;  {else of If FoundSDRecord(OverallTotalsList, SDCode, ExtCode, CMFlag,}

    {FXX01021998-12: Sort the overall SD totals by SD code\ Extension.}

  For I := 0 to (OverallTotalsList.Count - 1) do
    begin
      with SDistTotPtr(OverallTotalsList[I])^ do
        MainKey := Take(5, SDCode) + Take(2, ExtCode);

      For J := (I + 1) to (OverallTotalsList.Count - 1) do
        begin
          with SDistTotPtr(OverallTotalsList[J])^ do
            NewKey := Take(5, SDCode) + Take(2, ExtCode);

          If (NewKey < MainKey)
            then
              begin
                TempPtr := OverallTotalsList[I];
                OverallTotalsList[I] := OverallTotalsList[J];
                OverallTotalsList[J] := TempPtr;
                MainKey := NewKey;

              end;  {If (NewKey < MainKey)}

        end;  {For J := (I + 1) to (OverallTotalsList.Count - 1) do}

    end;  {For I := 0 to (OverallTotalsList.Count - 1) do}

end;  {CombineSDTotals}

{=======================================================================}
Procedure UpdateSDTaxTotals(    SourceSDTotalsRec : SDistTotRecord;
                            var TempSDTotalRec : SDistTotRecord);

{Update the running totals in the TempSDTotalRec from the source
 rec.}

begin
  with TempSDTotalRec do
    begin
      ParcelCt := ParcelCt + SourceSDTotalsRec.ParcelCt;
      PartCount := PartCount + SourceSDTotalsRec.PartCount;
      Value := Value + SourceSDTotalsRec.Value;
      ADValue := ADValue + SourceSDTotalsRec.ADValue;
      ExemptAmt := ExemptAmt + SourceSDTotalsRec.ExemptAmt;
      TaxableVal := TaxableVal + SourceSDTotalsRec.TaxableVal;
      TotalTax := TotalTax + SourceSDTotalsRec.TotalTax;

    end;  {with TempSDTotalRec do}

end;  {UpdateSDTaxTotals}

{=======================================================================}
Procedure PrintSDSubheader(    Sender : TObject;  {Report printer or filer object}
                               RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                               SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                           var LineNo : Integer);

{Print the individual SD totals section header and set the tabs for the
 SD amounts columns.}

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hsdt\nonhstd so
         the following two lines are not needed.}

      If (SubheaderType <> 'R')
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {CODE}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {DIST NAME}
      SetTab(TL3, pjLeft, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjLeft, TL4W, 0, BOXLINENONE, 0);   {EXT TYPE}
      SetTab(TL5, pjCenter, TL5W, 0, BOXLINENONE, 0);   {EXT VALUE}
      SetTab(TL6, pjCenter, TL6W, 0, BOXLINENONE, 0);   {AD VAL VALUE}
      SetTab(TL7, pjCenter, TL7W, 0, BOXLINENONE, 0);   {EXEMPT AMT}
      SetTab(TL8, pjCenter, TL8W, 0, BOXLINENONE, 0);   {TAXABLE VAL}
      SetTab(TL9, pjCenter, TL9W, 0, BOXLINENONE, 0);   {TAX RATE}
      SetTab(TL10, pjRight, TL10W, 0, BOXLINENONE, 0);   {TOTAL TX}

        {FXX01191998-7: Don't print tax rate or amt header for assessment
                        rolls.}

      Println('');
      Print(#9 + #9 +
            #9 + 'TOTAL' +
            #9 + 'EXTENSION' +
            #9 + 'EXTENSION' +
            #9 + 'AD VALOREM' +
            #9 + 'EXEMPT' +
            #9 + 'TAXABLE');

      If (RollType = 'X')
        then Println(#9 + 'TAX' +
                     #9 + 'TOTAL')
        else Println('');

       Print(#9 + 'CODE' +
             #9 + 'DISTRICT NAME' +
             #9 + 'PARCELS' +
             #9 + 'TYPE' +
             #9 + 'VALUE' +
             #9 + 'VALUE' +
             #9 + 'AMOUNT' +
             #9 + 'VALUE');

      If (RollType = 'X')
        then Println(#9 + 'RATE' +
                     #9 + 'TAX')
        else Println('');

       LineNo := LineNo + 3;

         {If this is a homestead or nonhomestead section,
          print that this is the total number of parcels and parts.}

       If (SubheaderType in ['H', 'N'])
         then
           begin
             Println(#9 + #9 + #9 + '& PARTS');
             LineNo := LineNo + 1;
           end;

       {FXX12291997-2: Print a blank line between the header and the start
                       of the information.}

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintSDSubheader}

{=======================================================================}
Procedure PrintOneSDTotal(    Sender : TObject;  {Report printer or filer object}
                              RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                              SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                              SDRateList,
                              SDCodeDescList,
                              SDExtCodeDescList : TList;
                              NumExtensionsThisSDCode : Integer;
                              LastSDCode : String;  {What was the last SD code printed?}
                              SDTotalsRec : SDistTotRecord;
                          var LineNo : Integer);

{Print one special district total.}

var
  I : Integer;
  IsTotalsRec : Boolean;
  TempRate : Extended;
  ParcelCount : LongInt;

begin
  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {CODE}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {DIST NAME}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjLeft, TL4W, 0, BOXLINENONE, 0);   {EXT TYPE}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {EXT VALUE}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {AD VAL VALUE}
      SetTab(TL7, pjRight, TL7W, 0, BOXLINENONE, 0);   {EXEMPT AMT}
      SetTab(TL8, pjRight, TL8W, 0, BOXLINENONE, 0);   {TAXABLE VAL}
      SetTab(TL9, pjRight, TL9W, 0, BOXLINENONE, 0);   {TAX RATE}
      SetTab(TL10, pjRight, TL10W, 0, BOXLINENONE, 0);   {TOTAL TX}

      with SDTotalsRec do
        begin
            {FXX12291997-6: For SD totals, print only the total amt, the
                            rest does not make sense.}
            {FXX01021998-5: The word 'TOTAL' is in last SD code, not the SD
                            code.}

          IsTotalsRec := (Take(5, LastSDCode) = 'TOTAL');

            {Only print the SD code if it is different than the last
             SD code printed.}

            {FXX12291997-4: Make the extension shorter and include the CM flag.}

          If IsTotalsRec
            then Print(#9 + 'TOTAL' + #9 + #9 + #9 + #9 + #9 +
                       #9 + #9 + #9)
            else
              begin
                  {FXX12301997-1: Don't print the SD code on each line of
                                  each extension for the same SD code.}
                  {FXX01021998-3: Skip repeating the description and
                                  # parcels, too.}

                ParcelCount := ParcelCt;

                If _Compare(SDTotalsRec.HomesteadCode, coBlank)
                  then ParcelCount := ParcelCount - PartCount;

                If (SDCode = LastSDCode)
                  then Print(#9 + #9 + #9)
                  else Print(#9 + SDCode +
                             #9 + UpcaseStr(Take(15, GetDescriptionFromList(SDCode, SDCodeDescList))) +
                             #9 + IntToStr(ParcelCount));

                Print(#9 + Take(5, UpcaseStr(GetDescriptionFromList(ExtCode, SDExtCodeDescList))) +
                           ' ' + CMFlag);

                If (Roundoff(Value, 2) > 0)
                   then Print(#9 + FormatFloat(DecimalDisplay, Value))
                   else Print(#9);

                   {FXX12291997-3: Print ad valorum as whole val except in rs.9}

                Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, ADValue));

                If (Roundoff(ExemptAmt, 0) > 0)
                   then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, ExemptAmt))
                   else Print(#9);

                   {FXX12301997-2: Taxable val should display without dec.}
                   {FXX01021998-13: Taxable values should have no dec for
                                    TO, dec for all else.}

                If (ExtCode = 'TO')
                  then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, TaxableVal))
                  else Print(#9 + FormatFloat(DecimalDisplay_BlankZero, TaxableVal));

                If ((RollType = 'X') and
                    FoundSDRate(SDRateList, SDCode, ExtCode, CMFlag, I))
                  then
                    with SDRatePointer(SDRateList[I])^ do
                      begin
                        If (SDTotalsRec.HomesteadCode = 'N')
                          then TempRate := NonhomesteadRate
                          else TempRate := HomesteadRate;

                          {FXX01142005-1(2.8.2.4)[2047]: The rate was not showing for SDs becuase
                                                         the nonhomestead rate was 0 and thus different from the
                                                         homestead rate.  So, I had to add a test for 0.}

                        If ((Roundoff(NonhomesteadRate, 6) <> 0) and
                            (Roundoff(NonhomesteadRate, 6) <>
                             Roundoff(HomesteadRate, 6)))
                          then TempRate := 0;

                        If (Roundoff(TempRate, 6) = 0)
                          then Print(#9)
                          else Print(#9 + FormatFloat(ExtendedDecimalDisplay,
                                                      TempRate));

                      end;  {with SDRatePointer(SDRateList[I])^ do}

                end;  {else of If IsTotalsRec}

            {FXX01021998-1: Putting the asterisk at the end of the wrong total.}
            {FXX01021998-9: If this is one extension of many, outdent 2
                            spaces to make the total more prominent.}
            {FXX05261998-6: Finish out the line if assessment roll.}

          If (RollType = 'X')
            then
              If (NumExtensionsThisSDCode > 1)
                then Println(#9 + FormatFloat(DecimalDisplay, TotalTax) + '  ')
                else Println(#9 + FormatFloat(DecimalDisplay, TotalTax))
            else Println('');

        end;  {with SDTotalsRec do}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintOneSDTotal}

{=======================================================================}
Procedure PrintTotalForMultipleExtensionSD(    Sender : TObject;
                                               SDCode : String;
                                               TotalTaxThisSDCode : Extended;
                                           var LineNo : Integer);

begin
    {FXX12291997-9: Reset the tabs for one SD tot
                    print in case of page break.}

  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {CODE}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {DIST NAME}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjLeft, TL4W, 0, BOXLINENONE, 0);   {EXT TYPE}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {EXT VALUE}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {AD VAL VALUE}
      SetTab(TL7, pjRight, TL7W, 0, BOXLINENONE, 0);   {EXEMPT AMT}
      SetTab(TL8, pjRight, TL8W, 0, BOXLINENONE, 0);   {TAXABLE VAL}
      SetTab(TL9, pjRight, TL9W, 0, BOXLINENONE, 0);   {TAX RATE}
      SetTab(TL10, pjRight, TL10W, 0, BOXLINENONE, 0);   {TOTAL TX}

      Println(#9 + #9 + #9 + #9 + #9 + #9 + #9 +
                   #9 + #9 + SDCode + ' TOTAL' +
                   #9 +
                   FormatFloat(DecimalDisplay, TotalTaxThisSDCode));

      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {If ((NumExtensionsThisSDCode > 1) and ...}

{FXX01021998-8: We need to pass in the sd code table to determine
                how many extensions each SD code has.}
{=======================================================================}
Function PrintSDTotals(    Sender : TObject;  {Report printer or filer object}
                            SDTotalsList,
                            SDRateList,
                            SDCodeDescList,
                            SDExtDescList : TList;
                            RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                            SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                            CollectionType : String;   {From here down is for printing the header.}
                            RollPrintingYear : String;
                            SDCodeTable,
                            AssessmentYearCtlTable : TTable;
                            SchoolCode,
                            SwisCode : String;
                            RollSection : String;
                            SchoolCodeDescList,
                            SwisCodeDescList : TList;
                            SequenceStr : String;
                            SDTotalsTable : TTable;
                            SelectedRollSections : TStringList;
                        var PageNo,
                            LineNo : Integer) : Extended;

{Print the special district totals in the TLists.}
{Note: To my knowledge, there is never any homestead or non-homestead
       SD's, but I will leave in the possiblity just in case.}

var
  TotalTaxThisSDCode : Extended;
  I, J, (*NumHomestead, *)HeaderSize,
  (*NumNonhomestead, *)NumExtensionsThisSDCode : Integer;
  HeaderPrinted, SubheaderPrinted, FirstSDCodePrinted, PrintThisSD, Quit : Boolean;
  _SDCode, LastSDCode : String;
  OverallSDTotalsList, HomesteadSDTotalsList, NonHomesteadSDTotalsList : TList;
  TempSDTotalRec : SDistTotRecord;
  TempFieldName : String;
  SectionHeader : String;

begin
  Quit := False;
  HeaderPrinted := False;
  (*NumHomestead := 0;
  NumNonhomestead := 0; *)
  LastSDCode := '';

  NonHomesteadSDTotalsList := TList.Create;
  HomesteadSDTotalsList := TList.Create;

 (* For I := 0 to (SDTotalsList.Count - 1) do
    with SDistTotPtr(SDTotalsList[I])^ do
      If (HomesteadCode = 'N')
        then NumNonhomestead := NumNonhomestead + 1
        else NumHomestead := NumHomestead + 1; *)

    {FXX04291998-9: For swis and municipal totals, print that for the header.
                    For roll section totals, print the roll secion name.}

  SectionHeader := GetSectionHeader(SectionType, RollSection);

  with Sender as TBaseReport do
    begin
        {First homestead part, but only if this is not a roll section summary.
         Note that we print the header and subheader only if there is an
         entry.}

        {FXX01081998-1: Since SD's are never homestead/non-homestead, just
                        comment out the code - it was causing problems.}
        {CHG12172004-1(2.8.1.4): Actually, Clarkstown has a homestead \ non-homestead dist.}

      If ((SectionType <> 'R') and
          GlblMunicipalityIsClassified)
        then
          begin
            SubheaderPrinted := False;

            LoadSDTotals(SDTotalsTable, CollectionType, HomesteadSDTotalsList,
                         SectionType, RollSection, SwisCode, SchoolCode,
                         'H', SelectedRollSections, Quit);

             {Initialize the temporary record for the totals for this
              subsection.}

            with TempSDTotalRec do
              begin
                ParcelCt := 0;
                PartCount := 0;
                Value := 0;
                ADValue := 0;
                ExemptAmt := 0;
                TaxableVal := 0;
                TotalTax := 0;

              end;  {with TempSDTotalRec do}

            OverallSDTotalsList := TList.Create;
            CombineSDTotals(HomesteadSDTotalsList, OverallSDTotalsList, 'H');
            LastSDCode := '';

            If (OverallSDTotalsList.Count = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'D', RollSection, LineNo);
                  PrintSDSubheader(Sender, RollType, 'H', LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO SPECIAL DISTRICT TOTALS AT THIS LEVEL');
                  Println('');
                  LineNo := LineNo + 3;
                end
              else
                begin
                  _SDCode := SDistTotPtr(OverallSDTotalsList[0])^.SDCode;

                    {FXX01021998-8: Use the sd code table to determine
                                    how many extensions each SD code has
                                    so that we don't print SD's with
                                    1 extension on 2 lines.}

                  FindKeyOld(SDCodeTable, ['SDistCode'], [_SDCode]);
                  PrintThisSD := SDCodeTable.FieldByName('SDHomestead').AsBoolean;
                  NumExtensionsThisSDCode := 0;

                  For J := 1 to 10 do
                    begin
                      TempFieldName := 'ECd' + IntToStr(J);
                      If (Trim(SDCodeTable.FieldByName(TempFieldName).Text) <> '')
                        then NumExtensionsThisSDCode := NumExtensionsThisSDCode + 1;

                    end;  {For J := 1 to 10 do}

                  TotalTaxThisSDCode := 0;
                  HeaderSize := 6;

                  For I := 0 to (OverallSDTotalsList.Count - 1) do
                    begin
                        {Do we need to go to a new page?}

                      with Sender as TBaseReport do
                        If ((NumLinesPerPage - LineNo - HeaderSize) < LinesAtBottom)
                          then
                            begin
                              StartNewPage(Sender, RollType,
                                           SchoolCode, SwisCode,
                                           SectionHeader,
                                           CollectionType,
                                           RollPrintingYear,
                                           AssessmentYearCtlTable,
                                           SchoolCodeDescList,
                                           SwisCodeDescList,
                                           SequenceStr,
                                           PageNo, LineNo);

                              PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                              HeaderPrinted := False;
                              SubheaderPrinted := False;

                            end;  {If (LinesLeft < 4)}

                      _SDCode := SDistTotPtr(OverallSDTotalsList[I])^.SDCode;

                        {If we changed SD codes, we may have to print a total
                         line if this is the tax roll.}

                        {FXX12291997-5: The individual SD total was being printed
                                        in the wrong place.}

                      If ((LastSDCode <> _SDCode) and
                          (Deblank(LastSDCode) <> ''))
                        then
                          begin
                            If ((NumExtensionsThisSDCode > 1) and
                                (RollType = 'X') and
                                PrintThisSD)
                              then PrintTotalForMultipleExtensionSD(Sender,
                                                                    LastSDCode,
                                                                    TotalTaxThisSDCode,
                                                                    LineNo);

                              {FXX01081998-2: Skip a line between all SD's.}

                            Println('');
                            LineNo := LineNo + 1;

                            TotalTaxThisSDCode := 0;

                              {FXX01021998-8: Use the sd code table to determine
                                              how many extensions each SD code has
                                              so that we don't print SD's with
                                              1 extension on 2 lines.}

                            FindKeyOld(SDCodeTable, ['SDistCode'], [_SDCode]);
                            PrintThisSD := SDCodeTable.FieldByName('SDHomestead').AsBoolean;

                            NumExtensionsThisSDCode := 0;

                            For J := 1 to 10 do
                              begin
                                TempFieldName := 'ECd' + IntToStr(J);
                                If (Deblank(SDCodeTable.FieldByName(TempFieldName).Text) <> '')
                                  then NumExtensionsThisSDCode := NumExtensionsThisSDCode + 1;

                              end;  {For J := 1 to 10 do}

                          end;  {If (LastSDCode <> SDistTotPtr(SDTotalsList[I])^.SDCode)}

                      If not HeaderPrinted
                        then
                          begin
                            PrintSectionHeader(Sender, 'D', RollSection, LineNo);
                            HeaderPrinted := True;
                          end;

                      If not SubHeaderPrinted
                        then
                          begin
                            PrintSDSubHeader(Sender, RollType, 'H', LineNo);
                            SubheaderPrinted := True;
                          end;

                      If PrintThisSD
                        then PrintOneSDTotal(Sender, RollType, ' ', SDRateList,
                                             SDCodeDescList, SDExtDescList,
                                             NumExtensionsThisSDCode, LastSDCode,
                                             SDistTotPtr(OverallSDTotalsList[I])^,
                                             LineNo);

                        {FXX01021998-7: Need to update the LastSDCode after
                                        printing one line, not before.}

                      LastSDCode := _SDCode;
                      TotalTaxThisSDCode := TotalTaxThisSDCode + SDistTotPtr(OverallSDTotalsList[I])^.TotalTax;

                      UpdateSDTaxTotals(SDistTotPtr(OverallSDTotalsList[I])^,
                                        TempSDTotalRec);

                    end;  {For I := 0 to OverallEXTotalsList do}

                        {Do we need to go to a new page?}

                    with Sender as TBaseReport do
                      If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                        then
                          begin
                            StartNewPage(Sender, RollType,
                                         SchoolCode, SwisCode,
                                         SectionHeader,
                                         CollectionType,
                                         RollPrintingYear,
                                         AssessmentYearCtlTable,
                                         SchoolCodeDescList,
                                         SwisCodeDescList,
                                         SequenceStr,
                                         PageNo, LineNo);

                            PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                            HeaderPrinted := False;
                            SubheaderPrinted := False;

                          end;  {If (LinesLeft < 4)}

                    {FXX01021998-10: If the last code has multiple extensions,
                                     don't forget to print the total.}

                  If ((NumExtensionsThisSDCode > 1) and
                      (RollType = 'X'))
                    then PrintTotalForMultipleExtensionSD(Sender,
                                                          LastSDCode,
                                                          TotalTaxThisSDCode,
                                                          LineNo);

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                    {FXX01191998-8: Don't print overall SD amount if assessment roll.}

                  If (RollType = 'X')
                    then
                      begin
                        If not HeaderPrinted
                          then
                            begin
                              PrintSectionHeader(Sender, 'D', RollSection, LineNo);
                              HeaderPrinted := True;
                            end;

                        If not SubHeaderPrinted
                          then PrintSDSubheader(Sender, RollType, SectionType, LineNo);

                          {Print the totals for this subsection.}

                        Println('');
                        LineNo := LineNo + 1;
                        PrintOneSDTotal(Sender, RollType, ' ', SDRateList,
                                        SDCodeDescList, SDExtDescList,
                                        0, 'TOTAL', TempSDTotalRec, LineNo);

                      end;  {If (RollType = 'X')}

                end;  {else of If (OverallSDTotalsList.Count = 0)}

            FreeTList(OverallSDTotalsList, SizeOf(SDistTotRecord));

          end;  {If ((SectionType <> 'R') and ...}

      If ((SectionType <> 'R') and
          GlblMunicipalityIsClassified)
        then
          begin
            SubheaderPrinted := False;

             {Initialize the temporary record for the totals for this
              subsection.}

            with TempSDTotalRec do
              begin
                ParcelCt := 0;
                Value := 0;
                ADValue := 0;
                ExemptAmt := 0;
                TaxableVal := 0;
                TotalTax := 0;

              end;  {with TempSDTotalRec do}

            LoadSDTotals(SDTotalsTable, CollectionType, NonHomesteadSDTotalsList,
                         SectionType, RollSection, SwisCode, SchoolCode,
                         'N', SelectedRollSections, Quit);

            OverallSDTotalsList := TList.Create;
            CombineSDTotals(NonHomesteadSDTotalsList, OverallSDTotalsList, 'N');
            LastSDCode := '';

            If (OverallSDTotalsList.Count = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'D', RollSection, LineNo);
                  PrintSDSubheader(Sender, RollType, 'N', LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO SPECIAL DISTRICT TOTALS AT THIS LEVEL');
                  Println('');
                  LineNo := LineNo + 3;
                end
              else
                begin
                  _SDCode := SDistTotPtr(OverallSDTotalsList[0])^.SDCode;

                    {FXX01021998-8: Use the sd code table to determine
                                    how many extensions each SD code has
                                    so that we don't print SD's with
                                    1 extension on 2 lines.}

                  FindKeyOld(SDCodeTable, ['SDistCode'], [_SDCode]);
                  PrintThisSD := SDCodeTable.FieldByName('SDHomestead').AsBoolean;
                  NumExtensionsThisSDCode := 0;

                  For J := 1 to 10 do
                    begin
                      TempFieldName := 'ECd' + IntToStr(J);
                      If (Trim(SDCodeTable.FieldByName(TempFieldName).Text) <> '')
                        then NumExtensionsThisSDCode := NumExtensionsThisSDCode + 1;

                    end;  {For J := 1 to 10 do}

                  TotalTaxThisSDCode := 0;
                  HeaderSize := 6;

                  For I := 0 to (OverallSDTotalsList.Count - 1) do
                    begin
                        {Do we need to go to a new page?}

                      with Sender as TBaseReport do
                        If ((NumLinesPerPage - LineNo - HeaderSize) < LinesAtBottom)
                          then
                            begin
                              StartNewPage(Sender, RollType,
                                           SchoolCode, SwisCode,
                                           SectionHeader,
                                           CollectionType,
                                           RollPrintingYear,
                                           AssessmentYearCtlTable,
                                           SchoolCodeDescList,
                                           SwisCodeDescList,
                                           SequenceStr,
                                           PageNo, LineNo);

                              PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                              HeaderPrinted := False;
                              SubheaderPrinted := False;

                            end;  {If (LinesLeft < 4)}

                      _SDCode := SDistTotPtr(OverallSDTotalsList[I])^.SDCode;

                        {If we changed SD codes, we may have to print a total
                         line if this is the tax roll.}

                        {FXX12291997-5: The individual SD total was being printed
                                        in the wrong place.}

                      If ((LastSDCode <> _SDCode) and
                          (Deblank(LastSDCode) <> ''))
                        then
                          begin
                            If ((NumExtensionsThisSDCode > 1) and
                                (RollType = 'X') and
                                PrintThisSD)
                              then PrintTotalForMultipleExtensionSD(Sender,
                                                                    LastSDCode,
                                                                    TotalTaxThisSDCode,
                                                                    LineNo);

                              {FXX01081998-2: Skip a line between all SD's.}

                            Println('');
                            LineNo := LineNo + 1;

                            TotalTaxThisSDCode := 0;

                              {FXX01021998-8: Use the sd code table to determine
                                              how many extensions each SD code has
                                              so that we don't print SD's with
                                              1 extension on 2 lines.}

                            FindKeyOld(SDCodeTable, ['SDistCode'], [_SDCode]);
                            PrintThisSD := SDCodeTable.FieldByName('SDHomestead').AsBoolean;

                            NumExtensionsThisSDCode := 0;

                            For J := 1 to 10 do
                              begin
                                TempFieldName := 'ECd' + IntToStr(J);
                                If (Deblank(SDCodeTable.FieldByName(TempFieldName).Text) <> '')
                                  then NumExtensionsThisSDCode := NumExtensionsThisSDCode + 1;

                              end;  {For J := 1 to 10 do}

                          end;  {If (LastSDCode <> SDistTotPtr(SDTotalsList[I])^.SDCode)}

                      If not HeaderPrinted
                        then
                          begin
                            PrintSectionHeader(Sender, 'D', RollSection, LineNo);
                            HeaderPrinted := True;
                          end;

                      If not SubHeaderPrinted
                        then
                          begin
                            PrintSDSubHeader(Sender, RollType, 'N', LineNo);
                            SubheaderPrinted := True;
                          end;

                      If PrintThisSD
                        then PrintOneSDTotal(Sender, RollType, ' ', SDRateList,
                                             SDCodeDescList, SDExtDescList,
                                             NumExtensionsThisSDCode, LastSDCode,
                                             SDistTotPtr(OverallSDTotalsList[I])^,
                                             LineNo);

                        {FXX01021998-7: Need to update the LastSDCode after
                                        printing one line, not before.}

                      LastSDCode := _SDCode;
                      TotalTaxThisSDCode := TotalTaxThisSDCode + SDistTotPtr(OverallSDTotalsList[I])^.TotalTax;

                      UpdateSDTaxTotals(SDistTotPtr(OverallSDTotalsList[I])^,
                                        TempSDTotalRec);

                    end;  {For I := 0 to OverallEXTotalsList do}

                        {Do we need to go to a new page?}

                    with Sender as TBaseReport do
                      If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                        then
                          begin
                            StartNewPage(Sender, RollType,
                                         SchoolCode, SwisCode,
                                         SectionHeader,
                                         CollectionType,
                                         RollPrintingYear,
                                         AssessmentYearCtlTable,
                                         SchoolCodeDescList,
                                         SwisCodeDescList,
                                         SequenceStr,
                                         PageNo, LineNo);

                            PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                            HeaderPrinted := False;
                            SubheaderPrinted := False;

                          end;  {If (LinesLeft < 4)}

                    {FXX01021998-10: If the last code has multiple extensions,
                                     don't forget to print the total.}

                  If ((NumExtensionsThisSDCode > 1) and
                      (RollType = 'X'))
                    then PrintTotalForMultipleExtensionSD(Sender,
                                                          LastSDCode,
                                                          TotalTaxThisSDCode,
                                                          LineNo);

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                    {FXX01191998-8: Don't print overall SD amount if assessment roll.}

                  If (RollType = 'X')
                    then
                      begin
                        If not HeaderPrinted
                          then
                            begin
                              PrintSectionHeader(Sender, 'D', RollSection, LineNo);
                              HeaderPrinted := True;
                            end;

                        If not SubHeaderPrinted
                          then PrintSDSubheader(Sender, RollType, SectionType, LineNo);

                          {Print the totals for this subsection.}

                        Println('');
                        LineNo := LineNo + 1;
                        PrintOneSDTotal(Sender, RollType, ' ', SDRateList,
                                        SDCodeDescList, SDExtDescList,
                                        0, 'TOTAL', TempSDTotalRec, LineNo);

                      end;  {If (RollType = 'X')}

                end;  {else of If (OverallSDTotalsList.Count = 0)}

            FreeTList(OverallSDTotalsList, SizeOf(SDistTotRecord));

          end;  {If ((SectionType <> 'R') and ...}

        {Finally, do the overall totals.}

      SubheaderPrinted := False;

       {Initialize the temporary record for the totals for this
        subsection.}

      with TempSDTotalRec do
        begin
          ParcelCt := 0;
          Value := 0;
          ADValue := 0;
          ExemptAmt := 0;
          TaxableVal := 0;
          TotalTax := 0;

        end;  {with TempSDTotalRec do}

      OverallSDTotalsList := TList.Create;
      CombineSDTotals(SDTotalsList, OverallSDTotalsList, '');
      LastSDCode := '';

      If (OverallSDTotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'D', RollSection, LineNo);
            PrintSDSubheader(Sender, RollType, SectionType, LineNo);
            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO SPECIAL DISTRICT TOTALS AT THIS LEVEL');
            Println('');
            LineNo := LineNo + 3;
          end
        else
          begin
            _SDCode := SDistTotPtr(OverallSDTotalsList[0])^.SDCode;

              {FXX01021998-8: Use the sd code table to determine
                              how many extensions each SD code has
                              so that we don't print SD's with
                              1 extension on 2 lines.}

            FindKeyOld(SDCodeTable, ['SDistCode'], [_SDCode]);
            NumExtensionsThisSDCode := 0;

            For J := 1 to 10 do
              begin
                TempFieldName := 'ECd' + IntToStr(J);
                If (Trim(SDCodeTable.FieldByName(TempFieldName).Text) <> '')
                  then NumExtensionsThisSDCode := NumExtensionsThisSDCode + 1;

              end;  {For J := 1 to 10 do}

            TotalTaxThisSDCode := 0;
            HeaderSize := 6;

            For I := 0 to (OverallSDTotalsList.Count - 1) do
              begin
                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                  If ((NumLinesPerPage - LineNo - HeaderSize) < LinesAtBottom)
                    then
                      begin
                        StartNewPage(Sender, RollType,
                                     SchoolCode, SwisCode,
                                     SectionHeader,
                                     CollectionType,
                                     RollPrintingYear,
                                     AssessmentYearCtlTable,
                                     SchoolCodeDescList,
                                     SwisCodeDescList,
                                     SequenceStr,
                                     PageNo, LineNo);

                        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                        HeaderPrinted := False;
                        SubheaderPrinted := False;

                      end;  {If (LinesLeft < 4)}

                _SDCode := SDistTotPtr(OverallSDTotalsList[I])^.SDCode;

                  {If we changed SD codes, we may have to print a total
                   line if this is the tax roll.}

                  {FXX12291997-5: The individual SD total was being printed
                                  in the wrong place.}

                If ((LastSDCode <> _SDCode) and
                    (Deblank(LastSDCode) <> ''))
                  then
                    begin
                      If ((NumExtensionsThisSDCode > 1) and
                          (RollType = 'X'))
                        then PrintTotalForMultipleExtensionSD(Sender,
                                                              LastSDCode,
                                                              TotalTaxThisSDCode,
                                                              LineNo);

                        {FXX01081998-2: Skip a line between all SD's.}

                      Println('');
                      LineNo := LineNo + 1;

                      TotalTaxThisSDCode := 0;

                        {FXX01021998-8: Use the sd code table to determine
                                        how many extensions each SD code has
                                        so that we don't print SD's with
                                        1 extension on 2 lines.}

                      FindKeyOld(SDCodeTable, ['SDistCode'], [_SDCode]);
                      NumExtensionsThisSDCode := 0;

                      For J := 1 to 10 do
                        begin
                          TempFieldName := 'ECd' + IntToStr(J);
                          If (Deblank(SDCodeTable.FieldByName(TempFieldName).Text) <> '')
                            then NumExtensionsThisSDCode := NumExtensionsThisSDCode + 1;

                        end;  {For J := 1 to 10 do}

                    end;  {If (LastSDCode <> SDistTotPtr(SDTotalsList[I])^.SDCode)}

                If not HeaderPrinted
                  then
                    begin
                      PrintSectionHeader(Sender, 'D', RollSection, LineNo);
                      HeaderPrinted := True;
                    end;

                If not SubHeaderPrinted
                  then
                    begin
                      PrintSDSubHeader(Sender, RollType, SectionType, LineNo);
                      SubheaderPrinted := True;
                    end;

                PrintOneSDTotal(Sender, RollType, ' ', SDRateList,
                                SDCodeDescList, SDExtDescList,
                                NumExtensionsThisSDCode, LastSDCode,
                                SDistTotPtr(OverallSDTotalsList[I])^,
                                LineNo);

                  {FXX01021998-7: Need to update the LastSDCode after
                                  printing one line, not before.}

                LastSDCode := _SDCode;
                TotalTaxThisSDCode := TotalTaxThisSDCode + SDistTotPtr(OverallSDTotalsList[I])^.TotalTax;

                UpdateSDTaxTotals(SDistTotPtr(OverallSDTotalsList[I])^,
                                  TempSDTotalRec);

              end;  {For I := 0 to OverallEXTotalsList do}

                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                  If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                    then
                      begin
                        StartNewPage(Sender, RollType,
                                     SchoolCode, SwisCode,
                                     SectionHeader,
                                     CollectionType,
                                     RollPrintingYear,
                                     AssessmentYearCtlTable,
                                     SchoolCodeDescList,
                                     SwisCodeDescList,
                                     SequenceStr,
                                     PageNo, LineNo);

                        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                        HeaderPrinted := False;
                        SubheaderPrinted := False;

                      end;  {If (LinesLeft < 4)}

              {FXX01021998-10: If the last code has multiple extensions,
                               don't forget to print the total.}

            If ((NumExtensionsThisSDCode > 1) and
                (RollType = 'X'))
              then PrintTotalForMultipleExtensionSD(Sender,
                                                    LastSDCode,
                                                    TotalTaxThisSDCode,
                                                    LineNo);

              {Make sure that if we had to switch pages between
               the details and the total line that we print the headers
               again.}

              {FXX01191998-8: Don't print overall SD amount if assessment roll.}

            If (RollType = 'X')
              then
                begin
                  If not HeaderPrinted
                    then PrintSectionHeader(Sender, 'D', RollSection, LineNo);

                  If not SubHeaderPrinted
                    then PrintSDSubheader(Sender, RollType, SectionType, LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  LineNo := LineNo + 1;
                  PrintOneSDTotal(Sender, RollType, ' ', SDRateList,
                                  SDCodeDescList, SDExtDescList,
                                  0, 'TOTAL', TempSDTotalRec, LineNo);

                end;  {If (RollType = 'X')}

          end;  {else of If (OverallSDTotalsList.Count = 0)}

      FreeTList(OverallSDTotalsList, SizeOf(SDistTotRecord));

    end;  {with Sender as TBaseReport do}

  FreeTList(HomesteadSDTotalsList, SizeOf(SDistTotRecord));
  FreeTList(NonHomesteadSDTotalsList, SizeOf(SDistTotRecord));

    {FXX06301998-5: Pass back the total SD amount for roll section 9 total tax
                    amount since there is no general tax.}

  Result := TempSDTotalRec.TotalTax;

end;  {PrintSDTotals}

{=======================================================================}
{==================  EXEMPTION TOTAL ROUNTINES  ========================}
{=======================================================================}
Function FoundEXRecord(    EXTotalsList : TList;
                           _EXCode : String;
                           _HomesteadCode : String;
                       var I : Integer) : Boolean;

{Search through the totals list for this EX code,
 and homestead code.}

var
  J : Integer;

begin
  Result := False;

  For J := 0 to (EXTotalsList.Count - 1) do
    with ExemptTotPtr(EXTotalsList[J])^ do
      If ((Take(5, EXCode) = Take(5, _EXCode)) and
          (Take(1, HomesteadCode) = Take(1, _HomesteadCode)))
        then
          begin
            Result := True;
            I := J;
          end;

end;  {FoundEXRecord}

{=======================================================================}
Procedure LoadEXTotals(    EXTotalsTable : TTable;
                           CollectionType : String;  {SC, MU, VI}
                           EXTotalsList : TList;  {Broken up by homestead and non-homestead.}
                           SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                           RollSection : String;
                           SwisCode,
                           SchoolCode : String;
                           SelectedRollSections : TStringList;
                       var Quit : Boolean);

{Load all the EX totals for this roll section, swis code, school code,
 (or all for grand totals) into two TLists which have EX amounts.
 One for homestead and one for non-homestead. If this is not a classified
 municipality, the totals will go in the homestead list.}

var
  FirstTimeThrough, Done : Boolean;
  EXTotalsPtr : ExemptTotPtr;
  I : Integer;

begin
  Done := False;
  FirstTimeThrough := True;

    {FXX04231998-10: Need to cancel last range so that munic totals don't show
                     swis totals.}

  EXTotalsTable.CancelRange;

    {Set the index and range of the EX table for this collection type.}

  with EXTotalsTable do
    If (CollectionHasSchoolTax and
        (CollectionType = 'SC'))
      then
        begin
          IndexName := 'BYSCHOOL_RS_HC_EXCODE';

          case SectionType of
            'R' : SetRangeOld(EXTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode', 'EXCode'],
                              [SchoolCode, SwisCode, RollSection, ' ', '     '],
                              [SchoolCode, SwisCode, RollSection, 'Z', '99999']);

            'S' : SetRangeOld(EXTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode', 'EXCode'],
                              [SchoolCode, SwisCode, '1', ' ', '     '],
                              [SchoolCode, SwisCode, '9', 'Z', '99999']);

            'C' : SetRangeOld(EXTotalsTable,
                              ['SchoolCode', 'SwisCode', 'RollSection', 'HomesteadCode', 'EXCode'],
                              [SchoolCode, '      ', '1', ' ', '     '],
                              [SchoolCode, '999999', '9', 'Z', '99999']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

        end
      else
        begin
          IndexName := 'BYSWIS_RS_HC_EXCODE';

          case SectionType of
            'R' : SetRangeOld(EXTotalsTable,
                              ['SwisCode', 'RollSection', 'HomesteadCode', 'EXCode'],
                              [SwisCode, RollSection, ' ', '     '],
                              [SwisCode, RollSection, 'Z', '99999']);
            'S' : SetRangeOld(EXTotalsTable,
                              ['SwisCode', 'RollSection', 'HomesteadCode', 'EXCode'],
                              [SwisCode, '1', ' ', '     '],
                              [SwisCode, '9', 'Z', '99999']);

              {No set range for Grand totals - will do all.}

          end;  {case SectionType of}

        end;  {else of If CollectionHasSchoolTax}

  try
    EXTotalsTable.First;
  except
    Quit := True;
    SystemSupport(800, EXTotalsTable, 'Error getting first EX totals record.',
                  'UTILBILL.PAS', GlblErrorDlgBox);
  end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        try
          EXTotalsTable.Next;
        except
          Quit := True;
          SystemSupport(800, EXTotalsTable, 'Error getting next EX totals record.',
                        'UTILBILL.PAS', GlblErrorDlgBox);
        end;

    If EXTotalsTable.EOF
      then Done := True;

      {FXX04241998-1: Only load the roll sections that we want in this section
                      of the roll.}

    If not Done
      then
        If (SelectedRollSections.IndexOf(EXTotalsTable.FieldByName('RollSection').Text) <> -1)
          then
            with EXTotalsTable do
              If FoundEXRecord(EXTotalsList,
                               FieldByName('EXCode').Text,
                               FieldByName('HomesteadCode').Text, I)
                then
                  begin
                    with ExemptTotPtr(EXTotalsList[I])^ do
                      begin
                        ParcelCt := ParcelCt + FieldByName('ParcelCt').AsInteger;
                        CountyExAmt := CountyExAmt + TCurrencyField(FieldByName('CountyEXAmt')).Value;
                        TownExAmt := TownExAmt + TCurrencyField(FieldByName('TownEXAmt')).Value;
                        VillageEXAmt := VillageExAmt + TCurrencyField(FieldByName('VillageEXAmt')).Value;
                        SchoolExAmt := SchoolExAmt + TCurrencyField(FieldByName('SchoolEXAmt')).Value;

                      end;  {with ExemptTotPtr(EXTotalsList[I])^ do}

                  end
                else
                  begin
                    New(EXTotalsPtr);   {get new pptr for tlist array}

                    with EXTotalsPtr^ do
                      begin
                        ParcelCt := FieldByName('ParcelCt').AsInteger;
                        SwisCode := FieldByName('SwisCode').Text;
                        SchoolCode := FieldByName('SchoolCode').Text;
                        RollSection := FieldByName('RollSection').Text;
                        HomesteadCode := FieldByName('HomesteadCode').Text;
                        EXCode := FieldByName('EXCode').Text;
                        CountyExAmt := TCurrencyField(FieldByName('CountyEXAmt')).Value;
                        TownExAmt := TCurrencyField(FieldByName('TownEXAmt')).Value;
                        VillageEXAmt := TCurrencyField(FieldByName('VillageEXAmt')).Value;
                        SchoolExAmt := TCurrencyField(FieldByName('SchoolEXAmt')).Value;

                      end;  {with EXTotalsPtr^ do}

                    EXTotalsList.Add(EXTotalsPtr);

                  end;  {else of If FoundEXRecord(EXTotalsList,}

  until (Done or Quit);

end;  {LoadEXTotals}

{=======================================================================}
Procedure CombineEXTotals(EXTotalsList,  {List with totals broken down into hstd, nonhstd.}
                          OverallTotalsList : TList);  {No hstd\nonhstd breakdown.}

{The totals entries in the EXTotalsList are broken down into homestead and
 nonhomestead, so we want to combine them for the overall totals. To do
 this, we will take the entries from the EXTotalsList and put them into the
 overall totals list, disregarding the homestead code.}

var
  I, J : Integer;
  EXTotalsPtr : ExemptTotPtr;

begin
  For I := 0 to (EXTotalsList.Count - 1) do
    with ExemptTotPtr(EXTotalsList[I])^ do
      If FoundEXRecord(OverallTotalsList, EXCode,
                       ' ', J)  {Don't use hstd code as a key.}
        then
          begin
            ExemptTotPtr(OverallTotalsList[J])^.ParcelCt :=
                     ExemptTotPtr(OverallTotalsList[J])^.ParcelCt + ParcelCt;
            ExemptTotPtr(OverallTotalsList[J])^.CountyExAmt :=
                     ExemptTotPtr(OverallTotalsList[J])^.CountyExAmt + CountyExAmt;
            ExemptTotPtr(OverallTotalsList[J])^.TownExAmt :=
                     ExemptTotPtr(OverallTotalsList[J])^.TownExAmt + TownExAmt;
            ExemptTotPtr(OverallTotalsList[J])^.VillageExAmt :=
                     ExemptTotPtr(OverallTotalsList[J])^.VillageExAmt + VillageExAmt;
            ExemptTotPtr(OverallTotalsList[J])^.SchoolExAmt :=
                     ExemptTotPtr(OverallTotalsList[J])^.SchoolExAmt + SchoolExAmt;

          end
        else
          begin
            New(EXTotalsPtr);   {get new pptr for tlist array}

            EXTotalsPtr^.SwisCode := SwisCode;
            EXTotalsPtr^.ParcelCt := ParcelCt;
            EXTotalsPtr^.SchoolCode := SchoolCode;
            EXTotalsPtr^.RollSection := RollSection;
            EXTotalsPtr^.HomesteadCode := ' ';  {Blank out hstd code.}
            EXTotalsPtr^.EXCode := EXCode;
            EXTotalsPtr^.CountyExAmt := CountyEXAmt;
            EXTotalsPtr^.TownExAmt := TownEXAmt;
            EXTotalsPtr^.VillageExAmt := VillageEXAmt;
            EXTotalsPtr^.SchoolExAmt := SchoolEXAmt;

            OverallTotalsList.Add(EXTotalsPtr);

          end;  {else of If FoundEXRecord(OverallTotalsList, EXCode, ExtCode, CMFlag,}

end;  {CombineEXTotals}

{=======================================================================}
Procedure UpdateEXTaxTotals(    SourceEXTotalsRec : ExemptTotRecord;
                            var TempEXTotalRec : ExemptTotRecord);

{Update the running totals in the TempEXTotalRec from the source
 rec.}

begin
  with TempEXTotalRec do
    begin
      ParcelCt := ParcelCt + SourceEXTotalsRec.ParcelCt;
      CountyExAmt := CountyExAmt + SourceEXTotalsRec.CountyExAmt;
      TownExAmt := TownExAmt + SourceEXTotalsRec.TownExAmt;
      SchoolExAmt := SchoolExAmt + SourceEXTotalsRec.SchoolExAmt;
      VillageExAmt := VillageExAmt + SourceEXTotalsRec.VillageExAmt;

    end;  {with TempEXTotalRec do}

end;  {UpdateEXTaxTotals}

{=======================================================================}
Procedure PrintEXSubheader(    Sender : TObject;  {Report printer or filer object}
                               RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                               SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                               MunicipalityType : String;
                           var LineNo : Integer);

{Print the individual EX totals section header and set the tabs for the
 EX amounts columns.}

begin
  with Sender as TBaseReport do
    begin
        {Roll section totals do not breakdown by hEXt\nonhstd so
         the following two lines are not needed.}

      If (SubheaderType <> 'R')
        then PrintSectionSubheader(Sender, SubheaderType, LineNo);

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {CODE}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjCenter, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjCenter, TL4W, 0, BOXLINENONE, 0);   {County amt}
      SetTab(TL5, pjCenter, TL5W, 0, BOXLINENONE, 0);   {City amt}
      SetTab(TL6, pjCenter, TL6W, 0, BOXLINENONE, 0);   {School amt}
      SetTab(TL7, pjCenter, TL7W, 0, BOXLINENONE, 0);   {Village amt}

      Println('');
      Println(#9 +
              #9 +
              #9 + 'TOTAL');

      LineNo := LineNo + 2;

         {FXX12291997-7: Only print the relevant exemption amounts.}

       Print(#9 + 'CODE' +
             #9 + 'DESCRIPTION' +
             #9 + 'PARCELS');

        {CHG10302000-1: Need to allow user to specify exactly which municipalities
                        print on the roll.}

       If (MunicipalityType = 'MU')
         then
           begin
             Print(#9 + 'COUNTY' +
                   #9 + 'CITY');

             If (mtpPartialVillage in MunicipalitiesToPrint)
               then Print(#9 + 'VILLAGE');

           end;  {If (MunicipalityType = 'MU')}

         {FXX06021998-5: Show STAR amounts on all assessment rolls.}

       If (CollectionHasSchoolTax or
           (RollType in ['F', 'T']))
         then
           If (mtpSchool in MunicipalitiesToPrint)
              then Print(#9 + 'SCHOOL')
              else Print(#9);

       If (MunicipalityType = 'VI')
         then
           begin
             If (mtpCounty in MunicipalitiesToPrint)
               then Print(#9 + 'COUNTY')
               else Print(#9);

             Print(#9 + #9 + 'VILLAGE');

           end;  {If (MunicipalityType = 'VI')}

       Println('');

       LineNo := LineNo + 1;

         {If this is a homestead or nonhomestead section,
          print that this is the total number of parcels and parts.}

       If (SubheaderType in ['H', 'N'])
         then
           begin
             Println(#9 + #9 + #9 + '& PARTS');
             LineNo := LineNo + 1;
           end;

       {FXX12291997-2: Print a blank line between the header and the start
                       of the information.}

      Println('');
      LineNo := LineNo + 1;

    end;  {with Sender as TBaseReport do}

end;  {PrintEXSubheader}

{=======================================================================}
Procedure PrintOneEXTotal(    Sender : TObject;  {Report printer or filer object}
                              RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                              SubheaderType : Char;  {(H)std, (N)onhstd, (S)wis, S(c)hool, (R)S, (G)rand}
                              MunicipalityType : String;
                              EXCodeDescList : TList;
                              EXTotalsRec : ExemptTotRecord;
                              IsTotalRecord : Boolean;  {Is this a 'TOTAL' line?}
                          var LineNo : Integer);

{Print one special district total.}

begin
  with Sender as TBaseReport do
    begin
        {Reset the tabs}

      ClearTabs;
      SetTab(TL1, pjLeft, TL1W, 0, BOXLINENONE, 0);   {CODE}
      SetTab(TL2, pjLeft, TL2W, 0, BOXLINENONE, 0);   {Desc}
      SetTab(TL3, pjRight, TL3W, 0, BOXLINENONE, 0);   {PRCL CNT}
      SetTab(TL4, pjRight, TL4W, 0, BOXLINENONE, 0);   {1st amt}
      SetTab(TL5, pjRight, TL5W, 0, BOXLINENONE, 0);   {2nd amt}
      SetTab(TL6, pjRight, TL6W, 0, BOXLINENONE, 0);   {3rd amt}
      SetTab(TL7, pjRight, TL7W, 0, BOXLINENONE, 0);   {4th amt}

      with EXTotalsRec do
        begin
          If IsTotalRecord
            then Print(#9 + #9 + 'TOTAL')
            else Print(#9 + EXCode +
                       #9 + Take(15, GetDescriptionFromList(EXCode, EXCodeDescList)));

          Print(#9 + IntToStr(ParcelCt));

            {FXX12291997-7: Only print the relevant exemption amounts.}
            {FXX01021997-14: The exemption amounts should have decimals.}

            {CHG10302000-1: Need to allow user to specify exactly which municipalities
                            print on the roll.}

           If (MunicipalityType = 'MU')
             then
               begin

                 If (mtpCounty in MunicipalitiesToPrint)
                   then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, CountyExAmt))
                   else Print(#9);

                 If (mtpTown in MunicipalitiesToPrint)
                   then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, TownExAmt))
                   else Print(#9);

                 If (mtpPartialVillage in MunicipalitiesToPrint)
                   then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, VillageExAmt))
                   else Print(#9);

               end;  {If (MunicipalityType = 'MU')}

             {FXX06021998-5: Show STAR amounts on all assessment rolls.}

           If (CollectionHasSchoolTax or
               (RollType in ['F', 'T']))
             then
               If (mtpSchool in MunicipalitiesToPrint)
                 then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, SchoolExAmt))
                 else Print(#9);

           If (MunicipalityType = 'VI')
             then
               begin
                 If (mtpCounty in MunicipalitiesToPrint)
                   then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, CountyExAmt))
                   else Print(#9);

                 If (mtpTown in MunicipalitiesToPrint)
                   then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, TownExAmt))
                   else Print(#9);

                 If (mtpPartialVillage in MunicipalitiesToPrint)
                   then Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, VillageExAmt))
                   else Print(#9);

               end;  {If (MunicipalityType = 'VI')}

          Println('');

        end;  {with EXTotalsRec do}

    end;  {with Sender as TBaseReport do}

  LineNo := LineNo + 1;

end;  {PrintOneEXTotal}

{=================================================================}
Procedure SortExemptionList(EXTotalsList : TList);

{FXX04231998-11: Sort the exemption totals list into the proper order.}

var
  OldKey, NewKey : String;
  I, J : Integer;
  TempPtr : ExemptTotPtr;

begin
  For I := 0 to (EXTotalsList.Count - 1) do
    begin
      OldKey := ExemptTotPtr(EXTotalsList[I])^.EXCode;

      For J := (I + 1) to (EXTotalsList.Count - 1) do
        begin
          NewKey := ExemptTotPtr(EXTotalsList[J])^.EXCode;

          If (NewKey < OldKey)
            then
              begin
                TempPtr := EXTotalsList[I];
                EXTotalsList[I] := EXTotalsList[J];
                EXTotalsList[J] := TempPtr;
                OldKey := NewKey;

              end;  {If (NewKey < OldKey)}

        end;  {For J := (I + 1) to (EXTotalsList.Count - 1) do}

    end;  {For I := 0 to (EXTotalsList.Count - 1) do}

end;  {SortExemptionList}

{=======================================================================}
Procedure PrintEXTotals(    Sender : TObject;  {Report printer or filer object}
                            EXTotalsList,
                            EXCodeDescList : TList;
                            RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                            SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                            CollectionType : String;   {From here down is for printing the header.}
                            RollPrintingYear : String;
                            AssessmentYearCtlTable : TTable;
                            SchoolCode,
                            SwisCode : String;
                            RollSection : String;
                            SchoolCodeDescList,
                            SwisCodeDescList : TList;
                            SequenceStr : String;
                        var PageNo,
                            LineNo : Integer);

{Print the exemption totals in the TLists.}

var
  I, NumHomestead, NumNonhomestead, HeaderSize : Integer;
  HeaderPrinted, SubheaderPrinted : Boolean;
  OverallEXTotalsList : TList;
  TempEXTotalRec : ExemptTotRecord;
  SectionHeader : String;

begin
  HeaderPrinted := False;
  NumHomestead := 0;
  NumNonhomestead := 0;

  For I := 0 to (EXTotalsList.Count - 1) do
    with ExemptTotPtr(EXTotalsList[I])^ do
      If (HomesteadCode = 'N')
        then NumNonhomestead := NumNonhomestead + 1
        else NumHomestead := NumHomestead + 1;

    {FXX04231998-11: Sort the exemption totals list into the proper order.}

  SortExemptionList(EXTotalsList);

    {FXX04291998-9: For swis and municipal totals, print that for the header.
                    For roll section totals, print the roll secion name.}

  SectionHeader := GetSectionHeader(SectionType, RollSection);

  HeaderSize := 8;

    {FXX08232004-2(2.08.0.08302004): Fix up page breaks on the roll.}

  with Sender as TBaseReport do
    begin
        {Do we need to go to a new page?}

      If ((NumLinesPerPage - LineNo - HeaderSize) < LinesAtBottom)
        then
          begin
            StartNewPage(Sender, RollType,
                         SchoolCode, SwisCode,
                         SectionHeader,
                         CollectionType,
                         RollPrintingYear,
                         AssessmentYearCtlTable,
                         SchoolCodeDescList,
                         SwisCodeDescList,
                         SequenceStr,
                         PageNo, LineNo);

            PrintTotalsPageSubheader(Sender, SectionType, LineNo);

            HeaderPrinted := False;

          end;  {If (LinesLeft < 4)}

        {First homestead part, but only if this is not a roll section summary.
         Note that we print the header and subheader only if there is an
         entry.}

        {FXX04231998-7: Don't print hstd/non-hstd if not classified.}
        {FXX04241998-3: Shouldn't have a "not" in front of GlblMunicipalityIsClassified.}

      If ((SectionType <> 'R') and
          GlblMunicipalityIsClassified)
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempEXTotalRec do
              begin
                ParcelCt := 0;
                CountyExAmt := 0;
                TownExAmt := 0;
                SchoolExAmt := 0;
                VillageExAmt := 0;

              end;  {with TempEXTotalRec do}

            If (NumHomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'X', RollSection, LineNo);
                  PrintEXSubheader(Sender, RollType, 'H', CollectionType, LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO EXEMPTIONS AT THIS LEVEL');
                  Println('');
                  LineNo := LineNo + 3;
                end
              else
                begin
                  If ((NumLinesPerPage - LineNo - HeaderSize) < LinesAtBottom)
                    then
                      begin
                        StartNewPage(Sender, RollType,
                                     SchoolCode, SwisCode,
                                     SectionHeader,
                                     CollectionType,
                                     RollPrintingYear,
                                     AssessmentYearCtlTable,
                                     SchoolCodeDescList,
                                     SwisCodeDescList,
                                     SequenceStr,
                                     PageNo, LineNo);

                        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                        HeaderPrinted := False;
                        SubheaderPrinted := False;

                      end;  {If (LinesLeft < 4)}

                  For I := 0 to (EXTotalsList.Count - 1) do
                    If (ExemptTotPtr(EXTotalsList[I])^.HomesteadCode[1] in ['H', ' '])
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'X', RollSection, LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintEXSubheader(Sender, RollType, 'H',
                                                 CollectionType, LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneEXTotal(Sender, RollType, 'H',
                                          CollectionType,
                                          EXCodeDescList,
                                          ExemptTotPtr(EXTotalsList[I])^,
                                          False, LineNo);

                            {Do we need to go to a new page?}
                            {FXX04231998-9: Instead of print the roll section hdr for
                                            the totals sections, print the section type.}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, RollType,
                                             SchoolCode, SwisCode,
                                             SectionHeader,
                                             CollectionType,
                                             RollPrintingYear,
                                             AssessmentYearCtlTable,
                                             SchoolCodeDescList,
                                             SwisCodeDescList,
                                             SequenceStr,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateEXTaxTotals(ExemptTotPtr(EXTotalsList[I])^,
                                            TempEXTotalRec);

                        end;  {If (ExemptTotPtr(EXTotalsList[I])^.HomesteadCode in ['H', ' '])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'X', RollSection, LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintEXSubheader(Sender, RollType, 'H', CollectionType, LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  LineNo := LineNo + 1;
                  PrintOneEXTotal(Sender, RollType, 'H', CollectionType,
                                  EXCodeDescList,
                                  TempEXTotalRec, True, LineNo);

                end;  {else of If (NumHomestead = 0)}

          end;  {If (SectionType <> 'R')}

        {FXX04241998-6: Don't print if not classified.}
        {Now the non-homestead part, if these are not roll section totals.}

      If ((SectionType <> 'R') and
          GlblMunicipalityIsClassified)
        then
          begin
            SubheaderPrinted := False;

              {Initialize the temporary record for the totals for this
               subsection.}

            with TempEXTotalRec do
              begin
                ParcelCt := 0;
                CountyExAmt := 0;
                TownExAmt := 0;
                SchoolExAmt := 0;
                VillageExAmt := 0;

              end;  {with TempEXTotalRec do}

            If (NumNonhomestead = 0)
              then
                begin
                  Println('');
                  PrintSectionHeader(Sender, 'X', RollSection, LineNo);
                  PrintEXSubheader(Sender, RollType, 'N', CollectionType, LineNo);
                  ClearTabs;
                  SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
                  Println(#9 + 'NO EXEMPTIONS AT THIS LEVEL');
                  Println('');
                  LineNo := LineNo + 3;
                end
              else
                begin
                  If ((NumLinesPerPage - LineNo - HeaderSize) < LinesAtBottom)
                    then
                      begin
                        StartNewPage(Sender, RollType,
                                     SchoolCode, SwisCode,
                                     SectionHeader,
                                     CollectionType,
                                     RollPrintingYear,
                                     AssessmentYearCtlTable,
                                     SchoolCodeDescList,
                                     SwisCodeDescList,
                                     SequenceStr,
                                     PageNo, LineNo);

                        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                        HeaderPrinted := False;
                        SubheaderPrinted := False;

                      end;  {If (LinesLeft < 4)}

                  For I := 0 to (EXTotalsList.Count - 1) do
                    If (ExemptTotPtr(EXTotalsList[I])^.HomesteadCode[1] = 'N')
                      then
                        begin
                          If not HeaderPrinted
                            then
                              begin
                                PrintSectionHeader(Sender, 'X', RollSection, LineNo);
                                HeaderPrinted := True;
                              end;

                          If not SubHeaderPrinted
                            then
                              begin
                                PrintEXSubheader(Sender, RollType, 'N',
                                                 CollectionType, LineNo);
                                SubheaderPrinted := True;
                              end;

                          PrintOneEXTotal(Sender, RollType, 'N',
                                          CollectionType,
                                          EXCodeDescList,
                                          ExemptTotPtr(EXTotalsList[I])^,
                                          False, LineNo);

                            {Do we need to go to a new page?}

                          If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                            then
                              begin
                                StartNewPage(Sender, RollType,
                                             SchoolCode, SwisCode,
                                             SectionHeader,
                                             CollectionType,
                                             RollPrintingYear,
                                             AssessmentYearCtlTable,
                                             SchoolCodeDescList,
                                             SwisCodeDescList,
                                             SequenceStr,
                                             PageNo, LineNo);

                                PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                                HeaderPrinted := False;
                                SubheaderPrinted := False;

                              end;  {If (LinesLeft < 4)}

                          UpdateEXTaxTotals(ExemptTotPtr(EXTotalsList[I])^,
                                            TempEXTotalRec);

                        end;  {If (ExemptTotPtr(EXTotalsList[I])^.HomesteadCode in ['N'])}

                    {Make sure that if we had to switch pages between
                     the details and the total line that we print the headers
                     again.}

                  If not HeaderPrinted
                    then
                      begin
                        PrintSectionHeader(Sender, 'X', RollSection, LineNo);
                        HeaderPrinted := True;
                      end;

                  If not SubHeaderPrinted
                    then PrintEXSubheader(Sender, RollType, 'N', CollectionType, LineNo);

                    {Print the totals for this subsection.}

                  Println('');
                  LineNo := LineNo + 1;
                  PrintOneEXTotal(Sender, RollType, 'N',
                                  CollectionType, EXCodeDescList,
                                  TempEXTotalRec, True, LineNo);

                end;  {else of If (NumNonhomestead = 0)}

              end;  {If (SectionType <> 'R')}

        {Finally, do the overall totals.}

      SubheaderPrinted := False;

      OverallEXTotalsList := TList.Create;
      CombineEXTotals(EXTotalsList, OverallEXTotalsList);

        {FXX04231998-11: Sort the exemption totals list into the proper order.}

      SortExemptionList(OverallEXTotalsList);

       {Initialize the temporary record for the totals for this
        subsection.}

      with TempEXTotalRec do
        begin
          ParcelCt := 0;
          CountyExAmt := 0;
          TownExAmt := 0;
          SchoolExAmt := 0;
          VillageExAmt := 0;

        end;  {with TempEXTotalRec do}

      If (OverallEXTotalsList.Count = 0)
        then
          begin
            Println('');
            PrintSectionHeader(Sender, 'X', RollSection, LineNo);
            PrintEXSubheader(Sender, RollType, SectionType, CollectionType, LineNo);
            ClearTabs;
            SetTab(4.5, pjCenter, 5.0, 0, BOXLINENONE, 0);   {HDR}
            Println(#9 + 'NO EXEMPTIONS AT THIS LEVEL');
            Println('');
            LineNo := LineNo + 3;
          end
        else
          begin
            If ((NumLinesPerPage - LineNo - HeaderSize) < LinesAtBottom)
              then
                begin
                  StartNewPage(Sender, RollType,
                               SchoolCode, SwisCode,
                               SectionHeader,
                               CollectionType,
                               RollPrintingYear,
                               AssessmentYearCtlTable,
                               SchoolCodeDescList,
                               SwisCodeDescList,
                               SequenceStr,
                               PageNo, LineNo);

                  PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                  HeaderPrinted := False;
                  SubheaderPrinted := False;

                end;  {If (LinesLeft < 4)}

            For I := 0 to (OverallEXTotalsList.Count - 1) do
              begin
                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                  If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                    then
                      begin
                        StartNewPage(Sender, RollType,
                                     SchoolCode, SwisCode,
                                     SectionHeader,
                                     CollectionType,
                                     RollPrintingYear,
                                     AssessmentYearCtlTable,
                                     SchoolCodeDescList,
                                     SwisCodeDescList,
                                     SequenceStr,
                                     PageNo, LineNo);

                        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                        HeaderPrinted := False;
                        SubheaderPrinted := False;

                      end;  {If (LinesLeft < 4)}

                If not HeaderPrinted
                  then
                    begin
                      PrintSectionHeader(Sender, 'X', RollSection, LineNo);
                      HeaderPrinted := True;
                    end;

                If not SubHeaderPrinted
                  then
                    begin
                      PrintEXSubHeader(Sender, RollType, SectionType,
                                       CollectionType, LineNo);
                      SubheaderPrinted := True;
                    end;

                PrintOneEXTotal(Sender, RollType, ' ',
                                CollectionType, EXCodeDescList,
                                ExemptTotPtr(OverallEXTotalsList[I])^,
                                False, LineNo);

                UpdateEXTaxTotals(ExemptTotPtr(OverallEXTotalsList[I])^,
                                  TempEXTotalRec);

              end;  {For I := 0 to OverallEXTotalsList do}

              {Make sure that if we had to switch pages between
               the details and the total line that we print the headers
               again.}

                  {Do we need to go to a new page?}

                with Sender as TBaseReport do
                  If ((NumLinesPerPage - LineNo) < LinesAtBottom)
                    then
                      begin
                        StartNewPage(Sender, RollType,
                                     SchoolCode, SwisCode,
                                     SectionHeader,
                                     CollectionType,
                                     RollPrintingYear,
                                     AssessmentYearCtlTable,
                                     SchoolCodeDescList,
                                     SwisCodeDescList,
                                     SequenceStr,
                                     PageNo, LineNo);

                        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

                        HeaderPrinted := False;
                        SubheaderPrinted := False;

                      end;  {If (LinesLeft < 4)}

            If not HeaderPrinted
              then PrintSectionHeader(Sender, 'X', RollSection, LineNo);

            If not SubHeaderPrinted
              then PrintEXSubheader(Sender, RollType, SectionType, CollectionType, LineNo);

              {Print the totals for this subsection.}

            Println('');
            LineNo := LineNo + 1;
            PrintOneEXTotal(Sender, RollType, SectionType,
                            CollectionType, EXCodeDescList,
                            TempEXTotalRec, True, LineNo);

          end;  {else of If (OverallEXTotalsList.Count = 0)}

      FreeTList(OverallEXTotalsList, SizeOf(ExemptTotRecord));

    end;  {with Sender as TBaseReport do}

end;  {PrintEXTotals}

{FXX01021998-8: We need to pass in the sd code table to determine
                how many extensions each SD code has.}
{=======================================================================}
Function PrintSectionTotals(    Sender : TObject;  {Report printer or filer object}
                                RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                RollSection : String;
                                SwisCode,
                                SchoolCode : String;
                                GeneralRateList,
                                SDRateList,
                                SpecialFeeRateList,
                                GnTaxList,
                                SDTaxList,
                                SpFeeTaxList,
                                ExTaxList : TList;
                                GeneralTotalsTable,
                                SchoolTotalsTable,
                                EXTotalsTable,
                                SDTotalsTable,
                                SpecialFeeTotalsTable : TTable;
                                CollectionType : String;
                                RollPrintingYear : String;
                                SDCodeTable,
                                AssessmentYearCtlTable : TTable;
                                SDCodeDescList,  {Description lists}
                                SDExtCodeDescList,
                                EXCodeDescList,
                                SchoolCodeDescList,
                                SwisCodeDescList,
                                RollSectionList : TList;
                                SelectedRollSections : TStringList;
                                SequenceStr : String;  {Text for what order roll is printing in.}
                            var ParcelPrintedThisPage : Boolean;
                            var PageNo,
                                LineNo : Integer;
                            var Quit : Boolean) : Extended;

{Print the totals for this roll section, swis, school, or end of report
 break.}
{FXX04291998-4: Figure out the total tax for these roll sections, so make this
                a function that returns that amount.}

var
  SDTotalsList,
  EXTotalsList,
  SchoolTotalsList,
  GeneralTotalsList,
  SpecialFeeTotalsList : TList;
  TempInt : Word;
  SectionHeader : String;
  TotalSDTax, TotalTax : Extended;
  I : Integer;

begin
  TotalTax := 0;
  TotalSDTax := 0;
  SDTotalsList := TList.Create;
  EXTotalsList := TList.Create;
  SchoolTotalsList := TList.Create;
  GeneralTotalsList := TList.Create;
  SpecialFeeTotalsList := TList.Create;

    {FXX11291999-4: In order to allow city and school at the same time,
                    check the tax type of the individual line.}

  CollectionHasSchoolTax := False;

  If (RollType = 'X')
    then
      For I := 0 to (GeneralRateList.Count - 1) do
        with GeneralRatePointer(GeneralRateList[I])^ do
          If (GeneralTaxType = 'SC')
            then CollectionHasSchoolTax := True;

    {First load the totals.}
    {FXX04241998-1: Only load the roll sections that we want in this section
                    of the roll.}

  If (RollType = 'X')
    then LoadGeneralTaxTotals(GeneralTotalsTable, CollectionType, GeneralTotalsList,
                              SectionType, RollSection, SwisCode, SchoolCode,
                              SelectedRollSections, Quit)
    else LoadGeneralAssessmentTotals(GeneralTotalsTable, CollectionType, GeneralTotalsList,
                                     SectionType, RollSection, SwisCode, SchoolCode,
                                     SelectedRollSections, Quit);

  LoadSchoolTotals(SchoolTotalsTable, CollectionType, SchoolTotalsList,
                   SectionType, RollSection, SwisCode, SchoolCode,
                   SelectedRollSections, Quit);

  LoadSDTotals(SDTotalsTable, CollectionType, SDTotalsList,
               SectionType, RollSection, SwisCode, SchoolCode,
               '', SelectedRollSections, Quit);

  LoadEXTotals(EXTotalsTable, CollectionType, EXTotalsList,
               SectionType, RollSection, SwisCode, SchoolCode,
               SelectedRollSections, Quit);

  LoadSpecialFeeTotals(SpecialFeeTotalsTable, CollectionType, SpecialFeeTotalsList,
                       SectionType, RollSection, SwisCode, SchoolCode,
                       SelectedRollSections, Quit);

    {FXX06181998-5: Don't print any totals if no parcels for this set of
                    selected roll sections.}
    {FXX06301998-3: If this is roll section 9, there are no general totals,
                    so we were skipping the sd print.}
    {FXX12102002-1: For Clarkstown, there are no base taxes - only SDs.}

  If ((GeneralTotalsList.Count > 0) or
      (SDTotalsList.Count > 0) or
      ((RollSection = '9') and
       (SDTotalsList.Count > 0)))
    then
      begin
          {FXX06291998-2: Start a new page for swis, school, municipal tots.}

        SectionHeader := GetSectionHeader(SectionType, RollSection);

        with Sender as TBaseReport do
          If (ParcelPrintedThisPage or
              (SectionType in ['S', 'C', 'G']))
            then
              begin
                If ParcelPrintedThisPage
                  then PrintEndingParcelLine(Sender);

                 {FXX04231998-9: Instead of print the roll section hdr for
                                 the totals sections, print the section type.}
                  {FXX04291998-9: For swis and municipal totals, print that for the header.
                                  For roll section totals, print the roll secion name.}

                StartNewPage(Sender, RollType, SchoolCode, SwisCode,
                             SectionHeader, CollectionType,
                             RollPrintingYear, AssessmentYearCtlTable,
                             SchoolCodeDescList,
                             SwisCodeDescList, SequenceStr,
                             PageNo, LineNo);

              end;  {If ParcelPrintedThisPage}

        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

        TotalSDTax :=
           PrintSDTotals(Sender, SDTotalsList, SDRateList, SDCodeDescList,
                         SDExtCodeDescList, RollType, SectionType,
                         CollectionType, RollPrintingYear,
                         SDCodeTable, AssessmentYearCtlTable,
                         SchoolCode, SwisCode, RollSection,
                         SchoolCodeDescList, SwisCodeDescList,
                         SequenceStr, SDTotalsTable, SelectedRollSections, PageNo, LineNo);

          {FXX06011998-2: Only print SD totals for roll section 9.}

        If (RollSection <> '9')
          then
            begin
              If (SchoolTotalsList.Count > 0)
                then PrintSchoolTotals(Sender, SchoolTotalsList,
                                       RollType, SectionType, CollectionType,
                                       RollPrintingYear, AssessmentYearCtlTable,
                                       SchoolCode, SwisCode, RollSection,
                                       SchoolCodeDescList, SwisCodeDescList,
                                       SequenceStr, PageNo, LineNo);

              PrintEXTotals(Sender, EXTotalsList, EXCodeDescList, RollType, SectionType,
                            CollectionType, RollPrintingYear,
                            AssessmentYearCtlTable,
                            SchoolCode, SwisCode, RollSection,
                            SchoolCodeDescList, SwisCodeDescList,
                            SequenceStr, PageNo, LineNo);

              If (GeneralTotalsList.Count > 0)
                then
                  If (RollType = 'X')
                    then PrintGeneralTaxRollTotals(Sender, GeneralTotalsList, SpecialFeeTotalsList,
                                                   SpecialFeeRateList, GeneralRateList,
                                                   RollSectionList, SDTotalsList,
                                                   RollType, SectionType,
                                                   CollectionType, RollPrintingYear,
                                                   AssessmentYearCtlTable,
                                                   SchoolCode, SwisCode,
                                                   SchoolCodeDescList, SwisCodeDescList,
                                                   SequenceStr, PageNo, LineNo, TotalTax)
                    else PrintGeneralAssessmentRollTotals(Sender, GeneralTotalsList, RollSectionList,
                                                          RollType, SectionType,
                                                          CollectionType, RollPrintingYear,
                                                          AssessmentYearCtlTable,
                                                          SchoolCode, SwisCode,
                                                          RollSection,
                                                          SchoolCodeDescList, SwisCodeDescList,
                                                          SequenceStr, PageNo, LineNo);

            end;  {If (RollSection <> '9')}

        with Sender as TBaseReport do
          Println('');
        LineNo := LineNo + 1;

      end;  {If (GeneralTotalsList.Count > 0)}

     {FXX06301998-5: Pass back the total SD amount for roll section 9 total tax
                     amount since there is no general tax.}
     {FXX12102002-1: Clarkstown special special billing has only SDs.}
     {FXX07232003-1(2.07g): This statement was after the GeneralTotalsList was freed - should be before.}

  If ((RollSection = '9') or
      (GeneralTotalsList.Count = 0))
    then Result := TotalSDTax
    else Result := TotalTax;

  FreeTList(SDTotalsList, SizeOf(SDistTotRecord));
  FreeTList(EXTotalsList, SizeOf(ExemptTotRecord));
  FreeTList(SchoolTotalsList, SizeOf(SchoolTotRecord));

    {FXX01191998-3: Need to free up the general totals record according
                    to which type it is.}

  If (RollType = 'X')
    then FreeTList(GeneralTotalsList, SizeOf(GeneralTotRecord))
    else FreeTList(GeneralTotalsList, SizeOf(GeneralAssessmentTotRecord));

  FreeTList(SpecialFeeTotalsList, SizeOf(SPFeeTotRecord));

  ParcelPrintedThisPage := False;

end;  {PrintSectionTotals}

{=======================================================================}
Function PrintSectionTotals_FromTotalsLists(    Sender : TObject;  {Report printer or filer object}
                                                RollType : Char; {'X' = Tax roll, 'T' = tenative assessment, 'F' = Final}
                                                SectionType : Char;  {(R)oll section, (S)wis, S(c)hool, (G)rand}
                                                RollSection : String;
                                                SwisCode : String;
                                                SchoolCode : String;
                                                LastCooperative : String;
                                                GeneralRateList,
                                                SDRateList,
                                                SpecialFeeRateList,
                                                SDTotalsList,
                                                EXTotalsList,
                                                SchoolTotalsList,
                                                GeneralTotalsList,
                                                SpecialFeeTotalsList : TList;
                                                CollectionType : String;
                                                RollPrintingYear : String;
                                                SDCodeTable,
                                                AssessmentYearCtlTable : TTable;
                                                SDCodeDescList,  {Description lists}
                                                SDExtCodeDescList,
                                                EXCodeDescList,
                                                SchoolCodeDescList,
                                                SwisCodeDescList,
                                                RollSectionList : TList;
                                                SelectedRollSections : TStringList;
                                                SequenceStr : String;  {Text for what order roll is printing in.}
                                            var ParcelPrintedThisPage : Boolean;
                                            var PageNo,
                                                LineNo : Integer;
                                            var Quit : Boolean) : Extended;

{Print the totals for this roll section, swis, school, or end of report
 break.}
{FXX04291998-4: Figure out the total tax for these roll sections, so make this
                a function that returns that amount.}

var
  TempInt : Word;
  SectionHeader : String;
  TotalSDTax, TotalTax : Extended;
  I : Integer;

begin
  TotalTax := 0;
  TotalSDTax := 0;

    {FXX11291999-4: In order to allow city and school at the same time,
                    check the tax type of the individual line.}

  CollectionHasSchoolTax := False;

  If (RollType = 'X')
    then
      For I := 0 to (GeneralRateList.Count - 1) do
        with GeneralRatePointer(GeneralRateList[I])^ do
          If (GeneralTaxType = 'SC')
            then CollectionHasSchoolTax := True;

  If ((GeneralTotalsList.Count > 0) or
      (SDTotalsList.Count > 0) or
      (EXTotalsList.Count > 0) or
      ((RollSection = '9') and
       (SDTotalsList.Count > 0)))
    then
      begin
          {FXX06291998-2: Start a new page for swis, school, municipal tots.}

        SectionHeader := GetSectionHeader(SectionType, RollSection);

        with Sender as TBaseReport do
          If (ParcelPrintedThisPage or
              (SectionType in ['S', 'C', 'G']))
            then
              begin
                If ParcelPrintedThisPage
                  then PrintEndingParcelLine(Sender);

                 {FXX04231998-9: Instead of print the roll section hdr for
                                 the totals sections, print the section type.}
                  {FXX04291998-9: For swis and municipal totals, print that for the header.
                                  For roll section totals, print the roll secion name.}

                StartNewPage(Sender, RollType, SchoolCode, SwisCode,
                             SectionHeader, CollectionType,
                             RollPrintingYear, AssessmentYearCtlTable,
                             SchoolCodeDescList,
                             SwisCodeDescList, SequenceStr,
                             PageNo, LineNo);

              end;  {If ParcelPrintedThisPage}

        with Sender as TBaseReport do
          begin
            Println(#9 + #9 + 'COOPERATIVE: ' + LastCooperative);
            Println('');
            Inc(LineNo, 2);
          end;

        PrintTotalsPageSubheader(Sender, SectionType, LineNo);

(*        TotalSDTax :=
           PrintSDTotals(Sender, SDTotalsList, SDRateList, SDCodeDescList,
                         SDExtCodeDescList, RollType, SectionType,
                         CollectionType, RollPrintingYear,
                         SDCodeTable, AssessmentYearCtlTable,
                         SchoolCode, SwisCode, RollSection,
                         SchoolCodeDescList, SwisCodeDescList,
                         SequenceStr, SDTotalsTable, SelectedRollSections, PageNo, LineNo); *)

          {FXX06011998-2: Only print SD totals for roll section 9.}

        If (RollSection <> '9')
          then
            begin
              If (SchoolTotalsList.Count > 0)
                then PrintSchoolTotals(Sender, SchoolTotalsList,
                                       RollType, SectionType, CollectionType,
                                       RollPrintingYear, AssessmentYearCtlTable,
                                       SchoolCode, SwisCode, RollSection,
                                       SchoolCodeDescList, SwisCodeDescList,
                                       SequenceStr, PageNo, LineNo);

              PrintEXTotals(Sender, EXTotalsList, EXCodeDescList, RollType, SectionType,
                            CollectionType, RollPrintingYear,
                            AssessmentYearCtlTable,
                            SchoolCode, SwisCode, RollSection,
                            SchoolCodeDescList, SwisCodeDescList,
                            SequenceStr, PageNo, LineNo);

              If (GeneralTotalsList.Count > 0)
                then PrintGeneralTaxRollTotals(Sender, GeneralTotalsList, SpecialFeeTotalsList,
                                               SpecialFeeRateList, GeneralRateList,
                                               RollSectionList, SDTotalsList,
                                               RollType, SectionType,
                                               CollectionType, RollPrintingYear,
                                               AssessmentYearCtlTable,
                                               SchoolCode, SwisCode,
                                               SchoolCodeDescList, SwisCodeDescList,
                                               SequenceStr, PageNo, LineNo, TotalTax);

            end;  {If (RollSection <> '9')}

        with Sender as TBaseReport do
          Println('');
        LineNo := LineNo + 1;

      end;  {If (GeneralTotalsList.Count > 0)}

     {FXX06301998-5: Pass back the total SD amount for roll section 9 total tax
                     amount since there is no general tax.}
     {FXX12102002-1: Clarkstown special special billing has only SDs.}
     {FXX07232003-1(2.07g): This statement was after the GeneralTotalsList was freed - should be before.}

  If ((RollSection = '9') or
      (GeneralTotalsList.Count = 0))
    then Result := TotalSDTax
    else Result := TotalTax;

  ParcelPrintedThisPage := False;

end;  {PrintSectionTotals}


INITIALIZATION
begin
end;

end.