unit Ppicture;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids, Printers,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, ExtDlgs, TMultiP, Math;

type
  TPictureForm = class(TForm)
    MainDataSource: TwwDataSource;
    MainTable: TwwTable;
    Panel1: TPanel;
    TitleLabel: TLabel;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    ParcelDataSource: TDataSource;
    ParcelTable: TTable;
    YearLabel: TLabel;
    Panel3: TPanel;
    PrintDialog: TPrintDialog;
    Timer: TTimer;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    InactiveLabel: TLabel;
    PictureLookupTable: TTable;
    MainTableSwisSBLKey: TStringField;
    MainTablePictureNumber: TIntegerField;
    MainTablePictureLocation: TStringField;
    MainTableDate: TDateField;
    MainTableNotes: TStringField;
    OpenDialog: TOpenPictureDialog;
    PartialAssessmentLabel: TLabel;
    HeaderPanel: TPanel;
    Label4: TLabel;
    EditSBL: TMaskEdit;
    OwnerLabel: TLabel;
    EditName: TDBEdit;
    LocationLabel: TLabel;
    EditLocation: TEdit;
    FooterPanel: TPanel;
    NewPictureButton: TBitBtn;
    DeletePictureButton: TBitBtn;
    SaveButton: TBitBtn;
    CopyToClipboardButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Label1: TLabel;
    Panel7: TPanel;
    Panel11: TPanel;
    PictureGrid: TwwDBGrid;
    Panel10: TPanel;
    Panel12: TPanel;
    Label8: TLabel;
    Label3: TLabel;
    EditDate: TDBEdit;
    EditPictureLocation: TDBEdit;
    ReloadPictureButton: TButton;
    Panel13: TPanel;
    Label6: TLabel;
    Panel14: TPanel;
    NotesMemo: TDBMemo;
    Image: TPMultiImage;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterDelete(DataSet: TDataset);
    procedure MainTableAfterInsert(DataSet: TDataset);
    procedure MainDataSourceDataChange(Sender: TObject; Field: TField);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure ReloadPictureButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure MainTableNewRecord(DataSet: TDataset);
    procedure MainTableAfterPost(DataSet: TDataset);
    procedure NewPictureButtonClick(Sender: TObject);
    procedure DeletePictureButtonClick(Sender: TObject);
    procedure CopyToClipboardButtonClick(Sender: TObject);
    procedure ImageClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { public declarations }
    UnitName : String;  {For use with error dialog box.}

      {These will be set in the ParcelTabForm.}

    EditMode : Char;  {A = Add; M = Modify; V = View}
    SwisSBLKey : String;

    FormIsInitializing : Boolean;  {Is the form being initialized right now?}
    ClosingForm : Boolean;  {Are we closing a form right now?}
    PictureDir, TempFileName : String;

    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
      {because these routines are placed at the form object def. level,}
      {they have access to all variables on form (no need to Var in)   }
    Procedure InitializeForm;
    Procedure SetRangeForTable(Table : TTable);
    {Now set the range on this table so that it is sychronized to this parcel. Note
     that all segments of the key must be set.}

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, Fullscrn;

{$R *.DFM}

{=====================================================================}
Procedure TPictureForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TracePictureAccess(iTraceStep : Integer;
                             sMessage : String);

var
  flTrace : TextFile;

begin
  try
    AssignFile(flTrace, 'c:\PictureTrace.txt');

    If FileExists('c:\PictureTrace.txt')
    then Append(flTrace)
    else Rewrite(flTrace);

    Writeln(flTrace, 'Locator: ' + IntToStr(iTraceStep) + '  Message: ' + sMessage);

    CloseFile(flTrace);
  except
  end;

end;  {TracePictureAccess}

{========================================================================}
Procedure TPictureForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{mmm4 - Make sure to set range on all keys.}

begin
  try
    SetRangeOld(Table, ['SwisSBLKey', 'PictureNumber'],
                [SwisSBLKey, '0'],
                [SwisSBLKey, '99999']);
  except
    SystemSupport(001, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{====================================================================}
Procedure TPictureForm.FormResize(Sender: TObject);

var
  BottomButtonsTotalWidth, BottomButtonsInterval : LongInt;

begin
  If not FormIsInitializing
    then
      begin
        BottomButtonsTotalWidth := NewPictureButton.Width +
                                   DeletePictureButton.Width +
                                   SaveButton.Width +
                                   CopyToClipboardButton.Width +
                                   PrintButton.Width +
                                   CloseButton.Width;

        BottomButtonsInterval := (FooterPanel.Width - BottomButtonsTotalWidth) DIV 7;

        DeletePictureButton.Left := NewPictureButton.Left + NewPictureButton.Width + BottomButtonsInterval;
        SaveButton.Left := DeletePictureButton.Left + DeletePictureButton.Width + BottomButtonsInterval;
        CopyToClipboardButton.Left := SaveButton.Left + SaveButton.Width + BottomButtonsInterval;
        PrintButton.Left := CopyToClipboardButton.Left + CopyToClipboardButton.Width + BottomButtonsInterval;
        CloseButton.Left := PrintButton.Left + PrintButton.Width + BottomButtonsInterval;

        LocationLabel.Left := HeaderPanel.Width - 218;
        EditLocation.Left := HeaderPanel.Width - 166;

        EditName.Left := (HeaderPanel.Width - EditName.Width) DIV 2;
        OwnerLabel.Left := EditName.Left - 40;

      end;  {If not FormIsInitializing}

end;  {FormResize}

{====================================================================}
Procedure TPictureForm.InitializeForm;

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
  UnitName := 'PPICTURE.PAS';  {mmm1}
  ClosingForm := False;
  FormIsInitializing := True;
  TempFileName := '';

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

        OpenTablesForForm(Self, GlblProcessingType);

          {First let's find this parcel in the parcel table.}

        SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

        with SBLRec do
          Found := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode', 'Section',
                               'Subsection', 'Block', 'Lot', 'Sublot',
                               'Suffix'],
                              [GetTaxRlYr, SwisCode, Section,
                               SubSection, Block, Lot, Sublot, Suffix]);

        If not Found
          then SystemSupport(005, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

          {Set the range.}

        SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}

          {Also, set the title label to reflect the mode.
           We will then center it in the panel.}

          {FXX12151997-1: Make sure that the tital does not overlap the
                          assessed values.}

        TitleLabel.Caption := 'Pictures';

(*        case EditMode of   {mmm5}
          'A' : TitleLabel.Caption := 'Picture Add';
          'M' : TitleLabel.Caption := 'Picture Modify';
          'V' : TitleLabel.Caption := 'Picture View';

        end;  {case EditMode of} *)

        TitleLabel.Left := (Panel1.Width - TitleLabel.Width) DIV 2;

          {Now, for some reason the table is marked as
           Modified after we do a set range in modify mode.
           So, we will cancel the modify and set it in
           the proper mode.}

        If ((not MainTable.ReadOnly) and
            (EditMode = 'M'))
          then
            begin
              MainTable.Edit;
              MainTable.Cancel;
            end;

          {Note that we will not automatically put them
           in edit mode or insert mode. We will make them
           take that action themselves since even though
           they are in an edit or insert session, they
           may not want to actually make any changes, and
           if they do not, they should not have to cancel.}

        If MainTable.ReadOnly
          then
            begin
              NewPictureButton.Enabled := False;
              DeletePictureButton.Enabled := False;
              SaveButton.Enabled := False;
            end;

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
        SetTaxYearLabelForProcessingType(YearLabel, GlblProcessingType);

          {FXX12101997-1: Make sure that all pages have the inactive label.}

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

          {FXX01182000-1: Need a default picture directory.}

        OpenDialog.InitialDir := GlblPictureDir;

          {FXX04262000-1: Load button is confusing.}

        If MainTable.EOF
          then ReloadPictureButton.Enabled := False;

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  If glblTracePictureAccess
  then TracePictureAccess(2, 'InitialzeForm (end)');

  FormIsInitializing := False;
  Timer.Enabled := True;

end;  {InitializeForm}

{=======================================================================}
Procedure TPictureForm.TimerTimer(Sender: TObject);

{Load the image on a delay so that the page appears first.}

begin
  Timer.Enabled := False;
  Cursor := crHourglass;

  If glblTracePictureAccess
  then TracePictureAccess(8, 'TimerTimer-' + MainTablePictureLocation.Text);

    {FXX07272001-2: If the data is downloaded from a network to a portable,
                    try to find the pictures on the local drive.}

  try
    If FileExists(MainTablePictureLocation.Text)
      then Image.ImageName := MainTablePictureLocation.Text
      else Image.ImageName := ChangeLocationToLocalDrive(MainTablePictureLocation.Text);
  except
    Image.ImageName := '';
  end;

  If glblTracePictureAccess
  then TracePictureAccess(10, 'TimerTimer (after)-' + MainTablePictureLocation.Text);

  Cursor := crDefault;

end;  {TimerTimer}

{=======================================================================}
Procedure TPictureForm.MainTableNewRecord(DataSet: TDataset);

{FXX11191999-15: Default to the next picture number.}

var
  NextPictureNumber : Integer;

begin
  SetRangeOld(PictureLookupTable,
              ['SwisSBLKey', 'PictureNumber'],
              [SwisSBLKey, '0'], [SwisSBLKey, '99999']);
  PictureLookupTable.First;

  If PictureLookupTable.EOF
    then NextPictureNumber := 1
    else
      begin
        PictureLookupTable.Last;

        NextPictureNumber := PictureLookupTable.FieldByName('PictureNumber').AsInteger + 1;

      end;  {If PictureLookupTable.EOF}

  MainTable.FieldByName('PictureNumber').AsInteger := NextPictureNumber;

end;  {MainTableNewRecord}

{=======================================================================}
Procedure TPictureForm.MainTableAfterInsert(DataSet: TDataset);

begin
  If not FormIsInitializing
    then
      If OpenDialog.Execute
        then
          begin
            Cursor := crHourglass;
            MainTablePictureLocation.Text := OpenDialog.FileName;

            try
              Image.ImageName := MainTablePictureLocation.Text;
            except
              Image.ImageName := '';
            end;

            Cursor := crDefault;
            MainTableDate.AsDateTime := Date;
              {FXX04262000-1: Load button is confusing.}
            ReloadPictureButton.Enabled := False;
          end
        else MainTable.Cancel;

end;  {MainTableAfterInsert}

{=================================================================}
Procedure TPictureForm.MainDataSourceDataChange(Sender: TObject;
                                                Field: TField);

begin
  If ((not FormIsInitializing) and
      (Field = nil))
    then
      begin
        Cursor := crHourglass;

          {FXX07272001-2: If the data is downloaded from a network to a portable,
                          try to find the pictures on the local drive.}

        If glblTracePictureAccess
        then TracePictureAccess(10, 'DataChange-' + MainTablePictureLocation.Text);

        try
          If FileExists(MainTablePictureLocation.Text)
            then Image.ImageName := MainTablePictureLocation.Text
            else Image.ImageName := ChangeLocationToLocalDrive(MainTablePictureLocation.Text);
        except
          Image.ImageName := '';
        end;

        If glblTracePictureAccess
        then TracePictureAccess(12, 'DataChange (after)-' + MainTablePictureLocation.Text);

      end;  {If ((not FormIsInitializing) and ...}

end;  {MainDataSourceDataChange}

{===============================================================}
Procedure TPictureForm.ReloadPictureButtonClick(Sender: TObject);

{Load a new picture in.}

begin
  If OpenDialog.Execute
    then
      begin
        If not (MainTable.State in [dsEdit, dsInsert])
          then MainTable.Edit;

        Cursor := crHourglass;
        Image.ImageName := OpenDialog.FileName;

        Cursor := crDefault;
        MainTablePictureLocation.Text := OpenDialog.FileName;

      end;  {If OpenDialog.Execute}

end;  {LoadPictureButtonClick}

{=================================================================}
Procedure TPictureForm.NewPictureButtonClick(Sender: TObject);

begin
  try
    MainTable.Append;
  except
    SystemSupport(039, MainTable, 'Error adding picture record.',
                  UnitName, GlblErrorDlgBox);
  end;

end;  {NewPictureButtonClick}

{=================================================================}
Procedure TPictureForm.DeletePictureButtonClick(Sender: TObject);

begin
    {CHG05042004-1(2.07l4): Option to delete the physical picture.}

  If (MessageDlg('Are you sure you want to delete the link to this picture?', mtConfirmation,
                 [mbYes, mbNo], 0) = idYes)
    then
      try
        If (MessageDlg('Do you want to delete the actual picture also?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            try
              DeleteFile(PChar(MainTable.FieldByName('PictureLocation').Text));
            except
              MessageDlg('There was an error deleting the picture.' + #13 +
                         'Please remove it manually.', mtError, [mbOK], 0);
            end
          else MessageDlg('Please note that only the link was deleted, not the actual picture.', mtWarning, [mbOK], 0);

        MainTable.Delete;

      except
        SystemSupport(040, MainTable, 'Error deleting picture record.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {DeletePictureButtonClick}

{=================================================================}
Procedure TPictureForm.CopyToClipboardButtonClick(Sender: TObject);

{CHG09042003-1(2.07i): Add copy to clipboard.}

begin
  try
    Image.CopyToClipboard;
  except
  end;

end;  {CopyToClipboardButtonClick}

{=================================================================}
Procedure TPictureForm.SaveButtonClick(Sender: TObject);

begin
  If (MainTable.State in [dsEdit, dsInsert])
    then
      try
        MainTable.Post;
      except
        SystemSupport(042, MainTable, 'Error saving picture record.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {SaveButtonClick}

{=================================================================}
Procedure TPictureForm.ImageClick(Sender: TObject);

{CHG09042003-1(2.07i): Move the full screen to the image click to free up space for more buttons.}

var
  FullScreenForm : TFullScreenViewForm;

begin
  FullScreenForm := nil;

  try
    FullScreenForm := TFullScreenViewForm.Create(self);

      {FXX07272001-2: If the data is downloaded from a network to a portable,
                      try to find the pictures on the local drive.}

    try
      with FullScreenForm do
        If FileExists(MainTablePictureLocation.Text)
          then Image.ImageName := MainTablePictureLocation.Text
          else Image.ImageName := ChangeLocationToLocalDrive(MainTablePictureLocation.Text);
    except
      Image.ImageName := '';
    end;

    FullScreenForm.ShowModal;
  finally
    FullScreenForm.Free;
  end;

end;  {ImageClick}

{=======================================================================}
Procedure TPictureForm.PrintButtonClick(Sender: TObject);

var
  TempWidth, ImageHeight, ImageWidth : LongInt;
  Scale : Double;

begin
    {FXX02181999-2: The image is printing very small.}
    {CHG08042004-1(2.07l6): Option to have the printed picture take up the whole page.}

  If PrintDialog.Execute
    then
        {FXX06092009-5(2.20.1.1)[D1544]: Make sure the paper is in portrait mode for the following logic to work.
                                         Sometimes it was still in landscape mode and caused it to print full
                                         screen even when the person said not to.}

      Printer.Orientation := poPortrait;

      If (MessageDlg('Do you want to the printed picture to take up the whole page?',
                     mtConfirmation, [mbYes, mbNo], 0) = idYes)
        then Image.PrintMultiImage(0, 0, Trunc(Printer.PageWidth),
                                   Trunc(Printer.PageHeight))
        else
          begin
              {FXX10092004-3(2.8.0.14): When print the image, preserve scale.}

            Image.GetInfoAndType(Image.ImageName);
            ImageWidth := Image.BWidth;
            ImageHeight := Image.BHeight;

            If (ImageWidth >= ImageHeight)
              then
                begin
                  Scale := 1 - (ImageWidth - ImageHeight) / ImageWidth;
                  Image.PrintMultiImage(0, 0, Trunc(Printer.PageWidth),
                                        Trunc(Printer.PageWidth * Scale));
                end
              else
                begin
                  Scale := 1 - (ImageHeight - ImageWidth) / ImageHeight;
                  TempWidth := Min(Trunc(Printer.PageWidth), Trunc(Printer.PageHeight * Scale));

                  Image.PrintMultiImage(0, 0, TempWidth, Trunc(Printer.PageHeight));

                end;  {else of If (ImageWidth >= ImageHeight)}

          end;  {else of If (MessageDlg('}

end;  {PrintButtonClick}

{==============================================================}
Procedure TPictureForm.MainTableAfterDelete(DataSet: TDataset);

{After a delete, we should always reset the range.}

begin
  MainTable.DisableControls;
  MainTable.CancelRange;
  SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}
  MainTable.EnableControls;

    {FXX04262000-1: Load button is confusing.}

  If MainTable.EOF
    then ReloadPictureButton.Enabled := False;

end;  {MainTableAfterDelete}

{==============================================================}
Procedure TPictureForm.MainTableBeforePost(DataSet: TDataset);

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

          {FXX05151998-3: Don't ask save on close form if don't want to see save.}

        If (GlblAskSave or ClosingForm)
          then
            begin
                {FXX11061997-2: Remove the "save before exiting" prompt because it
                                is confusing. Use only "Do you want to save.}

              ReturnCode := MessageDlg('Do you wish to save your picture changes?', mtConfirmation,
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

{==============================================================}
Procedure TPictureForm.MainTableAfterPost(DataSet: TDataset);

begin
    {FXX04262000-1: Load button is confusing.}
  ReloadPictureButton.Enabled := True;
end;

{==============================================================}
Procedure TPictureForm.CloseButtonClick(Sender: TObject);

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
Procedure TPictureForm.FormCloseQuery(    Sender: TObject;
                                         var CanClose: Boolean);

begin
  GlblParcelPageCloseCancelled := False;
  CanClose := True;
  ClosingForm := True;

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
Procedure TPictureForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
  If (Deblank(TempFileName) <> '')
    then
      try
        ChDir(PictureDir);
        OldDeleteFile(TempFileName);
      except
      end;

    {Close all tables here.}

  CloseTablesForForm(Self);

  Action := caFree;

end;  {FormClose}




end.