unit Strctmnt;

interface

uses
  DBIProcs, SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, Mask, DBCtrls,
  Wwkeycb, DB, DBTables, Wwtable, Wwdatsrc, Printrng, Btrvdlg, Grids,
  DBGrids, DBLookup, RPBase, RPCanvas, RPrinter, Wwdbigrd, Wwdbgrid,
  TabNotBk, RPDefine, RPFiler;

type
  TStructureMaintForm = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    DBNavigator: TDBNavigator;
    IncrementalSearch: TwwIncrementalSearch;
    TitleLabel: TLabel;
    MainCodeLabel: TLabel;
    DescriptionLabel: TLabel;
    InsertButton: TBitBtn;
    DeleteButton: TBitBtn;
    PrintButton: TBitBtn;
    SaveButton: TBitBtn;
    ExitButton: TBitBtn;
    MainCodeEdit: TDBEdit;
    DescriptionEdit: TDBEdit;
    InsertLabel1: TLabel;
    IncrementalSearchLabel: TLabel;
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    PrintRangeDlg: TPrintRangeDlg;
    LookupTable: TwwTable;
    RefreshButton: TBitBtn;
    StatusBar: TPanel;
    LookupGrid: TDBGrid;
    InsertLabel2: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    MeasureCodesGroupBox: TGroupBox;
    MC1CheckBox: TDBCheckBox;
    MC2CheckBox: TDBCheckBox;
    MC3CheckBox: TDBCheckBox;
    MC4CheckBox: TDBCheckBox;
    procedure InsertButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure MainCodeEditExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RefreshButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IncrementalSearchExit(Sender: TObject);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure IncrementalSearchEnter(Sender: TObject);
    procedure LookupGridEnter(Sender: TObject);
    procedure LookupGridExit(Sender: TObject);
    procedure ReportPrinterBeforePrint(Sender: TObject);
    function ReportPrinterPrintPage(Sender: TObject;
      var PageNum: Integer): Boolean;
    procedure ReportPrinterPrintHeader(Sender: TObject);
    procedure ReportPrinterAfterPrint(Sender: TObject);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure Cleanup;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MeasureCodesGroupBoxEnter(Sender: TObject);
    procedure MeasureCodesGroupBoxExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  private
    UnitName : String; {For error dialog box}
    Inserting : Boolean;  {Are we presently in insert mode?}
    CancelledPost : Boolean;  {Did they answer cancel to the
                               'Do you want to post question?'}
    LastKeyPressed : Char;  {For an explanation of this variable see
                             OnDescriptionExit event.}
  public
    MainCodeName : String;
    SRAZ : Boolean;  {Should we shift right add zeroes?}
    FormAccessRights : Integer; {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;  {Open the tables and setup.}
    Procedure SetStatusBarCaption;
  end;

var
  StructureMaintForm: TStructureMaintForm;

implementation

{$R *.DFM}

uses
  Preview,   {Print preview form}
  Types,     {Constants, types}
  Utilitys,  {General utilities}
  GlblVars,  {Global variables}
  PASUTILS, UTILEXSD,   {PAS specific utilites}
  WinUtils;  {Windows specific utilities}
{===================================================================}
Procedure TStructureMaintForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{===================================================================}
Procedure TStructureMaintForm.Cleanup;

{Restore the form to it's original state i.e. Edit state, no
 insert labels visible, the code edit box disabled, etc.
 This is called after posting.}

begin
     {Make sure that the labels which prompt the person to enter a new code
      are turned off.}

  If InsertLabel1.Visible
    then
      begin
        InsertLabel1.Visible := False;
        InsertLabel2.Visible := False;
      end;

    {Make sure that the delete button is on.}

  If not DeleteButton.Enabled
    then DeleteButton.Enabled := True;

    {Disable the code edit box.}

  If not MainCodeEdit.ReadOnly
    then
      begin
        MainCodeEdit.ReadOnly := True;
        MainCodeEdit.TabStop := False;
        MainCodeEdit.Color := clBtnFace;
      end;

   {Put the main table in edit state.}

  If not MainTable.ReadOnly
    then MainTable.Edit;

    {If there are no records in the table, then we will
     put a special message at the bottom of the screen
     asking them to click add to add the first record.
     Otherwise, we will put them in the incremental search
     field.}

  If (MainTable.RecordCount = 0)
    then
      begin
        StatusBar.Caption := 'Please click the insert button to enter the first ' +
                             LowerCase(MainCodeName) + ' code.';
        IncrementalSearch.Enabled := False;
        InsertButton.SetFocus;
      end
    else
      begin
        If not IncrementalSearch.Enabled
          then IncrementalSearch.Enabled := True;

        IncrementalSearch.SetFocus;

      end;  {else of If (MainTable.RecordCount = 0)}

end;  {Cleanup}

{======================================================================}
Procedure TStructureMaintForm.SetStatusBarCaption;

begin
  If MainTable.ReadOnly
    then StatusBar.Caption := 'Please choose the ' + LowerCase(MainCodeName) +
                              ' code to view.'
    else StatusBar.Caption := 'Please choose the ' + LowerCase(MainCodeName) +
                              ' code to view, edit, or delete.';

end;  {SetStatusBarCaption}

{======================================================================}
Procedure TStructureMaintForm.InitializeForm;

{Open the tables.}

begin
  MainCodeName := 'Structure';
  SRAZ := False;
  UnitName := 'STRCTMNT.PAS';  {mmm}

    {If this is the history file, or they do not have read access,
     then we want to set the files to read only.}

  If not ModifyAccessAllowed(FormAccessRights)
    then
      begin
        MainTable.ReadOnly := True;
        InsertButton.Enabled := False;
        DeleteButton.Enabled := False;
        SaveButton.Enabled := False;
        RefreshButton.Enabled := False;

      end;  {If (GlblTaxYearFlg = 'History')}

  OpenTablesForForm(Self, GlblProcessingType);

  Inserting := False;

    {Prevent the tax roll year and description from showing in
     the grid.}

  MainTable.FieldByName('TaxRollYr').Visible := False;
  MainTable.FieldByName('Description').Visible := False;

    {Make the display width of the main code 1 greater so that it
     fits nicely into the grid.}

  with MainTable.FieldByName('MainCode') do
    DisplayWidth := DisplayWidth + 1;

     {Disable the code edit box. They will only be allowed in
      this field in insert mode.}

  If not MainCodeEdit.ReadOnly
    then
      begin
        MainCodeEdit.ReadOnly := True;
        MainCodeEdit.TabStop := False;
        MainCodeEdit.Color := clBtnFace;
      end;

    {Set the properties in the print range dialog to
     match the properties for this maint.}

  PrintRangeDlg.CodeName := MainCodeName;
  PrintRangeDlg.CodeLength := MainTable.FieldByName('MainCode').Size;
  PrintRangeDlg.ShiftRightAddZeroes := SRAZ;

    {Set the title label.}

  TitleLabel.Caption := MainCodeName + ' Code Maintenance';
  TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

  SetStatusBarCaption;

end;  {InitializeForm}

{===================================================================}
Procedure TStructureMaintForm.FormKeyPress(Sender: TObject;
                                        var Key: Char);

{Change carriage return into tab.}

begin
  LastKeyPressed := Key;

  If (Key = #13)
    then
      begin
        Perform(WM_NextDlgCtl, 0, 0);
        Key := #0;
      end;  {If (Key = #13)}

end;  {FormKeyPress}

{===================================================================}
Procedure TStructureMaintForm.MainTableBeforePost(DataSet: TDataset);

var
  ReturnCode : Integer;

begin
  ReturnCode := idYes;
  CancelledPost := False;

  If GlblAskSave
    then
      begin
          {Let's ask confirm whether or not they want to save this
           record. The choices are yes, no, and cancel.
           Yes means save and process whatever they just did.
             (i.e. They made some changes and clicked Print. If
                   they select yes, save the record and then bring
                   up the print dialog box.)

           No means don't save and process whatever they just did.
             (i.e. They made some changes and clicked Print. If
                   they select no, don't save the record and then bring
                   up the print dialog box.)

           Cancel means don't save this record and cancel whatever
             action they just selected. They will be placed where
             they used to be.
             (i.e. They made some changes and clicked Print. If
                   they select cancel, don't save the record and
                   put them back in the description edit field.)}

        case MainTable.State of
          dsInsert : ReturnCode := MessageDlg('Do you want to insert ' + LowerCase(MainCodeName) +
                                              ' code ' +
                                              MainTable.FieldByName('MainCode').Text + '?',
                                              mtConfirmation,
                                              mbYesNoCancel, 0);

          dsEdit : ReturnCode := MessageDlg('Do you want to save ' + LowerCase(MainCodeName) +
                                            ' code ' +
                                            MainTable.FieldByName('MainCode').Text + '?',
                                            mtConfirmation,
                                            mbYesNoCancel, 0);

        end;  {case MainTable.State of}

          {Test the return code.}

        case ReturnCode of
          idNo : If (MainTable.State = dsInsert)
                   then
                     begin
                         {In insert mode, we will cancel this record,
                          which throws away this record. Then we will
                          call Cleanup to restore the form to normal
                          state. Finally, we will call Abort to prevent
                          the post.}

                       MainTable.Cancel;
                       Cleanup;
                       Abort;
                     end
                   else
                     begin
                         {In the edit case, we will call RefreshNoPost
                          which is a procedure in WinUtils which reloads
                          the present record without trying to post first.
                          We do not need to worry about preventing the
                          post from continuing, though, since it will
                          post back the same information now.}

                       RefreshNoPost(MainTable);

                     end;  {idNo : If (MainTable.State = dsInsert)}

          idCancel : begin
                         {In the cancel case, we will put them back in
                          the description edit field, and set a var
                          saying that they cancelled the post. We need
                          to set a variable so when the exception is
                          raised by the Abort to prevent post, we can
                          distinguish the exception as being a cancel
                          answer rather than a "no" answer to the
                          "Do you want to post?" question.}

                       DescriptionEdit.SetFocus;
                       CancelledPost := True;
                       Abort;
                     end;

        end;  {case ReturnCode of}

      end;  {If GlblAskSave}

end;  {MainTableBeforePost}

{===================================================================}
Procedure TStructureMaintForm.MainTableAfterPost(DataSet: TDataset);

{After the post, let's make sure that we set the form back to it's original
 state and reset the vars.}

begin
  Cleanup;
  Inserting := False;
  CancelledPost := False;

end;  {MainTableAfterPost}

{===================================================================}
Procedure TStructureMaintForm.IncrementalSearchEnter(Sender: TObject);

{Whenever they enter the incremental search field, we want to
 make sure that the text displaying in the box matches the
 code of the record that the table points to.}
{Load the field with the present record in the main table.}

var
  Size : Integer;
  TempPChar : PChar;

begin
  If MainTable.Active
    then
      begin
          {Now fill in the buffer for the present main table code.}

        Size := Length(MainTable.FieldByName('MainCode').Text) + 1;
        GetMem(TempPChar, Size);
        StrPCopy(TempPChar, MainTable.FieldByName('MainCode').Text);
        IncrementalSearch.SetTextBuf(TempPChar);
        FreeMem(TempPChar, Size);

        IncrementalSearch.SelectAll;

      end;  {If MainTable.Active}

  If MainTable.ReadOnly
    then StatusBar.Caption := 'Please choose the ' + LowerCase(MainCodeName) +
                              ' code to view.'
    else StatusBar.Caption := 'Please choose the ' + LowerCase(MainCodeName) +
                              ' code to view, edit, or delete.';

end;  {IncrementalSearchEnter}

{===================================================================}
Procedure TStructureMaintForm.IncrementalSearchExit(Sender: TObject);

{Whenever they exit the incremental search field, we want to
 make sure that the text displaying in the box matches the
 code of the record that the table points to.}
{Fill in the buffer with whatever record is pointed to in the file.}

var
  Size : Integer;
  TempPChar : PChar;

begin
    {Now fill in the buffer for the present main table code.}

  Size := Length(MainTable.FieldByName('MainCode').Text) + 1;
  GetMem(TempPChar, Size);
  StrPCopy(TempPChar, MainTable.FieldByName('MainCode').Text);
  IncrementalSearch.SetTextBuf(TempPChar);
  FreeMem(TempPChar, Size);

    {Make sure that we are in edit mode.}

  If not MainTable.ReadOnly
    then MainTable.Edit;

    {Clear the status bar.}

  StatusBar.Caption := '';

end;  {IncrementalSearchExit}

{===================================================================}
Procedure TStructureMaintForm.LookupGridEnter(Sender: TObject);

begin
  SetStatusBarCaption;
end;

{===================================================================}
Procedure TStructureMaintForm.LookupGridExit(Sender: TObject);

begin
  StatusBar.Caption := '';
end;

{===================================================================}
Procedure TStructureMaintForm.MainCodeEditExit(Sender: TObject);

{They just entered a new main code, so let's make sure that it does
 not already exist in the file.}

var
  Found : Boolean;

begin
  If ((ActiveControl.Name <> 'ExitButton') and
      (ActiveControl.Name <> 'InsertButton') and
      (ActiveControl.Name <> 'RefreshButton') and
      (MainTable.State = dsInsert))
    then
      If (Deblank(MainCodeEdit.Text) = '')
        then
          begin
            MessageDlg('Please enter a ' + LowerCase(MainCodeName) +
                       ' code.', mtError, [mbOK], 0);
            MainCodeEdit.SetFocus;
          end
        else
          begin
            Found := False;

              {Do a take to make sure it is the
               correct length, and a shift right add zeroes
               if we need it.}

            MainCodeEdit.Text := Take(MainTable.FieldByName('MainCode').Size, MainCodeEdit.Text);

            If SRAZ
              then MainCodeEdit.Text := ShiftRightAddZeroes(MainCodeEdit.Text);

            try
              Found := FindKeyOld(LookupTable, ['MainCode'],
                                  [MainCodeEdit.Text]);
            except
              If not LookupTable.EOF
                then SystemSupport(003, MainTable, 'Error looking up ' + LowerCase(MainCodeName) +
                                   ' table record.', UnitName, GlblErrorDlgBox);
            end;

            If Found
              then
                begin
                  MessageDlg(MainCodeName + ' code ' + MainCodeEdit.Text +
                             ' already exists.' + #13 +
                             'Please enter a different code.', mtError, [mbOK], 0);
                  MainCodeEdit.SetFocus;
                  Abort;

                end;  {If Found}

          end;  {else of If (Deblank(MainCodeEdit.Text) = '')}

end;  {MainCodeEditExit}

{===================================================================}
Procedure TStructureMaintForm.MeasureCodesGroupBoxEnter(Sender: TObject);

{Reset the LastKeyPressed var. since we are only interested in key presses
 within the description edit.}

begin
  LastKeyPressed := ' ';
end;  {MeasureCodesGroupEnter}

{===================================================================}
Procedure TStructureMaintForm.MeasureCodesGroupBoxExit(Sender: TObject);

{On exit of the last field, we will try to post the record.
 The only time that we will actually check this is when they
 have hit enter or tab on the last field. The way that we can tell
 is if there are any messages in the message queue for mouse
 events.

 Thus, we will not try to post if they have gone to a different
 edit box. Also, we will not post here if they clicked on any
 of the buttons. The post is done within the buttons in this case,
 so that all processing for that button click is processed.}

var
  ButtonClicked : Boolean;

begin
    {It matters to us whether or not the person is exiting the description field
     by hitting tab or enter versus clicking a button. We can easily tell if they are
     exiting due to a click on a button other than the InsertButton by looking at the
     ActiveControl of the form - it will be the button that they just clicked on.
     The problem is if they are in the description field and click the insert button.
     The ActiveControl says InsertButton, but this is the case if they hit tab or
     enter. To tell the difference, we are tracking the last key pressed in the
     OnKeyPress event of the form. If the last key pressed was enter or tab, than
     we know that they did not click on the InsertButton. Otherwise, we know that they
     did. The reason that this is important is that we want to do all post processing
     within the OnClick event for the buttons in order to properly handle the
     cases of Yes\No\Cancel and continue the event of the button. To give an example,
     if we did not take this approach, and they clicked on the PrintButton and there
     were changes, we would try to post below in the OnExit of the description field.
     If they answered no, we would get an exception (thrown away) in the BeforePost,
     and the print would not be processed. By doing the processing within the OnClick
     of the button (i.e. PrintButton), we can handle the exception there and print
     anyway.

     To keep the LastKeyPressed synchronized, it is set to blank every time that they
     enter the description field to avoid spurious key presses from getting in the way.}

  ButtonClicked := not (LastKeyPressed in [#13, #9]);

  If (MainTable.Modified and
      (ActiveControl.Name = 'InsertButton') and
      (not ButtonClicked))
    then
      try
        MainTable.Post;
      except
        If RecordIsLocked(MainTable)
          then MeasureCodesGroupBox.SetFocus
          else
            begin
              MeasureCodesGroupBox.SetFocus;

                {Sometimes, if the person cancels or says they
                 do not want to post, we can get an exception with
                 an error code 0 or 9, and we want to ignore them.}

              If not MainTable.EOF
                then SystemSupport(005, MainTable, 'Error attempting to post.',
                                   UnitName, GlblErrorDlgBox);

            end;  {If RecordIsLocked(MainTable)}

      end;  {except}

end;  {MeasureCodesGroupExit}

{===================================================================}
Procedure TStructureMaintForm.InsertButtonClick(Sender: TObject);

{Put the table into insert state. If the table is modified, then save
 the information first.}

begin
    {First save any unposted information.}

  If MainTable.Modified
    then
      try
        MainTable.Post;
      except
        If not RecordIsLocked(MainTable)
          then
            begin
              DescriptionEdit.SetFocus;

                {If the person cancels or says they
                 do not want to post, we can get an exception with
                 an error code 0 or 9, and we want to ignore them.}

              If not MainTable.EOF
                then SystemSupport(004, MainTable, 'Error attempting to post.',
                                   UnitName, GlblErrorDlgBox);

            end;  {If RecordIsLocked(MainTable)}

      end;  {except}

    {Set the variable saying that we are now in insert state.}

  Inserting := True;

    {Now insert a new record.}

  try
    MainTable.Append;
  except
    SystemSupport(006, MainTable, 'Error putting ' + LowerCase(MainCodeName) +
                  ' table in insert state.', UnitName,
                  GlblErrorDlgBox);
  end;

    {Set the tax year to blank since for now we are not using it - code tables
     are year independent.}

  MainTable.FieldByName('TaxRollYr').Text := Take(4, '');

    {Make sure that they can get into the main code edit box
     to edit the field.}

  MainCodeEdit.ReadOnly := False;
  MainCodeEdit.TabStop := True;
  MainCodeEdit.Color := clWindow;
  MainCodeEdit.SetFocus;

     {Turn on the labels which prompt the person to enter a new code.}

  InsertLabel1.Visible := True;
  InsertLabel2.Visible := True;

    {Turn off the delete button.}

  DeleteButton.Enabled := False;

end;  {InsertButtonClick}

{===================================================================}
Procedure TStructureMaintForm.DeleteButtonClick(Sender: TObject);

begin
  If (MessageDlg('Do you want to delete ' + LowerCase(MainCodeName) +
                 ' code ' + MainTable.FieldByName('MainCode').Text + '?',
                 mtConfirmation,
                 [mbYes, mbNo], 0) = idYes)
    then
      begin
        try
          MainTable.Delete;
        except
          SystemSupport(007, MainTable, 'Error deleting ' + LowerCase(MainCodeName) +
                        ' table record.', UnitName, GlblErrorDlgBox);
        end;

      end  {If (MessageDlg('Do you want to delete code ' + ...}
    else DescriptionEdit.SetFocus;

end;  {DeleteButtonClick}

{===================================================================}
Procedure TStructureMaintForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  ExceptionRaised : Boolean;

begin
  ExceptionRaised := False;

    {First check to see if they need to post any changes.}

  If MainTable.Modified
    then
      try
        MainTable.Post;
      except
          {If they cancelled the post, then we want to
           make sure that we do not process the print.
           Otherwise, they said no to the post, so we still
           want to print.

           Note that the ReportFiler and ReportPrinter components
           share event handlers, so that a call to the
           execute method of ReportPrinter and ReportFiler both
           execute the same code, and no further direct reference
           to the ReportFiler or ReportPrinter components is
           need after calling their Execute method.}

        If CancelledPost
          then ExceptionRaised := True;

        If not RecordIsLocked(MainTable)
          then
            begin
              DescriptionEdit.SetFocus;

                {If the person cancels or says they
                 do not want to post, we can get an exception with
                 an error code 0 or 9, and we want to ignore them.}

              If not MainTable.EOF
                then SystemSupport(008, MainTable, 'Error attempting to post.',
                                   UnitName, GlblErrorDlgBox);

            end;  {If RecordIsLocked(MainTable)}

      end;  {except}

    {Now do the actual printing. To do this, we will first
     execute the print range dialog to let them select the
     range that they want to print and the printer.}

  If not ExceptionRaised
    then
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
        else DescriptionEdit.SetFocus

    else DescriptionEdit.SetFocus;

end;  {PrintButtonClick}

{==================================================================================}
Procedure TStructureMaintForm.SaveButtonClick(Sender: TObject);

begin
  If MainTable.Modified
    then
      try
        MainTable.Post;
      except
        If not RecordIsLocked(MainTable)
          then
            begin
              DescriptionEdit.SetFocus;

                {If the person cancels or says they
                 do not want to post, we can get an exception with
                 an error code 0 or 9, and we want to ignore them.}

              If not MainTable.EOF
                then SystemSupport(009, MainTable, 'Error attempting to post.',
                                   UnitName, GlblErrorDlgBox);

            end;  {If RecordIsLocked(MainTable)}

      end;  {except}

  DescriptionEdit.SetFocus;

end;  {SaveButtonClick}

{===================================================================}
Procedure TStructureMaintForm.RefreshButtonClick(Sender: TObject);

{Do they want to throw away any changes that they just made. If
 they are in insert mode, this means that the whole record will
 be thrown away.}

var
  ReturnCode : Integer;

begin
  If MainTable.Modified
    then
      begin
        ReturnCode := MessageDlg('Do you want to discard changes to '
                                 + LowerCase(MainCodeName) + ' code ' +
                                 MainTable.FieldByName('MainCode').Text + '?',
                                 mtConfirmation,
                                 [mbYes, mbNo], 0);

        case ReturnCode of
          idNo : DescriptionEdit.SetFocus;

          idYes : begin
                    try
                        {If they are in the middle of an insert, then we just
                         want to cancel what they are doing. Otherwise,
                         we want to refresh without a post
                         (i.e. reload).}

                      If (MainTable.State = dsInsert)
                        then MainTable.Cancel
                        else RefreshNoPost(MainTable);
                    except
                      SystemSupport(010, MainTable, 'Error posting ' + LowerCase(MainCodeName) +
                                    ' table record.', UnitName,
                                    GlblErrorDlgBox);
                    end;

                    Cleanup;

                  end;  {idYes : begin}

        end;  {case ReturnCode of}

      end;  {If MainTable.Modified}

end;  {RefreshButtonClick}

{===================================================================}
Procedure TStructureMaintForm.ExitButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TStructureMaintForm.FormCloseQuery(    Sender: TObject;
                                          var CanClose: Boolean);

{If there are any changes, let's ask them if they want to save
 them (or cancel).}

var
  CancelClose, IgnoreException : Boolean;

begin
    {First see if anything needs to be saved.}

  If ((not MainTable.ReadOnly) and
      MainTable.Modified)
    then
      try
        MainTable.Post;
      except
        If not RecordIsLocked(MainTable)
          then
            begin
              DescriptionEdit.SetFocus;
              CancelClose := False;
              IgnoreException := False;

                {An exception will be raised in the following
                 cases:
                   1. The person is in insert mode, and they
                      answered "cancel" to "Do you want to post?".
                      In this case, we want to prevent the close.

                   2. The person is in insert mode, and they
                      answered "no" to "Do you want to post?".
                      In this case, we want to ignore the exception
                      and close anyway.

                   3. The person is in edit mode, and they
                      answered "cancel" to "Do you want to post?".
                      In this case, we want to prevent the close.

                    Note that we make use of the variables Inserting
                    and CancelledPost which are set when the person
                    clicks Add and answers "Cancel", respectively.

                    We need the Inserting variable because once the Post
                    is Aborted in either Insert or Edit mode, the state of the
                    table is set to Browse. So, in order to know what state
                    the table was in before the call to post, we need
                    to set this variable.

                    We need the CancelledPost variable because this is the
                    only way we have of knowing if the person answered
                    "Cancel" to "Do you want to post?"}

              If Inserting
                then
                  If CancelledPost
                    then CancelClose := True  {Case 1}
                    else IgnoreException := True;  {Case 2}

                {Case 3}

              If not Inserting
                then CancelClose := True;

                {If they cancelled the close, then we want to make
                 sure that we do not close (set Action to caNone)
                 and abort out of this exit handler before any
                 of the closes are done.}

              If CancelClose
                then CanClose := False;

                {If we did not set IgnoreException or CancelClose,
                 then this was a real BTrieve error.}

              If not (IgnoreException or CancelClose)
                then SystemSupport(011, MainTable, 'Error attempting to post.',
                                   UnitName, GlblErrorDlgBox);

            end;  {If RecordIsLocked(MainTable)}

      end;  {except}

end;  {FormCloseQuery}

{===================================================================}
Procedure TStructureMaintForm.FormClose(    Sender: TObject;
                                     var Action: TCloseAction);

{Note that if we get here, we are definately closing the form
 since the CloseQuery event is called first. In CloseQuery, if
 there are any modifications, they have a chance to cancel
 then.}

begin
    {Make sure that we close the tables.}

  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


{=============================================================================}
{===============   PRINTING LOGIC  ===========================================}
{=============================================================================}
Procedure TStructureMaintForm.ReportPrinterBeforePrint(Sender: TObject);

var
  TempStr : String;

begin
  with Sender as TBaseReport do
    begin
      TempStr := Name;
      MarginTop := 1.25;
      MarginBottom := 0.75;

         {Get the first record. Note that we have to take the
          tax year into account.}

         {FXX06291999-4: Having the TaxRollYr as the first part of the key in the
                         FindNearest messed up the range.}

      LookupTable.IndexName := 'ByMainCode';

      try
        If PrintRangeDlg.PrintAllCodes
          then LookupTable.First
          else FindNearestOld(LookupTable, ['MainCode'],
                              [PrintRangeDlg.StartRange]);

      except
        If LookupTable.EOF
          then MessageDlg('There are no ' + LowerCase(MainCodeName) +
                          ' codes to print in the specified range.',
                          mtInformation, [mbOK], 0)
          else SystemSupport(012, LookupTable, 'Error getting first ' + LowerCase(MainCodeName) +
                             ' table record.', UnitName, GlblErrorDlgBox);
      end;

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterBeforePrint}

{=============================================================================}
Procedure TStructureMaintForm.ReportPrinterPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

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
      PrintCenter(MainCodeName + ' Codes Listing', (PageWidth / 2));
      SetFont('Times New Roman', 12);
      CRLF;
      CRLF;

         {Code tables are now year independent so we do not want to print the
          tax year.}

      (*Println('Tax Year: ' + GetTaxRlYr + ' (' +
              ConvertYearBeingProcessedToText + ')');*)
      Print('For Codes: ');

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
      Home;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      Bold := True;

      ClearTabs;
      SetTab(5.5, pjCenter, 1.8, 0, BOXLINENONE, 0);   {Measure code title}
      Println(#9 + 'Valid Measure Codes');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {Main code}
      SetTab(2.0, pjCenter,  3.0, 0, BOXLINEBOTTOM, 0);   {Description}
      SetTab(5.5, pjCenter,  0.4, 0, BOXLINEBOTTOM, 0);   {MC1}
      SetTab(6.0, pjCenter,  0.4, 0, BOXLINEBOTTOM, 0);   {MC2}
      SetTab(6.5, pjCenter,  0.4, 0, BOXLINEBOTTOM, 0);   {MC3}
      SetTab(7.0, pjCenter,  0.4, 0, BOXLINEBOTTOM, 0);   {MC4}

      Print(#9 + 'Code');
      Print(#9 + 'Description');
      Print(#9 + '1');
      Print(#9 + '2');
      Print(#9 + '3');
      Println(#9 + '4');

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrintHeader}

{=============================================================================}
Function TStructureMaintForm.ReportPrinterPrintPage(    Sender: TObject;
                                                  var PageNum: Integer): Boolean;

var
  DoneWithReport,
  DoneWithPage : Boolean;

begin
  DoneWithPage := False;
  DoneWithReport := False;

  with Sender as TBaseReport do
    begin
      Bold := False;

        {Set up the tabs for the info.}

      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.3, pjLeft, 1.5, 0.1, BOXLINENONE, 0);  {Code}
      SetTab(2.0, pjLeft,  3.0, 0, BOXLINENONE, 0);    {Description}
      SetTab(5.5, pjCenter,  0.4, 0, BOXLINENONE, 0);   {MC1}
      SetTab(6.0, pjCenter,  0.4, 0, BOXLINENONE, 0);   {MC2}
      SetTab(6.5, pjCenter,  0.4, 0, BOXLINENONE, 0);   {MC3}
      SetTab(7.0, pjCenter,  0.4, 0, BOXLINENONE, 0);   {MC4}

      repeat
           {Print the present record.}

        Print(#9 + LookupTable.FieldByName('MainCode').Text);   {Code}
        Print(#9 + LookupTable.FieldByName('Description').Text); {Description}

          {Put an X if this measure codes applies.}

        If LookupTable.FieldByName('CanUseMC1').AsBoolean
          then Print(#9 + 'X') {MC1}
          else Print(#9);

        If LookupTable.FieldByName('CanUseMC2').AsBoolean
          then Print(#9 + 'X') {MC2}
          else Print(#9);

        If LookupTable.FieldByName('CanUseMC3').AsBoolean
          then Print(#9 + 'X') {MC3}
          else Print(#9);

        If LookupTable.FieldByName('CanUseMC4').AsBoolean
          then Println(#9 + 'X') {MC4}
          else Println(#9);

          {Update the status bar.}
        StatusBar.Caption := 'Printing Code: ' + LookupTable.FieldByName('MainCode').Text;
        StatusBar.Repaint;

        try
          LookupTable.Next;
        except
          SystemSupport(013, LookupTable, 'Error getting next code.', UnitName,
                        GlblErrorDlgBox);
        end;

          {If we have printed all the records, then we are done.}

        If LookupTable.EOF
          then DoneWithReport := True;

          {Make sure that we are not past the end of the range.}

        with PrintRangeDlg do
          If ((not (PrintAllCodes or PrintToEndOfCodes)) and
              (LookupTable.FieldByName('MainCode').AsString > EndRange))
            then DoneWithReport := True;

          {If there is only one line left to print, then we
           want to go to the next page.}

        If (LinesLeft = 1)
          then DoneWithPage := True;

      until (DoneWithPage or DoneWithReport);

        {We are done printing the report if we have gone through all the codes.}

      Result := not DoneWithReport; {False = stop}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrintPage}

{==============================================================================}
Procedure TStructureMaintForm.ReportPrinterAfterPrint(Sender: TObject);

begin
  StatusBar.Caption := '';
end;


end.