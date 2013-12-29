unit PNote_Halcyon;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, RPFiler, RPBase, RPCanvas, RPrinter,
  Printrng, RPMemo, RPDBUtil, RPDefine, Progress, wwMemo, Halcn6db;

type
  TNotesForm = class(TForm)
    NotesDataSource: TwwDataSource;
    NotesTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintRangeDlg: TPrintRangeDlg;
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
    CodeTable: TwwTable;
    ParcelTableLastChangeDate: TDateField;
    ParcelTableLastChangeByName: TStringField;
    UserTable: TwwTable;
    ParcelTableActiveFlag: TStringField;
    InactiveLabel: TLabel;
    NotesTableDateEntered: TDateField;
    NotesTableTimeEntered: TTimeField;
    NotesTableNoteNumber: TSmallintField;
    NotesTableEnteredByUserID: TStringField;
    NotesTableTransactionCode: TStringField;
    NotesTableNoteTypeCode: TStringField;
    NotesTableDueDate: TDateField;
    NotesTableUserResponsible: TStringField;
    NotesTableNoteOpen: TBooleanField;
    NotesTablePurgable: TBooleanField;
    NotesTableNote: TMemoField;
    NotesTableSwisSBLKey: TStringField;
    NotesTableTransactionDesc: TStringField;
    NotesTableNoteTypeDesc: TStringField;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    NotesLookupTable: TTable;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    ParcelTableRemapOldSBL: TStringField;
    NotesSearchTable: TTable;
    NotesSearchTableSwisSBLKey: TStringField;
    NotesSearchTableDateEntered: TDateField;
    NotesSearchTableTimeEntered: TDateTimeField;
    NotesSearchTableNoteNumber: TIntegerField;
    NotesSearchTableEnteredByUserID: TStringField;
    NotesSearchTableTransactionDesc: TStringField;
    NotesSearchTableTransactionCode: TStringField;
    NotesSearchTableNoteTypeDesc: TStringField;
    NotesSearchTableNoteTypeCode: TStringField;
    NotesSearchTableDueDate: TDateField;
    NotesSearchTableUserResponsible: TStringField;
    NotesSearchTableNoteOpen: TBooleanField;
    NotesSearchTablePurgable: TBooleanField;
    NotesSearchTableReserved: TStringField;
    NotesSearchTableNote: TMemoField;
    PartialAssessmentLabel: TLabel;
    FooterPanel: TPanel;
    PrintButton: TBitBtn;
    Navigator: TDBNavigator;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    NotesGrid: TwwDBGrid;
    NotesXActLookupCombo: TwwDBLookupCombo;
    NotesTypeLookupCombo: TwwDBLookupCombo;
    UserResponsibleLookupCombo: TwwDBLookupCombo;
    StatusPanel: TPanel;
    Panel5: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label6: TLabel;
    EditName: TDBEdit;
    EditSBL: TMaskEdit;
    EditLocation: TEdit;
    EditLastChangeDate: TDBEdit;
    EditLastChangeByName: TDBEdit;
    HalcyonDataSet1: THalcyonDataSet;
    Database1: TDatabase;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrinterPrintHeader(Sender: TObject);
    procedure NotesTableAfterDelete(DataSet: TDataset);
    procedure NotesTableNewRecord(DataSet: TDataset);
    procedure CodeLookupEnter(Sender: TObject);
    procedure NotesTableBeforePost(DataSet: TDataset);
    procedure NotesGridMemoOpen(Grid: TwwDBGrid;
      MemoDialog: TwwMemoDialog);
    procedure NotesTableAfterInsert(DataSet: TDataset);
    procedure NotesDataSourceDataChange(Sender: TObject; Field: TField);
    procedure SetCodeOnLookupCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure ReportFilerPrint(Sender: TObject);
    procedure NotesTableAfterScroll(DataSet: TDataSet);
    procedure NotesTableBeforeDelete(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
    procedure NotesTableBeforeInsert(DataSet: TDataSet);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr, SwisSBLKey : String;
    ProcessingType : Integer;  {NextYear, ThisYear, History}

    PostingRecord,
    ClosingForm : Boolean;  {Are we in the process of closing this
                             form?}
    PostCancelled : Boolean;  {Was the  post cancelled?}

      {This variable is here to prevent the following problem:
       After setting the range, the table is set to modified. To
       prevent this, we call Table.Edit followed by Table.Cancel.
       However, for some reason this causes the OnAfterInsert event
       to be called, and we try to set up a new record, even
       though we don't want to. So, until the initialization is completed,
       no processing is done in the OnAfterInsert event.}

    TableIsInitializing : Boolean;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    OriginalGridWidth : Integer;

    Procedure SetRangeForTable(NotesTable : TTable;
                               SwisSBLKey : String);

    Procedure InitializeForm;
      {What is the code table name for this lookup?}
    Function DetermineCodeTableName(Tag : Integer) : String;

      {Actually set the code table name.}
    Procedure SetCodeTableName(Tag : Integer);
    Procedure SetReadOnlyFields;

  end;

var
  NotesForm: TNotesForm;

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst,
     Preview;  {Report preview form}

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

  NotesXAct = 10;  {LLL1}
  NotesType = 20;

    {Now we will put the lookups that are description based in a set for later
     reference.}

  DescriptionIndexedLookups : set of 0..250 = [];

{$R *.DFM}

{=====================================================================}
Procedure TNotesForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{====================================================================}
Procedure TNotesForm.SetRangeForTable(NotesTable : TTable;
                                      SwisSBLKey : String);

begin
  try
    SetRangeOld(NotesTable, ['SwisSBLKey', 'NoteNumber'],
                [SwisSBLKey, '1'], [SwisSBLKey, '32000']);
  except
    SystemSupport(008, NotesTable, 'Error setting range in notes table.', UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TNotesForm.FormResize(Sender: TObject);

begin
  If ((not TableIsInitializing) and
      (NotesGrid.Width <> OriginalGridWidth))
    then
      begin
        ResizeGridFontForWidthChange(NotesGrid, OriginalGridWidth);
(*        NotesGrid.ColumnByName('Note').DisplayWidth := Trunc((NotesGrid.ColumnByName('Note').DisplayWidth +
                                                              (NotesGrid.Width - OriginalGridWidth)) / 7);*)
        Navigator.Left := (FooterPanel.Width - Navigator.Width) DIV 2;
        CloseButton.Left := FooterPanel.Width - 100;

        OriginalGridWidth := NotesGrid.Width;

      end;  {If ((not TableIsInitializing) and ...}

end;  {FormResize}

{====================================================================}
Procedure TNotesForm.InitializeForm;

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
  OriginalGridWidth := NotesGrid.Width;
  UnitName := 'PNOTEFRM.PAS';
  TableIsInitializing := True;
  ClosingForm := False;
  PostingRecord := False;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        SetTableNameForTaxYear(ParcelTable);  {Since the note table is year independant, we
                                               will open the parcel table for the glbl tax year.}

        If not ModifyAccessAllowed(FormAccessRights)
          then NotesTable.ReadOnly := True;

           {CHG09251996 - The notes table can always be edited,
                          so we won't open it in readonly for
                          view mode.}

        OpenTablesForForm(Self, ProcessingType);

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        try
          with SBLRec do
            Found := FindKeyOld(ParcelTable,
                                ['TaxRollYr', 'SwisCode', 'Section',
                                 'Subsection', 'Block', 'Lot', 'Sublot',
                                 'Suffix'],
                                [TaxRollYr, SwisCode, Section,
                                 SubSection, Block, Lot, Sublot, Suffix]);
        except
          SystemSupport(006, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);
        end;

        If not Found
          then SystemSupport(007, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Now set the range on the notes and notes search table
           so that it is sychronized to this parcel. Note
           that all segments of the key must be set.}

        SetRangeForTable(NotesTable, SwisSBLKey);

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

          {FXX12151997-1: Make sure that the tital does not overlap the
                          assessed values.}

        TitleLabel.Caption := 'Notes';

(*         case EditMode of
          'A' : TitleLabel.Caption := 'Notes Add';
          'M' : TitleLabel.Caption := 'Notes Modify';
          'V' : TitleLabel.Caption := 'Notes View';

        end;  {case EditMode of} *)

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Now, for some reason the table is marked as
           Modified after we look it up (in modify mode).
           So, we will cancel the modify and set it in
           the proper mode.}

        If not NotesTable.ReadOnly
          then
            begin
              NotesTable.Edit;
              NotesTable.Cancel;
            end;

           {CHG09251996 - The notes table can always be edited,
                          so we won't limit them to just
                          next, prior, first, last buttons.}

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

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

      end;  {If (Deblank(SwisSBLKey) <> '')}

  TableIsInitializing := False;

  If (NotesTable.RecordCount > 0)
    then SetReadOnlyFields;

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  FormResize(nil);

end;  {InitializeForm}

{===========================================================================}
Procedure TNotesForm.NotesTableNewRecord(DataSet: TDataset);

{Fill in the read only information.}

var
  FoundRec : Boolean;
  I, Status : Integer;

begin
  If not TableIsInitializing
    then
      begin
        with NotesTable do
          For I := 0 to (FieldCount - 1) do
            Fields[I].ReadOnly := False;

          {FXX1021998-2: Need to reset read only fields.}

        NotesTableSwisSBLKey.Text := Take(26, SwisSBLKey);
        NotesTableDateEntered.AsDateTime := Date;
        NotesTableTimeEntered.AsDateTime := Now;
        NotesTableEnteredByUserID.Text   := GlblUserName;
        NotesTableNoteOpen.AsBoolean     := True;  {Default open to true.}
        NotesTablePurgable.AsBoolean     := GlblNotesPurgeDefault;

          {Now figure out the next note number by looking at the last note in the range.
           Note that we can tell that there are no notes if the sbl key of the search table is
           blank, since if there are no records in the range, then it will be.}

        NotesSearchTable.CancelRange;
        SetRangeForTable(NotesSearchTable, SwisSBLKey);

        try
          NotesSearchTable.Last;
        except
          SystemSupport(010, NotesSearchTable, 'Error getting last in notes search table.', UnitName,
                        GlblErrorDlgBox);
        end;

        If (Status = BRC_EndOfFile)
          then NotesTableNoteNumber.AsInteger := 1
          else NotesTableNoteNumber.AsInteger := NotesSearchTable.FieldByName('NoteNumber').AsInteger + 1;

      end;  {If not TableIsInitializing}

end;  {NotesTableNewRecord}

{====================================================================}
Procedure TNotesForm.NotesDataSourceDataChange(Sender: TObject;
                                               Field: TField);

{FXX06222000-1: Sometimes the notes memo was not reset to no view only.}

begin
  NotesGrid.MemoAttributes := NotesGrid.MemoAttributes - [mViewOnly];
end;

{====================================================================}
Procedure TNotesForm.SetReadOnlyFields;

var
  I : Integer;
  ReadOnlyStatus : Boolean;

begin
  If ((not TableIsInitializing) and
      (not NotesTable.ReadOnly))
    then
      begin
        ReadOnlyStatus := False;

        If ((not GlblModifyOthersNotes) and
            (Take(10, GlblUserName) <> Take(10, 'SUPERVISOR')) and
            (Take(10, NotesTableEnteredByUserID.Text) <> Take(10, GlblUserName)) and
            (Take(10, NotesTableUserResponsible.Text) <> Take(10, GlblUserName)))
          then ReadOnlyStatus := True;

          {Make sure that if we are in insert mode, all fields are open.}

        If (NotesTable.State = dsInsert)
          then ReadOnlyStatus := False;

        with NotesTable do
          For I := 0 to (FieldCount - 1) do
            Fields[I].ReadOnly := ReadOnlyStatus;

          {CHG04302003-1(2.07): Allow users to turn Open on and off even
                                if they are not allowed to modify each other's notes.}

        If (NotesTable.FieldByName('NoteOpen').ReadOnly and
            GlblAnyUserCanChangeOpenNoteStatus)
          then NotesTable.FieldByName('NoteOpen').ReadOnly := False;

      end;  {If not TableIsInitializing}

end;  {SetReadOnlyFields}

{====================================================================}
Procedure TNotesForm.NotesTableBeforeInsert(DataSet: TDataSet);

{FXX05182004-1(2.074): Set the fields to read only false here to prevent problem where
                       TwwDBComboLookup boxes stay read only after SetReadOnlyFields.}

var
  I : Integer;

begin
  with NotesTable do
    For I := 0 to (FieldCount - 1) do
      Fields[I].ReadOnly := False;

end;  {NotesTableBeforeInsert}

{====================================================================}
Procedure TNotesForm.NotesTableBeforeDelete(DataSet: TDataSet);

begin
  If ((not GlblModifyOthersNotes) and
      (Take(10, GlblUserName) <> Take(10, 'SUPERVISOR')) and
      (Take(10, NotesTableEnteredByUserID.Text) <> Take(10, GlblUserName)) and
      (Take(10, NotesTableUserResponsible.Text) <> Take(10, GlblUserName)))
    then
      begin
        MessageDlg('Sorry, you can not delete another person''s notes.',
                   mtError, [mbOK], 0);
        Abort;
      end;  {If ((not GlblModifyOthersNotes) and ...}

end;  {NotesTableBeforeDelete}

{====================================================================}
Procedure TNotesForm.NotesTableAfterInsert(DataSet: TDataset);

begin
     {FXX12011998-15: After insert, put the user in the notes
                      XAct field.}

  If not TableIsInitializing
    then
      begin
        NotesGrid.SetFocus;
        NotesGrid.SetActiveField('TransactionCode');
      end;

end;  {NotesTableAfterInsert}

{====================================================================}
Procedure TNotesForm.NotesTableAfterScroll(DataSet: TDataSet);

begin
  If not TableIsInitializing
    then SetReadOnlyFields;

end;  {NotesTableAfterScroll}

{====================================================================}
Function TNotesForm.DetermineCodeTableName(Tag : Integer) : String;

{Based on the tag of the lookup combo box, what table should we open in the
 code table? Note that the constants below are declared right after the
 IMPLEMENTATION directive.}

begin
  case Tag of  {LLL3}
    NotesXAct : Result := 'ZNotesXActCodeTbl';
    NotesType : Result := 'ZNotesTypeTbl';

  end;  {case Tag of}

end;  {DetermineCodeTableName}

{========================================================================}
Procedure TNotesForm.SetCodeTableName(Tag : Integer);

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
Procedure TNotesForm.CodeLookupEnter(Sender: TObject);

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

{==============================================================}
Procedure TNotesForm.SetCodeOnLookupCloseUp(Sender: TObject;
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

begin
  If ((NotesTable.State in [dsInsert, dsEdit]) and
      NotesTable.Modified)
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

                FieldSize := NotesTable.FieldByName(CodeFieldName).DataSize - 1; {Minus 1 because it includes #0.}

              end;  {If (Tag in DescriptionIndexedLookups)}

              {Now, if the field is now blank, then blank out the code.
               Otherwise, fill in the code in the table.}

            If (Deblank(NotesTable.FieldByName(FieldName).Text) = '')
              then NotesTable.FieldByName(CodeFieldName).Text := ''
              else NotesTable.FieldByName(CodeFieldName).Text :=
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

                FieldSize := NotesTable.FieldByName(DescFieldName).DataSize - 1;  {Minus 1 because it includes #0.}

              end;  {If (Tag in DescriptionIndexedLookups)}

              {Now, if the field is now blank, then blank out the code.
               Otherwise, fill in the code in the table.}

            If (Deblank(NotesTable.FieldByName(FieldName).Text) = '')
              then NotesTable.FieldByName(DescFieldName).Text := ''
              else NotesTable.FieldByName(DescFieldName).Text :=
                   Take(FieldSize, TwwDBLookupCombo(Sender).LookupTable.FieldByName('Description').Text);

              {If they changed the notes type to 'T', make sure that the tickler fields are not r\o.
               Otherwise, blank them out and change them to R\O.}

            If (TwwDBLookupCombo(Sender).Name = 'NotesTypeLookupCombo')
              then
                begin
                  case NotesTypeLookupCombo.Text[1] of
                    'R' : begin  {Regular Notes}
                            If (NotesTableDueDate.AsDateTime <> 0)
                              then NotesTableDueDate.Text := '';
                            NotesTableUserResponsible.Text := '';
                            NotesTableNoteOpen.AsBoolean := False;

                            NotesTableDueDate.ReadOnly := True;

                              {FXX11062003-1(2.07k): Let them enter a user responsible if they want.}

                            NotesTableUserResponsible.ReadOnly := False;

                              {FXX04272001-2: Don't set the user responsible to read only -
                                              it only causes problems.  They can now
                                              enter on regular, but no big deal.}

(*                            NotesTableUserResponsible.ReadOnly := True; *)

                              {CHG01032000-2: Allow user to enter open or
                                              closed on a regular note.}

                            (*NotesTableNoteOpen.ReadOnly := True;*)

                          end;   {Regular Notes}

                    'T' : begin  {Tickler}
                            NotesTableDueDate.ReadOnly := False;
(*                            NotesTableUserResponsible.ReadOnly := False; *)
                            NotesTableNoteOpen.ReadOnly := False;
                            NotesTableDueDate.Required := True;
                            NotesTableUserResponsible.Required := True;

                          end;   {Tickler}

                  end;  {case NotesTableNoteTypeCode of}

                end;  {If (TwwDBLookupCombo(Sender).Name = 'NotesTypeLookupCombo')}

          end;  {else of If (TComponent(Sender).Tag in DescriptionIndexedLookups)}

end;  {SetCodeOnLookupCloseUp}

{==============================================================}
Procedure TNotesForm.NotesTableBeforePost(DataSet: TDataset);

{Make sure that the responsible user is capitalized.}

begin
  If ((not NotesTable.FieldByName('UserResponsible').ReadOnly) and
      (Deblank(NotesTable.FieldByName('UserResponsible').Text) <> ''))
    then NotesTable.FieldByName('UserResponsible').Text :=
                     ANSIUpperCase(NotesTable.FieldByName('UserResponsible').Text);


    {FXX11052003-1(2.07k): If they really want to enter a user responsible, who am I to question?}
(*    {If this is a regular note and they entered a user responsible,
     blank it out.}

  If ((NotesTable.FieldByName('NoteTypeCode').Text = 'R') and
      (not NotesTable.FieldByName('UserResponsible').ReadOnly) and
      (Deblank(NotesTable.FieldByName('UserResponsible').Text) <> ''))
    then NotesTable.FieldByName('UserResponsible').Text := '';*)

end;  {NotesTableBeforePost}

{==============================================================}
Procedure TNotesForm.NotesTableAfterDelete(DataSet: TDataset);

{Reset the range for the table because sometimes it gets screwed up
 after a delete.}

begin
  NotesTable.DisableControls;
  NotesTable.CancelRange;

  SetRangeForTable(NotesTable, SwisSBLKey);

  NotesTable.EnableControls;
  SetReadOnlyFields;

end;  {NotesTableAfterDelete}

{==============================================================}
Procedure TNotesForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;

begin
    {First check to see if they need to post any changes.}

  If NotesTable.Modified
    then
      try
        NotesTable.Post;
      except
        SystemSupport(011, NotesTable, 'Error attempting to post.',
                      UnitName, GlblErrorDlgBox);

      end;  {except}

    {Now do the actual printing. To do this, we will first
     execute the print range dialog to let them select the
     range that they want to print and the printer.}

  If PrintRangeDlg.Execute
    then
      begin
          {If they want to preview the print (i.e. have it
           go to the screen), then we need to come up with
           a unique file name to tell the ReportFiler
           component where to put the output.
           Once we have done that, we will execute the
           report filer which will print the report to
           that file. Then we will create and show the
           preview print form and give it the name of the
           file. When we are done, we will delete the file
           and make sure that we go back to the original
           directory.}

        If PrintRangeDlg.PreviewPrint
          then
            begin
              NewFileName := GetPrintFileName(Self.Caption, True);
              ReportFiler.FileName := NewFileName;

              try
                PreviewForm := TPreviewForm.Create(self);
                PreviewForm.FilePrinter.FileName := NewFileName;
                PreviewForm.FilePreview.FileName := NewFileName;

                ReportFiler.Execute;
                PreviewForm.ShowModal;
              finally
                PreviewForm.Free;

                  {Now delete the file.}
                try
                  AssignFile(TempFile, NewFileName);
                  OldDeleteFile(NewFileName);
                finally
                  {We don't care if it does not get deleted, so we won't put up an
                   error message.}

                  ChDir(GlblProgramDir);
                end;

              end;  {If PrintRangeDlg.PreviewPrint}

            end  {They did not select preview, so we will go
                  right to the printer.}
          else ReportPrinter.Execute;

      end  {If PrintRangeDlg.Execute}
    else NotesGrid.SetFocus;

end;  {PrintButtonClick}

{==============================================================}
Procedure TNotesForm.CloseButtonClick(Sender: TObject);

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
Procedure TNotesForm.FormCloseQuery(    Sender: TObject;
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

  If (NotesTable.State in [dsInsert, dsEdit])
    then NotesTable.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode.}

    {FXX05151998-3: Don't ask save on close form if don't want to see save.}

  If ((not NotesTable.ReadOnly) and
      (NotesTable.State in [dsInsert, dsEdit]) and
      NotesTable.Modified)
    then
      If GlblAskSave
        then
          begin
              {FXX11061997-2: Remove the "save before exiting" prompt because it
                              is confusing. Use only "Do you want to save.}

            ReturnCode := MessageDlg('Do you wish to save your changes?', mtConfirmation,
                                     [mbYes, mbNo, mbCancel], 0);

            case ReturnCode of
              idYes : NotesTable.Post;

              idNo : NotesTable.Cancel;

              idCancel : begin
                           GlblParcelPageCloseCancelled := True;
                           CanClose := False;
                         end;

            end;  {case ReturnCode of}

          end
        else NotesTable.Post;

  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure TNotesForm.FormClose(    Sender: TObject;
                               var Action: TCloseAction);

begin
    {Close all tables here.}

  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}

{=============================================================================}
{===============   PRINTING LOGIC  ===========================================}
{=============================================================================}
Procedure TNotesForm.ReportPrinterPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      MarginTop := 1.25;
      MarginBottom := 0.75;
      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Times New Roman',14);
      Underline := True;
      Home;
      CRLF;
      PrintCenter('Notes Listing', (PageWidth / 2));
      SetFont('Times New Roman', 12);
      CRLF;
      CRLF;
      Println('Swis\SBL: ' + ConvertSwisSBLToDashDot(SwisSBLKey));
      Println('');
      Print('For Notes: ');

      with PrintRangeDlg do
        If PrintAllCodes
          then Println('All')
          else
            begin
              Print(StartRange + ' to ');

              If PrintToEndOfCodes
                then Println('End')
                else Println(EndRange);

            end;  {else of If PrintAllCodes}

      SectionTop := 1.5;

        {Print column headers.}

      CRLF;
      CRLF;
      Home;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('Times New Roman', 10);
      Underline := False;

      Bold := True;
      ClearTabs;
      SetTab(0.1, pjCenter, 0.3, 0, BOXLINEBottom, 0);   {Note Num}
      SetTab(0.5, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {Date}
      SetTab(1.6, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Time}
      SetTab(2.5, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {User}
      SetTab(3.8, pjCenter, 1.2, 0, BOXLINEBOTTOM, 0);   {Xact Cd}
      SetTab(5.1, pjCenter, 0.2, 0, BOXLINEBOTTOM, 0);   {Note Type}
      SetTab(5.4, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {Date due}
      SetTab(6.5, pjCenter, 1.1, 0, BOXLINEBOTTOM, 0);   {User responsible}
      SetTab(7.7, pjCenter, 0.3, 0, BOXLINEBOTTOM, 0);   {Open?}

      Print(#9 + 'Num');
      Print(#9 + 'Date Ent');
      Println(#9 + 'Time' +
              #9 + 'Ent By' +
              #9 + 'Xact Cd' +
              #9 + 'Type' +
              #9 + 'Date Due' +
              #9 + 'Respons.' +
              #9 + 'Open?');
      Println('');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrintHeader}

{=============================================================================}
Procedure TNotesForm.ReportFilerPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  DBMemoBuf: TDBMemoBuf;
  I, TempInt, Lines : Integer;
  Buffer : PChar;
  TempStr : String;

begin
  Done := False;
  FirstTimeThrough := True;
  StatusPanel.Visible := True;

  NotesSearchTable.CancelRange;
  SetRangeForTable(NotesSearchTable, SwisSBLKey);

  If PrintRangeDlg.PrintAllCodes
    then NotesSearchTable.First
    else FindNearestOld(NotesSearchTable,
                        ['SwisSBLKey', 'NoteNumber'],
                        [SwisSBLKey, PrintRangeDlg.StartRange]);

  with Sender as TBaseReport do
    begin
      Bold := False;

        {Set up the tabs for the info.}

      ClearTabs;
      SetFont('Times New Roman', 10);
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.1, pjLeft, 0.3, 0, BoxLineNone, 0);   {Note Num}
      SetTab(0.5, pjLeft, 1.0, 0, BoxLineNone, 0);   {Date}
      SetTab(1.6, pjLeft, 0.8, 0, BoxLineNone, 0);   {Time}
      SetTab(2.5, pjLeft, 1.2, 0, BoxLineNone, 0);   {User}
      SetTab(3.8, pjLeft, 1.2, 0, BoxLineNone, 0);   {Xact Cd}
      SetTab(5.1, pjLeft, 0.2, 0, BoxLineNone, 0);   {Note Type}
      SetTab(5.4, pjLeft, 1.0, 0, BoxLineNone, 0);   {Date due}
      SetTab(6.5, pjLeft, 1.1, 0, BoxLineNone, 0);   {User responsible}
      SetTab(7.7, pjCenter, 0.3, 0, BoxLineNone, 0);   {Open?}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else NotesSearchTable.Next;

        If NotesSearchTable.EOF
          then Done := True;

          {Make sure that we are not past the end of the range.}

        with PrintRangeDlg do
          If ((not (PrintAllCodes or PrintToEndOfCodes)) and
              (NotesSearchTable.FieldByName('NoteNumber').Text > EndRange))
            then Done := True;

          {Now actually print it.}

        If not Done
          then
            with NotesSearchTable do
              begin
                Print(#9 + FieldByName('NoteNumber').Text +
                      #9 + FieldByName('DateEntered').Text +
                      #9 + FormatDateTime(TimeFormat,
                                          FieldByName('TimeEntered').AsDateTime) +
                      #9 + FieldByName('EnteredByUserID').Text +
                      #9 + FieldByName('TransactionCode').Text +
                      #9 + FieldByName('NoteTypeCode').Text +
                      #9 + FieldByName('DueDate').Text +
                      #9 + FieldByName('UserResponsible').Text);

                If (FieldByName('NoteTypeCode').Text = 'T')
                  then
                    begin
                      If (FieldByName('NoteOpen').Text = 'True')
                        then Println(#9 + 'X')
                        else Println('');
                    end
                  else Println('');

                   {Now print the note.}

                DBMemoBuf := TDBMemoBuf.Create;
                DBMemoBuf.Field := NotesSearchTableNote;

                DBMemoBuf.PrintStart := 0.5;
                DBMemoBuf.PrintEnd := 7.9;

                PrintMemo(DBMemoBuf, 0, False);
                DBMemoBuf.Free;

                  {Update the status bar.}
                StatusPanel.Caption := 'Printing Note: ' + FieldByName('NoteNumber').Text;
                StatusPanel.Repaint;

                If (LinesLeft = 1)
                  then NewPage;

              end;  {If not Done}

      until Done;

    end;  {with Sender as TBaseReport do}

  StatusPanel.Caption := '';
  StatusPanel.Visible := False;

end;  {ReportFilerPrint}

{==============================================================}
Procedure TNotesForm.NotesGridMemoOpen(Grid: TwwDBGrid;
                                       MemoDialog: TwwMemoDialog);

{Make sure that the text of the memo is big even though the text in
 the grid is not.}

begin
    {CHG09102004-1(2.8.0.11): Set the caption of the memo dialog to be the parcel ID.}

  MemoDialog.Caption := 'Note for ' + ConvertSwisSBLToDashDot(SwisSBLKey);

  MemoDialog.Font.Size := 10;
  MemoDialog.Font.Style := [fsBold];

    {FXX02282000-3: Don't check for non-modify of others notes until go to post -
                    otherwise, they get it if they are even just viewing.}

  If ((not GlblModifyOthersNotes) and
      (Take(10, NotesTableEnteredByUserID.Text) <> Take(10, GlblUserName)) and
      (Take(10, NotesTableUserResponsible.Text) <> Take(10, GlblUserName)))
    then
      begin
        If not (mViewOnly in NotesGrid.MemoAttributes)
          then NotesGrid.MemoAttributes := NotesGrid.MemoAttributes + [mViewOnly];
      end
    else
      begin
        If (mViewOnly in NotesGrid.MemoAttributes)
          then NotesGrid.MemoAttributes := NotesGrid.MemoAttributes - [mViewOnly];
      end;

end;  {NotesGridMemoOpen}

end.