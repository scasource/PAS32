unit PBasePg2;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBCtrls, StdCtrls, ExtCtrls, Mask, DB, DBTables, Buttons,
  Types, DBLookup, Wwtable, Wwdatsrc, wwdblook;

type
  TBaseParcelPg2Form = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    YearLabel: TLabel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    Label31: TLabel;
    EditDeedBook: TDBEdit;
    Label32: TLabel;
    EditDeedPage: TDBEdit;
    Label35: TLabel;
    EditGridCordNorth: TDBEdit;
    EditGridCordEast: TDBEdit;
    Label38: TLabel;
    EditAccountNo: TDBEdit;
    Label39: TLabel;
    EditLotGroup: TDBEdit;
    Label7: TLabel;
    EditRelatedSBL: TDBEdit;
    Label8: TLabel;
    EditSBLRelationship: TDBEdit;
    Label40: TLabel;
    EditAdditionalLots: TDBEdit;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    CloseButton: TBitBtn;
    Label4: TLabel;
    EditSBL: TMaskEdit;
    Label5: TLabel;
    EditName: TDBEdit;
    Label6: TLabel;
    EditLocation: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    RemapSBLLabel: TLabel;
    EditSplitMergeNo: TDBEdit;
    Label2: TLabel;
    Label12: TLabel;
    EditLastChangeDate: TDBEdit;
    Label13: TLabel;
    EditLastChangeByName: TDBEdit;
    Label11: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    lbAllocationFactor: TLabel;
    EditCommitmentTermYear: TDBEdit;
    EditAllocationFactor: TDBEdit;
    LookupEasementCode: TwwDBLookupCombo;
    LookupLandCommitmentCode: TwwDBLookupCombo;
    CodeTable: TwwTable;
    InactiveLabel: TLabel;
    IrregularShapeCheckBox: TDBCheckBox;
    Label18: TLabel;
    EditSchoolRelevy: TDBEdit;
    EditTownRelevy: TDBEdit;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    EditMortgageNumber: TDBEdit;
    Label22: TLabel;
    EditRS9LinkedField: TEdit;
    Label23: TLabel;
    Label25: TLabel;
    EditSplitSBL1: TEdit;
    EditSplitSBL2: TEdit;
    SwisCodeTable: TTable;
    Label26: TLabel;
    OppositeYearParcelTable: TTable;
    Label3: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    SetFocusTimer: TTimer;
    ArrearsCheckBox: TDBCheckBox;
    LastAddressChangeEdit: TDBEdit;
    Label28: TLabel;
    RemapOldSBLEdit: TEdit;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    Label24: TLabel;
    EditCountyID: TDBEdit;
    CoopSharesLabel: TLabel;
    EditCoopShares: TDBEdit;
    Label1: TLabel;
    PermanentRetentionCheckBox: TDBCheckBox;
    cbxSplitSchoolDistrict: TDBCheckBox;
    lbSplitSchoolDistrictGroup: TLabel;
    edSplitSchoolDistrictGroup: TDBEdit;
    btnEditOldSBL: TButton;
    Label16: TLabel;
    edLegalCity: TDBEdit;
    edLegalZip: TDBEdit;
    cbRestrictFromGIS: TDBCheckBox;
    Label17: TLabel;
    edBasicSTARSavings: TDBEdit;
    Label27: TLabel;
    edEnhancedSTARSavings: TDBEdit;
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ParcelTableAfterEdit(DataSet: TDataset);
    procedure ParcelTableAfterPost(DataSet: TDataset);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CodeLookupEnter(Sender: TObject);
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure ExitSplitSwisSBL(Sender: TObject);
    procedure ParcelTableBeforePost(DataSet: TDataset);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure SetCodeOnLookupCloseup(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure btnEditOldSBLClick(Sender: TObject);
      {override method of parent object so we can set parent and style of}
    {this 'nested' forms}
  protected
    procedure CreateParams(var Params: TCreateParams); override;

  private
    { private declarations }
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr : String;
    SwisSBLKey : String;
    ProcessingType : Integer;  {NextYear, ThisYear, History}

    FieldTraceInformationList : TList;

      {Have there been any changes?}

    ParcelChanged : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    FormIsInitializing,
    FormIsClosing : Boolean;

    OrigVillageRelevy,
    OrigSchoolRelevy : Extended;

      {CHG10281997-1: Dual mode processing.}

    OppositeProcessingType : Integer;
    OppositeTaxYear : String;
    OriginalFieldValues,
    NewFieldValues : TStringList;

    Procedure SetOldSBL;
    Procedure InitializeForm;
    Procedure SetFocusToFirstField;

    Function DetermineCodeTableName(Tag : Integer) : String;
    Procedure SetCodeTableName(Tag : Integer);

  end;

implementation

{$R *.DFM}

Uses Glblvars, PASUTILS, UTILEXSD,  PASTypes, WinUtils, Utilitys,
     GlblCnst, UtilRTot, dlgSBLEntryUnit;

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

  Ownership = 10;  {LLL1}
  Easement = 20;
  LandCommitment = 30;

    {Now we will put the lookups that are description based in a set for later
     reference.}
     {FXX08092010-1(2.26.1.12)[I7932]: The Easement lookup is no longer description based.}

  DescriptionIndexedLookups : DropdownTagIDSetType = [Ownership, LandCommitment];

{===========================================================================}
Procedure TBaseParcelPg2Form.CreateParams(var Params: TCreateParams);

begin
  inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{===========================================================================}
Procedure TBaseParcelPg2Form.SetOldSBL;

begin
  If ((Length(ParcelTable.FieldByName('RemapOldSBL').Text) = 26) and
       GlblLocateByOldParcelID)
    then RemapOldSBLEdit.Text :=
           ConvertSwisSBLToOldDashDotNoSwis(ParcelTable.FieldByName('RemapOldSBL').Text,
                                            AssessmentYearControlTable)
    else RemapOldSBLEdit.Text := ParcelTable.FieldByName('RemapOldSBL').AsString;

  If GlblLocateByOldParcelID
    then
      begin
        SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                            AssessmentYearControlTable);

        If _Compare(EditMode, 'M', coEqual)
          then btnEditOldSBL.Visible := True;

      end;

end;  {SetOldSBL}

{===========================================================================}
Procedure TBaseParcelPg2Form.InitializeForm;

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
  SBLRec : SBLRecord;
  Quit, Found : Boolean;
  I : Integer;

begin
  FormIsInitializing := True;
  FormIsClosing := False;
  UnitName := 'PBASEPG2.PAS';
  ParcelChanged := False;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        OriginalFieldValues := TStringList.Create;
        NewFieldValues := TStringList.Create;

          {This string lists will hold the labels and values of each field and will be used
           to insert changes into the trace file.}

(*        FieldValuesList := TStringList.Create;
        FieldLabelsList := TStringList.Create;*)

        FieldTraceInformationList := TList.Create;

          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then ParcelTable.ReadOnly := True;

          {If this is inquire mode or the processing type is not the main type
            (i.e. GlblTaxYearFlg), let's open it in readonly mode.}

        If ((EditMode = 'V') or
            (ProcessingType <> DetermineProcessingType(GlblTaxYearFlg)))
          then ParcelTable.ReadOnly := True;

        If GlblNameAddressUpdateOnly
          then ParcelTable.ReadOnly := False;

        OpenTablesForForm(Self, ProcessingType);

         {CHG03101999-1: Alos let them modify arrears.}

        If GlblNameAddressUpdateOnly
          then
            begin
                {If they are allowed to change the name and address, then set the parcel
                 table to not read only, then set all fields to read only and turn
                 back on only the name and address fields.}

                {Set all fields to read only.}

              with ParcelTable do
                For I := 0 to (FieldCount - 1) do
                  Fields[I].ReadOnly := True;

                {Now turn back on the arrears field.}

              ParcelTable.FieldByName('Arrears').ReadOnly := False;
              ParcelTable.FieldByName('LastChangeDate').ReadOnly := False;
              ParcelTable.FieldByName('LastChangeByName').ReadOnly := False;
              ParcelTable.FieldByName('MortgageNumber').ReadOnly := False;

            end;  {If GlblNameAddressUpdateOnly}

          {FXX03111999-1: Do not allow arrears in next year.}

        If (ProcessingType = NextYear)
          then ParcelTable.FieldByName('Arrears').ReadOnly := False;

          {Now look up this parcel.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode',
                               'Section', 'Subsection',
                               'Block', 'Lot', 'Sublot', 'Suffix'],
                              [TaxRollYr, SwisCode, Section,
                               SubSection, Block, Lot, Sublot,
                               Suffix]);

        If not Found
          then SystemSupport(003, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);

          {Now set the year label.}

        SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

          {FXX12151997-1: Make sure that the tital does not overlap the
                          assessed values.}

        TitleLabel.Caption := 'Parcel Information';

(*        case EditMode of
          'A' : TitleLabel.Caption := 'Parcel Add';
          'M' : TitleLabel.Caption := 'Parcel Modify';
          'V' : TitleLabel.Caption := 'Parcel View';

        end;  {case EditMode of} *)

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Now, for some reason the table is marked as
           Modified after we look it up (in modify mode).
           So, we will cancel the modify and set it in
           the proper mode.}

        If ((not ParcelTable.ReadOnly) and
            ParcelTable.Modified and
            (EditMode = 'M'))
          then
            begin
              ParcelTable.Edit;
              ParcelTable.Cancel;
            end;

        If ParcelTable.ReadOnly
          then
            begin
              SaveButton.Visible := False;
              CancelButton.Visible := False;
            end;

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

          {CHG10091997-1: Should zeroes be blanks or '0'?}
        SetDisplayFormatForCurrencyFields(Self, False);

          {FXX01071998-10: Relevy fields need decimals.}

        TNumericField(ParcelTable.FieldByName('SchoolRelevy')).DisplayFormat := CurrencyDecimalDisplay_BlankZero;
        TNumericField(ParcelTable.FieldByName('VillageRelevy')).DisplayFormat := CurrencyDecimalDisplay_BlankZero;
        TNumericField(ParcelTable.FieldByName('BasicSTARSavings')).DisplayFormat := DecimalDisplay_BlankZero;
        TNumericField(ParcelTable.FieldByName('EnhancedSTARSavings')).DisplayFormat := DecimalDisplay_BlankZero;

          {If there is a roll section 9 linked field, fill it in in
           dash dot SBL format.}

        If (Deblank(ParcelTable.FieldByName('RS9LinkedSBL').Text) <> '')
          then EditRS9LinkedField.Text := ConvertSwisSBLToDashDot(ParcelTable.FieldByName('RS9LinkedSBL').Text);

          {If there is a split SBL, fill them in the dash dot format.}

        If (Deblank(ParcelTable.FieldByName('SplitSwisSBL1').Text) <> '')
          then EditSplitSBL1.Text := ConvertSwisSBLToDashDot(ParcelTable.FieldByName('SplitSwisSBL1').Text);

          {If there is a split SBL, fill them in the dash dot format.}

        If (Deblank(ParcelTable.FieldByName('SplitSwisSBL2').Text) <> '')
          then EditSplitSBL1.Text := ConvertSwisSBLToDashDot(ParcelTable.FieldByName('SplitSwisSBL2').Text);

          {CHG10281997-1: Dual mode processing.
                          Note that there is only edit for parcel pg2,
                          no delete or insert.}

        If (ProcessingType = ThisYear)
          then OppositeProcessingType := NextYear
          else OppositeProcessingType := ThisYear;

        OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

        OpenTableForProcessingType(OppositeYearParcelTable,
                                   ParcelTableName,
                                   OppositeProcessingType, Quit);

          {FXX11131997-7: Refresh the drop downs when come in.}

        RefreshDropdownsAndLabels(Self, ParcelTable,
                                  DescriptionIndexedLookups);

          {FXX03031998-2: Set focus to the first field. Note that we must
                          do this on a timer so that the form is showing
                          by the time we try to set focus.  Otherwise,
                          we get an error trying to set focus in an invisible
                          window.}

        SetFocusTimer.Enabled := True;

          {FXX12091998-2: Do not let them edit the school and village relevies in NY.}

        If (ProcessingType = NextYear)
          then
            begin
              ParcelTable.FieldByName('VillageRelevy').ReadOnly := True;
              ParcelTable.FieldByName('SchoolRelevy').ReadOnly := True;

              with EditSchoolRelevy do
                begin
                  ReadOnly := True;
                  Color := clBtnFace;
                  Font.Color := clBlue;
                  TabStop := False;

                end;  {with EditSchoolRelevy do}

              with EditTownRelevy do
                begin
                  ReadOnly := True;
                  Color := clBtnFace;
                  Font.Color := clBlue;
                  TabStop := False;

                end;  {with EditVillageRelevy do}

            end;  {If (ProcessingType = NextYear)}

        SetOldSBL;

          {CHG04232003-3(2.07): Allow them t enter the number of shares for this parcel.}

        If GlblIsCoopRoll
          then
            begin
              CoopSharesLabel.Visible := True;
              EditCoopShares.Visible := True;
              EditCoopShares.TabStop := True;

            end;  {If GlblIsCoopRoll}

(*          {CHG02172005-1(2.8.3.7): Add system option to allow edit of old SBL.}

        If GlblAllowOldSBLEdit
          then
            begin
              ParcelTable.FieldByName('').ReadOnly := False;
              MakeEditNotReadOnly(RemapOldSBLEdit);
            end; *)

          {CHG04082005-1(2.8.3.16)[2093]: Add feature to permanently retain parcels.}

        If GlblEnablePermanentRetentionFeature
          then
            with PermanentRetentionCheckBox do
              begin
                DataField := 'RetainPermanently';
                Visible := True;
                TabStop := True;

              end;  {with PermanentRetentionCheckBox do}

          {CHG10082009-1(2.20.1.1)[F1005]: Allow for split school districts.}

        If GlblDisplaySplitSchoolSBLs
          then
            begin
              cbxSplitSchoolDistrict.Visible := True;
              lbSplitSchoolDistrictGroup.Visible := True;
              edSplitSchoolDistrictGroup.Visible := True;

            end;  {If GlblDisplaySplitSchoolSBLs}

        If glblDisplaySuppressFromGIS
        then
        begin
          lbAllocationFactor.Visible := False;
          EditAllocationFactor.Visible := False;
          cbRestrictFromGIS.Visible := True;
        end;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  FormIsInitializing := False;

      {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

end;  {InitializeForm}

{===========================================================}
Procedure TBaseParcelPg2Form.SetFocusToFirstField;

{FXX03031998-2: Set focus to the first field after insert, any post,
                and upon coming into the form.}

begin
  with EditDeedBook do
    begin
      SetFocus;
      SelectAll;
    end;

end;  {SetFocusToFirstField}

{===========================================================}
Procedure TBaseParcelPg2Form.SetFocusTimerTimer(Sender: TObject);

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
Procedure TBaseParcelPg2Form.EditEnter(Sender: TObject);

{Set the currency display to not have any commas or dollar sign for editing purpose.}

var
  TempField : TCurrencyField;

begin
  TempField := TCurrencyField(ParcelTable.FieldByName(TDBEdit(Sender).DataField));

  with TempField do
    If ((DataType = ftCurrency) and
         Currency)
      then DisplayFormat := DecimalDisplay_BlankZero;

  TDBEdit(Sender).SelectAll;

end;  {EditEnter}

{====================================================================}
Procedure TBaseParcelPg2Form.EditExit(Sender: TObject);

{Change the currency field back to normal display format.}

var
  TempField : TCurrencyField;

begin
  TempField := TCurrencyField(ParcelTable.FieldByName(TDBEdit(Sender).DataField));

   {FXX01071998-10: Relevy fields need decimals.}

  with TempField do
    If ((DataType = ftCurrency) and
         Currency)
      then DisplayFormat := CurrencyDecimalDisplay_BlankZero;

end;  {EditExit}

{====================================================================}
Function TBaseParcelPg2Form.DetermineCodeTableName(Tag : Integer) : String;

{Based on the tag of the lookup combo box, what table should we open in the
 code table? Note that the constants below are declared right after the
 IMPLEMENTATION directive.}

begin
  case Tag of  {LLL3}
    Ownership : Result := 'ZOwnershipTbl';
    Easement : Result := 'ZEasementTbl';
    landCommitment : Result := 'ZLandCommitmentTbl';

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{========================================================================}
Procedure TBaseParcelPg2Form.SetCodeTableName(Tag : Integer);

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
Procedure TBaseParcelPg2Form.CodeLookupEnter(Sender: TObject);

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

          {Also, change the selected in the lookup to match the index type.}

          If (Tag in DescriptionIndexedLookups)
            then
              begin
                Selected.Clear;
                Selected.Add('Description' + #9 + '30' + #9 + 'Description Description');
                Selected.Add('MainCode' + #9 +
                             IntToStr(CodeTable.FieldByName('MainCode').DataSize) +
                             #9 + 'MainCode Code');
              end
            else
              begin
                Selected.Clear;
                Selected.Add('MainCode' + #9 +
                             IntToStr(CodeTable.FieldByName('MainCode').DataSize) +
                             #9 + 'MainCode Code');
                Selected.Add('Description' + #9 + '30' + #9 + 'Description Description');

              end;  {else of If (Tag in DescriptionIndexedLookups)}

        end;  {If (CodeTable.TableName <> DetermineCode}

end;  {CodeLookupEnter}

{==============================================================}
Procedure TBaseParcelPg2Form.SetCodeOnLookupCloseup(Sender: TObject;
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
  If ((ParcelTable.State in [dsInsert, dsEdit]) and
      ParcelTable.Modified)
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

            If (Deblank(ParcelTable.FieldByName(FieldName).Text) = '')
              then ParcelTable.FieldByName(CodeFieldName).Text := ''
              else ParcelTable.FieldByName(CodeFieldName).Text :=
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

                FieldSize := ParcelTable.FieldByName(DescFieldName).DataSize - 1;  {Minus 1 because it includes #0.}

              end;  {If (Tag in DescriptionIndexedLookups)}

              {Now, if the field is now blank, then blank out the code.
               Otherwise, fill in the code in the table.}

            If (Deblank(ParcelTable.FieldByName(FieldName).Text) = '')
              then ParcelTable.FieldByName(DescFieldName).Text := ''
              else ParcelTable.FieldByName(DescFieldName).Text :=
                   Take(FieldSize, TwwDBLookupCombo(Sender).LookupTable.FieldByName('Description').Text);

               {Set the description label for the code based dropdown.}

            try
              TempLabel := TLabel(FindComponent(DescFieldName));
              TempLabel.Caption := ParcelTable.FieldByName(DescFieldName).Text;
              TempLabel.Hint := CodeTable.FieldByName('Description').Text;
            except
            end;

          end;  {else of If (TComponent(Sender).Tag in DescriptionIndexedLookups)}

end;  {SetCodeOnLookupCloseUp}

{=====================================================================================}
Procedure TBaseParcelPg2Form.ParcelTableAfterEdit(DataSet: TDataset);

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
        CreateFieldValuesAndLabels(Self, ParcelTable, FieldTraceInformationList);

        OrigSchoolRelevy := ParcelTable.FieldByName('SchoolRelevy').AsFloat;
        OrigVillageRelevy := ParcelTable.FieldByName('VillageRelevy').AsFloat;

          {FXX01202000-2: Copy information forward for parcel record on a field
                          by field basis only.}

        OriginalFieldValues.Clear;

        with ParcelTable do
          For I := 0 to (FieldCount - 1) do
            OriginalFieldValues.Add(Fields[I].Text);

      end;  {If not FormIsInitializing}

end;  {ParcelTableAfterEdit}

{===================================================================}
Procedure TBaseParcelPg2Form.btnEditOldSBLClick(Sender: TObject);

{CHG02132010-1(2.22.1.15)[]: Allow edit of old SBL.}

var
  dlgEnterSBL : TdlgEnterSBL;
  bSwisCodeInSBL : Boolean;
  sOldSwisSBL : String;

begin
  dlgEnterSBL := nil;
  
  try
    dlgEnterSBL := TdlgEnterSBL.Create(nil);

    sOldSwisSBL := ParcelTable.FieldByName('RemapOldSBL').AsString;

    bSwisCodeInSBL := _Compare(Length(sOldSwisSBL), 26, coEqual);

    If not bSwisCodeInSBL
      then sOldSwisSBL := ParcelTable.FieldByName('SwisCode').AsString + sOldSwisSBL;

    dlgEnterSBL.InitializeForm(sOldSwisSBL, ProcessingType);

    If (dlgEnterSBL.ShowModal = idOK)
      then
        with ParcelTable do
          try
            If not (State = dsEdit)
              then Edit;

            If bSwisCodeInSBL
              then FieldByName('RemapOldSBL').AsString := dlgEnterSBL.sOldSwisSBLKey
              else FieldByName('RemapOldSBL').AsString := Copy(dlgEnterSBL.sOldSwisSBLKey, 7, 20);
            SetOldSBL;
          except
          end;

  finally
    dlgEnterSBL.Free;
  end;

end;  {btnEditOldSBLClick}

{====================================================================}
Procedure TBaseParcelPg2Form.ExitSplitSwisSBL(Sender: TObject);

var
  TempSBLKey : String;
  ValidEntry : Boolean;

begin
  If not FormIsClosing
    then
      begin
        with Sender as TEdit do
          If (Deblank(Text) = '')
            then
              begin
                ValidEntry := True;
                TempSBLKey := '';
              end
            else TempSBLKey := ConvertSwisDashDotToSwisSBL(Text, SwisCodeTable, ValidEntry);

        If ValidEntry
          then
            begin
              If not (ParcelTable.State in [dsEdit, dsInsert])
                then ParcelTable.Edit;

              If (TComponent(Sender).Name = 'EditSplitSBL1')
                then ParcelTable.FieldByName('SplitSwisSBL1').Text := TempSBLKey
                else ParcelTable.FieldByName('SplitSwisSBL2').Text := TempSBLKey;

            end
          else
            begin
              MessageDlg('That is not a valid Swis\SBL entry.' + #13 +
                         'Please enter in the form ss/SBL where ss = Swis short code.',
                         mtError, [mbOK], 0);
              TEdit(Sender).SetFocus;
              Abort;
            end;

      end;  {If not FormIsClosing}

end;  {ExitSplitSwisSBL}

{=====================================================================================}
Procedure TBaseParcelPg2Form.ParcelTableBeforePost(DataSet: TDataset);

{FXX10291997-2: Set the last change name and date in before post, not
                on save click since can save without clicking save.}

begin
  ParcelTable.FieldByName('LastChangeByName').Text := GlblUserName;
  ParcelTable.FieldByName('LastChangeDate').AsDateTime := Date;

end;  {ParcelTableBeforePost}

{=====================================================================================}
Procedure TBaseParcelPg2Form.ParcelTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.}

var
  Quit, Found : Boolean;
  SBLRec : SBLRecord;
  ChangedFields : TStringList;
  NewSchoolRelevy, NewVillageRelevy : Extended;
  TempParcelTable : TTable;
  NumChanges, I : Integer;
  FieldName : String;

begin
      {FXX11101997-3: Pass the screen name into RecordChanges so
                      the screen names are more readable.}
    {FXX12301999-3: Make sure to always carry changes forward if they want them.}

  NumChanges := RecordChanges(Self, 'Base Information', ParcelTable, SwisSBLKey,
                              FieldTraceInformationList);

  If (NumChanges > 0)
    then ParcelChanged := True;

  NewSchoolRelevy := ParcelTable.FieldByName('SchoolRelevy').AsFloat;
  NewVillageRelevy := ParcelTable.FieldByName('VillageRelevy').AsFloat;

  If ((Roundoff(OrigSchoolRelevy, 2) <>  Roundoff(NewSchoolRelevy, 2)) or
      (Roundoff(OrigVillageRelevy, 2) <>  Roundoff(NewVillageRelevy, 2)))
    then
      begin
          {Rather than change all AdjustRollTotals routines to pass in the school and village
           relevy, we will fake it by passing in the relevy amounts in a temp parcel table.}

        TempParcelTable := TTable.Create(nil);
        OpenTableForProcessingType(TempParcelTable, ParcelTableName, ProcessingType, Quit);
        TempParcelTable.GotoCurrent(ParcelTable);

        with TempParcelTable do
          begin
            Edit;
            FieldByName('SchoolRelevy').AsFloat := OrigSchoolRelevy;
            FieldByName('VillageRelevy').AsFloat := OrigVillageRelevy;
          end;

          {FXX02101999-4: Add land value to swis and school totals.}

        AdjustRollTotalsForParcel(TaxRollYr,
                                  ParcelTable.FieldByName('SwisCode').Text,
                                  ParcelTable.FieldByName('SchoolCode').Text,
                                  ParcelTable.FieldByName('HomesteadCode').Text,
                                  '', 0, 0, 0, 0, nil, nil, nil, nil, nil, nil,
                                  TempParcelTable, 0, 0, nil, ['Z', 'V'],
                                  'D');  {Delete the totals.}

        with TempParcelTable do
          begin
            Cancel;
            Close;
            Free;
          end;

          {Now insert the new amounts - already in parcel table.}

        AdjustRollTotalsForParcel(TaxRollYr,
                                  ParcelTable.FieldByName('SwisCode').Text,
                                  ParcelTable.FieldByName('SchoolCode').Text,
                                  ParcelTable.FieldByName('HomesteadCode').Text,
                                  '', 0, 0, 0, 0, nil, nil, nil, nil, nil, nil,
                                  ParcelTable, 0, 0, nil, ['Z', 'V'],
                                  'A');  {Add the totals.}

      end;  {If ((Roundoff(OrigSchoolRelevy, 2) <>  Roundoff(NewSchoolRelevy, 2)) or ...}

   {CHG10281997-1: Dual mode processing.}

  If GlblModifyBothYears
    then
      begin
          {FXX01202000-2: Copy information forward for parcel record on a field
                          by field basis only.}

        NewFieldValues.Clear;

        with ParcelTable do
          For I := 0 to (FieldCount - 1) do
            NewFieldValues.Add(Fields[I].Text);

           {Now go through the list and compare on a field by field basis
            any changes.}

        ChangedFields := TStringList.Create;
        For I := 0 to (OriginalFieldValues.Count - 1) do
          If (NewFieldValues[I] <> OriginalFieldValues[I])
            then ChangedFields.Add(ParcelTable.Fields[I].FieldName);

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(OppositeYearParcelTable,
                              ['TaxRollYr', 'SwisCode',
                               'Section', 'Subsection',
                               'Block', 'Lot', 'Sublot', 'Suffix'],
                              [OppositeTaxYear,
                               SwisCode, Section, SubSection,
                               Block, Lot, Sublot, Suffix]);

        If Found
          then OppositeYearParcelTable.Edit;

        CreateFieldValuesAndLabels(Self, OppositeYearParcelTable,
                                   FieldTraceInformationList);

          {Copy the fields from the main table to the new table, but make
           sure that we do not copy the tax roll year.}

          {FXX06222001-1: Don't move changes forward if NY parcel is inactive.}
          {FXX01172002-1: The code said the information should only move forward if it WAS inactive.}

        If (Found and
            (OppositeYearParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then
            begin
                {Never copy the school and village relevies forward.}
                {FXX03101999-1: Also, don't copy the arrears flag forward.}

                {FXX01202000-2: Copy information forward for parcel record on a field
                                by field basis only.}

              For I := 0 to (ChangedFields.Count - 1) do
                begin
                  FieldName := ChangedFields[I];

                  If ((FieldName <> 'SchoolRelevy') and
                      (FieldName <> 'VillageRelevy') and
                      (FieldName <> 'SplitMergeNo') and
                      (FieldName <> 'SBLRelationship') and
                      (FieldName <> 'RelatedSBL') and
                      (FieldName <> 'Arrears'))
                    then OppositeYearParcelTable.FieldByName(FieldName).Text :=
                                         ParcelTable.FieldByName(FieldName).Text;

                end;  {For I := 0 to (ChangedFields.Count - 1) do}

              If (RecordChanges(Self, 'Base Information',
                                OppositeYearParcelTable, SwisSBLKey,
                                FieldTraceInformationList) > 0)
                then
                  with OppositeYearParcelTable do
                    begin
                      FieldByName('LastChangeByName').Text := GlblUserName;
                      FieldByName('LastChangeDate').AsDateTime := Date;
                    end;

              try
                OppositeYearParcelTable.Post;
              except
                SystemSupport(050, OppositeYearParcelTable,
                              'Error posting opposite year record.', UnitName,
                              GlblErrorDlgBox);
              end;

            end;  {If Found}

          {FXX06222001-1: Don't move changes forward if NY parcel is inactive.}

        If (Found and
            (OppositeYearParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag))
          then
            begin
              OppositeYearParcelTable.Cancel;
              MessageDlg('The parcel change was not moved forward to next year' + #13 +
                         'because the next year parcel is inactive.' + #13 +
                         'Please make sure that this is correct.', mtWarning, [mbOK], 0);

            end;  {If (Found and ...}

        ChangedFields.Free;

      end;  {If GlblModifyBothYears}

    {FXX03021998-2: Set focus back to the first field after post,.}

  SetFocusToFirstField;

end;  {ParcelTableAfterPost}

{===========================================================================}
Procedure TBaseParcelPg2Form.SaveButtonClick(Sender: TObject);

{FXX10291997-2: Set the last change name and date in before post, not
                on save click since can save without clicking save.}

begin
  If (ParcelTable.Modified and  {Table is modified.}
      (ParcelTable.State = dsEdit) and
      ((not GlblAskSave) or     {We should not confirm a save or...}
       (GlblAskSave and        {We should confirm a save and...}
        (MessageDlg('Do you want to save this parcel?', mtConfirmation,
                    [mbYes, mbCancel], 0) = mrYes))))  {They want to save it.}
    then ParcelTable.Post;

end;  {SaveButtonClick}

{===========================================================================}
Procedure TBaseParcelPg2Form.CancelButtonClick(Sender: TObject);

begin
  If (ParcelTable.Modified and
      (MessageDlg('Warning! You will lose all changes.' + #13 +
                  'Cancel anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes))
    then ParcelTable.Cancel;

end;  {CancelButtonClick}

{===========================================================================}
Procedure TBaseParcelPg2Form.CloseButtonClick(Sender: TObject);

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

{===========================================================================}
Procedure TBaseParcelPg2Form.FormCloseQuery(    Sender: TObject;
                                            var CanClose: Boolean);

var
  ReturnCode : Integer;

begin
  GlblParcelPageCloseCancelled := False;
  CanClose := True;

    {First see if anything needs to be saved. In order to
     determine if there are any changes, we need to sychronize
     the fields with what is in the DB edit boxes. To do this,
     we call the UpdateRecord. Then, if there are any changes,
     the Modified flag will be set to True.}

  If (ParcelTable.State in [dsInsert, dsEdit])
    then ParcelTable.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode. Note that sometimes a record can be marked even
     if there were no changes if a person clicks on a drop down box (even without changing
     the value). So, since we are recording field values before any changes, we
     will compare them to now and if there are no changes, we will cancel this
     edit or insert.}
    {FXX05151998-3: Don't ask save on close form if don't want to see save.}

  If ((not ParcelTable.ReadOnly) and
      (ParcelTable.State in [dsEdit, dsInsert]) and
      ParcelTable.Modified)
    then
      If (NumRecordChanges(Self, ParcelTable, FieldTraceInformationList) = 0)
        then ParcelTable.Cancel
        else
          If GlblAskSave
            then
              begin
                ReturnCode := MessageDlg('Do you wish to save your parcel changes?', mtConfirmation,
                                         [mbYes, mbNo, mbCancel], 0);

                case ReturnCode of
                  idYes : ParcelTable.Post;

                  idNo : ParcelTable.Cancel;

                  idCancel : begin
                               GlblParcelPageCloseCancelled := True;
                               CanClose := False;
                             end;

                end;  {case ReturnCode of}

              end
            else ParcelTable.Post;

end;  {FormCloseQuery}

{===========================================================================}
Procedure TBaseParcelPg2Form.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

begin
  FormIsClosing := True;
  CloseTablesForForm(Self);

    {Free up the trace lists.}

(*  FieldValuesList.Free;
  FieldLabelsList.Free; *)
  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

  OriginalFieldValues.Free;
  NewFieldValues.Free;

  Action := caFree;

end;  {FormClose}

end.