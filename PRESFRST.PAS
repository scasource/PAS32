unit Presfrst;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons;

type
  TParcelResidentialForestForm = class(TForm)
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    Grid: TwwDBGrid;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    CloseButton: TBitBtn;
    Navigator: TDBNavigator;
    CodeTable: TwwTable;
    EditPanel: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Acres: TLabel;
    Label18: TLabel;
    Label6: TLabel;
    ForestTypeCodeLookup: TwwDBLookupCombo;
    LoggingCodeLookup: TwwDBLookupCombo;
    SiteClassCodeLookup: TwwDBLookupCombo;
    CutClassCodeLookup: TwwDBLookupCombo;
    EditValue: TDBEdit;
    EditAcres: TDBEdit;
    EditShoreline: TDBEdit;
    CancelButton: TBitBtn;
    OKButton: TBitBtn;
    RegionLookupCombo: TwwDBLookupCombo;
    AccessibilityLookupCombo: TwwDBLookupCombo;
    NominalValLookupCombo: TwwDBLookupCombo;
    VolAcreClassLookupCombo: TwwDBLookupCombo;
    EditForestNumber: TDBEdit;
    Label17: TLabel;
    Label4: TLabel;
    EditSBL: TMaskEdit;
    Label7: TLabel;
    EditLocation: TEdit;
    Label21: TLabel;
    EditSite: TDBEdit;
    SaleNumberLabel: TLabel;
    EditSalesNumber: TEdit;
    Label5: TLabel;
    EditName: TDBEdit;
    Label3: TLabel;
    EditLastChangeDate: TDBEdit;
    Label33: TLabel;
    EditLastChangeByName: TDBEdit;
    Label29: TLabel;
    EditNumResSites: TEdit;
    Label30: TLabel;
    EditNumComSites: TEdit;
    ResidentialSiteTable: TTable;
    ResidentialSiteDataSource: TDataSource;
    Label51: TLabel;
    InactiveLabel: TLabel;
    OppositeYearResForestTable: TTable;
    Label19: TLabel;
    Label41: TLabel;
    Label44: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    PartialAssessmentLabel: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterEdit(DataSet: TDataset);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure MainTableAfterDelete(DataSet: TDataset);
    procedure CodeLookupEnter(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure EditPanelEnter(Sender: TObject);
    procedure MainDataSourceDataChange(Sender: TObject; Field: TField);
    procedure GridDblClick(Sender: TObject);
    procedure MainTableBeforeDelete(DataSet: TDataset);
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

    LookupTable : TTable;  {Temp table for finding next forest number.}

    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
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
    DeletedSiteNum,
    DeletedForestNum : Integer;
    FieldTraceInformationList : TList;

    Procedure InitializeForm;
    Procedure SetRangeForTable(Table : TTable);
      {What is the code table name for this lookup?}
    Function DetermineCodeTableName(Tag : Integer) : String;

      {Actually set the code table name.}
    Procedure SetCodeTableName(Tag : Integer);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst;


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

  Region = 10;  {LLL1}
  ForestType = 20;
  LoggingEase = 30;
  Accessibility = 40;
  NominalValue = 50;
  SiteClass = 60;
  CutClass = 70;
  VolAcreClass = 80;

    {Now we will put the lookups that are description based in a set for later
     reference.}

  DescriptionIndexedLookups : set of 0..250 = [Region, ForestType, LoggingEase, Accessibility,
                                               NominalValue, SiteClass, CutClass, VolAcreClass];  {LLL2}

{=====================================================================}
Procedure TParcelResidentialForestForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TParcelResidentialForestForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{mmm4 - Make sure to set range on all keys.}

begin
  try
    If (ProcessingType = SalesInventory)
      then SetRangeOld(Table,
                       ['SwisSBLKey', 'SalesNumber', 'Site',
                        'ForestNumber'],
                       [SwisSBLKey, IntToStr(SalesNumber), IntToStr(Site), '0'],
                       [SwisSBLKey, IntToStr(SalesNumber), IntToStr(Site), '32000'])
      else SetRangeOld(Table,
                       ['TaxRollYr', 'SwisSBLKey', 'Site',
                        'ForestNumber'],
                       [TaxRollYr, SwisSBLKey, IntToStr(Site), '0'],
                       [TaxRollYr, SwisSBLKey, IntToStr(Site), '32000']);
  except
    SystemSupport(001, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TParcelResidentialForestForm.InitializeForm;

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
  UnitName := 'PRESFRST.PAS';  {mmm1}
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
           set the table name and open them implicitly.
           OpenTablesForForm is a method in PASUTILS.}

        OpenTablesForForm(Self, ProcessingType);

          {If this is sales inventory, then let's set the index to include the
           sales number. Otherwise, let's do the index without the sales number.}

        If (ProcessingType = SalesInventory)
          then MainTable.IndexName := 'BYSBL_SALESNUM_SITE_FOREST'
          else MainTable.IndexName := 'BYTAXROLLYR_SBL_SITE_FOREST';

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                              [TaxRollYr, SwisCode, Section, SubSection,
                               Block, Lot, Sublot, Suffix]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Set the range.}

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

        TitleLabel.Caption := 'Residential Forest';
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
              CancelButton.Visible := False;

            end;  {If MainTable.ReadOnly}

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

          {Center the edit panel.}

        EditPanel.Top := Panel2.Top + ScrollBox.Top + (ScrollBox.Height - EditPanel.Height) DIV 2;
        EditPanel.Left := (Width - EditPanel.Width) DIV 2;

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

        OpenTableForProcessingType(OppositeYearResForestTable,
                                   ResidentialForestTableName,
                                   OppositeProcessingType, Quit);

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  FormIsInitializing := False;

end;  {InitializeForm}

{====================================================================}
Function TParcelResidentialForestForm.DetermineCodeTableName(Tag : Integer) : String;

begin
  case Tag of
    Region : Result := 'ZInvForestRegionTbl';   {LLL3}
    ForestType : Result := 'ZInvForestTypeTbl';   {LLL3}
    LoggingEase : Result := 'ZInvLoggingEaseTbl';   {LLL3}
    Accessibility : Result := 'ZInvAccessibilityTbl';   {LLL3}
    NominalValue : Result := 'ZInvNominalValueTbl';   {LLL3}
    SiteClass : Result := 'ZInvSiteClassTbl';   {LLL3}
    CutClass : Result := 'ZInvCutClassTbl';   {LLL3}
    VolAcreClass : Result := 'ZInvVolAcreClassTbl';   {LLL3}

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{========================================================================}
Procedure TParcelResidentialForestForm.SetCodeTableName(Tag : Integer);

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
Procedure TParcelResidentialForestForm.CodeLookupEnter(Sender: TObject);


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

end;  {CodeLookupEnter}

{=====================================================================================}
Procedure TParcelResidentialForestForm.SetCodeOnLookupCloseUp(Sender: TObject;
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

          end;  {else of If (TComponent(Sender).Tag in DescriptionIndexedLookups)}

end;  {SetCodeOnLookupCloseup}

{==============================================================}
Procedure TParcelResidentialForestForm.CancelButtonClick(Sender: TObject);

{If they click the cancel button we will cancel the edits and hide the panel.}

begin
  MainTable.Cancel;
  EditPanel.Visible := False;
end;

{==============================================================}
Procedure TParcelResidentialForestForm.OKButtonClick(Sender: TObject);

{If they click the OK button we will post the record and hide the panel.
 Note that this is a shared event handler with the EditPanel OnExit.}

begin
  If ((MainTable.State in [dsInsert, dsEdit]) and
      MainTable.Modified)
    then MainTable.Post;

  If EditPanel.Visible
    then EditPanel.Visible := False;

end;  {OKButtonClick}

{===========================================================================}
Procedure TParcelResidentialForestForm.MainDataSourceDataChange(Sender: TObject;
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
Procedure TParcelResidentialForestForm.MainTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in the Self var.

 Also, if they are in insert state, then we will initialize the values
 TaxRollYr, SwisSBLKey, and Site. Also, we will set the new improvement
 number.}

begin
  If not FormIsInitializing
    then
      begin
        CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

        EditPanel.Show;

          {CHG10281997-1: Dual mode processing.}

        If (MainTable.State = dsInsert)
          then RecordAction := raInserted
          else RecordAction := raEdited;

        If (MainTable.State = dsInsert)
          then
            begin
                {Set the tax roll year and SBL Key.}

              MainTable.FieldByName('TaxRollYr').Text  := Take(4, TaxRollYr);
              MainTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);
              MainTable.FieldByName('Site').AsInteger := Site;

                {Now figure out the next Forest number by looking at the
                 last Forest in the range.}

              If (GetRecordCount(MainTable) = 0)
                then MainTable.FieldByName('ForestNumber').AsInteger := 1
                else
                  begin
                      {If the lookup table has not yet been created,
                       then create and open it.}

                    If (LookupTable = nil)
                      then
                        begin
                          LookupTable := TTable.Create(Self);
                          LookupTable.DatabaseName := 'PASsystem';
                          LookupTable.TableName := 'TPResidentialForest';
                          LookupTable.TableType := ttDBase;
                          LookupTable.IndexName := InventoryYear_SwisSBLKey;
                          SetTableNameForProcessingType(LookupTable, ProcessingType);
                          LookupTable.Open;
                          SetRangeForTable(LookupTable);

                        end;  {If (LookupTable = nil)}

                      {There are Forest records for this parcel, so let's
                       get the last one and look at the Forest number.}

                    try
                      LookupTable.Last;
                    except
                      SystemSupport(010, LookupTable, 'Error getting last in residential Forest table.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                    MainTable.FieldByName('ForestNumber').AsInteger := LookupTable.FieldByName('ForestNumber').AsInteger + 1;

                  end;  {else of If (MainTable.RecordCount = 0)}

            end;  {If (MainTable.State = dsInsert)}

      end;  {If not FormInitializing}

end;  {MainTableAfterEdit}

{==============================================================}
Procedure TParcelResidentialForestForm.GridDblClick(Sender: TObject);

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
Procedure TParcelResidentialForestForm.EditPanelEnter(Sender: TObject);

var
  I : Integer;

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

end;  {EditPanelEnter}

{==============================================================}
Procedure TParcelResidentialForestForm.MainTableBeforeDelete(DataSet: TDataset);

{CHG10281997-1: Dual mode processing.}
{Record the site that is about to be deleted so that we can delete in the
 opposite year too.}

begin
  DeletedSiteNum := MainTable.FieldByName('Site').AsInteger;
  DeletedForestNum := MainTable.FieldByName('ForestNumber').AsInteger;

end;  {MainTableBeforeDelete}

{==============================================================}
Procedure TParcelResidentialForestForm.MainTableAfterDelete(DataSet: TDataset);

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
        Found := FindKeyOld(OppositeYearResForestTable,
                            ['TaxRollYr', 'SwisSBLKey', 'Site', 'ForestNumber'],
                            [OppositeTaxYear,
                             ExtractSSKey(ParcelTable),
                             IntToStr(DeletedSiteNum),
                             IntToStr(DeletedForestNum)]);

        If Found
          then OppositeYearResForestTable.Delete;

      end;  {If GlblModifyBothYears}

end;  {MainTableAfterDelete}

{==============================================================}
Procedure TParcelResidentialForestForm.MainTableBeforePost(DataSet: TDataset);

{Verify that they want to save.}

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

        ReturnCode := MessageDlg('Do you wish to save your residential forest changes?', mtConfirmation,
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
Procedure TParcelResidentialForestForm.MainTableAfterPost(DataSet: TDataset);

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

  If GlblModifyBothYears
    then
      begin
          {Set the table in insert or edit mode depending on what action
           the user did.}

        case RecordAction of
          raInserted : begin
                         OppositeYearResForestTable.Insert;
                         Found := True;

                       end;  {raInserted}

          raEdited : begin
                       Found := FindKeyOld(OppositeYearResForestTable,
                                           ['TaxRollYr', 'SwisSBLKey', 'Site', 'ForestNumber'],
                                           [OppositeTaxYear,
                                            ExtractSSKey(ParcelTable),
                                            IntToStr(MainTable.FieldByName('Site').AsInteger),
                                            IntToStr(MainTable.FieldByName('ForestNumber').AsInteger)]);

                       If Found
                         then OppositeYearResForestTable.Edit;

                     end;  {raEdited}

        end;  {case RecordAction of}

        CreateFieldValuesAndLabels(Self, OppositeYearResForestTable, FieldTraceInformationList);

          {Copy the fields from the main table to the new table, but make
           sure that we do not copy the tax roll year.}

        If Found
          then
            begin
              CopyFields(MainTable, OppositeYearResForestTable,
                         ['TaxRollYr'], [OppositeTaxYear]);

              try
                OppositeYearResForestTable.Post;
              except
                SystemSupport(050, OppositeYearResForestTable,
                              'Error posting opposite year record.', UnitName,
                              GlblErrorDlgBox);
              end;

              If (RecordChanges(Self, Caption,
                                OppositeYearResForestTable, SwisSBLKey,
                                FieldTraceInformationList) > 0)
                then OppositeYearParcelChanged := True;

            end;  {If Found}

      end;  {If GlblModifyBothYears}

end;  {MainTableAfterPost}

{==============================================================}
Procedure TParcelResidentialForestForm.CloseButtonClick(Sender: TObject);

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
Procedure TParcelResidentialForestForm.FormCloseQuery(    Sender: TObject;
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

{====================================================================}
Procedure TParcelResidentialForestForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

var
  Quit : Boolean;
  SBLRec : SBLRecord;

begin
    {Now, if the parcel changed, then update the parcel and residential
     site table.}

  If ParcelChanged
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