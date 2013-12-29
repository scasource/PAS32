unit Exrecalc;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, (*Progress,*)
  RPCanvas, RPrinter, RPDefine, RPBase, RPFiler;

type
  TExemptionRecalculationForm = class(TForm)
    ParcelExemptionTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    Label7: TLabel;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    ChooseTaxYearRadioGroup: TRadioGroup;
    PrintDialog: TPrintDialog;
    AuditEXChangeTable: TTable;
    EditHistory: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure ReportHeader(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ChooseTaxYearRadioGroupClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ProcessingType : Integer;
    ClassTable,
    AssessmentTable,
    ParcelTable,
    SwisCodeTable,
    ExemptionCodeTable : TTable;
    AssessmentYear : String;
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, UTILEXSD,  Types,
     PASTypes, Prog,
     RTCalcul, Preview, ExemptionsNotRecalculatedFormUnit;

const
  TrialRun = False;

{$R *.DFM}

{========================================================}
Procedure TExemptionRecalculationForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TExemptionRecalculationForm.InitializeForm;

begin
  UnitName := 'EXRECALC.PAS';  {mmm}
end;  {InitializeForm}

{======================================================================}
Procedure TExemptionRecalculationForm.ChooseTaxYearRadioGroupClick(Sender: TObject);

begin
  case ChooseTaxYearRadioGroup.ItemIndex of
    0, 1 : EditHistory.Visible := False;
    2 : begin
          EditHistory.Visible := True;
          EditHistory.SetFocus;
    end;

  end;  {case ChooseTaxYearRadioGroup.ItemIndex of}

end;  {ChooseTaxYearRadioGroupClick}

{=================================================================}
Procedure TExemptionRecalculationForm.StartButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  Quit : Boolean;

begin
  ProcessingType := -1;
  GlblDisplaySystemExemptionConfirmation := False;

    {FXX05181999-2: Trace the add of the system exemption, but only if the
                    calling job requires it - i.e. running exemptions recalc,
                    since other jobs automatically insert a trace rec for the
                    system exemption.}


  GlblInsertSystemExemptionTrace := True;

  case ChooseTaxYearRadioGroup.ItemIndex of
    0 : begin
          ProcessingType := ThisYear;
          AssessmentYear := GlblThisYear;
        end;

    1 : begin
          ProcessingType := NextYear;
          AssessmentYear := GlblNextYear;
        end;

    2 : begin
          ProcessingType := History;
          AssessmentYear := EditHistory.Text;
        end;

    else MessageDlg('Please choose an assessment year.', mtError, [mbOK], 0);

  end;  {case ChooseTaxYearRadioGroup.ItemIndex of}

  If ((ProcessingType <> -1) and
      (MessageDlg('Are you sure you want to recalculate the exemptions?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes) and
      PrintDialog.Execute)
    then
      begin
        OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName,
                                   ProcessingType, Quit);

        try
          AuditEXChangeTable.Open;
        except
          SystemSupport(003, AuditExChangeTable, 'Error opening audit exemption change table.',
                        UnitName, GlblErrorDlgBox);
        end;

        AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                  ProcessingType);
        ParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                              ProcessingType);
        SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                                ProcessingType);
        ExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                     ProcessingType);
        ClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                             ProcessingType);

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

        CloseTablesForForm(Self);

      end;  {If ((MessageDlg(' ...}

  GlblDisplaySystemExemptionConfirmation := True;
  GlblInsertSystemExemptionTrace := False;

end;  {StartButtonClick}

{===================================================================}
Procedure TExemptionRecalculationForm.ReportHeader(Sender: TObject);

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
      PrintCenter('Exemptions Changed Due To Recalculation', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;

      Underline := False;
      ClearTabs;
      SetTab(0.2, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Parcel ID}
      SetTab(1.6, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {Name}
      SetTab(2.9, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {EX Code}
      SetTab(3.5, pjCenter, 0.7, 0, BOXLINENone, 0);   {Type}
      SetTab(4.4, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {County}
      SetTab(5.3, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Town}
      SetTab(6.2, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {School}
      SetTab(7.1, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Village}

      Print(#9 + 'Parcel ID' +
            #9 + 'Name' +
            #9 + 'EX Code' +
            #9 + '');

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + 'County');

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + GetShortMunicipalityTypeName(GlblMunicipalityType));

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + 'School');

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + 'Village')
        else Println('');

      ClearTabs;
      SetTab(0.2, pjLeft, 1.3, 0, BoxLineNone, 0);   {Parcel ID}
      SetTab(1.6, pjLeft, 1.2, 0, BoxLineNone, 0);   {Name}
      SetTab(2.9, pjLeft, 0.5, 0, BoxLineNone, 0);   {EX Code}
      SetTab(3.5, pjLeft, 0.7, 0, BoxLineNone, 0);   {Type}
      SetTab(4.4, pjRight, 0.8, 0, BoxLineNone, 0);   {County}
      SetTab(5.3, pjRight, 0.8, 0, BoxLineNone, 0);   {Town}
      SetTab(6.2, pjRight, 0.8, 0, BoxLineNone, 0);   {School}
      SetTab(7.1, pjRight, 0.8, 0, BoxLineNone, 0);   {Village}

    end;  {with Sender as TBaseReport do}

end;  {ReportHeader}

{===================================================================}
Procedure PrintOneLine(    Sender : TObject;
                           ParcelTable : TTable;
                           ExemptionCode : String;
                           OrigCountyAmount,
                           OrigTownAmount,
                           OrigSchoolAmount,
                           OrigVillageAmount,
                           OrigBasicSTARAmount,
                           OrigEnhancedSTARAmount,
                           NewCountyAmount,
                           NewTownAmount,
                           NewSchoolAmount,
                           NewVillageAmount,
                           NewBasicSTARAmount,
                           NewEnhancedSTARAmount : Comp;
                       var FirstExemptionPrintedForParcel : Boolean;
                       var NumPrinted : LongInt);

var
  TempSchoolAmount : Comp;
  SwisSBLKey : String;

begin
  SwisSBLKey := ExtractSSKey(ParcelTable);

  with Sender as TBaseReport do
    begin
      NumPrinted := NumPrinted + 1;

      If FirstExemptionPrintedForParcel
        then
          begin
            Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                  #9 + Take(15, ParcelTable.FieldByName('Name1').Text));
            FirstExemptionPrintedForParcel := False;

          end
        else Print(#9 + #9);

        {FXX05191998-1: Show STAR amount changes, too.}

      If (ExemptionCode = BasicSTARExemptionCode)
        then TempSchoolAmount := OrigBasicSTARAmount
        else
          If (ExemptionCode = EnhancedSTARExemptionCode)
            then TempSchoolAmount := OrigEnhancedSTARAmount
            else TempSchoolAmount := OrigSchoolAmount;

      Print(#9 + ExemptionCode +
            #9 + 'Orig Vals:');

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, OrigCountyAmount));

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, OrigTownAmount));

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TempSchoolAmount));

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, OrigVillageAmount))
        else Println('');

        {FXX05191998-1: Show STAR amount changes, too.}

      If (ExemptionCode = BasicSTARExemptionCode)
        then TempSchoolAmount := NewBasicSTARAmount
        else
          If (ExemptionCode = EnhancedSTARExemptionCode)
            then TempSchoolAmount := NewEnhancedSTARAmount
            else TempSchoolAmount := NewSchoolAmount;

      Print(#9 + #9 + #9 + #9 + 'New Vals:');

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      If (rtdCounty in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, NewCountyAmount));

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, NewTownAmount));

      If (rtdSchool in GlblRollTotalsToShow)
        then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TempSchoolAmount));

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, NewVillageAmount))
        else Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintOneLine}

{===================================================================}
Procedure TExemptionRecalculationForm.ReportPrint(Sender: TObject);

{CHG11241997-2: Print an audit trail.}

var
  FirstExemptionPrintedForParcel,
  FirstTimeThrough, Done, ExemptionAmountsChanged : Boolean;
  SwisSBLKey : String;

  I : Integer;
  NumPrinted : LongInt;

  OrigExemptionCodes,
  OrigExemptionHomesteadCodes,
  OrigResidentialTypes,
  OrigCountyExemptionAmounts,
  OrigTownExemptionAmounts,
  OrigSchoolExemptionAmounts,
  OrigVillageExemptionAmounts,
  NewExemptionCodes,
  NewExemptionHomesteadCodes,
  NewResidentialTypes,
  NewCountyExemptionAmounts,
  NewTownExemptionAmounts,
  NewSchoolExemptionAmounts,
  NewVillageExemptionAmounts : TStringList;

  TotalOrigExemptionAmount,
  TotalNewExemptionAmount,
  TotalOrigCountyExemptionAmount,
  TotalOrigTownExemptionAmount,
  TotalOrigSchoolExemptionAmount,
  TotalOrigVillageExemptionAmount,
  TotalOrigBasicSTARAmount,
  TotalOrigEnhancedSTARAmount,
  TotalNewCountyExemptionAmount,
  TotalNewTownExemptionAmount,
  TotalNewSchoolExemptionAmount,
  TotalNewVillageExemptionAmount,
  TotalNewBasicSTARAmount,
  TotalNewEnhancedSTARAmount : Comp;

  OrigBasicSTARAmount, OrigEnhancedSTARAmount,
  NewBasicSTARAmount, NewEnhancedSTARAmount : Comp;

  RecCount : LongInt;
  AuditEXChangeList, NewAuditEXChangeList : TList;
  ExemptionsNotRecalculatedList, MasterExemptionsNotRecalculatedList : TStringList;

begin
  ExemptionsNotRecalculatedList := TStringList.Create;
  MasterExemptionsNotRecalculatedList := TStringList.Create;
  AuditEXChangeList := TList.Create;
  NewAuditEXChangeList := TList.Create;
  FirstTimeThrough := True;
  Done := False;

  ProgressDialog.UserLabelCaption := 'Recalculating Exemptions.';
  ProgressDialog.Start(GetRecordCount(ParcelTable), False, False);

  OrigExemptionCodes := TStringList.Create;
  OrigExemptionHomesteadCodes := TStringList.Create;
  OrigResidentialTypes := TStringList.Create;
  OrigCountyExemptionAmounts := TStringList.Create;
  OrigTownExemptionAmounts := TStringList.Create;
  OrigSchoolExemptionAmounts := TStringList.Create;
  OrigVillageExemptionAmounts := TStringList.Create;

  NewExemptionCodes := TStringList.Create;
  NewExemptionHomesteadCodes := TStringList.Create;
  NewResidentialTypes := TStringList.Create;
  NewCountyExemptionAmounts := TStringList.Create;
  NewTownExemptionAmounts := TStringList.Create;
  NewSchoolExemptionAmounts := TStringList.Create;
  NewVillageExemptionAmounts := TStringList.Create;

  TotalOrigCountyExemptionAmount := 0;
  TotalOrigTownExemptionAmount := 0;
  TotalOrigSchoolExemptionAmount := 0;
  TotalOrigVillageExemptionAmount := 0;
  TotalNewCountyExemptionAmount := 0;
  TotalNewTownExemptionAmount := 0;
  TotalNewSchoolExemptionAmount := 0;
  TotalNewVillageExemptionAmount := 0;

    {FXX05191998-1: Show STAR amount changes, too.}

  TotalOrigBasicSTARAmount := 0;
  TotalOrigEnhancedSTARAmount := 0;
  TotalNewBasicSTARAmount := 0;
  TotalNewEnhancedSTARAmount := 0;
  RecCount := 0;

    {CHG03192004-1(2.08): Add support for history exemption recalculation.}

  If (ProcessingType = History)
    then
      begin
        ParcelTable.Filter := 'TaxRollYr=' + AssessmentYear;
        ParcelTable.Filtered := True;
      end;

  ParcelTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If (ParcelTable.EOF or
        (TrialRun and
         (RecCount > 100)))
      then Done := True;

    Application.ProcessMessages;

      {FXX12211999-1: Don't do inactive parcels and the STAR amounts were being
                      totalled wrong.}

    If ((not Done) and
        (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
      then
        begin
          RecCount := RecCount + 1;
          SwisSBLKey := ExtractSSKey(ParcelTable);

          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));

          OrigExemptionCodes.Clear;
          OrigExemptionHomesteadCodes.Clear;
          OrigResidentialTypes.Clear;
          OrigCountyExemptionAmounts.Clear;
          OrigTownExemptionAmounts.Clear;
          OrigSchoolExemptionAmounts.Clear;
          OrigVillageExemptionAmounts.Clear;

          NewExemptionCodes.Clear;
          NewExemptionHomesteadCodes.Clear;
          NewResidentialTypes.Clear;
          NewCountyExemptionAmounts.Clear;
          NewTownExemptionAmounts.Clear;
          NewSchoolExemptionAmounts.Clear;
          NewVillageExemptionAmounts.Clear;

          OrigBasicSTARAmount := 0;
          OrigEnhancedSTARAmount := 0;
          NewBasicSTARAmount := 0;
          NewEnhancedSTARAmount := 0;

            {Get the original amounts.}
            {CHG12011997-1: STAR support}
            {FXX02091998-1: Pass the residential type of each exemption.}

          TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                   ParcelExemptionTable,
                                   ExemptionCodeTable,
                                   ParcelTable.FieldByName('HomesteadCode').Text,
                                   'A',
                                   OrigExemptionCodes,
                                   OrigExemptionHomesteadCodes,
                                   OrigResidentialTypes,
                                   OrigCountyExemptionAmounts,
                                   OrigTownExemptionAmounts,
                                   OrigSchoolExemptionAmounts,
                                   OrigVillageExemptionAmounts,
                                   OrigBasicSTARAmount,
                                   OrigEnhancedSTARAmount);

            {CHG06222003-2(2.07e): Audit exemptions that are recalculated.}

          ClearTList(AuditEXChangeList, SizeOf(AuditEXRecord));
          GetAuditEXList(SwisSBLKey, AssessmentYear, ParcelExemptionTable, AuditEXChangeList);

          RecalculateExemptionsForParcel(ExemptionCodeTable,
                                         ParcelExemptionTable,
                                         AssessmentTable,
                                         ClassTable,
                                         SwisCodeTable,
                                         ParcelTable,
                                         AssessmentYear,
                                         SwisSBLKey, ExemptionsNotRecalculatedList,
                                         0, 0, False);

            {CHG01282004-1(2.08): Display exemptions not recalculated.  Can be nil if don't care.}

          If (ExemptionsNotRecalculatedList.Count > 0)
            then
              For I := 0 to (ExemptionsNotRecalculatedList.Count - 1) do
                begin
                  MasterExemptionsNotRecalculatedList.Add(SwisSBLKey);
                  MasterExemptionsNotRecalculatedList.Add(ExemptionsNotRecalculatedList[I]);
                end;

            {Get the new amounts.}

          TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                   ParcelExemptionTable,
                                   ExemptionCodeTable,
                                   ParcelTable.FieldByName('HomesteadCode').Text,
                                   'A',
                                   NewExemptionCodes,
                                   NewExemptionHomesteadCodes,
                                   NewResidentialTypes,
                                   NewCountyExemptionAmounts,
                                   NewTownExemptionAmounts,
                                   NewSchoolExemptionAmounts,
                                   NewVillageExemptionAmounts,
                                   NewBasicSTARAmount,
                                   NewEnhancedSTARAmount);

            {Now see if anything changed. Note that the # of exemptions
             and their positions in the list will be the same.}

          FirstExemptionPrintedForParcel := True;
          NumPrinted := 0;
          ExemptionAmountsChanged := False;

          For I := 0 to (OrigExemptionCodes.Count - 1) do
            If ((OrigCountyExemptionAmounts[I] <> NewCountyExemptionAmounts[I]) or
                (OrigTownExemptionAmounts[I] <> NewTownExemptionAmounts[I]) or
                (OrigSchoolExemptionAmounts[I] <> NewSchoolExemptionAmounts[I]) or
                (OrigVillageExemptionAmounts[I] <> NewVillageExemptionAmounts[I]))
              then
                begin
                  ExemptionAmountsChanged := True;
                  PrintOneLine(Sender, ParcelTable, OrigExemptionCodes[I],
                               StrToFloat(OrigCountyExemptionAmounts[I]),
                               StrToFloat(OrigTownExemptionAmounts[I]),
                               StrToFloat(OrigSchoolExemptionAmounts[I]),
                               StrToFloat(OrigVillageExemptionAmounts[I]), 0 , 0,
                               StrToFloat(NewCountyExemptionAmounts[I]),
                               StrToFloat(NewTownExemptionAmounts[I]),
                               StrToFloat(NewSchoolExemptionAmounts[I]),
                               StrToFloat(NewVillageExemptionAmounts[I]), 0 , 0,
                               FirstExemptionPrintedForParcel, NumPrinted);

                end;  {If ((OrigCountyExemptionAmounts[I] <> NewCountyExemptionAmounts[I]) or ...}

          If (OrigBasicSTARAmount <> NewBasicSTARAmount)
            then
              begin
                ExemptionAmountsChanged := True;
                PrintOneLine(Sender, ParcelTable, BasicSTARExemptionCode,
                             0, 0, 0, 0, OrigBasicSTARAmount, 0,
                             0, 0, 0, 0, NewBasicSTARAmount, 0,
                             FirstExemptionPrintedForParcel, NumPrinted);

              end;  {If (OrigBasicSTARAmount <> NewBasicSTARAmount)}

          If (OrigEnhancedSTARAmount <> NewEnhancedSTARAmount)
            then PrintOneLine(Sender, ParcelTable, EnhancedSTARExemptionCode,
                              0, 0, 0, 0, 0, OrigEnhancedSTARAmount,
                              0, 0, 0, 0, 0, NewEnhancedSTARAmount,
                              FirstExemptionPrintedForParcel, NumPrinted);

            {CHG06222003-2(2.07e): Audit exemptions that are recalculated.}

          If ExemptionAmountsChanged
            then
              begin
                InsertAuditEXChanges(SwisSBLKey, AssessmentYear, AuditEXChangeList,
                                     AuditEXChangeTable, 'B');

                ClearTList(NewAuditEXChangeList, SizeOf(AuditEXRecord));
                GetAuditEXList(SwisSBLKey, AssessmentYear, ParcelExemptionTable, NewAuditEXChangeList);
                InsertAuditEXChanges(SwisSBLKey, AssessmentYear, NewAuditEXChangeList,
                                     AuditEXChangeTable, 'A');

              end;  {If ExemptionAmountsChanged}

          If (NumPrinted > 0)
            then
              with Sender as TBaseReport do
                begin
                  Println('');

                  If (LinesLeft < 5)
                    then NewPage;

                end;  {with Sender as TBaseReport do}

            {Now add to the totals.}

          For I := 0 to (OrigExemptionCodes.Count - 1) do
            begin
              TotalOrigCountyExemptionAmount := TotalOrigCountyExemptionAmount +
                                                StrToFloat(OrigCountyExemptionAmounts[I]);
              TotalOrigTownExemptionAmount := TotalOrigTownExemptionAmount +
                                              StrToFloat(OrigTownExemptionAmounts[I]);
              TotalOrigSchoolExemptionAmount := TotalOrigSchoolExemptionAmount +
                                                StrToFloat(OrigSchoolExemptionAmounts[I]);
              TotalOrigVillageExemptionAmount := TotalOrigVillageExemptionAmount +
                                                 StrToFloat(OrigVillageExemptionAmounts[I]);

              TotalNewCountyExemptionAmount := TotalNewCountyExemptionAmount +
                                               StrToFloat(NewCountyExemptionAmounts[I]);
              TotalNewTownExemptionAmount := TotalNewTownExemptionAmount +
                                             StrToFloat(NewTownExemptionAmounts[I]);
              TotalNewSchoolExemptionAmount := TotalNewSchoolExemptionAmount +
                                               StrToFloat(NewSchoolExemptionAmounts[I]);
              TotalNewVillageExemptionAmount := TotalNewVillageExemptionAmount +
                                                StrToFloat(NewVillageExemptionAmounts[I]);

            end;  {For I := 0 to (OrigExemptionCodes.Count - 1) do}

            {FXX05191998-1: Show STAR amount changes, too.}

          TotalOrigBasicSTARAmount := TotalOrigBasicSTARAmount +
                                      OrigBasicSTARAmount;
          TotalOrigEnhancedSTARAmount := TotalOrigEnhancedSTARAmount +
                                         OrigEnhancedSTARAmount;

            {FXX05191998-1: Show STAR amount changes, too.}

          TotalNewBasicSTARAmount := TotalNewBasicSTARAmount +
                                      NewBasicSTARAmount;
          TotalNewEnhancedSTARAmount := TotalNewEnhancedSTARAmount +
                                         NewEnhancedSTARAmount;

        end;  {If not Done}

  until Done;

    {Print the totals.}

  with Sender as TBaseReport do
    begin
      If (LinesLeft < 9)
        then NewPage;

      Println('  Exemption Totals (Including those not changed):');
      Println('');

        {FXX05191998-2: Don't add up all the exemptions from different
                        types - it makes no sense!}

      ClearTabs;
      SetTab(0.2, pjLeft, 1.3, 0, BoxLineNone, 0);   {Col 1}
      SetTab(1.6, pjLeft, 1.3, 0, BoxLineBottom, 0);   {Col 2}
      SetTab(3.0, pjLeft, 1.3, 0, BoxLineBottom, 0);   {Col 3}
      SetTab(4.4, pjLeft, 1.3, 0, BoxLineBottom, 0);   {Col 4}

      Println(#9 + #9 + 'Original:' +
              #9 + 'New:' +
              #9 + 'Difference:');

      ClearTabs;
      SetTab(0.2, pjLeft, 1.3, 0, BoxLineNone, 0);   {Col 1}
      SetTab(1.6, pjRight, 1.3, 0, BoxLineNone, 0);   {Col 2}
      SetTab(3.0, pjRight, 1.3, 0, BoxLineNone, 0);   {Col 3}
      SetTab(4.4, pjRight, 1.3, 0, BoxLineNone, 0);   {Col 4}

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      If (rtdCounty in GlblRollTotalsToShow)
        then Println(#9 + 'County:' +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      TotalOrigCountyExemptionAmount) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      TotalNewCountyExemptionAmount) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      (TotalNewCountyExemptionAmount -
                                       TotalOrigCountyExemptionAmount)));

      If (rtdMunicipal in GlblRollTotalsToShow)
        then Println(#9 + GetShortMunicipalityTypeName(GlblMunicipalityType) + ':' +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      TotalOrigTownExemptionAmount) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      TotalNewTownExemptionAmount) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      (TotalNewTownExemptionAmount -
                                       TotalOrigTownExemptionAmount)));

      If (rtdSchool in GlblRollTotalsToShow)
        then Println(#9 + 'School:' +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      TotalOrigSchoolExemptionAmount) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      TotalNewSchoolExemptionAmount) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      (TotalNewSchoolExemptionAmount -
                                       TotalOrigSchoolExemptionAmount)));

      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Println(#9 + 'Village:' +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      TotalOrigVillageExemptionAmount) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      TotalNewVillageExemptionAmount) +
                     #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                      (TotalNewVillageExemptionAmount -
                                       TotalOrigVillageExemptionAmount)));

        {FXX05191998-1: Show STAR amount changes, too.}

      If (rtdSchool in GlblRollTotalsToShow)
        then
          begin
            Println(#9 + 'Enh STAR:' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     TotalOrigEnhancedSTARAmount) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     TotalNewEnhancedSTARAmount) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (TotalNewEnhancedSTARAmount -
                                      TotalOrigEnhancedSTARAmount)));

            Println(#9 + 'Basic STAR:' +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     TotalOrigBasicSTARAmount) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     TotalNewBasicSTARAmount) +
                    #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                     (TotalNewBasicSTARAmount -
                                      TotalOrigBasicSTARAmount)));

          end;  {If (rtdSchool in GlblRollTotalsToShow)}

    end;  {with Sender as TBaseReport do}

  ProgressDialog.Finish;

  OrigExemptionCodes.Free;
  OrigExemptionHomesteadCodes.Free;
  OrigResidentialTypes.Free;
  OrigCountyExemptionAmounts.Free;
  OrigTownExemptionAmounts.Free;
  OrigSchoolExemptionAmounts.Free;
  OrigVillageExemptionAmounts.Free;

  NewExemptionCodes.Free;
  NewExemptionHomesteadCodes.Free;
  NewResidentialTypes.Free;
  NewCountyExemptionAmounts.Free;
  NewTownExemptionAmounts.Free;
  NewSchoolExemptionAmounts.Free;
  NewVillageExemptionAmounts.Free;

  FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));
  FreeTList(NewAuditEXChangeList, SizeOf(AuditEXRecord));

  MessageDlg('The exemptions have now been recalculated.',
             mtInformation, [mbOK], 0);

    {CHG01282004-1(2.08): Display exemptions not recalculated.  Can be nil if don't care.}

  DisplayExemptionsNotRecalculatedForm(MasterExemptionsNotRecalculatedList);

  ExemptionsNotRecalculatedList.Free;
  MasterExemptionsNotRecalculatedList.Free;

    {FXX11191999-2: Automatically recalculate the roll totals if they want.}

  If (MessageDlg('The on-line roll totals are now incorrect.' + #13 +
                 'Do you want to recalculate the roll totals now?' + #13 +
                 'If you do not, you will need to do it manually later.',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then CreateRollTotals(ProcessingType, AssessmentYear, ProgressDialog,
                          Self, False, True);

end;  {ReportPrint}

{===================================================================}
Procedure TExemptionRecalculationForm.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.