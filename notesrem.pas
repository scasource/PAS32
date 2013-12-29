unit Notesrem;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, RPFiler, RPBase, RPCanvas, RPrinter,
  Printrng, RPMemo, RPDBUtil, Gauges, RPDefine, ComCtrls(*, Progress*);

type
  TNotesReminderDialog = class(TForm)
    OKBtn: TBitBtn;
    Label1: TLabel;
    NotesDataSource: TwwDataSource;
    NotesTable: TwwTable;
    NotesTableDisplaySwisSBLKey: TStringField;
    NotesTableDateEntered: TDateField;
    NotesTableTransactionCode: TStringField;
    NotesTableDueDate: TDateField;
    NotesTableNote: TMemoField;
    NotesTableSwisSBLKey: TStringField;
    NotesTableUserResponsible: TStringField;
    NotesTableNoteTypeCode: TStringField;
    NotesTableNoteOpen: TBooleanField;
    PrintButton: TBitBtn;
    CreateParcelList: TBitBtn;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    NotesTableTimeEntered: TTimeField;
    NotesTableNoteNumber: TSmallintField;
    NotesTableEnteredByUserID: TStringField;
    NotesTableTransactionDesc: TStringField;
    NotesTableNoteTypeDesc: TStringField;
    Label2: TLabel;
    NotesPageControl: TPageControl;
    RegularNotesTabSheet: TTabSheet;
    NotesGrid: TwwDBGrid;
    RegularNotesNavigator: TDBNavigator;
    SmallClaimsTabSheet: TTabSheet;
    CertiorariNotesTabSheet: TTabSheet;
    CertiorariNotesNavigator: TDBNavigator;
    CertiorariNotesGrid: TwwDBGrid;
    CertiorariNotesTable: TwwTable;
    CertiorariNotesDataSource: TwwDataSource;
    CertiorariNotesTableSwisSBLKey: TStringField;
    CertiorariNotesTableDateEntered: TDateField;
    CertiorariNotesTableTimeEntered: TDateTimeField;
    CertiorariNotesTableNoteNumber: TIntegerField;
    CertiorariNotesTableEnteredByUserID: TStringField;
    CertiorariNotesTableTransactionDesc: TStringField;
    CertiorariNotesTableTransactionCode: TStringField;
    CertiorariNotesTableNoteTypeDesc: TStringField;
    CertiorariNotesTableNoteTypeCode: TStringField;
    CertiorariNotesTableDueDate: TDateField;
    CertiorariNotesTableUserResponsible: TStringField;
    CertiorariNotesTableNoteOpen: TBooleanField;
    CertiorariNotesTableNote: TMemoField;
    CertiorariNotesTableDisplaySwisSBLKey: TStringField;
    SmallClaimsNotesTab: TTabSheet;
    SmallClaimsNotesGrid: TwwDBGrid;
    SmallClaimsNotesNavagator: TDBNavigator;
    SmallClaimsNotesDataSource: TwwDataSource;
    SmallClaimsNotesTable: TwwTable;
    StringField1: TStringField;
    DateField1: TDateField;
    StringField2: TStringField;
    DateField2: TDateField;
    BooleanField1: TBooleanField;
    MemoField1: TMemoField;
    StringField3: TStringField;
    DateTimeField1: TDateTimeField;
    IntegerField1: TIntegerField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    procedure OKBtnClick(Sender: TObject);
    procedure NotesTableCalcFields(DataSet: TDataset);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReportPrint(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure CreateParcelListClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    Procedure SetFilter(NotesTable : TwwTable);
  end;

var
  NotesReminderDialog: TNotesReminderDialog;

implementation

uses Utilitys, PASUTILS, UTILEXSD,  GlblCnst, Glblvars, WinUtils, PASTypes,
     PREVIEW, Prog, PRCLLIST;

{$R *.DFM}

{================================================================}
Procedure SetReadOnlyFields(NotesTable : TTable);

var
  I : Integer;

begin
    {CHG05112001-1: Allow them to click off the open on the due reminder.}

  with NotesTable do
    For I := 0 to (FieldCount - 1) do
      Fields[I].ReadOnly := True;

  NotesTable.FieldByName('NoteOpen').ReadOnly := False;

end;  {SetReadOnlyFields}

{================================================================}
Procedure SetCaption(NotesTable : TTable;
                     TabSheet : TTabSheet;
                     Caption : String);

begin
  TabSheet.Caption := Caption + ' (' + IntToStr(NotesTable.RecordCount) + ')';
end;  {SetCaption}

{=====================================================================}
Procedure TNotesReminderDialog.SetFilter(NotesTable : TwwTable);

const
  DblQuote = '"';

begin
  NotesTable.wwFilter.Clear;
  NotesTable.IndexDefs.Update;

  If _Compare(NotesTable.IndexDefs.Count, 0, coEqual)
    then NotesTable.wwFilter.Add('UserResponsible = ' + FormatwwFilterString(GlblUserName))
    else
      begin
        NotesTable.IndexName := 'BYUSER_DUEDATE_SBL_NOTENUM';

        SetRangeOld(NotesTable,
                    ['UserResponsible', 'DueDate', 'SwisSBLKey', 'NoteNumber'],
                    [Take(10, GlblUserName), '', '', ''],
                    [Take(10, GlblUserName), '1/1/3000', '', '']);

      end;  {else of If _Compare(NotesTable...}

  with NotesTable do
    begin
      wwFilter.Add('NoteTypeCode = "T"');
      wwFilter.Add('NoteOpen = True');
      wwFilter.Add('DueDate <= ' + DblQuote + DateToStr(Date) + DblQuote);
      FilterActivate;

    end;  {with NotesTable do}

end;  {SetFilter}

{================================================================}
Procedure TNotesReminderDialog.FormShow(Sender: TObject);

var
  Continue : Boolean;

begin
  UnitName := 'NOTESREM';

  try
    NotesTable.Open;
  except
    SystemSupport(003, NotesTable, 'Error opening notes table.',
                  UnitName, GlblErrorDlgBox);
  end;

  SetFilter(NotesTable);
  SetCaption(NotesTable, RegularNotesTabSheet, 'Regular');
  SetReadOnlyFields(NotesTable);

    {CHG11172003-2(2.07k): Display small claims and cert notes.}

  If (GlblUsesGrievances and
      GlblCanSeeCertNotes)
    then
      begin
        Continue := True;

        try
          CertiorariNotesTable.Open;
        except
          Continue := False;
          SystemSupport(002, CertiorariNotesTable, 'Error opening certiorari notes table.',
                        UnitName, GlblErrorDlgBox);

        end;

        If Continue
          then
            begin
              SetFilter(CertiorariNotesTable);
              SetCaption(CertiorariNotesTable, CertiorariNotesTabSheet, 'Certiorari');
              SetReadOnlyFields(CertiorariNotesTable);

            end;  {If Continue}

      end
    else CertiorariNotesTabSheet.TabVisible := False;

    if GlblUsesGrievances
    then
      begin
        Continue := True;

        try
          SmallClaimsNotesTable.Open;
        except
          Continue := False;
          SystemSupport(002, SmallClaimsNotesTable, 'Error opening certiorari notes table.',
                        UnitName, GlblErrorDlgBox);

        end;

        If Continue
          then
            begin
              SetFilter(SmallClaimsNotesTable);
              SetCaption(SmallClaimsNotesTable, SmallClaimsNotesTab, 'Small Claims');
              SetReadOnlyFields(SmallClaimsNotesTable);

            end;  {If Continue}

      end
    else SmallClaimsNotesTab.TabVisible := False;

    {CHG11132013(MPT): Add Small Claims Notes table to reminder dialogue}

end;  {FormShow}

{===================================================================}
Procedure TNotesReminderDialog.NotesTableCalcFields(DataSet: TDataset);

begin
  with DataSet do
    FieldByName('DisplaySwisSBLKey').Text := ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text);

end;

{CHG07211999-2: Allow print or create parcel list for overdue notes.}

{===================================================================}
Procedure TNotesReminderDialog.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  Quit : Boolean;

begin
  Quit := False;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

        If not Quit
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

            end;  {If not Quit}

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{===================================================================}
Procedure TNotesReminderDialog.ReportPrintHeader(Sender: TObject);

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
      SetFont('Arial',14);
      Underline := True;
      Home;
      CRLF;
      PrintCenter('Overdue Notes Report', (PageWidth / 2));
      SetFont('Times New Roman', 12);
      CRLF;
      CRLF;

      SectionTop := 1.0;

        {Print column headers.}

      CRLF;
      CRLF;
      Home;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('Times New Roman', 10);
      Bold := True;
      ClearTabs;
      SetTab(0.4, pjCenter, 1.4, 0, BOXLINEBOTTOM, 0);   {SBL}
      SetTab(1.85, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Date Entered}
      SetTab(2.70, pjCenter, 0.3, 0, BOXLINEBOTTOM, 0);   {Note Number}
      SetTab(3.1, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {User}
      SetTab(4.2, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {Xact Cd}
      SetTab(5.3, pjCenter, 0.3, 0, BOXLINEBOTTOM, 0);   {Note Type}
      SetTab(5.7, pjCenter, 0.8, 0, BOXLINEBOTTOM, 0);   {Date due}
      SetTab(6.6, pjCenter, 1.0, 0, BOXLINEBOTTOM, 0);   {User responsible}
      SetTab(7.7, pjCenter, 0.3, 0, BOXLINEBOTTOM, 0);   {Open?}

      Println(#9 + 'Parcel ID' +
              #9 + 'Date Ent' +
              #9 + 'Num' +
              #9 + 'User' +
              #9 + 'Xact Cd' +
              #9 + 'Note' +
              #9 + 'Date Due' +
              #9 + 'Responsible' +
              #9 + 'Open?');
      Println('');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{=========================================================================}
Procedure PrintOneNoteRecord(Sender : TObject;
                             NotesTable : TTable);
var
  DBMemoBuf: TDBMemoBuf;

begin
  with Sender as TBaseReport, NotesTable do
    begin
      Print(#9 + ConvertSwisSBLToDashDot(FieldByName('SwisSBLKey').Text) +
            #9 + FieldByName('DateEntered').Text +
            #9 + FieldByName('NoteNumber').Text +
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
      DBMemoBuf.Field := TMemoField(NotesTable.FieldByName('Note'));

      DBMemoBuf.PrintStart := 0.5;
      DBMemoBuf.PrintEnd := 7.9;

      PrintMemo(DBMemoBuf, 0, False);
      DBMemoBuf.Free;
      Println('');

    end;  {with NotesTable do}

end;  {PrintOneNoteRecord}

{=========================================================================}
Procedure TNotesReminderDialog.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  NotesTable.First;

  with Sender as TBaseReport do
    begin
      Bold := False;

        {Set up the tabs for the info.}

      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.4, pjLeft, 1.4, 0, BoxLineNone, 0);   {SBL}
      SetTab(1.85, pjLeft, 0.8, 0, BoxLineNone, 0);   {Date Entered}
      SetTab(2.7, pjLeft, 0.3, 0, BoxLineNone, 0);   {Note Number}
      SetTab(3.1, pjLeft, 1.0, 0, BoxLineNone, 0);   {User}
      SetTab(4.2, pjLeft, 1.0, 0, BoxLineNone, 0);   {Xact Cd}
      SetTab(5.3, pjLeft, 0.3, 0, BoxLineNone, 0);   {Note Type}
      SetTab(5.7, pjLeft, 0.8, 0, BoxLineNone, 0);   {Date due}
      SetTab(6.6, pjLeft, 1.0, 0, BoxLineNone, 0);   {User responsible}
      SetTab(7.7, pjCenter, 0.3, 0, BoxLineNone, 0);   {Open?}

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else NotesTable.Next;

        If NotesTable.EOF
          then Done := True;

        If not Done
          then PrintOneNoteRecord(Sender, NotesTable);

        If (LinesLeft < 5)
          then NewPage;

      until Done;

      If CertiorariNotesTable.Active
        then
          begin
            Println('');
            Bold := True;
            Underline := True;
            Println(#9 + 'Certiorari:');
            Bold := False;
            Underline := False;

            Done := False;
            FirstTimeThrough := True;
            CertiorariNotesTable.First;

            repeat
              If FirstTimeThrough
                then FirstTimeThrough := False
                else CertiorariNotesTable.Next;

              If CertiorariNotesTable.EOF
                then Done := True;

              If not Done
                then PrintOneNoteRecord(Sender, CertiorariNotesTable);

              If (LinesLeft < 5)
                then NewPage;

            until Done;

          end;  {If CertiorariNotesTable.Active}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{================================================================}
Procedure TNotesReminderDialog.CreateParcelListClick(Sender: TObject);

var
  FirstTimeThrough, Done : Boolean;

begin
  FirstTimeThrough := True;
  Done := False;
  ParcelListDialog.ClearParcelGrid(True);
  NotesTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else NotesTable.Next;

    If NotesTable.EOF
      then Done := True;

    If not Done
      then ParcelListDialog.AddOneParcel(NotesTable.FieldByName('SwisSBLKey').Text);

  until Done;

  If CertiorariNotesTable.Active
    then
      begin
        FirstTimeThrough := True;
        Done := False;
        CertiorariNotesTable.First;

        repeat
          If FirstTimeThrough
            then FirstTimeThrough := False
            else CertiorariNotesTable.Next;

          If CertiorariNotesTable.EOF
            then Done := True;

          If not Done
            then ParcelListDialog.AddOneParcel(CertiorariNotesTable.FieldByName('SwisSBLKey').Text);

        until Done;

      end;  {If CertiorariNotesTable.Active}

  ParcelListDialog.Show;

end;  {CreateParcelListClick}

{================================================================}
Procedure TNotesReminderDialog.OKBtnClick(Sender: TObject);

begin
  Close;
end;

{=========================================================================}
Procedure TNotesReminderDialog.FormClose(    Sender: TObject;
                                         var Action: TCloseAction);

begin
  If (NotesTable.State = dsEdit)
    then NotesTable.Post;

  NotesTable.Close;

end;  {FormClose}


end.