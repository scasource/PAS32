unit Keychng;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,
  Types, RPFiler, RPBase, RPCanvas, RPrinter, Printrng, wwdblook,
  RPDefine;

type
  TKeyChangeForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    OKButton: TBitBtn;
    ClearButton: TBitBtn;
    ChangeModeButton: TButton;
    SourceGrid: TStringGrid;
    SourceLabel: TLabel;
    DestLabel: TLabel;
    DestGrid: TStringGrid;
    ModeLabel: TLabel;
    SplitMergeLabel: TLabel;
    SplitMergeNoEdit: TEdit;
    CopyInventoryCheckBox: TCheckBox;
    KeyChangeModePanel: TPanel;
    KeyChangeRadioGroup: TRadioGroup;
    ChooseModePanelOKButton: TBitBtn;
    ChooseModePanelCancelButton: TBitBtn;
    ParcelTable: TTable;
    YearLabel: TLabel;
    NameLabel: TLabel;
    AddrLabel: TLabel;
    Timer1: TTimer;
    NextSplitMergeNoLabel: TLabel;
    PrintButton: TBitBtn;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    StatusPanel: TPanel;
    PrintDialog: TPrintDialog;
    ParcelSDTable: TTable;
    Label8: TLabel;
    RollSection9Panel: TPanel;
    GroupBox1: TGroupBox;
    RS9PanelCancelButton: TBitBtn;
    RS9PanelOKButton: TBitBtn;
    Label4: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EditRS9Amount: TEdit;
    SDCodeLookupCombo: TwwDBLookupCombo;
    DestTable: TTable;
    SourceTable: TTable;
    Label14: TLabel;
    MergeHintLabel: TImage;
    Label15: TLabel;
    AuditParcelChangeTable: TTable;
    AuditSDChangeTable: TTable;
    AuditEXChangeTable: TTable;
    DefaultRS9SpecialDistrict: TwwDBLookupCombo;
    DefaultRS9SpecialDistrictLabel: TLabel;
    DefaultRS9HelpLabel: TLabel;
    SplitMergeDtlTable: TTable;
    SplitMergeHdrTable: TTable;
    AuditTable: TTable;
    CreateParcelListCheckBox: TCheckBox;
    SegmentDisplayPanel: TPanel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    SectionLabel: TLabel;
    SuffixLabel: TLabel;
    SubsectionLabel: TLabel;
    BlockLabel: TLabel;
    LotLabel: TLabel;
    SublotLabel: TLabel;
    SetDestParcelInfoButton: TBitBtn;
    SetDestParcelInfoButtonPositionTimer: TTimer;
    CopyPicturesCheckBox: TCheckBox;
    tb_ParcelByAccountNumber: TTable;
    rg_GridEntryMethod: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CloseButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure KeyChangeModePanelExit(Sender: TObject);
    procedure ChooseModePanelCancelButtonClick(Sender: TObject);
    procedure ChooseModePanelOKButtonClick(Sender: TObject);
    procedure ChangeModeButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure SourceGridSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure SourceGridExit(Sender: TObject);
    procedure DestGridExit(Sender: TObject);
    procedure DestGridSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure SplitMergeNoEditExit(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrinterBeforePrint(Sender: TObject);
    procedure ReportPrinterPrintHeader(Sender: TObject);
    function ReportPrinterPrintPage(Sender: TObject;
      var PageNum: Integer): Boolean;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RS9PanelCancelButtonClick(Sender: TObject);
    procedure RS9PanelOKButtonClick(Sender: TObject);
    procedure RollSection9PanelExit(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure SetDestParcelInfoButtonClick(Sender: TObject);
    procedure SetDestParcelInfoButtonPositionTimerTimer(Sender: TObject);
    procedure rg_GridEntryMethodClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    UnitName : String;
    ProcessingType : Integer;  {ThisYear, NextYear, History}
    TaxRollYr : String;  {Tax year for this processing type}
    FirstTimePanelShown : Boolean;  {Is this the first time that the panel is being shown?}
    ChooseModePanelButtonPressed,
    RS9PanelButtonPressed : Boolean;
    NextSplitMergeNo : Integer;
    DefaultGridWidth : Integer;  {Grid width with vertical scroll bar.}
    Mode : Integer;  {Split\Merge\SBL Change\CopyParcel\Roll Section 9}

      {These four variables are for printing.}

    NumSourceSBLsPrinted,
    NumDestSBLsPrinted,
    NumSourceSBLsToPrint,
    NumDestSBLsToPrint : Integer;

    SplitMergePrinted, {Have they printed this split\merge?}
    SplitMergeCancelledInPrint : Boolean;  {Did they cancel the split\merge during print?}

      {CHG02261998-1: Need opposite year tables to adjust opposite year
                      roll totals.}

    OppositeYearParcelTable,
    OppositeYearParcelExemptionTable,
    OppositeYearEXCodeTable,
    OppositeYearParcelSDTable,
    OppositeYearSDCodeTable,
    OppositeYearAssessmentTable,
    OppositeYearClassTable : TTable;

    OppositeYearProcessingType : Integer;
    OppositeTaxYear : String;

    InventoryCopyMode, PictureCopyMode : Integer;
    DisplayClassifiedParcelWarning : Boolean;
    CreateParcelList : Boolean;
    SwisCodeTable, SDCodeTable,
    AssessmentTable, NYParcelTable,
    AssessmentYearControlTable,
    ParcelExemptionTable,
    EXCodeTable, ClassTable : TTable;
    DestParcelInfoList : TList;
    GridEntryMethod : Integer;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure OpenSourceDestTables(    TableName : String;
                                       ProcessingType : Integer;
                                   var Quit : Boolean);
    {Open the source and destination tables with the given TableName using the ProcessingType
     for this form.}

    Procedure CopyRecordsFromSourceToDestsOneTable(    SourceTable,
                                                       DestTable : TTable;
                                                       SourceParcelID : String;  {Source parcel ID to copy from.}
                                                       DestList,  {List of parcel ID's to copy to.}
                                                       DestExistsList,
                                                       FieldList,  {Any fields that need to be set specially for this table?}
                                                       FieldValueList : TStringList;  {If so, what values?}
                                                       RecordShouldBePresentInSource : Boolean;
                                                       TaxRollYr : String;
                                                   var Quit : Boolean);

    {Given a source and destination tables (both pointing to the same type of table), along
     with a source parcel ID and destination list (both in 26 char SwisSBL format), copy all
     the records in the source table with this SwisSBL to each destination parcel ID.
     Note that if the var RecordShouldBePresentInSource is True and we could not find one record
     for the parcel, then we will give an error. Otherwise, if we do not find a record for this
     parcel ID in this table, we will ignore it.}

    Procedure CopySourceToNewParcels(    SourceParcelID : String;
                                         SourceList,
                                         DestList,
                                         DestExistsList : TStringList;
                                         CopyExemptions : Boolean;
                                         SplitMergeNo : String;
                                         Mode : Integer;  {Split\Merge\SBL change\Copy}
                                         ProcessingType : Integer;
                                         TaxRollYr : String;
                                     var Quit : Boolean);
    {Given a source parcel ID, copy it to all the parcels in the destination list.}

    Procedure SwitchOrConvertTheParcelIDs(    ParcelID1 : String;
                                              ParcelID2 : String;
                                              ActionMode : Char;  {(S)witch or (C)onvert}
                                              bConvertHistory : Boolean;
                                          var Quit : Boolean);

    Procedure SetParentParcelRelationship(    SourceParcelID,
                                              ChildParcelID,
                                              SplitMergeNo : String;
                                              TaxRollYr : String;
                                              ParcelTable : TTable;
                                          var Quit : Boolean);
    {Make this parcel a parent and set the child related SBL.}

    Procedure MarkSourceParcelsInactive(SourceList,
                                        DestList,
                                        DestExistsList : TStringList;
                                        TaxRollYr : String;
                                        ParcelTable : TTable;
                                        SplitMergeNo : String);
    {Mark the source parcel inactive and delete the roll totals.}

    Procedure FillInDestinationList(DestList,
                                    DestExistsList : TStringList;
                                    TaxRollYr : String;
                                    ParcelTable : TTable);
    {FXX02161999-1: Allow to spilt\merge into an existing parcel.}

    Procedure SaveSplitMergeAudit(SourceList,
                                  DestList,
                                  DestExistsList : TStringList;
                                  MarkInactive : Boolean);
    {FXX04081999-6: Store this split/merge.}

    Procedure MergeValuesForParcel(SourceList : TStringList;
                                   DestinationList : TStringList;
                                   AssessmentYear : String;
                                   ShowFrontageDepthWarningMessage : Boolean;
                                   AdjustEqualizationChange : Boolean);

    Function GetSwisSBLFromGridEntry(    GridEntry : String;
                                     var ValidEntry : Boolean) : String;

  end;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  PASTypes, GlblCnst,
     PRCLLIST,
     UTILRTOT,  {Roll total update unit.}
     Datamodule,
     DataAccessUnit,
     DestInfo,  {Form to enter default information about the destination parcel.}
     Preview;   {Print preview form}

{$R *.DFM}

const
  invCopyNone = 0;
  invCopyToFirst = 1;
  invCopyAll = 2;

  picCopyNone = 0;
  picCopyToFirst = 1;
  picCopyAll = 2;

(*  gemAccountNumber = 0; *)
  gemSBL = 0;
  gemPrintKey = 1;

{========================================================}
Procedure TKeyChangeForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TKeyChangeForm.InitializeForm;

var
  Quit : Boolean;

begin
  UnitName := 'KEYCHNG';  {mmm}
  Quit := False;

  If glblUseExactPrintKey
  then GridEntryMethod := gemPrintKey
  else GridEntryMethod := gemSBL;

    {Don't allow any typing until they have chosen a mode.}

  SourceGrid.Options := SourceGrid.Options - [goEditing];
  DestGrid.Options := DestGrid.Options - [goEditing];

  ProcessingType := DetermineProcessingType(GlblTaxYearFlg);
  TaxRollYr := GetTaxRlYr;

  ChooseModePanelButtonPressed := False;
  RS9PanelButtonPressed := False;

    {Now set the year label.}

  SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);

  OpenTablesForForm(Self, GlblProcessingType);

    {FXX01202000-1: Display NY name for roll section 9 since that is the name
                    that goes on the bill.}

  SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                          ProcessingType);
  SDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                        ProcessingType);
  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                            ProcessingType);
  NYParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                          NextYear);
  AssessmentYearControlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                       ProcessingType);
  EXCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                        ProcessingType);
  ClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                       ProcessingType);
  ParcelExemptionTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                 ProcessingType);

    {Don't allow roll section 9 for next year.}

  If (GlblProcessingType = NextYear)
    then KeyChangeRadioGroup.Items.Delete(RollSection9);

  Timer1.Enabled := True;
  DefaultGridWidth := SourceGrid.Width;
  NextSplitMergeNo := AssessmentYearControlTable.FieldByName('NextSplitMergeNo').AsInteger;
  NextSplitMergeNoLabel.Caption := '(Next S\M# = ' + IntToStr(NextSplitMergeNo) + ')';

    {Now, let's force the active control to be the split merge number rather than
     the grids. If it were the grids, then the first SelectCell occurs when they
     click on the mode and this can cause a situation where the first entry in the
     grid "disappears". Trust me - this works!}

  ActiveControl := SplitMergeNoEdit;

  SplitMergePrinted := False;
  SplitMergeCancelledInPrint := False;

    {CHG02261998-1: Need opposite year tables to adjust opposite year
                    roll totals.}

  If (GlblModifyBothYears and
      (ProcessingType = ThisYear))
    then
      begin
        OppositeYearProcessingType := NextYear;
        OppositeTaxYear := GlblNextYear;

        OppositeYearParcelTable := TTable.Create(nil);
        OppositeYearParcelSDTable := TTable.Create(nil);

        OppositeYearSDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                                          OppositeYearProcessingType);
        OppositeYearAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                              OppositeYearProcessingType);
        OppositeYearEXCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                          OppositeYearProcessingType);
        OppositeYearClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                                         OppositeYearProcessingType);
        OppositeYearParcelExemptionTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                                   OppositeYearProcessingType);

        OpenTableForProcessingType(OppositeYearParcelTable, ParcelTableName,
                                   OppositeYearProcessingType, Quit);
        OpenTableForProcessingType(OppositeYearParcelSDTable, SpecialDistrictTableName,
                                   OppositeYearProcessingType, Quit);

        OppositeYearParcelSDTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        OppositeYearParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

      end;  {If GlblModifyBothYears}

    {CHG02232001-1: Let them modify the defaults.}

  DestParcelInfoList := TList.Create;

end;  {InitializeForm}

{===================================================================}
Procedure TKeyChangeForm.FormKeyPress(    Sender: TObject;
                                      var Key: Char);

begin
  If (Key = #13)
    then
      If ((ActiveControl is TStringGrid) and
          (TStringGrid(ActiveControl).Row < (TStringGrid(ActiveControl).RowCount - 1)))
        then
          begin
              {FXX09142001-1: If they hit enter on a blank row, go to the next control.}

            with TStringGrid(ActiveControl) do
              If (Deblank(Cells[Col, Row]) = '')
                then
                  begin
                    If (Name = 'SourceGrid')
                      then DestGrid.SetFocus;

                    If (Name = 'DestGrid')
                      then OKButton.SetFocus;

                  end
                else TStringGrid(ActiveControl).Row := TStringGrid(ActiveControl).Row + 1
          end
        else
          begin
            Key := #0;
            Perform(WM_NEXTDLGCTL, 0, 0);
          end;

    {If they hit tab in the last row of a grid, issue an actual tab instead of
     trying to tab within the grid.}

  If (Key = #9)
    then
      If ((ActiveControl is TStringGrid) and
          (TStringGrid(ActiveControl).Row = (TStringGrid(ActiveControl).RowCount - 1)))
        then
          begin
            Key := #0;
            Perform(WM_NEXTDLGCTL, 0, 0);
          end;

end;  {FormKeyPress}

{===========================================================}
Procedure TKeyChangeForm.GridKeyPress(    Sender: TObject;
                                      var Key: Char);

{FXX02261998-4: Make all entries in the SBL grids upper case.}

begin
  Key := Upcase(Key);
end;

{==============================================================}
Procedure TKeyChangeForm.rg_GridEntryMethodClick(Sender: TObject);

begin
  GridEntryMethod := rg_GridEntryMethod.ItemIndex;
end;  {rg_GridEntryMethodClick}

{==============================================================}
Procedure TKeyChangeForm.Timer1Timer(Sender: TObject);

{Get the mode.}

begin
    {Make sure that the two panels are centered.}

  KeyChangeModePanel.Left := (ScrollBox.Width - KeyChangeModePanel.Width) DIV 2;
  KeyChangeModePanel.Top := (ScrollBox.Height - KeyChangeModePanel.Height) DIV 2;
  RollSection9Panel.Left := (ScrollBox.Width - RollSection9Panel.Width) DIV 2;
  RollSection9Panel.Top := (ScrollBox.Height - RollSection9Panel.Height) DIV 2;

  Timer1.Enabled := False;
  FirstTimePanelShown := True;
  ChooseModePanelButtonPressed := False;
  KeyChangeModePanel.Visible := True;

end;  {Timer1Timer}

{============================================================}
Procedure TKeyChangeForm.KeyChangeModePanelExit(Sender: TObject);

{Make them stay in the panel until they hit OK or cancel.}

begin
  If not ChooseModePanelButtonPressed
    then KeyChangeModePanel.SetFocus;

end;  {KeyChangeModePanelExit}

{============================================================}
Procedure TKeyChangeForm.ChooseModePanelCancelButtonClick(Sender: TObject);

{They clicked cancel, so let's hide the panel. However, if this is the first time that
 the panel has been displayed (i.e. on start up), we will close the form.}

begin
  If FirstTimePanelShown
    then Close
    else
      begin
        SourceGrid.Options := SourceGrid.Options + [goEditing];
        DestGrid.Options := DestGrid.Options + [goEditing];

        ChooseModePanelButtonPressed := True;
        KeyChangeModePanel.Visible := False;

      end;  {else of If FirstTimePanelShown}

end;  {PanelCancelButtonClick}

{============================================================}
Procedure TKeyChangeForm.ChooseModePanelOKButtonClick(Sender: TObject);

{They clicked OK, so let's close the panel, but only if they actually selected something.}

var
  I : Integer;
  EntriesExist : Boolean;

begin
  EntriesExist := False;

  If ((NumEntriesInGridCol(SourceGrid, 0) > 0) or
      (NumEntriesInGridCol(DestGrid, 0) > 0))
    then EntriesExist := True;

    {If there are any entries in the grid, we will warn them before
     they switch modes since they will lose all the data they
     entered so far.}

  If (KeyChangeRadioGroup.ItemIndex <> -1)
    then
      If ((not EntriesExist) or
          (EntriesExist and
           (MessageDlg('All parcels will be cleared when you switch modes.' + #13 +
                       'Do you want to proceed?', mtWarning, [mbYes, mbNo], 0) = idYes)))
        then
          begin
            FirstTimePanelShown := False;
            ChooseModePanelButtonPressed := True;
            KeyChangeModePanel.Visible := False;
            ModeLabel.Visible := True;
            MergeHintLabel.Visible := False;
            SplitMergeNoEdit.Visible := True;
            NextSplitMergeNoLabel.Visible := True;
            SplitMergeLabel.Visible := True;

              {CHG04121998-1: Allow for selection of default SD.}

            DefaultRS9SpecialDistrict.Visible := False;
            DefaultRS9SpecialDistrictLabel.Visible := False;
            DefaultRS9HelpLabel.Visible := False;

              {Clear the grids.}

            For I := 0 to (SourceGrid.RowCount - 1) do
              SourceGrid.Cells[0, I] := '';

            For I := 0 to (DestGrid.RowCount - 1) do
              DestGrid.Cells[0, I] := '';

              {Now set up the screen for this mode.}

            case KeyChangeRadioGroup.ItemIndex of
              Split :
                  begin  {Split}
                    Mode := Split;
                    ModeLabel.Caption := 'Mode: Split';
                    SourceLabel.Caption := 'Original Parcel ID(s)';
                    DestLabel.Caption := 'New Parcels';
                    SourceGrid.RowCount := 999;
                    SourceGrid.Height := SourceGrid.DefaultRowHeight * 10 + 12;
                    SourceGrid.Width := DefaultGridWidth;
                    DestGrid.RowCount := 999;
                    DestGrid.Height := DestGrid.DefaultRowHeight * 10 + 12;
                    DestGrid.Width := DefaultGridWidth;
                    CopyInventoryCheckBox.Visible := True;
                    CopyInventoryCheckBox.Checked := True;
                    SplitMergeNoEdit.Text := IntToStr(NextSplitMergeNo);
                    MergeHintLabel.Visible := True;

                  end;   {Split}

              Merge :
                  begin  {Merge}
                    Mode := Merge;
                    ModeLabel.Caption := 'Mode: Merge';
                    SourceLabel.Caption := 'Original Parcel IDs';
                    DestLabel.Caption := 'New Parcel ID';
                    SourceGrid.RowCount := 999;
                    SourceGrid.Height := SourceGrid.DefaultRowHeight * 10 + 12;
                    SourceGrid.Width := DefaultGridWidth;
                    DestGrid.RowCount := 1;
                    DestGrid.Height := DestGrid.DefaultRowHeight + 2;
                    DestGrid.Width := DefaultGridWidth - GetSystemMetrics(SM_CXVSCROLL);
                    CopyInventoryCheckBox.Visible := True;
                    CopyInventoryCheckBox.Checked := True;
                    SplitMergeNoEdit.Text := IntToStr(NextSplitMergeNo);
                    MergeHintLabel.Visible := True;

                 end;   {Merge}

              SBLChange :
                  begin  {SBL change}
                    Mode := SBLChange;
                    ModeLabel.Caption := 'Mode: SBL Change';
                    SourceLabel.Caption := 'Parcel To Be Changed';
                    DestLabel.Caption := 'New Parcel ID';
                    SourceGrid.RowCount := 1;
                    SourceGrid.Height := SourceGrid.DefaultRowHeight + 2;
                    SourceGrid.Width := DefaultGridWidth - GetSystemMetrics(SM_CXVSCROLL);
                    DestGrid.RowCount := 1;
                    DestGrid.Height := DestGrid.DefaultRowHeight + 2;
                    DestGrid.Width := DefaultGridWidth - GetSystemMetrics(SM_CXVSCROLL);
                    CopyInventoryCheckBox.Visible := False;
                    SplitMergeNoEdit.Text := '99999999';

                  end;   {SBL change}

              CopyParcel :
                  begin  {Copy}
                    Mode := CopyParcel;
                    ModeLabel.Caption := 'Mode: Copy';
                    SourceLabel.Caption := 'Source Parcel ID';
                    DestLabel.Caption := 'New Parcels';
                    SourceGrid.RowCount := 1;
                    SourceGrid.Height := SourceGrid.DefaultRowHeight;
                    SourceGrid.Width := DefaultGridWidth - GetSystemMetrics(SM_CXVSCROLL);
                    DestGrid.RowCount := 999;
                    DestGrid.Height := DestGrid.DefaultRowHeight * 10 + 12;
                    DestGrid.Width := DefaultGridWidth;
                    CopyInventoryCheckBox.Visible := True;
                    CopyInventoryCheckBox.Checked := True;
                    SplitMergeNoEdit.Text := '99999999';

                  end;   {Copy}

                {CHG12112002-2: Allow 2 parcels to be completely switched.}

              SwitchParcels :
                  begin
                    Mode := SwitchParcels;
                    ModeLabel.Caption := 'Mode: Switch';
                    SourceLabel.Caption := 'Parcel ID 1';
                    DestLabel.Caption := 'Parcel ID 2';
                    SourceGrid.RowCount := 1;
                    SourceGrid.Height := SourceGrid.DefaultRowHeight;
                    SourceGrid.Width := DefaultGridWidth - GetSystemMetrics(SM_CXVSCROLL);
                    DestGrid.RowCount := 999;
                    DestGrid.RowCount := 1;
                    DestGrid.Height := DestGrid.DefaultRowHeight + 2;
                    DestGrid.Width := DefaultGridWidth - GetSystemMetrics(SM_CXVSCROLL);
                    CopyInventoryCheckBox.Visible := False;
                    SplitMergeNoEdit.Text := '99999999';

                  end;   {SwitchParcels}

              RollSection9 :
                  begin  {RS9}
                    Mode := RollSection9;
                    ModeLabel.Caption := 'Mode: Roll Section 9';
                    SourceLabel.Caption := 'Original Parcel';
                    DestLabel.Caption := 'Roll Section 9 Parcel ID';
                    SourceGrid.RowCount := 1;
                    SourceGrid.Height := SourceGrid.DefaultRowHeight + 2;
                    SourceGrid.Width := DefaultGridWidth - GetSystemMetrics(SM_CXVSCROLL);
                    DestGrid.RowCount := 1;
                    DestGrid.Height := DestGrid.DefaultRowHeight + 2;
                    DestGrid.Width := DefaultGridWidth - GetSystemMetrics(SM_CXVSCROLL);
                    CopyInventoryCheckBox.Visible := False;
                    CopyPicturesCheckBox.Visible := False;
                    SplitMergeNoEdit.Text := Take(8, '');
                    SplitMergeNoEdit.Visible := False;
                    NextSplitMergeNoLabel.Visible := False;
                    SplitMergeLabel.Visible := False;

                      {CHG04121998-1: Allow for selection of default SD.}

                    DefaultRS9SpecialDistrict.Visible := True;
                    DefaultRS9SpecialDistrictLabel.Visible := True;
                    DefaultRS9HelpLabel.Visible := True;

                  end;   {RS 9}

            end;  {case KeyChangeRadioGroup.ItemIndex of}

              {Center the source and destination labels within the width of their respective
               grids.}

            SourceLabel.Left := SourceGrid.Left + (SourceGrid.Width -
                                                   SourceLabel.Canvas.TextWidth(SourceLabel.Caption)) DIV 2;
            DestLabel.Left := DestGrid.Left + (DestGrid.Width -
                                               DestLabel.Canvas.TextWidth(DestLabel.Caption)) DIV 2;

              {Make it so that the name and address label are right below the source grid.}

            NameLabel.Top := SourceGrid.Top + SourceGrid.Height + 10;
            AddrLabel.Top := SourceGrid.Top + SourceGrid.Height + 10;

            CopyInventoryCheckBox.Checked := False;

              {Clear the grids.}

            For I := 0 to (SourceGrid.RowCount - 1) do
              SourceGrid.Cells[0, I] := '';

            For I := 0 to (DestGrid.RowCount - 1) do
              DestGrid.Cells[0, I] := '';

            SourceGrid.Row := 0;
            DestGrid.Row := 0;
            SourceGrid.SetFocus;
            NameLabel.Caption := '';
            AddrLabel.Caption := '';
            SourceGrid.Refresh;
            DestGrid.Refresh;

            DestGrid.Options := DestGrid.Options + [goEditing];
            SourceGrid.Options := SourceGrid.Options + [goEditing];

          end  {If ((not EntriesExist) or ...}
    else MessageDlg('Please choose a mode.', mtError, [mbOK], 0);

end;  {PanelOKButtonClick}

{=====================================================================}
Procedure TKeyChangeForm.ClearButtonClick(Sender: TObject);

{Confirm that they want to cancel. If they do, then clear out the grids.}

var
  TempStr : String;
  I : Integer;

begin
  TempStr := ConvertModeToStr(Mode);

  If (MessageDlg('Are you sure you want to clear the parcels for this ' + TempStr + '?', mtConfirmation,
                 [mbYes, mbNo], 0) = mrYes)
    then
      begin
        SplitMergePrinted := False;
        SplitMergeCancelledInPrint := False;

        For I := 0 to (SourceGrid.RowCount - 1) do
          SourceGrid.Cells[0, I] := '';

        For I := 0 to (DestGrid.RowCount - 1) do
          DestGrid.Cells[0, I] := '';

        SourceGrid.SetFocus;
        NameLabel.Caption := '';
        AddrLabel.Caption := '';

        SetDestParcelInfoButton.Top := 26;

      end;  {If (MessageDlg('Are  ...}

end;  {ClearButtonClick}

{=====================================================================}
Procedure TKeyChangeForm.SetDestParcelInfoButtonClick(Sender: TObject);

{CHG02232001-1: Let them modify the defaults.}

var
  _DestinationSwisSBLKey, _SourceSwisSBLKey : String;
  ValidEntry : Boolean;

begin
  _SourceSwisSBLKey := GetSwisSBLFromGridEntry(SourceGrid.Cells[0, 0], ValidEntry);
  _DestinationSwisSBLKey := GetSwisSBLFromGridEntry(DestGrid.Cells[0, DestGrid.Row], ValidEntry);

  try
    EnterDestinationParcelInformationForm := TEnterDestinationParcelInformationForm.Create(Application);

    with EnterDestinationParcelInformationForm do
      begin
        SourceSwisSBLKey := _SourceSwisSBLKey;
        AssessmentYear := TaxRollYr;

          {FXX03292002-3: Check for information that already exists.}

        InitializeForm(_DestinationSwisSBLKey, DestParcelInfoList,
                       GlblProcessingType);

        If (ShowModal = idOK)
          then AddDefaultInformationItem(_DestinationSwisSBLKey, DestParcelInfoList,
                                         ProcessingType);

      end;  {with EnterDestinationParcelInformationForm do}

  finally
    EnterDestinationParcelInformationForm.Free;
  end;

end;  {SetDestParcelInfoButtonClick}

{=======================================================================}
Procedure TKeyChangeForm.SourceGridSelectCell(    Sender: TObject;
                                                  Col,
                                                  Row: Longint;
                                              var CanSelect: Boolean);

{They have just selected a new cell in the string grid, so let's validate the cell that
 they were just in (only if it is non-blank).}

var
  SwisSBLKey, GridSwisSBLEntry : String;
  FoundRec, ValidEntry : Boolean;
  SwisSBLRec : SBLRecord;
  RS9SwisSBLKey : String;
  TempTable : TTable;

begin
  ValidEntry := False;
  GridSwisSBLEntry := SourceGrid.Cells[0, SourceGrid.Row];

    {If the entry is non-blank then check the entry.}

  If ((Screen.ActiveControl.Name <> 'CloseButton') and
      (Deblank(GridSwisSBLEntry) <> ''))
    then
      begin
        GridSwisSBLEntry := UpcaseStr(GridSwisSBLEntry);

        SwisSBLKey := GetSwisSBLFromGridEntry(GridSwisSBLEntry, ValidEntry);

        If ValidEntry
          then
            begin
                 {Check to make sure that this parcel ID exists.}

              FoundRec := _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey]);

              SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);
              If DuplicateExistsInGrid(SourceGrid, 0, SourceGrid.Row)
                then
                  begin
                    MessageDlg('That parcel ID already is in the source list.' + #13 +
                               'Please check and enter again.', mtError, [mbOK], 0);
                    CanSelect := False;
                  end
                else
                  If FoundRec
                    then
                      begin
                          {If the parcel is inactive, they can not do any action on it.}

                        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
                          then
                            begin
                              MessageDlg('That parcel is inactive.' + #13 +
                                         'Please check and enter again.', mtError, [mbOK], 0);
                              CanSelect := False;
                            end
                          else
                            begin
                                {Make sure that the entry is upper case.}

                              SourceGrid.Cells[0, SourceGrid.Row] := UpcaseStr(SourceGrid.Cells[0, SourceGrid.Row]);

                                {Make sure that the name and address labels are visible.}

                              If not NameLabel.Visible
                                then
                                  begin
                                    NameLabel.Visible := True;
                                    AddrLabel.Visible := True;
                                  end;

                                {FXX01202000-1: Display NY name for roll section 9 since that is the name
                                                that goes on the bill.}

                              If (Mode = RollSection9)
                                then
                                  begin
                                    with SwisSBLRec do
                                      FindKeyOld(NYParcelTable,
                                                 ['TaxRollYr', 'SwisCode', 'Section',
                                                  'Subsection', 'Block', 'Lot', 'Sublot',
                                                  'Suffix'],
                                                 [GlblNextYear, SwisCode, Section, Subsection,
                                                  Block, Lot, SubLot, Suffix]);
                                    TempTable := NYParcelTable;
                                  end
                                else TempTable := ParcelTable;

                              NameLabel.Caption := Take(15, TempTable.FieldByName('Name1').Text);
                              AddrLabel.Caption := Take(15, GetLegalAddressFromTable(TempTable));

                                {If this is roll section 9, and they just entered the original
                                 parcel and the destination parcel ID is blank, then we will
                                 default the destination SBL to the same except the suffix will
                                 contain the year.}
                                {FXX12011998-1: Do a take on the swis SBL since the
                                                string may be < 22 char. Also,
                                                default suffix to next year.}

                              If ((Mode = RollSection9) and
                                  (Deblank(DestGrid.Cells[0,0]) = ''))
                                then
                                  begin
                                    RS9SwisSBLKey := Take(22, SwisSBLKey) + GlblNextYear;
                                    DestGrid.Cells[0, 0] := ConvertSwisSBLToDashDot(RS9SwisSBLKey);

                                      {FXX02281999-4: Hard to edit rs 9 sbl.}

                                    ChangeModeButton.SetFocus;
                                    DestGrid.Repaint;

                                  end;  {If ((Mode = RollSection9) and ...}

                                {FXX11221999-4: Make sure destination parcel does not already exist.}

                              If ((Mode = RollSection9) and
                                  (Deblank(DestGrid.Cells[0,0]) <> ''))
                                then
                                  begin
                                    RS9SwisSBLKey := Take(22, SwisSBLKey) + GlblNextYear;
                                    SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(RS9SwisSBLKey);

                                    with SwisSBLRec do
                                      FoundRec := FindKeyOld(ParcelTable,
                                                             ['TaxRollYr', 'SwisCode', 'Section',
                                                              'Subsection', 'Block', 'Lot', 'Sublot',
                                                              'Suffix'],
                                                             [TaxRollYr, SwisCode, Section, Subsection,
                                                              Block, Lot, SubLot, Suffix]);

                                    If FoundRec
                                      then
                                        begin
                                          DestGrid.SetFocus;

                                           {FXX02032000-1: Check for existence of roll section 9 parcels
                                                           after leave dest grid, not source grid.}

                                          MessageDlg('Warning! The roll section 9 parcel ' +
                                                     DestGrid.Cells[0, 0] + ' already exists.' + #13 +
                                                     'Please change the parcel ID so that it is unique.',
                                                     mtWarning, [mbOK], 0);

                                        end;  {If FoundRec}

                                  end;  {If ((Mode = RollSection9) and ...}

                            end;  {else of If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)}
                      end
                    else
                      begin
                        MessageDlg('This parcel does not exist.' + #13 +
                                   'Please check the parcel ID and enter again.',
                                   mtError, [mbOK], 0);
                        CanSelect := False;
                        SourceGrid.SetFocus;
                        NameLabel.Caption := '';
                        AddrLabel.Caption := '';

                      end;  {If not FoundRec}

            end
          else
            begin
              CanSelect := False;
              MessageDlg('Parcel cannot be located.' + #13 +
                         'Please enter in Print Key format.',
                         mtError, [mbOK], 0);
              SourceGrid.SetFocus;
              NameLabel.Caption := '';
              AddrLabel.Caption := '';

            end;  {If not ValidEntry}

      end;  {If (Deblank(SwisSBLEntry) <> '')}

end;  {SourceGridSelectCell}

{===============================================================}
Procedure TKeyChangeForm.SourceGridExit(Sender: TObject);

{When they exit the source grid, if they did not just click on the clear or change mode
 button, then we want to check the entry. The logic for this is already in the
 SourceGridSelectCell event, so we will just call it.}

var
  CanSelect : Boolean;

begin
  If ((ActiveControl.Name <> 'ClearButton') and
      (ActiveControl.Name <> 'ChangeModeButton'))
    then SourceGridSelectCell(Sender, 0, 0, CanSelect);

end;  {SourceGridExit}

{=======================================================================}
Procedure TKeyChangeForm.DestGridSelectCell(    Sender: TObject;
                                                Col,
                                                Row: Longint;
                                            var CanSelect: Boolean);

{They have just selected a new cell in the string grid, so let's validate the cell that
 they were just in (only if it is non-blank).}

var
  SwisSBLKey, GridSwisSBLEntry : String;
  FoundRec, ValidEntry : Boolean;
  SwisSBLRec : SBLRecord;

begin
  ValidEntry := False;
  CanSelect := True;
  GridSwisSBLEntry := ANSIUpperCase(DestGrid.Cells[0, DestGrid.Row]);

    {If the entry is non-blank then check the entry.}

  If ((Screen.ActiveControl.Name <> 'CloseButton') and
      (Deblank(GridSwisSBLEntry) <> ''))
    then
      begin
        SwisSBLKey := ConvertSwisDashDotToSwisSBL(GridSwisSBLEntry, SwisCodeTable, ValidEntry);

        If _Compare(GlblMunicipalityName, 'Malverne', coEqual)
          then SwisSBLKey := GetMalverneSwisSBLFromPrintKey(GridSwisSBLEntry,
                                                            ParcelTable.FieldByName('SwisCode').AsString);

          {CHG12112002-2: Allow 2 parcels to be completely switched.}

        If ValidEntry
          then
            begin
                 {Check to make sure that this parcel ID does not exist.}

                 {Check to make sure that this parcel ID exists.}

              FoundRec := _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey]);

              SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                {Make sure that this entry is not already in the grid and that the
                 parcel does not already exist. If it is OK, make sure to uppercase
                 the entry.}

              If DuplicateExistsInGrid(DestGrid, 0, DestGrid.Row)
                then
                  begin
                    MessageDlg('That parcel ID already is in the destination list.' + #13 +
                               'Please check and enter again.', mtError, [mbOK], 0);
                    CanSelect := False;
                  end
                else
                  If FoundRec
                    then
                      begin
                          {FXX02161999-1: Allow to spilt\merge into an existing
                                          parcel.}

                        case Mode of
                          Split,
                          Merge : If (MessageDlg('The parcel ' +
                                             ConvertSwisSBLToDashDot(SwisSBLKey) +
                                             ' already exists.' + #13 +
                                             'If this parcel ID is correct, click Yes.' + #13 +
                                             'Otherwise click No and enter the correct parcel ID.',
                                             mtWarning, [mbYes, mbNo], 0) = idNo)
                                    then
                                      begin
                                        CanSelect := False;
                                        DestGrid.SetFocus;
                                      end;

                          SwitchParcels : DestGrid.Cells[0, DestGrid.Row] := UpcaseStr(DestGrid.Cells[0, DestGrid.Row]);

                          else
                            begin
                              MessageDlg('This parcel already exists.' + #13 +
                                         'Please check the parcel ID and enter again.',
                                         mtError, [mbOK], 0);
                              CanSelect := False;
                              DestGrid.SetFocus;
                            end;

                        end;  {case Mode of}

                      end  {If FoundRec}
                    else
                      If (Mode = SwitchParcels)
                        then
                          begin
                            MessageDlg('Sorry, the parcel ' + DestGrid.Cells[0, DestGrid.Row] + ' does not exist.' + #13 +
                                       'Both parcels must exist to perform a switch.', mtError, [mbOK], 0);
                            CanSelect := False;
                            DestGrid.SetFocus;
                          end
                        else
                          begin
                            DestGrid.Cells[0, DestGrid.Row] := UpcaseStr(DestGrid.Cells[0, DestGrid.Row]);

                              {CHG04272000-3: Display the segments.}

                            If (Mode <> RollSection9)
                              then SegmentDisplayPanel.Visible := True;

                            with SwisSBLRec do
                              begin
                                SectionLabel.Caption := Section;
                                SubsectionLabel.Caption := Subsection;
                                BlockLabel.Caption := Block;
                                LotLabel.Caption := Lot;
                                SublotLabel.Caption := Sublot;
                                SuffixLabel.Caption := Suffix;

                              end;  {with SwisSBLRec do}

                          end;  {else of If (Mode = SwitchParcels)}

            end
          else
            begin
              CanSelect := False;
              MessageDlg('Sorry, invalid parcel ID entry.' + #13 +
                         'Please enter in form Swis/Dash Dot SBL where Swis is short Swis code.',
                         mtError, [mbOK], 0);
              DestGrid.SetFocus;

            end;  {If not ValidEntry}

          {Move the dest info button to the correct row.}

        If CanSelect
          then SetDestParcelInfoButtonPositionTimer.Enabled := True;

      end;  {If (Deblank(SwisSBLEntry) <> '')}

end;  {DestGridSelectCell}

{==================================================================}
Procedure TKeyChangeForm.SetDestParcelInfoButtonPositionTimerTimer(Sender: TObject);

begin
  SetDestParcelInfoButtonPositionTimer.Enabled := False;

    {Move the dest info button to the correct row.}

  with DestGrid do
    SetDestParcelInfoButton.Top := Top + (Row - TopRow) * (DefaultRowHeight + 1) + 2;

end;  {SetDestParcelInfoButtonPositionTimerTimer}

{===============================================================}
Procedure TKeyChangeForm.DestGridExit(Sender: TObject);

{When they exit the Dest grid, if they did not just click on the clear or change mode
 button, then we want to check the entry. The logic for this is already in the
 DestGridSelectCell event, so we will just call it.}

var
  CanSelect : Boolean;

begin
  If ((ActiveControl.Name <> 'ClearButton') and
      (ActiveControl.Name <> 'ChangeModeButton'))
    then DestGridSelectCell(Sender, 0, 0, CanSelect);

end;  {DestGridExit}

{======================================================================}
Procedure TKeyChangeForm.SplitMergeNoEditExit(Sender: TObject);

{The split merge number must be 99999999, 99998888, or the next split merge
 number.}

var
  Found, ValidSplitMergeNo : Boolean;

begin
  If ((SplitMergeNoEdit.Text <> '99999999') and
      (SplitMergeNoEdit.Text <> '99998888'))
    then
      begin
        ValidSplitMergeNo := True;

        try
          StrToInt(SplitMergeNoEdit.Text);
        except
          ValidSplitMergeNo := False;
          MessageDlg('Please enter a valid number for the split merge number.',
                     mtError, [mbOK], 0);
          SplitMergeNoEdit.SetFocus;
        end;

          {FXX04091999-1: Check to see if that split merge number exists.}

        If ValidSplitMergeNo
          then
            begin
              SplitMergeHdrTable.IndexName := 'BYSPLITMERGENO';

              Found := FindKeyOld(SplitMergeHdrTable,
                                  ['SplitMergeNo'],
                                  [SplitMergeNoEdit.Text]);

              If (Found and
                  (MessageDlg('That split\merge number has already been used.' + #13 +
                              'Are you sure you want to use it again?', mtWarning,
                              [mbYes, mbNo], 0) = idNo))
                then SplitMergeNoEdit.SetFocus;

            end;  {If ValidSplitMergeNo}

      end;  {If ((SplitMergeNoEdit.Text <> '99999999') and}

end;  {SplitMergeNoEditExit}

{======================================================================}
Procedure TKeyChangeForm.OpenSourceDestTables(    TableName : String;
                                                  ProcessingType : Integer;
                                              var Quit : Boolean);

{Open the source and destination tables with the given TableName using the ProcessingType
 for this form.}
{CHG02261998-1: Pass in the processing type in order to do dual processing.}

begin
  SourceTable.Close;
  DestTable.Close;

  SourceTable.TableName := TableName;
  DestTable.TableName := TableName;

  If _Compare(TableName, PictureTableName, coEqual)
    then
      begin
        SourceTable.IndexName := 'BYSWISSBLKEY';
        DestTable.IndexName := 'BYSWISSBLKEY';
      end
    else
      begin
        SourceTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
        DestTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
      end;

  SetTableNameForProcessingType(SourceTable, ProcessingType);
  SetTableNameForProcessingType(DestTable, ProcessingType);

  try
    SourceTable.Open;
  except
    Quit := True;
    SystemSupport(003, SourceTable, 'Error opening source table ' + TableName + '.',
                  UnitName, GlblErrorDlgBox);
  end;

  try
    DestTable.Open;
  except
    Quit := True;
    SystemSupport(004, DestTable, 'Error opening dest table ' + TableName + '.',
                  UnitName, GlblErrorDlgBox);
  end;

end;  {OpenSourceDestTables}

{======================================================================}
Procedure TKeyChangeForm.CopyRecordsFromSourceToDestsOneTable(    SourceTable,
                                                                  DestTable : TTable;
                                                                  SourceParcelID : String;  {Parcel ID to copy from.}
                                                                  DestList,  {List of parcel ID's to copy to.}
                                                                  DestExistsList,
                                                                  FieldList,  {Any fields that to set for this table?}
                                                                  FieldValueList : TStringList;  {If so, what values?}
                                                                  RecordShouldBePresentInSource : Boolean;
                                                                  TaxRollYr : String;
                                                              var Quit : Boolean);

{Given a source and destination tables (both pointing to the same type of table), along
 with a source parcel ID and destination list (both in 26 char SwisSBL format), copy all
 the records in the source table with this SwisSBL to each destination parcel ID.
 Note that if the var RecordShouldBePresentInSource is True and we could not find one record
 for the parcel, then we will give an error. Otherwise, if we do not find a record for this
 parcel ID in this table, we will ignore it.
 Also, if this is the assessment table, we only want to copy the last assessment record.}

var
  FoundRec, FirstTimeThrough,
  IsInventoryTable, IsAssessmentTable,
  IsPictureTable, IsParcelTable, Done : Boolean;
  I, J : Integer;
  FName : String;
  _DestinationSwisSBLKey, DestSwisSBLKey, NewSwisSBLKey : String;
  DestSwisSBLRec, SwisSBLRec : SBLRecord;  {For parcel table only.}

begin
  FirstTimeThrough := True;
  Done := False;

  IsParcelTable := (Pos('Parcel', SourceTable.TableName) <> 0);
  IsAssessmentTable := (Pos('Assess', SourceTable.TableName) <> 0);
  IsInventoryTable := (Pos('Residential', SourceTable.TableName) <> 0) or
                      (Pos('Commercial', SourceTable.TableName) <> 0);
  IsPictureTable := _Compare(SourceTable.TableName, PictureTableName, coEqual);

    {If this is the parcel table, we need to find the first key by segment
     (i.e. section, subsection, etc.). However, all other keys have a 26 char
     SwisSBLKey field.}

  If IsParcelTable
    then
      begin
        SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(SourceParcelID);

        with SwisSBLRec do
          FoundRec := FindKeyOld(SourceTable,
                                 ['TaxRollYr', 'SwisCode', 'Section',
                                  'Subsection', 'Block', 'Lot', 'Sublot',
                                  'Suffix'],
                                 [TaxRollYr, SwisCode, Section, Subsection,
                                  Block, Lot, Sublot, Suffix]);

      end
    else
      begin
        If IsPictureTable
          then FoundRec := FindKeyOld(SourceTable, ['SwisSBLKey'], [SourceParcelID])
          else FoundRec := FindKeyOld(SourceTable,
                                      ['TaxRollYr', 'SwisSBLKey'],
                                      [TaxRollYr, SourceParcelID]);

      end;  {else of If IsParcelTable}

    {If we only want to copy the last record. To do this, we will set a range and get the last rec.}

  If IsAssessmentTable
    then
      begin
        SetRangeOld(SourceTable,
                    ['TaxRollYr', 'SwisSBLKey'],
                    [TaxRollYr, SourceParcelID],
                    [TaxRollYr, SourceParcelID]);

        try
          SourceTable.Last;
        except
          Quit := True;
          SystemSupport(007, SourceTable, 'Error getting record in ' + SourceTable.TableName + '.',
                        UnitName, GlblErrorDlgBox);
        end;

      end;  {If IsAssessmentTable}

  If not FoundRec
    then
      begin
        Done := True;

        If RecordShouldBePresentInSource
          then
            begin
              Quit := True;
              SystemSupport(008, SourceTable, 'Error getting record in ' + SourceTable.TableName + '.',
                            UnitName, GlblErrorDlgBox);
            end;  {If RecordShouldBePresentInSource}

      end;  {If not FoundRec}

    If not (Done or Quit)
      then
        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else
              try
                SourceTable.Next;
              except
                SystemSupport(009, SourceTable, 'Error getting next record in ' + SourceTable.TableName + '.',
                              UnitName, GlblErrorDlgBox);
              end;

            {If we are on a different parcel ID then the source, then
             we are done. Note that if this is the parcel table, the
             swis sbl is stored in segments, so to find the 26 char swis sbl key,
             we have to call ExtractSSKey. In all other records, we just have
             to look at the SwisSBLKey field.}

          If IsParcelTable
            then NewSwisSBLKey := ExtractSSKey(SourceTable)
            else NewSwisSBlKey := SourceTable.FieldByName('SwisSBLKey').Text;

          If (Take(26, NewSwisSBLKey) <> Take(26, SourceParcelID))
            then Done := True;

            {If we got a record for this source parcel id ok, then we will copy it to all
             destination parcel id's.}

            {FXX02161999-1: Allow to spilt\merge into an existing
                            parcel.}
            {CHG07211999-1: Allow copying of inventory to 1st parcel or all.}
            {CHG10152004-1(2.8.0.14): Allow copying of pictures to 1st parcel or all.}

          If not (Done or Quit)
            then
              For I := 0 to (DestList.Count - 1) do
                If ((not (IsInventoryTable or IsPictureTable)) or
                    (IsInventoryTable and
                     ((InventoryCopyMode = invCopyAll) or
                      ((InventoryCopyMode = invCopyToFirst) and
                       (I = 0)))) or
                    (IsPictureTable and
                     ((PictureCopyMode = picCopyAll) or
                      ((PictureCopyMode = picCopyToFirst) and
                       (I = 0)))))
                  then
                    If (DestExistsList[I] = 'Y')
                      then
                        begin
                          SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(DestList[I]);

                            {If this destination exists, set the split merge # and
                             relationship.}

                          If IsParcelTable
                            then
                              try
                                with SwisSBLRec do
                                  FindKeyOld(DestTable,
                                             ['TaxRollYr', 'SwisCode', 'Section',
                                              'Subsection', 'Block', 'Lot', 'Sublot',
                                              'Suffix'],
                                             [TaxRollYr, SwisCode, Section, Subsection,
                                              Block, Lot, Sublot, Suffix]);

                                DestTable.Edit;

                                For J := 0 to (FieldList.Count - 1) do
                                  DestTable.FieldByName(FieldList[J]).Text := FieldValueList[J];

                                DestTable.Post;
                              except
                                Quit := True;
                                SystemSupport(010, DestTable, 'Error updating existng parcel record.',
                                              UnitName, GlblErrorDlgBox);
                              end;

                        end
                      else
                        begin
                          DestTable.Insert;

                          StatusPanel.Caption := 'Creating parcel ' +
                                                 ConvertSwisSBLToDashDot(DestList[I]) +
                                                 ' in table ' + SourceTable.TableName + '.';
                          StatusPanel.Repaint;

                            {Loop through all the fields of the source table and copy them into
                             the destination table.}

                          For J := 0 to (SourceTable.FieldCount - 1) do
                            begin
                              FName := SourceTable.Fields[J].FieldName;

                              try
                                DestTable.FieldByName(FName).Text := SourceTable.FieldByName(FName).Text;
                              except
                                  {If a date is stored as 0/0/0000, it will cause and exception, so blank it out.}

                                If (SourceTable.FieldByName(FName).Text = '0/0/0000')
                                  then DestTable.FieldByName(FName).Text := '';

                              end;

                            end;  {For J := 0 to (SourceTable.FieldCount - 1) do}

                            {Now, if there are any fields that need to be set specially, let's loop
                             through the FieldList string list and set them.}

                          For J := 0 to (FieldList.Count - 1) do
                            DestTable.FieldByName(FieldList[J]).Text := FieldValueList[J];

                            {We want to be sure to set the destination SwisSBL
                             rather than the source. If this is the parcel table,
                             we need to set each field indiviually. Otherwise, we
                             can just do the 26 char SwisSBL.}
                            {FXX04071998-3: The destination parcel should
                                            get today's creation date. Also
                                            mark as modified today.}

                          If IsParcelTable
                            then
                              begin
        (*                        DestSwisSBLKey := ConvertSwisDashDotToSwisSBL(DestList[I],
                                                                              SwisCodeTable,
                                                                              ValidEntry); *)
                                DestSwisSBLRec := ExtractSwisSBLFromSwisSBLKey(DestList[I]);

                                with DestSwisSBLRec do
                                  begin
                                    DestTable.FieldByName('SwisCode').Text := SwisCode;
                                    DestTable.FieldByName('Section').Text := Section;
                                    DestTable.FieldByName('Subsection').Text := Subsection;
                                    DestTable.FieldByName('Block').Text := Block;
                                    DestTable.FieldByName('Lot').Text := Lot;
                                    DestTable.FieldByName('Sublot').Text := Sublot;
                                    DestTable.FieldByName('Suffix').Text := Suffix;

                                    try
                                      DestTable.FieldByName('SwisSBLKey').AsString := DestList[I];
                                    except
                                    end;

                                    try
                                      DestTable.FieldByName('PrintKey').AsString := ConvertSBLOnlyToDashDot(Copy(DestTable.FieldByName('SwisSBLKey').AsString, 7, 20));
                                    except
                                    end;

                                    DestTable.FieldByName('CheckDigit').Text := ReturnCheckDigit(DestSwisSBLKey, 0);
                                    DestTable.FieldByName('ParcelCreatedDate').AsDateTime := Date;
                                    DestTable.FieldByName('LastChangeByName').Text := GlblUserName;
                                    DestTable.FieldByName('LastChangeDate').AsDateTime := Date;

                                  end;  {with DestSwisSBLRec do}

                                  {CHG02232001-1: Let them modify the defaults.}
                                  {Search through the default list and override.}

                                _DestinationSwisSBLKey := ExtractSSKey(DestTable);

                                  {FXX04022003-1(2.06r): Make sure that the new parcel
                                                         SwisSBLKey gets the new value.}

                                DestTable.FieldByName('SwisSBLKey').Text := _DestinationSwisSBLKey;

                                For J := 0 to (DestParcelInfoList.Count - 1) do
                                  with DestinationParcelInformationPointer(DestParcelInfoList[J])^ do
                                    If (SwisSBLKey = _DestinationSwisSBLKey)
                                      then
                                        try
                                          DestTable.FieldByName(FieldName).Text := FieldValue;
                                        except
                                          DestTable.FieldByName(FieldName).Text := '0';
                                        end;

                                  {FXX02232000-1: Don't copy class records in a split.}

                                If ((Mode = Split) and
                                    (DestTable.FieldByName('HomesteadCode').Text = 'S'))
                                  then
                                    begin
                                      DestTable.FieldByName('HomesteadCode').Text := 'H';
                                      DisplayClassifiedParcelWarning := True;
                                    end;

                                  {CHG03302000-1: Option to add to parcel list.}

                                If (CreateParcelList and
                                    (not ParcelListDialog.ParcelExistsInList(DestList[I])))
                                  then ParcelListDialog.AddOneParcel(DestList[I]);

                              end  {If IsParcelTable}
                            else
                              begin
                                DestTable.FieldByName('SwisSBLKey').Text := DestList[I];

                              end;  {else of If IsParcelTable}

                          try
                            DestTable.Post;
                          except
                            SystemSupport(011, DestTable, 'Error posting into table ' + DestTable.TableName,
                                          UnitName, GlblErrorDlgBox);
                          end;

                        end;  {else of If (DestExistsList[I] = 'Y')}

            {If this is the assessment table, then we are done since we only want to copy one record.}

          If IsAssessmentTable
            then Done := True;

          If (SourceTable.EOF)
            then Done := True;

        until (Done or Quit);

end;  {CopyRecordsFromSourceToDestsOneTable}

{======================================================================}
Procedure TKeyChangeForm.CopySourceToNewParcels(    SourceParcelID : String;
                                                    SourceList,
                                                    DestList,
                                                    DestExistsList : TStringList;
                                                    CopyExemptions : Boolean;
                                                    SplitMergeNo : String;
                                                    Mode : Integer;  {Split\Merge\SBL change\Copy}
                                                    ProcessingType : Integer;
                                                    TaxRollYr : String;
                                                var Quit : Boolean);

{Given a source parcel ID, copy it to all the parcels in the destination list.}
{CHG02261998-1: Pass in the processing type and tax roll year in order to do
                dual processing.}

var
  AssessmentRecordFound, ClassRecordFound, ValidEntry : Boolean;
  FieldList, FieldValueList : TStringList;
  DestSwisSBLKey : String;
  I : Integer;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  SDAmounts : TList;
  BasicSTARAmount, EnhancedSTARAmount,
  HstdAssessedVal, NonhstdAssessedVal,
  HstdLandVal, NonhstdLandVal, AssessedValue : Comp;
  HstdAcres, NonhstdAcres : Real;
  _ParcelTable, _ParcelExemptionTable, _EXCodeTable,
  _AssessmentTable, _ParcelSDTable, _SDCodeTable, _ClassTable : TTable;
  EXAmounts : ExemptionTotalsArrayType;
  AuditEXChangeList : TList;
  OrigAuditParcelRec, NewAuditParcelRec : AuditParcelRecord;
  TempRollSection : String;
  OrigNameAddressRec,
  NewNameAddressRec : NameAddressRecord;

begin
  Quit := False;
  FieldList := TStringList.Create;
  FieldValueList := TStringList.Create;

    {First copy the base parcel record to all new destination records. We will do this
     by hand since we have to fill in the split merge # and the date changed and
     changed by user id's.}

  OpenSourceDestTables(ParcelTableName, ProcessingType, Quit);

  If not Quit
    then
      begin
          {For the parcel records, we want to set the last change date and user ID's. Also,
           we want to set the split merge number.}

        FieldList.Add('LastChangeDate');
        FieldValueList.Add(DateToStr(Date));
        FieldList.Add('LastChangeByName');
        FieldValueList.Add(GlblUserName);

          {FXX02171999-3: Do not mark opposite year parcels with s\m info.}

        If (ProcessingType <> OppositeYearProcessingType)
          then
            begin
              FieldList.Add('SplitMergeNo');
              FieldValueList.Add(SplitMergeNo);

                {In the case of split, merge, and SBL change, this is a child parcel,
                 so fill in the related SBL and the relationship.}

              case Mode of
                Split,
                Merge,
                SBLChange :
                  begin
                    FieldList.Add('RelatedSBL');
                    FieldValueList.Add(ConvertSwisSBLToDashDot(SourceParcelID));
                    FieldList.Add('SBLRelationship');
                    FieldValueList.Add('C');

                  end;  {Split\Merge\SBL change}

                  {FXX11191999-13: Change the parcel created date to today.}

                RollSection9 :
                  begin
                    FieldList.Add('RS9LinkedSBL');
                    FieldValueList.Add(SourceParcelID);
                    FieldList.Add('RollSection');
                    FieldValueList.Add('9');
                    FieldList.Add('ParcelCreatedDate');
                    FieldValueList.Add(DateToStr(Date));

                  end;  {RollSection9}

              end;  {case Mode of}

            end;  {If (ProcessingType <> OppositeYearProcessingType)}

          {FXX02171999-5: Also, store the old SBL.}
          {FXX06291999-5: Put the old SBL on Ty and NY.}

        If (Mode = SBLChange)
          then
            begin
              FieldList.Add('RemapOldSBL');
              FieldValueList.Add(ConvertSwisSBLToDashDot(SourceParcelID));
            end;

          {CHG06252001-1: Maintain a seperate indexed SwisSBLKey into the parcel file.}

        FieldList.Add('SwisSBLKey');
        FieldValueList.Add(Take(26, SourceParcelID));

        CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID, DestList,
                                             DestExistsList, FieldList, FieldValueList, True,
                                             TaxRollYr, Quit);

      end;  {If not Quit}

  FieldList.Clear;
  FieldValueList.Clear;

    {Now do assessments.}

  If not Quit
    then OpenSourceDestTables(AssessmentTableName, ProcessingType, Quit);
  If not Quit
    then
      begin
          {Set the assessment date to today.}

        FieldList.Add('AssessmentDate');
        FieldValueList.Add(DateToStr(Date));

          {If this is roll section 9 processing, the assessment record amounts should be zero.}
          {FXX01041998-1: Copy with AV and decrease\increase amounts 0, so that
                          parcel does not have to be put out of balance.}

          {FXX06291999-2: If this is an SBL change, then copy over the assessed values.
                          Same for copy.}

        If ((Mode <> SBLChange) and
            (Mode <> CopyParcel))
          then
            begin
              FieldList.Add('LandAssessedVal');
              FieldValueList.Add('0');
              FieldList.Add('TotalAssessedVal');
              FieldValueList.Add('0');
              FieldList.Add('PhysicalQtyIncrease');
              FieldValueList.Add('0');
              FieldList.Add('PhysicalQtyDecrease');
              FieldValueList.Add('0');
              FieldList.Add('IncreaseForEqual');
              FieldValueList.Add('0');
              FieldList.Add('DecreaseForEqual');
              FieldValueList.Add('0');

            end;  {If (Mode <> SBLChange)}

          {FXX11182003-3(2.07k): Make sure to zero out the hold prior value on new parcels
                                 so that there are no remnants on this parcel to affect
                                 the Assessor's Report.}

        If (Mode <> SwitchParcels)
          then
            begin
              FieldList.Add('HoldPriorValue');
              FieldValueList.Add('0');

                {FXX11182003-4(2.07k): Actually the prior values should be blanked out, too.}

              FieldList.Add('PriorLandValue');
              FieldValueList.Add('0');
              FieldList.Add('PriorTotalValue');
              FieldValueList.Add('0');

            end;  {If (Mode <> SwitchParcels)}

        CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                             DestList, DestExistsList, FieldList, FieldValueList,
                                             False, TaxRollYr, Quit);
      end;  {If not Quit}

  FieldList.Clear;
  FieldValueList.Clear;

    {Now do class records.}
    {FXX02232000-1: Don't copy class records in a split.}

  If (Mode <> Split)
    then
      begin
        If not Quit
          then OpenSourceDestTables(ClassTableName, ProcessingType, Quit);
        If not Quit
          then
            begin
                {If this is roll section 9 processing, the class record amounts should be zero.}
                {FXX01041998-1: Copy with AV and decrease\increase amounts 0, so that
                                parcel does not have to be put out of balance.}

                {FXX06291999-2: If this is an SBL change, then copy over the assessed values.
                                Same for copy.}

              If ((Mode <> SBLChange) and
                  (Mode <> CopyParcel))
                then
                  begin
                                     FieldList.Add('HstdLandVal');
                    FieldValueList.Add('0');
                    FieldList.Add('HstdTotalVal');
                    FieldValueList.Add('0');
                    FieldList.Add('HstdPhysQtyInc');
                    FieldValueList.Add('0');
                    FieldList.Add('HstdPhysQtyDec');
                    FieldValueList.Add('0');
                    FieldList.Add('HstdEqualInc');
                    FieldValueList.Add('0');
                    FieldList.Add('HstdEqualDec');
                    FieldValueList.Add('0');

                    FieldList.Add('NonhstdLandVal');
                    FieldValueList.Add('0');
                    FieldList.Add('NonhstdTotalVal');
                    FieldValueList.Add('0');
                    FieldList.Add('NonhstdPhysQtyInc');
                    FieldValueList.Add('0');
                    FieldList.Add('NonhstdPhysQtyDec');
                    FieldValueList.Add('0');
                    FieldList.Add('NonhstdEqualInc');
                    FieldValueList.Add('0');
                    FieldList.Add('NonhstdEqualDec');
                    FieldValueList.Add('0');

                  end;  {If (Mode <> SBLChange)}

              CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable,
                                                    SourceParcelID,
                                                    DestList,
                                                    DestExistsList,
                                                    FieldList,
                                                    FieldValueList,
                                                    False, TaxRollYr, Quit);
            end;  {If not Quit}

      end;  {If (Mode <> Split)}

  FieldList.Clear;
  FieldValueList.Clear;

    {Now do special districts. However, we won't copy them for roll section 9.}

  If not Quit
    then OpenSourceDestTables(SpecialDistrictTableName, ProcessingType, Quit);

  If ((Mode <> RollSection9) and
      (not Quit))
    then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                              DestList, DestExistsList, FieldList, FieldValueList,
                                              False, TaxRollYr, Quit);

    {Now do exemptions, if they want to copy them.}
    {FXX07211999-3: Need to make sure not to copy AutoIncrementID - causes error code 5.}

  If CopyExemptions
    then
      begin
        If not Quit
          then OpenSourceDestTables(ExemptionsTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

       FieldList.Clear;
       FieldValueList.Clear;

     end;  {If CopyExemptions}

    {Now, if they want to do inventory, let's copy it.}
    {CHG07211999-1: Allow copying of inventory to 1st parcel or all.}

  If (InventoryCopyMode in [invCopyAll, invCopyToFirst])
    then
      begin
          {For the site records, we want to set the last change date and user ID's.}

        FieldList.Add('LastChangeDate');
        FieldValueList.Add(DateToStr(Date));
        FieldList.Add('LastChangeByName');
        FieldValueList.Add(GlblUserName);

           {Do the residential site.}

        If not Quit
          then OpenSourceDestTables(ResidentialSiteTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

        FieldList.Clear;
        FieldValueList.Clear;

           {Do the residential bldg.}

        If not Quit
          then OpenSourceDestTables(ResidentialBldgTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

           {Do the residential forest.}

        If not Quit
          then OpenSourceDestTables(ResidentialForestTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

           {Do the residential land.}

        If not Quit
          then OpenSourceDestTables(ResidentialLandTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

           {Do the residential improvement.}

        If not Quit
          then OpenSourceDestTables(ResidentialImprovementsTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

          {For the site records, we want to set the last change date and user ID's.}

        FieldList.Add('LastChangeDate');
        FieldValueList.Add(DateToStr(Date));
        FieldList.Add('LastChangeByName');
        FieldValueList.Add(GlblUserName);


           {Do the commercial site.}

        If not Quit
          then OpenSourceDestTables(CommercialSiteTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

        FieldList.Clear;
        FieldValueList.Clear;

           {Do the commercial bldg.}

        If not Quit
          then OpenSourceDestTables(CommercialBldgTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

           {Do the commercial land.}

        If not Quit
          then OpenSourceDestTables(CommercialLandTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

           {Do the commercial improvement.}

        If not Quit
          then OpenSourceDestTables(CommercialImprovementsTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

           {Do the commercial income\expense.}

        If not Quit
          then OpenSourceDestTables(CommercialIncomeExpenseTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

           {Do the commercial rent.}

        If not Quit
          then OpenSourceDestTables(CommercialRentTableName, ProcessingType, Quit);
        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

      end;  {If CopyInventory}

      {CHG10152004-1(2.8.0.14): Allow copying of pictures to 1st parcel or all.}
      {FXX03142007-1(2.11.1.19): Pictures should not be copied in both This Year and Next Year.}

  If (_Compare(TaxRollYr, OppositeTaxYear, coNotEqual) and
      (PictureCopyMode in [picCopyAll, picCopyToFirst]))
    then
      begin
        FieldList.Clear;
        FieldValueList.Clear;

        If not Quit
          then
            begin
              OpenSourceDestTables(PictureTableName, ProcessingType, Quit);
              SourceTable.IndexName := 'BYSWISSBLKEY';
            end;

        If not Quit
          then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                                    DestList, DestExistsList, FieldList, FieldValueList,
                                                    False, TaxRollYr, Quit);

      end;  {If (PictureCopyMode in [picCopyAll, picCopyToFirst])}

     {FXX05281999-3: Copy user data in split\merge.}
     {FXX07211999-1: User data should always be copied - not dependant on copy inventory.}

   If not Quit
     then OpenSourceDestTables(UserDataTableName, ProcessingType, Quit);
   If not Quit
     then CopyRecordsFromSourceToDestsOneTable(SourceTable, DestTable, SourceParcelID,
                                               DestList, DestExistsList, FieldList, FieldValueList,
                                               False, TaxRollYr, Quit);

  FieldValueList.Free;
  FieldList.Free;

    {CHG02261998-1: Adjust roll totals for opposite year if they are in
                    dual processing mode.}

  If (TaxRollYr = OppositeTaxYear)
    then
      begin
        _ParcelTable := OppositeYearParcelTable;
        _ParcelExemptionTable := OppositeYearParcelExemptionTable;
        _EXCodeTable := OppositeYearEXCodeTable;
        _AssessmentTable := OppositeYearAssessmentTable;
        _ParcelSDTable := OppositeYearParcelSDTable;
        _SDCodeTable := OppositeYearSDCodeTable;
        _ClassTable := OppositeYearClassTable;
     end
    else
      begin
        _ParcelTable := ParcelTable;
        _ParcelExemptionTable := ParcelExemptionTable;
        _EXCodeTable := EXCodeTable;
        _AssessmentTable := AssessmentTable;
        _ParcelSDTable := ParcelSDTable;
        _SDCodeTable := SDCodeTable;
        _ClassTable := ClassTable;

      end;  {else of If (TaxRollYr = OppositeTaxYear)}

    {Now add in the roll totals for all new parcels.}
    {FXX02161999-1: Allow person to enter destination that exists - do
                    not adjust roll totals if it exists in source and dest
                    since nothing will happen to this parcel.}

  For I := 0 to (DestList.Count - 1) do
    If (DestExistsList[I] = 'N')
      then
        begin
          DestSwisSBLKey := DestList[I];

          ExemptionCodes := TStringList.Create;
          ExemptionHomesteadCodes := TStringList.Create;
          ResidentialTypes := TStringList.Create;
          CountyExemptionAmounts := TStringList.Create;
          TownExemptionAmounts := TStringList.Create;
          SchoolExemptionAmounts := TStringList.Create;
          VillageExemptionAmounts := TStringList.Create;
          SDAmounts := TList.Create;

          FindKeyOld(_AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                     [TaxRollYr, DestSwisSBLKey]);

            {Now figure out the exemption totals.}
            {CHG12011997-2: STAR support}
            {FXX02091998-1: Pass the residential type of each exemption.}

          EXAmounts := TotalExemptionsForParcel(TaxRollYr, DestSwisSBLKey,
                                    _ParcelExemptionTable,
                                    _EXCodeTable,
                                    _ParcelTable.FieldByName('HomesteadCode').Text,
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

            {The special district amounts may have changed, so
             calculate the  special district amounts, too.}

          TotalSpecialDistrictsForParcel(TaxRollYr,
                                         DestSwisSBLKey,
                                         _ParcelTable,
                                         _AssessmentTable,
                                         _ParcelSDTable,
                                         _SDCodeTable,
                                         _ParcelExemptionTable,
                                         _EXCodeTable,
                                         SDAmounts);

            {Add all the roll totals for this parcel. Note that for roll section 9, this will be none.}

          CalculateHstdAndNonhstdAmounts(TaxRollYr, DestSwisSBLKey,
                                         _AssessmentTable, _ClassTable,
                                         _ParcelTable,
                                         HstdAssessedVal, NonhstdAssessedVal,
                                         HstdLandVal, NonhstdLandVal,
                                         HstdAcres, NonhstdAcres,
                                         AssessmentRecordFound, ClassRecordFound);

            {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                            the parcel table for that.}
            {FXX01222000-1: Fix up omitted roll totals.}

          If (Mode = RollSection9)
            then TempRollSection := '9'
            else TempRollSection := _ParcelTable.FieldByName('RollSection').Text;

            {FXX06132000-1: Need to look at the swis code from the destination list in
                            case they switched.}

          AdjustRollTotalsForParcel(TaxRollYr,
                                    Copy(DestSwisSBLKey, 1, 6),
                                    _ParcelTable.FieldByName('SchoolCode').Text,
                                    _ParcelTable.FieldByName('HomesteadCode').Text,
                                    TempRollSection,
                                    HstdLandVal, NonhstdLandVal,
                                    HstdAssessedVal,
                                    NonhstdAssessedVal,
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

            {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

          AssessedValue := _AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

          GetAuditParcelRec(_ParcelTable, AssessedValue,
                            EXAmounts, NewAuditParcelRec);

          InsertParcelChangeRec(DestSwisSBLKey, TaxRollYr, AuditParcelChangeTable,
                                OrigAuditParcelRec, NewAuditParcelRec, 'A');

            {Insert audit trails for SD and EX.}

          AuditEXChangeList := TList.Create;
          GetAuditEXList(DestSwisSBLKey, TaxRollYr,
                         _ParcelExemptionTable, AuditEXChangeList);
          InsertAuditEXChanges(DestSwisSBLKey, TaxRollYr,
                               AuditEXChangeList, AuditEXChangeTable, 'A');
          FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));

          InsertAuditSDChanges(DestSwisSBLKey, TaxRollYr,
                               _ParcelSDTable, AuditSDChangeTable, 'A');

          ExemptionCodes.Free;
          ExemptionHomesteadCodes.Free;
          ResidentialTypes.Free;
          CountyExemptionAmounts.Free;
          TownExemptionAmounts.Free;
          SchoolExemptionAmounts.Free;
          VillageExemptionAmounts.Free;
          ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
          FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

            {CHG02122000-3: Insert a name\addr audit change record.}
            {FXX04272000-1: Only insert one set (not TY and NY) and had wrong SBL.}

          If (TaxRollYr <> OppositeTaxYear)
            then
              begin
                InitNameAddressRecord(OrigNameAddressRec);
                NewNameAddressRec := GetNameAddressInfo(_ParcelTable);
                InsertNameAddressTraceRecord(DestSwisSBLKey,
                                             OrigNameAddressRec,
                                             NewNameAddressRec);

                  {CHG04272000-1: Add an audit record.}

                with AuditTable do
                  try
                    Insert;
                    FieldByName('TaxRollYr').Text := TaxRollYr;
                    FieldByName('SwisSBLKey').Text := DestSwisSBLKey;
                    FieldByName('Date').AsDateTime := Date;
                    FieldByName('Time').AsDateTime := Now;
                    FieldByName('User').Text := Take(10, GlblUserName);
                    FieldByName('OldValue').Text := 'Created by ' + ConvertModeToStr(Mode) +
                                                    ' ' + SplitMergeNo;
                    Post;
                  except
                  end;

              end;  {If (TaxRollYr <> OppositeTaxYear)}

        end;  {For I := 0 to (DestList.Count - 1) do}

end;  {CopySourceToNewParcels}

{==================================================================}
{========== All of this is to switch parcel IDs ===================}
{==================================================================}
Function ChangeParcelIDOneRecord(    TempTable : TTable;
                                     TableName,
                                     OldSwisSBLKey,
                                     NewSwisSBLKey : String;
                                     IsYearDependantTable : Boolean;
                                     ProcessingType : Integer;
                                     AssessmentYear : String;
                                     IndexName : String;
                                 var Exists,
                                     Quit : Boolean;
                                 var RecCount : LongInt) : Boolean;

var
  Done, FirstTimeThrough, IsParcelTable, IsNotesTableWithoutIndex : Boolean;
  SBLRec, NewSBLRec : SBLRecord;

begin
  Result := False;
  Done := False;
  FirstTimeThrough := True;
  IsParcelTable := False;
  IsNotesTableWithoutIndex := False;

  If _Compare(TempTable.TableName, NotesTableName, coEqual)
    then
      begin
        TempTable.IndexDefs.Update;

        IsNotesTableWithoutIndex :=  _Compare(TempTable.IndexDefs.Count, 0, coEqual);

      end;  {If _Compare(TempTable.TableName, NotesTableName, coEqual)}

  TempTable.IndexName := IndexName;

  If (TableName = ParcelTableName)
    then
      begin
        IsParcelTable := True;
        SBLRec := ExtractSwisSBLFromSwisSBLKey(OldSwisSBLKey);

        with SBLRec do
          Exists := FindKeyOld(TempTable,
                               ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                                'Block', 'Lot', 'Sublot', 'Suffix'],
                               [AssessmentYear, SwisCode, Section, Subsection,
                                Block, Lot, Sublot, Suffix]);

      end;  {If (TableName = ParcelTableName)}

  If IsParcelTable
    then
      begin
        NewSBLRec := ExtractSwisSBLFromSwisSBLKey(NewSwisSBLKey);
        RecCount := RecCount + 1;

        If Exists
          then
            with TempTable do
              try
                Edit;
                FieldByName('Section').Text := NewSBLRec.Section;
                FieldByName('Subsection').Text := NewSBLRec.Subsection;
                FieldByName('Block').Text := NewSBLRec.Block;
                FieldByName('Lot').Text := NewSBLRec.Lot;
                FieldByName('Sublot').Text := NewSBLRec.Sublot;
                FieldByName('Suffix').Text := NewSBLRec.Suffix;
                FieldByName('SwisCode').Text := NewSBLRec.SwisCode;

                FieldByName('SwisSBLKey').AsString := NewSwisSBLKey;
                FieldByName('PrintKey').AsString := ConvertSBLOnlyToDashDot(Copy(NewSwisSBLKey, 7, 20));
                Post;
              except
                Quit := True;
                MessageDlg('Error posting parcel rec in table ' + TempTable.TableName + #13 +
                           'Parcel ID = ' + OldSwisSBLKey, mtError, [mbOK], 0);
              end;
      end
    else
      repeat
        TempTable.CancelRange;

        If IsYearDependantTable
          then
            begin
              If (ProcessingType = SalesInventory)
                then SetRangeOld(TempTable, ['SwisSBLKey', 'SalesNumber'],
                                 [OldSwisSBLKey, '0'],
                                 [OldSwisSBLKey, '9999'])
                else SetRangeOld(TempTable, ['TaxRollYr', 'SwisSBLKey'],
                                 [AssessmentYear, OldSwisSBLKey],
                                 [AssessmentYear, OldSwisSBLKey]);
            end
          else
            If IsNotesTableWithoutIndex
              then _SetFilter(TempTable, 'SwisSBLKey = ' + FormatFilterString(OldSwisSBLKey))
              else SetRangeOld(TempTable, ['SwisSBLKey'],
                               [OldSwisSBLKey], [OldSwisSBLKey]);

        If FirstTimeThrough
          then FirstTimeThrough := False
          else TempTable.First;

        If TempTable.EOF
          then Done := True;

        If not Done
          then
            with TempTable do
              try
                RecCount := RecCount + 1;
                Edit;
                TempTable.FieldByName('SwisSBLKey').Text := NewSwisSBLKey;
                Post;
              except
                Quit := True;
                MessageDlg('Error posting record for table ' + TempTable.TableName + #13 +
                           'Parcel ID = ' + OldSwisSBLKey, mtError, [mbOK], 0);
              end;

      until Done;

end;  {ChangeParcelIDOneRecord}

{==================================================================}
Procedure ConvertParcelID_OneProcessingType(    TempTable : TTable;
                                                TableName,
                                                OldSwisSBLKey,
                                                NewSwisSBLKey : String;
                                                IsYearDependantTable : Boolean;
                                                ProcessingType : Integer;
                                                AssessmentYear : String;
                                            var Quit : Boolean);

var
  Exists : Boolean;
  TempIndexName, TempStr : String;
  FileRecCount : LongInt;

begin
  FileRecCount := 0;

  case ProcessingType of
    ThisYear : TempStr := 'This Year';
    NextYear : TempStr := 'Next Year';
    History : TempStr := 'History';
    SalesInventory : TempStr := 'Sales Inventory';
  end;

(*  FileLabel.Caption := TableName + ' ' + TempStr;*)

  If IsYearDependantTable
    then
      begin
        If (ProcessingType = SalesInventory)
          then TempIndexName := 'BySwisSBLKey_SalesNumber'
          else TempIndexName := 'ByTaxRollYr_SwisSBLKey';
      end
    else TempIndexName := 'BySwisSBLKey';

  TempTable.IndexName := '';
  OpenTableForProcessingType(TempTable, TableName, ProcessingType, Quit);

  ChangeParcelIDOneRecord(TempTable, TableName,
                          OldSwisSBLKey, NewSwisSBLKey,
                          IsYearDependantTable,
                          ProcessingType,
                          AssessmentYear,
                          TempIndexName,
                          Exists, Quit, FileRecCount);

  Application.ProcessMessages;

end;  {ConvertParcelID_OneProcessingType}

{===============================================================}
Procedure ChangeParcelIDOneFile(    TempTable : TTable;
                                    TableName,
                                    OldSwisSBLKey,
                                    NewSwisSBLKey : String;
                                    HistoryYearsList : TStringList;
                                    InventoryTable : Boolean;
                                var Quit : Boolean);

var
  IsYearDependantTable : Boolean;
  I : Integer;

begin
  IsYearDependantTable := not ((TableName = SalesTableName) or
                               (TableName = NotesTableName) or
                               (TableName = ExemptionsRemovedTableName) or
                               (TableName = PictureTableName) or
                               (TableName = DocumentTableName) or
                               (TableName = ThirdPartyNotificationTableName) or
                               _Compare(TableName, 'g', coStartsWith));  {No grievance tables.}

  If ((_Compare(GlblProcessingType, NextYear, coEqual) and
       GlblModifyBothYears) or
      _Compare(GlblProcessingType, ThisYear, coEqual))
  then
  ConvertParcelID_OneProcessingType(TempTable, TableName,
                                         OldSwisSBLKey, NewSwisSBLKey,
                                         IsYearDependantTable,
                                         ThisYear, GlblThisYear, Quit);

  If IsYearDependantTable
    then
      begin
        If ((_Compare(GlblProcessingType, ThisYear, coEqual) and
             GlblModifyBothYears) or
            _Compare(GlblProcessingType, NextYear, coEqual))
        then ConvertParcelID_OneProcessingType(TempTable, TableName,
                                               OldSwisSBLKey, NewSwisSBLKey,
                                               IsYearDependantTable,
                                               NextYear, GlblNextYear, Quit);

        For I := 0 to (HistoryYearsList.Count - 1) do
          ConvertParcelID_OneProcessingType(TempTable, TableName,
                                            OldSwisSBLKey, NewSwisSBLKey,
                                            IsYearDependantTable,
                                            History, HistoryYearsList[I], Quit);

        If InventoryTable
          then ConvertParcelID_OneProcessingType(TempTable, TableName,
                                                 OldSwisSBLKey, NewSwisSBLKey,
                                                 IsYearDependantTable,
                                                 SalesInventory, '', Quit);

      end;  {If IsYearDependantTable}

end;  {ChangeParcelIDOneFile}

{===============================================================}
Procedure ConvertParcelID(OldSwisSBLKey,
                          NewSwisSBLKey : String;
                          TempTable : TTable;
                          HistoryYearsList : TStringList;
                          Mode : Integer);

var
  Quit : Boolean;

begin
  Quit := False;

  ChangeParcelIDOneFile(TempTable, ParcelTableName,
                        OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, AssessmentTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, ClassTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, SpecialDistrictTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, ExemptionsTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, ResidentialSiteTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, True, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, ResidentialBldgTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, True, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, ResidentialForestTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, True, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, ResidentialLandTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, True, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, ResidentialImprovementsTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, True, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, CommercialSiteTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, True, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, CommercialBldgTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, True, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, CommercialLandTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, True, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, CommercialImprovementsTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, True, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, CommercialIncomeExpenseTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, True, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, CommercialRentTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, True, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, SalesTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, NotesTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, AssessmentNotesTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, AssessmentLetterTextTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, ExemptionsRemovedTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, PictureTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, DocumentTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  If not Quit
    then ChangeParcelIDOneFile(TempTable, ThirdPartyNotificationTableName,
                               OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    {FXX12272010(2.26.1.26)[I]: Make sure that SBL change extends to grievance info.}

  If ((not Quit) and
      _Compare(Mode, SBLChange, coEqual))
  then
  begin
    ChangeParcelIDOneFile(TempTable, GrievanceTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, GrievanceResultsTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, GrievanceExemptionsAskedTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, GrievanceAuditTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, GrievanceDocumentTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, GrievanceLettersTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, GrievanceParcelExemptionTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, GrievanceParcelSpecialDistrictTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, GrievanceBOARDetailsTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, CertiorariTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, CertiorariAppraisalsTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, CertiorariCalenderTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, CertiorariDocumentsTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, CertiorariExemptionsAskedTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, CertiorariLettersSentTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, CertiorariNotesTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, CertiorariParcelExemptionsTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, CertiorariParcelSalesTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, CertiorariParcelSpecialDistrictsTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, SmallClaimsTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, SmallClaimsAppraisalsTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, SmallClaimsCalenderTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, SmallClaimsDocumentsTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, SmallClaimsExemptionsAskedTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, SmallClaimsNotesTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, SmallClaimsParcelExemptionsTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, SmallClaimsParcelSalesTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

    ChangeParcelIDOneFile(TempTable, SmallClaimsParcelSpecialDistrictsTableName,
                          OldSwisSBLKey, NewSwisSBLKey, HistoryYearsList, False, Quit);

  end;  {If _Compare(Mode, SBLChange, coEqual)}

end;  {ConvertParcelIDs}

{=====================================================================}
Procedure TKeyChangeForm.SwitchOrConvertTheParcelIDs(    ParcelID1 : String;
                                                         ParcelID2 : String;
                                                         ActionMode : Char;  {(S)witch or (C)onvert}
                                                         bConvertHistory : Boolean;
                                                     var Quit : Boolean);

var
  HistoryYearsList : TStringList;
  TemporaryParcelID : String;
  AssessmentYearCtlTable : TTable;
  Done, FirstTimeThrough : Boolean;

begin
  HistoryYearsList := TStringList.Create;

  If bConvertHistory
  then
  begin
    AssessmentYearCtlTable := PASDataModule.HistoryAssessmentYearControlTable;
    AssessmentYearCtlTable.First;

    Done := False;
    FirstTimeThrough := True;

    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else AssessmentYearCtlTable.Next;

      If AssessmentYearCtlTable.EOF
        then Done := True;

      If not Done
        then HistoryYearsList.Add(AssessmentYearCtlTable.FieldByName('TaxRollYr').Text);

    until Done;

  end;  {If bConvertHistory}

  case ActionMode of
    'C' : ConvertParcelID(ParcelID1, ParcelID2, DestTable, HistoryYearsList, Mode);

    'S' : begin
            TemporaryParcelID := Copy(ParcelID1, 1, 6) + '12345678901234567890';

            ConvertParcelID(ParcelID1, TemporaryParcelID, DestTable, HistoryYearsList, Mode);
            ConvertParcelID(ParcelID2, ParcelID1, DestTable, HistoryYearsList, Mode);
            ConvertParcelID(TemporaryParcelID, ParcelID2, DestTable, HistoryYearsList, Mode);

          end;

  end;  {case ActionMode of}

  HistoryYearsList.Free;

end;  {SwitchOrConvertTheParcelID}

{==================================================================}
{========== All of this was to switch parcel IDs ==================}
{==================================================================}

{=====================================================================}
Procedure TKeyChangeForm.SetParentParcelRelationship(    SourceParcelID,
                                                         ChildParcelID,
                                                         SplitMergeNo : String;
                                                         TaxRollYr : String;
                                                         ParcelTable : TTable;
                                                     var Quit : Boolean);

{Make this parcel a parent and set the child related SBL.}
{CHG02261998-1: Pass in the parcel table so can do dual processing.}

var
  FoundRec : Boolean;
  SwisSBLRec : SBLRecord;

begin
  try
    SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(SourceParcelID);

    with SwisSBLRec do
      FoundRec := FindKeyOld(ParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot', 'Sublot',
                              'Suffix'],
                             [TaxRollYr, SwisCode, Section, Subsection,
                              Block, Lot, Sublot, Suffix]);

    If FoundRec
      then
        begin
          ParcelTable.Edit;

          ParcelTable.FieldByName('RelatedSBL').Text := ChildParcelID;
          ParcelTable.FieldByName('SBLRelationship').Text := 'P';

            {FXX02171999-4: Do not mark the NY parcel with split merge #.}

          If (TaxRollYr <> OppositeTaxYear)
            then ParcelTable.FieldByName('SplitMergeNo').Text := SplitMergeNo;

          ParcelTable.Post;

        end  {If FoundRec}
      else
        begin
          Quit := True;
          MessageDlg('Unable to find parcel record to set relationship.', mtError,
                     [mbOK], 0);
        end;

  except
    Quit := True;
    MessageDlg('Error trying to set parcel relationship.', mtError, [mbOK], 0);
  end;

end;  {SetParentParcelRelationship}

{============================================================}
Procedure TKeyChangeForm.MarkSourceParcelsInactive(SourceList,
                                                   DestList,
                                                   DestExistsList : TStringList;
                                                   TaxRollYr : String;
                                                   ParcelTable : TTable;
                                                   SplitMergeNo : String);

{Mark the source parcel inactive and delete the roll totals.}
{CHG02261998-1: Allow for dual processing mode.}

var
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  SDAmounts : TList;
  BasicSTARAmount, EnhancedSTARAmount,
  HstdAssessedVal, NonhstdAssessedVal,
  HstdLandVal, NonhstdLandVal, AssessedValue : Comp;
  HstdAcres, NonhstdAcres : Real;
  I : Integer;
  FoundRec, AssessmentRecordFound, ClassRecordFound : Boolean;
  _ParcelTable, _ParcelExemptionTable, _EXCodeTable,
  _AssessmentTable, _ParcelSDTable, _SDCodeTable, _ClassTable : TTable;
  EXAmounts : ExemptionTotalsArrayType;
  SwisSBLKey : String;
  AuditEXChangeList : TList;
  OrigAuditParcelRec, NewAuditParcelRec : AuditParcelRecord;
  SwisSBLRec : SBLRecord;

begin
  StatusPanel.Caption := 'Marking source parcel(s) inactive.';
  StatusPanel.Repaint;

    {Do not mark parcels that are also in the destination list inactive.}

  For I := 0 to (SourceList.Count - 1) do
    If (DestList.IndexOf(SourceList[I]) = -1)
      then
        begin
            {CHG02261998-1: Adjust roll totals for opposite year if they are in
                            dual processing mode.}

          If (TaxRollYr = OppositeTaxYear)
            then
              begin
                _ParcelTable := OppositeYearParcelTable;
                _ParcelExemptionTable := OppositeYearParcelExemptionTable;
                _EXCodeTable := OppositeYearEXCodeTable;
                _AssessmentTable := OppositeYearAssessmentTable;
                _ParcelSDTable := OppositeYearParcelSDTable;
                _SDCodeTable := OppositeYearSDCodeTable;
                _ClassTable := OppositeYearClassTable;
             end
            else
              begin
                _ParcelTable := ParcelTable;
                _ParcelExemptionTable := ParcelExemptionTable;
                _EXCodeTable := EXCodeTable;
                _AssessmentTable := AssessmentTable;
                _ParcelSDTable := ParcelSDTable;
                _SDCodeTable := SDCodeTable;
                _ClassTable := ClassTable;

              end;  {else of If (TaxRollYr = OppositeTaxYear)}

            {FXX06052001-1: We need to reaccess the parcel based on the parcel ID to
                            inactivate.}

          SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(SourceList[I]);

          with SwisSBLRec do
            FoundRec := FindKeyOld(_ParcelTable,
                                   ['TaxRollYr', 'SwisCode', 'Section',
                                    'Subsection', 'Block', 'Lot',
                                    'Sublot', 'Suffix'],
                                   [TaxRollYr, SwisCode, Section, Subsection,
                                    Block, Lot, Sublot, Suffix]);

          If not FoundRec
            then SystemSupport(098, _ParcelTable, 'Error locating parcel for roll total adjustment in inactivate.',
                               UnitName, GlblErrorDlgBox);

          FindKeyOld(_AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                     [TaxRollYr, SourceList[I]]);

            {Now add in the roll totals for this new parcel.}

          ExemptionCodes := TStringList.Create;
          ExemptionHomesteadCodes := TStringList.Create;
          ResidentialTypes := TStringList.Create;
          CountyExemptionAmounts := TStringList.Create;
          TownExemptionAmounts := TStringList.Create;
          SchoolExemptionAmounts := TStringList.Create;
          VillageExemptionAmounts := TStringList.Create;
          SDAmounts := TList.Create;

            {Now figure out the  exemption totals.}
            {CHG12011997-2: STAR support}
            {FXX02091998-1: Pass the residential type of each exemption.}

          ExAmounts := TotalExemptionsForParcel(TaxRollYr, SourceList[I],
                                    _ParcelExemptionTable,
                                    _EXCodeTable,
                                    _ParcelTable.FieldByName('HomesteadCode').Text,
                                    'A',
                                    ExemptionCodes,
                                    ExemptionHomesteadCodes,
                                    ResidentialTypes,
                                    CountyExemptionAmounts,
                                    TownExemptionAmounts,
                                    SchoolExemptionAmounts,
                                    VillageExemptionAmounts,
                                    BasicSTARAmount, EnhancedSTARAmount);

            {The special district amounts may have changed, so
             calculate the  special district amounts, too.}

          TotalSpecialDistrictsForParcel(TaxRollYr,
                                         SourceList[I],
                                         _ParcelTable,
                                         _AssessmentTable,
                                         _ParcelSDTable,
                                         _SDCodeTable,
                                         _ParcelExemptionTable,
                                         _EXCodeTable,
                                         SDAmounts);

            {Delete all the old roll totals for this parcel.}

          CalculateHstdAndNonhstdAmounts(TaxRollYr, SourceList[I],
                                         _AssessmentTable, _ClassTable,
                                         _ParcelTable,
                                         HstdAssessedVal, NonhstdAssessedVal,
                                         HstdLandVal, NonhstdLandVal,
                                         HstdAcres, NonhstdAcres,
                                         AssessmentRecordFound, ClassRecordFound);

            {FXX09291999-2: Need to make sure the AssessedValue and EXAmounts vars
                            are initialized.}

          AssessedValue := _AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;
          GetAuditParcelRec(_ParcelTable, AssessedValue,
                            EXAmounts, OrigAuditParcelRec);

          MarkParcelInactive(_ParcelTable, TaxRollYr, SourceList[I]);

            {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                            the parcel table for that.}

          AdjustRollTotalsForParcel(TaxRollYr,
                                    _ParcelTable.FieldByName('SwisCode').Text,
                                    _ParcelTable.FieldByName('SchoolCode').Text,
                                    _ParcelTable.FieldByName('HomesteadCode').Text,
                                    _ParcelTable.FieldByName('RollSection').Text,
                                    HstdLandVal, NonhstdLandVal,
                                    HstdAssessedVal,
                                    NonhstdAssessedVal,
                                    ExemptionCodes,
                                    ExemptionHomesteadCodes,
                                    CountyExemptionAmounts,
                                    TownExemptionAmounts,
                                    SchoolExemptionAmounts,
                                    VillageExemptionAmounts,
                                    _ParcelTable,
                                    BasicSTARAmount, EnhancedSTARAmount,
                                    SDAmounts,
                                    ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                                    'D');  {Delete the totals.}

            {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

          SwisSBLKey := SourceList[I];

          GetAuditParcelRec(_ParcelTable, AssessedValue,
                            EXAmounts, NewAuditParcelRec);

            {FXX08201999-1: Putting in parcel add record instead of delete.}

          InsertParcelChangeRec(SwisSBLKey, TaxRollYr, AuditParcelChangeTable,
                                OrigAuditParcelRec, NewAuditParcelRec, 'D');

            {Insert audit trails for SD and EX.}

          AuditEXChangeList := TList.Create;
          GetAuditEXList(SwisSBLKey, TaxRollYr,
                         _ParcelExemptionTable, AuditEXChangeList);
          InsertAuditEXChanges(SwisSBLKey, TaxRollYr,
                               AuditEXChangeList, AuditEXChangeTable, 'B');
          FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));

          InsertAuditSDChanges(SwisSBLKey, TaxRollYr,
                               _ParcelSDTable, AuditSDChangeTable, 'D');

          ExemptionCodes.Free;
          ExemptionHomesteadCodes.Free;
          ResidentialTypes.Free;
          CountyExemptionAmounts.Free;
          TownExemptionAmounts.Free;
          SchoolExemptionAmounts.Free;
          VillageExemptionAmounts.Free;
          ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
          FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

          If (TaxRollYr <> OppositeTaxYear)
            then
              begin
                  {CHG04272000-1: Add an audit record.}

                with AuditTable do
                  try
                    Insert;
                    FieldByName('TaxRollYr').Text := TaxRollYr;
                    FieldByName('SwisSBLKey').Text := SwisSBLKey;
                    FieldByName('Date').AsDateTime := Date;
                    FieldByName('Time').AsDateTime := Now;
                    FieldByName('User').Text := Take(10, GlblUserName);
                    FieldByName('OldValue').Text := 'Inactivated by ' + ConvertModeToStr(Mode) +
                                                    ' ' + SplitMergeNo;
                    Post;
                  except
                  end;

              end;  {If (TaxRollYr <> OppositeTaxYear)}

        end;  {For I := 0 to (SourceList.Count - 1) do}

end;  {MarkSourceParcelsInactive}

{=====================================================================}
Procedure TKeyChangeForm.FillInDestinationList(DestList,
                                               DestExistsList : TStringList;
                                               TaxRollYr : String;
                                               ParcelTable : TTable);

{FXX02161999-1: Allow to spilt\merge into an existing parcel.}

var
  I : Integer;
  ValidEntry : Boolean;
  SwisSBLKey, DestinationPrintKey : String;

begin
  For I := 0 to (DestGrid.RowCount - 1) do
    If _Compare(DestGrid.Cells[0, I], coNotBlank)
      then
        begin
          DestinationPrintKey := DestGrid.Cells[0, I];
          SwisSBLKey := GetSwisSBLFromGridEntry(DestinationPrintKey, ValidEntry);

            {11072006: I am hanging my head on this one, but I am hardcoding a Malverne SBL conversion
             because the underlying data structure is so flawed that there is no
             legitimate way to reverse parse the Malverne SBL.}

          If _Compare(GlblMunicipalityName, 'Malverne', coEqual)
            then SwisSBLKey := GetMalverneSwisSBLFromPrintKey(DestinationPrintKey,
                                                              ParcelTable.FieldByName('SwisCode').AsString);

          DestList.Add(SwisSBLKey);

          If _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey])
            then DestExistsList.Add('Y')
            else DestExistsList.Add('N');

        end;  {If (Deblank(DestGrid.Cells[0, I]) <> '')}

end;  {FillInDestinationList}

{=====================================================================}
Procedure TKeyChangeForm.SaveSplitMergeAudit(SourceList,
                                             DestList,
                                             DestExistsList : TStringList;
                                             MarkInactive : Boolean);

{FXX04081999-6: Store this split/merge.}

var
  TempTime : TDateTime;
  I : Integer;
  AssessmentYear : String;
  SBLRec : SBLRecord;

begin
  TempTime := Now;

  If (GlblModifyBothYears or
      (GlblProcessingType = ThisYear))
    then AssessmentYear := GlblThisYear
    else AssessmentYear := GlblNextYear;

  with SplitMergeHdrTable do
    try
      Insert;

      FieldByName('Date').AsDateTime := Date;
      FieldByName('Time').AsDateTime := TempTime;
      FieldByName('SplitMergeNo').Text := SplitMergeNoEdit.Text;
      FieldByName('CopyInventory').AsBoolean := CopyInventoryCheckBox.Checked;
      FieldByName('Printed').AsBoolean := SplitMergePrinted;
      FieldByName('Mode').AsInteger := Mode;
      FieldByName('SourceParcelInactive').AsBoolean := MarkInactive;

      If GlblModifyBothYears
        then FieldByName('ProcessingYears').AsInteger := BothYears  {Both years}
        else FieldByName('ProcessingYears').AsInteger := GlblProcessingType;

      Post;
    except
      SystemSupport(050, SplitMergeHdrTable, 'Error inserting split\merge hdr record.',
                    UnitName, GlblErrorDlgBox);
    end;

    {Now fill in the source details.}

  For I := 0 to (SourceList.Count - 1) do
    with SplitMergeDtlTable do
      try
        Insert;

        FieldByName('Date').AsDateTime := Date;
        FieldByName('Time').AsDateTime := TempTime;
        FieldByName('SplitMergeNo').Text := SplitMergeNoEdit.Text;
        FieldByName('SourceOrDest').Text := 'S';
        FieldByName('SwisSBLKey').Text := SourceList[I];
        FieldByName('SBLExists').AsBoolean := True;
        FieldByName('OrderInGrid').AsInteger := I;

          {FXX01272000-1: Need to store owner and legal addr as of split.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(FieldByName('SwisSBLKey').Text);

        with SBLRec do
          FindKeyOld(ParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot',
                      'Suffix'],
                     [AssessmentYear, SwisCode, Section, Subsection,
                      Block, Lot, Sublot, Suffix]);

        FieldByName('Name').Text := ParcelTable.FieldByName('Name1').Text;
        FieldByName('LegalAddress').Text := GetLegalAddressFromTable(ParcelTable);

          {CHG02052005-3(2.8.3.5)[2013]: Show the original and current AV on the split \ merge report.}

        If FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                      [AssessmentYear, FieldByName('SwisSBLKey').Text])
          then
            try
              FieldByName('OriginalAV').AsInteger := AssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
            except
            end;

        Post;
      except
        SystemSupport(051, SplitMergeDtlTable, 'Error inserting split\merge dtl record.',
                      UnitName, GlblErrorDlgBox);
      end;

    {Now fill in the destination details.}

  For I := 0 to (DestList.Count - 1) do
    with SplitMergeDtlTable do
      try
        Insert;

        FieldByName('Date').AsDateTime := Date;
        FieldByName('Time').AsDateTime := TempTime;
        FieldByName('SplitMergeNo').Text := SplitMergeNoEdit.Text;
        FieldByName('SourceOrDest').Text := 'D';
        FieldByName('SwisSBLKey').Text := DestList[I];
        FieldByName('SBLExists').AsBoolean := (DestExistsList[I] = 'Y');
        FieldByName('OrderInGrid').AsInteger := I;

          {FXX01272000-1: Need to store owner and legal addr as of split.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(FieldByName('SwisSBLKey').Text);

        with SBLRec do
          FindKeyOld(ParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot',
                      'Suffix'],
                     [AssessmentYear, SwisCode, Section, Subsection,
                      Block, Lot, Sublot, Suffix]);

        FieldByName('Name').Text := ParcelTable.FieldByName('Name1').Text;
        FieldByName('LegalAddress').Text := GetLegalAddressFromTable(ParcelTable);

        Post;
      except
        SystemSupport(051, SplitMergeDtlTable, 'Error inserting split\merge dtl record.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {SaveSplitMergeAudit}

{=====================================================================}
Procedure TKeyChangeForm.MergeValuesForParcel(SourceList : TStringList;
                                              DestinationList : TStringList;
                                              AssessmentYear : String;
                                              ShowFrontageDepthWarningMessage : Boolean;
                                              AdjustEqualizationChange : Boolean);

{CHG02162005-1(2.8.3.7)[2069]: Add option to merge together the assessed values and
                               dimensions.}

var
  ParcelTable, AssessmentTable : TTable;
  I, ProcessingType : Integer;
  Frontage, Depth, Acreage : Double;
  LandAssessedValue, TotalAssessedValue, EqualizationIncrease : LongInt;
  CurrentTime : TDateTime;
  EXAmounts : ExemptionTotalsArrayType;

begin
  CurrentTime := Now;
  ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);
  ParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                        ProcessingType);

  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                            ProcessingType);

  TotalAssessedValue := 0;
  LandAssessedValue := 0;
  Frontage := 0;
  Depth := 0;
  Acreage := 0;

  For I := 0 to (SourceList.Count - 1) do
    If (_Locate(ParcelTable, [AssessmentYear, SourceList[I]], '', [loParseSwisSBLKey]) and
        _Locate(AssessmentTable, [AssessmentYear, SourceList[I]], '', []))
      then
        begin
          with ParcelTable do
            try
              Frontage := Frontage + FieldByName('Frontage').AsFloat;
              Depth := Depth + FieldByName('Depth').AsFloat;
              Acreage := Acreage + FieldByName('Acreage').AsFloat;
            except
            end;

          with AssessmentTable do
            try
              LandAssessedValue := LandAssessedValue + FieldByName('LandAssessedVal').AsInteger;
              TotalAssessedValue := TotalAssessedValue + FieldByName('TotalAssessedVal').AsInteger;
            except
            end;

        end;  {If (_Locate(ParcelTable ...}

    If (_Locate(ParcelTable, [AssessmentYear, DestinationList[0]], '', [loParseSwisSBLKey]) and
        _Locate(AssessmentTable, [AssessmentYear, DestinationList[0]], '', []))
      then
        begin
          with ParcelTable do
            try
              (*AddToTraceFile(DestinationList[0],
                             BaseInformationScreenName, 'Frontage',
                             FieldByName('Frontage').Text, FloatToStr(Frontage),
                             CurrentTime, ParcelTable);

              AddToTraceFile(DestinationList[0],
                             BaseInformationScreenName, 'Depth',
                             FieldByName('Depth').Text, FloatToStr(Depth),
                             CurrentTime, ParcelTable);*)

              AddToTraceFile(DestinationList[0],
                             BaseInformationScreenName, 'Acreage',
                             FieldByName('Acreage').Text, FloatToStr(Acreage),
                             CurrentTime, ParcelTable);

              Edit;
              (*FieldByName('Frontage').AsFloat := Frontage;
              FieldByName('Depth').AsFloat := Depth;*)
              FieldByName('Acreage').AsFloat := Acreage;
              Post;
            except
            end;

          If (ShowFrontageDepthWarningMessage and
              ((Frontage > 0) or
               (Depth > 0)))
            then MessageDlg('This parcel has frontage \ depth dimensions.' + #13 +
                            'Please update the dimensions manually.', mtWarning, [mbOK], 0);

          with AssessmentTable do
            try
              EqualizationIncrease := FieldByName('TotalAssessedVal').AsInteger - TotalAssessedValue;

              AddToTraceFile(DestinationList[0],
                             AssessmentScreenName, 'Land Assessed Val',
                             FieldByName('LandAssessedVal').Text, IntToStr(LandAssessedValue),
                             CurrentTime, AssessmentTable);

              AddToTraceFile(DestinationList[0],
                             AssessmentScreenName, 'Total Assessed Val',
                             FieldByName('TotalAssessedVal').Text, IntToStr(EqualizationIncrease),
                             CurrentTime, AssessmentTable);

              AddToTraceFile(DestinationList[0],
                             AssessmentScreenName, 'Increase For Equal',
                             FieldByName('IncreaseForEqual').Text, IntToStr(TotalAssessedValue),
                             CurrentTime, AssessmentTable);

              AdjustRollTotalsForParcel_New(AssessmentYear, ProcessingType,
                                            DestinationList[0], EXAmounts,
                                            ['S', 'C', 'E', 'D'], 'D');
              Edit;
              FieldByName('LandAssessedVal').AsInteger := LandAssessedValue;
              FieldByName('TotalAssessedVal').AsInteger := TotalAssessedValue;

              If AdjustEqualizationChange
                then FieldByName('IncreaseForEqual').AsInteger := FieldByName('IncreaseForEqual').AsInteger + EqualizationIncrease;

              Post;

              AdjustRollTotalsForParcel_New(AssessmentYear, ProcessingType,
                                            DestinationList[0], EXAmounts,
                                            ['S', 'C', 'E', 'D'], 'A');

            except
            end;

        end;  {If (_Locate(ParcelTable ...}

end;  {MergeValuesForParcel}

{=====================================================================}
Function TKeyChangeForm.GetSwisSBLFromGridEntry(    GridEntry : String;
                                                var ValidEntry : Boolean) : String;

var
  TempIndex : String;

begin
  Result := '';
  ValidEntry := True;

  with ParcelTable do
    begin
      TempIndex := IndexName;

      case GridEntryMethod of
(*        gemAccountNumber :
          begin
            IndexName := 'BYACCOUNTNO';
            If _Locate(tb_ParcelByAccountNumber, [GridEntry], '', [])
              then Result := ExtractSSKey(ParcelTable)
              else ValidEntry := False;

          end;  {gemAccountNumber} *)

        gemSBL :
          begin
            Result := ConvertSwisDashDotToSwisSBL(GridEntry, SwisCodeTable, ValidEntry);

            If _Compare(GlblMunicipalityName, 'Malverne', coEqual)
              then Result := GetMalverneSwisSBLFromPrintKey(GridEntry,
                                                            ParcelTable.FieldByName('SwisCode').AsString);

          end;  {gemSBL}

        gemPrintKey :
          begin
            IndexName := 'BYPRINTKEY';
            If _Locate(ParcelTable, [GridEntry], '', [])
              then Result := ExtractSSKey(ParcelTable)
              else
              begin
                Result := ConvertSwisDashDotToSwisSBL(GridEntry, SwisCodeTable, ValidEntry);
                ValidEntry := False;
              end;

          end;  {gemPrintKey}

      end;  {gemPrintKey}

      IndexName := TempIndex;

    end;  {with ParcelTable do}

end;  {GetSwisSBLFromGridEntry}

{=====================================================================}
Procedure TKeyChangeForm.OKButtonClick(Sender: TObject);

{Perform the action that they have requested.}

var
  I, ReturnCode : Integer;
  SourceList,  {For merge only}
  DestList, DestExistsList : TStringList;
  Cancelled, Quit, ValidEntry, MarkInactive,
  SplitMergeCopyOrSBLChangeDone, CanSelect,
  MergeValues, Continue, bConvertHistory : Boolean;
  SourceParcelID, YearsOfExistenceString,
  ExString, TempStr, ParcelID1, ParcelID2 : String;
  SplitMergeNo : Integer;
  AssessmentYears, YearsOfExistence, ExemptionList : TStringList;

begin
  DestList := nil;
  DestExistsList := nil;
  MarkInactive := False;
  DisplayClassifiedParcelWarning := False;
(*  GridEntryMethod := rg_GridEntryMethod.ItemIndex; *)
    {FXX02032000-2: As a double check, check for existence of the parcel again.}

  DestGridSelectCell(Sender, 0, 0, CanSelect);

  If CanSelect
    then
      begin
        SplitMergeCancelledInPrint := False;

          {FXX08181000-4: Need to reset flag so asks print on 2nd and greater s\m.}

        SplitMergePrinted := False;

          {FXX02091999-1: Allow them to accept an out of order split\merge #.}
          {FXX02281999-2: Get '   ' is not a valid integer when do rs 9 - there
                          is no split merge for rs 9.}
          {CHG12112002-2: Allow 2 parcels to be completely switched.}

        If ((Mode <> RollSection9) and
            (Mode <> SwitchParcels))
          then
            begin
              SplitMergeNo := StrToInt(SplitMergeNoEdit.Text);

              If ((SplitMergeNoEdit.Text <> '99999999') and
                  (SplitMergeNoEdit.Text <> '99998888') and
                  (SplitMergeNo <> NextSplitMergeNo))
                then MessageDlg('Warning! The split\merge number you entered is out of sequence.',
                                mtWarning, [mbOK], 0);

            end;  {If (Mode <> RollSection9)}

          {If they have not printed this split\merge, then let's
           give them a chance before they lose the info.}

        If not SplitMergePrinted
          then
            begin
              ReturnCode := MessageDlg('Do you want to print this ' + ConvertModeToStr(Mode) +
                                       '?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);

              case ReturnCode of
                idYes : PrintButtonClick(Sender);
                idCancel : SplitMergeCancelledInPrint := True;
              end;

            end;  {If not SplitMergePrinted}

          {CHG07211999-1: Allow copying of inventory to 1st parcel or all.}

        InventoryCopyMode := invCopyNone;
        Cancelled := False;

        If (Mode = SBLChange)
          then InventoryCopyMode := invCopyAll  {Force inv copy in SBL change.}
          else
            If CopyInventoryCheckBox.Checked
              then
                begin
                  ReturnCode := MessageDlg('Do you want to copy inventory to only the first destination parcel?',
                                           mtConfirmation, [mbYes, mbNo, mbCancel], 0);

                  case ReturnCode of
                    idYes : InventoryCopyMode := invCopyToFirst;
                    idNo : InventoryCopyMode := invCopyAll;
                    idCancel : Cancelled := True;

                  end;  {case ReurnCode of}

                end;  {If CopyInventoryCheckBox.Checked}

          {CHG10152004-1(2.8.0.14): Allow copying of pictures to 1st parcel or all.}

        PictureCopyMode := picCopyNone;

        If (Mode = SBLChange)
          then PictureCopyMode := picCopyAll  {Force pic copy in SBL change.}
          else
            If CopyPicturesCheckBox.Checked
              then
                begin
                  ReturnCode := MessageDlg('Do you want to copy the pictures to only the first destination parcel?',
                                           mtConfirmation, [mbYes, mbNo, mbCancel], 0);

                  case ReturnCode of
                    idYes : PictureCopyMode := picCopyToFirst;
                    idNo : PictureCopyMode := picCopyAll;
                    idCancel : Cancelled := True;

                  end;  {case ReurnCode of}

                end;  {If CopyPictureCheckBox.Checked}

      end
    else Cancelled := True;

  If not (SplitMergeCancelledInPrint or Cancelled)
    then
      begin
        SplitMergeCopyOrSBLChangeDone := False;
        Quit := False;

          {CHG03302000-1: Add create parcel list to split merge.}

        CreateParcelList := CreateParcelListCheckBox.Checked;
        If CreateParcelList
          then ParcelListDialog.ClearParcelGrid(True);

        case Mode of
          Split :
            begin
                 {First, let's make sure that they have entries in both the source and destination
                  grids.}

              If ((NumEntriesInGridCol(SourceGrid, 0) = 0) or
                  (NumEntriesInGridCol(DestGrid, 0) = 0))
                then
                  begin
                    If (NumEntriesInGridCol(SourceGrid, 0) = 0)
                      then
                        begin
                          MessageDlg('Please enter the source parcel ID(s).', mtError, [mbOK], 0);
                          SourceGrid.SetFocus;
                        end
                      else
                        begin
                          MessageDlg('Please enter the new parcel ID(s).', mtError, [mbOK], 0);
                          DestGrid.SetFocus;
                        end;  {else of If (NumEntries(SourceGrid) = 0)}

                  end
                else
                  begin
                    Quit := False;
                    MarkInactive := (MessageDlg('Do you want to mark the original parcel(s) inactive?' + #13 +
                                                'Please note that any parcels in both the source and' + #13 +
                                                'destination list will not be marked inactive.', mtConfirmation,
                                                [mbYes, mbNo], 0) = idYes);
                    StatusPanel.Visible := True;

                       {They have entries in both grids, so let's copy the original parcel.}

                    SourceParcelID := GetSwisSBLFromGridEntry(SourceGrid.Cells[0,0], ValidEntry);

                      {FXX02161999-1: Allow to spilt\merge into an existing
                                      parcel.}

                    DestList := TStringList.Create;
                    DestExistsList := TStringList.Create;
                    FillInDestinationList(DestList, DestExistsList, TaxRollYr, ParcelTable);

                      {If we successfully split, then mark the originals inactive.}

                    SourceList := TStringList.Create;
                    For I := 0 to (SourceGrid.RowCount - 1) do
                      If _Compare(SourceGrid.Cells[0, I], coNotBlank)
                        then SourceList.Add(GetSwisSBLFromGridEntry(SourceGrid.Cells[0, I], ValidEntry));

                    If not Quit
                      then
                        begin
                          CopySourceToNewParcels(SourceParcelID,
                                                 SourceList,
                                                 DestList, DestExistsList,
                                                 False,
                                                 SplitMergeNoEdit.Text, Mode,
                                                 ProcessingType,
                                                 TaxRollYr, Quit);

                            {If they want to mark the source parcel(s) inactive, do it.
                             Also, take out the roll totals for this parcel.}
                           {FXX02161999-1: Allow to spilt\merge into an existing
                                           parcel.}


                          If MarkInactive
                            then MarkSourceParcelsInactive(SourceList, DestList,
                                                           DestExistsList,
                                                           TaxRollYr,
                                                           ParcelTable,
                                                           SplitMergeNoEdit.Text);

                            {Also, make the original parcel the parent and fill in the
                             related SBL of the first child (i.e. destination).}

                          StatusPanel.Caption := 'Marking source parcel(s) as parent.';
                          StatusPanel.Repaint;

                        end;  {If not Quit}

                    If not Quit
                      then
                        For I := 0 to (SourceList.Count - 1) do
                          SetParentParcelRelationship(SourceList[I], DestGrid.Cells[0, 0],
                                                      SplitMergeNoEdit.Text,
                                                      TaxRollYr,
                                                      ParcelTable, Quit);

                      {FXX04081999-6: Store this split/merge.}

                    If not Quit
                      then SaveSplitMergeAudit(SourceList, DestList, DestExistsList,
                                               MarkInactive);

                      {CHG02261998-1: Add dual modify mode to split/merge.}

                    If GlblModifyBothYears
                      then
                        begin
                            {FXX02161999-1: Allow to spilt\merge into an existing
                                            parcel.}

                          DestList.Clear;
                          DestExistsList.Clear;
                          FillInDestinationList(DestList, DestExistsList, OppositeTaxYear,
                                                OppositeYearParcelTable);

                          If not Quit
                            then
                              begin
                                CopySourceToNewParcels(SourceParcelID,
                                                       SourceList,
                                                       DestList,
                                                       DestExistsList,
                                                       False,
                                                       SplitMergeNoEdit.Text, Mode,
                                                       OppositeYearProcessingType,
                                                       OppositeTaxYear, Quit);

                                  {If they want to mark the source parcel(s) inactive, do it.
                                   Also, take out the roll totals for this parcel.}
                                  {FXX02161999-1: Allow to spilt\merge into an existing
                                                  parcel.}


                                If MarkInactive
                                  then MarkSourceParcelsInactive(SourceList, DestList,
                                                                 DestExistsList,
                                                                 OppositeTaxYear,
                                                                 OppositeYearParcelTable,
                                                                 SplitMergeNoEdit.Text);

                                  {Also, make the original parcel the parent and fill in the
                                   related SBL of the first child (i.e. destination).}

                                StatusPanel.Caption := 'Marking source parcel(s) as parent.';
                                StatusPanel.Repaint;

                              end;  {If not Quit}

                          If not Quit
                            then
                              For I := 0 to (SourceList.Count - 1) do
                                SetParentParcelRelationship(SourceList[I], DestGrid.Cells[0, 0],
                                                            SplitMergeNoEdit.Text,
                                                            OppositeTaxYear,
                                                            OppositeYearParcelTable,
                                                            Quit);

                        end;  {If GlblModifyBothYears}

                    SourceList.Free;
                    DestList.Free;
                    DestExistsList.Free;

                    If Quit
                      then MessageDlg('The parcel was not split successfully.', mtError, [mbOK], 0)
                      else
                        begin
                          SplitMergeCopyOrSBLChangeDone := True;

                          If MarkInactive
                            then TempStr := 'Please note that the source parcel(s) are now inactive.'
                            else TempStr := 'Please note that the source parcel(s) are still active.';

                          MessageDlg('The parcel was split successfully.' + #13 + TempStr,
                                     mtInformation, [mbOK], 0);

                            {FXX02191999-5: Warn the user to check source exemptions,
                                            if there are any.}

                          ExemptionList := TStringList.Create;
                          GetExemptionCodesForParcel(TaxRollYr, SourceParcelID,
                                                     ParcelExemptionTable, ExemptionList);

                          If ((ExemptionList.Count > 0) and
                              (not MarkInactive))
                            then
                              begin
                                ExString := '';

                                For I := 0 to (ExemptionList.Count - 1) do
                                  begin
                                    ExString := ExString + ExemptionList[I];

                                    If (I < (ExemptionList.Count - 1))
                                      then ExString := ExString + ',';

                                  end;  {For I := 1 to ExIdx do}

                                MessageDlg('Warning: The following exemption(s) assigned to' + #13 +
                                           'this parcel require review for continued  ' + #13 +
                                           'applicability as a result of this split\merge:' + #13 + #13 +
                                           ExString, mtWarning, [mbOK], 0);

                              end;  {If (ExIdx > 1)}

                          ExemptionList.Free;

                        end;  {else of If Quit}

                  end;  {If (NumEntriesInGrid(SourceGrid) = 0) and ...}

              StatusPanel.Visible := False;

            end;  {Split}

          Merge :
            begin
                 {First, let's make sure that they have entries in both the source and destination
                  grids.}

              If ((NumEntriesInGridCol(SourceGrid, 0) = 0) or
                  (NumEntriesInGridCol(DestGrid, 0) = 0))
                then
                  begin
                    If (NumEntriesInGridCol(SourceGrid, 0) = 0)
                      then
                        begin
                          MessageDlg('Please enter the source parcel ID(s).', mtError, [mbOK], 0);
                          SourceGrid.SetFocus;
                        end
                      else
                        begin
                          MessageDlg('Please enter the new parcel ID.', mtError, [mbOK], 0);
                          DestGrid.SetFocus;
                        end;  {else of If (NumEntries(SourceGrid) = 0)}

                  end
                else
                  begin
                    Quit := False;
                    MarkInactive := (MessageDlg('Do you want to mark the original parcel(s) inactive?' + #13 +
                                                'Please note that any parcels in both the source and' + #13 +
                                                'destination list will not be marked inactive.', mtConfirmation,
                                                [mbYes, mbNo], 0) = idYes);
                    StatusPanel.Visible := True;

                      {CHG02162005-1(2.8.3.7)[]: Add option to merge together the assessed values and
                                                 dimensions.}

                    MergeValues := GlblMergeValuesDuringMerge;
(*                    MergeValues := (MessageDlg('Do you want to merge the land values, total values, and dimensions?',
                                               mtConfirmation, [mbYes, mbNo], 0) = idYes);*)

                       {They have entries in both grids, so let's copy the original parcel.}

                    SourceParcelID := GetSwisSBLFromGridEntry(SourceGrid.Cells[0,0], ValidEntry);

                    SourceList := TStringList.Create;
                    For I := 0 to (SourceGrid.RowCount - 1) do
                      If _Compare(SourceGrid.Cells[0, I], coNotBlank)
                        then SourceList.Add(GetSwisSBLFromGridEntry(SourceGrid.Cells[0, I], ValidEntry));

                    If not Quit
                      then
                        begin
                            {FXX02161999-1: Allow to spilt\merge into an existing
                                            parcel.}

                          DestList := TStringList.Create;
                          DestExistsList := TStringList.Create;
                          FillInDestinationList(DestList, DestExistsList, TaxRollYr,
                                                ParcelTable);

                          CopySourceToNewParcels(SourceParcelID,
                                                 SourceList,
                                                 DestList,
                                                 DestExistsList,
                                                 False,
                                                 SplitMergeNoEdit.Text, Mode,
                                                 ProcessingType,
                                                 TaxRollYr, Quit);

                            {If we successfully merged, then mark the originals inactive.}
                            {If they want to mark the source parcel(s) inactive, do it.}

                          If MarkInactive
                            then MarkSourceParcelsInactive(SourceList,
                                                           DestList, DestExistsList,
                                                           TaxRollYr, ParcelTable,
                                                           SplitMergeNoEdit.Text);

                            {Also, make the original parcel the parent and fill in the
                             related SBL of the first child (i.e. destination).}

                          StatusPanel.Caption := 'Marking source parcel(s) as parent.';
                          StatusPanel.Repaint;

                        end;  {If not Quit}

                    If not Quit
                      then
                        For I := 0 to (SourceList.Count - 1) do
                          SetParentParcelRelationship(SourceList[I], DestGrid.Cells[0, 0],
                                                      SplitMergeNoEdit.Text,
                                                      TaxRollYr,
                                                      ParcelTable, Quit);

                      {FXX04081999-6: Store this split/merge.}

                    If not Quit
                      then SaveSplitMergeAudit(SourceList, DestList, DestExistsList,
                                               MarkInactive);

                      {CHG02261998-1: Add dual modify mode to split/merge.}

                    If GlblModifyBothYears
                      then
                        begin
                          DestList.Clear;
                          DestExistsList.Clear;
                          FillInDestinationList(DestList, DestExistsList, OppositeTaxYear,
                                                OppositeYearParcelTable);

                          If not Quit
                            then
                              begin
                                CopySourceToNewParcels(SourceParcelID,
                                                       SourceList,
                                                       DestList,
                                                       DestExistsList,
                                                       False,
                                                       SplitMergeNoEdit.Text, Mode,
                                                       OppositeYearProcessingType,
                                                       OppositeTaxYear, Quit);

                                  {If we successfully merged, then mark the originals inactive.}
                                  {If they want to mark the source parcel(s) inactive, do it.}

                                If MarkInactive
                                  then MarkSourceParcelsInactive(SourceList,
                                                                 DestList, DestExistsList,
                                                                 OppositeTaxYear,
                                                                 OppositeYearParcelTable,
                                                                 SplitMergeNoEdit.Text);

                                  {Also, make the original parcel the parent and fill in the
                                   related SBL of the first child (i.e. destination).}

                                StatusPanel.Caption := 'Marking source parcel(s) as parent.';
                                StatusPanel.Repaint;

                              end;  {If not Quit}

                          If not Quit
                            then
                              For I := 0 to (SourceList.Count - 1) do
                                SetParentParcelRelationship(SourceList[I], DestGrid.Cells[0, 0],
                                                            SplitMergeNoEdit.Text,
                                                            OppositeTaxYear,
                                                            OppositeYearParcelTable, Quit);

                        end;  {If GlblModifyBothYears}

                    {CHG02162005-1(2.8.3.7)[2069]: Add option to merge together the assessed values and
                                                   dimensions.}

                    If MergeValues
                      then
                        begin
                          MergeValuesForParcel(SourceList, DestList, TaxRollYr, True, True);

                          If GlblModifyBothYears
                            then MergeValuesForParcel(SourceList, DestList, OppositeTaxYear, False, False);

                        end;  {If MergeValues}

                    SourceList.Free;
                    DestList.Free;
                    DestExistsList.Free;

                    If Quit
                      then MessageDlg('The parcels were not merged successfully.', mtError, [mbOK], 0)
                      else
                        begin
                          SplitMergeCopyOrSBLChangeDone := True;

                          If MarkInactive
                            then TempStr := 'Please note that the source parcel(s) are now inactive.'
                            else TempStr := 'Please note that the source parcel(s) are still active.';

                          MessageDlg('The parcels were merged successfully.' + #13 + TempStr,
                                      mtInformation, [mbOK], 0);

                            {FXX02191999-5: Warn the user to check source exemptions,
                                            if there are any.}

                          ExemptionList := TStringList.Create;
                          GetExemptionCodesForParcel(TaxRollYr, SourceParcelID,
                                                     ParcelExemptionTable, ExemptionList);

                          If ((ExemptionList.Count > 0) and
                              (not MarkInactive))
                            then
                              begin
                                ExString := '';

                                For I := 0 to (ExemptionList.Count - 1) do
                                  begin
                                    ExString := ExString + ExemptionList[I];

                                    If (I < (ExemptionList.Count - 1))
                                      then ExString := ExString + ',';

                                  end;  {For I := 1 to ExIdx do}

                                MessageDlg('Warning: The following exemption(s) assigned to' + #13 +
                                           'this parcel require review for continued  ' + #13 +
                                           'applicability as a result of this split\merge:' + #13 + #13 +
                                           ExString, mtWarning, [mbOK], 0);

                              end;  {If (ExIdx > 1)}

                          ExemptionList.Free;

                        end;  {If Quit}

                  end;  {If (NumEntriesInGrid(SourceGrid) = 0) and ...}

              StatusPanel.Visible := False;

            end;  {Merge}

          SBLChange :
            begin
                 {First, let's make sure that they have entries in both the source and destination
                  grids.}

              If ((NumEntriesInGridCol(SourceGrid, 0) = 0) or
                  (NumEntriesInGridCol(DestGrid, 0) = 0))
                then
                  begin
                    If (NumEntriesInGridCol(SourceGrid, 0) = 0)
                      then
                        begin
                          MessageDlg('Please enter the source parcel ID.', mtError, [mbOK], 0);
                          SourceGrid.SetFocus;
                        end
                      else
                        begin
                          MessageDlg('Please enter the new parcel ID.', mtError, [mbOK], 0);
                          DestGrid.SetFocus;
                        end;  {else of If (NumEntries(SourceGrid) = 0)}

                  end
                else
                  begin
                    Quit := False;
                    StatusPanel.Visible := True;

                    ParcelID1 := GetSwisSBLFromGridEntry(SourceGrid.Cells[0,0], ValidEntry);

                    ParcelID2 := GetSwisSBLFromGridEntry(DestGrid.Cells[0,0], ValidEntry);
                    YearsOfExistence := TStringList.Create;

                      {CHG01222006-1(2.9.5.1): Check to make sure that the original parcel did not exist in any
                                               assessment year.}
                      {CHG02102006-1(2.9.5.5): If the parcel exists in a previous year, offer to get rid of it.}

                    Continue := True;

                    If ParcelExistsInAnyYear(ParcelID2, YearsOfExistence)
                      then
                        begin
                          YearsOfExistenceString := StringListToString(YearsOfExistence, ', ');
                          If (MessageDlg('Parcel ' + SourceGrid.Cells[0,0] + ' exists in the following assessment year(s): ' + #13 +
                                         YearsOfExistenceString + '.' + #13 +
                                         'Do you want to switch it anyway?', mtWarning, [mbYes, mbNo], 0) = idYes)
                            then
                              begin
                                  {In order to make sure that there aren't any orphans, delete all years
                                   just in case.}

                                AssessmentYears := TStringList.Create;
                                GetAllAssessmentYears(AssessmentYears);

                                For I := 0 to (AssessmentYears.Count - 1) do
                                  DeleteParcelPermanently(AssessmentYears[I], ParcelID2, Quit);

                                AssessmentYears.Free;

                              end
                            else Continue := False;

                        end;

                    If Continue
                      then
                        If (MessageDlg('Do you want to completely switch the parcel to the new ID?',
                                       mtConfirmation, [mbYes, mbNo], 0) = idYes)
                          then
                            begin
                                {CHG02072011-1(2.26.1.36)[I8635]: Add the option to not switch history.}

                              bConvertHistory := (MessageDlg('Do you want to switch history?', mtConfirmation, [mbYes, mbNo], 0) = idYes);

                              SwitchOrConvertTheParcelIDs(ParcelID1, ParcelID2, 'C', bConvertHistory, Quit);

                              If Quit
                                then MessageDlg('The parcel ' +
                                                SourceGrid.Cells[0,0] +
                                                ' was not converted successfully to   ' +
                                                DestGrid.Cells[0,0] + '.',
                                                mtError, [mbOK], 0)
                                else
                                  begin
                                    MessageDlg('The parcel ' +
                                               SourceGrid.Cells[0,0] +
                                               ' was converted successfully to   ' +
                                               DestGrid.Cells[0,0] + '.',
                                               mtInformation, [mbOK], 0);

                                    SplitMergeCopyOrSBLChangeDone := True;
                                    SourceList := TStringList.Create;
                                    SourceList.Add(ParcelID1);
                                    DestList := TStringList.Create;
                                    DestList.Add(ParcelID2);
                                    DestExistsList := TStringList.Create;
                                    DestExistsList.Add('Y');

                                    SaveSplitMergeAudit(SourceList, DestList,
                                                        DestExistsList, False);

                                    DestList.Free;
                                    DestExistsList.Free;
                                    SourceList.Free;

                                  end;  {else of If Quit}

                            end
                          else
                            begin
                              SourceParcelID := GetSwisSBLFromGridEntry(SourceGrid.Cells[0,0], ValidEntry);

                                {FXX03161998-1: SourceList.Create is wrong, all wrong!}

                              SourceList := TStringList.Create;
                              SourceList.Add(SourceParcelID);
                              DestList := TStringList.Create;
                              DestExistsList := TStringList.Create;

                              If not Quit
                                then
                                  begin
                                      {FXX02161999-1: Allow to spilt\merge into an existing
                                                      parcel.}

                                    FillInDestinationList(DestList, DestExistsList, TaxRollYr,
                                                          ParcelTable);

                                    CopySourceToNewParcels(SourceParcelID, SourceList,
                                                           DestList, DestExistsList, True,
                                                           SplitMergeNoEdit.Text, Mode,
                                                           ProcessingType, TaxRollYr,
                                                           Quit);

                                  end;  {If not Quit}

                                {If we successfully changed the key, then mark the original
                                 inactive.}

                              If not Quit
                                then MarkSourceParcelsInactive(SourceList, DestList, DestExistsList,
                                                               TaxRollYr, ParcelTable,
                                                               SplitMergeNoEdit.Text);

                                {FXX06291999-1: Do keychange in next year, too.}

                              If GlblModifyBothYears
                                then
                                  begin
                                    If not Quit
                                      then
                                        begin
                                          DestList.Clear;
                                          DestExistsList.Clear;

                                            {FXX02161999-1: Allow to spilt\merge into an existing
                                                            parcel.}

                                          FillInDestinationList(DestList, DestExistsList, OppositeTaxYear,
                                                                OppositeYearParcelTable);

                                          CopySourceToNewParcels(SourceParcelID, SourceList,
                                                                 DestList, DestExistsList, True,
                                                                 SplitMergeNoEdit.Text, Mode,
                                                                 OppositeYearProcessingType,
                                                                 OppositeTaxYear, Quit);

                                        end;  {If not Quit}

                                      {If we successfully changed the key, then mark the original
                                       inactive.}

                                    If not Quit
                                      then MarkSourceParcelsInactive(SourceList, DestList, DestExistsList,
                                                                     OppositeTaxYear, OppositeYearParcelTable,
                                                                     SplitMergeNoEdit.Text);

                                  end;  {If GlblModifyBothYears}

                                {FXX04081999-6: Store this split/merge.}

                              If not Quit
                                then SaveSplitMergeAudit(SourceList, DestList, DestExistsList,
                                                         MarkInactive);

                              SourceList.Free;
                              DestList.Free;
                              DestExistsList.Free;

                                {Also, make the original parcel the parent and fill in the
                                 related SBL of the first child (i.e. destination).}

                              StatusPanel.Caption := 'Marking source parcel as parent.';
                              StatusPanel.Repaint;

                              If not Quit
                                then SetParentParcelRelationship(SourceParcelID, DestGrid.Cells[0, 0],
                                                                 SplitMergeNoEdit.Text,
                                                                 TaxRollYr,
                                                                 ParcelTable, Quit);

                              If Quit
                                then MessageDlg('The parcel SBL was not changed successfully.', mtError, [mbOK], 0)
                                else
                                  begin
                                    SplitMergeCopyOrSBLChangeDone := True;
                                    MessageDlg('The parcel SBL was changed successfully.' + #13 +
                                                'Please note that parcel ' + SourceGrid.Cells[0,0] +
                                                ' is now inactive.' , mtInformation,
                                                [mbOK], 0);
                                  end;

                            end;  {else of If (MessageDlg('Do you want...}

                    YearsOfExistence.Free;

                  end;  {If (NumEntriesInGrid(SourceGrid) = 0) and ...}

              StatusPanel.Visible := False;

            end;  {SBLChange}

          CopyParcel :
            begin
                 {First, let's make sure that they have entries in both the source and destination
                  grids.}

              If ((NumEntriesInGridCol(SourceGrid, 0) = 0) or
                  (NumEntriesInGridCol(DestGrid, 0) = 0))
                then
                  begin
                    If (NumEntriesInGridCol(SourceGrid, 0) = 0)
                      then
                        begin
                          MessageDlg('Please enter the source parcel ID.', mtError, [mbOK], 0);
                          SourceGrid.SetFocus;
                        end
                      else
                        begin
                          MessageDlg('Please enter the new parcel ID(s).', mtError, [mbOK], 0);
                          DestGrid.SetFocus;
                        end;  {else of If (NumEntries(SourceGrid) = 0)}

                  end
                else
                  begin
                    Quit := False;
                    StatusPanel.Visible := True;

                       {They have entries in both grids, so let's copy the original parcel.}

                      {FXX02161999-1: Allow to spilt\merge into an existing
                                      parcel.}

                    SourceParcelID := GetSwisSBLFromGridEntry(SourceGrid.Cells[0,0], ValidEntry);

                    SourceList := TStringList.Create;
                    SourceList.Add(SourceParcelID);
                    DestList := TStringList.Create;
                    DestExistsList := TStringList.Create;
                    FillInDestinationList(DestList, DestExistsList, TaxRollYr,
                                          ParcelTable);

                    CopySourceToNewParcels(SourceParcelID, SourceList, DestList,
                                           DestExistsList, False,
                                           SplitMergeNoEdit.Text, Mode,
                                           ProcessingType, TaxRollYr, Quit);

                      {FXX06291999-1: Do copy in next year, too.}

                    If GlblModifyBothYears
                      then
                        begin
                            {FXX03292002-1: We need to reload the destinaton parcel
                                            exists list to avoid case where parcel
                                            already exists in NY.}

                          DestList.Clear;
                          DestExistsList.Clear;
                          FillInDestinationList(DestList, DestExistsList, OppositeTaxYear,
                                                OppositeYearParcelTable);

                          CopySourceToNewParcels(SourceParcelID, SourceList, DestList,
                                                 DestExistsList, False,
                                                 SplitMergeNoEdit.Text, Mode,
                                                 OppositeYearProcessingType,
                                                 OppositeTaxYear, Quit);

                        end;  {If GlblModifyBothYears}

                      {FXX04081999-6: Store this split/merge.}

                    If not Quit
                      then SaveSplitMergeAudit(SourceList, DestList, DestExistsList,
                                               MarkInactive);

                    DestList.Free;
                    DestExistsList.Free;

                    If Quit
                      then MessageDlg('The parcel did not copy successfully.', mtError, [mbOK], 0)
                      else
                        begin
                          SplitMergeCopyOrSBLChangeDone := True;
                          MessageDlg('The parcel was copied successfully.', mtInformation,
                                      [mbOK], 0);
                        end;

                  end;  {If (NumEntriesInGrid(SourceGrid) = 0) and ...}

              StatusPanel.Visible := False;

            end;  {Copy}

          SwitchParcels :
            begin
              If ((NumEntriesInGridCol(SourceGrid, 0) = 0) or
                  (NumEntriesInGridCol(DestGrid, 0) = 0))
                then
                  begin
                    If (NumEntriesInGridCol(SourceGrid, 0) = 0)
                      then
                        begin
                          MessageDlg('Please enter the first parcel ID.', mtError, [mbOK], 0);
                          SourceGrid.SetFocus;
                        end
                      else
                        begin
                          MessageDlg('Please enter the second parcel ID.', mtError, [mbOK], 0);
                          DestGrid.SetFocus;
                        end;  {else of If (NumEntries(SourceGrid) = 0)}

                  end
                else
                  begin
                    ParcelID1 := GetSwisSBLFromGridEntry(SourceGrid.Cells[0,0], ValidEntry);

                    ParcelID2 := GetSwisSBLFromGridEntry(DestGrid.Cells[0,0], ValidEntry);

                    If (MessageDlg('This will completely switch the parcels ' +
                                   SourceGrid.Cells[0,0] + ' and ' +
                                   DestGrid.Cells[0,0] + '.' + #13 +
                                   'Are you sure this is what you want to do?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
                      then
                        begin
                          SwitchOrConvertTheParcelIDs(ParcelID1, ParcelID2, 'S', True, Quit);

                          If Quit
                            then MessageDlg('The parcels ' +
                                            SourceGrid.Cells[0,0] + ' and ' +
                                            DestGrid.Cells[0,0] + ' were NOT switched successfully.',
                                            mtError, [mbOK], 0)
                            else
                              begin
                                MessageDlg('The parcels ' +
                                           SourceGrid.Cells[0,0] + ' and ' +
                                           DestGrid.Cells[0,0] + ' were switched successfully.',
                                           mtInformation, [mbOK], 0);

                                SplitMergeCopyOrSBLChangeDone := True;
                                SourceList := TStringList.Create;
                                SourceList.Add(ParcelID1);
                                DestList := TStringList.Create;
                                DestList.Add(ParcelID2);
                                DestExistsList := TStringList.Create;
                                DestExistsList.Add('Y');

                                SaveSplitMergeAudit(SourceList, DestList,
                                                    DestExistsList, False);

                                DestList.Free;
                                DestExistsList.Free;
                                SourceList.Free;

                              end;  {else of If Quit}

                        end;  {If (MessageDlg('This will completely...}

                  end;  {else of If ((NumEntriesInGridCol(SourceGrid, 0) = 0) or...}

            end;  {SwitchParcels}

          RollSection9 :
            begin
              If ((NumEntriesInGridCol(SourceGrid, 0) = 0) or
                  (NumEntriesInGridCol(DestGrid, 0) = 0))
                then
                  begin
                    If (NumEntriesInGridCol(SourceGrid, 0) = 0)
                      then
                        begin
                          MessageDlg('Please enter the original parcel ID.', mtError, [mbOK], 0);
                          SourceGrid.SetFocus;
                        end
                      else
                        begin
                          MessageDlg('Please enter the roll section 9 parcel ID.', mtError, [mbOK], 0);
                          DestGrid.SetFocus;
                        end;  {else of If (NumEntries(SourceGrid) = 0)}

                  end
                else
                  begin
                    SegmentDisplayPanel.Top := 50;
                       {Get the pro-rata special district and amount.
                        We will actually create the rs9 parcel if they click OK in the
                        rs 9 panel.}

                    RS9PanelButtonPressed := False;

                      {CHG04121998-1: Allow user to select default pro-rata
                                      SD.}

                    SDCodeLookupCombo.Text := DefaultRS9SpecialDistrict.Text;
                    RollSection9Panel.Visible := True;

                      {FXX02281998-3: Should not have amount of last rs 9.  Also if
                                      have default rs 9, put in amount field.}

                    EditRS9Amount.Text := '';

                    If (Deblank(DefaultRS9SpecialDistrict.Text) = '')
                      then SDCodeLookupCombo.SetFocus
                      else EditRS9Amount.SetFocus;

                  end;  {If ((NumEntriesInGridCol(SourceGrid, 0) = 0) ...}

            end;  {Roll section 9}

        end;  {case Mode of}

          {Now, if they did a split, merge, copy, or SBL change, then let's
           add one to the split merge number (if they used the next split merge no.)
           and clear the grids.}

        If SplitMergeCopyOrSBLChangeDone
          then
            begin
              StatusPanel.Visible := False;
              If (StrToInt(SplitMergeNoEdit.Text) = NextSplitMergeNo)
                then
                  begin
                    with AssessmentYearControlTable do
                      begin
                        Edit;
                        FieldByName('NextSplitMergeNo').AsInteger := NextSplitMergeNo + 1;

                        try
                          Post;
                        except
                          SystemSupport(012, AssessmentYearControlTable, 'Error posting assessment year control record.',
                                        UnitName, GlblErrorDlgBox);
                        end;

                      end;  {with AssessmentYearControlTable do}

                    NextSplitMergeNo := NextSplitMergeNo + 1;
                    NextSplitMergeNoLabel.Caption := '(Next S\M# = ' + IntToStr(NextSplitMergeNo) + ')';
                    SplitMergeNoEdit.Text := IntToStr(NextSplitMergeNo);

                  end;  {If (StrToInt(SplitMergeNoEdit.Text) = ...}

              If DisplayClassifiedParcelWarning
                then MessageDlg('The parent parcel was classified split.' + #13 +
                                'No class records were copied to the new parcels.' + #13 +
                                'All new parcels have been marked homestead.', mtWarning, [mbOK], 0);

                {Clear the grids.}

              For I := 0 to (SourceGrid.RowCount - 1) do
                SourceGrid.Cells[0, I] := '';

              For I := 0 to (DestGrid.RowCount - 1) do
                DestGrid.Cells[0, I] := '';

              SourceGrid.Row := 0;
              DestGrid.Row := 0;
              NameLabel.Caption := '';
              AddrLabel.Caption := '';

              SourceGrid.SetFocus;

            end;  {If SplitMergeCopyOrSBLChangeDone}

        If CreateParcelList
          then ParcelListDialog.Show;

      end;  {If not SplitMergeCancelledInPrint}

  SplitMergeCancelledInPrint := False;

    {CHG04272000-3: Display the segments.}

  SegmentDisplayPanel.Visible := False;

end;  {OKButtonClick}

{=====================================================================}
Procedure TKeyChangeForm.RS9PanelCancelButtonClick(Sender: TObject);

begin
  RS9PanelButtonPressed := True;
  RollSection9Panel.Visible := False;

end;  {RS9PanelCancelButtonClick}

{=====================================================================}
Procedure TKeyChangeForm.RS9PanelOKButtonClick(Sender: TObject);

{If they entered a special district code and a valid numerical amount,
 then we will create the roll section 9 parcel.}

var
  Quit, ValidEntry, SDEntryOK,
  _Found, SDCodeIsMoveTax : Boolean;
  TempNum : Real;
  I : Integer;
  SourceList, DestList, DestExistsList : TStringList;
  SourceSwisSBLKey, DestSwisSBLKey : String;
  TempFieldName : String;
  DestSwisSBLRec, SwisSBLRec : SBLRecord;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  SDAmounts : TList;

begin
  SDEntryOK := True;
  Quit := False;

  DestList := TStringList.Create;
  DestExistsList := TStringList.Create;

  If (Deblank(SDCodeLookupCombo.Text) = '')
    then
      begin
        SDEntryOK := False;
        MessageDlg('Please enter a special district code.', mtError, [mbOK], 0);
      end;

    {If the special district is not a MOVE tax, then it can not be a pro-rata SD.}

  SDCodeIsMoveTax := False;

    {Go through all of the extension code fields.}

  For I := 1 to 10 do
    begin
      TempFieldName := 'ECd' + IntToStr(I);

      If (SDCodeTable.FieldByName(TempFieldName).Text = SdistEcMT)
        then SDCodeIsMoveTax := True;

    end;  {For I := 1 to 10 do}

  If not SDCodeIsMoveTax
    then
      begin
        SDEntryOK := False;
        MessageDlg('The pro-rata special district must be a move tax type special distcit.', mtError, [mbOK], 0);
      end;

  try
    TempNum := StrToFloat(EditRS9Amount.Text);

    If (Roundoff(TempNum, 2) <= 0)
      then
        begin
          SDEntryOK := False;
          MessageDlg('Please enter a number greater than 0 for the pro-rata amount.',
                     mtError, [mbOK], 0);
        end;

  except
    SDEntryOK := False;
    MessageDlg('Please enter a number for the amount.', mtError, [mbOK], 0);
  end;

    {The entries were OK, so now create the roll section 9 parcel, add the special district
     that they specified, and put the RS9 relationship in the original parcel.}

  If SDEntryOK
    then
      begin
          {First create the parcel.}

        SourceSwisSBLKey := GetSwisSBLFromGridEntry(SourceGrid.Cells[0,0], ValidEntry);

        DestSwisSBLKey := GetSwisSBLFromGridEntry(DestGrid.Cells[0, 0], ValidEntry);

          {FXX02281999-1: Dest list exists for rs 9 is always false.}

        DestList.Add(DestSwisSBLKey);
        DestExistsList.Add('N');

          {If we successfully split, then mark the originals inactive.}

        SourceList := TStringList.Create;
        For I := 0 to (SourceGrid.RowCount - 1) do
          If (Deblank(SourceGrid.Cells[0, I]) <> '')
            then SourceList.Add(GetSwisSBLFromGridEntry(SourceGrid.Cells[0, I], ValidEntry));

        InventoryCopyMode := InvCopyNone;

        CopySourceToNewParcels(SourceSwisSBLKey, SourceList, DestList, DestExistsList, False,
                               '', Mode, ProcessingType, TaxRollYr, Quit);

          {Now add the pro-rata special district.}

        If not Quit
          then
            begin
              with ParcelSDTable do
                try
                  Insert;
                  FieldByName('TaxRollYr').Text := GetTaxRlYr;
                  FieldByName('SwisSBLKey').Text := DestSwisSBLKey;
                  FieldByName('SDistCode').Text := SDCodeLookupCombo.Text;
                  FieldByName('CalcAmount').Text := EditRS9Amount.Text;

                   {FXX07191999-9: Force a move tax to have a 'T' calc code for
                                   compatibility with RPS.}

                  FieldByName('CalcCode').Text := 'T';
                  FieldByName('DateAdded').AsDateTime := Date;

                  Post;
                except
                  Quit := True;
                  SystemSupport(013, ParcelSDTable, 'Error inserting parcel SD record.',
                                UnitName, GlblErrorDlgBox);
                end;

            end;  {If not Quit}

          {Finally set the RS9 link for the base parcel.}

        If not Quit
          then
            begin
              with ParcelTable do
                begin
                  SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(SourceSwisSBLKey);

                  with SwisSBLRec do
                    _Found := FindKeyOld(ParcelTable,
                                         ['TaxRollYr', 'SwisCode', 'Section',
                                          'Subsection', 'Block', 'Lot', 'Sublot',
                                          'Suffix'],
                                         [TaxRollYr, SwisCode, Section, Subsection,
                                          Block, Lot, Sublot, Suffix]);

                  If _Found
                    then
                      begin
                        try
                          Edit;

                          FieldByName('RS9LinkedSBL').Text := DestSwisSBLKey;

                          Post;
                        except
                          Quit := True;
                          SystemSupport(014, ParcelTable, 'Error getting source parcel record.',
                                        UnitName, GlblErrorDlgBox);
                        end;

                      end
                    else
                      begin
                        Quit := True;
                        SystemSupport(015, ParcelTable, 'Error getting source parcel record.',
                                      UnitName, GlblErrorDlgBox);

                      end;

                end;  {with ParcelTable do}

            end;  {If not Quit}

          {Add the special district to the roll totals.}

        If not Quit
          then
            begin
                {FXX01222000-1: Fix up omitted roll totals.}
                {We need to switch back to the roll section 9 parcel.}

              with ParcelTable do
                begin
                  SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(DestSwisSBLKey);

                  with SwisSBLRec do
                    FindKeyOld(ParcelTable,
                               ['TaxRollYr', 'SwisCode', 'Section',
                                'Subsection', 'Block', 'Lot', 'Sublot',
                                'Suffix'],
                               [TaxRollYr, SwisCode, Section, Subsection,
                                Block, Lot, Sublot, Suffix]);

                end;

                {Now add in the roll totals for this new parcel.}

              ExemptionCodes := TStringList.Create;
              ExemptionHomesteadCodes := TStringList.Create;
              CountyExemptionAmounts := TStringList.Create;
              TownExemptionAmounts := TStringList.Create;
              SchoolExemptionAmounts := TStringList.Create;
              VillageExemptionAmounts := TStringList.Create;
              SDAmounts := TList.Create;

                {The special district amounts may have changed, so
                 calculate the  special district amounts, too.}

              TotalSpecialDistrictsForParcel(TaxRollYr,
                                             DestSwisSBLKey,
                                             ParcelTable,
                                             AssessmentTable,
                                             ParcelSDTable,
                                             SDCodeTable,
                                             ParcelExemptionTable,
                                             EXCodeTable,
                                             SDAmounts);

                {CHG12011997-2: STAR support. There will not be any STAR
                                on RS9.}
                {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                                the parcel table for that.}
                {FXX01222000-1: Fix up omitted roll totals.}

              AdjustRollTotalsForParcel(TaxRollYr,
                                        ParcelTable.FieldByName('SwisCode').Text,
                                        ParcelTable.FieldByName('SchoolCode').Text,
                                        ParcelTable.FieldByName('HomesteadCode').Text,
                                        ParcelTable.FieldByName('RollSection').Text,
                                        0, 0, 0, 0,
                                        ExemptionCodes,
                                        ExemptionHomesteadCodes,
                                        CountyExemptionAmounts,
                                        TownExemptionAmounts,
                                        SchoolExemptionAmounts,
                                        VillageExemptionAmounts,
                                        ParcelTable,
                                        0, 0, SDAmounts,
                                        ['D'],  {Adjust sd}
                                        'A');  {Add the totals.}

              ExemptionCodes.Free;
              ExemptionHomesteadCodes.Free;
              CountyExemptionAmounts.Free;
              TownExemptionAmounts.Free;
              SchoolExemptionAmounts.Free;
              VillageExemptionAmounts.Free;
              ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
              FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

            end;  {If not Quit}

      end;  {If SDEntryOK}

    {FXX02281999-5: Use the NY name and address.}

  If SDEntryOK
    then
      begin
        OpenTableForProcessingType(SourceTable, ParcelTableName,
                                   NextYear, Quit);
        OpenTableForProcessingType(DestTable, ParcelTableName,
                                   ThisYear, Quit);

        SwisSBLRec := ExtractSwisSBLFromSwisSBLKey(SourceSwisSBLKey);

        with SwisSBLRec do
          _Found := FindKeyOld(SourceTable,
                               ['TaxRollYr', 'SwisCode', 'Section',
                                'Subsection', 'Block', 'Lot', 'Sublot',
                                'Suffix'],
                               [GlblNextYear, SwisCode, Section, Subsection,
                                Block, Lot, Sublot, Suffix]);

        DestSwisSBLRec := ExtractSwisSBLFromSwisSBLKey(DestList[0]);

        with DestSwisSBLRec do
          FindKeyOld(DestTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                     [GlblThisYear, SwisCode, Section, Subsection,
                      Block, Lot, Sublot, Suffix]);

        If _Found
          then
            with DestTable do
              try
                Edit;
                FieldByName('Name1').Text := SourceTable.FieldByName('Name1').Text;
                FieldByName('Name2').Text := SourceTable.FieldByName('Name2').Text;
                FieldByName('Address1').Text := SourceTable.FieldByName('Address1').Text;
                FieldByName('Address2').Text := SourceTable.FieldByName('Address2').Text;
                FieldByName('Street').Text := SourceTable.FieldByName('Street').Text;
                FieldByName('City').Text := SourceTable.FieldByName('City').Text;
                FieldByName('State').Text := SourceTable.FieldByName('State').Text;
                FieldByName('Zip').Text := SourceTable.FieldByName('Zip').Text;
                FieldByName('ZipPlus4').Text := SourceTable.FieldByName('ZipPlus4').Text;
                FieldByName('BankCode').Text := SourceTable.FieldByName('BankCode').Text;
                Post;
              except
                SystemSupport(67, DestTable, 'Error posting NY name\address information to rs 9 parcel.',
                              UnitName, GlblErrorDlgBox);
              end;

      end;  {If SDEntryOK}

  If SDEntryOK
    then
      begin
        RS9PanelButtonPressed := True;
        RollSection9Panel.Visible := False;
        MessageDlg('The roll section 9 parcel was successfully created.',
                   mtInformation, [mbOK], 0);

          {Clear the grids.}

        SourceGrid.Cells[0,0] := '';
        DestGrid.Cells[0,0] := '';

      end;  {If SDEntryOK}

  DestList.Free;
  DestExistsList.Free;

end;  {RS9PanelOKButtonClick}

{=====================================================================}
Procedure TKeyChangeForm.RollSection9PanelExit(Sender: TObject);

{Don't let them exit the roll section 9 panel without pressing OK or Cancel.}

begin
  If not RS9PanelButtonPressed
    then RollSection9Panel.SetFocus;

end;  {RollSection9PanelExit}

{=====================================================================}
Procedure TKeyChangeForm.ChangeModeButtonClick(Sender: TObject);

begin
    {Don't allow any typing until they have chosen a mode.}

  SourceGrid.Options := SourceGrid.Options - [goEditing];
  DestGrid.Options := DestGrid.Options - [goEditing];

  ChooseModePanelButtonPressed := False;
  KeyChangeModePanel.Visible := True;
  SplitMergePrinted := False;

end;  {ChangeModeButtonClick}

{=====================================================================}
Procedure TKeyChangeForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;

begin
  If PrintDialog.Execute
    then
      begin
        SplitMergePrinted := True;

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

      end  {If PrintRangeDlg.Execute}
    else SplitMergeCancelledInPrint := True;

end;  {PrintButtonClick}

{=============================================================================}
{===============   PRINTING LOGIC  ===========================================}
{=============================================================================}
Procedure TKeyChangeForm.ReportPrinterBeforePrint(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      MarginTop := 1.25;
      MarginBottom := 0.75;
      NumSourceSBLsPrinted := 0;
      NumDestSBLsPrinted := 0;
      NumSourceSBLsToPrint := NumEntriesInGridCol(SourceGrid, 0);
      NumDestSBLsToPrint := NumEntriesInGridCol(DestGrid, 0);

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterBeforePrint}

{=============================================================================}
Procedure TKeyChangeForm.ReportPrinterPrintHeader(Sender: TObject);

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
      SetFont('Arial',14);
      Home;
      CRLF;
      PrintCenter('Split\Merge\SBL Change\Copy\Roll Section 9 Listing', (PageWidth / 2));
      SetFont('Times New Roman', 10);
      CRLF;
      CRLF;

         {Code tables are now year independent so we do not want to print the
          tax year.}

      Println('Tax Year: ' + GetTaxRlYr + ' (' +
              ConvertYearBeingProcessedToText + ')');
      Println('For Mode: ' + ConvertModeToStr(Mode) + '   Split\Merge Number: ' +
              SplitMergeNoEdit.Text);

      SectionTop := 1.5;

        {There are no column headers.}

      CRLF;
      Home;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrintHeader}

{=============================================================================}
Function TKeyChangeForm.ReportPrinterPrintPage(    Sender: TObject;
                                                  var PageNum: Integer): Boolean;

var
  DoneWithReport : Boolean;
  Index, NumPrintedThisLine : Integer;

begin
  DoneWithReport := False;

  with Sender as TBaseReport do
    begin
      Bold := False;

        {Set up the tabs for the info.}

      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.3, pjLeft, 2.5, 0, BOXLINENONE, 0);  {SBL #1}
      SetTab(2.9, pjLeft, 2.5, 0, BOXLINENONE, 0);  {SBL #2}
      SetTab(5.5, pjLeft, 2.5, 0, BOXLINENONE, 0);  {SBL #3}

        {Print any source SBLs.}

      If (NumSourceSBLsPrinted <> NumSourceSBLsToPrint)
        then
          begin
            NumPrintedThisLine := 0;
            Index := 0;
            Underline := True;

              {Print the label.}

            case Mode of
              Split : Println('Original Parcel ID:');
              Merge : Println('Original Parcel ID(s):');
              SBLChange : Println('Parcel To Be Changed:');
              CopyParcel : Println('Source Parcel ID:');
              RollSection9 : Println('Original Parcel ID:');
            end;  {case Mode of}

            Underline := False;

              {Now print the SBLs 3 to a line.}

            while ((NumSourceSBLsPrinted < NumSourceSBLsToPrint) and
                   (LinesLeft > 1)) do
              begin
                If (NumPrintedThisLine = 3)
                  then
                    begin
                      NumPrintedThisLine := 0;
                      Println('');
                    end;

                If (Deblank(SourceGrid.Cells[0, Index]) <> '')
                  then
                    begin
                      Print(#9 + SourceGrid.Cells[0, Index]);

                        {FXX12011998-17: Mark the source parcel.}

                      If (NumSourceSBLsPrinted = 0)
                        then Print('  (Source)');

                      NumPrintedThisLine := NumPrintedThisLine + 1;
                      NumSourceSBLsPrinted := NumSourceSBLsPrinted + 1;

                    end;  {If (Deblank(SourceGrid.Cells[0, Index]) <> '')}

                Index := Index + 1;

              end;  {while ((NumSourceSBLsPrinted < NumSourceSBLsToPrint) ...}

              {See if we need to issue a carriage return to finish this line.}

            If (NumPrintedThisLine < 3)
              then Println('');

            Println('');

          end;  {If (NumSourceSBLsPrinted <> NumSourceSBLsToBePrinted)}

        {Print any Dest SBLs.}

      If (NumDestSBLsPrinted <> NumDestSBLsToPrint)
        then
          begin
            NumPrintedThisLine := 0;
            Index := 0;
            Underline := True;

              {Print the label.}

            case Mode of
              Split : Println('New Parcel ID(s):');
              Merge : Println('New Parcel ID:');
              SBLChange : Println('New Parcel ID:');
              CopyParcel : Println('New Parcel ID(s):');
              RollSection9 : Println('Roll Section 9 Parcel:');
            end;  {case Mode of}

            Underline := False;

              {Now print the SBLs 3 to a line.}

            while ((NumDestSBLsPrinted < NumDestSBLsToPrint) and
                   (LinesLeft > 1)) do
              begin
                If (NumPrintedThisLine = 3)
                  then
                    begin
                      NumPrintedThisLine := 0;
                      Println('');
                    end;

                If (Deblank(DestGrid.Cells[0, Index]) <> '')
                  then
                    begin
                      Print(#9 + DestGrid.Cells[0, Index]);
                      NumPrintedThisLine := NumPrintedThisLine + 1;
                      NumDestSBLsPrinted := NumDestSBLsPrinted + 1;

                    end;  {If (Deblank(DestGrid.Cells[0, Index]) <> '')}

                Index := Index + 1;

              end;  {while ((NumDestSBLsPrinted < NumDestSBLsToPrint) ...}

              {See if we need to issue a carriage return to finish this line.}

            If (NumPrintedThisLine < 3)
              then Println('');

            If (NumDestSBLsPrinted = NumDestSBLsToPrint)
              then DoneWithReport := True;

          end;  {If (NumDestSBLsPrinted <> NumDestSBLsToBePrinted)}

        {We are done printing the report if we have gone through all the codes.}

      Result := not DoneWithReport; {False = stop}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrintPage}

{==========================================================}
Procedure TKeyChangeForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TKeyChangeForm.FormCloseQuery(    Sender: TObject;
                                        var CanClose: Boolean);

begin
(*  EntriesExist := False;

  If ((NumEntriesInGridCol(SourceGrid, 0) > 0) or
      (NumEntriesInGridCol(DestGrid, 0) > 0))
    then EntriesExist := True;

  If (EntriesExist and
      (MessageDlg('You are in the middle of a ' + ConvertModeToStr(Mode) + '.' + #13 +
                  'Do you want to close anyway?', mtWarning, [mbYes, mbNo], 0) = idNo))
    then CanClose := False; *)

end;  {FormCloseQuery}

{===================================================================}
Procedure TKeyChangeForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

  If GlblModifyBothYears
    then
      begin
        OppositeYearParcelTable.Close;
        OppositeYearParcelSDTable.Close;

        OppositeYearParcelTable.Free;
        OppositeYearParcelSDTable.Free;

      end;  {If GlblModifyBothYears}

    {CHG02232001-1: Let them modify the defaults.}

  FreeTList(DestParcelInfoList, SizeOf(DestinationParcelInformationRecord));

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.