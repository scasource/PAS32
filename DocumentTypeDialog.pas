unit DocumentTypeDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TDocumentTypeDialogForm = class(TForm)
    PreviousButton: TBitBtn;
    CancelButton: TBitBtn;
    Panel1: TPanel;
    NextButton: TBitBtn;
    Notebook: TNotebook;
    Label1: TLabel;
    DocumentTypeRadioGroup: TRadioGroup;
    WordDocumentRadioGroup: TRadioGroup;
    Label2: TLabel;
    Label3: TLabel;
    ExcelSpreadsheetRadioGroup: TRadioGroup;
    Label4: TLabel;
    WordPerfectDocumentRadioGroup: TRadioGroup;
    Label5: TLabel;
    QuattroProSpreadsheetRadioGroup: TRadioGroup;
    procedure PreviousButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure DocumentTypeRadioGroupClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DocumentTypeSelected : Integer;
  end;

var
  DocumentTypeDialogForm: TDocumentTypeDialogForm;

const
  MainDocumentSelectPage = 0;
  WordDocumentSelectPage = 1;
  ExcelSpreadsheetSelectPage = 2;
  WordPerfectDocumentSelectPage = 3;
  QuattroProSpreadsheetSelectPage = 4;

  dtOpenScannedImage = 0;
  dtOpenWordDocument = 1;
  dtCreateWordDocument = 2;
  dtOpenExcelSpreadsheet = 3;
  dtCreateExcelSpreadsheet = 4;
  dtOpenWordPerfectDocument = 5;
  dtCreateWordPerfectDocument = 6;
  dtOpenQuattroProSpreadsheet = 7;
  dtCreateQuattroProSpreadsheet = 8;
  dtOpenApexSketch = 9;
  dtOpenPDFDocument = 10;

implementation

{$R *.DFM}

{====================================================}
Procedure TDocumentTypeDialogForm.DocumentTypeRadioGroupClick(Sender: TObject);

begin
  case DocumentTypeRadioGroup.ItemIndex of
    0 : begin
          NextButton.Caption := '&OK';
          PreviousButton.Visible := False;
        end;

    1..4 : begin
          NextButton.Caption := '&Next >';
          PreviousButton.Visible := True;
        end;

  end;  {case DocumentTypeRadioGroup of}

end;  {DocumentTypeRadioGroupClick}

{====================================================}
Procedure TDocumentTypeDialogForm.PreviousButtonClick(Sender: TObject);

begin
  Notebook.PageIndex := 1;
end;

{======================================================}
Procedure TDocumentTypeDialogForm.NextButtonClick(Sender: TObject);

begin
  case Notebook.PageIndex of
    MainDocumentSelectPage :
      begin
        case DocumentTypeRadioGroup.ItemIndex of
          0 : begin
                DocumentTypeSelected := dtOpenScannedImage;
                ModalResult := mrOK;
              end;  {Scanned document}

          1..4 : begin
                Notebook.PageIndex := DocumentTypeRadioGroup.ItemIndex;
                PreviousButton.Enabled := True;
                NextButton.Caption := '&OK';

              end;  {Other documents}

          5 : begin
                DocumentTypeSelected := dtOpenPDFDocument;
                ModalResult := mrOK;
              end;

        end;  {case DocumentTypeRadioGroup.ItemIndex of}

      end;  {First notebook page}

    WordDocumentSelectPage :
      begin
        case WordDocumentRadioGroup.ItemIndex of
          0 : DocumentTypeSelected := dtOpenWordDocument;
          1 : DocumentTypeSelected := dtCreateWordDocument;
        end;  {case WordDocumentRadioGroup.ItemIndex of}

        ModalResult := mrOK;

      end;  {Second notebook page}

    ExcelSpreadsheetSelectPage :
      begin
        case ExcelSpreadsheetRadioGroup.ItemIndex of
          0 : DocumentTypeSelected := dtOpenExcelSpreadsheet;
          1 : DocumentTypeSelected := dtCreateExcelSpreadsheet;
        end;  {case ExcelSpreadsheetRadioGroup.ItemIndex of}

        ModalResult := mrOK;

      end;  {Third notebook page}

    WordPerfectDocumentSelectPage :
      begin
        case WordPerfectDocumentRadioGroup.ItemIndex of
          0 : DocumentTypeSelected := dtOpenWordPerfectDocument;
          1 : DocumentTypeSelected := dtCreateWordPerfectDocument;
        end;  {case WordPerfectDocumentRadioGroup.ItemIndex of}

        ModalResult := mrOK;

      end;  {Fourth notebook page}

    QuattroProSpreadsheetSelectPage :
      begin
        case QuattroProSpreadsheetRadioGroup.ItemIndex of
          0 : DocumentTypeSelected := dtOpenQuattroProSpreadsheet;
          1 : DocumentTypeSelected := dtCreateQuattroProSpreadsheet;
        end;  {case QuattroProSpreadsheetRadioGroup.ItemIndex of}

        ModalResult := mrOK;

      end;  {Fifth notebook page}

  end;  {case Notebook.PageIndex of}

end;  {NextButtonClick}


end.
