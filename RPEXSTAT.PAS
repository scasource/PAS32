unit Rpexstat;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Types, RPDefine, (*Progress,*) TabNotBk, RPTXFilr,
  PASTypes, Zipcopy, ComCtrls;

type
  TExemptionStatusReportForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ExemptionTable: TTable;
    ExemptionCodeTable: TTable;
    Label3: TLabel;
    SwisCodeTable: TTable;
    PrintButton: TBitBtn;
    PrintDialog: TPrintDialog;
    Label2: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    Notebook: TTabbedNotebook;
    AssessmentYearRadioGroup: TRadioGroup;
    Label5: TLabel;
    TextFiler: TTextFiler;
    ExemptionCodeListBox: TListBox;
    PrintOrderRadioGroup: TRadioGroup;
    ZipCopyDlg: TZipCopyDlg;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Label14: TLabel;
    SchoolCodeListBox: TListBox;
    Label9: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeTable: TTable;
    Label16: TLabel;
    OptionsGroupBox: TGroupBox;
    LoadFromParcelListCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    StatusGroupBox: TGroupBox;
    RenewalSentCheckBox: TCheckBox;
    RenewalReminderSentCheckBox: TCheckBox;
    RenewalReceivedCheckBox: TCheckBox;
    ExemptionApprovedCheckBox: TCheckBox;
    ApprovalSentCheckBox: TCheckBox;
    ExemptionDeniedCheckBox: TCheckBox;
    DenialSentCheckBox: TCheckBox;
    ExemptionDenialTable: TTable;
    ParcelTable: TTable;
    Label4: TLabel;
    Label6: TLabel;
    ExemptionNotApprovedCheckBox: TCheckBox;
    AllButton: TBitBtn;
    NoneButton: TBitBtn;
    ExemptionLookupTable: TTable;
    RenewalNotReceivedCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrintButtonClick(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure AssessmentYearRadioGroupClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure TextFilerPrintHeader(Sender: TObject);
    procedure AllButtonClick(Sender: TObject);
    procedure NoneButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    AssessmentYear : String;
    ReportCancelled : Boolean;
    ProcessingType : Integer;
    SelectedExemptionCodes,
    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;
    ShowRenewalSent, ShowRenewalReminderSent,
    ShowRenewalReceived, ShowRenewalNotReceived,
    ShowExemptionApproved, ShowExemptionNotApproved,
    ShowApprovalSent, ShowExemptionDenied, ShowDenialSent : Boolean;

    PrintOrder, EnhancedSTARType : Integer;

    LoadFromParcelList,
    CreateParcelList : Boolean;
    TotalsList : TList;
    ReportSection : Integer;
    IVPEnrollmentStatusType : Integer;

    Procedure InitializeForm;  {Open the tables and setup.}


    Function RecMeetsCriteria(ParcelTable,
                              ExemptionTable : TTable;
                              SwisSBLKey : String;
                              ExemptionType : Integer;
                              SelectedExemptionCodes,
                              SelectedSwisCodes,
                              SelectedSchoolCodes : TStringList) : Boolean;

    Procedure FillListBoxes(ProcessingType : Integer;
                            AssessmentYear : String);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, GlblCnst,
     PRCLLIST, Prog, RptDialg,
     Preview, Enstarty;  {Report preview form}

const
  poParcelID = 0;
  poName = 1;
  poLegalAddress = 2;

  Regular = 0;
  Denial = 1;

  rsMain = 0;
  rsTotals = 1;

type
  TotalsRecord = record
    EXCode : String;
    TotalExemptions,
    NumRenewalsSent,
    NumRenewalRemindersSent,
    NumRenewalsReceived,
    NumRenewalsNotReceived,
    NumExemptionsApproved,
    NumExemptionsNotApproved,
    NumApprovalsSent,
    NumExemptionsDenied,
    NumDenialsSent : LongInt;
  end;

  TotalsPointer = ^TotalsRecord;

{$R *.DFM}

{========================================================}
Procedure TExemptionStatusReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TExemptionStatusReportForm.FillListBoxes(ProcessingType : Integer;
                                                   AssessmentYear : String);

var
  Quit : Boolean;

begin
  OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             ProcessingType, Quit);

  FillOneListBox(ExemptionCodeListBox, ExemptionCodeTable,
                 'EXCode', 'Description', 10,
                 True, True, ProcessingType, AssessmentYear);

  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName', 20,
                 True, True, ProcessingType, AssessmentYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable,
                 'SchoolCode', 'SchoolName', 20,
                 True, True, ProcessingType, AssessmentYear);

end;  {LoadEXListBox}

{========================================================}
Procedure TExemptionStatusReportForm.InitializeForm;

begin
  UnitName := 'RPEXSTAT';  {mmm}

    {Default assessment year.}

  case GlblProcessingType of
    NextYear : begin
                 AssessmentYearRadioGroup.ItemIndex := 1;
                 ProcessingType := NextYear;
                 AssessmentYear := GlblNextYear;
               end;  {NextYear}

    ThisYear : begin
                 AssessmentYearRadioGroup.ItemIndex := 0;
                 ProcessingType := ThisYear;
                 AssessmentYear := GlblThisYear;
               end;  {This Year}

  end;  {case GlblProcessingType of}

  FillListBoxes(ProcessingType, AssessmentYear);

end;  {InitializeForm}

{===========================================================================}
Procedure TExemptionStatusReportForm.AssessmentYearRadioGroupClick(Sender: TObject);

{FXX12021998-1: Load the EX box with that year's sd codes.}

var
  ProcessingType : Integer;

begin
  ProcessingType := GlblProcessingType;
    {FXX04251999-2: Allow the user to print from history.}

  case AssessmentYearRadioGroup.ItemIndex of
    0 : begin
          ProcessingType := ThisYear;
          AssessmentYear := GlblThisYear;
        end;

    1 : begin
          ProcessingType := NextYear;
          AssessmentYear := GlblNextYear;
        end;

  end;  {case AssessmentYearRadioGroup.ItemIndex of}

  FillListBoxes(ProcessingType, AssessmentYear);

end;  {AssessmentYearRadioGroupClick}

{====================================================================}
Procedure TExemptionStatusReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'exstatus.sta', 'Exemption Status Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TExemptionStatusReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'exstatus.sta', 'Exemption Status Report');

end;  {LoadButtonClick}

{===================================================================}
Procedure TExemptionStatusReportForm.AllButtonClick(Sender: TObject);

var
  I : Integer;

begin
  For I := 0 to (ComponentCount - 1) do
    If (Components[I] is TCheckBox)
      then
        with Components[I] as TCheckBox do
          If (Parent.Name = 'StatusGroupBox')
            then Checked := True;

end;  {AllButtonClick}

{===================================================================}
Procedure TExemptionStatusReportForm.NoneButtonClick(Sender: TObject);

var
  I : Integer;

begin
  For I := 0 to (ComponentCount - 1) do
    If (Components[I] is TCheckBox)
      then
        with Components[I] as TCheckBox do
          If (Parent.Name = 'StatusGroupBox')
            then Checked := False;

end;  {NoneButtonClick}

{===================================================================}
{===============  THE FOLLOWING ARE PRINTING PROCEDURES ============}
{===================================================================}
{=================================================================}
Procedure TExemptionStatusReportForm.PrintButtonClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName, TextFileName : String;
  I, ProcessingType : Integer;

begin
  ReportSection := rsMain;
  Quit := False;
  ReportCancelled := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  PrintButton.Enabled := False;
  Application.ProcessMessages;
  TotalsList := TList.Create;

  If PrintDialog.Execute
    then
      begin
        ProcessingType := GlblProcessingType;
        case AssessmentYearRadioGroup.ItemIndex of
          0 : begin
                ProcessingType := ThisYear;
                AssessmentYear := GlblThisYear;
              end;

          1 : begin
                ProcessingType := NextYear;
                AssessmentYear := GlblNextYear;
              end;

        end;  {case AssessmentYearRadioGroup.ItemIndex of}

        LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
        CreateParcelList := CreateParcelListCheckBox.Checked;

        SelectedSwisCodes := TStringList.Create;
        SelectedExemptionCodes := TStringList.Create;
        SelectedSchoolCodes := TStringList.Create;

        For I := 0 to (SwisCodeListBox.Items.Count - 1) do
          If SwisCodeListBox.Selected[I]
            then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

        For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
          If SchoolCodeListBox.Selected[I]
            then SelectedSchoolCodes.Add(Take(6, SchoolCodeListBox.Items[I]));

        For I := 0 to (ExemptionCodeListBox.Items.Count - 1) do
          If (ExemptionCodeListBox.Selected[I])
             then SelectedExemptionCodes.Add(Take(5, ExemptionCodeListBox.Items[I]));

          {CHG06042001-3: Let them choose which STAR type.}

        If ((not LoadFromParcelList) and
            (SelectedExemptionCodes.IndexOf(EnhancedSTARExemptionCode) > -1))
          then
            begin
              EnhancedSTARTypeDialog.ShowModal;
              EnhancedSTARType := EnhancedSTARTypeDialog.EnhancedSTARType;

                {CHG01212004-1(2.08): Add ability to select IVP enrollment status as a choice.}

              IVPEnrollmentStatusType := EnhancedSTARTypeDialog.IVPEnrollmentStatusType;

            end;  {If ((not LoadFromParcelList) and ...}

        ShowRenewalSent := RenewalSentCheckBox.Checked;
        ShowRenewalReminderSent := RenewalReminderSentCheckBox.Checked;
        ShowRenewalReceived := RenewalReceivedCheckBox.Checked;
        ShowRenewalNotReceived := RenewalNotReceivedCheckBox.Checked;
        ShowExemptionApproved := ExemptionApprovedCheckBox.Checked;
        ShowExemptionNotApproved := ExemptionNotApprovedCheckBox.Checked;
        ShowApprovalSent := ApprovalSentCheckBox.Checked;
        ShowExemptionDenied := ExemptionDeniedCheckBox.Checked;
        ShowDenialSent := DenialSentCheckBox.Checked;

        with ParcelTable do
          case PrintOrderRadioGroup.ItemIndex of
            poParcelId : IndexName := ParcelTable_Year_Swis_SBLKey;
            poName : IndexName := 'BYYEAR_NAME';
            poLegalAddress : IndexName := 'BYYEAR_LEGALADDR_LEGALADDRNO';
          end;

          {We have to open the tables manually since we are opening both this year and next year.}

        OpenTableForProcessingType(ExemptionTable, ExemptionsTableName,
                                   ProcessingType, Quit);
        OpenTableForProcessingType(ExemptionLookupTable, ExemptionsTableName,
                                   ProcessingType, Quit);
        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   ProcessingType, Quit);
        OpenTableForProcessingType(ExemptionDenialTable, ExemptionsDenialTableName,
                                   ProcessingType, Quit);

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
              ProgressDialog.Start(GetRecordCount(ExemptionTable), True, True);
              ProgressDialog.UserLabelCaption := '';

              TextFileName := GetPrintFileName(Self.Caption, True);
              TextFiler.FileName := TextFileName;

                {FXX01211998-1: Need to set the LastPage property so that
                                long rolls aren't a problem.}

              TextFiler.LastPage := 30000;

              TextFiler.Execute;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

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

              ProgressDialog.Finish;

                {CHG01182000-3: Allow them to choose a different name or copy right away.}

              ShowReportDialog('EXSTATUS.RPT', TextFiler.FileName, True);

              ResetPrinter(ReportPrinter);

            end;  {If not Quit}

          {FXX09071999-4: Need to show the parcel list.}

        If CreateParcelList
          then ParcelListDialog.Show;

      end;  {If PrintDialog.Execute}

  PrintButton.Enabled := True;
  FreeTList(TotalsList, SizeOf(TotalsRecord));

end;  {PrintButtonClick}

{===================================================================}
Procedure TExemptionStatusReportForm.TextFilerPrintHeader(Sender: TObject);

var
  TempStr, TempStr2, LineStr : String;
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      Println('');
      TempStr := 'COUNTY OF ' + Trim(GlblCountyName);
      TempStr2 := 'DATE: ' + DateToStr(Date) + '  TIME: ' + TimeToStr(Now);

      LineStr := UpcaseStr(TempStr) +
                 Center('EXEMPTION STATUS REPORT', (130 - 2 * Length(TempStr)));
      LineStr := Take(130, LineStr);

        {Put the date and time on the end.}

      For I := Length(TempStr2) downto 1 do
        LineStr[130 - (Length(TempStr2) - I)] := TempStr2[I];
      Println(LineStr);

        {FXX09081999-5: Add in year of printing and skip one line at beginning.}

      TempStr := Trim(UpcaseStr(GetMunicipalityName));
      TempStr2 := 'PAGE: ' + IntToStr(CurrentPage);
      Println(Take(43, TempStr) +
              Center(AssessmentYear + ' ASSESSMENT YEAR', 43) +
              RightJustify(TempStr2, 44));

      Println('');

      If (ReportSection = rsMain)
        then
          begin
              {CHG10262001-1: Add the exemption percent.}

            ClearTabs;
            SetTab(0.3, pjCenter, 1.8, 0, BoxLineNone, 0); {Parcel ID}
            SetTab(2.2, pjCenter, 1.3, 0, BoxLineNone, 0); {Name}
            SetTab(3.6, pjCenter, 1.2, 0, BoxLineNone, 0); {Addr}
            SetTab(4.9, pjCenter, 0.6, 0, BoxLineNone, 0); {EX Code}
            SetTab(5.6, pjCenter, 0.3, 0, BoxLineNone, 0);  {Percent}
            SetTab(6.0, pjCenter, 1.0, 0, BoxLineNone, 0);  {Initial Date}
            SetTab(7.1, pjCenter, 1.0, 0, BoxLineNone, 0);  {Renewal Printed Date}
            SetTab(8.2, pjCenter, 0.4, 0, BoxLineNone, 0);  {Renewal Received}
            SetTab(8.7, pjCenter, 0.4, 0, BoxLineNone, 0);  {Renewal Not Received}
            SetTab(9.2, pjCenter, 0.8, 0, BoxLineNone, 0);  {Renewal reminder sent}
            SetTab(10.1, pjCenter, 0.6, 0, BoxLineNone, 0);  {Approved}
            SetTab(10.8, pjCenter, 1.0, 0, BoxLineNone, 0);  {Approval Sent date}
            SetTab(11.9, pjCenter, 0.6, 0, BoxLineNone, 0);  {Denied}
            SetTab(12.6, pjCenter, 1.0, 0, BoxLineNone, 0);  {Denial Sent date}

            Println(#9 + #9 + #9 + #9 + #9 + #9 +
                    #9 + 'RENEWAL' +
                    #9 +
                    #9 + 'RENW' +
                    #9 +
                    #9 + 'RENW' +
                    #9 + 'APPROVAL' +
                    #9 +
                    #9 + 'DENIAL');

            Println(#9 + #9 + #9 +
                    #9 + 'EX' +
                    #9 +
                    #9 + 'INITIAL' +
                    #9 + 'NOTICE' +
                    #9 + 'RENW' +
                    #9 + 'NOT' +
                    #9 + 'REMINDER' +
                    #9 +
                    #9 + 'NOTICE' +
                    #9 +
                    #9 + 'NOTICE');

            Println(#9 + 'PARCEL ID' +
                    #9 + 'OWNER' +
                    #9 + 'LEGAL ADDR' +
                    #9 + 'CODE' +
                    #9 + 'PCT' +
                    #9 + 'DATE' +
                    #9 + 'DATE' +
                    #9 + 'RCVD' +
                    #9 + 'RCVD' +
                    #9 + 'SENT' +
                    #9 + 'APPRVD' +
                    #9 + 'DATE' +
                    #9 + 'DENIED' +
                    #9 + 'DATE');

            Println('');

            ClearTabs;
            SetTab(0.3, pjLeft, 1.8, 0, BoxLineNone, 0); {Parcel ID}
            SetTab(2.2, pjLeft, 1.3, 0, BoxLineNone, 0); {Name}
            SetTab(3.6, pjLeft, 1.3, 0, BoxLineNone, 0); {Addr}
            SetTab(4.9, pjLeft, 0.6, 0, BoxLineNone, 0); {EX Code}
            SetTab(5.6, pjRight, 0.3, 0, BoxLineNone, 0);  {Percent}
            SetTab(6.0, pjLeft, 1.0, 0, BoxLineNone, 0);  {Initial Date}
            SetTab(7.1, pjLeft, 1.0, 0, BoxLineNone, 0);  {Renewal Printed Date}
            SetTab(8.2, pjCenter, 0.4, 0, BoxLineNone, 0);  {Renewal Received}
            SetTab(8.7, pjCenter, 0.4, 0, BoxLineNone, 0);  {Renewal Not Received}
            SetTab(9.2, pjCenter, 0.8, 0, BoxLineNone, 0);  {Renewal reminder sent}
            SetTab(10.1, pjCenter, 0.6, 0, BoxLineNone, 0);  {Approved}
            SetTab(10.8, pjLeft, 1.0, 0, BoxLineNone, 0);  {Approval Sent date}
            SetTab(11.9, pjCenter, 0.6, 0, BoxLineNone, 0);  {Denied}
            SetTab(12.6, pjLeft, 1.0, 0, BoxLineNone, 0);  {Denial Sent date}

          end;  {If (ReportSection = rsMain)}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Function FindTotalsRec(TotalsList : TList;
                       EXCode : String) : Integer;

var
  I, Index : Integer;
  Found : Boolean;
  TotalsPtr : TotalsPointer;

begin
  Found := False;
  Index := -1;

  For I := 0 to (TotalsList.Count - 1) do
    If (TotalsPointer(TotalsList[I])^.EXCode = EXCode)
      then
        begin
          Index := I;
          Found := True;
        end;

    {If no record was found, then insert one.}

  If not Found
    then
      begin
        New(TotalsPtr);

        with TotalsPtr^ do
          begin
            TotalExemptions := 0;
            NumRenewalsSent := 0;
            NumRenewalRemindersSent := 0;
            NumRenewalsReceived := 0;
            NumRenewalsNotReceived := 0;
            NumExemptionsApproved := 0;
            NumExemptionsNotApproved := 0;
            NumApprovalsSent := 0;
            NumExemptionsDenied := 0;
            NumDenialsSent := 0;

          end;  {with TotalsPtr^ do}

        TotalsPtr^.EXCode := EXCode;
        TotalsList.Add(TotalsPtr);
        Index := TotalsList.Count - 1;  {Last item}

      end;  {If not Found}

  Result := Index;

end;  {FindTotalsRec}

{===================================================================}
Function TExemptionStatusReportForm.RecMeetsCriteria(ParcelTable,
                                                     ExemptionTable : TTable;
                                                     SwisSBLKey : String;
                                                     ExemptionType : Integer;
                                                     SelectedExemptionCodes,
                                                     SelectedSwisCodes,
                                                     SelectedSchoolCodes : TStringList) : Boolean;

var
  EXCode : String;
  Index : Integer;
  ParcelHasSenior : Boolean;

begin
  Index := -1;
  Result := True;
  EXCode := ExemptionTable.FieldByName('ExemptionCode').Text;

    {In the selected swis list?}

  If (SelectedSwisCodes.IndexOf(Copy(SwisSBLKey, 1, 6)) = -1)
    then Result := False;

    {In the selected school list?}

  If (SelectedSchoolCodes.IndexOf(ParcelTable.FieldByName('SchoolCode').Text) = -1)
    then Result := False;

    {Don't include rs 9.}

  If (ParcelTable.FieldByName('RollSection').Text = '9')
    then Result := False;

    {FXX09161998-3: Don't include inactive parcels.}

  If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
    then Result := False;

  If (SelectedExemptionCodes.IndexOf(EXCode) = -1)
    then Result := False;

  If Result
    then Index := FindTotalsRec(TotalsList, EXCode);

    {CHG06042001-3: Let them choose which STAR type.}

  If (Result and
      (EXCode = EnhancedSTARExemptionCode))
    then
      begin
        FindNearestOld(ExemptionLookupTable,
                       ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                       [AssessmentYear, SwisSBLKey, '41800']);

        ParcelHasSenior := (Take(4, ExemptionLookupTable.FieldByName('ExemptionCode').Text) = '4180');

        If ((EnhancedSTARType = enSeniorSTAROnly) and
            ParcelHasSenior)
          then Result := False;

        If ((EnhancedSTARType = enWithSeniorandSTARExemption) and
            (not ParcelHasSenior))
          then Result := False;

          {CHG01212004-1(2.08): Add ability to select IVP enrollment status as a choice.}

        If Result
          then
            case IVPEnrollmentStatusType of
              ivpEnrolledOnly : Result := ExemptionTable.FieldByName('AutoRenew').AsBoolean;
              ivpNotEnrolledOnly : Result := (not ExemptionTable.FieldByName('AutoRenew').AsBoolean);
            end;  {case IVPEnrollmentStatusType of}

      end;  {If (Result and ...}

    {Now test for the statuses that they wanted.}

  If (Result and
      (ExemptionType = Regular))
    then
      with TotalsPointer(TotalsList[Index])^ do
        begin
          Result := False;
          TotalExemptions := TotalExemptions + 1;

          If ExemptionTable.FieldByName('RenewalPrinted').AsBoolean
            then
              begin
                If ShowRenewalSent
                  then Result := True;
                NumRenewalsSent := NumRenewalsSent + 1;

              end;  {If ExemptionTable.FieldByName('RenewalPrinted').AsBoolean}

          If ExemptionTable.FieldByName('RenewalReceived').AsBoolean
            then
              begin
                If ShowRenewalReceived
                  then Result := True;
                NumRenewalsReceived := NumRenewalsReceived + 1;

              end;  {If ExemptionTable.FieldByName('RenewalReceived').AsBoolean}

            {CHG04302003-2(2.07): Show renewals not received.}

          If (ExemptionTable.FieldByName('RenewalPrinted').AsBoolean and
              (not ExemptionTable.FieldByName('RenewalReceived').AsBoolean) and
              (not ExemptionTable.FieldByName('ExemptionApproved').AsBoolean))
            then
              begin
                If ShowRenewalNotReceived
                  then Result := True;
                NumRenewalsNotReceived := NumRenewalsNotReceived + 1;

              end;

          If ExemptionTable.FieldByName('ReminderPrinted').AsBoolean
            then
              begin
                If ShowRenewalReminderSent
                  then Result := True;
                NumRenewalRemindersSent := NumRenewalRemindersSent + 1;

              end;  {If ExemptionTable.FieldByName('ReminderPrinted').AsBoolean}

          If ExemptionTable.FieldByName('ExemptionApproved').AsBoolean
            then
              begin
                If ShowExemptionApproved
                  then Result := True;
                NumExemptionsApproved := NumExemptionsApproved + 1;

              end;  {If ExemptionTable.FieldByName('ExemptionApproved').AsBoolean}

          If not ExemptionTable.FieldByName('ExemptionApproved').AsBoolean
            then
              begin
                If ShowExemptionNotApproved
                  then Result := True;
                NumExemptionsNotApproved := NumExemptionsNotApproved + 1;

              end;  {If not ExemptionTable.FieldByName('ExemptionApproved').AsBoolean}

          If ExemptionTable.FieldByName('ApprovalPrinted').AsBoolean
            then
              begin
                If ShowApprovalSent
                  then Result := True;
                NumApprovalsSent := NumApprovalsSent + 1;

              end;  {If ExemptionTable.FieldByName('ApprovalPrinted').AsBoolean}

        end;  {with TotalsPointer(TotalsList[Index])^ do}

  If (Result and
      (ExemptionType = Denial))
    then
      with TotalsPointer(TotalsList[Index])^ do
        begin
          Result := False;

            {Note that if we got to this point, it indicates the presence of
             a denial with this exemption code.}

          If ShowExemptionDenied
            then
              begin
                Result := True;
                NumExemptionsDenied := NumExemptionsDenied + 1;
              end;

          If ExemptionTable.FieldByName('DenialPrinted').AsBoolean
            then
              begin
                If ShowDenialSent
                  then Result := True;
                NumDenialsSent := NumDenialsSent + 1;

              end;  {If ExemptionTable.FieldByName('DenialPrinted').AsBoolean}

        end; {with TotalsPointer(TotalsList[Index])^ do}

end;  {RecMeetsCriteria}

{===================================================================}
Procedure PrintOneRecord(Sender : TObject;
                         ExemptionTable,
                         ParcelTable : TTable;
                         ExemptionType : Integer);

var
  RenewalReceivedStr, RenewalNotReceivedStr,
  RenewalReminderSentStr, ApprovedStr : String;
  TempPercent : String;

begin
  with Sender as TBaseReport do
    begin
      If (LinesLeft < 6)
        then NewPage;

      with ExemptionTable do
        begin
          Print(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                #9 + Take(11, ParcelTable.FieldByName('Name1').Text) +
                #9 + Take(11, GetLegalAddressFromTable(ParcelTable)) +
                #9 + FieldByName('ExemptionCode').Text);

            {FXX04062003-2(2.06r): Make sure that printing denial information does not
                                   cause a problem since it does not have a percent field.}

          try
            TempPercent := FormatFloat(IntegerDisplay, FieldByName('Percent').AsFloat);
          except
            TempPercent := '';
          end;

          Print(#9 + TempPercent);

          If (ExemptionType = Regular)
            then
              begin
                If FieldByName('RenewalReceived').AsBoolean
                  then RenewalReceivedStr := 'X'
                  else RenewalReceivedStr := '';

                  {CHG04302003-2(2.07): Show renewals not received.}

                If (FieldByName('RenewalPrinted').AsBoolean and
                    (not FieldByName('RenewalReceived').AsBoolean))
                  then RenewalNotReceivedStr := 'X'
                  else RenewalNotReceivedStr := '';

                If FieldByName('ReminderPrinted').AsBoolean
                  then RenewalReminderSentStr := 'X'
                  else RenewalReminderSentStr := '';

                If FieldByName('ExemptionApproved').AsBoolean
                  then ApprovedStr := 'X'
                  else ApprovedStr := '';

                Println(#9 + FieldByName('InitialDate').Text +
                        #9 + FieldByName('DateRenewalPrinted').Text +
                        #9 + RenewalReceivedStr +
                        #9 + RenewalNotReceivedStr +
                        #9 + RenewalReminderSentStr +
                        #9 + ApprovedStr +
                        #9 + FieldByName('DateApprovalPrinted').Text);
              end
            else Println(#9 + FieldByName('DenialDate').Text +
                         #9 + #9 + #9 + #9 + #9 +
                         #9 + 'X' +  {This is never called unless an exemption was denied.}
                         #9 + FieldByName('PrintedDate').Text);


        end;  {with ExemptionTable do}

    end;  {with Sender as TBaseReport do}

end;  {PrintOneRecord}

{===================================================================}
Procedure PrintTotalsHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjCenter, 13, 0, BoxLineNone, 0); {Parcel ID}
      Println('');
      Println(#9 + 'E X E M P T I O N   T O T A L S');
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 0.6, 0, BoxLineNone, 0); {EX Code}
      SetTab(1.0, pjCenter, 1.1, 0, BoxLineNone, 0);  {Total Exemptions}
      SetTab(2.2, pjCenter, 1.1, 0, BoxLineNone, 0);  {Num renewals sent}
      SetTab(3.4, pjCenter, 1.1, 0, BoxLineNone, 0);  {Num renewal reminders sent}
      SetTab(4.6, pjCenter, 1.1, 0, BoxLineNone, 0);  {Num renewals received}
      SetTab(5.8, pjCenter, 1.1, 0, BoxLineNone, 0);  {Num renewals not received}
      SetTab(7.0, pjCenter, 1.1, 0, BoxLineNone, 0);  {Num exemptions approved}
      SetTab(8.2, pjCenter, 1.1, 0, BoxLineNone, 0);  {Num exemptions not approved}
      SetTab(9.4, pjCenter, 1.1, 0, BoxLineNone, 0);  {Num approvals sent}
      SetTab(10.6, pjCenter, 1.1, 0, BoxLineNone, 0);  {Num exemptions denied}
      SetTab(11.8, pjCenter, 1.1, 0, BoxLineNone, 0);  {Num denials sent}

      Println(#9 + 'EX' +
              #9 +
              #9 + 'RENEWALS' +
              #9 + 'REMINDERS' +
              #9 + 'RENEWALS' +
              #9 + 'RENEWALS' +
              #9 + 'EXEMPTS' +
              #9 + 'EXEMPTS NOT' +
              #9 + 'APPRVLS' +
              #9 + 'EXEMPTS' +
              #9 + 'DENIALS');

      Println(#9 + 'CODE' +
              #9 + 'TOTAL' +
              #9 + 'SENT' +
              #9 + 'SENT' +
              #9 + 'RCVD' +
              #9 + 'NOT RCVD' +
              #9 + 'APPRVD' +
              #9 + 'APPRVD' +
              #9 + 'SENT' +
              #9 + 'DENIED' +
              #9 + 'SENT');

      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 0.6, 0, BoxLineNone, 0); {EX Code}
      SetTab(1.0, pjRight, 1.1, 0, BoxLineNone, 0);  {Total Exemptions}
      SetTab(2.2, pjRight, 1.1, 0, BoxLineNone, 0);  {Num renewals sent}
      SetTab(3.4, pjRight, 1.1, 0, BoxLineNone, 0);  {Num renewal reminders sent}
      SetTab(4.6, pjRight, 1.1, 0, BoxLineNone, 0);  {Num renewals received}
      SetTab(5.8, pjRight, 1.1, 0, BoxLineNone, 0);  {Num renewals not received}
      SetTab(7.0, pjRight, 1.1, 0, BoxLineNone, 0);  {Num exemptions approved}
      SetTab(8.2, pjRight, 1.1, 0, BoxLineNone, 0);  {Num exemptions not approved}
      SetTab(9.4, pjRight, 1.1, 0, BoxLineNone, 0);  {Num approvals sent}
      SetTab(10.6, pjRight, 1.1, 0, BoxLineNone, 0);  {Num exemptions denied}
      SetTab(11.8, pjRight, 1.1, 0, BoxLineNone, 0);  {Num denials sent}

    end;  {with Sender as TBaseReport do}

end;  {PrintTotalsHeader}

{==================================================================}
Procedure SortTotalsList(TotalsList : TList);

var
  I, J : Integer;
  MasterKey : String;
  TempTotalsPtr : TotalsPointer;

begin
  For I := 0 to (TotalsList.Count - 1) do
    begin
      MasterKey := TotalsPointer(TotalsList[I])^.EXCode;

      For J := (I + 1) to (TotalsList.Count - 1) do
        If (TotalsPointer(TotalsList[J])^.EXCode < MasterKey)
          then
            begin
              TempTotalsPtr := TotalsList[J];
              TotalsList[J] := TotalsList[I];
              TotalsList[I] := TempTotalsPtr;
            end;  {For J := (I + 1) to (TotalsList.Count - 1) do}

    end;  {For I := 0 to (TotalsList.Count - 1) do}

end;  {SortTotalsList}

{===================================================================}
Procedure TExemptionStatusReportForm.TextFilerPrint(Sender: TObject);

var
  FirstTimeThrough, Done, NewPagePrinted,
  FirstTimeThroughExemptions, DoneExemptions : Boolean;
  SwisSBLKey : String;
  I, Index, NumFound : Integer;
  GrandTotalExemptions, GrandTotalRenewalsSent,
  GrandTotalRenewalRemindersSent, GrandTotalRenewalsReceived, GrandTotalRenewalsNotReceived,
  GrandTotalExemptionsApproved, GrandTotalExemptionsNotApproved,
  GrandTotalApprovalsSent, GrandTotalExemptionsDenied, GrandTotalDenialsSent : LongInt;

begin
  FirstTimeThrough := True;
  Done := False;
  NumFound := 0;
  ProgressDialog.UserLabelCaption := '';
  Index := 1;

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

    {CHG03191999-2: Add option to load from parcel list.}

  If LoadFromParcelList
    then
      begin
        Index := 1;
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        ParcelTable.First;
        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
      end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              ParcelListDialog.GetParcel(ParcelTable, Index);
            end
          else ParcelTable.Next;

    If (ParcelTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
      else
        case PrintOrderRadioGroup.ItemIndex of
          poParcelId : ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));
          poName : ProgressDialog.Update(Self, ParcelTable.FieldByName('Name1').Text);
          poLegalAddress : ProgressDialog.Update(Self, GetLegalAddressFromTable(ParcelTable));
        end;

    SwisSBLKey := ExtractSSKey(ParcelTable);
    Application.ProcessMessages;

    If not Done
      then
        begin
            {First see if the exemption records are what they want.}

          If (ShowRenewalSent or
              ShowRenewalReminderSent or
              ShowRenewalReceived or
              ShowRenewalNotReceived or
              ShowExemptionApproved or
              ShowExemptionNotApproved or
              ShowApprovalSent)
            then
              begin
                FirstTimeThroughExemptions := True;
                DoneExemptions := False;

                ExemptionTable.CancelRange;
                SetRangeOld(ExemptionTable,
                            ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                            [AssessmentYear, SwisSBLKey, '     '],
                            [AssessmentYear, SwisSBLKey, 'ZZZZZ']);

                repeat
                  If FirstTimeThroughExemptions
                    then FirstTimeThroughExemptions := False
                    else ExemptionTable.Next;

                  If ExemptionTable.EOF
                    then DoneExemptions := True;

                  If ((not DoneExemptions) and
                       RecMeetsCriteria(ParcelTable, ExemptionTable,
                                        SwisSBLKey, Regular,
                                        SelectedExemptionCodes,
                                        SelectedSwisCodes,
                                        SelectedSchoolCodes))
                    then
                      begin
                        NumFound := NumFound + 1;
                        ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumFound);
                        PrintOneRecord(Sender, ExemptionTable, ParcelTable, Regular);

                        If (CreateParcelList and
                            (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                          then ParcelListDialog.AddOneParcel(SwisSBLKey);

                      end;

                until DoneExemptions;

              end;  {If (ShowRenewalSent or ...}

            {Now go through the denials for this parcel.}

          If (ShowExemptionDenied or
              ShowDenialSent)
            then
              begin
                FirstTimeThroughExemptions := True;
                DoneExemptions := False;

                ExemptionDenialTable.CancelRange;
                SetRangeOld(ExemptionDenialTable,
                            ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                            [AssessmentYear, SwisSBLKey, '     '],
                            [AssessmentYear, SwisSBLKey, 'ZZZZZ']);

                repeat
                  If FirstTimeThroughExemptions
                    then FirstTimeThroughExemptions := False
                    else ExemptionDenialTable.Next;

                  If ExemptionDenialTable.EOF
                    then DoneExemptions := True;

                  If ((not DoneExemptions) and
                       RecMeetsCriteria(ParcelTable, ExemptionDenialTable,
                                        SwisSBLKey, Denial,
                                        SelectedExemptionCodes,
                                        SelectedSwisCodes,
                                        SelectedSchoolCodes))
                    then
                      begin
                        PrintOneRecord(Sender, ExemptionDenialTable, ParcelTable, Denial);
                        NumFound := NumFound + 1;
                      end;

                until DoneExemptions;

              end;  {If (ShowExemptionDenied or ...}

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

    {Print totals}

  SortTotalsList(TotalsList);

  GrandTotalExemptions := 0;
  GrandTotalRenewalsSent := 0;
  GrandTotalRenewalRemindersSent := 0;
  GrandTotalRenewalsReceived := 0;
  GrandTotalRenewalsNotReceived := 0;
  GrandTotalExemptionsApproved := 0;
  GrandTotalExemptionsNotApproved := 0;
  GrandTotalApprovalsSent := 0;
  GrandTotalExemptionsDenied := 0;
  GrandTotalDenialsSent := 0;

  with Sender as TBaseReport do
    begin
      For I := 0 to (TotalsList.Count - 1) do
        begin
          ReportSection := rsTotals;
          NewPagePrinted := False;

          If (LinesLeft < 10)
            then
              begin
                NewPage;
                NewPagePrinted := True;
              end;

          If ((I = 0) or
              NewPagePrinted)
            then PrintTotalsHeader(Sender);

          with TotalsPointer(TotalsList[I])^ do
            begin
              Println(#9 + EXCode +
                      #9 + IntToStr(TotalExemptions) +
                      #9 + IntToStr(NumRenewalsSent) +
                      #9 + IntToStr(NumRenewalRemindersSent) +
                      #9 + IntToStr(NumRenewalsReceived) +
                      #9 + IntToStr(NumRenewalsNotReceived) +
                      #9 + IntToStr(NumExemptionsApproved) +
                      #9 + IntToStr(NumExemptionsNotApproved) +
                      #9 + IntToStr(NumApprovalsSent) +
                      #9 + IntToStr(NumExemptionsDenied) +
                      #9 + IntToStr(NumDenialsSent));

              GrandTotalExemptions := GrandTotalExemptions + TotalExemptions;
              GrandTotalRenewalsSent := GrandTotalRenewalsSent + NumRenewalsSent;
              GrandTotalRenewalRemindersSent := GrandTotalRenewalRemindersSent + NumRenewalRemindersSent;
              GrandTotalRenewalsReceived := GrandTotalRenewalsReceived + NumRenewalsReceived;
              GrandTotalRenewalsNotReceived := GrandTotalRenewalsNotReceived + NumRenewalsNotReceived;
              GrandTotalExemptionsApproved := GrandTotalExemptionsApproved + NumExemptionsApproved;
              GrandTotalExemptionsNotApproved := GrandTotalExemptionsNotApproved + NumExemptionsNotApproved;
              GrandTotalApprovalsSent := GrandTotalApprovalsSent + NumApprovalsSent;
              GrandTotalExemptionsDenied := GrandTotalExemptionsDenied + NumExemptionsDenied;
              GrandTotalDenialsSent := GrandTotalDenialsSent + NumDenialsSent;

            end;  {with TotalsPointer(TotalsList[I])^ do}

        end;  {For I := 0 to (TotalsList.Count - 1) do}

        {CHG06042001-2: Add a grand total.}

      Println('');
      Println(#9 + 'TOTAL' +
              #9 + IntToStr(GrandTotalExemptions) +
              #9 + IntToStr(GrandTotalRenewalsSent) +
              #9 + IntToStr(GrandTotalRenewalRemindersSent) +
              #9 + IntToStr(GrandTotalRenewalsReceived) +
              #9 + IntToStr(GrandTotalRenewalsNotReceived) +
              #9 + IntToStr(GrandTotalExemptionsApproved) +
              #9 + IntToStr(GrandTotalExemptionsNotApproved) +
              #9 + IntToStr(GrandTotalApprovalsSent) +
              #9 + IntToStr(GrandTotalExemptionsDenied) +
              #9 + IntToStr(GrandTotalDenialsSent));

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{==================================================================}
Procedure TExemptionStatusReportForm.ReportPrint(Sender: TObject);

var
  TempTextFile : TextFile;

begin
  AssignFile(TempTextFile, TextFiler.FileName);
  Reset(TempTextFile);

        {CHG12211998-1: Add ability to select print range.}

  PrintTextReport(Sender, TempTextFile, PrintDialog.FromPage,
                  PrintDialog.ToPage);

  CloseFile(TempTextFile);

end;  {ReportPrint}

{===================================================================}
Procedure TExemptionStatusReportForm.FormClose(    Sender: TObject;
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