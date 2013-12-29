unit LoadArrearsFromTaxSystems_SQL;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler, ADODB;

type
  TTaxSystemsSetType = set of (tsDelinquent, tsSchool, tsTown, tsCounty);


  TLoadArrearsFlagsFromSQLTaxesForm = class(TForm)
    ParcelTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    Label1: TLabel;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    DelinquentTaxCheckBox: TCheckBox;
    CurrentSchoolTaxCheckBox: TCheckBox;
    CurrentTownTaxCheckBox: TCheckBox;
    CurrentCountyTaxCheckBox: TCheckBox;
    gb_Options: TGroupBox;
    ClearOldArrearsFlagsCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ReportHeaderPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName, AlternateDelinquentSystem : String;
    ClearArrearsFlags, ReportCancelled : Boolean;
    TaxSystemsToCheck : TTaxSystemsSetType;

    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, PASTypes, DataAccessUnit;

{$R *.DFM}


{========================================================}
Procedure TLoadArrearsFlagsFromSQLTaxesForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TLoadArrearsFlagsFromSQLTaxesForm.InitializeForm;

begin
  UnitName := 'LoadArrearsFromTaxSystem';  {mmm}

  OpenTablesForForm(Self, ThisYear);

end;  {InitializeForm}

{===================================================================}
Procedure TLoadArrearsFlagsFromSQLTaxesForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{================================================================}
Procedure TLoadArrearsFlagsFromSQLTaxesForm.StartButtonClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName : String;
  TempFile : File;

begin
  Quit := False;
  ReportCancelled := False;

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  StartButton.Enabled := False;
  Application.ProcessMessages;
  Quit := False;
  ClearArrearsFlags := ClearOldArrearsFlagsCheckBox.Checked;

  TaxSystemsToCheck := [];

  If CurrentSchoolTaxCheckBox.Checked
    then TaxSystemsToCheck := TaxSystemsToCheck + [tsSchool];

  If CurrentTownTaxCheckBox.Checked
    then TaxSystemsToCheck := TaxSystemsToCheck + [tsTown];

  If CurrentCountyTaxCheckBox.Checked
    then TaxSystemsToCheck := TaxSystemsToCheck + [tsCounty];

  If DelinquentTaxCheckBox.Checked
    then TaxSystemsToCheck := TaxSystemsToCheck + [tsDelinquent];

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler,
                              [ptLaser], False, Quit);

        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

          {Now print the report.}

        If not (Quit or ReportCancelled)
          then
            begin
              If PrintDialog.PrintToFile
                then
                  begin
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    ReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      ReportFiler.Execute;

                        {FXX10111999-3: Make sure they know its done.}

                      ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;

                        {Now delete the file.}
                      try
                        AssignFile(TempFile, NewFileName);
                        OldDeleteFile(NewFileName);
                      finally
                        {We don't care if it does not get deleted, so we won't put up an
                         error message.}

                        ChDir(GlblProgramDir);
                      end;

                    end;  {try PreviewForm := ...}

                  end  {If PrintDialog.PrintToFile}
                else ReportPrinter.Execute;

              ResetPrinter(ReportPrinter);

            end;  {If not Quit}

        ProgressDialog.Finish;

        DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

      end;  {If PrintDialog.Execute}

  StartButton.Enabled := True;

end;  {StartButtonClick}

{=========================================================}
Function ParcelHasOpenDelinquentTaxes(qryLien : TADOQuery;
                                      sSwisSBLKey : String) : Boolean;

begin
  Result := False;

  _ADOQuery(qryLien,
            ['select distinct p.SwisSBLKey as SwisSBL from parceltable p',
             'inner join stddlqhdrtable sdh on',
             '(sdh.SwisSBLKey = p.SwisSBLKey)',
             'where (sdh.FullyPaidFlg = 0) and (p.SwisSBLKey = ' + FormatSQLString(sSwisSBLKey) + ')']);

  try
    If _Compare(qryLien.RecordCount, 0, coGreaterThan)
    then Result := True;
  except
  end;

end;  {ParcelHasOpenDelinquentTaxes}

{=========================================================}
Function GetMostCurrentCollectionID(qryTax : TADOQuery;
                                    sCollectionType : String) : Integer;

begin
  Result := -1;

  _ADOQuery(qryTax,
            ['select top 1 Collection_ID from CollectionsAvailableTable',
             'where (CollectionType = ' + FormatSQLString(sCollectionType) + ')',
             'order by TaxYear desc']);

  try
    If _Compare(qryTax.RecordCount, 0, coGreaterThan)
    then Result := qryTax.FieldByName('Collection_ID').AsInteger;
  except
  end;

end;  {GetMostCurrentCollectionID}

{=========================================================}
Function ParcelHasOpenCurrentTaxes(qryTax : TADOQuery;
                                   sSwisSBLKey : String;
                                   sSchoolCode : String;
                                   iCollectionID : Integer) : Boolean;

var
  dNetDue : Double;
  sSwisCode, sSBL : String;

begin
  sSwisCode := Copy(sSwisSBLKey, 1, 6);
  sSBL := Copy(sSwisSBLKey, 7, 20);
  
  _ADOQuery(qryTax,
            ['select ROUND((SUM(d.Amount) - ISNULL(SUM(py.Amount), 0)), 2) as NetDue from ParcelYearMasterFile p',
             'inner join DueFile d on',
             '(d.SwisCode = p.SwisCode) and (d.SchoolCodeKey = p.SchoolKeyCode) and (d.SBL = p.SBL) and (d.Collection_ID = p.Collection_ID)',
             'left outer join PayFile py on',
             '(py.SwisCode = p.SwisCode) and (py.SchoolCodeKey = p.SchoolKeyCode) and (py.SBL = p.SBL) and (py.Collection_ID = p.Collection_ID)',
             'where (p.Collection_ID = ' + IntToStr(iCollectionID) + ') and (p.SwisCode = ' + FormatSQLString(sSwisCode) + ') and ',
             '(p.SchoolKeyCode = ' + FormatSQLString(sSchoolCode) + ') and (p.SBL = ' + FormatSQLString(sSBL) + ')']);

  dNetDue := qryTax.FieldByName('NetDue').AsFloat;

  Result := _Compare(dNetDue, 0, coGreaterThan);

end;  {ParcelHasOpenCurrentTaxes}

{=========================================================}
Procedure LoadDelinquentTaxList(qryLien : TADOQuery;
                                slSBLs : TStringList);

begin
  _ADOQueryExec(qryLien,
                ['drop Table [dbo].[#SBLs]']);

  _ADOQueryExec(qryLien,
                ['Create Table #SBLs (',
                 'SwisSBLKey varchar(50),',
                 'NetDue [float] )']);

  _ADOQueryExec(qryLien,
                ['insert into #SBLs (SwisSBLKey, NetDue)',
                 'select distinct p.SwisSBLKey as SwisSBL,',
                 '(ROUND(((select SUM(AmountDue) from stddlqduetable',
                 'where (stddlqduetable.SwisSBLKey = p.SwisSBLKey) and (VoidedItem = 0)) -',
                 '(select IsNull(SUM(AmountPaid), 0) from stddlqpaytable',
                 'where (stddlqpaytable.SwisSBLKey = p.SwisSBLKey))), 2))',
                 'from parceltable p']);

  _ADOQuery(qryLien,
            ['select * from #SBLs',
             'where (NetDue > 0)',
             'order by SwisSBLKey']);

  with qryLien do
  begin
    First;

    while not EOF do
    begin
      slSBLs.Add(Trim(FieldByName('SwisSBLKey').AsString));
      Next;
    end;

  end;

end;  {LoadDelinquentTaxList}

{=========================================================}
Procedure LoadOpenTaxList(qryTax : TADOQuery;
                          iCollectionID : Integer;
                          slSBLs : TStringList);

begin
  _ADOQueryExec(qryTax,
                ['drop Table [dbo].[#SBLs]']);

  _ADOQueryExec(qryTax,
                ['Create Table #SBLs (',
                 'SwisSBLKey varchar(50),',
                 '[TotalDue] [float],',
                 '[DueAmount] [float],',
                 '[PayAmount] [float])']);

  _ADOQueryExec(qryTax,
                ['insert into #SBLs (SwisSBLKey, DueAmount, PayAmount, TotalDue)',
                 'select p.SwisCode + p.SBL,',
                 '(select SUM(Amount) from duefile',
                 'where (dueFile.SwisCode = p.SwisCode) and (dueFile.SchoolCodeKey = p.SchoolKeyCode) and (dueFile.SBL = p.SBL) and (dueFile.Collection_ID = p.Collection_ID) and (Voided = 0)),',
                 '(select IsNull(SUM(Amount), 0) from Payfile',
                 'where (PayFile.SwisCode = p.SwisCode) and (PayFile.SchoolCodeKey = p.SchoolKeyCode) and (PayFile.SBL = p.SBL) and (PayFile.Collection_ID = p.Collection_ID)),',
                 '(ROUND(((select SUM(Amount) from duefile',
                 'where (dueFile.SwisCode = p.SwisCode) and (dueFile.SchoolCodeKey = p.SchoolKeyCode) and (dueFile.SBL = p.SBL) and (dueFile.Collection_ID = p.Collection_ID) and (Voided = 0)) -',
                 '(select IsNull(SUM(Amount), 0) from Payfile',
                 'where (PayFile.SwisCode = p.SwisCode) and (PayFile.SchoolCodeKey = p.SchoolKeyCode) and (PayFile.SBL = p.SBL) and (PayFile.Collection_ID = p.Collection_ID))), 2))',
                 'from parcelyearmasterfile p',
                 'where (p.Collection_ID =' + IntToStr(iCollectionID) + ')']);

  _ADOQuery(qryTax,
            ['select * from #SBLs',
             'where (TotalDue > 0)',
             'order by SwisSBLKey']);

  with qryTax do
  begin
    First;

    while not EOF do
    begin
      slSBLs.Add(Trim(FieldByName('SwisSBLKey').AsString));
      Next;
    end;

  end;

end;  {LoadOpenTaxList}

{=========================================================}
Procedure TLoadArrearsFlagsFromSQLTaxesForm.ReportHeaderPrint(Sender: TObject);

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
      SetFont('Arial',12);
      Bold := True;
      Home;
      PrintCenter('Arrears Flags Cleared \ Set', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.8, 0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(2.2, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Action}

      Println(#9 + 'Parcel ID' +
              #9 + 'Action');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.8, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(2.2, pjLeft, 1.0, 0, BOXLINENone, 0);   {Action}

    end;  {with Sender as TBaseReport do}

end;  {ReportHeaderPrint}

{====================================================================}
Procedure TLoadArrearsFlagsFromSQLTaxesForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit,
  ParcelHasLien, ParcelHasSchool,
  ParcelHasTown, ParcelHasCounty : Boolean;
  SwisSBLKey : String;
  TaxSystems, SchoolCode : String;
  NumCleared, NumAdded,
  iSchoolCollectionID, iMunicipalCollectionID, iCountyCollectionID : Integer;
  TempLen : Integer;
  TotalLien, TotalSchool, TotalTown, TotalCounty : LongInt;
  qryTax, qryLien : TADOQuery;
  adoConnection, adoConnection_Lien : TADOConnection;
  slSchoolSBLs, slMunicipalSBLs, slCountySBLs, slLienSBLs : TStringList;

begin
  Quit := False;
  NumCleared := 0;
  NumAdded := 0;
  Done := False;
  FirstTimeThrough := True;

  TotalLien := 0;
  TotalSchool := 0;
  TotalTown := 0;
  TotalCounty := 0;

  slSchoolSBLs := TStringList.Create;
  slMunicipalSBLs := TStringList.Create;
  slCountySBLs := TStringList.Create;
  slLienSBLs := TStringList.Create;

  try
    adoConnection := TADOConnection.Create(nil);
    adoConnection.ConnectionString := 'FILE NAME=' + GlblProgramDir + 'LocalTax.udl';
    adoConnection.LoginPrompt := False;
    adoConnection.Connected := True;
    qryTax := TADOQuery.Create(nil);
    qryTax.Connection := adoConnection;
  except
    MessageDlg('Error connecting to SQL tax database.  UDL should be ' + GlblProgramDir + 'LocalTax.udl',
               mtError, [mbOK], 0);
  end;

  If (tsDelinquent in TaxSystemsToCheck)
  then
  try
    adoConnection_Lien := TADOConnection.Create(nil);
    adoConnection_Lien.ConnectionString := 'FILE NAME=' + GlblProgramDir + 'Lien.udl';
    adoConnection_Lien.LoginPrompt := False;
    adoConnection_Lien.Connected := True;
    qryLien := TADOQuery.Create(nil);
    qryLien.Connection := adoConnection_Lien;
  except
    MessageDlg('Error connecting to SQL lien database.  UDL should be ' + GlblProgramDir + 'Lien.udl.',
               mtError, [mbOK], 0);
  end;


  iSchoolCollectionID := GetMostCurrentCollectionID(qryTax, 'SC');
  iMunicipalCollectionID := GetMostCurrentCollectionID(qryTax, 'TO');

  If _Compare(iMunicipalCollectionID, -1, coEqual)
  then iMunicipalCollectionID := GetMostCurrentCollectionID(qryTax, 'VI');

  iCountyCollectionID := GetMostCurrentCollectionID(qryTax, 'CO');

  If (tsSchool in TaxSystemsToCheck)
  then LoadOpenTaxList(qryTax, iSchoolCollectionID, slSchoolSBLs);

  If (tsTown in TaxSystemsToCheck)
  then LoadOpenTaxList(qryTax, iMunicipalCollectionID, slMunicipalSBLs);

  If (tsCounty in TaxSystemsToCheck)
  then LoadOpenTaxList(qryTax, iCountyCollectionID, slCountySBLs);

  If (tsDelinquent in TaxSystemsToCheck)
  then LoadDelinquentTaxList(qryLien, slLienSBLs);

  ParcelTable.First;

  with ParcelTable, Sender as TBaseReport do
    begin
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else Next;

        If EOF
          then Done := True;

        SwisSBLKey := ExtractSSKey(ParcelTable);
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
        ProgressDialog.UserLabelCaption := 'Number Arrears Flags Added = ' + IntToStr(NumAdded);
        Application.ProcessMessages;

        If ((not Done) and
            ClearArrearsFlags and
            FieldByName('Arrears').AsBoolean)
          then
            with ParcelTable do
              try
                Edit;
                FieldByName('Arrears').AsBoolean := False;
                Post;

                Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                        #9 + 'Cleared');
                NumCleared := NumCleared + 1;

              except
                SystemSupport(001, ParcelTable, 'Error clearing arrears flag for ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                              UnitName, GlblErrorDlgBox);
              end;

          {Now check for delinquent status.}

        SchoolCode := FieldByName('SchoolCode').Text;

        ParcelHasLien := False;
        ParcelHasSchool := False;
        ParcelHasTown := False;
        ParcelHasCounty := False;

(*        If ((tsDelinquent in TaxSystemsToCheck) and
            ParcelHasOpenDelinquentTaxes(qryLien, SwisSBLKey))
          then
            begin
              ParcelHasLien := True;
              TotalLien := TotalLien + 1;
            end;

        If ((tsSchool in TaxSystemsToCheck) and
            ParcelHasOpenCurrentTaxes(qryTax, SwisSBLKey, SchoolCode, iSchoolCollectionID))
          then
            begin
              ParcelHasSchool := True;
              TotalSchool := TotalSchool + 1;
            end;

        If ((tsTown in TaxSystemsToCheck) and
            ParcelHasOpenCurrentTaxes(qryTax, SwisSBLKey, '999999', iMunicipalCollectionID))
          then
            begin
              ParcelHasTown := True;
              TotalTown := TotalTown + 1;
            end;

        If ((tsCounty in TaxSystemsToCheck) and
            ParcelHasOpenCurrentTaxes(qryTax, SwisSBLKey, '999999', iCountyCollectionID))
          then
            begin
              ParcelHasCounty := True;
              TotalCounty := TotalCounty + 1;
            end;  *)

        If ((tsDelinquent in TaxSystemsToCheck) and
            _Compare(slLienSBLs.IndexOf(SwisSBLKey), -1, coGreaterThan))
          then
            begin
              ParcelHasLien := True;
              TotalLien := TotalLien + 1;
            end;

        If ((tsSchool in TaxSystemsToCheck) and
            _Compare(slSchoolSBLs.IndexOf(SwisSBLKey), -1, coGreaterThan))
          then
            begin
              ParcelHasSchool := True;
              TotalSchool := TotalSchool + 1;
            end;

        If ((tsTown in TaxSystemsToCheck) and
            _Compare(slMunicipalSBLs.IndexOf(SwisSBLKey), -1, coGreaterThan))
          then
            begin
              ParcelHasTown := True;
              TotalTown := TotalTown + 1;
            end;

        If ((tsCounty in TaxSystemsToCheck) and
            _Compare(slCountySBLs.IndexOf(SwisSBLKey), -1, coGreaterThan))
          then
            begin
              ParcelHasCounty := True;
              TotalCounty := TotalCounty + 1;
            end;

        If ((not Done) and
            (ParcelHasLien or
             ParcelHasSchool or
             ParcelHasTown or
             ParcelHasCounty))
          then
            with ParcelTable do
              try
                Edit;
                FieldByName('Arrears').AsBoolean := True;
                Post;

                Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                        #9 + 'Added');
                NumAdded := NumAdded + 1;

              except
                SystemSupport(002, ParcelTable, 'Error adding arrears flag for ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                              UnitName, GlblErrorDlgBox);
              end;

        ReportCancelled := ProgressDialog.Cancelled;

        If (LinesLeft < 5)
          then NewPage;

      until (Done or ReportCancelled);

      If (LinesLeft < 7)
        then NewPage;

      Println('');
      Println('');
      Println(#9 + 'Number cleared = ' + IntToStr(NumCleared));
      Println(#9 + 'Number added = ' + IntToStr(NumAdded) +
                   '  (distinct parcels that were marked with arrears flag)');

      If (tsDelinquent in TaxSystemsToCheck)
        then Println(#9 + '  Parcels with delinquent liens = ' + IntToStr(TotalLien));

      If (tsSchool in TaxSystemsToCheck)
        then Println(#9 + '  Parcels with delinquent school taxes = ' +
                     IntToStr(TotalSchool));

      If (tsTown in TaxSystemsToCheck)
        then Println(#9 + '  Parcels with delinquent town taxes = ' +
                     IntToStr(TotalTown));

      If (tsCounty in TaxSystemsToCheck)
        then Println(#9 + '  Parcels with delinquent county taxes = ' +
                     IntToStr(TotalCounty));

    end;  {with Sender as TBaseReport do}

  slSchoolSBLs.Free;
  slMunicipalSBLs.Free;
  slCountySBLs.Free;
  slLienSBLs.Free;

end;  {ReportPrint}

{===================================================================}
Procedure TLoadArrearsFlagsFromSQLTaxesForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.