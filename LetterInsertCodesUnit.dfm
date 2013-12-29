object LetterInsertCodesForm: TLetterInsertCodesForm
  Left = 362
  Top = 130
  Width = 333
  Height = 334
  Caption = 'Letter Insert Codes'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 9
    Width = 296
    Height = 33
    AutoSize = False
    Caption = 
      'This list is for reference only - the code will not be inserted ' +
      'into the letter.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object InsertCodesListBox: TListBox
    Left = 71
    Top = 53
    Width = 183
    Height = 201
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 16
    ParentFont = False
    TabOrder = 0
  end
  object OKButton: TBitBtn
    Left = 125
    Top = 263
    Width = 75
    Height = 29
    TabOrder = 1
    Kind = bkOK
  end
end
