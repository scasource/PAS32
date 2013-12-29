unit Rslsrcrt;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress, *)RPTXFilr, Types, Zipcopy,
  AbArcTyp, AbZBrows, AbZipper, Progress, SysUtils, AbBase, AbBrowse;

type
  TRecreateSalesExtractForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    PrintButton: TBitBtn;
    SalesTable: TwwTable;
    SwisCodeTable: TwwTable;
    SalesStatusTable: TwwTable;
    SalesStatusTableTaxRollYr: TStringField;
    SalesStatusTableMainCode: TStringField;
    SalesStatusTableDescription: TStringField;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    ComSiteTable: TTable;
    ComBldgTable: TTable;
    ComImprovementTable: TTable;
    ComLandTable: TTable;
    ComRentTable: TTable;
    ComIncExpTable: TTable;
    ResSiteTable: TTable;
    ResBldgTable: TTable;
    ResImprovementTable: TTable;
    ResLandTable: TTable;
    ResForestTable: TTable;
    ParcelTable: TTable;
    AssessmentTable: TTable;
    label99: TLabel;
    Label13: TLabel;
    TextFiler: TTextFiler;
    Label4: TLabel;
    SalesTableSwisSBLKey: TStringField;
    SalesTableSaleNumber: TSmallintField;
    SalesTableControlNo: TStringField;
    SalesTableSaleTypeCode: TStringField;
    SalesTableSaleTypeDesc: TStringField;
    SalesTableSalePrice: TCurrencyField;
    SalesTableSaleDate: TDateField;
    SalesTableVerifyCode: TStringField;
    SalesTableVerifyDesc: TStringField;
    SalesTableSaleConditionCode: TStringField;
    SalesTableDeedTypeCode: TStringField;
    SalesTableDeedTypeDesc: TStringField;
    SalesTableDeedBook: TStringField;
    SalesTableDeedPage: TStringField;
    SalesTableSaleStatusCode: TStringField;
    SalesTableSaleStatusDesc: TStringField;
    SalesTableAcreage: TFloatField;
    SalesTableFrontage: TFloatField;
    SalesTableDepth: TFloatField;
    SalesTableSaleAssessmentYear: TStringField;
    SalesTableNewOwnerName: TStringField;
    SalesTableOldOwnerName: TStringField;
    SalesTableArmsLength: TBooleanField;
    SalesTableEastCoord: TIntegerField;
    SalesTableNorthCoord: TIntegerField;
    SalesTableDeedDate: TDateField;
    SalesTableValidSale: TBooleanField;
    SalesTableEA5217Code: TStringField;
    SalesTableEA5217Descr: TStringField;
    SalesTableOwnerShipCode: TStringField;
    SalesTableOwnerShipDesc: TStringField;
    SalesTableRollSection: TStringField;
    SalesTableRollSubsection: TStringField;
    SalesTableNoParcels: TSmallintField;
    SalesTablePropClass: TStringField;
    SalesTableHomeSteadcode: TStringField;
    SalesTableSchoolDistcode: TStringField;
    SalesTablePersonalPropVal: TCurrencyField;
    SalesTableNumResSites: TSmallintField;
    SalesTableNumComSites: TSmallintField;
    SalesTableLandAssessedVal: TCurrencyField;
    SalesTableTotAssessedVal: TCurrencyField;
    SalesTableLegalAddrNo: TStringField;
    SalesTableLegalAddr: TStringField;
    SalesTableAccountNo: TStringField;
    SalesTableAssessorChangeFlag: TStringField;
    SalesTableActiveFlag: TStringField;
    SalesTableCheckDigit: TStringField;
    SalesTableIrregularShape: TBooleanField;
    SalesTableLastChangeDate: TDateField;
    SalesTableLastChangeByName: TStringField;
    SalesTableDateTransmitted: TDateField;
    SalesTablePriorStatusCode: TStringField;
    ZipCopyDlg: TZipCopyDlg;
    AbZipper: TAbZipper;
    ZipPanel: TPanel;
    Label16: TLabel;
    Gauge: TGauge;
    AssessmentYearCtlTable: TTable;
    RecreateDateEdit: TMaskEdit;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TextReportPrintHeader(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure TextReportPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure TextFilerBeforePrint(Sender: TObject);
    procedure AbZipperArchiveItemProgress(Sender: TObject;
      Item: TAbArchiveItem; Progress: Byte; var Abort: Boolean);
  private
    { Private declarations }
  public

    RPS035T1File,  {Sales extract equivalent to full file.}
    RPS035T2File : TextFile;  {Report information}

     {For printing status:}

    TransmitReport,
    ReportCancelled : Boolean;

    TotalSalesRecordCnt,
    IncompleteSalesCnt,
    TotalSalesXmittedCnt,
    ResidentialCnt,
    CommercialCnt : LongInt;
    PClassCntArray : Array [1..9] of LongInt;
    PClassCntArray_Condo : Array[1..10] of LongInt;  {This array has two entries for res prop class (200's) -
                                                      condo and other.}

    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    CurrentSwisCode : Str6;

    PrintFinalPageHeader : Boolean;  {if true, print final page hdr}
                                   {for report}

    RecreateDate : TDateTime;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Function RecordInRange : Boolean;
    {Does this record fall within the set of parameters that they selected?}

    Procedure WriteExtractRecords;

  end;

implementation
Uses Utilitys,  {General utilitys}
     RPS995UT,  {Full file extract utilities}
     PASUTILS, UTILEXSD,   {PAS specific utilitys}
     PASTypes,  {PAS specific types}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     PRCLLIST,
     Prog,
     Preview;



{$R *.DFM}
{========================================================}
Procedure TRecreateSalesExtractForm.InitializeForm;

var
  I : Integer;
  Quit, FirstTimeThrough, Done : Boolean;
  TempStr : Str35;

begin
  UnitName := 'RSLSRCRT.PAS';  {mmm}

  OpenTablesForForm(Self, NextYear);

  OpenTableForProcessingType(AssessmentYearCtlTable, AssessmentYearControlTableName,
                             ThisYear, Quit);


  TotalSalesRecordCnt := 1;  {set to one, since 'SalesTAble.First' is done}
  IncompleteSalesCnt  := 0;
  TotalSalesXmittedCnt := 0;
  ResidentialCnt := 0;
  CommercialCnt := 0;

  For I := 1 to 9 do
    PClassCntArray[I] := 0;

  For I := 1 to 10 do
    PClassCntArray_Condo[I] := 0;

end;  {InitializeForm}

{===================================================================}
Procedure TRecreateSalesExtractForm.FormKeyPress(    Sender: TObject;
                                              var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{======================================================================}
Procedure TRecreateSalesExtractForm.AbZipperArchiveItemProgress(    Sender: TObject;
                                                                 Item: TAbArchiveItem;
                                                                 Progress: Byte;
                                                             var Abort: Boolean);

begin
  Gauge.Progress := Progress;
  Application.ProcessMessages;
end;

{======================================================================}
Procedure TRecreateSalesExtractForm.PrintButtonClick(Sender: TObject);

var
  NewFileName, TextFileName, ReportFileName : String;
  TempFile : File;
  Continue, Quit : Boolean;
  Year, Month, Day : Word;
  YearStr, TempFileName : String;

begin
  ReportCancelled := False;
  Continue := False;

  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        RecreateDate := StrToDate(RecreateDateEdit.Text);

          {FXX10071999-1: To solve the problem of printing to the high speed,
                          we need to set the font to a TrueType even though it
                          doesn't matter in the actual printing.  The reason for this
                          is that without setting it, the default font is System for
                          the Generic printer which has a baseline descent of 0.5
                          which messes up printing to a text file.  We needed a font
                          with no descent.}

        TextFiler.SetFont('Courier New', 10);

        Continue := True;

        TransmitReport := True;

      end;  {If (ValidSelectionInformation and ...}

  If Continue
    then
      begin
        PrintFinalPageHeader := False;

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}
          {FXX07281999-3: Sales report can go to laser or dot matrix.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], True, Quit);

        If not Quit
          then
            begin
              ProgressDialog.Start(GetRecordCount(SalesTable), True, True);

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

                 {force xmit run to go to file so report will be }
                 {saved to disk with user-identifiable name in case}
                 {posting fails and we need to reconstruct posting results}
                 {CHG06171998-2: Add the RPS035T2 transmit.}

              If TransmitReport
                then
                  begin
                    PrintDialog.PrintToFile := True;
                    AssignFile(RPS035T1File, ExpandPASPath(GlblExportDir) + 'RPS035T1');
                    Rewrite(RPS035T1File);
                    AssignFile(RPS035T2File, ExpandPASPath(GlblExportDir) + 'RPS035T2');
                    Rewrite(RPS035T2File);

                       {Open the sales inventory tables.}
                       {Residential inventory tables.}

                    OpenTableForProcessingType(ResSiteTable, ResidentialSiteTableName,
                                               SalesInventory, Quit);
                    OpenTableForProcessingType(ResBldgTable, ResidentialBldgTableName,
                                               SalesInventory, Quit);
                    OpenTableForProcessingType(ResLandTable, ResidentialLandTableName,
                                               SalesInventory, Quit);
                    OpenTableForProcessingType(ResImprovementTable, ResidentialImprovementsTableName,
                                               SalesInventory, Quit);
                    OpenTableForProcessingType(ResForestTable, ResidentialForestTableName,
                                               SalesInventory, Quit);

                      {Commercial inventory tables.}

                    OpenTableForProcessingType(ComSiteTable, CommercialSiteTableName,
                                               SalesInventory, Quit);
                    OpenTableForProcessingType(ComBldgTable, CommercialBldgTableName,
                                               SalesInventory, Quit);
                    OpenTableForProcessingType(ComLandTable, CommercialLandTableName,
                                               SalesInventory, Quit);
                    OpenTableForProcessingType(ComImprovementTable, CommercialImprovementsTableName,
                                               SalesInventory, Quit);
                    OpenTableForProcessingType(ComRentTable, CommercialRentTableName,
                                               SalesInventory, Quit);
                    OpenTableForProcessingType(ComIncExpTable, CommercialIncomeExpenseTableName,
                                               SalesInventory, Quit);

                    ResSiteTable.IndexFieldNames := 'SwisSBLKey;SalesNumber;Site';
                    ResBldgTable.IndexFieldNames := 'SwisSBLKey;SalesNumber;Site';
                    ResLandTable.IndexFieldNames := 'SwisSBLKey;SalesNumber;Site;LandNumber';
                    ResImprovementTable.IndexFieldNames := 'SwisSBLKey;SalesNumber;Site;ImprovementNumber';
                    ResForestTable.IndexFieldNames := 'SwisSBLKey;SalesNumber;Site;ForestNumber';

                    ComSiteTable.IndexFieldNames := 'SwisSBLKey;SalesNumber;Site';
                    ComBldgTable.IndexFieldNames := 'SwisSBLKey;SalesNumber;Site;BuildingNumber;BuildingSection';
                    ComLandTable.IndexFieldNames := 'SwisSBLKey;SalesNumber;Site;LandNumber';
                    ComImprovementTable.IndexFieldNames := 'SwisSBLKey;SalesNumber;Site;ImprovementNumber';
                    ComRentTable.IndexFieldNames := 'SwisSBLKey;SalesNumber;Site;UseNumber';
                    ComIncExpTable.IndexFieldNames := 'SwisSBLKey;SalesNumber;Site';

                  end;  {If XmitCheckBox.Checked}

                {FXX11271998-1: Print the sales report to text file 1st in
                                order to print to dot matrix.}

              TextFileName := GetPrintFileName(Self.Caption, True);
              TextFiler.FileName := TextFileName;

                {FXX01211998-1: Need to set the LastPage property so that
                                long rolls aren't a problem.}

              TextFiler.LastPage := 30000;

              TextFiler.Execute;

                {FXX10111999-3: Tell people that printing is starting and
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

                      ReportFiler.Execute;
                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;
                    end;

                      {Delete the temporary report filer file.}

                    try
                      Chdir(GlblReportDir);
                      OldDeleteFile(NewFileName);
                    except
                    end;

                  end
                else ReportPrinter.Execute;

                {Now rename the text file to a recognizable
                 name, but to do so, erase the original first.
                 This is so that several people can run this job
                 at once.}

              ReportFileName := 'SALES.RPT';
              try
                Chdir(GlblReportDir);
                OldDeleteFile(ReportFileName);
              except
              end;

              try
                AssignFile(TempFile, TextFileName);
                Rename(TempFile, ReportFileName);

                  {FXX02171999-3: Need to do a CloseFile even though no
                                 Reset or Rewrite in order to get Novell
                                 to release.}

                Reset(TempFile);
                CloseFile(TempFile);
              finally
                {We don't care if it does not get deleted, so we won't put up an
                 error message.}

                ChDir(GlblProgramDir);
              end;

              ProgressDialog.Finish;

              If TransmitReport
                then
                  begin
                    CloseFile(RPS035T1File);
                    CloseFile(RPS035T2File);

                      {CHG05131999-3: See if they want to copy\zip the file.}

                    If (MessageDlg('Do you want to copy\zip the sales transmittal files to another drive or disk?',
                                    mtConfirmation, [mbYes, mbNo], 0) = idYes)
                      then
                        with ZipCopyDlg do
                          begin
                              {CHG08301999-1: Change zip\copy to allow selections from other dirs.}

                            InitialDrive := GlblDrive;
                            InitialDir := GlblExportDir;
                            SelectFile(ExpandPASPath(GlblExportDir) + 'RPS035T1');
                            SelectFile(ExpandPASPath(GlblExportDir) + 'RPS035T2');
                            SelectFile(ExpandPASPath(GlblReportDir) + 'SALES.RPT');

                            Execute;

                          end;  {with ZipCopyDlg do}

                      {CHG09021999-1: Save sales transmittals in a directory for history.}

                    DecodeDate(Date, Year, Month, Day);
                    YearStr := IntToStr(Year);
                    TempFileName := 'SL' + ShiftRightAddZeroes(Take(2, IntToStr(Month))) +
                                           ShiftRightAddZeroes(Take(2, IntToStr(Day))) +
                                           Copy(YearStr, 3, 2) + '.ZIP';

                    ZipPanel.Show;

                    with ABZipper do
                      begin
                        FileName := ExpandPASPath(GlblSavedSalesDir) + TempFileName;
                        AddFiles(ExpandPASPath(GlblExportDir) + 'RPS035T1', faReadOnly);
                        AddFiles(ExpandPASPath(GlblExportDir) + 'RPS035T2', faReadOnly);
                        AddFiles(ExpandPASPath(GlblReportDir) + 'SALES.RPT', faReadOnly);

                      end;  {with ABZipper do}

                    ZipPanel.Hide;

                    MessageDlg('PAS has created a copy of the sales files for archive purposes called ' +
                               ABZipper.FileName, mtInformation, [mbOk], 0);

                  end;  {If XmitCheckBox.Checked}

                {FXX10111999-3: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

            end;  {If not Quit}

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{========================================================================}
Procedure TRecreateSalesExtractForm.TextFilerBeforePrint(Sender: TObject);

begin
  SalesTable.First;
  CurrentSwisCode := Copy(SalesTable.FieldByName('SwisSBLKey').Text, 1, 6);

end;  {TextFilerBeforePrint}

{========================================================================}
Procedure TRecreateSalesExtractForm.TextReportPrintHeader(Sender: TObject);

var
  FirstLine, Done : Boolean;
  I, LabelPos : Integer;
  TempStr, TitleStr, TempStr1, TempStr2 : String;

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 12.9, 0, BoxLineNone, 0);
      Println('');

        {Print the date and page number.}

      TempStr1 := 'COUNTY OF ' + Trim(GlblCountyName);
      TempStr2 := 'DATE: ' + DateToStr(Date) + '  TIME: ' + TimeToStr(Now);
      Println(#9 + TempStr1 +
              ShiftRightAddBlanks(Take((130 - Length(TempStr1)), TempStr2)));

      If TransmitReport
        then TitleStr := 'TRANSMITTED SALES REPORT'
        else TitleStr := 'SALES REPORT';

      TempStr1 := Trim(UpcaseStr(GetMunicipalityName));
      TempStr2 := 'PAGE: ' + IntToStr(CurrentPage);
      Println(#9 + Take(43, UpcaseStr(TempStr1)) +
              Center(TitleStr, 43) +
              RightJustify(TempStr2, 43));

      If (TransmitReport and
          PrintFinalPageHeader)
        then TempStr := '5217 EXTRACT FILE/SALE CORRECTIONS TRANSMITTAL FORM'
        else TempStr := '';

      SwisCodeTable.FindKey([CurrentSwisCode]);
      TempStr1 := 'SWIS CODE: ' + CurrentSwisCode + '  (' +
                  Trim(SwisCodeTable.FieldByName('MunicipalityName').Text) + ')';
      Println(#9 + TempStr1 + Center(TempStr, 115 - Length(TempStr1)));


      If not PrintFinalPageHeader
        then
          begin
              {Print column headers.}

            CRLF;
            ClearTabs;
            SetTab(0.3, pjLeft, 1.0, 0, BOXLINENONE, 0);   {Ctl No & Deed Date}
            SetTab(1.4, pjLeft, 0.5, 0, BOXLINENONE, 0);   {DeedBook/Page}
            SetTab(2.0, pjLeft, 1.5, 0, BOXLINENONE, 0);   {SBL}
            SetTab(3.6, pjLeft, 0.3, 0, BOXLINENONE, 0);   {Sales No}
            SetTab(4.0, pjLeft, 1.8, 0, BOXLINENONE, 0);   {Current/Prior Owner}
            SetTab(5.9, pjLeft, 0.7, 0, BOXLINENONE, 0);   {Front OR acreage}
            SetTab(6.7, pjLeft, 0.7, 0, BOXLINENONE, 0);     {Depth}
            SetTab(7.5, pjCenter, 1.3, 0, BOXLINENONE, 0);   {SaleDate/Price}
            SetTab(8.9, pjLeft, 0.3, 0, BOXLINENONE, 0);   {Roll Section/Validity}
            SetTab(9.3, pjLeft, 0.8, 0, BOXLINENONE, 0);   {SchoolCde,S/S,prp cls}
            SetTab(10.2, pjLeft, 0.5, 0, BOXLINENONE, 0);   {Hstd Cde, # parcels}
            SetTab(10.8, pjCenter, 1.3, 0, BOXLINENONE, 0);   {Land & Tot AV }
            SetTab(12.2, pjCenter, 0.3, 0, BOXLINENONE, 0);   {AV Year}
            SetTab(12.6, pjCenter, 0.3, 0, BOXLINENONE, 0);   {Status code}

            Println(#9 + 'Ctl #' +
                    #9 + 'Deed ' +
                    #9 + 'Parcel ID' +
                    #9 + 'Sls' +
                    #9 + 'Curr Owner' +
                    #9 + 'Frntg' +
                    #9 + 'Depth' +
                    #9 + 'Sale Date' +
                    #9 + 'RS' +
                    #9 + 'School' +
                    #9 + 'Hstd' +
                    #9 + 'Land A/V' +
                    #9 + 'AV' +
                    #9 + 'ST');

              {FXX02081999-5: Add the legal address to the sales report.}

            Println(#9 + 'Deed Date' +
                    #9 + 'Bk/Pg' +
                    #9 + 'Legal Addr' +
                    #9 + '#' +
                    #9 + 'Prior Owner' +
                    #9 + 'Acres' +
                    #9 + '' +
                    #9 + 'Sale Price' +
                    #9 + 'Val' +
                    #9 + 'S/S Cls' +
                    #9 + '# Prc' +
                    #9 + 'Tot A/V' +
                    #9 + 'YR' +
                    #9 + 'CD');

                   {Set up the tabs for the info.}

           ClearTabs;
           SetTab(0.3, pjLeft, 1.0, 0, BOXLINENONE, 0);   {Ctl No & Deed Date}
           SetTab(1.4, pjRight, 0.5, 0, BOXLINENONE, 0);   {DeedBook/Page}
           SetTab(2.0, pjLeft, 1.5, 0, BOXLINENONE, 0);   {SBL}
           SetTab(3.6, pjCenter, 0.3, 0, BOXLINENONE, 0);   {Sales No}
           SetTab(4.0, pjLeft, 1.8, 0, BOXLINENONE, 0);   {Current/Prior Owner}
           SetTab(5.9, pjRight, 0.7, 0, BOXLINENONE, 0);   {Front OR acreage}
           SetTab(6.7, pjRight, 0.7, 0, BOXLINENONE, 0);     {Depth}
           SetTab(7.5, pjRight, 1.3, 0, BOXLINENONE, 0);   {SaleDate/Price}
           SetTab(8.9, pjCenter, 0.3, 0, BOXLINENONE, 0);   {Roll Section/Validity}
           SetTab(9.3, pjLeft, 0.8, 0, BOXLINENONE, 0);   {SchoolCde,S/S,prp cls}
           SetTab(10.2, pjCenter, 0.5, 0, BOXLINENONE, 0);   {Hstd Cde, # parcels}
           SetTab(10.8, pjRight, 1.3, 0, BOXLINENONE, 0);   {Land & Tot AV }
           SetTab(12.2, pjRight, 0.3, 0, BOXLINENONE, 0);   {AV Year}
           SetTab(12.6, pjRight, 0.3, 0, BOXLINENONE, 0);   {Status code}

           Println('');

         end;  {If not PrintFinalPageHeader}

    end;  {with Sender as TBaseReport do}

end;  {TextReportPrintHeader}

{==========================================================}
Function TRecreateSalesExtractForm.RecordInRange : Boolean;

{Does this record fall within the set of parameters that they selected?}

var
  FieldName : String;
  I : Integer;
  StatusCode : Str1;

begin
  Result := False;
  StatusCode := Take(1, SalesTable.FieldByName('SaleStatusCode').Text);

   {if formal xmittal, do that report}

  If (TransmitReport and
      (StatusCode[1] in ['R', 'T']) and
      (SalesTable.FieldByName('DateTransmitted').AsDateTime = RecreateDate))
    then Result := True

end;  {RecordInRange}

{=================================================================}
Procedure TRecreateSalesExtractForm.WriteExtractRecords;

var
  Index : Integer;
  SaleStatusCode : Str1;

begin
  with SalesTable do
    begin
       {use 1st digit of prop class code to index into }
       {prop class count array (1..9)  }
       {FXX11021999-2: Put the StrToInt of prop class in a try except so don't cause
                       a problem if blank.}

      try
        Index := StrToInt(Copy(FieldByName('PropClass').Text, 1, 1));
      except
        Index := 2;  {If error, default to res.}
      end;

      PClassCntArray[Index] := PClassCntArray[Index] + 1;

        {Now for the prop class array with a condo split, check the owner code.}

      If (((Index = 2) and
           (FieldByName('OwnershipCode').Text <> 'C')) or
          (Index > 2))
        then Index := Index + 1;

      PClassCntArray_Condo[Index] := PClassCntArray_Condo[Index] + 1;

        {count xmits after post}

      TotalSalesXmittedCnt := TotalSalesXmittedCnt + 1;

        {CHG06171998-2: Create extract RPS035T2 file.}

      Write(RPS035T2File, Copy(FieldByName('SwisSBLKey').Text, 1, 6));
      Write(RPS035T2File, Take(7, FieldByName('ControlNo').Text));
      Write(RPS035T2File, Take(6, MakeMMDDYY(FieldByName('DeedDate').AsDateTime)));
      Write(RPS035T2File, Take(5, FieldByName('DeedBook').Text));
      Write(RPS035T2File, Take(5, FieldByName('DeedPage').Text));
      Write(RPS035T2File, Take(25, ConvertSBLOnlyToDashDot(Copy(FieldByName('SwisSBLKey').Text, 7, 20))));
      Write(RPS035T2File, ShiftRightAddZeroes(Take(2, FieldByName('SaleNumber').Text)));
      Write(RPS035T2File, Take(10, FieldByName('NewOwnerName').Text));
      Write(RPS035T2File, Take(10, FieldByName('OldOwnerName').Text));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('Frontage').Text, 7, 2));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('Depth').Text, 7, 2));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('Acreage').Text, 7, 2));
      Write(RPS035T2File, Take(6, MakeMMDDYY(FieldByName('SaleDate').AsDateTime)));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('SalePrice').Text, 12, 0));
      Write(RPS035T2File, Take(1, FieldByName('RollSection').Text));
      Write(RPS035T2File, BoolToChar_0_1(FieldByName('ValidSale').AsBoolean));
      Write(RPS035T2File, Take(6, FieldByName('SchoolDistCode').Text));
      Write(RPS035T2File, Take(3, FieldByName('PropClass').Text));
      Write(RPS035T2File, Take(1, FieldByName('OwnershipCode').Text));
      Write(RPS035T2File, Take(1, FieldByName('HomesteadCode').Text));
      Write(RPS035T2File, ShiftRightAddZeroes(Take(3, FieldByName('NoParcels').Text)));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('LandAssessedVal').Text, 12, 0));
      Write(RPS035T2File, FormatRPSNumericString(FieldByName('TotAssessedVal').Text, 12, 0));
        {FXX12011998-3: If the sale status code is 'A', send as 'T'.}

      SaleStatusCode := FieldByName('SaleStatusCode').Text;

      If (SaleStatusCode = 'A')
        then SaleStatusCode := 'T';

      Write(RPS035T2File, Take(1, SaleStatusCode));  {Sale status code}
      Writeln(RPS035T2File, Copy(FieldByName('SaleAssessmentYear').Text, 3, 2));

        {Now extract to the T1 file if this is a sale with status
         'A', 'R', 'M'.}

      If (FieldByName('SaleStatusCode').Text[1] in ['A', 'R', 'M'])
        then ExtractInformationForOneSale(RPS035T1File,
                                          SalesTable,
                                          ParcelTable,
                                          AssessmentTable,
                                          AssessmentYearCtlTable,
                                          FieldByName('SwisSBLKey').Text,
                                          '', False,
                                          FieldByName('SaleNumber').AsInteger,
                                          True, False, True);

        {FXX10091998-9: Need to actually add up the number of sites.}

      ResidentialCnt := ResidentialCnt +
                        CalculateNumSites(ResSiteTable, '',
                                          FieldByName('SwisSBLKey').Text,
                                          FieldByName('SaleNumber').AsInteger,
                                          True);

      CommercialCnt := CommercialCnt +
                        CalculateNumSites(ComSiteTable, '',
                                          FieldByName('SwisSBLKey').Text,
                                          FieldByName('SaleNumber').AsInteger,
                                          True);

    end;  {with SalesTable do}

end;  {WriteExtractRecords}

{=================================================================}
Procedure TRecreateSalesExtractForm.TextReportPrint(Sender: TObject);

var
  TransmittalTotalsRec : PRPSExtractRec;
  PreviousSwisCode : Str6;
  FrontStr, DepthStr, AcresStr : Str7;
  FirstTimeThrough, Done : Boolean;
  TempStr : String;
  I : Integer;
  NumFound : LongInt;
  SaleStatusCode : Str1;

begin
  NumFound := 0;

  with Sender as TBaseReport do
    begin
      Done := False;
      FirstTimeThrough := True;
      PreviousSwisCode := Copy(SalesTable.FieldByName('SwisSBLKey').Text, 1, 6);

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SalesTable.Next;

        TotalSalesRecordCnt := TotalSalesRecordCnt + 1;

        If (SalesTable.FieldByName('SaleStatusCode').Text = 'I')
          then IncompleteSalesCnt := IncompleteSalesCnt + 1;
        CurrentSwisCode := Copy(SalesTable.FieldByName('SwisSBLKey').Text, 1, 6);

        If SalesTable.EOF
          then Done := True;

        ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumFound);
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SalesTable.FieldByName('SwisSBLKey').Text));
        Application.ProcessMessages;

        If ((not Done) and
            RecordInRange)
          then
            with SalesTable do
              begin
                NumFound := NumFound + 1;

                If (((not Done) and
                     (LinesLeft < 8)) or
                    (PreviousSwisCode <> CurrentSwisCode))
                  then NewPage;

                FrontStr := Take(7,' ');
                DepthStr := Take(7,' ');
                AcresStr := Take(7,' ');

                If ((FieldByName('Frontage').AsFloat > 0) or
                    (FieldByName('Depth').AsFloat > 0))
                  then
                    begin
                       {show frontage/acreage or depth or both}

                      FrontStr := FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat);
                      DepthStr := FormatFloat(DecimalDisplay, FieldByName('Depth').AsFloat);
                    end
                  else AcresStr := FormatFloat(DecimalDisplay, FieldByName('Acreage').AsFloat);

                    {FXX12011998-3: If the sale status code is 'A', send as 'T'.}

                  SaleStatusCode := FieldByName('SaleStatusCode').Text;

                  If (SaleStatusCode = 'A')
                    then SaleStatusCode := 'T';

                  If (DezeroOnLeft(FieldByName('ControlNo').Text) = '')
                    then Print(#9)
                    else Print(#9 + FieldByName('ControlNo').Text);

                  Println(#9 + FieldByName('DeedBook').Text +
                          #9 + ConvertSBLOnlyToDashDot(Copy(FieldByName('SwisSBLKey').Text, 7, 20)) +
                          #9 + FieldByName('SaleNumber').Text +
                          #9 + Take(18, FieldByName('NewOwnerName').Text) +
                          #9 + FrontStr +
                          #9 + DepthStr +
                          #9 + FieldByName('SaleDate').Text +
                          #9 + FieldByName('RollSection').Text +
                          #9 + FieldByName('SchoolDistcode').Text +
                          #9 + FieldByName('HomeSteadcode').Text +
                          #9 + FormatFloat(CurrencyNormalDisplay,
                                 (FieldByName('LandAssessedVal').AsFloat)) +
                          #9 + Copy(FieldByName('SaleAssessmentYear').Text,3,2) +
                          #9 + RTrim(FieldByName('SaleStatusCode').Text));

                    {FXX02081999-5: Add the legal address to the sales report.}

                  Println(#9 + FieldByName('DeedDate').Text +
                          #9 + FieldByName('DeedPage').Text +
                          #9 + Take(15, GetLegalAddressFromTable(SalesTable)) +
                          #9 +
                          #9 + Take(18, FieldByName('OldOwnerName').Text) +
                          #9 + AcresStr +
                          #9 +
                          #9 + FormatFloat(CurrencyNormalDisplay,
                                           FieldByName('SalePrice').AsFloat) +
                          #9 + BoolToChar_0_1(FieldByName('ValidSale').AsBoolean) +
                          #9 + SaleStatusCode +
                               '  ' + FieldByName('PropClass').Text +
                          #9 + FieldByName('NoParcels').Text +
                          #9 + FormatFloat(CurrencyNormalDisplay,
                               FieldByName('TotAssessedVal').AsFloat));

                  Println('');  {space one line between parcels}

                If TransmitReport
                  then WriteExtractRecords;

              end;  {with SalesTable do}

        PreviousSwisCode := Copy(SalesTable.FieldByName('SwisSBLKey').Text, 1, 6);

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or ReportCancelled);

        {Write out totals for transmittal report and files.}

      If TransmitReport
        then
          begin
            NewPage;
            CRLF;
            CRLF;
            ClearTabs;

            ClearTabs;
            SetTab(0.5, pjLeft, 2.5, 0, BOXLINENONE, 0);   {totals prose}
            SetTab(3.5, pjLeft, 0.5, 0, BOXLINENONE, 0);   {count column}
            SetTab(5.0, pjLeft, 3.0, 0, BOXLINENONE, 0);   {Prose column}

            Println(#9 + '* * * * TOTALS FOR ' +  Copy(CurrentSwisCode, 1, 4) + ' * * * *' +
                    #9 +
                    #9 + 'AUTHORIZED AGENT (ASSESSOR OR COUNTY DIRECTOR)');
            Println(#9 + #9 + #9  +'PLEASE COMPLETE THE FOLLOWING');
            Println(#9 + 'SALES TRANSMITTED:' +
                    #9 + IntToStr(TotalSalesXmittedCnt) +
                    #9 + '----------------------------------------------------');
            Println('');
            Println(#9 + 'RESIDENTIAL INV RECORDS: ' +
                    #9 + IntToStr(ResidentialCnt) +
                    #9 + '1. I CERTIFY THAT, TO THE BEST OF MY KNOWLEDGE, ALL ITEMS');
            Println(#9 + #9 +
                    #9 + '   OF INFORMATION ENTERED ON THE ENCLOSED EA-5217 (SALES');
            Println(#9 + 'COMMERCIAL INV RECORDS: ' +
                    #9 + IntToStr(CommercialCnt) +
                    #9 + '   TRANSMITTAL FILE) ARE TRUE AND CORRECT.');
            Println('');
            Println('');
            Println(#9 + #9 +
                    #9 + '   SIGNATURE:___________________________________________');
            Println('');
            Println(#9 + '100''s - AGRICULTURE ' +
                    #9 + IntToStr(PClassCntArray[1]) +
                    #9 + '   TITLE:___________________________________________________');
            Println('');
            Println(#9 + '200''s - RESIDENTIAL ' +
                    #9 + IntToStr(PClassCntArray[2]) +
                    #9 + '   DATE: ___________________________________________________');
            Println('');
            Println(#9 + '300''s - VACANT LAND ' +
                    #9 + IntToStr(PClassCntArray[3]));
            Println('');
            Println(#9 + '400''s - COMMERCIAL  ' +
                    #9 + IntToStr(PClassCntArray[4]) +
                    #9 + '2. FOR FURTHER INFORMATION CONTACT:' );
            Println('');
            Println(#9 + '500''s - AMUSEMENT   ' +
                    #9 + IntToStr(PClassCntArray[5]) );
            Println('');
            Println(#9 + '600''s - COMMUNITY SERVICE' +
                    #9 + IntToStr(PClassCntArray[6]) +
                    #9 + '   NAME: ___________________________________________________');
            Println('');
            Println(#9 + '700''s - INDUSTRIAL ' +
                    #9 + IntToStr(PClassCntArray[7]) +
                    #9 + '   TELEPHONE: (______) _____________________________________________');
            Println('');
            Println(#9 + '800''s - PUBLIC SERVICE' +
                    #9 + IntToStr(PClassCntArray[8]));
            Println('');
            Println(#9 + '900''s - WILD & FORESTED' +
                    #9 + IntToStr(PClassCntArray[9]) +
                    #9 + '3. IF THE CORRECTED SALES REPORT IS ENCLOSED,');
            Println(#9 + #9 +
                    #9 + '   PLEASE ENCLOSE AN EXPLANATION FOR ANY SALES');
            Println(#9 + #9 +
                    #9 + '   WHERE CONDITION CODE ''I'' IS INDICATED (OTHER');
            Println(#9 + #9 +
                    #9 + '   UNUSUAL FACTORS AFFECTING SALE PRICE).');

              {now print final page summary}

            PrintFinalPageHeader := True;  {print spcl final pg hdr}
            NewPage;
            CRLF;
            CRLF;
            ClearTabs;

            ClearTabs;
            SetTab(0.5, pjLeft, 2.5, 0, BOXLINENONE, 0);   {totals prose}
            SetTab(3.5, pjLeft, 0.5, 0, BOXLINENONE, 0);   {count column}
            SetTab(5.0, pjLeft, 3.0, 0, BOXLINENONE, 0);   {Prose column}

            Println(#9 + 'SALES RECORDS READ:' +
                    #9 + IntToStr(TotalSalesRecordCnt));
            Println('');
            Println(#9 + 'SALES TRANSMITTED:' +
                    #9 + IntToStr(TotalSalesXmittedCnt));
            Println('');
            Println(#9 + 'INCOMPLETE SALES ON MASTER:' +
                    #9 + IntToStr(IncompleteSalesCnt));
            Println('');

                 {FXX06231998-1: Write out the totals record to the T1 file.}

            New(TransmittalTotalsRec);
            InitializeRPSExtractString(TransmittalTotalsRec);
            RPSExtractStrCat(TransmittalTotalsRec, Take(4, CurrentSwisCode) + '99');
            RPSExtractStrCat(TransmittalTotalsRec,
                             ShiftRightAddZeroes(Take(6, IntToStr(TotalSalesXmittedCnt))));
            RPSExtractStrCat(TransmittalTotalsRec,
                             ShiftRightAddZeroes(Take(6, IntToStr(ResidentialCnt))));
            RPSExtractStrCat(TransmittalTotalsRec,
                             ShiftRightAddZeroes(Take(6, IntToStr(CommercialCnt))));
            For I := 1 to 10 do
              RPSExtractStrCat(TransmittalTotalsRec,
                               ShiftRightAddZeroes(Take(6, IntToStr(PClassCntArray_Condo[I]))));

            RPSExtractStrCat(TransmittalTotalsRec, Take(15, 'PAS'));
            RPSExtractStrCat(TransmittalTotalsRec, Take(255, ''));
            RPSExtractStrCat(TransmittalTotalsRec, Take(255, ''));
            RPSExtractStrCat(TransmittalTotalsRec, Take(213, ''));

            WriteOneRPSExtractRecToFile(RPS035T1File, TransmittalTotalsRec, '', False);
            Dispose(TransmittalTotalsRec);

          end;  {If TransmitReport}

    end;  {with Sender as TBaseReport do}

    {Don't repost.}

(*
    {if this is a transmittal, we must post A's & R's to T's in sales file}
    {posting is done after the print file is created so there is a record}
    {of what should have gotten posted if this posting loop fails}

  If TransmitReport
    then
      begin
         {get code description for 'T'}

        SalesStatusTable.FindKey(['T']);

        SalesTable.First;

        FirstTimeThrough := True;
        Done := False;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SalesTable.Next;

          If SalesTable.EOF
            then Done := True;

          If ((not Done) and
              RecordInRange)
            then
              with SalesTable do
                try
                  Edit;
                    {FXX04071999-2: Store transmitted date and code.}

                  FieldByName('DateTransmitted').AsDateTime := Date;
                  FieldByName('PriorStatusCode').Text := FieldByName('SaleStatusCode').Text;
                  FieldByName('SaleStatusCode').Text := 'T';
                  FieldByName('SaleStatusDesc').Text := SalesStatusTableDescription.Text;

                  Post;
                except
                  SystemSupport(011, SalesTable, 'Error Updating Sales Status to Xmitted.',
                              UnitName, GlblErrorDlgBox);
                  Done := True;
                end;

        until Done;

      end;  {If TransmitReport} *)

end;  {TextReportPrint}

{=============================================================}
Procedure TRecreateSalesExtractForm.ReportPrint(Sender: TObject);

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
Procedure TRecreateSalesExtractForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TRecreateSalesExtractForm.FormClose(    Sender: TObject;
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