unit Utrolscn;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,pastypes,
  GlblCnst,Types, RPFiler, RPBase, RPCanvas, RPrinter, (*Progress, *)RPDefine;

type
  TRollScanUtilityForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    SysrecTable: TTable;
    TSOCodeEdit: TEdit;
    Label1: TLabel;
    TSODiskOpenDialog: TOpenDialog;
    SysrecTableSysNextYear: TStringField;
    SysrecTableSysThisYear: TStringField;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    ImportButton: TButton;
    ParcelTable: TTable;
    InstructionLabel: TLabel;
    ParcelTableTaxRollYr: TStringField;
    ParcelTableSwisCode: TStringField;
    ParcelTableSection: TStringField;
    ParcelTableSubsection: TStringField;
    ParcelTableBlock: TStringField;
    ParcelTableLot: TStringField;
    ParcelTableSublot: TStringField;
    ParcelTableSuffix: TStringField;
    ParcelTableActiveFlag: TStringField;
    ParcelTableRelatedSBL: TStringField;
    ParcelTableSBLRelationship: TStringField;
    ParcelTableRemapOldSBL: TStringField;
    ParcelTableCheckDigit: TStringField;
    ParcelTableSchoolCode: TStringField;
    ParcelTableName1: TStringField;
    ParcelTableName2: TStringField;
    ParcelTableAddress1: TStringField;
    ParcelTableAddress2: TStringField;
    ParcelTableStreet: TStringField;
    ParcelTableCity: TStringField;
    ParcelTableState: TStringField;
    ParcelTableZip: TStringField;
    ParcelTableZipPlus4: TStringField;
    ParcelTablePropDescr1: TStringField;
    ParcelTablePropDescr2: TStringField;
    ParcelTablePropDescr3: TStringField;
    ParcelTablePropertyClassDesc: TStringField;
    ParcelTablePropertyClassCode: TStringField;
    ParcelTableHomesteadDesc: TStringField;
    ParcelTableHomesteadCode: TStringField;
    ParcelTableOwnershipCode: TStringField;
    ParcelTableOwnershipDesc: TStringField;
    ParcelTableLegalAddrNo: TStringField;
    ParcelTableLegalAddr: TStringField;
    ParcelTableLastChangeDate: TDateField;
    ParcelTableLastChangeByName: TStringField;
    ParcelTableRollSection: TStringField;
    ParcelTableRollSubsection: TStringField;
    ParcelTableBankCode: TStringField;
    ParcelTableDeedBook: TStringField;
    ParcelTableDeedPage: TStringField;
    ParcelTableFrontage: TFloatField;
    ParcelTableDepth: TFloatField;
    ParcelTableAcreage: TFloatField;
    ParcelTableGridCordNorth: TIntegerField;
    ParcelTableGridCordEast: TIntegerField;
    ParcelTableAuditControl: TStringField;
    ParcelTableAccountNo: TStringField;
    ParcelTableLotGroup: TStringField;
    ParcelTableAdditionalLots: TStringField;
    ParcelTableResidentialPercent: TFloatField;
    ParcelTableParcelCreatedDate: TDateField;
    ParcelTableSplitMergeNo: TStringField;
    ParcelTableConsolidatedSchlDist: TStringField;
    ParcelTableDescriptionPrintCode: TStringField;
    ParcelTableEasementCode: TStringField;
    ParcelTableEasementDesc: TStringField;
    ParcelTableLandCommitmentCode: TStringField;
    ParcelTableLandCommitmentDesc: TStringField;
    ParcelTableCommitmentTermYear: TStringField;
    ParcelTableAllocationFactor: TFloatField;
    ParcelTableHoldPriorHomestead: TStringField;
    ParcelTableAssociatedSaleNumber: TSmallintField;
    ParcelTableIrregularShape: TBooleanField;
    ParcelTableSchoolRelevy: TCurrencyField;
    ParcelTableTownRelevy: TCurrencyField;
    ParcelTableMortgageNumber: TStringField;
    ParcelTableRS9LinkedSBL: TStringField;
    ParcelTableReserved: TStringField;
    AssessmentTable: TTable;
    ParcelSDTable: TTable;
    SDCodeTable: TTable;
    ParcelExemptionTable: TTable;
    ExemptionCodeTable: TTable;
    ParcelSDLookupTable: TTable;
    tracelabel: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportFilerPrintHeader(Sender: TObject);
    procedure ImportButtonClick(Sender: TObject);
    procedure ReportPrinterPrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;  {Open the tables and setup.}
    Procedure ResetIt (Var TheFile : TextFile);

  end;

{$R *.DFM}

var
  RollScanUtilityForm: TRollScanUtilityForm;

  ScanOutFile : TextFile;

  TaxRollYear : Str4;
  LocalDebug  : Boolean;

    TSORec : AnyStr;
   TSOBankCode             : Str7;
   TSO_SwisSBL             : Str26;
   PrintingExcessParcels : Boolean;
   TSOFileSize : LongInt;
implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Prog, Preview;

{========================================================}
Procedure TRollScanUtilityForm.InitializeForm;

begin
  UnitName := 'IMPBKCOD.PAS';  {mmm}

  If (FormAccessRights = raReadOnly)
    then ParcelTable.ReadOnly := True;  {mmm}
OpenTAblesForForm(Self,GlblProcessingType);

Try
   SysrecTAble.first
   Except
      SystemSupport(001, SysrecTable, 'Get First Error on Sysrec Table.',
                  UnitName, GlblErrorDlgBox);
end;
TaxRollYear := GetTaxRlYr;

LocalDebug := False;
PrintingExcessParcels := False;
end;  {InitializeForm}

{===================================================================}
Procedure TRollScanUtilityForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{===================================================================}
Procedure TRollScanUtilityForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin

 CloseTablesForForm(Self);
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

procedure TRollScanUtilityForm.CloseButtonClick(Sender: TObject);
begin
Close;
end;


procedure TRollScanUtilityForm.ReportFilerPrintHeader(Sender: TObject);
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
      SetFont('Arial',20);
      Underline := True;
      Home;
      CRLF;
      PrintCenter('Roll Scan Report', (PageWidth / 2));
      SetFont('Times New Roman', 12);
      CRLF;
      CRLF;

      Underline := False;
      ClearTabs;
      SetTab(0.5, pjLeft, 1.7, 0, BOXLINENONE, 0);   {Bank Code}

        {Print the selection information.}

      Bold := True;
      PrintLn(' ');
      CRLF;

      Bold := False;


      SectionTop := 2.0;

        {Print column headers.}

      CRLF;
      CRLF;
      Home;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('Times New Roman', 10);
      Bold := True;
      ClearTabs;

         CRLF;
         CRLF;

         SetTab(0.5, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {swis}
         SetTab(1.2, pjCenter, 2.6, 0, BOXLINEBOTTOM, 0);   {SBL}
         SetTab(3.9, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {SD1}
         SetTab(5.5, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {SD2}
         SetTab(7.1, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {SD3}
         Println('');

      Println('');
    ClearTAbs;

      Cleartabs;
    SetTab(0.5, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {swis}
    SetTab(1.2, pjCenter, 2.6, 0, BOXLINEBOTTOM, 0);   {SBL}
    SetTab(4.0, pjCenter, 0.3, 0, BOXLINEBOTTOM, 0);   {cd}
    SetTab(4.5, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {amt}

    end;  {with Sender as TBaseReport do}


end;

Procedure TRollScanUtilityForm.ResetIt (Var TheFile : TextFile);

Begin
Reset(TheFile);

End;

procedure TRollScanUtilityForm.ReportPrinterPrint(Sender: TObject);

Const
     SearchSD = 'CW004';

var
  DoneWithReport,
  DoneWithPage, LineFeedFound : Boolean;
  Progress, I, J, TempInt, Lines : Integer;
  {mikemike DBMemoBuf: TDBMemoBuf; }
  TempStr : String;
   UserSaidDoUpdate,
   Found,
   Doneparcels : Boolean;

   REcordCount             : Longint;
   SBLREc : SBLREcord;
   TempSize,
   NotFoundCount,
   TotalRecsCount : LongInt;
   REturnCode : Integer;
   Result : boolean;
   RS8Count :integer;
      SDAmounts : TList;
    TotSDValue : Real;
    TempSd : Str5;
    TempSwisSBL : Str26;
    TempSwis : Str6;

begin


 AssignFile(ScanOutFile,'USDTSCAN.SCN');  {file for errors}
 Rewrite(ScanOutFile);
TotSDValue := 0;
UserSaidDoUpdate := False;
NotFoundCount := 0;
TotalRecsCount := 1;
InstructionLabel.Visible := False;
InstructionLabel.Repaint;

  DoneParcels := False;
  RecordCount := 0;
  DoneWithReport := False;
(****
  Try
      ParcelSDTable.First;
         Except
         begin
         SystemSupport(012, ParcelTable,'Error reading 1st record in Parcel TAble', UnitName, GlblErrorDlgBox);
         (*Abort;
         end;
      end; {end try}
  ****)
  Found := False;
  Try
  (*** i=dx 0
   Found := ParcelSDTable.FindKey(['1997','55348900910 0012A         ','WJ011']);
      ***)
   Found := ParcelSDTable.FindKey([SearchSd]);
         Except
         begin
         SystemSupport(012, ParcelSDTable,'Error reading 1st record in Parcel SD TAble', UnitName, GlblErrorDlgBox);
         (*Abort;*)
         end;
      end; {end try}
  If Not Found
    then
    begin
         SystemSupport(998, ParcelSDTable,'Error finding  parcel sd key', UnitName, GlblErrorDlgBox);
         (*Abort;*)
    end;

  with Sender as TBaseReport do
    begin
      Bold := False;
        {Set up the tabs for the info.}

         {flat file == total bytes/reclen}

        REcordcount := 0;
        (**
        ProgressDialog.Start(ParcelSDTable.REcordCount );
         ***)

        DoneParcels := False;          {2222}
              {first mark all existing codes as 'X_' + 3char tso code}
           (**
        ProgressDialog.UserLabelCaption :='Scanning Roll Sections';
            ***)
        RS8Count := 0;
        Writeln(ScanoutFile,'SD CODE = ' + SEARCHSD);
        Repeat
         (**
        ProgressDialog.UpDate( sELF,ParcelSDTable.FieldByName('SwisSBLKey').AsString);
         **)
        (**
                  +' / ' + ParcelSDTable.FieldByName('Section').AsString + '-'
                      + ParcelSDTable.FieldByName('SubSection').AsString + '-'
                      + ParcelSDTable.FieldByName('Block').AsString + '-'
                      + ParcelSDTable.FieldByName('Lot').AsString + '-'
                      + ParcelSDTable.FieldByName('Sublot').AsString + '-'
                      + ParcelSDTable.FieldByName('Suffix').AsString);
           **)
         Application.ProcessMessages;

        TempSd :=   Take(5,ParcelSDTable.FieldByName('SDistCode').AsString);
        SBLRec := ExtractSwisSBLFromSwisSBLKey( ParcelSDTable.FieldByName('SwisSBLKey').AsString);
        If Take(5,ParcelSDTable.FieldByName('SDistCode').AsString) = SearchSD
           then
           begin

           SDAmounts := TList.Create;
           SBLRec := ExtractSwisSBLFromSwisSBLKey( ParcelSDTable.FieldByName('SwisSBLKey').AsString);

           With SBLRec do
               Found := ParcelTable.FindKey([TaxRollYear,Swiscode,Section,SubSection,
                                             Block,Lot,Sublot,Suffix]);

           If Found
              then
              begin
              Found := AssessmentTable.FindKey([TaxRollYear, ParcelSDTable.FieldByName('SwisSBLKey').AsString]);
              If NOT Found
                 then Writeln(ScanoutFile,'asssment rec not found   ' +  ParcelSDTable.FieldByName('SwisSBLKey').AsString);

             (***
              Found := ParcelExemptionTable.FindKey([TaxRollYear, ParcelSDTable.FieldByName('SwisSBLKey').AsString]);
                   If NOT Found
                 then Println(#9 + 'Parcel Exemption rec not found   ' +  ParcelSDTable.FieldByName('SwisSBLKey').AsString);
                 ***)

              TotalSpecialDistrictsForParcel(TaxRollYear,
                                         ParcelSDTable.FieldByName('SwisSBLKey').AsString,
                                         ParcelTable,
                                         AssessmentTable,
                                         ParcelSDLookupTable,
                                         SDCodeTable,
                                         ParcelExemptionTable,
                                         ExemptionCodeTable,
                                         SDAmounts);


              end;

           RS8Count := RS8Count + 1;

           TempSwisSBl := Take(26,ParcelSDTable.FieldByName('SwisSBLKey').AsString);

           Write(ScanOutFile, Take(6,ParcelSDTable.FieldByName('SwisSBLKey').AsString) +

                 Take(6,' ')  + ConvertSwisSBLToDashDotNoSwis(ParcelSDTable.FieldByName('SwisSBLKey').AsString));




           For I := 0 to (SDAmounts.Count - 1) do
               begin
                with PParcelSDValuesRecord(SDAmounts[I])^ do
                     begin
                     If (PParcelSDValuesRecord(SDAmounts[I])^.SdCode = SearchSD)
                        then for J := 1 to 10 do

                            { sec units
                       If (SDExtensionCodes[J] = 'SU')
                             }
                          { ad valorum codes}
                        If (SDExtensionCodes[J] = 'TO')
                               OR
                          (SDExtensionCodes[J] = 'IM')
                               OR
                          (SDExtensionCodes[J] = 'LD')
                       then
                       begin
                       Write(ScanOutFile,'      ' + SDExtensionCodes[J] + ' - ' +
                             FormatFloat('###,###,###.##',StrToFloat(SDValues[J])));
                       TotSDValue := TotSdValue +  StrToFloat(SDValues[J]);
                       end;

                     end;
                 end;


            Writeln(Scanoutfile,' ');
     (***
            +
             #9 +ParcelSDTable.FieldByName('Section').AsString + '-'
                      + ParcelSDTable.FieldByName('SubSection').AsString + '-'
                      + ParcelSDTable.FieldByName('Block').AsString + '-'
                      + ParcelSDTable.FieldByName('Lot').AsString + '-'



                      + ParcelSDTable.FieldByName('Sublot').AsString + '-'
                      + ParcelSDTable.FieldByName('Suffix').AsString);
              ***)

           ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
           FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

           end
           else DoneParcels := True;  {done when search sd does not match}


        Try
        ParcelSDTable.Next;
        TotalREcsCount := totalRecsCount + 1;
         Except
         begin
         SystemSupport(004, ParcelSDTable,'Error reading 1st record in Parcel TAble', UnitName, GlblErrorDlgBox);
         (*Abort;*)
         end;
        end; {end try}
        recordcount := recordcount + 1;


        (***
        If (RecordCount > 100) And LocalDebug then DoneParcels:= True;
        ***)
        TempSwis :=  Take(6,ParcelSDTable.FieldByName('SwisSBLKey').AsString);
        If (ParcelSDTable.EOF)
                 OR
           (SearchSD <> Take(5,ParcelSDTable.FieldByName('SDistCode').AsString) )
                 OR
            (TempSwis <> '553401')
         then DoneParcels := True;
          (***
         If LinesLeft < 10
           then
           begin
           Newpage;
           end;
             ****)

        Until DoneParcels;

        (***
        CRLF;
        CRLF;
        ***)

        Writeln(ScanOutFile,' tot sd value =  ' + FormatFloat('###,###,###.##',TotSDValue));



        {We are done printing the report if we have gone through all the codes.}

      Result := not DoneWithReport; {False = stop}

    end;  {with Sender as TBaseReport do}
CloseFile(ScanOutFile);
end;

procedure TRollScanUtilityForm.ImportButtonClick(Sender: TObject);

Const
     SearchSD = 'SD005';

var
  DoneWithReport,
  DoneWithPage, LineFeedFound : Boolean;
  Progress, I, J, TempInt, Lines : Integer;
  {mikemike DBMemoBuf: TDBMemoBuf; }
  TempStr : String;
   UserSaidDoUpdate,
   Found,
   Doneparcels : Boolean;

   REcordCount             : Longint;
   SBLREc : SBLREcord;
   TempSize,
   NotFoundCount,
   TotalRecsCount : LongInt;
   REturnCode : Integer;
   Result : boolean;
   RS8Count :integer;
      SDAmounts : TList;
    TotSDValue : Real;
    TempSd : Str5;
    TempSwisSBL : Str26;
    TempSwis : Str6;

begin


 AssignFile(ScanOutFile,'USDTSCAN.SCN');  {file for errors}
 Rewrite(ScanOutFile);
TotSDValue := 0;
UserSaidDoUpdate := False;
NotFoundCount := 0;
TotalRecsCount := 1;
InstructionLabel.Visible := False;
InstructionLabel.Repaint;

  DoneParcels := False;
  RecordCount := 0;
  DoneWithReport := False;

  Found := False;
  Try
   Found := ParcelSDTable.FindKey([SearchSd]);
         Except
         begin
         SystemSupport(012, ParcelSDTable,'Error reading 1st record in Parcel SD TAble', UnitName, GlblErrorDlgBox);
         (*Abort;*)
         end;
      end; {end try}
  If Not Found
    then
    begin
         SystemSupport(998, ParcelSDTable,'Error finding  parcel sd key', UnitName, GlblErrorDlgBox);
         (*Abort;*)
    end;


        REcordcount := 0;

        DoneParcels := False;          {2222}
        RS8Count := 0;
        Writeln(ScanoutFile,'SD CODE = ' + SEARCHSD);
        Repeat
        Application.ProcessMessages;

        TempSd :=   Take(5,ParcelSDTable.FieldByName('SDistCode').AsString);
        SBLRec := ExtractSwisSBLFromSwisSBLKey( ParcelSDTable.FieldByName('SwisSBLKey').AsString);

        TempSwis :=  Take(6,ParcelSDTable.FieldByName('SwisSBLKey').AsString);
        If (Take(5,ParcelSDTable.FieldByName('SDistCode').AsString) = SearchSD)
                                        AND
            (TempSwis = '553403')

           then
           begin

           SDAmounts := TList.Create;
           SBLRec := ExtractSwisSBLFromSwisSBLKey( ParcelSDTable.FieldByName('SwisSBLKey').AsString);

           With SBLRec do
               Found := ParcelTable.FindKey([TaxRollYear,Swiscode,Section,SubSection,
                                             Block,Lot,Sublot,Suffix]);

           If Found
              then
              begin
              Found := AssessmentTable.FindKey([TaxRollYear, ParcelSDTable.FieldByName('SwisSBLKey').AsString]);
              If NOT Found
                 then Writeln(ScanoutFile,'asssment rec not found   ' +  ParcelSDTable.FieldByName('SwisSBLKey').AsString);

              TotalSpecialDistrictsForParcel(TaxRollYear,
                                         ParcelSDTable.FieldByName('SwisSBLKey').AsString,
                                         ParcelTable,
                                         AssessmentTable,
                                         ParcelSDLookupTable,
                                         SDCodeTable,
                                         ParcelExemptionTable,
                                         ExemptionCodeTable,
                                         SDAmounts);


              end;

           RS8Count := RS8Count + 1;

           TempSwisSBl := Take(26,ParcelSDTable.FieldByName('SwisSBLKey').AsString);

           Write(ScanOutFile, Take(6,ParcelSDTable.FieldByName('SwisSBLKey').AsString) +

                 Take(6,' ')  + ConvertSwisSBLToDashDotNoSwis(ParcelSDTable.FieldByName('SwisSBLKey').AsString));

           For I := 0 to (SDAmounts.Count - 1) do
               begin
                with PParcelSDValuesRecord(SDAmounts[I])^ do
                     begin
                     If (PParcelSDValuesRecord(SDAmounts[I])^.SdCode = SearchSD)
                        then for J := 1 to 10 do

                            { sec units
                       If (SDExtensionCodes[J] = 'SU')
                             }
                          { ad valorum codes}
                        If (SDExtensionCodes[J] = 'TO')
                               OR
                          (SDExtensionCodes[J] = 'IM')
                               OR
                          (SDExtensionCodes[J] = 'LD')
                       then
                       begin
                       Write(ScanOutFile,'      ' + SDExtensionCodes[J] + ' - ' +
                             FormatFloat('###,###,###.##',StrToFloat(SDValues[J])));
                       TotSDValue := TotSdValue +  StrToFloat(SDValues[J]);
                       end;

                     end;
                 end;


            Writeln(Scanoutfile,' ');

           ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
           FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

           end
           else;  (* DoneParcels := True;  {done when search sd does not match} *)


        Try
        ParcelSDTable.Next;
        TotalREcsCount := totalRecsCount + 1;
         Except
         begin
         SystemSupport(004, ParcelSDTable,'Error reading 1st record in Parcel TAble', UnitName, GlblErrorDlgBox);
         (*Abort;*)
         end;
        end; {end try}
        recordcount := recordcount + 1;
        If NOT ParcelSDTAble.eof
           then
           begin
           tracelabel.caption :=
              IntTostr(RecordCount) + '     ' + Take(26,ParcelSDTable.FieldByName('SwisSBLKey').AsString);
           TraceLabel.Repaint;
           end;

        (***
        If (RecordCount > 100) And LocalDebug then DoneParcels:= True;
        ***)
        TempSwis :=  Take(6,ParcelSDTable.FieldByName('SwisSBLKey').AsString);
        If (ParcelSDTable.EOF)
                 OR
           (SearchSD <> Take(5,ParcelSDTable.FieldByName('SDistCode').AsString) )
                 OR
            (TempSwis > '553403')
         then DoneParcels := True;
        Until DoneParcels;

        Writeln(ScanOutFile,' tot sd value =  ' + FormatFloat('###,###,###.##',TotSDValue));



        {We are done printing the report if we have gone through all the codes.}


CloseFile(ScanOutFile);

end;

end.
