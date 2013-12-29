unit rpSales_And_RemovedExemptions;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls;

type
  TReportSalesAndRemovedExemptionsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    SwisCodeTable: TwwTable;
    PrintButton: TBitBtn;
    TextFiler: TTextFiler;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    TabbedNotebook1: TTabbedNotebook;
    IndexRadioGroup: TRadioGroup;
    SBLGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    StartSBLEdit: TEdit;
    EndSBLEdit: TEdit;
    AllSBLCheckBox: TCheckBox;
    ToEndOfSBLCheckBox: TCheckBox;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    Label6: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    Label21: TLabel;
    SchoolCodeTable: TTable;
    ParcelTable: TTable;
    SalesTable: TTable;
    RemovedExemptionsTable: TTable;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    IncludeRemovedSTARExemptionsCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    Label2: TLabel;
    SeperatorLineCheckBox: TCheckBox;
    Label3: TLabel;
    OnlyShowSalesWithRemovedExemptionsCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TextReportBeforePrint(Sender: TObject);
    procedure TextReportPrintHeader(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure DateGroupBoxClick(Sender: TObject);
    procedure AllSBLCheckBoxClick(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
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

    OnlyShowSalesWithRemovedExemptions,
    PrintSeperatorLine,
    PrintSTARRemovedExemptions,
    PrintAllDates, PrintToEndOfDates,
    CreateParcelList : Boolean;

    StartingSwisSBL,
    EndingSwisSBL : String;
    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;
    StartingDate,
    EndingDate : TDateTime;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Function ValidSelectionInformation : Boolean;
    {Have they filled in enough information in the selection boxes to print?}

    Procedure GetRemovedExemptions(RemovedExemptionsTable : TTable;
                                   SwisSBLKey : String;
                                   RemovedExemptionsList : TStringList;
                                   RemovedExemptionsDateList : TStringList);

    Function RecordInRange(TempDate : TDateTime;
                           SwisSBLKey : String;
                           SchoolCode : String) : Boolean;
    {Does this record fall within the set of parameters that they selected?}


  end;

implementation
Uses Utilitys,  {General utilitys}
     PASUTILS, UTILEXSD,   {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     Prog,
     RptDialg,
     PRCLLIST,
     Preview;

{$R *.DFM}

{========================================================}
Procedure TReportSalesAndRemovedExemptionsForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TReportSalesAndRemovedExemptionsForm.InitializeForm;

begin
  UnitName := 'rpSales_And_RemovedExemptions.PAS';  {mmm}

  OpenTablesForForm(Self, NextYear);

    {CHG12291999-1: Add swis \ school selection to audit reports.}

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, GlblProcessingType, GetTaxRlYr);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, GlblProcessingType, GetTaxRlYr);

end;  {InitializeForm}

{===================================================================}
Procedure TReportSalesAndRemovedExemptionsForm.FormKeyPress(    Sender: TObject;
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
Function TReportSalesAndRemovedExemptionsForm.RecordInRange(TempDate : TDateTime;
                                                            SwisSBLKey : String;
                                                            SchoolCode : String) : Boolean;

{Does this record fall within the set of parameters that they selected?}
{CHG01211998-3: Allow tracking of EX, SD deletions.}

var
  FieldName : String;
  SwisCode : String;

begin
  Result := True;
  SwisCode := Take(6, SwisSBLKey);

    {Now see if they are in the date range (if any) specified.}

  If not AllDatesCheckBox.Checked
    then
      begin
      FieldName := 'Date';

        If (TempDate < StrToDate(StartDateEdit.Text))
          then Result := False;

        If ((not ToEndOfDatesCheckBox.Checked) and
            (TempDate > StrToDate(EndDateEdit.Text)))
          then Result := False;

      end;  {else of If AllDatesCheckBox.Checked}

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
Function TReportSalesAndRemovedExemptionsForm.ValidSelectionInformation : Boolean;

{Have they filled in enough information in the selection boxes to print?}

begin
  Result := True;

    {Now make sure that the selections that they chose make sense. Note that if they do not
     select anything in a box, all is assumed, so we will check it.}

  If Result
    then
      If ((StartDateEdit.Text <> '  /  /    ') or
           (EndDateEdit.Text <> '  /  /    ') or
           AllDatesCheckBox.Checked or
           ToEndofDatesCheckBox.Checked)
        then
          begin
              {Make sure if they clicked to end of range that they put in a start range.}

            If ((ToEndofDatesCheckBox.Checked or
                 (EndDateEdit.Text <> '  /  /    ')) and
                (StartDateEdit.Text = '  /  /    '))
              then
                begin
                  MessageDlg('Please select a starting date or chose all dates.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((StartDateEdit.Text <> '  /  /    ') and
                ((EndDateEdit.Text = '  /  /    ') and
                 (not ToEndofDatesCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending date or chose to print to the end of the dates on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllDatesCheckBox.Checked := True;

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
                  MessageDlg('Please select a starting parcel ID or chose all parcel ID"s.', mtError, [mbOK], 0);
                  Result := False;
                end;

              {Make sure that if they entered a start range, there is an end range.}

            If ((Deblank(StartSBLEdit.Text) <> '') and
                ((Deblank(EndSBLEdit.Text) = '') and
                 (not ToEndofSBLCheckBox.Checked)))
              then
                begin
                  MessageDlg('Please select an ending parcel ID or chose to print to the end of the parcel ID"s on file.',
                             mtError, [mbOK], 0);
                  Result := False;
                end;

          end
        else AllSBLCheckBox.Checked := True;

end;  {ValidSelectionInformation}

{===============================================================}
Procedure TReportSalesAndRemovedExemptionsForm.DateGroupBoxClick(Sender: TObject);

begin
 If AllDatesCheckBox.Checked
    then
      begin
        ToEndofDatesCheckBox.Checked := False;
        ToEndofDatesCheckBox.Enabled := False;
        StartDateEdit.Text := '';
        StartDateEdit.Enabled := False;
        StartDateEdit.Color := clBtnFace;
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(DateGroupBox);

end;

{===========================================================================}
Procedure TReportSalesAndRemovedExemptionsForm.AllSBLCheckBoxClick(Sender: TObject);

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

end;

{==========================================================================}
Procedure TReportSalesAndRemovedExemptionsForm.AllDatesCheckBoxClick(Sender: TObject);

begin
 If AllDatesCheckBox.Checked
    then
      begin
        ToEndofDatesCheckBox.Checked := False;
        ToEndofDatesCheckBox.Enabled := False;
        StartDateEdit.Text := '';
        StartDateEdit.Enabled := False;
        StartDateEdit.Color := clBtnFace;
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(DateGroupBox);

end;

{====================================================================}
Procedure TReportSalesAndRemovedExemptionsForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Sales And Removed Exemptions.REX', 'Sales And Removed Exemptions Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TReportSalesAndRemovedExemptionsForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Sales And Removed Exemptions.REX', 'Sales And Removed Exemptions Report');

end;  {LoadButtonClick}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TReportSalesAndRemovedExemptionsForm.PrintButtonClick(Sender: TObject);

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

        PrintSeperatorLine := SeperatorLineCheckBox.Checked;
        PrintSTARRemovedExemptions := IncludeRemovedSTARExemptionsCheckBox.Checked;

        PrintAllDates := AllDatesCheckBox.Checked;
        PrintToEndOfDates := ToEndofDatesCheckBox.Checked;

        OnlyShowSalesWithRemovedExemptions := OnlyShowSalesWithRemovedExemptionsCheckBox.Checked;

        try
          StartingDate := StrToDate(StartDateEdit.Text);
        except
        end;

        try
          EndingDate := StrToDate(EndDateEdit.Text);
        except
        end;

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

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

        If not Quit
          then
            begin
              ProgressDialog.UserLabelCaption := '';
              ProgressDialog.Start(GetRecordCount(SalesTable), True, True);

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

                    ShowReportDialog('SLRMVDEX.RPT', TextFiler.FileName, True);

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
Procedure TReportSalesAndRemovedExemptionsForm.GetRemovedExemptions(RemovedExemptionsTable : TTable;
                                                                    SwisSBLKey : String;
                                                                    RemovedExemptionsList : TStringList;
                                                                    RemovedExemptionsDateList : TStringList);

var
  Done, FirstTimeThrough : Boolean;
  I, J : Integer;

begin
  SetRangeOld(RemovedExemptionsTable, ['SwisSBLKey'],
              [SwisSBLKey], [SwisSBLKey]);
  RemovedExemptionsTable.First;

  Done := False;
  FirstTimeThrough := True;
  RemovedExemptionsList.Clear;
  RemovedExemptionsDateList.Clear;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else RemovedExemptionsTable.Next;

    If RemovedExemptionsTable.EOF
      then Done := True;

    with RemovedExemptionsTable do
      If ((not Done) and
          FieldByName('RemovedDueToSale').AsBoolean and
          (PrintSTARRemovedExemptions or
           (not ExemptionIsSTAR(FieldByName('ExemptionCode').Text))) and
          InDateRange(FieldByName('ActualDateRemoved').AsDateTime,
                      PrintAllDates, PrintToEndOfDates,
                      StartingDate, EndingDate))
        then
          begin
            RemovedExemptionsList.Add(FieldByName('ExemptionCode').Text);
            RemovedExemptionsDateList.Add(FieldByName('EffectiveDateRemoved').Text);
          end;

  until Done;

    {Remove duplicates.}

  For I := 0 to (RemovedExemptionsList.Count - 1) do
    For J := (RemovedExemptionsList.Count - 1) downto (I + 1) do
      If ((RemovedExemptionsList[I] = RemovedExemptionsList[J]) and
          (RemovedExemptionsDateList[I] = RemovedExemptionsDateList[J]))
        then
          begin
            RemovedExemptionsList.Delete(J);
            RemovedExemptionsDateList.Delete(J);
          end;

end;  {GetRemovedExemptions}

{====================================================================}
Procedure TReportSalesAndRemovedExemptionsForm.TextReportBeforePrint(Sender: TObject);

var
  ValidEntry : Boolean;

begin
  If not AllSBLCheckBox.Checked
    then
      begin
        StartingSwisSBL := ConvertSwisDashDotToSwisSBL(StartSBLEdit.Text,
                                                       SwisCodeTable, ValidEntry);

        If ToEndOfSBLCheckBox.Checked
          then EndingSwisSBL := TAke(26,'ZZZZZZZZZZZZZZZZZZZZZZZZZZ')
          else EndingSwisSBL := ConvertSwisDashDotToSwisSBL(EndSBLEdit.Text,
                                                            SwisCodeTable, ValidEntry);
      end;

end;  {ReportFilerBeforePrint}

{====================================================================}
Procedure TReportSalesAndRemovedExemptionsForm.TextReportPrintHeader(Sender: TObject);

var
  TempStr : String;

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 13.8, 0, BoxLineNone, 0);

        {Print the date and page number.}

      Println(#9 + UpcaseStr(Take(41, GetMunicipalityName)) +
              Center('Sales And Removed Exemptions Report', 41) +
              RightJustify('Page: ' + IntToStr(CurrentPage), 41));

      Println(#9 + RightJustify('Date: ' + DateToStr(Date) +
                           '  Time: ' + FormatDateTime(TimeFormat, Now), 132));

      ClearTabs;
      SetTab(0.3, pjLeft, 13.8, 0, BOXLINENONE, 0);   {Index}

        {Print the selection information.}

      Print(#9 + 'Index:  ');
      case IndexRadioGroup.ItemIndex of
        0 : Println(' SBL');
        1 : Println(' Date');
      end;  {case IndexRadioGroup of}

      Print(#9 + 'For Dates: ');
      If AllDatesCheckBox.Checked
        then Println(' All')
        else
          begin
            If ToEndOfDatesCheckBox.Checked
              then TempStr := 'Current Date'
              else TempStr := EndDateEdit.Text;

            Println(' ' + StartDateEdit.Text + ' to ' + TempStr);

          end;  {else of If AllDatesCheckBox.Checked}

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

      ClearTabs;
      SetTab(0.3, pjCenter, 2.0, 0, BOXLINENONE, 0);   {Old Owner}
      SetTab(2.6, pjCenter, 2.5, 0, BOXLINENONE, 0);   {New Owner}
      SetTab(5.4, pjCenter, 2.5, 0, BOXLINENONE, 0);   {New Address}
      SetTab(8.2, pjCenter, 2.0, 0, BOXLINENONE, 0);   {Parcel ID \ Location}
      SetTab(10.4, pjLeft, 1.0, 0, BOXLINENONE, 0);   {Deed Date}
      SetTab(11.5, pjLeft, 1.0, 0, BOXLINENONE, 0);   {Exemption}

      Println(#9 + #9 + #9 +
              #9 + 'Parcel ID');

      Println(#9 + 'Old Owner' +
              #9 + 'New Owner' +
              #9 + 'Address' +
              #9 + 'Location' +
              #9 + 'Sale Date' +
              #9 + 'Ex Code / Eff Dt');

      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Old Owner}
      SetTab(2.6, pjLeft, 2.5, 0, BOXLINENONE, 0);   {New Owner}
      SetTab(5.4, pjLeft, 2.5, 0, BOXLINENONE, 0);   {New Address}
      SetTab(8.2, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Parcel ID \ Location}
      SetTab(10.4, pjLeft, 1.0, 0, BOXLINENONE, 0);   {Deed Date}
      SetTab(11.6, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Exemption}

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerPrintHeader}

{====================================================================}
Procedure TReportSalesAndRemovedExemptionsForm.TextReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough,
  Quit, FirstTimeThroughSales, DoneSales,
  SaleFound, PrintThisParcel : Boolean;
  SwisSBLKey : String;
  NAddrArray : NameAddrArray;
  RemovedExemptionsList, RemovedExemptionsDateList : TStringList;
  I, StartingIndex,
  NameAddrArrayIndex, RemovedExemptionsIndex : Integer;
  NumFound : LongInt;
  OldOwner, DeedDate : String;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  NumFound := 0;
  RemovedExemptionsList := TStringList.Create;
  RemovedExemptionsDateList := TStringList.Create;

    {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

(*  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SalesTable.Next;

          {Use the actual date entered rather than the sale date since the
           sale can take between 2-10 months to arrive at their office.}

        TempDate := SalesTable.FieldByName('DateEntered').AsDateTime;

        If (SalesTable.EOF or
            ((IndexRadioGroup.ItemIndex = 1) and
             (not AllDatesCheckBox.Checked) and
             (not ToEndofDatesCheckBox.Checked) and
             (TempDate > StrToDate(EndDateEdit.Text))))
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              Application.ProcessMessages;

              SwisSBLKey := SalesTable.FieldByName('SwisSBLKey').Text;

              {Update the progress panel.}

              with SalesTable do
                case IndexRadioGroup.ItemIndex of
                  0 : ProgressDialog.Update(Self,
                                            ConvertSwisSBLToDashDot(SwisSBLKey));
                  1 : ProgressDialog.Update(Self, FieldByName('Date').Text);

                end;  {case IndexRadioGroup.ItemIndex of}

              ProgressDialog.UserLabelCaption := 'Number Found = ' + IntToStr(NumFound);
              SBLRec := ExtractSwisSBLFromSwisSBLKey(SalesTable.FieldByName('SwisSBLKey').Text);

              with SBLRec do
                FindKeyOld(ParcelTable,
                           ['TaxRollYr', 'SwisCode', 'Section',
                            'Subsection', 'Block', 'Lot',
                            'Sublot', 'Suffix'],
                           [GlblNextYear, SwisCode, Section, Subsection,
                            Block, Lot, Sublot, Suffix]);

              with SalesTable do
                If RecordInRange(FieldByName('DateEntered').AsDateTime,
                                 FieldByName('SwisSBLKey').Text,
                                 ParcelTable.FieldByName('SchoolCode').Text)
                  then
                    begin
                      RemovedExemptionsTable.CancelRange;
                      SetRangeOld(RemovedExemptionsTable, ['SwisSBLKey'],
                                  [SwisSBLKey], [SwisSBLKey]);

                      If ((not OnlyShowSalesWithRemovedExemptions) or
                          (OnlyShowSalesWithRemovedExemptions and
                           (not RemovedExemptionsTable.EOF)))
                        then
                          begin
                            NumFound := NumFound + 1;

                            If PrintSeperatorLine
                              then Println(#9 + StringOfChar('-', 130));

                            DoneRemovedExemptions := False;
                            FirstTimeThroughRemovedExemptions := True;
                            RemovedExemptionsList.Clear;

                            repeat
                              If FirstTimeThroughRemovedExemptions
                                then FirstTimeThroughRemovedExemptions := False
                                else RemovedExemptionsTable.Next;

                              If RemovedExemptionsTable.EOF
                                then DoneRemovedExemptions := True;

                              with RemovedExemptionsTable do
                                If ((not DoneRemovedExemptions) and
                                    FieldByName('RemovedDueToSale').AsBoolean and
                                    (PrintSTARRemovedExemptions or
                                     (not ExemptionIsSTAR(FieldByName('ExemptionCode').Text))) and
                                    InDateRange(FieldByName('ActualDateRemoved').AsDateTime,
                                                PrintAllDates, PrintToEndOfDates,
                                                StartingDate, EndingDate))
                                  then RemovedExemptionsList.Add(FieldByName('ExemptionCode').Text);

                            until DoneRemovedExemptions;

                              {Get the current name and address, but remove the
                               name 1 and 2 since those are printed in the 2nd column.}

                            GetNameAddress(ParcelTable, NAddrArray);

                            StartingIndex := 2;
                            If (Take(30, NAddrArray[2]) =
                                Take(30, ParcelTable.FieldByName('Name2').Text))
                              then StartingIndex := 3;

                            For I := 1 to 6 do
                              If ((I + (StartingIndex - 1)) > 6)
                                then NAddrArray[I] := ''
                                else NAddrArray[I] := NAddrArray[I + (StartingIndex - 1)];

                              {Now print the parcel.}
                              {FXX07252001-1: Print the sale date instead of the deed date
                                              as per Laura.}

                            Print(#9 + Take(20, SalesTable.FieldByName('OldOwnerName').Text) +
                                  #9 + ParcelTable.FieldByName('Name1').Text +
                                  #9 + Take(25, NAddrArray[1]) +
                                  #9 + ConvertSwisSBLToDashDotNoSwis(SwisSBLKey) +
                                  #9 + SalesTable.FieldByName('SaleDate').Text);

                            If (RemovedExemptionsList.Count = 0)
                              then Println(#9 + 'N')
                              else Println(#9 + RemovedExemptionsList[0]);

                            Print(#9 +
                                  #9 + ParcelTable.FieldByName('Name2').Text +
                                  #9 + Take(25, NAddrArray[2]) +
                                  #9 + GetLegalAddressFromTable(ParcelTable));

                            If (RemovedExemptionsList.Count > 1)
                              then Println(#9 + #9 + RemovedExemptionsList[1])
                              else Println('');

                              {Now print the rest of the address or exemptions.}

                            RemovedExemptionsIndex := 2;
                            NameAddrArrayIndex := 3;

                            while (((NameAddrArrayIndex <= 6) and
                                    (Deblank(NAddrArray[NameAddrArrayIndex]) <> '')) or
                                   (RemovedExemptionsList.Count > RemovedExemptionsIndex)) do
                              begin
                                If ((NameAddrArrayIndex <= 6) and
                                    (Deblank(NAddrArray[NameAddrArrayIndex]) <> ''))
                                  then Print(#9 + #9 +
                                             #9 + Take(25, NAddrArray[NameAddrArrayIndex]))
                                  else Print(#9 + #9 + #9);

                                If (RemovedExemptionsList.Count > RemovedExemptionsIndex)
                                  then Print(#9 +
                                             #9 + RemovedExemptionsList[RemovedExemptionsIndex]);

                                RemovedExemptionsIndex := RemovedExemptionsIndex + 1;
                                NameAddrArrayIndex := NameAddrArrayIndex + 1;

                                Println('');

                              end;  {while (((NameAddrArrayIndex <= 6) and ...}

                            If (CreateParcelList and
                                (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                              then ParcelListDialog.AddOneParcel(SwisSBLKey);

                          end;  {If ((not OnlyShowSalesWithRemovedExemptions) or ...}

                    end;  {with SalesTable do}

                {If there is only one line left to print, then we
                 want to go to the next page.}

              If (LinesLeft < 8)
                then
                  begin
                    If PrintSeperatorLine
                      then Println(#9 + StringOfChar('-', 130));
                    NewPage;
                  end;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);*)

  case IndexRadioGroup.ItemIndex of
    0 : ParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
    1 : ParcelTable.IndexName := 'BYYEAR_LEGALADDR_LEGALADDRINT';
    2 : ParcelTable.IndexName := 'BYYEAR_NAME';
  end;  {case IndexRadioGroup.ItemIndex of}

  ParcelTable.First;

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else ParcelTable.Next;

          {Use the actual date entered rather than the sale date since the
           sale can take between 2-10 months to arrive at their office.}

        If ParcelTable.EOF
          then Done := True;

          {Print the present record.}

        If not (Done or Quit)
          then
            begin
              Application.ProcessMessages;

              SwisSBLKey := ExtractSSKey(ParcelTable);

              with ParcelTable do
                case IndexRadioGroup.ItemIndex of
                  0 : ProgressDialog.Update(Self,
                                            ConvertSwisSBLToDashDot(SwisSBLKey));
                  1 : ProgressDialog.Update(Self, FieldByName('Name1').Text);
                  2 : ProgressDialog.Update(Self, GetLegalAddressFromTable(ParcelTable));

                end;  {case IndexRadioGroup.ItemIndex of}

              ProgressDialog.UserLabelCaption := 'Number Found = ' + IntToStr(NumFound);

              SetRangeOld(SalesTable, ['SwisSBLKey'],
                          [SwisSBLKey], [SwisSBLKey]);
              SalesTable.First;

              GetRemovedExemptions(RemovedExemptionsTable, SwisSBLKey,
                                   RemovedExemptionsList,
                                   RemovedExemptionsDateList);

              SaleFound := False;
              FirstTimeThroughSales := True;
              DoneSales := False;
              PrintThisParcel := False;

              repeat
                If FirstTimeThroughSales
                  then FirstTimeThroughSales := False
                  else SalesTable.Next;

                If SalesTable.EOF
                  then DoneSales := True;

                with SalesTable do
                  If ((not DoneSales) and
                      RecordInRange(FieldByName('DateEntered').AsDateTime,
                                    SwisSBLKey,
                                    ParcelTable.FieldByName('SchoolCode').Text) and
                      ((not OnlyShowSalesWithRemovedExemptions) or
                       (OnlyShowSalesWithRemovedExemptions and
                        (RemovedExemptionsList.Count > 0))))
                    then
                      begin
                        SaleFound := True;

                           {FXX06282002-3: NumFound is double counting.}
                        (*NumFound := NumFound + 1;*)
                        PrintThisParcel := True;

                        OldOwner := SalesTable.FieldByName('OldOwnerName').Text;
                        DeedDate := SalesTable.FieldByName('SaleDate').Text;

                      end;  {If ((not DoneSales) and ...}

                 {If there is only one line left to print, then we
                  want to go to the next page.}

                If (LinesLeft < 8)
                  then
                    begin
                      If PrintSeperatorLine
                        then Println(#9 + StringOfChar('-', 130));
                      NewPage;
                    end;

              until (DoneSales or SaleFound);

                {Now take care of the case where we have a removed exemption
                 without a sale, i.e. removed senior due to death.}

              If ((not SaleFound) and
                  (RemovedExemptionsList.Count > 0))
                then
                  with ParcelTable do
                    begin
                      PrintThisParcel := True;

                      OldOwner := 'NO SALE';
                      DeedDate := 'NO SALE';

                    end;  {with ParcelTable do}

              If PrintThisParcel
                then
                  begin
                    NumFound := NumFound + 1;
                    GetNameAddress(ParcelTable, NAddrArray);
                    If PrintSeperatorLine
                      then Println(#9 + StringOfChar('-', 130));

                      {Get the current name and address, but remove the
                       name 1 and 2 since those are printed in the 2nd column.}

                    StartingIndex := 2;
                    If (Take(30, NAddrArray[2]) =
                        Take(30, ParcelTable.FieldByName('Name2').Text))
                      then StartingIndex := 3;

                    For I := 1 to 6 do
                      If ((I + (StartingIndex - 1)) > 6)
                        then NAddrArray[I] := ''
                        else NAddrArray[I] := NAddrArray[I + (StartingIndex - 1)];

                      {Now print the parcel.}
                      {FXX07252001-1: Print the sale date instead of the deed date
                                      as per Laura.}

                    Print(#9 + Take(20, OldOwner) +
                          #9 + ParcelTable.FieldByName('Name1').Text +
                          #9 + Take(25, NAddrArray[1]) +
                          #9 + ConvertSwisSBLToDashDotNoSwis(SwisSBLKey) +
                          #9 + DeedDate);

                    If (RemovedExemptionsList.Count = 0)
                      then Println(#9 + 'N')
                      else Println(#9 + RemovedExemptionsList[0] + ' ' +
                                        RemovedExemptionsDateList[0]);

                    Print(#9 +
                          #9 + ParcelTable.FieldByName('Name2').Text +
                          #9 + Take(25, NAddrArray[2]) +
                          #9 + GetLegalAddressFromTable(ParcelTable));

                    If (RemovedExemptionsList.Count > 1)
                      then Println(#9 +
                                   #9 + RemovedExemptionsList[1] + ' ' +
                                        RemovedExemptionsDateList[1])
                      else Println('');

                      {Now print the rest of the address or exemptions.}

                    RemovedExemptionsIndex := 2;
                    NameAddrArrayIndex := 3;

                    while (((NameAddrArrayIndex <= 6) and
                            (Deblank(NAddrArray[NameAddrArrayIndex]) <> '')) or
                           (RemovedExemptionsList.Count > RemovedExemptionsIndex)) do
                      begin
                        If ((NameAddrArrayIndex <= 6) and
                            (Deblank(NAddrArray[NameAddrArrayIndex]) <> ''))
                          then Print(#9 + #9 +
                                     #9 + Take(25, NAddrArray[NameAddrArrayIndex]))
                          else Print(#9 + #9 + #9);

                        If (RemovedExemptionsList.Count > RemovedExemptionsIndex)
                          then Print(#9 + #9 +
                                     #9 + RemovedExemptionsList[RemovedExemptionsIndex] + ' ' +
                                          RemovedExemptionsDateList[RemovedExemptionsIndex]);

                        RemovedExemptionsIndex := RemovedExemptionsIndex + 1;
                        NameAddrArrayIndex := NameAddrArrayIndex + 1;

                        Println('');

                      end;  {while (((NameAddrArrayIndex <= 6) and ...}

                    If (CreateParcelList and
                        (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                      then ParcelListDialog.AddOneParcel(SwisSBLKey);

                  end;  {If PrintThisParcel}

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

      If PrintSeperatorLine
        then Println(#9 + StringOfChar('-', 130));

        {FXX01231998-5: Tell them if nothing in range.}

      If (NumFound = 0)
        then Println('None.')
        else
          begin
            Println('');
            Println(#9 + 'Parcels with Removed Exemptions = ' + IntToStr(NumFound));
          end;

    end;  {with Sender as TBaseReport do}

  RemovedExemptionsList.Free;

end;  {ReportPrinterPrint}

{===========================================================}
Procedure TReportSalesAndRemovedExemptionsForm.ReportPrint(Sender: TObject);

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
Procedure TReportSalesAndRemovedExemptionsForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TReportSalesAndRemovedExemptionsForm.FormClose(    Sender: TObject;
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