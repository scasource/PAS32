unit PSales_NewStyle;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, Tabs, PASTypes,
  UtilPrcl, Wwdbedit, MemoDialog;

type
  TSalesPageForm = class(TForm)
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
    AssessmentYrLabel: TLabel;
    NoSalesLabel: TLabel;
    NewOwnerDBEdit: TDBEdit;
    NewOwnerLabel: TLabel;
    OldOwnerLabel: TLabel;
    OldOwnerDBEdit: TDBEdit;
    ControlNumberEdit: TDBEdit;
    SaleDateDBEdit: TDBEdit;
    PriceDBEdit: TDBEdit;
    CtlnoLabel: TLabel;
    PriceLabel: TLabel;
    SaleTypeDBLookupCombo: TwwDBLookupCombo;
    ValidityLabel: TLabel;
    StatusCodeLabel: TLabel;
    CondtionLabel: TLabel;
    SaleDateLabel: TLabel;
    SlsTyp: TLabel;
    StatusCodeDBLookupCombo: TwwDBLookupCombo;
    VerifyLabel: TLabel;
    Label11: TLabel;
    VerifyDBLookupCombo: TwwDBLookupCombo;
    AssessmentDataSource: TwwDataSource;
    AssessmentTable: TwwTable;
    Label6: TLabel;
    PersonalPropertyEdit: TDBEdit;
    PersonalPropertyLabel: TLabel;
    CodeTable: TwwTable;
    MainDataSource: TwwDataSource;
    AssessorChangeEA5217Label: TLabel;
    AssessorChgEA5217DBEdit: TDBEdit;
    EA5217DataSource: TwwDataSource;
    EA5217Table: TwwTable;
    ConditionsDBEdit: TDBEdit;
    TaxSaleYearDBEdit: TDBEdit;
    NoParcelsLabel: TLabel;
    NoParcelsDBEdit: TDBEdit;
    EA5217TableTaxRollYr: TStringField;
    EA5217TableMainCode: TStringField;
    EA5217TableDescription: TStringField;
    ConditionTable: TwwTable;
    CodeTableMainCode: TStringField;
    CodeTableTaxRollYr: TStringField;
    CodeTableDescription: TStringField;
    SaleNumberDBEdit: TDBEdit;
    ExemptionTable: TwwTable;
    Label18: TLabel;
    ExemptionTableTaxRollYr: TStringField;
    ExemptionTableSwisSBLKey: TStringField;
    ExemptionTableExemptionCode: TStringField;
    SalesLookupTable: TwwTable;
    InactiveLabel: TLabel;
    ArmsLengthCheckBox: TDBCheckBox;
    SaleTypeDesc: TLabel;
    ValidityCheckBox: TDBCheckBox;
    SaleStatusDesc: TLabel;
    DeedGroupBox: TGroupBox;
    DeedPageLabel: TLabel;
    DeedBookLabel: TLabel;
    DeedDateLabel: TLabel;
    DeedtypeLabel: TLabel;
    DeedDateDBEdit: TDBEdit;
    DeedPageDBEdit: TDBEdit;
    DeedBookDBEdit: TDBEdit;
    DeedTypeDBLookupCombo: TwwDBLookupCombo;
    VerifyDesc: TLabel;
    DeedTypeDesc: TLabel;
    NYParcelTable: TTable;
    NYParcelDataSource: TDataSource;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    SetFocusTimer: TTimer;
    TYParcelTable: TTable;
    Label21: TLabel;
    EditDateEntered: TDBEdit;
    TransmittedDateLabel: TLabel;
    TransmittedStatusLabel: TLabel;
    EditDateTransmitted: TDBEdit;
    EditPriorStatusCode: TDBEdit;
    SalesDeedTypeTable: TTable;
    AssessmentYearCtlTable: TTable;
    OldParcelIDLabel: TLabel;
    AssessmentYearControlTable: TTable;
    PartialAssessmentLabel: TLabel;
    GroupBox1: TGroupBox;
    TotalAssessedValLabel: TLabel;
    LandAssessedValLabel: TLabel;
    PropertyClassLabel: TLabel;
    RollSectLabel: TLabel;
    HomeSteadLabel: TLabel;
    ActiveInactiveLabel: TLabel;
    SchoolDistLabel: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label24: TLabel;
    DateEnteredEdit: TDBEdit;
    RollSectionDBEdit: TDBEdit;
    ActiveInactiveDBEdit: TDBEdit;
    SchoolDistDBEdit: TDBEdit;
    OwnershipDBEdit: TDBEdit;
    EastCordDBEdit: TDBEdit;
    NorhtCoordDBEdit: TDBEdit;
    DepthDBEdit: TDBEdit;
    FrontageDBEdit: TDBEdit;
    AcreageDBEdit: TDBEdit;
    LandAVDBEdit: TDBEdit;
    TotalAVDBEdit: TDBEdit;
    PropClassDBEdit: TDBEdit;
    HomeSteadDBEdit: TDBEdit;
    NameAddressPanel: TPanel;
    ParcelRecPanelLabel: TLabel;
    PnlAddr2Label: TLabel;
    PnlAddr1Label: TLabel;
    PnlName2Label: TLabel;
    PnlName1Label: TLabel;
    SwisLabel: TLabel;
    Label17: TLabel;
    Label15: TLabel;
    Label28: TLabel;
    StreetLabel: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    ParcelRecName1DBEdit: TDBEdit;
    ParcelRecName2DBEdit: TDBEdit;
    ParcelRecAddr1DBEdit: TDBEdit;
    ParcelRecAddr2DBEdit: TDBEdit;
    OKButton: TBitBtn;
    EditCity: TDBEdit;
    EditState: TDBEdit;
    EditZip: TDBEdit;
    EditZipPlus4: TDBEdit;
    ParcelRecStreetDBEdit: TDBEdit;
    CancelButton: TBitBtn;
    BankCodeEdit: TDBEdit;
    StatusPanel: TPanel;
    MemoDialog: TwwMemoDialog;
    Panel3: TPanel;
    CloseButton: TBitBtn;
    Navigator: TDBNavigator;
    SalesInventoryButton: TButton;
    OwnerProgressionButton: TButton;
    NotesButton: TBitBtn;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterEdit(DataSet: TDataset);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure MainTableAfterDelete(DataSet: TDataset);
    procedure CodeLookupEnter(Sender: TObject);
    procedure AssessorChgEA5217DBEditKeyPress(Sender: TObject;
      var Key: Char);
    procedure ConditionsDBEditKeyPress(Sender: TObject; var Key: Char);
    procedure NameAddressPanelExit(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure StatusCodeDBLookupComboExit(Sender: TObject);
    procedure MainTableBeforeEdit(DataSet: TDataset);
    procedure MainTableNewRecord(DataSet: TDataset);
    procedure SalesInventoryButtonClick(Sender: TObject);
    procedure MainDataSourceDataChange(Sender: TObject; Field: TField);
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ArmsLengthCheckBoxClick(Sender: TObject);
    procedure ParcelRecEditExit(Sender: TObject);
    procedure OwnerEditExit(Sender: TObject);
    procedure MainTableAfterCancel(DataSet: TDataset);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure SaleDateDBEditExit(Sender: TObject);
    procedure SetCodeOnLookupCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure OwnerProgressionButtonClick(Sender: TObject);
    procedure NotesButtonClick(Sender: TObject);
    procedure ConditionsDBEditExit(Sender: TObject);
    procedure DeedDateDBEditExit(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr : String;
    SwisSBLKey : String;
    SalesNumber : Integer;  {What sales number were they on last?}
    ProcessingType : Integer;  {NextYear, ThisYear, History}

      {The following four variables are passed in from parcel tab so that we can record
       the appropriate information for the sales inventory tabs if they create them.}

    ResidentialSite : PProcessingTypeArray; {What residential site are we on for this parcel
                                             for history, next year, this year, sales inv?}
    CommercialSite : PProcessingTypeArray;  {What commercial site are we on for this parcel
                                             for history, next year, this year, sales inv?}
    CommBuildingNo,
    CommBuildingSection : PProcessingTypeArray;  {What commercial building and section are they on
                                                  for history, next year, this year, sales inv?}

    NumResSites,
    NumComSites : PProcessingTypeArray;  {How many residential and commercial sites are there for this
                                           parcel for history, next year, this year and sales inv.?}

    ParcelTabSet : TTabSet;  {The tab set from PARCLTAB - we need this so that if they
                              want to add sales inventory tabs, we add them on to the
                              actual tab object.}

    TabTypeList :  TStringList;  {This is the list corresponding to the parcel tab set
                                  which tells us what processing type each tab is, i.e.
                                  ThisYear, NextYear, History, or SalesInventory.}

        {These var.'s are for tracing changes.}

    FieldTraceInformationList, ParcelFieldTraceInformationList : TList;

    SaleWasInserted,
    FormIsInitializing : Boolean;
    ClosingForm : Boolean;  {Are we closing a form right now?}

      {Have there been any changes?}

    ParcelChanged : Boolean;
    PanelButtonPressed : Boolean;

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
      {because these routines are placed at the form object def. level,}
      {they have access to all variables on form (no need to Var in)   }

     SaveStatusCode : String;
     SaveStatusDesc : String;

     OriginalSalesStatusCode : String; {save sales status cde on entry}
                                     {so we can set xmitted code (T) to }
                                     {retransmitted (R)          }

    OrigNameAddressBankCodeRec,
    NewNameAddressBankCodeRec : NameAddressBankCodeRecord;

    ValidSale : Boolean;
    OrigOldOwnerName : String;

    OrigNameAddressRec,
    NewNameAddressRec : NameAddressRecord;

    Procedure InitializeForm;
    Procedure SetFocusToFirstField;
    Procedure SetRangeForTable(Table : TTable);

         {What is the code table name for this lookup?}
    Function DetermineCodeTableName(Tag : Integer) : String;

      {Actually set the code table name.}
    Procedure SetCodeTableName(Tag : Integer);

    Function SiteFound(TableName : String;
                       SwisSBLKey : String;
                       ProcessingType : Integer;
                       TaxRollYr : String) : Boolean;


    Procedure CopyRecordsForSale(    SourceTable,
                                     DestTable : TTable;
                                     TaxRollYear : String;
                                     SourceSwisSBLKey : String;
                                     SalesNumber : Integer;
                                 var Quit : Boolean);
    {Copy all the inventory records for this inventory source table to the sales inventory
     DestTable.}

   Procedure RecordSalesInventory(ProcessingType : Integer;
                                  TaxRollYr : String);

   {Copy all inventory to the sales inventory files for this sale.}

   Function FillInSalesInformation : Boolean;

   Procedure OpenTablesForSalesInformation(     AssessmentTable,
                                                ParcelTable : TTable;
                                                SwisSBLKey : String;
                                                SaleDate : TDateTime;
                                            var LandAssessedValue,
                                                TotalAssessedValue : Comp;
                                            var TaxRollYear,
                                                AssessmentYear : String;
                                            var ValidSale,
                                                UsePriorFields : Boolean);


    Function SaleAppliesToThisYear : Boolean;
    {FXX07211999-4: If the sale is entered prior to final roll,
                    automatically put on ThisYear also.}

  end;    {end form object definition}

implementation

uses GlblVars, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     OwnerProgressionDialog, DataAccessUnit,
     GlblCnst;


{$R *.DFM}

Const
    {This is a unique number for each lookup box stored in that
     lookup's tag field.}
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

  SlsDeedType = 20;
  SlsStatus = 30;
  SlsSaleType = 40;
  SlsVerify = 60;

    {Now we will put the lookups that are description based in a set for later
     reference.}

  DescriptionIndexedLookups : set of 0..250 = []; {LLL2}


{========================================================================}
Procedure TSalesPageForm.SetCodeTableName(Tag : Integer);

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
Procedure TSalesPageForm.CodeLookupEnter(Sender: TObject);

{Close the code table and rename the table to the table for this lookup.
 Then we will rename it according to tax year and open it.}

begin
    {Only close and reopen the table if they are on a lookup that needs a
     different code table opened.}
      {save the status code on entry so user cant change it to something}
      {we do not allow}
  SAveStatusCode := MainTable.FieldByName('SaleStatusCode').Text;
  SaveStatusDesc := MainTable.FieldByName('SaleStatusCode').Text;

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

{==============================================================}
Procedure TSalesPageForm.SetCodeOnLookupCloseUp(Sender: TObject;
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
  If (MainTable.Modified and
      (not MainTable.ReadOnly) and
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

                FieldSize := MainTable.FieldByName(CodeFieldName).DataSize - 1; {Minus 1 because it includes #0.}

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

                 {CHG10141997-1}
                 {Set the description label for the code based dropdown.}

              TempLabel := TLabel(FindComponent(DescFieldName));
              TempLabel.Caption := MainTable.FieldByName(DescFieldName).Text;
              TempLabel.Hint := CodeTable.FieldByName('Description').Text;

          end;  {else of If (TComponent(Sender).Tag in DescriptionIndexedLookups)}

end;  {SetCodeOnLookupCloseUp}

{=========================================================================}
Function TSalesPageForm.DetermineCodeTableName(Tag : Integer) : String;

begin
  case Tag of
    SlsDeedType : Result := 'ZSlsDeedTypeTbl';
    SlsStatus : Result := 'ZSlsStatusTbl';
    SlsSaleType : Result := 'ZSlsSalesTypeTbl';
    SlsVerify : Result := 'ZSlsVerifyTbl';

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{=====================================================================}
Procedure TSalesPageForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TSalesPageForm.SetRangeForTable(Table : TTable);

          {Now set the range on this table
           so that it is sychronized to this parcel. Note
           that all segments of the key must be set.}
           {mmm4 - Make sure to set range on all keys.}

begin
  try
    {for sales set range to whole year for starters}
    SetRangeOld(Table, ['SwisSBLKey', 'SaleNumber'],
                [SwisSBLKey,'0'], [SwisSBLKey,'999']);

  except
    SystemSupport(002, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TSalesPageForm.InitializeForm;

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
  Found, Quit : Boolean;
  SBLRec : SBLRecord;
  I, TempProcessingType : Integer;
  TempTaxRollYear, AssessmentYear : String;

begin
  Quit := False;
  FormIsInitializing := True;
  UnitName := 'PSALESMT.PAS';  {mmm1}
  ParcelChanged := False;
  ClosingForm := False;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        FieldTraceInformationList := TList.Create;
        ParcelFieldTraceInformationList := TList.Create;

          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.
           We also want to set a filter to only include the year
           that they have selected for history.}

           {Note that we do not have to filter any tables where the tax roll year
            is already used as part of the lookup or set range key
            (i.e. the parcel table).}

        If ((not ModifyAccessAllowed(FormAccessRights)) or
            (EditMode = 'V'))
          then MainTable.ReadOnly := True;

          {There are so many tables on this form, we will
           set the table name and open them implicitly.
           OpenTablesForForm is a method in PASUTILS.}

        OpenTablesForForm(Self, ProcessingType);

          {FXX07211999-4: If the sale is entered prior to final roll,
                          automatically put on ThisYear also.}

        OpenTableForProcessingType(AssessmentYearCtlTable, AssessmentYearControlTableName,
                                   ThisYear, Quit);

          {FXX10231997-1: The address and deed changes should go on NY.}

        OpenTableForProcessingType(NYParcelTable, 'TParcelRec', NextYear,
                                   Quit);

          {FXX02122004-1(2.07l): If there is no Next Year, reopen the parcel table in
                                 this year.}
          {FXX07142004-2(2.08): Use GetRecordCount instead of .RecordCount in order to speed things up.}

        AssessmentYear := GlblNextYear;
        If (GetRecordCount(NYParcelTable) = 0)
          then
            begin
              OpenTableForProcessingType(NYParcelTable, ParcelTableName, ThisYear,
                                         Quit);
              AssessmentYear := GlblThisYear;
            end;

          {FXX01281999 - We also may need to put the changes on TY.}

        OpenTableForProcessingType(TYParcelTable, 'TParcelRec', ThisYear,
                                   Quit);

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        try
          with SBLRec do
            Found := FindKeyOld(ParcelTable,
                                ['TaxRollYr', 'SwisCode', 'Section',
                                 'Subsection', 'Block', 'Lot', 'Sublot',
                                 'Suffix'],
                                [TaxRollYr, SwisCode, Section,
                                 SubSection, Block, Lot, Sublot, Suffix]);
        except
          SystemSupport(004, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);
        end;

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {FXX10231997-1: The address and deed changes should go on NY.}

        try
          with SBLRec do
            Found := FindKeyOld(NYParcelTable,
                                ['TaxRollYr', 'SwisCode', 'Section',
                                 'Subsection', 'Block', 'Lot', 'Sublot',
                                 'Suffix'],
                                [AssessmentYear, SwisCode, Section,
                                 SubSection, Block, Lot, Sublot, Suffix]);
        except
          SystemSupport(004, NYParcelTable, 'Error finding key in NY parcel table.', UnitName, GlblErrorDlgBox);
        end;

          {FXX01281999 - We also may need to put the changes on TY.}

        try
          with SBLRec do
            Found := FindKeyOld(TYParcelTable,
                                ['TaxRollYr', 'SwisCode', 'Section',
                                 'Subsection', 'Block', 'Lot', 'Sublot',
                                 'Suffix'],
                                [GlblThisYear, SwisCode, Section,
                                 SubSection, Block, Lot, Sublot, Suffix]);
        except
          SystemSupport(004, TYParcelTable, 'Error finding key in TY parcel table.', UnitName, GlblErrorDlgBox);
        end;

          {Set the range.}
        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

          {for sales show most recent sales first}
        MainTable.Last;

          {If they were on a different sales record last time they were in the
           sales form for this parcel, then let's set them to that one. Note that if the
           sales number is 0, then this is the first time we have been on the form for this
           parcel, and we will not assume a sales number.}

        If ((SalesNumber <> 0) and
            (SalesNumber <> MainTable.FieldByName('SaleNumber').AsInteger))
          then
            try
              FindKeyOld(MainTable, ['SwisSBLKey', 'SaleNumber'],
                         [SwisSBLKey, IntToStr(SalesNumber)]);
            except
              SystemSupport(006, MainTable, 'Error finding Sales record.', UnitName, GlblErrorDlgBox);
            end;

        TitleLabel.Caption := 'Sales';
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
                    {Disable any navigator button that does
                     not apply in inquire mode.}

                  Navigator.VisibleButtons := [nbFirst, nbPrior, nbNext, nbLast];

                    {We will allow a width of 30 per button and
                     resize and recenter the navigator.}

                  Navigator.Width := 120;
                  Navigator.Left := (ScrollBox.Width - Navigator.Width) DIV 2;

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

          {For some reason the lookup boxes were not being filled in with the
           value in the underlying MainTable field when the form was initialized,
           so this fills in the fields so that the data is visible. Note that this
           does not cause the table to be marked modified. Also, we will fill
           in any labels for code based dropdowns. Note that the label names (not captions)
           must be EXACTLY the description field name in the table.}

        RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

          {Set the display for currency fields.}
          {CHG10091997-1: Display blanks for zeroes.}

        with MainTable do
          begin
            TIntegerField(FieldByName('SalePrice')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('Acreage')).DisplayFormat := DecimalDisplay;
            TFloatField(FieldByName('Frontage')).DisplayFormat := DecimalDisplay;
            TFloatField(FieldByName('Depth')).DisplayFormat := DecimalDisplay;
            TDateField(FieldByName('SaleDate')).EditMask := DateMask;
            TDateField(FieldByName('DeedDate')).EditMask := DateMask;

          end;  {with MainTable do}

        {center name addr panel on screen}
        NameAddressPanel.Left := (Width - NameAddressPanel.Width) DIV 2;
        NameAddressPanel.Top := 6;

        {ONLY if new record and no status set, allow user to edit }
        {in case they want to enter I for incomplete}

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

          {FXX03031998-2: Set focus to the first field. Note that we must
                          do this on a timer so that the form is showing
                          by the time we try to set focus.  Otherwise,
                          we get an error trying to set focus in an invisible
                          window.}

        SetFocusTimer.Enabled := True;

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

          {CHG12022001-1: Don't let searchers see the progression.}

        If GlblUserIsSearcher
          then OwnerProgressionButton.Visible := False;

          {CHG09122004-2(2.8.0.11): Option to hide the personal property fields.}

        If GlblHideSalesPersonalProperty
          then
            begin
              PersonalPropertyLabel.Visible := False;
              PersonalPropertyEdit.Visible := False;
              PersonalPropertyEdit.TabStop := False;

            end;  {If GlblHideSalesPersonalProperty}

          {CHG09122004-3(2.8.0.11): Option to hide all the sales transmittal fields.}

        If GlblHideSalesTransmitFields
          then
            begin
              VerifyLabel.Visible := False;
              VerifyDBLookupCombo.Visible := False;
              VerifyDBLookupCombo.TabStop := False;
              VerifyDesc.Visible := False;
              TransmittedDateLabel.Visible := False;
              EditDateTransmitted.Visible := False;
              EditDateTransmitted.TabStop := False;
              TransmittedStatusLabel.Visible := False;
              EditPriorStatusCode.Visible := False;
              EditPriorStatusCode.TabStop := False;
              AssessorChangeEA5217Label.Visible := False;
              AssessorChgEA5217DBEdit.Visible := False;
              AssessorChgEA5217DBEdit.TabStop := False;

            end;  {If GlblHideSalesTransmitFields}

      end;  {If (Deblank(SwisSBLKey) <> '')}

  FormIsInitializing := False;

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

end;  {InitializeForm}

{===========================================================}
Procedure TSalesPageForm.SetFocusToFirstField;

{FXX03031998-2: Set focus to the first field after insert, any post,
                and upon coming into the form.}

begin
  with NewOwnerDBEdit do
    begin
      SetFocus;
      SelectAll;
    end;

end;  {SetFocusToFirstField}

{===========================================================}
Procedure TSalesPageForm.SetFocusTimerTimer(Sender: TObject);

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
Procedure TSalesPageForm.MainTableBeforeEdit(DataSet: TDataset);

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

end;  {MainTableBeforeEdit}

{==============================================================}
Procedure TSalesPageForm.OpenTablesForSalesInformation(     AssessmentTable,
                                                            ParcelTable : TTable;
                                                            SwisSBLKey : String;
                                                            SaleDate : TDateTime;
                                                        var LandAssessedValue,
                                                            TotalAssessedValue : Comp;
                                                        var TaxRollYear,
                                                            AssessmentYear : String;
                                                        var ValidSale,
                                                            UsePriorFields : Boolean);

var
  ProcessingType : Integer;
  AssessmentYearSet, Found, SaleInfoFound, Quit, _HistoryExists : Boolean;
  TempYear, TempDate : String;

begin
  AssessmentYearSet := False;
  SaleInfoFound := False;
  _HistoryExists := HistoryExists;
  ValidSale := False;
  UsePriorFields := False;

  LandAssessedValue := 0;
  TotalAssessedValue := 0;

  TempDate := DateToStr(SaleDate);
  TempYear := MainTable.FieldByName('SaleAssessmentYear').Text;
  ProcessingType := FindProcessingTypeOfLastFinalRoll(SaleDate, TaxRollYear, Found);

  If Found
    then
      begin
           {If we actually found info for that year, use it.}

        If ((ProcessingType = NextYear) or
            (ProcessingType = ThisYear) or
            ((ProcessingType = History) and
             _HistoryExists))
          then
            begin
              OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                         ProcessingType, Quit);
              OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                         ProcessingType, Quit);

                {FXX05131999-1: If the roll year was found, but the parcel did not
                                exist, the wrong info was going on it.}

              SaleInfoFound := FindKeyOld(AssessmentTable,
                                          ['TaxRollYr', 'SwisSBLKey'],
                                          [TaxRollYear, SwisSBLKey]);

              If SaleInfoFound
                then
                  begin
                    LandAssessedValue := AssessmentTable.FieldByName('LandAssessedVal').AsFloat;
                    TotalAssessedValue := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

                    ValidSale := True;

                  end;  {If SaleInfoFound}

              AssessmentYear := TaxRollYear;
              AssessmentYearSet := True;

            end;  {If ((ProcessingType = NextYear) or ...}

      end;  {If Found}

  If not SaleInfoFound
    then
      If ((StrToInt(TaxRollYear) = (StrToInt(GlblThisYear) - 1)) and
          (not _HistoryExists))
        then
          begin
              {Need info from one year back, but there is no history yet, so
               use parcel info from ThisYear and assessment info from the prior
               fields of the parcel.}

            OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                       ThisYear, Quit);
            OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                       ThisYear, Quit);

              {FXX07191999-1: Scenario: New parcel in NY is sold, should be testing
                                        if found in TY assessment table. Otherwise,
                                        is not valid.}

            SaleInfoFound := FindKeyOld(AssessmentTable,
                                        ['TaxRollYr', 'SwisSBLKey'],
                                        [GlblThisYear, SwisSBLKey]);

            If SaleInfoFound
              then
                begin
                  LandAssessedValue := AssessmentTable.FieldByName('PriorLandValue').AsFloat;
                  TotalAssessedValue := AssessmentTable.FieldByName('PriorTotalValue').AsFloat;

                  ValidSale := True;

                    {FXX04071999-2: The assessment year does not match the tax year if
                                    using prior year.}

                  AssessmentYear := TaxRollYear;
                  AssessmentYearSet := True;
                  TaxRollYear := GlblThisYear;
                  UsePriorFields := True;

                end;  {If SaleInfoFound}

          end;  {If ((StrToInt(TaxRollYr) = (StrToInt(GlblThisYear) - 1) and ...}

  If ((not SaleInfoFound) or
      ((Roundoff(LandAssessedValue, 0) = 0) and
       (Roundoff(TotalAssessedValue, 0) = 0)))
    then
      begin
           {Either this is a new parcel or a very old sale, so not valid - use TY parcel
            info and leave values 0.}

        ValidSale := False;
        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   ThisYear, Quit);

      end;

    {FXX07191999-3: Do not reset the AssessmentYear if it was already set above.}

  If not AssessmentYearSet
    then AssessmentYear := TaxRollYear;

end;  {OpenTablesForSalesInformation}

{====================================================================}
Function TSalesPageForm.FillInSalesInformation : Boolean;

var
  TempParcelTable,
  ResidentialSiteTable, CommercialSiteTable : TTable;  {For determining how many res or com sites exist.}
  LandAssessedValue, TotalAssessedValue : Comp;
  AssessmentYear, TaxRollYear, TempTaxRollYear : String;
  Found, ValidSale, Quit, UsePriorFields : Boolean;
  SBLRec : SBLRecord;

begin
  TempParcelTable := TTable.Create(nil);
  TempParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

  OpenTablesForSalesInformation(AssessmentTable, TempParcelTable,
                                SwisSBLKey,
                                MainTable.FieldByName('SaleDate').AsDateTime,
                                LandAssessedValue,
                                TotalAssessedValue,
                                TaxRollYear, AssessmentYear,
                                ValidSale, UsePriorFields);

  If not ValidSale
    then TempTaxRollYear := GlblThisYear  {For parcel lookup}
    else TempTaxRollYear := TaxRollYear;

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    Found := FindKeyOld(TempParcelTable,
                        ['TaxRollYr', 'SwisCode', 'Section',
                         'Subsection', 'Block', 'Lot', 'Sublot',
                         'Suffix'],
                        [TempTaxRollYear, SwisCode, Section, Subsection,
                         Block, Lot, Sublot, Suffix]);

    {FXX07191999-1: Problems with parcels created in NY and sold there.}

  If (not (ValidSale or Found))
    then
      begin
        TempTaxRollYear := GlblNextYear;

        OpenTableForProcessingType(TempParcelTable, ParcelTableName, NextYear, Quit);

        with SBLRec do
          Found := FindKeyOld(TempParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot',
                               'Suffix'],
                              [TempTaxRollYear, SwisCode, Section, Subsection,
                               Block, Lot, Sublot, Suffix]);

      end;  {If (not (ValidSale and Found))}

    {FXX06021999-1: If this is a new parcel, it will have no prior info,
                    so use the current info.}

  If (UsePriorFields and
      (Deblank(TempParcelTable.FieldByName('PriorPropertyClass').Text) = ''))
    then UsePriorFields := False;

    {Set up read-only fields from parcel record}
    {FXX10231997-1: The address, deed changes, and other info
                    should go on NY.}
    {FXX10231997-2: The assessment year is always NY.}
    {FXX01281999 - We also may need to put the changes on TY.}
    {FXX03031999-3: The property information always is the most current.}

  with MainTable do
    begin
      FieldByName('IrregularShape').AsBoolean := TempParcelTable.FieldByName('IrregularShape').AsBoolean;
      FieldByName('Acreage').AsFloat := TempParcelTable.FieldByName('Acreage').AsFloat;
      FieldByName('Frontage').AsFloat := TempParcelTable.FieldByName('Frontage').AsFloat;
      FieldByName('Depth').AsFloat := TempParcelTable.FieldByName('Depth').AsFloat;
      FieldByName('SaleAssessmentYear').Text := AssessmentYear;

        {FXX07191999-2: Try always taking the orig NY name for this parcel since this should always
                        be the most current.}

      FieldByName('OldOwnerName').Text := OrigOldOwnerName;
      FieldByName('EastCoord').AsInteger := TempParcelTable.FieldByName('GridCordNorth').AsInteger;
      FieldByName('NorthCoord').AsInteger := TempParcelTable.FieldByName('GridCordEast').AsInteger;

        {FXX05131999-4: Prior fields were messed up.}

      If UsePriorFields
        then FieldByName('RollSection').Text := TempParcelTable.FieldByName('PriorRollSection').Text
        else FieldByName('RollSection').Text := TempParcelTable.FieldByName('RollSection').Text;

      FieldByName('RollSubsection').Text := TempParcelTable.FieldByName('RollSubsection').Text;

      If UsePriorFields
        then FieldByName('PropClass').Text := Take(3, TempParcelTable.FieldByName('PriorPropertyClass').Text)
        else FieldByName('PropClass').Text := Take(3, TempParcelTable.FieldByName('PropertyClassCode').Text);

      If UsePriorFields
        then FieldByName('HomesteadCode').Text := TempParcelTable.FieldByName('PriorHomesteadCode').Text
        else FieldByName('HomesteadCode').Text := TempParcelTable.FieldByName('HomesteadCode').Text;

      If UsePriorFields
        then FieldByName('SchoolDistCode').Text := Take(6, TempParcelTable.FieldByName('PriorSchoolDistrict').Text)
        else FieldByName('SchoolDistCode').Text := Take(6, TempParcelTable.FieldByName('SchoolCode').Text);

      FieldByName('ActiveFlag').Text := Take(1, TempParcelTable.FieldByName('ActiveFlag').Text);

        {We must create the check digit for the sale using ReturnCheckDigit
         in PASUTILS since the sales check digit has the sales number in
         the algorithm - it is not the parcel check digit.}

      FieldByName('CheckDigit').Text := ReturnCheckDigit(SwisSBLKey, FieldByName('SaleNumber').AsInteger);
      FieldByName('LegalAddrNo').Text := Take(10, TempParcelTable.FieldByName('LegalAddrNo').Text);

        {CHG05072002-3: Allow for sales report by legal address.}

      FieldByName('LegalAddrInt').AsInteger := GetLegalAddressInt(TempParcelTable.FieldByName('LegalAddrNo').Text);

        {FXX01201999-3: The legal addr was being filled in from the legal addr number.}

      FieldByName('LegalAddr').Text := TempParcelTable.FieldByName('LegalAddr').Text;
      FieldByName('AccountNo').Text := TempParcelTable.FieldByName('AccountNo').Text;
      If UsePriorFields
        then FieldByName('OwnershipCode').Text := TempParcelTable.FieldByName('PriorOwnershipCode').Text
        else FieldByName('OwnershipCode').Text := TempParcelTable.FieldByName('OwnershipCode').Text;

        {Figure out the number of residential and commercial sites.}
        {FXX10231997-3: Take NY inventory.}

      ResidentialSiteTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
                                                                     NextYear);
      CommercialSiteTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                                    NextYear);

        {FXX07301999-2: Was not calculating num sites for sales correctly.}

      FieldByName('NumResSites').AsInteger := CalculateNumSites(ResidentialSiteTable,
                                                                GlblNextYear,
                                                                SwisSBLKey, 0, False);
      FieldByName('NumComSites').AsInteger := CalculateNumSites(CommercialSiteTable,
                                                                GlblNextYear,
                                                                SwisSBLKey, 0, False);

      FieldByName('LandAssessedVal').AsFloat := LandAssessedValue;
      FieldByName('TotAssessedVal').AsFloat := TotalAssessedValue;

    end;  {with MainTable do}

  TempParcelTable.Close;
  TempParcelTable.Free;

  Result := ValidSale;

end;  {FillInSalesInformation}

{====================================================================}
Procedure TSalesPageForm.MainTableNewRecord(DataSet: TDataset);

begin
    {FXX11142003-1(2.07k): Make sure that all fields are initialized to 0.}
  InitializeFieldsForRecord(Dataset);

    {Assume that this will be a valid sale.}

  ValidSale := True;

    {set up next sales number for new sales record by getting highest}
    {sale number for this parcel on record}

  SetRangeOld(SalesLookupTable, ['SwisSBLKey', 'SaleNumber'],
              [SwisSBLKey, '0'], [SwisSBLKey, '32000']);
  SalesLookupTable.Last;

    {FXX06051998-1: Comparing the sales lookup table swis to the main
                    table swis, but it is blank at this point.}

  If ((SalesLookupTable.EOF) and
      (Take(26, SalesLookupTable.FieldByName('SwisSBLKey').Text) <>
       Take(26, SwisSBLKey)))
    then MainTable.FieldByName('SaleNumber').AsInteger := 1
    else MainTable.FieldByName('SaleNumber').AsInteger := SalesLookupTable.FieldByName('SaleNumber').AsInteger + 1;

    {CHG10211997-2: Default num parcels to 1.}

  MainTable.FieldByName('NoParcels').AsInteger := 1;

    {CHG12201999-1: Save date entered for new owner list.}

  MainTable.FieldByName('DateEntered').AsDateTime := Date;

    {FXX08082002-1: Default personal property to zero so that it does not
                    end up as a garbage number.}

  MainTable.FieldByName('PersonalPropVal').AsFloat := 0;

end;  {MainTableNewRecord}

{===========================================================}
Procedure TSalesPageForm.EditEnter(Sender: TObject);

{Set the currency display to not have any commas or dollar sign for editing purpose.}
{FXX11162004-1(2.8.0.21): Don't go by currency flag - if numeric, set to numeric edit format.}

var
  TempField : TField;

begin
  TempField := MainTable.FieldByName(TDBEdit(Sender).DataField);

  with TempField do
    If IsNumericDataType(DataType)
      then TNumericField(TempField).DisplayFormat := CurrencyEditDisplay;

  TDBEdit(Sender).SelectAll;

end;  {EditEnter}

{===============================================================}
Procedure TSalesPageForm.EditExit(Sender: TObject);

{Change the currency field back to normal display format.}

var
  TempField : TField;

begin
  TempField := MainTable.FieldByName(TDBEdit(Sender).DataField);

  with TempField do
    If IsNumericDataType(DataType)
      then TNumericField(TempField).DisplayFormat := CurrencyDisplayNoDollarSign;

end;  {EditExit}

{==============================================================}
Procedure TSalesPageForm.MainTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in the Self var.}

var
  I : Integer;

begin
  If not FormIsInitializing
    then
      begin
          {save in case this is re-edit of (T)transmitted rec, so we can set to }
          {(R)correction on post}

        OriginalSalesStatusCode := Take(1, MainTable.FieldByName('SaleStatusCode').Text);

          {FXX10211997-2: Do not copy inventory records on modify.}

        If (MainTable.State = dsInsert)
          then SaleWasInserted := True
          else SaleWasInserted := False;

          {When the form first initialized, we set the text of the lookup boxes
           to match the values of the underlying fields. However, when they click
           insert, the text does not go away, so this clears it.}

           {FXX10241997-1: This should only be done if they are inserting
                           a record.}
           {FXX10241997-2: The default for arms length is unchecked and
                           the default for sale status is 'N' but this
                           clears out the 'N'.}

        If (MainTable.State = dsInsert)
          then
            For I := 1 to (ComponentCount - 1) do
              If ((Components[I] is TwwDBLookupCombo) and
                  (Components[I].Tag <> SlsStatus))
                then
                  with Components[I] as TwwDBLookupCombo do
                    Text := '';

        CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

          {CHG11211997-2: Show the parcel record update after insert.}

        If (MainTable.State = dsInsert)
          then
            begin
              MainTable.FieldByName('OldOwnerName').Text := Take(25, NYParcelTable.FieldByName('Name1').Text);
              OrigOldOwnerName := MainTable.FieldByName('OldOwnerName').Text;

                {FXX05112001-1: Not setting the extract fields for owner changes through sales or
                                tracing name changes in audit trail.}

              CreateFieldValuesAndLabels(Self, NYParcelTable, ParcelFieldTraceInformationList);

              If (NYParcelTable.State = dsBrowse)
                then
                  begin
                    OrigNameAddressBankCodeRec := GetNameAddressBankCodeInfo(NYParcelTable);

                    NYParcelTable.Edit;
                  end;

              PanelButtonPressed := False;
              NameAddressPanel.Visible := True;
              NameAddressPanel.Show;
              ParcelRecName1DBEdit.SetFocus;

            end
          else
            If (MessageDlg('Are you sure you want to edit this existing sale?',
                           mtConfirmation, [mbYes, mbNo], 0) = idNo)
              then MainTable.Cancel;

          {CHG02122000-3: Insert a name\addr audit change record.}

        OrigNameAddressRec := GetNameAddressInfo(NYParcelTable);

      end;  {If not FormIsInitializing}

end;  {MainTableAfterEdit}

{============================================================================}
Procedure TSalesPageForm.MainDataSourceDataChange(Sender: TObject;
                                                  Field: TField);

var
  SalesInventoryTabsExist : Boolean;
  I : Integer;

begin
  If ((not FormIsInitializing) and
      (Field = nil))
    then
      begin
        RefreshDropdownsAndLabels(Self, MainTable, DescriptionIndexedLookups);

        {First see if they have already brought the sales inventory tabs up for this
         parcel. If they have, then we will do nothing. To see if they have already brought
         up the sales inventory tabs, we will look through the TabTypeList for a SalesInventory
         entry. If we find any, then we know that they have already brought them up.}

        SalesInventoryTabsExist := False;

        try
          For I := 0 to (TabTypeList.Count - 1) do
            If (DetermineProcessingType(TabTypeList[I][1]) = SalesInventory)
              then SalesInventoryTabsExist := True;
        except
        end;

            {If they changed sites, delete the related site tabs for the previous site and
             add the ones for the present site. Note that this also gets called in the delete case,
             i.e if they delete a site, they have switched sites and this routine gets called. Note that
             if they deleted the last site, then we will not add the tabs back.}

        If (SalesNumber <> MainTable.FieldByName('SaleNumber').AsInteger)
          then
            begin
              SalesNumber := MainTable.FieldByName('SaleNumber').AsInteger;

              If SalesInventoryTabsExist
                then
                  begin
                    DeleteInventoryTabsForProcessingType(ParcelTabSet, TabTypeList, SalesInventory,
                                                         'R', True);
                    DeleteInventoryTabsForProcessingType(ParcelTabSet, TabTypeList, SalesInventory,
                                                         'C', True);

                    SalesInventoryButtonClick(Sender);

                  end;  {If SalesInventoryTabsExist}

            end;  {If (SalesNumber <> MainTableSalesNo.AsInteger)}

          {FXX06262001-2: Eliminate grayed check marks.}

        If (ArmsLengthCheckBox.State = cbGrayed)
          then ArmsLengthCheckBox.State := cbUnchecked;

        If (ValidityCheckBox.State = cbGrayed)
          then ValidityCheckBox.State := cbUnchecked;

        If TMemoField(MainTable.FieldByName('Notes')).IsNull
          then NotesButton.Font.Color := clBlack
          else NotesButton.Font.Color := clMaroon;

      end;  {If ((not InitializingForm) and ...}

end;  {MainDataSourceDataChange}

{====================================================================================}
Procedure TSalesPageForm.SalesInventoryButtonClick(Sender: TObject);

var
  LookupTable : TTable;

begin
  try
    LookupTable := TTable.Create(Self);
    LookupTable.DatabaseName := 'PASsystem';

    SetSalesInventoryTabsForParcel(ParcelTabSet, TabTypeList, LookupTable, SwisSBLKey,
                                   MainTable.FieldByName('SaleNumber').AsInteger,
                                   ResidentialSite, CommercialSite, CommBuildingNo,
                                   CommBuildingSection, NumResSites, NumComSites);

  finally
    LookupTable.Free;
  end;

end;  {SalesInventoryButtonClick}

{==============================================================}
Procedure TSalesPageForm.MainTableAfterDelete(DataSet: TDataset);

{After a delete, we should always reset the range.}

begin
  MainTable.DisableControls;
  MainTable.CancelRange;
  SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}
  MainTable.EnableControls;

    {FXX03031998-2: Set focus back to the first field after post, delete.}

  SetFocusToFirstField;

end;  {MainTableAfterDelete}

{======================================================================}
Procedure TSalesPageForm.AssessorChgEA5217DBEditKeyPress(    Sender: TObject;
                                                         var Key: Char);

{Check the EA flags as they enter them.}

var
  Found : Boolean;

begin
    {FXX10211997-3: Upcase the key.}

  Key := Upcase(Key);

  If (Key <> ' ')
    then
      begin
        Found := FindKeyOld(EA5217Table, ['MainCode'], [Key]);

        If not Found
          then
            begin
              MessageDlg('That was an invalid change code.' + #13 +
                         'The valid codes are C, D, and P.' + #13 +
                         'Please try again.', mtError, [mbOK], 0);
              Key := ' ';
              Abort;

            end;  {If not Found}

      end;  {If (Key <> ' ')}

end;  {AssessorChgEA5217DBEditKeyPress}

{======================================================================}
Procedure TSalesPageForm.ConditionsDBEditKeyPress(    Sender: TObject;
                                                  var Key: Char);

var
  Found : Boolean;

begin
    {FXX10211997-3: Upcase the key.}

  Key := Upcase(Key);

  If (Key <> ' ')
    then
      begin
        Found := FindKeyOld(ConditionTable, ['MainCode'], [Key]);

        If not Found
          then
            begin
              MessageDlg('That is an invalid condition code.' + #13 +
                         'The valid codes are A,B,C,D,E,F,G,H,I,J,R,S,T,U.' + #13 +
                         'Please try again.', mtError, [mbOK], 0);
              Key := ' ';
              Abort;

            end;  {If not Found}

      end;  {If (Key <> ' ')}

end;  {ConditionsDBEditKeyPress}

{===============================================================}
Procedure TSalesPageForm.SaleDateDBEditExit(Sender: TObject);

var
  Quit : Boolean;

begin
  ValidSale := True;

    {FXX05131999-2: Only do the following if the rec is in edit mode.}

  If (MainTable.State in [dsEdit, dsInsert])
    then
      begin
        If not FillInSalesInformation
          then
            begin
              ValidSale := False;
              MessageDlg('Either there is no information for this parcel on the' + #13 +
                         'last final roll or the sale is earlier than the history' + #13 +
                         'on the computer, so the sale will be marked invalid.' + #13 +
                         'The land and total assessed values are recorded as zero.',
                         mtWarning, [mbOK], 0);
              MainTable.FieldByName('ValidSale').AsBoolean := False;
              ValidityCheckBox.Checked := False;

            end;  {If not FillInSalesInformation}

          {FXX07191999-4: Make these events happen after the date is entered.}

          {CHG11211997-1: Default deed to type to bargain and
                          sale for arms length.}
          {CHG07191999-1: Allow municipality to choose which deed type is default.}
          {FXX04052001-1: We must make sure that the sales table is in edit or insert mode
                          before doing the following.}

        DeedTypeDBLookupCombo.Text := GlblDefaultDeedType;
        FindKeyOld(SalesDeedTypeTable, ['MainCode'], [GlblDefaultDeedType]);
        DeedTypeDesc.Caption := SalesDeedTypeTable.FieldByName('Description').Text;
        MainTable.FieldByName('DeedTypeCode').Text := DeedTypeDBLookupCombo.Text;
        MainTable.FieldByName('DeedTypeDesc').Text := DeedTypeDesc.Caption;

          {CHG12071998-1: Default sales type to 3 if av > land av}
          {If not yet open, default to NY.}

        If not AssessmentTable.Active
          then OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                                          NextYear, Quit);

        with AssessmentTable do
          If (FieldByName('TotalAssessedVal').AsFloat >
              FieldByName('LandAssessedVal').AsFloat)
            then
              begin
                SaleTypeDBLookupCombo.Text := '3';
                SaleTypeDesc.Caption := 'Land and Building';
              end
            else
              begin
                SaleTypeDBLookupCombo.Text := '1';
                SaleTypeDesc.Caption := 'Land Only';
              end;

        MainTable.FieldByName('SaleTypeCode').Text := SaleTypeDBLookupCombo.Text;
        MainTable.FieldByName('SaleTypeDesc').Text := SaleTypeDesc.Caption;

        MainTable.FieldByName('SaleStatusCode').Text := 'A';
        StatusCodeDBLookupCombo.Text := 'A';
        StatusCodeDBLookupCombo.Refresh;
        MainTable.FieldByName('SaleStatusDesc').Text := 'Complete, Xmit To State';
        SaleStatusDesc.Caption := MainTable.FieldByName('SaleStatusDesc').Text;

      end;  {If (MainTable.State in [dsEdit, dsInsert])}

end;  {SaleDateDBEditExit}

{===============================================================}
Procedure TSalesPageForm.OKButtonClick(Sender: TObject);

begin
    {CHG04022001-2: Check to see if there was an owner change.}

  If ((Take(25, ParcelRecName1DBEdit.Text) <>
       Take(25, OrigOldOwnerName)) or
      ((Take(25, ParcelRecName1DBEdit.Text) =
        Take(25, OrigOldOwnerName)) and
       (MessageDlg('Warning! It does not appear that the owner''s name was changed.' + #13 +
                  'Is this correct?', mtWarning, [mbYes, mbNo], 0) = idYes)))
    then
      begin
        MainTable.FieldByName('NewOwnerName').Text := ParcelRecName1DBEdit.Text;
        NameAddressPanel.Hide;
        PanelButtonPressed := True;

          {FXX11211997-6: Fix the tab order and flow.}

        If GlblSalesControlNumberRequired
          then ControlNumberEdit.SetFocus
          else NoParcelsDBEdit.SetFocus;

      end;  {If ((Take(25, ParcelRecName1DBEdit.Text) = ...}

end;  {OKButtonClick}

{==============================================================}
Procedure TSalesPageForm.CancelButtonClick(Sender: TObject);

begin
  ParcelTable.Cancel;

    {FXX12011998-11: Cancel the whole sale if they click cancel in parcel rec update.}

  MainTable.Cancel;
  NameAddressPanel.Hide;
  PanelButtonPressed := True;

    {FXX10241997-3: Refresh the name if they cancel the sale.}

  EditName.Refresh;

    {FXX11211997-6: Fix the tab order and flow.}

  If GlblSalesControlNumberRequired
    then ControlNumberEdit.SetFocus
    else NoParcelsDBEdit.SetFocus;

end;  {CancelButtonClick}

{==============================================================}
Procedure TSalesPageForm.NameAddressPanelExit(Sender: TObject);

begin
    {CHG10151997-2: Don't allow exit from name address panel unless
                    pressed button.}

  If not PanelButtonPressed
    then
      begin
        NameAddressPanel.Hide;
        NewOwnerDBEdit.Text := ParcelRecName1DBEdit.Text;
        NewOwnerDBEdit.Repaint;

      end;  {If not PanelButtonPressed}

end;  {NameAddressPanelExit}

{=====================================================================}
Procedure TSalesPageForm.EditKeyPress(    Sender: TObject;
                                      var Key: Char);

{FXX02221999-2: Prevent them from editing a sale unless they click edit on
                the navigator bar.}

begin
  If (MainTable.State in [dsBrowse])
    then
      begin
        MessageDlg('Please press the edit button on the navigator bar to edit an existing sale.',
                   mtError, [mbOK], 0);
        Key := #0;
        MainTable.Cancel;

      end;  {If (MainTable.State in [dsBrowse])}

end;  {EditKeyPress}

{======================================================================}
Procedure TSalesPageForm.StatusCodeDBLookupComboExit(Sender: TObject);

begin
   {on add or Edit , field can be only I or blank or A}
   {on edit , control is readonly anyway}

    {FXX10221997-2: 'N' is a valid code.}
    {FXX11211997-7: The sale status must be an 'A', 'I', or 'N' for insert.}

  If ((MainTable.State = dsInsert) and
      (not (Take(1, MainTable.FieldByName('SaleStatusCode').Text)[1] in ['A', 'I', 'N'])) and
      (Deblank(MainTable.FieldByName('SaleStatusCode').Text) <> ''))
    then
      begin
        MessageDlg('The sale status code must be ''A'', ''I'', or ''N''.',
                   mtError, [mbOK], 0);
        Abort;
      end;

    {FXX11211997-8: Edited sales must be either 'A', 'I', 'M', 'N', or 'R'.}

  If ((MainTable.State = dsEdit) and
      (not (Take(1, MainTable.FieldByName('SaleStatusCode').Text)[1] in ['A', 'M', 'N', 'I', 'R'])))
     then
       begin
         MessageDlg('The sale status code must be ''A'', ''I'', ''M''. ''N'', or ''R''.',
                    mtError, [mbOK], 0);
         Abort;
       end;

end;  {StatusCodeDBLookupComboExit}

{===============================================================}
Procedure TSalesPageForm.ArmsLengthCheckBoxClick(Sender: TObject);

{CHG10151997-2: Default sales code and validity flag based on
                value of arms length.}

{FXX10211997-1: If the status code is 'N', change to 'A' and vice-versa
                if they click.}

var
  Quit : Boolean;

begin
  If ((not FormIsInitializing) and
      (MainTable.State = dsInsert))
    then
      begin
        If ArmsLengthCheckBox.Checked
          then
            begin
              If ValidSale
                then
                  begin
                    ValidityCheckBox.Checked := True;
                    MainTable.FieldByName('ValidSale').AsBoolean := True;

                      {CHG02122004-2(2.07l1): Make editing simpler by skipping unused or seldom used fields.}

                    ConditionsDBEdit.SetFocus;

                  end;

            end
          else
            begin
                {FXX12171998-10: Non arms length sales should default to transmitted,
                                 also.}

              MainTable.FieldByName('ValidSale').AsBoolean := False;
              ValidityCheckBox.Checked := False;

            end;  {else of If ArmsLengthCheckBox.Checked}

      end;  {If ((not FormIsInitializing) and ...}

end;  {ArmsLengthCheckBoxClick}

{===============================================================}
Procedure TSalesPageForm.ConditionsDBEditExit(Sender: TObject);

{CHG02122004-2(2.07l1): Make editing simpler by skipping unused or seldom used fields.}

begin
    {FXX04182004-1(2.08): Make it so that this is a user option.}
    {CHG09122004-4(2.8.0.11): User option as to what sales field to go to after the condition code.}
    {CHG11162004-1(2.8.0.21): Add DeedDate as an option of the next field after condition.}

  case GlblNextSalesFieldAfterCondition of
    nsfDefault : If GlblSkipUnusedSalesFields
                   then OldOwnerDBEdit.SetFocus;

    nsfVerify : VerifyDBLookupCombo.SetFocus;
    nsfPersonalProperty : PersonalPropertyEdit.SetFocus;
    nsfAssessorChangeFlag : AssessorChgEA5217DBEdit.SetFocus;
    nsfOldOwner : OldOwnerDBEdit.SetFocus;
    nsfDeedBook : DeedBookDBEdit.SetFocus;
    nsfDeedType : DeedTypeDBLookupCombo.SetFocus;
    nsfDeedDate : DeedDateDBEdit.SetFocus;

  end;  {case GlblNextSalesFieldAfterCondition of}

end;  {ConditionsDBEditExit}

{===============================================================}
Procedure TSalesPageForm.DeedDateDBEditExit(Sender: TObject);

{CHG11162004-2(2.8.1.0)[1951]: Ask if they want to save after entering the deed date,
                               but only if they want to be prompted for save.}
{FXX12172004-3(2.8.1.4)[2030]: Don't autopost if the table is not in insert or edit mode.}

begin
  If (GlblAskSave and
      (MainTable.State <> dsBrowse))
    then MainTable.Post;

end;  {DeedDateDBEditExit}

{===============================================================}
Procedure TSalesPageForm.ParcelRecEditExit(Sender: TObject);

{CHG10211997-3: Captialize all entries in the parcel record and the owners.}

var
  FieldName : String;

begin
  with Sender as TDBEdit do
    begin
      FieldName := DataField;

      NYParcelTable.FieldByName(FieldName).Text := UpcaseStr(NYParcelTable.FieldByName(FieldName).Text);

    end;  {with Sender as TDBEdit do}

end;  {ParcelRecEditExit}

{===============================================================}
Procedure TSalesPageForm.OwnerEditExit(Sender: TObject);

{CHG10211997-3: Captialize all entries in the parcel record and the owners.}

var
  FieldName : String;

begin
    {FXX03041998-1: Because the focus is being set to the owner name
                    on entry, the on exit event is called when exit form
                    even if no changes made, so must check to see if in
                    insert or edit before trying to set NY parcel name.}

  If (MainTable.State in [dsEdit, dsInsert])
    then
      begin
        with Sender as TDBEdit do
          begin
            FieldName := DataField;

            MainTable.FieldByName(FieldName).Text := UpcaseStr(MainTable.FieldByName(FieldName).Text);

              {FXX08181999-2: I don't think that changes to new owner name should
                              carry to pg 1 - only from parcel record update.}

            (*If (TComponent(Sender).Name = 'NewOwnerDBEdit')
              then NYParcelTable.FieldByName('Name1').Text := Take(25, NewOwnerDBEdit.Text); *)

          end;  {with Sender as TDBEdit do}

      end;  { If (MainTable.State in [dsEdit, dsInsert])}

end;  {OwnerEditExit}

{================================================================}
Procedure TSalesPageForm.MainTableAfterCancel(DataSet: TDataset);

begin
    {FXX10241997-3: Refresh the name if they cancel the sale.}

  EditName.Refresh;

    {FXX11111997-7: Make sure to cancel the NY table edit.}

  NYParcelTable.Cancel;

end;  {MainTableAfterCancel}

{==============================================================}
Function TSalesPageForm.SaleAppliesToThisYear : Boolean;

{FXX07211999-4: If the sale is entered prior to final roll,
                automatically put on ThisYear also.}

begin
  Result := (Date <= AssessmentYearCtlTable.FieldByName('FinalRollDate').AsDateTime);
end;  {SaleAppliesToThisYear}

{==============================================================}
Procedure TSalesPageForm.MainTableBeforePost(DataSet: TDataset);

{If this is insert state, then fill in the SBL key and the
 tax roll year.}

var
  ReturnCode : Integer;
  IncompleteSale, Continue : Boolean;

begin
  Continue := True;

  If (MainTable.State in [dsEdit, dsInsert])
    then
      begin
          {They can only create a sale with blank, complete or incomplete
           status codes.}

           {FXX10221997-2: Allowed to save sales with status code 'N'.}
           {FXX07222003-1(2.07g): Make sure that sales can not be entered with blank status codes.}

        If ((MainTable.State = dsInsert) and
            (not (Take(1, MainTable.FieldByName('SaleStatusCode').Text)[1] in ['A', 'I', 'N'])))
          then
            begin
              MessageDlg('Only complete or incomplete sales can be created.',
                         mtError, [mbOK], 0);
              Continue := False;
           end;

        If Continue
          then
            begin
              MainTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);

                 {if in insert or edit mode and state is blank or A, }
                 {check for reqd fields and if all ok set status to A}
                 {...user should be allowed to reedit sale marked A}

                 {CHG10141997-2: Removed requirement for control number.
                                 Is an option on municipality basis.}

              If (Take(1, MainTable.FieldByName('SaleStatusCode').Text)[1] in [' ', 'A']) {A = complete}
                then
                  begin
                    IncompleteSale := False;

                      {FXX04081999-2: Make these warnings which set the sale to incomplete.}

                    If (GlblSalesControlNumberRequired and
                        (Deblank(MainTable.FieldByName('ControlNo').Text) = ''))
                      then
                        If (MessageDlg('The control number is blank.' + #13 +
                                      'If you save this sale it will be marked incomplete and' + #13 +
                                      'you must complete it later.' + #13 +
                                      'The sale will not be transmitted until the control number is entered.' + #13 +
                                      'Do you want to save anyway?',
                                      mtWarning, [mbYes, mbNo], 0) = idYes)
                          then IncompleteSale := True
                          else Continue := False;

                    If (Continue and
                        (Deblank(MainTable.FieldByName('NewOwnerName').Text) = ''))
                      then
                        If (MessageDlg('The new owner name is blank.' + #13 +
                                      'If you save this sale it will be marked incomplete and' + #13 +
                                      'you must complete it later.' + #13 +
                                      'The sale will not be transmitted until the new owner is entered.' + #13 +
                                      'Do you want to save anyway?',
                                      mtWarning, [mbYes, mbNo], 0) = idYes)
                          then IncompleteSale := True
                          else Continue := False;

                    If (Continue and
                        (Deblank(MainTable.FieldByName('OldOwnerName').Text) = ''))
                      then
                        If (MessageDlg('The old owner name is blank.' + #13 +
                                      'If you save this sale it will be marked incomplete and' + #13 +
                                      'you must complete it later.' + #13 +
                                      'The sale will not be transmitted until the old owner is entered.' + #13 +
                                      'Do you want to save anyway?',
                                      mtWarning, [mbYes, mbNo], 0) = idYes)
                          then IncompleteSale := True
                          else Continue := False;

                    If (Continue and
                        (Deblank(PriceDBEdit.Text) = ''))
                      then
                        If (MessageDlg('The sales price is blank.' + #13 +
                                      'If you save this sale it will be marked incomplete and' + #13 +
                                      'you must complete it later.' + #13 +
                                      'The sale will not be transmitted until the sales price is entered.' + #13 +
                                      'Do you want to save anyway?',
                                      mtWarning, [mbYes, mbNo], 0) = idYes)
                          then IncompleteSale := True
                          else Continue := False;

                       {FXX04081999-3: Add some other warnings.}

                    If (Continue and
                        (MainTable.FieldByName('SaleDate').AsDateTime > Date))
                      then
                        If (MessageDlg('The sales date is later than today.' + #13 +
                                       'Do you want to save anyway?',
                                       mtWarning, [mbYes, mbNo], 0) = idNo)
                          then Continue := False;

                    If (Continue and
                        (not GlblAllowBlankDeedDate) and
                        (MainTable.FieldByName('DeedDate').AsDateTime > Date))
                      then
                        If (MessageDlg('The deed date is later than today.' + #13 +
                                       'Do you want to save anyway?',
                                       mtWarning, [mbYes, mbNo], 0) = idNo)
                          then Continue := False;

                    If (Continue and
                        (Trim(MainTable.FieldByName('OldOwnerName').Text) = Trim(MainTable.FieldByName('NewOwnerName').Text)))
                      then
                        If (MessageDlg('The old owner and new owner are the same.' + #13 +
                                       'Do you want to save anyway?',
                                       mtWarning, [mbYes, mbNo], 0) = idNo)
                          then Continue := False;

                      {FXX07191999-5: Prevent dates from too long ago.}

                    If (Continue and
                        (MainTable.FieldByName('SaleDate').AsDateTime < StrToDate('1/1/1990')))
                      then
                        If (MessageDlg('The sales date is earlier than 1990.' + #13 +
                                       'Do you want to save anyway?',
                                       mtWarning, [mbYes, mbNo], 0) = idNo)
                          then Continue := False;

                      {CHG11162004-5(2.8.1.0)[1974]: Allow for a blank deed date.}

                    If (Continue and
                        (not GlblAllowBlankDeedDate) and
                        (MainTable.FieldByName('DeedDate').AsDateTime < StrToDate('1/1/1990')))
                      then
                        If (MessageDlg('The deed date is earlier than 1990.' + #13 +
                                       'Do you want to save anyway?',
                                       mtWarning, [mbYes, mbNo], 0) = idNo)
                          then Continue := False;

                       {FXX10221997-1: Sales price can be 0.}

                    If (Continue and
                        (MainTable.FieldByName('SalePrice').Value < 0))
                      then
                        begin
                          ReturnCode := MessageDlg('The sale price is less than 0.' + #13 +
                                                   'Do you wish to save this sale anyway?',
                                                   mtConfirmation,
                                                   [mbYes, mbNo, mbCancel], 0);

                          case ReturnCode of
                            idNo : If (MainTable.State = dsInsert)
                                     then
                                       begin
                                         MainTable.Cancel;
                                         Continue := False;
                                       end;

                            idCancel: Continue := False;

                          end; {end case}

                        end;  {If (Continue and ...}

                    If (Continue and
                        (Deblank(MainTable.FieldByName('SaleDate').Text) = ''))
                      then
                        If (MessageDlg('The sales date is blank.' + #13 +
                                       'If you save this sale it will be marked incomplete and' + #13 +
                                       'you must complete it later.' + #13 +
                                       'The sale will not be transmitted until the sales date is entered.' + #13 +
                                       'Do you want to save anyway?',
                                       mtWarning, [mbYes, mbNo], 0) = idYes)
                          then IncompleteSale := True
                          else Continue := False;

                    If (Continue and
                        (not GlblAllowBlankDeedDate) and
                        (Deblank(MainTable.FieldByName('DeedDate').Text) = ''))
                      then
                        If (MessageDlg('The deed date is blank.' + #13 +
                                       'If you save this sale it will be marked incomplete and' + #13 +
                                       'you must complete it later.' + #13 +
                                       'The sale will not be transmitted until the deed date is entered.' + #13 +
                                       'Do you want to save anyway?',
                                       mtWarning, [mbYes, mbNo], 0) = idYes)
                          then IncompleteSale := True
                          else Continue := False;

                       {CHG09132004-5(2.8.0.11): Don't check to make sure that the deed book and
                                                 page are filled in if they use the control number.}

                    If (Continue and
                        (not GlblUseControlNumInsteadOfBook_Page) and
                        (Deblank(MainTable.FieldByName('DeedBook').Text) = ''))
                      then
                        If (MessageDlg('The deed book is blank.' + #13 +
                                       'If you save this sale it will be marked incomplete and' + #13 +
                                       'you must complete it later.' + #13 +
                                       'The sale will not be transmitted until the deed book is entered.' + #13 +
                                       'Do you want to save anyway?',
                                       mtWarning, [mbYes, mbNo], 0) = idYes)
                          then IncompleteSale := True
                          else Continue := False;

                    If (Continue and
                        (not GlblUseControlNumInsteadOfBook_Page) and
                        (Deblank(MainTable.FieldByName('DeedPage').Text) = ''))
                      then
                        If (MessageDlg('The deed page is blank.' + #13 +
                                       'If you save this sale it will be marked incomplete and' + #13 +
                                       'you must complete it later.' + #13 +
                                       'The sale will not be transmitted until the deed page is entered.' + #13 +
                                       'Do you want to save anyway?',
                                       mtWarning, [mbYes, mbNo], 0) = idYes)
                          then IncompleteSale := True
                          else Continue := False;

                      {FXX05112001-1: If not arms length and no condition codes,
                                      warn.}

                    If (Continue and
                        (not MainTable.FieldByName('ArmsLength').AsBoolean) and
                        (Deblank(MainTable.FieldByName('SaleConditionCode').Text) = '') and
                        (MessageDlg('The sale is not arms length, but there are no condition codes.' + #13 +
                                    'Do you want to save anyway?',
                                    mtWarning, [mbYes, mbNo], 0) = idNo))
                       then Continue := False;

                      {CHG03062002-1: Warn if the deed date is less than the sale date.}

                    If (Continue and
                        (not GlblAllowBlankDeedDate) and
                        (MainTable.FieldByName('DeedDate').AsDateTime <
                         MainTable.FieldByName('SaleDate').AsDateTime) and
                        (MessageDlg('The deed date is earlier than the sale date.' + #13 +
                                    'Do you want to save anyway?',
                                    mtWarning, [mbYes, mbNo], 0) = idNo))
                      then Continue := False;

                      {FXX12091998-8: Any sale can be a complete sale for transmit.}

(*                    If (Continue and
                        (not ArmsLengthCheckBox.Checked))
                      then
                        begin
                          MessageDlg('Arms length must be checked for a completed sale.' ,
                                      mtError, [mbOK], 0);
                          Continue := False;
                        end; *)

                    If (Continue and
                        IncompleteSale)
                      then
                        begin
                          MainTable.FieldByName('SaleStatusCode').Text := 'I';
                          MainTable.FieldByName('SaleStatusDesc').Text := 'Incompleted Sale';

                            {FXX05131999-3: If the sale date is not filled in,
                                            make sure the assessment year is
                                            blank.}

                          If (Deblank(MainTable.FieldByName('SaleDate').Text) = '')
                            then MainTable.FieldByName('SaleAssessmentYear').Text := '';

                        end;  {If (Continue and ...}

                       {If passes all checks, mark sale as complete}

                    If (Continue and
                        (Deblank(MainTable.FieldByName('SaleStatusCode').Text) = ''))
                      then
                        begin
                          MainTable.FieldByName('SaleStatusCode').Text := 'A';
                          MainTable.FieldByName('SaleStatusDesc').Text := 'Completed Sale For XMIT Munic.';
                        end;

                  end  {If (Take(1, MainTableSaleStatusCode.Text) in [' ', 'A'])}
                else
                  begin
                      {Invalid sale or other status code.}

                    If (Deblank(MainTable.FieldByName('SaleConditionCode').Text) = '') and
                        ((not MainTable.FieldByName('ArmsLength').AsBoolean) or
                          (not MainTable.FieldByName('ValidSale').AsBoolean))
                      then
                        begin
                          ReturnCode := MessageDlg('Warning: The condition codes should be filled in ' + #13 +
                                                   'for invalid or non-arms length sales.' + #13 +
                                                   'Do you wish to save your changes?', mtConfirmation,
                                                   [mbYes, mbNo, mbCancel], 0);

                          case ReturnCode of
                            idNo : If (MainTable.State = dsInsert)
                                     then
                                       begin
                                         MainTable.Cancel;
                                         Continue := False;
                                       end;

                           idCancel: Abort;

                         end; {case ReturnCode of}

                       end;  {If (Deblank(MainTable.FieldByName('SaleCondition ...}

                    end;  {If (Take(1, MainTableSaleStatusCode ...}

            end;  {If Continue}

          {change a xmitted sale to a correction}

      If Continue
        then
          begin
            If (OriginalSalesStatusCode = 'T')
              then
                begin
                  MainTable.FieldByName('SaleStatusCode').Text := 'R';
                  MainTable.FieldByName('SaleStatusDesc').Text := 'Clerical/Reporting Correction';

                end;

              {Set the owner name.}
              {CHG10151997-1: Also set the parcel deed book and page.}
              {FXX10231997-1: The address and deed changes should go on NY.}

            If (NYParcelTable.State = dsEdit)
              then
                begin
                  NYParcelTable.FieldByName('Name1').Text := MainTable.FieldByName('NewOwnerName').Text;
                  NYParcelTable.FieldByName('DeedBook').Text := MainTable.FieldByName('DeedBook').Text;
                  NYParcelTable.FieldByName('DeedPage').Text := MainTable.FieldByName('DeedPage').Text;

                    {FXX02171999-7: Store the name address information to see if it changed.}

                  NewNameAddressBankCodeRec := GetNameAddressBankCodeInfo(NYParcelTable);

                  If NameAddressBankCodeDifferent(OrigNameAddressBankCodeRec,
                                                  NewNameAddressBankCodeRec)
                    then
                      begin
                        NYParcelTable.FieldByName('DateAddressChanged').AsDateTime := Date;
                        NYParcelTable.FieldByName('AddressExtracted').AsBoolean := False;

                          {FXX05112001-1: Not setting the extract fields for owner changes through sales or
                                          tracing name changes in audit trail.}

                        NYParcelTable.FieldByName('DateChangedForExtract').AsDateTime := Date;
                        NYParcelTable.FieldByName('ChangeExtracted').AsBoolean := False;

                      end;  {If NameAddressBankCodeDifferent(OrigNameAddressBankCodeRec, ...}

                  try
                    NYParcelTable.Post;
                  except
                    SystemSupport(008, NYParcelTable,
                                  'Error Posting NY Parcel Record.', UnitName, GlblErrorDlgBox);
                    Continue := False;
                  end;

                    {FXX07211999-4: If the sale is entered prior to final roll,
                                    automatically put on ThisYear also.}
                    {CHG03042000-1: Allow override of this and let them always
                                    apply name changes to TY and NY.}

                  If (SaleAppliesToThisYear or
                      GlblSalesApplyToThisYear)
                    then
                      with TYParcelTable do
                        try
                            {FXX02171999-7: Store the name address information to see if it changed.}

                          OrigNameAddressBankCodeRec := GetNameAddressBankCodeInfo(TYParcelTable);

                          Edit;
                          FieldByName('Name1').Text := MainTable.FieldByName('NewOwnerName').Text;
                          FieldByName('DeedBook').Text := MainTable.FieldByName('DeedBook').Text;
                          FieldByName('DeedPage').Text := MainTable.FieldByName('DeedPage').Text;

                          FieldByName('Name1').Text := NYParcelTable.FieldByName('Name1').Text;
                          FieldByName('Name2').Text := NYParcelTable.FieldByName('Name2').Text;
                          FieldByName('Address1').Text := NYParcelTable.FieldByName('Address1').Text;
                          FieldByName('Address2').Text := NYParcelTable.FieldByName('Address2').Text;
                          FieldByName('Street').Text := NYParcelTable.FieldByName('Street').Text;
                          FieldByName('City').Text := NYParcelTable.FieldByName('City').Text;
                          FieldByName('State').Text := NYParcelTable.FieldByName('State').Text;
                          FieldByName('Zip').Text := NYParcelTable.FieldByName('Zip').Text;
                          FieldByName('ZipPlus4').Text := NYParcelTable.FieldByName('ZipPlus4').Text;
                          FieldByName('BankCode').Text := NYParcelTable.FieldByName('BankCode').Text;

                            {FXX02171999-7: Store the name address information to see if it changed.}

                          NewNameAddressBankCodeRec := GetNameAddressBankCodeInfo(TYParcelTable);

                          If NameAddressBankCodeDifferent(OrigNameAddressBankCodeRec,
                                                          NewNameAddressBankCodeRec)
                            then
                              begin
                                FieldByName('DateAddressChanged').AsDateTime := Date;
                                FieldByName('AddressExtracted').AsBoolean := False;
                              end;

                          Post;
                        except
                          SystemSupport(008, TYParcelTable,
                                        'Error Posting NY Parcel Record.', UnitName, GlblErrorDlgBox);
                          Continue := False;
                        end;

                end;  {If (ParcelTable.State = dsEdit)}

              {FXX11021999-1: Put in an additional check to prevent no sales info.}

            If (Continue and
                (Deblank(MainTable.FieldByName('PropClass').Text) = ''))
              then FillInSalesInformation;

              {Set the sales last change name and date.}

            MainTable.FieldByName('LastChangeByName').Text := GlblUserName;
            MainTable.FieldByName('LastChangeDate').AsDateTime := Date;

              {FXX02021999-4: Refresh the parcel table so that the name in the
                              upper right is updated.}

            ParcelTable.Refresh;

          end;  {If Continue}

        {FXX05151998-3: Don't ask save on close form if don't want to see save.}

      If Continue
        then
          begin
            If GlblAskSave
              then
                begin
                    {FXX11061997-2: Remove the "save before exiting" prompt because it
                                    is confusing. Use only "Do you want to save.}

                  ReturnCode := MessageDlg('Do you wish to save your sales changes?', mtConfirmation,
                                                  [mbYes, mbNo, mbCancel], 0);

                  case ReturnCode of
                    idNo : If (MainTable.State = dsInsert)
                             then MainTable.Cancel
                             else RefreshNoPost(MainTable);

                    idCancel : Abort;

                  end;  {case ReturnCode of}

                end;  {If GlblAskSave}

          end
        else Abort;

    end;  {If (MainTable.State in [dsEdit, dsInsert])}

end;  {MainTableBeforePost}

{====================================================================}
Function ExCodeSubjectToChange(Excd : String): Boolean;

begin
  Result := True;
end;  {ExCodeSubjectToChange}

{==============================================================}
Function TSalesPageForm.SiteFound(TableName : String;
                                  SwisSBLKey : String;
                                  ProcessingType : Integer;
                                  TaxRollYr : String) : Boolean;


var
  TempTable : TTable;
  Quit : Boolean;

begin
  TempTable := TTable.Create(nil);
  TempTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  OpenTableForProcessingType(TempTable, TableName,
                             ProcessingType, Quit);

  try
    Result := FindKeyOld(TempTable, ['TaxRollYr', 'SwisSBLKey'],
                         [TaxRollYr, SwisSBLKey]);
  except
    SystemSupport(005, TempTable, 'Error getting residential site record.',
                  UnitName, GlblErrorDlgBox);
  end;

  TempTable.Close;
  TempTable.Free;

end;  {SiteFound}

{==============================================================}
Procedure TSalesPageForm.MainTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.}

const
  MaxNumExemptions = 5;

var
  I,J,K, ExIdx, ProcessingType : Integer;
  TempTaxRollYr : String;
  ExString : String;
  Done, Found,
  Quit, TYResSiteFound, TYComSiteFound,
  NYResSiteFound, NYComSiteFound : Boolean;
  ExemptionList : TStringList;

begin
  Quit := False;

      {FXX11101997-3: Pass the screen name into RecordChanges so
                      the screen names are more readable.}

  If (RecordChanges(Self, 'Sales', MainTable, ExtractSSKey(ParcelTable),
                    FieldTraceInformationList) > 0)
    then ParcelChanged := True;

    {If the sales code is 'A', i.e. completed, then we will see if
     the sales inventory exists already or not. If it does not,
     we will create it.}

    {FXX10211997-2: Do not copy inventory records on modify.}
    {FXX11211997-2: Always check exemptions, no matter what the sales
                    status code.}
    {FXX09201999-1: Problem with TaxRollYr var. - is messing up exemption display.}

  If SaleWasInserted
    then
      begin
          {FXX07301999-3: Test for inventory in NY and TY and decide based
                          on this which info to send.}

        TYResSiteFound := SiteFound(ResidentialSiteTableName, SwisSBLKey,
                                    ThisYear, GlblThisYear);
        TYComSiteFound := SiteFound(CommercialSiteTableName, SwisSBLKey,
                                    ThisYear, GlblThisYear);
        NYResSiteFound := SiteFound(ResidentialSiteTableName, SwisSBLKey,
                                    NextYear, GlblNextYear);
        NYComSiteFound := SiteFound(CommercialSiteTableName, SwisSBLKey,
                                    NextYear, GlblNextYear);

        TempTaxRollYr := '';

        If (NYResSiteFound or NYComSiteFound)
          then
            begin
              ProcessingType := NextYear;
              TempTaxRollYr := GlblNextYear;
            end;

        If (TYResSiteFound or TYComSiteFound)
          then
            begin
              ProcessingType := ThisYear;
              TempTaxRollYr := GlblThisYear;
            end;

          {FXX12301997-3: Was only recording sales inventory if there
                          weren't any sites.}

        If (Deblank(TempTaxRollYr) <> '')
          then RecordSalesInventory(ProcessingType, TempTaxRollYr);

          {FXX11111997-8: Move the exemption warning to after a sale is
                          posted.}

        ExemptionList := TStringList.Create;
        GetExemptionCodesForParcel(TaxRollYr, SwisSBLKey, ExemptionTable, ExemptionList);

        If (ExemptionList.Count > 0)
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
                         'applicability as a result of this sale:' + #13 + #13 +
                         ExString, mtWarning, [mbOK], 0);

            end;  {If (ExIdx > 1)}

        ExemptionList.Free;

          {CHG02122000-3: Insert a name\addr audit change record.}

        NewNameAddressRec := GetNameAddressInfo(NYParcelTable);
        InsertNameAddressTraceRecord(SwisSBLKey,
                                     OrigNameAddressRec,
                                     NewNameAddressRec);

          {FXX05112001-1: Not setting the extract fields for owner changes through sales or
                          tracing name changes in audit trail.}

        RecordChanges(Self, 'Base Information', NYParcelTable,
                      ExtractSSKey(ParcelTable),
                      ParcelFieldTraceInformationList);

      end;  {If (SaleStatusCode = 'A') ...}

    {FXX03031998-2: Set focus back to the first field after post.}

  SetFocusToFirstField;

end;  {MainTableAfterPost}

{=========================================================================}
Procedure TSalesPageForm.CopyRecordsForSale(    SourceTable,
                                                DestTable : TTable;
                                                TaxRollYear : String;
                                                SourceSwisSBLKey : String;
                                                SalesNumber : Integer;
                                            var Quit : Boolean);

{Copy all the inventory records for this inventory source table to the sales inventory
 DestTable.}

var
  FirstTimeThrough, FoundRec, Done : Boolean;
  I, J : Integer;
  FName : String;

begin
  FirstTimeThrough := True;
  Done := False;
  FoundRec := True;
  SourceTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

    {Find the first record for this SBL.}
    {FXX12151999-1: Had TaxRollYr instead of TaxRollYear and was causing FoundRec to
                    return false sometimes.}

  FoundRec := FindKeyOld(SourceTable, ['TaxRollYr', 'SwisSBLKey'],
                         [TaxRollYear, SourceSwisSBLKey]);

  If not FoundRec
    then Done := True;

  If not (Done or Quit)
    then
      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else SourceTable.Next;

          {If we are on a different parcel ID then the source, then
           we are done.}

          {FXX01232004-1(2.07): Need to trim the SBLs in case the suffix is blank.}

        If ((Trim(SourceTable.FieldByName('SwisSBLKey').Text) <> Trim(SourceSwisSBLKey)) or
            SourceTable.EOF)
          then Done := True;

          {If we got a record for this source parcel id ok, then we will copy it to all
           destination parcel id's.}

        If not (Done or Quit)
          then
            begin
              DestTable.Insert;

                {Loop through all the fields of the source table and copy them into
                 the destination table.}

              For J := 0 to (SourceTable.FieldCount - 1) do
                begin
                  FName := SourceTable.Fields[J].FieldName;

                    {FXX02142000-1: Date fields not copying correctly.}

                  If (DestTable.FieldByName(FName).DataType in [ftDateTime, ftDate, ftTime])
                    then
                      try
                        DestTable.FieldByName(FName).AsDateTime := SourceTable.FieldByName(FName).AsDateTime
                      except
                          {FXX04162001-1: If the date could not transfer, make sure it
                                          stays blank.}
                        DestTable.FieldByName(FName).Text := '';
                      end
                    else DestTable.FieldByName(FName).Text := SourceTable.FieldByName(FName).Text;

                end;  {For J := 0 to (SourceTable.FieldCount - 1) do}

                {Set the sales number.}

              TIntegerField(DestTable.FieldByName('SalesNumber')).AsInteger := SalesNumber;

              try
                DestTable.Post;
              except
                SystemSupport(006, DestTable, 'Error posting into table ' + DestTable.TableName,
                              UnitName, GlblErrorDlgBox);
              end;

            end;  {If not (Done or Quit)}

      until (Done or Quit);

end;  {CopyRecordsForSale}

{================================================================================}
Procedure TSalesPageForm.RecordSalesInventory(ProcessingType : Integer;
                                              TaxRollYr : String);

{Copy all inventory to the sales inventory files for this sale.}

var
  SourceTable, DestTable : TTable;
  Quit, RecordsAlreadyExist : Boolean;

begin
  Cursor := crHourGlass;
  StatusPanel.Visible := True;
  Quit := False;
  RecordsAlreadyExist := False;

  SourceTable := TTable.Create(Self);
  SourceTable.DatabaseName := 'PASsystem';
  DestTable := TTable.Create(Self);
  DestTable.DatabaseName := 'PASsystem';

    {FXX11161999-4: If the records already exist, do not copy them again.}

    {Check commercial inventory first.}

  OpenTableForProcessingType(DestTable, CommercialSiteTableName, SalesInventory, Quit);

  DestTable.IndexName := InventorySwisSBL_SalesNumberKey;
  FindNearestOld(DestTable, ['SwisSBLKey', 'SalesNumber'],
                 [SwisSBLKey, MainTable.FieldByName('SaleNumber').Text]);

  If ((Take(26, DestTable.FieldByName('SwisSBLKey').Text) = Take(26, SwisSBLKey)) and
      (DestTable.FieldByName('SalesNumber').AsInteger = MainTable.FieldByName('SaleNumber').AsInteger))
    then RecordsAlreadyExist := True;

    {Now check residential.}

  OpenTableForProcessingType(DestTable, ResidentialSiteTableName, SalesInventory, Quit);

  DestTable.IndexName := InventorySwisSBL_SalesNumberKey;
  FindNearestOld(DestTable, ['SwisSBLKey', 'SalesNumber'],
                 [SwisSBLKey, MainTable.FieldByName('SaleNumber').Text]);

  If ((Take(26, DestTable.FieldByName('SwisSBLKey').Text) = Take(26, SwisSBLKey)) and
      (DestTable.FieldByName('SalesNumber').AsInteger = MainTable.FieldByName('SaleNumber').AsInteger))
    then RecordsAlreadyExist := True;

  If not RecordsAlreadyExist
    then
      begin
           {COMMERCIAL}

        StatusPanel.Caption := 'Please wait... copying commercial site records for site to sales inventory.';
        StatusPanel.Repaint;

        If not Quit
          then
            begin
              OpenTableForProcessingType(SourceTable, CommercialSiteTableName, ProcessingType, Quit);
              OpenTableForProcessingType(DestTable, CommercialSiteTableName, SalesInventory, Quit);
            end;

        If not Quit
          then CopyRecordsForSale(SourceTable, DestTable, TaxRollYr, SwisSBLKey,
                                  MainTable.FieldByName('SaleNumber').AsInteger, Quit);

        StatusPanel.Caption := 'Please wait... copying commercial building records to sales inventory.';
        StatusPanel.Repaint;

        OpenTableForProcessingType(SourceTable, CommercialBldgTableName, ProcessingType, Quit);
        OpenTableForProcessingType(DestTable, CommercialBldgTableName, SalesInventory, Quit);

        If not Quit
          then CopyRecordsForSale(SourceTable, DestTable, TaxRollYr, SwisSBLKey,
                                  MainTable.FieldByName('SaleNumber').AsInteger, Quit);

        StatusPanel.Caption := 'Please wait... copying commercial land records to sales inventory.';
        StatusPanel.Repaint;

        If not Quit
          then
            begin
              OpenTableForProcessingType(SourceTable, CommercialLandTableName, ProcessingType, Quit);
              OpenTableForProcessingType(DestTable, CommercialLandTableName, SalesInventory, Quit);
            end;

        If not Quit
          then CopyRecordsForSale(SourceTable, DestTable, TaxRollYr, SwisSBLKey,
                                  MainTable.FieldByName('SaleNumber').AsInteger, Quit);

        StatusPanel.Caption := 'Please wait... copying commercial improvement records to sales inventory.';
        StatusPanel.Repaint;

        If not Quit
          then
            begin
              OpenTableForProcessingType(SourceTable, CommercialImprovementsTableName, ProcessingType, Quit);
              OpenTableForProcessingType(DestTable, CommercialImprovementsTableName, SalesInventory, Quit);
            end;

        If not Quit
          then CopyRecordsForSale(SourceTable, DestTable, TaxRollYr, SwisSBLKey,
                                  MainTable.FieldByName('SaleNumber').AsInteger, Quit);

        StatusPanel.Caption := 'Please wait... copying commercial income\expense records to sales inventory.';
        StatusPanel.Repaint;

        If not Quit
          then
            begin
              OpenTableForProcessingType(SourceTable, CommercialIncomeExpenseTableName, ProcessingType, Quit);
              OpenTableForProcessingType(DestTable, CommercialIncomeExpenseTableName, SalesInventory, Quit);
            end;

        If not Quit
          then CopyRecordsForSale(SourceTable, DestTable, TaxRollYr, SwisSBLKey,
                                  MainTable.FieldByName('SaleNumber').AsInteger, Quit);

        StatusPanel.Caption := 'Please wait... copying commercial rent records for site to sales inventory.';
        StatusPanel.Repaint;

        If not Quit
          then
            begin
              OpenTableForProcessingType(SourceTable, CommercialRentTableName, ProcessingType, Quit);
              OpenTableForProcessingType(DestTable, CommercialRentTableName, SalesInventory, Quit);
            end;

        If not Quit
          then CopyRecordsForSale(SourceTable, DestTable, TaxRollYr, SwisSBLKey,
                                  MainTable.FieldByName('SaleNumber').AsInteger, Quit);

          {RESIDENTIAL}

        StatusPanel.Caption := 'Please wait... copying residential building records to sales inventory.';
        StatusPanel.Repaint;

        OpenTableForProcessingType(SourceTable, ResidentialBldgTableName, ProcessingType, Quit);
        OpenTableForProcessingType(DestTable, ResidentialBldgTableName, SalesInventory, Quit);

        If not Quit
          then CopyRecordsForSale(SourceTable, DestTable, TaxRollYr, SwisSBLKey,
                                  MainTable.FieldByName('SaleNumber').AsInteger, Quit);

        StatusPanel.Caption := 'Please wait... copying residential forest records to sales inventory.';
        StatusPanel.Repaint;

        If not Quit
          then
            begin
              OpenTableForProcessingType(SourceTable, ResidentialForestTableName, ProcessingType, Quit);
              OpenTableForProcessingType(DestTable, ResidentialForestTableName, SalesInventory, Quit);
            end;

        If not Quit
          then CopyRecordsForSale(SourceTable, DestTable, TaxRollYr, SwisSBLKey,
                                  MainTable.FieldByName('SaleNumber').AsInteger, Quit);

        StatusPanel.Caption := 'Please wait... copying residential land records  to sales inventory.';
        StatusPanel.Repaint;

        If not Quit
          then
            begin
              OpenTableForProcessingType(SourceTable, ResidentialLandTableName, ProcessingType, Quit);
              OpenTableForProcessingType(DestTable, ResidentialLandTableName, SalesInventory, Quit);
            end;

        If not Quit
          then CopyRecordsForSale(SourceTable, DestTable, TaxRollYr, SwisSBLKey,
                                  MainTable.FieldByName('SaleNumber').AsInteger, Quit);

        StatusPanel.Caption := 'Please wait... copying residential improvement records to sales inventory.';
        StatusPanel.Repaint;

        If not Quit
          then
            begin
              OpenTableForProcessingType(SourceTable, ResidentialImprovementsTableName, ProcessingType, Quit);
              OpenTableForProcessingType(DestTable, ResidentialImprovementsTableName, SalesInventory, Quit);
            end;

        If not Quit
          then CopyRecordsForSale(SourceTable, DestTable, TaxRollYr, SwisSBLKey,
                                  MainTable.FieldByName('SaleNumber').AsInteger, Quit);


        StatusPanel.Caption := 'Please wait... copying residential site records for site to sales inventory.';
        StatusPanel.Repaint;

        If not Quit
          then
            begin
              OpenTableForProcessingType(SourceTable, ResidentialSiteTableName, ProcessingType, Quit);
              OpenTableForProcessingType(DestTable, ResidentialSiteTableName, SalesInventory, Quit);
            end;

        If not Quit
          then CopyRecordsForSale(SourceTable, DestTable, TaxRollYr, SwisSBLKey,
                                  MainTable.FieldByName('SaleNumber').AsInteger, Quit);

      end;  {If not RecordsAlreadyExist}

  SourceTable.Close;
  SourceTable.Free;
  DestTable.Close;
  DestTable.Free;

  StatusPanel.Visible := False;

end;  {RecordSalesInventory}

{==============================================================}
Procedure TSalesPageForm.NotesButtonClick(Sender: TObject);

{CHG02042004-2(2.08): Add notes to sales record.}

begin
  MemoDialog.Caption := 'Notes for sale #' + MainTable.FieldByName('SaleNumber').Text;
  MemoDialog.Execute;
end;  {NotesButtonClick}

{==============================================================}
Procedure TSalesPageForm.CloseButtonClick(Sender: TObject);

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
Procedure TSalesPageForm.FormCloseQuery(    Sender: TObject;
                                         var CanClose: Boolean);

var
  ReturnCode : Integer;

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
Procedure TSalesPageForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
    {Now, if the parcel changed, then update the parcel table.}

  If ParcelChanged
    then MarkRecChanged(NYParcelTable, UnitName);

    {Close all tables here.}

  CloseTablesForForm(Self);

  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));
  FreeTList(ParcelFieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

  Action := caFree;

end;  {FormClose}

{======================================================================}
Procedure TSalesPageForm.OwnerProgressionButtonClick(Sender: TObject);

begin
  try
    SalesOwnerProgressionForm := TSalesOwnerProgressionForm.Create(nil);
    SalesOwnerProgressionForm.InitializeForm(SwisSBLKey);
    SalesOwnerProgressionForm.ShowModal;
  finally
    SalesOwnerProgressionForm.Free;
  end;

end;  {OwnerProgressionButtonClick}

end.