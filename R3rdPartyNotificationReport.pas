unit R3rdPartyNotificationReport;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls;

type
  TThirdPartyNotificationReport = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    SwisCodeTable: TwwTable;
    ThirdPartyNotificationTable: TwwTable;
    PrintButton: TBitBtn;
    TextFiler: TTextFiler;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    TabbedNotebook1: TTabbedNotebook;
    CreateParcelListCheckBox: TCheckBox;
    SBLGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    StartSBLEdit: TEdit;
    EndSBLEdit: TEdit;
    AllSBLCheckBox: TCheckBox;
    ToEndOfSBLCheckBox: TCheckBox;
    Label6: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    Label21: TLabel;
    SchoolCodeTable: TTable;
    ParcelTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TextReportBeforePrint(Sender: TObject);
    procedure TextReportPrintHeader(Sender: TObject);
    procedure SBLEditExit(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure AllSBLCheckBoxClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure TextReportPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    ReportCancelled : Boolean;

    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    CreateParcelList : Boolean;
    StartingSwisSBL,
    EndingSwisSBL : String;
    PrintAllParcelIDs,
    PrintToEndOfParcelIDs : Boolean;
    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Function ValidSelectionInformation : Boolean;
    {Have they filled in enough information in the selection boxes to print?}

    Function RecordInRange(SwisSBLKey : String;
                           SchoolCode : String) : Boolean;
    {Does this record fall within the set of parameters that they selected?}


  end;

implementation
Uses Utilitys,  {General utilitys}
     PASUTILS, {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     Prog,
     RptDialg,
     PRCLLIST,
     Preview;

{$R *.DFM}

{========================================================}
Procedure TThirdPartyNotificationReport.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TThirdPartyNotificationReport.InitializeForm;

begin
  UnitName := 'R3rdPartyNotificationReport';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

    {CHG12291999-1: Add swis \ school selection to audit reports.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType, GetTaxRlYr);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, GlblProcessingType, GetTaxRlYr);

end;  {InitializeForm}

{===================================================================}
Procedure TThirdPartyNotificationReport.FormKeyPress(    Sender: TObject;
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
Function TThirdPartyNotificationReport.RecordInRange(SwisSBLKey : String;
                                                     SchoolCode : String) : Boolean;

{Does this record fall within the set of parameters that they selected?}

var
  SwisCode : String;

begin
  Result := True;
  SwisCode := Take(6, SwisSBLKey);

    {Now see if they are in the notes code range (if any) specified.}

  If not AllSBLCheckBox.Checked
    then
      begin
        If (Take(26, SwisSBLKey) < Take(26, StartingSWISSBL))
          then Result := False;

        If ((not ToEndOfSBLCheckBox.Checked) and
            (Take(26, SwisSBLKey) > Take(26, EndingSWISSBL)))
          then Result := False;

      end;  {else of If AllNotesCodesCheckBox.Checked}

  If (Result and
      ((SelectedSwisCodes.IndexOf(SwisCode) = -1) or
       (SelectedSchoolCodes.IndexOf(SchoolCode) = -1)))
    then Result := False;

end;  {RecordInRange}

{=====================================================================}
Function TThirdPartyNotificationReport.ValidSelectionInformation : Boolean;

{Have they filled in enough information in the selection boxes to print?}

begin
  Result := True;

  If Result
    then
      If ((Deblank(StartSBLEdit.Text) <> '') or
       (Deblank(EndSBLEdit.Text) <> '') or
       AllSBLCheckBox.Checked or
       ToEndofSBLCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofSBLCheckBox.Checked or
                 (Deblank(EndSBLEdit.Text) <> '')) and
                (Deblank(StartSBLEdit.Text) = ''))
              then
                begin
                  MessageDlg('Please select a starting SBL or chose all SBL"s.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((Deblank(StartSBLEdit.Text) <> '') and
                ((Deblank(EndSBLEdit.Text) = '') and
                 (not ToEndofSBLCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending SBL or chose to print to the end of the SBL"s on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllSBLCheckBox.Checked := True;

end;  {ValidSelectionInformation}

{===================================================================}
Procedure TThirdPartyNotificationReport.SBLEditExit(Sender: TObject);

var
  SwisSBLKey, SwisSBLEntry : String;
  ValidEntry : Boolean;

begin
  SwisSBLEntry := UpcaseStr(StartSBLEdit.Text);

  If (Deblank(SwisSBLEntry) <> '')
    then
      begin
        SwisSBLKey := ConvertSwisDashDotToSwisSBL(SwisSBLEntry,
                                                  SwisCodeTable, ValidEntry);

        If not ValidEntry
          then
            begin
              MessageDlg('Invalid SBL. Please Re-Enter.',
                         mtError, [mbOK], 0);
              TEdit(Sender).SetFocus;
              Abort;
           end;

      end;  {If (Deblank(SwisSBLEntry) <> '')}

end;  {SBLEditExit}

{===========================================================================}
Procedure TThirdPartyNotificationReport.AllSBLCheckBoxClick(Sender: TObject);

begin
 If AllSBLCheckBox.Checked
    then
      begin
        ToEndofSBLCheckBox.Checked := False;
        ToEndofSBLCheckBox.Enabled := False;
        StartSBLEdit.Text := '';
        StartSBLEdit.Enabled := False;
        StartSBLEdit.Color := clBtnFace;
        EndSBLEdit.Text := '';
        EndSBLEdit.Enabled := False;
        EndSBLEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(SBLGroupBox);

end;  {AllSBLCheckBoxClick}

{====================================================================}
Procedure TThirdPartyNotificationReport.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Notify.3rd', 'Third Party Notification Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TThirdPartyNotificationReport.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Notify.3rd', 'Third Party Notification Report');

end;  {LoadButtonClick}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TThirdPartyNotificationReport.PrintButtonClick(Sender: TObject);

var
  TextFileName, NewFileName : String;
  Quit : Boolean;
  I : Integer;

begin
  ReportCancelled := False;
  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If (ValidSelectionInformation and
      PrintDialog.Execute)
    then
      begin
        CreateParcelList := CreateParcelListCheckBox.Checked;
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

        SelectedSwisCodes := TStringList.Create;
        SelectedSchoolCodes := TStringList.Create;

          {CHG12291999-1: Allow for school \ swis selection.}

        SelectedSwisCodes.Clear;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        SelectedSchoolCodes.Clear;

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

          {FXX10071999-1: To solve the problem of printing to the high speed,
                          we need to set the font to a TrueType even though it
                          doesn't matter in the actual printing.  The reason for this
                          is that without setting it, the default font is System for
                          the Generic printer which has a baseline descent of 0.5
                          which messes up printing to a text file.  We needed a font
                          with no descent.}

        TextFiler.SetFont('Courier New', 10);

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

        If not Quit
          then
            begin
              ProgressDialog.UserLabelCaption := '';
              ProgressDialog.Start(GetRecordCount(ThirdPartyNotificationTable), True, True);

                {Now print the report.}

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

                    TextFileName := GetPrintFileName(Self.Caption, True);
                    TextFiler.FileName := TextFileName;

                      {FXX01211998-1: Need to set the LastPage property so that
                                      long rolls aren't a problem.}

                    TextFiler.LastPage := 30000;

                    TextFiler.Execute;
                    ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

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

                            {Delete the report printer file.}

                          try
                            Chdir(GlblReportDir);
                            OldDeleteFile(NewFileName);
                          except
                          end;

                        end
                      else ReportPrinter.Execute;

                      {CHG01182000-3: Allow them to choose a different name or copy right away.}

                    ShowReportDialog('3RDPARTY.RPT', TextFiler.FileName, True);

                  end;  {If not Quit}

                {Clear the selections.}

              ProgressDialog.Finish;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);


              If CreateParcelList
                then ParcelListDialog.Show;

            end;  {If not Quit}

        SelectedSwisCodes.Free;
        SelectedSchoolCodes.Free;

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{====================================================================}
Procedure TThirdPartyNotificationReport.TextReportBeforePrint(Sender: TObject);

var
  ValidEntry : Boolean;

begin
  PrintAllParcelIDs := False;
  PrintToEndOfParcelIDs := False;

  If AllSBLCheckBox.Checked
    then PrintAllParcelIDs := True
    else
      begin
        StartingSwisSBL := ConvertSwisDashDotToSwisSBL(StartSBLEdit.Text,
                                                       SwisCodeTable, ValidEntry);

        If ToEndOfSBLCheckBox.Checked
          then
            begin
              PrintToEndOfParcelIDs := True;
              EndingSwisSBL := ConstStr('Z', 26);
            end
          else EndingSwisSBL := ConvertSwisDashDotToSwisSBL(EndSBLEdit.Text,
                                                            SwisCodeTable, ValidEntry);

      end;  {If not AllSBLCheckBox.Checked}

  If not PrintAllParcelIDs
    then SetRangeOld(ThirdPartyNotificationTable,
                     ['SwisSBLKey', 'NoticeNumber'],
                     [StartingSwisSBL, '0'],
                     [EndingSwisSBL, '999']);

end;  {ReportFilerBeforePrint}

{====================================================================}
Procedure TThirdPartyNotificationReport.TextReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);

        {Print the date and page number.}

      Println(#9 + UpcaseStr(Take(26, GetMunicipalityName)) +
              Center('Third Party Notice Report', 27) +
              RightJustify('Page: ' + IntToStr(CurrentPage), 27));

      Println(#9 + RightJustify('Date: ' + DateToStr(Date) +
                           '  Time: ' + FormatDateTime(TimeFormat, Now), 78));

      ClearTabs;
      SetTab(0.4, pjLeft, 8, 0, BOXLINENONE, 0);   {Index}

        {Print the selection information.}

      Print(#9 + 'For Parcel IDs: ');

      If AllSBLCheckBox.Checked
        then Println(' All')
        else
          begin
            Print(' ' + RTrim(StartSBlEdit.Text) + ' to ');

            If ToEndOfSBLCheckBox.Checked
              then Println(' End')
              else Println(' ' + EndSBLEdit.Text);

          end;  {else of If AllSBLSCheckBox.Checked}

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerPrintHeader}

{====================================================================}
Procedure TThirdPartyNotificationReport.TextReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit : Boolean;
  SwisSBLKey : String;
  SBLRec : SBLRecord;
  TempNameAddrArray : NameAddrArray;
  I : Integer;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else ThirdPartyNotificationTable.Next;

        If ThirdPartyNotificationTable.EOF
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              Application.ProcessMessages;

              {Update the progress panel.}

              with ThirdPartyNotificationTable do
                ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));

              SBLRec := ExtractSwisSBLFromSwisSBLKey(ThirdPartyNotificationTable.FieldByName('SwisSBLKey').Text);

              with SBLRec do
                FindKeyOld(ParcelTable,
                           ['TaxRollYr', 'SwisCode', 'Section',
                            'Subsection', 'Block', 'Lot',
                            'Sublot', 'Suffix'],
                           [GetTaxRlYr, SwisCode, Section, Subsection,
                            Block, Lot, Sublot, Suffix]);

              with ThirdPartyNotificationTable do
                If RecordInRange(FieldByName('SwisSBLKey').Text,
                                 ParcelTable.FieldByName('SchoolCode').Text)
                  then
                    begin
                      ClearTabs;
                      SetTab(0.4, pjLeft, 3.0, 0, BOXLINENONE, 0);   {Col 1}
                      Println(#9 + ConstStr('-', 10) + '  ' +
                                   ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) + '  ' +
                                   ConstStr('-', 40));

                      Println(#9 + '  3rd Party Address:');
                      Println('');
                      ClearTabs;
                      SetTab(0.4, pjLeft, 3.0, 0, BOXLINENONE, 0);   {Col 1}

                      FillInNameAddrArray(FieldByName('Name1').Text,
                                          FieldByName('Name2').Text,
                                          FieldByName('Address1').Text,
                                          FieldByName('Address2').Text,
                                          FieldByName('Street').Text,
                                          FieldByName('City').Text,
                                          FieldByName('State').Text,
                                          FieldByName('Zip').Text,
                                          FieldByName('ZipPlus4').Text,
                                          True, False, TempNameAddrArray);

                      For I := 1 to 6 do
                        If (Deblank(TempNameAddrArray[I]) <> '')
                          then Println(#9 + TempNameAddrArray[I]);

                      Println('');

                      If (CreateParcelList and
                          (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                        then ParcelListDialog.AddOneParcel(SwisSBLKey);

                    end;  {with ThirdPartyNotificationTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 10)
                then NewPage;

              SwisSBLKey := ThirdPartyNotificationTable.FieldByName('SwisSBLKey').Text;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrint}

{===========================================================}
Procedure TThirdPartyNotificationReport.ReportPrint(Sender: TObject);

{FXX02181999-3: Changed the audit trail so it could go to dot matrix.}

var
  ReportTextFile : TextFile;

begin
  AssignFile(ReportTextFile, TextFiler.FileName);
  Reset(ReportTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, ReportTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(ReportTextFile);

end;  {ReportPrint}

{===============================================================}
Procedure TThirdPartyNotificationReport.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TThirdPartyNotificationReport.FormClose(    Sender: TObject;
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