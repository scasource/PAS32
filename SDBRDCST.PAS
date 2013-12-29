unit SDBRDCST;

{Import File Layouts:

  Fixed File
  ----------
  SwisSBLKey  4 ->29
  SD Code     48->52
  Units       53->59
  Percent     60->64
  Calc Code   65->65
  Amount      66->78
  The rest is filler.

  Comma Delimited File
  --------------------
  SwisSBLKey
  SD Code
  Calc Code
  Amount
  Units
  2nd Units
  Percentage

  Tab Delimited File
  ------------------
  SwisCode
  Print Key
  SD Code
  Amount
  Calc Code
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, wwdblook,
  TabNotBk, Types, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, ComCtrls(*, Progress*);

type
  TSDBroadcastForm = class(TForm)
    SDCodeTable: TwwTable;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    ParcelSDTable: TTable;
    SDCalcCodeTable: TwwTable;
    SDCodeTable2: TwwTable;
    PropertyClassTable: TwwTable;
    ParcelTable: TTable;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    SwisCodeTable: TTable;
    ParcelSDLookupTable: TTable;
    NotebookChangeTimer: TTimer;
    AssessmentTable: TTable;
    ExemptionTable: TTable;
    ExemptionCodeTable: TTable;
    RollTotalParcelSDTable: TTable;
    RollTotalSDCodeTable: TTable;
    AuditSDChangeTable: TTable;
    SDExtensionCodeTable: TTable;
    OpenDialog: TOpenDialog;
    SDExtensionTable: TTable;
    Panel3: TPanel;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    Panel4: TPanel;
    Notebook: TTabbedNotebook;
    AssessmentYearRadioGroup: TRadioGroup;
    BroadcastMethodRadioGroup: TRadioGroup;
    PropertiesGroupBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SDCodeLookupCombo: TwwDBLookupCombo;
    AmountEdit: TEdit;
    UnitsEdit: TEdit;
    SecondaryUnitsEdit: TEdit;
    PercentageEdit: TEdit;
    CalcCodeLookupCombo: TwwDBLookupCombo;
    TrialRunCheckBox: TCheckBox;
    SelectExistingSDGroupBox: TGroupBox;
    SelectedSDCodeLookupCombo: TwwDBLookupCombo;
    SelectParcelIDGroupBox: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    StartParcelIDEdit: TEdit;
    EndParcelIDEdit: TEdit;
    PropertyClassSelectionGroupBox: TGroupBox;
    PropertyClassLookupCombo: TwwDBLookupCombo;
    SwisCodeSelectionGroupBox: TGroupBox;
    SwisCodeListBox: TListBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure StartButtonClick(Sender: TObject);
    procedure NotebookChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure PrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure AssessmentYearRadioGroupClick(Sender: TObject);
    procedure NotebookChangeTimerTimer(Sender: TObject);
    procedure DecimalFieldEditExit(Sender: TObject);
    procedure BroadcastMethodRadioGroupClick(Sender: TObject);
    procedure SDCodeLookupComboCloseUp(Sender: TObject; LookupTable,
      FillTable: TDataSet; modified: Boolean);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;

    AssessmentYear,
    BroadcastMethod : Integer;
    TemplateSDCode : String;
    TemplateCalcCode : String;
    TemplateAmount, TemplateUnits,
    TemplateSecondaryUnits, TemplatePercentage : Double;
    SelectedSwisCodes : TStringList;
    SelectedPropertyClass : String;
    StartParcelID, EndParcelID, ImportFileName : String;
    BroadcastToParcelsWithSD : String;
    TrialRun, ReportCancelled : Boolean;
    CurrentAssessmentYear : String;
    LastPage0Control : TWinControl;
    ReportSection : Integer;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure SetReadOnlyFields;
    {Set the fields read only or required depending on the type of sd.}

    Function ValidSelections : Boolean;

    Procedure PrintRejects(Sender : TObject;
                           RejectList : TList);

    Procedure AddSDCode(    Sender : TObject;
                            ParcelTable,
                            ParcelSDTable : TTable;
                            AssessmentYear : String;
                            SwisSBLKey : String;
                            SDExists : Boolean;
                        var NumParcelsPrinted : LongInt;
                            SDExistsList : TStringList);
    {Add a special district to this parcel and print it out.}

    Procedure UpdateSDCode(    Sender : TObject;
                               ParcelTable,
                               ParcelSDTable : TTable;
                               AssessmentYear : String;
                               SwisSBLKey : String;
                               SDExists : Boolean;
                           var NumParcelsPrinted : LongInt;
                               lstSDDoesNotExist : TStringList);

    Procedure AddSDCodesBySwisCode(    Sender : TObject;
                                       ParcelTable,
                                       ParcelSDTable : TTable;
                                       AssessmentYear : String;
                                   var NumParcelsPrinted : LongInt);
    {Add the template special district to each parcel in the selected swis codes.}

    Procedure AddSDCodesByParcelID(    Sender : TObject;
                                       ParcelTable,
                                       ParcelSDTable : TTable;
                                       AssessmentYear : String;
                                   var NumParcelsPrinted : LongInt);
    {Add the template special district to each parcel in the selected parcel ID
     range.}

    Procedure AddSDCodesByPropertyClass(    Sender : TObject;
                                            ParcelTable,
                                            ParcelSDTable : TTable;
                                            AssessmentYear : String;
                                        var NumParcelsPrinted : LongInt);
    {Add the template special district to each parcel with the specified
     property class.}

    Procedure AddSDCodesByPreviousSD(    Sender : TObject;
                                         ParcelTable,
                                         ParcelSDTable,
                                         ParcelSDLookupTable : TTable;
                                         AssessmentYear : String;
                                     var NumParcelsPrinted : LongInt);
    {Add the template special district to each parcel which already has the specified
     SD.}

    Procedure AddSDCodesByImportFile(    Sender : TObject;
                                         ParcelTable,
                                         ParcelSDTable : TTable;
                                         AssessmentYear : String;
                                         iBroadcastMethod : Integer;
                                     var NumParcelsPrinted : LongInt);
    {Add the special districts in an extract file.}
    {CHG06171998-1: Add the option to import from a file.}

    Procedure AddSDCodesByParcelList(    Sender : TObject;
                                         ParcelTable,
                                         ParcelSDTable : TTable;
                                         AssessmentYear : String;
                                     var NumParcelsPrinted : LongInt);
    {Add the template SD to each parcel in the parcel list.}

    Procedure UpdateSDCodesByParcelList(    Sender : TObject;
                                            ParcelTable,
                                            ParcelSDTable : TTable;
                                            AssessmentYear : String;
                                        var NumParcelsPrinted : LongInt);
    {Update the template SD to each parcel in the parcel list.}

    Procedure DeleteSDCode(    Sender : TObject;
                               ParcelTable,
                               ParcelSDTable : TTable;
                               AssessmentYear : String;
                               bDeleteByList : Boolean;
                           var NumParcelsPrinted : LongInt);

    Procedure PrintTotalNumPrinted(Sender : TObject;
                                   AssessmentYear : String;
                                   NumParcelsPrinted : LongInt);

    Procedure OpenTables(Form : TForm;
                         ProcessingType : Integer);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, UTILEXSD, GlblCnst, PASUtils,
     UTILRTOT,  {Roll total update unit.}
     PRCLList, Prog,
     Preview, PASTypes, DataAccessUnit;

const
    {Assessment Years}
  ayThisYear = 0;
  ayNextYear = 1;
  ayBothYears = 2;

    {Broadcast methods}

  bmSwisCode = 0;
  bmParcelIDRange = 1;
  bmPropertyClass = 2;
  bmParcelsWithCertainSD = 3;
  bmImportFileFixedPosition = 4;
  bmImportFileCommaDelimited = 5;
  bmImportFileTabDelimited = 6;
  bmParcelList = 7;
  bmDeleteSD = 8;
  bmDeleteSDByParcelList = 9;
  bmUpdateByParcelList = 10;

  NumColumns = 3;

  rsMain = 0;
  rsRejects = 1;

type
  RejectRecord = record
    SwisSBLKey : String;
    SDCode : String;
    CalcCode : String;
    Units : Double;
    SecondaryUnits : Double;
    Percent : Double;
    Amount : Double;
    LineNumber : Integer;
    Reason : String;
  end;

  RejectPointer = ^RejectRecord;


{$R *.DFM}

{========================================================}
Procedure TSDBroadcastForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TSDBroadcastForm.InitializeForm;

var
  Done, FirstTimeThrough : Boolean;

begin
  UnitName := 'SDBRDCST';  {mmm}

  OpenTablesForForm(Self, GlblProcessingType);

    {Now fill the swis, school, and neighborhood codes.}

  SwisCodeTable.First;

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SwisCodeTable.Next;

    If SwisCodeTable.EOF
       then Done := True;

    If not Done
      then
        with SwisCodeTable do
          SwisCodeListBox.Items.Add(FieldByName('SwisCode').Text + ' - ' +
                                    Take(15, FieldByName('MunicipalityName').Text));

  until Done;

end;  {InitializeForm}

{===================================================================}
Procedure TSDBroadcastForm.OpenTables(Form : TForm;
                                      ProcessingType : Integer);

{FXX11052001-2: If running broadcast more than 1 time, the tables were not being
                reopened to TY / NY Correctly.  Created seperate procedure to
                open tables to correct year.}

var
  Quit : Boolean;

begin
  OpenTableForProcessingType(SDCodeTable, SdistCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelSDTable, SpecialDistrictTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SDCodeTable2, SdistCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelSDLookupTable, SpecialDistrictTableName,
                             ProcessingType, Quit);

end;  {OpenTables}


{===================================================================}
Procedure TSDBroadcastForm.FormKeyPress(    Sender: TObject;
                                     var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{==================================================================}
Procedure TSDBroadcastForm.AssessmentYearRadioGroupClick(Sender: TObject);

{Switch the lookup tables based on which year they want. Note that for
 BothYears, we will use ThisYear lookup tables.}

var
  Quit : Boolean;

begin
  case AssessmentYearRadioGroup.ItemIndex of
    ayThisYear,
    ayBothYears :
      begin
        OpenTableForProcessingType(SDCodeTable, SdistCodeTableName,
                                   ThisYear, Quit);

        OpenTableForProcessingType(SDCodeTable2, SdistCodeTableName,
                                   ThisYear, Quit);

      end;  {ayThisYear, ayBothYears}

    ayNextYear :
      begin
        OpenTableForProcessingType(SDCodeTable, SdistCodeTableName,
                                   NextYear, Quit);

        OpenTableForProcessingType(SDCodeTable2, SdistCodeTableName,
                                   NextYear, Quit);

      end;  {ayNextYear}

  end;  {case AssessmentYearRadioGroup.ItemIndex of}

end;  {AssessmentYearRadioGroupClick}

{==============================================================}
Procedure SetEditReadOnlyStatus(Sender : TObject);

begin
  If (Sender is TwwDBLookupCombo)
    then
      with Sender as TwwDBLookupCombo do
        If ReadOnly
          then
            begin
              Color := clBtnFace;
              Text := '';
            end
          else Color := clWindow;

  If (Sender is TEdit)
    then
      with Sender as TEdit do
        If ReadOnly
          then
            begin
              Color := clBtnFace;
              Text := '';
            end
          else Color := clWindow;

end;  {SetEditReadOnlyStatus}

{==================================================================}
Procedure TSDBroadcastForm.BroadcastMethodRadioGroupClick(Sender: TObject);

begin
  If _Compare(BroadcastMethodRadioGroup.ItemIndex, [bmDeleteSD, bmDeleteSDByParcelList], coEqual)
    then
      begin
        PropertiesGroupBox.Caption := ' Select Special District to Delete: ';
        SetEditReadOnlyStatus(CalcCodeLookupCombo);
        SetEditReadOnlyStatus(AmountEdit);
        SetEditReadOnlyStatus(UnitsEdit);
        SetEditReadOnlyStatus(SecondaryUnitsEdit);
        SetEditReadOnlyStatus(PercentageEdit);

      end
    else PropertiesGroupBox.Caption := ' Select Properties of Broadcasted Special District: ';

end;  {BroadcastMethodRadioGroupClick}

{==================================================================}
Procedure TSDBroadcastForm.DecimalFieldEditExit(Sender: TObject);

{Make sure that they entered a number in the amount, unit, secondary unit
 or percentage field.}

var
  EditOK : Boolean;
  TempNum : Double;

begin
  EditOK := True;
  TempNum := 0;

  with Sender as TEdit do
    begin
      try
        TempNum := StrToFloat(Text);
      except
        If (Deblank(Text) <> '')
          then
            begin
              MessageDlg('Please enter a number.', mtError, [mbOK], 0);
              SetFocus;
              EditOK := False;
            end;

      end;  {try}

        {Reformat with two decimals.}

      If EditOK
        then
          If (Name = 'PercentageEdit')
            then Text := FormatFloat(NoDecimalDisplay_BlankZero, TempNum)
            else Text := FormatFloat(DecimalDisplay_BlankZero, TempNum);

    end;  {with Sender as TEdit do}

end;  {DecimalFieldEditExit}

{==================================================================}
Procedure TSDBroadcastForm.NotebookChange(    Sender: TObject;
                                              NewTab: Integer;
                                          var AllowChange: Boolean);

{Don't allow change if range type not selected. If selected, setup
 range page.}

begin
  If (NewTab = 1)
    then
      begin
        If (BroadcastMethodRadioGroup.ItemIndex = -1)
          then
            begin
              MessageDlg('Please select the broadcast method before selecting the range.',
                         mtError, [mbOK], 0);
              AllowChange := False;
            end
          else
            begin
              SwisCodeSelectionGroupBox.Visible := False;
              PropertyClassSelectionGroupBox.Visible := False;
              SelectExistingSDGroupBox.Visible := False;
              SelectParcelIDGroupBox.Visible := False;

              case BroadcastMethodRadioGroup.ItemIndex of
                bmSwisCode : SwisCodeSelectionGroupBox.Visible := True;
                bmParcelIDRange : SelectParcelIDGroupBox.Visible := True;
                bmPropertyClass : PropertyClassSelectionGroupBox.Visible := True;
                bmParcelsWithCertainSD : SelectExistingSDGroupBox.Visible := True;
              end;  {case BroadcastMethodRadioGroup.ItemIndex of}

            end;  {else of If (BroadcastMethodRadioGroup.ItemIndex = -1)}

        LastPage0Control := Screen.ActiveControl

      end;  {If (NewTab = 1)}

  NotebookChangeTimer.Enabled := True;

end;  {TabbedNotebookChange}

{==============================================================}
Procedure TSDBroadcastForm.NotebookChangeTimerTimer(Sender: TObject);

{FXX04281998-5: Set focus to the relevant field on the page.}

begin
  NotebookChangeTimer.Enabled := False;

  case Notebook.PageIndex of
    0 : LastPage0Control.SetFocus;
    1 : case BroadcastMethodRadioGroup.ItemIndex of
          bmSwisCode : SwisCodeListBox.SetFocus;
          bmParcelIDRange : StartParcelIDEdit.SetFocus;
          bmPropertyClass : PropertyClassLookupCombo.SetFocus;
          bmParcelsWithCertainSD : SelectedSDCodeLookupCombo.SetFocus;

        end;  {case BroadcastMethodRadioGroup.ItemIndex of}

  end;  {case Notebook.PageIndex of}

end;  {NotebookChangeTimerTimer}

{==============================================================}
Procedure TSDBroadcastForm.SetReadOnlyFields;

{Set the fields read only or required depending on the type of sd.}

var
  I : Integer;
  ECDArray : ECdeArray;
  ECDCategory : String;
  TempFieldName : String;

begin
     {For each extension code for this SD code, set flds
      to be not readonly if the ext code for the Sd code
      requires that field.}

  with SDCodeTable do
    For I := 1 to 10 do
      begin
        ECdArray[I] := Take(2,' ');

        TempFieldName := 'ECD' + IntToStr(I);

        If (Deblank(FieldByName(TempFieldName).Text) <> '')
          then ECdArray[I] := Take(2, FieldByName(TempFieldName).Text);

      end;  {For I := 1 to 10 do}

    {FXX10221997-6: Remove for now - not letting them edit units at all.}

  AmountEdit.ReadOnly := True;
  UnitsEdit.ReadOnly := True;
  SecondaryUnitsEdit.ReadOnly := True;
  PercentageEdit.ReadOnly := True;
  CalcCodeLookupCombo.ReadOnly := True;

  For I := 1 to 10 do
    If (Deblank(ECDArray[I]) <> '')
      then
        begin
          FindKeyOld(SDExtensionCodeTable, ['MainCode'],
                     [ECDArray[I]]);
          ECDCategory := SDExtensionCodeTable.FieldByName('Category').Text;

          If (ECDCategory = SDistCategoryDIMN)
            then UnitsEdit.ReadOnly := False;

          If (ECDCategory = SDistCategoryUNIT)
            then
              begin
                CalcCodeLookupCombo.ReadOnly := False;
                UnitsEdit.ReadOnly := False;
                SecondaryUnitsEdit.ReadOnly := False;

             end;  {If (ECDCategory = SDistCategoryUNIT)}

         If (ECDCategory = SDistCategorySTUN)
           then
             begin
               UnitsEdit.ReadOnly := False;
               SecondaryUnitsEdit.ReadOnly := False;

             end;  {If (ECDCategory = SDistCategorySTUN)}

         If (ECDCategory = SDistCategoryADVL)
           then
             begin
               CalcCodeLookupCombo.ReadOnly := False;
               AmountEdit.ReadOnly := False;
               PercentageEdit.ReadOnly := False;

             end;  {If (ECDCategory = SDistCategoryADVL)}

         If (ECDCategory = SDistCategoryFIXD)
           then
             begin
                 {mt can put in value in amount field}

               If (ECDArray[I] = SDistEcMT)
                 then CalcCodeLookupCombo.ReadOnly := False;

               AmountEdit.ReadOnly := False;

             end;  {If (ECDCategory = SDistCategoryFIXD)}

          If (CalcCodeLookupCombo.Text = 'U')
            then SecondaryUnitsEdit.ReadOnly := False;

        end; {If (Deblank(ECDArray[I]) <> '')}

    {Now based on the stuff above, set the edit boxes to readonly or not.}

  SetEditReadOnlyStatus(CalcCodeLookupCombo);
  SetEditReadOnlyStatus(AmountEdit);
  SetEditReadOnlyStatus(UnitsEdit);
  SetEditReadOnlyStatus(SecondaryUnitsEdit);
  SetEditReadOnlyStatus(PercentageEdit);

end;  {SetReadOnlyFields}

{==============================================================}
Procedure TSDBroadcastForm.SDCodeLookupComboCloseUp(Sender: TObject;
                                                    LookupTable,
                                                    FillTable: TDataSet;
                                                    modified: Boolean);

{FXX04281998-8: Enforce valid entry of SD amounts based on extensions.}

begin
  If _Compare(BroadcastMethodRadioGroup.ItemIndex, [bmDeleteSD, bmDeleteSDByParcelList], coNotEqual)
    then SetReadOnlyFields;
end;  {SDCodeLookupComboCloseUp}

{==============================================================}
Function TSDBroadcastForm.ValidSelections : Boolean;

{Have they entered everything they need for this SD broadcast?}

var
  I, NumSelected : Integer;

begin
  Result := True;

    {CHG06171998-1: Add feature to import by file.}

  If not (BroadcastMethodRadioGroup.ItemIndex in [bmImportFileFixedPosition, bmImportFileCommaDelimited, bmImportFileTabDelimited])
    then
      begin
        If (Deblank(SDCodeLookupCombo.Text) = '')
          then
            begin
              MessageDlg('Please enter the special district that you wish to broadcast.',
                         mtError, [mbOK], 0);

                {Set focus back to the SD combo box, changing pages if necessary.}

              If (Notebook.PageIndex = 0)
                then SDCodeLookupCombo.SetFocus
                else
                  begin
                    LastPage0Control := SDCodeLookupCombo;
                    Notebook.PageIndex := 0;
                  end;

              Result := False;

            end;  {If (Deblank(SDCodeLookupCombo.Text) = '')}

          {Make sure they selected an assessment year.}

        If (Result and
            (AssessmentYearRadioGroup.ItemIndex = -1))
          then
            begin
              MessageDlg('Please select the assessment year(s).',
                         mtError, [mbOK], 0);

                {Set focus back to the assessment radio box, changing pages if necessary.}

              If (Notebook.PageIndex = 0)
                then AssessmentYearRadioGroup.SetFocus
                else
                  begin
                    LastPage0Control := AssessmentYearRadioGroup;
                    Notebook.PageIndex := 0;
                  end;

              Result := False;

            end;  {If (Result and ...}

          {Make sure they selected a range.}

        If Result
          then
            case BroadcastMethodRadioGroup.ItemIndex of
              bmSwisCode :
                begin
                  NumSelected := 0;

                  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
                    If SwisCodeListBox.Selected[I]
                      then NumSelected := NumSelected + 1;

                  If (NumSelected = 0)
                    then
                      begin
                        MessageDlg('Please select the swis code(s) to broadcast to.',
                                   mtError, [mbOK], 0);

                          {Set focus on the swis list box, changing notebook pages
                           if necessary.}

                        If (Notebook.PageIndex = 0)
                          then Notebook.PageIndex := 1
                          else SwisCodeListBox.SetFocus;

                        Result := False;

                      end;  {If (NumSelected = 0)}

                end;  {bmSwisCode}

              bmParcelIDRange :
                begin
                  If ((Deblank(StartParcelIDEdit.Text) = '') or
                      (Deblank(EndParcelIDEdit.Text) = ''))
                    then
                      begin
                        MessageDlg('Please select the parcel ID range to broadcast to.',
                                   mtError, [mbOK], 0);

                          {Set focus on the start parcel ID box, changing notebook pages
                           if necessary.}

                        If (Notebook.PageIndex = 0)
                          then Notebook.PageIndex := 1
                          else StartParcelIDEdit.SetFocus;

                        Result := False;

                      end;  {If ((Deblank(StartParcelIDEdit.Text) = '') or ...}

                end;  {bmParcelIDRange}

              bmPropertyClass :
                begin
                  If (Deblank(PropertyClassLookupCombo.Text) = '')
                    then
                      begin
                        MessageDlg('Please select the property class to broadcast to.',
                                   mtError, [mbOK], 0);

                          {Set focus on the property class combo, changing notebook pages
                           if necessary.}

                        If (Notebook.PageIndex = 0)
                          then Notebook.PageIndex := 1
                          else PropertyClassLookupCombo.SetFocus;

                        Result := False;

                      end;  {If (Deblank(PropertyClassLookupCombo.Text) = '')}

                end;  {bmPropertyClass}

              bmParcelsWithCertainSD :
                begin
                  If (Deblank(SelectedSDCodeLookupCombo.Text) = '')
                    then
                      begin
                        MessageDlg('Please select the existing special district to broadcast to.',
                                   mtError, [mbOK], 0);

                          {Set focus on the existing SD combo, changing notebook pages
                           if necessary.}

                        If (Notebook.PageIndex = 0)
                          then Notebook.PageIndex := 1
                          else SelectedSDCodeLookupCombo.SetFocus;

                        Result := False;

                      end;  {If (Deblank(SelectedSDCodeLookupCombo.Text) = '')}

                end;  {bmParcelsWithCertainSD}

            end;  {case BroadcastMethodRadioGroup.ItemIndex of}

      end;  {If (BroadcastMethodRadioGroup.ItemIndex <> bmImportFile)}

end;  {ValidSelections}

{==============================================================}
Procedure TSDBroadcastForm.StartButtonClick(Sender: TObject);

var
  I : Integer;
  TempStr, NewFileName : String;
  Quit, Cancelled : Boolean;

begin
  ReportSection := rsMain;
  BroadcastMethod := BroadcastMethodRadioGroup.ItemIndex;
  ProgressDialog.UserLabelCaption := '';

  If (ValidSelections and
      (_Compare(BroadcastMethod, [bmDeleteSD, bmDeleteSDByParcelList], coNotEqual) or
       (_Compare(BroadcastMethod, [bmDeleteSD, bmDeleteSDByParcelList], coEqual) and
        (MessageDlg('Are you sure you want to delete special district ' +
                    SDCodeLookupCombo.Text + '?', mtConfirmation, [mbYes, mbNo], 0) = idYes))))
    then
      begin
        If _Compare(BroadcastMethod, [bmDeleteSD, bmDeleteSDByParcelList], coEqual)
          then TempStr := 'from which the special district is deleted.'
          else TempStr := 'that receive the special district.';

        MessageDlg('The special district broadcast prints a list of all' + #13 +
                   'parcels ' + TempStr + #13 +
                   'Please select where the print output should go in the' + #13 +
                   'following Print dialog box which will appear after you press OK.',
                   mtInformation, [mbOK], 0);

          {CHG10121998-1: Add user options for default destination and show vet max msg.}

        SetPrintToScreenDefault(PrintDialog);

        If PrintDialog.Execute
          then
            begin
                {CHG10131998-1: Set the printer settings based on what printer they selected
                                only - they no longer need to worry about paper or landscape
                                mode.}

              AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

              AssessmentYear := AssessmentYearRadioGroup.ItemIndex;

                {Template information}

              TemplateSDCode := SDCodeLookupCombo.Text;
              TemplateCalcCode := CalcCodeLookupCombo.Text;

              try
                TemplateAmount := StrToFloat(AmountEdit.Text);
              except
                TemplateAmount := 0;
              end;

              try
                TemplateUnits := StrToFloat(UnitsEdit.Text);
              except
                TemplateUnits := 0;
              end;

              try
                TemplateSecondaryUnits := StrToFloat(SecondaryUnitsEdit.Text);
              except
                TemplateSecondaryUnits := 0;
              end;

              try
                TemplatePercentage := StrToFloat(PercentageEdit.Text);
              except
                TemplatePercentage := 0;
              end;

                 {Range information}

              SelectedSwisCodes := TStringList.Create;

              For I := 0 to (SwisCodeListBox.Items.Count - 1) do
                If SwisCodeListBox.Selected[I]
                  then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

              SelectedPropertyClass := PropertyClassLookupCombo.Text;
              StartParcelID := StartParcelIDEdit.Text;
              EndParcelID := EndParcelIDEdit.Text;
              BroadcastToParcelsWithSD := SelectedSDCodeLookupCombo.Text;

              TrialRun := TrialRunCheckBox.Checked;
              ReportCancelled := False;

                {Now print the report and do the SD broadcast.}

              GlblPreviewPrint := False;

                {FXX04281998-7: Need to set the assessment year before printing
                                so that it shows on the first page.}

              If (AssessmentYear in [ayThisYear, ayBothYears])
                then CurrentAssessmentYear := GlblThisYear
                else CurrentAssessmentYear := GlblNextYear;

                {CHG06171998-1: Option to load special districts from file.}

              Cancelled := False;

              If (BroadcastMethod in [bmImportFileFixedPosition, bmImportFileCommaDelimited, bmImportFileTabDelimited])
                then
                  If OpenDialog.Execute
                    then ImportFileName := OpenDialog.FileName
                    else Cancelled := True;

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

                {If they want to see it on the screen, start the preview.}

              If not Cancelled
                then
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
                          PreviewForm.ShowModal;
                        finally
                          PreviewForm.Free;
                        end

                      end
                    else ReportPrinter.Execute;

              SelectedSwisCodes.Free;

            end;  {If PrintDialog.Execute}

      end;  {If ValidSelections}

end;  {StartButtonClick}

{===================================================================}
Procedure TSDBroadcastForm.PrintHeader(Sender: TObject);

{FXX05041998-1: Print selected information in header.}

var
  TempStr : String;
  I : Integer;

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
      SetFont('Times New Roman',10);
      Bold := True;
      Home;
      PrintCenter('Special District Broadcast', (PageWidth / 2));
      Bold := False;
      CRLF;
      CRLF;

        {Selected options}

      ClearTabs;
      SetTab(0.3, pjLeft, 7.5, 0, BOXLINENONE, 0);   {hdr}

      SetFont('Times New Roman',10);
      Println(#9 + 'Assessment Year: ' + CurrentAssessmentYear);

      case BroadcastMethod of
        bmImportFileFixedPosition,
        bmImportFileCommaDelimited,
        bmImportFileTabDelimited : Println(#9 + 'Import from file: ' + ImportFileName);

        bmDeleteSD,
        bmDeleteSDByParcelList : Println(#9 + 'Delete SD: ' + TemplateSDCode);

        else Println(#9 + 'Broadcasted SD -> Code: ' + TemplateSDCode +
                     '  Calc Cd: ' + TemplateCalcCode +
                     '  Amt: ' + FormatFloat(DecimalDisplay, TemplateAmount) +
                     '  Units: ' + FormatFloat(DecimalDisplay, TemplateUnits)  +
                     '  2nd Units: ' + FormatFloat(DecimalDisplay, TemplateSecondaryUnits) +
                     '  Percent: ' + FormatFloat(DecimalDisplay, TemplatePercentage));

      end;  {case BroadcastMethod of}

      case BroadcastMethod of
        bmSwisCode :
          begin
            TempStr := '';
            For I := 0 to (SelectedSwisCodes.Count - 1) do
              TempStr := TempStr + SelectedSwisCodes[I] + ' ';

            Println(#9 + 'Broadcast To: Parcel in swis code(s): ' + TempStr);

          end;  {bmSwisCode}

        bmParcelIDRange : Println(#9 + 'Broadcast To: Start SBL: ' + StartParcelID +
                                       '   End SBL: ' + EndParcelID);
        bmPropertyClass : Println(#9 + 'Broadcast To: Property Class ' +
                                   SelectedPropertyClass);
        bmParcelsWithCertainSD : Println(#9 + 'Broadcast To: Parcels with SD code ' +
                                         BroadcastToParcelsWithSD);
      end;  {case BoradcastMethod of}

      Println('');
      Underline := False;

      case ReportSection of
        rsMain:
          begin
            ClearTabs;
            SetTab(0.3, pjLeft, 2.3, 0, BOXLINENONE, 0);   {SBL 1}
            SetTab(2.7, pjLeft, 2.3, 0, BOXLINENONE, 0);   {SBL 2}
            SetTab(5.1, pjLeft, 2.3, 0, BOXLINENONE, 0);   {SBL 3}

         end;

        rsRejects :
          begin
            Bold := True;
            Underline := True;
            Println('The following parcels in the import were not found or were roll section 9 or inactive:');
            Underline := False;
            Println('');

              {FXX02182004-1(2.07l1): Clean up reject printing.}

            ClearTabs;
            SetTab(0.3, pjCenter, 1.7, 0, BOXLINENONE, 0);   {SBL 1}
            SetTab(2.1, pjCenter, 0.5, 0, BOXLINENONE, 0);   {SD Code}
            SetTab(2.7, pjCenter, 0.4, 0, BOXLINENONE, 0);   {Calc Code}
            SetTab(3.2, pjCenter, 0.6, 0, BOXLINENONE, 0);   {Units}
            SetTab(3.9, pjCenter, 0.5, 0, BOXLINENONE, 0);   {Percent}
            SetTab(4.5, pjCenter, 1.1, 0, BOXLINENONE, 0);   {Amount}
            SetTab(5.7, pjCenter, 0.4, 0, BOXLINENONE, 0);   {Line #}
            SetTab(6.2, pjCenter, 2.2, 0, BOXLINENONE, 0);   {Reason}

            Println(#9 +
                    #9 + 'SD' +
                    #9 + 'Calc' +
                    #9 + #9 + #9 +
                    #9 + 'Line');

            ClearTabs;
            SetTab(0.3, pjCenter, 1.7, 0, BOXLINEBottom, 0);   {SBL 1}
            SetTab(2.1, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {SD Code}
            SetTab(2.7, pjCenter, 0.4, 0, BOXLINEBottom, 0);   {Calc Code}
            SetTab(3.2, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {Units}
            SetTab(3.9, pjCenter, 0.5, 0, BOXLINEBottom, 0);   {Percent}
            SetTab(4.5, pjCenter, 1.1, 0, BOXLINEBottom, 0);   {Amount}
            SetTab(5.7, pjCenter, 0.4, 0, BOXLINEBottom, 0);   {Line #}
            SetTab(6.2, pjCenter, 2.2, 0, BOXLINEBottom, 0);   {Reason}

            Println(#9 + 'Parcel ID' +
                    #9 + 'Code' +
                    #9 + 'Code' +
                    #9 + 'Units' +
                    #9 + 'Percent' +
                    #9 + 'Amount' +
                    #9 + 'Num' +
                    #9 + 'Reason');

            ClearTabs;
            SetTab(0.3, pjLeft, 1.7, 0, BOXLINENone, 0);   {SBL 1}
            SetTab(2.1, pjLeft, 0.5, 0, BOXLINENone, 0);   {SD Code}
            SetTab(2.7, pjCenter, 0.4, 0, BOXLINENone, 0);   {Calc Code}
            SetTab(3.2, pjRight, 0.6, 0, BOXLINENone, 0);   {Units}
            SetTab(3.9, pjRight, 0.5, 0, BOXLINENone, 0);   {Percent}
            SetTab(4.5, pjRight, 1.1, 0, BOXLINENone, 0);   {Amount}
            SetTab(5.7, pjRight, 0.4, 0, BOXLINENone, 0);   {Line #}
            SetTab(6.2, pjLeft, 2.2, 0, BOXLINENone, 0);   {Reason}

            Bold := False;

          end;  {rsRejects}

      end;  {case ReportSection of}

    end;  {with Sender as TBaseReport do}

end;  {PrintHeader}

{===================================================================}
Procedure PrintExistingSDs(Sender : TObject;
                           SDExistsList : TStringList);

{If any parcels already had this SD, then print it out.}

var
  I : Integer;

begin
  If (SDExistsList.Count > 0)
    then
      with Sender as TBaseReport do
        begin
          If (LinesLeft < 10)
            then NewPage;

          Println('');
          Bold := True;
          Underline := True;
          Println('The following parcels already had the broadcasted special district:');
          Bold := False;
          Underline := False;

          For I := 0 to (SDExistsList.Count - 1) do
            begin
              If (LinesLeft < 5)
                then NewPage;

                {We will print probably 3 columns across, so if this is a new
                 line, issue a carriage return for the last line.}

              If (((I + 1) MOD NumColumns) = 1)
                then Println('');

              Print(#9 + ConvertSwisSBLToDashDot(SDExistsList[I]));

            end;  {with Sender as TBaseReport do}

        end;  {with Sender as TBaseReport do}

end;  {PrintExistingSDs}

{===================================================================}
Procedure PrintNonExistingSDs(Sender : TObject;
                              lstSDDoesNotExist : TStringList);

{If any parcels already had this SD, then print it out.}

var
  I : Integer;

begin
  If _Compare(lstSDDoesNotExist.Count, 0, coGreaterThan)
    then
      with Sender as TBaseReport do
        begin
          If (LinesLeft < 10)
            then NewPage;

          Println('');
          Bold := True;
          Underline := True;
          Println('The following parcels did not have the selected special district:');
          Bold := False;
          Underline := False;

          For I := 0 to (lstSDDoesNotExist.Count - 1) do
            begin
              If (LinesLeft < 5)
                then NewPage;

                {We will print probably 3 columns across, so if this is a new
                 line, issue a carriage return for the last line.}

              If (((I + 1) MOD NumColumns) = 1)
                then Println('');

              Print(#9 + ConvertSwisSBLToDashDot(lstSDDoesNotExist[I]));

            end;  {with Sender as TBaseReport do}

        end;  {with Sender as TBaseReport do}

end;  {PrintNonExistingSDs}

{===================================================================}
Procedure TSDBroadcastForm.PrintRejects(Sender : TObject;
                                        RejectList : TList);

{If any parcels were not found in the import, print them out.}

var
  I : Integer;

begin
  If (RejectList.Count > 0)
    then
      with Sender as TBaseReport do
        begin
          ReportSection := rsRejects;
          NewPage;

            {FXX04182001-1: Give details of rejects.}

          For I := 0 to (RejectList.Count - 1) do
            with RejectPointer(RejectList[I])^ do
              begin
                If (LinesLeft < 10)
                  then NewPage;

                  {FXX02182004-1(2.07l1): Clean up reject printing.}

                Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                        #9 + SDCode +
                        #9 + CalcCode +
                        #9 + FormatFloat(DecimalDisplay_BlankZero, Units) +
                        #9 + FormatFloat(DecimalDisplay_BlankZero, Percent) +
                        #9 + FormatFloat(CurrencyDecimalDisplay_BlankZero, Amount) +
                        #9 + FormatFloat(CurrencyEditDisplay, LineNumber) +
                        #9 + Reason);

              end;  {with RejectPointer(RejectList[I])^ do}

        end;  {with Sender as TBaseReport do}

end;  {PrintRejects}

{===================================================================}
Procedure TSDBroadcastForm.AddSDCode(    Sender : TObject;
                                         ParcelTable,
                                         ParcelSDTable : TTable;
                                         AssessmentYear : String;
                                         SwisSBLKey : String;
                                         SDExists : Boolean;
                                     var NumParcelsPrinted : LongInt;
                                         SDExistsList : TStringList);

{Add a special district to this parcel and print it out.}
{FXX04281998-3: Pass in the SwisSBL since not always driven on the parcel table.}

var
  ExemptionCodes,  {Note that the exemption lists will be empty since we are not adjusting exemption roll totals.}
  ExemptionHomesteadCodes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  OrigSDAmounts, NewSDAmounts : TList;
  DummySDRec : AuditSDRecord;

begin
  BasicSTARAmount := 0;
  EnhancedSTARAmount := 0;

  If SDExists
    then SDExistsList.Add(SwisSBLKey)
    else
      begin
        If not TrialRun
          then
            begin
                {FXX04281998-6: Add roll total adjustments and audit trail
                                entries.}
                {Note that for the parcel SD and SD code tables, we use yet another
                 copy to make sure that we don't lose position in the tables we
                 are using.}

              ExemptionCodes := TStringList.Create;
              ExemptionHomesteadCodes := TStringList.Create;
              CountyExemptionAmounts := TStringList.Create;
              TownExemptionAmounts := TStringList.Create;
              SchoolExemptionAmounts := TStringList.Create;
              VillageExemptionAmounts := TStringList.Create;
              OrigSDAmounts := TList.Create;
              NewSDAmounts := TList.Create;

              FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                         [AssessmentYear, SwisSBLKey]);

              TotalSpecialDistrictsForParcel(AssessmentYear,
                                             SwisSBLKey,
                                             ParcelTable,
                                             AssessmentTable,
                                             RollTotalParcelSDTable,
                                             RollTotalSDCodeTable,
                                             ExemptionTable,
                                             ExemptionCodeTable,
                                             OrigSDAmounts);

              with ParcelSDTable do
                begin
                  Insert;

                  FieldByName('TaxRollYr').Text := AssessmentYear;
                  FieldByName('SwisSBLKey').Text := SwisSBLKey;
                  FieldByName('SDistCode').Text := TemplateSDCode;
                  FieldByName('PrimaryUnits').AsFloat := TemplateUnits;
                  FieldByName('SecondaryUnits').AsFloat := TemplateSecondaryUnits;
                  FieldByName('SDPercentage').AsFloat := TemplatePercentage;
                  FieldByName('CalcCode').Text := TemplateCalcCode;
                  FieldByName('CalcAmount').AsFloat := TemplateAmount;
                  FieldByName('DateAdded').AsDateTime := Date;

                  try
                    Post;
                  except
                    SystemSupport(001, ParcelSDTable, 'Error posting SD record: ' +
                                  ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                                  UnitName, GlblErrorDlgBox);
                  end;

            end;  {with ParcelSDTable do}

            TotalSpecialDistrictsForParcel(AssessmentYear,
                                           SwisSBLKey,
                                           ParcelTable,
                                           AssessmentTable,
                                           RollTotalParcelSDTable,
                                           RollTotalSDCodeTable,
                                           ExemptionTable,
                                           ExemptionCodeTable,
                                           NewSDAmounts);

            InsertOneSDChangeTrace(SwisSBLKey, AssessmentYear,
                                   ParcelSDTable, AuditSDChangeTable,
                                   'A',
                                   DummySDRec);  {Blank parameter}

              {Delete all the old roll totals for this parcel.
               We are only going to adjust the special district roll
               totals since these are the only totals affected by
               an SD change.}
              {FXX02101999-4: Add land value to swis and school totals.}

            AdjustRollTotalsForParcel(AssessmentYear,
                                      ParcelTable.FieldByName('SwisCode').Text,
                                      ParcelTable.FieldByName('SchoolCode').Text,
                                      ParcelTable.FieldByName('HomesteadCode').Text,
                                      ParcelTable.FieldByName('RollSection').Text,
                                      0, 0, 0, 0,
                                      ExemptionCodes,
                                      ExemptionHomesteadCodes,
                                      CountyExemptionAmounts,
                                      TownExemptionAmounts,
                                      SchoolExemptionAmounts,
                                      VillageExemptionAmounts,
                                      ParcelTable,
                                      BasicSTARAmount,
                                      EnhancedSTARAmount,
                                      OrigSDAmounts,
                                      ['D'],  {sd}
                                      'D');  {Delete the totals.}

              {Add the new roll totals for this parcel.}

            AdjustRollTotalsForParcel(AssessmentYear,
                                      ParcelTable.FieldByName('SwisCode').Text,
                                      ParcelTable.FieldByName('SchoolCode').Text,
                                      ParcelTable.FieldByName('HomesteadCode').Text,
                                      ParcelTable.FieldByName('RollSection').Text,
                                      0, 0, 0, 0,
                                      ExemptionCodes,
                                      ExemptionHomesteadCodes,
                                      CountyExemptionAmounts,
                                      TownExemptionAmounts,
                                      SchoolExemptionAmounts,
                                      VillageExemptionAmounts,
                                      ParcelTable,
                                      BasicSTARAmount,
                                      EnhancedSTARAmount,
                                      NewSDAmounts,
                                      ['D'],  {sd}
                                      'A');  {Add the totals.}

            ExemptionCodes.Free;
            ExemptionHomesteadCodes.Free;
            CountyExemptionAmounts.Free;
            TownExemptionAmounts.Free;
            SchoolExemptionAmounts.Free;
            VillageExemptionAmounts.Free;
            FreeTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));
            FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

          end;  {If not TrialRun}

          {Now print out the parcel.}

        with Sender as TBaseReport do
          begin
            If (LinesLeft < 5)
              then NewPage;

              {We will print probably 3 columns across, so if this is a new
               line, issue a carriage return for the last line.}

            If ((NumParcelsPrinted MOD NumColumns) = 1)
              then Println('');

            Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));

          end;  {with Sender as TBaseReport do}

        NumParcelsPrinted := NumParcelsPrinted + 1;

      end;  {else of If SDExists}

end;  {AddSDCode}

{===================================================================}
Procedure TSDBroadcastForm.UpdateSDCode(    Sender : TObject;
                                            ParcelTable,
                                            ParcelSDTable : TTable;
                                            AssessmentYear : String;
                                            SwisSBLKey : String;
                                            SDExists : Boolean;
                                        var NumParcelsPrinted : LongInt;
                                            lstSDDoesNotExist : TStringList);

{Add a special district to this parcel and print it out.}
{FXX04281998-3: Pass in the SwisSBL since not always driven on the parcel table.}

var
  ExemptionCodes,  {Note that the exemption lists will be empty since we are not adjusting exemption roll totals.}
  ExemptionHomesteadCodes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  OrigSDAmounts, NewSDAmounts : TList;
  DummySDRec : AuditSDRecord;

begin
  BasicSTARAmount := 0;
  EnhancedSTARAmount := 0;

  If SDExists
    then
      begin
        If not TrialRun
          then
            begin
                {Note that for the parcel SD and SD code tables, we use yet another
                 copy to make sure that we don't lose position in the tables we
                 are using.}

              ExemptionCodes := TStringList.Create;
              ExemptionHomesteadCodes := TStringList.Create;
              CountyExemptionAmounts := TStringList.Create;
              TownExemptionAmounts := TStringList.Create;
              SchoolExemptionAmounts := TStringList.Create;
              VillageExemptionAmounts := TStringList.Create;
              OrigSDAmounts := TList.Create;
              NewSDAmounts := TList.Create;

              FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                         [AssessmentYear, SwisSBLKey]);

              TotalSpecialDistrictsForParcel(AssessmentYear,
                                             SwisSBLKey,
                                             ParcelTable,
                                             AssessmentTable,
                                             RollTotalParcelSDTable,
                                             RollTotalSDCodeTable,
                                             ExemptionTable,
                                             ExemptionCodeTable,
                                             OrigSDAmounts);

              with ParcelSDTable do
                begin
                  Edit;

                  If _Compare(TemplateUnits, 0, coGreaterThan)
                    then FieldByName('PrimaryUnits').AsFloat := TemplateUnits;
                  If _Compare(TemplateSecondaryUnits, 0, coGreaterThan)
                    then FieldByName('SecondaryUnits').AsFloat := TemplateSecondaryUnits;
                  If _Compare(TemplatePercentage, 0, coGreaterThan)
                    then FieldByName('SDPercentage').AsFloat := TemplatePercentage;
                  If _Compare(TemplateCalcCode, coNotBlank)
                    then FieldByName('CalcCode').Text := TemplateCalcCode;
                  If _Compare(TemplateAmount, 0, coGreaterThan)
                    then FieldByName('CalcAmount').AsFloat := TemplateAmount;

                  try
                    Post;
                  except
                    SystemSupport(001, ParcelSDTable, 'Error posting SD record: ' +
                                  ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                                  UnitName, GlblErrorDlgBox);
                  end;

            end;  {with ParcelSDTable do}

            TotalSpecialDistrictsForParcel(AssessmentYear,
                                           SwisSBLKey,
                                           ParcelTable,
                                           AssessmentTable,
                                           RollTotalParcelSDTable,
                                           RollTotalSDCodeTable,
                                           ExemptionTable,
                                           ExemptionCodeTable,
                                           NewSDAmounts);

            InsertOneSDChangeTrace(SwisSBLKey, AssessmentYear,
                                   ParcelSDTable, AuditSDChangeTable,
                                   'C',
                                   DummySDRec);  {Blank parameter}

              {Delete all the old roll totals for this parcel.
               We are only going to adjust the special district roll
               totals since these are the only totals affected by
               an SD change.}
              {FXX02101999-4: Add land value to swis and school totals.}

            AdjustRollTotalsForParcel(AssessmentYear,
                                      ParcelTable.FieldByName('SwisCode').Text,
                                      ParcelTable.FieldByName('SchoolCode').Text,
                                      ParcelTable.FieldByName('HomesteadCode').Text,
                                      ParcelTable.FieldByName('RollSection').Text,
                                      0, 0, 0, 0,
                                      ExemptionCodes,
                                      ExemptionHomesteadCodes,
                                      CountyExemptionAmounts,
                                      TownExemptionAmounts,
                                      SchoolExemptionAmounts,
                                      VillageExemptionAmounts,
                                      ParcelTable,
                                      BasicSTARAmount,
                                      EnhancedSTARAmount,
                                      OrigSDAmounts,
                                      ['D'],  {sd}
                                      'D');  {Delete the totals.}

              {Add the new roll totals for this parcel.}

            AdjustRollTotalsForParcel(AssessmentYear,
                                      ParcelTable.FieldByName('SwisCode').Text,
                                      ParcelTable.FieldByName('SchoolCode').Text,
                                      ParcelTable.FieldByName('HomesteadCode').Text,
                                      ParcelTable.FieldByName('RollSection').Text,
                                      0, 0, 0, 0,
                                      ExemptionCodes,
                                      ExemptionHomesteadCodes,
                                      CountyExemptionAmounts,
                                      TownExemptionAmounts,
                                      SchoolExemptionAmounts,
                                      VillageExemptionAmounts,
                                      ParcelTable,
                                      BasicSTARAmount,
                                      EnhancedSTARAmount,
                                      NewSDAmounts,
                                      ['D'],  {sd}
                                      'A');  {Add the totals.}

            ExemptionCodes.Free;
            ExemptionHomesteadCodes.Free;
            CountyExemptionAmounts.Free;
            TownExemptionAmounts.Free;
            SchoolExemptionAmounts.Free;
            VillageExemptionAmounts.Free;
            FreeTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));
            FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

          end;  {If not TrialRun}

          {Now print out the parcel.}

        with Sender as TBaseReport do
          begin
            If (LinesLeft < 5)
              then NewPage;

              {We will print probably 3 columns across, so if this is a new
               line, issue a carriage return for the last line.}

            If ((NumParcelsPrinted MOD NumColumns) = 1)
              then Println('');

            Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));

          end;  {with Sender as TBaseReport do}

        NumParcelsPrinted := NumParcelsPrinted + 1;

      end
    else lstSDDoesNotExist.Add(SwisSBLKey);

end;  {UpdateSDCode}

{===================================================================}
Procedure TSDBroadcastForm.AddSDCodesBySwisCode(    Sender : TObject;
                                                    ParcelTable,
                                                    ParcelSDTable : TTable;
                                                    AssessmentYear : String;
                                                var NumParcelsPrinted : LongInt);

{Add the template special district to each parcel in the selected swis codes.}

var
  I : Integer;
  SwisCode : String;
  SDExists, Done, FirstTimeThrough : Boolean;
  SDExistsList : TStringList;
  SwisSBLKey : String;
  NumParcelsThisSwisCode : LongInt;

begin
  SDExistsList := TStringList.Create;

  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

  For I := 0 to (SelectedSwisCodes.Count - 1) do
    begin
      NumParcelsThisSwisCode := 0;
      SwisCode := SelectedSwisCodes[I];
      ParcelTable.CancelRange;
      SetRangeOld(ParcelTable,
                  ['TaxRollYr', 'SwisCode', 'Section',
                   'Subsection', 'Block', 'Lot', 'Sublot',
                   'Suffix'],
                  [AssessmentYear, SwisCode, '   ', '', '', '', '', ''],
                  [AssessmentYear, SwisCode, 'ZZZ', '', '', '', '', '']);

        {Don't add an SD code to an inactive parcel.}

      FirstTimeThrough := True;
      Done := False;

      ParcelTable.First;

      repeat
        If FirstTimeThrough
          then FirstTimeThrough := False
          else ParcelTable.Next;

        If ParcelTable.EOF
          then Done := True;

        ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
        Application.ProcessMessages;

          {FXX04281998-4: Don't copy to roll section 9.}

        If ((not (Done or ReportCancelled)) and
            (ParcelTable.FieldByName('RollSection').Text <> '9') and
            (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
          then
            begin
              SwisSBLKey := ExtractSSKey(ParcelTable);

              If TrialRun
                then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
                else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

                 {FXX04281998-2: Use the SD lookup table to see if the SD
                                 already exists.}

              SDExists := FindKeyOld(ParcelSDLookupTable,
                                     ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                                     [AssessmentYear, SwisSBLKey, TemplateSDCode]);

              AddSDCode(Sender, ParcelTable, ParcelSDTable, AssessmentYear,
                        SwisSBLKey, SDExists, NumParcelsPrinted, SDExistsList);

              NumParcelsThisSwisCode := NumParcelsThisSwisCode + 1;

            end;  {If ((not Done) and ...}

        ReportCancelled := ProgressDialog.Cancelled;

      until (Done or ReportCancelled);

      with Sender as TBaseReport do
        begin
          Println('');
          Println('');
          Bold := True;
          Println(#9 + 'Special Districts Added for ' + SwisCode + ' = ' +
                  IntToStr(NumParcelsThisSwisCode));
          Println('');
          Bold := False;

        end;  {with Sender as TBaseReport do}

    end;  {For I := 0 to (SelectedSwisCodes.Count - 1) do}

    {If any parcels already had this SD, then print it out.}

  PrintExistingSDs(Sender, SDExistsList);

  SDExistsList.Free;

  ProgressDialog.Finish;

end;  {AddSDCodesBySwisCode}

{===================================================================}
Procedure TSDBroadcastForm.AddSDCodesByParcelID(    Sender : TObject;
                                                    ParcelTable,
                                                    ParcelSDTable : TTable;
                                                    AssessmentYear : String;
                                                var NumParcelsPrinted : LongInt);

{Add the template special district to each parcel in the selected parcel ID
 range.}

var
  ValidEntry, SDExists, Done, FirstTimeThrough : Boolean;
  SDExistsList : TStringList;
  EndSwisSBLKey, CurrentSwisSBLKey : String;
  StartSBLRec : SBLRecord;

begin
  SDExistsList := TStringList.Create;

  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

    {FXX05281999-1: Start parcel ID was looking at the end parcel ID.}

  StartSBLRec := ExtractSwisSBLFromSwisSBLKey(ConvertSwisDashDotToSwisSBL(StartParcelID,
                                              SwisCodeTable, ValidEntry));
  EndSwisSBLKey := ConvertSwisDashDotToSwisSBL(EndParcelID,
                                               SwisCodeTable, ValidEntry);

  with StartSBLRec do
    FindNearestOld(ParcelTable,
                   ['TaxRollYr', 'SwisCode', 'Section',
                    'Subsection', 'Block', 'Lot', 'Sublot',
                    'Suffix'],
                   [AssessmentYear, SwisCode, Section, Subsection,
                    Block, Lot, Sublot, Suffix]);

    {Don't add an SD code to an inactive parcel.}

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    CurrentSwisSBLKey := ExtractSSKey(ParcelTable);

    If (ParcelTable.EOF or
        (CurrentSwisSBLKey > EndSwisSBLKey))
      then Done := True;

      {FXX04281998-4: Don't copy to roll section 9.}

    If ((not (Done or ReportCancelled)) and
        (ParcelTable.FieldByName('RollSection').Text <> '9') and
        (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
      then
        begin
          If TrialRun
            then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
            else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

                 {FXX04281998-2: Use the SD lookup table to see if the SD
                                 already exists.}

          SDExists := FindKeyOld(ParcelSDLookupTable,
                                 ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                                 [AssessmentYear, CurrentSwisSBLKey,
                                  TemplateSDCode]);

          AddSDCode(Sender, ParcelTable, ParcelSDTable, AssessmentYear,
                    CurrentSwisSBLKey, SDExists, NumParcelsPrinted, SDExistsList);

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(CurrentSwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

    {If any parcels already had this SD, then print it out.}

  PrintExistingSDs(Sender, SDExistsList);

  SDExistsList.Free;

  ProgressDialog.Finish;

end;  {AddSDCodesByParcelID}

{===================================================================}
Procedure TSDBroadcastForm.AddSDCodesByPropertyClass(    Sender : TObject;
                                                         ParcelTable,
                                                         ParcelSDTable : TTable;
                                                         AssessmentYear : String;
                                                     var NumParcelsPrinted : LongInt);

{Add the template special district to each parcel with the specified
 property class.}

var
  SDExists, Done, FirstTimeThrough : Boolean;
  SDExistsList : TStringList;
  SwisSBLKey : String;

begin
  SDExistsList := TStringList.Create;

  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

  ParcelTable.First;

    {Don't add an SD code to an inactive parcel.}

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    SwisSBLKey := ExtractSSKey(ParcelTable);

    If ParcelTable.EOF
      then Done := True;

      {FXX04281998-4: Don't copy to roll section 9.}

    If ((not (Done or ReportCancelled)) and
        (ParcelTable.FieldByName('RollSection').Text <> '9') and
        (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
        (ParcelTable.FieldByName('PropertyClassCode').Text = SelectedPropertyClass))
      then
        begin
          If TrialRun
            then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
            else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

                 {FXX04281998-2: Use the SD lookup table to see if the SD
                                 already exists.}

          SDExists := FindKeyOld(ParcelSDLookupTable,
                                 ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                                 [AssessmentYear, SwisSBLKey,
                                  TemplateSDCode]);

          AddSDCode(Sender, ParcelTable, ParcelSDTable, AssessmentYear,
                    SwisSBLKey, SDExists, NumParcelsPrinted, SDExistsList);

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

    {If any parcels already had this SD, then print it out.}

  PrintExistingSDs(Sender, SDExistsList);

  SDExistsList.Free;

  ProgressDialog.Finish;

end;  {AddSDCodesByPropertyClass}

{===================================================================}
Procedure TSDBroadcastForm.AddSDCodesByPreviousSD(    Sender : TObject;
                                                      ParcelTable,
                                                      ParcelSDTable,
                                                      ParcelSDLookupTable : TTable;
                                                      AssessmentYear : String;
                                                  var NumParcelsPrinted : LongInt);

{Add the template special district to each parcel which already has the specified
 SD.}

var
  SDExists, Done, FirstTimeThrough : Boolean;
  SDExistsList : TStringList;
  SwisSBLKey : String;
  SBLRec : SBLRecord;

begin
  SDExistsList := TStringList.Create;

  ProgressDialog.Start(GetRecordCount(ParcelSDTable), True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

  ParcelSDTable.First;

    {Don't add an SD code to an inactive parcel.}

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelSDTable.Next;

    SwisSBLKey := ParcelSDTable.FieldByName('SwisSBLKey').Text;

    If ParcelSDTable.EOF
      then Done := True;

    If ((not Done) and
        (ParcelSDTable.FieldByName('SDistCode').Text = BroadcastToParcelsWithSD))
      then
        begin
            {Get the parcel for this SD record to see if active.}

          SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

            {FXX10111999-2: Missing suffix in lookup.}

          with SBLRec do
            FindKeyOld(ParcelTable,
                       ['TaxRollYr', 'SwisCode', 'Section',
                        'Subsection', 'Block', 'Lot', 'Sublot',
                        'Suffix'],
                       [AssessmentYear, SwisCode, Section, Subsection,
                        Block, Lot, Sublot, Suffix]);

          {FXX04281998-4: Don't copy to roll section 9.}

          If ((ParcelTable.FieldByName('RollSection').Text <> '9') and
              (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
            then
              begin
                If TrialRun
                  then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
                  else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

                 {FXX04281998-2: Use the SD lookup table to see if the SD
                                 already exists.}

                SDExists := FindKeyOld(ParcelSDLookupTable,
                                       ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                                       [AssessmentYear, SwisSBLKey,
                                        TemplateSDCode]);

                  {FXX04281998-1: For inserting the new special districts
                                  when searching by existing SD, must use diff
                                  table than search table so position in file
                                  does not get messed up.}

                AddSDCode(Sender, ParcelTable, ParcelSDLookupTable, AssessmentYear,
                          SwisSBLKey, SDExists, NumParcelsPrinted, SDExistsList);

              end;  {If (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag)}

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

    {If any parcels already had this SD, then print it out.}

  PrintExistingSDs(Sender, SDExistsList);

  SDExistsList.Free;

  ProgressDialog.Finish;

end;  {AddSDCodesByPreviousSD}

{===================================================================}
Procedure TSDBroadcastForm.AddSDCodesByImportFile(    Sender : TObject;
                                                      ParcelTable,
                                                      ParcelSDTable : TTable;
                                                      AssessmentYear : String;
                                                      iBroadcastMethod : Integer;
                                                  var NumParcelsPrinted : LongInt);

{Add the special districts in an extract file.}
{CHG06171998-1: Add the option to import from a file.}

var
  SDExists, Found, Done, ValidEntry : Boolean;
  TrialRunSDsProcessed, SDExistsList : TStringList;
  RejectList : TList;
  sSwisCode, sPrintKey, sTemp, sOriginalSwisSBLKey,
  SwisSBLKey, ImportLine, NewSwisSBLKey : String;
  SDImportFile : TextFile;
  NumImported, NumFound, CurrentLine : LongInt;
  TotalAmount, TotalUnits, TotalSecondaryUnits : Extended;
  RejectPtr : RejectPointer;
  FieldList : TStringList;

begin
  FieldList := TStringList.Create;
  CurrentLine := 0;
  NumImported := 0;
  NumFound := 0;
  TotalAmount := 0;
  TotalUnits := 0;
  TotalSecondaryUnits := 0;
  Done := False;
  SDExistsList := TStringList.Create;
  TrialRunSDsProcessed := TStringList.Create;
  RejectList := TList.Create;

  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  AssignFile(SDImportFile, ImportFileName);
  Reset(SDImportFile);

  repeat
    Readln(SDImportFile, ImportLine);

    If EOF(SDImportFile)
      then Done := True;

    If TrialRun
      then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumFound)
      else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumImported);

      {Process one line.}

     {FXX04281998-4: Don't copy to roll section 9.}
     {CHG03242005-1(2.8.3.14): Add option to import special districts by comma delimited file.}

   case iBroadcastMethod of
     bmImportFileFixedPosition :
       begin
         SwisSBLKey := Take(26, Copy(ImportLine, 4, 26));
         sOriginalSwisSBLKey := SwisSBLKey;

         TemplateSDCode := Copy(ImportLine, 48, 5);
         TemplateCalcCode := Copy(ImportLine, 65, 1);

         sTemp := Copy(ImportLine, 66, 13);
         If _Compare(sTemp, coNotBlank)
         then
           try
             TemplateAmount := StrToFloat(sTemp);
           except
             TemplateAmount := 0;
           end;

         sTemp := Copy(ImportLine, 53, 7);
         If _Compare(sTemp, coNotBlank)
         then
         try
           TemplateUnits := StrToFloat(sTemp) / 100;
         except
           TemplateUnits := 0;
         end;

         sTemp := Copy(ImportLine, 60, 5);
         If _Compare(sTemp, coNotBlank)
         then
         try
           TemplatePercentage := StrToFloat(sTemp) / 100;
         except
           TemplatePercentage := 0;
         end;

       end;  {bmImportFileFixedPosition}

     bmImportFileCommaDelimited :
       begin
         ParseCommaDelimitedStringIntoFields(ImportLine, FieldList, True);

         SwisSBLKey := FieldList[0];
         sOriginalSwisSBLKey := FieldList[0];

         If (_Compare(SwisSBLKey[3], '/', coNotEqual) and
             _Compare(SwisCodeTable.RecordCount, 1, coEqual))
         then SwisSBLKey := SwisCodeTable.FieldByName('SwisCode').AsString + SwisSBLKey;

         If _Compare(SwisSBLKey, '.', coContains)
         then
           begin
             If _Compare(SwisSBLKey[3], '/', coNotEqual)
             then SwisSBLKey := Copy(SwisSBLKey, 5, 2) + '/' + Copy(SwisSBLKey, 7, 20);

             SwisSBLKey := ConvertSwisDashDotToSwisSBL(SwisSBLKey, SwisCodeTable, ValidEntry);

           end;

         TemplateSDCode := FieldList[1];
         TemplateCalcCode := FieldList[2];

         try
           TemplateAmount := StrToFloat(FieldList[3]);
         except
           TemplateAmount := 0;
         end;

         try
           TemplateUnits := StrToFloat(FieldList[4]);
         except
           TemplateUnits := 0;
         end;

         try
           TemplateSecondaryUnits := StrToFloat(FieldList[5]);
         except
           TemplateSecondaryUnits := 0;
         end;

         try
           TemplatePercentage := StrToFloat(FieldList[6]);
         except
           TemplatePercentage := 0;
         end;

       end;  {bmImportFileCommaDelimited}

     bmImportFileTabDelimited :
       begin
         ParseTabDelimitedStringIntoFields(ImportLine, FieldList, True);

         If _Compare(FieldList.Count, 4, coGreaterThanOrEqual)
           then
             begin
               sSwisCode:= FieldList[0];
               sPrintKey := FieldList[1];

               SwisSBLKey := ConvertSwisDashDotToSwisSBL(Copy(sSwisCode, 5, 2) + '/' + sPrintKey,
                                                         SwisCodeTable, ValidEntry);

               sOriginalSwisSBLKey := SwisSBLKey;

               TemplateSDCode := FieldList[2];

               If _Compare(FieldList.Count, 5, coEqual)
               then TemplateCalcCode := FieldList[4];

               try
                 TemplateAmount := StrToFloat(FieldList[3]);
               except
                 TemplateAmount := 0;
               end;

             end
           else SwisSBLKey := '';

       end;  {bmImportFileTabDelimited}

   end;  {case iBroadcastMethod of}

   Found := _Locate(ParcelTable, [AssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey]);

     {Try an alternate method for Glen Cove.}

   If not Found
     then
       begin
         NewSwisSBLKey := Copy(SwisSBLKey, 1, 9) +
                          ShiftRightAddZeroes(Copy(SwisSBLKey, 14, 3), 3) +
                          '    ' +
                          Copy(SwisSBLKey, 17, 3) +
                          StringReplace(Copy(SwisSBLKey, 20, 3), '0', ' ', [rfReplaceAll]);

         Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);

         If not Found
           then
             begin
               NewSwisSBLKey := Copy(SwisSBLKey, 1, 20);

               Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);

             end;  {If not Found}

         try
           If ((not Found) and
               (SwisSBLKey[16] in Letters))
             then
               begin
                 NewSwisSBLKey := Copy(SwisSBLKey, 1, 9) +
                                  ShiftRightAddBlanks(Take(3, Copy(SwisSBLKey, 16, 1))) +
                                  '    ' +
                                  Copy(SwisSBLKey, 17, 3) +
                                  StringReplace(Copy(SwisSBLKey, 20, 3), '0', ' ', [rfReplaceAll]);

                 Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);
               end;

         except
         end;

         try
           If ((not Found) and
               (SwisSBLKey[12] in Letters))
             then
               begin
                 NewSwisSBLKey := Copy(SwisSBLKey, 1, 9) +
                                  StringReplace(Copy(SwisSBLKey, 10, 3), '0', ' ', [rfReplaceAll]) +
                                  Copy(SwisSBLKey, 13, 7);
                 NewSwisSBLKey[15] := '0';

                 Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);
               end;

         except
         end;

         try
           If ((not Found) and
               _Compare(SwisSBLKey[16], '0', coEqual))
             then
               begin
                 NewSwisSBLKey := Copy(SwisSBLKey, 1, 12) +
                                  '    ' +
                                  Copy(SwisSBLKey, 16, 3) +
                                  StringReplace(Copy(SwisSBLKey, 20, 3), '0', ' ', [rfReplaceAll]);

                 Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);
               end;

         except
         end;

         try
           If ((not Found) and
               (SwisSBLKey[10] in Letters))
             then
               begin
                 NewSwisSBLKey := Copy(SwisSBLKey, 1, 9) +
                                  '  ' +
                                  Copy(SwisSBLKey, 10, 1) +
                                  '   ' +
                                  Copy(SwisSBLKey, 12, 4) +
                                  StringReplace(Copy(SwisSBLKey, 20, 3), '0', ' ', [rfReplaceAll]);

                 Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);

                 If not Found
                   then
                     begin
                       NewSwisSBLKey[15] := '0';
                       Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);
                     end;

               end;

         except
         end;

         try
           If not Found
             then
               begin
                 NewSwisSBLKey := Copy(SwisSBLKey, 1, 19) +
                                  StringReplace(Copy(SwisSBLKey, 20, 3), '0', ' ', [rfReplaceAll]);
                 NewSwisSBLKey[15] := '0';

                 Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);
               end;

         except
         end;

         try
           If not Found
             then
               begin
                 NewSwisSBLKey := Copy(SwisSBLKey, 1, 9) +
                                  ShiftRightAddZeroes(Copy(SwisSBLKey, 14, 3), 3) +
                                  '    ' +
                                  Copy(SwisSBLKey, 20, 3);

                 Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);
               end;

         except
         end;

         try
           If ((not Found) and
               (SwisSBLKey[12] in Letters))
             then
               begin
                 NewSwisSBLKey := Copy(SwisSBLKey, 1, 9) +
                                  StringReplace(Copy(SwisSBLKey, 10, 3), '0', ' ', [rfReplaceAll]) +
                                  '    ' +
                                  Copy(SwisSBLKey, 13, 3) +
                                  '   ' +
                                  Copy(SwisSBLKey, 16, 4);

                 Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);
               end;

         except
         end;

         try
           If ((not Found) and
               (SwisSBLKey[16] in Letters))
             then
               begin
                 NewSwisSBLKey := Copy(SwisSBLKey, 1, 9) +
                                  ShiftRightAddBlanks(Take(3, Copy(SwisSBLKey, 16, 1))) +
                                  '    0' +
                                  Copy(SwisSBLKey, 17, 2) +
                                  StringReplace(Copy(SwisSBLKey, 20, 3), '0', ' ', [rfReplaceAll]);

                 Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);
               end;

         except
         end;

         try
           If ((not Found) and
               (SwisSBLKey[10] in Letters))
             then
               begin
                 NewSwisSBLKey := Copy(SwisSBLKey, 1, 9) +
                                  '  ' +
                                  Copy(SwisSBLKey, 10, 1) +
                                  '    ' +
                                  Copy(SwisSBLKey, 13, 3) +
                                  StringReplace(Copy(SwisSBLKey, 20, 3), '0', ' ', [rfReplaceAll]);

                 Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);

                 If not Found
                   then
                     begin
                       NewSwisSBLKey[15] := '0';
                       Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);
                     end;

               end;

         except
         end;

         try
           If ((not Found) and
               (SwisSBLKey[10] in Letters))
             then
               begin
                 NewSwisSBLKey := Copy(SwisSBLKey, 1, 9) +
                                  '  ' +
                                  Copy(SwisSBLKey, 10, 1) +
                                  '    ' +
                                  Copy(SwisSBLKey, 13, 3) +
                                  '   ' +
                                  Copy(SwisSBLKey, 16, 4);

                 Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);

                 If not Found
                   then
                     begin
                       NewSwisSBLKey[15] := '0';
                       Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);
                     end;

               end;

         except
         end;

         If not Found
           then
             begin
               NewSwisSBLKey := Copy(SwisSBLKey, 1, 12) +
                                '    ' +
                                Copy(SwisSBLKey, 16, 3);

               Found := _Locate(ParcelTable, [AssessmentYear, NewSwisSBLKey], '', [loParseSwisSBLKey]);

             end;  {If not Found}

         If not Found
           then
             begin
                 {Try account number.}

               ParcelTable.IndexName := 'ByAccountNo';

               Found := _Locate(ParcelTable, [sOriginalSwisSBLKey], '', []);
               NewSwisSBLKey := ExtractSSKey(ParcelTable);

             end;  {If not Found}

         If Found
           then SwisSBLKey := NewSwisSBLKey;

         ParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

       end;  {If not Found}

   Application.ProcessMessages;

   If TrialRun
     then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumImported)
     else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumFound);

     {FXX07191999-9: Import file did not broadcast last parcel in file.}

   If ((not ReportCancelled) and
       Found and
       (ParcelTable.FieldByName('RollSection').Text <> '9') and
       (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
     then
       begin
         NumFound := NumFound + 1;

          {FXX04281998-2: Use the SD lookup table to see if the SD
                          already exists.}

         SDExists := FindKeyOld(ParcelSDLookupTable,
                                ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                                [AssessmentYear, SwisSBLKey,
                                 TemplateSDCode]);

            {FXX11052001-1: On load by file, check for dups on trial run.}

          If TrialRun
            then
              begin
                SDExists := (TrialRunSDsProcessed.IndexOf(SwisSBLKey) > -1);

                If not SDExists
                  then TrialRunSDsProcessed.Add(SwisSBLKey);

              end;  {If TrialRun}

           {FXX04281998-1: For inserting the new special districts
                           when searching by existing SD, must use diff
                           table than search table so position in file
                           does not get messed up.}

         AddSDCode(Sender, ParcelTable, ParcelSDLookupTable, AssessmentYear,
                   SwisSBLKey, SDExists, NumImported, SDExistsList);

         If not SDExists
           then
             begin
               TotalAmount := TotalAmount + TemplateAmount;
               TotalUnits := TotalUnits + TemplateUnits;
               TotalSecondaryUnits := TotalSecondaryUnits + TemplateSecondaryUnits;
             end;

       end;  {If ((not (Done or ReportCancelled)) and}

    Application.ProcessMessages;
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    ReportCancelled := ProgressDialog.Cancelled;
    CurrentLine := CurrentLine + 1;

     {FXX07191999-10: Include parcel in reject list if rs 9 or inactive.}
     {FXX04182001-1: Give details of rejects.}

    If ((not Found) or
        (ParcelTable.FieldByName('RollSection').Text = '9') or
        (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag))
      then
        begin
          New(RejectPtr);

            {FXX05022002-1: In the case of not found, we can not get
                            the parcel ID from the parcel table since it
                            points to the last valid parcel.}

          If Found
            then RejectPtr^.SwisSBLKey := ExtractSSKey(ParcelTable)
            else RejectPtr^.SwisSBLKey := SwisSBLKey;

          with RejectPtr^ do
            begin
              SDCode := TemplateSDCode;
              CalcCode := TemplateCalcCode;
              Units := TemplateUnits;
              SecondaryUnits := TemplateSecondaryUnits;
              Percent := TemplatePercentage;
              Amount := TemplateAmount;

              If not Found
                then Reason := 'Parcel ID not found.';

              If (ParcelTable.FieldByName('RollSection').Text = '9')
                then Reason := 'Parcel is roll section 9.';

              If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
                then Reason := 'Parcel is inactive.';

                {FXX02182004-1(2.07l1): Clean up reject printing.}

              LineNumber := CurrentLine;

            end;  {with RejectPtr^ do}

          RejectList.Add(RejectPtr);

        end;  {If ((not Found) or ...}

  until (Done or ReportCancelled);

  CloseFile(SDImportFile);

  with Sender as TBaseReport do
    begin
      Println('');
      Println('');
      Bold := True;
      Println(#9 + 'Special Districts Imported = ' +
              IntToStr(NumImported));
      Println(#9 + 'Total SD Amount Imported = $' +
              FormatFloat(DecimalDisplay, TotalAmount));
      Println(#9 + 'Total SD Units Imported = ' +
              FormatFloat(DecimalDisplay, TotalUnits));
      Println(#9 + 'Total SD 2nd Units Imported = ' +
              FormatFloat(DecimalDisplay, TotalSecondaryUnits));
      Println('');
      Bold := False;

    end;  {with Sender as TBaseReport do}

    {If any parcels already had this SD, then print it out.}

  PrintExistingSDs(Sender, SDExistsList);

    {Now print any rejects.}

  PrintRejects(Sender, RejectList);

  SDExistsList.Free;
  FreeTList(RejectList, SizeOf(RejectRecord));

  ProgressDialog.Finish;

  NumParcelsPrinted := NumImported;
  FieldList.Free;

end;  {AddSDCodesByImportFile}

{===================================================================}
Procedure TSDBroadcastForm.AddSDCodesByParcelList(    Sender : TObject;
                                                      ParcelTable,
                                                      ParcelSDTable : TTable;
                                                      AssessmentYear : String;
                                                  var NumParcelsPrinted : LongInt);

{Add the template SD to each parcel in the parcel list.}
{CHG06101999-1: Add ability to broadcast by list.}

var
  Index : Integer;
  SDExists, Done, FirstTimeThrough : Boolean;
  SDExistsList : TStringList;
  SwisSBLKey : String;
  SBLRec : SBLRecord;

begin
  Index := 1;
  SDExistsList := TStringList.Create;

  ParcelListDialog.GetParcel(ParcelTable, Index);

  ProgressDialog.Start(ParcelListDialog.NumItems, True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

    {Don't add an SD code to an inactive parcel.}

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        begin
          Index := Index + 1;
          ParcelListDialog.GetParcel(ParcelTable, Index);
        end;

    If (Index > ParcelListDialog.NumItems)
      then Done := True;

    SwisSBLKey := ExtractSSKey(ParcelTable);

    SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

    with SBLRec do
      FindKeyOld(ParcelTable,
                 ['TaxRollYr', 'SwisCode', 'Section',
                  'Subsection', 'Block', 'Lot', 'Sublot',
                  'Suffix'],
                 [AssessmentYear, SwisCode, Section, Subsection, Block,
                  Lot, Sublot, Suffix]);

      {FXX04281998-4: Don't copy to roll section 9.}

    If ((not (Done or ReportCancelled)) and
        (ParcelTable.FieldByName('RollSection').Text <> '9') and
        (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag))
      then
        begin
                 {FXX04281998-2: Use the SD lookup table to see if the SD
                                 already SDists.}

          SDExists := FindKeyOld(ParcelSDLookupTable,
                                 ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
                                 [AssessmentYear, SwisSBLKey,
                                  TemplateSDCode]);

          AddSDCode(Sender, ParcelTable, ParcelSDLookupTable, AssessmentYear,
                    SwisSBLKey, SDExists, NumParcelsPrinted,
                    SDExistsList);

          If TrialRun
            then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
            else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

    {If any parcels already had this SD, then print it out.}

  PrintExistingSDs(Sender, SDExistsList);

  SDExistsList.Free;

  ProgressDialog.Finish;

end;  {AddSDCodesByParcelList}

{===================================================================}
Procedure TSDBroadcastForm.UpdateSDCodesByParcelList(    Sender : TObject;
                                                         ParcelTable,
                                                         ParcelSDTable : TTable;
                                                         AssessmentYear : String;
                                                     var NumParcelsPrinted : LongInt);

{Update the template SD to each parcel in the parcel list.}

var
  Index : Integer;
  SDExists, Done, FirstTimeThrough : Boolean;
  lstSDDoesNotExist : TStringList;
  SwisSBLKey : String;

begin
  Index := 0;
  lstSDDoesNotExist := TStringList.Create;

  ParcelListDialog.GetParcel(ParcelTable, Index);

  ProgressDialog.Start(ParcelListDialog.NumItems, True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Broadcasted = ' + IntToStr(NumParcelsPrinted);

    {Don't add an SD code to an inactive parcel.}

  FirstTimeThrough := True;
  Done := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        begin
          Index := Index + 1;
          ParcelListDialog.GetParcel(ParcelTable, Index);
        end;

    If (Index > ParcelListDialog.NumItems)
      then Done := True;

    SwisSBLKey := ExtractSSKey(ParcelTable);

    _Locate(ParcelTable, [AssessmentYear, SwisSBLKey], '', [loParseSwisSBLKey]);

      {FXX04281998-4: Don't copy to roll section 9.}

    If ((not (Done or ReportCancelled)) and
        _Compare(ParcelTable.FieldByName('RollSection').AsString, '9', coNotEqual) and
        _Compare(ParcelTable.FieldByName('ActiveFlag').AsString, InactiveParcelFlag, coNotEqual))
      then
        begin
          SDExists := _Locate(ParcelSDLookupTable,
                              [AssessmentYear, SwisSBLKey, TemplateSDCode], '', []);

          UpdateSDCode(Sender, ParcelTable, ParcelSDLookupTable, AssessmentYear,
                       SwisSBLKey, SDExists, NumParcelsPrinted,
                       lstSDDoesNotExist);

          If TrialRun
            then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
            else ProgressDialog.UserLabelCaption := 'Num Updated = ' + IntToStr(NumParcelsPrinted);

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

    {If any parcels didn't hvae this SD, then print it out.}

  PrintNonExistingSDs(Sender, lstSDDoesNotExist);

  lstSDDoesNotExist.Free;

  ProgressDialog.Finish;

end;  {UpdateSDCodesByParcelList}

{===================================================================}
Procedure TSDBroadcastForm.DeleteSDCode(    Sender : TObject;
                                            ParcelTable,
                                            ParcelSDTable : TTable;
                                            AssessmentYear : String;
                                            bDeleteByList : Boolean;
                                        var NumParcelsPrinted : LongInt);

{Delete the SD code.}

var
  Done, FirstTimeThrough, bSDFound : Boolean;
  SwisSBLKey : String;
  ExemptionCodes,  {Note that the exemption lists will be empty since we are not adjusting exemption roll totals.}
  ExemptionHomesteadCodes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  OrigSDAmounts, NewSDAmounts : TList;
  DummySDRec : AuditSDRecord;
  SBLRec : SBLRecord;
  Index : Integer;
  tbTempParcelSpecialDistricts : TTable;

begin
  Index := 1;
  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

  If TrialRun
    then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
    else ProgressDialog.UserLabelCaption := 'Num Deleted = ' + IntToStr(NumParcelsPrinted);

  If bDeleteByList
    then
      begin
        ParcelListDialog.GetParcel(ParcelTable, Index);
        SwisSBLKey := ExtractSSKey(ParcelTable);
        bSDFound := _Locate(ParcelSDLookupTable, [AssessmentYear, SwisSBLKey, TemplateSDCode], '', []);
        tbTempParcelSpecialDistricts := ParcelSDLookupTable;
      end
    else
      begin
        bSDFound := True;
        ParcelSDTable.IndexName := 'BYSDCODE';
        ParcelSDTable.CancelRange;
        ParcelSDTable.SetRange([TemplateSDCode], [TemplateSDCode]);
        tbTempParcelSpecialDistricts := ParcelSDTable;
      end;

  FirstTimeThrough := True;
  Done := False;

  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
      Underline := True;
      Println(#9 + TemplateSDCode + ' was deleted from the following parcels for year ' +
              AssessmentYear + ':');
      Bold := False;
      Underline := False;

    end;  {with Sender as TBaseReport do}

  ParcelSDTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else
        If bDeleteByList
          then
            begin
              Inc(Index);
              ParcelListDialog.GetParcel(ParcelTable, Index);
              SwisSBLKey := ExtractSSKey(ParcelTable);
              bSDFound := _Locate(ParcelSDLookupTable, [AssessmentYear, SwisSBLKey, TemplateSDCode], '', []);
            end
          else
            begin
              bSDFound := True;
              If TrialRun
              then tbTempParcelSpecialDistricts.Next
              else tbTempParcelSpecialDistricts.First;

              SwisSBLKey := tbTempParcelSpecialDistricts.FieldByName('SwisSBLKey').Text;

            end;

    If (tbTempParcelSpecialDistricts.EOF or
        (bDeleteByList and
         (Index > ParcelListDialog.NumItems)))
      then Done := True;

      {FXX04281998-4: Don't copy to roll section 9.}

    If (bSDFound and
        (not (Done or ReportCancelled)))
      then
        begin
          If TrialRun
            then ProgressDialog.UserLabelCaption := 'Num Found = ' + IntToStr(NumParcelsPrinted)
            else
              begin
                ProgressDialog.UserLabelCaption := 'Num Deleted = ' + IntToStr(NumParcelsPrinted);

                ExemptionCodes := TStringList.Create;
                ExemptionHomesteadCodes := TStringList.Create;
                CountyExemptionAmounts := TStringList.Create;
                TownExemptionAmounts := TStringList.Create;
                SchoolExemptionAmounts := TStringList.Create;
                VillageExemptionAmounts := TStringList.Create;
                OrigSDAmounts := TList.Create;
                NewSDAmounts := TList.Create;
                BasicSTARAmount := 0;
                EnhancedSTARAmount := 0;

                FindKeyOld(AssessmentTable, ['TaxRollYr', 'SwisSBLKey'],
                           [AssessmentYear, SwisSBLKey]);
                SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                with SBLRec do
                  FindKeyOld(ParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot', 'Sublot',
                              'Suffix'],
                             [AssessmentYear, SwisCode, Section, Subsection,
                              Block, Lot, Sublot, Suffix]);

                TotalSpecialDistrictsForParcel(AssessmentYear,
                                               SwisSBLKey,
                                               ParcelTable,
                                               AssessmentTable,
                                               RollTotalParcelSDTable,
                                               RollTotalSDCodeTable,
                                               ExemptionTable,
                                               ExemptionCodeTable,
                                               OrigSDAmounts);

                try
                  tbTempParcelSpecialDistricts.Delete;
                except
                  SystemSupport(032, tbTempParcelSpecialDistricts,
                                'Error deleting ' + TemplateSDCode + ' for ' +
                                ConvertSwisSBLToDashDot(SwisSBLKey) + '.',
                                UnitName, GlblErrorDlgBox);
                end;

                TotalSpecialDistrictsForParcel(AssessmentYear,
                                               SwisSBLKey,
                                               ParcelTable,
                                               AssessmentTable,
                                               RollTotalParcelSDTable,
                                               RollTotalSDCodeTable,
                                               ExemptionTable,
                                               ExemptionCodeTable,
                                               NewSDAmounts);

                InsertOneSDChangeTrace(SwisSBLKey, AssessmentYear,
                                       tbTempParcelSpecialDistricts, AuditSDChangeTable,
                                       'D',
                                       DummySDRec);  {Blank parameter}

                  {Delete all the old roll totals for this parcel.
                   We are only going to adjust the special district roll
                   totals since these are the only totals affected by
                   an SD change.}
                  {FXX02101999-4: Add land value to swis and school totals.}

                AdjustRollTotalsForParcel(AssessmentYear,
                                          ParcelTable.FieldByName('SwisCode').Text,
                                          ParcelTable.FieldByName('SchoolCode').Text,
                                          ParcelTable.FieldByName('HomesteadCode').Text,
                                          ParcelTable.FieldByName('RollSection').Text,
                                          0, 0, 0, 0,
                                          ExemptionCodes,
                                          ExemptionHomesteadCodes,
                                          CountyExemptionAmounts,
                                          TownExemptionAmounts,
                                          SchoolExemptionAmounts,
                                          VillageExemptionAmounts,
                                          ParcelTable,
                                          BasicSTARAmount,
                                          EnhancedSTARAmount,
                                          OrigSDAmounts,
                                          ['D'],  {sd}
                                          'D');  {Delete the totals.}

                  {Add the new roll totals for this parcel.}

                AdjustRollTotalsForParcel(AssessmentYear,
                                          ParcelTable.FieldByName('SwisCode').Text,
                                          ParcelTable.FieldByName('SchoolCode').Text,
                                          ParcelTable.FieldByName('HomesteadCode').Text,
                                          ParcelTable.FieldByName('RollSection').Text,
                                          0, 0, 0, 0,
                                          ExemptionCodes,
                                          ExemptionHomesteadCodes,
                                          CountyExemptionAmounts,
                                          TownExemptionAmounts,
                                          SchoolExemptionAmounts,
                                          VillageExemptionAmounts,
                                          ParcelTable,
                                          BasicSTARAmount,
                                          EnhancedSTARAmount,
                                          NewSDAmounts,
                                          ['D'],  {sd}
                                          'A');  {Add the totals.}

                ExemptionCodes.Free;
                ExemptionHomesteadCodes.Free;
                CountyExemptionAmounts.Free;
                TownExemptionAmounts.Free;
                SchoolExemptionAmounts.Free;
                VillageExemptionAmounts.Free;
                FreeTList(OrigSDAmounts, SizeOf(ParcelSDValuesRecord));
                FreeTList(NewSDAmounts, SizeOf(ParcelSDValuesRecord));

              end;  {else of If TrialRun}

                    {Now print out the parcel.}

          with Sender as TBaseReport do
            begin
              If (LinesLeft < 5)
                then NewPage;

                {We will print probably 3 columns across, so if this is a new
                 line, issue a carriage return for the last line.}

              If ((NumParcelsPrinted MOD NumColumns) = 1)
                then Println('');

              Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));

            end;  {with Sender as TBaseReport do}

          NumParcelsPrinted := NumParcelsPrinted + 1;

        end;  {If ((not Done) and ...}

    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;
    ReportCancelled := ProgressDialog.Cancelled;

  until (Done or ReportCancelled);

  ProgressDialog.Finish;
  ParcelSDTable.CancelRange;
  ParcelSDTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SD';

end;  {DeleteSDCode}

{===================================================================}
Procedure TSDBroadcastForm.PrintTotalNumPrinted(Sender : TObject;
                                                AssessmentYear : String;
                                                NumParcelsPrinted : LongInt);

var
  TempStr : String;

begin
  with Sender as TBaseReport do
    begin
      Println('');
      Println('');
      Bold := True;

      If _Compare(BroadcastMethod, [bmDeleteSD, bmDeleteSDByParcelList], coEqual)
        then TempStr := 'Deleted'
        else TempStr := 'Added';

      Println(#9 + 'Special Districts ' + TempStr + ' for Assessment Year ' + AssessmentYear + ' = ' +
              IntToStr(NumParcelsPrinted));
      Println('');
      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {PrintTotalNumPrinted}

{===================================================================}
Procedure TSDBroadcastForm.ReportPrint(Sender: TObject);

var
  NumTYParcelsPrinted, NumNYParcelsPrinted : LongInt;

begin
  NumTYParcelsPrinted := 0;
  NumNYParcelsPrinted := 0;

    {FXX06181999-1: Some tables were not getting opened for the correct year - Changed to
                    OpenTablesForForm in order to force all tables to be reopened.}
    {FXX11052001-2: If running broadcast more than 1 time, the tables were not being
                    reopened to TY / NY Correctly.  Created seperate procedure to
                    open tables to correct year.}

  case BroadcastMethod of
    bmSwisCode :
      begin
          {Add SD to all the parcels in the swis code that they
           choose.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTablesForForm(Self, ThisYear);

              AddSDCodesBySwisCode(Sender, ParcelTable, ParcelSDTable,
                                   GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              CurrentAssessmentYear := GlblNextYear;

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              OpenTables(Self, NextYear);

              AddSDCodesBySwisCode(Sender, ParcelTable, ParcelSDTable,
                                   GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmSwisCode}

    bmParcelIDRange :
      begin
          {Add SD to all the parcels in the range that they specified.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTables(Self, ThisYear);

              AddSDCodesByParcelID(Sender, ParcelTable, ParcelSDTable,
                                   GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              CurrentAssessmentYear := GlblNextYear;

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              OpenTables(Self, NextYear);

              AddSDCodesByParcelID(Sender, ParcelTable, ParcelSDTable,
                                   GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmParcelIDRange}

    bmPropertyClass :
      begin
          {Add SD to all parcels with property class that they specified.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTables(Self, ThisYear);

              AddSDCodesByPropertyClass(Sender, ParcelTable, ParcelSDTable,
                                        GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              CurrentAssessmentYear := GlblNextYear;

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              OpenTables(Self, NextYear);
              AddSDCodesByPropertyClass(Sender, ParcelTable, ParcelSDTable,
                                        GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmPropertyClass}

    bmParcelsWithCertainSD :
      begin
          {Add SD to all parcels with a certain SD.}
          {FXX04281998-1: For inserting the new special districts
                when searching by existing SD, must use diff
                table than search table so position in file
                does not get messed up.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTables(Self, ThisYear);

              AddSDCodesByPreviousSD(Sender, ParcelTable, ParcelSDTable,
                                     ParcelSDLookupTable,
                                     GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              CurrentAssessmentYear := GlblNextYear;

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              OpenTables(Self, NextYear);
              AddSDCodesByPreviousSD(Sender, ParcelTable, ParcelSDTable,
                                     ParcelSDLookupTable,
                                     GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmParcelsWithCertainSD}

      {FXX06171998-1: Add option to import from file.}

    bmImportFileFixedPosition,
    bmImportFileCommaDelimited,
    bmImportFileTabDelimited :
      begin
          {Add SD to all the parcels in the swis code that they
           choose.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTables(Self, ThisYear);

              AddSDCodesByImportFile(Sender, ParcelTable, ParcelSDTable,
                                     GlblThisYear, BroadcastMethod,
                                     NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              CurrentAssessmentYear := GlblNextYear;

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              OpenTables(Self, NextYear);
              AddSDCodesByImportFile(Sender, ParcelTable, ParcelSDTable,
                                     GlblNextYear, BroadcastMethod,
                                     NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmImportFile}

    bmParcelList :
      begin
          {Add EX to all the parcels in the swis code that they
           choose.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTables(Self, ThisYear);

              AddSDCodesByParcelList(Sender, ParcelTable, ParcelSDTable,
                                     GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              CurrentAssessmentYear := GlblNextYear;

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              OpenTables(Self, NextYear);

              AddSDCodesByParcelList(Sender, ParcelTable, ParcelSDTable,
                                     GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmParcelList}

    bmDeleteSD :
      begin
          {Delete SD from parcels.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTables(Self, ThisYear);

              DeleteSDCode(Sender, ParcelTable, ParcelSDTable,
                           GlblThisYear, False, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              CurrentAssessmentYear := GlblNextYear;

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              OpenTables(Self, NextYear);

              DeleteSDCode(Sender, ParcelTable, ParcelSDTable,
                           GlblNextYear, False, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmParcelList}

    bmDeleteSDByParcelList :
      begin
          {Delete SD from parcels by list.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTables(Self, ThisYear);

              DeleteSDCode(Sender, ParcelTable, ParcelSDTable,
                           GlblThisYear, True, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              CurrentAssessmentYear := GlblNextYear;

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              OpenTables(Self, NextYear);

              DeleteSDCode(Sender, ParcelTable, ParcelSDTable,
                           GlblNextYear, True, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmDeleteSDByParcelList}

    bmUpdateByParcelList :
      begin
          {Add EX to all the parcels in the swis code that they
           choose.}

        If (AssessmentYear in [ayThisYear, ayBothYears])
          then
            begin
              CurrentAssessmentYear := GlblThisYear;
              OpenTables(Self, ThisYear);

              UpdateSDCodesByParcelList(Sender, ParcelTable, ParcelSDTable,
                                        GlblThisYear, NumTYParcelsPrinted);

            end;  {If (AssessmentYear in [ayThisYear, ayBothYears])}

        If (AssessmentYear in [ayNextYear, ayBothYears])
          then
            begin
                {If we already printed ThisYear, go to the next page.}

              CurrentAssessmentYear := GlblNextYear;

              If (AssessmentYear = ayBothYears)
                then
                  with Sender as TBaseReport do
                    NewPage;

              OpenTables(Self, NextYear);

              UpdateSDCodesByParcelList(Sender, ParcelTable, ParcelSDTable,
                                        GlblNextYear, NumNYParcelsPrinted);

            end;  {If (AssessmentYear in [ayNextYear, ayBothYears])}

      end;  {bmUpdateByParcelList}

  end;  {case BroadcastMethod of}

  If (AssessmentYear in [ayThisYear, ayBothYears])
    then PrintTotalNumPrinted(Sender, GlblThisYear, NumTYParcelsPrinted);

  with Sender as TBaseReport do
    If (LinesLeft < 5)
      then NewPage;

  If (AssessmentYear in [ayNextYear, ayBothYears])
    then PrintTotalNumPrinted(Sender, GlblNextYear, NumNYParcelsPrinted);

end;  {ReportPrint}

{===================================================================}
Procedure TSDBroadcastForm.FormClose(    Sender: TObject;
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