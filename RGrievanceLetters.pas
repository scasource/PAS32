unit RGrievanceLetters;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls,  DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwdatsrc, Menus,
  DBTables, Wwtable, Btrvdlg, RPFiler, RPBase, RPCanvas, RPrinter, Mask,
  Gauges, RPMemo, RPDBUtil, RPDefine, (*Progress,*) Types, RPTXFilr, PASTypes,
  Progress, TabNotBk, ComCtrls, OleCtnrs, Word97, OleServer,
  FileCtrl, UtilOLE, CheckLst;

type
  TGreivanceLettersForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintDialog: TPrintDialog;
    GrievanceResultsDetailsTable: TwwTable;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    GrievanceResultsTable: TTable;
    BoardMemberCodeTable: TTable;
    MergeLetterDefinitionsTable: TwwTable;
    MergeFieldsAvailableTable: TTable;
    MergeLetterTable: TwwTable;
    MergeLetterDataSource: TwwDataSource;
    WordDocument: TWordDocument;
    WordApplication: TWordApplication;
    GrievanceTable: TTable;
    GrievanceLetterSentTable: TTable;
    TempRichEdit: TDBRichEdit;
    GrievanceResultsDataSource: TDataSource;
    GrievanceLookupTable: TTable;
    OLEItemNameTimer: TTimer;
    GrievanceDispositionCodeTable: TwwTable;
    LabelReportPrinter: TReportPrinter;
    LabelReportFiler: TReportFiler;
    SwisCodeTable: TTable;
    ParcelTable: TTable;
    PageControl1: TPageControl;
    LetterOptionsTabSheet: TTabSheet;
    Label5: TLabel;
    LetterTypeRadioGroup: TRadioGroup;
    PrintOrderRadioGroup: TRadioGroup;
    GrievanceResultsTypeCheckListBox: TCheckListBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    CreateParcelListCheckBox: TCheckBox;
    PrintReportCheckBox: TCheckBox;
    GrievanceYearEdit: TEdit;
    CommercialPropertiesOnlyCheckBox: TCheckBox;
    ReprintLettersCheckBox: TCheckBox;
    TrialRunCheckBox: TCheckBox;
    ExcludeDuplicatesCheckBox: TCheckBox;
    ExtractOnlyCheckBox: TCheckBox;
    LetterDateEdit: TMaskEdit;
    PrintOnlyLettersWithRepresentativesCheckBox: TCheckBox;
    PrintRepresentativeLettersForPetitionersCheckBox: TCheckBox;
    LoadFromParcelListCheckBox: TCheckBox;
    SendToRepresentativesCheckBox: TCheckBox;
    MoreOptionsTabSheet: TTabSheet;
    LabelPrintTypeRadioGroup: TRadioGroup;
    PrintDuplicateLabelsCheckBox: TCheckBox;
    LettersTabSheet: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    LetterFileNameLabel: TDBText;
    Label4: TLabel;
    LetterOleContainer: TOleContainer;
    NewLetterButton: TBitBtn;
    RemoveLetterButton: TBitBtn;
    MergeFieldsUsedListBox: TListBox;
    AddFieldButton: TButton;
    RemoveFieldButton: TButton;
    wwDBGrid1: TwwDBGrid;
    Panel3: TPanel;
    LoadButton: TBitBtn;
    SaveButton: TBitBtn;
    PrintButton: TBitBtn;
    CloseButton: TBitBtn;
    tbExemptionCodes: TTable;
    tbGrievanceExemptionsAsked: TTable;
    cbSendToHomeowner: TCheckBox;
    tbGrievanceDenialReasons: TwwTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure NewLetterButtonClick(Sender: TObject);
    procedure MergeLetterTableAfterScroll(DataSet: TDataSet);
    procedure RemoveLetterButtonClick(Sender: TObject);
    procedure AddFieldButtonClick(Sender: TObject);
    procedure RemoveFieldButtonClick(Sender: TObject);
    procedure OLEItemNameTimerTimer(Sender: TObject);
    procedure LetterOleContainerMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LabelPrint(Sender: TObject);
    procedure LabelPrintHeader(Sender: TObject);
  private
    { Private declarations }
  public
    ReportCancelled : Boolean;

    { Public declarations }
    UnitName : String;

    CommercialParcelsOnly,
    CreateParcelList,
    TrialRun, ExtractOnly,
    PrintDuplicateLabels,
    PrintReport, ReprintLetters, ExcludeDuplicates, SendToRepresentatives : Boolean;
    LetterType, PrintOrder : Integer;
    LetterName : String;

    GrievanceYear : String;

    MergeFieldsToPrint,
    LettersPrinted : TStringList;
    GrievanceNumbersPrinted : TStringList;
    SelectedGrievanceResultsTypeList : TStringList;
    LabelPrintType : Integer;

    LetterDate : TDateTime;

      {Label variables.}

    lb_PrintLabelsBold,
    lb_PrintOldAndNewParcelIDs,
    lb_PrintSwisCodeOnParcelIDs,
    lb_PrintParcelIDOnly : Boolean;

    lb_LabelType,
    lb_NumLinesPerLabel,
    lb_NumLabelsPerPage,
    lb_NumColumnsPerPage,
    lb_SingleParcelFontSize : Integer;

    lb_ResidentLabels, lb_LegalAddressLabels,
    lb_PrintParcelIDOnlyOnFirstLine : Boolean;
    lb_LaserTopMargin : Real;
    lb_PrintParcelID_PropertyClass : Boolean;
    InitializingForm, LoadFromParcelList,
    PrintOnlyLettersWithRepresentatives,
    PrintOnlyLettersWithDifferentPetitionerAndRepresentatives : Boolean;

    Procedure InitializeForm;  {Open the ScreenLabelTables and setup.}
    Function PrintThisLetter(GrievanceTable : TTable;
                             GrievanceResultsTable : TTable;
                             GrievanceNumber : Integer;
                             LastGrievanceNumber : Integer;
                             SwisSBLKey : String;
                             LastSwisSBLKey : String;
                             GrievanceNumbersPrinted : TStringList;
                             LoadFromParcelList : Boolean;
                             GrievanceFound : Boolean) : Boolean;

    Procedure PrintLetters;
    Procedure SetPrintOrder;

  end;

implementation
Uses Utilitys,  {General utilitys}
     PASUTILS, {PAS specific utilitys}
     GlblCnst,  {Global constants}
     GlblVars,  {Global variables}
     WinUtils,  {General Windows utilitys}
     Utilexsd,
     Prog,
     RptDialg,
     PRCLLIST,
     NewLetterDialog,
     GrievanceUtilitys,
     LabelOptionsDialogUnit,
     DataAccessUnit,
     Preview;

{$R *.DFM}

const
  ltResults = 0;
  ltOther = 1;

  poGrievanceNumber = 0;
  poParcelID = 1;
  poRepresentative_ParcelID = 2;

  ccAssessment = 0;
  ccExemption = 1;
  ccClassified = 2;
  ccOther = 3;

  lptNone = 0;
  lptByParcelID = 1;
  lptByGrievanceNumber = 2;
  lptByPetitionerName = 3;

{========================================================}
Procedure TGreivanceLettersForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TGreivanceLettersForm.InitializeForm;

begin
  InitializingForm := True;
  UnitName := 'RGrievanceLetters';  {mmm}

  OpenTablesForForm(Self, NextYear);

  MergeFieldsToPrint := TStringList.Create;
  LettersPrinted := TStringList.Create;

  GrievanceYearEdit.Text := DetermineGrievanceYear;
  LetterDateEdit.Text := DateToStr(Date);

  SelectedGrievanceResultsTypeList := TStringList.Create;

  FillOneListBox(GrievanceResultsTypeCheckListBox,
                 GrievanceDispositionCodeTable,
                 'Code', 'Description', 0,
                 True, False, GlblProcessingType,
                 GrievanceYearEdit.Text);

  InitializingForm := False;

  MergeLetterTableAfterScroll(MergeLetterTable);

end;  {InitializeForm}

{===================================================================}
Procedure TGreivanceLettersForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{====================================================================}
Procedure TGreivanceLettersForm.SaveButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  SaveReportOptions(Self, OpenDialog, SaveDialog, 'Grievance Letters.glt', 'Grievance Letters');

end;  {SaveButtonClick}

{====================================================================}
Procedure TGreivanceLettersForm.LoadButtonClick(Sender: TObject);

{FXX04091999-8: Add ability to save and load search report options.}

begin
  LoadReportOptions(Self, OpenDialog, 'Grievance Letters.glt', 'Grievance Letters');

end;  {LoadButtonClick}

{====================================================================}
Procedure TGreivanceLettersForm.OLEItemNameTimerTimer(Sender: TObject);

begin
  If GlblApplicationIsActive
    then
      begin
        OLEItemNameTimer.Enabled := False;
        MergeLetterTableAfterScroll(MergeLetterTable);
      end
    else
      If (MergeLetterTable.State in [dsEdit, dsInsert])
        then
          try
            MergeLetterTable.FieldByName('FileName').Text := WordDocument.FullName;
          except
          end;

end;  {OLEItemNameTimerTimer}

{========================================================================}
Procedure TGreivanceLettersForm.NewLetterButtonClick(Sender: TObject);

var
  TemplateName : OleVariant;

begin
  try
    NewLetterDialogForm := TNewLetterDialogForm.Create(nil);

    If (NewLetterDialogForm.ShowModal = idOK)
      then
        begin
          If not DirectoryExists(GlblLetterTemplateDir)
            then MkDir(GlblLetterTemplateDir);

          TemplateName := GlblLetterTemplateDir + MergeLetterTable.FieldByName('LetterName').Text;
             {Launch either word perfect or word.}

          If (NewLetterDialogForm.WordProcessorToUse = dtMSWord)
            then
              begin
                with WordApplication do
                  begin
                    Connect;
                    Visible := True;
                    WindowState := wdWindowStateMaximize;
                    Activate;

                    Documents.Add(EmptyParam, EmptyParam);
                    WordDocument.ConnectTo(ActiveDocument);
                    OLEItemNameTimer.Enabled := True;
                    GlblApplicationIsActive := False;

                  end;  {with WordApplication do}

              end;  {If (NewLetterDialogForm.WordProcessorToUse = dtWord)}

        end;  {If (NewLetterDialogForm.ShowModal = idOK)}

  finally
    NewLetterDialogForm.Free;
  end;

end;  {NewLetterButtonClick}

{========================================================================}
Procedure TGreivanceLettersForm.MergeLetterTableAfterScroll(DataSet: TDataSet);

var
  TemplateName : OLEVariant;

begin
  If not InitializingForm
    then
      begin
        TemplateName := MergeLetterTable.FieldByName('FileName').Text;

          {FXX07252002-2: Make sure to have a try..except around the container create.}

        If (_Compare(MergeLetterTable.FieldByName('LetterName').Text, coNotBlank) and
            FileExists(TemplateName))
          then
            try
              LetterOLEContainer.CreateObjectFromFile(TemplateName, False);
            except
              LetterOLEContainer.DestroyObject;
              LetterOLEContainer.SizeMode := smClip;
              LetterOLEContainer.CreateObjectFromFile(TemplateName, False);
            end;

        SetRangeOld(MergeLetterDefinitionsTable, ['LetterName'],
                    [MergeLetterTable.FieldByName('LetterName').Text],
                    [MergeLetterTable.FieldByName('LetterName').Text]);

        FillOneListBox(MergeFieldsUsedListBox,
                       MergeLetterDefinitionsTable,
                       'MergeFieldName',
                       '', 0, False, False,
                       NoProcessingType, '');

      end;  {If not InitializingForm}

end;  {MergeLetterTableAfterScroll}

{========================================================================}
Procedure TGreivanceLettersForm.RemoveLetterButtonClick(Sender: TObject);

begin
  If (MessageDlg('Are you sure you want to remove letter template ' +
                 MergeLetterTable.FieldByName('LetterName').Text + '?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        try
          MergeLetterTable.Delete;
        except
          SystemSupport(002, MergeLetterTable,
                        'Error deleting letter template ' +
                        MergeLetterTable.FieldByName('LetterName').Text + '.',
                        UnitName, GlblErrorDlgBox);
        end;

        SetRangeOld(MergeLetterDefinitionsTable, ['LetterName'],
                    [MergeLetterTable.FieldByName('LetterName').Text],
                    [MergeLetterTable.FieldByName('LetterName').Text]);

        DeleteTableRange(MergeLetterDefinitionsTable);

      end;  {If (MessageDlg(...}

end;  {RemoveLetterButtonClick}

{========================================================================}
Procedure TGreivanceLettersForm.AddFieldButtonClick(Sender: TObject);

begin
(*  AddAvailableMergeFieldDialog := TAddAvailableMergeFieldDialog.Create(nil);

  If (AddAvailableMergeFieldDialog.ShowModal = idOK)
    then
      begin
        SetRangeOld(MergeLetterDefinitionsTable, ['LetterName'],
                    [MergeLetterTable.FieldByName('LetterName').Text],
                    [MergeLetterTable.FieldByName('LetterName').Text]);

        FillOneListBox(MergeFieldsUsedListBox,
                       MergeLetterDefinitionsTable,
                       'MergeFieldName',
                       '', 0, False, False,
                       NoProcessingType, '');

      end;  {If (AddAvailableMergeFieldDialog.ShowModal = idOK)}*)

end;  {AddFieldButtonClick}

{========================================================================}
Procedure TGreivanceLettersForm.RemoveFieldButtonClick(Sender: TObject);

begin
  If (MergeFieldsUsedListBox.ItemIndex > -1)
    then
      begin
        FindKeyOld(MergeLetterDefinitionsTable, ['LetterName', 'MergeFieldName'],
                   [MergeLetterTable.FieldByName('LetterName').Text,
                    MergeFieldsUsedListBox.Items[MergeFieldsUsedListBox.ItemIndex]]);


        SetRangeOld(MergeLetterDefinitionsTable, ['LetterName'],
                    [MergeLetterTable.FieldByName('LetterName').Text],
                    [MergeLetterTable.FieldByName('LetterName').Text]);

        FillOneListBox(MergeFieldsUsedListBox,
                       MergeLetterDefinitionsTable,
                       'MergeFieldName',
                       '', 0, False, False,
                       NoProcessingType, '');

      end;  {If (MergeFieldsUsedListBox.ItemIndex > -1)}

end;  {RemoveFieldButtonClick}

{======================================================================}
Procedure TGreivanceLettersForm.LetterOleContainerMouseDown(Sender: TObject;
                                                            Button: TMouseButton;
                                                            Shift: TShiftState;
                                                            X, Y: Integer);

{Bring up the document for editing.}

var
  FileName : OLEVariant;

begin
  FileName := MergeLetterTable.FieldByName('FileName').Text;

  try
    LetterOLEContainer.DestroyObject;
  except
  end;

  OpenWordDocument(WordApplication, WordDocument, FileName);

end;  {LetterOleContainerMouseDown}

{======================================================================}
Function GetVoteDescription(GrievanceResultsDetailsTable,
                            BoardMemberCodeTable : TTable;
                            GrievanceYear : String;
                            SwisSBLKey : String;
                            GrievanceNumber : Integer;
                            ResultNumber : Integer) : String;

var
  Done, FirstTimeThrough : Boolean;

begin
  SetRangeOld(GrievanceResultsDetailsTable,
              ['SwisSBLKey', 'TaxRollYr', 'GrievanceNumber', 'ResultNumber', 'BoardMember'],
              [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber),
               IntToStr(ResultNumber), ''],
              [SwisSBLKey, GrievanceYear, IntToStr(GrievanceNumber),
               IntToStr(ResultNumber), 'ZZZZZZZZZZ']);

  Done := False;
  FirstTimeThrough := True;
  Result := '';
  GrievanceResultsDetailsTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else GrievanceResultsDetailsTable.Next;

    If GrievanceResultsDetailsTable.EOF
      then Done := True;

    If ((not Done) and
        (not GrievanceResultsDetailsTable.FieldByName('Concur').AsBoolean))
      then
        begin
          If (Result = '')
            then Result := 'ALL CONCUR EXCEPT '
            else Result := Result + ', ';

          FindKeyOld(BoardMemberCodeTable, ['Code'],
                     [GrievanceResultsDetailsTable.FieldByName('BoardMember').Text]);

          Result := Result + Trim(BoardMemberCodeTable.FieldByName('Description').Text);

          with GrievanceResultsDetailsTable do
            begin
              If FieldByName('Against').AsBoolean
                then Result := Result + ' (Against)';

               If FieldByName('Abstain').AsBoolean
                then Result := Result + ' (Abstain)';

               If FieldByName('Absent').AsBoolean
                then Result := Result + ' (Absent)';

            end;  {with GrievanceResultsDetailsTable do}

        end;  {If ((not Done) and}

  until Done;

  If (Result = '')
    then Result := 'ALL CONCUR';

end;  {GetVoteDescription}

{======================================================================}
Procedure AddMergeFieldsToExtractFile(var LetterExtractFile : TextFile;
                                          MergeFieldsToPrint : TStringList;
                                          LetterType : Char;  {(G)rievance, (R)egular}
                                          GrievanceLetterType : Integer;  {ltResults, ltOther}
                                          SwisSBLKey : String;
                                          GrievanceNumber : Integer;
                                          ResultNumber : Integer;
                                          GrievanceTable,
                                          GrievanceLookupTable,
                                          GrievanceResultsTable,
                                          GrievanceResultsDetailsTable,
                                          GrievanceDispositionCodeTable,
                                          tbGrievanceExemptionsAsked,
                                          BoardMemberCodeTable,
                                          MergeFieldsAvailableTable,
                                          ParcelTable,
                                          tbExemptionCodes,
                                          tbGrievanceDenialReasons : TTable;
                                          GrievanceResultsDataSource : TDataSource;
                                          TempRichEdit : TDBRichEdit;
                                          ExcludeDuplicates,
                                          PrintOnlyLettersWithDifferentPetitionerAndRepresentatives,
                                          SendToHomeowner : Boolean;
                                          SendToRepresentatives : Boolean;
                                          LetterDate : TDateTime);

var
  Handled, _Found, Approved,
  UsePetitionerName, UseRepresentativeName, bPetitionerAskedForExemption : Boolean;
  I, GrievanceProcessingType, ComplaintCategory : Integer;
  AssessedValue, TempLandValue, ExemptionAmount : LongInt;
  FullMarketValue, TempAssessedValue : Comp;
  GrievanceYear, EXAmountToDisplay,
  FieldValue, MergeFieldName, EXGranted, sExemptionCode : String;
  NAddrArray, OwnerAddrArray, AttorneyAddrArray, PetitionerAddrArray : NameAddrArray;
  ExemptArray : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  AssessmentTable, ExemptionTable,
  ExemptionCodeTable, SwisCodeTable : TTable;

begin
  Approved := False;
  ComplaintCategory := ccOther;
  GrievanceYear := GrievanceResultsTable.FieldByName('TaxRollYr').Text;
  GrievanceProcessingType := GetProcessingTypeForTaxRollYear(GrievanceYear);

  If (GrievanceLetterType = ltResults)
    then
      begin
        If (Trim(GrievanceTable.FieldByName('PetitReason').Text) = 'MISCLASS')
          then ComplaintCategory := ccClassified;

        If (Pos('EX', GrievanceResultsTable.FieldByName('ComplaintReason').Text) > 0)
          then ComplaintCategory := ccExemption;

        If (Pos('AV', GrievanceResultsTable.FieldByName('ComplaintReason').Text) > 0)
          then ComplaintCategory := ccAssessment;

        FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                   [GrievanceResultsTable.FieldByName('Disposition').Text]);

        If (Deblank(GrievanceResultsTable.FieldByName('Disposition').Text) = '')
          then Approved := False
          else Approved := (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger =
                            gtApproved);

      end;  {If (GrievanceLetterType = ltResults)}

  with GrievanceTable do
    begin
      UsePetitionerName := False;
      UseRepresentativeName := False;

      If (PrintOnlyLettersWithDifferentPetitionerAndRepresentatives or
          (SendToRepresentatives and
           _Compare(FieldByName('LawyerCode').Text, coNotBlank)))
        then UseRepresentativeName := True
        else UsePetitionerName := True;

      FillInNameAddrArray(FieldByName('PetitName1').Text,
                                 FieldByName('PetitName2').Text,
                                 FieldByName('PetitAddress1').Text,
                                 FieldByName('PetitAddress2').Text,
                                 FieldByName('PetitStreet').Text,
                                 FieldByName('PetitCity').Text,
                                 FieldByName('PetitState').Text,
                                 FieldByName('PetitZip').Text,
                                 FieldByName('PetitZipPlus4').Text,
                                 True, False, PetitionerAddrArray);

      FillInNameAddrArray(FieldByName('AttyName1').Text,
                          FieldByName('AttyName2').Text,
                          FieldByName('AttyAddress1').Text,
                          FieldByName('AttyAddress2').Text,
                          FieldByName('AttyStreet').Text,
                          FieldByName('AttyCity').Text,
                          FieldByName('AttyState').Text,
                          FieldByName('AttyZip').Text,
                          FieldByName('AttyZipPlus4').Text,
                          True, False, AttorneyAddrArray);

      FillInNameAddrArray(FieldByName('CurrentName1').Text,
                          FieldByName('CurrentName2').Text,
                          FieldByName('CurrentAddress1').Text,
                          FieldByName('CurrentAddress2').Text,
                          FieldByName('CurrentStreet').Text,
                          FieldByName('CurrentCity').Text,
                          FieldByName('CurrentState').Text,
                          FieldByName('CurrentZip').Text,
                          FieldByName('CurrentZipPlus4').Text,
                          True, False, OwnerAddrArray);

      If _Compare(AttorneyAddrArray[1], coBlank)
        then
          For I := 1 to 6 do
            AttorneyAddrArray[I] := PetitionerAddrArray[I];

      If UseRepresentativeName
        then FillInNameAddrArray(FieldByName('AttyName1').Text,
                                 FieldByName('AttyName2').Text,
                                 FieldByName('AttyAddress1').Text,
                                 FieldByName('AttyAddress2').Text,
                                 FieldByName('AttyStreet').Text,
                                 FieldByName('AttyCity').Text,
                                 FieldByName('AttyState').Text,
                                 FieldByName('AttyZip').Text,
                                 FieldByName('AttyZipPlus4').Text,
                                 True, False, NAddrArray);

        {FXX09132007-1(2.11.4.2): Don't use the petitioner name if it is pro se.}

      If (UsePetitionerName and
          _Compare(FieldByName('PetitName1').AsString, coNotBlank))
        then FillInNameAddrArray(FieldByName('PetitName1').Text,
                                 FieldByName('PetitName2').Text,
                                 FieldByName('PetitAddress1').Text,
                                 FieldByName('PetitAddress2').Text,
                                 FieldByName('PetitStreet').Text,
                                 FieldByName('PetitCity').Text,
                                 FieldByName('PetitState').Text,
                                 FieldByName('PetitZip').Text,
                                 FieldByName('PetitZipPlus4').Text,
                                 True, False, NAddrArray);

      If _Compare(NAddrArray[1], coBlank)
        then
          For I := 1 to 6 do
            NAddrArray[I] := OwnerAddrArray[I];

    end;  {with GrievanceTable do}

  For I := 0 to (MergeFieldsToPrint.Count - 1) do
    begin
      FindKeyOld(MergeFieldsAvailableTable, ['MergeFieldName'],
                 [MergeFieldsToPrint[I]]);

      with MergeFieldsAvailableTable do
        begin
          MergeFieldName := FieldByName('MergeFieldName').Text;

          If (FieldByName('TableName').Text = 'Special')
            then
              begin
                If (MergeFieldName = 'ThisYear')
                  then FieldValue := GlblThisYear;

                If (MergeFieldName = 'NextYear')
                  then FieldValue := GlblNextYear;

                If (MergeFieldName = 'SwisCode')
                  then FieldValue := Copy(SwisSBLKey, 1, 6);

                If (MergeFieldName = 'ParcelID')
                  then
                    begin
                      FieldValue := ConvertSwisSBLToDashDot(SwisSBLKey);

                      If ExcludeDuplicates
                        then
                          begin
                            SetRangeOld(GrievanceLookupTable, ['TaxRollYr', 'GrievanceNumber'],
                                        [GrievanceYear, IntToStr(GrievanceNumber)],
                                        [GrievanceYear, IntToStr(GrievanceNumber)]);

                            If (GrievanceLookupTable.RecordCount > 1)
                              then FieldValue := FieldValue + ' and others';

                          end;  {If ExcludeDuplicates}

                    end;  {If (MergeFieldName = 'ParcelID')}

                If (MergeFieldName = 'ParcelID_No_Swis')
                  then FieldValue := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                If (MergeFieldName = 'LegalAddress')
                  then FieldValue := GetLegalAddressFromTable(GrievanceTable);

                If (MergeFieldName = 'Name1')
                  then FieldValue := NAddrArray[1];

                If (MergeFieldName = 'Name2')
                  then FieldValue := NAddrArray[2];

                If (MergeFieldName = 'Address1')
                  then FieldValue := NAddrArray[3];

                If (MergeFieldName = 'Address2')
                  then FieldValue := NAddrArray[4];

                If (MergeFieldName = 'Address3')
                  then FieldValue := NAddrArray[5];

                If (MergeFieldName = 'Address4')
                  then FieldValue := NAddrArray[6];

                If _Compare(MergeFieldName, 'OwnerName1', coEqual)
                  then FieldValue := OwnerAddrArray[1];

                If _Compare(MergeFieldName, 'OwnerName2', coEqual)
                  then FieldValue := OwnerAddrArray[2];

                If _Compare(MergeFieldName, 'OwnerAddress1', coEqual)
                  then FieldValue := OwnerAddrArray[3];

                If _Compare(MergeFieldName, 'OwnerAddress2', coEqual)
                  then FieldValue := OwnerAddrArray[4];

                If _Compare(MergeFieldName, 'OwnerAddress3', coEqual)
                  then FieldValue := OwnerAddrArray[5];

                If _Compare(MergeFieldName, 'OwnerAddress4', coEqual)
                  then FieldValue := OwnerAddrArray[6];

                If _Compare(MergeFieldName, 'AttorneyName1', coEqual)
                  then FieldValue := AttorneyAddrArray[1];

                If _Compare(MergeFieldName, 'AttorneyName2', coEqual)
                  then FieldValue := AttorneyAddrArray[2];

                If _Compare(MergeFieldName, 'AttorneyAddress1', coEqual)
                  then FieldValue := AttorneyAddrArray[3];

                If _Compare(MergeFieldName, 'AttorneyAddress2', coEqual)
                  then FieldValue := AttorneyAddrArray[4];

                If _Compare(MergeFieldName, 'AttorneyAddress3', coEqual)
                  then FieldValue := AttorneyAddrArray[5];

                If _Compare(MergeFieldName, 'AttorneyAddress4', coEqual)
                  then FieldValue := AttorneyAddrArray[6];

                  {CHG08202002-1: Allow them to choose the letter date.}

                If (MergeFieldName = 'LetterDate')
                  then FieldValue := DateToStr(LetterDate);

                If ((MergeFieldName = 'RequestedExemption') and
                    _Compare(GrievanceResultsTable.FieldByName('ComplaintReason').AsString, 'Asking EX', coStartsWith))
                  then
                    begin
                      sExemptionCode := Copy(GrievanceResultsTable.FieldByName('ComplaintReason').AsString, 11, 5);
                      _Locate(tbExemptionCodes, [sExemptionCode], '', []);
                      FieldValue := sExemptionCode + ' (' + tbExemptionCodes.FieldByName('Description').AsString + ')';
                    end;

                If (MergeFieldName = 'ComplaintCategory')
                  then
                    begin
                      FieldValue := '';

                      case ComplaintCategory of
                        ccClassified : FieldValue := 'Classification';
                        ccExemption : FieldValue := 'Exemption';
                        ccAssessment : FieldValue := 'Assessed Valuation';
                        ccOther : FieldValue := 'Other';
                      end;

                    end;  {If (MergeFieldName = 'ComplaintCategory')}

                If (MergeFieldName = 'DenialReason_CodeTable')
                then
                begin
                  FieldValue := '';

                  If (_Compare(GrievanceResultsTable.FieldByName('Disposition').Text, 'DENIED', coEqual) and
                      _Locate(tbGrievanceDenialReasons, [GrievanceResultsTable.FieldByName('DenialReasonCode').Text], '', []))
                  then FieldValue := tbGrievanceDenialReasons.FieldByName('Reason').AsString;

                end;

                If (MergeFieldName = 'DenialReason')
                  then
                    If (Deblank(GrievanceResultsTable.FieldByName('DenialReasonCode').Text) = '')
                      then FieldValue := ''
                      else
                        begin
                          TempRichEdit.DataSource := GrievanceResultsDataSource;
                          TempRichEdit.DataField := 'DenialReason';
                          FieldValue := TempRichEdit.Text;

                        end;  {If (Deblank(GrievanceResultsTable.FieldByName('').Text) = '')}

                  {Scarsdale has a special result message for stips.
                   Otherwise, they use the standard language.}

                If (MergeFieldName = 'ScarsdaleResultsDescText')
                  then
                    begin
                      If (GrievanceResultsTable.FieldByName('TotalValue').AsInteger > 0)
                        then
                          begin
                            If _Compare(GrievanceResultsTable.FieldByName('Disposition').Text, 'STIP', coEqual)
                              then FieldValue := 'Final assessment shown above was agreed to by stipulation of settlement.'
                              else FieldValue := 'A partial reduction has been granted based on evidence submitted.';

                          end
                        else
                          begin
                            TempRichEdit.DataSource := GrievanceResultsDataSource;
                            TempRichEdit.DataField := 'DenialReason';
                            FieldValue := TempRichEdit.Text;

                          end;  {If (Deblank(GrievanceResultsTable.FieldByName('').Text) = '')}

                    end;  {If (MergeFieldName = 'ScarsdaleResultsDescText')}

                If (MergeFieldName = 'ResultsDescriptionText')
                  then
                    If (GrievanceResultsTable.FieldByName('TotalValue').AsInteger > 0)
                      then FieldValue := 'HAS BEEN REDUCED TO AN ASSESSED VALUE OF ' +
                                         FormatFloat(CurrencyDisplayNoDollarSign,
                                                     GrievanceResultsTable.FieldByName('TotalValue').AsFloat)
                      else FieldValue := 'HAS NOT BEEN REDUCED.';

                If (MergeFieldName = 'GrievanceResults')
                  then
                    If (GrievanceResultsTable.FieldByName('TotalValue').AsInteger > 0)
                      then FieldValue := 'Your assessment has been reduced to ' +
                                         FormatFloat(CurrencyDisplayNoDollarSign,
                                                     GrievanceResultsTable.FieldByName('TotalValue').AsFloat) + '.'
                      else
                        begin
                          TempRichEdit.DataSource := GrievanceResultsDataSource;
                          TempRichEdit.DataField := 'DenialReason';
                          FieldValue := TempRichEdit.Text;
                        end;

                If (MergeFieldName = 'ExemptionResults')
                  then
                    with GrievanceResultsTable do
                      begin
                        FieldValue := '';

                        If (Pos('EX', FieldByName('ComplaintReason').Text) > 0)
                          then
                            If (Deblank(FieldByName('EXGranted').Text) = '')
                              then FieldValue := 'Your request for an exemption was denied because you do not qualify for the exemption.'
                              else
                                begin
                                  EXAmountToDisplay := '';

                                  If (FieldByName('EXAmount').AsFloat > 0)
                                    then EXAmountToDisplay := FormatFloat(CurrencyDisplayNoDollarSign,
                                                                          FieldByName('EXAmount').AsFloat)
                                    else
                                      If (Roundoff(FieldByName('EXPercent').AsFloat, 0) > 0)
                                        then EXAmountToDisplay := FormatFloat(PercentDisplay,
                                                                              FieldByName('EXPercent').AsFloat);

                                  If (EXAmountToDisplay = '')
                                    then FieldValue := 'Your request for exemption ' +
                                                       FieldByName('EXGranted').Text +
                                                       ' has been granted.'
                                    else FieldValue := 'Your request for an exemption has been granted in the amount of: ' +
                                                       EXAmountToDisplay;

                                end;  {else of If (Deblank(FieldByName('EXGranted').Text) = '')}

                      end;  {with GrievanceResultsTable do}

                If (MergeFieldName = 'ExemptionResultsWithReason')
                  then
                    with GrievanceResultsTable do
                      begin
                        FieldValue := '';

                        If (Pos('EX', FieldByName('ComplaintReason').Text) > 0)
                          then
                            If (Deblank(FieldByName('EXGranted').Text) = '')
                              then
                                begin
                                  TempRichEdit.DataSource := GrievanceResultsDataSource;
                                  TempRichEdit.DataField := 'DenialReason';
                                  FieldValue := TempRichEdit.Text;
                                end
                              else
                                begin
                                  EXAmountToDisplay := '';

                                  If (FieldByName('EXAmount').AsFloat > 0)
                                    then EXAmountToDisplay := FormatFloat(CurrencyDisplayNoDollarSign,
                                                                          FieldByName('EXAmount').AsFloat)
                                    else
                                      If (Roundoff(FieldByName('EXPercent').AsFloat, 0) > 0)
                                        then EXAmountToDisplay := FormatFloat(PercentDisplay,
                                                                              FieldByName('EXPercent').AsFloat);

                                  If (EXAmountToDisplay = '')
                                    then FieldValue := 'Your request for exemption ' +
                                                       FieldByName('EXGranted').Text +
                                                       ' has been granted.'
                                    else FieldValue := 'Your request for an exemption has been granted in the amount of: ' +
                                                       EXAmountToDisplay;

                                end;  {else of If (Deblank(FieldByName('EXGranted').Text) = '')}

                      end;  {with GrievanceResultsTable do}

                If (MergeFieldName = 'VoteDescription')
                  then FieldValue := GetVoteDescription(GrievanceResultsDetailsTable,
                                                        BoardMemberCodeTable,
                                                        GrievanceYear,
                                                        SwisSBLKey,
                                                        GrievanceNumber,
                                                        ResultNumber);

                If ((MergeFieldName = 'TownTaxableValue') or
                    (MergeFieldName = 'CountyTaxableValue') or
                    (MergeFieldName = 'SchoolTaxableValue') or
                    (MergeFieldName = 'TownTaxable_ExOnly'))
                  then
                    begin
                      AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                                GrievanceProcessingType);

                      FindKeyOld(AssessmentTable,
                                 ['TaxRollYr', 'SwisSBLKey'],
                                 [GrievanceYear, SwisSBLKey]);

                      AssessedValue := AssessmentTable.FieldByName('TotalAssessedVal').AsInteger;

                      ExemptionTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                               GrievanceProcessingType);
                      ExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                                                   GrievanceProcessingType);

                      ExemptionCodes := TStringList.Create;
                      ExemptionHomesteadCodes := TStringList.Create;
                      ResidentialTypes := TStringList.Create;
                      CountyExemptionAmounts := TStringList.Create;
                      TownExemptionAmounts := TStringList.Create;
                      SchoolExemptionAmounts := TStringList.Create;
                      VillageExemptionAmounts := TStringList.Create;

                      ExemptArray := TotalExemptionsForParcel(GrievanceYear, SwisSBLKey,
                                                              ExemptionTable,
                                                              ExemptionCodeTable,
                                                              GrievanceTable.FieldByName('HomesteadCode').Text,
                                                              'A',
                                                              ExemptionCodes,
                                                              ExemptionHomesteadCodes,
                                                              ResidentialTypes,
                                                              CountyExemptionAmounts,
                                                              TownExemptionAmounts,
                                                              SchoolExemptionAmounts,
                                                              VillageExemptionAmounts,
                                                              BasicSTARAmount,
                                                              EnhancedSTARAmount);

                      ExemptionCodes.Free;
                      ExemptionHomesteadCodes.Free;
                      ResidentialTypes.Free;
                      CountyExemptionAmounts.Free;
                      TownExemptionAmounts.Free;
                      SchoolExemptionAmounts.Free;
                      VillageExemptionAmounts.Free;

                      If (MergeFieldName = 'TownTaxableValue')
                        then FieldValue := FormatFloat(CurrencyDisplayNoDollarSign,
                                                       (AssessedValue -
                                                        ExemptArray[EXTown]));

                      If (MergeFieldName = 'TownTaxable_ExOnly')
                      then
                        If (ComplaintCategory = ccExemption)
                        then FieldValue := FormatFloat(CurrencyDisplayNoDollarSign,
                                                       (AssessedValue -
                                                        ExemptArray[EXTown]))
                        else FieldValue := 'N/A';

                      If (MergeFieldName = 'CountyTaxableValue')
                        then FieldValue := FormatFloat(CurrencyDisplayNoDollarSign,
                                                       (AssessedValue -
                                                        ExemptArray[EXCounty]));

                      If (MergeFieldName = 'SchoolTaxableValue')
                        then FieldValue := FormatFloat(CurrencyDisplayNoDollarSign,
                                                       (AssessedValue -
                                                        ExemptArray[EXSchool]));

                    end;  {If ((MergeFieldName = 'TownTaxableValue') or ...}

                If (MergeFieldName = 'GrievanceNumNH')
                  then FieldValue := GetGrievanceNumberToDisplay(GrievanceTable);

                If (MergeFieldName = 'NCReducedCheck')
                  then
                    begin
                      FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                                 [GrievanceResultsTable.FieldByName('Disposition').Text]);

                      If (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtApproved)
                        then FieldValue := '_X_'
                        else FieldValue := '___';

                    end;  {If (MergeFieldName = 'NCReducedCheck')}

                If (MergeFieldName = 'NCNotReducedCheck')
                  then
                    begin
                      FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                                 [GrievanceResultsTable.FieldByName('Disposition').Text]);

                      If (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtDenied)
                        then FieldValue := '_X_'
                        else FieldValue := '___';

                    end;  {If (MergeFieldName = 'NCReducedCheck')}

                If (MergeFieldName = 'NCNotReducedCheckBlank')
                  then
                    begin
                      FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                                 [GrievanceResultsTable.FieldByName('Disposition').Text]);

                      If (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtDenied)
                        then FieldValue := '_X_'
                        else FieldValue := '';

                    end;  {If (MergeFieldName = 'NCReducedCheck')}

                If (MergeFieldName = 'DeniedReason1')
                  then
                    begin
                      FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                                 [GrievanceResultsTable.FieldByName('Disposition').Text]);

                      If ((GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtDenied) and
                          (GrievanceResultsTable.FieldByName('DenialReasonCode').Text = '1'))
                        then FieldValue := '_X_'
                        else FieldValue := '___';

                    end;  {If (MergeFieldName = 'NCReducedCheck')}

                If (MergeFieldName = 'NCDismissal1')
                  then
                    If (GrievanceResultsTable.FieldByName('DenialReasonCode').Text = '1')
                        then FieldValue := '_X_'
                        else FieldValue := '___';

                If (MergeFieldName = 'NCDismissal2')
                  then
                    If (GrievanceResultsTable.FieldByName('DenialReasonCode').Text = '2')
                    then FieldValue := '_X_'
                    else FieldValue := '___';

                If (MergeFieldName = 'NCDismissal3')
                  then
                    If (GrievanceResultsTable.FieldByName('DenialReasonCode').Text = '3')
                        then FieldValue := '_X_'
                        else FieldValue := '___';

                If (MergeFieldName = 'NCDismissal4')
                  then
                    If (GrievanceResultsTable.FieldByName('DenialReasonCode').Text = '4')
                        then FieldValue := '_X_'
                        else FieldValue := '___';

                If (_Compare(ComplaintCategory, ccExemption, coNotEqual) and
                    ((MergeFieldName = 'MVRA') or
                     (MergeFieldName = 'MVA1')))
                  then
                    begin
                      FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                                 [GrievanceResultsTable.FieldByName('Disposition').Text]);

                      If (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtDenied)
                        then FieldValue := 'o'
                        else FieldValue := 'x';

                    end;  {If (MergeFieldName = 'MVRA')}

                If (_Compare(MergeFieldName, 'MVA11', coEqual) or
                    _Compare(MergeFieldName, 'MVA12', coEqual))
                  then
                    begin
                      FieldValue := 'o';

                      FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                                 [GrievanceResultsTable.FieldByName('Disposition').Text]);

                      If (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtApproved)
                        then
                          begin
                            If (_Compare(MergeFieldName, 'MVA11', coEqual) and
                                _Compare(GrievanceResultsTable.FieldByName('Disposition').Text, 'COURT', coEqual))
                              then FieldValue := 'x';
                              
                            If (_Compare(MergeFieldName, 'MVA12', coEqual) and
                                _Compare(GrievanceResultsTable.FieldByName('Disposition').Text, '3 YEAR', coEqual))
                              then FieldValue := 'x';

                          end;  {If (GrievanceDispositionCodeTable...}

                    end;  {If (MergeFieldName = 'MVRA')}

                If ((MergeFieldName = 'MVRB') or
                    (MergeFieldName = 'MVA2'))
                  then
                    begin
                      FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                                 [GrievanceResultsTable.FieldByName('Disposition').Text]);

                      If (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtDenied)
                        then FieldValue := 'x'
                        else FieldValue := 'o';

                    end;  {If (MergeFieldName = 'MVRB')}

                If (MergeFieldName = 'MVE1')
                  then
                    If (ComplaintCategory = ccExemption)
                      then
                        begin
                          FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                                     [GrievanceResultsTable.FieldByName('Disposition').Text]);

                          If (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtApproved)
                            then FieldValue := 'x'
                            else FieldValue := 'o';

                        end
                      else FieldValue := 'o';

                If (MergeFieldName = 'MVE2')
                  then
                    If (ComplaintCategory = ccExemption)
                      then
                        begin
                          FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                                     [GrievanceResultsTable.FieldByName('Disposition').Text]);

                          If (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtApproved)
                            then FieldValue := 'o'
                            else FieldValue := 'x';

                        end
                      else FieldValue := 'o';

                If (MergeFieldName = 'MVCAV')
                  then
                    If (ComplaintCategory = ccAssessment)
                      then FieldValue := 'x'
                      else FieldValue := 'o';

                If (MergeFieldName = 'MVCEX')
                  then
                    If (ComplaintCategory = ccExemption)
                      then FieldValue := 'x'
                      else FieldValue := 'o';

                If (MergeFieldName = 'MVCCL')
                  then
                    If (ComplaintCategory = ccClassified)
                      then FieldValue := 'x'
                      else FieldValue := 'o';

                If (MergeFieldName = 'MVCOT')
                  then
                    If (ComplaintCategory = ccOther)
                      then FieldValue := 'x'
                      else FieldValue := 'o';

                  {CHG06192006-1(2.9.7.7): Add a dismissal box to letter.}

                If _Compare(MergeFieldName, 'DSMBX', coEqual)
                  then
                    begin
                      FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                                 [GrievanceResultsTable.FieldByName('Disposition').Text]);

                      If (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtDismissed)
                        then FieldValue := 'x'
                        else FieldValue := 'o';

                    end;  {If _Compare(MergeFieldName, 'DSMBX', coEqual)}

                If ((MergeFieldName = 'MVA21') or
                    (MergeFieldName = 'MVA22') or
                    (MergeFieldName = 'MVA23') or
                    (MergeFieldName = 'MVA24') or
                    (MergeFieldName = 'MVA25'))
                  then
                    If (((MergeFieldName = 'MVA21') and
                         (GrievanceResultsTable.FieldByName('DenialReasonCode').Text = '1')) or
                        ((MergeFieldName = 'MVA22') and
                         (GrievanceResultsTable.FieldByName('DenialReasonCode').Text = '2')) or
                        ((MergeFieldName = 'MVA23') and
                         (GrievanceResultsTable.FieldByName('DenialReasonCode').Text = '3')) or
                        ((MergeFieldName = 'MVA24') and
                         (GrievanceResultsTable.FieldByName('DenialReasonCode').Text = '4')) or
                        ((MergeFieldName = 'MVA25') and
                         (GrievanceResultsTable.FieldByName('DenialReasonCode').Text = '5')))
                      then FieldValue := 'x'
                      else FieldValue := 'o';

                If ((MergeFieldName = 'HA21') or
                    (MergeFieldName = 'HA22') or
                    (MergeFieldName = 'HA23') or
                    (MergeFieldName = 'HA24') or
                    (MergeFieldName = 'HA25'))
                  then
                    If ((MergeFieldName = 'HA21') and
                        (GrievanceResultsTable.FieldByName('DenialReasonCode').Text = '4'))
                      then FieldValue := 'x'
                      else FieldValue := 'o';

                If (MergeFieldName = 'GrantedEXAmount')
                  then
                    begin
                      EXGranted := GrievanceResultsTable.FieldByName('EXGranted').Text;

                      If (Deblank(EXGranted) = '')
                        then FieldValue := ''
                        else
                          begin
                            ExemptionAmount := GrievanceResultsTable.FieldByName('EXAmount').AsInteger;

                              {Sometimes they don't fill in the exemption amount
                               since PAS automatically calculates it.}

                            If (ExemptionAmount = 0)
                              then
                                begin
                                  ExemptionTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                                                           GrievanceProcessingType);

                                  _Found := FindKeyOld(ExemptionTable,
                                                       ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
                                                       [GrievanceYear, SwisSBLKey, EXGranted]);

                                  If _Found
                                    then ExemptionAmount := ExemptionTable.FieldByName('Amount').AsInteger;

                                end;  {If (ExemptionAmount = 0)}

                            FieldValue := FormatFloat(NoDecimalDisplay_BlankZero,
                                                      ExemptionAmount);

                          end;  {else of If (Deblank(EXGranted) = '')}

                    end;  {If (MergeFieldName = 'GrantedEXAmount')}

                If (MergeFieldName = 'FullMarketValueCalculated')
                  then
                    begin
                        {If approved, calc based on the new value.}
                        {Only display it if the complaint was approved.}

                      If Approved
                        then
                          begin
                            TempAssessedValue := GrievanceResultsTable.FieldByName('TotalValue').AsFloat;

                            SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                                                    GrievanceProcessingType);

                            FullMarketValue := ComputeFullValue(TempAssessedValue, SwisCodeTable,
                                                                GrievanceTable.FieldByName('PropertyClassCode').Text,
                                                                GrievanceTable.FieldByName('OwnershipCode').Text,
                                                                GlblUseRAR);

                            FieldValue := FormatFloat(CurrencyNormalDisplay,
                                                      FullMarketValue);

                          end  {If (MergeFieldName = 'FullMarketValueCalculated')}
                        else FieldValue := '';

                    end;  {If (MergeFieldName = 'FullMarketValueCalculated')}

                If (MergeFieldName = 'DismissedCheck')
                  then
                    begin
                      FindKeyOld(GrievanceDispositionCodeTable, ['Code'],
                                 [GrievanceResultsTable.FieldByName('Disposition').Text]);

                      If (GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger = gtDismissed)
                        then FieldValue := '_X_'
                        else FieldValue := '___';

                    end;  {If (MergeFieldName = 'DismissedCheck')}

                If _Compare(MergeFieldName, 'Attention', coEqual)
                  then FieldValue := GrievanceTable.FieldByName('LawyerCode').Text;

                If _Compare(MergeFieldName, 'YorktownApproval', coEqual)
                  then
                    If _Compare(GrievanceResultsTable.FieldByName('EXGranted').Text, coBlank)
                      then FieldValue := ' determined the ' + GrievanceTable.FieldByName('TaxRollYr').Text +
                                         ' tentative assessment to be excessive and reduces the assessment to $' +
                                         FormatFloat(CurrencyDisplayNoDollarSign,
                                                     GrievanceResultsTable.FieldByName('TotalValue').AsFloat)
                      else FieldValue := ' granted your exemption';

                If _Compare(MergeFieldName, 'Petitioner', coEqual)
                  then
                    begin
                      FieldValue := GrievanceTable.FieldByName('PetitName1').Text;

                      If _Compare(FieldValue, coBlank)
                        then FieldValue := GrievanceTable.FieldByName('CurrentName1').Text;;

                    end;  {If _Compare(MergeFieldName, 'Petitioner', coEqual)}

                  {Greenburgh}

                If _Compare(MergeFieldName, ['ckRed', 'ckExApp', 'ckRedCB'], coEqual)
                then
                begin
                  FieldValue := '___';

                  If _Compare(MergeFieldName, 'ckRedCB', coEqual)
                  then FieldValue := 'o';

                  _Locate(GrievanceDispositionCodeTable, [GrievanceResultsTable.FieldByName('Disposition').AsString], '', []);

                  If _Compare(GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger, gtApproved, coEqual)
                  then
                  begin
                    If (_Compare(MergeFieldName, 'ckExApp', coEqual) and
                        _Compare(GrievanceResultsTable.FieldByName('ExGranted').AsString, coNotBlank))
                    then FieldValue := '_X_';

                    If (_Compare(MergeFieldName, 'ckRed', coEqual) and
                        _Compare(GrievanceResultsTable.FieldByName('TotalValue').AsInteger, 0, coGreaterThan))
                    then FieldValue := '_X_';

                    If _Compare(MergeFieldName, 'ckRedCB', coEqual)
                    then
                      If _Compare(GrievanceResultsTable.FieldByName('TotalValue').AsInteger, 0, coGreaterThan)
                      then FieldValue := 'x';

                  end;  {If (GrievanceDispositionCodeTable...}

                end;  {If (_Compare(MergeFieldName, 'ckRed', coEqual) or ...}

                If _Compare(MergeFieldName, ['ckDen', 'ckExDen', 'ckDenCB'], coEqual)
                then
                begin
                  If _Compare(MergeFieldName, 'ckDenCB', coEqual)
                  then FieldValue := 'o'
                  else FieldValue := '___';

                  _Locate(GrievanceDispositionCodeTable, [GrievanceResultsTable.FieldByName('Disposition').AsString], '', []);

                  If _Compare(GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger, gtDenied, coEqual)
                  then
                  begin
                    with GrievanceTable do
                      _SetRange(tbGrievanceExemptionsAsked,
                                [FieldByName('TaxRollYr').AsString,
                                 FieldByName('SwisSBLKey').AsString,
                                 FieldByName('GrievanceNumber').AsInteger,
                                 '00000'],
                                [FieldByName('TaxRollYr').AsString,
                                 FieldByName('SwisSBLKey').AsString,
                                 FieldByName('GrievanceNumber').AsInteger,
                                 '99999'], '', []);

                    bPetitionerAskedForExemption := _Compare(tbGrievanceExemptionsAsked.RecordCount, 0, coGreaterThan);

                    If bPetitionerAskedForExemption
                    then
                    begin
                      If _Compare(MergeFieldName, 'ckExDen', coEqual)
                      then FieldValue := '_X_'
                    end
                    else
                    begin
                      If _Compare(MergeFieldName, 'ckDen', coEqual)
                      then FieldValue := '_X_';

                      If _Compare(MergeFieldName, 'ckDenCB', coEqual)
                      then FieldValue := 'x';

                    end;

                  end;  {If (GrievanceDispositionCodeTable}

                end;  {If (_Compare(MergeFieldName, 'ckDen', coEqual) or ...}

                If _Compare(MergeFieldName, 'ckDissC', coEqual)
                then
                begin
                  FieldValue := '___';
                  _Locate(GrievanceDispositionCodeTable, [GrievanceResultsTable.FieldByName('Disposition').AsString], '', []);

                  If _Compare(GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger, gtWithdrawn, coEqual)
                  then FieldValue := '_X_';

                end;  {If _Compare(MergeFieldName, 'ckDissC', coEqual)}

                If _Compare(MergeFieldName, ['ckDiss', 'ckDissA', 'ckDissB'], coEqual)
                then
                begin
                  FieldValue := '___';
                  _Locate(GrievanceDispositionCodeTable, [GrievanceResultsTable.FieldByName('Disposition').AsString], '', []);

                  If _Compare(GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger, gtDismissed, coEqual)
                  then
                  begin
                    If _Compare(MergeFieldName, 'ckDiss', coEqual)
                    then FieldValue := '_X_';

(*                    If (_Compare(MergeFieldName, 'ckDissA', coEqual) and
                        _Compare(GrievanceResultsTable.FieldByName('DenialReasonCode').AsString, '1', coEqual))
                    then FieldValue := '_X_';

                    If (_Compare(MergeFieldName, 'ckDissB', coEqual) and
                        _Compare(GrievanceResultsTable.FieldByName('DenialReasonCode').AsString, 'DISMISSED', coEqual))
                    then FieldValue := '_X_';   *)


                    If (_Compare(MergeFieldName, 'ckDissA', coEqual) and
                        _Compare(GrievanceResultsTable.FieldByName('Disposition').AsString, 'DISMISS_A', coEqual))
                    then FieldValue := '_X_';

                    If (_Compare(MergeFieldName, 'ckDissB', coEqual) and
                        _Compare(GrievanceResultsTable.FieldByName('Disposition').AsString, 'DISMISS_B', coEqual))
                    then FieldValue := '_X_';

                  end;  {If _Compare(GrievanceDispositionCodeTable.FieldByName('ResultType').AsInteger, gtDismissed, coEqual)}

                end;  {If (MergeFieldName = 'MVRB')}

              end
            else
              begin
                Handled := False;

                If (MergeFieldName = 'TentativeAV')
                  then
                    begin
                      Handled := True;
                      FieldValue := FormatFloat(CurrencyNormalDisplay,
                                                GrievanceTable.FieldByName('CurrentTotalValue').AsFloat);
                    end;

                If _Compare(MergeFieldName, ['TentativeLandValue', 'TentativeLandAV'], coEqual)
                  then
                    begin
                      Handled := True;
                      FieldValue := FormatFloat(CurrencyNormalDisplay,
                                                GrievanceTable.FieldByName('CurrentLandValue').AsFloat);
                    end;

                If (MergeFieldName = 'GrievanceNumber')
                  then
                    begin
                      Handled := True;
                      FieldValue := GrievanceTable.FieldByName('GrievanceNumber').Text;
                    end;

                If (MergeFieldName = 'GrantedLandValue')
                  then
                    If Approved
                      then
                        begin
                          Handled := True;

                            {Most times the land value is not part of the whole
                             process, so if we see that the granted land is zero,
                             pull it from the assessment table.}

                          with GrievanceResultsTable do
                            If (Roundoff(FieldByName('LandValue').AsFloat, 2) > 0)
                              then TempLandValue := FieldByName('LandValue').AsInteger
                              else
                                begin
                                  AssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                                            GrievanceProcessingType);

                                  FindKeyOld(AssessmentTable,
                                             ['TaxRollYr', 'SwisSBLKey'],
                                             [GrievanceYear, SwisSBLKey]);

                                  TempLandValue := AssessmentTable.FieldByName('LandAssessedVal').AsInteger;

                                end;  {If (Roundoff(FieldByName('LandValue').AsFloat, 2) > 0)}

                          If _Compare(ComplaintCategory, ccExemption, coEqual)
                          then FieldValue := ''
                          else FieldValue := FormatFloat(CurrencyNormalDisplay_BlankZero, TempLandValue);

                        end  {If (MergeFieldName = 'GrantedLandValue')}
                      else
                        begin
                          Handled := True;
                          FieldValue := '';
                        end;

                If (MergeFieldName = 'GrantedTotalValue')
                  then
                    begin
                      Handled := True;

                      If Approved
                        then FieldValue := FormatFloat(CurrencyNormalDisplay_BlankZero,
                                                        GrievanceResultsTable.FieldByName('TotalValue').AsFloat)
                        else FieldValue := 'N/A';

                    end;  {If (MergeFieldName = 'GrantedTotalValue')}

                If (MergeFieldName = 'FinalValue')
                  then
                    begin
                      Handled := True;

                      If Approved
                        then FieldValue := FormatFloat(CurrencyNormalDisplay_BlankZero,
                                                        GrievanceResultsTable.FieldByName('TotalValue').AsFloat)
                        else FieldValue := FormatFloat(CurrencyNormalDisplay,
                                                       GrievanceTable.FieldByName('CurrentTotalValue').AsFloat);

                    end;  {If (MergeFieldName = 'GrantedTotalValue')}

                If (MergeFieldName = 'ScarsdaleTotalValue')
                  then
                    begin
                      Handled := True;

                      If Approved
                        then FieldValue := FormatFloat(CurrencyNormalDisplay_BlankZero,
                                                        GrievanceResultsTable.FieldByName('TotalValue').AsFloat)
                        else FieldValue := FormatFloat(CurrencyNormalDisplay,
                                                       GrievanceTable.FieldByName('CurrentTotalValue').AsFloat);

                    end;  {If (MergeFieldName = 'GrantedTotalValue')}

                If _Compare(MergeFieldName, 'AccountNumber', coEqual)
                  then
                    begin
                      Handled := True;
                      FieldValue := '';

                      If _Locate(ParcelTable, [GrievanceTable.FieldByName('TaxRollYr').Text, SwisSBLKey], '', [loParseSwisSBLKey])
                        then FieldValue := ParcelTable.FieldByName('AccountNo').Text;

                    end;  {If _Compare(MergeFieldName, 'AccountNumber', coEqual)}

                If not Handled
                  then FieldValue := GrievanceTable.FieldByName(MergeFieldsAvailableTable.FieldByName('FieldName').Text).Text;

              end;  {else of If (FieldByName('TableName').Text = Special)}

        end;  {with MergeFieldsAvailableTable do}

      If (I > 0)
        then Write(LetterExtractFile, ',');

      Write(LetterExtractFile, '"', FieldValue, '"');

    end;  {For I := 0 to (MergeFieldsToAdd.Count - 1) do}

  Writeln(LetterExtractFile);

end;  {AddMergeFieldsToExtractFile}

{======================================================================}
Function TGreivanceLettersForm.PrintThisLetter(GrievanceTable : TTable;
                                               GrievanceResultsTable : TTable;
                                               GrievanceNumber : Integer;
                                               LastGrievanceNumber : Integer;
                                               SwisSBLKey : String;
                                               LastSwisSBLKey : String;
                                               GrievanceNumbersPrinted : TStringList;
                                               LoadFromParcelList : Boolean;
                                               GrievanceFound : Boolean) : Boolean;

var
  ResultNumber : Integer;

begin
  Result := True;

  If (_Compare(LetterType, ltResults, coEqual) and
      (SelectedGrievanceResultsTypeList.IndexOf(GrievanceResultsTable.FieldByName('Disposition').Text) = -1))
    then Result := False;

  If Result
  then
    If LoadFromParcelList
      then Result := GrievanceFound
      else
        begin
          If (CommercialParcelsOnly and
              (GrievanceTable.FieldByName('PropertyClassCode').Text[1] = '2'))
            then Result := False;

            {FXX07252002-1: The comparison should be based on the ResultType in
                            the disposition code table, not the results table.}
            {FXX06222007-1(2.11.1.38): Only compare against the disposition for results letters.}

          If (Result and
              (not ReprintLetters))
            then
              begin
                If (LetterType = ltResults)
                  then ResultNumber := GrievanceResultsTable.FieldByName('ResultNumber').AsInteger
                  else ResultNumber := 0;

                Result := not FindKeyOld(GrievanceLetterSentTable,
                                         ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber',
                                          'ResultNumber', 'LetterName'],
                                         [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber),
                                          IntToStr(ResultNumber), LetterName]);

              end;  {If (Result and ...}

        (*  If (Result and
              ExcludeDuplicates and
              (LastGrievanceNumber = GrievanceNumber) and
              (SwisSBLKey <> LastSwisSBLKey))
            then Result := False;*)

          If (Result and
              ExcludeDuplicates and
              (GrievanceNumbersPrinted.IndexOf(IntToStr(GrievanceNumber)) > - 1) and
              (SwisSBLKey <> LastSwisSBLKey))
            then Result := False;

            {CHG06242004-1(2.07l5): Option to print letters only for reps.}

          If (Result and
              PrintOnlyLettersWithRepresentatives and
              ((Deblank(GrievanceTable.FieldByName('LawyerCode').Text) = '') or
               (Deblank(GrievanceTable.FieldByName('AttyName1').Text) = '')))
            then Result := False;

            {CHG06302005-1(2.8.5.3): Option to print letters for grievances where the representative
                                     is different than the petitioner.}

          with GrievanceTable do
            If PrintOnlyLettersWithDifferentPetitionerAndRepresentatives
              then
                begin
                  Result := True;

                  If (_Compare(FieldByName('AttyName1').Text, coBlank) or
                      _Compare(FieldByName('AttyName1').Text, FieldByName('PetitName1').Text, coEqual))
                    then Result := False;

                end;  {If PrintOnlyLettersWithDifferentPetitionerAndRepresentatives}

        end;  {else of If LoadFromParcelList}

end;  {PrintThisLetter}

{======================================================================}
Procedure TGreivanceLettersForm.PrintLetters;

var
  _Found, Done, FirstTimeThrough, GrievanceFound, bSendToHomeowner : Boolean;
  LetterExtractFile : TextFile;
  FileExtension, NewFileName,
  LetterExtractFileName, SwisSBLKey, LastSwisSBLKey : String;
  I, Index, LastGrievanceNumber,
  ExtensionPos, GrievanceNumber, ResultNumber : Integer;

begin
  Done := False;
  FirstTimeThrough := True;
  LastGrievanceNumber := 0;
  LastSwisSBLKey := '';
  GrievanceNumber := 0;
  GrievanceFound := False;
  Index := 0;
  GrievanceNumbersPrinted := TStringList.Create;
  bSendToHomeowner := cbSendToHomeowner.Checked;

  LetterExtractFileName := GetPrintFileName(Caption, True);

  try
    AssignFile(LetterExtractFile, LetterExtractFileName);
    Rewrite(LetterExtractFile);
  except
    SystemSupport(001, GrievanceTable, 'Error creating linked text file.',
                  UnitName, GlblErrorDlgBox);
  end;

    {Create the header record.}

  For I := 0 to (MergeFieldsToPrint.Count - 1) do
    begin
      If (I > 0)
        then Write(LetterExtractFile, ',');

      Write(LetterExtractFile, '"', MergeFieldsToPrint[I], '"');

    end;  {For I := 0 to (MergeFieldsToPrint.Count - 1) do}

  Writeln(LetterExtractFile);

    {Write a sample letter in order to preserve formatting during merge.}

  For I := 0 to (MergeFieldsToPrint.Count - 1) do
    begin
      If (I > 0)
        then Write(LetterExtractFile, ',');

      Write(LetterExtractFile, '"Sample"');

    end;  {For I := 0 to (MergeFieldsToPrint.Count - 1) do}

  Writeln(LetterExtractFile);

  If LoadFromParcelList
    then
      begin
        Index := 1;
        ParcelListDialog.GetParcel(ParcelTable, Index);
        ProgressDialog.Start(ParcelListDialog.NumItems, True, True);
        GrievanceTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
      end
    else
      case LetterType of
        ltResults :
          begin
            GrievanceResultsTable.First;
            ProgressDialog.Start(GetRecordCount(GrievanceResultsTable), True, True);
          end;

        ltOther :
          begin
            GrievanceTable.First;
            ProgressDialog.Start(GetRecordCount(GrievanceTable), True, True);
          end;

      end;  {case LetterType of}

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If LoadFromParcelList
          then
            begin
              Index := Index + 1;
              ParcelListDialog.GetParcelSwisSBLKey(Index);
            end
          else
            case LetterType of
              ltResults : GrievanceResultsTable.Next;
              ltOther : GrievanceTable.Next;
            end;

    If LoadFromParcelList
      then
        begin
          Done := (Index > ParcelListDialog.NumItems);
          SwisSBLKey := ParcelListDialog.GetParcelSwisSBLKey(Index);

          GrievanceFound := _Locate(GrievanceTable, [GrievanceYear, SwisSBLKey], '', []);

          If GrievanceFound
            then GrievanceNumber := GrievanceTable.FieldByName('GrievanceNumber').AsInteger;
          ResultNumber := 1;

          If (LetterType = ltResults)
          then
          begin
            with GrievanceTable do
              FindKeyOld(GrievanceResultsTable,
                         ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber'],
                         [FieldByName('TaxRollYr').Text,
                          FieldByName('SwisSBLKey').Text,
                          FieldByName('GrievanceNumber').Text, '1']);

            ResultNumber := GrievanceResultsTable.FieldByName('ResultNumber').AsInteger;
          end;


        end
      else
        begin
          case LetterType of
            ltResults : Done := GrievanceResultsTable.EOF;
            ltOther : Done := GrievanceTable.EOF;
          end;

          If (LetterType = ltResults)
            then
              with GrievanceResultsTable do
                FindKeyOld(GrievanceTable,
                           ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber'],
                           [FieldByName('TaxRollYr').Text,
                            FieldByName('SwisSBLKey').Text,
                            FieldByName('GrievanceNumber').Text]);

          If (LetterType = ltResults)
            then
              begin
                GrievanceNumber := GrievanceResultsTable.FieldByName('GrievanceNumber').AsInteger;
                ResultNumber := GrievanceResultsTable.FieldByName('ResultNumber').AsInteger;
                SwisSBLKey := GrievanceResultsTable.FieldByName('SwisSBLKey').Text;
              end
            else
              begin
                GrievanceNumber := GrievanceTable.FieldByName('GrievanceNumber').AsInteger;
                ResultNumber := 0;
                SwisSBLKey := GrievanceTable.FieldByName('SwisSBLKey').Text;
              end;  {else of If (LetterType = ltResults)}

        end;  {else of If LoadFromParcelList}

    ProgressDialog.Update(Self, 'Grievance = ' + IntToStr(GrievanceNumber));
    Application.ProcessMessages;

    If ((not Done) and
        PrintThisLetter(GrievanceTable, GrievanceResultsTable,
                        GrievanceNumber, LastGrievanceNumber,
                        SwisSBLKey, LastSwisSBLKey,
                        GrievanceNumbersPrinted,
                        LoadFromParcelList,
                        GrievanceFound))
      then
        begin
          GrievanceNumbersPrinted.Add(IntToStr(GrievanceNumber));
          LettersPrinted.Add(SwisSBLKey);

          AddMergeFieldsToExtractFile(LetterExtractFile,
                                      MergeFieldsToPrint, 'G',
                                      LetterType,
                                      SwisSBLKey,
                                      GrievanceNumber,
                                      ResultNumber,
                                      GrievanceTable,
                                      GrievanceLookupTable,
                                      GrievanceResultsTable,
                                      GrievanceResultsDetailsTable,
                                      GrievanceDispositionCodeTable,
                                      tbGrievanceExemptionsAsked,
                                      BoardMemberCodeTable,
                                      MergeFieldsAvailableTable,
                                      ParcelTable,
                                      tbExemptionCodes,
                                      tbGrievanceDenialReasons,
                                      GrievanceResultsDataSource,
                                      TempRichEdit, ExcludeDuplicates,
                                      PrintOnlyLettersWithDifferentPetitionerAndRepresentatives,
                                      bSendToHomeowner,
                                      SendToRepresentatives,
                                      LetterDate);

            {Put in a record to say that this letter was mailed.}

          If not TrialRun
            then
              begin
                _Found := FindKeyOld(GrievanceLetterSentTable,
                                     ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber',
                                      'ResultNumber', 'LetterName'],
                                     [GrievanceYear, SwisSBLKey, IntToStr(GrievanceNumber),
                                      IntToStr(ResultNumber), LetterName]);

                with GrievanceLetterSentTable do
                  try
                    If _Found
                      then Edit
                      else
                        begin
                          Insert;
                          FieldByName('TaxRollYr').Text := GrievanceYear;
                          FieldByName('GrievanceNumber').AsInteger := GrievanceNumber;
                          FieldByName('SwisSBLKey').Text := SwisSBLKey;
                          FieldByName('ResultNumber').AsInteger := ResultNumber;
                          FieldByName('LetterName').Text := LetterName;

                        end;  {else of If _Found}

                    FieldByName('DateSent').AsDateTime := Date;
                    FieldByName('TimeSent').AsDateTime := Now;
                    FieldByName('SentByUser').Text := GlblUserName;

                    Post;
                  except
                    SystemSupport(003, GrievanceLetterSentTable,
                                  'Error saving grievance letter sent record.',
                                  UnitName, GlblErrorDlgBox);
                  end;

              end;  {with GrievanceLetterSentTable do}

        end;  {If not Done}

    ReportCancelled := ProgressDialog.Cancelled;

    LastGrievanceNumber := GrievanceNumber;
    LastSwisSBLKey := SwisSBLKey;

  until (Done or ReportCancelled);

  ProgressDialog.Finish;
  GrievanceNumbersPrinted.Free;

    {Now load the text file into Excel and then do the mail merge.}

  CloseFile(LetterExtractFile);

  If (not ReportCancelled)
    then
      If _Compare(LettersPrinted.Count, 0, coEqual)
        then MessageDlg('There are no letters to be printed.', mtError, [mbOK], 0)
        else
          begin
            SendTextFileToExcelSpreadsheet(LetterExtractFileName, ExtractOnly,
                                           True, ChangeFileExt(LetterExtractFileName, '.XLS'));

            If not ExtractOnly
              then
                begin
                    {FXX08192002-1: First copy the merge document to a template to avoid
                                    MS Word associating the template with a particular Excel file.}

                  FileExtension := ExtractFileExt(MergeLetterTable.FieldByName('FileName').Text);
                  NewFileName := MergeLetterTable.FieldByName('FileName').Text;
                  ExtensionPos := Pos(FileExtension, NewFileName);
                  Delete(NewFileName, ExtensionPos, 200);
                  NewFileName := NewFileName + '_Template' + FileExtension;

                  CopyOneFile(MergeLetterTable.FieldByName('FileName').Text, NewFileName);

                  PerformWordMailMerge(NewFileName,
                                       ChangeFileExt(LetterExtractFileName, '.XLS'));

                end;  {If not ExtractOnly}

          end;  {else of If _Compare(LettersPrinted.Count, 0, coEqual)}

end;  {PrintLetters}

{======================================================================}
Procedure TGreivanceLettersForm.SetPrintOrder;

var
  iPrintOrder : LongInt;

begin
  iPrintOrder := 1;
  with GrievanceTable do
  begin
    First;

    while not EOF do
    begin
      _SetRange(GrievanceResultsTable,
                [FieldByName('TaxRollYr').AsString,
                 FieldByName('GrievanceNumber').AsString,
                 FieldByName('SwisSBLKey').AsString, 0],
                [FieldByName('TaxRollYr').AsString,
                 FieldByName('GrievanceNumber').AsString,
                 FieldByName('SwisSBLKey').AsString, 999], '', []);

      GrievanceResultsTable.First;

      while not GrievanceResultsTable.EOF do
      begin
        GrievanceResultsTable.Edit;
        GrievanceResultsTable.FieldByName('PrintOrder').AsInteger := iPrintOrder;
        iPrintOrder := iPrintOrder + 1;
        GrievanceResultsTable.Post;
        GrievanceResultsTable.Next;

      end;  {while not GrievanceResultsTable.EOF do}

      Next;

    end;  {while not EOF do}

  end;  {with GrievanceTable do}

end;  {SetPrintOrder}

{========================================================================}
{==================  PRINTING  ==========================================}
{======================================================================}
Procedure TGreivanceLettersForm.PrintButtonClick(Sender: TObject);

var
  NewFileName, sTempIndex : String;
  Quit : Boolean;
  I : Integer;

begin
  try
    LetterOLEContainer.DestroyObject;
  except
  end;

  ReportCancelled := False;
  Quit := False;

  SendToRepresentatives := SendToRepresentativesCheckBox.Checked;
  PrintOnlyLettersWithDifferentPetitionerAndRepresentatives := PrintRepresentativeLettersForPetitionersCheckBox.Checked;
  PrintDuplicateLabels := PrintDuplicateLabelsCheckBox.Checked;
  LabelPrintType := LabelPrintTypeRadioGroup.ItemIndex;
  GrievanceYear := GrievanceYearEdit.Text;
  PrintReport := PrintReportCheckBox.Checked;
  CommercialParcelsOnly := CommercialPropertiesOnlyCheckBox.Checked;
  ReprintLetters := ReprintLettersCheckBox.Checked;
  TrialRun := TrialRunCheckBox.Checked;
  CreateParcelList := CreateParcelListCheckBox.Checked;
  LetterType := LetterTypeRadioGroup.ItemIndex;
  LetterName := MergeLetterTable.FieldByName('LetterName').Text;
  ExcludeDuplicates := ExcludeDuplicatesCheckBox.Checked;
  ExtractOnly := ExtractOnlyCheckBox.Checked;
  LoadFromParcelList := LoadFromParcelListCheckBox.Checked;

    {CHG06242004-1(2.07l5): Option to print letters only for reps.}

  PrintOnlyLettersWithRepresentatives := PrintOnlyLettersWithRepresentativesCheckBox.Checked;

  SelectedGrievanceResultsTypeList.Clear;

  with GrievanceResultsTypeCheckListBox do
    For I := 0 to (Items.Count - 1) do
      If Checked[I]
        then SelectedGrievanceResultsTypeList.Add(Items[I]);


  PrintOrder := PrintOrderRadioGroup.ItemIndex;

    {CHG08202002-1: Allow them to choose the letter date.}

  try
    LetterDate := StrToDate(LetterDateEdit.Text);
  except
    LetterDate := Date;
  end;

    {CHG08092010-1(2.26.1.13)[I7859]: Add print by rep / SBL.}

  case LetterType of
    ltResults :
      case PrintOrder of
        poGrievanceNumber : GrievanceResultsTable.IndexName := 'BYYEAR_GRVNUM_SBL_RSLT';
        poParcelID : GrievanceResultsTable.IndexName := 'BYYEAR_SBL_GRVNUM_RSLT';
        poRepresentative_ParcelID :
          begin
            GrievanceResultsTable.IndexName := 'BYYEAR_GRVNUM_SBL_RSLT';
            sTempIndex := GrievanceTable.IndexName;
            GrievanceTable.IndexName := 'ByRep_SwisSBLKey';
            SetPrintOrder;
            GrievanceResultsTable.IndexName := 'ByPrintOrder';
            GrievanceTable.IndexName := sTempIndex;
          end;
      end;

    ltOther :
      case PrintOrder of
        poGrievanceNumber :
          begin
            GrievanceTable.IndexName := 'BYTAXROLLYR_GREVNUM';
            SetRangeOld(GrievanceTable, ['TaxRollYr', 'GrievanceNumber'],
                        [GrievanceYear, '0'],
                        [GrievanceYear, '9999']);

          end;  {poGrievanceNumber}

        poParcelID :
          begin
            GrievanceTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_GRVNUM';
            SetRangeOld(GrievanceTable, ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber'],
                        [GrievanceYear, '', '0'],
                        [GrievanceYear, 'ZZZZZ', '9999']);

          end;  {poParcelID}

      end;  {case PrintOrder of}

  end;  {case LetterType of}

    {FXX06192003-1(2.07d): Need to make sure that the results are limited to just the
                           correct grievance year.}

  GrievanceResultsTable.Filter := 'TaxRollYr=' + GrievanceYear;
  GrievanceResultsTable.Filtered := True;

  LettersPrinted.Clear;
  MergeFieldsToPrint.Assign(MergeFieldsUsedListBox.Items);

    {FXX09292003-2(2.07j): Verify that they are printing the correct letter.}

  If (MessageDlg('Are you sure you want to print the ' + MergeLetterTable.FieldByName('LetterName').Text + ' letter?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        PrintLetters;

        SetPrintToScreenDefault(PrintDialog);

        If (PrintReport and
            PrintDialog.Execute)
          then
            begin
              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                                    False, Quit);

              If not Quit
                then
                  begin
                    ProgressDialog.UserLabelCaption := '';

                    ProgressDialog.Start(GetRecordCount(GrievanceResultsTable), True, True);

                      {Now print the report.}

                    If not (Quit or ReportCancelled)
                      then
                        begin
                          GlblPreviewPrint := False;

                          ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                            {If they want to see it on the screen, start the preview.}

                          If PrintDialog.PrintToFile
                            then
                              begin
                                GlblPreviewPrint := True;
                                NewFileName := GetPrintFileName(Self.Caption, True);
                                ReportFiler.FileName := NewFileName;

                                try
                                  PreviewForm := TPreviewForm.Create(self);
                                  PreviewForm.FilePrinter.FileName := NewFileName;
                                  PreviewForm.FilePreview.FileName := NewFileName;

                                  PreviewForm.FilePreview.ZoomFactor := 130;

                                  ReportFiler.Execute;

                                    {FXX09071999-6: Tell people that printing is starting and
                                                    done.}

                                  ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                                  PreviewForm.ShowModal;
                                finally
                                  PreviewForm.Free;
                                end;

                                ShowReportDialog('Grievance Letters.RPT', NewFileName, True);

                              end
                            else ReportPrinter.Execute;

                        end;  {If not Quit}

                      {FXX09071999-6: Tell people that printing is starting and
                                      done.}

                    DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

                  end;  {If not Quit}

              ResetPrinter(ReportPrinter);

            end;  {If PrintDialog.Execute}

                {Now print labels if they asked for it.}

        If ((not Quit) and
            (LabelPrintType <> lptNone) and
            (MessageDlg('Please insert label paper to print labels for the letters.' + #13 +
                        'If you no longer want to print labels, select Cancel.' + #13 +
                        'Otherwise, select OK to continue.',
                        mtConfirmation, [mbOK, mbCancel], 0) = idOK) and
              ExecuteLabelOptionsDialogOld(lb_PrintLabelsBold,
                                           lb_PrintOldAndNewParcelIDs,
                                           lb_PrintSwisCodeOnParcelIDs,
                                           lb_PrintParcelIDOnly,
                                           lb_LabelType,
                                           lb_NumLinesPerLabel,
                                           lb_NumLabelsPerPage,
                                           lb_NumColumnsPerPage,
                                           lb_SingleParcelFontSize,
                                           lb_ResidentLabels,
                                           lb_LegalAddressLabels,
                                           lb_PrintParcelIDOnlyOnFirstLine,
                                           lb_LaserTopMargin,
                                           lb_PrintParcelID_PropertyClass) and
            PrintDialog.Execute)
          then
            begin
              AssignPrinterSettings(PrintDialog, LabelReportPrinter, LabelReportFiler, [ptLaser],
                                    False, Quit);

              If not Quit
                then
                  begin
                    ProgressDialog.UserLabelCaption := 'Printing Labels';

                    ProgressDialog.Start(GetRecordCount(GrievanceResultsTable), True, True);

                      {Now print the report.}

                    GlblPreviewPrint := False;

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

                      {FXX07221998-1: So that more than one person can run the report
                                      at once, use a time based name first and then
                                      rename.}

                    ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                      {If they want to see it on the screen, start the preview.}

                    If PrintDialog.PrintToFile
                      then
                        begin
                          GlblPreviewPrint := True;
                          NewFileName := GetPrintFileName(Self.Caption, True);
                          LabelReportFiler.FileName := NewFileName;

                          try
                            PreviewForm := TPreviewForm.Create(self);
                            PreviewForm.FilePrinter.FileName := NewFileName;
                            PreviewForm.FilePreview.FileName := NewFileName;

                            PreviewForm.FilePreview.ZoomFactor := 130;
                            LabelReportFiler.Execute;

                            ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                            PreviewForm.ShowModal;
                          finally
                            PreviewForm.Free;
                          end;

                        end
                      else LabelReportPrinter.Execute;

                  end;  {If not Quit}

              ResetPrinter(LabelReportPrinter);

            end;  {If ((not Quit) and ...}

        ProgressDialog.Finish;

        MergeLetterTableAfterScroll(MergeLetterTable);

      end;  {If (MessageDlg...}

end;  {PrintButtonClick}

{====================================================================}
Procedure TGreivanceLettersForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 0, BoxLineNone, 0);

        {Print the date and page number.}

      SetFont('Times New Roman',8);
      Println('');
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '    ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman',14);
      Bold := True;
      Home;
      Println('');
      PrintCenter('Grievance Letters Printed Report', (PageWidth / 2));
      Println('');
      Println('');

      SetFont('Times New Roman',10);
      Bold := True;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.0, 0, BoxLineBottom, 0);

      Println(#9 + 'Letter printed: ' + MergeLetterTable.FieldByName('LetterName').Text);

      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BoxLineNone, 0);
      SetTab(2.3, pjLeft, 2.0, 0, BoxLineNone, 0);
      SetTab(4.3, pjLeft, 2.0, 0, BoxLineNone, 0);

      Println('');
      Println('');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{====================================================================}
Procedure TGreivanceLettersForm.ReportPrint(Sender: TObject);

var
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      For I := 0 to (LettersPrinted.Count - 1) do
        begin
          If ((I mod 3) = 0)
            then Println('');

          If (LinesLeft < 5)
            then NewPage;

          Print(#9 + ConvertSwisSBLToDashDot(LettersPrinted[I]));

        end;  { For I := 0 to (LettersPrinted.Count - 1) do}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrinterPrint}

{===============================================================}
Procedure TGreivanceLettersForm.LabelPrintHeader(Sender: TObject);

begin
  PrintLabelHeaderOld(Sender, lb_LabelType,
                      lb_LaserTopMargin, lb_PrintLabelsBold);
end;  {LabelPrintHeader}

{===============================================================}
Procedure TGreivanceLettersForm.LabelPrint(Sender: TObject);

var
  Name2FilledIn, PrintLetter,
  Done, FirstTimeThrough,
  DoneResults, FirstTimeThroughResults, ProSeGrievance : Boolean;
  I, StartIndex,
  LastGrievanceNumber, GrievanceNumber : Integer;
  LastSwisSBLKey, SwisSBLKey : String;
  PNAddrArray : PNameAddrArray;
  LabelList : TList;
  PSwisSBLKey : PSwisSBLKeyType;
  GrievanceNumbersPrinted, PetitionersPrinted : TStringList;
  AssessmentYearControlTable : TTable;

begin
  Done := False;
  FirstTimeThrough := True;
  ReprintLetters := True;
  PetitionersPrinted := TStringList.Create;

  with GrievanceTable do
    case LabelPrintType of
      lptByParcelID : IndexName := 'BySwisSBLKey';
      lptByGrievanceNumber : IndexName := 'ByGrevNum';
      lptByPetitionerName : IndexName := 'ByPetitionerName';
    end;

  GrievanceTable.Filter := 'TaxRollYr=' + GrievanceYear;
  GrievanceTable.Filtered := True;

  LastGrievanceNumber := 0;
  LastSwisSBLKey := '';
  GrievanceNumbersPrinted := TStringList.Create;

  LabelList := TList.Create;

  GrievanceTable.First;
  AssessmentYearControlTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName, ThisYear);

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else GrievanceTable.Next;

    If GrievanceTable.EOF
      then Done := True;

    GrievanceNumber := GrievanceTable.FieldByName('GrievanceNumber').AsInteger;
    SwisSBLKey := GrievanceTable.FieldByName('SwisSBLKey').Text;

    ProgressDialog.Update(Self, 'Grievance = ' + IntToStr(GrievanceNumber));
    Application.ProcessMessages;

    If not Done
      then
        begin
          with GrievanceTable do
            SetRangeOld(GrievanceResultsTable,
                        ['TaxRollYr', 'SwisSBLKey', 'GrievanceNumber', 'ResultNumber'],
                        [FieldByName('TaxRollYr').Text,
                         FieldByName('SwisSBLKey').Text,
                         FieldByName('GrievanceNumber').Text, '1'],
                        [FieldByName('TaxRollYr').Text,
                         FieldByName('SwisSBLKey').Text,
                         FieldByName('GrievanceNumber').Text, '999']);

          FirstTimeThroughResults := True;
          DoneResults := False;

          GrievanceResultsTable.First;

          repeat
            If FirstTimeThroughResults
              then FirstTimeThroughResults := False
              else GrievanceResultsTable.Next;

            If GrievanceResultsTable.EOF
              then DoneResults := True;

              {Suppress duplicates by petitioner.}
              {FXX03022005-1(2.8.3.9): Make sure the prose ones get printed.}

            PrintLetter := True;

            ProSeGrievance := _Compare(GrievanceTable.FieldByName('PetitName1').Text, coBlank);

            If ((not PrintDuplicateLabels) and
                (not ProSeGrievance) and
                (PetitionersPrinted.IndexOf(Trim(GrievanceTable.FieldByName('PetitName1').Text)) > -1))
              then PrintLetter := False;

            If ((not DoneResults) and
                PrintLetter and
                PrintThisLetter(GrievanceTable, GrievanceResultsTable,
                                GrievanceNumber, LastGrievanceNumber,
                                SwisSBLKey, LastSwisSBLKey,
                                GrievanceNumbersPrinted, False, False))
              then
                begin
                  PetitionersPrinted.Add(Trim(GrievanceTable.FieldByName('PetitName1').Text));

                  If (lb_LabelType = lbLaser1Liner)
                    then
                      begin
                        New(PSwisSBLKey);
                        If lb_PrintSwisCodeOnParcelIDs
                          then PSwisSBLKey^ := ConvertSwisSBLToDashDot(SwisSBLKey)
                          else PSwisSBLKey^ := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                        LabelList.Add(PSwisSBLKey);
                      end
                    else
                      begin
                        New(PNAddrArray);

                        with GrievanceTable do
                          If ProSeGrievance
                            then FillInNameAddrArray(FieldByName('CurrentName1').Text,
                                                     FieldByName('CurrentName2').Text,
                                                     FieldByName('CurrentAddress1').Text,
                                                     FieldByName('CurrentAddress2').Text,
                                                     FieldByName('CurrentStreet').Text,
                                                     FieldByName('CurrentCity').Text,
                                                     FieldByName('CurrentState').Text,
                                                     FieldByName('CurrentZip').Text,
                                                     FieldByName('CurrentZipPlus4').Text,
                                                     True, False, PNAddrArray^)
                            else FillInNameAddrArray(FieldByName('PetitName1').Text,
                                                     FieldByName('PetitName2').Text,
                                                     FieldByName('PetitAddress1').Text,
                                                     FieldByName('PetitAddress2').Text,
                                                     FieldByName('PetitStreet').Text,
                                                     FieldByName('PetitCity').Text,
                                                     FieldByName('PetitState').Text,
                                                     FieldByName('PetitZip').Text,
                                                     FieldByName('PetitZipPlus4').Text,
                                                     True, False, PNAddrArray^);

                        If lb_ResidentLabels
                          then
                            begin
                              Name2FilledIn := (Deblank(GrievanceTable.FieldByName('PetitName2').Text) <> '');

                              PNAddrArray^[1] := 'RESIDENT';

                                {If name 2 is filled in then move everything from
                                 the 3rd line up one since 'RESIDENT' replaces the
                                 name.  So, we are assuming the 2nd line is name
                                 info and not address.}

                              If Name2FilledIn
                                then
                                  begin
                                    For I := 3 to 6 do
                                      PNAddrArray^[I-1] := PNAddrArray^[I];

                                    PNAddrArray^[6] := '';

                                  end;  {If Name2FilledIn}

                            end;  {If lb_ResidentLabels}

                        If lb_LegalAddressLabels
                          then
                            begin
                                {FXX05222004-1(2.07l4): If resident and legal address labels, do 'Resident'
                                                        on line 1, legal addr on line 2 and then city info on
                                                        line 3.}

                              If lb_ResidentLabels
                                then
                                  begin
                                    PNAddrArray^[1] := 'RESIDENT';
                                    StartIndex := 2;
                                  end
                                else
                                  begin
                                    Name2FilledIn := (Deblank(GrievanceTable.FieldByName('Name2').Text) <> '');

                                    If Name2FilledIn
                                      then StartIndex := 3
                                      else StartIndex := 2;

                                  end;  {else of If lb_ResidentLabels}

                                {Clear out everything after the name.}

                              For I := StartIndex to 6 do
                                PNAddrArray^[I] := '';

                              PNAddrArray^[StartIndex] := GetLegalAddressFromTable(GrievanceTable);

                              FindKeyOld(SwisCodeTable, ['SwisCode'], [Copy(SwisSBLKey, 1, 6)]);

                              with SwisCodeTable do
                                PNAddrArray^[StartIndex + 1] := Trim(FieldByName('MunicipalityName').Text) +
                                                                ', NY ' +
                                                                FieldByName('ZipCode').Text;

                            end;  {If LegalAddressLabels}

                          {CHG07192000-1: Allow them to print labels with just parcel IDs.}

                        If lb_PrintParcelIDOnly
                          then
                            begin
                              For I := 1 to 6 do
                                PNAddrArray^[I] := '';

                              If lb_PrintSwisCodeOnParcelIDs
                                then PNAddrArray^[3] := ConvertSwisSBLToDashDot(SwisSBLKey)
                                else PNAddrArray^[3] := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));

                            end
                          else
                            begin
                              If lb_PrintParcelID_PropertyClass
                                then PrintLabelParcelID_Class(SwisSBLKey, PNAddrArray^, False,
                                                              lb_PrintSwisCodeOnParcelIDs,
                                                              GrievanceTable.FieldByName('PropertyClassCode').Text);

                              If lb_PrintParcelIDOnlyOnFirstLine
                                then PrintLabelParcelID_Class(SwisSBLKey, PNAddrArray^, False,
                                                              lb_PrintSwisCodeOnParcelIDs,
                                                              GrievanceTable.FieldByName('PropertyClassCode').Text);

                              If lb_PrintOldAndNewParcelIDs
                                then PrintLabelOldAndNewParcelID(SwisSBLKey, PNAddrArray^,
                                                                 GrievanceTable,
                                                                 AssessmentYearControlTable,
                                                                 lb_PrintSwisCodeOnParcelIDs, False);

                            end;  {else of If PrintParcelIDOnly}

                        LabelList.Add(PNAddrArray);

                      end;  {else of If (lb_LabelType = lbLaser1Liner)}

                end;  {If ((not DoneResults) and}

          until DoneResults;

        end;  {If not Done}

    LastGrievanceNumber := GrievanceNumber;
    LastSwisSBLKey := SwisSBLKey;

  until Done;



  PrintLabelsOld(Sender, LabelList, lb_LabelType,
                 lb_PrintParcelIDOnly, lb_PrintLabelsBold,
                 lb_NumLinesPerLabel, lb_NumLabelsPerPage,
                 lb_NumColumnsPerPage, lb_SingleParcelFontSize, 0, nil,
                 False, nil, False, nil);

  If (lb_LabelType = lbLaser1Liner)
    then FreeTList(LabelList, 26)
    else FreeTList(LabelList, SizeOf(NameAddrArray));

  GrievanceNumbersPrinted.Free;
  PetitionersPrinted.Free;

  GrievanceTable.Filtered := False;
  GrievanceTable.Filter := '';

end;  {LabelPrint}

{===============================================================}
Procedure TGreivanceLettersForm.CloseButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TGreivanceLettersForm.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  MergeFieldsToPrint.Free;
  SelectedGrievanceResultsTypeList.Free;
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;

  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.