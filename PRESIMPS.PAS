unit Presimps;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, wwdblook,
  Types;

type
  TResidentialImprovementsSubform = class(TForm)
    Label8: TLabel;
    Label9: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    GradeDesc: TLabel;
    ConditionDesc: TLabel;
    StructureCodeLookup: TwwDBLookupCombo;
    ConditionCodeLookup: TwwDBLookupCombo;
    EditYearBuilt: TDBEdit;
    EditRCNLD: TDBEdit;
    EditRCN: TDBEdit;
    EditFunctionalObsolescence: TDBEdit;
    EditPercentGood: TDBEdit;
    CancelButton: TBitBtn;
    SaveButton: TBitBtn;
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
    GradeCodeLookup: TwwDBLookupCombo;
    StructureLookupTable: TTable;
    OppositeYearResImprovementTable: TTable;
    MainTable: TwwTable;
    MainDataSource: TwwDataSource;
    ImprovementLookupTable: TTable;
    CodeTable: TwwTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure CodeLookupEnter(Sender: TObject);
    procedure EditYearBuiltExit(Sender: TObject);
    procedure MeasurementCodeLookupExit(Sender: TObject);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure MainTableAfterEdit(DataSet: TDataset);
    procedure MainTableAfterInsert(DataSet: TDataset);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SaveButtonClick(Sender: TObject);
    procedure SetCodeOnLookupCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    TaxRollYr : String;
    EditMode : Char;
    Site, SalesNumber, ImprovementNumber : Integer;
    MeasurementRestrictionsCodes : Charset; {Are there any measure code restrictions for this structure code?
                                             We will store any restrictions in character set form,
                                             i.e. ['1', '3'].}
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    ProcessingType : Integer;
    SwisSBLKey : String;
    RecordAction,
    OppositeProcessingType : Integer;
    OppositeTaxYear : String;
    OppositeYearParcelChanged : Boolean;
        {These var.'s are for tracing changes.}

    FieldValuesList,
    FieldLabelsList : TStringList;

    FormIsInitializing : Boolean;  {Are we initializing the form?}
    ClosingForm : Boolean;  {Are we closing a form right now?}
    ParcelChanged : Boolean;

    MainCaption : String;
    FieldTraceInformationList : TList;

    Procedure SetMeasurementEdits;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure SetRangeForTable(Table : TTable);
      {What is the code table name for this lookup?}
    Function DetermineCodeTableName(Tag : Integer) : String;

      {Actually set the code table name.}
    Procedure SetCodeTableName(Tag : Integer);

    Procedure SetMeasurementRestrictions(    StructureLookupTable : TTable;
                                         var MeasurementRestrictionsCodes : Charset);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, PASTypes, DataAccessUnit;

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

{========================================================}
Procedure TResidentialImprovementsSubform.SetMeasurementEdits;

var
  I, MeasCode, DefaultValue : Integer;

begin
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
        {FXX08031999-2: Option to not enforce measurement restrictions.}

      If GlblEnforceMeasurementRestrictions
        then
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
                   MakeEditReadOnly(EditQuantity, MainTable, True, DefaultValue);

                 end;   {Dimesions 1}

              3,
              4: begin  {Sq. Feet, Dollars}
                   MakeEditNotReadOnly(EditDimension1);
                   MakeEditReadOnly(EditDimension2, MainTable, True, DefaultValue);
                   MakeEditReadOnly(EditQuantity, MainTable, True, DefaultValue);

                 end;   {Sq. Feet, Dollars}

            end;  {case MeasCode of}

          end
        else
          begin
              {Don't enforce the restrictions, allow access to all fields.}

            MakeEditNotReadOnly(EditDimension1);
            MakeEditNotReadOnly(EditDimension2);
            MakeEditNotReadOnly(EditQuantity);
          end;  {else of If GlblEnforceMeasurementRestrictions}

end;  {SetMeasurementEdits}

{========================================================}
Procedure TResidentialImprovementsSubform.InitializeForm;

var
  I : Integer;
  Quit : Boolean;

begin
  UnitName := 'PRESIMPS';  {mmm}

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

    {If this is sales inventory, then let's set the index to include the
     sales number. Otherwise, let's do the index without the sales number.}

        If (ProcessingType = SalesInventory)
          then MainTable.IndexName := 'BYSBL_SALENO_SITE_IMPNO'
          else MainTable.IndexName := 'BYTAXROLLYR_SBL_SITE_IMPNO';

    {There are so many tables on this form, we will
     set the table name and open them implicitly.
     OpenTablesForForm is a method in PASUTILS.}

  OpenTablesForForm(Self, ProcessingType);

    {For some reason the lookup boxes were not being filled in with the
     value in the underlying MainTable field when the form was initialized,
     so this fills in the fields so that the data is visible. Note that this
     does not cause the table to be marked modified. Also, we will fill
     in any labels for code based dropdowns. Note that the label names (not captions)
     must be EXACTLY the description field name in the table.}

  RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

    {CHG10091997-1: Should zeroes be blanks or '0'?}
  SetDisplayFormatForCurrencyFields(Self, False);

    {For some reason the lookup boxes were not being filled in with the
     value in the underlying MainTable field when the form was initialized,
     so this fills in the fields so that the data is visible. Note that this
     does not cause the table to be marked modified.}

  For I := 1 to (ComponentCount - 1) do
    If (Components[I] is TwwDBLookupCombo)
      then
        with Components[I] as TwwDBLookupCombo do
          Text := MainTable.FieldByName(DataField).Text;

  SetMeasurementEdits;

    {CHG10281997-1: Continue the dual mode processing work.}

  If (ProcessingType = ThisYear)
    then OppositeProcessingType := NextYear
    else OppositeProcessingType := ThisYear;

  OppositeYearParcelChanged := False;
  OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

  OpenTableForProcessingType(OppositeYearResImprovementTable,
                             ResidentialImprovementsTableName,
                             OppositeProcessingType, Quit);

  If MainTable.ReadOnly
    then
      begin
        CancelButton.Enabled := False;
        SaveButton.Enabled := False;
      end;

  case EditMode of
    emInsert : MainTable.Insert;

    emEdit : begin
               _Locate(MainTable, [TaxRollYr, SwisSBLKey, Site, ImprovementNumber], '', []);
               MainTable.Edit;
             end;

    emBrowse : _Locate(MainTable, [TaxRollYr, SwisSBLKey, Site, ImprovementNumber], '', []);

  end;  {case EditMode of}

  Caption := 'Residential Improvement (Site ' + MainTable.FieldByName('Site').Text + ')';
  RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);
  SetMeasurementEdits;

end;  {InitializeForm}

{===================================================================}
Procedure TResidentialImprovementsSubform.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{========================================================================}
Procedure TResidentialImprovementsSubform.SetRangeForTable(Table : TTable);

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

{=================================================================}
Procedure TResidentialImprovementsSubform.MainTableAfterInsert(DataSet: TDataset);

begin
  InitializeFieldsForRecord(DataSet);

    {CHG10281997-1: Dual mode processing.}

  RecordAction := raInserted;

    {Set the tax roll year and SBL Key.}

  MainTable.FieldByName('TaxRollYr').Text  := Take(4, TaxRollYr);
  MainTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
  MainTable.FieldByName('Site').AsInteger := Site;

  RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

    {Set up the Measurement restrictions code for this structre type, if it is filled
     in already.}
    {FXX07061998-1: Set up the measurement restrictions codes in one place and
                    use one table.}

  If (Deblank(MainTable.FieldByName('StructureDesc').Text) <> '')
    then SetMeasurementRestrictions(StructureLookupTable, MeasurementRestrictionsCodes);

    {Now figure out the next improvement number by looking at the
     last improvement in the range.}
    {FXX06272001-2: Sometimes opening the residential improvements form was slow
                    because it was checking the record count.}

  SetRangeForTable(ImprovementLookupTable);
  ImprovementLookupTable.First;

  If ImprovementLookupTable.EOF
    then MainTable.FieldByName('ImprovementNumber').AsInteger := 1
    else
      begin
          {There are improvement records for this parcel, so let's
           get the last one and look at the improvement number.}
           
        ImprovementLookupTable.Last;

        MainTable.FieldByName('ImprovementNumber').AsInteger :=
           ImprovementLookupTable.FieldByName('ImprovementNumber').AsInteger + 1;

      end;  {else of If (MainTable.RecordCount = 0)}

  CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

end;  {MainTableAfterInsert}

{=================================================================}
Procedure TResidentialImprovementsSubform.MainTableAfterEdit(DataSet: TDataset);

begin
  RecordAction := raEdited;
  CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

end;  {MainTableAfterEdit}

{=================================================================}
Procedure TResidentialImprovementsSubform.EditEnter(Sender: TObject);

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

{=====================================================================}
Procedure TResidentialImprovementsSubform.EditExit(Sender: TObject);

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
Function TResidentialImprovementsSubform.DetermineCodeTableName(Tag : Integer) : String;

begin
  case Tag of
    Structure : Result := 'ZInvStructureTbl';
    Measurement : Result := 'ZInvMeasurementTbl';
    Grade : Result := 'ZInvGradeTbl';
    Condition : Result := 'ZInvConditionTbl';

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{========================================================================}
Procedure TResidentialImprovementsSubform.SetCodeTableName(Tag : Integer);

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
Procedure TResidentialImprovementsSubform.CodeLookupEnter(Sender: TObject);


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

{=======================================================================================}
Procedure TResidentialImprovementsSubform.SetMeasurementRestrictions(    StructureLookupTable : TTable;
                                                                     var MeasurementRestrictionsCodes : Charset);

begin
  MeasurementRestrictionsCodes := [];

    {FXX07271998-1: Need to look up on the code set in CodeTable, not
                    StructureLookupTable.}

  StructureLookupTable.IndexName := 'BYMAINCODE';

  If _Locate(StructureLookupTable, [CodeTable.FieldByName('MainCode').Text], '', [])
    then
      begin
        If TBooleanField(StructureLookupTable.FieldByName('CanUseMC1')).AsBoolean
          then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['1'];

        If TBooleanField(StructureLookupTable.FieldByName('CanUseMC2')).AsBoolean
          then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['2'];

        If TBooleanField(StructureLookupTable.FieldByName('CanUseMC3')).AsBoolean
          then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['3'];

        If TBooleanField(StructureLookupTable.FieldByName('CanUseMC4')).AsBoolean
          then MeasurementRestrictionsCodes := MeasurementRestrictionsCodes + ['4'];

        StructureLookupTable.IndexName := 'BYDESCRIPTION';

      end;  {If _Locate(StructureLookupTable ...}

end;  {SetMeasurementRestrictions}

{=====================================================================================}
Procedure TResidentialImprovementsSubform.SetCodeOnLookupCloseUp(Sender: TObject;
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

                {FXX03031998-10: If the person hit enter on the measurement
                                 code, it went to the cancel button.}

              If (Screen.ActiveForm.ActiveControl.Name = 'OKButton')
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

                If (Deblank(MainTable.FieldByName('StructureDesc').Text) <> '')
                  then
                    begin
                        {FXX07061998-1: Set up the measurement restrictions codes in one place and
                                        use one table.}

                      SetMeasurementRestrictions(StructureLookupTable, MeasurementRestrictionsCodes);

                        {Now, if the measurement code is not in the current restrictions
                         because of a change, blank out the measurement code and
                         the measure edits.}

                        {FXX11131997-3: Users may need to put in qty no
                                        matter what the dimension code is.}

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

{==============================================================}
Procedure TResidentialImprovementsSubform.EditYearBuiltExit(Sender: TObject);

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
Procedure TResidentialImprovementsSubform.MeasurementCodeLookupExit(Sender: TObject);

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

  SetMeasurementEdits;

end;  {MeasurementCodeLookupExit}

{==============================================================}
Procedure TResidentialImprovementsSubform.SaveButtonClick(Sender: TObject);

{If they click the OK button we will post the record and hide the panel.
 Note that this is a shared event handler with the EditPanel OnExit.}

begin
  If ((MainTable.State in [dsInsert, dsEdit]) and
      MainTable.Modified)
    then
      begin
        MainTable.Post;
        Close;
      end;

    {FXX02231999-2: Need to make sure there is a way out for inquire mode, too.}

  If (MainTable.State in [dsBrowse])
    then Close;

end;  {OKButtonClick}

{==============================================================}
Procedure TResidentialImprovementsSubform.CancelButtonClick(Sender: TObject);

begin
  MainTable.Cancel;
  Close;
end;

{==============================================================}
Procedure TResidentialImprovementsSubform.MainTableBeforePost(DataSet: TDataset);

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

        ReturnCode := MessageDlg('Do you wish to save your residential improvement changes?',
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
Procedure TResidentialImprovementsSubform.MainTableAfterPost(DataSet: TDataset);

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
  NumChanges := RecordChanges(Self, MainCaption, MainTable, SwisSBLKey,
                              FieldTraceInformationList);

  If (NumChanges > 0)
    then ParcelChanged := True;

   {CHG10271997-1: Make the change in the opposite year, too.}

  If (GlblModifyBothYears and
      (ProcessingType <> SalesInventory))
    then
      begin
          {Set the table in insert or edit mode depending on what action
           the user did.}

        case RecordAction of
          raInserted : begin
                         OppositeYearResImprovementTable.Insert;
                         Found := True;

                       end;  {raInserted}

          raEdited : begin
                       Found := FindKeyOld(OppositeYearResImprovementTable,
                                           ['TaxRollYr', 'SwisSBLKey', 'Site', 'ImprovementNumber'],
                                           [OppositeTaxYear,
                                            SwisSBLKey,
                                            IntToStr(MainTable.FieldByName('Site').AsInteger),
                                            IntToStr(MainTable.FieldByName('ImprovementNumber').AsInteger)]);

                       If Found
                         then OppositeYearResImprovementTable.Edit;

                     end;  {raEdited}

        end;  {case RecordAction of}

        CreateFieldValuesAndLabels(Self, OppositeYearResImprovementTable,
                                   FieldTraceInformationList);

          {Copy the fields from the main table to the new table, but make
           sure that we do not copy the tax roll year.}

        If Found
          then
            begin
              CopyFields(MainTable, OppositeYearResImprovementTable,
                         ['TaxRollYr'], [OppositeTaxYear]);

              try
                OppositeYearResImprovementTable.Post;
              except
                SystemSupport(050, OppositeYearResImprovementTable,
                              'Error posting opposite year record.', UnitName,
                              GlblErrorDlgBox);
              end;

              If (RecordChanges(Self, Caption,
                                OppositeYearResImprovementTable, SwisSBLKey,
                                FieldTraceInformationList) > 0)
                then OppositeYearParcelChanged := True;

            end;  {If Found}

      end;  {If GlblModifyBothYears}

end;  {MainTableAfterPost}

{====================================================================}
Procedure TResidentialImprovementsSubform.FormCloseQuery(    Sender: TObject;
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

{===================================================================}
Procedure TResidentialImprovementsSubform.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

end;  {FormClose}

end.
