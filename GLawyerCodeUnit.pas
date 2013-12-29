unit GLawyerCodeUnit;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, DBGrids,
  Wwkeycb, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Printrng, Prog;

type
  TLawyerCodeForm = class(TForm)
    DataSource: TwwDataSource;
    LookupTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    TitleLabel: TLabel;
    PrintRangeDlg: TPrintRangeDlg;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    MainTable: TwwTable;
    GrievanceTable: TTable;
    CertiorariTable: TTable;
    SmallClaimsTable: TTable;
    IncrementalSearchLabel: TLabel;
    MainCodeLabel: TLabel;
    InsertLabel: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    SwisLabel: TLabel;
    Label17: TLabel;
    Label3: TLabel;
    Label28: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    CloseButton: TBitBtn;
    InsertButton: TBitBtn;
    DeleteButton: TBitBtn;
    PrintButton: TBitBtn;
    SaveButton: TBitBtn;
    UndoButton: TBitBtn;
    IncrementalSearch: TwwIncrementalSearch;
    MainCodeEdit: TDBEdit;
    EditName: TDBEdit;
    EditName2: TDBEdit;
    EditAddress: TDBEdit;
    EditAddress2: TDBEdit;
    EditStreet: TDBEdit;
    EditCity: TDBEdit;
    EditState: TDBEdit;
    EditZip: TDBEdit;
    EditZipPlus4: TDBEdit;
    DBGrid: TwwDBGrid;
    EditPhoneNumber: TDBEdit;
    EditFaxNumber: TDBEdit;
    EditAttorneyName: TDBEdit;
    EditEmail: TDBEdit;
    LabelReportFiler: TReportFiler;
    LabelReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure InsertButtonClick(Sender: TObject);
    procedure MainTableBeforePost(DataSet: TDataSet);
    procedure MainTableAfterPost(DataSet: TDataSet);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure UndoButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MainTableAfterEdit(DataSet: TDataSet);
    procedure MainTableAfterInsert(DataSet: TDataSet);
    procedure LabelPrint(Sender: TObject);
    procedure LabelPrintHeader(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    PrintLabels : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    EditMode : Char;
    LabelList : TList;
      {Label variables.}

    lb_PrintLabelsBold,
    lb_PrintOldAndNewParcelIDs,
    lb_PrintSwisCodeOnParcelIDs,
    lb_PrintParcelIDOnly : Boolean;

    lb_LabelType,
    lb_NumLinesPerLabel,
    lb_NumLabelsPerPage,
    lb_NumColumnsPerPage,
    lb_SingleParcelFontSize : Integer;

    lb_ResidentLabels, lb_LegalAddressLabels,
    lb_PrintParcelIDOnlyOnFirstLine : Boolean;
    lb_LaserTopMargin : Real;
    lb_PrintParcelID_PropertyClass : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Preview,
     PASTypes, GrievanceUtilitys;

{$R *.DFM}

{========================================================}
Procedure TLawyerCodeForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TLawyerCodeForm.InitializeForm;

begin
  UnitName := 'LawyerCodeUnit';  {mmm}

  If (FormAccessRights = raReadOnly)
    then MainTable.ReadOnly := True;  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

  PrintRangeDlg.CodeLength := MainTable.FieldByName('Code').DataSize;
  MakeEditReadOnly(MainCodeEdit, MainTable, False, '');
  InsertLabel.Visible := False;

end;  {InitializeForm}

{===================================================================}
Procedure TLawyerCodeForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{============================================================}
Procedure TLawyerCodeForm.MainTableAfterEdit(DataSet: TDataSet);

begin
  EditMode := 'E';
end;

{============================================================}
Procedure TLawyerCodeForm.MainTableAfterInsert(DataSet: TDataSet);

begin
  EditMode := 'I';
end;

{============================================================}
Procedure TLawyerCodeForm.MainTableBeforePost(DataSet: TDataSet);

begin
  If (GlblAskSave and
      (MessageDlg('Are you sure you want to save lawyer code ' +
                  MainTable.FieldByName('Code').Text + '?',
                  mtConfirmation, [mbYes, mbNo], 0) = idNo))
    then Abort;

end;  {MainTableBeforePost}

{===========================================================}
Procedure TLawyerCodeForm.MainTableAfterPost(DataSet: TDataSet);

var
  Done, FirstTimeThrough, Cancelled : Boolean;
  StatusThisSmallClaims, StatusThisCertiorari : Integer;
  GrievanceYear : String;

begin
  If ((EditMode = 'E') and
      (MessageDlg('Do you want to apply these changes to all current grievances with this representative?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        Done := False;
        FirstTimeThrough := True;
        GrievanceYear := DetermineGrievanceYear;

        SetRangeOld(GrievanceTable, ['TaxRollYr', 'GrievanceNumber'],
                    [GrievanceYear, '0'], [GrievanceYear, '99999']);

        GrievanceTable.First;
        ProgressDialog.Start(GetRecordCount(GrievanceTable), True, True);
        ProgressDialog.UserLabelCaption := 'Updating petitioner information.';

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else GrievanceTable.Next;

          If GrievanceTable.EOF
            then Done := True;

          ProgressDialog.Update(Self, GrievanceTable.FieldByName('GrievanceNumber').Text);
          Application.ProcessMessages;

          If ((not Done) and
              (GrievanceTable.FieldByName('LawyerCode').Text =
               MainTable.FieldByName('Code').Text))
            then
              with GrievanceTable do
                try
                  Edit;

                    {FXX07232009-1(2.20.1.11)[D6235]: If the municipality uses the rep. teb,
                                                      don't update the petitioner.}

                  If GlblGrievanceSeperateRepresentativeInfo
                    then SetAttorneyNameAndAddress(GrievanceTable, MainTable,
                                                   MainTable.FieldByName('Code').AsString)
                    else SetPetitionerNameAndAddress(GrievanceTable, MainTable,
                                                     MainTable.FieldByName('Code').Text);
                  Post;
                except
                  SystemSupport(003, GrievanceTable,
                                'Error updating grievance ' +
                                GrievanceTable.FieldByName('GrievanceNumber').Text + '.',
                                UnitName, GlblErrorDlgBox);
                end;

          Cancelled := ProgressDialog.Cancelled;

        until (Done or Cancelled);

        ProgressDialog.Finish;

      end;  {If (EditMode = 'E') and ...}

    {CHG10152003-1(2.07j2): Broadcast lawyer changes to open certs, small claims.}

  If ((EditMode = 'E') and
      (MessageDlg('Do you want to apply these changes to all current certioraris with this representative?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        Done := False;
        FirstTimeThrough := True;

        CertiorariTable.First;
        ProgressDialog.Start(GetRecordCount(CertiorariTable), True, True);
        ProgressDialog.UserLabelCaption := 'Updating lawyer information for certs.';

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else CertiorariTable.Next;

          If CertiorariTable.EOF
            then Done := True;

          ProgressDialog.Update(Self, CertiorariTable.FieldByName('CertiorariNumber').Text);
          Application.ProcessMessages;

          If ((not Done) and
              (CertiorariTable.FieldByName('LawyerCode').Text =
               MainTable.FieldByName('Code').Text))
            then
              begin
                GetCert_Or_SmallClaimStatus(CertiorariTable, StatusThisCertiorari);

                If ((StatusThisCertiorari = csOpen) and
                    (CertiorariTable.FieldByName('CertiorariNumber').AsInteger <> 0))
                  then
                    with CertiorariTable do
                      try
                        Edit;
                        SetPetitionerNameAndAddress(CertiorariTable, MainTable,
                                                    MainTable.FieldByName('Code').Text);
                        Post;
                      except
                        SystemSupport(004, CertiorariTable,
                                      'Error updating Certiorari ' +
                                      CertiorariTable.FieldByName('CertiorariNumber').Text + '.',
                                      UnitName, GlblErrorDlgBox);
                      end;

              end;  {If ((not Done) and ...}

          Cancelled := ProgressDialog.Cancelled;

        until (Done or Cancelled);

        ProgressDialog.Finish;

      end;  {If (EditMode = 'E') and ...}

  If ((EditMode = 'E') and
      (MessageDlg('Do you want to apply these changes to all current small claims with this representative?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then
      begin
        Done := False;
        FirstTimeThrough := True;

        SmallClaimsTable.First;
        ProgressDialog.Start(GetRecordCount(SmallClaimsTable), True, True);
        ProgressDialog.UserLabelCaption := 'Updating lawyer information for small claims.';

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SmallClaimsTable.Next;

          If SmallClaimsTable.EOF
            then Done := True;

          ProgressDialog.Update(Self, SmallClaimsTable.FieldByName('IndexNumber').Text);
          Application.ProcessMessages;

          If ((not Done) and
              (SmallClaimsTable.FieldByName('LawyerCode').Text =
               MainTable.FieldByName('Code').Text))
            then
              begin
                GetCert_Or_SmallClaimStatus(SmallClaimsTable, StatusThisSmallClaims);

                If ((StatusThisSmallClaims = csOpen) and
                    (SmallClaimsTable.FieldByName('IndexNumber').AsInteger <> 0))
                  then
                    with SmallClaimsTable do
                      try
                        Edit;
                        SetPetitionerNameAndAddress(SmallClaimsTable, MainTable,
                                                    MainTable.FieldByName('Code').Text);
                        Post;
                      except
                        SystemSupport(004, SmallClaimsTable,
                                      'Error updating Small Claims ' +
                                      SmallClaimsTable.FieldByName('IndexNumber').Text + '.',
                                      UnitName, GlblErrorDlgBox);
                      end;

              end;  {If ((not Done) and ...}

          Cancelled := ProgressDialog.Cancelled;

        until (Done or Cancelled);

        ProgressDialog.Finish;

      end;  {If (EditMode = 'E') and ...}

  MakeEditReadOnly(MainCodeEdit, MainTable, False, '');
  InsertLabel.Visible := False;

end;  {MainTableAfterPost}

{===========================================================}
Procedure TLawyerCodeForm.InsertButtonClick(Sender: TObject);

begin
  with MainTable do
    try
      Append;
      MakeEditNotReadOnly(MainCodeEdit);
      InsertLabel.Visible := True;
      MainCodeEdit.SetFocus;
    except
      SystemSupport(001, MainTable, 'Error adding lawyer record.',
                    UnitName, GlblErrorDlgBox);
    end;

end;  {InsertButtonClick}

{===================================================================}
Procedure TLawyerCodeForm.SaveButtonClick(Sender: TObject);

begin
  If MainTable.Modified
    then
      try
        MainTable.Post;
      except
        SystemSupport(002, MainTable,
                      'Error saving lawyer code ' +
                      MainTable.FieldByName('Code').Text + '.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {SaveButtonClick}

{===================================================================}
procedure TLawyerCodeForm.DeleteButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to delete lawyer code ' +
                 MainTable.FieldByName('Code').Text + '?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      try
        MainTable.Delete;
      except
        SystemSupport(003, MainTable,
                      'Error deleting lawyer code ' +
                      MainTable.FieldByName('Code').Text + '.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {DeleteButtonClick}

{===================================================================}
Procedure TLawyerCodeForm.UndoButtonClick(Sender: TObject);

begin
  If (MainTable.Modified and
      (MessageDlg('Are you sure you want to discard your changes?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then MainTable.Cancel;

end;  {UndoButtonClick}

{==========================================================}
Procedure TLawyerCodeForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  Quit : Boolean;

begin
  Quit := False;

  If PrintRangeDlg.Execute
    then
      begin
        PrintLabels := (MessageDlg('Do you want to print labels?', mtConfirmation, [mbYes, mbNo], 0) = idYes);

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                              False, Quit);

          {FXX02022004-3: Use legal paper.}

        ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
        ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);

        If PrintRangeDlg.PreviewPrint
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

        If (PrintLabels and
            (MessageDlg('Please insert label paper to print labels for the letters.' + #13 +
                        'If you no longer want to print labels, select Cancel.' + #13 +
                        'Otherwise, select OK to continue.',
                        mtConfirmation, [mbOK, mbCancel], 0) = idOK) and
              ExecuteLabelOptionsDialogOld(lb_PrintLabelsBold,
                                           lb_PrintOldAndNewParcelIDs,
                                           lb_PrintSwisCodeOnParcelIDs,
                                           lb_PrintParcelIDOnly,
                                           lb_LabelType,
                                           lb_NumLinesPerLabel,
                                           lb_NumLabelsPerPage,
                                           lb_NumColumnsPerPage,
                                           lb_SingleParcelFontSize,
                                           lb_ResidentLabels,
                                           lb_LegalAddressLabels,
                                           lb_PrintParcelIDOnlyOnFirstLine,
                                           lb_LaserTopMargin,
                                           lb_PrintParcelID_PropertyClass) and
            PrintDialog.Execute)
          then
            begin
              AssignPrinterSettings(PrintDialog, LabelReportPrinter, LabelReportFiler, [ptLaser],
                                    False, Quit);

              If not Quit
                then
                  begin
                    ProgressDialog.UserLabelCaption := 'Printing Labels';

                      {Now print the report.}

                    GlblPreviewPrint := False;

                      {If they want to see it on the screen, start the preview.}

                    If PrintDialog.PrintToFile
                      then
                        begin
                          GlblPreviewPrint := True;
                          NewFileName := GetPrintFileName(Self.Caption, True);
                          LabelReportFiler.FileName := NewFileName;

                          try
                            PreviewForm := TPreviewForm.Create(self);
                            PreviewForm.FilePrinter.FileName := NewFileName;
                            PreviewForm.FilePreview.FileName := NewFileName;

                            PreviewForm.FilePreview.ZoomFactor := 100;
                            LabelReportFiler.Execute;

                            ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                            PreviewForm.ShowModal;
                          finally
                            PreviewForm.Free;
                          end;

                        end
                      else LabelReportPrinter.Execute;

                  end;  {If not Quit}

              ResetPrinter(LabelReportPrinter);

            end;  {If ((not Quit) and ...}

      end;  {If PrintRangeDlg.Execute}

end;  {PrintButtonClick}

{===================================================================}
Procedure TLawyerCodeForm.ReportPrintHeader(Sender: TObject);

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
      SetFont('Times New Roman', 11);
      Underline := True;
      Home;
      CRLF;
      PrintCenter('Lawyer Codes Listing', (PageWidth / 2));
      SetFont('Courier New', 10);
      CRLF;
      CRLF;

         {Code tables are now year independent so we do not want to print the
          tax year.}

      Print('For Codes: ');

      with PrintRangeDlg do
        If PrintAllCodes
          then Println('All')
          else
            begin
              Print(StartRange + ' to ');

              If PrintToEndOfCodes
                then Println('End')
                else Println(EndRange);

            end;  {else of If PrintAllCodes}

      SectionTop := 1.5;

        {Print column headers.}

      CRLF;
      Home;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      Bold := True;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TLawyerCodeForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  TempNameAddrArray : PNameAddrArray;
  I : Integer;

begin
  LabelList := TList.Create;
  Done := False;
  FirstTimeThrough := True;

  If PrintRangeDlg.PrintAllCodes
    then LookupTable.First
    else FindNearestOld(LookupTable, ['Code'],
                        [PrintRangeDlg.StartRange]);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else LookupTable.Next;

    with PrintRangeDlg do
      If (LookupTable.EOF or
          ((not (PrintAllCodes or PrintToEndOfCodes)) and
           (LookupTable.FieldByName('Code').Text > EndRange)))
        then Done := True;

    If not Done
      then
        with Sender as TBaseReport, LookupTable do
          begin
            ClearTabs;
            SetTab(0.4, pjLeft, 8.0, 0, BOXLINENONE, 0);   {Col 1}
            Println(#9 + ConstStr('-', 70));

            ClearTabs;
            SetTab(0.4, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Col 1}
            SetTab(3.0, pjLeft, 4.0, 0, BOXLINENONE, 0);   {Col 2}
            Print(#9 + 'Lawyer: ' + FieldByName('Code').Text);

            New(TempNameAddrArray);
            FillInNameAddrArray(FieldByName('Name1').Text,
                                FieldByName('Name2').Text,
                                FieldByName('Address1').Text,
                                FieldByName('Address2').Text,
                                FieldByName('Street').Text,
                                FieldByName('City').Text,
                                FieldByName('State').Text,
                                FieldByName('Zip').Text,
                                FieldByName('ZipPlus4').Text,
                                True, False, TempNameAddrArray^);

            For I := 1 to 6 do
              If (Deblank(TempNameAddrArray^[I]) <> '')
                then
                  begin
                    If (I > 1)
                      then Print(#9);

                    Println(#9 + TempNameAddrArray^[I]);

                  end;  {If (Deblank(NameAddrArray[I]) <> '')}

              {CHG05082012(2.28.4.21)[PAS-274]:  Add the phone number to the print.}

            Println(#9 + #9 + FieldByName('PhoneNumber').AsString);

            LabelList.Add(TempNameAddrArray);

            If (LinesLeft < 7)
              then NewPage;

          end;  {with Sender as TBaseReport do}

  until Done;

  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.4, pjLeft, 8.0, 0, BOXLINENONE, 0);   {Col 1}
      Println(#9 + ConstStr('-', 70));

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{===============================================================}
Procedure TLawyerCodeForm.LabelPrintHeader(Sender: TObject);

begin
  PrintLabelHeaderOld(Sender, lb_LabelType,
                      lb_LaserTopMargin, lb_PrintLabelsBold);
end;  {LabelPrintHeader}

{===============================================================}
Procedure TLawyerCodeForm.LabelPrint(Sender: TObject);

begin
  PrintLabelsOld(Sender, LabelList, lb_LabelType,
                 lb_PrintParcelIDOnly, lb_PrintLabelsBold,
                 lb_NumLinesPerLabel, lb_NumLabelsPerPage,
                 lb_NumColumnsPerPage, lb_SingleParcelFontSize, 0, nil,
                 False, nil, False, nil);

  FreeTList(LabelList, SizeOf(NameAddrArray));

end;  {LabelPrint}

{===================================================================}
Procedure TLawyerCodeForm.FormCloseQuery(    Sender: TObject;
                                          var CanClose: Boolean);

begin
  SaveButtonClick(Sender);
end;  {FormCloseQuery}

{===================================================================}
Procedure TLawyerCodeForm.FormClose(    Sender: TObject;
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
