unit UpdateNamesAndAddressesInSCASystems;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, Wwtable, Wwdatsrc, Menus, RPCanvas,
  RPrinter, RPDefine, RPBase, RPFiler, PASTypes, ComCtrls, ADODB;

type
  TSystemsSetType = set of (tsDelinquent, tsSchool, tsTown, tsCounty,
                            tsBigBuilding, tsSmallBuilding, tsPASVillage,
                            tsSQLLien);

  TGeneralDLLFunction = Function (Application : TApplication) : Boolean;

  TGetParcelNameAddressFunction = Function (    Application : TApplication;
                                                SwisSBLKey : ShortString;
                                                SchoolCode : ShortString;
                                                TaxSystem : ShortString;
                                            var OldNameAddressArray : NameAddrArray) : Boolean;

  TSetParcelNameAddressProcedure = Procedure (    Application : TApplication;
                                                  SwisSBLKey : ShortString;
                                                  SchoolCode : ShortString;
                                                  TaxSystem : ShortString;
                                                  NewNameAddressArray : NameAddrArray);

  TGetParcelBankCodeFunction = Function (    Application : TApplication;
                                             SwisSBLKey : ShortString;
                                             SchoolCode : ShortString;
                                             IgnoreThisParameter : ShortString;
                                             TaxSystem : ShortString;
                                         var BankCode : ShortString) : Boolean;

  TSetParcelBankCodeProcedure = Procedure (Application : TApplication;
                                           SwisSBLKey : ShortString;
                                           SchoolCode : ShortString;
                                           IgnoreThisParameter : ShortString;
                                           TaxSystem : ShortString;
                                           BankCode : ShortString);

  TInitializeTaxNameAddressDLLFunction = Function (Application : TApplication;
                                                   TaxSystems : ShortString) : Boolean;

  TGetParcelNameAddressBuildingFunction = Function(    Application : TApplication;
                                                       SwisCode : ShortString;
                                                       SBL : ShortString;
                                                   var OldNameAddressArray : NameAddrArray) : Boolean;

  TSetParcelNameAddressBuildingProcedure = Procedure(    Application : TApplication;
                                                         SwisCode : ShortString;
                                                         SBL : ShortString;
                                                         NewNameAddressArray : NameAddrArray);

  TGetLegalAddressBuildingFunction = Function(    Application : TApplication;
                                                  SwisCode : ShortString;
                                                  SBL : ShortString;
                                              var OldLegalAddressName : ShortString;
                                              var OldLegalAddressNumber : ShortString) : Boolean;

  TSetLegalAddressBuildingProcedure = Procedure(Application : TApplication;
                                                SwisCode : ShortString;
                                                SBL : ShortString;
                                                OldLegalAddressName : ShortString;
                                                OldLegalAddressNumber : ShortString);

  TParcelExistsInBuildingSystemFuncion = Function(Application : TApplication;
                                                  SwisCode : ShortString;
                                                  SBL : ShortString) : Boolean;

  TAddParcelToBuildingSystemProcedure = Procedure(Application : TApplication;
                                                  SwisCode : ShortString;
                                                  SBL : ShortString;
                                                  AssessmentYear : ShortString;
                                                  NameAddressArray : NameAddrArray);

  TUpdateNamesAndAddressesInSCASystemsForm = class(TForm)
    ParcelTable: TwwTable;
    PrintDialog: TPrintDialog;
    tbTownTaxParcel: TTable;
    tbSchoolTaxParcel: TTable;
    tbCountyTaxParcel: TTable;
    SwisCodeTable: TwwTable;
    SchoolCodeTable: TTable;
    tbSmallBuildingParcel: TTable;
    OptionsPageControl: TPageControl;
    Options_TabSheet: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    lbVillagePASSystem: TLabel;
    CurrentSchoolTaxCheckBox: TCheckBox;
    CurrentTownTaxCheckBox: TCheckBox;
    CurrentCountyTaxCheckBox: TCheckBox;
    BigBuildingCheckBox: TCheckBox;
    SmallBuildingCheckBox: TCheckBox;
    cbVillagePASSystem: TCheckBox;
    GroupBox2: TGroupBox;
    AddNewParcelsCheckBox: TCheckBox;
    TrialRunCheckBox: TCheckBox;
    UpdateBankCodesCheckBox: TCheckBox;
    UpdateLegalAddressesCheckBox: TCheckBox;
    CreateParcelListCheckBox: TCheckBox;
    UpdateAllParcelsCheckBox: TCheckBox;
    Swis_School_TabSheet: TTabSheet;
    Label6: TLabel;
    Label21: TLabel;
    SwisCodeListBox: TListBox;
    SchoolCodeListBox: TListBox;
    Panel1: TPanel;
    StartButton: TBitBtn;
    CloseButton: TBitBtn;
    cbxVillagePASSystem: TComboBox;
    tbPASVillageParcels: TTable;
    cbxLocateByAccountNumber: TCheckBox;
    cbSQLLienSystem: TCheckBox;
    tbTYPASVillageParcels: TTable;
    ReportFiler: TReportFiler;
    ReportPrinter: TReportPrinter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ReportHeaderPrint(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BuildingCheckBoxClick(Sender: TObject);
    procedure TaxCheckBoxClick(Sender: TObject);
    procedure cbVillagePASSystemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    UpdateBankCodes, AddNewParcelsToBuilding, UpdateAllParcels,
    CreateParcelList, UpdateLegalAddresses,
    TrialRun, ReportCancelled, bLocateByAccountNumber : Boolean;
    SystemsToUpdate : TSystemsSetType;
    SelectedSchoolCodes : TStringList;
    SelectedSwisCodes : TStringList;
    sVillageSystemToUpdate : String;

    Procedure InitializeForm;  {Open the tables and setup.}

  end;

implementation

uses GlblVars, WinUtils, Utilitys, GlblCnst, PASUtils, Prog, Preview,
     Types, Prcllist, DataAccessUnit;

{$R *.DFM}

const
  TaxNameAddressDLLName = 'TaxNameAddressFunctions.dll';
  TaxBankCodeDLLName = 'TaxBankCodeFunctions.dll';
  BigBuildingNameAddressDLLName = 'BuildingNameAddressFunctions.dll';
  BigBuildingAddNewParcelsDLLName = 'BuildingAddParcelFromPASDLL.dll';
  SmallBuildingNameAddressDLLName = 'SmallBuildingNameAddressFunctions.dll';
  SmallBuildingAddNewParcelsDLLName = 'SmallBuildingAddParcelFromPASDLL.dll';

{========================================================}
Procedure TUpdateNamesAndAddressesInSCASystemsForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TUpdateNamesAndAddressesInSCASystemsForm.InitializeForm;

begin
  UnitName := 'UpdateNamesAndAddressesInSystem';  {mmm}
  OptionsPageControl.ActivePageIndex := 0;

  OpenTablesForForm(Self, NextYear);

    {CHG04182004-1(2.08): Only show the applicable building system.}

  SmallBuildingCheckBox.Visible := False;
  BigBuildingCheckBox.Visible := False;

  case GlblBuildingSystemLinkType of
    bldSmallBuilding : SmallBuildingCheckBox.Visible := True;
    bldLargeBuilding : BigBuildingCheckBox.Visible := True;
  end;

  FillOneListBox(SwisCodeListBox, SwisCodeTable, 'SwisCode',
                 'MunicipalityName', 25, True, True, NextYear, GlblNextYear);

  FillOneListBox(SchoolCodeListBox, SchoolCodeTable, 'SchoolCode',
                 'SchoolName', 25, True, True, NextYear, GlblNextYear);

  Session.GetDatabaseNames(cbxVillagePASSystem.Items);
  
end;  {InitializeForm}

{===================================================================}
Procedure TUpdateNamesAndAddressesInSCASystemsForm.FormKeyPress(    Sender: TObject;
                                                               var Key: Char);

begin
  If (Key = #13)
    then
      begin
        Key := #0;
        Perform(WM_NEXTDLGCTL, 0, 0);
      end;

end;  {FormKeyPress}

{================================================================}
Procedure TUpdateNamesAndAddressesInSCASystemsForm.BuildingCheckBoxClick(Sender: TObject);

begin
  AddNewParcelsCheckBox.Visible := (BigBuildingCheckBox.Checked or SmallBuildingCheckBox.Checked);

  If not AddNewParcelsCheckBox.Visible
    then AddNewParcelsCheckBox.Checked := False;

    {CHG02082004-3(2.08): Allow for legal address update in big building.}

  UpdateLegalAddressesCheckBox.Visible := (BigBuildingCheckBox.Checked or
                                           SmallBuildingCheckBox.Checked or
                                           cbVillagePASSystem.Checked);

  If not UpdateLegalAddressesCheckBox.Visible
    then UpdateLegalAddressesCheckBox.Checked := False;

end;  {BuildingCheckBoxClick}

{================================================================}
Procedure TUpdateNamesAndAddressesInSCASystemsForm.TaxCheckBoxClick(Sender: TObject);

begin
  UpdateBankCodesCheckBox.Visible := TCheckBox(Sender).Checked;

  If not UpdateBankCodesCheckBox.Visible
    then UpdateBankCodesCheckBox.Checked := False;

end;  {TaxCheckBoxClick}

{================================================================}
Procedure TUpdateNamesAndAddressesInSCASystemsForm.cbVillagePASSystemClick(Sender: TObject);

begin
  cbxVillagePASSystem.Visible := cbVillagePASSystem.Checked;
  lbVillagePASSystem.Visible := cbVillagePASSystem.Checked;
  UpdateLegalAddressesCheckBox.Visible := True;
end;

{================================================================}
Procedure TUpdateNamesAndAddressesInSCASystemsForm.StartButtonClick(Sender: TObject);

var
   Quit : Boolean;
   NewFileName : String;
   TempFile : File;
   I : Integer;

begin
  Quit := False;
  ReportCancelled := False;
  TrialRun := TrialRunCheckBox.Checked;
  AddNewParcelsToBuilding := AddNewParcelsCheckBox.Checked;
  UpdateBankCodes := UpdateBankCodesCheckBox.Checked;
  UpdateAllParcels := UpdateAllParcelsCheckBox.Checked;

  bLocateByAccountNumber := cbxLocateByAccountNumber.Checked;

  SelectedSwisCodes := TStringList.Create;
  SelectedSchoolCodes := TStringList.Create;

      {CHG12291999-1: Allow for school \ swis selection.}

      //SelectedSwisCodes.Clear;

  with SwisCodeListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then SelectedSwisCodes.Add(Take(6, Items[I]));

  with SchoolCodeListBox do
    For I := 0 to (Items.Count - 1) do
      If Selected[I]
        then SelectedSchoolCodes.Add(Take(6, Items[I]));

    {CHG02082004-3(2.08): Allow for legal address update in big building.}

  UpdateLegalAddresses := UpdateLegalAddressesCheckBox.Checked;

  CreateParcelList := CreateParcelListCheckBox.Checked;

  If CreateParcelList
    then ParcelListDialog.ClearParcelGrid(True);

    {FXX09301998-1: Disable print button after clicking to avoid clicking twice.}

  StartButton.Enabled := False;
  Application.ProcessMessages;
  Quit := False;

  SystemsToUpdate := [];

  If CurrentSchoolTaxCheckBox.Checked
    then SystemsToUpdate := SystemsToUpdate + [tsSchool];

  If CurrentTownTaxCheckBox.Checked
    then SystemsToUpdate := SystemsToUpdate + [tsTown];

  If CurrentCountyTaxCheckBox.Checked
    then SystemsToUpdate := SystemsToUpdate + [tsCounty];

  If BigBuildingCheckBox.Checked
    then SystemsToUpdate := SystemsToUpdate + [tsBigBuilding];

  If SmallBuildingCheckBox.Checked
    then SystemsToUpdate := SystemsToUpdate + [tsSmallBuilding];

  If cbVillagePASSystem.Checked
  then
  begin
    SystemsToUpdate := SystemsToUpdate + [tsPASVillage];
    sVillageSystemToUpdate := cbxVillagePASSystem.Text;
  end;

  If cbSQLLienSystem.Checked
  then SystemsToUpdate := SystemsToUpdate + [tsSQLLien];

  SetPrintToScreenDefault(PrintDialog);

  If PrintDialog.Execute
    then
      begin
          {CHG10131998-1: Set the printer settings based on what printer they selected
                          only - they no longer need to worry about paper or landscape
                          mode.}

        AssignPrinterSettings(PrintDialog, ReportPrinter, ReportFiler,
                              [ptLaser], False, Quit);

        ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

          {Now print the report.}

        If not (Quit or ReportCancelled)
          then
            begin

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

                      ReportFiler.Execute;

                        {FXX10111999-3: Make sure they know its done.}

                      ProgressDialog.StartPrinting(PrintDialog.PrintToFile);

                      PreviewForm.ShowModal;
                    finally
                      PreviewForm.Free;

                        {Now delete the file.}
                      try
                        AssignFile(TempFile, NewFileName);
                        OldDeleteFile(NewFileName);
                      finally
                        {We don't care if it does not get deleted, so we won't put up an
                         error message.}

                        ChDir(GlblProgramDir);
                      end;

                    end;  {try PreviewForm := ...}

                  end  {If PrintDialog.PrintToFile}
                else ReportPrinter.Execute;

              ResetPrinter(ReportPrinter);

            end;  {If not Quit}

        ProgressDialog.Finish;

          {FXX10111999-3: Tell people that printing is starting and
                          done.}

        DisplayPrintingFinishedMessage(PrintDialog.PrintToFile);

        If CreateParcelList
          then ParcelListDialog.Show;

      end;  {If PrintDialog.Execute}

  StartButton.Enabled := True;

  SelectedSwisCodes.Free;
  SelectedSchoolCodes.Free;

end;  {StartButtonClick}

{==============================================================================}
Procedure TUpdateNamesAndAddressesInSCASystemsForm.ReportHeaderPrint(Sender: TObject);

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
      PrintCenter('Names and Addresses Changed', (PageWidth / 2));
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
      SetTab(2.2, pjCenter, 0.6, 0, BOXLINEBottom, 0);   {System}
      SetTab(3.0, pjCenter, 2.5, 0, BOXLINEBottom, 0);   {Old Addres}
      SetTab(5.7, pjCenter, 2.5, 0, BOXLINEBottom, 0);   {New Address}

      Println(#9 + 'Parcel ID' +
              #9 + 'System' +
              #9 + 'Old Address' +
              #9 + 'New Address');

      ClearTabs;
      SetTab(0.3, pjLeft, 1.8, 0, BOXLINENone, 0);   {Parcel ID}
      SetTab(2.2, pjLeft, 0.6, 0, BOXLINENone, 0);   {System}
      SetTab(3.0, pjLeft, 2.5, 0, BOXLINENone, 0);   {Old Addres}
      SetTab(5.7, pjLeft, 2.5, 0, BOXLINENone, 0);   {New Address}

    end;  {with Sender as TBaseReport do}

end;  {ReportHeaderPrint}

{====================================================================}
Procedure PrintAddressChange(Sender : TObject;
                             SwisSBLKey : String;
                             _System : String;
                             OldNameAddressArray,
                             NewNameAddressArray : NameAddrArray);

var
  I : Integer;

begin
  with Sender as TBaseReport do
    begin
      If (LinesLeft < 10)
        then NewPage;

      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
              #9 + _System +
              #9 + Take(30, OldNameAddressArray[1]) +
              #9 + Take(30, NewNameAddressArray[1]));

      For I := 2 to 6 do
        If ((Deblank(OldNameAddressArray[I]) <> '') or
            (Deblank(NewNameAddressArray[I]) <> ''))
          then Println(#9 + #9 +
                       #9 + Take(30, OldNameAddressArray[I]) +
                       #9 + Take(30, NewNameAddressArray[I]));

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintAddressChange}

{====================================================================}
Procedure PrintBankCodeChange(Sender : TObject;
                              SwisSBLKey : String;
                              _System : String;
                              OldBankCode : String;
                              NewBankCode : String);

begin
  with Sender as TBaseReport do
    begin
      If (LinesLeft < 10)
        then NewPage;

      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
              #9 + _System +
              #9 + 'OLD BANK: ' + OldBankCode +
              #9 + 'NEW BANK: ' + NewBankCode);

    end;  {with Sender as TBaseReport do}

end;  {PrintBankCodeChange}

{====================================================================}
Procedure PrintLegalAddressChange(Sender : TObject;
                                  SwisSBLKey : String;
                                  _System : String;
                                  OldLegalAddress : String;
                                  NewLegalAddress : String);

begin
  with Sender as TBaseReport do
    begin
      If (LinesLeft < 10)
        then NewPage;

      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
              #9 + _System +
              #9 + 'OLD LEGAL: ' + OldLegalAddress +
              #9 + 'NEW LEGAL: ' + NewLegalAddress);

    end;  {with Sender as TBaseReport do}

end;  {PrintLegalAddressChange}

{====================================================================}
Procedure PrintAddedParcel(Sender : TObject;
                           SwisSBLKey : String;
                           _System : String);

begin
  with Sender as TBaseReport do
    begin
      If (LinesLeft < 10)
        then NewPage;

      Println(#9 + ConvertSwisSBLToDashDot(SwisSBLKey) +
              #9 + _System +
              #9 + 'NEW PARCEL');

    end;  {with Sender as TBaseReport do}

end;  {PrintAddedParcel}

{====================================================================}
Procedure AddBankChangeExtractLine(var ExtractFile : TextFile;
                                       SwisSBLKey : String;
                                       SchoolCode : String;
                                       OldBankCode : String;
                                       NewBankCode : String;
                                       OldNameAddressArray : NameAddrArray);

var
  I, J : Integer;
  ZipCode, TempNameAddr : String;
  SpaceFound, ZipCodeFound : Boolean;

begin
  WriteCommaDelimitedLine(ExtractFile,
                          [ConvertSwisSBLToDashDot(SwisSBLKey),
                           SchoolCode,
                           OldBankCode,
                           NewBankCode]);

  ZipCode := '';
  ZipCodeFound := False;

  For I := 6 downto 1 do
    If ((not ZipCodeFound) and
        _Compare(OldNameAddressArray[I], coNotBlank))
      then
        begin
          TempNameAddr := Trim(OldNameAddressArray[I]);
          SpaceFound := False;
          ZipCodeFound := True;

          For J := Length(TempNameAddr) downto 1 do
            If not SpaceFound
              then
                If (TempNameAddr[J] = ' ')
                  then SpaceFound := True
                  else ZipCode := TempNameAddr[J] + ZipCode;

        end;  {If ((not ZipCodeFound) and ...}

  WriteCommaDelimitedLine(ExtractFile, [ZipCode, '']);

  For I := 1 to 6 do
    WriteCommaDelimitedLine(ExtractFile,
                            [OldNameAddressArray[I]]);

  WritelnCommaDelimitedLine(ExtractFile, ['']);

end;  {AddBankChangeExtractLine}


{=============================================================================}
Function RecordinRange(SelectedSwisCodes : TStringList;
                        SelectedSchoolCodes: TStringList;
                        SwisCode: String;
                        SchoolCode: String): Boolean;
begin
  Result := ((SelectedSwisCodes.IndexOf(SwisCode) > -1) and
             (SelectedSchoolCodes.IndexOf(SchoolCode) > -1));

end; {RecordinRange}

{=======================================================================}
Function OpenTable(Table : TTable;
                   _TableName,
                   _IndexName,
                   _DatabaseName : String) : Boolean;

begin
  Result := True;

  with Table do
    try
      TableType := ttDBase;
      DatabaseName := _DatabaseName;
      TableName := _TableName;
      IndexName := _IndexName;
      Open;
    except
      MessageDlg('Error opening table ' + _TableName + ' in Delinquent Tax System.',
                 mtError, [mbOk], 0);
      Result := False;
    end;

end;  {OpenTable}

{================================================================}
Procedure CloseTable(Table : TTable);

begin
  try
    Table.Close;
    Table.Free;
  except
  end;

end;  {CloseTable}

{=============================================================================}
Procedure _AddParcelToBigBuildingSystem(BuildingParcelTable : TTable;
                                        PASParcelTable : TTable;
                                        SwisCode : String;
                                        SBL : String;
                                        AssessmentYear : String;
                                        NameAddressArray : NameAddrArray);

begin
  with BuildingParcelTable do
    try
      Insert;
      FieldByName('Owner').Text := NameAddressArray[1];
      FieldByName('MailAddr1').Text := NameAddressArray[2];
      FieldByName('MailAddr2').Text := NameAddressArray[3];
      FieldByName('MailAddr3').Text := NameAddressArray[4];
      FieldByName('MailAddr4').Text := NameAddressArray[5];
      FieldByName('MailAddr5').Text := NameAddressArray[6];

      FieldByName('SwisCode').Text := SwisCode;
      FieldByName('SBL').Text := SBL;

      FieldByName('LegalAddr').Text := PASParcelTable.FieldByName('LegalAddr').Text;
      FieldByName('LegalAddrNo').Text := PASParcelTable.FieldByName('LegalAddrNo').Text;
      FieldByName('BankCode').Text := PASParcelTable.FieldByName('BankCode').Text;
      FieldByName('Frontage').AsFloat := 0;
      FieldByName('Depth').AsFloat := 0;
      FieldByName('Acreage').AsFloat := 0;

      try
        FieldByName('Frontage').Text := PASParcelTable.FieldByName('Frontage').Text;
      except
        FieldByName('Frontage').AsFloat := 0;
      end;

      try
        FieldByName('Depth').Text := PASParcelTable.FieldByName('Depth').Text;
      except
        FieldByName('Depth').AsFloat := 0;
      end;

      try
        FieldByName('Acreage').Text := PASParcelTable.FieldByName('Acreage').Text;
      except
        FieldByName('Acreage').AsFloat := 0;
      end;

      FieldByName('DeedBook').Text := PASParcelTable.FieldByName('DeedBook').Text;
      FieldByName('DeedPage').Text := PASParcelTable.FieldByName('DeedPage').Text;
      FieldByName('OldSBL').Text := PASParcelTable.FieldByName('RemapOldSBL').Text;
      FieldByName('AccountNo').Text := PASParcelTable.FieldByName('AccountNo').Text;
      FieldByName('LegalAddrInt').Text := PASParcelTable.FieldByName('LegalAddrInt').Text;

      try
        FieldByName('PropertyClass').Text := PASParcelTable.FieldByName('PropertyClassCode').Text;
        FieldByName('SchoolDistrict').Text := PASParcelTable.FieldByName('SchoolCode').Text;
        FieldByName('RollSection').Text := PASParcelTable.FieldByName('RollSection').Text;
      except
      end;

      Post;
    except
      MessageDlg('Error updating name \ address for parcel ' + SBL + '.',
                 mtError, [mbOK], 0)
    end;

end;  {_AddParcelToBigBuildingSystem}

{=============================================================================}
Function _GetSmallBuildingLegalAddress(    tbSmallBuildingParcel : TTable;
                                           SwisCode : String;
                                           SBL : String;
                                       var OldLegalAddressName : String;
                                       var OldLegalAddressNumber : String) : Boolean;

begin
  Result := False;
  OldLegalAddressName := '';
  OldLegalAddressNumber := '';

  If _Locate(tbSmallBuildingParcel, [SwisCode + SBL], '', [])
    then
      begin
        Result := True;
        OldLegalAddressName := tbSmallBuildingParcel.FieldByName('LegalAddr').AsString;
        OldLegalAddressNumber := tbSmallBuildingParcel.FieldByName('LegalAddrNo').AsString;
      end;

end;  {_GetSmallBuildingLegalAddress}

{=============================================================================}
Procedure _SetSmallBuildingLegalAddress(tbSmallBuildingParcel : TTable;
                                        SwisCode : String;
                                        SBL : String;
                                        NewLegalAddressName : String;
                                        NewLegalAddressNumber : String);

begin
  If _Locate(tbSmallBuildingParcel, [SwisCode + SBL], '', [])
    then
      with tbSmallBuildingParcel do
        try
          Edit;
          FieldByName('LegalAddr').AsString := NewLegalAddressName;
          FieldByName('LegalAddrNo').AsString := NewLegalAddressNumber;
          Post;
        except
        end;

end;  {_SetSmallBuildingLegalAddress}

{=============================================================================}
Function _GetSmallBuildingParcelNameAddress(    tbSmallBuildingParcel : TTable;
                                                sSwisCode : String;
                                                sSBL : String;
                                            var OldNameAddressArray : NameAddrArray) : Boolean;

begin
  Result := _Locate(tbSmallBuildingParcel, [sSwisCode + sSBL], '', []);

  If Result
    then
      with tbSmallBuildingParcel do
        begin
          OldNameAddressArray[1] := FieldByName('OwnerName').AsString;
          OldNameAddressArray[2] := FieldByName('OwnerName2').AsString;
          OldNameAddressArray[3] := FieldByName('MailingAddr').AsString;
          OldNameAddressArray[4] := FieldByName('Address2').AsString;
          OldNameAddressArray[5] := FieldByName('Address3').AsString;
          OldNameAddressArray[6] := FieldByName('Address4').AsString;

        end;  {with tb_SmallBuildingParcel do}

end;  {_GetSmallBuildingParcelNameAddress}

{=============================================================================}
Procedure _SetSmallBuildingParcelNameAddress(tbSmallBuildingParcel : TTable;
                                             sSwisCode : String;
                                             sSBL : String;
                                             NewNameAddressArray : NameAddrArray);

begin
  If _Locate(tbSmallBuildingParcel, [sSwisCode + sSBL], '', [])
    then
      with tbSmallBuildingParcel do
        try
          Edit;
          FieldByName('OwnerName').AsString := NewNameAddressArray[1];
          FieldByName('OwnerName2').AsString := NewNameAddressArray[2];
          FieldByName('MailingAddr').AsString := NewNameAddressArray[3];
          FieldByName('Address2').AsString := NewNameAddressArray[4];
          FieldByName('Address3').AsString := NewNameAddressArray[5];
          FieldByName('Address4').AsString := NewNameAddressArray[6];
          Post;
        except
        end;

end;  {_SetSmallBuildingParcelNameAddress}

{=============================================================================}
Function _ParcelExistsInBigBuildingSystem(tb_BigBuildingParcel : TTable;
                                          sSwisCode : String;
                                          sSBL : String) : Boolean;

begin
  Result := _Locate(tb_BigBuildingParcel, [sSwisCode, sSBL], '', []);
end;  {_ParcelExistsInBigBuildingSystem}

{=============================================================================}
Function _GetBigBuildingParcelNameAddress(    tb_BigBuildingParcel : TTable;
                                              sSwisCode : String;
                                              sSBL : String;
                                          var OldNameAddressArray : NameAddrArray) : Boolean;

begin
  Result := _Locate(tb_BigBuildingParcel, [sSwisCode, sSBL], '', []);

  If Result
    then
      with tb_BigBuildingParcel do
        begin
          OldNameAddressArray[1] := FieldByName('Owner').AsString;
          OldNameAddressArray[2] := FieldByName('MailAddr1').AsString;
          OldNameAddressArray[3] := FieldByName('MailAddr2').AsString;
          OldNameAddressArray[4] := FieldByName('MailAddr3').AsString;
          OldNameAddressArray[5] := FieldByName('MailAddr4').AsString;
          OldNameAddressArray[6] := FieldByName('MailAddr5').AsString;

        end;  {with tb_BigBuildingParcel do}

end;  {_GetBigBuildingParcelNameAddress}

{=============================================================================}
Procedure _SetBigBuildingParcelNameAddress(tb_BigBuildingParcel : TTable;
                                           sSwisCode : String;
                                           sSBL : String;
                                           NewNameAddressArray : NameAddrArray);

begin
  If _Locate(tb_BigBuildingParcel, [sSwisCode, sSBL], '', [])
    then
      with tb_BigBuildingParcel do
        try
          Edit;
          FieldByName('Owner').AsString := NewNameAddressArray[1];
          FieldByName('MailAddr1').AsString := NewNameAddressArray[2];
          FieldByName('MailAddr2').AsString := NewNameAddressArray[3];
          FieldByName('MailAddr3').AsString := NewNameAddressArray[4];
          FieldByName('MailAddr4').AsString := NewNameAddressArray[5];
          FieldByName('MailAddr5').AsString := NewNameAddressArray[6];
          Post;
        except
        end;

end;  {_SetBigBuildingParcelNameAddress}

{=============================================================================}
Function _GetBigBuildingLegalAddress(    tb_BigBuildingParcel : TTable;
                                         sSwisCode : String;
                                         sSBL : String;
                                     var sLegalAddressName : String;
                                     var sLegalAddressNumber : String) : Boolean;

begin
  Result := True;

  If _ParcelExistsInBigBuildingSystem(tb_BigBuildingParcel, sSwisCode, sSBL)
    then
      begin
        sLegalAddressName := tb_BigBuildingParcel.FieldByName('LegalAddr').AsString;
        sLegalAddressNumber := tb_BigBuildingParcel.FieldByName('LegalAddrNo').AsString;
      end  {If _ParcelExistsInBigBuildingSystem(tb_BigBuildingParcel, sSwisCode, sSBL)}
    else Result := False;

end;  {_GetBigBuildingLegalAddress}

{=============================================================================}
Function _SetBigBuildingLegalAddress(tb_BigBuildingParcel : TTable;
                                     sSwisCode : String;
                                     sSBL : String;
                                     sLegalAddressName : String;
                                     sLegalAddressNumber : String) : Boolean;

begin
  Result := True;

  If _ParcelExistsInBigBuildingSystem(tb_BigBuildingParcel, sSwisCode, sSBL)
    then
      begin
        with tb_BigBuildingParcel do
          try
            Edit;
            FieldByName('LegalAddr').AsString := sLegalAddressName;
            FieldByName('LegalAddrNo').AsString := sLegalAddressNumber;
            Post;
          except
          end;

      end  {If _ParcelExistsInBigBuildingSystem(tb_BigBuildingParcel, sSwisCode, sSBL)}
    else Result := False;

end;  {_SetBigBuildingLegalAddress}

{=============================================================================}
{ VILLAGE }
{=============================================================================}
Function _GetPASVillageLegalAddress(    tbVillageParcels : TTable;
                                        sAssessmentYear : String;
                                        SwisCode : String;
                                        SBL : String;
                                        bLocateByAccountNumber : Boolean;
                                        sAccountNumber : String;
                                    var OldLegalAddressName : String;
                                    var OldLegalAddressNumber : String) : Boolean;

begin
  Result := False;
  OldLegalAddressName := '';
  OldLegalAddressNumber := '';

  If ((bLocateByAccountNumber and
       _Locate(tbVillageParcels, [sAccountNumber], '', [])) or
      _Locate(tbVillageParcels, [SwisCode + SBL], '', []))
    then
      begin
        Result := True;
        OldLegalAddressName := tbVillageParcels.FieldByName('LegalAddr').AsString;
        OldLegalAddressNumber := tbVillageParcels.FieldByName('LegalAddrNo').AsString;
      end;

end;  {_GetPASVillageLegalAddress}

{=============================================================================}
Procedure _SetPASVillageLegalAddress(tbVillageParcels : TTable;
                                     sAssessmentYear : String;
                                     SwisCode : String;
                                     SBL : String;
                                     bLocateByAccountNumber : Boolean;
                                     sAccountNumber : String;
                                     NewLegalAddressName : String;
                                     NewLegalAddressNumber : String);

begin
  If ((bLocateByAccountNumber and
       _Locate(tbVillageParcels, [sAccountNumber], '', [])) or
      _Locate(tbVillageParcels, [SwisCode + SBL], '', []))
    then
      with tbVillageParcels do
        try
          Edit;
          FieldByName('LegalAddr').AsString := NewLegalAddressName;
          FieldByName('LegalAddrNo').AsString := NewLegalAddressNumber;
          //FieldByName('LegalAddrInt').Text := PASParcelTable.FieldByName('LegalAddrInt').Text;
          Post;
        except
        end;

end;  {_SetPASVillageLegalAddress}

{=============================================================================}
Function _GetPASVillageParcelNameAddress(    tbVillageParcels : TTable;
                                             sAssessmentYear : String;
                                             sSwisCode : String;
                                             sSBL : String;
                                             bLocateByAccountNumber : Boolean;
                                             sAccountNumber : String;
                                         var OldNameAddressArray : NameAddrArray) : Boolean;

begin
  sAssessmentYear := tbVillageParcels.FieldByName('TaxRollYr').AsString;

  Result := ((bLocateByAccountNumber and
              _Locate(tbVillageParcels, [sAccountNumber], '', [])) or
             _Locate(tbVillageParcels, [sSwisCode + sSBL], '', []));

  If Result
    then GetNameAddress(tbVillageParcels, OldNameAddressArray);

end;  {_GetPASVillageParcelNameAddress}

{=============================================================================}
Procedure _SetPASVillageParcelNameAddress(tbVillageParcels : TTable;
                                          tbTownParcels : TTable;
                                          sAssessmentYear : String;
                                          sSwisCode : String;
                                          sSBL : String;
                                          bLocateByAccountNumber : Boolean;
                                          sAccountNumber : String;
                                          NewNameAddressArray : NameAddrArray);

begin
  sAssessmentYear := tbVillageParcels.FieldByName('TaxRollYr').AsString;
  If ((bLocateByAccountNumber and
       _Locate(tbVillageParcels, [sAccountNumber], '', [])) or
      _Locate(tbVillageParcels, [sSwisCode + sSBL], '', []))
    then
      with tbVillageParcels do
        try
          Edit;
          FieldByName('Name1').AsString := tbTownParcels.FieldByName('Name1').AsString;
          FieldByName('Name2').AsString := tbTownParcels.FieldByName('Name2').AsString;
          FieldByName('Address1').AsString := tbTownParcels.FieldByName('Address1').AsString;
          FieldByName('Address2').AsString := tbTownParcels.FieldByName('Address2').AsString;
          FieldByName('Street').AsString := tbTownParcels.FieldByName('Street').AsString;
          FieldByName('City').AsString := tbTownParcels.FieldByName('City').AsString;
          FieldByName('State').AsString := tbTownParcels.FieldByName('State').AsString;
          FieldByName('Zip').AsString := tbTownParcels.FieldByName('Zip').AsString;
          FieldByName('ZipPlus4').AsString := tbTownParcels.FieldByName('ZipPlus4').AsString;
          Post;
        except
        end;

end;  {_SetPASVillageParcelNameAddress}

{=============================================================================}
Function _ParcelExistsInPASVillageSystem(tbVillageParcels : TTable;
                                      sAssessmentYear : String;
                                      sSwisCode : String;
                                      sSBL : String;
                                      bLocateByAccountNumber : Boolean;
                                      sAccountNumber : String) : Boolean;

begin
  sAssessmentYear := tbVillageParcels.FieldByName('TaxRollYr').AsString;

  Result := ((bLocateByAccountNumber and
              _Locate(tbVillageParcels, [sAccountNumber], '', [])) or
             _Locate(tbVillageParcels, [sAssessmentYear, sSwisCode + sSBL], '', [loParseSwisSBLKey]));

end;  {_ParcelExistsInPASVillageSystem}


{=============================================================================}
Function _GetParcelNameAddress(    tbTaxParcel : TTable;
                                   sSchoolCode : String;
                                   sSwisCode : String;
                                   sSBL : String;
                               var OldNameAddressArray : NameAddrArray) : Boolean; overload;

begin
  Result := _Locate(tbTaxParcel, [sSchoolCode, sSwisCode, sSBL], '', []);

  If Result
    then
      with tbTaxParcel do
        begin
          OldNameAddressArray[1] := FieldByName('Name1').AsString;
          OldNameAddressArray[2] := FieldByName('Name2').AsString;
          OldNameAddressArray[3] := FieldByName('Address1').AsString;
          OldNameAddressArray[4] := FieldByName('Address2').AsString;
          OldNameAddressArray[5] := FieldByName('Address3').AsString;
          OldNameAddressArray[6] := FieldByName('Address4').AsString;

        end;  {with tbTaxParcel do}

end;  {_GetParcelNameAddress}

{=============================================================================}
Procedure _SetParcelNameAddress(tbTaxParcel : TTable;
                                sSchoolCode : String;
                                sSwisCode : String;
                                sSBL : String;
                                NewNameAddressArray : NameAddrArray); overload;

begin
  If _Locate(tbTaxParcel, [sSchoolCode, sSwisCode, sSBL], '', [])
    then
      with tbTaxParcel do
        try
          Edit;
          FieldByName('Name1').AsString := NewNameAddressArray[1];
          FieldByName('Name2').AsString := NewNameAddressArray[2];
          FieldByName('Address1').AsString := NewNameAddressArray[3];
          FieldByName('Address2').AsString := NewNameAddressArray[4];
          FieldByName('Address3').AsString := NewNameAddressArray[5];
          FieldByName('Address4').AsString := NewNameAddressArray[6];
          Post;
        except
        end;

end;  {_SetParcelNameAddress}

{=============================================================================}
Function _GetBankCode(    tbTaxParcel : TTable;
                          SchoolCode : String;
                          SwisCode : String;
                          SBL : String;
                      var OldBankCode : String) : Boolean; overload;

begin
  Result := _Locate(tbTaxParcel, [SchoolCode, SwisCode, SBL], '', []);
  If Result
  then OldBankCode := tbTaxParcel.FieldByName('BankCode').AsString;
end;

{=============================================================================}
Procedure _SetBankCode(tbTaxParcel : TTable;
                       NewBankCode : String); overload;

begin
  with tbTaxParcel do
  try
    Edit;
    FieldByName('BankCode').Text := NewBankCode;
    Post;
  except
    SystemSupport(010, tbTaxParcel, 'Error updating bank code for town tax parcel table.',
                  'UpdateNamesAndAddressesInSCASystems', GlblErrorDlgBox);
 end;

end;  {_SetBankCode}

{=============================================================================}
{SQL TAX}
{=============================================================================}
Function _GetParcelNameAddress(    qryTax : TADOQuery;
                                   sSchoolCode : String;
                                   sSwisCode : String;
                                   sSBL : String;
                                   iCollectionID : Integer;
                               var OldNameAddressArray : NameAddrArray) : Boolean; overload;

begin
  Result := False;

  _ADOQuery(qryTax,
            ['Select Name1, Name2, Address1, Address2, Address3, Address4 from ParcelYearMasterFile',
             'where (SwisCode = ' + FormatSQLString(sSwisCode) + ') and ',
             '(SchoolKeyCode = ' + FormatSQLString(sSchoolCode) + ') and ',
             '(SBL = ' + FormatSQLString(sSBL) + ') and ',
             '(Collection_id = ' + IntToStr(iCollectionID) + ')']);

  If _Compare(qryTax.RecordCount, 0, coGreaterThan)
  then
    with qryTax do
    begin
      Result := True;
      OldNameAddressArray[1] := FieldByName('Name1').AsString;
      OldNameAddressArray[2] := FieldByName('Name2').AsString;
      OldNameAddressArray[3] := FieldByName('Address1').AsString;
      OldNameAddressArray[4] := FieldByName('Address2').AsString;
      OldNameAddressArray[5] := FieldByName('Address3').AsString;
      OldNameAddressArray[6] := FieldByName('Address4').AsString;

    end;  {with qryTax do}

end;  {_GetParcelNameAddress}

{=============================================================================}
Procedure _SetParcelNameAddress(qryTax : TADOQuery;
                                sSchoolCode : String;
                                sSwisCode : String;
                                sSBL : String;
                                iCollectionID : Integer;
                                NewNameAddressArray : NameAddrArray); overload;

begin
  _ADOQueryExec(qryTax,
                ['Update ParcelYearMasterFile',
                 'Set Name1 = ' + FormatSQLString(NewNameAddressArray[1]) + ',',
                 '    Name2 = ' + FormatSQLString(NewNameAddressArray[2]) + ',',
                 '    Address1 = ' + FormatSQLString(NewNameAddressArray[3]) + ',',
                 '    Address2 = ' + FormatSQLString(NewNameAddressArray[4]) + ',',
                 '    Address3 = ' + FormatSQLString(NewNameAddressArray[5]) + ',',
                 '    Address4 = ' + FormatSQLString(NewNameAddressArray[6]),
                 'where (SwisCode = ' + FormatSQLString(sSwisCode) + ') and ',
                 '(SchoolKeyCode = ' + FormatSQLString(sSchoolCode) + ') and ',
                 '(SBL = ' + FormatSQLString(sSBL) + ') and ',
                 '(Collection_id = ' + IntToStr(iCollectionID) + ')']);

end;  {_SetParcelNameAddress}

{=============================================================================}
Function _GetBankCode(    qryTax : TADOQuery;
                          sSchoolCode : String;
                          sSwisCode : String;
                          sSBL : String;
                          iCollectionID : Integer;
                      var OldBankCode : String) : Boolean; overload;

begin
  Result := False;

  _ADOQuery(qryTax,
            ['Select BankCode from ParcelYearMasterFile',
             'where (SwisCode = ' + FormatSQLString(sSwisCode) + ') and ',
             '(SchoolKeyCode = ' + FormatSQLString(sSchoolCode) + ') and ',
             '(SBL = ' + FormatSQLString(sSBL) + ') and ',
             '(Collection_id = ' + IntToStr(iCollectionID) + ')']);

  If _Compare(qryTax.RecordCount, 0, coGreaterThan)
  then
    with qryTax do
    begin
      Result := True;
      OldBankCode := FieldByName('BankCode').AsString;

    end;  {with qryTax do}

end;  {_GetBankCode}

{=============================================================================}
Procedure _SetBankCode(qryTax : TADOQuery;
                       sSchoolCode : String;
                       sSwisCode : String;
                       sSBL : String;
                       iCollectionID : Integer;
                       NewBankCode : String); overload;

begin
  _ADOQueryExec(qryTax,
                ['Update ParcelYearMasterFile',
                 'Set BankCode = ' + FormatSQLString(NewBankCode),
                 'where (SwisCode = ' + FormatSQLString(sSwisCode) + ') and ',
                 '(SchoolKeyCode = ' + FormatSQLString(sSchoolCode) + ') and ',
                 '(SBL = ' + FormatSQLString(sSBL) + ') and ',
                 '(Collection_id = ' + IntToStr(iCollectionID) + ')']);

end;  {_SetBankCode}

{=============================================================================}
{SQL Lien}
{=============================================================================}
Function _GetLienParcelNameAddress(    qryLien : TADOQuery;
                                       sSchoolCode : String;
                                       sSwisCode : String;
                                       sSBL : String;
                                   var OldNameAddressArray : NameAddrArray) : Boolean;

begin
  Result := False;

  _ADOQuery(qryLien,
            ['Select Name1, Name2, Address1, Address2, Street, City, State, Zip, ZipPlus4 from ParcelTable',
             'where (SwisCode = ' + FormatSQLString(sSwisCode) + ') and ',
             '(SchoolCode = ' + FormatSQLString(sSchoolCode) + ') and ',
             '(SBLKey = ' + FormatSQLString(sSBL) + ')']);

  If _Compare(qryLien.RecordCount, 0, coGreaterThan)
  then
    with qryLien do
    begin
      Result := True;
      FillInNameAddrArray(FieldByName('Name1').AsString,
                          FieldByName('Name2').AsString,
                          FieldByName('Address1').AsString,
                          FieldByName('Address2').AsString,
                          FieldByName('Street').AsString,
                          FieldByName('City').AsString,
                          FieldByName('State').AsString,
                          FieldByName('Zip').AsString,
                          FieldByName('ZipPlus4').AsString,
                          True, False, OldNameAddressArray);

    end;  {with qryLien do}

end;  {_GetLienParcelNameAddress}

{=============================================================================}
Procedure _SetLienParcelNameAddress(qryLien : TADOQuery;
                                    qryLien2 : TADOQuery;
                                    sSchoolCode : String;
                                    sSwisCode : String;
                                    sSBL : String;
                                    sName1 : String;
                                    sName2 : String;
                                    sAddress1 : String;
                                    sAddress2 : String;
                                    sStreet : String;
                                    sCity : String;
                                    sState : String;
                                    sZip : String;
                                    sZipPlus4 : String);

var
  sTaxYear : String;
  Year, Month, Day : Word;

begin
  DecodeDate(Date, Year, Month, Day);
  sTaxYear := IntToStr(Year);

     {Insert the current name / address in to the audit table.}

  with qryLien do
    _ADOQueryExec(qryLien2,
                  ['Insert into ParcelNameAddrTable ',
                   '(SwisSBLKey, TaxYear, Date, Name1, Name2, Address1, Address2, Street, City, State, Zip, ZipPlus4, UserID)',
                   'VALUES (' +
                   FormatSQLString(sSwisCode + sSBL) + ',',
                   FormatSQLString(sTaxYear) + ',',
                   FormatSQLString(DateToStr(Date)) + ',',
                   FormatSQLString(FieldByName('Name1').AsString) + ',',
                   FormatSQLString(FieldByName('Name2').AsString) + ',',
                   FormatSQLString(FieldByName('Address1').AsString) + ',',
                   FormatSQLString(FieldByName('Address2').AsString) + ',',
                   FormatSQLString(FieldByName('Street').AsString) + ',',
                   FormatSQLString(FieldByName('City').AsString) + ',',
                   FormatSQLString(FieldByName('State').AsString) + ',',
                   FormatSQLString(FieldByName('Zip').AsString) + ',',
                   FormatSQLString(FieldByName('ZipPlus4').AsString) + ',',
                   FormatSQLString(glblUserName) + ')']);

  _ADOQueryExec(qryLien2,
                ['Update ParcelTable',
                 'Set Name1 = ' + FormatSQLString(sName1) + ',',
                 '    Name2 = ' + FormatSQLString(sName2) + ',',
                 '    Address1 = ' + FormatSQLString(sAddress1) + ',',
                 '    Address2 = ' + FormatSQLString(sAddress2) + ',',
                 '    Street = ' + FormatSQLString(sStreet) + ',',
                 '    City = ' + FormatSQLString(sCity) + ',',
                 '    State = ' + FormatSQLString(sState) + ',',
                 '    Zip = ' + FormatSQLString(sZip) + ',',
                 '    ZipPlus4 = ' + FormatSQLString(sZipPlus4),
                 'where (SwisCode = ' + FormatSQLString(sSwisCode) + ') and ',
                 '(SchoolCode = ' + FormatSQLString(sSchoolCode) + ') and ',
                 '(SBLKey = ' + FormatSQLString(sSBL) + ')']);

end;  {_SetLienParcelNameAddress}

{=============================================================================}
Procedure TUpdateNamesAndAddressesInSCASystemsForm.ReportPrint(Sender: TObject);

var
  Done, FirstTimeThrough, Quit,
  ParcelHasLien, ParcelHasSchool, ParcelHasSQLLien,
  ParcelHasTown, ParcelHasCounty, ParcelHasPASVillage,
  ParcelHasBigBuilding, ParcelHasSmallBuilding, ExtractToExcel : Boolean;

  SwisSBLKey, SwisCode, SBL, sAccountNumber,
  OldLegalAddress, NewLegalAddress,
  OldLegalAddressNumber, OldLegalAddressName,
  NewLegalAddressNumber, NewLegalAddressName,
  _Systems, SchoolCode, NewBankCode, OldBankCode,
  OldNameAddressString, TaxBankCodeDLLLocation,
  TaxNameAddressDLLLocation, BigBuildingNameAddressDLLLocation,
  BigBuildingAddNewParcelsDLLLocation,
  SmallBuildingNameAddressDLLLocation,
  SmallBuildingAddNewParcelsDLLLocation : String;

  I, Index, TempLen,
  iCurrentTownCollectionID,
  iCurrentSchoolCollectionID, iCurrentCountyCollectionID : Integer;
  TempPChar : PChar;

  TaxNameAddressDLLHandle, BigBuildingNameAddressDLLHandle,
  TaxBankCodeDLLHandle, BigBuildingAddNewParcelsDLLHandle,
  SmallBuildingNameAddressDLLHandle, SmallBuildingAddNewParcelsDLLHandle : THandle;

  GetParcelNameAddress : TGetParcelNameAddressFunction;
  SetParcelNameAddress : TSetParcelNameAddressProcedure;
  GetParcelBankCode : TGetParcelBankCodeFunction;
  SetParcelBankCode : TSetParcelBankCodeProcedure;

(*  GetBigBuildingParcelNameAddress : TGetParcelNameAddressBuildingFunction;
  SetBigBuildingParcelNameAddress : TSetParcelNameAddressBuildingProcedure;
  GetBigBuildingLegalAddress : TGetLegalAddressBuildingFunction;
  SetBigBuildingLegalAddress : TSetLegalAddressBuildingProcedure;
  ParcelExistsInBuildingSystem : TParcelExistsInBuildingSystemFuncion;
  AddParcelToBuildingSystem : TAddParcelToBuildingSystemProcedure; *)

  GetSmallBuildingParcelNameAddress : TGetParcelNameAddressBuildingFunction;
  SetSmallBuildingParcelNameAddress : TSetParcelNameAddressBuildingProcedure;
  GetSmallBuildingLegalAddress : TGetLegalAddressBuildingFunction;
  SetSmallBuildingLegalAddress : TSetLegalAddressBuildingProcedure;
  ParcelExistsInSmallBuildingSystem : TParcelExistsInBuildingSystemFuncion;
  AddParcelToSmallBuildingSystem : TAddParcelToBuildingSystemProcedure;

  CloseTaxNameAddressDLL,
  CloseTaxBankCodeDLL,
  CloseBigBuildingNameAddressDLL,
  CloseBigBuildingAddNewParcelsDLL,
  CloseSmallBuildingNameAddressDLL,
  CloseSmallBuildingAddNewParcelsDLL,
  InitializeBigBuildingNameAddressDLL,
  InitializeBigBuildingAddNewParcelsDLL,
  InitializeSmallBuildingNameAddressDLL,
  InitializeSmallBuildingAddNewParcelsDLL : TGeneralDLLFunction;

  InitializeTaxBankCodeDLL,
  InitializeTaxNameAddressDLL : TInitializeTaxNameAddressDLLFunction;

  NumChanged, TotalSchool,
  NumParcelsAddedToBigBuilding,
  NumParcelsAddedToSmallBuilding,
  TotalTown, TotalCounty,
  TotalBigBuilding, TotalSmallBuilding, TotalPASVillage,
  TotalTownBankCodeChanges, TotalCountyBankCodeChanges,
  TotalSchoolBankCodeChanges, TotalSQLLien : LongInt;
  OldNameAddressArray, NewNameAddressArray : NameAddrArray;
  NewParcelList : TStringList;

  ExtractBankCodesRemoved,
  ExtractBankCodesChanged,
  ExtractBankCodesAdded : TextFile;
  ExtractBankCodesRemovedFileName,
  ExtractBankCodesAddedFileName,
  ExtractBankCodesChangedFileName : String;

  tb_BigBuildingParcel : TTable;
  qryTax, qryTax2, qryLien, qryLien2 : TADOQuery;
  adoConnection, adoConnection_Lien : TADOConnection;

begin
  If glblUsesSQLTax
  then
  try
    adoConnection := TADOConnection.Create(nil);
    adoConnection.ConnectionString := 'FILE NAME=' + GlblProgramDir + 'LocalTax.udl';
    adoConnection.LoginPrompt := False;
    adoConnection.Connected := True;
    qryTax := TADOQuery.Create(nil);
    qryTax.Connection := adoConnection;
    qryTax2 := TADOQuery.Create(nil);
    qryTax2.Connection := adoConnection;

    _ADOQuery(qryTax,
              ['Select * from CollectionsAvailableTable',
               'where (CollectionType in (' + FormatSQLString('TO') + ',' + FormatSQLString('CI') + ',' + FormatSQLString('VI') + '))',
               'order by TaxYear desc']);
    qryTax.First;
    If _Compare(qryTax.RecordCount, 0, coEqual)
    then iCurrentTownCollectionID := 0
    else iCurrentTownCollectionID := qryTax.FieldByName('Collection_ID').AsInteger;

    _ADOQuery(qryTax,
              ['Select * from CollectionsAvailableTable',
               'where (CollectionType = ' + FormatSQLString('SC') + ')',
               'order by TaxYear desc']);
    qryTax.First;
    If _Compare(qryTax.RecordCount, 0, coEqual)
    then iCurrentSchoolCollectionID := 0
    else iCurrentSchoolCollectionID := qryTax.FieldByName('Collection_ID').AsInteger;

    _ADOQuery(qryTax,
              ['Select * from CollectionsAvailableTable',
               'where (CollectionType = ' + FormatSQLString('CO') + ')',
               'order by TaxYear desc']);
    qryTax.First;
    If _Compare(qryTax.RecordCount, 0, coEqual)
    then iCurrentCountyCollectionID := 0
    else iCurrentCountyCollectionID := qryTax.FieldByName('Collection_ID').AsInteger;

  except
    MessageDlg('Error connecting to SQL tax database.  .  UDL should be ' + GlblProgramDir + 'LocalTax.udl',
               mtError, [mbOK], 0);
  end;

  If (tsSQLLien in SystemsToUpdate)
  then
  try
    adoConnection_Lien := TADOConnection.Create(nil);
    adoConnection_Lien.ConnectionString := 'FILE NAME=' + GlblProgramDir + 'Lien.udl';
    adoConnection_Lien.LoginPrompt := False;
    adoConnection_Lien.Connected := True;
    qryLien := TADOQuery.Create(nil);
    qryLien.Connection := adoConnection_Lien;
    qryLien2 := TADOQuery.Create(nil);
    qryLien2.Connection := adoConnection_Lien;
  except
    MessageDlg('Error connecting to SQL lien database.  UDL should be ' + GlblProgramDir + 'Lien.udl.',
               mtError, [mbOK], 0);
  end;

  BigBuildingNameAddressDLLHandle := 0;
  TaxNameAddressDLLHandle := 0;
  SmallBuildingNameAddressDLLHandle := 0;
  BigBuildingAddNewParcelsDLLHandle := 0;
  GetParcelNameAddress := nil;
  tb_BigBuildingParcel := nil;

  Quit := False;
  Done := False;
  FirstTimeThrough := True;
  NewParcelList := TStringList.Create;
  (*ExtractToExcel := ExtractToExcelCheckBox.Checked;

  If ExtractToExcel
    then
      begin
        ExtractBankCodesRemovedFileName := '\temp\ramapo\BankCodesRemoved.txt';
        AssignFile(ExtractBankCodesRemoved, ExtractBankCodesRemovedFileName);
        Rewrite(ExtractBankCodesRemoved);

        ExtractBankCodesAddedFileName := '\temp\ramapo\BankCodesAdded.txt';
        AssignFile(ExtractBankCodesAdded, ExtractBankCodesAddedFileName);
        Rewrite(ExtractBankCodesAdded);

        ExtractBankCodesChangedFileName := '\temp\ramapo\BankCodesChanged.txt';
        AssignFile(ExtractBankCodesChanged, ExtractBankCodesChangedFileName);
        Rewrite(ExtractBankCodesChanged);

        WritelnCommaDelimitedLine(ExtractBankCodesRemoved,
                                  ['Parcel ID',
                                   'School code',
                                   'Tax Bank',
                                   'PAS Bank',
                                   'Zip Code',
                                   'Zip + 4',
                                   'Name \ Addr 1',
                                   'Name \ Addr 2',
                                   'Name \ Addr 3',
                                   'Name \ Addr 4',
                                   'Name \ Addr 5',
                                   'Name \ Addr 6']);

        WritelnCommaDelimitedLine(ExtractBankCodesAdded,
                                  ['Parcel ID',
                                   'School code',
                                   'Tax Bank',
                                   'PAS Bank',
                                   'Zip Code',
                                   'Zip + 4',
                                   'Name \ Addr 1',
                                   'Name \ Addr 2',
                                   'Name \ Addr 3',
                                   'Name \ Addr 4',
                                   'Name \ Addr 5',
                                   'Name \ Addr 6']);

        WritelnCommaDelimitedLine(ExtractBankCodesChanged,
                                  ['Parcel ID',
                                   'School code',
                                   'Tax Bank',
                                   'PAS Bank',
                                   'Zip Code',
                                   'Zip + 4',
                                   'Name \ Addr 1',
                                   'Name \ Addr 2',
                                   'Name \ Addr 3',
                                   'Name \ Addr 4',
                                   'Name \ Addr 5',
                                   'Name \ Addr 6']);

      end;  {If ExtractToExcel} *)

  NumChanged := 0;
  TotalSchool := 0;
  TotalTown := 0;
  TotalCounty := 0;
  TotalBigBuilding := 0;
  TotalPASVillage := 0;
  TotalSQLLien := 0;
  NumParcelsAddedToBigBuilding := 0;
  NumParcelsAddedToSmallBuilding := 0;
  ExtractToExcel := False;

  TotalTownBankCodeChanges := 0;
  TotalCountyBankCodeChanges := 0;
  TotalSchoolBankCodeChanges := 0;

  _Systems := '';

  If (tsPASVillage in SystemsToUpdate)
  then
  begin
    _OpenTable(tbPASVillageParcels, ParcelTableName, sVillageSystemToUpdate, '', NextYear, []);
    _OpenTable(tbTYPASVillageParcels, ParcelTableName, sVillageSystemToUpdate, '', ThisYear, []);

    If bLocateByAccountNumber
    then tbPASVillageParcels.IndexName := 'BYACCOUNTNO'
    else tbPASVillageParcels.IndexName := 'BYSWISSBLKEY';

  end;

  If ((tsSchool in SystemsToUpdate) or
      (tsTown in SystemsToUpdate) or
      (tsCounty in SystemsToUpdate))
    then
      begin
(*        TaxNameAddressDLLLocation := GlblProgramDir;

        Index := Pos('PAS32\', TaxNameAddressDLLLocation);
        If (Index > 0)
          then Delete(TaxNameAddressDLLLocation, Index, 255);
        TaxNameAddressDLLLocation := TaxNameAddressDLLLocation + 'SCATAX32\' +
                                     TaxNameAddressDLLName;

          {FXX08182003-1: If the DLL is not in the same root directory structure, just put
                          it in the PAS32 folder.}

        If (not FileExists(TaxNameAddressDLLLocation))
          then TaxNameAddressDLLLocation := GlblProgramDir + TaxNameAddressDLLName;

        TempLen := Length(TaxNameAddressDLLLocation);
        TempPChar := StrAlloc(TempLen + 1);
        StrPCopy(TempPChar, TaxNameAddressDLLLocation);

        TaxNameAddressDLLHandle := LoadLibrary(TempPChar);

        If (TaxNameAddressDLLHandle = 0)
          then Quit := True
          else
            begin
              @InitializeTaxNameAddressDLL := GetProcAddress(TaxNameAddressDLLHandle, 'InitializeDLL');
              @GetParcelNameAddress := GetProcAddress(TaxNameAddressDLLHandle, 'GetParcelNameAddress');
              @SetParcelNameAddress := GetProcAddress(TaxNameAddressDLLHandle, 'SetParcelNameAddress');
              @CloseTaxNameAddressDLL := GetProcAddress(TaxNameAddressDLLHandle, 'CloseDLL');

              If (tsSchool in SystemsToUpdate)
                then _Systems := _Systems + 'SCHOOL';

              If (tsTown in SystemsToUpdate)
                then _Systems := _Systems + 'TOWN';

              If (tsCounty in SystemsToUpdate)
                then _Systems := _Systems + 'COUNTY';

              If (@InitializeTaxNameAddressDLL = nil)
                then Quit := True
                else InitializeTaxNameAddressDLL(Application, _Systems);

            end;  {else of If (TaxNameAddressDLLHandle = 0)} *)

          {CHG08072003-1(2.07h) : Allow for bank code updates.}
          {FXX07252008-1(2.14.1.5): The tables were only being set if the UpdateBankCodes option was used.}

(*        If UpdateBankCodes
          then
            begin *)
          If not glblUsesSQLTax
          then
          begin
            If (tsTown in SystemsToUpdate)
              then
                try
                  tbTownTaxParcel.TableName := 'parcelyearmasterfile';
                  tbTownTaxParcel.Open;
                except
                  SystemSupport(006, tbTownTaxParcel, 'Error opening town tax parcel table.',
                                UnitName, GlblErrorDlgBox);
                end;

            If (tsSchool in SystemsToUpdate)
              then
                try
                  tbSchoolTaxParcel.TableName := 'parcelyearmasterfile';
                  tbSchoolTaxParcel.Open;
                except
                  SystemSupport(007, tbSchoolTaxParcel, 'Error opening School tax parcel table.',
                                UnitName, GlblErrorDlgBox);
                end;

            If (tsCounty in SystemsToUpdate)
              then
                try
                  tbCountyTaxParcel.TableName := 'parcelyearmasterfile';
                  tbCountyTaxParcel.Open;
                except
                  SystemSupport(008, tbCountyTaxParcel, 'Error opening County tax parcel table.',
                                UnitName, GlblErrorDlgBox);
                end;

          end;  {If not glblUsesSQLTax}

(*              TaxBankCodeDLLLocation := GlblProgramDir;

              Index := Pos('PAS32\', TaxBankCodeDLLLocation);
              If (Index > 0)
                then Delete(TaxBankCodeDLLLocation, Index, 255);
              TaxBankCodeDLLLocation := TaxBankCodeDLLLocation + 'SCATAX32\' +
                                        TaxBankCodeDLLName;

              TempLen := Length(TaxBankCodeDLLLocation);
              TempPChar := StrAlloc(TempLen + 1);
              StrPCopy(TempPChar, TaxBankCodeDLLLocation);

              TaxBankCodeDLLHandle := LoadLibrary(TempPChar);

              If (TaxBankCodeDLLHandle = 0)
                then Quit := True
                else
                  begin
                    @InitializeTaxBankCodeDLL := GetProcAddress(TaxBankCodeDLLHandle, 'InitializeDLL');
                    @GetParcelBankCode := GetProcAddress(TaxBankCodeDLLHandle, 'GetParcelBankCode');
                    @SetParcelBankCode := GetProcAddress(TaxBankCodeDLLHandle, 'SetParcelBankCode');
                    @CloseTaxBankCodeDLL := GetProcAddress(TaxBankCodeDLLHandle, 'CloseDLL');

                    If (@InitializeTaxBankCodeDLL = nil)
                      then Quit := True
                      else InitializeTaxBankCodeDLL(Application, _Systems);

                  end;  {else of If (TaxBankCodeDLLHandle = 0)} *)

(*            end;  {If UpdateBankCodes} *)

      end;  {If ((tsSchool in SystemsToUpdate) or ...}

  If (tsBigBuilding in SystemsToUpdate)
    then
      begin
        BigBuildingNameAddressDLLLocation := GlblProgramDir;
        tb_BigBuildingParcel := TTable.Create(nil);
        OpenTable(tb_BigBuildingParcel, 'parcelmasterfile',
                  'BYSWISCODE_SBL', 'CodeEnforcement');

(*        Index := Pos('PAS32\', BigBuildingNameAddressDLLLocation);
        If (Index > 0)
          then Delete(BigBuildingNameAddressDLLLocation, Index, 255);
        BigBuildingNameAddressDLLLocation := BigBuildingNameAddressDLLLocation + 'CodeEnforcement\' +
                                             BigBuildingNameAddressDLLName;

          {FXX01192003-1: If the DLL is not in the same root directory structure, just put
                          it in the PAS32 folder.}

        If (not FileExists(BigBuildingNameAddressDLLLocation))
          then BigBuildingNameAddressDLLLocation := GlblProgramDir + BigBuildingNameAddressDLLName;

        TempLen := Length(BigBuildingNameAddressDLLLocation);
        TempPChar := StrAlloc(TempLen + 1);
        StrPCopy(TempPChar, BigBuildingNameAddressDLLLocation);

        BigBuildingNameAddressDLLHandle := LoadLibrary(TempPChar);

        If (BigBuildingNameAddressDLLHandle = 0)
          then Quit := True
          else
            begin
              @InitializeBigBuildingNameAddressDLL := GetProcAddress(BigBuildingNameAddressDLLHandle, 'InitializeDLL');
              @GetBigBuildingParcelNameAddress := GetProcAddress(BigBuildingNameAddressDLLHandle, 'GetParcelNameAddress');
              @SetBigBuildingParcelNameAddress := GetProcAddress(BigBuildingNameAddressDLLHandle, 'SetParcelNameAddress');
//              @GetBigBuildingLegalAddress := GetProcAddress(BigBuildingNameAddressDLLHandle, 'GetLegalAddress');
//              @SetBigBuildingLegalAddress := GetProcAddress(BigBuildingNameAddressDLLHandle, 'SetLegalAddress');
              @CloseBigBuildingNameAddressDLL := GetProcAddress(BigBuildingNameAddressDLLHandle, 'CloseDLL');

              _Systems := _Systems + 'BIGBUILDING';

              If (@InitializeBigBuildingNameAddressDLL = nil)
                then Quit := True
                else InitializeBigBuildingNameAddressDLL(Application);

            end;  {else of If (BigBuildingNameAddressDLLHandle = 0)}  *)

      end;  {If (tsBigBuilding in SystemsToUpdate)}

  If (tsSmallBuilding in SystemsToUpdate)
    then
      begin
        tbSmallBuildingParcel.TableName := 'PropertyTable';
        tbSmallBuildingParcel.Open;
        SmallBuildingNameAddressDLLLocation := GlblProgramDir;

(*        Index := Pos('PAS32\', SmallBuildingNameAddressDLLLocation);
        If (Index > 0)
          then Delete(SmallBuildingNameAddressDLLLocation, Index, 255);
        SmallBuildingNameAddressDLLLocation := SmallBuildingNameAddressDLLLocation + 'SCABuild32\' +
                                               SmallBuildingNameAddressDLLName;

          {FXX01192003-1: If the DLL is not in the same root directory structure, just put
                          it in the PAS32 folder.}

        If (not FileExists(SmallBuildingNameAddressDLLLocation))
          then SmallBuildingNameAddressDLLLocation := GlblProgramDir + SmallBuildingNameAddressDLLName;

        TempLen := Length(SmallBuildingNameAddressDLLLocation);
        TempPChar := StrAlloc(TempLen + 1);
        StrPCopy(TempPChar, SmallBuildingNameAddressDLLLocation);

        SmallBuildingNameAddressDLLHandle := LoadLibrary(TempPChar);

        If (SmallBuildingNameAddressDLLHandle = 0)
          then Quit := True
          else
            begin
              @InitializeSmallBuildingNameAddressDLL := GetProcAddress(SmallBuildingNameAddressDLLHandle, 'InitializeDLL');
              @GetSmallBuildingParcelNameAddress := GetProcAddress(SmallBuildingNameAddressDLLHandle, 'GetParcelNameAddress');
              @SetSmallBuildingParcelNameAddress := GetProcAddress(SmallBuildingNameAddressDLLHandle, 'SetParcelNameAddress');
              @GetSmallBuildingLegalAddress := GetProcAddress(BigBuildingNameAddressDLLHandle, 'GetLegalAddress');
              @SetSmallBuildingLegalAddress := GetProcAddress(BigBuildingNameAddressDLLHandle, 'SetLegalAddress');
              @CloseSmallBuildingNameAddressDLL := GetProcAddress(SmallBuildingNameAddressDLLHandle, 'CloseDLL');

              _Systems := _Systems + 'SMALLBUILDING';

              If (@InitializeSmallBuildingNameAddressDLL = nil)
                then Quit := True
                else InitializeSmallBuildingNameAddressDLL(Application);

            end;  {else of If (SmallBuildingNameAddressDLLHandle = 0)} *)

      end;  {If (tsSmallBuilding in SystemsToUpdate)}

(*  If AddNewParcelsToBuilding
    then
      begin
        BigBuildingAddNewParcelsDLLLocation := GlblProgramDir;

        Index := Pos('PAS32\', BigBuildingAddNewParcelsDLLLocation);
        If (Index > 0)
          then Delete(BigBuildingAddNewParcelsDLLLocation, Index, 255);
        BigBuildingAddNewParcelsDLLLocation := BigBuildingAddNewParcelsDLLLocation + 'CodeEnforcement\' +
                                               BigBuildingAddNewParcelsDLLName;

          {FXX01192003-1: If the DLL is not in the same root directory structure, just put
                          it in the PAS32 folder.}

        If (not FileExists(BigBuildingAddNewParcelsDLLLocation))
          then BigBuildingAddNewParcelsDLLLocation := GlblProgramDir + BigBuildingAddNewParcelsDLLName;

        TempLen := Length(BigBuildingAddNewParcelsDLLLocation);
        TempPChar := StrAlloc(TempLen + 1);
        StrPCopy(TempPChar, BigBuildingAddNewParcelsDLLLocation);

        BigBuildingAddNewParcelsDLLHandle := LoadLibrary(TempPChar);

        If (BigBuildingAddNewParcelsDLLHandle = 0)
          then Quit := True
          else
            begin
              @InitializeBigBuildingAddNewParcelsDLL := GetProcAddress(BigBuildingAddNewParcelsDLLHandle, 'InitializeDLL');
              @ParcelExistsInBuildingSystem := GetProcAddress(BigBuildingAddNewParcelsDLLHandle, 'ParcelExistsInBuildingSystem');
              @AddParcelToBuildingSystem := GetProcAddress(BigBuildingAddNewParcelsDLLHandle, 'AddParcelToBuildingSystem');
              @CloseBigBuildingAddNewParcelsDLL := GetProcAddress(BigBuildingAddNewParcelsDLLHandle, 'CloseDLL');

              If (@InitializeBigBuildingAddNewParcelsDLL = nil)
                then Quit := True
                else InitializeBigBuildingAddNewParcelsDLL(Application);

            end;  {else of If (BigBuildingAddNewParcelsDLLHandle = 0)}

      end;  {If AddNewParcelsToBuilding} *)

  If Quit
    then SystemSupport(001, ParcelTable, 'Error loading interface to tax systems.',
                       UnitName, GlblErrorDlgBox)
    else
      begin
        ParcelTable.First;

        with Sender as TBaseReport do
          begin
            repeat
              If FirstTimeThrough
                then FirstTimeThrough := False
                else ParcelTable.Next;

              If ParcelTable.EOF
                then Done := True;

              SwisSBLKey := ExtractSSKey(ParcelTable);
              ProgressDialog.Update(Self, ConvertSwisSBLToDashDot(SwisSBLKey));
              ProgressDialog.UserLabelCaption := 'Number Parcels Changed = ' + IntToStr(NumChanged);
              Application.ProcessMessages;

              SwisCode := ParcelTable.FieldByName('SwisCode').Text;
              SchoolCode := ParcelTable.FieldByName('SchoolCode').Text;
              sAccountNumber := ParcelTable.FieldByName('AccountNo').AsString;

                {FXX03112005-1(2.8.3.11)[2074]: Don't process inactive parcels.}

              If ((not Done) and
                  ParcelIsActive(ParcelTable) and
                  RecordinRange(SelectedSwisCodes, SelectedSchoolCodes, SwisCode, SchoolCode))
                then
                  begin
                    NewLegalAddressNumber := ParcelTable.FieldByName('LegalAddrNo').Text;
                    NewLegalAddressName := ParcelTable.FieldByName('LegalAddr').Text;

                    GetNameAddress(ParcelTable, NewNameAddressArray);

                    SBL := Copy(SwisSBLKey, 7, 20);
                    NewBankCode := ParcelTable.FieldByName('BankCode').Text;
                    OldBankCode := '';

                    ParcelHasSchool := False;
                    ParcelHasTown := False;
                    ParcelHasCounty := False;
                    ParcelHasBigBuilding := False;
                    ParcelHasSmallBuilding := False;
                    ParcelHasPASVillage := False;
                    ParcelHasSQLLien := False;

                    If ((tsTown in SystemsToUpdate) and
                        ((glblUsesSQLTax and
                          _GetParcelNameAddress(qryTax, '999999', SwisCode, SBL,
                                                iCurrentTownCollectionID, OldNameAddressArray)) or
                         ((not glblUsesSQLTax) and
                          _GetParcelNameAddress(tbTownTaxParcel, '999999', SwisCode, SBL,
                                                OldNameAddressArray))) and
                        (UpdateAllParcels or
                         NameAddressesDifferent(OldNameAddressArray,
                                                NewNameAddressArray,
                                                True)))
                      then
                        begin
                          ParcelHasTown := True;
                          TotalTown := TotalTown + 1;

                          If not TrialRun
                          then
                            If glblUsesSQLTax
                            then _SetParcelNameAddress(qryTax2,
                                                       '999999', SwisCode, SBL,
                                                       iCurrentTownCollectionID,
                                                       NewNameAddressArray)
                            else _SetParcelNameAddress(tbTownTaxParcel,
                                                       '999999', SwisCode, SBL,
                                                       NewNameAddressArray);

                          PrintAddressChange(Sender, SwisSBLKey,
                                             'TOWN',
                                             OldNameAddressArray,
                                             NewNameAddressArray);

                        end;  {If ((tsTown in SystemsToUpdate) and ...}

                    If ((tsCounty in SystemsToUpdate) and
                        ((glblUsesSQLTax and
                          _GetParcelNameAddress(qryTax, '999999', SwisCode, SBL,
                                               iCurrentCountyCollectionID, OldNameAddressArray)) or
                         ((not glblUsesSQLTax) and
                          _GetParcelNameAddress(tbCountyTaxParcel, '999999', SwisCode, SBL,
                                                OldNameAddressArray))) and
                        (UpdateAllParcels or
                         NameAddressesDifferent(OldNameAddressArray,
                                                NewNameAddressArray,
                                                True)))
                      then
                        begin
                          ParcelHasCounty := True;
                          TotalCounty := TotalCounty + 1;

                          If not TrialRun
                          then
                            If glblUsesSQLTax
                            then _SetParcelNameAddress(qryTax2,
                                                       '999999', SwisCode, SBL,
                                                       iCurrentCountyCollectionID,
                                                       NewNameAddressArray)
                            else _SetParcelNameAddress(tbCountyTaxParcel,
                                                       '999999', SwisCode, SBL,
                                                       NewNameAddressArray);

                          PrintAddressChange(Sender, SwisSBLKey,
                                             'COUNTY',
                                             OldNameAddressArray,
                                             NewNameAddressArray);

                        end;  {If ((tsCounty in SystemsToUpdate) and ...}

                    If ((tsSchool in SystemsToUpdate) and
                        ((glblUsesSQLTax and
                          _GetParcelNameAddress(qryTax, SchoolCode, SwisCode, SBL,
                                                iCurrentSchoolCollectionID, OldNameAddressArray)) or
                         ((not glblUsesSQLTax) and
                          _GetParcelNameAddress(tbSchoolTaxParcel, SchoolCode, SwisCode, SBL,
                                                OldNameAddressArray))) and
                        (UpdateAllParcels or
                         NameAddressesDifferent(OldNameAddressArray,
                                                NewNameAddressArray,
                                                True)))
                      then
                        begin
                          ParcelHasSchool := True;
                          TotalSchool := TotalSchool + 1;

                          If not TrialRun
                          then
                            If glblUsesSQLTax
                            then _SetParcelNameAddress(qryTax2,
                                                       SchoolCode, SwisCode, SBL,
                                                       iCurrentSchoolCollectionID,
                                                       NewNameAddressArray)
                            else _SetParcelNameAddress(tbSchoolTaxParcel,
                                                       SchoolCode, SwisCode, SBL,
                                                       NewNameAddressArray);

                          PrintAddressChange(Sender, SwisSBLKey,
                                             'SCHOOL',
                                             OldNameAddressArray,
                                             NewNameAddressArray);

                        end;  {If ((tsSchool in SystemsToUpdate) and ...}

                      {CHG08072003-1(2.07h) : Allow for bank code updates.}

                    with tbTownTaxParcel do
                      If ((tsTown in SystemsToUpdate) and
                          UpdateBankCodes and
                          ((glblUsesSQLTax and
                            _GetBankCode(qryTax, '999999', SwisCode, SBL,
                                         iCurrentTownCollectionID, OldBankCode)) or
                           ((not glblUsesSQLTax) and
                            _GetBankCode(tbTownTaxParcel, '999999', SwisCode, SBL,
                                         OldBankCode))) and
                          _Compare(OldBankCode, NewBankCode, coNotEqual))
                        then
                          begin
                            ParcelHasTown := True;
                            TotalTownBankCodeChanges := TotalTownBankCodeChanges + 1;

                            If not TrialRun
                            then
                              If glblUsesSQLTax
                              then _SetBankCode(qryTax2,
                                                '999999', SwisCode, SBL,
                                                iCurrentTownCollectionID,
                                                NewBankCode)
                              else _SetBankCode(tbTownTaxParcel,
                                                NewBankCode);

                            PrintBankCodeChange(Sender, SwisSBLKey,
                                                'TOWN', OldBankCode, NewBankCode);

                            If ExtractToExcel
                              then AddBankChangeExtractLine(ExtractBankCodesAdded,
                                                            SwisSBLKey, SchoolCode,
                                                            OldBankCode,
                                                            NewBankCode,
                                                            OldNameAddressArray);

                          end;  {If ((tsTown in SystemsToUpdate) and ...}

                    with tbCountyTaxParcel do
                      If ((tsCounty in SystemsToUpdate) and
                          ((glblUsesSQLTax and
                            _GetBankCode(qryTax, '999999', SwisCode, SBL,
                                         iCurrentCountyCollectionID, OldBankCode)) or
                           ((not glblUsesSQLTax) and
                            _GetBankCode(tbCountyTaxParcel, '999999', SwisCode, SBL,
                                         OldBankCode))) and
                          _Compare(OldBankCode, NewBankCode, coNotEqual))
                        then
                          begin
                            ParcelHasCounty := True;
                            TotalCountyBankCodeChanges := TotalCountyBankCodeChanges + 1;

                            If not TrialRun
                            then
                              If glblUsesSQLTax
                              then _SetBankCode(qryTax2,
                                                '999999', SwisCode, SBL,
                                                iCurrentCountyCollectionID,
                                                NewBankCode)
                              else _SetBankCode(tbCountyTaxParcel,
                                                NewBankCode);

                            PrintBankCodeChange(Sender, SwisSBLKey,
                                                'COUNTY', OldBankCode, NewBankCode);

                            If ExtractToExcel
                              then AddBankChangeExtractLine(ExtractBankCodesAdded,
                                                            SwisSBLKey, SchoolCode,
                                                            OldBankCode,
                                                            NewBankCode,
                                                            OldNameAddressArray);

                          end;  {If ((tsCounty in SystemsToUpdate) and ...}

                    with tbSchoolTaxParcel do
                      If ((tsSchool in SystemsToUpdate) and
                          UpdateBankCodes and
                          ((glblUsesSQLTax and
                            _GetBankCode(qryTax, SchoolCode, SwisCode, SBL,
                                         iCurrentSchoolCollectionID, OldBankCode)) or
                           ((not glblUsesSQLTax) and
                            _GetBankCode(tbSchoolTaxParcel, SchoolCode, SwisCode, SBL,
                                         OldBankCode))) and
                          _Compare(OldBankCode, NewBankCode, coNotEqual))
                        then
                          begin
                            ParcelHasSchool := True;
                            TotalSchoolBankCodeChanges := TotalSchoolBankCodeChanges + 1;

                            If not TrialRun
                            then
                              If glblUsesSQLTax
                              then _SetBankCode(qryTax2,
                                                SchoolCode, SwisCode, SBL,
                                                iCurrentSchoolCollectionID,
                                                NewBankCode)
                              else _SetBankCode(tbSchoolTaxParcel,
                                                NewBankCode);

                            PrintBankCodeChange(Sender, SwisSBLKey,
                                                'SCHOOL', OldBankCode, NewBankCode);

                            If ExtractToExcel
                              then AddBankChangeExtractLine(ExtractBankCodesAdded,
                                                            SwisSBLKey, SchoolCode,
                                                            OldBankCode,
                                                            NewBankCode,
                                                            OldNameAddressArray);

                          end;  {If ((tsSchool in SystemsToUpdate) and ...}

                      {CHG05082003-1(2.07a): Option to transfer new parcels from PAS to
                                             assessment.}

                    If ((tsBigBuilding in SystemsToUpdate) and
                        AddNewParcelsToBuilding and
                        (not _ParcelExistsInBigBuildingSystem(tb_BigBuildingParcel, SwisCode, SBL)))
                      then
                        begin
                          NumParcelsAddedToBigBuilding := NumParcelsAddedToBigBuilding + 1;

                          If not TrialRun
                            then
                              begin
                                GetNameAddress(ParcelTable, NewNameAddressArray);
                                _AddParcelToBigBuildingSystem(tb_BigBuildingParcel, ParcelTable,
                                                              SwisCode, SBL,
                                                              GlblNextYear, NewNameAddressArray);

                              end;  {If not TrialRun}

                          NewParcelList.Add(SwisSBLKey);

                        end;  {If AddNewParcelsToBuilding}

                    If ((tsBigBuilding in SystemsToUpdate) and
                        _GetBigBuildingParcelNameAddress(tb_BigBuildingParcel, SwisCode, SBL,
                                                         OldNameAddressArray) and
                        (UpdateAllParcels or
                         NameAddressesDifferent(OldNameAddressArray,
                                                NewNameAddressArray,
                                                True)))
                      then
                        begin
                          ParcelHasBigBuilding := True;
                          TotalBigBuilding := TotalBigBuilding + 1;

                          If not TrialRun
                            then _SetBigBuildingParcelNameAddress(tb_BigBuildingParcel, SwisCode, SBL,
                                                                  NewNameAddressArray);

                          PrintAddressChange(Sender, SwisSBLKey,
                                             'BUILDING',
                                             OldNameAddressArray,
                                             NewNameAddressArray);

                        end;  {If ((tsBigBuilding in SystemsToUpdate) and ...}

                      {CHG02082004-3(2.08): Allow for legal address update in big building.}

                    If ((tsBigBuilding in SystemsToUpdate) and
                        UpdateLegalAddresses and
                        _GetBigBuildingLegalAddress(tb_BigBuildingParcel, SwisCode, SBL,
                                                    OldLegalAddressName, OldLegalAddressNumber) and
                        LegalAddressesDifferent(OldLegalAddressName,
                                                OldLegalAddressNumber,
                                                NewLegalAddressName,
                                                NewLegalAddressNumber))
                      then
                        begin
                          ParcelHasBigBuilding := True;
                          TotalBigBuilding := TotalBigBuilding + 1;

                          If not TrialRun
                            then _SetBigBuildingLegalAddress(tb_BigBuildingParcel, SwisCode, SBL,
                                                             NewLegalAddressName,
                                                             NewLegalAddressNumber);

                          OldLegalAddress := MakeLegalAddress(OldLegalAddressNumber,
                                                              OldLegalAddressName);

                          NewLegalAddress := MakeLegalAddress(NewLegalAddressNumber,
                                                              NewLegalAddressName);

                          PrintLegalAddressChange(Sender, SwisSBLKey,
                                                  'BUILDING',
                                                  OldLegalAddress,
                                                  NewLegalAddress);

                        end;  {If ((tsBigBuilding in SystemsToUpdate) and ...}

                      {CHG01232006-1(2.9.5.1): Allow for legal address update in small building.}

                    If ((tsSmallBuilding in SystemsToUpdate) and
                        UpdateLegalAddresses and
                        _GetSmallBuildingLegalAddress(tbSmallBuildingParcel, SwisCode, SBL,
                                                      OldLegalAddressName, OldLegalAddressNumber) and
                        LegalAddressesDifferent(OldLegalAddressName,
                                                OldLegalAddressNumber,
                                                NewLegalAddressName,
                                                NewLegalAddressNumber))
                      then
                        begin
                          ParcelHasSmallBuilding := True;

                          If not TrialRun
                            then _SetSmallBuildingLegalAddress(tbSmallBuildingParcel, SwisCode, SBL,
                                                               NewLegalAddressName,
                                                               NewLegalAddressNumber);

                          OldLegalAddress := MakeLegalAddress(OldLegalAddressNumber,
                                                              OldLegalAddressName);

                          NewLegalAddress := MakeLegalAddress(NewLegalAddressNumber,
                                                              NewLegalAddressName);

                          PrintLegalAddressChange(Sender, SwisSBLKey,
                                                  'BUILDING',
                                                  OldLegalAddress,
                                                  NewLegalAddress);

                        end;  {If ((tsBigBuilding in SystemsToUpdate) and ...}

                    If ((tsSmallBuilding in SystemsToUpdate) and
                        _GetSmallBuildingParcelNameAddress(tbSmallBuildingParcel, SwisCode, SBL,
                                                           OldNameAddressArray) and
                        NameAddressesDifferent(OldNameAddressArray,
                                               NewNameAddressArray,
                                               True))
                      then
                        begin
                          ParcelHasSmallBuilding := True;

                          If not TrialRun
                            then _SetSmallBuildingParcelNameAddress(tbSmallBuildingParcel, SwisCode, SBL,
                                                                    NewNameAddressArray);

                          PrintAddressChange(Sender, SwisSBLKey,
                                             'BUILDING',
                                             OldNameAddressArray,
                                             NewNameAddressArray);

                        end;  {If ((tsSmallBuilding in SystemsToUpdate) and ...}

                      {CHG12192010-1(2.26.1.23)[I7458]: Move name / addrs to village.}

                    If ((tsPASVillage in SystemsToUpdate) and
                        _GetPASVillageParcelNameAddress(tbPASVillageParcels, GlblNextYear, SwisCode, SBL,
                                                        bLocateByAccountNumber, sAccountNumber,
                                                        OldNameAddressArray) and
                        (UpdateAllParcels or
                         NameAddressesDifferent(OldNameAddressArray,
                                                NewNameAddressArray,
                                                True)))
                      then
                        begin
                          ParcelHasPASVillage := True;
                          TotalPASVillage := TotalPASVillage + 1;

                          If not TrialRun
                            then _SetPASVillageParcelNameAddress(tbPASVillageParcels,
                                                                 ParcelTable,
                                                                 GlblNextYear, SwisCode, SBL,
                                                                 bLocateByAccountNumber, sAccountNumber,
                                                                 NewNameAddressArray);

                          PrintAddressChange(Sender, SwisSBLKey,
                                             'PAS Village',
                                             OldNameAddressArray,
                                             NewNameAddressArray);

                        end;  {If ((tsPASVillage in SystemsToUpdate) and ...}

                      {CHG02082004-3(2.08): Allow for legal address update in big building.}

                    If ((tsPASVillage in SystemsToUpdate) and
                        UpdateLegalAddresses and
                        _GetPASVillageLegalAddress(tbTYPASVillageParcels, GlblNextYear, SwisCode, SBL,
                                                   bLocateByAccountNumber, sAccountNumber,
                                                   OldLegalAddressName, OldLegalAddressNumber) and
                        LegalAddressesDifferent(OldLegalAddressName,
                                                OldLegalAddressNumber,
                                                NewLegalAddressName,
                                                NewLegalAddressNumber))
                      then
                        begin
                          ParcelHasPASVillage := True;
                          TotalPASVillage := TotalPASVillage + 1;

                          If not TrialRun
                            then _SetPASVillageLegalAddress(tbTYPASVillageParcels,
                                                            GlblNextYear, SwisCode, SBL,
                                                            bLocateByAccountNumber, sAccountNumber,
                                                            NewLegalAddressName,
                                                            NewLegalAddressNumber);

                          OldLegalAddress := MakeLegalAddress(OldLegalAddressNumber,
                                                              OldLegalAddressName);

                          NewLegalAddress := MakeLegalAddress(NewLegalAddressNumber,
                                                              NewLegalAddressName);

                          PrintLegalAddressChange(Sender, SwisSBLKey,
                                                  'PAS Village',
                                                  OldLegalAddress,
                                                  NewLegalAddress);

                        end;  {If ((tsPASVillage in SystemsToUpdate) and ...}

                      {SQLLien}

                    If ((tsSQLLien in SystemsToUpdate) and
                        (_GetLienParcelNameAddress(qryLien, SchoolCode, SwisCode, SBL,
                                                   OldNameAddressArray)) and
                        (UpdateAllParcels or
                         NameAddressesDifferent(OldNameAddressArray,
                                                NewNameAddressArray,
                                                True)))
                      then
                        begin
                          ParcelHasSQLLien := True;
                          TotalSQLLien := TotalSQLLien + 1;

                          with ParcelTable do
                            If not TrialRun
                            then _SetLienParcelNameAddress(qryLien, qryLien2,
                                                           SchoolCode, SwisCode, SBL,
                                                           FieldByName('Name1').AsString,
                                                           FieldByName('Name2').AsString,
                                                           FieldByName('Address1').AsString,
                                                           FieldByName('Address2').AsString,
                                                           FieldByName('Street').AsString,
                                                           FieldByName('City').AsString,
                                                           FieldByName('State').AsString,
                                                           FieldByName('Zip').AsString,
                                                           FieldByName('ZipPlus4').AsString);

                          PrintAddressChange(Sender, SwisSBLKey,
                                             'LIEN',
                                             OldNameAddressArray,
                                             NewNameAddressArray);

                        end;  {If ((tsSQLLien in SystemsToUpdate) and ...}

                    If (ParcelHasSchool or
                        ParcelHasTown or
                        ParcelHasCounty or
                        ParcelHasBigBuilding or
                        ParcelHasSmallBuilding or
                        ParcelHasPASVillage or
                        ParcelHasSQLLien)
                      then
                        begin
                          NumChanged := NumChanged + 1;

                            {CHG08022004-1(2.07l6): Add option for a parcel list.}

                          If (CreateParcelList and
                              (not ParcelListDialog.ParcelExistsInList(SwisSBLKey)))
                            then ParcelListDialog.AddOneParcel(SwisSBLKey);

                        end;  {If (ParcelHasSchool or ...}

                  end;  {If ((not Done) and ...}

              ReportCancelled := ProgressDialog.Cancelled;

            until (Done or ReportCancelled);

              {Now print the new parcels if they selected this option.}

            If AddNewParcelsToBuilding
              then
                begin
                  If (LinesLeft < 12)
                    then NewPage;

                  Underline := True;

                  If (tsSmallBuilding in SystemsToUpdate)
                    then Println(#9 + 'Parcels added to the Building System:')
                    else Println(#9 + 'Parcls added to the Code Enforcement System:');

                  Underline := False;
                  Println('');

                  For I := 0 to (NewParcelList.Count - 1) do
                    begin
                      PrintAddedParcel(Sender, NewParcelList[I], 'BUILDING');

                      If (LinesLeft < 7)
                        then NewPage;

                    end;  {For I := 0 to (NewParcelList.Count - 1) do}

                end;  {If AddNewParcelsToBuilding}

            If (LinesLeft < 7)
              then NewPage;

            Println('');
            Println('');
            Println(#9 + 'Number changed = ' + IntToStr(NumChanged));

            If (tsSchool in SystemsToUpdate)
              then Println(#9 + '  School addresses changed = ' +
                                IntToStr(TotalSchool));

            If (tsTown in SystemsToUpdate)
              then Println(#9 + '  Town addresses changed = ' +
                                IntToStr(TotalTown));

            If (tsCounty in SystemsToUpdate)
              then Println(#9 + '  County addresses changed = ' +
                                IntToStr(TotalCounty));

            If (tsBigBuilding in SystemsToUpdate)
              then Println(#9 + '  Code Enforcement addresses changed = ' +
                                IntToStr(TotalBigBuilding));

            If (tsSmallBuilding in SystemsToUpdate)
              then Println(#9 + '  Building addresses changed = ' +
                                IntToStr(TotalBigBuilding));

            If (tsPASVillage in SystemsToUpdate)
              then Println(#9 + '  PAS Village addresses changed = ' +
                                IntToStr(TotalPASVillage));

            If (tsSQLLien in SystemsToUpdate)
              then Println(#9 + '  Lien addresses changed = ' +
                                IntToStr(TotalSQLLien));

            If (UpdateBankCodes and
                (tsSchool in SystemsToUpdate))
              then Println(#9 + '  School bank codes changed = ' +
                                IntToStr(TotalSchoolBankCodeChanges));

            If (tsTown in SystemsToUpdate)
              then Println(#9 + '  Town bank codes changed = ' +
                                IntToStr(TotalTownBankCodeChanges));

            If (tsCounty in SystemsToUpdate)
              then Println(#9 + '  County bank codes changed = ' +
                                IntToStr(TotalCountyBankCodeChanges));

            If ((tsBigBuilding in SystemsToUpdate) and
                AddNewParcelsToBuilding)
              then Println(#9 + '  Parcels added to Code Enforcement system = ' +
                                IntToStr(NumParcelsAddedToBigBuilding));

            If ((tsSmallBuilding in SystemsToUpdate) and
                AddNewParcelsToBuilding)
              then Println(#9 + '  Parcels added to Building system = ' +
                                IntToStr(NumParcelsAddedToSmallBuilding));

          end;  {with Sender as TBaseReport do}

(*        If ((tsSchool in SystemsToUpdate) or
            (tsTown in SystemsToUpdate) or
            (tsCounty in SystemsToUpdate))
          then
            begin
              CloseTaxNameAddressDLL(Application);
              FreeLibrary(TaxNameAddressDLLHandle);
              TaxNameAddressDLLHandle := 0;

            end;  {If ((tsSchool in SystemsToUpdate) or ...} *)

(*        If (tsBigBuilding in SystemsToUpdate)
          then
            begin
              CloseBigBuildingNameAddressDLL(Application);
              FreeLibrary(BigBuildingNameAddressDLLHandle);
              BigBuildingNameAddressDLLHandle := 0;

            end;  {If (tsBigBuilding in SystemsToUpdate)} *)

        If (tsSmallBuilding in SystemsToUpdate)
          then
            begin
(*              CloseSmallBuildingNameAddressDLL(Application);
              FreeLibrary(SmallBuildingNameAddressDLLHandle);
              SmallBuildingNameAddressDLLHandle := 0; *)
              tbSmallBuildingParcel.Close;

            end;  {If (tsSmallBuilding in SystemsToUpdate)}

        If AddNewParcelsToBuilding
          then
            If (tsBigBuilding in SystemsToUpdate)
              then
                begin
(*                  CloseBigBuildingAddNewParcelsDLL(Application);
                  FreeLibrary(BigBuildingAddNewParcelsDLLHandle);
                  BigBuildingAddNewParcelsDLLHandle := 0; *)

                end
              else
                begin
                  try
                    CloseSmallBuildingAddNewParcelsDLL(Application);
                  except
                  end;

                  FreeLibrary(SmallBuildingAddNewParcelsDLLHandle);
                  SmallBuildingAddNewParcelsDLLHandle := 0;

                end;  {else of If (tsBigBuilding in SystemsToUpdate)}

      end;  {else of If Quit}

  NewParcelList.Free;

  If (tsBigBuilding in SystemsToUpdate)
    then CloseTable(tb_BigBuildingParcel);

  If glblUsesSQLTax
  then
  try
    adoConnection.Connected := False;
    qryTax.Close;
    qryTax.Free;
    qryTax2.Close;
    qryTax2.Free;
    adoConnection.Free;
  except
  end;

  If ExtractToExcel
    then
      begin
        CloseFile(ExtractBankCodesRemoved);
        CloseFile(ExtractBankCodesChanged);
        CloseFile(ExtractBankCodesAdded);

        SendTextFileToExcelSpreadsheet(ExtractBankCodesRemovedFileName, True, False, '');
        SendTextFileToExcelSpreadsheet(ExtractBankCodesAddedFileName, True, False, '');
        SendTextFileToExcelSpreadsheet(ExtractBankCodesChangedFileName, True, False, '');

      end;  {If ExtractToExcel}

end;  {ReportPrint}

{===================================================================}
Procedure TUpdateNamesAndAddressesInSCASystemsForm.FormClose(    Sender: TObject;
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
