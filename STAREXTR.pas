unit Starextr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Types, Zipcopy;

type
  TSTARRenewalExtractForm = class(TForm)
    SwisCodeTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    ParcelTable: TTable;
    ExemptionTable: TTable;
    PrintOrderRadioGroup: TRadioGroup;
    AssessmentYearControlTable: TTable;
    AssessorsOfficeTable: TTable;
    ZipCopyDlg: TZipCopyDlg;
    ExemptionLookupTable: TTable;
    ExemptionCodeTable: TTable;
    RenewalApplicationsToPrintGroupBox: TGroupBox;
    EnhancedSTARRenewalCheckBox: TCheckBox;
    SeniorRenewalCheckBox: TCheckBox;
    MiscellaneousGroupBox: TGroupBox;
    IgnoreIfRenewalAlreadyReceivedCheckBox: TCheckBox;
    Label1: TLabel;
    AssessmentYearRadioGroup: TRadioGroup;
    Label2: TLabel;
    UseTYOwnersCheckBox: TCheckBox;
    TYParcelTable: TTable;
    Label3: TLabel;
    ExcludeEnhancedSTARsWithAutoRenewCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ProcessingType : Integer;
    AssessmentYear : String;
    PrintEnhancedSTARRenewals,
    PrintSeniorRenewals,
    IncludeIfRenewalAlreadyReceived,
    UseThisYearOwners, ExcludeEnhancedSTARsWithAutoRenew : Boolean;
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, PASTypes,
     UtilExsd, Prog;

{$R *.DFM}

const
  poParcelId = 1;
  poName = 0;
  poZip = 2;

{========================================================}
Procedure TSTARRenewalExtractForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TSTARRenewalExtractForm.InitializeForm;

begin
  UnitName := 'STAREXTR';  {mmm}

end;  {InitializeForm}

{===================================================================}
Procedure WriteHeaderRecord(var ExtractFile : TextFile;
                                Self : TForm;
                                AssessmentYear : String;
                                ExemptionTable,
                                ExemptionLookupTable,
                                ExemptionCodeTable,
                                SwisCodeTable,
                                ParcelTable,
                                AssessorsOfficeTable,
                                AssessmentYearControlFile : TTable;
                                PrintSeniorRenewals,
                                PrintEnhancedSTARRenewals,
                                IncludeIfRenewalAlreadyReceived,
                                ExcludeEnhancedSTARsWithAutoRenew : Boolean);

var
  Cancelled, SeniorFound, Done, FirstTimeThrough : Boolean;
  STARCount, SeniorCount : Integer;
  SwisSBLKey : String;
  TempStr : String;

begin
  ProgressDialog.UserLabelCaption := 'Scanning for Header Information';

  Write(ExtractFile, '0'); {1}
  Write(ExtractFile, Take(4, SwisCodeTable.FieldByName('SwisCode').Text)); {2-5}

  with AssessorsOfficeTable do
    begin
        {CHG12202001-1: They changed Assessor name and title to 1 field of 42 characters.}

      TempStr := Trim(FieldByName('AssessorName').Text) + ',' +
                 FieldByName('Title').Text;

      Write(ExtractFile, Take(20, FieldByName('MunicipalityName').Text));
      Write(ExtractFile, Take(42, TempStr));
      Write(ExtractFile, Take(30, FieldByName('Address1').Text));
      Write(ExtractFile, Take(30, FieldByName('Address2').Text));
      Write(ExtractFile, Take(30, FieldByName('City').Text));
      Write(ExtractFile, Take(10, FieldByName('Zip').Text));
      Write(ExtractFile, Take(12, FieldByName('Phone').Text));

    end;  {with AssessorsOfficeTable do}

  Write(ExtractFile, Take(10, AssessmentYearControlFile.FieldByName('TaxableStatusDate').Text));

    {Count up the number of extracts.}

  ParcelTable.First;
  Done := False;
  FirstTimeThrough := True;
  STARCount := 0;
  SeniorCount := 0;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If ParcelTable.EOF
      then Done := True;

    SwisSBLKey := ExtractSSKey(ParcelTable);
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

      {Get the exemptions and see if they have an senior. If
       they do, count this in the senior total.  If they do not, but
       they have a STAR, count this in the STAR total.}

    If ((not Done) and
        (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
      then
        begin
          SeniorFound := False;
          FindNearestOld(ExemptionTable,
                         ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                         [AssessmentYear, SwisSBLKey, '4180']);

            {CHG10192001-1: Allow them to exclude ones that have already been renewed.}

          If (((Take(4, ExemptionTable.FieldByName('ExemptionCode').Text) = '4180') and
               (Take(26, SwisSBLKey) = Take(26, ExemptionTable.FieldByName('SwisSBLKey').Text))) and
              (IncludeIfRenewalAlreadyReceived or
               ((not IncludeIfRenewalAlreadyReceived) and
                (not ExemptionTable.FieldByName('RenewalReceived').AsBoolean))))
            then SeniorFound := True;

          If SeniorFound
            then SeniorCount := SeniorCount + 1;

            {CHG10232002-2: Add NYS DTF AutoRenew feature for property owners with
                            Enhanced senior only.}

          If ((not SeniorFound) and
              FindKeyOld(ExemptionTable,
                         ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                         [AssessmentYear, SwisSBLKey, EnhancedSTARExemptionCode]) and
              (IncludeIfRenewalAlreadyReceived or
               ((not IncludeIfRenewalAlreadyReceived) and
                (not ExemptionTable.FieldByName('RenewalReceived').AsBoolean))) and
              ((not ExcludeEnhancedSTARsWithAutoRenew) or
               (ExcludeEnhancedSTARsWithAutoRenew and
                (not ExemptionTable.FieldByName('AutoRenew').AsBoolean))))
            then STARCount := STARCount + 1;

        end;  {If not Done}

    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled);

  ExemptionTable.CancelRange;
  If PrintSeniorRenewals
    then Write(ExtractFile, ShiftRightAddZeroes(Take(5, IntToStr(SeniorCount))))  {Senior renewals}
    else Write(ExtractFile, '00000');

  If PrintEnhancedSTARRenewals
    then Write(ExtractFile, ShiftRightAddZeroes(Take(5, IntToStr(STARCount))))  {STAR renewals}
    else Write(ExtractFile, '00000');

  Write(ExtractFile, '00000');  {No other renewals}
  Write(ExtractFile, ShiftRightAddZeroes(Take(6, IntToStr(STARCount + SeniorCount))));  {Total renewals}
  Writeln(ExtractFile, ConstStr(' ', 107));  {Filer}

end;  {WriteHeaderRecord}

{===================================================================}
Procedure WriteDetailRecord(var ExtractFile : TextFile;
                                RecordType : Char;
                                ParcelTable,
                                TYParcelTable,
                                SwisCodeTable,
                                AssessorsOfficeTable,
                                ExemptionTable : TTable;
                                PrintOrder : Integer;
                                UseThisYearOwners : Boolean);

var
  SwisSBLKey : String;
  NAddrArray : NameAddrArray;
  TempParcelTable : TTable;
  SBLRec : SBLRecord;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);
  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  Write(ExtractFile, RecordType);
  Write(ExtractFile, Take(4, SwisCodeTable.FieldByName('SwisCode').Text)); {2-5}
  Write(ExtractFile, Take(20, AssessorsOfficeTable.FieldByName('MunicipalityName').Text));

    {CHG10272001-1: Allow them to use NY exemptions and TY owner names.}

  If UseThisYearOwners
    then
      begin
        TempParcelTable := TYParcelTable;
        with SBLRec do
          FindKeyOld(TYParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                      'Block', 'Lot', 'Sublot', 'Suffix'],
                     [GlblThisYear, SwisCode, Section, Subsection,
                      Block, Lot, Sublot, Suffix]);

      end
    else TempParcelTable := ParcelTable;

  with TempParcelTable do
    begin
     case PrintOrder of
       poName :
         begin
           Write(ExtractFile, FieldByName('SwisCode').Text +
                              Take(25, FieldByName('Name1').Text));
           Write(ExtractFile, FieldByName('SwisCode').Text +
                              Take(25, FieldByName('Name1').Text));
         end;  {Name}

       poParcelID :
         begin
           Write(ExtractFile, FieldByName('SwisCode').Text +
                              Take(25, SwisSBLKey));
           Write(ExtractFile, FieldByName('SwisCode').Text +
                              Take(25, SwisSBLKey));
         end;  {ParcelID}

       poZip :
         begin
           Write(ExtractFile, FieldByName('SwisCode').Text +
                              Take(25, FieldByName('Zip').Text + '-' +
                                       FieldByName('ZipPlus4').Text));
           Write(ExtractFile, FieldByName('SwisCode').Text +
                              Take(25, FieldByName('Zip').Text + '-' +
                                       FieldByName('ZipPlus4').Text));
         end;  {ParcelID}

     end;  {case PrintOrder of}

    Write(ExtractFile, Take(25, ConvertSwisSBLToDashDot(SwisSBLKey)));
    Write(ExtractFile, Take(10, FieldByName('LegalAddrNo').Text));
    Write(ExtractFile, Take(25, FieldByName('LegalAddr').Text));

    GetNameAddress(TempParcelTable, NAddrArray);
    Write(ExtractFile, Take(30, NAddrArray[1]));
    Write(ExtractFile, Take(30, NAddrArray[2]));
    Write(ExtractFile, Take(25, NAddrArray[3]));
    Write(ExtractFile, Take(25, NAddrArray[4]));
    Write(ExtractFile, Take(25, NAddrArray[5]));
    Write(ExtractFile, Take(25, NAddrArray[6]));

    Writeln(ExtractFile, Take(10, FieldByName('Zip').Text + '-' +
                                  FieldByName('ZipPlus4').Text));

  end;  {with ParcelTable do}

end;  {WriteDetailRecord}

{===================================================================}
Procedure TSTARRenewalExtractForm.StartButtonClick(Sender: TObject);

var
  SeniorFound, Done,
  Quit, FirstTimeThrough, Cancelled : Boolean;
  ExtractFile : TextFile;
  SelectedFiles : TStringList;
  ExtractDir, MailSubject,
  STARExtractFileName : String;
  PrintOrder, NumSTARExtracted, NumSeniorExtracted : Integer;
  SwisSBLKey : String;

begin
  Done := False;
  FirstTimeThrough := True;
  Cancelled := False;
  NumSTARExtracted := 0;
  NumSeniorExtracted := 0;

  case AssessmentYearRadioGroup.ItemIndex of
    0 : begin
          AssessmentYear := GlblThisYear;
          ProcessingType := ThisYear;
        end;

    1 : begin
          AssessmentYear := GlblNextYear;
          ProcessingType := NextYear;
        end;

  end;  {case AssessmentYearRadioGroup.ItemIndex of}

    {CHG10232002-2: Add NYS DTF AutoRenew feature for property owners with
                    Enhanced senior only.}

  ExcludeEnhancedSTARsWithAutoRenew := ExcludeEnhancedSTARsWithAutoRenewCheckBox.Checked;

  OpenTablesForForm(Self, ProcessingType);

  UseThisYearOwners := UseTYOwnersCheckBox.Checked;
  OpenTableForProcessingType(TYParcelTable, ParcelTableName, ThisYear, Quit);

  STARExtractFileName := 'STAR' + Take(4, SwisCodeTable.FieldByName('SwisCode').Text);

  PrintOrder := PrintOrderRadioGroup.ItemIndex;

  case PrintOrder of
    poParcelId : ParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
    poName : ParcelTable.IndexName := 'BYYEAR_NAME';
  end;

  PrintEnhancedSTARRenewals := EnhancedSTARRenewalCheckBox.Checked;
  PrintSeniorRenewals := SeniorRenewalCheckBox.Checked;

    {CHG10192001-1: Allow them to exclude ones that have already been Renewed.}

  IncludeIfRenewalAlreadyReceived := IgnoreIfRenewalAlreadyReceivedCheckBox.Checked;

  ProgressDialog.Start((3 * GetRecordCount(ParcelTable)), True, True);

  AssignFile(ExtractFile, ExpandPASPath(GlblExportDir) + STARExtractFileName);
  Rewrite(ExtractFile);
  WriteHeaderRecord(ExtractFile, Self, AssessmentYear, ExemptionTable,
                    ExemptionLookupTable, ExemptionCodeTable, SwisCodeTable,
                    ParcelTable, AssessorsOfficeTable, AssessmentYearControlTable,
                    PrintSeniorRenewals, PrintEnhancedSTARRenewals,
                    IncludeIfRenewalAlreadyReceived,
                    ExcludeEnhancedSTARsWithAutoRenew);
  ProgressDialog.UserLabelCaption := 'Writing Detail Records';

    {We have to do 2 passes - first the type 1 extracts and then the type
     2 extracts. First we do the senior records.}

  ParcelTable.First;

  If PrintSeniorRenewals
    then
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else ParcelTable.Next;

        If ParcelTable.EOF
          then Done := True;

        SwisSBLKey := ExtractSSKey(ParcelTable);
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
        Application.ProcessMessages;

          {Check for a senior.}

        If ((not Done) and
            (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then
            begin
              FindNearestOld(ExemptionTable,
                             ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                             [AssessmentYear, SwisSBLKey, '4180']);

                {CHG10192001-1: Allow them to exclude ones that have already been renewed.}

              If (((Take(4, ExemptionTable.FieldByName('ExemptionCode').Text) = '4180') and
                   (Take(26, SwisSBLKey) = Take(26, ExemptionTable.FieldByName('SwisSBLKey').Text))) and
                  (IncludeIfRenewalAlreadyReceived or
                   ((not IncludeIfRenewalAlreadyReceived) and
                    (not ExemptionTable.FieldByName('RenewalReceived').AsBoolean))))
                then
                  begin
                    NumSeniorExtracted := NumSeniorExtracted + 1;
                    WriteDetailRecord(ExtractFile, '1', ParcelTable, TYParcelTable,
                                      SwisCodeTable, AssessorsOfficeTable,
                                      ExemptionTable, PrintOrder, UseThisYearOwners);

                    with ExemptionTable do
                      try
                        Edit;
                        FieldByName('RenewalPrinted').AsBoolean := True;
                        FieldByName('DateRenewalPrinted').AsDateTime := Date;
                        Post;
                      except
                        SystemSupport(001, ExemptionTable, 'Error posting to exemption record ' +
                                      SwisSBLKey + '.', UnitName, GlblErrorDlgBox);
                      end;

                  end;  {If (Take(4, ExemptionTable. ...}

            end;  {If not Done}

        Cancelled := ProgressDialog.Cancelled;

      until (Done or Cancelled);

    {Now go back through the file for type 2 (enhanced STAR) records.}

  If ((not Cancelled) and
      PrintEnhancedSTARRenewals)
    then
      begin
        Done := False;
        FirstTimeThrough := True;

        ParcelTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else ParcelTable.Next;

          If ParcelTable.EOF
            then Done := True;

          SwisSBLKey := ExtractSSKey(ParcelTable);
          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          Application.ProcessMessages;

          SeniorFound := False;

            {Check for a senior.}
            {CHG10192001-1: Allow them to exclude ones that have already been renewed.}

          If ((not Done) and
              (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
            then
              begin
                FindNearestOld(ExemptionTable,
                               ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                               [AssessmentYear, SwisSBLKey, '4180']);

                If ((Take(4, ExemptionTable.FieldByName('ExemptionCode').Text) = '4180') and
                    (Take(26, SwisSBLKey) = Take(26, ExemptionTable.FieldByName('SwisSBLKey').Text)))
                  then SeniorFound := True;

              end;  {If not Done}

            {If there was no senior found, then check for an enhanced STAR.}
            {CHG10232002-2: Add NYS DTF AutoRenew feature for property owners with
                            Enhanced senior only.}
            {FXX11122003-1(2.07k): People in IVP program were not being excluded.}

          If ((not Done) and
              (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
              (not SeniorFound) and
              FindKeyOld(ExemptionTable,
                         ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                         [AssessmentYear, SwisSBLKey, EnhancedSTARExemptionCode]) and
              (IncludeIfRenewalAlreadyReceived or
               ((not IncludeIfRenewalAlreadyReceived) and
                (not ExemptionTable.FieldByName('RenewalReceived').AsBoolean))) and
              ((not ExcludeEnhancedSTARsWithAutoRenew) or
               (ExcludeEnhancedSTARsWithAutoRenew and
                (not ExemptionTable.FieldByName('AutoRenew').AsBoolean))))
            then
              begin
                NumSTARExtracted := NumSTARExtracted + 1;
                WriteDetailRecord(ExtractFile, '2', ParcelTable, TYParcelTable,
                                  SwisCodeTable, AssessorsOfficeTable,
                                  ExemptionTable, PrintOrder, UseThisYearOwners);

                with ExemptionTable do
                  try
                    Edit;
                    FieldByName('RenewalPrinted').AsBoolean := True;
                    FieldByName('DateRenewalPrinted').AsDateTime := Date;
                    Post;
                  except
                    SystemSupport(001, ExemptionTable, 'Error posting to exemption record ' +
                                  SwisSBLKey + '.', UnitName, GlblErrorDlgBox);
                  end;

              end;  {If ((not Done) and ..}

          Cancelled := ProgressDialog.Cancelled;

        until (Done or Cancelled);

      end;  {If not Cancelled}

  ProgressDialog.Finish;
  CloseFile(ExtractFile);

  If not Cancelled
    then
      begin
        MessageDlg('The STAR renewal extract file has been created.' + #13 +
                   'There were ' + IntToStr(NumSeniorExtracted) + ' senior renewals in the file' + #13 +
                   'and ' + IntToStr(NumSTARExtracted) +
                   ' enhanced STAR only renewals in the file.',
                   mtInformation, [mbOK], 0);

          {CHG03232004-4(2.08): Change the email sending process and add it to all needed places.}

        If (MessageDlg('Do you want to email the STAR renewal form file?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            begin
              ExtractDir := GlblDrive + ':' + GlblExportDir;
              SelectedFiles := TStringList.Create;

              MailSubject := Trim(GlblMunicipalityName) + ' STAR renewal form extract ' + DateToStr(Date);

              EMailFile(Self, ExtractDir, ExtractDir, STARExtractFileName,
                        emlORPSExtract, '', MailSubject, '', SelectedFiles, False);
              SelectedFiles.Free;

            end;  {If (MessageDlg('Do you want to email this file?' + #13 +}

        If (MessageDlg('Do you want to copy\zip the STAR renewal form file to another drive or disk?',
                        mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            with ZipCopyDlg do
              begin
                InitialDrive := GlblDrive;
                InitialDir := GlblExportDir;
                SelectFile(ExpandPASPath(GlblExportDir) + STARExtractFileName);

                Execute;

              end;  {with ZipCopyDlg do}

      end;  {If not Cancelled}

end;  {StartButtonClick}

{===================================================================}
Procedure TSTARRenewalExtractForm.FormClose(    Sender: TObject;
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