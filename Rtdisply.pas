unit Rtdisply;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, Mask, DBCtrls,
  Wwkeycb, DB, DBTables, Wwtable, Wwdatsrc, Printrng, Btrvdlg, Grids,
  DBGrids, DBLookup, RPBase, RPCanvas, RPrinter, Wwdbigrd, Wwdbgrid,
  TabNotBk, RPFiler, DBIProcs, RPDefine,
  Types,Glblvars, PASTYPES;

type
  TRollTotalDisplayForm = class(TForm)
    ScrollBox1: TScrollBox;
    TitlePanel: TPanel;
    TitleLabel: TLabel;
    YearLabel: TLabel;
    SwisCodeTable: TTable;
    Label1: TLabel;
    Notebook: TNotebook;
    MunRadioGroup: TRadioGroup;
    FormatRadioGroup: TRadioGroup;
    TaxYearRadioGroup: TRadioGroup;
    CloseOptionsButton: TBitBtn;
    Label9: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    Label2: TLabel;
    ReturnButton2: TBitBtn;
    ShowTotalsButton1: TBitBtn;
    ShowTotalsButton2: TBitBtn;
    ShowHomesteadTotalsCheckBox: TCheckBox;
    HistoryEdit: TEdit;
    Table1: TTable;
    CalculateButton: TBitBtn;
    DisplayFooterPanel: TPanel;
    EqualizationRateLabel: TLabel;
    RARLabel: TLabel;
    UniformPercentOfValueLabel: TLabel;
    ReturnButton3: TBitBtn;
    Panel3: TPanel;
    DisplayStringGrid: TStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseOptionsButtonClick(Sender: TObject);
    procedure DisplayStringGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure ShowTotalsButton1Click(Sender: TObject);
    procedure ReturnButton2Click(Sender: TObject);
    procedure ShowTotalsButton2Click(Sender: TObject);
    procedure ReturnButton3Click(Sender: TObject);
    procedure TaxYearRadioGroupClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CalculateButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);

  private
    UnitName : String; {For error dialog box}
  public
    FormAccessRights : Integer; {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}
    ProcessingType : Integer;
    SelectedSwisCodes : TStringList;
    TotalsOnly,
    ShowHomesteadCode : Boolean;
    OriginalGridWidth : Integer;
    ColumnSizeFactor : Double;
    InitializingForm : Boolean;

    Procedure InitializeForm;

    Procedure DisplayOneSwisLine(    SwisCodePtr : RTSwisCodeTotalsPtr;
                                 var RowNum : Integer;
                                     TotalsRecord,
                                     ShowHomesteadCodes : Boolean;
                                     TotalsTitle1,
                                     TotalsTitle2 : String);

    Procedure DisplayTotals_OneSwisCode(    DisplayStringGrid : TStringGrid;
                                            LastSwisCode : String;
                                            BySwisHstdTotals,
                                            BySwisNonHstdTotals : RTSwisCodeTotalsPtr;
                                            ShowHomesteadCodes : Boolean;
                                        var RowNum : Integer);

    Procedure DisplaySwisCodes(ProcessingType : Integer;
                               ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                               TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                               SelectedSwisCodes : TStringList);
    {Display the swis codes.}

    Procedure DisplaySDCodes(ProcessingType : Integer;
                             TotalsOnly : Boolean;
                             SelectedSwisCodes : TStringList;
                             ProratasOnly : Boolean);

    Procedure DisplayRS9(ProcessingType : Integer;
                         TotalsOnly : Boolean;
                         SelectedSwisCodes : TStringList);

    Procedure DisplayOneExemptionLine(    ExemptionCodePtr : RTEXCodeTotalsPtr;
                                      var RowNum : Integer;
                                          TotalsRecord,
                                          ShowHomesteadCodes : Boolean;
                                          EXCodeLookupTable : TTable;
                                          TotalsTitle1,
                                          TotalsTitle2 : String);

    Procedure DisplayExemptionTotals_OneSwisCode(    DisplayStringGrid : TStringGrid;
                                                     LastSwisCode : String;
                                                     BySwisHstdTotals,
                                                     BySwisNonHstdTotals : RTEXCodeTotalsPtr;
                                                     ShowHomesteadCodes : Boolean;
                                                     EXCodeLookupTable : TTable;
                                                 var RowNum : Integer);

    Procedure DisplayEXCodes(ProcessingType : Integer;
                             ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                             TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                             SelectedSwisCodes : TStringList);

    Procedure DisplayOneSchoolLine(    SchoolCodePtr : RTSchoolCodeTotalsPtr;
                                   var RowNum : Integer;
                                       TotalsRecord,
                                       ShowHomesteadCodes : Boolean;
                                       SchoolCodeLookupTable : TTable;
                                       TotalsTitle1,
                                       TotalsTitle2 : String);

    Procedure DisplaySchoolTotals_OneSwisCode(    DisplayStringGrid : TStringGrid;
                                                  LastSwisCode : String;
                                                  BySwisHstdTotals,
                                                  BySwisNonHstdTotals : RTSchoolCodeTotalsPtr;
                                                  ShowHomesteadCodes : Boolean;
                                                  SchoolCodeLookupTable : TTable;
                                              var RowNum : Integer);

    Procedure DisplaySchoolCodes(ProcessingType : Integer;
                                 ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                                 TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                                 SelectedSwisCodes : TStringList);

    Procedure DisplayVillageRelevies(ProcessingType : Integer;
                                     ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                                     TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                                     SelectedSwisCodes : TStringList);

    Procedure DisplayRollTotals;
    {Display the 3rd notebook page and the roll totals they wanted to see.}

    Function RequiredInformationFilledIn : Boolean;
    {Make sure that the user has filled in all the information they need.}

  end;

implementation

{$R *.DFM}

uses
  Utilitys,  {General utilities}
  PASUTILS, UTILEXSD,   {PAS specific utilites}
  UTILRTOT,  {Procs to load roll total lists.}
  GlblCnst, RTCalcul,
  WinUtils, Prog;  {Windows specific utilities}

const
  ayThisYear = 0;
  ayNextYear = 1;
  ayHistory = 2;

var
  SelectedTaxRollYr : String;

{======================================================================}
Procedure TRollTotalDisplayForm.FormActivate(Sender: TObject);

begin
  InitializingForm := True;
  SetFormStateMaximized(Self);
end;

{======================================================================}
Procedure TRollTotalDisplayForm.InitializeForm;

{Open the tables.}

var
  Done, FirstTimeThrough : Boolean;
  I : Integer;

begin
  InitializingForm := True;
  OriginalGridWidth := DisplayStringGrid.Width;
  ColumnSizeFactor := 1;
  UnitName := 'RTDISPLY.PAS';  {mmm}

  OpenTablesForForm(Self, NextYear);

  FirstTimeThrough := True;
  Done := False;
  SwisCodeTable.First;

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
                                    FieldByName('MunicipalityName').Text);

  until Done;

    {Default to all swis codes.}

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    SwisCodeListBox.Selected[I] := True;

  SelectedSwisCodes := TStringList.Create;

  case GlblProcessingType of
    ThisYear : TaxYearRadioGroup.ItemIndex := ayThisYear;
    NextYear : TaxYearRadioGroup.ItemIndex := ayNextYear;
    History : TaxYearRadioGroup.ItemIndex := ayHistory;

  end;  {case GlblProcessingType of}

    {FXX05012002-1: Make sure that we don't show the calculate roll totals button if
                    they can't recalculate totals.}

  CalculateButton.Visible := GlblCanCalculateRollTotals;
  InitializingForm := False;

end;  {InitializeForm}

{===================================================================}
Procedure TRollTotalDisplayForm.FormResize(Sender: TObject);

begin
    {CHG09102004-1(2.8.0.11): Resize the grid font for a change.}

  If ((not InitializingForm) and
      (DisplayStringGrid.Width <> OriginalGridWidth) and
      (OriginalGridWidth > 0))
    then
      begin
        ResizeStringGridFontForWidthChange(DisplayStringGrid, OriginalGridWidth, ColumnSizeFactor);

        OriginalGridWidth := DisplayStringGrid.Width;

        ReturnButton3.Left := DisplayFooterPanel.Width - 100;
        TitleLabel.Left := (TitlePanel.Width - TitleLabel.Width) DIV 2;

      end;  {If (DisplayStringGrid.Width <> OriginalGridWidth)}

end;  {FormResize}

{===================================================================}
Procedure TRollTotalDisplayForm.TaxYearRadioGroupClick(Sender: TObject);

{FXX1004199-6: Allow history roll totals print.}

begin
  case TaxYearRadioGroup.ItemIndex of
    0, 1 : begin
             HistoryEdit.Text := '';
             HistoryEdit.Visible := False;
           end;

    2 : begin
          HistoryEdit.Visible := True;
          HistoryEdit.SetFocus;
        end;

  end;  {case TaxYearRadioGroup.ItemIndex of}

end;  {TaxYearRadioGroupClick}

{===================================================================}
{===========   SWIS CODE DISPLAY  ==================================}
{===================================================================}
Procedure InitializeSwisTotalPtr(SwisTotalsPtr : RTSwisCodeTotalsPtr);

{CHG11131997-1: Display the totals by swis and municipality.}

begin
  with SwisTotalsPtr^ do
    begin
      ParcelCount    := 0;
      PartCount      := 0;
      AssessedValue  := 0;
      CountyTaxable  := 0;
      TownTaxable    := 0;
      VillageTaxable := 0;

    end;  {with SwisTotalsPtr^ do}

end;  {InitializeSwisTotalPtr}

{==========================================================================================}
Procedure UpdateSwisTotals(SwisCodePtr,
                           BySwisCodeHstdTotals,
                           BySwisCodeNonHstdTotals,
                           OverallHstdTotals,
                           OverallNonHstdTotals : RTSwisCodeTotalsPtr);

{CHG11131997-1: Display the totals by swis and municipality.}

begin
  with SwisCodePtr^ do
    begin
      If (Take(1, HomesteadCode)[1] in [' ', 'H'])
        then
          begin
            BySwisCodeHstdTotals^.ParcelCount    := BySwisCodeHstdTotals^.ParcelCount + ParcelCount;
            BySwisCodeHstdTotals^.PartCount      := BySwisCodeHstdTotals^.PartCount + PartCount;
            BySwisCodeHstdTotals^.AssessedValue  := BySwisCodeHstdTotals^.AssessedValue + AssessedValue;
            BySwisCodeHstdTotals^.CountyTaxable  := BySwisCodeHstdTotals^.CountyTaxable + CountyTaxable;
            BySwisCodeHstdTotals^.TownTaxable    := BySwisCodeHstdTotals^.TownTaxable + TownTaxable;
            BySwisCodeHstdTotals^.VillageTaxable := BySwisCodeHstdTotals^.VillageTaxable + VillageTaxable;

            OverallHstdTotals^.ParcelCount    := OverallHstdTotals^.ParcelCount + ParcelCount;
            OverallHstdTotals^.PartCount      := OverallHstdTotals^.PartCount + PartCount;
            OverallHstdTotals^.AssessedValue  := OverallHstdTotals^.AssessedValue + AssessedValue;
            OverallHstdTotals^.CountyTaxable  := OverallHstdTotals^.CountyTaxable + CountyTaxable;
            OverallHstdTotals^.TownTaxable    := OverallHstdTotals^.TownTaxable + TownTaxable;
            OverallHstdTotals^.VillageTaxable := OverallHstdTotals^.VillageTaxable + VillageTaxable;

          end  {If (Take(1, HomesteadCode)[1] = [' ', 'H')}
        else
          begin
            BySwisCodeNonHstdTotals^.ParcelCount    := BySwisCodeNonHstdTotals^.ParcelCount + ParcelCount;
            BySwisCodeNonHstdTotals^.PartCount      := BySwisCodeNonHstdTotals^.PartCount + PartCount;
            BySwisCodeNonHstdTotals^.AssessedValue  := BySwisCodeNonHstdTotals^.AssessedValue + AssessedValue;
            BySwisCodeNonHstdTotals^.CountyTaxable  := BySwisCodeNonHstdTotals^.CountyTaxable + CountyTaxable;
            BySwisCodeNonHstdTotals^.TownTaxable    := BySwisCodeNonHstdTotals^.TownTaxable + TownTaxable;
            BySwisCodeNonHstdTotals^.VillageTaxable := BySwisCodeNonHstdTotals^.VillageTaxable + VillageTaxable;

            OverallNonHstdTotals^.ParcelCount    := OverallNonHstdTotals^.ParcelCount + ParcelCount;
            OverallNonHstdTotals^.PartCount      := OverallNonHstdTotals^.PartCount + PartCount;
            OverallNonHstdTotals^.AssessedValue  := OverallNonHstdTotals^.AssessedValue + AssessedValue;
            OverallNonHstdTotals^.CountyTaxable  := OverallNonHstdTotals^.CountyTaxable + CountyTaxable;
            OverallNonHstdTotals^.TownTaxable    := OverallNonHstdTotals^.TownTaxable + TownTaxable;
            OverallNonHstdTotals^.VillageTaxable := OverallNonHstdTotals^.VillageTaxable + VillageTaxable;

          end;  {else of If (Take(1, HomesteadCode)[1] = [' ', 'H'])}

    end;  {with SwisCodePtr^ do}

end;  {UpdateSwisTotals}

{==========================================================================================}
Procedure TRollTotalDisplayForm.DisplayOneSwisLine(    SwisCodePtr : RTSwisCodeTotalsPtr;
                                                   var RowNum : Integer;
                                                       TotalsRecord,
                                                       ShowHomesteadCodes : Boolean;
                                                       TotalsTitle1,
                                                       TotalsTitle2 : String);

{CHG11131997-1: Display the totals by swis and municipality.}

begin
  with DisplayStringGrid, SwisCodePtr^ do
    begin
      If ((RowNum + 1) > RowCount)
        then RowCount := RowNum + 1;

      If TotalsRecord
        then Cells[0, RowNum] := TotalsTitle1
        else Cells[0, RowNum] := SwisCode;

      If (ShowHomesteadCodes and
          (Deblank(HomesteadCode) <> ''))
        then
          begin
            If TotalsRecord
              then Cells[1, RowNum] := TotalsTitle2 + '-' + HomesteadCode
              else Cells[1, RowNum] := RollSection + ' - ' + HomesteadCode;

          end
        else
          If TotalsRecord
            then Cells[1, RowNum] := TotalsTitle2
            else Cells[1, RowNum] := RollSection;

      Cells[2, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, AssessedValue);

        {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      If (rtdCounty in GlblRollTotalsToShow)
        then Cells[3, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, CountyTaxable);
      If (rtdMunicipal in GlblRollTotalsToShow)
        then Cells[4, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, TownTaxable);
      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Cells[5, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, VillageTaxable);

        {FXX11071997-4: Display the parts amounts for split parcels.
                        To do this, we will add the parcel count and
                        half the part count since it will be double counted.}
        {FXX11091997-3: Don't have to divide part count by 2 since not
                        being overcounted on an individual homestead
                        rec basis.}

      If ShowHomesteadCodes
        then Cells[6, RowNum] := IntToStr(ParcelCount + PartCount)
        else Cells[6, RowNum] := IntToStr(ParcelCount + (PartCount DIV 2));

    end;  {with DisplayStringGrid, SwisCodePtr^ do}

end;  {DisplayOneSwisLine}

{==========================================================================================}
Procedure TRollTotalDisplayForm.DisplayTotals_OneSwisCode(    DisplayStringGrid : TStringGrid;
                                                              LastSwisCode : String;
                                                              BySwisHstdTotals,
                                                              BySwisNonHstdTotals : RTSwisCodeTotalsPtr;
                                                              ShowHomesteadCodes : Boolean;
                                                          var RowNum : Integer);

var
  J : Integer;

begin
  with DisplayStringGrid do
    For J := 0 to (ColCount - 1) do
      Cells[ColCount, RowNum] := '';

  RowNum := RowNum + 1;

    {CHG11131997-1: Display the totals by swis and municipality.}

    {FXX11301997-4: Show hstd and nonhstd BySwiss if they want by
                    hstd code.}

  If ShowHomesteadCodes
    then
      begin
        DisplayOneSwisLine(BySwisHstdTotals,
                           RowNum, True, ShowHomesteadCodes,
                           LastSwisCode, 'TOT');
        RowNum := RowNum + 1;
        DisplayOneSwisLine(BySwisNonHstdTotals,
                           RowNum, True, ShowHomesteadCodes,
                           LastSwisCode, 'TOT');
        RowNum := RowNum + 1;
        RowNum := RowNum + 1;

          {Now combine non-hstd into hstd so that can display
           BySwis (w.out regard to hstd code) totals.}

        with BySwisHstdTotals^ do
          begin
            ParcelCount    := ParcelCount + BySwisNonHstdTotals^.ParcelCount;
            PartCount      := PartCount + BySwisNonHstdTotals^.PartCount;
            AssessedValue  := AssessedValue + BySwisNonHstdTotals^.AssessedValue;
            CountyTaxable  := CountyTaxable + BySwisNonHstdTotals^.CountyTaxable;
            TownTaxable    := TownTaxable + BySwisNonHstdTotals^.TownTaxable;
            VillageTaxable := VillageTaxable + BySwisNonHstdTotals^.VillageTaxable;

          end;  {with BySwisHstdTotals^ do}

      end;  {If ShowHomesteadCodes}

    {Now display the BySwis totals. Note that if they wanted by hstd
     code, we already combined non-hstd into hstd.}

  DisplayOneSwisLine(BySwisHstdTotals,
                     RowNum, True, False,
                     LastSwisCode, 'TOTAL');

  RowNum := RowNum + 1;
  RowNum := RowNum + 1;

end;  {DisplayTotals_OneSwisCode}

{==========================================================================================}
Procedure TRollTotalDisplayForm.DisplaySwisCodes(ProcessingType : Integer;
                                                 ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                                                 TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                                                 SelectedSwisCodes : TStringList);

{Display the swis codes.}

var
  Quit : Boolean;
  LastSwisCode : String;

  BySwisHstdTotals,
  BySwisNonhstdTotals,
  OverallHstdTotals,
  OverallNonhstdTotals : RTSwisCodeTotalsPtr;
  I, J, RowNum : Integer;
  DisplayList : TList;
  RTSwisCodeTable : TTable;

begin
  DisplayList := TList.Create;
  Quit := False;

  New(BySwisHstdTotals);
  New(BySwisNonhstdTotals);
  New(OverallHstdTotals);
  New(OverallNonhstdTotals);

  InitializeSwisTotalPtr(BySwisHstdTotals);
  InitializeSwisTotalPtr(BySwisNonhstdTotals);
  InitializeSwisTotalPtr(OverallHstdTotals);
  InitializeSwisTotalPtr(OverallNonhstdTotals);

  OverallHstdTotals^.HomesteadCode := 'H';
  OverallNonhstdTotals^.HomesteadCode := 'N';

  with DisplayStringGrid do
    For I := 0 to (ColCount - 1) do
      For J := 0 to (RowCount - 1) do
        Cells[I, J] := '';

  RTSwisCodeTable := TTable.Create(nil);

  OpenTableForProcessingType(RTSwisCodeTable, RTBySwisCodeTableName,
                             ProcessingType, Quit);

  If (RTSwisCodeTable.RecordCount > 0)
    then
      begin
          {CHG12031998-1: Move definitions of roll total lists here so that the load procs can be
                          shared by Roll total display and print.}
          {FXX10041999-7: Make sure to pass the year in for history load.}

        LoadTotalsByRollSectionList(DisplayList, RTSwisCodeTable,
                                    SelectedSwisCodes, TotalsOnly, ShowHomesteadCodes, SelectedTaxRollYr);

          {Now display the totals.}

        with DisplayStringGrid do
          begin
            RowCount := DisplayList.Count;
            ColCount := 7;

            Cells[0,0] := 'SWIS';
            Cells[1,0] := 'RS';
            Cells[2,0] := 'ASSESSED';

              {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

            If (rtdCounty in GlblRollTotalsToShow)
              then Cells[3,0] := 'CNTY TXBL';
            If (rtdMunicipal in GlblRollTotalsToShow)
              then Cells[4,0] := UpcaseStr(GetShortMunicipalityTypeName(GlblMunicipalityType)) + ' TXBL';
            If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
              then Cells[5,0] := 'VILL TXBL';

              {FXX11071997-4: Show parcels and parts.}

            If ShowHomesteadCodes
              then Cells[6,0] := 'PRC&PART'
              else Cells[6,0] := 'PRCL CNT';

            ColWidths[0] := Trunc(60 * ColumnSizeFactor);
            ColWidths[1] := Trunc(43 * ColumnSizeFactor);
            ColWidths[2] := Trunc(102 * ColumnSizeFactor);
            ColWidths[3] := Trunc(102 * ColumnSizeFactor);
            ColWidths[4] := Trunc(102 * ColumnSizeFactor);
            ColWidths[5] := Trunc(102 * ColumnSizeFactor);
            ColWidths[6] := Trunc(85 * ColumnSizeFactor);

          end;  {with DisplayStringGrid do}

       LastSwisCode := '';
       RowNum := 1;

       For I := 0 to (DisplayList.Count - 1) do
         with DisplayStringGrid, RTSwisCodeTotalsPtr(DisplayList[I])^ do
           begin
               {FXX11041997-4: Add a blank space when switching between
                               swis codes.}

             If ((Deblank(LastSwisCode) <> '') and
                 (LastSwisCode <> SwisCode))
               then
                 begin
                   DisplayTotals_OneSwisCode(DisplayStringGrid, LastSwisCode, BySwisHstdTotals,
                                             BySwisNonHstdTotals, ShowHomesteadCodes, RowNum);

                     {Initialize the totals pointers for the next swis code.}

                   Dispose(BySwisHstdTotals);
                   Dispose(BySwisNonhstdTotals);
                   New(BySwisHstdTotals);
                   New(BySwisNonhstdTotals);

                   InitializeSwisTotalPtr(BySwisHstdTotals);
                   InitializeSwisTotalPtr(BySwisNonhstdTotals);

                 end;  {If ((Deblank(LastSwisCode) <> '') and ...}

               {FXX11301997-3: The ShowHomesteadCodes and TotalsRecord
                               were switched in the call to
                               DisplayOneSwisLine.}

             DisplayOneSwisLine(RTSwisCodeTotalsPtr(DisplayList[I]),
                                RowNum, False, ShowHomesteadCodes,
                                '', '');

               {CHG11131997-1: Display the totals by swis and municipality.}

             UpdateSwisTotals(RTSwisCodeTotalsPtr(DisplayList[I]),
                              BySwisHstdTotals,
                              BySwisNonHstdTotals,
                              OverallHstdTotals,
                              OverallNonHstdTotals);

             RowNum := RowNum + 1;

             If (RowNum > DisplayStringGrid.RowCount)
               then DisplayStringGrid.RowCount := DisplayStringGrid.RowCount + 1;

             LastSwisCode := SwisCode;

           end;  {with DisplayStringGrid, RTSwisCodeTotalsPtr(DisplayList[I])^ do}

           {CHG11131997-1: Display the totals by swis and municipality.}

          {FXX10271999-1: Was not displaying totals for the last swis if displayed by swis code.}

        If (Length(LastSwisCode) = 6)
          then DisplayTotals_OneSwisCode(DisplayStringGrid, LastSwisCode, BySwisHstdTotals,
                                         BySwisNonHstdTotals, ShowHomesteadCodes, RowNum);

          {FXX11301997-4: Show hstd and nonhstd overalls if they want by
                          hstd code.}

        If ShowHomesteadCodes
          then
            begin
                {FXX12172001-2: Only do a take 2 on the swis code for villages
                                that go across 2 towns.}

              DisplayOneSwisLine(OverallHstdTotals,
                                 RowNum, True, ShowHomesteadCodes,
                                 Take(2, LastSwisCode), 'TOT');
              RowNum := RowNum + 1;
              DisplayOneSwisLine(OverallNonHstdTotals,
                                 RowNum, True, ShowHomesteadCodes,
                                 Take(2, LastSwisCode), 'TOT');
              RowNum := RowNum + 1;

                {Now combine non-hstd into hstd so that can display
                 overall (w.out regard to hstd code) totals.}

              with OverallHstdTotals^ do
                begin
                  ParcelCount    := ParcelCount + OverallNonHstdTotals^.ParcelCount;
                  PartCount      := PartCount + OverallNonHstdTotals^.PartCount;
                  AssessedValue  := AssessedValue + OverallNonHstdTotals^.AssessedValue;
                  CountyTaxable  := CountyTaxable + OverallNonHstdTotals^.CountyTaxable;
                  TownTaxable    := TownTaxable + OverallNonHstdTotals^.TownTaxable;
                  VillageTaxable := VillageTaxable + OverallNonHstdTotals^.VillageTaxable;

                end;  {with OverallHstdTotals^ do}

            end;  {If ShowHomesteadCodes}

          {Now display the overall totals. Note that if they wanted by hstd
           code, we already combined non-hstd into hstd.}
          {FXX12172001-2: Only do a take 2 on the swis code for villages
                          that go across 2 towns.}

        RowNum := RowNum + 1;
        DisplayOneSwisLine(OverallHstdTotals,
                           RowNum, True, False,
                           Take(2, LastSwisCode), 'TOTAL');

      end
    else MessageDlg('The roll totals by swis file is empty.' + #13 +
                    'Please run the roll totals calculation menu selection.',
                    mtError, [mbOK], 0);

  RTSwisCodeTable.Close;
  RTSwisCodeTable.Free;

  Dispose(BySwisHstdTotals);
  Dispose(BySwisNonhstdTotals);
  Dispose(OverallHstdTotals);
  Dispose(OverallNonhstdTotals);

end;  {DisplaySwisCodes}

{===================================================================}
{=============  SD CODE DISPLAY  ===================================}
{===================================================================}
Function GetSDCodeName(SDCodeLookupTable : TTable;
                       SDCode : String) : String;

{FXX11041997-2: Look up by the SDCode only - not year and SDCode, since the
                year was wrong.}

var
  Found : Boolean;

begin
  Found := FindKeyOld(SDCodeLookupTable, ['SDistCode'], [SDCode]);

  If Found
    then Result := SDCodeLookupTable.FieldByName('Description').AsString
    else Result := 'UNKNOWN';

end;  {GetSDCodeName}

{===================================================================}
Function GetSDExtCodeName(SDExtCodeLookupTable : TTable;
                          ExtCode : String) : String;

var
  Found : Boolean;

begin
  Found := FindKeyOld(SDExtCodeLookupTable, ['MainCode'], [ExtCode]);

  If Found
    then Result := Take(30, SDExtCodeLookupTable.FieldByName('Description').Text)
    else Result := 'UNKNOWN';

end;  {GetSDExtCodeName}

{==========================================================================================}
Procedure TRollTotalDisplayForm.DisplaySDCodes(ProcessingType : Integer;
                                               TotalsOnly : Boolean;
                                               SelectedSwisCodes : TStringList;
                                               ProratasOnly : Boolean);

var
  Quit : Boolean;
  LastSwisCode : String;
  I, J, RowNum : Integer;
  DisplayList : TList;
  RTSDCodeTable, SDCodeLookupTable, SDExtCodeLookupTable : TTable;

begin
  DisplayList := TList.Create;
  Quit := False;

  with DisplayStringGrid do
    For I := 0 to (ColCount - 1) do
      For J := 0 to (RowCount - 1) do
        Cells[I, J] := '';

  RTSDCodeTable := TTable.Create(nil);
  SDCodeLookupTable := TTable.Create(nil);
  SDExtCodeLookupTable := TTable.Create(nil);

  RTSDCodeTable.IndexName := 'BYYR_SWIS_SD_EXTENSION_CCOM';
  SDCodeLookupTable.IndexName := 'BYSDISTCODE';
  SDExtCodeLookupTable.IndexName := 'BYMAINCODE';

  OpenTableForProcessingType(RTSDCodeTable, RTBySDCodeTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(SDCodeLookupTable, SdistCodeTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(SDExtCodeLookupTable, 'ZSDExtCodeTbl',
                             ProcessingType, Quit);

  If (RTSDCodeTable.RecordCount > 0)
    then
      begin
          {CHG12031998-1: Move definitions of roll total lists here so that the load procs can be
                          shared by Roll total display and print.}
          {FXX10041999-7: Make sure to pass the year in for history load.}

        LoadTotalsBySpecialDistrictList(DisplayList, RTSDCodeTable,
                                        SelectedSwisCodes, TotalsOnly,
                                        ShowHomesteadCode, ProratasOnly, SelectedTaxRollYr);

          {Now display the totals.}
          {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

        with DisplayStringGrid do
          begin
            ColCount := 8;
            RowCount := DisplayList.Count + 1;

            Cells[0,0] := 'SWIS';
            Cells[1,0] := 'SD CODE';
            Cells[2,0] := 'SD NAME';
            Cells[3,0] := 'HSTD';
            Cells[4,0] := 'EXT DESCR ';
            Cells[5,0] := 'CC/OM';
            Cells[6,0] := 'TAXABLE VAL';
            Cells[7,0] := '# PRCLS';

            ColWidths[0] := Trunc(55 * ColumnSizeFactor);
            ColWidths[1] := Trunc(60 * ColumnSizeFactor);
            ColWidths[2] := Trunc(155 * ColumnSizeFactor);
            ColWidths[3] := Trunc(35 * ColumnSizeFactor);
            ColWidths[4] := Trunc(100 * ColumnSizeFactor);
            ColWidths[5] := Trunc(45 * ColumnSizeFactor);
            ColWidths[6] := Trunc(90 * ColumnSizeFactor);
            ColWidths[7] := Trunc(55 * ColumnSizeFactor);

          end;  {with DisplayStringGrid do}

       LastSwisCode := '';
       RowNum := 1;

       For I := 0 to (DisplayList.Count - 1) do
         with DisplayStringGrid, RTSDCodeTotalsPtr(DisplayList[I])^ do
           begin
               {FXX11041997-4: Add a blank space when switching between
                               swis codes.}

             If ((Deblank(LastSwisCode) <> '') and
                 (LastSwisCode <> SwisCode))
               then
                 begin
                   For J := 0 to (ColCount - 1) do
                     Cells[ColCount, RowNum] := '';

                   RowNum := RowNum + 1;

                 end;  {If ((Deblank(LastSwisCode) <> '') and ..}

             Cells[0, RowNum] := SwisCode;
             Cells[1, RowNum] := SDCode;
             Cells[2, RowNum] := Take(20, GetSDcodeName(SDCodeLookupTable, SDCode));
             Cells[3, RowNum] := HomesteadCode;
             Cells[4, RowNum] := Take(15, GetSDExtCodeName(SDExtCodeLookupTable, ExtensionCode));
             Cells[5, RowNum] := CCOMFlg;

               {FXX11041997-3: Format SD value based on type - acres and units should
                               have decimals, but ad valorums should not.}

             If (ExtensionCode = 'TO')
               then Cells[6, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, TaxableValue)
               else Cells[6, RowNum] := FormatFloat(DecimalDisplay, TaxableValue);

             Cells[7, RowNum] := IntToStr(ParcelCount);

             RowNum := RowNum + 1;
             LastSwisCode := SwisCode;

             If (RowNum >= DisplayStringGrid.RowCount)
               then DisplayStringGrid.RowCount := DisplayStringGrid.RowCount + 10;

           end;  {with DisplayStringGrid, RTSDCodeTotalsPtr(DisplayList[I])^ do}

      end
    else MessageDlg('The roll totals by special district file is empty.' + #13 +
                    'Please run the roll totals calculation menu selection.',
                    mtError, [mbOK], 0);

  RTSDCodeTable.Close;
  SDCodeLookupTable.Close;
  SDExtCodeLookupTable.Close;
  RTSDCodeTable.Free;
  SDCodeLookupTable.Free;
  SDExtCodeLookupTable.Free;

end;  {DisplaySDCodes}

{CHG08021999-2: Add roll section 9 totals.}
{==========================================================================================}
{==========================  RS9  =========================================================}
{==========================================================================================}
Procedure TRollTotalDisplayForm.DisplayRS9(ProcessingType : Integer;
                                           TotalsOnly : Boolean;
                                           SelectedSwisCodes : TStringList);

var
  Quit : Boolean;
  LastSwisCode : String;
  I, J, RowNum : Integer;
  DisplayList : TList;
  RTRS9Table, SDCodeLookupTable : TTable;
  TempRec : RtRS9Totals;

begin
  DisplayList := TList.Create;
  Quit := False;

  with DisplayStringGrid do
    For I := 0 to (ColCount - 1) do
      For J := 0 to (RowCount - 1) do
        Cells[I, J] := '';

  RTRS9Table := TTable.Create(nil);
  SDCodeLookupTable := TTable.Create(nil);

  RTRS9Table.IndexName := 'BYTAXROLLYR_SWISCODE_SD';
  SDCodeLookupTable.IndexName := 'BYSDISTCODE';

  OpenTableForProcessingType(RTRS9Table, RTByRS9TableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(SDCodeLookupTable, SdistCodeTableName,
                             ProcessingType, Quit);

  If (RTRS9Table.RecordCount > 0)
    then
      begin
          {CHG12031998-1: Move definitions of roll total lists here so that the load procs can be
                          shared by Roll total display and print.}
          {FXX10041999-7: Make sure to pass the year in for history load.}

        LoadTotalsByProrataList(DisplayList, RTRS9Table,
                                SelectedSwisCodes, TotalsOnly, SelectedTaxRollYr);

          {Now display the totals.}

        with DisplayStringGrid do
          begin
            ColCount := 5;
            RowCount := DisplayList.Count + 1;

            Cells[0,0] := 'SWIS';
            Cells[1,0] := 'SD CODE';
            Cells[2,0] := 'SD NAME';
            Cells[3,0] := 'AMOUNT';
            Cells[4,0] := 'PRCL CNT ';

            ColWidths[0] := Trunc(60 * ColumnSizeFactor);
            ColWidths[1] := Trunc(70 * ColumnSizeFactor);
            ColWidths[2] := Trunc(155 * ColumnSizeFactor);
            ColWidths[3] := Trunc(90 * ColumnSizeFactor);
            ColWidths[4] := Trunc(80 * ColumnSizeFactor);

          end;  {with DisplayStringGrid do}

       LastSwisCode := '';
       RowNum := 1;

       For I := 0 to (DisplayList.Count - 1) do
         with DisplayStringGrid, RTRS9TotalsPtr(DisplayList[I])^ do
           begin
             TempRec := RTRS9TotalsPtr(DisplayList[I])^;

               {FXX11041997-4: Add a blank space when switching between
                               swis codes.}

             If ((Deblank(LastSwisCode) <> '') and
                 (LastSwisCode <> SwisCode))
               then
                 begin
                   For J := 0 to (ColCount - 1) do
                     Cells[ColCount, RowNum] := '';

                   RowNum := RowNum + 1;

                 end;  {If ((Deblank(LastSwisCode) <> '') and ..}

             Cells[0, RowNum] := SwisCode;
             Cells[1, RowNum] := SDCode;
             Cells[2, RowNum] := Take(20, GetSDCodeName(SDCodeLookupTable, SDCode));
             Cells[3, RowNum] := FormatFloat(DecimalDisplay, Amount);
             Cells[4, RowNum] := IntToStr(ParcelCount);

             RowNum := RowNum + 1;
             LastSwisCode := SwisCode;

             If (RowNum >= DisplayStringGrid.RowCount)
               then DisplayStringGrid.RowCount := DisplayStringGrid.RowCount + 10;

           end;  {with DisplayStringGrid, RTRS9TotalsPtr(DisplayList[I])^ do}

      end
    else MessageDlg('The roll totals by roll section 9 file is empty.' + #13 +
                    'Please run the roll totals calculation menu selection.',
                    mtError, [mbOK], 0);

  RTRS9Table.Close;
  SDCodeLookupTable.Close;
  RTRS9Table.Free;
  SDCodeLookupTable.Free;

end;  {DisplayRS9s}

{===================================================================}
{==============  EX CODE DISPLAY  ==================================}
{===================================================================}
Function GetEXCodeName(EXCodeLookupTable : TTable;
                       EXCode : String) : String;

var
  Found : Boolean;

begin
  Found := FindKeyOld(EXCodeLookupTable, ['EXCode'], [EXCode]);

  If Found
    then Result := EXCodeLookupTable.FieldByName('Description').Text
    else Result := 'UNKNOWN';

end;  {GetEXCodeName}

{==========================================================================================}
Procedure TRollTotalDisplayForm.DisplayOneExemptionLine(    ExemptionCodePtr : RTEXCodeTotalsPtr;
                                                        var RowNum : Integer;
                                                            TotalsRecord,
                                                            ShowHomesteadCodes : Boolean;
                                                            EXCodeLookupTable : TTable;
                                                            TotalsTitle1,
                                                            TotalsTitle2 : String);

{CHG11131997-1: Display the totals by swis and municipality.}

begin
  with DisplayStringGrid, ExemptionCodePtr^ do
    begin
      If ((RowNum + 1) > RowCount)
        then RowCount := RowNum + 1;

      If TotalsRecord
        then Cells[0, RowNum] := TotalsTitle1
        else Cells[0, RowNum] := SwisCode;

      If (ShowHomesteadCodes and
          (Deblank(HomesteadCode) <> ''))
        then
          begin
            If TotalsRecord
              then Cells[1, RowNum] := TotalsTitle2 + '-' + HomesteadCode
              else Cells[1, RowNum] := EXCode + ' - ' + HomesteadCode;

          end
        else
          If TotalsRecord
            then Cells[1, RowNum] := TotalsTitle2
            else Cells[1, RowNum] := EXCode;

      If TotalsRecord
        then Cells[2, RowNum] := ''
        else Cells[2, RowNum] := Take(20, GetEXCodeName(EXCodeLookupTable, EXCode));

       {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

      If (rtdCounty in GlblRollTotalsToShow)
        then Cells[3, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, CountyExAmount);
      If (rtdMunicipal in GlblRollTotalsToShow)
        then Cells[4, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, TownExAmount);
      If (rtdSchool in GlblRollTotalsToShow)
        then Cells[5, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, SchoolExAmount);
      If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
        then Cells[6, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, VillageExAmount);

        {FXX11071997-4: Display the parts amounts for split parcels.
                        To do this, we will add the parcel count and
                        half the part count since it will be double counted.}

        {FXX11091997-3: Don't have to divide part count by 2 since not
                        being overcounted on an individual homestead
                        rec basis.}
        {FXX02231999-3: Split parcels with exemptions will not be double counted
                        since they are on either H or N only. So, I am taking
                        away code that says IntToStr(ParcelCount + (PartCount DIV 2)).}

      Cells[7, RowNum] := IntToStr(ParcelCount + PartCount);

    end;  {with DisplayStringGrid, SwisCodePtr^ do}

end;  {DisplayOneExemptionLine}

{==========================================================================================}
Procedure TRollTotalDisplayForm.DisplayExemptionTotals_OneSwisCode(    DisplayStringGrid : TStringGrid;
                                                                       LastSwisCode : String;
                                                                       BySwisHstdTotals,
                                                                       BySwisNonHstdTotals : RTEXCodeTotalsPtr;
                                                                       ShowHomesteadCodes : Boolean;
                                                                       EXCodeLookupTable : TTable;
                                                                   var RowNum : Integer);

var
  J : Integer;

begin
  with DisplayStringGrid do
    For J := 0 to (ColCount - 1) do
      Cells[ColCount, RowNum] := '';

  RowNum := RowNum + 1;

    {CHG11131997-1: Display the totals by swis and municipality.}

    {FXX11301997-4: Show hstd and nonhstd BySwiss if they want by
                    hstd code.}

  If ShowHomesteadCodes
    then
      begin
        DisplayOneExemptionLine(BySwisHstdTotals,
                                RowNum, True, ShowHomesteadCodes,
                                EXCodeLookupTable,
                                LastSwisCode, 'TOT');
        RowNum := RowNum + 1;
        DisplayOneExemptionLine(BySwisNonHstdTotals,
                                RowNum, True, ShowHomesteadCodes,
                                EXCodeLookupTable,
                                LastSwisCode, 'TOT');
        RowNum := RowNum + 1;
        RowNum := RowNum + 1;

          {Now combine non-hstd into hstd so that can display
           BySwis (w.out regard to hstd code) totals.}

        with BySwisHstdTotals^ do
          begin
            ParcelCount    := ParcelCount + BySwisNonHstdTotals^.ParcelCount;
            PartCount      := PartCount + BySwisNonHstdTotals^.PartCount;
            CountyEXAmount := CountyEXAmount + BySwisNonHstdTotals^.CountyEXAmount;
            TownEXAmount := TownEXAmount + BySwisNonHstdTotals^.TownEXAmount;
            VillageEXAmount := VillageEXAmount + BySwisNonHstdTotals^.VillageEXAmount;
            SchoolEXAmount := SchoolEXAmount + BySwisNonHstdTotals^.SchoolEXAmount;

          end;  {with BySwisHstdTotals^ do}

      end;  {If ShowHomesteadCodes}

    {Now display the BySwis totals. Note that if they wanted by hstd
     code, we already combined non-hstd into hstd.}

  DisplayOneExemptionLine(BySwisHstdTotals,
                          RowNum, True, False,
                          EXCodeLookupTable,
                          LastSwisCode, 'TOTAL');

  RowNum := RowNum + 1;
  RowNum := RowNum + 1;

end;  {DisplayExemptionTotals_OneSwisCode}

{===================================================================}
Procedure InitializeExemptionTotalPtr(ExemptionTotalsPtr : RTEXCodeTotalsPtr);

{CHG11131997-1: Display the totals by swis and municipality.}

begin
  with ExemptionTotalsPtr^ do
    begin
      ParcelCount    := 0;
      PartCount      := 0;
      CountyEXAmount := 0;
      TownEXAmount   := 0;
      SchoolEXAmount := 0;
      VillageEXAmount := 0;

    end;  {with ExemptionTotalsPtr^ do}

end;  {InitializeExemptionTotalPtr}

{==========================================================================================}
Procedure UpdateExemptionTotals(ExemptionCodePtr,
                                BySwisCodeHstdTotals,
                                BySwisCodeNonHstdTotals,
                                OverallHstdTotals,
                                OverallNonHstdTotals : RTEXCodeTotalsPtr);

{CHG11131997-1: Display the totals by swis and municipality.}

begin
  with ExemptionCodePtr^ do
    begin
      If (Take(1, HomesteadCode)[1] in [' ', 'H'])
        then
          begin
            BySwisCodeHstdTotals^.ParcelCount    := BySwisCodeHstdTotals^.ParcelCount + ParcelCount;
            BySwisCodeHstdTotals^.PartCount      := BySwisCodeHstdTotals^.PartCount + PartCount;
            BySwisCodeHstdTotals^.CountyEXAmount  := BySwisCodeHstdTotals^.CountyEXAmount + CountyEXAmount;
            BySwisCodeHstdTotals^.TownEXAmount  := BySwisCodeHstdTotals^.TownEXAmount + TownEXAmount;
            BySwisCodeHstdTotals^.SchoolEXAmount  := BySwisCodeHstdTotals^.SchoolEXAmount + SchoolEXAmount;
            BySwisCodeHstdTotals^.VillageEXAmount  := BySwisCodeHstdTotals^.VillageEXAmount + VillageEXAmount;

            OverallHstdTotals^.ParcelCount    := OverallHstdTotals^.ParcelCount + ParcelCount;
            OverallHstdTotals^.PartCount      := OverallHstdTotals^.PartCount + PartCount;
            OverallHstdTotals^.CountyEXAmount  := OverallHstdTotals^.CountyEXAmount + CountyEXAmount;
            OverallHstdTotals^.TownEXAmount  := OverallHstdTotals^.TownEXAmount + TownEXAmount;
            OverallHstdTotals^.SchoolEXAmount  := OverallHstdTotals^.SchoolEXAmount + SchoolEXAmount;
            OverallHstdTotals^.VillageEXAmount  := OverallHstdTotals^.VillageEXAmount + VillageEXAmount;

          end  {If (Take(1, HomesteadCode)[1] = [' ', 'H')}
        else
          begin
            BySwisCodeNonHstdTotals^.ParcelCount    := BySwisCodeNonHstdTotals^.ParcelCount + ParcelCount;
            BySwisCodeNonHstdTotals^.PartCount      := BySwisCodeNonHstdTotals^.PartCount + PartCount;
            BySwisCodeNonHstdTotals^.CountyEXAmount  := BySwisCodeNonHstdTotals^.CountyEXAmount + CountyEXAmount;
            BySwisCodeNonHstdTotals^.TownEXAmount  := BySwisCodeNonHstdTotals^.TownEXAmount + TownEXAmount;
            BySwisCodeNonHstdTotals^.SchoolEXAmount  := BySwisCodeNonHstdTotals^.SchoolEXAmount + SchoolEXAmount;
            BySwisCodeNonHstdTotals^.VillageEXAmount  := BySwisCodeNonHstdTotals^.VillageEXAmount + VillageEXAmount;

            OverallNonHstdTotals^.ParcelCount    := OverallNonHstdTotals^.ParcelCount + ParcelCount;
            OverallNonHstdTotals^.PartCount      := OverallNonHstdTotals^.PartCount + PartCount;
            OverallNonHstdTotals^.CountyEXAmount  := OverallNonHstdTotals^.CountyEXAmount + CountyEXAmount;
            OverallNonHstdTotals^.TownEXAmount  := OverallNonHstdTotals^.TownEXAmount + TownEXAmount;
            OverallNonHstdTotals^.SchoolEXAmount  := OverallNonHstdTotals^.SchoolEXAmount + SchoolEXAmount;
            OverallNonHstdTotals^.VillageEXAmount  := OverallNonHstdTotals^.VillageEXAmount + VillageEXAmount;

          end;  {else of If (Take(1, HomesteadCode)[1] = [' ', 'H'])}

    end;  {with SwisCodePtr^ do}

end;  {UpdateExemptionTotals}

{==========================================================================================}
Procedure TRollTotalDisplayForm.DisplayEXCodes(ProcessingType : Integer;
                                               ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                                               TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                                               SelectedSwisCodes : TStringList);

var
  Quit : Boolean;
  LastSwisCode : String;
  BySwisHstdTotals,
  BySwisNonhstdTotals,
  OverallHstdTotals,
  OverallNonhstdTotals : RTEXCodeTotalsPtr;
  I, J, RowNum : Integer;
  DisplayList : TList;
  RTEXCodeTable, EXCodeLookupTable : TTable;

begin
  DisplayList := TList.Create;
  Quit := False;

  New(BySwisHstdTotals);
  New(BySwisNonhstdTotals);
  New(OverallHstdTotals);
  New(OverallNonhstdTotals);

  InitializeExemptionTotalPtr(BySwisHstdTotals);
  InitializeExemptionTotalPtr(BySwisNonhstdTotals);
  InitializeExemptionTotalPtr(OverallHstdTotals);
  InitializeExemptionTotalPtr(OverallNonhstdTotals);

  OverallHstdTotals^.HomesteadCode := 'H';
  OverallNonhstdTotals^.HomesteadCode := 'N';

  with DisplayStringGrid do
    For I := 0 to (ColCount - 1) do
      For J := 0 to (RowCount - 1) do
        Cells[I, J] := '';

  RTEXCodeTable := TTable.Create(nil);
  EXCodeLookupTable := TTable.Create(nil);

  RTEXCodeTable.IndexName := 'BYTAXROLLYR_SWISCODE_EX_HC';
  EXCodeLookupTable.IndexName := 'BYEXCODE';

  OpenTableForProcessingType(RTEXCodeTable, RTByEXCodeTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(EXCodeLookupTable, ExemptionCodesTableName,
                             ProcessingType, Quit);

  If (RTEXCodeTable.RecordCount > 0)
    then
      begin
          {CHG12031998-1: Move definitions of roll total lists here so that the load procs can be
                          shared by Roll total display and print.}
          {FXX10041999-7: Make sure to pass the year in for history load.}

        LoadTotalsByExemptionList(DisplayList, RTEXCodeTable,
                                  SelectedSwisCodes, TotalsOnly, ShowHomesteadCode,
                                  SelectedTaxRollYr);

          {Now display the totals.}

        with DisplayStringGrid do
          begin
            RowCount := DisplayList.Count + 1;
            ColCount := 8;

            Cells[0,0] := 'SWIS';
            Cells[1,0] := 'EX CD';
            Cells[2,0] := 'EX NAME';

              {CHG01192004-1(2.08): Let each municipality decide what roll totals to display.}

            If (rtdCounty in GlblRollTotalsToShow)
              then Cells[3,0] := 'CNTY AMT';
            If (rtdMunicipal in GlblRollTotalsToShow)
              then Cells[4,0] := UpcaseStr(GetShortMunicipalityTypeName(GlblMunicipalityType)) + ' AMT';
            If (rtdSchool in GlblRollTotalsToShow)
              then Cells[5,0] := 'SCHL AMT';
            If (rtdVillageReceivingPartialRoll in GlblRollTotalsToShow)
              then Cells[6,0] := 'VILL AMT';

              {FXX11071997-4: Show parcels and parts.}

            If ShowHomesteadCodes
              then Cells[7,0] := 'PRC&PART'
              else Cells[7,0] := 'PRCL CNT';

              {FXX12031997-2: The exemption display grid was too big.}

            ColWidths[0] := Trunc(44 * ColumnSizeFactor);
            ColWidths[1] := Trunc(53 * ColumnSizeFactor);
            ColWidths[2] := Trunc(90 * ColumnSizeFactor);
            ColWidths[3] := Trunc(84 * ColumnSizeFactor);
            ColWidths[4] := Trunc(84 * ColumnSizeFactor);
            ColWidths[5] := Trunc(84 * ColumnSizeFactor);
            ColWidths[6] := Trunc(84 * ColumnSizeFactor);
            ColWidths[7] := Trunc(74 * ColumnSizeFactor);

          end;  {with DisplayStringGrid do}

       LastSwisCode := '';
       RowNum := 1;

       For I := 0 to (DisplayList.Count - 1) do
         with DisplayStringGrid, RTEXCodeTotalsPtr(DisplayList[I])^ do
           begin
               {FXX11041997-4: Add a blank space when switching between
                               swis codes.}

             If ((Deblank(LastSwisCode) <> '') and
                 (LastSwisCode <> SwisCode))
               then
                 begin
                   For J := 0 to (ColCount - 1) do
                     Cells[ColCount, RowNum] := '';

                   DisplayExemptionTotals_OneSwisCode(DisplayStringGrid, LastSwisCode,
                                                      BySwisHstdTotals,
                                                      BySwisNonHstdTotals,
                                                      ShowHomesteadCodes,
                                                      EXCodeLookupTable, RowNum);

                     {Initialize the totals pointers for the next swis code.}

                   Dispose(BySwisHstdTotals);
                   Dispose(BySwisNonhstdTotals);
                   New(BySwisHstdTotals);
                   New(BySwisNonhstdTotals);

                   InitializeExemptionTotalPtr(BySwisHstdTotals);
                   InitializeExemptionTotalPtr(BySwisNonhstdTotals);

                 end;  {If ((Deblank(LastSwisCode) <> '') and ...}

               {FXX11191999-5: There was a blank space between items - took out
                               a RowCount increment.}

             DisplayOneExemptionLine(RTEXCodeTotalsPtr(DisplayList[I]),
                                     RowNum, False, ShowHomesteadCodes,
                                     EXCodeLookupTable, '', '');

               {CHG11131997-1: Display the totals by swis and municipality.}

             UpdateExemptionTotals(RTEXCodeTotalsPtr(DisplayList[I]),
                                   BySwisHstdTotals,
                                   BySwisNonHstdTotals,
                                   OverallHstdTotals,
                                   OverallNonHstdTotals);

             LastSwisCode := SwisCode;
             RowNum := RowNum + 1;

             If (RowNum >= DisplayStringGrid.RowCount)
               then DisplayStringGrid.RowCount := DisplayStringGrid.RowCount + 10;

           end;  {with DisplayStringGrid, RTEXCodeTotalsPtr(DisplayList[I])^ do}

           {CHG11131997-1: Display the totals by swis and municipality.}

          {FXX10271999-1: Was not displaying totals for the last swis if displayed by swis code.}

        If (Length(LastSwisCode) = 6)
          then DisplayExemptionTotals_OneSwisCode(DisplayStringGrid, LastSwisCode, BySwisHstdTotals,
                                                  BySwisNonHstdTotals,
                                                  ShowHomesteadCodes,
                                                  EXCodeLookupTable, RowNum);

          {FXX11301997-4: Show hstd and nonhstd overalls if they want by
                          hstd code.}

        If ShowHomesteadCodes
          then
            begin
                {FXX12172001-2: Only do a take 2 on the swis code for villages
                                that go across 2 towns.}

              DisplayOneExemptionLine(OverallHstdTotals,
                                      RowNum, True, ShowHomesteadCodes,
                                      EXCodeLookupTable,
                                      Take(2, LastSwisCode), 'TOT');
              RowNum := RowNum + 1;
              DisplayOneExemptionLine(OverallNonHstdTotals,
                                      RowNum, True, ShowHomesteadCodes,
                                      EXCodeLookupTable,
                                      Take(2, LastSwisCode), 'TOT');
              RowNum := RowNum + 1;

                {Now combine non-hstd into hstd so that can display
                 overall (w.out regard to hstd code) totals.}

              with OverallHstdTotals^ do
                begin
                  ParcelCount    := ParcelCount + OverallNonHstdTotals^.ParcelCount;
                  PartCount      := PartCount + OverallNonHstdTotals^.PartCount;
                  CountyEXAmount := CountyEXAmount + OverallNonHstdTotals^.CountyEXAmount;
                  TownEXAmount := TownEXAmount + OverallNonHstdTotals^.TownEXAmount;
                  SchoolEXAmount := SchoolEXAmount + OverallNonHstdTotals^.SchoolEXAmount;
                  VillageEXAmount := VillageEXAmount + OverallNonHstdTotals^.VillageEXAmount;

                end;  {with OverallHstdTotals^ do}

            end;  {If ShowHomesteadCodes}

          {Now display the overall totals. Note that if they wanted by hstd
           code, we already combined non-hstd into hstd.}
          {FXX12172001-2: Only do a take 2 on the swis code for villages
                          that go across 2 towns.}

        RowNum := RowNum + 1;
        DisplayOneExemptionLine(OverallHstdTotals,
                                RowNum, True, False,
                                EXCodeLookupTable,
                                Take(2, LastSwisCode), 'TOTAL');

      end
    else MessageDlg('The roll totals by exemption file is empty.' + #13 +
                    'Please run the roll totals calculation menu selection.',
                    mtError, [mbOK], 0);

  RTEXCodeTable.Close;
  EXCodeLookupTable.Close;
  RTEXCodeTable.Free;
  EXCodeLookupTable.Free;

  Dispose(BySwisHstdTotals);
  Dispose(BySwisNonhstdTotals);
  Dispose(OverallHstdTotals);
  Dispose(OverallNonhstdTotals);

end;  {ProcessEXCodes}

{===================================================================}
{==========   SCHOOL CODE DISPLAY  =================================}
{===================================================================}
Function GetSchoolCodeName(SchoolCodeLookupTable : TTable;
                           SchoolCode : String) : String;

{FXX11041997-2: Look up by the SchoolCode only - not year and SchoolCode, since the
                year was wrong.}

var
  Found : Boolean;

begin
  Found := FindKeyOld(SchoolCodeLookupTable,
                      ['TaxRollYr', 'SchoolCode'],
                      [SelectedTaxRollYr, SchoolCode]);

  If Found
    then Result := Take(30, SchoolCodeLookupTable.FieldByName('SchoolName').Text)
    else Result := 'UNKNOWN';

end;  {GetSchoolCodeName}

{===================================================================}
Procedure InitializeSchoolTotalPtr(SchoolTotalsPtr : RTSchoolCodeTotalsPtr);

{CHG11131997-1: Display the totals by swis and municipality.}

begin
  with SchoolTotalsPtr^ do
    begin
      ParcelCount    := 0;
      PartCount      := 0;
      LandValue      := 0;
      AssessedValue  := 0;
      SchoolTaxable  := 0;
      RelevyCount    := 0;
      SchoolRelevyAmt    := 0;
      BasicSTARAmount    := 0;
      EnhancedSTARAmount := 0;
      BasicSTARCount     := 0;
      EnhancedSTARCount  := 0;

    end;  {with SchoolTotalsPtr^ do}

end;  {InitializeSchoolTotalPtr}

{==========================================================================================}
Procedure UpdateSchoolTotals(SchoolCodePtr,
                             BySwisCodeHstdTotals,
                             BySwisCodeNonHstdTotals,
                             OverallHstdTotals,
                             OverallNonHstdTotals : RTSchoolCodeTotalsPtr);

{CHG11131997-1: Display the totals by swis and municipality.}

begin
  with SchoolCodePtr^ do
    begin
      If (Take(1, HomesteadCode)[1] in [' ', 'H'])
        then
          begin
            BySwisCodeHstdTotals^.ParcelCount    := BySwisCodeHstdTotals^.ParcelCount + ParcelCount;
            BySwisCodeHstdTotals^.PartCount      := BySwisCodeHstdTotals^.PartCount + PartCount;
            BySwisCodeHstdTotals^.AssessedValue  := BySwisCodeHstdTotals^.AssessedValue + AssessedValue;
            BySwisCodeHstdTotals^.SchoolTaxable  := BySwisCodeHstdTotals^.SchoolTaxable + SchoolTaxable;
            BySwisCodeHstdTotals^.RelevyCount  := BySwisCodeHstdTotals^.RelevyCount + RelevyCount;
            BySwisCodeHstdTotals^.SchoolRelevyAmt  := BySwisCodeHstdTotals^.SchoolRelevyAmt + SchoolRelevyAmt;
            BySwisCodeHstdTotals^.BasicSTARAmount  := BySwisCodeHstdTotals^.BasicSTARAmount + BasicSTARAmount;
            BySwisCodeHstdTotals^.BasicSTARCount  := BySwisCodeHstdTotals^.BasicSTARCount + BasicSTARCount;
            BySwisCodeHstdTotals^.EnhancedSTARAmount  := BySwisCodeHstdTotals^.EnhancedSTARAmount + EnhancedSTARAmount;
            BySwisCodeHstdTotals^.EnhancedSTARCount  := BySwisCodeHstdTotals^.EnhancedSTARCount + EnhancedSTARCount;

            OverallHstdTotals^.ParcelCount    := OverallHstdTotals^.ParcelCount + ParcelCount;
            OverallHstdTotals^.PartCount      := OverallHstdTotals^.PartCount + PartCount;
            OverallHstdTotals^.AssessedValue  := OverallHstdTotals^.AssessedValue + AssessedValue;
            OverallHstdTotals^.SchoolTaxable  := OverallHstdTotals^.SchoolTaxable + SchoolTaxable;
            OverallHstdTotals^.RelevyCount  := OverallHstdTotals^.RelevyCount + RelevyCount;
            OverallHstdTotals^.SchoolRelevyAmt  := OverallHstdTotals^.SchoolRelevyAmt + SchoolRelevyAmt;
            OverallHstdTotals^.BasicSTARAmount  := OverallHstdTotals^.BasicSTARAmount + BasicSTARAmount;
            OverallHstdTotals^.BasicSTARCount  := OverallHstdTotals^.BasicSTARCount + BasicSTARCount;
            OverallHstdTotals^.EnhancedSTARAmount  := OverallHstdTotals^.EnhancedSTARAmount + EnhancedSTARAmount;
            OverallHstdTotals^.EnhancedSTARCount  := OverallHstdTotals^.EnhancedSTARCount + EnhancedSTARCount;

          end  {If (Take(1, HomesteadCode)[1] = [' ', 'H')}
        else
          begin
            BySwisCodeNonHstdTotals^.ParcelCount    := BySwisCodeNonHstdTotals^.ParcelCount + ParcelCount;
            BySwisCodeNonHstdTotals^.PartCount      := BySwisCodeNonHstdTotals^.PartCount + PartCount;
            BySwisCodeNonHstdTotals^.AssessedValue  := BySwisCodeNonHstdTotals^.AssessedValue + AssessedValue;
            BySwisCodeNonHstdTotals^.SchoolTaxable  := BySwisCodeNonHstdTotals^.SchoolTaxable + SchoolTaxable;
            BySwisCodeNonHstdTotals^.RelevyCount  := BySwisCodeNonHstdTotals^.RelevyCount + RelevyCount;
            BySwisCodeNonHstdTotals^.SchoolRelevyAmt  := BySwisCodeNonHstdTotals^.SchoolRelevyAmt + SchoolRelevyAmt;
            BySwisCodeNonHstdTotals^.BasicSTARAmount  := BySwisCodeNonHstdTotals^.BasicSTARAmount + BasicSTARAmount;
            BySwisCodeNonHstdTotals^.BasicSTARCount  := BySwisCodeNonHstdTotals^.BasicSTARCount + BasicSTARCount;
            BySwisCodeNonHstdTotals^.EnhancedSTARAmount  := BySwisCodeNonHstdTotals^.EnhancedSTARAmount + EnhancedSTARAmount;
            BySwisCodeNonHstdTotals^.EnhancedSTARCount  := BySwisCodeNonHstdTotals^.EnhancedSTARCount + EnhancedSTARCount;

            OverallNonHstdTotals^.ParcelCount    := OverallNonHstdTotals^.ParcelCount + ParcelCount;
            OverallNonHstdTotals^.PartCount      := OverallNonHstdTotals^.PartCount + PartCount;
            OverallNonHstdTotals^.AssessedValue  := OverallNonHstdTotals^.AssessedValue + AssessedValue;
            OverallNonHstdTotals^.SchoolTaxable  := OverallNonHstdTotals^.SchoolTaxable + SchoolTaxable;
            OverallNonHstdTotals^.RelevyCount  := OverallNonHstdTotals^.RelevyCount + RelevyCount;
            OverallNonHstdTotals^.SchoolRelevyAmt  := OverallNonHstdTotals^.SchoolRelevyAmt + SchoolRelevyAmt;
            OverallNonHstdTotals^.BasicSTARAmount  := OverallNonHstdTotals^.BasicSTARAmount + BasicSTARAmount;
            OverallNonHstdTotals^.BasicSTARCount  := OverallNonHstdTotals^.BasicSTARCount + BasicSTARCount;
            OverallNonHstdTotals^.EnhancedSTARAmount  := OverallNonHstdTotals^.EnhancedSTARAmount + EnhancedSTARAmount;
            OverallNonHstdTotals^.EnhancedSTARCount  := OverallNonHstdTotals^.EnhancedSTARCount + EnhancedSTARCount;

          end;  {else of If (Take(1, HomesteadCode)[1] = [' ', 'H'])}

    end;  {with SchoolCodePtr^ do}

end;  {UpdateSchoolTotals}

{==========================================================================================}
Procedure TRollTotalDisplayForm.DisplayOneSchoolLine(    SchoolCodePtr : RTSchoolCodeTotalsPtr;
                                                     var RowNum : Integer;
                                                         TotalsRecord,
                                                         ShowHomesteadCodes : Boolean;
                                                         SchoolCodeLookupTable : TTable;
                                                         TotalsTitle1,
                                                         TotalsTitle2 : String);

{CHG11131997-1: Display the totals by swis and municipality.}

begin
  with DisplayStringGrid, SchoolCodePtr^ do
    begin
      If ((RowNum + 1) > RowCount)
        then RowCount := RowNum + 1;

      If TotalsRecord
        then Cells[0, RowNum] := TotalsTitle1
        else Cells[0, RowNum] := SwisCode;

      If (ShowHomesteadCodes and
          (Deblank(HomesteadCode) <> ''))
        then
          begin
            If TotalsRecord
              then Cells[1, RowNum] := TotalsTitle2 + '-' + HomesteadCode
              else Cells[1, RowNum] := SchoolCode + ' - ' + HomesteadCode;

          end
        else
          If TotalsRecord
            then Cells[1, RowNum] := TotalsTitle2
            else Cells[1, RowNum] := SchoolCode;

      If TotalsRecord
        then Cells[2, RowNum] := ''
        else Cells[2, RowNum] := Take(20, GetSchoolCodeName(SchoolCodeLookupTable, SchoolCode));
      Cells[3, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, AssessedValue);
      Cells[4, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, SchoolTaxable);

        {FXX11071997-4: Display the parts amounts for split parcels.
                        To do this, we will add the parcel count and
                        half the part count since it will be double counted.}

        {FXX11091997-3: Don't have to divide part count by 2 since not
                        being overcounted on an individual homestead
                        rec basis.}

      If ShowHomesteadCodes
        then Cells[5, RowNum] := IntToStr(ParcelCount + PartCount)
        else Cells[5, RowNum] := IntToStr(ParcelCount + (PartCount DIV 2));

      Cells[6, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, BasicSTARAmount);
      Cells[7, RowNum] := IntToStr(BasicSTARCount);
      Cells[8, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign, EnhancedSTARAmount);
      Cells[9, RowNum] := IntToStr(EnhancedSTARCount);
      Cells[10, RowNum] := FormatFloat(CurrencyDisplayNoDollarSign,
                                       (SchoolTaxable - (BasicSTARAmount + EnhancedSTARAmount)));

      Cells[11, RowNum] := FormatFloat(CurrencyDecimalDisplay, SchoolRelevyAmt);
      Cells[12, RowNum] := IntToStr(RelevyCount);

    end;  {with DisplayStringGrid, SwisCodePtr^ do}

end;  {DisplayOneSchoolLine}

{==========================================================================================}
Procedure TRollTotalDisplayForm.DisplaySchoolTotals_OneSwisCode(    DisplayStringGrid : TStringGrid;
                                                                    LastSwisCode : String;
                                                                    BySwisHstdTotals,
                                                                    BySwisNonHstdTotals : RTSchoolCodeTotalsPtr;
                                                                    ShowHomesteadCodes : Boolean;
                                                                    SchoolCodeLookupTable : TTable;
                                                                var RowNum : Integer);

var
  J : Integer;

begin
  with DisplayStringGrid do
    For J := 0 to (ColCount - 1) do
      Cells[ColCount, RowNum] := '';

  RowNum := RowNum + 1;

    {CHG11131997-1: Display the totals by swis and municipality.}

    {FXX11301997-4: Show hstd and nonhstd BySwiss if they want by
                    hstd code.}

  If ShowHomesteadCodes
    then
      begin
        DisplayOneSchoolLine(BySwisHstdTotals,
                             RowNum, True, ShowHomesteadCodes,
                             SchoolCodeLookupTable,
                             LastSwisCode, 'TOT');
        RowNum := RowNum + 1;
        DisplayOneSchoolLine(BySwisNonHstdTotals,
                             RowNum, True, ShowHomesteadCodes,
                             SchoolCodeLookupTable,
                             LastSwisCode, 'TOT');
        RowNum := RowNum + 1;
        RowNum := RowNum + 1;

          {Now combine non-hstd into hstd so that can display
           BySwis (w.out regard to hstd code) totals.}

        with BySwisHstdTotals^ do
          begin
            ParcelCount    := ParcelCount + BySwisNonHstdTotals^.ParcelCount;
            PartCount      := PartCount + BySwisNonHstdTotals^.PartCount;
            AssessedValue  := AssessedValue + BySwisNonHstdTotals^.AssessedValue;
            SchoolTaxable  := SchoolTaxable + BySwisNonHstdTotals^.SchoolTaxable;
            BasicSTARAmount := BasicSTARAmount + BySwisNonHstdTotals^.BasicSTARAmount;
            BasicSTARCount := BasicSTARCount + BySwisNonHstdTotals^.BasicSTARCount;
            EnhancedSTARAmount := EnhancedSTARAmount + BySwisNonHstdTotals^.EnhancedSTARAmount;
            EnhancedSTARCount := EnhancedSTARCount + BySwisNonHstdTotals^.EnhancedSTARCount;
            SchoolRelevyAmt := SchoolRelevyAmt + BySwisNonHstdTotals^.SchoolRelevyAmt;
            RelevyCount := RelevyCount + BySwisNonHstdTotals^.RelevyCount;

          end;  {with BySwisHstdTotals^ do}

      end;  {If ShowHomesteadCodes}

    {Now display the BySwis totals. Note that if they wanted by hstd
     code, we already combined non-hstd into hstd.}

  DisplayOneSchoolLine(BySwisHstdTotals,
                       RowNum, True, False,
                       SchoolCodeLookupTable,
                       LastSwisCode, 'TOTAL');

  RowNum := RowNum + 1;
  RowNum := RowNum + 1;

end;  {DisplaySchoolTotals_OneSwisCode}

{==========================================================================================}
Procedure TRollTotalDisplayForm.DisplaySchoolCodes(ProcessingType : Integer;
                                                   ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                                                   TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                                                   SelectedSwisCodes : TStringList);

var
  Quit : Boolean;
  LastSwisCode : String;
  BySwisHstdTotals, BySwisNonhstdTotals,
  OverallHstdTotals, OverallNonhstdTotals : RTSchoolCodeTotalsPtr;
  I, J, RowNum : Integer;
  DisplayList : TList;
  RTSchoolCodeTable, SchoolCodeLookupTable : TTable;

begin
  DisplayList := TList.Create;
  Quit := False;

  New(BySwisHstdTotals);
  New(BySwisNonhstdTotals);
  New(OverallHstdTotals);
  New(OverallNonhstdTotals);

  InitializeSchoolTotalPtr(BySwisHstdTotals);
  InitializeSchoolTotalPtr(BySwisNonhstdTotals);
  InitializeSchoolTotalPtr(OverallHstdTotals);
  InitializeSchoolTotalPtr(OverallNonhstdTotals);

  OverallHstdTotals^.HomesteadCode := 'H';
  OverallNonhstdTotals^.HomesteadCode := 'N';

  with DisplayStringGrid do
    For I := 0 to (ColCount - 1) do
      For J := 0 to (RowCount - 1) do
        Cells[I, J] := '';

  RTSchoolCodeTable := TTable.Create(nil);
  SchoolCodeLookupTable := TTable.Create(nil);

  RTSchoolCodeTable.IndexName := 'BYYEAR_SWIS_SCHOOL_HC';
  SchoolCodeLookupTable.IndexName := 'BYTAXROLLYR_SCHOOLCODE';

  OpenTableForProcessingType(RTSchoolCodeTable, RTBySchoolCodeTableName,
                             ProcessingType, Quit);

  OpenTableForProcessingType(SchoolCodeLookupTable, SchoolCodeTableName,
                             ProcessingType, Quit);

  If (RTSchoolCodeTable.RecordCount > 0)
    then
      begin
          {CHG12031998-1: Move definitions of roll total lists here so that the load procs can be
                          shared by Roll total display and print.}
          {FXX10041999-7: Make sure to pass the year in for history load.}

        LoadTotalsBySchoolList(DisplayList, RTSchoolCodeTable,
                               SelectedSwisCodes, TotalsOnly, ShowHomesteadCodes, SelectedTaxRollYr);

          {Now display the totals.}

        with DisplayStringGrid do
          begin
            ColCount := 13;
            RowCount := DisplayList.Count + 1;

               {CHG07291999-1: Add STAR values and taxable vals to on-line totals.}

            Cells[0,0] := 'SWIS';
            Cells[1,0] := 'SCHOOL';
            Cells[2,0] := 'SCHL NAME';
            Cells[3,0] := 'ASSESSED';
            Cells[4,0] := 'SCHL TXBL';

              {FXX11071997-4: Show parcels and parts.}

            If ShowHomesteadCodes
              then Cells[5,0] := 'PRC&PART'
              else Cells[5,0] := 'PRCL CNT';

            Cells[6, 0] := 'BASIC STAR';
            Cells[7, 0] := '# BASIC';
            Cells[8, 0] := 'ENH STAR';
            Cells[9, 0] := '# ENH';
            Cells[10, 0] := 'TXBL W\STAR';
            Cells[11,0] := 'SCHL RLVY';
            Cells[12,0] := 'RLVY CNT';

            ColWidths[0] := Trunc(50 * ColumnSizeFactor);
            ColWidths[1] := Trunc(65 * ColumnSizeFactor);
            ColWidths[2] := Trunc(95 * ColumnSizeFactor);
            ColWidths[3] := Trunc(90 * ColumnSizeFactor);

              {FXX02182004-2(2.07l1): The column was increased from 80 to 85.}

            ColWidths[4] := Trunc(85 * ColumnSizeFactor);
            ColWidths[5] := Trunc(68 * ColumnSizeFactor);
            ColWidths[6] := Trunc(90 * ColumnSizeFactor);
            ColWidths[7] := Trunc(68 * ColumnSizeFactor);
            ColWidths[8] := Trunc(90 * ColumnSizeFactor);
            ColWidths[9] := Trunc(68 * ColumnSizeFactor);
            ColWidths[10] := Trunc(90 * ColumnSizeFactor);
            ColWidths[11] := Trunc(80 * ColumnSizeFactor);
            ColWidths[12] := Trunc(68 * ColumnSizeFactor);

          end;  {with DisplayStringGrid do}

       LastSwisCode := '';
       RowNum := 1;

       For I := 0 to (DisplayList.Count - 1) do
         with DisplayStringGrid, RTSchoolCodeTotalsPtr(DisplayList[I])^ do
           begin
               {FXX11041997-4: Add a blank space when switching between
                               swis codes.}

             If ((Deblank(LastSwisCode) <> '') and
                 (LastSwisCode <> SwisCode))
               then
                 begin
                   DisplaySchoolTotals_OneSwisCode(DisplayStringGrid, LastSwisCode, BySwisHstdTotals,
                                                   BySwisNonHstdTotals, ShowHomesteadCodes,
                                                   SchoolCodeLookupTable, RowNum);

                     {Initialize the totals pointers for the next swis code.}

                   Dispose(BySwisHstdTotals);
                   Dispose(BySwisNonhstdTotals);
                   New(BySwisHstdTotals);
                   New(BySwisNonhstdTotals);

                   InitializeSchoolTotalPtr(BySwisHstdTotals);
                   InitializeSchoolTotalPtr(BySwisNonhstdTotals);

                 end;  {If ((Deblank(LastSwisCode) <> '') and ...}

               {FXX11301997-3: The ShowHomesteadCodes and TotalsRecord
                               were switched in the call to
                               DisplayOneSwisLine.}

             DisplayOneSchoolLine(RTSchoolCodeTotalsPtr(DisplayList[I]),
                                  RowNum, False, ShowHomesteadCodes,
                                  SchoolCodeLookupTable, '', '');

               {CHG11131997-1: Display the totals by swis and municipality.}

             UpdateSchoolTotals(RTSchoolCodeTotalsPtr(DisplayList[I]),
                                BySwisHstdTotals,
                                BySwisNonHstdTotals,
                                OverallHstdTotals,
                                OverallNonHstdTotals);

             RowNum := RowNum + 1;
             LastSwisCode := SwisCode;

             If (RowNum >= DisplayStringGrid.RowCount)
               then DisplayStringGrid.RowCount := DisplayStringGrid.RowCount + 10;

           end;  {with DisplayStringGrid, RTSchoolCodeTotalsPtr(DisplayList[I])^ do}

           {CHG11131997-1: Display the totals by swis and municipality.}

          {FXX10271999-1: Was not displaying totals for the last swis if displayed by swis code.}

        If (Length(LastSwisCode) = 6)
          then DisplaySchoolTotals_OneSwisCode(DisplayStringGrid, LastSwisCode, BySwisHstdTotals,
                                               BySwisNonHstdTotals, ShowHomesteadCodes,
                                               SchoolCodeLookupTable, RowNum);

          {FXX11301997-4: Show hstd and nonhstd overalls if they want by
                          hstd code.}

        If ShowHomesteadCodes
          then
            begin
                {FXX12172001-2: Only do a take 2 on the swis code for villages
                                that go across 2 towns.}

              DisplayOneSchoolLine(OverallHstdTotals,
                                   RowNum, True, ShowHomesteadCodes,
                                   SchoolCodeLookupTable,
                                   Take(2, LastSwisCode), 'TOT');
              RowNum := RowNum + 1;
              DisplayOneSchoolLine(OverallNonHstdTotals,
                                   RowNum, True, ShowHomesteadCodes,
                                   SchoolCodeLookupTable,
                                   Take(2, LastSwisCode), 'TOT');
              RowNum := RowNum + 1;

                {Now combine non-hstd into hstd so that can display
                 overall (w.out regard to hstd code) totals.}

              with OverallHstdTotals^ do
                begin
                  ParcelCount    := ParcelCount + OverallNonHstdTotals^.ParcelCount;
                  PartCount      := PartCount + OverallNonHstdTotals^.PartCount;
                  AssessedValue  := AssessedValue + OverallNonHstdTotals^.AssessedValue;
                  SchoolTaxable  := SchoolTaxable + OverallNonHstdTotals^.SchoolTaxable;
                  BasicSTARAmount := BasicSTARAmount + OverallNonHstdTotals^.BasicSTARAmount;
                  BasicSTARCount := BasicSTARCount + OverallNonHstdTotals^.BasicSTARCount;
                  EnhancedSTARAmount := EnhancedSTARAmount + OverallNonHstdTotals^.EnhancedSTARAmount;
                  EnhancedSTARCount := EnhancedSTARCount + OverallNonHstdTotals^.EnhancedSTARCount;
                  SchoolRelevyAmt := SchoolRelevyAmt + OverallNonHstdTotals^.SchoolRelevyAmt;
                  RelevyCount := RelevyCount + OverallNonHstdTotals^.RelevyCount;

                end;  {with OverallHstdTotals^ do}

            end;  {If ShowHomesteadCodes}

          {Now display the overall totals. Note that if they wanted by hstd
           code, we already combined non-hstd into hstd.}
          {FXX12172001-2: Only do a take 2 on the swis code for villages
                          that go across 2 towns.}

        RowNum := RowNum + 1;
        DisplayOneSchoolLine(OverallHstdTotals,
                             RowNum, True, False,
                             SchoolCodeLookupTable,
                             Take(2, LastSwisCode), 'TOTAL');

      end
    else MessageDlg('The roll totals by school file is empty.' + #13 +
                    'Please run the roll totals calculation menu selection.',
                    mtError, [mbOK], 0);

  RTSchoolCodeTable.Close;
  SchoolCodeLookupTable.Close;
  RTSchoolCodeTable.Free;
  SchoolCodeLookupTable.Free;

  Dispose(BySwisHstdTotals);
  Dispose(BySwisNonhstdTotals);
  Dispose(OverallHstdTotals);
  Dispose(OverallNonhstdTotals);

end;  {DisplaySchoolCodes}

{CHG12091998-1:  Village relevy totals.}
{===================================================================}
{==========   Village Relevy DISPLAY  =================================}
{===================================================================}
Procedure TRollTotalDisplayForm.DisplayVillageRelevies(ProcessingType : Integer;
                                                       ShowHomesteadCodes,  {Do they want to see totals by homestead code?}
                                                       TotalsOnly : Boolean;  {Are these totals by swis or overall?}
                                                       SelectedSwisCodes : TStringList);

var
  Quit : Boolean;
  I, J, RowNum : Integer;
  DisplayList : TList;
  RTVillageRelevyTable : TTable;
  TotalVillageRelevy : Extended;
  TotalRelevyCount : LongInt;

begin
  DisplayList := TList.Create;
  Quit := False;
  TotalVillageRelevy := 0;
  TotalRelevyCount := 0;

  with DisplayStringGrid do
    For I := 0 to (ColCount - 1) do
      For J := 0 to (RowCount - 1) do
        Cells[I, J] := '';

  RTVillageRelevyTable := TTable.Create(nil);

  RTVillageRelevyTable.IndexName := 'BYYEAR_SWIS_HC';

  OpenTableForProcessingType(RTVillageRelevyTable, RTByVillageRelevyTableName,
                             ProcessingType, Quit);

  If (RTVillageRelevyTable.RecordCount > 0)
    then
      begin
          {CHG12031998-1: Move definitions of roll total lists here so that the load procs can be
                          shared by Roll total display and print.}
          {FXX10041999-7: Make sure to pass the year in for history load.}

        LoadTotalsByVillageRelevyList(DisplayList, RTVillageRelevyTable,
                                      SelectedSwisCodes, TotalsOnly, ShowHomesteadCodes,
                                      SelectedTaxRollYr);

          {Now display the totals.}

        with DisplayStringGrid do
          begin
            ColCount := 3;
            RowCount := DisplayList.Count + 1;

            Cells[0,0] := 'SWIS';
            Cells[1,0] := 'VIL RELEVY AMT';
            Cells[2,0] := 'RELEVY COUNT';

            ColWidths[0] := Trunc(60 * ColumnSizeFactor);
            ColWidths[1] := Trunc(110 * ColumnSizeFactor);
            ColWidths[2] := Trunc(110 * ColumnSizeFactor);

          end;  {with DisplayStringGrid do}

        RowNum := 1;

        For I := 0 to (DisplayList.Count - 1) do
          with DisplayStringGrid, RTVillageRelevyTotalsPtr(DisplayList[I])^ do
            begin
              If (ShowHomesteadCodes and
                  (Deblank(HomesteadCode) <> ''))
                then Cells[0, RowNum] := SwisCode + ' - ' + HomesteadCode
                else Cells[0, RowNum] := SwisCode;

              Cells[1, RowNum] := FormatFloat(CurrencyDecimalDisplay, RelevyAmount);
              Cells[2, RowNum] := IntToStr(RelevyCount);

              TotalVillageRelevy := TotalVillageRelevy + RelevyAmount;
              TotalRelevyCount := TotalRelevyCount + RelevyCount;

              RowNum := RowNum + 1;

              If (RowNum >= DisplayStringGrid.RowCount)
                then DisplayStringGrid.RowCount := DisplayStringGrid.RowCount + 10;

            end;  {with DisplayStringGrid, RTVillageRelevyTotalsPtr(DisplayList[I])^ do}

        If not TotalsOnly
          then
            begin
              RowNum := RowNum + 1;

              with DisplayStringGrid do
                begin
                  Cells[1, RowNum] := FormatFloat(CurrencyDecimalDisplay, TotalVillageRelevy);
                  Cells[2, RowNum] := IntToStr(TotalRelevyCount);
                end;

            end;  {If not TotalsOnly}

      end
    else MessageDlg('There are no village relevies.',
                    mtError, [mbOK], 0);

  RTVillageRelevyTable.Close;
  RTVillageRelevyTable.Free;

end;  {DisplayVillageRelevies}

{====================================================================}
Procedure TRollTotalDisplayForm.DisplayRollTotals;

{Display the 3rd notebook page and the roll totals they wanted to see.}

var
  I : Integer;
  Quit : Boolean;

begin
  Notebook.PageIndex := 2;
  SetTaxYearLabelForProcessingType(YearLabel, ProcessingType);

    {Make sure that the tax roll year appears in the header even if they are
     not actually in the history processing year.}

  If ((ProcessingType = History) and
      (not (YearLabel.Caption[1] in ['1', '2'])))
    then YearLabel.Caption := SelectedTaxRollYr + ' ' + YearLabel.Caption;

  SelectedSwisCodes.Clear;

  For I := 0 to (SwisCodeListBox.Items.Count - 1) do
    If (TotalsOnly or SwisCodeListBox.Selected[I])
      then SelectedSwisCodes.Add(Take(6, SwisCodeListBox.Items[I]));

  case FormatRadioGroup.ItemIndex of
    0 : DisplaySwisCodes(ProcessingType, ShowHomesteadCode,
                         TotalsOnly, SelectedSwisCodes);

    1 : DisplaySchoolCodes(ProcessingType, ShowHomesteadCode,
                           TotalsOnly, SelectedSwisCodes);

    2 : DisplaySDCodes(ProcessingType, TotalsOnly, SelectedSwisCodes, False);

    3 : DisplayEXCodes(ProcessingType, ShowHomesteadCode,
                       TotalsOnly, SelectedSwisCodes);

    4 : DisplayVillageRelevies(ProcessingType, ShowHomesteadCode, TotalsOnly, SelectedSwisCodes);

      {FXX12161998-2: Display proratas\omitteds.}

    5 : DisplayRS9(ProcessingType, TotalsOnly, SelectedSwisCodes);

  end;  {case FormatRadioGroup.ItemIndex of}

    {CHG04092004-1(2.08): Display the equalization rate, RAR and uniform percent of value,
                          but only if all swis codes are part of the same town.}
    {FXX07212004-1(2.08): Make sure to reopen the swis code for the correct processing type.}

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName, ProcessingType, Quit);

  If (ProcessingType = History)
    then SetFilterForHistoryYear(SwisCodeTable, SelectedTaxRollYr);

  If AllSwisCodesInSameMunicipality(SwisCodeTable)
    then
      begin
        with SwisCodeTable do
          begin
            EqualizationRateLabel.Caption := 'Equalization Rate: ' +
                                             FormatFloat(PercentageDisplay_2Decimals,
                                                         FieldByName('EqualizationRate').AsFloat);

            If (Roundoff(FieldByName('ResAssmntRatio').AsFloat, 2) > 0)
              then RARLabel.Caption := 'RAR: ' +
                                       FormatFloat(PercentageDisplay_2Decimals,
                                                   FieldByName('ResAssmntRatio').AsFloat)
              else RARLabel.Visible := False;

            UniformPercentOfValueLabel.Caption := 'Uniform % of Value: ' +
                                                  FormatFloat(PercentageDisplay_2Decimals,
                                                              FieldByName('UniformPercentValue').AsFloat);

          end;  {with SwisCodeTable do}
      end
    else
      begin
        EqualizationRateLabel.Visible := False;
        RARLabel.Visible := False;
        UniformPercentOfValueLabel.Visible := False;

      end;  {If AllSwisCodesInSameMunicipality(SwisCodeTable)}

end;  {DisplayRollTotals}

{====================================================================}
Procedure TRollTotalDisplayForm.CalculateButtonClick(Sender: TObject);

{CHG03282002-8: Let them calculate from the display and print screens.}

var
  TempStr, AssessmentYear : String;
  ProcessingType : Integer;

begin
  ProcessingType := GlblProcessingType;
(*  If (TaxYearRadioGroup.ItemIndex = ayHistory)
    then MessageDlg('Sorry, you can not recalculate roll totals for history.',
                    mtError, [mbOK], 0)
    else
      begin  *)
        case TaxYearRadioGroup.ItemIndex of
          ayThisYear : begin
                         TempStr := 'This Year';
                         ProcessingType := ThisYear;
                         AssessmentYear := GlblThisYear;
                       end;

          ayNextYear : begin
                         TempStr := 'Next Year';
                         ProcessingType := NextYear;
                         AssessmentYear := GlblNextYear;
                       end;

          ayHistory : begin
                         TempStr := 'History';
                         ProcessingType := History;
                         AssessmentYear := HistoryEdit.Text;
                       end;

        end;  {case TaxYearRadioGroup.ItemIndex of}

        CreateRollTotals(ProcessingType, AssessmentYear,
                         ProgressDialog, Self, False, True);

(*      end;  {else of If (TaxYearRadioGroup.ItemIndex = ayHistory)}   *)

end;  {CalculateButtonClick}

{====================================================================}
Function TRollTotalDisplayForm.RequiredInformationFilledIn : Boolean;

{Make sure that the user has filled in all the information they need.}

begin
  Result := True;

    {FXX1004199-6: Allow history roll totals print.}

  case TaxYearRadioGroup.ItemIndex of
    0 : SelectedTaxRollYr := GlblThisYear;
    1 : SelectedTaxRollYr := GlblNextYear;
    2 : SelectedTaxRollYr := HistoryEdit.Text;

    else
      begin
        MessageDlg('Please select a tax year.', mtError, [mbOK], 0);
        Result := False;
      end;

  end;  {case TaxYearRadioGroup.ItemIndex of}

  ProcessingType := GetProcessingTypeForTaxRollYear(SelectedTaxRollYr);

  case MunRadioGroup.ItemIndex of
    0 : TotalsOnly := False;
    1 : TotalsOnly := True;

    else
      begin
        MessageDlg('Please select a municipality type.', mtError, [mbOK], 0);
        Result := False;
      end;

  end;  {case MunRadioGroup.ItemIndex of}

  If (FormatRadioGroup.ItemIndex = -1)
    then
      begin
        MessageDlg('Please select a totals type.', mtError, [mbOK], 0);
        Result := False;
      end;

  ShowHomesteadCode := ShowHomesteadTotalsCheckBox.Checked;

end;  {RequiredInformationFilledIn}

{====================================================================}
Procedure TRollTotalDisplayForm.ShowTotalsButton1Click(Sender: TObject);

begin
    {FXX11021997-3: Check to make sure that all of the information is filled
                    in.}
    {FXX04121998-3: If grand totals for school districts, don't ask swis.}

    {CHG06092010-2(2.26.1)[I7371]: Force totals calculate before print.}

  If glblAutoCalcRollTotalsBeforePrint
  then CalculateButtonClick(nil);
    
  If RequiredInformationFilledIn
    then
      If TotalsOnly
        then DisplayRollTotals
        else Notebook.PageIndex := 1;  {Get the swis and/or school codes they want to see.}

end;  {ShowTotalsButton1Click}

{====================================================================}
Procedure TRollTotalDisplayForm.ReturnButton2Click(Sender: TObject);

{Go back from page 1 where can select swis and school codes.}

begin
  Notebook.PageIndex := 0;
end;

{====================================================================}
Procedure TRollTotalDisplayForm.ShowTotalsButton2Click(Sender: TObject);

begin
  DisplayRollTotals;
end;

{====================================================================}
Procedure TRollTotalDisplayForm.ReturnButton3Click(Sender: TObject);

begin
  Notebook.PageIndex := 0;
end;

{====================================================================}
Procedure TRollTotalDisplayForm.DisplayStringGridDrawCell(Sender: TObject;
                                                           Col, Row: Longint;
                                                           Rect: TRect;
                                                           State : TGridDrawState);

begin
  If ((Row = 0) or
      (Pos('NAME', DisplayStringGrid.Cells[Col, 0]) > 0))
    then
      begin
        DisplayStringGrid.Canvas.Pen.Color := clPurple;
        LeftJustifyText(Rect, DisplayStringGrid.Canvas,
                        DisplayStringGrid.Cells[Col,Row],
                        True,False,0,3);
      end
    else
      If (Col = 0)
        then DisplayStringGrid.Canvas.Brush.Color := clPurple
        else RightJustifyText(Rect, DisplayStringGrid.Canvas,
                 DisplayStringGrid.Cells[Col,Row],
                 True,False,0,3);

end;  {DisplayStringGridDrawCell}

{==========================================================================================}
Procedure TRollTotalDisplayForm.CloseOptionsButtonClick(Sender: TObject);

begin
  Close;
end;

{===================================================================}
Procedure TRollTotalDisplayForm.FormClose(    Sender: TObject;
                                       var Action: TCloseAction);

{Note that if we get here, we are definately closing the form
 since the CloseQuery event is called first. In CloseQuery, if
 there are any modifications, they have a chance to cancel
 then.}

begin
  SelectedSwisCodes.Free;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.