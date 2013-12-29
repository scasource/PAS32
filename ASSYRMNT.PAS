unit Assyrmnt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, Mask, DBCtrls,
  Wwkeycb, DB, DBTables, Wwtable, Wwdatsrc, Printrng, Btrvdlg, Grids,
  DBGrids, DBLookup, RPBase, RPCanvas, RPrinter, Wwdbigrd, Wwdbgrid,
  TabNotBk, RPFiler, DBIProcs, RPDefine, wwdblook, Types;

type
  TAssYearControlForm = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    TitleLabel: TLabel;
    YearLabel: TLabel;
    MainDataSource: TDataSource;
    Panel2: TPanel;
    MainCodeLabel: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    SaveButton: TBitBtn;
    ExitButton: TBitBtn;
    EditTaxYear: TDBEdit;
    EditNextSplitMergeNo: TDBEdit;
    CancelButton: TBitBtn;
    NextMunCollNoDBEdit: TDBEdit;
    NextSchoolCollNoDBEdit: TDBEdit;
    DBEdit3: TDBEdit;
    EditValuationDate: TDBEdit;
    EditTaxableStatusDate: TDBEdit;
    Label2: TLabel;
    Label4: TLabel;
    MainTable: TTable;
    Label7: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    gbxCountyVeteranLimits: TGroupBox;
    DisabledVetLabel: TLabel;
    VetMaxLabel: TLabel;
    CombatVetlbl: TLabel;
    EditDisabledVetTownCityMax: TDBEdit;
    EditVetCountyMax: TDBEdit;
    EditCombatVetTownCityMax: TDBEdit;
    FinalRollDateEdit: TDBEdit;
    Navigator: TDBNavigator;
    VeteransLimitTable: TwwTable;
    SBLPanel: TPanel;
    Label14: TLabel;
    SBLSegmentGrid: TStringGrid;
    OKButton: TBitBtn;
    BitBtn1: TBitBtn;
    SeperatorsGroupBox: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    EditLotSeparator: TDBEdit;
    EditSectionSeparator: TDBEdit;
    EditBlockSeparator: TDBEdit;
    EditSubsectionSeparator: TDBEdit;
    EditSublotSeparator: TDBEdit;
    SBLFormatButton: TButton;
    Label1: TLabel;
    EditGrievenceFrozenDate: TDBEdit;
    Label21: TLabel;
    VeteransMaximumLookupComboBox: TwwDBLookupCombo;
    gbxCountyColdWarVeteranLimits: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    edDisabledColdWarVeteranLimit: TDBEdit;
    edBasicColdWarVeteranLimit: TDBEdit;
    edColdWarBasicCountyPercent: TDBEdit;
    cbxCountyColdWarVeteranLimitCode: TwwDBLookupCombo;
    tbColdWarVeteranLimits: TwwTable;
    dsColdWarVeteranLimits: TwwDataSource;
    MainTableTaxRollYr: TStringField;
    MainTableNextSplitMergeNo: TIntegerField;
    MainTableNxtMunTaxCollNo: TIntegerField;
    MainTableNextVilTaxCollNo: TIntegerField;
    MainTableNextSchTaxCollNo: TIntegerField;
    MainTableValuationDate: TDateField;
    MainTableTaxableStatusDate: TDateField;
    MainTableFinalRollDate: TDateField;
    MainTableVeteransLimitSet: TStringField;
    MainTableEligibleFundsCntyMax: TIntegerField;
    MainTableVeteranCntyMax: TIntegerField;
    MainTableCombatVetCntyMax: TIntegerField;
    MainTableDisabledVetCntyMax: TIntegerField;
    MainTableMunicEqualRate: TFloatField;
    MainTableMunicResAssessRatio: TFloatField;
    MainTableMunicUniformPercentValue: TFloatField;
    MainTableSectionLJust: TBooleanField;
    MainTableSectionRJust: TBooleanField;
    MainTableSectionNumeric: TBooleanField;
    MainTableSectionAlphaNum: TBooleanField;
    MainTableSectionAlpha: TBooleanField;
    MainTableSectionSRAZ: TBooleanField;
    MainTableSubsectionLJust: TBooleanField;
    MainTableSubsectionRJust: TBooleanField;
    MainTableSubsectionNumeric: TBooleanField;
    MainTableSubsectionAlphaNum: TBooleanField;
    MainTableSubsectionAlpha: TBooleanField;
    MainTableSubsectionSRAZ: TBooleanField;
    MainTableBlockLJust: TBooleanField;
    MainTableBlockRJust: TBooleanField;
    MainTableBlockNumeric: TBooleanField;
    MainTableBlockAlphaNum: TBooleanField;
    MainTableBlockAlpha: TBooleanField;
    MainTableBlockSRAZ: TBooleanField;
    MainTableLotLJust: TBooleanField;
    MainTableLotRJust: TBooleanField;
    MainTableLotNumeric: TBooleanField;
    MainTableLotAlphaNum: TBooleanField;
    MainTableLotAlpha: TBooleanField;
    MainTableLotSRAZ: TBooleanField;
    MainTableSublotLJust: TBooleanField;
    MainTableSublotRJust: TBooleanField;
    MainTableSublotNumeric: TBooleanField;
    MainTableSublotAlphaNum: TBooleanField;
    MainTableSublotAlpha: TBooleanField;
    MainTableSublotSRAZ: TBooleanField;
    MainTableSuffixLJust: TBooleanField;
    MainTableSuffixRJust: TBooleanField;
    MainTableSuffixNumeric: TBooleanField;
    MainTableSuffixAlphaNum: TBooleanField;
    MainTableSuffixAlpha: TBooleanField;
    MainTableSuffixSRAZ: TBooleanField;
    MainTableSectionSeparator: TStringField;
    MainTableSubsectionSeparator: TStringField;
    MainTableBlockSeparator: TStringField;
    MainTableLotSeparator: TStringField;
    MainTableSublotSeparator: TStringField;
    MainTableSectionDigits: TIntegerField;
    MainTableSubsectionDigits: TIntegerField;
    MainTableBlockDigits: TIntegerField;
    MainTableLotDigits: TIntegerField;
    MainTableSublotDigits: TIntegerField;
    MainTableSuffixDigits: TIntegerField;
    MainTableGrievanceFreezeDate: TDateField;
    MainTableColdWarVetCntyLimitSet: TStringField;
    Label20: TLabel;
    wwDBLookupCombo1: TwwDBLookupCombo;
    procedure SaveButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CancelButtonClick(Sender: TObject);
    procedure EditSeniorSTARLimitEnter(Sender: TObject);
    procedure EditSeniorSTARLimitExit(Sender: TObject);
    procedure VeteransMaximumLookupComboBoxChange(Sender: TObject);
    procedure SBLSegmentGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure SBLSegmentGridClick(Sender: TObject);
    procedure SBLFormatButtonClick(Sender: TObject);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure CancelSegmentFormatButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure MainTableBeforeEdit(DataSet: TDataset);
    procedure FormActivate(Sender: TObject);

  private
    UnitName : String; {For error dialog box}
  public
    FormAccessRights : Integer; {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    InitializingForm, ClosingForm : Boolean;
    OriginalVeteransSet : String;
    FirstSBLFormatFieldOffset : Integer;  {Where is the first field of the SBL format fields?}
    Procedure InitializeForm;
  end;

implementation

{$R *.DFM}

uses
  Preview,   {Print preview form}
  Utilitys,  {General utilities}
  GlblVars,  {Global variables}
  GlblCnst,
  Prog,
  RTCalcul,
  PASUTILS, UTILEXSD,   {PAS specific utilites}
  DataAccessUnit,
  WinUtils;  {Windows specific utilities}

type
  SBLSegmentArrayType = Array[1..6, 1..6] of Boolean;
  SBLSegmentTextArrayType = Array[1..6, 1..7] of String;

var
  SBLSegmentArray : SBLSegmentArrayType;
  SBLSegmentTextArray : SBLSegmentTextArrayType;

{======================================================================}
Procedure TAssYearControlForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{======================================================================}
Procedure TAssYearControlForm.InitializeForm;

{Open the tables.}

var
  TaxRollYear : String;

begin
  ClosingForm := False;
  UnitName := 'ASSYRMNT.PAS';  {mmm}

  TaxRollYear := GetTAxRlYr;
  InitializingForm := True;

  If not ModifyAccessAllowed(FormAccessRights)
    then
      begin
        MainTable.ReadOnly := True;
        SaveButton.Enabled := False;

      end;  {If (GlblTaxYearFlg = 'History')}

    {Set a label in the upper right to indicate if they
     are doing this year, next year, or history.}

  YearLabel.Caption := GetTaxYrLbl;

    {Open the main table.}

  OpenTablesForForm(Self, GlblProcessingType);

    {FXX11191999-9: Need to set range for history.}

  If (GlblProcessingType = History)
    then MainTable.SetRange([GlblHistYear], [GlblHistYear]);

    {If for some reason there is no assessment year yet, let's insert it now.
     This should really only happen while we are testing.}

  If ((MainTable.RecordCount = 0) and
      (not MainTable.ReadOnly))
    then MainTable.Insert;

    {Only show the navigator for our internal ID.}
    {Also only allow edit of tax year and split merge number for supervisor.}
    {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}

  If UserIsSupervisor(GlblUserName)
    then
      begin
        MakeEditNotReadOnly(EditTaxYear);
        MakeEditNotReadOnly(EditNextSplitMergeNo);
      end;

    {FXX12021997-1: Set the field format for the STAR fields.}

  SetDisplayFormatForCurrencyFields(Self, True);
(*  MainTableResSalePriceDiffFact.DisplayFormat := ExtendedDecimalDisplay;
  MainTableEnhSalePriceDiffFact.DisplayFormat := ExtendedDecimalDisplay;*)

    {Center the SBL panel in case we forgot to last time.}

  SBLPanel.Left := (Width - SBLPanel.Width) DIV 2;
  SBLPanel.Top := 25;

    {Where is the first field of the SBL format fields?}

  FirstSBLFormatFieldOffset := MainTable.FindField('SectionLJust').Index;
  _Locate(tbColdWarVeteranLimits, [MainTable.FieldByName('ColdWarVetCntyLimitSet').AsString], '', []);

  InitializingForm := False;

end;  {InitializeForm}

{===================================================================}
Procedure TAssYearControlForm.FormKeyPress(Sender: TObject;
                                        var Key: Char);

{Change carriage return into tab.}

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NextDlgCtl, 0, 0);
        Key := #0;
      end;  {If (Key = #13)}

end;  {FormKeyPress}

{=======================================================================}
Procedure TAssYearControlForm.VeteransMaximumLookupComboBoxChange(Sender: TObject);

{FXX06241998-1: The veterans maximums need to be at the county and swis level.}
{Set the town limits according to the new vet limit set.}

begin
  If not (InitializingForm or ClosingForm)
    then
      with MainTable do
        begin
          FieldByName('EligibleFundsCntyMax').AsFloat := VeteransLimitTable.FieldByName('EligibleFundsLimit').AsFloat;
          FieldByName('VeteranCntyMax').AsFloat := VeteransLimitTable.FieldByName('BasicVetLimit').AsFloat;
          FieldByName('CombatVetCntyMax').AsFloat := VeteransLimitTable.FieldByName('CombatVetLimit').AsFloat;
          FieldByName('DisabledVetCntyMax').AsFloat := VeteransLimitTable.FieldByName('DisabledVetLimit').AsFloat;

        end;  {with VeteransLimitTable, MainTable do}

end;  {VeteransMaximumLookupComboBoxChange}

{==================================================================================}
Procedure TAssYearControlForm.EditSeniorSTARLimitEnter(Sender: TObject);

{Set the currency display to not have any commas or dollar sign for editing purpose.}
{FXX12021997-1: Set the field format for the STAR fields.}

var
  TempField : TCurrencyField;

begin
  TempField := TCurrencyField(MainTable.FieldByName(TDBEdit(Sender).DataField));

  with TempField do
    If ((DataType = ftCurrency) and
         Currency)
      then DisplayFormat := CurrencyEditDisplay;

  TDBEdit(Sender).SelectAll;

end;  {EditEnter}

{==================================================================================}
Procedure TAssYearControlForm.EditSeniorSTARLimitExit(Sender: TObject);

{Change the currency field back to normal display format.}
{FXX12021997-1: Set the field format for the STAR fields.}

var
  TempField : TCurrencyField;

begin
  TempField := TCurrencyField(MainTable.FieldByName(TDBEdit(Sender).DataField));

  with TempField do
    If ((DataType = ftCurrency) and
         Currency)
      then DisplayFormat := CurrencyNormalDisplay;

end;  {EditExit}

{FXX02101999-3 Split the SBL format into a by year item.}
{====================================================================}
Procedure TAssYearControlForm.SBLSegmentGridDrawCell(Sender: TObject;
                                                     Col,
                                                     Row: Longint;
                                                     Rect: TRect;
                                                     State: TGridDrawState);

var
  DrawRow, DrawCol : LongInt;

begin
  DrawRow := Row;
  DrawCol := Col;

    {FXX11021999-12: Allow the # of forced digits in each segment to be specified.}

  with SBLSegmentGrid do
  If (DrawRow = 0)
    then
      begin
           {Fill in the headers.}

        Font.Size := 10;
        Font.Color := clBlack;
        Font.Style := [fsBold];
        Canvas.Brush.Color := clBtnFace;

        case DrawCol of
          0 : CenterText(Rect, Canvas, '', True, False, clBlue);
          1 : CenterText(Rect, Canvas, 'Section', True, False, clBlue);
          2 : CenterText(Rect, Canvas, 'Subsect', True, False, clBlue);
          3 : CenterText(Rect, Canvas, 'Block', True, False, clBlue);
          4 : CenterText(Rect, Canvas, 'Lot', True, False, clBlue);
          5 : CenterText(Rect, Canvas, 'Sublot', True, False, clBlue);
          6 : CenterText(Rect, Canvas, 'Suffix', True, False, clBlue);

        end;  {case DrawRow of}

      end
    else
      begin
        case DrawCol of
          0 : begin  {Row headers}
                case DrawRow of
                  1 : CenterText(Rect, Canvas, 'L Just', True, False, clBlue);
                  2 : CenterText(Rect, Canvas, 'R Just', True, False, clBlue);
                  3 : CenterText(Rect, Canvas, 'Numeric', True, False, clBlue);
                  4 : CenterText(Rect, Canvas, 'AlphaNum', True, False, clBlue);
                  5 : CenterText(Rect, Canvas, 'Alpha', True, False, clBlue);
                  6 : CenterText(Rect, Canvas, 'SRAZ', True, False, clBlue);
                  7 : CenterText(Rect, Canvas, 'Digits', True, False, clBlue);

                end;  {case Row of}

              end;   {Row headers}

          1..6 :
            If (DrawRow = 7)
              then
                begin
                  Canvas.Brush.Color := clWindow;
                  RightJustifyText(Rect, Canvas,
                                   Cells[DrawCol, DrawRow],
                                   True, False, clBlue, 1);
                end
              else
                begin  {Each of the segments}
                  If SBLSegmentArray[DrawCol, DrawRow]
                    then Canvas.Brush.Color := clGreen
                    else Canvas.Brush.Color := clWindow;

                  CenterText(Rect, Canvas, '',
                             True, False, clBlue);

                 end;  {Each of the segments}

        end;  {case Col of}

      end;  {else of If (Row = 0)}

end;  {SBLSegmentGridDrawCell}

{=======================================================================}
Procedure TAssYearControlForm.SBLSegmentGridClick(Sender: TObject);

begin
  with SBLSegmentGrid do
    If ((Row in [1..6]) and
        (Col in [1..6]))
      then
        begin
          SBLSegmentArray[Col, Row] := not SBLSegmentArray[Col, Row];

          SBLSegmentGridDrawCell(SBLSegmentGrid, Col, Row, CellRect(Col, Row), []);

        end;  {If ((Row in [1..6]) and ...}

end;  {SBLSegmentGridClick}

{=====================================================================}
Procedure TAssYearControlForm.SBLFormatButtonClick(Sender: TObject);

var
  TempRow, TempCol : Integer;
  FieldPos : Integer;

begin
    {If they are not in edit mode, then put them in it.}

  with MainTable do
    If ((not ReadOnly) and
        (not (State in [dsEdit, dsInsert])))
      then Edit;

  For TempCol := 1 to 6 do
    For TempRow := 1 to 6 do
      SBLSegmentArray[TempCol, TempRow] := False;

    {Now fill in the array. Note that this is based on the order
     of the fields in the FieldsEditor, so DO NOT CHANGE THE ORDER!}
    {FXX11021999-12: Allow the # of forced digits in each segment to be specified.}

  For TempCol := 1 to 6 do
    For TempRow := 1 to 7 do
      begin
        FieldPos := FirstSBLFormatFieldOffset + (TempRow + (TempCol - 1) * 7) - 1;

        If (TempRow <= 6)
          then SBLSegmentArray[TempCol, TempRow] := MainTable.Fields[FieldPos].AsBoolean;

      end;  {For TempRow := 1 to 6 do}

  For TempCol := 1 to 6 do
    For TempRow := 1 to 7 do
      begin
        FieldPos := FirstSBLFormatFieldOffset + (TempRow + (TempCol - 1) * 7) - 1;

        SBLSegmentTextArray[TempCol, TempRow] := MainTable.Fields[FieldPos].AsString;

        If (TempRow = 7)
          then SBLSegmentGrid.Cells[TempCol, TempRow] := SBLSegmentTextArray[TempCol, TempRow];

      end;  {For TempRow := 1 to 7 do}

  SBLPanel.Show;
  SBLSegmentGrid.Repaint;

end;  {SBLFormatButtonClick}

{==================================================================}
Procedure TAssYearControlForm.MainTableBeforeEdit(DataSet: TDataset);

{FXX11191999-2: Automatically recalculate exemptions and roll totals if needed.}

begin
  OriginalVeteransSet := MainTable.FieldByName('VeteransLimitSet').Text;
end;

{===================================================================}
Procedure TAssYearControlForm.MainTableBeforePost(DataSet: TDataset);

begin
  with MainTable do
    begin
      FieldByName('SectionSeparator').Text := Take(1, FieldByName('SectionSeparator').Text);
      FieldByName('SubsectionSeparator').Text := Take(1, FieldByName('SubsectionSeparator').Text);
      FieldByName('BlockSeparator').Text := Take(1, FieldByName('BlockSeparator').Text);
      FieldByName('LotSeparator').Text := Take(1, FieldByName('LotSeparator').Text);
      FieldByName('SublotSeparator').Text := Take(1, FieldByName('SublotSeparator').Text);

    end;  {with MainTable do}

end;  {MainTable}

{==============================================================}
Procedure TAssYearControlForm.CancelSegmentFormatButtonClick(Sender: TObject);

begin
  SBLPanel.Visible := False;
end;

{================================================================}
Procedure TAssYearControlForm.OKButtonClick(Sender: TObject);

{Store the changes in the system record.}

var
  Col, Row, FieldPos : Integer;

begin
  SBLPanel.Visible := False;

    {Now fill in the array. Note that this is based on the order
     of the fields in the FieldsEditor, so DO NOT CHANGE THE ORDER!}
    {FXX11021999-12: Allow the # of forced digits in each segment to be specified.}

  If (MainTable.State in [dsInsert, dsEdit])
    then
      For Col := 1 to 6 do
        For Row := 1 to 7 do
          begin
            FieldPos := FirstSBLFormatFieldOffset + (Row + (Col - 1) * 7) - 1;

            If (Row <= 6)
              then MainTable.Fields[FieldPos].AsBoolean := SBLSegmentArray[Col, Row]
              else
                try
                  MainTable.Fields[FieldPos].AsInteger := StrToInt(SBLSegmentGrid.Cells[Col, Row]);
                except
                  MainTable.Fields[FieldPos].AsInteger := 0;
                end;

          end;  {For Row := 1 to 6 do}

end;  {OKButtonClick}

{================================================================}
Procedure TAssYearControlForm.MainTableAfterPost(DataSet: TDataset);

var
  Quit : Boolean;

begin
  SetGlobalSBLSegmentFormats(MainTable);

    {FXX11191999-2: Automatically recalculate exemptions and roll totals if needed.}

  If (Take(1, OriginalVeteransSet) <>
      Take(1, MainTable.FieldByName('VeteransLimitSet').Text))
    then
      If (MessageDlg('The exemptions and roll totals must be recalculated due' + #13 +
                     'to a change in the veteran''s limits.' + #13 +
                     'Do you want to recalculate now?' + #13 +
                     'If you do not, you will need to do it manually later.',
                     mtConfirmation, [mbYes, mbNo], 0) = idYes)
        then
          begin
            ProgressDialog.Start(1, False, False);
            RecalculateAllExemptions(Self, ProgressDialog,
                                     GlblProcessingType, GetTaxRlYr, True, Quit);
            CreateRollTotals(GlblProcessingType, GetTaxRlYr,
                             ProgressDialog, Self, False, True);

          end;  {If (MessageDlg('The exemptions ...}

end;

{==================================================================================}
Procedure TAssYearControlForm.SaveButtonClick(Sender: TObject);

begin
  If (MainTable.Modified and  {Table is modified.}
      (MainTable.State in [dsEdit, dsInsert]) and
      ((not GlblAskSave) or     {We should not confirm a save or...}
       (GlblAskSave and        {We should confirm a save and...}
        (MessageDlg('Do you want to save these assessment year changes?', mtConfirmation,
                    [mbYes, mbCancel], 0) = mrYes))))  {They want to save it.}
    then
      try
        MainTable.Post;
      except
        SystemSupport(001, MainTable, 'Error posting assessment year control file.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {SaveButtonClick}

{======================================================================}
Procedure TAssYearControlForm.CancelButtonClick(Sender: TObject);

begin
  If ((not MainTable.ReadOnly) and
      (MainTable.Modified) and
      (MainTable.State in [dsEdit, dsInsert]))
    then
      If (MessageDlg('You will lose all changes.' + #13 +
                     'Do you want to cancel anyway?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)
        then MainTable.Cancel;

end;  {CancelButtonClick}

{===================================================================}
Procedure TAssYearControlForm.ExitButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TAssYearControlForm.FormCloseQuery(    Sender: TObject;
                                            var CanClose: Boolean);

{If there are any changes, let's ask them if they want to save
 them (or cancel).}

var
  ReturnCode : Integer;

begin
  ClosingForm := True;
    {First see if anything needs to be saved. In order to
     determine if there are any changes, we need to sychronize
     the fields with what is in the DB edit boxes. To do this,
     we call the UpdateRecord. Then, if there are any changes,
     the Modified flag will be set to True.}

  If (MainTable.State in [dsInsert, dsEdit])
    then MainTable.UpdateRecord;

  If ((not MainTable.ReadOnly) and
      (MainTable.State in [dsEdit, dsInsert]) and
      MainTable.Modified)
    then
      begin
        ReturnCode := MessageDlg('Do you wish to save your assessment year changes?', mtConfirmation,
                                 [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idYes : MainTable.Post;

          idNo : MainTable.Cancel;

          idCancel : CanClose := False;

        end;  {case ReturnCode of}

      end;  {If ((not MainTable.ReadOnly) and ...}

  ClosingForm := False;

end;  {FormCloseQuery}

{===================================================================}
Procedure TAssYearControlForm.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

{Note that if we get here, we are definately closing the form
 since the CloseQuery event is called first. In CloseQuery, if
 there are any modifications, they have a chance to cancel
 then.}

begin
  ClosingForm := True;

    {Make sure that we close the tables.}

  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

  ClosingForm := False;

end;  {FormClose}


end.