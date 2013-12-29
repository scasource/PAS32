unit Rpasrutl;

{More of the assessment report since the code got too big.
 The routines to fill the sort files are here.}

interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Types,
  GlblCnst, PASUTILS, UTILEXSD,  WinUtils, Utilitys, GlblVars, PASTypes, Prog;


Procedure GetSection6Totals(    _RecType : Char;  {(S)wis, S(c)hool}
                                _MunicipalityCode : String;
                            var HstdPhysicalQtyIncrease,
                                HstdEqualizationIncrease,
                                HstdPhysicalQtyDecrease,
                                HstdEqualizationDecrease,
                                HstdPriorAssessed,
                                HstdCurrentAssessed,
                                NonhstdPhysicalQtyIncrease,
                                NonhstdEqualizationIncrease,
                                NonhstdPhysicalQtyDecrease,
                                NonhstdEqualizationDecrease,
                                NonhstdPriorAssessed,
                                NonhstdCurrentAssessed : Comp;
                                SortAssessedValChangesTable,
                                SortTotalAssessedValTable : TTable;
                                WriteToChangeFile : Boolean;
                            var Detail225ChangeFile : TextFile;
                            var Quit : Boolean);

  Procedure PostComputedChanges(SortComputedChangesTable : TTable;
                                Form : TForm;
                                ProgressDialog : TProgressDialog);

  Procedure PostHoldValues(ParcelTable,
                           AssessmentTable,
                           ClassTable : TTable;
                           Form : TForm;
                           ProcessingType : Integer;
                           ProgressDialog : TProgressDialog;
                           RPS225ReportRun : Boolean);

  Procedure FillSortFiles(AssessmentTable,
                          ParcelTable,
                          SwisCodeTable,
                          SortTotalAssessedValTable,
                          SortAssessedValChangesTable,
                          SortAVByPropClass_RS_Table,
                          SortExemptionTable,
                          SortComputedChangesTable,
                          SortSummaryTable,
                          SortAVChangesTable,
                          AssessmentYearCtlFile,
                          SchoolCodeTable,
                          ClassTable,
                          ParcelExemptionTable,
                          EXCodeTable : TTable;
                          SwisCodeListBox : TListBox;
                          ProgressDialog : TProgressDialog;
                          Form : TForm;
                          RPS225ReportRun : Boolean;
                          AttributeInactivationsOrNewParcelsToPhysicalChange,
                          AttributeImbalancesToEqualization : Boolean;
                      var Quit : Boolean);
  {Fill all the sort files needed for the assessor's report.}

type
  TotalValueRecord = record
    RecType : Char;  {(S)wis, S(c)hool}
    MunicipalityCode : String;
    RollSection : String;
    Block : String;
    HstdPriorVal,
    NonhstdPriorVal,
    HstdCurrentVal,
    NonhstdCurrentVal,
    HstdEqualizationIncrease,
    HstdEqualizationDecrease,
    HstdPhysicalQtyIncrease,
    HstdPhysicalQtyDecrease,
    NonhstdEqualizationIncrease,
    NonhstdEqualizationDecrease,
    NonhstdPhysicalQtyIncrease,
    NonhstdPhysicalQtyDecrease,
    HstdExAmount,
    NonhstdExAmount : Comp;

  end;  {TotalValueRecord = record}

  PTotalValueRecord = ^TotalValueRecord;


  AV_PC_RSRecord = record
    RecType : Char; {'R' = Roll Section, 'P' = prop class}
    Category : Char;
    PriorValue : Comp;
    PriorNumParcels : LongInt;
    CurrentValue : Comp;
    CurrentNumParcels : LongInt;

  end;  {AV_PC_RSRecord = record}

  PAV_PC_RSRecord = ^AV_PC_RSRecord;


  ExemptionSummaryRecord = record
    ExemptionCode : String;
    Description : String;
    Count : LongInt;
    CountyExAmount,
    TownExAmount,
    SchoolExAmount,
    VillageExAmount : Comp;

  end;  {ExemptionSummaryRecord = record}

  PExemptionSummaryRecord = ^ExemptionSummaryRecord;

var
  ReportCancelled : Boolean;
  TrialRun : Boolean;

implementation

const
  UnitName = 'RPASESOR';

{===================================================================}
Procedure GetSection6Totals(    _RecType : Char;  {(S)wis, S(c)hool}
                                _MunicipalityCode : String;
                            var HstdPhysicalQtyIncrease,
                                HstdEqualizationIncrease,
                                HstdPhysicalQtyDecrease,
                                HstdEqualizationDecrease,
                                HstdPriorAssessed,
                                HstdCurrentAssessed,
                                NonhstdPhysicalQtyIncrease,
                                NonhstdEqualizationIncrease,
                                NonhstdPhysicalQtyDecrease,
                                NonhstdEqualizationDecrease,
                                NonhstdPriorAssessed,
                                NonhstdCurrentAssessed : Comp;
                                SortAssessedValChangesTable,
                                SortTotalAssessedValTable : TTable;
                                WriteToChangeFile : Boolean;
                            var Detail225ChangeFile : TextFile;
                            var Quit : Boolean);

{Get the totals for this rec type and municipality code.}
{12/17/1999 Moved to utilitys because out of code space.}

var
  MunicCodeLength : Integer;
  Done, FirstTimeThrough : Boolean;
  CurrentAssessedValue, PriorAssessedValue,
  _HstdPhysicalQtyIncrease, _HstdEqualizationIncrease,
  _HstdPhysicalQtyDecrease, _HstdEqualizationDecrease,
  _NonhstdPhysicalQtyIncrease, _NonhstdEqualizationIncrease,
  _NonhstdPhysicalQtyDecrease, _NonhstdEqualizationDecrease : Comp;
  SchoolCd, MunicipalityCode : String;
  SwisSBLKey : String;
  SplitMergeNo : String;

begin
  HstdPhysicalQtyIncrease := 0;
  HstdEqualizationIncrease := 0;
  HstdPhysicalQtyDecrease := 0;
  HstdEqualizationDecrease := 0;
  HstdPriorAssessed := 0;
  HstdCurrentAssessed := 0;
  NonhstdPhysicalQtyIncrease := 0;
  NonhstdEqualizationIncrease := 0;
  NonhstdPhysicalQtyDecrease := 0;
  NonhstdEqualizationDecrease := 0;
  NonhstdPriorAssessed := 0;
  NonhstdCurrentAssessed := 0;

  FirstTimeThrough := True;
  Done := False;
  MunicCodeLength := Length(Trim(_MunicipalityCode));

  SortAssessedValChangesTable.CancelRange;
  SortAssessedValChangesTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortAssessedValChangesTable.Next;

    If SortAssessedValChangesTable.EOF
      then Done := True;

    If not (Done or Quit)
      then
        with SortAssessedValChangesTable do
          begin
            SwisSBLKey := FieldByName('SwisCode').Text + FieldByName('SBLKey').Text;
            SchoolCd := FieldByName('CurrSchoolCode').Text;
            SplitMergeNo := FieldByName('SplitMergeNo').Text;

              {Only match on the number of chars in the passed in munic code
               since it may be only 4 for the town total.}
              {FXX04151999-1: Must drive this section off of the individual
                              change table because of the RPS rules which are:
                              In this section, if a parcel is created, the increase
                              goes in the phys\qty change section and if a parcel
                              is deleted, the equal decrease goes in the
                              phys\qty change section.}

            If (_RecType = 'S')
              then MunicipalityCode := FieldByName('SwisCode').Text
              else MunicipalityCode := FieldByName('CurrSchoolCode').Text;

            If ((Take(MunicCodeLength, MunicipalityCode) =
                 Take(MunicCodeLength, _MunicipalityCode)) and
                ((Take(1, FieldByName('CurrRollSect_Subsect').Text)[1] in ['1', '6']) or
                 (Take(1, FieldByName('PriorRollSect_Subsec').Text)[1] in ['1', '6'])))
               then
                 begin
                   _HstdPhysicalQtyIncrease := FieldByName('HstdPhysQtyInc').AsFloat;
                   _HstdEqualizationIncrease := FieldByName('HstdEqualInc').AsFloat;
                   _HstdPhysicalQtyDecrease := FieldByName('HstdPhysQtyDec').AsFloat;
                   _HstdEqualizationDecrease := FieldByName('HstdEqualDec').AsFloat;
                   _NonhstdPhysicalQtyIncrease := FieldByName('NonhstdPhysQtyInc').AsFloat;
                   _NonhstdEqualizationIncrease := FieldByName('NonhstdEqualInc').AsFloat;
                   _NonhstdPhysicalQtyDecrease := FieldByName('NonhstdPhysQtyDec').AsFloat;
                   _NonhstdEqualizationDecrease := FieldByName('NonhstdEqualDec').AsFloat;

                   CurrentAssessedValue := FieldByName('CurrAssessedVal').AsFloat;
                   PriorAssessedValue := FieldByName('PriorAssessedVal').AsFloat;

                   If not (Take(1, FieldByName('CurrRollSect_Subsect').Text)[1] in ['1', '6'])
                     then CurrentAssessedValue := 0;

                   If not (Take(1, FieldByName('PriorRollSect_Subsec').Text)[1] in ['1', '6'])
                     then PriorAssessedValue := 0;

                   If (((Deblank(FieldByName('SplitMergeNo').Text) <> '') and
                        (Deblank(FieldByName('SplitMergeNo').Text) <> '99999999')) or
                       ((Roundoff(CurrentAssessedValue, 0) > 0) and
                        (Roundoff(PriorAssessedValue, 0) = 0) and
                        (Deblank(FieldByName('PriorHomesteadCode').Text) = '')))  {Does not exist in prior.}
                     then
                       begin
                         If (FieldByName('CurrHomesteadCode').Text = 'N')
                           then
                             begin
                               _NonhstdPhysicalQtyIncrease := _NonhstdPhysicalQtyIncrease +
                                                              _NonhstdEqualizationIncrease;
                               _NonhstdEqualizationIncrease := 0;
                             end
                           else
                             begin
                               _HstdPhysicalQtyIncrease := _HstdPhysicalQtyIncrease +
                                                           _HstdEqualizationIncrease;
                               _HstdEqualizationIncrease := 0;

                             end;  {else of If (FieldByName('CurrHomesteadCode').Text = 'N')}

                       end;  {If ((Roundoff(FieldByName('CurrAssessedVal').AsFloat, 0) > 0) and ...}

                     {CHG01272003-3: If there is a split merge number that is not '99999999',
                                     then switch equalization amounts over to physical amounts.
                                     This was actually in old PAS, but not brought over.}
                     {FXX01292003-1: Any split merge should be moved to a physical.}

                   If ((Deblank(FieldByName('SplitMergeNo').Text) <> '') and
                       (Deblank(FieldByName('SplitMergeNo').Text) <> '99999999'))
(*                       ((Roundoff(CurrentAssessedValue, 0) = 0) and
                        (Roundoff(PriorAssessedValue, 0) > 0) and
                        (FieldByName('Inactive').AsBoolean)))  {Does not exist current.}*)
                     then
                       begin
                         If (FieldByName('PriorHomesteadCode').Text = 'N')
                           then
                             begin
                               _NonhstdPhysicalQtyDecrease := _NonhstdPhysicalQtyDecrease +
                                                              _NonhstdEqualizationDecrease;
                               _NonhstdEqualizationDecrease := 0;

                             end
                           else
                             begin
                               _HstdPhysicalQtyDecrease := _HstdPhysicalQtyDecrease +
                                                           _HstdEqualizationDecrease;
                               _HstdEqualizationDecrease := 0;

                             end;  {else of If (FieldByName('PriorHomesteadCode').Text = 'N')}

                       end;  {If ((Roundoff(FieldByName('CurrAssessedVal').AsFloat, 0) > 0) and ...}

                     {Hstd to Nonhstd}
                     {FXX03222001-1: In case there is a change in code and value,
                                     need to blank out the other physical qty value.}

                   If ((FieldByName('CurrHomesteadCode').Text = 'N') and
                       (FieldByName('PriorHomesteadCode').Text = 'H'))
                     then
                       begin
                         _HstdPhysicalQtyDecrease := PriorAssessedValue;
                         _NonhstdPhysicalQtyIncrease := CurrentAssessedValue;
                         _HstdPhysicalQtyIncrease := 0;
                         _NonhstdPhysicalQtyDecrease := 0;

                       end;  {If ((FieldByName('CurrHomesteadCode').Text = 'N') and ...}

                     {Nonhstd to Hstd}

                   If ((FieldByName('PriorHomesteadCode').Text = 'N') and
                       (FieldByName('CurrHomesteadCode').Text = 'H'))
                     then
                       begin
                         _NonhstdPhysicalQtyDecrease := PriorAssessedValue;
                         _HstdPhysicalQtyIncrease := CurrentAssessedValue;
                         _HstdPhysicalQtyDecrease := 0;
                         _NonhstdPhysicalQtyIncrease := 0;

                       end;  {If ((FieldByName('CurrHomesteadCode').Text = 'N') and ...}

                      {Reverse out any equalization increases\decreases first.}

                   If (((FieldByName('PriorHomesteadCode').Text = 'N') and
                        (FieldByName('CurrHomesteadCode').Text = 'H')) or
                       ((FieldByName('PriorHomesteadCode').Text = 'H') and
                        (FieldByName('CurrHomesteadCode').Text = 'N')))
                     then
                       begin
                         _HstdEqualizationDecrease := 0;
                         _NonhstdEqualizationDecrease := 0;
                         _HstdEqualizationIncrease := 0;
                         _NonhstdEqualizationIncrease := 0;

                       end;  {If (FieldByName('PriorHomesteadCode').Text = <> ...}

                     {FXX03152002-2: Don't write to file if no actual change.}

                   If (WriteToChangeFile and
                       ((Roundoff(_HstdPhysicalQtyIncrease, 0) > 0) or
                        (Roundoff(_HstdPhysicalQtyDecrease, 0) > 0) or
                        (Roundoff(_HstdEqualizationIncrease, 0) > 0) or
                        (Roundoff(_HstdEqualizationDecrease, 0) > 0) or
                        (Roundoff(_NonhstdPhysicalQtyIncrease, 0) > 0) or
                        (Roundoff(_NonhstdPhysicalQtyDecrease, 0) > 0) or
                        (Roundoff(_NonhstdEqualizationIncrease, 0) > 0) or
                        (Roundoff(_NonhstdEqualizationDecrease, 0) > 0)))
                     then Writeln(Detail225ChangeFile, '"', ConvertSwisSBLToDashDot(SwisSBLKey) + '","' +
                                                FieldByName('PriorHomesteadCode').Text + '","' +
                                                FieldByName('CurrHomesteadCode').Text + '","' +
                                                FieldByName('SplitMergeNo').Text + '","' +
                                                FormatFloat(CurrencyDisplayNoDollarSign,
                                                            PriorAssessedValue) + '","' +
                                                FormatFloat(CurrencyDisplayNoDollarSign,
                                                            CurrentAssessedValue) + '","' +
                                                FormatFloat(CurrencyDisplayNoDollarSign,
                                                            _HstdPhysicalQtyIncrease) + '","' +
                                                FormatFloat(CurrencyDisplayNoDollarSign,
                                                            _HstdPhysicalQtyDecrease) + '","' +
                                                FormatFloat(CurrencyDisplayNoDollarSign,
                                                            _HstdEqualizationIncrease) + '","' +
                                                FormatFloat(CurrencyDisplayNoDollarSign,
                                                            _HstdEqualizationDecrease) + '","' +
                                                FormatFloat(CurrencyDisplayNoDollarSign,
                                                            _NonhstdPhysicalQtyIncrease) + '","' +
                                                FormatFloat(CurrencyDisplayNoDollarSign,
                                                            _NonhstdPhysicalQtyDecrease) + '","' +
                                                FormatFloat(CurrencyDisplayNoDollarSign,
                                                            _NonhstdEqualizationIncrease) + '","' +
                                                FormatFloat(CurrencyDisplayNoDollarSign,
                                                            _NonhstdEqualizationDecrease) + '"');

                   HstdPhysicalQtyIncrease := HstdPhysicalQtyIncrease + _HstdPhysicalQtyIncrease;
                   HstdEqualizationIncrease := HstdEqualizationIncrease + _HstdEqualizationIncrease;
                   HstdPhysicalQtyDecrease := HstdPhysicalQtyDecrease + _HstdPhysicalQtyDecrease;
                   HstdEqualizationDecrease := HstdEqualizationDecrease + _HstdEqualizationDecrease;
                   NonhstdPhysicalQtyIncrease := NonhstdPhysicalQtyIncrease + _NonhstdPhysicalQtyIncrease;
                   NonhstdEqualizationIncrease := NonhstdEqualizationIncrease + _NonhstdEqualizationIncrease;
                   NonhstdPhysicalQtyDecrease := NonhstdPhysicalQtyDecrease + _NonhstdPhysicalQtyDecrease;
                   NonhstdEqualizationDecrease := NonhstdEqualizationDecrease + _NonhstdEqualizationDecrease;

                   If (Take(1, FieldByName('CurrRollSect_Subsect').Text)[1] in ['1', '6'])
                     then
                       If (FieldByName('CurrHomesteadCode').Text = 'N')
                         then NonhstdCurrentAssessed := NonhstdCurrentAssessed + CurrentAssessedValue
                         else HstdCurrentAssessed := HstdCurrentAssessed + CurrentAssessedValue;

                   If (Take(1, FieldByName('PriorRollSect_Subsec').Text)[1] in ['1', '6'])
                     then
                       If (FieldByName('PriorHomesteadCode').Text = 'N')
                         then NonhstdPriorAssessed := NonhstdPriorAssessed + PriorAssessedValue
                         else HstdPriorAssessed := HstdPriorAssessed + PriorAssessedValue;

                 end;  {If (Take(MunicCodeLength, FieldByName('MunicipalityCode').Text) = ...}

          end;  {with SortTotalAssessedValTable do}

  until (Done or Quit);

    {FXX12171999-1: Now get the total values.}

  NonhstdCurrentAssessed := 0;
  HstdCurrentAssessed := 0;
  NonhstdPriorAssessed := 0;
  HstdPriorAssessed := 0;
  Done := False;
  FirstTimeThrough := True;

  SortTotalAssessedValTable.CancelRange;

    {FXX12182001-2: 'MunicipalityCode' spelled wrong.}

  SetRangeOld(SortTotalAssessedValTable,
              ['RecType', 'MunicipalityCode', 'RollSection', 'Block'],
              [_RecType, '      ', '1', '    '],
              [_RecType, '999999', '9', 'ZZZZ']);
  SortTotalAssessedValTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortTotalAssessedValTable.Next;

    with SortTotalAssessedValTable do
      If (EOF or
          (Deblank(FieldByName('RecType').Text) = ''))
        then Done := True;

      {Get the assessed values for this roll section.}

    If not Done
      then
        with SortTotalAssessedValTable do
          If ((Take(MunicCodeLength, FieldByName('MunicipalityCode').Text) = Take(MunicCodeLength, _MunicipalityCode)) and
              (Take(1, FieldByName('RollSection').Text)[1] in ['1', '6']))
            then
              begin
                HstdPriorAssessed := HstdPriorAssessed +
                                     FieldByName('HomestdPriorVal').AsFloat;
                HstdCurrentAssessed := HstdCurrentAssessed +
                                       FieldByName('HomestdCurrentVal').AsFloat;
                NonhstdPriorAssessed := NonhstdPriorAssessed +
                                        FieldByName('NonhomestdPriorVal').AsFloat;
                NonhstdCurrentAssessed := NonhstdCurrentAssessed +
                                          FieldByName('NonhomestdCurrentVal').AsFloat;

              end;  {If (FieldByName('RollSection') in ['1', '6'])}

  until Done;

  SortTotalAssessedValTable.CancelRange;

end;  {GetSection6Totals}

{===================================================================}
Procedure PostComputedChanges(SortComputedChangesTable : TTable;
                              Form : TForm;
                              ProgressDialog : TProgressDialog);

{FXX09071999-10: Post back the computed changes.}

var
  FoundParcel, PostThisChange,
  Quit, ClassRecord, _Found, Done, FirstTimeThrough : Boolean;
  TaxRollYr : String;
  SwisSBLKey : String;
  ClassTable, AssessmentTable, ThisYearAssessmentTable : TTable;
  ProcessingType : Integer;

begin
  FirstTimeThrough := True;
  Done := False;
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := GetRecordCount(SortComputedChangesTable);
  ProgressDialog.UserLabelCaption := 'Posting computed changes.';

  SortComputedChangesTable.First;
  ClassTable := TTable.Create(nil);
  AssessmentTable := TTable.Create(nil);
  ThisYearAssessmentTable := TTable.Create(nil);
  OpenTableForProcessingType(ThisYearAssessmentTable, AssessmentTableName, ThisYear,
                             Quit);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortComputedChangesTable.Next;

    If SortComputedChangesTable.EOF
      then Done := True;

      {Post back the computed changes.}

    If (not Done)
      then
        with SortComputedChangesTable do
          begin
            ClassRecord := FieldByName('ClassRecord').AsBoolean;
            TaxRollYr := FieldByName('TaxRollYr').Text;
            SwisSBLKey := FieldByName('SwisSBLKey').Text;
            ProcessingType := GetProcessingTypeForTaxRollYear(TaxRollYr);

            ProgressDialog.Update(Form, ConvertSwisSBLToDashDot(SwisSBLKey));

            If ClassRecord
              then
                begin
                  OpenTableForProcessingType(ClassTable, ClassTableName, ProcessingType,
                                             Quit);

                  _Found := FindKeyOld(ClassTable,
                                       ['TaxRollYr', 'SwisSBLKey'],
                                       [TaxRollYr, SwisSBLKey]);

                  If _Found
                    then
                      try
                        ClassTable.Edit;
                        ClassTable.FieldByName('HstdEqualInc').AsFloat := FieldByName('HstdEqualInc').AsFloat;
                        ClassTable.FieldByName('HstdEqualDec').AsFloat := FieldByName('HstdEqualDec').AsFloat;
                        ClassTable.FieldByName('HstdPhysQtyInc').AsFloat := FieldByName('HstdPhysQtyInc').AsFloat;
                        ClassTable.FieldByName('HstdPhysQtyDec').AsFloat := FieldByName('HstdPhysQtyDec').AsFloat;
                        ClassTable.FieldByName('NonhstdEqualInc').AsFloat := FieldByName('NonhstdEqualInc').AsFloat;
                        ClassTable.FieldByName('NonhstdEqualDec').AsFloat := FieldByName('NonhstdEqualDec').AsFloat;
                        ClassTable.FieldByName('NonhstdPhysQtyInc').AsFloat := FieldByName('NonhstdPhysQtyInc').AsFloat;
                        ClassTable.FieldByName('NonhstdPhysQtyDec').AsFloat := FieldByName('NonhstdPhysQtyDec').AsFloat;

                        ClassTable.Post;

                      except
                        SystemSupport(050, ClassTable, 'Error posting back computeds to class table.',
                                      UnitName, GlblErrorDlgBox);
                      end;

                end
              else
                begin
                  OpenTableForProcessingType(AssessmentTable, AssessmentTableName, ProcessingType,
                                             Quit);
                  _Found := FindKeyOld(AssessmentTable,
                                       ['TaxRollYr', 'SwisSBLKey'],
                                       [TaxRollYr, SwisSBLKey]);

                    {FXX11031999-1: Prevent the following situation in Westchester -
                                    parcel is changed in TY after Final roll so
                                    AR change is on TY, but computes to NY.  Don't
                                    want to post again to NY if change is already
                                    in TY.}

                  PostThisChange := True;
                  If (GlblIsWestchesterCounty and
                      (ProcessingType = NextYear))
                    then
                      begin
                        FoundParcel := FindKeyOld(ThisYearAssessmentTable,
                                                  ['TaxRollYr', 'SwisSBLKey'],
                                                  [GlblThisYear, SwisSBLKey]);

                        If (FoundParcel and
                            (Roundoff(ThisYearAssessmentTable.FieldByName('IncreaseForEqual').AsFloat, 0) =
                             Roundoff((FieldByName('HstdEqualInc').AsFloat +
                                       FieldByName('NonHstdEqualInc').AsFloat), 0)) and
                            (Roundoff(Abs(ThisYearAssessmentTable.FieldByName('DecreaseForEqual').AsFloat), 0) =
                             Roundoff((FieldByName('HstdEqualDec').AsFloat +
                                       FieldByName('NonHstdEqualDec').AsFloat), 0)) and
                            (Roundoff(ThisYearAssessmentTable.FieldByName('PhysicalQtyIncrease').AsFloat, 0) =
                             Roundoff((FieldByName('HstdPhysQtyInc').AsFloat +
                                       FieldByName('NonHstdPhysQtyInc').AsFloat), 0)) and
                            (Roundoff(ThisYearAssessmentTable.FieldByName('PhysicalQtyIncrease').AsFloat, 0) =
                             Roundoff((FieldByName('HstdPhysQtyInc').AsFloat +
                                       FieldByName('NonHstdPhysQtyInc').AsFloat), 0)))
                          then PostThisChange := False;

                      end;  {If (GlblIsWestchester and ...}

                  If (_Found and
                      PostThisChange)
                    then
                      try
                        AssessmentTable.Edit;
                        AssessmentTable.FieldByName('IncreaseForEqual').AsFloat := FieldByName('HstdEqualInc').AsFloat +
                                                                                   FieldByName('NonHstdEqualInc').AsFloat;
                        AssessmentTable.FieldByName('DecreaseForEqual').AsFloat := FieldByName('HstdEqualDec').AsFloat +
                                                                               FieldByName('NonHstdEqualDec').AsFloat;
                        AssessmentTable.FieldByName('PhysicalQtyIncrease').AsFloat := FieldByName('HstdPhysQtyInc').AsFloat +
                                                                                 FieldByName('NonHstdPhysQtyInc').AsFloat;
                        AssessmentTable.FieldByName('PhysicalQtyDecrease').AsFloat := FieldByName('HstdPhysQtyDec').AsFloat +
                                                                                 FieldByName('NonHstdPhysQtyDec').AsFloat;

                        AssessmentTable.Post;

                      except
                        SystemSupport(051, AssessmentTable, 'Error posting back computeds to Assessment table.',
                                      UnitName, GlblErrorDlgBox);
                      end;

                end;  {else of If ClassRecord}

          end;  {with SortComputedChangesTable do}

  until Done;

  ClassTable.Close;
  ClassTable.Free;
  AssessmentTable.Close;
  AssessmentTable.Free;
  ThisYearAssessmentTable.Close;
  ThisYearAssessmentTable.Free;

end;  {PostComputedChanges}

{===================================================================}
Procedure PostHoldValues(ParcelTable,
                         AssessmentTable,
                         ClassTable : TTable;
                         Form : TForm;
                         ProcessingType : Integer;
                         ProgressDialog : TProgressDialog;
                         RPS225ReportRun : Boolean);

{FXX12271999-1: Make sure to save values.}
{FXX06272002-1: Sometimes the tables were pointing to the wrong year.}

var
  Quit, Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;

  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             ProcessingType, Quit);
  ProgressDialog.UserLabelCaption := 'Saving hold values - parcel table.';
  ProgressDialog.Start(GetRecordCount(ParcelTable), False, False);
  ParcelTable.CancelRange;

    {FXX04292002-1: Not doing a first on the tables to post values.}

  ParcelTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If ParcelTable.EOF
      then Done := True;

    ProgressDialog.Update(Form, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));
    Application.ProcessMessages;

    If not Done
      then
        with ParcelTable do
          try
            Edit;

              {CHG02282000-1: Add fields for 225 run.}

            If RPS225ReportRun
              then
                begin
                  FieldByName('Hold225RollSection').Text := FieldByName('RollSection').Text;
                  FieldByName('Hold225Status').Text := FieldByName('ActiveFlag').Text;
                  FieldByName('Hold225PropClass').Text := FieldByName('PropertyClassCode').Text;
                  FieldByName('Hold225Homestead').Text := FieldByName('HomesteadCode').Text;
                end
              else
                begin
                  FieldByName('HoldPriorRollSection').Text := FieldByName('RollSection').Text;
                  FieldByName('HoldPriorStatus').Text := FieldByName('ActiveFlag').Text;
                  FieldByName('HoldPriorPropClass').Text := FieldByName('PropertyClassCode').Text;
                  FieldByName('HoldPriorHomestead').Text := FieldByName('HomesteadCode').Text;
                end;

            Post;

          except
            SystemSupport(052, ParcelTable, 'Error posting holds to parcel table.',
                          UnitName, GlblErrorDlgBox);
          end;

  until Done;

  Done := False;
  FirstTimeThrough := True;

  OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                             ProcessingType, Quit);

  ProgressDialog.UserLabelCaption := 'Saving hold values - Assessment table.';
  ProgressDialog.Start(GetRecordCount(AssessmentTable), False, False);
  AssessmentTable.CancelRange;

    {FXX04292002-1: Not doing a first on the tables to post values.}

  AssessmentTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else AssessmentTable.Next;

    If AssessmentTable.EOF
      then Done := True;

    ProgressDialog.Update(Form, ConvertSwisSBLToDashDot(AssessmentTable.FieldByName('SwisSBLKey').Text));
    Application.ProcessMessages;

    If not Done
      then
        with AssessmentTable do
          try
            Edit;

              {CHG02282000-1: Add fields for 225 run.}

            If RPS225ReportRun
              then FieldByName('Hold225Value').AsFloat := FieldByName('TotalAssessedVal').AsFloat
              else FieldByName('HoldPriorValue').AsFloat := FieldByName('TotalAssessedVal').AsFloat;

            Post;

          except
            SystemSupport(053, AssessmentTable, 'Error posting holds to Assessment table.',
                          UnitName, GlblErrorDlgBox);
          end;

  until Done;

    {FXX02282000-2: Don't forget to post back class values.}

  OpenTableForProcessingType(ClassTable, ClassTableName,
                             ProcessingType, Quit);

  Done := False;
  FirstTimeThrough := True;

  ProgressDialog.UserLabelCaption := 'Saving hold value - Class table.';
  ProgressDialog.Start(GetRecordCount(ClassTable), False, False);
  ClassTable.CancelRange;
  ClassTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ClassTable.Next;

    If ClassTable.EOF
      then Done := True;

    If not Done
      then
        with ClassTable do
          try
            Edit;
            FieldByName('HstdHoldPriorVal').AsFloat := FieldByName('HstdTotalVal').AsFloat;
            FieldByName('NonhstdHoldPriorVal').AsFloat := FieldByName('NonhstdTotalVal').AsFloat;
            Post;
          except
            SystemSupport(053, ClassTable, 'Error posting holds to Class table.',
                          UnitName, GlblErrorDlgBox);
          end;

  until Done;

end;  {PostHoldValues}

{===================================================================}
Function FindTotalAssessedValRecord(    TotalAssessedValList : TList;
                                        _RecType : Char;
                                        _MunicipalityCode : String;
                                        _RollSection : String;
                                        _Block : String;
                                    var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (TotalAssessedValList.Count - 1) do
    with PTotalValueRecord(TotalAssessedValList[I])^ do
      If ((RecType = _RecType) and
          (MunicipalityCode = _MunicipalityCode) and
          (RollSection = _RollSection) and
          (Block = _Block))
        then
          begin
            Result := True;
            Index := I;
          end;

end;  {FindTotalAssessedValRecord}

{===================================================================}
Procedure UpdateOneTotalAssessedValueRec(TotalAssessedValList : TList;
                                         _RollSection : String;
                                         _RecType : Char;
                                         _MunicipalityCode : String;
                                         _Block : String;
                                         _HomesteadValue,
                                         _NonhomesteadValue,
                                         _HstdEqualizationIncrease,
                                         _HstdEqualizationDecrease,
                                         _HstdPhysicalQtyIncrease,
                                         _HstdPhysicalQtyDecrease,
                                         _NonhstdEqualizationIncrease,
                                         _NonhstdEqualizationDecrease,
                                         _NonhstdPhysicalQtyIncrease,
                                         _NonhstdPhysicalQtyDecrease,
                                         _HstdExAmount,
                                         _NonhstdExAmount : Comp;
                                         PriorValues : Boolean);

var
  Index : Integer;
  PTotalAssessedValRec : PTotalValueRecord;

begin
  If not FindTotalAssessedValRecord(TotalAssessedValList,
                                    _RecType, _MunicipalityCode,
                                    _RollSection, _Block, Index)
    then
      begin
        New(PTotalAssessedValRec);

        with PTotalAssessedValRec^ do
          begin
            RecType := _RecType;
            MunicipalityCode := _MunicipalityCode;
            RollSection := _RollSection;
            Block := _Block;
            HstdPriorVal := 0;
            HstdCurrentVal := 0;
            NonhstdPriorVal := 0;
            NonhstdCurrentVal := 0;
            HstdEqualizationIncrease := 0;
            HstdEqualizationDecrease := 0;
            HstdPhysicalQtyIncrease := 0;
            HstdPhysicalQtyDecrease := 0;
            NonhstdEqualizationIncrease := 0;
            NonhstdEqualizationDecrease := 0;
            NonhstdPhysicalQtyIncrease := 0;
            NonhstdPhysicalQtyDecrease := 0;
            HstdExAmount := 0;
            NonhstdExAmount := 0;

          end;  {with PTotalAssessedValRec^ do}

        TotalAssessedValList.Add(PTotalAssessedValRec);

        FindTotalAssessedValRecord(TotalAssessedValList, _RecType,
                                   _MunicipalityCode, _RollSection,
                                   _Block, Index);

      end;  {If not FindTotalAssessedValRecord(RecType, ...}

    {Update the totals.}

  with PTotalValueRecord(TotalAssessedValList[Index])^ do
    begin
      HstdEqualizationIncrease := HstdEqualizationIncrease + _HstdEqualizationIncrease;
      HstdEqualizationDecrease := HstdEqualizationDecrease + _HstdEqualizationDecrease;
      HstdPhysicalQtyIncrease := HstdPhysicalQtyIncrease + _HstdPhysicalQtyIncrease;
      HstdPhysicalQtyDecrease := HstdPhysicalQtyDecrease + _HstdPhysicalQtyDecrease;

      NonhstdEqualizationIncrease := NonhstdEqualizationIncrease + _NonhstdEqualizationIncrease;
      NonhstdEqualizationDecrease := NonhstdEqualizationDecrease + _NonhstdEqualizationDecrease;
      NonhstdPhysicalQtyIncrease := NonhstdPhysicalQtyIncrease + _NonhstdPhysicalQtyIncrease;
      NonhstdPhysicalQtyDecrease := NonhstdPhysicalQtyDecrease + _NonhstdPhysicalQtyDecrease;

      If PriorValues
        then
          begin
            HstdPriorVal := HstdPriorVal + _HomesteadValue;
            NonhstdPriorVal := NonhstdPriorVal + _NonhomesteadValue;

          end
        else
          begin
              {The assessment increase\decrease fields only apply to
               this year since we want to know how they got from the
               prior (history) to the this year value.}

            HstdCurrentVal := HstdCurrentVal + _HomesteadValue;
            NonhstdCurrentVal := NonhstdCurrentVal + _NonhomesteadValue;

            HstdExAmount := HstdExAmount + _HstdExAmount;
            NonhstdExAmount := NonhstdExAmount + _NonhstdExAmount;

          end;  {If PriorValues}

    end;  {with PTotalValueRecord(TotalAssessedValList[Index])^ do}

end;  {UpdateOneTotalAssessedValueRec}

{===================================================================}
Procedure UpdateTotalAssessedVal(    TotalAssessedValList : TList;
                                     PriorRollSection,
                                     CurrentRollSection,
                                     PriorActiveFlag,
                                     CurrentActiveFlag : String;
                                     PriorSchoolCode,
                                     CurrentSchoolCode : String;
                                     PriorHomesteadValue,
                                     PriorNonhomesteadValue,
                                     CurrentHomesteadValue,
                                     CurrentNonhomesteadValue,
                                     _HstdEqualizationIncrease,
                                     _HstdEqualizationDecrease,
                                     _HstdPhysicalQtyIncrease,
                                     _HstdPhysicalQtyDecrease,
                                     _NonhstdEqualizationIncrease,
                                     _NonhstdEqualizationDecrease,
                                     _NonhstdPhysicalQtyIncrease,
                                     _NonhstdPhysicalQtyDecrease,
                                     _HstdExAmount,
                                     _NonhstdExAmount : Comp;
                                     _RecType : Char;  {'S' = swis, 'C' = school}
                                     _SwisCode : String;
                                     _Block : String;
                                     PriorParcelExists : Boolean;
                                 var Quit : Boolean);

{Update or insert a record which totals the assessed value by swis code or school code.
 Normally we will use the roll section of the processing year that we are
 looking at. However, if this is a parcel that switched to\from roll section
 8, we need to make some adjustments if this is the Current information.
 If this is a parcel that switched to roll section 8, we will not adjust the
 assessed value totals, but we will add to the inc\dec fields under the old
 roll section. If this is a parcel that switched from roll section 8, we will
 add in the assessed value and use the new roll section.}

var
  _MunicipalityCode : String;  {Swis or school depending}
  TempHstdEqualizationIncrease,
  TempHstdEqualizationDecrease,
  TempHstdPhysicalQtyIncrease,
  TempHstdPhysicalQtyDecrease,
  TempNonhstdEqualizationIncrease,
  TempNonhstdEqualizationDecrease,
  TempNonhstdPhysicalQtyIncrease,
  TempNonhstdPhysicalQtyDecrease : Comp;

begin
     {First store the prior amount.  Note that the ex amounts and
      ar changes are for current year only.}

  If (PriorActiveFlag = InactiveParcelFlag)
    then
      begin
        PriorHomesteadValue := 0;
        PriorNonhomesteadValue := 0;
      end;

  If (CurrentActiveFlag = InactiveParcelFlag)
    then
      begin
        CurrentHomesteadValue := 0;
        CurrentNonhomesteadValue := 0;
      end;

    {Must have school code if school rec.}

  If ((*(PriorActiveFlag <> InactiveParcelFlag) and*)
      (Take(1, PriorRollSection)[1] in ['1', '3', '6']) or
      (Take(1, CurrentRollSection)[1] in ['1', '3', '6']) and
      (((_RecType = 'C') and
        (Deblank(PriorSchoolCode) <> '')) or
       (_RecType = 'S')))
    then
      begin
        If (_RecType = 'S')
          then _MunicipalityCode := _SwisCode
          else _MunicipalityCode := PriorSchoolCode;

          {FXX05022000-3: If this is a new parcel, the prior roll section will
                          be blank, so need to use the current roll section.}

        If not PriorParcelExists
          then PriorRollSection := CurrentRollSection;

        UpdateOneTotalAssessedValueRec(TotalAssessedValList,
                                        PriorRollSection,
                                        _RecType, _MunicipalityCode,
                                        _Block, PriorHomesteadValue,
                                        PriorNonhomesteadValue,
                                        _HstdEqualizationIncrease,
                                        _HstdEqualizationDecrease,
                                        _HstdPhysicalQtyIncrease,
                                        _HstdPhysicalQtyDecrease,
                                        _NonhstdEqualizationIncrease,
                                        _NonhstdEqualizationDecrease,
                                        _NonhstdPhysicalQtyIncrease,
                                        _NonhstdPhysicalQtyDecrease, 0, 0,
                                        True);

      end;  {If ((PriorActiveFlag <> InactiveParcelFlag) and ...}

     {Now store the current amount.}

  If ((*(CurrentActiveFlag <> InactiveParcelFlag) and*)
      (Take(1, CurrentRollSection)[1] in ['1', '3', '6']) and
      (((_RecType = 'C') and
        (Deblank(CurrentSchoolCode) <> '')) or
       (_RecType = 'S')))
    then
      begin
        TempHstdEqualizationIncrease := 0;
        TempHstdEqualizationDecrease := 0;
        TempHstdPhysicalQtyIncrease := 0;
        TempHstdPhysicalQtyDecrease := 0;
        TempNonhstdEqualizationIncrease := 0;
        TempNonhstdEqualizationDecrease := 0;
        TempNonhstdPhysicalQtyIncrease := 0;
        TempNonhstdPhysicalQtyDecrease := 0;

          {If the parcel moved from roll section 5, 7, or 8, need to
           include the inc\dec fields here since they were not picked up for
           the prior parcel.}

        If (Take(1, PriorRollSection)[1] in ['5', '7', '8'])
          then
            begin
              TempHstdEqualizationIncrease := _HstdEqualizationIncrease;
              TempHstdEqualizationDecrease := _HstdEqualizationDecrease;
              TempHstdPhysicalQtyIncrease := _HstdPhysicalQtyIncrease;
              TempHstdPhysicalQtyDecrease := _HstdPhysicalQtyDecrease;
              TempNonhstdEqualizationIncrease := _NonhstdEqualizationIncrease;
              TempNonhstdEqualizationDecrease := _NonhstdEqualizationDecrease;
              TempNonhstdPhysicalQtyIncrease := _NonhstdPhysicalQtyIncrease;
              TempNonhstdPhysicalQtyDecrease := _NonhstdPhysicalQtyDecrease;

            end;  {If (PriorRollSection in ['5', '7', '8'])}

        If (_RecType = 'S')
          then _MunicipalityCode := _SwisCode
          else _MunicipalityCode := CurrentSchoolCode;

        UpdateOneTotalAssessedValueRec(TotalAssessedValList,
                                       CurrentRollSection,
                                       _RecType, _MunicipalityCode,
                                       _Block, CurrentHomesteadValue,
                                       CurrentNonhomesteadValue,
                                       TempHstdEqualizationIncrease,
                                       TempHstdEqualizationDecrease,
                                       TempHstdPhysicalQtyIncrease,
                                       TempHstdPhysicalQtyDecrease,
                                       TempNonhstdEqualizationIncrease,
                                       TempNonhstdEqualizationDecrease,
                                       TempNonhstdPhysicalQtyIncrease,
                                       TempNonhstdPhysicalQtyDecrease,
                                       _HstdExAmount,
                                       _NonhstdExAmount, False);

      end;  {If ((CurrentActiveFlag <> InactiveParcelFlag) and ...}

end;  {UpdateTotalAssessedVal}

{===================================================================}
Function FoundAVByPC_RS_Record(    TotalByPropClass_RollSectionList : TList;
                                   _RecType : Char;
                                   _Category : Char;
                               var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (TotalByPropClass_RollSectionList.Count - 1) do
    with PAV_PC_RSRecord(TotalByPropClass_RollSectionList[I])^ do
      If ((RecType = _RecType) and
          (Category = _Category))
        then
          begin
            Result := True;
            Index := I;
          end;

end;  {FoundAVByPC_RS_Record}

{===================================================================}
Function DeterminePropertyClassCategory(PropertyClass : String;
                                        RollSection,
                                        OwnershipCode : String) : Char;

{The property class category is a way to refer to the different
 property class classifications on the assessor's report. They are:

 A : 100's
 B : 200's  (Roll section 1, 6, non-condo)
 C : 200's  (Roll section 1, 6; condo)
 D : 200's  (Roll section 3, 5, 7, 8)
 E : 300's
 F : 400's
 G : 500's
 H : 600's
 I : 700's
 J : 800's
 K : 900's
 L : anything else}

begin
   {Just in case they have a property class like '75',
    we want this to be '075' for determining the categories.}

  PropertyClass := ShiftRightAddZeroes(Take(3, PropertyClass));
  OwnershipCode := Take(1, OwnershipCode);

  case PropertyClass[1] of
    '1' : Result := 'A';

    '2' : begin  {200's}
            If (Take(1, RollSection)[1] in ['1', '6'])
              then
                begin
                  If (OwnershipCode[1] in ['C', 'P', 'T'])
                    then Result := 'C'
                    else Result := 'B';

                end
              else Result := 'D';

          end;   {200's}

    '3' : Result := 'E';
    '4' : Result := 'F';
    '5' : Result := 'G';
    '6' : Result := 'H';
    '7' : Result := 'I';
    '8' : Result := 'J';
    '9' : Result := 'K';

    else Result := 'L';

  end;  {case PropertyClass[1] of}

end;  {DeterminePropertyClassCategory}

{===================================================================}
Procedure InsertOneAVByPC_RS_Record(TotalByPropClass_RollSectionList : TList;
                                    _RecType : Char;
                                    AssessedValue : Comp;
                                    PropertyClass : String;
                                    RollSection,
                                    OwnershipCode : String;
                                    UsePriorFields : Boolean);

var
  Index : Integer;
  PAV_PC_RSRec : PAV_PC_RSRecord;
  _Category : Char;

begin
  If (_RecType = 'R')
    then _Category := Take(1, RollSection)[1]
    else _Category := DeterminePropertyClassCategory(PropertyClass,
                                                     RollSection,
                                                     OwnershipCode);

  If not FoundAVByPC_RS_Record(TotalByPropClass_RollSectionList, _RecType,
                               _Category, Index)
    then
      begin
        New(PAV_PC_RSRec);

        with PAV_PC_RSRec^ do
          begin
            RecType := _RecType;
            Category := _Category;
            PriorValue := 0;
            PriorNumParcels := 0;
            CurrentValue := 0;
            CurrentNumParcels := 0;

          end;  {with PAV_PC_RSRec^ do}

          TotalByPropClass_RollSectionList.Add(PAV_PC_RSRec);

          FoundAVByPC_RS_Record(TotalByPropClass_RollSectionList, _RecType,
                                _Category, Index);

        end;  {If not FoundAVByPC_RS_Record(RecType, Category, Index)}

  with PAV_PC_RSRecord(TotalByPropClass_RollSectionList[Index])^ do
    begin
      If UsePriorFields
        then
          begin
            PriorValue := PriorValue + AssessedValue;
            PriorNumParcels := PriorNumParcels + 1;
          end
        else
          begin
            CurrentValue := CurrentValue + AssessedValue;
            CurrentNumParcels := CurrentNumParcels + 1;
          end;  {else of If UsePriorFields}

    end;  {If not FoundAVByPC_RS_Record(RecType, Category, Index)}

end;  {InsertOneAVByPC_RS_Record}

{===================================================================}
Procedure UpdateAVByPropClassAndRS(    TotalByPropClass_RollSectionList : TList;
                                       PriorAssessedValue,
                                       CurrentAssessedValue : Comp;
                                       _PriorPropertyClass,
                                       _CurrentPropertyClass : String;
                                       _PriorRollSection,
                                       _CurrentRollSection,
                                       _PriorOwnershipCode,
                                       _CurrentOwnershipCode,
                                       _PriorActiveFlag,
                                       _CurrentActiveFlag : String;
                                       PriorParcelExists,
                                       CurrentParcelExists : Boolean;
                                   var Quit : Boolean);

{Insert or update a record which breaks down the assessed values by property class category
 and roll section.}

begin
     {First insert a prior roll section record.}

  If (PriorParcelExists and
      (_PriorActiveFlag <> InactiveParcelFlag))
    then InsertOneAVByPC_RS_Record(TotalByPropClass_RollSectionList, 'R',
                                   PriorAssessedValue, _PriorPropertyClass,
                                   _PriorRollSection, _PriorOwnershipCode, True);

    {Now insert a current roll section record.}

  If (CurrentParcelExists and
      (_CurrentActiveFlag <> InactiveParcelFlag))
    then InsertOneAVByPC_RS_Record(TotalByPropClass_RollSectionList, 'R',
                                   CurrentAssessedValue, _CurrentPropertyClass,
                                   _CurrentRollSection, _CurrentOwnershipCode, False);

     {First insert a prior property class record.}

  If (PriorParcelExists and
      (_PriorActiveFlag <> InactiveParcelFlag))
    then InsertOneAVByPC_RS_Record(TotalByPropClass_RollSectionList, 'P',
                                   PriorAssessedValue, _PriorPropertyClass,
                                   _PriorRollSection, _PriorOwnershipCode, True);

    {Now insert a current property class record.}

  If (CurrentParcelExists and
      (_CurrentActiveFlag <> InactiveParcelFlag))
    then InsertOneAVByPC_RS_Record(TotalByPropClass_RollSectionList, 'P',
                                   CurrentAssessedValue, _CurrentPropertyClass,
                                   _CurrentRollSection, _CurrentOwnershipCode, False);

end;  {UpdateAVByPropClassAndRSSortTable}

{===================================================================}
Function FoundExemptionSummaryRec(    ExemptionSummaryList : TList;
                                      ExemptionCode : String;
                                  var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (ExemptionSummaryList.Count - 1) do
    If (PExemptionSummaryRecord(ExemptionSummaryList[I])^.ExemptionCode = ExemptionCode)
      then
        begin
          Result := True;
          Index := I;
        end;

end;  {FoundExemptionSummaryRec}

{===================================================================}
Procedure UpdateExemptionSummary(ExemptionSummaryList : TList;
                                 ExemptionCodes,
                                 ExemptionHomesteadCodes,
                                 CountyExemptionAmounts,
                                 TownExemptionAmounts,
                                 SchoolExemptionAmounts,
                                 VillageExemptionAmounts : TStringList;
                                 ExCodeTable : TTable);

{Update the summary list for the exemptions for this parcel.}

var
  I, Index : Integer;
  PExemptionSummaryRec : PExemptionSummaryRecord;

begin
  For I := 0 to (ExemptionCodes.Count - 1) do
    If (Deblank(ExemptionCodes[I]) <> '')
      then
        begin
          If not FoundExemptionSummaryRec(ExemptionSummaryList, ExemptionCodes[I],
                                          Index)
            then
              begin
                New (PExemptionSummaryRec);

                with PExemptionSummaryRec^ do
                  begin
                    ExemptionCode := ExemptionCodes[I];
                    FindKeyOld(ExCodeTable, ['EXCode'], [ExemptionCodes[I]]);
                    Description := Take(20, ExCodeTable.FieldByName('Description').Text);
                    Count := 0;
                    CountyExAmount := 0;
                    TownExAmount := 0;
                    SchoolExAmount := 0;
                    VillageExAmount := 0;

                  end;  {with PExemptionSummaryRec^ do}

                ExemptionSummaryList.Add(PExemptionSummaryRec);

                FoundExemptionSummaryRec(ExemptionSummaryList, ExemptionCodes[I],
                                         Index);

              end;  {If not FoundExemptionSummaryRec(ExemptionSummaryList, ExemptionCodes[I])}

            {Now update the totals.}

          with PExemptionSummaryRecord(ExemptionSummaryList[Index])^ do
            begin
              Count := Count + 1;
              CountyExAmount := CountyExAmount + StrToFloat(CountyExemptionAmounts[I]);
              TownExAmount := TownExAmount + StrToFloat(TownExemptionAmounts[I]);
              SchoolExAmount := SchoolExAmount + StrToFloat(SchoolExemptionAmounts[I]);
              VillageExAmount := VillageExAmount + StrToFloat(VillageExemptionAmounts[I]);

            end;  {with PExemptionSummaryRecord(ExemptionSummaryList[Index])^ do}

        end;  {If (Deblank(ExemptionCodes[I]) <> '')}

end;  {UpdateExemptionSummary}

{=====================================================================}
Procedure InsertOneAVChangeRecord(    SortAssessedValChangesTable,
                                      SortComputedChangesTable : TTable;
                                      SwisSBLKey : String;
                                      _Name : String;
                                      PriorHomesteadValue,
                                      PriorNonhomesteadValue,
                                      CurrentHomesteadValue,
                                      CurrentNonhomesteadValue : Comp;
                                      PriorRollSectionSubsection,
                                      CurrentRollSectionSubsection : String;
                                      PriorHomesteadCode,
                                      CurrentHomesteadCode,
                                      PriorOwnershipCode,
                                      CurrentOwnershipCode,
                                      PriorActiveFlag,
                                      CurrentActiveFlag : String;
                                      PriorPropertyClass,
                                      CurrentPropertyClass : String;
                                      PriorSchoolCode,
                                      CurrentSchoolCode : String;
                                      SplitMergeNo : String;
                                      AttributeInactivationsOrNewParcelsToPhysicalChange,
                                      AttributeImbalancesToEqualization : Boolean;
                                      IgnoreFalseImbalances : Boolean;
                                  var HstdEqualizationIncrease,
                                      HstdEqualizationDecrease,
                                      HstdPhysicalQtyIncrease,
                                      HstdPhysicalQtyDecrease,
                                      NonhstdEqualizationIncrease,
                                      NonhstdEqualizationDecrease,
                                      NonhstdPhysicalQtyIncrease,
                                      NonhstdPhysicalQtyDecrease : Comp;
                                      ProcessingType : Integer;
                                  var Quit : Boolean);

{We will put out a detail change record if:
  1. There was an increase or decrease in total assessed value.
  2. The property was transferred from or to roll sections 1, 3, or 6
     to or from roll sections 5, 7, 8.
  3. There was a change from residential to non-res or vice-versa.
  4. There was a change from homestead to non-homestead or vice-versa.
  5. The school district changed.
  6. The TY parcel has a split merge number.
  7. The TY parcel is inactive.}

{Also, note that we do not use a TList since there are no running totals -
 each record is a discrete entity.}

var
  PropertyIsRollSection8PriorAndCurr,
  PropertyIsRollSection5PriorAndCurr,
  PropertyIsRollSection7PriorAndCurr,
  RollSectionChanged,
  PropertyClassChanged, InactiveParcel,
  ParcelExistsInHistory, _Found, FoundHistoryAssessment, ParcelChanged : Boolean;
  MismatchCode : Char;
  I : Integer;
  EqualizationIncrease, EqualizationDecrease,
  PhysicalQtyIncrease, PhysicalQtyDecrease,
  CurrentAssessedVal, PriorAssessedVal,
  HstdAVDifference, NonhstdAVDifference, AdjustedValue, Difference : Comp;
  SwisCode : String;
  SBLKey : String;

begin
  RollSectionChanged := False;
  PropertyClassChanged := False;
  PropertyIsRollSection8PriorAndCurr := False;
  PropertyIsRollSection5PriorAndCurr := False;
  PropertyIsRollSection7PriorAndCurr := False;
  MismatchCode := ' ';
  InactiveParcel := False;
  SwisCode := Take(6, SwisSBLKey);
  SBLKey := Copy(SwisSBLKey, 7, 20);

  CurrentAssessedVal := CurrentHomesteadValue + CurrentNonhomesteadValue;
  PriorAssessedVal := PriorHomesteadValue + PriorNonhomesteadValue;

  CurrentRollSectionSubsection := Take(1, CurrentRollSectionSubsection);
  PriorRollSectionSubsection := Take(1, PriorRollSectionSubsection);

    {Now see if there is any change. If so, we will insert a record.}

  If (((CurrentRollSectionSubsection[1] in ['1', '3', '6']) and
       (PriorRollSectionSubsection[1] in ['5', '7', '8'])) or
      ((PriorRollSectionSubsection[1] in ['1', '3', '6']) and
       (CurrentRollSectionSubsection[1] in ['5', '7', '8'])))
    then RollSectionChanged := True;

  If ((PropertyIsResidential(CurrentPropertyClass) and
       (not PropertyIsResidential(PriorPropertyClass))) or
      (PropertyIsResidential(PriorPropertyClass) and
       (not PropertyIsResidential(CurrentPropertyClass))))
    then PropertyClassChanged := True;

    {If the property was roll section 8 in the prior year and in this year,
     we don't care about ANY changes to it since it is wholly exempt and
     does not affect the taxes.}

  If ((CurrentRollSectionSubsection[1] = '8') and
      (PriorRollSectionSubsection[1] = '8'))
    then PropertyIsRollSection8PriorAndCurr := True;

    {Same for roll section 5 - state land - this is because the assessed
     value is set by the state and they already know about any changes.}

  If ((CurrentRollSectionSubsection[1] = '5') and
      (PriorRollSectionSubsection[1] = '5'))
    then PropertyIsRollSection5PriorAndCurr := True;

    {Same for roll section 7 - ceiling railiroad - this is because the assessed
     value is set by the state and they already know about any changes.}

  If ((CurrentRollSectionSubsection[1] = '7') and
      (PriorRollSectionSubsection[1] = '7'))
    then PropertyIsRollSection7PriorAndCurr := True;

  EqualizationIncrease := HstdEqualizationIncrease + NonhstdEqualizationIncrease;
  EqualizationDecrease := HstdEqualizationDecrease + NonhstdEqualizationDecrease;
  PhysicalQtyIncrease := HstdPhysicalQtyIncrease + NonhstdPhysicalQtyIncrease;
  PhysicalQtyDecrease := HstdPhysicalQtyDecrease + NonhstdPhysicalQtyDecrease;

    {FXX01282001-1: Don't show the parcel if it was inactive both years.}
    {FXX05152005-1(2.8.4.4)[2122]: Don't show parcels that did not actually change.}

  ParcelChanged := ((not ((CurrentActiveFlag = InactiveParcelFlag) and
                          (PriorActiveFlag = InactiveParcelFlag))) and
                    (not PropertyIsRollSection5PriorAndCurr) and
                    (not PropertyIsRollSection7PriorAndCurr) and
                    (not PropertyIsRollSection8PriorAndCurr) and
                    (RollSectionChanged or
                     PropertyClassChanged or
                     (Deblank(SplitMergeNo) <> '') or
                     (CurrentActiveFlag = InactiveParcelFlag) or
                     (_Compare(PriorHomesteadCode, coNotBlank) and
                      _Compare(CurrentHomesteadCode, PriorHomesteadCode, coNotEqual)) or
                     (_Compare(PriorSchoolCode, coNotBlank) and
                      _Compare(CurrentSchoolCode, PriorSchoolCode, coNotEqual)) or
                     (Roundoff(CurrentAssessedVal, 0) <> Roundoff(PriorAssessedVal, 0)) or
                     ((Roundoff(EqualizationIncrease, 0) <> 0) or
                      (Roundoff(EqualizationDecrease, 0) <> 0) or
                      (Roundoff(PhysicalQtyIncrease, 0) <> 0) or
                      (Roundoff(PhysicalQtyDecrease, 0) <> 0))));

  If ((not Quit) and
      ParcelChanged)
    then
      begin
          {FXX09201999-4: If roll section = 7 prior or current, considered no
                          value.}

        If (CurrentRollSectionSubsection[1] = '7')
          then
            begin
              CurrentHomesteadValue := 0;
              CurrentNonHomesteadValue := 0;
            end;

        If (PriorRollSectionSubsection[1] = '7')
          then
            begin
              PriorHomesteadValue := 0;
              PriorNonHomesteadValue := 0;
            end;

         {FXX12212000-1: Make sure to set the current value to 0 if inactive
                          before checking for conversion from rs 8 so that if
                          a parcel goes from 8 to 1 and is inactivated, it does
                          not show a decrease.}
         {Also, inactive parcels have no assessed value for this report.}
          {FXX03151999-3: If this is an inactive parcel, make all ar change
                          fields 0 - full amount should be calced even if there
                          was a change previously.}

        If (CurrentActiveFlag = InactiveParcelFlag)
          then
            begin
                {FXX04261999-3: Need seperate flag for inactive since
                                it can be inactive and computed.}

              InactiveParcel := True;
              CurrentHomesteadValue := 0;
              CurrentNonhomesteadValue := 0;

              HstdEqualizationIncrease := 0;
              HstdEqualizationDecrease := 0;
              HstdPhysicalQtyIncrease := 0;
              HstdPhysicalQtyDecrease := 0;
              NonhstdEqualizationIncrease := 0;
              NonhstdEqualizationDecrease := 0;
              NonhstdPhysicalQtyIncrease := 0;
              NonhstdPhysicalQtyDecrease := 0;

                {FXX03241999-3: Need to recompute these fields.}

              EqualizationIncrease := HstdEqualizationIncrease + NonhstdEqualizationIncrease;
              EqualizationDecrease := HstdEqualizationDecrease + NonhstdEqualizationDecrease;
              PhysicalQtyIncrease := HstdPhysicalQtyIncrease + NonhstdPhysicalQtyIncrease;
              PhysicalQtyDecrease := HstdPhysicalQtyDecrease + NonhstdPhysicalQtyDecrease;

                {FXX12242000-1: Also make sure to blank out the prior AV if this used
                                to be a rs7 or rs8 and is now inactive.}

              If (PriorRollSectionSubsection[1] in ['7', '8'])
                then
                  begin
                    PriorHomesteadValue := 0;
                    PriorNonhomesteadValue := 0;
                  end;

            end;  {If (CurrentActiveFlag = InactiveParcelFlag)}

          {FXX09222006-1(2.10.1.11): A move from roll section 5 is an equalization change.}

        If ((_Compare(CurrentRollSectionSubsection, '5', coStartsWith) or
             _Compare(PriorRollSectionSubsection, '5', coStartsWith)) and
            (not PropertyIsRollSection5PriorAndCurr))
          then
            begin
              MismatchCode := 'C';
              HstdEqualizationIncrease := 0;
              HstdEqualizationDecrease := 0;
              HstdPhysicalQtyIncrease := 0;
              HstdPhysicalQtyDecrease := 0;
              NonhstdEqualizationIncrease := 0;
              NonhstdEqualizationDecrease := 0;
              NonhstdPhysicalQtyIncrease := 0;
              NonhstdPhysicalQtyDecrease := 0;

              If _Compare(CurrentRollSectionSubsection, '5', coStartsWith)
                then
                  begin
                    HstdEqualizationDecrease := PriorHomesteadValue;
                    NonhstdEqualizationDecrease := PriorNonhomesteadValue;
                  end
                else
                  begin
                    HstdEqualizationIncrease := CurrentHomesteadValue;
                    NonhstdEqualizationIncrease := CurrentNonhomesteadValue;
                  end;

                {FXX03241999-3: Need to recompute these fields.}

              EqualizationIncrease := HstdEqualizationIncrease + NonhstdEqualizationIncrease;
              EqualizationDecrease := HstdEqualizationDecrease + NonhstdEqualizationDecrease;
              PhysicalQtyIncrease := HstdPhysicalQtyIncrease + NonhstdPhysicalQtyIncrease;
              PhysicalQtyDecrease := HstdPhysicalQtyDecrease + NonhstdPhysicalQtyDecrease;

            end;  {If (not PropertyIsRollSection8PriorAndCurr)}

           {FXX09091998-2: If the property switched too or from roll section 8,
                           we do not want to use any of the increase or decrease
                           fields that may already be there.}
           {FXX09111998-7: The same thing that applies to roll section 8
                           applies to roll section 7.}

        If (((CurrentRollSectionSubsection[1] = '8') or
             (PriorRollSectionSubsection[1] = '8')) or
            ((CurrentRollSectionSubsection[1] = '7') or
             (PriorRollSectionSubsection[1] = '7')) and
            (not PropertyIsRollSection8PriorAndCurr))
          then
            begin
              MismatchCode := 'C';
              HstdEqualizationIncrease := 0;
              HstdEqualizationDecrease := 0;
              HstdPhysicalQtyIncrease := 0;
              HstdPhysicalQtyDecrease := 0;
              NonhstdEqualizationIncrease := 0;
              NonhstdEqualizationDecrease := 0;
              NonhstdPhysicalQtyIncrease := 0;
              NonhstdPhysicalQtyDecrease := 0;

              If ((CurrentRollSectionSubsection[1] = '8') or
                  (CurrentRollSectionSubsection[1] = '7'))
                then
                  begin
                    HstdPhysicalQtyDecrease := PriorHomesteadValue;
                    NonhstdPhysicalQtyDecrease := PriorNonhomesteadValue;
                  end
                else
                  begin
                    HstdPhysicalQtyIncrease := CurrentHomesteadValue;
                    NonhstdPhysicalQtyIncrease := CurrentNonhomesteadValue;
                  end;

                {FXX03241999-3: Need to recompute these fields.}

              EqualizationIncrease := HstdEqualizationIncrease + NonhstdEqualizationIncrease;
              EqualizationDecrease := HstdEqualizationDecrease + NonhstdEqualizationDecrease;
              PhysicalQtyIncrease := HstdPhysicalQtyIncrease + NonhstdPhysicalQtyIncrease;
              PhysicalQtyDecrease := HstdPhysicalQtyDecrease + NonhstdPhysicalQtyDecrease;

            end;  {If (not PropertyIsRollSection8PriorAndCurr)}

          {Figure out the mismatch code. The possible mismatch codes are;
           I on left side - Inactive parcel.
           B on right side - current year parcel out of balance
           C on right side - increase or decrease is calculated}

          {To see if the current year balances, take the current year
           (Prior) value, subtract the increases and add back the decreases
           and we should get the Current value. If we do not, it is out of
           balance. Note that we do not consider a parcel out of balance
           if the increase and decrease fields are all empty. In
           this case, we will compute the increase or decrease and
           give it a mismatch code of 'C'.}

          {However, if this is a property that became roll section 8,
           we will make the current assessed value 0 since this is what
           it is for the municipality (tax-wise). Then, the parcel should
           balance even though the assessed value is not 0.}

        If (CurrentRollSectionSubsection[1] = '8')
          then
            begin
              CurrentHomesteadValue := 0;
              CurrentNonHomesteadValue := 0;
            end;

        If (PriorRollSectionSubsection[1] = '8')
          then
            begin
              PriorHomesteadValue := 0;
              PriorNonHomesteadValue := 0;
            end;

          {FXX04201999-1: Do not list rs.5 increase and decreases.}

        If ((CurrentRollSectionSubsection[1] = '5') and  {Is rs 5 now}
            ((PriorRollSectionSubsection[1] = '5') or  {Used to be rs 5 or}
             (Deblank(PriorRollSectionSubsection) = '')))  {Did not exist prior year}
          then
            begin
              HstdEqualizationIncrease := 0;
              HstdEqualizationDecrease := 0;
              HstdPhysicalQtyIncrease := 0;
              HstdPhysicalQtyDecrease := 0;
              NonhstdEqualizationIncrease := 0;
              NonhstdEqualizationDecrease := 0;
              NonhstdPhysicalQtyIncrease := 0;
              NonhstdPhysicalQtyDecrease := 0;

              If (CurrentRollSectionSubsection[1] = '5')
                then
                  begin
                    CurrentHomesteadValue := 0;
                    CurrentNonHomesteadValue := 0;
                  end;

              If (PriorRollSectionSubsection[1] = '5')
                then
                  begin
                    PriorHomesteadValue := 0;
                    PriorNonHomesteadValue := 0;
                  end;

            end;  {If ((CurrentRollSectionSubsection[1] = '5') and ...}

          {FXX09091998-6: No roll section 8's.}
          {FXX02012004-3(2.07l): We also need to exclude roll section 5's.}
          {CHG04152004-1(2.07l3): Attribute out of balance extra value to equalization.}

        AdjustedValue := Roundoff((CurrentAssessedVal -
                                  (EqualizationIncrease + PhysicalQtyIncrease) +
                                  (EqualizationDecrease + PhysicalQtyDecrease)), 0);
        Difference := Roundoff((AdjustedValue - PriorAssessedVal), 0);

        If (((Roundoff(EqualizationIncrease, 0) <> 0) or
             (Roundoff(EqualizationDecrease, 0) <> 0) or
             (Roundoff(PhysicalQtyIncrease, 0) <> 0) or
             (Roundoff(PhysicalQtyDecrease, 0) <> 0)) and
            (Roundoff(Difference, 0) <> 0) and
            (PriorRollSectionSubsection[1] <> '8') and
            (CurrentRollSectionSubsection[1] <> '8') and
            (PriorRollSectionSubsection[1] <> '7') and
            (CurrentRollSectionSubsection[1] <> '7') and
            (PriorRollSectionSubsection[1] <> '5') and
            (CurrentRollSectionSubsection[1] <> '5'))
          then MismatchCode := 'B';

        If (IgnoreFalseImbalances and
            _Compare(MismatchCode, 'B', coEqual) and
            _Compare((CurrentAssessedVal - PriorAssessedVal), 0, coEqual) and
            (_Compare(EqualizationIncrease, 0, coGreaterThan) or
             _Compare(EqualizationDecrease, 0, coGreaterThan) or
             _Compare(PhysicalQtyIncrease, 0, coGreaterThan) or
             _Compare(PhysicalQtyDecrease, 0, coGreaterThan)))
          then
            begin
              EqualizationIncrease := 0;
              EqualizationDecrease := 0;
              PhysicalQtyIncrease := 0;
              PhysicalQtyDecrease := 0;
              HstdEqualizationIncrease := 0;
              HstdEqualizationDecrease := 0;
              HstdPhysicalQtyIncrease := 0;
              HstdPhysicalQtyDecrease := 0;
              NonhstdEqualizationIncrease := 0;
              NonhstdEqualizationDecrease := 0;
              NonhstdPhysicalQtyIncrease := 0;
              NonhstdPhysicalQtyDecrease := 0;
              MismatchCode := ' ';

            end;  {If (IgnoreFalseImbalances and...}

        If (AttributeImbalancesToEqualization and
            (Difference <> 0) and
            (MismatchCode = 'B'))
          then
            begin
              MismatchCode := ' ';

              If (CurrentHomesteadCode = 'N')
                then
                  begin
                    If (Difference > 0)
                      then NonhstdEqualizationIncrease := NonhstdEqualizationIncrease + Difference
                      else NonhstdEqualizationDecrease := NonhstdEqualizationDecrease + (-1 * Difference);

                  end
                else
                  begin
                    If (Difference > 0)
                      then HstdEqualizationIncrease := HstdEqualizationIncrease + Difference
                      else HstdEqualizationDecrease := HstdEqualizationDecrease + (-1 * Difference);

                  end;  {else of If (CurrentHomesteadCode = 'N')}

            end;  {If (AttributeImbalancesToEqualization and...}

          {If the increase and decrease amounts are not filled in,
           then we will compute it. In the case of property codes
           731, 732, 733 or a roll section change, it is a physical
           qty change. Otherwise, it is computed as an equalization
           change.}
          {FXX09131998-1: Don't compute for inactives.}
          {FXX12281998-1: Actually, do compute for inactives - check if true
                          for Westchester - leaving out for now.}
          {FXX08231999-5: Do compute for inactives in Westchester, too.}

        If ((Roundoff(CurrentAssessedVal, 0) <> Roundoff(PriorAssessedVal, 0)) and
            (Roundoff(EqualizationIncrease, 0) = 0) and
            (Roundoff(EqualizationDecrease, 0) = 0) and
            (Roundoff(PhysicalQtyIncrease, 0) = 0) and
            (Roundoff(PhysicalQtyDecrease, 0) = 0))
          then
            begin
              MismatchCode := 'C';

                {FXX01231998-4: The AV difference for computed parcels
                                was not being correctly computed.}
                {CHG07082003-1(2.07f): Allow option to attribute inactivations or new parcels to physical change.}

              HstdAVDifference := CurrentHomesteadValue - PriorHomesteadValue;
              NonhstdAVDifference := CurrentNonhomesteadValue - PriorNonhomesteadValue;

              If ((PriorPropertyClass = '731') or
                  (PriorPropertyClass = '732') or
                  (PriorPropertyClass = '733') or
                  RollSectionChanged or
                  (AttributeInactivationsOrNewParcelsToPhysicalChange and
                   ((CurrentActiveFlag = InactiveParcelFlag) or
                    (PriorActiveFlag = InactiveParcelFlag) or
                    (Roundoff(PriorAssessedVal, 0) = 0))))
                then
                  begin
                    If (Roundoff(HstdAVDifference, 0) > 0)
                      then HstdPhysicalQtyIncrease := HstdAVDifference
                      else HstdPhysicalQtyDecrease := -1 * HstdAVDifference;

                    If (Roundoff(NonhstdAVDifference, 0) > 0)
                      then NonhstdPhysicalQtyIncrease := NonhstdAVDifference
                      else NonhstdPhysicalQtyDecrease := -1 * NonhstdAVDifference;

                  end
                else
                  begin
                    If (Roundoff(HstdAVDifference, 0) > 0)
                      then HstdEqualizationIncrease := HstdAVDifference
                      else HstdEqualizationDecrease := -1 * HstdAVDifference;

                    If (Roundoff(NonhstdAVDifference, 0) > 0)
                      then NonhstdEqualizationIncrease := NonhstdAVDifference
                      else NonhstdEqualizationDecrease := -1 * NonhstdAVDifference;

                  end;  {else of If ((PriorPropertyClass = '731') or ...}

            end;  {If ((Roundoff(TYAssessedVal, 0) ...}

        _Found := FindKeyOld(SortAssessedValChangesTable,
                            ['SwisCode', 'SBLKey'],
                            [SwisCode, SBLKey]);

        with SortAssessedValChangesTable do
          try
            If _Found
              then Edit
              else
                begin
                  Insert;

                  FieldByName('SwisCode').Text := Copy(SwisSBLKey, 1, 6);
                  FieldByName('SBLKey').Text := Copy(SwisSBLKey, 7, 20);

                  FieldByName('PriorSchoolCode').Text := PriorSchoolCode;
                  FieldByName('PriorPropertyClass').Text := PriorPropertyClass;
                  FieldByName('PriorOwnershipCode').Text := PriorOwnershipCode;
                  FieldByName('PriorRollSect_Subsec').Text := PriorRollSectionSubsection;
                  FieldByName('PriorHomesteadCode').Text := PriorHomesteadCode;
                  TCurrencyField(FieldByName('PriorAssessedVal')).Value := PriorAssessedVal;

                end;  {If Found}

            FieldByName('SplitMergeNo').Text := SplitMergeNo;
            FieldByName('Name').Text := _Name;

            FieldByName('CurrSchoolCode').Text := CurrentSchoolCode;
            FieldByName('CurrOwnershipCode').Text := CurrentOwnershipCode;
            FieldByName('CurrPropertyClass').Text := CurrentPropertyClass;
            FieldByName('CurrRollSect_Subsect').Text := CurrentRollSectionSubsection;
            FieldByName('CurrHomesteadCode').Text := CurrentHomesteadCode;
            TCurrencyField(FieldByName('CurrAssessedVal')).Value := CurrentAssessedVal;
            TCurrencyField(FieldByName('HstdEqualInc')).Value := (*FieldByName('HstdEqualInc').AsFloat +*)
                                                                 HstdEqualizationIncrease;
            TCurrencyField(FieldByName('HstdEqualDec')).Value := (*FieldByName('HstdEqualDec').AsFloat +*)
                                                                 HstdEqualizationDecrease;
            TCurrencyField(FieldByName('HstdPhysQtyInc')).Value := (*FieldByName('HstdPhysQtyInc').AsFloat +*)
                                                                   HstdPhysicalQtyIncrease;
            TCurrencyField(FieldByName('HstdPhysQtyDec')).Value := (*FieldByName('HstdPhysQtyDec').AsFloat +*)
                                                                   HstdPhysicalQtyDecrease;
            TCurrencyField(FieldByName('NonhstdEqualInc')).Value := (*FieldByName('NonhstdEqualInc').AsFloat +*)
                                                                    NonhstdEqualizationIncrease;
            TCurrencyField(FieldByName('NonhstdEqualDec')).Value := (*FieldByName('NonhstdEqualDec').AsFloat +*)
                                                                    NonhstdEqualizationDecrease;
            TCurrencyField(FieldByName('NonhstdPhysQtyInc')).Value := (*FieldByName('NonhstdPhysQtyInc').AsFloat +*)
                                                                      NonhstdPhysicalQtyIncrease;
            TCurrencyField(FieldByName('NonhstdPhysQtyDec')).Value := (*FieldByName('NonhstdPhysQtyDec').AsFloat +*)
                                                                      NonhstdPhysicalQtyDecrease;

              {Do not overwrite any existing mismatch message.}

            If (Deblank(FieldByName('MismatchMessage').Text) = '')
              then FieldByName('MismatchMessage').Text := MismatchCode;
            FieldByName('Inactive').AsBoolean := InactiveParcel;

            Post;
          except
            Quit := True;
            SystemSupport(054, SortAssessedValChangesTable, 'Error inserting AV change sort record.',
                          UnitName, GlblErrorDlgBox);
          end;

          {If this is computed, post an entry in the computed table.}

        If (MismatchCode = 'C')
          then
            with SortComputedChangesTable do
              try
                Insert;

                FieldByName('SwisSBLKey').Text := SwisSBLKey;
                FieldByName('TaxRollYr').Text := GetTaxRollYearForProcessingType(ProcessingType);
                FieldByName('ClassRecord').AsBoolean := (CurrentHomesteadCode = 'S');

                FieldByName('HstdEqualInc').AsFloat := HstdEqualizationIncrease;
                FieldByName('HstdEqualDec').AsFloat := HstdEqualizationDecrease;
                FieldByName('HstdPhysQtyInc').AsFloat := HstdPhysicalQtyIncrease;
                FieldByName('HstdPhysQtyDec').AsFloat := HstdPhysicalQtyDecrease;
                FieldByName('NonhstdEqualInc').AsFloat := NonhstdEqualizationIncrease;
                FieldByName('NonhstdEqualDec').AsFloat := NonhstdEqualizationDecrease;
                FieldByName('NonhstdPhysQtyInc').AsFloat := NonhstdPhysicalQtyIncrease;
                FieldByName('NonhstdPhysQtyDec').AsFloat := NonhstdPhysicalQtyDecrease;

                Post;
              except
                SystemSupport(055, SortComputedChangesTable, 'Error posting to computed changes table.',
                              'RPASRUTL', GlblErrorDlgBox);
              end;

      end;  {If (RollSectionChanged or ...}

end;  {InsertOneAVChangeRecord}

{===================================================================}
Procedure UpdateAVChangeSortTable(    SortAssessedValChangesTable,
                                      SortSummaryTable,
                                      SortComputedChangesTable,
                                      SortAVChangesTable : TTable;
                                      AttributeInactivationsOrNewParcelsToPhysicalChange,
                                      AttributeImbalancesToEqualization : Boolean;
                                  var _HstdEqualizationIncrease,
                                      _HstdEqualizationDecrease,
                                      _HstdPhysicalQtyIncrease,
                                      _HstdPhysicalQtyDecrease,
                                      _NonhstdEqualizationIncrease,
                                      _NonhstdEqualizationDecrease,
                                      _NonhstdPhysicalQtyIncrease,
                                      _NonhstdPhysicalQtyDecrease : Comp;
                                  var Quit : Boolean);

var
  CurrentHomesteadValue, CurrentNonhomesteadValue,
  PriorHomesteadValue, PriorNonhomesteadValue,
  TYHstdEqualizationIncrease, TYHstdEqualizationDecrease,
  TYHstdPhysicalQtyIncrease, TYHstdPhysicalQtyDecrease,
  TYNonhstdEqualizationIncrease, TYNonhstdEqualizationDecrease,
  TYNonhstdPhysicalQtyIncrease, TYNonhstdPhysicalQtyDecrease,
  NYHstdEqualizationIncrease, NYHstdEqualizationDecrease,
  NYHstdPhysicalQtyIncrease, NYHstdPhysicalQtyDecrease,
  NYNonhstdEqualizationIncrease, NYNonhstdEqualizationDecrease,
  NYNonhstdPhysicalQtyIncrease, NYNonhstdPhysicalQtyDecrease : Comp;
  CurrentRollSectionSbs, PriorRollSectionSbs,
  CurrentPropertyClass, PriorPropertyClass,
  CurrentOwnershipCode, CurrentActiveFlag, CurrentHomesteadCode,
  PriorOwnershipCode, PriorActiveFlag, PriorHomesteadCode,
  CurrentSchoolCode, PriorSchoolCode, SplitMergeNo,
  SwisSBLKey, _Name : String;

begin
  NYHstdEqualizationIncrease := 0;
  NYHstdEqualizationDecrease := 0;
  NYHstdPhysicalQtyIncrease := 0;
  NYHstdPhysicalQtyDecrease := 0;
  NYNonhstdEqualizationIncrease := 0;
  NYNonhstdEqualizationDecrease := 0;
  NYNonhstdPhysicalQtyIncrease := 0;
  NYNonhstdPhysicalQtyDecrease := 0;

  TYHstdEqualizationIncrease := 0;
  TYHstdEqualizationDecrease := 0;
  TYHstdPhysicalQtyIncrease := 0;
  TYHstdPhysicalQtyDecrease := 0;
  TYNonhstdEqualizationIncrease := 0;
  TYNonhstdEqualizationDecrease := 0;
  TYNonhstdPhysicalQtyIncrease := 0;
  TYNonhstdPhysicalQtyDecrease := 0;

    {FXX10181999-1: If they use Westchester logic, do TY to NY.}

  If GlblIsWestchesterCounty
    then
      begin
        with SortSummaryTable do
          begin
            CurrentHomesteadValue := FieldByName('NYHstdValue').AsFloat;
            CurrentNonhomesteadValue := FieldByName('NYNonhstdValue').AsFloat;
            NYHstdEqualizationIncrease := FieldByName('NYHstdEqInc').AsFloat;
            NYHstdEqualizationDecrease := FieldByName('NYHstdEqDec').AsFloat;
            NYHstdPhysicalQtyIncrease := FieldByName('NYHstdPhysInc').AsFloat;
            NYHstdPhysicalQtyDecrease := FieldByName('NYHstdPhysDec').AsFloat;
            NYNonhstdEqualizationIncrease := FieldByName('NYNonhstdEqInc').AsFloat;
            NYNonhstdEqualizationDecrease := FieldByName('NYNonhstdEqDec').AsFloat;
            NYNonhstdPhysicalQtyIncrease := FieldByName('NYNonhstdPhysInc').AsFloat;
            NYNonhstdPhysicalQtyDecrease := FieldByName('NYNonhstdPhysDec').AsFloat;
            TYHstdEqualizationIncrease := FieldByName('TYHstdEqInc').AsFloat;
            TYHstdEqualizationDecrease := FieldByName('TYHstdEqDec').AsFloat;
            TYHstdPhysicalQtyIncrease := FieldByName('TYHstdPhysInc').AsFloat;
            TYHstdPhysicalQtyDecrease := FieldByName('TYHstdPhysDec').AsFloat;
            TYNonhstdEqualizationIncrease := FieldByName('TYNonhstdEqInc').AsFloat;
            TYNonhstdEqualizationDecrease := FieldByName('TYNonhstdEqDec').AsFloat;
            TYNonhstdPhysicalQtyIncrease := FieldByName('TYNonhstdPhysInc').AsFloat;
            TYNonhstdPhysicalQtyDecrease := FieldByName('TYNonhstdPhysDec').AsFloat;
            CurrentRollSectionSbs := FieldByName('NYRollSectionSbs').Text;
            CurrentPropertyClass := FieldByName('NYPropertyClass').Text;
            CurrentOwnershipCode := FieldByName('NYOwnershipCode').Text;
            CurrentActiveFlag := FieldByName('NYActiveFlag').Text;
            CurrentHomesteadCode := FieldByName('NYHomesteadCode').Text;
            CurrentSchoolCode := FieldByName('NYSchoolCode').Text;

            PriorRollSectionSbs := FieldByName('TYRollSectionSbs').Text;
            PriorPropertyClass := FieldByName('TYPropertyClass').Text;
            PriorOwnershipCode := FieldByName('TYOwnershipCode').Text;
            PriorHomesteadCode := FieldByName('TYHomesteadCode').Text;
            PriorActiveFlag := FieldByName('TYActiveFlag').Text;
            PriorSchoolCode := FieldByName('TYSchoolCode').Text;
            PriorHomesteadValue := FieldByName('TYHstdValue').AsFloat;
            PriorNonhomesteadValue := FieldByName('TYNonhstdValue').AsFloat;

            SplitMergeNo := FieldByName('NYSplitMergeNo').Text;
            SwisSBLKey := FieldByName('SwisSBLKey').Text;
            _Name := FieldByName('Name').Text;

          end;  {with SortSummaryTable do}

        NYHstdEqualizationIncrease := NYHstdEqualizationIncrease +
                                      TYHstdEqualizationIncrease;
        NYHstdEqualizationDecrease := NYHstdEqualizationDecrease +
                                      TYHstdEqualizationDecrease;
        NYHstdPhysicalQtyIncrease := NYHstdPhysicalQtyIncrease +
                                     TYHstdPhysicalQtyIncrease;
        NYHstdPhysicalQtyDecrease := NYHstdPhysicalQtyDecrease +
                                     TYHstdPhysicalQtyDecrease;
        NYNonhstdEqualizationIncrease := NYNonhstdEqualizationIncrease +
                                         TYNonhstdEqualizationIncrease;
        NYNonhstdEqualizationDecrease := NYNonhstdEqualizationDecrease +
                                         TYNonhstdEqualizationDecrease;
        NYNonhstdPhysicalQtyIncrease := NYNonhstdPhysicalQtyIncrease +
                                        TYNonhstdPhysicalQtyIncrease;
        NYNonhstdPhysicalQtyDecrease := NYNonhstdPhysicalQtyDecrease +
                                        TYNonhstdPhysicalQtyDecrease;

        If (CurrentActiveFlag = InactiveParcelFlag)
          then
            begin
              CurrentHomesteadValue := 0;
              CurrentNonhomesteadValue := 0;
            end;

        If (PriorActiveFlag = InactiveParcelFlag)
          then
            begin
              PriorHomesteadValue := 0;
              PriorNonhomesteadValue := 0;
              NYHstdEqualizationIncrease := 0;
              NYHstdEqualizationDecrease := 0;
              NYHstdPhysicalQtyIncrease := 0;
              NYHstdPhysicalQtyDecrease := 0;
              NYNonhstdEqualizationIncrease := 0;
              NYNonhstdEqualizationDecrease := 0;
              NYNonhstdPhysicalQtyIncrease := 0;
              NYNonhstdPhysicalQtyDecrease := 0;

            end;  {If (PriorActiveFlag = InactiveParcelFlag)}

        with SortSummaryTable do
          InsertOneAVChangeRecord(SortAssessedValChangesTable,
                                  SortComputedChangesTable,
                                  SwisSBLKey, _Name,
                                  PriorHomesteadValue,
                                  PriorNonhomesteadValue,
                                  CurrentHomesteadValue,
                                  CurrentNonhomesteadValue,
                                  PriorRollSectionSbs, CurrentRollSectionSbs,
                                  PriorHomesteadCode, CurrentHomesteadCode,
                                  PriorOwnershipCode, CurrentOwnershipCode,
                                  PriorActiveFlag, CurrentActiveFlag,
                                  PriorPropertyClass, CurrentPropertyClass,
                                  PriorSchoolCode, CurrentSchoolCode,
                                  SplitMergeNo,
                                  AttributeInactivationsOrNewParcelsToPhysicalChange,
                                  AttributeImbalancesToEqualization,
                                  True,
                                  NYHstdEqualizationIncrease,
                                  NYHstdEqualizationDecrease,
                                  NYHstdPhysicalQtyIncrease,
                                  NYHstdPhysicalQtyDecrease,
                                  NYNonhstdEqualizationIncrease,
                                  NYNonhstdEqualizationDecrease,
                                  NYNonhstdPhysicalQtyIncrease,
                                  NYNonhstdPhysicalQtyDecrease,
                                  NextYear, Quit);

        _HstdEqualizationIncrease := NYHstdEqualizationIncrease;
        _HstdEqualizationDecrease := NYHstdEqualizationDecrease;
        _HstdPhysicalQtyIncrease := NYHstdPhysicalQtyIncrease;
        _HstdPhysicalQtyDecrease := NYHstdPhysicalQtyDecrease;
        _NonhstdEqualizationIncrease := NYNonhstdEqualizationIncrease;
        _NonhstdEqualizationDecrease := NYNonhstdEqualizationDecrease;
        _NonhstdPhysicalQtyIncrease := NYNonhstdPhysicalQtyIncrease;
        _NonhstdPhysicalQtyDecrease := NYNonhstdPhysicalQtyDecrease;

      end  {If GlblIsWestchesterCounty}
    else
      begin
          {Changes prior to TY for non-Westchester.}

        with SortSummaryTable do
          begin
            CurrentHomesteadValue := FieldByName('TYHstdValue').AsFloat;
            CurrentNonhomesteadValue := FieldByName('TYNonhstdValue').AsFloat;
            TYHstdEqualizationIncrease := FieldByName('TYHstdEqInc').AsFloat;
            TYHstdEqualizationDecrease := FieldByName('TYHstdEqDec').AsFloat;
            TYHstdPhysicalQtyIncrease := FieldByName('TYHstdPhysInc').AsFloat;
            TYHstdPhysicalQtyDecrease := FieldByName('TYHstdPhysDec').AsFloat;
            TYNonhstdEqualizationIncrease := FieldByName('TYNonhstdEqInc').AsFloat;
            TYNonhstdEqualizationDecrease := FieldByName('TYNonhstdEqDec').AsFloat;
            TYNonhstdPhysicalQtyIncrease := FieldByName('TYNonhstdPhysInc').AsFloat;
            TYNonhstdPhysicalQtyDecrease := FieldByName('TYNonhstdPhysDec').AsFloat;
            CurrentRollSectionSbs := FieldByName('TYRollSectionSbs').Text;
            CurrentPropertyClass := FieldByName('TYPropertyClass').Text;
            CurrentOwnershipCode := FieldByName('TYOwnershipCode').Text;
            CurrentActiveFlag := FieldByName('TYActiveFlag').Text;
            CurrentHomesteadCode := FieldByName('TYHomesteadCode').Text;
            CurrentSchoolCode := FieldByName('TYSchoolCode').Text;

            PriorRollSectionSbs := FieldByName('PriorRollSectionSbs').Text;
            PriorPropertyClass := FieldByName('PriorPropertyClass').Text;
            PriorOwnershipCode := FieldByName('PriorOwnershipCode').Text;
            PriorHomesteadCode := FieldByName('PriorHomesteadCode').Text;
            PriorActiveFlag := FieldByName('PriorActiveFlag').Text;
            PriorSchoolCode := FieldByName('PriorSchoolCode').Text;
            PriorHomesteadValue := FieldByName('PriorHstdValue').AsFloat;
            PriorNonhomesteadValue := FieldByName('PriorNonhstdValue').AsFloat;

            If GlblIsWestchesterCounty
              then SplitMergeNo := FieldByName('NYSplitMergeNo').Text
              else SplitMergeNo := FieldByName('TYSplitMergeNo').Text;

            SwisSBLKey := FieldByName('SwisSBLKey').Text;
            _Name := FieldByName('Name').Text;

          end;  {with SortSummaryTable do}

        If (CurrentActiveFlag = InactiveParcelFlag)
          then
            begin
              CurrentHomesteadValue := 0;
              CurrentNonhomesteadValue := 0;
            end;

        If ((PriorActiveFlag = InactiveParcelFlag) or
            (Deblank(PriorSchoolCode) = ''))  {For munic with no history.}
          then
            begin
              PriorHomesteadValue := 0;
              PriorNonhomesteadValue := 0;
              NYHstdEqualizationIncrease := 0;
              NYHstdEqualizationDecrease := 0;
              NYHstdPhysicalQtyIncrease := 0;
              NYHstdPhysicalQtyDecrease := 0;
              NYNonhstdEqualizationIncrease := 0;
              NYNonhstdEqualizationDecrease := 0;
              NYNonhstdPhysicalQtyIncrease := 0;
              NYNonhstdPhysicalQtyDecrease := 0;

            end;  {If (PriorActiveFlag = InactiveParcelFlag)}

        with SortSummaryTable do
          InsertOneAVChangeRecord(SortAssessedValChangesTable,
                                  SortComputedChangesTable,
                                  SwisSBLKey, _Name,
                                  PriorHomesteadValue,
                                  PriorNonhomesteadValue,
                                  CurrentHomesteadValue,
                                  CurrentNonhomesteadValue,
                                  PriorRollSectionSbs, CurrentRollSectionSbs,
                                  PriorHomesteadCode, CurrentHomesteadCode,
                                  PriorOwnershipCode, CurrentOwnershipCode,
                                  PriorActiveFlag, CurrentActiveFlag,
                                  PriorPropertyClass, CurrentPropertyClass,
                                  PriorSchoolCode, CurrentSchoolCode,
                                  SplitMergeNo,
                                  AttributeInactivationsOrNewParcelsToPhysicalChange,
                                  AttributeImbalancesToEqualization,
                                  True,
                                  TYHstdEqualizationIncrease,
                                  TYHstdEqualizationDecrease,
                                  TYHstdPhysicalQtyIncrease,
                                  TYHstdPhysicalQtyDecrease,
                                  TYNonhstdEqualizationIncrease,
                                  TYNonhstdEqualizationDecrease,
                                  TYNonhstdPhysicalQtyIncrease,
                                  TYNonhstdPhysicalQtyDecrease,
                                  ThisYear, Quit);

        _HstdEqualizationIncrease := TYHstdEqualizationIncrease;
        _HstdEqualizationDecrease := TYHstdEqualizationDecrease;
        _HstdPhysicalQtyIncrease := TYHstdPhysicalQtyIncrease;
        _HstdPhysicalQtyDecrease := TYHstdPhysicalQtyDecrease;
        _NonhstdEqualizationIncrease := TYNonhstdEqualizationIncrease;
        _NonhstdEqualizationDecrease := TYNonhstdEqualizationDecrease;
        _NonhstdPhysicalQtyIncrease := TYNonhstdPhysicalQtyIncrease;
        _NonhstdPhysicalQtyDecrease := TYNonhstdPhysicalQtyDecrease;

      end;  {else of If GlblIsWestchesterCounty}

(*  _HstdEqualizationIncrease := TYHstdEqualizationIncrease + NYHstdEqualizationIncrease;
  _HstdEqualizationDecrease := TYHstdEqualizationDecrease + NYHstdEqualizationDecrease;
  _HstdPhysicalQtyIncrease := TYHstdPhysicalQtyIncrease + NYHstdPhysicalQtyIncrease;
  _HstdPhysicalQtyDecrease := TYHstdPhysicalQtyDecrease + NYHstdPhysicalQtyDecrease;
  _NonhstdEqualizationIncrease := TYNonhstdEqualizationIncrease + NYNonhstdEqualizationIncrease;
  _NonhstdEqualizationDecrease := TYNonhstdEqualizationDecrease + NYNonhstdEqualizationDecrease;
  _NonhstdPhysicalQtyIncrease := TYNonhstdPhysicalQtyIncrease + NYNonhstdPhysicalQtyIncrease;
  _NonhstdPhysicalQtyDecrease := TYNonhstdPhysicalQtyDecrease + NYNonhstdPhysicalQtyDecrease; *)

end;  {UpdateAVChangeSortTable}

{===================================================================}
Procedure SaveTotals(    SortTotalAssessedValTable,
                         SortAVByPropClass_RS_Table,
                         SortExemptionTable : TTable;
                         TotalAssessedValList,
                         TotalByPropClass_RollSectionList,
                         ExemptionSummaryList : TList;
                     var Quit : Boolean);

{Store the total assessed value list and the total by property class\roll section
 list.}

var
  I : Integer;

begin
  For I := 0 to (TotalAssessedValList.Count - 1) do
    with SortTotalAssessedValTable,
         PTotalValueRecord(TotalAssessedValList[I])^ do
      begin
        Insert;

        FieldByName('RecType').Text := RecType;
        FieldByName('MunicipalityCode').Text := MunicipalityCode;
        FieldByName('RollSection').Text := RollSection;
        FieldByName('Block').Text := Block;
        FieldByName('HomestdPriorVal').AsFloat := HstdPriorVal;
        FieldByName('NonhomestdPriorVal').AsFloat := NonhstdPriorVal;
        FieldByName('HomestdCurrentVal').AsFloat := HstdCurrentVal;
        FieldByName('NonhomestdCurrentVal').AsFloat := NonhstdCurrentVal;
        FieldByName('HstdEqualInc').AsFloat := HstdEqualizationIncrease;
        FieldByName('HstdEqualDec').AsFloat := HstdEqualizationDecrease;
        FieldByName('HstdPhysQtyInc').AsFloat := HstdPhysicalQtyIncrease;
        FieldByName('HstdPhysQtyDec').AsFloat := HstdPhysicalQtyDecrease;
        FieldByName('NonhstdEqualInc').AsFloat := NonhstdEqualizationIncrease;
        FieldByName('NonhstdEqualDec').AsFloat := NonhstdEqualizationDecrease;
        FieldByName('NonhstdPhysQtyInc').AsFloat := NonhstdPhysicalQtyIncrease;
        FieldByName('NonhstdPhysQtyDec').AsFloat := NonhstdPhysicalQtyDecrease;
        FieldByName('HstdExAmount').AsFloat := HstdExAmount;
        FieldByName('NonhstdExAmount').AsFloat := NonhstdExAmount;

        try
          Post;
        except
          Quit := True;
          SystemSupport(056, SortTotalAssessedValTable,
                        'Error posting total assessed value sort record.',
                        UnitName, GlblErrorDlgBox);
        end;

      end;  {with SortTotalAssessedValTable, ...}

  For I := 0 to (TotalByPropClass_RollSectionList.Count - 1) do
    with SortAVByPropClass_RS_Table,
         PAV_PC_RSRecord(TotalByPropClass_RollSectionList[I])^ do
      begin
        Insert;

        FieldByName('RecType').Text := RecType;
        FieldByName('Category').Text := Category;
        FieldByName('PriorValue').AsFloat := PriorValue;
        FieldByName('PriorNumParcels').AsInteger := PriorNumParcels;
        FieldByName('CurrentValue').AsFloat := CurrentValue;
        FieldByName('CurrentNumParcels').AsInteger := CurrentNumParcels;

        try
          Post;
        except
          Quit := True;
          SystemSupport(057, SortAVByPropClass_RS_Table,
                        'Error posting total by prop class \ roll sect. rec.',
                        UnitName, GlblErrorDlgBox);
        end;

      end;  {with SortAVByPropClass_RS_Table,}

  For I := 0 to (ExemptionSummaryList.Count - 1) do
    with SortExemptionTable,
         PExemptionSummaryRecord(ExemptionSummaryList[I])^ do
      begin
        Insert;

        FieldByName('ExemptionCode').Text := ExemptionCode;
        FieldByName('Description').Text := Description;
        FieldByName('ParcelCount').AsInteger := Count;
        FieldByName('CountyAmount').AsFloat := CountyExAmount;
        FieldByName('TownAmount').AsFloat := TownExAmount;
        FieldByName('SchoolAmount').AsFloat := SchoolExAmount;
        FieldByName('VillageAmount').AsFloat := VillageExAmount;

        try
          Post;
        except
          Quit := True;
          SystemSupport(058, SortExemptionTable,
                        'Error posting exemption sort rec.',
                        UnitName, GlblErrorDlgBox);
        end;

      end;  {with SortExemptionTable,...}

end;  {SaveTotals}

{====================================================================}
Procedure FillInSummaryRecord(ParcelTable,
                              AssessmentTable,
                              ClassTable,
                              ParcelExemptionTable,
                              EXCodeTable,
                              SortSummaryTable : TTable;
                              ExemptionSummaryList : TList;
                              AssessmentYear : String;
                              FieldsToFillIn : Char;  {(P)rior, (T)his Year, (N)ext Year}
                              UsePriorFields,
                              RPS225ReportRun : Boolean);

var
  HomesteadValue, NonhomesteadValue,
  HstdLandVal, NonhstdLandVal,
  BasicSTARAmount, EnhancedSTARAmount,
  AssessedValue,
  HstdEqInc, HstdPhysInc, HstdEqDec, HstdPhysDec,
  NonhstdEqInc, NonhstdPhysInc, NonhstdEqDec, NonhstdPhysDec : Comp;
  HstdAcres, NonhstdAcres, ResPercent : Real;
  PostSuccessful, Quit,
  _Found, AssessmentRecordFound, ClassRecordFound : Boolean;
  SwisSBLKey : String;
  RollSection, RollSubsection,
  HomesteadCode, OwnershipCode, ActiveFlag : String;
  PropertyClass : String;
  SchoolCode : String;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  HstdEXAmounts, NonhstdEXAmounts : ExemptionTotalsArrayType;
  I, J : Integer;
  _Name : String;
  TempBool : Boolean;

begin
  PostSuccessful := True;
  Quit := False;

  repeat
    SwisSBLKey := ExtractSSKey(ParcelTable);
    ExemptionCodes := TStringList.Create;
    ExemptionHomesteadCodes := TStringList.Create;
    ResidentialTypes := TStringList.Create;
    CountyExemptionAmounts := TStringList.Create;
    TownExemptionAmounts := TStringList.Create;
    SchoolExemptionAmounts := TStringList.Create;
    VillageExemptionAmounts := TStringList.Create;

    HstdEqInc := 0;
    HstdPhysInc := 0;
    HstdEqDec := 0;
    HstdPhysDec := 0;
    NonhstdEqInc := 0;
    NonhstdPhysInc := 0;
    NonhstdEqDec := 0;
    NonhstdPhysDec := 0;
    HomesteadValue := 0;
    NonhomesteadValue := 0;

    For I := 1 to 4 do
      begin
        HstdEXAmounts[I] := 0;
        NonhstdEXAmounts[I] := 0;
      end;

    If UsePriorFields
      then
        begin
          with ParcelTable do
            begin
                {FXX11151999-1: Use hold prior fields.}

              SchoolCode := FieldByName('PriorSchoolDistrict').AsString;
              RollSubsection := ' ';
              OwnershipCode := FieldByName('PriorOwnershipCode').AsString;

                {FXX07062008-1(2.13.1.22): If the prior ownership code is blank,
                                           go with the regular one.}

              If _Compare(OwnershipCode, coBlank)
                then OwnershipCode := FieldByName('OwnershipCode').AsString;
              ResPercent := FieldByName('PriorResPercent').AsFloat;
              _Name := FieldByName('Name1').Text;

                {CHG02282000-1: Add fields for 225 run.}

              If RPS225ReportRun
                then
                  begin
                    ActiveFlag := FieldByName('Hold225Status').Text;
                    PropertyClass := FieldByName('Hold225PropClass').Text;
                    RollSection := FieldByName('Hold225RollSection').Text;
                    HomesteadCode := Take(1, FieldByName('Hold225Homestead').Text);
                  end
                else
                  begin
                    ActiveFlag := FieldByName('HoldPriorStatus').Text;
                    PropertyClass := FieldByName('HoldPriorPropClass').Text;
                    RollSection := FieldByName('HoldPriorRollSection').Text;
                    HomesteadCode := Take(1, FieldByName('HoldPriorHomestead').Text);
                  end;

              If (SchoolCode = '000000')
                then SchoolCode := '';

                {FXX12222000-1: If the school code was blank, but the parcel
                                existed, assume that the school code did not
                                change.}

              If ((Deblank(SchoolCode) = '') and
                  (Deblank(RollSection) <> ''))
                then SchoolCode := FieldByName('SchoolCode').Text;

                {FXX01112000-1: Not getting assessment and class records.}

              FindKeyOld(AssessmentTable,
                         ['TaxRollYr', 'SwisSBLKey'],
                         [AssessmentYear, SwisSBLKey]);
              FindKeyOld(ClassTable,
                         ['TaxRollYr', 'SwisSBLKey'],
                         [AssessmentYear, SwisSBLKey]);

              If (HomesteadCode = 'S')
                then
                  begin
                    HomesteadValue := ClassTable.FieldByName('HstdHoldPriorVal').AsFloat;
                    NonhomesteadValue := ClassTable.FieldByName('NonhstdHoldPriorVal').AsFloat;
                  end
                else
                  begin
                    If RPS225ReportRun
                      then AssessedValue := AssessmentTable.FieldByName('Hold225Value').AsFloat
                      else AssessedValue := AssessmentTable.FieldByName('HoldPriorValue').AsFloat;

                    If (Take(1, HomesteadCode)[1] in [' ', 'H'])
                      then HomesteadValue := AssessedValue
                      else NonhomesteadValue := AssessedValue;

                  end;  {else of If (HomesteadCode = 'S')}

            end;  {with ParcelTable do}

        end
      else
        begin
          with ParcelTable do
            begin
              PropertyClass := FieldByName('PropertyClassCode').Text;
              OwnershipCode := FieldByName('OwnershipCode').Text;
              HomesteadCode := Take(1, FieldByName('HomesteadCode').Text);
              RollSection := FieldByName('RollSection').Text;
              SchoolCode := FieldByName('SchoolCode').Text;
              RollSubsection := FieldByName('RollSubsection').Text;
              ActiveFlag := FieldByName('ActiveFlag').Text;
              ResPercent := FieldByName('ResidentialPercent').AsFloat;
              _Name := FieldByName('Name1').Text;

            end;  {with ParcelTable do}

          CalculateHstdAndNonhstdAmounts(AssessmentYear,
                                         ExtractSSKey(ParcelTable),
                                         AssessmentTable,
                                         ClassTable,
                                         ParcelTable,
                                         HomesteadValue,
                                         NonhomesteadValue,
                                         HstdLandVal,  {Not used}
                                         NonhstdLandVal,  {Not used}
                                         HstdAcres, NonhstdAcres, {Not used}
                                         AssessmentRecordFound,
                                         ClassRecordFound);

            {FXX10181999-1: Use the value as of final roll for current value for Westchester.}

          If (GlblIsWestchesterCounty and
              (FieldsToFillIn = 'T'))
            then
              begin
                PropertyClass := ParcelTable.FieldByName('HoldPriorPropClass').Text;
                RollSection := ParcelTable.FieldByName('HoldPriorRollSection').Text;
                ActiveFlag := ParcelTable.FieldByName('HoldPriorStatus').Text;
                HomesteadCode := Take(1, ParcelTable.FieldByName('HoldPriorHomestead').Text);

                  {FxX10262004-1(2.8.0.15): Also get the school code from the prior.}
                  {FXX10132008-1(2.15.1.19): If there is no prior school code, use the actual.}

                SchoolCode := ParcelTable.FieldByName('PriorSchoolDistrict').AsString;

                If _Compare(SchoolCode, coBlank)
                  then SchoolCode := ParcelTable.FieldByName('SchoolCode').AsString;

                  {FXX09172001-1: Need to check homestead code.}

                case Take(1, HomesteadCode)[1] of
                   ' ',
                   'H' : begin
                           HomesteadValue := AssessmentTable.FieldByName('HoldPriorValue').AsFloat;
                           NonhomesteadValue := 0;
                         end;

                   'N' : begin
                           HomesteadValue := 0;
                           NonhomesteadValue := AssessmentTable.FieldByName('HoldPriorValue').AsFloat;
                         end;

                   'S' : begin
                           HomesteadValue := ClassTable.FieldByName('HstdHoldPriorVal').AsFloat;
                           NonhomesteadValue := ClassTable.FieldByName('NonhstdHoldPriorVal').AsFloat;
                         end;

                end;  {case HomesteadCode[1] of}

              end;  {If (GlblIsWestchesterCounty and ...}

            {Fill in the AR fields.}

          If ClassRecordFound
            then
              begin
                with ClassTable do
                  begin
                    HstdEqInc := FieldByName('HstdEqualInc').AsFloat;
                    HstdPhysInc := FieldByName('HstdPhysQtyInc').AsFloat;
                    HstdEqDec := FieldByName('HstdEqualDec').AsFloat;
                    HstdPhysDec := FieldByName('HstdPhysQtyDec').AsFloat;
                    NonhstdEqInc := FieldByName('NonhstdEqualInc').AsFloat;
                    NonhstdPhysInc := FieldByName('NonhstdPhysQtyInc').AsFloat;
                    NonhstdEqDec := FieldByName('NonhstdEqualDec').AsFloat;
                    NonhstdPhysDec := FieldByName('NonhstdPhysQtyDec').AsFloat;

                  end;  {with ClassTable do}

              end
            else
              with AssessmentTable do
                If (HomesteadCode = 'N')
                  then
                    begin
                      NonhstdEqInc := FieldByName('IncreaseForEqual').AsFloat;
                      NonhstdPhysInc := FieldByName('PhysicalQtyIncrease').AsFloat;
                      NonhstdEqDec := Abs(FieldByName('DecreaseForEqual').AsFloat);
                      NonhstdPhysDec := Abs(FieldByName('PhysicalQtyDecrease').AsFloat);
                    end
                  else
                    begin
                      HstdEqInc := FieldByName('IncreaseForEqual').AsFloat;
                      HstdPhysInc := FieldByName('PhysicalQtyIncrease').AsFloat;
                      HstdEqDec := Abs(FieldByName('DecreaseForEqual').AsFloat);
                      HstdPhysDec := Abs(FieldByName('PhysicalQtyDecrease').AsFloat);

                    end;  {else of If (HomesteadCode = 'N')}

            {Get the exemptions for this parcel and store in the totals, too.}

          If (((not GlblIsWestchesterCounty) and
               (FieldsToFillIn = 'T')) or
              (GlblIsWestchesterCounty and
               (FieldsToFillIn = 'N')))
            then
              begin
                TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                         ParcelExemptionTable,
                                         EXCodeTable,
                                         ParcelTable.FieldByName('HomesteadCode').Text, 'A',
                                         ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         ResidentialTypes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         BasicSTARAmount, EnhancedSTARAmount);

                GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                                       ExemptionHomesteadCodes,
                                                       CountyExemptionAmounts,
                                                       TownExemptionAmounts,
                                                       SchoolExemptionAmounts,
                                                       VillageExemptionAmounts,
                                                       HstdEXAmounts,
                                                       NonhstdEXAmounts);

                  {Store the exemption totals.}

                If (Roundoff(BasicSTARAmount, 0) > 0)
                  then
                    begin
                      ExemptionCodes.Add(BasicSTARExemptionCode);
                      ExemptionHomesteadCodes.Add(HomesteadCode);
                      CountyExemptionAmounts.Add('0');
                      TownExemptionAmounts.Add('0');
                      SchoolExemptionAmounts.Add(FloatToStr(BasicSTARAmount));
                      VillageExemptionAmounts.Add('0');

                    end;  {If (Roundoff(BasicSTARAmount, 0) > 0)}

                If (Roundoff(EnhancedSTARAmount, 0) > 0)
                  then
                    begin
                      ExemptionCodes.Add(EnhancedSTARExemptionCode);
                      ExemptionHomesteadCodes.Add(HomesteadCode);
                      CountyExemptionAmounts.Add('0');
                      TownExemptionAmounts.Add('0');
                      SchoolExemptionAmounts.Add(FloatToStr(EnhancedSTARAmount));
                      VillageExemptionAmounts.Add('0');

                    end;  {If (Roundoff(EnhancedSTARAmount, 0) > 0)}

                  {FXX10291999-1: Don't store exemptions if not active.}

                If (ActiveFlag <> InactiveParcelFlag)
                  then UpdateExemptionSummary(ExemptionSummaryList, ExemptionCodes,
                                              ExemptionHomesteadCodes,
                                              CountyExemptionAmounts,
                                              TownExemptionAmounts,
                                              SchoolExemptionAmounts,
                                              VillageExemptionAmounts, ExCodeTable);

             end;  {If (((not GlblIsWestchesterCounty) and ...}

        end;  {else of If UsePriorFields}

    _Found := FindKeyOld(SortSummaryTable, ['SwisSBLKey'],
                        [SwisSBLKey]);

    with SortSummaryTable do
      try
        If _Found
          then Edit
          else
            begin
              Insert;
              FieldByName('SwisSBLKey').Text := SwisSBLKey;
            end;

        case FieldsToFillIn of
          'P' : begin
                  FieldByName('PriorRollSectionSbs').Text := RollSection + RollSubsection;
                  FieldByName('PriorPropertyClass').Text := PropertyClass;
                  FieldByName('PriorActiveFlag').Text := ActiveFlag;
                  FieldByName('PriorHomesteadCode').Text := HomesteadCode;
                  FieldByName('PriorOwnershipCode').Text := OwnershipCode;
                  FieldByName('PriorResPercent').AsFloat := ResPercent;
                  FieldByName('PriorHstdValue').AsFloat := HomesteadValue;
                  FieldByName('PriorNonhstdValue').AsFloat := NonhomesteadValue;
                  FieldByName('PriorSchoolCode').Text := SchoolCode;
                  FieldByName('Name').Text := Take(15, _Name);

                  If (Deblank(SchoolCode) <> '')
                    then FieldByName('PriorParcelExists').AsBoolean := True;

                end;  {Prior}

          'T' : begin
                  FieldByName('TYRollSectionSbs').Text := RollSection + RollSubsection;
                  FieldByName('TYPropertyClass').Text := PropertyClass;
                  FieldByName('TYActiveFlag').Text := ActiveFlag;
                  FieldByName('TYHomesteadCode').Text := HomesteadCode;
                  FieldByName('TYOwnershipCode').Text := OwnershipCode;
                  FieldByName('TYSchoolCode').Text := SchoolCode;
                  FieldByName('TYResPercent').AsFloat := ResPercent;
                  FieldByName('TYHstdValue').AsFloat := HomesteadValue;
                  FieldByName('TYNonhstdValue').AsFloat := NonhomesteadValue;
                  FieldByName('TYHstdEqInc').AsFloat := HstdEqInc;
                  FieldByName('TYHstdPhysInc').AsFloat := HstdPhysInc;
                  FieldByName('TYHstdEqDec').AsFloat := HstdEqDec;
                  FieldByName('TYHstdPhysDec').AsFloat := HstdPhysDec;
                  FieldByName('TYNonhstdEqInc').AsFloat := NonhstdEqInc;
                  FieldByName('TYNonhstdPhysInc').AsFloat := NonhstdPhysInc;
                  FieldByName('TYNonhstdEqDec').AsFloat := NonhstdEqDec;
                  FieldByName('TYNonhstdPhysDec').AsFloat := NonhstdPhysDec;
                  FieldByName('TYHstdEXAmount').AsFloat := HstdEXAmounts[EXTown];
                  FieldByName('TYNonhstdEXAmount').AsFloat := NonhstdEXAmounts[EXTown];

                    {FXX07122007-1(2.11.2.3)[D903]: Part 3 (Transmittal letter) should
                                                    show the school taxable values.}

                  try
                    FieldByName('TYSchoolHstdEX').AsInteger := Trunc(HstdEXAmounts[EXSchool]);
                    FieldByName('TYSchoolNonhstdEX').AsInteger := Trunc(NonhstdEXAmounts[EXSchool]);
                  except
                  end;

                  FieldByName('Name').Text := Take(15, _Name);
                  FieldByName('TYSplitMergeNo').Text := ParcelTable.FieldByName('SplitMergeNo').Text;

                  If (Deblank(SchoolCode) <> '')
                    then FieldByName('TYParcelExists').AsBoolean := True;

                end;  {TY}

          'N' : begin
                  FieldByName('NYRollSectionSbs').Text := RollSection + RollSubsection;
                  FieldByName('NYPropertyClass').Text := PropertyClass;
                  FieldByName('NYActiveFlag').Text := ActiveFlag;
                  FieldByName('NYHomesteadCode').Text := HomesteadCode;
                  FieldByName('NYOwnershipCode').Text := OwnershipCode;
                  FieldByName('NYSchoolCode').Text := SchoolCode;
                  FieldByName('NYResPercent').AsFloat := ResPercent;
                  FieldByName('NYHstdValue').AsFloat := HomesteadValue;
                  FieldByName('NYNonhstdValue').AsFloat := NonhomesteadValue;
                  FieldByName('NYHstdEqInc').AsFloat := HstdEqInc;
                  FieldByName('NYHstdPhysInc').AsFloat := HstdPhysInc;
                  FieldByName('NYHstdEqDec').AsFloat := HstdEqDec;
                  FieldByName('NYHstdPhysDec').AsFloat := HstdPhysDec;
                  FieldByName('NYNonhstdEqInc').AsFloat := NonhstdEqInc;
                  FieldByName('NYNonhstdPhysInc').AsFloat := NonhstdPhysInc;
                  FieldByName('NYNonhstdEqDec').AsFloat := NonhstdEqDec;
                  FieldByName('NYNonhstdPhysDec').AsFloat := NonhstdPhysDec;
                  FieldByName('NYHstdEXAmount').AsFloat := HstdEXAmounts[EXTown];
                  FieldByName('NYNonhstdEXAmount').AsFloat := NonhstdEXAmounts[EXTown];

                    {FXX07122007-1(2.11.2.3)[D903]: Part 3 (Transmittal letter) should
                                                    show the school taxable values.}

                  try
                    FieldByName('NYSchoolHstdEX').AsInteger := Trunc(HstdEXAmounts[EXSchool]);
                    FieldByName('NYSchoolNonhstdEX').AsInteger := Trunc(NonhstdEXAmounts[EXSchool]);
                  except
                  end;

                  FieldByName('Name').Text := Take(15, _Name);
                  FieldByName('NYSplitMergeNo').Text := ParcelTable.FieldByName('SplitMergeNo').Text;

                  If (Deblank(SchoolCode) <> '')
                    then FieldByName('NYParcelExists').AsBoolean := True;

                  TempBool := FieldByName('NYParcelExists').AsBoolean;

                end;  {NY}

        end;  {case FieldsToFillIn of}

        Post;

      except
        SortSummaryTable.Cancel;
        PostSuccessful := False;

        SystemSupport(059, SortSummaryTable, 'Error updating sort summary table.',
                      'RPASRUTL', GlblErrorDlgBox);
      end;

    ExemptionCodes.Free;
    ExemptionHomesteadCodes.Free;
    CountyExemptionAmounts.Free;
    ResidentialTypes.Free;
    TownExemptionAmounts.Free;
    SchoolExemptionAmounts.Free;
    VillageExemptionAmounts.Free;

  until (PostSuccessful or Quit);

end;  {FillInSummaryRecord}

{========================================================================}
Procedure FillSortFiles(AssessmentTable,
                        ParcelTable,
                        SwisCodeTable,
                        SortTotalAssessedValTable,
                        SortAssessedValChangesTable,
                        SortAVByPropClass_RS_Table,
                        SortExemptionTable,
                        SortComputedChangesTable,
                        SortSummaryTable,
                        SortAVChangesTable,
                        AssessmentYearCtlFile,
                        SchoolCodeTable,
                        ClassTable,
                        ParcelExemptionTable,
                        EXCodeTable : TTable;
                        SwisCodeListBox : TListBox;
                        ProgressDialog : TProgressDialog;
                        Form : TForm;
                        RPS225ReportRun : Boolean;
                        AttributeInactivationsOrNewParcelsToPhysicalChange,
                        AttributeImbalancesToEqualization : Boolean;
                    var Quit : Boolean);

var
  CurrentParcelExists, PriorParcelExists,
  Done, FirstTimeThrough, PriorRecordsExist : Boolean;
  HistoryYear : String;
  TempYear, I : Integer;
  RecCount : LongInt;
  CurrentHomesteadValue, CurrentNonhomesteadValue,
  PriorHomesteadValue, PriorNonhomesteadValue,
  HstdEqualizationIncrease, HstdEqualizationDecrease,
  HstdPhysicalQtyIncrease, HstdPhysicalQtyDecrease,
  NonhstdEqualizationIncrease, NonhstdEqualizationDecrease,
  NonhstdPhysicalQtyIncrease, NonhstdPhysicalQtyDecrease,
  HstdExAmount, NonhstdExAmount,
  HstdSchoolExAmount, NonhstdSchoolExAmount : Comp;
  CurrentRollSectionSbs, PriorRollSectionSbs : String;
  CurrentPropertyClass, PriorPropertyClass : String;
  CurrentOwnershipCode, CurrentActiveFlag, CurrentHomesteadCode,
  PriorOwnershipCode, PriorActiveFlag, PriorHomesteadCode : String;
  CurrentSchoolCode, PriorSchoolCode : String;
  SelectedSwisCodes : TStringList;
  TotalAssessedValList,
  TotalByPropClass_RollSectionList, ExemptionSummaryList : TList;
  SwisSBLKey, SwisCode, TempStr : String;
  ExtractFileTY, ExtractFilePrior : TextFile;

begin
(*  AssignFile(ExtractFileTY, 'c:\AAR_TY.txt');
  Rewrite(ExtractFileTY);
  AssignFile(ExtractFilePrior, 'c:\AAR_Prior.txt');
  Rewrite(ExtractFilePrior); *)
  TempYear := StrToInt(GlblThisYear);
  HistoryYear := IntToStr(TempYear - 1);

  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             History, Quit);
  PriorRecordsExist := (GetRecordCount(ParcelTable) > 0);

     {First do a pass through the TY file - also do prior if no
      prior exists.}

  SelectedSwisCodes := TStringList.Create;
  TotalAssessedValList := TList.Create;
  TotalByPropClass_RollSectionList := TList.Create;
  ExemptionSummaryList := TList.Create;

  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             ThisYear, Quit);
  OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName,
                             ThisYear, Quit);
  OpenTableForProcessingType(EXCodeTable, ExemptionCodesTableName,
                             ThisYear, Quit);
  OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                             ThisYear, Quit);
  OpenTableForProcessingType(ClassTable, ClassTableName,
                             ThisYear, Quit);

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    If SwisCodeListBox.Selected[I]
      then SelectedSwisCodes.Add(SwisCodeListBox.Items[I]);

  ParcelTable.First;
  TrialRun := False;

    {Go through the Current parcel table.}

  FirstTimeThrough := True;
  Quit := False;

  ProgressDialog.UserLabelCaption := 'Filling Sort File - TY';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    Done := ParcelTable.EOF;

    Application.ProcessMessages;
    ProgressDialog.Update(Form, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));
    ReportCancelled := ProgressDialog.Cancelled;

    SwisSBLKey := ExtractSSKey(ParcelTable);
    SwisCode := Take(6, SwisSBLKey);

    TempStr := ConvertSwisSBLToDashDot(SwisSBLKey);

      {Insert records into the sort files where appropriate.}
      {FXX12031998-1: Only insert sort rec if it is in this swis.}

    If ((not Done) and
        (SelectedSwisCodes.IndexOf(SwisCode) > -1) and
        (ParcelTable.FieldByName('RollSection').Text <> '9'))
      then
        begin
          FillInSummaryRecord(ParcelTable, AssessmentTable,
                              ClassTable, ParcelExemptionTable,
                              EXCodeTable, SortSummaryTable,
                              ExemptionSummaryList,
                              GlblThisYear, 'T', False, RPS225ReportRun);

          If not PriorRecordsExist
            then FillInSummaryRecord(ParcelTable, AssessmentTable,
                                     ClassTable, ParcelExemptionTable,
                                     EXCodeTable, SortSummaryTable,
                                     ExemptionSummaryList,
                                     GlblThisYear, 'P', True, RPS225ReportRun);

(*          Writeln(ExtractFileTY, SwisSBLKey); *)

        end;  {If ((not Done) and ...}

  until (Done or Quit or ReportCancelled);

    {If there are actual prior records, then go through them.}

  If PriorRecordsExist
    then
      begin
        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   History, Quit);
        OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName,
                                   History, Quit);
        OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                   History, Quit);
        OpenTableForProcessingType(ClassTable, ClassTableName,
                                   History, Quit);

          {FXX05232000-1: Need to make sure multiple history years don't
                          cause a problem.}

        SetRangeOld(ParcelTable,
                    ['TaxRollYr', 'SwisCode', 'Section',
                     'Subsection', 'Block', 'Lot', 'Sublot',
                     'Suffix'],
                    [HistoryYear, '      ', '   ', '   ', '    ',
                     '   ', '   ', '    '],
                    [HistoryYear, '999999', 'ZZZ', 'ZZZ', 'ZZZZ',
                     'ZZZ', 'ZZZ', 'ZZZZ']);

        ParcelTable.First;

          {Go through the Current parcel table.}

        FirstTimeThrough := True;
        RecCount := 0;
        Quit := False;
        Done := False;

        ProgressDialog.UserLabelCaption := 'Filling Sort File - Prior';

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelTable.Next;

          RecCount := RecCount + 1;

          If (ParcelTable.EOF or
              (TrialRun and
               (RecCount > 1000)))
            then Done := True;

          Application.ProcessMessages;
          ReportCancelled := ProgressDialog.Cancelled;
          ProgressDialog.Update(Form, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

          SwisSBLKey := ExtractSSKey(ParcelTable);
          SwisCode := Take(6, SwisSBLKey);

          TempStr := ConvertSwisSBLToDashDot(SwisSBLKey);
(*          Writeln(ExtractFilePrior, SwisSBLKey); *)

            {Insert records into the sort files where appropriate.}
            {FXX12031998-1: Only insert sort rec if it is in this swis.}
            {FXX01102000-1: Actually, use prior hold fields even if history exists.}

          If ((not Done) and
              (SelectedSwisCodes.IndexOf(SwisCode) > -1) and
              (ParcelTable.FieldByName('RollSection').Text <> '9'))
            then FillInSummaryRecord(ParcelTable, AssessmentTable,
                                     ClassTable, ParcelExemptionTable,
                                     EXCodeTable, SortSummaryTable,
                                     ExemptionSummaryList,
                                     HistoryYear, 'P', False, RPS225ReportRun);

        until (Done or Quit or ReportCancelled);

      end;  {If PriorRecordsExist}

    {If this is Westchester county, need NY info also.}

  If GlblIsWestchesterCounty
    then
      begin
        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(EXCodeTable, ExemptionCodesTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(ClassTable, ClassTableName,
                                   NextYear, Quit);

        ParcelTable.First;

          {Go through the Next year parcel table.}

        FirstTimeThrough := True;
        RecCount := 0;
        Quit := False;
        Done := False;

        ProgressDialog.UserLabelCaption := 'Filling Sort File  - NY.';

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelTable.Next;

          RecCount := RecCount + 1;

          If (ParcelTable.EOF or
              (TrialRun and
               (RecCount > 1000)))
            then Done := True;

          Application.ProcessMessages;
          ReportCancelled := ProgressDialog.Cancelled;
          ProgressDialog.Update(Form, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

          SwisSBLKey := ExtractSSKey(ParcelTable);
          SwisCode := Take(6, SwisSBLKey);

          TempStr := ConvertSwisSBLToDashDot(SwisSBLKey);

            {Insert records into the sort files where appropriate.}
            {FXX12031998-1: Only insert sort rec if it is in this swis.}

          If ((not Done) and
              (SelectedSwisCodes.IndexOf(SwisCode) > -1) and
              (ParcelTable.FieldByName('RollSection').Text <> '9'))
            then FillInSummaryRecord(ParcelTable, AssessmentTable,
                                     ClassTable, ParcelExemptionTable,
                                     EXCodeTable, SortSummaryTable,
                                     ExemptionSummaryList,
                                     GlblNextYear, 'N', False, RPS225ReportRun);

        until (Done or Quit or ReportCancelled);

      end;  {If GlblIsWestchesterCounty}

    {Now go through the summary table and fill in the other sort tables.}

  SortSummaryTable.First;

    {Go through the Sort Summary table.}

  FirstTimeThrough := True;
  Quit := False;

  ProgressDialog.UserLabelCaption := 'Processing sort summary table.';
  SortAssessedValChangesTable.IndexName := 'BYSWISCODE_SBLKEY';

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SortSummaryTable.Next;

    Done := SortSummaryTable.EOF;

    Application.ProcessMessages;
    SwisSBLKey := SortSummaryTable.FieldByName('SwisSBLKey').Text;
    ProgressDialog.Update(Form, ConvertSwisSBLToDashDot(SwisSBLKey));

    SwisCode := Take(6, SwisSBLKey);

    TempStr := ConvertSwisSBLToDashDot(SwisSBLKey);
    HstdSchoolExAmount := 0;
    NonhstdSchoolExAmount := 0;

      {Insert records into the sort files where appropriate.}
      {FXX12031998-1: Only insert sort rec if it is in this swis.}

    If not Done
      then
        begin
          HstdEqualizationIncrease := 0;
          HstdEqualizationDecrease := 0;
          HstdPhysicalQtyIncrease := 0;
          HstdPhysicalQtyDecrease := 0;
          NonhstdEqualizationIncrease := 0;
          NonhstdEqualizationDecrease := 0;
          NonhstdPhysicalQtyIncrease := 0;
          NonhstdPhysicalQtyDecrease := 0;

            {FXX10181999-1: Use the value as of final roll for current value for Westchester.}

          with SortSummaryTable do
            begin
              If GlblIsWestchesterCounty
                then
                  begin
                    CurrentHomesteadValue := FieldByName('NYHstdValue').AsFloat;
                    CurrentNonhomesteadValue := FieldByName('NYNonhstdValue').AsFloat;
                    HstdExAmount := FieldByName('NYHstdEXAmount').AsFloat;
                    NonhstdExAmount := FieldByName('NYNonhstdEXAmount').AsFloat;

                      {FXX07122007-1(2.11.2.3)[D903]: Part 3 (Transmittal letter) should
                                                      show the school taxable values.}

                    try
                      HstdSchoolExAmount := FieldByName('NYSchoolHstdEX').AsFloat;
                      NonHstdSchoolExAmount := FieldByName('NYSchoolNonhstdEX').AsFloat;
                    except
                    end;

                    CurrentRollSectionSbs := FieldByName('NYRollSectionSbs').Text;
                    CurrentPropertyClass := FieldByName('NYPropertyClass').Text;
                    CurrentOwnershipCode := FieldByName('NYOwnershipCode').Text;
                    CurrentActiveFlag := FieldByName('NYActiveFlag').Text;
                    CurrentSchoolCode := FieldByName('NYSchoolCode').Text;

                    CurrentParcelExists := ((CurrentActiveFlag = 'A') or
                                            (CurrentActiveFlag = 'R'));

                    PriorRollSectionSbs := FieldByName('TYRollSectionSbs').Text;
                    PriorPropertyClass := FieldByName('TYPropertyClass').Text;
                    PriorOwnershipCode := FieldByName('TYOwnershipCode').Text;
                    PriorActiveFlag := FieldByName('TYActiveFlag').Text;
                    PriorSchoolCode := FieldByName('TYSchoolCode').Text;
                    PriorHomesteadValue := FieldByName('TYHstdValue').AsFloat;
                    PriorNonhomesteadValue := FieldByName('TYNonhstdValue').AsFloat;
                    PriorParcelExists := FieldByName('TYParcelExists').AsBoolean;

(*                    WritelnCommaDelimitedLine(ExtractFile,
                                              [SwisSBLKey, PriorRollSectionSbs,
                                               PriorPropertyClass, PriorActiveFlag,
                                               PriorSchoolCode, PriorParcelExists,
                                               PriorHomesteadValue,
                                               PriorNonhomesteadValue]); *)

                  end
                else
                  begin
                    CurrentHomesteadValue := FieldByName('TYHstdValue').AsFloat;
                    CurrentNonhomesteadValue := FieldByName('TYNonhstdValue').AsFloat;
                    HstdExAmount := FieldByName('TYHstdEXAmount').AsFloat;
                    NonhstdExAmount := FieldByName('TYNonhstdEXAmount').AsFloat;

                      {FXX07122007-1(2.11.2.3)[D903]: Part 3 (Transmittal letter) should
                                                      show the school taxable values.}

                    try
                      HstdSchoolExAmount := FieldByName('TYSchoolHstdEX').AsFloat;
                      NonHstdSchoolExAmount := FieldByName('TYSchoolNonhstdEX').AsFloat;
                    except
                    end;

                    CurrentRollSectionSbs := FieldByName('TYRollSectionSbs').Text;
                    CurrentPropertyClass := FieldByName('TYPropertyClass').Text;
                    CurrentOwnershipCode := FieldByName('TYOwnershipCode').Text;
                    CurrentActiveFlag := FieldByName('TYActiveFlag').Text;
                    CurrentSchoolCode := FieldByName('TYSchoolCode').Text;
                    CurrentParcelExists := FieldByName('TYParcelExists').AsBoolean;

                    PriorRollSectionSbs := FieldByName('PriorRollSectionSbs').Text;
                    PriorPropertyClass := FieldByName('PriorPropertyClass').Text;
                    PriorOwnershipCode := FieldByName('PriorOwnershipCode').Text;
                    PriorActiveFlag := FieldByName('PriorActiveFlag').Text;
                    PriorSchoolCode := FieldByName('PriorSchoolCode').Text;
                    PriorHomesteadValue := FieldByName('PriorHstdValue').AsFloat;
                    PriorNonhomesteadValue := FieldByName('PriorNonhstdValue').AsFloat;
                    PriorParcelExists := FieldByName('PriorParcelExists').AsBoolean;

                  end;  {else of If GlblIsWestchesterCounty}

            end;  {with SortSummaryTable do}

            {Update the av change table.}

          UpdateAVChangeSortTable(SortAssessedValChangesTable,
                                  SortSummaryTable,
                                  SortComputedChangesTable,
                                  SortAVChangesTable,
                                  AttributeInactivationsOrNewParcelsToPhysicalChange,
                                  AttributeImbalancesToEqualization,
                                  HstdEqualizationIncrease,
                                  HstdEqualizationDecrease,
                                  HstdPhysicalQtyIncrease,
                                  HstdPhysicalQtyDecrease,
                                  NonhstdEqualizationIncrease,
                                  NonhstdEqualizationDecrease,
                                  NonhstdPhysicalQtyIncrease,
                                  NonhstdPhysicalQtyDecrease, Quit);

            {Update the swis totals.}

          UpdateTotalAssessedVal(TotalAssessedValList,
                                 Take(1, PriorRollSectionSbs)[1],
                                 Take(1, CurrentRollSectionSbs)[1],
                                 PriorActiveFlag,
                                 CurrentActiveFlag,
                                 PriorSchoolCode,
                                 CurrentSchoolCode,
                                 PriorHomesteadValue,
                                 PriorNonhomesteadValue,
                                 CurrentHomesteadValue,
                                 CurrentNonhomesteadValue,
                                 HstdEqualizationIncrease,
                                 HstdEqualizationDecrease,
                                 HstdPhysicalQtyIncrease,
                                 HstdPhysicalQtyDecrease,
                                 NonhstdEqualizationIncrease,
                                 NonhstdEqualizationDecrease,
                                 NonhstdPhysicalQtyIncrease,
                                 NonhstdPhysicalQtyDecrease,
                                 HstdExAmount,
                                 NonhstdExAmount,
                                 'S', SwisCode,
                                 Copy(SwisSBLKey, 7, 4),
                                 PriorParcelExists, Quit);

            {Update the school totals.}

          UpdateTotalAssessedVal(TotalAssessedValList,
                                 Take(1, PriorRollSectionSbs)[1],
                                 Take(1, CurrentRollSectionSbs)[1],
                                 PriorActiveFlag,
                                 CurrentActiveFlag,
                                 PriorSchoolCode,
                                 CurrentSchoolCode,
                                 PriorHomesteadValue,
                                 PriorNonhomesteadValue,
                                 CurrentHomesteadValue,
                                 CurrentNonhomesteadValue,
                                 HstdEqualizationIncrease,
                                 HstdEqualizationDecrease,
                                 HstdPhysicalQtyIncrease,
                                 HstdPhysicalQtyDecrease,
                                 NonhstdEqualizationIncrease,
                                 NonhstdEqualizationDecrease,
                                 NonhstdPhysicalQtyIncrease,
                                 NonhstdPhysicalQtyDecrease,
                                 HstdSchoolExAmount,
                                 NonhstdSchoolExAmount,
                                 'C', SwisCode,
                                 Copy(SwisSBLKey, 7, 4),
                                 PriorParcelExists, Quit);

            {Update the av by property class totals.}

          UpdateAVByPropClassAndRS(TotalByPropClass_RollSectionList,
                                   (PriorHomesteadValue +
                                    PriorNonhomesteadValue),
                                   (CurrentHomesteadValue +
                                    CurrentNonhomesteadValue),
                                   PriorPropertyClass,
                                   CurrentPropertyClass,
                                   Take(1, PriorRollSectionSbs)[1],
                                   Take(1, CurrentRollSectionSbs)[1],
                                   PriorOwnershipCode,
                                   CurrentOwnershipCode,
                                   PriorActiveFlag,
                                   CurrentActiveFlag,
                                   PriorParcelExists,
                                   CurrentParcelExists,
                                   Quit);

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or Quit or ReportCancelled);

  SaveTotals(SortTotalAssessedValTable, SortAVByPropClass_RS_Table,
             SortExemptionTable,
             TotalAssessedValList, TotalByPropClass_RollSectionList,
             ExemptionSummaryList, Quit);

  FreeTList(TotalAssessedValList, SizeOf(TotalValueRecord));
  FreeTList(TotalByPropClass_RollSectionList, SizeOf(AV_PC_RSRecord));
  FreeTList(ExemptionSummaryList, SizeOf(ExemptionSummaryRecord));
  SelectedSwisCodes.Free;
(*  CloseFile(ExtractFileTY);
  CloseFile(ExtractFilePrior); *)

(*  CloseFile(ExtractFile); *)

  SortAssessedValChangesTable.IndexName := 'BYSWIS_SMNUM_SBLKEY';

end;  {FillSortFiles}


end.