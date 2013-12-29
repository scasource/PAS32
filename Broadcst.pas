unit Broadcst;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  TabNotBk, Types, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Progress,
  ComCtrls;

type
  ChangeRecord = record
    ScreenName,
    TableName,
    FieldName,
    LabelName : String;
    NewValue : String;
  end;

  ChangeRecordPtr = ^ChangeRecord;

type
  TBroadcastForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    TitleLabel: TLabel;
    PropertyClassTable: TwwTable;
    ParcelTable: TTable;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    SwisCodeTable: TTable;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    NotebookChangeTimer: TTimer;
    OpenDialog: TOpenDialog;
    SchoolCodeTable: TTable;
    SDCodeTable: TTable;
    ExemptionCodeTable: TTable;
    ScreenLabelTable: TTable;
    TempTable: TTable;
    Label11: TLabel;
    Label12: TLabel;
    AuditTable: TTable;
    UserFieldDefinitionTable: TTable;
    CommercialSiteTable: TTable;
    ResidentialSiteTable: TTable;
    ResidentialBldgTable: TTable;
    CommercialBldgTable: TTable;
    CodeTable: TTable;
    Notebook: TTabbedNotebook;
    Label2: TLabel;
    AssessmentYearRadioGroup: TRadioGroup;
    BroadcastMethodRadioGroup: TRadioGroup;
    TrialRunCheckBox: TCheckBox;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Screen1ComboBox: TComboBox;
    Field1ComboBox: TComboBox;
    Change1Edit: TEdit;
    Screen2ComboBox: TComboBox;
    Field2ComboBox: TComboBox;
    Change2Edit: TEdit;
    Screen3ComboBox: TComboBox;
    Field3ComboBox: TComboBox;
    Change3Edit: TEdit;
    Label1: TLabel;
    ExemptionListBox: TListBox;
    Label3: TLabel;
    SpecialDistrictListBox: TListBox;
    Label18: TLabel;
    PropertyClassListBox: TListBox;
    GroupBox2: TGroupBox;
    Label19: TLabel;
    SelectCodeTableLabel: TLabel;
    Label21: TLabel;
    ClearCodeTableFirstCheckBox: TCheckBox;
    FillCorrespondingCodeTableCheckBox: TCheckBox;
    CodeTableComboBox: TComboBox;
    Panel3: TPanel;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    edHistoryYear: TEdit;
    gbxOptions: TGroupBox;
    AddInventorySitesCheckBox: TCheckBox;
    cbxOnlyBroadcastToBlankValues: TCheckBox;
    cbLocateByAccountNumber: TCheckBox;
    tbUserData: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure AssessmentYearRadioGroupClick(Sender: TObject);
    procedure ScreenComboBoxChange(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FillCorrespondingCodeTableCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;

    AssessmentYear : String;
    ProcessingType,
    BroadcastMethod : Integer;
    SelectedExemptionCodes,
    SelectedSpecialDistricts : TStringList;
    PrintAllPropertyClasses,
    TrialRun, ReportCancelled,
    AddInventorySites, bOnlyUpdateBlankValues : Boolean;
    ScreenLabelList, ChangeRecList : TList;
    ImportFileName : String;
    ReportSection : Char;
    SelectedPropertyClasses : TStringList;
    CorrespondingTableName : String;
    FillCorrespondingCodeTable, ClearCodeTableFirst : Boolean;
    RejectedDueToFrozenBankCodeList : TStringList;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure FillListBoxes(AssessmentYear : String);

    Procedure FillChangeBoxes(ScreenComboBox,
                              FieldComboBox : TComboBox;
                              ScreenLabelList : TList;
                              FillScreenBox,
                              FillFieldBox : Boolean);

    Procedure GetChangesToDo(ChangeRecList : TList);

    Function ValidSelections : Boolean;

    Function InPropertyClassRange(PropertyClass : String) : Boolean;

    Procedure PrintBadParcels(Sender : TObject;
                              BadParcelList : TStringList);

    Function BroadcastChange(    Sender : TObject;
                                 ParcelTable,
                                 TempTable,
                                 AuditTable : TTable;
                                 SwisSBLKey : String;
                                 ProcessingType : Integer;
                                 AssessmentYear : String;
                                 sPropertyClassCode : String;
                                 sOwnershipCode : String;
                                 ChangeRec : ChangeRecord;
                                 SelectedExemptionCodes,
                                 SelectedSpecialDistricts : TStringList;
                                 ScreenLabelList : TList;
                                 TrialRun : Boolean;
                             var Quit : Boolean) : Boolean;

    Procedure BroadcastByImportFile(    Sender : TObject;
                                        ParcelTable,
                                        TempTable,
                                        AuditTable : TTable;
                                        BroadcastMethod : Integer;
                                        ChangeRecList : TList;
                                        ImportFileName : String;
                                        TrialRun : Boolean;
                                        ProcessingType : Integer;
                                        AssessmentYear : String;
                                    var NumParcelsBroadcasted : LongInt);

    Procedure BroadcastByParcelList(    Sender : TObject;
                                        ParcelTable,
                                        TempTable,
                                        AuditTable : TTable;
                                        ChangeRecList : TList;
                                        SelectedExemptionCodes,
                                        SelectedSpecialDistrictCodes : TStringList;
                                        TrialRun : Boolean;
                                        ProcessingType : Integer;
                                    var NumParcelsBroadcasted : LongInt);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, UTILEXSD, GlblCnst, PASUtils,
     DataAccessUnit, UTILRTOT,  {Roll total update unit.}
     PRCLLIST,  {Parcel list}
     Prog,
     Preview, PASTypes;

const
    {Assessment Years}
  ayThisYear = 0;
  ayNextYear = 1;
  ayBothYears = 2;
  aySales = 3;
  ayHistory = 4;

    {Broadcast methods}

  bmImportFile_TabDelimited = 0;
  bmImportFile_CommaDelimited = 1;
  bmParcelList = 2;

{$R *.DFM}

{========================================================}
procedure TBroadcastForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TBroadcastForm.FillListBoxes(AssessmentYear : String);

{Fill in all the list boxes on the various notebook pages.}

var
  ProcessingType : Integer;
  Quit : Boolean;

begin
  ProcessingType := GetProcessingTypeForTaxRollYear(AssessmentYear);

  OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(SDCodeTable, SdistCodeTableName,
                             ProcessingType, Quit);

  FillOneListBox(ExemptionListBox, ExemptionCodeTable, 'EXCode',
                 'Description', 10, True, False, ProcessingType, AssessmentYear);

  FillOneListBox(SpecialDistrictListBox, SDCodeTable, 'SDistCode',
                 'Description', 10, True, False, ProcessingType, AssessmentYear);

  SelectItemsInListBox(ExemptionListBox);
  SelectItemsInListBox(SpecialDistrictListBox);

end;  {FillListBoxes}

{========================================================}
Procedure TBroadcastForm.FillChangeBoxes(ScreenComboBox,
                                         FieldComboBox : TComboBox;
                                         ScreenLabelList : TList;
                                         FillScreenBox,
                                         FillFieldBox : Boolean);

var
  I : Integer;

begin
    {Add blank items to the front of the list to blank it out.}

  If FillScreenBox
    then
      begin
        ScreenComboBox.Items.Clear;

        For I := 0 to (ScreenLabelList.Count - 1) do
          If (ScreenComboBox.Items.IndexOf(RTrim(ScreenLabelPtr(ScreenLabelList[I])^.ScreenName)) = -1)
            then ScreenComboBox.Items.Add(RTrim(ScreenLabelPtr(ScreenLabelList[I])^.ScreenName));

        ScreenComboBox.Items.Insert(0, '');

      end;  {If FillScreenBox}

  If FillFieldBox
    then
      begin
        FieldComboBox.Items.Clear;

        For I := 0 to (ScreenLabelList.Count - 1) do
          If (RTrim(ScreenLabelPtr(ScreenLabelList[I])^.ScreenName) =
              ScreenComboBox.Items[ScreenComboBox.ItemIndex])
            then FieldComboBox.Items.Add(RTrim(ScreenLabelPtr(ScreenLabelList[I])^.LabelName));

        FieldComboBox.Items.Insert(0, '');

      end;  {If FillFieldBox}

end;  {FillChangeBoxes}

{========================================================}
Procedure TBroadcastForm.InitializeForm;

begin
  UnitName := 'BROADCST';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

  AssessmentYear := GetTaxRlYr;

  FillListBoxes(AssessmentYear);
  FillOneListBox(PropertyClassListBox, PropertyClassTable, 'MainCode',
                 'Description', 17, True, True, ProcessingType, AssessmentYear);
  SelectItemsInListBox(PropertyClassListBox);

     {FXX11191999-7: Add user defined fields to search, audit, broadcast.}

  If (GlblProcessingType = History)
    then SetRangeOld(UserFieldDefinitionTable,
                     ['TaxRollYr', 'DisplayOrder'],
                     [GlblHistYear, '0'],
                     [GlblHistYear, '32000']);

  ScreenLabelList := TList.Create;

  LoadScreenLabelList(ScreenLabelList, ScreenLabelTable, UserFieldDefinitionTable, True,
                      True, True, [slAll]);

  FillChangeBoxes(Screen1ComboBox, Field1ComboBox, ScreenLabelList, True, False);
  FillChangeBoxes(Screen2ComboBox, Field2ComboBox, ScreenLabelList, True, False);
  FillChangeBoxes(Screen3ComboBox, Field3ComboBox, ScreenLabelList, True, False);

    {CHG04192001-1: Option to fill in the corresponding code table if they are loading
                    into a code field from a file.}

  Session.GetTableNames(CodeTable.DatabaseName,
                        'Z*.*', False, False, CodeTableComboBox.Items);

end;  {InitializeForm}

{===================================================================}
Procedure TBroadcastForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{==========================================================}
Procedure TBroadcastForm.AssessmentYearRadioGroupClick(Sender: TObject);

begin
  case AssessmentYearRadioGroup.ItemIndex of
    ayThisYear,
    ayBothYears : FillListBoxes(GlblThisYear);

    ayNextYear : FillListBoxes(GlblNextYear);

  end;  {case AssessmentYearRadioGroup.ItemIndex of}

end;  {AssessmentYearRadioGroupClick}

{=========================================================}
Procedure TBroadcastForm.ScreenComboBoxChange(Sender: TObject);

{Synchronize the field combo box with the screen combo box.}

var
  LineNum : Integer;
  TempFieldComboBox : TComboBox;
  TempEdit : TEdit;
  TempName : String;

begin
  LineNum := StrToInt(TComboBox(Sender).Name[7]);
  TempName := 'Field' + IntToStr(LineNum) + 'ComboBox';
  TempFieldComboBox := TComboBox(Self.FindComponent(TempName));
  TempName := 'Change' + IntToStr(LineNum) + 'Edit';
  TempEdit := TEdit(Self.FindComponent(TempName));

  with Sender as TComboBox do
    If (Deblank(Text) = '')
      then
        begin
            {They selected a blank screen - blank out the field and value.}

          TempFieldComboBox.ItemIndex := 0;  {The first value is blank.}
          TempEdit.Text := '';
        end
      else
        begin
          FillChangeBoxes(TComboBox(Sender), TempFieldComboBox,
                          ScreenLabelList, False, True);

        end;  {else of If (Deblank(Text) = '')}

end;  {ScreenComboBoxChange}

{===================================================================}
Procedure TBroadcastForm.FillCorrespondingCodeTableCheckBoxClick(Sender: TObject);

var
  _Enabled : Boolean;

begin
  _Enabled := FillCorrespondingCodeTableCheckBox.Checked;

  SelectCodeTableLabel.Enabled := _Enabled;
  ClearCodeTableFirstCheckBox.Enabled := _Enabled;
  CodeTableComboBox.Enabled := _Enabled;

end;  {FillCorrespondingCodeTableCheckBoxClick}
{=============================================================================}
Procedure UpdateCodeDescription(tbTemp : TTable;
                                sTableName : String;
                                sFieldName : String;
                                sNewValue : String);

begin
  with tbTemp do
    try
      If _Compare(sTableName, ResidentialSiteTableName, coEqual)
        then
          begin
            If _Compare(sFieldName, 'NghbrhdRatingCode', coEqual)
              then FieldByName('NghbrhdRatingDesc').AsString := GetCodeDescription(sNewValue,
                                                                                   'zinvnghbrhdratingtbl');
            If _Compare(sFieldName, 'NghbrhdTypeCode', coEqual)
              then FieldByName('NghbrhdTypeDesc').AsString := GetCodeDescription(sNewValue,
                                                                                 'ZInvNghbrhdTypeTbl');
            If _Compare(sFieldName, 'RoadTypeCode', coEqual)
              then FieldByName('RoadTypeDesc').AsString := GetCodeDescription(sNewValue,
                                                                              'ZInvRoadTypeTbl');
            If _Compare(sFieldName, 'UtilityTypeCode', coEqual)
              then FieldByName('UtilityTypeDesc').AsString := GetCodeDescription(sNewValue,
                                                                                 'zinvutilitytbl');
            If _Compare(sFieldName, 'D_CEntryTypeCode', coEqual)
              then FieldByName('D_CEntryTypeDesc').AsString := GetCodeDescription(sNewValue,
                                                                                  'ZInvEntryCodeTbl');
            If _Compare(sFieldName, 'TrafficCode', coEqual)
              then FieldByName('TrafficDesc').AsString := GetCodeDescription(sNewValue,
                                                                             'zinvtrafficcodetbl');
            If _Compare(sFieldName, 'ElevationCode', coEqual)
              then FieldByName('ElevationDesc').AsString := GetCodeDescription(sNewValue,
                                                                               'ZInvElevationCodeTbl');
            If _Compare(sFieldName, 'DesirabilityCode', coEqual)
              then FieldByName('DesirabilityDesc').AsString := GetCodeDescription(sNewValue,
                                                                                  'ZInvResSiteDesireTbl');

            If _Compare(sFieldName, 'ZoningCode', coEqual)
              then FieldByName('ZoningDesc').AsString := GetCodeDescription(sNewValue,
                                                                                  'ZInvZoningCodeTbl');

          end;  {If bFillInCodeDescriptions}

      If _Compare(sTableName, ResidentialBldgTableName, coEqual)
        then
          begin
            If _Compare(sFieldName, 'ConditionCode', coEqual)
              then FieldByName('ConditionDesc').AsString := GetCodeDescription(sNewValue,
                                                                               'zinvconditiontbl');
            If _Compare(sFieldName, 'ExtWallMaterialCode', coEqual)
              then FieldByName('ExtWallMaterialDesc').AsString := GetCodeDescription(sNewValue,
                                                                                     'ZInvExteriorWallTbl');
            If _Compare(sFieldName, 'BasementTypeCode', coEqual)
              then FieldByName('BasementTypeDesc').AsString := GetCodeDescription(sNewValue,
                                                                                  'ZInvResBasementTbl');
            If _Compare(sFieldName, 'OverallGradeCode', coEqual)
              then FieldByName('OverallGradeDesc').AsString := GetCodeDescription(sNewValue,
                                                                                  'ZInvGradeTbl');
            If _Compare(sFieldName, 'BuildingStyleCode', coEqual)
              then FieldByName('BuildingStyleDesc').AsString := GetCodeDescription(sNewValue,
                                                                                   'zinvbuildstyletbl');
            If _Compare(sFieldName, 'HeatTypeCode', coEqual)
              then FieldByName('HeatTypeDesc').AsString := GetCodeDescription(sNewValue,
                                                                              'ZInvHeatTbl');
            If _Compare(sFieldName, 'FuelTypeCode', coEqual)
              then FieldByName('FuelTypeDesc').AsString := GetCodeDescription(sNewValue,
                                                                              'ZInvFuelTbl');
            If _Compare(sFieldName, 'KitchenQualityCode', coEqual)
              then FieldByName('KitchenQualityDesc').AsString := GetCodeDescription(sNewValue,
                                                                                    'ZInvQualityTbl');
            If _Compare(sFieldName, 'BathroomQualityCode', coEqual)
              then FieldByName('BathroomQualityDesc').AsString := GetCodeDescription(sNewValue,
                                                                                     'ZInvQualityTbl');

          end;  {If _Compare(sTableName, ResidentialBldgTableName, coEqual)}

    except
    end;

end;  {UpdateCodeDescription}

{===================================================================}
Function TBroadcastForm.BroadcastChange(    Sender : TObject;
                                            ParcelTable,
                                            TempTable,
                                            AuditTable : TTable;
                                            SwisSBLKey : String;
                                            ProcessingType : Integer;
                                            AssessmentYear : String;
                                            sPropertyClassCode : String;
                                            sOwnershipCode : String;
                                            ChangeRec : ChangeRecord;
                                            SelectedExemptionCodes,
                                            SelectedSpecialDistricts : TStringList;
                                            ScreenLabelList : TList;
                                            TrialRun : Boolean;
                                        var Quit : Boolean) : Boolean;

var
  FirstTimeThrough, Done,
  ChangeThisRec, AddSiteRecord,
  IsSalesTable, IsNotesTable, bSiteFound,
  IsParcelTable, IsExemptionTable,
  IsSpecialDistrictTable, ProcessThisChange : Boolean;
  SBLRec : SBLRecord;
  OldValue : String;

begin
  Result := False;
  ProcessThisChange := True;
  TempTable.IndexName := '';
  OpenTableForProcessingType(TempTable, RTrim(ChangeRec.TableName),
                             ProcessingType, Quit);

  IsParcelTable := (Pos('PARCEL', ANSIUpperCase(TempTable.TableName)) > 0);
  IsExemptionTable := (Pos('EXEMPTIONREC', ANSIUpperCase(TempTable.TableName)) > 0);
  IsSpecialDistrictTable := (Pos('SPCLDISTREC', ANSIUpperCase(TempTable.TableName)) > 0);
  IsSalesTable := (Pos('SALE', ANSIUpperCase(TempTable.TableName)) > 0);
  IsNotesTable := (Pos('NOTE', ANSIUpperCase(TempTable.TableName)) > 0);

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  FirstTimeThrough := True;
  Done := False;

  If IsParcelTable
    then
      begin
        TempTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

        with SBLRec do
          FindKeyOld(TempTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot',
                      'Suffix'],
                     [AssessmentYear, SwisCode, Section,
                      SubSection, Block, Lot, Sublot, Suffix])
      end
    else
      begin
        TempTable.CancelRange;
        If (IsSalesTable or IsNotesTable)
          then
            begin
              TempTable.IndexName := 'BYSWISSBLKEY';
              SetRangeOld(TempTable, ['SwisSBLKey'],
                          [SwisSBLKey],[SwisSBLKey]);
            end
          else
            begin
              TempTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
              SetRangeOld(TempTable,
                          ['TaxRollYr', 'SwisSBLKey'],
                          [AssessmentYear, SwisSBLKey],
                          [AssessmentYear, SwisSBLKey]);

            end;  {else of If (IsSalesTable or IsNotesTable)}

        TempTable.First;

          {If this record does not exist and it is a residential or commercial
           inventory field, then add the record.  Also, if there are no sites,
           add one.}

        If TempTable.EOF
          then
            begin
              If _Compare(ChangeRec.TableName, 'TPRES', coStartsWith)
                then
                  begin
                    AddSiteRecord := False;

                    If _Compare(ChangeRec.TableName, ResidentialSiteTableName, coEqual)
                      then
                        begin
                          FindNearestOld(ResidentialSiteTable,
                                         ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                         [AssessmentYear, SwisSBLKey, '0']);

                          bSiteFound :=  _Compare(ResidentialSiteTable.FieldByName('SwisSBLKey').Text,
                                                  SwisSBLKey, coEqual);
                          AddSiteRecord := (AddInventorySites and (not bSiteFound) and
                                            PropertyIsResidential(sPropertyClassCode));

                        end;  {If (UpcaseStr(RTrim(ChangeRec.TableName)) = ...}

                    If not bSiteFound
                    then
                      If AddSiteRecord
                        then
                          begin
                            with ResidentialSiteTable do
                              try
                                Insert;
                                FieldByName('TaxRollYr').Text := AssessmentYear;
                                FieldByName('SwisSBLKey').Text := SwisSBLKey;
                                FieldByName('Site').AsInteger := 1;
                                Post;
                              except
                                SystemSupport(001, ResidentialSiteTable,
                                              'Error inserting residential site record for parcel ' + SwisSBLKey +
                                              '.', UnitName, GlblErrorDlgBox);
                              end;

                              {If we add a site record, we must add a building record.}

                            with ResidentialBldgTable do
                              try
                                Insert;
                                FieldByName('TaxRollYr').Text := AssessmentYear;
                                FieldByName('SwisSBLKey').Text := SwisSBLKey;
                                FieldByName('Site').AsInteger := 1;
                                Post;
                              except
  (*                              SystemSupport(002, ResidentialBldgTable,
                                              'Error inserting residential building record for parcel ' + SwisSBLKey +
                                              '.', UnitName, GlblErrorDlgBox); *)
                              end;

                          end  {If ((UpcaseStr(RTrim(ChangeRec.TableName)) = UpcaseStr(ResidentialSiteTableName)) or}
                        else ProcessThisChange := False;

                      {Now, if this is not the site, insert the subrecord.}

                    If _Compare(ChangeRec.TableName, ResidentialSiteTableName, coNotEqual)
                      then
                        with TempTable do
                          try
                            Insert;
                            FieldByName('TaxRollYr').Text := AssessmentYear;
                            FieldByName('SwisSBLKey').Text := SwisSBLKey;
                            FieldByName('Site').AsInteger := 1;

                            If _Compare(ChangeRec.TableName, ResidentialLandTableName, coEqual)
                              then FieldByName('LandNumber').AsInteger := 1;

                            If _Compare(ChangeRec.TableName, ResidentialForestTableName, coEqual)
                              then FieldByName('ForestNumber').AsInteger := 1;

                            If _Compare(ChangeRec.TableName, ResidentialImprovementsTableName, coEqual)
                              then FieldByName('ImprovementNumber').AsInteger := 1;

                            Post;
                          except
                            SystemSupport(003, TempTable,
                                          'Error inserting record for table ' + TempTable.TableName +
                                          ' Parcel ' + SwisSBLKey + '.',
                                          UnitName, GlblErrorDlgBox);
                          end;

                  end;  {If (UpcaseStr(Take(5, ChangeRec.TableName)) = 'TPRES')}

              If _Compare(ChangeRec.TableName, 'TPCOM', coStartsWith)
                then
                  begin
                   AddSiteRecord := False;

                    If _Compare(ChangeRec.TableName, CommercialSiteTableName, coStartsWith)
                      then
                        begin
                          FindNearestOld(CommercialSiteTable,
                                         ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                         [AssessmentYear, SwisSBLKey, '0']);

                          bSiteFound :=  _Compare(CommercialSiteTable.FieldByName('SwisSBLKey').Text,
                                                  SwisSBLKey, coEqual);
                          AddSiteRecord := (AddInventorySites and (not bSiteFound) and
                                            (not PropertyIsResidential(sPropertyClassCode)));

                        end;  {If (UpcaseStr(RTrim(ChangeRec.TableName)) = ...}

                    If not bSiteFound
                    then
                      If AddSiteRecord
                      then
                        begin
                          with CommercialSiteTable do
                            try
                              Insert;
                              FieldByName('TaxRollYr').Text := AssessmentYear;
                              FieldByName('SwisSBLKey').Text := SwisSBLKey;
                              FieldByName('Site').AsInteger := 1;
                              Post;
                            except
                              SystemSupport(004, CommercialSiteTable,
                                            'Error inserting commercial site record for parcel ' + SwisSBLKey +
                                            '.', UnitName, GlblErrorDlgBox);
                            end;

                          with CommercialBldgTable do
                            try
                              Insert;
                              FieldByName('TaxRollYr').Text := AssessmentYear;
                              FieldByName('SwisSBLKey').Text := SwisSBLKey;
                              FieldByName('Site').AsInteger := 1;
                              FieldByName('BuildingNumber').AsInteger := 1;
                              FieldByName('BuildingSection').AsInteger := 1;
                              Post;
                            except
                            end;

                        end  {If ((UpcaseStr(RTrim(ChangeRec.TableName)) = ...}
                      else ProcessThisChange := False;

                      {Now, if this is not the site, insert the subrecord.}

                    If _Compare(ChangeRec.TableName, CommercialSiteTableName, coNotEqual)
                      then
                        with TempTable do
                          try
                            Insert;
                            FieldByName('TaxRollYr').Text := AssessmentYear;
                            FieldByName('SwisSBLKey').Text := SwisSBLKey;
                            FieldByName('Site').AsInteger := 1;

                            If _Compare(ChangeRec.TableName, CommercialLandTableName, coEqual)
                              then FieldByName('LandNumber').AsInteger := 1;

                            If _Compare(ChangeRec.TableName, CommercialBldgTableName, coEqual)
                              then
                                begin
                                  FieldByName('BuildingNumber').AsInteger := 1;
                                  FieldByName('BuildingSection').AsInteger := 1;
                                end;

                            If _Compare(ChangeRec.TableName, CommercialImprovementsTableName, coEqual)
                              then FieldByName('ImprovementNumber').AsInteger := 1;

                            If _Compare(ChangeRec.TableName, CommercialRentTableName, coEqual)
                              then FieldByName('UseNumber').AsInteger := 1;

                            Post;
                          except
                            SystemSupport(006, TempTable,
                                          'Error inserting record for table ' + TempTable.TableName +
                                          ' Parcel ' + SwisSBLKey + '.',
                                          UnitName, GlblErrorDlgBox);
                          end;

                  end;  {If (UpcaseStr(Take(5, ChangeRec.TableName)) = 'TPCOM')}

              If (_Compare(ChangeRec.TableName, UserDataTableName, coStartsWith) and
                  (not _Locate(tbUserData, ['TaxRollYr', 'SwisSBLKey'], '', [])))
              then
                try
                  tbUserData.Insert;
                  tbUserData.FieldByName('TaxRollYr').AsString := AssessmentYear;
                  tbUserData.FieldByName('SwisSBLKey').AsString := SwisSBLKey;
                  tbUserData.Post;
                except
                end;

              TempTable.CancelRange;
              SetRangeOld(TempTable,
                          ['TaxRollYr', 'SwisSBLKey'],
                          [AssessmentYear, SwisSBLKey],
                          [AssessmentYear, SwisSBLKey]);

            end;  {If TempTable.EOF}

      end;  {else of If IsParcelTable}

  If ProcessThisChange
    then
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else TempTable.Next;

        If (IsParcelTable or
            TempTable.EOF)
          then Done := True;

        If (IsParcelTable or
            (not Done))
          then
            begin
              ChangeThisRec := True;

              If (IsExemptionTable and
                  (SelectedExemptionCodes.IndexOf(TempTable.FieldByName('ExemptionCode').Text) = -1))
                then ChangeThisRec := False;

              If (IsSpecialDistrictTable and
                  (SelectedSpecialDistricts.IndexOf(TempTable.FieldByName('SDistCode').Text) = -1))
                then ChangeThisRec := False;

                {CHG05222003-1(2.07b): If this a frozen bank code, don't update it - give a
                                       message, though.}

              If (GlblAllowBankCodeFreeze and
                  (ANSIUpperCase(Trim(ChangeRec.FieldName)) = 'BANKCODE') and
                  IsParcelTable and
                  TempTable.FieldByName('BankCodeFrozen').AsBoolean)
                then
                  begin
                    ChangeThisRec := False;
                    RejectedDueToFrozenBankCodeList.Add(SwisSBLKey);
                  end;

              OldValue := TempTable.FieldByName(RTrim(ChangeRec.FieldName)).Text;

                {CHG02272009-1(2.17.1.3): Add option to only change non-blank \ zero values.}

              If (bOnlyUpdateBlankValues and
                  _Compare(OldValue, coNotBlank) and
                  _Compare(OldValue, '0', coNotEqual) and
                  _Compare(OldValue, '0.00', coNotEqual))
                then ChangeThisRec := False;

              Result := True;

              If (ChangeThisRec and
                  (not TrialRun))
                then
                  begin
                    with TempTable do
                      try
                        Edit;

                        If IsParcelTable
                          then
                            begin
                              FieldByName('LastChangeDate').AsDateTime := Date;
                              FieldByName('LastChangeByName').Text := GlblUserName;
                            end;

                        OldValue := FieldByName(RTrim(ChangeRec.FieldName)).Text;
                        FieldByName(RTrim(ChangeRec.FieldName)).Text := ChangeRec.NewValue;

                          {Make sure that the code descriptions are in synch with the
                           code values.}

                        UpdateCodeDescription(TempTable, ChangeRec.TableName,
                                              ChangeRec.FieldName, ChangeRec.NewValue);
                        Post;
                      except
                        SystemSupport(007, TempTable, 'Error posting change for table ' +
                                           TempTable.TableName + ' , field ' +
                                           ChangeRec.FieldName + '.',
                                      UnitName, GlblErrorDlgBox);
                      end;

                      {Now put a record in the audit file.}

                    with AuditTable do
                      try
                        Insert;

                        FieldByName('TaxRollYr').Text := AssessmentYear;
                        FieldByName('SwisSBLKey').Text := SwisSBLKey;
                        FieldByName('Date').AsDateTime := Date;
                        FieldByName('Time').AsDateTime := Now;
                        FieldByName('User').Text := Take(10, GlblUserName);
                        FieldByName('LabelName').Text := Take(30, ChangeRec.LabelName);
                        FieldByName('ScreenName').Text := Take(30, ChangeRec.ScreenName);
                        FieldByName('OldValue').Text := OldValue;
                        FieldByName('NewValue').Text := ChangeRec.NewValue;

                        Post;

                      except
                        SystemSupport(008, AuditTable, 'Error inserting audit record.',
                                      UnitName, GlblErrorDlgBox);
                      end;  {with AuditTable do}

                  end;  {If (ChangeThisRec and ...}

                {Now print out the change.}

              If ChangeThisRec
                then
                  with Sender as TBaseReport do
                    begin
                      If (LinesLeft < 5)
                        then NewPage;

                      Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                            #9 + AssessmentYear);

                      If IsExemptionTable
                        then Print(#9 + TempTable.FieldByName('ExemptionCode').Text)
                        else Print(#9);

                      If IsSpecialDistrictTable
                        then Print(#9 + TempTable.FieldByName('SDistCode').Text)
                        else Print(#9);

                      Println(#9 + Take(19, OldValue) +
                              #9 + Take(19, ChangeRec.NewValue));

                    end;  {If ChangeThisRec}

            end;  {If not Done}

      until Done;

end;  {BroadcastChange}

{===================================================================}
Function TBroadcastForm.InPropertyClassRange(PropertyClass : String) : Boolean;

var
  I : Integer;

begin
  Result := False;

  If PrintAllPropertyClasses
    then Result := True
    else
      For I := 0 to (SelectedPropertyClasses.Count - 1) do
        If (PropertyClass = SelectedPropertyClasses[I])
          then Result := True;

end;  {InPropertyClassRange}

{===================================================================}
Procedure TBroadcastForm.PrintBadParcels(Sender : TObject;
                                         BadParcelList : TStringList);

var
  I : Integer;

begin
  ReportSection := 'B';

  with Sender as TBaseReport do
    begin
      NewPage;

      For I := 0 to (BadParcelList.Count - 1) do
        begin
          If (((I + 1) MOD 3) = 0)
            then Println('');

          Print(#9 + BadParcelList[I]);

          If (LinesLeft < 5)
            then NewPage;

        end;  {For I := 0 to (BadParcelList.Count - 1) do}

      Println('');
      Println('');
      Println(#9 + 'Number of rejected parcels = ' + IntToStr(BadParcelList.Count));

    end;  {with Sender as TBaseReport do}

end;  {PrintBadParcels}

{===================================================================}
Procedure TBroadcastForm.BroadcastByImportFile(    Sender : TObject;
                                                   ParcelTable,
                                                   TempTable,
                                                   AuditTable : TTable;
                                                   BroadcastMethod : Integer;
                                                   ChangeRecList : TList;
                                                   ImportFileName : String;
                                                   TrialRun : Boolean;
                                                   ProcessingType : Integer;
                                                   AssessmentYear : String;
                                               var NumParcelsBroadcasted : LongInt);

{Add the exemptions in an extract file.}

var
  PeriodFound, Quit, Found, _Found,
  Broadcasted, Done, ValidEntry : Boolean;
  ImportFile : TextFile;
  SwisCode,
  OrigSBLKey, SBLKey, SwisSBLKey,
  sPropertyClass, sOwnershipCode,
  TempProcessingType, NewValue, sOriginalIndex : String;
  ImportLine : LineStringType;
  NumImported, NumFound : LongInt;
  SBLRec : SBLRecord;
  BadParcelList : TStringList;
  I : Integer;
  FieldList : TStringList;

begin
  Found := False;
  FieldList := TStringList.Create;
  NumImported := 0;
  NumFound := 0;
  Done := False;
  Quit := False;

  case ProcessingType of
    ThisYear : TempProcessingType := 'This Year';
    NextYear : TempProcessingType := 'Next Year';
    History : TempProcessingType := 'History';
  end;

  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ResidentialSiteTable, ResidentialSiteTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ResidentialBldgTable, ResidentialBldgTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(CommercialSiteTable, CommercialSiteTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(CommercialBldgTable, CommercialBldgTableName,
                             ProcessingType, Quit);

  BadParcelList := TStringList.Create;

  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  AssignFile(ImportFile, ImportFileName);
  Reset(ImportFile);

  repeat
    ReadLine(ImportFile, ImportLine);

    If EOF(ImportFile)
      then Done := True;

    If TrialRun
      then ProgressDialog.UserLabelCaption := 'Num Found (' + TempProcessingType + ') = ' +
                                              IntToStr(NumFound)
      else ProgressDialog.UserLabelCaption := 'Num Broadcasted (' + TempProcessingType +
                                              ') = ' + IntToStr(NumImported);

      {CHG12062004-1(2.8.1.2): New import format - tab delimited [Swis, SBL, value].}

      {Process one line.}

    case BroadcastMethod of
      bmImportFile_TabDelimited : ParseTabDelimitedStringIntoFields(ImportLine, FieldList, False);
      bmImportFile_CommaDelimited : ParseCommaDelimitedStringIntoFields(ImportLine, FieldList, False);
    end;

    try
      SwisCode := FieldList[0];
    except
      SwisCode := '';
    end;

    try
      SBLKey := FieldList[1];
    except
      SBLKey := '';
    end;

    OrigSBLKey := SBLKey;

      {FXX12232002-2: Check to see if swis is included on SBL.  Otherwise, lookup without it.}

    try
      If (SBLKey[3] = '/')
        then
          begin
            ParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
            SBLRec := ExtractSwisSBLFromSwisSBLKey(ConvertSwisDashDotToSwisSBL(SBLKey, SwisCodeTable, ValidEntry));

            with SBLRec do
              Found := FindKeyOld(ParcelTable,
                                  ['TaxRollYr', 'SwisCode', 'Section',
                                   'Subsection', 'Block', 'Lot', 'Sublot',
                                   'Suffix'],
                                  [AssessmentYear, SwisCode, Section,
                                   SubSection, Block, Lot, Sublot, Suffix]);

          end
        else
          begin
            ParcelTable.IndexName := 'BYTAXROLLYR_SBLKEY';

            If _Compare(SBLKey, ['-', '.', '/'], coContains)
              then SBLRec := ConvertDashDotSBLToSegmentSBL(SBLKey, ValidEntry)
              else
                with SBLRec do
                  begin
                    SwisCode := '';
                    Section := Copy(SBLKey, 1, 3);
                    SubSection := Copy(SBLKey, 4, 3);
                    Block := Copy(SBLKey, 7, 4);
                    Lot := Copy(SBLKey, 11, 3);
                    Sublot := Copy(SBLKey, 14, 3);
                    Suffix := Copy(SBLKey, 17, 4);

                  end;

            with SBLRec do
              begin
                Found := FindKeyOld(ParcelTable,
                                    ['TaxRollYr', 'Section', 'Subsection',
                                     'Block', 'Lot', 'Sublot', 'Suffix'],
                                    [AssessmentYear, Section, SubSection,
                                     Block, Lot, Sublot, Suffix]);

                If Found
                  then ValidEntry := True;

              end;  {with SBLRec do}

          end;  {else of If ((SwisCodeTable.RecordCount = 1) or ..}
    except
    end;

     {For White Plains, try putting an extra dot in between the lot and sublot in order to
      make it a suffix.}

    If not Found
      then
        begin
          PeriodFound := False;

          For I := Length(SBLKey) downto 1 do
            If ((not PeriodFound) and
                (SBLKey[I] = '.'))
              then
                begin
                  Insert('.', SBLKey, I);
                  PeriodFound := True;
                end;

          SBLRec := ConvertDashDotSBLToSegmentSBL(SBLKey, ValidEntry);

          If (GetRecordCount(SwisCodeTable) = 1)
            then SBLRec.SwisCode := SwisCodeTable.FieldByName('SwisCode').Text;

          with SBLRec do
            Found := FindKeyOld(ParcelTable,
                                ['TaxRollYr', 'SwisCode', 'Section',
                                 'Subsection', 'Block', 'Lot', 'Sublot',
                                 'Suffix'],
                                [AssessmentYear, SwisCode, Section, Subsection,
                                 Block, Lot, Sublot, Suffix]);

        end;  {If not Found}

    If not Found
      then
        try
          sOriginalIndex := ParcelTable.IndexName;
          ParcelTable.IndexName := 'BYRemapOldSBL';
          Found := _Locate(ParcelTable, [OrigSBLKey], '', []);
        except
          ParcelTable.IndexName := sOriginalIndex;
        end;


    If not Found
      then
        try
          sOriginalIndex := ParcelTable.IndexName;
          ParcelTable.IndexName := 'BYACCOUNTNO';
          Found := _Locate(ParcelTable, [OrigSBLKey], '', []);
        except
          ParcelTable.IndexName := sOriginalIndex;
        end;

    If not Found
      then
        try
          sOriginalIndex := ParcelTable.IndexName;
          ParcelTable.IndexName := 'BYPrintKey';
          Found := _Locate(ParcelTable, [OrigSBLKey], '', []);
        except
          ParcelTable.IndexName := sOriginalIndex;
        end;

    If not Found
      then
        try
          SBLKey := StringReplace(SBLKey, '..', '.-', []);
          sOriginalIndex := ParcelTable.IndexName;
          ParcelTable.IndexName := 'BYPrintKey';
          Found := _Locate(ParcelTable, [OrigSBLKey], '', []);
        except
          ParcelTable.IndexName := sOriginalIndex;
        end;


    SwisSBLKey := ExtractSSKey(ParcelTable);

    If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
      then BadParcelList.Add(OrigSBLKey);

    If ((not ReportCancelled) and
        ValidEntry and
        Found and
        (ParcelTable.FieldByName('RollSection').Text <> '9') and
        (*(ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and *)
        InPropertyClassRange(ParcelTable.FieldByName('PropertyClassCode').Text))
      then
        begin
           NumFound := NumFound + 1;
           Broadcasted := False;

             {Fill in the change recs based on positional fields following the
              parcel ID, i.e. column 1 corresponds to the first change, etc.
              Then broadcast them.}

          For I := 0 to (ChangeRecList.Count - 1) do
            begin
                {FXX12232002-4: Only get the value from the import file if it is present.}

              try
                NewValue := FieldList[2];
              except
              end;

                {FXX12192005-1(2.9.4.5): Only set the new value if it is actually in the file.}
                
              If _Compare(NewValue, coNotBlank)
                then ChangeRecordPtr(ChangeRecList[I])^.NewValue := NewValue;

              sPropertyClass := ParcelTable.FieldByName('PropertyClassCode').AsString;
              sOwnershipCode := ParcelTable.FieldByName('OwnershipCode').AsString;

              Broadcasted := Broadcasted or
                             BroadcastChange(Sender, ParcelTable, TempTable, AuditTable,
                                             SwisSBLKey, ProcessingType,
                                             AssessmentYear,
                                             sPropertyClass, sOwnershipCode,
                                             ChangeRecordPtr(ChangeRecList[I])^,
                                             SelectedExemptionCodes,
                                             SelectedSpecialDistricts,
                                             ScreenLabelList, TrialRun, Quit);

            end;  {For I := 0 to (ChangeRecList.Count - 1) do}

            {CHG04192001-1: Option to fill in the corresponding code table if they are loading
                            into a code field from a file.}

          If (Broadcasted and
              FillCorrespondingCodeTable)
            then
              begin
                _Found := FindKeyOld(CodeTable, ['MainCode'],
                                     [ChangeRecordPtr(ChangeRecList[0])^.NewValue]);

                If not _Found
                  then
                    with CodeTable do
                      try
                        Insert;
                        FieldByName('MainCode').Text := ChangeRecordPtr(ChangeRecList[0])^.NewValue;
                        Post;
                      except
                        SystemSupport(009, CodeTable, 'Error inserting ' + FieldByName('MainCode').Text +
                                      ' into table ' + CodeTable.TableName + '.',
                                      UnitName, GlblErrorDlgBox);
                      end;

              end;  {If FillCorrespondingCodeTable}

          If Broadcasted
            then NumImported := NumImported + 1;

        end;  {If ((not ReportCancelled) and ..}

     {FXX04192001-1: Make sure we make a copy of the original SBL key as it came
                     into the file for adding to the list.}

   If ((not ValidEntry) or
       (not Found))
     then BadParcelList.Add(OrigSBLKey);

   Application.ProcessMessages;
   ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
   ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

  NumParcelsBroadcasted := NumImported;
  CloseFile(ImportFile);

  ProgressDialog.Finish;

  with Sender as TBaseReport do
    begin
      Println('');
      Println('Number of parcels for ' + AssessmentYear + ' year = ' + IntToStr(NumParcelsBroadcasted));
    end;

  If (BadParcelList.Count > 0)
    then PrintBadParcels(Sender, BadParcelList);

  BadParcelList.Free;

end;  {BroadcastByImportFile}

{===================================================================}
Procedure TBroadcastForm.BroadcastByParcelList(    Sender : TObject;
                                                   ParcelTable,
                                                   TempTable,
                                                   AuditTable : TTable;
                                                   ChangeRecList : TList;
                                                   SelectedExemptionCodes,
                                                   SelectedSpecialDistrictCodes : TStringList;
                                                   TrialRun : Boolean;
                                                   ProcessingType : Integer;
                                               var NumParcelsBroadcasted : LongInt);

{Add the template exemption to each parcel in the selected parcel ID
 range.}

var
  I, Index : Integer;
  Quit, Done, FirstTimeThrough, Broadcasted : Boolean;
  SwisSBLKey, sPropertyClassCode, sOwnershipCode : String;
  SBLRec : SBLRecord;
  AssessmentYear : String;
  TempProcessingType : String;

begin
  Index := 1;

  case ProcessingType of
    ThisYear : TempProcessingType := 'This Year';
    NextYear : TempProcessingType := 'Next Year';
  end;

  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ResidentialSiteTable, ResidentialSiteTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ResidentialBldgTable, ResidentialBldgTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(CommercialSiteTable, CommercialSiteTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(CommercialBldgTable, CommercialBldgTableName,
                             ProcessingType, Quit);

  ParcelListDialog.GetParcel(ParcelTable, Index);

  ProgressDialog.Start(ParcelListDialog.NumItems, True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsBroadcasted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsBroadcasted);

    {Don't add an EX code to an inactive parcel.}

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        begin
          Index := Index + 1;
          ParcelListDialog.GetParcel(ParcelTable, Index);
        end;

    If (Index > ParcelListDialog.NumItems)
      then Done := True;

    SwisSBLKey := ExtractSSKey(ParcelTable);

    SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

    AssessmentYear := GetTaxRollYearForProcessingType(ProcessingType);

    with SBLRec do
      FindKeyOld(ParcelTable,
                 ['TaxRollYr', 'SwisCode', 'Section',
                  'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                 [AssessmentYear, SwisCode, Section, Subsection,
                  Block, Lot, Sublot, Suffix]);

      {FXX04281998-4: Don't copy to roll section 9.}

    If ((not (Done or ReportCancelled)) and
        (ParcelTable.FieldByName('RollSection').Text <> '9') and
        (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
        InPropertyClassRange(ParcelTable.FieldByName('PropertyClassCode').Text))
      then
        begin
          Broadcasted := False;
          If TrialRun
            then ProgressDialog.UserLabelCaption := 'Num Found (' + TempProcessingType + ') = ' +
                                                    IntToStr(NumParcelsBroadcasted)
            else ProgressDialog.UserLabelCaption := 'Num Broadcasted (' + TempProcessingType +
                                                    ') = ' + IntToStr(NumParcelsBroadcasted);

          sPropertyClassCode := ParcelTable.FieldByName('PropertyClassCode').AsString;
          sOwnershipCode := ParcelTable.FieldByName('OwnershipCode').AsString;

          For I := 0 to (ChangeRecList.Count - 1) do
            Broadcasted := Broadcasted or
                           BroadcastChange(Sender, ParcelTable, TempTable, AuditTable,
                                           SwisSBLKey, ProcessingType, AssessmentYear,
                                           sPropertyClassCode, sOwnershipCode,
                                           ChangeRecordPtr(ChangeRecList[I])^,
                                           SelectedExemptionCodes,
                                           SelectedSpecialDistricts,
                                           ScreenLabelList, TrialRun, Quit);

          If Broadcasted
            then NumParcelsBroadcasted := NumParcelsBroadcasted + 1;

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

  ProgressDialog.Finish;

  with Sender as TBaseReport do
    begin
        {CHG05222003-1(2.07b): If this a frozen bank code, don't update it - give a
                               message, though.}

      If (GlblAllowBankCodeFreeze and
          (RejectedDueToFrozenBankCodeList.Count > 0))
        then
          begin
            Println('');
            Underline := True;
            Println('Parcels not updated due to frozen bank code:');
            Underline := False;
            ClearTabs;
            SetTab(0.3, pjLeft, 2.0, 0, BOXLINENone, 0);   {Parcel ID 1}
            SetTab(2.4, pjLeft, 2.0, 0, BOXLINENone, 0);   {Parcel ID 2}
            SetTab(4.5, pjLeft, 2.0, 0, BOXLINENone, 0);   {Parcel ID 3}

            For I := 0 to (RejectedDueToFrozenBankCodeList.Count - 1) do
              begin
                If ((I > 0) and
                    ((I mod 3) = 0))
                  then Println('');

                If (LinesLeft < 5)
                  then
                    begin
                      NewPage;
                      Println('');
                      Underline := True;
                      Println('Parcels not updated due to frozen bank code:');
                      Underline := False;
                      ClearTabs;

                    end;  {If (LinesLeft < 5)}

                Print(#9 + ConvertSwisSBLToDashDot(RejectedDueToFrozenBankCodeList[I]));

              end;  {For I := 0 to (RejectedDueToFrozenBankCodeList.Count - 1) do}

          end;  {If (GlblAllowBankCodeFreeze and ...}

      Println('');
      Println('Number of parcels for ' + AssessmentYear + ' year = ' + IntToStr(NumParcelsBroadcasted));

    end;  {with Sender as TBaseReport do}

end;  {BroadcastByParcelList}

{==============================================================}
Procedure TBroadcastForm.GetChangesToDo(ChangeRecList : TList);

var
  TempName, _ScreenName, _LabelName : String;
  TempScreenComboBox, TempFieldComboBox : TComboBox;
  TempEdit : TEdit;
  ChangeRec : ChangeRecordPtr;
  I, J : Integer;

begin
  For I := 1 to 3 do
    begin
      TempName := 'Screen' + IntToStr(I) + 'ComboBox' ;
      TempScreenComboBox := TComboBox(Self.FindComponent(TempName));

      TempName := 'Field' + IntToStr(I) + 'ComboBox';
      TempFieldComboBox := TComboBox(Self.FindComponent(TempName));

      TempName := 'Change' + IntToStr(I) + 'Edit';
      TempEdit := TEdit(Self.FindComponent(TempName));

      If (TempScreenComboBox.ItemIndex > 0)  {Blank entry.}
        then
          begin
            _ScreenName := TempScreenComboBox.Items[TempScreenComboBox.ItemIndex];
            _LabelName := TempFieldComboBox.Items[TempFieldComboBox.ItemIndex];

            New(ChangeRec);

            with ChangeRec^ do
              begin
                ScreenName := Take(30, _ScreenName);
                LabelName := Take(30, _LabelName);

                For J := 0 to (ScreenLabelList.Count - 1) do
                  If ((Take(30, ScreenLabelPtr(ScreenLabelList[J])^.LabelName) = LabelName) and
                      (Take(30, ScreenLabelPtr(ScreenLabelList[J])^.ScreenName) = ScreenName))
                    then
                      begin
                        TableName := ScreenLabelPtr(ScreenLabelList[J])^.TableName;
                        FieldName := ScreenLabelPtr(ScreenLabelList[J])^.FieldName;
                      end;

                NewValue := TempEdit.Text;

              end;  {with ChangeRec do}

            ChangeRecList.Add(ChangeRec);

          end;  {If (TempScreenComboBox.ItemIndex <> 0)  (Blank entry.)}

    end;  {For I := 1 to 3 do}

end;  {GetChangesToDo}

{==============================================================}
Function TBroadcastForm.ValidSelections : Boolean;

begin
  Result := True;
end;  {ValidSelections}

{==============================================================}
Procedure TBroadcastForm.ReportPrintHeader(Sender: TObject);

var
  TempName : String;
  I : Integer;
  TempScreenComboBox, TempFieldComboBox : TComboBox;
  TempEdit : TEdit;

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
      SetFont('Times New Roman',10);
      Bold := True;
      Home;
      PrintCenter('Broadcast', (PageWidth / 2));
      Bold := False;
      CRLF;
      CRLF;

        {Selected options}

      ClearTabs;
      SetTab(0.3, pjLeft, 7.5, 0, BOXLINENONE, 0);   {hdr}

      SetFont('Times New Roman',10);

      Print(#9 + 'Assessment Year: ');

      case ProcessingType of
        ayThisYear : Println(GlblThisYear);
        ayNextYear : Println(GlblNextYear);
        ayBothYears : Println(GlblThisYear + '\' + GlblNextYear);
      end;

      If _Compare(BroadcastMethod, [bmImportFile_TabDelimited, bmImportFile_CommaDelimited], coEqual)
        then Println(#9 + 'Import from file: ' + ImportFileName)
        else Println(#9 + 'Import from parcel list.');

       {Now print changes to be done.}

     For I := 1 to 3 do
       begin
         TempName := 'Screen' + IntToStr(I) + 'ComboBox';
         TempScreenComboBox := TComboBox(Self.FindComponent(TempName));

         If (Deblank(TempScreenComboBox.Text) <> '')
           then
             begin
               TempName := 'Field' + IntToStr(I) + 'ComboBox';
               TempFieldComboBox := TComboBox(Self.FindComponent(TempName));
               TempName := 'Change' + IntToStr(I) + 'Edit';
               TempEdit := TEdit(Self.FindComponent(TempName));

               Println(#9 + 'Change ' + RTrim(TempFieldComboBox.Text) +
                            ' from screen ' + RTrim(TempScreenComboBox.Text) +
                            ' to ' + RTrim(TempEdit.Text));

             end;  {If (Deblank(TempScreenComboBox.Text) <> '')}

       end;  {For I := 1 to 3 do}

     Println('');

       {FXX06162003-2(2.07d): The swis code was getting cut off on the report.
                              Margins were adjusted.}

     case ReportSection of
       'M' : {Main}
         begin
           Underline := False;
           ClearTabs;
           SetTab(0.3, pjCenter, 2.1, 0, BOXLINEBottom, 0);   {Parcel ID}
           SetTab(2.5, pjCenter, 0.4, 0, BOXLINEBottom, 0);   {Year}
           SetTab(3.0, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {EX Code}
           SetTab(3.6, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {SD Code}
           SetTab(4.2, pjCenter, 1.9, 0, BOXLINEBottom, 0);   {Old value}
           SetTab(6.2, pjCenter, 1.9, 0, BOXLINEBottom, 0);   {New value}

           Println(#9 + 'Parcel ID' +
                   #9 + 'Year' +
                   #9 + 'EX Cd' +
                   #9 + 'SD Cd' +
                   #9 + 'Old Value' +
                   #9 + 'New Value');

           ClearTabs;
           SetTab(0.3, pjLeft, 2.1, 0, BOXLINENone, 0);   {Parcel ID}
           SetTab(2.5, pjLeft, 0.4, 0, BOXLINENone, 0);   {Year}
           SetTab(3.0, pjLeft, 0.5, 0, BOXLINENone, 0);   {EX Code}
           SetTab(3.6, pjLeft, 0.5, 0, BOXLINENone, 0);   {SD Code}
           SetTab(4.2, pjLeft, 1.9, 0, BOXLINENone, 0);   {Old value}
           SetTab(6.2, pjLeft, 1.9, 0, BOXLINENone, 0);   {New value}

         end;  {'M' : Main}

      'B' : {Bad parcels}
        begin
           ClearTabs;
           SetTab(0.4, pjLeft, 2.5, 0, BOXLINENone, 0);   {Parcel ID 1}
           SetTab(3.0, pjLeft, 2.5, 0, BOXLINENone, 0);   {Parcel ID 2}
           SetTab(5.6, pjLeft, 2.5, 0, BOXLINENone, 0);   {Parcel ID 3}

           Underline := True;
           Println(#9 + 'Parcels rejected due to bad parcel IDs:');
           Underline := False;

        end;  {'B' : Bad parcels}

      end;  {case ReportSection of}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==============================================================}
Procedure TBroadcastForm.ReportPrint(Sender: TObject);

var
  NumParcelsBroadcasted : LongInt;

begin
  NumParcelsBroadcasted := 0;

  case BroadcastMethod of
    bmImportFile_TabDelimited,
    bmImportFile_CommaDelimited :
      begin
           {CHG04192001-1: Option to fill in the corresponding code table if they are loading
                           into a code field from a file.}

        If FillCorrespondingCodeTable
          then
            begin
              CodeTable.TableName := CorrespondingTableName;

              try
                CodeTable.Open;
              except
                SystemSupport(010, CodeTable, 'Error opening code table ' + CodeTable.TableName + '.',
                              UnitName, GlblErrorDlgBox);
              end;

              If ClearCodeTableFirst
                then DeleteTable(CodeTable);

            end;  {If FillCorrespondingCodeTable}

        If _Compare(ProcessingType, ayHistory, coEqual)
        then BroadcastByImportFile(Sender, ParcelTable, TempTable,
                                   AuditTable, BroadcastMethod, ChangeRecList,
                                   ImportFileName, TrialRun,
                                   History, edHistoryYear.Text, NumParcelsBroadcasted);


        If ((ProcessingType = ayThisYear) or
            (ProcessingType = ayBothYears))
          then BroadcastByImportFile(Sender, ParcelTable, TempTable,
                                     AuditTable, BroadcastMethod, ChangeRecList,
                                     ImportFileName, TrialRun,
                                     ThisYear, GlblThisYear, NumParcelsBroadcasted);

          {FXX04192001-2: Make sure to form feed between years.
                          Also reset the section}

        If (ProcessingType = ayBothYears)
          then
            begin
              ReportSection := 'M';
              TBaseReport(Sender).NewPage;
            end;

        If ((ProcessingType = ayNextYear) or
            (ProcessingType = ayBothYears))
          then BroadcastByImportFile(Sender, ParcelTable, TempTable,
                                     AuditTable, BroadcastMethod, ChangeRecList,
                                     ImportFileName, TrialRun,
                                     NextYear, GlblNextYear, NumParcelsBroadcasted);

      end;  {bmImportFile}

    bmParcelList :
      begin
        If ((ProcessingType = ayThisYear) or
            (ProcessingType = ayBothYears))
          then BroadcastByParcelList(Sender, ParcelTable, TempTable,
                                  AuditTable, ChangeRecList,
                                  SelectedExemptionCodes,
                                  SelectedSpecialDistricts,
                                  TrialRun, ThisYear,
                                  NumParcelsBroadcasted);

          {FXX04192001-2: Make sure to form feed between years.
                          Also reset the section}

        If (ProcessingType = ayBothYears)
          then
            begin
              ReportSection := 'M';
              TBaseReport(Sender).NewPage;
            end;

        If ((ProcessingType = ayNextYear) or
            (ProcessingType = ayBothYears))
          then BroadcastByParcelList(Sender, ParcelTable, TempTable,
                                     AuditTable, ChangeRecList,
                                     SelectedExemptionCodes,
                                     SelectedSpecialDistricts,
                                     TrialRun, NextYear,
                                     NumParcelsBroadcasted);

      end;  {bmParcelList}

  end;  {case BroadcastMethod of}

end;  {ReportPrint}

{==============================================================}
Procedure TBroadcastForm.StartButtonClick(Sender: TObject);

var
  I : Integer;
  NewFileName : String;
  Quit, Cancelled : Boolean;

begin
  If ValidSelections
    then
      begin
        RejectedDueToFrozenBankCodeList := TStringList.Create;
        ReportSection := 'M';
        BroadcastMethod := BroadcastMethodRadioGroup.ItemIndex;
        AddInventorySites := AddInventorySitesCheckBox.Checked;
        bOnlyUpdateBlankValues := cbxOnlyBroadcastToBlankValues.Checked;

        MessageDlg('The broadcast prints an audit trail of all changes.' + #13 +
                   'Please select where the print output should go in the' + #13 +
                   'following Print dialog box which will appear after you press OK.',
                   mtInformation, [mbOK], 0);

          {CHG10121998-1: Add user options for default destination and show vet max msg.}

        SetPrintToScreenDefault(PrintDialog);

        If (PrintDialog.Execute and
            ((BroadcastMethod = bmParcelList) or
             OpenDialog.Execute))
          then
            begin
                {CHG10131998-1: Set the printer settings based on what printer they selected
                                only - they no longer need to worry about paper or landscape
                                mode.}

              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

              ProcessingType := AssessmentYearRadioGroup.ItemIndex;
              ImportFileName := OpenDialog.FileName;

                 {Range information}

              PrintAllPropertyClasses := False;
              SelectedExemptionCodes := TStringList.Create;
              SelectedSpecialDistricts := TStringList.Create;
              SelectedPropertyClasses := TStringList.Create;

              For I := 0 to (ExemptionListBox.Items.Count - 1) do
                If ExemptionListBox.Selected[I]
                  then SelectedExemptionCodes.Add(Take(5, ExemptionListBox.Items[I]));

              For I := 0 to (SpecialDistrictListBox.Items.Count - 1) do
                If SpecialDistrictListBox.Selected[I]
                  then SelectedSpecialDistricts.Add(Take(5, SpecialDistrictListBox.Items[I]));

              with PropertyClassListBox do
                If (SelCount = Items.Count)
                  then PrintAllPropertyClasses := True
                  else
                    For I := 0 to (Items.Count - 1) do
                      If Selected[I]
                        then SelectedPropertyClasses.Add(Take(3, Items[I]));

                {CHG04192001-1: Option to fill in the corresponding code table if they are loading
                                into a code field from a file.}

              FillCorrespondingCodeTable := FillCorrespondingCodeTableCheckBox.Checked;

              If FillCorrespondingCodeTable
                then
                  begin
                    CorrespondingTableName := CodeTableComboBox.Text;
                    ClearCodeTableFirst := ClearCodeTableFirstCheckBox.Checked;
                  end;

              TrialRun := TrialRunCheckBox.Checked;
              ReportCancelled := False;

                {Now print the report and do the EX broadcast.}

              GlblPreviewPrint := False;

                {Fill in the changes that they want to do.}

              ChangeRecList := TList.Create;

              GetChangesToDo(ChangeRecList);

                {CHG06171998-1: Option to load exemptions from file.}

              Cancelled := False;

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

              If not Cancelled
                then
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
                        end

                      end
                    else ReportPrinter.Execute;

              SelectedExemptionCodes.Free;
              SelectedSpecialDistricts.Free;
              SelectedPropertyClasses.Free;
              RejectedDueToFrozenBankCodeList.Free;

            end;  {If PrintDialog.Execute}

      end;  {If ValidSelections}

end;  {StartButtonClick}

{===================================================================}
Procedure TBroadcastForm.FormClose(    Sender: TObject;
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
