unit pCertiorari;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, Tabs, GrievanceNotesFrameUnit,
  ComCtrls, RPTable, RPDBTabl, RPDefine, RPBase, RPShell, Word97, Excel97,
  OleServer, ShellAPI, Printers, TMultiP, MMOpen;

type
  TCertiorariForm = class(TForm)
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    InactiveLabel: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    CertiorariLookupTable: TTable;
    PriorAssessmentTable: TTable;
    CurrentAssessmentTable: TTable;
    SwisCodeTable: TTable;
    CurrentExemptionsTable: TTable;
    CurrentSpecialDistrictsTable: TTable;
    CertiorariExemptionsTable: TTable;
    CertiorariSpecialDistrictsTable: TTable;
    LawyerCodeTable: TTable;
    CurrentSalesTable: TTable;
    CertiorariCalendarTable: TTable;
    CertiorariAppraisalTable: TTable;
    CertiorariDocumentTable: TTable;
    CertiorariSalesTable: TTable;
    CertiorariExemptionsAskedTable: TTable;
    MainTableTaxRollYr: TStringField;
    MainTableSwisSBLKey: TStringField;
    MainTableCertiorariNumber: TIntegerField;
    MainTableArticleType: TStringField;
    MainTableCurrentName1: TStringField;
    MainTableCurrentName2: TStringField;
    MainTableCurrentAddress1: TStringField;
    MainTableCurrentAddress2: TStringField;
    MainTableCurrentStreet: TStringField;
    MainTableCurrentCity: TStringField;
    MainTableCurrentState: TStringField;
    MainTableCurrentZip: TStringField;
    MainTableCurrentZipPlus4: TStringField;
    MainTableLawyerCode: TStringField;
    MainTablePetitName1: TStringField;
    MainTablePetitName2: TStringField;
    MainTablePetitAddress1: TStringField;
    MainTablePetitAddress2: TStringField;
    MainTablePetitStreet: TStringField;
    MainTablePetitCity: TStringField;
    MainTablePetitState: TStringField;
    MainTablePetitZip: TStringField;
    MainTablePetitZipPlus4: TStringField;
    MainTablePetitPhoneNumber: TStringField;
    MainTablePetitFaxNumber: TStringField;
    MainTablePetitEmail: TStringField;
    MainTablePetitAttorneyName: TStringField;
    MainTablePriorLandValue: TIntegerField;
    MainTablePriorTotalValue: TIntegerField;
    MainTableCurrentLandValue: TIntegerField;
    MainTableCurrentTotalValue: TIntegerField;
    MainTableCurrentTentativeValue: TIntegerField;
    MainTableCurrentFullMarketVal: TIntegerField;
    MainTableCurrentEqRate: TFloatField;
    MainTableCurrentUniformPercent: TFloatField;
    MainTableCurrentRAR: TFloatField;
    MainTablePetitLandValue: TIntegerField;
    MainTablePetitTotalValue: TIntegerField;
    MainTablePetitFullMarketVal: TIntegerField;
    MainTablePropertyClassCode: TStringField;
    MainTableOwnershipCode: TStringField;
    MainTableResidentialPercent: TFloatField;
    MainTableRollSection: TStringField;
    MainTableHomesteadCode: TStringField;
    MainTableLegalAddr: TStringField;
    MainTableLegalAddrNo: TStringField;
    MainTableOldParcelID: TStringField;
    MainTableSchoolCode: TStringField;
    MainTableNotes: TMemoField;
    MainTableNumberOfParcels: TIntegerField;
    MainTableNoticeOfPetition: TDateField;
    MainTableNoteOfIssue: TDateField;
    MainTableResolutionNumber: TStringField;
    MainTableFinalOrderDate: TDateField;
    MainTableGrantedFullMarketVal: TIntegerField;
    MainTableCertiorariStatus: TStringField;
    HistorySwisCodeTable: TTable;
    MainTablePriorFullMarketVal: TIntegerField;
    MainTablePetitReason: TStringField;
    MainTablePetitSubreasonCode: TStringField;
    MainTablePetitSubreason: TMemoField;
    MainTablePostTrialMemo: TDateField;
    MainTableGrantedLandValue: TIntegerField;
    MainTableGrantedTotalValue: TIntegerField;
    MainTableGrantedEXCode: TStringField;
    MainTableGrantedEXAmount: TIntegerField;
    MainTableGrantedEXPercent: TFloatField;
    PriorSwisCodeTable: TTable;
    MainTableDisposition: TStringField;
    MainTableResultsReason: TMemoField;
    MainTableDispositionDate: TDateField;
    MainTableGrievanceDecision: TStringField;
    MainTableLegalAddrInt: TIntegerField;
    MainTableMunicipalAuditDate: TDateField;
    MainTablePetitGrievanceValue: TIntegerField;
    MainTableAlternateID: TStringField;
    MainTableMunicipalAuditAmount: TIntegerField;
    RenumberCertiorariPanel: TPanel;
    Label1: TLabel;
    CancelButton: TBitBtn;
    OKButton: TBitBtn;
    EditNewCertiorariNumber: TEdit;
    Label2: TLabel;
    EditNewCertiorariYear: TEdit;
    Panel21: TPanel;
    CloseRenumberCertiorariPanelTopButton: TButton;
    Label3: TLabel;
    SetFocusTimer: TTimer;
    NumberOfNotesTimer: TTimer;
    SwisCodeLookupTable: TTable;
    ParcelLookupTable: TTable;
    AssessmentLookupTable: TTable;
    Panel3: TPanel;
    Label4: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    EditSBL: TMaskEdit;
    EditName: TDBEdit;
    EditLocation: TEdit;
    PageControl: TPageControl;
    SummaryTabSheet: TTabSheet;
    NotesTabSheet: TTabSheet;
    GrievanceNotesFrame: TGrievanceNotesFrame;
    pnl_Buttons: TPanel;
    NewCertiorariButton: TBitBtn;
    DeleteCertiorariButton: TBitBtn;
    RenumberCertiorariButton: TBitBtn;
    CopyCertiorariButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel5: TPanel;
    CertiorariGrid: TwwDBGrid;
    CertiorariLookup2Table: TTable;
    tbs_CertiorariDocuments: TTabSheet;
    Panel6: TPanel;
    btn_NewDocument: TBitBtn;
    btn_DeleteDocument: TBitBtn;
    btn_FullScreen: TBitBtn;
    btn_PrintDocument: TBitBtn;
    lv_CertiorariDocuments: TListView;
    tb_CertiorariDocuments: TwwTable;
    CertiorariNotesTablePrinter: TDBTablePrinter;
    CertiorariNotesTablePrinterDateEntered: TDBTableColumn;
    CertiorariNotesTablePrinterEnteredBy: TDBTableColumn;
    CertiorariNotesTablePrinterOpen: TDBTableColumn;
    CertiorariNotesTablePrinterNote: TDBTableColumn;
    CertiorariNotesTablePrinterBodyHeader: TTableSection;
    tb_DocumentType: TwwTable;
    tb_CertiorariDocumentsLookup: TwwTable;
    WordApplication: TWordApplication;
    ExcelApplication: TExcelApplication;
    WordDocument: TWordDocument;
    PrintDialog: TPrintDialog;
    Image: TPMultiImage;
    btn_DocumentClose: TBitBtn;
    DocumentDialog: TOpenDialog;
    OpenScannedImageDialog: TMMOpenDialog;
    OpenPDFDialog: TOpenDialog;
    OLEItemNameTimer: TTimer;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure NewCertiorariButtonClick(Sender: TObject);
    procedure CertiorariGridDblClick(Sender: TObject);
    procedure MainTableCalcFields(DataSet: TDataSet);
    procedure DeleteCertiorariButtonClick(Sender: TObject);
    procedure RenumberCertiorariButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure NumberOfNotesTimerTimer(Sender: TObject);
    procedure CopyCertiorariButtonClick(Sender: TObject);
    procedure btn_NewDocumentClick(Sender: TObject);
    procedure btn_DeleteDocumentClick(Sender: TObject);
    procedure btn_FullScreenClick(Sender: TObject);
    procedure btn_PrintDocumentClick(Sender: TObject);
    procedure OLEItemNameTimerTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr, SwisSBLKey,
    CertiorariYear, PriorYear, DocumentLocation : String;
    lcid, CertiorariProcessingType,
    iOriginalGridWidth, PriorProcessingType : Integer;
    DocumentActive, PriorAssessmentFound : Boolean;
    CurrentDocumentNumber, CurrentDocumentType : Integer;

    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
      {because these routines are placed at the form object def. level,}
      {they have access to all variables on form (no need to Var in)   }
    Procedure InitializeForm;
    Procedure SetRangeForTable(Table : TTable);

    Procedure ConvertOneCertiorari(SwisSBLKey : String;
                                   CurrentCertiorariYear : String;
                                   NewCertiorariYear : String;
                                   CurrentCertiorariNumber : Integer;
                                   NewCertiorariNumber : Integer);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, PCertiorariSubFormUnit, CertiorariAddDialogUnit,
     CertiorariCondoCopyDialogUnit,
     DataAccessUnit, DocumentTypeDialog,
     GrievanceUtilitys, FullScrn, UtilOLE;

{$R *.DFM}

{=====================================================================}
Procedure TCertiorariForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TCertiorariForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{mmm4 - Make sure to set range on all keys.}

begin
  SetRangeOld(Table, ['SwisSBLKey', 'TaxRollYr'],
              [SwisSBLKey, '1950'],
              [SwisSBLKey, '9999']);

end;  {SetRangeForTable}

{====================================================================}
Procedure LoadCertiorariDocuments(lv_CertiorariDocuments : TListView;
                                  tb_CertiorariDocuments : TTable;
                                  tb_DocumentType : TTable;
                                  tbs_CertiorariDocuments : TTabSheet;
                                  SwisSBLKey : String);

begin
  ClearListView(lv_CertiorariDocuments);

  _SetRange(tb_CertiorariDocuments, [SwisSBLKey, ''], [SwisSBLKey, 9999999], '', []);

  with tb_CertiorariDocuments do
    begin
      First;

      while (not EOF) do
        begin
          _Locate(tb_DocumentType, [FieldByName('DocumentType').AsString], '', []);

          FillInListViewRow(lv_CertiorariDocuments,
                            [FieldByName('DocumentNumber').AsString,
                             tb_DocumentType.FieldByName('ApplicationName').AsString,
                             FieldByName('Date').AsString,
                             FieldByName('DocumentLocation').AsString,
                             FieldByName('Notes').AsString],
                            False);

          Next;

        end;  {while (not EOF) do}

    end;  {with tb_CertiorariDocuments do}

  tbs_CertiorariDocuments.Caption := 'Documents (' + IntToStr(lv_CertiorariDocuments.Items.Count) + ')';

end;  {LoadDocuments}

{====================================================================}
Procedure TCertiorariForm.InitializeForm;

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

begin
  UnitName := 'PCertiorari';  {mmm1}
  ClosingForm := False;
  FormIsInitializing := True;
  iOriginalGridWidth := CertiorariGrid.Width;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then MainTable.ReadOnly := True;

          {If this is inquire let's open it in
           readonly mode. Hist access is blocked at menu level}

        If (EditMode = 'V')
          then MainTable.ReadOnly := True;

          {FXX10062002-1: Actually certs are entered on This Year in Westchester.}

(*        If GlblIsWestchesterCounty
          then
            begin
              CertiorariYear := GlblNextYear;
              PriorYear := GlblThisYear;
              CertiorariProcessingType := NextYear;
              PriorProcessingType := ThisYear;
            end
          else
            begin *)
              CertiorariYear := GlblThisYear;
              PriorYear := IntToStr(StrToInt(CertiorariYear) - 1);
              CertiorariProcessingType := ThisYear;
              PriorProcessingType := History;
(*            end;*)

        OpenTablesForForm(Self, CertiorariProcessingType);

        Found := _Locate(ParcelTable, [CertiorariYear, SwisSBLKey], '', [loParseSwisSBLKey]);

          {Set the range.}

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

        case EditMode of   {mmm5}
          'A',
          'M' : TitleLabel.Caption := 'Certiorari Add\Modify';
          'V' : TitleLabel.Caption := 'Certiorari View';
        end;  {case EditMode of}

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Note that we will not automatically put them
           in edit mode or insert mode. We will make them
           take that action themselves since even though
           they are in an edit or insert session, they
           may not want to actually make any changes, and
           if they do not, they should not have to cancel.}
          {FXX02022004-2(2.07l): Make sure the copy grievance, etc. button is disabled in view mode.}

        If ((EditMode = 'V') or
            MainTable.ReadOnly)
          then
            begin
              NewCertiorariButton.Enabled := False;
              DeleteCertiorariButton.Enabled := False;
              RenumberCertiorariButton.Enabled := False;
              CopyCertiorariButton.Enabled := False;

            end;  {If ((EditMode = 'V') or ...}

          {Set the location label.}
          {FXX01242005-1(2.8.3.1)[]: Handle the case where a cert still exists for a parcel no
                                   longer on the roll.}

        If Found
          then EditLocation.Text := GetLegalAddressFromTable(ParcelTable)
          else
            begin
              EditName.Enabled := False;
              EditLocation.Enabled := False;
            end;

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
        SetTaxYearLabelForProcessingType(YearLabel, GlblProcessingType);

          {FXX12101997-1: Make sure that all pages have the inactive label.}

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                                   CertiorariProcessingType, Quit);

        OpenTableForProcessingType(CurrentAssessmentTable, AssessmentTableName,
                                   CertiorariProcessingType, Quit);

        OpenTableForProcessingType(PriorSwisCodeTable, SwisCodeTableName,
                                   PriorProcessingType, Quit);

        OpenTableForProcessingType(PriorAssessmentTable, AssessmentTableName,
                                   PriorProcessingType, Quit);

        OpenTableForProcessingType(CurrentExemptionsTable, ExemptionsTableName,
                                   CertiorariProcessingType, Quit);

        OpenTableForProcessingType(CurrentSpecialDistrictsTable, SpecialDistrictTableName,
                                   CertiorariProcessingType, Quit);

        FindKeyOld(SwisCodeTable, ['SwisCode'], [Copy(SwisSBLKey, 1, 6)]);

        FindKeyOld(CurrentAssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                   [CertiorariYear, SwisSBLKey]);

        PriorAssessmentFound := FindKeyOld(PriorAssessmentTable,
                                           ['TaxRollYr', 'SwisSBLKey'],
                                           [PriorYear, SwisSBLKey]);

        SetRangeOld(CurrentExemptionsTable, ['TaxRollYr', 'SwisSBLKey'],
                    [CertiorariYear, SwisSBLKey], [CertiorariYear, SwisSBLKey]);

        SetRangeOld(CurrentSpecialDistrictsTable, ['TaxRollYr', 'SwisSBLKey'],
                    [CertiorariYear, SwisSBLKey], [CertiorariYear, SwisSBLKey]);

        SetRangeOld(CurrentSalesTable, ['SwisSBLKey', 'SaleNumber'],
                    [SwisSBLKey, '0'], [SwisSBLKey, '9999']);

        TFloatField(MainTable.FieldByName('CurrentTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;
        TFloatField(MainTable.FieldByName('CurrentFullMarketVal')).DisplayFormat := CurrencyDisplayNoDollarSign;
        TFloatField(MainTable.FieldByName('PetitTotalValue')).DisplayFormat := CurrencyDisplayNoDollarSign;

        If GlblCanSeeCertNotes
          then
            begin
              GrievanceNotesFrame.InitializeForm(SwisSBLKey, CertiorariNotesTableName);
              LoadCertiorariDocuments(lv_CertiorariDocuments, tb_CertiorariDocuments,
                                      tb_DocumentType, tbs_CertiorariDocuments, SwisSBLKey);
              NumberOfNotesTimer.Enabled := True;

            end
          else
            begin
              NotesTabSheet.TabVisible := False;
              tbs_CertiorariDocuments.TabVisible := False;
            end;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  FormIsInitializing := False;

  MainTable.Refresh;

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

end;  {InitializeForm}

{==============================================================}
Procedure TCertiorariForm.MainTableCalcFields(DataSet: TDataSet);

var
  StatusCode : Integer;

begin
  If not FormIsInitializing
    then MainTableCertiorariStatus.Text := GetCert_Or_SmallClaimStatus(MainTable, StatusCode);

end;  {MainTableCalcFields}

{==============================================================}
Procedure TCertiorariForm.NumberOfNotesTimerTimer(Sender: TObject);

begin
  NotesTabSheet.Caption := 'Notes (' + IntToStr(GrievanceNotesFrame.GetNumberOfNotes) + ')';
end;

{==============================================================}
Procedure TCertiorariForm.CertiorariGridDblClick(Sender: TObject);

{Go to this certiorari in the subform.}

begin
  GlblDialogBoxShowing := True;

  try
    CertiorariSubform := TCertiorariSubform.Create(nil);

    CertiorariSubform.SwisSBLKey := MainTable.FieldByName('SwisSBLKey').Text;
    CertiorariSubform.CertiorariYear := MainTable.FieldByName('TaxRollYr').Text;
    CertiorariSubform.CertiorariNumber := MainTable.FieldByName('CertiorariNumber').AsInteger;
    CertiorariSubform.CertiorariProcessingType := CertiorariProcessingType;
    CertiorariSubform.EditMode := EditMode;

    CertiorariSubform.InitializeForm;

    CertiorariSubform.ShowModal;

    MainTable.Refresh;

  finally
    CertiorariSubform.Free;
  end;

  GlblDialogBoxShowing := False;

end;  {CertiorariGridDblClick}

{==============================================================}
Procedure TCertiorariForm.NewCertiorariButtonClick(Sender: TObject);

var
  CertiorariNumber, TempProcessingType : Integer;
  _Found, Continue, AddNewCertiorari : Boolean;
  InitializationInformationFound, Quit : Boolean;
  TempAssessmentYear,
  LawyerCode, EnteredCertiorariYear : String;
  TempParcelTable, TempAssessmentTable, TempSwisCodeTable : TTable;
  SBLRec : SBLRecord;

begin
  Continue := True;
  GlblDialogBoxShowing := True;
  TempParcelTable := nil;
  TempSwisCodeTable := nil;
  TempAssessmentTable := nil;
  CertiorariNumber := 0;
  AddNewCertiorari := False;

    {FXX10072003-1(2.07j): Make it so that history cert and small claims entry picks up
                           as much info as it can.}

  try
    CertiorariAddDialog := TCertiorariAddDialog.Create(nil);
    CertiorariAddDialog.CertiorariYear := CertiorariYear;
    CertiorariAddDialog.PriorYear := PriorYear;
    CertiorariAddDialog.CertiorariProcessingType := CertiorariProcessingType;
    CertiorariAddDialog.PriorProcessingType := PriorProcessingType;
    CertiorariAddDialog.SwisSBLKey := SwisSBLKey;

    case CertiorariAddDialog.ShowModal of
      idOK :
        begin
          LawyerCode := CertiorariAddDialog.LawyerCode;
          CertiorariNumber := CertiorariAddDialog.CertiorariNumber;
          EnteredCertiorariYear := CertiorariAddDialog.CertiorariYear;
        end;

      idCancel : Continue := False;

    end;  {case CertiorariLawyerCodeDialog.ShowModal of}

    If Continue
      then AddNewCertiorari := not CertiorariAddDialog.AlreadyCopied;

  finally
    CertiorariAddDialog.Free;
  end;

  GlblDialogBoxShowing := False;

  If (Continue and
      AddNewCertiorari)
    then
      begin
        with MainTable do
          try
            Append;
            FieldByName('TaxRollYr').Text := EnteredCertiorariYear;
            FieldByName('CertiorariNumber').AsInteger := CertiorariNumber;
            FieldByName('SwisSBLKey').Text := SwisSBLKey;
            FieldByName('LawyerCode').Text := LawyerCode;
            FieldByName('OldParcelID').Text := ParcelTable.FieldByName('RemapOldSBL').Text;

            InitializationInformationFound := False;

            If (CertiorariYear = EnteredCertiorariYear)
              then
                begin
                  TempParcelTable := ParcelTable;
                  TempAssessmentTable := CurrentAssessmentTable;
                  TempSwisCodeTable := SwisCodeTable;
                  InitializationInformationFound := True;

                end;  {If (GrievanceYear = EnteredGrievanceYear)}

            If not InitializationInformationFound
              then
                begin
                  If (EnteredCertiorariYear = GlblThisYear)
                    then
                      begin
                        TempProcessingType := ThisYear;
                        TempAssessmentYear := GlblThisYear;
                      end
                    else
                      If (EnteredCertiorariYear = GlblNextYear)
                      then
                      begin
                        TempProcessingType := NextYear;
                        TempAssessmentYear := GlblNextYear;
                      end
                      else
                      begin
                        TempProcessingType := History;
                        TempAssessmentYear := EnteredCertiorariYear;
                      end;

                  OpenTableForProcessingType(ParcelLookupTable, ParcelTableName,
                                             TempProcessingType, Quit);

                  OpenTableForProcessingType(AssessmentLookupTable, AssessmentTableName,
                                             TempProcessingType, Quit);

                  OpenTableForProcessingType(SwisCodeLookupTable, SwisCodeTableName,
                                             TempProcessingType, Quit);

                  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                  with SBLRec do
                    InitializationInformationFound := FindKeyOld(ParcelLookupTable,
                                                                 ['TaxRollYr', 'SwisCode', 'Section',
                                                                  'Subsection', 'Block', 'Lot', 'Sublot',
                                                                  'Suffix'],
                                                                 [TempAssessmentYear, SwisCode, Section,
                                                                  SubSection, Block, Lot, Sublot, Suffix]);

                  FindKeyOld(AssessmentLookupTable, ['TaxRollYr', 'SwisSBLKey'],
                             [TempAssessmentYear, SwisSBLKey]);

                  FindKeyOld(SwisCodeLookupTable, ['TaxRollYr', 'SwisCode'],
                             [TempAssessmentYear, SBLRec.SwisCode]);

                  TempParcelTable := ParcelLookupTable;
                  TempAssessmentTable := AssessmentLookupTable;
                  TempSwisCodeTable := SwisCodeLookupTable;

                end;  {If not InitializationInformationFound}

            If InitializationInformationFound
              then
                begin
                  FieldByName('CurrentName1').Text := TempParcelTable.FieldByName('Name1').Text;
                  FieldByName('CurrentName2').Text := TempParcelTable.FieldByName('Name2').Text;
                  FieldByName('CurrentAddress1').Text := TempParcelTable.FieldByName('Address1').Text;
                  FieldByName('CurrentAddress2').Text := TempParcelTable.FieldByName('Address2').Text;
                  FieldByName('CurrentStreet').Text := TempParcelTable.FieldByName('Street').Text;
                  FieldByName('CurrentCity').Text := TempParcelTable.FieldByName('City').Text;
                  FieldByName('CurrentState').Text := TempParcelTable.FieldByName('State').Text;
                  FieldByName('CurrentZip').Text := TempParcelTable.FieldByName('Zip').Text;
                  FieldByName('CurrentZipPlus4').Text := TempParcelTable.FieldByName('ZipPlus4').Text;

                  If (Deblank(LawyerCode) = '')
                    then
                      begin
                          {They are representing themselves.}

                        FieldByName('PetitName1').Text := TempParcelTable.FieldByName('Name1').Text;
                        FieldByName('PetitName2').Text := TempParcelTable.FieldByName('Name2').Text;
                        FieldByName('PetitAddress1').Text := TempParcelTable.FieldByName('Address1').Text;
                        FieldByName('PetitAddress2').Text := TempParcelTable.FieldByName('Address2').Text;
                        FieldByName('PetitStreet').Text := TempParcelTable.FieldByName('Street').Text;
                        FieldByName('PetitCity').Text := TempParcelTable.FieldByName('City').Text;
                        FieldByName('PetitState').Text := TempParcelTable.FieldByName('State').Text;
                        FieldByName('PetitZip').Text := TempParcelTable.FieldByName('Zip').Text;
                        FieldByName('PetitZipPlus4').Text := TempParcelTable.FieldByName('ZipPlus4').Text;

                      end
                    else SetPetitionerNameAndAddress(MainTable, LawyerCodeTable, LawyerCode);

                  FieldByName('PropertyClassCode').Text := TempParcelTable.FieldByName('PropertyClassCode').Text;
                  FieldByName('OwnershipCode').Text := TempParcelTable.FieldByName('OwnershipCode').Text;
                  FieldByName('ResidentialPercent').AsFloat := TempParcelTable.FieldByName('ResidentialPercent').AsFloat;
                  FieldByName('RollSection').Text := TempParcelTable.FieldByName('RollSection').Text;
                  FieldByName('HomesteadCode').Text := TempParcelTable.FieldByName('HomesteadCode').Text;
                  FieldByName('LegalAddr').Text := TempParcelTable.FieldByName('LegalAddr').Text;
                  FieldByName('LegalAddrNo').Text := TempParcelTable.FieldByName('LegalAddrNo').Text;
                    {FXX01162003-3: Need to include the legal address integer.}

                  try
                    FieldByName('LegalAddrInt').AsInteger := TempParcelTable.FieldByName('LegalAddrInt').AsInteger;
                  except
                  end;
                  FieldByName('CurrentLandValue').AsInteger := TempAssessmentTable.FieldByName('LandAssessedVal').AsInteger;
                  FieldByName('CurrentTotalValue').AsInteger := TempAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
                  FieldByName('CurrentFullMarketVal').AsInteger := Round(ComputeFullValue(TempAssessmentTable.FieldByName('TotalAssessedVal').AsInteger,
                                                                                          TempSwisCodeTable,
                                                                                          TempParcelTable.FieldByName('PropertyClassCode').Text,
                                                                                          TempParcelTable.FieldByName('OwnershipCode').Text,
                                                                                          GlblUseRAR));
                  If ((EnteredCertiorariYear = CertiorariYear) and
                      PriorAssessmentFound)
                    then
                      begin
                        FindKeyOld(PriorSwisCodeTable, ['TaxRollYr', 'SwisCode'],
                                   [PriorYear, Copy(SwisSBLKey, 1, 6)]);
                        FieldByName('PriorLandValue').AsInteger := PriorAssessmentTable.FieldByName('LandAssessedVal').AsInteger;
                        FieldByName('PriorTotalValue').AsInteger := PriorAssessmentTable.FieldByName('TotalAssessedVal').AsInteger;

                        try
                          FieldByName('PriorFullMarketVal').AsInteger := Round(ComputeFullValue(PriorAssessmentTable.FieldByName('TotalAssessedVal').AsInteger,
                                                                                                HistorySwisCodeTable,
                                                                                                ParcelTable.FieldByName('PropertyClassCode').Text,
                                                                                                ParcelTable.FieldByName('OwnershipCode').Text,
                                                                                                GlblUseRAR));
                        except
                        end;

                      end;  {If PriorAssessmentFound}

                  FieldByName('CurrentEqRate').AsFloat := TempSwisCodeTable.FieldByName('EqualizationRate').AsFloat;
                  FieldByName('CurrentUniformPercent').AsFloat := TempSwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
                  FieldByName('CurrentRAR').AsFloat := TempSwisCodeTable.FieldByName('ResAssmntRatio').AsFloat;
                  FieldByName('SchoolCode').Text := TempParcelTable.FieldByName('SchoolCode').Text;
                  FieldByName('NumberOfParcels').AsInteger := 1;

                  Post;

                  If (EnteredCertiorariYear = CertiorariYear)
                    then
                      begin
                        CopyTableRange(CurrentExemptionsTable, CertiorariExemptionsTable,
                                       'TaxRollYr', ['CertiorariNumber'], [IntToStr(CertiorariNumber)]);

                        CopyTableRange(CurrentSpecialDistrictsTable, CertiorariSpecialDistrictsTable,
                                       'TaxRollYr', ['CertiorariNumber'], [IntToStr(CertiorariNumber)]);

                        CopyTableRange(CurrentSalesTable, CertiorariSalesTable,
                                       'SwisSBLKey', ['CertiorariNumber'], [IntToStr(CertiorariNumber)]);

                      end;  {If (EnteredCertiorariYear = CertiorariYear)}

                end
              else Post;

          except
            Continue := False;
            SystemSupport(002, MainTable, 'Error adding Certiorari # ' + IntToStr(CertiorariNumber) + '.',
                          UnitName, GlblErrorDlgBox);
          end;

      end;  {If Continue}

  If Continue
    then
      begin
        MainTable.Refresh;
        SetRangeForTable(MainTable);

          {FXX08272003-1(2.07i): Need to make sure we are pointed at the right cert at this point.}

        _Found := FindKeyOld(CertiorariLookupTable, ['TaxRollYr', 'SwisSBLKey', 'CertiorariNumber'],
                             [EnteredCertiorariYear, SwisSBLKey, IntToStr(CertiorariNumber)]);

        If _Found
          then
            begin
              MainTable.GotoCurrent(CertiorariLookupTable);
              CertiorariGridDblClick(Sender);
            end
          else SystemSupport(009, CertiorariLookupTable,
                             'Error reaccessing certiorari ' + IntToStr(CertiorariNumber) + '.',
                             UnitName, GlblErrorDlgBox);

      end;  {If Continue}

end;  {NewCertiorariButtonClick}

{==============================================================}
Procedure TCertiorariForm.DeleteCertiorariButtonClick(Sender: TObject);

var
  CertiorariNumber : Integer;

begin
  CertiorariNumber := MainTable.FieldByName('CertiorariNumber').AsInteger;

    {CHG03232003-1(2.06q2): Allow Supervisor to delete cert from a year other
                            than the current year.}
    {CHG06092010-3(2.26.1)[I7208]: Allow for supervisor equivalents.}

  If ((CertiorariYear = MainTable.FieldByName('TaxRollYr').Text) or
      UserIsSupervisor(GlblUserName))
    then
      If (MessageDlg('Are you sure you want to delete certiorari ' +
                     IntToStr(CertiorariNumber) + '?',
                     mtConfirmation, [mbYes, mbNo], 0) = idYes)
        then
          begin
            SetRangeOld(CertiorariExemptionsTable,
                        ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'ExemptionCode'],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '     '],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '99999']);

            SetRangeOld(CertiorariExemptionsAskedTable,
                        ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'ExemptionCode'],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '     '],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '99999']);

            SetRangeOld(CertiorariSpecialDistrictsTable,
                        ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'SDistCode'],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '     '],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), 'ZZZZZ']);

            SetRangeOld(CertiorariSalesTable,
                        ['SwisSBLKey', 'CertiorariNumber', 'SaleNumber'],
                        [SwisSBLKey, IntToStr(CertiorariNumber), '0'],
                        [SwisSBLKey, IntToStr(CertiorariNumber), '9999']);

            SetRangeOld(CertiorariCalendarTable,
                        ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'Date'],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '1/1/1990'],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '1/1/3000']);

            SetRangeOld(CertiorariAppraisalTable,
                        ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'DateAuthorized'],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '1/1/1990'],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '1/1/3000']);

            SetRangeOld(CertiorariDocumentTable,
                        ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'DocumentNumber'],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '0'],
                        [SwisSBLKey, CertiorariYear, IntToStr(CertiorariNumber), '9999']);

            DeleteTableRange(CertiorariExemptionsTable);
            DeleteTableRange(CertiorariExemptionsAskedTable);
            DeleteTableRange(CertiorariSpecialDistrictsTable);
            DeleteTableRange(CertiorariSalesTable);
            DeleteTableRange(CertiorariCalendarTable);
            DeleteTableRange(CertiorariAppraisalTable);
            DeleteTableRange(CertiorariDocumentTable);

            try
              MainTable.Delete;
            except
              SystemSupport(060, MainTable,
                            'Error deleting Certiorari ' + IntToStr(CertiorariNumber) + '.',
                            UnitName, GlblErrorDlgBox);
            end;

          end  {If (MessageDlg ...}
        else MessageDlg('Sorry, you can not delete certioraris from a prior year.',
                        mtError, [mboK], 0);

end;  {DeleteCertiorariButtonClick}

{==============================================================}
Procedure TCertiorariForm.SetFocusTimerTimer(Sender: TObject);

begin
  SetFocusTimer.Enabled := False;
  EditNewCertiorariYear.SetFocus;
end;

{==============================================================}
Procedure TCertiorariForm.RenumberCertiorariButtonClick(Sender: TObject);

begin
  RenumberCertiorariPanel.Visible := True;
  SetFocusTimer.Enabled := True;
end;

{==============================================================}
Procedure TCertiorariForm.CopyCertiorariButtonClick(Sender: TObject);

{CHG10092003-2(2.07j1): Allow them to copy a Certiorari to multiple parcels.}

begin
  try
    CertiorariCondoCopyDialog := TCertiorariCondoCopyDialog.Create(nil);
    CertiorariCondoCopyDialog.CertiorariNumber := MainTable.FieldByName('CertiorariNumber').AsInteger;
    CertiorariCondoCopyDialog.CertiorariYear := MainTable.FieldByName('TaxRollYr').Text;
    CertiorariCondoCopyDialog.LawyerCode := MainTable.FieldByName('LawyerCode').Text;
    CertiorariCondoCopyDialog.OriginalSwisSBLKey := SwisSBLKey;

    CertiorariCondoCopyDialog.ShowModal;

  finally
    CertiorariCondoCopyDialog.Free;
  end;

end;  {CopyCertiorariButtonClick}

{==============================================================}
Procedure TCertiorariForm.ConvertOneCertiorari(SwisSBLKey : String;
                                               CurrentCertiorariYear : String;
                                               NewCertiorariYear : String;
                                               CurrentCertiorariNumber : Integer;
                                               NewCertiorariNumber : Integer);

var
  ExceptionRaised : Boolean;

begin
  SetRangeOld(CertiorariExemptionsAskedTable,
              ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'ExemptionCode'],
              [SwisSBLKey, CurrentCertiorariYear, IntToStr(CurrentCertiorariNumber), '     '],
              [SwisSBLKey, CurrentCertiorariYear, IntToStr(CurrentCertiorariNumber), '99999']);
  UpdateFieldForTable(CertiorariExemptionsAskedTable,
                      'CertiorariNumber', IntToStr(NewCertiorariNumber));
  If ((Deblank(NewCertiorariYear) <> '') and
      (NewCertiorariYear <> CurrentCertiorariYear))
    then
      begin
        SetRangeOld(CertiorariExemptionsAskedTable,
                    ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'ExemptionCode'],
                    [SwisSBLKey, CurrentCertiorariYear, IntToStr(NewCertiorariNumber), '     '],
                    [SwisSBLKey, CurrentCertiorariYear, IntToStr(NewCertiorariNumber), '99999']);
        UpdateFieldForTable(CertiorariExemptionsAskedTable,
                            'TaxRollYr', NewCertiorariYear);

      end;  {If ((Deblank(NewCertiorariYear) <> '') and ..}

  SetRangeOld(CertiorariExemptionsTable,
              ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'ExemptionCode'],
              [SwisSBLKey, CertiorariYear, IntToStr(CurrentCertiorariNumber), '     '],
              [SwisSBLKey, CertiorariYear, IntToStr(CurrentCertiorariNumber), '99999']);
  UpdateFieldForTable(CertiorariExemptionsTable,
                      'CertiorariNumber', IntToStr(NewCertiorariNumber));
  If ((Deblank(NewCertiorariYear) <> '') and
      (NewCertiorariYear <> CurrentCertiorariYear))
    then
      begin
        SetRangeOld(CertiorariExemptionsTable,
                    ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'ExemptionCode'],
                    [SwisSBLKey, CertiorariYear, IntToStr(NewCertiorariNumber), '     '],
                    [SwisSBLKey, CertiorariYear, IntToStr(NewCertiorariNumber), '99999']);

        UpdateFieldForTable(CertiorariExemptionsTable,
                            'TaxRollYr', NewCertiorariYear);

      end;  {If ((Deblank(NewCertiorariYear) <> '') and ...}

  SetRangeOld(CertiorariSpecialDistrictsTable,
              ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'SDistCode'],
              [SwisSBLKey, CertiorariYear, IntToStr(CurrentCertiorariNumber), '     '],
              [SwisSBLKey, CertiorariYear, IntToStr(CurrentCertiorariNumber), 'ZZZZZ']);
  UpdateFieldForTable(CertiorariSpecialDistrictsTable,
                      'CertiorariNumber', IntToStr(NewCertiorariNumber));
  If ((Deblank(NewCertiorariYear) <> '') and
      (NewCertiorariYear <> CurrentCertiorariYear))
    then
      begin
        SetRangeOld(CertiorariSpecialDistrictsTable,
                    ['SwisSBLKey', 'TaxRollYr', 'CertiorariNumber', 'SDistCode'],
                    [SwisSBLKey, CertiorariYear, IntToStr(NewCertiorariNumber), '     '],
                    [SwisSBLKey, CertiorariYear, IntToStr(NewCertiorariNumber), 'ZZZZZ']);

        UpdateFieldForTable(CertiorariSpecialDistrictsTable,
                            'TaxRollYr', NewCertiorariYear);

      end;  {If ((Deblank(NewCertiorariYear) <> '') and ...}

  SetRangeOld(CertiorariSalesTable,
              ['SwisSBLKey', 'CertiorariNumber', 'SaleNumber'],
              [SwisSBLKey, IntToStr(CurrentCertiorariNumber), '1'],
              [SwisSBLKey, IntToStr(CurrentCertiorariNumber), '99999']);
  UpdateFieldForTable(CertiorariSalesTable,
                      'CertiorariNumber', IntToStr(NewCertiorariNumber));

  SetRangeOld(CertiorariAppraisalTable,
              ['TaxRollYr', 'SwisSBLKey', 'CertiorariNumber', 'DateAuthorized'],
              [CurrentCertiorariYear, SwisSBLKey, IntToStr(CurrentCertiorariNumber), '1/1/1900'],
              [CurrentCertiorariYear, SwisSBLKey, IntToStr(CurrentCertiorariNumber), '1/1/3000']);
  UpdateFieldForTable(CertiorariAppraisalTable,
                      'CertiorariNumber', IntToStr(NewCertiorariNumber));
  If ((Deblank(NewCertiorariYear) <> '') and
      (NewCertiorariYear <> CurrentCertiorariYear))
    then
      begin
        SetRangeOld(CertiorariAppraisalTable,
                    ['TaxRollYr', 'SwisSBLKey', 'CertiorariNumber', 'DateAuthorized'],
                    [CurrentCertiorariYear, SwisSBLKey, IntToStr(NewCertiorariNumber), '1/1/1900'],
                    [CurrentCertiorariYear, SwisSBLKey, IntToStr(NewCertiorariNumber), '1/1/3000']);
        UpdateFieldForTable(CertiorariAppraisalTable,
                            'TaxRollYr', NewCertiorariYear);

      end;  {If ((Deblank(NewCertiorariYear) <> '') and ..}

  SetRangeOld(CertiorariCalendarTable,
              ['TaxRollYr', 'SwisSBLKey', 'CertiorariNumber', 'Date'],
              [CurrentCertiorariYear, SwisSBLKey, IntToStr(CurrentCertiorariNumber), '1/1/1900'],
              [CurrentCertiorariYear, SwisSBLKey, IntToStr(CurrentCertiorariNumber), '1/1/3000']);
  UpdateFieldForTable(CertiorariCalendarTable,
                      'CertiorariNumber', IntToStr(NewCertiorariNumber));
  If ((Deblank(NewCertiorariYear) <> '') and
      (NewCertiorariYear <> CurrentCertiorariYear))
    then
      begin
        SetRangeOld(CertiorariCalendarTable,
                    ['TaxRollYr', 'SwisSBLKey', 'CertiorariNumber', 'Date'],
                    [CurrentCertiorariYear, SwisSBLKey, IntToStr(NewCertiorariNumber), '1/1/1900'],
                    [CurrentCertiorariYear, SwisSBLKey, IntToStr(NewCertiorariNumber), '1/1/3000']);
        UpdateFieldForTable(CertiorariCalendarTable,
                            'TaxRollYr', NewCertiorariYear);

      end;  {If ((Deblank(NewCertiorariYear) <> '') and ..}

  ExceptionRaised := False;

  If _Locate(CertiorariLookupTable, [CurrentCertiorariYear, SwisSBLKey, CurrentCertiorariNumber], '', [])
    then
      begin
        with CertiorariLookupTable do
          try
            Edit;
            FieldByName('CertiorariNumber').AsInteger := NewCertiorariNumber;

            If ((Deblank(NewCertiorariYear) <> '') and
                (NewCertiorariYear <> CurrentCertiorariYear))
              then FieldByName('TaxRollYr').Text := NewCertiorariYear;

            Post;
          except
            ExceptionRaised := True;
          end;

      end
    else ExceptionRaised := True;

  If ExceptionRaised
    then SystemSupport(003, CertiorariLookupTable, 'Error changing Certiorari number.',
                       UnitName, GlblErrorDlgBox);

end;  {ConvertOneCertiorari}

{==============================================================}
Procedure TCertiorariForm.OKButtonClick(Sender: TObject);

{CHG07082003-2(2.07f): Allow for renumbering.}

var
  NewCertiorariNumber, CurrentCertiorariNumber : Integer;
  NewCertiorariYear, CurrentCertiorariYear : String;
  Continue, FirstTimeThrough, Done : Boolean;

begin
  Continue := True;
  NewCertiorariNumber := 0;
  CurrentCertiorariNumber := MainTable.FieldByName('CertiorariNumber').AsInteger;
  CurrentCertiorariYear := MainTable.FieldByName('TaxRollYr').Text;

  try
    NewCertiorariNumber := StrToInt(EditNewCertiorariNumber.Text);
  except
    Continue := False;
    MessageDlg('Sorry, ' + EditNewCertiorariNumber.Text + ' is not a valid certiorari number.',
               mtError, [mbOK], 0);
    EditNewCertiorariNumber.SetFocus;
  end;

  NewCertiorariYear := Trim(EditNewCertiorariYear.Text);

    {CHG10062002-2: Don't allow them to delete or renumber Certioraris from prior years.}

  If Continue
    then
      If (MessageDlg('Are you sure you want to change the number of this Certiorari from ' +
                     IntToStr(CurrentCertiorariNumber) + ' to ' +
                     IntToStr(NewCertiorariNumber) + '?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
        then
          begin
              {CHG02162006-1(2.9.5.5): If this cert # is on multiple parcels, offer to change it for all of them.}

            _SetRange(CertiorariLookup2Table, [CurrentCertiorariYear, CurrentCertiorariNumber], [],
                      'ByYear_CertNum', [loSameEndingRange]);

            If (_Compare(CertiorariLookup2Table.RecordCount, 0, coGreaterThan) and
                _Compare(MessageDlg('This certiorari number applies to ' +
                                    IntToStr(CertiorariLookupTable.RecordCount) + ' parcels.' + #13 +
                                    'Do you want to change all of the parcels?',
                                    mtConfirmation, [mbYes, mbNo], 0),
                         idYes, coEqual))
              then
                begin
                  FirstTimeThrough := True;
                  CertiorariLookup2Table.First;

                  with CertiorariLookup2Table do
                    repeat
                      If FirstTimeThrough
                        then FirstTimeThrough := False
                        else Next;

                      Done := EOF;

                      If not Done
                        then ConvertOneCertiorari(FieldByName('SwisSBLKey').Text,
                                                  CurrentCertiorariYear,
                                                  NewCertiorariYear,
                                                  CurrentCertiorariNumber,
                                                  NewCertiorariNumber);

                    until Done;

                end
              else ConvertOneCertiorari(SwisSBLKey, CurrentCertiorariYear, NewCertiorariYear,
                                        CurrentCertiorariNumber, NewCertiorariNumber);

            RenumberCertiorariPanel.Visible := False;
            SetRangeForTable(MainTable);
            MainTable.Refresh;

            MessageDlg('This certiorari has been changed from ' +
                       IntToStr(CurrentCertiorariNumber) + ' to ' +
                       IntToStr(NewCertiorariNumber) + '.', mtInformation, [mbOK], 0);

            MainTable.Refresh;

          end;  {If (MessageDlg('Are you sure you want ...}

end;  {OKButtonClick}

{==============================================================}
Procedure TCertiorariForm.CancelButtonClick(Sender: TObject);

begin
  RenumberCertiorariPanel.Visible := False;
end;

{==============================================================}
Procedure TCertiorariForm.btn_NewDocumentClick(Sender: TObject);

var
  DocumentTypeDialogForm : TDocumentTypeDialogForm;
  NextDocumentNumber : Integer;
  _Selection : Selection;
  TempParcelTable, NYParcelTable : TTable;
  InsertNameAndAddress, Cancelled : Boolean;
  NAddrArray : NameAddrArray;
  I, DocumentType : Integer;

begin
  Cancelled := False;
  DocumentLocation := '';
  DocumentTypeDialogForm := nil;
  DocumentType := dtScannedImage;

  try
    DocumentTypeDialogForm := TDocumentTypeDialogForm.Create(nil);

    DocumentTypeDialogForm.ShowModal;

    If (DocumentTypeDialogForm.ModalResult = idOK)
      then
        begin
          NYParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                  NextYear);

          with tb_CertiorariDocuments do
            begin
              case DocumentTypeDialogForm.DocumentTypeSelected of
                dtOpenScannedImage :
                  begin
                    If OpenScannedImageDialog.Execute
                      then
                        begin
                          DocumentLocation := OpenScannedImageDialog.FileName;
                          DocumentType := dtScannedImage;
                        end
                      else Cancelled := True;

                  end;  {dtOpenScannedImage}

                dtOpenWordDocument :
                  begin
                    DocumentDialog.Filter := 'MS Word documents|*.doc|All Files|*.*';

                    If DocumentDialog.Execute
                      then
                        begin
                          DocumentLocation := DocumentDialog.FileName;
                          DocumentType := dtMSWord;
                        end
                      else Cancelled := True;

                  end;  {dtOpenWordDocument}

                dtCreateWordDocument :
                  try
                    DocumentType := dtMSWord;

                    InsertNameAndAddress := (MessageDlg('Do you want to insert the current name and address of this parcel?',
                                             mtConfirmation, [mbYes, mbNo], 0) = idYes);

                    CreateWordDocument(WordApplication, WordDocument);

                    with WordApplication do
                      begin
                          {CHG04022002-1: Give them the option of inserting the name and address.}

                        If InsertNameAndAddress
                          then
                            begin
                              _Selection := WordApplication.Selection;

                                {If it does not exist in NY, use the main parcel table.}

                              If _Locate(NYParcelTable, [GlblNextYear, SwisSBLKey], '', [loParseSwisSBLKey])
                                then
                                  begin
                                    TempParcelTable := NYParcelTable;

                                    GetNameAddress(TempParcelTable, NAddrArray);

                                    For I := 1 to 6 do
                                      If (Deblank(NAddrArray[I]) <> '')
                                        then
                                          begin
                                            _Selection.TypeText(NAddrArray[I]);
                                            _Selection.TypeParagraph;
                                          end;

                                  end;  {If _Locate(NYParcelTable, [GetTaxRlYr, SwisSBLKey], '', [loParseSwisSBLKey])}

                            end;  {InsertNameAndAddress}

                        DocumentActive := True;
                        GlblApplicationIsActive := False;
                        OLEItemNameTimer.Enabled := True;

                      end;  {with WordApplication do}

                  except
                    MessageDlg('Sorry, there was an problem linking with Word.' + #13 +
                               'Please try again.', mtError, [mbOK], 0);
                    Cancelled := True;
                  end;  {dtCreateWordDocument}

                dtOpenExcelSpreadsheet :
                  begin
                    DocumentDialog.Filter := 'Excel spreadsheets|*.xls|All Files|*.*';

                    If DocumentDialog.Execute
                      then
                        begin
                          DocumentLocation := DocumentDialog.FileName;
                          DocumentType := dtExcel;
                        end
                      else Cancelled := True;

                  end;  {dtOpenExcelSpreadsheet}

                dtCreateExcelSpreadsheet :
                  try
                    DocumentType := dtExcel;

                    CreateExcelDocument(ExcelApplication, lcID);
                    DocumentActive := True;
                    GlblApplicationIsActive := False;
                    OLEItemNameTimer.Enabled := True;

                  except
                    MessageDlg('Sorry, there was an problem linking with Excel.' + #13 +
                               'Please try again.', mtError, [mbOK], 0);
                    Cancel;
                  end;  {dtCreateExcelSpreadsheet}

                dtOpenPDFDocument :
                  If OpenPDFDialog.Execute
                    then
                      begin
                        DocumentLocation := OpenPDFDialog.FileName;
                        DocumentType := dtAdobePDF;
                      end
                    else Cancel;

              end;  {case DocumentTypeSelected of}

            end;  {with tb_CertiorariDocuments do}

          If not Cancelled
            then
              begin
                _SetRange(tb_CertiorariDocumentsLookup,
                          [SwisSBLKey, 0], [SwisSBLKey, 9999], '', []);

                tb_CertiorariDocumentsLookup.First;

                If tb_CertiorariDocumentsLookup.EOF
                  then NextDocumentNumber := 1
                  else
                    begin
                      tb_CertiorariDocumentsLookup.Last;

                      NextDocumentNumber := tb_CertiorariDocumentsLookup.FieldByName('DocumentNumber').AsInteger + 1;

                    end;  {If tb_CertiorariDocumentsLookup.EOF}

                CurrentDocumentNumber := NextDocumentNumber;
                CurrentDocumentType := DocumentType;

                with tb_CertiorariDocuments do
                  try
                    Insert;
                    FieldByName('DocumentNumber').AsInteger := NextDocumentNumber;
                    FieldByName('DocumentLocation').AsString := DocumentLocation;
                    FieldByName('DocumentType').AsInteger := DocumentType;
                    FieldByName('Date').AsDateTime := Date;
                    FieldByName('SwisSBLKey').AsString := SwisSBLKey;
                    Post;
                  except
                  end;

                LoadCertiorariDocuments(lv_CertiorariDocuments, tb_CertiorariDocuments,
                                        tb_DocumentType, tbs_CertiorariDocuments, SwisSBLKey);
                                        
              end;  {If not Cancelled}

        end;  {If (DocumentTypeDialogForm.ModalResult = idOK)}

  finally
    DocumentTypeDialogForm.Free;
  end;

end;  {btn_NewDocumentClick}

{==============================================================}
Procedure TCertiorariForm.btn_DeleteDocumentClick(Sender: TObject);

var
  DocumentNumber : Integer;

begin
  try
    DocumentNumber := StrToInt(GetColumnValueForItem(lv_CertiorariDocuments, 0, -1));
  except
    DocumentNumber := 0;
  end;

  If (_Compare(DocumentNumber, 0, coGreaterThan) and
      _Locate(tb_CertiorariDocuments, [SwisSBLKey, DocumentNumber], '', []) and
      (MessageDlg('Are you sure you want to delete the link to this document?', mtConfirmation,
                  [mbYes, mbNo], 0) = idYes))
    then
      try
        If (MessageDlg('Do you want to delete the actual document also?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            try
              DeleteFile(PChar(tb_CertiorariDocuments.FieldByName('DocumentLocation').AsString));
            except
              MessageDlg('There was an error deleting the document.' + #13 +
                         'Please remove it manually.', mtError, [mbOK], 0);
            end
          else MessageDlg('Please note that only the link was deleted, not the actual document.', mtWarning, [mbOK], 0);

        tb_CertiorariDocuments.Delete;

      except
        SystemSupport(005, tb_CertiorariDocuments, 'Error deleting document link.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {btn_DeleteDocumentClick}

{==============================================================}
Procedure TCertiorariForm.btn_FullScreenClick(Sender: TObject);

var
  FullScreenForm : TFullScreenViewForm;
  FileName : OLEVariant;
  DocumentNumber : Integer;

begin
  try
    DocumentNumber := StrToInt(GetColumnValueForItem(lv_CertiorariDocuments, 0, -1));
  except
    DocumentNumber := 0;
  end;

  If (_Compare(DocumentNumber, 0, coGreaterThan) and
      _Locate(tb_CertiorariDocuments, [SwisSBLKey, DocumentNumber], '', []))
    then
      begin
        FileName := tb_CertiorariDocuments.FieldByName('DocumentLocation').Text;
        FullScreenForm := nil;

        case tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger of
          0,
          dtScannedImage :
            try
              FullScreenForm := TFullScreenViewForm.Create(self);
              FullScreenForm.Image.ImageName := tb_CertiorariDocuments.FieldByName('DocumentLocation').Text;
              FullScreenForm.Image.ImageLibPalette := False;
              FullScreenForm.ShowModal;
            finally
              FullScreenForm.Free;
            end;

          dtMSWord : OpenWordDocument(WordApplication, WordDocument, FileName);

          dtExcel : OpenExcelDocument(ExcelApplication, lcID, FileName);

          dtAdobePdf : ShellExecute(0, 'open',
                                    PChar(tb_CertiorariDocuments.FieldByName('DocumentLocation').Text),
                                    nil, nil, SW_NORMAL);

        end;  {case MainTable.FieldByName('DocumentType').AsInteger of}

      end;  {If (_Compare(DocumentNumber, 0, coGreaterThan) and ...}

end;  {btn_FullScreenClick}

{==============================================================}
Procedure TCertiorariForm.btn_PrintDocumentClick(Sender: TObject);

var
  FileName : OLEVariant;
  DocumentNumber : Integer;

begin
  try
    DocumentNumber := StrToInt(GetColumnValueForItem(lv_CertiorariDocuments, 0, -1));
  except
    DocumentNumber := 0;
  end;

  If (_Compare(DocumentNumber, 0, coGreaterThan) and
      _Locate(tb_CertiorariDocuments, [SwisSBLKey, DocumentNumber], '', []))
    then
      begin
        FileName := tb_CertiorariDocuments.FieldByName('DocumentLocation').AsString;

          {FXX02181999-2: The image is printing very small.}

        case tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger of
          0,
          dtScannedImage :
            If PrintDialog.Execute
              then
                begin
                  Printer.Refresh;
                  Image.Visible := True;
                  Image.ImageName := FileName;
                  PrintImage(Image, Handle, 0, 0, Printer.PageWidth, Printer.PageHeight,
                             0, 999, True);
                  Image.Visible := False;

                end;  {If PrintDialog.Execute}

          dtMSWord : PrintWordDocument(WordApplication, WordDocument, FileName);

          dtExcel : PrintExcelDocument(ExcelApplication, lcID, FileName);

        end;  {case MainTable.FieldByName('DocumentType').AsInteger of}

    end;  {If (_Compare(DocumentNumber, 0, coGreaterThan) and ...}

end;  {btn_PrintDocumentClick}

{==============================================================}
Procedure TCertiorariForm.OLEItemNameTimerTimer(Sender: TObject);

begin
  If GlblApplicationIsActive
    then OLEItemNameTimer.Enabled := False
    else
      begin
        _Locate(tb_CertiorariDocuments, [SwisSBLKey, CurrentDocumentNumber], '', []);

        with tb_CertiorariDocuments do
          try
            Edit;
            case FieldByName('DocumentType').AsInteger of
              dtMSWord : FieldByName('DocumentLocation').Text := WordDocument.FullName;
              dtExcel : FieldByName('DocumentLocation').Text := ExcelApplication.ActiveWorkbook.FullName[lcID];
            end;  {case tb_CertiorariDocuments.FieldByName('DocumentType').AsInteger of}

            Post;
          except
          end;

        LoadCertiorariDocuments(lv_CertiorariDocuments, tb_CertiorariDocuments,
                                tb_DocumentType, tbs_CertiorariDocuments, SwisSBLKey);

      end;  {else of If GlblApplicationIsActive}

end;  {OLEItemNameTimerTimer}

{==============================================================}
Procedure TCertiorariForm.FormResize(Sender: TObject);

var
  iAvailableSpace, iSpacing : Integer;

begin
  iAvailableSpace := pnl_Buttons.Width -
                     (NewCertiorariButton.Width +
                      DeleteCertiorariButton.Width +
                      RenumberCertiorariButton.Width +
                      CopyCertiorariButton.Width +
                      CloseButton.Width);

  iSpacing := iAvailableSpace DIV 6;

  NewCertiorariButton.Left := iSpacing;
  DeleteCertiorariButton.Left := NewCertiorariButton.Left + NewCertiorariButton.Width + iSpacing;
  RenumberCertiorariButton.Left := DeleteCertiorariButton.Left + DeleteCertiorariButton.Width + iSpacing;
  CopyCertiorariButton.Left := RenumberCertiorariButton.Left + RenumberCertiorariButton.Width + iSpacing;
  CloseButton.Left := CopyCertiorariButton.Left + CopyCertiorariButton.Width + iSpacing;

  If (MainTable.Active and
      (CertiorariGrid.Width <> iOriginalGridWidth))
    then
      begin
        ResizeGridFontForWidthChange(CertiorariGrid, iOriginalGridWidth);

        iOriginalGridWidth := CertiorariGrid.Width;

      end;

end;  {FormResize}

{==============================================================}
Procedure TCertiorariForm.CloseButtonClick(Sender: TObject);

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
Procedure TCertiorariForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
    {Close all tables here.}

  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}

end.
