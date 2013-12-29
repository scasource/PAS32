unit Rbldprpt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus,pastypes,
  GlblCnst,Types, RPFiler, RPBase, RPCanvas, RPrinter, RPDefine,
  Mask, TabNotBk, ComCtrls, ADODB, CheckLst;

type
  TBldgPermitReportForm = class(TForm)
    Panel2: TPanel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    LargeBuildingPermitTable: TwwTable;
    LargeBuildingDataSource: TwwDataSource;
    LargeBuildingPermitTableSwisCode: TStringField;
    LargeBuildingPermitTableSBL: TStringField;
    LargeBuildingPermitTableOwner: TStringField;
    LargeBuildingPermitTableLegalAddrNo: TStringField;
    LargeBuildingPermitTableLegalAddr: TStringField;
    LargeBuildingPermitTableApplicaNo: TStringField;
    LargeBuildingPermitTablePermitNo: TStringField;
    LargeBuildingPermitTablePermitDate: TDateField;
    LargeBuildingPermitTableProposedUse: TStringField;
    LargeBuildingPermitTableInspectorCode: TStringField;
    LargeBuildingPermitTableApplicaDate1: TDateField;
    LargeBuildingPermitTableApplicaDate2: TDateField;
    LargeBuildingPermitTableApplicaDate3: TDateField;
    LargeBuildingPermitTableApplicaDate4: TDateField;
    LargeBuildingPermitTableExperationDate: TDateField;
    LargeBuildingPermitTableContractor: TStringField;
    LargeBuildingPermitTableArchitect: TStringField;
    LargeBuildingPermitTablePermStatus: TStringField;
    LargeBuildingPermitTableApplFirstName: TStringField;
    LargeBuildingPermitTableApplLastName: TStringField;
    LargeBuildingPermitTableMailAddr1: TStringField;
    LargeBuildingPermitTableMailAddr2: TStringField;
    LargeBuildingPermitTableMailAddr3: TStringField;
    LargeBuildingPermitTableMailAddr4: TStringField;
    LargeBuildingPermitTablePhone: TStringField;
    LargeBuildingPermitTableZone: TStringField;
    LargeBuildingPermitTableStartedDate: TDateField;
    LargeBuildingPermitTableCompletedDate: TDateField;
    LargeBuildingPermitTableImproveType: TStringField;
    LargeBuildingPermitTablePermitType: TStringField;
    LargeBuildingPermitTableOwnership: TStringField;
    LargeBuildingPermitTableBaseCost: TFloatField;
    LargeBuildingPermitTableElecCost: TFloatField;
    LargeBuildingPermitTablePlumbCost: TFloatField;
    LargeBuildingPermitTableHVACCost: TFloatField;
    LargeBuildingPermitTableTotalCost: TFloatField;
    LargeBuildingPermitTableOtherCost1: TFloatField;
    LargeBuildingPermitTableOtherCost1Desc: TStringField;
    LargeBuildingPermitTableOtherCost2: TFloatField;
    LargeBuildingPermitTableOtherCost2Desc: TStringField;
    LargeBuildingPermitTableOtherCost3: TFloatField;
    LargeBuildingPermitTableOtherCost3Desc: TStringField;
    LargeBuildingPermitTableConstTypeExist: TStringField;
    LargeBuildingPermitTableConstTypeProp: TStringField;
    LargeBuildingPermitTableZoningPendingState: TDateField;
    LargeBuildingPermitTableZoningStatus: TStringField;
    LargeBuildingPermitTableZoningApprovalDate: TDateField;
    LargeBuildingPermitTableZoningVarianceNo: TStringField;
    LargeBuildingPermitTableZoningApprovalExm: TStringField;
    LargeBuildingPermitTableZoningDeniedDate: TDateField;
    LargeBuildingPermitTableZoningDeniedExm: TStringField;
    LargeBuildingPermitTablePrelimRvwPendingDate: TDateField;
    LargeBuildingPermitTablePrelimRvwStatus: TStringField;
    LargeBuildingPermitTablePrelimRvwApprovalDate: TDateField;
    LargeBuildingPermitTablePrelimRvwVarianceNo: TStringField;
    LargeBuildingPermitTablePrelimRvwApprovalExm: TStringField;
    LargeBuildingPermitTableDescription: TMemoField;
    LargeBuildingPermitTableApprovalDate: TDateField;
    LargeBuildingPermitTableAdjustedCost: TFloatField;
    LargeBuildingPermitTableArchReviewDate: TDateField;
    LargeBuildingPermitTableZoneReviewDate: TDateField;
    LargeBuildingPermitTableStateReviewDate: TDateField;
    LargeBuildingPermitTableBaseApplicationNo: TStringField;
    LargeBuildingPermitTableCertOccupancyDate: TDateField;
    LargeBuildingPermitTableCertOccupancyNumber: TStringField;
    LargeBuildingPermitTableCertComplianceDate: TDateField;
    LargeBuildingPermitTableCertComplianceNumber: TStringField;
    LargeBuildingPermitTableSpecialUsePermit: TBooleanField;
    LargeBuildingPermitTableAssessorNextInspDate: TDateField;
    LargeBuildingPermitTableAssessorOfficeClosed: TBooleanField;
    LargeBuildingPermitTableAssessorComments: TMemoField;
    LargeBuildingPermitTableAssessorFirstVisitDate: TDateField;
    LargeBuildingPermitTableAssessorSecondVisitDate: TDateField;
    LargeBuildingPermitTableAssessorTemp1: TStringField;
    LargeBuildingPermitTableAssessorTemp2: TStringField;
    LargeBuildingPermitTableAssessorTempDate1: TDateField;
    LargeBuildingPermitTableAssessorTempDate2: TDateField;
    LargeBuildingPermitTableNextInspDate: TDateField;
    LargeBuildingPermitTablePermInspDate1: TDateField;
    LargeBuildingPermitTablePermInspDate2: TDateField;
    LargeBuildingPermitTablePermInspDate3: TDateField;
    LargeBuildingPermitTablePermInspDate4: TDateField;
    LargeBuildingPermitTablePermInspDate5: TDateField;
    LargeBuildingPermitTablePermInspInspector1: TStringField;
    LargeBuildingPermitTablePermInspInspector2: TStringField;
    LargeBuildingPermitTablePermInspInspector3: TStringField;
    LargeBuildingPermitTablePermInspInspector4: TStringField;
    LargeBuildingPermitTablePermInspInspector5: TStringField;
    LargeBuildingPermitTablePermInspStatus1: TStringField;
    LargeBuildingPermitTablePermInspStatus2: TStringField;
    LargeBuildingPermitTablePermInspStatus3: TStringField;
    LargeBuildingPermitTablePermInspStatus4: TStringField;
    LargeBuildingPermitTablePermInspStatus5: TStringField;
    LargeBuildingPermitTablePermInspType1: TStringField;
    LargeBuildingPermitTablePermInspType2: TStringField;
    LargeBuildingPermitTablePermInspType3: TStringField;
    LargeBuildingPermitTablePermInspType4: TStringField;
    LargeBuildingPermitTablePermInspType5: TStringField;
    LargeBuildingPermitTableCloseDate: TDateField;
    LargeBuildingPermitTableInspTemplate: TStringField;
    LargeBuildingPermitTableParcelID: TStringField;
    LargeBuildingPermitTableApplicantName: TStringField;
    PermitStatusTable: TTable;
    SmallBuildingPermitTable: TwwTable;
    SmallBuildingDataSource: TwwDataSource;
    SmallBuildingPermitTableSwisSBLKey: TStringField;
    SmallBuildingPermitTableOwnerName: TStringField;
    SmallBuildingPermitTablePermitNumber: TStringField;
    SmallBuildingPermitTableApplicationNo: TStringField;
    SmallBuildingPermitTableVarianceNumber: TStringField;
    SmallBuildingPermitTableInspector: TStringField;
    SmallBuildingPermitTableIssueDate: TDateField;
    SmallBuildingPermitTableExpirationDate: TDateField;
    SmallBuildingPermitTableConstructionCost: TFloatField;
    SmallBuildingPermitTableConstructionCode: TStringField;
    SmallBuildingPermitTableCloseType: TStringField;
    SmallBuildingPermitTableCloseDate: TDateField;
    SmallBuildingPermitTableCONumber: TStringField;
    SmallBuildingPermitTableCloseingNotes: TMemoField;
    SmallBuildingPermitTableWorkDescription: TMemoField;
    SmallBuildingPermitTablePlumbingPermitNo: TStringField;
    SmallBuildingPermitTableElectPermitNo: TStringField;
    SmallBuildingPermitTableFileNo: TStringField;
    SmallBuildingPermitTableIsCommercial: TBooleanField;
    SmallBuildingPermitTableArchitectName: TStringField;
    SmallBuildingPermitTableArchitectAddr: TStringField;
    SmallBuildingPermitTableArchitectLicNo: TStringField;
    SmallBuildingPermitTableArchitectPhone: TStringField;
    SmallBuildingPermitTableBuildersName: TStringField;
    SmallBuildingPermitTableBuildersAddr: TStringField;
    SmallBuildingPermitTableBuildersLicNo: TStringField;
    SmallBuildingPermitTableBuildersPhone: TStringField;
    SmallBuildingPermitTableOwnersPhoneNo: TStringField;
    SmallBuildingPermitTableLocationInformation: TMemoField;
    SmallBuildingPermitTableElectriciansName: TStringField;
    SmallBuildingPermitTableElectriciansAddr: TStringField;
    SmallBuildingPermitTableElectriciansLicNo: TStringField;
    SmallBuildingPermitTableElectriciansPhoneNo: TStringField;
    SmallBuildingPermitTablePlumbersName: TStringField;
    SmallBuildingPermitTablePlumbersAddr: TStringField;
    SmallBuildingPermitTablePlumbersLicNo: TStringField;
    SmallBuildingPermitTablePlumbersPhoneNo: TStringField;
    SmallBuildingPermitTableAssessorComments: TMemoField;
    SmallBuildingPermitTableAssessorFirstVisitDate: TDateField;
    SmallBuildingPermitTableAssessorNextInspDate: TDateField;
    SmallBuildingPermitTableAssessorOfficeClosed: TBooleanField;
    SmallBuildingPermitTableAssessorSecondVisitDate: TDateField;
    SmallBuildingPermitTableParcelId: TStringField;
    ParcelTable: TTable;
    LargeBuildingPermitTableDoesNotExistInPASFlag: TStringField;
    SmallBuildingPermitTableDoesNotExistInPASFlag: TBooleanField;
    MunicityPermitQuery: TADOQuery;
    MunicityPermitStatusTable: TADOTable;
    tb_Sales: TTable;
    Panel1: TPanel;
    AsteriskLegendLabel: TLabel;
    lb_Asterisk: TLabel;
    PrintReportButton: TBitBtn;
    CloseButton: TBitBtn;
    MainPageControl: TPageControl;
    OptionsTabSheet: TTabSheet;
    PermitStatusRadioGroup: TRadioGroup;
    AssessorsOfficeStatusRadioGroup: TRadioGroup;
    SortOrderRadioGroup: TRadioGroup;
    PrintOptionsGroupBox: TGroupBox;
    PrintWorkDescriptionCheckBox: TCheckBox;
    PrintAssessorsNotesCheckBox: TCheckBox;
    PrintToExcelCheckBox: TCheckBox;
    DateGroupBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    AllDatesCheckBox: TCheckBox;
    ToEndofDatesCheckBox: TCheckBox;
    EndDateEdit: TMaskEdit;
    StartDateEdit: TMaskEdit;
    ApplyFilterButton: TBitBtn;
    ResultsTabSheet: TTabSheet;
    BuildingGridNotebook: TNotebook;
    LargeBuildingPermitGrid: TwwDBGrid;
    SmallBuildingPermitGrid: TwwDBGrid;
    qry_MunicityInspections: TADOQuery;
    tb_Assessment: TTable;
    tb_SwisCodes: TTable;
    cb_CreateParcelList: TCheckBox;
    qry_MunicityCertificates: TADOQuery;
    tbsMunicityPermitStatusAndType: TTabSheet;
    MunicityPermitStatusGroupBox: TGroupBox;
    MunicityPermitStatusCheckList: TCheckListBox;
    gbxMunicityPermitType: TGroupBox;
    clbxMunicityPermitTypes: TCheckListBox;
    adotbMunicityPermitTypes: TADOTable;
    cbxValidSalesOnly: TCheckBox;
    gbxCODates: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    cbAllCODates: TCheckBox;
    cbToEndOfCODates: TCheckBox;
    edCODateEnd: TMaskEdit;
    edCODateStart: TMaskEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure PrintReportButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure AllDatesCheckBoxClick(Sender: TObject);
    procedure ToEndofDatesCheckBoxClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LargeBuildingPermitTableCalcFields(DataSet: TDataSet);
    procedure ApplyFilterButtonClick(Sender: TObject);
    procedure LargeBuildingPermitTableFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure SortOrderRadioGroupClick(Sender: TObject);
    procedure SmallBuildingPermitTableCalcFields(DataSet: TDataSet);
    procedure SmallBuildingPermitTableFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure LargeBuildingPermitGridCalcCellColors(Sender: TObject;
      Field: TField; State: TGridDrawState; Highlight: Boolean;
      AFont: TFont; ABrush: TBrush);
    procedure OptionsItemClick(Sender: TObject);
    procedure cbAllCODatesClick(Sender: TObject);
    procedure cbToEndOfCODatesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ReportCancelled, PrintToExcel,
    OptionsChangesMade, bCreateParcelList : Boolean;
    PermitStatus, AssessorsOfficeStatus : Integer;
    PermitType : String;
    BuildingPermitTable : TTable;
    OpenPermitStatusCodesList, slPermitStatus, slPermitTypes : TStringList;
    PrintWorkDescription, PrintAssessorsNotes, bValidSalesOnly : Boolean;
    ExtractFile : TextFile;

    Procedure InitializeForm;  {Open the tables and setup.}
    Function PermitInDateRange(PermitDate : TDateTime): Boolean;
    Function LargeBuildingPermitInRange(BldgPermitTable :Ttable): Boolean;
    Function SmallBuildingPermitInRange(BldgPermitTable : TTable): Boolean;
  end;

{$R *.DFM}

implementation

uses GlblVars, WinUtils, Utilitys,PASUTILS, UTILEXSD, Prog, Preview,
     DataAccessUnit, DataModule, MunicityPermitReportPrintUnit, PrclList;

const
    {Permit status constants.}
  stOpen = 0;
  stClosed = 1;
  stEither = 2;

    {Display \ print order}

  soParcelID = 0;
  soPermitDate = 1;
  soPermitNumber = 2;
  soOwner = 3;

{========================================================}
Procedure TBldgPermitReportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TBldgPermitReportForm.InitializeForm;

var
  Quit, Done, FirstTimeThrough : Boolean;

begin
  slPermitStatus := TStringList.Create;
  slPermitTypes := TStringList.Create;
  OptionsChangesMade := False;
  UnitName := 'RBLDPRPT.PAS';  {mmm}
  OpenPermitStatusCodesList := TStringList.Create;

  tb_Sales.Open;

  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             NextYear, Quit);
  OpenTableForProcessingType(tb_Assessment, AssessmentTableName,
                             GlblProcessingType, Quit);
  OpenTableForProcessingType(tb_SwisCodes, SwisCodeTableName,
                             GlblProcessingType, Quit);

  tbsMunicityPermitStatusAndType.TabVisible := False;
  cbxValidSalesOnly.Visible := False;

  {CHG02192002-1: Hook up to all the different building departments.}

  case GlblBuildingSystemLinkType of

    //Small Building
    bldSmallBuilding :
      begin
        BuildingGridNotebook.PageIndex := 1;
        PermitStatusRadioGroup.Visible := True;
        MunicityPermitStatusGroupBox.Visible := False;
        MunicityPermitStatusCheckList.Visible := False;
        with SmallBuildingPermitTable do
          try
            DatabaseName := GlblBuildingSystemDatabaseName;
            TableName := GlblBuildingSystemTableName;
            IndexName := GlblBuildingSystemIndexName;
            Open;
          except
            MessageDlg('Error opening table ' + GlblBuildingSystemTableName +
                       ' in database ' + GlblBuildingSystemDatabaseName +
                       ' for index ' + GlblBuildingSystemIndexName + '.',
                       mtError, [mbOK], 0);
          end;
      end;  {bldSmallBuilding}

    //Large Building
    bldLargeBuilding :
      begin
        BuildingGridNotebook.PageIndex := 0;
        PermitStatusRadioGroup.Visible := True;
        MunicityPermitStatusGroupBox.Visible := False;
        MunicityPermitStatusCheckList.Visible := False;
        with LargeBuildingPermitTable do
          try
            DatabaseName := GlblBuildingSystemDatabaseName;
            TableName := GlblBuildingSystemTableName;
            IndexName := GlblBuildingSystemIndexName;
            Open;
          except
            MessageDlg('Error opening table ' + GlblBuildingSystemTableName +
                       ' in database ' + GlblBuildingSystemDatabaseName +
                       ' for index ' + GlblBuildingSystemIndexName + '.',
                       mtError, [mbOK], 0);
          end;
      end;  {bldLargeBuilding}

    //Municity
    bldMunicity :
      begin
        ApplyFilterButton.Visible := False;
        BuildingGridNotebook.Visible := False;
        ResultsTabSheet.Visible := False;
        ResultsTabSheet.TabVisible := False;
(*        TitleLabel.Caption := 'Building Permit Report'; *)
        self.Caption := 'Print Building Permits';

        PermitStatusRadioGroup.Visible := False;
        lb_Asterisk.Visible := False;
        AsteriskLegendLabel.Visible := False;
        tbsMunicityPermitStatusAndType.TabVisible := True;
        cbxValidSalesOnly.Visible := True;

      end;  {bldMunicity}

  end;  {case GlblBuildingSystemLinkType of}

    {Now get a list of the open statuses.}

  case GlblBuildingSystemLinkType of
    //bldLargeBuilding
    bldLargeBuilding :
      begin
        with PermitStatusTable do
          try
            DatabaseName := 'CodeEnforcement';
            TableName := 'PermitStatus';
            Open;
          except
            SystemSupport(001, PermitStatusTable, 'Error opening permit status table.',
                          UnitName, GlblErrorDlgBox);
          end;

        Done := False;
        FirstTimeThrough := True;
        PermitStatusTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else PermitStatusTable.Next;

          If PermitStatusTable.EOF
            then Done := True;

          If ((not Done) and
              (PermitStatusTable.FieldByName('OpenClosedNA').AsInteger = 1))
            then OpenPermitStatusCodesList.Add(PermitStatusTable.FieldByName('MainCode').Text);

        until Done;

      end;  {bldLargeBuilding}

    //bldMunicity
    bldMunicity :
     begin
        try
          if MunicityPermitStatusTable.Active then
            MunicityPermitStatusTable.Close;
          MunicityPermitStatusTable.ConnectionString := 'FILE NAME=' + GlblDrive + ':' + GlblProgramDir + 'pasMunicity.udl';
          MunicityPermitStatusTable.TableName := 'PermitStatus';
          MunicityPermitStatusTable.Open;
        except
          MessageDlg('Error opening Municity Permit Status table.',
                     mtError, [mbOK], 0);
        end;

        Done := False;
        FirstTimeThrough := True;
        MunicityPermitStatusTable.First;
        MunicityPermitStatusCheckList.Clear;
        MunicityPermitStatusCheckList.Items.Add('All');

        repeat
          If FirstTimeThrough
            Then FirstTimeThrough := False
            Else MunicityPermitStatusTable.Next;

          if MunicityPermitStatusTable.EOF
            then Done := True;

          IF (NOT Done) THEN
            MunicityPermitStatusCheckList.Items.Add(MunicityPermitStatusTable.FieldByName('MainCode').Text);

        until Done;

        if MunicityPermitStatusTable.Active then
        begin
          MunicityPermitStatusTable.First;
          MunicityPermitStatusTable.Close;
        end;

         {CHG03132009-1(2.17.1.8): Add an option to select permit types.}

        with adotbMunicityPermitTypes do
          begin
            try
              if Active then
                Close;
              ConnectionString := 'FILE NAME=' + GlblDrive + ':' + GlblProgramDir + 'pasMunicity.udl';
              TableName := 'PermitTypes';
              Open;
            except
              MessageDlg('Error opening Municity Permit Types table.',
                         mtError, [mbOK], 0);
            end;

            Done := False;
            FirstTimeThrough := True;
            First;
            clbxMunicityPermitTypes.Clear;
            clbxMunicityPermitTypes.Items.Add('All');

            repeat
              If FirstTimeThrough
                Then FirstTimeThrough := False
                Else Next;

              if EOF
                then Done := True;

              IF (NOT Done) THEN
                clbxMunicityPermitTypes.Items.Add(FieldByName('MainCode').Text);

            until Done;

            if Active then
            begin
              First;
              Close;
            end;

        end;  {with adotbMunicityPermitTypes do}

     end;  {bldMunicity}

  end;  {case GlblBuildingSystemLinkType of}

end;  {InitializeForm}

{===================================================================}
Procedure TBldgPermitReportForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{=========================================================================}
Procedure TBldgPermitReportForm.LargeBuildingPermitTableCalcFields(DataSet: TDataSet);

var
  SBLRec : SBLRecord;
  _Found : Boolean;
  TempSBL : String;

begin
  with LargeBuildingPermitTable do
    begin
      If (PASDataModule.TYSwisCodeTable.RecordCount = 1)
        then FieldByName('ParcelID').Text := ConvertSBLOnlyToDashDot(FieldByName('SBL').Text)
        else FieldByName('ParcelID').Text := ConvertSwisSBLToDashDot(FieldByName('SwisCode').Text +
                                                                     FieldByName('SBL').Text);
      FieldByName('ApplicantName').Text := Trim(FieldByName('ApplLastName').Text) + ',' +
                                           FieldByName('ApplFirstName').Text;

        {CHG11042003-1(2.07k): Mark the parcels that have permits that are not in PAS.}

        {FXX04262004-1(2.07l3): Convert back and forth between PAS and building in Glen Cove
                                due to incompatibilities in the format.}

      If GlblUseGlenCoveFormatForCodeEnforcement
        then TempSBL := ConvertFrom_GlenCoveTax_Building_To_PAS_SBL(FieldByName('SBL').Text)
        else TempSBL := FieldByName('SBL').Text;

      with LargeBuildingPermitTable do
        SBLRec := ExtractSwisSBLFromSwisSBLKey(FieldByName('SwisCode').Text + TempSBL);

      with SBLRec do
        _Found := FindKeyOld(ParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                              'Block', 'Lot', 'Sublot', 'Suffix'],
                              [GlblNextYear, SwisCode, Section, SubSection,
                               Block, Lot, Sublot, Suffix]);

      If _Found
        then FieldByName('DoesNotExistInPASFlag').Text := ''
        else FieldByName('DoesNotExistInPASFlag').Text := '*';

    end;  {with LargeBuildingPermitTable do}

end;  {LargeBuildingPermitTableCalcFields}

{===========================================================================}
Procedure TBldgPermitReportForm.LargeBuildingPermitGridCalcCellColors(Sender: TObject;
                                                                      Field: TField;
                                                                      State: TGridDrawState;
                                                                      Highlight: Boolean;
                                                                      AFont: TFont;
                                                                      ABrush: TBrush);

{CHG11042003-1(2.07k): Mark the parcels that have permits that are not in PAS.}

begin
  If (Field.FieldName = 'DoesNotExistInPASFlag')
    then
      begin
        AFont.Color := clRed;
        AFont.Size := 16;
        AFont.Style := [fsBold];
      end;  {If (Field.FieldName = 'InactiveParcel')}

end;  {LargeBuildingPermitGridCalcCellColors}

{===========================================================================}
Procedure TBldgPermitReportForm.SmallBuildingPermitTableCalcFields(DataSet: TDataSet);

var
  SBLRec : SBLRecord;
  _Found : Boolean;

begin
  with SmallBuildingPermitTable do
    begin
      FieldByName('ParcelID').Text := ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text);

      SBLRec := ExtractSwisSBLFromSwisSBLKey(FieldByName('SwisSBLKey').Text);

      with SBLRec do
        _Found := FindKeyOld(ParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                              'Block', 'Lot', 'Sublot', 'Suffix'],
                              [GlblNextYear, SwisCode, Section, SubSection,
                               Block, Lot, Sublot, Suffix]);

      If _Found
        then FieldByName('DoesNotExistInPASFlag').Text := ''
        else FieldByName('DoesNotExistInPASFlag').Text := '*';

    end;  {with SmallBuildingPermitTable do}

end;  {SmallBuildingPermitTableCalcFields}

{=========================================================================}
Procedure TBldgPermitReportForm.OptionsItemClick(Sender: TObject);

begin
  OptionsChangesMade := True;
end;

{===========================================================================}
Procedure TBldgPermitReportForm.AllDatesCheckBoxClick(Sender: TObject);

begin
  OptionsChangesMade := True;
  If AllDatesCheckBox.Checked
    then
      begin
        ToEndofDatesCheckBox.Checked := False;
        ToEndofDatesCheckBox.Enabled := False;
        StartDateEdit.Text := '';
        StartDateEdit.Enabled := False;
        StartDateEdit.Color := clBtnFace;
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(DateGroupBox);

end;  {AllDatesCheckBoxClick}

{===========================================================================}
Procedure TBldgPermitReportForm.ToEndofDatesCheckBoxClick(Sender: TObject);

begin
  OptionsChangesMade := True;
  If ToEndOfDatesCheckBox.Checked
    then
      begin
        EndDateEdit.Text := '';
        EndDateEdit.Enabled := False;
        EndDateEdit.Color := clBtnFace;
      end
    else
      begin
        EndDateEdit.Enabled := True;
        EndDateEdit.Color := clWindow;

      end;  {If ToEndOfDatesCheckBox.Checked}

end;  {ToEndofDatesCheckBoxClick}

{=====================================================================}
Procedure TBldgPermitReportForm.cbAllCODatesClick(Sender: TObject);

begin
  OptionsChangesMade := True;
  If cbAllCODates.Checked
    then
      begin
        cbToEndOfCODates.Checked := False;
        cbToEndOfCODates.Enabled := False;
        edCODateStart.Text := '';
        edCODateStart.Enabled := False;
        edCODateStart.Color := clBtnFace;
        edCODateEnd.Text := '';
        edCODateEnd.Enabled := False;
        edCODateEnd.Color := clBtnFace;
      end
    else EnableSelectionsInGroupBoxOrPanel(gbxCODates);

end;  {cbAllCODatesClick}

{=====================================================================}
Procedure TBldgPermitReportForm.cbToEndOfCODatesClick(Sender: TObject);

begin
  OptionsChangesMade := True;
  If cbToEndOfCODates.Checked
    then
      begin
        edCODateEnd.Text := '';
        edCODateEnd.Enabled := False;
        edCODateEnd.Color := clBtnFace;
      end
    else
      begin
        edCODateEnd.Enabled := True;
        edCODateEnd.Color := clWindow;

      end;  {If ToEndOfDatesCheckBox.Checked}

end;  {cbToEndOfCODatesClick}

{=====================================================================}
Function TBldgPermitReportForm.PermitInDateRange(PermitDate : TDateTime): Boolean;

begin
  Result := True;

  If not AllDatesCheckBox.Checked
    then
      begin
        try
          If (PermitDate < StrToDate(StartDateEdit.Text))
            then Result := False;
        except
          Result := False;
        end;

        try
          If ((not ToEndOfDatesCheckBox.Checked) and
              (PermitDate > StrToDate(EndDateEdit.Text)))
            then Result := False;
        except
          Result := False;
        end;

      end;  {If not AllDatesCheckBox.Checked}

end;  {PermitInDateRange}

{=====================================================================}
Function TBldgPermitReportForm.LargeBuildingPermitInRange(BldgPermitTable : TTable): Boolean;

begin
  Result := PermitInDateRange(BldgPermitTable.FieldByName('PermitDate').AsDateTime);

    {Check the permit status.}

  with BldgPermitTable do
    If Result
      then
        begin
          Result := False;

          case AssessorsOfficeStatus of
            stOpen : Result := not FieldByName('AssessorOfficeClosed').AsBoolean;
            stClosed : Result := FieldByName('AssessorOfficeClosed').AsBoolean;
            stEither : Result := True;

          end;  {case AssessorsOfficeStatus of}

          If Result
            then
              case PermitStatus of
                stOpen : Result := (OpenPermitStatusCodesList.IndexOf(FieldByName('PermStatus').Text) > -1);
                stClosed : Result := (OpenPermitStatusCodesList.IndexOf(FieldByName('PermStatus').Text) = -1);
                stEither : Result := True;

              end;  {If Result}

        end;  {If Result}

end;  {LargeBuildingPermitInRange}

{=====================================================================}
Function TBldgPermitReportForm.SmallBuildingPermitInRange(BldgPermitTable : TTable): Boolean;

begin
  Result := PermitInDateRange(BldgPermitTable.FieldByName('IssueDate').AsDateTime);

    {Check the permit status.}

  with BldgPermitTable do
    If Result
      then
        begin
          Result := False;

          case AssessorsOfficeStatus of
            stOpen : Result := not FieldByName('AssessorOfficeClosed').AsBoolean;
            stClosed : Result := FieldByName('AssessorOfficeClosed').AsBoolean;
            stEither : Result := True;

          end;  {case AssessorsOfficeStatus of}

          If Result
            then
              case PermitStatus of
                stOpen : Result := (Deblank(FieldByName('CloseType').Text) = '');
                stClosed : Result := (Deblank(FieldByName('CloseType').Text) <> '');
                stEither : Result := True;

              end;  {If Result}

        end;  {If Result}

end;  {SmallBuildingPermitInRange}

{===========================================================================}
Procedure TBldgPermitReportForm.LargeBuildingPermitTableFilterRecord(    DataSet: TDataSet;
                                                                     var Accept: Boolean);

begin
  Accept := LargeBuildingPermitInRange(LargeBuildingPermitTable);
end;  {LargeBuildingPermitTableFilterRecord}

{===========================================================================}
procedure TBldgPermitReportForm.SmallBuildingPermitTableFilterRecord(    DataSet: TDataSet;
                                                                     var Accept: Boolean);

begin
  Accept := SmallBuildingPermitInRange(SmallBuildingPermitTable);
end;

{===========================================================================}
Procedure TBldgPermitReportForm.ApplyFilterButtonClick(Sender: TObject);

begin
  OptionsChangesMade := False;

  If ((StartDateEdit.Text = '  /  /    ') and
       (EndDateEdit.Text = '  /  /    ') and
      (not (AllDatesCheckBox.Checked or
            ToEndofDatesCheckBox.Checked)))
    then AllDatesCheckBox.Checked := True;

  PermitStatus := PermitStatusRadioGroup.ItemIndex;
  AssessorsOfficeStatus := AssessorsOfficeStatusRadioGroup.ItemIndex;

  case GlblBuildingSystemLinkType of
    bldSmallBuilding :
      begin
        SmallBuildingPermitTable.DisableControls;
        SmallBuildingPermitTable.Filtered := False;

        Cursor := crHourglass;
        Application.ProcessMessages;
        SmallBuildingPermitTable.Filtered := True;
        SmallBuildingPermitTable.EnableControls;

        Cursor := crDefault;

      end;  {bldSmallBuilding :}

    bldLargeBuilding :
      begin
        LargeBuildingPermitTable.DisableControls;
        LargeBuildingPermitTable.Filtered := False;
        Cursor := crHourglass;
        Application.ProcessMessages;
        LargeBuildingPermitTable.Filtered := True;
        LargeBuildingPermitTable.EnableControls;

        Cursor := crDefault;

      end;  {bldLargeBuilding :}

    {bldMunicity : Not needed, because Apply Filter Button
                   is NOT visible for Municity}


    end;  {case GlblBuildingSystemLinkType of}

  MainPageControl.ActivePage := ResultsTabSheet;

end;  {ApplyFilterButtonClick}

{===========================================================================}
Procedure TBldgPermitReportForm.SortOrderRadioGroupClick(Sender: TObject);

begin
  OptionsChangesMade := True;
  case GlblBuildingSystemLinkType of
    bldSmallBuilding :
      with SmallBuildingPermitTable do
        case SortOrderRadioGroup.ItemIndex of
          soParcelID : IndexName := 'BYSWISSBLKEY';
          soPermitDate : IndexName := 'BYISSUEDATE';
          soPermitNumber : IndexName := 'BYPERMITNO';

        end;  {case SortOrderRadioGroup of}

    bldLargeBuilding :
      with LargeBuildingPermitTable do
        case SortOrderRadioGroup.ItemIndex of
          soParcelID : IndexName := 'BYSWISCODE_SBL';
          soPermitDate : IndexName := 'BYPERMITDATE';
          soPermitNumber : IndexName := 'BYPERMITNO';
          soOwner : IndexName := 'BYOWNER';

        end;  {case SortOrderRadioGroup of}

    bldMunicity :
      with MunicityPermitQuery do
        case SortOrderRadioGroup.ItemIndex of
          soParcelID : IndexName := 'Parcel_ID';
          soPermitDate : IndexName := 'PermitDate';
          soPermitNumber : IndexName := 'PermitNo';
          soOwner : IndexName := 'ParcelOwner';

        end;  {case SortOrderRadioGroup of}

  end;  {case GlblBuildingSystemLinkType of}

end;  {SortOrderRadioGroupClick}

{===========================================================================}
Procedure TBldgPermitReportForm.PrintReportButtonClick(Sender: TObject);

var
  SpreadsheetFileName, NewFileName : String;
  TempFile : File;
  Quit, bWideCarriage : Boolean;
  iX : Integer;

begin
  bValidSalesOnly := cbxValidSalesOnly.Checked;
  slPermitStatus.Clear;
  slPermitTypes.Clear;
  Quit := False;
  bCreateParcelList := cb_CreateParcelList.Checked;
  If bCreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

    {FXX06062005(2.8.4.8): If changes were made, but not applied, make sure to do them now.}

  IF ((GlblBuildingSystemLinkType = bldSmallBuilding) OR
      (GlblBuildingSystemLinkType = bldLargeBuilding)) THEN
        If OptionsChangesMade then ApplyFilterButtonClick(Sender);

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
        If ((StartDateEdit.Text = '  /  /    ') and
             (EndDateEdit.Text = '  /  /    ') and
            (not (AllDatesCheckBox.Checked or
                  ToEndofDatesCheckBox.Checked)))
          then AllDatesCheckBox.Checked := True;

        If ((edCODateStart.Text = '  /  /    ') and
             (edCODateEnd.Text = '  /  /    ') and
            (not (cbAllCODates.Checked or
                  cbToEndOfCODates.Checked)))
          then cbAllCODates.Checked := True;

        PermitStatus := PermitStatusRadioGroup.ItemIndex;
        AssessorsOfficeStatus := AssessorsOfficeStatusRadioGroup.ItemIndex;

        PrintWorkDescription := PrintWorkDescriptionCheckBox.Checked;
        PrintAssessorsNotes := PrintAssessorsNotesCheckBox.Checked;

        If (_Compare(GlblBuildingSystemLinkType, bldMunicity, coEqual) and
            (not MunicityPermitStatusCheckList.Checked[0]))
          then
            For iX := 0 to (MunicityPermitStatusCheckList.Items.Count - 2) do
              If MunicityPermitStatusCheckList.Checked[iX+1]
                then slPermitStatus.Add(MunicityPermitStatusCheckList.Items.Strings[iX+1]);

        If (_Compare(GlblBuildingSystemLinkType, bldMunicity, coEqual) and
            (not clbxMunicityPermitTypes.Checked[0]))
          then
            For iX := 0 to (clbxMunicityPermitTypes.Items.Count - 2) do
              If clbxMunicityPermitTypes.Checked[iX+1]
                then slPermitTypes.Add(clbxMunicityPermitTypes.Items.Strings[iX+1]);

          {CHG020122004-4(2.08): Option to print to Excel.}

        PrintToExcel := PrintToExcelCheckBox.Checked;

        If PrintToExcel
          then
            begin
              SpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(ExtractFile, SpreadsheetFileName);
              Rewrite(ExtractFile);

              case GlblBuildingSystemLinkType of

                //bldSmallBuilding
                bldSmallBuilding :
                  begin
                    Write(ExtractFile, 'Parcel ID,',
                                       'Owner,',
                                       'Legal Address,',
                                       'Permit #,',
                                       'Issue Date,',
                                       'Close Date,',
                                       'Inspector,',
                                       'Const Cost,',
                                       'Assr Status,',
                                       'Assr Next Insp Date');

                    If PrintWorkDescription
                      then Write(ExtractFile, ',Work Description');

                    If PrintAssessorsNotes
                      then Write(ExtractFile, ',Assessor Notes');

                    Writeln(ExtractFile);
                   end;  {bldSmallBuilding}

                //bldLargeBuilding
                bldLargeBuilding :
                  begin
                    Write(ExtractFile, 'Parcel ID,',
                                       'Owner,',
                                       'Legal Address,',
                                       'Permit #,',
                                       'Permit Date,',
                                       'Permit Status,',
                                       'Permit Type,',
                                       'Const Cost,',
                                       'Assr Status,',
                                       'Assr Next Insp Date');
                    If PrintWorkDescription
                      then Write(ExtractFile, ',Work Description');

                    If PrintAssessorsNotes
                      then Write(ExtractFile, ',Assessor Notes');

                    Writeln(ExtractFile);
                   end;  {bldLargeBuilding}

                // bldMunicity
                bldMunicity :
                  begin
                    WritelnCommaDelimitedLine(ExtractFile,
                                              ['Parcel ID',
                                               'Swis',
                                               'Section',
                                               'Subsection',
                                               'Block',
                                               'Lot',
                                               'Sublot',
                                               'Suffix',
                                               'Owner',
                                               'Legal Address',
                                               'Legal Addr #',
                                               'Legal Addr Street',
                                               'Permit #',
                                               'Permit Date',
                                               'Permit Status',
                                               'Permit Type',
                                               'Const Cost',
                                               'Last Insp Date',
                                               'C/O Date',
                                               'Current Value',
                                               'Full Mkt Value',
                                               'Last Sale Date',
                                               'Last Sale Price',
                                               'Description']);

(*                    If PrintWorkDescription
                      then Write(ExtractFile, ',Work Description');

                    If PrintAssessorsNotes
                      then Write(ExtractFile, ',Assessor Notes'); *)

                  end;  {bldMunicity}

              end;  {case GlblBuildingSystemLinkType of}

            end;  {If PrintToExcel}

          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        bWideCarriage := _Compare(GlblBuildingSystemLinkType, bldMunicity, coEqual);

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], bWideCarriage, Quit);

        ReportPrinter.Orientation := poLandscape;
        ReportFiler.Orientation := poLandscape;

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

        If not Quit
          then
            begin
              If PrintDialog.PrintToFile
                then
                  begin
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    ReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      ReportFiler.Execute;
                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;
                        {Now delete the file.}
                      try
                        AssignFile(TempFile, NewFileName);
                        OldDeleteFile(NewFileName);
                      finally
                        {We don't care if it does not get deleted, so we won't put up an
                         error message.}

                        ChDir(GlblProgramDir);
                      end;

                    end;  {If PrintRangeDlg.PreviewPrint}

                  end  {They did not select preview, so we will go
                        right to the printer.}
                else ReportPrinter.Execute;
            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

        if (MunicityPermitQuery.Active) then
        begin
          try
            MunicityPermitQuery.First;
            if (MunicityPermitQuery.RecordCount = 0) then MunicityPermitQuery.AppendRecord([' ']);
            MunicityPermitQuery.Close;
          except

          end;
        end;

        If bCreateParcelList
          then ParcelListDialog.Show;

        If PrintToExcel
          then
            begin
              CloseFile(ExtractFile);
              SendTextFileToExcelSpreadsheet(SpreadsheetFileName, True,
                                             False, '');
            end;  {If PrintToExcel}

      end;  {If PrintDialog.Execute}

end;  {PrintReportButtonClick}

{=====================================================================}
Procedure TBldgPermitReportForm.ReportPrintHeader(Sender: TObject);

begin
  If _Compare(GlblBuildingSystemLinkType, bldMunicity, coEqual)
    then PrintMunicityPermitReportHeader(Sender,
                                         StartDateEdit.Text,
                                         EndDateEdit.Text,
                                         AllDatesCheckBox.Checked,
                                         ToEndofDatesCheckBox.Checked)
    else
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
          SetFont('Times New Roman',12);
          Home;
          CRLF;
          Bold := True;
          PrintCenter('Building Permit Report', (PageWidth / 2));
          Bold := False;
          SetFont('Times New Roman', 12);
          CRLF;

          SectionTop := 1.4;

            {Print column headers.}

          Home;
          SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
          SetFont('Times New Roman', 10);
          Bold := True;

          case GlblBuildingSystemLinkType of
            bldSmallBuilding :
              begin
                ClearTabs;

                SetTab(0.5, pjCenter, 1.2, 0, BOXLINENone, 0);   {Parcel ID}
                SetTab(1.9, pjCenter, 1.4, 0, BOXLINENone, 0);   {name}
                SetTab(3.4, pjCenter, 1.5, 0, BOXLINENone, 0);   {Legal addr}
                SetTab(5.0, pjCenter, 0.7, 0, BOXLINENone, 0);   {Permit no}
                SetTab(5.8, pjCenter, 0.7, 0, BOXLINENone, 0);   {Issue date}
                SetTab(6.6, pjCenter, 0.7, 0, BOXLINENone, 0);   {Close Date}
                SetTab(7.4, pjCenter, 0.5, 0, BOXLINENone, 0);   {Inspector}
                SetTab(8.0, pjCenter, 0.7, 0, BOXLINENone, 0);   {Construction Cost}
                SetTab(8.8, pjCenter, 0.7, 0, BOXLINENone, 0);   {Assessor status}
                SetTab(9.6, pjCenter, 0.7, 0, BOXLINENone, 0);   {Next Insp Date}

                Println(#9 + #9 + #9 +
                        #9 + 'Permit' +
                        #9 + 'Issue' +
                        #9 + 'Close' +
                        #9 + '' +
                        #9 + 'Construct' +
                        #9 + 'Assessor' +
                        #9 + 'Next Insp');

                ClearTabs;

                SetTab(0.5, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {swis}
                SetTab(1.9, pjCenter, 1.4, 0, BOXLINEBOTTOM, 0);   {name}
                SetTab(3.4, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {Legal addr}
                SetTab(5.0, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Permit no}
                SetTab(5.8, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Permit date}
                SetTab(6.6, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Close Date}
                SetTab(7.4, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {Inspector}
                SetTab(8.0, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Construction Cost}
                SetTab(8.8, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Assessor status}
                SetTab(9.6, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Next Insp Date}

                Println(#9 + 'Parcel ID' +
                        #9 + 'Name' +
                        #9 + 'Legal Addr' +
                        #9 + 'Number' +
                        #9 + 'Date' +
                        #9 + 'Date' +
                        #9 + 'Insp' +
                        #9 + 'Cost' +
                        #9 + 'Status' +
                        #9 + 'Date');
                Println('');

                ClearTabs;
                Bold := False;
                SetTab(0.5, pjLeft, 1.2, 0, BOXLINENone, 0);   {swis}
                SetTab(1.9, pjLeft, 1.4, 0, BOXLINENone, 0);   {name}
                SetTab(3.4, pjLeft, 1.5, 0, BOXLINENone, 0);   {Legal addr}
                SetTab(5.0, pjLeft, 0.7, 0, BOXLINENone, 0);   {Permit no}
                SetTab(5.8, pjLeft, 0.7, 0, BOXLINENone, 0);   {Permit date}
                SetTab(6.6, pjLeft, 0.7, 0, BOXLINENone, 0);   {Close Date}
                SetTab(7.4, pjLeft, 0.5, 0, BOXLINENone, 0);   {Insp}
                SetTab(8.0, pjRight, 0.7, 0, BOXLINENone, 0);   {Construction Cost}
                SetTab(8.8, pjLeft, 0.7, 0, BOXLINENone, 0);   {Assessor status}
                SetTab(9.6, pjLeft, 0.7, 0, BOXLINENone, 0);   {Next Insp Date}

              end;  { bldSmallBuilding}

            bldLargeBuilding :
              begin
                ClearTabs;
                SetTab(0.5, pjLeft, 2.0, 0, BOXLINENone, 0);   {Does not exist}
                Println(#9 + '* = Parcel does not exist in PAS');

                ClearTabs;

                SetTab(0.3, pjCenter, 0.1, 0, BOXLINENone, 0);   {Does not exist}
                SetTab(0.5, pjCenter, 1.2, 0, BOXLINENone, 0);   {swis}
                SetTab(1.9, pjCenter, 1.4, 0, BOXLINENone, 0);   {name}
                SetTab(3.4, pjCenter, 1.5, 0, BOXLINENone, 0);   {Legal addr}
                SetTab(5.0, pjCenter, 0.7, 0, BOXLINENone, 0);   {Permit no}
                SetTab(5.8, pjCenter, 0.7, 0, BOXLINENone, 0);   {Permit date}
                SetTab(6.6, pjCenter, 0.7, 0, BOXLINENone, 0);   {Permit status}
                SetTab(7.4, pjCenter, 0.5, 0, BOXLINENone, 0);   {permit Type}
                SetTab(8.0, pjCenter, 0.7, 0, BOXLINENone, 0);   {Construction Cost}
                SetTab(8.8, pjCenter, 0.7, 0, BOXLINENone, 0);   {Assessor status}
                SetTab(9.6, pjCenter, 0.7, 0, BOXLINENone, 0);   {Next Insp Date}

                Println(#9 + #9 + #9 + #9 +
                        #9 + 'Permit' +
                        #9 + 'Permit' +
                        #9 + 'Permit' +
                        #9 + 'Permit' +
                        #9 + 'Construct' +
                        #9 + 'Assessor' +
                        #9 + 'Next Insp');

                ClearTabs;

                SetTab(0.3, pjCenter, 0.1, 0, BOXLINENone, 0);   {Does not exist}
                SetTab(0.5, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {swis}
                SetTab(1.9, pjCenter, 1.4, 0, BOXLINEBOTTOM, 0);   {name}
                SetTab(3.4, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {Legal addr}
                SetTab(5.0, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Permit no}
                SetTab(5.8, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Permit date}
                SetTab(6.6, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Permit status}
                SetTab(7.4, pjCenter, 0.5, 0, BOXLINEBOTTOM, 0);   {permit Type}
                SetTab(8.0, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Construction Cost}
                SetTab(8.8, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Assessor status}
                SetTab(9.6, pjCenter, 0.7, 0, BOXLINEBOTTOM, 0);   {Next Insp Date}

                Println(#9 +
                        #9 + 'Parcel ID' +
                        #9 + 'Name' +
                        #9 + 'Legal Addr' +
                        #9 + 'Number' +
                        #9 + 'Date' +
                        #9 + 'Status' +
                        #9 + 'Type' +
                        #9 + 'Cost' +
                        #9 + 'Status' +
                        #9 + 'Date');

                ClearTabs;
                Bold := False;
                SetTab(0.3, pjCenter, 0.1, 0, BOXLINENone, 0);   {Does not exist}
                SetTab(0.5, pjLeft, 1.2, 0, BOXLINENone, 0);   {swis}
                SetTab(1.9, pjLeft, 1.4, 0, BOXLINENone, 0);   {name}
                SetTab(3.4, pjLeft, 1.5, 0, BOXLINENone, 0);   {Legal addr}
                SetTab(5.0, pjLeft, 0.7, 0, BOXLINENone, 0);   {Permit no}
                SetTab(5.8, pjLeft, 0.7, 0, BOXLINENone, 0);   {Permit date}
                SetTab(6.6, pjLeft, 0.7, 0, BOXLINENone, 0);   {Permit status}
                SetTab(7.4, pjLeft, 0.5, 0, BOXLINENone, 0);   {permit Type}
                SetTab(8.0, pjRight, 0.7, 0, BOXLINENone, 0);   {Construction Cost}
                SetTab(8.8, pjLeft, 0.7, 0, BOXLINENone, 0);   {Assessor status}
                SetTab(9.6, pjLeft, 0.7, 0, BOXLINENone, 0);   {Next Insp Date}

              end;  {bldLargeBuilding}

          end;  {case GlblBuildingSystemLinkType of}

        end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==================================================================}
Procedure TBldgPermitReportForm.ReportPrint(Sender: TObject);

var
  _Found, Done, FirstTimeThrough : Boolean;
  LegalAddress, AssessorStat, sSwisSBLKey : String;
  Bookmark : TBookmark;
  RightMargin, LeftMargin : Double;
  LinesToPrint : Integer;
  SBLRec : SBLRecord;

begin
  Done := False;
  FirstTimeThrough := True;
  ReportCancelled := False;

  case GlblBuildingSystemLinkType of
    //bldSmallBuilding
    bldSmallBuilding :
      begin
        ProgressDialog.Start(SmallBuildingPermitTable.RecordCount, True, True);
        Bookmark := SmallBuildingPermitTable.GetBookmark;
        ApplyFilterButtonClick(Sender);
        SmallBuildingPermitTable.DisableControls;

        SmallBuildingPermitTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else SmallBuildingPermitTable.Next;

          If SmallBuildingPermitTable.EOF
            then Done := True;

          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SmallBuildingPermitTable.FieldByName('SwisSBLKey').Text));
          Application.ProcessMessages;
          If bCreateParcelList
            then ParcelListDialog.AddOneParcel(SmallBuildingPermitTable.FieldByName('SwisSBLKey').AsString);

          If not Done
            then
              with SmallBuildingPermitTable, Sender as TBaseReport do
                begin
                  LinesToPrint := 1;
                  LeftMargin := 2;
                  RightMargin := 10;

                  If (PrintWorkDescription and
                      (not TMemoField(SmallBuildingPermitTable.FieldByName('WorkDescription')).IsNull))
                    then LinesToPrint := LinesToPrint +
                                         GetMemoLineCountForMemoField(Sender,
                                                                      TMemoField(SmallBuildingPermitTable.FieldByName('WorkDescription')),
                                                                      LeftMargin, RightMargin);

                  If (PrintAssessorsNotes and
                      (not TMemoField(SmallBuildingPermitTable.FieldByName('AssessorComments')).IsNull))
                    then LinesToPrint := LinesToPrint +
                                         GetMemoLineCountForMemoField(Sender,
                                                                      TMemoField(SmallBuildingPermitTable.FieldByName('AssessorComments')),
                                                                      LeftMargin, RightMargin);

                  If ((LinesLeft - LinesToPrint) < 5)
                    then NewPage;

                  If FieldByName('AssessorOfficeClosed').AsBoolean
                    then AssessorStat := 'CLOSED'
                    else AssessorStat := 'OPEN';

                  SBLRec := ExtractSwisSBLFromSwisSBLKey(SmallBuildingPermitTable.FieldByName('SwisSBLKey').Text);

                  with SBLRec do
                    _Found := FindKeyOld(ParcelTable,
                                         ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                                          'Block', 'Lot', 'Sublot', 'Suffix'],
                                          [GlblNextYear, SwisCode, Section, SubSection,
                                           Block, Lot, Sublot, Suffix]);

                  If _Found
                    then LegalAddress := GetLegalAddressFromTable(ParcelTable)
                    else LegalAddress := '';

                    {CHG04012003-1(2.06r): Add more information to the report and allow for
                                           printing of work description and\or Assessor's notes.}

                  Println(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
                          #9 + Take(14, FieldByName('OwnerName').Text) +
                          #9 + Take(15, LegalAddress) +
                          #9 + FieldByName('PermitNumber').Text +
                          #9 + FieldByName('IssueDate').Text +
                          #9 + FieldByName('CloseDate').Text +
                          #9 + FieldByName('Inspector').Text +
                          #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                           FieldByName('ConstructionCost').AsFloat) +
                          #9 + AssessorStat +
                          #9 + FieldByName('AssessorNextInspDate').Text);

                  If (PrintWorkDescription and
                      (not TMemoField(SmallBuildingPermitTable.FieldByName('WorkDescription')).IsNull))
                    then
                      begin
                        Bold := True;
                        Print(#9 + '    Work Description: ');
                        Bold := False;
                        PrintMemoField(Sender, TMemoField(SmallBuildingPermitTable.FieldByName('WorkDescription')),
                                       LeftMargin, RightMargin, True);

                      end;  {If PrintWorkDescription}

                  If (PrintAssessorsNotes and
                      (not TMemoField(SmallBuildingPermitTable.FieldByName('AssessorComments')).IsNull))
                    then
                      begin
                        Bold := True;
                        Print(#9 + '    Assessor''s Notes: ');
                        Bold := False;
                        PrintMemoField(Sender, TMemoField(SmallBuildingPermitTable.FieldByName('AssessorComments')),
                                       LeftMargin, RightMargin, True);

                      end;  {If PrintWorkDescription}

                    {CHG020122004-4(2.08): Option to print to Excel.}

                  If PrintToExcel
                    then
                      begin
                        Write(ExtractFile, ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text),
                                           FormatExtractField(FieldByName('OwnerName').Text),
                                           FormatExtractField(LegalAddress),
                                           FormatExtractField(FieldByName('PermitNumber').Text),
                                           FormatExtractField(FieldByName('IssueDate').Text),
                                           FormatExtractField(FieldByName('CloseDate').Text),
                                           FormatExtractField(FieldByName('Inspector').Text),
                                           FormatExtractField(FormatFloat(NoDecimalDisplay_BlankZero,
                                                                          FieldByName('ConstructionCost').AsFloat)),
                                           FormatExtractField(AssessorStat),
                                           FormatExtractField(FieldByName('AssessorNextInspDate').Text));

                        If PrintWorkDescription
                          then Write(ExtractFile, FormatExtractField(FieldByName('WorkDescription').Text));

                        If PrintAssessorsNotes
                          then Write(ExtractFile, FormatExtractField(FieldByName('AssessorComments').Text));

                        Writeln(ExtractFile);

                      end;  {If PrintToExcel}

                end;  {with Sender as TBaseReport do}

        until (Done or ReportCancelled);

        ProgressDialog.Finish;

          {Go back to the original rec.}

        SmallBuildingPermitTable.GotoBookmark(Bookmark);
        SmallBuildingPermitTable.FreeBookmark(Bookmark);

        SmallBuildingPermitTable.EnableControls;

      end; {bldSmallBuilding}

    //bldLargeBuilding
    bldLargeBuilding :
      begin
        ProgressDialog.Start(LargeBuildingPermitTable.RecordCount, True, True);
        Bookmark := LargeBuildingPermitTable.GetBookmark;
        ApplyFilterButtonClick(Sender);
        LargeBuildingPermitTable.DisableControls;

        LargeBuildingPermitTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else LargeBuildingPermitTable.Next;

          If LargeBuildingPermitTable.EOF
            then Done := True;

          ProgressDialog.Update(Self, ConvertSBLOnlyToDashDot(LargeBuildingPermitTable.FieldByName('SBL').Text));
          Application.ProcessMessages;

          If bCreateParcelList
            then
              begin
                with LargeBuildingPermitTable do
                  sSwisSBLKey := FieldByName('SwisCode').AsString + FieldByName('SBL').AsString;
                ParcelListDialog.AddOneParcel(sSwisSBLKey);

              end;  {If bCreateParcelList}

          If not Done
            then
              with LargeBuildingPermitTable, Sender as TBaseReport do
                begin
                  LinesToPrint := 1;
                  LeftMargin := 2;
                  RightMargin := 10;

                  If (PrintWorkDescription and
                      (not TMemoField(LargeBuildingPermitTable.FieldByName('Description')).IsNull))
                    then LinesToPrint := LinesToPrint +
                                         GetMemoLineCountForMemoField(Sender,
                                                                      TMemoField(LargeBuildingPermitTable.FieldByName('Description')),
                                                                      LeftMargin, RightMargin);

                  If (PrintAssessorsNotes and
                      (not TMemoField(LargeBuildingPermitTable.FieldByName('AssessorComments')).IsNull))
                    then LinesToPrint := LinesToPrint +
                                         GetMemoLineCountForMemoField(Sender,
                                                                      TMemoField(LargeBuildingPermitTable.FieldByName('AssessorComments')),
                                                                      LeftMargin, RightMargin);

                  If ((LinesLeft - LinesToPrint) < 5)
                    then NewPage;

                  If FieldByName('AssessorOfficeClosed').AsBoolean
                    then AssessorStat := 'CLOSED'
                    else AssessorStat := 'OPEN';

                    {CHG11042003-1(2.07k): Mark the parcels that have permits that are not in PAS.}
                    {CHG04012003-1(2.06r): Add more information to the report and allow for
                                           printing of work description and\or Assessor's notes.}

                  Println(#9 + FieldByName('DoesNotExistInPASFlag').Text +
                          #9 + ConvertSwisSBLToDashDot(FieldByName('SwisCode').Text +
                                                       FieldByName('SBL').Text) +
                          #9 + Take(14, FieldByName('Owner').Text) +
                          #9 + Take(15, GetLegalAddressFromTable(LargeBuildingPermitTable)) +
                          #9 + FieldByName('PermitNo').Text +
                          #9 + FieldByName('PermitDate').Text +
                          #9 + FieldByName('PermStatus').Text +
                          #9 + Copy(FieldByName('PermitType').Text, 1, 7) +
                          #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                           FieldByName('TotalCost').AsFloat) +
                          #9 + AssessorStat +
                          #9 + FieldByName('AssessorNextInspDate').Text);

                  If (PrintWorkDescription and
                      (not TMemoField(LargeBuildingPermitTable.FieldByName('Description')).IsNull))
                    then
                      begin
                        Bold := True;
                        Print(#9 + '    Work Description: ');
                        Bold := False;
                        PrintMemoField(Sender, TMemoField(LargeBuildingPermitTable.FieldByName('Description')),
                                       LeftMargin, RightMargin, True);

                      end;  {If PrintWorkDescription}

                  If (PrintAssessorsNotes and
                      (not TMemoField(LargeBuildingPermitTable.FieldByName('AssessorComments')).IsNull))
                    then
                      begin
                        Bold := True;
                        Print(#9 + '    Assessor''s Notes: ');
                        Bold := False;
                        PrintMemoField(Sender, TMemoField(LargeBuildingPermitTable.FieldByName('AssessorComments')),
                                       LeftMargin, RightMargin, True);

                      end;  {If PrintWorkDescription}

                    {CHG020122004-4(2.08): Option to print to Excel.}
                  //Tammy
                  If PrintToExcel
                    then
                      begin
                        Write(ExtractFile, ConvertSwisSBLToDashDot(FieldByName('SwisCode').Text +
                                                                   FieldByName('SBL').Text),
                                           FormatExtractField(FieldByName('Owner').Text),
                                           FormatExtractField(GetLegalAddressFromTable(LargeBuildingPermitTable)),
                                           FormatExtractField(FieldByName('PermitNo').Text),
                                           FormatExtractField(FieldByName('PermitDate').Text),
                                           FormatExtractField(FieldByName('PermStatus').Text),
                                           FormatExtractField(FieldByName('PermitType').Text),
                                           FormatExtractField(FieldByName('TotalCost').Text),
                                           FormatExtractField(AssessorStat),
                                           FormatExtractField(FieldByName('AssessorNextInspDate').Text));


                        If PrintWorkDescription
                          then Write(ExtractFile, FormatExtractField(FieldByName('Description').Text));

                        If PrintAssessorsNotes
                          then Write(ExtractFile, FormatExtractField(FieldByName('AssessorComments').Text));

                        Writeln(ExtractFile);

                      end;  {If PrintToExcel}

                end;  {with Sender as TBaseReport do}

          ReportCancelled := ProgressDialog.Cancelled;

        until (Done or ReportCancelled);

        ProgressDialog.Finish;

          {Go back to the original rec.}

        LargeBuildingPermitTable.GotoBookmark(Bookmark);
        LargeBuildingPermitTable.FreeBookmark(Bookmark);

        LargeBuildingPermitTable.EnableControls;

      end;  {bldLargeBuilding}

      bldMunicity :
        PrintMunicityPermitReport(ExtractFile,
                                  Sender,
                                  Self,
                                  ProgressDialog,
                                  MunicityPermitQuery,
                                  qry_MunicityInspections,
                                  qry_MunicityCertificates,
                                  tb_Sales,
                                  tb_Assessment,
                                  ParcelTable,
                                  tb_SwisCodes,
                                  slPermitStatus,
                                  slPermitTypes,
                                  AssessorsOfficeStatusRadioGroup.ItemIndex,
                                  AllDatesCheckBox.Checked,
                                  ToEndofDatesCheckBox.Checked,
                                  StartDateEdit.Text,
                                  EndDateEdit.Text,
                                  cbAllCODates.Checked,
                                  cbToEndOfCODates.Checked,
                                  edCODateStart.Text,
                                  edCODateEnd.Text,
                                  SortOrderRadioGroup.ItemIndex, '',
                                  PrintToExcel,
                                  bCreateParcelList,
                                  bValidSalesOnly,
                                  True);

  end;  {case GlblBuildingSystemLinkType of}

end;  {ReportPrint}

{===================================================================}
Procedure TBldgPermitReportForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TBldgPermitReportForm.FormClose(    Sender: TObject;
                                          var Action: TCloseAction);

begin
  slPermitStatus.Free;
  slPermitTypes.Free;
  CloseTablesForForm(Self);
  OpenPermitStatusCodesList.Free;
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

{===================================================================}



end.