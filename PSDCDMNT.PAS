unit Psdcdmnt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, PASTypes;

type
  TParcelSpecialDistrictForm = class(TForm)
    TitlePanel: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    SpecialDistrictCodeTable: TwwTable;
    SpecialDistrictLookupTable: TwwTable;
    SpecialDistrictExtensionCodeTable: TwwTable;
    Label8: TLabel;
    SpecialDistrictDataSource: TwwDataSource;
    SpecialDistrictTable: TwwTable;
    SDCalcCodeTable: TwwTable;
    SpecialDistrictTableTaxRollYr: TStringField;
    SpecialDistrictTableSwisSBLKey: TStringField;
    SpecialDistrictTableSdistCode: TStringField;
    SpecialDistrictTablePrimaryUnits: TFloatField;
    SpecialDistrictTableSecondaryUnits: TFloatField;
    SpecialDistrictTableSdPercentage: TFloatField;
    SpecialDistrictTableCalcCode: TStringField;
    SpecialDistrictTableCalcAmount: TCurrencyField;
    SpecialDistrictTableDateAdded: TDateField;
    ExemptionCodeTable: TTable;
    ExemptionTable: TTable;
    AssessmentTable: TTable;
    InactiveLabel: TLabel;
    AssessmentDataSource: TDataSource;
    OppositeYearParcelSDTable: TTable;
    LandLabel: TLabel;
    TotalLabel: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    AuditSDChangeTable: TTable;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    FooterPanel: TPanel;
    Navigator: TDBNavigator;
    CloseButton: TBitBtn;
    HeaderPanel: TPanel;
    OwnerNameLabel: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    LastChangeByLabel: TLabel;
    ChangeByLabel: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    EditLastChangeDate: TDBEdit;
    EditLastChangeByName: TDBEdit;
    Panel5: TPanel;
    DimensionsLabel: TLabel;
    EditDimensions: TEdit;
    SpecialDistrictGrid: TwwDBGrid;
    SDCalcCodeDBLookupCombo: TwwDBLookupCombo;
    SDistcodeDBLookupCombo: TwwDBLookupCombo;
    DimensionsPanel: TPanel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    EditFrontage: TDBEdit;
    EditDepth: TDBEdit;
    EditAcreage: TDBEdit;
    SpecialDistrictTableSDValue: TFloatField;
    ClassTable: TTable;
    SpecialDistrictTableSDDescription: TStringField;
    Label1: TLabel;
    edPropertyClass: TDBEdit;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure SpecialDistrictTableAfterEdit(DataSet: TDataset);
    procedure SpecialDistrictTableBeforePost(DataSet: TDataset);
    procedure SpecialDistrictTableAfterPost(DataSet: TDataset);
    procedure SpecialDistrictTableBeforeInsert(DataSet: TDataset);
    procedure SpecialDistrictTableBeforeDelete(DataSet: TDataset);
    procedure SpecialDistrictDataSourceDataChange(Sender: TObject;
      Field: TField);
    procedure SDistcodeDBLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure SDCalcCodeDBLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure SDCalcCodeDBLookupComboNotInList(Sender: TObject;
      LookupTable: TDataSet; NewValue: String; var Accept: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure SpecialDistrictTableNewRecord(DataSet: TDataSet);
    procedure SpecialDistrictTableCalcFields(DataSet: TDataSet);
    procedure SpecialDistrictGridCalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; Highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure FormResize(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;

  private

  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr : String;
    SwisSBLKey : String;
    ProcessingType : Integer;  {NextYear, ThisYear, History}

        {These var.'s are for tracing changes.}

    FieldValuesList,
    FieldLabelsList : TStringList;

    DeletingARecord,  {Are we in the middle of a record delete?}
    InitializingForm : Boolean;  {Are we creating the form right now?}
    Inserting, ClosingForm : Boolean;  {Are we closing a form?}

      {Have there been any changes?}

    ParcelChanged : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    OrigSDAmounts : TList;

      {CHG10281997-1: Dual mode processing.}

    RecordAction,
    OppositeProcessingType : Integer;
    OppositeTaxYear : String;
    OppositeYearParcelChanged : Boolean;
    DeletedSDCode : String;
    OrigSDRec : AuditSDRecord;
    SettingReadOnlyFields : Boolean;
    OriginalGridWidth : Integer;
    FieldTraceInformationList : TList;

    Procedure InitializeForm;
    Procedure SetRangeForTable(Table : TTable);

    Function GetECDCategory(ECDCode : String) : String;

    Procedure SetReadOnlyFields;

    Function ValidCalcCode(SpecialDistrictCode : String;
                           SpecialDistrictTableCalcCode : String): Boolean;

  end;    {end form object definition}

implementation

uses GlblVars, WinUtils, PASUTILS, UTILEXSD,  Utilitys, DataAccessUnit,
     UTILRTOT,  {Roll total update unit.}
     GlblCnst;

type
  ECDArrayType = Array[1..10] of String;

{$R *.DFM}

{=====================================================================}
Procedure TParcelSpecialDistrictForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TParcelSpecialDistrictForm.FormResize(Sender: TObject);

{CHG09102004-1(2.8.0.11): Resize the grid font for a change.}

begin
  If ((not InitializingForm) and
      (SpecialDistrictGrid.Width <> OriginalGridWidth))
    then
      begin
        ResizeGridFontForWidthChange(SpecialDistrictGrid, OriginalGridWidth);

        OriginalGridWidth := SpecialDistrictGrid.Width;

        ResizeTitleInformation(Self);
        ResizeHeaderInformation(Self);
        ResizeFooterInformation(Self);

      end;  {If ((not FormIsInitializing) and ...}

end;  {FormResize}

{========================================================================}
Procedure TParcelSpecialDistrictForm.FormActivate(Sender: TObject);

begin
  Refresh;
end;

{========================================================================}
Procedure TParcelSpecialDistrictForm.SetRangeForTable(Table : TTable);

{Now set the range on the exemption so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}

begin
  try
    SetRangeOld(Table, ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                [TaxRollYr, SwisSBLKey, '     '],
                [TaxRollYr, SwisSBLKey, 'zzzzz']);
  except
    SystemSupport(007, Table, 'Error setting range in ' + Table.TableName +
                  ' table.', UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TParcelSpecialDistrictForm.InitializeForm;

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

begin
  OriginalGridWidth := SpecialDistrictGrid.Width;
  UnitName := 'PSDCDMNT.PAS';  {mmm1}
  InitializingForm := True;
  SettingReadOnlyFields := False;
  ClosingForm := False;
  Inserting := False;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        FieldTraceInformationList := TList.Create;

        If ((EditMode = 'V') or
            (ProcessingType <> DetermineProcessingType(GlblTaxYearFlg)))
          then SpecialDistrictTable.ReadOnly := True;

          {There are so many tables on this form, we will
           set the table name and open them implicitly.
           OpenTablesForForm is a method in PASUTILS.}

          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}
         If not ModifyAccessAllowed(FormAccessRights)
          then
            begin
              SpecialDistrictTable.ReadOnly := True;

            end;  {If not ModifyAccessAllowed(FormAccessRights)}

        OpenTablesForForm(Self, ProcessingType);

         {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If (GlblTaxYearFlg = 'H')
          then SetRangeForHistoryTaxYear(SpecialDistrictCodeTable, 'TaxRollYr', 'SDistCode');

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
          then SystemSupport(009, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Now set the range on the Parcel SD Table.}

        SetRangeForTable(SpecialDistrictTable);

        try
          Found := FindKeyOld(AssessmentTable,
                              ['TaxRollYr', 'SwisSBLKey'],
                              [TaxRollYr, SwisSBLKey]);
        except
          SystemSupport(009, AssessmentTable, 'Error getting assessment record.',
                        UnitName, GlblErrorDlgBox);
        end;

        If not Found
          then SystemSupport(009, AssessmentTable, 'Error getting assessment record.',
                        UnitName, GlblErrorDlgBox);

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

        TitleLabel.Caption := 'Special District';
        TitleLabel.Left := (TitlePanel.Width - TitleLabel.Width) DIV 2;

          {Now, for some reason the table is marked as
           Modified after we do a set range in modify mode.
           So, we will cancel the modify and set it in
           the proper mode.}

        If ((not SpecialDistrictTable.ReadOnly) and
            SpecialDistrictTable.Modified and
            (EditMode = 'M'))
          then
            begin
              SpecialDistrictTable.Edit;
              SpecialDistrictTable.Cancel;
            end;

          {Note that we will not automatically put them
           in edit mode or insert mode. We will make them
           take that action themselves since even though
           they are in an edit or insert session, they
           may not want to actually make any changes, and
           if they do not, they should not have to cancel.}

        If SpecialDistrictTable.ReadOnly
          then Navigator.Visible := False;

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);

          {Now set the year label.}

        SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);

          {Set the SBL in the SBL edit so that it is visible.
           Note that it is not data aware since if there are
           no records, we have nothing to get the SBL from.}

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        OrigSDAmounts := TList.Create;

          {CHG10281997-1: Dual mode processing.}

        If (ProcessingType = ThisYear)
          then OppositeProcessingType := NextYear
          else OppositeProcessingType := ThisYear;

        OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

        OpenTableForProcessingType(OppositeYearParcelSDTable,
                                   SpecialDistrictTableName,
                                   OppositeProcessingType, Quit);

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

          {CHG11162004-6(2.8.0.21): Option to show extended SD values.}

        If GlblShowExtendedSDAmounts
          then
            begin
              DimensionsPanel.Enabled := False;
              DimensionsLabel.Visible := True;
              DimensionsPanel.Width := 0;
              EditDimensions.Visible := True;
              EditDimensions.Text := ParcelDimensionsToString(ParcelTable);
              SpecialDistrictTable.FieldByName('SDValue').Visible := True;
              OriginalGridWidth := 570;

            end  {If GlblShowExtendedSDAmounts}
          else SpecialDistrictTable.FieldByName('SDValue').Visible := False;

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG10091997-1: Display blanks for zeroes.}

  SetDisplayFormatForCurrencyFields(Self, True);

    {CHG10091997-1: Display blanks for zeroes.}
    {The calc amount is special - it is an extended, but a currency.}
    {FXX10221997-4: No dollar signs for units.}
    {FXX11111997-2: Display the calc amount as a regular decimal,
                    not currency.}
    {CHG11012004-1(2.8.0.16): Allow for 3 decimals on units.}

  with SpecialDistrictTable do
    begin
      TNumericField(FieldByName('CalcAmount')).DisplayFormat := DecimalDisplay_BlankZero;
      TNumericField(FieldByName('SDPercentage')).DisplayFormat := DecimalDisplay_BlankZero;
      TNumericField(FieldByName('PrimaryUnits')).DisplayFormat := _3DecimalEditDisplay;
      TNumericField(FieldByName('SecondaryUnits')).DisplayFormat := _3DecimalEditDisplay;

    end;  {with SpecialDistrictTable do}

  with ParcelTable do
    begin
      TNumericField(FieldByName('Frontage')).DisplayFormat := DecimalDisplay_BlankZero;
      TNumericField(FieldByName('Depth')).DisplayFormat := DecimalDisplay_BlankZero;
      TNumericField(FieldByName('Acreage')).DisplayFormat := DecimalDisplay_BlankZero;

    end;  {with ParcelTable do}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  InitializingForm := False;

    {CHG11162004-6(2.8.0.21): Option to show extended SD values.}
    {Force the calc of SD value fields.}

  If GlblShowExtendedSDAmounts
    then SpecialDistrictTable.Refresh;

  If GlblDisplaySpecialDistrictDescriptions
    then DimensionsPanel.Visible := False
    else SpecialDistrictTable.FieldByName('SDDescription').Visible := False;

  FormResize(nil);

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

end;  {InitializeForm}

{==============================================================}
Procedure TParcelSpecialDistrictForm.SpecialDistrictTableCalcFields(DataSet: TDataSet);

var
  SDExtensionCodes, SDCC_OMFlags,
  SDValues, HomesteadCodesList, slAssessedValues : TStringList;
  ParcelExemptionList, ExemptionCodeList : TList;

begin
    {CHG11162004-6(2.8.0.21): Option to show extended SD values.}

  If (GlblShowExtendedSDAmounts and
      (not InitializingForm))
    then
      begin
        SDExtensionCodes := TStringList.Create;
        SDCC_OMFlags := TStringList.Create;
        SDValues := TStringList.Create;
        ParcelExemptionList := TList.Create;
        ExemptionCodeList := TList.Create;
        HomesteadCodesList := TStringList.Create;
        slAssessedValues := TStringList.Create;

        LoadExemptions(TaxRollYr, SwisSBLKey,
                       ParcelExemptionList, ExemptionCodeList,
                       ExemptionTable, ExemptionCodeTable);

        CalculateSpecialDistrictAmounts(ParcelTable, AssessmentTable,
                                        ClassTable,
                                        SpecialDistrictTable,
                                        SpecialDistrictCodeTable,
                                        ParcelExemptionList,
                                        ExemptionCodeList,
                                        SDExtensionCodes,
                                        SDCC_OMFlags,
                                        slAssessedValues,
                                        SDValues,
                                        HomesteadCodesList);

        try
          SpecialDistrictTable.FieldByName('SDValue').Text := SDValues[0];
        except
        end;

        SDExtensionCodes.Free;
        SDCC_OMFlags.Free;
        SDValues.Free;
        slAssessedValues.Free;
        FreeTList(ParcelExemptionList, SizeOf(ParcelExemptionRecord));
        FreeTList(ExemptionCodeList, SizeOf(ExemptionCodeRecord));

      end;  {If GlblShowExtendedSDAmounts}

    {CHG02052005-2(2.8.3.5)[]: Add the SD description.}

  If (GlblDisplaySpecialDistrictDescriptions and
      _Compare(SpecialDistrictTable.FieldByName('SDistCode').AsString, coNotBlank))
    then
      begin
        FindKeyOld(SpecialDistrictCodeTable, ['SDistCode'], [SpecialDistrictTable.FieldByName('SDistCode').Text]);
        SpecialDistrictTable.FieldByName('SDDescription').Text := SpecialDistrictCodeTable.FieldByName('Description').Text;

      end;  {If (GlblShowSpecialDistrictDescriptions and ...}

end;  {SpecialDistrictTableCalcFields}

{==============================================================}
Procedure TParcelSpecialDistrictForm.SpecialDistrictGridCalcCellColors(Sender : TObject;
                                                            Field : TField;
                                                            State : TGridDrawState;
                                                            Highlight : Boolean;
                                                            AFont : TFont;
                                                            ABrush : TBrush);

begin
    {CHG11162004-6(2.8.0.21): Option to show extended SD values.}

  If (GlblShowExtendedSDAmounts and
      (Field.FieldName = 'SDValue'))
    then
      begin
        AFont.Style := [fsBold];
        AFont.Color := clGreen;
      end;

end;  {SpecialDistrictGridCalcCellColors}

{==============================================================}
Procedure TParcelSpecialDistrictForm.SpecialDistrictTableNewRecord(DataSet: TDataSet);

{FXX11142003-1: Make sure that all float and integer fields are initialized to 0.}

begin
  InitializeFieldsForRecord(DataSet);
end;

{==============================================================}
Procedure TParcelSpecialDistrictForm.SpecialDistrictTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in the Self var.}

begin
  If not InitializingForm
    then
      begin
          {CHG10281997-1: Dual mode processing.}

        If (SpecialDistrictTable.State = dsInsert)
          then RecordAction := raInserted
          else RecordAction := raEdited;

        If not DeletingARecord
          then
            begin
               {FXX11101997-6: Combined the CreateFieldValuesAndLabels from UGenSclb
                               and PASUtils for compatibility.}
               {FXX12231998-1: Need to turn the read only off before getting the
                               labels and turn it back on afterwards.}

              SpecialDistrictTable.FieldByName('CalcAmount').ReadOnly := False;
              SpecialDistrictTable.FieldByName('PrimaryUnits').ReadOnly := False;
              SpecialDistrictTable.FieldByName('SecondaryUnits').ReadOnly := False;
              SpecialDistrictTable.FieldByName('SDPercentage').ReadOnly := False;

              CreateFieldValuesAndLabels(Self, SpecialDistrictTable,
                                         FieldTraceInformationList);

              with SpecialDistrictTable do
                begin
                  FieldByName('CalcAmount').ReadOnly := True;
                  FieldByName('PrimaryUnits').ReadOnly := True;
                  FieldByName('SecondaryUnits').ReadOnly := True;
                  FieldByName('SDPercentage').ReadOnly := True;

                  If (State = dsInsert)
                    then
                      begin
                        FieldByName('SDistCode').ReadOnly := False;
                        FieldByName('DateAdded').AsDateTime := Date;

                      end
                    else FieldByName('SDistCode').ReadOnly := True;

                end;  {with SpecialDistrictTable do}

              SetReadOnlyFields;

            end;  {If not DeletingARecord}

           {Get the original SD values so that we can adjust the roll totals
            after any changes.}

        ClearTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));

        TotalSpecialDistrictsForParcel(TaxRollYr,
                                       SwisSBLKey,
                                       ParcelTable,
                                       AssessmentTable,
                                       SpecialDistrictLookupTable,
                                       SpecialDistrictCodeTable,
                                       ExemptionTable,
                                       ExemptionCodeTable,
                                       OrigSDAmounts);

        SpecialDistrictGrid.Refresh;
        SpecialDistrictGrid.Repaint;

          {FXX02061998-1: After insert make sure the cursor is in
                          the exemption code field.}

        If (SpecialDistrictTable.State = dsInsert)
          then
            begin
              SpecialDistrictGrid.SetFocus;
              SpecialDistrictGrid.SetActiveField('SdistCode');
            end;

          {CHG03231998-1: Record SD and EX changes, too.}

        If (SpecialDistrictTable.State = dsEdit)
          then
            with OrigSDRec do
              begin
                PrimaryUnits := SpecialDistrictTable.FieldByName('PrimaryUnits').AsFloat;
                SecondaryUnits := SpecialDistrictTable.FieldByName('SecondaryUnits').AsFloat;
                CalcAmount := SpecialDistrictTable.FieldByName('CalcAmount').AsFloat;
                SDPercentage := SpecialDistrictTable.FieldByName('SDPercentage').AsFloat;
                CalcCode := Take(1, SpecialDistrictTable.FieldByName('CalcCode').Text)[1];

              end;  {with OrigSDRecord do}

      end;  {If not InitializingForm}

  Inserting := False;  {This is only for use during setup of insert.
                        The RecordAction variable is used from now on.}

end;  {SpecialDistrictTableAfterEdit}

{========================================================================}
Function TParcelSpecialDistrictForm.GetECDCategory(ECDCode : String) : String;

begin
  If FindKeyOld(SpecialDistrictExtensionCodeTable, ['MainCode'], [ECDCode])
    then Result := SpecialDistrictExtensionCodeTable.FieldByName('Category').Text
    else Result := '';

end;  {GetECDCategory}

{==============================================================}
Function GetExtensionCodeArray(SDCodeTable,
                               ParcelSDTable : TTable) : ECDArrayType;

var
  I : Integer;
  TempFieldName : String;

begin
    {FXX11111997-3: We were not getting the SD code, so was not
                    synched with the SD code.}

  FindKeyOld(SDCodeTable, ['SDistCode'],
             [ParcelSDTable.FieldByName('SDistCode').Text]);

  with SDCodeTable do
    For I := 1 to 10 do
      begin
        Result[I] := Take(2,' ');

        TempFieldName := 'ECD' + IntToStr(I);

        If (Deblank(FieldByName(TempFieldName).Text) <> '')
          then Result[I] := Take(2, FieldByName(TempFieldName).Text);

      end;  {For I := 1 to 10 do}

end;  {GetExtensionCodeArray(}

{==============================================================}
Procedure TParcelSpecialDistrictForm.SetReadOnlyFields;

{Set the fields read only or required depending on the type of sd.}

var
  I : Integer;
  ECDArray : EcdArrayType;
  ECDCategory : String;

begin
  SettingReadOnlyFields := True;

    {FXX11111997-1: There was problems with setting the SD code fields to
                    read only.}

     {For each extension code for this SD code, set flds
      to be not readonly if the ext code for the Sd code
      requires that field.}

  ECDArray := GetExtensionCodeArray(SpecialDistrictCodeTable, SpecialDistrictTable);

    {FXX10221997-6: Remove for now - not letting them edit units at all.}

  with SpecialDistrictTable do
    begin
      FieldByName('CalcAmount').ReadOnly := True;
      FieldByName('PrimaryUnits').ReadOnly := True;
      FieldByName('SecondaryUnits').ReadOnly := True;
      FieldByName('SDPercentage').ReadOnly := True;

      For I := 1 to 10 do
        If (Deblank(ECDArray[I]) <> '')
          then
            begin
              ECDCategory := GetECDCategory(ECDArray[I]);

              If (ECDCategory = SDistCategoryDIMN)
                then FieldByName('PrimaryUnits').ReadOnly := False;

              If (ECDCategory = SDistCategoryUNIT)
                then
                  begin
                    FieldByName('CalcCode').ReadOnly := False;
                    FieldByName('PrimaryUnits').ReadOnly := False;
                    FieldByName('SecondaryUnits').ReadOnly := False;

                 end;  {If (ECDCategory = SDistCategoryUNIT)}

             If (ECDCategory = SDistCategorySTUN)
               then
                 begin
                   FieldByName('PrimaryUnits').ReadOnly := False;
                   FieldByName('SecondaryUnits').ReadOnly := False;

                 end;  {If (ECDCategory = SDistCategorySTUN)}

             If (ECDCategory = SDistCategoryADVL)
               then
                 begin
                   FieldByName('CalcCode').ReadOnly := False;
                   FieldByName('CalcAmount').ReadOnly := False;
                   FieldByName('SDPercentage').ReadOnly := False;

                 end;  {If (ECDCategory = SDistCategoryADVL)}

             If (ECDCategory = SDistCategoryFIXD)
               then
                 begin
                     {mt can put in value in amount field}

                   If (ECDArray[I] = SDistEcMT)
                     then FieldByName('CalcCode').ReadOnly := False;

                   FieldByName('CalcAmount').ReadOnly := False;

                 end;  {If (ECDCategory = SDistCategoryFIXD)}

              If (FieldByName('CalcCode').Text = 'U')
                then FieldByName('SecondaryUnits').ReadOnly := False;

            end; {If (Deblank(ECDArray[I]) <> '')}

    end;  {with SpecialDistrictTable do}

  SettingReadOnlyFields := False;

end;  {SetReadOnlyFields}

{================================================================}
Procedure TParcelSpecialDistrictForm.SpecialDistrictDataSourceDataChange(Sender: TObject;
                                                                          Field: TField);
{FXX11111997-5: Set the read only status of the fields on data
                change so that it is correct when they go into
                edit mode.}

{FXX01211998-6: Don't set the fields if the form is initializing.}

begin
  If ((Field = nil) and
      (not InitializingForm) and
      (not SettingReadOnlyFields) and
      (not Inserting))
    then SetReadOnlyFields;

end;  {ParcelSpecialDistDataSourceDataChange}

{============================================================}
Procedure TParcelSpecialDistrictForm.SDistcodeDBLookupComboCloseUp(Sender: TObject;
                                                                   LookupTable,
                                                                   FillTable: TDataSet;
                                                                   modified: Boolean);

var
  SDCodeOK, Found,
  SDCodeHasUnits,
  SDCodeHasSecondaryUnits : Boolean;
  SwisList : TStringList;
  I : Integer;
  TempStr, TempFieldName : String;

begin
  SDCodeOK := True;

   {Check to make sure that this sd code does not already exist on this parcel.}

  If (SpecialDistrictTable.State = dsInsert)
    then
      begin
        Found := FindKeyOld(SpecialDistrictLookupTable,
                            ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                            [TaxRollYr, SwisSBLKey,
                             SpecialDistrictTable.FieldByName('SDistCode').Text]);

        If Found
          then
            begin
              MessageDlg('Special district code ' + SpecialDistrictTable.FieldByName('SDistCode').Text +
                         'is already assigned to this parcel.', mtError, [mbOK], 0);
              SDCodeOK := False;
            end;

          {FXX12171998-9: If this is not a roll section 9 parcel, do not
                          allow rs 9 special districts.}

        If ((ParcelTable.FieldByName('RollSection').Text <> '9') and
            SpecialDistrictCodeTable.FieldByName('SDRs9').AsBoolean)
          then
            begin
              MessageDlg(SpecialDistrictCodeTable.FieldByName('SDistCode').Text +
                         ' can only be placed on a roll section 9 parcel.' + #13 +
                         'Please select a different special district code.',
                         mtError, [mbOK], 0);
              SDCodeOK := False;
            end;

          {And vice-versa.}

        If ((ParcelTable.FieldByName('RollSection').Text = '9') and
            (not SpecialDistrictCodeTable.FieldByName('SDRs9').AsBoolean))
          then
            begin
              MessageDlg(SpecialDistrictCodeTable.FieldByName('SDistCode').Text +
                         ' can only be placed on a parcel not in roll section 9.' + #13 +
                         'Please select a different special district code.',
                         mtError, [mbOK], 0);
              SDCodeOK := False;
            end;

          {Now make sure that they can put this SD code on for this swis.}

        If SDCodeOK
          then
            begin
              SwisList := TStringList.Create;

              For I := 1 to 20 do
                begin
                  TempStr := 'SW' + IntToStr(I);

                  If (Deblank(SpecialDistrictCodeTable.FieldByName(TempStr).Text) <> '')
                    then SwisList.Add(SpecialDistrictCodeTable.FieldByName(TempStr).Text);

                end;  {For I := 1 to 20 do}

                {Now if there are any swis restrictions, let's compare them versus
                 the swis code for this parcel and see if it fits.}

              If not ValidSwisCodeForExemptionOrSpecialDistrictCode(SwisList,
                                                                    ParcelTable.FieldByName('SwisCode').Text)
                then
                  begin
                    MessageDlg('This special district code can not ' + #13 +
                               'be placed on a parcel in this swis code.' + #13 +
                               'Please check your information.', mtError, [mbOK], 0);
                    SDCodeOK := False;
                  end;

              SwisList.Free;

            end;  {If ExemptionCodeOK}

          {CHG10292001-2: Allow for setting of default units and secondary units.}

        If SDCodeOK
          then
            begin
              SetReadOnlyFields;

              SDCodeHasUnits := False;
              SDCodeHasSecondaryUnits := False;

              For I := 1 to 10 do
                begin
                  TempFieldName := 'ECd' + IntToStr(I);

                  If (SpecialDistrictCodeTable.FieldByName(TempFieldName).Text = SDistEcUN)
                    then SDCodeHasUnits := True;

                  If (SpecialDistrictCodeTable.FieldByName(TempFieldName).Text = SDistEcSU)
                    then SDCodeHasSecondaryUnits := True;

                end;  {For I := 1 to 10 do}

              If (SDCodeHasUnits and
                  (not SpecialDistrictTable.FieldByName('PrimaryUnits').ReadOnly))
                then SpecialDistrictTable.FieldByName('PrimaryUnits').AsFloat := SpecialDistrictCodeTable.FieldByName('DefaultUnits').AsFloat;

              If (SDCodeHasSecondaryUnits and
                  (not SpecialDistrictTable.FieldByName('SecondaryUnits').ReadOnly))
                then SpecialDistrictTable.FieldByName('SecondaryUnits').AsFloat := SpecialDistrictCodeTable.FieldByName('Default2ndUnits').AsFloat;

            end;  {If SDCodeOK}

        If SDCodeOK
          then SetReadOnlyFields
          else
            begin
              SpecialDistrictGrid.SetFocus;
              SpecialDistrictTable.Cancel;
              Abort;
            end;

      end;  {If (SpecialDistrictTable.State = dsInsert)}

end;  {SDistcodeDBLookupComboCloseUp}

{============================================================}
Procedure TParcelSpecialDistrictForm.SpecialDistrictTableBeforeInsert(DataSet: TDataset);

begin
  SpecialDistrictTable.FieldByName('SdistCode').ReadOnly := False;

  Inserting := True;

end;  {SpecialDistrictTableBeforeInsert}

{=====================================================================}
Procedure TParcelSpecialDistrictForm.SpecialDistrictTableBeforeDelete(DataSet: TDataset);

{We will set a boolean saying that we are deleting a record and
 then call the after edit routine.}

begin
  DeletingARecord := True;

    {CHG01211998-3: Allow tracking of EX, SD deletions.}
    {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

  InsertOneSDChangeTrace(SwisSBLKey, TaxRollYr, SpecialDistrictTable,
                         AuditSDChangeTable, 'D', OrigSDRec);

   {CHG10281997-1: Dual mode processing.}
   {Record the SD code that is about to be deleted so that we can delete in
    the opposite year too.}

  DeletedSDCode := SpecialDistrictTableSDistCode.Text;
  SpecialDistrictTableAfterEdit(DataSet);

    {FXX12021999-3: Trace deletes of exemptions, sds in audit table.}

  AddToTraceFile(SwisSBLKey, 'Special District', 'Code', DeletedSDCode,
                 '(Deleted)', Time, SpecialDistrictTable);

end;  {SpecialDistrictTableBeforeDelete}

{=====================================================================}
Function TParcelSpecialDistrictForm.ValidCalcCode(SpecialDistrictCode : String;
                                                  SpecialDistrictTableCalcCode : String): Boolean;

var
  I : Integer;
  FoundCorrectEcd, Valid : Boolean;
  ECDArray : EcdArrayType;

begin
  Valid := False;

  If FindKeyOld(SpecialDistrictCodeTable, ['SDistCode'], [SpecialDistrictCode])
    then
      begin
        ECDArray := GetExtensionCodeArray(SpecialDistrictCodeTable, SpecialDistrictTable);

            {if S OR E must be TO}
        FoundCorrectECD := False;

        If ((Take(1, SpecialDistrictTableCalcCode) = PrclSDCcS) or
            (Take(1, SpecialDistrictTableCalcCode) = PrclSDCcE))
          then
            begin
              For I := 1 to 10 do
                If (ECDArray[I] = SDistEcTO)
                  then
                    begin
                      FoundCorrectECD := True;
                      Valid := True;
                    end;

              If not FoundCorrectECD
                then MessageDlg('The special district code must have an extension code' + #13 +
                                'of TO for this calculation code.' + #13 +
                                'Please try again.', mtError, [mbOK], 0);

            end;  {If ((Take(1,SpecialDistrictTableCalcCode) ...}

           {T & R must have 'MT'}

        If ((Take(1,SpecialDistrictTableCalcCode) = PrclSDCcT) or
            (Take(1,SpecialDistrictTableCalcCode) = PrclSDCcR))
          then
            begin
              For I := 1 to 10 do
                If (ECDArray[I] = SDistEcMT)
                  then
                    begin
                      FoundCorrectECD := True;
                      Valid := True;
                    end;

              If not FoundCorrectECD
                then MessageDlg('This special district code must have an extension code' + #13 +
                                'of MT for this calculation code.' + #13 +
                                'Please select a different calcluation code.',
                                mtError, [mbOK], 0);

            end;  {If ((Take(1,SpecialDistrictTableCalcCode) ...}

      end;  {If Found}

  ValidCalcCode := Valid;

end;  {ValidCalcCode}

{==============================================================}
Procedure TParcelSpecialDistrictForm.SDCalcCodeDBLookupComboCloseUp(Sender: TObject;
                                                                    LookupTable,
                                                                    FillTable: TDataSet;
                                                                    modified: Boolean);

{Make sure that this is a valid calculation code.}

begin
  If ((SpecialDistrictTable.State in [dsEdit, dsInsert]) and
      (not SpecialDistrictTable.ReadOnly) and
      Modified)
    then
      If not ValidCalcCode(SpecialDistrictTable.FieldByName('SdistCode').Text,
                           SpecialDistrictTable.FieldByName('CalcCode').Text)
        then Abort;

end;  {SDCalcCodeDBLookupComboCloseUp}

{=====================================================================}
Procedure TParcelSpecialDistrictForm.SDCalcCodeDBLookupComboNotInList(    Sender: TObject;
                                                                          LookupTable: TDataSet;
                                                                          NewValue: String;
                                                                      var Accept: Boolean);

{FXX01221999-1: Allow calc code to be cleared.}

begin
  If (Deblank(NewValue) = '')
    then Accept := True;

end;  {LookupComboNotInList}

{==============================================================}
Procedure TParcelSpecialDistrictForm.SpecialDistrictTableBeforePost(DataSet: TDataset);

{Make sure that all fields are filled in. If not, abort the post.
 Change the wording to reflect which fields are not filled in.}

var
  ReturnCode : Integer;
  OKToProceed : Boolean;

begin
  SpecialDistrictTable.FieldByName('TaxRollYr').Text  := TaxRollYr;
  SpecialDistrictTable.FieldByName('SwisSBLKey').Text := SwisSBLKey;
  OKToProceed := True;

    {FXX07191999-9: Force a move tax to have a 'T' calc code for compatibility with RPS.}

  FindKeyOld(SpecialDistrictCodeTable, ['SDistCode'],
             [SpecialDistrictTable.FieldByName('SDistCode').Text]);

  If (SpecialDistrictCodeTable.FieldByName('ECd1').Text = SdistEcMT)
    then SpecialDistrictTable.FieldByName('CalcCode').Text := 'T';

    {FXX12171998-11: Make sure that the special district code is filled in.}

  If (Trim(SpecialDistrictTable.FieldByName('SDistCode').Text) = '')
    then
      begin
        MessageDlg('Please enter a special district code.', mtError, [mbOK], 0);
        OKToProceed := False;
      end;  {If (Deblank(SpecialDistrictTableSDistCode.Text) = '')}

    {FXX05151998-3: Don't ask save on close form if don't want to see save.}

  If OKToProceed
    then
      begin
        If ((not InitializingForm) and
            GlblAskSave)
          then
            begin
                {FXX11061997-2: Remove the "save before exiting" prompt because it
                                is confusing. Use only "Do you want to save.}

              ReturnCode := MessageDlg('Do you wish to save your special district changes?',
                                       mtConfirmation,
                                       [mbYes, mbNo, mbCancel], 0);

              case ReturnCode of
                idNo : If (SpecialDistrictTable.State = dsInsert)
                         then SpecialDistrictTable.Cancel
                         else RefreshNoPost(SpecialDistrictTable);

                idCancel : Abort;

              end;  {case ReturnCode of}

            end;  {If ((not FormIsInitializing) and ...}

      end
    else Abort;

end;  {SpecialDistrictTableBeforePost}

{==============================================================}
Function CheckIfOppositeYearHasDuplicate(SDTable,
                                         OppositeYearSDTable,
                                         OppositeYearParcelTable : TTable;
                                         OppositeTaxYear : String;
                                         SwisSBLKey : String) : Boolean;

{FXX02221999-13: Make sure not to add a dupliate SD on opposite year if already exists.}

var
  DuplicateFound, Done, FirstTimeThrough : Boolean;

begin
  DuplicateFound := False;

  OppositeYearSDTable.CancelRange;
  SetRangeOld(OppositeYearSDTable,
              ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
              [OppositeTaxYear, SwisSBLKey, '     '],
              [OppositeTaxYear, SwisSBLKey, 'ZZZZZ']);

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else OppositeYearSDTable.Next;

    If OppositeYearSDTable.EOF
      then Done := True;

    If not Done
      then
        begin
          If (OppositeYearSDTable.FieldByName('SDistCode').Text =
              SDTable.FieldByName('SDistCode').Text)
            then DuplicateFound := True;

        end;  {If not Done}

  until Done;

  Result := DuplicateFound;

end;  {CheckIfOppositeYearHasDuplicate}

{==============================================================}
Procedure TParcelSpecialDistrictForm.SpecialDistrictTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.}

var
  ExemptionCodes,  {Note that the exemption lists will be empty since we are not adjusting exemption roll totals.}
  ExemptionHomesteadCodes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  NewSDAmounts : TList;

    {CHG10281997-1: Dual mode processing.}

  OppositeYearHasDuplicate, Found : Boolean;

  OppositeYearExemptionCodeTable,
  OppositeYearExemptionTable,
  OppositeYearAssessmentTable,
  OppositeYearParcelTable,
  OppositeYearSDCodeTable : TTable;

  SBLRec : SBLRecord;

begin
  BasicSTARAmount := 0;
  EnhancedSTARAmount := 0;
  Found := False;

    {Note that if they are deleting a record, we are not recording the
     changes (since DeletingARecord is True, the RecordChanges is not
     performed.}

      {FXX11101997-3: Pass the screen name into RecordChanges so
                      the screen names are more readable.}

  If (DeletingARecord or
      (RecordChanges(Self, 'Special District', SpecialDistrictTable, SwisSBLKey,
                     FieldTraceInformationList) > 0))
    then
      begin
        ParcelChanged := True;

          {Now adjust the SD roll totals.}

        ExemptionCodes := TStringList.Create;
        ExemptionHomesteadCodes := TStringList.Create;
        CountyExemptionAmounts := TStringList.Create;
        TownExemptionAmounts := TStringList.Create;
        SchoolExemptionAmounts := TStringList.Create;
        VillageExemptionAmounts := TStringList.Create;
        NewSDAmounts := TList.Create;

        TotalSpecialDistrictsForParcel(TaxRollYr,
                                       SwisSBLKey,
                                       ParcelTable,
                                       AssessmentTable,
                                       SpecialDistrictLookupTable,
                                       SpecialDistrictCodeTable,
                                       ExemptionTable,
                                       ExemptionCodeTable,
                                       NewSDAmounts);

          {CHG03231998-1: Also record SD and ex changes.}

        If ((not DeletingARecord) and
            (RecordAction <> raInserted))
          then InsertOneSDChangeTrace(SwisSBLKey, TaxRollYr,
                                      SpecialDistrictTable, AuditSDChangeTable,
                                      'C', OrigSDRec);

          {Delete all the old roll totals for this parcel.
           We are only going to adjust the special district roll
           totals since these are the only totals affected by
           an SD change.}

          {CHG12011997-2: STAR support}
          {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                          the parcel table for that.}
          {FXX02101999-4: Add land value to swis and school totals.}

        If not GlblSuppressRollTotalsUpdate
          then AdjustRollTotalsForParcel(TaxRollYr,
                                        ParcelTable.FieldByName('SwisCode').Text,
                                        ParcelTable.FieldByName('SchoolCode').Text,
                                        ParcelTable.FieldByName('HomesteadCode').Text,
                                        ParcelTable.FieldByName('RollSection').Text,
                                        0, 0, 0, 0,
                                        ExemptionCodes,
                                        ExemptionHomesteadCodes,
                                        CountyExemptionAmounts,
                                        TownExemptionAmounts,
                                        SchoolExemptionAmounts,
                                        VillageExemptionAmounts,
                                        ParcelTable,
                                        BasicSTARAmount,
                                        EnhancedSTARAmount,
                                        OrigSDAmounts,
                                        ['D'],  {sd}
                                        'D');  {Delete the totals.}

          {Add the new roll totals for this parcel.}

        If not GlblSuppressRollTotalsUpdate
          then AdjustRollTotalsForParcel(TaxRollYr,
                                        ParcelTable.FieldByName('SwisCode').Text,
                                        ParcelTable.FieldByName('SchoolCode').Text,
                                        ParcelTable.FieldByName('HomesteadCode').Text,
                                        ParcelTable.FieldByName('RollSection').Text,
                                        0, 0, 0, 0,
                                        ExemptionCodes,
                                        ExemptionHomesteadCodes,
                                        CountyExemptionAmounts,
                                        TownExemptionAmounts,
                                        SchoolExemptionAmounts,
                                        VillageExemptionAmounts,
                                        ParcelTable,
                                        BasicSTARAmount,
                                        EnhancedSTARAmount,
                                        NewSDAmounts,
                                        ['D'],  {sd}
                                        'A');  {Add the totals.}

        ExemptionCodes.Free;
        ExemptionHomesteadCodes.Free;
        CountyExemptionAmounts.Free;
        TownExemptionAmounts.Free;
        SchoolExemptionAmounts.Free;
        VillageExemptionAmounts.Free;
        ClearTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));
        FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

      end;  {If (RecordChanges(Self, ExemptionTable, ...}

        {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

  If (RecordAction = raInserted)
    then InsertOneSDChangeTrace(SwisSBLKey, TaxRollYr, SpecialDistrictTable,
                                AuditSDChangeTable, 'A', OrigSDRec);

   {CHG10281997-1: Dual mode processing.}
   {FXX07191999-8: Move taxes should not carry forward.}

  FindKeyOld(SpecialDistrictCodeTable, ['SDistCode'],
             [SpecialDistrictTable.FieldByName('SDistCode').Text]);

  If (GlblModifyBothYears and
      (SpecialDistrictCodeTable.FieldByName('ECd1').Text <> SdistEcMT))
    then
      begin
          {Open the tables for adjusting the opposite year roll totals.}

        OppositeYearExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                                 NextYear);
        OppositeYearExemptionTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                             NextYear);
        OppositeYearAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                              NextYear);
        OppositeYearParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                          NextYear);
        OppositeYearSDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                                          NextYear);

        FindKeyOld(OppositeYearAssessmentTable,
                   ['TaxRollYr', 'SwisSBLKey'],
                   [OppositeTaxYear, SwisSBLKey]);

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          FindKeyOld(OppositeYearParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot',
                      'Suffix'],
                     [OppositeTaxYear, SwisCode, Section,
                      SubSection, Block, Lot, Sublot, Suffix]);

          {FXX06222001-1: Don't move changes forward if NY parcel is inactive.}

        If (OppositeYearParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then MessageDlg('The special district change was not moved forward to next year' + #13 +
                          'because the next year parcel is inactive.' + #13 +
                          'Please make sure that this is correct.', mtWarning, [mbOK], 0)
          else
            begin
                 {Get the original SD values so that we can adjust the roll totals
                  after any changes.}

              ClearTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));

              TotalSpecialDistrictsForParcel(OppositeTaxYear,
                                             SwisSBLKey,
                                             OppositeYearParcelTable,
                                             OppositeYearAssessmentTable,
                                             OppositeYearParcelSDTable,
                                             OppositeYearSDCodeTable,
                                             OppositeYearExemptionTable,
                                             OppositeYearExemptionCodeTable,
                                             OrigSDAmounts);

                {Delete, edit or insert the record.}
                {FXX11021997-2: The table should be set up for deletion, editing,
                                or inserting after getting the original amounts
                                since this alters the record position.}

              If DeletingARecord
                then Found := FindKeyOld(OppositeYearParcelSDTable,
                                         ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                                         [OppositeTaxYear, SwisSBLKey,
                                          DeletedSDCode])
                else
                  begin
                      {Set the table in insert or edit mode depending on what action
                       the user did.}

                    case RecordAction of
                      raInserted : begin
                                     Found := True;

                                   end;  {raInserted}

                      raEdited : begin
                                   Found := FindKeyOld(OppositeYearParcelSDTable,
                                                       ['TaxRollYr', 'SwisSBLKey',
                                                        'SDistCode'],
                                                       [OppositeTaxYear,
                                                        SwisSBLKey,
                                                        SpecialDistrictTableSDistCode.Text]);

                                   If Found
                                     then OppositeYearParcelSDTable.Edit;

                                     {CHG03231998-1: Also record SD and ex changes.}

                                   with OrigSDRec do
                                     begin
                                       PrimaryUnits := OppositeYearParcelSDTable.FieldByName('PrimaryUnits').AsFloat;
                                       SecondaryUnits := OppositeYearParcelSDTable.FieldByName('SecondaryUnits').AsFloat;
                                       CalcAmount := OppositeYearParcelSDTable.FieldByName('CalcAmount').AsFloat;
                                       SDPercentage := OppositeYearParcelSDTable.FieldByName('SDPercentage').AsFloat;
                                       CalcCode := Take(1, OppositeYearParcelSDTable.FieldByName('CalcCode').Text)[1];

                                     end;  {with OrigSDRecord do}

                                 end;  {raEdited}

                    end;  {case RecordAction of}

                  end;  {else of If DeletingARecord}

                {Now either delete the record or copy it to the opposite year.}

              If Found
                then
                  begin
                    If DeletingARecord
                      then
                        begin
                            {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

                          InsertOneSDChangeTrace(SwisSBLKey, OppositeTaxYear,
                                                 OppositeYearParcelSDTable,
                                                 AuditSDChangeTable, 'D',
                                                 OrigSDRec);

                            {FXX12021999-3: Trace deletes of exemptions, sds in audit table.}

                          AddToTraceFile(SwisSBLKey, 'Special District',
                                         'Code', DeletedSDCode,
                                         '(Deleted)', Time, OppositeYearParcelSDTable);

                          OppositeYearParcelSDTable.Delete;

                            {FXX12101999-3: Make sure opposite year SDs are being recalculated.}

                          OppositeYearParcelChanged := True;
                        end
                      else
                        begin
                            {FXX04091999-3: Was not defaulting opposite year has duplicate to
                                            false.}

                          OppositeYearHasDuplicate := False;

                            {FXX02221999-1: Make sure not to put a STAR on opposite year if already exists.}

                          If (RecordAction = raInserted)
                            then OppositeYearHasDuplicate := CheckIfOppositeYearHasDuplicate(
                                                                                   SpecialDistrictTable,
                                                                                   OppositeYearParcelSDTable,
                                                                                   OppositeYearParcelTable,
                                                                                   OppositeTaxYear,
                                                                                   SwisSBLKey);

                          If OppositeYearHasDuplicate
                            then
                              begin
                                OppositeYearParcelChanged := False;

                                MessageDlg('The special district ' + SpecialDistrictTable.FieldByName('SDistCode').Text +
                                           ' already exists in Next Year.' + #13 +
                                           'It was not added to Next Year.' + #13 +
                                           'Please review.', mtInformation, [mbOK], 0);

                              end
                            else
                              begin

                                  {FXX12101999-3: Make sure opposite year SDs are being recalculated.}

                                OppositeYearParcelChanged := True;

                                If (RecordAction = raInserted)
                                  then OppositeYearParcelSDTable.Insert;

                                CreateFieldValuesAndLabels(Self, OppositeYearParcelSDTable,
                                                           FieldTraceInformationList);

                                  {Copy the fields from the main table to the new table, but make
                                   sure that we do not copy the tax roll year.}

                                CopyFields(SpecialDistrictTable, OppositeYearParcelSDTable,
                                           ['TaxRollYr'], [OppositeTaxYear]);

                                try
                                  OppositeYearParcelSDTable.Post;
                                except
                                  SystemSupport(050, OppositeYearParcelSDTable,
                                                'Error posting opposite year record.', UnitName,
                                                GlblErrorDlgBox);
                                end;

                                  {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

                                If (RecordAction = raInserted)
                                  then InsertOneSDChangeTrace(SwisSBLKey, OppositeTaxYear,
                                                              OppositeYearParcelSDTable,
                                                              AuditSDChangeTable, 'A',
                                                              OrigSDRec);

                                  {CHG03231998-1: Also record SD and ex changes.}

                                If ((not DeletingARecord) and
                                    (RecordAction <> raInserted))
                                  then InsertOneSDChangeTrace(SwisSBLKey, OppositeTaxYear,
                                                              OppositeYearParcelSDTable,
                                                              AuditSDChangeTable, 'C',
                                                              OrigSDRec);

                                If (RecordChanges(Self, 'Special District',
                                                  OppositeYearParcelSDTable, SwisSBLKey,
                                                  FieldTraceInformationList) > 0)
                                  then OppositeYearParcelChanged := True;

                              end;  {else of If OppositeYearHasDuplicate}

                          end;  {else of If DeletingARecord}

                    If OppositeYearParcelChanged
                      then
                        begin
                                  {Now get the new SD amounts and adjust.}

                          ExemptionCodes := TStringList.Create;
                          ExemptionHomesteadCodes := TStringList.Create;
                          CountyExemptionAmounts := TStringList.Create;
                          TownExemptionAmounts := TStringList.Create;
                          SchoolExemptionAmounts := TStringList.Create;
                          VillageExemptionAmounts := TStringList.Create;
                          NewSDAmounts := TList.Create;

                          TotalSpecialDistrictsForParcel(OppositeTaxYear,
                                                         SwisSBLKey,
                                                         OppositeYearParcelTable,
                                                         OppositeYearAssessmentTable,
                                                         OppositeYearParcelSDTable,
                                                         OppositeYearSDCodeTable,
                                                         OppositeYearExemptionTable,
                                                         OppositeYearExemptionCodeTable,
                                                         NewSDAmounts);

                            {Delete all the old roll totals for this parcel.
                             We are only going to adjust the special district roll
                             totals since these are the only totals affected by
                             an SD change.}

                           {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                                           the parcel table for that.}
                            {FXX02101999-4: Add land value to swis and school totals.}

                          If not GlblSuppressRollTotalsUpdate
                            then AdjustRollTotalsForParcel(OppositeTaxYear,
                                                          OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                                          OppositeYearParcelTable.FieldByName('SchoolCode').Text,
                                                          OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                                          OppositeYearParcelTable.FieldByName('RollSection').Text,
                                                          0, 0, 0, 0,
                                                          ExemptionCodes,
                                                          ExemptionHomesteadCodes,
                                                          CountyExemptionAmounts,
                                                          TownExemptionAmounts,
                                                          SchoolExemptionAmounts,
                                                          VillageExemptionAmounts,
                                                          OppositeYearParcelTable,
                                                          BasicSTARAmount,
                                                          EnhancedSTARAmount,
                                                          OrigSDAmounts,
                                                          ['D'],  {sd}
                                                          'D');  {Delete the totals.}

                            {Add the new roll totals for this parcel.}

                          If not GlblSuppressRollTotalsUpdate
                            then AdjustRollTotalsForParcel(OppositeTaxYear,
                                                          OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                                          OppositeYearParcelTable.FieldByName('SchoolCode').Text,
                                                          OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                                          OppositeYearParcelTable.FieldByName('RollSection').Text,
                                                          0, 0, 0, 0,
                                                          ExemptionCodes,
                                                          ExemptionHomesteadCodes,
                                                          CountyExemptionAmounts,
                                                          TownExemptionAmounts,
                                                          SchoolExemptionAmounts,
                                                          VillageExemptionAmounts,
                                                          OppositeYearParcelTable,
                                                          BasicSTARAmount,
                                                          EnhancedSTARAmount,
                                                          NewSDAmounts,
                                                          ['D'],  {sd}
                                                          'A');  {Add the totals.}

                          ExemptionCodes.Free;
                          ExemptionHomesteadCodes.Free;
                          CountyExemptionAmounts.Free;
                          TownExemptionAmounts.Free;
                          SchoolExemptionAmounts.Free;
                          VillageExemptionAmounts.Free;
                          ClearTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));
                          FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

                        end;  {If OppositeYearParcelChanged}

                  end;  {If Found}

            end;  {If (OppositeYearParcelTable.FieldByName( ...}

      end;  {If GlblModifyBothYears}

    {FXX10152004-2(2.8.0.14): Move the call to MarkRecChanged to after post so that it updates right away.}
    {Now, if the parcel changed, then update the parcel table.}

  If ParcelChanged
    then MarkRecChanged(ParcelTable, UnitName);

  DeletingARecord := False

end;  {SpecialDistrictTableAfterPost}

{==============================================================}
Procedure TParcelSpecialDistrictForm.CloseButtonClick(Sender: TObject);

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
Procedure TParcelSpecialDistrictForm.FormCloseQuery(    Sender: TObject;
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

  If (SpecialDistrictTable.State in [dsInsert, dsEdit])
    then SpecialDistrictTable.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode. Note that sometimes a record can be marked even
     if there were no changes if a person clicks on a drop down box (even without changing
     the value). So, since we are recording field values before any changes, we
     will compare them to now and if there are no changes, we will cancel this
     edit or insert.}

  If ((not SpecialDistrictTable.ReadOnly) and
      (SpecialDistrictTable.State in [dsInsert, dsEdit]) and
      SpecialDistrictTable.Modified)
    then
      If (NumRecordChanges(Self, SpecialDistrictTable, FieldTraceInformationList) = 0)
        then SpecialDistrictTable.Cancel
        else
          begin
            try
              SpecialDistrictTable.Post;
            except
              CanClose := False;
              GlblParcelPageCloseCancelled := True;
            end;

          end;  {else of If (NumRecordChanges(Self, ...}

  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure TParcelSpecialDistrictForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

var
  Quit : Boolean;
  SBLRec : SBLRecord;

begin
    {Now, if the parcel changed, then update the parcel table.}

  If ParcelChanged
    then MarkRecChanged(ParcelTable, UnitName);

    {CHG10281997-1: Dual mode processing.}

  If OppositeYearParcelChanged
    then
      begin
          {Close the parcel and reopen it for the opposite year.}

        ParcelTable.Close;

        OpenTableForProcessingType(ParcelTable, ParcelTableName,
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

        MarkRecChanged(ParcelTable, UnitName);

      end;  {If OppositeYearParcelChanged}

    {Close all tables here.}

  CloseTablesForForm(Self);

  ClearTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));
  FreeTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));
  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

  Action := caFree;

end;  {FormClose}

end.