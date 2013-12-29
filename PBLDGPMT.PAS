unit Pbldgpmt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, (*BseMain, BtrMain, *)ComCtrls, wwriched,
  wwrichedspell;

type
  TBldgPermitForm = class(TForm)
    BigBuildingDataSource: TwwDataSource;
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
    InactiveLabel: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    BigBuildingPermitTable: TTable;
    PermitNotebook: TNotebook;
    Label3: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label11: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label18: TLabel;
    Label22: TLabel;
    ApplicationNoDBEdit: TDBEdit;
    PermitNoDBEdit: TDBEdit;
    PermitTypeEdit: TDBEdit;
    PermitDateEdit: TDBEdit;
    ProposedUseDBEdit: TDBEdit;
    ImproveTypeDBEdit: TDBEdit;
    ConstructionEndDateDBEdit: TDBEdit;
    TotalCostEdit: TDBEdit;
    ContstrStartDBEdit: TDBEdit;
    StatusDBEdit: TDBEdit;
    CCDateDBEdit: TDBEdit;
    EditVisitDate2: TDBEdit;
    EditNextInspectionDate: TDBEdit;
    EditVisitDate1: TDBEdit;
    ApplicationDateEdit: TDBEdit;
    ClosedAssessmentCheckBox: TDBCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label29: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    EditSmallApplicationNumber: TDBEdit;
    EditSmallPermitNumber: TDBEdit;
    EditSmallIssueDate: TDBEdit;
    EditSmallInspector: TDBEdit;
    EditSmallConstructionCode: TDBEdit;
    EditSmallCloseType: TDBEdit;
    EditConstructionCost: TDBEdit;
    EditSmallCloseDate: TDBEdit;
    EditCONumber: TDBEdit;
    EditSmallAssessorsVisitDate2: TDBEdit;
    EditSmallAssessorsNextInspectionDate: TDBEdit;
    EditSmallAssessorsVisitDate1: TDBEdit;
    EditSmallAssessorsClosed: TDBCheckBox;
    EditSmallWorkDescription: TwwDBRichEdit;
    SmallBuildingPermitTable: TTable;
    SmallBuildingPermitDataSource: TDataSource;
    Label27: TLabel;
    EditCODate_Number: TEdit;
    DBRichEdit1: TDBRichEdit;
    DBRichEdit2: TDBRichEdit;
    DBRichEdit3: TDBRichEdit;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure BigBuildingPermitTableAfterScroll(DataSet: TDataSet);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr : String;
    SwisSBLKey : String;

        {These var.'s are for tracing changes.}

    FieldValuesList,
    FieldLabelsList : TStringList;

    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}

      {Have there been any changes?}

    ParcelChanged : Boolean;

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
      {because these routines are placed at the form object def. level,}
      {they have access to all variables on form (no need to Var in)   }
    Procedure InitializeForm;
(*    Procedure SetRangeForBldgPermitFile(Table : TtbTable);*)

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst;


{$R *.DFM}

{=====================================================================}
Procedure TBldgPermitForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{=====================================================================}
Procedure TBldgPermitForm.InitializeForm;

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
  ProcessingType : Integer;
  TempSBL : String;

begin
  UnitName := 'PBLDGPMT';  {mmm1}
  ParcelChanged := False;
  ClosingForm := False;
  FormIsInitializing := True;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If ((not ModifyAccessAllowed(FormAccessRights)) or
            (EditMode = 'V'))
          then
            begin
              BigBuildingPermitTable.ReadOnly := True;
              SmallBuildingPermitTable.ReadOnly := True;
            end;

          {First let's find this parcel in the parcel table.}
          {FXX03282000-1: Fix up building permit processing.}

        ProcessingType := GetProcessingTypeForTaxRollYear(TaxRollYr);

        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   ProcessingType, Quit);

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                               'Block', 'Lot', 'Sublot', 'Suffix'],
                               [TaxRollYr, SwisCode, Section, SubSection,
                                Block, Lot, Sublot, Suffix]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Set the range.}

        case GlblBuildingSystemLinkType of
(*          bldBTrieve :
            begin
              try
                MainTable.Open;
              except
                MessageDlg('Error opening permits table.', mtError, [mbOK], 0);
              end;

              SetRangeForBldgPermitFile(MainTable);  {special for permit fileonly}

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

            end;  {bldBTrieve} *)

          bldLargeBuilding :
            begin
              Navigator.DataSource := BigBuildingDataSource;
              PermitNotebook.PageIndex := 1;

              with BigBuildingPermitTable do
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

              try
                  {FXX04262004-1(2.07l3): Convert back and forth between PAS and building in Glen Cove
                                          due to incompatibilities in the format.}

                If GlblUseGlenCoveFormatForCodeEnforcement
                  then TempSBL := ConvertFrom_PAS_To_GlenCoveTax_Building_SBL(Copy(SwisSBLKey, 7, 20))
                  else TempSBL := Copy(SwisSBLKey, 7, 20);

                SetRangeOld(BigBuildingPermitTable, ['SwisCode', 'SBL'],
                            [Copy(SwisSBLKey, 1, 6), TempSBL],
                            [Copy(SwisSBLKey, 1, 6), TempSBL]);
               except
                 SystemSupport(109, BigBuildingPermitTable, 'Error setting range on building table.',
                               UnitName, GlblErrorDlgBox);
               end;

                {Now, for some reason the table is marked as
                 Modified after we do a set range in modify mode.
                 So, we will cancel the modify and set it in
                 the proper mode.}

               If ((not BigBuildingPermitTable.ReadOnly) and
                   (EditMode = 'M'))
                 then
                   begin
                     BigBuildingPermitTable.Edit;
                     BigBuildingPermitTable.Cancel;
                   end;

            end;  {bldLargeBuilding}

          bldSmallBuilding :
            begin
              Navigator.DataSource := SmallBuildingPermitDataSource;
              PermitNotebook.PageIndex := 0;

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

              SetRangeOld(SmallBuildingPermitTable, ['SwisSBLKey'],
                          [SwisSBLKey], [SwisSBLKey]);

                {Now, for some reason the table is marked as
                 Modified after we do a set range in modify mode.
                 So, we will cancel the modify and set it in
                 the proper mode.}

              If ((not SmallBuildingPermitTable.ReadOnly) and
                  (EditMode = 'M'))
                then
                  begin
                    SmallBuildingPermitTable.Edit;
                    SmallBuildingPermitTable.Cancel;
                  end;

            end;  {bldLargeBuilding}

        end;  {case GlblBuildingSystemLinkType of}

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

        YearLabel.Caption := GetTaxYrLbl;

          {Set the SBL in the SBL edit so that it is visible.
           Note that it is not data aware since if there are
           no Assessment records, we have nothing to get the SBL from.}

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

      end;  {If (Deblank(SwisSBLKey) <> '')}

  FormIsInitializing := False;

end;  {InitializeForm}

{==============================================================}
Procedure TBldgPermitForm.BigBuildingPermitTableAfterScroll(DataSet: TDataSet);

begin
    {CHG02052006-2(2.9.5.4): Display the CO #.  So that it would fit, I
                             combined it with the CO date.}

  with BigBuildingPermitTable do
    If _Compare(FieldByName('CertOccupancyDate').Text, coBlank)
      then EditCODate_Number.Text := ''
      else EditCODate_Number.Text := FieldByName('CertOccupancyDate').Text + '\' +
                                     FieldByName('CertOccupancyNumber').Text;

end;  {BigBuildingPermitTableAfterScroll}

{==============================================================}
Procedure TBldgPermitForm.CloseButtonClick(Sender: TObject);

{Note that the close button is a close for the whole
 parcel maintenance.}

{To close the whole parcel maintenance, we will once again use
 the base popup menu. We will simulate a click on the
 "Exit Parcel Maintenance" of the BasePopupMenu which will
 then call the Close of ParcelTabForm. See the locate button
 click above for more information on how this works.}

var
  I : Integer;

begin
    {Search for the name of the menu item that has "Exit"
     in it, and click it.}

  For I := 0 to (PopupMenu.Items.Count - 1) do
    If (Pos('Exit', PopupMenu.Items[I].Name) <> 0)
      then PopupMenu.Items[I].Click;

end;  {CloseButtonClick}

{====================================================================}
Procedure TBldgPermitForm.FormCloseQuery(    Sender: TObject;
                                         var CanClose: Boolean);

begin
  CanClose := True;
  GlblParcelPageCloseCancelled := False;
  ClosingForm := True;

    {First see if anything needs to be saved. In order to
     determine if there are any changes, we need to sychronize
     the fields with what is in the DB edit boxes. To do this,
     we call the UpdateRecord. Then, if there are any changes,
     the Modified flag will be set to True.}

  case GlblBuildingSystemLinkType of
(*    bldBTrieve :
      begin
        If (MainTable.State in [dsInsert, dsEdit])
          then MainTable.UpdateRecord;

          {Now, if they are closing the table, let's see if they want to
           save any changes. However, we won't check this if
           they are in inquire mode.}

        If ((MainTable.State in [dsInsert, dsEdit]) and
            (not MainTable.ReadOnly) and
            MainTable.Modified)
          then
            begin
              try
                MainTable.Post;
              except
                CanClose := False;
                GlblParcelPageCloseCancelled := True;
              end;

            end;  {If Modified}

      end;  {bldBTrieve} *)

    bldSmallBuilding :
      begin
        If (SmallBuildingPermitTable.State in [dsInsert, dsEdit])
          then SmallBuildingPermitTable.UpdateRecord;

          {Now, if they are closing the table, let's see if they want to
           save any changes. However, we won't check this if
           they are in inquire mode.}

        If ((SmallBuildingPermitTable.State in [dsInsert, dsEdit]) and
            (not SmallBuildingPermitTable.ReadOnly) and
            SmallBuildingPermitTable.Modified)
          then
            begin
              try
                SmallBuildingPermitTable.Post;
              except
                CanClose := False;
                GlblParcelPageCloseCancelled := True;
              end;

            end;  {If Modified}

      end;  {bldSmallBuilding}

  end;  {case GlblBuildingSystemLinkType of}

  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure TBldgPermitForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
    {Now, if the parcel changed, then update the parcel table.}

  CloseTablesForForm(Self);

    {Free up the string lists.}

  FieldValuesList.Free;
  FieldLabelsList.Free;

  Action := caFree;

end;  {FormClose}

end.