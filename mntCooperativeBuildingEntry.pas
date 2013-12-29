unit mntCooperativeBuildingEntry;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Db, DBTables, Wwtable, Buttons, ToolWin,
  ComCtrls, ExtCtrls, wwdblook, Wwdatsrc, RPCanvas, RPrinter, RPDefine,
  RPBase, RPFiler;

type
  TfmCooperativeBuildingsEntry = class(TForm)
    gbxSwisCode: TGroupBox;
    MainToolBar: TToolBar;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    tmrButtonsState: TTimer;
    dsMain: TwwDataSource;
    tbMain: TwwTable;
    MainCodeLabel: TLabel;
    MunNameLabel: TLabel;
    edBuildingName: TDBEdit;
    EqualLabel: TLabel;
    edAssessment: TDBEdit;
    edTotalShares: TDBEdit;
    Label1: TLabel;
    dlgPrint: TPrintDialog;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    edSwisSBLKey: TEdit;
    tbSwisCodes: TTable;
    btnCalculate: TSpeedButton;
    btnApportion: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    edOwner: TDBEdit;
    Label4: TLabel;
    edMailAddr1: TDBEdit;
    Label5: TLabel;
    edMailAddr2: TDBEdit;
    edPrintKey: TDBEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tbMainAfterPost(DataSet: TDataSet);
    procedure tbMainAfterEdit(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReportPrint(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure tbMainBeforePost(DataSet: TDataSet);
    procedure btnCalculateClick(Sender: TObject);
    procedure btnApportionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    fOriginalTotalShares : Double;
    iOriginalAssessedValue : LongInt;
    lstCoopAVChanges : TList;
    bTrialRun, bInitializingForm, bExtractToExcel,
    bRecalculateThisYear, bRecalculateNextYear : Boolean;
    flExtractFile : TextFile;
    sCurrentAssessmentYear, sOriginalSwisSBLKey : String;

    Procedure InitializeForm(iCoopID : LongInt;
                             sEditMode : String);

    Procedure PrintApportionment;

    Procedure ApportionOneBuildingOneYear(iCoopID : LongInt;
                                          iProcessingType : Integer;
                                          sAssessmentYear : String;
                                          bTrialRun : Boolean;
                                          lstCoopAVChanges : TList;
                                          iCalcTotalAssessment : LongInt;
                                          fCalcTotalShares : Double;
                                          bUseCalculationValues : Boolean);

    Procedure SetButtonsState(bEnabled : Boolean);

  end;

implementation

{$R *.DFM}

uses DataAccessUnit, Utilitys, GlblCnst, WinUtils, GlblVars, UtilExSD, PASUtils,
     Prog, RTCalcul, Preview, PASTypes, Util_Coops;

{=========================================================================}
Procedure TfmCooperativeBuildingsEntry.SetButtonsState(bEnabled : Boolean);

begin
  If not bInitializingForm
    then
      begin
        btnSave.Enabled := bEnabled;
        btnCancel.Enabled := bEnabled;
      end;

end;  {SetButtonsState}

{=========================================================================}
Procedure TfmCooperativeBuildingsEntry.InitializeForm(iCoopID : LongInt;
                                                      sEditMode : String);

begin
  UnitName := 'mntCooperativeBuildingEntry';

  bInitializingForm := True;
  bRecalculateThisYear := False;
  bRecalculateNextYear := False;
  sOriginalSwisSBLKey := '';

  If _Compare(sEditMode, emBrowse, coEqual)
    then tbMain.ReadOnly := True;

  _OpenTablesForForm(Self, GlblProcessingType, []);

  If _Compare(sEditMode, [emBrowse, emEdit], coEqual)
    then
      begin
        _Locate(tbMain, [iCoopID], '', []);

        If _Compare(sEditMode, emEdit, coEqual)
          then tbMain.Edit;

          {FXX02262009-1(2.17.1.2): If only the SBL is displayed, it cannot be converted back.}

        sOriginalSwisSBLKey := tbMain.FieldByName('CoopSwisSBL').AsString;
        edSwisSBLKey.Text := ConvertSwisSBLToDashDot(tbMain.FieldByName('CoopSwisSBL').AsString);
        edSwisSBLKey.ReadOnly := True;
        ActiveControl := edBuildingName;

      end
    else
      begin
        fOriginalTotalShares := 0;
        iOriginalAssessedValue := 0;

        _InsertRecord(tbMain, [], [], [irSuppressPost]);

        iCoopID := tbMain.FieldByName('CoopID').AsInteger;
        edSwisSBLKey.Text := '';
        ActiveControl := edSwisSBLKey;

      end;  {else of If _Compare(sEditMode, [emBrowse, emEdit], coEqual)}

  gbxSwisCode.Caption := ' Coop Building #' + IntToStr(iCoopID) + ': ';
  lstCoopAVChanges := TList.Create;
  bInitializingForm := False;

end;  {InitializeForm}

{==========================================================}
Procedure TfmCooperativeBuildingsEntry.EditChange(Sender: TObject);

begin
  SetButtonsState(True);
end;

{==========================================================}
Procedure TfmCooperativeBuildingsEntry.FormKeyPress(    Sender: TObject;
                                                      var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Perform(WM_NEXTDLGCTL, 0, 0);
        Key := #0;
      end;

end;  {FormKeyPress}

{====================================================================}
Procedure TfmCooperativeBuildingsEntry.tbMainAfterEdit(DataSet: TDataSet);

begin
  with tbMain do
    begin
      fOriginalTotalShares := FieldByName('TotalShares').AsFloat;
      iOriginalAssessedValue := FieldByName('AssessedValue').AsInteger;
    end;

end;  {tbMainAfterEdit}

{==========================================================}
Procedure TfmCooperativeBuildingsEntry.tbMainBeforePost(DataSet: TDataSet);

var
  bValidEntry : Boolean;
  sSwisSBLKey : String;

begin
  If _Compare(sOriginalSwisSBLKey, coBlank)
  then
  begin
    bValidEntry := True;
    sSwisSBLKey := ConvertSwisDashDotToSwisSBL(edSwisSBLKey.Text, tbSwisCodes, bValidEntry);
    tbMain.FieldByName('CoopSwisSBL').AsString := Copy(sSwisSBLKey, 1, 6) +
                                                       GetCooperativeBase(Copy(sSwisSBLKey, 7, 20), '',
                                                                          True, GlblCoopBaseSBLHasSubblock);
  end;  {If _Compare(sOriginalSwisSBLKey, coBlank)}

end;  {tbMainBeforePost}

{==========================================================}
Procedure TfmCooperativeBuildingsEntry.btnSaveClick(Sender: TObject);

begin
  case MessageDlg('Are you sure you want to save these coop changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
    idYes:
      try
        tbMain.Post;
        ModalResult := mrOK;
      except
        SystemSupport(1, tbMain, 'Error posting record.', UnitName, GlblErrorDlgBox);
      end;

    idNo:
      try
        tbMain.Cancel;
        ModalResult := mrCancel;
      except
      end;

  end;  {case MessageDlg...}

end;  {btnSaveClick}

{==========================================================}
Procedure TfmCooperativeBuildingsEntry.btnCancelClick(Sender: TObject);

begin
  tbMain.Cancel;
  ModalResult := mrCancel;

end;  {btnCancelClick}

{====================================================================}
Procedure TfmCooperativeBuildingsEntry.ReportPrint(Sender: TObject);

begin
  PrintApportionmentOneBuilding(Sender, lstCoopAVChanges,
                                sCurrentAssessmentYear, bExtractToExcel,
                                flExtractFile);
end;  {ReportPrint}

{====================================================================}
Procedure TfmCooperativeBuildingsEntry.PrintApportionment;

var
  sNewFileName, sSpreadsheetFileName : String;
  flTempFile : File;

begin
  If dlgPrint.Execute
    then
      begin
        If bExtractToExcel
          then
            begin
              sSpreadsheetFileName := GetPrintFileName('CoopApportionment' + '_' +
                                                        sCurrentAssessmentYear + '_', True);
              AssignFile(flExtractFile, sSpreadsheetFileName);
              Rewrite(flExtractFile);

              WritelnCommaDelimitedLine(flExtractFile,
                                        ['Parcel ID',
                                         'Shares',
                                         'Share %',
                                         'Current AV',
                                         'New AV',
                                         'Difference']);

            end;  {If bExtractToExcel}

        If dlgPrint.PrintToFile
          then
            begin
              sNewFileName := GetPrintFileName(Self.Caption, True);
              ReportFiler.FileName := sNewFileName;

              try
                PreviewForm := TPreviewForm.Create(self);
                PreviewForm.FilePrinter.FileName := sNewFileName;
                PreviewForm.FilePreview.FileName := sNewFileName;

                ReportFiler.Execute;
                PreviewForm.ShowModal;
              finally
                PreviewForm.Free;

                  {Now delete the file.}
                try
                  AssignFile(flTempFile, sNewFileName);
                  OldDeleteFile(sNewFileName);
                finally
                  {We don't care if it does not get deleted, so we won't put up an
                   error message.}

                  ChDir(GlblProgramDir);
                end;

              end;  {If PrintRangeDlg.PreviewPrint}

            end  {They did not select preview, so we will go
                  right to the printer.}
          else ReportPrinter.Execute;

        If bExtractToExcel
          then
            begin
              CloseFile(flExtractFile);
              SendTextFileToExcelSpreadsheet(sSpreadsheetFileName, True,
                                             False, '');

            end;  {If PrintToExcel}

      end;  {If dlgPrint.Execute}

end;  {PrintApportionment}

{====================================================================}
Procedure TfmCooperativeBuildingsEntry.ApportionOneBuildingOneYear(iCoopID : LongInt;
                                                                   iProcessingType : Integer;
                                                                   sAssessmentYear : String;
                                                                   bTrialRun : Boolean;
                                                                   lstCoopAVChanges : TList;
                                                                   iCalcTotalAssessment : LongInt;
                                                                   fCalcTotalShares : Double;
                                                                   bUseCalculationValues : Boolean);

begin
  ApportionCoopBuilding(iCoopID,
                        bTrialRun, True,
                        iProcessingType, sAssessmentYear,
                        lstCoopAVChanges,
                        True, iCalcTotalAssessment,
                        fCalcTotalShares, bUseCalculationValues);

  sCurrentAssessmentYear := sAssessmentYear;

  PrintApportionment;

end;  {ApportionOneBuildingOneYear}

{====================================================================}
Procedure TfmCooperativeBuildingsEntry.tbMainAfterPost(DataSet: TDataSet);

begin
  with tbMain do
    begin
      If (((DataSet = nil) or
           _Compare(fOriginalTotalShares, FieldByName('TotalShares').AsFloat, coNotEqual) or
           _Compare(iOriginalAssessedValue, FieldByName('AssessedValue').AsInteger, coNotEqual)) and
          (MessageDlg('Do you want to recalculate the values of the units?',
                      mtConfirmation, [mbYes, mbNo], 0) = idYes))
        then
          begin
            bTrialRun := (MessageDlg('Do you want to do a trial run?', mtConfirmation, [mbYes, mbNo], 0) = idYes);
            bExtractToExcel := (MessageDlg('Do you want to extract the information to Excel?',
                                           mtConfirmation, [mbYes, mbNo], 0) = idYes);

            ApportionOneBuildingOneYear(FieldByName('CoopID').AsInteger, GlblProcessingType,
                                        GetTaxRlYr, bTrialRun, lstCoopAVChanges,
                                        0, 0, False);

            If _Compare(GlblProcessingType, ThisYear, coEqual)
              then bRecalculateThisYear := True
              else bRecalculateNextYear := True;

            If (_Compare(GlblProcessingType, ThisYear, coEqual) and
                GlblModifyBothYears)
              then
                begin
                  bRecalculateNextYear := True;
                  MessageDlg('The ' + GlblNextYear + ' values will now be apportioned.',
                             mtInformation, [mbOK], 0);

                  ApportionOneBuildingOneYear(FieldByName('CoopID').AsInteger, NextYear, GlblNextYear,
                                              bTrialRun, lstCoopAVChanges, 0, 0, False);

                end;  {If (_Compare(GlblProcessingType, ThisYear, coEqual)...}

          end;  {If (MessageDlg('The exemptions ...}

    end;  {with tbMain do}

end;  {tbMainAfterPost}

{====================================================================}
Procedure TfmCooperativeBuildingsEntry.btnApportionClick(Sender: TObject);

{CHG07062010-1(2.27.1)[I7717]: Add a button to apportion only.}

begin
  tbMainAfterPost(nil);
end;

{====================================================================}
Procedure TfmCooperativeBuildingsEntry.btnCalculateClick(Sender: TObject);

var
  iCalcTotalAssessment : LongInt;
  fCalcTotalShares : Double;

begin
  try
    iCalcTotalAssessment := StrToInt(edAssessment.Text);
  except
    iCalcTotalAssessment := 0;
  end;

  try
    fCalcTotalShares := StrToFloat(edTotalShares.Text);
  except
    fCalcTotalShares := 0;
  end;

  bExtractToExcel := (MessageDlg('Do you want to extract the information to Excel?',
                                 mtConfirmation, [mbYes, mbNo], 0) = idYes);

  ApportionOneBuildingOneYear(tbMain.FieldByName('CoopID').AsInteger, GlblProcessingType,
                              GetTaxRlYr, True, lstCoopAVChanges,
                              iCalcTotalAssessment, fCalcTotalShares, True);

end;  {btnCalculateClick}

{=======================================================================}
Procedure TfmCooperativeBuildingsEntry.FormCloseQuery(    Sender: TObject;
                                                        var CanClose: Boolean);

var
  Selection : Integer;

begin
  CanClose := True;
  If tbMain.Modified
    then
      begin
        Selection := MessageDlg('Do you want to save the changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);

        case Selection of
          idYes : btnSaveClick(Sender);
          idNo : btnCancelClick(Sender);
          idCancel : CanClose := False;
        end;

      end;  {If tbMain.Modified}

end;  {FormCloseQuery}

{====================================================================}
Procedure TfmCooperativeBuildingsEntry.FormClose(    Sender: TObject;
                                                 var Action: TCloseAction);

begin
  CloseTablesForForm(Self);
  FreeTList(lstCoopAVChanges, SizeOf(rCoopAVChange))
end;


end.
