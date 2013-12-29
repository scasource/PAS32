unit CreateApexSearcherFiles;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, (*Progress,*)
  RPCanvas, RPrinter, RPDefine, RPBase, RPFiler, OleCtrls, CApexSPX_TLB,
  Exchange2XControl1_TLB;

type
  TCreateSketchFilesForSearcherForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    StartButton: TBitBtn;
    Label7: TLabel;
    SketchTable: TTable;
    GetSketchDataTimer: TTimer;
    OpenSketchTimer: TTimer;
    CreateActiveXComponentTimer: TTimer;
    pnl_Apex: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ApexXNewSketchData(Sender: TObject);
    procedure GetSketchDataTimerTimer(Sender: TObject);
    procedure OpenSketchTimerTimer(Sender: TObject);
    procedure ApexXSketchOpen(Sender: TObject);
    procedure CreateActiveXComponentTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    TimeOut, GotSketchData : Boolean;
    ApexX : TCApexSPX;
    ApexXv4 : TExchange2X;
    Procedure InitializeForm;  {Open the tables and setup.}
    Procedure CreateApexComponent;

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUTILS, Types,
     PASTypes, Prog,
     Preview;

{$R *.DFM}

{========================================================}
Procedure TCreateSketchFilesForSearcherForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{====================================================================}
Procedure TCreateSketchFilesForSearcherForm.CreateApexComponent;

begin
  If GlblUsesApexMedina
    then
      try
        ApexXv4 := TExchange2X.Create(pnl_Apex);

        ApexXv4.OnSketchOpen := ApexXSketchOpen;
        ApexXv4.OnNewSketchData := ApexXNewSketchData;

        with ApexXv4 do
          begin
            Align := alClient;
            AreaPage := 0;
            CurrentPage := 1;
            Color := clWhite;
            Parent := pnl_Apex;
            ShowHint := True;
            StartMinimized := True;
            ShowSplashScreen := False;
            SketchForm := 1;

          end;  {with ApexXv4 do}

      except
        on E: Exception do
          MessageDlg('There was an error creating the Apex ActiveX component.' + #13 +
                     'Exception: ' + E.Message + '.', mtError, [mbOK], 0);
      end
    else
      try
        ApexX := TCApexSPX.Create(pnl_Apex);

        ApexX.OnSketchOpen := ApexXSketchOpen;
        ApexX.OnNewSketchData := ApexXNewSketchData;

        with ApexX do
          begin
            Align := alClient;
            AreaCount := 2;
            Color := clWhite;
            DataPage := 1;
            Parent := pnl_Apex;
            ShowHint := True;
            StartMinimized := True;
            ShowSplashScreen := False;
            SketchForm := $0002;

          end;  {with ApexX do}

      except
        on E: Exception do
          MessageDlg('There was an error creating the Apex ActiveX component.' + #13 +
                     'Exception: ' + E.Message + '.', mtError, [mbOK], 0);
      end;

end;  {CreateApexComponent}

{====================================================================}
Procedure TCreateSketchFilesForSearcherForm.CreateActiveXComponentTimerTimer(Sender: TObject);

begin
  CreateActiveXComponentTimer.Enabled := False;
  CreateApexComponent;
end;

{========================================================}
Procedure TCreateSketchFilesForSearcherForm.InitializeForm;

begin
  UnitName := 'CreateApexSearcherFiles';
  OpenTablesForForm(Self, GlblProcessingType);
  CreateActiveXComponentTimer.Enabled := True;
end;  {InitializeForm}

{===================================================================}
Procedure TCreateSketchFilesForSearcherForm.ApexXNewSketchData(Sender: TObject);

begin
  GotSketchData := True;
end;  {ApexXNewSketchData}

{===================================================================}
Procedure TCreateSketchFilesForSearcherForm.GetSketchDataTimerTimer(Sender: TObject);

begin
  GetSketchDataTimer.Enabled := False;
  TimeOut := True;
end;

{=================================================================}
Procedure TCreateSketchFilesForSearcherForm.ApexXSketchOpen(Sender: TObject);

begin
  OpenSketchTimer.Enabled := True;
end;

{=================================================================}
Procedure TCreateSketchFilesForSearcherForm.OpenSketchTimerTimer(Sender: TObject);

begin
  OpenSketchTimer.Enabled := False;

  TimeOut := False;
  GotSketchData := False;
(*  GetSketchDataTimer.Enabled := True;

  If GlblUsesApexMedina
    then ApexXv4.RunDDEMacro('File;SendData')
    else ApexX.RunDDEMacro('File;SendData');

  repeat
    Application.ProcessMessages;
  until (TimeOut or GotSketchData); *)
  GotSketchData := True;

  GetSketchDataTimer.Enabled := False;

end;  {OpenSketchTimerTimer}

{=================================================================}
Procedure TCreateSketchFilesForSearcherForm.StartButtonClick(Sender: TObject);

var
  FirstTimeThrough, Done : Boolean;
  QualifiedFileName, SwisSBLKey : String;

begin
  FirstTimeThrough := True;
  Done := False;

  ProgressDialog.UserLabelCaption := 'Creating Sketch Files.';
  ProgressDialog.Start(GetRecordCount(SketchTable), True, True);

  SketchTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SketchTable.Next;

    If SketchTable.EOF
      then Done := True;

    SwisSBLKey := SketchTable.FieldByName('SwisSBLKey').Text;
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

    If not Done
      then
        begin
          If GlblUsesApexMedina
            then
              with ApexXv4 do
                try
                  CloseSketch;
                  QualifiedFileName := GetSketchLocation(SketchTable, True);
                  OpenSketchFile(QualifiedFileName);
                  UpdateSketchData;
                  Refresh;
                  SavePlaceableMetafileByPage(ConvertFileNameToApexWMFFileName(QualifiedFileName, True, False), CurrentPage);
                except
                end
            else
              with ApexX do
                try
                  CloseSketch;
                  QualifiedFileName := SketchTable.FieldByName('SketchLocation').Text;
                  try
                    SketchFile := QualifiedFileName;
                  except
                    SketchFile := '';
                  end;

                  UpdateSketchData;
                  Refresh;
                  SavePlaceableMetafile(ConvertFileNameToApexWMFFileName(QualifiedFileName, True, False));
                except
                  SketchFile := '';
                end;

        end;  {If not Done}

  until (Done or ProgressDialog.Cancelled);

  ProgressDialog.Finish;

  MessageDlg('The sketches have been created for the searchers.',
             mtInformation, [mbOK], 0);

end;  {ReportPrint}

{===================================================================}
Procedure TCreateSketchFilesForSearcherForm.FormClose(    Sender: TObject;
                                                var Action: TCloseAction);

begin
  If (ApexX <> nil)
    then
      try
        ApexX.CloseSketch;
        ApexX.CloseApex;
        ApexX.Free;
        ApexX := nil;
      except
      end;

  If (ApexXv4 <> nil)
    then
      try
        ApexXv4.CloseSketch;
        ApexXv4.CloseApex;
        ApexXv4.Free;
        ApexXv4 := nil;
      except
      end;

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}


end.