unit ViewReportDataForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, Wwdbigrd, Wwdbgrid, wwSpeedButton,
  wwDBNavigator, ExtCtrls, wwclearpanel, Db, Wwdatsrc, DBTables, Wwtable;

type
  TViewDataForm = class(TForm)
    Table: TwwTable;
    DataSource: TwwDataSource;
    wwDBNavigator1: TwwDBNavigator;
    wwDBNavigator1First: TwwNavButton;
    wwDBNavigator1PriorPage: TwwNavButton;
    wwDBNavigator1Prior: TwwNavButton;
    wwDBNavigator1Next: TwwNavButton;
    wwDBNavigator1NextPage: TwwNavButton;
    wwDBNavigator1Last: TwwNavButton;
    wwDBNavigator1Insert: TwwNavButton;
    wwDBNavigator1Delete: TwwNavButton;
    wwDBNavigator1Edit: TwwNavButton;
    wwDBNavigator1Post: TwwNavButton;
    wwDBNavigator1Cancel: TwwNavButton;
    wwDBNavigator1Refresh: TwwNavButton;
    wwDBNavigator1SaveBookmark: TwwNavButton;
    wwDBNavigator1RestoreBookmark: TwwNavButton;
    Grid: TwwDBGrid;
    CloseButton: TBitBtn;
    SaveButton: TBitBtn;
    PrintButton: TBitBtn;
    ExportButton: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure Initialize(TableName : String;
                         ProcessingType : Integer);
  end;

var
  ViewDataForm: TViewDataForm;

implementation

{$R *.DFM}

uses Winutils, PASUtils;

{======================================================================}
Procedure TViewDataForm.Initialize(TableName : String;
                                   ProcessingType : Integer);

var
  Quit : Boolean;

begin
  OpenTableForProcessingType(Table, TableName, ProcessingType, Quit);
end;  {Initialize}

end.
