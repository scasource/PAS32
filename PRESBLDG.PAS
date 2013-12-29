unit Presbldg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons;

type
  TParcelResidentialBldgForm = class(TForm)
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
    EditNumStories: TDBEdit;
    EditNumRooms: TDBEdit;
    Edit1stStoryArea: TDBEdit;
    EditYearBuilt: TDBEdit;
    EditNumKitchens: TDBEdit;
    EditNumBaths: TDBEdit;
    EditUnfinished1_2StoryArea: TDBEdit;
    EditFunctionalObsolescence: TDBEdit;
    EditFinishedOverGarageArea: TDBEdit;
    EditBasementGarageCapacity: TDBEdit;
    EditUnfinished3_4StoryArea: TDBEdit;
    EditFinishedAtticArea: TDBEdit;
    EditFinishedBasementArea: TDBEdit;
    EditPorchArea: TDBEdit;
    EditAttachedGarageCapacity: TDBEdit;
    EditPercentGood: TDBEdit;
    LookupHeat: TwwDBLookupCombo;
    LookupFuel: TwwDBLookupCombo;
    LookupBasementType: TwwDBLookupCombo;
    LookupConditon: TwwDBLookupCombo;
    LookupGrade: TwwDBLookupCombo;
    LookupPorchType: TwwDBLookupCombo;
    LookupBuildingStyle: TwwDBLookupCombo;
    LookupExtWall: TwwDBLookupCombo;
    LookupKitchenQuality: TwwDBLookupCombo;
    LookupBathQuality: TwwDBLookupCombo;
    CheckBoxCentralAir: TDBCheckBox;
    EditFinishedRecRoomArea: TDBEdit;
    EditUnfinishedRoomArea: TDBEdit;
    Edit2ndStoryArea: TDBEdit;
    Edit3rdStoryArea: TDBEdit;
    Edit1_2StoryArea: TDBEdit;
    Edit3_4StoryArea: TDBEdit;
    EditTotalLivingArea: TDBEdit;
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
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    lbUnfinishedRoom: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    CodeTable: TwwTable;
    Label42: TLabel;
    Label43: TLabel;
    EditNumberBedrooms: TDBEdit;
    EditNumberFireplaces: TDBEdit;
    EditRCN: TDBEdit;
    EditRCNLD: TDBEdit;
    RCNLabel: TLabel;
    RCNLDLabel: TLabel;
    EditGradeAdjustment: TDBEdit;
    Label47: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditSBL: TMaskEdit;
    Label7: TLabel;
    EditLocation: TEdit;
    Label5: TLabel;
    EditSite: TDBEdit;
    SaleNumberLabel: TLabel;
    EditSalesNumber: TEdit;
    Label6: TLabel;
    EditName: TDBEdit;
    Label41: TLabel;
    EditLastChangeDate: TDBEdit;
    Label48: TLabel;
    EditLastChangeByName: TDBEdit;
    Label49: TLabel;
    EditNumResSites: TEdit;
    Label50: TLabel;
    EditNumComSites: TEdit;
    ResidentialSiteTable: TTable;
    ResidentialSiteDataSource: TDataSource;
    ConditionDesc: TLabel;
    OverallGradeDesc: TLabel;
    InactiveLabel: TLabel;
    OppositeYearResBldgTable: TTable;
    ClearButton: TBitBtn;
    Label53: TLabel;
    Label54: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    SetFocusTimer: TTimer;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    EditRemodelYear: TDBEdit;
    Label55: TLabel;
    EditNumberHalfBathrooms: TDBEdit;
    Label56: TLabel;
    Label57: TLabel;
    EditDetachedGarage: TDBEdit;
    Label58: TLabel;
    Label59: TLabel;
    EditNumHalfKitchens: TDBEdit;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterEdit(DataSet: TDataset);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure MainTableAfterDelete(DataSet: TDataset);
    procedure CodeLookupEnter(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OnLivingAreaExit(Sender: TObject);
    procedure EditYearBuiltExit(Sender: TObject);
    procedure MainTableBeforeDelete(DataSet: TDataset);
    procedure ClearButtonClick(Sender: TObject);
    procedure MainDataSourceDataChange(Sender: TObject; Field: TField);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure SetCodeOnLookupCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure LookupPorchTypeNotInList(Sender: TObject;
      LookupTable: TDataSet; NewValue: String; var Accept: Boolean);
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

    FieldTraceInformationList : TList;
    InitializingForm,
    ClosingForm : Boolean;  {Are we closing a form right now?}

      {Have there been any changes?}

    ParcelChanged : Boolean;

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
      {because these routines are placed at the form object def. level,}
      {they have access to all variables on form (no need to Var in)   }

      {CHG10281997-1: Dual mode processing.}

    RecordAction,
    OppositeProcessingType : Integer;
    OppositeTaxYear : String;
    OppositeYearParcelChanged : Boolean;
    DeletedSiteNum : Integer;  {There is only one bldg per site.}

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
     GlblCnst;

const
    {This is a unique number for each lookup box stored in that
     lookup's tag field. This is because we have only one code table and
     as they enter each lookup, we change the name of the code table to be
     the table for this lookup. To use this, set the tag field of each
     lookup combo box to a unique number and list it below.}

    {To use the hints, create unique numerical tags for each lookup combo box
     and list them below (hhh1). Then go to the DetermineCodeTableName procedure
     (hhh2) and change the table name assignments. Then set the OnEnter event
     for all LookupCombo boxes to CodeLookupEnter, the OnMouseMove event for all
     LookupCombo boxes to CodeLookupMouseMove, and the OnCloseUp for all
     LookupCombo boxes to SetHintOnLookupCloseUp.}

  BuildingStyle = 10;  {LLL1}
  ExteriorWall = 20;
  KitchenQuality = 30;
  BathroomQuality = 40;
  HeatType = 50;
  FuelType = 60;
  BasementType = 70;
  Condition = 80;
  Grade = 90;
  PorchType = 100;

    {Now we will put the lookups that are description based in a set for later
     reference.}

  DescriptionIndexedLookups : set of 0..250 =
         [BuildingStyle, ExteriorWall, KitchenQuality, BathroomQuality, HeatType,
          FuelType, BasementType, PorchType];  {LLL2}

{$R *.DFM}

{=====================================================================}
Procedure TParcelResidentialBldgForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TParcelResidentialBldgForm.SetRangeForTable(Table : TTable);

          {Now set the range on this table
           so that it is sychronized to this parcel. Note
           that all segments of the key must be set.}
           {mmm4 - Make sure to set range on all keys.}

begin
  try
    If (ProcessingType = SalesInventory)
      then SetRangeOld(Table,
                       ['SwisSBLKey', 'SalesNumber', 'Site'],
                       [SwisSBLKey, IntToStr(SalesNumber), IntToStr(Site)],
                       [SwisSBLKey, IntToStr(SalesNumber), IntToStr(Site)])
      else SetRangeOld(Table,
                       ['TaxRollYr', 'SwisSBLKey', 'Site'],
                       [TaxRollYr, SwisSBLKey, IntToStr(Site)],
                       [TaxRollYr, SwisSBLKey, IntToStr(Site)]);
  except
    SystemSupport(001, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TParcelResidentialBldgForm.InitializeForm;

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
  UnitName := 'PRESBLDG';  {mmm1}
  ParcelChanged := False;
  ClosingForm := False;
  InitializingForm := True;

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
                               'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                              [TaxRollYr, SwisCode, Section,
                               SubSection, Block, Lot, Sublot, Suffix]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Set the range.}

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

          {Set the range for the residential site table.}

        SetRangeOld(ResidentialSiteTable,
                    ['TaxRollYr', 'SwisSBLKey', 'Site'],
                    [TaxRollYr, SwisSBLKey, IntToStr(Site)],
                    [TaxRollYr, SwisSBLKey, IntToStr(Site)]);

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

          {FXX12151997-1: Make sure that the tital does not overlap the
                          assessed values.}

        TitleLabel.Caption := 'Residential Bldg';

(*        case EditMode of   {mmm5}
          'A' : TitleLabel.Caption := 'Residential Building Add';
          'M' : TitleLabel.Caption := 'Residential Building Modify';
          'V' : TitleLabel.Caption := 'Residential Building View';

        end;  {case EditMode of} *)

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Now, for some reason the table is marked as
           Modified after we do a set range in modify mode.
           So, we will cancel the modify and set it in
           the proper mode.}

        If ((not MainTable.ReadOnly) and
            MainTable.Modified and
            (EditMode = 'M'))
          then
            begin
              MainTable.Edit;
              MainTable.Cancel;
            end;

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

          {If this is edit mode, hide the save and cancel button.}

        If MainTable.ReadOnly
          then
            begin
              SaveButton.Visible := False;
              CancelButton.Visible := False;
              ClearButton.Visible := False;
            end;

          {For some reason the lookup boxes were not being filled in with the
           value in the underlying MainTable field when the form was initialized,
           so this fills in the fields so that the data is visible. Note that this
           does not cause the table to be marked modified. Also, we will fill
           in any labels for code based dropdowns. Note that the label names (not captions)
           must be EXACTLY the description field name in the table.}

        RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

          {Set the display for currency fields. Note that for some reason setting
           the currency field is not working in the object inspector, so we will
           force it.}

          {CHG10091997-1: Should zeroes be blanks or '0'?}
        SetDisplayFormatForCurrencyFields(Self, False);

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

        OpenTableForProcessingType(OppositeYearResBldgTable,
                                   ResidentialBldgTableName,
                                   OppositeProcessingType, Quit);

          {FXX03031998-2: Set focus to the first field. Note that we must
                          do this on a timer so that the form is showing
                          by the time we try to set focus.  Otherwise,
                          we get an error trying to set focus in an invisible
                          window.}

        SetFocusTimer.Enabled := True;

          {FXX07081998-1: Format the # of stories and bathrooms.}

        TFloatField(MainTable.FieldByName('NumberOfBathrooms')).DisplayFormat := DecimalDisplay;
        TFloatField(MainTable.FieldByName('NumberOfStories')).DisplayFormat := DecimalDisplay;

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

          {CHG03112002-1: Allow for suppression of inventory values.}

        If not GlblShowInventoryValues
          then
            begin
              RCNLDLabel.Visible := False;
              RCNLabel.Visible := False;
              EditRCNLD.Visible := False;
              EditRCN.Visible := False;

            end;  {If not GlblShowInventoryValues}

        If not GlblRecalculateSFLA
          then
            begin
              EditTotalLivingArea.Enabled := True;
              EditTotalLivingArea.ReadOnly := False;

                {FXX06282002-2: The color was not being set back to white to
                                indicate the ability to edit.}

              EditTotalLivingArea.Color := clWindow;
              EditTotalLivingArea.Refresh;

            end;  {If not GlblRecalculateSFLA}

        If glblUnfinRoomIsUnfinBsmt
        then lbUnfinishedRoom.Caption := 'Unfin Bsmt';

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  InitializingForm := False;

end;  {InitializeForm}

{===========================================================}
Procedure TParcelResidentialBldgForm.SetFocusToFirstField;

{FXX03031998-2: Set focus to the first field after insert, any post,
                and upon coming into the form.}

begin
  with LookupBuildingStyle do
    begin
      SetFocus;
      SelectAll;
    end;

end;  {SetFocusToFirstField}

{===========================================================}
Procedure TParcelResidentialBldgForm.SetFocusTimerTimer(Sender: TObject);

{FXX03031998-2: Set focus to the first field. Note that we must
                do this on a timer so that the form is showing
                by the time we try to set focus.  Otherwise,
                we get an error trying to set focus in an invisible
                window.}

begin
  SetFocusTimer.Enabled := False;
  SetFocusToFirstField;
end;  {SetFocusTimerTimer}

{====================================================================}
Procedure TParcelResidentialBldgForm.MainDataSourceDataChange(Sender: TObject;
                                                              Field: TField);

begin
     {FXX12231997-7: There was no refresh of dropdowns occuring.}

     {For some reason the lookup boxes were not being filled in with the
      value in the underlying MainTable field when the form was initialized,
      so this fills in the fields so that the data is visible. Note that this
      does not cause the table to be marked modified. This also occurs during
      scrolling, so we will fill the fields in by hand.}

  If ((not InitializingForm) and
      (Field = nil))
    then RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

end;  {MainDataSourceDataChange}

{====================================================================}
Function TParcelResidentialBldgForm.DetermineCodeTableName(Tag : Integer) : String;

begin
  case Tag of
    BuildingStyle : Result := 'ZInvBuildStyleTbl';
    ExteriorWall : Result := 'ZInvExteriorWallTbl';
    KitchenQuality : Result := 'ZInvQualityTbl';
    BathroomQuality : Result := 'ZInvQualityTbl';
    HeatType : Result := 'ZInvHeatTbl';
    FuelType : Result := 'ZInvFuelTbl';
    BasementType : Result := 'ZInvResBasementTbl';
    Condition : Result := 'ZInvConditionTbl';
    Grade : Result := 'ZInvGradeTbl';
    PorchType : Result := 'ZInvPorchTypeTbl';

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{========================================================================}
Procedure TParcelResidentialBldgForm.SetCodeTableName(Tag : Integer);

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

{===============================================================}
Procedure TParcelResidentialBldgForm.CodeLookupEnter(Sender: TObject);

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
                CharCase := ecNormal;  {Because description key is case insensitive, don't care about case.}
                Selected.Clear;
                Selected.Add('Description' + #9 + '20' + #9 + 'Description Description');
                Selected.Add('MainCode' + #9 +
                             IntToStr(CodeTable.FieldByName('MainCode').DataSize - 1) +
                             #9 + 'MainCode Code');
              end
            else
              begin
                CharCase := ecUpperCase;  {Because MainCode is not case insensitive, need to force to upper case.}
                Selected.Clear;
                Selected.Add('MainCode' + #9 +
                             IntToStr(CodeTable.FieldByName('MainCode').DataSize - 1) +
                             #9 + 'MainCode Code');
                Selected.Add('Description' + #9 + '20' + #9 + 'Description Description');

              end;  {else of If (Tag in DescriptionIndexedLookups)}

        end;  {If (CodeTable.TableName <> DetermineCode}

    {FXX03031998-8: Refresh the dropdowns when we exit code lookup enter
                    since we were having problems with text disapperaing.}

  RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

end;  {CodeLookupEnter}

{==========================================================================}
Procedure TParcelResidentialBldgForm.SetCodeOnLookupCloseUp(Sender: TObject;
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

    {On the closeup of the building style lookup, we want to recalaculate the SFLA
     just in case they changed the building type.}

  If (TComponent(Sender).Name = 'LookupBuildingStyle')
    then OnLivingAreaExit(Sender);

end;  {SetCodeOnLookupCloseUp}

{==============================================================}
Procedure TParcelResidentialBldgForm.OnLivingAreaExit(Sender: TObject);

{Calculate the total square feet living area whenever they exit a field which is part
 of the calculation. Note that the Finished Rec Room Area is not part of the living area.
 Also, the finished basement area only gets added in if this is building
 style 02 or 03.}

begin
    {FXX03192003-3(2.06q1): Make sure that if they blank out a field, we store it as 0.}

  If ((not ClosingForm) and
      (MainTable.State in [dsInsert, dsEdit]) and
      (Deblank(TDBEdit(Sender).Text) = ''))
    then MainTable.FieldByName(TDBEdit(Sender).DataField).AsInteger := 0;

    {CHG01302002-1: Allow suppression of SFLA recalculation.}

  If ((not ClosingForm) and
      (MainTable.State in [dsInsert, dsEdit]) and
      GlblRecalculateSFLA)
    then MainTable.FieldByName('SqFootLivingArea').AsFloat := CalculateSquareFootLivingArea(MainTable);

end;  {OnLivingAreaExit}

{==============================================================}
Procedure TParcelResidentialBldgForm.MainTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in the Self var.}

begin
  CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

  If (MainTable.State = dsInsert)
    then RecordAction := raInserted
    else RecordAction := raEdited;

end;  {MainTableAfterEdit}

  {Validity checking procedures.}

{==============================================================}
Procedure TParcelResidentialBldgForm.EditYearBuiltExit(Sender: TObject);

begin
    {FXX10201997-5: Field "YearBuilt" changed to "ActualYearBuilt".}

  If not YearEntryIsValid(MainTable.FieldByName('ActualYearBuilt').Text)
    then
      begin
        MessageDlg('Please enter a valid YYYY year. (i.e. 1996)',
                   mtError, [mbOK], 0);
        TEdit(Sender).SetFocus;
      end;

end;  {EditYearBuiltExit}

{==============================================================}
Procedure TParcelResidentialBldgForm.LookupPorchTypeNotInList(    Sender: TObject;
                                                                  LookupTable: TDataSet;
                                                                  NewValue: String;
                                                              var Accept: Boolean);

{FXX03192003-2(2.06q1): Make sure to let them blank out the porch type.}

begin
  Accept := False;

  If (Deblank(NewValue) = '')
    then Accept := True
    else MessageDlg('Sorry, ' + NewValue + ' is not a valid porch type.' + #13 +
                    'Please select again.', mtError, [mbOK], 0);

end;  {LookupPorchTypeNotInList}

{==============================================================}
Procedure TParcelResidentialBldgForm.MainTableBeforeDelete(DataSet: TDataset);

{CHG10281997-1: Dual mode processing.}
{Record the site that is about to be deleted so that we can delete in the
 opposite year too.}

begin
  DeletedSiteNum := MainTable.FieldByName('Site').AsInteger;
end;  {MainTableBeforeDelete}

{==============================================================}
Procedure TParcelResidentialBldgForm.MainTableAfterDelete(DataSet: TDataset);

{After a delete, we should always reset the range.}

var
  Found : Boolean;

begin
  MainTable.DisableControls;
  MainTable.CancelRange;
  SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}
  MainTable.EnableControls;

   {CHG10281997-1: Dual mode processing.}

  If GlblModifyBothYears
    then
      begin
        Found := FindKeyOld(OppositeYearResBldgTable,
                            ['TaxRollYr', 'SwisSBLKey', 'Site'],
                            [OppositeTaxYear,
                             ExtractSSKey(ParcelTable),
                             IntToStr(DeletedSiteNum)]);

        If Found
          then OppositeYearResBldgTable.Delete;

      end;  {If GlblModifyBothYears}

    {FXX03031998-2: Set focus back to the first field after post, delete.}

  SetFocusToFirstField;

end;  {MainTableAfterDelete}

{==============================================================}
Procedure TParcelResidentialBldgForm.MainTableBeforePost(DataSet: TDataset);

{Verify that they want to save.}

var
  ReturnCode : Integer;

begin
    {FXX05151998-3: Don't ask save on close form if don't want to see save.}

  If GlblAskSave
    then
      begin
          {FXX11061997-2: Remove the "save before exiting" prompt because it
                          is confusing. Use only "Do you want to save.}

        ReturnCode := MessageDlg('Do you wish to save your residential building changes?', mtConfirmation,
                                 [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idNo : If (MainTable.State = dsInsert)
                   then MainTable.Cancel
                   else RefreshNoPost(MainTable);

          idCancel : Abort;

        end;  {case ReturnCode of}

      end;  {If GlblAskSave}

end;  {MainTableBeforePost}

{==============================================================}
Procedure TParcelResidentialBldgForm.MainTableAfterPost(DataSet: TDataset);

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

    {FXX11101997-3: Pass the screen name into RecordChanges so
                    the screen names are more readable.}
    {FXX12301999-3: Make sure to always carry changes forward if they want them.}

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
                         OppositeYearResBldgTable.Insert;
                         Found := True;

                       end;  {raInserted}

          raEdited : begin
                       Found := FindKeyOld(OppositeYearResBldgTable,
                                           ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                           [OppositeTaxYear,
                                            ExtractSSKey(ParcelTable),
                                            IntToStr(MainTable.FieldByName('Site').AsInteger)]);

                       If Found
                         then OppositeYearResBldgTable.Edit;

                     end;  {raEdited}

        end;  {case RecordAction of}

        CreateFieldValuesAndLabels(Self, OppositeYearResBldgTable,
                                   FieldTraceInformationList);

          {Copy the fields from the main table to the new table, but make
           sure that we do not copy the tax roll year.}

        If Found
          then
            begin
              CopyFields(MainTable, OppositeYearResBldgTable,
                         ['TaxRollYr'], [OppositeTaxYear]);

              try
                OppositeYearResBldgTable.Post;
              except
                SystemSupport(050, OppositeYearResBldgTable,
                              'Error posting opposite year record.', UnitName,
                              GlblErrorDlgBox);
              end;

              If (RecordChanges(Self, Caption,
                                OppositeYearResBldgTable, SwisSBLKey,
                                FieldTraceInformationList) > 0)
                then OppositeYearParcelChanged := True;

            end;  {If Found}

      end;  {If GlblModifyBothYears}

    {FXX10152004-2(2.8.0.14): Move the call to MarkRecChanged to after post so that it updates right away.}
    {Now, if the parcel changed, then update the parcel and residential
     site table.}

  If (ParcelChanged and
      (ProcessingType <> SalesInventory))
    then MarkRecChanged(ResidentialSiteTable, UnitName);

    {FXX03031998-2: Make sure to put the cursor back at the first control.}

  SetFocusToFirstField;

end;  {MainTableAfterPost}

{==============================================================}
Procedure TParcelResidentialBldgForm.ClearButtonClick(Sender: TObject);

{CHG12041997-1: Allow the user to easily clear a building record (leave
                the record, just clear the inv fields).}

var
  I : Integer;

begin
  If (MessageDlg('Are you sure you want to clear the residential buidling information?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        If not (MainTable.State = dsEdit)
          then MainTable.Edit;

          {Note that we will not blank out thetax year, sbl key, or site
           since we still need to look it up.}

        with MainTable do
          For I := 0 to (FieldCount - 1) do
            If ((Fields[I].FieldName <> 'TaxRollYr') and
                (Fields[I].FieldName <> 'SwisSBLKey') and
                (Fields[I].FieldName <> 'Site'))
              then Fields[I].Text := '';

        MainTable.FieldByName('CentralAir').AsBoolean := False;

        try
          MainTable.Post;
        except
          SystemSupport(030, MainTable, 'Error clearing building record.',
                        UnitName, GlblErrorDlgBox);
        end;

        ConditionDesc.Caption := '';
        OverallGradeDesc.Caption := '';

          {FXX02021998-3: Refresh the dropdowns so that they are clear.}

        RefreshDropdownsAndLabels(Self, MainTable,
                                  DescriptionIndexedLookups);

        SetFocusToFirstField;

      end;  {If (MessageDlg ...}

end;  {ClearButtonClick}

{==============================================================}
Procedure TParcelResidentialBldgForm.SaveButtonClick(Sender: TObject);

begin
    {FXX12301999-1: Make sure that the table is in insert or edit mode before posting.}

  If (MainTable.State in [dsEdit, dsInsert])
    then MainTable.Post;

end;  {SaveButtonClick}

{===================================================================}
Procedure TParcelResidentialBldgForm.CancelButtonClick(Sender: TObject);

begin
  If (MainTable.Modified and
      (MessageDlg('Warning! You will lose all changes.' + #13 +
                  'Cancel anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes))
    then MainTable.Cancel;

end;  {CancelButtonClick}

{========================================================================}
Procedure TParcelResidentialBldgForm.MainTableNewRecord(DataSet: TDataSet);

{FXX02092009-1(2.17.1.1): Make sure to initialize key fields if an insert is necessary.}

begin
  with MainTable do
    begin
      FieldByName('TaxRollYr').AsString := TaxRollYr;
      FieldByName('SwisSBLKey').AsString := SwisSBLKey;
      FieldByName('Site').AsInteger := Site;
    end;  {with MainTable do}

end;  {MainTableNewRecord}

{==============================================================}
Procedure TParcelResidentialBldgForm.CloseButtonClick(Sender: TObject);

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
Procedure TParcelResidentialBldgForm.FormCloseQuery(    Sender: TObject;
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
      (MainTable.State in [dsInsert, dsEdit]) and
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
Procedure TParcelResidentialBldgForm.FormClose(    Sender: TObject;
                                               var Action: TCloseAction);

var
  Quit : Boolean;
  SBLRec : SBLRecord;

begin
    {Now, if the parcel changed, then update the parcel and residential
     site table.}

  If (ParcelChanged and
      (ProcessingType <> SalesInventory))
    then
      begin
        MarkRecChanged(ParcelTable, UnitName);
        MarkRecChanged(ResidentialSiteTable, UnitName);

      end;  {If ParcelChanged}

    {CHG10281997-1: Dual mode processing.}

  If OppositeYearParcelChanged
    then
      begin
          {Close the parcel and site table and reopen them for the
           opposite year.}

        ParcelTable.Close;
        ResidentialSiteTable.Close;

        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   OppositeProcessingType, Quit);

        OpenTableForProcessingType(ResidentialSiteTable, ResidentialSiteTableName,
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

        FindKeyOld(ResidentialSiteTable,
                   ['TaxRollYr', 'SwisSBLKey', 'Site'],
                   [OppositeTaxYear, SwisSBLKey, IntToStr(Site)]);

        MarkRecChanged(ParcelTable, UnitName);
        MarkRecChanged(ResidentialSiteTable, UnitName);

      end;  {If OppositeYearParcelChanged}

    {Close all tables here.}

  CloseTablesForForm(Self);

  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));
  Action := caFree;

end;  {FormClose}

end.
