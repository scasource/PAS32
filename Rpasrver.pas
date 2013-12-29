unit Rpasrver;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,
  RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Types, RPTXFilr,
  UASMWARN, TabNotBk, PasTypes, ComCtrls;

type
  TAssessorsVerificationReportForm = class(TForm)
    ParcelTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    TextFiler: TTextFiler;
    CurrentAssessmentTable: TTable;
    PriorAssessmentTable: TTable;
    SwisCodeTable: TTable;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Panel3: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    OptionsPageControl: TPageControl;
    MessagesTabSheet: TTabSheet;
    GroupBox1: TGroupBox;
    FrozenAssessmentCheckBox: TCheckBox;
    ShowZeroAssessmentsCheckBox: TCheckBox;
    ShowInactiveParcelsCheckBox: TCheckBox;
    DuplicateExemptionsCheckBox: TCheckBox;
    ShowBasicAndEnhancedCheckBox: TCheckBox;
    ImprovementChangeCheckBox: TCheckBox;
    GasAndOilWellCheckBox: TCheckBox;
    WhollyExemptNotRS8CheckBox: TCheckBox;
    OutOfBalanceCheckBox: TCheckBox;
    RS8NoExemptionCheckBox: TCheckBox;
    SplitMergeAVChangeCheckBox: TCheckBox;
    ChangeInARFieldsCheckBox: TCheckBox;
    PhysicalQtyIncAndDecCheckBox: TCheckBox;
    EqualizationIncAndDecCheckBox: TCheckBox;
    VacantLotCheckBox: TCheckBox;
    NonVacantCheckBox: TCheckBox;
    Panel4: TPanel;
    AllButton: TBitBtn;
    NoneButton: TBitBtn;
    MoreMessagesTabSheet: TTabSheet;
    GroupBox2: TGroupBox;
    ShowSeniorWithoutEnhancedCheckBox: TCheckBox;
    VacantLandExemptionCheckBox: TCheckBox;
    NonResidentialSTARCheckBox: TCheckBox;
    NoTerminationDateCheckBox: TCheckBox;
    OnlyCountyOrTownCheckBox: TCheckBox;
    ClergyWarningCheckBox: TCheckBox;
    ExemptionsGreaterThanAssessedValueCheckBox: TCheckBox;
    LandAreaMismatchCheckBox: TCheckBox;
    STAROnTYnotNYCheckBox: TCheckBox;
    RS8PartialExemptionCheckBox: TCheckBox;
    OptionsTabSheet: TTabSheet;
    AssessmentYearRadioGroup: TRadioGroup;
    OptionsGroupBox: TGroupBox;
    LoadFromParcelListCheckBox: TCheckBox;
    InventoryWarningsCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    PrintMessagesFirstPageOnlyCheckBox: TCheckBox;
    PrintBySwisCodeCheckBox: TCheckBox;
    HistoryEdit: TEdit;
    cb_AVChangeOnOverrideSD: TCheckBox;
    cb_AVChangeOnParcelWithSaleGreaterThan1Parcel: TCheckBox;
    cbxColdWarVeteranOnParcelWithOtherVeteran: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrintButtonClick(Sender: TObject);
    procedure TextFilerPrintHeader(Sender: TObject);
    procedure TextFilerPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure AllButtonClick(Sender: TObject);
    procedure NoneButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AssessmentYearRadioGroupClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName, AssessmentYear,
    CurrentAssessmentYear, PriorAssessmentYear : String;
    ProcessingType : Integer;
    ReportCancelled : Boolean;
    WarningOptions : WarningTypesSet;
    OnePageOfWarningMessagesOnly,
    PrintBySwisCode,
    CreateParcelList,
    LoadFromParcelList : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure PrintOneLine(Sender : TObject;
                           SwisSBLKey : String;
                           WarningCode : Integer);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Preview,
     Prog,
     RptDialg,  {Report options dialog}
     DataModule,
     PRCLLIST;

{$R *.DFM}

const
  ayThisYear = 0;
  ayNextYear = 1;
  ayHistory = 2;

{========================================================}
Procedure TAssessorsVerificationReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TAssessorsVerificationReportForm.InitializeForm;

begin
  UnitName := 'RPASRVER';
  ProcessingType := GlblProcessingType;

    {CHG12082004-2(2.8.1.2)[2019]: Make it work in history.}

  with AssessmentYearRadioGroup do
    case GlblProcessingType of
      ThisYear : ItemIndex := ayThisYear;
      NextYear : ItemIndex := ayNextYear;
      History :
        begin
          ItemIndex := ayHistory;
          HistoryEdit.Text := GlblHistYear;

        end;  {ayHistory}

    end;  {case GlblProcessingType of}

  AssessmentYearRadioGroupClick(nil);

end;  {InitializeForm}

{====================================================================}
Procedure TAssessorsVerificationReportForm.AssessmentYearRadioGroupClick(Sender: TObject);

begin
    {CHG12082004-2(2.8.1.2)[2019]: Make it work in history.}

  HistoryEdit.Visible := False;

  case AssessmentYearRadioGroup.ItemIndex of
    ayHistory : begin
                  HistoryEdit.Visible := True;
                  ProcessingType := History;
                  AssessmentYear := HistoryEdit.Text;
                end;  {History}

    ayNextYear : begin
                   ProcessingType := NextYear;
                   AssessmentYear := GlblNextYear;
                 end;  {NextYear}

    ayThisYear : begin
                   ProcessingType := ThisYear;
                   AssessmentYear := GlblThisYear;
                 end;  {This Year}

  end;  {case AssessmentYearRadioGroup.ItemIndex do}

end;  {AssessmentYearRadioGroupClick}

{====================================================================}
Procedure TAssessorsVerificationReportForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'asrver.ver', 'Assessor''s Verification Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TAssessorsVerificationReportForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'asrver.ver', 'Assessor''s Verification Report');

end;  {LoadButtonClick}

{=========================================================================}
Procedure TAssessorsVerificationReportForm.AllButtonClick(Sender: TObject);

{Select all the warnings.}

var
  I : Integer;
  TempStr : String;

begin
  For I := 0 to (ComponentCount - 1) do
    If (Components[I] is TCheckBox)
      then
        with Components[I] as TCheckBox do
          begin
            TempStr := Caption;

              {The first character of the options check boxes start with numbers.
               If this is not a checkbox whose caption starts with a number, a silent
               exception will be raised and nothing will be done to this check box.}

            try
              StrToInt(TempStr[1]);
              Checked := True;
            except
            end;

          end;  {with Components[I] as TCheckBox do}

end;  {AllButtonClick}

{===================================================================}
Procedure TAssessorsVerificationReportForm.NoneButtonClick(Sender: TObject);

{Unselect all the warnings.}

var
  I : Integer;
  TempStr : String;

begin
  For I := 0 to (ComponentCount - 1) do
    If (Components[I] is TCheckBox)
      then
        with Components[I] as TCheckBox do
          begin
            TempStr := Caption;

              {The first character of the options check boxes start with numbers.
               If this is not a checkbox whose caption starts with a number, a silent
               exception will be raised and nothing will be done to this check box.}

            try
              StrToInt(TempStr[1]);
              Checked := False;
            except
            end;

          end;  {with Components[I] as TCheckBox do}

end;  {NoneButtonClick}

{=================================================================}
Procedure TAssessorsVerificationReportForm.PrintButtonClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName, TextFileName : String;
  CurrentProcessingType, PriorProcessingType : Integer;

begin
  Quit := False;
  ReportCancelled := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  PrintButton.Enabled := False;
  Application.ProcessMessages;

  If PrintDialog.Execute
    then
      begin
        PriorProcessingType := ThisYear;

        TextFiler.SetFont('Courier New', 10);

        LoadFromParcelList := LoadFromParcelListCheckBox.Checked;
        CreateParcelList := CreateParcelListCheckBox.Checked;

        OnePageOfWarningMessagesOnly := PrintMessagesFirstPageOnlyCheckBox.Checked;

        PrintBySwisCode := PrintBySwisCodeCheckBox.Checked;

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

        PromptForLetterSize(ReportPrinter, ReportFiler, 80, 80, 1.5);

        If not Quit
          then
            begin
              case ProcessingType of
                NextYear : PriorProcessingType := ThisYear;
                ThisYear : PriorProcessingType := History;
                History : begin
                            PriorProcessingType := History;
                            AssessmentYear := HistoryEdit.Text;
                          end;

              end;  {case ProcessingType of}

              CurrentProcessingType := ProcessingType;
              CurrentAssessmentYear := AssessmentYear;
              PriorAssessmentYear := IntToStr(StrToInt(CurrentAssessmentYear) - 1);

                {CHG060101999-2: Allow the user to select exactly which messages to show.}

              WarningOptions := [];

              If ShowInactiveParcelsCheckBox.Checked
                then WarningOptions := WarningOptions + [wtInactiveParcels];

              If OutOfBalanceCheckBox.Checked
                then WarningOptions := WarningOptions + [wtOutOfBalance];

              If RS8NoExemptionCheckBox.Checked
                then WarningOptions := WarningOptions + [wtRS8NoExemption];

              If WhollyExemptNotRS8CheckBox.Checked
                then WarningOptions := WarningOptions + [wtWhollyExemptNotRS8];

              If ShowZeroAssessmentsCheckBox.Checked
                then WarningOptions := WarningOptions + [wtZeroAssessments];

              If FrozenAssessmentCheckBox.Checked
                then WarningOptions := WarningOptions + [wtFrozenAssessments];

              If GasAndOilWellCheckBox.Checked
                then WarningOptions := WarningOptions + [wtGasAndOilWells];

              If ImprovementChangeCheckBox.Checked
                then WarningOptions := WarningOptions + [wtImprovementChange];

              If SplitMergeAVChangeCheckBox.Checked
                then WarningOptions := WarningOptions + [wtSplitMerge];

              If ChangeInARFieldsCheckBox.Checked
                then WarningOptions := WarningOptions + [wtARFilledIn_NoAVChange];

              If PhysicalQtyIncAndDecCheckBox.Checked
                then WarningOptions := WarningOptions + [wtPhysIncAndDec];

              If EqualizationIncAndDecCheckBox.Checked
                then WarningOptions := WarningOptions + [wtEqualIncAndDec];

              If VacantLotCheckBox.Checked
                then WarningOptions := WarningOptions + [wtVacantLand];

              If NonVacantCheckBox.Checked
                then WarningOptions := WarningOptions + [wtNonVacantLand];

                {CHG05131999-1: Warn if duplicate exemptions on parcel or basic and enhanced.}

              If DuplicateExemptionsCheckBox.Checked
                then WarningOptions := WarningOptions + [wtDuplicateExemptions];

              If ShowBasicAndEnhancedCheckBox.Checked
                then WarningOptions := WarningOptions + [wtBasicAndEnhanced];

              If ShowSeniorWithoutEnhancedCheckBox.Checked
                then WarningOptions := WarningOptions + [wtSeniorWithoutEnhanced];

              If VacantLandExemptionCheckBox.Checked
                then WarningOptions := WarningOptions + [wtExemptionOnVacant];

              If NonResidentialSTARCheckBox.Checked
                then WarningOptions := WarningOptions + [wtSTARonNonResidential];

              If NoTerminationDateCheckBox.Checked
                then WarningOptions := WarningOptions + [wtNoTerminationDate];

              If OnlyCountyOrTownCheckBox.Checked
                then WarningOptions := WarningOptions + [wtCountyOrTownExemptionOnly];

              If InventoryWarningsCheckBox.Checked
                then WarningOptions := WarningOptions + [wtInventoryWarnings];

                {CHG12021999-2: Add exemptions greater than AV to warning list.}

              If ExemptionsGreaterThanAssessedValueCheckBox.Checked
                then WarningOptions := WarningOptions + [wtExemptionsGreaterThanAV];

              If STAROnTYnotNYCheckBox.Checked
                then WarningOptions := WarningOptions + [wtSTARonNYnotTY];

              If RS8PartialExemptionCheckBox.Checked
                then WarningOptions := WarningOptions + [wtPartialExemptionOnRS8];

              If cb_AVChangeOnOverrideSD.Checked
                then WarningOptions := WarningOptions + [wtAVChangeWithOverrideSpecialDistricts];

              If cb_AVChangeOnParcelWithSaleGreaterThan1Parcel.Checked
                then WarningOptions := WarningOptions + [wtAVChangeWithSaleForMultipleParcels];

                {CHG05112001-2: Check the total of the land records versus the
                                overall acreage.}

              If LandAreaMismatchCheckBox.Checked
                then WarningOptions := WarningOptions + [wtLandRecordSizeNotEqualToOverallSize];

              If cbxColdWarVeteranOnParcelWithOtherVeteran.Checked
                then WarningOptions := WarningOptions + [wtColdWarVetAndRegularVetOnParcel];

              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         ProcessingType, Quit);
              OpenTableForProcessingType(CurrentAssessmentTable, AssessmentTableName,
                                         CurrentProcessingType, Quit);
              OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                                         PriorProcessingType, Quit);
              OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                         ProcessingType, Quit);

              ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
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

              ResetPrinter(ReportPrinter);

              ProgressDialog.Finish;

                {CHG01182000-3: Allow them to choose a different name or copy right away.}

              ShowReportDialog('ASREDIT.RPT', TextFiler.FileName, True);

            end;  {If not Quit}

          {FXX09071999-6: Tell people that printing is starting and
                          done.}

(*        DisplayPrintingFinishedMessage(PrintDialog.PrintToFile); *)

          {FXX09071999-4: Need to show the parcel list.}

        If CreateParcelList
          then ParcelListDialog.Show;

      end;  {If PrintDialog.Execute}

  PrintButton.Enabled := True;

end;  {PrintButtonClick}

{===================================================================}
Procedure TAssessorsVerificationReportForm.TextFilerPrintHeader(Sender: TObject);

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
                 Center('ASSESSOR''S VERIFICATION REPORT', (130 - 2 * Length(TempStr)));
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

        {CHG09131999-1: Allow option of whether or not to print by swis code.}

      If PrintBySwisCode
        then
          begin
            TempStr := 'SWIS - ' + ParcelTable.FieldByName('SwisCode').Text;
            Println(UpcaseStr(TempStr) +
                    ' (' + Trim(SwisCodeTable.FieldByName('MunicipalityName').Text + ')'));
          end;

      Println('');

      ClearTabs;
      SetTab(0.2, pjRight, 0.1, 0, BoxLineNone, 0);  {Inactive}
      SetTab(0.4, pjCenter, 0.8, 0, BoxLineNone, 0); {SM#}
      SetTab(1.3, pjCenter, 1.8, 0, BoxLineNone, 0); {Parcel ID}
      SetTab(3.2, pjCenter, 1.0, 0, BoxLineNone, 0); {Name}
      SetTab(4.3, pjRight, 0.2, 0, BoxLineNone, 0);  {Year}
      SetTab(4.6, pjRight, 0.2, 0, BoxLineNone, 0);  {Homestead code}
      SetTab(4.9, pjRight, 0.2, 0, BoxLineNone, 0);  {RS}
      SetTab(5.2, pjRight, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(5.6, pjCenter, 0.3, 0, BoxLineNone, 0);  {Msg #}
      SetTab(6.0, pjCenter, 1.1, 0, BoxLineNone, 0);  {Prior AV}
      SetTab(7.2, pjCenter, 1.1, 0, BoxLineNone, 0);  {Current AV}
      SetTab(8.4, pjCenter, 1.1, 0, BoxLineNone, 0);  {Phys Inc}
      SetTab(9.6, pjCenter, 1.1, 0, BoxLineNone, 0);  {Phys Dec}
      SetTab(10.8, pjCenter, 1.1, 0, BoxLineNone, 0); {Equal Inc}
      SetTab(12.0, pjCenter, 1.1, 0, BoxLineNone, 0); {Equal Dec}

      Println(#9 +
              #9 + 'SPLIT' +
              #9 + 'PARCEL ID' +
              #9 + 'NAME' +
              #9 + 'YR' +
              #9 + 'HC' +
              #9 + 'RS' +
              #9 + 'PRP' +
              #9 + 'MSG' +
              #9 + 'ASSESSED' +
              #9 + 'ASSESSED' +
              #9 + 'PHY \ QTY' +
              #9 + 'EQUALIZATION' +
              #9 + 'PHY \ QTY' +
              #9 + 'EQUALIZATION');

      Println(#9 +
              #9 + 'MERGE #' +
              #9 + #9 + #9 + #9 + #9 +
              #9 + 'CLS' +
              #9 + '#' +
              #9 + 'PRIOR' +
              #9 + 'CURRENT' +
              #9 + 'INCREASE' +
              #9 + 'INCREASE' +
              #9 + 'DECREASE' +
              #9 + 'DECREASE');

      ClearTabs;
      SetTab(0.2, pjRight, 0.1, 0, BoxLineNone, 0);  {Inactive}
      SetTab(0.4, pjLeft, 0.8, 0, BoxLineNone, 0); {SM#}
      SetTab(1.3, pjLeft, 1.8, 0, BoxLineNone, 0); {Parcel ID}
      SetTab(3.2, pjLeft, 1.0, 0, BoxLineNone, 0); {Name}
      SetTab(4.3, pjLeft, 0.2, 0, BoxLineNone, 0);  {Year}
      SetTab(4.6, pjLeft, 0.2, 0, BoxLineNone, 0);  {Homestead code}
      SetTab(4.9, pjLeft, 0.2, 0, BoxLineNone, 0);  {RS}
      SetTab(5.2, pjLeft, 0.3, 0, BoxLineNone, 0);  {Prop class}
      SetTab(5.6, pjRight, 0.3, 0, BoxLineNone, 0);  {Msg #}
      SetTab(6.0, pjRight, 1.1, 0, BoxLineNone, 0);  {Prior AV}
      SetTab(7.2, pjRight, 1.1, 0, BoxLineNone, 0);  {Current AV}
      SetTab(8.4, pjRight, 1.1, 0, BoxLineNone, 0);  {Phys Inc}
      SetTab(9.6, pjRight, 1.1, 0, BoxLineNone, 0);  {Phys Dec}
      SetTab(10.8, pjRight, 1.1, 0, BoxLineNone, 0); {Equal Inc}
      SetTab(12.0, pjRight, 1.1, 0, BoxLineNone, 0); {Equal Dec}

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TAssessorsVerificationReportForm.PrintOneLine(Sender : TObject;
                                                        SwisSBLKey : String;
                                                        WarningCode : Integer);

var
  PriorAssessedVal, CurrentAssessedVal,
  PhysicalQtyIncrease, PhysicalQtyDecrease,
  IncreaseForEqual, DecreaseForEqual : Comp;
  FoundPriorAssessment : Boolean;

begin
  FindKeyOld(CurrentAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
             [CurrentAssessmentYear, SwisSBLKey]);

  with CurrentAssessmentTable do
    begin
      PhysicalQtyIncrease := FieldByName('PhysicalQtyIncrease').AsFloat;
      PhysicalQtyDecrease := FieldByName('PhysicalQtyDecrease').AsFloat;
      IncreaseForEqual := FieldByName('IncreaseForEqual').AsFloat;
      DecreaseForEqual := FieldByName('DecreaseForEqual').AsFloat;
      CurrentAssessedVal := FieldByName('TotalAssessedVal').AsFloat;

    end;  {with CurrentAssessmentTable do}

  FoundPriorAssessment := FindKeyOld(PriorAssessmentTable,
                                     ['TaxRollYr', 'SwisSBLKey'],
                                     [PriorAssessmentYear, SwisSBLKey]);

    {If there is no history yet, then we will use the prior value field of
     the TY record.}

  If FoundPriorAssessment
    then PriorAssessedVal := PriorAssessmentTable.FieldByName('TotalAssessedVal').AsFloat
    else PriorAssessedVal := CurrentAssessmentTable.FieldByName('PriorTotalValue').AsFloat;

  with Sender as TBaseReport do
    begin
      If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
        then Print(#9 + '*')
        else Print(#9);

      with ParcelTable do
        begin
          Print(#9 + FieldByName('SplitMergeNo').Text);

             {CHG09131999-1: Allow option of whether or not to print by swis code.}

          If PrintBySwisCode
            then Print(#9 + ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)))
            else Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));

          Println(#9 + Take(10, FieldByName('Name1').Text) +
                  #9 + Copy(AssessmentYear, 3, 2) +
                  #9 + FieldByName('HomesteadCode').Text +
                  #9 + FieldByName('RollSection').Text +
                  #9 + FieldByName('PropertyClassCode').Text +
                  #9 + IntToStr(WarningCode) +
                  #9 + FormatFloat(CurrencyDisplayNoDollarSign, PriorAssessedVal) +
                  #9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentAssessedVal) +
                  #9 + FormatFloat(CurrencyDisplayNoDollarSign, PhysicalQtyIncrease) +
                  #9 + FormatFloat(CurrencyDisplayNoDollarSign, IncreaseForEqual) +
                  #9 + FormatFloat(CurrencyDisplayNoDollarSign, PhysicalQtyDecrease) +
                  #9 + FormatFloat(CurrencyDisplayNoDollarSign, DecreaseForEqual));

        end;  {with ParcelTable do}

    end;  {with Sender as TBaseReport do}

end;  {PrintOneLine}

{===================================================================}
Procedure TAssessorsVerificationReportForm.TextFilerPrint(Sender: TObject);

var
  FirstTimeThrough, Done : Boolean;
  WarningCodeList, WarningDescList : TStringList;
  SwisSBLKey : String;
  LastSwisCode : String;
  WarningsChosen, I, Index, NumFound : Integer;
  TempStr : String;

begin
  FirstTimeThrough := True;
  Done := False;
  NumFound := 0;
  Index := 1;

  WarningsChosen := 0;
  For I := 0 to (ComponentCount - 1) do
    If (Components[I] is TCheckBox)
      then
        with Components[I] as TCheckBox do
          begin
            TempStr := Caption;

              {The first character of the options check boxes start with numbers.
               If this is not a checkbox whose caption starts with a number, a silent
               exception will be raised and nothing will be done to this check box.}

            try
              StrToInt(TempStr[1]);
              If Checked
                then WarningsChosen := WarningsChosen + 1;
            except
            end;

          end;  {with Components[I] as TCheckBox do}


  WarningCodeList := TStringList.Create;
  WarningDescList := TStringList.Create;

    {CHG03101999-1: Send info to a list or load from a list.}

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

    {CHG03191999-2: Add option to load from parcel list.}

  If LoadFromParcelList
    then
      begin
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
      end
    else
      begin
        ParcelTable.First;
        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);
      end;

  LastSwisCode := ParcelTable.FieldByName('SwisCode').Text;

    {CHG09091999-1: Allow them to print the message listing on the first page only.}

  If OnePageOfWarningMessagesOnly
    then
      with Sender as TBaseReport do
        begin
          ClearTabs;
          SetTab(0.3, pjRight, 0.2, 0, BoxLineNone, 0);
          SetTab(0.6, pjLeft, 12, 0, BoxLineNone, 0);

            {FXX06291999-8: Only print the numbers of the warnings that they selected.}

          For I := 1 to WarningMessageCount do
            If WarningSelected(WarningOptions, I)
              then Println(#9 + IntToStr(I) +
                           #9 + GetParcelWarningMessage(I));

          NewPage;

      end;  {with Sender as TBaseReport do}

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
      else ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

    SwisSBLKey := ExtractSSKey(ParcelTable);
    Application.ProcessMessages;

      {Go to the next page, printing warning messages on bottom.}
      {CHG09131999-1: Allow option of whether or not to print by swis code.}
      {FXX10111999-1: Was not paging when did by swis, print warnings on one page.}

    with Sender as TBaseReport do
      If (((not OnePageOfWarningMessagesOnly) and
           (LinesLeft < (WarningsChosen + 6))) or  {No more room}
          (OnePageOfWarningMessagesOnly and
           (LinesLeft < 6)) or
          ((not LoadFromParcelList) and  {Don't page for each change in swis on parcel list.}
           PrintBySwisCode and
           (LastSwisCode <> ParcelTable.FieldByName('SwisCode').Text)) or {Change swis}
          (Done or ReportCancelled))  {End of report}
        then
          begin
              {Make sure we are at the bottom of the page.}

            while (LinesLeft > (WarningsChosen + 6)) do
              Println('');

            ClearTabs;
            SetTab(0.3, pjLeft, 3.0, 0, BoxLineNone, 0);

            Println(#9 + '* = Inactive Parcels');
            Println('');

            ClearTabs;
            SetTab(0.3, pjRight, 0.2, 0, BoxLineNone, 0);
            SetTab(0.6, pjLeft, 12, 0, BoxLineNone, 0);

              {FXX06291999-8: Only print the numbers of the warnings that they selected.}

            If not OnePageOfWarningMessagesOnly
              then
                For I := 1 to WarningMessageCount do
                  If WarningSelected(WarningOptions, I)
                    then Println(#9 + IntToStr(I) +
                                 #9 + GetParcelWarningMessage(I));

            If not Done
              then NewPage;

          end;  {If ((LinesLeft < 24) or ...}

    If not Done
      then
        begin
          GetParcelWarnings(AssessmentYear, SwisSBLKey,
                            WarningCodeList, WarningDescList,
                            WarningOptions);

          If (WarningCodeList.Count > 0)
            then
              begin
                NumFound := NumFound + 1;
                ProgressDialog.UserLabelCaption := 'Parcels in Error = ' + IntToStr(NumFound);

                  {CHG03101999-1: Send info to a list.}

                If CreateParcelList
                  then ParcelListDialog.AddOneParcel(SwisSBLKey);

                For I := 0 to (WarningCodeList.Count - 1) do
                  PrintOneLine(Sender, SwisSBLKey, StrToInt(WarningCodeList[I]));

              end;  {If (WarningCodeList.Count > 0)}

          LastSwisCode := ParcelTable.FieldByName('SwisCode').Text;

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

      {FXX11301999-2: Allow the parcel warning tables to stay open so
                    that warning report does not take so long.}

  CloseParcelWarningTables;

  WarningCodeList.Free;
  WarningDescList.Free;

end;  {ReportPrint}

{==================================================================}
Procedure TAssessorsVerificationReportForm.ReportPrint(Sender: TObject);

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
Procedure TAssessorsVerificationReportForm.FormClose(    Sender: TObject;
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