unit PPermits_Municity_Subform;

{$H+}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Wwtable, wwdblook, Buttons, ToolWin, ComCtrls,
  Mask, ExtCtrls, StdCtrls, ADODB, DBCtrls, RPCanvas, RPrinter, RPDefine,
  RPBase, RPFiler;

type
  TPermitsMunicityEditDialogForm = class(TForm)
    MainToolBar: TToolBar;
    SaveButton: TSpeedButton;
    CancelButton: TSpeedButton;
    EntryInformationGroupBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    PermitInformationGroupBox: TGroupBox;
    ButtonsStateTimer: TTimer;
    SaveAndExitButton: TSpeedButton;
    ADO_MainQuery2: TADOQuery;
    Label6: TLabel;
    Label15: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    Label16: TLabel;
    Label20: TLabel;
    AssessorComments: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    AssessorTempDate1: TEdit;
    AssessorTempDate2: TEdit;
    Label7: TLabel;
    AssessorOfficeClosed: TCheckBox;
    AssessorNextInspDate: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    Description: TMemo;
    ApplicaNo: TEdit;
    ApplicaDate1: TEdit;
    PermitNo: TEdit;
    PermitDate: TEdit;
    PermStatus: TEdit;
    PermitType: TEdit;
    ImproveType: TEdit;
    ProposedUse: TEdit;
    StartedDate: TEdit;
    CompletedDate: TEdit;
    CertificateDate: TEdit;
    CertComplianceDate: TEdit;
    ConstCost: TEdit;
    Bevel1: TBevel;
    qryCertificates: TADOQuery;
    btnPrintFieldSheet: TSpeedButton;
    PrintDialog: TPrintDialog;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    ParcelTable: TTable;
    procedure EditChange(Sender: TObject);
    Procedure ChangeDate(Sender: TObject);
    procedure ButtonsStateTimerTimer(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SaveAndExitButtonClick(Sender: TObject);
    procedure btnPrintFieldSheetClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    DataChanged : Boolean;
    UnitName, SwisSBLKey, EditMode : String;
    PermitID : Integer;

    Procedure Load;
    Function Save : Boolean;
    Procedure SetReadOnlyFields;
    Procedure InitializeForm(_SwisSBLKey : String;
                              _PermitID : Integer;
                              _EditMode : String);
  end;

var
  PermitsMunicityEditDialogForm: TPermitsMunicityEditDialogForm;

implementation

{$R *.DFM}

uses PASUtils, DataAccessUnit, GlblCnst, Utilitys, GlblVars, WinUtils,
  Preview, PASTypes;


{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.Load;

var
  sCertificateDate : String;

begin
  with ADO_MainQuery2 do
    try
      IF Active THEN
      BEGIN
        if (EOF or BOF) then First;
        Close;
      END; {IF Active}

      with SQL do
        begin
          Clear;
          Add('SELECT');
          Add(' ApplicaNo, ApplicaDate1, Permits.Permit_ID, PermitNo, Permits.PermitDate,');
          Add(' PermStatus, Permits.PermitType, ImproveType, Permits.ProposedUse,');
          Add(' StartedDate, CompletedDate, CertOccupancyDate, CertComplianceDate,');
          Add('	Permits.Description, Permits.ConstCost,');
          Add(' AssessorTempDate1, AssessorTempDate2, AssessorNextInspDate,');
          Add(' AssessorOfficeClosed, AssessorComments, Parcel_ID');
          Add('FROM Permits ');
          Add('WHERE Permits.Permit_ID = ' + '''' + IntToStr(PermitID) + ''' ');
          Open;

        end;  {with SQL do}

    except
    end; {ADO_MainQuery2}

  DatasetLoadToForm(Self, ADO_MainQuery2);
  (*Memo1.Lines.Assign(ADO_MainQuery2.SQL); *)

  sCertificateDate := GetMunicityCODateForPermit(qryCertificates,
                                                 ADO_MainQuery2.FieldByName('Permit_ID').AsString,
                                                 ADO_MainQuery2.FieldByName('Parcel_ID').AsString);

  If _Compare(sCertificateDate, coBlank)
    then sCertificateDate := ADO_MainQuery2.FieldByName('CertOccupancyDate').AsString;

  CertificateDate.Text := sCertificateDate;

end;  {Load}

{=========================================================================}
Function TPermitsMunicityEditDialogForm.Save : Boolean;
var
  TempDate1, TempDate2, NextInspDate : String;
  strOfficeClosed : String;
  strComments : WideString;

begin
  Result := True;

  TempDate1 := Trim(PermitsMunicityEditDialogForm.AssessorTempDate1.Text);
  TempDate2 := Trim(PermitsMunicityEditDialogForm.AssessorTempDate2.Text);
  NextInspDate := Trim(PermitsMunicityEditDialogForm.AssessorNextInspDate.Text);

  strOfficeClosed := '';
  if PermitsMunicityEditDialogForm.AssessorOfficeClosed.Checked then
     strOfficeClosed := 'True';

  strComments := QuotedStr(PermitsMunicityEditDialogForm.AssessorComments.Text);
  strComments := Copy(strComments,2,length(strComments)-2);

  If (DataChanged) Then
    with PermitsMunicityEditDialogForm.ADO_MainQuery2 do begin
      TRY
        If Active Then
        Begin
          if (EOF or BOF) then First;
          Close;
        End; {IF Active}

        SQL.Clear;
        SQL.Add('UPDATE Permits');
        SQL.Add(' SET');
        if TempDate1 <> '' then
          SQL.Add(' AssessorTempDate1 = ' + '''' + TempDate1 + ''',')
        else
          SQL.Add(' AssessorTempDate1 = NULL,');

        if TempDate2 <> '' then
          SQL.Add(' AssessorTempDate2 = ' + '''' + TempDate2 + ''',')
        else
          SQL.Add(' AssessorTempDate2 = NULL,');

        if NextInspDate <> '' then
          SQL.Add(' AssessorNextInspDate = ' + '''' + NextInspDate + ''',')
        else
          SQL.Add(' AssessorNextInspDate = NULL,');
        
        SQL.Add(' AssessorOfficeClosed = ' + '''' +  strOfficeClosed + ''',');
        SQL.Add(' AssessorComments = ' + '''' + strComments + ''' ');
        SQL.Add(' WHERE Permit_ID = ' + '''' + IntToStr(PermitID) + ''' ');
        ExecSQL;
      EXCEPT
        Result := False;
      END; {TRY}
    end; {with PermitsMunicityEditDialogForm.ADO_MainQuery2}

  DataChanged := False;

end;  {Save}

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.EditChange(Sender: TObject);

begin
  DataChanged := GetDataChangedStateForComponent(Sender);
end;  {EditChange}

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.ChangeDate(Sender: TObject);
begin

  with Sender as TEdit do
    if TEdit(Sender).Text <> '' then
    begin
      try
        with Sender as TEdit do
          StrToDate(TEdit(Sender).Text);
      except
        ShowMessage('You entered an invalid Date.  Please correct.');
        with Sender as TEdit do
          TEdit(Sender).SetFocus;
      end; {try}
    end; {if TEdit(Sender).Text <> ''}
end;  {ExitDate}

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.ButtonsStateTimerTimer(Sender: TObject);

var
  Enabled : Boolean;

begin
  Enabled := DataChanged;

  SaveButton.Enabled := Enabled;
  CancelButton.Enabled := Enabled;
  SaveAndExitButton.Enabled := Enabled;

end;  {ButtonsStateTimerTimer}

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.SetReadOnlyFields;

begin
  //Municity Permits Fields that are always disabled for PAS
  ApplicaNo.ReadOnly := True;
  ApplicaDate1.ReadOnly := True;
  PermitNo.ReadOnly := True;
  PermitDate.ReadOnly := True;
  PermStatus.ReadOnly := True;
  PermitType.ReadOnly := True;
  ImproveType.ReadOnly := True;
  ProposedUse.ReadOnly := True;
  StartedDate.ReadOnly := True;
  CompletedDate.ReadOnly := True;
  CertificateDate.ReadOnly := True;
  CertComplianceDate.ReadOnly := True;
  ConstCost.ReadOnly := True;
  Description.ReadOnly := True;

  //Municity Permits Fields that are specifically for PAS/Assessor's Office
  AssessorTempDate1.ReadOnly := False;
  AssessorTempDate2.ReadOnly := False;
  AssessorNextInspDate.ReadOnly := False;
  AssessorOfficeClosed.Enabled := True;
  AssessorComments.ReadOnly := False;

end;  {SetReadOnlyFields}

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.InitializeForm(_SwisSBLKey : String;
                                                         _PermitID : Integer;
                                                         _EditMode : String);

var
  ReadOnlyStatus, Found : Boolean;

begin
  UnitName := 'PPermits_Municity_Subform';
  PermitID   := _PermitID;
  SwisSBLKey := _SwisSBLKey;

  Caption := 'Permit ID: ' + IntToStr(PermitID) +
             ' for Parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey);

  ADO_MainQuery2.ConnectionString := 'FILE NAME=' + GlblDrive + ':' + GlblProgramDir + 'pasMunicity.udl';
  qryCertificates.ConnectionString := 'FILE NAME=' + GlblDrive + ':' + GlblProgramDir + 'pasMunicity.udl';
  Load;

  If (_Compare(_EditMode, emEdit, coEqual) ) Then
     ReadOnlyStatus := False
  Else
     ReadOnlyStatus := True;

  SetReadOnlyFields;
  If ReadOnlyStatus Then
    SetComponentsToReadOnly(Self);

  DataChanged := False;

  OpenTablesForForm(Self, NextYear);

  Found := _Locate(ParcelTable, [GlblNextYear, _SwisSBLKey], '', [loParseSwisSBLKey]);

  If not Found
    then SystemSupport(001, ParcelTable, 'Error finding key in parcel table.', UnitName, GlblErrorDlgBox);

  ButtonsStateTimer.Enabled := True;

end;  {InitializeForm}

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.FormKeyPress(    Sender: TObject;
                                             var Key: Char);

begin
  If ((Key = #13) and
      (not (ActiveControl is TMemo)))
    then
      begin
        Perform(WM_NEXTDLGCTL, 0, 0);
        Key := #0;
      end;

end;  {FormKeyPress}

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.SaveAndExitButtonClick(Sender: TObject);

begin
  If Save Then
  Begin
     WITH PermitsMunicityEditDialogForm.ADO_MainQuery2 DO
       TRY
         If Active Then
         Begin
           if (EOF or BOF) then First;
           Close;
         End; {IF Active}
       EXCEPT
       END;

     Close;
  End; {If Save}
  ModalResult := mrOK;
end;

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.SaveButtonClick(Sender: TObject);

begin
  Save;
end;

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.CancelButtonClick(Sender: TObject);

begin
  If DataChanged
    then
      begin
        If (MessageDlg('Do you want to cancel your changes?', mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            begin
              DataChanged := False;
              ModalResult := mrCancel;
            end;
      end
    else ModalResult := mrCancel;

end;  {CancelButtonClick}

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.FormCloseQuery(    Sender: TObject;
                                               var CanClose: Boolean);

var
  ReturnCode : Integer;

begin
  If DataChanged
    then
      begin
        ReturnCode := MessageDlg('Do you want to save your changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);

        case ReturnCode of
          idYes : begin
                    Save;
                    ModalResult := mrOK;
                  end;

          idNo : ModalResult := mrCancel;

          idCancel : CanClose := False;

        end;  {case ReturnCode of}

      end;  {If DataChanged}

  WITH PermitsMunicityEditDialogForm.ADO_MainQuery2 DO
    Try
      IF Active THEN
      BEGIN
        if (EOF or BOF) then First;
        Close;
      END; {IF Active}
    Except
    End; {Try}

end;  {FormCloseQuery}

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.btnPrintFieldSheetClick(Sender: TObject);

var
  bQuit : Boolean;
  NewFileName : String;
  TempFile : File;

begin
  If PrintDialog.Execute
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, bQuit);

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

      end;  {If PrintDialog.Execute}

end;  {btnPrintFieldSheetClick}

{=========================================================================}
Procedure TPermitsMunicityEditDialogForm.ReportPrint(Sender: TObject);

var
  I, StartIndex : Integer;
  bName2FilledIn : Boolean;
  NAddrArray : NameAddrArray;

begin
  GetNameAddress(ParcelTable, NAddrArray);

  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.5;
      SetFont('Times New Roman',20);
      Home;
      CRLF;
      Bold := True;
      Underline := True;
      PrintCenter('FIELD ASSESSMENT RECORD', (PageWidth / 2));
      Bold := False;
      Underline := False;
      CRLF;
      CRLF;
      CRLF;
      ClearTabs;
      SetTab(5.6, pjLeft, 2.0, 0, BOXLINENone, 0);   {Parcel ID}
      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));
      CRLF;

      SetFont('Times New Roman',12);
      ClearTabs;
      SetTab(6.3, pjLeft, 2.0, 0, BOXLINENone, 0);
      Println(#9 + 'Appointments');

      ClearTabs;
      SetFont('Times New Roman',12);
      SetTab(0.6, pjLeft, 1.2, 0, BOXLINENone, 0);
      SetTab(6.0, pjLeft, 1.5, 0, BOXLINEBottom, 0);

      Println(#9 + #9 + '');
      Println(#9 + 'Permit # ' + PermitNo.Text +
              #9 + '');
      Println(#9 + #9 + '');
      Println(#9 + 'Permit Date ' + PermitDate.Text +
              #9 + '');

      ClearTabs;
      SetFont('Times New Roman',12);
      SetTab(0.6, pjLeft, 1.2, 0, BOXLINENone, 0);
      SetTab(5.5, pjLeft, 0.7, 0, BOXLINENone, 0);
      SetTab(6.2, pjLeft, 1.5, 0, BOXLINENone, 0);

      Println('');
      Println(#9 + 'Est Cost Ltr. ' + ConstCost.Text +
              #9 + 'Partial' +
              #9 + '______');

      Println('');
      Println(#9 + 'Affidavit of Cost ' +
              #9 + 'Complete' +
              #9 + '______');

      CRLF;
      CRLF;
      SetFont('Times New Roman',14);
      Bold := True;
      Underline := True;
      PrintCenter('SCOPE OF PROJECT', (PageWidth / 2));
      Bold := False;
      Underline := False;
      CRLF;
      ClearTabs;
      SetFont('Times New Roman',12);
      SetTab(0.3, pjLeft, 8.0, 0, BOXLINENone, 0);

      For I := 0 to (Description.Lines.Count - 1) do
      Println(#9 + Description.Lines[I]);

      For I := (Description.Lines.Count + 1) to 8 do
        Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BOXLINEBottom, 0);

      Println(#9 + '');

      ClearTabs;
      SetFont('Times New Roman',12);
      SetTab(0.6, pjLeft, 3.0, 0, BOXLINENone, 0);

        {Addr should be legal addr, not mailing.}

      bName2FilledIn := _Compare(ParcelTable.FieldByName('Name2').AsString, coNotBlank);

      If bName2FilledIn
        then StartIndex := 3
        else StartIndex := 2;

        {Clear out everything after the name.}

      For I := StartIndex to 6 do
        NAddrArray[I] := '';

      NAddrArray[StartIndex] := GetLegalAddressFromTable(ParcelTable);

      NAddrArray[StartIndex + 1] := Trim(ParcelTable.FieldByName('LegalCity').AsString) +
                                    ', NY ' +
                                    ParcelTable.FieldByName('LegalZip').AsString;

      Println('');
      For I := 1 to 6 do
        Println(#9 + NAddrArray[I]);

      Println('');

      ClearTabs;
      SetFont('Times New Roman',12);
      SetTab(0.6, pjLeft, 0.7, 0, BOXLINENone, 0);
      SetTab(1.3, pjLeft, 0.2, 0, BOXLINENone, 0);
      SetTab(1.6, pjLeft, 1.3, 0, BOXLINEBottom, 0);

      Println(#9 + 'PHONE#' +
              #9 + '(H)' +
              #9 + '');
      Println(#9 + '' +
              #9 + '(C)' +
              #9 + '');
      Println(#9 + '' +
              #9 + '(W)' +
              #9 + '');
      Println('');

      CRLF;
      SetFont('Times New Roman',14);
      Bold := True;
      Underline := True;
      PrintCenter('COMMENTS', (PageWidth / 2));
      Bold := False;
      Underline := False;
      CRLF;

    end;  {with Sender as TBaseReport do}

end; {ReportPrint}

end.
