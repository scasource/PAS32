unit P3rdPartyNotificationUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Db, DBTables, Wwtable, Buttons, ToolWin,
  ComCtrls;

type
  TThirdPartyNotificationSubForm = class(TForm)
    ThirdPartyNotificationGroupBox: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    SwisLabel: TLabel;
    Label17: TLabel;
    Label3: TLabel;
    Label28: TLabel;
    EditName1: TDBEdit;
    EditName2: TDBEdit;
    EditAddress: TDBEdit;
    EditAddress2: TDBEdit;
    EditStreet: TDBEdit;
    EditCity: TDBEdit;
    EditState: TDBEdit;
    EditZip: TDBEdit;
    EditZipPlus4: TDBEdit;
    MainToolBar: TToolBar;
    SaveSpeedButton: TSpeedButton;
    CancelSpeedButton: TSpeedButton;
    MainTable: TwwTable;
    MainDataSource: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ThirdPartyNotificationSubForm: TThirdPartyNotificationSubForm;

implementation

{$R *.DFM}

end.
