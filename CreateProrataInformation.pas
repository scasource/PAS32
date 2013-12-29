unit CreateProrataInformation;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, (*Progress,*)
  RPCanvas, RPrinter, RPDefine, RPBase, RPFiler, OleCtrls, Mask;

type
  TCreateProrataInformationForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    Label7: TLabel;
    RemovedExemptionsTable: TTable;
    CollectionRadioGroup: TRadioGroup;
    GroupBox1: TGroupBox;
    TrialRunCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    Label1: TLabel;
    CalendarStartDateEdit: TMaskEdit;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    PrintDialog: TPrintDialog;
    ProrataHeaderTable: TTable;
    ProrataDetailsTable: TTable;
    ProrataExemptionsTable: TTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    Cancelled, TrialRun, CreateParcelList : Boolean;
    CollectionsToCalculate : TCollectionSetType;
    Procedure InitializeForm;

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, Types,
     PASTypes, Prog,
     Preview;

{$R *.DFM}

{========================================================}
Procedure TCreateProrataInformationForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TCreateProrataInformationForm.InitializeForm;

begin
  UnitName := 'CreateProrataInformation';
  OpenTablesForForm(Self, GlblProcessingType);
end;  {InitializeForm}

{=================================================================}
Procedure TCreateProrataInformationForm.StartButtonClick(Sender: TObject);

var
  NewFileName : String;

begin
  TrialRun := TrialRunCheckBox.Checked;
  CreateParcelList := CreateParcelListCheckBox.Checked;
  ProgressDialog.UserLabelCaption := 'Creating Prorata Information.';
  ProgressDialog.Start(GetRecordCount(RemovedExemptionsTable), True, True);

  If PrintDialog.Execute
    then
      begin
        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptBoth], False, Quit);

        Cancelled := False;
        GlblPreviewPrint := False;

        If not Cancelled
          then
            If PrintDialog.PrintToFile
              then
                begin
                  GlblPreviewPrint := True;
                  NewFileName := GetPrintFileName(Self.Caption, True);
                  ReportFiler.FileName := NewFileName;
                  GlblDefaultPreviewZoomPercent := 100;

                  try
                    PreviewForm := TPreviewForm.Create(Self);
                    PreviewForm.FilePrinter.FileName := NewFileName;
                    PreviewForm.FilePreview.FileName := NewFileName;

                    ReportFiler.Execute;
                    PreviewForm.ShowModal;
                  finally
                    PreviewForm.Free;
                  end

                end
              else ReportPrinter.Execute;

      end;  {If PrintDialog.Execute}

  ProgressDialog.Finish;

end;  {StartButtonClick}

{===================================================================}
Function ProrataNeedsToBeCalculatedForParcel(RemovedExemptionsTable : TTable;
                                             CollectionsToCalculate : TCollectionSetType);

begin
end;  {ProrataNeedsToBeCalculatedForParcel}

{===================================================================}
Procedure TCreateProrataInformationForm.CalculateProrataForParcel;

begin

end;  {CalculateProrataForParcel}

{===================================================================}
Procedure TCreateProrataInformationForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
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
      PrintCenter('Create Prorata Information', (PageWidth / 2));
      Bold := False;
      CRLF;
      CRLF;

      ClearTabs;
      SetTab(0.4, pjCenter, 2.2, 5, BOXLINEAll, 25);   {Parcel ID 1}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===================================================================}
Procedure TCreateProrataInformationForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough : Boolean;
  SwisSBLKey : String;
  ProratasCalculated : LongInt;
  ProrataInformationForParcelList : TList;

begin
  Done := False;
  FirstTimeThrough := True;
  RemovedExemptionTable.First;
  ProratasCalculated := 0;
  ProrataInformationForParcel := TList.Create;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else RemovedExemptionsTable.Next;

    If RemovedExemptionsTable.EOF
      then Done := True;

    SwisSBLKey := RemovedExemptionsTable.FieldByName('SwisSBLKey').Text;
    ProgressDialog.Update(Form, ConvertSwisSBLKeyToDashDot(SwisSBLKey));
    Application.ProcessMessages;

    If ((_Compare(LastSwisSBLKey, coNotBlank) and
         (_Compare(SwisSBLKey, LastSwisSBLKey, coNotEqual)) or
        Done)
      then
        begin
          ProratasCalculated := ProratasCalculated + 1;
          ProgressDialog.UserLabelCaption := 'Proratas Found = ' + IntToStr(ProratasCalculated);
          CalculateProrataForParcel(ProrataInformationForParcelList);
          ClearTList(ProrataInformationForParcelList, SizeOf(ProrataInformationForParcelRecord));

        end;  {If ((_Compare(LastSwisSBLKey, coNotBlank) and ...}

    If ((not Done) and
        ProrataNeedsToBeCalculatedForParcel(RemovedExemptionsTable, CollectionsToCalculate))
      then AddProrataInformationForParcel(ProrataInformationForParcelList);

  until (Done or Cancelled);

end;  {ReportPrint}

{===================================================================}
Procedure TCreateProrataInformationForm.FormClose(    Sender: TObject;
                                                  var Action: TCloseAction);

begin
  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.