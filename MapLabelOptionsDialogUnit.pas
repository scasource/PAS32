unit MapLabelOptionsDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TMapLabelOptionsDialog = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    LabelTypeRadioGroup: TRadioGroup;
    FirstLineRadioGroup: TRadioGroup;
    OptionsGroupBox: TGroupBox;
    Label10: TLabel;
    LaserTopMarginEdit: TEdit;
    PrintLabelsBoldCheckBox: TCheckBox;
    OldAndNewLabelCheckBox: TCheckBox;
    PrintSwisCodeOnParcelIDCheckBox: TCheckBox;
    GroupBox1: TGroupBox;
    FontSizeLabel: TLabel;
    PrintParcelIDOnlyCheckBox: TCheckBox;
    FontSizeEdit: TEdit;
    ResidentLabelsCheckBox: TCheckBox;
    LegalAddressLabelsCheckBox: TCheckBox;
    procedure OKButtonClick(Sender: TObject);
    procedure PrintParcelIDOnlyCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PrintLabelsBold,
    PrintOldAndNewParcelIDs,
    PrintSwisCodeOnParcelIDs,
    PrintParcelIDOnly : Boolean;

    LabelType,
    NumLinesPerLabel,
    NumLabelsPerPage,
    NumColumnsPerPage,
    SingleParcelFontSize : Integer;

    ResidentLabels, LegalAddressLabels,
    PrintParcelIDOnlyOnFirstLine : Boolean;
    LaserTopMargin : Real;
    PrintParcelID_PropertyClass : Boolean;

  end;

var
  MapLabelOptionsDialog: TMapLabelOptionsDialog;

implementation

{$R *.DFM}

uses GlblCnst;

{===========================================================}
Procedure TMapLabelOptionsDialog.PrintParcelIDOnlyCheckBoxClick(Sender: TObject);

begin
  FontSizeEdit.Enabled := PrintParcelIDOnlyCheckBox.Checked;
  FontSizeLabel.Enabled := PrintParcelIDOnlyCheckBox.Checked;

end;  {PrintParcelIDOnlyCheckBoxClick}

{===========================================================}
Procedure TMapLabelOptionsDialog.OKButtonClick(Sender: TObject);

begin
  If (LabelTypeRadioGroup.ItemIndex = -1)
    then
      begin
        MessageDlg('Please select a label type.', mtError, [mbOK], 0);
        LabelTypeRadioGroup.SetFocus;
      end
    else
      begin
        PrintLabelsBold := PrintLabelsBoldCheckBox.Checked;
        LabelType := LabelTypeRadioGroup.ItemIndex;
        PrintParcelID_PropertyClass := (FirstLineRadioGroup.ItemIndex = flPropertyClass);
        PrintParcelIDOnlyOnFirstLine := (FirstLineRadioGroup.ItemIndex = flParcelIDOnly);
        PrintSwisCodeOnParcelIDs := PrintSwisCodeOnParcelIDCheckBox.Checked;
        PrintOldAndNewParcelIDs := OldAndNewLabelCheckBox.Checked;
        PrintParcelIDOnly := PrintParcelIDOnlyCheckBox.Checked;
        ResidentLabels := ResidentLabelsCheckBox.Checked;
        LegalAddressLabels := LegalAddressLabelsCheckBox.Checked;

        try
          SingleParcelFontSize := StrToInt(FontSizeEdit.Text);
        except
          SingleParcelFontSize := 16;
        end;

        try
          LaserTopMargin := StrToFloat(LaserTopMarginEdit.Text);
        except
          LaserTopMargin := 0.66;
        end;

        case LabelType of
          lbDotMatrix :
            begin
              NumLinesPerLabel := 12;
              NumLabelsPerPage := 6;
              NumColumnsPerPage := 1;
            end;

          lbLaser5161 :
            begin
              NumLinesPerLabel := 6;
              NumLabelsPerPage := 20;
              NumColumnsPerPage := 2;
            end;

          lbLaser5160 :
            begin
              NumLinesPerLabel := 6;
              NumLabelsPerPage := 30;
              NumColumnsPerPage := 3;
            end;

          lbLaser1Liner :
            begin
              NumLinesPerLabel := 1;
              NumLabelsPerPage := 8;
              NumColumnsPerPage := 1;
            end;

            {CHG12021999-1: Allow print to envelopes.}

          lbEnvelope :
            begin
              NumLinesPerLabel := 6;
              NumLabelsPerPage := 1;
              NumColumnsPerPage := 1;
            end;

        end;  {case LabelType of}

        ModalResult := mrOK;

      end;  {else of If (LabelTypeRadioGroup.ItemIndex = -1)}

end;  {OKButtonClick}


end.
