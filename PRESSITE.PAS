unit Pressite;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, Tabs,
  UtilPrcl;

type
  TParcelResidentialSiteForm = class(TForm)
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    CloseButton: TBitBtn;
    Navigator: TDBNavigator;
    EditRouteNumber: TDBEdit;
    PropClassLookup: TwwDBLookupCombo;
    NeighborhoodCodeLookup: TwwDBLookupCombo;
    NeighborhoodRatingLookup: TwwDBLookupCombo;
    DesirabilityLookup: TwwDBLookupCombo;
    ZoningLookup: TwwDBLookupCombo;
    SewerLookup: TwwDBLookupCombo;
    WaterLookup: TwwDBLookupCombo;
    UtilityLookup: TwwDBLookupCombo;
    RoadTypeLookup: TwwDBLookupCombo;
    TrafficLookup: TwwDBLookupCombo;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    ElevationLookup: TwwDBLookupCombo;
    Label20: TLabel;
    Label5: TLabel;
    CodeTable: TwwTable;
    DCEntryLookup: TwwDBLookupCombo;
    PhysicalChangeLookup: TwwDBLookupCombo;
    Label30: TLabel;
    Label4: TLabel;
    EditSBL: TMaskEdit;
    Label7: TLabel;
    EditLocation: TEdit;
    Label21: TLabel;
    EditSite: TDBEdit;
    SaleNumberLabel: TLabel;
    EditSalesNumber: TEdit;
    EditName: TDBEdit;
    Label3: TLabel;
    EditLastChangeDate: TDBEdit;
    Label33: TLabel;
    EditLastChangeByName: TDBEdit;
    Label31: TLabel;
    EditNumSites: TEdit;
    PropertyClassDesc: TLabel;
    NeighborhoodDesc: TLabel;
    StatusPanel: TPanel;
    InactiveLabel: TLabel;
    OppositeYearResSiteTable: TTable;
    Label2: TLabel;
    Label41: TLabel;
    Label44: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    NeighborhoodTypeLookup: TwwDBLookupCombo;
    SetFocusTimer: TTimer;
    LastInspectionDateEdit: TDBEdit;
    Label1: TLabel;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    ResBldgTable: TTable;
    PartialAssessmentLabel: TLabel;
    ZoningText: TDBText;
    pnlRevaluation: TPanel;
    ReplacementCostLabel: TLabel;
    EditReplacementCost: TDBEdit;
    RCNLDLabel: TLabel;
    EditRCNMinusDep: TDBEdit;
    LandValueLabel: TLabel;
    EditLandValue: TDBEdit;
    ModelEstimateLabel: TLabel;
    EditModelEstimate: TDBEdit;
    MarketEstimateLabel: TLabel;
    EditMarketEstimate: TDBEdit;
    FinalLandValueLabel: TLabel;
    EditFinalLandValue: TDBEdit;
    FinalTotalValueLabel: TLabel;
    EditFinalTotalValue: TDBEdit;
    pnlExtendedInventory: TPanel;
    lbCivicAssociation: TLabel;
    cmbxCivicAssoc: TwwDBLookupCombo;
    lbSchoolNeighborhood: TLabel;
    cmbxSchoolNeighborhood: TwwDBLookupCombo;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterEdit(DataSet: TDataset);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure MainTableAfterDelete(DataSet: TDataset);
    procedure CodeLookupEnter(Sender: TObject);
    procedure MainDataSourceDataChange(Sender: TObject; Field: TField);
    procedure MainTableNewRecord(DataSet: TDataset);
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure MainTableBeforeDelete(DataSet: TDataset);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure SetCodeOnLookupCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);

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

        {These var.'s are for tracing changes.}

    FieldValuesList,
    FieldLabelsList : TStringList;

    SiteLookupTable : TTable;  {Temp table for finding next site number.}
    LookupTable : TTable;  {Table for keeping tabs in synch with the site (see OnDataChange event).}

    InitializingForm : Boolean;  {Are we initializing the form now?}
    ClosingForm,
    ClosingFormQuery : Boolean;  {Are we closing a form right now?}
    DropDownShowing : Boolean;  {Is the drop down box showing now?}

      {Have there been any changes?}

    ParcelChanged : Boolean;
    DeletedSiteNum : Integer;  {What site are they presently deleting?}

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

    Procedure FillInNumSites(NumResSites,
                             NumComSites : Integer);
    {CHG02122000-2: Add last inspection date.}

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
  NeighborhoodCode = 20;
  NeighborhoodType = 30;
  NeighborhoodRating = 40;
  Desirability = 50;
  Zoning = 60;
  Sewer = 70;
  Water = 80;
  Utility = 90;
  RoadType = 100;
  DCEntryCode = 110;
  PhysicalChange = 120;
  Traffic = 130;
  Elevation = 140;
  CivicAssoc = 150;
  SchlNbhd = 160;

    {Now we will put the lookups that are description based in a set for later
     reference.}

  DescriptionIndexedLookups : set of 0..250 =
         [NeighborhoodType, NeighborhoodRating,
          Desirability, Zoning, Sewer, Water, Utility, RoadType, DCEntryCode,
          PhysicalChange, Traffic, Elevation, CivicAssoc, SchlNbhd];  {LLL2}

{=====================================================================}
Procedure TParcelResidentialSiteForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TParcelResidentialSiteForm.SetRangeForTable(Table : TTable);

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
Procedure TParcelResidentialSiteForm.FillInNumSites(NumResSites,
                                                    NumComSites : Integer);

{CHG02122000-2: Add last inspection date.}

begin
  EditNumSites.Text := IntToStr(NumResSites) + '/' + IntToStr(NumComSites);
end;

{====================================================================}
Procedure TParcelResidentialSiteForm.InitializeForm;

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
  UnitName := 'PRESSITE.PAS';  {mmm1}
  ParcelChanged := False;
  ClosingForm := False;
  ClosingFormQuery := False;
  InitializingForm := True;
  DropDownShowing := False;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        FieldTraceInformationList := TList.Create;

          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then MainTable.ReadOnly := True;

            {If this is inquire mode or the processing type is not the the
             main (i.e. Glbl Tax Year), let's open it in
             readonly mode.}

          {CHG06302012-1(2.28.4.33)[PAS-412]:  Allow for sales inventory editing.}

        If not MainTable.ReadOnly
        then MainTable.ReadOnly := not DetermineEditStatusForInventoryForm(EditMode, ProcessingType, GlblTaxYearFlg, glblAllowSalesInventoryEdit);

          {There are so many tables on this form, we will
           set the table name and open them implicitly.
           OpenTablesForForm is a method in PASUTILS.}

        OpenTablesForForm(Self, ProcessingType);

          {If this is sales inventory, then let's set the index to include the
           sales number. Otherwise, let's do the index without the sales number.}

        If (ProcessingType = SalesInventory)
          then MainTable.IndexName := 'BYSWISSBLKEY_SALESNUMBER_SITE'
          else MainTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SITE';

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
              If (ProcessingType = SalesInventory)
                then FindKeyOld(MainTable,
                                ['SwisSBLKey', 'SalesNumber', 'Site'],
                                [SwisSBLKey, IntToStr(SalesNumber), IntToStr(Site)])
                else FindKeyOld(MainTable,
                                ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                [TaxRollYr, SwisSBLKey, IntToStr(Site)]);
            except
              SystemSupport(006, MainTable, 'Error getting residential site record.',
                            UnitName, GlblErrorDlgBox);
            end;

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

          {FXX12151997-1: Make sure that the tital does not overlap the
                          assessed values.}

        TitleLabel.Caption := 'Residential Site';

(*        case EditMode of   {mmm5}
          'A' : TitleLabel.Caption := 'Residential Site Add';
          'M' : TitleLabel.Caption := 'Residential Site Modify';
          'V' : TitleLabel.Caption := 'Residential Site View';

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

            end;  {MainTable.FindKey([TaxRollYr, SwisSBLKey, Site])}

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);

          {Now set the year label.}

        SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);

          {Set the SBL in the SBL edit so that it is visible.
           Note that it is not data aware since if there are
           no records, we have nothing to get the SBL from.}

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);


          {CHG02122000-2: Add last inspection date.}

        FillInNumSites(NumResSites, NumComSites);

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

        TFloatField(MainTable.FieldByName('ReplacementCost')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('RCNLessDepreciation')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('LandValue')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('ModelEstimate')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('MarketEstimate')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('FinalLandValue')).DisplayFormat := CurrencyNormalDisplay;
        TFloatField(MainTable.FieldByName('FinalTotalValue')).DisplayFormat := CurrencyNormalDisplay;

          {CHG03112002-1: Allow for suppression of inventory values.}

        If not GlblShowInventoryValues
        then pnlRevaluation.Visible := False;
(*            begin
              ReplacementCostLabel.Visible := False;
              RCNLDLabel.Visible := False;
              LandValueLabel.Visible := False;
              ModelEstimateLabel.Visible := False;
              MarketEstimateLabel.Visible := False;
              FinalLandValueLabel.Visible := False;
              FinalTotalValueLabel.Visible := False;
              EditReplacementCost.Visible := False;
              EditRCNMinusDep.Visible := False;
              EditLandValue.Visible := False;
              EditModelEstimate.Visible := False;
              EditMarketEstimate.Visible := False;
              EditFinalLandValue.Visible := False;
              EditFinalTotalValue.Visible := False;

            end;  {If not GlblShowInventoryValues}  *)

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

        OpenTableForProcessingType(OppositeYearResSiteTable,
                                   ResidentialSiteTableName,
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

        If glblShowExtendedNeighborhoodInfo
        then pnlExtendedInventory.Visible := True;

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  InitializingForm := False;

end;  {InitializeForm}

{===========================================================}
Procedure TParcelResidentialSiteForm.SetFocusToFirstField;

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
Procedure TParcelResidentialSiteForm.SetFocusTimerTimer(Sender: TObject);

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
Procedure TParcelResidentialSiteForm.EditEnter(Sender: TObject);

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
Procedure TParcelResidentialSiteForm.EditExit(Sender: TObject);

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
Function TParcelResidentialSiteForm.DetermineCodeTableName(Tag : Integer) : String;

{Based on the tag of the lookup combo box, what table should we open in the
 code table? Note that the constants below are declared right after the
 IMPLEMENTATION directive.}

begin
  case Tag of  {LLL3}
    PropertyClass : Result := 'ZPropClsTbl';
    NeighborhoodCode : Result := 'ZInvNghbrhdCodeTbl';
    NeighborhoodType : Result := 'ZInvNghbrhdTypeTbl';
    NeighborhoodRating : Result := 'ZInvNghbrhdRatingTbl';

      {FXX01211998-3: The site desirability codes are different for
                      commercial and residential.}

    Desirability : Result := 'ZInvResSiteDesireTbl';
    Zoning : Result := 'ZInvZoningCodeTbl';
    Sewer : Result := 'ZInvSewerTbl';
    Water : Result := 'ZInvWaterTbl';
    Utility : Result := 'ZInvUtilityTbl';
    RoadType : Result := 'ZInvRoadTypeTbl';
    DCEntryCode : Result := 'ZInvEntryCodeTbl';
    PhysicalChange : Result := 'ZInvPhysicalChgTbl';
    Traffic : Result := 'ZInvTrafficCodeTbl';
    Elevation : Result := 'ZInvElevationCodeTbl';
    CivicAssoc : Result := 'zInvCivicAssoc';
    SchlNbhd : Result := 'zInvSchoolNbhd';

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{========================================================================}
Procedure TParcelResidentialSiteForm.SetCodeTableName(Tag : Integer);

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
Procedure TParcelResidentialSiteForm.CodeLookupEnter(Sender: TObject);

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
                             IntToStr(CodeTable.FieldByName('MainCode').DataSize) +
                             #9 + 'MainCode Code');
              end
            else
              begin
                Selected.Clear;
                Selected.Add('MainCode' + #9 +
                             IntToStr(CodeTable.FieldByName('MainCode').DataSize) +
                             #9 + 'MainCode Code');
                Selected.Add('Description' + #9 + '30' + #9 + 'Description Description');

              end;  {else of If (Tag in DescriptionIndexedLookups)}

        end;  {If (CodeTable.TableName <> DetermineCode}

    {FXX03031998-8: Refresh the dropdowns when we exit code lookup enter
                    since we were having problems with text disapperaing.}

  RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

end;  {CodeLookupEnter}

{==============================================================}
Procedure TParcelResidentialSiteForm.SetCodeOnLookupCloseUp(Sender: TObject;
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
      MainTable.Modified and
      Modified)
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
                                              CodeTable.FieldByName('MainCode').Text;

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
                DescFieldName := DetermineDescriptionField(FieldName);

                FieldSize := MainTable.FieldByName(DescFieldName).DataSize - 1;  {Minus 1 because it includes #0.}

              end;  {If (Tag in DescriptionIndexedLookups)}

              {Now, if the field is now blank, then blank out the code.
               Otherwise, fill in the code in the table.}

            If (Deblank(MainTable.FieldByName(FieldName).Text) = '')
              then MainTable.FieldByName(DescFieldName).Text := ''
              else MainTable.FieldByName(DescFieldName).Text :=
                   Take(FieldSize, CodeTable.FieldByName('Description').Text);

               {Set the description label for the code based dropdown.}

            TempLabel := TLabel(FindComponent(DescFieldName));
            TempLabel.Caption := MainTable.FieldByName(DescFieldName).Text;
            TempLabel.Hint := CodeTable.FieldByName('Description').Text;

          end;  {else of If (TComponent(Sender).Tag in DescriptionIndexedLookups)}

end;  {SetCodeOnLookupCloseUp}

{============================================================================}
Procedure TParcelResidentialSiteForm.MainDataSourceDataChange(Sender: TObject;
                                                              Field: TField);

begin
     {For some reason the lookup boxes were not being filled in with the
      value in the underlying MainTable field when the form was initialized,
      so this fills in the fields so that the data is visible. Note that this
      does not cause the table to be marked modified. This also occurs during
      scrolling, so we will fill the fields in by hand.}

  If ((not (InitializingForm or ClosingForm or ClosingFormQuery)) and
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

              DeleteInventoryTabsForProcessingType(ParcelTabSet, TabTypeList, ProcessingType, 'R', False);

                {If the lookup table is not initialized, then created it.}

              If (LookupTable = nil)
                then
                  begin
                    LookupTable := TTable.Create(Self);
                    LookupTable.DatabaseName := 'PASsystem';
                  end;  {If (LookupTable = nil)}

              If (Site > 0)
                then SetResidentialInventoryTabsForSite(ParcelTabSet, TabTypeList, LookupTable,
                                                        TaxRollYr, SwisSBLKey,
                                                        ProcessingType, MainTable.FieldByName('Site').AsInteger,
                                                        SalesNumber);

            end;  {If (Site <> MainTableSite.AsInteger)}

      end;  {If ((not InitializingForm) and ...}

end;  {MainDataSourceDataChange}

{==============================================================}
Procedure TParcelResidentialSiteForm.MainTableNewRecord(DataSet: TDataset);

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
    {If they are inserting a record, then we want figure out what the next
     site record # is.}

  If (not InitializingForm)
    then
      begin
          {FXX11142003-1: Make sure that all float and integer fields are initialized to 0.}

        InitializeFieldsForRecord(DataSet);

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

              SiteLookupTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
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

          {Now insert a residential building record for this site.}

        OpenTableForProcessingType(ResBldgTable, ResidentialBldgTableName,
                                   ProcessingType, Quit);

        ResBldgTable.Insert;

          {FXX11142003-1: Make sure that all float and integer fields are initialized to 0.}
        InitializeFieldsForRecord(ResBldgTable);
        ResBldgTable.FieldByName('TaxRollYr').Text  := Take(4, TaxRollYr);
        ResBldgTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
        ResBldgTable.FieldByName('Site').AsInteger := MainTable.FieldByName('Site').AsInteger;

        try
          ResBldgTable.Post;
        except
          SystemSupport(011, ResBldgTable, 'Error posting res bldg record.',
                        UnitName, GlblErrorDlgBox);
        end;

        If GlblModifyBothYears
          then
            begin
              OpenTableForProcessingType(ResBldgTable,
                                         ResidentialBldgTableName,
                                         OppositeProcessingType, Quit);

              If not FindKeyOld(ResBldgTable,
                                ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                [OppositeTaxYear, Take(26, SwisSBLKey),
                                 MainTable.FieldByName('Site').Text])
                then
                  begin
                    ResBldgTable.Insert;

                      {FXX11142003-1: Make sure that all float and integer fields are initialized to 0.}
                    InitializeFieldsForRecord(ResBldgTable);

                    ResBldgTable.FieldByName('TaxRollYr').Text  := Take(4, OppositeTaxYear);
                    ResBldgTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
                    ResBldgTable.FieldByName('Site').AsInteger := MainTable.FieldByName('Site').AsInteger;

                    try
                      ResBldgTable.Post;
                    except
                      SystemSupport(011, ResBldgTable, 'Error posting opp year res bldg record.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                  end;  {If not FindKeyOld(ResBldgTable,}

            end;  {If OppositeYearParcelChanged}

      end;  {If ((not InitializingForm) and}

end;  {MainTableNewRecord}

{==============================================================}
Procedure TParcelResidentialSiteForm.MainTableAfterEdit(DataSet: TDataset);

begin
  If not (InitializingForm or ClosingForm)
    then
      begin
        CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

          {FXX03031998-2: Make sure focus is in the property class field
                          after insert begins.  Edit may start by them
                          clicking on a field.}

        If (MainTable.State = dsInsert)
          then SetFocusToFirstField;

      end;  {If not FormIsInitializing}

    {CHG10281997-1: Dual mode processing.}

  If (MainTable.State = dsInsert)
    then RecordAction := raInserted
    else RecordAction := raEdited;

end;  {MainTableAfterEdit}

{===============================================================}
Procedure TParcelResidentialSiteForm.MainTableBeforeDelete(DataSet: TDataset);

begin
  If (MessageDlg('Warning! If you delete this site, all building, land, improvement, income\expense,'+
                 ' and rent records will be deleted also.' + #13 +
                 'Do you want to proceed?', mtWarning, [mbYes, mbNo], 0) = idNo)
     then Abort
     else DeletedSiteNum := MainTable.FieldByName('Site').AsInteger;

end;  {MainTableBeforeDelete}

{==============================================================}
Procedure TParcelResidentialSiteForm.MainTableAfterDelete(DataSet: TDataset);

{After a delete, we should always reset the range.}

var
  TempTable : TTable;
  Quit, Found : Boolean;

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
  TempTable.IndexName := InventoryYear_SwisSBLKey;

  StatusPanel.Caption := 'Please wait... deleting building record for site ' + IntToStr(DeletedSiteNum);
  StatusPanel.Repaint;

  OpenTableForProcessingType(TempTable, ResidentialBldgTableName, ProcessingType, Quit);

    {FXX11262001-2: Include the site as part of the index of the building so that
                    deleting site 2 does not delete the building for site 1.}

  TempTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SITE';

    {FXX10291997-1: All the inventory records were being deleted for parc
                    instead of just that site. We need to set a range.}

  SetRangeOld(TempTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum)],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum)]);

    {FXX11291999-1: Do not use DeleteRecordsForParcel - it cancels the range first.}

  If not Quit
    then DeleteTableRange(TempTable);

  StatusPanel.Caption := 'Please wait... deleting forest records for site ' + IntToStr(DeletedSiteNum);
  StatusPanel.Repaint;

  TempTable.Close;
  TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE_FOREST';
  If not Quit
    then OpenTableForProcessingType(TempTable, ResidentialForestTableName, ProcessingType, Quit);

  SetRangeOld(TempTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site', 'ForestNumber'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '0'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '32000']);

  If not Quit
    then DeleteTableRange(TempTable);

  StatusPanel.Caption := 'Please wait... deleting land records for site ' + IntToStr(DeletedSiteNum);
  StatusPanel.Repaint;

  TempTable.Close;
  TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE_LANDNUM';
  If not Quit
    then OpenTableForProcessingType(TempTable, ResidentialLandTableName, ProcessingType, Quit);

  SetRangeOld(TempTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site', 'LandNumber'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '0'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '32000']);

  If not Quit
    then DeleteTableRange(TempTable);

  StatusPanel.Caption := 'Please wait... deleting improvement records for site ' + IntToStr(DeletedSiteNum);
  StatusPanel.Repaint;

  TempTable.Close;
  TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE_IMPNO';
  If not Quit
    then OpenTableForProcessingType(TempTable, ResidentialImprovementsTableName, ProcessingType, Quit);

  SetRangeOld(TempTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site', 'ImprovementNumber'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '0'],
              [TaxRollYr, SwisSBLKey, IntToStr(DeletedSiteNum), '32000']);

  If not Quit
    then DeleteTableRange(TempTable);

    {CHG10281997-1: Dual mode processing.}
    {First see if this site exists in the opposite year, too.}

  If ((not Quit) and
      GlblModifyBothYears)
    then Found := FindKeyOld(OppositeYearResSiteTable,
                             ['TaxRollYr', 'SwisSBLKey', 'Site'],
                             [OppositeTaxYear, SwisSBLKey,
                              IntToStr(DeletedSiteNum)]);

    {If found, then delete the site in the opposite year.}

  If ((not Quit) and
      Found and
      GlblModifyBothYears)
    then
      begin
        StatusPanel.Caption := 'Please wait... deleting building record for site ' + IntToStr(DeletedSiteNum);
        StatusPanel.Repaint;

        OppositeYearResSiteTable.Delete;

        TempTable.Close;
        TempTable.IndexName := InventoryYear_SwisSBLKey;
        OpenTableForProcessingType(TempTable, ResidentialBldgTableName, OppositeProcessingType, Quit);

        SetRangeOld(TempTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum)],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum)]);

        If not Quit
          then DeleteTableRange(TempTable);

        StatusPanel.Caption := 'Please wait... deleting forest records for site ' + IntToStr(DeletedSiteNum);
        StatusPanel.Repaint;

        TempTable.Close;
        TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE_FOREST';
        If not Quit
          then OpenTableForProcessingType(TempTable, ResidentialForestTableName, OppositeProcessingType,
                                          Quit);

        SetRangeOld(TempTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site', 'ForestNumber'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '0'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '32000']);

        If not Quit
          then DeleteTableRange(TempTable);

        StatusPanel.Caption := 'Please wait... deleting land records for site ' + IntToStr(DeletedSiteNum);
        StatusPanel.Repaint;

        TempTable.Close;
        TempTable.IndexName := 'BYTAXROLLYR_SBL_SITE_LANDNUM';
        If not Quit
          then OpenTableForProcessingType(TempTable, ResidentialLandTableName, OppositeProcessingType, Quit);

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
          then OpenTableForProcessingType(TempTable, ResidentialImprovementsTableName, OppositeProcessingType,
                                          Quit);

        SetRangeOld(TempTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site', 'ImprovementNumber'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '0'],
                    [OppositeTaxYear, SwisSBLKey, IntToStr(DeletedSiteNum), '32000']);

        If not Quit
          then DeleteTableRange(TempTable);

      end;  {If ((not Quit) and ...}

  TempTable.Close;
  TempTable.Free;
  StatusPanel.Visible := False;

  If Quit
    then MessageDlg('Error! Site ' + IntToStr(DeletedSiteNum) + ' was not deleted successfully.', mtError,
                    [mbOK], 0)
    else MessageDlg('Site ' + IntToStr(DeletedSiteNum) + ' was deleted successfully.', mtInformation,
                    [mbOK], 0);

    {Subtract one from the number of sites.}

  NumResSites := NumResSites - 1;

    {CHG02122000-2: Add last inspection date.}

  FillInNumSites(NumResSites, NumComSites);

    {FXX03031998-2: Set focus back to the first field after post, delete.}

  SetFocusToFirstField;

end;  {MainTableAfterDelete}

{==============================================================}
Procedure TParcelResidentialSiteForm.MainTableBeforePost(DataSet: TDataset);

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

        ReturnCode := MessageDlg('Do you wish to save your residential site changes?', mtConfirmation,
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
        NumResSites := NumResSites + 1;

         {CHG02122000-2: Add last inspection date.}

        FillInNumSites(NumResSites, NumComSites);
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
Procedure TParcelResidentialSiteForm.MainTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.}

var
  Found : Boolean;
  FieldNamesList : TStringList;
  NumChanges : Integer;

begin
  Found := False;
      {FXX11101997-3: Pass the screen name into RecordChanges so
                      the screen names are more readable.}
    {FXX12301999-3: Make sure to always carry changes forward if they want them.}

  If not ClosingForm
    then
      begin
        NumChanges := RecordChanges(Self, Caption, MainTable, ExtractSSKey(ParcelTable),
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
                               OppositeYearResSiteTable.Insert;
                               Found := True;

                             end;  {raInserted}

                raEdited : begin
                             Found := FindKeyOld(OppositeYearResSiteTable,
                                                 ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                                 [OppositeTaxYear,
                                                  ExtractSSKey(ParcelTable),
                                                  IntToStr(MainTable.FieldByName('Site').AsInteger)]);

                             If Found
                               then OppositeYearResSiteTable.Edit;

                           end;  {raEdited}

              end;  {case RecordAction of}

               {FXX11101997-6: Combined the CreateFieldValuesAndLabels from UGenSclb
                               and PASUtils for compatibility.}

              FieldNamesList := TStringList.Create;

              CreateFieldValuesAndLabels(Self, OppositeYearResSiteTable,
                                         FieldTraceInformationList);

              FieldNamesList.Free;

                {Copy the fields from the main table to the new table, but make
                 sure that we do not copy the tax roll year.}

              If Found
                then
                  begin
                    CopyFields(MainTable, OppositeYearResSiteTable,
                               ['TaxRollYr'], [OppositeTaxYear]);

                    try
                      OppositeYearResSiteTable.Post;
                    except
                      SystemSupport(050, OppositeYearResSiteTable,
                                    'Error posting opposite year record.', UnitName,
                                    GlblErrorDlgBox);
                    end;

                    If (RecordChanges(Self, Caption,
                                      OppositeYearResSiteTable, SwisSBLKey,
                                      FieldTraceInformationList) > 0)
                      then OppositeYearParcelChanged := True;

                  end;  {If Found}

            end;  {If GlblModifyBothYears}

      end;  {If not ClosingForm}

    {FXX03031998-2: Make sure to put the cursor back at the first control.}

  SetFocusToFirstField;

end;  {MainTableAfterPost}

{==============================================================}
Procedure TParcelResidentialSiteForm.CloseButtonClick(Sender: TObject);

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
Procedure TParcelResidentialSiteForm.FormCloseQuery(    Sender: TObject;
                                              var CanClose: Boolean);

begin
  CanClose := True;
  ClosingForm := True;
  GlblParcelPageCloseCancelled := False;

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

  ClosingFormQuery := False;
  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure TParcelResidentialSiteForm.FormClose(    Sender: TObject;
                                               var Action: TCloseAction);

var
  I : Integer;
  TempGlblAskSave, Quit : Boolean;
  SBLRec : SBLRecord;

begin
  ClosingForm := True;

    {Now, if the parcel changed, then update the parcel and residential
     site table.}

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

        OpenTableForProcessingType(MainTable, ResidentialSiteTableName,
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

  For I := 0 to (ComponentCount - 1) do
    If (Components[I] is TTable)
      then TTable(Components[I]).Close;

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