unit Pclassfm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons;

type
  TClassForm = class(TForm)
    MainDataSource: TwwDataSource;
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
    CloseButton: TBitBtn;
    InactiveLabel: TLabel;
    HomesteadGroupBox: TGroupBox;
    NonhomesteadGroupBox: TGroupBox;
    EditHstdAcres: TDBEdit;
    EditHstdLandVal: TDBEdit;
    EditHstdTotalVal: TDBEdit;
    EditHstdLandPercent: TDBEdit;
    EditHstdTotalPercent: TDBEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    EditHstdPhysicalQtyIncrease: TDBEdit;
    EditHstdPhysicalQtyDecrease: TDBEdit;
    EditHstdIncreaseForEqual: TDBEdit;
    EditHstdDecreaseForEqual: TDBEdit;
    Label3: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    EditHstdCountyTaxableValue: TEdit;
    EditHstdVillageTaxableValue: TEdit;
    EditHstdTownTaxableValue: TEdit;
    EditHstdSchoolTaxableValue: TEdit;
    Label13: TLabel;
    HstdTownLabel: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    Label16: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    NonhstdTownLabel: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    EditNonhstdAcres: TDBEdit;
    EditNonhstdLandVal: TDBEdit;
    EditNonhstdTotalVal: TDBEdit;
    EditNonhstdLandPercent: TDBEdit;
    EditNonhstdTotalPercent: TDBEdit;
    EditNonhstdPhysicalQtyIncrease: TDBEdit;
    EditNonhstdPhysicalQtyDecrease: TDBEdit;
    EditNonhstdIncreaseForEqual: TDBEdit;
    EditNonhstdDecreaseForEqual: TDBEdit;
    EditNonhstdCountyTaxableValue: TEdit;
    EditNonhstdVillageTaxableValue: TEdit;
    EditNonhstdTownTaxableValue: TEdit;
    EditNonhstdSchoolTaxableValue: TEdit;
    AssessmentTable: TTable;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    DisplayWarningTimer: TTimer;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    SDCodeTable: TTable;
    ExemptionCodeTable: TTable;
    ExemptionTable: TTable;
    ParcelSDTable: TTable;
    SwisCodeTable: TTable;
    OppositeYearClassTable: TTable;
    Label1: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    SetFocusTimer: TTimer;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    PartialAssessmentLabel: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterEdit(DataSet: TDataset);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure EditExit(Sender: TObject);
    procedure EditEnter(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure DisplayWarningTimerTimer(Sender: TObject);
    procedure SetFocusTimerTimer(Sender: TObject);

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

    FieldTraceInformationList : TList;
    ProcessingType : Integer;  {NextYear, ThisYear, History}

    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}

      {Have there been any changes?}

    ParcelChanged : Boolean;

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

      {Variables to keep track if the assessment changes. If they do, we will need to
       adjust roll totals and exemption amounts.}

    OrigLandVal, OrigTotalVal,
    OrigPhysicalQtyInc, OrigPhysicalQtyDec,
    OrigEqualizationInc, OrigEqualizationDec : Comp;

      {These variables are for keeping track of roll total changes
       and making sure that they keep the assessment in balance,
       i.e. any changes they make to the total assessed value must
       be reflected in the increase\decrease fields.}

    OrigHstdTotalVal,
    OrigHstdLandVal,
    OrigHstdPhysicalQtyInc,
    OrigHstdPhysicalQtyDec,
    OrigHstdEqualizationInc,
    OrigHstdEqualizationDec,
    OrigNonhstdTotalVal,
    OrigNonhstdLandVal,
    OrigNonhstdPhysicalQtyInc,
    OrigNonhstdPhysicalQtyDec,
    OrigNonhstdEqualizationInc,
    OrigNonhstdEqualizationDec : Comp;
    OrigExemptionCodes,
    OrigExemptionHomesteadCodes,
    OrigResidentialTypes,
    OrigCountyExemptionAmounts,
    OrigTownExemptionAmounts,
    OrigSchoolExemptionAmounts,
    OrigVillageExemptionAmounts : TStringList;
    OrigBasicSTARAmount, OrigEnhancedSTARAmount : Comp;
    OrigSDAmounts : TList;

      {Also, the new value fields. They are here since we compute them in
       before post for some data integrity checking, but we also use these
       values in after post for roll total adjustment.}

    NewHstdTotalVal,
    NewHstdLandVal,
    NewHstdPhysicalQtyInc,
    NewHstdPhysicalQtyDec,
    NewHstdEqualizationInc,
    NewHstdEqualizationDec,
    NewNonhstdTotalVal,
    NewNonhstdLandVal,
    NewNonhstdPhysicalQtyInc,
    NewNonhstdPhysicalQtyDec,
    NewNonhstdEqualizationInc,
    NewNonhstdEqualizationDec : Comp;

      {CHG10281997-1: Dual mode processing.}

    OppositeProcessingType : Integer;
    OppositeTaxYear : String;
    OppositeYearParcelChanged : Boolean;

    Procedure InitializeForm;
    Procedure SetFocusToFirstField;

    Procedure DisplayTaxableValues(ExemptionCodes,
                                   ExemptionHomesteadCodes,  {What is the homestead code for each exemption?}
                                   CountyExemptionAmounts,
                                   TownExemptionAmounts,
                                   SchoolExemptionAmounts,
                                   VillageExemptionAmounts : TStringList);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst,
     UtilRTot;  {Roll total adjustments}


{$R *.DFM}

{=====================================================================}
Procedure TClassForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{====================================================================}
Procedure TClassForm.DisplayTaxableValues(ExemptionCodes,
                                          ExemptionHomesteadCodes,  {What is the homestead code for each exemption?}
                                          CountyExemptionAmounts,
                                          TownExemptionAmounts,
                                          SchoolExemptionAmounts,
                                          VillageExemptionAmounts : TStringList);

var
  HstdAssessedVal, NonhstdAssessedVal : Comp;
  HstdEXAmounts, NonhstdEXAmounts : ExemptionTotalsArrayType;

begin
  HstdAssessedVal := MainTable.FieldByName('HstdTotalVal').AsInteger;
  NonhstdAssessedVal := MainTable.FieldByName('NonhstdTotalVal').AsInteger;

  If (GlblMunicipalityType = MTCity)
    then
      begin
        HstdTownLabel.Caption := 'City';
        NonhstdTownLabel.Caption := 'City';
      end;

  GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                         ExemptionHomesteadCodes,
                                         CountyExemptionAmounts,
                                         TownExemptionAmounts,
                                         SchoolExemptionAmounts,
                                         VillageExemptionAmounts,
                                         HstdEXAmounts,
                                         NonhstdEXAmounts);

  EditHstdCountyTaxableValue.Text := FormatFloat(CurrencyNormalDisplay,
                                                 HstdAssessedVal - HstdExAmounts[EXCounty]);
  EditHstdTownTaxableValue.Text := FormatFloat(CurrencyNormalDisplay,
                                               HstdAssessedVal - HstdExAmounts[EXTown]);
  EditHstdSchoolTaxableValue.Text := FormatFloat(CurrencyNormalDisplay,
                                                 HstdAssessedVal - HstdExAmounts[EXSchool]);
  EditHstdVillageTaxableValue.Text := FormatFloat(CurrencyNormalDisplay,
                                                  HstdAssessedVal - HstdExAmounts[EXVillage]);

  EditNonhstdCountyTaxableValue.Text := FormatFloat(CurrencyNormalDisplay,
                                                    NonhstdAssessedVal - NonhstdExAmounts[EXCounty]);
  EditNonhstdTownTaxableValue.Text := FormatFloat(CurrencyNormalDisplay,
                                                  NonhstdAssessedVal - NonhstdExAmounts[EXTown]);
  EditNonhstdSchoolTaxableValue.Text := FormatFloat(CurrencyNormalDisplay,
                                                    NonhstdAssessedVal - NonhstdExAmounts[EXSchool]);
  EditNonhstdVillageTaxableValue.Text := FormatFloat(CurrencyNormalDisplay,
                                                     NonhstdAssessedVal - NonhstdExAmounts[EXVillage]);

end;  {DisplayTaxableValues}

{====================================================================}
Procedure TClassForm.InitializeForm;

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
  Default : Real;
  OrigBasicSTARAmount, OrigEnhancedSTARAmount : Comp;
  I : Integer;

begin
  UnitName := 'PCLASSFM.PAS';  {mmm1}
  ParcelChanged := False;
  ClosingForm := False;
  FormIsInitializing := True;
  OrigExemptionCodes := TStringList.Create;
  OrigExemptionHomesteadCodes := TStringList.Create;
  OrigResidentialTypes := TStringList.Create;
  OrigCountyExemptionAmounts := TStringList.Create;
  OrigTownExemptionAmounts := TStringList.Create;
  OrigSchoolExemptionAmounts := TStringList.Create;
  OrigVillageExemptionAmounts := TStringList.Create;
  OrigSDAmounts := TList.Create;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        FieldTraceInformationList := TList.Create;

          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then MainTable.ReadOnly := True;

          {If this is inquire mode or the processing type is not the main type
          (i.e. GlblTaxYearFlg), let's open it in readonly mode.}
          {Also, if this is roll section 9, they can not make any changes since the
           assessment must be zero for an rs 9 parcel.}

        If ((EditMode = 'V') or
            (ProcessingType <> DetermineProcessingType(GlblTaxYearFlg)))
          then MainTable.ReadOnly := True;

          {FXX02272000-3: We were opening the tables for the GlblProcessingType.}

        OpenTablesForForm(Self, ProcessingType);

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
          then SystemSupport(002, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Get the assessment record.}

        try
          Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                              [TaxRollYr, Take(26, SwisSBLKey)]);
        except
          SystemSupport(003, AssessmentTable, 'Error finding key in assessment table.', UnitName, GlblErrorDlgBox);
        end;

        If not Found
          then SystemSupport(004, AssessmentTable, 'Error getting assessment record.', UnitName, GlblErrorDlgBox);

          {If there is no class record, then add one.}

        try
          Found := FindKeyOld(MainTable, ['TaxRollYr', 'SwisSBLKey'],
                              [TaxRollYr, Take(26, SwisSBLKey)]);
        except
          SystemSupport(005, MainTable, 'Error finding key in class table.', UnitName, GlblErrorDlgBox);
        end;

        If ((not Found) and
            (not MainTable.ReadOnly))
          then MainTable.Insert;

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

          {FXX12151997-1: Make sure that the tital does not overlap the
                          assessed values.}

        TitleLabel.Caption := 'Class';

(*        case EditMode of   {mmm5}
          'A' : TitleLabel.Caption := 'Class Add';
          'M' : TitleLabel.Caption := 'Class Modify';
          'V' : TitleLabel.Caption := 'Class View';

        end;  {case EditMode of} *)

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);

          {Now set the year label.}

        YearLabel.Caption := GetTaxYrLbl;

          {Set the SBL in the SBL edit so that it is visible.
           Note that it is not data aware since if there are
           no records, we have nothing to get the SBL from.}

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

          {CHG10091997-1: Should zeroes be blanks or '0'?}
        SetDisplayFormatForCurrencyFields(Self, False);

        with MainTable do
          begin
            TFloatField(FieldByName('HstdLandVal')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('HstdTotalVal')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('HstdPhysQtyInc')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('HstdPhysQtyDec')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('HstdEqualInc')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('HstdEqualDec')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('HstdAcres')).DisplayFormat := DecimalEditDisplay;

            TFloatField(FieldByName('NonhstdLandVal')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('NonhstdTotalVal')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('NonhstdPhysQtyInc')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('NonhstdPhysQtyDec')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('NonhstdEqualInc')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('NonhstdEqualDec')).DisplayFormat := CurrencyNormalDisplay;
            TFloatField(FieldByName('NonhstdAcres')).DisplayFormat := DecimalEditDisplay;

          end;  {with MainTable do}

          {If the frozen date is filled in, then no editing of the assessed values or
           increase\decrease fields is allowed. We will message them about this.}

          {CHG09162001-1: New security option to not allow value changes.}

        If ((Deblank(AssessmentTable.FieldByName('DateFrozen').Text) <> '') or
            (not GlblUserCanMakeValueChanges))
          then
            begin
              Default := 0.;

              MakeEditReadOnly(EditHstdLandVal, MainTable, False, Default);
              MakeEditReadOnly(EditHstdTotalVal, MainTable, False, Default);
              MakeEditReadOnly(EditHstdPhysicalQtyDecrease, MainTable, False, Default);
              MakeEditReadOnly(EditHstdPhysicalQtyIncrease, MainTable, False, Default);
              MakeEditReadOnly(EditHstdDecreaseForEqual, MainTable, False, Default);
              MakeEditReadOnly(EditHstdIncreaseForEqual, MainTable, False, Default);

              MakeEditReadOnly(EditNonhstdLandVal, MainTable, False, Default);
              MakeEditReadOnly(EditNonhstdTotalVal, MainTable, False, Default);
              MakeEditReadOnly(EditNonhstdPhysicalQtyDecrease, MainTable, False, Default);
              MakeEditReadOnly(EditNonhstdPhysicalQtyIncrease, MainTable, False, Default);
              MakeEditReadOnly(EditNonhstdDecreaseForEqual, MainTable, False, Default);
              MakeEditReadOnly(EditNonhstdIncreaseForEqual, MainTable, False, Default);

                {We want to display the warning message on
                 a timer so that the class screen displays first.}

              DisplayWarningTimer.Enabled := True;

            end;  {If (Deblank(AssessmentTable.FieldByName ...}

          {If this is a roll section 9 parcel, let them know that they can not edit the values.}

        If (ParcelTable.FieldByName('RollSection').Text = '9')
          then DisplayWarningTimer.Enabled := True;

          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                 ExemptionTable,
                                 ExemptionCodeTable,
                                 ParcelTable.FieldByName('HomesteadCode').Text,
                                 'A',
                                 OrigExemptionCodes,
                                 OrigExemptionHomesteadCodes,
                                 OrigResidentialTypes,
                                 OrigCountyExemptionAmounts,
                                 OrigTownExemptionAmounts,
                                 OrigSchoolExemptionAmounts,
                                 OrigVillageExemptionAmounts,
                                 OrigBasicSTARAmount,
                                 OrigEnhancedSTARAmount);

        DisplayTaxableValues(OrigExemptionCodes,
                             OrigExemptionHomesteadCodes,
                             OrigCountyExemptionAmounts,
                             OrigTownExemptionAmounts,
                             OrigSchoolExemptionAmounts,
                             OrigVillageExemptionAmounts);

          {CHG10281997-1: Dual mode processing.
                          Note that there is only edit for class page,
                          no delete or insert.}

        If (ProcessingType = ThisYear)
          then OppositeProcessingType := NextYear
          else OppositeProcessingType := ThisYear;

        OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

        OpenTableForProcessingType(OppositeYearClassTable,
                                   ClassTableName,
                                   OppositeProcessingType, Quit);

          {FXX03031998-2: Set focus to the first field. Note that we must
                          do this on a timer so that the form is showing
                          by the time we try to set focus.  Otherwise,
                          we get an error trying to set focus in an invisible
                          window.}

        SetFocusTimer.Enabled := True;

          {CHG06291999-1: Keep the searcher from seeing next year values.}

        If ((ProcessingType = NextYear) and
            GlblUserIsSearcher and
            (not SearcherCanSeeNYValues))
          then
            For I := 0 to (ComponentCount - 1) do
              If (Components[I] is TDBEdit)
                then
                  with Components[I] as TDBEdit do
                    Visible := False;

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

      end;  {If (Deblank(SwisSBLKey) <> '')}

  FormIsInitializing := False;

end;  {InitializeForm}

{===========================================================}
Procedure TClassForm.SetFocusToFirstField;

{FXX03031998-2: Set focus to the first field after insert, any post,
                and upon coming into the form.}

begin
  with EditHstdLandPercent do
    begin
      SetFocus;
      SelectAll;
    end;

end;  {SetFocusToFirstField}

{===========================================================}
Procedure TClassForm.SetFocusTimerTimer(Sender: TObject);

{FXX03031998-2: Set focus to the first field. Note that we must
                do this on a timer so that the form is showing
                by the time we try to set focus.  Otherwise,
                we get an error trying to set focus in an invisible
                window.}

{CHG06291999-1: Keep the searcher from seeing next year values.}

begin
  If ((ProcessingType = NextYear) and
      GlblUserIsSearcher and
      (not SearcherCanSeeNYValues))
    then
      begin
        SetFocusTimer.Enabled := False;
        MessageDlg('Sorry, searchers can not view Next Year values.', mtError, [mbOk], 0);
      end
    else
      begin
        SetFocusTimer.Enabled := False;
        SetFocusToFirstField;
      end;

end;  {SetFocusTimerTimer}

{==============================================================}
Procedure TClassForm.DisplayWarningTimerTimer(Sender: TObject);

begin
  DisplayWarningTimer.Enabled := False;

  If (ParcelTable.FieldByName('RollSection').Text = '9')
    then MessageDlg('This is a roll section 9 parcel.' + #13 +
                    'No changes may be made to the class values.', mtInformation, [mbOK], 0)
    else
      If GlblUserCanMakeValueChanges
        then MessageDlg('The assessment for this parcel has been frozen.' + #13 +
                        'No changes to the assessment may be made until the frozen date is removed.',
                        mtWarning, [mbOK], 0);

end;  {WarningMessageTimerTimer}

{==============================================================}
Procedure TClassForm.MainTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in Self.}

begin
  If not FormIsInitializing
    then
      begin
        CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

          {Record the original values.}

        with MainTable do
          begin
            OrigHstdLandVal := TCurrencyField(FieldByName('HstdLandVal')).Value;
            OrigNonhstdLandVal := TCurrencyField(FieldByName('NonhstdLandVal')).Value;
            OrigHstdTotalVal := TCurrencyField(FieldByName('HstdTotalVal')).Value;
            OrigNonhstdTotalVal := TCurrencyField(FieldByName('NonhstdTotalVal')).Value;
            OrigHstdPhysicalQtyInc := TCurrencyField(FieldByName('HstdPhysQtyInc')).Value;
            OrigNonhstdPhysicalQtyInc := TCurrencyField(FieldByName('NonhstdPhysQtyInc')).Value;
            OrigHstdPhysicalQtyDec := TCurrencyField(FieldByName('HstdPhysQtyDec')).Value;
            OrigNonhstdPhysicalQtyDec := TCurrencyField(FieldByName('NonhstdPhysQtyDec')).Value;
            OrigHstdEqualizationInc := TCurrencyField(FieldByName('HstdEqualInc')).Value;
            OrigNonhstdEqualizationInc := TCurrencyField(FieldByName('NonhstdEqualInc')).Value;
            OrigHstdEqualizationDec := TCurrencyField(FieldByName('HstdEqualDec')).Value;
            OrigNonhstdEqualizationDec := TCurrencyField(FieldByName('NonhstdEqualDec')).Value;

          end;  {with MainTable do}

          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                 ExemptionTable,
                                 ExemptionCodeTable,
                                 ParcelTable.FieldByName('HomesteadCode').Text,
                                 'A',
                                 OrigExemptionCodes,
                                 OrigExemptionHomesteadCodes,
                                 OrigResidentialTypes,
                                 OrigCountyExemptionAmounts,
                                 OrigTownExemptionAmounts,
                                 OrigSchoolExemptionAmounts,
                                 OrigVillageExemptionAmounts,
                                 OrigBasicSTARAmount, OrigEnhancedSTARAmount);

        ClearTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));

        TotalSpecialDistrictsForParcel(TaxRollYr,
                                       SwisSBLKey,
                                       ParcelTable,
                                       AssessmentTable,
                                       ParcelSDTable,
                                       SDCodeTable,
                                       ExemptionTable,
                                       ExemptionCodeTable,
                                       OrigSDAmounts);

      end;  {If not FormIsInitializing}

end;  {MainTableAfterEdit}

{===========================================================================}
Procedure TClassForm.EditEnter(Sender: TObject);

{Set the currency display to not have any commas or dollar sign for editing purpose.}

var
  TempField : TField;

begin
  TempField := MainTable.FindField(TDBEdit(Sender).DataField);
  TFloatField(TempField).DisplayFormat := CurrencyEditDisplay;
  TDBEdit(Sender).SelectAll;

end;  {EditEnter}

{===========================================================================}
Procedure TClassForm.EditExit(Sender: TObject);

{Change the currency field back to normal display format.}

var
  TempField : TField;

begin
  TempField := MainTable.FindField(TDBEdit(Sender).DataField);
  TFloatField(TempField).DisplayFormat := CurrencyNormalDisplay;

end;  {EditExit}

{==============================================================}
Procedure TClassForm.MainTableBeforePost(DataSet: TDataset);

{If this is insert state, then fill in the SBL key and the
 tax roll year.}

var
  ReturnCode : Integer;
  ProceedWithPost : Boolean;
  TotalLandValue, TotalValue,
  ChangeInIncreaseFields, ChangeInDecreaseFields : Comp;
  TempHstdPercent, TempNonhstdPercent : Real;

begin
  ProceedWithPost := True;

  If ((not FormIsInitializing) and
      (MainTable.State in [dsEdit, dsInsert]))
    then
      begin
        MainTable.FieldByName('TaxRollYr').Text  := Take(4, TaxRollYr);
        MainTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);

          {Calculate the new land value, total value, physical quantity +\-, and
           equalization +\-.}

        with MainTable do
          begin
            NewHstdLandVal := TCurrencyField(FieldByName('HstdLandVal')).Value;
            NewNonhstdLandVal := TCurrencyField(FieldByName('NonhstdLandVal')).Value;
            NewHstdTotalVal := TCurrencyField(FieldByName('HstdTotalVal')).Value;
            NewNonhstdTotalVal := TCurrencyField(FieldByName('NonhstdTotalVal')).Value;
            NewHstdPhysicalQtyInc := TCurrencyField(FieldByName('HstdPhysQtyInc')).Value;
            NewNonhstdPhysicalQtyInc := TCurrencyField(FieldByName('NonhstdPhysQtyInc')).Value;
            NewHstdPhysicalQtyDec := TCurrencyField(FieldByName('HstdPhysQtyDec')).Value;
            NewNonhstdPhysicalQtyDec := TCurrencyField(FieldByName('NonhstdPhysQtyDec')).Value;
            NewHstdEqualizationInc := TCurrencyField(FieldByName('HstdEqualInc')).Value;
            NewNonhstdEqualizationInc := TCurrencyField(FieldByName('NonhstdEqualInc')).Value;
            NewHstdEqualizationDec := TCurrencyField(FieldByName('HstdEqualDec')).Value;
            NewNonhstdEqualizationDec := TCurrencyField(FieldByName('NonhstdEqualDec')).Value;

          end;  {with MainTable do}

          {Make sure that the land %'s add up to 100, the total %'s add up to 100 and that
           the hstd + nonhstd acreage add up to the parcel acreage.
           Also, the new total assessed value (hstd + nonhstd) minus any changes must equal
           the original total assessed value.}

           {FXX10301997-10: The percentages should add up to 1 not 100.
                            Actually the percentages should be whole and
                            add up to 100. This is really a conversion prob.}

        with MainTable do
          begin
              {FXX04151998-2: Automatically recalculate %'s rather than
                              warning that they don't add up to 100.}

              {The new value - any change in the increase fields + any change in the
               decrease fields must equal the original total value for the parcel to
               stay in balance. Do both homestead and non-homestead
               seperately.}

            ChangeInIncreaseFields := NewHstdPhysicalQtyInc +
                                      NewHstdEqualizationInc -
                                      (OrigHstdPhysicalQtyInc +
                                       OrigHstdEqualizationInc);

            ChangeInDecreaseFields := NewHstdPhysicalQtyDec +
                                      NewHstdEqualizationDec -
                                      (OrigHstdPhysicalQtyDec +
                                       OrigHstdEqualizationDec);

              {FXX04151998-4: Make imbalances a warning.}

            If (Roundoff(OrigHstdTotalVal, 0) <>
                Roundoff((NewHstdTotalVal - ChangeInIncreaseFields + ChangeInDecreaseFields), 0))
              then ProceedWithPost :=
                        (MessageDlg('The total homestead assessed value changed by ' +
                                    FormatFloat(CurrencyNormalDisplay, (NewHstdTotalVal - OrigHstdTotalVal)) + #13 +
                                   'but the homestead physical and equalization change fields do not reflect this change.' +
                                   #13 + #13 +
                                   'Are you sure this is correct?',
                                   mtConfirmation, [mbYes, mbNo], 0) = idYes);

              {Now do the nonhomestead values.}

            ChangeInIncreaseFields := NewNonhstdPhysicalQtyInc +
                                      NewNonhstdEqualizationInc -
                                      (OrigNonhstdPhysicalQtyInc +
                                       OrigNonhstdEqualizationInc);

            ChangeInDecreaseFields := NewNonhstdPhysicalQtyDec +
                                      NewNonhstdEqualizationDec -
                                      (OrigNonhstdPhysicalQtyDec +
                                       OrigNonhstdEqualizationDec);

            If (Roundoff(OrigNonhstdTotalVal, 0) <>
                Roundoff((NewNonhstdTotalVal - ChangeInIncreaseFields + ChangeInDecreaseFields), 0))
              then ProceedWithPost :=
                      (MessageDlg('The total nonhomestead assessed value changed by ' +
                                  FormatFloat(CurrencyNormalDisplay, (NewNonhstdTotalVal - OrigNonhstdTotalVal)) + #13 +
                                  'but the nonhomestead physical and equalization change fields do not reflect this change.'
                                  + #13 + #13 +
                                   'Are you sure this is correct?',
                                   mtConfirmation, [mbYes, mbNo], 0) = idYes);

          end;  {with MainTable do}

          {FXX05062002-1: Only ask this if they are in This Year!}

        If (ProceedWithPost and
            (ProcessingType = ThisYear))
          then ProceedWithPost := (MessageDlg('Warning! You are about to change a This Year assessed value.' + #13 +
                                   'Are you sure you want to do this?', mtWarning, [mbYes, mbNo], 0) = idYes);

          {Update the percentages.}

        If ProceedWithPost
          then
            begin
                {FXX04151998-2: Automatically recalculate %'s rather than
                 warning that they don't add up to 100.}

              TotalLandValue := NewNonhstdLandVal + NewHstdLandVal;
              TempHstdPercent := 0;
              TempNonhstdPercent := 0;

                {FXX02021999-1: If the Total Value = 0 which can occur after
                                a split, do not compute the values.}
                {FXX02021999-2: Had hstd and non-hstd percent calcs mixed up.}

              If (Roundoff(TotalLandValue, 0) > 0)
                then
                  begin
                    TempHstdPercent := NewHstdLandVal / TotalLandValue * 100;
                    TempNonhstdPercent := NewNonhstdLandVal / TotalLandValue * 100;
                    TempHstdPercent := Roundoff(TempHstdPercent, 0);
                    TempNonhstdPercent := Roundoff(TempNonhstdPercent, 0);
                  end;

              with MainTable do
                begin
                  FieldByName('HstdLandPercent').AsFloat := TempHstdPercent;
                  FieldByName('NonhstdLandPercent').AsFloat := TempNonhstdPercent;
                end;  {with MainTable do}

                {Now do the total value percents.}

              TotalValue := NewNonhstdTotalVal + NewHstdTotalVal;
              TempHstdPercent := 0;
              TempNonhstdPercent := 0;

                {FXX02021999-1: If the Total Value = 0 which can occur after
                                a split, do not compute the values.}
                {FXX02021999-2: Had hstd and non-hstd percent calcs mixed up.}

              If (Roundoff(TotalValue, 0) > 0)
                then
                  begin
                    TempHstdPercent := NewHstdTotalVal / TotalValue * 100;
                    TempNonhstdPercent := NewNonhstdTotalVal / TotalValue * 100;
                    TempHstdPercent := Roundoff(TempHstdPercent, 0);
                    TempNonhstdPercent := Roundoff(TempNonhstdPercent, 0);
                  end;

              with MainTable do
                begin
                  FieldByName('HstdTotalPercent').AsFloat := TempHstdPercent;
                  FieldByName('NonhstdTotalPercent').AsFloat := TempNonhstdPercent;
                end;  {with MainTable do}

            end;  {If ProceedWithPost}

          {FXX05151998-3: Don't ask save on close form if don't want to see save.}

        If ProceedWithPost
          then
            begin
              If GlblAskSave
                then
                  begin
                      {FXX11061997-2: Remove the "save before exiting" prompt because it
                                      is confusing. Use only "Do you want to save.}

                    ReturnCode := MessageDlg('Do you wish to save your class changes?', mtConfirmation,
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

      end;  {If ((not FormIsInitializing) and ...}

end;  {MainTableBeforePost}

{===================================================================}
Procedure TClassForm.SaveButtonClick(Sender: TObject);

begin
  If (MainTable.Modified and
      (MainTable.State in [dsEdit, dsInsert]))
     then MainTable.Post;

end;  {SaveButtonClick}

{==============================================================}
Procedure TClassForm.MainTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.

 Also, we will synchronize the assessment values in the assessment record with
 those in the class record.}

var
  NewExemptionCodes,
  NewExemptionHomesteadCodes,
  NewResidentialTypes,
  NewCountyExemptionAmounts,
  NewTownExemptionAmounts,
  NewSchoolExemptionAmounts,
  NewVillageExemptionAmounts : TStringList;
  NewBasicSTARAmount, NewEnhancedSTARAmount : Comp;
  NewSDAmounts : TList;

    {CHG10281997-1: Dual mode processing.}

  Found, Quit : Boolean;

  OppositeYearExemptionCodeTable,
  OppositeYearExemptionTable,
  OppositeYearAssessmentTable,
  OppositeYearParcelTable,
  OppositeYearSwisCodeTable,
  OppositeYearSDCodeTable,
  OppositeYearParcelSDTable : TTable;

  SBLRec : SBLRecord;
  NumChanges : Integer;

begin
      {FXX11101997-3: Pass the screen name into RecordChanges so
                      the screen names are more readable.}
    {FXX12301999-3: Make sure to always carry changes forward if they want them.}

  NumChanges := RecordChanges(Self, 'Class', MainTable, ExtractSSKey(ParcelTable),
                              FieldTraceInformationList);

  If (NumChanges > 0)
    then ParcelChanged := True;

    {If the land or total assessed value changed, then we will record the changes
     in the assessment record, adjust the roll totals and the exemption totals.}

  If ((Roundoff(OrigHstdLandVal, 0) <> Roundoff(NewHstdLandVal, 0)) or
      (Roundoff(OrigHstdTotalVal, 0) <> Roundoff(NewHstdTotalVal, 0)) or
      (Roundoff(OrigNonhstdLandVal, 0) <> Roundoff(NewNonhstdLandVal, 0)) or
      (Roundoff(OrigNonhstdTotalVal, 0) <> Roundoff(NewNonHstdTotalVal, 0)))
    then
      begin
        with AssessmentTable do
          try
            Edit;

            TCurrencyField(FieldByName('LandAssessedVal')).Value := NewHstdLandVal + NewNonhstdLandVal;
            TCurrencyField(FieldByName('TotalAssessedVal')).Value := NewHstdTotalVal + NewNonhstdTotalVal;
            TCurrencyField(FieldByName('PhysicalQtyIncrease')).Value := NewHstdPhysicalQtyInc +
                                                        NewNonhstdPhysicalQtyInc;
            TCurrencyField(FieldByName('PhysicalQtyDecrease')).Value := NewHstdPhysicalQtyDec +
                                                        NewNonhstdPhysicalQtyDec;
            TCurrencyField(FieldByName('IncreaseForEqual')).Value := NewHstdEqualizationInc +
                                                        NewNonhstdEqualizationInc;
            TCurrencyField(FieldByName('DecreaseForEqual')).Value := NewHstdEqualizationDec +
                                                        NewNonhstdEqualizationDec;
            Post;

          except
            SystemSupport(006, AssessmentTable, 'Error updating assessment record.',
                          UnitName, GlblErrorDlgBox);
          end;

          {Now adjust the roll totals.}

        NewExemptionCodes := TStringList.Create;
        NewExemptionHomesteadCodes := TStringList.Create;
        NewResidentialTypes := TStringList.Create;
        NewCountyExemptionAmounts := TStringList.Create;
        NewTownExemptionAmounts := TStringList.Create;
        NewSchoolExemptionAmounts := TStringList.Create;
        NewVillageExemptionAmounts := TStringList.Create;
        NewSDAmounts := TList.Create;

          {Since there has been an assessed value change,
           it is very possible that an exemption amount will change,
           too. So, we will recalculate all exemptions and redo the
           totals.}

        RecalculateExemptionsForParcel(ExemptionCodeTable,
                                       ExemptionTable,
                                       AssessmentTable,
                                       MainTable,
                                       SwisCodeTable,
                                       ParcelTable,
                                       TaxRollYr, SwisSBLKey, nil,
                                       0, 0, False);

          {Now figure out the new exemption totals.}
          {CHG12011997-2: STAR support}
          {FXX02091998-1: Pass the residential type of each exemption.}

        TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                 ExemptionTable,
                                 ExemptionCodeTable,
                                 ParcelTable.FieldByName('HomesteadCode').Text,
                                 'A',
                                 NewExemptionCodes,
                                 NewExemptionHomesteadCodes,
                                 NewResidentialTypes,
                                 NewCountyExemptionAmounts,
                                 NewTownExemptionAmounts,
                                 NewSchoolExemptionAmounts,
                                 NewVillageExemptionAmounts,
                                 NewBasicSTARAmount,
                                 NewEnhancedSTARAmount);

          {The special district amounts may have changed, so
           calculate the new special district amounts, too.}

        TotalSpecialDistrictsForParcel(TaxRollYr,
                                       SwisSBLKey,
                                       ParcelTable,
                                       AssessmentTable,
                                       ParcelSDTable,
                                       SDCodeTable,
                                       ExemptionTable,
                                       ExemptionCodeTable,
                                       NewSDAmounts);

          {Delete all the old roll totals for this parcel.
           Note that this can not be a split parcel since it
           would have a class record and no editing of the
           assessed value on the assessment screen could be done.}
         {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                         the parcel table for that.}
          {FXX02101999-4: Add land value to swis and school totals.}

        AdjustRollTotalsForParcel(TaxRollYr,
                                  ParcelTable.FieldByName('SwisCode').Text,
                                  ParcelTable.FieldByName('SchoolCode').Text,
                                  ParcelTable.FieldByName('HomesteadCode').Text,
                                  ParcelTable.FieldByName('RollSection').Text,
                                  OrigHstdLandVal,
                                  OrigNonhstdLandVal,
                                  OrigHstdTotalVal,
                                  OrigNonhstdTotalVal,
                                  OrigExemptionCodes,
                                  OrigExemptionHomesteadCodes,
                                  OrigCountyExemptionAmounts,
                                  OrigTownExemptionAmounts,
                                  OrigSchoolExemptionAmounts,
                                  OrigVillageExemptionAmounts,
                                  ParcelTable,
                                  OrigBasicSTARAmount,
                                  OrigEnhancedSTARAmount,
                                  OrigSDAmounts,
                                  ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                                  'D');  {Delete the totals.}

          {Add the new roll totals for this parcel.}

        AdjustRollTotalsForParcel(TaxRollYr,
                                  ParcelTable.FieldByName('SwisCode').Text,
                                  ParcelTable.FieldByName('SchoolCode').Text,
                                  ParcelTable.FieldByName('HomesteadCode').Text,
                                  ParcelTable.FieldByName('RollSection').Text,
                                  NewHstdLandVal, NewNonhstdLandVal,
                                  NewHstdTotalVal,
                                  NewNonhstdTotalVal,
                                  NewExemptionCodes,
                                  NewExemptionHomesteadCodes,
                                  NewCountyExemptionAmounts,
                                  NewTownExemptionAmounts,
                                  NewSchoolExemptionAmounts,
                                  NewVillageExemptionAmounts,
                                  ParcelTable,
                                  NewBasicSTARAmount,
                                  NewEnhancedSTARAmount,
                                  NewSDAmounts,
                                  ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                                  'A');  {Add the totals.}

        DisplayTaxableValues(NewExemptionCodes,
                             NewExemptionHomesteadCodes,
                             NewCountyExemptionAmounts,
                             NewTownExemptionAmounts,
                             NewSchoolExemptionAmounts,
                             NewVillageExemptionAmounts);

        NewExemptionCodes.Free;
        NewExemptionHomesteadCodes.Free;
        NewResidentialTypes.Free;
        NewCountyExemptionAmounts.Free;
        NewTownExemptionAmounts.Free;
        NewSchoolExemptionAmounts.Free;
        NewVillageExemptionAmounts.Free;
        ClearTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));
        FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

      end;  {If ((Roundoff(OrigLandVal, 0) <> ...}

    {Record the original values.}

    {CHG10281997-1: Dual mode processing.}

  If GlblModifyBothYears
    then
      begin
        Found := FindKeyOld(OppositeYearClassTable,
                            ['TaxRollYr', 'SwisSBLKey'],
                            [OppositeTaxYear, SwisSBLKey]);

        CreateFieldValuesAndLabels(Self, OppositeYearClassTable,
                                   FieldTraceInformationList);

          {Copy the fields from the main table to the new table, but make
           sure that we do not copy the tax roll year.}

        If Found
          then
            begin
                {Get the original amounts so we can adjust the totals
                 if necessary.}

              OppositeYearExemptionCodeTable := TTable.Create(nil);
              OppositeYearExemptionTable := TTable.Create(nil);
              OppositeYearAssessmentTable := TTable.Create(nil);
              OppositeYearParcelTable := TTable.Create(nil);
              OppositeYearSwisCodeTable := TTable.Create(nil);
              OppositeYearSDCodeTable := TTable.Create(nil);
              OppositeYearParcelSDTable := TTable.Create(nil);

              OpenTableForProcessingType(OppositeYearExemptionCodeTable,
                                         ExemptionCodesTableName,
                                         OppositeProcessingType, Quit);

              OppositeYearExemptionCodeTable.IndexName := 'BYEXCODE';

              OpenTableForProcessingType(OppositeYearExemptionTable,
                                         ExemptionsTableName,
                                         OppositeProcessingType, Quit);
              OppositeYearExemptionTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';

              OpenTableForProcessingType(OppositeYearAssessmentTable,
                                         AssessmentTableName,
                                         OppositeProcessingType, Quit);
              OppositeYearAssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

              FindKeyOld(AssessmentTable,
                         ['TaxRollYr', 'SwisSBLKey'],
                         [OppositeTaxYear, SwisSBLKey]);

              OpenTableForProcessingType(OppositeYearParcelTable,
                                         ParcelTableName,
                                         OppositeProcessingType, Quit);
              OppositeYearParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

              OpenTableForProcessingType(OppositeYearSwisCodeTable,
                                         SwisCodeTableName,
                                         OppositeProcessingType, Quit);
              OppositeYearSwisCodeTable.IndexName := 'BYSWISCODE';

              OpenTableForProcessingType(OppositeYearSDCodeTable,
                                         SdistCodeTableName,
                                         OppositeProcessingType, Quit);
              OppositeYearSDCodeTable.IndexName := 'BYSDISTCODE';

              OpenTableForProcessingType(OppositeYearParcelSDTable,
                                         SpecialDistrictTableName,
                                         OppositeProcessingType, Quit);
              OppositeYearParcelSDTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SD';

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
                then MessageDlg('The class assessment change was not moved forward to next year' + #13 +
                                'because the next year parcel is inactive.' + #13 +
                                'Please make sure that this is correct.', mtWarning, [mbOK], 0)
                else
                  begin
                    with OppositeYearClassTable do
                      begin
                        OrigHstdLandVal := TCurrencyField(FieldByName('HstdLandVal')).Value;
                        OrigNonhstdLandVal := TCurrencyField(FieldByName('NonhstdLandVal')).Value;
                        OrigHstdTotalVal := TCurrencyField(FieldByName('HstdTotalVal')).Value;
                        OrigNonhstdTotalVal := TCurrencyField(FieldByName('NonhstdTotalVal')).Value;
                        OrigHstdPhysicalQtyInc := TCurrencyField(FieldByName('HstdPhysQtyInc')).Value;
                        OrigNonhstdPhysicalQtyInc := TCurrencyField(FieldByName('NonhstdPhysQtyInc')).Value;
                        OrigHstdPhysicalQtyDec := TCurrencyField(FieldByName('HstdPhysQtyDec')).Value;
                        OrigNonhstdPhysicalQtyDec := TCurrencyField(FieldByName('NonhstdPhysQtyDec')).Value;
                        OrigHstdEqualizationInc := TCurrencyField(FieldByName('HstdEqualInc')).Value;
                        OrigNonhstdEqualizationInc := TCurrencyField(FieldByName('NonhstdEqualInc')).Value;
                        OrigHstdEqualizationDec := TCurrencyField(FieldByName('HstdEqualDec')).Value;
                        OrigNonhstdEqualizationDec := TCurrencyField(FieldByName('NonhstdEqualDec')).Value;

                      end;  {with MainTable do}

                      {CHG12011997-2: STAR support}
                      {FXX02091998-1: Pass the residential type of each exemption.}

                    TotalExemptionsForParcel(OppositeTaxYear, SwisSBLKey,
                                             OppositeYearExemptionTable,
                                             OppositeYearExemptionCodeTable,
                                             OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                             'A',
                                             OrigExemptionCodes,
                                             OrigExemptionHomesteadCodes,
                                             OrigResidentialTypes,
                                             OrigCountyExemptionAmounts,
                                             OrigTownExemptionAmounts,
                                             OrigSchoolExemptionAmounts,
                                             OrigVillageExemptionAmounts,
                                             OrigBasicSTARAmount,
                                             OrigEnhancedSTARAmount);

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

                       {FXX02031999-4: Don't copy forward any AR change fields.}

                    with OppositeYearClassTable do
                      try
                        Edit;

                        CopyFields(MainTable, OppositeYearClassTable,
                                   ['TaxRollYr', 'HstdPhysQtyInc',
                                    'NonhstdPhysQtyInc', 'HstdPhysQtyDec',
                                    'NonhstdPhysQtyDec', 'HstdEqualInc',
                                    'NonhstdEqualInc', 'HstdEqualDec',
                                    'NonhstdEqualDec'],
                                   [OppositeTaxYear, '0', '0', '0', '0',
                                    '0', '0', '0', '0']);
                        Post;
                      except
                        SystemSupport(007, MainTable, 'Error updating opposite year class table.',
                                      UnitName, glblErrorDlgBox);
                      end;

                    If (RecordChanges(Self, 'Class',
                                      OppositeYearClassTable, SwisSBLKey,
                                      FieldTraceInformationList) > 0)
                      then OppositeYearParcelChanged := True;

                      {Get the new values.}

                    with OppositeYearClassTable do
                      begin
                        NewHstdLandVal := TCurrencyField(FieldByName('HstdLandVal')).Value;
                        NewNonhstdLandVal := TCurrencyField(FieldByName('NonhstdLandVal')).Value;
                        NewHstdTotalVal := TCurrencyField(FieldByName('HstdTotalVal')).Value;
                        NewNonhstdTotalVal := TCurrencyField(FieldByName('NonhstdTotalVal')).Value;
                        NewHstdPhysicalQtyInc := TCurrencyField(FieldByName('HstdPhysQtyInc')).Value;
                        NewNonhstdPhysicalQtyInc := TCurrencyField(FieldByName('NonhstdPhysQtyInc')).Value;
                        NewHstdPhysicalQtyDec := TCurrencyField(FieldByName('HstdPhysQtyDec')).Value;
                        NewNonhstdPhysicalQtyDec := TCurrencyField(FieldByName('NonhstdPhysQtyDec')).Value;
                        NewHstdEqualizationInc := TCurrencyField(FieldByName('HstdEqualInc')).Value;
                        NewNonhstdEqualizationInc := TCurrencyField(FieldByName('NonhstdEqualInc')).Value;
                        NewHstdEqualizationDec := TCurrencyField(FieldByName('HstdEqualDec')).Value;
                        NewNonhstdEqualizationDec := TCurrencyField(FieldByName('NonhstdEqualDec')).Value;

                      end;  {with OppositeYearClassTable do}

                      {If the land or total assessed value changed, then we will record the changes
                       in the assessment record, adjust the roll totals and the exemption totals.}

                    If ((Roundoff(OrigHstdLandVal, 0) <> Roundoff(NewHstdLandVal, 0)) or
                        (Roundoff(OrigHstdTotalVal, 0) <> Roundoff(NewHstdTotalVal, 0)) or
                        (Roundoff(OrigNonhstdLandVal, 0) <> Roundoff(NewNonhstdLandVal, 0)) or
                        (Roundoff(OrigNonhstdTotalVal, 0) <> Roundoff(NewNonHstdTotalVal, 0)))
                      then
                        begin
                          with OppositeYearAssessmentTable do
                            try
                              Edit;

                              TCurrencyField(FieldByName('LandAssessedVal')).Value := NewHstdLandVal + NewNonhstdLandVal;
                              TCurrencyField(FieldByName('TotalAssessedVal')).Value := NewHstdTotalVal + NewNonhstdTotalVal;
                              TCurrencyField(FieldByName('PhysicalQtyIncrease')).Value := NewHstdPhysicalQtyInc +
                                                                          NewNonhstdPhysicalQtyInc;
                              TCurrencyField(FieldByName('PhysicalQtyDecrease')).Value := NewHstdPhysicalQtyDec +
                                                                          NewNonhstdPhysicalQtyDec;
                              TCurrencyField(FieldByName('IncreaseForEqual')).Value := NewHstdEqualizationInc +
                                                                          NewNonhstdEqualizationInc;
                              TCurrencyField(FieldByName('DecreaseForEqual')).Value := NewHstdEqualizationDec +
                                                                          NewNonhstdEqualizationDec;
                              Post;

                            except
                              SystemSupport(009, OppositeYearAssessmentTable, 'Error updating assessment record.',
                                            UnitName, GlblErrorDlgBox);
                            end;

                            {Now adjust the roll totals.}

                          NewExemptionCodes := TStringList.Create;
                          NewExemptionHomesteadCodes := TStringList.Create;
                          NewResidentialTypes := TStringList.Create;
                          NewCountyExemptionAmounts := TStringList.Create;
                          NewTownExemptionAmounts := TStringList.Create;
                          NewSchoolExemptionAmounts := TStringList.Create;
                          NewVillageExemptionAmounts := TStringList.Create;
                          NewSDAmounts := TList.Create;

                            {Since there has been an assessed value change,
                             it is very possible that an exemption amount will change,
                             too. So, we will recalculate all exemptions and redo the
                             totals.}

                          RecalculateExemptionsForParcel(OppositeYearExemptionCodeTable,
                                                         OppositeYearExemptionTable,
                                                         OppositeYearAssessmentTable,
                                                         OppositeYearClassTable,
                                                         SwisCodeTable,
                                                         ParcelTable,
                                                         OppositeTaxYear,
                                                         SwisSBLKey, nil,
                                                         0, 0, False);

                            {Now figure out the new exemption totals.}
                            {FXX02091998-1: Pass the residential type of each exemption.}

                          TotalExemptionsForParcel(OppositeTaxYear,
                                                   SwisSBLKey,
                                                   OppositeYearExemptionTable,
                                                   OppositeYearExemptionCodeTable,
                                                   ParcelTable.FieldByName('HomesteadCode').Text,
                                                   'A',
                                                   NewExemptionCodes,
                                                   NewExemptionHomesteadCodes,
                                                   NewResidentialTypes,
                                                   NewCountyExemptionAmounts,
                                                   NewTownExemptionAmounts,
                                                   NewSchoolExemptionAmounts,
                                                   NewVillageExemptionAmounts,
                                                   NewBasicSTARAmount,
                                                   NewEnhancedSTARAmount);

                            {The special district amounts may have changed, so
                             calculate the new special district amounts, too.}

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
                             Note that this can not be a split parcel since it
                             would have a class record and no editing of the
                             assessed value on the assessment screen could be done.}
                            {FXX02101999-4: Add land value to swis and school totals.}

                          AdjustRollTotalsForParcel(OppositeTaxYear,
                                                    OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                                    OppositeYearParcelTable.FieldByName('SchoolCode').Text,
                                                    OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                                    OppositeYearParcelTable.FieldByName('RollSection').Text,
                                                    OrigHstdLandVal, OrigNonhstdLandVal,
                                                    OrigHstdTotalVal,
                                                    OrigNonhstdTotalVal,
                                                    OrigExemptionCodes,
                                                    OrigExemptionHomesteadCodes,
                                                    OrigCountyExemptionAmounts,
                                                    OrigTownExemptionAmounts,
                                                    OrigSchoolExemptionAmounts,
                                                    OrigVillageExemptionAmounts,
                                                    OppositeYearParcelTable,
                                                    OrigBasicSTARAmount,
                                                    OrigEnhancedSTARAmount,
                                                    OrigSDAmounts,
                                                    ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                                                    'D');  {Delete the totals.}

                            {Add the new roll totals for this parcel.}

                          AdjustRollTotalsForParcel(OppositeTaxYear,
                                                    OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                                    OppositeYearParcelTable.FieldByName('SchoolCode').Text,
                                                    OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                                    OppositeYearParcelTable.FieldByName('RollSection').Text,
                                                    NewHstdLandVal, NewNonhstdLandVal,
                                                    NewHstdTotalVal,
                                                    NewNonhstdTotalVal,
                                                    NewExemptionCodes,
                                                    NewExemptionHomesteadCodes,
                                                    NewCountyExemptionAmounts,
                                                    NewTownExemptionAmounts,
                                                    NewSchoolExemptionAmounts,
                                                    NewVillageExemptionAmounts,
                                                    OppositeYearParcelTable,
                                                    NewBasicSTARAmount,
                                                    NewEnhancedSTARAmount,
                                                    NewSDAmounts,
                                                    ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                                                    'A');  {Add the totals.}

                          NewExemptionCodes.Free;
                          NewExemptionHomesteadCodes.Free;
                          NewResidentialTypes.Free;
                          NewCountyExemptionAmounts.Free;
                          NewTownExemptionAmounts.Free;
                          NewSchoolExemptionAmounts.Free;
                          NewVillageExemptionAmounts.Free;
                          ClearTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));
                          FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

                        end;  {If ((Roundoff(OrigLandVal, 0) <> ...}

                  end;  {If (OppositeYearParcelTable.FieldByName('ActiveFlag ...}

            end;  {If Found}

      end;  {If GlblModifyBothYears}

    {Now, if the parcel changed, then update the parcel table.}
    {FXX10152004-2(2.8.0.14): Move the call to MarkRecChanged to after post so that it updates right away.}

  If ParcelChanged
    then MarkRecChanged(ParcelTable, UnitName);

    {FXX03021998-2: Set the focus back to the first field after post.}

  SetFocusToFirstField;

end;  {MainTableAfterPost}

{===============================================================}
Procedure TClassForm.CancelButtonClick(Sender: TObject);

begin
  If (MainTable.Modified and
      (MainTable.State in [dsEdit, dsInsert]) and
      (MessageDlg('Warning! You will lose all changes.' + #13 +
                  'Cancel anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes))
    then MainTable.Cancel;

end;  {CancelButtonClick}

{==============================================================}
Procedure TClassForm.CloseButtonClick(Sender: TObject);

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
Procedure TClassForm.FormCloseQuery(    Sender: TObject;
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
    {FXX05151998-3: Don't ask save on close form if don't want to see save.}

  If ((not MainTable.ReadOnly) and
      (MainTable.State in [dsEdit, dsInsert]) and
      MainTable.Modified)
    then
      If (NumRecordChanges(Self, MainTable, FieldTraceInformationList) = 0)
        then MainTable.Cancel
        else
          If GlblAskSave
            then
              begin
                ReturnCode := MessageDlg('Do you wish to save your class changes?', mtConfirmation,
                                         [mbYes, mbNo, mbCancel], 0);

                case ReturnCode of
                  idYes : MainTable.Post;

                  idNo : MainTable.Cancel;

                  idCancel : begin
                               GlblParcelPageCloseCancelled := True;
                               CanClose := False;
                             end;

                end;  {case ReturnCode of}

              end
            else MainTable.Post;

  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure TClassForm.FormClose(    Sender: TObject;
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
                      'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                     [OppositeTaxYear, SwisCode, Section,
                      SubSection, Block, Lot, Sublot, Suffix]);

        MarkRecChanged(ParcelTable, UnitName);

      end;  {If OppositeYearParcelChanged}

    {Close all tables here.}

  CloseTablesForForm(Self);

    {FXX02091998-2: We were not freeing the original value TLists.}

  OrigExemptionCodes.Free;
  OrigExemptionHomesteadCodes.Free;
  OrigResidentialTypes.Free;
  OrigCountyExemptionAmounts.Free;
  OrigTownExemptionAmounts.Free;
  OrigSchoolExemptionAmounts.Free;
  OrigVillageExemptionAmounts.Free;
  ClearTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));
  FreeTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));

  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

  Action := caFree;

end;  {FormClose}

end.