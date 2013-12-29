unit pTaxBillNameAddress;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBCtrls, StdCtrls, ExtCtrls, Mask, DB, DBTables, Buttons,
  Types, DBLookup, Wwtable, Wwdatsrc, wwdblook;

type
  TfmTaxBillAddress = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    YearLabel: TLabel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    Label9: TLabel;
    Label10: TLabel;
    InactiveLabel: TLabel;
    OppositeYearParcelTable: TTable;
    Label3: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    SetFocusTimer: TTimer;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    Panel3: TPanel;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    Label4: TLabel;
    EditSBL: TMaskEdit;
    Label6: TLabel;
    EditLocation: TEdit;
    Label12: TLabel;
    Label5: TLabel;
    EditName: TDBEdit;
    EditLastChangeDate: TDBEdit;
    Label13: TLabel;
    EditLastChangeByName: TDBEdit;
    GroupBox1: TGroupBox;
    Label11: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    SwisLabel: TLabel;
    Label17: TLabel;
    Label7: TLabel;
    Label28: TLabel;
    edName1: TDBEdit;
    EditName2: TDBEdit;
    EditAddress: TDBEdit;
    EditAddress2: TDBEdit;
    EditStreet: TDBEdit;
    EditCity: TDBEdit;
    EditState: TDBEdit;
    EditZip: TDBEdit;
    EditZipPlus4: TDBEdit;
    SwisCodeTable: TTable;
    tbTaxBillAddress: TTable;
    dsTaxBillAddress: TDataSource;
    edDesignation: TDBEdit;
    Label8: TLabel;
    btnCopyAddress: TBitBtn;
    Label16: TLabel;
    DBEdit1: TDBEdit;
    btnClearAddress: TBitBtn;
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TaxBillAddressTableAfterEdit(DataSet: TDataset);
    procedure TaxBillAdressTableAfterPost(DataSet: TDataset);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure tbTaxBillAddressNewRecord(DataSet: TDataSet);
    procedure btnCopyAddressClick(Sender: TObject);
    procedure ParcelTableAfterEdit(DataSet: TDataSet);
    procedure ParcelTableAfterPost(DataSet: TDataSet);
    procedure tbTaxBillAddressBeforePost(DataSet: TDataSet);
    procedure btnClearAddressClick(Sender: TObject);
    procedure ParcelTableBeforePost(DataSet: TDataSet);
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
    FieldTraceInformationList_Parcel : TList;

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
    OriginalFieldValues_Parcel,
    NewFieldValues_Parcel : TStringList;

    Procedure InitializeForm;
    Procedure SetFocusToFirstField;


  end;

implementation

{$R *.DFM}

Uses Glblvars, PASUTILS, UTILEXSD,  PASTypes, WinUtils, Utilitys,
     GlblCnst, DataAccessUnit;


{===========================================================================}
Procedure TfmTaxBillAddress.CreateParams(var Params: TCreateParams);

begin
  inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}


{===========================================================================}
Procedure TfmTaxBillAddress.InitializeForm;

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
  UnitName := 'PTaxBillNameAddress.pas';
  ParcelChanged := False;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        OriginalFieldValues := TStringList.Create;
        NewFieldValues := TStringList.Create;
        OriginalFieldValues_Parcel := TStringList.Create;
        NewFieldValues_Parcel := TStringList.Create;

          {This string lists will hold the labels and values of each field and will be used
           to insert changes into the trace file.}

(*        FieldValuesList := TStringList.Create;
        FieldLabelsList := TStringList.Create;*)

        FieldTraceInformationList := TList.Create;
        FieldTraceInformationList_Parcel := TList.Create;

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

        TitleLabel.Caption := 'Tax Bill Address';

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
              btnCopyAddress.Visible := False;
            end;

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

          {CHG10091997-1: Should zeroes be blanks or '0'?}
        SetDisplayFormatForCurrencyFields(Self, False);


          {CHG10281997-1: Dual mode processing.
                          Note that there is only edit for parcel pg2,
                          no delete or insert.}

(*        If (ProcessingType = ThisYear)
          then OppositeProcessingType := NextYear
          else OppositeProcessingType := ThisYear;

        OppositeTaxYear := GetTaxRollYearForProcessingType(OppositeProcessingType);

        OpenTableForProcessingType(OppositeYearParcelTable,
                                   ParcelTableName,
                                   OppositeProcessingType, Quit);  *)

          {FXX11131997-7: Refresh the drop downs when come in.}

        (*RefreshDropdownsAndLabels(Self, ParcelTable,
                                  DescriptionIndexedLookups);  *)

          {FXX03031998-2: Set focus to the first field. Note that we must
                          do this on a timer so that the form is showing
                          by the time we try to set focus.  Otherwise,
                          we get an error trying to set focus in an invisible
                          window.}

        SetFocusTimer.Enabled := True;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  FormIsInitializing := False;

  If not _Locate(tbTaxBillAddress, [TaxRollYr, SwisSBLKey], '', [])
  then tbTaxBillAddress.Insert;

      {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

end;  {InitializeForm}

{===========================================================}
Procedure TfmTaxBillAddress.SetFocusToFirstField;

{FXX03031998-2: Set focus to the first field after insert, any post,
                and upon coming into the form.}

begin
  with edName1 do
    begin
      SetFocus;
      SelectAll;
    end;

end;  {SetFocusToFirstField}

{===========================================================}
Procedure TfmTaxBillAddress.SetFocusTimerTimer(Sender: TObject);

{FXX03031998-2: Set focus to the first field. Note that we must
                do this on a timer so that the form is showing
                by the time we try to set focus.  Otherwise,
                we get an error trying to set focus in an invisible
                window.}

begin
  SetFocusTimer.Enabled := False;
  SetFocusToFirstField;
end;  {SetFocusTimerTimer}

{=====================================================================================}
Procedure TfmTaxBillAddress.btnCopyAddressClick(Sender: TObject);

begin
  with tbTaxBillAddress do
  try
    If (State = dsBrowse)
    then Edit;

    FieldByName('Name1').AsString := ParcelTable.FieldByName('Name1').AsString;
    FieldByName('Name2').AsString := ParcelTable.FieldByName('Name2').AsString;
    FieldByName('Address1').AsString := ParcelTable.FieldByName('Address1').AsString;
    FieldByName('Address2').AsString := ParcelTable.FieldByName('Address2').AsString;
    FieldByName('Street').AsString := ParcelTable.FieldByName('Street').AsString;
    FieldByName('City').AsString := ParcelTable.FieldByName('City').AsString;
    FieldByName('State').AsString := ParcelTable.FieldByName('State').AsString;
    FieldByName('Zip').AsString := ParcelTable.FieldByName('Zip').AsString;
    FieldByName('ZipPlus4').AsString := ParcelTable.FieldByName('ZipPlus4').AsString;
  except
  end;

end;  {btnCopyAddressClick}

{=====================================================================================}
Procedure TfmTaxBillAddress.btnClearAddressClick(Sender: TObject);

begin
  with tbTaxBillAddress do
  try
    If (State = dsBrowse)
    then Edit;

    FieldByName('Name1').AsString := '';
    FieldByName('Name2').AsString := '';
    FieldByName('Address1').AsString := '';
    FieldByName('Address2').AsString := '';
    FieldByName('Street').AsString := '';
    FieldByName('City').AsString := '';
    FieldByName('State').AsString := '';
    FieldByName('Zip').AsString := '';
    FieldByName('ZipPlus4').AsString := '';
    Post;
  except
  end;

end;  {btnClearAddressClick}

{======================================================================}
Procedure TfmTaxBillAddress.tbTaxBillAddressNewRecord(DataSet: TDataSet);

begin
  with tbTaxBillAddress do
  try
    FieldByName('TaxRollYr').AsString := TaxRollYr;
    FieldByName('SwisSBLKey').AsString := SwisSBLKey;
  except
  end;

end;  {tbTaxBillAddressNewRecord}

{=====================================================================================}
Procedure TfmTaxBillAddress.TaxBillAddressTableAfterEdit(DataSet: TDataset);

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
        CreateFieldValuesAndLabels(Self, tbTaxBillAddress, FieldTraceInformationList);

        OriginalFieldValues.Clear;

        with tbTaxBillAddress do
          For I := 0 to (FieldCount - 1) do
            OriginalFieldValues.Add(Fields[I].Text);

      end;  {If not FormIsInitializing}

end;  {TaxBillAddressTableAfterEdit}

{=====================================================================================}
Procedure TfmTaxBillAddress.tbTaxBillAddressBeforePost(DataSet: TDataSet);

begin
  with tbTaxBillAddress do
  try
    FieldByName('LastChangeUser').AsString := GlblUserName;
    FieldByName('LastChangeDate').AsString := DateToStr(Date);
  except
  end;

  If (ParcelTable.State = dsBrowse)
  then ParcelTable.Edit;

  ParcelTable.Post;
  
end;  {tbTaxBillAddressBeforePost}

{=====================================================================================}
Procedure TfmTaxBillAddress.TaxBillAdressTableAfterPost(DataSet: TDataset);

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

  NumChanges := RecordChanges(Self, 'Tax Bill Address', tbTaxBillAddress, SwisSBLKey,
                              FieldTraceInformationList);

  If (NumChanges > 0)
    then ParcelChanged := True;

  If GlblModifyBothYears
    then
      begin
          {FXX01202000-2: Copy information forward for parcel record on a field
                          by field basis only.}

        NewFieldValues.Clear;

        with tbTaxBillAddress do
          For I := 0 to (FieldCount - 1) do
            NewFieldValues.Add(Fields[I].Text);

           {Now go through the list and compare on a field by field basis
            any changes.}

        ChangedFields := TStringList.Create;
        For I := 0 to (OriginalFieldValues.Count - 1) do
          If (NewFieldValues[I] <> OriginalFieldValues[I])
            then ChangedFields.Add(ParcelTable.Fields[I].FieldName);

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

(*        with SBLRec do
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

                  OppositeYearParcelTable.FieldByName(FieldName).Text :=
                                         ParcelTable.FieldByName(FieldName).Text;

                end;  {For I := 0 to (ChangedFields.Count - 1) do}

              If (RecordChanges(Self, 'Tax Bill Address',
                                OppositeYearParcelTable, SwisSBLKey,
                                FieldTraceInformationList) > 0)
                then
                  with OppositeYearParcelTable do
                    begin
                    end;

              try
                OppositeYearParcelTable.Post;
              except
                SystemSupport(050, OppositeYearParcelTable,
                              'Error posting opposite year record.', UnitName,
                              GlblErrorDlgBox);
              end;

            end;  {If Found}  *)


        ChangedFields.Free;

      end;  {If GlblModifyBothYears}

    {FXX03021998-2: Set focus back to the first field after post,.}

  SetFocusToFirstField;

end;  {TaxBillAdressTableAfterPost}

{======================================================================}
Procedure TfmTaxBillAddress.ParcelTableAfterEdit(DataSet: TDataSet);

var
  I : Integer;

begin
  If not FormIsInitializing
    then
      begin
        CreateFieldValuesAndLabels(Self, ParcelTable, FieldTraceInformationList_Parcel);

        OriginalFieldValues_Parcel.Clear;

        with ParcelTable do
          For I := 0 to (FieldCount - 1) do
            OriginalFieldValues_Parcel.Add(Fields[I].Text);

      end;  {If not FormIsInitializing}

end;  {ParcelTableAfterEdit}

{===========================================================================}
Procedure TfmTaxBillAddress.ParcelTableBeforePost(DataSet: TDataSet);

begin
  with ParcelTable do
  try
    FieldByName('LastChangeUser').AsString := GlblUserName;
    FieldByName('LastChangeDate').AsString := DateToStr(Date);
  except
  end;

end;  {ParcelTableBeforePost}

{===========================================================================}
Procedure TfmTaxBillAddress.ParcelTableAfterPost(DataSet: TDataSet);

var
  Quit, Found : Boolean;
  SBLRec : SBLRecord;
  ChangedFields : TStringList;
  NewSchoolRelevy, NewVillageRelevy : Extended;
  TempParcelTable : TTable;
  NumChanges, I : Integer;
  FieldName : String;

begin
  NumChanges := RecordChanges(Self, 'Base Information', ParcelTable, SwisSBLKey,
                              FieldTraceInformationList_Parcel);

  If (NumChanges > 0)
    then ParcelChanged := True;

  If GlblModifyBothYears
    then
      begin
          {FXX01202000-2: Copy information forward for parcel record on a field
                          by field basis only.}

        NewFieldValues.Clear;

        with ParcelTable do
          For I := 0 to (FieldCount - 1) do
            NewFieldValues_Parcel.Add(Fields[I].Text);

           {Now go through the list and compare on a field by field basis
            any changes.}

        ChangedFields := TStringList.Create;
        For I := 0 to (OriginalFieldValues.Count - 1) do
          If (NewFieldValues_Parcel[I] <> OriginalFieldValues_Parcel[I])
            then ChangedFields.Add(ParcelTable.Fields[I].FieldName);

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

(*        with SBLRec do
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

                  OppositeYearParcelTable.FieldByName(FieldName).Text :=
                                         ParcelTable.FieldByName(FieldName).Text;

                end;  {For I := 0 to (ChangedFields.Count - 1) do}

              If (RecordChanges(Self, 'Tax Bill Address',
                                OppositeYearParcelTable, SwisSBLKey,
                                FieldTraceInformationList) > 0)
                then
                  with OppositeYearParcelTable do
                    begin
                    end;

              try
                OppositeYearParcelTable.Post;
              except
                SystemSupport(050, OppositeYearParcelTable,
                              'Error posting opposite year record.', UnitName,
                              GlblErrorDlgBox);
              end;

            end;  {If Found}  *)


        ChangedFields.Free;

      end;  {If GlblModifyBothYears}

end;  {ParcelTableAfterPost}

{===========================================================================}
Procedure TfmTaxBillAddress.SaveButtonClick(Sender: TObject);

{FXX10291997-2: Set the last change name and date in before post, not
                on save click since can save without clicking save.}

begin
  If (tbTaxBillAddress.Modified and  {Table is modified.}
      (tbTaxBillAddress.State <> dsBrowse) and
      ((not GlblAskSave) or     {We should not confirm a save or...}
       (GlblAskSave and        {We should confirm a save and...}
        (MessageDlg('Do you want to save this tax bill address change?', mtConfirmation,
                    [mbYes, mbCancel], 0) = mrYes))))  {They want to save it.}
    then tbTaxBillAddress.Post;

  If (ParcelTable.State = dsEdit)
  then ParcelTable.Post;

end;  {SaveButtonClick}

{===========================================================================}
Procedure TfmTaxBillAddress.CancelButtonClick(Sender: TObject);

begin
  If (tbTaxBillAddress.Modified and
      (MessageDlg('Warning! You will lose all changes.' + #13 +
                  'Cancel anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes))
    then tbTaxBillAddress.Cancel;

end;  {CancelButtonClick}

{===========================================================================}
Procedure TfmTaxBillAddress.CloseButtonClick(Sender: TObject);

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
Procedure TfmTaxBillAddress.FormCloseQuery(    Sender: TObject;
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

  If (tbTaxBillAddress.State in [dsInsert, dsEdit])
    then tbTaxBillAddress.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode. Note that sometimes a record can be marked even
     if there were no changes if a person clicks on a drop down box (even without changing
     the value). So, since we are recording field values before any changes, we
     will compare them to now and if there are no changes, we will cancel this
     edit or insert.}
    {FXX05151998-3: Don't ask save on close form if don't want to see save.}

  If (((not tbTaxBillAddress.ReadOnly) and
       (tbTaxBillAddress.State in [dsEdit, dsInsert]) and
       tbTaxBillAddress.Modified) or
      ((not ParcelTable.ReadOnly) and
       (ParcelTable.State in [dsEdit, dsInsert]) and
       ParcelTable.Modified))
    then
      If ((NumRecordChanges(Self, tbTaxBillAddress, FieldTraceInformationList) = 0) and
          (NumRecordChanges(Self, ParcelTable, FieldTraceInformationList_Parcel) = 0))
        then
        begin
          try
            tbTaxBillAddress.Cancel;
            ParcelTable.Cancel;
          except
          end;
        end
        else
          If GlblAskSave
            then
              begin
                ReturnCode := MessageDlg('Do you want to save your tax bill address changes?', mtConfirmation,
                                         [mbYes, mbNo, mbCancel], 0);

                case ReturnCode of
                  idYes :
                  begin
                    tbTaxBillAddress.Post;
                    If (ParcelTable.State = dsEdit)
                    then ParcelTable.Post;
                  end;

                  idNo :
                  begin
                    tbTaxBillAddress.Cancel;
                    If (ParcelTable.State = dsEdit)
                    then ParcelTable.Cancel;
                  end;

                  idCancel : begin
                               GlblParcelPageCloseCancelled := True;
                               CanClose := False;
                             end;

                end;  {case ReturnCode of}

              end
            else tbTaxBillAddress.Post;

end;  {FormCloseQuery}

{===========================================================================}
Procedure TfmTaxBillAddress.FormClose(    Sender: TObject;
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

  FreeTList(FieldTraceInformationList_Parcel, SizeOf(FieldTraceInformationRecord));

  OriginalFieldValues_Parcel.Free;
  NewFieldValues_Parcel.Free;

  Action := caFree;

end;  {FormClose}

end.
