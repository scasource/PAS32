unit UtilOLE;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes,
  Word97, Excel97, OLEServer, OLECtnrs, ComCtrls, Dialogs, Printers;

Procedure CreateWordDocument(WordApplication : TWordApplication;
                             WordDocument : TWordDocument);
                             
Procedure OpenWordDocument(WordApplication : TWordApplication;
                           WordDocument : TWordDocument;
                           FileName : OLEVariant);

Procedure PrintWordDocument(WordApplication : TWordApplication;
                            WordDocument : TWordDocument;
                            FileName : OLEVariant);

Procedure CreateExcelDocument(    ExcelApplication : TExcelApplication;
                              var lcID : Integer);

Procedure OpenExcelDocument(    ExcelApplication : TExcelApplication;
                            var lcID : Integer;
                                FileName : OLEVariant);

Procedure PrintExcelDocument(    ExcelApplication : TExcelApplication;
                             var lcID : Integer;
                                 FileName : OLEVariant);

implementation
{=======================================================}
{================  WORD  ===============================}
{=======================================================}
Procedure CreateWordDocument(WordApplication : TWordApplication;
                             WordDocument : TWordDocument);

begin
  with WordApplication do
    begin
      Connect;
      Visible := True;
      WindowState := wdWindowStateMaximize;
      Activate;

      Documents.Add(EmptyParam, EmptyParam);
      WordDocument.ConnectTo(ActiveDocument);

    end;  {with WordApplication do}

end;  {CreateWordDocument}

{=======================================================}
Procedure OpenWordDocument(WordApplication : TWordApplication;
                           WordDocument : TWordDocument;
                           FileName : OLEVariant);

begin
  try
    WordApplication.Connect;
    WordApplication.Visible := True;
    WordApplication.WindowState := wdWindowStateMaximize;

    WordDocument.ConnectTo(WordApplication.Documents.Open(FileName,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam));
  except
    MessageDlg('Sorry, there was an problem linking with Word.' + #13 +
               'Please try again.', mtError, [mbOK], 0);
  end;

end;  {OpenWordDocument}

{=======================================================}
Procedure PrintWordDocument(WordApplication : TWordApplication;
                            WordDocument : TWordDocument;
                            FileName : OLEVariant);

begin
  WordApplication.Connect;
  WordDocument.ConnectTo(WordApplication.Documents.Open(FileName,
                                                        EmptyParam,
                                                        EmptyParam,
                                                        EmptyParam,
                                                        EmptyParam,
                                                        EmptyParam,
                                                        EmptyParam,
                                                        EmptyParam,
                                                        EmptyParam,
                                                        EmptyParam));

  WordApplication.ActivePrinter := Printer.Printers[Printer.PrinterIndex];
  WordDocument.PrintOut;

end;  {PrintWordDocument}

{=======================================================}
{================  EXCEL  ==============================}
{=======================================================}
Procedure CreateExcelDocument(    ExcelApplication : TExcelApplication;
                              var lcID : Integer);

var
  Wbk : _Workbook;
  ws : _Worksheet;

begin
  with ExcelApplication do
    begin
      Connect;
      lcID := GetUserDefaultLCID;
      ExcelApplication.Visible[lcID] := True;
      WBK := ExcelApplication.Workbooks.Add(EmptyParam, lcID);
      ws := WBK.Worksheets.Item['Sheet1'] as _Worksheet;
      ws.Activate(lcID);

    end;  {with ExcelApplication do}

end;  {CreateExcelDocument}                                  

{=======================================================}
Procedure OpenExcelDocument(    ExcelApplication : TExcelApplication;
                            var lcID : Integer;
                                FileName : OLEVariant);

var
  Wbk : _Workbook;
  ws : _Worksheet;

begin
  ExcelApplication.Connect;
  lcID := GetUserDefaultLCID;
  ExcelApplication.Visible[lcID] := True;
  wBK := ExcelApplication.Workbooks.Open(FileName,
                                         EmptyParam, EmptyParam,
                                         EmptyParam, EmptyParam, EmptyParam,
                                         EmptyParam, EmptyParam, EmptyParam,
                                         EmptyParam, EmptyParam, EmptyParam,
                                         EmptyParam, lcID);

    {FXX03152004-1(2.08): Opening up a workbook when it is already open causes an
                          OLE "Invalid Index" error, so put it in a try..except and
                          ignore it.}

  try
    ws := WBK.Worksheets.Item['Sheet1'] as _Worksheet;
  except
  end;

  try
    ws.Activate(lcID);
  except
  end;

end;  {OpenExcelDocument}

{=============================================================================}
Procedure PrintExcelDocument(    ExcelApplication : TExcelApplication;
                             var lcID : Integer;
                                 FileName : OLEVariant);

begin
  ExcelApplication.Connect;
  lcID := GetUserDefaultLCID;

  ExcelApplication.Workbooks.Open(FileName,
                                  EmptyParam, EmptyParam,
                                  EmptyParam, EmptyParam, EmptyParam,
                                  EmptyParam, EmptyParam, EmptyParam,
                                  EmptyParam, EmptyParam, EmptyParam,
                                  EmptyParam, lcID);

  ExcelApplication.ActiveWorkbook.PrintOut(EmptyParam, EmptyParam,
                                           EmptyParam, EmptyParam,
                                           EmptyParam, EmptyParam,
                                           EmptyParam, lcID);

end;  {PrintExcelDocument}


end.
