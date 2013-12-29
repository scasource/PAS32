unit AutoLoadPicturesAndDocumentsFromLoadingDock;

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
  RPrinter, RPDefine, RPBase, RPFiler, locatdir, TMultiP, RenameDialog;

type
  TImportPicturesFromLoadingDockForm = class(TForm)
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ParcelTable: TTable;
    LocateDirectoryDialog: TLocateDirectoryDlg;
    Panel1: TPanel;
    ImportButton: TBitBtn;
    Panel4: TPanel;
    ScrollBox: TScrollBox;
    ItemPanel1: TPanel;
    Panel7: TPanel;
    Image1: TPMultiImage;
    PicturesToImportLabel: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditFileName1: TEdit;
    EditParcelID1: TEdit;
    Label4: TLabel;
    OptionsGroupBox: TGroupBox;
    Label1: TLabel;
    DirectoryEdit: TEdit;
    DirectoryLocateButton: TButton;
    ReportFilesNotLoadedCheckBox: TCheckBox;
    UseEndOfFileNameAsNotesCheckBox: TCheckBox;
    ErrorPanel1: TPanel;
    ItemPanel2: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel5: TPanel;
    Image2: TPMultiImage;
    EditFileName2: TEdit;
    EditParcelID2: TEdit;
    ErrorPanel2: TPanel;
    PictureTable: TTable;
    PictureLookupTable: TTable;
    RenameButton1: TBitBtn;
    LocateButton1: TBitBtn;
    LocateButton2: TBitBtn;
    RenameButton2: TBitBtn;
    RenameDialogBox: TRenameDialogBox;
    SwisCodeTable: TTable;
    Notes1: TEdit;
    Notes2: TEdit;
    ImportActionRadioGroup1: TRadioGroup;
    ImportActionRadioGroup2: TRadioGroup;
    ItemPanel3: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Panel6: TPanel;
    Image3: TPMultiImage;
    EditFileName3: TEdit;
    EditParcelID3: TEdit;
    ErrorPanel3: TPanel;
    RenameButton3: TBitBtn;
    LocateButton3: TBitBtn;
    Notes3: TEdit;
    ImportActionRadioGroup3: TRadioGroup;
    ItemPanel4: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Panel10: TPanel;
    Image4: TPMultiImage;
    EditFileName4: TEdit;
    EditParcelID4: TEdit;
    ErrorPanel4: TPanel;
    RenameButton4: TBitBtn;
    LocateButton4: TBitBtn;
    Notes4: TEdit;
    ImportActionRadioGroup4: TRadioGroup;
    ValidPicturesLabel: TLabel;
    ErrorPicturesLabel: TLabel;
    ItemPanel5: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Panel8: TPanel;
    Image5: TPMultiImage;
    EditFileName5: TEdit;
    EditParcelID5: TEdit;
    ErrorPanel5: TPanel;
    RenameButton5: TBitBtn;
    LocateButton5: TBitBtn;
    Notes5: TEdit;
    ImportActionRadioGroup5: TRadioGroup;
    ItemPanel6: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Panel12: TPanel;
    Image6: TPMultiImage;
    EditFileName6: TEdit;
    EditParcelID6: TEdit;
    ErrorPanel6: TPanel;
    RenameButton6: TBitBtn;
    LocateButton6: TBitBtn;
    Notes6: TEdit;
    ImportActionRadioGroup6: TRadioGroup;
    CloseButton: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ImportButtonClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure DirectoryLocateButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RenameButtonClick(Sender: TObject);
    procedure LocateButtonClick(Sender: TObject);
    procedure UseEndOfFileNameAsNotesCheckBoxClick(Sender: TObject);
    procedure ImportActionRadioGroupClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    AssessmentYear, OriginalFileName : String;
    ReportCancelled, ImportDone,
    PrintSubHeader, UseEndOfFileNameAsNotes : Boolean;
    PicturesLoadedList, PicturesDeletedList, PicturesNotLoadedList : TList;
    ItemPanel, ErrorPanel : TPanel;
    Image : TPMultiImage;
    EditFileName, EditParcelID, Notes : TEdit;
    RenameButton, LocateButton : TBitBtn;
    ImportActionRadioGroup : TRadioGroup;
    PicturesThisBatch : Integer;
    PicturesPrinted, PrintPicturesNotLoaded : Boolean;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure SetImportPictureCaption;

    Procedure LoadPicturesForPreview;

    Procedure GetComponentsForThisPicturePanel(I : Integer);

    Procedure ClearAllPanels;

    Procedure GetParcelIDForPictureName(    PictureFileName : String;
                                        var SwisSBLKey : String;
                                        var PictureNote : String;
                                        var Error : Boolean;
                                        var ErrorMessage : String;
                                        var ErrorType : Integer);

    Procedure LoadOnePicture(PictureFileName : String;
                             PictureFilePath : String;
                             PictureNumber : Integer);

    Procedure PrintThePictureReport;

    Function CheckPictureFileName(NewFileName : String) : Boolean;

    Procedure ImportThePictures(    PictureActionList : TStringList;
                                    PicturesLoadedList : TList;
                                    PicturesDeletedList : TList;
                                    PicturesNotLoadedList : TList;
                                var Quit : Boolean);

  end;

  PictureListRecord = record
    SwisSBLKey : String;
    FileName : String;
    Notes : String;
    ImportAction : Integer;
  end;

  PPictureListPointer = ^PictureListRecord;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, PASTypes;

{$R *.DFM}

const
  PicturesPerBatch = 6;

    {Error types}

  etNone = 0;
  etInvalidPictureType = 1;
  etBadParcelID = 2;
  etMultipleParcelID = 3;
  etPictureAlreadyExists = 4;

    {Action Types}

  acTransfer = 0;
  acLeaveInDirectory = 1;
  acDelete = 2;

{========================================================}
Procedure TImportPicturesFromLoadingDockForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Function PictureInList(    PictureList : TList;
                           _FileName : String;
                       var Index : Integer) : Boolean;

var
  I : Integer;

begin
  Index := -1;
  Result := False;

  For I := 0 to (PictureList.Count - 1) do
    If (PPictureListPointer(PictureList[I])^.FileName = _FileName)
      then
        begin
          Result := True;
          Index := I;
        end;

end;  {PictureInList}

{========================================================}
Procedure AddOnePictureListItem(PictureList : TList;
                                _SwisSBLKey : String;
                                _FileName : String;
                                _Notes : String;
                                _ImportAction : Integer);

var
  PPictureListPtr : PPictureListPointer;
  Index : Integer;

begin
    {FX04232004-1(2.07l3): Make sure that the picture does not already exist in the list.}

  If not PictureInList(PictureList, _FileName, Index)
    then
      begin
        New(PPictureListPtr);

        with PPictureListPtr^ do
          begin
            SwisSBLKey := _SwisSBLKey;
            FileName := _FileName;
            Notes := _Notes;
            ImportAction := _ImportAction;
          end;

        PictureList.Add(PPictureListPtr);

      end;  {If not PictureInList(PictureList, _FileName, Index)}

end;  {AddOnePictureListItem}

{========================================================}
Function FindFileInPictureList(PicturesList : TList;
                               _FileName : String) : Boolean;

var
  I : Integer;

begin
  Result := False;

  For I := 0 to (PicturesList.Count - 1) do
    If (Trim(PPictureListPointer(PicturesList[I])^.FileName) =
        Trim(_FileName))
      then Result := True;

end;  {FindFileInPictureList}

{========================================================}
Procedure TImportPicturesFromLoadingDockForm.SetImportPictureCaption;

var
  I, PicturesThisBatch, NumErrors, NumValid : Integer;

begin
  PicturesThisBatch := 0;
  NumErrors := 0;
  NumValid := 0;

  For I := 1 to PicturesPerBatch do
    begin
      GetComponentsForThisPicturePanel(I);

      If ItemPanel.Visible
        then
          begin
            PicturesThisBatch := PicturesThisBatch + 1;

            If (Deblank(ErrorPanel.Caption) = '')
              then NumValid := NumValid + 1
              else NumErrors := NumErrors + 1;

          end;  {If ItemPanel.Visible}

    end;  {For I := 1 to PicturesPerBatch do}

  PicturesToImportLabel.Caption := 'Pictures to Import (' +
                                   IntToStr(PicturesThisBatch) +
                                   ' this batch):';
  ValidPicturesLabel.Caption := 'Valid Pictures: ' + IntToStr(NumValid);
  ErrorPicturesLabel.Caption := 'Pictures in Error: ' + IntToStr(NumErrors);

end;  {SetImportPictureCaption}

{========================================================}
Function FileExistsInPictureDirectory(    PictureFileName : String;
                                          PictureDirectory : String;
                                          PictureDirectoryType : String;
                                      var ErrorMessage : String;
                                      var ErrorType : Integer) : Boolean;

var
  FileAttributes, ReturnCode : Integer;
  TempFile : TSearchRec;

begin
  Result := False;
  FileAttributes := SysUtils.faArchive + SysUtils.faReadOnly;

  ReturnCode := FindFirst(PictureDirectory + PictureFileName, FileAttributes, TempFile);

  If (ReturnCode = 0)
    then
      begin
        Result := True;
        ErrorMessage := 'Picture with this name already exists in ' +
                        PictureDirectoryType + ' picture directory.';
        ErrorType := etPictureAlreadyExists;
      end;

end;  {If not Error}

{========================================================}
Procedure TImportPicturesFromLoadingDockForm.GetParcelIDForPictureName(    PictureFileName : String;
                                                                       var SwisSBLKey : String;
                                                                       var PictureNote : String;
                                                                       var Error : Boolean;
                                                                       var ErrorMessage : String;
                                                                       var ErrorType : Integer);

{There are 3 errors to check for:
   1. Can't match the parcel ID.
   2. Can match multiple parcel IDs.
   3. Picture with that name already exists.}

var
  SBLRec : SBLRecord;
  _Found, ValidEntry, PictureNameAlreadyMatched : Boolean;
  TempFileName, LastPictureMatchedSwisSBLKey : String;
  PicturesMatched : TStringList;
  I : Integer;

begin
  ErrorType := etNone;
  Error := False;
  ErrorMessage := '';
  PicturesMatched := TStringList.Create;
  SwisSBLKey := '';

    {This is how to determine if this is a valid picture name, if there are mulstiples and what the notes are:
       Take the first character of the file name, convert it to a swis sbl and attempt to look it up.
       If if matches a parcel exactly, make a note of the parcel and everything else in the picture is a note (if they selected this option).
       Then, take the first 2 characters and do the same.
       Continue until all characters in the name are being tested on.
       If multiple matches have been made, then mark this as an error picture and tell the user what parcels are matched.}

  TempFileName := PictureFileName[1];
  PictureNameAlreadyMatched := False;
  LastPictureMatchedSwisSBLKey := '';
  ParcelTable.IndexName := 'BYTAXROLLYR_SBLKEY';

    {FXX03172004-1(2.08): Redo checking for duplicate matches.  The way it should work is that once we find
                          a match, we keep searching until it no longer matches.  The last match is really
                          the one we should use and the note is everything after it.
                          This means that 100.20.1.43Front.jpg will have a note of 'Front' and be
                          matched correctly even if there is also a 100.20.1.4 parcel and not
                          be listed as duplicate.}

  For I := 2 to Length(PictureFileName) do
    begin
      SBLRec := ConvertDashDotSBLToSegmentSBL(TempFileName,
                                              ValidEntry);

      If ValidEntry
        then
          begin
            with SBLRec do
              _Found := FindKeyOld(ParcelTable,
                                   ['TaxRollYr', 'Section', 'Subsection',
                                    'Block', 'Lot', 'Sublot', 'Suffix'],
                                   [AssessmentYear, Section, Subsection,
                                    Block, Lot, Sublot, Suffix]);

            If _Found
              then
                begin
                  PictureNameAlreadyMatched := True;
                  LastPictureMatchedSwisSBLKey := ExtractSSKey(ParcelTable);
                end
              else
                If PictureNameAlreadyMatched
                  then
                    begin
                      PictureNameAlreadyMatched := False;
                      PicturesMatched.Add(LastPictureMatchedSwisSBLKey);
                      SwisSBLKey := LastPictureMatchedSwisSBLKey;

                      If UseEndOfFileNameAsNotes
                        then PictureNote := Trim(Copy(ChangeFileExt(PictureFileName, ''), (I - 1), 255))
                        else PictureNote := '';

                    end;  {If PictureNameAlreadyMatched}

          end;  {If ValidEntry}

      TempFileName := TempFileName + PictureFileName[I];

    end;  {For I := 2 to Length(PictureFileName);}

  ParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

  If (PicturesMatched.Count = 0)
    then
      begin
        Error := True;
        ErrorMessage := 'No parcel could be matched to the picture file name.';
        ErrorType := etBadParcelID;
      end;

  If (PicturesMatched.Count > 1)
    then
      begin
        Error := True;
        ErrorMessage := 'More than 1 parcel could be matched: (' +
                        ConvertSwisSBLToDashDot(PicturesMatched[0]) + ' ' +
                        ConvertSwisSBLToDashDot(PicturesMatched[1]) + ')';
        ErrorType := etMultipleParcelID;

      end;  {If (PicturesMatched.Count > 1)}

    {If everything is OK so far, then make sure this picture does not already
     exist in the main picture directory.}

  If not Error
    then Error := FileExistsInPictureDirectory(PictureFileName, GlblPictureDir, 'main',
                                               ErrorMessage, ErrorType);

  PicturesMatched.Free;

end;  {GetParcelIDForPictureName}

{========================================================}
Procedure TImportPicturesFromLoadingDockForm.GetComponentsForThisPicturePanel(I : Integer);

var
  TempComponentName : String;

begin
  TempComponentName := 'ItemPanel' + IntToStr(I);
  ItemPanel := TPanel(FindComponent(TempComponentName));

  TempComponentName := 'Image' + IntToStr(I);
  Image := TPMultiImage(FindComponent(TempComponentName));

  TempComponentName := 'EditFileName' + IntToStr(I);
  EditFileName := TEdit(FindComponent(TempComponentName));

  TempComponentName := 'EditParcelID' + IntToStr(I);
  EditParcelID := TEdit(FindComponent(TempComponentName));

  TempComponentName := 'Notes' + IntToStr(I);
  Notes := TEdit(FindComponent(TempComponentName));

  TempComponentName := 'ErrorPanel' + IntToStr(I);
  ErrorPanel := TPanel(FindComponent(TempComponentName));

  TempComponentName := 'ImportActionRadioGroup' + IntToStr(I);
  ImportActionRadioGroup := TRadioGroup(FindComponent(TempComponentName));

  TempComponentName := 'RenameButton' + IntToStr(I);
  RenameButton := TBitBtn(FindComponent(TempComponentName));

  TempComponentName := 'LocateButton' + IntToStr(I);
  LocateButton := TBitBtn(FindComponent(TempComponentName));

end;  {GetComponentsForThisPicturePanel}

{========================================================}
Procedure TImportPicturesFromLoadingDockForm.ClearAllPanels;

var
  I : Integer;

begin
  For I := 1 to PicturesPerBatch do
    begin
      GetComponentsForThisPicturePanel(I);
      Image.ImageName := '';
      EditFileName.Text := '';
      EditParcelID.Text := '';
      Notes.Text := '';
      ErrorPanel.Caption := '';
      ItemPanel.Color := clBtnFace;
      ItemPanel.Visible := False;

    end;  {For I := 1 to PicturesPerBatch do}

end;  {ClearAllPanels}

{========================================================}
Procedure TImportPicturesFromLoadingDockForm.LoadOnePicture(PictureFileName : String;
                                                            PictureFilePath : String;
                                                            PictureNumber : Integer);

var
  SwisSBLKey, PictureNote, ErrorMessage : String;
  Error, ValidPicture : Boolean;
  ErrorType : Integer;

begin
  ErrorType := etNone;
  PictureFileName := Trim(PictureFileName);
  ValidPicture := True;

  GetComponentsForThisPicturePanel(PictureNumber);

  ItemPanel.Visible := True;
  ItemPanel.Color := clBtnFace;

  try
    Image.ImageName := PictureFilePath + PictureFileName;
  except
    Image.ImageName := '';
    ErrorMessage := 'Not a valid picture file type.';
    ErrorType := etInvalidPictureType;
    ValidPicture := False;
  end;

  EditFileName.Text := PictureFileName;

  If ValidPicture
    then GetParcelIDForPictureName(PictureFileName, SwisSBLKey,
                                   PictureNote, Error, ErrorMessage, ErrorType);

  If (Error or
      (not ValidPicture))
    then
      begin
        ItemPanel.Color := $007C59E6;
        ErrorPanel.Visible := True;
        ErrorPanel.Caption := ErrorMessage;
        ImportActionRadioGroup.ItemIndex := acLeaveInDirectory;

        If (ErrorType = etPictureAlreadyExists)
          then EditParcelID.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        If ((ErrorType = etBadParcelID) or
            (ErrorType = etMultipleParcelID))
          then EditParcelID.Text := '';

      end
    else
      begin
        ErrorPanel.Visible := False;
        ErrorPanel.Caption := '';
        ImportActionRadioGroup.ItemIndex := acTransfer;

        EditParcelID.Text := ConvertSwisSBLToDashDot(SwisSBLKey);

        If (Deblank(PictureNote) <> '')
          then Notes.Text := PictureNote;

      end;  {If (Error or...}

end;  {LoadOnePicture}

{========================================================}
Procedure TImportPicturesFromLoadingDockForm.LoadPicturesForPreview;

var
  TempComponentName, Directory : String;
  TempFile : TSearchRec;
  I, FileAttributes, ReturnCode : Integer;

begin
  PicturesThisBatch := 0;
  Directory := DirectoryEdit.Text;

  ClearAllPanels;

  FileAttributes := SysUtils.faArchive + SysUtils.faReadOnly;

  ReturnCode := FindFirst(Directory + '*.*', FileAttributes, TempFile);

  while ((ReturnCode = 0) and
         (PicturesThisBatch < PicturesPerBatch)) do
    begin
      If ((TempFile.Name <> '.') and
          (TempFile.Name <> '..') and
          (not FindFileInPictureList(PicturesLoadedList, TempFile.Name)))
        then
          begin
            LoadOnePicture(StripPath(TempFile.Name), Directory, PicturesThisBatch + 1);
            PicturesThisBatch := PicturesThisBatch + 1;

          end;  {If ((TempFile.Name <> '.') and}

      ReturnCode := FindNext(TempFile);

    end;  {while (ReturnCode = 0) do}

    {Set Visible to False for any unused panels.}

  For I := (PicturesThisBatch + 1) to (PicturesPerBatch - 1) do
    begin
      TempComponentName := 'ItemPanel' + IntToStr(I + 1);
      TPanel(FindComponent(TempComponentName)).Visible := False;
    end;

  SetImportPictureCaption;
  ScrollBox.VertScrollBar.Position := 0;

end;  {LoadPicturesForPreview}

{========================================================}
Procedure TImportPicturesFromLoadingDockForm.InitializeForm;

begin
  UnitName := 'AutoLoadPicturesAndDocumentsFromLoadingDock';  {mmm}
  ImportDone := False;

  OpenTablesForForm(Self, GlblProcessingType);

  AssessmentYear := GetTaxRlYr;

  DirectoryEdit.Text := AddDirectorySlashes(ExpandPASPath(GlblDefaultPictureLoadingDockDirectory));
  UseEndOfFileNameAsNotes := UseEndOfFileNameAsNotesCheckBox.Checked;

  PicturesLoadedList := TList.Create;
  PicturesNotLoadedList := TList.Create;
  PicturesDeletedList := TList.Create;
  PicturesPrinted := False;

  If (Deblank(DirectoryEdit.Text) <> '')
    then LoadPicturesForPreview;

end;  {InitializeForm}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.FormKeyPress(    Sender: TObject;
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
Procedure TImportPicturesFromLoadingDockForm.DirectoryLocateButtonClick(Sender: TObject);

begin
  If (Deblank(DirectoryEdit.Text) <> '')
    then LocateDirectoryDialog.Directory := DirectoryEdit.Text;

  If LocateDirectoryDialog.Execute
    then DirectoryEdit.Text := LocateDirectoryDialog.Directory;

end;  {DirectoryLocateButtonClick}

{===================================================================}
Function GetImportActionName(ImportAction : Integer) : String;

begin
  case ImportAction of
    acTransfer : Result := 'Imported';
    acLeaveInDirectory : Result := 'Left in dock';
    acDelete : Result := 'Deleted';
    else Result := '';

  end;  {case ImportAction of}

end;  {GetImportActionName}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.ReportPrintHeader(Sender: TObject);

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
      PrintCenter('Pictures Automatically Loaded', (PageWidth / 2));
      SetFont('Times New Roman', 9);
      CRLF;
      Println('');
      Println('Directory to load from: ' + DirectoryEdit.Text);
      Println('');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure PrintPageHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      SetTab(0.3, pjCenter, 1.5, 0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(1.9, pjCenter, 2.0, 0, BOXLINEBottom, 0);   {File name}
      SetTab(4.0, pjCenter, 3.1, 0, BOXLINEBottom, 0);   {Notes}
      SetTab(7.2, pjCenter, 0.8, 0, BOXLINEBottom, 0);   {Action}

      Println(#9 + 'Parcel ID' +
              #9 + 'File Name' +
              #9 + 'Notes' +
              #9 + 'Action');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Parcel ID}
      SetTab(1.9, pjLeft, 2.0, 0, BOXLINENONE, 0);   {File name}
      SetTab(4.0, pjLeft, 3.1, 0, BOXLINENONE, 0);   {Notes}
      SetTab(7.2, pjLeft, 0.8, 0, BOXLINENONE, 0);   {Action}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {PrintPageHeader}

{===================================================================}
Procedure PrintSectionHeader(Sender : TObject;
                             SectionHeader : String);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      ClearTabs;
      SetTab(0.3, pjCenter, 1.5, 0, BOXLINEBottom, 0);   {Parcel ID}
      Bold := True;
      Underline := True;
      Println(#9 + SectionHeader + ':');
      Bold := False;
      Underline := False;
      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintSectionHeader}

{===================================================================}
Procedure PrintOnePictureReportSection(Sender : TObject;
                                       PicturesList : TList;
                                       SectionHeader : String);

var
  I : Integer;
  TempParcelID : String;

begin
  with Sender as TBaseReport do
    begin
      PrintSectionHeader(Sender, SectionHeader);
      PrintPageHeader(Sender);

      For I := 0 to (PicturesList.Count - 1) do
        begin
          If (LinesLeft < 5)
            then
              begin
                NewPage;
                PrintSectionHeader(Sender, SectionHeader);
                PrintPageHeader(Sender);
              end;

          with PPictureListPointer(PicturesList[I])^ do
            begin
              If (Deblank(SwisSBLKey) = '')
                then TempParcelID := 'Unknown'
                else TempParcelID := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

              Println(#9 + TempParcelID +
                      #9 + FileName +
                      #9 + Notes +
                      #9 + GetImportActionName(ImportAction));

            end;  {with PPictureListPointer(PicturesList)^ do}

        end;  {with Sender as TBaseReport do}

    end;  {with Sender as TBaseReport do}

end;  {PrintOnePictureReportSection}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.ReportPrint(Sender: TObject);

begin
  PicturesPrinted := True;
  PrintOnePictureReportSection(Sender, PicturesLoadedList, 'Pictures Loaded');
  PrintOnePictureReportSection(Sender, PicturesDeletedList, 'Pictures Deleted');

  If PrintPicturesNotLoaded
    then PrintOnePictureReportSection(Sender, PicturesNotLoadedList, 'Pictures Not Loaded');

end;  {ReportPrint}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.PrintThePictureReport;

var
  NewFileName : String;
  TempFile : File;
  Quit : Boolean;

begin
  SetPrintToScreenDefault(PrintDialog);
  Quit := False;

  If PrintDialog.Execute
    then
      begin
          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler,
                              [ptLaser], False, Quit);

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

        ClearTList(PicturesLoadedList, SizeOf(PictureListRecord));
        ClearTList(PicturesNotLoadedList, SizeOf(PictureListRecord));
        ClearTList(PicturesDeletedList, SizeOf(PictureListRecord));

        PicturesPrinted := False;

      end;  {If PrintDialog.Execute}

end;  {PrintThePictureReport}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.ImportThePictures(    PictureActionList : TStringList;
                                                                   PicturesLoadedList : TList;
                                                                   PicturesDeletedList : TList;
                                                                   PicturesNotLoadedList : TList;
                                                               var Quit : Boolean);

var
  I, PictureNumber, PictureAction : Integer;
  SwisSBLKey : String;
  _Found, ValidEntry : Boolean;
  SBLRec : SBLRecord;

begin
  Quit := False;

  For I := 0 to (PictureActionList.Count - 1) do
    begin
      PictureAction := StrToInt(PictureActionList[I]);

      GetComponentsForThisPicturePanel(I + 1);

      case PictureAction of
        acTransfer :
          begin
            LockWindowUpdate(Handle);
            Image.ImageName := '';

            SBLRec := ExtractSwisSBLFromSwisSBLKey(ConvertSwisDashDotToSwisSBL(EditParcelID.Text,
                                                                               SwisCodeTable,
                                                                               ValidEntry));

            with SBLRec do
              _Found := FindKeyOld(ParcelTable,
                                   ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                                    'Block', 'Lot', 'Sublot', 'Suffix'],
                                   [AssessmentYear, SwisCode, Section, Subsection,
                                    Block, Lot, Sublot, Suffix]);

            If _Found
              then SwisSBLKey := ExtractSSKey(ParcelTable)
              else
                begin
                  Quit := True;
                  MessageDlg('Error relocating parcel in order to transfer.',
                             mtError, [mbOK], 0);
                end;

              {First move the picture.}

            If not Quit
              then Quit := not CopyOneFile(AddDirectorySlashes(DirectoryEdit.Text) + EditFileName.Text,
                                           AddDirectorySlashes(GlblPictureDir) + EditFileName.Text);

            If not Quit
              then
                try
                  OldDeleteFile(AddDirectorySlashes(DirectoryEdit.Text) + EditFileName.Text);
                except
                  Quit := True;
                end;

              {Then add a record to the picture table.}

            If not Quit
              then
                begin
                  SetRangeOld(PictureLookupTable, ['SwisSBLKey', 'PictureNumber'],
                              [SwisSBLKey, '0'], [SwisSBLKey, '999']);

                  PictureLookupTable.First;

                  If PictureLookupTable.EOF
                    then PictureNumber := 1
                    else
                      begin
                        PictureLookupTable.Last;
                        PictureNumber := PictureLookupTable.FieldByName('PictureNumber').AsInteger + 1;
                      end;

                  with PictureTable do
                    try
                      Insert;
                      FieldByName('SwisSBLKey').Text := SwisSBLKey;
                      FieldByName('PictureNumber').AsInteger := PictureNumber;
                      FieldByName('PictureLocation').Text := AddDirectorySlashes(GlblPictureDir) + EditFileName.Text;
                      FieldByName('Date').AsDateTime := Date;
                      FieldByName('Notes').Text := Notes.Text;
                      Post;
                    except
                      Quit := True;
                    end;

                  AddOnePictureListItem(PicturesLoadedList, SwisSBLKey, EditFileName.Text, Notes.Text, acTransfer);

                end;  {If not Quit}

            LockWindowUpdate(0);

          end;  {acTransfer}

        acDelete :
          begin
            Image.ImageName := '';

            try
              OldDeleteFile(AddDirectorySlashes(DirectoryEdit.Text) + EditFileName.Text);
            except
              Quit := True;
            end;

            AddOnePictureListItem(PicturesDeletedList, '', EditFileName.Text, '', acDelete);

          end;  {acDelete}

        acLeaveInDirectory : AddOnePictureListItem(PicturesNotLoadedList, '', EditFileName.Text, '', acLeaveInDirectory);

      end;  {case PictureAction of}

    end;  {For I := 0 to (PictureActionList.Count - 1) do}

end;  {ImportThePictures}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.UseEndOfFileNameAsNotesCheckBoxClick(Sender: TObject);

begin
  UseEndOfFileNameAsNotes := UseEndOfFileNameAsNotesCheckBox.Checked;
end;

{===================================================================}
Function DeterminePanelNumberForComponentName(ComponentName : String) : Integer;

var
  I : Integer;
  TempStr : String;

begin
  Result := -1;
  TempStr := '';

  For I := 1 to Length(ComponentName) do
    If not (ComponentName[I] in Letters)
      then TempStr := TempStr + ComponentName[I];

  try
    Result := StrToInt(TempStr);
  except
  end;

end;  {DeterminePanelNumberForComponentName}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.ImportActionRadioGroupClick(Sender: TObject);

{Don't let them switch to transfer if there are still errors.}

var
  Index : Integer;

begin
  Index := DeterminePanelNumberForComponentName(TComponent(Sender).Name);
  GetComponentsForThisPicturePanel(Index);

  with Sender as TRadioGroup do
    If ((ItemIndex = acTransfer) and
        (Trim(ErrorPanel.Caption) <> ''))
      then
        begin
          MessageDlg('Sorry, you cannot import a picture with errors.', mtError, [mbOK], 0);
          ItemIndex := acLeaveInDirectory;
        end;

end;  {ImportActionRadioGroupClick}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.ImportButtonClick(Sender: TObject);

var
  Continue, Quit, CancelImport : Boolean;
  TempComponentName : String;
  I, ActionThisPicture,
  TotalNumberPicturesToImport, TotalNumberPicturesToDelete : Integer;
  PictureActionList : TStringList;

begin
  ImportDone := True;
  PictureActionList := TStringList.Create;
  ImportButton.Enabled := False;
  Application.ProcessMessages;
  CancelImport := False;
  TotalNumberPicturesToImport := 0;
  TotalNumberPicturesToDelete := 0;
  PrintPicturesNotLoaded := ReportFilesNotLoadedCheckBox.Checked;

     {First check the pictures to see if there are still any errors or pictures not accepted.}

  For I := 1 to PicturesThisBatch do
    begin
      GetComponentsForThisPicturePanel(I);
      ActionThisPicture := ImportActionRadioGroup.ItemIndex;

      If (ActionThisPicture = acTransfer)
        then TotalNumberPicturesToImport := TotalNumberPicturesToImport + 1;

      If (ActionThisPicture = acDelete)
        then TotalNumberPicturesToDelete := TotalNumberPicturesToDelete + 1;

      PictureActionList.Add(IntToStr(ActionThisPicture));

    end;  {For I := 1 to PicturesPerBatch do}

  Continue := False;
  Quit := False;

  If CancelImport
    then MessageDlg('The import has been cancelled.' + #13 +
                    'No pictures have been transferred or deleted.',
                    mtWarning, [mbOK], 0)
    else
      If (MessageDlg('Do you want to import the ' + IntToStr(TotalNumberPicturesToImport) +
                     ' valid pictures in this batch?' + #13 +
                     '(In addition, ' + IntToStr(TotalNumberPicturesToDelete) +
                     ' pictures will be deleted.', mtConfirmation, [mbYes, mbNo], 0) = idYes)
        then
          begin
            ImportThePictures(PictureActionList, PicturesLoadedList, PicturesDeletedList,
                              PicturesNotLoadedList, Quit);

            If not Quit
              then Continue := True;

          end;  {If (MessageDlg('Do you want ...}

    {If continue, then check for more files to import.
     If there are more, then go through the process again.
     If not, then print out the results.}

  If Continue
    then
      begin
        LoadPicturesForPreview;

        If (PicturesThisBatch = 0)
          then
            begin
              PrintSubHeader := True;
              ReportCancelled := False;

              For I := 0 to (PicturesPerBatch - 1) do
                begin
                  TempComponentName := 'ItemPanel' + IntToStr(I + 1);
                  TPanel(FindComponent(TempComponentName)).Visible := False;
                end;

              PrintThePictureReport;

            end;  {If (PicturesThisBatch = 0)}

      end;  {If Continue}

  ImportButton.Enabled := True;
  PictureActionList.Free;

end; {ImportButtonClick}

{===================================================================}
Function TImportPicturesFromLoadingDockForm.CheckPictureFileName(NewFileName : String) : Boolean;

var
  ErrorType : Integer;
  ErrorMessage : String;

begin
  Result := True;

  If FileExists(NewFileName)
    then
      begin
        Result := False;
        MessageDlg('A file already exists with that name.' + #13 +
                   'Please choose a different name.',
                   mtError, [mbOK], 0);
      end
    else
      If FileExistsInPictureDirectory(NewFileName, GlblPictureDir, 'main', ErrorMessage, ErrorType)
        then
          begin
            Result := False;
            MessageDlg('A picture with the new name already exists in the main picture directory.' + #13 +
                       'Please enter a different name.', mtError, [mbOK], 0);
          end
        else
          If FileExistsInPictureDirectory(NewFileName, DirectoryEdit.Text,
                                          'loading dock', ErrorMessage, ErrorType)
            then
              begin
                Result := False;
                MessageDlg('A picture with the new name already exists in the loading dock picture directory.' + #13 +
                           'Please enter a different name.', mtError, [mbOK], 0);
              end
            else
              begin
                LockWindowUpdate(Handle);
                Image.ImageName := '';
                EditFileName.ReadOnly := False;
                EditFileName.Text := NewFileName;
                EditFileName.ReadOnly := True;
                ChDir(AddDirectorySlashes(DirectoryEdit.Text));
                RenameFile(RenameDialogBox.OriginalFileName, NewFileName);
                Image.ImageName := EditFileName.Text;
                LockWindowUpdate(0);

                ItemPanel.Color := clBtnFace;
                ErrorPanel.Caption := '';
                ImportActionRadioGroup.ItemIndex := acTransfer;
                ErrorPanel.Visible := False;
                SetImportPictureCaption;

              end;  {else of If FileExistsInMainPictureDirectory...}

end;  {CheckPictureFileName}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.RenameButtonClick(Sender: TObject);

var
  Index, ErrorType : Integer;
  SwisSBLKey, ErrorMessage, PictureNote : String;
  Error : Boolean;

begin
  Index := DeterminePanelNumberForComponentName(TComponent(Sender).Name);

  GetComponentsForThisPicturePanel(Index);

  RenameDialogBox.OriginalFileName := EditFileName.Text;
  RenameDialogBox.NewFileName := EditFileName.Text;

    {In order to rename the file, we have to make sure that the file does not
     already exist.  If it is OK, then disable the image, rename the file and
     then reset the image.  Then, review for errors again.}

  If RenameDialogBox.Execute
    then
      begin
        CheckPictureFileName(RenameDialogBox.NewFileName);

        If not ErrorPanel.Visible
          then
            begin
              GetComponentsForThisPicturePanel(Index);
              GetParcelIDForPictureName(EditFileName.Text, SwisSBLKey,
                                        PictureNote, Error, ErrorMessage, ErrorType);

              If (Deblank(EditParcelID.Text) = '')
                then
                  If Error
                    then
                      begin
                        ItemPanel.Color := $007C59E6;
                        ErrorPanel.Visible := True;
                        ErrorPanel.Caption := ErrorMessage;
                        ImportActionRadioGroup.ItemIndex := acLeaveInDirectory;

                      end
                    else
                      begin
                        EditParcelID.ReadOnly := False;
                        EditParcelID.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
                        EditParcelID.ReadOnly := True;
                        ItemPanel.Color := clBtnFace;
                        ErrorPanel.Caption := '';
                        ErrorPanel.Visible := False;
                        ImportActionRadioGroup.ItemIndex := acTransfer;
                        SetImportPictureCaption;

                      end;  {else of If Error}

            end;  {If not ErrorPanel.Visible}

      end;  {If RenameDialogBox.Execute}

end;  {RenameButtonClick}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.LocateButtonClick(Sender: TObject);

var
  Index : Integer;
  SwisSBLKey : String;
  ValidEntry : Boolean;

begin
  Index := DeterminePanelNumberForComponentName(TComponent(Sender).Name);

  GetComponentsForThisPicturePanel(Index);

    {Let them locate another parcel to go with this picture.}

  If (Deblank(EditParcelID.Text) = '')
    then SwisSBLKey := ''
    else SwisSBLKey := ConvertSwisDashDotToSwisSBL(EditParcelID.Text, SwisCodeTable,
                                                   ValidEntry);

  If ValidEntry
    then
      begin
        GlblLastLocateInfoRec.LastLocatePage := 'P';
        GlblLastLocateInfoRec.LastSwisSBLKey := SwisSBLKey;
        GlblLastLocateInfoRec.LastLocateKey := lcpParcelID;
      end
    else SwisSBLKey := '';

  If ExecuteParcelLocateDialog(SwisSBLKey, True, False, 'Choose Parcel for Picture',
                               False, nil)
    then
      begin
        EditParcelID.ReadOnly := False;
        EditParcelID.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
        EditParcelID.ReadOnly := True;
        ItemPanel.Color := clBtnFace;
        ErrorPanel.Caption := '';
        ErrorPanel.Visible := False;
        ImportActionRadioGroup.ItemIndex := acTransfer;
        SetImportPictureCaption;

      end;  {If ExecuteParcelLocateDialog}

end;  {LocateButtonClick}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;  {CloseButtonClick}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.FormCloseQuery(    Sender: TObject;
                                                            var CanClose: Boolean);

var
  I, ActionThisPicture, TotalNumberPicturesToImport : Integer;

begin
  PrintPicturesNotLoaded := ReportFilesNotLoadedCheckBox.Checked;
  TotalNumberPicturesToImport := 0;

     {When we go to close the form, make sure that all current items in the batch are in the
      picture action list.}

  For I := 1 to PicturesThisBatch do
    begin
      GetComponentsForThisPicturePanel(I);
      ActionThisPicture := ImportActionRadioGroup.ItemIndex;

      If (ActionThisPicture = acLeaveInDirectory)
        then AddOnePictureListItem(PicturesNotLoadedList, '', EditFileName.Text, '', acLeaveInDirectory);

      If (ActionThisPicture = acTransfer)
        then TotalNumberPicturesToImport := TotalNumberPicturesToImport + 1;

    end;  {For I := 1 to PicturesPerBatch do}

  If (TotalNumberPicturesToImport > 0)
    then ImportButtonClick(Sender);

  If (ImportDone and
      (not PicturesPrinted) and
      ((PicturesLoadedList.Count > 0) or
       (PicturesNotLoadedList.Count > 0) or
       (PicturesDeletedList.Count > 0)))
    then
      begin
        MessageDlg('Before you exit a report will print detailing the pictures that you imported.', mtInformation, [mbOK], 0);
        PrintThePictureReport;
      end;

  CanClose := True;

end;  {FormCloseQuery}

{===================================================================}
Procedure TImportPicturesFromLoadingDockForm.FormClose(    Sender: TObject;
                                                       var Action: TCloseAction);

begin
  FreeTList(PicturesLoadedList, SizeOf(PictureListRecord));
  FreeTList(PicturesNotLoadedList, SizeOf(PictureListRecord));
  FreeTList(PicturesDeletedList, SizeOf(PictureListRecord));

  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.