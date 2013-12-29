unit Prgexdnl;

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
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler(*, Progress*);

type
  TPurgeDeniedExemptionsForm = class(TForm)
    ExemptionTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    TrialRunCheckBox: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    StartButton: TBitBtn;
    PrintDialog: TPrintDialog;
    ExemptionCodeTable: TTable;
    AssessmentTable: TTable;
    SwisCodeTable: TTable;
    ParcelTable: TTable;
    ParcelSDTable: TTable;
    ClassTable: TTable;
    SDCodeTable: TTable;
    ExemptionLookupTable: TTable;
    AuditEXChangeTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    TrialRun : Boolean;
    ReportCancelled : Boolean;
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Preview, PASTypes,
     UTILRTOT,  {Roll total update unit.}
     Prog, Types, UtilExSd;

{$R *.DFM}

{========================================================}
Procedure TPurgeDeniedExemptionsForm.InitializeForm;

begin
  UnitName := 'PRGEXDNL';  {mmm}

  OpenTablesForForm(Self, NextYear);

end;  {InitializeForm}

{===================================================================}
Procedure TPurgeDeniedExemptionsForm.StartButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  Quit : Boolean;

begin
    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  TrialRun := TrialRunCheckBox.Checked;

  If PrintDialog.Execute
    then
      begin
        StartButton.Enabled := False;

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

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

        StartButton.Enabled := True;

      end;  {If PrintDialog.Execute}

end;  {StartButtonClick}

{===================================================================}
Procedure TPurgeDeniedExemptionsForm.ReportPrintHeader(Sender: TObject);

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
      SetFont('Times New Roman', 10);
      Home;
      PrintCenter('Denied Exemptions Purged Report', (PageWidth / 2));
      CRLF;
      Bold := False;

      ClearTabs;
      SetTab(0.2, pjCenter, 2.5 ,0, BOXLINENONE, 0);   {Topic}
      If TrialRun
        then Println(#9 + 'Trial Run (No Exemptions Deleted)');

      SectionTop := 1.0;

        {Print column headers.}

      CRLF;
      Home;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('Times New Roman', 10);
      Bold := True;
      ClearTabs;

      SetTab(0.2, pjCenter, 2.5 ,0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(2.8, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {Ex code}
      SetTab(3.4, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {Desc}
      SetTab(5.0, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {Amount}
      Println(#9 + 'Parcel ID' +
              #9 + 'Ex Cd' +
              #9 + 'Description' +
              #9 + 'Amount');
      ClearTabs;
      SetTab(0.2, pjCenter, 2.5 ,0, BOXLINENONE, 0);   {Parcel ID}
      SetTab(2.8, pjCenter, 0.5, 0, BOXLINENone, 0);   {Ex code}
      SetTab(3.4, pjCenter, 1.5, 0, BOXLINENone, 0);   {Desc}
      SetTab(5.0, pjCenter, 1.2, 0, BOXLINENone, 0);   {Amount}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TPurgeDeniedExemptionsForm.ReportPrint(Sender: TObject);

var
  AssessmentRecordFound,
  ClassRecordFound,
  FirstTimeThrough, Done : Boolean;
  SwisSBLKey : Str26;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  HstdAssessedVal, NonhstdAssessedVal,
  HstdLandVal, NonhstdLandVal,
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  AuditEXChangeList, SDAmounts : TList;
  SBLRec : SBLRecord;
  HstdAcres, NonhstdAcres : Real;

begin
  FirstTimeThrough := True;
  Done := False;
  ReportCancelled := False;
  ProgressDialog.Start(GetRecordCount(ExemptionTable), False, False);
  SDAmounts := TList.Create;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ExemptionTable.Next;

    If ExemptionTable.EOF
      then Done := True;

    If not Done
      then
        begin
          SwisSBLKey := ExemptionTable.FieldByName('SwisSBLKey').Text;
          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));

          with ExemptionTable, Sender as TBaseReport do
            If (FieldByName('ExemptionDenied').AsBoolean and
                FieldByName('DenialPrinted').AsBoolean)
              then
                begin
                  If (LinesLeft < 8)
                    then NewPage;

                  ExemptionCodeTable.FindKey([FieldByName('ExemptionCode').Text]);

                  Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                          #9 + FieldByName('ExemptionCode').Text +
                          #9 + Take(15, ExemptionCodeTable.FieldByName('Description').Text) +
                          #9 + FormatFloat(CurrencyNormalDisplay,
                                           FieldByName('Amount').AsFloat));


                  If not TrialRun
                    then
                      begin
                        ExemptionCodes := TStringList.Create;
                        ExemptionHomesteadCodes := TStringList.Create;
                        ResidentialTypes := TStringList.Create;
                        CountyExemptionAmounts := TStringList.Create;
                        TownExemptionAmounts := TStringList.Create;
                        SchoolExemptionAmounts := TStringList.Create;
                        VillageExemptionAmounts := TStringList.Create;
                        SDAmounts := TList.Create;
                        AuditEXChangeList := TList.Create;

                        AssessmentTable.FindKey([GlblNextYear, SwisSBLKey]);

                        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                        with SBLRec do
                          ParcelTable.FindKey([GlblNextYear,
                                               SwisCode, Section,
                                               SubSection,
                                               Block, Lot,
                                               Sublot, Suffix]);

                        CalculateHstdAndNonhstdAmounts(GlblNextYear, SwisSBLKey,
                                                       AssessmentTable,
                                                       ClassTable,
                                                       ParcelTable,
                                                       HstdAssessedVal, NonhstdAssessedVal,
                                                       HstdLandVal, NonhstdLandVal,
                                                       HstdAcres, NonhstdAcres,
                                                       AssessmentRecordFound,
                                                       ClassRecordFound);

                           {Get the initial SD values so that we can adjust the roll totals
                            after any changes.}

                        ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

                        TotalSpecialDistrictsForParcel(GlblNextYear,
                                                       SwisSBLKey,
                                                       ParcelTable,
                                                       AssessmentTable,
                                                       ParcelSDTable,
                                                       SDCodeTable,
                                                       ExemptionTable,
                                                       ExemptionCodeTable,
                                                       SDAmounts);

                          {Figure out the inal exemption totals.}

                        TotalExemptionsForParcel(GlblNextYear, SwisSBLKey,
                                                 ExemptionTable,
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
                                                 BasicSTARAmount,
                                                 EnhancedSTARAmount);

                          {Remove the initial exemption amounts.}
                          {FXX02101999-4: Add land value to swis and school totals.}

                        AdjustRollTotalsForParcel(GlblNextYear,
                                                  ParcelTable.FieldByName('SwisCode').Text,
                                                  ParcelTable.FieldByName('SchoolCode').Text,
                                                  ParcelTable.FieldByName('HomesteadCode').Text,
                                                  ParcelTable.FieldByName('RollSection').Text,
                                                  HstdLandVal, NonhstdLandVal,
                                                  HstdAssessedVal, NonhstdAssessedVal,
                                                  ExemptionCodes,
                                                  ExemptionHomesteadCodes,
                                                  CountyExemptionAmounts,
                                                  TownExemptionAmounts,
                                                  SchoolExemptionAmounts,
                                                  VillageExemptionAmounts,
                                                  ParcelTable,
                                                  BasicSTARAmount,
                                                  EnhancedSTARAmount,
                                                  SDAmounts,
                                                  ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                                                  'D');  {Delete the totals.}

                          {This is the before for the exemptions.}

                        ClearTList(AuditEXChangeList, SizeOf(AuditEXRecord));
                        GetAuditEXList(SwisSBLKey, GlblNextYear, ExemptionLookupTable,
                                       AuditEXChangeList);
                        InsertAuditEXChanges(SwisSBLKey, GlblNextYear,
                                             AuditEXChangeList, AuditEXChangeTable, 'B');

                        try
                          Delete;
                        except
                          SystemSupport(001, ExemptionTable, 'Error deleting exemption.',
                                        UnitName, GlblErrorDlgBox);
                        end;

                          {Now since an exemption has been deleted, we must recalculate
                           all the exemptions for this parcel.}

                        RecalculateExemptionsForParcel(ExemptionCodeTable,
                                                       ExemptionLookupTable,
                                                       AssessmentTable,
                                                       ClassTable,
                                                       SwisCodeTable,
                                                       ParcelTable,
                                                       GlblNextYear, SwisSBLKey);

                           {Now get the new SD and exemption vals in order to add
                            these back in to the roll totals.}

                           {Get the new SD values so that we can adjust the roll totals
                            after any changes.}

                        ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

                        TotalSpecialDistrictsForParcel(GlblNextYear,
                                                       SwisSBLKey,
                                                       ParcelTable,
                                                       AssessmentTable,
                                                       ParcelSDTable,
                                                       SDCodeTable,
                                                       ExemptionTable,
                                                       ExemptionCodeTable,
                                                       SDAmounts);

                          {Figure out the inal exemption totals.}

                        TotalExemptionsForParcel(GlblNextYear, SwisSBLKey,
                                                 ExemptionTable,
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
                                                 BasicSTARAmount,
                                                 EnhancedSTARAmount);

                          {Remove the inal exemption amounts.}

                        AdjustRollTotalsForParcel(GlblNextYear,
                                                  ParcelTable.FieldByName('SwisCode').Text,
                                                  ParcelTable.FieldByName('SchoolCode').Text,
                                                  ParcelTable.FieldByName('HomesteadCode').Text,
                                                  ParcelTable.FieldByName('RollSection').Text,
                                                  HstdLandVal, NonhstdLandVal,
                                                  HstdAssessedVal, NonhstdAssessedVal,
                                                  ExemptionCodes,
                                                  ExemptionHomesteadCodes,
                                                  CountyExemptionAmounts,
                                                  TownExemptionAmounts,
                                                  SchoolExemptionAmounts,
                                                  VillageExemptionAmounts,
                                                  ParcelTable,
                                                  BasicSTARAmount,
                                                  EnhancedSTARAmount,
                                                  SDAmounts,
                                                  ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                                                  'A');  {Add the totals.}

                          {This is the after for the exemptions.}

                        ClearTList(AuditEXChangeList, SizeOf(AuditEXRecord));
                        GetAuditEXList(SwisSBLKey, GlblNextYear, ExemptionLookupTable,
                                       AuditEXChangeList);
                        InsertAuditEXChanges(SwisSBLKey, GlblNextYear,
                                             AuditEXChangeList, AuditEXChangeTable, 'A');

                      end;  {If not TrialRun}

                end;  {If (FieldByName('ExemptionDenied').AsBoolean and ...}

        end;  {If not Done}

  until (Done or ProgressDialog.Cancelled);

  ProgressDialog.Finish;
  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

  FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
  FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));

end;  {ReportPrint}

{===================================================================}
Procedure TPurgeDeniedExemptionsForm.FormClose(    Sender: TObject;
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