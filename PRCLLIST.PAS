unit Prcllist;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, Grids, Dialogs, Types, DBTables, DB, SysUtils,
  RPFiler, RPDefine, RPBase, RPCanvas, RPrinter, ComCtrls;

type
  TParcelListDialog = class(TForm)
    LoadButton: TBitBtn;
    ParcelStringGrid: TStringGrid;
    Label1: TLabel;
    SaveButton: TBitBtn;
    SortButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    DescriptionMemo: TMemo;
    NewButton: TBitBtn;
    AddButton: TBitBtn;
    DeleteButton: TBitBtn;
    NameLabel: TLabel;
    AddressLabel: TLabel;
    ParcelTable: TTable;
    SwisCodeTable: TTable;
    NumParcelsLabel: TLabel;
    PrintButton: TBitBtn;
    ImportButton: TBitBtn;
    ExportButton: TBitBtn;
    PrintDialog: TPrintDialog;
    ReportPrinter: TReportPrinter;
    ReportFiler: TReportFiler;
    SortingPanel: TPanel;
    Label2: TLabel;
    SortProgressBar: TProgressBar;
    SortByPanel: TPanel;
    SortByRadioGroup: TRadioGroup;
    SortByOKButton: TBitBtn;
    SortByCancelButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure SortButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure ParcelStringGridClick(Sender: TObject);
    procedure ParcelStringGridDblClick(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure ImportButtonClick(Sender: TObject);
    procedure ExportButtonClick(Sender: TObject);
    procedure SortByCancelButtonClick(Sender: TObject);
    procedure SortByOKButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ParcelStringGridMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ParcelStringGridMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }

    FileName : String;
    Dragging, Modified : Boolean;
    LastRow : Integer;
    DragStartRow : LongInt;
    PrintCheckedStatus : Boolean;

    Function AddOneParcel(SwisSBLKey : String) : Boolean;
    Procedure ClearParcelGrid(AskForSave : Boolean);
    Function GetParcelSwisSBLKey(Index : Integer) : String;
    Function GetParcelID(Index : Integer) : String;
    Function NumItems : Integer;
    Function GetParcel(ParcelTable : TTable;
                       Index : Integer) : Boolean;
    Function GetParcelWithAssessmentYear(ParcelTable : TTable;
                                         Index : Integer;
                                         AssessmentYear : String) : Boolean;
    Procedure SetCaption;
    Procedure CheckAndSaveModifiedList;
    Procedure SetNumParcelsLabel(NumParcels : Integer);
    Procedure CloseFiles;
    Function ParcelExistsInList(SwisSBLKey : String) : Boolean;
    Procedure SortList(SortType : Integer);
    Function GetCheckedStatus(Index : Integer) : Boolean;
    Procedure SwitchRows(Row1,
                         Row2 : LongInt);

  end;

const
  stByParcelID = 0;
  stByName = 1;
  stByLegalAddressStreet_Number = 2;
  stByLegalAddressNumber_Street = 3;

var
  ParcelListDialog: TParcelListDialog;

implementation

uses GlblVars, Utilitys, PASUtils, PASTypes, WINUtils, Glblcnst,
     Prclocat, ParclTab, Prog, Preview, DataModule, DataAccessUnit;

{$R *.DFM}

type
  SortRecord = record
    SwisSBLKey : String;
    ParcelID : String;
    Name : String;
    LegalAddressStreet : String;
    LegalAddressNumber : String;
    Checked : Boolean;
  end;

  SortPointer = ^SortRecord;


{============================================================}
Procedure TParcelListDialog.SetCaption;

{FXX10302001-1: Remove the path from the file name.}

begin
  Caption := 'Parcel List - (' + StripPath(Trim(FileName)) + ')';
end;

{============================================================}
Procedure TParcelListDialog.FormCreate(Sender: TObject);

begin
  ParcelStringGrid.Cells[1, 0] := 'Parcel ID';
  OpenDialog.InitialDir := GlblListDir;
  SaveDialog.InitialDir := GlblListDir;
  Top := 0;
  Left := 0;
  FileName := 'unnamed';
  SetCaption;
  Modified := False;
  Dragging := False;

end;  {FormCreate}

{============================================================}
Function FindLastItem(ParcelStringGrid : TStringGrid) : Integer;

var
  I : Integer;

begin
  Result := 0;

  with ParcelStringGrid do
    For I := 1 to (RowCount - 1) do
      If (Deblank(Cells[1, I]) <> '')
        then Result := Result + 1;

end;  {FindLastItem}

{============================================================}
Procedure TParcelListDialog.CheckAndSaveModifiedList;

var
  TempStr : String;

begin
  If ((Modified or
       (FileName = 'unnamed')) and
      (FindLastItem(ParcelStringGrid) > 0)) {Make sure there is info in the grid.}
    then
      begin
        If (FileName = 'unnamed')
          then TempStr := 'The current list has not been saved.'
          else TempStr := 'The current list has been changed.';

        If (MessageDlg(TempStr + #13 +
                       'Do you wish to save the list?', mtConfirmation,
                       [mbYes, mbNo], 0) = idYes)
          then SaveButtonClick(SaveButton);

      end;  {If (Modified or ...}

end;  {CheckAndSaveModifiedList}

{============================================================}
Procedure TParcelListDialog.SetNumParcelsLabel(NumParcels : Integer);

begin
  NumParcelsLabel.Caption := 'Num Parcels = ' + IntToStr(NumParcels);
end;  {SetNumParcelsLabel}

{============================================================}
Function TParcelListDialog.AddOneParcel(SwisSBLKey : String) : Boolean;

var
  LastItem : Integer;

begin
  Result := False;

  If not ParcelExistsInList(SwisSBLKey)
    then
      begin
        LastItem := FindLastItem(ParcelStringGrid);

        with ParcelStringGrid do
          begin
            If (LastItem = (RowCount - 1))
              then RowCount := RowCount + 1;

            Cells[0, (LastItem + 1)] := '';
            Cells[1, (LastItem + 1)] := ConvertSwisSBLToDashDot(SwisSBLKey);
            Cells[2, (LastItem + 1)] := SwisSBLKey;

          end;  {with ParcelStringGrid do}

        ParcelStringGrid.Row := LastItem + 1;
        SetNumParcelsLabel(LastItem + 1);
        Modified := True;
        Result := True;

      end;  {If not ParcelExistsInList(SwisSBLKey)}

end;  {AddOneParcel}

{============================================================}
Function GetTempKey(TempSortList : TList;
                    J : Integer;
                    SortType : Integer) : String;

begin
  with SortPointer(TempSortList[J])^ do
    case SortType of
      stByParcelID : Result := SwisSBLKey;
      stByName : Result := Take(25, Name);
      stByLegalAddressStreet_Number : Result := Take(25, LegalAddressStreet) +
                                                ShiftRightAddZeroes(Take(10, LegalAddressNumber));
      stByLegalAddressNumber_Street : Result := ShiftRightAddZeroes(Take(10, LegalAddressNumber)) +
                                                Take(25, LegalAddressStreet);
    end;  {case SortType of}

end;  {GetTempKey}

{============================================================}
Procedure SortTempList(TempSortList : TList;
                       SortType : Integer);

var
  I, J : LongInt;
  OldKey, NewKey : String;
  TempSortPtr : SortPointer;

begin
  For I := 0 to (TempSortList.Count - 1) do
    begin
      OldKey := GetTempKey(TempSortList, I, SortType);

      For J := (I + 1) to (TempSortList.Count - 1) do
        begin
          NewKey := GetTempKey(TempSortList, J, SortType);

          If (NewKey < OldKey)
            then
              begin
                TempSortPtr := TempSortList[I];
                TempSortList[I] := TempSortList[J];
                TempSortList[J] := TempSortPtr;
                OldKey := NewKey;

              end;  {If (NewKey < OldKey)}

        end;  {For J := (I + 1) to (TempSortList.Count - 1) do}

    end;  {For I := 0 to (TempSortList.Count - 1) do}

end;  {SortTempList}

{============================================================}
Procedure TParcelListDialog.SortList(SortType : Integer);

var
  TempSortList : TList;
  SortPtr : SortPointer;
  I, TotalItems : LongInt;

begin
  TempSortList := TList.Create;
  TotalItems := NumItems;
  SortingPanel.Visible := True;
  Refresh;
  SortProgressBar.Position := 0;
  SortProgressBar.Max := TotalItems;
  Application.ProcessMessages;

    {First create a TList with all the items.}

  For I := 1 to TotalItems do
    If GetParcel(ParcelTable, I)
      then
        begin
          New(SortPtr);

          with SortPtr^, ParcelTable do
            begin
              SwisSBLKey := GetParcelSwisSBLKey(I);
              ParcelID := GetParcelID(I);
              SortPtr^.Name := FieldByName('Name1').Text;
              LegalAddressStreet := FieldByName('LegalAddr').Text;
              LegalAddressNumber := ShiftRightAddZeroes(Take(10, FieldByName('LegalAddrNo').Text));
              Checked := GetCheckedStatus(I);

            end;  {with SortPtr^ do}

          SortProgressBar.Position := SortProgressBar.Position + 1;

          TempSortList.Add(SortPtr);

        end;  {If GetParcel(ParcelTable, I)}

  SortTempList(TempSortList, SortType);

    {Now clear the grid and refill it in the new order.}

  ClearParcelGrid(False);

  For I := 1 to TotalItems do
    with SortPointer(TempSortList[I - 1])^ do
      begin
        If Checked
          then ParcelStringGrid.Cells[0, I] := 'X'
          else ParcelStringGrid.Cells[0, I] := ' ';

        ParcelStringGrid.Cells[1, I] := ParcelID;
        ParcelStringGrid.Cells[2, I] := SwisSBLKey;

      end;  {with SortPointer(TempSortList[I])^ do}

  SortingPanel.Visible := False;

end;  {SortList}

{==============================================================}
Procedure TParcelListDialog.SortByCancelButtonClick(Sender: TObject);

begin
  SortByPanel.Hide;
end;

{==============================================================}
Procedure TParcelListDialog.SortByOKButtonClick(Sender: TObject);

begin
  SortByPanel.Hide;
  SortList(SortByRadioGroup.ItemIndex);
end;

{==============================================================}
Procedure TParcelListDialog.SortButtonClick(Sender: TObject);

{CHG11052001-1: Allow for sort of parcel list.}

begin
  SortByPanel.Show;
end;

{============================================================}
Procedure TParcelListDialog.ClearParcelGrid(AskForSave : Boolean);

var
  I, J : Integer;
  Quit : Boolean;

begin
  If AskForSave
    then CheckAndSaveModifiedList;

    {FXX07211999-5: Delete leaves 'X' in grid.}

  with ParcelStringGrid do
    For I := 0 to (ColCount - 1) do
      For J := 1 to (RowCount - 1) do
        Cells[I, J] := '';

  with DescriptionMemo do
    For I := 0 to 4 do
      Lines[I] := '';

  FileName := 'unnamed';
  SetCaption;
  Modified := False;
  LastRow := 1;
  SetNumParcelsLabel(0);

    {Let's always reopen the parcel table when we clear the grid to
     make sure it is set to the right processing type.}

  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             GlblProcessingType, Quit);

  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             GlblProcessingType, Quit);

end;  {ClearParcelGrid}

{==============================================================}
Procedure TParcelListDialog.LoadButtonClick(Sender: TObject);

var
  Done : Boolean;
  ListFile : TextFile;
  TempStr, ParcelID : String;
  I : Integer;

begin
  Done := False;
  OpenDialog.FilterIndex := 1;

  If OpenDialog.Execute
    then
      begin
        ClearParcelGrid(True);

        AssignFile(ListFile, OpenDialog.FileName);
        Reset(ListFile);

        For I := 0 to 4 do
          begin
            Readln(ListFile, TempStr);
            DescriptionMemo.Lines[I] := TempStr;
          end;

        repeat
          Readln(ListFile, ParcelID);
          ParcelID := Take(28, ParcelID);

          If EOF(ListFile)
            then Done := True;

          AddOneParcel(Take(26, ParcelID));

            {Now display if this was selected before.}

          ParcelStringGrid.Cells[0, (ParcelStringGrid.Row - 1)] := Copy(ParcelID, 28, 1);

        until Done;

        CloseFile(ListFile);

        FileName := OpenDialog.FileName;
        SetCaption;
        Modified := False;

      end;  {If OpenDialog.Execute}

end;  {LoadButtonClick}

{=================================================================}
Procedure TParcelListDialog.SaveButtonClick(Sender: TObject);

var
  I : Integer;
  ListFile : TextFile;

begin
  SaveDialog.FilterIndex := 1;

  If SaveDialog.Execute
    then
      begin
        AssignFile(ListFile, SaveDialog.FileName);
        Rewrite(ListFile);

          {Write the description.}

        with DescriptionMemo do
          For I := 0 to 4 do
            Writeln(ListFile, Lines[I]);

          {CHG05131999-2: Let people look up parcels from the parcel list.}
          {Also write if selected or not.}

        For I := 1 to (ParcelStringGrid.RowCount - 1) do
          If (Deblank(ParcelStringGrid.Cells[2, I]) <> '')
            then Writeln(ListFile, ParcelStringGrid.Cells[2, I], ' ',
                                   Take(1, ParcelStringGrid.Cells[0, I]));

        CloseFile(ListFile);

        FileName := SaveDialog.FileName;
        SetCaption;
        Modified := False;

          {FXX11021999-14: Preventative measure to make sure that the file saved.}

        If not FileExists(SaveDialog.FileName)
          then MessageDlg('The parcel list did not save correctly.' + #13 +
                          'Please try again.', mtError, [mbOK], 0);

      end;  {If SaveDialog.Execute}

end;  {SaveButtonClick}

{=================================================================}
Function TParcelListDialog.GetParcelSwisSBLKey(Index : Integer) : String;

begin
  Result := ParcelStringGrid.Cells[2, Index];
end;

{=================================================================}
Function TParcelListDialog.GetCheckedStatus(Index : Integer) : Boolean;

begin
  Result := (ParcelStringGrid.Cells[0, Index] = 'X');
end;

{=================================================================}
Function TParcelListDialog.NumItems : Integer;

begin
  Result := FindLastItem(ParcelStringGrid);
end;

{=================================================================}
Function TParcelListDialog.GetParcel(ParcelTable : TTable;
                                     Index : Integer) : Boolean;

var
  SBLRec : SBLRecord;

begin
  Result := False;

  SBLRec := ExtractSwisSBLFromSwisSBLKey(GetParcelSwisSBLKey(Index));

  If (Deblank(SBLRec.SwisCode) <> '')
    then
      with SBLRec do
         Result := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode',
                               'Section', 'Subsection',
                               'Block', 'Lot', 'Sublot', 'Suffix'],
                              [ParcelTable.FieldByName('TaxRollYr').Text,
                               SwisCode, Section, Subsection, Block,
                               Lot, Sublot, Suffix]);

end;  {GetParcel}

{=================================================================}
Function TParcelListDialog.GetParcelWithAssessmentYear(ParcelTable : TTable;
                                                       Index : Integer;
                                                       AssessmentYear : String) : Boolean;

var
  SBLRec : SBLRecord;

begin
  Result := False;
  SBLRec := ExtractSwisSBLFromSwisSBLKey(GetParcelSwisSBLKey(Index));

  If (Deblank(SBLRec.SwisCode) <> '')
    then
      with SBLRec do
         Result := FindKeyOld(ParcelTable,
                              ['TaxRollYr', 'SwisCode',
                               'Section', 'Subsection',
                               'Block', 'Lot', 'Sublot', 'Suffix'],
                              [AssessmentYear,
                               SwisCode, Section, Subsection, Block,
                               Lot, Sublot, Suffix]);

end;  {GetParcelWithAssessmentYear}

{=================================================================}
Function TParcelListDialog.GetParcelID(Index : Integer) : String;

begin
  Result := ParcelStringGrid.Cells[1, Index];
end;

{===========================================================}
Procedure TParcelListDialog.NewButtonClick(Sender: TObject);

begin
  ClearParcelGrid(True);
end;

{===================================================================}
Procedure TParcelListDialog.AddButtonClick(Sender: TObject);

var
  SwisSBLKey : String;

begin
  If ExecuteParcelLocateDialog(SwisSBLKey, True, False, 'Add to Parcel List', False, nil)
    then
      begin
        AddOneParcel(SwisSBLKey);
        ParcelStringGridClick(Sender);
      end;

end;  {AddButtonClick}

{====================================================================}
Procedure TParcelListDialog.DeleteButtonClick(Sender: TObject);

var
  TempRow, I : Integer;

begin
  TempRow := ParcelStringGrid.Row;

    {FXX07211999-5: Delete leaves 'X' in grid.}

  with ParcelStringGrid do
    begin
      For I := (TempRow + 1) to (RowCount - 1) do
        begin
          Cells[0, (I - 1)] := Cells[0, I];
          Cells[1, (I - 1)] := Cells[1, I];
          Cells[2, (I - 1)] := Cells[2, I];

        end;

          {Blank out the last row.}

      Cells[0, (RowCount - 1)] := '';
      Cells[1, (RowCount - 1)] := '';
      Cells[2, (RowCount - 1)] := '';

    end;  {with ParcelStringGrid do}

  SetNumParcelsLabel(FindLastItem(ParcelStringGrid));

  Modified := True;

end;  {DeleteButtonClick}

{========================================================================}
Procedure TParcelListDialog.ParcelStringGridClick(Sender: TObject);

var
  Found : Boolean;

begin
  Found := GetParcel(ParcelTable, ParcelStringGrid.Row);

  If Found
    then
      begin
        NameLabel.Caption := Take(15, ParcelTable.FieldByName('Name1').Text);
        AddressLabel.Caption := Take(15, GetLegalAddressFromTable(ParcelTable));
      end
    else
      begin
        NameLabel.Caption := '';
        AddressLabel.Caption := '';
      end;

end;  {ParcelStringGridClick}

{===========================================================}
Procedure TParcelListDialog.ParcelStringGridDblClick(Sender: TObject);

{CHG05131999-2: Let people look up parcels from the parcel list.}

var
  Found : Boolean;
  SwisSBLKey : String;

begin
  Found := GetParcel(ParcelTable, ParcelStringGrid.Row);
  SwisSBLKey := GetParcelSwisSBLKey(ParcelStringGrid.Row);

  If Found
    then
      begin
          {Display this parcel in the list.}

        ParcelStringGridClick(Sender);

          {Now see if parcel view or mod is active.}

        If (GlblParcelMaintenance <> nil)
          then
            begin
              ParcelStringGrid.Cells[0, ParcelStringGrid.Row] := 'X';
              GlblLocateParcelFromList := True;
              GlblParcelListSBLKey := SwisSBLKey;
              ParcelListDialog.SendToBack;

              TParcelTabForm(GlblParcelMaintenance).Show;
              TParcelTabForm(GlblParcelMaintenance).BringToFront;
              TParcelTabForm(GlblParcelMaintenance).LocateParcel1Click(TParcelTabForm(GlblParcelMaintenance).LocateParcel1);

            end;  {If ParcelViewOrModifyActive}

      end;  {If Found}

end;  {ParcelStringGridDblClick}

{===========================================================}
Function TParcelListDialog.ParcelExistsInList(SwisSBLKey : String) : Boolean;

var
  I : Integer;

begin
  Result := False;

  with ParcelStringGrid do
    For I := 0 to (RowCount - 1) do
      If ((Deblank(Cells[2, I]) <> '') and
          (Take(26, Cells[2, I]) = Take(26, SwisSBLKey)))
        then Result := True;

end;  {ParcelExistsInList}

{===========================================================}
Procedure TParcelListDialog.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) +
                  '  Time: ' + FormatDateTime(TimeFormat, Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Arial',14);
      Underline := True;
      Home;
      CRLF;
      PrintCenter('Parcel List ' + FileName, (PageWidth / 2));
      SetFont('Times New Roman', 12);
      CRLF;
      CRLF;

      Underline := False;
      ClearTabs;
      SetTab(0.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Parcel 1}
      SetTab(2.1, pjLeft, 0.1, 0, BOXLINENONE, 0);   {Checked off 1}
      SetTab(2.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Parcel 2}
      SetTab(4.1, pjLeft, 0.1, 0, BOXLINENONE, 0);   {Checked off 2}
      SetTab(4.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Parcel 3}
      SetTab(6.1, pjLeft, 0.1, 0, BOXLINENONE, 0);   {Checked off 3}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{===========================================================}
Procedure TParcelListDialog.ReportPrint(Sender: TObject);

var
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      For I := 1 to NumItems do
        begin
          Print(#9 + GetParcelID(I));

          If PrintCheckedStatus
            then Print(#9 + ParcelStringGrid.Cells[0, I])
            else Print(#9);

          If ((I MOD 3) = 0)
            then Println('');

          If (LinesLeft < 5)
            then NewPage;

          ProgressDialog.Update(Self, IntToStr(I));

        end;  {For I := 1 to NumItems do}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{===========================================================}
Procedure TParcelListDialog.PrintButtonClick(Sender: TObject);

{CHG03232001-3: Add the ability to print, export, and import from the
                parcel list.}

var
  NewFileName : String;
  Quit : Boolean;

begin
  If PrintDialog.Execute
    then
      begin
        PrintCheckedStatus := (MessageDlg('Do you want to print the checked status of each parcel?',
                                          mtConfirmation, [mbYes, mbNo], 0) = idYes);

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser], False, Quit);

        If not Quit
          then
            begin
              ProgressDialog.Start(NumItems, True, True);

                {If they want to preview the print (i.e. have it
                 go to the screen), then we need to come up with
                 a unique file name to tell the ReportFiler
                 component where to put the output.
                 Once we have done that, we will execute the
                 report filer which will print the report to
                 that file. Then we will create and show the
                 preview print form and give it the name of the
                 file. When we are done, we will delete the file
                 and make sure that we go back to the original
                 directory.}

              If PrintDialog.PrintToFile
                then
                  begin
                    NewFileName := GetPrintFileName(Self.Caption, True);
                    ReportFiler.FileName := NewFileName;

                    try
                      PreviewForm := TPreviewForm.Create(self);
                      PreviewForm.FilePrinter.FileName := NewFileName;
                      PreviewForm.FilePreview.FileName := NewFileName;

                      PreviewForm.FilePreview.ZoomFactor := 130;
                      ReportFiler.Execute;

                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;
                    end;  {If PrintRangeDlg.PreviewPrint}

                  end  {They did not select preview, so we will go
                        right to the printer.}
                else ReportPrinter.Execute;

              ProgressDialog.Finish;

            end;  {If not Quit}

        ResetPrinter(ReportPrinter);

      end;  {If PrintDialog.Execute}

end;  {PrintButtonClick}

{===========================================================}
Procedure TParcelListDialog.ImportButtonClick(Sender: TObject);



var
  Done, ValidEntry : Boolean;
  ListFile, flRejects : TextFile;
  ParcelID, SwisSBLKey, SBLKey : String;
  LineNumber : Integer;
  SBLRec : SBLRecord;

begin
  Done := False;
  LineNumber := 1;

  OpenDialog.FilterIndex := 2;

  If OpenDialog.Execute
    then
      begin
        ClearParcelGrid(True);

        AssignFile(ListFile, OpenDialog.FileName);
        Reset(ListFile);

        AssignFile(flRejects, glblProgramDir + 'ListRejects.txt');
        Rewrite(flRejects);

        repeat
          ValidEntry := False;
          Readln(ListFile, ParcelID);
          ParcelID := Trim(ParcelID);

          If EOF(ListFile)
            then Done := True;

            {If it is in dash dot format, convert it to full format.}
            {FXX03312010-1(2.22.2.8)[I7182]: For some municipalities with odd SBLs, they don't have a length of 26.}

          If (_Compare(Length(ParcelID), 26, coEqual) or
              (_Compare(Pos('-', ParcelID), 0, coEqual) and
               _Compare(Pos('.', ParcelID), 0, coEqual)))
            then
              begin
                SwisSBLKey := ParcelID;

                If _Locate(ParcelTable, [GetTaxRlYr, SwisSBLKey], '', [loParseSwisSBLKey])
                  then ValidEntry := True
                  else SwisSBLKey := '';

              end
            else
              If _Compare(ParcelID[3], '/', coEqual)
                then SwisSBLKey := ConvertSwisDashDotToSwisSBL(ParcelID,
                                                               PASDataModule.TYSwisCodeTable,
                                                               ValidEntry)
                else
                  begin
                    ParcelTable.IndexName := 'BYTAXROLLYR_SBLKEY';

                    SBLRec := ConvertDashDotSBLToSegmentSBL(ParcelID, ValidEntry);

                    with SBLRec do
                      SBLKey := Take(3, Section) + Take(3, SubSection) +
                                Take(4, Block) + Take(3, Lot) + Take(3, Sublot) + Take(4, Suffix);

                    If _Locate(ParcelTable, [GetTaxRlYr, SBLKey], '', [loParseSBLOnly])
                      then
                        begin
                          SwisSBLKey := ParcelTable.FieldByName('SwisCode').AsString + SBLKey;
                          ValidEntry := True;
                        end
                      else SwisSBLKey := '';

                    ParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

                  end;  {If _Compare(ParcelID, '/', coContains)}

          If not ValidEntry
          then
          begin
            ParcelTable.IndexName := 'BYACCOUNTNO';
            If _Locate(ParcelTable, [ParcelID], '', [])
            then
            begin
              ValidEntry := True;
              SwisSBLKey := ExtractSSKey(ParcelTable);
            end;

          end;  {If not ValidEntry}

          If not ValidEntry
          then
          begin
            ParcelTable.IndexName := 'BYPrintKey';
            If _Locate(ParcelTable, [ParcelID], '', [])
            then
            begin
              ValidEntry := True;
              SwisSBLKey := ExtractSSKey(ParcelTable);
            end;

          end;  {If not ValidEntry}


          ParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

          If ValidEntry
          then
          begin
            If not AddOneParcel(SwisSBLKey)
            then Writeln(flRejects, SwisSBLKey, ',', 'Already in list.');
          end;

            {Make sure that we can locate this parcel.}

          If not GetParcel(ParcelTable, NumItems)
            then
              begin
                MessageDlg('The parcel ' + ParcelID + ' on line ' +
                           IntToStr(LineNumber) + ' could not be found.' + #13 +
                           'It has not been added to the list.',
                           mtError, [mbOk], 0);
                DeleteButtonClick(Sender);
                Writeln(flRejects, SwisSBLKey, ',', 'Not found.');

              end;  {If not GetParcel(ParcelTable, NumItems)}

          LineNumber := LineNumber + 1;

        until Done;

        CloseFile(ListFile);

        FileName := OpenDialog.FileName;
        SetCaption;
        Modified := False;
        CloseFile(flRejects);

      end;  {If OpenDialog.Execute}

end;  {ImportButtonClick}

{===========================================================}
Procedure TParcelListDialog.ExportButtonClick(Sender: TObject);

var
  I, ColumnNumber : Integer;
  ListFile : TextFile;
  SaveInDashDotFormat : Boolean;

begin
  SaveDialog.FilterIndex := 2;

  If SaveDialog.Execute
    then
      begin
        SaveInDashDotFormat := (MessageDlg('Do you want to export the parcel IDs in dash dot format?' + #13 +
                                           'If you answer no, the parcel IDs will be exported in full 26 character format.',
                                           mtConfirmation, [mbYes, mbNo], 0) = idYes);

        If SaveInDashDotFormat
          then ColumnNumber := 1
          else ColumnNumber := 2;

        AssignFile(ListFile, SaveDialog.FileName);
        Rewrite(ListFile);

        For I := 1 to (ParcelStringGrid.RowCount - 1) do
          If (Deblank(ParcelStringGrid.Cells[2, I]) <> '')
            then Writeln(ListFile, ParcelStringGrid.Cells[ColumnNumber, I]);

        CloseFile(ListFile);

        MessageDlg('The parcel list has been exported to ' + SaveDialog.FileName + '.',
                   mtInformation, [mbOK], 0);

      end;  {If SaveDialog.Execute}

end;  {ExportButtonClick}

{============================================================}
Procedure TParcelListDialog.SwitchRows(Row1,
                                       Row2 : LongInt);

var
  TempStr : String;
  I : Integer;

begin
  with ParcelStringGrid do
    If ((Row1 >= 0) and
        (Row1 <= (RowCount - 1)) and
        (Row2 >= 0) and
        (Row2 <= (RowCount - 1)))
      then
        For I := 0 to (ColCount - 1) do
          begin
            TempStr := Cells[I, Row1];
            Cells[I, Row1] := Cells[I, Row2];
            Cells[I, Row2] := TempStr;
          end;

end;  {SwitchRows}

{===========================================================}
Procedure TParcelListDialog.ParcelStringGridMouseDown(Sender: TObject;
                                                      Button: TMouseButton;
                                                      Shift: TShiftState;
                                                      X, Y: Integer);

{CHG11052001-2: Allow drag drop.}

var
  DragStartCol : LongInt;

begin
  Dragging := True;
  ParcelStringGrid.Cursor := crDrag;

  ParcelStringGrid.MouseToCell(X, Y, DragStartCol, DragStartRow);

end;  {ParcelStringGridMouseDown}

{===========================================================}
Procedure TParcelListDialog.ParcelStringGridMouseUp(Sender: TObject;
                                                    Button: TMouseButton;
                                                    Shift: TShiftState;
                                                    X, Y: Integer);

{CHG11052001-2: Allow drag drop.}

var
  DragEndCol, DragEndRow : LongInt;

begin
  ParcelStringGrid.MouseToCell(X, Y, DragEndCol, DragEndRow);

  If (DragStartRow <> DragEndRow)
    then SwitchRows(DragStartRow, DragEndRow);

  ParcelStringGrid.Cursor := crDefault;
  Dragging := False;

end;  {ParcelStringGridMouseUp}

{===========================================================}
Procedure TParcelListDialog.CloseFiles;

begin
  SwisCodeTable.Close;
  ParcelTable.Close;
end;  {CloseFiles}

{===========================================================}
Procedure TParcelListDialog.FormCloseQuery(    Sender: TObject;
                                           var CanClose: Boolean);
begin
  CheckAndSaveModifiedList;
end;





end.