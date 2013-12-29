unit Addstar;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPFiler,
  RPDefine, RPBase, RPCanvas, RPrinter(*, Progress*);

type
  TAutoAddStarForm = class(TForm)
    ParcelTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ParcelExemptionTable: TTable;
    ExemptionCodeTable: TTable;
    StartButton: TBitBtn;
    Label7: TLabel;
    PrintDialog: TPrintDialog;
    TrialRunCheckBox: TCheckBox;
    SwisCodeTable: TTable;
    AssessmentTable: TTable;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    AssessmentYearRadioGroup: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure ReportHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ProcessingType : Integer;
    TrialRun : Boolean;
    Procedure InitializeForm;  {Open the tables and setup.}

    Function PropertyGetsEnhancedSTAR(    ExemptionCodes : TStringList;
                                          BasicSTARAmount,
                                          EnhancedSTARAmount : Comp;
                                      var PropertyHasMoreThanOneAged : Boolean) : Boolean;
    {This property automatically gets an enhanced STAR if there is an aged exemption
     already on the property.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, UTILEXSD,  Preview, Types,
     Prog;

{$R *.DFM}

{========================================================}
Procedure TAutoAddStarForm.InitializeForm;

begin
  UnitName := 'ADDSTAR';  {mmm}

    {CHG12191997-1: Need to be able to add STAR to either year.}

(*    {Only add STAR exemptions to NextYear.}

  ProcessingType := NextYear; *)

end;  {InitializeForm}

{================================================================}
Procedure TAutoAddStarForm.StartButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  Continue : Boolean;

begin
    {FXX12301997-3: Need to text if item index is -1 not 0.}

  If (AssessmentYearRadioGroup.ItemIndex = -1)
    then
      begin
        MessageDlg('Please choose an assessment year to apply the STAR exemptions to.',
                   mtError, [mbOK], 0);
        Continue := False;
      end;

  If Continue
    then
      If TrialRun
        then Continue := True  {Don't confirm for trial run.}
        else Continue := (MessageDlg('Are you sure you want to add the enhanced STAR exemptions?',
                          mtConfirmation, [mbYes, mbNo], 0) = idYes);

  If (Continue and
      PrintDialog.Execute)
    then
      begin
          {CHG12191997-1: Need to be able to add STAR to either year.}

        If (AssessmentYearRadioGroup.ItemIndex = 0)
          then ProcessingType := ThisYear
          else ProcessingType := NextYear;

        OpenTablesForForm(Self, ProcessingType);

        TrialRun := TrialRunCheckBox.Checked;

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

end;  {StartButtonClick}

{===================================================================}
Function TAutoAddStarForm.PropertyGetsEnhancedSTAR(    ExemptionCodes : TStringList;
                                                       BasicSTARAmount,
                                                       EnhancedSTARAmount : Comp;
                                                   var PropertyHasMoreThanOneAged : Boolean) : Boolean;

{This property automatically gets an enhanced STAR if there is an aged exemption
 already on the property.}

var
  I, NumAgeds : Integer;

begin
  Result := False;
  PropertyHasMoreThanOneAged := False;
  NumAgeds := 0;

  For I := 0 to (ExemptionCodes.Count - 1) do
    If (Take(4, ExemptionCodes[I]) = '4180')
      then NumAgeds := NumAgeds + 1;

  If (NumAgeds > 0)
    then
      begin
        Result := True;

        If (NumAgeds > 1)
          then PropertyHasMoreThanOneAged := True;

      end;  {If (NumAgeds > 0)}

     {FXX12041997-3: Make sure that we don't add STAR to a
                     prop already with STAR.}

  If ((Roundoff(BasicSTARAmount, 0) > 0) or
      (Roundoff(EnhancedSTARAmount, 0) > 0))
    then Result := False;

end;  {PropertyGetsEnhancedSTAR}

{===================================================================}
Procedure TAutoAddStarForm.ReportHeader(Sender: TObject);

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
      PrintCenter('Automatic Addition of Enhanced STAR Exemptions', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;

      If TrialRun
        then Println('TRIAL RUN.');

       {CHG12191997-1: Need to be able to add STAR to either year.}

      If (ProcessingType = ThisYear)
        then Println('Assessment Year = This Year (' + GlblThisYear + ')')
        else Println('Assessment Year = Next Year (' + GlblNextYear + ')');

      Println('''*'' -> Parcel has more than one aged exemption.');
      Println('');

      Underline := False;
      ClearTabs;
      SetTab(0.2, pjCenter, 0.1, 0, BOXLINENone, 0);   {More than one aged}
      SetTab(0.4, pjCenter, 1.3, 0, BOXLINEBOTTOM, 0);   {Parcel ID}
      SetTab(1.8, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {Name}
      SetTab(3.1, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {Amount}

      Println(#9 + #9 + 'Parcel ID' +
              #9 + 'Name' +
              #9 + 'STAR Amount');

      ClearTabs;
      SetTab(0.2, pjLeft, 0.1, 0, BoxLineNone, 0);   {More than one aged}
      SetTab(0.4, pjLeft, 1.3, 0, BoxLineNone, 0);   {Parcel ID}
      SetTab(1.8, pjLeft, 1.2, 0, BoxLineNone, 0);   {Name}
      SetTab(3.1, pjRight, 1.0, 0, BoxLineNone, 0);   {Amount}

    end;  {with Sender as TBaseReport do}

end;  {ReportHeader}

{===================================================================}
Procedure TAutoAddStarForm.ReportPrint(Sender: TObject);

var
  PropertyHasMoreThanOneAged,
  FirstTimeThrough, Done : Boolean;
  AssessmentYear : Str4;
  SwisSBLKey : Str26;

  I : Integer;
  NumSTARAdded : LongInt;
  FullSTARAmount, AssessedValue,
  BasicSTARAmount, EnhancedSTARAmount,
  STARAmount, TotalSTARAmount : Comp;

  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;

begin
  FirstTimeThrough := True;
  Done := False;
  AssessmentYear := GetTaxRollYearForProcessingType(ProcessingType);

  ProgressDialog.Start(ParcelTable.RecordCount, True, True);

  NumSTARAdded := 0;
  TotalSTARAmount := 0;

  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If ParcelTable.EOF
      then Done := True;

    If not Done
      then
        begin
          SwisSBLKey := ExtractSSKey(ParcelTable);

          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));

          ExemptionCodes.Clear;
          ExemptionHomesteadCodes.Clear;
          CountyExemptionAmounts.Clear;
          TownExemptionAmounts.Clear;
          SchoolExemptionAmounts.Clear;
          VillageExemptionAmounts.Clear;

            {Get the original amounts.}
            {FXX02091998-1: Pass the residential type of each exemption.}

          TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                                   ParcelExemptionTable,
                                   ExemptionCodeTable,
                                   ParcelTable.FieldByName('HomesteadCode').Text,
                                   'A',
                                   ExemptionCodes,
                                   ExemptionHomesteadCodes,
                                   ResidentialTypes,
                                   CountyExemptionAmounts,
                                   TownExemptionAmounts,
                                   SchoolExemptionAmounts,
                                   VillageExemptionAmounts,
                                   BasicSTARAmount, EnhancedSTARAmount);

            {FXX12041997-3: Make sure that we don't add STAR to a
                            prop already with STAR.}

          If PropertyGetsEnhancedSTAR(ExemptionCodes, BasicSTARAmount,
                                      EnhancedSTARAmount, PropertyHasMoreThanOneAged)
            then
              begin
                AssessmentTable.FindKey([GlblNextYear, SwisSBLKey]);
                AssessedValue := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

(*                STARAmount := CalculateSTARAmount(GlblNextYear, '41834',
                                                  ParcelTable.FieldByName('SwisCode').Text,
                                                  SwisCodeTable,
                                                  ParcelTable,
                                                  AssessedValue,
                                                  SchoolExemptionAmounts,
                                                  FullSTARAmount); *)

                  {Add the STAR exemption.}

                If not TrialRun
                  then
                    with ParcelExemptionTable do
                      try
                        Insert;

                        FieldByName('ExemptionCode').Text := '41834';
                        FieldByName('Amount').AsFloat := STARAmount;
                        FieldByName('SchoolAmount').AsFloat := STARAmount;
                        FieldByName('InitialDate').AsDateTime := Date;
                        FieldByName('TaxRollYr').Text := GlblNextYear;
                        FieldByName('SwisSBLKey').Text := SwisSBLKey;

                          {If this is a split parcel make sure that the
                           exemption goes on the homestead part.}

                        If (ParcelTable.FieldByName('HomesteadCode').Text = 'S')
                          then FieldByName('HomesteadCode').Text := 'H';

                        Post;
                      except
                        SystemSupport(050, ParcelExemptionTable, 'Error inserting STAR exemption.',
                                      UnitName, GlblErrorDlgBox);
                      end;

                   {Print it out.}

                with Sender as TBaseReport do
                  begin
                    If PropertyHasMoreThanOneAged
                      then Print(#9 + '*')
                      else Print(#9);

                    Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                            #9 + Take(20, ParcelTable.FieldByName('Name1').Text) +
                            #9 + FormatFloat(CurrencyDisplayNoDollarSign, STARAmount));

                    If (LinesLeft < 5)
                      then NewPage;

                  end;  {with Sender as TBaseReport do}

                   {Update the totals.}

                NumSTARAdded := NumSTARAdded + 1;
                TotalSTARAmount := TotalSTARAmount + STARAmount;

                If TrialRun
                  then ProgressDialog.UserLabelCaption := 'Num to be added = ' + IntToStr(NumSTARAdded)
                  else ProgressDialog.UserLabelCaption := 'Num added = ' + IntToStr(NumSTARAdded);

              end;  {If PropertyGetsEnhancedSTAR(ExemptionCodes)}

        end;  {If not Done}

  until Done;

  with Sender as TBaseReport do
    begin
      Println('');

      If TrialRun
        then Println('Total number of STAR exemptions to be added = ' + IntToStr(NumSTARAdded))
        else Println('Total number of STAR exemptions = ' + IntToStr(NumSTARAdded));

      Println('Total STAR amount = ' + FormatFloat(CurrencyNormalDisplay, TotalSTARAmount));

    end;  {with Sender as TBaseReport do}

  ProgressDialog.Finish;

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

  If TrialRun
    then MessageDlg('A report will now be printed showing what parcels' + #13 +
                    'will receive the enchanced STAR exemption.' + #13 +
                    'Please review and click Start when correct.', mtInformation, [mbOK], 0)
    else MessageDlg('The enhanced STAR exemptions have now been added.',
                    mtInformation, [mbOK], 0);

  If not TrialRun
    then MessageDlg('The on-line roll totals are now incorrect.' + #13 +
                    'Please recalculate the on-line roll totals by' + #13 +
                    'selecting ''Calculate Roll Totals'' from the system menu.',
                    mtInformation, [mbOK], 0);

end;  {ReportPrint}

{===================================================================}
Procedure TAutoAddStarForm.FormClose(    Sender: TObject;
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