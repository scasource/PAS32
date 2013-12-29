unit MunicityPermitReportPrintUnit;

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
     StdCtrls, ExtCtrls, Forms, RPFiler, RPBase, RPCanvas, RPrinter,
     RPMemo, RPDBUtil, RPDefine, ADODB, Dialogs, DB, DBTables, Prog;

Procedure PrintMunicityPermitReportHeader(Sender : TObject;
                                          sStartDate : String;
                                          sEndDate : String;
                                          bPrintAllDates : Boolean;
                                          bPrintToEndOfDates : Boolean);

Procedure PrintMunicityPermitReport(var fExtract : TextFile;
                                        Sender : TObject;
                                        Form : TForm;
                                        ProgressDialog : TProgressDialog;
                                        qry_MunicityPermit : TADOQuery;
                                        qry_MunicityInspections : TADOQuery;
                                        qry_MunicityCertificates : TADOQuery;
                                        tb_Sales : TTable;
                                        tb_Assessment : TTable;
                                        tb_Parcel : TTable;
                                        tb_SwisCodes : TTable;
                                        slPermitStatus : TStringList;
                                        slPermitTypes : TStringList;
                                        iAssessorOfficeStatus : Integer;
                                        bPrintAllDates : Boolean;
                                        bPrintToEndOfDates : Boolean;
                                        sStartDate : String;
                                        sEndDate : String;
                                        bPrintAllCODates : Boolean;
                                        bPrintToEndOfCODates : Boolean;
                                        sCOStartDate : String;
                                        sCOEndDate : String;
                                        iPrintOrder : Integer;
                                        sSBL : String;
                                        bPrintToExcel : Boolean;
                                        bCreateParcelList : Boolean;
                                        bValidSalesOnly : Boolean;
                                        bShowProgress : Boolean);

const
  aosOpen = 0;
  aosClosed = 1;
  aosEither = 2;

implementation

uses GlblCnst, GlblVars, Utilitys, PASUtils, WinUtils,
     DataAccessUnit, PrclList;

{======================================================================}
Procedure PrintMunicityPermitReportHeader(Sender : TObject;
                                          sStartDate : String;
                                          sEndDate : String;
                                          bPrintAllDates : Boolean;
                                          bPrintToEndOfDates : Boolean);

var
  sHeader : String;

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      SectionTop := 0.4;
      Home;
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjRight);

      SectionTop := 0.5;
      SetFont('Times New Roman',12);
      Home;
      CRLF;
      Bold := True;
      PrintCenter('Building Permit Report', (PageWidth / 2));
      Bold := False;
      SetFont('Times New Roman', 12);
      CRLF;

      SectionTop := 1.0;

        {Print column headers.}

      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('Times New Roman', 10);

      sHeader := 'Dates: ';

      If bPrintAllDates
        then sHeader := sHeader + 'All.'
        else
          begin
            sHeader := sHeader + sStartDate;

            If bPrintToEndOfDates
              then sHeader := sHeader + ' to end.'
              else sHeader := sHeader + ' to ' + sEndDate;

          end;  {else of If bPrintAllDates}
          
      PrintCenter(sHeader, (PageWidth / 2));

      CRLF;
      
      ClearTabs;
      SetTab(0.3, pjCenter, 0.9, 5, BOXLINENOBOTTOM, 25);   {Parcel ID}
      SetTab(1.2, pjCenter, 1.3, 5, BOXLINENOBOTTOM, 25);   {name}
      SetTab(2.5, pjCenter, 1.3, 5, BOXLINENOBOTTOM, 25);   {Legal addr}
      SetTab(3.8, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);   {Permit no}
      SetTab(4.5, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);   {Permit date}
      SetTab(5.2, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);   {Permit status}
      SetTab(5.9, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);   {permit Type}
      SetTab(6.5, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);   {Construction Cost}
      SetTab(7.1, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);   {Last Insp Date}
      SetTab(7.8, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);  {CO Date}
      SetTab(8.5, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);   {Current AV}
      SetTab(9.2, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);   {Full Market val}
      SetTab(9.9, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);  {Last sale date}
      SetTab(10.6, pjCenter, 0.7, 5, BOXLINENOBOTTOM, 25);  {Last sale price}
      SetTab(11.3, pjCenter, 2.5, 5, BOXLINENOBOTTOM, 25);  {Description}

      Println(#9 + #9 + #9 +
              #9 + 'Permit' +
              #9 + 'Permit' +
              #9 + 'Permit' +
              #9 + 'Permit' +
              #9 + 'Construct' +
              #9 + 'Last Insp' +
              #9 + 'C/O' +
              #9 + 'Current' +
              #9 + 'Full Mkt' +
              #9 + 'Last Sale' +
              #9 + 'Last Sale' +
              #9 + '');

      ClearTabs;
      SetTab(0.3, pjCenter, 0.9, 5, BoxLineNoTop, 25);   {Parcel ID}
      SetTab(1.2, pjCenter, 1.3, 5, BoxLineNoTop, 25);   {name}
      SetTab(2.5, pjCenter, 1.3, 5, BoxLineNoTop, 25);   {Legal addr}
      SetTab(3.8, pjCenter, 0.7, 5, BoxLineNoTop, 25);   {Permit no}
      SetTab(4.5, pjCenter, 0.7, 5, BoxLineNoTop, 25);   {Permit date}
      SetTab(5.2, pjCenter, 0.7, 5, BoxLineNoTop, 25);   {Permit status}
      SetTab(5.9, pjCenter, 0.6, 5, BoxLineNoTop, 25);   {permit Type}
      SetTab(6.5, pjCenter, 0.6, 5, BoxLineNoTop, 25);   {Construction Cost}
      SetTab(7.1, pjCenter, 0.7, 5, BoxLineNoTop, 25);   {Last Insp Date}
      SetTab(7.8, pjCenter, 0.7, 5, BoxLineNoTop, 25);   {CO Date}
      SetTab(8.5, pjCenter, 0.7, 5, BoxLineNoTop, 25);   {Current AV}
      SetTab(9.2, pjCenter, 0.7, 5, BoxLineNoTop, 25);   {Full Market val}
      SetTab(9.9, pjCenter, 0.7, 5, BoxLineNoTop, 25);   {Last sale date}
      SetTab(10.6, pjCenter, 0.7, 5, BoxLineNoTop, 25);  {Last sale price}
      SetTab(11.3, pjCenter, 2.5, 5, BoxLineNoTop, 25);  {Description}

      Println(#9 + 'Parcel ID' +
              #9 + 'Name' +
              #9 + 'Legal Addr' +
              #9 + 'Number' +
              #9 + 'Date' +
              #9 + 'Status' +
              #9 + 'Type' +
              #9 + 'Cost' +
              #9 + 'Date' +
              #9 + 'Date' +
              #9 + 'Value' +
              #9 + 'Value' +
              #9 + 'Date' +
              #9 + 'Price' +
              #9 + 'Description');

      ClearTabs;
      Bold := False;
      SetTab(0.3, pjLeft, 0.9, 5, BoxLineAll, 0);   {Parcel ID}
      SetTab(1.2, pjLeft, 1.3, 5, BoxLineAll, 0);   {name}
      SetTab(2.5, pjLeft, 1.3, 5, BoxLineAll, 0);   {Legal addr}
      SetTab(3.8, pjLeft, 0.7, 5, BoxLineAll, 0);   {Permit no}
      SetTab(4.5, pjCenter, 0.7, 5, BoxLineAll, 0);   {Permit date}
      SetTab(5.2, pjLeft, 0.7, 5, BoxLineAll, 0);   {Permit status}
      SetTab(5.9, pjLeft, 0.6, 5, BoxLineAll, 0);   {permit Type}
      SetTab(6.5, pjRight, 0.6, 5, BoxLineAll, 0);   {Construction Cost}
      SetTab(7.1, pjLeft, 0.7, 5, BoxLineAll, 0);   {Last Insp Date}
      SetTab(7.8, pjLeft, 0.7, 5, BoxLineAll, 0);   {CO Date}
      SetTab(8.5, pjRight, 0.7, 5, BoxLineAll, 0);   {Current AV}
      SetTab(9.2, pjRight, 0.7, 5, BoxLineAll, 0);   {Full Market val}
      SetTab(9.9, pjLeft, 0.7, 5, BoxLineAll, 0);   {Last sale date}
      SetTab(10.6, pjRight, 0.7, 5, BoxLineAll, 0);  {Last sale price}
      SetTab(11.3, pjLeft, 2.5, 5, BoxLineAll, 0);  {Description}

    end;  {with Sender as TBaseReport do}

end;  {PrintMunicityPermitReportHeader}


{======================================================================}
Procedure GetPermitReportData(qry_MunicityPermit : TADOQuery;
                              qry_MunicityInspections : TADOQuery;
                              qry_MunicityCertificates : TADOQuery;
                              slPermitStatus : TStringList;
                              slPermitTypes : TStringList;
                              iAssessorOfficeStatus : Integer;
                              bPrintAllDates : Boolean;
                              bPrintToEndOfDates : Boolean;
                              sStartDate : String;
                              sEndDate : String;
                              bPrintAllCODates : Boolean;
                              bPrintToEndOfCODates : Boolean;
                              sCOStartDate : String;
                              sCOEndDate : String;
                              iPrintOrder : Integer;
                              sSBL : String);
{H+}

var
  sWhereClause : WideString;
  sTempVar, sOrderByClause : String;
  bAtLeastOne : Boolean;
  iX : Integer;

begin
  with qry_MunicityPermit do
    try
      Close;
      ConnectionString := 'FILE NAME=' + GlblDrive + ':' + GlblProgramDir + 'pasMunicity.udl';
    except
      MessageDlg('Error Connecting to Municity database.'  +  Chr(10) + Chr(13) +
                 ' UDL file: ' + GlblDrive + ':' + GlblProgramDir +
                 'pasMunicity.udl.' +  Chr(10) + Chr(13) + Chr(10) + Chr(13) +
                 '  Please verify connection.',
                 mtError, [mbOK], 0);
    end; {try}

  with qry_MunicityInspections do
    try
      Close;
      ConnectionString := qry_MunicityPermit.ConnectionString;
    except
    end;

  with qry_MunicityCertificates do
    try
      Close;
      ConnectionString := qry_MunicityPermit.ConnectionString;
    except
    end;

  sWhereClause := '';
  bAtLeastOne := False;

  If (_Compare(slPermitStatus.IndexOf('ALL'), -1, coEqual) and
      _Compare(slPermitStatus.Count, 0, coGreaterThan))
    then
      begin
        sWhereClause := sWhereClause + '(';
        For iX := 0 to (slPermitStatus.Count - 1) do
          begin
            If bAtLeastOne
              then sWhereClause := sWhereClause + ' OR';

            sWhereClause := sWhereClause + ' Permits.PermStatus = ' + '''' + slPermitStatus[iX] + ''' ';
            bAtLeastOne := True;

          end; {For iX := 0 to (slPermitStatus.Count -1 ) do}

        sWhereClause := sWhereClause + ')';

      end;  {If _Compare(slPermitStatus.IndexOf('ALL'), -1, coEqual)}

  If (_Compare(slPermitTypes.IndexOf('ALL'), -1, coEqual) and
      _Compare(slPermitTypes.Count, 0, coGreaterThan))
    then
      begin
        bAtLeastOne := False;
        If _Compare(sWhereClause, coNotBlank)
          then sWhereClause := sWhereClause + ' AND ';

        sWhereClause := sWhereClause + '(';

        For iX := 0 to (slPermitTypes.Count - 1) do
          begin
            If bAtLeastOne
              then sWhereClause := sWhereClause + ' OR';

            sWhereClause := sWhereClause + ' Permits.PermitType = ' + '''' + slPermitTypes[iX] + ''' ';
            bAtLeastOne := True;

          end; {For iX := 0 to (slPermitStatus.Count -1 ) do}

        sWhereClause := sWhereClause + ')';

      end;  {If _Compare(slPermitTypes.IndexOf('ALL'), -1, coEqual)}

  //do Assessor Office Status
  If _Compare(iAssessorOfficeStatus, aosEither, coNotEqual)
    then
      begin
        If _Compare(iAssessorOfficeStatus, aosOpen, coNotEqual)
          then sTempVar := 'False'
          else sTempVar := 'True';

        If _Compare(sWhereClause, coBlank)
          then sWhereClause := 'Permits.AssessorOfficeClosed = ' + '''' + sTempVar + ''' '
          else sWhereClause := sWhereClause + ' AND Permits.AssessorOfficeClosed = ' + '''' + sTempVar + ''' ';

      end;  {If _Compare(iAssessorOfficeStatus, aosEither, coNotEqual)}

  If not bPrintAllDates
    then
      If bPrintToEndOfDates
        then
          begin
            If _Compare(sWhereClause, coBlank)
              then sWhereClause := ' Permits.PermitDate >= ' + '''' + sStartDate + ''' '
              else sWhereClause := sWhereClause + ' AND Permits.PermitDate >= ' + '''' + sStartDate + ''' ';
          end //If not bPrintToEndOfDates
        else
          begin
            If _Compare(sWhereClause, coBlank)
              then sWhereClause := ' Permits.PermitDate >= ' + '''' + sStartDate + ''' ' + ' AND Permits.PermitDate <= ' + '''' + sEndDate + ''' '
              else sWhereClause := sWhereClause + ' AND (Permits.PermitDate >= ' + '''' + sStartDate + ''' ' + ' AND Permits.PermitDate <= ' + '''' + sEndDate + ''') ';

          end;  {else of If bPrintToEndOfDates}

(*  If not bPrintAllCODates
    then
      If bPrintToEndOfCODates
        then
          begin
            If _Compare(sWhereClause, coBlank)
              then sWhereClause := ' Permits.CertOccupancyDate >= ' + '''' + sCOStartDate + ''' '
              else sWhereClause := sWhereClause + ' AND Permits.CertOccupancyDate >= ' + '''' + sCOStartDate + ''' ';
          end //If not bPrintToEndOfDates
        else
          begin
            If _Compare(sWhereClause, coBlank)
              then sWhereClause := ' Permits.CertOccupancyDate >= ' + '''' + sCOStartDate + ''' ' + ' AND Permits.CertOccupancyDate <= ' + '''' + sCOEndDate + ''' '
              else sWhereClause := sWhereClause + ' AND (Permits.CertOccupancyDate >= ' + '''' + sCOStartDate + ''' ' + ' AND Permits.CertOccupancyDate <= ' + '''' + sCOEndDate + ''') ';

          end;  {else of If bPrintToEndOfDates} *)

  If _Compare(sSBL, coNotBlank)
    then
      begin
        If _Compare(sWhereClause, coNotBlank)
          then sWhereClause := sWhereClause + ' AND';

        sWhereClause := sWhereClause + ' (Parcels.SBL = ' + FormatSQLString(sSBL) + ')';

      end;  {If _Compare(sSBL, coNotBlank)}

  If _Compare(sWhereClause, coNotBlank)
  then sWhereClause := sWhereClause + ' AND';

  sWhereClause := sWhereClause + ' ((Permits.Deleted is null) or (Permits.Deleted = 0))';

  case iPrintOrder of
    0 : sOrderByClause := 'SBL';  {Parcels}
    1 : sOrderByClause := 'Permits.PermitDate DESC';
    2 : sOrderByClause := 'Permits.PermitNo';
    3 : sOrderByClause := 'Permits.ParcelOwner';
    4 : sOrderByClause := 'Parcels.LegalAddr, Parcels.LegalAddrInt';
  end;

  with qry_MunicityPermit do
    try
      If Active
        then Close;

      with SQL do
        begin
          Clear;
          Add('SELECT Parcels.SwisSBLKey,');
          Add(' Parcels.Parcel_ID,');
          Add(' Parcels.PrintKey,');
          Add(' Parcels.LegalAddrInt,');
          Add(' Parcels.LegalAddr,');
          Add(' Parcels.SBL AS SBL,');
          Add(' Parcels.SwisCode,');
          Add(' ParcelPermitMap.Parcel_ID AS MapParcelID,');
          Add(' ParcelPermitMap.Permit_ID,');
          Add(' Permits.Permit_ID AS PermitsPermits_ID,');
          Add(' Permits.PermitNo,');
          Add(' Permits.PermitDate,');
          Add(' Permits.PermStatus,');
          Add(' Permits.PermitType,');
          Add(' Permits.ConstCost,');
          Add(' Permits.AssessorOfficeClosed,');
          Add(' Permits.AssessorNextInspDate,');
          Add(' Permits.ParcelOwner AS Owner,');
          Add(' Permits.AssessorComments,');
          Add(' Permits.Description,');
          Add(' Permits.LegalAddrNo,');
          Add(' Permits.CertOccupancyNumber,');
          Add(' Permits.CertOccupancyDate,');
          Add(' Permits.LegalAddr');
          Add('FROM Parcels');
          Add(' INNER JOIN ParcelPermitMap ON (Parcels.Parcel_ID = ParcelPermitMap.Parcel_ID)');
          Add(' INNER JOIN Permits ON (ParcelPermitMap.Permit_ID = Permits.Permit_ID)');
(*          Add('FROM Parcels INNER JOIN ');
          Add(' ParcelPermitMap ON Parcels.Parcel_ID =');
          Add(' ParcelPermitMap.Parcel_ID INNER JOIN ');
          Add(' Permits ON ParcelPermitMap.Permit_ID = Permits.Permit_ID');  *)
          If Length(sWhereClause) > 0 then
            Add('WHERE ' + sWhereClause);
          If _Compare(sOrderByClause, coNotBlank)
            then Add('ORDER BY ' + sOrderByClause);

        end;  {with SQL do}

      Open;

    except
    end;

  {$H-}

end;  {GetPermitData}

{======================================================================}
Procedure PrintMunicityPermitReport(var fExtract : TextFile;
                                        Sender : TObject;
                                        Form : TForm;
                                        ProgressDialog : TProgressDialog;
                                        qry_MunicityPermit : TADOQuery;
                                        qry_MunicityInspections : TADOQuery;
                                        qry_MunicityCertificates : TADOQuery;
                                        tb_Sales : TTable;
                                        tb_Assessment : TTable;
                                        tb_Parcel : TTable;
                                        tb_SwisCodes : TTable;
                                        slPermitStatus : TStringList;
                                        slPermitTypes : TStringList;
                                        iAssessorOfficeStatus : Integer;
                                        bPrintAllDates : Boolean;
                                        bPrintToEndOfDates : Boolean;
                                        sStartDate : String;
                                        sEndDate : String;
                                        bPrintAllCODates : Boolean;
                                        bPrintToEndOfCODates : Boolean;
                                        sCOStartDate : String;
                                        sCOEndDate : String;
                                        iPrintOrder : Integer;
                                        sSBL : String;
                                        bPrintToExcel : Boolean;
                                        bCreateParcelList : Boolean;
                                        bValidSalesOnly : Boolean;
                                        bShowProgress : Boolean);

var
  bReportCancelled, bFirstTimeThrough,
  bDone, bValidSaleFound, bInRange : Boolean;
  sAssessorStat, sLastInspectionDate,
  sCertificateDate, sLastSaleDate, sSwisSBLKey, sTempSwisSBL : String;
  iConstructionCost, iLastSalePrice, iFullMarketValue : LongInt;
  dCODate : TDateTime;

begin
  bFirstTimeThrough := True;
  bDone := False;

  GetPermitReportData(qry_MunicityPermit, qry_MunicityInspections,
                      qry_MunicityCertificates,
                      slPermitStatus, slPermitTypes, iAssessorOfficeStatus,
                      bPrintAllDates, bPrintToEndOfDates,
                      sStartDate, sEndDate,
                      bPrintAllCODates, bPrintToEndOfCODates,
                      sCOStartDate, sCOEndDate,
                      iPrintOrder, sSBL);

  with Sender as TBaseReport do
    begin
      If bShowProgress
        then ProgressDialog.Start(qry_MunicityPermit.RecordCount, True, True);

      qry_MunicityPermit.First;

      repeat
        If bFirstTimeThrough
          then bFirstTimeThrough := False
          else qry_MunicityPermit.Next;

        If qry_MunicityPermit.EOF
          then bDone := True;

          {FXX06092009-2(2.20.1.1)[D1534]: Don't use the SBL.  It sometimes is not loaded correctly.  Use the SwisSBLKey.}

        with qry_MunicityPermit do
          begin
            sSwisSBLKey := FieldByName('SwisSBLKey').AsString;

            If _Compare(sSwisSBLKey, coBlank)
              then sSwisSBLKey := FieldByName('SwisCode').AsString + FieldByName('SBL').AsString;

          end;  {with qry_MunicityPermit do}

        If bShowProgress
          then ProgressDialog.Update(Form, ConvertSBLOnlyToDashDot(Copy(sSwisSBLKey, 7, 20)));
        Application.ProcessMessages;
        If (_Compare(sSwisSBLKey, coNotBlank) and
            bCreateParcelList)
          then ParcelListDialog.AddOneParcel(sSwisSBLKey);

        If not bDone
          then
            with qry_MunicityPermit, Sender as TBaseReport do
              begin
(*                LinesToPrint := 1;
                LeftMargin := 2;
                RightMargin := 10;

                If (PrintWorkDescription and
                    (not TMemoField(qry_MunicityPermit.FieldByName('Description')).IsNull))
                  then LinesToPrint := LinesToPrint +
                                       GetMemoLineCountForMemoField(Sender,
                                                                    TMemoField(qry_MunicityPermit.FieldByName('Description')),
                                                                    LeftMargin, RightMargin);

                If (PrintAssessorsNotes and
                    (not TMemoField(qry_MunicityPermit.FieldByName('AssessorComments')).IsNull))
                  then LinesToPrint := LinesToPrint +
                                       GetMemoLineCountForMemoField(Sender,
                                                                    TMemoField(qry_MunicityPermit.FieldByName('AssessorComments')),
                                                                    LeftMargin, RightMargin); *)

                If _Compare(LinesLeft, 5, coLessThan)
                  then NewPage;

                If FieldByName('AssessorOfficeClosed').AsBoolean
                  then sAssessorStat := 'CLOSED'
                  else sAssessorStat := 'OPEN';

                If _Compare(FieldByName('ConstCost').AsString, coBlank)
                  then iConstructionCost := 0
                  else
                    try
                      iConstructionCost := Trunc(FieldByName('ConstCost').AsFloat);
                    except
                      iConstructionCost := 0;
                    end;

                sSwisSBLKey := FieldByName('SwisSBLKey').AsString;

                  {FXX05162010(2.24.2.4)[I7347]: For Glen Cove, translate SBL to Glen Cove format.}

                If GlblUseGlenCoveFormatForCodeEnforcement
                  then sTempSwisSBL := Copy(sSwisSBLKey, 1, 6) +
                                       ConvertFrom_GlenCoveTax_Building_To_PAS_SBL(Copy(sSwisSBLKey, 7, 20))
                  else sTempSwisSBL := sSwisSBLKey;

                _SetRange(tb_Sales, [sTempSwisSBL, 0], [sTempSwisSBL, 999], '', []);

                  {CHG06102009-1(2.20.1.1)[F971]: Option to only pick up valid sales.}

                with tb_Sales do
                  begin
                    Last;

                    If bValidSalesOnly
                      then
                        begin
                          bValidSaleFound := False;

                          while (not (bValidSaleFound or BOF)) do
                            begin
                              If (FieldByName('ArmsLength').AsBoolean and
                                  FieldByName('ValidSale').AsBoolean)
                                then bValidSaleFound := True;

                              If not bValidSaleFound
                                then Prior;

                            end;  {while (not (bValidSaleFound or EOF)) do}

                        end
                      else bValidSaleFound := True;

                  end;  {with tb_Sales do}

                iLastSalePrice := 0;
                sLastSaleDate := '';

                with tb_Sales do
                  If (bValidSaleFound and
                      _Compare(RecordCount, 0, coGreaterThan))
                    then
                      begin
                        iLastSalePrice := FieldByName('SalePrice').AsInteger;
                        sLastSaleDate := FieldByName('SaleDate').AsString;
                      end;

                _ADOQuery(qry_MunicityInspections,
                          ['Select Inspections.SchedDate, Inspections.CloseDate',
                           'from Permits',
                           'Inner Join PermitInspectionMap on (Permits.Permit_ID = PermitInspectionMap.Permit_ID)',
                           'Inner Join Inspections on (Inspections.Inspection_ID = PermitInspectionMap.Inspection_ID)',
                           'where ((Permits.Permit_ID = ' + FieldByName('Permit_ID').AsString + ') and',
                           '       (Inspections.CloseDate > ' + FormatSQLString('1/1/1902') + '))',
                           'order by Inspections.SchedDate DESC']);

                sLastInspectionDate := '';

                If _Compare(qry_MunicityInspections.RecordCount, 0, coGreaterThan)
                  then sLastInspectionDate := qry_MunicityInspections.FieldByName('SchedDate').AsString;

                _Locate(tb_Assessment, [GetTaxRlYr, sTempSwisSBL], '', []);
                _Locate(tb_Parcel, [GetTaxRlYr, sTempSwisSBL], '', [loParseSwisSBLKey]);
                _Locate(tb_SwisCodes, [Copy(sTempSwisSBL, 1, 6)], '', []);

                iFullMarketValue := Trunc(ComputeFullValue(tb_Assessment.FieldByName('TotalAssessedVal').AsInteger,
                                                           tb_SwisCodes,
                                                           tb_Parcel.FieldByName('PropertyClassCode').Text,
                                                           tb_Parcel.FieldByName('OwnershipCode').Text,
                                                           GlblUseRAR));

                sCertificateDate := GetMunicityCODateForPermit(qry_MunicityCertificates,
                                                               FieldByName('Permit_ID').AsString,
                                                               FieldByName('Parcel_ID').AsString);

                If _Compare(sCertificateDate, coBlank)
                  then sCertificateDate := FieldByName('CertOccupancyDate').AsString;

                bInRange := False;

                If (_Compare(sCertificateDate, coBlank) or
                    bPrintAllCODates)
                then bInRange := True
                else
                try
                  dCODate := StrToDate(sCertificateDate);
                  bInRange := InDateRange(dCODate, bPrintAllCODates, bPrintToEndOfCODates,
                                          StrToDate(sCOStartDate), StrToDate(sCOEndDate));
                except
                end;

                If bInRange
                then
                begin
                  Println(#9 + ConvertSBLOnlyToDashDot(Copy(sTempSwisSBL, 7, 20)) +
                          #9 + Take(14, FieldByName('Owner').AsString) +
                          #9 + Take(15, GetLegalAddressFromADOQuery(qry_MunicityPermit)) +
                          #9 + FieldByName('PermitNo').AsString +
                          #9 + FieldByName('PermitDate').AsString +
                          #9 + Copy(FieldByName('PermStatus').AsString, 1, 6) +
                          #9 + Copy(FieldByName('PermitType').AsString, 1, 6) +
                          #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                           iConstructionCost) +
                          #9 + qry_MunicityInspections.FieldByName('SchedDate').AsString +
                          #9 + sCertificateDate +
                          #9 + FormatFloat(IntegerDisplay,
                                           tb_Assessment.FieldByName('TotalAssessedVal').AsInteger) +
                          #9 + FormatFloat(IntegerDisplay,
                                           iFullMarketValue) +
                          #9 + sLastSaleDate +
                          #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                           iLastSalePrice) +
                          #9 + Copy(FieldByName('Description').AsString, 1, 25));

                  If bPrintToExcel
                    then
                      begin
                        Write(fExtract, ConvertSwisSBLToDashDot(sTempSwisSBL),
                                        FormatExtractField(tb_Parcel.FieldByName('SwisCode').AsString),
                                        FormatExtractField(tb_Parcel.FieldByName('Section').AsString),
                                        FormatExtractField(tb_Parcel.FieldByName('Subsection').AsString),
                                        FormatExtractField(tb_Parcel.FieldByName('Block').AsString),
                                        FormatExtractField(tb_Parcel.FieldByName('Lot').AsString),
                                        FormatExtractField(tb_Parcel.FieldByName('Sublot').AsString),
                                        FormatExtractField(tb_Parcel.FieldByName('Suffix').AsString),
                                        FormatExtractField(FieldByName('Owner').Text),
                                        FormatExtractField(GetLegalAddressFromADOQuery(qry_MunicityPermit)),
                                        FormatExtractField(FieldByName('LegalAddrNo').AsString),
                                        FormatExtractField(FieldByName('LegalAddr').AsString),
                                        FormatExtractField(FieldByName('PermitNo').Text),
                                        FormatExtractField(FieldByName('PermitDate').Text),
                                        FormatExtractField(FieldByName('PermStatus').Text),
                                        FormatExtractField(FieldByName('PermitType').Text),
                                        FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                       iConstructionCost)),
                                        FormatExtractField(qry_MunicityInspections.FieldByName('SchedDate').AsString),
                                        FormatExtractField(sCertificateDate),
                                        FormatExtractField(FormatFloat(IntegerDisplay,
                                                                       tb_Assessment.FieldByName('TotalAssessedVal').AsInteger)),
                                        FormatExtractField(FormatFloat(IntegerDisplay,
                                                                       iFullMarketValue)),
                                        FormatExtractField(sLastSaleDate),
                                        FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                       iLastSalePrice)),
                                        FormatExtractField(FieldByName('Description').AsString));

  (*                      If PrintWorkDescription
                          then Write(fExtractFile, FormatExtractField(FieldByName('Description').Text));

                        If PrintAssessorsNotes
                          then Write(fExtractFile, FormatExtractField(FieldByName('AssessorComments').Text)); *)

                        Writeln(fExtract);

                      end;  {If bPrintToExcel}

                end;  {If bInRange}

              end;  {with Sender as TBaseReport do}

        bReportCancelled := ProgressDialog.Cancelled;

      until (bDone or bReportCancelled);

      If bShowProgress
        then ProgressDialog.Finish;

    end;  {with Sender as TBaseReport do}

end;  {PrintMunicityPermitReport}

end.
