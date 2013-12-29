unit GBoardDispositionCodesUnit;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, DBGrids,
  Wwkeycb, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Printrng;

type
  TBOARDispositionCodeForm = class(TForm)
    DataSource: TwwDataSource;
    LookupTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    TitleLabel: TLabel;
    PrintRangeDlg: TPrintRangeDlg;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    MainTable: TwwTable;
    IncrementalSearchLabel: TLabel;
    MainCodeLabel: TLabel;
    InsertLabel: TLabel;
    Label11: TLabel;
    CloseButton: TBitBtn;
    InsertButton: TBitBtn;
    DeleteButton: TBitBtn;
    PrintButton: TBitBtn;
    SaveButton: TBitBtn;
    UndoButton: TBitBtn;
    IncrementalSearch: TwwIncrementalSearch;
    MainCodeEdit: TDBEdit;
    EditDescription: TDBEdit;
    DBGrid: TwwDBGrid;
    ResultTypeRadioGroup: TDBRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure InsertButtonClick(Sender: TObject);
    procedure MainTableBeforePost(DataSet: TDataSet);
    procedure MainTableAfterPost(DataSet: TDataSet);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure UndoButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Preview,
     PASTypes;

{$R *.DFM}

const
  CodeName = 'disposition code';
  CodeFieldName = 'Code';

{========================================================}
procedure TBOARDispositionCodeForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TBOARDispositionCodeForm.InitializeForm;

begin
  UnitName := 'GBoardDispositionCodeUnit';  {mmm}

  If (FormAccessRights = raReadOnly)
    then MainTable.ReadOnly := True;  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

  PrintRangeDlg.CodeLength := MainTable.FieldByName(CodeFieldName).DataSize;
  MakeEditReadOnly(MainCodeEdit, MainTable, False, '');
  InsertLabel.Visible := False;

end;  {InitializeForm}

{===================================================================}
Procedure TBOARDispositionCodeForm.FormKeyPress(    Sender: TObject;
                                                var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{============================================================}
Procedure TBOARDispositionCodeForm.MainTableBeforePost(DataSet: TDataSet);

begin
  If (GlblAskSave and
      (MessageDlg('Are you sure you want to save ' + CodeName + ' ' +
                  MainTable.FieldByName(CodeFieldName).Text + '?',
                  mtConfirmation, [mbYes, mbNo], 0) = idNo))
    then Abort;

end;  {MainTableBeforePost}

{===========================================================}
Procedure TBOARDispositionCodeForm.MainTableAfterPost(DataSet: TDataSet);

begin
  MakeEditReadOnly(MainCodeEdit, MainTable, False, '');
  InsertLabel.Visible := False;
end;

{===========================================================}
Procedure TBOARDispositionCodeForm.InsertButtonClick(Sender: TObject);

begin
  with MainTable do
    try
      Append;
      MakeEditNotReadOnly(MainCodeEdit);
      InsertLabel.Visible := True;
      MainCodeEdit.SetFocus;
    except
      SystemSupport(001, MainTable, 'Error adding ' + CodeName + ' record.',
                    UnitName, GlblErrorDlgBox);
    end;

end;  {InsertButtonClick}

{===================================================================}
Procedure TBOARDispositionCodeForm.SaveButtonClick(Sender: TObject);

begin
  If MainTable.Modified
    then
      try
        MainTable.Post;
      except
        SystemSupport(002, MainTable,
                      'Error saving ' + CodeName + ' code ' +
                      MainTable.FieldByName(CodeFieldName).Text + '.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {SaveButtonClick}

{===================================================================}
procedure TBOARDispositionCodeForm.DeleteButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to delete disposition code ' +
                 MainTable.FieldByName(CodeFieldName).Text + '?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      try
        MainTable.Delete;
      except
        SystemSupport(003, MainTable,
                      'Error deleting ' + CodeName + ' code ' +
                      MainTable.FieldByName(CodeFieldName).Text + '.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {DeleteButtonClick}

{===================================================================}
Procedure TBOARDispositionCodeForm.UndoButtonClick(Sender: TObject);

begin
  If (MainTable.Modified and
      (MessageDlg('Are you sure you want to discard your changes?',
                  mtConfirmation, [mbYes, mbNo], 0) = idYes))
    then MainTable.Cancel;

end;  {UndoButtonClick}

{==========================================================}
Procedure TBOARDispositionCodeForm.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;

begin
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

      end;  {If PrintRangeDlg.Execute}

end;  {PrintButtonClick}

{===================================================================}
Procedure TBOARDispositionCodeForm.ReportPrintHeader(Sender: TObject);

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
      SetFont('Times New Roman', 11);
      Underline := True;
      Home;
      CRLF;
      PrintCenter('BAR Disposition Codes Listing', (PageWidth / 2));
      SetFont('Courier New', 10);
      CRLF;
      CRLF;

         {Code tables are now year independent so we do not want to print the
          tax year.}

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
      SetTab(0.3, pjCenter, 1.5, 0, BOXLINEBOTTOM, 0);   {Main code}
      SetTab(2.0, pjCenter,  3.0, 0, BOXLINEBOTTOM, 0);   {Description}
      SetTab(5.1, pjCenter,  1.2, 0, BOXLINEBOTTOM, 0);   {Result Type}

      Println(#9 + 'Code' +
              #9 + 'Description' +
              #9 + 'Result Type');

      Bold := False;

        {Set up the tabs for the info.}

      ClearTabs;
      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetTab(0.3, pjLeft, 1.5, 0.1, BOXLINENONE, 0);  {Code}
      SetTab(2.0, pjLeft,  3.0, 0, BOXLINENONE, 0);    {Description}
      SetTab(5.1, pjLeft,  1.2, 0, BOXLINENone, 0);   {Result Type}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TBOARDispositionCodeForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  TempStr : String;

begin
  Done := False;
  FirstTimeThrough := True;

  If PrintRangeDlg.PrintAllCodes
    then LookupTable.First
    else FindNearestOld(LookupTable, [CodeFieldName],
                        [PrintRangeDlg.StartRange]);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else LookupTable.Next;

    with PrintRangeDlg do
      If (LookupTable.EOF or
          ((not (PrintAllCodes or PrintToEndOfCodes)) and
           (LookupTable.FieldByName(CodeFieldName).Text > EndRange)))
        then Done := True;

    If not Done
      then
        with Sender as TBaseReport, LookupTable do
          begin
            case FieldByName('ResultType').AsInteger of
              gtApproved : TempStr := 'APPROVED';
              gtDenied : TempStr := 'DENIED';
              gtDismissed : TempStr := 'DISMISSED';
              gtWithdrawn : TempStr := 'WITHDRAWN';
            end;

            Println(#9 + FieldByName(CodeFieldName).Text +
                    #9 + FieldByName('Description').Text +
                    #9 + TempStr);

            If (LinesLeft < 5)
              then NewPage;

          end;  {with Sender as TBaseReport do}

  until Done;

end;  {ReportPrint}

{===================================================================}
Procedure TBOARDispositionCodeForm.FormCloseQuery(    Sender: TObject;
                                          var CanClose: Boolean);

begin
  SaveButtonClick(Sender);
end;  {FormCloseQuery}

{===================================================================}
Procedure TBOARDispositionCodeForm.FormClose(    Sender: TObject;
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
