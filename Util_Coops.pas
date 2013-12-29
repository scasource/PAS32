unit Util_Coops;

interface

Uses Types, Glblvars, SysUtils, WinTypes, WinProcs,
     Messages, Dialogs, Forms, wwTable, Classes, DB, DBTables,
     Controls,DBCtrls,StdCtrls, PASTypes, WinUtils, GlblCnst, Utilitys,
     wwDBLook, Graphics, PASUTILS, RPBase, RPDefine, DataAccessUnit;

Procedure PrintApportionmentOneBuilding(    Sender : TObject;
                                            lstCoopAVChanges : TList;
                                            sAssessmentYear : String;
                                            bExtractToExcel : Boolean;
                                        var flExtractFile : TextFile);

Procedure ApportionCoopBuilding(iCoopID : Integer;
                                bTrialRun : Boolean;
                                bLogAVChanges : Boolean;
                                iProcessingType : Integer;
                                sAssessmentYear : String;
                                lstCoopAVChanges : TList;
                                bClearChangeList : Boolean;
                                iCalcTotalAssessment : LongInt;
                                fCalcTotalShares : Double;
                                bUseCalculationValues : Boolean);

implementation

{============================================================================}
Procedure PrintApportionmentOneBuildingHeader(Sender : TObject;
                                              sCoopName : String;
                                              sAssessmentYear : String);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Arial',16);
      Home;
      CRLF;
      Bold := True;
      PrintCenter('Coop Apportionment', (PageWidth / 2));
      SetFont('Times New Roman', 10);
      CRLF;
      CRLF;

      ClearTabs;
      SetTab(0.4, pjLeft, 2.0, 0, BOXLINENone, 0);
      Println(#9 + 'Assessment Year: ' + sAssessmentYear);
      Println(#9 + 'Coop: ' + sCoopName);

      SectionTop := 1.0;

      ClearTabs;
      SetTab(0.4, pjCenter, 2.3, 5, BOXLINENOBOTTOM, 25);   {SBL}
      SetTab(2.7, pjCenter, 0.8, 5, BOXLINENOBOTTOM, 25);   {Shares}
      SetTab(3.5, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);   {Share %}
      SetTab(4.1, pjCenter, 1.0, 5, BOXLINENOBOTTOM, 25);   {Current Value}
      SetTab(5.1, pjCenter, 1.0, 5, BOXLINENOBOTTOM, 25);   {New Value}
      SetTab(6.1, pjCenter, 1.0, 5, BOXLINENOBOTTOM, 25);   {Difference}

      Println(#9 + 'Coop SBL' +
              #9 + 'Shares' +
              #9 + 'Share %' +
              #9 + 'Current Value' +
              #9 + 'New Value' +
              #9 + 'Difference');

      ClearTabs;
      SetTab(0.4, pjLeft, 2.3, 5, BoxLineAll, 0);   {SBL}
      SetTab(2.7, pjRight, 0.8, 5, BoxLineAll, 0);   {Shares}
      SetTab(3.5, pjRight, 0.6, 5, BoxLineAll, 0);   {Share %}
      SetTab(4.1, pjRight, 1.0, 5, BoxLineAll, 0);   {Current Value}
      SetTab(5.1, pjRight, 1.0, 5, BoxLineAll, 0);   {New Value}
      SetTab(6.1, pjRight, 1.0, 5, BoxLineAll, 0);   {Difference}

    end;  {with Sender as TBaseReport do}

end;  {PrintApportionmentOneBuildingHeader}

{============================================================================}
Procedure PrintApportionmentOneBuilding(    Sender : TObject;
                                            lstCoopAVChanges : TList;
                                            sAssessmentYear : String;
                                            bExtractToExcel : Boolean;
                                        var flExtractFile : TextFile);


var
  I : Integer;
  fTotalShares, fTotalSharePercent : Double;
  iTotalCurrentAssessedValue, iTotalNewAssessedValue : LongInt;
  sCoopName : String;

begin
  fTotalShares := 0;
  fTotalSharePercent := 0;
  iTotalCurrentAssessedValue := 0;
  iTotalNewAssessedValue := 0;
  sCoopName := '';

  try
    sCoopName := ptrCoopAVChange(lstCoopAVChanges[0])^.CoopName;
  except
  end;

  PrintApportionmentOneBuildingHeader(Sender, sCoopName, sAssessmentYear);

  For I := 0 to (lstCoopAVChanges.Count - 1) do
    with Sender as TBaseReport, ptrCoopAVChange(lstCoopAVChanges[I])^ do
      begin
        If _Compare(LinesLeft, 5, coLessThan)
          then
            with Sender as TBaseReport do
              begin
                NewPage;
                PrintApportionmentOneBuildingHeader(Sender, sCoopName, sAssessmentYear);
              end;

          Println(#9 + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)) +
                  #9 + FormatFloat(DecimalDisplay, Shares) +
                  #9 + FormatFloat(DecimalDisplay, SharePercent) +
                  #9 + FormatFloat(IntegerDisplay, CurrentAssessedValue) +
                  #9 + FormatFloat(IntegerDisplay, NewAssessedValue) +
                  #9 + FormatFloat(IntegerDisplay, (NewAssessedValue - CurrentAssessedValue)));

          If bExtractToExcel
            then WritelnCommaDelimitedLine(flExtractFile,
                                           [ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)),
                                            Shares,
                                            SharePercent,
                                            CurrentAssessedValue,
                                            NewAssessedValue,
                                            (NewAssessedValue - CurrentAssessedValue)]);

          fTotalShares := fTotalShares + Shares;
          fTotalSharePercent := fTotalSharePercent + SharePercent;
          iTotalCurrentAssessedValue := iTotalCurrentAssessedValue + CurrentAssessedValue;
          iTotalNewAssessedValue := iTotalNewAssessedValue + NewAssessedValue;

      end;  {with Sender as TBaseReport ...}

  with Sender as TBaseReport do
    begin
      Bold := True;
      Println(#9 + #9 + #9 + #9 + #9 + #9);

      Println(#9 + Copy(sCoopName, 1, 15) + ' Totals:' +
              #9 + FormatFloat(DecimalDisplay, fTotalShares) +
              #9 + FormatFloat(DecimalDisplay, fTotalSharePercent) +
              #9 + FormatFloat(IntegerDisplay, iTotalCurrentAssessedValue) +
              #9 + FormatFloat(IntegerDisplay, iTotalNewAssessedValue) +
              #9 + FormatFloat(IntegerDisplay, (iTotalNewAssessedValue - iTotalCurrentAssessedValue)));

      Bold := False;

    end;  {with Sender as TBaseReport do}

  If bExtractToExcel
    then
      begin
        WritelnCommaDelimitedLine(flExtractFile,
                                  [sCoopName + ' Total',
                                   fTotalShares,
                                   fTotalSharePercent,
                                   iTotalCurrentAssessedValue,
                                   iTotalNewAssessedValue,
                                   (iTotalNewAssessedValue - iTotalCurrentAssessedValue)]);

        WritelnCommaDelimitedLine(flExtractFile, []);

      end;  {If bExtractToExcel}

end;  {PrintApportionmentOneBuilding}

{============================================================================}
Procedure ApportionCoopBuilding(iCoopID : Integer;
                                bTrialRun : Boolean;
                                bLogAVChanges : Boolean;
                                iProcessingType : Integer;
                                sAssessmentYear : String;
                                lstCoopAVChanges : TList;
                                bClearChangeList : Boolean;
                                iCalcTotalAssessment : LongInt;
                                fCalcTotalShares : Double;
                                bUseCalculationValues : Boolean);

var
  sBaseSwisSBL : String;
  fShares, fTotalShares, fSharePercent,
  fAVPerShare : Double;
  iTotalAssessment, iNewAssessedValue : LongInt;
  tbAssessments, tbCoopBuildings,
  tbParcels, tbAuditAVChanges : TTable;
  pCoopAVChange : ptrCoopAVChange;
  ExemptionAmounts : ExemptionTotalsArrayType;

begin
  tbAssessments := TTable.Create(nil);
  tbCoopBuildings := TTable.Create(nil);
  tbParcels := TTable.Create(nil);
  tbAuditAVChanges := TTable.Create(nil);

  _OpenTable(tbAssessments, AssessmentTableName, '',
             'BYTAXROLLYR_SWISSBLKEY', iProcessingType, []);
  _OpenTable(tbCoopBuildings, CoopBuildingsTableName, '',
             'BYCOOPID', iProcessingType, []);
  _OpenTable(tbParcels, ParcelTableName, '',
             'BYTAXROLLYR_SWISSBLKEY', iProcessingType, []);
  _OpenTable(tbAuditAVChanges, AuditAVChangesTableName, '',
             '', iProcessingType, []);

  ClearTList(lstCoopAVChanges, SizeOf(rCoopAVChange));

  _Locate(tbCoopBuildings, [iCoopID], '', []);

  with tbCoopBuildings do
  begin
    If bUseCalculationValues
    then
    begin
      iTotalAssessment := iCalcTotalAssessment;
      fTotalShares := fCalcTotalShares;
    end
    else
    begin
      iTotalAssessment := FieldByName('AssessedValue').AsInteger;
      fTotalShares := FieldByName('TotalShares').AsFloat;
    end;

    sBaseSwisSBL := FieldByName('CoopSwisSBL').AsString;

  end;  {with tbCoopBuildings do}

    {FXX07092010-1(2.26.1.5)[I7769]: Some coop units are missing from the range.  Can't use 9999 as the top range.}

  _SetRange(tbAssessments, [sAssessmentYear, sBaseSwisSBL],
            [sAssessmentYear, sBaseSwisSBL + 'zzzz'], '', []);

  with tbAssessments do
    begin
      First;

      while (not EOF) do
        begin
          _Locate(tbParcels, [sAssessmentYear, FieldByName('SwisSBLKey').AsString], '', [loParseSwisSBLKey ]);

          fShares := tbParcels.FieldByName('CoopShares').AsFloat;

          try
            fSharePercent := (fShares / fTotalShares) * 100;
          except
            fSharePercent := 0;
          end;

          iNewAssessedValue := Round(iTotalAssessment * (fSharePercent / 100));  

          (*fAVPerShare := (iTotalAssessment / fTotalShares);

          iNewAssessedValue := Round(fShares * fAVPerShare); *)

          New(pCoopAVChange);

          with pCoopAVChange^ do
            begin
              SwisSBLKey := FieldByName('SwisSBLKey').AsString;
              CoopID := iCoopID;
              CoopName := tbCoopBuildings.FieldByName('CoopName').AsString;
              Shares := fShares;
              SharePercent := fSharePercent;
              CurrentAssessedValue := FieldByName('TotalAssessedVal').AsInteger;
              NewAssessedValue := iNewAssessedValue;
              
            end;  {with pCoopAVChange^ do}

          lstCoopAVChanges.Add(pCoopAVChange);

          If not bTrialRun
            then
              try
                Edit;
                FieldByName('TotalAssessedVal').AsInteger := iNewAssessedValue;
                Post;

                If bLogAVChanges
                  then InsertAuditAVChangeRec(tbAuditAVChanges,
                                              FieldByName('SwisSBLKey').AsString,
                                              sAssessmentYear,
                                              0, pCoopAVChange^.CurrentAssessedValue,
                                              0, 0, 0, 0,
                                              ExemptionAmounts,
                                              0, pCoopAVChange^.NewAssessedValue,
                                              0, 0, 0, 0,
                                              ExemptionAmounts);

              except
              end;

          Next;

        end;  {while (not EOF) do}

    end;  {with tbAssessment do}

  tbAssessments.Close;
  tbCoopBuildings.Close;
  tbParcels.Close;
  tbAuditAVChanges.Close;

  tbAssessments.Free;
  tbCoopBuildings.Free;
  tbParcels.Free;
  tbAuditAVChanges.Free;

end;  {ApportionCoopBuilding}

end.
