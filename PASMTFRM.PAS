unit PAsmtfrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DBTables, DB, Mask, DBCtrls,
  Types, Buttons, BtrvDlg, Wwdbgrid, Wwdatsrc, Wwtable, wwdblook, wwMemo,
  Wwdbedit, PASUTILS, UTILEXSD,  PASTypes;

type
  TAssessmentForm = class(TForm)
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    Label7: TLabel;
    Label4: TLabel;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    Label1: TLabel;
    NextVisitDateLabel: TLabel;
    AssessmentNotesLabel: TLabel;
    Label8: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EditNextVisitDate: TDBEdit;
    EditPhysicalQtyIncrease: TDBEdit;
    EditPhysicalQtyDecrease: TDBEdit;
    EditIncreaseForEqual: TDBEdit;
    EditDecreaseForEqual: TDBEdit;
    EditTotalAssessedVal: TDBEdit;
    EditLandAssessedVal: TDBEdit;
    Panel1: TPanel;
    YearLabel: TLabel;
    TitleLabel: TLabel;
    ParcelTable: TTable;
    ParcelDataSource: TDataSource;
    CloseButton: TBitBtn;
    AsmtDateLabel: TLabel;
    AssessmentDateEdit: TDBEdit;
    Label5: TLabel;
    Label6: TLabel;
    EditName: TDBEdit;
    EditLastChangeDate: TDBEdit;
    Label15: TLabel;
    EditLastChangeByName: TDBEdit;
    EditDateFrozen: TDBEdit;
    EditReasonFrozen: TDBEdit;
    EditBldgPermits: TDBEdit;
    Label16: TLabel;
    Label18: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    ExemptionCodeTable: TTable;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    NotesMemo: TDBMemo;
    AssessmentNotesMemoDialog: TwwMemoDialog;
    AssessmentNotesButton: TButton;
    AssessmentNotesTable: TwwTable;
    AssessmentNotesDataSource: TwwDataSource;
    InactiveLabel: TLabel;
    OrigAssessedValueLookupCombo: TwwDBLookupCombo;
    RevisedAssessedValueLookupCombo: TwwDBLookupCombo;
    Label29: TLabel;
    Label30: TLabel;
    OrigAssessedValCodeTable: TwwTable;
    RevisedAssessedValCodeTable: TwwTable;
    ClassTable: TTable;
    SDCodeTable: TTable;
    ParcelSDTable: TTable;
    Label31: TLabel;
    SwisCodeTable: TTable;
    Label24: TLabel;
    ExemptionTable: TTable;
    DisplayWarningTimer: TTimer;
    ChangeLetterNotesLabel: TLabel;
    AssessmentLetterDataSource: TwwDataSource;
    AssessmentLetterTextTable: TwwTable;
    GroupBox1: TGroupBox;
    Label34: TLabel;
    EditPriorLandAssessedValue: TEdit;
    Label35: TLabel;
    EditPriorTotalAssessedValue: TEdit;
    AssessmentLetterTextMemoDialog: TwwMemoDialog;
    AssessmentLetterMemo: TDBMemo;
    AssessmentLetterChangeButton: TButton;
    OppositeYearAssessmentTable: TTable;
    ClassLabel: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    SetFocusTimer: TTimer;
    AuditAVChangeTable: TTable;
    Label27: TLabel;
    ClearDateFrozenButton: TBitBtn;
    OldParcelIDLabel: TLabel;
    AssessmentYearControlTable: TTable;
    PartialAssessmentDBCheckBox: TDBCheckBox;
    PartialAssessmentLabel: TLabel;
    AVChangeAmountEdit: TEdit;
    AVChangeAmountLabel: TLabel;
    AssessmentTable: TwwTable;
    AssessmentDataSource: TwwDataSource;
    AssessmentLookupTable: TTable;
    NassauValuesPanel: TPanel;
    EditNassauLandAssessedVal: TDBEdit;
    EditNassauTotalAssessedVal: TDBEdit;
    Label3: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label11: TLabel;
    EditPASLandAssessedVal: TDBEdit;
    EditPASTotalAssessedVal: TDBEdit;
    Label21: TLabel;
    lbImprovementValue: TLabel;
    edImprovementValue: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AssessmentTableAfterPost(DataSet: TDataset);
    procedure AssessmentTableAfterEdit(DataSet: TDataset);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AssessmentTableBeforePost(DataSet: TDataset);
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure AssessmentNotesButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure EditDateFrozenExit(Sender: TObject);
    procedure DisplayWarningTimerTimer(Sender: TObject);
    procedure AssessmentLetterChangeButtonClick(Sender: TObject);
    procedure AssessmentNotesTableNewRecord(DataSet: TDataset);
    procedure AssessmentLetterTextTableNewRecord(DataSet: TDataset);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure ClearDateFrozenButtonClick(Sender: TObject);
    procedure LookupComboNotInList(Sender: TObject;
      LookupTable: TDataSet; NewValue: String; var Accept: Boolean);
    procedure AssessmentTableNewRecord(DataSet: TDataSet);
    procedure EditNassauTotalAssessedValExit(Sender: TObject);
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
    AssessmentDate : TDateTime;  {What assessment date were they on last - let's synch them
                                  up so they always return to the same date.}

      {Have there been any changes?}

    ParcelChanged : Boolean;

    ClosingForm : Boolean;  {Are we in the process of closing this
                             form?}
    PostCancelled : Boolean;  {Was the  post cancelled?}

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    FormIsInitializing : Boolean;
    StateChar : Char;  {'E'dit or 'I'nsert - used for roll totals adjustment.}

      {These variables are for keeping track of exemption
       and SD roll total changes.}

    OrigPhysicalQtyInc,
    OrigPhysicalQtyDec,
    OrigEqualizationInc,
    OrigEqualizationDec,
    OrigTotalAssessedVal,
    OrigLandAssessedVal : Comp;
    OrigExemptionCodes,
    OrigExemptionHomesteadCodes,
    OrigResidentialTypes,
    OrigCountyExemptionAmounts,
    OrigTownExemptionAmounts,
    OrigSchoolExemptionAmounts,
    OrigVillageExemptionAmounts : TStringList;
    OrigBasicSTARAmount, OrigEnhancedSTARAmount : Comp;
    OrigSDAmounts : TList;
    OrigEXAmounts : ExemptionTotalsArrayType;

    NewPhysicalQtyInc,
    NewPhysicalQtyDec,
    NewEqualizationInc,
    NewEqualizationDec : Comp;

    ClassRecordFound : Boolean;

      {CHG10281997-1: Dual mode processing.}

    OppositeProcessingType : Integer;
    FormatString, OppositeTaxYear : String;
    OppositeYearParcelChanged : Boolean;
    PriorAssessedVal : Comp;
    AssessmentChanged : Boolean;
    OriginalChangeAmount : LongInt;
    FieldTraceInformationList : TList;

    Procedure InitializeForm;
    Procedure SetFocusToFirstField;
    Procedure ShowImprovementValue;
  end;

implementation

uses GlblVars, WinUtils, Utilitys,
     DataModule,
     UTILRTOT,  {Roll total update unit.}
     GlblCnst;

{$R *.DFM}

{======================================================================}
Procedure TAssessmentForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{====================================================================}
Procedure TAssessmentForm.ShowImprovementValue;

{CHG06092010-7(2.26.1)[I7394]: Show the improvement value.}

begin
  edImprovementValue.ReadOnly := False;
  edImprovementValue.Text := FormatFloat(IntegerDisplay,
                                         (AssessmentTable.FieldByName('TotalAssessedVal').AsInteger -
                                          AssessmentTable.FieldByName('LandAssessedVal').AsInteger));
  edImprovementValue.ReadOnly := True;

end;  {ShowImprovementValue}

{====================================================================}
Procedure TAssessmentForm.InitializeForm;

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
  ActiveParcel, I, PriorProcessingType : Integer;
  PriorTaxYear : String;
  PriorAssessmentTable : TTable;

begin
  UnitName := 'PASMTFRM.PAS';
  FormIsInitializing := True;
  AssessmentChanged := False;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {This string lists will hold the labels and values of each field and will be used
           to insert changes into the trace file.}

(*        FieldValuesList := TStringList.Create;
        FieldLabelsList := TStringList.Create; *)

        FieldTraceInformationList := TList.Create;

          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

          {If this is inquire mode or the processing type is not the main type
          (i.e. GlblTaxYearFlg), let's open it in readonly mode.}
          {Also, if this is roll section 9, they can not make any changes since the
           assessment must be zero for an rs 9 parcel.}
          {CHG10232002-1: Prevent CertOnly users from modifying anything else.}

        If ((EditMode = 'V') or
            (not ModifyAccessAllowed(FormAccessRights)) or
            (ProcessingType <> DetermineProcessingType(GlblTaxYearFlg)) or
            GlblCertiorariOnly)
          then
            begin
              AssessmentTable.ReadOnly := True;
              AssessmentLetterTextTable.ReadOnly := True;
              AssessmentNotesTable.ReadOnly := True;

              with AssessmentNotesMemoDialog do
                MemoAttributes := MemoAttributes + [mViewOnly];

              with AssessmentLetterTextMemoDialog do
                MemoAttributes := MemoAttributes + [mViewOnly];

            end;  {If ((EditMode = 'V') or ...}

          {FXX12011998-13: Don't allow searcher to see assessment notes.}

        If (GlblUserIsSearcher or
            GlblCertiorariOnly)
          then
            begin
              ChangeLetterNotesLabel.Visible := False;
              AssessmentNotesLabel.Visible := False;
              NotesMemo.Visible := False;
              AssessmentNotesButton.Visible := False;
              AssessmentLetterMemo.Visible := False;
              AssessmentLetterChangeButton.Visible := False;

            end;  {If GlblUserIsSearcher}

        OpenTablesForForm(Self, ProcessingType);

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode',
                               'Section', 'Subsection',
                               'Block', 'Lot', 'Sublot', 'Suffix'],
                              [TaxRollYr, SwisCode, Section,
                               SubSection, Block, Lot, Sublot, Suffix]);

        If not Found
           then SystemSupport(006, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {If there is no assessment record, then add one.}

        Found := FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                            [TaxRollYr, SwisSBLKey]);

        FindKeyOld(AssessmentLookupTable, ['TaxRollYr', 'SwisSBLKey'],
                   [TaxRollYr, SwisSBLKey]);

        If ((not Found) and
            (not AssessmentTable.ReadOnly))
          then AssessmentTable.Insert;

          {FXX06262001-2: Eliminate grayed check marks.}

        If (PartialAssessmentDBCheckBox.State = cbGrayed)
          then PartialAssessmentDBCheckBox.State := cbUnchecked;

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

        TitleLabel.Caption := 'Assessment';

          {FXX12151997-1: Make sure that the tital does not overlap the
                          assessed values.}

(*
        case EditMode of
          'A' : TitleLabel.Caption := 'Assessment Add';
          'M' : TitleLabel.Caption := 'Assessment Modify';
          'V' : TitleLabel.Caption := 'Assessment View';

        end;  {case EditMode of}  *)

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Now, for some reason the table is marked as
           Modified after we look it up (in modify mode).
           So, we will cancel the modify and set it in
           the proper mode.}

        If ((not AssessmentTable.ReadOnly) and
            AssessmentTable.Modified and
            (EditMode = 'M'))
          then
            begin
              AssessmentTable.Edit;
              AssessmentTable.Cancel;
            end;

          {Note that we will not automatically put them
           in edit mode or insert mode. We will make them
           take that action themselves since even though
           they are in an edit or insert session, they
           may not want to actually make any changes, and
           if they do not, they should not have to cancel.}

        If AssessmentTable.ReadOnly
          then
            begin
                {Disable any buttons that does
                 not apply in inquire mode.}

              SaveButton.Visible := False;
              CancelButton.Visible := False;

            end;  {If AssessmentTable.ReadOnly}

          {CHG10091997-1: Should zeroes be blanks or '0'?}

          {CHG04262007-1(2.11.1.26): Allow for option to suppress $ on assessments.}

        FormatString := GetAssessmentDisplayFormat;

        with AssessmentTable do
          begin
            TFloatField(FieldByName('LandAssessedVal')).DisplayFormat := FormatString;
            TFloatField(FieldByName('TotalAssessedVal')).DisplayFormat := FormatString;
            TFloatField(FieldByName('IncreaseForEqual')).DisplayFormat := FormatString;
            TFloatField(FieldByName('DecreaseForEqual')).DisplayFormat := FormatString;
            TFloatField(FieldByName('PhysicalQtyIncrease')).DisplayFormat := FormatString;
            TFloatField(FieldByName('PhysicalQtyDecrease')).DisplayFormat := FormatString;

          end;  {with AssessmentTable do}

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);

          {Now set the year label.}

        SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);

          {Set the SBL in the SBL edit so that it is visible.
           Note that it is not data aware since if there are
           no Assessment records, we have nothing to get the SBL from.}

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

          {Load the assessment note for this assessment, if there
           is any.}

        (*try
          Found := AssessmentNotesTable.FindKey([TaxRollYr, SwisSBLKey]);
        except
          SystemSupport(001, AssessmentNotesTable, 'Error finding assessment notes record.',
                        UnitName, GlblErrorDlgBox)
        end;

        If not Found
          then NotesMemo.Text := '';

          {Load the assessment change letter text for this assessment, if there
           is any.}

        try
          Found := AssessmentLetterTextTable.FindKey([TaxRollYr, SwisSBLKey]);
        except
          SystemSupport(001, AssessmentLetterTextTable, 'Error finding assessment letter change text record.',
                        UnitName, GlblErrorDlgBox)
        end;

        If not Found
          then AssessmentLetterMemo.Text := ''; *)

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        try
          ClassRecordFound := FindKeyOld(ClassTable,
                                         ['TaxRollYr', 'SwisSBLKey'],
                                         [TaxRollYr, Take(26, SwisSBLKey)]);
        except
          SystemSupport(006, ClassTable, 'Error finding class record.', UnitName, GlblErrorDlgBox);
        end;

          {If the frozen date is filled in, then no editing of the assessed values or
           increase\decrease fields is allowed. We will message them about this.
           Also, if there is a class record, all editing of values must be done in the class
           record itself.}

          {CHG09162001-1: New security option to not allow value changes.}
          {FXX04302003-1(2.07): Increase\decrease fields can be modified even when the
                                date frozen is filled in.}

        If ((Deblank(AssessmentTable.FieldByName('DateFrozen').Text) <> '') or
            ClassRecordFound or
            (not GlblUserCanMakeValueChanges))
          then
            begin
              Default := 0.;

              MakeEditReadOnly(EditLandAssessedVal, AssessmentTable, False, Default);
              MakeEditReadOnly(EditTotalAssessedVal, AssessmentTable, False, Default);
              MakeEditReadOnly(EditPASLandAssessedVal, AssessmentTable, False, Default);
              MakeEditReadOnly(EditPASTotalAssessedVal, AssessmentTable, False, Default);

              If (ClassRecordFound or
                  (not GlblUserCanMakeValueChanges))
                then
                  begin
                    MakeEditReadOnly(EditPhysicalQtyDecrease, AssessmentTable, False, Default);
                    MakeEditReadOnly(EditPhysicalQtyIncrease, AssessmentTable, False, Default);
                    MakeEditReadOnly(EditDecreaseForEqual, AssessmentTable, False, Default);
                    MakeEditReadOnly(EditIncreaseForEqual, AssessmentTable, False, Default);

                  end;  {If (ClassRecordFound or ...}

                {We want to display the appropriate warning message on
                 a timer so that the assessment screen displays first.}

              DisplayWarningTimer.Enabled := True;

            end;  {If (Deblank(AssessmentTable.FieldByName('FrozenDate').Text) <> '')}

          {If there is a class record, display a label.}

        If ClassRecordFound
          then ClassLabel.Visible := True;

        OrigExemptionCodes := TStringList.Create;
        OrigExemptionHomesteadCodes := TStringList.Create;
        OrigResidentialTypes := TStringList.Create;
        OrigCountyExemptionAmounts := TStringList.Create;
        OrigTownExemptionAmounts := TStringList.Create;
        OrigSchoolExemptionAmounts := TStringList.Create;
        OrigVillageExemptionAmounts := TStringList.Create;
        OrigSDAmounts := TList.Create;

          {If this is a roll section 9 parcel, let them know that they can not edit the values.}

        If (ParcelTable.FieldByName('RollSection').Text = '9')
          then DisplayWarningTimer.Enabled := True;

          {Fill in the prior year values.}

        If (ProcessingType = NextYear)
          then PriorProcessingType := ThisYear
          else PriorProcessingType := History;

        PriorTaxYear := IntToStr(StrToInt(TaxRollYr) - 1);

          {FXX11201997-1: Open and free prior assessment table right away.}
          {FXX02081999-4: Only display prior info if the parcel was created
                          before TY.}
          {FXX12201999-1: The previous fix was a stop gap because the prior values
                          were being copied on new parcels.  Remove it since it
                          causes problems.}

        (*If (ParcelTable.FieldByName('ParcelCreatedDate').AsDateTime <
            StrToDate('1/1/' + GlblThisYear))
          then
            begin*)
        PriorAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                       PriorProcessingType);

        try
          Found := FindKeyOld(PriorAssessmentTable,
                              ['TaxRollYr', 'SwisSBLKey'],
                              [PriorTaxYear, SwisSBLKey]);
        except
          SystemSupport(005, PriorAssessmentTable, 'Error looking up prior assessment.',
                        UnitName, GlblErrorDlgBox);
        end;

          {If there is no history yet, then we will use the prior value field of
           the TY record.}
          {FXX03212000-2: If not found in prior assessment table, but history exists,
                          then must not have existed.}

        PriorAssessedVal := 0;
        ActiveParcel := CheckIfParcelIsActive(PriorTaxYear, PriorProcessingType,
                                              SwisSBLKey);

        If Found
          then
            with PriorAssessmentTable do
              begin
                  {We found a prior assessment record, so use these values.}
                  {FXX05012000-8: If the parcel is inactive, then say so.}

                If (ActiveParcel = atActive)
                  then
                    begin
                      EditPriorLandAssessedValue.Text := FormatFloat(FormatString,
                                                                     FieldByName('LandAssessedVal').AsFloat);
                      EditPriorTotalAssessedValue.Text := FormatFloat(FormatString,
                                                                      FieldByName('TotalAssessedVal').AsFloat);
                    end
                  else
                    begin
                      EditPriorLandAssessedValue.Text := InactiveLabelText;
                      EditPriorTotalAssessedValue.Text := InactiveLabelText;
                    end;  {If (ActiveParcel = atActive)}

                PriorAssessedVal := FieldByName('TotalAssessedVal').AsFloat;
              end
          else
            If (GetRecordCount(PriorAssessmentTable) = 0)
              then
                with AssessmentTable do
                  begin
                      {There was no prior assessed value record, so we will look
                       in the prior value fields for this assessment record.
                       This should only happen for new parcels, in which case
                       these fields would be 0, or for a new installation that
                       does not have history.}

                    EditPriorLandAssessedValue.Text := FormatFloat(FormatString,
                                                                   FieldByName('PriorLandValue').AsFloat);
                    EditPriorTotalAssessedValue.Text := FormatFloat(FormatString,
                                                                    FieldByName('PriorTotalValue').AsFloat);

                      {FXX10041999-4: Was looking at wrong field for prior value.}

                    PriorAssessedVal := FieldByName('PriorTotalValue').AsFloat;

                  end;  {with AssessmentTable do}

          {CHG10281997-1: Dual mode processing.
                          Note that there is only edit for assessment page,
                          no delete or insert.}

        If (ProcessingType = ThisYear)
          then OppositeProcessingType := NextYear
          else OppositeProcessingType := ThisYear;

        OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

        OpenTableForProcessingType(OppositeYearAssessmentTable,
                                   AssessmentTableName,
                                   OppositeProcessingType, Quit);

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

       SetRangeOld(AssessmentLetterTextTable,
                   ['TaxRollYr', 'SwisSBLKey'],
                   [TaxRollYr, SwisSBLKey],
                   [TaxRollYr, SwisSBLKey]);

       SetRangeOld(AssessmentNotesTable,
                   ['TaxRollYr', 'SwisSBLKey'],
                   [TaxRollYr, SwisSBLKey],
                   [TaxRollYr, SwisSBLKey]);

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

    {CHG02042005-1(2.8.3.4): Allow for searching on the Nassau values in the Search report.}

  If GlblShowNassauValues
    then
      begin
        NassauValuesPanel.Visible := True;
        NassauValuesPanel.Top := 77;
        NassauValuesPanel.Left := 7;

        NextVisitDateLabel.Visible := False;
        EditNextVisitDate.Visible := False;

        AsmtDateLabel.Top := NextVisitDateLabel.Top - 10;
        AssessmentDateEdit.Top := EditNextVisitDate.Top;

        EditNassauLandAssessedVal.DataSource := AssessmentDataSource;
        EditNassauTotalAssessedVal.DataSource := AssessmentDataSource;

      end;  {If GlblShowNassauValues}

    {CHG06092010-7(2.26.1)[I7394]: Show the improvement value.}

  If glblShowImprovementValue
  then
  begin
    lbImprovementValue.Visible := True;
    edImprovementValue.Visible := True;
    ShowImprovementValue;
  end;

    {FXX03031998-2: Set focus to the first field. Note that we must
                    do this on a timer so that the form is showing
                    by the time we try to set focus.  Otherwise,
                    we get an error trying to set focus in an invisible
                    window.}

  SetFocusTimer.Enabled := True;

  FormIsInitializing := False;

end;  {InitializeForm}

{===========================================================}
Procedure TAssessmentForm.EditNassauTotalAssessedValExit(Sender: TObject);

{CHG02042005-1(2.8.3.4): Allow for searching on the Nassau values in the Search report.}

begin
  AssessmentDateEdit.SetFocus;
end;  {EditNassauTotalAssessedValExit}

{===========================================================}
Procedure TAssessmentForm.SetFocusToFirstField;

{FXX03031998-2: Set focus to the first field after insert, any post,
                and upon coming into the form.}
{CHG11192004-4(2.8.1.0)[1944]: Make the default the total assessed value field
                               since it is used more.}

begin
  If ClassRecordFound
    then
       with AssessmentDateEdit do
        begin
          SetFocus;
          SelectAll;
        end
    else
      If GlblShowNassauValues
        then
          with EditPASTotalAssessedVal do
            begin
              SetFocus;
              SelectAll;
            end
        else
          with EditTotalAssessedVal do
            begin
              SetFocus;
              SelectAll;
            end;

end;  {SetFocusToFirstField}

{===========================================================}
Procedure TAssessmentForm.SetFocusTimerTimer(Sender: TObject);

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

{===========================================================}
Procedure TAssessmentForm.DisplayWarningTimerTimer(Sender: TObject);

begin
  DisplayWarningTimer.Enabled := False;

  If (ParcelTable.FieldByName('RollSection').Text = '9')
    then MessageDlg('This is a roll section 9 parcel.' + #13 +
                    'No changes may be made to the assessment.', mtInformation, [mbOK], 0)
    else
      If ClassRecordFound
        then MessageDlg('This is a split parcel.' + #13 +
                        'Please make assessment changes to the class record.',
                        mtWarning, [mbOk], 0)
        else
          If GlblUserCanMakeValueChanges
            then MessageDlg('The assessment for this parcel has been frozen.' + #13 +
                            'No changes to the assessment may be made until the frozen date is removed.',
                            mtWarning, [mbOK], 0);

end;  {ClassDialogTimerTimer}

{===========================================================}
Procedure TAssessmentForm.EditEnter(Sender: TObject);

{Set the currency display to not have any commas or dollar sign for editing purpose.}

var
  TempField : TFloatField;

begin
  TempField := TFloatField(AssessmentTable.FieldByName(TDBEdit(Sender).DataField));

  with TempField do
    DisplayFormat := CurrencyEditDisplay;

  TDBEdit(Sender).SelectAll;

  If ((ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('IncreaseForEqual')) or
      (ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('DecreaseForEqual')) or
      (ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('PhysicalQtyIncrease')) or
      (ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('PhysicalQtyDecrease')))
    then OriginalChangeAmount := TempField.AsInteger;

end;  {EditEnter}

{===============================================================}
Procedure TAssessmentForm.EditExit(Sender: TObject);

{Change the currency field back to normal display format.}

var
  TempField : TFloatField;
  OriginalAssessedValue,
  CurrentChangeAmount, ChangeAmount : LongInt;

begin
  If AssessmentTable.Active
    then
      begin
        TempField := TFloatField(AssessmentTable.FieldByName(TDBEdit(Sender).DataField));

        with TempField do
          DisplayFormat := GetAssessmentDisplayFormat;

          {CHG11012001-2: Don't allow negative entries.}

        If (((ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('IncreaseForEqual')) or
             (ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('DecreaseForEqual')) or
             (ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('PhysicalQtyIncrease')) or
             (ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('PhysicalQtyDecrease'))) and
            (TempField.Value < 0))
          then
            begin
              MessageDlg('Please only enter positive amounts for the change amounts.' + #13 +
                         'If you want to show a decrease, then use the decrease fields.',
                         mtError, [mbOK], 0);
              Abort;
            end;

        CurrentChangeAmount := TempField.AsInteger;

          {CHG01262004-2(2.07l1): Option to enter increase or decrease in balancing field
                                  and have it change the AV.}

        If (GlblAV_BalancingFieldUpdates_AV and
            (CurrentChangeAmount <> 0) and
            (OriginalChangeAmount <> CurrentChangeAmount))
          then
            begin
              ChangeAmount := 0;

              If ((ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('IncreaseForEqual')) or
                  (ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('PhysicalQtyIncrease')))
                then ChangeAmount := TempField.AsInteger;

              If ((ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('DecreaseForEqual')) or
                  (ANSIUpperCase(TempField.FieldName) = ANSIUpperCase('PhysicalQtyDecrease')))
                then ChangeAmount := -1 * TempField.AsInteger;

              OriginalAssessedValue := AssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
              AssessmentTable.FieldByName('TotalAssessedVal').AsInteger := OriginalAssessedValue +
                                                                           ChangeAmount;

              If (ChangeAmount > 0)
                then MessageDlg('The total assessed value has increased by ' +
                                IntToStr(ChangeAmount) + ' from ' +
                                IntToStr(OriginalAssessedValue) + ' to ' +
                                AssessmentTable.FieldByName('TotalAssessedVal').Text + '.',
                                mtInformation, [mbOK], 0)
                else MessageDlg('The total assessed value has decreased by ' +
                                IntToStr(-1 * ChangeAmount) + ' from ' +
                                IntToStr(OriginalAssessedValue) + ' to ' +
                                AssessmentTable.FieldByName('TotalAssessedVal').Text + '.',
                                mtInformation, [mbOK], 0)

            end;  {If (GlblAV_BalancingFieldUpdates_AV and ...}

          {CHG06092010-7(2.26.1)[I7394]: Show the improvement value.}

        If (glblShowImprovementValue and
            _Compare(TempField.FieldName, ['LandAssessedVal', 'TotalAssessedVal'], coEqual))
        then ShowImprovementValue;

      end;  {If AssessmentTable.Active}

end;  {EditExit}

{=====================================================================================}
Procedure TAssessmentForm.AssessmentTableNewRecord(DataSet: TDataSet);

{FXX05292001-1: If the assessment record does not exist, make sure it gets the right year and SBL.}

begin
  AssessmentTable.FieldByName('TaxRollYr').Text := TaxRollYr;
  AssessmentTable.FieldByName('SwisSBLKey').Text := SwisSBlKey;
end;  {AssessmentTableNewRecord}

{=====================================================================================}
Procedure TAssessmentForm.AssessmentTableAfterEdit(DataSet: TDataset);

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
        CreateFieldValuesAndLabels(Self, AssessmentTable, FieldTraceInformationList);

          {Figure out the original values for roll total and exemption
           adjustments.}

        with AssessmentTable do
          begin
            OrigTotalAssessedVal := FieldByName('TotalAssessedVal').AsInteger;
            OrigLandAssessedVal := FieldByName('LandAssessedVal').AsInteger;
            OrigPhysicalQtyInc := FieldByName('PhysicalQtyIncrease').AsInteger;
            OrigPhysicalQtyDec := FieldByName('PhysicalQtyDecrease').AsInteger;
            OrigEqualizationInc := FieldByName('IncreaseForEqual').AsInteger;
            OrigEqualizationDec := FieldByName('DecreaseForEqual').AsInteger;

          end;  {with AssessmentTable do}

          {FXX02091998-1: Pass the residential type of each exemption.}

        OrigEXAmounts := TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
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

          {FIX11092004-1(2.8.0.19)[1971]: Since TotalSpecialDistrictsForParcel now calls
                                          CalculateHstdAndNonhstdAmounts which does a locate on the AssessmentTable,
                                          we must pass in the AssessmentLookupTable so as to not
                                          cause a cancel of the Edit mode.}

        TotalSpecialDistrictsForParcel(TaxRollYr,
                                       SwisSBLKey,
                                       ParcelTable,
                                       AssessmentLookupTable,
                                       ParcelSDTable,
                                       SDCodeTable,
                                       ExemptionTable,
                                       ExemptionCodeTable,
                                       OrigSDAmounts);

      end;  {If not FormIsInitializing}

end;  {AssessmentTableAfterEdit}

{=====================================================================================}
Procedure TAssessmentForm.EditDateFrozenExit(Sender: TObject);

{If the frozen date is now filled in, then make the value fields read only and
 tell them. If the value fields were read only, and the frozen date has now been
 removed, open up the value fields and let them know.}

var
  Default : Real;

begin
    {FXX04302003-1(2.07): Increase\decrease fields can be modified even when the
                          date frozen is filled in.}

  If ((not EditLandAssessedVal.ReadOnly) and
      (Deblank(AssessmentTable.FieldByName('DateFrozen').Text) <> ''))
    then
      begin
        Default := 0;

        MakeEditReadOnly(EditLandAssessedVal, AssessmentTable, False, Default);
        MakeEditReadOnly(EditTotalAssessedVal, AssessmentTable, False, Default);
        MakeEditReadOnly(EditPASLandAssessedVal, AssessmentTable, False, Default);
        MakeEditReadOnly(EditPASTotalAssessedVal, AssessmentTable, False, Default);
(*        MakeEditReadOnly(EditPhysicalQtyDecrease, AssessmentTable, False, Default);
        MakeEditReadOnly(EditPhysicalQtyIncrease, AssessmentTable, False, Default);
        MakeEditReadOnly(EditDecreaseForEqual, AssessmentTable, False, Default);
        MakeEditReadOnly(EditIncreaseForEqual, AssessmentTable, False, Default);*)

        MessageDlg('The assessment for this parcel has been frozen.' + #13 +
                   'No changes to the assessment may be made until the frozen date is removed.',
                   mtWarning, [mbOK], 0);

      end;  {If ((not EditLandAssessedVal.ReadOnly) ...}

    {The frozen date has been cleared.}
    {FXX10182006-1(2.10.2.3): Don't open up for editing unless the user is allowed to make changes.}

  If (EditLandAssessedVal.ReadOnly and
      (Deblank(AssessmentTable.FieldByName('DateFrozen').Text) = '') and
      (not AssessmentTable.ReadOnly) and 
      GlblUserCanMakeValueChanges)
    then
      begin
        MakeEditNotReadOnly(EditLandAssessedVal);
        MakeEditNotReadOnly(EditTotalAssessedVal);
        MakeEditNotReadOnly(EditPASLandAssessedVal);
        MakeEditNotReadOnly(EditPASTotalAssessedVal);
        MakeEditNotReadOnly(EditPhysicalQtyDecrease);
        MakeEditNotReadOnly(EditPhysicalQtyIncrease);
        MakeEditNotReadOnly(EditDecreaseForEqual);
        MakeEditNotReadOnly(EditIncreaseForEqual);

        MessageDlg('The assessment for this parcel is no longer frozen.' + #13 +
                   'Changes may now be made to the assessment.',
                   mtInformation, [mbOK], 0);

      end;  {If ((not EditLandAssessedVal.ReadOnly) ...}

end;  {EditDateFrozenExit}

{=====================================================================================}
Procedure TAssessmentForm.AssessmentTableBeforePost(DataSet: TDataset);

{If this user wants save confirmation, then ask it here.
 Otherwise, do not. Also, if we are closing the form, then we want
 to ask the question no matter what.}

var
  ReturnCode : Integer;
  NewTotalAssessedVal,
  (*ChangeInIncreaseFields, ChangeInDecreaseFields,*)
  TotalARChange : Comp;

begin
  PostCancelled := False;

    {FXX05151998-3: Don't ask save on close form if don't want to see save.}

  If ((not FormIsInitializing) and
      GlblAskSave)
    then
      begin
          {FXX11061997-2: Remove the "save before exiting" prompt because it
                          is confusing. Use only "Do you want to save.}

        ReturnCode := MessageDlg('Do you wish to save your assessment changes?', mtConfirmation,
                                 [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idNo : If (AssessmentTable.State = dsInsert)
                   then
                     begin
                       AssessmentTable.Cancel;
                       Abort;
                     end
                   else RefreshNoPost(AssessmentTable);

          idCancel : begin
                       PostCancelled := True;
                       Abort;
                     end;

        end;  {case ReturnCode of}

      end;  {If GlblAskSave}

    {The new value - any change in the increase fields + any change in the
     decrease fields must equal the original total value for the parcel to
     stay in balance.}

    {Calculate the new land value, total value, physical quantity +\-, and
     equalization +\-.}

    {FXX10261997-1: Only check for balancing if they want to save.}

  If not PostCancelled
    then
      begin
        with AssessmentTable do
          begin
            NewTotalAssessedVal := FieldByName('TotalAssessedVal').AsInteger;
            NewPhysicalQtyInc := FieldByName('PhysicalQtyIncrease').AsInteger;
            NewPhysicalQtyDec := FieldByName('PhysicalQtyDecrease').AsInteger;
            NewEqualizationInc := FieldByName('IncreaseForEqual').AsInteger;
            NewEqualizationDec := FieldByName('DecreaseForEqual').AsInteger;

          end;  {with AssessmentTable do}

(*        ChangeInIncreaseFields := NewPhysicalQtyInc +
                                  NewEqualizationInc -
                                  (OrigPhysicalQtyInc +
                                   OrigEqualizationInc);

        ChangeInDecreaseFields := NewPhysicalQtyDec +
                                  NewEqualizationDec -
                                  (OrigPhysicalQtyDec +
                                   OrigEqualizationDec); *)

          {FXX08181999-3: Compare old to new by looking only at the AR change fields
                          as they are now.}

        If (Roundoff(PriorAssessedVal, 0) <>
            Roundoff((NewTotalAssessedVal -
                      (NewPhysicalQtyInc +
                       NewEqualizationInc) +
                      (NewPhysicalQtyDec +
                       NewEqualizationDec)), 0))
          then
            begin
                {CHG02251998-1: Let them override out of balance parcels.}
                {FXX10211999-1: Give a better message.}

              TotalARChange := (NewPhysicalQtyInc +
                                NewEqualizationInc) +
                               (NewPhysicalQtyDec +
                                NewEqualizationDec);

              PostCancelled := (MessageDlg('The total assessed value changed by ' +
                                           FormatFloat(FormatString, (NewTotalAssessedVal - OrigTotalAssessedVal)) +
                                           #13 + 'but the physical and equalization change fields indicate a change of ' +
                                           FormatFloat(FormatString, TotalARChange) + '.' + #13 +
                                           'Are you sure this is correct?',
                                           mtConfirmation, [mbYes, mbNo], 0) = idNo);

              If PostCancelled
                then Abort;

            end;  {If (Roundoff(OrigTotalVal, 0) <> ...}

      end;  {If not PostCancelled}

    {FXX12091998-7: Warn them if they have a land assessed val > total.}
    {FXX08032003-3(2.07h): This should not be a warning - it should be prevented.}

  If not PostCancelled
    then
      with AssessmentTable do
        If (FieldByName('LandAssessedVal').AsInteger >
            FieldByName('TotalAssessedVal').AsInteger)(* and
            (MessageDlg('Warning! The land value is greater than the total value.' + #13 +
                        'Do you want to save this change?', mtWarning, [mbYes, mbNo], 0) = idNo))*)
          then
            begin
              MessageDlg('The land value can not be greater than the total value.' + #13 +
                         'Please correct this.',
                         mtError, [mbOK], 0);
              PostCancelled := True;
              Abort;
            end;

        {Additional warning if changing TY assessed val.}

    {FXX10261997-2: Moved the warning for changing TY to before post since the
                    message dlg was causing a problem with the cursor
                    not appearing.}

    {FXX01142000-2: Don't ask if want to change assessment if prior to final roll.}

  If not PostCancelled
    then
      If ((AssessmentTable.State in [dsEdit, dsInsert]) and
          (ProcessingType = ThisYear) and
          (Date > GlblFinalRollDate) and
          ((Roundoff(OrigLandAssessedVal, 0) <> Roundoff(AssessmentTable.FieldByName('LandAssessedVal').AsInteger, 0)) or
           (Roundoff(OrigTotalAssessedVal, 0) <> Roundoff(AssessmentTable.FieldByName('TotalAssessedVal').AsInteger, 0))))
        then
          If (MessageDlg('Are you sure you want to change a This Year assessment?',
                         mtConfirmation, [mbYes, mbNo], 0) = idNo)
            then Abort;

    {FXX03191999-1: Update the assessment date field if changed.}
    {FXX09231999-2: Only do it if the land or total assessment changes.}

  If (not PostCancelled and
      ((Roundoff(OrigLandAssessedVal, 0) <> Roundoff(AssessmentTable.FieldByName('LandAssessedVal').AsInteger, 0)) or
       (Roundoff(OrigTotalAssessedVal, 0) <> Roundoff(AssessmentTable.FieldByName('TotalAssessedVal').AsInteger, 0))))
    then AssessmentTable.FieldByName('AssessmentDate').AsDateTime := Date;

end;  {AssessmentTableBeforePost}

{=================================================================}
Procedure TAssessmentForm.AssessmentNotesButtonClick(Sender: TObject);

{Show the full memo dialog. If there is no notes record for this
 assessment record, then insert one before we show the memo.
 Note that the notes memo on the screen where text displays is
 read only - to edit the notes, they must click the button.}

begin
  FindKeyOld(AssessmentNotesTable,
             ['TaxRollYr', 'SwisSBLKey'],
             [TaxRollYr, SwisSBLKey]);

     {Note that the memo dialog takes care of inserting a note record.}

  AssessmentNotesMemoDialog.Execute;

end;  {AssessmentNotesButtonClick}

{==========================================================}
Procedure TAssessmentForm.AssessmentLetterChangeButtonClick(Sender: TObject);

{Show the full memo dialog. If there is no notes record for this
 assessment record, then insert one before we show the memo.
 Note that the notes memo on the screen where text displays is
 read only - to edit the notes, they must click the button.}

begin
  FindKeyOld(AssessmentLetterTextTable,
             ['TaxRollYr', 'SwisSBLKey'],
             [TaxRollYr, SwisSBLKey]);

     {Note that the memo dialog takes care of inserting a note record.}

  AssessmentLetterTextMemoDialog.Execute;

end;  {AssessmentLetterChangeButtonClick}

{========================================================================}
Procedure TAssessmentForm.AssessmentNotesTableNewRecord(DataSet: TDataset);

begin
  AssessmentNotesTable.FieldByName('TaxRollYr').Text := TaxRollYr;
  AssessmentNotesTable.FieldByName('SwisSBLKey').Text := SwisSBlKey;
end;

{========================================================================}
Procedure TAssessmentForm.LookupComboNotInList(    Sender: TObject;
                                                   LookupTable: TDataSet;
                                                   NewValue: String;
                                               var Accept: Boolean);

{FXX01221999-1: Let Anne clear the assessed val type.}

begin
  If (Deblank(NewValue) = '')
    then Accept := True;

end;  {LookupComboNotInList}

{========================================================================}
Procedure TAssessmentForm.AssessmentLetterTextTableNewRecord(DataSet: TDataset);

begin
  AssessmentLetterTextTable.FieldByName('TaxRollYr').Text := TaxRollYr;
  AssessmentLetterTextTable.FieldByName('SwisSBLKey').Text := SwisSBlKey;

end;

{==========================================================}
Procedure TAssessmentForm.ClearDateFrozenButtonClick(Sender: TObject);

{FXX12091998-5: There are problems clearing out masked dates. This is a quick fix.}

begin
  If not (AssessmentTable.State in [dsEdit])
    then AssessmentTable.Edit;

  AssessmentTable.FieldByName('DateFrozen').Text := '';

end;  {ClearDateFrozenButtonClick}

{==========================================================}
Procedure TAssessmentForm.SaveButtonClick(Sender: TObject);

begin
  If (AssessmentTable.Modified and  {Table is modified.}
      (AssessmentTable.State in [dsEdit, dsInsert]))
    then AssessmentTable.Post;

    {FXX06042001-1: The assessment notes and letter text records were not being saved.}

  If (AssessmentLetterTextTable.Modified and  {Table is modified.}
      (AssessmentLetterTextTable.State in [dsEdit, dsInsert]))
    then AssessmentLetterTextTable.Post;

  If (AssessmentNotesTable.Modified and  {Table is modified.}
      (AssessmentNotesTable.State in [dsEdit, dsInsert]))
    then AssessmentNotesTable.Post;

end;  {SaveButtonClick}

{==============================================================}
Procedure TAssessmentForm.CancelButtonClick(Sender: TObject);

begin
  If (AssessmentTable.Modified and
      (AssessmentTable.State in [dsEdit, dsInsert]) and
      (MessageDlg('Warning! You will lose all changes.' + #13 +
                  'Cancel anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes))
    then
      begin
        AssessmentTable.Cancel;
        AssessmentChanged := False;
      end;

end;  {CancelButtonClick}

{=====================================================================================}
Procedure TAssessmentForm.AssessmentTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.}

var
  NewBasicSTARAmount, NewEnhancedSTARAmount,
  HstdLandVal, NonhstdLandVal,
  NewTotalAssessedVal,
  NewLandAssessedVal,
  HstdAssessedVal,
  NonhstdAssessedVal : Comp;
  NewExemptionCodes,
  NewExemptionHomesteadCodes,
  NewResidentialTypes,
  NewCountyExemptionAmounts,
  NewTownExemptionAmounts,
  NewSchoolExemptionAmounts,
  NewVillageExemptionAmounts : TStringList;
  NewSDAmounts : TList;
  NewEXAmounts : ExemptionTotalsArrayType;

    {CHG10281997-1: Dual mode processing.}

  Found, Quit : Boolean;

  OppositeYearExemptionCodeTable,
  OppositeYearExemptionTable,
  OppositeYearClassTable,
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

   NumChanges := RecordChanges(Self, Caption, AssessmentTable, ExtractSSKey(ParcelTable),
                               FieldTraceInformationList);

   If (NumChanges > 0)
    then ParcelChanged := True;

  Cursor := crHourglass;

  NewTotalAssessedVal := AssessmentTable.FieldByName('TotalAssessedVal').AsInteger;
  NewLandAssessedVal := AssessmentTable.FieldByName('LandAssessedVal').AsInteger;

    {Now, if there was a change in total or land assessed value,
     let's go through the exemptions for this parcel, recalculate them,
     and then adjust the exemption roll totals.}

  If ((Roundoff(OrigTotalAssessedVal, 0) <> Roundoff(NewTotalAssessedVal, 0)) or
      (Roundoff(OrigLandAssessedVal, 0) <> Roundoff(NewLandAssessedVal, 0)))
    then
      begin
        AssessmentChanged := True;
          {FXX04121998-2: Reset the land and total AV's.}

        LandAVLabel.Caption := FormatFloat(FormatString,
                                           NewLandAssessedVal);
        TotalAVLabel.Caption := FormatFloat(FormatString,
                                            NewTotalAssessedVal);

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
                                       ClassTable,
                                       SwisCodeTable,
                                       ParcelTable,
                                       TaxRollYr, SwisSBLKey, nil,
                                       0, 0, False);

          {Now figure out the new exemption totals.}
          {CHG12011997-2: STAR support}

        NewEXAmounts := TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
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

        HstdAssessedVal := 0;
        NonhstdAssessedVal := 0;
        HstdLandVal := 0;
        NonhstdLandVal := 0;

        If (ParcelTable.FieldByName('HomesteadCode').Text = 'N')
          then
            begin
              NonhstdAssessedVal := OrigTotalAssessedVal;
              NonhstdLandVal := OrigLandAssessedVal;
            end
          else
            begin
                {FXX09132001-1: The HstdLandVal was NonhstdLandVal.}

              HstdAssessedVal := OrigTotalAssessedVal;
              HstdLandVal := OrigLandAssessedVal;
            end;

        {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                        the parcel table for that.}
          {FXX02101999-4: Add land value to swis and school totals.}

        If not GlblSuppressRollTotalsUpdate
          then AdjustRollTotalsForParcel(TaxRollYr,
                                        ParcelTable.FieldByName('SwisCode').Text,
                                        ParcelTable.FieldByName('SchoolCode').Text,
                                        ParcelTable.FieldByName('HomesteadCode').Text,
                                        ParcelTable.FieldByName('RollSection').Text,
                                        HstdLandVal, NonhstdLandVal,
                                        HstdAssessedVal,
                                        NonhstdAssessedVal,
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

        HstdAssessedVal := 0;
        NonhstdAssessedVal := 0;
        HstdLandVal := 0;
        NonhstdLandVal := 0;

          {FXX02101999-4: Add land value to swis and school totals.}

        If (ParcelTable.FieldByName('HomesteadCode').Text = 'N')
          then
            begin
              NonhstdAssessedVal := NewTotalAssessedVal;
              NonhstdLandVal := NewLandAssessedVal;
            end
          else
             begin
               HstdAssessedVal := NewTotalAssessedVal;
               HstdLandVal := NewLandAssessedVal;
             end;

        If not GlblSuppressRollTotalsUpdate
          then AdjustRollTotalsForParcel(TaxRollYr,
                                        ParcelTable.FieldByName('SwisCode').Text,
                                        ParcelTable.FieldByName('SchoolCode').Text,
                                        ParcelTable.FieldByName('HomesteadCode').Text,
                                        ParcelTable.FieldByName('RollSection').Text,
                                        HstdLandVal, NonhstdLandVal,
                                        HstdAssessedVal,
                                        NonhstdAssessedVal,
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

          {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

        InsertAuditAVChangeRec(AuditAVChangeTable,
                               SwisSBLKey,
                               TaxRollYr,
                               OrigLandAssessedVal,
                               OrigTotalAssessedVal,
                               OrigPhysicalQtyInc,
                               OrigPhysicalQtyDec,
                               OrigEqualizationInc,
                               OrigEqualizationDec,
                               OrigEXAmounts,
                               NewLandAssessedVal,
                               NewTotalAssessedVal,
                               NewPhysicalQtyInc,
                               NewPhysicalQtyDec,
                               NewEqualizationInc,
                               NewEqualizationDec,
                               NewEXAmounts);

          {FXX07152002-1: Missing frees on creates of these lists.}

        NewExemptionCodes.Free;
        NewExemptionHomesteadCodes.Free;
        NewResidentialTypes.Free;
        NewCountyExemptionAmounts.Free;
        NewTownExemptionAmounts.Free;
        NewSchoolExemptionAmounts.Free;
        NewVillageExemptionAmounts.Free;
        ClearTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));
        FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

      end;  {If ((Roundoff(OrigTotalAssessedVal, 0) <> ...}

    {CHG04262000-1: If av changes on parcel with a BIE exemption, warn.}

  If ((OrigExemptionCodes.IndexOf(BIEExemptionCode) > -1) and
      ((Roundoff(OrigTotalAssessedVal, 0) <> Roundoff(NewTotalAssessedVal, 0)) or
       (Roundoff(OrigLandAssessedVal, 0) <> Roundoff(NewLandAssessedVal, 0))))
    then MessageDlg('This parcel has a BIE exemption.' + #13 +
                    'Please adjust the current and original BIE amounts appropriately.',
                    mtWarning, [mbOK], 0);

    {CHG04292009-1(2.20.1.1)[F431]: If there are override districts on this parcel, warn them.}

  If ParcelHasOverrideSpecialDistricts(ParcelSDTable, TaxRollYr, SwisSBLKey)
    then MessageDlg('This parcel has one or more special districts with an override value.' + #13 +
                    'Please review these districts.', mtWarning, [mbOK], 0);

    {CHG10281997-1: Dual mode processing.}

  If GlblModifyBothYears
    then
      begin
        Found := FindKeyOld(OppositeYearAssessmentTable,
                            ['TaxRollYr', 'SwisSBLKey'],
                            [OppositeTaxYear, SwisSBLKey]);

        If Found
          then OppositeYearAssessmentTable.Edit;

        CreateFieldValuesAndLabels(Self, OppositeYearAssessmentTable, FieldTraceInformationList);

          {Copy the fields from the main table to the new table, but make
           sure that we do not copy the tax roll year.}

        If Found
          then
            begin
                {Get the original amounts so we can adjust the totals
                 if necessary.}

              OppositeYearExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                                       NextYear);
              OppositeYearExemptionTable := TTable.Create(nil);
              OpenTableForProcessingType(OppositeYearExemptionTable,
                                         ExemptionsTableName,
                                         NextYear, Quit);

              OppositeYearSwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                                                  NextYear);
              OppositeYearSDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                                                NextYear);
              OppositeYearParcelSDTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                                                  NextYear);
              OppositeYearParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                                                 NextYear);
              OppositeYearClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                                               NextYear);

              with OppositeYearAssessmentTable do
                begin
                  OrigTotalAssessedVal := FieldByName('TotalAssessedVal').AsInteger;
                  OrigLandAssessedVal := FieldByName('LandAssessedVal').AsInteger;
                  OrigPhysicalQtyInc := FieldByName('PhysicalQtyIncrease').AsInteger;
                  OrigPhysicalQtyDec := FieldByName('PhysicalQtyDecrease').AsInteger;
                  OrigEqualizationInc := FieldByName('IncreaseForEqual').AsInteger;
                  OrigEqualizationDec := FieldByName('DecreaseForEqual').AsInteger;

                end;  {with AssessmentTable do}

              SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

              with SBLRec do
                FindKeyOld(OppositeYearParcelTable,
                           ['TaxRollYr', 'SwisCode',
                            'Section', 'Subsection',
                            'Block', 'Lot', 'Sublot', 'Suffix'],
                           [OppositeTaxYear,
                            SwisCode, Section, SubSection,
                            Block, Lot, Sublot, Suffix]);

                {FXX06222001-1: Don't move changes forward if NY parcel is inactive.}

              If (OppositeYearParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
                then
                  begin
                    OppositeYearAssessmentTable.Cancel;
                    MessageDlg('The assessment change was not moved forward to next year' + #13 +
                                'because the next year parcel is inactive.' + #13 +
                                'Please make sure that this is correct.', mtWarning, [mbOK], 0);
                  end
                else
                  begin
                    OrigEXAmounts := TotalExemptionsForParcel(OppositeTaxYear, SwisSBLKey,
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
                      {CHG05292000-1: Partial assessment.}

                    CopyFields(AssessmentTable, OppositeYearAssessmentTable,
                               ['TaxRollYr', 'PhysicalQtyIncrease',
                                'PhysicalQtyDecrease', 'IncreaseForEqual',
                                'DecreaseForEqual', 'PartialAssessment'],
                               [OppositeTaxYear, '0', '0', '0', '0', 'False']);

                    If (RecordChanges(Self, Caption, OppositeYearAssessmentTable,
                                      SwisSBLKey, FieldTraceInformationList) > 0)
                      then OppositeYearParcelChanged := True;

                    try
                      OppositeYearAssessmentTable.Post;
                    except
                      SystemSupport(050, OppositeYearAssessmentTable,
                                    'Error posting opposite year record.', UnitName,
                                    GlblErrorDlgBox);
                    end;

                      {Adjust the opposite year roll totals.}

                    with OppositeYearAssessmentTable do
                      begin
                        NewTotalAssessedVal := FieldByName('TotalAssessedVal').AsInteger;
                        NewLandAssessedVal := FieldByName('LandAssessedVal').AsInteger;
                        NewPhysicalQtyInc := FieldByName('PhysicalQtyIncrease').AsInteger;
                        NewPhysicalQtyDec := FieldByName('PhysicalQtyDecrease').AsInteger;
                        NewEqualizationInc := FieldByName('IncreaseForEqual').AsInteger;
                        NewEqualizationDec := FieldByName('DecreaseForEqual').AsInteger;
                      end;

                      {Now, if there was a change in total or land assessed value,
                       let's go through the exemptions for this parcel, recalculate them,
                       and then adjust the exemption roll totals.}

                    If ((Roundoff(OrigTotalAssessedVal, 0) <> Roundoff(NewTotalAssessedVal, 0)) or
                        (Roundoff(OrigLandAssessedVal, 0) <> Roundoff(NewLandAssessedVal, 0)))
                      then
                        begin
                            {Create tables for the opposite year ex codes,
                             exemptions, class, swis code, parcels,
                             sd, sd code}

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
                                                         OppositeYearSwisCodeTable,
                                                         OppositeYearParcelTable,
                                                         OppositeTaxYear,
                                                         SwisSBLKey, nil,
                                                         0, 0, False);

                            {Now figure out the new exemption totals.}

                          NewEXAmounts := TotalExemptionsForParcel(OppositeTaxYear,
                                                   SwisSBLKey,
                                                   OppositeYearExemptionTable,
                                                   OppositeYearExemptionCodeTable,
                                                   OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
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

                          HstdAssessedVal := 0;
                          NonhstdAssessedVal := 0;
                          HstdLandVal := 0;
                          NonhstdLandVal := 0;

                          If (ParcelTable.FieldByName('HomesteadCode').Text = 'N')
                            then
                              begin
                                NonhstdAssessedVal := OrigTotalAssessedVal;
                                NonhstdLandVal := OrigLandAssessedVal;
                              end
                            else
                              begin
                                HstdAssessedVal := OrigTotalAssessedVal;

                                  {FXX03222005-1(2.8.3.12)[2085]: The Nonhstd land value was being set in this
                                                                  case instead of the homestead.}

                                HstdLandVal := OrigLandAssessedVal;

                              end;

                           {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                                           the parcel table for that.}

                          If not GlblSuppressRollTotalsUpdate
                            then AdjustRollTotalsForParcel(OppositeTaxYear,
                                                          OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                                          OppositeYearParcelTable.FieldByName('SchoolCode').Text,
                                                          OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                                          OppositeYearParcelTable.FieldByName('RollSection').Text,
                                                          HstdLandVal, NonhstdLandVal,
                                                          HstdAssessedVal,
                                                          NonhstdAssessedVal,
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
                            {FXX02101999-4: Add land value to swis and school totals.}

                          HstdAssessedVal := 0;
                          NonhstdAssessedVal := 0;
                          HstdLandVal := 0;
                          NonhstdLandVal := 0;

                          If (ParcelTable.FieldByName('HomesteadCode').Text = 'N')
                            then
                              begin
                                NonhstdAssessedVal := NewTotalAssessedVal;
                                NonhstdLandVal := NewLandAssessedVal;
                              end
                            else
                              begin
                                HstdAssessedVal := NewTotalAssessedVal;
                                HstdLandVal := NewLandAssessedVal;
                              end;

                           {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                                           the parcel table for that.}

                          If not GlblSuppressRollTotalsUpdate
                            then AdjustRollTotalsForParcel(OppositeTaxYear,
                                                          OppositeYearParcelTable.FieldByName('SwisCode').Text,
                                                          OppositeYearParcelTable.FieldByName('SchoolCode').Text,
                                                          OppositeYearParcelTable.FieldByName('HomesteadCode').Text,
                                                          OppositeYearParcelTable.FieldByName('RollSection').Text,
                                                          HstdLandVal, NonhstdLandVal,
                                                          HstdAssessedVal,
                                                          NonhstdAssessedVal,
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

                            {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

                          InsertAuditAVChangeRec(AuditAVChangeTable,
                                                 SwisSBLKey,
                                                 OppositeTaxYear,
                                                 OrigLandAssessedVal,
                                                 OrigTotalAssessedVal,
                                                 OrigPhysicalQtyInc,
                                                 OrigPhysicalQtyDec,
                                                 OrigEqualizationInc,
                                                 OrigEqualizationDec,
                                                 OrigEXAmounts,
                                                 NewLandAssessedVal,
                                                 NewTotalAssessedVal,
                                                 NewPhysicalQtyInc,
                                                 NewPhysicalQtyDec,
                                                 NewEqualizationInc,
                                                 NewEqualizationDec,
                                                 NewEXAmounts);

                          NewExemptionCodes.Free;
                          NewExemptionHomesteadCodes.Free;
                          NewResidentialTypes.Free;
                          NewCountyExemptionAmounts.Free;
                          NewTownExemptionAmounts.Free;
                          NewSchoolExemptionAmounts.Free;
                          NewVillageExemptionAmounts.Free;
                          ClearTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));
                          FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

                        end;  {If ((Roundoff(OldLandAssessedVal, 2) <> Roundoff(NewLandAssessedVal, 2)) or ...}

                  end;  {If (OppositeYearParcelTable.FieldByName('ActiveFlag ...}

              OppositeYearExemptionTable.Close;
              OppositeYearExemptionTable.Free;

            end;  {If Found}

      end;  {If GlblModifyBothYears}

    {CHG06092010-7(2.26.1)[I7394]: Show the improvement value.}

  If glblShowImprovementValue
  then ShowImprovementValue;

  Cursor := crDefault;

    {FXX03021998-2: Set the focus back to the first field after post.}

  SetFocusToFirstField;

    {Now, if the parcel changed, then update the parcel table.}
    {FXX10152004-2(2.8.0.14): Move the call to MarkRecChanged to after post so that it updates right away.}

  If ParcelChanged
    then MarkRecChanged(ParcelTable, UnitName);

    {FXX11021998-5: If the person adds value beyond the land for vacant land,
                    warn them.}
    {FXX03262001-3: This is taken care of in the parcel warnings.}

(*  If ((ParcelTable.FieldByName('PropertyClassCode').Text[1] = '3') and
      (Roundoff(AssessmentTableTotalAssessedVal.Value, 0) >
       Roundoff(AssessmentTableLandAssessedVal.Value, 0)))
    then MessageDlg('The total assessed value is greater than the land value,' + #13 +
                    'but the parcel has a vacant land property class.' + #13 +
                    'Please review.', mtWarning, [mbOK], 0); *)

end;  {AssessmentTableAfterPost}

{======================================================================}
Procedure TAssessmentForm.CloseButtonClick(Sender: TObject);

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

{======================================================================}
Procedure TAssessmentForm.FormCloseQuery(    Sender: TObject;
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

  If (AssessmentTable.State in [dsInsert, dsEdit])
    then AssessmentTable.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode. Note that sometimes a record can be marked even
     if there were no changes if a person clicks on a drop down box (even without changing
     the value). So, since we are recording field values before any changes, we
     will compare them to now and if there are no changes, we will cancel this
     edit or insert.}

  If ((not AssessmentTable.ReadOnly) and
      (AssessmentTable.State in [dsInsert, dsEdit]) and
      AssessmentTable.Modified)
    then
      If (NumRecordChanges(Self, AssessmentTable, FieldTraceInformationList) = 0)
        then AssessmentTable.Cancel
        else
          begin
            try
              AssessmentTable.Post;
            except
              CanClose := False;
              GlblParcelPageCloseCancelled := True;
            end;

          end;  {else of If (NumRecordChanges(Self, ...}

    {FXX06042001-3: If there are letter text or AV notes not saved, save them.}

  If ((not AssessmentNotesTable.ReadOnly) and
      (AssessmentNotesTable.State in [dsInsert, dsEdit]) and
      AssessmentNotesTable.Modified)
    then AssessmentNotesTable.Post;

  If ((not AssessmentLetterTextTable.ReadOnly) and
      (AssessmentLetterTextTable.State in [dsInsert, dsEdit]) and
      AssessmentLetterTextTable.Modified)
    then AssessmentLetterTextTable.Post;

  ClosingForm := False;

end;  {FormCloseQuery}

{======================================================================}
Procedure TAssessmentForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

var
  Quit : Boolean;
  SBLRec : SBLRecord;

begin
    {Now, if the parcel changed, then update the parcel table.}

  If ParcelChanged
    then MarkRecChanged(ParcelTable, UnitName);

    {CHG03302000-1: Expand the capabilites of the extract - Freeport
                    wants to see AV changes in the extract.}

  If AssessmentChanged
    then SetExtractFlags(SwisSBLKey);

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
                     ['TaxRollYr', 'SwisCode',
                      'Section', 'Subsection',
                      'Block', 'Lot', 'Sublot', 'Suffix'],
                     [OppositeTaxYear, SwisCode, Section,
                      SubSection, Block, Lot, Sublot, Suffix]);

        MarkRecChanged(ParcelTable, UnitName);

      end;  {If OppositeYearParcelChanged}

    {Free up the trace lists.}

(*  FieldValuesList.Free;
  FieldLabelsList.Free; *)

  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

  OrigExemptionCodes.Free;
  OrigExemptionHomesteadCodes.Free;
  OrigResidentialTypes.Free;
  OrigCountyExemptionAmounts.Free;
  OrigTownExemptionAmounts.Free;
  OrigSchoolExemptionAmounts.Free;
  OrigVillageExemptionAmounts.Free;
  ClearTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));
  FreeTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));

  CloseTablesForForm(Self);

  Action := caFree;

end;  {FormClose}

end.