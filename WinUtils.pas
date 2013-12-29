unit Winutils;

interface

uses BDE, Types, Utilitys, DBCtrls, Dialogs, DBGrids, Buttons,
     WinProcs, WinTypes, Forms, Wwdbgrid, BtrvDlg, ExtCtrls,
     Classes, Grids, DBTables,  wwdblook,
     DBITypes, DBIErrs, DBIProcs, StdCtrls, Mask, DB, GlblCnst,
     LZExpand, Printers, RPDefine, RPBase, RPrinter, RPFiler, PASTypes, Controls,
     SysUtils, Graphics, TMultiP, Prnutils, PrnForm, CheckLst,
     Excel97, Word97, ComObj, Outlook8, RPMemo, RPDBUtil,
     AbBase, AbBrowse, AbZBrows, AbZipper, AbMeter, ShellAPI,
     FileCtrl, OleServer, MAPI, Math, ComCtrls;

{Procedures and functions to get rid of.}

{====================================================}
Function RecordIsLocked(Table : TTable) : Boolean;

Function GetBtrieveError(Table : TTable) : Integer;

Function PrinterIsDotMatrix : Boolean;

{=====================================================}

Function OldDeleteFile(FileName : String) : Boolean;

Function GetEditControlValue(DBEditControl : TDBEdit) : String;

Function ValidNumericalEntry(DBEditControl : TDBEdit;
                             FieldText : String;
                             AllowBlankEntry,
                             SetBlankEntryToZero,
                             CheckRange,
                             StayInFieldIfInvalidInput : Boolean;
                             DecimalPlaces : Integer;
                             MinRange,
                             MaxRange : Real) : Boolean;

Function iCalcGridWidth(dbg : TwwDBGrid;
                        TitlesShowing,
                        IndicatorShowing,
                        ColLinesShowing : Boolean) : Integer; {Returns the "exact" width }

Function iCalcStringGridWidth(Grid : TStringGrid) : Integer; {Returns the "exact" width }

Procedure SystemSupport(_LocatorCode : Integer;
                        TempTable : TTable;
                        _ErrorMsg,
                        _UnitName : String;
                        ErrorDlgBox : TSCAErrorDialogBox);

Procedure NonBtrvSystemSupport(LocatorCode,
                               ErrorCode : Integer;
                               ErrorMsg,
                               UnitName : String;
                               ErrorDlgBox : TSCAErrorDialogBox);

Procedure CenterText(Rect : TRect;      {The TRect to draw in.}
                     Canvas : TCanvas;  {The canvas of the ACTUAL object that we are drawing on.}
                     TextStr : String;
                     ClippingEnabled,       {Should we clip text that does not fit?}
                     SelectText : Boolean;  {Is this text selected?}
                     SelectedColor : TColor); {If it is selected, what color?}

Procedure LeftJustifyText(Rect : TRect;      {The TRect to draw in.}
                          Canvas : TCanvas;  {The canvas of the ACTUAL object that we are drawing on.}
                          TextStr : String;
                          ClippingEnabled,       {Should we clip text that does not fit?}
                          SelectText : Boolean;  {Is this text selected?}
                          SelectedColor : TColor; {If it is selected, what color?}
                          Spacing : Integer);  {Pixels to leave from the left of the TRect}

Procedure RightJustifyText(Rect : TRect;      {The TRect to draw in.}
                           Canvas : TCanvas;  {The canvas of the ACTUAL object that we are drawing on.}
                           TextStr : String;
                           ClippingEnabled,       {Should we clip text that does not fit?}
                           SelectText : Boolean;  {Is this text selected?}
                           SelectedColor : TColor; {If it is selected, what color?}
                           Spacing : Integer);  {Pixels to leave from the right of the TRect}

Procedure TwoLineText(Rect : TRect;      {The TRect to draw in.}
                      Canvas : TCanvas;  {The canvas of the ACTUAL object that we are drawing on.}
                      TextStr1,          {Top string}
                      TextStr2 : String;  {Bottom string}
                      ClippingEnabled,       {Should we clip text that does not fit?}
                      SelectText : Boolean;  {Is this text selected?}
                      SelectedColor : TColor); {If it is selected, what color?}

Function GetNetworkID : String;

Function DateTimetoMMDDYYYY(TempDate : TDateTime) : String;

Function MakeMMDDYYYYDate(TempDate : TDateTime) : String;

Function ApplicationRunning(Handle : HWnd;  {Handle of the form (i.e. Form1.Handle).}
                            ApplicationName : String) : Boolean;

Procedure AddZeroesToDateMask(DateEdit : TMaskEdit);

Procedure RefreshNoPost(Table : TTable);

Procedure DeleteTable(Table : TTable);

Procedure DeleteTableRange(Table : TTable);

Procedure MakeEditNotReadOnly(EditBox : TObject);

Procedure MakeNonDataAwareEditNotReadOnly(EditBox : TEdit);

Procedure MakeEditReadOnly(EditBox : TObject;
                           Table : TTable;
                           AssignDefaultValue : Boolean;
                           const DefaultValue);

Procedure MakeAllReadOnlyComponentsGray(Form : TForm);

Procedure MakeNonDataAwareEditReadOnly(EditBox : TEdit;
                                       AssignDefaultValue : Boolean;
                                       DefaultValue : String);

Procedure ClearTList(List : TList;
                     Size : Integer);
{Clear all the objects in a TList, but leave the list around.
 Note that the size of the pointer record must be passed in since Delphi
 has no way of knowing the size of the pointer.}

Procedure FreeTList(List : TList;
                    Size : Integer);
{Free all the objects in a TList and then free the whole list.
 Note that the size of the pointer record must be passed in since Delphi
 has no way of knowing the size of the pointer.}

Function NumEntriesInGridCol(StringGrid : TStringGrid;
                             Column : Integer) : Integer;
{Determine the number of non=blank entries in a column of a string grid.}

Function DuplicateExistsInGrid(StringGrid : TStringGrid;
                               SourceCellCol,
                               SourceCellRow : Integer) : Boolean;
{See if there are any other entries in the grid with the same entry as
 Cells[SourceCellCol, SourceCellRow].}

Procedure OpenTable(TableName : String;
                    Table : TTable;
                    UnitName : String;
                    ErrorDlgBox : TSCAErrorDialogBox);
{Given a table, open it with the given table name.}

Procedure DisableSelectionsInGroupBoxOrPanel(GroupBox : TGroupBox);
{Given a set of selections in a group box or panel (i.e. start and end edits with check boxes for
 all and to end of range), disable and grey the contained controls.}

Procedure EnableSelectionsInGroupBoxOrPanel(GroupBox : TGroupBox);
{Given a set of selections in a group box or panel (i.e. start and end edits with check boxes for
 all and to end of range), enable the contained controls.}

Procedure CopyTable_OneRecord(      SourceTable,
                                    DestTable : TTable;
                              const ExceptionFields : Array of String;
                              const ExceptionFieldValues : Array of String);
{Given a source and destination table (both the same layout), copy all
 fields from the source table to the destination table. However,
 for all the fields in ExceptionFields, substitute the corresponding
 value in the ExceptionFieldValues array.
 For example, if you want to set the 'TaxRollYr' field of the destination
 table to a value different than what is in the source table, you
 would call the procedure in the following way:
  CopyTable(SourceTable, DestTable, ['TaxRollYr'], ['1996']); }

Function CopyTableRange(      SourceTable,
                              DestTable : TTable;
                              KeyField : String;
                        const ExceptionFields : Array of String;
                        const ExceptionFieldValues : Array of String) : Integer;
{Given a source and destination table (both the same layout) where
 there has been a range set on the source table, copy all
 fields for all records in the range from the source table to the
 destination table. However,
 for all the fields in ExceptionFields, substitute the corresponding
 value in the ExceptionFieldValues array.
 For example, if you want to set the 'TaxRollYr' field of the destination
 table to a value different than what is in the source table, you
 would call the procedure in the following way:
   CopyTableRange(SourceTable, DestTable, ['TaxRollYr'], ['1996']);
 The number of records copied is returned.}

Function CopyOneFile(SourceName,
                     DestinationName : String) : Boolean;
{Actual copy of file routine that copies from a fully qualified source file name
 to a fully qualified destination name.}

Procedure TextPrint(Sender : TObject;
                    PrintString : String);
{Given the ReportPrinter component and the string to print
 (which may include tabs), print directly to the printer.}

Procedure TextPrintln(Sender : TObject;
                      PrintString : String);
{Given the ReportPrinter component and the string to print
 (which may include tabs), print directly to the printer and
 issue a line feed.}

Function NumRecordsInRange(      Table : TTable;
                           const _KeyFields : Array of String;
                           const StartRangeValues : Array of String;
                           const EndRangeValues : Array of String) : Integer;
{This procedure figures out how many records there are in a range.
 Example of usage - find out how many sales records there are for a table:
 NumRecordsInRange(SalesTable, [SwisSBLKey, '0'], [SwisSBLKey, '32000'])}

Function ClipText(TempStr : String;
                  Canvas : TCanvas;
                  Width : Real) : String;
{Clip the text so that it fits within the given width on the given canvas.}

Procedure CopyFields(SourceTable,
                     DestTable : TTable;
                     const ExceptionFields : Array of String;
                     const ExceptionFieldValues : Array of String);

Procedure FillOneListBox(ListBox : TCustomListBox;
                         Table : TTable;
                         CodeField,
                         DescriptionField : String;
                         DescriptionLen : Integer;
                         SelectAll,
                         IncludeDescription : Boolean;
                         ProcessingType : Integer;
                         AssessmentYear : String);

Procedure FillOneComboBox(ComboBox : TComboBox;
                          Table : TTable;
                          CodeField,
                          DescriptionField : String;
                          DescriptionLen : Integer;
                          IncludeDescription : Boolean;
                          ProcessingType : Integer;
                          AssessmentYear : String);
                         
Function RecordsAreDifferent(Table1,
                             Table2 : TTable) : Boolean;
{Compare 2 records field by field and see if the records match.
 Always ignore TaxRollYr.
 Note that the 2 tables must be the same type.}

Procedure AssignPrinterSettings(    PrintDialog : TPrintDialog;
                                    ReportPrinter,
                                    ReportFiler : TObject;
                                    PrintToType : PrintToTypeSet;
                                    WideCarriage : Boolean;
                                var Quit : Boolean);
{CHG10131998-1: Set the printer settings based on what printer they selected
                only - they no longer need to worry about paper or landscape
                mode.}

Procedure SetPrintToScreenDefault(PrintDialog : TPrintDialog);
{CHG10121998-1: Add user options for default destination and show vet max msg.}

Procedure ClearStringGrid(StringGrid : TStringGrid);

Procedure SortListAndGetStats(    List : TStringList;
                              var Median,
                                  Mean,
                                  COD : Double);
{Given a list of numbers, sort them into order from lowest to highest and
 then get the statistics.}

Procedure CopyMemoField(SourceField,
                        DestField : TField);

Procedure SaveReportOptions(Form : TForm;
                            OpenDialog : TOpenDialog;
                            SaveDialog : TSaveDialog;
                            DefaultFileName,
                            ReportName : String);
{CHG04271999-1: Let them save the report options.}

Function LoadReportOptions(Form : TForm;
                           OpenDialog : TOpenDialog;
                           DefaultFileName,
                           ReportName : String) : Boolean;

Procedure DisplayPrintingFinishedMessage(PrintToScreen : Boolean);

Procedure SelectItemsInListBox(ListBox : TListBox);

Function FindValueInRange(AssessmentYear : String;
                          SwisSBLKey : String;
                          Table : TTable;
                          SearchField : String;
                          ValuesList : TStringList;
                          AllowPartialMatch : Boolean) : Boolean;

Function RecordsDifferent(Table1,
                          Table2 : TTable) : Boolean;

Procedure ResetPrinter(ReportPrinter : TObject);

Procedure SetRangeOld(      Table : TTable;
                      const _Fields : Array of String;
                      const StartRange : Array of String;
                      const EndRange : Array of String);

Function FindKeyOld(      Table : TTable;
                    const _Fields : Array of String;
                    const Values : Array of String) : Boolean;

Procedure FindNearestOld(      Table : TTable;
                         const _Fields : Array of String;
                         const Values : Array of String);

Procedure CopySortFile(SourceTable : TTable;
                       SortFileName : String);
{Copy a sort file template to a temporary sort file using BatchMove.}

Procedure SetFormStateMaximized(Form : TForm);

Function GetSortFileName(StartingLetters : String) : String;

Procedure CopyAndOpenSortFile(    SortTable : TTable;
                                  SortFilePrefix : String;
                                  OrigSortFileName : String;
                              var SortFileName : String;
                                  Exclusive : Boolean;
                                  ComputeSortFileName : Boolean;
                              var Quit : Boolean);

Procedure PrintScreen(Application : TApplication;
                      Form : TWinControl;
                      TopX, TopY,
                      BottomX, BottomY : LongInt);

Procedure TFormPrint_PrintScreen(Application : TApplication;
                                 Form : TForm);

Procedure CopyTable(Table : TTable;
                    TableName : String;
                    Overwrite : Boolean);

Procedure UpdateFieldForTable(Table : TTable;
                              FieldName : String;
                              FieldValue : String);

Procedure SelectItemsInCheckListBox(CheckListBox : TCheckListBox);

Procedure FillStringListFromFile(List : TStringList;
                                 Table : TTable;
                                 CodeField,
                                 DescriptionField : String;
                                 DescriptionLen : Integer;
                                 IncludeDescription : Boolean;
                                 ProcessingType : Integer;
                                 AssessmentYear : String);

Procedure DisplaySelectedItemsInListBox(ListBox : TListBox;
                                        List : TStringList;
                                        StartingCharacters : String;
                                        SelectAll : Boolean);

Function InDateRange(TempDate : TDateTime;
                     PrintAllDates,
                     PrintToEndOfDates : Boolean;
                     StartingDate,
                     EndingDate : TDateTime) : Boolean;

(*Function ValueInRange(ValueToCompare : const;
                      PrintAllValues,
                      PrintToEndOfValues : Boolean;
                      StartingValue : const;
                      EndingValue : const) : Boolean; *)

Function GetRecordCount(Table : TTable) : LongInt;

Procedure FillSelectedItemList(ListBox : TListBox;
                               SelectedList : TStringList;
                               CharsToSelect : Integer);

Procedure FillSelectedItemsFromCheckListBox(clbxListBox : TCheckListBox;
                                            SelectedList : TStringList;
                                            CharsToSelect : Integer);
                               
Procedure DisplayHintForListBox(ListBox : TListBox;
                                Table : TTable;
                                IndexField,
                                DescriptionField : String;
                                ListBoxCurrPosX,
                                ListBoxCurrPosY : Integer);

Function PackTable(    Table : TTable;
                   var ResultMsg : String) : Boolean;

Function ReindexTable(    Table : TTable;
                      var ResultMsg : String) : Boolean;

Procedure SendTextFileToExcelSpreadsheet(FileName : String;
                                         MakeVisible : Boolean;
                                         AutomaticallySaveFile : Boolean;
                                         AutomaticSaveFileName : String);

Function MapObjectsInstalled : Boolean;

Procedure PerformWordMailMerge(WordFileName : String;
                               ExcelFileName : String); overload;

Procedure PerformWordMailMerge(WordFileName : String;
                               DatabaseName : String;
                               DSNName : String;
                               UserID : String;
                               Password : String;
                               TableName : String); overload;

Procedure MoveToRecordNumber(Table : TTable;
                             RecordNumber : LongInt);

Function GetMemoLineCountForMemoField(Sender : TObject;
                                      MemoField : TMemoField;
                                      LeftMargin : Double;
                                      RightMargin : Double) : Integer;

Function MemoFieldIsRichTextMemoField(MemoField : TMemoField) : Boolean;

{$H+}
Function StringContainsRichText(sTemp : String) : Boolean;
{$H-}

Procedure PrintMemoField(Sender : TObject;
                         MemoField : TMemoField;
                         LeftMargin : Double;
                         RightMargin : Double;
                         CarriageReturn : Boolean);

{$H+}
Procedure EMailFile(Form : TForm;
                    SourceDirectory : String;
                    ZipDirectory : String;
                    ZipFileName : String;
                    sDestinationEmail : String;
                    sCCEmail : String;
                    sMailSubject : String;
                    sBody : String;
                    SelectedFiles : TStringList;
                    CompressFiles : Boolean);
{$H-}

Function ParseLongDate(    LongDate : String;
                       var ParsedTime : TTime;
                       var GoodDate : Boolean) : TDateTime;

Function GetPaperSize(PaperSize : String) : Integer;

Procedure SetPrinterOverrides(    PrinterSettingsTable : TTable;
                                  ReportPrinter : TReportPrinter;
                                  ReportFiler : TReportFiler;
                                  PrintToScreenCheckBox : TCheckBox;
                              var PrintToScreen : Boolean;
                              var LinesAtBottom : Integer;
                              var NumLinesPerPage : Integer);

Procedure PromptForLetterSizePaper(    ReportPrinter : TReportPrinter;
                                       ReportFiler : TReportFiler;
                                   var NumLinesPerPage : Integer;
                                   var LinesAtBottom : Integer;
                                   var ReducedSize : Boolean;
                                   var DuplexType : TDuplex);

{$H+}
Function SendMail(sSubject,
                  sBody,
                  sFileName,
                  sSenderName,
                  sSenderEMail,
                  sRecepientName,
                  sRecepientEMail,
                  sCCEMail : String;
                  bDisplayError : Boolean) : Integer;
{$H-}

Function TableFieldsSame(Table1 : TTable;
                         Table2 : TTable;
                         FieldName : String) : Boolean;

Function TableIntegerFieldsDifference(Table1 : TTable;
                                      Table2 : TTable;
                                      FieldName : String;
                                      AbsoluteValue : Boolean) : Integer;

Function TableFloatFieldsDifference(Table1 : TTable;
                                    Table2 : TTable;
                                    FieldName : String;
                                    AbsoluteValue : Boolean) : Double;

Function SumTableColumn(Table : TTable;
                        FieldName : String) : Double;

Procedure ResizeGridFontForWidthChange(Grid : TwwDBGrid;
                                       OriginalGridWidth : Integer);

Procedure ResizeStringGridFontForWidthChange(    Grid : TStringGrid;
                                                 OriginalGridWidth : Integer;
                                             var ColumnSizeFactor : Double);

Function MeetsDateCriteria(Date : TDateTime;
                           StartDate : TDateTime;
                           EndDate : TDateTime;
                           PrintAllDates : Boolean;
                           PrintToEndOfDates : Boolean) : Boolean;

Function IsNumericDataType(DataType : TFieldType) : Boolean;

Procedure SetTabStopsForDBEdits(Form : TForm);

Function GetDatasetForDataSource(Form : TForm;
                                 DataSource : TDataSource) : TDataSet;

Function GetYearFromDate(_Date : TDateTime) : Integer;

Procedure SelectPrinterForPrintScreen;

Procedure FillStringListFromTableField(StringList : TStringList;
                                       Table : TTable;
                                       FieldName : String);

Procedure FillInListView(      ListView : TListView;
                               Dataset : TDataset;
                         const FieldNames : Array of const;
                               SelectLastItem : Boolean;
                               ReverseOrder : Boolean); overload;

Procedure FillInListView(      ListView : TListView;
                               Dataset : TDataset;
                         const FieldNames : Array of const;
                         const DisplayFormats : Array of String;
                               SelectLastItem : Boolean;
                               ReverseOrder : Boolean); overload;

Procedure FillInListViewRow(      ListView : TListView;
                            const Values : Array of const;
                                  SelectLastItem : Boolean);

Procedure ChangeListViewRow(      ListView : TListView;
                            const Values : Array of const;
                                  Index : Integer);

Function GetColumnValueForListItem(ListItem : TListItem;
                                   ColumnNumber : Integer) : String;
                                  
Function GetColumnValueForItem(ListView : TListView;
                               ColumnNumber : Integer;
                               Index : Integer) : String;  {-1 means selected}

Procedure GetColumnValuesForItem(ListView : TListView;
                                 ValuesList : TStringList;
                                 Index : Integer);  {-1 means selected}

Procedure GetSelectedColumnValues(ListView : TListView;
                                  ColumnNumber : Integer;
                                  ValuesList : TStringList);

Procedure SelectListViewItem(ListView : TListView;
                             RowNumber : Integer);

Procedure DeleteSelectedListViewRow(ListView : TListView);

Procedure ClearListView(ListView : TListView);

Procedure WriteListViewToFile(ListView : TListView;
                              sFileName : String);


Procedure SetComponentsToReadOnly(Form : TForm);

Function GetDataChangedStateForComponent(Sender : TObject) : Boolean;

Function StringListToString(StringList : TStringList;
                            SeparationChar : String) : String;

Procedure GetValuesFromStringGrid(StringGrid : TStringGrid;
                                  StringList : TStringList;
                                  UpperCase : Boolean);

{$H+}
Function ConvertRichTextFieldToString(RichTextMemo : TDBRichEdit;
                                      PlainTextMemo : TMemo;
                                      _DataSource : TDataSource;
                                      _DataField : String) : String;


Function ConvertRichTextStringToString(sRichText : String;
                                       frmTemp : TForm) : String;

{$H-}

Procedure FillDistinctStringListFromTable(StringList : TStringList;
                                          Dataset : TDataset;
                                          _FieldName : String;
                                          NumberCharsToCompare : Integer;
                                          SortList : Boolean);

Procedure AddOneTreeViewItem(      TreeView : TTreeView;
                                   MainLevelItem : String;
                             const ChildItems : Array of String);

Procedure PrintImage(Image : TPMultiImage;
                     Handle : HWnd;
                     X : Integer;
                     Y : Integer;
                     PageWidth : Integer;
                     PageHeight : Integer;
                     StartPage : Integer;
                     EndPage : Integer;
                     ScaleToPage : Boolean);

Procedure PromptForLetterSize(ReportPrinter : TReportPrinter;
                              ReportFiler : TReportFiler;
                              ScaleX : Integer;
                              ScaleY : Integer;
                              SectionLeft : Double);

Procedure CapitalizeAllFields(tbTable : TTable);

Function DateDisplay(sDate : String) : String;

implementation

uses GlblVars, Registry;

{Procedures and functions to get rid of.}

{====================================================}
Function RecordIsLocked(Table : TTable) : Boolean;

begin
  Result := False;
end;

{====================================================}
Function GetBtrieveError(Table : TTable) : Integer;

begin
  Result := 0;
end;

{====================================================}
Function DeleteOneFile(FileName : String) : Boolean;

var
  FileNameLen : Integer;
  FileNamePChar : PChar;

begin
  FileNameLen := Length(FileName);
  FileNamePChar := StrAlloc(FileNameLen + 1);
  StrPCopy(FileNamePChar, FileName);
  try
    Result := DeleteFile(FileNamePChar);
  except
  end;
  
  StrDispose(FileNamePChar);

end;  {DeleteOneFile}

{==================================================================}
Function OldDeleteFile(FileName : String) : Boolean;

{FXX08232000-1(MDT): dBase files actually consist of 2 files -
                     the dbf and the mdx - if we want to delete
                     the dbf, it should delete the mdx, too. TODO TOOJMG}

begin
  DeleteOneFile(FileName);

    {If this is a dBase file, delete the MDX file, too.}

  If (Pos('DBF', FileName) > 0)
    then
      begin
        FileName := ChangeFileExt(FileName, '.MDX');
        DeleteOneFile(FileName);
      end;

  Result := True;

end;  {OldDeleteFile}

{==========================================================================}
Function GetEditControlValue(DBEditControl : TDBEdit) : String;

var
  Buffer: PChar;
  Size: Byte;
  Value : String;

begin
  Size := (DBEditControl as TDBEdit).GetTextLen;       {Get length of string in Edit}
  Inc(Size);                      {Add room for null character}
  GetMem(Buffer, Size);           {Creates Buffer dynamic variable}
  (DBEditControl as TDBEdit).GetTextBuf(Buffer,Size);  {Puts value into Buffer}
  Value := StrPas(Buffer);   {Converts Buffer to a Pascal-style string]}
  FreeMem(Buffer, Size);          {Frees memory allocated to Buffer}
  GetEditControlValue := Value;

end;  {GetEditControlValue}

{==========================================================================}
Function ValidNumericalEntry(DBEditControl : TDBEdit;
                             FieldText : String;
                             AllowBlankEntry,
                             SetBlankEntryToZero,
                             CheckRange,
                             StayInFieldIfInvalidInput : Boolean;
                             DecimalPlaces : Integer;
                             MinRange,
                             MaxRange : Real) : Boolean;

var
  MinRangeStr, MaxRangeStr, TempValStr : String;
  TempVal : Real;
  StrSize, ReturnCode : Integer;
  ValidInput : Boolean;
  TempPChar : PChar;

begin
  TempValStr := GetEditControlValue(DBEditControl);
  ValidInput := True;

  If (Deblank(TempValStr) = '')
    then
      begin
        If AllowBlankEntry
          then
            begin
              If (DecimalPlaces = 0)
                then TempValStr := '0'
                else Str(Zero:(DecimalPlaces + 2):DecimalPlaces, TempValStr);

              TempPChar := StrAlloc(Length(TempValStr) + 1);
              StrPCopy(TempPChar, TempValStr);

              If SetBlankEntryToZero
                then (DBEditControl as TDBEdit).SetTextBuf(TempPChar);

              StrDispose(TempPChar);
            end
          else
            begin
              ValidInput := False;
              MessageDlg('You must enter a value for the ' + FieldText + '.',
                         mtError, [mbOK], 0);
            end;  {else of If AllowBlankEntry}

      end
    else
      begin
        Val(TempValStr, TempVal, ReturnCode);

        If (ReturnCode <> 0)
          then
            begin
              ValidInput := False;
              MessageDlg('Not a valid numerical entry - please re-enter.',
                         mtError, [mbOK], 0);
            end
          else
            If (CheckRange and
                ((TempVal < MinRange) or
                 (TempVal > MaxRange)))
              then
                begin
                  ValidInput := False;

                  If (DecimalPlaces = 0)
                    then StrSize := 1
                    else StrSize := DecimalPlaces + 2;

                  Str(MinRange:StrSize:DecimalPlaces, MinRangeStr);
                  Str(MaxRange:StrSize:DecimalPlaces, MaxRangeStr);

                  MessageDlg('Please enter a number between ' + MinRangeStr +
                             ' and ' + MaxRangeStr + ' for the ' + FieldText + '.',
                             mtError, [mbOK], 0);

                end;  {If ((CreditsVal < 0) and (CreditsVal > 4))}

      end;  {else of If (Deblank(Credits) = 0)}

    {If the entry was not valid, then make them stay in the field, if the
     flag is set.}

  If ((not ValidInput) and
      StayInFieldIfInvalidInput)
    then (DBEditControl as TDBEdit).SetFocus;

  ValidNumericalEntry := ValidInput;

end;  {ValidNumericalEntry}


{===============================================================================================}
{===============================================================================================}
 {This calculates the width of a TDBGrid so that it will display all the fields,
  but no horizontal scrollbar. It takes into account the width of the vertical
  scrollbar (which changes based on the screen resolution) and the indicator.}

Function NewTextWidth(      fntFont : TFont;
                      const sString : OpenString) : Integer;

{I had to use the function NewTextWidth, rather than the Grid's Canvas.TextWith
 as the Canvas of the Grid may not initialized when you need to call
 iCalcGridWidth.}

var
  fntSave : TFont;
  TotalWidth : Integer;

begin
  TotalWidth := 0;
  fntSave := Application.MainForm.Font;
  Application.MainForm.Font := fntFont;

  try
    TotalWidth := Application.MainForm.Canvas.TextWidth(sString);
  finally
    Application.MainForm.Font := fntSave;
    NewTextWidth := TotalWidth;
  end;

end;  {NewTextWidth}


Function iCalcGridWidth(dbg : TwwDBGrid;
                        TitlesShowing,
                        IndicatorShowing,
                        ColLinesShowing : Boolean) : Integer; {Returns the "exact" width }

{ calculate the width of the grid needed to exactly display with no   }
{ horizontal scrollbar and with no extra space between the last       }
{ column and the vertical scrollbar.  The grid's datasource must be   }
{ properly set and the datasource's dataset must be properly set,     }
{ though it need not be open.  Note:  this width includes the width   }
{ of the vertical scrollbar, which changes based on screen            }
{ resolution.  These changes are compensated for.                     }

const
  cMEASURE_CHAR   = '0';
  iEXTRA_COL_PIX  = 4;
  iINDICATOR_WIDE = 11;

var
  i, iColumns, iColWidth,
  iTitleWidth, iCharWidth, TotalWidth,
  LineDivPos : integer;
  TempTitle, TempStr : String;

begin
  iColumns := 0;
  TotalWidth := GetSystemMetrics(SM_CXVSCROLL);
  iCharWidth := NewTextWidth(dbg.Font, cMEASURE_CHAR);

  with dbg.dataSource.dataSet do
    for i := 0 to FieldCount - 1 do
      with Fields[i] do
      if visible then
      begin
        iColWidth := iCharWidth * DisplayWidth;

          {MDT - If using Infopower's grid which allows for more than 1
                 title line, we have to recurse through the display label
                 checking the size of each line to see if it is larger than
                 anything we have already found.}

        If TitlesShowing
          then
            begin
              TempTitle := DisplayLabel;

              while (Deblank(TempTitle) <> '') do
                begin
                    {~ is the line seperator, so let's find the position of the first one
                     in the title (if there is one).}

                  LineDivPos := Pos('~', TempTitle);

                  If (LineDivPos = 0)
                    then TempStr := TempTitle  {Only one line}
                    else TempStr := Copy(TempTitle, 1, (LineDivPos - 1));

                  iTitleWidth := NewTextWidth(dbg.TitleFont, TempStr);
                  if (iColWidth < iTitleWidth)
                    then iColWidth := iTitleWidth;

                    {Delete that line from the title in the loop.}

                  If (LineDivPos = 0)
                    then TempTitle := ''  {There was only one line.}
                    else System.Delete(TempTitle, 1, LineDivPos);

                end;  {while (Deblank(TempTitle) <> '') do}

            end;  {If TitlesShowing}

        inc(iColumns, 1);
        inc(TotalWidth, iColWidth + iEXTRA_COL_PIX);
      end;

  if IndicatorShowing then
  begin
    inc(iColumns, 1);
    inc(TotalWidth, iINDICATOR_WIDE);
  end;

  if ColLinesShowing
    then inc(TotalWidth, iColumns)
    else inc(TotalWidth, 1);

  iCalcGridWidth := TotalWidth;

end;  {iCalcGridWidth}

{=============================================================================}
Function iCalcStringGridWidth(Grid : TStringGrid) : Integer; {Returns the "exact" width }

{ calculate the width of the grid needed to exactly display with no   }
{ horizontal scrollbar and with no extra space between the last       }
{ column and the vertical scrollbar. }
{ Note:  this width includes the width   }
{ of the vertical scrollbar, which changes based on screen            }
{ resolution.  These changes are compensated for.                     }

const
  iEXTRA_COL_PIX  = 4;

var
  I, TotalWidth : Integer;

begin
  TotalWidth := GetSystemMetrics(SM_CXVSCROLL);

  with Grid do
    begin
      For I := 0 to (ColCount - 1) do
        inc(TotalWidth, ColWidths[I]{ + iEXTRA_COL_PIX});

      If goVertLine in Grid.Options
        then inc(TotalWidth, (ColCount - 1))
        else inc(TotalWidth, 1);

    end;  {with Grid do}

  iCalcStringGridWidth := TotalWidth;

end;  {iCalcStringGridWidth}

{==============================================================================}
Procedure SystemSupport(_LocatorCode : Integer;
                        TempTable : TTable;
                        _ErrorMsg,
                        _UnitName : String;
                        ErrorDlgBox : TSCAErrorDialogBox);

begin
  If (ErrorDlgBox <> nil)
    then
      with ErrorDlgBox do
        try
          ErrorCode := 0;
          LocatorCode := _LocatorCode;
          ErrorMsg := _ErrorMsg;
          UnitName := _UnitName;

          Execute;
        except
        end
    else MessageDlg(_ErrorMsg, mtError, [mbOK], 0);

end;  {SystemSupport}

{==============================================================================}
Procedure NonBtrvSystemSupport(LocatorCode,
                               ErrorCode : Integer;
                               ErrorMsg,
                               UnitName : String;
                               ErrorDlgBox : TSCAErrorDialogBox);

{If they have received an EOutOfResources or EOutOfMemory error, we will give
 them a nice message saying to close some windows and try again. Otherwise, we
 will put an SCA dialog box.}

var
  E : TObject;
  TempStr, TempErrorMsg : String;

begin
  try
    If (ExceptObject = nil)
      then TempStr := ''
      else
        begin
          E := ExceptObject;
          TempStr := Exception(E).ClassName;
        end;

  except
    TempStr := '';
  end;

  If ((TempStr = 'EOutOfResources') or
      (TempStr = 'EOutOfMemory'))
    then
      begin
        If (TempStr = 'EOutOfResources')
          then TempErrorMsg := GlblOutOfResourcesErrorMsg
          else TempErrorMsg := GlblOutOfMemoryErrorMsg;

        MessageDlg(TempErrorMsg, mtError, [mbOK], 0);
      end
    else
      begin
        ErrorDlgBox.ErrorCode := ErrorCode;
        ErrorDlgBox.LocatorCode := LocatorCode;
        ErrorDlgBox.ErrorMsg := ErrorMsg;
        ErrorDlgBox.UnitName := UnitName;

        ErrorDlgBox.Execute;

      end;  {If ((TempStr = 'EOutOfResources') or ...}

end;  {SystemSupport}

{======================================================================}
Procedure CenterText(Rect : TRect;      {The TRect to draw in.}
                     Canvas : TCanvas;  {The canvas of the ACTUAL object that we are drawing on.}
                     TextStr : String;
                     ClippingEnabled,       {Should we clip text that does not fit?}
                     SelectText : Boolean;  {Is this text selected?}
                     SelectedColor : TColor); {If it is selected, what color?}

{Center a string within a given TRect.}

var
  X, Y, PointSize, Width : Integer;
  TempColor : TColor;

begin
  PointSize := Canvas.TextHeight(TextStr);
  Width := Canvas.TextWidth(TextStr);

  If (Width > (Rect.Right - Rect.Left))
    then X := Rect.Left
    else X := Rect.Left + ((Rect.Right - Rect.Left - Width) Div 2);

  If (PointSize > (Rect.Bottom - Rect.Top))
    then Y := Rect.Top
    else Y := Rect.Top + ((Rect.Bottom - Rect.Top - PointSize) Div 2);

  TempColor := Canvas.Brush.Color;

  If SelectText
    then Canvas.Brush.Color := SelectedColor;

  If ClippingEnabled
    then Canvas.TextRect(Rect, X, Y, TextStr)
    else Canvas.TextOut(X, Y, TextStr);

  Canvas.Brush.Color := TempColor;

end;  {CenterText}

{======================================================================}
Procedure LeftJustifyText(Rect : TRect;      {The TRect to draw in.}
                          Canvas : TCanvas;  {The canvas of the ACTUAL object that we are drawing on.}
                          TextStr : String;
                          ClippingEnabled,       {Should we clip text that does not fit?}
                          SelectText : Boolean;  {Is this text selected?}
                          SelectedColor : TColor; {If it is selected, what color?}
                          Spacing : Integer);  {Pixels to leave from the left of the TRect}

{Left justify a string within a given TRect.}

var
  X, Y, PointSize : Integer;
  TempColor : TColor;

begin
  PointSize := Canvas.TextHeight(TextStr);
  X := Rect.Left + Spacing;

  If (PointSize > (Rect.Bottom - Rect.Top))
    then Y := Rect.Top
    else Y := Rect.Top + ((Rect.Bottom - Rect.Top - PointSize) Div 2);

  TempColor := Canvas.Brush.Color;

  If SelectText
    then Canvas.Brush.Color := SelectedColor;

  If ClippingEnabled
    then Canvas.TextRect(Rect, X, Y, TextStr)
    else Canvas.TextOut(X, Y, TextStr);

  Canvas.Brush.Color := TempColor;

end;  {LeftJustifyText}

{======================================================================}
Procedure RightJustifyText(Rect : TRect;      {The TRect to draw in.}
                           Canvas : TCanvas;  {The canvas of the ACTUAL object that we are drawing on.}
                           TextStr : String;
                           ClippingEnabled,       {Should we clip text that does not fit?}
                           SelectText : Boolean;  {Is this text selected?}
                           SelectedColor : TColor; {If it is selected, what color?}
                           Spacing : Integer);  {Pixels to leave from the right of the TRect}

{Right justify a string within a given TRect.}

var
  X, Y, PointSize, Width : Integer;
  TempColor : TColor;

begin
  Width := Canvas.TextWidth(TextStr);
  PointSize := Canvas.TextHeight(TextStr);
   {position from rt side of cell}

  X := Rect.Right - Width - Spacing;

  If (X < 0)
    then X := 0;

  If (PointSize > (Rect.Bottom - Rect.Top))
    then Y := Rect.Top
    else Y := Rect.Top +
        ((Rect.Bottom - Rect.Top - PointSize) Div 2);

  TempColor := Canvas.Brush.Color;

  If SelectText
    then Canvas.Brush.Color := SelectedColor;

  If ClippingEnabled
    then Canvas.TextRect(Rect, X, Y, TextStr)
    else Canvas.TextOut(X, Y, TextStr);

  Canvas.Brush.Color := TempColor;

end;  {RightJustifyText}

{======================================================================}
Procedure TwoLineText(Rect : TRect;      {The TRect to draw in.}
                      Canvas : TCanvas;  {The canvas of the ACTUAL object that we are drawing on.}
                      TextStr1,          {Top string}
                      TextStr2 : String;  {Bottom string}
                      ClippingEnabled,       {Should we clip text that does not fit?}
                      SelectText : Boolean;  {Is this text selected?}
                      SelectedColor : TColor); {If it is selected, what color?}

{Put two centered lines of text in a TRect.}

var
  X1, X2, Y1, Y2, PointSize, Width1, Width2, Space : Integer;
  TempColor : TColor;
  Rect1, Rect2 : TRect;

begin
  PointSize := Canvas.TextHeight(TextStr1);
  Width1 := Canvas.TextWidth(TextStr1);
  Width2 := Canvas.TextWidth(TextStr2);

  Rect1 := Rect;
  Rect2 := Rect;
  Rect1.Bottom := Rect.Top + (Rect.Bottom - Rect.Top) DIV 2;
  Rect2.Top := Rect1.Bottom;

    {Figure out the left point of the two text strings.}

  If (Width1 > (Rect.Right - Rect.Left))
    then X1 := Rect.Left
    else X1 := Rect.Left + ((Rect.Right - Rect.Left - Width1) Div 2);

  If (Width2 > (Rect.Right - Rect.Left))
    then X2 := Rect.Left
    else X2 := Rect.Left + ((Rect.Right - Rect.Left - Width2) Div 2);

    {Figure out the Y of the two text strings.}

  Space := ((Rect.Bottom - Rect.Top) - (2 * PointSize)) DIV 3;
  Y1 := Rect.Top + Space;
  Y2 := Rect.Top + Space + PointSize + Space;

  TempColor := Canvas.Brush.Color;

  If SelectText
    then Canvas.Brush.Color := SelectedColor;

    {Now put out the first string.}

  If ClippingEnabled
    then Canvas.TextRect(Rect1, X1, Y1, TextStr1)
    else Canvas.TextOut(X1, Y1, TextStr1);

    {Now put out the second string.}

  If ClippingEnabled
    then Canvas.TextRect(Rect2, X2, Y2, TextStr2)
    else Canvas.TextOut(X2, Y2, TextStr2);

  Canvas.Brush.Color := TempColor;

end;  {TwoLineText}

{======================================================================}
Function GetNetworkID : String;

{This procedure was given to me over Compuserve. It uses the units DBIProcs,
 DBITypes, DBIErrs.}

var
  ID : DbiUserName;

begin
  DbiGetNetUserName(ID);
  Result := ID;
end;

{=================================================================}
Function DateTimetoMMDDYYYY(TempDate : TDateTime) : String;

begin
  Result := FormatDateTime('mm"/"dd"/"yyyy', TempDate);
end;

{=================================================================}
Function MakeMMDDYYYYDate(TempDate : TDateTime) : String;

var
  Year, Month, Day : Word;

begin
  DecodeDate(TempDate, Year, Month, Day);
  Result := ShiftRightAddZeroes(Take(2, IntToStr(Month))) +
            ShiftRightAddZeroes(Take(2, IntToStr(Day))) +
            ShiftRightAddZeroes(Take(4, IntToStr(Year)));

end;

{=================================================================}
Function ApplicationRunning(Handle : HWnd;  {Handle of the form (i.e. Form1.Handle).}
                            ApplicationName : String) : Boolean;

{We will look through the window list of all running DOS and Windows
 applications and look for the application name.}

var
  Wnd : HWnd;
  Buff : Array[0..127] of Char;
  AppFound : Boolean;
  TempPChar : PChar;
  TempStr : String;

begin
  AppFound := False;
  Wnd := GetWindow(Handle, gw_hWndFirst);

    {We will loop through all the windows and get the name of each. We will then
     put the buffer in a PChar and convert the PChar to a string in order to compare.
     The reason for this is that a null terminated string is returned in the buffer,
     but to get rid of the extra junk on the end, we have to assign the buffer to
     a PChar.}

  while (Wnd <> 0) do
    begin
      If (GetWindowText(Wnd, Buff, SizeOf(Buff)) <> 0)
        then
          begin
            TempPChar := Buff;
            TempStr := StrPas(TempPChar);

            If (CompareText(TempStr, ApplicationName) = 0)
              then AppFound := True;

          end;

      Wnd := GetWindow(Wnd, gw_hWndNext);

    end;  {while (Wnd <> 0) do}

  Result := AppFound;

end;  {ApplicationRunning}

{===================================================================}
Procedure AddZeroesToDateMask(DateEdit : TMaskEdit);

    {Let's fill in the zeroes. We will search through the text string
     for blanks and change it to a zero.}

var
  TempStr : String;
  I : Integer;

begin
  TempStr := DateEdit.Text;
  For I := 1 to Length(DateEdit.Text) do
    If (TempStr[I] = ' ')
      then TempStr[I] := '0';
  DateEdit.Text := TempStr;

end;  {AddZeroesToDateMask}

{===========================================================================}
Procedure RefreshNoPost(Table : TTable);

begin
  with Table do
    begin
      UpdateCursorPos;
      Check(DbiForceReread(Table.Handle));
      Resync([]);
    end;  {with Table do}

end;  {RefreshNoPost}

{===============================================================}
Procedure DeleteTable(Table : TTable);

begin
  Table.First;

  while (Table.RecordCount >= 1) do
    begin
      Table.Delete;

      If not Table.EOF
        then Table.Next;

    end;

end;  {DeleteTable}

{===============================================================}
Procedure DeleteTableRange(Table : TTable);

{Special version for ranges that does not depend on the record count.}

begin
  Table.First;

  repeat
    If not Table.EOF
      then Table.Delete;

    If not Table.EOF
      then Table.First;

  until Table.EOF;

end;  {DeleteTable}

{============================================================}
Procedure MakeEditNotReadOnly(EditBox : TObject);

{We will make an edit box not read only by setting ReadOnly to
 False, the color to clWindow and the font color to clBlack.}

begin
  If (EditBox is TDBEdit)
    then
      with EditBox as TDBEdit do
        begin
          ReadOnly := False;
          Color := clWindow;
          Font.Color := clBlack;
          TabStop := True;

        end;  {with EditBox do}

  If (EditBox is TwwDBLookupCombo)
    then
      with EditBox as TwwDBLookupCombo do
        begin
          ReadOnly := False;
          Color := clWindow;
          Font.Color := clBlack;
          TabStop := True;

        end;  {with EditBox do}

end;  {MakeEditNotReadOnly}

{============================================================}
Procedure MakeNonDataAwareEditNotReadOnly(EditBox : TEdit);

{We will make an edit box not read only by setting ReadOnly to
 False, the color to clWindow and the font color to clBlack.}

begin
  with EditBox do
    begin
      ReadOnly := False;
      Color := clWindow;
      Font.Color := clBlack;
      TabStop := True;

    end;  {with EditBox do}

end;  {MakeEditReadOnly}

{============================================================}
Procedure MakeEditReadOnly(EditBox : TObject;
                           Table : TTable;
                           AssignDefaultValue : Boolean;
                           const DefaultValue);

{We will make an edit box read only by setting ReadOnly to
 True, the color to clBtnFace and the font color to clBlue.
 Also, if a value should be assigned to the data field,
 let's do it.}

begin
  If (EditBox is TDBEdit)
    then
      with EditBox as TDBEdit do
        begin
          ReadOnly := True;
          Color := clBtnFace;
          Font.Color := clBlue;
          TabStop := False;

          If (AssignDefaultValue and
              (not Table.ReadOnly) and
              (Table.State in [dsEdit, dsInsert]))
            then
              case Table.FieldByName(DataField).DataType of
                ftFloat : Table.FieldByName(DataField).AsFloat := 0;
                ftCurrency : Table.FieldByName(DataField).AsFloat := 0;
                ftInteger : Table.FieldByName(DataField).AsInteger := 0;
                ftString : Table.FieldByName(DataField).AsString := '';
              end;

        end;  {with EditBox do}

  If (EditBox is TwwDBLookupCombo)
    then
      with EditBox as TwwDBLookupCombo do
        begin
          ReadOnly := True;
          Color := clBtnFace;
          Font.Color := clBlue;
          TabStop := False;

          If (AssignDefaultValue and
              (not Table.ReadOnly) and
              (Table.State in [dsEdit, dsInsert]))
            then
              case Table.FieldByName(DataField).DataType of
                ftFloat : Table.FieldByName(DataField).AsFloat := 0;
                ftCurrency : Table.FieldByName(DataField).AsFloat := 0;
                ftInteger : Table.FieldByName(DataField).AsInteger := 0;
                ftString : Table.FieldByName(DataField).AsString := '';
              end;

        end;  {with EditBox do}

end;  {MakeEditReadOnly}

{============================================================}
Function GetDatasetForDataSource(Form : TForm;
                                 DataSource : TDataSource) : TDataSet;

var
  I : Integer;

begin
  Result := nil;

  with Form do
    For I := 0 to (ComponentCount - 1) do
      If (Components[I] = DataSource)
        then Result := DataSource.Dataset;

end;  {GetDatasetForDataSource}

{============================================================}
Procedure MakeAllReadOnlyComponentsGray(Form : TForm);

var
  I : Integer;
  MarkReadOnly : Boolean;

begin
  with Form do
    For I := 0 to (ComponentCount - 1) do
      begin
        MarkReadOnly := False;

        If (Components[I] is TDBEdit)
          then
            with Components[I] as TDBEdit do
              MarkReadOnly := GetDatasetForDataSource(Form, DataSource).FieldByName(DataField).ReadOnly;

        If (Components[I] is TwwDBLookupCombo)
          then
            with Components[I] as TwwDBLookupCombo do
              MarkReadOnly := GetDatasetForDataSource(Form, DataSource).FieldByName(DataField).ReadOnly;

        If MarkReadOnly
          then MakeEditReadOnly(Components[I], nil, False, '');

      end;  {For I := 0 to (ComponentCount - 1) do}

end;  {MakeAllReadOnlyComponentsGray}

{============================================================}
Procedure MakeNonDataAwareEditReadOnly(EditBox : TEdit;
                                       AssignDefaultValue : Boolean;
                                       DefaultValue : String);

{We will make an edit box read only by setting ReadOnly to
 True, the color to clBtnFace and the font color to clBlue.
 Also, if a value should be assigned to the data field,
 let's do it.}

begin
  with EditBox do
    begin
      ReadOnly := True;
      Color := clBtnFace;
      Font.Color := clBlue;
      TabStop := False;

      If AssignDefaultValue
        then Text := DefaultValue;

    end;  {with EditBox do}

end;  {MakeNonDataAwareEditReadOnly}

{=======================================================================================}
Procedure ClearTList(List : TList;
                     Size : Integer);

{Clear all the objects in a TList, but leave the list around.
 Note that the size of the pointer record must be passed in since Delphi
 has no way of knowing the size of the pointer.}

var
  I, Count : Integer;

begin
  Count := List.Count - 1;

  For I := Count downto 0 do
    FreeMem(List[I], Size);

  List.Clear;

end;  {ClearTList}

{=======================================================================================}
Procedure FreeTList(List : TList;
                    Size : Integer);

{Free all the objects in a TList and then free the whole list.
 Note that the size of the pointer record must be passed in since Delphi
 has no way of knowing the size of the pointer.}

begin
  ClearTList(List, Size);
  List.Free;

end;  {FreeTList}

{=============================================================================}
Function NumEntriesInGridCol(StringGrid : TStringGrid;
                             Column : Integer) : Integer;

{Determine the number of non=blank entries in a column of a string grid.}

var
  I : Integer;

begin
  Result := 0;

  For I := 0 to (StringGrid.RowCount - 1) do
    If (Deblank(StringGrid.Cells[0, I]) <> '')
      then Result := Result + 1;

end;  {NumEntriesInGridCol}

{=======================================================================}
Function DuplicateExistsInGrid(StringGrid : TStringGrid;
                               SourceCellCol,
                               SourceCellRow : Integer) : Boolean;

{See if there are any other entries in the grid with the same entry as
 Cells[SourceCellCol, SourceCellRow].}

var
  Col, Row : Integer;
  TempStr : String;

begin
  Result := False;
  TempStr := StringGrid.Cells[SourceCellCol, SourceCellRow];

  For Col := 0 to (StringGrid.ColCount - 1) do
    For Row := 0 to (StringGrid.RowCount - 1) do
      If (((Col <> SourceCellCol) or  {Don't compare to self.}
           (Row <> SourceCellRow)) and
          (TempStr = StringGrid.Cells[Col, Row]))
        then Result := True;


end;  {DuplicateExistsInGrid}

{=========================================================================}
Procedure OpenTable(TableName : String;
                    Table : TTable;
                    UnitName : String;
                    ErrorDlgBox : TSCAErrorDialogBox);

{Given a table, open it with the given table name.}

begin
  Table.Close;
  Table.TableName := TableName;

  try
    Table.Open;
  except
    SystemSupport(850, Table, 'Error opening table ' + TableName + '.',
                  UnitName, ErrorDlgBox);
  end;

end;  {OpenTable}

{===========================================================}
Procedure DisableSelectionsInGroupBoxOrPanel(GroupBox : TGroupBox);

{Given a set of selections in a group box or panel (i.e. start and end edits with check boxes for
 all and to end of range), disable and grey the contained controls.}

var
  I : Integer;

begin
  For I := 0 to (GroupBox.ControlCount - 1) do
    begin
        {If this is an edit or DBEdit, we want to grey out the box and disable it.}

      If (GroupBox.Controls[I] is TEdit)
        then
          with (GroupBox.Controls[I] as TEdit) do
            begin
              Text := '';
              Color := clBtnFace;
              Enabled := False;

            end;  {with (Component.Control[I] as TEdit) do}

      If (GroupBox.Controls[I] is TMaskEdit)
        then
          with (GroupBox.Controls[I] as TMaskEdit) do
            begin
              Text := '';
              Color := clBtnFace;
              Enabled := False;

            end;  {with (Component.Control[I] as TMaskEdit) do}

      If (GroupBox.Controls[I] is TCheckBox)
        then
          with (GroupBox.Controls[I] as TCheckBox) do
            begin
              Checked := False;
              Color := clBtnFace;
              Enabled := False;

            end;  {with (GroupBox.Control[I] as TCheckBox) do}

      If (GroupBox.Controls[I] is TwwDBLookupCombo)
        then
          with (GroupBox.Controls[I] as TwwDBLookupCombo) do
            begin
              Color := clBtnFace;
              Enabled := False;
            end;  {with (GroupBox.Controls[I] as TwwDBLookupCombo) do}

    end;  {with GroupBox.Control[I] do}

  GroupBox.Enabled := False;

end;  {DisableSelectionsInGroupBoxOrPanel}

{===========================================================}
Procedure EnableSelectionsInGroupBoxOrPanel(GroupBox : TGroupBox);

{Given a set of selections in a group box or panel (i.e. start and end edits with check boxes for
 all and to end of range), enable the contained controls.}

var
  I : Integer;

begin
  For I := 0 to (GroupBox.ControlCount - 1) do
    begin
        {If this is an edit or DBEdit, we want to grey out the box and disable it.}

      If (GroupBox.Controls[I] is TEdit)
        then
          with (GroupBox.Controls[I] as TEdit) do
            begin
              Color := clWindow;
              Enabled := True;

            end;  {with (GroupBox.Control[I] as TEdit) do}

      If (GroupBox.Controls[I] is TMaskEdit)
        then
          with (GroupBox.Controls[I] as TMaskEdit) do
            begin
              Color := clWindow;
              Enabled := True;

            end;  {with (GroupBox.Control[I] as TEdit) do}

      If (GroupBox.Controls[I] is TCheckBox)
        then
          with (GroupBox.Controls[I] as TCheckBox) do
            Enabled := True;

      If (GroupBox.Controls[I] is TwwDBLookupCombo)
        then
          with (GroupBox.Controls[I] as TwwDBLookupCombo) do
            begin
              Color := clWindow;
              Enabled := True;
            end;  {with (GroupBox.Controls[I] as TwwDBLookupCombo) do}

    end;  {with GroupBox.Control[I] do}

  GroupBox.Enabled := True;

end;  {EnableSelectionsInGroupBoxOrPanel}

{=====================================================================}
Procedure CopyTable_OneRecord(      SourceTable,
                                    DestTable : TTable;
                              const ExceptionFields : Array of String;
                              const ExceptionFieldValues : Array of String);

{Given a source and destination table (both the same layout), copy all
 fields from the source table to the destination table. However,
 for all the fields in ExceptionFields, substitute the corresponding
 value in the ExceptionFieldValues array.
 For example, if you want to set the 'TaxRollYr' field of the destination
 table to a value different than what is in the source table, you
 would call the procedure in the following way:
   CopyTable(SourceTable, DestTable, ['TaxRollYr'], ['1996']);
}


var
  I : Integer;
  TempStr : String;

begin
  try
    DestTable.Insert;

      {Copy all the fields from the source table to the destination
       table. Note that we are using FieldByName so that we don't have
       to worry about the fields being in the same order between the
       two tables. They should be, but I don't want to make that
       assumption.}
      {FXX05111999-1: Put in an exception for the field assigns.}
      {FXX11151999-1: Put in logic to copy memo records.}

    For I := 0 to (SourceTable.FieldCount - 1) do
      try
        If (SourceTable.Fields[I].DataType = ftMemo)
          then
            begin
              TMemoField(SourceTable.Fields[I]).SaveToFile('Temp.MEM');
              TMemoField(DestTable.FieldByName(SourceTable.Fields[I].FieldName)).LoadFromFile('Temp.MEM');
              OldDeleteFile('Temp.MEM');
            end
          else
              {FXX08082001-1: Don't copy the Reserved field - it is never used.}
              {FXX08042002-1: Make sure that the field exists in the destination table.}

            If ((UpcaseStr(SourceTable.Fields[I].FieldName) <> UpcaseStr('AutoIncrementID')) and
                (UpcaseStr(SourceTable.Fields[I].FieldName) <> UpcaseStr('AutoIncrement')) and
                _Compare(SourceTable.Fields[I].FieldName, 'AutoIncremetID', coNotEqual) and
                (UpcaseStr(SourceTable.Fields[I].FieldName) <> UpcaseStr('Reserved')) and
                (DestTable.FindField(SourceTable.Fields[I].FieldName) <> nil))
              then
                begin
                  TempStr := SourceTable.Fields[I].Text;
                  DestTable.FieldByName(SourceTable.Fields[I].FieldName).Text := SourceTable.Fields[I].Text;
                end;

      except
        DestTable.FieldByName(SourceTable.Fields[I].FieldName).Text := '';
      end;

      {Now go through the exceptions and use the corresponding values
       instead of the original values from the source table.}

    For I := 0 to High(ExceptionFields) do
      DestTable.FieldByName(ExceptionFields[I]).Text := ExceptionFieldValues[I];

    DestTable.Post;

  except
    on E: Exception do
      begin
(*        ShowMessage(E.Message); *)
        DestTable.Cancel;
(*        SystemSupport(800, DestTable,
                      'Error copying tables.' + #13 +
                      'Source table = ' + SourceTable.TableName + #13 +
                      'Destination table = ' + DestTable.TableName,
                      'WINUTILS.PAS', GlblErrorDlgBox); *)

      end;

  end;

end;  {CopyTable}

{=====================================================================}
Function CopyTableRange(      SourceTable,
                              DestTable : TTable;
                              KeyField : String;
                        const ExceptionFields : Array of String;
                        const ExceptionFieldValues : Array of String) : Integer;

{Given a source and destination table (both the same layout) where
 there has been a range set on the source table, copy all
 fields for all records in the range from the source table to the
 destination table. However,
 for all the fields in ExceptionFields, substitute the corresponding
 value in the ExceptionFieldValues array.
 For example, if you want to set the 'TaxRollYr' field of the destination
 table to a value different than what is in the source table, you
 would call the procedure in the following way:
   CopyTableRange(SourceTable, DestTable, ['TaxRollYr'], ['1996']);
 The number of records copied is returned.}

var
  FirstTimeThrough, Done : Boolean;

begin
  FirstTimeThrough := True;
  Done := False;
  Result := 0;

  SourceTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SourceTable.Next;

    If SourceTable.EOF
      then Done := True;

    If not Done
      then
        begin
          Result := Result + 1;
          CopyTable_OneRecord(SourceTable, DestTable, ExceptionFields,
                              ExceptionFieldValues);
        end;

  until Done;

end;  {CopyTableRange}

{==================================================================}
Function CopyOneFile(SourceName,
                     DestinationName : String) : Boolean;

{Actual copy of file routine that copies from a fully qualified source file name
 to a fully qualified destination name.}

var
  SourceLen, DestLen : Integer;
  SourceNamePChar, DestNamePChar : PChar;

begin
  SourceLen := Length(SourceName);
  DestLen := Length(DestinationName);

  SourceNamePChar := StrAlloc(SourceLen + 1);
  DestNamePChar := StrAlloc(DestLen + 1);

  StrPCopy(SourceNamePChar, SourceName);
  StrPCopy(DestNamePChar, DestinationName);

  Result := CopyFile(SourceNamePChar, DestNamePChar, False);

  StrDispose(SourceNamePChar);
  StrDispose(DestNamePChar);

end;  {CopyOneFile}

{=====================================================================}
Function JustifyString(SourceStr : String;
                       Width : Double;
                       Justify : TPrintJustify) : String;

var
  TempLen : Integer;

begin
  TempLen := Trunc(Width * 10);

  case Justify of
    pjLeft : Result := SourceStr;
    pjRight : Result := ShiftRightAddBlanks(Take(TempLen, Trim(SourceStr)));
    pjCenter : Result := Center(SourceStr, TempLen);

  end;  {case Justify of}

end;  {JustifyString}

{=====================================================================}
Procedure TextPrint(Sender : TObject;
                    PrintString : String);

{Given the ReportPrinter component and the string to print
 (which may include tabs), print directly to the printer.}

var
  I, J, NumSpaces, LeftPosInt : Integer;
  TempWidth, LeftPos : Double;
  TempTab : PTab;
  TempStr : String;
  Justify : TPrintJustify;  {pjRight, pjLeft, pjCenter}

begin
  TempStr := '';
  TempWidth := 0;
  Justify := pjLeft;  {Default}
  TempTab := nil;

  with Sender as TBaseReport do
    If GlblPreviewPrint
      then Print(PrintString)
      else
        begin
          For I := 1 to Length(PrintString) do
            If (PrintString[I] = #9)
              then
                begin
                    {First, if there is anything in TempStr to print,
                     then justify it according to the justify type
                     for this tab and print it.}

                  If (TempStr <> '')
                    then
                      begin
                        TempStr := JustifyString(TempStr, TempWidth, Justify);

                        For J := 1 to Length(TempStr) do
                          begin
                            PrintData(TempStr[J]);
                            GlblCurrentLinePos := GlblCurrentLinePos + 1;
                          end;

                      end;  {If (TempStr <> '')}

                  TempStr := '';

                     {Now space for the new tab.}

                  try
                    TempTab := GetTab(GlblCurrentTabNo);
                  except
                    MessageDlg('Error getting tab position.' + #13 +
                               'PrintString = ' + PrintString + #13 +
                               'Tab # = ' + IntToStr(GlblCurrentTabNo),
                               mtError, [mbOK], 0);
                    (*Abort;*)
                  end;

                  GlblCurrentTabNo := GlblCurrentTabNo + 1;

                    {Figure out how many spaces between present spot and tab.}

                  try
                    LeftPos := TempTab^.Pos;
                    LeftPosInt := Trunc(LeftPos * 10);
                  except
                    LeftPosInt := GlblCurrentLinePos + 1;
                  end;

                  NumSpaces := 0;

                  try
                    Justify := TempTab^.Justify;
                  except
                    Justify := pjLeft;
                  end;

                  try
                    TempWidth := TempTab^.Width;
                  except
                    TempWidth := 1.0;
                  end;

                  If (GlblCurrentLinePos < LeftPosInt)
                    then NumSpaces := LeftPosInt - GlblCurrentLinePos;

                  For J := 1 to NumSpaces do
                    begin
                      PrintData(' ');
                      GlblCurrentLinePos := GlblCurrentLinePos + 1;
                    end;

                end
              else TempStr := TempStr + PrintString[I];

            {Finally, if there is anything left over in TempStr to print,
             then justify it according to the justify type
             for this tab and print it.}

          If (TempStr <> '')
            then
              begin
                If (TempWidth > 0)
                  then TempStr := JustifyString(TempStr, TempWidth, Justify);

                For J := 1 to Length(TempStr) do
                  begin
                    PrintData(TempStr[J]);
                    GlblCurrentLinePos := GlblCurrentLinePos + 1;
                  end;

              end;  {If (TempStr <> '')}

        end;  {else of If GlblPreviewPrint}

end;  {TextPrint}

{=====================================================================}
Procedure TextPrintln(Sender : TObject;
                      PrintString : String);

{Given the ReportPrinter component and the string to print
 (which may include tabs), print directly to the printer and
 issue a line feed.}

begin
  TextPrint(Sender, PrintString);

  with Sender as TBaseReport do
    If GlblPreviewPrint
      then CRLF
      else PrintData(#13 + #10);

  GlblCurrentTabNo := 1;
  GlblCurrentLinePos := 1;

end;  {TextPrintln}

{=====================================================================}
Function NumRecordsInRange(      Table : TTable;
                           const _KeyFields : Array of String;
                           const StartRangeValues : Array of String;
                           const EndRangeValues : Array of String) : Integer;

{This procedure figures out how many records there are in a range.
 Example of usage - find out how many sales records there are for a table:
 NumRecordsInRange(SalesTable, [SwisSBLKey, '0'], [SwisSBLKey, '32000'])}

var
  Done, FirstTimeThrough : Boolean;

begin
  FirstTimeThrough := True;
  Done := False;
  Result := 0;

  try
    SetRangeOld(Table, _KeyFields, StartRangeValues, EndRangeValues);
  except
    SystemSupport(985, Table, 'Error setting range on table ' + Table.TableName,
                  'PASUTILS.PAS', GlblErrorDlgBox);
  end;

  Table.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Table.Next;

    If Table.EOF
      then Done := True;

    If not Done
      then Result := Result + 1;

  until Done;

end;  {NumRecordsInRange}

{=======================================================================}
Function ClipText(TempStr : String;
                  Canvas : TCanvas;
                  Width : Real) : String;

{Clip the text so that it fits within the given width on the given canvas.}

var
  I : Integer;

begin
  TempStr := Trim(TempStr);
  Result := '';
  I := 1;

  while ((I <= Length(TempStr)) and
         ((Canvas.TextWidth(Result) / Canvas.Font.PixelsPerInch) < Width)) do
    begin
      Result := Result + TempStr[I];
      I := I + 1;
    end;

  If ((Canvas.TextWidth(Result) / Canvas.Font.PixelsPerInch) > Width)
    then Delete(Result, Length(Result), 1);

end;  {ClipText}

{CHG10271997-1: This procedure is need to make simultaneous TY and NY changes.}
{=======================================================================}
Procedure CopyFields(SourceTable,
                     DestTable : TTable;
                     const ExceptionFields : Array of String;
                     const ExceptionFieldValues : Array of String);

{Before this procedure is called, the destination table is put either
 edit or insert mode and all we have to do is put copy the fields
 except for the exception fields. Note that we will type out the fields
 and copy them this way to avoid any display format problems.

 However, for all the fields in ExceptionFields, substitute the corresponding
 value in the ExceptionFieldValues array.
 For example, if you want to set the 'TaxRollYr' field of the destination
 table to a value different than what is in the source table, you
 would call the procedure in the following way:
 CopyFields(SourceTable, DestTable, ['TaxRollYr'], ['1996']}

var
  I : Integer;
  SourceField : TField;

begin
    {FXX11092004-2(2.8.0.19)[1970]: Make sure that the destination table is in edit mode.}

  If (DestTable.State = dsBrowse)
    then DestTable.Edit;

     {Copy all the fields from the source table to the destination
       table. Note that we are using FieldByName so that we don't have
       to worry about the fields being in the same order between the
       two tables. They should be, but I don't want to make that
       assumption.}

  For I := 0 to (SourceTable.FieldCount - 1) do
    begin
      SourceField := SourceTable.Fields[I];

      If ((UpcaseStr(SourceField.FieldName) <> UpcaseStr('AutoIncrementID')) and
          (not SourceField.Calculated))
        then
          case SourceField.DataType of
            ftString : DestTable.FieldByName(SourceField.FieldName).Text := SourceField.Text;

            ftSmallInt,
            ftInteger,
            ftWord : DestTable.FieldByName(SourceField.FieldName).AsInteger := SourceField.AsInteger;

            ftBoolean : DestTable.FieldByName(SourceField.FieldName).AsBoolean := SourceField.AsBoolean;

            ftFloat,
            ftCurrency : DestTable.FieldByName(SourceField.FieldName).AsFloat := SourceField.AsFloat;

              {FXX11031997-7: If the date or time is blank, don't copy it.
                              Otherwise, we will get a date of 0/0/0000.}
              {FXX03021998-6: Need to check the date in the source table for
                              being blank, not the dest table.}
              {FXX12301999-5: Actually set the dest table date to blank instead.}

            ftDate,
            ftTime,
            ftDateTime : If (Deblank(SourceTable.FieldByName(SourceField.FieldName).Text) = '')
                           then DestTable.FieldByName(SourceField.FieldName).Text := ''
                           else DestTable.FieldByName(SourceField.FieldName).AsDateTime := SourceField.AsDateTime;

          end;  {case SourceField.DataType of}

    end;  {For I := 0 to (SourceTable.FieldCount - 1) do}

    {Now go through the exceptions and use the corresponding values
     instead of the original values from the source table.}

  For I := 0 to High(ExceptionFields) do
    DestTable.FieldByName(ExceptionFields[I]).Text := ExceptionFieldValues[I];

end;  {CopyFields}

{==================================================================}
Procedure SelectItemsInListBox(ListBox : TListBox);

var
  I : Integer;

begin
  with ListBox do
    begin
      If (Items.Count > 0)
        then
          For I := 0 to (Items.Count - 1) do
            try
              Selected[I] := True;
            except
            end;

      try
        TopIndex := 0;
      except
      end;

    end;  {with ListBox do}

end;  {SelectItemsInListBox}

{==============================================================}
Procedure FillOneListBox(ListBox : TCustomListBox;
                         Table : TTable;
                         CodeField,
                         DescriptionField : String;
                         DescriptionLen : Integer;
                         SelectAll,
                         IncludeDescription : Boolean;
                         ProcessingType : Integer;
                         AssessmentYear : String);

var
  FirstTimeThrough, Done : Boolean;
  TempStr, OrigIndexName, OrigIndexFieldNames : String;
  IndexList : TStringList;

begin
  IndexList := nil;
  FirstTimeThrough := True;
  Done := False;

  OrigIndexName := '';
  OrigIndexFieldNames := '';

    {FXX10241999-1: Clear the list of items first.}

  ListBox.Items.Clear;

    {FXX11241999-1: If this is history, set a range so that only codes from that
                    year are displayed.}

  If ((ProcessingType = History) and
      (Table.TableName[1] in ['N', 'T', 'H']))  {Year dependent}
    then
      begin
          {FXX12161999-2: History fixes - problem that index may not be on tax year index.}

(*        IndexList := TStringList.Create;
        Table.GetIndexNames(IndexList);

        For I := 0 to (IndexList.Count - 1) do
          If (Pos('TaxRollYr', IndexList[I]) > 0)
            then Index := I;

        If (Deblank(Table.IndexFieldNames) <> '')
          then OrigIndexFieldNames := Table.IndexFieldNames;

        If (Deblank(Table.IndexName) <> '')
          then OrigIndexName := Table.IndexName;

        Table.IndexName := IndexList[Index];

        Table.SetRange([AssessmentYear], [AssessmentYear]);*)

          {FXX01082004-1(2.07l): SetRange does not work - use a filter instead.}

        Table.Filtered := False;
        Table.Filter := 'TaxRollYr = ' + AssessmentYear;
        Table.Filtered := True;

      end;  {If ((ProcessingType = History) and ...}

  Table.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Table.Next;

    If Table.EOF
      then Done := True;

    If not Done
      then
        begin
          TempStr := Table.FieldByName(CodeField).Text;

          If IncludeDescription
            then TempStr := TempStr + ' - ' +
                            Take(DescriptionLen, Table.FieldByName(DescriptionField).AsString);

          ListBox.Items.Add(TempStr);

        end;  {If not Done}

  until Done;

  If SelectAll
    then
      begin
        If (ListBox is TListBox)
          then SelectItemsInListBox(TListBox(ListBox));

        If (ListBox is TCheckListBox)
          then SelectItemsInCheckListBox(TCheckListBox(ListBox));

      end;  {If SelectAll}

    {Switch back to original index if history.}

  If ((ProcessingType = History) and
      (Table.TableName[1] in ['N', 'T', 'H']))  {Year dependent}
    then
      begin
        Table.CancelRange;

        If (Deblank(OrigIndexFieldNames) <> '')
          then Table.IndexFieldNames := OrigIndexFieldNames;

        If (Deblank(OrigIndexName) <> '')
          then Table.IndexName := OrigIndexName;

        IndexList.Free;

      end;  {If ((ProcessingType = History) and ...}

  try
    ListBox.TopIndex := 0;
  except
  end;

end;  {FillOneListBox}

{==============================================================}
Procedure FillOneComboBox(ComboBox : TComboBox;
                          Table : TTable;
                          CodeField,
                          DescriptionField : String;
                          DescriptionLen : Integer;
                          IncludeDescription : Boolean;
                          ProcessingType : Integer;
                          AssessmentYear : String);

var
  FirstTimeThrough, Done : Boolean;
  TempStr, OrigIndexName, OrigIndexFieldNames : String;
  IndexList : TStringList;

begin
  IndexList := nil;
  FirstTimeThrough := True;
  Done := False;

  OrigIndexName := '';
  OrigIndexFieldNames := '';

    {FXX10241999-1: Clear the list of items first.}

  ComboBox.Items.Clear;

    {FXX11241999-1: If this is history, set a range so that only codes from that
                    year are displayed.}

  If ((ProcessingType = History) and
      (Table.TableName[1] in ['N', 'T', 'H']))  {Year dependent}
    then
      begin
          {FXX12161999-2: History fixes - problem that index may not be on tax year index.}

(*        IndexList := TStringList.Create;
        Table.GetIndexNames(IndexList);

        For I := 0 to (IndexList.Count - 1) do
          If (Pos('TaxRollYr', IndexList[I]) > 0)
            then Index := I;

        If (Deblank(Table.IndexFieldNames) <> '')
          then OrigIndexFieldNames := Table.IndexFieldNames;

        If (Deblank(Table.IndexName) <> '')
          then OrigIndexName := Table.IndexName;

        Table.IndexName := IndexList[Index];

        Table.SetRange([AssessmentYear], [AssessmentYear]);*)

          {FXX01082004-1(2.07l): SetRange does not work - use a filter instead.}

        Table.Filtered := False;
        Table.Filter := 'TaxRollYr = ' + AssessmentYear;
        Table.Filtered := True;

      end;  {If ((ProcessingType = History) and ...}

  Table.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Table.Next;

    If Table.EOF
      then Done := True;

    If not Done
      then
        begin
          TempStr := Table.FieldByName(CodeField).Text;

          If IncludeDescription
            then TempStr := TempStr + ' - ' +
                            Take(DescriptionLen, Table.FieldByName(DescriptionField).AsString);

          ComboBox.Items.Add(TempStr);

        end;  {If not Done}

  until Done;

    {Switch back to original index if history.}

  If ((ProcessingType = History) and
      (Table.TableName[1] in ['N', 'T', 'H']))  {Year dependent}
    then
      begin
        Table.CancelRange;

        If (Deblank(OrigIndexFieldNames) <> '')
          then Table.IndexFieldNames := OrigIndexFieldNames;

        If (Deblank(OrigIndexName) <> '')
          then Table.IndexName := OrigIndexName;

        IndexList.Free;

      end;  {If ((ProcessingType = History) and ...}

end;  {FillOneComboBox}

{========================================================================}
Function RecordsAreDifferent(Table1,
                             Table2 : TTable) : Boolean;

{Compare 2 records field by field and see if the records match.
 Always ignore TaxRollYr.
 Note that the 2 tables must be the same type.}

var
  I : Integer;
  TempStr : String;

begin
  Result := False;

  with Table1 do
    For I := 0 to (FieldCount - 1) do
      begin
        TempStr := Fields[I].FieldName;

        If (TempStr <> 'TaxRollYr')
          then
            try
              If (Table1.FieldByName(TempStr).Text <>
                  Table2.FieldByName(TempStr).Text)
                then Result := True;
            except
            end;

      end;  {with Table1 do}

end;  {RecordsAreDifferent}

{================================================================================}
Procedure SetPrinter(Sender : TObject;
                     Laser,
                     WideCarriage,
                     PrintToScreen : Boolean);

begin
  with Sender as TBaseReport do
    begin
      SelectPrinter(Printer.Printers[Printer.PrinterIndex]);

        {FXX08052003-1(2.07h): Default this.}

      SetPaperSize(dmPaper_Letter, 0, 0);

      If WideCarriage
        then
          begin
            If Laser
              then
                begin
                  Orientation := poLandscape;
                  SetPaperSize(dmPaper_Legal, 0, 0);
                  (*ScaleX := 77;*)

                    {CHG12081999-1: Option to prompt if legal paper is required.}

                  If (GlblRemindForLegalPaper and
                      (Sender is TReportPrinter) and
                      (not PrintToScreen))
                    then MessageDlg('Please put legal paper in the laser printer.',
                                    mtInformation, [mbOK], 0);
                end
              else
                begin
                  Orientation := poPortrait;
                  SetPaperSize(0, 14, 11);
                end;

              {Set wide margins for the laser or for print to screen.}

            If (Laser or
                (Pos('Filer', TWinControl(Sender).Name) > 0))
              then
                begin
                  SectionTop := 0.9;
                  SectionLeft := 0.2;
                  SectionRight := PageWidth - 0.2;
                  ClearTabs;
                  SetTab(0.1, pjLeft, 12, 0, BOXLINENone, 0);   {Line}

                end;  {If (Laser or ...}

          end
        else Orientation := poPortrait;

    end;  {with Sender as TBaseReport do}

end;  {SetPrinter}

{================================================================================}
Procedure SetEnhancedOptions(PrintDialog : TPrintDialog;
                             ReportObject : TObject;
                             PrintToType : PrintToTypeSet;
                             WideCarriage : Boolean);

{CHG06302001-1: Set enhanced options such as collate, duplex, bins.}

(*var
  CurrentBin : String;
  DuplexType : TDuplex; *)

begin
  with ReportObject as TBaseReport do
    begin
      Copies := PrintDialog.Copies;

      If ((PrintDialog.PrintRange <> prAllPages) and
          (PrintDialog.ToPage > 0))
        then
          begin
            FirstPage := PrintDialog.FromPage;
            LastPage := PrintDialog.ToPage;
          end;  {If ((PrintDialog.PrintRange <> prAllPages) and ...}

      Collate := (SupportCollate and
                  PrintDialog.Collate);

(*      If SupportBin
        then
          begin
              {Get bin that is currently selected.}

            SelectBin(CurrentBin);

          end;  {If SupportBins} *)

        {Reduce to fit regular paper if they want.}

(*      If ((Orientation = poLandscape) and
          ((GlblAlwaysPrintOnLetterPaper or
           (MessageDlg('Do you want to print on letter size paper?',
                       mtConfirmation, [mbYes, mbNo], 0) = idYes))))
        then
          begin
            SetPaperSize(dmPaper_Letter, 0, 0);
            Orientation := poLandscape;

            ScaleX := 77;
            ScaleY := 70;
            SectionLeft := 1.5;

          end;  {If ((Orientation = poLandscape) and ...}

        {If they can duplex, do it.}

      Duplex := dupSimplex;

      If (SupportDuplex and
          (MessageDlg('Do you want to print on both sides of the paper?',
                      mtConfirmation, [mbYes, mbNo], 0) = idYes))
        then
          begin
            If (MessageDlg('Do you want to vertically duplex this report?',
                            mtConfirmation, [mbYes, mbNo], 0) = idYes)
              then Duplex := dupVertical
              else Duplex := dupHorizontal;

          end;  {If (SupportDuplex and ...} *)

    end;  {with ReportObject as TBaseReport do}

end;  {SetEnhancedOptions}

{================================================================================}
Function PrinterIsDotMatrix : Boolean;

var
  PrinterTable : TTable;

begin
  SelectPrinterForPrintScreen;
  PrinterTable := TTable.Create(nil);
  PrinterTable.DatabaseName := 'PASsystem';
  PrinterTable.TableType := ttDBase;
  PrinterTable.TableName := 'InstalledPrinterTbl';
  PrinterTable.Open;

  PrinterTable.IndexName := 'BYPRINTERNAME';
  FindNearestOld(PrinterTable, ['PrinterName'],
                 [Printer.Printers[Printer.PrinterIndex]]);

  Result := not PrinterTable.FieldByName('Laser').AsBoolean;

  PrinterTable.Close;
  PrinterTable.Free;

end;  {PrinterIsDotMatrix}

{================================================================================}
Procedure AssignPrinterSettings(    PrintDialog : TPrintDialog;
                                    ReportPrinter,
                                    ReportFiler : TObject;
                                    PrintToType : PrintToTypeSet;
                                    WideCarriage : Boolean;
                                var Quit : Boolean);

{CHG10131998-1: Set the printer settings based on what printer they selected
                only - they no longer need to worry about paper or landscape
                mode.}

var
  PrinterTable : TTable;
  Laser, Found : Boolean;
  CurrentPrinter, CurrentPrinterBase, TempStr : String;
  I, FilePos, TempLength : Integer;

begin
   {If the last thing done was a print to screen, then the printer
     index is now pointing at the printer redirected to file,
     i.e. if the driver is 'HP LJ 6 on LPT1:', it may now be
     'HP LJ 6 on FILE'.  We want to change it to the main one.}

  CurrentPrinter := Printer.Printers[Printer.PrinterIndex];
  FilePos := Pos('FILE', CurrentPrinter);

  If (FilePos > 0)
    then
      begin
        CurrentPrinterBase := CurrentPrinter;
        Delete(CurrentPrinterBase, FilePos, 5);
        TempLength := Length(CurrentPrinterBase);
        Found := False;

          {Now look for the base printer.  Note that we won't get
           the same result since the driver directed to file is
           the last one.  We will find the base before then.}

        For I := 0 to (Printer.PrinterIndex - 1) do
          If ((not Found) and
              (Take(TempLength, Printer.Printers[I]) =
               Take(TempLength, CurrentPrinterBase)))
            then
              begin
                Printer.PrinterIndex := I;
                Found := True;
              end;

      end;  {If (FilePos > 0)}

  Quit := False;
  PrinterTable := TTable.Create(nil);
  PrinterTable.DatabaseName := 'PASsystem';
  PrinterTable.TableType := ttDBase;
  PrinterTable.TableName := 'InstalledPrinterTbl';
  PrinterTable.Open;

  PrinterTable.IndexName := 'BYPRINTERNAME';
  FindNearestOld(PrinterTable, ['PrinterName'],
                 [Printer.Printers[Printer.PrinterIndex]]);
  Found := True;

  TempStr := Printer.Printers[Printer.PrinterIndex];

  If Found
    then
      begin
        Laser := PrinterTable.FieldByName('Laser').AsBoolean;

          {Make sure that the printer type for the report is compatible with what they selected.}

        If (Laser and
            (PrintToType = [ptDotMatrix]))
          then
            begin
              Quit := True;
              MessageDlg('This report can only print to a dot matrix printer.' + #13 +
                         'Please select a different printer.', mtError, [mbOK], 0);
            end;

          {FXX10092004-1(2.8.0.14): Eliminate this stupid message - people were getting it
                                    when they should not have due to answering the
                                    "Is it laser?" question wrong.}

        If ((not Laser) and
            (PrintToType = [ptLaser]))
          then Laser := True;
(*            begin
              Quit := True;
              MessageDlg('This report can only print to a laser or ink jet printer.' + #13 +
                         'Please select a different printer.', mtError, [mbOK], 0);
            end; *)

        If not Quit
          then
            begin
              SetPrinter(ReportPrinter, Laser, WideCarriage, PrintDialog.PrintToFile);
              SetPrinter(ReportFiler, Laser, WideCarriage, PrintDialog.PrintToFile);
            end;

      end
    else
      begin
        MessageDlg('Warning! PAS does not recognize this printer.' + #13 +
                   'Please make sure that the printer settings are correct for this report.',
                   mtWarning, [mbOK], 0);
      end;

    {CHG06302001-1: Set enhanced options such as collate, duplex, bins.}

  SetEnhancedOptions(PrintDialog, ReportPrinter, PrintToType, WideCarriage);

    {Set the report filer to the same settings.}

  with ReportFiler as TBaseReport do
    begin
      Copies := TBaseReport(ReportPrinter).Copies;
      Collate := TBaseReport(ReportPrinter).Collate;
      Duplex := TBaseReport(ReportPrinter).Duplex;
      FirstPage := TBaseReport(ReportPrinter).FirstPage;
      LastPage := TBaseReport(ReportPrinter).LastPage;
      ScaleX := TBaseReport(ReportPrinter).ScaleX;
      ScaleY := TBaseReport(ReportPrinter).ScaleY;
      SectionLeft := TBaseReport(ReportPrinter).SectionLeft;

        {Select the same bin as the printer.}

    end;  {with ReportFiler do}

  PrinterTable.Close;
  PrinterTable.Free;

end;  {AssignPrinterSettings}

{======================================================================}
Procedure SetPrintToScreenDefault(PrintDialog : TPrintDialog);

{CHG10121998-1: Add user options for default destination and show vet max msg.}

begin
  PrintDialog.PrintToFile := GlblPrintToScreenDefault;
end;  {SetPrintToScreenDefault}

{======================================================================}
Procedure ClearStringGrid(StringGrid : TStringGrid);

var
  I, J : Integer;

begin
  with StringGrid do
    For I := 0 to (ColCount - 1) do
      For J := 0 to (RowCount - 1) do
        Cells[I, J] := '';

end;  {ClearStringGrid}

{===================================================================}
Procedure SortListAndGetStats(    List : TStringList;
                              var Median,
                                  Mean,
                                  COD : Double);

{Given a list of numbers, sort them into order from lowest to highest and
 then get the statistics.}

var
  I, J, Index : Integer;
  TempStr : String;
  ThisPercentDifference,
  Total, TotalPercentDifference : Double;

begin
  For I := 0 to (List.Count - 1) do
    For J := (I + 1) to (List.Count - 1) do
      If (StrToFloat(List[J]) < StrToFloat(List[I]))
        then
          begin
            TempStr := List[J];
            List[J] := List[I];
            List[I] := TempStr;

          end;  {If (StrToFloat(List[J]) < StrToFloat(List[I]))}

    {Get the total for the mean.}

  Total := 0;

  For I := 0 to (List.Count - 1) do
    Total := Total + StrToFloat(List[I]);

  If (List.Count = 0)
    then Mean := 0
    else
      try
        Mean := Roundoff((Total / List.Count), 2);
      except
        Mean := 0;
      end;

    {Now figure out the median.}
    {FXX02251998-2: The median should be on list.count - 1 (the actual indices).}

  If Odd(List.Count)
    then
      begin
        try
            {FXX07171998 - when count = 1, index should be 0}
            {FXX07301998-3: Adding one to index, but should not because is 0 based.}

          Index := (List.Count - 1) DIV 2;
          Median := StrToFloat(List[Index]);
        except
          Median := 0;
        end;
      end
    else
      begin
        try
            {Add up the 2 middle numbers and divide.}
          Index := (List.Count - 1) DIV 2;

          If (List.Count = 0)
            then Median := 0
            else Median := (StrToFloat(List[Index]) + StrToFloat(List[Index + 1])) / 2;
        except
          Median := 0;
        end;

      end;  {else of If Odd(List.Count)}

    {Now figure out the coefficient of dispersion - the average difference
     from the mean of each item.}

  TotalPercentDifference := 0;

    {FXX02251998-1: Need an exception handler around total percent difference.
                    This is in case there is a small population and the
                    median is zero.}

  If (Roundoff(Median, 0) <> 0)
    then
      try
        For I := 0 to (List.Count - 1) do
          begin
            ThisPercentDifference := Abs(Roundoff(((StrToFloat(List[I]) - Median) / Median) * 100, 3));

            TotalPercentDifference := TotalPercentDifference + ThisPercentDifference;

          end;  {For I := 0 to (List.Count - 1) do}

      except
        TotalPercentDifference := 0;
      end;

  If (List.Count = 0)
    then COD := 0
    else
      try
        COD := Roundoff((TotalPercentDifference / List.Count), 3);
      except
        COD := 0;
      end;

end;  {SortListAndGetStats}

{======================================================================}
Procedure CopyMemoField(SourceField,
                        DestField : TField);

begin
  with SourceField as TMemoField do
    SaveToFile('TEMP.TXT');
  TMemoField(DestField).LoadFromFile('TEMP.TXT');

end;  {CopyMemoField}

{======================================================================}
Procedure SaveReportOptions(Form : TForm;
                            OpenDialog : TOpenDialog;
                            SaveDialog : TSaveDialog;
                            DefaultFileName,
                            ReportName : String);

{CHG04271999-1: Let them save the report options.}

var
  TempFile : TextFile;
  FileName : String;
  I, J, K : Integer;

begin
  SaveDialog.InitialDir := GlblReportOptionsDir;

    {If they did not load report options, use the default file name.  Otherwise,
     use the file name they loaded as the default.}

  If (Deblank(OpenDialog.FileName) = '')
    then SaveDialog.FileName := DefaultFileName
    else SaveDialog.FileName := OpenDialog.FileName;

  If SaveDialog.Execute
    then
      begin
        FileName := SaveDialog.FileName;
        AssignFile(TempFile, FileName);
        Rewrite(TempFile);

        Writeln(TempFile, ReportName);

        with Form do
          begin
            For I := 0 to (ComponentCount - 1) do
              If ((Components[I] is TStringGrid) or
                  (Components[I] is TEdit) or
                  (Components[I] is TDBEdit) or
                  (Components[I] is TListBox) or
                  (Components[I] is TRadioGroup) or
                  (Components[I] is TMaskEdit) or
                  (Components[I] is TwwDBLookupCombo) or
                  (Components[I] is TCheckBox))
                then
                  begin
                      {FXX05012000-3: Support DB edits.}

                    If ((Components[I] is TEdit) or
                        (Components[I] is TDBEdit))
                      then Writeln(TempFile, Components[I].Name, ';',
                                             Components[I].ClassName, ';',
                                             TEdit(Components[I]).Text);

                    If (Components[I] is TMaskEdit)
                      then Writeln(TempFile, Components[I].Name, ';',
                                             Components[I].ClassName, ';',
                                             TMaskEdit(Components[I]).Text);

                    If (Components[I] is TRadioGroup)
                      then Writeln(TempFile, Components[I].Name, ';',
                                             Components[I].ClassName, ';',
                                             TRadioGroup(Components[I]).ItemIndex);

                    If (Components[I] is TCheckBox)
                      then Writeln(TempFile, Components[I].Name, ';',
                                             Components[I].ClassName, ';',
                                             TCheckBox(Components[I]).Checked);

                    If (Components[I] is TwwDBLookupCombo)
                      then Writeln(TempFile, Components[I].Name, ';',
                                             Components[I].ClassName, ';',
                                             TwwDBLookupCombo(Components[I]).Text);

                      {For a list box, write out all the items, with a 0 if not
                       selected, and a 1 if selected.}

                    If (Components[I] is TListBox)
                      then
                        For J := 0 to (TListBox(Components[I]).Items.Count - 1) do
                          Writeln(TempFile, Components[I].Name, ';',
                                            Components[I].ClassName, ';',
                                            TListBox(Components[I]).Items[J], ';',
                                            BoolToChar_0_1(TListBox(Components[I]).Selected[J]));

                      {For a list box, write out all cells.}

                    If (Components[I] is TStringGrid)
                      then
                        For J := 0 to (TStringGrid(Components[I]).ColCount - 1) do
                          For K := 0 to (TStringGrid(Components[I]).RowCount - 1) do
                            Writeln(TempFile, Components[I].Name, ';',
                                              Components[I].ClassName, ';',
                                              TStringGrid(Components[I]).Cells[J, K], ';',
                                              IntToStr(J), ';',
                                              IntToStr(K));

                  end;  {If (Components[I] in}

          end;  {with Form do}

        CloseFile(TempFile);

      end;  {If SaveDialog.Execute}

end;  {SaveReportOptions}

{====================================================================}
Procedure ParseLine(    TempStr : String;
                    var ComponentName,
                        ComponentClass,
                        Value : String;
                    var Column,          {For string grids.}
                        Row : Integer);

{FXX06181999-2: Sometimes the values had commas in them and caused problems, so use a semicolon instead.}

var
  SemiColonPos : Integer;

begin
    {First is component name.}

  SemiColonPos := Pos(';', TempStr);
  ComponentName := Copy(TempStr, 1, (SemiColonPos - 1));
  Delete(TempStr, 1, SemiColonPos);

    {Next is component class.}

  SemiColonPos := Pos(';', TempStr);
  ComponentClass := Copy(TempStr, 1, (SemiColonPos - 1));
  Delete(TempStr, 1, SemiColonPos);

    {Value may be the rest unless this is a string grid.}

  SemiColonPos := Pos(';', TempStr);
  If (SemiColonPos = 0)
    then Value := Copy(TempStr, 1, 255)
    else
      begin
        Value := Copy(TempStr, 1, (SemiColonPos - 1));
        Delete(TempStr, 1, SemiColonPos);

          {Column}

        SemiColonPos := Pos(';', TempStr);
        try
          If (SemiColonPos = 0)
            then Column := StrToInt(Copy(TempStr, 1, 255)) {List box, take the rest.}
            else Column := StrToInt(Copy(TempStr, 1, (SemiColonPos - 1)));
        except
          Column := 0;
        end;
        Delete(TempStr, 1, SemiColonPos);

          {Row}

        try
          Row := StrToInt(Copy(TempStr, 1, 255));
        except
          Row := 0;
        end;

      end;  {else of If (SemiColonPos = 0)}

end;  {ParseLine}

{===================================================================}
Function LoadReportOptions(Form : TForm;
                           OpenDialog : TOpenDialog;
                           DefaultFileName,
                           ReportName : String) : Boolean;

var
  TempFile : TextFile;
  FileName : String;
  I, Index, Index2, Column, Row : Integer;
  Found, Done : Boolean;
  TempStr, ComponentName, ComponentClass, Value : String;

begin
  OpenDialog.InitialDir := GlblReportOptionsDir;
  OpenDialog.FileName := DefaultFileName;
  Result := False;
  Index := 0;

  If OpenDialog.Execute
    then
      begin
        FileName := OpenDialog.FileName;
        Result := False;
        AssignFile(TempFile, FileName);
        Reset(TempFile);

        Readln(TempFile, TempStr);

        with Form do
          begin
            If (TempStr = ReportName)
              then
                begin
                  Done := False;

                  repeat
                    Readln(TempFile, TempStr);

                    If EOF(TempFile)
                      then Done := True;

                    ParseLine(TempStr, ComponentName, ComponentClass, Value,
                                       Column, Row);

                      {Find this component on the form.}

                    Found := False;
                    For I := 0 to (ComponentCount - 1) do
                      If (Components[I].Name = ComponentName)
                        then
                          begin
                            Found := True;
                            Index := I;
                          end;

                    If Found
                      then
                        begin
                          If (ComponentClass = 'TEdit')
                            then TEdit(Components[Index]).Text := Value;

                          If (ComponentClass = 'TMaskEdit')
                            then TMaskEdit(Components[Index]).Text := Value;

                          If (ComponentClass = 'TRadioGroup')
                            then TRadioGroup(Components[Index]).ItemIndex := StrToInt(Value);

                          If (ComponentClass = 'TCheckBox')
                            then TCheckBox(Components[Index]).Checked := StrToBool(Value);

                          If (ComponentClass = 'TwwDBLookupCombo')
                            then
                              with Components[Index] as TwwDBLookupCombo do
                                Text := Value;

                          If (ComponentClass = 'TListBox')
                            then
                              begin
                                Index2 := TListBox(Components[Index]).Items.IndexOf(Value);

                                  {If not found, add it.}

                                If (Index2 = -1)
                                  then
                                    begin
                                      TListBox(Components[Index]).Items.Add(Value);
                                      Index2 := TListBox(Components[Index]).Items.IndexOf(Value);
                                    end;

                                  {0 = False, 1 = True}

                                try
                                  with Components[Index] as TListBox do
                                    If (ExtendedSelect or MultiSelect)
                                      then
                                        begin
                                          If (Column = 0)
                                            then Selected[Index2] := False
                                            else Selected[Index2] := True;
                                        end
                                      else
                                        If (Column = 1)
                                          then ItemIndex := Index2;
                                except
                                end;

                              end;  {If (ComponentClass = 'TListBox')}

                          If (ComponentClass = 'TStringGrid')
                            then
                              try
                                TStringGrid(Components[Index]).Cells[Column, Row] := Value;
                              except
                              end;

                        end;  {If Found}

                  until Done;
                  Result := True;
                end
              else MessageDlg('Sorry, those report options are not for the ' + ReportName + 'report.' + #13 +
                              'They are for the ' + TempStr + ' report.' + #13 +
                              'Please select a different file of report options.',
                              mtError, [mbOK], 0);

          end;  {with Form do}

        CloseFile(TempFile);

      end;  {If OpenDialog}

end;  {LoadReportOptions}

{==================================================================}
Procedure DisplayPrintingFinishedMessage(PrintToScreen : Boolean);

{FXX09071999-6: Tell people that printing is starting and done.}

begin
  If not PrintToScreen
    then MessageDlg('The report has printed.', mtInformation, [mbOK], 0);
end;

{================================================================}
Function FindValueInRange(AssessmentYear : String;
                          SwisSBLKey : String;
                          Table : TTable;
                          SearchField : String;
                          ValuesList : TStringList;
                          AllowPartialMatch : Boolean) : Boolean;

var
  Done, FirstTimeThrough, FoundPartialMatch : Boolean;
  I : Integer;

begin
  Table.CancelRange;
  SetRangeOld(Table,
              ['TaxRollYr', 'SwisSBLKey'],
              [AssessmentYear, SwisSBLKey],
              [AssessmentYear, SwisSBLKey]);
  Table.First;

  Done := False;
  FirstTimeThrough := True;
  Result := False;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Table.Next;

    If Table.EOF
      then Done := True;

    FoundPartialMatch := False;

    If AllowPartialMatch
      then
        For I := 0 to (ValuesList.Count - 1) do
          If (Pos(ValuesList[I], Table.FieldByName(SearchField).Text) > 0)
            then FoundPartialMatch := True;

    If ((not Done) and
        ((ValuesList.IndexOf(Table.FieldByName(SearchField).Text) > -1) or
         FoundPartialMatch))
      then Result := True;

  until Done;

  Table.CancelRange;

end;  {FindValueInRange}

{==================================================================}
Function RecordsDifferent(Table1,
                          Table2 : TTable) : Boolean;

var
  I : Integer;
  TempStr : String;

begin
  Result := False;

  with Table1 do
    For I := 0 to (FieldCount - 1) do
      begin
        TempStr := Fields[I].FieldName;
        If (FieldByName(TempStr).Text <> Table2.FieldByName(TempStr).Text)
          then Result := True;
      end;

end;  {RecordsDifferent}

{=============================================================================}
Procedure ResetPrinter(ReportPrinter : TObject);

{FXX05152000-1: Make sure to reset to portrait, letter.}

begin
  with ReportPrinter as TBaseReport do
    begin
      Orientation := poPortrait;
      SetPaperSize(dmPaper_Letter, 0, 0);
    end;

end;  {ResetPrinter}

{===================================================}
Procedure SetRangeOld(      Table : TTable;
                      const _Fields : Array of String;
                      const StartRange : Array of String;
                      const EndRange : Array of String);

{For backwards compatibility.}

var
  I : Integer;

begin
  with Table do
    begin
      LogTime('c:\trace.txt', 'SetRange - before ' + TableName);

      CancelRange;
      SetRangeStart;

      For I := 0 to High(_Fields) do
        FieldByName(_Fields[I]).Text := StartRange[I];

      SetRangeEnd;

      For I := 0 to High(_Fields) do
        FieldByName(_Fields[I]).Text := EndRange[I];

      ApplyRange;

      LogTime('c:\trace.txt', 'SetRange - after ' + TableName);

    end;  {with Table do}

end;  {SetRangeOld}

{===================================================}
Function FindKeyOld(      Table : TTable;
                    const _Fields : Array of String;
                    const Values : Array of String) : Boolean;

{For backwards compatibility.}

var
  I : Integer;

begin
  with Table do
    begin
      SetKey;

      For I := 0 to High(_Fields) do
        FieldByName(_Fields[I]).Text := Values[I];

      Result := GotoKey;

    end;  {with Table do}

end;  {FindKeyOld}

{===================================================}
Procedure FindNearestOld(      Table : TTable;
                         const _Fields : Array of String;
                         const Values : Array of String);

{For backwards compatibility.}

var
  I : Integer;

begin
  with Table do
    begin
      SetKey;

      For I := 0 to High(_Fields) do
        FieldByName(_Fields[I]).Text := Values[I];

      GotoNearest;

    end;  {with Table do}

end;  {FindNearestOld}

{=============================================================}
Procedure CopySortFile(SourceTable : TTable;
                       SortFileName : String);

{Copy a sort file template to a temporary sort file using BatchMove.}

var
  TblDesc: CRTblDesc;
  PtrFldDesc, PtrIdxDesc: Pointer;
  CursorProp: CURProps;

begin
  SourceTable.Open;
  Check(DbiGetCursorProps(SourceTable.Handle, CursorProp));
     // Allocate memory for field descriptors
  PtrFldDesc := AllocMem(SizeOf(FLDDesc) * CursorProp.iFields);
  PtrIdxDesc := AllocMem(SizeOf(IDXDesc) * CursorProp.iIndexes);

  try
    Check(DbiGetFieldDescs(SourceTable.Handle, PtrFldDesc));
    Check(DbiGetIndexDescs(SourceTable.Handle, PtrIdxDesc));
    FillChar(TblDesc, SizeOf(TblDesc), #0);

    with TblDesc do
      begin
        StrPCopy(szTblName, SortFileName);
        StrCopy(szTblType, CursorProp.szTableType);
        iFldCount := CursorProp.iFields;
        pfldDesc := PtrFldDesc;
        iIdxCount := CursorProp.iIndexes;
        pIdxDesc := PtrIdxDesc;
      end;

    Check(DbiCreateTable(SourceTable.DBHandle, True, TblDesc));

    finally
      FreeMem(PtrFldDesc);
      FreeMem(PtrIdxDesc);
    end; 

end;  {CopyTable}

{=======================================================}
Procedure SetFormStateMaximized(Form : TForm);

begin
  Form.WindowState := wsMaximized;
end;

{==========================================================================}
Function GetSortFileName(StartingLetters : String) : String;

{Get the name of a sort file used for reporting, etc. The extension will
 end with .SRT.
 The form of the file is xxxxMMSS.SRT.}
{FXX12011997-1: Name the sort files with the date and time and extension of
                .SRT.}

var
  Hour, Minute,
  Second, Millisecond : Word;

begin
  DecodeTime(Now, Hour, Minute, Second, Millisecond);

  Result := 'SORT_' + StartingLetters +
            ShiftRightAddZeroes(Take(2, IntToStr(Minute))) +
            ShiftRightAddZeroes(Take(2, IntToStr(Second))) +
            ShiftRightAddZeroes(Take(2, IntToStr(MilliSecond))) +
            ShiftRightAddZeroes(Take(4, IntToStr(Random(9999)))) + '.DBF';

end;  {GetSortFileName}

{=======================================================}
Procedure CopyAndOpenSortFile(    SortTable : TTable;
                                  SortFilePrefix : String;
                                  OrigSortFileName : String;
                              var SortFileName : String;
                                  Exclusive : Boolean;
                                  ComputeSortFileName : Boolean;
                              var Quit : Boolean);

var
  E : TObject;
  TempStr : String;

begin
  If (SortTable.DatabaseName = '')
    then SortTable.DatabaseName := 'PASSystem';

  If (SortTable.TableType = ttDefault)
    then SortTable.TableType := ttDBase;

  SortTable.Close;
  SortTable.TableName := OrigSortFileName;

  If ComputeSortFileName
    then SortFileName := GetSortFileName(SortFilePrefix)
    else SortFileName := SortFilePrefix;

  CopySortFile(SortTable, SortFileName);
  SortTable.Close;
  SortTable.TableName := SortFileName;
  SortTable.Exclusive := Exclusive;

  try
    SortTable.Open;
  except
    try
      If (ExceptObject = nil)
        then TempStr := ''
        else
          begin
            E := ExceptObject;
            TempStr := Exception(E).ClassName;
          end;

    except
      TempStr := '';
    end;

    Quit := True;
    MessageDlg('Error opening sort table ' + OrigSortFileName +
               '. (Copied name = ' + SortFileName + ').' + #13 +
               'Exception = ' + TempStr + '.' + #13 +
               'Please call SCA and report the problem.',
               mtError, [mbOK], 0);

  end;

end;  {CopyAndOpenSortFile}

(*
{=================================================================}
Procedure PrintScreen(Form : TForm);

var
  ScreenImage : TBitMap;
  MultiImage1 : TPMultiImage;
  I, FilePos, TempLength : Integer;
  CurrentPrinter, CurrentPrinterBase : String;
  Found : Boolean;

begin
   {If the last thing done was a print to screen, then the printer
     index is now pointing at the printer redirected to file,
     i.e. if the driver is 'HP LJ 6 on LPT1:', it may now be
     'HP LJ 6 on FILE'.  We want to change it to the main one.}

  CurrentPrinter := Printer.Printers[Printer.PrinterIndex];
  FilePos := Pos('FILE', CurrentPrinter);

  If (FilePos > 0)
    then
      begin
        CurrentPrinterBase := CurrentPrinter;
        Delete(CurrentPrinterBase, FilePos, 5);
        TempLength := Length(CurrentPrinterBase);
        Found := False;

          {Now look for the base printer.  Note that we won't get
           the same result since the driver directed to file is
           the last one.  We will find the base before then.}

        For I := 0 to (Printer.PrinterIndex - 1) do
          If ((not Found) and
              (Take(TempLength, Printer.Printers[I]) =
               Take(TempLength, CurrentPrinterBase)))
            then
              begin
                Printer.PrinterIndex := I;
                Found := True;
              end;

      end;  {If (FilePos > 0)}

    {FXX10032000-6(MDT): Force the printer to portrait mode.}

  Printer.Orientation := Printers.poPortrait;  {Definition in printers unit}

  try
    MultiImage1 := TPMultiImage.Create(nil);
    ScreenImage := TBitMap.Create;
    ScreenImage := Form.GetFormImage;
    MultiImage1.Picture.Bitmap.Assign(ScreenImage);

   (* MultiImage1.ImageText(20, 50, 0, False, True, clSilver,
                          'Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now));
    MultiImage1.PrintMultiImage(20, 50, 3920, 3050);
  finally
    ScreenImage.Free;
    MultiImage1.Free;
  end;

end;  {PrintScreen} *)

{=================================================================}
Procedure SelectPrinterForPrintScreen;

{If the last thing done was a print to screen, then the printer
 index is now pointing at the printer redirected to file,
 i.e. if the driver is 'HP LJ 6 on LPT1:', it may now be
 'HP LJ 6 on FILE'.  We want to change it to the main one.}

var
  I, FilePos, TempLength, iOnPos : Integer;
  CurrentPrinter, CurrentPrinterBase : String;
  Found : Boolean;

begin
  try
    CurrentPrinter := Printer.Printers[Printer.PrinterIndex];
  except
  end;

  FilePos := Pos('FILE', CurrentPrinter);
  iOnPos := Pos(' on ', CurrentPrinter);

(*  ShowMessage(CurrentPrinter + ': ' + IntToStr(iOnPos)); *)

  If (_Compare(FilePos, 0, coGreaterThan) or
      _Compare(iOnPos, 0, coGreaterThan))
    then
      begin
        CurrentPrinterBase := CurrentPrinter;

        If _Compare(FilePos, 0, coGreaterThan)
          then Delete(CurrentPrinterBase, FilePos, 5)
          else Delete(CurrentPrinterBase, iOnPos, 100);

        TempLength := Length(CurrentPrinterBase);
(*        ShowMessage('Trimmed: ' + CurrentPrinterBase + ': ' + IntToStr(TempLength)); *)
        Found := False;

          {Now look for the base printer.  Note that we won't get
           the same result since the driver directed to file is
           the last one.  We will find the base before then.}

        try
          For I := 0 to (Printer.PrinterIndex - 1) do
            begin
(*              ShowMessage(IntToStr(I) + ': ' + Printer.Printers[I]); *)

            If ((not Found) and
                _Compare(Copy(Printer.Printers[I], 1, TempLength),
                         Copy(CurrentPrinterBase, 1, TempLength), coEqual))
              then
                begin
                  try
                    Printer.PrinterIndex := I;
                  except
                  end;

                  Found := True;
                end;

            end;

        except
          Found := False;
        end;

          {FXX01302009(2.16.1.19): Don't refresh the printer unless it is changed.
                                   Otherwise, we get an "Index out of bounds."}

        try
          Printer.Refresh;
        except
        end;

      end;  {If (FilePos > 0)}

  try
    Printer.Refresh;
  except
  end;

end;  {SelectPrinterForPrintScreen}

{============================================================}
Procedure PrintScreen(Application : TApplication;
                      Form : TWinControl;
                      TopX, TopY,
                      BottomX, BottomY : LongInt);

var
  dc: HDC;
  isDcPalDevice : BOOL;
  MemDc :hdc;
  MemBitmap : hBitmap;
  OldMemBitmap : hBitmap;
  hDibHeader : Thandle;
  pDibHeader : pointer;
  hBits : Thandle;
  pBits : pointer;
  ScaleX : Double;
  ScaleY : Double;
  ppal : PLOGPALETTE;
  pal : hPalette;
  Oldpal : hPalette;
  i : Integer;

begin
  pPal := nil;
  SelectPrinterForPrintScreen;

    {FXX10032000-6(MDT): Force the printer to portrait mode.}

  Printer.Orientation := Printers.poPortrait;  {Definition in printers unit}

    {FXX08202003-1(2.07i): After doing a print to screen and then doing an F3 print screen,
                           it asked for the Output File Name.  A simple refresh cures that
                           problem.}

  Printer.Refresh;

 {Get the screen dc}
  dc := GetDc(0);
 {Create a compatible dc}
  MemDc := CreateCompatibleDc(dc);
 {create a bitmap}
  MemBitmap := CreateCompatibleBitmap(Dc,
                                      Form.width, Form.height);

 {select the bitmap into the dc}
  OldMemBitmap := SelectObject(MemDc, MemBitmap);

 {Lets prepare to try a fixup for broken video drivers}
  isDcPalDevice := false;
  if GetDeviceCaps(dc, RASTERCAPS) and
     RC_PALETTE = RC_PALETTE then begin
    GetMem(pPal, sizeof(TLOGPALETTE) +
      (255 * sizeof(TPALETTEENTRY)));
    FillChar(pPal^, sizeof(TLOGPALETTE) +
      (255 * sizeof(TPALETTEENTRY)), #0);
    pPal^.palVersion := $300;
    pPal^.palNumEntries :=
      GetSystemPaletteEntries(dc,
                              0,
                              256,
                              pPal^.palPalEntry);
    if pPal^.PalNumEntries <> 0 then begin
      pal := CreatePalette(pPal^);
      oldPal := SelectPalette(MemDc, Pal, false);
      isDcPalDevice := true
    end else
    FreeMem(pPal, sizeof(TLOGPALETTE) +
           (255 * sizeof(TPALETTEENTRY)));
  end;

  (*If _Compare(TopY, 0, coEqual)
  then TopY := 45; *)

 {copy from the screen to the memdc/bitmap}

  BitBlt(MemDc,
         0,0,
         Form.Width, Form.Height,
         Dc,
         Application.MainForm.Left,
         (Application.MainForm.top + 45),
         SrcCopy);


  if isDcPalDevice = true then begin
    SelectPalette(MemDc, OldPal, false);
    DeleteObject(Pal);
  end;

 {unselect the bitmap}
  SelectObject(MemDc, OldMemBitmap);
 {delete the memory dc}
  DeleteDc(MemDc);
 {Allocate memory for a DIB structure}
  hDibHeader := GlobalAlloc(GHND,
                            sizeof(TBITMAPINFO) +
                            (sizeof(TRGBQUAD) * 256));
 {get a pointer to the alloced memory}
  pDibHeader := GlobalLock(hDibHeader);

 {fill in the dib structure with info on the way we want the DIB}
  FillChar(pDibHeader^,
           sizeof(TBITMAPINFO) + (sizeof(TRGBQUAD) * 256),
           #0);
  PBITMAPINFOHEADER(pDibHeader)^.biSize :=
    sizeof(TBITMAPINFOHEADER);
  PBITMAPINFOHEADER(pDibHeader)^.biPlanes := 1;
  PBITMAPINFOHEADER(pDibHeader)^.biBitCount := 8;
  PBITMAPINFOHEADER(pDibHeader)^.biWidth := Form.width;
  PBITMAPINFOHEADER(pDibHeader)^.biHeight := Form.height;
  PBITMAPINFOHEADER(pDibHeader)^.biCompression := BI_RGB;

 {find out how much memory for the bits}
  GetDIBits(dc,
            MemBitmap,
            0,
            Form.height,
            nil,
            TBitmapInfo(pDibHeader^),
            DIB_RGB_COLORS);

 {Alloc memory for the bits}
  hBits := GlobalAlloc(GHND,
                       PBitmapInfoHeader(pDibHeader)^.BiSizeImage);
 {Get a pointer to the bits}
  pBits := GlobalLock(hBits);

 {Call fn again, but this time give us the bits!}
  GetDIBits(dc,
            MemBitmap,
            0,
            Form.height,
            pBits,
            PBitmapInfo(pDibHeader)^,
            DIB_RGB_COLORS);

 {Lets try a fixup for broken video drivers}
  if isDcPalDevice = true then begin
    for i := 0 to (pPal^.PalNumEntries - 1) do begin
      PBitmapInfo(pDibHeader)^.bmiColors[i].rgbRed :=
        pPal^.palPalEntry[i].peRed;
      PBitmapInfo(pDibHeader)^.bmiColors[i].rgbGreen :=
        pPal^.palPalEntry[i].peGreen;
      PBitmapInfo(pDibHeader)^.bmiColors[i].rgbBlue :=
        pPal^.palPalEntry[i].peBlue;
    end;
    FreeMem(pPal, sizeof(TLOGPALETTE) +
           (255 * sizeof(TPALETTEENTRY)));
  end;

 {Release the screen dc}
  ReleaseDc(0, dc);
 {Delete the bitmap}
  DeleteObject(MemBitmap);

 {Start print job}
  Printer.BeginDoc;

 {Scale print size}
  if Printer.PageWidth < Printer.PageHeight then begin
   ScaleX := Printer.PageWidth;
   ScaleY := Form.Height * (Printer.PageWidth / Form.Width);
  end else begin
   ScaleX := Form.Width * (Printer.PageHeight / Form.Height);
   ScaleY := Printer.PageHeight;
  end;


 {Just incase the printer drver is a palette device}
  isDcPalDevice := false;
  if GetDeviceCaps(Printer.Canvas.Handle, RASTERCAPS) and
      RC_PALETTE = RC_PALETTE then begin
   {Create palette from dib}
    GetMem(pPal, sizeof(TLOGPALETTE) +
          (255 * sizeof(TPALETTEENTRY)));
    FillChar(pPal^, sizeof(TLOGPALETTE) +
          (255 * sizeof(TPALETTEENTRY)), #0);
    pPal^.palVersion := $300;
    pPal^.palNumEntries := 256;
    for i := 0 to (pPal^.PalNumEntries - 1) do begin
      pPal^.palPalEntry[i].peRed :=
        PBitmapInfo(pDibHeader)^.bmiColors[i].rgbRed;
      pPal^.palPalEntry[i].peGreen :=
        PBitmapInfo(pDibHeader)^.bmiColors[i].rgbGreen;
      pPal^.palPalEntry[i].peBlue :=
        PBitmapInfo(pDibHeader)^.bmiColors[i].rgbBlue;
    end;
    pal := CreatePalette(pPal^);
    FreeMem(pPal, sizeof(TLOGPALETTE) +
            (255 * sizeof(TPALETTEENTRY)));
    oldPal := SelectPalette(Printer.Canvas.Handle, Pal, false);
    isDcPalDevice := true
  end;

 {send the bits to the printer}
  StretchDiBits(Printer.Canvas.Handle,
                0, 0,
                Round(scaleX), Round(scaleY),
                0, 0,
                Form.Width, Form.Height,
                pBits,
                PBitmapInfo(pDibHeader)^,
                DIB_RGB_COLORS,
                SRCCOPY);

 {Just incase you printer drver is a palette device}
  if isDcPalDevice = true then begin
    SelectPalette(Printer.Canvas.Handle, oldPal, false);
    DeleteObject(Pal);
  end;


 {Clean up allocated memory}
  GlobalUnlock(hBits);
  GlobalFree(hBits);
  GlobalUnlock(hDibHeader);
  GlobalFree(hDibHeader);

    {FXX07282001-1: Print the date on the print screen.}
    {CHG12132004-1(2.8.2.3): Move the printed on date a little lower to see
                             if this fixes Nanette's problem.}

  Printer.Canvas.TextOut(15, 3400, 'Printed on: ' + DateToStr(Date));

 {End the print job}
  Printer.EndDoc;

end;  {PrintScreen}

{==================================================================}
Procedure TFormPrint_PrintScreen(Application : TApplication;
                                 Form : TForm);

var
  PrintOptions : TPrintFormData;

begin
  SelectPrinterForPrintScreen;

    {FXX10032000-6(MDT): Force the printer to portrait mode.}

  Printer.Orientation := Printers.poPortrait;  {Definition in printers unit}

    {Prepare to set printing options}
  FillChar(PrintOptions, sizeof(PrintOptions), 0);
  PrintOptions.StrucSize := sizeof(PrintOptions);

 {Lets show a status dialog during the print job!}
  PrintOptions.UseAbortDialog := False;

 {Lets show messages if there are problems printing the form}
  PrnFormSetDebugMsg(TRUE);

 {Allow the user to force the use 24 bit printing for problem printers}
  PrintOptions.Use24BitOutputOnly := True;

 {Allow user to force the use of DDBs for problem printers or speed up the print job}
  PrnFormSetDebugUseDDB(True);

  {Set print job size reduction factor}
  PrnFormSetOutputScaleFactor(1, 1);

  {Set WinScale}
  PrnFormSetDoWinScale(FALSE);

 {Start the print job!}
  Printer.BeginDoc;
    {CHG12132004-1(2.8.2.3): Move the printed on date a little lower to see
                             if this fixes Nanette's problem.}

  Printer.Canvas.TextOut(15, 3400, 'Printed on: ' + DateToStr(Date));

 {Print the form!}
  if (NOT PrintFormEx(Form,
                      Printer.Canvas.Handle,
                      False, {Center the form on the page}
                      False, {Adjust for perfect margins}
                      @PrintOptions)) then begin
   {Abort the print job!}
    Printer.Abort;
    ShowMessage('User abort or other error!');
  end else begin
   {End the print job!}
    Printer.EndDoc;
  end;

end;  {TFormPrint_PrintScreen}

{==================================================================}
Procedure CopyTable(Table : TTable;
                    TableName : String;
                    Overwrite : Boolean);

{dBase files actually consist of 2 files -the dbf and the mdx.
 If we want to copy the dbf, it should copy the mdx, too.}

var
  Props: CURProps;
  SourceLen, DestLen : Integer;
  SourceNamePChar, DestNamePChar : PChar;

begin
  Check(DbiGetCursorProps(Table.Handle, Props));

  SourceLen := Length(Table.TableName);
  DestLen := Length(TableName);

  SourceNamePChar := StrAlloc(SourceLen + 1);
  DestNamePChar := StrAlloc(DestLen + 1);

  StrPCopy(SourceNamePChar, Table.TableName);
  StrPCopy(DestNamePChar, TableName);

  Check(DbiCopyTable(Table.DBHandle, Overwrite, SourceNamePChar,
                     Props.szTableType, DestNamePChar));

  StrDispose(SourceNamePChar);
  StrDispose(DestNamePChar);

end;  {CopyTable}

{============================================================}
Procedure UpdateFieldForTable(Table : TTable;
                              FieldName : String;
                              FieldValue : String);

var
  FirstTimeThrough, Done : Boolean;

begin
  FirstTimeThrough := True;
  Done := False;
  Table.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Table.Next;

    If Table.EOF
      then Done := True;

    If not Done
      then
        with Table do
          try
            Edit;
            FieldByName(FieldName).Text := FieldValue;
            Post;
          except
            Cancel;
            SystemSupport(825, Table, 'Error updating field ' + FieldName +
                          ' in table ' + Table.TableName + '.',
                          'WINUTILS.PAS', GlblErrorDlgBox);
          end;

  until Done;

end;  {UpdateFieldForTable}

{==================================================================}
Procedure SelectItemsInCheckListBox(CheckListBox : TCheckListBox);

var
  I : Integer;

begin
  with CheckListBox do
    If (Items.Count > 0)
      then
        For I := 0 to (Items.Count - 1) do
          Checked[I] := True;

end;  {SelectItemsInCheckListBox}

{==============================================================}
Procedure FillStringListFromFile(List : TStringList;
                                 Table : TTable;
                                 CodeField,
                                 DescriptionField : String;
                                 DescriptionLen : Integer;
                                 IncludeDescription : Boolean;
                                 ProcessingType : Integer;
                                 AssessmentYear : String);

var
  FirstTimeThrough, Done : Boolean;
  TempStr, OrigIndexName, OrigIndexFieldNames : String;
  IndexList : TStringList;
  I, Index : Integer;

begin
  IndexList := nil;
  Index := 0;
  FirstTimeThrough := True;
  Done := False;

  OrigIndexName := '';
  OrigIndexFieldNames := '';

    {FXX11241999-1: If this is history, set a range so that only codes from that
                    year are displayed.}

  If ((ProcessingType = History) and
      (Table.TableName[1] in ['N', 'T', 'H']))  {Year dependent}
    then
      begin
          {FXX12161999-2: History fixes - problem that index may not be on tax year index.}

        IndexList := TStringList.Create;
        Table.GetIndexNames(IndexList);

        For I := 0 to (IndexList.Count - 1) do
          If (Pos('TaxRollYr', IndexList[I]) > 0)
            then Index := I;

        If (Deblank(Table.IndexFieldNames) <> '')
          then OrigIndexFieldNames := Table.IndexFieldNames;

        If (Deblank(Table.IndexName) <> '')
          then OrigIndexName := Table.IndexName;

        Table.IndexName := IndexList[Index];

        Table.SetRange([AssessmentYear], [AssessmentYear]);

      end;  {If ((ProcessingType = History) and ...}

  Table.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Table.Next;

    If Table.EOF
      then Done := True;

    If not Done
      then
        begin
          TempStr := Table.FieldByName(CodeField).Text;

          If IncludeDescription
            then TempStr := TempStr + ' - ' +
                            Take(DescriptionLen, Table.FieldByName(DescriptionField).Text);

          List.Add(TempStr);

        end;  {If not Done}

  until Done;

    {Switch back to original index if history.}

  If ((ProcessingType = History) and
      (Table.TableName[1] in ['N', 'T', 'H']))  {Year dependent}
    then
      begin
        Table.CancelRange;

        If (Deblank(OrigIndexFieldNames) <> '')
          then Table.IndexFieldNames := OrigIndexFieldNames;

        If (Deblank(OrigIndexName) <> '')
          then Table.IndexName := OrigIndexName;

        IndexList.Free;

      end;  {If ((ProcessingType = History) and ...}

end;  {FillOneListBox}

{============================================================}
Procedure DisplaySelectedItemsInListBox(ListBox : TListBox;
                                        List : TStringList;
                                        StartingCharacters : String;
                                        SelectAll : Boolean);

var
  Len, I : Integer;

begin
  Len := Length(StartingCharacters);
  ListBox.Items.Clear;

  For I := 0 to (List.Count - 1) do
    If (Take(Len, StartingCharacters) = Take(Len, List[I]))
      then ListBox.Items.Add(List[I]);

  If SelectAll
    then SelectItemsInListBox(ListBox);

end;  {DisplaySelectedItemsInListBox}

{=========================================================}
Procedure SetDefaultPrinterSettings(PrintDialog : TPrintDialog;
                                    WideCarriage : Boolean);

(*var
  PrinterTable : TTable;
  Laser, Found : Boolean;
  TempStr : String; *)

begin
(*  Quit := False;
  PrinterTable := TTable.Create(nil);
  PrinterTable.DatabaseName := 'PASsystem';
  PrinterTable.TableType := ttDBase;
  PrinterTable.TableName := 'InstalledPrinterTbl';
  PrinterTable.Open;

  PrinterTable.IndexName := 'BYPRINTERNAME';
  FindNearestOld(PrinterTable, ['PrinterName'],
                 [Printer.Printers[Printer.PrinterIndex]]);

  TempStr := Printer.Printers[Printer.PrinterIndex];
  Laser := PrinterTable.FieldByName('Laser').AsBoolean;

  If (Laser and
      WideCarriage) *)


end;  {SetDefaultPrinterSettings}

{====================================================================}
Function InDateRange(TempDate : TDateTime;
                     PrintAllDates,
                     PrintToEndOfDates : Boolean;
                     StartingDate,
                     EndingDate : TDateTime) : Boolean;

begin
  Result := True;

  If not PrintAllDates
    then
      begin
        If (TempDate < StartingDate)
          then Result := False;

        If ((not PrintToEndOfDates) and
            (TempDate > EndingDate))
          then Result := False;

      end;  {If not PrintAllDates}

end;  {InDateRange}

(*{======================================================================}
Function ValueInRange(ValueToCompare : const;
                      PrintAllValues,
                      PrintToEndOfValues : Boolean;
                      StartingValue : const;
                      EndingValue : const) : Boolean;

const
  vrtString = 0;
  vrtFloat = 1;
  vrtInteger = 2;

var
  ValueTo_Compare, StartingValueStr, EndingValueStr : String;
  ValueToCompareFloat, StartingValueFloat, EndingValueFloat : Extended;
  ValueTo_Compare, StartingValueInt, EndingValueInt : LongInt;
  ValueRangeType : Integer;

begin
  Result := True;

  If PrintAllValues
    then Result := True
    else
      case ValueToCompare.VType of
        vtString     : begin
                         ValueRangeType := vrtString;
                         ValueTo_Compare := ValueToCompare.VString^;
                         StartingValueStr := StartingValue.VString^;
                         EndingValueStr := EndingValue.VString^;
                       end;

        vtAnsiString : begin
                         ValueRangeType := vrtString;
                         ValueTo_Compare := ValueToCompare.VANSIString^;
                         StartingValueStr := StartingValue.VANSIString^;
                         EndingValueStr := EndingValue.VANSIString^;
                       end;

        vtInteger    : begin
                         ValueRangeType := vrtInteger;
                         ValueTo_Compare := ValueToCompare.VInteger^;
                         StartingValueInt := StartingValue.VInteger^;
                         EndingValueInt := EndingValue.VInteger^;
                       end;

        vtInt64      : begin
                         ValueRangeType := vrtInteger;
                         ValueTo_Compare := ValueToCompare.VInt64^;
                         StartingValueInt := StartingValue.VInt64^;
                         EndingValueInt := EndingValue.VInt64^;
                       end;

        vtExtended   : begin
                         ValueRangeType := vrtFloat;
                         ValueToCompareFloat := ValueToCompare.VExtended^;
                         StartingValueFloat := StartingValue.VExtended^;
                         EndingValueFloat := EndingValue.VExtended^;
                       end;

        vtCurrency   : begin
                         ValueRangeType := vrtFloat;
                         ValueToCompareFloat := ValueToCompare.VCurrency^;
                         StartingValueFloat := StartingValue.VCurrency^;
                         EndingValueFloat := EndingValue.VCurrency^;
                       end;

      end;  {case ValueToCompare.VType of}

      case ValueRangeType of
        vrtString :
          begin
            If (ValueTo_Compare < StartingValueStr)
              then Result := False;

            If ((not PrintToEndOfValues) and
                (ValueTo_Compare > EndingValueStr))
              then Result := False;

          end;  {vrtString}

        vrtInteger :
          begin
            If (ValueTo_Compare < StartingValueInt)
              then Result := False;

            If ((not PrintToEndOfValues) and
                (ValueTo_Compare > EndingValueInt))
              then Result := False;

          end;  {vrtInteger}

      end;  {case ValueRangeType of}

end;  {ValueInRange} *)

{======================================================================}
Function GetRecordCount(Table : TTable) : LongInt;

{FXX07272001-1: The RecordCount property has a call to DbiGetExactRecordCount
                which slows things down.  We will call DbiExactRecordCount
                directly which is pretty much instant.}

begin
  try
    DbiGetRecordCount(Table.Handle, Result);
  except
    DbiGetExactRecordCount(Table.Handle, Result);
  end;

end;  {GetRecordCount}

{==================================================================}
Procedure FillSelectedItemList(ListBox : TListBox;
                               SelectedList : TStringList;
                               CharsToSelect : Integer);

var
  I : Integer;

begin
  SelectedList.Clear;
  
  with ListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then SelectedList.Add(Copy(Items[I], 1, CharsToSelect));

end;  {FillSelectedItemList}

{==================================================================}
Procedure FillSelectedItemsFromCheckListBox(clbxListBox : TCheckListBox;
                                            SelectedList : TStringList;
                                            CharsToSelect : Integer);

var
  I : Integer;

begin
  SelectedList.Clear;

  with clbxListBox do
    For I := 0 to (Items.Count - 1) do
      If Checked[I]
        then SelectedList.Add(Copy(Items[I], 1, CharsToSelect));

end;  {FillSelectedItemsFromCheckListBox}

{=====================================================================}
Procedure DisplayHintForListBox(ListBox : TListBox;
                                Table : TTable;
                                IndexField,
                                DescriptionField : String;
                                ListBoxCurrPosX,
                                ListBoxCurrPosY : Integer);

var
  Point, MousePoint : TPoint;
  Index : Integer;
  HintStr, TempItem : String;

begin
  Point.X := ListBoxCurrPosX;
  Point.Y := ListBoxCurrPosY;

  MousePoint := Mouse.CursorPos;

  with ListBox do
    begin
      Index := ItemAtPos(Point, True);

      If (Index = -1)
        then TempItem := ''
        else TempItem := Items[Index];

    end;  {with ListBox do}

  If (TempItem = '')
    then HintStr := ''
    else
      begin
        FindKeyOld(Table, [IndexField], [TempItem]);
        HintStr := Table.FieldByName(DescriptionField).Text;

      end;  {else of If (TempItem = '')}

  ListBox.Hint := HintStr;
  Application.Hint := HintStr;
  Application.ActivateHint(MousePoint);

end;  {DisplayHintForListBox}

{===================================================}
Function PackTable(    Table : TTable;
                   var ResultMsg : String) : Boolean;

var
  ActionResult : DBIResult;

begin
  ActionResult := dbiPackTable(Table.DBHandle, Table.Handle, nil, szDBASE, True);

  If (ActionResult = DBIERR_NONE)
    then
      begin
        Result := True;
        ResultMsg := 'Table ' + Table.TableName + ' packed successfully.';
      end
    else
      begin
        Result := False;
        ResultMsg := 'Table ' + Table.TableName + ' was not packed successfully: ';

        case ActionResult of
          DBIERR_INVALIDHNDL : ResultMsg := ResultMsg +
                                            'The table handle is not valid.  It probably does not point to a real table.';

          DBIERR_NEEDEXCLACCESS : ResultMsg := ResultMsg +
                                               'The table must be opened exclusive.  Please make sure not one else is using the table.';

          DBIERR_INVALIDPARAM : ResultMsg := ResultMsg +
                                            'The table name or pointer to the table name is NULL.';

          DBIERR_UNKNOWNTBLTYPE : ResultMsg := ResultMsg +
                                               'Unknown table type.';

          DBIERR_NOSUCHTABLE : ResultMsg := ResultMsg +
                                            'The table does not exist.';

        end;  {case ActionResult of}

      end;  {else of If (ActionResult = DBIERR_NONE)}

end;  {PackTable}

{===================================================}
Function ReindexTable(    Table : TTable;
                      var ResultMsg : String) : Boolean;

var
  ActionResult : DBIResult;

begin
  ActionResult := dbiRegenIndexes(Table.Handle);

  If (ActionResult = DBIERR_NONE)
    then
      begin
        Result := True;
        ResultMsg := 'Table ' + Table.TableName + ' was reindexed successfully.';
      end
    else
      begin
        Result := False;
        ResultMsg := 'Table ' + Table.TableName + ' was not reindexed successfully: ';

        case ActionResult of
          DBIERR_INVALIDHNDL : ResultMsg := ResultMsg +
                                            'The table handle is not valid.  It probably does not point to a real table.';

          DBIERR_NEEDEXCLACCESS : ResultMsg := ResultMsg +
                                               'The table must be opened exclusive.  Please make sure not one else is using the table.';

          DBIERR_NOTSUPPORTED : ResultMsg := ResultMsg +
                                             'Can not regenerate the indexes - they are not supported.';

        end;  {case ActionResult of}

      end;  {else of If (ActionResult = DBIERR_NONE)}

end;  {ReindexTable}

(*
{===========================================================================}
Procedure SendTextFileToExcelSpreadsheet(FileName : String);

var
  TempFile : TextFile;
  FloatDataType,
  EndOfLine, Done, Continue, FirstTimeThrough : Boolean;
  ExcelApplication: TExcelApplication;
  Wbk : _Workbook;
  ws : _Worksheet;
  I, lcID : Integer;  {Reference ID number for created Excel worksheet.}
  StringVariantArray, NumericVariantArray : OleVariant;
  TempStr : LineStringType;
  FieldValue : String;
  ColumnNumber, RowNumber,
  TotalNumberOfColumns, TotalNumberOfRows : LongInt;

begin
  Continue := True;
  RowNumber := 0;
  TotalNumberOfRows := 100;
  FirstTimeThrough := True;

  try
    AssignFile(TempFile, FileName);
    Reset(TempFile);
  except
    Continue := False;
    MessageDlg('Error opening file ' + FileName + '.' + #13 +
               'The file can not be brought into Excel.',
               mtError, [mbOK], 0);
  end;

  If Continue
    then
      try
        ExcelApplication := TExcelApplication.Create(nil);
        lcID := GetUserDefaultLCID;
        WBK := ExcelApplication.Workbooks.Add(EmptyParam, lcID);
        ws := WBK.Worksheets.Item['Sheet1'] as _Worksheet;

          {FXX05092002-1: Numeric fields were going into Excel as strings
                          and could not be converted.}

        StringVariantArray := VarArrayCreate([0, 0], varOleStr);
        NumericVariantArray := VarArrayCreate([0, 0], varDouble);

          {Now load the data into the worksheet.}

        Done := False;

        repeat
          ReadLine(TempFile, TempStr);

            {Set up a variant array for quicker insert of data
             into Excel.}

          If FirstTimeThrough
            then
              begin
                FirstTimeThrough := False;

                  {Count up the number of columns.}

                TotalNumberOfColumns := 0;
                EndOfLine := False;

                while not EndOfLine do
                  begin
                    ParseField(TempStr, (TotalNumberOfColumns + 1), EndOfLine);
                    TotalNumberOfColumns := TotalNumberOfColumns + 1;
                  end;

              end;  {If FirstTimeThrough}

          If EOF(TempFile)
            then Done := True;

          RowNumber := RowNumber + 1;

            {If we have too mant rows now, resize.}

{          If (RowNumber > TotalNumberOfRows)
            then
              begin
                TotalNumberOfRows := TotalNumberOfRows + 100;
                VarArrayRedim(VariantArray, TotalNumberOfRows);
              end;}

          For ColumnNumber := 1 to TotalNumberOfColumns do
            begin
              FieldValue := ParseField(TempStr, ColumnNumber, EndOfLine);

              FloatDataType := True;

              try
                StrToFloat(FieldValue);
              except
                FloatDataType := False;
              end;

                {FXX05212002-1: Force some numerics such as parcel ID to strings.}

              If (Pos('FORCESTRING', FieldValue) > 0)
                then
                  begin
                    Delete(FieldValue, 1, 11);
                    FloatDataType := False;
                  end;

              If FloatDataType
                then
                  begin
                    NumericVariantArray[0] := StrToFloat(FieldValue);
                    ws.Range[GetExcelCellName(ColumnNumber, RowNumber),
                             GetExcelCellName(ColumnNumber,
                                              RowNumber)].Value := NumericVariantArray;
                  end
                else
                  begin
                    StringVariantArray[0] := FieldValue;
                    ws.Range[GetExcelCellName(ColumnNumber, RowNumber),
                             GetExcelCellName(ColumnNumber,
                                              RowNumber)].Value := StringVariantArray;

                  end;  {If FloatDataType}

            end;  {For ColumnNumber := 1 to TotalNumberColumns do}

        until Done;

        ExcelApplication.Visible[lcID] := True;
        ws.Activate(lcID);

      finally
        ExcelApplication.Disconnect;
        ExcelApplication.Free;
      end;

end;  {SendTextFileToExcelSpreadsheet} *)

(*
{===========================================================================}
Procedure SendTextFileToExcelSpreadsheet(FileName : String);

var
  TempFile : TextFile;
  FloatDataType, EndOfLine,
  Done, Continue, FirstTimeThrough : Boolean;
  ExcelApplication: TExcelApplication;
  Wbk : _Workbook;
  ws : _Worksheet;
  I, lcID : Integer;  {Reference ID number for created Excel worksheet.}
  VariantArray : OleVariant;
  TempStr : LineStringType;
  FieldValue : String;
  ColumnNumber, RowNumber,
  TotalNumberOfColumns, TotalNumberOfRows : LongInt;

begin
  Continue := True;
  RowNumber := 0;
  TotalNumberOfRows := 100;
  FirstTimeThrough := True;

  try
    AssignFile(TempFile, FileName);
    Reset(TempFile);
  except
    Continue := False;
    MessageDlg('Error opening file ' + FileName + '.' + #13 +
               'The file can not be brought into Excel.',
               mtError, [mbOK], 0);
  end;

  If Continue
    then
      try
        ExcelApplication := TExcelApplication.Create(nil);
        lcID := GetUserDefaultLCID;
        WBK := ExcelApplication.Workbooks.Add(EmptyParam, lcID);
        ws := WBK.Worksheets.Item['Sheet1'] as _Worksheet;

          {Now load the data into the worksheet.}

        Done := False;

        repeat
          ReadLine(TempFile, TempStr);

            {Set up a variant array for quicker insert of data
             into Excel.}

          If FirstTimeThrough
            then
              begin
                FirstTimeThrough := False;

                  {Count up the number of columns.}

                TotalNumberOfColumns := 0;
                EndOfLine := False;

                while not EndOfLine do
                  begin
                    ParseField(TempStr, (TotalNumberOfColumns + 1), EndOfLine);
                    TotalNumberOfColumns := TotalNumberOfColumns + 1;
                  end;

                  {Create the array with 100 rows and dimension as need.}

                VariantArray := VarArrayCreate([0, (TotalNumberOfColumns - 1)],
                                               varOleStr);

              end;  {If FirstTimeThrough}

          If EOF(TempFile)
            then Done := True;

          RowNumber := RowNumber + 1;

            {If we have too mant rows now, resize.}

{          If (RowNumber > TotalNumberOfRows)
            then
              begin
                TotalNumberOfRows := TotalNumberOfRows + 100;
                VarArrayRedim(VariantArray, TotalNumberOfRows);
              end; }

          For ColumnNumber := 1 to TotalNumberOfColumns do
            begin
              FieldValue := ParseField(TempStr, ColumnNumber, EndOfLine);

              FieldValue := ParseField(TempStr, ColumnNumber, EndOfLine);

              FloatDataType := True;

              try
                StrToFloat(FieldValue);
              except
                FloatDataType := False;
              end;

                {FXX05212002-1: Force some numerics such as parcel ID to strings.}

              If (Pos('FORCESTRING', FieldValue) > 0)
                then
                  begin
                    Delete(FieldValue, 1, 11);
                    FloatDataType := False;
                  end;

              If FloatDataType
                then FieldValue := '=' + FieldValue;

              VariantArray[ColumnNumber - 1] := FieldValue;

            end;  {For ColumnNumber := 1 to TotalNumberColumns do}

          ws.Range[GetExcelCellName(1, RowNumber),
                   GetExcelCellName(TotalNumberOfColumns,
                                    RowNumber)].Value := VariantArray;

        until Done;

        ExcelApplication.Visible[lcID] := True;
        ws.Activate(lcID);

      finally
        ExcelApplication.Disconnect;
        ExcelApplication.Free;
      end;

end;  {SendTextFileToExcelSpreadsheet} *)

{===========================================================================}
Procedure SendTextFileToExcelSpreadsheet(FileName : String;
                                         MakeVisible : Boolean;
                                         AutomaticallySaveFile : Boolean;
                                         AutomaticSaveFileName : String);

var
  TempFile : TextFile;
  Continue : Boolean;
  ExcelApplication: TExcelApplication;
  Wbk : _Workbook;
  lcID : Integer;  {Reference ID number for created Excel worksheet.}
  TempFileName : OLEVariant;

begin
  Continue := True;
  TempFileName := FileName;
  ExcelApplication := nil;

  try
    AssignFile(TempFile, FileName);
    Reset(TempFile);
  except
    Continue := False;
    MessageDlg('Error opening file ' + FileName + '.' + #13 +
               'The file can not be brought into Excel.',
               mtError, [mbOK], 0);
  end;

  If Continue
    then
      try
        CloseFile(TempFile);
        ExcelApplication := TExcelApplication.Create(nil);
        lcID := GetUserDefaultLCID;
        Wbk := ExcelApplication.Workbooks.Open(TempFileName,
                                               0,  {Don't update links}
                                               False,  {Not read only}
                                               2,  {Comma delimited}
                                               EmptyParam,  {Password}
                                               EmptyParam, {Write pswd}
                                               True,  {Ignore read only msgs}
                                               EmptyParam, {Origin}
                                               EmptyParam, {Delimiter}
                                               EmptyParam, {Editable}
                                               EmptyParam, {Notify}
                                               EmptyParam, {Converter}
                                               True, {AddToMru}
                                               lcID);

        If MakeVisible
          then
            begin
              Wbk.Activate(lcID);
              ExcelApplication.Visible[lcID] := True;
            end;

        If AutomaticallySaveFile
          then
            begin
              TempFileName := AutomaticSaveFileName;
              Wbk.SaveAs(TempFileName, xlWorkbookNormal,
                         EmptyParam, EmptyParam,
                         EmptyParam, EmptyParam,
                         xlNoChange, EmptyParam, EmptyParam,
                         EmptyParam, EmptyParam, lcid);

              If not MakeVisible
                then Wbk.Close(False, EmptyParam, EmptyParam, lcID);

            end;  {If AutomaticallySaveFile}

      finally
        ExcelApplication.Disconnect;
        ExcelApplication.Free;
      end;

end;  {SendTextFileToExcelSpreadsheet}

{==================================================}
Function MapObjectsInstalled : Boolean;

var
  RegistryKeys : TStringList;
  TempKey : String;
  Skip : Boolean;
  I : Integer;
  MyRegistry : TRegistry;

begin
  RegistryKeys := TStringList.Create;
  Result := False;
  Skip := False;
  MyRegistry := TRegistry.Create;
  MyRegistry.RootKey := HKey_Local_Machine;

  try
    MyRegistry.OpenKey('SOFTWARE', False);
    MyRegistry.GetKeyNames(RegistryKeys);
    MyRegistry.CloseKey;
  except
    Skip := True;
  end;

  If not Skip
    then
      For I := 0 To (RegistryKeys.Count - 1) do
        begin
          TempKey := ANSIUpperCase(RegistryKeys[I]);

          If (Pos('ESRI', TempKey) > 0)
            then Result := True;

        end;  {If not Skip}

    {CHG06252004-1(2.07l5): Due to a strange registry problem, also check in the
                            Current_User key.}

  If not Result
    then
      begin
        MyRegistry.RootKey := HKey_Current_User;

        try
          MyRegistry.OpenKey('SOFTWARE', False);
          MyRegistry.GetKeyNames(RegistryKeys);
          MyRegistry.CloseKey;
        except
          Skip := True;
        end;

        If not Skip
          then
            For I := 0 To (RegistryKeys.Count - 1) do
              begin
                TempKey := ANSIUpperCase(RegistryKeys[I]);

                If (Pos('ESRI', TempKey) > 0)
                  then Result := True;

              end;  {If not Skip}

      end;  {If not Result}

  RegistryKeys.Free;
  MyRegistry.Free;

end;  {MapObjectsInstalled}

{==================================================}
Procedure PerformWordMailMerge(WordFileName : String;
                               ExcelFileName : String); overload;

var
  TempWordFileName, TempExcelFileName,
  OLEFalseBoolean, OLETrueBoolean, Connection : OLEVariant;
  WordApplication: TWordApplication;
  WordDocument: TWordDocument;

begin
  WordDocument := nil;
  WordApplication := nil;
  TempWordFileName := WordFileName;
  TempExcelFileName := ExcelFileName;

  try
    WordApplication := TWordApplication.Create(nil);
    WordDocument := TWordDocument.Create(nil);

    WordApplication.Connect;
    WordApplication.Visible := True;
    WordApplication.WindowState := wdWindowStateMaximize;

    WordDocument.ConnectTo(WordApplication.Documents.Open(TempWordFileName,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam));

    {$IFDEF Word2000Components}
    WordDocument.ConnectTo(WordApplication.Documents.Open(TempWordFileName,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam));
    {$ENDIF}

    {$IFDEF WordXPComponents}
    WordDocument.ConnectTo(WordApplication.Documents.Open(TempWordFileName,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam));
    {$ENDIF}

    WordDocument.MailMerge.MainDocumentType := 0;
    OLEFalseBoolean := False;
    OLETrueBoolean := True;
    Connection := 'Entire Spreadsheet';

    {$IFDEF WordXPComponents}
    WordDocument.MailMerge.OpenDataSource(ExcelFileName, EmptyParam,
                                          OLEFalseBoolean, EmptyParam,
                                          OLETrueBoolean, EmptyParam,
                                          EmptyParam, EmptyParam,
                                          EmptyParam, EmptyParam,
                                          EmptyParam,
                                          Connection,
                                          EmptyParam, EmptyParam, EmptyParam);
    {$ELSE}
    WordDocument.MailMerge.OpenDataSource(TempExcelFileName, EmptyParam,
                                          OLEFalseBoolean, EmptyParam,
                                          OLETrueBoolean, EmptyParam,
                                          EmptyParam, EmptyParam,
                                          EmptyParam, EmptyParam,
                                          EmptyParam,
                                          Connection,
                                          EmptyParam, EmptyParam);
    {$ENDIF}

    WordDocument.MailMerge.Destination := wdSendToNewDocument;
    WordDocument.MailMerge.Execute(OLETrueBoolean);
    WordDocument.Close;

  finally
    WordDocument.Free;
    WordApplication.Disconnect;
    WordApplication.Free;
  end;

end;  {PerformWordMailMerge}

{==================================================}
Procedure PerformWordMailMerge(WordFileName : String;
                               DatabaseName : String;
                               DSNName : String;
                               UserID : String;
                               Password : String;
                               TableName : String); overload;

var
  Pause, SQL,
  OLEWordFileName, OLEDatabaseName, OLEConnectionString : OLEVariant;
  ConnectionString : String;
  WordApplication: TWordApplication;
  WordDocument: TWordDocument;

begin
  Pause := False;
  OLEWordFileName := WordFileName;
  WordDocument := nil;
  WordApplication := nil;

  try
    WordApplication := TWordApplication.Create(nil);
    WordDocument := TWordDocument.Create(nil);

    WordApplication.Connect;
    WordApplication.Visible := True;
    WordApplication.WindowState := wdWindowStateMaximize;

    {$IFDEF Word2000Components}
    WordDocument.ConnectTo(WordApplication.Documents.Open(OLEWordFileName,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam));
    {$ENDIF}

    {$IFDEF Word97Components}
    WordDocument.ConnectTo(WordApplication.Documents.Open(OLEWordFileName,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam));
    {$ENDIF}

    {$IFDEF WordXPComponents}
    WordDocument.ConnectTo(WordApplication.Documents.Open(TempWordFileName,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam,
                                                          EmptyParam));
    {$ENDIF}

    with WordDocument.MailMerge do
      begin
        MainDocumentType := 0;
        ConnectionString := Format('DSN=%s;DBQ=%s;UID=%s;PWD=%s;', [DSNName, TableName, UserID, Password]);
        SQL := Format('SELECT * FROM %s', [TableName]);

        OLEDatabaseName := DatabaseName;
        OLEConnectionString := ConnectionString;

        {$IFDEF WordXPComponents}
        OpenDataSource(DatabaseName, EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam, OLEConnectionString,
                       SQL, EmptyParam);
        {$ELSE}
        OpenDataSource(OLEDatabaseName, EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam, EmptyParam,
                       EmptyParam, EmptyParam, EmptyParam, OLEConnectionString,
                       SQL, EmptyParam);
        {$ENDIF}


        Destination := wdSendToNewDocument;
        Datasource.FirstRecord := wdDefaultFirstRecord;
        Datasource.LastRecord := Integer(wdDefaultLastRecord);
        Execute(Pause);

      end;  {with WordDocument.MailMerge do}

    WordDocument.Close;

  finally
    WordDocument.Free;
    WordApplication.Disconnect;
    WordApplication.Free;
  end;

end;  {PerformWordMailMerge}

{========================================================================}
Procedure MoveToRecordNumber(Table : TTable;
                             RecordNumber : LongInt);

{Move to a particular record in a table based on the record number.}

var
  CurrentRecordNumber : LongInt;

begin
  Table.First;
  CurrentRecordNumber := 1;

  while ((not Table.EOF) and
         (CurrentRecordNumber < RecordNumber)) do
    begin
      CurrentRecordNumber := CurrentRecordNumber + 1;
      Table.Next;
    end;

end;  {MoveToRecordNumber}

(*
{========================================================================}
Procedure EMailFile(AttachmentFile : String;
                    AttachmentFileDescription : String;
                    SubjectLine : String);

const
  olMailItem = 0;
  olByValue  = 1;
var
  OutlookApp, MailItem, MyAttachments : OLEVariant;
begin
  try
    OutlookApp := GetActiveOleObject('Outlook.Application');
  except
    OutlookApp := CreateOleObject('Outlook.Application');
  end;

  try
    MailItem := OutlookApp.CreateItem(olMailItem);
    MailItem.Recipients.Add('<Unknown>');
    MailItem.Subject := SubjectLine;
    MailItem.Body := '';
    MailItem.Attachments.Add(AttachmentFile, olByValue, 1, AttachmentFileDescription);
  finally
    myAttachments := VarNull;
    OutlookApp := VarNull;
  end;

end;  {EMailFile} *)

{========================================================================}
Function MemoFieldIsRichTextMemoField(MemoField : TMemoField) : Boolean;

begin
  Result := (Pos('\fs', MemoField.AsString) > 0);
end;

{$H+}
{========================================================================}
Function StringContainsRichText(sTemp : String) : Boolean;

begin
  Result := _Compare(sTemp, '\fs', coContains);
end;
{$H-}

{========================================================================}
Function GetMemoLineCountForMemoField(Sender : TObject;
                                      MemoField : TMemoField;
                                      LeftMargin : Double;
                                      RightMargin : Double) : Integer;

var
  DBMemoBuf : TDBMemoBuf;

begin
  DBMemoBuf := TDBMemoBuf.Create;

  If MemoFieldIsRichTextMemoField(MemoField)
    then DBMemoBuf.RTFField := MemoField
    else DBMemoBuf.Field := MemoField;

  DBMemoBuf.PrintStart := LeftMargin;
  DBMemoBuf.PrintEnd := RightMargin;

  with Sender as TBaseReport do
    Result := MemoLines(DBMemoBuf);

  DBMemoBuf.Free;

end;  {GetMemoLineCountForMemoField}

{========================================================================}
Procedure PrintMemoField(Sender : TObject;
                         MemoField : TMemoField;
                         LeftMargin : Double;
                         RightMargin : Double;
                         CarriageReturn : Boolean);

{Print a memo field in the specified area.}

var
  DBMemoBuf : TDBMemoBuf;

begin
  with Sender as TBaseReport do
    begin
      DBMemoBuf := TDBMemoBuf.Create;

      If MemoFieldIsRichTextMemoField(MemoField)
        then DBMemoBuf.RTFField := MemoField
        else DBMemoBuf.Field := MemoField;

      DBMemoBuf.PrintStart := LeftMargin;
      DBMemoBuf.PrintEnd := RightMargin;

      PrintMemo(DBMemoBuf, 0, False);
      DBMemoBuf.Free;

      If CarriageReturn
        then Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintMemoField}

{$H+}
{====================================================================}
Procedure EMailFile(Form : TForm;
                    SourceDirectory : String;
                    ZipDirectory : String;
                    ZipFileName : String;
                    sDestinationEmail : String;
                    sCCEmail : String;
                    sMailSubject : String;
                    sBody : String;
                    SelectedFiles : TStringList;
                    CompressFiles : Boolean);

var
  I : Integer;
(*  NmSpace: NameSpace;
  Folder: MAPIFolder;
  MI: MailItem;
  OutlookApplication : TOutlookApplication; *)
  CompressedFileProgressPanel : TPanel;
  CompressingLabel, CurrentCompressedFileLabel : TLabel;
  AbMeter1 : TAbMeter;
  Zipper : TAbZipper;
  Continue : Boolean;
  TempFileName : String;

begin
  Continue := True;
  AbMeter1 := nil;
  CompressingLabel := nil;
  CurrentCompressedFileLabel := nil;
  Zipper := nil;
  CompressedFileProgressPanel := nil;

(*  try
    OutlookApplication := TOutlookApplication.Create(nil);
  except
    Continue := False;
    MessageDlg('Error initializing email program.' + #13 +
               'Please attach the file to an email manually.',
               mtError, [mbOK], 0);
  end; *)

  If Continue
    then
      begin
        If CompressFiles
          then
            begin
              try
                CompressedFileProgressPanel := TPanel.Create(Form);
              except
              end;

              with CompressedFileProgressPanel do
                try
                  Top := 127;
                  Left := 149;
                  Height := 99;
                  Width := 322;
                  Visible := True;
                  BevelInner := bvRaised;
                  BevelOuter := bvLowered;
                  BevelWidth := 1;
                except
                end;

              try
                CompressingLabel := TLabel.Create(CompressedFileProgressPanel);
              except
              end;

              with CompressingLabel do
                try
                  Top := 23;
                  Left := 19;
                  Caption := 'Compressing:';
                  Font.Style := [fsBold];
                except
                end;

              try
                CurrentCompressedFileLabel := TLabel.Create(CompressedFileProgressPanel);
              except
              end;
              with CurrentCompressedFileLabel do
                try
                  Top := 23;
                  Left := 124;
                  Caption := 'CurrentCompressedFileLabel';
                  Font.Style := [fsBold];
                  Font.Color := clBlue;
                except
                end;

              try
                AbMeter1 := TAbMeter.Create(CompressedFileProgressPanel);
              except
              end;

              with AbMeter1 do
                try
                  Top := 50;
                  Left := 31;
                  Width := 260;
                except
                end;

              try
                Zipper := TAbZipper.Create(nil);
              except
              end;

              with Zipper do
                try
                  ArchiveProgressMeter := AbMeter1;
                  AutoSave := False;
                except
                end;

              CompressedFileProgressPanel.BringToFront;
              Application.ProcessMessages;

              Zipper.BaseDirectory := SourceDirectory;

              Zipper.FileName := ZipDirectory + ZipFileName;
              TempFileName := Zipper.FileName;

              For I := 0 to (SelectedFiles.Count - 1) do
                Zipper.AddFiles(SelectedFiles[I], SysUtils.faReadOnly);

              Zipper.Save;
              Zipper.CloseArchive;

            end
          else TempFileName := ZipDirectory + ZipFileName;

            {CHG03232004-4(2.08): Change the email sending process and add it to all needed places.}

          SendMail(sMailSubject, sBody, TempFileName, '', '', '', sDestinationEmail, sCCEMail, True);
(*        try
          OutlookApplication.Connect;
          NmSpace := OutlookApplication.GetNamespace('MAPI');
        except
          Continue := False;
          MessageDlg('Error initializing connection to email program.' + #13 +
                     'Please attach the file to an email manually.',
                     mtError, [mbOK], 0);
        end;

        If Continue
          then
            begin
              NmSpace.Logon('', '', False, False);
              Folder := NmSpace.GetDefaultFolder(olFolderInbox);
              Folder.Display;

              MI := OutlookApplication.CreateItem(olMailItem) as MailItem;
              MI.Subject := MailSubject;
              MI.Attachments.Add(TempFileName, EmptyParam, EmptyParam, EmptyParam);
              MI.Display(0);

            end;  {If Continue} *)

      (*


        try
          MailSubject := Trim(GlblMunicipalityName) + ' full file extract ' + DateToStr(Date);

          try
            ShellExecute(0, 'open',
                         PChar('mailto: ' +
                               '?subject=' + MailSubject +
                               ' &Attach="' + TempFileName + '"'),
                         nil, nil, SW_NORMAL);
          except
            MessageDlg('No Outlook98 or above EMail Program On System!',
                       mtError, [mbOk], 0);
          end;

        except
          MessageDlg('Error copying file ' + ZipFileName + ' to attach it to email.',
                     mtError, [mbOK], 0);
        end; *)

      (*        EmailFile(TempFileName, ZipFileName,
                  Trim(GlblMunicipalityName) + ' full file extract ' + DateToStr(Date));*)

(*        try
          OutlookApplication.Free;
        except
        end; *)

        If CompressFiles
          then
            begin
              CompressedFileProgressPanel.Visible := False;

              try
                CompressedFileProgressPanel.Free;
                CompressingLabel.Free;
                CurrentCompressedFileLabel.Free;
                AbMeter1.Free;
                Zipper.Free;
              except
              end;

            end;  {If CompressFiles}

      end;  {If Continue}

end;  {EMailFile}
{$H-}

{================================================================}
Function ParseLongDate(    LongDate : String;
                       var ParsedTime : TTime;
                       var GoodDate : Boolean) : TDateTime;

{Parse dates in the form NOV 28 15:28}

var
  TempMonth, TempDay : String;
  Month, Day, BlankPos : Integer;
  Year, TodaysMonth, TodaysDay : Word;

begin
  Result := 0;
  Day := 0;
  GoodDate := True;
  TempMonth := ANSIUpperCase(Copy(LongDate, 1, 3));
  Month := GetMonthNumberForShortMonthName(TempMonth);

  If (Month = 0)
    then GoodDate := False
    else
      begin
        Delete(LongDate, 1, 4);
        BlankPos := Pos(' ', LongDate);
        TempDay := Copy(LongDate, 1, (BlankPos - 1));
        Delete(LongDate, 1, BlankPos);

        try
          Day := StrToInt(TempDay);
        except
          GoodDate := False;
        end;

      end;  {If (Month = 0)}

  If GoodDate
    then
      begin
          {For now, use today's year for the file since I don't know how to get the
           year of the file date, just asume it is the current year.  However,
           this means the files have to be cleared out at the beginning of each year.}

        DecodeDate(Date, Year, TodaysMonth, TodaysDay);

        try
          Result := EncodeDate(Year, Month, Day);
        except
          GoodDate := False;

        end;

      end;  {If GoodDate}

    {Now do the time.}

  If GoodDate
    then
      begin
        LongDate := Trim(LongDate);  {Now just time}

        try
          ParsedTime := StrToTime(LongDate);
        except
          GoodDate := False;
        end;

      end;  {If GoodDate}

end;  {ParseLongDate}

{========================================================================}
Function GetPaperSize(PaperSize : String) : Integer;

begin
  PaperSize := ANSIUpperCase(PaperSize);

  Result := DMPAPER_LETTER;

  If ((PaperSize = 'LETTER') or
      (Pos('ANSI A', PaperSize) > 0))
    then Result := DMPAPER_LETTER;

  If (PaperSize = 'LEGAL')
    then Result := DMPAPER_LEGAL;

  If ((Pos('11X17', PaperSize) > 0) or
      (Pos('11 X 17', PaperSize) > 0) or
      (Pos('11" x 17"', PaperSize) > 0) or
      (Pos('11"x17"', PaperSize) > 0) or
      (Pos('LEDGER', PaperSize) > 0) or
      (Pos('TABLOID', PaperSize) > 0) or
      ((Pos('11', PaperSize) > 0) and
       (Pos('17', PaperSize) > 0)))
    then Result := DMPAPER_11x17;

  If (Pos('ANSI C', PaperSize) > 0)
    then Result := DMPAPER_CSHEET;

  If (Pos('ANSI D', PaperSize) > 0)
    then Result := DMPAPER_DSHEET;

  If (Pos('ANSI E', PaperSize) > 0)
    then Result := DMPAPER_ESHEET;

  If (Pos('FANFOLD', PaperSize) > 0)
    then Result := DMPAPER_FANFOLD_US;

end;  {GetPaperSize}

{=====================================================================}
Procedure SetPrinterOverrides(    PrinterSettingsTable : TTable;
                                  ReportPrinter : TReportPrinter;
                                  ReportFiler : TReportFiler;
                                  PrintToScreenCheckBox : TCheckBox;
                              var PrintToScreen : Boolean;
                              var LinesAtBottom : Integer;
                              var NumLinesPerPage : Integer);

var
  PaperSize : Integer;

begin
  with PrinterSettingsTable do
    begin
      PrintToScreen := PrintToScreenCheckBox.Checked;
      GlblReportReprintLeftMargin := FieldByName('LeftMargin').AsFloat;
      GlblReportReprintSectionTop := FieldByName('SectionTop').AsFloat;
      PaperSize := GetPaperSize(FieldByName('PaperSize').Text);
      ReportPrinter.SetPaperSize(PaperSize, 0, 0);

      If (FieldByName('Orientation').AsInteger = 0)
        then ReportPrinter.Orientation := poPortrait
        else ReportPrinter.Orientation := poLandscape;

      ReportFiler.SetPaperSize(PaperSize, 0, 0);
      ReportFiler.Orientation := ReportPrinter.Orientation;

      LinesAtBottom := GlblLinesLeftOnRollLaserJet;
      NumLinesPerPage := 51;

      ReportPrinter.ScaleX := 100;
      ReportPrinter.ScaleY := 100;
      ReportFiler.ScaleX := 100;
      ReportFiler.ScaleY := 100;

      case PaperSize of
        DMPAPER_LETTER :
          If (ReportPrinter.Orientation = poLandscape)
            then
              begin
                  {Reduced}
                NumLinesPerPage := 66;
                ReportPrinter.ScaleX := 90;
                ReportPrinter.ScaleY := 70;
                ReportFiler.ScaleX := 90;
                ReportFiler.ScaleY := 70;
                LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
              end
            else
              begin
                  {Otherwise, regular}
                LinesAtBottom := GlblLinesLeftOnRollLaserJet;
                NumLinesPerPage := 51;

              end;  {DMPaper_Letter}

        DMPAPER_LEGAL :
          If (ReportPrinter.Orientation = poLandscape)
            then
              begin
                  {Reduced}
                NumLinesPerPage := 51;
                LinesAtBottom := GlblLinesLeftOnRollLaserJet;
              end
            else
              begin
                  {Otherwise, regular}
                LinesAtBottom := GlblLinesLeftOnRollLaserJet;
                NumLinesPerPage := 66;

              end;  {DMPaper_Letter}

        DMPAPER_FANFOLD_US,
        DMPAPER_TABLOID,
        DMPAPER_LEDGER,
        DMPAPER_11X17 :
          begin
            NumLinesPerPage := 66;
            LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
          end;

      end;  {case PaperSize of}

    end;  {with PrinterSettingsTable do}

end;  {SetPrinterOverrides}

{=============================================================================}
Procedure PromptForLetterSizePaper(    ReportPrinter : TReportPrinter;
                                       ReportFiler : TReportFiler;
                                   var NumLinesPerPage : Integer;
                                   var LinesAtBottom : Integer;
                                   var ReducedSize : Boolean;
                                   var DuplexType : TDuplex);

begin
  ReducedSize := False;
  If (ReportPrinter.Orientation = poLandscape)
    then
      begin
        If (MessageDlg('Do you want to print on letter size paper?',
                       mtConfirmation, [mbYes, mbNo], 0) = idYes)
          then
            begin
              ReducedSize := True;
              ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
              ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
              ReportPrinter.Orientation := poLandscape;
              ReportFiler.Orientation := poLandscape;

              If (ReportPrinter.SupportDuplex and
                  (MessageDlg('Do you want to print on both sides of the paper?',
                              mtConfirmation, [mbYes, mbNo], 0) = idYes))
                then
                  If (MessageDlg('Do you want to vertically duplex this report?',
                                  mtConfirmation, [mbYes, mbNo], 0) = idYes)
                    then
                      begin
                        ReportPrinter.Duplex := dupVertical;
                        DuplexType := dupVertical;
                      end
                    else
                      begin
                        ReportPrinter.Duplex := dupHorizontal;
                        DuplexType := dupHorizontal;
                      end;

              NumLinesPerPage := 66;
              ReportPrinter.ScaleX := 90;
              ReportPrinter.ScaleY := 70;
              ReportFiler.ScaleX := 90;
              ReportFiler.ScaleY := 70;
              LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
            end
          else
            begin
              LinesAtBottom := GlblLinesLeftOnRollLaserJet;
              NumLinesPerPage := 51;
            end;

      end
    else
      begin
        LinesAtBottom := GlblLinesLeftOnRollDotMatrix;
        NumLinesPerPage := 66;

      end;  {else of If (ReportPrinter.Orientation = poLandscape)}

end;  {PromptForLetterSizePaper}

{$H+}
{================================================}
Function SendMail(sSubject,
                  sBody,
                  sFileName,
                  sSenderName,
                  sSenderEMail,
                  sRecepientName,
                  sRecepientEMail,
                  sCCEMail : String;
                  bDisplayError : Boolean) : Integer;

var
  mapiMessage: TMapiMessage;
//  lpSender, lpRecepient: TMapiRecipDesc;
  FileAttach: TMapiFileDesc;
  SM: TFNMapiSendMail;
  MAPIModule: HModule;
  lpSender: TMapiRecipDesc;
  PRecip, Recipients: PMapiRecipDesc;
  iRecipients : Integer;

begin
  FillChar(mapiMessage, SizeOf(mapiMessage), 0);

  iRecipients := 0;
  If _Compare(sRecepientEMail, coNotBlank)
    then Inc(iRecipients);
  If _Compare(sCCEMail, coNotBlank)
    then Inc(iRecipients);
  mapiMessage.nRecipCount := iRecipients;
  GetMem(Recipients, MapiMessage.nRecipCount * SizeOf(TMapiRecipDesc));

  with mapiMessage do
    begin
      If _Compare(sSubject, coNotBlank)
        then lpszSubject := PChar(sSubject);

      If _Compare(sBody, coNotBlank)
        then lpszNoteText := PChar(sBody);

      If _Compare(sSenderEmail, coNotBlank)
        then
          begin
            lpSender.ulRecipClass := MAPI_ORIG;

            If _Compare(sSenderName, coBlank)
              then lpSender.lpszName := PChar(sSenderEMail)
              else lpSender.lpszName := PChar(sSenderName);

            lpSender.lpszAddress := PChar('SMTP:' + sSenderEMail);
            lpSender.ulReserved := 0;
            lpSender.ulEIDSize := 0;
            lpSender.lpEntryID := nil;
            lpOriginator := @lpSender;

          end;  {If _Compare(sSenderEmail, coNotBlank)}

      PRecip := Recipients;

      If _Compare(sRecepientEmail, coNotBlank)
        then
          with PRecip^ do
            begin
              ulRecipClass := MAPI_TO;
              lpszName := PChar(sRecepientEMail);
              lpszAddress := PChar('SMTP:' + sRecepientEMail);
              ulReserved := 0;
              ulEIDSize := 0;
              lpEntryID := nil;
              Inc(PRecip);

            end
        else lpRecips := nil;

      If _Compare(sCCEmail, coNotBlank)
        then
          with PRecip^ do
            begin
              ulRecipClass := MAPI_CC;
              lpszName := PChar(sCCEMail);
              lpszAddress := PChar('SMTP:' + sCCEMail);
              ulReserved := 0;
              ulEIDSize := 0;
              lpEntryID := nil;
              Inc(PRecip);

            end;  {with PRecip^ do}

      lpRecips := Recipients;

      If _Compare(sFileName, coBlank)
        then
          begin
            nFileCount := 0;
            lpFiles := nil;
          end
        else
          begin
            FillChar(FileAttach, SizeOf(FileAttach), 0);
            FileAttach.nPosition := Cardinal($FFFFFFFF);
            FileAttach.lpszPathName := PChar(sFileName);

            nFileCount := 1;
            lpFiles := @FileAttach;

          end;  {else of If (FileName = '')}

    end;  {with Message do}

  MAPIModule := LoadLibrary(PChar(MAPIDLL));

  If (MAPIModule = 0)
    then Result := -1
    else
      try
        @SM := GetProcAddress(MAPIModule, 'MAPISendMail');

        If (@SM <> nil)
          then Result := SM(0, 0, mapiMessage, MAPI_DIALOG or MAPI_LOGON_UI, 0)
          else Result := 1;

      finally
        FreeLibrary(MAPIModule);
        FreeMem(Recipients, MapiMessage.nRecipCount * sizeof(TMapiRecipDesc));
      end;

(*  If (bDisplayError and
      (Result <> 0))
    then MessageDlg('There was an error connecting to your e-mail program.' + #13 +
                    'Please attach the file to an e-mail manually.',
                    mtError, [mbOK], 0); *)

end;  {SendMail}
{$H-}

{=================================================================}
Function TableFieldsSame(Table1 : TTable;
                         Table2 : TTable;
                         FieldName : String) : Boolean;

var
  Field1, Field2 : String;

begin
  Field1 := Trim(Table1.FieldByName(FieldName).Text);
  Field2 := Trim(Table2.FieldByName(FieldName).Text);

  Result := (ANSIUpperCase(Field1) = ANSIUpperCase(Field2));

end;  {TableFieldsDifferent}

{=================================================================}
Function TableIntegerFieldsDifference(Table1 : TTable;
                                      Table2 : TTable;
                                      FieldName : String;
                                      AbsoluteValue : Boolean) : Integer;

var
  Value1, Value2 : LongInt;

begin
  try
    Value1 := Table1.FieldByName(FieldName).AsInteger;
  except
    Value1 := 0;
  end;

  try
    Value2 := Table2.FieldByName(FieldName).AsInteger;
  except
    Value2 := 0;
  end;

  Result := Value1 - Value2;

  If AbsoluteValue
    then Result := Abs(Result);

end;  {TableIntegerFieldsDifference}

{=================================================================}
Function TableFloatFieldsDifference(Table1 : TTable;
                                    Table2 : TTable;
                                    FieldName : String;
                                    AbsoluteValue : Boolean) : Double;

var
  Value1, Value2 : Double;

begin
  try
    Value1 := Table1.FieldByName(FieldName).AsFloat;
  except
    Value1 := 0;
  end;

  try
    Value2 := Table2.FieldByName(FieldName).AsFloat;
  except
    Value2 := 0;
  end;

  Result := Value1 - Value2;

  If AbsoluteValue
    then Result := Abs(Result);

end;  {TableFloatFieldsDifference}

{===========================================================================}
Function SumTableColumn(Table : TTable;
                        FieldName : String) : Double;

var
  Done, FirstTimeThrough : Boolean;

begin
  Done := False;
  FirstTimeThrough := True;
  Result := 0;
  Table.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else Table.Next;

    If Table.EOF
      then Done := True;

    If not Done
      then
        try
          Result := Result + Table.FieldByName(FieldName).AsFloat;
        except
        end;

  until Done;

end;  {SumTableColumn}

{====================================================================}
Procedure ResizeGridFontForWidthChange(Grid : TwwDBGrid;
                                       OriginalGridWidth : Integer);

{CHG09102004-1(2.8.0.11): Resize the grid font for a change.}

var
  PercentChange : Double;
  CurrentFontSize, NewFontSize, FontSizeChange : Integer;

begin
  with Grid do
    begin
      CurrentFontSize := Font.Size;
      PercentChange := (Width - OriginalGridWidth) / OriginalGridWidth;

      FontSizeChange := Abs(Trunc(CurrentFontSize * PercentChange));

      If (PercentChange > 0)
        then NewFontSize := Min((CurrentFontSize + FontSizeChange), 14)
        else NewFontSize := Max((CurrentFontSize - FontSizeChange), 9);

      Font.Size := NewFontSize;

    end;  {with ExemptionGrid do}

end;  {ResizeGridFontForWidthChange}

{====================================================================}
Procedure ResizeStringGridFontForWidthChange(    Grid : TStringGrid;
                                                 OriginalGridWidth : Integer;
                                             var ColumnSizeFactor : Double);

{CHG09102004-1(2.8.0.11): Resize the grid font for a change.}

var
  I : Integer;
  PercentChange : Double;
  CurrentFontSize, NewFontSize, FontSizeChange : Integer;

begin
  with Grid do
    begin
      CurrentFontSize := Font.Size;
      PercentChange := (Width - OriginalGridWidth) / OriginalGridWidth;

      FontSizeChange := Abs(Trunc(CurrentFontSize * PercentChange));

      If (PercentChange > 0)
        then NewFontSize := Min((CurrentFontSize + FontSizeChange), 14)
        else NewFontSize := Max((CurrentFontSize - FontSizeChange), 9);

      Font.Size := NewFontSize;

        {Now resize the columns.}

      ColumnSizeFactor := 1 + PercentChange;

      For I := 0 to (ColCount - 1) do
        ColWidths[I] := Trunc(ColWidths[I] * ColumnSizeFactor);

    end;  {with ExemptionGrid do}

end;  {ResizeStringGridFontForWidthChange}

{===================================================================}
Function MeetsDateCriteria(Date : TDateTime;
                           StartDate : TDateTime;
                           EndDate : TDateTime;
                           PrintAllDates : Boolean;
                           PrintToEndOfDates : Boolean) : Boolean;

begin
  Result := False;

  If PrintAllDates
    then Result := True
    else
      try
        If ((Date >= StartDate) and
            (PrintToEndOfDates or
             (Date <= EndDate)))
          then Result := True;

      except
      end;

end;  {MeetsDateCriteria}

{===========================================================================}
Function IsNumericDataType(DataType : TFieldType) : Boolean;

begin
  Result := (DataType in [ftSmallInt, ftInteger, ftWord, ftFloat, ftCurrency, ftBCD]);
end;  {IsNumericDataType}

{=============================================================================}
Procedure SetTabStopsForDBEdits(Form : TForm);

{CHG12022004-1(2.8.1.1): Make sure that only active fields are tab stops.}
{FXX12172004-1(2.8.1.4)[2028]: If it is not ReadOnly, TabStop should be set to the
                               negative of the data field ReadOnly.}

var
  I : Integer;

begin
  with Form do
    For I := 0 to (ComponentCount - 1) do
      If (Components[I] is TDBEdit)
        then
          with Components[I] as TDBEdit do
            If ReadOnly
              then TabStop := False
              else TabStop := not DataSource.DataSet.FieldByName(DataField).ReadOnly;

end;  {SetTabStopsForDBEdits}

{=======================================================================================}
Function GetYearFromDate(_Date : TDateTime) : Integer;

var
  Year, Month, Day : Word;

begin
  DecodeDate(_Date, Year, Month, Day);
  Result := Year;

end;  {GetYearFromDate}

{=======================================================================================}
Procedure FillStringListFromTableField(StringList : TStringList;
                                       Table : TTable;
                                       FieldName : String);

var
  FirstTimeThrough, Done : Boolean;

begin
  StringList.Clear;
  Table.First;
  FirstTimeThrough := True;

  with Table do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If not Done
        then
          try
            StringList.Add(Table.FieldByName(FieldName).Text);
          except
          end;

    until Done;

end;  {FillStringListFromTableField}

{===========================================================================}
Procedure FillInListView(      ListView : TListView;
                               Dataset : TDataset;
                         const FieldNames : Array of const;
                               SelectLastItem : Boolean;
                               ReverseOrder : Boolean); overload;

{Fill in a TListView from a table using the values of the fields in the
 order they are passed in.
 Note that any select or filter needs to be done prior to calling this procedure.}

var
  I : Integer;
  Item : TListItem;
  Value, FieldName : String;
  Done, FirstTimeThrough : Boolean;

begin
  FirstTimeThrough := True;

  If ReverseOrder
    then Dataset.Last
    else Dataset.First;

  ListView.Enabled := False;
  ListView.Items.Clear;

  with Dataset do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else
          If ReverseOrder
            then Prior
            else Next;

      If ReverseOrder
        then Done := BOF
        else Done := EOF;

      If not Done
        then
          begin
            with ListView do
              Item := Items.Insert(Items.Count);

            For I := 0 to High(FieldNames) do
              try
                FieldName := VarRecToStr(FieldNames[I]);

                try
                  Value := Dataset.FieldByName(FieldName).AsString;
                except
                  Value := '';
                end;

                case Dataset.FieldByName(FieldName).DataType of
                  ftDate : If _Compare(Value, coNotBlank)
                             then
                               try
                                 Value := FormatDateTime(DateFormat, FieldByName(FieldName).AsDateTime);
                               except
                                 Value := '';
                               end;

                  ftDateTime : If _Compare(FieldName, 'Time', coContains)
                                 then
                                   try
                                     Value := FormatDateTime(TimeFormat, FieldByName(FieldName).AsDateTime);
                                   except
                                     Value := '';
                                   end;

                  ftBoolean : try
                                Value := BoolToChar_Blank_Y(Dataset.FieldByName(FieldName).AsBoolean);
                              except
                                Value := '';
                              end;

                end;  {case Dataset.FieldByName(FieldName).DataType of}

                If _Compare(I, 0, coEqual)
                  then Item.Caption := Value
                  else Item.SubItems.Add(Value);
              except
              end;

          end;  {If not Done}

    until Done;

  ListView.Enabled := True;

  with ListView do
    begin
      If SelectLastItem
        then
          try
            Selected := Items[SelCount - 1];
          except
          end;

      Refresh;

    end;  {with ListView do}

end;  {FillInListView}

{===========================================================================}
Procedure FillInListView(      ListView : TListView;
                               Dataset : TDataset;
                         const FieldNames : Array of const;
                         const DisplayFormats : Array of String;
                               SelectLastItem : Boolean;
                               ReverseOrder : Boolean); overload;

{Fill in a TListView from a table using the values of the fields in the
 order they are passed in.
 Note that any select or filter needs to be done prior to calling this procedure.}

var
  I : Integer;
  Item : TListItem;
  Value, FieldName : String;
  Done, FirstTimeThrough : Boolean;

begin
  FirstTimeThrough := True;

  If ReverseOrder
    then Dataset.Last
    else Dataset.First;

  ListView.Enabled := False;
  ListView.Items.Clear;

  with Dataset do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else
          If ReverseOrder
            then Prior
            else Next;

      If ReverseOrder
        then Done := BOF
        else Done := EOF;

      If not Done
        then
          begin
            with ListView do
              Item := Items.Insert(Items.Count);

            For I := 0 to High(FieldNames) do
              try
                FieldName := VarRecToStr(FieldNames[I]);

                try
                  Value := Dataset.FieldByName(FieldName).AsString;
                except
                  Value := '';
                end;

                case Dataset.FieldByName(FieldName).DataType of
                  ftDate : If _Compare(Value, coNotBlank)
                             then
                               try
                                 Value := FormatDateTime(DateFormat, FieldByName(FieldName).AsDateTime);
                               except
                                 Value := '';
                               end;

                  ftDateTime : If _Compare(FieldName, 'Time', coContains)
                                 then
                                   try
                                     Value := FormatDateTime(TimeFormat, FieldByName(FieldName).AsDateTime);
                                   except
                                     Value := '';
                                   end;

                  ftBoolean : try
                                Value := BoolToChar_Blank_Y(Dataset.FieldByName(FieldName).AsBoolean);
                              except
                                Value := '';
                              end;

                  ftFloat,
                  ftInteger : try
                                Value := FormatFloat(DisplayFormats[I], Dataset.FieldByName(FieldName).AsFloat);
                              except
                                Value := '';
                              end;

                end;  {case Dataset.FieldByName(FieldName).DataType of}

                If _Compare(I, 0, coEqual)
                  then Item.Caption := Value
                  else Item.SubItems.Add(Value);
              except
              end;

          end;  {If not Done}

    until Done;

  ListView.Enabled := True;

  with ListView do
    begin
      If SelectLastItem
        then
          try
            Selected := Items[SelCount - 1];
          except
          end;

      Refresh;

    end;  {with ListView do}

end;  {FillInListView}

{===========================================================================}
Procedure FillInListViewRow(      ListView : TListView;
                            const Values : Array of const;
                                  SelectLastItem : Boolean);

{Fill in a TListView from an array of values in the order they are passed in.}

var
  Item : TListItem;
  Value : String;
  I : Integer;

begin
  with ListView do
    Item := Items.Insert(Items.Count);

  For I := 0 to High(Values) do
    try
      Value := VarRecToStr(Values[I]);

      If _Compare(I, 0, coEqual)
        then Item.Caption := Value
        else Item.SubItems.Add(Value);
    except
    end;

  with ListView do
    begin
      If SelectLastItem
        then
          try
            Selected := Items[SelCount - 1];
          except
          end;

      Refresh;

    end;  {with ListView do}

end;  {FillInListViewRow}

{===========================================================================}
Procedure ChangeListViewRow(      ListView : TListView;
                            const Values : Array of const;
                                  Index : Integer);

{Fill in a TListView from an array of values in the order they are passed in.}

var
  Item : TListItem;
  Value : String;
  I : Integer;

begin
  Item := ListView.Items[Index];

  For I := 0 to High(Values) do
    try
      Value := VarRecToStr(Values[I]);

      If _Compare(I, 0, coEqual)
        then Item.Caption := Value
        else Item.SubItems.Add(Value);
    except
    end;

  ListView.Refresh;

end;  {FillInListViewRow}

{=======================================================================}
Function GetColumnValueForListItem(ListItem : TListItem;
                                   ColumnNumber : Integer) : String;

begin
  Result := '';

  If _Compare(ColumnNumber, 0, coEqual)
    then
      try
        Result := ListItem.Caption;
      except
      end
    else
      try
        Result := ListItem.SubItems[ColumnNumber - 1];
      except
      end;

end;  {GetColumnValueForListItem}

{=======================================================================}
Function GetColumnValueForItem(ListView : TListView;
                               ColumnNumber : Integer;
                               Index : Integer) : String;  {-1 for selected item}

var
  TempItem : TListItem;

begin
  Result := '';

  If _Compare(Index, -1, coEqual)
    then TempItem := ListView.Selected
    else
      try
        TempItem := ListView.Items[Index];
      except
        TempItem := nil;
      end;

  If (TempItem <> nil)
    then Result := GetColumnValueForListItem(TempItem, ColumnNumber);

end;  {GetColumnValueForItem}

{========================================================================}
Procedure GetColumnValuesForItem(ListView : TListView;
                                 ValuesList : TStringList;
                                 Index : Integer);  {-1 means selected}

var
  I : Integer;
  TempItem : TListItem;

begin
  ValuesList.Clear;

  If _Compare(Index, -1, coEqual)
    then TempItem := ListView.Selected
    else
      try
        TempItem := ListView.Items[Index];
      except
        TempItem := nil;
      end;

  with ListView do
    For I := 0 to (Columns.Count - 1) do
      If _Compare(I, 0, coEqual)
        then ValuesList.Add(TempItem.Caption)
        else ValuesList.Add(TempItem.SubItems[I - 1]);

end;  {GetColumnValuesForItem}

{========================================================================}
Procedure GetSelectedColumnValues(ListView : TListView;
                                  ColumnNumber : Integer;
                                  ValuesList : TStringList);

{Given a list view, return the values in a column for all selected rows.}

var
  SelectedItem : TListItem;

begin
  ValuesList.Clear;

  with ListView do
    begin
      SelectedItem := Selected;

      while (SelectedItem <> nil) do
        begin
          ValuesList.Add(GetColumnValueForListItem(SelectedItem, ColumnNumber));
          SelectedItem := GetNextItem(SelectedItem, sdAll, [isSelected]);

        end;  {while (SelectedItem <> nil) do}

    end;  {with ListView do}

end;  {GetSelectedColumnValues}

{========================================================================}
Procedure SelectListViewItem(ListView : TListView;
                             RowNumber : Integer);

begin
  with ListView do
    If _Compare(RowNumber, (Items.Count - 1), coLessThanOrEqual)
      then
        begin
          Selected := Items[RowNumber];
          Refresh;
        end;

end;  {SelectListViewItem}

{=========================================================================}
Procedure DeleteSelectedListViewRow(ListView : TListView);

var
  Index : Integer;
  SelectedItem : TListItem;
  ItemDeleted : Boolean;

begin
  Index := 0;
  ItemDeleted := False;
  SelectedItem := ListView.Selected;

  with ListView do
    while ((not ItemDeleted) and
           _Compare(Index, (Items.Count - 1), coLessThanOrEqual)) do
      begin
        If (Items[Index] = SelectedItem)
          then
            try
              ItemDeleted := True;
              Items.Delete(Index);
            except
            end;

        Inc(Index);

      end;  {while ((not Deleted) and ...}

end;  {DeleteSelectedListViewRow}

{=========================================================================}
Procedure ClearListView(ListView : TListView);

begin
  ListView.Items.Clear;
end;

{========================================================================}
Procedure WriteListViewToFile(ListView : TListView;
                              sFileName : String);

var
  I, J : LongInt;
  slValues : TStringList;
  flExtract : TextFile;

begin
  AssignFile(flExtract, sFileName);
  Rewrite(flExtract);

  slValues := TStringList.Create;

  For I := 0 to (ListView.Items.Count - 1) do
    begin
      GetColumnValuesForItem(ListView, slValues, I);

      For J := 0 to (slValues.Count - 1) do
        WriteCommaDelimitedLine(flExtract, [slValues[J]]);

      WritelnCommaDelimitedLine(flExtract, []);

    end;  {For I := 0 to (RowCount - 1) do}

  CloseFile(flExtract);
  slValues.Free;

end;  {WriteListViewToFile}

{=========================================================================}
Procedure SetComponentsToReadOnly(Form : TForm);

var
  I : Integer;

begin
  with Form do
    For I := 0 to (ComponentCount - 1) do
      begin
        If (Components[I] is TEdit)
          then TEdit(Components[I]).ReadOnly := True;

        If (Components[I] is TMaskEdit)
          then TMaskEdit(Components[I]).ReadOnly := True;

        If (Components[I] is TMemo)
          then TMemo(Components[I]).ReadOnly := True;

        If (Components[I] is TwwDBLookupCombo)
          then TwwDBLookupCombo(Components[I]).ReadOnly := True;

        If (Components[I] is TCheckBox)
          then TCheckBox(Components[I]).Enabled := True;

        If (Components[I] is TDateTimePicker)
          then TDateTimePicker(Components[I]).Enabled := True;

      end;  {with Form do}

end;  {SetComponentsToReadOnly}

{==========================================================================}
Function GetDataChangedStateForComponent(Sender : TObject) : Boolean;

begin
  Result := False;

  If ((Sender is TCheckBox) and
      TCheckBox(Sender).Enabled)
    then Result := True;

  If ((Sender is TDateTimePicker) and
      TDateTimePicker(Sender).Enabled)
    then Result := True;

  If (Sender is TEdit)
    then
      with Sender as TEdit do
        If (Enabled and
            (not ReadOnly))
          then Result := True;

  If (Sender is TMaskEdit)
    then
      with Sender as TMaskEdit do
        If (Enabled and
            (not ReadOnly))
          then Result := True;

  If (Sender is TMemo)
    then
      with Sender as TMemo do
        If (Enabled and
            (not ReadOnly))
          then Result := True;

  If (Sender is TwwDBLookupCombo)
    then
      with Sender as TwwDBLookupCombo do
        If (Enabled and
            (not ReadOnly))
          then Result := True;

end;  {GetDataChangedStateForComponent}

{==============================================================}
Function StringListToString(StringList : TStringList;
                            SeparationChar : String) : String;

var
  I : Integer;

begin
  Result := '';

  For I := 0 to (StringList.Count - 1) do
    If _Compare(I, 0, coEqual)
      then Result := StringList[I]
      else Result := Result + SeparationChar + StringList[I];

end;  {StringListToString}

{=================================================================================}
Procedure GetValuesFromStringGrid(StringGrid : TStringGrid;
                                  StringList : TStringList;
                                  UpperCase : Boolean);

var
  I, J : Integer;
  TempStr : String;

begin
  StringList.Clear;

  with StringGrid do
    For I := 0 to (ColCount - 1) do
      For J := 0 to (RowCount - 1) do
        If _Compare(Cells[I, J], coNotBlank)
          then
            begin
              TempStr := Trim(Cells[I, J]);

              If UpperCase
                then TempStr := ANSIUpperCase(Trim(Cells[I, J]));

              StringList.Add(TempStr);

            end;  {If _Compare(Cells[I, J], coNotBlank)}

end;  {GetValuesFromStringGrid}

{$H+}
{===============================================================================}
Function ConvertRichTextFieldToString(RichTextMemo : TDBRichEdit;
                                      PlainTextMemo : TMemo;
                                      _DataSource : TDataSource;
                                      _DataField : String) : String;

begin
  with RichTextMemo do
    begin
      DataField := '';
      DataSource := _DataSource;
      DataField := _DataField;
      SelectAll;

      PlainTextMemo.Text := SelText;

    end;  {with RichTextMemo do}

  Result := PlainTextMemo.Text;

end;  {ConvertRichTextFieldToString}


{===============================================================================}
Function ConvertRichTextStringToString(sRichText : String;
                                       frmTemp : TForm) : String;

var
  reMemo : TRichEdit;

begin
  reMemo := TRichEdit.Create(frmTemp);
  frmTemp.InsertControl(reMemo);

  with reMemo do
    try
      PlainText := True;
      Text := sRichText;
      Result := Text;
    finally;
      frmTemp.RemoveControl(reMemo);
      Free;
    end;

end;  {ConvertRichTextStringToString}

{$H-}

{================================================================================}
Procedure FillDistinctStringListFromTable(StringList : TStringList;
                                          Dataset : TDataset;
                                          _FieldName : String;
                                          NumberCharsToCompare : Integer;
                                          SortList : Boolean);

var
  TempStr : String;

begin
  StringList.Clear;

  with Dataset do
    begin
      First;

      while not EOF do
        begin
          TempStr := FieldByName(_FieldName).AsString;

          If _Compare(NumberCharsToCompare, 0, coGreaterThan)
            then TempStr := Copy(TempStr, 1, NumberCharsToCompare);

          If _Compare(StringList.IndexOf(TempStr), -1, coEqual)
            then StringList.Add(TempStr);

          Next;

        end;  {while not EOF do}
        
    end;  {with Dataset do}

  If SortList
    then StringList.Sort;

end;  {FillDistinctStringListFromTable}

{====================================================================}
Procedure AddOneTreeViewItem(      TreeView : TTreeView;
                                   MainLevelItem : String;
                             const ChildItems : Array of String);

var
  I : Integer;
  MainTreeNode : TTreeNode;

begin
  with TreeView.Items do
    begin
      MainTreeNode := Add(nil, MainLevelItem);

      For I := 0 to High(ChildItems) do
        AddChild(MainTreeNode, ChildItems[I]);

    end;  {with TreeView do}

end;  {AddOneTreeViewItem}

{==================================================================}
Procedure GetPrinterResolution(    Printer : TPrinter;
                               var iHorizontalResolution : Integer;
                               var iVerticalResolution : Integer);


begin
  iHorizontalResolution := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  iVerticalResolution := GetDeviceCaps(Printer.Handle, LOGPIXELSY);

end;  {GetPrinterResolution}

{==================================================================}
Procedure PrintImage(Image : TPMultiImage;
                     Handle : HWnd;
                     X : Integer;
                     Y : Integer;
                     PageWidth : Integer;
                     PageHeight : Integer;
                     StartPage : Integer;
                     EndPage : Integer;
                     ScaleToPage : Boolean);

var
  TiffImage : Boolean;
  I, Pages, iPrinterIndex,
  iHorizontalResolution, iVerticalResolution : Integer;
  fPrinters : TextFile;

begin
(*  ShowMessage('Width: ' + IntToStr(PageWidth) + '   Height: ' + IntToStr(PageHeight));
  ShowMessage('Printer Count = ' + IntToStr(Printer.Printers.Count)); *)

(*  AssignFile(fPrinters, 'c:\Printers_Before.txt');
  Rewrite(fPrinters);
  For I := 0 to (Printer.Printers.Count - 1) do
    Writeln(fPrinters, Printer.Printers[I]);
  CloseFile(fPrinters); *)

  SelectPrinterForPrintScreen;

  try
    Printer.Refresh;
  except
  end;

  LockWindowUpdate(Handle);
  Image.GetInfoAndType(Image.ImageName);
  GetPrinterResolution(Printer, iHorizontalResolution, iVerticalResolution);

  TiffImage := _Compare(Image.BFileType, ['TIF', 'TIFF'], coEqual);

  If TiffImage
    then ScaleToPage := False;

  If TiffImage
    then
      begin
//        ScaleToPage := False;
        Pages := Image.BTiffPages;
        EndPage := Min((Pages - 1), EndPage);
        Image.TiffPage := StartPage;
        Image.ImageName := Image.ImageName;

      end
    else
      begin
        StartPage := 1;
        EndPage := 1;

      end;  {If TiffImage}

    {CHG07172005-2(2.8.5.6): If the TIFF image is landscape such as a property card,
                             print it that way.}
    {FXX10172006-1(2.10.2.3): Extend conditional orientation setting to non-TIFF images.}

(*  iPrinterIndex := Printer.PrinterIndex;
  ShowMessage('3: ' + IntToStr(iPrinterIndex)); *)
  
  If _Compare(Image.Width, Image.Height, coGreaterThanOrEqual)
    then Printer.Orientation := Printers.poLandscape
    else Printer.Orientation := Printers.poPortrait;

(*  AssignFile(fPrinters, 'c:\Printers_After.txt');
  Rewrite(fPrinters);
  For I := 0 to (Printer.Printers.Count - 1) do
    Writeln(fPrinters, Printer.Printers[I]);
  CloseFile(fPrinters); *)

(*  try
    PageWidth := Printer.PageWidth;
    PageHeight := Printer.PageHeight;
  except
    PageWidth := 8.5;
    PageHeight := 11;
   end; *)

(*  try
    Printer.Refresh;
  except
  end; *)
(*  ShowMessage('Printer Count = ' + IntToStr(Printer.Printers.Count));

  iPrinterIndex := Printer.PrinterIndex;
  ShowMessage('5: ' + IntToStr(iPrinterIndex));
  ShowMessage('5: ' + Printer.Printers[Printer.PrinterIndex]); *)

  For I := StartPage to EndPage do
    begin
      iPrinterIndex := Printer.PrinterIndex;
(*      ShowMessage('6: ' + IntToStr(iPrinterIndex)); *)

      If ScaleToPage
        then Image.PrintMultiImage(X, Y, Trunc(PageWidth * 0.7), Trunc(PageHeight * 0.5))
        else Image.PrintMultiImage(X, Y, PageWidth, PageHeight);

(*      ShowMessage('7'); *)
      If TiffImage
        then
          begin
            Image.TiffPage := Image.TiffPage + 1;
            Image.ImageName := Image.ImageName;
          end;

    end;  {For I := StartPage to EndPage do}

  If TiffImage
    then
      begin
        Image.TiffPage := StartPage;
        Image.ImageName := Image.ImageName;
      end;

  LockWindowUpdate(0);

end;  {PrintImage}

{============================================================================}
Procedure PromptForLetterSize(ReportPrinter : TReportPrinter;
                              ReportFiler : TReportFiler;
                              ScaleX : Integer;
                              ScaleY : Integer;
                              SectionLeft : Double);

begin
  If (MessageDlg('Do you want to print on letter size paper?',
                 mtConfirmation, [mbYes, mbNo], 0) = idYes)
    then
      begin
        ReportPrinter.SetPaperSize(dmPaper_Letter, 0, 0);
        ReportFiler.SetPaperSize(dmPaper_Letter, 0, 0);
        ReportPrinter.Orientation := poLandscape;
        ReportFiler.Orientation := poLandscape;

        ReportPrinter.ScaleX := ScaleX;
        ReportPrinter.ScaleY := ScaleY;
        ReportPrinter.SectionLeft := SectionLeft;
        ReportFiler.ScaleX := ScaleX;
        ReportFiler.ScaleY := ScaleY;
        ReportFiler.SectionLeft := SectionLeft;

      end;  {If (MessageDlg('Do you want to...}

end;  {PromptForLetterSize}

{==============================================================}
Procedure CapitalizeAllFields(tbTable : TTable);

var
  I : Integer;

begin
  with tbTable do
    try
      Edit;

      For I := 0 to (Fields.Count - 1) do
        If (Fields[I].DataType = ftString)
          then FieldByName(Fields[I].FieldName).AsString := ANSIUpperCase(FieldByName(Fields[I].FieldName).AsString);

      Post;
    except
    end;

end;  {CapitalizeAllFields}

{=============================================================================}
Function DateDisplay(sDate : String) : String;

begin
  If _Compare(sDate, '1/1/1900', coEqual)
    then Result := ''
    else Result := sDate;

end;  {DateDisplay}

end.
