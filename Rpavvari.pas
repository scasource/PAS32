unit Rpavvari;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Types, RPDefine, (*Progress, *)RPTXFilr,
  ComCtrls;

type
  TAssessmentVarianceReportForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    TYParcelTable: TTable;
    TYAssessmentTable: TTable;
    SwisCodeTable: TTable;
    PrintDialog: TPrintDialog;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    NYAssessmentTable: TTable;
    SortTable: TTable;
    NYParcelTable: TTable;
    PriorAssessmentTable: TTable;
    PriorParcelTable: TTable;
    TextFiler: TTextFiler;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    SchoolCodeTable: TTable;
    PageControl1: TPageControl;
    OptionsTabSheet: TTabSheet;
    PrintOrderRadioGroup: TRadioGroup;
    ComparisonTypeRadioGroup: TRadioGroup;
    OptionsGroupBox: TGroupBox;
    LoadFromParcelListCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    PrintNoChangeParcelsCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    RollSectionTypeRadioGroup: TRadioGroup;
    Swis_School_RS_TabSheet: TTabSheet;
    Label15: TLabel;
    Label9: TLabel;
    Label18: TLabel;
    RollSectionListBox: TListBox;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    Panel2: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    cbxDisplayChangeReason: TCheckBox;
    tbAssessmentChangeReasons: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure TextReportPrint(Sender: TObject);
    procedure TextReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ReportCancelled : Boolean;
    SelectedRollSections,
    SelectedSchoolCodes,
    SelectedSwisCodes : TStringList;  {What swis codes did they select?}
    PrintOrder : Integer;  {What order are we printing in?}
    PriorYear : String;
    LoadFromParcelList,
    CreateParcelList, bDisplayChangeReason : Boolean;
    OrigSortFileName, CurrentYear, LastYear : String;
    PrintToExcel : Boolean;
    ExtractFile : TextFile;
    RollSectionChangeType : Integer;
    LinesAtBottom, NumLinesPerPage, CurrentLineNumber : Integer;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure UpdateSortTable(    SwisSBLKey : String;
                                  LandVal,
                                  PriorLandVal,
                                  AssessedVal,
                                  PriorAssessedVal : LongInt;
                                  PriorRollSection,
                                  CurrentRollSection : String;
                                  ParcelTable : TTable;
                                  PartialAssessment : Boolean;
                                  sChangeReason : String;
                              var Quit : Boolean);
    {Insert a record for this parcel.}

    Procedure FillSortFile(var Quit : Boolean);   {Fill the sort file with the variance information.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst, PasTypes,
     PRCLLIST, RptDialg,
     Prog, DataAccessUnit,
     Preview;  {Report preview form}

const
  TrialRun = False;
  ParcelID = 0;
  VariancePercent = 1;

  cmTYvsNY = 0;
  cmHistoryvsTY = 1;

  rscOnlyChanged = 0;
  rscNoChanges = 1;
  rscEither = 2;

{$R *.DFM}

{========================================================}
Procedure TAssessmentVarianceReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TAssessmentVarianceReportForm.InitializeForm;

var
  Quit : Boolean;
  I : Integer;

begin
  Quit := False;
  UnitName := 'RPAVVARI.PAS';  {mmm}

    {Default swis code table to NY esp. since it rarely changes.}
    {CHG02182004-2(2.07l1): Add school code support.}

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             NextYear, Quit);

  OpenTableForProcessingType(SchoolCodeTable, SchoolCodeTableName,
                             NextYear, Quit);

  FillOneListBox(SwisCodeListBox, SwisCodeTable,
                 'SwisCode', 'MunicipalityName', 20,
                 True, True, NextYear, GlblNextYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable,
                 'SchoolCode', 'SchoolName', 15,
                  True, True, NextYear, GlblNextYear);

  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;
  SelectedRollSections := TStringList.Create;

    {CHG10131999-1: Allow for selection of roll sections.}

  with RollSectionListBox do
    For I := 0 to (Items.Count - 1) do
      Selected[I] := True;

  OrigSortFileName := SortTable.TableName;

end;  {InitializeForm}

{===================================================================}
Procedure TAssessmentVarianceReportForm.UpdateSortTable(    SwisSBLKey : String;
                                                            LandVal,
                                                            PriorLandVal,
                                                            AssessedVal,
                                                            PriorAssessedVal : LongInt;
                                                            PriorRollSection,
                                                            CurrentRollSection : String;
                                                            ParcelTable : TTable;
                                                            PartialAssessment : Boolean;
                                                            sChangeReason : String;
                                                        var Quit : Boolean);

{Insert a record for this parcel.}
{CHG12041997-2: Allow user to choose years to compare, showing no change
                parcels.}

var
  VariancePercent : Double;

begin
    {FXX03151999-1: If prior is 0, put in a high variance percent.}

  If (PriorAssessedVal = 0)
    then VariancePercent := 9999
    else
      try
        VariancePercent := Roundoff(((AssessedVal - PriorAssessedVal) / PriorAssessedVal * 100), 1);
      except
        VariancePercent := 0;
      end;

    {FXX05031999-3: Need to see if variance <> 0}

  If ((Roundoff(AssessedVal, 0) <> Roundoff(PriorAssessedVal, 0)) or
      (PriorRollSection <> CurrentRollSection) or
      PrintNoChangeParcelsCheckBox.Checked)
    then
      begin
          {CHG03101999-1: Send info to a list.}

        If CreateParcelList
          then ParcelListDialog.AddOneParcel(SwisSBLKey);

        with SortTable do
          try
            Insert;

            FieldByName('SwisSBLKey').Text := SwisSBLKey;
            FieldByName('Name').Text := Take(20, ParcelTable.FieldByName('Name1').Text);
            FieldByName('Location').Text := Take(20, GetLegalAddressFromTable(ParcelTable));

              {CHG02182004-1(2.07l1): Allow search of changed roll sections.}
              {CHG06052004-2(2.07l5): Add land AV to AV variance report.}

            FieldByName('RollSection').Text := CurrentRollSection;
            FieldByName('PriorRollSection').Text := PriorRollSection;
            FieldByName('PropertyClass').Text := Take(3, ParcelTable.FieldByName('PropertyClassCode').Text);
            FieldByName('SchoolCode').Text := Take(6, ParcelTable.FieldByName('SchoolCode').Text);
            FieldByName('LandVal').AsInteger := LandVal;
            FieldByName('PriorLandVal').AsInteger := PriorLandVal;
            FieldByName('AssessedVal').AsInteger := AssessedVal;
            FieldByName('PriorAssessedVal').AsInteger := PriorAssessedVal;
            FieldByName('Variance').AsInteger := AssessedVal - PriorAssessedVal;
            FieldByName('VariancePercent').AsFloat := VariancePercent;

              {CHG06102004-1(2.07l5): Add partial assessment flag.}

            FieldByName('PartialAssessment').AsBoolean := PartialAssessment;

            try
              FieldByName('ChangeReason').AsString := sChangeReason;
            except
            end;

            Post;

          except
            Quit := True;
            SystemSupport(005, SortTable, 'Error inserting sort record.',
                          UnitName, GlblErrorDlgBox);
          end;

      end;  {If ((VariancePercent > 0) or ...}

end;  {UpdateSortTable}

{===================================================================}
Procedure TAssessmentVarianceReportForm.FillSortFile(var Quit : Boolean);

{Fill the sort file with the variance information.}

var
  HistoryFilesExist, Found,
  MeetsCriteria, RollSectionChanged, AssessmentChanged,
  FirstTimeThrough, Done, PartialAssessment,
  bPriorInactive, bCurrentInactive : Boolean;
  I, Index : Integer;
  SwisSBLKey : String;
  SwisSBLRec : SBLRecord;
  LandVal, PriorLandVal,
  AssessedVal, PriorAssessedVal : LongInt;
  MainParcelTable : TTable;
  CurrentRollSection, PriorRollSection,
  sChangeReason, sChangeReasonCode : String;

begin
  MainParcelTable := nil;
  Index := 1;
  AssessedVal := 0;
  PriorAssessedVal := 0;
  LandVal := 0;
  PriorLandVal := 0;
  PartialAssessment := False;
  HistoryFilesExist := HistoryExists;
  ProgressDialog.UserLabelCaption := 'Creating Sort File.';

  SelectedSwisCodes.Clear;

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    If SwisCodeListBox.Selected[I]
      then SelectedSwisCodes.Add(Copy(SwisCodeListBox.Items[I], 1, 6));

  SelectedSchoolCodes.Clear;

  For I := 0 to (SchoolCodeListBox.Items.Count - 1) do
    If SchoolCodeListBox.Selected[I]
      then SelectedSchoolCodes.Add(Copy(SchoolCodeListBox.Items[I], 1, 6));

    {CHG10131999-1: Allow for selection of roll sections.}

  SelectedRollSections.Clear;

  For I := 0 to (RollSectionListBox.Items.Count - 1) do
    If RollSectionListBox.Selected[I]
      then SelectedRollSections.Add(RollSectionListBox.Items[I][1]);

    {FXX05301999-1: For NY to TY comparison, must drive off the NY table looking
                    backwards.}

  case ComparisonTypeRadioGroup.ItemIndex of
    0 : MainParcelTable := NYParcelTable;
    1 : MainParcelTable := TYParcelTable;
  end;

    {Now go through the prior parcel file, comparing forward.}

  FirstTimeThrough := True;
  Done := False;

    {CHG03101999-1: Send info to a list or load from a list.}

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(MainParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        MainParcelTable.First;
        ProgressDialog.Start(GetRecordCount(MainParcelTable), True, True);
      end;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              ParcelListDialog.GetParcel(MainParcelTable, Index);
            end
          else MainParcelTable.Next;

    If (MainParcelTable.EOF or
        (LoadFromParcelList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

    If LoadFromParcelList
      then ProgressDialog.Update(Self, ParcelListDialog.GetParcelID(Index))
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(MainParcelTable)));

    SwisSBLKey := ExtractSSKey(MainParcelTable);

    Application.ProcessMessages;

      {Insert records into the sort files where appropriate.}
      {CHG10131999-1: Allow for selection of roll sections.}
      {CHG02182004-2(2.07l1): Add school code support.}

    If ((not Done) and
        (SelectedSwisCodes.IndexOf(Copy(SwisSBLKey, 1, 6)) > -1) and  {In the selected list.}
        (SelectedRollSections.IndexOf(MainParcelTable.FieldByName('RollSection').Text) > -1) and
        (SelectedSchoolCodes.IndexOf(MainParcelTable.FieldByName('SchoolCode').Text) > -1))
      then
        begin
          SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);
          PriorRollSection := '';
          bPriorInactive := False;
          bCurrentInactive := False;

          case ComparisonTypeRadioGroup.ItemIndex of
           0 : begin
                    {FXX05301999-1: For NY to TY comparison, must drive off the NY table looking
                                    backwards.}

                 FindKeyOld(NYAssessmentTable,
                            ['TaxRollYr', 'SwisSBLKey'],
                            [GlblNextYear, SwisSBLKey]);
                 AssessedVal := NYAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
                 LandVal := NYAssessmentTable.FieldByName('LandAssessedVal').AsInteger;

                   {CHG06102004-1(2.07l5): Add partial assessment flag.}

                 PartialAssessment := NYAssessmentTable.FieldByName('PartialAssessment').AsBoolean;

                 with SwisSBLRec do
                   Found := FindKeyOld(TYParcelTable,
                                       ['TaxRollYr', 'SwisCode', 'Section',
                                        'Subsection', 'Block', 'Lot', 'Sublot',
                                        'Suffix'],
                                       [GlblThisYear, SwisCode, Section, Subsection,
                                        Block, Lot, Sublot, Suffix]);
                 FindKeyOld(TYAssessmentTable,
                            ['TaxRollYr', 'SwisSBLKey'],
                            [GlblThisYear, SwisSBLKey]);

                   {FXX12171999-2: Current value should be 0 if inactive even if prior does
                                   not exist.}

                 If (NYParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
                   then
                     begin
                       AssessedVal := 0;
                       LandVal := 0;
                       bCurrentInactive := True;
                     end;

                 If Found
                   then
                     begin
                       PriorAssessedVal := TYAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
                       PriorLandVal := TYAssessmentTable.FieldByName('LandAssessedVal').AsInteger;
                       PriorRollSection := TYParcelTable.FieldByName('RollSection').Text;

                         {FXX05031999-5: If the parcel is inactive, current val is 0.}

                       If (TYParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
                         then
                           begin
                             PriorAssessedVal := 0;
                             PriorLandVal := 0;
                             bPriorInactive := True;
                             PriorRollSection := '';
                           end;

                     end
                   else
                     begin
                       PriorAssessedVal := 0;
                       PriorLandVal := 0;
                       bPriorInactive := True;
                       PriorRollSection := '';
                     end;

                   {CHG02182004-1(2.07l1): Allow search of changed roll sections.}

                 CurrentRollSection := NYParcelTable.FieldByName('RollSection').Text;

                 sChangeReasonCode := NYAssessmentTable.FieldByName('OrigCurrYrValCode').AsString;

               end;  {NY vs. TY}

           1 : begin
                   {FXX08231999-2: Need to get the correct rec for TY assessment.}

                 FindKeyOld(TYAssessmentTable,
                            ['TaxRollYr', 'SwisSBLKey'],
                            [GlblThisYear, SwisSBLKey]);
                 AssessedVal := TYAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
                 LandVal := TYAssessmentTable.FieldByName('LandAssessedVal').AsInteger;

                   {CHG06102004-1(2.07l5): Add partial assessment flag.}

                 PartialAssessment := TYAssessmentTable.FieldByName('PartialAssessment').AsBoolean;

                   {FXX05031999-5: If the parcel is inactive, current val is 0.}

                 If (TYParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
                   then
                     begin
                       AssessedVal := 0;
                       LandVal := 0;
                       bCurrentInactive := True;
                     end;

                 with SwisSBLRec do
                   Found := FindKeyOld(PriorParcelTable,
                                       ['TaxRollYr', 'SwisCode', 'Section',
                                        'Subsection', 'Block', 'Lot', 'Sublot',
                                        'Suffix'],
                                       [PriorYear, SwisCode, Section, Subsection,
                                        Block, Lot, Sublot, Suffix]);
                 If Found
                   then
                     begin
                       FindKeyOld(PriorAssessmentTable,
                                  ['TaxRollYr', 'SwisSBLKey'],
                                  [PriorYear, SwisSBLKey]);

                       PriorAssessedVal := PriorAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
                       PriorLandVal := PriorAssessmentTable.FieldByName('LandAssessedVal').AsInteger;
                       PriorRollSection := PriorParcelTable.FieldByName('RollSection').Text;

                       If (PriorParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
                         then
                           begin
                             PriorAssessedVal := 0;
                             PriorLandVal := 0;
                             bPriorInactive := True;
                             PriorRollSection := '';
                           end;

                     end
                   else
                     If HistoryFilesExist
                       then
                         begin
                           PriorAssessedVal := 0;  {New parcel}
                           PriorLandVal := 0;
                           bPriorInactive := True;
                           PriorRollSection := '';
                         end
                       else
                         begin
                           PriorAssessedVal := TYAssessmentTable.FieldByName('PriorTotalValue').AsInteger;
                           PriorLandVal := TYAssessmentTable.FieldByName('PriorLandValue').AsInteger;
                           PriorRollSection := MainParcelTable.FieldByName('PriorRollSection').Text;
                         end;

                   {CHG02182004-1(2.07l1): Allow search of changed roll sections.}

                 CurrentRollSection := MainParcelTable.FieldByName('RollSection').Text;
                 sChangeReasonCode := TYAssessmentTable.FieldByName('OrigCurrYrValCode').AsString;

               end;  {TY vs. prior}

          end;  {case ComparisonTypeRadioGroup of}

          AssessmentChanged := ((Roundoff(AssessedVal, 0) <> Roundoff(PriorAssessedVal, 0)) or
                                PrintNoChangeParcelsCheckBox.Checked);

          RollSectionChanged := (CurrentRollSection <> PriorRollSection);

            {CHG02182004-1(2.07l1): Allow search of changed roll sections.}

          MeetsCriteria := False;

          case RollSectionChangeType of
            rscOnlyChanged : If RollSectionChanged
                               then MeetsCriteria := True;

            rscNoChanges : If (AssessmentChanged and
                               (not RollSectionChanged))
                             then MeetsCriteria := True;

            rscEither : If (AssessmentChanged or RollSectionChanged)
                          then MeetsCriteria := True;

          end;  {case RollSectionChangeType of}

          If (bCurrentInactive and bPriorInactive)
          then MeetsCriteria := False;

          If _Compare(sChangeReasonCode, coBlank)
          then sChangeReason := ''
          else
          begin
            _Locate(tbAssessmentChangeReasons, [sChangeReasonCode], '', []);
            sChangeReason := tbAssessmentChangeReasons.FieldByName('Description').AsString;
          end;

          If MeetsCriteria
            then UpdateSortTable(SwisSBLKey, LandVal, PriorLandVal,
                                 AssessedVal, PriorAssessedVal,
                                 PriorRollSection, CurrentRollSection,
                                 MainParcelTable, PartialAssessment,
                                 sChangeReason, Quit);

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or Quit or ReportCancelled);

end;  {FillSortFiles}

{====================================================================}
Procedure TAssessmentVarianceReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'avvari.var', 'Assessment Variance Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TAssessmentVarianceReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'avvari.var', 'Assessment Variance Report');

end;  {LoadButtonClick}

{===================================================================}
Procedure TAssessmentVarianceReportForm.StartButtonClick(Sender: TObject);

var
  Quit : Boolean;
  SpreadsheetFileName, TextFileName,
  SortFileName, NewFileName : String;
  TempYear : Integer;
  ReducedSize : Boolean;
  DuplexType : TDuplex;

begin
  Quit := False;
  ReportCancelled := False;
  CurrentLineNumber := 0;
  bDisplayChangeReason := cbxDisplayChangeReason.Checked;

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  StartButton.Enabled := False;
  Application.ProcessMessages;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
          {FXX10071999-1: To solve the problem of printing to the high speed,
                          we need to set the font to a TrueType even though it
                          doesn't matter in the actual printing.  The reason for this
                          is that without setting it, the default font is System for
                          the Generic printer which has a baseline descent of 0.5
                          which messes up printing to a text file.  We needed a font
                          with no descent.}

        TextFiler.SetFont('Courier New', 10);

        LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
        CreateParcelList := CreateParcelListCheckBox.Checked;

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

          {CHG02182004-3(2.07l1): Offer to print on letter size paper.}

        PromptForLetterSizePaper(ReportPrinter, ReportFiler, NumLinesPerPage, LinesAtBottom,
                                 ReducedSize, DuplexType);

        ReportPrinter.ScaleX := 82;
        ReportPrinter.ScaleY := 75;
        ReportFiler.ScaleX := 82;
        ReportFiler.ScaleY := 75;

        If not Quit
          then
            begin
                {Copy the sort table and open the tables.}
                {FXX03191999-5: Use the GetSortFileName function.}

              CopyAndOpenSortFile(SortTable, 'AssessmentVariance',
                                  OrigSortFileName, SortFileName,
                                  True, True, Quit);

              TempYear := StrToInt(GlblThisYear);
              PriorYear := IntToStr(TempYear - 1);

                {CHG02182004-1(2.07l1): Allow search of changed roll sections.}

              RollSectionChangeType := RollSectionTypeRadioGroup.ItemIndex;

                {We have to open the tables manually since we are opening both this year and next year.}

              OpenTableForProcessingType(TYAssessmentTable, AssessmentTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(NYAssessmentTable, AssessmentTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(NYParcelTable, ParcelTableName,
                                         NextYear, Quit);
              OpenTableForProcessingType(TYParcelTable, ParcelTableName,
                                         ThisYear, Quit);
              OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                                         History, Quit);
              OpenTableForProcessingType(PriorParcelTable, ParcelTableName,
                                         History, Quit);
              OpenTableForProcessingType(tbAssessmentChangeReasons, 'zorigassvaltbl',
                                         NoProcessingType, Quit);

              ProgressDialog.Start(GetRecordCount(TYParcelTable), True, True);

              case PrintOrderRadioGroup.ItemIndex of
                0 : begin
                      SortTable.IndexName := 'BYSWISSBLKEY';
                      PrintOrder := ParcelID;

                    end;  {Parcel ID}

                1 : begin
                      SortTable.IndexFieldNames := 'BYVARIANCEPERCENT_NAME';
                      PrintOrder := VariancePercent;

                    end;  {Variance percent}

              end;  {case PrintOrderRadioGroup.ItemIndex of}

              FillSortFile(Quit);

                {Now print the report.}

              If not Quit
                then
                  begin
                    case ComparisonTypeRadioGroup.ItemIndex of
                      0 : begin
                            CurrentYear := GlblNextYear;
                            LastYear := GlblThisYear;
                          end;

                      1 : begin
                            CurrentYear := GlblThisYear;
                            LastYear := PriorYear;
                          end;
                    end;  {case ComparisonTypeRadioGroup.ItemIndex of}

                      {CHG11092003-1(2.07k): Option to print to Excel.}

                    PrintToExcel := ExtractToExcelCheckBox.Checked;

                    If PrintToExcel
                      then
                        begin
                          SpreadsheetFileName := GetPrintFileName('Excel_' + Self.Caption, True);
                          AssignFile(ExtractFile, SpreadsheetFileName);
                          Rewrite(ExtractFile);

                          Writeln(ExtractFile, 'Partial,',
                                               'Swis Cd,',
                                               'Parcel ID,',
                                               'School,',
                                               'Owner,',
                                               'Location,',
                                               LastYear + ' RS,',
                                               CurrentYear + ' RS,',
                                               'Prp Cls,',
                                               LastYear + ' Land Value,',
                                               CurrentYear + ' Land Value,',
                                               LastYear + ' Assessment,',
                                               CurrentYear + ' Assessment,',
                                               'Variance,',
                                               '% Diff');

                        end;  {If PrintToExcel}

                    ProgressDialog.Reset;
                    ProgressDialog.TotalNumRecords := GetRecordCount(SortTable);
                    ProgressDialog.UserLabelCaption := 'Printing report.';
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

                      {FXX09071999-6: Tell people that printing is starting and
                                      done.}

                    ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                    ProgressDialog.Finish;

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

                            PreviewForm.FilePreview.ZoomFactor := 100;

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

                      {CHG01182000-3: Allow them to choose a different name or copy right away.}

                    ShowReportDialog('AVVARINC.RPT', TextFiler.FileName, True);

                  end;  {If not Quit}

                {Make sure to close and delete the sort file.}

              SortTable.Close;

                {Now delete the file.}
              try
                ChDir(GlblDataDir);
                OldDeleteFile(SortFileName);
              finally
                {We don't care if it does not get deleted, so we won't put up an
                 error message.}

                ChDir(GlblProgramDir);
              end;

              If CreateParcelList
                then ParcelListDialog.Show;

              If PrintToExcel
                then
                  begin
                    CloseFile(ExtractFile);
                    SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                                   False, '');

                  end;  {If PrintToExcel}

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);
              ResetPrinter(ReportPrinter);

            end;  {If not Quit}

      end;  {If PrintDialog.Execute}

  StartButton.Enabled := True;

end;  {StartButtonClick}

{===================================================================}
{===============  THE FOLLOWING ARE PRINTING PROCEDURES ============}
{===================================================================}
Procedure TAssessmentVarianceReportForm.TextReportPrintHeader(Sender: TObject);

{FXX09081999-5: Add in year of printing and skip one line at beginning.}

var
  I : Integer;
  TempTab : PTab;
  ReportTypeString : String;

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 13.0, 0, BoxLineNone, 0);

      Println('');
      Println(#9 + Take(43, 'COUNTY OF ' + UpcaseStr(GlblCountyName)) +
              Center('ASSESSMENT VARIANCE REPORT', 43) +
              RightJustify('Page: ' + IntToStr(CurrentPage), 35));

      case PrintOrder of
        ParcelID : ReportTypeString := 'PARCEL ID ORDER';
        VariancePercent : ReportTypeString := 'DESCENDING VARIANCE PERCENT ORDER';
      end;  {case PrintOrderRadioGroup.ItemIndex of}

      ReportTypeString := ReportTypeString + ' ORDER';

      Println(#9 + Take(43, UpcaseStr(GetMunicipalityName)) +
              Center(ReportTypeString, 43) +
              RightJustify('Date: ' + DateToStr(Date) +
                           '  Time: ' + TimeToStr(Now), 35));

      Println(Center(LastYear + '\' + CurrentYear + ' ASSESSMENT YEARS', 132));
      Println('');

        {CHG02182004-1(2.07l1): Allow search of changed roll sections.}
        {CHG06052004-2(2.07l5): Add land AV to AV variance report.}

      ClearTabs;
      SetTab(0.3, pjCenter, 0.1, 0, BoxLineNone, 0);  {Partial assessment}
      SetTab(0.5, pjCenter, 1.6, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.2, pjCenter, 1.2, 0, BoxLineNone, 0);  {Name}
      SetTab(3.5, pjCenter, 1.3, 0, BoxLineNone, 0);  {Location}
      SetTab(4.9, pjCenter, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(5.3, pjCenter, 0.6, 0, BoxLineNone, 0);  {School}
      SetTab(6.0, pjCenter, 0.4, 0, BoxLineNone, 0);  {Prior R\S}
      SetTab(6.5, pjCenter, 0.4, 0, BoxLineNone, 0);  {R\S}
      SetTab(7.0, pjCenter, 0.9, 0, BoxLineNone, 0);  {TY land AV}
      SetTab(8.0, pjCenter, 0.9, 0, BoxLineNone, 0);  {NY land AV}
      SetTab(9.0, pjCenter, 1.1, 0, BoxLineNone, 0);  {TY AV}
      SetTab(10.2, pjCenter, 1.1, 0, BoxLineNone, 0);  {NY AV}
      SetTab(11.4, pjCenter, 1.1, 0, BoxLineNone, 0);  {Variance}
      SetTab(12.6, pjCenter, 0.8, 0, BoxLineNone, 0);  {Var %}
      SetTab(13.5, pjCenter, 0.5, 0, BoxLineNone, 0);  {Order}

      Println(#9 + #9 + #9 + #9 +
              #9 + 'PRP' +
              #9 +
              #9 + LastYear +
              #9 + CurrentYear +
              #9 + LastYear +
              #9 + CurrentYear +
              #9 + LastYear +
              #9 + CurrentYear +
              #9 + #9 + 'VARIANCE');

        {We want to turn on the BoxLineBottom for underlining the tabs on
         the lowest line.}

      For I := 1 to 10 do
        begin
          TempTab := GetTab(I);
          TempTab^.Bottom := True;
        end;  {For I := 1 to 13 do}

      Print(#9 + #9 + 'PARCEL ID' +
            #9 + 'NAME' +
            #9 + 'LOCATION' +
            #9 + 'CLS' +
            #9 + 'SCHOOL' +
            #9 + 'RS' +
            #9 + 'RS' +
            #9 + 'LAND AV' +
            #9 + 'LAND AV' +
            #9 + 'ASSESSMENT' +
            #9 + 'ASSESSMENT' +
            #9 + 'VARIANCE' +
            #9 + 'PERCENT');

      If (PrintOrder = ParcelID)
        then Println('')
        else Println(#9 + 'ORDER');

      ClearTabs;
      SetTab(0.3, pjCenter, 0.1, 0, BoxLineNone, 0);  {Partial assessment}
      SetTab(0.5, pjLeft, 1.6, 0, BoxLineNone, 0);  {Parcel ID}
      SetTab(2.2, pjLeft, 1.2, 0, BoxLineNone, 0);  {Name}
      SetTab(3.5, pjLeft, 1.3, 0, BoxLineNone, 0);  {Location}
      SetTab(4.9, pjLeft, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(5.3, pjLeft, 0.6, 0, BoxLineNone, 0);  {School}
      SetTab(6.0, pjCenter, 0.4, 0, BoxLineNone, 0);  {Prior R\S}
      SetTab(6.5, pjCenter, 0.4, 0, BoxLineNone, 0);  {R\S}
      SetTab(7.0, pjRight, 0.9, 0, BoxLineNone, 0);  {TY land AV}
      SetTab(8.0, pjRight, 0.9, 0, BoxLineNone, 0);  {NY land AV}
      SetTab(9.0, pjRight, 1.1, 0, BoxLineNone, 0);  {TY AV}
      SetTab(10.2, pjRight, 1.1, 0, BoxLineNone, 0);  {NY AV}
      SetTab(11.4, pjRight, 1.1, 0, BoxLineNone, 0);  {Variance}
      SetTab(12.6, pjRight, 0.8, 0, BoxLineNone, 0);  {Var %}
      SetTab(13.5, pjRight, 0.5, 0, BoxLineNone, 0);  {Order}

      Println('');
      CurrentLineNumber := CurrentLineNumber + 8;

    end;  {with Sender as TBaseReport do}

end;  {ReportFilerPrintHeader}

{===================================================================}
Procedure TAssessmentVarianceReportForm.TextReportPrint(Sender: TObject);

var
  Quit, Done, FirstTimeThrough : Boolean;
  OrderNo : LongInt;
  TotalParcelsChanged, TotalVariance,
  TotalCurrentLandValue, TotalPriorLandValue,
  TotalCurrentAssessedVal, TotalPriorAssessedVal : LongInt;
  TotalVariancePercent : Real;
  TempStr : String;

begin
  Done := False;
  FirstTimeThrough := True;
  Quit := False;
  OrderNo := 1;
  TotalCurrentAssessedVal := 0;
  TotalPriorAssessedVal := 0;
  TotalCurrentLandValue := 0;
  TotalPriorLandValue := 0;
  TotalParcelsChanged := 0;

  with Sender as TBaseReport do
    begin
      try
        If (PrintOrder = ParcelID)
          then SortTable.First
          else SortTable.Last;  {Descending variance order.}

      except
        Quit := True;
        SystemSupport(050, SortTable, 'Error getting exemption sort record.',
                      UnitName, GlblErrorDlgBox);
      end;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else
            try
              If (PrintOrder = ParcelID)
                then SortTable.Next
                else SortTable.Prior;  {Descending variance percent order}

            except
              Quit := True;
              SystemSupport(050, SortTable, 'Error getting exemption sort record.',
                            UnitName, GlblErrorDlgBox);
            end;

        If (((PrintOrder = ParcelID) and
              SortTable.EOF) or
            ((PrintOrder = VariancePercent) and
              SortTable.BOF))
          then Done := True;

        If not (Done or Quit)
          then
            begin
              with SortTable do
                case PrintOrderRadioGroup.ItemIndex of
                  0 : ProgressDialog.Update(Self,
                                            'S\B\L: ' + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text));
                  1 : ProgressDialog.Update(Self,
                                            'Var %: ' + FormatFloat(DecimalDisplay,
                                                                    FieldByName('VariancePercent').AsFloat));

                end;  {case PrintOrderRadioGroup.ItemIndex of}

              If (CurrentLineNumber > (NumLinesPerPage - LinesAtBottom))
                then
                  begin
                    CurrentLineNumber := 0;
                    Println('');
                    Println(#9 + #9 + '* = Partial Assessment.');
                    NewPage;
                  end;

                {Print the line.}
                {CHG02182004-1(2.07l1): Allow search of changed roll sections.}
                {CHG06052004-2(2.07l5): Add land AV to AV variance report.}

              with SortTable do
                begin
                  CurrentLineNumber := CurrentLineNumber + 1;

                    {CHG06102004-1(2.07l5): Add partial assessment flag.}

                  If FieldByName('PartialAssessment').AsBoolean
                    then
                      begin
                        TempStr := 'Yes';
                        Print(#9 + '*');
                      end
                    else
                      begin
                        TempStr := '';
                        Print(#9);
                      end;

                    {CHG06102004-1(2.07l5): Add partial assessment flag.}

                  Print(#9 + ConvertSBLOnlyToDashDot(Copy(FieldByName('SwisSBLKey').Text, 7, 20)) +
                        #9 + Take(11, FieldByName('Name').Text) +
                        #9 + Take(11, FieldByName('Location').Text) +
                        #9 + FieldByName('PropertyClass').Text +
                        #9 + FieldByName('SchoolCode').Text +
                        #9 + FieldByName('PriorRollSection').Text +
                        #9 + FieldByName('RollSection').Text +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('PriorLandVal').AsInteger) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('LandVal').AsInteger) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('PriorAssessedVal').AsInteger) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('AssessedVal').AsInteger) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('Variance').AsInteger) +
                        #9 + FormatFloat(DecimalDisplay,
                                         FieldByName('VariancePercent').AsFloat));

                    TotalCurrentLandValue := TotalCurrentLandValue +
                                             FieldByName('LandVal').AsInteger;
                    TotalPriorLandValue := TotalPriorLandValue +
                                           FieldByName('PriorLandVal').AsInteger;
                    TotalCurrentAssessedVal := TotalCurrentAssessedVal +
                                               FieldByName('AssessedVal').AsInteger;
                    TotalPriorAssessedVal := TotalPriorAssessedVal +
                                             FieldByName('PriorAssessedVal').AsInteger;

                    TotalParcelsChanged := TotalParcelsChanged + 1;

                      {CHG11092003-1(2.07k): Option to print to Excel.}
                      {CHG06102004-1(2.07l5): Add partial assessment flag.}

                    If PrintToExcel
                      then Writeln(ExtractFile, TempStr,
                                                FormatExtractField(Copy(FieldByName('SwisSBLKey').Text, 1, 6)),
                                                FormatExtractField(ConvertSBLOnlyToDashDot(Copy(FieldByName('SwisSBLKey').Text, 7, 20))),
                                                FormatExtractField(FieldByName('SchoolCode').Text),
                                                FormatExtractField(FieldByName('Name').Text),
                                                FormatExtractField(FieldByName('Location').Text),
                                                FormatExtractField(FieldByName('PriorRollSection').Text),
                                                FormatExtractField(FieldByName('RollSection').Text),
                                                FormatExtractField(FieldByName('PropertyClass').Text),
                                                FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign,
                                                                               FieldByName('PriorLandVal').AsFloat)),
                                                FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign,
                                                                               FieldByName('LandVal').AsFloat)),
                                                FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign,
                                                                               FieldByName('PriorAssessedVal').AsFloat)),
                                                FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign,
                                                                               FieldByName('AssessedVal').AsFloat)),
                                                FormatExtractField(FormatFloat(CurrencyDisplayNoDollarSign,
                                                                               FieldByName('Variance').AsFloat)),
                                                FormatExtractField(FormatFloat(DecimalDisplay,
                                                                               FieldByName('VariancePercent').AsFloat)));

                  end;  {with SortTable do}

              If (PrintOrder = ParcelID)
                then Println('')
                else
                  begin
                    Println(#9 + IntToStr(OrderNo));
                    OrderNo := OrderNo + 1;
                  end;

              If (bDisplayChangeReason and
                  _Compare(SortTable.FieldByName('ChangeReason').AsString, coNotBlank))
              then
              begin
                Println(#9 + #9 + 'Change Reason: ' + SortTable.FieldByName('ChangeReason').AsString);
                Println('');
                CurrentLineNumber := CurrentLineNumber + 2;
              end;

            end;  {If not Done or Quit}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or Quit or ReportCancelled);

      TotalVariance := TotalCurrentAssessedVal - TotalPriorAssessedVal;

      try
        TotalVariancePercent := Roundoff(((TotalCurrentAssessedVal - TotalPriorAssessedVal) /
                                         TotalPriorAssessedVal * 100), 1);
      except
        TotalVariancePercent := 0;
      end;

      Println('');
      Println(#9 + 'TOTAL' +
              #9 + #9 + #9 + #9 + #9 + #9 + #9 +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               TotalPriorLandValue) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               TotalCurrentLandValue) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               TotalPriorAssessedVal) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               TotalCurrentAssessedVal) +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                               TotalVariance) +
              #9 + FormatFloat(DecimalDisplay,
                               TotalVariancePercent));

      Println('');
      Println(#9 + 'NUMBER OF CHANGES: ' + IntToStr(TotalParcelsChanged));
      Println(#9 + 'TOTAL VARIANCE...: ' +
                   FormatFloat(CurrencyDisplayNoDollarSign, TotalVariance));

      Println('');
      Println(#9 + #9 + '* = Partial Assessment');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{==================================================================}
Procedure TAssessmentVarianceReportForm.ReportPrint(Sender: TObject);

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

{===================================================================}
Procedure TAssessmentVarianceReportForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

  SelectedSwisCodes.Free;
  SelectedRollSections.Free;
  SelectedSchoolCodes.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.