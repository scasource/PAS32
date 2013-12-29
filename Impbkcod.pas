unit Impbkcod;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,pastypes,
  GlblCnst,Types, RPFiler, RPBase, RPCanvas, RPrinter, Progress, RPDefine,
  FileCtrl, ComCtrls;

type
  TImportBankCodeForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    TSODiskOpenDialog: TOpenDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    ParcelTable: TTable;
    TYParcelTable: TTable;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    CloseButton: TBitBtn;
    TSOCodeEdit: TEdit;
    FrozenBankCodesStringGrid: TStringGrid;
    ImportButton: TBitBtn;
    PrintBankCodesReceivedCheckBox: TCheckBox;
    ChangeThisYearBankCodesCheckBox: TCheckBox;
    BankCodeAuditGrid: TwwDBGrid;
    BankCodeAuditTable: TwwTable;
    BankCodeAuditDataSource: TwwDataSource;
    Label3: TLabel;
    Label4: TLabel;
    TSONameComboBox: TComboBox;
    cbxTabDelimited: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportFilerPrintHeader(Sender: TObject);
    procedure ImportButtonClick(Sender: TObject);
    procedure ReportPrinterPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    TSOImportFile : TextFile;

    TaxRollYear : String;
    LocalDebug  : Boolean;

    TSORec : String;
    TSOBankCode : String;
    TSOCodeLen : Integer;
    TSO_SwisSBL : String;
    PrintingExcessParcels, PrintBankCodesReceived : Boolean;
    TSOFileSize : LongInt;
    ReportSection : Integer;
    ChangeThisYearBankCodes : Boolean;
    TotalBankCodesImported : LongInt;
    BankCodesSuccessfullyImported, bTabDelimited : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}
    Function FrozenBankCode(BankCodeInParcel : String) : Boolean;

  end;

{$R *.DFM}

implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Prog, Preview, DataAccessUnit;

const
  rsCheckingForErrors = 0;
  rsImporting = 1;
  rsDeletingExcessParcels = 2;

{========================================================}
Procedure TImportBankCodeForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TImportBankCodeForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'IMPBKCOD.PAS';  {mmm}

  OpenTablesForForm(Self, NextYear);
  OpenTableForProcessingType(TYParcelTable, ParcelTableName,
                             ThisYear, Quit);

  TaxRollYear := GlblNextYear;

  LocalDebug := False;
  PrintingExcessParcels := False;
  ChangeThisYearBankCodes := ChangeThisYearBankCodesCheckBox.Checked;

  TTimeField(BankCodeAuditTable.FieldByName('TimeImported')).DisplayFormat := TimeFormat;

end;  {InitializeForm}

{===================================================================}
Procedure TImportBankCodeForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{===========================================================}
Procedure TImportBankCodeForm.ImportButtonClick(Sender: TObject);

var
  ImportsDirectory, NewFileName : String;
  TempFile, TempTSOFile : File;
  TempStr : String;
  Proceed : Boolean;

begin
  Proceed := False;
  ReportSection := rsCheckingForErrors;
  bTabDelimited := cbxTabDelimited.Checked;

  If bTabDelimited
    then ParcelTable.IndexName := 'ByPrintKey';

  If (Deblank(TSOCodeEdit.Text) = '')
    then
      begin
        MessageDlg('Please enter a TSO code to clear.', mtError, [mbOK], 0);
        TSOCodeEdit.SetFocus;
      end
    else
      begin
        TSOCodeLen := Length(Deblank(TSOCodeEdit.Text));

          {get file name of TSO disk}

        Proceed := TSODiskOpenDialog.Execute;

      end;  {else of If (Deblank(TSOCodeEdit.Text) <> '')}

    {CHG06292003-1(2.07e): Keep track of when bank codes are imported.}

(*  If (Proceed and
      (Deblank(TSONameComboBox.Text) = ''))
    then
      If (MessageDlg('You have not selected the name of the TSO that this file came from.' + #13 +
                     'If you do not, no information will be stored about this bank code import.' + #13 +
                     'Do you wish to proceed anyway?' + #13 +
                     'Note: If you do proceed, the bank codes will still be imported correctly.',
                     mtWarning, [mbYes, mbNo], 0) = idNo)
        then
          begin
            Proceed := False;
            TSONameComboBox.SetFocus;
          end; *)

  If Proceed
    then
      begin
          {CHG04242001-1: Option to change the bank code on TY, too.}

        ChangeThisYearBankCodes := ChangeThisYearBankCodesCheckBox.Checked;


        ParcelTable.First;

          {CHG11262001-4: Copy the TSO file to a temporary directory for faster
                          speed.}

        ImportsDirectory := ExpandPASPath(GlblProgramDir) + 'IMPORTS\';

        If not DirectoryExists(ImportsDirectory)
          then Mkdir(ImportsDirectory);

        CopyOneFile(TSODiskOpenDialog.Filename,
                    ImportsDirectory + StripPath(TSODiskOpenDialog.Filename));

          {get file size for progress dialogue box down in print logic}

        AssignFile(TempTSOFile, ImportsDirectory + StripPath(TSODiskOpenDialog.Filename));
        Reset(TempTsoFile);

           {compute actual file by mult blocksize * blocks}

        TSOFileSize := 128*FileSize(TempTSOFile);
        CloseFile(TempTsoFile);

          {now open tso file for real import}
        AssignFile(TSOImportFile,TSODiskOpenDialog.Filename);  {file for errors}
        Reset(TSOImportFile);
        ReadLn(TSOImportFile,TSORec);
        CloseFile(TSOImportFile);

        If not bTabDelimited
          then
            begin
              TempStr := Trim(Copy(TSORec, 27, 7));

                {tso code from screen and tso diskette 1st record should match}

              If ((Take(TSOCodeLen, TempStr) <> Take(TSOCodeLen,TSOCodeEdit.Text)) and
                  (MessageDlg('The TSO Code in the first record on the' + #13 +
                              'diskette (' +  Take(7, TempStr) +') does NOT match the TSO you' + #13 +
                              'have selected for processing (' +  Take(TSOCodeLen, TSOCodeEdit.Text) + ').' + #13 +
                              'Do You Want To Proceed?',
                              mtConfirmation, [mbYes, mbNo], 0) = idNo))
                then Proceed := False;

            end;  {If not bTabDelimited}

      end;  {If Proceed}

  If (Proceed and
      PrintDialog.Execute)
    then
      begin
        PrintBankCodesReceived := PrintBankCodesReceivedCheckBox.Checked;

          {If they want to preview the print (i.e. have it
           go to the screen), then we need to come up with
           a unique file name to tell the ReportFiler
           component where to put the output.
           Once we have done that, we will execute the
           report filer which will print the report to
           that file. Then we will create and show the
           preview print form and give it the name of the
           file. When we are done, we will delete the file
           and make sure that we go back to the original
           directory.}

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

              end;  {If PrintRangeDlg.PreviewPrint}

            end  {They did not select preview, so we will go
                  right to the printer.}
          else ReportPrinter.Execute;

          {CHG06292003-1(2.07e): Keep track of when bank codes are imported.}

        If (Deblank(TSONameComboBox.Text) <> '')
          then
            with BankCodeAuditTable do
              try
                Insert;
                FieldByName('TSOName').Text := TSONameComboBox.Text;
                FieldByName('DateImported').AsDateTime := Date;
                FieldByName('TimeImported').AsDateTime := Now;
                FieldByName('NumImported').AsInteger := TotalBankCodesImported;
                FieldByName('ImportSuccessful').AsBoolean := BankCodesSuccessfullyImported;
                FieldByName('BankReplaced').Text := TSOCodeEdit.Text;
                Post;
              except
                SystemSupport(010, BankCodeAuditTable,
                              'Error inserting bank code audit record.',
                              UnitName, GlblErrorDlgBox);
              end;

        ProgressDialog.Finish;

      end;  {If PrintDialog.Execute}

end;  {ImportButtonClick}

{=========================================================}
Procedure TImportBankCodeForm.ReportFilerPrintHeader(Sender: TObject);

var
  I, J : Integer;

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
      SetFont('Times New Roman', 12);
      Home;
      CRLF;
      Bold := True;
      PrintCenter('Bank Code Import Report', (PageWidth / 2));
      Bold := False;
      ClearTabs;
      SetTab(0.5, pjLeft, 1.7, 0, BOXLINENONE, 0);   {Bank Code}
      SetFont('Times New Roman', 10);

        {Print the selection information.}

      Bold := True;

      Println(#9 + 'Import For Bank Code:   ' + TSOCodeEdit.Text);
      CRLF;

      Print(#9 + 'Codes Not Overlaid: ');
      For I := 0 to 4 do
        For J := 0 to 1 do
          Print(FrozenBankCodesStringGrid.Cells[I,J] + ' ');
      Println(' ');
      Print(#9 + '                       ');
      For I := 0 to 4 do
        For J := 2 to 3 do
          Print(FrozenBankCodesStringGrid.Cells[I,J] + ' ');
      Println(' ');
      Print(#9 + '                       ');
      For I := 0 to 4 do
        For J := 4 to 4 do
          Print( FrozenBankCodesStringGrid.Cells[I,J] + ' ');
      Println(' ');
      Bold := False;

        {FXX08032003-2(2.07h): Increase SectionTop from 1.2 to 1.4 to make sure all codes are printed.}

      SectionTop := 1.4;

        {Print column headers.}

      Home;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      Bold := True;
      ClearTabs;

      If (ReportSection in [rsImporting, rsDeletingExcessParcels])
        then
          begin
            Bold := True;
            Underline := True;

            If (ReportSection = rsImporting)
              then Println(#9 + 'Bank codes imported from the TSO disk:')
              else Println(#9 + 'Parcels with bank codes deleted (excessed):');

            Bold := False;
            Underline := False;
            CRLF;

            SetTab(0.3, pjCenter, 2.0, 0, BOXLINEBOTTOM, 0);   {SBL}
            SetTab(2.4, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {name}
            SetTab(4.0, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {legal addr}
            SetTab(5.6, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Bank code}

            Print(#9 + 'Parcel ID' +
                  #9 + 'Name' +
                  #9 + 'Legal Address');

            If (ReportSection = rsImporting)
              then Println(#9 + 'Bank Cd')
              else Println('');

            ClearTabs;

            SetTab(0.3, pjLeft, 2.0, 0, BOXLINENone, 0);   {SBL}
            SetTab(2.4, pjLeft, 1.5, 0, BOXLINENone, 0);   {name}
            SetTab(4.0, pjLeft, 1.5, 0, BOXLINENone, 0);   {legal addr}
            SetTab(5.6, pjLeft, 0.7, 0, BOXLINENone, 0);   {Bank code}
            Bold := False;

          end
        else
          begin
            SetTab(0.5, pjLeft, 5.0, 0, BOXLINENone, 0);   {SBL}
            Bold := True;
            Underline := True;
            Println(#9 + 'Errors - Parcels on disk not found in parcel file:');
            Bold := False;
            Underline := False;

          end;  {If PrintingExcessParcels}

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerPrintHeader}

{=============================================================}
Function TImportBankCodeForm.FrozenBankCode(BankCodeInParcel : String) : Boolean;

var
  I, J : Integer;
  FrozenCodeLen : Integer;
  Frozen : boolean;
  FrozenCode : String;

begin
  Frozen := False;
  BankCodeInParcel := Take(7,UpcaseStr(DEblank(BankCodeInparcel)));

   For I := 0 to 4 do
     For J := 0 to 4 do
       with FrozenBankCodesStringGrid do
         If (Deblank(Cells[I,J]) <> '')
           then
             begin
               FrozenCodeLen := Length(Deblank(Cells[I,J]));

               FrozenCode := Take(FrozenCodeLen, UpCaseStr(Deblank(Cells[I,J])));

               If (Take(FrozenCodeLen, BankCodeInParcel) =
                   Take(FrozenCodeLen, FrozenCode))
                 then Frozen := True;

             end;  {If (Deblank(Cells[I,J]) <> '')}

  Result := Frozen;

end;  {FrozenBankCode}

{===============================================================}
Procedure ResetIt(var TempFile : TextFile);

{Had to write this in order to reset file while within scope of Report Printer.}

begin
  Reset(TempFile);
end;

{=============================================================}
Procedure TImportBankCodeForm.ReportPrinterPrint(Sender: TObject);

var
  TSOToClearLength : Integer;
  OldValue, TempOldValue, sPrintKey : String;
  Proceed, Quit, Found, Cancelled,
  _Found, Done, FirstTimeThrough : Boolean;
  TempSize, NotFoundCount, TotalRecsCount : Longint;
  SBLRec : SBLRecord;
  sFieldList : TStringList;

begin
  sFieldList := TStringList.Create;
  TotalBankCodesImported := 0;
  BankCodesSuccessfullyImported := False;
  NotFoundCount := 0;
  TotalRecsCount := 1;
  Quit := False;

  with Sender as TBaseReport do
    begin
      Bold := False;
         {flat file == total bytes/reclen}
      TempSize := TSOFileSize DIV 33 ;
        {prevent div by zero error on small file}
      If (TempSize < 10)
        then TempSize := 10;

      ProgressDialog.Start(TempSize, True, True);

       {First scan quality of tso disk, if too many sbls cant be found}
       {allow user to cancel job}

        {Now Update the parcel file with diskette bank codes}

      ProgressDialog.UserLabelCaption := 'Scanning Disk For SBL Accuracy';

         {now open tso file for real import}

      Done := False;
      FirstTimeThrough := True;
      Proceed := True;

      AssignFile(TSOImportFile, TSODiskOpenDialog.Filename);
      ResetIt(TSOImportFile);
      Readln(TSOImportFile, TSORec);

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else
            begin
              ReadLn(TSOImportFile, TSORec);
              TotalRecsCount := TotalRecsCount + 1;
            end;

         If EOF(TSOImportFile)
           then Done := True;

           {Extract the bank code and SBL Code from the input file }
           {record layout = swis(6),SBL(20),Bankcode(7)}

        If bTabDelimited
          then
            begin
              ParseTabDelimitedStringIntoFields(TSORec, sFieldList, True);

              try
                sPrintKey := sFieldList[1];
                TSOBankCode := sFieldList[2];

                Found := _Locate(ParcelTable, [sPrintKey], '', []);

                If Found
                  then TSO_SwisSBL := ExtractSSKey(ParcelTable)
                  else TSO_SwisSBL := sPrintKey;

              except
                Found := False;
              end;

            end
          else
            begin
              TSO_SwisSBL := Take(6, Copy(TSORec, 1, 6)) + Take(20, Copy(TSORec, 7, 20));
              TSOBankCode := Trim(Take(7, Copy(TSORec, 27, 7)));

              SBLRec := ExtractSwisSBLFromSwisSBLKey(TSO_SwisSBL);

                {CHG02142001-1: If the TSO did not SRAZ the lot field (as in Freeport)
                                and it is supposed to be, then do it.}
                {FXX05142003-1(2.07a): Don't zero fill this segment if there is an override preventing it.}

              If (((Deblank(SBLRec.Lot) = '') and
                   (fmShiftRightAddZeroes in GlblLotFormat)) and
                  (not GlblDontZeroFillBlankSegments))
                then SBLRec.Lot := '000';

              with SBLRec do
                Found := FindKeyOld(ParcelTable,
                                    ['TaxRollYr', 'SwisCode', 'Section',
                                     'Subsection', 'Block', 'Lot',
                                     'Sublot', 'Suffix'],
                                    [TaxRollYear, SwisCode, Section,
                                     SubSection, Block, Lot, SubLot, Suffix]);

            end;  {else of If bTabDelimited}

        If not Found
          then
            begin
              NotFoundCount := NotFoundCount + 1;
              Println(#9 + 'Parcel Not Found For Parcel ID: ' +
                           ConvertSwisSBLToDashDot(TSO_SwisSBL));

              If (LinesLeft < 5)
                then NewPage;

            end;  {If not Found}

          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

      until Done;

        {If there are errors, see if they want to proceed anyway.}

      If (NotFoundCount > 0)
        then Proceed := (MessageDlg('PLEASE NOTE: ' + IntToStr(NotFoundCount) +
                                    ' record(s) on this TSO disk had invalid parcel IDs ' +
                                    'out of ' + IntToStr(TotalRecsCount) + ' records scanned. ' +  #13 +
                                    'Do you want to proceed?', mtConfirmation,
                                    [mbYes, mbNo], 0) = idYes);

      ProgressDialog.Reset;

      CloseFile(TSOImportFile);

      If Proceed
        then
          begin
            ProgressDialog.Start(GetRecordCount(ParcelTable) * 2 + (TSOFileSize DIV 33),
                                 True, True);

            Done := False;
            FirstTimeThrough := True;

               {first mark all existing codes as '&' + 6char tso code}

            ProgressDialog.UserLabelCaption := 'Scanning Old Bank Codes For ' +
                                               Take(6, TSOCodeEdit.Text );

            ParcelTable.First;

            repeat
              If FirstTimeThrough
                then FirstTimeThrough := False
                else ParcelTable.Next;

              If ParcelTable.EOF
                then Done := True;

              ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));
              Application.ProcessMessages;

                {FXX02242004-2(2.08): Left trim the bank code to ignore leading space when
                                      comparing old bank code to the one to replace.}

              If (Take(TSOCodeLen, UpcaseStr(Trim(ParcelTable.FieldByName('BankCode').Text))) =
                  Take(TSOCodeLen, TSOCodeEdit.Text))
                then
                  with ParcelTable do
                    try
                      Edit;

                        {FXX02242004-2(2.08): Left trim the bank code to ignore leading space when
                                              comparing old bank code to the one to replace.}

                      FieldByName('BankCode').Text := '&' +  Take(6, Trim(FieldByName('BankCode').Text));

                      Post;
                    except
                      SystemSupport(005, ParcelTable,'Error Updating Parcel Table', UnitName, GlblErrorDlgBox);
                      Quit := True;
                    end;

              Cancelled := ProgressDialog.Cancelled;

            until (Done or Quit or Cancelled);

             {Now Update the parcel file with diskette bank codes}

            Done := False;
            FirstTimeThrough := True;
            ReportSection := rsImporting;

            ProgressDialog.UserLabelCaption := 'Updating Parcels With New Bank Codes For ' +
                                               Take(6, TSOCodeEdit.Text );

               {now open tso file for real import}

            AssignFile(TSOImportFile,TSODiskOpenDialog.Filename);
            ResetIt(TSOImportFile);
            Readln(TSOImportFile,TSORec);

            If PrintBankCodesReceived
              then NewPage;

            If not Quit
              then
                repeat
                  If FirstTimeThrough
                    then FirstTimeThrough := False
                    else ReadLn(TSOImportFile, TSORec);

                  ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

                  If EOF(TSOImportFile)
                    then Done := True;

                  If bTabDelimited
                    then
                      begin
                        ParseTabDelimitedStringIntoFields(TSORec, sFieldList, True);

                        try
                          sPrintKey := sFieldList[1];
                          TSOBankCode := sFieldList[2];

                          Found := _Locate(ParcelTable, [sPrintKey], '', []);

                          If Found
                            then TSO_SwisSBL := ExtractSSKey(ParcelTable)
                            else TSO_SwisSBL := sPrintKey;

                        except
                          Found := False;
                        end;

                      end
                    else
                      begin
                          {Extract the bank code and SBL Code from the input file }
                          {record layout = swis(6),SBL(20),Bankcode(7)}

                        TSO_SwisSBL := Take(6, Copy(TSORec, 1, 6)) + Take(20, Copy(TSORec, 7, 20));
                        TSOBankCode := Trim(Take(7, Copy(TSORec, 27, 7)));

                          {Next, fetch the master record associated with this S/B/L so we may
                           update it}

                        SBLRec := ExtractSwisSBLFromSwisSBLKey(TSO_SwisSBL);

                          {CHG02142001-1: If the TSO did not SRAZ the lot field (as in Freeport)
                                          and it is supposed to be, then do it.}
                          {FXX05142003-1(2.07a): Don't zero fill this segment if there is an override preventing it.}

                        If (((Deblank(SBLRec.Lot) = '') and
                             (fmShiftRightAddZeroes in GlblLotFormat)) and
                            (not GlblDontZeroFillBlankSegments))
                          then SBLRec.Lot := '000';

                        with SBLREc do
                          Found := FindKeyOld(ParcelTable,
                                              ['TaxRollYr', 'SwisCode', 'Section',
                                               'Subsection', 'Block', 'Lot',
                                               'Sublot', 'Suffix'],
                                              [TaxRollYear, SwisCode,
                                               Section, SubSection,
                                               Block, Lot, SubLot, Suffix]);

                      end;  {else of If bTabDelimited}

                  If (Found and
                      (not FrozenBankCode(ParcelTable.FieldByName('BankCode').Text)))
                    then
                      with ParcelTable do
                        try
                            {FXX12011999-7: Audit trail and update the changed by
                                           for bank code.}

                          Edit;
                          TotalBankCodesImported := TotalBankCodesImported + 1;
                          OldValue := FieldByName('BankCode').Text;
                          FieldByName('BankCode').Text := Take(7, TSOBankCode);

                              {FXX04242001-1: The flags were not set to send this parcel
                                              in the extract.}
                              {FXX06222001-2: Don't mark ones that did not actually change as
                                              being changed.  To do this, if we see that this
                                              parcel previously had this bank code, we will
                                              check the 6 characters that are still left of the
                                              original bank code, i.e. what is after the '&'
                                              versus the first 6 of the new code.  Note that this
                                              will fail if the 7th character changes, but most
                                              bank codes only have a few significant chars.}

                            {FXX08172001-1: Need to do a take 6 when copy the old value because
                                            the old value may not have been 7 chars.}

                          If ((Take(1, OldValue)[1] <> '&') or   {Was not this bank code}
                              ((Take(7, OldValue)[1] = '&') and  {Used to be this bank code}
                               (Take(6, Copy(OldValue, 2, 6)) <> Take(6, FieldByName('BankCode').Text))))
                            then
                              begin
                                FieldByName('LastChangeDate').AsDateTime := Date;
                                FieldByName('LastChangeByName').Text := GlblUserName;
                                FieldByName('ChangeExtracted').AsBoolean := False;
                                FieldByName('DateChangedForExtract').AsDateTime := date;

                                TempOldValue := OldValue;

                                If (Take(1, TempOldValue)[1] = '&')
                                  then System.Delete(TempOldValue, 1, 1);

                                AddToTraceFile(TSO_SwisSBL,
                                               Take(30, 'Base Information'),
                                               Take(30, 'BankCode'),
                                               TempOldValue, TSOBankCode, Time,
                                               ParcelTable);

                              end;  {If (Take(7, OldValue) <> Take(7, FieldByName('BankCode').Text))}

                          Post;

                            {CHG04242001-1: Option to change the bank code on TY, too.}
                            {FXX03012009-1(2.17.1.4): The change TY bank codes should be here.}

                          If ChangeThisYearBankCodes
                            then
                              begin
                                with SBLREc do
                                  _Found := FindKeyOld(TYParcelTable,
                                                       ['TaxRollYr', 'SwisCode', 'Section',
                                                        'Subsection', 'Block', 'Lot',
                                                        'Sublot', 'Suffix'],
                                                       [GlblThisYear, SwisCode,
                                                        Section, SubSection,
                                                        Block, Lot, SubLot, Suffix]);

                                If _Found
                                  then
                                    with TYParcelTable do
                                      try
                                        Edit;
                                        FieldByName('BankCode').Text := Take(7, TSOBankCode);
                                        FieldByName('LastChangeDate').AsDateTime := Date;
                                        FieldByName('LastChangeByName').Text := GlblUserName;

                                        Post;
                                      except
                                        SystemSupport(014, TYParcelTable, 'Error updating This Year bank code for ' +
                                                      ConvertSwisSBLToDashDot(ExtractSSKey(TYParcelTable)) + '.',
                                                      UnitName, GlblErrorDlgBox);
                                      end;

                              end;  {If ChangeThisYearBankCodes}

                          If (LinesLeft < 5)
                            then NewPage;

                            {FXX11191999-14 - Print out the bank codes that are put on.}


                          If PrintBankCodesReceived
                            then Println(#9 + ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)) +
                                         #9 + Take(13, ParcelTable.FieldByName('Name1').Text) +
                                         #9 + Take(13, GetLegalAddressFromTable(ParcelTable)) +
                                         #9 + FieldByName('BankCode').Text);

                        except
                          SystemSupport(009, ParcelTable,'Error Updating Parcel TAble', UnitName, GlblErrorDlgBox);
                          Quit := True;
                        end;

                until (Done or Quit);

              {now we blank out and print the execess properties}

            ReportSection := rsDeletingExcessParcels;
            TSOToClearLength := Length(Trim(TSOCodeEdit.Text)) + 1; {+1 for the &}

            If not Quit
              then
                begin
                  NewPage;

                  FirstTimeThrough := True;
                  Done := False;
                  ParcelTable.First;

                  ProgressDialog.UserLabelCaption := 'Deleting Excess Bank Codes For ' +
                                                      Take(6, TSOCodeEdit.Text);

                  repeat
                    If FirstTimeThrough
                      then FirstTimeThrough := False
                      else ParcelTable.Next;

                    If ParcelTable.EOF
                      then Done := True;

                    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

                    If ((not Done) and
                        (Take(TSOToClearLength, UpcaseStr(ParcelTable.FieldByName('BankCode').Text)) =
                         Take(TSOToClearLength, ('&' + TSOCodeEdit.Text))))
                      then
                        with ParcelTable do
                          try
                              {FXX12011999-7: Audit trail and update the changed by
                                             for bank code.}

                            Edit;
                            OldValue := Copy(FieldByName('BankCode').Text, 2, 6);
                            FieldByName('BankCode').Text := '';
                            FieldByName('LastChangeDate').AsDateTime := Date;
                            FieldByName('LastChangeByName').Text := GlblUserName;

                              {FXX04242001-1: The flags were not set to send this parcel
                                              in the extract.}

                            FieldByName('ChangeExtracted').AsBoolean := False;
                            FieldByName('DateChangedForExtract').AsDateTime := Date;
                            Post;


                              {CHG04242001-1: Option to change the bank code on TY, too.}

                            If ChangeThisYearBankCodes
                              then
                                begin
                                  SBLRec := ExtractSwisSBLFromSwisSBLKey(ExtractSSKey(ParcelTable));

                                  with SBLREc do
                                    _Found := FindKeyOld(TYParcelTable,
                                                         ['TaxRollYr', 'SwisCode', 'Section',
                                                          'Subsection', 'Block', 'Lot',
                                                          'Sublot', 'Suffix'],
                                                         [GlblThisYear, SwisCode,
                                                          Section, SubSection,
                                                          Block, Lot, SubLot, Suffix]);

                                  If _Found
                                    then
                                      with TYParcelTable do
                                        try
                                          Edit;
                                          FieldByName('BankCode').Text := '';
                                          FieldByName('LastChangeDate').AsDateTime := Date;
                                          FieldByName('LastChangeByName').Text := GlblUserName;

                                          Post;
                                        except
                                          SystemSupport(014, TYParcelTable, 'Error clearing This Year bank code for ' +
                                                        ConvertSwisSBLToDashDot(ExtractSSKey(TYParcelTable)) + '.',
                                                        UnitName, GlblErrorDlgBox);
                                        end;

                                end;  {If ChangeThisYearBankCodes}

                              {FXX04242001-1: Sending in wrong swis SBL key.}


                            TempOldValue := OldValue;

                            If (Take(1, TempOldValue)[1] = '&')
                              then System.Delete(TempOldValue, 1, 1);

                            AddToTraceFile(ExtractSSKey(ParcelTable),
                                           Take(30, 'Base Information'),
                                           Take(30, 'BankCode'),
                                           TempOldValue, '', Time,
                                           ParcelTable);

                            If (LinesLeft < 5)
                              then NewPage;

                            Println(#9 + ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)) +
                                    #9 + Take(13, ParcelTable.FieldByName('Name1').Text) +
                                    #9 + Take(13, GetLegalAddressFromTable(ParcelTable)));

                          except
                            SystemSupport(012, ParcelTable,'Error Updating Parcel TAble',
                                          UnitName, GlblErrorDlgBox);
                            Quit := True;
                          end;

                  until (Done or Quit);

                end;  {If not Quit}

          end;  {If Proceed}

      BankCodesSuccessfullyImported := not Quit;

      CloseFile(TSOImportFile);

    end;  {with Sender as TBaseReport do}

  sFieldList.Free;

end;  {ReportPrint}

{======================================================}
Procedure TImportBankCodeForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TImportBankCodeForm.FormClose(    Sender: TObject;
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