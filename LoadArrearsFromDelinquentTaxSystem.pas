unit LoadArrearsFromDelinquentTaxSystem;

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
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler;

type
  TGeneralDLLFunction = Function (Application : TApplication) : Boolean;
  TParcelHasOpenDelinquentTaxesFunction = Function (Application : TApplication;
                                                    SwisSBLKey : ShortString) : Boolean;


  TLoadArrearsFlagsFromDTSForm = class(TForm)
    ParcelTable: TwwTable;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    Label1: TLabel;
    ClearOldArrearsFlagsCheckBox: TCheckBox;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ReportHeaderPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ClearArrearsFlags, ReportCancelled : Boolean;
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, PASTypes;

{$R *.DFM}

const
  DLLName = '\SCADLQTX\ReturnDelinquentStatusDLL.dll';

{========================================================}
Procedure TLoadArrearsFlagsFromDTSForm.InitializeForm;

begin
  UnitName := 'LoadArrearsFromDelinquentTaxSystem';  {mmm}

  OpenTablesForForm(Self, ThisYear);

end;  {InitializeForm}

{===================================================================}
Procedure TLoadArrearsFlagsFromDTSForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{================================================================}
Procedure TLoadArrearsFlagsFromDTSForm.StartButtonClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName : String;
  TempFile : File;

begin
  Quit := False;
  ReportCancelled := False;

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  StartButton.Enabled := False;
  Application.ProcessMessages;
  Quit := False;
  ClearArrearsFlags := ClearOldArrearsFlagsCheckBox.Checked;

    {CHG10121998-1: Add user options for default destination and show vet max msg.}

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler,
                              [ptLaser], False, Quit);

        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

          {Now print the report.}

        If not (Quit or ReportCancelled)
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

                        {FXX10111999-3: Make sure they know its done.}

                      ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

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

                    end;  {try PreviewForm := ...}

                  end  {If PrintDialog.PrintToFile}
                else ReportPrinter.Execute;

              ResetPrinter(ReportPrinter);

            end;  {If not Quit}

        ProgressDialog.Finish;

          {FXX10111999-3: Tell people that printing is starting and
                          done.}

        DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

      end;  {If PrintDialog.Execute}

  StartButton.Enabled := True;

end;  {StartButtonClick}

{=========================================================}
Procedure TLoadArrearsFlagsFromDTSForm.ReportHeaderPrint(Sender: TObject);

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
      SetFont('Arial',12);
      Bold := True;
      Home;
      PrintCenter('Arrears Flags Cleared \ Set', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.8, 0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(2.2, pjCenter, 1.0, 0, BOXLINEBottom, 0);   {Action}

      Println(#9 + 'Parcel ID' +
              #9 + 'Action');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.8, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(2.2, pjLeft, 1.0, 0, BOXLINENone, 0);   {Action}

    end;  {with Sender as TBaseReport do}

end;  {ReportHeaderPrint}

{====================================================================}
Procedure TLoadArrearsFlagsFromDTSForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit : Boolean;
  SwisSBLKey : Str26;
  NumCleared, NumAdded : Integer;
  TempLen : Integer;
  TempPChar : PChar;
  CurrentDLLHandle : THandle;
  ParcelHasOpenDelinquentTaxes : TParcelHasOpenDelinquentTaxesFunction;
  CloseDLL, InitializeDLL : TGeneralDLLFunction;

begin
  Quit := False;
  NumCleared := 0;
  NumAdded := 0;
  Done := False;
  FirstTimeThrough := True;

    {Load the DLL for checking lien status.}

  TempLen := Length(DLLName);
  TempPChar := StrAlloc(TempLen + 1);
  StrPCopy(TempPChar, DLLName);

  CurrentDLLHandle := LoadLibrary(TempPChar);

  If (CurrentDLLHandle = 0)
    then Quit := True
    else
      begin
        @InitializeDLL := GetProcAddress(CurrentDLLHandle, 'InitializeDLL');
        @ParcelHasOpenDelinquentTaxes := GetProcAddress(CurrentDLLHandle, 'ParcelHasOpenDelinquentTaxes');
        @CloseDLL := GetProcAddress(CurrentDLLHandle, 'CloseDLL');

        If (@InitializeDLL = nil)
          then Quit := True
          else InitializeDLL(Application);

      end;  {else of If (CurrentDLLHandle = 0)}

  If Quit
    then SystemSupport(001, ParcelTable, 'Error loading interface to Delinquent Tax Status.',
                                    UnitName, GlblErrorDlgBox)
    else
      begin
        ParcelTable.First;

        with Sender as TBaseReport do
          begin
            repeat
              If FirstTimeThrough
                then FirstTimeThrough := False
                else ParcelTable.Next;

              If ParcelTable.EOF
                then Done := True;

              SwisSBLKey := ExtractSSKey(ParcelTable);
              ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
              ProgressDialog.UserLabelCaption := 'Number Arrears Flags Added = ' + IntToStr(NumAdded);
              Application.ProcessMessages;

              If ((not Done) and
                  ClearArrearsFlags and
                  ParcelTable.FieldByName('Arrears').AsBoolean)
                then
                  with ParcelTable do
                    try
                      Edit;
                      FieldByName('Arrears').AsBoolean := False;
                      Post;

                      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                              #9 + 'Cleared');
                      NumCleared := NumCleared + 1;

                    except
                      SystemSupport(001, ParcelTable, 'Error clearing arrears flag for ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                                    UnitName, GlblErrorDlgBox);
                    end;

                {Now check for delinquent status.}

              If ((not Done) and
                  ParcelHasOpenDelinquentTaxes(Application, SwisSBLKey))
                then
                  with ParcelTable do
                    try
                      Edit;
                      FieldByName('Arrears').AsBoolean := True;
                      Post;

                      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                              #9 + 'Added');
                      NumAdded := NumAdded + 1;

                    except
                      SystemSupport(002, ParcelTable, 'Error adding arrears flag for ' + ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                                    UnitName, GlblErrorDlgBox);
                    end;

              ReportCancelled := ProgressDialog.Cancelled;

              If (LinesLeft < 5)
                then NewPage;

            until (Done or ReportCancelled);

            Println('');
            Println('');
            Println(#9 + 'Number cleared = ' + IntToStr(NumCleared));
            Println(#9 + 'Number added = ' + IntToStr(NumAdded));

          end;  {with Sender as TBaseReport do}

        CloseDLL(Application);
        FreeLibrary(CurrentDLLHandle);
        CurrentDLLHandle := 0;

      end;  {else of If Quit}

end;  {ReportPrint}

{===================================================================}
Procedure TLoadArrearsFlagsFromDTSForm.FormClose(    Sender: TObject;
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