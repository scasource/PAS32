unit Enstarty;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls;

type
  TEnhancedSTARTypeDialog = class(TForm)
    OKBtn: TBitBtn;
    EnhancedSTARRadioGroup: TRadioGroup;
    IVPStatusRadioGroup: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    EnhancedSTARType, IVPEnrollmentStatusType : Integer;
  end;

var
  EnhancedSTARTypeDialog: TEnhancedSTARTypeDialog;

const
  enSeniorSTAROnly = 0;
  enWithSeniorandSTARExemption = 1;
  enAnySeniorSTAR = 2;

  ivpEnrolledOnly = 0;
  ivpNotEnrolledOnly = 1;
  ivpIgnoreEnrollmentStatus = 2;

implementation

{$R *.DFM}

{==============================================================}
Procedure TEnhancedSTARTypeDialog.OKBtnClick(Sender: TObject);

begin
  Close;
end;

{==============================================================}
Procedure TEnhancedSTARTypeDialog.FormClose(    Sender: TObject;
                                            var Action: TCloseAction);

{CHG01212004-1(2.07l): Add ability to select IVP enrollment status as a choice.}

begin
  EnhancedSTARType := EnhancedSTARRadioGroup.ItemIndex;
  IVPEnrollmentStatusType := IVPStatusRadioGroup.ItemIndex;
end;


end.
