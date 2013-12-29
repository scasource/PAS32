object DeleteFilesOnCloseForm: TDeleteFilesOnCloseForm
  Left = 233
  Top = 127
  Width = 237
  Height = 143
  Caption = 'Delete Files on Close'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  WindowState = wsMinimized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DeleteFilesLabel: TLabel
    Left = 17
    Top = 46
    Width = 78
    Height = 13
    Caption = 'DeleteFilesLabel'
  end
  object DeleteFileTimer: TTimer
    Enabled = False
    OnTimer = DeleteFileTimerTimer
    Left = 149
    Top = 54
  end
end
