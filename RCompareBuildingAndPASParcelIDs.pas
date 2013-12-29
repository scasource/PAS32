unit RCompareBuildingAndPASParcelIDs;

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
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  TabNotBk, Types, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Progress,
  RPTXFilr, ComCtrls, Math;

type
  TParcelIDComparisonReportForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    Label11: TLabel;
    Label12: TLabel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    PrintButton: TBitBtn;
    PASParcelTable: TTable;
    OtherSystemParcelTable: TTable;
    SCASystemRadioGroup: TRadioGroup;
    ExtractToExcelCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ReportCancelled, ExtractToExcel : Boolean;
    OtherSystem : Integer;
    OtherSystemName, OtherSystemLongName : String;
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, UTILEXSD, GlblCnst, PASUtils,
     PRCLLIST,  {Parcel list}
     Prog, RptDialg,
     Preview, PASTypes;

const
  sySchoolTaxes = 0;
  syTownTaxes = 1;
  syCountyTaxes = 2;
  syCodeEnforcement = 3;
  syBuildingLevelI = 4;

{$R *.DFM}

{========================================================}
Procedure TParcelIDComparisonReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TParcelIDComparisonReportForm.InitializeForm;

begin
  UnitName := 'RCompareDataBetweenYears';

end;  {InitializeForm}

{===================================================================}
Procedure TParcelIDComparisonReportForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{==============================================================}
Procedure TParcelIDComparisonReportForm.PrintButtonClick(Sender: TObject);

var
  NewFileName, SpreadsheetFileName : String;
  Quit : Boolean;

begin
  SetPrintToScreenDefault(PrintDialog);
  ReportCancelled := False;
  ExtractToExcel := ExtractToExcelCheckBox.Checked;
  OtherSystem := SCASystemRadioGroup.ItemIndex;

  case OtherSystem of
    syCodeEnforcement :
      begin
        OtherSystemName := 'Bldg';
        OtherSystemLongName := 'Building';

        with OtherSystemParcelTable do
          begin
            DatabaseName := 'CodeEnforcement';
            TableName := 'ParcelMasterFile';
            IndexName := 'BYSBL_SWISCODE';
          end;

      end;  {syCodeEnforcement}

    syBuildingLevelI :
      begin
        OtherSystemName := 'Bldg';
        OtherSystemLongName := 'Building';

        with OtherSystemParcelTable do
          begin
            DatabaseName := 'SCABuild32';
            TableName := 'PropertyTable';
            IndexName := 'BYSWISSBLKEY';
          end;

      end;  {syBuildingLevelI}

  end;  {case OtherSystem of}

  OpenTableForProcessingType(PASParcelTable, ParcelTableName, NextYear, Quit);

  try
    OtherSystemParcelTable.Open;
  except
    Quit := True;
  end;

  If ((not Quit) and
      PrintDialog.Execute)
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);
        ProgressDialog.Start((PASParcelTable.RecordCount + OtherSystemParcelTable.RecordCount), True, True);

        ReportCancelled := False;
        GlblPreviewPrint := False;

        If ExtractToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

              Writeln(ExtractFile,
                      'Parcel ID' +
                      FormatExtractField('PAS'),
                      FormatExtractField(OtherSystemName));

            end;  {If PrintToExcel}

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

          {Make sure to close and delete the sort file.}

        ResetPrinter(ReportPrinter);
        ProgressDialog.Finish;

        If ExtractToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');

            end;  {If PrintToExcel}

      end;  {If PrintDialog.Execute}

end;  {StartButtonClick}

{==============================================================}
Procedure TParcelIDComparisonReportForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;

      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '    ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman',12);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Compare Parcel IDs between SCA Systems Report', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',12);

      ClearTabs;
      SetTab(0.4, pjCenter, 1.8, 5, BOXLINEALL, 25);   {Parcel ID}
      SetTab(2.2, pjCenter, 0.5, 5, BOXLINEALL, 25);   {PAS}
      SetTab(2.7, pjCenter, 0.5, 5, BOXLINEAll, 25);   {Other System}

      Println('');
      Println(#9 + 'Parcel ID' +
              #9 + 'PAS' +
              #9 + OtherSystemName);

      ClearTabs;
      SetTab(0.4, pjLeft, 1.8, 5, BOXLINEALL, 0);   {Parcel ID}
      SetTab(2.2, pjCenter, 0.5, 5, BOXLINEALL, 0);   {PAS}
      SetTab(2.7, pjCenter, 0.5, 5, BOXLINEAll, 0);   {Other System}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==============================================================}
Procedure TParcelIDComparisonReportForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, _Found : Boolean;
  SwisCode, SBL, SwisSBLKey : String;
  TotalParcelsInPASNotOther,
  TotalParcelsInOtherNotPAS : LongInt;
  SBLRec : SBLRecord;

begin
  TotalParcelsInPASNotOther := 0;
  TotalParcelsInOtherNotPAS := 0;

  FirstTimeThrough := True;
  Done := False;
  ReportCancelled := False;

  PASParcelTable.First;

  with Sender as TBaseReport do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else PASParcelTable.Next;

      If PASParcelTable.EOF
        then Done := True;

      SwisSBLKey := ExtractSSKey(PASParcelTable);
      SwisCode := Copy(SwisSBLKey, 1, 6);
      SBL := Copy(SwisSBLKey, 7, 20);

      ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
      Application.ProcessMessages;

      If not Done
        then
          begin
            _Found := False;

            case OtherSystem of
              syCodeEnforcement :
                _Found := FindKeyOld(OtherSystemParcelTable, ['SwisCode', 'SBL'], [SwisCode, SBL]);

              syBuildingLevelI :
                _Found := FindKeyOld(OtherSystemParcelTable, ['SwisSBLKey'], [SwisSBLKey]);

            end;  {case OtherSystem of}

            If not _Found
              then
                begin
                  TotalParcelsInPASNotOther := TotalParcelsInPASNotOther + 1;
                  Println(#9 + ConvertSBLOnlyToDashDot(SBL) +
                          #9 + 'X');

                  If (LinesLeft < 5)
                    then NewPage;

                  If ExtractToExcel
                    then Writeln(ExtractFile,
                                 ConvertSwisSBLToDashDot(SwisSBLKey),
                                 FormatExtractField('X'));

                end;  {If not _Found}

          end;  {If not Done}

      ReportCancelled := ProgressDialog.Cancelled;

    until (Done or ReportCancelled);

  If not ReportCancelled
    then
      begin
        OtherSystemParcelTable.First;
        FirstTimeThrough := True;
        Done := False;

        with Sender as TBaseReport do
          repeat
            If FirstTimeThrough
              then FirstTimeThrough := False
              else OtherSystemParcelTable.Next;

            If OtherSystemParcelTable.EOF
              then Done := True;

            case OtherSystem of
              syCodeEnforcement :
                with OtherSystemParcelTable do
                  begin
                    SwisCode := FieldByName('SwisCode').Text;
                    SBL := FieldByName('SBL').Text;
                  end;

              syBuildingLevelI :
                with OtherSystemParcelTable do
                  begin
                    SwisCode := Copy(FieldByName('SwisSBLKey').Text, 1, 6);
                    SBL := Copy(FieldByName('SwisSBLKey').Text, 7, 30);
                  end;

            end;  {case OtherSystem of}

            SwisSBLKey := SwisCode + SBL;
            ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
            Application.ProcessMessages;

            If not Done
              then
                begin
                  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                  with SBLRec do
                    _Found := FindKeyOld(PASParcelTable,
                                         ['TaxRollYr', 'SwisCode', 'Section',
                                          'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                                         [GlblNextYear, SwisCode, Section,
                                          SubSection, Block, Lot, Sublot, Suffix]);

                  If not _Found
                    then
                      begin
                        TotalParcelsInOtherNotPAS := TotalParcelsInOtherNotPAS + 1;
                        Println(#9 + ConvertSBLOnlyToDashDot(SBL) +
                                #9 +
                                #9 + 'X');

                        If (LinesLeft < 5)
                          then NewPage;

                        If ExtractToExcel
                          then Writeln(ExtractFile,
                                       ConvertSwisSBLToDashDot(SwisSBLKey),
                                       FormatExtractField(''),
                                       FormatExtractField('X'));

                      end;  {If not _Found}

                end;  {If not Done}

            ReportCancelled := ProgressDialog.Cancelled;

          until (Done or ReportCancelled);

      end;  {If not ReportCancelled}

  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.4, pjLeft, 4.0, 0, BOXLINENone, 0);   {Parcel ID}
      Println('');
      Bold := True;
      Println(#9 + 'Total parcels in PAS, not ' + OtherSystemLongName + ' = ' + IntToStr(TotalParcelsInPASNotOther));
      Println(#9 + 'Total parcels in ' + OtherSystemLongName + ', not PAS = ' + IntToStr(TotalParcelsInOtherNotPAS));
    end;

end;  {ReportPrint}

{===================================================================}
Procedure TParcelIDComparisonReportForm.FormClose(    Sender: TObject;
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