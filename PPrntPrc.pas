unit Pprntprc;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons, SysUtils,
  StdCtrls, ExtCtrls, RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, Types,
  JPEG, UPrntPrc, Dialogs;  {Print parcel information}

type
  TParcelPrintDialog = class(TForm)
    CancelButton: TBitBtn;
    GroupBox1: TGroupBox;
    ResidentialInventoryCheckBox: TCheckBox;
    CommercialInventoryCheckBox: TCheckBox;
    SalesCheckBox: TCheckBox;
    ExemptionCheckBox: TCheckBox;
    SpecialDistrictCheckBox: TCheckBox;
    BaseInformationCheckBox: TCheckBox;
    AssessmentsCheckBox: TCheckBox;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    PrintButton: TBitBtn;
    CheckAllButton: TBitBtn;
    UncheckAllButton: TBitBtn;
    PrinterSetupButton: TBitBtn;
    PrinterSetupDialog: TPrinterSetupDialog;
    PrintDialog: TPrintDialog;
    PictureCheckBox: TCheckBox;
    TaxableValuesGroupBox2: TGroupBox;
    SchoolTaxableCheckBox: TCheckBox;
    TownTaxableCheckBox: TCheckBox;
    CountyTaxableCheckBox: TCheckBox;
    NotesCheckBox: TCheckBox;
    cb_Permits: TCheckBox;
    cbSketches: TCheckBox;
    procedure PrintButtonClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure CheckAllButtonClick(Sender: TObject);
    procedure UncheckAllButtonClick(Sender: TObject);
    procedure PrinterSetupButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SwisSBLKey : String;
    ProcessingType : Integer;
    Options : OptionsSet;
  end;

var
  ParcelPrintDialog: TParcelPrintDialog;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils,
     PasTypes, Preview;

{$R *.DFM}

{===============================================================}
Procedure TParcelPrintDialog.FormShow(Sender: TObject);

{CHG04242002-1: Make sure that the searcher does not have the option to print notes.}

begin
  If GlblUserIsSearcher
    then NotesCheckBox.Visible := False;

    {CHG04302006-1(2.9.7.1): Allow the for permit printing.}

  If _Compare(GlblBuildingSystemLinkType, bldMunicity, coEqual)
    then cb_Permits.Visible := True
    else cb_Permits.Checked := False;

    {CHG04262012-1(2.28.4.19)[PAS-305]:  Add sketches to the F5 print.}

  If (GlblUsesSketches and
      ApexIsInstalledOnComputer)
    then cbSketches.Visible := True;

end;  {FormShow}

{===============================================================}
Procedure TParcelPrintDialog.CheckAllButtonClick(Sender: TObject);

begin
  ResidentialInventoryCheckBox.Checked := True;
  CommercialInventoryCheckBox.Checked := True;
  SalesCheckBox.Checked := True;
  ExemptionCheckBox.Checked := True;
  SpecialDistrictCheckBox.Checked := True;
  BaseInformationCheckBox.Checked := True;
  AssessmentsCheckBox.Checked := True;
  CountyTaxableCheckBox.Checked := True;
  TownTaxableCheckBox.Checked := True;
  SchoolTaxableCheckBox.Checked := True;

  If not GlblUserIsSearcher
    then NotesCheckBox.Checked := True;

    {CHG04302006-1(2.9.7.1): Allow the for permit printing.}

  If GlblUsesPASPermits
    then cb_Permits.Checked := True;

    {CHG04262012-1(2.28.4.19)[PAS-305]:  Add sketches to the F5 print.}

  If (GlblUsesSketches and
      ApexIsInstalledOnComputer)
    then cbSketches.Checked := True;

end;  {CheckAllButtonClick}

{=================================================================}
Procedure TParcelPrintDialog.UncheckAllButtonClick(Sender: TObject);

begin
  ResidentialInventoryCheckBox.Checked := False;
  CommercialInventoryCheckBox.Checked := False;
  SalesCheckBox.Checked := False;
  ExemptionCheckBox.Checked := False;
  SpecialDistrictCheckBox.Checked := False;
  BaseInformationCheckBox.Checked := False;
  AssessmentsCheckBox.Checked := False;
  CountyTaxableCheckBox.Checked := False;
  TownTaxableCheckBox.Checked := False;
  SchoolTaxableCheckBox.Checked := False;

  If not GlblUserIsSearcher
    then NotesCheckBox.Checked := False;

    {CHG04302006-1(2.9.7.1): Allow the for permit printing.}

  If GlblUsesPASPermits
    then cb_Permits.Checked := False;

    {CHG04262012-1(2.28.4.19)[PAS-305]:  Add sketches to the F5 print.}

  If (GlblUsesSketches and
      ApexIsInstalledOnComputer)
    then cbSketches.Visible := False;

end;  {UncheckAllButtonClick}

{==========================================================}
Procedure TParcelPrintDialog.PrinterSetupButtonClick(Sender: TObject);

begin
  PrintDialog.Execute;
end;

{==========================================================}
Procedure TParcelPrintDialog.PrintButtonClick(Sender: TObject);

var
  NewFileName : String;
  TempFile : File;
  Quit : Boolean;

begin
    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  PrintButton.Enabled := False;
  Application.ProcessMessages;

  Options := [];

  If BaseInformationCheckBox.Checked
    then Options := Options + [ptBaseInformation];

  If AssessmentsCheckBox.Checked
    then Options := Options + [ptAssessments];

  If SpecialDistrictCheckBox.Checked
    then Options := Options + [ptSpecialDistricts];

  If ExemptionCheckBox.Checked
    then Options := Options + [ptExemptions];

  If SalesCheckBox.Checked
    then Options := Options + [ptSales];

  If ResidentialInventoryCheckBox.Checked
    then Options := Options + [ptResidentialInventory];

  If CommercialInventoryCheckBox.Checked
    then Options := Options + [ptCommercialInventory];

  If PictureCheckBox.Checked
    then Options := Options + [ptPictures];

    {CHG09192001-2: Allow them to select which taxable values to show.}

  If CountyTaxableCheckBox.Checked
    then Options := Options + [ptCountyTaxable];

  If TownTaxableCheckBox.Checked
    then Options := Options + [ptTownTaxable];

  If SchoolTaxableCheckBox.Checked
    then Options := Options + [ptSchoolTaxable];

    {CHG03282002-11: Allow them to print notes.}

  If (NotesCheckBox.Checked and
      (not GlblUserIsSearcher))
    then Options := Options + [ptNotes];

    {FXX12081999-1: Make sure that if they are not allowed to see NY,
                    we don't print it.}

  If GlblUserIsSearcher
    then
      begin
        If SearcherCanSeeNYValues
          then Options := Options + [ptPrintNextYear];
      end
    else
      If ((not GlblDoNotPrintNextYearOnF5) or
          _Compare(GlblProcessingType, NextYear, coEqual))
        then Options := Options + [ptPrintNextYear];

    {CHG04302006-1(2.9.7.1): Allow the for permit printing.}

  If (cb_Permits.Checked and
      (not GlblUserIsSearcher))
    then Options := Options + [ptPermits];

    {CHG04262012-1(2.28.4.19)[PAS-305]:  Add sketches to the F5 print.}

  If GlblUsesSketches
    then Options := Options + [ptSketches];

    {FXX10231998-1: Do not keep showing the print dialog each time.}

    {CHG10131998-1: Set the printer settings based on what printer they selected
                    only - they no longer need to worry about paper or landscape
                    mode.}

  AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

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

            try
              ChDir(GlblProgramDir);
            except
            end;
            
          end;

        end;  {If PrintRangeDlg.PreviewPrint}

      end  {They did not select preview, so we will go
            right to the printer.}
    else ReportPrinter.Execute;

  Close;
  PrintButton.Enabled := True;

end;  {PrintButtonClick}

{============================================================}
Procedure TParcelPrintDialog.ReportPrint(Sender: TObject);

begin
  PrintAParcel(Sender, SwisSBLKey, ProcessingType, Options);
end;

{==============================================================}
Procedure TParcelPrintDialog.CancelButtonClick(Sender: TObject);

begin
  Close;
end;



end.
