object DocumentTypeDialogForm: TDocumentTypeDialogForm
  Left = 172
  Top = 127
  BorderStyle = bsDialog
  Caption = 'Choose Document Type'
  ClientHeight = 233
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  object PreviousButton: TBitBtn
    Left = 211
    Top = 198
    Width = 75
    Height = 26
    Caption = '< &Back'
    Enabled = False
    TabOrder = 0
    Visible = False
    OnClick = PreviousButtonClick
    NumGlyphs = 2
  end
  object CancelButton: TBitBtn
    Left = 383
    Top = 198
    Width = 75
    Height = 26
    TabOrder = 1
    Kind = bkCancel
  end
  object Panel1: TPanel
    Left = 12
    Top = 10
    Width = 448
    Height = 170
    TabOrder = 2
    object Notebook: TNotebook
      Left = 1
      Top = 1
      Width = 446
      Height = 168
      Align = alClient
      TabOrder = 0
      object TPage
        Left = 0
        Top = 0
        Caption = 'Document Type Page'
        object Label1: TLabel
          Left = 18
          Top = 15
          Width = 389
          Height = 20
          AutoSize = False
          Caption = 'Please choose the type of document that you want:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object DocumentTypeRadioGroup: TRadioGroup
          Left = 18
          Top = 38
          Width = 416
          Height = 118
          Caption = ' Choose Document Type: '
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemIndex = 0
          Items.Strings = (
            ' Scanned Document'
            ' Word Document'
            ' Excel Spreadsheet'
            ' Word Perfect Document'
            ' Quattro Pro Spreadsheet'
            ' PDF (Adobe) Document')
          ParentFont = False
          TabOrder = 0
          OnClick = DocumentTypeRadioGroupClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Create or Open Word Document Page'
        object Label2: TLabel
          Left = 18
          Top = 15
          Width = 389
          Height = 20
          AutoSize = False
          Caption = 'Please choose from the following:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object WordDocumentRadioGroup: TRadioGroup
          Left = 18
          Top = 46
          Width = 378
          Height = 91
          Caption = ' Do you want to '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemIndex = 0
          Items.Strings = (
            ' Link to an existing Word document'
            ' Create a new Word document linked to this parcel')
          ParentFont = False
          TabOrder = 0
          OnClick = DocumentTypeRadioGroupClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Create or Open Excel Spreadsheet Page'
        object Label3: TLabel
          Left = 18
          Top = 15
          Width = 389
          Height = 20
          AutoSize = False
          Caption = 'Please choose from the following:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object ExcelSpreadsheetRadioGroup: TRadioGroup
          Left = 18
          Top = 46
          Width = 378
          Height = 91
          Caption = ' Do you want to '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemIndex = 0
          Items.Strings = (
            ' Link to an existing Excel spreadsheet'
            ' Create a new Excel spreadsheet linked to this parcel')
          ParentFont = False
          TabOrder = 0
          OnClick = DocumentTypeRadioGroupClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Create or Open Word Perfect Document Page'
        object Label4: TLabel
          Left = 18
          Top = 15
          Width = 389
          Height = 20
          AutoSize = False
          Caption = 'Please choose from the following:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object WordPerfectDocumentRadioGroup: TRadioGroup
          Left = 18
          Top = 46
          Width = 412
          Height = 91
          Caption = ' Do you want to '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemIndex = 0
          Items.Strings = (
            ' Link to an existing Word Perfect document'
            ' Create a new Word Perfect document linked to this parcel')
          ParentFont = False
          TabOrder = 0
          OnClick = DocumentTypeRadioGroupClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Create or Open Quattro Pro Spreadsheet Page'
        object Label5: TLabel
          Left = 18
          Top = 15
          Width = 389
          Height = 20
          AutoSize = False
          Caption = 'Please choose from the following:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object QuattroProSpreadsheetRadioGroup: TRadioGroup
          Left = 18
          Top = 46
          Width = 411
          Height = 91
          Caption = ' Do you want to '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ItemIndex = 0
          Items.Strings = (
            ' Link to an existing Quattro Pro spreadsheet'
            ' Create a new Quattro Pro spreadsheet linked to this parcel')
          ParentFont = False
          TabOrder = 0
          OnClick = DocumentTypeRadioGroupClick
        end
      end
    end
  end
  object NextButton: TBitBtn
    Left = 285
    Top = 198
    Width = 75
    Height = 26
    Caption = '&OK'
    TabOrder = 3
    OnClick = NextButtonClick
    Layout = blGlyphRight
    NumGlyphs = 2
  end
end
