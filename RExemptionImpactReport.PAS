unit RExemptionImpactReport;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPBase, RPFiler, Types, RPDefine, (*Progress,*) TabNotBk, RPTXFilr,
  PASTypes, Zipcopy, ComCtrls;

type
  TfmExemptionImpactReport = class(TForm)
    Panel1: TPanel;
    lbTitle: TLabel;
    tbExemptions: TTable;
    tbExemptionCodes: TTable;
    tbAssessments: TTable;
    tbSwisCodes: TTable;
    dlgPrint: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    tbSchoolCodes: TTable;
    pgcMain: TPageControl;
    tbsOptions: TTabSheet;
    tbsSwisSchool: TTabSheet;
    Label14: TLabel;
    Label9: TLabel;
    lbxSchoolCodes: TListBox;
    lbxSwisCodes: TListBox;
    tbsExemptions: TTabSheet;
    lbxExemptionCodes: TListBox;
    Panel2: TPanel;
    btnPrint: TBitBtn;
    btnClose: TBitBtn;
    Panel3: TPanel;
    Label5: TLabel;
    rgAssessmentYear: TRadioGroup;
    rgExemptionValueType: TRadioGroup;
    gbxOptions: TGroupBox;
    cbxExtractToExcel: TCheckBox;
    lbxRollSections: TListBox;
    Label17: TLabel;
    edHistoryYear: TEdit;
    tbParcels: TTable;
    Label1: TLabel;
    edTaxRate: TEdit;
    cbxShowStatutoryAuthority: TCheckBox;
    tbStatutoryAuthorities: TTable;
    cbxShowSTARExemptions: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPrintClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure rgAssessmentYearClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sUnitName, sAssessmentYear,
    sSwisCode, sSchoolCode : String;
    bReportCancelled, bExtractToExcel,
    bShowStatutoryAuthority, bShowSTARExemptions : Boolean;

    slSelectedExemptionCodes, slSelectedSchoolCodes,
    slSelectedSwisCodes, slSelectedRollSections : TStringList;

    iExemptionType, iProcessingType : Integer;
    flExcelExtract : TextFile;

    fTaxRate : Double;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure FillListBoxes(iProcessingType : Integer;
                            sAssessmentYear : String);

    Procedure UpdateTotalsForOneParcel(sAssessmentYear : String;
                                       sSwisSBLKey : String;
                                       tlExemptionTotals : TList);

  end;

  rExemptionTotal = record
    sExemptionCode : String;
    iCount : LongInt;
    iValue : LongInt;
    fTaxAmount : Double;
  end;

  pExemptionTotal = ^rExemptionTotal;

implementation

uses GlblVars, WinUtils, Utilitys, PASUTILS, UTILEXSD,  GlblCnst,
     PRCLLIST, Prog, RptDialg, DataAccessUnit, Preview;

const
  etCounty = 0;
  etMunicipal = 1;
  etSchool = 2;
  etVillage = 3;

{$R *.DFM}

{========================================================}
Procedure TfmExemptionImpactReport.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TfmExemptionImpactReport.FillListBoxes(iProcessingType : Integer;
                                                 sAssessmentYear : String);

var
  Quit : Boolean;

begin
  OpenTableForProcessingType(tbExemptionCodes, ExemptionCodesTableName,
                             iProcessingType, Quit);
  OpenTableForProcessingType(tbSwisCodes, SwisCodeTableName,
                             iProcessingType, Quit);
  OpenTableForProcessingType(tbSchoolCodes, SchoolCodeTableName,
                             iProcessingType, Quit);

  FillOneListBox(lbxExemptionCodes, tbExemptionCodes,
                 'EXCode', 'Description', 10,
                 True, True, iProcessingType, sAssessmentYear);

  FillOneListBox(lbxSwisCodes, tbSwisCodes,
                 'SwisCode', 'MunicipalityName', 20,
                 True, True, iProcessingType, sAssessmentYear);

  FillOneListBox(lbxSchoolCodes, tbSchoolCodes,
                 'SchoolCode', 'SchoolName', 20,
                 True, True, iProcessingType, sAssessmentYear);

end;  {FillListBoxes}

{========================================================}
Procedure TfmExemptionImpactReport.InitializeForm;

begin
  sUnitName := 'RExemptionImpactReport';  {mmm}

    {Default assessment year.}

  case GlblProcessingType of
    History : begin
                rgAssessmentYear.ItemIndex := 2;
                edHistoryYear.Text := GlblHistYear;
                iProcessingType := History;
                sAssessmentYear := GlblHistYear;
              end;  {History}

    NextYear : begin
                 rgAssessmentYear.ItemIndex := 1;
                 iProcessingType := NextYear;
                 sAssessmentYear := GlblNextYear;
               end;  {NextYear}

    ThisYear : begin
                 rgAssessmentYear.ItemIndex := 0;
                 iProcessingType := ThisYear;
                 sAssessmentYear := GlblThisYear;
               end;  {This Year}

  end;  {case GlbliProcessingType of}

  FillListBoxes(iProcessingType, sAssessmentYear);

  slSelectedExemptionCodes := TStringList.Create;
  slSelectedSchoolCodes := TStringList.Create;
  slSelectedSwisCodes := TStringList.Create;
  slSelectedRollSections := TStringList.Create;
  SelectItemsInListBox(lbxRollSections);

  tbStatutoryAuthorities.Open;

end;  {InitializeForm}

{===========================================================================}
Procedure TfmExemptionImpactReport.rgAssessmentYearClick(Sender: TObject);

{FXX12021998-1: Load the EX box with that year's sd codes.}

var
  iProcessingType : Integer;

begin
  iProcessingType := GlblProcessingType;

    {FXX04251999-2: Allow the user to print from history.}

  case rgAssessmentYear.ItemIndex of
    0 : begin
          iProcessingType := ThisYear;
          sAssessmentYear := GlblThisYear;
          edHistoryYear.Visible := False;
        end;

    1 : begin
          iProcessingType := NextYear;
          sAssessmentYear := GlblNextYear;
          edHistoryYear.Visible := False;
        end;

    2 : begin
          iProcessingType := History;
          sAssessmentYear := edHistoryYear.Text;
          edHistoryYear.Visible := True;
        end;

  end;  {case rgAssessmentYear.ItemIndex of}

  If (_Compare(iProcessingType, ThisYear, coEqual) or
      _Compare(iProcessingType, NextYear, coEqual))
    then FillListBoxes(iProcessingType, sAssessmentYear);

end;  {rgAssessmentYearClick}

{===================================================================}
Function RecMeetsCriteria(tbParcels : TTable;
                          sSwisSBLKey : String;
                          slSelectedSwisCodes,
                          slSelectedSchoolCodes,
                          slSelectedRollSections : TStringList) : Boolean;

begin
  Result := True;

  If _Compare(slSelectedSwisCodes.IndexOf(Copy(sSwisSBLKey, 1, 6)), -1, coEqual)
    then Result := False;

    {In the selected school list?}

  If _Compare(slSelectedSchoolCodes.IndexOf(tbParcels.FieldByName('SchoolCode').AsString), -1, coEqual)
    then Result := False;

    {Don't include rs 9.}

  If (_Compare(tbParcels.FieldByName('RollSection').AsString, '9', coEqual) or
      (not ParcelIsActive(tbParcels)))
    then Result := False;

  If _Compare(slSelectedRollSections.IndexOf(tbParcels.FieldByName('RollSection').AsString), -1, coEqual)
    then Result := False;

end;  {RecMeetsCriteria}

{===================================================================}
Procedure TfmExemptionImpactReport.btnPrintClick(Sender: TObject);

var
  bQuit : Boolean;
  sSpreadsheetFileName, sNewFileName : String;
  iProcessingType : Integer;

begin
  bReportCancelled := False;
  bShowStatutoryAuthority := cbxShowStatutoryAuthority.Checked;
  bShowSTARExemptions := cbxShowSTARExemptions.Checked;

  try
    fTaxRate := StrToFloat(edTaxRate.Text);
  except
    fTaxRate := 0;
  end;

  iExemptionType := rgExemptionValueType.ItemIndex;

  FillSelectedItemList(lbxRollSections, slSelectedRollSections, 1);
  FillSelectedItemList(lbxSwisCodes, slSelectedSwisCodes, 6);
  FillSelectedItemList(lbxSchoolCodes, slSelectedSchoolCodes, 6);
  FillSelectedItemList(lbxExemptionCodes, slSelectedExemptionCodes, 5);

  If _Compare(slSelectedSwisCodes.Count, 1, coEqual)
    then sSwisCode := slSelectedSwisCodes[0]
    else sSwisCode := Copy(slSelectedSwisCodes[0], 1, 4);

  If _Compare(slSelectedSchoolCodes.Count, 1, coEqual)
    then sSchoolCode := slSelectedSchoolCodes[0]
    else sSchoolCode := 'All';

  If dlgPrint.Execute
    then
      begin
        btnPrint.Enabled := False;
        Application.ProcessMessages;

        AssignPrinterSettings(dlgPrint, ReportPrinter, ReportFiler, [ptBoth], False, bQuit);
(*        ReportPrinter.Orientation := poLandscape;
        ReportFiler.Orientation := poLandscape; *)

        iProcessingType := GlblProcessingType;

        case rgAssessmentYear.ItemIndex of
          0 : begin
                iProcessingType := ThisYear;
                sAssessmentYear := GlblThisYear;
              end;

          1 : begin
                iProcessingType := NextYear;
                sAssessmentYear := GlblNextYear;
              end;

          2 : begin
                iProcessingType := History;
                sAssessmentYear := edHistoryYear.Text;
              end;

        end;  {case rgAssessmentYear.ItemIndex of}

        bExtractToExcel := cbxExtractToExcel.Checked;

        If bExtractToExcel
          then
            begin
              sSpreadsheetFileName := GetPrintFileName(Self.Caption, True);
              AssignFile(flExcelExtract, sSpreadsheetFileName);
              Rewrite(flExcelExtract);

              WriteCommaDelimitedLine(flExcelExtract,
                                      ['EX Code',
                                       'Description']);

              If bShowStatutoryAuthority
                then WriteCommaDelimitedLine(flExcelExtract,
                                             ['Statutory Authority']);

              WritelnCommaDelimitedLine(flExcelExtract,
                                        ['Count',
                                         'Total Equalized Value',
                                         '% of Value Exempted']);

            end;  {If bExtractToExcel}

        OpenTableForProcessingType(tbParcels, ParcelTableName,
                                   iProcessingType, bQuit);
        OpenTableForProcessingType(tbExemptions, ExemptionsTableName,
                                   iProcessingType, bQuit);
        OpenTableForProcessingType(tbAssessments, AssessmentTableName,
                                   iProcessingType, bQuit);
        OpenTableForProcessingType(tbSwisCodes, SwisCodeTableName,
                                   iProcessingType, bQuit);
        OpenTableForProcessingType(tbExemptionCodes, ExemptionCodesTableName,
                                   iProcessingType, bQuit);

        If _Compare(iProcessingType, History, coEqual)
          then _SetRange(tbParcels, [sAssessmentYear, '', '', '', '', '', '', ''],
                         [sAssessmentYear, 'zzzzzzzz', '', '', '', '', '', ''], '', []);

        ProgressDialog.StartPrinting(dlgPrint.PrintToFile);

        If dlgPrint.PrintToFile
          then
            begin
              sNewFileName := GetPrintFileName(Self.Caption, True);
              ReportFiler.FileName := sNewFileName;
              GlblPreviewPrint := True;

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
                  Chdir(GlblReportDir);
                  OldDeleteFile(sNewFileName);
                finally
                  {We don't care if it does not get deleted, so we won't put up an
                   error message.}

                  ChDir(GlblProgramDir);
                end;

              end;  {try PreviewForm := ...}

            end  {If PrintDialog.PrintToFile}
          else ReportPrinter.Execute;

        ShowReportDialog('Exemption Impact.rpt', sNewFileName, True);

      end;  {If not Quit}

  ProgressDialog.Finish;

  If bExtractToExcel
    then
      begin
        CloseFile(flExcelExtract);
        SendTextFileToExcelSpreadsheet(sSpreadsheetFileName, True,
                                       False, '');

      end;  {If bExtractToExcel}

  btnPrint.Enabled := True;

end;  {btnPrintClick}

{===================================================================}
Function FindExemptionInList(tlExemptionTotals : TList;
                             _sExemptionCode : String) : Integer;

var
  I : Integer;

begin
  Result := -1;

  For I := 0 to (tlExemptionTotals.Count - 1) do
    with pExemptionTotal(tlExemptionTotals[I])^ do
      If _Compare(sExemptionCode, _sExemptionCode, coEqual)
        then Result := I;

end;  {FindExemptionInList}

{===================================================================}
Procedure UpdateExemptionTotals(tlExemptionTotals : TList;
                                _sExemptionCode : String;
                                _iValue : LongInt);

var
  ptrExemptionTotal : pExemptionTotal;
  iIndex : Integer;

begin
  iIndex := FindExemptionInList(tlExemptionTotals, _sExemptionCode);

  If _Compare(iIndex, -1, coEqual)
    then
      begin
        New(ptrExemptionTotal);

        with ptrExemptionTotal^ do
          begin
            sExemptionCode := _sExemptionCode;
            iCount := 0;
            iValue := 0;

          end;  {with ptrExemptionTotal do}

        tlExemptionTotals.Add(ptrExemptionTotal);

        iIndex := FindExemptionInList(tlExemptionTotals, _sExemptionCode);

      end;  {If not ExemptionExistsInList(tlExemptionTotals, sExemptionCode)}

  with pExemptionTotal(tlExemptionTotals[iIndex])^ do
    begin
      iCount := iCount + 1;
      iValue := iValue + _iValue;
    end;

end;  {UpdateExemptionTotals}

{===================================================================}
Procedure TfmExemptionImpactReport.UpdateTotalsForOneParcel(sAssessmentYear : String;
                                                            sSwisSBLKey : String;
                                                            tlExemptionTotals : TList);

var
  slExemptionCodes,
  slExemptionHomesteadCodes,
  slResidentialTypes,
  slCountyExemptionAmounts,
  slTownExemptionAmounts,
  slSchoolExemptionAmounts,
  slVillageExemptionAmounts : TStringList;
  cBasicSTARAmount, cEnhancedSTARAmount : Comp;
  aExemptionTotals : ExemptionTotalsArrayType;
  I, iAmount : LongInt;

begin
  iAmount := 0;
  slExemptionCodes := TStringList.Create;
  slExemptionHomesteadCodes := TStringList.Create;
  slResidentialTypes := TStringList.Create;
  slCountyExemptionAmounts := TStringList.Create;
  slTownExemptionAmounts := TStringList.Create;
  slSchoolExemptionAmounts := TStringList.Create;
  slVillageExemptionAmounts := TStringList.Create;

  aExemptionTotals := TotalExemptionsForParcel(sAssessmentYear, sSwisSBLKey,
                                               tbExemptions, tbExemptionCodes,
                                               tbParcels.FieldByName('HomesteadCode').AsString,
                                               'A',
                                               slExemptionCodes,
                                               slExemptionHomesteadCodes,
                                               slResidentialTypes,
                                               slCountyExemptionAmounts,
                                               slTownExemptionAmounts,
                                               slSchoolExemptionAmounts,
                                               slVillageExemptionAmounts,
                                               cBasicSTARAmount, cEnhancedSTARAmount);

  For I := 0 to (slExemptionCodes.Count - 1) do
    begin
      try
        case iExemptionType of
          etCounty : iAmount := StrToInt(slCountyExemptionAmounts[I]);
          etMunicipal : iAmount := StrToInt(slTownExemptionAmounts[I]);
          etSchool : iAmount := StrToInt(slSchoolExemptionAmounts[I]);
          etVillage : iAmount := StrToInt(slVillageExemptionAmounts[I]);
        end;
      except
        iAmount := 0;
      end;

      UpdateExemptionTotals(tlExemptionTotals, slExemptionCodes[I], iAmount);

    end;  {For I := 0 to (slExemptionCodes.Count - 1) do}

    {CHG03112009-1(2.17.1.7): Option to show the STAR exemptions.}

  If bShowSTARExemptions
    then
      begin
        If _Compare(cBasicSTARAmount, 0, coGreaterThan)
          then UpdateExemptionTotals(tlExemptionTotals, BasicSTARExemptionCode, Trunc(cBasicSTARAmount));

        If _Compare(cEnhancedSTARAmount, 0, coGreaterThan)
          then UpdateExemptionTotals(tlExemptionTotals, EnhancedSTARExemptionCode, Trunc(cEnhancedSTARAmount));

      end;  {If bShowSTARExemptions}

end;  {UpdateTotalsForOneParcel}

{==================================================================}
Procedure SortTList(tlExemptionTotals : TList);

var
  I, J : Integer;
  ptrTemp : Pointer;

begin
  For I := 0 to (tlExemptionTotals.Count - 1) do
    For J := (I + 1) to (tlExemptionTotals.Count - 1) do
      If _Compare(pExemptionTotal(tlExemptionTotals[I])^.sExemptionCode,
                  pExemptionTotal(tlExemptionTotals[J])^.sExemptionCode,
                  coGreaterThan)
        then
          begin
            ptrTemp := tlExemptionTotals[I];
            tlExemptionTotals[I] := tlExemptionTotals[J];
            tlExemptionTotals[J] := ptrTemp;
          end;

end;  {SortTList}

{==================================================================}
Procedure TfmExemptionImpactReport.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
      SectionTop := 0.25;
      SectionLeft := 0.3;
      SectionRight := PageWidth - 0.5;

      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage) + '    ', pjRight);
      PrintHeader('    Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SetFont('Times New Roman',12);
      ClearTabs;
      SetTab(3.0, pjCenter, 2.0, 0, BoxLineNone, 0);
      Bold := True;
      Home;
      Println('');
      Println(#9 + 'Exemption Impact Report');
      Println('');
      SetFont('Times New Roman',10);
      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BoxLineNone, 0);
      Println(#9 + 'Assessment Year: ' + sAssessmentYear);
      Println('');

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==================================================================}
Procedure PrintReportSubHeader(Sender : TObject;
                               iExemptionType : Integer;
                               fTotalAssessment : Double;
                               fUniformPercentOfValue : Double;
                               sSwisCode : String;
                               sSchoolCode : String;
                               bShowStatutoryAuthority : Boolean);

var
  sExemptionTypeDescription : String;
  fEqualizedTotalAssessedValue : Double;

begin
  with Sender as TBaseReport do
    begin
      SetFont('Times New Roman',10);
      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BoxLineNone, 0);
      SetTab(3.0, pjCenter, 2.0, 0, BoxLineNone, 0);
      SetTab(6.1, pjLeft, 1.0, 0, BoxLineNone, 0);
      SetTab(7.3, pjRight, 0.8, 0, BoxLineNone, 0);

      Println(#9 + 'County: ' + GlblCountyName +
              #9 + #9 + 'Municipality: ' +
              #9 + GlblMunicipalityName);

      case iExemptionType of
        etCounty : sExemptionTypeDescription := 'County Value Report';
        etMunicipal : sExemptionTypeDescription := GetMunicipalityTypeName(GlblMunicipalityType) +
                                                   ' Value Report';
        etSchool : sExemptionTypeDescription := 'School Value Report (' + sSchoolCode + ')';
        etVillage : sExemptionTypeDescription := 'Village Value Report';
      end;

      Println(#9 + 'SWIS Code: ' + sSwisCode +
              #9 + sExemptionTypeDescription +
              #9 + 'Total Assessed Val:' +
              #9 + FormatFloat(IntegerDisplay, fTotalAssessment));

      Println(#9 + #9 +
              #9 + 'Uniform Percentage:' +
              #9 + FormatFloat(DecimalDisplay, fUniformPercentOfValue));

      fEqualizedTotalAssessedValue := Trunc(fTotalAssessment / (fUniformPercentOfValue / 100));

      ClearTabs;
      SetTab(0.3, pjCenter, 8.0, 0, BoxLineNone, 0);
      Println(#9 + 'Equalized Total Assessed Value = ' +
                   FormatFloat(IntegerDisplay, fEqualizedTotalAssessedValue));
      Println('');
      Bold := True;

      If bShowStatutoryAuthority
        then
          begin
            ClearTabs;
            SetTab(0.6, pjCenter, 0.5, 5, BOXLINENOBOTTOM, 25);  {Exemption code}
            SetTab(1.1, pjCenter, 2.2, 5, BOXLINENOBOTTOM, 25);  {Description}
            SetTab(3.3, pjCenter, 2.0, 5, BOXLINENOBOTTOM, 25);  {Statutory authority}
            SetTab(5.3, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);  {# of exemptions}
            SetTab(5.9, pjCenter, 1.2, 5, BOXLINENOBOTTOM, 25);  {Total equalized exemption amount}
            SetTab(7.1, pjCenter, 0.8, 5, BOXLINENOBOTTOM, 25);  {% of value exempted}

            Println(#9 + 'Exempt' +
                    #9 +
                    #9 + 'Statutory' +
                    #9 + '# of' +
                    #9 + 'Total Equalized' +
                    #9 + '% of Value');

            ClearTabs;
            SetTab(0.6, pjCenter, 0.5, 5, BOXLINENOTOP, 25);  {Exemption code}
            SetTab(1.1, pjCenter, 2.2, 5, BOXLINENOTOP, 25);  {Description}
            SetTab(3.3, pjCenter, 2.0, 5, BOXLINENOTOP, 25);  {Statutory authority}
            SetTab(5.3, pjCenter, 0.6, 5, BOXLINENOTOP, 25);  {# of exemptions}
            SetTab(5.9, pjCenter, 1.2, 5, BOXLINENOTOP, 25);  {Total equalized exemption amount}
            SetTab(7.1, pjCenter, 0.8, 5, BOXLINENOTOP, 25);  {% of value exempted}

            Println(#9 + 'Code' +
                    #9 + 'Description' +
                    #9 + 'Authority' +
                    #9 + 'Exempts' +
                    #9 + 'Value of EX' +
                    #9 + 'Exempted');

            ClearTabs;
            SetTab(0.6, pjLeft, 0.5, 5, BOXLINEAll, 0);  {Exemption code}
            SetTab(1.1, pjLeft, 2.2, 5, BOXLINEAll, 0);  {Description}
            SetTab(3.3, pjLeft, 2.0, 5, BOXLINEAll, 0);  {Statutory authority}
            SetTab(5.3, pjRight, 0.6, 5, BOXLINEAll, 0);  {# of exemptions}
            SetTab(5.9, pjRight, 1.2, 5, BOXLINEAll, 0);  {Total equalized exemption amount}
            SetTab(7.1, pjRight, 0.8, 5, BOXLINEAll, 0);  {% of value exempted}

          end
        else
          begin
            ClearTabs;
            SetTab(1.6, pjCenter, 0.5, 5, BOXLINENOBOTTOM, 25);  {Exemption code}
            SetTab(2.1, pjCenter, 2.2, 5, BOXLINENOBOTTOM, 25);  {Description}
            SetTab(4.3, pjCenter, 0.6, 5, BOXLINENOBOTTOM, 25);  {# of exemptions}
            SetTab(4.9, pjCenter, 1.2, 5, BOXLINENOBOTTOM, 25);  {Total equalized exemption amount}
            SetTab(6.1, pjCenter, 0.8, 5, BOXLINENOBOTTOM, 25);  {% of value exempted}

            Println(#9 + 'Exempt' +
                    #9 +
                    #9 + '# of' +
                    #9 + 'Total Equalized' +
                    #9 + '% of Value');

            ClearTabs;
            SetTab(1.6, pjCenter, 0.5, 5, BOXLINENOTOP, 25);  {Exemption code}
            SetTab(2.1, pjCenter, 2.2, 5, BOXLINENOTOP, 25);  {Description}
            SetTab(4.3, pjCenter, 0.6, 5, BOXLINENOTOP, 25);  {# of exemptions}
            SetTab(4.9, pjCenter, 1.2, 5, BOXLINENOTOP, 25);  {Total equalized exemption amount}
            SetTab(6.1, pjCenter, 0.8, 5, BOXLINENOTOP, 25);  {% of value exempted}

            Println(#9 + 'Code' +
                    #9 + 'Description' +
                    #9 + 'Exempts' +
                    #9 + 'Value of EX' +
                    #9 + 'Exempted' +
                    #9 + 'Tax Impact');

            ClearTabs;
            SetTab(1.6, pjLeft, 0.5, 5, BOXLINEAll, 25);  {Exemption code}
            SetTab(2.1, pjLeft, 2.2, 5, BOXLINEAll, 25);  {Description}
            SetTab(4.3, pjRight, 0.6, 5, BOXLINEAll, 25);  {# of exemptions}
            SetTab(4.9, pjRight, 1.2, 5, BOXLINEAll, 25);  {Total equalized exemption amount}
            SetTab(6.1, pjRight, 0.8, 5, BOXLINEAll, 25);  {% of value exempted}

          end;  {else of If bShowStatutoryAuthority}

      Bold := False;

    end;  {with Sender as TBaseReport do}

end;  {PrintReportSubHeader}

{==================================================================}
Procedure PrintFooter(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');

      ClearTabs;
      SetTab(0.3, pjLeft, 8.0, 5, BOXLINENone, 0);

      Println(#9 + StringOfChar('_', 120));
      Println(#9 + 'Values have been equalized using the Uniform Percentage of Value.');
      Println(#9 + 'The Exempt amounts do not take in to consideration payments in lieu of taxes or other payments for municipal services.');
      Println(#9 + StringOfChar('_', 120));

      Println('');
      Println(#9 + 'Amount, if any, attributable to payments in lieu of taxes:  ______________');

    end;  {with Sender as TBaseObject do}

end;  {PrintFooter}

{==================================================================}
Procedure PrintExemptions(    Sender : TObject;
                              tlExemptionTotals : TList;
                              tbExemptionCodes : TTable;
                              tbStatutoryAuthorities : TTable;
                              sSwisCode : String;
                              sSchoolCode : String;
                              fUniformPercentOfValue : Double;
                              fTotalAssessment : Double;
                              iExemptionType : Integer;
                              bShowSystemExemptions : Boolean;
                              bIncludeSTARExemptions : Boolean;
                              bShowStatutoryAuthority : Boolean;
                              bExtractToExcel : Boolean;
                          var flExcelExtract : TextFile;
                          var iOverallExemptionCount : LongInt;
                          var fOverallEqualizedExemptionTotal : Double;
                          var fOverallPercentExempted : Double);

var
  I, iEqualizedExemptionTotal : LongInt;
  fPercentExempted : Double;

begin
  For I := 0 to (tlExemptionTotals.Count - 1) do
    with pExemptionTotal(tlExemptionTotals[I])^ do
      If (_Compare(iValue, 0, coGreaterThan) and
           ((bShowSystemExemptions and
             _Compare(sExemptionCode, '5', coStartsWith)) or
            ((not bShowSystemExemptions) and
             (not _Compare(sExemptionCode, '5', coStartsWith)))) and
          (bIncludeSTARExemptions or
           (not ExemptionIsSTAR(sExemptionCode))))
        then
          begin
            _Locate(tbExemptionCodes, [sExemptionCode], '', []);

            iEqualizedExemptionTotal := Trunc(iValue / (fUniformPercentOfValue / 100));
            fPercentExempted := (iValue / fTotalAssessment) * 100;
(*                  fTaxImpact := (iValue / 1000) * fTaxRate; *)

            iOverallExemptionCount := iOverallExemptionCount + iCount;
            fOverallEqualizedExemptionTotal := fOverallEqualizedExemptionTotal +
                                               iEqualizedExemptionTotal;
            fOverallPercentExempted := fOverallPercentExempted + fPercentExempted;

            with Sender as TBaseReport do
              begin
                If (LinesLeft < 6)
                  then
                    begin
                      NewPage;

                      PrintReportSubHeader(Sender, iExemptionType,
                                           fTotalAssessment, fUniformPercentOfValue,
                                           sSwisCode, sSchoolCode, bShowStatutoryAuthority);

                    end;  {If (LinesLeft < 10)}

                Print(#9 + sExemptionCode +
                      #9 + tbExemptionCodes.FieldByName('Description').AsString);

                If (bShowStatutoryAuthority and
                    _Locate(tbStatutoryAuthorities, [Copy(sExemptionCode, 1, 4)], '', []))
                  then Print(#9 + tbStatutoryAuthorities.FieldByName('StatutoryAuthority').AsString)
                  else Print(#9);

                Println(#9 + FormatFloat(IntegerDisplay, iCount) +
                        #9 + FormatFloat(IntegerDisplay, iEqualizedExemptionTotal) +
                        #9 + FormatFloat(DecimalDisplay, fPercentExempted));

                If bExtractToExcel
                  then
                    begin
                      WriteCommaDelimitedLine(flExcelExtract,
                                              [sExemptionCode,
                                               tbExemptionCodes.FieldByName('Description').AsString]);

                      If bShowStatutoryAuthority
                        then WriteCommaDelimitedLine(flExcelExtract,
                                                     [tbStatutoryAuthorities.FieldByName('StatutoryAuthority').AsString]);

                      WritelnCommaDelimitedLine(flExcelExtract,
                                                [iCount,
                                                 iEqualizedExemptionTotal,
                                                 fPercentExempted]);

                    end;  {If bExtractToExcel}

              end;  {with Sender as TBaseReport do}

          end;  {If _Compare(iValue, 0, coGreaterThan)}

end;  {PrintExemptions}

{==================================================================}
Procedure TfmExemptionImpactReport.ReportPrint(Sender: TObject);


var
  tlExemptionTotals : TList;
  sSwisSBLKey : String;
  iOverallExemptionCount : LongInt;
  fUniformPercentOfValue, fTotalAssessment,
  fOverallPercentExempted, fOverallEqualizedExemptionTotal : Double;

begin
  iOverallExemptionCount := 0;
  fTotalAssessment := 0;
  fUniformPercentOfValue := 0;
  fOverallPercentExempted := 0;
  fOverallEqualizedExemptionTotal := 0;
  tlExemptionTotals := TList.Create;
  ProgressDialog.Start(tbParcels.RecordCount, True, True);

  with tbParcels do
    begin
      First;

      while not (EOF or bReportCancelled) do
        begin
          sSwisSBLKey := ExtractSSKey(tbParcels);

          If RecMeetsCriteria(tbParcels, sSwisSBLKey,
                              slSelectedSwisCodes,
                              slSelectedSchoolCodes,
                              slSelectedRollSections)
            then
              begin
                _Locate(tbSwisCodes, [Copy(sSwisSBLKey, 1, 6)], '', []);
                fUniformPercentOfValue := tbSwisCodes.FieldByName('UniformPercentValue').AsFloat;

                UpdateTotalsForOneParcel(sAssessmentYear, sSwisSBLKey, tlExemptionTotals);

                If _Locate(tbAssessments, [sAssessmentYear, sSwisSBLKey], '', [])
                  then fTotalAssessment := fTotalAssessment + tbAssessments.FieldByName('TotalAssessedVal').AsInteger;

              end;  {If RecMeetsCriteria...}

          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(sSwisSBLKey));
          Application.ProcessMessages;
          Next;

          bReportCancelled := ProgressDialog.Cancelled;

        end;  {while not (EOF or bReportCancelled) do}

    end;  {with tbParcels do}

  If not bReportCancelled
    then
      begin
        SortTList(tlExemptionTotals);

        PrintReportSubHeader(Sender, iExemptionType,
                             fTotalAssessment, fUniformPercentOfValue,
                             sSwisCode, sSchoolCode, bShowStatutoryAuthority);

        PrintExemptions(Sender, tlExemptionTotals,
                        tbExemptionCodes,
                        tbStatutoryAuthorities,
                        sSwisCode,
                        sSchoolCode,
                        fUniformPercentOfValue,
                        fTotalAssessment,
                        iExemptionType,
                        False,
                        bShowSTARExemptions,
                        bShowStatutoryAuthority,
                        bExtractToExcel,
                        flExcelExtract,
                        iOverallExemptionCount,
                        fOverallEqualizedExemptionTotal,
                        fOverallPercentExempted);

          {Print totals}

        If not bReportCancelled
          then
            with Sender as TBaseReport do
              begin
                Println(#9 + #9 + #9 + #9 + #9 + #9);

                Bold := True;
                Println(#9 + #9 + 'Total Exemptions (No System EX''s)' +
                        #9 + #9 + FormatFloat(IntegerDisplay, iOverallExemptionCount) +
                        #9 + FormatFloat(IntegerDisplay, fOverallEqualizedExemptionTotal) +
                        #9 + FormatFloat(DecimalDisplay, fOverallPercentExempted));
                Bold := False;

                Println(#9 + #9 + #9 + #9 + #9 + #9);

                If (LinesLeft < 10)
                  then
                    begin
                      NewPage;

                      PrintReportSubHeader(Sender, iExemptionType,
                                           fTotalAssessment, fUniformPercentOfValue,
                                           sSwisCode, sSchoolCode, bShowStatutoryAuthority);

                    end;  {If (LinesLeft < 10)}

                PrintExemptions(Sender, tlExemptionTotals,
                                tbExemptionCodes,
                                tbStatutoryAuthorities,
                                sSwisCode,
                                sSchoolCode,
                                fUniformPercentOfValue,
                                fTotalAssessment,
                                iExemptionType,
                                True,
                                bShowSTARExemptions,
                                bShowStatutoryAuthority,
                                bExtractToExcel,
                                flExcelExtract,
                                iOverallExemptionCount,
                                fOverallEqualizedExemptionTotal,
                                fOverallPercentExempted);

                Bold := True;
                Println(#9 + #9 + 'Total Exemptions (with System EX''s)' +
                        #9 + #9 + FormatFloat(IntegerDisplay, iOverallExemptionCount) +
                        #9 + FormatFloat(IntegerDisplay, fOverallEqualizedExemptionTotal) +
                        #9 + FormatFloat(DecimalDisplay, fOverallPercentExempted));
                Bold := False;

              end;  {If not bReportCancelled}

      end;  {If not bReportCancelled}

  PrintFooter(Sender);

  FreeTList(tlExemptionTotals, SizeOf(rExemptionTotal));
  ProgressDialog.Finish;

end;  {ReportPrint}

{===================================================================}
Procedure TfmExemptionImpactReport.FormClose(    Sender: TObject;
                                  var Action: TCloseAction);

begin
  slSelectedSwisCodes.Free;
  slSelectedSchoolCodes.Free;
  slSelectedExemptionCodes.Free;
  slSelectedRollSections.Free;
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.
