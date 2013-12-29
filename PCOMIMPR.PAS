unit Pcomimpr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons;

type
  TParcelCommercialImprovementsForm = class(TForm)
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    EditPanel: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label6: TLabel;
    Label20: TLabel;
    StructureCodeLookup: TwwDBLookupCombo;
    GradeCodeLookup: TwwDBLookupCombo;
    ConditionCodeLookup: TwwDBLookupCombo;
    EditYearBuilt: TDBEdit;
    EditRCNLD: TDBEdit;
    EditRCN: TDBEdit;
    EditFunctionalObsolescence: TDBEdit;
    EditPercentGood: TDBEdit;
    CancelButton: TBitBtn;
    OKButton: TBitBtn;
    MeasureGroupBox: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label19: TLabel;
    MeasurementCodeLookup: TwwDBLookupCombo;
    EditDimension1: TDBEdit;
    EditDimension2: TDBEdit;
    EditQuantity: TDBEdit;
    EditImprovementNum: TDBEdit;
    CodeTable: TwwTable;
    CommercialSiteTable: TTable;
    CommercialSiteDataSource: TDataSource;
    GradeDesc: TLabel;
    ConditionDesc: TLabel;
    InactiveLabel: TLabel;
    OppositeYearComImprovementTable: TTable;
    Label41: TLabel;
    Label44: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    Label7: TLabel;
    Label21: TLabel;
    SaleNumberLabel: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label33: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    EditSite: TDBEdit;
    EditSalesNumber: TEdit;
    EditName: TDBEdit;
    EditLastChangeDate: TDBEdit;
    EditLastChangeByName: TDBEdit;
    EditNumResSites: TEdit;
    EditNumComSites: TEdit;
    Panel5: TPanel;
    Grid: TwwDBGrid;
    Panel4: TPanel;
    CloseButton: TBitBtn;
    NewImprovementButton: TBitBtn;
    DeleteImprovementButton: TBitBtn;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterEdit(DataSet: TDataset);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure MainTableAfterDelete(DataSet: TDataset);
    procedure CodeLookupEnter(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure EditYearBuiltExit(Sender: TObject);
    procedure EditPanelEnter(Sender: TObject);
    procedure MainDataSourceDataChange(Sender: TObject; Field: TField);
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure MeasurementCodeLookupExit(Sender: TObject);
    procedure MainTableBeforeDelete(DataSet: TDataset);
    procedure SetCodeOnLookupCloseup(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure MainTableNewRecord(DataSet: TDataSet);
    procedure NewImprovementButtonClick(Sender: TObject);
    procedure DeleteImprovementButtonClick(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr, SwisSBLKey, OppositeTaxYear : String;
    SalesNumber : Integer;  {What sales number are we on - only for use if Processing Type = SalesInv.}
    Site : Integer; {What site are we on?}
    ProcessingType : Integer;  {NextYear, ThisYear, History, SalesInventory}
    NumResSites,
    NumComSites : Integer;  {Number of commercial and residential sites for this
                             parcel.}

    FieldTraceInformationList : TList;
    StructureLookupTable,     {Table to find structure restrictions.}
    LookupTable : TTable;  {Temp table for finding next imp number.}

    MeasurementRestrictionsCodes : Charset; {Are there any measure code restrictions for this structure code?
                                             We will store any restrictions in character set form,
                                             i.e. ['1', '3'].}

    FormIsInitializing : Boolean;  {Are we initializing the form?}
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
    OppositeYearParcelChanged : Boolean;
    DeletedSiteNum,
    DeletedImprovementNum : Integer;

    Procedure InitializeForm;
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

  Structure = 10;
  Measurement = 20;
  Grade = 30;
  Condition = 40;

    {Now we will put the lookups that are description based in a set for later
     reference.}

  DescriptionIndexedLookups : set of 0..250 = [Structure, Measurement];

{=====================================================================}
Procedure TParcelCommercialImprovementsForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TParcelCommercialImprovementsForm.FormActivate(Sender: TObject);

begin
  Refresh;
end;

{========================================================================}
Procedure TParcelCommercialImprovementsForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{For residential improvements the key is Taxyear\SwisSBL\Site\YearBuilt.}

begin
  try
    If (ProcessingType = SalesInventory)
      then SetRangeOld(Table,
                       ['SwisSBLKey', 'SalesNumber', 'Site',
                        'ImprovementNumber'],
                       [SwisSBLKey, IntToStr(SalesNumber), IntToStr(Site), '0'],
                       [SwisSBLKey, IntToStr(SalesNumber), IntToStr(Site), '32000'])
      else SetRangeOld(Table,
                       ['TaxRollYr', 'SwisSBLKey', 'Site',
                        'ImprovementNumber'],
                       [TaxRollYr, SwisSBLKey, IntToStr(Site), '0'],
                       [TaxRollYr, SwisSBLKey, IntToStr(Site), '32000']);
  except
    SystemSupport(001, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TParcelCommercialImprovementsForm.InitializeForm;

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

begin
  UnitName := 'PCOMIMPR.PAS';  {mmm1}
  ParcelChanged := False;
  ClosingForm := False;
  FormIsInitializing := True;

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
           set the table name and open them implicitly (except the
           trace table. OpenTablesForForm is a method in PASUTILS}

        OpenTablesForForm(Self, ProcessingType);

          {If this is sales inventory, then let's set the index to include the
           sales number. Otherwise, let's do the index without the sales number.}

        If (ProcessingType = SalesInventory)
          then MainTable.IndexName := InventorySwisSBL_SalesNumberKey
          else MainTable.IndexName := InventoryYear_SwisSBLKey;

          {First let's find this parcel in the parcel table.}

        Found := _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Set the range.}

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

          {FXX09102004-1(2.8.0.11): Make sure to get the site table so that the last change information is correct.}

        FindKeyOld(CommercialSiteTable,
                   ['TaxRollYr', 'SwisSBLKey', 'Site'],
                   [TaxRollYr, SwisSBLKey, IntToStr(Site)]);

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

          {FXX12151997-1: Make sure that the tital does not overlap the
                          assessed values.}

        TitleLabel.Caption := 'Comm Improvement';

(*        case EditMode of   {mmm5}
          'A' : TitleLabel.Caption := 'Commercial Improvements Add';
          'M' : TitleLabel.Caption := 'Commercial Improvements Modify';
          'V' : TitleLabel.Caption := 'Commercial Improvements View';

        end;  {case EditMode of} *)

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Now, for some reason the table is marked as
           Modified after we do a set range in modify mode.
           So, we will cancel the modify and set it in
           the proper mode.}

        If ((not MainTable.ReadOnly) and
            (EditMode = 'M'))
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

        case EditMode of
          'V' : begin
                  NewImprovementButton.Enabled := False;
                  DeleteImprovementButton.Enabled := False;

                end;  {Inquire}

        end;  {case EditMode of}

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);

          {Now set the year label.}

        SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);

          {Set the SBL in the SBL edit so that it is visible.
           Note that it is not data aware since if there are
           no records, we have nothing to get the SBL from.}

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

          {We will fill in the site manually rather than based on the improvement table because
           if we did it base on the improvement table, they would not be able to see the site
           until they inserted the first record.}

        EditSite.Text := IntToStr(Site);
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

          {CHG10281997-1: Continue the dual mode processing work.}

        If (ProcessingType = ThisYear)
          then OppositeProcessingType := NextYear
          else OppositeProcessingType := ThisYear;

        OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

        OpenTableForProcessingType(OppositeYearComImprovementTable,
                                   CommercialImprovementsTableName,
                                   OppositeProcessingType, Quit);

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  FormIsInitializing := False;

end;  {InitializeForm}

{===========================================================}
Procedure TParcelCommercialImprovementsForm.EditEnter(Sender: TObject);

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
Procedure TParcelCommercialImprovementsForm.EditExit(Sender: TObject);

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
Function TParcelCommercialImprovementsForm.DetermineCodeTableName(Tag : Integer) : String;

begin
  case Tag of
    Structure : Result := 'ZInvStructureTbl';
    Measurement : Result := 'ZInvMeasurementTbl';
    Grade : Result := 'ZInvGradeTbl';
    Condition : Result := 'ZInvConditionTbl';

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{========================================================================}
Procedure TParcelCommercialImprovementsForm.SetCodeTableName(Tag : Integer);

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

{==============================================================}
Procedure TParcelCommercialImprovementsForm.CodeLookupEnter(Sender: TObject);


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

{=====================================================================================}
Procedure TParcelCommercialImprovementsForm.SetCodeOnLookupCloseup(Sender: TObject;
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
  DefaultValue : Comp;
  FocusSet : Boolean;

begin
  DefaultValue := 0;

  If ((MainTable.State in [dsInsert, dsEdit]) and
      MainTable.Modified)
    then
      begin
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

          {If they were in the measurement code lookup, we will check to see if this
           is a valid measurement code for this structure type. If it is, then we may
           need to set some of the fields r/o or unset them. The code to do this is
           in the EditPanel OnEnter event.}

        If (TComponent(Sender).Name = 'MeasurementCodeLookup')
          then
            begin
              MeasurementCodeLookupExit(Sender);
              EditPanelEnter(Sender);

                {FXX03031998-10: If the person hit enter on the measurement
                                 code, it went to the OK button.}

              If (Screen.ActiveForm.ActiveControl.Name = 'CancelButton')
                then
                  begin
                    FocusSet := False;

                    with EditDimension1 do
                      If not ReadOnly
                        then
                          begin
                            SetFocus;
                            SelectAll;
                            FocusSet := True;

                          end;  {If not ReadOnly}

                    If not FocusSet
                      then
                        with EditDimension2 do
                          If not ReadOnly
                            then
                              begin
                                SetFocus;
                                SelectAll;
                                FocusSet := True;

                              end;  {If not ReadOnly}

                    If not FocusSet
                      then
                        with EditQuantity do
                          If not ReadOnly
                            then
                              begin
                                SetFocus;
                                SelectAll;

                              end;  {If not ReadOnly}

                  end;  {If (Screen.ActiveForm.ActiveControl.Name = 'CancelButton')}

            end;  {If (TComponent(Sender).Name = 'MeasurementCodeLookup')}

          {If this is the structure code lookup, then we want to set any measurement
           code restrictions, if they apply.}

        If (TComponent(Sender).Name = 'StructureCodeLookup')
          then
            with Sender as TwwDBLookupCombo do
              begin
                MeasurementRestrictionsCodes := [];

                If (Deblank(MainTable.FieldByName('StructureDesc').Text) <> '')
                  then
                    begin
                      If TBooleanField(LookupTable.FieldByName('CanUseMC1')).AsBoolean
                        then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['1'];

                      If TBooleanField(LookupTable.FieldByName('CanUseMC2')).AsBoolean
                        then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['2'];

                      If TBooleanField(LookupTable.FieldByName('CanUseMC3')).AsBoolean
                        then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['3'];

                      If TBooleanField(LookupTable.FieldByName('CanUseMC4')).AsBoolean
                        then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['4'];

                        {Now, if the measurement code is not in the current restrictions
                         because of a change, blank out the measurement code and
                         the measure edits.}

                        {FXX11131997-3: Users may need to put in qty no matter
                                        what the dimension code is.}

                      If not (Take(1, MainTable.FieldByName('MeasureCode').Text)[1] in MeasurementRestrictionsCodes)
                        then
                          begin
                            MainTable.FieldByName('MeasureCode').Text := '';
                            MainTable.FieldByName('MeasureDesc').Text := '';

                            MakeEditReadOnly(EditDimension1, MainTable, True, DefaultValue);
                            MakeEditReadOnly(EditDimension2, MainTable, True, DefaultValue);

                          end;  {If not (MainTable.FieldByName('MeasureCode').Text[1] ...}

                    end;  {If (Deblank(LookupTable.FieldByName('MeasurementRestrictionCode').Text) ...}

              end;  {with Sender as TwwDBLookupCombo do}

      end;  {If ((MainTable.State in [dsInsert, dsEdit]) and ...}

end;  {SetCodeOnLookupCloseup}

{==========================================================================}
Procedure TParcelCommercialImprovementsForm.MainDataSourceDataChange(Sender: TObject;
                                                                     Field: TField);

begin
     {For some reason the lookup boxes were not being filled in with the
      value in the underlying MainTable field when the form was initialized,
      so this fills in the fields so that the data is visible. Note that this
      does not cause the table to be marked modified. This also occurs during
      scrolling, so we will fill the fields in by hand.}

  If ((not FormIsInitializing) and
      (Field = nil))
    then RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

end;  {MainDataSourceDataChange}

{==============================================================}
Procedure TParcelCommercialImprovementsForm.MainTableNewRecord(DataSet: TDataSet);

{FXX11142003-1: Make sure that all float and integer fields are initialized to 0.}

begin
  InitializeFieldsForRecord(DataSet);
end;

{==============================================================}
Procedure TParcelCommercialImprovementsForm.MainTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in the Self var.

 Also, if they are in insert state, then we will initialize the values
 TaxRollYr, SwisSBLKey, and Site. Also, we will set the new improvement
 number.}

var
  Quit, FoundRec : Boolean;

begin
  If not FormIsInitializing
    then
      begin
        CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

        EditPanel.Show;
        EditPanel.SetFocus;

          {FXX03031998-9: Set focus on the year built.}

        EditYearBuilt.SetFocus;
        EditYearBuilt.SelectAll;

          {CHG10281997-1: Dual mode processing.}

        If (MainTable.State = dsInsert)
          then RecordAction := raInserted
          else RecordAction := raEdited;

          {Set up the Measurement restrictions code for this rent type, if it is filled
           in already.}

        MeasurementRestrictionsCodes := [];

        If (Deblank(MainTable.FieldByName('StructureDesc').Text) <> '')
          then
            begin
                {If the used as table is not initialized, do so.}

              If (StructureLookupTable = nil)
                then
                  begin
                    StructureLookupTable := TTable.Create(Self);
                    StructureLookupTable.DatabaseName := 'PASsystem';
                    StructureLookupTable.TableType := ttdBase;
                    StructureLookupTable.TableName := DetermineCodeTableName(StructureCodeLookup.Tag);
                    StructureLookupTable.Open;
                    StructureLookupTable.IndexName := 'BYMAINCODE';

                  end;  {If (StructureLookupTable = nil)}

              try
                FoundRec := FindKeyOld(StructureLookupTable, ['MainCode'],
                                       [StructureLookupTable.FieldByName('MainCode').Text]);
              except
                FoundRec := False;
                SystemSupport(010, StructureLookupTable, 'Error finding used as code.',
                              UnitName, GlblErrorDlgBox);
              end;

              If not FoundRec
                then SystemSupport(011, StructureLookupTable, 'Error finding used as code.',
                                   UnitName, GlblErrorDlgBox);

              If TBooleanField(StructureLookupTable.FieldByName('CanUseMC1')).AsBoolean
                then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['1'];

              If TBooleanField(StructureLookupTable.FieldByName('CanUseMC2')).AsBoolean
                then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['2'];

              If TBooleanField(StructureLookupTable.FieldByName('CanUseMC3')).AsBoolean
                then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['3'];

              If TBooleanField(StructureLookupTable.FieldByName('CanUseMC4')).AsBoolean
                then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['4'];

            end;  {If (Deblank(LookupTable.FieldByName('MeasurementRestrictionCode').Text) ...}

        If (MainTable.State = dsInsert)
          then
            begin
                {Set the tax roll year and SBL Key.}

              MainTable.FieldByName('TaxRollYr').Text  := Take(4, TaxRollYr);
              MainTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
              MainTable.FieldByName('Site').AsInteger := Site;

                {Now figure out the next improvement number by looking at the
                 last improvement in the range.}

              If (GetRecordCount(MainTable) = 0)
                then MainTable.FieldByName('ImprovementNumber').AsInteger := 1
                else
                  begin
                      {If the lookup table has not yet been created,
                       then create and open it.}

                    If (LookupTable = nil)
                      then
                        begin
                          LookupTable := TTable.Create(Self);
                          OpenTableForProcessingType(LookupTable, CommercialImprovementsTableName,
                                                     ProcessingType, Quit);
                          LookupTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
                          SetRangeForTable(LookupTable);

                        end;  {If (LookupTable = nil)}

                      {There are improvement records for this parcel, so let's
                       get the last one and look at the improvement number.}

                    try
                      LookupTable.Last;
                    except
                      SystemSupport(010, LookupTable, 'Error getting last in commercial improvement table.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                    MainTable.FieldByName('ImprovementNumber').AsInteger :=
                       LookupTable.FieldByName('ImprovementNumber').AsInteger + 1;

                  end;  {else of If (MainTable.RecordCount = 0)}

            end;  {If (MainTable.State = dsInsert)}

      end;  {If not FormInitializing}

end;  {MainTableAfterEdit}

{==================================================================}
Procedure TParcelCommercialImprovementsForm.EditPanelEnter(Sender: TObject);

{When they come into the panel enter, if the measure code is not
 filled in, then blank out the measure fields. If it is, based on
 the measure code we will allow or not allow access to certain
 fields. Note that this is also called from the OnCloseUp of the
 Measure Code lookup box.

 The rules are, for measure code:
   1: Only Quantity is used.
   2: Dimension1 & 2 used
   3, 4: Dimension 1 only}

var
  I, MeasCode : Integer;
  DefaultValue : Comp;

begin
    {For some reason the lookup boxes were not being filled in with the
     value in the underlying MainTable field when the form was initialized,
     so this fills in the fields so that the data is visible. Note that this
     does not cause the table to be marked modified.}

  For I := 1 to (ComponentCount - 1) do
    If (Components[I] is TwwDBLookupCombo)
      then
        with Components[I] as TwwDBLookupCombo do
          Text := MainTable.FieldByName(DataField).Text;

  DefaultValue := 0;

  If (Deblank(MainTable.FieldByName('MeasureDesc').Text) = '')
    then
      begin
         {There is no measure code set yet, so we will
          loop through the edit boxes in the group box and set them
          to read only. Also, we will make the background BtnFace and
          the font blue as per our standards for Read Only fields.
          Also, if the data value is other than 0, we will set it
          to 0 since all fields should be 0 if there is no measure code.}

        For I := 0 to (MeasureGroupBox.ControlCount - 1) do
          If (MeasureGroupBox.Controls[I] is TDBEdit)
            then MakeEditReadOnly(TDBEdit(MeasureGroupBox.Controls[I]),
                                  MainTable, True, DefaultValue);

      end
    else
      begin
        MeasCode := MainTable.FieldByName('MeasureCode').AsInteger;

        {FXX11131997-3: Users may need to put in qty no matter
                        what the dimension code is.}

        If EditQuantity.ReadOnly
          then MakeEditNotReadOnly(EditQuantity);

        case MeasCode of
          1: begin  {Quantity measure}
               MakeEditReadOnly(EditDimension1, MainTable, True, DefaultValue);
               MakeEditReadOnly(EditDimension2, MainTable, True, DefaultValue);

             end;   {Quantity measure}

          2: begin  {Dimesions 1}
               MakeEditNotReadOnly(EditDimension1);
               MakeEditNotReadOnly(EditDimension2);

             end;   {Dimesions 1}

          3,
          4: begin  {Sq. Feet, Dollars}
               MakeEditNotReadOnly(EditDimension1);
               MakeEditReadOnly(EditDimension2, MainTable, True, DefaultValue);

             end;   {Sq. Feet, Dollars}

        end;  {case MeasCode of}

      end;  {else of If (Deblank(MainTable.FieldByName('MeasureDesc').Text) = '')}

end;  {EditPanelEnter}

{==============================================================}
Procedure TParcelCommercialImprovementsForm.MeasurementCodeLookupExit(Sender: TObject);

{Make sure that they don't use the wrong measurement type for this structure code.}

begin
  If (Screen.ActiveControl.Name <> 'CancelButton')
    then
      If (MeasurementRestrictionsCodes <> [])
        then
          If not (MainTable.FieldByName('MeasureCode').Text[1] in MeasurementRestrictionsCodes)
            then
              begin
                MessageDlg('Structure code ' + MainTable.FieldByName('StructureCode').Text +
                           ' can only have measurement code(s) ' +
                           ListMembersFormatted(MeasurementRestrictionsCodes) + '.',
                           mtError, [mbOK], 0);
                MeasurementCodeLookup.SetFocus;
              end;

end;  {MeasurementCodeLookupExit}

  {Validity checking procedures.}

{==============================================================}
Procedure TParcelCommercialImprovementsForm.EditYearBuiltExit(Sender: TObject);

begin
  If not YearEntryIsValid(MainTable.FieldByName('YearBuilt').Text)
    then
      begin
        MessageDlg('Please enter a valid YYYY year. (i.e. 1996)',
                   mtError, [mbOK], 0);
        TEdit(Sender).SetFocus;
      end;

end;  {EditYearBuiltExit}

{==============================================================}
Procedure TParcelCommercialImprovementsForm.MainTableBeforeDelete(DataSet: TDataset);

{CHG10281997-1: Dual mode processing.}
{Record the site that is about to be deleted so that we can delete in the
 opposite year too.}

begin
  DeletedSiteNum := MainTable.FieldByName('Site').AsInteger;
  DeletedImprovementNum := MainTable.FieldByName('ImprovementNumber').AsInteger;

end;  {MainTableBeforeDelete}

{==============================================================}
Procedure TParcelCommercialImprovementsForm.MainTableAfterDelete(DataSet: TDataset);

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
        Found := FindKeyOld(OppositeYearComImprovementTable,
                            ['TaxRollYr', 'SwisSBLKey', 'Site',
                             'ImprovementNumber'],
                            [OppositeTaxYear,
                             ExtractSSKey(ParcelTable),
                             IntToStr(DeletedSiteNum),
                             IntToStr(DeletedImprovementNum)]);

        If Found
          then OppositeYearComImprovementTable.Delete;

      end;  {If GlblModifyBothYears}

end;  {MainTableAfterDelete}

{==============================================================}
Procedure TParcelCommercialImprovementsForm.GridDblClick(Sender: TObject);

begin
    {FXX10251997-2: By calling the panel without putting it in edit mode,
                    if drop down, get flicker as after edit is preformed and
                    thus DataSetDataChange and RefreshLabels which closes
                    the box making person have to drop down again.
                    Solution is to put table in edit mode and not
                    worry about showing the panel here.}

    {FXX10281997-2: Only put the table in edit mode if the table is not read only.
                    Otherwise, just show the panel.}

  If MainTable.ReadOnly
    then
      begin
        EditPanel.Show;
        EditPanel.SetFocus;
      end
    else MainTable.Edit;

end;  {GridDblClick}

{==============================================================}
Procedure TParcelCommercialImprovementsForm.CancelButtonClick(Sender: TObject);

{If they click the cancel button we will cancel the edits and hide the panel.}

begin
  MainTable.Cancel;
  EditPanel.Visible := False;
end;

{==============================================================}
Procedure TParcelCommercialImprovementsForm.OKButtonClick(Sender: TObject);

{If they click the OK button we will post the record and hide the panel.
 Note that this is a shared event handler with the EditPanel OnExit.}

begin
  If ((MainTable.State in [dsInsert, dsEdit]) and
      MainTable.Modified)
    then MainTable.Post;

  If EditPanel.Visible
    then EditPanel.Visible := False;

end;  {OKButtonClick}

{==============================================================}
Procedure TParcelCommercialImprovementsForm.MainTableBeforePost(DataSet: TDataset);

{Verify that they want to post.}

var
  ReturnCode : Integer;

begin
    {FXX05151998-3: Don't ask save on close form if don't want to see save.}

  If ((not FormIsInitializing) and
      GlblAskSave)
    then
      begin
          {FXX11061997-2: Remove the "save before exiting" prompt because it
                          is confusing. Use only "Do you want to save.}

        ReturnCode := MessageDlg('Do you wish to save your commercial improvement changes?',
                                 mtConfirmation,
                                 [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idNo : If (MainTable.State = dsInsert)
                   then MainTable.Cancel
                   else RefreshNoPost(MainTable);

          idCancel : Abort;

        end;  {case ReturnCode of}

      end;  {If ((not FormIsInitializing) and ...}

end;  {MainTableBeforePost}

{==============================================================}
Procedure TParcelCommercialImprovementsForm.MainTableAfterPost(DataSet: TDataset);

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
                         OppositeYearComImprovementTable.Insert;
                         Found := True;

                       end;  {raInserted}

          raEdited : begin
                       Found := FindKeyOld(OppositeYearComImprovementTable,
                                           ['TaxRollYr', 'SwisSBLKey',
                                            'Site', 'ImprovementNumber'],
                                           [OppositeTaxYear,
                                            ExtractSSKey(ParcelTable),
                                            IntToStr(MainTable.FieldByName('Site').AsInteger),
                                            IntToStr(MainTable.FieldByName('ImprovementNumber').AsInteger)]);

                       If Found
                         then OppositeYearComImprovementTable.Edit;

                     end;  {raEdited}

        end;  {case RecordAction of}

        CreateFieldValuesAndLabels(Self, OppositeYearComImprovementTable,
                                   FieldTraceInformationList);

          {Copy the fields from the main table to the new table, but make
           sure that we do not copy the tax roll year.}

        If Found
          then
            begin
              CopyFields(MainTable, OppositeYearComImprovementTable,
                         ['TaxRollYr'], [OppositeTaxYear]);

              try
                OppositeYearComImprovementTable.Post;
              except
                SystemSupport(050, OppositeYearComImprovementTable,
                              'Error posting opposite year record.', UnitName,
                              GlblErrorDlgBox);
              end;

              If (RecordChanges(Self, Caption,
                                OppositeYearComImprovementTable, SwisSBLKey,
                                FieldTraceInformationList) > 0)
                then OppositeYearParcelChanged := True;

            end;  {If Found}

      end;  {If GlblModifyBothYears}

    {FXX10152004-2(2.8.0.14): Move the call to MarkRecChanged to after post so that it updates right away.}
    {Now, if the parcel changed, then update the parcel and commercial site table.}

  If (ParcelChanged and
      (ProcessingType <> SalesInventory))
    then
      begin
        MarkRecChanged(ParcelTable, UnitName);
        MarkRecChanged(CommercialSiteTable, UnitName);
      end;

end;  {MainTableAfterPost}

{==============================================================}
Procedure TParcelCommercialImprovementsForm.NewImprovementButtonClick(Sender: TObject);

begin
  try
    MainTable.Insert;
  except
  end;

end;  {NewImprovementButtonClick}

{================================================================}
Procedure TParcelCommercialImprovementsForm.DeleteImprovementButtonClick(Sender: TObject);

begin
  try
    MainTable.Delete;
  except
  end;

end;  {DeleteImprovementButtonClick}

{==============================================================}
Procedure TParcelCommercialImprovementsForm.CloseButtonClick(Sender: TObject);

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
Procedure TParcelCommercialImprovementsForm.FormCloseQuery(    Sender: TObject;
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
Procedure TParcelCommercialImprovementsForm.FormClose(    Sender: TObject;
                                                      var Action: TCloseAction);

var
  Quit : Boolean;

begin
    {Now, if the parcel changed, then update the parcel and commercial site table.}

  If (ParcelChanged and
      (ProcessingType <> SalesInventory))
    then
      begin
        MarkRecChanged(ParcelTable, UnitName);
        MarkRecChanged(CommercialSiteTable, UnitName);
      end;

   {CHG10281997-1: Continue the dual mode processing work.}

  If OppositeYearParcelChanged
    then
      begin
          {Close the parcel and site table and reopen them for the
           opposite year.}

        ParcelTable.Close;
        CommercialSiteTable.Close;

        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   OppositeProcessingType, Quit);

        _Locate(ParcelTable, [OppositeTaxYear, SwisSBLKey], '', [loParseSwisSBLKey]);

        OpenTableForProcessingType(CommercialSiteTable, CommercialSiteTableName,
                                   OppositeProcessingType, Quit);

           {FXX11211997-9: Do the same for inv. sites.}

        FindKeyOld(CommercialSiteTable,
                   ['TaxRollYr', 'SwisSBLKey', 'Site'],
                   [OppositeTaxYear, SwisSBLKey, IntToStr(Site)]);

        MarkRecChanged(ParcelTable, UnitName);
        MarkRecChanged(CommercialSiteTable, UnitName);

      end;  {If OppositeYearParcelChanged}

    {Close all tables here.}

  CloseTablesForForm(Self);

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
