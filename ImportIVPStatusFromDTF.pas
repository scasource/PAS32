unit ImportIVPStatusFromDTF;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Types, Zipcopy,
  RPCanvas, RPrinter, RPDefine, RPBase, RPFiler, PASTypes;

type
  NotFound_InvalidParcelRecord = record
    Status : String;
    ParcelID : String;
    sOwner : String;
    sLegalAddress : String;
    ErrorMessage : String;
  end;

  NotFound_InvalidParcelPointer = ^NotFound_InvalidParcelRecord;


  TImportIVPStatusFileForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    ParcelTable: TTable;
    ExemptionTable: TTable;
    MiscellaneousGroupBox: TGroupBox;
    PrintLabelsForUnknownStatusCheckBox: TCheckBox;
    Label1: TLabel;
    AssessmentYearRadioGroup: TRadioGroup;
    Label2: TLabel;
    PrintLabelsForDeniedStatusCheckBox: TCheckBox;
    Label3: TLabel;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    OpenDialog: TOpenDialog;
    TrialRunCheckBox: TCheckBox;
    Label4: TLabel;
    ReportLabelPrinter: TReportPrinter;
    ReportLabelFiler: TReportFiler;
    SwisCodeTable: TwwTable;
    AssessmentYearControlTable: TTable;
    Label5: TLabel;
    PrintLabelsForApprovedStatusCheckBox: TCheckBox;
    Label6: TLabel;
    PrintLabelsForApproved_NotEnrolledStatusCheckBox: TCheckBox;
    Label7: TLabel;
    UpdateStatusIfNotEnrolledCheckBox: TCheckBox;
    Label8: TLabel;
    MarkApprovedHomeownersEnfrolledCheckBox: TCheckBox;
    tbParcels2: TTable;
    cbxExtractToExcel: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure ReportLabelPrintHeader(Sender: TObject);
    procedure ReportLabelPrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ProcessingType : Integer;
    AssessmentYear : String;
    TrialRun,
    PrintLabelsForApprovedStatus,
    PrintLabelsForApproved_NotEnrolled,
    PrintLabelsForUnknownStatus, PrintLabelsForDeniedStatus : Boolean;
    ImportFile : TextFile;
    ApprovedStatusList, ApprovedStatusNotEnrolledList,
    UnknownStatusList, DeniedStatusList, lstApprovedNoEnhancedSTAR : TStringList;
    CurrentReportSection : String;

      {Label variables}

    LabelOptions : TLabelOptions;
    ParcelListForLabels : TStringList;
    NotFound_InvalidParcelList : TList;

    MarkApprovedHomeownersEnrolled,
    UpdateStatusEvenIfNotMarkedEnrolled,
    bExtractToExcel : Boolean;
    sSpreadsheetFileName : String;
    flExtract : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure MarkSeniorExemptionsApproved(    Sender : TObject;
                                               SwisSBLKey : String;
                                               Status : String;
                                               FieldList : TStringList;
                                           var SeniorExemptionApprovedCount : LongInt;
                                           var EnhancedSTARExemptionApprovedCount : Integer;
                                           var NotEnrolledCount : Integer);

    Procedure PrintLabelsForStatusList(StatusList : TStringList;
                                       StatusText : String);

    Procedure PrintUnknownOrDeniedStatusList(Sender : TObject;
                                             StatusList : TStringList;
                                             Status : String;
                                             ReportSection : String);

    Procedure PrintNotFound_OrInvalidList(Sender : TObject;
                                          NotFound_InvalidParcelList : TList);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils,
     UtilExsd, Prog, Preview, DataAccessUnit;

{$R *.DFM}

{========================================================}
Procedure TImportIVPStatusFileForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TImportIVPStatusFileForm.InitializeForm;

begin
  UnitName := 'ImportIVPStatusFromDTF';  {mmm}

end;  {InitializeForm}

{========================================================}
Procedure TImportIVPStatusFileForm.PrintLabelsForStatusList(StatusList : TStringList;
                                                            StatusText : String);

var
  TempFile : TextFile;
  NewLabelFileName : String;

begin
  If ((MessageDlg('Please insert label paper to print out labels for the ' + StatusText,
                  mtConfirmation, [mbOK, mbCancel], 0) = idOK) and
      ExecuteLabelOptionsDialog(LabelOptions) and
      PrintDialog.Execute)
    then
      begin
          {FXX10102003-1(2.07j1): Make sure to reset to letter paper after printing the
                                  search report.}

        ReportLabelFiler.SetPaperSize(dmPaper_Letter, 0, 0);
        ReportLabelPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
        ParcelListForLabels := StatusList;

        If PrintDialog.PrintToFile
          then
            begin
              NewLabelFileName := GetPrintFileName(Self.Caption, True);
              GlblPreviewPrint := True;
              GlblDefaultPreviewZoomPercent := 70;
              ReportLabelFiler.FileName := NewLabelFileName;

              try
                PreviewForm := TPreviewForm.Create(self);
                PreviewForm.FilePrinter.FileName := NewLabelFileName;
                PreviewForm.FilePreview.FileName := NewLabelFileName;
                ReportLabelFiler.Execute;
                PreviewForm.ShowModal;
              finally
                PreviewForm.Free;

                  {Now delete the file.}
                try

                  AssignFile(TempFile, NewLabelFileName);
                  OldDeleteFile(NewLabelFileName);

                finally
                  {We don't care if it does not get deleted, so we won't put up an
                   error message.}

                  ChDir(GlblProgramDir);
                end;

              end;  {If PrintRangeDlg.PreviewPrint}

            end  {They did not select preview, so we will go
                  right to the printer.}
          else ReportLabelPrinter.Execute;

      end;  {If ((MessageDlg('Please insert label ...}

end;  {PrintLabelsForStatusList}

{===================================================================}
Procedure TImportIVPStatusFileForm.StartButtonClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName, IVPImportFileName : String;
  ImportRecordCount : Integer;

begin
  Quit := False;
  CurrentReportSection := 'Approved Status';
  ImportRecordCount := 0;

  If OpenDialog.Execute
    then
      begin
        IVPImportFileName := OpenDialog.FileName;

        try
          AssignFile(ImportFile, IVPImportFileName);
          Reset(ImportFile);
        except
          Quit := True;
          SystemSupport(001, ParcelTable, 'Error opening DTF status file.',
                        UnitName, GlblErrorDlgBox);
        end;

        If not Quit
          then
            begin
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

              OpenTablesForForm(Self, ProcessingType);

              PrintLabelsForApprovedStatus := PrintLabelsForApprovedStatusCheckBox.Checked;
              PrintLabelsForApproved_NotEnrolled := PrintLabelsForApproved_NotEnrolledStatusCheckBox.Checked;
              PrintLabelsForUnknownStatus := PrintLabelsForUnknownStatusCheckBox.Checked;
              PrintLabelsForDeniedStatus := PrintLabelsForDeniedStatusCheckBox.Checked;
              TrialRun := TrialRunCheckBox.Checked;

                {CHG02102004-1(2.07l): Allow for options to mark all homeonwers as enrolled or
                                       to mark approved even if not enrolled.}

              MarkApprovedHomeownersEnrolled := MarkApprovedHomeownersEnfrolledCheckBox.Checked;
              UpdateStatusEvenIfNotMarkedEnrolled := UpdateStatusIfNotEnrolledCheckBox.Checked;

              UnknownStatusList := TStringList.Create;
              DeniedStatusList := TStringList.Create;
              ApprovedStatusList := TStringList.Create;
              ApprovedStatusNotEnrolledList := TStringList.Create;
              lstApprovedNoEnhancedSTAR := TStringList.Create;
              bExtractToExcel := cbxExtractToExcel.Checked;

              If bExtractToExcel
                then
                  begin
                    sSpreadsheetFileName := GetPrintFileName(Self.Caption, True);
                    AssignFile(flExtract, sSpreadsheetFileName);
                    Rewrite(flExtract);

                    WritelnCommaDelimitedLine(flExtract,
                                              ['Parcel ID', 'Status', 'Prior Status', 'Owner',
                                               'Legal Address #', 'Legal Address', 'Notes']);

                  end;  {If bExtractToExcel}

              If PrintDialog.Execute
                then
                  begin
                    AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                                          False, Quit);

                    If not Quit
                      then
                        begin
                          ProgressDialog.UserLabelCaption := '';
                          ProgressDialog.Start(ImportRecordCount, True, True);

                            {Now print the report.}

                          If not Quit
                            then
                              begin
                                GlblPreviewPrint := False;

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

                                  {FXX07221998-1: So that more than one person can run the report
                                                  at once, use a time based name first and then
                                                  rename.}

                                  {If they want to see it on the screen, start the preview.}

                                If PrintDialog.PrintToFile
                                  then
                                    begin
                                      GlblPreviewPrint := True;
                                      NewFileName := GetPrintFileName(Self.Caption, True);
                                      ReportFiler.FileName := NewFileName;

                                      try
                                        PreviewForm := TPreviewForm.Create(self);
                                        PreviewForm.FilePrinter.FileName := NewFileName;
                                        PreviewForm.FilePreview.FileName := NewFileName;

                                        PreviewForm.FilePreview.ZoomFactor := 130;

                                        ReportFiler.Execute;

                                          {FXX09071999-6: Tell people that printing is starting and
                                                          done.}

                                        ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                                        PreviewForm.ShowModal;
                                      finally
                                        PreviewForm.Free;
                                      end;

                                      ShowReportDialog('ImportIVPStatus.RPT', NewFileName, True);

                                    end
                                  else ReportPrinter.Execute;

                              end;  {If not Quit}

                            {Clear the selections.}

                          ProgressDialog.Finish;

                            {FXX09071999-6: Tell people that printing is starting and
                                            done.}

                          DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);


                        end;  {If not Quit}

                    ResetPrinter(ReportPrinter);

                    If PrintLabelsForApprovedStatus
                      then
                        begin
                          PrintLabelsForStatusList(ApprovedStatusList, 'approved status enrollees.');

                          If _Compare(lstApprovedNoEnhancedSTAR.Count, 0, coGreaterThan)
                            then PrintLabelsForStatusList(lstApprovedNoEnhancedSTAR, 'approved status, no Enhanced STAR.');

                        end;  {If PrintLabelsForApprovedStatus}

                    If PrintLabelsForApproved_NotEnrolled
                      then PrintLabelsForStatusList(ApprovedStatusNotEnrolledList, 'approved status, not enrolled homeowners.');

                    If PrintLabelsForUnknownStatus
                      then PrintLabelsForStatusList(UnknownStatusList, 'unknown status enrollees.');

                    If PrintLabelsForDeniedStatus
                      then PrintLabelsForStatusList(DeniedStatusList, 'denied status enrollees.');

                  end;  {If PrintDialog.Execute}

              UnknownStatusList.Free;
              DeniedStatusList.Free;
              ApprovedStatusList.Free;
              ApprovedStatusNotEnrolledList.Free;
              lstApprovedNoEnhancedSTAR.Free;

              If bExtractToExcel
                then
                  begin
                    CloseFile(flExtract);
                    SendTextFileToExcelSpreadsheet(sSpreadsheetFileName, True,
                                                   False, '');

                  end;  {If bExtractToExcel}

            end;  {If not Quit}

        CloseFile(ImportFile);

      end;  {If OpenDialog.Execute}

end;  {StartButtonClick}

{===================================================================}
Procedure AddOneNotFound_InvalidParcelPointer(NotFound_InvalidParcelList : TList;
                                              _Status : String;
                                              _ParcelID : String;
                                              _sOwner : String;
                                              _sLegalAddress : String;
                                              _ErrorMessage : String);

var
  NotFound_InvalidParcelPtr : NotFound_InvalidParcelPointer;

begin
  New(NotFound_InvalidParcelPtr);

  with NotFound_InvalidParcelPtr^ do
    begin
      Status := _Status;
      ParcelID := _ParcelID;
      sOwner := _sOwner;
      sLegalAddress := _sLegalAddress;
      ErrorMessage := _ErrorMessage;

    end;  {with NotFound_InvalidParcelPtr^ do}

  NotFound_InvalidParcelList.Add(NotFound_InvalidParcelPtr);

end;  {AddOneNotFound_InvalidParcelPointer}

{===================================================================}
Procedure TImportIVPStatusFileForm.MarkSeniorExemptionsApproved(    Sender : TObject;
                                                                    SwisSBLKey : String;
                                                                    Status : String;
                                                                    FieldList : TStringList;
                                                                var SeniorExemptionApprovedCount : LongInt;
                                                                var EnhancedSTARExemptionApprovedCount : Integer;
                                                                var NotEnrolledCount : Integer);

var
  Done, FirstTimeThrough, bExemptionFound : Boolean;
  sParcelID, sOwner, sLegalAddressNumber,
  sStatus, sLegalAddressName, ExemptionCode : String;

begin
  Done := False;
  FirstTimeThrough := True;
  bExemptionFound := False;

    {FXX04112012(2.28.4.18)[PAS-261]: Make sure to trim the fields since the fields now have leading blanks.}

  sStatus := Trim(FieldList[0]);
  sParcelID := Trim(FieldList[2]);
  sOwner := Trim(FieldList[4]);
  sLegalAddressNumber := Trim(FieldList[8]);
  sLegalAddressName := Trim(FieldList[9]);

  SetRangeOld(ExemptionTable, ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [AssessmentYear, SwisSBLKey, '00000'],
              [AssessmentYear, SwisSBLKey, '99999']);

  ExemptionTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ExemptionTable.Next;

    If ExemptionTable.EOF
      then Done := True;

    ExemptionCode := ExemptionTable.FieldByName('ExemptionCode').Text;

      {Only enhanced STAR.}

    If ((not Done) and
(*        (ExemptionIsSenior(ExemptionCode) or*)
        ExemptionIsEnhancedSTAR(ExemptionCode))
      then
        with ExemptionTable, Sender as TBaseReport do
          begin
            bExemptionFound := True;
            If (LinesLeft < 6)
              then NewPage;

              {CHG02102004-1(2.07l): Allow for options to mark all homeonwers as enrolled or
                                     to mark approved even if not enrolled.}

            If (UpdateStatusEvenIfNotMarkedEnrolled  or
                FieldByName('AutoRenew').AsBoolean)
              then
                begin
                  Println(#9 + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)) +
                          #9 + Status +
                          #9 + ExemptionCode +
                          #9 + 'Exemption approved.');

                  If not TrialRun
                    then
                      try
                        Edit;
                        FieldByName('ExemptionApproved').AsBoolean := True;

                          {CHG02102004-1(2.07l): Allow for options to mark all homeonwers as enrolled or
                                                 to mark approved even if not enrolled.}

                        If MarkApprovedHomeownersEnrolled
                          then FieldByName('AutoRenew').AsBoolean := True;

                        Post;
                      except
                        SystemSupport(002, ExemptionTable,
                                      'Error updating exemption approved flag for ' +
                                      ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                                      UnitName, GlblErrorDlgBox);
                      end;
(*
                  If ExemptionIsSenior(ExemptionCode)
                    then SeniorExemptionApprovedCount := SeniorExemptionApprovedCount + 1; *)

                  If ExemptionIsEnhancedSTAR(ExemptionCode)
                    then EnhancedSTARExemptionApprovedCount := EnhancedSTARExemptionApprovedCount + 1;

                  ApprovedStatusList.Add(SwisSBLKey);

                end
              else
                begin
                  ApprovedStatusNotEnrolledList.Add(SwisSBLKey);
                  Println(#9 + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)) +
                          #9 + Status +
                          #9 + ExemptionCode +
                          #9 + 'Owner not enrolled in IVP - not marked approved.');

                  NotEnrolledCount := NotEnrolledCount + 1;

                end;  {else of If FieldByName('AutoRenew').AsBoolean}

          end;  {with ExemptionTable, Sender as TBaseReport do}

  until Done;

  If not bExemptionFound
    then
      begin
        lstApprovedNoEnhancedSTAR.Add(SwisSBLKey);
        AddOneNotFound_InvalidParcelPointer(NotFound_InvalidParcelList, sStatus,
                                            sParcelID, sOwner,
                                            MakeLegalAddress(sLegalAddressNumber, sLegalAddressName),
                                            'Approved, no Enhanced STAR.');

        If bExtractToExcel
          then WriteCommaDelimitedLine(flExtract,
                                       ['Approved, no Enhanced STAR.']);

      end;  {If not bExemptionFound}

end;  {MarkSeniorExemptionsApproved}

{===================================================================}
Procedure TImportIVPStatusFileForm.PrintUnknownOrDeniedStatusList(Sender : TObject;
                                                                  StatusList : TStringList;
                                                                  Status : String;
                                                                  ReportSection : String);

var
  I : Integer;

begin
  CurrentReportSection := ReportSection;

  with Sender as TBaseReport do
    begin
      Underline := True;
      Println(#9 + CurrentReportSection + ':');
      Underline := False;

      For I := 0 to (StatusList.Count - 1) do
        begin
          If (LinesLeft < 5)
            then NewPage;

          Println(#9 + ConvertSBLOnlyToDashDot(Copy(StatusList[I], 7, 20)) +
                  #9 + Status +
                  #9 + #9 + ReportSection);

        end;  {For I := 0 (StatusList.Count - 1) do}

      Println('');
      Println(#9 + ReportSection + ': ' + IntToStr(StatusList.Count));
      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintUnknownOrDeniedStatusList}

{===================================================================}
Procedure TImportIVPStatusFileForm.PrintNotFound_OrInvalidList(Sender : TObject;
                                                               NotFound_InvalidParcelList : TList);

var
  I : Integer;

begin
  CurrentReportSection := 'Invalid or Not Found Parcels';

  with Sender as TBaseReport do
    begin
      Underline := True;
      Println(#9 + CurrentReportSection + ':');
      Underline := False;

        {Print the bad parcels.}

      For I := 0 to (NotFound_InvalidParcelList.Count - 1) do
        with NotFound_InvalidParcelPointer(NotFound_InvalidParcelList[I])^ do
          begin
            If (LinesLeft < 5)
              then NewPage;

            Println(#9 + ParcelID +
                    #9 + Status +
                    #9 +
                    #9 + ErrorMessage + '(' +
                         sOwner + ' - ' + sLegalAddress + ')');

          end;  {with NotFound_InvalidParcelPointer(NotFound_InvalidParcelList[I]), Sender as TBaseReport do}

      Println('');
      Bold := True;
      Println(#9 + 'Total Errors = ' + IntToStr(NotFound_InvalidParcelList.Count));

    end;  {with Sender as TBaseReport do}

end;  {PrintNotFound_OrInvalidList}

{===================================================================}
Procedure TImportIVPStatusFileForm.ReportPrintHeader(Sender: TObject);

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
      PrintCenter('Import IVP Status File', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;
      Println('');
      Bold := True;

      If TrialRun
        then
          begin
            Println('  Trial Run (no update)');
            Println('');
          end;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.3, 0, BOXLINENone, 0);   {Parcel ID}

      Underline := True;
      Println(#9 + CurrentReportSection + ':');
      Underline := False;
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.3, 0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(1.7, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {Status}
      SetTab(2.4, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {Exemption Code}
      SetTab(3.2, pjCenter, 2.5, 0, BOXLINEBottom, 0);   {Message}

      Println(#9 + 'Parcel ID' +
              #9 + 'Status' +
              #9 + 'EX Code' +
              #9 + 'Message');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.3, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(1.7, pjLeft, 0.6, 0, BOXLINENone, 0);   {Status}
      SetTab(2.4, pjLeft, 0.6, 0, BOXLINENone, 0);   {Exemption Code}
      SetTab(3.2, pjLeft, 2.5, 0, BOXLINENone, 0);   {Message}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TImportIVPStatusFileForm.ReportPrint(Sender: TObject);

var
  Done, ValidEntry, _Found, LineFeedOnly : Boolean;
  SBLRec : SBLRecord;
  {$H+}
  TempStr, ImportLine : String;
  {$H-}
  ParcelID, Status, SwisSBLKey, LastParcelID,
  sLegalAddressNumber, sLegalAddressName,
  sOwner, sPriorStatus : String;
  sTempGlblSublotSeparator : Char;
  SeniorExemptionApprovedCount,
  EnhancedSTARExemptionApprovedCount,
  NotEnrolledCount, TotalRecords, LineFeedPos : LongInt;
  FieldList : TStringList;

begin
  LastParcelID := '';
  Done := False;
  UnknownStatusList.Clear;
  DeniedStatusList.Clear;
  ApprovedStatusList.Clear;
  ApprovedStatusNotEnrolledList.Clear;

  SeniorExemptionApprovedCount := 0;
  EnhancedSTARExemptionApprovedCount := 0;
  NotEnrolledCount := 0;

    {First determine the number of records.}
  TotalRecords := 0;
  repeat
    {H+}
    Readln(ImportFile, TempStr);
    TotalRecords := TotalRecords + 1;
    {H-}
  until EOF(ImportFile);

    {CHG12022005-1(2.9.4.2): If there are no carriage returns, count the number of line feeds.}

  LineFeedOnly := _Compare(TotalRecords, 1, coEqual);

  If LineFeedOnly
    then TotalRecords := CountOfCharacter(TempStr, #10);

  Reset(ImportFile);
  ProgressDialog.Start(TotalRecords, True, True);

  NotFound_InvalidParcelList := TList.Create;
  FieldList := TStringList.Create;

    {Only 1 string if this is a line feed only file.}

  {$H+}
  If LineFeedOnly
    then Readln(ImportFile, ImportLine);
  {$H-}

  repeat
    {H+}
    If not LineFeedOnly
      then Readln(ImportFile, ImportLine);

    If LineFeedOnly
      then
        begin
          LineFeedPos := Pos(#10, ImportLine);

          If _Compare(LineFeedPos, 0, coGreaterThan)
            then
              begin
                TempStr := Copy(ImportLine, 1, (LineFeedPos - 1));
                Delete(ImportLine, 1, LineFeedPos);
              end
            else Done := True;
        end
      else
        begin
          TempStr := ImportLine;

          If EOF(ImportFile)
            then Done := True;

        end;  {else of If LineFeedOnly}


    ParseTabDelimitedStringIntoFields(TempStr, FieldList, True);

    {$H-}

    Status := Trim(FieldList[0]);
    ProgressDialog.Update(Self, LastParcelID);

    If (_Compare(Length(Status), 1, coEqual) and
        (Status[1] in ['U', 'N', 'Y']))  {Valid status line}
      then
        begin
          sPriorStatus := Take(1, FieldList[1]);
          ParcelID := FieldList[2];
          sOwner := FieldList[4];
          sLegalAddressNumber := FieldList[8];
          sLegalAddressName := FieldList[9];

          If (ParcelID <> LastParcelID)
            then
              begin
                SBLRec := ConvertDashDotSBLToSegmentSBL(ParcelID, ValidEntry);

                If bExtractToExcel
                  then WriteCommaDelimitedLine(flExtract,
                                               [ParcelID, Status, sPriorStatus, sOwner,
                                                sLegalAddressNumber, sLegalAddressName]);

                If ValidEntry
                  then
                    begin
                      with SBLRec do
                        _Found := FindKeyOld(ParcelTable,
                                             ['TaxRollYr', 'Section', 'Subsection', 'Block',
                                              'Lot', 'Sublot', 'Suffix'],
                                             [AssessmentYear, Section, Subsection, Block,
                                              Lot, Sublot, Suffix]);

                      SwisSBLKey := ExtractSSKey(ParcelTable);

                        {FXX12042009-1(2.20.2.1): IVP parcel ID lookup issue.}
                        {If it was not found and the SWIS is on the front, try
                         again without it.}

                      If ((not _Found) and
                          _Compare(Pos('/', ParcelID), 3, coEqual))
                        then
                        begin
                          ParcelID := Copy(ParcelID, 4, 20);
                          SBLRec := ConvertDashDotSBLToSegmentSBL(ParcelID, ValidEntry);

                          with SBLRec do
                            _Found := FindKeyOld(ParcelTable,
                                                 ['TaxRollYr', 'Section', 'Subsection', 'Block',
                                                  'Lot', 'Sublot', 'Suffix'],
                                                 [AssessmentYear, Section, Subsection, Block,
                                                  Lot, Sublot, Suffix]);

                          If not _Found
                            then
                              begin
                                SBLRec := ConvertDashDotSBLToSegmentSBL(ParcelID, ValidEntry);
                                sTempGlblSublotSeparator := GlblSublotSeparator;
                                GlblSublotSeparator := '.';

                                with SBLRec do
                                  _Found := FindKeyOld(ParcelTable,
                                                       ['TaxRollYr', 'Section', 'Subsection', 'Block',
                                                        'Lot', 'Sublot', 'Suffix'],
                                                       [AssessmentYear, Section, Subsection, Block,
                                                        Lot, Sublot, Suffix]);

                                GlblSublotSeparator := sTempGlblSublotSeparator;

                              end;  {If not _Found}

                        end;  {If ((not _Found) and...}

                        {Try to find it by legal address.}

(*                      If not _Found
                        then
                          begin
                            If _Locate(tbParcels2, [AssessmentYear, sLegalAddressNumber, sLegalAddressName], '', [])
                              then
                                begin
                                  ValidEntry := True;
                                  SwisSBLKey := ExtractSSKey(tbParcels2);
                                  _Found := True;

                                  _Locate(ParcelTable, [AssessmentYear, Copy(SwisSBLKey, 7, 20)], '', [loParseSBLOnly]);

                                end;  {If _Locate(tbParcels2 ...}

                          end;  {If not _Found}

                        {Try by the IVPKeyField, i.e. the legal address in the IVP file.}

                      If not _Found
                        then
                          try
                            tbParcels2.IndexName := 'ByIVPKeyField';

                            If _Locate(tbParcels2, [Trim(sLegalAddressNumber + ' ' + sLegalAddressName)], '', [])
                              then
                                begin
                                  ValidEntry := True;
                                  SwisSBLKey := ExtractSSKey(tbParcels2);
                                  _Found := True;
                                  _Locate(ParcelTable, [AssessmentYear, Copy(SwisSBLKey, 7, 20)], '', [loParseSBLOnly]);

                                end;  {If _Locate(tbParcels2...}

                          finally
                            tbParcels2.IndexName := 'BYYEAR_LEGALADDRNO_LEGALADDR';
                          end;  {If not _Found} *)

                      If _Found
                        then
                          begin
                            case Status[1] of
                              'U' : UnknownStatusList.Add(SwisSBLKey);
                              'N' : DeniedStatusList.Add(SwisSBLKey);
                              'Y' : MarkSeniorExemptionsApproved(Sender, SwisSBLKey, Status,
                                                                 FieldList,
                                                                 SeniorExemptionApprovedCount,
                                                                 EnhancedSTARExemptionApprovedCount,
                                                                 NotEnrolledCount);
                            end;  {case Status[1] of}

                            If bExtractToExcel
                              then WritelnCommaDelimitedLine(flExtract, ['']);

                            with ParcelTable do
                              try
                                Edit;
                                FieldByName('IVPStatus').AsString := Status[1];
                                Post;
                              except
                                Cancel;
                              end;

                          end
                        else
                          begin
                            AddOneNotFound_InvalidParcelPointer(NotFound_InvalidParcelList, FieldList[0],
                                                                ParcelID, sOwner,
                                                                MakeLegalAddress(sLegalAddressNumber, sLegalAddressName),
                                                                'Parcel not found.');

                            If bExtractToExcel
                              then WritelnCommaDelimitedLine(flExtract, ['Parcel not found.']);

                          end
                    end
                  else
                    begin
                      AddOneNotFound_InvalidParcelPointer(NotFound_InvalidParcelList, FieldList[0],
                                                          ParcelID, sOwner,
                                                          MakeLegalAddress(sLegalAddressNumber, sLegalAddressName),
                                                          'Invalid parcel ID.');

                      If bExtractToExcel
                        then WritelnCommaDelimitedLine(flExtract, ['Invalid parcel ID.']);

                    end;  {else of If ValidEntry}

              end;  {If (ParcelID <> LastParcelID)}

        end;  {If (Take(1, FieldList[0])[1] in ['U', 'N', 'Y'])}

    LastParcelID := ParcelID;

  until Done;

    {Print the totals.}

  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
(*      Println(#9 + 'Senior Exemptions Approved: ' + IntToStr(SeniorExemptionApprovedCount)); *)
      Println(#9 + 'Enhanced STAR Exemptions Approved: ' + IntToStr(EnhancedSTARExemptionApprovedCount));
      Println(#9 + 'Not Enrolled in IVP - Exemption not Approved: ' + IntToStr(NotEnrolledCount));
      Println('');

    end;  {with Sender as TBaseReport do}

  PrintUnknownOrDeniedStatusList(Sender, UnknownStatusList, 'U', 'Unknown Status');
  PrintUnknownOrDeniedStatusList(Sender, DeniedStatusList, 'N', 'Denied Status');

  PrintNotFound_OrInvalidList(Sender, NotFound_InvalidParcelList);

  FieldList.Free;
  FreeTList(NotFound_InvalidParcelList, SizeOf(NotFound_InvalidParcelRecord));
  ProgressDialog.Finish;

end;  {ReportPrint}

{===================================================================}
Procedure TImportIVPStatusFileForm.ReportLabelPrintHeader(Sender: TObject);

begin
  PrintLabelHeader(Sender, LabelOptions);
end;  {ReportLabelPrintHeader}

{===================================================================}
Procedure TImportIVPStatusFileForm.ReportLabelPrint(Sender: TObject);

begin
  PrintLabels(Sender, ParcelListForLabels, ParcelTable,
              SwisCodeTable, AssessmentYearControlTable,
              AssessmentYear, LabelOptions);
end;  {ReportLabelPrint}

{===================================================================}
Procedure TImportIVPStatusFileForm.FormClose(    Sender: TObject;
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