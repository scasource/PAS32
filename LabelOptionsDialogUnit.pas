unit LabelOptionsDialogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, DBTables;

type
  TLabelOptionsDialog = class(TForm)
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
    FontSizeEdit: TEdit;    ResidentLabelsCheckBox: TCheckBox;
    LegalAddressLabelsCheckBox: TCheckBox;
    ExtractToExcelCheckBox: TCheckBox;
    FontSizeAdditionalLinesLabel: TLabel;
    FontSizeAdditionalLinesEdit: TEdit;
    CommaDelimitedExtractCheckBox: TCheckBox;
    EliminateDuplicatesCheckBox: TCheckBox;
    SaveDialog: TSaveDialog;
    procedure OKButtonClick(Sender: TObject);
    procedure PrintParcelIDOnlyCheckBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    _PrintLabelsBold,
    _PrintOldAndNewParcelIDs,
    _PrintSwisCodeOnParcelIDs,
    _PrintParcelIDOnly : Boolean;

    _LabelType,
    _NumLinesPerLabel,
    _NumLabelsPerPage,
    _NumColumnsPerPage,
    _SingleParcelFontSize,
    _FontSizeAdditionalLines : Integer;

    _ResidentLabels, _LegalAddressLabels,
    _PrintParcelIDOnlyOnFirstLine : Boolean;
    _LaserTopMargin : Real;
    _PrintParcelID_PropertyClass,
    _ExtractToExcel,
    _CommaDelimitedExtract,
    _PrintAccountNumber_OldID,
    _EliminateDuplicateOwners : Boolean;
    _ExtractFileName : String;

  end;

var
  LabelOptionsDialog: TLabelOptionsDialog;

implementation

{$R *.DFM}

uses GlblCnst, DataModule, PASUtils, GlblVars;

{===========================================================}
Procedure TLabelOptionsDialog.FormCreate(Sender: TObject);

var
  SwisCodeTable : TTable;

begin
  SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName, NextYear);

    {CHG11182003-5(2.07k): If there is only one swis code, default print swis on parcel IDs to false.}

  PrintSwisCodeOnParcelIDCheckBox.Checked := (SwisCodeTable.RecordCount > 1);

end;  {FormCreate}

{===========================================================}
Procedure TLabelOptionsDialog.PrintParcelIDOnlyCheckBoxClick(Sender: TObject);

begin
  FontSizeEdit.Enabled := PrintParcelIDOnlyCheckBox.Checked;
  FontSizeLabel.Enabled := PrintParcelIDOnlyCheckBox.Checked;
  FontSizeAdditionalLinesLabel.Enabled := PrintParcelIDOnlyCheckBox.Checked;
  FontSizeAdditionalLinesEdit.Enabled := PrintParcelIDOnlyCheckBox.Checked;

end;  {PrintParcelIDOnlyCheckBoxClick}

{===========================================================}
Procedure TLabelOptionsDialog.OKButtonClick(Sender: TObject);

begin
  If (LabelTypeRadioGroup.ItemIndex = -1)
    then
      begin
        MessageDlg('Please select a label type.', mtError, [mbOK], 0);
        LabelTypeRadioGroup.SetFocus;
      end
    else
      begin
        _PrintLabelsBold := PrintLabelsBoldCheckBox.Checked;
        _LabelType := LabelTypeRadioGroup.ItemIndex;
        _PrintParcelID_PropertyClass := (FirstLineRadioGroup.ItemIndex = flPropertyClass);
        _PrintParcelIDOnlyOnFirstLine := (FirstLineRadioGroup.ItemIndex = flParcelIDOnly);
        _PrintAccountNumber_OldID := (FirstLineRadioGroup.ItemIndex = 3);

        _PrintSwisCodeOnParcelIDs := PrintSwisCodeOnParcelIDCheckBox.Checked;
        _PrintOldAndNewParcelIDs := OldAndNewLabelCheckBox.Checked;
        _PrintParcelIDOnly := PrintParcelIDOnlyCheckBox.Checked;
        _ResidentLabels := ResidentLabelsCheckBox.Checked;
        _LegalAddressLabels := LegalAddressLabelsCheckBox.Checked;

          {CHG05222004-1(2.08): Add option to extract labels to Excel.}

        _ExtractToExcel := ExtractToExcelCheckBox.Checked;
        _CommaDelimitedExtract := CommaDelimitedExtractCheckBox.Checked;

          {CHG06262005-1(2.8.5.2)[2152]: Option to eliminate duplicate owners from label print.}

        _EliminateDuplicateOwners := EliminateDuplicatesCheckBox.Checked;

        try
          _SingleParcelFontSize := StrToInt(FontSizeEdit.Text);
        except
          _SingleParcelFontSize := 16;
        end;

        If _PrintParcelIDOnly
          then
            try
              _FontSizeAdditionalLines := StrToInt(FontSizeAdditionalLinesEdit.Text);
            except
              _FontSizeAdditionalLines := 14;
            end
          else _FontSizeAdditionalLines := 0;

        try
          _LaserTopMargin := StrToFloat(LaserTopMarginEdit.Text);
        except
          _LaserTopMargin := 0.66;
        end;

        case _LabelType of
          lbDotMatrix :
            begin
              _NumLinesPerLabel := 12;
              _NumLabelsPerPage := 6;
              _NumColumnsPerPage := 1;
            end;

          lbLaser5161 :
            begin
              _NumLinesPerLabel := 6;
              _NumLabelsPerPage := 20;
              _NumColumnsPerPage := 2;
            end;

          lbLaser5160 :
            begin
              _NumLinesPerLabel := 6;
              _NumLabelsPerPage := 30;
              _NumColumnsPerPage := 3;
            end;

          lbLaser1Liner :
            begin
              _NumLinesPerLabel := 1;
              _NumLabelsPerPage := 8;
              _NumColumnsPerPage := 1;
            end;

            {CHG12021999-1: Allow print to envelopes.}

          lbEnvelope :
            begin
              _NumLinesPerLabel := 6;
              _NumLabelsPerPage := 1;
              _NumColumnsPerPage := 1;
            end;

        end;  {case LabelType of}

          {CHG11122005-1(2.9.4.1): Actually do the comma delimited and Excel extract.}

        If _CommaDelimitedExtract
          then
            begin
              SaveDialog.InitialDir := GlblExportDir;
              If SaveDialog.Execute
                then
                  begin
                    _ExtractFileName := SaveDialog.FileName;
                    ModalResult := mrOK;
                  end
                else ModalResult := mrCancel;

            end
          else ModalResult := mrOK;

      end;  {else of If (LabelTypeRadioGroup.ItemIndex = -1)}

end;  {OKButtonClick}


end.
