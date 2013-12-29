unit UpdateVillageNamesAndAddresses_Import;

{To use this template:
  1. Save the form it under a new name.
  2. Rename the form in the Object Inspector.
  3. Rename the table in the Object Inspector. Then switch
     to the code and do a blanket replace of "Table" with the new name.
  4. Change UnitName to the new unit name.}

interface

uses
SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, Mask, Types,
  wwdblook, Psock, NMFtp, ShellAPI, RPCanvas, RPrinter, RPDefine, RPBase,
  RPFiler, PASTypes, ComCtrls, FileCtrl;

type
  ChangeRecord = record
    SwisSBLKey : String;
    OldNameAddress : NameAddrArray;
    NewNameAddress : NameAddrArray;
    OldName1 : String;
    OldName2 : String;
    OldAddress1 : String;
    OldAddress2 : String;
    OldStreet : String;
    OldCity : String;
    OldState : String;
    OldZip : String;
    OldZipPlus4 : String;
    OldBankCode : String;
    NewName1 : String;
    NewName2 : String;
    NewAddress1 : String;
    NewAddress2 : String;
    NewStreet : String;
    NewCity : String;
    NewState : String;
    NewZip : String;
    NewZipPlus4 : String;
    NewBankCode : String;
    ParcelExistsInVillage : Boolean;
    ParcelExistsInTown : Boolean;
  end;

  ChangePointer = ^ChangeRecord;

  TUpdateVillagesNameAndAddress_ImportForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    ParcelTable: TTable;
    NMFTP: TNMFTP;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    CloseButton: TBitBtn;
    StartButton: TBitBtn;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    Label2: TLabel;
    ItemSourceRadioGroup: TRadioGroup;
    StatusBar: TStatusBar;
    OpenDialog: TOpenDialog;
    PrintDialog: TPrintDialog;
    AuditNameAddressTable: TTable;
    TYParcelTable: TTable;
    OptionsGroupBox: TGroupBox;
    TrialRunCheckBox: TCheckBox;
    ChangeThisYearAndNextYearCheckBox: TCheckBox;
    ImportBankCodesCheckBox: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure NMFTPPacketRecvd(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure ReportPrintHeader(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    ItemSource : Integer;
    ChangeThisYearAndNextYear,
    ReportCancelled, TrialRun, ImportBankCodes : Boolean;
    ChangeList : TList;
    ImportFileDate : TDateTime;
    ImportFileTime : TTime;
    ParcelsInImportFileList : TStringList;
    ImportedSwisCode : String;

    Procedure InitializeForm;  {Open the tables and setup.}

    Procedure UpdateAddress(Sender : TObject;
                            ChangePtr : ChangePointer);

    Procedure AddChangeToChangeList(ChangeList : TList;
                                    ParcelTable : TTable;
                                    OldNameAddrArray,
                                    NewNameAddrArray : NameAddrArray;
                                    _NewName1 : String;
                                    _NewName2 : String;
                                    _NewAddress1 : String;
                                    _NewAddress2 : String;
                                    _NewStreet : String;
                                    _NewCity : String;
                                    _NewState : String;
                                    _NewZip : String;
                                    _NewZipPlus4 : String;
                                    _NewBankCode : String);

    Procedure ImportPASNames_AddressesFromInternet(    ChangeList : TList;
                                                   var Cancelled : Boolean);

    Procedure Import995Names_Addresses(    ChangeList : TList;
                                       var Cancelled : Boolean);

    Procedure ImportRPSv4Names_Addresses(    ChangeList : TList;
                                         var Cancelled : Boolean);

    Procedure FindParcelsInVillageNotInTown(ChangeList : TList;
                                            ParcelsInImportFileList : TStringList);

    Procedure PrintAddressChange(    Sender : TObject;
                                     SwisSBLKey : String;
                                     OldNameAddressArray,
                                     NewNameAddressArray : NameAddrArray;
                                     OldBankCode,
                                     NewBankCode : String;
                                 var NumberAddressesChanged,
                                     NumberBankCodesChange : Integer);

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, UtilEXSD,
     Prog, Preview;

{$R *.DFM}

const
  itPAS = 0;
  itRPSv3 = 1;
  itRPSv4 = 2;

{========================================================}
procedure TUpdateVillagesNameAndAddress_ImportForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.InitializeForm;

var
  Quit : Boolean;

begin
  StatusBar.Visible := False;
  UnitName := 'UpdateVillageNamesAndAddresses_Import';  {mmm}

  OpenTablesForForm(Self, NextYear);
  OpenTableForProcessingType(TYParcelTable, ParcelTableName, ThisYear, Quit);

end;  {InitializeForm}

{===================================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.NMFTPPacketRecvd(Sender: TObject);

begin
  StatusBar.Panels[1].Text := IntToStr(NMFTP.BytesRecvd) +
                              ' bytes received out of ' +
                              IntToStr(NMFTP.BytesTotal);
  StatusBar.Refresh;

end;  {NMFTPPacketRecvd}

{===================================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.AddChangeToChangeList(ChangeList : TList;
                                                                         ParcelTable : TTable;
                                                                         OldNameAddrArray,
                                                                         NewNameAddrArray : NameAddrArray;
                                                                         _NewName1 : String;
                                                                         _NewName2 : String;
                                                                         _NewAddress1 : String;
                                                                         _NewAddress2 : String;
                                                                         _NewStreet : String;
                                                                         _NewCity : String;
                                                                         _NewState : String;
                                                                         _NewZip : String;
                                                                         _NewZipPlus4 : String;
                                                                         _NewBankCode : String);

var
  ChangePtr : ChangePointer;

begin
  New(ChangePtr);

  with ChangePtr^ do
    begin
      SwisSBLKey := ExtractSSKey(ParcelTable);
      OldNameAddress := OldNameAddrArray;
      NewNameAddress := NewNameAddrArray;
      ParcelExistsInVillage := True;
      ParcelExistsInTown := True;

      NewName1 := _NewName1;
      NewName2 := _NewName2;
      NewAddress1 := _NewAddress1;
      NewAddress2 := _NewAddress2;
      NewStreet := _NewStreet;
      NewCity := _NewCity;
      NewState := _NewState;
      NewZip := _NewZip;
      NewZipPlus4 := _NewZipPlus4;

      If ImportBankCodes
        then NewBankCode := _NewBankCode;

      with ParcelTable do
        begin
          OldName1 := FieldByName('Name1').Text;
          OldName2 := FieldByName('Name2').Text;
          OldAddress1 := FieldByName('Address1').Text;
          OldAddress2 := FieldByName('Address2').Text;
          OldStreet := FieldByName('Street').Text;
          OldCity := FieldByName('City').Text;
          OldState := FieldByName('State').Text;
          OldZip := FieldByName('Zip').Text;
          OldZipPlus4 := FieldByName('ZipPlus4').Text;

          If ImportBankCodes
            then OldBankCode := FieldByName('BankCode').Text;

        end;  {with ParcelTable do}

    end;  {with ChangePtr^ do}

  ChangeList.Add(ChangePtr);

end;  {AddChangeToChangeList}

{===================================================================}
Function BankCodesDifferent(BankCode : String;
                            ParcelTable : TTable) : Boolean;

{CHG02082004-1(2.08): Include the bank code in the village name \ address update.}

begin
  Result := (Trim(ANSIUpperCase(BankCode)) <> Trim(ANSIUpperCase(ParcelTable.FieldByName('BankCode').Text)));
end;

{===================================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.ImportPASNames_AddressesFromInternet(    ChangeList : TList;
                                                                                        var Cancelled : Boolean);

var
  GoodDate, Connected, _Found, Done : Boolean;
  TotalRecords, CurrentRecord : LongInt;
  TempDate : TDateTime;
  ImportFileName, ImportDirectory, MostCurrentFileName,
  SwisSBLKey, Name1, Name2,
  Address1, Address2,
  Street, City, State,
  Zip, ZipPlus4, BankCode : String;
  {H+}
  ImportLine : String;
  {H-}
  I : Integer;
  ImportFile : TextFile;
  SBLRec : SBLRecord;
  FieldList : TStringList;
  OldNameAddrArray, NewNameAddrArray : NameAddrArray;
  ModifTime : TTime;
  ChangePtr : ChangePointer;
  MostCurrentFileDate : TDateTime;
  MostCurrentFileTime : TTime;

begin
  MostCurrentFileDate := Date;
  MostCurrentFileTime := Now;
  StatusBar.Visible := True;
  StatusBar.Panels[1].Text := '';

    {First get the most recent file.}

  Connected := True;

  ImportDirectory := GlblDrive + ':' + AddDirectorySlashes(GlblProgramDir) + 'IMPORTS\TOWN\';
  If not DirectoryExists(ImportDirectory)
    then ForceDirectories(ImportDirectory);

  try
    NMFTP.Connect;
  except
    Connected := False;
    MessageDlg('There was an error connecting to the website for uploading.' + #13 +
               'Please make sure that you are connected to the internet and try again.',
               mtError, [mbOK], 0);
    Cancelled := True;
  end;

  If Connected
    then
      try
        StatusBar.Panels[0].Text := 'Connected';
        StatusBar.Refresh;

        NMFTP.ChangeDir('www');
        NMFTP.ChangeDir('nameaddressupdates');
        NMFTP.ChangeDir(GlblVillageHoldingDockFolder);
      except
        MessageDlg('There was an error changing to www/nameaddressupdates.' + #13 +
                   'Please make sure that you are connected to the internet and try again.',
                   mtError, [mbOK], 0);
        Cancelled := True;
      end;

    {First determine the most recent file.}

  If (Connected and
      (not Cancelled))
    then
      begin
        MostCurrentFileDate := StrToDate('1/1/2000');
        MostCurrentFileName := '';
        NMFTP.List;

        For I := 0 to (NMFTP.FTPDirectoryList.name.Count - 1) do
          with NMFTP.FTPDirectoryList do
            begin
              GoodDate := True;

              try
                TempDate := StrToDate(ModifDate[I]);
              except
                GoodDate := False;
                TempDate := StrToDate('1/1/1950');
              end;

              If not GoodDate
                then TempDate := ParseLongDate(ModifDate[I], ModifTime, GoodDate);

              If (GoodDate and
                  (TempDate > MostCurrentFileDate))
                then
                  begin
                    MostCurrentFileDate := TempDate;
                    MostCurrentFileTime := ModifTime;
                    MostCurrentFileName := Name[I];

                  end;  {If (TempDate > MostCurrentFileDate)}

            end;  {with NMFTP1.FTPDirectoryList do}

        If (Deblank(MostCurrentFileName) = '')
          then
            begin
              MessageDlg('No update file was located at the website.' + #13 +
                         'Please call SCA for assistance.', mtError, [mbOK], 0);
              Cancelled := True;

            end;  {If (Deblank(MostCurrentFileName) = '')}

      end;  {If (Connected and ...}

    {Now download it.}

  If (Connected and
      (not Cancelled))
    then
      try
        ImportFileName := MostCurrentFileName;

        NMFTP.Mode(MODE_ASCII);
        NMFTP.Download(ImportFileName, ImportDirectory + ImportFileName);

      except
        Cancelled := True;
        MessageDlg('There was an error receiving the import file ' + ImportFileName + ' from the website.' + #13 +
                   'Please try again.', mtError, [mbOK], 0);
      end;

  NMFTP.Disconnect;

  StatusBar.Panels[0].Text := 'Disconnected';
  StatusBar.Panels[1].Text := 'Preparing file to import.';
  StatusBar.Refresh;

    {Now import it.}

  If not Cancelled
    then
      begin
          {Prescan for total number of records.}

        AssignFile(ImportFile, ImportDirectory + ImportFileName);
        Reset(ImportFile);

        TotalRecords := 0;

        repeat
          Readln(ImportFile, ImportLine);
          TotalRecords := TotalRecords + 1;
        until EOF(ImportFile);

        ProgressDialog.Start(TotalRecords, True, True);

        Reset(ImportFile);
        Done := False;
        FieldList := TStringList.Create;
        CurrentRecord := 0;

        repeat
          Readln(ImportFile, ImportLine);

          If EOF(ImportFile)
            then Done := True;

            {CHG02082004-1(2.08): Include the bank code in the village name \ address update.}

          ParseCommaDelimitedStringIntoFields(ImportLine, FieldList, True);

          try
            SwisSBLKey := FieldList[0];
            Name1 := FieldList[1];
            Name2 := FieldList[2];
            Address1 := FieldList[3];
            Address2 := FieldList[4];
            Street := FieldList[5];
            City := FieldList[6];
            State := FieldList[7];
            Zip := FieldList[8];
            ZipPlus4 := FieldList[9];

            If ImportBankCodes
              then BankCode := FieldList[10];

            ImportedSwisCode := Take(6, SwisSBLKey);
          except
            SwisSBLKey := '';
          end;

          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          CurrentRecord := CurrentRecord + 1;

          If (SwisSBLKey = '')
            then NonBtrvSystemSupport(001, 1, 'Error parsing line number ' + IntToStr(CurrentRecord) + '.',
                                      UnitName, GlblErrorDlgBox)
            else
              begin
                FillInNameAddrArray(Name1, Name2,
                                    Address1, Address2,
                                    Street, City,
                                    State, Zip,
                                    ZipPlus4, True, False,
                                    NewNameAddrArray);

                SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                with SBLRec do
                  _Found := FindKeyOld(ParcelTable,
                                      ['TaxRollYr', 'SwisCode', 'Section',
                                       'Subsection', 'Block', 'Lot', 'Sublot',
                                       'Suffix'],
                                      [GlblNextYear, SwisCode, Section,
                                       SubSection, Block, Lot, Sublot, Suffix]);

                If _Found
                  then
                    begin
                      ParcelsInImportFileList.Add(SwisSBLKey);
                      GetNameAddress(ParcelTable, OldNameAddrArray);

                        {CHG02082004-1(2.08): Include the bank code in the village name \ address update.}

                      If (NameAddressesDifferent(NewNameAddrArray, OldNameAddrArray, True) or
                          (ImportBankCodes and
                           BankCodesDifferent(BankCode, ParcelTable)))
                        then AddChangeToChangeList(ChangeList, ParcelTable,
                                                   OldNameAddrArray, NewNameAddrArray,
                                                   Name1, Name2,
                                                   Address1, Address2,
                                                   Street, City,
                                                   State, Zip,
                                                   ZipPlus4, BankCode);

                    end
                  else
                    begin
                      New(ChangePtr);

                      ChangePtr^.SwisSBLKey := SwisSBLKey;
                      ChangePtr^.ParcelExistsInVillage := False;
                      ChangePtr^.ParcelExistsInTown := True;

                      ChangeList.Add(ChangePtr);

                    end;  {else of If _Found}

              end;  {else of If (SwisSBLKey = '')}

        until Done;

        CloseFile(ImportFile);
        FieldList.Free;

        ImportFileDate := MostCurrentFileDate;
        ImportFileTime := MostCurrentFileTime;

      end;  {If not Cancelled}

end;  {ImportPASNames_AddressesFromInternet}

{==============================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.Import995Names_Addresses(    ChangeList : TList;
                                                                            var Cancelled : Boolean);

var
  _Found, Done : Boolean;
  CurrentRecord : LongInt;
  ImportDirectory,
  SwisSBLKey, Name1, Name2,
  Address1, Address2,
  Street, City, State,
  Zip, ZipPlus4, BankCode : String;
  {H+}
  ImportLine : ANSIString;
  {H-}
  ImportFile : TextFile;
  SBLRec : SBLRecord;
  OldNameAddrArray, NewNameAddrArray : NameAddrArray;
  ChangePtr : ChangePointer;
  _FileSize : LongInt;

begin
  ImportDirectory := GlblDrive + ':' + AddDirectorySlashes(GlblProgramDir) + 'IMPORTS\';
  OpenDialog.InitialDir := ImportDirectory;
  OpenDialog.FileName := 'RPS995T1';

  If OpenDialog.Execute
    then
      begin
        ProgressDialog.Start(ParcelTable.RecordCount, True, True);
        AssignFile(ImportFile, OpenDialog.FileName);
        Reset(ImportFile);

        Done := False;
        CurrentRecord := 0;

        repeat
          Readln(ImportFile, ImportLine);

          If EOF(ImportFile)
            then Done := True;

          ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
          CurrentRecord := CurrentRecord + 1;
          Application.ProcessMessages;

            {CHG02082004-1(2.08): Include the bank code in the village name \ address update.}

          If (ImportLine[32] = 'P')
            then
              begin
                try
                  SwisSBLKey := Copy(ImportLine, 1, 26);
                  Name1 := Copy(ImportLine, 277, 25);
                  Name2 := Copy(ImportLine, 302, 25);
                  Address1 := Copy(ImportLine, 327, 25);
                  Address2 := Copy(ImportLine, 352, 25);
                  Street := Copy(ImportLine, 377, 25);
                  City := Copy(ImportLine, 402, 25);
                  State := '';  {In the 995 city and state are in one field.}
                  Zip := Copy(ImportLine, 427, 5);
                  ZipPlus4 := Copy(ImportLine, 432, 4);
                  BankCode := Copy(ImportLine, 450, 7);

                  ParseCityIntoCityAndState(City, State);
                except
                  SwisSBLKey := '';
                end;

                If (SwisSBLKey = '')
                  then NonBtrvSystemSupport(001, 1, 'Error parsing line number ' + IntToStr(CurrentRecord) + '.',
                                            UnitName, GlblErrorDlgBox)
                  else
                    begin
                      FillInNameAddrArray(Name1, Name2,
                                          Address1, Address2,
                                          Street, City,
                                          State, Zip,
                                          ZipPlus4, True, False,
                                          NewNameAddrArray);

                      SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

                      with SBLRec do
                        _Found := FindKeyOld(ParcelTable,
                                            ['TaxRollYr', 'SwisCode', 'Section',
                                             'Subsection', 'Block', 'Lot', 'Sublot',
                                             'Suffix'],
                                            [GlblNextYear, SwisCode, Section,
                                             SubSection, Block, Lot, Sublot, Suffix]);

                      If _Found
                        then
                          begin
                            ParcelsInImportFileList.Add(SwisSBLKey);
                            GetNameAddress(ParcelTable, OldNameAddrArray);

                              {CHG02082004-1(2.08): Include the bank code in the village name \ address update.}

                            If (NameAddressesDifferent(NewNameAddrArray, OldNameAddrArray, True) or
                                (ImportBankCodes and
                                 BankCodesDifferent(BankCode, ParcelTable)))
                              then AddChangeToChangeList(ChangeList, ParcelTable,
                                                         OldNameAddrArray, NewNameAddrArray,
                                                         Name1, Name2,
                                                         Address1, Address2,
                                                         Street, City,
                                                         State, Zip,
                                                         ZipPlus4, BankCode);

                          end
                        else
                          begin
                            New(ChangePtr);

                            ChangePtr^.SwisSBLKey := SwisSBLKey;
                            ChangePtr^.ParcelExistsInVillage := False;
                            ChangePtr^.ParcelExistsInTown := True;

                            ChangeList.Add(ChangePtr);

                          end;  {else of If _Found}

                    end;  {else of If (SwisSBLKey = '')}

              end;  {If (ImportLine[32] = 'P')}

        until Done;

        CloseFile(ImportFile);

        GetFileSpecifications(OpenDialog.FileName, ImportFileDate, ImportFileTime, _FileSize);

      end;  {If not Cancelled}

  ProgressDialog.Finish;

end;  {Import995Names_Addresses}

{==============================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.ImportRPSv4Names_Addresses(    ChangeList : TList;
                                                                              var Cancelled : Boolean);

var
  _Found, Done, ValidEntry : Boolean;
  LineForParcel : Integer;
  ImportDirectory, SwisSBLKey,
  LastParcelID, ParcelID,
  SwisCode, Name1, Name2,
  Address1, Address2,
  Street, City, State,
  Zip, ZipPlus4, AttentionName, POBox, BankCode : String;
  {H+}
  ImportLine : ANSIString;
  {H-}
  ImportFile : TextFile;
  SBLRec : SBLRecord;
  OldNameAddrArray, NewNameAddrArray : NameAddrArray;
  ChangePtr : ChangePointer;
  FieldList : TStringList;
  _FileSize : LongInt;

begin
  LastParcelID := '';
  ImportDirectory := GlblDrive + ':' + AddDirectorySlashes(GlblProgramDir) + 'IMPORTS\';
  OpenDialog.InitialDir := ImportDirectory;
  OpenDialog.FileName := 'pomona*.csv';
  FieldList := TStringList.Create;
  LineForParcel := 1;

  If OpenDialog.Execute
    then
      begin
        ProgressDialog.Start(ParcelTable.RecordCount, True, True);
        AssignFile(ImportFile, OpenDialog.FileName);
        Reset(ImportFile);

        Done := False;
        Readln(ImportFile, ImportLine);  {First line is headers}

        repeat
          Readln(ImportFile, ImportLine);

          If EOF(ImportFile)
            then Done := True;

          ProgressDialog.Update(Self, LastParcelID);
          Application.ProcessMessages;

          ParseCommaDelimitedStringIntoFields(ImportLine, FieldList, True);

          SwisCode := FieldList[0];
          ParcelID := FieldList[1];

            {If we switched to a new parcel ID, then process the last one.}

          If (Done or
              ((Deblank(LastParcelID) <> '') and
               (Trim(ParcelID) <> Trim(LastParcelID))))
            then
              begin
                  {The bank codes are now in a seperate file from the addresses for RPS 4.}

                If ImportBankCodes
                  then BankCode := FieldList[2]
                  else
                    begin
                      LineForParcel := 1;
                      If (Deblank(AttentionName) <> '')
                        then Address1 := AttentionName;

                      If (Deblank(POBox) <> '')
                        then
                          If (Deblank(Address1) = '')
                            then Address1 := POBox
                            else Address2 := POBox;

                      FillInNameAddrArray(Name1, Name2,
                                          Address1, Address2,
                                          Street, City,
                                          State, Zip,
                                          ZipPlus4, True, False, 
                                          NewNameAddrArray);

                    end;  {else of If ImportBankCodes}

                SBLRec := ConvertDashDotSBLToSegmentSBL(LastParcelID, ValidEntry);
                SBLRec.SwisCode := SwisCode;

                with SBLRec do
                  _Found := FindKeyOld(ParcelTable,
                                      ['TaxRollYr', 'SwisCode', 'Section',
                                       'Subsection', 'Block', 'Lot', 'Sublot',
                                       'Suffix'],
                                      [GlblNextYear, SwisCode, Section,
                                       SubSection, Block, Lot, Sublot, Suffix]);

                If _Found
                  then
                    begin
                      SwisSBLKey := ExtractSSKey(ParcelTable);
                      ParcelsInImportFileList.Add(SwisSBLKey);

                      If not ImportBankCodes
                        then GetNameAddress(ParcelTable, OldNameAddrArray);

                        {CHG02082004-1(2.08): Include the bank code in the village name \ address update.}

                      If (((not ImportBankCodes) and
                           NameAddressesDifferent(NewNameAddrArray, OldNameAddrArray, True)) or
                          (ImportBankCodes and
                           BankCodesDifferent(BankCode, ParcelTable)))
                        then AddChangeToChangeList(ChangeList, ParcelTable,
                                                   OldNameAddrArray, NewNameAddrArray,
                                                   Name1, Name2,
                                                   Address1, Address2,
                                                   Street, City,
                                                   State, Zip,
                                                   ZipPlus4, BankCode);

                    end
                  else
                    begin
                      New(ChangePtr);

                      ChangePtr^.SwisSBLKey := SwisSBLKey;
                      ChangePtr^.ParcelExistsInVillage := False;
                      ChangePtr^.ParcelExistsInTown := True;

                      ChangeList.Add(ChangePtr);

                    end;  {else of If _Found}

              end;  {else of If (SwisSBLKey = '')}

          If not ImportBankCodes
            then
              begin
                case LineForParcel of
                  1 : begin
                        Name1 := FieldList[10];
                        Name2 := '';
                        Address1 := '';
                        Address2 := '';
                        AttentionName := FieldList[11];

                        POBox := FieldList[9];
                        If (Deblank(POBox) <> '')
                          then POBox := 'P.O. BOX ' + POBox;

                        Street := Trim(Trim(FieldList[3]) + ' ' + Trim(FieldList[4]) + ' ' + Trim(FieldList[5]));
                        City := Trim(FieldList[6]);
                        State := Trim(FieldList[7]);
                        Zip := Trim(FieldList[8]);
                        ZipPlus4 := '';  {No zip plus 4 information at this time.}

(*                        If ImportBankCodes
                          then
                            try
                              BankCode := Trim(FieldList[11]);
                            except
                              BankCode := '';
                            end; *)

                      end;  {Line 1}

                  else
                    begin
                        {If there is a second line of parcel information then
                         it might have a second owner name.}

                      If ((Deblank(LastParcelID) <> '') and
                          (Trim(FieldList[10]) <> ''))
                        then Name2 := Trim(FieldList[10]);

                    end;  {not 1st line for parcel}

                end;  {case LineForParcel of}

                LineForParcel := LineForParcel + 1;

              end;  {If not ImportBankCodes}

          LastParcelID := ParcelID;

        until Done;

        CloseFile(ImportFile);

        GetFileSpecifications(OpenDialog.FileName, ImportFileDate, ImportFileTime, _FileSize);

      end;  {If not Cancelled}

  ProgressDialog.Finish;

end;  {ImportRPSv4Names_Addresses}

{====================================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.UpdateAddress(Sender : TObject;
                                                                 ChangePtr : ChangePointer);

var
  SBLRec : SBLRecord;
  _Found : Boolean;

begin
  with ChangePtr^ do
    begin
      SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

      with SBLRec do
        _Found := FindKeyOld(ParcelTable,
                             ['TaxRollYr', 'SwisCode', 'Section',
                              'Subsection', 'Block', 'Lot', 'Sublot',
                              'Suffix'],
                             [GlblNextYear, SwisCode, Section,
                              SubSection, Block, Lot, Sublot, Suffix]);

        {CHG02082004-1(2.08): Include the bank code in the village name \ address update.}

      If _Found
        then
          begin
            with ParcelTable do
              try
                Edit;
                FieldByName('Name1').Text := NewName1;
                FieldByName('Name2').Text := NewName2;
                FieldByName('Address1').Text := NewAddress1;
                FieldByName('Address2').Text := NewAddress2;
                FieldByName('Street').Text := NewStreet;
                FieldByName('City').Text := NewCity;
                FieldByName('State').Text := NewState;
                FieldByName('Zip').Text := NewZip;
                FieldByName('ZipPlus4').Text := NewZipPlus4;

                If ImportBankCodes
                  then FieldByName('BankCode').Text := NewBankCode;
                Post;
              except
                SystemSupport(5, ParcelTable, 'Error updating parcel ' + SwisSBLKey + '.',
                              UnitName, GlblErrorDlgBox);
              end;

          end
        else SystemSupport(6, ParcelTable, 'Error relocating parcel ' + SwisSBLKey + '.',
                           UnitName, GlblErrorDlgBox);

      If ChangeThisYearAndNextYear
        then
          begin
            with SBLRec do
              _Found := FindKeyOld(TYParcelTable,
                                   ['TaxRollYr', 'SwisCode', 'Section',
                                    'Subsection', 'Block', 'Lot', 'Sublot',
                                    'Suffix'],
                                   [GlblThisYear, SwisCode, Section,
                                    SubSection, Block, Lot, Sublot, Suffix]);

            If _Found
              then
                with TYParcelTable do
                  try
                    Edit;
                    FieldByName('Name1').Text := NewName1;
                    FieldByName('Name2').Text := NewName2;
                    FieldByName('Address1').Text := NewAddress1;
                    FieldByName('Address2').Text := NewAddress2;
                    FieldByName('Street').Text := NewStreet;
                    FieldByName('City').Text := NewCity;
                    FieldByName('State').Text := NewState;
                    FieldByName('Zip').Text := NewZip;
                    FieldByName('ZipPlus4').Text := NewZipPlus4;
                    If ImportBankCodes
                      then FieldByName('BankCode').Text := NewBankCode;
                    Post;
                  except
                    SystemSupport(9, TYParcelTable, 'Error updating TY parcel ' + SwisSBLKey + '.',
                                  UnitName, GlblErrorDlgBox);
                  end;

          end;  {If ChangeThisYearAndNextYearCheckBox}

        {Insert an name \ address audit record.}

      with AuditNameAddressTable do
        try
          Insert;
          FieldByName('SwisSBLKey').Text := SwisSBLKey;
          FieldByName('Date').AsDateTime := Date;
          FieldByName('Time').AsDateTime := Time;
          FieldByName('User').Text := 'TOWN';
          FieldByName('NewName1').Text := NewName1;
          FieldByName('NewName2').Text := NewName2;
          FieldByName('NewAddress1').Text := NewAddress1;
          FieldByName('NewAddress2').Text := NewAddress2;
          FieldByName('NewStreet').Text := NewStreet;
          FieldByName('NewCity').Text := NewCity;
          FieldByName('NewState').Text := NewState;
          FieldByName('NewZip').Text := NewZip;
          FieldByName('NewZipPlus4').Text := NewZipPlus4;
          FieldByName('OldName1').Text := OldName1;
          FieldByName('OldName2').Text := OldName2;
          FieldByName('OldAddress1').Text := OldAddress1;
          FieldByName('OldAddress2').Text := OldAddress2;
          FieldByName('OldStreet').Text := OldStreet;
          FieldByName('OldCity').Text := OldCity;
          FieldByName('OldState').Text := OldState;
          FieldByName('OldZip').Text := OldZip;
          FieldByName('OldZipPlus4').Text := OldZipPlus4;
          Post;
        except
          SystemSupport(7, AuditNameAddressTable, 'Error posting name \ address audit for ' + SwisSBLKey + '.',
                        UnitName, GlblErrorDlgBox);
        end;

    end;  {with ChangePtr^ do}

end;  {UpdateAddress}

{====================================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.PrintAddressChange(    Sender : TObject;
                                                                          SwisSBLKey : String;
                                                                          OldNameAddressArray,
                                                                          NewNameAddressArray : NameAddrArray;
                                                                          OldBankCode,
                                                                          NewBankCode : String;
                                                                      var NumberAddressesChanged,
                                                                          NumberBankCodesChange : Integer);

var
  I : Integer;
  ChangePrinted, ParcelIDPrinted : Boolean;

begin
  ChangePrinted := False;
  ParcelIDPrinted := False;

  with Sender as TBaseReport do
    begin
      If (LinesLeft < 10)
        then NewPage;

        {CHG02082004-1(2.08): Include the bank code in the village name \ address update.}

      If NameAddressesDifferent(NewNameAddressArray, OldNameAddressArray, True)
        then
          begin
            ChangePrinted := True;
            ParcelIDPrinted := True;
            NumberAddressesChanged := NumberAddressesChanged + 1;

            Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                    #9 + Take(30, OldNameAddressArray[1]) +
                    #9 + Take(30, NewNameAddressArray[1]));

            For I := 2 to 6 do
              If ((Deblank(OldNameAddressArray[I]) <> '') or
                  (Deblank(NewNameAddressArray[I]) <> ''))
                then Println(#9 +
                             #9 + Take(30, OldNameAddressArray[I]) +
                             #9 + Take(30, NewNameAddressArray[I]));

          end;  {If NameAddressesDifferent(NewNameAddrArray, OldNameAddrArray, True)}

      If (ImportBankCodes and
          (Trim(ANSIUpperCase(OldBankCode)) <> Trim(ANSIUpperCase(NewBankCode))))
        then
          begin
            ChangePrinted := True;
            NumberBankCodesChange := NumberBankCodesChange + 1;

            If ParcelIDPrinted
              then Print(#9)
              else Print(#9 + ConvertSwisSBLToDashDot(SwisSBLKey));

            Println(#9 + 'Bank: ' + OldBankCode +
                    #9 + 'Bank: ' + NewBankCode);

          end;  {If (ImportBankCodes and ...}

      If ChangePrinted
        then Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintAddressChange}

{==============================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.ReportPrintHeader(Sender: TObject);

begin
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.5;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.5;
      SetFont('Arial',12);
      Bold := True;
      Home;
      PrintCenter('Names and Addresses Changed - Village Import', (PageWidth / 2));

        {CHG02252004-1(2.08): Put the date and time of the import file on the report.}

      try
        CRLF;
        Bold := False;
        SetFont('Arial', 10);
        PrintCenter('Import file date: ' + DateToStr(ImportFileDate) +
                    '  time: ' + TimeToStr(ImportFileTime), (PageWidth / 2));
      except
      end;

      SetFont('Times New Roman', 9);
      CRLF;
      Println('');

      If TrialRun
        then
          begin
            Println('  Trial Run (no update)');
            Println('');
          end;

      ClearTabs;
      SetTab(0.3, pjCenter, 1.8, 0, BOXLINEBottom, 0);   {Parcel ID}
      SetTab(2.3, pjCenter, 2.5, 0, BOXLINEBottom, 0);   {Old Addres}
      SetTab(5.0, pjCenter, 2.5, 0, BOXLINEBottom, 0);   {New Address}

      Println(#9 + 'Parcel ID' +
              #9 + 'Old Address' +
              #9 + 'New Address');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.8, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(2.3, pjLeft, 2.5, 0, BOXLINENone, 0);   {Old Addres}
      SetTab(5.0, pjLeft, 2.5, 0, BOXLINENone, 0);   {New Address}

    end;  {with Sender as TBaseReport do}

end;  {ReportPrintHeader}

{==============================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.ReportPrint(Sender: TObject);

{CHG02252004-2(2.08): List parcels in village not in town.}

var
  I, NumberAddressesChanged,
  NumberBankCodesChanged,
  NumberParcelsInVillageNotTown,
  NumberParcelsInTownNotVillage : Integer;

begin
  NumberAddressesChanged := 0;
  NumberBankCodesChanged := 0;
  NumberParcelsInVillageNotTown := 0;
  NumberParcelsInTownNotVillage := 0;

  with Sender as TBaseReport do
    begin
      For I := 0 to (ChangeList.Count - 1) do
        begin
          with ChangePointer(ChangeList[I])^ do
            begin
              If ParcelExistsInVillage
                then
                  begin
                      {CHG02082004-1(2.08): Include the bank code in the village name \ address update.}

                    PrintAddressChange(Sender, SwisSBLKey,
                                       OldNameAddress,
                                       NewNameAddress,
                                       OldBankCode,
                                       NewBankCode,
                                       NumberAddressesChanged,
                                       NumberBankCodesChanged);

                    If not TrialRun
                      then UpdateAddress(Sender, ChangePointer(ChangeList[I]));

                  end;  {If ParcelExistsInVillage}

              If not ParcelExistsInVillage
                then
                  begin
                    NumberParcelsInTownNotVillage := NumberParcelsInTownNotVillage + 1;
                    Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                            #9 + 'Parcel in town, not village.');

                  end;  {If not ParcelExistsInVillage}

              If not ParcelExistsInTown
                then
                  begin
                    NumberParcelsInVillageNotTown := NumberParcelsInVillageNotTown + 1;
                    Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
                            #9 + 'Parcel in village, not town.');

                  end;  {If not ParcelExistsInTown}

            end;  {with ChangePointer(ChangeList[I])^ do}

          If (LinesLeft < 8)
            then NewPage;

        end;  {For I := 0 to (ChangeList.Count - 1) do}

      Println('');

      If TrialRun
        then
          begin
            Println(#9 + 'Addresses to be changed = ' + IntToStr(NumberAddressesChanged));
            Println(#9 + 'Bank codes to be changed = ' + IntToStr(NumberbankCodesChanged));
          end
        else
          begin
            Println(#9 + 'Addresses changed = ' + IntToStr(NumberAddressesChanged));
            Println(#9 + 'Bank codes changed = ' + IntToStr(NumberBankCodesChanged));
          end;

      Println(#9 + 'Parcels in village, not town = ' + IntToStr(NumberParcelsInVillageNotTown));
      Println(#9 + 'Parcels in town, not village = ' + IntToStr(NumberParcelsInTownNotVillage));

    end;  {with Sender as TBaseReport do}

end;  {ReportPrint}

{==============================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.FindParcelsInVillageNotInTown(ChangeList : TList;
                                                                                 ParcelsInImportFileList : TStringList);

{CHG02252004-2(2.08): List parcels in village not in town.}

var
  Done, FirstTimeThrough : Boolean;
  SwisSBLKey : String;
  ChangePtr : ChangePointer;

begin
  Done := False;
  FirstTimeThrough := True;
  ProgressDialog.Reset;
  ProgressDialog.Start(ParcelTable.RecordCount, False, False);
  ProgressDialog.UserLabelCaption := 'Finding parcels in village not in town.';

  ParcelTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If ParcelTable.EOF
      then Done := True;

    SwisSBLKey := ExtractSSKey(ParcelTable);
    ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
    Application.ProcessMessages;

    If ((not Done) and
        (ParcelsInImportFileList.IndexOf(SwisSBLKey) = -1) and
        (ParcelTable.FieldByName('SwisCode').Text = ImportedSwisCode))
      then
        begin
          New(ChangePtr);

          ChangePtr^.SwisSBLKey := SwisSBLKey;
          ChangePtr^.ParcelExistsInVillage := True;
          ChangePtr^.ParcelExistsInTown := False;

          ChangeList.Add(ChangePtr);

        end;  {If not Done}

  until Done;

end;  {FindParcelsInVillageNotInTown}

{==============================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.StartButtonClick(Sender: TObject);

var
  Quit, Cancelled : Boolean;
  NewFileName : String;

begin
  ReportCancelled := False;
  Cancelled := False;
  ChangeList := TList.Create;
  ItemSource := ItemSourceRadioGroup.ItemIndex;
  TrialRun := TrialRunCheckBox.Checked;
  ChangeThisYearAndNextYear := ChangeThisYearAndNextYearCheckBox.Checked;
  ImportBankCodes := ImportBankCodesCheckBox.Checked;
  ParcelsInImportFileList := TStringList.Create;

  case ItemSource of
    itPAS : ImportPASNames_AddressesFromInternet(ChangeList, Cancelled);
    itRPSv3 : Import995Names_Addresses(ChangeList, Cancelled);
    itRPSv4 : ImportRPSv4Names_Addresses(ChangeList, Cancelled);

  end;  {case ItemSource of}

    {CHG02252004-2(2.08): List parcels in village not in town.}

  FindParcelsInVillageNotInTown(ChangeList, ParcelsInImportFileList);

    {Now print the changes.}

  If Cancelled
    then MessageDlg('The name \ address import was cancelled and did not complete.',
                    mtWarning, [mbOK], 0)
    else
      If PrintDialog.Execute
        then
          begin
            AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler, [ptLaser],
                                  False, Quit);

            If not Quit
              then
                begin
                  ProgressDialog.UserLabelCaption := '';
                  ProgressDialog.Start(ChangeList.Count, True, True);

                    {Now print the report.}

                  If not (Quit or ReportCancelled)
                    then
                      begin
                        GlblPreviewPrint := False;

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

                          {FXX07221998-1: So that more than one person can run the report
                                          at once, use a time based name first and then
                                          rename.}

                          {If they want to see it on the screen, start the preview.}

                        If PrintDialog.PrintToFile
                          then
                            begin
                              GlblPreviewPrint := True;
                              NewFileName := GetPrintFileName(Self.Caption, True);
                              ReportFiler.FileName := NewFileName;

                              try
                                PreviewForm := TPreviewForm.Create(self);
                                PreviewForm.FilePrinter.FileName := NewFileName;
                                PreviewForm.FilePreview.FileName := NewFileName;

                                PreviewForm.FilePreview.ZoomFactor := 130;

                                ReportFiler.Execute;

                                  {FXX09071999-6: Tell people that printing is starting and
                                                  done.}

                                ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                                PreviewForm.ShowModal;
                              finally
                                PreviewForm.Free;
                              end;

                              ShowReportDialog('ImportTownNamesAndAddresse.RPT', NewFileName, True);

                            end
                          else ReportPrinter.Execute;

                      end;  {If not Quit}

                    {Clear the selections.}

                  ProgressDialog.Finish;

                    {FXX09071999-6: Tell people that printing is starting and
                                    done.}

                  DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);


                end;  {If not Quit}

            ResetPrinter(ReportPrinter);

          end;  {If PrintDialog.Execute}

  FreeTList(ChangeList, SizeOf(ChangeRecord));
  ParcelsInImportFileList.Free;

end;  {StartButtonClick}

{===================================================================}
Procedure TUpdateVillagesNameAndAddress_ImportForm.FormClose(    Sender: TObject;
                                                      var Action: TCloseAction);

begin
  CloseTablesForForm(Self);

    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}

end.