unit Rcptprnt;

interface

uses
   SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DB, DBTables, Wwtable, Wwdatsrc,BtrvDlg,
  Buttons, Types, ExtCtrls,Mask, Wwdbedit, Progress, Utilitys, Grids,
  Wwdbigrd, Wwdbgrid, Preview,RPCanvas, RPrinter, RPDefine, RPBase,
  RPFiler, Printers, CompatibilityUnit, wwSpeedButton, wwDBNavigator,
  wwclearpanel;

type
  TReceiptPrintForm = class(TForm)
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PropertyUseCodeTable: TTable;
    PayLookupFile: TTable;
    DueFile: TTable;
    PrintDialog: TPrintDialog;
    PayFile: TTable;
    CustOptionsTable: TTable;
    DueLookupFile: TTable;
    ParcelYearMasterFile: TTable;
    SwisCodeTable: TTable;
    SystemRecord: TTable;
    SchoolCodeTable: TTable;
    ExemptionDetailsFile: TTable;
    ExemptionDescTable: TTable;
    BaseTaxDetailsFile: TTable;
    BaseTaxRateFile: TTable;
    SpecialDistDetailsTa: TTable;
    SpecialDistRateFile: TTable;
    BillReceiptParameter: TTable;
    ChargeTable: TTable;
    PayDriverFile: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    StatusLabel: TLabel;
    ReportOrderRadioGroup: TRadioGroup;
    GroupBox1: TGroupBox;
    RequestedReceiptsOnlyCheckBox: TCheckBox;
    ReprintReceiptsCheckBox: TCheckBox;
    BatchRangeGroupBox: TGroupBox;
    BatchNameEdit: TMaskEdit;
    SeperatorLabel: TLabel;
    BatchExtEdit: TEdit;
    BatchGroupCheckBox: TCheckBox;
    DateRangeGroupBox: TGroupBox;
    Label5: TLabel;
    StartDateEdit: TMaskEdit;
    Label4: TLabel;
    EndDateEdit: TMaskEdit;
    Label6: TLabel;
    AllDatesCheckBox: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    PrintButton: TBitBtn;
    Label3: TLabel;
    Label7: TLabel;
    PrintBankReceiptsCheckBox: TCheckBox;
    Label8: TLabel;
    TempBatchTable: TwwTable;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportOrderRadioGroupClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
  private
    { Private declarations }
    ReprintReceipts, Cancelled : Boolean;

    function PastPrintCriteria: boolean;
    function meetsPrintCriteria: boolean;
    procedure MarkPaysAsReceiptPrintedForThisParcel;

  public
    Procedure InitializeForm;  {Open the tables and setup.}
    Function ValidSelections : Boolean;

    { Public declarations }
  end;


implementation
Uses WINUTILS, Glblvars,TaxUtil1,TaxTypes, PrntUtil,Spclutil,
       GenUtils,Glblcnst, Prog;
{$R *.DFM}
CONST
  Unitname = 'RCPTPRNT.PAS';
  BY_DATE = 0;
  BY_BATCH = 1;
  NOT_PRINTED_YET = 1;  {FXX09082000-21(MDT): Not_yet_Printed was wrong.}
  debug = false;

{=================================================================================}
Procedure TReceiptPrintForm.FormActivate(Sender: TObject);

begin
  WindowState := wsMaximized;
end;

{========================================================}
Procedure TReceiptPrintForm.InitializeForm;

var
  I : Integer;
  Quit : Boolean;

begin
  Opentablesforform(self);

    {FXX09112000-2(MDT): Make receipts easier to use.}

  DisableSelectionsInGroupBoxOrPanel(BatchRangeGroupBox);
  DisableSelectionsInGroupBoxOrPanel(DateRangeGroupBox);

end;  {InitializeForm}

{=================================================================}
Procedure TReceiptPrintForm.ReportOrderRadioGroupClick(Sender: TObject);

{FXX09112000-2(MDT): Make receipts easier to use.}

begin
  case ReportOrderRadioGroup.ItemIndex of
    BY_DATE :
      begin
        DisableSelectionsInGroupBoxOrPanel(BatchRangeGroupBox);
        EnableSelectionsInGroupBoxOrPanel(DateRangeGroupBox);
        StartDateEdit.SetFocus;
      end;

    BY_BATCH :
      begin
        EnableSelectionsInGroupBoxOrPanel(BatchRangeGroupBox);
        DisableSelectionsInGroupBoxOrPanel(DateRangeGroupBox);
        BatchNameEdit.SetFocus;
      end;

  end;  {case ReportOrderRadioGroup of}

end;  {ReportOrderRadioGroupClick}

{=================================================================}
Function TReceiptPrintForm.ValidSelections : Boolean;

begin
  Result := True;

  case ReportOrderRadioGroup.ItemIndex of
    BY_DATE :
      If ((not AllDatesCheckBox.Checked) and
          (StartDateEdit.Text = '  /  /    ') and
          (EndDateEdit.Text = '  /  /    '))
        then
          begin
            Result := False;
            MessageDlg('Please choose a date range.', mtError, [mbOK], 0);
            StartDateEdit.SetFocus;
          end
        else
          If (not AllDatesCheckBox.Checked)
            then
              try
                If (StrToDate(StartDateEdit.Text) >
                    StrToDate(EndDateEdit.Text))
                  then
                    begin
                      Result := False;
                      MessageDlg('The end date must be later than the start date.',
                                 mtError, [mbOK], 0);
                      EndDateEdit.SetFocus;

                    end;  {If (StrToDate(StartDateEdit.Text) >}

              except
                Result := False;
                MessageDlg('Either the start or end date is not a valid date.' + #13 +
                           'Please correct.', mtError, [mbOK], 0);
              end;

    BY_BATCH :
      begin
        If ((Deblank(BatchExtEdit.Text) = '') and
            (not BatchGroupCheckBox.Checked))
          then
            If (MessageDlg('You did not enter a batch extension,' + #13 +
                           'but you did not click the box to print all batches.' + #13 +
                           'Do you want to print all the batches in group ' + BatchNameEdit.Text + '?',
                           mtConfirmation, [mbYes, mbNo], 0) = idYes)
              then BatchGroupCheckBox.Checked := True
              else
                begin
                  Result := False;
                  BatchExtEdit.SetFocus;
                end;

        If BatchGroupCheckBox.Checked
          then
            begin
              FindNearestOld(PayDriverFile, ['BatchNo'],
                             [MakeBatchNameFromTempName(BatchNameEdit.Text)]);

              If (Take(9, PayDriverFile.FieldByName('BatchNo').AsString) <>
                  MakeBatchNameFromTempName(Take(9, BatchNameEdit.Text)))
                then
                  begin
                    Result := False;
                    MessageDlg('Sorry, there are no payments on file with that batch group.',
                               mtError, [mbOK], 0);
                    BatchNameEdit.SetFocus;

                  end;  {If (Take(9, PayDriverFile.FieldByName('BatchNo').AsString) <> ...}

            end
          else
            begin
              FindNearestOld(PayDriverFile, ['BatchNo'],
                             [MakeBatchNameFromTempName(BatchNameEdit.text) +
                              BatchExtEdit.Text]);

              If ((Take(9, PayDriverFile.FieldByName('BatchNo').AsString) <>
                   MakeBatchNameFromTempName(Take(9, BatchNameEdit.Text))) or
                  (Take(3, Copy(PayDriverFile.fieldByName('BatchNo').AsString,10,3)) <>
                   Take(3, BatchExtEdit.text)))
                then
                  begin
                    Result := False;
                    MessageDlg('Sorry, there are no payments on file with that batch group.',
                               mtError, [mbOK], 0);
                    BatchNameEdit.SetFocus;

                  end;  {If ((Take(9, PayDriverFile.FieldByName('BatchNo').AsString) <> ...}

            end;  {else of If BatchGroupCheckBox.Checked}

      end;  {BY_BATCH}

  end;  {case ReportOrderRadioGroup of}

end;  {ValidSelections}

{=================================================================}
Procedure TReceiptPrintForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;

begin
  Cancelled := False;
  PrintButton.Enabled := False;
  CloseButton.Enabled := False;

  If (ValidSelections and
      PrintDialog.Execute)
    then
      begin
        ReprintReceipts := ReprintReceiptsCheckBox.Checked;

         {FXX09142000-2(MDT): Force the paper size to letter.}
        ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
        ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);

          {FXX08302000-1(MDT): Spread the printer fix throughout the system.}

        SelectThePrinter(ReportPrinter);
        SelectThePrinter(ReportFiler);

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
                  DeleteFileOld(NewFileName);
                finally
                  {We don't care if it does not get deleted, so we won't put up an
                   error message.}

                  ChDir(GlblProgramDir);
                end;

              end;  {If PrintRangeDlg.PreviewPrint}

            end  {They did not select preview, so we will go
                  right to the printer.}
          else ReportPrinter.Execute;

      end;  {If (ValidSelections and ...}

  PrintButton.Enabled := True;
  CloseButton.Enabled := True;

end;  {PrintButtonClick}

{=================================================================================}
Function TReceiptPrintForm.PastPrintCriteria : Boolean;

begin
  Result := False;

  case ReportOrderRadioGroup.ItemIndex of
    BY_DATE :
      If not AllDatesCheckBox.Checked
        then
          If (Take(8, MakeYYYYMMDD(MakeMMDDYYYYFromDateTime(StrToDate(EndDateEdit.text)))) <
              Take(8, PayDriverFile.fieldByName('BatchNo').AsString))
            then Result := True;

    BY_BATCH :
      If (MakeBatchNameFromTempName(Take(9, BatchNameEdit.Text)) <>
          Take(9, PayDriverFile.fieldByName('BatchNo').AsString))
        then Result := True
        else
          If ((not BatchGroupCheckBox.Checked) and
              (Take(3, BatchExtEdit.text) <>
               Take(3, Copy(PayDriverFile.fieldByName('BatchNo').Text,10,3))))
            then Result := True;

  end;  {case ReportOrderRadioGroup.ItemIndex of}

end;  {PastPrintCriteria}

{=================================================================================}
Function TReceiptPrintForm.MeetsPrintCriteria : Boolean;

var
  Done, FirstTimeThrough,
  DateBatchOK, SingleRes : Boolean;

begin
  Result := False; {assume false, only change if we find it does not}
  Done := False;
  FirstTimeThrough := True;

   {check if any pays in range and not excluded for any of the following reasons:
     *not requested (if checked)
     *already printed (if option selected)}

  FindKeyOld(PayLookupFile,
             ['SchoolCodeKey', 'SwisCode', 'SBL'],
             [PayDriverFile.fieldByName('SchoolCodeKey').AsString,
              PayDriverFile.fieldByName('SwisCode').AsString,
              PayDriverFile.fieldByName('SBL').AsString]);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else PayLookupFile.Next;

    If (PayLookupFile.EOF or
        (ExtractConnectorKey(PayLookupFile) <> ExtractConnectorKey(PayDriverFile)))
      then Done := True;

    If not Done
      then
        begin
          SingleRes := True;

          If FindKeyOld(DueLookupFile, ['DocumentNo'],
                        [PayLookupFile.fieldByName('ApplytoNo').asString])
            then
              begin
                If DueLookupFile.fieldByName('voided').AsBoolean
                  then SingleRes := False
              end
            else
              begin
                SingleRes := False;{major error}
                NonBtrvSystemSupport(012,199,'ERROR. Internal data error, no corresponding due ' +
                                    'file rec for pay rec',unitname,glblErrorDlgBox);

              end;  {else of If FindKeyOld(DueLookupFile, ['DocumentNo'], ...}

            {if still good then keep checking}

          If SingleRes
            then
              begin
                DateBatchOK := False;{assume false, only change if we find it is true}

                case ReportOrderRadioGroup.ItemIndex of
                  BY_DATE :
                    If AllDatesCheckBox.Checked
                      then DateBatchOK := True
                      else
                        If InDateRange(PayLookupFile.FieldByName('PayDate').AsString,
                                       StartDateEdit.Text,
                                       EndDateEdit.Text)
                          then DateBatchOK := True;

                  BY_BATCH :
                    If (MakeBatchNameFromTempName(Take(9, BatchNameEdit.Text)) =
                        Take(9, PayLookupFile.fieldByName('BatchNo').AsString))
                      then
                        If BatchGroupCheckBox.Checked
                          then DateBatchOK := true {the batchno is correct}
                          else
                            If (Take(3, Copy(PayLookupFile.FieldByName('BatchNo').AsString,10,3)) =
                                Take(3, BatchExtEdit.Text))
                              then DateBatchOK := true;

                end; {case ReportOrderRadioGroup.ItemIndex of}

              end;   {If SingleRes}

          If DateBatchOK
            then
              begin
                  {check *not requested (if checked)
                   *already printed (if option selected)}

                If (RequestedReceiptsOnlyCheckBox.Checked and
                    (not PayLookupFile.FieldByName('ReceiptRequested').AsBoolean))
                  then SingleRes := False;

                  {FXX09122000-1(MDT): The logic to reprint was wrong.}

                If (SingleRes and
                    (PayLookupFile.FieldByName('ReceiptPrinted').AsBoolean and
                     (not ReprintReceiptsCheckBox.Checked)))
                  then SingleRes := False;

              end  {If DateBatchOK}

            else SingleRes := False;

            If SingleRes
              then Result := True;

          end;  {If not Done}

  until Done;

end;  {MeetsPrintCriteria}

{=================================================================================}
Procedure TReceiptPrintForm.MarkPaysAsReceiptPrintedForThisParcel;

var
  Done, FirstTimeThrough,
  SkipThisPay, ErrorFound, DateBatchOK : Boolean;
  TempFieldName : String;

begin
  ErrorFound := False;
  Done := False;
  FirstTimeThrough := True;

  {check if any pays in range and not excluded for any of the following reasons:
   *not requested (if checked)
   *already printed (if option selected)}

  FindKeyOld(PayLookupFile,
             ['SchoolCodeKey', 'SwisCode', 'SBL'],
             [PayDriverFile.fieldByName('SchoolCodeKey').AsString,
              PayDriverFile.fieldByName('SwisCode').AsString,
              PayDriverFile.fieldByName('SBL').AsString]);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else PayLookupFile.Next;

    If (PayLookupFile.EOF or
        (ExtractConnectorKey(PayLookupFile) <> ExtractConnectorKey(PayDriverFile)))
      then Done := True;

    If not Done
      then
        begin
          SkipThisPay := False;
          DateBatchOK := False;

          If FindKeyOld(DueLookupFile, ['DocumentNo'],
                        [PayLookupFile.FieldByName('ApplytoNo').asString])
            then
              begin
                If DueLookupFile.FieldByName('Voided').AsBoolean
                  then SkipThisPay := True;
              end
            else
              begin
                ErrorFound := True;
                NonBtrvSystemSupport(012,199,'Internal data error, no corresponding due ' +
                                     'file rec for pay rec',unitname,glblErrorDlgBox);
              end;  {else of If FindKeyOld(DueLookupFile, ['DocumentNo'], ...}

            {if still good then keep checking}

          If not (ErrorFound or SkipThisPay)
            then
              begin
                DateBatchOK := False;{assume false, only change if we find it is true}

                case ReportOrderRadioGroup.ItemIndex of
                  BY_DATE :
                    If AllDatesCheckBox.Checked
                      then DateBatchOK := True
                      else
                        If InDateRange(MakeMMDDYYYYSlashed(MakeMMDDYYYY(Take(8, PayLookupFile.fieldByName('BatchNo').AsString))),
                                       StartDateEdit.text,EndDateEdit.text)
                          then DateBatchOK := True;

                     {FXX09082000-23(MDT): Need to convert format of batch name
                                            that they entered.}

                  BY_BATCH :
                    If (MakeBatchNameFromTempName(Take(9, BatchNameEdit.Text)) =
                        Take(9, PayLookupFile.FieldByName('BatchNo').AsString))
                      then
                        If BatchGroupCheckBox.checked
                          then DateBatchOK := True
                          else
                            If (Take(3, Copy(PayLookupFile.fieldByName('BatchNo').AsString,10,3)) <>
                                Take(3, BatchExtEdit.text))
                              then DateBatchOK := True;

                end;  {case ReportOrderRadioGroup.ItemIndex of}

              end;  {If not (FoundError or SkipThisPay)}

          If DateBatchOK
            then
              begin
                 {check *not requested (if checked)
                  *already printed (if option selected)}

                If (RequestedReceiptsOnlyCheckBox.Checked and
                    (not PayLookupFile.fieldByName('ReceiptRequested').AsBoolean))
                  then SkipThisPay := True;

                If ((not SkipThisPay) and
                    (not PayLookupFile.FieldByName('ReceiptPrinted').AsBoolean))
                  then
                    begin
                      try
                        PayLookupFile.edit;

                        PayLookupFile.fieldByName('ReceiptPrinted').AsBoolean := true;

                        PayLookupFile.post;

                      except
                        SystemSupport(017,PayLookupFile,'Error marking Pay rec as Receipt Printed',
                                         Unitname,GlblErrorDlgBox);
                        ErrorFound := True;
                      end;{try except}

                     end;  {If ((not SkipThisPay) and ...}

                 {FXX09082000-20(MDT): Also post the receipt printed date to
                                       the parcel year master file.}
                  {FXX09122000-3(MDT): Do not post back the date if it was already printed.}
                  {FXX09292000-1(MDT): A misplaced End was causing the following to not
                                       get executed sometimes.}

                TempFieldName := 'ReceiptPrintedDate' +
                                 DueLookupFile.FieldByName('PaymentNo').Text;

                If (Deblank(ParcelYearMasterFile.FieldByName(TempFieldName).Text) = '')
                  then
                    with ParcelYearMasterFile do
                      try
                        Edit;
                        FieldByName(TempFieldName).AsDateTime := Date;
                        Post;
                      except
                        SystemSupport(056, ParcelYearMasterFile,
                                      'Error posting receipt date to parcel year master file.',
                                      Unitname, GlblErrorDlgBox);
                        ErrorFound := True;
                      end;

              end;  {If DateBatchOK}

        end;  {If not Done}

  until (Done or ErrorFound);

end;  {MarkPaysAsReceiptPrintedForThisParcel}

{=================================================================================}
Procedure TReceiptPrintForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough,
  FirstReceiptPrinted, ErrorFound : Boolean;
  AlreadyCheckedList : TList;
  AlreadyCheckedPtr  : AlreadyPrintedPointer;
  ReceiptTypeStr     : String;
  NumPrinted : LongInt;

begin
  FirstTimeThrough := True;
  FirstReceiptPrinted := True;
  Done := False;

  StatusLabel.caption := 'printing...';
  AlreadyCheckedList := TList.create;

  NumPrinted := 0;
  ProgressDialog.Start(PayDriverFile.RecordCount, True, True);

  case ReportOrderRadioGroup.ItemIndex of
    BY_DATE :
      begin
        PayDriverFile.IndexName := 'BYPAYDATE';

          {FXX09122000-2(MDT): Date conversion was wrong.}

        If AllDatesCheckBox.Checked
          then PayDriverFile.first
          else FindNearestOld(PayDriverFile, ['PayDate'],
                              [StartDateEdit.Text]);

      end;  {BY_DATE}

    BY_BATCH :
      begin
        PayDriverFile.IndexName := 'BYBATCHNO';

        If BatchGroupCheckBox.Checked
          then FindNearestOld(PayDriverFile, ['BatchNo'],
                              [MakeBatchNameFromTempName(BatchNameEdit.Text)])
          else FindNearestOld(PayDriverFile, ['BatchNo'],
                              [MakeBatchNameFromTempName(BatchNameEdit.Text) +
                               BatchExtEdit.text]);

      end;  {BY_BATCH}

  end;  {case ReportOrderRadioGroup.ItemIndex of}

   {we need to loop through the pay file}
  {look to see if the current swis sbl meets the print criteria and if
    it has not already been printed here--if passes then print and put in printed
    tlist}
  {after then .next we nned to check that we have not passed our print criteria}
     {(this should be a function)}

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else PayDriverFile.Next;

    If (PayDriverFile.EOF or
        PastPrintCriteria)
      then Done := True;

      {FXX09082000-19(MDT): Show a progress dialog.}

    ProgressDialog.UserLabelCaption := 'Num Printed = ' + IntToStr(NumPrinted);
    ProgressDialog.Update(Self,
                          ConvertSBLOnlyToDashDot(PayDriverFile.FieldByName('SBL').Text));

    If ((not Done) and
        NotInAlreadyCheckedList(ExtractConnectorKey(PayDriverFile),
                                AlreadyCheckedList))
      then
        begin
            {add to checked list}
          New(AlreadyCheckedPtr);
          AlreadyCheckedPtr^.ConnectorKey := ExtractConnectorKey(PayDriverFile);
          AlreadyCheckedList.Add(AlreadyCheckedPtr);

          If MeetsPrintCriteria
            then
              begin
                If FirstReceiptPrinted
                  then FirstReceiptPrinted := False
                  else TBaseReport(Sender).NewPage;

                  {print a receipt}
                  {check user prefs to see which receipt format they want and print it}

                ReceiptTypeStr := CustOptionsTable.FieldByname('DefaultReceiptType').AsString;
                NumPrinted := NumPrinted + 1;
                ErrorFound := False;

                  {FXX09292000-3(MDT): Make it so that bank receipts
                                       print out if requested.}

                If ((Deblank(ReceiptTypeStr) <> '') and
                    (UpcaseStr(ReceiptTypeStr) <> 'DEFAULT'))
                  then PrintSpecialReceipt(Sender,
                                          ReceiptTypeStr,
                                          BillReceiptParameter,
                                          ParcelYearMasterFile,
                                          PayFile, {by applytono key}
                                          DueFile, {(by connector key)}
                                          SchoolCodeTable,
                                          SwisCodeTable,
                                          PropertyUseCodeTable,
                                          systemrecord,
                                          ExemptionDetailsFile,
                                          ExemptionDescTable,
                                          BaseTaxDetailsFile,
                                          BaseTaxRateFile,
                                          SpecialDistDetailsTa,
                                          SpecialDistRateFile,
                                          TempBatchTable,
                                          ChargeTable,
                                          BillReceiptParameter,
                                          PayDriverFile.fieldByName('BatchNo').AsString,
                                          ExtractConnectorKey(PayDriverFile),
                                          ErrorFound)
                  else PrintBasicReceipt(Sender,
                                        ParcelYearMasterFile,
                                        PayFile, {by applytono key}
                                        DueFile, {(by connector key)}
                                        SchoolCodeTable,
                                        SwisCodeTable,
                                        PropertyUseCodeTable,
                                        systemrecord,
                                        ExemptionDetailsFile,
                                        ExemptionDescTable,
                                        BaseTaxDetailsFile,
                                        BaseTaxRateFile,
                                        SpecialDistDetailsTa,
                                        SpecialDistRateFile,
                                        ChargeTable,
                                        BillReceiptParameter,
                                        PayDriverFile.fieldByName('BatchNo').AsString,
                                        ExtractConnectorKey(PayDriverFile),
                                        PrintBankReceiptsCheckBox.Checked,
                                        ErrorFound,False);

                  {if appropriate then mark as receipt printed}
                  {we are assuming that if they are printing receipts that have not been
                   printed before we will exclude those from the same selection later.
                   ???Also, it is assumed that if they don't care if these were printed before
                   then we do not mark them as having been printed???}

                  {FXX09122000-4(MDT): Always go into this routine because if
                                       a print job gets jammed, they may need to
                                       start over , but some have not yet been
                                       marked.}

                MarkPaysAsReceiptPrintedForThisParcel;

              end;  {If MeetsPrintCriteria}

        end; {If ((not Done) and ...}

    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled);

  FreeTList(AlreadyCheckedList,sizeof(AlreadyPrintedRecord));
  StatusLabel.caption := 'done printing';
  ProgressDialog.Finish;

end;  {ReportPrint}

{============================================================================}
Procedure TReceiptPrintForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;
{=================================================================}
Procedure TReceiptPrintForm.FormClose(    Sender: TObject;
                                      var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  Action := caFree;
  GlblClosingAForm := True;
end;


end.