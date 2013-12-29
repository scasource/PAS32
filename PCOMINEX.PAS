unit Pcominex;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons;

type
  TParcelCommercialIncomeExpenseForm = class(TForm)
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
    EditGrossRentalIncome: TDBEdit;
    EditAdditionalIncome: TDBEdit;
    EditVacancyCreditLoss: TDBEdit;
    EditTotalExpenses: TDBEdit;
    EditBldgSvcExpenses: TDBEdit;
    EditEffectiveGrossIncome: TDBEdit;
    EditNetOperatingIncome: TDBEdit;
    EditAppreciationDepreciationPercent: TDBEdit;
    Edit1stMortgageTerm: TDBEdit;
    LookupAppreciationDepreciationCode: TwwDBLookupCombo;
    LookupInvestmentSet: TwwDBLookupCombo;
    LookupDataUse: TwwDBLookupCombo;
    LookupExpenseType: TwwDBLookupCombo;
    EditAlternateAddress: TDBEdit;
    EditAlternateName: TDBEdit;
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
    Label19: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label40: TLabel;
    CodeTable: TwwTable;
    Label42: TLabel;
    Label43: TLabel;
    EditReserveForReplacement: TDBEdit;
    Edit1stMortgageInterestRate: TDBEdit;
    EditInsuranceExpenses: TDBEdit;
    EditUtilityExpenses: TDBEdit;
    EditManagementExpenses: TDBEdit;
    EditMiscCosts: TDBEdit;
    EditInvestmentPeriod: TDBEdit;
    EditEquityYieldPercent: TDBEdit;
    EditEquityDividend: TDBEdit;
    Edit1stMortgageTotalInvestmentPercent: TDBEdit;
    Label18: TLabel;
    Label20: TLabel;
    Label48: TLabel;
    Edit2ndMortgageTotalInvestmentPercent: TDBEdit;
    Label49: TLabel;
    Edit2ndMortgageTerm: TDBEdit;
    Label50: TLabel;
    Edit2ndMortgageInterestRate: TDBEdit;
    CheckRentRestricted: TDBCheckBox;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Bevel1: TBevel;
    Label4: TLabel;
    EditSBL: TMaskEdit;
    Label7: TLabel;
    EditLocation: TEdit;
    Label3: TLabel;
    EditSite: TDBEdit;
    SaleNumberLabel: TLabel;
    EditSalesNumber: TEdit;
    Label5: TLabel;
    EditName: TDBEdit;
    Label30: TLabel;
    EditLastChangeDate: TDBEdit;
    Label33: TLabel;
    EditLastChangeByName: TDBEdit;
    Label31: TLabel;
    EditNumResSites: TEdit;
    Label32: TLabel;
    EditNumComSites: TEdit;
    CommercialSiteTable: TTable;
    CommercialSiteDataSource: TDataSource;
    InactiveLabel: TLabel;
    OppositeYearComIncExpTable: TTable;
    Label41: TLabel;
    Label44: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    SetFocusTimer: TTimer;
    OldParcelIDLabel: TLabel;
    AssessmentYearControlTable: TTable;
    PartialAssessmentLabel: TLabel;

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
    procedure MainTableNewRecord(DataSet: TDataset);
    procedure EditEffectiveGrossIncomeExit(Sender: TObject);
    procedure EditTotalExpensesExit(Sender: TObject);
    procedure OnExpenseEditEnter(Sender: TObject);
    procedure EditNetOperatingIncomeExit(Sender: TObject);
    procedure EditAppreciationDepreciationPercentEnter(Sender: TObject);
    procedure MainDataSourceDataChange(Sender: TObject; Field: TField);
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure MainTableBeforeDelete(DataSet: TDataset);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure SetCodeOnLookupCloseup(Sender: TObject; LookupTable,
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

    FieldTraceInformationList : TList;
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
    OppositeTaxYear : String;
    OppositeYearParcelChanged : Boolean;
    DeletedSiteNum : Integer;

    Procedure SetDisplayFormatForExpenseType(ExpenseCode : String);

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

  InvestmentSet = 10;  {LLL1}
  ExpenseType = 20;
  AppDep = 30;
  DataUse = 40;

    {Now we will put the lookups that are description based in a set for later
     reference.}

  DescriptionIndexedLookups : set of 0..250 =
         [InvestmentSet, ExpenseType, AppDep, DataUse];

{$R *.DFM}

{=====================================================================}
Procedure TParcelCommercialIncomeExpenseForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TParcelCommercialIncomeExpenseForm.SetRangeForTable(Table : TTable);

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

{=================================================================================}
Procedure TParcelCommercialIncomeExpenseForm.SetDisplayFormatForExpenseType(ExpenseCode : String);

{If the expense type is percent then we do not want to display '$' in front of
 the expenses. Otherwise, we do.}

var
  NewDisplayFormat : String;

begin
  If (ExpenseCode = '1')
    then NewDisplayFormat := '0'
    else NewDisplayFormat := CurrencyNormalDisplay;

  with MainTable do
    begin
      TFloatField(FieldByName('ManagementExpenses')).DisplayFormat := NewDisplayFormat;
      TFloatField(FieldByName('InsuranceExpenses')).DisplayFormat := NewDisplayFormat;
      TFloatField(FieldByName('BldgSvcExpenses')).DisplayFormat := NewDisplayFormat;
      TFloatField(FieldByName('UtilityExpenses')).DisplayFormat := NewDisplayFormat;
      TFloatField(FieldByName('MiscCosts')).DisplayFormat := NewDisplayFormat;
      TFloatField(FieldByName('TotalExpenses')).DisplayFormat := NewDisplayFormat;

    end;  {with MainTable do}

end;  {SetDisplayFormatForExpenseType}

{====================================================================}
Procedure TParcelCommercialIncomeExpenseForm.InitializeForm;

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
  Quit, Found, IncExpFound : Boolean;
  SBLRec : SBLRecord;

begin
  UnitName := 'PCOMINEX.PAS';  {mmm1}
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

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

          {FXX12151997-1: Make sure that the tital does not overlap the
                          assessed values.}

        TitleLabel.Caption := 'Comm Income\Expense';

(*        case EditMode of   {mmm5}
          'A' : TitleLabel.Caption := 'Commercial Income\Expense Add';
          'M' : TitleLabel.Caption := 'Commercial Income\Expense Modify';
          'V' : TitleLabel.Caption := 'Commercial Income\Expense View';

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

          {If there is no commercial expense record for this site
           then we will insert one now. Note that we will call
           Insert and fill in the fields in the OnNewRecord event so
           that the record does not get marked as modified. This way,
           if they exit the page without changing anything, it does
           not ask them to save.}

          {FXX03041998-13: Need to actually look and see if there is
                           an income/expense record since record count
                           does not return number within range.}

        If (ProcessingType = SalesInventory)
          then IncExpFound := FindKeyOld(MainTable,
                                         ['SwisSBLKey', 'SalesNumber', 'Site'],
                                         [SwisSBLKey, IntToStr(SalesNumber), IntToStr(Site)])
          else IncExpFound := FindKeyOld(MainTable,
                                         ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                         [TaxRollYr, SwisSBLKey, IntToStr(Site)]);

        If not (IncExpFound or MainTable.ReadOnly)
          then
            begin
              MainTable.Insert;

                {FXX03041998-11: Make sure that the record action is
                                 set in the case where this is a new
                                 record since AfterEdit is not executed
                                 during FormInitialize.}

              RecordAction := raInserted;

              CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

            end; {If IncExpFound}

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

          {Set the display for currency fields. Note that for some reason setting
           the currency field is not working in the object inspector, so we will
           force it.}

        with MainTable do
          begin
            TFloatField(FieldByName('EquityYieldPercent')).Currency := False;
            TFloatField(FieldByName('1stMortPercentTotInv')).Currency := False;
            TFloatField(FieldByName('1stMortIntRate')).Currency := False;
            TFloatField(FieldByName('2ndMortPercentTotInv')).Currency := False;
            TFloatField(FieldByName('2ndMortIntRate')).Currency := False;
            TFloatField(FieldByName('AppDepPercent')).Currency := False;

          end;  {with MainTable do}

        {CHG10091997-1: Display blanks for zeroes.}
        SetDisplayFormatForCurrencyFields(Self, True);

          {If this is sales inventory, then let's fill in the sales number edit.
           Otherwise, we will hide the sales edit and label.}

        If (ProcessingType = SalesInventory)
          then EditSalesNumber.Text := IntToStr(SalesNumber)
          else
            begin
              SaleNumberLabel.Visible := False;
              EditSalesNumber.Visible := False;
            end;

        SetDisplayFormatForExpenseType(MainTable.FieldByName('ExpenseTypeCode').Text);

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

          {CHG10281997-1: Dual mode processing.}

        If (ProcessingType = ThisYear)
          then OppositeProcessingType := NextYear
          else OppositeProcessingType := ThisYear;

        OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

        OpenTableForProcessingType(OppositeYearComIncExpTable,
                                   CommercialIncomeExpenseTableName,
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

          {FXX09102004-1(2.8.0.11): Make sure to get the site table so that the last change information is correct.}

        FindKeyOld(CommercialSiteTable,
                   ['TaxRollYr', 'SwisSBLKey', 'Site'],
                   [TaxRollYr, SwisSBLKey, IntToStr(Site)]);

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  FormIsInitializing := False;

end;  {InitializeForm}

{===========================================================}
Procedure TParcelCommercialIncomeExpenseForm.SetFocusToFirstField;

{FXX03031998-2: Set focus to the first field after insert, any post,
                and upon coming into the form.}

begin
  with EditGrossRentalIncome do
    begin
      SetFocus;
      SelectAll;
    end;

end;  {SetFocusToFirstField}

{===========================================================}
Procedure TParcelCommercialIncomeExpenseForm.SetFocusTimerTimer(Sender: TObject);

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
Procedure TParcelCommercialIncomeExpenseForm.EditEnter(Sender: TObject);

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
Procedure TParcelCommercialIncomeExpenseForm.EditExit(Sender: TObject);

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
Function TParcelCommercialIncomeExpenseForm.DetermineCodeTableName(Tag : Integer) : String;

begin
  case Tag of
    InvestmentSet : Result := 'ZInvInvestmentSetTbl';
    ExpenseType : Result := 'ZInvExpenseTbl';
    AppDep : Result := 'ZInvAppDepTbl';
    DataUse : Result := 'ZInvDataUseTbl';

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{========================================================================}
Procedure TParcelCommercialIncomeExpenseForm.SetCodeTableName(Tag : Integer);

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
Procedure TParcelCommercialIncomeExpenseForm.CodeLookupEnter(Sender: TObject);

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
Procedure TParcelCommercialIncomeExpenseForm.SetCodeOnLookupCloseup(Sender: TObject;
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
  If (MainTable.Modified and
      (MainTable.State in [dsEdit, dsInsert]))
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

    {If they just closed up the lookup close and the code is different and
     they are not is browse mode, then we will adjust the display format of
     the fields to either have a '$' or not.}

  If ((TComponent(Sender).Name = 'LookupExpenseType') and
      (MainTable.State <> dsBrowse) and
      Modified)
    then SetDisplayFormatForExpenseType(MainTable.FieldByName('ExpenseTypeCode').Text);

end;  {SetCodeOnLookupCloseUp}

{==============================================================}
Procedure TParcelCommercialIncomeExpenseForm.MainTableNewRecord(DataSet: TDataset);

{Initialize the fields tax roll year, site, and swis sbl. Note that
 by doing this in the OnNewRecord event, the table will not be marked
 as modified. We are doing this so that if they come into the commercial
 expense record for the first time, it appears that there is a record
 for them to edit. But, if they exit without making any changes, they
 will not be prompted to save.}

begin
  with MainTable do
    begin
        {CHG12152005-2(2.9.4.3): Initialize before setting the following fields or they get wiped out.}
        {FXX11142003-1: Make sure that all float and integer fields are initialized to 0.}

      InitializeFieldsForRecord(DataSet);

      FieldByName('TaxRollYr').Text := TaxRollYr;
      FieldByName('SwisSBLKey').Text := SwisSBLKey;
      FieldByName('Site').AsInteger := Site;

    end;  {with MainTable do}

end;  {MainTableNewRecord}

{=====================================================================}
Procedure TParcelCommercialIncomeExpenseForm.MainDataSourceDataChange(Sender: TObject;
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
Procedure TParcelCommercialIncomeExpenseForm.MainTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in the Self var.}

begin
  If not FormIsInitializing
    then
      begin
        CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

          {CHG10281997-1: Dual mode processing.}

        If (MainTable.State = dsInsert)
          then RecordAction := raInserted
          else RecordAction := raEdited;

      end;  {If not FormIsInitializing}

end;  {MainTableAfterEdit}

{==============================================================}
Procedure TParcelCommercialIncomeExpenseForm.MainTableBeforeDelete(DataSet: TDataset);

{CHG10281997-1: Dual mode processing.}
{Record the site that is about to be deleted so that we can delete in the
 opposite year too.}

begin
  DeletedSiteNum := MainTable.FieldByName('Site').AsInteger;
end;  {MainTableBeforeDelete}

{==============================================================}
Procedure TParcelCommercialIncomeExpenseForm.MainTableAfterDelete(DataSet: TDataset);

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
        Found := FindKeyOld(OppositeYearComIncExpTable,
                            ['TaxRollYr', 'SwisSBLKey', 'Site'],
                            [OppositeTaxYear,
                             ExtractSSKey(ParcelTable),
                             IntToStr(DeletedSiteNum)]);

        If Found
          then OppositeYearComIncExpTable.Delete;

      end;  {If GlblModifyBothYears}

    {FXX03031998-2: Set focus back to first field after edit, delete.}

  SetFocusToFirstField;

end;  {MainTableAfterDelete}

  {Data validation.}

{==========================================================================}
Procedure TParcelCommercialIncomeExpenseForm.EditEffectiveGrossIncomeExit(Sender: TObject);

{The effective gross income should equal Rent - Vacancy Loss + Misc Inc.}

begin
  with MainTable do
    If (FieldByName('EffectiveGrossInc').AsFloat <>
        (FieldByName('GrossRentalIncome').AsFloat +
         FieldByName('AdditionalIncome').AsFloat -
         FieldByName('VacancyOrCreditLoss').AsFloat))
      then MessageDlg('Warning! The effective gross income should equal the ' +
                      'rental income + additional income - vacancy or credit loss.',
                      mtWarning, [mbOK], 0);

end;  {EditEffectiveGrossIncomeExit}

{==============================================================}
Procedure TParcelCommercialIncomeExpenseForm.OnExpenseEditEnter(Sender: TObject);

{If they try to enter an expense without first entering an expense type
 code, don't let them.}

begin
  If (Deblank(MainTable.FieldByName('ExpenseTypeCode').Text) = '')
    then
      begin
        MessageDlg('Please enter an expense code before entering any expenses.',
                   mtError, [mbOK], 0);
        LookupExpenseType.SetFocus;
      end;

end;  {OnExpenseEditEnter}

{==============================================================}
Procedure TParcelCommercialIncomeExpenseForm.EditTotalExpensesExit(Sender: TObject);

{Total expenses equal the sum of the individual expenses.}

begin
  with MainTable do
    If (FieldByName('TotalExpenses').AsFloat <>
          (FieldByName('ManagementExpenses').AsFloat +
           FieldByName('InsuranceExpenses').AsFloat +
           FieldByName('BldgSvcExpenses').AsFloat +
           FieldByName('UtilityExpenses').AsFloat +
           FieldByName('MiscCosts').AsFloat))
      then MessageDlg('Warning! The total expenses should equal the sum of the individual expenses.',
                      mtWarning, [mbOK], 0);

end;  {EditTotalExpensesExit}

{==============================================================}
Procedure TParcelCommercialIncomeExpenseForm.EditNetOperatingIncomeExit(Sender: TObject);

{The net operating income is effective gross - total expenses - reserve for
 replacement.}

var
  NetIncomeOK : Boolean;

begin
  NetIncomeOK := False;

    {Percent based expenses.}

  If MainTable.Active
    then
      begin
        with MainTable do
          begin
            If (FieldByName('ExpenseTypeCode').Text = '1')
              then NetIncomeOK := (FieldByName('NetOperatingIncome').AsFloat =
                                   (FieldByName('EffectiveGrossInc').AsFloat -
                                    Roundoff((FieldByName('TotalExpenses').AsFloat *
                                              FieldByName('EffectiveGrossInc').AsFloat / 100), 0) -
                                    FieldByName('ReserveForReplacemen').AsFloat));

              {Dollar based expenses.}

            If (FieldByName('ExpenseTypeCode').Text = '2')
              then NetIncomeOK := (FieldByName('NetOperatingIncome').AsFloat =
                                   (FieldByName('EffectiveGrossInc').AsFloat -
                                    FieldByName('TotalExpenses').AsFloat -
                                    FieldByName('ReserveForReplacemen').AsFloat));

          end;  {with MainTable do}

        If not NetIncomeOK
          then MessageDlg('Warning! The net operating income should equal the effective gross ' +
                          'income - total expenses - reserves for replacement.',
                          mtWarning, [mbOK], 0);

      end;  {If MainTable.Active}

end;  {EditNetOperatingIncomeExit}

{==============================================================}
Procedure TParcelCommercialIncomeExpenseForm.EditAppreciationDepreciationPercentEnter(Sender: TObject);

{Make sure that they have the appreciation\depreciation code filled in.}

begin
  If (Deblank(MainTable.FieldByName('AppDepCode').Text) = '')
    then
      begin
        MessageDlg('Please enter an appreciation\depreciation code before entering ' +
                   'the appreciation\depreciation percent.',
                   mtError, [mbOK], 0);
        LookupAppreciationDepreciationCode.SetFocus;
      end;

end;  {EditAppreciationDepreciationPercentEnter}

{==============================================================}
Procedure TParcelCommercialIncomeExpenseForm.MainTableBeforePost(DataSet: TDataset);

{If this is insert state, then fill in the SBL key and the
 tax roll year.}

var
  ReturnCode : Integer;

begin
    {FXX05151998-3: Don't ask save on close form if don't want to see save.}

  If GlblAskSave
    then
      begin
          {FXX11061997-2: Remove the "save before exiting" prompt because it
                          is confusing. Use only "Do you want to save.}

        ReturnCode := MessageDlg('Do you wish to save your commercial income\expense changes?', mtConfirmation,
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
Procedure TParcelCommercialIncomeExpenseForm.MainTableAfterPost(DataSet: TDataset);

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
                         OppositeYearComIncExpTable.Insert;
                         Found := True;

                       end;  {raInserted}

          raEdited : begin
                       Found := FindKeyOld(OppositeYearComIncExpTable,
                                           ['TaxRollYr', 'SwisSBLKey', 'Site'],
                                           [OppositeTaxYear,
                                            ExtractSSKey(ParcelTable),
                                            IntToStr(MainTable.FieldByName('Site').AsInteger)]);

                       If Found
                         then OppositeYearComIncExpTable.Edit;

                     end;  {raEdited}

        end;  {case RecordAction of}

        CreateFieldValuesAndLabels(Self, OppositeYearComIncExpTable,
                                   FieldTraceInformationList);

          {Copy the fields from the main table to the new table, but make
           sure that we do not copy the tax roll year.}

        If Found
          then
            begin
              CopyFields(MainTable, OppositeYearComIncExpTable,
                         ['TaxRollYr'], [OppositeTaxYear]);

              try
                OppositeYearComIncExpTable.Post;
              except
                SystemSupport(050, OppositeYearComIncExpTable,
                              'Error posting opposite year record.', UnitName,
                              GlblErrorDlgBox);
              end;

              If (RecordChanges(Self, Caption,
                                OppositeYearComIncExpTable, SwisSBLKey,
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

    {FXX03031998-2: Set focus back to first field after edit, delete.}

  SetFocusToFirstField;

end;  {MainTableAfterPost}

{==============================================================}
Procedure TParcelCommercialIncomeExpenseForm.SaveButtonClick(Sender: TObject);

begin
  MainTable.Post;
end;  {SaveButtonClick}

{===================================================================}
Procedure TParcelCommercialIncomeExpenseForm.CancelButtonClick(Sender: TObject);

begin
  If (MainTable.Modified and
      (MessageDlg('Warning! You will lose all changes.' + #13 +
                  'Cancel anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes))
    then MainTable.Cancel;

end;  {CancelButtonClick}

{==============================================================}
Procedure TParcelCommercialIncomeExpenseForm.CloseButtonClick(Sender: TObject);

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
Procedure TParcelCommercialIncomeExpenseForm.FormCloseQuery(    Sender: TObject;
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
Procedure TParcelCommercialIncomeExpenseForm.FormClose(    Sender: TObject;
                                                       var Action: TCloseAction);

var
  Quit : Boolean;
  SBLRec : SBLRecord;

begin
    {Now, if the parcel changed, then update the parcel and commercial site table.}

  If (ParcelChanged and
      (ProcessingType <> SalesInventory))
    then
      begin
        MarkRecChanged(ParcelTable, UnitName);
        MarkRecChanged(CommercialSiteTable, UnitName);
      end;

    {CHG10281997-1: Dual mode processing.}

  If OppositeYearParcelChanged
    then
      begin
          {Close the parcel and site table and reopen them for the
           opposite year.}

        ParcelTable.Close;
        CommercialSiteTable.Close;

        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   OppositeProcessingType, Quit);

        OpenTableForProcessingType(CommercialSiteTable, CommercialSiteTableName,
                                   OppositeProcessingType, Quit);

          {FXX11201997-2: We were not getting opposite year parcel table before
                          trying to mark it as changed.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          FindKeyOld(ParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot',
                      'Suffix'],
                     [OppositeTaxYear, SwisCode, Section,
                      SubSection, Block, Lot, Sublot, Suffix]);

           {FXX11211997-9: Do the same for inv. sites.}

        FindKeyOld(CommercialSiteTable,
                   ['TaxRollYr', 'SwisSBLKey', 'Site'],
                   [OppositeTaxYear, SwisSBLKey, IntToStr(Site)]);

        MarkRecChanged(ParcelTable, UnitName);
        MarkRecChanged(CommercialSiteTable, UnitName);

      end;  {If OppositeYearParcelChanged}

    {Close all tables here.}

  CloseTablesForForm(Self);

  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

  Action := caFree;

end;  {FormClose}

end.