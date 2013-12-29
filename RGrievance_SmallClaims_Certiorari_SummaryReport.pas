unit RGrievance_SmallClaims_Certiorari_SummaryReport;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls, wwriched;

type
  TGrievance_SmallClaims_Certiorari_SummaryReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    GrievanceTable: TwwTable;
    PrintButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ParcelTable: TTable;
    GrievanceResultsTable: TTable;
    GrievanceDispositionCodeTable: TTable;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GrievanceTypeRadioGroup: TRadioGroup;
    PrintOrderRadioGroupBox: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    CreateParcelListCheckBox: TCheckBox;
    GrievanceYearEdit: TEdit;
    DenialCodeListBox: TListBox;
    Label2: TLabel;
    DenialReasonCodesTable: TTable;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    RepresentativeCodeListBox: TListBox;
    RepresentativeCodesTable: TTable;
    DenialReasonCodesDataSource: TwwDataSource;
    DenialReasonCodesTableMainCode: TStringField;
    DenialReasonCodesTableReason: TMemoField;
    ReasonRichEdit: TDBRichEdit;
    Label4: TLabel;
    PrintLawyerNameCheckBox: TCheckBox;
    PrintGrievanceNotesCheckBox: TCheckBox;
    AssessmentTable: TTable;
    PrintToExcelCheckBox: TCheckBox;
    GrievanceDataSource: TwwDataSource;
    NotesEdit: TEdit;
    GridLineFormatCheckBox: TCheckBox;
    SortOverallGrievanceTable: TTable;
    BlankRepresentativeIsProSeCheckBox: TCheckBox;
    GrievanceExemptionsAskedTable: TwwTable;
    SmallClaimsTable: TTable;
    CertiorariTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
  private
    { Private declarations }
  public
    ReportCancelled : Boolean;

    { Public declarations }
    UnitName : String;

    IncludeResults,
    CreateParcelList,
    PrintAppearanceNumberColumn,
    PrintLawyerName : Boolean;
    SelectedDenialCodes,
    SelectedRepresentativeCodes : TStringList;

    GrievanceYear : String;
    PrintOrder, GrievanceProcessingType, GrievanceStatusType : Integer;
    BlankRepresentativeIsProSe,
    PrintGrievanceNotes, PrintToExcel, GridLineFormat : Boolean;
    ExtractFile : TextFile;

    OrigSortFileName, SpreadsheetFileName : String;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Function MeetsGrievanceStatusCriteria(    SwisSBLKey : String;
                                              GrievanceYear : String;
                                          var StatusThisGrievance : Integer) : Boolean;

    Procedure FillSortFile(var Quit : Boolean);

  end;

implementation
Uses Utilitys,  {General utilitys}
     PASUTILS, {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     Prog,
     RptDialg,
     GrievanceUtilitys,
     PRCLLIST,
     Preview;

{$R *.DFM}

const
  poGrievanceNumber = 0;
  poParcelID = 1;
  poOwnerName = 2;
  poLegalAddress = 3;
  poRepresentative = 4;
  poPropertyClass = 5;

  gstOpen = 0;
  gstClosed = 1;
  gstApproved = 2;
  gstDenied = 3;
  gstDismissed = 4;
  gstWithdrawn = 5;
  gstAll = 6;

{==============================================================}
Procedure FillOneListBox_WithDescription(ListBox : TListBox;
                                         Table : TTable;
                                         CodeField : String;
                                         DescriptionRichEdit : TDBRichEdit;
                                         DescriptionLen : Integer;
                                         SelectAll,
                                         IncludeDescription : Boolean;
                                         ProcessingType : Integer;
                                         AssessmentYear : String);

var
  FirstTimeThrough, Done : Boolean;
  TempStr : String;

begin
  FirstTimeThrough := True;
  Done := False;

  ListBox.Items.Clear;

  Table.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Table.Next;

    If Table.EOF
      then Done := True;

    If not Done
      then
        begin
          TempStr := Table.FieldByName(CodeField).Text;

          If IncludeDescription
            then TempStr := TempStr + ' - ' +
                            Take(DescriptionLen, DescriptionRichEdit.Text);

          ListBox.Items.Add(TempStr);

        end;  {If not Done}

  until Done;

  If SelectAll
    then SelectItemsInListBox(ListBox);

  ListBox.TopIndex := 1;

end;  {FillOneListBox_WithDescription}

{========================================================}
Procedure TGrievance_SmallClaims_Certiorari_SummaryReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TGrievance_SmallClaims_Certiorari_SummaryReportForm.InitializeForm;

begin
  UnitName := 'RGrievance_SmallClaims_Certiorari_SummaryReport';  {mmm}

  If GlblIsWestchesterCounty
    then
      begin
        GrievanceYear := GlblNextYear;
        GrievanceProcessingType := NextYear;
      end
    else
      begin
        GrievanceYear := GlblThisYear;
        GrievanceProcessingType := ThisYear;
      end;

  OrigSortFileName := 'sortoverallgrievancetable';

  OpenTablesForForm(Self, GrievanceProcessingType);

  GrievanceYearEdit.Text := GrievanceYear;

  FillOneListBox_WithDescription(DenialCodeListBox, DenialReasonCodesTable,
                                 'MainCode',
                                 ReasonRichEdit,
                                 35, True, True,
                                 GrievanceProcessingType, GrievanceYear);

  FillOneListBox(RepresentativeCodeListBox, RepresentativeCodesTable,
                 'Code', 'Name1', 20, True, True,
                 GrievanceProcessingType, GrievanceYear);

end;  {InitializeForm}

{===================================================================}
Procedure TGrievance_SmallClaims_Certiorari_SummaryReportForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{====================================================================}
Procedure TGrievance_SmallClaims_Certiorari_SummaryReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Overall Summary.osu', 'Overall Summary Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TGrievance_SmallClaims_Certiorari_SummaryReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Overall Summary.grs', 'Overall Summary Report');

end;  {LoadButtonClick}

{====================================================================}
Procedure TGrievance_SmallClaims_Certiorari_SummaryReportForm.FillSortFile(var Quit : Boolean);

var
  _Found, FrozenStatus,
  Done, FirstTimeThrough : Boolean;
  NumFound, GrievanceNumber,
  SmallClaims_ReductionAmount,
  SmallClaims_CertiorariCurrentValue,
  SmallClaims_CertiorariGrantedAmount : LongInt;
  SmallClaims_CertiorariType,
  Representative, Decision, SwisSBLKey, TempStr : String;
  StatusThisGrievance : Integer;

begin
  NumFound := 0;
  Done := False;
  FirstTimeThrough := True;
  GrievanceTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else GrievanceTable.Next;

    If GrievanceTable.EOF
      then Done := True;

    SwisSBLKey := GrievanceTable.FieldByName('SwisSBLKey').Text;
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumFound);
    Application.ProcessMessages;

    GrievanceNumber := GrievanceTable.FieldByName('GrievanceNumber').AsInteger;
    SetRangeOld(GrievanceResultsTable,
                ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber'],
                [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '0'],
                [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber), '9999']);

    If ((not Done) and
        MeetsGrievanceStatusCriteria(SwisSBLKey, GrievanceYear, StatusThisGrievance))
      then
        begin
          GrievanceResultsTable.First;
          NumFound := NumFound + 1;
          _Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                               [GrievanceYear, SwisSBLKey]);

          FrozenStatus := (_Found and
                          (Deblank(AssessmentTable.FieldByName('DateFrozen').Text) <> ''));

          TempStr := ExtractPlainTextFromRichText(GrievanceTable.FieldByName('Notes').AsString, False);

          with SortOverallGrievanceTable do
            try
              Insert;

              Representative := GrievanceTable.FieldByName('LawyerCode').Text;

              If (BlankRepresentativeIsProSe and
                  (Deblank(Representative) = ''))
                then Representative := 'PRO SE';

              FieldByName('GrievanceNumber').AsInteger := GrievanceTable.FieldByName('GrievanceNumber').AsInteger;
              FieldByName('TaxRollYr').Text := GrievanceTable.FieldByName('TaxRollYr').Text;
              FieldByName('SwisSBLKey').Text := GrievanceTable.FieldByName('SwisSBLKey').Text;
              FieldByName('PropertyClassCode').Text := GrievanceTable.FieldByName('PropertyClassCode').Text;
              FieldByName('CurrentName1').Text := GrievanceTable.FieldByName('CurrentName1').Text;
              FieldByName('LegalAddr').Text := GrievanceTable.FieldByName('LegalAddr').Text;
              FieldByName('LegalAddrNo').Text := GrievanceTable.FieldByName('LegalAddrNo').Text;
              FieldByName('LegalAddrInt').AsInteger := GrievanceTable.FieldByName('LegalAddrInt').AsInteger;
              FieldByName('LawyerCode').Text := Representative;
              FieldByName('Notes').Text := TempStr;
              FieldByName('CurrentLandValue').AsInteger := GrievanceTable.FieldByName('CurrentLandValue').AsInteger;
              FieldByName('CurrentTotalValue').AsInteger := GrievanceTable.FieldByName('CurrentTotalValue').AsInteger;
              FieldByName('PetitTotalValue').AsInteger := GrievanceTable.FieldByName('PetitTotalValue').AsInteger;
              FieldByName('NoHearing').AsBoolean := GrievanceTable.FieldByName('NoHearing').AsBoolean;
              FieldByName('Frozen').AsBoolean := FrozenStatus;

              If GrievanceResultsTable.EOF
                then FieldByName('Decision').Text := ''
                else FieldByName('Decision').Text := GrievanceResultsTable.FieldByName('Disposition').Text;

              Decision := FieldByName('Decision').Text;

              If (GrievanceResultsTable.EOF or
                  (Deblank(Decision) = '') or
                  (StatusThisGrievance <> gsApproved))
                then
                  begin
                    FieldByName('ReducedToAmount').AsInteger := 0;
                    FieldByName('ReductionAmount').AsInteger := 0;
                  end
                else
                  begin
                    FieldByName('ReducedToAmount').AsInteger := GrievanceResultsTable.FieldByName('TotalValue').AsInteger;
                    FieldByName('ReductionAmount').AsInteger := FieldByName('CurrentTotalValue').AsInteger -
                                                                FieldByName('ReducedToAmount').AsInteger;

                  end;  {else of If GrievanceResultsTable.EOF}

                {Now include the cert \ small claims information if there is any.}

              SmallClaims_CertiorariType := '';
              SmallClaims_CertiorariCurrentValue := 0;
              SmallClaims_CertiorariGrantedAmount := 0;

              _Found := FindKeyOld(SmallClaimsTable, ['TaxRollYr', 'SwisSBLKey'],
                                   [FieldByName('TaxRollYr').Text, FieldByName('SwisSBLKey').Text]);

              If _Found
                then
                  begin
                    SmallClaims_CertiorariType := 'S';
                    SmallClaims_CertiorariCurrentValue := SmallClaimsTable.FieldByName('CurrentTotalValue').AsInteger;
                    SmallClaims_CertiorariGrantedAmount := SmallClaimsTable.FieldByName('GrantedTotalValue').AsInteger;

                  end;  {If _Found}

                 {See if there is a certiorari for this parcel.}
                 {FXX03142012(MDT): Note that very rarely a parcel will have a small claims and a cert.
                                    In this case, the cert information supercedes the small claim information.}

              _Found := FindKeyOld(CertiorariTable, ['TaxRollYr', 'SwisSBLKey'],
                                   [FieldByName('TaxRollYr').Text, FieldByName('SwisSBLKey').Text]);

              If _Found
                then
                  begin
                    SmallClaims_CertiorariType := 'C';
                    SmallClaims_CertiorariCurrentValue := CertiorariTable.FieldByName('CurrentTotalValue').AsInteger;
                    SmallClaims_CertiorariGrantedAmount := CertiorariTable.FieldByName('GrantedTotalValue').AsInteger;

                  end;  {If _Found}

              If _Compare(SmallClaims_CertiorariGrantedAmount, 0, coGreaterThan)
                then SmallClaims_ReductionAmount := SmallClaims_CertiorariCurrentValue -
                                                    SmallClaims_CertiorariGrantedAmount
                else SmallClaims_ReductionAmount := 0;

              FieldByName('SmallClaim_Or_Cert').Text := SmallClaims_CertiorariType;
              FieldByName('SC_C_ReducedTo').AsInteger := SmallClaims_CertiorariGrantedAmount;
              FieldByName('SC_C_Reduction_Amt').AsInteger := SmallClaims_ReductionAmount;
              FieldByName('OverallReduction').AsInteger := FieldByName('CurrentTotalValue').AsInteger -
                                                           SmallClaims_CertiorariGrantedAmount;

              Post;

            except
              Cancel;
              SystemSupport(001, SortOverallGrievanceTable, 'Error inserting into sort file.',
                            UnitName, GlblErrorDlgBox);
            end;

        end;  {If not Done}

  until Done;

end;  {FillSortFile}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TGrievance_SmallClaims_Certiorari_SummaryReportForm.PrintButtonClick(Sender: TObject);

var
  SortFileName, NewFileName, TempStr : String;
  Quit, WideCarriage : Boolean;
  I, TempPos : Integer;

begin
  ReportCancelled := False;
  Quit := False;

  SelectedDenialCodes := TStringList.Create;
  SelectedRepresentativeCodes := TStringList.Create;
  BlankRepresentativeIsProSe := BlankRepresentativeIsProSeCheckBox.Checked;
  PrintToExcel := PrintToExcelCheckBox.Checked;
  PrintGrievanceNotes := PrintGrievanceNotesCheckBox.Checked;
  GridLineFormat := GridLineFormatCheckBox.Checked;

    {FXX08132007-2(2.11.3.1)[D213,967]: Grievance Year entered was not being printed in header or
                                        taken in to account as part of criteria.}

  GrievanceYear := GrievanceYearEdit.Text;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        SortOverallGrievanceTable.Close;
        SortOverallGrievanceTable.TableName := OrigSortFileName;

        SortFileName := GetSortFileName('OverallGrievanceSummary');

        SortOverallGrievanceTable.IndexName := '';
        CopySortFile(SortOverallGrievanceTable, SortFileName);
        SortOverallGrievanceTable.Close;
        SortOverallGrievanceTable.TableName := SortFileName;
        SortOverallGrievanceTable.Exclusive := True;

        try
          SortOverallGrievanceTable.Open;
        except
          Quit := True;
          SystemSupport(060, SortOverallGrievanceTable, 'Error opening sort table.',
                        UnitName, GlblErrorDlgBox);
        end;

        PrintOrder := PrintOrderRadioGroupBox.ItemIndex;

        with SortOverallGrievanceTable do
          case PrintOrder of
            poGrievanceNumber : IndexName := 'BYYEAR_GRVNUM_SBL';
            poParcelID : IndexName := 'BYYEAR_SBL_GRVNUM';
            poOwnerName : IndexName := 'BYYEAR_NAME';
            poLegalAddress : IndexName := 'BYYEAR_LEGALADDR';
            poRepresentative : IndexName := 'BYLAWYERCODE';
            poPropertyClass : IndexName := 'BYPROPERTYCLASSCODE';

          end;  {case PrintOrder of}

        CreateParcelList := CreateParcelListCheckBox.Checked;
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

          {CHG08202002-3: Allow for choice of lawyer name print.}

        PrintLawyerName := PrintLawyerNameCheckBox.Checked;

        GrievanceStatusType := GrievanceTypeRadioGroup.ItemIndex;

        For I := 0 to (DenialCodeListBox.Items.Count - 1) do
          If DenialCodeListBox.Selected[I]
            then
              begin
                TempStr := DenialCodeListBox.Items[I];
                TempPos := Pos('-', TempStr);

                SelectedDenialCodes.Add(Take((TempPos - 2), TempStr));

              end;  {If DenialCodeListBox.Selected[I])}

        For I := 0 to (RepresentativeCodeListBox.Items.Count - 1) do
          If RepresentativeCodeListBox.Selected[I]
            then
              begin
                TempStr := RepresentativeCodeListBox.Items[I];
                TempPos := Pos('-', TempStr);

                SelectedRepresentativeCodes.Add(Take((TempPos - 2), TempStr));

              end;  {If RepresentativeCodeListBox.Selected[I])}

        WideCarriage := True;

        If PrintToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

              Write(ExtractFile, 'Grv #,',
                                 'Parcel ID,',
                                 'Property Address,',
                                 'Owner,',
                                 'Class,',
                                 'Represented,',
                                 'Decision,',
                                 'Land,',
                                 'BAR Change To,',
                                 'BAR Red Amount,',
                                 'Frozen,',
                                 'S/C,',
                                 'S/C Change To,',
                                 'S/C Red Amount,',
                                 'Total Red Amt');

              If PrintGrievanceNotes
                then Writeln(ExtractFile, ',Notes')
                else Writeln(ExtractFile);

            end;  {If PrintToExcel}

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                              WideCarriage, Quit);

        If not Quit
          then
            begin
              ProgressDialog.UserLabelCaption := '';

              case PrintOrder of
                poGrievanceNumber : ProgressDialog.Start(GetRecordCount(GrievanceTable), True, True);
                else ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
              end;

                {Now print the report.}

              If not (Quit or ReportCancelled)
                then FillSortFile(Quit);

              If not (Quit or ReportCancelled)
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

                          ShowReportDialog('Grievance Summary Report.RPT', NewFileName, True);

                        end
                      else ReportPrinter.Execute;

                  end;  {If not Quit}

                {Clear the selections.}

              ProgressDialog.Finish;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);


              If CreateParcelList
                then ParcelListDialog.Show;

              If PrintToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

              SortOverallGrievanceTable.Close;

              try
                Chdir(GlblReportDir);
                OldDeleteFile(SortFileName)
              except
              end;

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

  SelectedDenialCodes.Free;
  SelectedRepresentativeCodes.Free;

end;  {PrintButtonClick}

{====================================================================}
Function TGrievance_SmallClaims_Certiorari_SummaryReportForm.MeetsGrievanceStatusCriteria(    SwisSBLKey : String;
                                                                                              GrievanceYear : String;
                                                                                          var StatusThisGrievance : Integer) : Boolean;

var
  StatusStr : String;

begin
  Result := False;

  If _Compare(GrievanceYear, GrievanceTable.FieldByName('TaxRollYr').AsString, coEqual)
    then
      begin
        StatusThisGrievance := GetGrievanceStatus(GrievanceTable, GrievanceExemptionsAskedTable,
                                                  GrievanceResultsTable, GrievanceDispositionCodeTable,
                                                  GrievanceYear, SwisSBLKey,
                                                  True, StatusStr);

        If (GrievanceStatusType = gstAll)
          then Result := True
          else
            begin
              case GrievanceStatusType of
                gstOpen : Result := (StatusThisGrievance in [gsOpen,
                                                             gsMixed]);
                gstClosed : Result := (StatusThisGrievance in [gsClosed,
                                                               gsApproved,
                                                               gsDenied,
                                                               gsDismissed]);
                gstApproved : Result := (StatusThisGrievance = gsApproved);

                gstDenied :
                  Result := ((StatusThisGrievance = gsDenied) and
                             ((DenialCodeListBox.Items.Count = 0) or
                              (SelectedDenialCodes.IndexOf(Trim(GrievanceResultsTable.FieldByName('DenialReasonCode').Text)) > -1)));

                gstWithdrawn : Result := (StatusThisGrievance = gsWithdrawn);

              end;  {case StatusThisGrievance of}

                {Check the representative.}

              If Result
                then Result := ((SelectedRepresentativeCodes.Count =
                                 RepresentativeCodeListBox.Items.Count) or  {All items selected}
                                (SelectedRepresentativeCodes.IndexOf(GrievanceTable.FieldByName('LawyerCode').Text) > -1));

            end;  {If (GrievanceStatusType = gsAll)}

      end;  {If _Compare(GrievanceYear, GrievanceTable.FieldByName('TaxRollYr').AsString, coEqual)}
      
end;  {MeetsGrievanceStatusCriteria}

{====================================================================}
Procedure TGrievance_SmallClaims_Certiorari_SummaryReportForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);

      Println('');
      Println('');

        {Print the date and page number.}

      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '         ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman',14);
      Bold := True;
      Home;
      Println('');
      Println('');
      Println('');
      PrintCenter('Overall Grievance Listing for ' + GrievanceYear, (PageWidth / 2));
      Println('');
      Println('');
      SetFont('Times New Roman',8);
      ClearTabs;

      Bold := True;
      ClearTabs;
      SetTab(0.3, pjCenter, 0.3, 5, BoxLineAll, 0);   {Grievance #}
      SetTab(0.6, pjCenter, 1.1, 5, BoxLineAll, 0);   {Parcel ID}
      SetTab(1.7, pjCenter, 1.6, 5, BoxLineAll, 0);   {Legal address}
      SetTab(3.3, pjCenter, 1.6, 5, BoxLineAll, 0);   {Owner name}
      SetTab(4.9, pjCenter, 0.3, 5, BoxLineAll, 0);   {Property Class}
      SetTab(5.2, pjCenter, 0.9, 5, BoxLineAll, 0);   {Lawyer}
      SetTab(6.1, pjCenter, 0.7, 5, BoxLineAll, 0);   {Decision code}
      SetTab(6.8, pjCenter, 0.6, 5, BoxLineAll, 0);   {Current Land}
      SetTab(7.4, pjCenter, 0.7, 5, BoxLineAll, 0);   {Current Total}
      SetTab(8.1, pjCenter, 0.9, 5, BoxLineAll, 0);   {Granted total value}
      SetTab(9.0, pjCenter, 0.7, 5, BoxLineAll, 0);   {Reduction Amount}
      SetTab(9.7, pjCenter, 0.3, 5, BoxLineAll, 0);   {Frozen}
      SetTab(10.0, pjCenter, 0.3, 5, BoxLineAll, 0);   {Small Claim / Cert}
      SetTab(10.3, pjCenter, 0.9, 5, BoxLineAll, 0);   {Small Claim / Cert Asking value}
      SetTab(11.2, pjCenter, 0.9, 5, BoxLineAll, 0);   {Granted small claim / cert value}
      SetTab(12.1, pjCenter, 0.7, 5, BoxLineAll, 0);   {Overall Amount}
      SetTab(12.8, pjCenter, 0.9, 5, BoxLineAll, 0);   {Notes}

      Println(#9 + #9 + #9 + #9 +
              #9 + 'Prp' +
              #9 + #9 + #9 +
              #9 + 'Tentative' +
              #9 + 'BAR' +
              #9 + 'BAR' +
              #9 + 'PAR' +
              #9 + 'S/C' +
              #9 + 'S/C' +
              #9 + 'S/C' +
              #9 + 'Total' +
              #9 + 'Certs');

      Println(#9 + '#' +
              #9 + 'Parcel ID' +
              #9 + 'Legal Address' +
              #9 + 'Owner' +
              #9 + 'Cls' +
              #9 + 'Represented' +
              #9 + 'Decision' +
              #9 + 'Land' +
              #9 + 'Total' +
              #9 + 'Reduced To' +
              #9 + 'Red Amount' +
              #9 + 'FRO' +
              #9 + 'Cert' +
              #9 + 'Reduced To' +
              #9 + 'Red Amount' +
              #9 + 'Red Amount' +
              #9 + 'Pending');

      Bold := False;

      Println(#9 + #9 + #9 + #9 +
              #9 + #9 + #9 + #9 +
              #9 + #9 + #9 + #9 +
              #9 + #9 + #9 + #9 + #9 + '');

(*      Println(#9 + #9 + #9 + #9 +
              #9 + #9 + #9 + #9 +
              #9 + #9 + #9 + #9 +
              #9 + #9 + #9 + #9 + #9 + ''); *)

      ClearTabs;
      SetTab(0.3, pjRight, 0.3, 5, BoxLineAll, 0);   {Grievance #}
      SetTab(0.6, pjLeft, 1.1, 5, BoxLineAll, 0);   {Parcel ID}
      SetTab(1.7, pjLeft, 1.6, 5, BoxLineAll, 0);   {Legal address}
      SetTab(3.3, pjLeft, 1.6, 5, BoxLineAll, 0);   {Owner name}
      SetTab(4.9, pjLeft, 0.3, 5, BoxLineAll, 0);   {Property Class}
      SetTab(5.2, pjLeft, 0.9, 5, BoxLineAll, 0);   {Lawyer}
      SetTab(6.1, pjLeft, 0.7, 5, BoxLineAll, 0);   {Decision code}
      SetTab(6.8, pjRight, 0.6, 5, BoxLineAll, 0);   {Current Land}
      SetTab(7.4, pjRight, 0.7, 5, BoxLineAll, 0);   {Current Total}
      SetTab(8.1, pjRight, 0.9, 5, BoxLineAll, 0);   {Granted total value}
      SetTab(9.0, pjRight, 0.7, 5, BoxLineAll, 0);   {Reduction Amount}
      SetTab(9.7, pjLeft, 0.3, 5, BoxLineAll, 0);   {Frozen}
      SetTab(10.0, pjRight, 0.3, 5, BoxLineAll, 0);   {Small Claim / Cert}
      SetTab(10.3, pjRight, 0.9, 5, BoxLineAll, 0);   {Small Claim / Cert Asking value}
      SetTab(11.2, pjRight, 0.9, 5, BoxLineAll, 0);   {Granted small claim / cert value}
      SetTab(12.1, pjRight, 0.7, 5, BoxLineAll, 0);   {Overall Amount}
      SetTab(12.8, pjLeft, 0.9, 5, BoxLineAll, 0);   {Notes}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {TextFilerPrintHeader}

{====================================================================}
Function GetLawyerInfoToDisplay(LawyerCode : String;
                                PrintLawyerName : Boolean;
                                IncludeResults : Boolean;
                                RepresentativeCodesTable : TTable) : String;

begin
  If PrintLawyerName
    then
      begin
        FindKeyOld(RepresentativeCodesTable, ['Code'],
                   [LawyerCode]);

        Result := RepresentativeCodesTable.FieldByName('Name1').Text;

        If IncludeResults
          then Result := Take(18, Result)
          else Result := Take(12, Result);
      end
    else Result := LawyerCode;

end;  {GetLawyerInfoToDisplay}

{====================================================================}
Procedure TGrievance_SmallClaims_Certiorari_SummaryReportForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit : Boolean;
  SwisSBLKey, FrozenStatusStr,
  Representative : String;
  intTotalGrievanceReduction, intTotalSmallClaimsReduction,
  intTotalCertiorariReduction : LongInt;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  intTotalGrievanceReduction := 0;
  intTotalSmallClaimsReduction := 0;
  intTotalCertiorariReduction := 0;

  SortOverallGrievanceTable.First;
  ProgressDialog.UserLabelCaption := 'Printing sort file.';

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SortOverallGrievanceTable.Next;

        If SortOverallGrievanceTable.EOF
          then Done := True;

        Application.ProcessMessages;
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SortOverallGrievanceTable.FieldByName('SwisSBLKey').Text));

        If not Done
          then
            with SortOverallGrievanceTable do
              begin
                Representative := FieldByName('LawyerCode').Text;

                If (BlankRepresentativeIsProSe and
                    (Deblank(Representative) = ''))
                  then Representative := 'PRO SE';

                FrozenStatusStr := '';
                If FieldByName('Frozen').AsBoolean
                  then FrozenStatusStr := 'X';

                Println(#9 + FieldByName('GrievanceNumber').Text +
                        #9 + ConvertSBLOnlyToDashDot(Copy(FieldByName('SwisSBLKey').Text, 7, 20)) +
                        #9 + Take(17, Trim(GetLegalAddressFromTable(SortOverallGrievanceTable))) +
                        #9 + Take(17, FieldByName('CurrentName1').Text) +
                        #9 + FieldByName('PropertyClassCode').Text +
                        #9 + Representative +
                        #9 + FieldByName('Decision').Text +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         FieldByName('CurrentLandValue').AsFloat) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         FieldByName('CurrentTotalValue').AsFloat) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         FieldByName('ReducedToAmount').AsFloat) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         FieldByName('ReductionAmount').AsFloat) +
                        #9 + FrozenStatusStr +
                        #9 + FieldByName('SmallClaim_Or_Cert').Text +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         FieldByName('SC_C_ReducedTo').AsFloat) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         FieldByName('SC_C_Reduction_Amt').AsFloat) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         FieldByName('OverallReduction').AsFloat) +
                        #9 + FieldByName('Notes').Text);

                intTotalGrievanceReduction := intTotalGrievanceReduction + FieldByName('ReductionAmount').AsInteger;

                If _Compare(FieldByName('SmallClaim_Or_Cert').Text, 'S', coEqual)
                  then intTotalSmallClaimsReduction := intTotalSmallClaimsReduction + FieldByName('SC_C_Reduction_Amt').AsInteger;

                If _Compare(FieldByName('SmallClaim_Or_Cert').Text, 'C', coEqual)
                  then intTotalCertiorariReduction := intTotalCertiorariReduction + FieldByName('SC_C_Reduction_Amt').AsInteger;

                If PrintToExcel
                  then
                    begin
                      Representative := FieldByName('LawyerCode').Text;

                      If (BlankRepresentativeIsProSe and
                          (Deblank(Representative) = ''))
                        then Representative := 'PRO SE';

                      FrozenStatusStr := '';
                      If FieldByName('Frozen').AsBoolean
                        then FrozenStatusStr := 'X';

                      Writeln(ExtractFile, FieldByName('GrievanceNumber').Text,
                                           FormatExtractField(ConvertSBLOnlyToDashDot(Copy(FieldByName('SwisSBLKey').Text, 7, 20))),
                                           FormatExtractField(GetLegalAddressFromTable(SortOverallGrievanceTable)),
                                           FormatExtractField(FieldByName('CurrentName1').Text),
                                           FormatExtractField(FieldByName('PropertyClassCode').Text),
                                           FormatExtractField(Representative),
                                           FormatExtractField(FieldByName('Decision').Text),
                                           FormatExtractField(FieldByName('CurrentLandValue').Text),
                                           FormatExtractField(FieldByName('CurrentTotalValue').Text),
                                           FormatExtractField(FormatFloat(IntegerEditDisplay,
                                                                          FieldByName('ReducedToAmount').AsFloat)),
                                           FormatExtractField(FormatFloat(IntegerEditDisplay,
                                                                          FieldByName('ReductionAmount').AsFloat)),
                                           FormatExtractField(FrozenStatusStr),
                                           FormatExtractField(FieldByName('SmallClaim_Or_Cert').Text),
                                           FormatExtractField(FormatFloat(IntegerEditDisplay,
                                                                          FieldByName('SC_C_ReducedTo').AsFloat)),
                                           FormatExtractField(FormatFloat(IntegerEditDisplay,
                                                                          FieldByName('SC_C_Reduction_Amt').AsFloat)),
                                           FormatExtractField(FormatFloat(IntegerEditDisplay,
                                                                          FieldByName('OverallReduction').AsFloat)),
                                           FormatExtractField(FieldByName('Notes').Text));

                    end;  {If PrintToExcel}

                  If (CreateParcelList and
                      (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                    then ParcelListDialog.AddOneParcel(SwisSBLKey);

                    {If there is only one line left to print, then we
                     want to go to the next page.}

                  If (LinesLeft < 5)
                    then NewPage;

              end;  {with SortOverallGrievanceTable do}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

        {FXX08132007-3(2.11.3.1)[D966]: Print totals.}

      Bold := True;
      Println('');
      Underline := True;
      ClearTabs;
      SetTab(0.3, pjLeft, 1.2, 0, BoxLineNone, 0);
      SetTab(0.6, pjRight, 1.0, 0, BoxLineNone, 0);
      Println(#9 + 'Totals for ' + GrievanceYear + ':');
      Underline := False;

      Println(#9 + 'Grievance: ' +
              #9 + FormatFloat(IntegerDisplay,
                               intTotalGrievanceReduction));
      Println(#9 + 'Small Claims: ' +
              #9 + FormatFloat(IntegerDisplay,
                               intTotalSmallClaimsReduction));
      Println(#9 + 'Certiorari: ' +
              #9 + FormatFloat(IntegerDisplay,
                               intTotalCertiorariReduction));

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TGrievance_SmallClaims_Certiorari_SummaryReportForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TGrievance_SmallClaims_Certiorari_SummaryReportForm.FormClose(    Sender: TObject;
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