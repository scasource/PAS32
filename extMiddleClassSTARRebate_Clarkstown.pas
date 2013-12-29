unit extMiddleClassSTARRebate_Clarkstown;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  TabNotBk, Types, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Progress,
  RPTXFilr, ComCtrls, Math;

type
  TotalsRecord = record
    STARAdded : Integer;
    NewParcel : Integer;
    STARRemoved : Integer;
    ParcelInactivated : Integer;
    STARChanged_BasicToEnhanced : Integer;
    STARChanged_EnhancedToBasic : Integer;
    OwnerOrAddressChange : Integer;
  end;

  TfmMiddleClassSTARRebateExtract = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    Label11: TLabel;
    Label12: TLabel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    PageControl1: TPageControl;
    OptionsTabSheet: TTabSheet;
    Swis_School_RS_TabSheet: TTabSheet;
    Label15: TLabel;
    Label9: TLabel;
    Label18: TLabel;
    lbxRollSection: TListBox;
    lbxSwisCode: TListBox;
    lbxSchoolCode: TListBox;
    tbParcels: TTable;
    tbBillParcels: TTable;
    tbSwisCode: TTable;
    tbSchoolCode: TTable;
    Panel3: TPanel;
    btnStart: TBitBtn;
    btnClose: TBitBtn;
    tbSort: TTable;
    tbExemptions: TTable;
    tbBillExemptions: TTable;
    tbBillCollectionDetails: TTable;
    GroupBox1: TGroupBox;
    cbxCreateParcelList: TCheckBox;
    cbxExtractToExcel: TCheckBox;
    cbxPrintDetails: TCheckBox;
    rgOutputOptions: TRadioGroup;
    rgComparisonYear: TRadioGroup;
    dlgSave: TSaveDialog;
    tbNYParcels: TTable;
    cbxCompareToBillingFiles: TCheckBox;
    rgBillingCycleType: TRadioGroup;
    tbHistoryParcels: TTable;
    tbHistoryExemptions: TTable;    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnStartClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    bReportCancelled, bCreateParcelList,
    bPrintDetails, bExtractToExcel, bCompareToBillingFiles : Boolean;
    sOrigSortFileName, sCollectionType,
    sHistoryYear, sAssessmentYear, sBillingYear : String;
    iProcessingType, iReportType : Integer;
    slSelectedSchoolCodes, slSelectedSwisCodes,
    slSelectedRollSections, slSchoolCollections : TStringList;
    flExtractFile : TextFile;
    rTotalsRec : TotalsRecord;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure FillListBoxes;

    Procedure FillSortFileFromBillingFiles;

    Procedure FillSortFileFromHistory;

    Function ParcelMeetsBaseCriteria(tbParcels : TTable;
                                     sAssessmentYear : String;
                                     sSchoolCode : String) : Boolean;

    Function ParcelMeetsChangeCriteria(    tbParcels : TTable;
                                           tbExemptions : TTable;
                                           tbBillParcels : TTable;
                                           tbBillExemptions : TTable;
                                           sAssessmentYear : String;
                                           sBillingYear : String;
                                           sCollectionType : String;
                                           slSchoolCollections : TStringList;
                                       var sCurrentSTARCode : String;
                                       var iChangeType : Integer) : Boolean;

    Function ParcelMeetsChangeCriteria_History(    tbParcels : TTable;
                                                   tbExemptions : TTable;
                                                   tbHistoryParcels : TTable;
                                                   tbHistoryExemptions : TTable;
                                                   sAssessmentYear : String;
                                                   sHistoryYear : String;
                                               var sCurrentSTARCode : String;
                                               var iChangeType : Integer) : Boolean;

    Procedure InsertOneSortRecord(tbSort : TTable;
                                  tbParcels : TTable;
                                  tbNYParcels : TTable;
                                  sSwisSBLKey : String;
                                  sAsssessmentYear : String;
                                  sCurrentSTARCode : String;
                                  iChangeType : Integer;
                                  iParcelSource : Integer);

    {$H+}
    Procedure CreateSTARChangeExtractFile(    tbSort : TTable;
                                              iReportType : Integer;
                                              bExtractToExcel : Boolean;
                                          var flExtractFile : TextFile);
    {$H-}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, UTILEXSD, GlblCnst, PASUtils, UtilBill,
     PRCLLIST,  {Parcel list}
     Prog, RptDialg,
     Preview, PASTypes, DataAccessUnit;

{$R *.DFM}

const
  ctNone = 0;
  ctSTARAdded = 10;
  ctNewParcel = 11;
  ctSTARRemoved = 20;
  ctParcelInactivated = 21;
  ctSTARChanged_BasicToEnhanced = 30;
  ctSTARChanged_EnhancedToBasic = 31;
  ctOwnerOrAddressChange = 32;

  ayThisYear = 0;
  ayNextYear = 1;

  rtReportAndExtract = 0;
  rtExtract = 1;
  rtReport = 2;

  psParcels = 0;
  psBillingParcels = 1;

{========================================================}
Function GetChangeTypeDescription(iChangeType : Integer) : String;

begin
  Result := 'None';

  case iChangeType of
    ctSTARAdded : Result := 'STAR Added';
    ctNewParcel : Result := 'New Parcel';
    ctSTARRemoved : Result := 'STAR Removed';
    ctParcelInactivated : Result := 'Deleted Parcel';
    ctSTARChanged_BasicToEnhanced : Result := 'Basic to Enhanced';
    ctSTARChanged_EnhancedToBasic : Result := 'Enhanced to Basic';
    ctOwnerOrAddressChange : Result := 'Owner \ Address Change';

  end;  {case iChangeType of}

end;  {GetChangeTypeDescription}

{========================================================}
Function GetSTARCode(iSTARCode : Integer) : String;

begin
  Result := '';

  case iSTARCode of
    1 : Result := BasicSTARExemptionCode;
    2 : Result := EnhancedSTARExemptionCode;
  end;

end;  {GetSTARCode}

{========================================================}
Procedure TfmMiddleClassSTARRebateExtract.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TfmMiddleClassSTARRebateExtract.FillListBoxes;

var
  bQuit : Boolean;

begin
  OpenTableForProcessingType(tbSchoolCode, SchoolCodeTableName,
                             iProcessingType, bQuit);

  OpenTableForProcessingType(tbSwisCode, SwisCodeTableName,
                             iProcessingType, bQuit);

  FillOneListBox(lbxSwisCode, tbSwisCode, 'SwisCode',
                 'MunicipalityName', 25, True, True, iProcessingType, sAssessmentYear);

  FillOneListBox(lbxSchoolCode, tbSchoolCode, 'SchoolCode',
                 'SchoolName', 25, True, True, iProcessingType, sAssessmentYear);

  SelectItemsInListBox(lbxRollSection);

end;  {FillListBoxes}

{========================================================}
Procedure TfmMiddleClassSTARRebateExtract.InitializeForm;

begin
  UnitName := 'extMiddleClassSTARRebate';

  slSelectedRollSections := TStringList.Create;
  slSelectedSwisCodes := TStringList.Create;
  slSelectedSchoolCodes := TStringList.Create;
  slSchoolCollections := TStringList.Create;

  with rgComparisonYear do
(*    If GlblIsWestchesterCounty
      then
        begin
          ItemIndex := ayNextYear;
          sAssessmentYear := GlblNextYear;
        end
      else *)
        begin
          ItemIndex := ayThisYear;
          sAssessmentYear := GlblThisYear;
        end;

  FillListBoxes;

end;  {InitializeForm}

{===================================================================}
Procedure TfmMiddleClassSTARRebateExtract.FormKeyPress(    Sender: TObject;
                                                       var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{==============================================================}
Function TfmMiddleClassSTARRebateExtract.ParcelMeetsBaseCriteria(tbParcels : TTable;
                                                                 sAssessmentYear : String;
                                                                 sSchoolCode : String) : Boolean;

begin
  with tbParcels do
    Result := ((slSelectedRollSections.IndexOf(FieldByName('RollSection').AsString) > -1) and
               (slSelectedSchoolCodes.IndexOf(sSchoolCode) > -1) and
               (slSelectedSwisCodes.IndexOf(FieldByName('SwisCode').AsString) > -1) and
               (FieldByName('TaxRollYr').AsString = sAssessmentYear));

end;  {ParceMeetsBaseCriteria}

{==============================================================}
Function GetYearOfLastCollection(tbBillCollectionDetails : TTable;
                                 sTaxType : String) : String;

begin
  with tbBillCollectionDetails do
    begin
      Filtered := False;
      Filter := 'CollectionType=' + FormatFilterString(sTaxType);
      Filtered := True;
      Last;
      Result := FieldByName('TaxRollYr').AsString;

    end;  {with tbBillCollectionDetails do}

end;  {GetYearOfLastCollection}

{==============================================================}
Function OpenBillingFile(tbBilling : TTable;
                         sBillingTableBaseName : String;
                         sBillingYear : String;
                         sCollectionType : String;
                         sSchoolCode : String;
                         slSchoolCollections : TStringList) : Boolean;

var
  iCollectionNumber : Integer;

begin
  Result := False;
  iCollectionNumber := slSchoolCollections.IndexOf(sSchoolCode) + 1;

  If _Compare(iCollectionNumber, 0, coGreaterThan)
    then
      with tbBilling do
        try
          Close;
          TableName := GetBillingFileName(sBillingTableBaseName, sBillingYear,
                                          sCollectionType, IntToStr(iCollectionNumber));
          Open;
          Result := True;

        except
          Result := False;
          SystemSupport(1, tbBilling, 'Error opening ' + TableName + '.', 'extMiddleClassSTARRebate', GlblErrorDlgBox);
        end;

end;  {OpenBillingFile}

{==============================================================}
Function LocateParcelInBillingFile(tbBillParcels : TTable;
                                   sSwisSBLKey : String;
                                   sSchoolCode : String;
                                   sBillingYear : String;
                                   sCollectionType : String;
                                   slSchoolCollections : TStringList) : Boolean;

begin
  Result := False;

  If OpenBillingFile(tbBillParcels, blBillingParcelBaseName,
                     sBillingYear, sCollectionType, sSchoolCode, slSchoolCollections)
    then Result := _Locate(tbBillParcels,
                           [sSchoolCode, Copy(sSwisSBLKey, 1, 6), Copy(sSwisSBLKey, 7, 20)], '', []);

end;  {LocateParcelInBillingFile}

{==============================================================}
Procedure CheckForSTARChanges(    tbExemptions : TTable;
                                  tbBillExemptions : TTable;
                                  sSwisSBLKey : String;
                                  sSchoolCode : String;
                                  sAssessmentYear : String;
                                  sBillingYear : String;
                                  sCollectionType : String;
                                  slSchoolCollections : TStringList;
                              var sCurrentSTARCode : String;
                              var iChangeType : Integer);

var
  bBasicSTARPrior, bEnhancedSTARPrior,
  bBasicSTARCurrent, bEnhancedSTARCurrent : Boolean;

begin
  sCurrentSTARCode := '';

  If OpenBillingFile(tbBillExemptions, blBillingExemptionBaseName,
                     sBillingYear, sCollectionType, sSchoolCode, slSchoolCollections)
    then
      begin
        bBasicSTARPrior := (_Locate(tbBillExemptions, [sSwisSBLKey, BasicSTARExemptionCode, 'H'], '', []) or
                            _Locate(tbBillExemptions, [sSwisSBLKey, BasicSTARExemptionCode, 'N'], '', []) or
                            _Locate(tbBillExemptions, [sSwisSBLKey, BasicSTARExemptionCode, ''], '', []));
        bEnhancedSTARPrior := (_Locate(tbBillExemptions, [sSwisSBLKey, EnhancedSTARExemptionCode, 'H'], '', []) or
                               _Locate(tbBillExemptions, [sSwisSBLKey, EnhancedSTARExemptionCode, 'N'], '', []) or
                               _Locate(tbBillExemptions, [sSwisSBLKey, EnhancedSTARExemptionCode, ''], '', []));
        bBasicSTARCurrent := _Locate(tbExemptions, [sAssessmentYear, sSwisSBLKey, BasicSTARExemptionCode], '', []);
        bEnhancedSTARCurrent := _Locate(tbExemptions, [sAssessmentYear, sSwisSBLKey, EnhancedSTARExemptionCode], '', []);

        If bBasicSTARCurrent
          then sCurrentSTARCode := BasicSTARExemptionCode;

        If bEnhancedSTARCurrent
          then sCurrentSTARCode := EnhancedSTARExemptionCode;

        If ((bBasicSTARCurrent or bEnhancedSTARCurrent) and
            not (bBasicSTARPrior or bEnhancedSTARPrior))
          then iChangeType := ctSTARAdded;

        If ((bBasicSTARPrior or bEnhancedSTARPrior) and
            not (bBasicSTARCurrent or bEnhancedSTARCurrent))
          then
            begin
              iChangeType := ctSTARRemoved;

              If bBasicSTARPrior
                then sCurrentSTARCode := BasicSTARExemptionCode
                else sCurrentSTARCode := EnhancedSTARExemptionCode;

            end;  {If ((bBasicSTARPrior or bEnhancedSTARPrior)...}

        If (bBasicSTARPrior and
            (not bBasicSTARCurrent) and
            bEnhancedSTARCurrent)
          then iChangeType := ctSTARChanged_BasicToEnhanced;

        If (bEnhancedSTARPrior and
            (not bEnhancedSTARCurrent) and
            bBasicSTARCurrent)
          then iChangeType := ctSTARChanged_EnhancedToBasic;

      end;  {If OpenBillingFile...}

end;  {CheckForSTARChanges}

{==============================================================}
Procedure CheckForSTARChanges_History(    tbExemptions : TTable;
                                          tbHistoryExemptions : TTable;
                                          sSwisSBLKey : String;
                                          sAssessmentYear : String;
                                          sHistoryYear : String;
                                      var sCurrentSTARCode : String;
                                      var iChangeType : Integer);

var
  bBasicSTARPrior, bEnhancedSTARPrior,
  bBasicSTARCurrent, bEnhancedSTARCurrent : Boolean;

begin
  sCurrentSTARCode := '';

  bBasicSTARPrior := _Locate(tbHistoryExemptions, [sHistoryYear, sSwisSBLKey, BasicSTARExemptionCode], '', []);
  bEnhancedSTARPrior := _Locate(tbHistoryExemptions, [sHistoryYear, sSwisSBLKey, EnhancedSTARExemptionCode], '', []);
  bBasicSTARCurrent := _Locate(tbExemptions, [sAssessmentYear, sSwisSBLKey, BasicSTARExemptionCode], '', []);
  bEnhancedSTARCurrent := _Locate(tbExemptions, [sAssessmentYear, sSwisSBLKey, EnhancedSTARExemptionCode], '', []);

  If bBasicSTARCurrent
    then sCurrentSTARCode := BasicSTARExemptionCode;

  If bEnhancedSTARCurrent
    then sCurrentSTARCode := EnhancedSTARExemptionCode;

  If ((bBasicSTARCurrent or bEnhancedSTARCurrent) and
      not (bBasicSTARPrior or bEnhancedSTARPrior))
    then iChangeType := ctSTARAdded;

  If ((bBasicSTARPrior or bEnhancedSTARPrior) and
      not (bBasicSTARCurrent or bEnhancedSTARCurrent))
    then
      begin
        iChangeType := ctSTARRemoved;

        If bBasicSTARPrior
          then sCurrentSTARCode := BasicSTARExemptionCode
          else sCurrentSTARCode := EnhancedSTARExemptionCode;

      end;  {If ((bBasicSTARPrior or bEnhancedSTARPrior)...}

  If (bBasicSTARPrior and
      (not bBasicSTARCurrent) and
      bEnhancedSTARCurrent)
    then iChangeType := ctSTARChanged_BasicToEnhanced;

  If (bEnhancedSTARPrior and
      (not bEnhancedSTARCurrent) and
      bBasicSTARCurrent)
    then iChangeType := ctSTARChanged_EnhancedToBasic;

end;  {CheckForSTARChanges_History}

{==============================================================}
Procedure CheckForOwnerOrAddressChange(    tbParcels : TTable;
                                           tbPriorParcels : TTable;
                                       var iChangeType : Integer);

var
  PriorNameAddressInfo, CurrentNameAddressInfo : NameAddressRecord;

begin
  CurrentNameAddressInfo := GetNameAddressInfo(tbParcels);
  PriorNameAddressInfo := GetNameAddressInfo(tbPriorParcels);

  If NameAddressInfoChanged(PriorNameAddressInfo, CurrentNameAddressInfo)
    then iChangeType := ctOwnerOrAddressChange;

end;  {CheckForOwnerOrAddressChange}

{==============================================================}
Function TfmMiddleClassSTARRebateExtract.ParcelMeetsChangeCriteria(    tbParcels : TTable;
                                                                       tbExemptions : TTable;
                                                                       tbBillParcels : TTable;
                                                                       tbBillExemptions : TTable;
                                                                       sAssessmentYear : String;
                                                                       sBillingYear : String;
                                                                       sCollectionType : String;
                                                                       slSchoolCollections : TStringList;
                                                                   var sCurrentSTARCode : String;
                                                                   var iChangeType : Integer) : Boolean;

var
  sSwisSBLKey, sSchoolCode : String;
  bBasicSTARCurrent, bEnhancedSTARCurrent : Boolean;
  tbTempParcels : TTable;

begin
  sCurrentSTARCode := '';
  sSwisSBLKey := ExtractSSKey(tbParcels);
  sSchoolCode := tbParcels.FieldByName('SchoolCode').AsString;
  iChangeType := ctNone;

  If LocateParcelInBillingFile(tbBillParcels, sSwisSBLKey, sSchoolCode,
                               sBillingYear, sCollectionType, slSchoolCollections)
    then
      begin
        CheckForSTARChanges(tbExemptions, tbBillExemptions, sSwisSBLKey, sSchoolCode,
                            sAssessmentYear, sBillingYear, sCollectionType,
                            slSchoolCollections, sCurrentSTARCode, iChangeType);

        If _Locate(tbNYParcels, [GlblNextYear, sSwisSBLKey], '', [loParseSwisSBLKey])
          then tbTempParcels := tbNYParcels
          else tbTempParcels := tbParcels;

        If (_Compare(sCurrentSTARCode, coNotBlank) and
            _Compare(iChangeType, ctNone, coEqual))
          then CheckForOwnerOrAddressChange(tbTempParcels, tbBillParcels, iChangeType);
      end
    else
      begin
        bBasicSTARCurrent := _Locate(tbExemptions, [sAssessmentYear, sSwisSBLKey, BasicSTARExemptionCode], '', []);
        bEnhancedSTARCurrent := _Locate(tbExemptions, [sAssessmentYear, sSwisSBLKey, EnhancedSTARExemptionCode], '', []);

        If (bBasicSTARCurrent or bEnhancedSTARCurrent)
          then iChangeType := ctNewParcel;

      end;  {else of If LocateParcelInBillingFile...}

  Result := _Compare(iChangeType, ctNone, coNotEqual);

end;  {ParcelMeetsChangeCriteria}

{==============================================================}
Function TfmMiddleClassSTARRebateExtract.ParcelMeetsChangeCriteria_History(    tbParcels : TTable;
                                                                               tbExemptions : TTable;
                                                                               tbHistoryParcels : TTable;
                                                                               tbHistoryExemptions : TTable;
                                                                               sAssessmentYear : String;
                                                                               sHistoryYear : String;
                                                                           var sCurrentSTARCode : String;
                                                                           var iChangeType : Integer) : Boolean;

var
  sSwisSBLKey, sSchoolCode : String;
  bBasicSTARCurrent, bEnhancedSTARCurrent : Boolean;
  tbTempParcels : TTable;

begin
  sCurrentSTARCode := '';
  sSwisSBLKey := ExtractSSKey(tbParcels);
  sSchoolCode := tbParcels.FieldByName('SchoolCode').AsString;
  iChangeType := ctNone;

  If _Locate(tbHistoryParcels, [sHistoryYear, sSwisSBLKey], '', [loParseSwisSBLKey])
    then
      begin
        CheckForSTARChanges_History(tbExemptions, tbHistoryExemptions, sSwisSBLKey,
                                    sAssessmentYear, sHistoryYear,
                                    sCurrentSTARCode, iChangeType);

        If _Locate(tbNYParcels, [GlblNextYear, sSwisSBLKey], '', [loParseSwisSBLKey])
          then tbTempParcels := tbNYParcels
          else tbTempParcels := tbParcels;

        If (_Compare(sCurrentSTARCode, coNotBlank) and
            _Compare(iChangeType, ctNone, coEqual))
          then CheckForOwnerOrAddressChange(tbTempParcels, tbHistoryParcels, iChangeType);
      end
    else
      begin
        bBasicSTARCurrent := _Locate(tbExemptions, [sAssessmentYear, sSwisSBLKey, BasicSTARExemptionCode], '', []);
        bEnhancedSTARCurrent := _Locate(tbExemptions, [sAssessmentYear, sSwisSBLKey, EnhancedSTARExemptionCode], '', []);

        If (bBasicSTARCurrent or bEnhancedSTARCurrent)
          then iChangeType := ctNewParcel;

      end;  {else of If _Locate(tbHistoryParcels...}

  Result := _Compare(iChangeType, ctNone, coNotEqual);

end;  {ParcelMeetsChangeCriteria_History}

{==============================================================}
Procedure TfmMiddleClassSTARRebateExtract.InsertOneSortRecord(tbSort : TTable;
                                                              tbParcels : TTable;
                                                              tbNYParcels : TTable;
                                                              sSwisSBLKey : String;
                                                              sAsssessmentYear : String;
                                                              sCurrentSTARCode : String;
                                                              iChangeType : Integer;
                                                              iParcelSource : Integer);

var
  sSTARCode, sChangeType : String;
  tbTempParcels : TTable;

begin
  If _Compare(iParcelSource, psParcels, coEqual)
    then
      begin
        If _Locate(tbNYParcels, [GlblNextYear, sSwisSBLKey], '', [loParseSwisSBLKey])
          then tbTempParcels := tbNYParcels
          else tbTempParcels := tbParcels;
      end
    else tbTempParcels := tbParcels;  {Billing file}

  If _Compare(sCurrentSTARCode, BasicSTARExemptionCode, coEqual)
    then sSTARCode := '1'
    else sSTARCode := '2';

  case iChangeType of
    ctSTARChanged_BasicToEnhanced,
    ctSTARChanged_EnhancedToBasic : sChangeType := 'X';
    ctSTARAdded, ctNewParcel : sChangeType := 'A';
    ctSTARRemoved, ctParcelInactivated : sChangeType := 'D';
    else sChangeType := 'C';
  end;

  with tbSort do
    try
      Insert;
      FieldByName('SwisSBLKey').AsString := sSwisSBLKey;
      FieldByName('Muni_Code').AsString := Copy(sSwisSBLKey, 1, 4) + '00';
      FieldByName('Swis_Code').AsString := Copy(sSwisSBLKey, 1, 6);
      FieldByName('Print_Key').AsString := ConvertSBLOnlyToDashDot(Copy(sSwisSBLKey, 7, 20));

      If _Compare(iParcelSource, psParcels, coEqual)
        then
          begin
            FieldByName('Section').AsString := tbParcels.FieldByName('Section').AsString;
            FieldByName('Sub_Sec').AsString := tbParcels.FieldByName('Subsection').AsString;
            FieldByName('Block').AsString := tbParcels.FieldByName('Block').AsString;
            FieldByName('Lot').AsString := tbParcels.FieldByName('Lot').AsString;
            FieldByName('Sub_Lot').AsString := tbParcels.FieldByName('Sublot').AsString;
            FieldByName('Suffix').AsString := tbParcels.FieldByName('Suffix').AsString;
          end
        else
          begin
            FieldByName('Section').AsString := Copy(sSwisSBLKey, 7, 3);
            FieldByName('Sub_Sec').AsString := Copy(sSwisSBLKey, 10, 3);
            FieldByName('Block').AsString := Copy(sSwisSBLKey, 13, 4);
            FieldByName('Lot').AsString := Copy(sSwisSBLKey, 17, 3);
            FieldByName('Sub_Lot').AsString := Copy(sSwisSBLKey, 20, 3);
            FieldByName('Suffix').AsString := Copy(sSwisSBLKey, 3, 4);

          end;  {else of If _Compare(iParcelSource, psParcel, coEqual)}

      FieldByName('Last_Name_1').AsString := tbTempParcels.FieldByName('Name1').AsString;
      FieldByName('Last_Name_2').AsString := tbTempParcels.FieldByName('Name2').AsString;
      FieldByName('Parcel_St_Nmbr').AsString := tbParcels.FieldByName('LegalAddrNo').AsString;
      FieldByName('Parcel_St_Name').AsString := tbParcels.FieldByName('LegalAddr').AsString;
      FieldByName('Parcel_Muni_Name').AsString := GlblMunicipalityName;
      FieldByName('Mail_St_Rte').AsString := tbTempParcels.FieldByName('Street').AsString;
      FieldByName('Mail_City').AsString := tbTempParcels.FieldByName('City').AsString;
      FieldByName('State_Addr').AsString := tbTempParcels.FieldByName('State').AsString;
      FieldByName('Mail_Zip').AsString := CreateMailingZipCode(tbTempParcels.FieldByName('Zip').AsString,
                                                               tbTempParcels.FieldByName('ZipPlus4').AsString);
      FieldByName('PO_Box').AsString := GetPOBox(tbTempParcels);
      FieldByName('STAR_Ex_Type').AsString := sSTARCode;
      FieldByName('Prop_Class').AsString := tbParcels.FieldByName('PropertyClassCode').AsString;

      If _Compare(iParcelSource, psParcels, coEqual)
        then FieldByName('Own_Cd').AsString := tbParcels.FieldByName('OwnershipCode').AsString;

      FieldByName('Roll_Year').AsString := sAssessmentYear;

      If _Compare(iParcelSource, psParcels, coEqual)
        then FieldByName('Sch_Dist_Cd').AsString := tbParcels.FieldByName('SchoolCode').AsString
        else FieldByName('Sch_Dist_Cd').AsString := tbParcels.FieldByName('SchoolCodeKey').AsString;

      FieldByName('Source_Cd').AsString := 'A';
      FieldByName('Change_CD').AsString := sChangeType;
      FieldByName('ChangeType').AsInteger := iChangeType;
      Post;
    except
    end;

end;  {InsertOneSortRecord}

{==============================================================}
Procedure TfmMiddleClassSTARRebateExtract.FillSortFileFromBillingFiles;

{This is a 2 stage process.
 1. Go through the parcels and compare to the corresponding billing file.  Add any changes to sort file.
 2. Go through the billing file and look for parcels that exist in the billing file, but not the current roll.}

var
  sSwisSBLKey, sCurrentSTARCode, sPriorSTARCode : String;
  iChangeType : Integer;
  bBasicSTARPrior, bEnhancedSTARPrior, bParcelExistsCurrent : Boolean;

begin
  ProgressDialog.UserLabelCaption := 'Filling sort file - pass 1.';
  ProgressDialog.Start(tbParcels.RecordCount, True, True);

  tbParcels.First;

  with tbParcels do
    while (not (EOF or bReportCancelled)) do
      begin
        sSwisSBLKey := ExtractSSKey(tbParcels);
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(sSwisSBLKey));
        Application.ProcessMessages;

        If (ParcelMeetsBaseCriteria(tbParcels, sAssessmentYear,
                                    FieldByName('SchoolCode').AsString) and
            ParcelMeetsChangeCriteria(tbParcels, tbExemptions,
                                      tbBillParcels, tbBillExemptions,
                                      sAssessmentYear, sBillingYear,
                                      sCollectionType, slSchoolCollections,
                                      sCurrentSTARCode, iChangeType))
          then InsertOneSortRecord(tbSort, tbParcels, tbNYParcels,
                                   sSwisSBLKey, sAssessmentYear,
                                   sCurrentSTARCode, iChangeType, psParcels);

        Next;

        bReportCancelled := ProgressDialog.Cancelled;

      end;  {while (not (EOF or ReportCancelled)) do}

    {Now check the other way around - for parcels that got deleted.}

  If not bReportCancelled
    then
      begin
        ProgressDialog.UserLabelCaption := 'Filling sort file - pass 2.';
        ProgressDialog.Reset;
        ProgressDialog.TotalNumRecords := tbBillParcels.RecordCount;

        tbBillParcels.First;

        with tbBillParcels do
          while (not (EOF or bReportCancelled)) do
            begin
              sSwisSBLKey := FieldByName('SwisCode').AsString + FieldByName('SBLKey').AsString;
              ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(sSwisSBLKey));
              Application.ProcessMessages;
              bParcelExistsCurrent := _Locate(tbParcels, [sAssessmentYear, sSwisSBLKey], '', [loParseSwisSBLKey]);

              If (ParcelMeetsBaseCriteria(tbBillParcels, sBillingYear,
                                          FieldByName('SchoolCodeKey').AsString) and
                  ((not bParcelExistsCurrent) or
                   (not ParcelIsActive(tbParcels))))
                then
                  begin
                    sPriorSTARCode := '';

                    If OpenBillingFile(tbBillExemptions, blBillingExemptionBaseName,
                                       sBillingYear, sCollectionType,
                                       FieldByName('SchoolCodeKey').AsString, slSchoolCollections)
                      then
                        begin
                          bBasicSTARPrior := _Locate(tbBillExemptions, [sSwisSBLKey, BasicSTARExemptionCode, 'H'], '', []);
                          bEnhancedSTARPrior := _Locate(tbBillExemptions, [sSwisSBLKey, EnhancedSTARExemptionCode, 'H'], '', []);

                          If bBasicSTARPrior
                            then sPriorSTARCode := BasicSTARExemptionCode;

                          If bEnhancedSTARPrior
                            then sPriorSTARCode := EnhancedSTARExemptionCode;

                        end;  {If OpenBillingFile ...}

                    If _Compare(sPriorSTARCode, coNotBlank)
                      then InsertOneSortRecord(tbSort, tbBillParcels, tbNYParcels,
                                               sSwisSBLKey, sAssessmentYear,
                                               sPriorSTARCode, ctParcelInactivated, psBillingParcels);

                  end;  {If (ParcelMeetsBaseCriteria ...}

              Next;

              bReportCancelled := ProgressDialog.Cancelled;

            end;  {while (not (EOF or ReportCancelled)) do}

      end;  {If not bReportCancelled}

end;  {FillSortFileFromBillingFiles}

{==============================================================}
Procedure TfmMiddleClassSTARRebateExtract.FillSortFileFromHistory;

{This is a 2 stage process.
 1. Go through the parcels and compare to the corresponding billing file.  Add any changes to sort file.
 2. Go through the billing file and look for parcels that exist in the billing file, but not the current roll.}

var
  sSwisSBLKey, sCurrentSTARCode, sPriorSTARCode : String;
  iChangeType : Integer;
  bBasicSTARPrior, bEnhancedSTARPrior, bParcelExistsCurrent : Boolean;

begin
  ProgressDialog.UserLabelCaption := 'Filling sort file - pass 1.';
  ProgressDialog.Start(tbParcels.RecordCount, True, True);

  tbParcels.First;

  with tbParcels do
    while (not (EOF or bReportCancelled)) do
      begin
        sSwisSBLKey := ExtractSSKey(tbParcels);
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(sSwisSBLKey));
        Application.ProcessMessages;

        If (ParcelMeetsBaseCriteria(tbParcels, sAssessmentYear,
                                    FieldByName('SchoolCode').AsString) and
            ParcelMeetsChangeCriteria_History(tbParcels, tbExemptions,
                                              tbHistoryParcels, tbHistoryExemptions,
                                              sAssessmentYear, sHistoryYear,
                                              sCurrentSTARCode, iChangeType))
          then InsertOneSortRecord(tbSort, tbParcels, tbNYParcels,
                                   sSwisSBLKey, sAssessmentYear,
                                   sCurrentSTARCode, iChangeType, psParcels);

        Next;

        bReportCancelled := ProgressDialog.Cancelled;

      end;  {while (not (EOF or ReportCancelled)) do}

    {Now check the other way around - for parcels that got deleted.}

  If not bReportCancelled
    then
      begin
        ProgressDialog.UserLabelCaption := 'Filling sort file - pass 2.';
        ProgressDialog.Reset;
        _SetRange(tbHistoryParcels, [sHistoryYear, ''], [sHistoryYear, '99999'], '', [loParseSwisSBLKey]);
        ProgressDialog.TotalNumRecords := tbHistoryParcels.RecordCount;

        tbHistoryParcels.First;

        with tbHistoryParcels do
          while (not (EOF or bReportCancelled)) do
            begin
              sSwisSBLKey := ExtractSSKey(tbHistoryParcels);
              ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(sSwisSBLKey));
              Application.ProcessMessages;
              bParcelExistsCurrent := _Locate(tbParcels, [sAssessmentYear, sSwisSBLKey], '', [loParseSwisSBLKey]);

              If (ParcelMeetsBaseCriteria(tbHistoryParcels, sHistoryYear,
                                          FieldByName('SchoolCode').AsString) and
                  ((not bParcelExistsCurrent) or
                   (not ParcelIsActive(tbParcels))))
                then
                  begin
                    sPriorSTARCode := '';

                    bBasicSTARPrior := _Locate(tbHistoryExemptions, [sHistoryYear, sSwisSBLKey, BasicSTARExemptionCode], '', []);
                    bEnhancedSTARPrior := _Locate(tbHistoryExemptions, [sHistoryYear, sSwisSBLKey, EnhancedSTARExemptionCode], '', []);

                    If bBasicSTARPrior
                      then sPriorSTARCode := BasicSTARExemptionCode;

                    If bEnhancedSTARPrior
                      then sPriorSTARCode := EnhancedSTARExemptionCode;

                    If _Compare(sPriorSTARCode, coNotBlank)
                      then InsertOneSortRecord(tbSort, tbHistoryParcels, tbNYParcels,
                                               sSwisSBLKey, sAssessmentYear,
                                               sPriorSTARCode, ctParcelInactivated, psParcels);

                  end;  {If (ParcelMeetsBaseCriteria ...}

              Next;

              bReportCancelled := ProgressDialog.Cancelled;

            end;  {while (not (EOF or ReportCancelled)) do}

      end;  {If not bReportCancelled}

end;  {FillSortFileFromHistory}

{=================================================================}
Procedure ExtractOneLineToExcel(    tbSort : TTable;
                                var flExtractFile : TextFile);

begin
  with tbSort do
    WritelnCommaDelimitedLine(flExtractFile,
                              [FieldByName('Print_Key').AsString,
                               FieldByName('Last_Name_1').AsString,
                               GetSTARCode(FieldByName('STAR_EX_Type').AsInteger),
                               GetChangeTypeDescription(FieldByName('ChangeType').AsInteger)]);

end;  {ExtractOneLineToExcel}

{$H+}
{=================================================================}
Procedure TfmMiddleClassSTARRebateExtract.CreateSTARChangeExtractFile(    tbSort : TTable;
                                                                          iReportType : Integer;
                                                                          bExtractToExcel : Boolean;
                                                                      var flExtractFile : TextFile);

var
  flSTARExtractFile : TextFile;
  slSelectedFiles : TStringList;
  sDefaultExtractName, sZipFileName,
  sExtractDir, sMailSubject, sBody : String;
  wYear, wMonth, wDay : Word;

begin
  DecodeDate(Date, wYear, wMonth, wDay);

    {If the report is being printed, the Excel extract will be done through that.}

  If _Compare(iReportType, rtReportAndExtract, coEqual)
    then bExtractToExcel := False;

  If GlblIsCoopRoll
    then sDefaultExtractName := GlblMunicipalityName +
                                '_Coops_STARChangeExtract_' + IntToStr(wYear) + '.txt'
    else sDefaultExtractName := GlblMunicipalityName +
                                '_STARChangeExtract_' + IntToStr(wYear) + '.txt';

  with dlgSave do
    begin
      InitialDir := GlblExportDir;
      FileName := sDefaultExtractName;
    end;

  If dlgSave.Execute
    then
      with tbSort do
        begin
          AssignFile(flSTARExtractFile, dlgSave.FileName);
          Rewrite(flSTARExtractFile);

          First;

          while not (EOF or bReportCancelled) do
            begin
              Writeln(flSTARExtractFile, Take(6, FieldByName('Muni_Code').AsString),
                                         Take(6, FieldByName('Swis_Code').AsString),
                                         Take(35, FieldByName('Print_Key').AsString),
                                         Take(7, FieldByName('ORPS_ID').AsString),
                                         Take(3, FieldByName('Section').AsString),
                                         Take(3, FieldByName('Sub_Sec').AsString),
                                         Take(4, FieldByName('Block').AsString),
                                         Take(3, FieldByName('Lot').AsString),
                                         Take(3, FieldByName('Sub_Lot').AsString),
                                         Take(4, FieldByName('Suffix').AsString),
                                         Take(20, FieldByName('First_Name_1').AsString),
                                         Take(1, FieldByName('Middle_Initial_1').AsString),
                                         Take(30, FieldByName('Last_Name_1').AsString),
                                         Take(8, FieldByName('Suffix_Name_1').AsString),
                                         Take(20, FieldByName('First_Name_2').AsString),
                                         Take(1, FieldByName('Middle_Initial_2').AsString),
                                         Take(30, FieldByName('Last_Name_2').AsString),
                                         Take(8, FieldByName('Suffix_Name_2').AsString),
                                         Take(20, FieldByName('First_Name_3').AsString),
                                         Take(1, FieldByName('Middle_Initial_3').AsString),
                                         Take(30, FieldByName('Last_Name_3').AsString),
                                         Take(8, FieldByName('Suffix_Name_3').AsString),
                                         Take(30, FieldByName('Additional_Name').AsString),
                                         Take(2, FieldByName('Parcel_St_Side').AsString),
                                         Take(2, FieldByName('Parcel_St_Prefix').AsString),
                                         Take(10, FieldByName('Parcel_St_Nmbr').AsString),
                                         Take(30, FieldByName('Parcel_St_Name').AsString),
                                         Take(4, FieldByName('Parcel_St_Suff').AsString),
                                         Take(4, FieldByName('Parcel_Unit_Name').AsString),
                                         Take(10, FieldByName('Parcel_Unit_Nmbr').AsString),
                                         Take(30, FieldByName('Parcel_Muni_Name').AsString),
                                         Take(9, FieldByName('Parcel_Zip_Code').AsString),
                                         Take(2, FieldByName('Mail_St_Prefix').AsString),
                                         Take(30, FieldByName('Mail_St_Rte').AsString),
                                         Take(10, FieldByName('Mail_St_Nmbr').AsString),
                                         Take(4, FieldByName('Mail_St_Suff').AsString),
                                         Take(2, FieldByName('Mail_St_Dir').AsString),
                                         Take(30, FieldByName('Mail_City').AsString),
                                         Take(2, FieldByName('State_Addr').AsString),
                                         Take(9, FieldByName('Mail_Zip').AsString),
                                         Take(6, FieldByName('PO_Box').AsString),
                                         Take(1, FieldByName('STAR_Ex_Type').AsString),
                                         Take(3, FieldByName('Prop_Class').AsString),
                                         Take(1, FieldByName('Own_Cd').AsString),
                                         Take(4, FieldByName('Owner_Unit_Name').AsString),
                                         Take(10, FieldByName('Owner_Unit_Nmbr').AsString),
                                         Take(4, FieldByName('Roll_Year').AsString),
                                         Take(6, FieldByName('Sch_Dist_Cd').AsString),
                                         Take(3, FieldByName('NYS_Sch_Dist_Cd').AsString),
                                         Take(1, FieldByName('Source_Cd').AsString),
                                         Take(1, FieldByName('Change_CD').AsString));

              If bExtractToExcel
                then ExtractOneLineToExcel(tbSort, flExtractFile);

              Next;

            end;  {while not (EOF or bReportCancelled) do}

          CloseFile(flSTARExtractFile);

        end;  {with tbSort do}

  If (not bReportCancelled and
      _Compare(MessageDlg('Do you want to email this file?', mtConfirmation, [mbYes, mbNo], 0), idYes, coEqual))
    then
      begin
        slSelectedFiles := TStringList.Create;
        slSelectedFiles.Add(dlgSave.FileName);

        sZipFileName := StringReplace(dlgSave.FileName, '. ', '', [rfReplaceAll]);
//        sZipFileName := ChangeFileExt(sZipFileName, '.zip');
        sZipFileName := StripPath(StringReplace(sZipFileName, ' ', '_', [rfReplaceAll]));

        If GlblIsCoopRoll
          then sMailSubject := Trim(GlblMunicipalityName) + ' Coops STAR change extract ' + DateToStr(Date)
          else sMailSubject := Trim(GlblMunicipalityName) + ' STAR change extract ' + DateToStr(Date);

        sExtractDir := GlblDrive + ':' + AddDirectorySlashes(GlblExportDir);

        with rTotalsRec do
          sBody := 'STAR added = ' + IntToStr(STARAdded) + #13 +
                   'New parcels (with STAR) = ' + IntToStr(NewParcel)+ #13 +
                   'STAR removed = ' + IntToStr(STARRemoved)+ #13 +
                   'Removed parcels (with STAR) = ' + IntToStr(ParcelInactivated)+ #13 +
                   'Basic to Enhanced = ' + IntToStr(STARChanged_BasicToEnhanced)+ #13 +
                   'Enhanced to Basic = ' + IntToStr(STARChanged_EnhancedToBasic)+ #13 +
                   'Name \ Address change = ' + IntToStr(OwnerOrAddressChange)+ #13 + #13 +
                   'Total records = ' + IntToStr(STARAdded + NewParcel + STARRemoved +
                                                 ParcelInactivated + STARChanged_BasicToEnhanced +
                                                 STARChanged_EnhancedToBasic + OwnerOrAddressChange);

        EMailFile(Self, sExtractDir, sExtractDir, sZipFileName, emlORPSSTARExtract,
                  emlSCAMike, sMailSubject, sBody, slSelectedFiles, False);
        slSelectedFiles.Free;

      end;  {If (MessageDlg('Do you want to email this file?' + #13 +}

end;  {CreateSTARChangeExtractFile}
{$H-}

{==============================================================}
Procedure TfmMiddleClassSTARRebateExtract.btnStartClick(Sender: TObject);

var
  sSortFileName, sNewFileName, sSpreadsheetFileName : String;
  bQuit : Boolean;

begin
  tbBillCollectionDetails.Open;
  case rgBillingCycleType.ItemIndex of
    0 : begin
          sCollectionType := SchoolTaxType;
          sBillingYear := GetYearOfLastCollection(tbBillCollectionDetails, sCollectionType);
        end;

    1 : begin
          sCollectionType := MunicipalTaxType;
          sBillingYear := IncrementNumericString(GetYearOfLastCollection(tbBillCollectionDetails, sCollectionType), -1);
        end;

  end;  {case rgBillingCycleType.ItemIndex of}

  sOrigSortFileName := tbSort.TableName;
  SetPrintToScreenDefault(PrintDialog);
  iReportType := rgOutputOptions.ItemIndex;
  bExtractToExcel := cbxExtractToExcel.Checked;
  bCreateParcelList := cbxCreateParcelList.Checked;
  bPrintDetails := cbxPrintDetails.Checked;
  bCompareToBillingFiles := cbxCompareToBillingFiles.Checked;
  If bCreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

  case rgComparisonYear.ItemIndex of
    0 : begin
          sAssessmentYear := GlblThisYear;
          iProcessingType := ThisYear;
        end;

    1 : begin
          sAssessmentYear := GlblNextYear;
          iProcessingType := NextYear;
        end;

  end;  {case rgComparisonYear.ItemIndex of}

  sHistoryYear := IncrementNumericString(GlblThisYear, -1);

  OpenTableForProcessingType(tbNYParcels, ParcelTableName,
                             NextYear, bQuit);

  OpenTableForProcessingType(tbParcels, ParcelTableName,
                             iProcessingType, bQuit);

  OpenTableForProcessingType(tbExemptions, ExemptionsTableName,
                             iProcessingType, bQuit);

  OpenTableForProcessingType(tbHistoryParcels, ParcelTableName,
                             History, bQuit);

  OpenTableForProcessingType(tbHistoryExemptions, ExemptionsTableName,
                             History, bQuit);

  slSchoolCollections.Clear;
  _SetRange(tbBillCollectionDetails, [sBillingYear, sCollectionType, 1], [sBillingYear, sCollectionType, 10], '', []);
  FillStringListFromFile(slSchoolCollections, tbBillCollectionDetails, 'SchoolCode', '', 0, False,
                         GlblProcessingType, GetTaxRlYr);

  FillSelectedItemList(lbxSchoolCode, slSelectedSchoolCodes, 6);
  FillSelectedItemList(lbxSwisCode, slSelectedSwisCodes, 6);
  FillSelectedItemList(lbxRollSection, slSelectedRollSections, 1);

  bReportCancelled := False;
  GlblPreviewPrint := False;

  If bCreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

  CopyAndOpenSortFile(tbSort, 'STARChanges',
                      sOrigSortFileName, sSortFileName,
                      True, True, bQuit);

  If bCompareToBillingFiles
    then FillSortFileFromBillingFiles
    else FillSortFileFromHistory;

  If bExtractToExcel
    then
      begin
        sSpreadsheetFileName := GetPrintFileName(Self.Caption, True);
        AssignFile(flExtractFile, sSpreadsheetFileName);
        Rewrite(flExtractFile);
        WritelnCommaDelimitedLine(flExtractFile,
                                  ['Parcel ID',
                                   'Owner',
                                   'STAR Code',
                                   'Change Type']);

      end;  {If PrintToExcel}

  If (_Compare(iReportType, [rtReportAndExtract, rtReport], coEqual) and
      PrintDialog.Execute)
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, bQuit);

        If PrintDialog.PrintToFile
          then
            begin
              GlblPreviewPrint := True;
              sNewFileName := GetPrintFileName(Self.Caption, True);
              ReportFiler.FileName := sNewFileName;

              try
                PreviewForm := TPreviewForm.Create(self);
                PreviewForm.FilePrinter.FileName := sNewFileName;
                PreviewForm.FilePreview.FileName := sNewFileName;

                PreviewForm.FilePreview.ZoomFactor := 100;

                ReportFiler.Execute;
                PreviewForm.ShowModal;
              finally
                PreviewForm.Free;
              end;

                {Delete the report printer file.}

              try
                Chdir(GlblReportDir);
                OldDeleteFile(sNewFileName);
              except
              end;

            end
          else ReportPrinter.Execute;

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

  If _Compare(iReportType, [rtReportAndExtract, rtExtract], coEqual)
    then CreateSTARChangeExtractFile(tbSort, iReportType, bExtractToExcel, flExtractFile);

    {Make sure to close and delete the sort file.}

  tbSort.Close;

    {Now delete the file.}
  try
    ChDir(GlblDataDir);
    If FileExists(sSortFileName + '.dbf')
      then OldDeleteFile(sSortFileName);
  finally
    {We don't care if it does not get deleted, so we won't put up an
     error message.}

    ChDir(GlblProgramDir);
  end;

  If bCreateParcelList
    then ParcelListDialog.Show;
  ProgressDialog.Finish;

  If bExtractToExcel
    then
      begin
        CloseFile(flExtractFile);
        SendTextFileToExcelSpreadsheet(sSpreadsheetFileName, True,
                                       False, '');

      end;  {If PrintToExcel}

  tbSort.TableName := sOrigSortFileName;

end;  {StartButtonClick}

{==============================================================}
Procedure UpdateTotalsRec(    iChangeType : Integer;
                          var rTotalsRec : TotalsRecord);

begin
  with rTotalsRec do
    case iChangeType of
      ctSTARAdded : STARAdded := STARAdded + 1;
      ctNewParcel : NewParcel := NewParcel + 1;
      ctSTARRemoved : STARRemoved := STARRemoved + 1;
      ctParcelInactivated : ParcelInactivated := ParcelInactivated + 1;
      ctSTARChanged_BasicToEnhanced : STARChanged_BasicToEnhanced := STARChanged_BasicToEnhanced + 1;
      ctSTARChanged_EnhancedToBasic : STARChanged_EnhancedToBasic := STARChanged_EnhancedToBasic + 1;
      ctOwnerOrAddressChange : OwnerOrAddressChange := OwnerOrAddressChange + 1;

    end;  {case iChangeType of}

end;  {UpdateTotalsRec}

{==============================================================}
Procedure PrintTotals(Sender : TObject;
                      rTotalsRec : TotalsRecord);

begin
  with Sender as TBaseReport, rTotalsRec do
    begin
      If (LinesLeft < 10)
        then NewPage;

      Println('');
      ClearTabs;
      SetTab(0.3, pjCenter, 2.2, 5, BoxLineAll, 25);
      SetTab(2.5, pjCenter, 0.5, 5, BoxLineAll, 25);

      Bold := True;
      Println(#9 + 'Category' +
              #9 + 'Count');

      ClearTabs;
      SetTab(0.3, pjLeft, 2.2, 5, BoxLineAll, 0);
      SetTab(2.5, pjRight, 0.5, 5, BoxLineAll, 0);
      Bold := False;

      Println(#9 + 'STAR added' +
              #9 + IntToStr(STARAdded));
      Println(#9 + 'New parcels (with STAR)' +
              #9 + IntToStr(NewParcel));
      Println(#9 + 'STAR removed' +
              #9 + IntToStr(STARRemoved));
      Println(#9 + 'Removed parcels (with STAR)' +
              #9 + IntToStr(ParcelInactivated));
      Println(#9 + 'Basic to Enhanced' +
              #9 + IntToStr(STARChanged_BasicToEnhanced));
      Println(#9 + 'Enhanced to Basic' +
              #9 + IntToStr(STARChanged_EnhancedToBasic));
      Println(#9 + 'Name \ Address change' +
              #9 + IntToStr(OwnerOrAddressChange));

    end;  {with Sender as TBaseReport, rTotalsRec do}

end;  {PrintTotals}

{==============================================================}
Procedure TfmMiddleClassSTARRebateExtract.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;

      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '    ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman',12);
      Bold := True;
      Home;
      Println('');
      PrintCenter('STAR Change Report', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',10);

      If bPrintDetails
        then
          begin
            Bold := True;
            ClearTabs;
            SetTab(0.3, pjCenter, 1.2, 5, BoxLineAll, 25);  {Parcel ID}
            SetTab(1.5, pjCenter, 2.4, 5, BoxLineAll, 25);  {Owner}
            SetTab(3.9, pjCenter, 0.8, 5, BoxLineAll, 25);  {STAR Type}
            SetTab(4.7, pjCenter, 2.0, 5, BoxLineAll, 25);  {Change Type}

            Println(#9 + 'Parcel ID' +
                    #9 + 'Owner' +
                    #9 + 'STAR Code' +
                    #9 + 'Change Type');

            Bold := False;
            ClearTabs;
            SetTab(0.3, pjLeft, 1.2, 5, BoxLineAll, 0);  {Parcel ID}
            SetTab(1.5, pjLeft, 2.4, 5, BoxLineAll, 0);  {Owner}
            SetTab(3.9, pjLeft, 0.8, 5, BoxLineAll, 0);  {STAR Type}
            SetTab(4.7, pjLeft, 2.0, 5, BoxLineAll, 0);  {Change Type}

          end;  {If cbPrintDetails}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==============================================================}
Procedure TfmMiddleClassSTARRebateExtract.ReportPrint(Sender: TObject);

begin
  bReportCancelled := False;
  tbSort.First;
  ProgressDialog.UserLabelCaption := 'Printing Sort Results';
  ProgressDialog.Reset;
  ProgressDialog.TotalNumRecords := tbSort.RecordCount;

  with rTotalsRec do
    begin
      STARAdded := 0;
      NewParcel := 0;
      STARRemoved := 0;
      ParcelInactivated := 0;
      STARChanged_BasicToEnhanced := 0;
      STARChanged_EnhancedToBasic := 0;
      OwnerOrAddressChange := 0;
    end;

  with tbSort do
    while not (EOF or bReportCancelled) do
      begin
        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').AsString));
        Application.ProcessMessages;

        with Sender as TBaseReport do
          begin
            If bPrintDetails
              then Println(#9 + FieldByName('Print_Key').AsString +
                           #9 + FieldByName('Last_Name_1').AsString +
                           #9 + GetSTARCode(FieldByName('STAR_EX_Type').AsInteger) +
                           #9 + GetChangeTypeDescription(FieldByName('ChangeType').AsInteger));

            If (LinesLeft < 5)
              then NewPage;

            UpdateTotalsRec(FieldByName('ChangeType').AsInteger, rTotalsRec);

          end;  {with Sender as TBaseReport do}

        If bExtractToExcel
          then ExtractOneLineToExcel(tbSort, flExtractFile);

        If bCreateParcelList
          then ParcelListDialog.AddOneParcel(FieldByName('SwisSBLKey').AsString);

        Next;
        bReportCancelled := ProgressDialog.Cancelled;

      end;  {while not (EOF or ReportCancelled) do}

  If not bReportCancelled
    then PrintTotals(Sender, rTotalsRec);

end;  {ReportPrint}

{===================================================================}
Procedure TfmMiddleClassSTARRebateExtract.FormClose(    Sender: TObject;
                                                     var Action: TCloseAction);

begin
  slSelectedSchoolCodes.Free;
  slSelectedSwisCodes.Free;
  slSelectedRollSections.Free;
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
