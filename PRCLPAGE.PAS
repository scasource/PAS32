unit Prclpage;

{To use this template for parcel pages:

1. Save the form under its new name.
2. Change the Name and Caption of the Form in the Object Inspector.
3. Change the Name of MainTable (or leave it as is for convenience)
   and set the TableName to the table that this points to.
   If you change the Name (of the object, that is), do a blanket
   replace in the code below of MainTable with the new name.
   Then, using the fields editor, add all necessary fields.
   Also, set Required to true for all required fields.
4. If you do not want a grid on this form, delete it and
   add DBEdits instead. Remember to associate the label with
   the field using the FocusControl of the label.
   If you do want a grid on this form, go into the Selected property
   of the grid and add the fields that you want to display.
5. Change UnitName to its new name. Search for 'mmm' to find
   all places where things need to be changed.
6. If you place any other tables on the form, you need to go to
   'mmm2' and call SetTableNameForTaxYear for the tables to set
   the name according to which mode they are in. Also, add the
   open to InitializeForm procedure and the table close to the
   CloseForm procedure.
7. If any tables do not have TaxRollYr as part of their key or
   SetRange (i.e. code tables for a drop down box), they must
   be filtered according to TaxRollYr). See 'mmm3' for an example.
8. Check the SetRange on the main table (mmm4). Also, if there
   are any other tables that need to have a SetRange performed on them,
   do it here. this is necessary esp for data files like Forest rec
   which have YYYYSBLSITERECNO ...a 4 part key... this generic unit
   is only a 3-part key.. Remember all parts of a key must be set
   in SetRange for SetRange to work
9. Change the A\M\V titles to reflect this parcel page's title (mmm5).}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons;

type
  TParcelPageForm = class(TForm)
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    Grid: TwwDBGrid;
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
    ParcelTableTaxRollYr: TStringField;
    ParcelTableSwisCode: TStringField;
    ParcelTableSection: TStringField;
    ParcelTableSubsection: TStringField;
    ParcelTableBlock: TStringField;
    ParcelTableLot: TStringField;
    ParcelTableSublot: TStringField;
    ParcelTableSuffix: TStringField;
    ParcelTableName1: TStringField;
    ParcelTableLegalAddrNo: TStringField;
    ParcelTableLegalAddr: TStringField;
    ParcelTableLastChangeDate: TDateField;
    ParcelTableLastChangeByName: TStringField;
    Label32: TLabel;
    CodeTable: TwwTable;
    LookupCombo: TwwDBLookupCombo;
    InactiveLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterEdit(DataSet: TDataset);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure MainTableAfterDelete(DataSet: TDataset);
    procedure CodeLookupEnter(Sender: TObject);
    procedure SetCodeOnCodeLookupCloseUp(Sender: TObject; LookupTable: TwwTable;
      FillTable: TDataset; modified: Boolean);
    procedure LookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);

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
    Procedure SetRangeForTable(Table : TTable);
      {What is the code table name for this lookup?}
    Function DetermineCodeTableName(Tag : Integer) : String;

      {Actually set the code table name.}
    Procedure SetCodeTableName(Tag : Integer);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst;


{$R *.DFM}

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

  Sample = 10;  {LLL1}

    {Now we will put the lookups that are description based in a set for later
     reference.}

  DescriptionIndexedLookups : set of 0..250 = [Sample];  {LLL2}

{=====================================================================}
Procedure TParcelPageForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TParcelPageForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{mmm4 - Make sure to set range on all keys.}

begin
  try
    Table.SetRange([TaxRollYr, SwisSBLKey], [TaxRollYr, SwisSBLKey]);
  except
    SystemSupport(001, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TParcelPageForm.InitializeForm;

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
  Found : Boolean;
  SBLRec : SBLRecord;

begin
  UnitName := '.PAS';  {mmm1}
  ParcelChanged := False;
  ClosingForm := False;
  FormIsInitializing := True;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {This string lists will hold the labels and values of each field and will be used
           to insert changes into the trace file.}

        FieldValuesList := TStringList.Create;
        FieldLabelsList := TStringList.Create;

          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then MainTable.ReadOnly := True;

          {If this is inquire let's open it in
           readonly mode. Hist access is blocked at menu level}

        If (EditMode = 'V')
          then MainTable.ReadOnly := True;

        OpenTablesForForm(Self, GlblProcessingType);

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        try
          with SBLRec do
            Found := ParcelTable.FindKey([TaxRollYr, SwisCode, Section, SubSection, Block, Lot, Sublot, Suffix]);
        except
          SystemSupport(004, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);
        end;

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Set the range.}

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

          {FXX12151997-1: Make sure that the tital does not overlap the
                          assessed values.}

        TitleLabel.Caption := '';

(*        case EditMode of   {mmm5}
          'A' : TitleLabel.Caption := ' Add';
          'M' : TitleLabel.Caption := ' Modify';
          'V' : TitleLabel.Caption := ' View';

        end;  {case EditMode of} *)

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
           no records, we have nothing to get the SBL from.}

        EditSBL.EditMask := GlblSBLEditMask;
        EditSBL.Text := SwisSBLKey;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  FormIsInitializing := False;

end;  {InitializeForm}

{====================================================================}
Function TParcelPageForm.DetermineCodeTableName(Tag : Integer) : String;

begin
  case Tag of
    Sample : Result := 'ZSampleTbl';   {LLL3}

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{========================================================================}
Procedure TParcelPageForm.SetCodeTableName(Tag : Integer);

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

  If (GlblTaxYearFlg = 'H')
    then SetRangeForHistoryTaxYear(CodeTable, 'TaxRollYr', LookupFieldName)
    else SetIndexForCodeTable(CodeTable, LookupFieldName);

end;  {SetCodeTableName}

{==============================================================}
Procedure TParcelPageForm.CodeLookupEnter(Sender: TObject);


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
                             IntToStr(CodeTable.FieldByName('MainCode').DataSize - 1) +
                             #9 + 'MainCode Code');
              end
            else
              begin
                Selected.Clear;
                Selected.Add('MainCode' + #9 +
                             IntToStr(CodeTable.FieldByName('MainCode').DataSize - 1) +
                             #9 + 'MainCode Code');
                Selected.Add('Description' + #9 + '30' + #9 + 'Description Description');

              end;  {else of If (Tag in DescriptionIndexedLookups)}

        end;  {If (CodeTable.TableName <> DetermineCode}

end;  {CodeLookupEnter}

{=====================================================================================}
Procedure TParcelPageForm.SetCodeOnLookupCloseup(Sender: TObject;
                                                 LookupTable: TwwTable;
                                                 FillTable: TDataset;
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

begin
  If MainTable.Modified
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

                FieldSize := MainTable.FieldByName(CodeFieldName).DataSize - 1; {Minus 1 because it includes #0.}

              end;  {If (Tag in DescriptionIndexedLookups)}

              {Now, if the field is now blank, then blank out the code.
               Otherwise, fill in the code in the table.}

            If (Deblank(MainTable.FieldByName(FieldName).Text) = '')
              then MainTable.FieldByName(CodeFieldName).Text := ''
              else MainTable.FieldByName(CodeFieldName).Text :=
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

                FieldSize := MainTable.FieldByName(DescFieldName).DataSize - 1;  {Minus 1 because it includes #0.}

              end;  {If (Tag in DescriptionIndexedLookups)}

              {Now, if the field is now blank, then blank out the code.
               Otherwise, fill in the code in the table.}

            If (Deblank(MainTable.FieldByName(FieldName).Text) = '')
              then MainTable.FieldByName(DescFieldName).Text := ''
              else MainTable.FieldByName(DescFieldName).Text :=
                   Take(FieldSize, TwwDBLookupCombo(Sender).LookupTable.FieldByName('Description').Text);

          end;  {else of If (TComponent(Sender).Tag in DescriptionIndexedLookups)}

end;  {SetCodeOnLookupCloseup}

{==============================================================}
Procedure TParcelPageForm.MainTableAfterEdit(DataSet: TDataset);

{We will initialize the field values for this record. This will be used in the trace
 logic. In the AfterPost event, we will pass the values into the Record Changes procedure
 in PASUTILS and a record will be inserted into the trace file if any differences exist.
 Note that this is a shared event handler with the AfterInsert event.
 Also note that we can not pass in the form variable (i.e. BaseParcelPg1Form) since
 it is not initialized. Instead, we have to pass in the Self var.}

var
  FieldNamesList : TStringList;

begin
  If not FormIsInitializing
    then
      begin
         {FXX11101997-6: Combined the CreateFieldValuesAndLabels from UGenSclb
                         and PASUtils for compatibility.}

        FieldNamesList := TStringList.Create;

        CreateFieldValuesAndLabels(Self, MainTable,
                                   FieldValuesList, FieldLabelsList,
                                   FieldNamesList);

        FieldNamesList.Free;

      end;  {If not FormIsInitializing}

end;  {MainTableAfterEdit}

{==============================================================}
Procedure TParcelPageForm.MainTableAfterDelete(DataSet: TDataset);

{After a delete, we should always reset the range.}

begin
  MainTable.DisableControls;
  MainTable.CancelRange;
  SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}
  MainTable.EnableControls;

end;  {MainTableAfterDelete}

{==============================================================}
Procedure TParcelPageForm.MainTableBeforePost(DataSet: TDataset);

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

              ReturnCode := MessageDlg('Do you wish to save your changes?', mtConfirmation,
                                       [mbYes, mbNo, mbCancel], 0);

              case ReturnCode of
                idNo : If (MainTable.State = dsInsert)
                         then MainTable.Cancel
                         else RefreshNoPost(MainTable);

                idCancel : (*Abort;*)

              end;  {case ReturnCode of}

            end;  {If GlblAskSave}

      end;  {If ((not FormIsInitializing) and ...}

end;  {MainTableBeforePost}

{==============================================================}
Procedure TParcelPageForm.MainTableAfterPost(DataSet: TDataset);

{Now let's call RecordChanges which will insert a record into the trace file if any differences
 exist.
 Note that RecordChanges returns an integer saying how many changes there
 were. If this number is greater than 0, then we will update the
 name and date changed fields of the parcel record.}

begin
      {FXX11101997-3: Pass the screen name into RecordChanges so
                      the screen names are more readable.}

  If (RecordChanges(Self, Caption, MainTable, SwisSBLKey,
                    FieldValuesList, FieldLabelsList) > 0)
    then ParcelChanged := True;

end;  {MainTableAfterPost}

{==============================================================}
Procedure TParcelPageForm.CloseButtonClick(Sender: TObject);

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
Procedure TParcelPageForm.FormCloseQuery(    Sender: TObject;
                                         var CanClose: Boolean);

var
  ReturnCode : Integer;

begin
  GlblParcelPageCloseCancelled := False;
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

  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure TParcelPageForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
    {Now, if the parcel changed, then update the parcel table.}

  If ParcelChanged
    then MarkRecChanged(ParcelTable, UnitName);

    {Close all tables here.}

  CloseTablesForForm(Self);

    {Free up the string lists.}

  FieldValuesList.Free;
  FieldLabelsList.Free;

  Action := caFree;

end;  {FormClose}

end.