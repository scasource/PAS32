unit PDocumnt;

interface

uses
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, Printers, ExtDlgs, TMultiP, SysUtils,
  OleCtnrs, OleServer, Word97, Excel97, Forms, COMObj,
  OleCtrls, (*WordPerfect_TLB, *) MMOpen, ShellAPI, Umu_scan;

type
  TDocumentForm = class(TForm)
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    PrintDialog: TPrintDialog;
    Timer: TTimer;
    MainDataSource: TwwDataSource;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    InactiveLabel: TLabel;
    DocumentLookupTable: TTable;
    MainTableSwisSBLKey: TStringField;
    MainTableDocumentNumber: TIntegerField;
    MainTableDocumentLocation: TStringField;
    MainTableDate: TDateField;
    MainTableDocumentType: TIntegerField;
    DocumentTypeTable: TwwTable;
    DocumentDialog: TOpenDialog;
    WordApplication: TWordApplication;
    WordDocument: TWordDocument;
    PartialAssessmentLabel: TLabel;
    ExcelApplication: TExcelApplication;
    OLEItemNameTimer: TTimer;
    MainTableDocumentTypeDescription: TStringField;
    MainTableNotes: TStringField;
    MainTableVisibleToSearcher: TBooleanField;
    HeaderPanel: TPanel;
    Label4: TLabel;
    OwnerLabel: TLabel;
    LocationLabel: TLabel;
    EditSBL: TMaskEdit;
    EditName: TDBEdit;
    EditLocation: TEdit;
    Panel5: TPanel;
    DocumentGrid: TwwDBGrid;
    FooterPanel: TPanel;
    NewDocumentButton: TBitBtn;
    DeleteDocumentButton: TBitBtn;
    SaveButton: TBitBtn;
    FullScreenButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel3: TPanel;
    Notebook: TNotebook;
    ImagePanel: TPanel;
    ImageScrollBox: TScrollBox;
    Image: TPMultiImage;
    Panel6: TPanel;
    ScrollBox1: TScrollBox;
    OleContainer: TOleContainer;
    OleWordDocumentTimer: TTimer;
    OpenScannedImageDialog: TMMOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    OpenPDFDialog: TOpenDialog;
    btnScan: TBitBtn;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterDelete(DataSet: TDataset);
    procedure MainTableAfterInsert(DataSet: TDataset);
    procedure MainDataSourceDataChange(Sender: TObject; Field: TField);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure FullScreenButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MainTableNewRecord(DataSet: TDataset);
    procedure WordApplicationQuit(Sender: TObject);
    procedure WordDocumentClose(Sender: TObject);
    procedure MainTableAfterPost(DataSet: TDataSet);
    procedure ExcelApplicationWorkbookBeforeClose(Sender: TObject; var Wb,
      Cancel: OleVariant);
    procedure OLEItemNameTimerTimer(Sender: TObject);
    procedure NewDocumentButtonClick(Sender: TObject);
    procedure DeleteDocumentButtonClick(Sender: TObject);
    procedure MainTableCalcFields(DataSet: TDataSet);
    procedure SaveButtonClick(Sender: TObject);
    procedure OleWordDocumentTimerTimer(Sender: TObject);
    procedure DocumentGridKeyPress(Sender: TObject; var Key: Char);
    procedure btnScanClick(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}
    DocumentActive : Boolean;

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    SwisSBLKey : String;
    DocumentTypeSelected : Integer;

    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    lcID : Integer;  {Reference ID number for created Excel worksheet.}
    CurrentDocumentName : String;

    Procedure InitializeForm;

    Procedure SetScrollBars;
    {Set the scroll bars for this imags height.}

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     DocumentTypeDialog, GlblCnst, Fullscrn, UtilOLE, DataAccessUnit;

{$R *.DFM}

{=====================================================================}
Procedure TDocumentForm.SetScrollBars;

{Set the scroll bars for this imags height.}

var
  TempHeight, ZoomPercent : Integer;

begin
  If ((Deblank(Image.ImageName) = '') or
      (Image.ImageName = 'file not found'))
    then ImageScrollBox.VertScrollBar.Range := 0
    else
      begin
        Image.GetInfoAndType(Image.ImageName);
        ZoomPercent := Trunc((Image.Width / Image.BWidth) * 100);

        TempHeight := Trunc(Image.BHeight * (ZoomPercent / 100));
        ImageScrollBox.VertScrollBar.Range := TempHeight;
        ImageScrollBox.Height := TempHeight;
        Image.Height := TempHeight;

      end;  {If ((Deblank(Image.ImageName) = '') or ...}

end;  {SetScrollBars}

{=====================================================================}
Procedure TDocumentForm.CreateParams(var Params: TCreateParams);

begin
  inherited CreateParams(Params);

  with Params do
    Style := (Style or WS_Child) and not WS_Popup;

end;  {CreateParams}

{====================================================================}
Procedure TDocumentForm.InitializeForm;

begin
  DocumentActive := False;
  UnitName := 'PDOCUMNT.PAS';  {mmm1}
  ClosingForm := False;
  FormIsInitializing := True;

  If (Deblank(SwisSBLKey) <> '')
    then
      begin
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then MainTable.ReadOnly := True;

          {If this is inquire let's open it in
           readonly mode. Hist access is blocked at menu level}

        If (EditMode = 'V')
          then MainTable.ReadOnly := True;

        DocumentTypeTable.Open;

        OpenTablesForForm(Self, GlblProcessingType);

        If not _Locate(ParcelTable, [GetTaxRlYr, SwisSBLKey], '', [loParseSwisSBLKey])
          then SystemSupport(003, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        _SetRange(MainTable, [SwisSBLKey, 0], [SwisSBLKey, 32000], '', []);

          {CHG11072002-1: Allow some of the links to not be seen by searchers.}

        If GlblUserIsSearcher
          then
            begin
              MainTable.Filter := 'VisibleToSearcher = True';
              MainTable.Filtered := True;
            end;

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

        case EditMode of   {mmm5}
          'A' : TitleLabel.Caption := 'Document Add';
          'M' : TitleLabel.Caption := 'Document Modify';
          'V' : TitleLabel.Caption := 'Document View';

        end;  {case EditMode of}

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

        case EditMode of
          'V' : begin
                  DeleteDocumentButton.Enabled := False;
                  NewDocumentButton.Enabled := False;
                end;  {Inquire}

        end;  {case EditMode of}

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
        SetTaxYearLabelForProcessingType(YearLabel, GlblProcessingType);

          {FXX12101997-1: Make sure that all pages have the inactive label.}

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  FormIsInitializing := False;
  Timer.Enabled := True;

end;  {InitializeForm}

{=======================================================================}
Procedure TDocumentForm.TimerTimer(Sender: TObject);

{Load the image on a delay so that the page appears first.}

begin
  Timer.Enabled := False;
  DocumentGrid.SetFocus;
  MainDataSourceDataChange(Sender, nil);

end;  {TimerTimer}

{================================================================}
Procedure TDocumentForm.MainTableCalcFields(DataSet: TDataSet);

begin
    {Display the document type.}

  _Locate(DocumentTypeTable, [MainTable.FieldByName('DocumentType').Text], '', []);
  MainTable.FieldByName('DocumentTypeDescription').Text := DocumentTypeTable.FieldByName('ApplicationName').Text;

end;  {MainTableCalcFields}

{================================================================}
Procedure TDocumentForm.NewDocumentButtonClick(Sender: TObject);

begin
  try
    MainTable.Insert;
  except
    SystemSupport(004, MainTable, 'Error putting Document Table in insert mode.',
                  UnitName, GlblErrorDlgBox);
  end;

end;  {NewDocumentButtonClick}

{================================================================}
Procedure TDocumentForm.DeleteDocumentButtonClick(Sender: TObject);

begin
    {CHG05042004-1(2.07l4): Option to delete the physical document.}

  If (MessageDlg('Are you sure you want to delete the link to this document?', mtConfirmation,
                 [mbYes, mbNo], 0) = idYes)
    then
      try
        If (MessageDlg('Do you want to delete the actual document also?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            try
              DeleteFile(PChar(MainTable.FieldByName('DocumentLocation').Text));
            except
              MessageDlg('There was an error deleting the document.' + #13 +
                         'Please remove it manually.', mtError, [mbOK], 0);
            end
          else MessageDlg('Please note that only the link was deleted, not the actual document.', mtWarning, [mbOK], 0);

        MainTable.Delete;

      except
        SystemSupport(005, MainTable, 'Error deleting document link.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {DeleteDocumentButtonClick}

{=======================================================================}
Procedure TDocumentForm.MainTableNewRecord(DataSet: TDataset);

{FXX11191999-15: Default to the next Document number.}

var
  NextDocumentNumber : Integer;

begin
  If not FormIsInitializing
    then
      try
        DocumentTypeDialogForm := TDocumentTypeDialogForm.Create(nil);

        DocumentTypeDialogForm.ShowModal;

          {FXX03292011-1(2.26.1.48)[I8734]: Default the next document number in the case of a blank document #.}
          
        NextDocumentNumber := 90;

        If (DocumentTypeDialogForm.ModalResult = idOK)
          then
            begin
              _SetRange(DocumentLookupTable, [SwisSBLKey, 0], [SwisSBLKey, 32000], '', []);

              DocumentLookupTable.First;

              If DocumentLookupTable.EOF
                then NextDocumentNumber := 1
                else
                  begin
                    DocumentLookupTable.Last;

                    try
                      NextDocumentNumber := DocumentLookupTable.FieldByName('DocumentNumber').AsInteger + 1;
                    except
                      NextDocumentNumber := 90;
                    end;

                  end;  {If DocumentLookupTable.EOF}

              MainTable.FieldByName('DocumentNumber').AsInteger := NextDocumentNumber;
              MainTableDate.AsDateTime := Date;

              DocumentTypeSelected := DocumentTypeDialogForm.DocumentTypeSelected;

            end;  {If (DocumentTypeDialogForm.ModalResult = idOK)}

      finally
        DocumentTypeDialogForm.Free;
      end;

end;  {MainTableNewRecord}

{=======================================================================}
Procedure TDocumentForm.MainTableAfterInsert(DataSet: TDataset);

var
  QuattroPro : Variant;
  _Selection : Selection;
  TempParcelTable, NYParcelTable : TTable;
  InsertNameAndAddress : Boolean;
  NAddrArray : NameAddrArray;
  I : Integer;
  TempMemo : TMemo;

begin
  NYParcelTable := nil;
  If not FormIsInitializing
    then
      NYParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                              NextYear);

      case DocumentTypeSelected of
        dtOpenScannedImage :
          begin
            If OpenScannedImageDialog.Execute
              then
                begin
                  MainTableDocumentLocation.Text := OpenScannedImageDialog.FileName;
                  MainTable.FieldByName('DocumentType').AsInteger := dtScannedImage;
                  MainDataSourceDataChange(Dataset, nil);
                end
              else MainTable.Cancel;

          end;  {dtOpenScannedImage}

        dtOpenWordDocument :
          begin
            DocumentDialog.Filter := 'MS Word documents|*.doc|All Files|*.*';

            If DocumentDialog.Execute
              then
                begin
                  MainTableDocumentLocation.Text := DocumentDialog.FileName;
                  MainTable.FieldByName('DocumentType').AsInteger := dtMSWord;
                  MainDataSourceDataChange(Dataset, nil);
                end
              else MainTable.Cancel;

          end;  {dtOpenWordDocument}

        dtCreateWordDocument :
          try
            MainTable.FieldByName('DocumentType').AsInteger := dtMSWord;

            InsertNameAndAddress := (MessageDlg('Do you want to insert the current name and address of this parcel?',
                                     mtConfirmation, [mbYes, mbNo], 0) = idYes);

            CreateWordDocument(WordApplication, WordDocument);

            with WordApplication do
              begin
                  {CHG04022002-1: Give them the option of inserting the name and address.}

                If InsertNameAndAddress
                  then
                    begin
                      _Selection := WordApplication.Selection;

                        {If it does not exist in NY, use the main parcel table.}

                      If _Locate(NYParcelTable, [GetTaxRlYr, SwisSBLKey], '', [loParseSwisSBLKey])
                        then TempParcelTable := NYParcelTable
                        else TempParcelTable := ParcelTable;

                      GetNameAddress(TempParcelTable, NAddrArray);

                      For I := 1 to 6 do
                        If (Deblank(NAddrArray[I]) <> '')
                          then
                            begin
                              _Selection.TypeText(NAddrArray[I]);
                              _Selection.TypeParagraph;
                            end;

                    end;  {InsertNameAndAddress}

                DocumentActive := True;
                CurrentDocumentName := '';
                GlblApplicationIsActive := False;
                OLEItemNameTimer.Enabled := True;

              end;  {with WordApplication do}

          except
            MessageDlg('Sorry, there was an problem linking with Word.' + #13 +
                       'Please try again.', mtError, [mbOK], 0);
            MainTable.Cancel;
          end;  {dtCreateWordDocument}

        dtOpenExcelSpreadsheet :
          begin
            DocumentDialog.Filter := 'Excel spreadsheets|*.xls|All Files|*.*';

            If DocumentDialog.Execute
              then
                begin
                  MainTableDocumentLocation.Text := DocumentDialog.FileName;
                  MainTable.FieldByName('DocumentType').AsInteger := dtExcel;
                  MainDataSourceDataChange(Dataset, nil);
                end
              else MainTable.Cancel;

          end;  {dtOpenExcelSpreadsheet}

        dtCreateExcelSpreadsheet :
          try
            MainTable.FieldByName('DocumentType').AsInteger := dtExcel;

            CreateExcelDocument(ExcelApplication, lcID);
            DocumentActive := True;
            CurrentDocumentName := '';
            GlblApplicationIsActive := False;
            OLEItemNameTimer.Enabled := True;

          except
            MessageDlg('Sorry, there was an problem linking with Excel.' + #13 +
                       'Please try again.', mtError, [mbOK], 0);
            MainTable.Cancel;
          end;  {dtCreateExcelSpreadsheet}

        dtOpenWordPerfectDocument :
          begin
            DocumentDialog.Filter := 'Word Perfect documents|*.wpd|All Files|*.*';

            If DocumentDialog.Execute
              then
                begin
                  MainTableDocumentLocation.Text := DocumentDialog.FileName;
                  MainTable.FieldByName('DocumentType').AsInteger := dtWordPerfect;
                  MainDataSourceDataChange(Dataset, nil);
                end
              else MainTable.Cancel;

          end;  {dtOpenWordPerfectDocument}

        dtCreateWordPerfectDocument :
          begin
              {CHG04022002-1: Give them the option of inserting the name and address.}

            InsertNameAndAddress := (MessageDlg('Do you want to insert the current name and address of this parcel?',
                                     mtConfirmation, [mbYes, mbNo], 0) = idYes);

(*            PerfectScript.Connect;*)

            If InsertNameAndAddress
              then
                begin
                    {If it does not exist in NY, use the main parcel table.}

                  If _Locate(NYParcelTable, [GetTaxRlYr, SwisSBLKey], '', [loParseSwisSBLKey])
                    then TempParcelTable := NYParcelTable
                    else TempParcelTable := ParcelTable;

                  GetNameAddress(TempParcelTable, NAddrArray);

                    {For WordPerfect, we have to copy to the clipboard and
                     then paste.  To do this, we will fill in the name
                     and address into a memo, copy it to the clipboard
                     and then paste.}

                  TempMemo := TMemo.Create(Self);
                  TempMemo.ParentWindow := Self.Handle;
                  TempMemo.Lines.Clear;

                  For I := 1 to 6 do
                    If (Deblank(NAddrArray[I]) <> '')
                      then TempMemo.Lines.Add(NAddrArray[I]);

                  TempMemo.SelectAll;
                  TempMemo.CopyToClipboard;

(*                  PerfectScript.Paste;*)

                  TempMemo.Free;

                end;  {InsertNameAndAddress}

(*            PerfectScript.AppMaximize;

            PerfectScript.Disconnect;
            OLEItemNameTimer.Enabled := True;*)

          end;  {dtCreateWordPerfectDocument}

        dtOpenQuattroProSpreadsheet :
          begin
            DocumentDialog.Filter := 'Quattro Pro notebooks|*.qpw|All Files|*.*';

            If DocumentDialog.Execute
              then
                begin
                  MainTableDocumentLocation.Text := DocumentDialog.FileName;
                  MainTable.FieldByName('DocumentType').AsInteger := dtQuattroPro;
                  MainDataSourceDataChange(Dataset, nil);
                end
              else MainTable.Cancel;

          end;  {dtOpenQuattroProSpreadsheet}

        dtCreateQuattroProSpreadsheet :
          begin
            try
              QuattroPro := GetActiveOleObject('QuattroPro.PerfectScript');
            except
              QuattroPro := CreateOleObject('QuattroPro.PerfectScript');
            end;

            QuattroPro.WindowQPW_Maximize;
            QuattroPro.Quit;

            QuattroPro := unassigned;

          end;  {dtCreateQuattroProSpreadsheet}

        dtOpenPDFDocument :
          If OpenPDFDialog.Execute
            then
              begin
                MainTable.FieldByName('DocumentLocation').AsString := OpenPDFDialog.FileName;
                MainTable.FieldByName('DocumentType').AsInteger := dtAdobePDF;
                MainDataSourceDataChange(Dataset, nil);
              end
            else MainTable.Cancel;

      end;  {case DocumentTypeSelected of}

end;  {MainTableAfterInsert}

{=================================================================}
Procedure TDocumentForm.OleWordDocumentTimerTimer(Sender: TObject);

{FXX03152004-2(2.08): Make it so that Word documents show in the OLE container.}

begin
  OleWordDocumentTimer.Enabled := False;
  OleContainer.SetFocus;
  OleContainer.DoVerb(ovShow);
end;  {OleWordDocumentTimerTimer}

{=================================================================}
Procedure TDocumentForm.MainDataSourceDataChange(Sender: TObject;
                                                 Field: TField);

var
  FileName : String;

begin
  If ((not FormIsInitializing) and
      (Field = nil))
    then
      begin
        Cursor := crHourglass;

          {FXX07272001-2: If the data is downloaded from a network to a portable,
                          try to find the pictures on the local drive.}

        If (Deblank(MainTable.FieldByName('DocumentLocation').Text) <> '')
          then
            case MainTable.FieldByName('DocumentType').AsInteger of
              0,
              dtScannedImage :
                begin
                  Notebook.PageIndex := 0;

                  try
                    If FileExists(MainTableDocumentLocation.Text)
                      then Image.ImageName := MainTableDocumentLocation.Text
                      else Image.ImageName := ChangeLocationToLocalDrive(MainTableDocumentLocation.Text);
                  except
                    MessageDlg('Unable to connect to scanned image ' +
                               MainTableDocumentLocation.Text + '.',
                               mtError, [mbOK], 0);
                  end;

                  SetScrollBars;

                end;  {dtScannedImage}

              dtMSWord,
              dtExcel,
              dtWordPerfect,
              dtQuattroPro :
                begin
                  Notebook.PageIndex := 1;

                  If FileExists(MainTableDocumentLocation.Text)
                    then FileName := MainTableDocumentLocation.Text
                    else FileName := ChangeLocationToLocalDrive(MainTableDocumentLocation.Text);

                    {FXX03152004-2(2.08): Make it so that Word documents show in the OLE container.}

(*                  with OleContainer do
                    If (MainTable.FieldByName('DocumentType').AsInteger = dtMSWord)
                      then
                        begin
                          AllowActiveDoc := True;
                          AutoActivate := aaGetFocus;
                        end
                      else
                        begin
                          AllowActiveDoc := False;
                          AutoActivate := aaManual;
                        end;  {else of If (MainTable.FieldByName('DocumentType').AsInteger = dtMSWord)} *)

                  OleContainer.CreateObjectFromFile(MainTableDocumentLocation.Text, False);

                  If (MainTable.FieldByName('DocumentType').AsInteger = dtMSWord)
                    then OleWordDocumentTimer.Enabled := True;

                end;  {dtMSWord}

              dtAdobePdf : Notebook.PageIndex := 2;

            end;  {case MainTable.FieldByName('DocumentType').AsInteger of}

        Cursor := crDefault;

      end;  {If ((not FormIsInitializing) and}

end;  {MainDataSourceDataChange}

{===============================================================}
Procedure TDocumentForm.WordApplicationQuit(Sender: TObject);

begin
  DocumentActive := False;
end;

{===============================================================}
Procedure TDocumentForm.WordDocumentClose(Sender: TObject);

begin
  If not WordDocument.Saved
    then WordDocument.Save;

  If (MainTable.State in [dsEdit, dsInsert])
    then MainTable.FieldByName('DocumentLocation').Text := WordDocument.FullName;

  DocumentActive := False;

end;  {WordDocumentClose}

{===============================================================}
Procedure TDocumentForm.ExcelApplicationWorkbookBeforeClose(    Sender: TObject;
                                                            var Wb, Cancel: OleVariant);

begin
  If not ExcelApplication.ActiveWorkbook.Saved[lcID]
    then ExcelApplication.ActiveWorkbook.Save(lcID);

  If (MainTable.State in [dsEdit, dsInsert])
    then MainTable.FieldByName('DocumentLocation').Text := ExcelApplication.ActiveWorkbook.FullName[lcID];

  DocumentActive := False;

end;  {ExcelApplicationWorkbookBeforeClose}

{=================================================================}
Procedure TDocumentForm.FullScreenButtonClick(Sender: TObject);

var
  FullScreenForm : TFullScreenViewForm;
  FileName : OLEVariant;
  QuattroPro : Variant;

begin
  OleContainer.DestroyObject;
  FileName := MainTable.FieldByName('DocumentLocation').Text;
  FullScreenForm := nil;

  case MainTable.FieldByName('DocumentType').AsInteger of
    0,
    dtScannedImage :
      try
        FullScreenForm := TFullScreenViewForm.Create(self);
        FullScreenForm.Image.ImageName := MainTable.FieldByName('DocumentLocation').AsString;
        FullScreenForm.Image.ImageLibPalette := False;
        FullScreenForm.ShowModal;
      finally
        FullScreenForm.Free;
      end;

    dtMSWord : OpenWordDocument(WordApplication, WordDocument, FileName);

    dtExcel : OpenExcelDocument(ExcelApplication, lcID, FileName);

    dtWordPerfect :
      begin
(*        PerfectScript.Connect;
        PerfectScript.FileOpen(FileName, 0);
        PerfectScript.AppMaximize;
        PerfectScript.Disconnect;*)

      end;  {dtWordPerfect}

    dtQuattroPro :
      begin
        try
          QuattroPro := GetActiveOleObject('QuattroPro.PerfectScript');
        except
          QuattroPro := CreateOleObject('QuattroPro.PerfectScript');
        end;

        QuattroPro.FileOpen(FileName, 0);
        QuattroPro.WindowQPW_Maximize;
        QuattroPro.Quit;

        QuattroPro := unassigned;

      end;  {dtQuattroPro}

    dtAdobePdf : ShellExecute(0, 'open',
                              PChar(MainTable.FieldByName('DocumentLocation').AsString),
                              nil, nil, SW_NORMAL);

  end;  {case MainTable.FieldByName('DocumentType').AsInteger of}

end;  {FullScreenButtonClick}

{=======================================================================}
Procedure TDocumentForm.DocumentGridKeyPress(    Sender: TObject;
                                            var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        FullScreenButtonClick(Sender);
      end;

end;  {PictureGridKeyPress}

{=======================================================================}
Procedure TDocumentForm.PrintButtonClick(Sender: TObject);

var
  FileName : OLEVariant;

begin
  FileName := MainTable.FieldByName('DocumentLocation').Text;

    {FXX02181999-2: The image is printing very small.}

  case MainTable.FieldByName('DocumentType').AsInteger of
    0,
    dtScannedImage :
      If PrintDialog.Execute
        then
          begin
            Printer.Refresh;
            PrintImage(Image, Handle, 0, 0, Printer.PageWidth, Printer.PageHeight,
                       0, 999, True);

          end;  {If PrintDialog.Execute}

    dtMSWord : PrintWordDocument(WordApplication, WordDocument, FileName);

    dtExcel : PrintExcelDocument(ExcelApplication, lcID, FileName);

    dtWordPerfect :
      begin
(*        PerfectScript.Connect;
        PerfectScript.FileOpen(FileName, 0);
        PerfectScript.WPPrint(FullDocument_WPPrint_Action);
        PerfectScript.Disconnect;*)

      end;  {dtWordPerfect}

    dtQuattroPro :
      begin
      end;  {dtQuattroPro}

  end;  {case MainTable.FieldByName('DocumentType').AsInteger of}

end;  {PrintButtonClick}

{==============================================================}
Procedure TDocumentForm.MainTableAfterDelete(DataSet: TDataset);

{After a delete, we should always reset the range.}

begin
  MainTable.DisableControls;
  MainTable.CancelRange;
  _SetRange(MainTable, [SwisSBLKey, 0], [SwisSBLKey, 32000], '', []);
  MainTable.EnableControls;

end;  {MainTableAfterDelete}

{==============================================================}
Procedure TDocumentForm.MainTableBeforePost(DataSet: TDataset);

{If this is insert state, then fill in the SBL key and the
 tax roll year.}

var
  ReturnCode : Integer;

begin
  If ((not FormIsInitializing) and
      (MainTable.State = dsInsert))
    then
      begin
        MainTable.FieldByName('SwisSBLKey').Text := Take(26, SwisSBLKey);

          {If they are linked to an OLE server, make sure the file name
           is filled in.}

        with MainTable do
          case FieldByName('DocumentType').AsInteger of
            dtMSWord :
              If DocumentActive
                then WordDocumentClose(DataSet);

            dtExcel :

          end;  {case FieldByName('DocumentType').AsInteger of}

         {FXX05151998-3: Don't ask save on close form if don't want to see save.}

        If GlblAskSave
          then
            begin
                 {FXX11061997-2: Remove the "save before exiting" prompt because it
                                 is confusing. Use only "Do you want to save.}

              ReturnCode := MessageDlg('Do you wish to save your document changes?', mtConfirmation,
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

{====================================================================}
Procedure TDocumentForm.SaveButtonClick(Sender: TObject);

begin
  If (MainTable.State in [dsEdit, dsInsert])
    then
      try
        MainTable.Post;
      except
        SystemSupport(006, MainTable, 'Error posting document link.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {SaveButtonClick}

{==============================================================}
Procedure TDocumentForm.MainTableAfterPost(DataSet: TDataSet);

{Refresh any OLE links.}

begin
  with MainTable do
    case FieldByName('DocumentType').AsInteger of
      dtMSWord :
        If DocumentActive
          then WordDocument.Close;

    end;  {case FieldByName('DocumentType').AsInteger of}

  DocumentActive := False;

  MainDataSourceDataChange(Dataset, nil);

end;  {MainTableAfterPost}

{==============================================================}
Procedure TDocumentForm.FormResize(Sender: TObject);

var
  BottomButtonsTotalWidth, BottomButtonsInterval : LongInt;

begin
  If not FormIsInitializing
    then
      begin
        BottomButtonsTotalWidth := NewDocumentButton.Width +
                                   DeleteDocumentButton.Width +
                                   SaveButton.Width +
                                   FullScreenButton.Width +
                                   PrintButton.Width +
                                   CloseButton.Width;

        BottomButtonsInterval := (FooterPanel.Width - BottomButtonsTotalWidth) DIV 7;

        DeleteDocumentButton.Left := NewDocumentButton.Left + NewDocumentButton.Width + BottomButtonsInterval;
        SaveButton.Left := DeleteDocumentButton.Left + DeleteDocumentButton.Width + BottomButtonsInterval;
        FullScreenButton.Left := SaveButton.Left + SaveButton.Width + BottomButtonsInterval;
        PrintButton.Left := FullScreenButton.Left + FullScreenButton.Width + BottomButtonsInterval;
        CloseButton.Left := PrintButton.Left + PrintButton.Width + BottomButtonsInterval;

        LocationLabel.Left := HeaderPanel.Width - 218;
        EditLocation.Left := HeaderPanel.Width - 166;

        EditName.Left := (HeaderPanel.Width - EditName.Width) DIV 2;
        OwnerLabel.Left := EditName.Left - 40;

      end;  {If not FormIsInitializing}

end;  {FormResize}

{==============================================================}
Procedure TDocumentForm.OLEItemNameTimerTimer(Sender: TObject);

{Keep checking for the document name until they return to the application.}

begin
  If GlblApplicationIsActive
    then
      begin
        OLEItemNameTimer.Enabled := False;
        MainDataSourceDataChange(MainTable, nil);
      end
    else
      begin
        If (MainTable.State in [dsEdit, dsInsert])
          then
            try
              case MainTable.FieldByName('DocumentType').AsInteger of
                dtMSWord : MainTable.FieldByName('DocumentLocation').Text := WordDocument.FullName;
                dtExcel : MainTable.FieldByName('DocumentLocation').Text := ExcelApplication.ActiveWorkbook.FullName[lcID];

                dtWordPerfect :
                  begin
(*                    PerfectScript.Connect;
                    MainTable.FieldByName('DocumentLocation').Text := PerfectScript.envPath +
                                                                      PerfectScript.envName;
                    PerfectScript.Disconnect;*)

                      {We do not have an event to catch the close of the document, so
                       turn off the timer when the location has a value.}

                    If (Deblank(MainTable.FieldByName('DocumentLocation').Text) <> '')
                      then GlblApplicationIsActive := False;

                  end;  {dtWordPerfect}

              end;  {case MainTable.FieldByName('DocumentType').AsInteger of}
            except
            end;

      end;  {If GlblApplicationIsActive}

end;  {OLEItemNameTimerTimer}

{==============================================================}
Procedure TDocumentForm.CloseButtonClick(Sender: TObject);

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
Procedure TDocumentForm.FormCloseQuery(    Sender: TObject;
                                         var CanClose: Boolean);

begin
  CanClose := True;
  ClosingForm := True;
  GlblParcelPageCloseCancelled := False;

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

  If (((EditMode = 'M') or
       (EditMode = 'A')) and
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
Procedure TDocumentForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
    {Close all tables here.}

  CloseTablesForForm(Self);

  Action := caFree;

end;  {FormClose}

procedure TDocumentForm.btnScanClick(Sender: TObject);
begin
  TwainForm.ShowModal;
end;

end.