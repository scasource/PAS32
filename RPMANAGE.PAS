unit Rpmanage;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler, Progress, Zipcopy, RPFPrint;


const
  NumReports = 42;

type
  ReportsArray = Array[1..NumReports] of String;

type
  TReportManagerForm = class(TForm)
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    PrintDialog: TPrintDialog;
    OpenDialog: TOpenDialog;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    ZipCopyDialog: TZipCopyDlg;
    FilePrinter: TFilePrinter;
    Panel3: TPanel;
    Label1: TLabel;
    CloseButton: TBitBtn;
    PrintButton: TBitBtn;
    CopyButton: TBitBtn;
    ViewButton: TBitBtn;
    RefreshButton: TBitBtn;
    PrintLaserWideButton: TBitBtn;
    PrintTabloidButton: TBitBtn;
    EditTopMargin: TEdit;
    Panel4: TPanel;
    ReportStringGrid: TStringGrid;
    Panel1: TPanel;
    TitleLabel: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure ViewButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EmailButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ReportNames, ReportFileNames : ReportsArray;
    ReportSelected : Integer;
    PrintFileName : String;
    Procedure InitializeForm;  {Open the tables and setup.}
    Procedure FillInReportGrid(Path : String;
                               ExtractFiles : Boolean);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Preview, PASTypes;

{$R *.DFM}

const
  AssessmentChangeLetters = 2;
  AssessmentChangeReport = 3;
  AssessorsReport = 10;
  AssessorsReportExtracts = 11;
  BillingFileExtracts = 15;
  ExemptionComparisonReport = 17;
  ExemptionFileExtract = 18;
  ExemptionLetters = 19;
  FullFileExtractIndex = 21;
  GenericLetters = 22;
  AuditNameAddressReport = 25;
  OtherExtractsIndex = 27;
  OtherReportsIndex = 28;
  SalesExtractIndex = 32;
  SDComparisonReport = 37;

{========================================================}
Procedure TReportManagerForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TReportManagerForm.FillInReportGrid(Path : String;
                                              ExtractFiles : Boolean);

var
  I, FileHandle : Integer;
  FileRec : TSearchRec;
  FileSize, FileDate, FileTime : String;

begin
  For I := 1 to NumReports do
    If ((ExtractFiles and
        (I in [BillingFileExtracts, ExemptionFileExtract, FullFileExtractIndex,
               OtherExtractsIndex, SalesExtractIndex])) or
        ((not ExtractFiles) and
         (not (I in [BillingFileExtracts, ExemptionFileExtract, FullFileExtractIndex,
                     OtherExtractsIndex, SalesExtractIndex]))))
      then
        begin
          FileRec.Name := '';
          FindFirst(Path + ReportFileNames[I], faAnyFile, FileRec);

          If (Deblank(FileRec.Name) = '')
            then
              begin
                FileTime := '';
                FileDate := '';
                FileSize := '';
              end
            else
              begin
                FileTime := TimeToStr(FileDateToDateTime(FileRec.Time));
                FileHandle := FileOpen(Path + ReportFileNames[I], 0);
                FileDate := DateToStr(FileDateToDateTime(FileGetDate(FileHandle)));
                FileSize := FormatFloat(IntegerDisplay, FileRec.Size);
                FileClose(FileHandle);

              end;  {else of If (Deblank(FileRec.Name) = '')}

          with ReportStringGrid do
            begin
              Cells[0, I] := ReportNames[I];
              Cells[1, I] := ReportFileNames[I];
              Cells[2, I] := FileDate;
              Cells[3, I] := FileTime;
              Cells[4, I] := FileSize;
            end;

        end;  {For I := 0 to (NumReports - 1) do}

end;  {FillInReportGrid}

{========================================================}
Procedure TReportManagerForm.InitializeForm;

{FXX10011999-1: Add the assessor's report extract files.}

begin
  ReportNames[1] := 'Assessed Val By Prop Class';
  ReportNames[2] := 'Assessment Change Letters - Letters';
  ReportNames[3] := 'Assessment Change Letters - Report';
  ReportNames[4] := 'Assessment Roll (Final) - Full';
  ReportNames[5] := 'Assessment Roll (Final) - Totals';
  ReportNames[6] := 'Assessment Roll (Ten.) - Full';
  ReportNames[7] := 'Assessment Roll (Ten.) - Totals';
  ReportNames[8] := 'Assessment Summary';
  ReportNames[9] := 'Assessment Variance';
  ReportNames[10] := 'Assessor''s Report';
  ReportNames[11] := 'Assessor''s Report Extract Files';
  ReportNames[12] := 'Assessor''s Trial Balance';
  ReportNames[13] := 'Assessor''s Verification';
  ReportNames[14] := 'Audit Trial';
  ReportNames[15] := 'Billing File Extracts (RPS 147 & 155)';
  ReportNames[16] := 'Exemption';
  ReportNames[17] := 'Exemption Comparison Report';
  ReportNames[18] := 'Exemption Extract File';
  ReportNames[19] := 'Exemption Letters';
  ReportNames[20] := 'Exemption Status Report';
  ReportNames[21] := 'Full File Extract (RPS 995 & 060)';
  ReportNames[22] := 'Generic Letters';
  ReportNames[23] := 'Labels';
  ReportNames[24] := 'Labels (Report section)';
  ReportNames[25] := 'Name \ Address Audit';
  ReportNames[26] := 'Notes Report';
  ReportNames[27] := 'Other Extracts';
  ReportNames[28] := 'Other Reports';
  ReportNames[29] := 'Parcel Print';
  ReportNames[30] := 'Roll Totals';
  ReportNames[31] := 'Sales (Transmittal)';
  ReportNames[32] := 'Sales Extract Files';
  ReportNames[33] := 'Sales Analysis';
  ReportNames[34] := 'Sales \ Removed Exemptions';
  ReportNames[35] := 'Search Report';
  ReportNames[36] := 'Special District';
  ReportNames[37] := 'Special District Comparison';
  ReportNames[38] := 'Tax Roll - Full';
  ReportNames[39] := 'Tax Roll - STAR Reimbursement Form';
  ReportNames[40] := 'Tax Roll - Totals';
  ReportNames[41] := 'Year End Rollover';
  ReportNames[42] := 'Other';

  ReportFileNames[1] := 'AVPRPCLS.RPT';
  ReportFileNames[2] := 'AVCHGLTR.LTR';
  ReportFileNames[3] := 'AVCHGLTR.RPT';
  ReportFileNames[4] := 'FIROLL.RPT';
  ReportFileNames[5] := 'FIROLTOT.RPT';
  ReportFileNames[6] := 'TNROLL.RPT';
  ReportFileNames[7] := 'TNROLTOT.RPT';
  ReportFileNames[8] := 'AVSUMMRY.RPT';
  ReportFileNames[9] := 'AVVARINC.RPT';
  ReportFileNames[10] := 'ASSESSOR.RPT';
  ReportFileNames[11] := 'RPS210T1';
  ReportFileNames[12] := 'ASRTRIAL.RPT';
  ReportFileNames[13] := 'ASREDIT.RPT';
  ReportFileNames[14] := 'AUDITTRL.RPT';
  ReportFileNames[15] := 'RPS155D1';
  ReportFileNames[16] := 'EXLIST.RPT';
  ReportFileNames[17] := 'RPCOMPEX.RPT';
  ReportFileNames[18] := 'RPS220T1';
  ReportFileNames[19] := 'EXEMPLTR.LTR';
  ReportFileNames[20] := 'EXSTATUS.RPT';
  ReportFileNames[21] := 'RPS995T1';
  ReportFileNames[22] := 'GENERIC.LTR';
  ReportFileNames[23] := 'LABELS.LBL';
  ReportFileNames[24] := 'LABELS.RPT';
  ReportFileNames[25] := 'AUDNMADR.RPT';
  ReportFileNames[26] := 'NOTES.RPT';
  ReportFileNames[27] := 'Any Extract';
  ReportFileNames[28] := 'Any Report';
  ReportFileNames[29] := 'PARCLPRT.RPT';
  ReportFileNames[30] := 'RPROLTOT.RPT';
  ReportFileNames[31] := 'SALES.RPT';
  ReportFileNames[32] := 'RPS035T1';
  ReportFileNames[33] := 'SALESANL.RPT';
  ReportFileNames[34] := 'SLRMVDEX.RPT';
  ReportFileNames[35] := 'SEARCH.RPT';
  ReportFileNames[36] := 'SDLIST.RPT';
  ReportFileNames[37] := 'RPCOMPSD.RPT';
  ReportFileNames[38] := 'XROLL.RPT';
  ReportFileNames[39] := 'XROLSTAR.RPT';
  ReportFileNames[40] := 'XROLLTOT.RPT';
  ReportFileNames[41] := 'YRENDROL.RPT';
  ReportFileNames[42] := 'Any File';

  UnitName := 'RPMANAGE';

  with ReportStringGrid do
    begin
      Cells[0, 0] := 'Report Name';
      Cells[1, 0] := 'File Name';
      Cells[2, 0] := 'File Date';
      Cells[3, 0] := 'File Time';
      Cells[4, 0] := 'File Size';
    end;

  ReportStringGrid.RowCount := NumReports + 1;

    {First do the report files}

  FillInReportGrid(ExpandPASPath(GlblReportDir), False);

    {Now do the extract files.}

  FillInReportGrid(ExpandPASPath(GlblExportDir), True);

end;  {InitializeForm}

{===================================================================}
Procedure TReportManagerForm.PrintButtonClick(Sender: TObject);

var
  NewFileName, TempStr : String;
  PCLFile, WideCarriage, Continue, Quit : Boolean;
  TempFile : TextFile;

begin
  Continue := True;
  PrintFileName := ReportFileNames[ReportStringGrid.Row];
  PrintDialog.MinPage := 1;
  PrintDialog.MaxPage := 32000;

  If (ReportStringGrid.Row in [BillingFileExtracts, ExemptionFileExtract, FullFileExtractIndex,
                               OtherExtractsIndex, SalesExtractIndex])
    then
      begin
        MessageDlg('Sorry! That is not a report.', mtError, [mbOK], 0);
        Continue := False;
      end
    else OpenDialog.InitialDir := ExpandPASPath(GlblReportDir);

  If Continue
    then
      begin
        If (PrintFileName = 'Any File')
          then PrintFileName := '';

        OpenDialog.FileName := PrintFileName;

          {FXX05012000-2: Add files of type Letter for letter reprints.}

        If (ReportStringGrid.Row in [AssessmentChangeLetters, ExemptionLetters,
                                     GenericLetters])
          then OpenDialog.FilterIndex := 2
          else OpenDialog.FilterIndex := 1;

        If (OpenDialog.Execute and
            PrintDialog.Execute)
          then
            begin
                {Set the name to what they actually chose.}

              PrintFileName := OpenDialog.FileName;

                {FXX01212000-1: Allow for recall of PCL format reports.}

              FileMode := 0;
              AssignFile(TempFile, PrintFileName);
              Reset(TempFile);
              Readln(TempFile, TempStr);

              PCLFile := (Pos('PCL', TempStr) > 0);

                {FXX02172000-1: Fix for wide carriage.}
                {FXX04232003-2: Make sure to not set dot matrix printers to wide carriage since
                                it might then end up in landscape more.}
                {FXX07072003-1(2.07f): Should be set to not WideCarriage if it is not a dot matrix
                                       printer, instead of if it is.}
                {FXX08262003-1(2.07i): It really doesn't matter about dot matrix - it is the report itself.}

              WideCarriage := True;
              If (PCLFile or
(*                  (not PrinterIsDotMatrix) or*)
                  (ReportStringGrid.Row in [AssessmentChangeReport,
                                            AuditNameAddressReport,
                                            ExemptionComparisonReport,
                                            SDComparisonReport]))
                then WideCarriage := False;

              CloseFile(TempFile);

              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler,
                                    [ptBoth], WideCarriage, Quit);

              If ((TComponent(Sender).Name <> 'PrintLaserWideButton') and
                  (TComponent(Sender).Name <> 'PrintTabloidButton'))
                then
                  If (MessageDlg('Do you want to print on letter sized paper?',
                                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
                    then
                      begin
                        ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
                        ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                        ReportPrinter.Orientation := poLandscape;
                        ReportFiler.Orientation := poLandscape;

                        If ReportPrinter.SupportDuplex
                          then
                            If (MessageDlg('Do you want to print on both sides of the paper?',
                                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
                              then
                                begin
                                  If (MessageDlg('Do you want to vertically duplex this report?',
                                                  mtConfirmation, [mbYes, mbNo], 0) = idYes)
                                    then ReportPrinter.Duplex := dupVertical
                                    else ReportPrinter.Duplex := dupHorizontal;
                                end
                              else ReportPrinter.Duplex := dupSimplex;

                          {FXX08202002-4: Wrong scale for Y on filer.}

                        ReportPrinter.ScaleX := 90;
                        ReportPrinter.ScaleY := 70;
                        ReportPrinter.SectionLeft := 1.5{StrToFloat(SectionLeftEdit.Text)};
                        ReportFiler.ScaleX := 90;
                        ReportFiler.ScaleY := 70;

                        try
                          GlblReportReprintSectionTop := StrToFloat(EditTopMargin.Text);
                        except
                          GlblReportReprintSectionTop := 1.0;
                        end;

                      end;  {If (Sender.Name = 'PrintReducedButton')}

              If (TComponent(Sender).Name = 'PrintLaserWideButton')
                then
                  begin
                    ReportPrinter.SetPaperSize(DMPAPER_FANFOLD_US, 0, 0);
                    ReportFiler.SetPaperSize(DMPAPER_FANFOLD_US, 0, 0);
                    ReportPrinter.Orientation := poPortrait;
                    ReportFiler.Orientation := poPortrait;

                  end;  {If (TComponent(Sender).Name = 'PrintLaserWideButton')}

              If (TComponent(Sender).Name = 'PrintTabloidButton')
                then
                  begin
                    ReportPrinter.SetPaperSize(DMPAPER_11X17, 0, 0);
                    ReportFiler.SetPaperSize(DMPAPER_11X17, 0, 0);
                    ReportPrinter.Orientation := poLandscape;
                    ReportFiler.Orientation := poLandscape;

                  end;  {If (TComponent(Sender).Name = 'PrintLaserWideButton')}

              If not Quit
                then
                  If PCLFile
                    then
                      begin
                        If PrintDialog.PrintToFile
                          then
                            begin
                              GlblPreviewPrint := True;

                              try
                                PreviewForm := TPreviewForm.Create(self);
                                PreviewForm.FilePrinter.FileName := PrintFileName;
                                PreviewForm.FilePreview.FileName := PrintFileName;

                                PreviewForm.ShowModal;
                              finally
                                PreviewForm.Free;
                              end;  {try PreviewForm := ...}

                            end
                          else
                            begin
                              FilePrinter.FileName := PrintFileName;
                              FilePrinter.Execute;

                            end;  {else of If PrintDialog.PrintToFile}
                      end
                    else
                      If PrintDialog.PrintToFile
                        then
                          begin
                            NewFileName := GetPrintFileName(Self.Caption, True);
                            ReportFiler.FileName := NewFileName;
                            GlblPreviewPrint := True;

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
                                Chdir(GlblReportDir);
                                OldDeleteFile(NewFileName);
                              finally
                                {We don't care if it does not get deleted, so we won't put up an
                                 error message.}

                                ChDir(GlblProgramDir);
                              end;

                            end;  {try PreviewForm := ...}

                          end  {If PrintDialog.PrintToFile}
                        else ReportPrinter.Execute;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

            end;  {If (OpenDialog.Execute and ...}

      end;  {If Continue}

end;  {PrintButtonClick}

{==================================================================}
Procedure TReportManagerForm.ReportPrint(Sender: TObject);

var
  TempTextFile : TextFile;
  StartPage, EndPage : Integer;

begin
  AssignFile(TempTextFile, PrintFileName);
  Reset(TempTextFile);

  If (PrintDialog.PrintRange = prAllPages)
    then
      begin
        StartPage := 1;
        EndPage := 32000;
      end
    else
      begin
        StartPage := PrintDialog.FromPage;
        EndPage := PrintDialog.ToPage;
      end;  {else of If (PrintDialog.PrintRange = prAllPages)}

  PrintTextReport(Sender, TempTextFile, StartPage, EndPage);

  CloseFile(TempTextFile);

end;  {ReportPrint}

{===================================================================}
Procedure TReportManagerForm.CopyButtonClick(Sender: TObject);

{CHG03221999-1: Allow them to copy to disk.}
{CHG08301999-1: Change zip\copy to allow selections from other dirs.}

begin
  with ZipCopyDialog do
    begin
      FileName := '*.*';
      If (ReportStringGrid.Row in [BillingFileExtracts, ExemptionFileExtract, FullFileExtractIndex,
                                   OtherExtractsIndex, SalesExtractIndex])
        then InitialDir := GlblExportDir
        else InitialDir := GlblReportDir;

        {FXX07191999-11: Select the report name if there is one.}

      case ReportStringGrid.Row of
        AssessorsReportExtracts :
                            begin
                              SelectFile(ExpandPASPath(GlblExportDir) + 'RPS210T1');
                              SelectFile(ExpandPASPath(GlblExportDir) + 'RPS060I1');
                            end;

        BillingFileExtracts : begin
                                SelectFile(ExpandPASPath(GlblExportDir) + 'RPS147D1');
                                SelectFile(ExpandPASPath(GlblExportDir) + 'RPS155D1');
                              end;

        FullFileExtractIndex : begin
                                 SelectFile(ExpandPASPath(GlblExportDir) + 'RPS995T1');
                                 SelectFile(ExpandPASPath(GlblExportDir) + 'RPS060I1');
                               end;

        SalesExtractIndex : begin
                              SelectFile(ExpandPASPath(GlblExportDir) + 'RPS035T1');
                              SelectFile(ExpandPASPath(GlblExportDir) + 'RPS035T2');
                              SelectFile(ExpandPASPath(GlblReportDir) + 'SALES.RPT');
                            end;

        ExemptionFileExtract : begin
                                 SelectFile(ExpandPASPath(GlblExportDir) + 'RPS220T1');
                                 SelectFile(ExpandPASPath(GlblReportDir) + 'EXLIST.RPT');
                               end;

        OtherExtractsIndex : FileName := '*.TXT';

        OtherReportsIndex : FileName := '*.RPT';

        else SelectFile(ExpandPASPath(InitialDir) +
                        ReportFileNames[ReportStringGrid.Row]);

      end;  {case ReportStringGrid.Row of}

      InitialDrive := GlblDrive;
      Execute;

    end;  {with ZipCopyDialog do}

end;  {CopyButtonClick}

{================================================================}
Procedure TReportManagerForm.ViewButtonClick(Sender: TObject);

{FXX0217200-5: Allow them to bring it up in notepad.}

var
  TempStr : String;
  PCLFile, Continue : Boolean;
  TempFile : TextFile;
  ReturnCode : Word;
  TempPChar : PChar;

begin
  Continue := True;
  PrintFileName := ReportFileNames[ReportStringGrid.Row];

  If (ReportStringGrid.Row in [BillingFileExtracts, ExemptionFileExtract, FullFileExtractIndex,
                               OtherExtractsIndex, SalesExtractIndex])
    then
      begin
        MessageDlg('Sorry! That is not a report.', mtError, [mbOK], 0);
        Continue := False;
      end
    else OpenDialog.InitialDir := ExpandPASPath(GlblReportDir);

  If Continue
    then
      begin
        OpenDialog.FileName := PrintFileName;

        If OpenDialog.Execute
          then
            begin
                {Set the name to what they actually chose.}

              PrintFileName := OpenDialog.FileName;

                {FXX01212000-1: Allow for recall of PCL format reports.}

              AssignFile(TempFile, PrintFileName);
              Reset(TempFile);
              Readln(TempFile, TempStr);

              PCLFile := (Pos('PCL', TempStr) > 0);

              If PCLFile
                then MessageDlg('Sorry, you can not view a laser only report as text.',
                                mtError, [mbOK], 0)
                else
                  begin
                    TempStr := 'C:\Program Files\Accessories\WORDPAD ' + PrintFileName;
                    GetMem(TempPChar, Length(TempStr) + 1);
                    StrPCopy(TempPChar, TempStr);
                    ReturnCode := WinExec(TempPChar, SW_Show);
                    FreeMem(TempPChar, Length(TempStr) + 1);

                    If (ReturnCode < 32)
                      then MessageDlg('Word pad failed to bring up the report. Error = ' + IntToStr(ReturnCode) + '.',
                                      mtError, [mbOK], 0);

                  end;  {else of If PCLFile}

            end;  {If OpenDialog.Execute}

      end;  {If Continue}

end;  {ViewButtonClick}

{===========================================================}
Procedure TReportManagerForm.EmailButtonClick(Sender: TObject);

{CHG10082003-1(2.07k): Extend email option to more programs.}

var
  TempStr, PrintFileName : String;
  PCLFile, Continue : Boolean;
  TempFile : TextFile;

begin
  Continue := True;

    {FXX07272004-1(2.08.0.07272004): Make sure to set the PrintFileName before calling the
                                     open dialog.}
                                      
  PrintFileName := ReportFileNames[ReportStringGrid.Row];

  If (ReportStringGrid.Row in [BillingFileExtracts, ExemptionFileExtract, FullFileExtractIndex,
                               OtherExtractsIndex, SalesExtractIndex])
    then
      begin
        MessageDlg('Sorry! That is not a report.', mtError, [mbOK], 0);
        Continue := False;
      end
    else
      begin
        OpenDialog.InitialDir := ExpandPASPath(GlblReportDir);
        OpenDialog.FileName := PrintFileName;
      end;

  If (Continue and
      OpenDialog.Execute)
    then
      begin
        PrintFileName := OpenDialog.FileName;

        AssignFile(TempFile, PrintFileName);
        Reset(TempFile);
        Readln(TempFile, TempStr);

        PCLFile := (Pos('PCL', TempStr) > 0);
        CloseFile(TempFile);

        If PCLFile
          then MessageDlg('Sorry, you can not email a laser only report.',
                          mtError, [mbOK], 0)
          else SendMail('', '', PrintFileName, '', '', '', '', '', True);

      end;  {If Continue}

end;  {EmailButtonClick}

{===================================================================}
Procedure TReportManagerForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TReportManagerForm.FormClose(    Sender: TObject;
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
