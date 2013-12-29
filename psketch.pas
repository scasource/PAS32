unit Psketch;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs, DB, Grids, DBGrids, Printers,
  DBTables, Mask, DBCtrls, Wwtable, Wwdatsrc, Wwdbcomb, Wwdbigrd, Wwdbgrid,
  Btrvdlg, Types, wwdblook, Buttons, ExtDlgs, TMultiP, OleCtrls,
  CApexSPX_TLB, Exchange2XControl1_TLB;

type
  TSketchForm = class(TForm)
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
    DisplaySketchTimer: TTimer;
    Label53: TLabel;
    Label55: TLabel;
    TotalAVLabel: TLabel;
    LandAVLabel: TLabel;
    InactiveLabel: TLabel;
    SketchLookupTable: TTable;
    PartialAssessmentLabel: TLabel;
    OpenDialog: TOpenDialog;
    FooterPanel: TPanel;
    NewSketchButton: TBitBtn;
    DeleteSketchButton: TBitBtn;
    SaveButton: TBitBtn;
    CopyToClipboardButton: TBitBtn;
    PrintButton: TBitBtn;
    HeaderPanel: TPanel;
    Label4: TLabel;
    EditSBL: TMaskEdit;
    OwnerLabel: TLabel;
    EditName: TDBEdit;
    LocationLabel: TLabel;
    EditLocation: TEdit;
    Panel6: TPanel;
    Panel8: TPanel;
    Label1: TLabel;
    Panel10: TPanel;
    Panel4: TPanel;
    SketchGrid: TwwDBGrid;
    Panel11: TPanel;
    Label8: TLabel;
    EditDate: TDBEdit;
    Label3: TLabel;
    EditSketchLocation: TDBEdit;
    Panel12: TPanel;
    Panel13: TPanel;
    StatisticsLabel: TLabel;
    Panel14: TPanel;
    StatisticsStringGrid: TStringGrid;
    GetSketchDataTimer: TTimer;
    OpenSketchTimer: TTimer;
    SketchNotebook: TNotebook;
    SketchPanel: TPanel;
    SketchImage: TPMultiImage;
    CreateActiveXComponentTimer: TTimer;
    CloseButton: TBitBtn;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainTableAfterDelete(DataSet: TDataset);
    procedure MainTableBeforePost(DataSet: TDataset);
    procedure PrintButtonClick(Sender: TObject);
    procedure DisplaySketchTimerTimer(Sender: TObject);
    procedure MainTableNewRecord(DataSet: TDataset);
    procedure NewSketchButtonClick(Sender: TObject);
    procedure DeleteSketchButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MainTableAfterScroll(DataSet: TDataSet);
    procedure CopyToClipboardButtonClick(Sender: TObject);
    procedure GetSketchDataTimerTimer(Sender: TObject);
    procedure OpenSketchTimerTimer(Sender: TObject);
    procedure SketchImageClick(Sender: TObject);
    procedure CreateActiveXComponentTimerTimer(Sender: TObject);
    procedure SketchPanelClick(Sender: TObject);

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
    SketchDir : String;
    CurrentRow : Integer;
    TimeOut, GotSketchData, ApexInstalled : Boolean;
    ApexX : TCApexSPX;
    ApexXv4 : TExchange2X;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
      {because these routines are placed at the form object def. level,}
      {they have access to all variables on form (no need to Var in)   }
    Procedure InitializeForm;

    Procedure ApexXClick(Sender: TObject);
    Procedure ApexXSketchOpen(Sender: TObject);
    Procedure ApexXNewSketchData(Sender: TObject);

    Procedure CreateApexComponent;
    Procedure SetRangeForTable(Table : TTable);
    {Now set the range on this table so that it is sychronized to this parcel. Note
     that all segments of the key must be set.}

    Procedure AddOneAreaToStatisticsGrid(StatisticsStringGrid : TStringGrid;
                                         I : Integer);

  end;    {end form object definition}

implementation

uses GlblVars, PASTypes, WinUtils, PASUTILS, UTILEXSD,  Utilitys,
     GlblCnst, Fullscrn, ApexActionDialogUnit;

{$R *.DFM}

{=====================================================================}
Procedure TSketchForm.CreateParams(var Params: TCreateParams);

begin
 inherited CreateParams(Params);

  with Params do
    begin
      WndParent := Application.Mainform.Handle;
      Style := (Style or WS_Child) and not WS_Popup;
    end;

end;  {CreateParams}

{========================================================================}
Procedure TSketchForm.FormResize(Sender: TObject);

var
  BottomButtonsTotalWidth, BottomButtonsInterval : LongInt;

begin
  If not FormIsInitializing
    then
      begin
        BottomButtonsTotalWidth := NewSketchButton.Width +
                                   DeleteSketchButton.Width +
                                   SaveButton.Width +
                                   CopyToClipboardButton.Width +
                                   PrintButton.Width +
                                   CloseButton.Width;

        BottomButtonsInterval := (FooterPanel.Width - BottomButtonsTotalWidth) DIV 7;

        DeleteSketchButton.Left := NewSketchButton.Left + NewSketchButton.Width + BottomButtonsInterval;
        SaveButton.Left := DeleteSketchButton.Left + DeleteSketchButton.Width + BottomButtonsInterval;
        CopyToClipboardButton.Left := SaveButton.Left + SaveButton.Width + BottomButtonsInterval;
        PrintButton.Left := CopyToClipboardButton.Left + CopyToClipboardButton.Width + BottomButtonsInterval;
        CloseButton.Left := PrintButton.Left + PrintButton.Width + BottomButtonsInterval;

        LocationLabel.Left := HeaderPanel.Width - 218;
        EditLocation.Left := HeaderPanel.Width - 166;

        EditName.Left := (HeaderPanel.Width - EditName.Width) DIV 2;
        OwnerLabel.Left := EditName.Left - 40;

      end;  {If not FormIsInitializing}

end;  {FormResize}

{========================================================================}
Procedure TSketchForm.SetRangeForTable(Table : TTable);

{Now set the range on this table so that it is sychronized to this parcel. Note
 that all segments of the key must be set.}
{mmm4 - Make sure to set range on all keys.}

begin
  try
    SetRangeOld(Table, ['SwisSBLKey', 'SketchNumber'],
                [SwisSBLKey, '0'],
                [SwisSBLKey, '99999']);
  except
    SystemSupport(001, Table, 'Error setting range in ' + Table.Name, UnitName, GlblErrorDlgBox);
  end;

end;  {SetRangeForTable}

{=======================================================================}
Procedure TSketchForm.ApexXSketchOpen(Sender: TObject);

begin
  OpenSketchTimer.Enabled := True;
end;  {ApexXSketchOpen}

{=======================================================================}
Procedure TSketchForm.ApexXNewSketchData(Sender: TObject);

begin
  GotSketchData := True;
end;  {ApexXNewSketchData}

{=================================================================}
Procedure TSketchForm.ApexXClick(Sender: TObject);

begin
  try
    If not GlblUsesApexMedina
      then (*ApexXv4.SetApexWindowState(2)
      else *)ApexX.SetApexWindowState(2);
  except
    MessageDlg('There was an error connecting with Apex in order to display the sketch.',
               mtError, [mbOK], 0);
  end;

end;  {ApexXClick}

{====================================================================}
Procedure TSketchForm.CreateApexComponent;

begin
(*  If GlblUsesApexMedina
  then MessageDlg('Uses Medina.', mtInformation, [mbOK], 0)
  else MessageDlg('Not using Medina.', mtInformation, [mbOK], 0);  *)

  If GlblUsesApexMedina
    then
      try
        ApexXv4 := TExchange2X.Create(SketchPanel);

        ApexXv4.OnClick := ApexXClick;
        ApexXv4.OnSketchOpen := ApexXSketchOpen;
        ApexXv4.OnNewSketchData := ApexXNewSketchData;

        with ApexXv4 do
          begin
            Align := alClient;
            AreaPage := 0;
            CurrentPage := 1;
            Color := clWhite;
            Parent := SketchPanel;
            ShowHint := True;
            StartMinimized := True;
            ShowSplashScreen := False;
            If glblShowSketchWithComments
            then SketchForm := $2000
            else SketchForm := 1;

          end;  {with ApexXv4 do}

        DisplaySketchTimer.Enabled := True;

      except
        on E: Exception do
          MessageDlg('There was an error creating the Apex ActiveX component.' + #13 +
                     'Exception: ' + E.Message + '.', mtError, [mbOK], 0);
      end;
(*    else
      try
        ApexX := TCApexSPX.Create(SketchPanel);

        ApexX.OnClick := ApexXClick;
        ApexX.OnSketchOpen := ApexXSketchOpen;
        ApexX.OnNewSketchData := ApexXNewSketchData;

        with ApexX do
          begin
            Align := alClient;
            AreaCount := 2;
            Color := clWhite;
            DataPage := 1;
            Parent := SketchPanel;
            ShowHint := True;
            StartMinimized := True;
            ShowSplashScreen := False;
            SketchForm := $0002;

          end;  {with ApexX do}

        DisplaySketchTimer.Enabled := True;

      except
        on E: Exception do
          MessageDlg('There was an error creating the Apex ActiveX component.' + #13 +
                     'Exception: ' + E.Message + '.', mtError, [mbOK], 0);
      end; *)

end;  {CreateApexComponent}

{====================================================================}
Procedure TSketchForm.CreateActiveXComponentTimerTimer(Sender: TObject);

begin
  CreateActiveXComponentTimer.Enabled := False;
  CreateApexComponent;
end;

{====================================================================}
Procedure TSketchForm.InitializeForm;

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
  UnitName := 'PSketch';  {mmm1}
  ClosingForm := False;
  FormIsInitializing := True;
  SketchNotebook.PageIndex := 0;

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

        TitleLabel.Caption := 'Sketches';

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
              NewSketchButton.Enabled := False;
              DeleteSketchButton.Enabled := False;
              SaveButton.Enabled := False;
            end;

          {Set the location label.}

        EditLocation.Text := GetLegalAddressFromTable(ParcelTable);
        EditSBL.Text := ConvertSwisSBLToDashDot(SwisSBLKey);
        SetTaxYearLabelForProcessingType(YearLabel, GlblProcessingType);

          {FXX12101997-1: Make sure that all pages have the inactive label.}

        If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
          then InactiveLabel.Visible := True;

        OpenDialog.InitialDir := GlblDefaultApexDir;   

          {CHG03052004-1(2.07l2): Allow the searcher to view and print sketches.}

          {FXX06082005-1(2.8.4.9): Don't test the registry if this is a searcher
                                   because some searchers don't have rights.}

        ApexInstalled := True;

        If GlblUserIsSearcher
          then ApexInstalled := False;

        If ApexInstalled
          then ApexInstalled := ApexIsInstalledOnComputer;

        If ApexInstalled
          then
          begin
            CreateActiveXComponentTimer.Enabled := True;
          end
          else
            begin
              StatisticsStringGrid.Visible := False;
              StatisticsLabel.Visible := False;
              SketchNotebook.PageIndex := 1;
              NewSketchButton.Enabled := False;
              DeleteSketchButton.Enabled := False;
              SaveButton.Enabled := False;
              CopyToClipboardButton.Enabled := False;
              FormIsInitializing := False;
              DisplaySketchTimer.Enabled := True;

            end;  {If not ApexInstalled}

      end;  {If (Deblank(SwisSBLKey) <> '')}

    {CHG11162004-7(2.8.0.21): Option to make the close button locate.}

  If GlblCloseButtonIsLocate
    then MakeCloseButtonLocate(CloseButton);

  FormIsInitializing := False;

end;  {InitializeForm}

{=======================================================================}
Procedure TSketchForm.GetSketchDataTimerTimer(Sender: TObject);

begin
  GetSketchDataTimer.Enabled := False;
  TimeOut := True;
end;

{=======================================================================}
Procedure TSketchForm.AddOneAreaToStatisticsGrid(StatisticsStringGrid : TStringGrid;
                                                 I : Integer);

begin
  with StatisticsStringGrid do
    begin
      If ((CurrentRow + 4) > RowCount)
        then RowCount := RowCount + 5;

      Cells[0, CurrentRow] := 'Area Number';
      Cells[1, CurrentRow] := IntToStr(I);
                                    Cells[0, (CurrentRow + 1)] := '    Name';
      If GlblUsesApexMedina
        then Cells[1, (CurrentRow + 1)] := ApexXv4.GetAreaNameByIndex(I)
        else Cells[1, (CurrentRow + 1)] := ApexX.GetAreaNameByIndex(I);

      Cells[0, (CurrentRow + 2)] := '    Code';
      If GlblUsesApexMedina
        then Cells[1, (CurrentRow + 2)] := ApexXv4.GetAreaCodeByIndex(I)
        else Cells[1, (CurrentRow + 2)] := ApexX.GetAreaCodeByIndex(I);

      Cells[0, (CurrentRow + 3)] := '    Size';
      If GlblUsesApexMedina
        then Cells[1, (CurrentRow + 3)] := FormatFloat(DecimalEditDisplay,
                                                       ApexXv4.GetAreaSizeByIndex(I))
        else Cells[1, (CurrentRow + 3)] := FormatFloat(DecimalEditDisplay,
                                                       ApexX.GetAreaSizeByIndex(I));

      Cells[0, (CurrentRow + 4)] := '    Perim';
      If GlblUsesApexMedina
        then Cells[1, (CurrentRow + 4)] := FormatFloat(DecimalEditDisplay,
                                                       ApexXv4.GetAreaPerimeterByIndex(I))
        else Cells[1, (CurrentRow + 4)] := FormatFloat(DecimalEditDisplay,
                                                       ApexX.GetAreaPerimeterByIndex(I));

      CurrentRow := CurrentRow + 5;

    end;  {with StatisticsStringGrid do}

end;  {AddOneAreaToStatisticsGrid}

{=======================================================================}
Procedure TSketchForm.OpenSketchTimerTimer(Sender: TObject);

var
  I : Integer;

begin
  OpenSketchTimer.Enabled := False;

  CurrentRow := 0;

  TimeOut := False;
  GotSketchData := False;
  GetSketchDataTimer.Enabled := True;

  If GlblUsesApexMedina
    then ApexXv4.RunDDEMacro('File;SendData')
    else ApexX.RunDDEMacro('File;SendData');

  repeat
    Application.ProcessMessages;
  until (TimeOut or GotSketchData);

  GetSketchDataTimer.Enabled := False;

  If GlblUsesApexMedina
    then
    begin
      For I := 1 to ApexXv4.AreaCount do
        AddOneAreaToStatisticsGrid(StatisticsStringGrid, I)
    end
    else
      For I := 1 to ApexX.AreaCount do
        AddOneAreaToStatisticsGrid(StatisticsStringGrid, I);

  EditDate.SetFocus;

end;  {OpenSketchTimer}

{=======================================================================}
Procedure TSketchForm.DisplaySketchTimerTimer(Sender: TObject);

{Load the image on a delay so that the page appears first.}

var
  SketchImageLocation, SketchLocation : String;

begin
  DisplaySketchTimer.Enabled := False;
  Cursor := crHourglass;

    {FXX07272001-2: If the data is downloaded from a network to a portable,
                    try to find the pictures on the local drive.}

    {CHG03052004-1(2.07l2): Allow the searcher to view and print sketches.}

  If (Trim(MainTable.FieldByName('SketchLocation').Text) <> '')
    then
      If ApexInstalled
        then
          begin
            If GlblUsesApexMedina
              then
                with ApexXv4 do
                  try
                    CloseSketch;
                    OpenSketchFile(GetSketchLocation(MainTable, ApexInstalled));
                    UpdateSketchData;
                    Refresh;
                    Application.ProcessMessages;
                  except
                  end
              else
                with ApexX do
                  try
                    CloseSketch;
                    SketchLocation := GetSketchLocation(MainTable, ApexInstalled);
                    SketchFile := SketchLocation;
                    UpdateSketchData;
                    Refresh;
                    SetApexWindowState(0);
                    Application.ProcessMessages;
                  except
                    SketchFile := '';
                  end;

          end
        else
          begin
            SketchImageLocation := GetSketchLocation(MainTable, ApexInstalled);

            try
              SketchImage.ImageName := SketchImageLocation;
            except
              SketchImage.ImageName := '';
            end;

          end;  {else of If ApexInstalled}

  EditDate.SetFocus;
  Cursor := crDefault;

end;  {DisplaySketchTimer}

{=======================================================================}
Procedure TSketchForm.MainTableNewRecord(DataSet: TDataset);

{FXX11191999-15: Default to the next picture number.}

(*var
  NextSketchNumber : Integer;
  TempFileName : String; *)

begin
(*  If not FormIsInitializing
    then
      begin

        ApexActionDialogForm := TApexActionDialogForm.Create(nil);

        ApexActionDialogForm.ShowModal;

        If (ApexActionDialogForm.ModalResult = idOK)
          then
            begin
              SetRangeOld(SketchLookupTable,
                          ['SwisSBLKey', 'SketchNumber'],
                          [SwisSBLKey, '0'], [SwisSBLKey, '99999']);
              SketchLookupTable.First;

              If SketchLookupTable.EOF
                then NextSketchNumber := 1
                else
                  begin
                    SketchLookupTable.Last;

                    NextSketchNumber := SketchLookupTable.FieldByName('SketchNumber').AsInteger + 1;

                  end;  {If SketchLookupTable.EOF}

              MainTable.FieldByName('SketchNumber').AsInteger := NextSketchNumber;
              MainTable.FieldByName('Date').AsDateTime := Date;

              case ApexActionDialogForm.ApexActionType of
                apExistingSketch :
                  begin
                    If OpenDialog.Execute
                      then
                        begin
                          Cursor := crHourglass;
                          MainTable.FieldByName('SketchLocation').Text := OpenDialog.FileName;

                          try
                            ApexX.SketchFile := MainTable.FieldByName('SketchLocation').Text;
                          except
                            ApexX.SketchFile := '';
                          end;

                          Cursor := crDefault;
                        end
                      else MainTable.Cancel;

                  end;  {apExistingSketch}

                apNewSketch :
                  begin
                      {In order to create a new sketch, we want to set SketchFile to a new name.}

                    TempFileName := AddDirectorySlashes(ExpandPASPath(GlblDefaultApexDir)) + 'Sketch_for_' +
                                    ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                    If FileExists(TempFileName + '.AX3')
                      then TempFileName := TempFileName + '_' +
                                           DateToStr(Date);

                    TempFileName := TempFileName + '.AX3';

                    ApexX.ClearSketch;
                    ApexX.StartMinimized := False;

                    try
                      ApexX.UpdateOnLoad := True;
                      ApexX.LoadSketch32(TempFileName);
                    except
                      ApexX.SketchFile := '';
                    end;

                    MainTable.FieldByName('SketchLocation').Text := TempFileName;

                  end;  {apNewSketch}

              end;  {case ApexActionDialogForm.ApexActionType of}

            end
          else MainTable.Cancel;

        ApexX.SetApexWindowState(2);

      finally
        ApexActionDialogForm.Free;
      end; *)

end;  {MainTableNewRecord}

{=======================================================================}
Procedure TSketchForm.MainTableAfterScroll(DataSet: TDataSet);

begin
  If not FormIsInitializing
    then DisplaySketchTimer.Enabled := True;

end;  {MainTableAfterScroll}

{=================================================================}
Procedure TSketchForm.NewSketchButtonClick(Sender: TObject);

var
  NextSketchNumber : Integer;

begin
  If not FormIsInitializing
    then
      begin
        OpenDialog.InitialDir := GlblDefaultApexDir;

        If OpenDialog.Execute
          then
            begin
              SetRangeOld(SketchLookupTable,
                          ['SwisSBLKey', 'SketchNumber'],
                          [SwisSBLKey, '0'], [SwisSBLKey, '99999']);
              SketchLookupTable.First;

              If SketchLookupTable.EOF
                then NextSketchNumber := 1
                else
                  begin
                    SketchLookupTable.Last;

                    NextSketchNumber := SketchLookupTable.FieldByName('SketchNumber').AsInteger + 1;

                  end;  {If SketchLookupTable.EOF}

              with MainTable do
                try
                  Append;

                  FieldByName('SketchNumber').AsInteger := NextSketchNumber;
                  FieldByName('Date').AsDateTime := Date;
                  FieldByName('SketchLocation').Text := OpenDialog.FileName;
                  Post;
                except
                end;

              If GlblUsesApexMedina
                then
                  with ApexXv4 do
                    begin
                      try
                        CloseSketch;
                        OpenSketchFile(GetSketchLocation(MainTable, ApexInstalled));
                      except
                      end;

                      UpdateSketchData;
                      Refresh;
                    end
                else
                  with ApexX do
                    begin
                      try
                        CloseSketch;
                        SketchFile := GetSketchLocation(MainTable, ApexInstalled);

                      except
                        SketchFile := '';
                      end;

                      UpdateSketchData;
                      Refresh;
                      SetApexWindowState(0);
                    end;

              Application.ProcessMessages;

                {CHG03052004-1(2.07l2): Allow the searcher to view and print sketches.}
                {FXX08232004-3(2.08.0.08302004): Change to Windows metafile for better clarity.}

              If (MessageDlg('Do you want to create a copy of this sketch for searchers to view?',
                             mtConfirmation, [mbYes, mbNo], 0) = idYes)
                then
                  If GlblUsesApexMedina
                    then
                      with ApexXv4 do
                        begin
                          SavePlaceableMetaFileByPage(ConvertFileNameToApexWMFFileName(MainTable.FieldByName('SketchLocation').Text, True, False), CurrentPage);
                          Refresh;
                        end
                    else
                      with ApexX do
                        begin
                          SavePlaceableMetaFile(ConvertFileNameToApexWMFFileName(MainTable.FieldByName('SketchLocation').Text, True, False));
                          Refresh;
                        end;

            end;  {If OpenDialog.Execute}

      end;  {If not FormIsInitializing}

end;  {NewSketchButtonClick}

{=================================================================}
Procedure TSketchForm.DeleteSketchButtonClick(Sender: TObject);

begin
    {CHG05042004-1(2.07l4): Option to delete the physical document.}

  If (MessageDlg('Are you sure you want to delete the link to this sketch?', mtConfirmation,
                 [mbYes, mbNo], 0) = idYes)
    then
      try
        If (MessageDlg('Do you want to delete the actual sketch also?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            try
              DeleteFile(PChar(MainTable.FieldByName('SketchLocation').Text));
            except
              MessageDlg('There was an error deleting the sketch.' + #13 +
                         'Please remove it manually.', mtError, [mbOK], 0);
            end
          else MessageDlg('Please note that only the link was deleted, not the actual sketch.', mtWarning, [mbOK], 0);

        MainTable.Delete;
      except
        SystemSupport(040, MainTable, 'Error deleting sketch record.',
                      UnitName, GlblErrorDlgBox);
      end;

end;  {DeleteSketchButtonClick}

{=================================================================}
Procedure TSketchForm.SaveButtonClick(Sender: TObject);

begin
  If (MainTable.State in [dsEdit, dsInsert])
    then
      try
        MainTable.Post;
      except
        SystemSupport(042, MainTable, 'Error saving sketch record.',
                      UnitName, GlblErrorDlgBox);
      end;

  If GlblUsesApexMedina
    then
      with ApexXv4 do
        begin
          UpdateSketchData;
          Refresh;
        end
    else
      with ApexX do
        begin
          UpdateSketchData;
          Refresh;
        end;

end;  {SaveButtonClick}

{=======================================================================}
Procedure TSketchForm.SketchImageClick(Sender: TObject);

{CHG03052004-1(2.07l2): Allow the searcher to view and print sketches.}

var
  FullScreenForm : TFullScreenViewForm;
  SketchImageLocation : String;

begin
  FullScreenForm := nil;
  
  try
    FullScreenForm := TFullScreenViewForm.Create(self);

      {FXX07272001-2: If the data is downloaded from a network to a portable,
                      try to find the pictures on the local drive.}

    with FullScreenForm do
      try
        SketchImageLocation := GetSketchLocation(MainTable, ApexInstalled);
        Image.ImageName := SketchImageLocation;
      except
        Image.ImageName := '';
      end;

    FullScreenForm.ShowModal;
  finally
    FullScreenForm.Free;
  end;

end;  {SketchImageClick}

{=======================================================================}
Procedure TSketchForm.PrintButtonClick(Sender: TObject);

begin
    {CHG03052004-1(2.07l2): Allow the searcher to view and print sketches.}

  If PrintDialog.Execute
    then
      begin
          {FXX02152004-1(2.07l): Make sure that the print goes to tje printer that they selected.}

        Printer.Refresh;

        If ApexInstalled
          then
            try
              If GlblUsesApexMedina
                then ApexXv4.RunDDEMacro('File;Print')
                else ApexX.ApexPrint;
            except
              MessageDlg('There was an error printing the sketch.',
                         mtError, [mbOK], 0);
            end
          else SketchImage.PrintMultiImage(0, 0, Trunc(Printer.PageWidth),
                                           Trunc(1.3 * Printer.PageHeight));

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{==============================================================}
Procedure TSketchForm.CopyToClipboardButtonClick(Sender: TObject);

begin
  try
    If not GlblUsesApexMedina
      then (*ApexXv4.CopyToClipboard(ApexXv4.Handle)
      else *)ApexX.CopyToClipboard(ApexX.Handle);
  except
    MessageDlg('Error copying sketch to clipboard.', mtError, [mbOK], 0);
  end;

end;  {CopyToClipboardButtonClick}

{==============================================================}
Procedure TSketchForm.SketchPanelClick(Sender: TObject);

begin
  If GlblUsesApexMedina
    then ApexXv4.UpdateSketchData
    else ApexX.UpdateSketchData;

end;  {SketchPanelClick}

{==============================================================}
Procedure TSketchForm.MainTableAfterDelete(DataSet: TDataset);

{After a delete, we should always reset the range.}

begin
  MainTable.DisableControls;
  MainTable.CancelRange;
  SetRangeForTable(MainTable);  {This is a method that we have written to avoid having two copies of the setrange.}
  MainTable.EnableControls;

end;  {MainTableAfterDelete}

{==============================================================}
Procedure TSketchForm.MainTableBeforePost(DataSet: TDataset);

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

              ReturnCode := MessageDlg('Do you wish to save your sketch changes?', mtConfirmation,
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
Procedure TSketchForm.CloseButtonClick(Sender: TObject);

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
        (*self.FormClose(Sender, Action); *)

end;  {CloseButtonClick}

{====================================================================}
Procedure TSketchForm.FormCloseQuery(    Sender: TObject;
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
Procedure TSketchForm.FormClose(    Sender: TObject;
                                    var Action: TCloseAction);

begin
  If (ApexInstalled and
      (ApexX <> nil))
    then
      try
        ApexX.CloseSketch;

        If not GlblLeaveApexActive
          then ApexX.CloseApex;

        ApexX.Free;
        ApexX := nil;
      except
      end;

  If (ApexInstalled and
      (ApexXv4 <> nil))
    then
      try
        ApexXv4.CloseSketch;

        If not GlblLeaveApexActive
          then ApexXv4.CloseApex;

        ApexXv4.Free;
        ApexXv4 := nil;
      except
      end;

    {Close all tables here.}

  CloseTablesForForm(Self);

  Action := caFree;

end;  {FormClose}


end.