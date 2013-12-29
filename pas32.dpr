program pas32;

{$DEFINE WIN32}
{$DEFINE Word97Components}

uses
  Forms,
  SysUtils,
  WinProcs,
  Printers,
  Dialogs,
  Registry,
  DBTables,
  Utilitys,
  FileCtrl,
  AddMissingAliasesUnit,
  Mainform in 'MAINFORM.PAS' {MainPASForm},
  Parcltab in 'PARCLTAB.PAS' {ParcelTabForm},
  Pastypes in 'PASTYPES.PAS',
  Glblcnst in 'GLBLCNST.PAS',
  Pasutils in 'PASUTILS.PAS',
  Glblvars in 'GLBLVARS.PAS',
  Psdcdmnt in 'PSDCDMNT.PAS' {ParcelSpecialDistrictForm},
  Prclocat in 'PRCLOCAT.PAS' {LocateParcelForm},
  Pexcdmnt in 'PEXCDMNT.PAS' {ParcelExemptionCodeForm},
  pTaxBillNameAddress in 'pTaxBillNameAddress.pas' {fmTaxBillAddress},
  PAsmtfrm in 'PASMTFRM.PAS' {AssessmentForm},
  Tablemnt in 'TABLEMNT.PAS' {TableMaintForm},
  Sdecdmnt in 'SDECDMNT.PAS' {SpecialDistrictExtensionCodesForm},
  Security in 'SECURITY.PAS' {MenuSecurityForm},
  Userprof in 'USERPROF.PAS' {UserProfileForm},
  Pressite in 'PRESSITE.PAS' {ParcelResidentialSiteForm},
  Pcombldg in 'PCOMBLDG.PAS' {ParcelCommercialBldgForm},
  Pcomrent in 'PCOMRENT.PAS' {ParcelCommercialRentForm},
  Pcomland in 'PCOMLAND.PAS' {ParcelCommercialLandForm},
  Presfrst in 'PRESFRST.PAS' {ParcelResidentialForestForm},
  Pcominex in 'PCOMINEX.PAS' {ParcelCommercialIncomeExpenseForm},
  Presland in 'PRESLAND.PAS' {ParcelResidentialLandForm},
  Presimpr in 'PRESIMPR.PAS' {ParcelResidentialImprovementsForm},
  Pcomimpr in 'PCOMIMPR.PAS' {ParcelCommercialImprovementsForm},
  Presbldg in 'PRESBLDG.PAS' {ParcelResidentialBldgForm},
  Pcomsite in 'PCOMSITE.PAS' {ParcelCommercialSiteForm},
  Assyrmnt in 'ASSYRMNT.PAS' {AssYearControlForm},
  Chostxyr in 'CHOSTXYR.PAS' {ChooseTaxYearForm},
  Rtcalcul in 'RTCALCUL.PAS' {RollTotalCalculateForm},
  Rtdisply in 'RTDISPLY.PAS' {RollTotalDisplayForm},
  Rps995ut in 'RPS995UT.PAS',
  Rps995ex in 'RPS995EX.PAS' {RPS995FileExtractForm},
  Pclassfm in 'PCLASSFM.PAS' {ClassForm},
  RPS155EX in 'RPS155EX.PAS' {RPS155FileExtractForm},
  Utilbill in 'UTILBILL.PAS',
  Preview in 'PREVIEW.PAS' {PreviewForm},
  Bcollclc in 'BCOLLCLC.PAS' {pr},
  Bcollctl in 'BCOLLCTL.PAS' {BillFileControlForm},
  RNoteRpt in 'RNoterpt.pas' {NotesReportForm},
  Keychng in 'Keychng.pas' {KeyChangeForm},
  Rslsrept in 'RSLSREPT.PAS' {RptSalesReportingForm},
  Psummary in 'PSUMMARY.PAS' {ParcelSummaryForm},
  Rpasesor in 'RPASESOR.PAS' {AssessorsReportForm},
  Rpasrutl in 'RPASRUTL.PAS',
  Ppicture in 'PPICTURE.PAS' {PictureForm},
  Rpsdlist in 'RPSDLIST.PAS' {SpecialDistrictReportForm},
  SDBRDCST in 'SDBRDCST.PAS' {SDBroadcastForm},
  mntCooperativeBuildings in 'mntCooperativeBuildings.pas' {fmCooperativeBuildings},
  Rpasrver in 'RPASRVER.PAS' {AssessorsVerificationReportForm},
  Presimps in 'PRESIMPS.PAS' {ResidentialImprovementsSubform},
  RPrintParcelSummaryWithSketch in 'RPrintParcelSummaryWithSketch.PAS' {ParcelInformationWithSketchPrintForm},
  Uprntprc in 'UPRNTPRC.PAS',
  Pprntprc in 'PPRNTPRC.PAS' {ParcelPrintDialog},
  Prntrmnt in 'PRNTRMNT.PAS' {InstalledPrinterForm},
  Rpmanage in 'RPMANAGE.PAS' {ReportManagerForm},
  Rpasrtrl in 'RPASRTRL.PAS' {AssessorsTrialBalanceReportForm},
  Prcllist in 'PRCLLIST.PAS' {ParcelListDialog},
  Rpsplmrg in 'RPSPLMRG.PAS' {SplitMergeReportForm},
  Warnbox in 'WARNBOX.PAS' {WarningMessageDialog},
  Pexdeny in 'PEXDENY.PAS' {ExemptionDenialForm},
  Rprtprog in 'RPRTPROG.PAS' {ReprintingReportForm},
  Prog in 'PROG.PAS' {ProgressDialog},
  Enstarty in 'ENSTARTY.PAS' {EnhancedSTARTypeDialog},
  Types in 'TYPES.PAS',
  Rptdialg in 'RPTDIALG.PAS' {ReportDialog},
  Blprtunt in 'BLPRTUNT.PAS',
  DataModule in 'DataModule.pas' {PASDataModule: TDataModule},
  SplashScreen in 'SplashScreen.pas' {SplashScreenForm},
  PictureOrDocumentLoadDialog in 'PictureOrDocumentLoadDialog.pas' {LoadPicturesOrDocumentsDialog},
  DocumentTypeDialog in 'DocumentTypeDialog.pas' {DocumentTypeDialogForm},
  EnterDateDialog in 'EnterDateDialog.pas' {EnterDateDialogForm},
  SeniorLimitMaintenanceAddNewLimitDialog in 'SeniorLimitMaintenanceAddNewLimitDialog.pas' {AddNewLimitSetDialog},
  OwnerProgressionDialog_New in 'OwnerProgressionDialog_New.pas' {SalesOwnerProgressionForm_New},
  MapParcelInfoDialog in 'MapParcelInfoDialog.pas' {MapParcelInfoForm},
  ParcelToolbar in 'ParcelToolbar.pas' {ParcelToolbarForm},
  ParcelAuditPrintForm in 'ParcelAuditPrintForm.pas' {ParcelAuditPrintDialog},
  OLEUtilitys in 'OLEUtilitys.pas',
  MapUtilitys in 'MapUtilitys.pas',
  Phistfrm in 'Phistfrm.pas' {HistorySummaryForm},
  PGrievanceSubFormUnit in 'PGrievanceSubFormUnit.pas' {GrievanceSubform},
  GrievanceLawyerCodeDialogUnit in 'GrievanceLawyerCodeDialogUnit.pas' {GrievanceLawyerCodeDialog},
  NewLetterDialog in 'NewLetterDialog.pas' {NewLetterDialogForm},
  GrievanceUtilitys in 'GrievanceUtilitys.pas',
  GrievanceNotesFrameUnit in 'Frames\GrievanceNotesFrameUnit.pas' {GrievanceNotesFrame: TFrame},
  LetterInsertCodesUnit in 'LetterInsertCodesUnit.pas' {LetterInsertCodesForm},
  NewLawyerDialog in 'NewLawyerDialog.pas' {NewLawyerForm},
  ExemptionsNotRecalculatedFormUnit in 'ExemptionsNotRecalculatedFormUnit.pas' {ExemptionsNotRecalculatedForm},
  TrackLoginsUnit in 'TrackLoginsUnit.pas',
  DataAccessUnit in 'DataAccessUnit.pas',
  PBuildingPermit_New_Small_Subform in 'PBuildingPermit_New_Small_Subform.pas' {SmallBuildingPermitSubform},
  SDCodeMaintenanceSubformUnit in 'SDCodeMaintenanceSubformUnit.pas' {SpecialDistrictCodeMaintenanceSubform},
  UpdateBDEParametersUnit,
  LetterSelectionDialogUnit in 'LetterSelectionDialogUnit.pas' {LetterSelectionDialogForm},
  EstimatedTaxLetterUnit in 'EstimatedTaxLetterUnit.pas' {EstimatedTaxLetterForm},
  dlg_StreetRange in 'dlg_StreetRange.pas' {StreetRangeDialog},
  dlg_ProrataNewDetailUnit in 'dlg_ProrataNewDetailUnit.pas' {dlg_ProrataNewDetail},
  MunicityPermitReportPrintUnit in 'MunicityPermitReportPrintUnit.pas',
  Util_Coops in 'Util_Coops.pas',
  Coop_TaxRateCopy in 'Coop_TaxRateCopy.pas' {fmCopyTaxRatesToCoopRoll},
  dlgSBLEntryUnit in 'dlgSBLEntryUnit.pas' {dlgEnterSBL};

(*  MemCheck in '..\Utilitys\MemCheck\MemCheck.pas';*)

{$R *.RES}


{=====================================================}
Procedure ShowSplashScreen;

begin
  SplashScreenForm := TSplashScreenForm.Create(nil);
  SplashScreenForm.Show;
  SplashScreenForm.Update;
end;

{=====================================================}
Function KilledIfPreviousInstance(ApplicationName: string) : Boolean;

var
  hWndHandle: integer;
  hPopup: HWND;
  MyClassName: string;
  TempPClassName, TempPAppName : PChar;

begin
  Result := False;
  SetLength(MyClassName, 255);
  TempPClassName := StrAlloc(Length(MyClassName) + 1);
  StrPCopy(TempPClassName, MyClassName);

  TempPAppName := StrAlloc(Length(ApplicationName) + 1);
  StrPCopy(TempPAppName, ApplicationName);

  GetClassName(Application.Handle, TempPClassName, 255);
  hWndHandle := FindWindow(TempPClassName, TempPAppName);

  StrDispose(TempPClassName);
  StrDispose(TempPAppName);

  If (hWndHandle <> 0)
    then
      begin
        Result := True;
        hPopup := GetLastActivePopup(hWndHandle);

        If IsIconic(hPopup)
          then ShowWindow(hPopup, SW_RESTORE);
        SetForeGroundWindow(GetTopWindow(hPopup));
        Halt(0);

      end;  {If (hWndHandle <> 0)}

end;  {KillIfPreviousInstance}

{==============================================================}
Function GetFileSpecifications(    SearchFileName : String;
                               var FileTime : String;
                               var FileDate : String) : Boolean;

var
  FileRec : TSearchRec;
(*  FileHandle : Integer;*)

begin
  FileTime := '';
  FileDate := '';
  FileRec.Name := '';
  FindFirst(SearchFileName, faAnyFile, FileRec);
  Result := True;

  If (Deblank(FileRec.Name) <> '')
    then
      try
        Result := True;
        FileTime := TimeToStr(FileDateToDateTime(FileRec.Time));
(*        FileHandle := FileOpen(SearchFileName, 0);*)

        try
          FileDate := DateToStr(FileDateToDateTime(FileRec.Time));
        except
        end;

(*        FileDate := DateToStr(FileDateToDateTime(FileGetDate(FileHandle)));
        FileClose(FileHandle); *)
      except
        Result := False;
      end;  {else of If (Deblank(FileRec.Name) = '')}

end;  {GetFileSpecifications}

{==============================================================}
Function PASUpdateAvailable(var DriveLetter : String;
                            var ProgramDir : String) : Boolean;

{CHG02172003-1(2.07): Store the most current PAS executable on the network, but
                      copy it to the local hard drive to run.}

var
  SystemTable : TTable;
  Quit, FileFound, LocalFileFound : Boolean;
  LocalDirectory,
  NetworkFileDate, NetworkFileTime,
  LocalFileDate, LocalFileTime : String;

begin
  Quit := False;
  Result := False;
  SystemTable := TTable.Create(nil);

  with SystemTable do
    try
      TableType := ttDBase;
      DatabaseName := 'PropertyAssessmentSystem';
      TableName := 'SystemRecord';
      Open;
    except
      Quit := True;
    end;

  If not Quit
    then
      with SystemTable do
        If FieldByName('PASRunsLocalWithUpdate').AsBoolean
          then
            begin
              try
                DriveLetter := FieldByName('DriveLetter').Text;
                ProgramDir := FieldByName('SysProgramDir').AsString;
                ProgramDir := AddDirectorySlashes(ProgramDir);

                FileFound := GetFileSpecifications(DriveLetter + ':' + ProgramDir + 'PAS32.EXE',
                                                   NetworkFileTime, NetworkFileDate);

                If FileFound
                  then
                    begin
                        {First make sure the local directory exists.
                         If it does not, create it.}

                      LocalDirectory := 'C:' + ProgramDir;

                      If not DirectoryExists(LocalDirectory)
                        then MkDir(LocalDirectory);

                      ChDir(LocalDirectory);

                      LocalFileFound := GetFileSpecifications(LocalDirectory + 'PAS32.EXE',
                                                              LocalFileTime, LocalFileDate);

                        {If we found the file, then check the date and time to see if an update
                         is needed.  If it was not found, just copy it.}

                      If LocalFileFound
                        then
                          begin
                            If ((NetworkFileDate <> LocalFileDate) or
                                (NetworkFileTime <> LocalFileTime))
                              then Result := True;
                          end
                        else Result := True;

                    end;  {If FileFound}

              except
              end;  {If not Quit}

            end
          else Result := False;
  try
    SystemTable.Close;
    SystemTable.Free;
  except
  end;

end;  {PASUpdateAvialable}

{==============================================================}
Procedure DoPASUpdate(DriveLetter : String;
                      ProgramDir : String);

var
  SourceFileName, LocalFileName, TempCopyUtilityCommandLine : String;
  CopyUtilityPChar : PChar;
  TempLen : Integer;

begin
  MessageDlg('There is an update available for the Property Assessment System.' + #13 +
             'The program will now close and perform the update.' + #13 +
             'Press OK to continue.',
             mtInformation, [mbOK], 0);

  SourceFileName := DriveLetter + ':' + ProgramDir + 'PAS32.EXE';
  LocalFileName := 'C:' + ProgramDir + 'PAS32.EXE';

    {FXX05082003-1(2.07a): Make sure the update starts from the main network directory.}

  TempCopyUtilityCommandLine := DriveLetter + ':' + ProgramDir +
                                'UpdatePAS.EXE SOURCEFILE=' + SourceFileName +
                                ' LOCALFILE=' + LocalFileName +
                                ' RESTART';

  TempLen := Length(TempCopyUtilityCommandLine);
  CopyUtilityPChar := StrAlloc(TempLen + 1);
  StrPCopy(CopyUtilityPChar, TempCopyUtilityCommandLine);

  WinExec(CopyUtilityPChar, SW_SHOW);
  StrDispose(CopyUtilityPChar);

  Application.Terminate;

end;  {DoPASUpdate}

{==============================================================}
Procedure HideSplashScreen;

begin
  SplashScreenForm.Close;
  SplashScreenForm.Free;
end;

{==============================================================}
{======================  MAIN  ================================}
{==============================================================}

var
  CancelUpdate, Continue, ShowSplash : Boolean;
  I, MajorVersion, MinorVersion : Integer;
  Registry1 : TRegistry;
  DriveLetter, ProgramDir : String;

begin
(*  MemChk;*)
  SetHandleCount(255);
  Continue := True;
  CancelUpdate := False;

  If ((ParamCount = 0) and
       KilledIfPreviousInstance('Property Assessment System'))
    then Continue := False;

(*  If (Continue and
      PASUpdateAvailable(DriveLetter, ProgramDir))
    then
      begin
        Continue := False;
        DoPASUpdate(DriveLetter, ProgramDir);
      end; *)

  If Continue
    then
      begin
          {CHG07192004-1(2.08): Check to make sure that the workstation has all the parameters it needs.}
          
        AddMissingAliases(Session, Application);
        ShowSplash := True;
        For I := 0 to (ParamCount - 1) do
          If (ANSIUpperCase(ParamStr(I + 1)) = 'NOSPLASH')
            then ShowSplash := False;

        If ShowSplash
          then ShowSplashScreen;

        For I := 0 to (ParamCount - 1) do
          If (ANSIUpperCase(ParamStr(I + 1)) = 'CANCELUPDATE')
            then CancelUpdate := True;

           {CHG11262001-2: If the Novell client level is less than 3.21,
                            warn them.}

        Registry1 := TRegistry.Create;
        Registry1.RootKey := HKEY_LOCAL_MACHINE;

        If Registry1.OpenKey('Network\Novell\System Config\Install\Client Version', False)
          then
            begin
              MajorVersion := Registry1.ReadInteger('Major Version');
              MinorVersion := Registry1.ReadInteger('Minor Version');

              If ((MajorVersion = 3) and
                  (MinorVersion < 21))
                then MessageDlg('Warning! The Novell Client version is older than 3.21.' + #13 +
                                'You may receive error messages saying the number of file handles has been exceeded.' + #13 +
                                'Please upgrade the Novell client driver on this station.',
                                mtWarning, [mbOK], 0);

            end;  {If Registry1.OpenKey('Network\Novell\Install\Client Version', False)}

        Registry1.Free;

          {CHG11262001-1: If there are no printer drivers, prevent the app from running.}

        If (Printer.Printers.Count = 0)
          then MessageDlg('There are no printer drivers installed on your system.' + #13 +
                          'You must have at least 1 printer driver installed in Windows,' + #13 +
                          'even if it is not used.' + #13 +
                          'PAS will now shut down.', mtError, [mbOK], 0)
          else
            begin
              Application.Title := 'Property Assessment System';
              Application.HelpFile := '\PASYSTEM\PASHELP.HLP';

              UpdateBDEParameters(Application);

               If ((not CancelUpdate) and
                  PASUpdateAvailable(DriveLetter, ProgramDir))
                then
                  begin
                    If ShowSplash
                      then HideSplashScreen;

                    DoPASUpdate(DriveLetter, ProgramDir);
                  end
                else
                  begin
                    Application.CreateForm(TPASDataModule, PASDataModule);
  Application.CreateForm(TMainPASForm, MainPASForm);
  Application.CreateForm(TLocateParcelForm, LocateParcelForm);
  Application.CreateForm(TChooseTaxYearForm, ChooseTaxYearForm);
  Application.CreateForm(TParcelPrintDialog, ParcelPrintDialog);
  Application.CreateForm(TParcelListDialog, ParcelListDialog);
  Application.CreateForm(TWarningMessageDialog, WarningMessageDialog);
  Application.CreateForm(TReprintingReportForm, ReprintingReportForm);
  Application.CreateForm(TProgressDialog, ProgressDialog);
  Application.CreateForm(TEnhancedSTARTypeDialog, EnhancedSTARTypeDialog);
  Application.CreateForm(TReportDialog, ReportDialog);
  Application.CreateForm(TDocumentTypeDialogForm, DocumentTypeDialogForm);
  Application.CreateForm(TParcelToolbarForm, ParcelToolbarForm);
  Application.CreateForm(THistorySummaryForm, HistorySummaryForm);
  If ShowSplash
                      then HideSplashScreen;

                    Application.Run;

                  end;  {If not PASUpdateAvailable}

            end;  {else of If (Printer.Printers.Count = 0)}

      end;  {If not KilledIfPreviousInstance('Property Assessment System')}

end.