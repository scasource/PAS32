unit AutoLoadPicturesAndDocuments;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler, locatdir, FileCtrl;

type
  TAutoLoadPicturesAndDocumentsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    TitleLabel: TLabel;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ParcelTable: TTable;
    LocateDirectoryDialog: TLocateDirectoryDlg;
    ItemLocationLabel: TLabel;
    ItemTypeRadioGroup: TRadioGroup;
    DirectoryEdit: TEdit;
    DirectoryLocateButton: TButton;
    ReportFilesNotLoadedCheckBox: TCheckBox;
    UseEndOfFileNameAsNotesCheckBox: TCheckBox;
    LoadAtTopOfPictureListCheckBox: TCheckBox;
    ExactParcelIDMatchOnlyCheckBox: TCheckBox;
    Panel3: TPanel;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    OpenDialog1: TOpenDialog;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure DirectoryLocateButtonClick(Sender: TObject);
    procedure ItemTypeRadioGroupClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ItemType : Integer;
    ItemTypeStr : String;
    LoadAtTopOfPictureList,
    ReportFilesNotLoaded, ReportCancelled,
    PrintSubHeader, UseEndOfFileNameAsNotes, ExactParcelIDMatchOnly : Boolean;
    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, PASTypes;

{$R *.DFM}

const
  ldPictures = 0;
  ldApexSketches = 1;
  ldPropertyCards = 2;
  ldDocuments = 3;
  ldCertiorariDocuments = 4;

{========================================================}
Procedure TAutoLoadPicturesAndDocumentsForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TAutoLoadPicturesAndDocumentsForm.InitializeForm;

begin
  UnitName := 'AutoLoadPicturesAndDocuments';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

  DirectoryEdit.Text := ExpandPASPath(GlblPictureDir);

    {CHG08122007-1(2.11.3.1)[F654]: Autoload cert documents.}

  If not GlblUsesGrievances
    then ItemTypeRadioGroup.Items.Delete(ldCertiorariDocuments);

    {CHG06102009-6(2.20.1.1)[F839]: Option to suppress document autoload.}

  If GlblSuppressDocumentAutoload
    then ItemTypeRadioGroup.Items.Delete(ldDocuments);

end;  {InitializeForm}

{===================================================================}
Procedure TAutoLoadPicturesAndDocumentsForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{===================================================================}
Procedure TAutoLoadPicturesAndDocumentsForm.ItemTypeRadioGroupClick(Sender: TObject);

begin
  case ItemTypeRadioGroup.ItemIndex of
    ldPictures :
      begin
        DirectoryEdit.Text := ExpandPASPath(GlblPictureDir);
        ItemLocationLabel.Caption := 'Folder to find pictures in:';
      end;

    ldDocuments :
      begin
        DirectoryEdit.Text := ExpandPASPath(GlblDocumentDir);
        ItemLocationLabel.Caption := 'Folder to find documents in:';
      end;

    ldApexSketches :
      begin
        DirectoryEdit.Text := ExpandPASPath(GlblDefaultApexDir);
        ItemLocationLabel.Caption := 'Folder to find sketches in:';
      end;

    ldPropertyCards :
      begin
        DirectoryEdit.Text := ExpandPASPath(GlblDefaultPropertyCardDirectory);
        ItemLocationLabel.Caption := 'Folder to find property cards in:';
      end;

    ldCertiorariDocuments :
      ItemLocationLabel.Caption := 'Folder to find certiorari documents in:';

  end;  {case ItemTypeRadioGroup.ItemIndex of}

end;  {ItemTypeRadioGroupClick}

{===================================================================}
Procedure TAutoLoadPicturesAndDocumentsForm.DirectoryLocateButtonClick(Sender: TObject);

begin
  If (_Compare(DirectoryEdit.Text, coNotBlank) and
      DirectoryExists(DirectoryEdit.Text))
    then LocateDirectoryDialog.Directory := DirectoryEdit.Text;

  If LocateDirectoryDialog.Execute
    then DirectoryEdit.Text := LocateDirectoryDialog.Directory;

end;  {DirectoryLocateButtonClick}

{===================================================================}
Procedure TAutoLoadPicturesAndDocumentsForm.ReportPrintHeader(Sender: TObject);

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
      PrintCenter(ItemTypeStr + 's Automatically Loaded', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;
      Println('');
      Println('Directory to load from: ' + DirectoryEdit.Text);
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.5, 0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(1.9, pjCenter, 2.0, 0, BOXLINEBottom, 0);   {File name}
      SetTab(4.0, pjCenter, 2.0, 0, BOXLINEBottom, 0);   {File name}
      SetTab(6.1, pjCenter, 2.0, 0, BOXLINEBottom, 0);   {File name}

      If PrintSubHeader
        then Println(#9 + 'Parcel ID' +
                     #9 + 'File Name' +
                     #9 + 'File Name' +
                     #9 + 'File Name');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Parcel ID}
      SetTab(1.9, pjLeft, 2.0, 0, BOXLINENONE, 0);   {File name}
      SetTab(4.0, pjLeft, 2.0, 0, BOXLINENONE, 0);   {File name}
      SetTab(6.1, pjLeft, 2.0, 0, BOXLINENONE, 0);   {File name}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TAutoLoadPicturesAndDocumentsForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  SwisSBLKey : String;
  I, LinePrinted, ItemOnLine,
  FileAttributes,
  ReturnCode, Index, Column : Integer;
  ItemsAdded, AlreadyOnFileList, FilesInDirectoryList : TStringList;
  NumItemsLoaded : LongInt;
  Directory : String;
  TempFile : TSearchRec;

begin
  NumItemsLoaded := 0;
  ItemsAdded := TStringList.Create;
  AlreadyOnFileList := TStringList.Create;
  Done := False;
  FirstTimeThrough := True;
  Directory := DirectoryEdit.Text;
  If (Directory[Length(Directory)] <> '\')
    then Directory := Directory + '\';

  FilesInDirectoryList := TStringList.Create;

    {CHG10242002-2: Print out the files not found.}

  If ReportFilesNotLoaded
    then
      begin
          {FXX01272003-1: Exclude directories from not loaded list.}

        FileAttributes := SysUtils.faArchive + SysUtils.faReadOnly;

        ReturnCode := FindFirst(Directory + '*.*', FileAttributes, TempFile);

        while (ReturnCode = 0) do
          begin
            If ((TempFile.Name <> '.') and
                (TempFile.Name <> '..'))
              then FilesInDirectoryList.Add(TempFile.Name);

            ReturnCode := FindNext(TempFile);

          end;  {while (ReturnCode = 0) do}

      end;  {If ReportFilesNotLoaded}

  ParcelTable.First;

  with Sender as TBaseReport do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else ParcelTable.Next;

      If ParcelTable.EOF
        then Done := True;

      SwisSBLKey := ExtractSSKey(ParcelTable);
      ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
      ProgressDialog.UserLabelCaption := 'Number ' + ItemTypeStr + 's loaded = ' + IntToStr(NumItemsLoaded);
      Application.ProcessMessages;

        {FXX07092004-1(2.08): Don't load pictures on inactive parcels.}

      If ((ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
          (not Done))
        then
          begin
            If (LinesLeft < 5)
              then NewPage;

            ItemsAdded.Clear;

              {CHG01272003-2: Option to use the ending part of the picture name as a note.}
              {CHG06032004-1(2.07l5): Option to number pictures so they appear at the top of the list.}

            DetectNewPicturesOrDocuments(SwisSBLKey, Directory,
                                         ItemType, True,
                                         ItemsAdded, AlreadyOnFileList,
                                         UseEndOfFileNameAsNotes,
                                         LoadAtTopOfPictureList,
                                         ExactParcelIDMatchOnly,
                                         ParcelTable.FieldByName('AccountNo').AsString,
                                         ParcelTable.FieldByName('PrintKey').AsString);

            If (ItemsAdded.Count > 0)
              then
                begin
                  LinePrinted := 1;
                  I := 0;

                  while (I <= (ItemsAdded.Count - 1)) do
                    begin
                      ItemOnLine := 1;

                      If (LinePrinted = 1)
                        then Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey))
                        else Print(#9);

                      while ((I <= (ItemsAdded.Count - 1)) and
                             (ItemOnLine <= 3)) do
                        begin
                          Print(#9 + StripPath(ItemsAdded[I]));
                          ItemOnLine := ItemOnLine + 1;
                          I := I + 1;
                          NumItemsLoaded := NumItemsLoaded + 1;
                        end;

                      Println('');

                      LinePrinted := LinePrinted + 1;

                    end;  {while (I <= (ItemsAdded.Count - 1)) do}

                  {CHG10242002-2: Print out the files not found.}

                  If ReportFilesNotLoaded
                    then
                      begin
                        For I := 0 to (ItemsAdded.Count - 1) do
                          begin
                            Index := FilesInDirectoryList.IndexOf(StripPath(ItemsAdded[I]));

                            If (Index > -1)
                              then FilesInDirectoryList.Delete(Index);

                          end;  {For I := 0 to (ItemsAdded.Count - 1) do}

                      end;  {If ReportFilesNotLoaded}

                end;  {If (ItemsAdded.Count > 0)}

              {CHG01272003-1: Don't report pictures already on file.}

            If ReportFilesNotLoaded
              then
                For I := 0 to (AlreadyOnFileList.Count - 1) do
                  begin
                    Index := FilesInDirectoryList.IndexOf(StripPath(AlreadyOnFileList[I]));

                    If (Index > -1)
                      then FilesInDirectoryList.Delete(Index);

                  end;  {For I := 0 to (AlreadyOnFileList.Count - 1) do}

          end;  {If not Done}

      ReportCancelled := ProgressDialog.Cancelled;

    until (Done or ReportCancelled);

  with Sender as TBaseReport do
    begin
      Bold := True;
      Println(#9 + 'Total ' + ItemTypeStr + 's loaded = ' + IntToStr(NumItemsLoaded));
      Bold := False;

      ClearTabs;
      SetTab(0.5, pjLeft, 2.5, 0, BOXLINENONE, 0);   {File name}
      SetTab(3.1, pjLeft, 2.5, 0, BOXLINENONE, 0);   {File name}
      SetTab(5.6, pjLeft, 2.5, 0, BOXLINENONE, 0);   {File name}

      Column := 1;
      PrintSubHeader := False;
      FirstTimeThrough := True;

      For I := 0 to (FilesInDirectoryList.Count - 1) do
        begin
          If ((LinesLeft < 5) or
              FirstTimeThrough)
            then
              begin
                If not FirstTimeThrough
                  then
                    begin
                      NewPage;
                      ClearTabs;
                      SetTab(0.5, pjLeft, 2.5, 0, BOXLINENONE, 0);   {File name}
                      SetTab(3.1, pjLeft, 2.5, 0, BOXLINENONE, 0);   {File name}
                      SetTab(5.6, pjLeft, 2.5, 0, BOXLINENONE, 0);   {File name}

                    end;  {If not FirstTimeThrough}

                Println('');
                Underline := True;
                Println(#9 + 'Files in Directory NOT loaded into PAS:');
                Underline := False;
                FirstTimeThrough := False;

              end;  {If (LinesLeft < 5)}

          If (Column = 4)
            then
              begin
                Println('');
                Column := 1;
              end;

          Print(#9 + StripPath(FilesInDirectoryList[I]));

          Column := Column + 1;

        end;  {For I := 0 to (FilesInDirectoryList.Count - 1) do}

    end;  {with Sender as TBaseReport do}

  ItemsAdded.Free;
  FilesInDirectoryList.Free;
  AlreadyOnFileList.Free;

end;  {ReportPrint}

{===================================================================}
Procedure TAutoLoadPicturesAndDocumentsForm.PrintButtonClick(Sender: TObject);

var
  Quit : Boolean;
  NewFileName : String;
  TempFile : File;

begin
  Quit := False;
  PrintSubHeader := True;
  ReportCancelled := False;
  ReportFilesNotLoaded := ReportFilesNotLoadedCheckBox.Checked;
  UseEndOfFileNameAsNotes := UseEndOfFileNameAsNotesCheckBox.Checked;
  ExactParcelIDMatchOnly := ExactParcelIDMatchOnlyCheckBox.Checked;
  LoadAtTopOfPictureList := LoadAtTopOfPictureListCheckBox.Checked;

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  PrintButton.Enabled := False;
  Application.ProcessMessages;
  Quit := False;

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

        case ItemTypeRadioGroup.ItemIndex of
          ldPictures :
            begin
              ItemType := dtPicture;
              ItemTypeStr := 'Picture';
            end;

          ldDocuments :
            begin
              ItemType := dtScannedImage;
              ItemTypeStr := 'scanned document';
            end;

             {CHG04282005-1(2.8.4.3)[2114]: Create autoload for sketches.}

          ldApexSketches :
            begin
              ItemType := dtApexSketch;
              ItemTypeStr := 'Apex sketches';
            end;

          ldPropertyCards :
            begin
              ItemType := dtPropertyCard;
              ItemTypeStr := 'property card';
            end;

          ldCertiorariDocuments :
            begin
              ItemType := dtCertiorari;
              ItemTypeStr := 'Cert Documents';
            end;

        end;  {case ItemTypeRadioGroup of}

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

  PrintButton.Enabled := True;

end; {PrintButtonClick}

{===================================================================}
Procedure TAutoLoadPicturesAndDocumentsForm.FormClose(    Sender: TObject;
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