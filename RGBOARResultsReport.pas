unit RGBOARResultsReport;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls;

type
  ResultsRecord = record
    BoardMember : String;
    GrievanceYear : String;
    Active : Boolean;
    Against,
    Absent,
    Concur,
    Abstain : LongInt;

  end;  {ResultsRecord}

  ResultsPointer = ^ResultsRecord;

  TGrievanceResultsByBoardMemberReport = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    BoardMemberTable: TwwTable;
    PrintButton: TBitBtn;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    GroupBox1: TGroupBox;
    ShowInactiveMembersCheckBox: TCheckBox;
    GrievanceResultsTable: TTable;
    BoardMemberCodeTable: TTable;
    ShowDetailsCheckBox: TCheckBox;
    ChooseGrievanceYearGroupBox: TRadioGroup;
    GrievanceYearEdit: TEdit;
    cbExtractToExcel: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ChooseGrievanceYearGroupBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    ReportCancelled : Boolean;

    { Public declarations }
    UnitName : String;

    ShowDetails,
    IncludeInactiveMembers, bExtractToExcel : Boolean;

    ReportSection : Char;
    GrievanceYear, sSpreadsheetFileName : String;
    flExtract : TextFile;

    GrievanceYearsToPrint : Integer;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}

    Procedure PrintDetails(Sender : TObject;
                           BoardMember : String;
                           GrievanceYear : String;
                           GrievanceYearsToPrint : Integer;
                           BoardVoteTotalsList : TList);

    Procedure GetTotalsForBoardMember(BoardMember : String;
                                      BoardVoteTotalsList : TList;
                                      GrievanceYear : String;
                                      GrievanceYearsToPrint : Integer);

    Procedure PrintOneTotalsLine(Sender : TObject;
                                 ResultsRec : ResultsRecord;
                                 GrandTotals : Boolean;
                                 PrintMemberName : Boolean);

  end;

implementation
Uses Utilitys,  {General utilitys}
     PASUTILS, {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     Prog,
     RptDialg,
     PRCLLIST,
     GrievanceUtilitys,
     DataAccessUnit,
     Preview;

{$R *.DFM}

const
  gyAll = 0;
  gySpecific = 1;

{========================================================}
Procedure TGrievanceResultsByBoardMemberReport.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TGrievanceResultsByBoardMemberReport.InitializeForm;

begin
  UnitName := 'RGBOARResultsReport';  {mmm}
  GrievanceYearEdit.Text := DetermineGrievanceYear;

  OpenTablesForForm(Self, NextYear);

end;  {InitializeForm}

{===================================================================}
Procedure TGrievanceResultsByBoardMemberReport.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{====================================================================}
Procedure TGrievanceResultsByBoardMemberReport.ChooseGrievanceYearGroupBoxClick(Sender: TObject);

begin
  case ChooseGrievanceYearGroupBox.ItemIndex of
    gyAll : GrievanceYearEdit.Visible := False;
    gySpecific : GrievanceYearEdit.Visible := True;

  end;  {case ChooseGrievanceYearGroupBox.ItemIndex of}

end;  {ChooseGrievanceYearGroupBoxClick}

{====================================================================}
Procedure TGrievanceResultsByBoardMemberReport.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'BAR Member Decisions Report.bmd', 'BOAR Member Decisions Report');

end;  {SaveButtonClick}

{====================================================================}
Procedure TGrievanceResultsByBoardMemberReport.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'BAR Member Decisions Report.bmd', 'BOAR Member Decisions Report');

end;  {LoadButtonClick}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TGrievanceResultsByBoardMemberReport.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  Quit : Boolean;

begin
  ReportCancelled := False;
  Quit := False;
  ReportSection := 'M';

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);
  bExtractToExcel := cbExtractToExcel.Checked;

  If PrintDialog.Execute
    then
      begin
          {CHG07112010-1(2.26.1.6)[I7732]: Add Excel extract.}

        If bExtractToExcel
        then
        begin
          sSpreadsheetFileName := GetPrintFileName('BARResults', True);
          AssignFile(flExtract, sSpreadsheetFileName);
          Rewrite(flExtract);

          WritelnCommaDelimitedLine(flExtract,
                                    ['Parcel ID',
                                     'Year',
                                     'Grievance #',
                                     'Grievance Description',
                                     'Result',
                                     'Member',
                                     'Concur',
                                     'Against',
                                     'Absent',
                                     'Abstain']);

        end;  {If bExtractToExcel}

        ShowDetails := ShowDetailsCheckBox.Checked;
        IncludeInactiveMembers := ShowInactiveMembersCheckBox.Checked;

        GrievanceYearsToPrint := ChooseGrievanceYearGroupBox.ItemIndex;

        If (GrievanceYearsToPrint = gySpecific)
          then
            begin
              GrievanceYear := GrievanceYearEdit.Text;
              SetRangeOld(BoardMemberTable,
                          ['TaxRollYr', 'BoardMember'],
                          [GrievanceYear, Take(10, '')],
                          [GrievanceYear, ConstStr('Z', 10)]);
            end
          else GrievanceYear := '';

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                              False, Quit);

        If not Quit
          then
            begin
              ProgressDialog.UserLabelCaption := '';

              ProgressDialog.Start(GetRecordCount(GrievanceResultsTable), True, True);

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

                          ShowReportDialog('Results by Board Member Report.RPT', NewFileName, True);

                        end
                      else ReportPrinter.Execute;

                  end;  {If not Quit}

                {Clear the selections.}

              ProgressDialog.Finish;

                {FXX09071999-6: Tell people that printing is starting and
                                done.}

              DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

        If bExtractToExcel
        then
        begin
          CloseFile(flExtract);
          SendTextFileToExcelSpreadsheet(sSpreadsheetFileName, True,
                                         False, '');

        end;  {If bExtractToExcel}

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{====================================================================}
Procedure SetRangeForBoardTable(BoardMemberTable : TTable;
                                BoardMember : String;
                                GrievanceYear : String;
                                GrievanceYearsToPrint : Integer);

var
  StartGrievanceYear, EndGrievanceYear : String;

begin
  case GrievanceYearsToPrint of
    gyAll :
      begin
        StartGrievanceYear := '    ';
        EndGrievanceYear := '9999';
      end;

    gySpecific :
      begin
        StartGrievanceYear := GrievanceYear;
        EndGrievanceYear := GrievanceYear;
      end;

  end;  {case GrievanceYearsToPrint of}

  SetRangeOld(BoardMemberTable, ['BoardMember', 'TaxRollYr'],
              [BoardMember, StartGrievanceYear],
              [BoardMember, EndGrievanceYear]);

end;  {SetRangeForBoardTable}

{====================================================================}
Function FindRecordInResultsList(_BoardMember : String;
                                 _GrievanceYear : String;
                                 BoardVoteTotalsList : TList) : Integer;

var
  I, Index : Integer;

begin
  Index := -1;

  For I := 0 to (BoardVoteTotalsList.Count - 1) do
    with ResultsPointer(BoardVoteTotalsList[I])^ do
      If ((BoardMember = _BoardMember) and
          (GrievanceYear = _GrievanceYear))
        then Index := I;

  Result := Index;

end;  {FindRecordInResultsList}

{====================================================================}
Procedure TGrievanceResultsByBoardMemberReport.GetTotalsForBoardMember(BoardMember : String;
                                                                       BoardVoteTotalsList : TList;
                                                                       GrievanceYear : String;
                                                                       GrievanceYearsToPrint : Integer);

var
  Done, FirstTimeThrough : Boolean;
  Index : Integer;
  ResultsPtr : ResultsPointer;

begin
  SetRangeForBoardTable(BoardMemberTable, BoardMember, GrievanceYear, GrievanceYearsToPrint);

  Done := False;
  FirstTimeThrough := True;
  BoardMemberTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else BoardMemberTable.Next;

    If BoardMemberTable.EOF
      then Done := True;

    If not Done
      then
        begin
          Index := FindRecordInResultsList(BoardMemberTable.FieldByName('BoardMember').Text,
                                           BoardMemberTable.FieldByName('TaxRollYr').Text,
                                           BoardVoteTotalsList);

          If (Index = -1)
            then
              begin
                New(ResultsPtr);

                with ResultsPtr^, BoardMemberTable do
                  begin
                    BoardMember := FieldByName('BoardMember').Text;
                    GrievanceYear := FieldByName('TaxRollYr').Text;
                    Active := BoardMemberCodeTable.FieldByName('Active').AsBoolean;
                    Against := 0;
                    Absent := 0;
                    Concur := 0;
                    Abstain := 0;

                  end;  {with ResultsPtr^, BoardMemberTable do}

                BoardVoteTotalsList.Add(ResultsPtr);

                Index := FindRecordInResultsList(BoardMemberTable.FieldByName('BoardMember').Text,
                                                 BoardMemberTable.FieldByName('TaxRollYr').Text,
                                                 BoardVoteTotalsList);

              end;  {If (Index = -1)}

          with BoardMemberTable, ResultsPointer(BoardVoteTotalsList[Index])^ do
            begin
              If FieldByName('Against').AsBoolean
                then Against := Against + 1
                else
                  If FieldByName('Absent').AsBoolean
                    then Absent := Absent + 1
                    else
                      If FieldByName('Concur').AsBoolean
                        then Concur := Concur + 1
                        else Abstain := Abstain + 1;

            end;  {with BoardMemberTable, ResultsPointer(BoardVoteTotalsList[Index])^ do}

        end;  {If not Done}

  until Done;

end;  {GetTotalsForBoardMember}

{====================================================================}
Procedure PrintMainHeaders(Sender : TObject;
                           PrintHeaders : Boolean);

begin
  with Sender as TBaseReport do
    begin
      If PrintHeaders
        then
          begin
            Bold := True;
            ClearTabs;
            SetTab(0.3, pjCenter, 1.0, 0, BoxLineBottom, 0);   {Board Member}
            SetTab(1.4, pjCenter, 0.4, 0, BoxLineBottom, 0);   {Year}
            SetTab(1.9, pjCenter, 0.7, 0, BoxLineBottom, 0);   {Active}
            SetTab(2.7, pjCenter, 0.7, 0, BoxLineBottom, 0);   {Concur}
            SetTab(3.5, pjCenter, 0.7, 0, BoxLineBottom, 0);   {Against}
            SetTab(4.3, pjCenter, 0.7, 0, BoxLineBottom, 0);   {Absent}
            SetTab(5.1, pjCenter, 0.7, 0, BoxLineBottom, 0);   {Abstain}

            Println(#9 + 'Member' +
                    #9 + 'Active' +
                    #9 + 'Year' +
                    #9 + 'Concur' +
                    #9 + 'Against' +
                    #9 + 'Absent' +
                    #9 + 'Abstain');

          end;  {If PrintHeaders}

      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.0, 0, BoxLineNone, 0);   {Board Member}
      SetTab(1.4, pjLeft, 0.4, 0, BoxLineNone, 0);   {Year}
      SetTab(1.9, pjRight, 0.7, 0, BoxLineNone, 0);   {Active}
      SetTab(2.7, pjRight, 0.7, 0, BoxLineNone, 0);   {Concur}
      SetTab(3.5, pjRight, 0.7, 0, BoxLineNone, 0);   {Against}
      SetTab(4.3, pjRight, 0.7, 0, BoxLineNone, 0);   {Absent}
      SetTab(5.1, pjRight, 0.7, 0, BoxLineNone, 0);   {Abstain}

    end;  {with Sender as TBaseReport do}

end;  {PrintMainHeaders}

{====================================================================}
Procedure PrintDetailHeaders(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      ClearTabs;
      Bold := True;
      SetTab(0.6, pjCenter, 1.1, 0, BoxLineBottom, 0);   {Parcel ID}
      SetTab(1.8, pjCenter, 0.4, 0, BoxLineBottom, 0);   {Year}
      SetTab(2.3, pjCenter, 1.8, 0, BoxLineBottom, 0);   {Description}
      SetTab(4.2, pjCenter, 1.0, 0, BoxLineBottom, 0);   {Overall result}
      SetTab(5.3, pjCenter, 0.7, 0, BoxLineBottom, 0);   {Concur}
      SetTab(6.1, pjCenter, 0.7, 0, BoxLineBottom, 0);   {Against}
      SetTab(6.9, pjCenter, 0.7, 0, BoxLineBottom, 0);   {Absent}
      SetTab(7.7, pjCenter, 0.7, 0, BoxLineBottom, 0);   {Abstain}

      Println(#9 + 'Parcel ID' +
              #9 + 'Year' +
              #9 + 'Grievance Desc' +
              #9 + 'Result' +
              #9 + 'Concur' +
              #9 + 'Against' +
              #9 + 'Absent' +
              #9 + 'Abstain');

      Bold := False;

      ClearTabs;
      SetTab(0.6, pjLeft, 1.1, 0, BoxLineNone, 0);   {Parcel ID}
      SetTab(1.8, pjLeft, 0.4, 0, BoxLineNone, 0);   {Year}
      SetTab(2.3, pjLeft, 1.8, 0, BoxLineNone, 0);   {Description}
      SetTab(4.2, pjLeft, 1.0, 0, BoxLineNone, 0);   {Overall result}
      SetTab(5.3, pjCenter, 0.7, 0, BoxLineNone, 0);   {Concur}
      SetTab(6.1, pjCenter, 0.7, 0, BoxLineNone, 0);   {Against}
      SetTab(6.9, pjCenter, 0.7, 0, BoxLineNone, 0);   {Absent}
      SetTab(7.7, pjCenter, 0.7, 0, BoxLineNone, 0);   {Abstain}

    end;  {with Sender as TBaseReport do}

end;  {PrintDetailHeaders}

{====================================================================}
Procedure TGrievanceResultsByBoardMemberReport.PrintDetails(Sender : TObject;
                                                            BoardMember : String;
                                                            GrievanceYear : String;
                                                            GrievanceYearsToPrint : Integer;
                                                            BoardVoteTotalsList : TList);

var
  Done, FirstTimeThrough : Boolean;
  Index : Integer;

begin
  ReportSection := 'D';
  SetRangeForBoardTable(BoardMemberTable, BoardMember, GrievanceYear, GrievanceYearsToPrint);

  PrintDetailHeaders(Sender);

  Done := False;
  FirstTimeThrough := True;
  BoardMemberTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else BoardMemberTable.Next;

    If BoardMemberTable.EOF
      then Done := True;

    If not Done
      then
        with BoardMemberTable, Sender as TBaseReport do
          begin
            If (LinesLeft < 5)
              then NewPage;

            FindKeyOld(GrievanceResultsTable,
                       ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber'],
                       [FieldByName('TaxRollYr').Text,
                        FieldByName('SwisSBLKey').Text,
                        FieldByName('GrievanceNumber').Text,
                        FieldByName('ResultNumber').Text]);

            If ShowDetails
            then Println(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                    #9 + FieldByName('TaxRollYr').Text +
                    #9 + GrievanceResultsTable.FieldByName('ComplaintReason').Text +
                    #9 + GrievanceResultsTable.FieldByName('Disposition').Text +
                    #9 + BooleanToX_Blank(FieldByName('Concur').AsBoolean) +
                    #9 + BooleanToX_Blank(FieldByName('Against').AsBoolean) +
                    #9 + BooleanToX_Blank(FieldByName('Absent').AsBoolean) +
                    #9 + BooleanToX_Blank(FieldByName('Abstain').AsBoolean));

             {CHG07112010-1(2.26.1.6)[I7732]: Add Excel extract.}

            If bExtractToExcel
            then WritelnCommaDelimitedLine(flExtract,
                                           [ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').AsString),
                                            FieldByName('TaxRollYr').AsString,
                                            GrievanceResultsTable.FieldByName('GrievanceNumber').AsInteger,
                                            GrievanceResultsTable.FieldByName('ComplaintReason').AsString,
                                            GrievanceResultsTable.FieldByName('Disposition').AsString,
                                            FieldByName('BoardMember').AsString,
                                            BooleanToX_Blank(FieldByName('Concur').AsBoolean),
                                            BooleanToX_Blank(FieldByName('Against').AsBoolean),
                                            BooleanToX_Blank(FieldByName('Absent').AsBoolean),
                                            BooleanToX_Blank(FieldByName('Abstain').AsBoolean)]);

          end;  {with BoardMemberTable, Sender as TBaseReport do}

  until Done;

  If ShowDetails
  then
  with Sender as TBaseReport do
    begin
      Index := FindRecordInResultsList(BoardMemberTable.FieldByName('BoardMember').Text,
                                       BoardMemberTable.FieldByName('TaxRollYr').Text,
                                       BoardVoteTotalsList);

      ClearTabs;
      SetTab(5.3, pjRight, 0.7, 0, BoxLineTop, 0);   {Concur}
      SetTab(6.1, pjRight, 0.7, 0, BoxLineTop, 0);   {Against}
      SetTab(6.9, pjRight, 0.7, 0, BoxLineTop, 0);   {Absent}
      SetTab(7.7, pjRight, 0.7, 0, BoxLineTop, 0);   {Abstain}

      with ResultsPointer(BoardVoteTotalsList[Index])^ do
        Println(#9 + IntToStr(Concur) +
                #9 + IntToStr(Against) +
                #9 + IntToStr(Absent) +
                #9 + IntToStr(Abstain));

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintDetails}

{====================================================================}
Procedure GetTotalsForOneBoardMember(ResultsPtr : ResultsPointer;
                                     _BoardMember : String;
                                     BoardVoteTotalsList : TList);

var
  I : Integer;

begin
  ResultsPtr^.BoardMember := _BoardMember;
  ResultsPtr^.Against := 0;
  ResultsPtr^.Absent := 0;
  ResultsPtr^.Concur := 0;
  ResultsPtr^.Abstain := 0;

  For I := 0 to (BoardVoteTotalsList.Count - 1) do
    with ResultsPointer(BoardVoteTotalsList[I])^ do
      If (BoardMember = _BoardMember)
        then
          begin
            ResultsPtr^.Against := ResultsPtr^.Against + Against;
            ResultsPtr^.Absent := ResultsPtr^.Absent + Absent;
            ResultsPtr^.Concur := ResultsPtr^.Concur + Concur;
            ResultsPtr^.Abstain := ResultsPtr^.Abstain + Abstain;

          end;  {If (BoardMember = _BoardMember)}

end;  {GetTotalsForOneBoardMember}

{====================================================================}
Procedure TGrievanceResultsByBoardMemberReport.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

        {Print the date and page number.}

      SetFont('Times New Roman',14);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Results by Board Member Report', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',10);
      Bold := True;

    end;  {with Sender as TBaseReport do}

  case ReportSection of
    'D' : PrintDetailHeaders(Sender);
  end;

end;  {PrintHeader}

{====================================================================}
Procedure TGrievanceResultsByBoardMemberReport.PrintOneTotalsLine(Sender : TObject;
                                                                  ResultsRec : ResultsRecord;
                                                                  GrandTotals : Boolean;
                                                                  PrintMemberName : Boolean);

var
  TempStr : String;

begin
  with Sender as TBaseReport, ResultsRec do
    begin
      If GrandTotals
        then TempStr := 'ALL'
        else TempStr := GrievanceYear;

      If PrintMemberName
        then Print(#9 + BoardMember)
        else Print(#9);

      Println(#9 + BooleanToX_Blank(Active) +
              #9 + TempStr +
              #9 + IntToStr(Concur) +
              #9 + IntToStr(Against) +
              #9 + IntToStr(Absent) +
              #9 + IntToStr(Abstain));

    end;  {with Sender as TBaseReport, ResultsRec do}

end;  {PrintOneTotalsLine}

{====================================================================}
Procedure TGrievanceResultsByBoardMemberReport.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, FirstLinePrinted : Boolean;
  SwisSBLKey : String;
  I, NumPrinted : Integer;
  BoardVoteTotalsList : TList;
  ResultsPtr : ResultsPointer;

begin
  BoardMemberCodeTable.First;
  Done := False;
  FirstTimeThrough := True;
  FirstLinePrinted := True;

  BoardVoteTotalsList := TList.Create;

  with Sender as TBaseReport do
    begin
        {First print the individual changes.}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else BoardMemberCodeTable.Next;

        If BoardMemberCodeTable.EOF
          then Done := True;

        SwisSBLKey := GrievanceResultsTable.FieldByName('SwisSBLKey').Text;
        Application.ProcessMessages;
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));

          {Print the present record.}

        If ((not Done) and
            (BoardMemberCodeTable.FieldByName('Active').AsBoolean or
             IncludeInactiveMembers))
          then
            begin
              GetTotalsForBoardMember(BoardMemberCodeTable.FieldByName('Code').Text,
                                      BoardVoteTotalsList,
                                      GrievanceYear,
                                      GrievanceYearsToPrint);

              If ((LinesLeft + BoardVoteTotalsList.Count) < 5)
                then NewPage;

              NumPrinted := 0;

              If (ShowDetails or
                  FirstLinePrinted)
                then PrintMainHeaders(Sender, True);

              FirstLinePrinted := False;

              For I := 0 to (BoardVoteTotalsList.Count - 1) do
                If (ResultsPointer(BoardVoteTotalsList[I])^.BoardMember =
                    BoardMemberCodeTable.FieldByName('Code').Text)
                  then
                    begin
                      NumPrinted := NumPrinted + 1;
                      PrintOneTotalsLine(Sender, ResultsPointer(BoardVoteTotalsList[I])^,
                                         False, (NumPrinted = 1));

                    end;  {If (ResultsPointer(BoardVoteTotalsList[I])^.BoardMember = ...}

              If (ShowDetails or bExtractToExcel)
                then PrintDetails(Sender, BoardMemberCodeTable.FieldByName('Code').Text,
                                 GrievanceYear, GrievanceYearsToPrint,
                                 BoardVoteTotalsList)
                else
                  If (NumPrinted > 1)
                    then
                      begin
                        New(ResultsPtr);
                        GetTotalsForOneBoardMember(ResultsPtr,
                                                   BoardMemberCodeTable.FieldByName('Code').Text,
                                                   BoardVoteTotalsList);

                        PrintOneTotalsLine(Sender, ResultsPtr^,
                                           ShowDetails, False);
                        Println('');

                        try
                          Dispose(ResultsPtr);
                        except
                        end;

                      end;  {If (ShowDetails or ...}

              If (LinesLeft < 5)
                then
                  begin
                    NewPage;
                    FirstLinePrinted := True;
                  end;

            end;  {If not (Done or Quit)}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or ReportCancelled);

    end;  {with Sender as TBaseReport do}

  FreeTList(BoardVoteTotalsList, SizeOf(ResultsRecord));

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TGrievanceResultsByBoardMemberReport.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TGrievanceResultsByBoardMemberReport.FormClose(    Sender: TObject;
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