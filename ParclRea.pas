unit Parclrea;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus;

type
  TParcelReactivateForm = class(TForm)
    Timer1: TTimer;
    ParcelTable: TTable;
    Label1: TLabel;
    ParcelExemptionTable: TTable;
    Label2: TLabel;
    ParcelSDTable: TTable;
    Label3: TLabel;
    SDCodeTable: TTable;
    Label4: TLabel;
    AssessmentTable: TTable;
    Label5: TLabel;
    ClassTable: TTable;
    Label6: TLabel;
    ExemptionCodeTable: TTable;
    Label7: TLabel;
    AuditParcelChangeTable: TTable;
    Label8: TLabel;
    AuditEXChangeTable: TTable;
    AuditSDChangeTable: TTable;
    Label9: TLabel;
    Label10: TLabel;
    Panel1: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure ShowParcelLocate;

  end;

implementation

uses GlblVars, WinUtils, Utilitys,
     GlblCnst, Types,
     PASUTILS, UTILEXSD,
     PASTypes,
     UTILRTOT,  {Roll total update unit.}
     RecordSplitMergeNumberDialog,
     PBasePg1;
     (*PBasePg1_New;  {Parcel base page 1} *)

{$R *.DFM}

{========================================================}
Procedure TParcelReactivateForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TParcelReactivateForm.InitializeForm;

begin
  UnitName := 'PARCLREA.PAS';  {mmm}

  If (FormAccessRights = raReadOnly)
    then ParcelTable.ReadOnly := True;  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

  Timer1.Enabled := True;

end;  {InitializeForm}

{===================================================================}
Procedure TParcelReactivateForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{=============================================================}
Procedure AdjustRollTotals(TaxRollYr : String;
                           SwisSBLKey : String;
                           ProcessingType : Integer;
                           ParcelExemptionTable,
                           ExemptionCodeTable,
                           ParcelTable,
                           AssessmentTable,
                           ClassTable,
                           ParcelSDTable,
                           SDCodeTable,
                           AuditParcelChangeTable,
                           AuditEXChangeTable,
                           AuditSDChangeTable : TTable);

var
  BasicSTARAmount, EnhancedSTARAmount,
  HstdAssessedVal, NonhstdAssessedVal,
  HstdLandVal, NonhstdLandVal, AssessedValue : Comp;
  HstdAcres, NonhstdAcres : Real;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  SDAmounts : TList;
  EXAmounts : ExemptionTotalsArrayType;
  AuditEXChangeList : TList;
  OrigAuditParcelRec, NewAuditParcelRec : AuditParcelRecord;
  Quit, AssessmentRecordFound, ClassRecordFound : Boolean;

begin
  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;
  SDAmounts := TList.Create;

  OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelSDTable, SpecialDistrictTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SDCodeTable, SdistCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ClassTable, ClassTableName,
                             ProcessingType, Quit);

    {Get the exemption totals.}
    {CHG12011997-2: STAR support}
    {FXX02091998-1: Pass the residential type of each exemption.}

  EXAmounts := TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                        ParcelExemptionTable,
                                        ExemptionCodeTable,
                                        ParcelTable.FieldByName('HomesteadCode').Text,
                                        'A',
                                        ExemptionCodes,
                                        ExemptionHomesteadCodes,
                                        ResidentialTypes,
                                        CountyExemptionAmounts,
                                        TownExemptionAmounts,
                                        SchoolExemptionAmounts,
                                        VillageExemptionAmounts,
                                        BasicSTARAmount,
                                        EnhancedSTARAmount);

    {Delete all the old roll totals for this parcel.}

 CalculateHstdAndNonhstdAmounts(TaxRollYr,
                                SwisSBLKey,
                                AssessmentTable,
                                ClassTable,
                                ParcelTable,
                                HstdAssessedVal,
                                NonhstdAssessedVal,
                                HstdLandVal,
                                NonhstdLandVal,
                                HstdAcres,
                                NonhstdAcres,
                                AssessmentRecordFound,
                                ClassRecordFound);

    {Get the special district totals.}

  TotalSpecialDistrictsForParcel(TaxRollYr,
                                 SwisSBLKey,
                                 ParcelTable,
                                 AssessmentTable,
                                 ParcelSDTable,
                                 SDCodeTable,
                                 ParcelExemptionTable,
                                 ExemptionCodeTable,
                                 SDAmounts);

    {FXX12041997-4: Record full, unadjusted STAR amount. Need to pass
                    the parcel table for that.}
    {FXX02101999-4: Add land value to swis and school totals.}

  AdjustRollTotalsForParcel(TaxRollYr,
                            ParcelTable.FieldByName('SwisCode').Text,
                            ParcelTable.FieldByName('SchoolCode').Text,
                            ParcelTable.FieldByName('HomesteadCode').Text,
                            ParcelTable.FieldByName('RollSection').Text,
                            HstdLandVal, NonhstdLandVal,
                            HstdAssessedVal,
                            NonhstdAssessedVal,
                            ExemptionCodes,
                            ExemptionHomesteadCodes,
                            CountyExemptionAmounts,
                            TownExemptionAmounts,
                            SchoolExemptionAmounts,
                            VillageExemptionAmounts,
                            ParcelTable,
                            BasicSTARAmount,
                            EnhancedSTARAmount,
                            SDAmounts,
                            ['S', 'C', 'E', 'D'],  {Adjust swis, school, exemption, sd}
                            'A');  {Add the totals.}

    {CHG03161998-1: Track exemption, SD adds, av changes, parcel add/del.}

  AssessedValue := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;

    {FXX05092001-2: Passing in the OrigAuditParcelRec - should be New...}

  GetAuditParcelRec(ParcelTable, AssessedValue, EXAmounts,
                    NewAuditParcelRec);

  InsertParcelChangeRec(SwisSBLKey, TaxRollYr,
                        AuditParcelChangeTable,
                        OrigAuditParcelRec, NewAuditParcelRec,
                        'A');

    {Insert audit trails for SD and EX.}

  AuditEXChangeList := TList.Create;
  GetAuditEXList(SwisSBLKey, TaxRollYr,
                 ParcelExemptionTable,
                 AuditEXChangeList);
  InsertAuditEXChanges(SwisSBLKey, TaxRollYr,
                       AuditEXChangeList,
                       AuditEXChangeTable, 'A');

  InsertAuditSDChanges(SwisSBLKey, TaxRollYr,
                       ParcelSDTable,
                       AuditSDChangeTable, 'A');

  FreeTList(AuditEXChangeList, SizeOf(AuditEXRecord));

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;
  ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
  FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

end;  {AdjustRollTotals}

{=============================================================}
Procedure TParcelReactivateForm.ShowParcelLocate;

var
  _TaxRollYr : String;
  _SwisSBLKey : String;
  SBLRec : SBLRecord;
  ProcessingType : Integer;
  Continue, Quit, Abort,
  ActiveParcel, FoundRec, Locked : Boolean;
  ParcelTabChild : TBaseParcelPg1Form;
  SplitMergeNumber : String;

begin
  ParcelTabChild := nil;
  
    {FXX12011998-20: Display the present action in the locate dialog.}

  If ExecuteParcelLocateDialog(_SwisSBLKey, False, True, 'Reactivate a Parcel', False, nil)
    then
      begin
          {Synchronize the main parcel table on this
           form with the parcel search table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(_SwisSBLKey);
        _TaxRollYr := GetTaxRlYr;
        ProcessingType := GetProcessingTypeForTaxRollYear(_TaxRollYr);
        (*Locked := False; *)

        with SBLRec do
          FoundRec := FindKeyOld(ParcelTable,
                                 ['TaxRollYr', 'SwisCode', 'Section',
                                  'Subsection', 'Block', 'Lot',
                                  'Sublot', 'Suffix'],
                                 [GetTaxRlYr, SwisCode, Section, Subsection,
                                  Block, Lot, Sublot, Suffix]);

        If not FoundRec
          then SystemSupport(101, ParcelTable, 'Error getting parcel record.',
                             UnitName, GlblErrorDlgBox);

          {Now if the parcel is inactive, then we will not let them delete it.}

        ActiveParcel := False;

        If (FoundRec and
            ((ParcelTable.FieldByName('ActiveFlag').Text = ActiveParcelFlag) or
             (ParcelTable.FieldByName('ActiveFlag').Text = ReactivatedParcelFlag)))
          then
            begin
              MessageDlg('That parcel is active and can not be reactivated.' + #13 +
                         'Please select a different parcel.', mtError, [mbOK], 0);
              ActiveParcel := True;
            end;

          {CHG10131997-2: More parcel locking.}
          {See if the parcel is locked.}

        Locked := False;
(*        If not ActiveParcel
          then Locked := WinBtr.IsRecordLocked;

        If Locked
          then MessageDlg('Sorry, that parcel is being modified by another person.' + #13 +
                          'Please try again later.', mtWarning, [mbOK], 0); *)

          {Now if we found the parcel and it is active (only applies for modify),
           then let's display the base page 1 and ask them if they want to
           delete it.}

        If (FoundRec and
            (not ActiveParcel) and
            (not Locked))
          then
            begin
(*              Abort := False;
              LockParcel(ParcelTable, WinBtr, GetTaxRlYr,
                         _SwisSBLKey, Locked);

              If Locked
                then MessageDlg('Sorry, that parcel is being modified by another person.' + #13 +
                          'Please try again later.', mtWarning, [mbOK], 0); *)

            end;  {If (FoundRec and ...}

                 {Display the parcel page.}

        If (FoundRec and
            (not ActiveParcel) and
            (not Locked))
          then
            begin
                {FXX11211997-10: Abort was not being initialized.}

              Abort := False;

              try
                ParcelTabChild := TBaseParcelPg1Form.Create(Self);  {MMM}
              except
                Abort := True;
                NonBtrvSystemSupport(001, 999, 'Error creating parcel page form.',
                                     UnitName, GlblErrorDlgBox);
              end;

              If not Abort
                then
                  begin
                    with ParcelTabChild do
                      begin
                          {Set the keys for this form.}

                        SwisSBLKey := _SwisSBLKey;
                        TaxRollYr := _TaxRollYr;
                        EditMode := 'R';
                        ProcessingType := DetermineProcessingType(GlblTaxYearFlg);
                        FormAccessRights := raReadOnly;
                        NumResSites := 0;
                        NumComSites := 0;

                          {Call the procedure on the form which opens the tables,
                           synchronizes them to this parcel, sets labels, etc.}

                        InitializeForm;

                        CloseButton.Visible := False;
                        CancelButton.Visible := False;
                        SaveButton.Visible := False;

                        Parent := Self;
                        Align := alClient;
                        Visible := True;
                        BringToFront;

                      end;  {with ParcelTabChild as TBaseParcelPg1Form do}

                    Continue := False;
                    SplitMergeNumber := '';

                       {Now ask them if they want to delete it.
                        If so, remove the roll totals and give them a success message.}

                    If (MessageDlg('Do you want to reactivate parcel ' +
                                   ConvertSwisSBLToDashDot(_SwisSBLKey) + '?',
                                   mtConfirmation, [mbNo, mbYes], 0) = idYes)
                      then Continue := True;

                      {CHG05112001-2: Let them record a split\merge number.}

                    If (Continue and
                        (MessageDlg('Do you want to record a split\merge number for this parcel reactivation?',
                                    mtConfirmation, [mbYes, mbNo], 0) = idYes))
                      then
                        try
                          RecordSplitMergeNumberDialogForm := TRecordSplitMergeNumberDialogForm.Create(nil);
                          Continue := (RecordSplitMergeNumberDialogForm.ShowModal = idOK);

                          If Continue
                            then SplitMergeNumber := RecordSplitMergeNumberDialogForm.SplitMergeNumber;

                        finally
                          RecordSplitMergeNumberDialogForm.Free;
                        end;

                    If Continue
                      then
                        If MarkParcelReactivated(ParcelTable, GetTaxRlYr, _SwisSBLKey)
                          then
                            begin
                              If (Deblank(SplitMergeNumber) <> '')
                                then
                                  with ParcelTable do
                                    try
                                      Edit;
                                      FieldByName('SplitMergeNo').Text := SplitMergeNumber;
                                      Post;
                                    except
                                      SystemSupport(001, ParcelTable, 'Error posting split merge number.',
                                                    UnitName, GlblErrorDlgBox);
                                    end;

                              Cursor := crHourglass;

                                {FXX02012000-1: We were not deleting opposite year.}
                                {FXX05092001-1: The ProcessingType was hardcoded to ThisYear.}

                              AdjustRollTotals(_TaxRollYr, _SwisSBLKey,
                                               ProcessingType,
                                               ParcelExemptionTable,
                                               ExemptionCodeTable,
                                               ParcelTable,
                                               AssessmentTable,
                                               ClassTable,
                                               ParcelSDTable,
                                               SDCodeTable,
                                               AuditParcelChangeTable,
                                               AuditEXChangeTable,
                                               AuditSDChangeTable);

                              If GlblModifyBothYears
                                then
                                  begin
                                    _TaxRollYr := GlblNextYear;

                                    OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                                               NextYear, Quit);

                                    MarkParcelReactivated(ParcelTable, _TaxRollYr, _SwisSBLKey);

                                    AdjustRollTotals(_TaxRollYr, _SwisSBLKey, NextYear,
                                                     ParcelExemptionTable,
                                                     ExemptionCodeTable,
                                                     ParcelTable,
                                                     AssessmentTable,
                                                     ClassTable,
                                                     ParcelSDTable,
                                                     SDCodeTable,
                                                     AuditParcelChangeTable,
                                                     AuditEXChangeTable,
                                                     AuditSDChangeTable);

                                      {Make sure that the parcel table is set back to TY.}

                                    OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                                               ThisYear, Quit);
                                    _TaxRollYr := GlblThisYear;

                                  end;  {If GlblModifyBothYears}

                              Cursor := crDefault;

                              MessageDlg('Parcel ' + ConvertSwisSBLToDashDot(_SwisSBLKey) +
                                          ' was reactivated successfully.',
                                          mtInformation, [mbOK], 0);

                            end
                          else MessageDlg('Parcel ' +
                                          ConvertSwisSBLToDashDot(_SwisSBLKey) +
                                          ' was NOT reactivated successfully.',
                                          mtInformation, [mbOK], 0);

                  end;  {If not Abort}

              ParcelTabChild.Free;

(*              UnlockParcel(ParcelTable, WinBtr, GetTaxRlYr, _SwisSBLKey); *)

            end;  {If (FoundRec and ...}

           {Now return them to this routine by starting the timer again.}

        Timer1.Enabled := True;

      end  {If wwParcelSearchDialog.Execute}
    else Close;

end;  {ShowParcelLocate}

{===================================================================}
Procedure TParcelReactivateForm.Timer1Timer(Sender: TObject);

begin
  Timer1.Enabled := False;
  ShowParcelLocate;
end;

{===================================================================}
Procedure TParcelReactivateForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.