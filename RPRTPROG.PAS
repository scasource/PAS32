unit Rprtprog;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TReprintingReportForm = class(TForm)
    Label1: TLabel;
    ScanningLabel: TLabel;
    PrintingLabel: TLabel;
    ScanningPageNumLabel: TLabel;
    PrintingPageNumLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReprintingReportForm: TReprintingReportForm;

implementation

{$R *.DFM}

end.
