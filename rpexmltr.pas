unit Rpexmltr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,pastypes,
  GlblCnst,Types, RPFiler, RPBase, RPCanvas, RPrinter, (*Progress, *)RPDefine,
  DBGrids, DBLookup, TabNotBk, Mask, RPMemo, RPDBUtil, ComCtrls, ExtDlgs,
  wwriched, wwrichedspell, Word97, OleServer, OleCtnrs, EditDialog;

type
  TExemptionLetterPrintForm = class(TForm)
    Panel2: TPanel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    LetterTextTable: TTable;
    ExemptionCodeTable: TTable;
    ParcelExemptionSearchTable: TTable;
    AssessorOfficeTable: TTable;
    ParcelTable: TTable;
    ParcelExemptionTable: TTable;
    LetterTextDataSource: TDataSource;
    LetterTextTableMainCode: TStringField;
    LetterTextTableLetterText: TMemoField;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ExemptionDenialTable: TTable;
    SignatureOpenDialog: TOpenPictureDialog;
    ExemptionDenialTableTaxRollYr: TStringField;
    ExemptionDenialTableSwisSBLKey: TStringField;
    ExemptionDenialTableExemptionCode: TStringField;
    ExemptionDenialTableDenialPrinted: TBooleanField;
    ExemptionDenialTablePrintedDate: TDateField;
    ExemptionDenialTableDenialDate: TDateField;
    ExemptionDenialTableReason: TMemoField;
    ExemptionDenialTableProrata: TBooleanField;
    AssessmentYearControlTable: TTable;
    SwisCodeTable: TwwTable;
    Panel3: TPanel;
    Label5: TLabel;
    MirrorLetterCodeEdit: TEdit;
    SaveReportOptionsButton: TBitBtn;
    LoadButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    WordDocument: TWordDocument;
    WordApplication: TWordApplication;
    MergeLetterTable: TwwTable;
    MergeLetterDataSource: TwwDataSource;
    MergeFieldsAvailableTable: TTable;
    OLEItemNameTimer: TTimer;
    MergeLetterDefinitionsTable: TwwTable;
    eddlgNewLetter: TEditDialogBox;
    SchoolCodeTable: TTable;
    PageControl1: TPageControl;
    tbsOptions: TTabSheet;
    AssessmentYearRadioGroup: TRadioGroup;
    LetterTypeRadioGroup: TRadioGroup;
    ReportTypeRadioGroup: TRadioGroup;
    MiscGroupBox: TGroupBox;
    Label3: TLabel;
    Label7: TLabel;
    LetterHeadCheckBox: TCheckBox;
    TrialRunCheckBox: TCheckBox;
    DatePrintedEdit: TMaskEdit;
    PrintLetterBodyBoldCheckBox: TCheckBox;
    LoadFromParcelListCheckBox: TCheckBox;
    ReprintCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    ForceLettersToBePrintedCheckBox: TCheckBox;
    PrintGreetingLineCheckBox: TCheckBox;
    UseStandardApprovalPercentLineCheckBox: TCheckBox;
    InsertDollarAmountsCheckBox: TCheckBox;
    InsertPercentagesCheckBox: TCheckBox;
    IncludeReasonLinesCheckBox: TCheckBox;
    tbsMoreOptions: TTabSheet;
    SignatureGroupBox: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    WidthLabel: TLabel;
    Label6: TLabel;
    SignatureFileSpeedButton: TSpeedButton;
    SignatureXPosEdit: TEdit;
    SignatureYPosEdit: TEdit;
    SignatureFileNameEdit: TEdit;
    SignatureWidthEdit: TEdit;
    SignatureHeightEdit: TEdit;
    PrintOrderRadioGroup: TRadioGroup;
    tbsLetterText: TTabSheet;
    LetterTextPageControl: TPageControl;
    RegularLetterTabSheet: TTabSheet;
    LetterTextDBMemo: TwwDBRichEditMSWord;
    Panel1: TPanel;
    LetterTextDBGrid: TDBGrid;
    Panel12: TPanel;
    Label23: TLabel;
    btnNewLetter: TBitBtn;
    WordTabSheet: TTabSheet;
    Panel4: TPanel;
    Panel9: TPanel;
    Label1: TLabel;
    Panel10: TPanel;
    RemoveLetterButton: TBitBtn;
    NewLetterButton: TBitBtn;
    UseWordLettersCheckBox: TCheckBox;
    Panel11: TPanel;
    WordMergeletterGrid: TwwDBGrid;
    Panel5: TPanel;
    MergeFieldsUsedListBox: TListBox;
    Panel6: TPanel;
    Label15: TLabel;
    Panel7: TPanel;
    LetterFileNameLabel: TDBText;
    Panel8: TPanel;
    LetterOleContainer: TOleContainer;
    tbsExemptions: TTabSheet;
    ExListBox: TListBox;
    tbsSwisSchool: TTabSheet;
    Label9: TLabel;
    Label2: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrinterPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveReportOptionsButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SignatureFileSpeedButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure InsertCodeButtonClick(Sender: TObject);
    procedure LetterOleContainerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OLEItemNameTimerTimer(Sender: TObject);
    procedure MergeLetterTableAfterScroll(DataSet: TDataSet);
    procedure btnNewLetterClick(Sender: TObject);
    procedure LetterTextDBMemoDblClick(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
    UnitName : String;
    AssessmentYear : String;
    TrialRun, InsertPercents, InsertDollars  : Boolean;
    PrintedDate : TDateTime;
    EnhancedSTARType,
    IVPEnrollmentStatusType,
    LetterType, ReportType, LettersPrinted : Integer;
    PrintBodyBold : Boolean;

    ReprintLetters,
    UseStandardApprovalLines,
    UsePASGreeting,
    LoadFromParcelList,
    LettersCancelled,
    CreateParcelList : Boolean; {cancels print job}
    ForceLettersToBePrinted : Boolean;
    SBLPrintedList : TStringList;
    SignatureFile : String;
    SignatureXPos, SignatureYPos,
    SignatureHeight, SignatureWidth : Double;
    SignatureImage : TImage;
    slSelectedSchoolCodes, slSelectedSwisCodes,
    LettersNotPrintedDuetoIVP : TStringList;

          {Label variables}

    LabelOptions : TLabelOptions;
    IncludeReasonLines : Boolean;
    RenewalsPreventedList : TStringList;
    MergeFieldsToPrint : TStringList;
    UseWordLetterTemplate, InitializingForm : Boolean;
    LetterExtractFile : TextFile;
    LetterExtractFileName : String;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure InsertInformationIntoMemo(DBMemoBuf : TDBMemoBuf;
                                        SwisSBLKey : String);

    Function EXGetsRenewalLetter(    ExemptionCode : String;
                                     SwisSBLKey : String;
                                     iAutoIncrementID : LongInt;
                                     ParcelHasSeniorExemption,
                                     HomeownerIsEnrolledInIVP : Boolean;
                                 var Quit : Boolean): Boolean;

    Function EXGetsApprovalLetter(    ExemptionCode : String;
                                      SwisSBLKey : String;
                                      iAutoIncrementID : LongInt;
                                      ParcelHasSeniorExemption,
                                      HomeownerIsEnrolledInIVP : Boolean;
                                  var Quit : Boolean): Boolean;

    Function EXGetsDenialLetter(    ExemptionCode : String;
                                    SwisSBLKey : String): Boolean;

    Function EXGetsRenewalReminderLetter(    ExemptionCode : String;
                                             SwisSBLKey : String;
                                             iAutoIncrementID : LongInt;
                                             ParcelHasSeniorExemption,
                                             HomeownerIsEnrolledInIVP : Boolean;
                                         var Quit : Boolean): Boolean;

    Procedure GetExemptions(    SwisSBLKey : String;
                                EXList,
                                EXPercentList,
                                slEXAutoIncrement : TStringList;
                            var HomeownerIsEnrolledInIVP : Boolean;
                            var NumExemptions : Integer);


    Procedure PrintOneLetter(    Sender : TObject;
                                 DBMemoBuf : TDBMemoBuf;
                                 EXPercent : Real;
                                 Amount : Double;
                                 ReasonLines,
                                 ApprovedAtLines : TStringList;
                                 LetterType : Integer;
                             var FirstLetterPrinted : Boolean;
                             var LettersPrinted : Integer);

    Procedure PrintWordLetters;

  end;

{$R *.DFM}

implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Preview,
     Prog, EnStarTy, PRCLLIST, RptDialg, LetterInsertCodesUnit,
     UtilOLE, DataAccessUnit;

const
  ltRenewal = 0;
  ltRenewalReminder = 1;
  ltApproval = 2;
  ltDenial = 3;

  rpLetters = 0;
  rpLabels = 1;

{========================================================}
Procedure TExemptionLetterPrintForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TExemptionLetterPrintForm.InitializeForm;

var
  Quit : Boolean;

begin
  MergeFieldsToPrint := TStringList.Create;
  InitializingForm := True;
  UnitName := 'RPEXMLTR.PAS';  {mmm}

  LettersCancelled := False;

  LetterTextTable.Open;

  OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                             GlblProcessingType, Quit);

  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             GlblProcessingType, Quit);

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             GlblProcessingType, Quit);

  FillOneListBox(ExListBox, ExemptionCodeTable,
                 'EXCode', 'Description', 10,
                 True, True, GlblProcessingType, GetTaxRlYr);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable,
                 'SchoolCode', 'SchoolName',
                 25, True, True, GlblProcessingType, GetTaxRlYr);

  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName', 20,
                 True, True, GlblProcessingType, GetTaxRlYr);

    {Default date to today.}

  DatePrintedEdit.Text := DateToStr(Date);

  SBLPrintedList := TStringList.Create;
  slSelectedSchoolCodes := TStringList.Create;
  slSelectedSwisCodes := TStringList.Create;

  try
    MergeLetterTable.TableName := MergeLetterCodesTableName;
    MergeFieldsAvailableTable.TableName := MergeFieldsAvailableTableName;
    MergeLetterDefinitionsTable.TableName := MergeLetterFieldsTableName;

    MergeLetterTable.Open;
    MergeFieldsAvailableTable.Open;
    MergeLetterDefinitionsTable.Open;

    If (MergeLetterTable.RecordCount > 0)
      then OLEItemNameTimer.Enabled := True;

    InitializingForm := False;

    MergeLetterTableAfterScroll(nil);
  except
    MergeLetterTable.TableName := '';
    MergeFieldsAvailableTable.TableName := '';
    MergeLetterDefinitionsTable.TableName := '';
    WordTabSheet.TabVisible := False;
  end;

  InitializingForm := False;

end;  {InitializeForm}

{====================================================================}
Procedure TExemptionLetterPrintForm.FormKeyPress(    Sender: TObject;
                                                 var Key: Char);

{FXX02292000-2: Don't make Enter move to next control in letter edit.}

begin
  If ((Key = #13) and
      (Screen.ActiveControl.Name <> 'LetterTextDBMemo'))
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{====================================================================}
Procedure TExemptionLetterPrintForm.FormKeyDown(    Sender: TObject;
                                                var Key: Word;
                                                    Shift: TShiftState);
{If they press F2 anywhere on the letter tab, bring up the edit memo.}

begin
  If (Key = VK_F2)
    then LetterTextDBMemo.Execute;

end;  {FormKeyDown}

{====================================================================}
Procedure TExemptionLetterPrintForm.SaveReportOptionsButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}
{FXX03302000-3: Make sure they don't think this is the button to save
                the letter options.}

begin
    {FXX05012000-4: The save\load options does not work for data aware components,
                    so we will trick it by having a mirror edit the contains the
                    letter text code and can be used to relocate to the correct
                    letter.}

  MirrorLetterCodeEdit.Text := LetterTextTable.FieldByName('MainCode').Text;

  If (MessageDlg('Please note that this saves the report options for use again,' + #13 +
                 'but does not save changes to the letter.' + #13 +
                 'If you want to save changes to the letter,' + #13 +
                 'please click the check on the Letter page.' + #13 +
                 'Do you want to proceed with saving the report options?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then SaveReportOptions(Self, OpenDialog, SaveDialog, 'exletter.exl', 'Exemption Letters');

end;  {SaveButtonClick}

{====================================================================}
Procedure TExemptionLetterPrintForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'exletter.exl', 'Exemption Letters');

    {FXX05012000-4: The save\load options does not work for data aware components,
                    so we will trick it by having a mirror edit the contains the
                    letter text code and can be used to relocate to the correct
                    letter.}

  FindKeyOld(LetterTextTable, ['MainCode'],
             [MirrorLetterCodeEdit.Text]);

end;  {LoadButtonClick}

{==============================================================}
Procedure TExemptionLetterPrintForm.SignatureFileSpeedButtonClick(Sender: TObject);

{CHG04242000-1: Add signature file capabilites to ex, generic letters.}

begin
  If SignatureOpenDialog.Execute
    then SignatureFileNameEdit.Text := SignatureOpenDialog.FileName;

end;  {SignatureFileSpeedButtonClick}

{===================================================================}
Procedure TExemptionLetterPrintForm.PrintButtonClick(Sender: TObject);

var
  EXString, NewFileName, NewLabelFileName : String;
  TempFile : File;
  RenewalRequiredSet, Quit,
  Proceed, ShowPrintDialog : Boolean;
  I, ProcessingType : Integer;
  SelectedExemptionCodes, RenewalRequiredList : TStringList;
  Bookmark, Bookmark2 : TBookmark;

begin
  UseWordLetterTemplate := UseWordLettersCheckBox.Checked;
  MergeFieldsToPrint.Assign(MergeFieldsUsedListBox.Items);

    {CHG03172004-1(2.07l2): Allow them to suppress the reason lines.}

  IncludeReasonLines := IncludeReasonLinesCheckBox.Checked;
  LettersNotPrintedDuetoIVP := TStringList.Create;
  RenewalsPreventedList := TStringList.Create;
  InsertPercents := InsertPercentagesCheckBox.Checked;
  InsertDollars := InsertDollarAmountsCheckBox.Checked;
  ReportType := ReportTypeRadioGroup.ItemIndex;

  Application.ProcessMessages;

    {CHG03282002-5: Force letters to be printed for all parcels that have
                    the selected exemption codes.}

  ForceLettersToBePrinted := ForceLettersToBePrintedCheckBox.Checked;
  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

   {CHG10271998-1: If they are printing STAR renewal letters, have
                   option to supress seniors.}

  SelectedExemptionCodes := TStringList.Create;

  LetterType := LetterTypeRadioGroup.ItemIndex;
  LoadFromParcelList := LoadFromParcelListCheckBox.Checked;

  Proceed := True;

    {FXX01092006-1(2.9.4.9): Only put the code in the selected list, not the description.}

  with ExListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then SelectedExemptionCodes.Add(Copy(Items[I], 1, 5));

  FillSelectedItemList(SchoolCodeListBox, slSelectedSchoolCodes, 6);
  FillSelectedItemList(SwisCodeListBox, slSelectedSwisCodes, 6);

  (*If ((SelectedExemptionCodes.IndexOf(EnhancedSTARExemptionCode) > -1) and
      (LetterType = ltRenewal))
    then PrintRenewalsForSeniorsWithSTARs := (MessageDlg('Do you want to print renewals for parcels with ' +
                                                    'enhanced STAR exemptions if they also have a senior exemption?',
                                                    mtConfirmation, [mbYes, mbNo], 0) = idYes); *)

    {FXX12281999-1: Use the enhanced STAR dialog.}
    {FXX05012000-5: Add Enhanced STAR dialog for approvals.}
    {FXX01272006-1(2.9.5.2): Show the enhanced type exemption box even if it is load
                             from parcel list.}

  If ((SelectedExemptionCodes.IndexOf(EnhancedSTARExemptionCode) > -1) and
      (LetterType in [ltRenewal, ltRenewalReminder, ltApproval]))
    then
      begin
        EnhancedSTARTypeDialog.ShowModal;
        EnhancedSTARType := EnhancedSTARTypeDialog.EnhancedSTARType;

          {CHG01212004-1(2.07l): Add ability to select IVP enrollment status as a choice.}

        IVPEnrollmentStatusType := EnhancedSTARTypeDialog.IVPEnrollmentStatusType;

      end;  {If ((not LoadFromParcelList) and...}

    {FXX11151999-6: Review exemption codes for Renewal Required.}

  If (LetterType in [ltRenewal, ltRenewalReminder])
    then
      begin
        RenewalRequiredList := TStringList.Create;
        RenewalRequiredSet := True;

        For I := 0 to (SelectedExemptionCodes.Count - 1) do
          begin
            FindKeyOld(ExemptionCodeTable, ['EXCode'],
                       [SelectedExemptionCodes[I]]);

            If not ExemptionCodeTable.FieldByName('RenewalRequired').AsBoolean
              then
                begin
                  RenewalRequiredSet := False;
                  RenewalRequiredList.Add(SelectedExemptionCodes[I]);
                end;

          end;  {For I := 0 to (SelectedExemptionCodes.Count - 1) do}

        If not RenewalRequiredSet
          then
            begin
              ExString := '';

              For I := 0 to (RenewalRequiredList.Count - 1) do
                begin
                  ExString := ExString + RenewalRequiredList[I];

                  If (I < (RenewalRequiredList.Count - 1))
                    then ExString := ExString + ',';

                end;  {For I := 1 to ExIdx do}

              Proceed := (MessageDlg('The following exemptions do not have the renewal required flag set:' + #13 +
                                      EXString + #13 +
                                      'Do you want to print letters for these exemption codes anyway?',
                                      mtConfirmation, [mbYes, mbNo], 0) = idYes);

            end;  {If not RenewalRequiredSet}

          {Automatically set the renewal required flag if they want.}

        If (Proceed and
            (not RenewalRequiredSet))
          then
            If (MessageDlg('If you would like, PAS will now set the renewal required' + #13 +
                           'flag to True on the exemptions just listed.' + #13 +
                           'Do you want to do this?' + #13 +
                           '(Selecting No cancels the letter print.)',
                            mtConfirmation, [mbYes, mbNo], 0) = idYes)
              then
                begin
                  For I := 0 to (RenewalRequiredList.Count - 1) do
                    with ExemptionCodeTable do
                      try
                        FindKeyOld(ExemptionCodeTable, ['EXCode'],
                                   [RenewalRequiredList[I]]);
                        Edit;
                        FieldByName('RenewalRequired').AsBoolean := True;
                        Post;
                      except
                        SystemSupport(023, ExemptionCodeTable, 'Error updating renewal required flag.',
                                      UnitName, GlblErrorDlgBox);
                      end;

                end
              else Proceed := False;

        RenewalRequiredList.Free;

      end;  {If (LetterType in [ltRenewal, ltRenewalReminder])}

  SelectedExemptionCodes.Free;

  If (LetterTypeRadioGroup.ItemIndex = -1)
   then
     begin
       MessageDlg('Please select a letter type.', mtError, [mbOK], 0);
       Proceed := False;
       LetterTypeRadioGroup.SetFocus;
     end;


  If (PrintOrderRadioGroup.ItemIndex = -1)
   then
     begin
       MessageDlg('Please select a print order.', mtError, [mbOK], 0);
       Proceed := False;
       PrintOrderRadioGroup.SetFocus;
     end;

  If (ExListBox.SelCount <= 0)
    then
      begin
        MessageDlg('Please select one or more exemption codes.', mtError, [mbOK], 0);
        Proceed := False;
        ExListBox.SetFocus;
      end;

  If (AssessmentYearRadioGroup.ItemIndex = -1)
    then
      begin
        MessageDlg('Please select the assessment year.', mtError, [mbOK], 0);
        Proceed := False;
        AssessmentYearRadioGroup.SetFocus;
      end;

    {CHG10141998-3: Allow the user to select what date to print.}

  If Proceed
    then
      try
        PrintedDate := StrToDate(DatePrintedEdit.Text);
      except
        Proceed := False;
        MessageDlg('Please enter a valid printed date.', mtInformation, [mbOK], 0);
      end;

    {FXX10271998-1: Allow user to choose whether or not the body should be bold.}

  PrintBodyBold := PrintLetterBodyBoldCheckBox.Checked;

    {FXX03302000-2: Make sure that the letter text is saved prior to printing.}

  If Proceed
    then
      begin
        If (LetterTextTable.State in [dsEdit, dsInsert])
          then LetterTextTable.Post;

      end;  {If Proceed}

  If Proceed
    then
      begin
        ProcessingType := NoProcessingType;
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

          {Make sure to save the position in the letter text file.}

        Bookmark := LetterTextTable.GetBookmark;
        Bookmark2 := MergeLetterTable.GetBookmark;

        OpenTablesForForm(Self, ProcessingType);

        LetterTextTable.GotoBookmark(Bookmark);
        LetterTextTable.FreeBookmark(Bookmark);

        MergeLetterTable.GotoBookmark(Bookmark2);
        MergeLetterTable.FreeBookmark(Bookmark2);

          {CHG04242000-1: Add signature file capabilites to ex, generic letters.}

        SignatureFile := SignatureFileNameEdit.Text;

        try
          SignatureXPos := StrToFloat(SignatureXPosEdit.Text);
        except
          SignatureXPos := 0;
        end;

        try
          SignatureYPos := StrToFloat(SignatureYPosEdit.Text);
        except
          SignatureYPos := 0;
        end;

          {FXX05012000-1: Need height and width for sig files.}

        try
          SignatureHeight := StrToFloat(SignatureHeightEdit.Text);
        except
          SignatureHeight := 0.5;
        end;

        try
          SignatureWidth := StrToFloat(SignatureWidthEdit.Text);
        except
          SignatureWidth := 2.25;
        end;

        If (Deblank(SignatureFile) <> '')
          then
            begin
              SignatureImage := TImage.Create(nil);
              SignatureImage.Picture.LoadFromFile(SignatureFile);
            end;

          {FXX05191998-8: Add trial run feature.}

        TrialRun := TrialRunCheckBox.Checked;

          {FXX05191998-7: Need to reset LettersCancelled var.
                          to print 2 times in row.}

        LettersCancelled := False;

        ShowPrintDialog := True;

        If (UseWordLetterTemplate and
            (ReportType = rpLetters))
          then
            begin
              LetterExtractFileName := GetPrintFileName('ExemptionLetter', True);

              try
                AssignFile(LetterExtractFile, LetterExtractFileName);
                Rewrite(LetterExtractFile);
              except
              end;

                {Create the header record.}

              For I := 0 to (MergeFieldsToPrint.Count - 1) do
                begin
                  If (I > 0)
                    then Write(LetterExtractFile, ',');

                  Write(LetterExtractFile, '"', MergeFieldsToPrint[I], '"');

                end;  {For I := 0 to (MergeFieldsToPrint.Count - 1) do}

              Writeln(LetterExtractFile);

              ShowPrintDialog := False;

            end;  {If (UseWordLetterTemplate and ...}

        If ((ShowPrintDialog and
             PrintDialog.Execute) or
            (not ShowPrintDialog))
          then
            begin
              CreateParcelList := CreateParcelListCheckBox.Checked;
              If CreateParcelList
                then ParcelListDialog.ClearParcelGrid(True);

                {FXX05031999-1: Reprint letters if they want.}

              ReprintLetters := ReprintCheckBox.Checked;
              UseStandardApprovalLines := UseStandardApprovalPercentLineCheckBox.Checked;
              UsePASGreeting := PrintGreetingLineCheckBox.Checked;

                {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}
                {CHG01212004-2(MDT): Have option to print letters or labels.}

              PrintButton.Enabled := False;

              case ReportType of
                rpLetters :
                  begin
                    AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

                    If not Quit
                      then
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

                                  {CHG01182000-3: Allow them to choose a different name or copy right away.}
                                  {However, we can only do it if they print to screen first since
                                   report printer does not generate a file.}

                                ShowReportDialog('EXEMPLTR.LTR', ReportFiler.FileName, True);

                              end;  {If PrintRangeDlg.PreviewPrint}

                            end  {They did not select preview, so we will go
                                  right to the printer.}
                          else ReportPrinter.Execute;

                    If UseWordLetterTemplate
                      then
                        begin
                          CloseFile(LetterExtractFile);

                          If _Compare(LettersPrinted, 0, coEqual)
                            then ShowMessage('There were no letters to print.')
                            else PrintWordLetters;

                        end;  {If UseWordLetterTemplate}

                  end;  {rpLetters}

                rpLabels :
                  If ExecuteLabelOptionsDialog(LabelOptions)
                   then
                     begin
                         {FXX10102003-1(2.07j1): Make sure to reset to letter paper after printing the
                                                 search report.}

                       ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
                       ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);

                       If PrintDialog.PrintToFile
                         then
                           begin
                             NewLabelFileName := GetPrintFileName(Self.Caption, True);
                             GlblPreviewPrint := True;
                             GlblDefaultPreviewZoomPercent := 70;
                             ReportFiler.FileName := NewLabelFileName;

                             try
                               PreviewForm := TPreviewForm.Create(self);
                               PreviewForm.FilePrinter.FileName := NewLabelFileName;
                               PreviewForm.FilePreview.FileName := NewLabelFileName;
                               ReportFiler.Execute;
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
                         else ReportPrinter.Execute;

                     end;  {If ExecuteLabelOptionsDialog(lb_PrintLabelsBold, ...}

              end;  {case ReportType of}

              If CreateParcelList
                then ParcelListDialog.Show;

              ResetPrinter(ReportPrinter);

                {CHG04112001-1: If this was a trial run, warn them.}

              If TrialRun
                then MessageDlg('Warning! You just ran the letters in trial run mode.' + #13 +
                                'The date sent was not recorded on the exemption.' + #13 +
                                'If you want the date to appear on the exemption,' + #13 +
                                'rerun the letters without the trial run checked.', mtWarning, [mbOK], 0);


            end;  {If PrintDialog.Execute}

        If (Deblank(SignatureFile) <> '')
          then SignatureImage.Free;

      end; {end if Proceed}

  LettersNotPrintedDuetoIVP.Free;
  RenewalsPreventedList.Free;

  PrintButton.Enabled := True;

end;  {PrintButtonClick}

{=========================================================================}
Procedure TExemptionLetterPrintForm.ReportPrintHeader(Sender: TObject);

var
  NAddrArray : NameAddrArray;

begin
  case ReportType of
    rpLetters :
      begin
        GetNameAddress(ParcelTable, NAddrArray);

        PrintLetterHeader(Sender, AssessorOfficeTable, NAddrArray,
                          LetterHeadCheckBox.Checked, PrintedDate, False);

      end;  {rpLetters}

    rpLabels : PrintLabelHeader(Sender, LabelOptions);

  end;  {case ReportType of}

end;  {ReportPrintHeader}

{==================================================================================}
Function ExemptionMeetsEnhancedSTARCriteria(EnhancedSTARType,
                                            IVPEnrollmentStatusType : Integer;
                                            ParcelHasSeniorExemption,
                                            HomeownerIsEnrolledInIVP : Boolean) : Boolean;

begin
  Result := False;

    {FXX01102006-1(2.9.4.8): If they choose either exemption type,
                             the result should default to true.} 

  case EnhancedSTARType of
    enSeniorSTAROnly : Result := (not ParcelHasSeniorExemption);
    enWithSeniorandSTARExemption : Result := ParcelHasSeniorExemption;
    enAnySeniorSTAR : Result := True;
  end;  {case EnhancedSTARType of}

    {CHG01212004-1(2.07l): Add ability to select IVP enrollment status as a choice.}

  If Result
    then
      case IVPEnrollmentStatusType of
        ivpEnrolledOnly : Result := HomeownerIsEnrolledInIVP;
        ivpNotEnrolledOnly : Result := (not HomeownerIsEnrolledInIVP);
      end;  {case IVPEnrollmentStatusType of}

end;  {ExemptionMeetsEnhancedSTARCriteria}

{==================================================================================}
Function TExemptionLetterPrintForm.ExGetsRenewalLetter(    ExemptionCode : String;
                                                           SwisSBLKey : String;
                                                           iAutoIncrementID : LongInt;
                                                           ParcelHasSeniorExemption,
                                                           HomeownerIsEnrolledInIVP : Boolean;
                                                       var Quit :Boolean): Boolean;

var
  I : Integer;
  GetsLetter : boolean;

begin
  GetsLetter := False;

  For I := 0 to (ExListBox.Items.Count - 1) do
    If ((Copy(ExListBox.Items[I], 1, 5) = ExemptionCode) and
        EXListBox.Selected[I])
      then GetsLetter := True;

   {CHG10271998-1: If they are printing STAR renewal letters, have
                   option to supress seniors.}
   {FXX12281999-1: Use the enhanced STAR dialog.}

  If (GetsLetter and
      (ExemptionCode = EnhancedSTARExemptionCode))
    then GetsLetter := ExemptionMeetsEnhancedSTARCriteria(EnhancedSTARType,
                                                          IVPEnrollmentStatusType,
                                                          ParcelHasSeniorExemption,
                                                          HomeownerIsEnrolledInIVP);

  If GetsLetter
    then
      begin
        GetsLetter := False;

        with ParcelExemptionTable do
          If (_Locate(ExemptionCodeTable, [ExemptionCode], '', []) and
              ExemptionCodeTable.FieldByName('RenewalRequired').AsBoolean and
              _Locate(ParcelExemptionTable, [iAutoIncrementID], '', []))
            then
              begin
                   {FXX05191998-4: Don't print if already printed.}
                   {FXX05031999-1: Reprint letters if they want.}
                    {CHG03282002-5: Force letters to be printed for all parcels that have
                                    the selected exemption codes.}

                If ((not FieldByName('RenewalPrinted').AsBoolean) or
                    ReprintLetters or
                    ForceLettersToBePrinted)
                  then GetsLetter := True;

                  {CHG07212003-1(2.07g): Don't print enhanced STARs in the IVP program.
                                         Save them up to print out later.}

                If (GetsLetter and
                    ExemptionIsEnhancedSTAR(ExemptionCode) and
                    FieldByName('AutoRenew').AsBoolean)
                  then
                    begin
                      GetsLetter := False;
                      LettersNotPrintedDuetoIVP.Add(SwisSBLKey);
                    end;

                  {CHG03182004-1(2.08): Allow for prevention of renewals on individual exemptions.
                                        Used for volunteer firefighter.}

                If (GetsLetter and
                    FieldByName('PreventRenewal').AsBoolean)
                  then
                    begin
                      GetsLetter := False;
                      RenewalsPreventedList.Add(SwisSBLKey);
                    end;

              end;  {If (ExemptionCodeTable...}

      end;  {If GetsLetter}

    {If they get a letter, then mark it as having been printed.}
    {FXX05191998-8: Add trial run feature.}

  If (GetsLetter and
      (not TrialRun))
    then
      with ParcelExemptionTable do
        begin
          Edit;
          FieldByName('RenewalPrinted').AsBoolean := True;
          FieldByName('DateRenewalPrinted').AsDateTime := Date;

          try
            Post;
          except
            SystemSupport(009, ParcelExemptionTable,
                          'Error updating record ', UnitName, GlblErrorDlgBox);
            Abort;
          end;  {end try}

        end;  {with ParcelExemptionTable do}

  Result := GetsLetter;

end;  {ExGetsRenewalLetter}

{==================================================================================}
Function TExemptionLetterPrintForm.ExGetsRenewalReminderLetter(    ExemptionCode : String;
                                                                   SwisSBLKey : String;
                                                                   iAutoIncrementID : LongInt;
                                                                   ParcelHasSeniorExemption,
                                                                   HomeownerIsEnrolledInIVP : Boolean;
                                                               var Quit : Boolean): Boolean;

var
  I : Integer;
  GetsLetter : boolean;

begin
  GetsLetter := False;

    {first see if user wanted this ex code to get an ex letter}

  For I := 0 to (ExListBox.Items.Count-1) do
    If ((Copy(ExListBox.Items[I], 1, 5) = ExemptionCode) and
        EXListBox.Selected[I])
      then GetsLetter := True;

    {FXX05012000-5: Add Enhanced STAR dialog for approvals.}

  If (GetsLetter and
      (ExemptionCode = EnhancedSTARExemptionCode))
    then GetsLetter := ExemptionMeetsEnhancedSTARCriteria(EnhancedSTARType,
                                                          IVPEnrollmentStatusType,
                                                          ParcelHasSeniorExemption,
                                                          HomeownerIsEnrolledInIVP);

  If GetsLetter
    then
      begin
        GetsLetter := False;

        with ParcelExemptionTable do
          If (_Locate(ExemptionCodeTable, [ExemptionCode], '', []) and
              _Locate(ParcelExemptionTable, [iAutoIncrementID], '', []))
            then
              begin
                   {CHG03282002-5: Force letters to be printed for all parcels that have
                                   the selected exemption codes.}
                   {FXX10302002-1: Exclude ones where the exemption was approved.}

                If (ForceLettersToBePrinted or
                    (FieldByName('RenewalPrinted').AsBoolean and
                     ((not (FieldByName('RenewalReceived').AsBoolean or
                            FieldByName('ExemptionApproved').AsBoolean)) or
                      ReprintLetters)))
                  then GetsLetter := True;

              end;  {If (_Locate(ExemptionCodeTable ...}

      end;  {If GetsLetter}

    {If they get a letter, then mark it as having been printed.}
    {FXX05191998-8: Add trial run feature.}
    {FXX09132001-6: Mark the renewal reminder fields.}

  If (GetsLetter and
      (not TrialRun))
    then
      with ParcelExemptionTable do
        begin
          Edit;
          FieldByName('ReminderPrinted').AsBoolean := True;
          FieldByName('DateReminderPrinted').AsDateTime := Date;

          try
            Post;
          except
            SystemSupport(009, ParcelExemptionTable,
                          'Error updating record ', UnitName, GlblErrorDlgBox);
            Abort;
          end;  {end try}

        end;  {with ParcelExemptionTable do}

  Result := GetsLetter;

end;  {ExGetsRenewalReminderLetter}

{==================================================================================}
Function TExemptionLetterPrintForm.ExGetsApprovalLetter(    ExemptionCode : String;
                                                            SwisSBLKey : String;
                                                            iAutoIncrementID : LongInt;
                                                            ParcelHasSeniorExemption,
                                                            HomeownerIsEnrolledInIVP : Boolean;
                                                        var Quit : Boolean): Boolean;

var
  I : Integer;
  GetsLetter : boolean;

begin
  GetsLetter := False;

    {first see if user wanted this ex code to get an ex letter}

  For I := 0 to (ExListBox.Items.Count-1) do
    If ((Copy(ExListBox.Items[I], 1, 5) = ExemptionCode) and
        EXListBox.Selected[I])
      then GetsLetter := True;

    {FXX05012000-5: Add Enhanced STAR dialog for approvals.}

  If (GetsLetter and
      (ExemptionCode = EnhancedSTARExemptionCode))
    then GetsLetter := ExemptionMeetsEnhancedSTARCriteria(EnhancedSTARType,
                                                          IVPEnrollmentStatusType,
                                                          ParcelHasSeniorExemption,
                                                          HomeownerIsEnrolledInIVP);

    {then see if ex codce allows letter}

  If GetsLetter
    then
      begin
        GetsLetter := False;

        with ParcelExemptionTable do
          If (_Locate(ExemptionCodeTable, [ExemptionCode], '', []) and
              _Locate(ParcelExemptionTable, [iAutoIncrementID], '', []))
            then
              begin
                   {FXX05191998-4: Don't print if already printed.}
                   {FXX05031999-1: Reprint letters if they want.}
                   {CHG03282002-5: Force letters to be printed for all parcels that have
                                   the selected exemption codes.}

                If (ForceLettersToBePrinted or
                    (FieldByName('ExemptionApproved').AsBoolean and
                     ((not FieldByName('ApprovalPrinted').AsBoolean) or
                      ReprintLetters)))
                  then GetsLetter := True;

              end;  {If (_Locate(ExemptionCodeTable}

      end;  {If GetsLetter}

    {If they get a letter, then mark it as having been printed.}

    {FXX05191998-8: Add trial run feature.}

  If (GetsLetter and
      (not TrialRun))
    then
      with ParcelExemptionTable do
        begin
          Edit;
          FieldByName('ApprovalPrinted').AsBoolean := True;
          FieldByName('DateApprovalPrinted').AsDateTime := Date;

          try
            Post;
          except
            SystemSupport(009, ParcelExemptionTable,
                          'Error updating record ', UnitName, GlblErrorDlgBox);
            Abort;
          end;  {end try}

        end;  {with ParcelExemptionTable do}

  Result := GetsLetter;

end;  {ExGetsApprovalLetter}

{==================================================================================}
Function TExemptionLetterPrintForm.ExGetsDenialLetter(    ExemptionCode : String;
                                                          SwisSBLKey : String): Boolean;

var
  I : Integer;
  GetsLetter : boolean;

begin
  GetsLetter := False;

    {first see if user wanted this ex code to get an ex letter}

  For I := 0 to (ExListBox.Items.Count-1) do
    If ((Copy(ExListBox.Items[I], 1, 5) = ExemptionCode) and
        EXListBox.Selected[I])
      then GetsLetter := True;

  If GetsLetter
    then
      begin
        GetsLetter := False;

           {CHG03282002-5: Force letters to be printed for all parcels that have
                           the selected exemption codes.}

        with ExemptionDenialTable do
          If (ForceLettersToBePrinted or
              (not FieldByName('DenialPrinted').AsBoolean) or
               ReprintLetters)
            then GetsLetter := True;

      end;  {If GetsLetter}

    {If they get a letter, then mark it as having been printed.}

  If (GetsLetter and
      (not TrialRun))
    then
      with ExemptionDenialTable do
        begin
          Edit;
          FieldByName('DenialPrinted').AsBoolean := True;
          FieldByName('PrintedDate').AsDateTime := Date;

          try
            Post;
          except
            SystemSupport(009, ExemptionDenialTable,
                          'Error updating record ', UnitName, GlblErrorDlgBox);
            Abort;
          end;  {end try}

        end;  {with ParcelExemptionTable do}

  Result := GetsLetter;

end;  {ExGetsDenialLetter}

{========================================================}
Procedure TExemptionLetterPrintForm.GetExemptions(    SwisSBLKey : String;
                                                      EXList,
                                                      EXPercentList,
                                                      slEXAutoIncrement : TStringList;
                                                  var HomeownerIsEnrolledInIVP : Boolean;
                                                  var NumExemptions : Integer);

var
  FirstTimeThroughExemptions, DoneExemptions : Boolean;

begin
  HomeownerIsEnrolledInIVP := False;
  NumExemptions := 0;

  ExList.Clear;
  EXPercentList.Clear;
  slEXAutoIncrement.Clear;

   {get all ex codes for this parcel}

    {FXX11251997-3: We were doing a FindKey on TaxYear, SBLKey,
                    but the key was tax year, sbl key, ex code,
                    so we weren't getting anything. So, I
                    am doing a SetRange instead.}

  SetRangeOld(ParcelExemptionSearchTable,
              ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [AssessmentYear, SwisSBLKey, '     '],
              [AssessmentYear, SwisSBLKey, 'ZZZZZ']);

  FirstTimeThroughExemptions := True;
  DoneExemptions := False;

   {if found one or more exmeptions, read em into array and see
    if get letter}

  repeat
    If FirstTimeThroughExemptions
      then FirstTimeThroughExemptions := False
      else ParcelExemptionSearchTable.Next;

    If ParcelExemptionSearchTable.EOF
      then DoneExemptions := True
      else
        with ParcelExemptionSearchTable do
          begin
            Exlist.Add(FieldByName('ExemptionCode').Text);
            ExPercentList.Add(FieldByName('Percent').Text);
            slEXAutoIncrement.Add(FieldByName('AutoIncrementID').AsString);
            NumExemptions := NumExemptions + 1;

            If FieldByName('AutoRenew').AsBoolean
              then HomeownerIsEnrolledInIVP := True;

          end;  {else of If ParcelExemptionSearchTable.EOF}

  until DoneExemptions;

end;  {GetExemptions}

{=========================================================================}
Procedure TExemptionLetterPrintForm.InsertCodeButtonClick(Sender: TObject);

{CHG01082004-1(MDT): Add letter inserts.}

begin
  try
    LetterInsertCodesForm := TLetterInsertCodesForm.Create(nil);
    LetterInsertCodesForm.ShowModal;
  finally
    LetterInsertCodesForm.Free;
  end;

end;  {InsertCodeButtonClick}

{==================================================================}
Procedure InsertOneItem(DBMemoBuf : TDBMemoBuf;
                        InsertName : String;
                        Table : TTable;
                        FieldName : String);

{CHG01082004-1(2.07l): Allow for inserts.}

var
  FoundInsertCommand : Boolean;
  TempValue : String;

begin
  FoundInsertCommand := DBMemoBuf.SearchFirst(InsertName, False);

  If FoundInsertCommand
    then
      repeat
        DBMemoBuf.Delete(DBMemoBuf.Pos, Length(InsertName));

        If (Table = nil)
          then TempValue := FieldName
          else TempValue := Table.FieldByName(FieldName).Text;

        DBMemoBuf.Insert(DBMemoBuf.Pos, TempValue);

        FoundInsertCommand := DBMemoBuf.SearchNext;

      until (not FoundInsertCommand);

  DBMemoBuf.Pos := 0;

end;  {InsertOneItem}

{==================================================================}
Procedure TExemptionLetterPrintForm.InsertInformationIntoMemo(DBMemoBuf : TDBMemoBuf;
                                                              SwisSBLKey : String);

{CHG11142003-1(2.07k): Allow for inserts.}

var
  FirstName, LastName : String;

begin
  InsertOneItem(DBMemoBuf, ParcelIDInsert, nil, ConvertSwisSBLToDashDot(SwisSBLKey));

  InsertOneItem(DBMemoBuf, LegalAddressInsert, nil, GetLegalAddressFromTable(ParcelTable));

  InsertOneItem(DBMemoBuf, OwnerInsert, ParcelTable, 'Name1');

    {CHG03172004-2(2.07l2): Add first name and last name inserts.}

  ParseName(ParcelTable.FieldByName('Name1').Text, FirstName, LastName);
  InsertOneItem(DBMemoBuf, FirstNameInsert, nil, FirstName);
  InsertOneItem(DBMemoBuf, LastNameInsert, nil, LastName);

end;  {InsertInformationIntoMemo}

{======================================================================}
Procedure AddMergeFieldsToExtractFile(var LetterExtractFile : TextFile;
                                          Form : TForm;
                                          MergeFieldsToPrint : TStringList;
                                          ParcelTable,
                                          MergeFieldsAvailableTable,
                                          tbExemptionCodes : TTable;
                                          NAddrArray : NameAddrArray;
                                          AssessmentYear : String;
                                          SwisSBLKey : String;
                                          sExemptionCode : String;
                                          LetterDate : TDateTime);

var
  I, J, iProcessingType : Integer;
  MergeFieldName, FieldValue,
  sTableName, sFieldName, sComponentTableName : String;

begin
  iProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);
  For I := 0 to (MergeFieldsToPrint.Count - 1) do
    begin
      FindKeyOld(MergeFieldsAvailableTable, ['MergeFieldName'],
                 [MergeFieldsToPrint[I]]);

      with MergeFieldsAvailableTable do
        begin
          MergeFieldName := FieldByName('MergeFieldName').Text;
          sFieldName := FieldByName('FieldName').AsString;

          If _Compare(FieldByName('TableName').Text, 'Special', coEqual)
            then
              begin
                If _Compare(MergeFieldName, 'ThisYear', coEqual)
                  then FieldValue := GlblThisYear;

                If _Compare(MergeFieldName, 'NextYear', coEqual)
                  then FieldValue := GlblNextYear;

                If _Compare(MergeFieldName, 'ParcelID', coEqual)
                  then FieldValue := ConvertSwisSBLToDashDot(SwisSBLKey);

                If _Compare(MergeFieldName, 'ParcelID_No_Swis', coEqual)
                  then FieldValue := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                If _Compare(MergeFieldName, 'LegalAddress', coEqual)
                  then FieldValue := GetLegalAddressFromTable(ParcelTable);

                If _Compare(MergeFieldName, 'Name1', coEqual)
                  then FieldValue := NAddrArray[1];

                If _Compare(MergeFieldName, 'Name2', coEqual)
                  then FieldValue := NAddrArray[2];

                If _Compare(MergeFieldName, 'Address1', coEqual)
                  then FieldValue := NAddrArray[3];

                If _Compare(MergeFieldName, 'Address2', coEqual)
                  then FieldValue := NAddrArray[4];

                If _Compare(MergeFieldName, 'Address3', coEqual)
                  then FieldValue := NAddrArray[5];

                If _Compare(MergeFieldName, 'Address4', coEqual)
                  then FieldValue := NAddrArray[6];

                If _Compare(MergeFieldName, 'LetterDate', coEqual)
                  then FieldValue := DateToStr(LetterDate);

                If _Compare(MergeFieldName, 'DenialExemptionDesc', coEqual)
                  then
                    If _Locate(tbExemptionCodes, [sExemptionCode], '', [])
                      then FieldValue := tbExemptionCodes.FieldByName('Description').AsString;

(*                If _Compare(MergeFieldName, 'PriorValue', coEqual)
                  then FieldValue := FormatFloat(CurrencyNormalDisplay,
                                                 (PriorHstdAssessedValue +
                                                  PriorNonhstdAssessedValue)); *)

              end  {If (FieldByName('TableName').Text = 'Special')}
            else
              begin
                sTableName := MergeFieldsAvailableTable.FieldByName('TableName').AsString;

                If _Compare(iProcessingType, NextYear, coEqual)
                  then sTableName[1] := 'n';

                with Form do
                  For J := 0 to (ComponentCount - 1) do
                    If (Components[J] is TTable)
                      then
                        begin
                          sComponentTableName := TTable(Components[J]).TableName;

                          If _Compare(sComponentTableName, sTableName, coEqual)
                            then
                              try
                                FieldValue := TTable(Components[J]).FieldByName(sFieldName).AsString;
                              except
                              end;

                        end;  {If (Components[I] is TTable)}

(*                    If ((Components[I] is TTable) and
                        _Compare(TTable(Components[I]).TableName, sTableName, coEqual))
                      then
                        try
                          FieldValue := TTable(Components[I]).FieldByName(MergeFieldName).AsString;
                        except
                        end; *)

              end;  {else of }

          If _Compare(FieldByName('TableName').Text, 'ParcelTable', coEqual)
            then
              try
                FieldValue := ParcelTable.FieldByName(sFieldName).Text;
              except
                FieldValue := '';
              end;

        end;  {with MergeFieldsAvailableTable do}

      If (I > 0)
        then Write(LetterExtractFile, ',');

      Write(LetterExtractFile, '"', FieldValue, '"');

    end;  {For I := 0 to (MergeFieldsToAdd.Count - 1) do}

  Writeln(LetterExtractFile);

end;  {AddMergeFieldsToExtractFile}

{=========================================================================}
Procedure TExemptionLetterPrintForm.PrintOneLetter(    Sender : TObject;
                                                       DBMemoBuf : TDBMemoBuf;
                                                       EXPercent : Real;
                                                       Amount : Double;
                                                       ReasonLines,
                                                       ApprovedAtLines : TStringList;
                                                       LetterType : Integer;
                                                   var FirstLetterPrinted : Boolean;
                                                   var LettersPrinted : Integer);

var
  TempFormat : String;
  NAddrArray : NameAddrArray;
  I : Integer;
  SwisSBLKey, sExemptionCode : String;

begin
  GetNameAddress(ParcelTable, NAddrArray);
  SwisSBLKey := ExtractSSKey(ParcelTable);
  If CreateParcelList
    then ParcelListDialog.AddOneParcel(SwisSBLKey);

  Inc(LettersPrinted);
  ProgressDialog.UserLabelCaption := 'Letters Printed = ' + IntToStr(LettersPrinted);

  If UseWordLetterTemplate
    then
      begin
        If (LetterType = ltDenial)
          then sExemptionCode := ExemptionDenialTable.FieldByName('ExemptionCode').AsString
          else sExemptionCode := ParcelExemptionTable.FieldByName('ExemptionCode').AsString;

        AddMergeFieldsToExtractFile(LetterExtractFile, Self, MergeFieldsToPrint,
                                    ParcelTable, MergeFieldsAvailableTable,
                                    ExemptionCodeTable, NAddrArray, AssessmentYear,
                                    SwisSBLKey, sExemptionCode, PrintedDate);

      end
    else
      with Sender as TBaseReport do
        begin
          If not FirstLetterPrinted
            then FirstLetterPrinted := True
            else NewPage;

          ClearTabs;
          SetTab(1.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {letter addr}

            {FXX05201998-3: This is where the name and
                            addr should start for a
                            windowed envelope.}

          GotoXY(1.0, GlblLetterAddressStart);

          For I := 1 to 6 do
            PrintLn(#9 + NAddrArray[I]);

          CRLF;

            {FXX10271998-1: Allow user to choose whether or not the body should be bold.}

          Bold := PrintBodyBold;

           {FXX05201998-1: We want to print all exemptions that
                           apply on one letter, i.e. if have 41802
                           and 41806, only print one letter.}

          For I := 0 to (ReasonLines.Count - 1) do
            Println(#9 + ReasonLines[I]);

            {FXX05191998-10: Switch the dear property owner line
                             to before the line which prints
                             the percent.}

          CRLF;
          Bold := PrintBodyBold;

            {FXX04231999-2: Allow the user to choose if they
                            want to use PAS's greeting.}

          If UsePASGreeting
            then
              begin
                Println(#9 + 'Dear Property Owner:');
                CRLF;
              end;

            {FXX05201998-1: We want to print all exemptions that
                            apply on one letter, i.e. if have 41802
                            and 41806, only print one letter.}
            {FXX04231999-1: Allow % to be an insert.}

          If UseStandardApprovalLines
            then
              For I := 0 to (ApprovedAtLines.Count - 1) do
                Println(#9 + ApprovedAtLines[I]);

          ClearTabs;
          SetTab(1.0, pjLeft, 8.0,0, BOXLINENONE, 0);   {letter text}

            {FXX11301997-2: Don't do a take on the text - it
                            is already the right size since
                            it was entered in a memo box
                            that was narrower than the page.}

          (*For I := 0 to LinesLeft do
            Println(#9 + LtrTextDBMemo.Lines[I]);*)

            {FXX04231999-1: Allow % to be an insert.}

    (*      If not UseStandardApprovalLines
            then
              begin
                  {Save the original.}
                  {FXX12151999-4: Make sure that the temp file is created in the report
                                  directory and deleted afterwards.}

                LetterTextTableLetterText.SaveToFile(ExpandPASPath(GlblReportDir) + 'TEMP.TXT');

                with LetterTextDBMemo do
                  For I := 0 to (Lines.Count - 1) do
                    begin
                      PercentPos := Pos('%', Lines[I]);
                      OrigLine := Lines[I];

                      If ((PercentPos > 0) and
                          (not (OrigLine[PercentPos - 1] in Numbers)))
                        then
                          begin
                              {FXX05041999-1: Make a 0 percent 100%.}

                            If (Roundoff(EXPercent, 0) = 0)
                              then EXPercent := 100;

                            TempStr := Copy(Lines[I], 1, (PercentPos - 1)) +
                                       FormatFloat(NoDecimalDisplay_BlankZero,
                                                   EXPercent) +
                                       Copy(Lines[I], PercentPos, 255);

                            Lines[I] := TempStr;
                            Index := I;

                          end;  {If (PercentPos > 0)}

                        {CHG10312000-1: Allow dollar insert for exemption amount - take
                                        the default amount.}

                      DollarSignPos := Pos('$', Lines[I]);
                      OrigLine := Lines[I];

                      If ((DollarSignPos > 0) and
                          (not (OrigLine[DollarSignPos - 1] in Numbers)))
                        then
                          begin
                            TempStr := Copy(Lines[I], 1, (DollarSignPos - 1)) +
                                       FormatFloat(CurrencyNormalDisplay,
                                                   Amount) +
                                       Copy(Lines[I], (DollarSignPos + 1), 255);  {Don't print dollar sign again.}

                            Lines[I] := TempStr;
                            Index := I;

                          end;  {If (PercentPos > 0)}

                    end;  {with LetterTextTableLetterText do}

                AssignFile(TempFile, 'TEMP.TXT');
                Rewrite(TempFile);
                with LetterTextDBMemo do
                  For I := 0 to (Lines.Count - 1) do
                    Writeln(TempFile, Lines[I]);
                CloseFile(TempFile);

                LetterTextTable.Edit;
                LetterTextTableLetterText.LoadFromFile('TEMP.TXT');
                OldDeleteFile(ExpandPASPath(GlblReportDir) + 'TEMP.TXT');

              end;  {If not UseStandardApprovalPercentLineCheckBox} *)

          DBMemoBuf.RTFField := LetterTextTableLetterText;

            {CHG06042001-1: Need to change the way we insert the amount and percent into
                            the letters in order to accomodate rich text.}

          If not UseStandardApprovalLines
            then
              begin
                  {Check for percents.}
                  {CHG02072002-1: Allow them to decide whether or not they want to insert the percents and dollars.}

                If (InsertPercents and
                    DBMemoBuf.SearchFirst('%', False))
                  then
                    begin
                      DBMemoBuf.Delete(DBMemoBuf.Pos, 1);  {Delete the % sign.}
                      If (Roundoff(EXPercent, 0) = 0)
                        then EXPercent := 100;

                        {FXX04252005-1(2.8.4.2): If the exemption percent is not integer, show decimals.}

                      If _Compare(Trunc(EXPercent * 100), (Trunc(EXPercent) * 100), coEqual)
                        then TempFormat := NoDecimalDisplay
                        else TempFormat := DecimalEditDisplay;

                      DBMemoBuf.Insert(DBMemoBuf.Pos, FormatFloat(TempFormat, EXPercent) + '%');
                      DBMemoBuf.Pos := 0;

                    end;  {If DBMemo.SearchFirst('%', False)}

                 {Check for $}

                If (InsertDollars and
                    DBMemoBuf.SearchFirst('$', False))
                  then
                    begin
                      DBMemoBuf.Delete(DBMemoBuf.Pos, 1);  {Delete the % sign.}
                      DBMemoBuf.Insert(DBMemoBuf.Pos, '$' +
                                                      FormatFloat(CurrencyDisplayNoDollarSign,
                                                                  Amount));
                      DBMemoBuf.Pos := 0;

                    end;  {If DBMemo.SearchFirst('%', False)}

              end;  {If not UseStandardApprovalLines}

            {FXX11052001-3: Make sure that the reason is printed for the denial.}

          If ((LetterType = ltDenial) and
              DBMemoBuf.SearchFirst('^D', False))
            then
              begin
                DBMemoBuf.Delete(DBMemoBuf.Pos, 2);  {Delete the ^D sign.}
                DBMemoBuf.Insert(DBMemoBuf.Pos, ExemptionDenialTable.FieldByName('Reason').AsString);
                DBMemoBuf.Pos := 0;

              end;  {If DBMemo.SearchFirst('%', False)}

            {FXX11021999-13: Allow the letter left margin to be customized.}

          DBMemoBuf.PrintStart := GlblLetterLeftMargin;
          DBMemoBuf.PrintEnd := 8.2;

            {CHG01082004-1(2.07l): Allow for inserts.}

          InsertInformationIntoMemo(DBMemoBuf, SwisSBLKey);

          PrintMemo(DBMemoBuf, 0, False);

    (*      If not UseStandardApprovalLines
            then
              begin
                LetterTextDBMemo.Lines[Index] := OrigLine;
                LetterTextTable.Cancel;
              end; *)

            {CHG02292000-1: Signature files}
            {FXX05012000-1: Need height and width for sig files.}
            {FXX06042001-2: Wrong variable for width and height}

          If (Deblank(SignatureFile) <> '')
            then PrintBitmapRect(SignatureXPos, SignatureYPos,
                                 SignatureXPos + SignatureWidth,
                                 SignatureYPos + SignatureHeight,
                                 SignatureImage.Picture.Bitmap);

        end;  {with Sender as TBaseReport do}

end;  {PrintOneLetter}

{============================================================================}
Procedure TExemptionLetterPrintForm.PrintWordLetters;

{CHG05202003-1(2.07b): Word Template for change letters.}

var
  FileExtension, NewFileName : String;
  ExtensionPos : Integer;

begin
  try
    LetterOLEContainer.DestroyObject;
  except
  end;

  SendTextFileToExcelSpreadsheet(LetterExtractFileName, False,
                                 True, ChangeFileExt(LetterExtractFileName, '.XLS'));

    {FXX08192002-1: First copy the merge document to a template to avoid
                    MS Word associating the template with a particular Excel file.}

  FileExtension := ExtractFileExt(MergeLetterTable.FieldByName('FileName').Text);
  NewFileName := MergeLetterTable.FieldByName('FileName').Text;
  ExtensionPos := Pos(FileExtension, NewFileName);
  Delete(NewFileName, ExtensionPos, 200);
  NewFileName := NewFileName + '_Template' + FileExtension;

  CopyOneFile(MergeLetterTable.FieldByName('FileName').Text, NewFileName);

  PerformWordMailMerge(NewFileName,
                       ChangeFileExt(LetterExtractFileName, '.XLS'));

end;  {PrintWordLetters}

{==================================================================}
Function RecordInRange(tbParcels : TTable;
                       slSelectedSwisCodes : TStringList;
                       slSelectedSchoolCodes : TStringList) : Boolean;

begin
  Result := _Compare(slSelectedSwisCodes.IndexOf(tbParcels.FieldByName('SwisCode').AsString), 0, coGreaterThanOrEqual) and
            _Compare(slSelectedSchoolCodes.IndexOf(tbParcels.FieldByName('SchoolCode').AsString), 0, coGreaterThanOrEqual);
            
end;  {RecordInRange}

{========================================================}
Procedure TExemptionLetterPrintForm.ReportPrinterPrint(Sender: TObject);

const
  NumColumns = 3;

var
  ExIdx, NumExemptions, Index,
  I, J : Integer;

  FirstLetterPrinted, HomeownerIsEnrolledInIVP,
  FirstTimeThroughDenial, DoneDenial,
  Quit, Done, ParcelHasSeniorExemption,
  FirstTimeThrough, PrintLetter, ApprovalLetter : Boolean;

  ReasonLines, ApprovedAtLines,
  ExList, EXPercentList, slEXAutoIncrement : TStringList;
  SwisSBLKey : String;
  EXCode : String;
  DBMemoBuf : TDBMemoBuf;
  SelectedExemptions : TStringList;
  EXPercent, rTempEXPercent : Real;
  ParcelListForLabels : TStringList;
  iAutoIncrementID : LongInt;

begin
  Quit := False;
  Index := 0;
  EXPercent := 0;
  ExList := TStringList.Create;
  EXPercentList := TStringList.Create;
  slEXAutoIncrement := TStringList.Create;
  ParcelListForLabels := TStringList.Create;
  DBMemoBuf := TDBMemoBuf.Create;

    {FXX04282000-1: Not clearing list of parcels printed.}

  SBLPrintedList.Clear;

  SelectedExemptions := TStringList.Create;

    {FXX01252011-1[I8620](2.26.1.32): The exemption letters were not printing on a load from list.
                                      The SelectedExemption list was including the descriptions.}

  For I := 0 to (ExListBox.Items.Count-1) do
    If EXListBox.Selected[I]
      then SelectedExemptions.Add(Copy(EXListBox.Items[I], 1, 5));

  FirstLetterPrinted := False;  {for hdr control}
  LettersPrinted := 0;
  ProgressDialog.UserLabelCaption := '';

    {Make sure there is text for this letter code and see how many lines to print.}

  If ((not UseWordLetterTemplate) and
      (LetterTextDBMemo.Lines.Count = 0) and
      (MessageDlg('The exemption letter text is empty.' + #13 +
                  'The letters would be blank, so the letters will be blank.' + #13 +
                  'If this what you want?' + #13 +
                  '(Yes means the letters will be printed anyway.)',
                  mtWarning, [mbYes, mbNo], 0) = idNo))
    then Abort;

  If (PrintOrderRadioGroup.ItemIndex = 0)
    then ParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey
    else ParcelTable.IndexName := 'BYYEAR_NAME';

        {Print the selection information.}

  FirstTimeThrough := True;

    {CHG03241999-1: Add ability to load from parcel list.}
    {FXX06291999-9: Better method for denying exemptions.}

  If (LetterType = ltDenial)
    then
      begin
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
      end
    else
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

  with Sender as TBaseReport do
    begin
      Done := False;

        {FXX06291999-9: Better method for denying exemptions.}
        {FXX04302000-1: Need to traverse by parcel so can do by name.
                        Also, not updating progress dialog.}

      If (LetterType = ltDenial)
        then
          begin
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

              SwisSBLKey := ExtractSSKey(ParcelTable);

              If LoadFromParcelList
                then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
                else
                  If (PrintOrderRadioGroup.ItemIndex = 0)
                    then ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey))
                    else ProgressDialog.Update(Self, ParcelTable.FieldByName('Name1').Text);

              If ((not Done) and
                  RecordInRange(ParcelTable, slSelectedSwisCodes, slSelectedSchoolCodes))
                then
                  begin
                    SetRangeOld(ExemptionDenialTable,
                                ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                [AssessmentYear, SwisSBLKey, '     '],
                                [AssessmentYear, SwisSBLKey, 'ZZZZZ']);

                    FirstTimeThroughDenial := True;
                    DoneDenial := True;

                    repeat
                      If FirstTimeThroughDenial
                        then FirstTimeThroughDenial := True
                        else ExemptionDenialTable.Next;

                      If ExemptionDenialTable.EOF
                        then DoneDenial := True;

                      EXCode := ExemptionDenialTable.FieldByName('ExemptionCode').Text;

                      If ((not Done) and
                          (((LetterType = ltDenial) and
                            (ExGetsDenialLetter(EXCode, SwisSBLKey))) or
                           (LoadFromParcelList and
                            (SelectedExemptions.IndexOf(EXCode) > -1))))
                        then
                          begin
                            ReasonLines := TStringList.Create;
                            ApprovedAtLines := TStringList.Create;

                            FindKeyOld(ExemptionCodeTable,
                                       ['EXCode'], [EXCode]);

                              {CHG03172004-1(2.07l2): Allow them to suppress the reason lines.}

                            If IncludeReasonLines
                              then
                                begin
                                  ReasonLines.Add('RE: ' + ConvertSwisSBLToDashDot(SwisSBLKey));

                                  ReasonLines.Add('        ' + ExemptionCodeTable.FieldByName('Description').Text  + '  ' +
                                                  '  (' + EXCode + ')');

                                end;  {If IncludeReasonLines}

                              {CHG01212004-2(2.07l): Add ability to print labels instead of letters.}

                            case ReportType of
                              rpLetters : PrintOneLetter(Sender, DBMemoBuf, EXPercent, 0,
                                                         ReasonLines, ApprovedAtLines, LetterType,
                                                         FirstLetterPrinted, LettersPrinted);

                              rpLabels : ParcelListForLabels.Add(SwisSBLKey);

                            end;  {case ReportType of}

                            ReasonLines.Free;
                            ApprovedAtLines.Free;

                          end;  {If ((not Done) and ...}

                    until DoneDenial;

                  end;  {If (not Done)}

              LettersCancelled := ProgressDialog.Cancelled;

            until (Done or LettersCancelled);

              {FXX11052001-4: Not doing formfeed afterwards.}

            NewPage;
          end
        else
          begin
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

              If ((not Done) and
                  RecordInRange(ParcelTable, slSelectedSwisCodes, slSelectedSchoolCodes))
                then
                  begin
                    SwisSBLKey := ExtractSSKey(ParcelTable);

                       {FXX10021997 - MDT. Show dash dot format SBL.}
                       {FXX11251997-2: Show name if in alpha order.}

                    If LoadFromParcelList
                      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
                      else
                        If (PrintOrderRadioGroup.ItemIndex = 0)
                          then ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey))
                          else ProgressDialog.Update(Self, ParcelTable.FieldByName('Name1').Text);

                    Application.ProcessMessages;
                    GetExemptions(SwisSBLKey, ExList,
                                  ExPercentList, slEXAutoIncrement,
                                  HomeownerIsEnrolledInIVP, NumExemptions);

                    ExIdx := 0;

                     {FXX05201998-1: We want to print all exemptions that
                                     apply on one letter, i.e. if have 41802
                                     and 41806, only print one letter.}
                     {Go through each exemption code and see if it should appear on
                      the type of letter that they selected.  If so, we will save
                      up the information to save for the reason line and the
                      approved at lines to print all at once afterwards.}

                    ReasonLines := TStringList.Create;
                    ApprovedAtLines := TStringList.Create;
                    PrintLetter := False;
                    ApprovalLetter := (LetterType = ltApproval);

                    ParcelHasSeniorExemption := False;
                    For I := 0 to (EXList.Count - 1) do
                      If (Take(4, EXList[I]) = '4180')
                        then ParcelHasSeniorExemption := True;

                    while ((EXIdx <= (NumExemptions - 1)) and
                           (not Quit)) do
                      begin
                        Quit := False;
                        EXCode := EXList[EXIdx];

                        try
                          iAutoIncrementID := StrToInt(slEXAutoIncrement[EXIdx]);
                        except
                          iAutoIncrementID := 0;
                        end;

                           {renewal letter}
                           {FXX03261999-3: Listing all exemptions for approval letter
                                           if imported from parcel list.}
                           {CHG09271999-1: Add in renewal reminders.}
                           {FXX09132001-7: Renewal reminder check was not calling
                                           the correct test.}

                        If (((LetterType = ltRenewal) and
                             (ExGetsRenewalLetter(EXCode, SwisSBLKey, iAutoIncrementID,
                                                  ParcelHasSeniorExemption,
                                                  HomeownerIsEnrolledInIVP, Quit))) or
                            ((LetterType = ltApproval) and
                             (ExGetsApprovalLetter(EXCode, SwisSBLKey, iAutoIncrementID,
                                                   ParcelHasSeniorExemption,
                                                   HomeownerIsEnrolledInIVP, Quit))) or
                            ((LetterType = ltRenewalReminder) and
                             (ExGetsRenewalReminderLetter(EXCode, SwisSBLKey, iAutoIncrementID,
                                                          ParcelHasSeniorExemption,
                                                          HomeownerIsEnrolledInIVP, Quit))) or
                             (LoadFromParcelList and
                              (SelectedExemptions.IndexOf(EXCode) > -1)))
                          then
                            begin
                              PrintLetter := True;

                                {CHG03172004-1(2.07l2): Allow them to suppress the reason lines.}

                              If IncludeReasonLines
                                then
                                  begin
                                    If (ReasonLines.Count = 0)
                                      then ReasonLines.Add('RE: ' + ConvertSwisSBLToDashDot(SwisSBLKey));

                                    ReasonLines.Add('        ' + ExemptionCodeTable.FieldByName('Description').Text  + '  ' +
                                                    '  (' + EXCode + ')');

                                  end;  {If IncludeReasonLines}

                              If ApprovalLetter
                                then
                                  begin
                                      {CHG11251997-3: If these are an aged approval
                                                      letters, then print the percent.}

                                    If (Take(4, EXCode) = '4180')
                                      then ApprovedAtLines.Add('    Your senior exemption (' + EXCode + ') was approved at ' +
                                                               Trim(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                                StrToFloat(EXPercentList[EXIdx]))) +
                                                               '%.');

                                      {CHG05191998-1: If veterans exemption approval,
                                                      print %.}

                                    If ((Take(4, EXCode) = '4112') or
                                        (Take(4, EXCode) = '4113') or
                                        (Take(4, EXCode) = '4114'))
                                      then ApprovedAtLines.Add('    Your veterans exemption (' + EXCode +
                                                               ') was approved at ' +
                                                               Trim(FormatFloat(NoDecimalDisplay_BlankZero,
                                                               StrToFloat(EXPercentList[EXIdx]))) +
                                                               '%.');

                                      {FXX04231999-1: Allow % to be an insert.}
                                      {FXX06282002-1: Make sure this never causes an error.}
                                      {FXX04032008-1: Don't replace an actual percent with a 0 % from a different exemption.}

                                    EXPercent := 0;
                                    try
                                      rTempEXPercent := StrToFloat(EXPercentList[EXIdx]);

                                      If _Compare(rTempEXPercent, 0, coGreaterThan)
                                        then EXPercent := rTempEXPercent;
                                    except
                                    end;

                                  end;  {If ApprovalLetter}

                            end;  {If (((LetterTypeRadioGroup.ItemIndex = 0) and ...}

                        ExIdx := ExIdx + 1;

                      end;  {while ((EXIdx <= (NumExemptions - 1) and ...}

                      {Now print the letter generated above.}

                    If PrintLetter
                      then
                        begin
                            {CHG09271999-2: Print out a list of letters sent.}

                          SBLPrintedList.Add(SwisSBLKey);

                            {CHG10312000-1: Allow dollar insert for exemption amount - take
                                            the default amount.}
                            {CHG01212004-2(2.07l): Add ability to print labels instead of letters.}

                          case ReportType of
                            rpLetters : PrintOneLetter(Sender, DBMemoBuf, EXPercent,
                                                       ParcelExemptionTable.FieldByName('Amount').AsFloat,
                                                       ReasonLines, ApprovedAtLines, LetterType,
                                                       FirstLetterPrinted, LettersPrinted);

                            rpLabels : ParcelListForLabels.Add(SwisSBLKey);

                          end;  {case ReportType of}

                        end;  {If PrintLetter}

                  ReasonLines.Free;
                  ApprovedAtLines.Free;

                end;  {end not eof}

              LettersCancelled := ProgressDialog.Cancelled;

            until (Done or LettersCancelled);

          end;  {else of If (LetterTypeRadioGroup.ItemIndex = ltDenial)}

        {CHG09271999-2: Print a list of the parcels that got letters.}

      If ((ReportType = rpLetters) and
          (SBLPrintedList.Count > 0))
        then
          begin
            FirstTimeThrough := True;

              {FXX11151999-5: Columns were messed up.}

            ClearTabs;
            SetTab(0.5, pjLeft, 2.0, 0, BOXLINENONE, 0);   {parcel ID}
            SetTab(2.8, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Parcel ID}
            SetTab(5.1, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Parcel ID}

            For I := 0 to (SBLPrintedList.Count - 1) do
              begin
                If (FirstTimeThrough or
                    (LinesLeft < 5))
                  then
                    begin
                      FirstTimeThrough := False;
                      NewPage;

                      Println('');
                      Bold := True;
                      Underline := True;
                      Println('The following parcels received exemption letters:');
                      Bold := False;
                      Underline := False;

                    end;  {If (FirstTimeThrough or ...}

                  {We will print probably 3 columns across, so if this is a new
                   line, issue a carriage return for the last line.}

                If (((I + 1) MOD NumColumns) = 1)
                  then Println('');

                Print(#9 + ConvertSwisSBLToDashDot(SBLPrintedList[I]));

              end;  {with Sender as TBaseReport do}

            Println('');

          end;  {If (SBLPrintedList.Count > 0)}

        {CHG07212003-1(2.07g): Don't print enhanced STARs in the IVP program.
                               Save them up to print out later as a list.}

      If ((ReportType = rpLetters) and
          (LettersNotPrintedDuetoIVP.Count > 0))
        then
          begin
            FirstTimeThrough := True;

              {FXX11151999-5: Columns were messed up.}

            ClearTabs;
            SetTab(0.5, pjLeft, 2.0, 0, BOXLINENONE, 0);   {parcel ID}
            SetTab(2.8, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Parcel ID}
            SetTab(5.1, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Parcel ID}

            For I := 0 to (LettersNotPrintedDuetoIVP.Count - 1) do
              begin
                If (FirstTimeThrough or
                    (LinesLeft < 5))
                  then
                    begin
                      FirstTimeThrough := False;
                      NewPage;

                      Println('');
                      Bold := True;
                      Underline := True;
                      Println('The following parcel(s) did not receive an exemption letter because the owner is enrolled in the IVP program:');
                      Bold := False;
                      Underline := False;

                    end;  {If (FirstTimeThrough or ...}

                  {We will print probably 3 columns across, so if this is a new
                   line, issue a carriage return for the last line.}

                If (((I + 1) MOD NumColumns) = 1)
                  then Println('');

                Print(#9 + ConvertSwisSBLToDashDot(LettersNotPrintedDuetoIVP[I]));

              end;  {with Sender as TBaseReport do}

            Println('');

          end;  {If (LettersNotPrintedDuetoIVP.Count > 0)}

        {CHG03182004-1(2.08): Allow for prevention of renewals on individual exemptions.
                              Used for volunteer firefighter.}

      If ((ReportType = rpLetters) and
          (RenewalsPreventedList.Count > 0))
        then
          begin
            FirstTimeThrough := True;

              {FXX11151999-5: Columns were messed up.}

            ClearTabs;
            SetTab(0.5, pjLeft, 2.0, 0, BOXLINENONE, 0);   {parcel ID}
            SetTab(2.8, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Parcel ID}
            SetTab(5.1, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Parcel ID}

            For I := 0 to (RenewalsPreventedList.Count - 1) do
              begin
                If (FirstTimeThrough or
                    (LinesLeft < 5))
                  then
                    begin
                      FirstTimeThrough := False;
                      NewPage;

                      Println('');
                      Bold := True;
                      Underline := True;
                      Println('The following parcel(s) did not receive an exemption letter because the Prevent Renewal flag is on:');
                      Bold := False;
                      Underline := False;

                    end;  {If (FirstTimeThrough or ...}

                  {We will print probably 3 columns across, so if this is a new
                   line, issue a carriage return for the last line.}

                If (((I + 1) MOD NumColumns) = 1)
                  then Println('');

                Print(#9 + ConvertSwisSBLToDashDot(RenewalsPreventedList[I]));

              end;  {with Sender as TBaseReport do}

            Println('');

          end;  {If (RenewalsPreventedList.Count > 0)}

      If (ReportType = rpLetters)
        then
          begin
            If LettersCancelled
              then
                begin
                  CRLF;
                  CRLF;
                  CRLF;
                  Bold := True;
                  Println(#9 + '*** PRINT JOB CANCELLED BY USER ***');
                end;

            For I := 1 to 10 do
              CRLF;

            Println(#9 + 'TOTAL LETTERS PRINTED: ' +
                    IntToStr(LettersPrinted));
            CRLF;
            CRLF;
            Println(#9 + 'PRINT OPTIONS SELECTED:');
            CRLF;
            Print(#9 + '    Letter Type: ');

            case LetterType of
              ltRenewal : Println('Renewal Letter');
              ltRenewalReminder : Println('Renewal Reminder Letter');
              ltApproval : Println('Approval Letter');
              ltDenial : Println('Denial Letter');
            end;

            CRLF;
            PrintLn(#9 +  '    LETTER TEXT CODE: ' +
                    LetterTextTable.FieldByName('MainCode').Text);
            CRLF;

            If PrintOrderRadioGroup.ItemIndex = 0
              then Println(#9 +  '    PRINT ORDER: Parcel ID')
              else Println(#9 +  '    PRINT ORDER: By Name');

            CRLF;

            If LetterHeadCheckBox.Checked
              then Println(#9 +  '    Letter head printed.')
              else Println(#9 +  '    Using letter head paper.');
            CRLF;

            Println(#9 +'    EX CODES SELECTED:');
            CRLF;

            Done := False;
            I := 0;
            J := 0;

            repeat
              If (J > 10)
                then CRLF;

              If ExListBox.Selected[I]
                then
                  begin
                    Print(ExListBox.Items[I] + ' ');
                    J := J + 1;
                  end;

              I := I + 1;

              If (I > (ExListBox.Items.Count-1))
                then Done := True;

            until Done;

                {FXX05191998-8: Add trial run feature.}

            If TrialRun
              then
                begin
                  CRLF;
                  CRLF;
                  Println(#9 + '*******************************************');
                  Println(#9 + 'TRIAL RUN ONLY, NO UPDATES OCCURRED.');
                  Println(#9 + '*******************************************');

                end;  {If TrialRun}

          end;  {If (ReportType = rpLetters)}

    end;  {with Sender as TBaseReport do}

  ProgressDialog.Finish;
  EXList.Free;
  EXPercentList.Free;

  DBMemoBuf.Free;

  If (ReportType = rpLabels)
    then PrintLabels(Sender, ParcelListForLabels, ParcelTable,
                     SwisCodeTable, AssessmentYearControlTable,
                     AssessmentYear, LabelOptions);

  ParcelListForLabels.Free;

end;  {ReportPrinterPrint}

{===================================================================}
Procedure TExemptionLetterPrintForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TExemptionLetterPrintForm.FormClose(    Sender: TObject;
                                              var Action: TCloseAction);

begin
  slSelectedSchoolCodes.Free;
  slSelectedSwisCodes.Free;
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

{================================================================}
Procedure TExemptionLetterPrintForm.LetterOleContainerMouseDown(Sender: TObject;
                                                                Button: TMouseButton;
                                                                Shift: TShiftState;
                                                                X, Y: Integer);

{Bring up the document for editing.}

var
  FileName : OLEVariant;

begin
  FileName := MergeLetterTable.FieldByName('FileName').Text;

  try
    LetterOLEContainer.DestroyObject;
  except
  end;

  OpenWordDocument(WordApplication, WordDocument, FileName);

end;  {LetterOleContainerMouseDown}


{================================================================}
Procedure TExemptionLetterPrintForm.OLEItemNameTimerTimer(Sender: TObject);

begin
  If GlblApplicationIsActive
    then
      begin
        OLEItemNameTimer.Enabled := False;
        MergeLetterTableAfterScroll(MergeLetterTable);
      end
    else
      If (MergeLetterTable.State in [dsEdit, dsInsert])
        then
          try
            MergeLetterTable.FieldByName('FileName').Text := WordDocument.FullName;
          except
          end;

end;  {OLEItemNameTimerTimer}

{================================================================}
Procedure TExemptionLetterPrintForm.MergeLetterTableAfterScroll(DataSet: TDataSet);

var
  TemplateName : OLEVariant;

begin
  If not InitializingForm
    then
      begin
        TemplateName := MergeLetterTable.FieldByName('FileName').Text;

          {FXX07252002-2: Make sure to have a try..except around the container create.}

        If (_Compare(MergeLetterTable.FieldByName('LetterName').AsString, coNotBlank) and
            FileExists(TemplateName))                                               
          then
            try
              LetterOLEContainer.CreateObjectFromFile(TemplateName, False);
            except
              LetterOLEContainer.DestroyObject;
              LetterOLEContainer.SizeMode := smClip;
              LetterOLEContainer.CreateObjectFromFile(TemplateName, False);

            end;

        SetRangeOld(MergeLetterDefinitionsTable, ['LetterName'],
                    [MergeLetterTable.FieldByName('LetterName').Text],
                    [MergeLetterTable.FieldByName('LetterName').Text]);

        FillOneListBox(MergeFieldsUsedListBox,
                       MergeLetterDefinitionsTable,
                       'MergeFieldName',
                       '', 0, False, False,
                       NoProcessingType, '');

      end;  {If not InitializingForm}

end;  {MergeLetterTableAfterScroll}

{========================================================}
Procedure TExemptionLetterPrintForm.btnNewLetterClick(Sender: TObject);

begin
  If eddlgNewLetter.Execute
    then
      with LetterTextTable do
        try
          Insert;
          FieldByName('MainCode').AsString := eddlgNewLetter.Value;
          Post;
          LetterTextDBMemo.Execute;
        except
        end;

end;  {btnNewLetterClick}


{=========================================================}
Procedure TExemptionLetterPrintForm.LetterTextDBMemoDblClick(Sender: TObject);

begin
  LetterTextDBMemo.Execute;

    {FXX04232009-4(2.20.1.1)[D210]: Automatically save the letter changes.}

  If (LetterTextTable.State = dsEdit)
    then LetterTextTable.Post;

end;  {LetterTextDBMemoDblClick}


end.