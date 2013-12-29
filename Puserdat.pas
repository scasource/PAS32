unit Puserdat;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons;

type
  TParcelUserDataForm = class(TForm)
    MainDataSource: TwwDataSource;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;

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
    Str1DBEdit: TDBEdit;
    Str1Lbl: TLabel;
    Str3DBEdit: TDBEdit;
    Str2DBEdit: TDBEdit;
    Str4DBEdit: TDBEdit;
    Str5DBEdit: TDBEdit;
    Str7DBEdit: TDBEdit;
    Str6DBEdit: TDBEdit;
    Str8DBEdit: TDBEdit;
    Str9DBEdit: TDBEdit;
    Str10DBEdit: TDBEdit;
    Flt1DBEdit: TDBEdit;
    Flt3DBEdit: TDBEdit;
    Flt2DBEdit: TDBEdit;
    Flt4DBEdit: TDBEdit;
    Flt5DBEdit: TDBEdit;
    Flt7DBEdit: TDBEdit;
    Flt6DBEdit: TDBEdit;
    Flt8DBEdit: TDBEdit;
    Flt9DBEdit: TDBEdit;
    Flt10DBEdit: TDBEdit;
    Int1DBEdit: TDBEdit;
    Int3DBEdit: TDBEdit;
    Int2DBEdit: TDBEdit;
    Int4DBEdit: TDBEdit;
    Int5DBEdit: TDBEdit;
    Int7DBEdit: TDBEdit;
    Int6DBEdit: TDBEdit;
    Int8DBEdit: TDBEdit;
    Int9DBEdit: TDBEdit;
    Int10DBEdit: TDBEdit;
    Str2Lbl: TLabel;
    Str3Lbl: TLabel;
    Str4Lbl: TLabel;
    Str5Lbl: TLabel;
    Str6Lbl: TLabel;
    Str7Lbl: TLabel;
    Str8Lbl: TLabel;
    Str9Lbl: TLabel;
    Str10Lbl: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Flt1Lbl: TLabel;
    Flt2Lbl: TLabel;
    Flt3Lbl: TLabel;
    Flt4Lbl: TLabel;
    Flt5Lbl: TLabel;
    Flt6Lbl: TLabel;
    Flt7Lbl: TLabel;
    Flt8Lbl: TLabel;
    Flt9Lbl: TLabel;
    Flt10Lbl: TLabel;
    Int1Lbl: TLabel;
    Int2Lbl: TLabel;
    Int3Lbl: TLabel;
    Int4Lbl: TLabel;
    Int5Lbl: TLabel;
    Int6Lbl: TLabel;
    Int7Lbl: TLabel;
    Int8Lbl: TLabel;
    Int9Lbl: TLabel;
    Int10Lbl: TLabel;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    DBCheckBox7: TDBCheckBox;
    DBCheckBox8: TDBCheckBox;
    DBCheckBox9: TDBCheckBox;
    DBCheckBox10: TDBCheckBox;
    Label3: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SaveButton: TBitBtn;
    CancelButton: TBitBtn;
    UserDataDefTable: TwwTable;
    ScrollBox: TScrollBox;
    DBCheckBox5: TDBCheckBox;
    MainTable: TwwTable;
    DeleteButton: TBitBtn;
    Label2: TLabel;
    Label1: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    InactiveLabel: TLabel;
    SetFocusTimer: TTimer;
    OppositeYearUserDataTable: TTable;
    PartialAssessmentLabel: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterEdit(DataSet: TDataset);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure DecimalEditEnter(Sender: TObject);
    procedure DecimalEditExit(Sender: TObject);
    procedure EnterIntegerEdit(Sender: TObject);
    procedure ExitIntegerEdit(Sender: TObject);
    procedure SetFocusTimerTimer(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    OppositeTaxYear,
    TaxRollYr, SwisSBLKey : String;
    OppositeProcessingType : Integer;

    FieldTraceInformationList : TList;
    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}

      {Have there been any changes?}
    OppositeYearParcelChanged,
    ParcelChanged : Boolean;
    RecordAction,
    ProcessingType : Integer;  {NextYear, ThisYear, History, SalesInventory}
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
      {because these routines are placed at the form object def. level,}
      {they have access to all variables on form (no need to Var in)   }

    FirstFieldSetName : String;
    Procedure InitializeForm;
    Procedure SetRangeForTable(Table : TTable);
  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst;


{$R *.DFM}


{=====================================================================}
Procedure TParcelUserDataForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TParcelUserDataForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{mmm4 - Make sure to set range on all keys.}

begin
  try
    SetRangeOld(Table, ['TaxRollYr', 'SwisSBLKey'],
                [TaxRollYr, SwisSBLKey], [TaxRollYr, SwisSBLKey]);
  except
    SystemSupport(001, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TParcelUserDataForm.InitializeForm;

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
  I,J : Integer;
  Found : Boolean;
  SBLRec : SBLRecord;
  Quit, FirstFieldSet, Done, FirstTimeThrough : Boolean;

begin
  UnitName := 'PUSERDAT';  {mmm1}
  ParcelChanged := False;
  ClosingForm := False;
  FormIsInitializing := True;
  FirstFieldSet := True;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        OppositeTaxYear := GlblNextYear;
        OppositeProcessingType := NextYear;
        OpenTableForProcessingType(OppositeYearUserDataTable, UserDataTableName,
                                   NextYear, Quit);

        FieldTraceInformationList := TList.Create;

          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then MainTable.ReadOnly := True;

          {If this is inquire let's open it in
           readonly mode. Hist access is blocked at menu level}

        If (EditMode = 'V')
          then
            begin
              MainTable.ReadOnly := True;

                {FXX12072001-1: Disable the delete, save and cancel button in view mode.}

              DeleteButton.Enabled := False;
              SaveButton.Enabled := False;
              CancelButton.Enabled := False;

            end;  {If (EditMode = 'V')}

          {FXX07211999-2: Was opening for GlblProcessingType, not the type for this tab.}

        OpenTablesForForm(Self, ProcessingType);

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot',
                               'Sublot', 'Suffix'],
                              [TaxRollYr, SwisCode, Section,
                               SubSection, Block, Lot, Sublot, Suffix]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

        TitleLabel.Caption := 'User Data';

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

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

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);

          {Now set the year label.}

        YearLabel.Caption := GetTaxYrLbl;

        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

          {FXX12101997-1: Make sure that all pages have the inactive label.}

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        For I := 0 to (ComponentCount - 1) do
          If (Components[I] is TFloatField)
            then
              with Components[I] as TFloatField do
                DisplayFormat := _3DecimalDisplay;

          {FXX07071998-2: Set the integer field formats.}

        For I := 0 to (ComponentCount - 1) do
          If (Components[I] is TIntegerField)
            then
              with Components[I] as TIntegerField do
                DisplayFormat := IntegerEditDisplay;

        Done := False;
        FirstTimeThrough := True;

        {now read the user data definition file, and make fields specified}
        {as active in that file visible with a readable label}

        UserDataDefTable.First;

        If UserDataDefTable.EOF
          then
            begin
              MessageDlg('Sorry, there are no user data fields defined.' + #13 +
                         'Please go to System \ Define User Data to set up the user data.' ,
                         mtError, [mbOK], 0);
              FormIsInitializing := False;
              Close;

           end;  {If UserDataDefTable.EOF}

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else UserDataDefTable.Next;

          If UserDataDefTable.EOF
            then Done := True;

            {if field in def table is active, make it active in user screen}

          If ((not Done) and
              UserDataDefTable.FieldByName('Active').AsBoolean)
            then
              For I := 0 to (Self.ComponentCount - 1) do
                If (Take(15, Self.Components[I].Name) =
                    Take(15, UserDataDefTable.FieldByName('ComponentFieldName').Text))
                  then
                    begin
                      If (Self.Components[I] is TLabel)
                        then
                          begin
                              {SET THE LABEL TO THE USER'S PROSE & make it visible}

                            TLabel(Self.Components[I]).Caption :=
                                         Take(10, UserDataDefTable.FieldByName('UserSpecifiedDescr').Text);
                            TLabel(Self.Components[I]).Visible := True;

                              {now use focus ctl of label to find related DBEdit or check box}
                              {and make that visible}

                            For J := 0 to (Self.ComponentCount - 1) do
                              If ((Self.Components[J] is TDBEdit) and
                                  (Take(15,Self.Components[J].Name) =     {refers to edit or chkbx}
                                   Take(15, TLabel(Self.Components[I]).FocusControl.Name))) {refers to label scope}
                                then
                                  with Self.Components[J] as TDBEdit do
                                    begin
                                      Visible := True;

                                        {FXX02261998-1: Set the focus on the first field.}
                                        {FXX07071998-1: The focus must be set on a timer.}

                                      If FirstFieldSet
                                        then
                                          begin
                                            FirstFieldSetName := Self.Components[J].Name;
                                            FirstFieldSet := False;
                                          end;

                                    end;  {with Components[J] as TControl do}

                            end;  {If (Self.Components[I] is TLabel)}

                      If (Self.Components[I] is TDBCheckBox)
                        then
                          begin
                            TDBCheckBox(Self.Components[I]).Caption :=
                                            Take(10, UserDataDefTable.FieldByName('UserSpecifiedDescr').Text);
                            TDBCheckBox(Self.Components[I]).Visible := True;

                                {FXX02261998-1: Set the focus on the first field.}
                                {FXX07071998-1: The focus must be set on a timer.}

                            If FirstFieldSet
                              then
                                begin
                                  FirstFieldSetName := Self.Components[I].Name;
                                  FirstFieldSet := False;
                                end;

                          end;  {If (Self.Components[I] is TDBCheckBox)}

                    end;  {If (Take(15, Self.Components[I].Name) = ...}

        until Done;

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  FormIsInitializing := False;
  SetFocusTimer.Enabled := True;

end;  {InitializeForm}

{==============================================================}
Procedure TParcelUserDataForm.SetFocusTimerTimer(Sender: TObject);

{FXX07071998-1: The focus must be set on a timer.}

var
  I : Integer;

begin
  SetFocusTimer.Enabled := False;
  For I := 0 to (ComponentCount - 1) do
    If (Components[I].Name = FirstFieldSetName)
      then
        If (Components[I] is TDBEdit)
          then
            with Components[I] as TDBEdit do
              begin
                SetFocus;
                SelectAll;
              end
          else
            with Components[I] as TWinControl do
              SetFocus;

end;  {SetFocusTimerTimer}

{==============================================================}
Procedure TParcelUserDataForm.DecimalEditEnter(Sender: TObject);

{FXX02241998-1: Change display format so that when enter field, it
                is blank if zero.}

var
  TempField : TFloatField;

begin
  TempField := TFloatField(MainTable.FieldByName(TDBEdit(Sender).DataField));

  TempField.DisplayFormat := _3DecimalEditDisplay;

  TDBEdit(Sender).SelectAll;

end;  {DecimalEditEnter}

{==============================================================}
Procedure TParcelUserDataForm.DecimalEditExit(Sender: TObject);

{FXX02241998-1: Change display format so that when enter field, it
                is blank if zero.}

var
  TempField : TFloatField;

begin
    {Now change it back.}
  try
    TempField := TFloatField(MainTable.FieldByName(TDBEdit(Sender).DataField));

    TempField.DisplayFormat := _3DecimalDisplay;
  except
  end;

end;  {DecimalEditExit}

{==========================================================}
Procedure TParcelUserDataForm.EnterIntegerEdit(Sender: TObject);

{FXX02241998-1: Change display format so that when enter field, it
                is blank if zero.}

var
  TempField : TIntegerField;

begin
  TempField := TIntegerField(MainTable.FieldByName(TDBEdit(Sender).DataField));

  TempField.DisplayFormat := IntegerEditDisplay;

  TDBEdit(Sender).SelectAll;

end;  {EnterIntegerEdit}

{==============================================================}
Procedure TParcelUserDataForm.ExitIntegerEdit(Sender: TObject);


{FXX02241998-1: Change display format so that when enter field, it
                is blank if zero.}

var
  TempField : TIntegerField;

begin
    {Now change it back.}

  try
    TempField := TIntegerField(MainTable.FieldByName(TDBEdit(Sender).DataField));

    TempField.DisplayFormat := IntegerDisplay;
  except
  end;

end;  {ExitIntegerEdit}

{==============================================================}
Procedure TParcelUserDataForm.MainTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in the GlblActiveForm var.}

begin
  If not FormIsInitializing
    then
      begin
        CreateFieldValuesAndLabels(Self, MainTable, FieldTraceInformationList);

          {FXX12281999-2: Dual processing mode for user data.}

        If (MainTable.State = dsInsert)
          then RecordAction := raInserted
          else RecordAction := raEdited;

      end;  {If not FormIsInitializing}

end;  {MainTableAfterEdit}

{==============================================================}
Procedure TParcelUserDataForm.SaveButtonClick(Sender: TObject);

begin
  If (MainTable.Modified and  {Table is modified.}
      (MainTable.State in [dsEdit, dsInsert]))
    then MainTable.Post;

end;  {SaveButtonClick}

{==============================================================}
Procedure TParcelUserDataForm.CancelButtonClick(Sender: TObject);

begin
  If (MainTable.Modified and
      (MainTable.State in [dsEdit, dsInsert]) and
      (MessageDlg('Warning! You will lose all changes.' + #13 +
                  'Cancel anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes))
    then MainTable.Cancel;

end;  {CancelButtonClick}

{==============================================================}
Procedure TParcelUserDataForm.DeleteButtonClick(Sender: TObject);

begin
  If (MessageDlg('Do you want to delete this User-Defined Data?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      try
        MainTable.Delete;
      except
        SystemSupport(007, MainTable, 'Error deleting user data record.', UnitName, GlblErrorDlgBox);
      end;

end;  {DeleteButtonClick}

{==============================================================}
Procedure TParcelUserDataForm.MainTableBeforePost(DataSet: TDataset);

{If this is insert state, then fill in the SBL key and the
 tax roll year.}

var
  ReturnCode : Integer;

begin
  If ((not FormIsInitializing) and
      (MainTable.State = dsInsert))
    then
      begin
        MainTable.FieldByName('TaxRollYr').Text  := Take(4, TaxRollYr);
        MainTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);

          {FXX05151998-3: Don't ask save on close form if don't want to see save.}

        If GlblAskSave
          then
            begin
                 {FXX11061997-2: Remove the "save before exiting" prompt because it
                                 is confusing. Use only "Do you want to save.}

              ReturnCode := MessageDlg('Do you wish to save your user data changes?', mtConfirmation,
                                       [mbYes, mbNo, mbCancel], 0);

              case ReturnCode of
                idNo : If (MainTable.State = dsInsert)
                         then MainTable.Cancel
                         else RefreshNoPost(MainTable);

                idCancel : Abort;

              end;  {case ReturnCode of}

            end;  {If GlblAskSave}

      end;  {If ((not FormIsInitializing) and ...}

end;  {MainTableBeforePost}

{==============================================================}
Procedure TParcelUserDataForm.MainTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.}

var
  Found : Boolean;

begin
  Found := False;

      {FXX11101997-3: Pass the screen name into RecordChanges so
                      the screen names are more readable.}

  RecordChanges(Self, 'User Data', MainTable, ExtractSSKey(ParcelTable),
                FieldTraceInformationList);

  If GlblModifyBothYears
    then
      begin
          {Set the table in insert or edit mode depending on what action
           the user did.}

        case RecordAction of
          raInserted : begin
                         OppositeYearUserDataTable.Insert;
                         Found := True;

                       end;  {raInserted}

          raEdited : begin
                       Found := FindKeyOld(OppositeYearUserDataTable,
                                           ['TaxRollYr', 'SwisSBLKey'],
                                           [OppositeTaxYear, SwisSBLKey]);

                       If Found
                         then OppositeYearUserDataTable.Edit;

                     end;  {raEdited}

        end;  {case RecordAction of}

        CreateFieldValuesAndLabels(Self, OppositeYearUserDataTable, FieldTraceInformationList);

          {Copy the fields from the main table to the new table, but make
           sure that we do not copy the tax roll year.}

        If Found
          then
            begin
              CopyFields(MainTable, OppositeYearUserDataTable,
                         ['TaxRollYr'], [OppositeTaxYear]);

              try
                OppositeYearUserDataTable.Post;
              except
                SystemSupport(050, OppositeYearUserDataTable,
                              'Error posting opposite year record.', UnitName,
                              GlblErrorDlgBox);
              end;

              If (RecordChanges(Self, Caption,
                                OppositeYearUserDataTable, SwisSBLKey,
                                FieldTraceInformationList) > 0)
                then OppositeYearParcelChanged := True;

            end;  {If Found}

      end;  {If GlblModifyBothYears}

end;  {MainTableAfterPost}

{==============================================================}
Procedure TParcelUserDataForm.CloseButtonClick(Sender: TObject);

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
Procedure TParcelUserDataForm.FormCloseQuery(    Sender: TObject;
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

  If (MainTable.State in [dsInsert, dsEdit])
    then MainTable.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode.}

  If   (MainTable.State in [dsInsert, dsEdit])
                      AND
        (NOT MainTable.ReadOnly)
            and
      MainTable.Modified
    then
      begin
        try
          MainTable.Post;
        except
          CanClose := False;
          GlblParcelPageCloseCancelled := True;
        end;

      end;  {If Modified}

  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure TParcelUserDataForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

var
  SBLRec : SBLRecord;
  Found, Quit : Boolean;

begin
    {Now, if the parcel changed, then update the parcel table.}
    { ...to set last date modified field }
  If ParcelChanged
    then MarkRecChanged(ParcelTable, UnitName);

    {FXX12281999-2: Make sure that data is copied forward.}

  If OppositeYearParcelChanged
    then
      begin
          {Close the parcel and site table and reopen them for the
           opposite year.}

        ParcelTable.Close;

        OpenTableForProcessingType(ParcelTable, ParcelTableName,
                                   OppositeProcessingType, Quit);

          {FXX11201997-2: We were not getting opposite year parcel table before
                          trying to mark it as changed.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot',
                               'Sublot', 'Suffix'],
                              [OppositeTaxYear, SwisCode, Section, SubSection,
                               Block, Lot, Sublot, Suffix]);

        If Found
          then MarkRecChanged(ParcelTable, UnitName);

      end;  {If OppositeYearParcelChanged}

    {Close all tables here.}

  CloseTablesForForm(Self);

  FreeTList(FieldTraceInformationList, SizeOf(FieldTraceInformationRecord));

  Action := caFree;

end;  {FormClose}


end.