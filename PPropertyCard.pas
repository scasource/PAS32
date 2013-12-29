unit PPropertyCard;

interface

uses
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Dialogs, DB, Grids, DBGrids,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, Printers, ExtDlgs, TMultiP, SysUtils, Forms,
  MMOpen, IlDocImg, ShellAPI;

type
  Tfm_PropertyCard = class(TForm)
    tb_Main: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    ds_Parcel: TDataSource;
    tb_Parcel: TTable;
    YearLabel: TLabel;                  
    dlg_Print: TPrintDialog;
    ds_Main: TwwDataSource;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    InactiveLabel: TLabel;
    PartialAssessmentLabel: TLabel;
    HeaderPanel: TPanel;
    Label4: TLabel;
    OwnerLabel: TLabel;
    LocationLabel: TLabel;
    ed_SBL: TMaskEdit;
    ed_Name: TDBEdit;
    ed_Location: TEdit;
    Panel5: TPanel;
    DocumentGrid: TwwDBGrid;
    ImagePanel: TPanel;
    sb_Image: TScrollBox;
    FooterPanel: TPanel;
    btn_NewCard: TBitBtn;
    btn_DeleteCard: TBitBtn;
    btn_SaveCard: TBitBtn;
    btn_FullScreen: TBitBtn;
    btn_Print: TBitBtn;
    btn_Close: TBitBtn;
    tb_PropertyCardLookup: TTable;
    dlg_OpenScannedImage: TMMOpenDialog;
    ntbk_Main: TNotebook;
    Image: TPMultiImage;
    Label2: TLabel;
    Label1: TLabel;
    btn_CopyToClipboard: TBitBtn;
    dlg_OpenScannedImageSimple: TOpenDialog;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btn_CloseClick(Sender: TObject);
    procedure tb_MainAfterDelete(DataSet: TDataset);
    procedure tb_MainAfterInsert(DataSet: TDataset);
    procedure tb_MainBeforePost(DataSet: TDataset);
    procedure btn_FullScreenClick(Sender: TObject);
    procedure btn_PrintClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tb_MainNewRecord(DataSet: TDataset);
    procedure btn_NewCardClick(Sender: TObject);
    procedure btn_DeleteCardClick(Sender: TObject);
    procedure btn_SaveCardClick(Sender: TObject);
    procedure DocumentGridKeyPress(Sender: TObject; var Key: Char);
    procedure tb_MainAfterScroll(DataSet: TDataSet);
    procedure btn_CopyToClipboardClick(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    DocumentTypeSelected : Integer;
    UnitName : String;  {For use with error dialog box.}
    EditMode : Char;  {A = Add; M = Modify; V = View}
    SwisSBLKey : String;
    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    Procedure InitializeForm;

    Procedure SetScrollBars;
    {Set the scroll bars for this imags height.}

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, Fullscrn, DataAccessUnit;

{$R *.DFM}

{=====================================================================}
Procedure Tfm_PropertyCard.SetScrollBars;

{Set the scroll bars for this imags height.}

var
  TempHeight, ZoomPercent : Integer;

begin
  If (_Compare(Image.ImageName, coBlank) or
      _Compare(Image.ImageName, 'file not found', coEqual))
    then sb_Image.VertScrollBar.Range := 0
    else
      try
        Image.GetInfoAndType(Image.ImageName);
        ZoomPercent := Trunc((Image.Width / Image.BWidth) * 100);

        TempHeight := Trunc(Image.BHeight * (ZoomPercent / 100));
        sb_Image.VertScrollBar.Range := TempHeight;
        sb_Image.Height := TempHeight;
        Image.Height := TempHeight;
      except
      end;  {If ((Deblank(Image.ImageName) = '') or ...}

end;  {SetScrollBars}

{=====================================================================}
Procedure Tfm_PropertyCard.CreateParams(var Params: TCreateParams);

begin
  inherited CreateParams(Params);

  with Params do
    Style := (Style or WS_Child) and not WS_Popup;

end;  {CreateParams}

{====================================================================}
Procedure Tfm_PropertyCard.InitializeForm;

begin
  UnitName := 'PPropertyCard';
  ClosingForm := False;
  FormIsInitializing := True;
  dlg_OpenScannedImage.InitialDir := GlblDefaultPropertyCardDirectory;

  If _Compare(SwisSBLKey, coNotBlank)
    then
      begin
          {If this is the history file, or they do not have read access,
           then we want to set the files to read only.}

        If not ModifyAccessAllowed(FormAccessRights)
          then tb_Main.ReadOnly := True;

          {If this is inquire let's open it in
           readonly mode. Hist access is blocked at menu level}

        If _Compare(EditMode, emBrowse, coEqual)
          then tb_Main.ReadOnly := True;

        OpenTablesForForm(Self, GlblProcessingType);

        If not _Locate(tb_Parcel, [GetTaxRlYr, SwisSBLKey], '', [loParseSwisSBLKey])
          then SystemSupport(003, tb_Parcel, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

        _SetRange(tb_Main, [SwisSBLKey, 0], [SwisSBLKey, 32000], '', []);

          {CHG11072002-1: Allow some of the links to not be seen by searchers.}
          {CHG09062006-1(2.10.1.9): The searcher is allowed to see property cards.}

        (*If GlblUserIsSearcher
          then
            begin
              tb_Main.Filter := 'VisibleToSearcher = True';
              tb_Main.Filtered := True;
            end; *)

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

        case EditMode of
          'V' : begin
                  btn_DeleteCard.Enabled := False;
                  btn_NewCard.Enabled := False;
                  btn_SaveCard.Enabled := False;
                end;  {Inquire}

        end;  {case EditMode of}

          {Set the location label.}

        ed_Location.Text := GetLegalAddressFromTable(tb_Parcel);
        ed_SBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
        SetTaxYearLabelForProcessingType(YearLabel, GlblProcessingType);

          {FXX12101997-1: Make sure that all pages have the inactive label.}

        If not ParcelIsActive(tb_Parcel)
          then InactiveLabel.Visible := True;

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(btn_Close);

  FormIsInitializing := False;

  tb_MainAfterScroll(nil);

end;  {InitializeForm}

{================================================================}
Procedure Tfm_PropertyCard.btn_NewCardClick(Sender: TObject);

begin
  try
    tb_Main.Append;
  except
    SystemSupport(004, tb_Main, 'Error putting Property Card Table in insert mode.',
                  UnitName, GlblErrorDlgBox);
  end;

end;  {NewCardButtonClick}

{================================================================}
Procedure Tfm_PropertyCard.btn_DeleteCardClick(Sender: TObject);

begin
    {CHG05042004-1(2.07l4): Option to delete the physical document.}

  If (MessageDlg('Are you sure you want to delete the link to this property card?', mtConfirmation,
                 [mbYes, mbNo], 0) = idYes)
    then
      try
        If (MessageDlg('Do you want to delete the actual property card also?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            try
              DeleteFile(PChar(tb_Main.FieldByName('DocumentLocation').Text));
            except
              MessageDlg('There was an error deleting the property card.' + #13 +
                         'Please remove it manually.', mtError, [mbOK], 0);
            end
          else MessageDlg('Please note that only the link was deleted, not the actual property card.', mtWarning, [mbOK], 0);

        tb_Main.Delete;

      except
        SystemSupport(005, tb_Main, 'Error deleting property card link.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {DeleteDocumentButtonClick}

{=======================================================================}
Procedure Tfm_PropertyCard.tb_MainNewRecord(DataSet: TDataset);

{FXX11191999-15: Default to the next Document number.}

var
  NextDocumentNumber : Integer;

begin
  If not FormIsInitializing
    then
      begin
        _SetRange(tb_PropertyCardLookup, [SwisSBLKey, 0], [SwisSBLKey, 32000], '', []);

        tb_PropertyCardLookup.First;

        If tb_PropertyCardLookup.EOF
          then NextDocumentNumber := 1
          else
            begin
              tb_PropertyCardLookup.Last;

              NextDocumentNumber := tb_PropertyCardLookup.FieldByName('DocumentNumber').AsInteger + 1;

            end;  {If tb_DocumentLookup.EOF}

        tb_Main.FieldByName('DocumentNumber').AsInteger := NextDocumentNumber;
        tb_Main.FieldByName('Date').AsDateTime := Date;

      end;  {If not FormIsInitializing}

end;  {tb_MainNewRecord}

{=======================================================================}
Procedure Tfm_PropertyCard.tb_MainAfterInsert(DataSet: TDataset);

var
  DocumentLocation : String;

begin
  If not FormIsInitializing
    then
      begin
        DocumentLocation := '';

        If GlblPropertyCardsArePDF
          then
            begin
              If dlg_OpenScannedImageSimple.Execute
                then DocumentLocation := dlg_OpenScannedImageSimple.FileName;

            end
          else
            If dlg_OpenScannedImage.Execute
              then DocumentLocation := dlg_OpenScannedImage.FileName;

        If _Compare(DocumentLocation, coBlank)
          then tb_Main.Cancel
          else
            begin
              tb_Main.FieldByName('DocumentLocation').AsString := DocumentLocation;

              If _Compare(DocumentLocation, 'pdf', coContains)
                then tb_Main.FieldByName('DocumentType').AsInteger := dtAdobePdf
                else tb_Main.FieldByName('DocumentType').AsInteger := dtScannedImage;

              tb_Main.Post;
              tb_MainAfterScroll(Dataset);
              Cursor := crDefault;
            end;

      end;  {If not FormIsInitializing}

end;  {tb_MainAfterInsert}

{=================================================================}
Procedure Tfm_PropertyCard.tb_MainAfterScroll(DataSet: TDataSet);

var
  Location : String;

begin
  If not FormIsInitializing
    then
      begin
        Cursor := crHourglass;

          {FXX07272001-2: If the data is downloaded from a network to a portable,
                          try to find the pictures on the local drive.}

        Location := tb_Main.FieldByName('DocumentLocation').AsString;

        If _Compare(Location, coNotBlank)
          then
            If _Compare(tb_Main.FieldByName('DocumentType').AsInteger, dtAdobePdf, coEqual)
              then
                begin
                  Image.ImageName := '';
                  ntbk_Main.PageIndex := 1;
                end
              else
                begin
                  ntbk_Main.PageIndex := 0;

                  try
                    If FileExists(Location)
                      then Image.ImageName := Location
                      else Image.ImageName := ChangeLocationToLocalDrive(Location);
                  except
                    MessageDlg('Unable to connect to scanned image ' + Location + '.',
                               mtError, [mbOK], 0);
                  end;

                  SetScrollBars;

                end;  {dtScannedImage}

        Cursor := crDefault;
        Application.ProcessMessages;

      end;  {If not FormIsInitializing}

end;  {tb_MainAfterScroll}

{=================================================================}
Procedure Tfm_PropertyCard.btn_FullScreenClick(Sender: TObject);

var
  FullScreenForm : TFullScreenViewForm;

begin
  FullScreenForm := nil;

  If _Compare(tb_Main.FieldByName('DocumentType').AsInteger, dtAdobePdf, coEqual)
    then ShellExecute(0, 'open',
                      PChar(tb_Main.FieldByName('DocumentLocation').AsString),
                      nil, nil, SW_NORMAL)
    else
      try
        FullScreenForm := TFullScreenViewForm.Create(self);
        FullScreenForm.Image.ImageName := tb_Main.FieldByName('DocumentLocation').AsString;
        FullScreenForm.Image.ImageLibPalette := False;
        FullScreenForm.ShowModal;
      finally
        FullScreenForm.Free;
      end;

end;  {FullScreenButtonClick}

{=======================================================================}
Procedure Tfm_PropertyCard.DocumentGridKeyPress(    Sender: TObject;
                                            var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        btn_FullScreenClick(Sender);
      end;

end;  {PictureGridKeyPress}

{=======================================================================}
Procedure Tfm_PropertyCard.btn_PrintClick(Sender: TObject);

var
  fPrinters : TextFile;
  I : Integer;

begin
(*  AssignFile(fPrinters, 'c:\Printers_Before.txt');
  Rewrite(fPrinters);
  For I := 0 to (Printer.Printers.Count - 1) do
    Writeln(fPrinters, Printer.Printers[I]);
  CloseFile(fPrinters);

  ShowMessage(IntToStr(Printer.PrinterIndex)); *)
  try
    Printer.Refresh;
  except
  end;

 (* try
    Printer.PrinterIndex := 0;
  except
  end; *)

    {FXX06092009-4(2.20.1.1)[D1533]: The property cards were not taking up the full page.}

  If dlg_Print.Execute
    then PrintImage(Image, Handle, 0, 0, Printer.PageWidth, Printer.PageHeight,
                    0, 999, False);

end;  {PrintButtonClick}

{==============================================================}
Procedure Tfm_PropertyCard.tb_MainAfterDelete(DataSet: TDataset);

{After a delete, we should always reset the range.}

begin
  tb_Main.DisableControls;
  tb_Main.CancelRange;
  _SetRange(tb_Main, [SwisSBLKey, 0], [SwisSBLKey, 32000], '', []);
  tb_Main.EnableControls;

end;  {tb_MainAfterDelete}

{==============================================================}
Procedure Tfm_PropertyCard.tb_MainBeforePost(DataSet: TDataset);

{If this is insert state, then fill in the SBL key and the
 tax roll year.}

var
  ReturnCode : Integer;

begin
  If ((not FormIsInitializing) and
      (tb_Main.State = dsInsert))
    then
      begin
        tb_Main.FieldByName('SwisSBLKey').AsString := Take(26, SwisSBLKey);

        If GlblAskSave
          then
            begin
                 {FXX11061997-2: Remove the "save before exiting" prompt because it
                                 is confusing. Use only "Do you want to save.}

              ReturnCode := MessageDlg('Do you wish to save your property card changes?', mtConfirmation,
                                       [mbYes, mbNo, mbCancel], 0);

              case ReturnCode of
                idNo : If (tb_Main.State = dsInsert)
                         then tb_Main.Cancel
                         else RefreshNoPost(tb_Main);

                idCancel : Abort;

              end;  {case ReturnCode of}

            end;  {If GlblAskSave}

      end;  {If ((not FormIsInitializing) and ...}

end;  {tb_MainBeforePost}

{====================================================================}
Procedure Tfm_PropertyCard.btn_SaveCardClick(Sender: TObject);

begin
  If (tb_Main.State in [dsEdit, dsInsert])
    then
      try
        tb_Main.Post;
      except
        SystemSupport(006, tb_Main, 'Error posting property card link.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {SaveButtonClick}

{==============================================================}
Procedure Tfm_PropertyCard.FormResize(Sender: TObject);

var
  BottomButtonsTotalWidth, BottomButtonsInterval : LongInt;

begin
  If not FormIsInitializing
    then
      begin
        BottomButtonsTotalWidth := btn_NewCard.Width +
                                   btn_DeleteCard.Width +
                                   btn_SaveCard.Width +
                                   btn_FullScreen.Width +
                                   btn_CopyToClipboard.Width +
                                   btn_Print.Width +
                                   btn_Close.Width;

        BottomButtonsInterval := (FooterPanel.Width - BottomButtonsTotalWidth) DIV 8;

        btn_DeleteCard.Left := btn_NewCard.Left + btn_NewCard.Width + BottomButtonsInterval;
        btn_SaveCard.Left := btn_DeleteCard.Left + btn_DeleteCard.Width + BottomButtonsInterval;
        btn_FullScreen.Left := btn_SaveCard.Left + btn_SaveCard.Width + BottomButtonsInterval;
        btn_CopyToClipboard.Left := btn_FullScreen.Left + btn_FullScreen.Width + BottomButtonsInterval;
        btn_Print.Left := btn_CopyToClipboard.Left + btn_CopyToClipboard.Width + BottomButtonsInterval;
        btn_Close.Left := btn_Print.Left + btn_Print.Width + BottomButtonsInterval;

        LocationLabel.Left := HeaderPanel.Width - 218;
        ed_Location.Left := HeaderPanel.Width - 166;

        ed_Name.Left := (HeaderPanel.Width - ed_Name.Width) DIV 2;
        OwnerLabel.Left := ed_Name.Left - 40;

      end;  {If not FormIsInitializing}

end;  {FormResize}

{==============================================================}
Procedure Tfm_PropertyCard.btn_CopyToClipboardClick(Sender: TObject);

{CHG07312007-1(2.11.2.10)[I924]: Add copy to clipboard.}

begin
  try
    Image.CopyToClipboard;
  except
  end;

end;  {CopyToClipboardButtonClick}

{==============================================================}
Procedure Tfm_PropertyCard.btn_CloseClick(Sender: TObject);

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
Procedure Tfm_PropertyCard.FormCloseQuery(    Sender: TObject;
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

  If (tb_Main.State in [dsInsert, dsEdit])
    then tb_Main.UpdateRecord;

    {Now, if they are closing the table, let's see if they want to
     save any changes. However, we won't check this if
     they are in inquire mode.}

  If (((EditMode = 'M') or
       (EditMode = 'A')) and
      tb_Main.Modified)
    then
      begin
        try
          tb_Main.Post;
        except
          CanClose := False;
          GlblParcelPageCloseCancelled := True;
        end;

      end;  {If Modified}

  ClosingForm := False;

end;  {FormCloseQuery}

{====================================================================}
Procedure Tfm_PropertyCard.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
    {Close all tables here.}

  CloseTablesForForm(Self);

  Action := caFree;

end;  {FormClose}

end.
