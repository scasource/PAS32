unit pNotes_New;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, RPFiler, RPBase, RPCanvas, RPrinter,
  Printrng, RPMemo, RPDBUtil, RPDefine, Progress, wwMemo, ComCtrls;

type
  TNotes_NewForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    InactiveLabel: TLabel;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    AssessmentYearControlTable: TTable;
    OldParcelIDLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    FooterPanel: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel4: TPanel;
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
    MainListView: TListView;
    NewButton: TBitBtn;
    DeleteButton: TBitBtn;
    SetFocusTimer: TTimer;
    MainQuery: TQuery;
    PrintDialog: TPrintDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrinterPrintHeader(Sender: TObject);
    procedure ReportFilerPrint(Sender: TObject);
    procedure SetFocusTimerTimer(Sender: TObject);
    procedure MainListViewClick(Sender: TObject);
    procedure MainListViewKeyPress(Sender: TObject; var Key: Char);
    procedure NewButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure MainListViewCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure MainListViewColumnClick(Sender: TObject;
      Column: TListColumn);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    TaxRollYr, SwisSBLKey : String;
    ProcessingType, ColumnToSort : Integer;  {NextYear, ThisYear, History}

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    Procedure FillInMainListView;
    Procedure ShowSubform(_SwisSBLKey : String;
                          _NoteNumber : Integer;
                          _EditMode : String);
    Procedure InitializeForm;
  end;

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, Utilitys,
     GlblCnst, DataAccessUnit, PNotes_New_Subform,
     Preview;  {Report preview form}

{$R *.DFM}

{=====================================================================}
Procedure TNotes_NewForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{====================================================================}
Procedure TNotes_NewForm.SetFocusTimerTimer(Sender: TObject);

begin
  SetFocusTimer.Enabled := False;
  MainListView.SetFocus;
  SelectListViewItem(MainListView, 0);

end;  {SetFocusTimerTimer}

{====================================================================}
Procedure TNotes_NewForm.MainListViewCompare(    Sender : TObject;
                                                 Item1,
                                                 Item2 : TListItem;
                                                 Data : Integer;
                                             var Compare : Integer);

var
  Index, Int1, Int2 : Integer;

begin
  If _Compare(ColumnToSort, 0, coEqual)
    then
      begin
        try
          Int1 := StrToInt(Item1.Caption);
        except
          Int1 := 0;
        end;

        try
          Int2 := StrToInt(Item2.Caption);
        except
          Int2 := 0;
        end;

        If _Compare(Int1, Int2, coLessThan)
          then Compare := -1;

        If _Compare(Int1, Int2, coEqual)
          then Compare := 0;

        If _Compare(Int1, Int2, coGreaterThan)
          then Compare := 1;

      end
    else
      begin
        Index := ColumnToSort - 1;
        Compare := CompareText(Item1.SubItems[Index], Item2.SubItems[Index]);
      end;

end;  {MainListViewCompare}

{====================================================================}
Procedure TNotes_NewForm.MainListViewColumnClick(Sender : TObject;
                                                 Column : TListColumn);
begin
  ColumnToSort := Column.Index;
  (Sender as TCustomListView).AlphaSort;
end;

{====================================================================}
Procedure LoadDataForParcel(MainQuery : TQuery;
                            SwisSBLKey : String);

begin
  MainQuery.SQL.Clear;
  MainQuery.SQL.Add('Select * from PNotesRec');
  MainQuery.SQL.Add('where SwisSBLKey = ' + '''' + SwisSBLKey + '''');
  MainQuery.SQL.Add('Order by NoteNumber');
  MainQuery.Open;

end;  {LoadDataForParcel}

{====================================================================}
Procedure TNotes_NewForm.FillInMainListView;

begin
  LoadDataForParcel(MainQuery, SwisSBLKey);

  FillInListView(MainListView, MainQuery,
                 ['NoteNumber', 'DateEntered', 'TimeEntered', 'EnteredByUserID',
                  'TransactionCode', 'NoteTypeCode', 'DueDate', 'UserResponsible',
                  'NoteOpen', 'Note'],
                 True, False);

  MainListViewColumnClick(MainListView, MainListView.Columns[0]);

end;  {FillInMainListView}

{====================================================================}
Procedure TNotes_NewForm.InitializeForm;

var
  Found : Boolean;

begin
  UnitName := 'PNotes_New';

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
        If ((not ModifyAccessAllowed(FormAccessRights)) or
            _Compare(EditMode, emBrowse, coEqual))
          then
            begin
              NewButton.Enabled := False;
              DeleteButton.Enabled := False;
            end;

        OpenTablesForForm(Self, ProcessingType);

        Found := _Locate(ParcelTable, [TaxRollYr, SwisSBLKey], '', [loParseSwisSBLKey]);

        If not Found
          then SystemSupport(001, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        TitleLabel.Caption := 'Notes';
        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        YearLabel.Caption := GetTaxYrLbl;
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        If GlblLocateByOldParcelID
          then SetOldParcelIDLabel(OldParcelIDLabel, ParcelTable,
                                   AssessmentYearControlTable);

        FillInMainListView;

      end;  {If (Deblank(SwisSBLKey) <> '')}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  SetFocusTimer.Enabled := True;

end;  {InitializeForm}

{==============================================================}
Procedure TNotes_NewForm.ShowSubform(_SwisSBLKey : String;
                                     _NoteNumber : Integer;
                                     _EditMode : String);

begin
  try
    NotesEntryDialogForm := TNotesEntryDialogForm.Create(nil);

    NotesEntryDialogForm.InitializeForm(_SwisSBLKey, _NoteNumber, _EditMode);

    If (NotesEntryDialogForm.ShowModal <> idCancel)
      then FillInMainListView;

  finally
    NotesEntryDialogForm.Free;
  end;

end;  {ShowSubform}

{==============================================================}
Procedure TNotes_NewForm.MainListViewClick(Sender: TObject);

var
  NoteNumber : Integer;
  _EditMode : String;

begin
  try
    NoteNumber := StrToInt(GetColumnValueForItem(MainListView, 0, -1));
  except
    NoteNumber := 0;
  end;

  If _Compare(NoteNumber, 0, coGreaterThan)
    then
      begin
        If (ModifyAccessAllowed(FormAccessRights) and
            _Compare(EditMode, emEdit, coEqual))
          then _EditMode := emEdit
          else _EditMode := emBrowse;

        ShowSubform(SwisSBLKey, NoteNumber, _EditMode);
        FillInMainListView;
        SelectListViewItem(MainListView, NoteNumber);

      end;  {If _Compare(NoteNumber, 0, coGreaterThan)}

end;  {MainListViewClick}

{==============================================================}
Procedure TNotes_NewForm.MainListViewKeyPress(    Sender: TObject;
                                              var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        MainListViewClick(Sender);
      end;

end;  {MainListViewKeyPress}

{==============================================================}
Procedure TNotes_NewForm.NewButtonClick(Sender: TObject);

var
  NoteNumber : Integer;

begin
  LoadDataForParcel(MainQuery, SwisSBLKey);

  with MainQuery do
    begin
      First;

      If EOF
        then NoteNumber := 1
        else
          begin
            Last;
            NoteNumber := FieldByName('NoteNumber').AsInteger + 1;
          end;

    end;  {with MainQuery do}

  ShowSubform(SwisSBLKey, NoteNumber, emInsert);
  FillInMainListView;

end;  {NewButtonClick}

{==============================================================}
Procedure TNotes_NewForm.DeleteButtonClick(Sender: TObject);

var
  NoteNumber : Integer;

begin
  try
    NoteNumber := StrToInt(GetColumnValueForItem(MainListView, 0, -1));
  except
    NoteNumber := 0;
  end;

  with MainQuery do
    If _Compare(NoteNumber, 0, coGreaterThan)
      then
        If ((not GlblModifyOthersNotes) and
            _Compare(GlblUserName, 'SUPERVISOR', coNotEqual) and
            _Compare(FieldByName('EnteredByUserID').Text, GlblUserName, coNotEqual) and
            _Compare(FieldByName('UserResponsible').Text, GlblUserName, coNotEqual))
          then MessageDlg('You can not delete another person''s notes.', mtError, [mbOK], 0)
          else
            If (MessageDlg('Do you want to delete note #' + IntToStr(NoteNumber) + '?',
                           mtConfirmation, [mbYes, mbNo], 0) = idYes)
              then
                begin
                  with MainQuery do
                    try
                      SQL.Clear;
                      SQL.Add('Delete from PNotesRec');
                      SQL.Add('where (SwisSBLKey = ' + '''' + SwisSBLKey + '''' + ') and');
                      SQL.Add('(NoteNumber = ' + '''' + IntToStr(NoteNumber) + '''' + ')');
                    except
                    end;

                  MainQuery.ExecSQL;
                  FillInMainListView;

                end;  {If _Compare(NoteNumber, 0, coGreaterThan)}

end;  {DeleteButtonClick}

{==============================================================}
Procedure TNotes_NewForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;

begin
  If PrintDialog.Execute
    then
      If PrintDialog.PrintToFile
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

end;  {PrintButtonClick}

{==============================================================}
Procedure TNotes_NewForm.CloseButtonClick(Sender: TObject);

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
Procedure TNotes_NewForm.FormClose(    Sender: TObject;
                               var Action: TCloseAction);

begin
    {Close all tables here.}

  CloseTablesForForm(Self);
  Action := caFree;

end;  {FormClose}

{=============================================================================}
{===============   PRINTING LOGIC  ===========================================}
{=============================================================================}
Procedure TNotes_NewForm.ReportPrinterPrintHeader(Sender: TObject);

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
Procedure TNotes_NewForm.ReportFilerPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  DBMemoBuf: TDBMemoBuf;

begin
  Done := False;
  FirstTimeThrough := True;
  StatusPanel.Visible := True;
  LoadDataForParcel(MainQuery, SwisSBLKey);
  MainQuery.First;

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
          else MainQuery.Next;

        If MainQuery.EOF
          then Done := True;

        If not Done
          then
            with MainQuery do
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
                DBMemoBuf.Field := TMemoField(MainQuery.FieldByName('Note'));

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

end.
