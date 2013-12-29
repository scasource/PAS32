unit Pcomsite;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, Tabs,
  UtilPrcl;  {Parcel maintenance table names.}

type
  TParcelCommercialSiteForm = class(TForm)
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    Label5: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    YearLabel: TLabel;
    EditLocation: TEdit;
    Label7: TLabel;
    Label4: TLabel;
    CloseButton: TBitBtn;
    Navigator: TDBNavigator;
    EditRCNMinusDep: TDBEdit;
    EditRouteNumber: TDBEdit;
    EditReplacementCost: TDBEdit;
    EditTotalValue: TDBEdit;
    EditTotalEstimate: TDBEdit;
    EditExcessValue: TDBEdit;
    EditLandEstimate: TDBEdit;
    PropClassLookup: TwwDBLookupCombo;
    NeighborhoodCodeLookup: TwwDBLookupCombo;
    UsedAsLookup: TwwDBLookupCombo;
    ConiditionLookup: TwwDBLookupCombo;
    DesirabilityLookup: TwwDBLookupCombo;
    ZoningLookup: TwwDBLookupCombo;
    SewerLookup: TwwDBLookupCombo;
    WaterLookup: TwwDBLookupCombo;
    UtilityLookup: TwwDBLookupCombo;
    GradeLookup: TwwDBLookupCombo;
    EditSite: TDBEdit;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    ReplacementCostLabel: TLabel;
    RCNLDLabel: TLabel;
    LandEstimateLabel: TLabel;
    TotalEstimateLabel: TLabel;
    ExcessValueLabel: TLabel;
    LandValueLabel: TLabel;
    TotalValueLabel: TLabel;
    EditFinalLandValue: TDBEdit;
    CodeTable: TwwTable;
    DCEntryLookup: TwwDBLookupCombo;
    Label32: TLabel;
    EditEffectiveYearBuilt: TDBEdit;
    Label15: TLabel;
    Label20: TLabel;
    LookupValuationDist: TwwDBLookupCombo;
    SaleNumberLabel: TLabel;
    EditSalesNumber: TEdit;
    Label3: TLabel;
    EditLastChangeDate: TDBEdit;
    Label33: TLabel;
    EditLastChangeByName: TDBEdit;
    Label29: TLabel;
    Label30: TLabel;
    EditNumResSites: TEdit;
    EditNumComSites: TEdit;
    PropertyClassDesc: TLabel;
    NeighborhoodDesc: TLabel;
    ValuationDistDesc: TLabel;
    ConditionDesc: TLabel;
    GradeDesc: TLabel;
    UsedAsDesc: TLabel;
    StatusPanel: TPanel;
    InactiveLabel: TLabel;
    Label41: TLabel;
    Label44: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    SetFocusTimer: TTimer;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    OppositeYearComSiteTable: TTable;
    ComBldgTable: TTable;
    SiteLookupTable: TTable;
    PartialAssessmentLabel: TLabel;
    ZoningText: TDBText;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterEdit(DataSet: TDataset);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure MainTableAfterDelete(DataSet: TDataset);
    procedure CodeLookupEnter(Sender: TObject);
    procedure EditEffectiveYearBuiltExit(Sender: TObject);
    procedure MainDataSourceDataChange(Sender: TObject; Field: TField);
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure MainTableBeforeDelete(DataSet: TDataset);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure SetCodeOnLookupCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure MainTableNewRecord(DataSet: TDataSet);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr, SwisSBLKey : String;
    SalesNumber : Integer;  {What sales number are we on - only for use if Processing Type = SalesInv.}
    Site : Integer; {What site are we on?}
    ProcessingType : Integer;  {NextYear, ThisYear, History, SalesInventory}
    NumResSites,
    NumComSites : Integer;  {Number of commercial and residential sites for this
                             parcel.}
    ParcelTabSet : TTabSet;  {The tabs along the bottom. We need them for when a site is deleted or changed
                              so that we can refresh the tabs.}
    TabTypeList : TStringList; {The corresponding tab processing types. "  "   "  "}
    CommBuildingNo,
    CommBuildingSection : PProcessingTypeArray;  {What commercial building and section are they on
                                                  for history, next year, this year, sales inv?}

    LookupTable : TTable;  {Table for keeping tabs in synch with the site (see OnDataChange event).}

    InitializingForm : Boolean;  {Are we initializing the form now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}

      {Have there been any changes?}

    ParcelChanged : Boolean;
    DeletedSiteNum : Integer;  {What is the site that they are deleting now?}

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
      {because these routines are placed at the form object def. level,}
      {they have access to all variables on form (no need to Var in)   }

      {CHG10281997-1: Dual mode processing.}

    RecordAction,
    OppositeProcessingType : Integer;
    OppositeTaxYear : String;
    OppositeYearParcelChanged : Boolean;
    FieldTraceInformationList : TList;

    Procedure InitializeForm;
    Procedure SetFocusToFirstField;
    Procedure SetRangeForTable(Table : TTable);

      {What is the code table name for this lookup?}
    Function DetermineCodeTableName(Tag : Integer) : String;

      {Actually set the code table name.}
    Procedure SetCodeTableName(Tag : Integer);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, DataAccessUnit;


{$R *.DFM}

const
    {This is a unique number for each lookup box stored in that
     lookup's tag field. This is because we have only one code table and
     as they enter each lookup, we change the name of the code table to be
     the table for this lookup. To use this, set the tag field of each
     lookup combo box to a unique number and list it below.}

    {To use the hints, create unique numerical tags for each lookup combo box
     and list them below (LLL1).
     Also, put the constants of the lookups that will be description based
     in the DescriptionIndexedLookups array (LLL2).
     Then go to the DetermineCodeTableName procedure
     (LLL3) and change the table name assignments. Then set the OnEnter event
     for all LookupCombo boxes to CodeLookupEnter and the OnCloseUp for all
     LookupCombo boxes to SetCodeOnLookupCloseUp.}

  PropertyClass = 10;  {LLL1}
  UsedAs = 20;
  NeighborhoodCode = 30;
  Desirability = 40;
  Zoning = 50;
  Sewer = 60;
  Water = 70;
  Utility = 80;
  ValuationDist = 90;
  Condition = 100;
  Grade = 110;
  DCEntryCode = 120;

    {Now we will put the lookups that are description based in a set for later
     reference.}

  DescriptionIndexedLookups : set of 0..250 =
         [Desirability, Zoning, Sewer, Water, Utility, DCEntryCode];

{=====================================================================}
Procedure TParcelCommercialSiteForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TParcelCommercialSiteForm.SetRangeForTable(Table : TTable);

          {Now set the range on this table
           so that it is sychronized to this parcel. Note
           that all segments of the key must be set.}
           {mmm4 - Make sure to set range on all keys.}

begin
  try
    If (ProcessingType = SalesInventory)
      then SetRangeOld(Table,
                       ['SwisSBLKey', 'SalesNumber', 'Site'],
                       [SwisSBLKey, IntToStr(SalesNumber), '0'],
                       [SwisSBLKey, IntToStr(SalesNumber), '32000'])
      else SetRangeOld(Table,
                       ['TaxRollYr', 'SwisSBLKey', 'Site'],
                       [TaxRollYr, SwisSBLKey, '0'],
                       [TaxRollYr, SwisSBLKey, '32000']);
  except
    SystemSupport(001, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TParcelCommercialSiteForm.InitializeForm;

{This procedure opens the tables for this form and synchronizes
 them to this parcel. Also, we set the title and year
 labels.

 Note that this code is in this seperate procedure rather
 than any of the OnShow events so that we could have
 complete control over when this procedure is run.
 The problem with any of the OnShow events is that when
 the form is created, they are called, but it is not possible to
 have the SwisSBLKey, etc. set.
 This way, we can call InitializeForm after we know that
 the SwisSBLKey, etc. has been set.}

var
  Quit, Found : Boolean;
  SBLRec : SBLRecord;

begin
  UnitName := 'PCOMSITE.PAS';  {mmm1}
  ParcelChanged := False;
  ClosingForm := False;
  InitializingForm := True;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        FieldTraceInformationList := TList.Create;

            {If this is inquire mode or the processing type is not the the
             main (i.e. Glbl Tax Year), let's open it in
             readonly mode.}

        If ((EditMode = 'V') or
            (ProcessingType <> DetermineProcessingType(GlblTaxYearFlg)))
          then MainTable.ReadOnly := True;

            {If this is inquire mode or sales inventory, let's open it in
             readonly mode. Hist access is blocked at menu level}

        {CHG06302012-1(2.28.4.33)[PAS-412]:  Allow for sales inventory editing.}

        If not MainTable.ReadOnly
        then MainTable.ReadOnly := not DetermineEditStatusForInventoryForm(EditMode, ProcessingType, GlblTaxYearFlg, glblAllowSalesInventoryEdit);


          {There are so many tables on this form, we will
           set the table name and open them implicitly (except the
           trace table. OpenTablesForForm is a method in PASUTILS}

        OpenTablesForForm(Self, ProcessingType);

          {If this is sales inventory, then let's set the index to include the
           sales number. Otherwise, let's do the index without the sales number.}

        If (ProcessingType = SalesInventory)
          then MainTable.IndexName := InventorySwisSBL_SalesNumberKey
          else MainTable.IndexName := InventoryYear_SwisSBLKey;

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot',
                               'Suffix'],
                              [TaxRollYr, SwisCode, Section,
                               SubSection, Block, Lot, Sublot, Suffix]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Set the range.}

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

          {Now we are going to set them back to the site that they were on
           before - this is contained in the Site property. However, if Site
           is 0, then there are no sites for this residence yet, and we
           don't want to try a find key.}

        If (Site <> 0)
          then
            try
              FindKeyOld(MainTable,
                         ['TaxRollYr', 'SwisSBLKey', 'Site'],
                         [TaxRollYr, SwisSBLKey, IntToStr(Site)]);
            except
              SystemSupport(006, MainTable, 'Error getting commercial site record.',
                            UnitName, GlblErrorDlgBox);
            end;

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

          {FXX12151997-1: Make sure that the tital does not overlap the
                          assessed values.}

        TitleLabel.Caption := 'Commercial Site';

(*        case EditMode of   {mmm5}
          'A' : TitleLabel.Caption := 'Commercial Site Add';
          'M' : TitleLabel.Caption := 'Commercial Site Modify';
          'V' : TitleLabel.Caption := 'Commercial Site View';

        end;  {case EditMode of} *)

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Now, for some reason the table is marked as
           Modified after we do a set range in modify mode.
           So, we will cancel the modify and set it in
           the proper mode.}

        If ((not MainTable.ReadOnly) and
            (EditMode in ['A', 'M']))
          then
            begin
              MainTable.Edit;
              MainTable.Cancel;
            end;

          {Note that we will not automatically put them
           in edit mode or insert mode. We will make them
           take that action themselves since even though
           they are in an edit or insert session, they
           may not want to actually make any changes, and
           if they do not, they should not have to cancel.}

        If MainTable.ReadOnly
          then
            begin
                {Disable any navigator button that does
                 not apply in inquire mode.}

              Navigator.VisibleButtons := [nbFirst, nbPrior, nbNext, nbLast];

                {We will allow a width of 30 per button and
                 resize and recenter the navigator.}

              Navigator.Width := 120;
              Navigator.Left := (ScrollBox.Width - Navigator.Width) DIV 2;

            end;  {If MainTable.ReadOnly}

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);

          {Now set the year label.}

        SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);

          {Set the SBL in the SBL edit so that it is visible.
           Note that it is not data aware since if there are
           no records, we have nothing to get the SBL from.}

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        EditNumResSites.Text := IntToStr(NumResSites);
        EditNumComSites.Text := IntToStr(NumComSites);

          {For some reason the lookup boxes were not being filled in with the
           value in the underlying MainTable field when the form was initialized,
           so this fills in the fields so that the data is visible. Note that this
           does not cause the table to be marked modified. Also, we will fill
           in any labels for code based dropdowns. Note that the label names (not captions)
           must be EXACTLY the description field name in the table.}

        RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

          {Set the display for currency fields.}

          {CHG10091997-1: Should zeroes be blanks or '0'?}
        SetDisplayFormatForCurrencyFields(Self, False);

          {FXX01022002-1: Fix the format of currency.}

        TFloatField(MainTable.FieldByName('ReplacementCostNew')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('RCNLessDeprec')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('ExcessValue')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('LandEstimate')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('TotalEstimate')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('FinalLandValue')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('FinalTotalValue')).DisplayFormat := CurrencyNormalDisplay;

          {If this is sales inventory, then let's fill in the sales number edit.
           Otherwise, we will hide the sales edit and label.}

        If (ProcessingType = SalesInventory)
          then EditSalesNumber.Text := IntToStr(SalesNumber)
          else
            begin
              SaleNumberLabel.Visible := False;
              EditSalesNumber.Visible := False;
            end;

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

          {CHG10281997-1: Dual mode processing.}

        If (ProcessingType = ThisYear)
          then OppositeProcessingType := NextYear
          else OppositeProcessingType := ThisYear;

        OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

        OpenTableForProcessingType(OppositeYearComSiteTable,
                                   CommercialSiteTableName,
                                   OppositeProcessingType, Quit);

          {FXX03031998-2: Set focus to the first field. Note that we must
                          do this on a timer so that the form is showing
                          by the time we try to set focus.  Otherwise,
                          we get an error trying to set focus in an invisible
                          window.}

        SetFocusTimer.Enabled := True;

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

          {CHG03112002-1: Allow for suppression of inventory values.}

        If not GlblShowInventoryValues
          then
            begin
              ReplacementCostLabel.Visible := False;
              RCNLDLabel.Visible := False;
              LandValueLabel.Visible := False;
              ExcessValueLabel.Visible := False;
              LandEstimateLabel.Visible := False;
              TotalEstimateLabel.Visible := False;
              TotalValueLabel.Visible := False;
              EditReplacementCost.Visible := False;
              EditRCNMinusDep.Visible := False;
              EditExcessValue.Visible := False;
              EditLandEstimate.Visible := False;
              EditTotalEstimate.Visible := False;
              EditFinalLandValue.Visible := False;
              EditTotalValue.Visible := False;

            end;  {If not GlblShowInventoryValues}

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  InitializingForm := False;

end;  {InitializeForm}

{===========================================================}
Procedure TParcelCommercialSiteForm.SetFocusToFirstField;

{FXX03031998-2: Set focus to the first field after insert, any post,
                and upon coming into the form.}

begin
  with PropClassLookup do
    begin
      SetFocus;
      SelectAll;
    end;

end;  {SetFocusToFirstField}

{===========================================================}
Procedure TParcelCommercialSiteForm.SetFocusTimerTimer(Sender: TObject);

{FXX03031998-2: Set focus to the first field. Note that we must
                do this on a timer so that the form is showing
                by the time we try to set focus.  Otherwise,
                we get an error trying to set focus in an invisible
                window.}

begin
  SetFocusTimer.Enabled := False;
  SetFocusToFirstField;
end;  {SetFocusTimerTimer}

{===========================================================}
Procedure TParcelCommercialSiteForm.EditEnter(Sender: TObject);

{Set the currency display to not have any commas or dollar sign for editing purpose.}

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

{===============================================================}
Procedure TParcelCommercialSiteForm.EditExit(Sender: TObject);

{Change the currency field back to normal display format.}

var
  TempField : TCurrencyField;

begin
  TempField := TCurrencyField(MainTable.FieldByName(TDBEdit(Sender).DataField));

  with TempField do
    If ((DataType = ftCurrency) and
         Currency)
      then DisplayFormat := CurrencyNormalDisplay;

end;  {EditExit}

{====================================================================}
Function TParcelCommercialSiteForm.DetermineCodeTableName(Tag : Integer) : String;

{Based on the tag of the lookup combo box, what table should we open in the
 code table? Note that the constants below are declared right after the
 IMPLEMENTATION directive.}

begin
  case Tag of  {LLL3}
    PropertyClass : Result := 'ZPropClsTbl';
    UsedAs : Result := 'ZInvUsedAsTbl';
    NeighborhoodCode : Result := 'ZInvNghbrhdCodeTbl';

      {FXX01211998-3: The site desirability codes are different for
                      commercial and residential.}

    Desirability : Result := 'ZInvComSiteDesireTbl';
    Zoning : Result := 'ZInvZoningCodeTbl';
    Sewer : Result := 'ZInvSewerTbl';
    Water : Result := 'ZInvWaterTbl';
    Utility : Result := 'ZInvUtilityTbl';
    ValuationDist : Result := 'ZValuationDistTbl';
    Condition : Result := 'ZInvConditionTbl';
    Grade : Result := 'ZInvGradeTbl';
    DCEntryCode : Result := 'ZInvEntryCodeTbl';

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{========================================================================}
Procedure TParcelCommercialSiteForm.SetCodeTableName(Tag : Integer);

{Based on the tag of the lookup combo box, what table should we open in the
 code table? Actually set the table name. Note that the constants below are
 declared right after the IMPLEMENTATION directive.}

var
  LookupFieldName : String;  {Which key is this lookup by desc. or main code?}

begin
  CodeTable.TableName := DetermineCodeTableName(Tag);

  If (Tag in DescriptionIndexedLookups)
    then LookupFieldName := 'Description'
    else LookupFieldName := 'MainCode';

  SetIndexForCodeTable(CodeTable, LookupFieldName);

end;  {SetCodeTableName}

{========================================================================}
Procedure TParcelCommercialSiteForm.CodeLookupEnter(Sender: TObject);

{Close the code table and rename the table to the table for this lookup.
 Then we will rename it according to tax year and open it.}

begin
    {Only close and reopen the table if they are on a lookup that needs a
     different code table opened.}

  with Sender as TwwDBLookupCombo do
    If (CodeTable.TableName <> DetermineCodeTableName(Tag))
      then
        begin
          CodeTable.Close;
          SetCodeTableName(Tag);

          If (Tag in DescriptionIndexedLookups)
            then LookupField := 'Description'
            else LookupField := 'MainCode';

          CodeTable.Open;

            {Make sure that the code table is using the correct index.}

          SetIndexForCodeTable(CodeTable, LookupField);

          {Also, change the selected in the lookup to match the index type.}

          If (Tag in DescriptionIndexedLookups)
            then
              begin
                Selected.Clear;
                Selected.Add('Description' + #9 + '30' + #9 + 'Description Description');
                Selected.Add('MainCode' + #9 +
                             IntToStr(CodeTable.FieldByName('MainCode').DataSize - 1) +
                             #9 + 'MainCode Code');
              end
            else
              begin
                Selected.Clear;
                Selected.Add('MainCode' + #9 +
                             IntToStr(CodeTable.FieldByName('MainCode').DataSize - 1) +
                             #9 + 'MainCode Code');
                Selected.Add('Description' + #9 + '30' + #9 + 'Description Description');

              end;  {else of If (Tag in DescriptionIndexedLookups)}

        end;  {If (CodeTable.TableName <> DetermineCode}

    {FXX03031998-8: Refresh the dropdowns when we exit code lookup enter
                    since we were having problems with text disapperaing.}

  RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

end;  {CodeLookupEnter}

{==============================================================}
Procedure TParcelCommercialSiteForm.SetCodeOnLookupCloseUp(Sender: TObject;
                                                           LookupTable,
                                                           FillTable: TDataSet;
                                                           modified: Boolean);

{If this is a lookup combo box which looks up by description then we
 need to fill in the actual code in the record. If this is a lookup combo box
 which looks up by code, then let's fill in the description.
 Note that in order for this to work the DDF field names must end in 'Code' and
 'Desc' and the first part must be the same, i.e. 'PropertyClassCode' and
 'PropertyClassDescription'.}

var
  DescFieldName, CodeFieldName, FieldName : String;
  FieldSize : Integer;
  TempLabel : TLabel;

begin
  If ((MainTable.State in [dsInsert, dsEdit]) and
      MainTable.Modified)
    then
      If (TComponent(Sender).Tag in DescriptionIndexedLookups)
        then
          begin  {Description keyed look up.}
              {This is a description based lookup, so let's find the corresponding
               code field and fill it in.}

            with Sender as TwwDBLookupCombo do
              begin
                 {First, figure out which field this lookup box connects to in the
                  main table.}

                FieldName := DataField;
                CodeFieldName := FieldName;
                Delete(CodeFieldName, Pos('Desc', FieldName), 50);  {Delete 'Desc' from the field name.}
                CodeFieldName := CodeFieldName + 'Code';  {Now add 'Code' to get the code field name.}

              end;  {If (Tag in DescriptionIndexedLookups)}

              {Now, if the field is now blank, then blank out the code.
               Otherwise, fill in the code in the table.}

            If (Deblank(MainTable.FieldByName(FieldName).Text) = '')
              then MainTable.FieldByName(CodeFieldName).Text := ''
              else MainTable.FieldByName(CodeFieldName).Text :=
                   TwwDBLookupCombo(Sender).LookupTable.FieldByName('MainCode').Text;

          end
        else
          begin
              {This is a code based lookup, so let's fill in the description
               for this code.}

            with Sender as TwwDBLookupCombo do
              begin
                 {First, figure out which field this lookup box connects to in the
                  main table. Then delete 'Code' from the end and add 'Desc' to
                  get the decsription field.}

                FieldName := DataField;
                DescFieldName := FieldName;
                Delete(DescFieldName, Pos('Code', FieldName), 50);  {Delete 'Code' from the field name.}
                DescFieldName := DescFieldName + 'Desc';  {Now add 'Desc' to get the code field name.}

                FieldSize := MainTable.FieldByName(DescFieldName).DataSize - 1;  {Minus 1 because it includes #0.}

              end;  {If (Tag in DescriptionIndexedLookups)}

              {Now, if the field is now blank, then blank out the code.
               Otherwise, fill in the code in the table.}

            If (Deblank(MainTable.FieldByName(FieldName).Text) = '')
              then MainTable.FieldByName(DescFieldName).Text := ''
              else MainTable.FieldByName(DescFieldName).Text :=
                   Take(FieldSize, TwwDBLookupCombo(Sender).LookupTable.FieldByName('Description').Text);

               {Set the description label for the code based dropdown.}

            TempLabel := TLabel(FindComponent(DescFieldName));
            TempLabel.Caption := MainTable.FieldByName(DescFieldName).Text;
            TempLabel.Hint := CodeTable.FieldByName('Description').Text;

          end;  {else of If (TComponent(Sender).Tag in DescriptionIndexedLookups)}

end;  {SetCodeOnLookupCloseUp}

{=============================================================}
Procedure TParcelCommercialSiteForm.MainDataSourceDataChange(Sender: TObject;
                                                             Field: TField);

begin
     {For some reason the lookup boxes were not being filled in with the
      value in the underlying MainTable field when the form was initialized,
      so this fills in the fields so that the data is visible. Note that this
      does not cause the table to be marked modified. This also occurs during
      scrolling, so we will fill the fields in by hand.}

  If ((not InitializingForm) and
      (Field = nil))
    then
      begin
        RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

          {If they changed sites, delete the related site tabs for the previous site and
           add the ones for the present site. Note that this also gets called in the delete case,
           i.e if they delete a site, they have switched sites and this routine gets called. Note that
           if they deleted the last site, then we will not add the tabs back.}

        If (Site <> MainTable.FieldByName('Site').AsInteger)
          then
            begin
              Site := MainTable.FieldByName('Site').AsInteger;

              DeleteInventoryTabsForProcessingType(ParcelTabSet, TabTypeList, ProcessingType, 'C', False);

                {If the lookup table is not initialized, then created it.}

              If (LookupTable = nil)
                then
                  begin
                    LookupTable := TTable.Create(Self);
                    LookupTable.DatabaseName := 'PASsystem';
                  end;  {If (LookupTable = nil)}

              If (Site > 0)
                then SetCommercialInventoryTabsForSite(ParcelTabSet, TabTypeList, LookupTable,
                                                       TaxRollYr, SwisSBLKey,
                                                       ProcessingType, MainTable.FieldByName('Site').AsInteger,
                                                       SalesNumber, CommBuildingNo, CommBuildingSection);

            end;  {If (Site <> MainTable.FieldByName('Site').AsInteger)}

      end;  {If ((not InitializingForm) and ...}

end;  {MainDataSourceDataChange}

{==============================================================}
Procedure TParcelCommercialSiteForm.MainTableNewRecord(DataSet: TDataSet);

{FXX11142003-1: Make sure that all float and integer fields are initialized to 0.}

begin
  InitializeFieldsForRecord(DataSet);
end;

{==============================================================}
Procedure TParcelCommercialSiteForm.MainTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in the Self var.}

var
  I : Integer;
  Quit : Boolean;

begin
    {CHG10281997-1: Dual mode processing.}

  If (MainTable.State = dsInsert)
    then RecordAction := raInserted
    else RecordAction := raEdited;

    {If they are inserting a record, then we want figure out what the next
     site record # is.}

  If ((not InitializingForm) and
      (MainTable.State = dsInsert))
    then
      begin
          {When the form first initialized, we set the text of the lookup boxes
           to match the values of the underlying fields. However, when they click
           insert, the text does not go away, so this clears it.}

        For I := 1 to (ComponentCount - 1) do
          If (Components[I] is TwwDBLookupCombo)
            then
              with Components[I] as TwwDBLookupCombo do
                Text := '';

          {Set the tax roll year and SBL Key.}

        MainTable.FieldByName('TaxRollYr').Text  := Take(4, TaxRollYr);
        MainTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);

          {Now figure out the next note number by looking at the last note in the range.}

        If (GetRecordCount(MainTable) = 0)
          then MainTable.FieldByName('Site').AsInteger := 1
          else
            begin
               {If the lookup table has not yet been created,
                 then create and open it.}


              SiteLookupTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                                        ProcessingType);

              SiteLookupTable.CancelRange;
              SetRangeForTable(SiteLookupTable);

                {There are Site records for this parcel, so let's
                 get the last one and look at the Site number.}

              try
                SiteLookupTable.Last;
              except
                SystemSupport(010, SiteLookupTable, 'Error getting last in residential site table.',
                              UnitName, GlblErrorDlgBox);
              end;

              MainTable.FieldByName('Site').AsInteger := SiteLookupTable.FieldByName('Site').AsInteger + 1;

            end;  {else of If (MainTable.RecordCount = 0)}

          {Now insert a Commercial building record for this site.
           Note that this is a table created on the fly, so if it is
           not yet open, then open it now.}

        OpenTableForProcessingType(ComBldgTable,
                                   CommercialBldgTableName,
                                   ProcessingType, Quit);

        ComBldgTable.Insert;
        ComBldgTable.FieldByName('TaxRollYr').Text  := Take(4, TaxRollYr);
        ComBldgTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
        ComBldgTable.FieldByName('Site').AsInteger := MainTable.FieldByName('Site').AsInteger;
        ComBldgTable.FieldByName('BuildingNumber').AsInteger := 1;
        ComBldgTable.FieldByName('BuildingSection').AsInteger := 1;

        try
          ComBldgTable.Post;
        except
          SystemSupport(011, ComBldgTable, 'Error posting Com bldg record.',
                        UnitName, GlblErrorDlgBox);
        end;

          {FXX03041998-7: Need to add the commercial bldg table to NY, too
                          if in dual processing mode.}

        If GlblModifyBothYears
          then
            begin
              OpenTableForProcessingType(ComBldgTable, CommercialBldgTableName,
                                         OppositeProcessingType, Quit);

              If not FindKeyOld(ComBldgTable,
                                ['TaxRollYr', 'SwisSBLKey', 'Site',
                                 'BuildingNumber', 'BuildingSection'],
                                [OppositeTaxYear, Take(26, SwisSBLKey),
                                 MainTable.FieldByName('Site').Text,
                                 '1', '1'])
                then
                  begin
                    ComBldgTable.Insert;
                    ComBldgTable.FieldByName('TaxRollYr').Text  := OppositeTaxYear;
                    ComBldgTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
                    ComBldgTable.FieldByName('Site').AsInteger := MainTable.FieldByName('Site').AsInteger;
                    ComBldgTable.FieldByName('BuildingNumber').AsInteger := 1;
                    ComBldgTable.FieldByName('BuildingSection').AsInteger := 1;

                    try
                      ComBldgTable.Post;
                    except
                      SystemSupport(011, ComBldgTable, 'Error posting opposite year Com bldg record.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                  end;  {If not FindKeyOld(ComBldgTable ...}

            end;  {If GlblModifyBothYears}

      end;  {If ((not InitializingForm) and}

  If not InitializingForm
    then CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

end;  {MainTableAfterEdit}

  {Validity checking procedures.}

{==============================================================}
Procedure TParcelCommercialSiteForm.EditEffectiveYearBuiltExit(Sender: TObject);

begin
    {FXX03041998-6: Had wrong field name - it should be effective year
                    built instead of year built.}

  If not YearEntryIsValid(MainTable.FieldByName('EffectiveYearBuilt').Text)
    then
      begin
        MessageDlg('Please enter a valid YYYY year. (i.e. 1996)',
                   mtError, [mbOK], 0);
        SetFocus;
      end;

end;  {EditYearBuiltExit}

{=========================================================================}
Procedure TParcelCommercialSiteForm.MainTableBeforeDelete(DataSet: TDataset);

begin
  If (MessageDlg('Warning! If you delete this site, all building, land, improvement, income\expense,'+
                 ' and rent records will be deleted also.' + #13 +
                 'Do you want to proceed?', mtWarning, [mbYes, mbNo], 0) = idNo)
     then Abort
     else DeletedSiteNum := MainTable.FieldByName('Site').AsInteger;

end;  {MainTableBeforeDelete}

{==============================================================}
Procedure TParcelCommercialSiteForm.MainTableAfterDelete(DataSet: TDataset);

{After a delete, we should always reset the range.}

var
  TempTable : TTable;
  Quit, Found : Boolean;
  OppositeYearProcessingType : Integer;

begin
  Found := False;
  MainTable.DisableControls;
  MainTable.CancelRange;
  SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}
  MainTable.EnableControls;

    {Now delete all the records for this site.}

  Cursor := crHourGlass;
  StatusPanel.Visible := True;
  Quit := False;

  TempTable := TTable.Create(Self);
  TempTable.DatabaseName := 'PASsystem';
  TempTable.TableType := ttdBase;

  StatusPanel.Caption := 'Please wait... deleting building records for site ' + IntToStr(DeletedSiteNum);
  StatusPanel.Repaint;

    {FXX11291999-1: Do not use DeleteRecordsForParcel - it cancels the range first.}

  TempTable.IndexName := 'BYYEAR_SBL_SITE_BLDGNUM_SECT';
  OpenTableForProcessingType(TempTable, CommercialBldgTableName, ProcessingType, Quit);

    {FXX08012000-1: Not setting range on commercial bldg before delete.}

  SetRangeOld(TempTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site', 'BuildingNumber', 'BuildingSection'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '0', '0'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '32000', '32000']);

  If not Quit
    then DeleteTableRange(TempTable);

  StatusPanel.Caption := 'Please wait... deleting land records for site ' + IntToStr(DeletedSiteNum);
  StatusPanel.Repaint;

  TempTable.Close;
  TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE_LANDNUM';

  If not Quit
    then OpenTableForProcessingType(TempTable, CommercialLandTableName, ProcessingType, Quit);

    {FXX10291997-1: All the inventory records were being deleted for parc
                    instead of just that site. We need to set a range.}

   SetRangeOld(TempTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site', 'LandNumber'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '0'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '32000']);

  If not Quit
    then DeleteTableRange(TempTable);

  StatusPanel.Caption := 'Please wait... deleting improvement records for site ' + IntToStr(DeletedSiteNum);
  StatusPanel.Repaint;

    {FXX10192001-2: The closing of the table and setting of the index name
                    were in the wrong spot.}

  TempTable.Close;
  TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE_IMPNO';
  If not Quit
    then OpenTableForProcessingType(TempTable, CommercialImprovementsTableName, ProcessingType, Quit);

    {FXX10291997-1: All the inventory records were being deleted for parc
                    instead of just that site. We need to set a range.}

  SetRangeOld(TempTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site', 'ImprovementNumber'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '0'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '32000']);

  If not Quit
    then DeleteTableRange(TempTable);

  StatusPanel.Caption := 'Please wait... deleting income\expense records for site ' + IntToStr(DeletedSiteNum);
  StatusPanel.Repaint;

  TempTable.Close;
  TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE';
  If not Quit
    then OpenTableForProcessingType(TempTable, CommercialIncomeExpenseTableName, ProcessingType, Quit);

    {FXX10291997-1: All the inventory records were being deleted for parc
                    instead of just that site. We need to set a range.}

  SetRangeOld(TempTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum)],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum)]);

  If not Quit
    then DeleteTableRange(TempTable);

  StatusPanel.Caption := 'Please wait... deleting rent records for site ' + IntToStr(DeletedSiteNum);
  StatusPanel.Repaint;

  TempTable.Close;
  TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE_USE';
  If not Quit
    then OpenTableForProcessingType(TempTable, CommercialRentTableName, ProcessingType, Quit);

    {FXX10291997-1: All the inventory records were being deleted for parc
                    instead of just that site. We need to set a range.}

  SetRangeOld(TempTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site', 'UseNumber'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '0'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '32000']);

  If not Quit
    then DeleteTableRange(TempTable);

    {CHG10281997-1: Dual mode processing.}
    {First see if this site exists in the opposite year, too.}

  If ((not Quit) and
      GlblModifyBothYears)
    then Found := FindKeyOld(OppositeYearComSiteTable,
                              ['TaxRollYr', 'SwisSBLKey', 'Site'],
                             [OppositeTaxYear, SwisSBLKey,
                              IntToStr(DeletedSiteNum)]);

    {If found, then delete the site in the opposite year.}

  If ((not Quit) and
      Found and
      GlblModifyBothYears)
    then
      begin
          {FXX12201999-4: Was not deleting NY commercial site - using wrong processing type.}

        OppositeYearProcessingType := NextYear;
        StatusPanel.Caption := 'Please wait... deleting Site record ' + IntToStr(DeletedSiteNum);
        StatusPanel.Repaint;

        TempTable.Close;
        TempTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SITE';
        OpenTableForProcessingType(TempTable, CommercialSiteTableName, OppositeYearProcessingType, Quit);

          {FXX10291997-1: All the inventory records were being deleted for parc
                          instead of just that site. We need to set a range.}

        SetRangeOld(TempTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum)],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum)]);

        If not Quit
          then DeleteTableRange(TempTable);

        StatusPanel.Caption := 'Please wait... deleting building records for site ' + IntToStr(DeletedSiteNum);
        StatusPanel.Repaint;

        TempTable.Close;
        TempTable.IndexName := 'BYYEAR_SBL_SITE_BLDGNUM_SECT';

        OpenTableForProcessingType(TempTable, CommercialBldgTableName, OppositeYearProcessingType, Quit);

          {FXX10291997-1: All the inventory records were being deleted for parc
                          instead of just that site. We need to set a range.}

        SetRangeOld(TempTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site', 'BuildingNumber', 'BuildingSection'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '0', '0'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '32000', '32000']);

        If not Quit
          then DeleteTableRange(TempTable);

        StatusPanel.Caption := 'Please wait... deleting land records for site ' + IntToStr(DeletedSiteNum);
        StatusPanel.Repaint;

        TempTable.Close;
        TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE_LANDNUM';
        If not Quit
          then OpenTableForProcessingType(TempTable, CommercialLandTableName, OppositeYearProcessingType, Quit);

        SetRangeOld(TempTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site', 'LandNumber'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '0'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '32000']);

        If not Quit
          then DeleteTableRange(TempTable);

        StatusPanel.Caption := 'Please wait... deleting improvement records for site ' + IntToStr(DeletedSiteNum);
        StatusPanel.Repaint;

        TempTable.Close;
        TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE_IMPNO';
        If not Quit
          then OpenTableForProcessingType(TempTable, CommercialImprovementsTableName, OppositeYearProcessingType, Quit);

        SetRangeOld(TempTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site', 'ImprovementNumber'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '0'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '32000']);

        If not Quit
          then DeleteTableRange(TempTable);

        StatusPanel.Caption := 'Please wait... deleting income\expense records for site ' + IntToStr(DeletedSiteNum);
        StatusPanel.Repaint;

        TempTable.Close;
        TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE';
        If not Quit
          then OpenTableForProcessingType(TempTable, CommercialIncomeExpenseTableName, OppositeYearProcessingType, Quit);

        SetRangeOld(TempTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum)],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum)]);

        If not Quit
          then DeleteTableRange(TempTable);

        StatusPanel.Caption := 'Please wait... deleting rent records for site ' + IntToStr(DeletedSiteNum);
        StatusPanel.Repaint;

        TempTable.Close;
        TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE_USE';
        If not Quit
          then OpenTableForProcessingType(TempTable, CommercialRentTableName, OppositeYearProcessingType, Quit);

        SetRangeOld(TempTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site', 'UseNumber'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '0'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '32000']);

        If not Quit
          then DeleteTableRange(TempTable);

      end;  {If ((not Quit) and ...}

  StatusPanel.Visible := False;

  TempTable.Close;
  TempTable.Free;

    {Subtract one from the number of sites.}

  NumComSites := NumComSites - 1;
  EditNumComSites.Text := IntToStr(NumComSites);


  If Quit
    then MessageDlg('Error! Site ' + IntToStr(DeletedSiteNum) + ' was not deleted successfully.', mtError,
                    [mbOK], 0)
    else MessageDlg('Site ' + IntToStr(DeletedSiteNum) + ' was deleted successfully.', mtInformation,
                    [mbOK], 0);

    {FXX03031998-2: Set focus back to the first field after post, delete.}

  SetFocusToFirstField;

end;  {MainTableAfterDelete}

{==============================================================}
Procedure TParcelCommercialSiteForm.MainTableBeforePost(DataSet: TDataset);

{If this is insert state, then fill in the SBL key and the
 tax roll year.}

var
  ReturnCode : Integer;
  ProceedWithPost : Boolean;

begin
  ProceedWithPost := False;

    {FXX05151998-3: Don't ask save on close form if don't want to see save.}

  If GlblAskSave
    then
      begin
          {FXX11061997-2: Remove the "save before exiting" prompt because it
                          is confusing. Use only "Do you want to save.}

        ReturnCode := MessageDlg('Do you wish to save your commercial site changes?', mtConfirmation,
                                 [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idYes : ProceedWithPost := True;

          idNo : If (MainTable.State = dsInsert)
                   then MainTable.Cancel
                   else RefreshNoPost(MainTable);

          idCancel : Abort;

        end;  {case ReturnCode of}

      end  {If GlblAskSave}
    else ProceedWithPost := True;

    {If they are adding a new site, then let's add one to the number of sites.}

  If ((MainTable.State = dsInsert) and
      ProceedWithPost)
    then
      begin
        NumComSites := NumComSites + 1;
        EditNumComSites.Text := IntToStr(NumComSites);
      end;

    {Mark the site as being changed.}

  If ProceedWithPost
    then
      begin
        MainTable.FieldByName('LastChangeByName').Text := GlblUserName;
        MainTable.FieldByName('LastChangeDate').AsDateTime := Date;

      end;  {If ProceedWithPost}

end;  {MainTableBeforePost}

{==============================================================}
Procedure TParcelCommercialSiteForm.MainTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.}

var
  Found : Boolean;
  NumChanges : Integer;

begin
  Found := False;
  NumChanges := RecordChanges(Self, Caption, MainTable, SwisSBLKey,
                              FieldTraceInformationList);

  If (NumChanges > 0)
    then ParcelChanged := True;

   {CHG10281997-1: Dual mode processing.}

  If (GlblModifyBothYears and
      (ProcessingType <> SalesInventory))
    then
      begin
          {Set the table in insert or edit mode depending on what action
           the user did.}

        case RecordAction of
          raInserted : begin
                         OppositeYearComSiteTable.Insert;
                         Found := True;

                       end;  {raInserted}

          raEdited : begin
                       Found := FindKeyOld(OppositeYearComSiteTable,
                                           ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                           [OppositeTaxYear,
                                            ExtractSSKey(ParcelTable),
                                            MainTable.FieldByName('Site').Text]);

                       If Found
                         then OppositeYearComSiteTable.Edit;

                     end;  {raEdited}

        end;  {case RecordAction of}

        CreateFieldValuesAndLabels(Self, OppositeYearComSiteTable,
                                   FieldTraceInformationList);

          {Copy the fields from the main table to the new table, but make
           sure that we do not copy the tax roll year.}

        If Found
          then
            begin
              CopyFields(MainTable, OppositeYearComSiteTable,
                         ['TaxRollYr'], [OppositeTaxYear]);

              try
                OppositeYearComSiteTable.Post;
              except
                SystemSupport(050, OppositeYearComSiteTable,
                              'Error posting opposite year record.', UnitName,
                              GlblErrorDlgBox);
              end;

              If (RecordChanges(Self, Caption,
                                OppositeYearComSiteTable, SwisSBLKey,
                                FieldTraceInformationList) > 0)
                then OppositeYearParcelChanged := True;

            end;  {If Found}

      end;  {If GlblModifyBothYears}

    {FXX03031998-2: Set focus back to the first field after post, delete.}

  SetFocusToFirstField;

end;  {MainTableAfterPost}

{==============================================================}
Procedure TParcelCommercialSiteForm.CloseButtonClick(Sender: TObject);

{Note that the close button is a close for the whole
 parcel maintenance.}

{To close the whole parcel maintenance, we will once again use
 the base popup menu. We will simulate a click on the
 "Exit Parcel Maintenance" of the BasePopupMenu which will
 then call the Close of ParcelTabForm. See the locate button
 click above for more information on how this works.}

var
  I : Integer;
  CanClose : Boolean;

begin
    {Search for the name of the menu item that has "Exit"
     in it, and click it.}

  For I := 0 to (PopupMenu.Items.Count - 1) do
    If (Pos('Exit', PopupMenu.Items[I].Name) <> 0)
      then
        begin
            {FXX06141999-5: Ask if person wants to save before exiting
                            to locate dialog.}

          FormCloseQuery(Sender, CanClose);

          If CanClose
            then PopupMenu.Items[I].Click;

        end;  {If (Pos('Exit',  ...}

end;  {CloseButtonClick}

{====================================================================}
Procedure TParcelCommercialSiteForm.FormCloseQuery(    Sender: TObject;
                                              var CanClose: Boolean);

begin
  GlblParcelPageCloseCancelled := False;
  CanClose := True;
  ClosingForm := True;

    {First see if anything needs to be saved. In order to
     determine if there are any changes, we need to sychronize
     the fields with what is in the DB edit boxes. To do this,
     we call the UpdateRecord. Then, if there are any changes,
     the Modified flag will be set to True.}

  If (MainTable.State in [dsInsert, dsEdit])
    then MainTable.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode. Note that sometimes a record can be marked even
     if there were no changes if a person clicks on a drop down box (even without changing
     the value). So, since we are recording field values before any changes, we
     will compare them to now and if there are no changes, we will cancel this
     edit or insert.}

  If ((not MainTable.ReadOnly) and
      (MainTable.State in [dsEdit, dsInsert]) and
      MainTable.Modified)
    then
      If (NumRecordChanges(Self, MainTable, FieldTraceInformationList) = 0)
        then MainTable.Cancel
        else
          begin
            try
              MainTable.Post;
            except
              CanClose := False;
              GlblParcelPageCloseCancelled := True;
            end;

          end;  {else of If (NumRecordChanges(Self, ...}

  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure TParcelCommercialSiteForm.FormClose(    Sender: TObject;
                                         var Action: TCloseAction);

var
  TempGlblAskSave, Quit : Boolean;
  SBLRec : SBLRecord;

begin
    {Now, if the parcel changed, then update the parcel and commercial site table.}

  If (ParcelChanged and
      (ProcessingType <> SalesInventory))
    then MarkRecChanged(ParcelTable, UnitName);

    {CHG10281997-1: Dual mode processing.}

  If OppositeYearParcelChanged
    then
      begin
          {Close the parcel and site table and reopen them for the
           opposite year.}

        ParcelTable.Close;
        MainTable.Close;

        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   OppositeProcessingType, Quit);

        OpenTableForProcessingType(MainTable, CommercialSiteTableName,
                                   OppositeProcessingType, Quit);

          {FXX11201997-2: We were not getting opposite year parcel table before
                          trying to mark it as changed.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          FindKeyOld(ParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                     [OppositeTaxYear, SwisCode, Section,
                      SubSection, Block, Lot, Sublot, Suffix]);

           {FXX11211997-9: Do the same for inv. sites.}

        FindKeyOld(MainTable, ['TaxRollYr', 'SwisSBLKey', 'Site'],
                   [OppositeTaxYear, SwisSBLKey, IntToStr(Site)]);

         {Turn off GlblAskSave so don't get 2nd msg asking if
           want to save.}

        TempGlblAskSave := GlblAskSave;
        GlblAskSave := False;
        MarkRecChanged(ParcelTable, UnitName);
        MarkRecChanged(MainTable, UnitName);
        GlblAskSave := TempGlblAskSave;

      end;  {If OppositeYearParcelChanged}

    {Close all tables here.}

  CloseTablesForForm(Self);

    {Close and free up the lookup tables.}

  If (LookupTable <> nil)
    then
      begin
        LookupTable.Close;
        LookupTable.Free;
      end;

  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

  Action := caFree;

end;  {FormClose}

end.