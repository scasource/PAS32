unit NassauCountyDiskLoadUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBTables, ExtCtrls;

type
  Tfm_NassauCountyDiskLoad = class(TForm)
    ParcelTable: TTable;
    OpenDialog: TOpenDialog;
    NotFoundListBox: TListBox;
    AssessmentTable: TTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    TrialRunCheckBox: TCheckBox;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    RecordCountLabel: TLabel;
    NotFoundCountLabel: TLabel;
    TotalLandLabel: TLabel;
    TotalAssessedLabel: TLabel;
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fm_NassauCountyDiskLoad: Tfm_NassauCountyDiskLoad;

implementation

{$R *.DFM}
{$H+}

uses PASUtils, WinUtils, Utilitys, GlblVars, GlblCnst,
     Prog, RTCalcul, UtilEXSD, DataAccessUnit;

{===============================================================}
Procedure Tfm_NassauCountyDiskLoad.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{==================================================================}
Procedure Tfm_NassauCountyDiskLoad.StartButtonClick(Sender: TObject);

var
  I, RecCount, NotFoundCount : Integer;
  _Found, Done, TrialRun, Quit : Boolean;
  SpreadsheetFileName, ImportLine,
  (*Section, Subsection, Block,
  Lot, Sublot, Suffix, *) SBLKey, RawSBLKey, AssessmentYear : String;
  PriorAssessedValue, PriorLandValue, Difference,
  LandAssessedValue, TotalAssessedValue,
  GrandTotalLandValue, GrandTotalAssessedValue : LongInt;
  CountyFile, ExtractFile : TextFile;

begin
  Quit := False;
  TrialRun := TrialRunCheckBox.Checked;
  SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
  AssignFile(ExtractFile, SpreadsheetFileName);
  Rewrite(ExtractFile);
  NotFoundCount := 0;
  GrandTotalLandValue := 0;
  GrandTotalAssessedValue := 0;

  WritelnCommaDelimitedLine(ExtractFile,
                            ['SBL', 'Account #', 'Prior Land', 'New Land',
                             'Prior AV', 'New AV', 'Eq Incr', 'Eq Decr']);

  RecCount := 0;
  Done := False;
  OpenTablesForForm(Self, ThisYear);
  AssessmentYear := GlblThisYear;

  If OpenDialog.Execute
    then
      begin
        AssignFile(CountyFile, OpenDialog.FileName);
        Reset(CountyFile);

        repeat
          try
            Readln(CountyFile, ImportLine);
          except
            Done := True;
          end;

          Application.ProcessMessages;

          If EOF(CountyFile)
            then Done := True;

          RecCount := RecCount + 1;
          RecordCountLabel.Caption := 'Tot Rec Count = ' + IntToStr(RecCount);
          NotFoundCountLabel.Caption := 'Not Found = ' + IntToStr(NotFoundCount);
          TotalLandLabel.Caption := 'Land Total = ' + IntToStr(GrandTotalLandValue);
          TotalAssessedLabel.Caption := 'Assessed Total = ' + IntToStr(GrandTotalAssessedValue);

          SBLKey := Copy(ImportLine, 5, 23);
(*          RawSBLKey := SBLKey;

          Section := Copy(SBLKey, 1, 2);
          Subsection := '';
          Block := Copy(SBLKey, 3, 3);
          Block := ShiftRightAddZeroes(Take(3, Trim(Block)));
          Lot := Copy(SBLKey, 6, 2);

          If (Trim(Lot) <> '')
            then Lot := ShiftRightAddZeroes(Take(3, Trim(Lot)));
          Sublot := Copy(SBLKey, 8, 4);

          If ((Length(Trim(Sublot)) = 4) and
              (Sublot[1] = '1'))
            then
              begin
                Suffix := ShiftRightAddZeroes(Take(4, Trim(Sublot)));
                Sublot := '000';
              end
            else
              begin
                Delete(Sublot, 1, 1);
                Sublot := ShiftRightAddZeroes(Take(3, Trim(Sublot)));
                Suffix := Copy(SBLKey, 12, 1);
                If (Suffix = '0')
                  then Suffix := '';

                If (Suffix = 'U')
                  then Suffix := Copy(SBLKey, 21, 3);

              end;  {else of If (Length(Trim(Sublot) = 4)}

          _Found := FindKeyOld(ParcelTable,
                               ['TaxRollYr', 'Section',
                                'Subsection', 'Block', 'Lot',
                                'Sublot', 'Suffix'],
                               [AssessmentYear, Section, Subsection,
                                Block, Lot, Sublot, Suffix]);

          SBLKey := Take(3, Section) + Take(3, Subsection) +
                    Take(4, Block) + Take(3, Lot) +
                    Take(3, Sublot) + Take(4, Suffix); *)


          _Found := _Locate(ParcelTable, [AssessmentYear, SBLKey], '', [loParseSBLOnly]);

          try
            LandAssessedValue := StrToInt(Trim(DezeroOnLeft(Copy(ImportLine, 189, 8))));
          except
            LandAssessedValue := 0;
          end;

          try
            TotalAssessedValue := StrToInt(Trim(DezeroOnLeft(Copy(ImportLine, 197, 8))));
          except
            TotalAssessedValue := 0;
          end;

          GrandTotalLandValue := GrandTotalLandValue + LandAssessedValue;
          GrandTotalAssessedValue := GrandTotalAssessedValue + TotalAssessedValue;

          If not Done
            then
              If _Found
                then
                  begin
                    If FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                                  [AssessmentYear,
                                   ParcelTable.FieldByName('SwisCode').Text + SBLKey])
                      then
                        begin
                          with AssessmentTable do
                            try
                              Edit;
                              PriorAssessedValue := FieldByName('TotalAssessedVal').AsInteger;
                              PriorLandValue := FieldByName('LandAssessedVal').AsInteger;
                              FieldByName('TotalAssessedVal').AsInteger := TotalAssessedValue;
                              FieldByName('LandAssessedVal').AsInteger := LandAssessedValue;

                              Difference := TotalAssessedValue - PriorAssessedValue;

                              If (Difference > 0)
                                then
                                  begin
                                    FieldByName('IncreaseForEqual').AsInteger := Difference;
                                    FieldByName('DecreaseForEqual').AsInteger := 0;
                                  end
                                else
                                  begin
                                    FieldByName('IncreaseForEqual').AsInteger := 0;
                                    FieldByName('DecreaseForEqual').AsInteger := Difference;
                                  end;

                              FieldByName('PhysicalQtyIncrease').AsInteger := 0;
                              FieldByName('PhysicalQtyDecrease').AsInteger := 0;
                              FieldByName('AssessmentDate').AsDateTime := Date;

                              WritelnCommaDelimitedLine(ExtractFile,
                                                        ['_' + SBLKey,
                                                         ParcelTable.FieldByName('AccountNo').Text,
                                                         PriorLandValue, LandAssessedValue,
                                                         PriorAssessedValue, TotalAssessedValue,
                                                         FieldByName('IncreaseForEqual').AsInteger,
                                                         FieldByName('DecreaseForEqual').AsInteger]);

                              If TrialRun
                                then Cancel
                                else Post;

                            except
                              MessageDlg('Error posting assessment change for ' +
                                         SBLKey + '.', mtError, [mbOK], 0);
                            end;

                        end
                      else MessageDlg('Assessment record not found for ' +
                                      SBLKey + '.', mtError, [mbOK], 0);

                  end
                else
                  begin
                    NotFoundCount := NotFoundCount + 1;
                    NotFoundListBox.Items.Add(RawSBLKey + ',' +
                                              IntToStr(LandAssessedValue) + ',' +
                                              IntToStr(TotalAssessedValue));

                  end;

        until Done;

      end;  {If OpenDialog.Execute}

  TotalLandLabel.Caption := 'Land Total = ' + IntToStr(GrandTotalLandValue);
  TotalAssessedLabel.Caption := 'Assessed Total = ' + IntToStr(GrandTotalAssessedValue);
  Application.ProcessMessages;

  WritelnCommaDelimitedLine(ExtractFile, ['Parcels not found:']);
  WritelnCommaDelimitedLine(ExtractFile, ['SBL', 'Land AV', 'Total AV']);

  with NotFoundListBox do
    For I := 0 to (Items.Count - 1) do
      WritelnCommaDelimitedLine(ExtractFile, [Items[I]]);

  CloseFile(ExtractFile);
  SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                 False, '');

  CloseFile(CountyFile);

  CloseTablesForForm(Self);

  If ((not TrialRun) and
      (MessageDlg('The exemptions and roll totals must be recalculated.' + #13 +
                  'Do you want to recalculate now?' + #13 +
                  'If you do not, you will need to do it manually later.',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
        then
          begin
            ProgressDialog.Start(1, True, True);
            RecalculateAllExemptions(Self, ProgressDialog,
                                     ThisYear, GlblThisYear, True, Quit);

            If not Quit
              then CreateRollTotals(ThisYear, GlblThisYear, ProgressDialog, Self,
                                    False, True);

          end;  {If (MessageDlg('The exemptions ...}

end;  {StartButtonClick}

{===============================================================}
Procedure Tfm_NassauCountyDiskLoad.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{==========================================================}
Procedure Tfm_NassauCountyDiskLoad.FormClose(    Sender: TObject;
                                             var Action: TCloseAction);

begin
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
