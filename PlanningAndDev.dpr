program PlanningAndDev;

uses
  Forms,
  Controls,
  SplashFrm,
  SplashFrm2,
  PL_MainFRM in 'PL_MainFRM.pas' {PL_Main_Form},
  DataModule in 'DataModule.pas' {DataModule1: TDataModule};

//datamodule in 'DataModule.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Splash_Form := TSplash_Form.Create(nil);
  if Splash_Form.showModal = mrOK then
  begin
  Application.Title := 'SCA Building & Development';
  Application.ProcessMessages;
  Splash_Form2 := TSplash_Form2.Create(nil);
  Splash_Form2.Show;
  Application.ProcessMessages;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TPL_Main_Form, PL_Main_Form);
  Splash_Form2.Hide;
  Application.Run;
  end
  Else
  Application.Terminate;

end.
