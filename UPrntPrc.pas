unit Uprntprc;

{Print the information selected for a parcel.}

interface

uses Types, DBCtrls, DBTables, DB, PASUtils, RPBase, Utilitys, RPCanvas,
     SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
     RPDefine, Glblcnst, PASTypes, Forms, GlblVars, UtilEXSD,
     WinUtils, DataModule, Dialogs, JPEG, RPMemo, RPDBUtil, TMultiP, DataAccessUnit, ADODB,
     Exchange2XControl1_TLB, ExtCtrls, Printers;

type
  OptionsTypes = (ptBaseInformation, ptAssessments, ptSpecialDistricts,
                  ptExemptions, ptSales, ptPictures,
                  ptResidentialInventory, ptCommercialInventory,
                  ptPrintNextYear,
                  ptSchoolTaxable, ptTownTaxable, ptCountyTaxable,
                  ptNotes, ptPermits, ptSketches, ptPropertyCard);
  OptionsSet = set of OptionsTypes;

Procedure PrintAParcel(Sender : TObject;  {Report printer\filer}
                       SwisSBLKey : String;
                       ProcessingType : Integer;
                       Options : OptionsSet);


implementation

var
  SalesTable: TTable;
  ComSiteTable: TTable;
  ComBldgTable: TTable;
  ComLandTable: TTable;
  ComImprovementTable: TTable;
  ComRentTable: TTable;
  ComIncExpTable: TTable;
  ResForestTable: TTable;
  ResLandTable: TTable;
  ResImprovementTable: TTable;
  ResBldgTable: TTable;
  ResSiteTable: TTable;
  ParcelTable: TTable;
  PriorAssessmentTable: TTable;
  TYAssessmentTable: TTable;
  NYAssessmentTable: TTable;
  ClassTable: TTable;
  ExemptionTable: TTable;
  SDTable: TTable;
  SchoolCodeTable : TTable;
  SwisCodeTable : TTable;
  ExemptionCodeTable : TTable;
  SDCodeTable : TTable;
  NotesTable : TTable;
  tbAssessmentYearControl : TTable;
  tbSketch : TTable;
  ApexXv4 : TExchange2X;
  SketchPanel : TPanel;
  ApexInstalled : Boolean;
  tbPropertyCard : TTable;
  Image: TPMultiImage;

{============================================================================}
Procedure PrintParcelHeader(    Sender : TObject;
                                AssessmentYear : String;
                                Options : OptionsSet;
                            var PicturePrinted : Boolean);

var
  SchoolCodeDesc, SwisCodeDesc : String;
  SwisSBLKey : String;
  PictureTable : TTable;
  Image : TJPEGImage;
  Stream : TMemoryStream;
  Bitmap : TBitmap;
  Palette : HPalette;
  Format: word;
  Data: THandle;
  PMultiImage : TPMultiImage;
  ImageIsValid, ImageIsJPEG : Boolean;

begin
  PictureTable := nil;
  ImageIsJPEG := False;
  with Sender as TBaseReport do
    begin
        {Print the date and page number.}

      SectionTop := 0.25;
      SectionLeft := 0.3;
      SectionRight := PageWidth - 0.5;
      SetFont('Times New Roman',8);
      PrintHeader('Page: ' + IntToStr(CurrentPage), pjRight);
      PrintHeader(AssessmentYear + ' Assessment Year', pjCenter);
      PrintHeader('Date: ' + DateToStr(Date) + '  Time: ' + TimeToStr(Now), pjLeft);

      SectionTop := 0.6;
      SetFont('Times New Roman', 10);
      Underline := False;
      ClearTabs;
      SetTab(0.3, pjLeft, 3.5, 0, BOXLINENONE, 0);   {Left column}
      SetTab(4.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {Right}
      SetTab(6.5, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Right}

      FindKeyOld(SwisCodeTable,
                 ['SwisCode'],
                 [ParcelTable.FieldByName('SwisCode').Text]);
      SwisCodeDesc := SwisCodeTable.FieldByName('MunicipalityName').Text;

      FindKeyOld(SchoolCodeTable,
                 ['SchoolCode'],
                 [ParcelTable.FieldByName('SchoolCode').Text]);
      SchoolCodeDesc := SchoolCodeTable.FieldByName('SchoolName').Text;

        {CHG02132001-1(MDT): Print a picture if there is one.}

      If (ptPictures in Options)
        then
          begin
            SwisSBLKey := ExtractSSKey(ParcelTable);
            PictureTable := PASDataModule.PictureTable;
            PictureTable.CancelRange;

            SetRangeOld(PictureTable,
                        ['SwisSBLKey', 'PictureNumber'],
                        [SwisSBLKey, '0'],
                        [SwisSBLKey, '32000']);

          end;  {If (ptPictures in Options)}

        {FXX03192001-1: Don't print the picture on 2nd page.}

      If ((not (ptPictures in Options)) or
          PictureTable.EOF or
          PicturePrinted)
        then
          begin
               {No picture - leave as is.}

            Bold := True;
            Print(#9 + 'Parcel ID: ');
            Bold := False;
            Print(ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)) + '  (' + Trim(SwisCodeDesc) + ')');
            Bold := True;
            Print(#9 + 'Legal Addr: ');
            Bold := False;
            Println(GetLegalAddressFromTable(ParcelTable));

            Bold := True;
            Print(#9 + 'Name: ');
            Bold := False;
            Print(ParcelTable.FieldByName('Name1').Text);
            Bold := True;
            Print(#9 + 'School: ');
            Bold := False;
            Println(ParcelTable.FieldByName('SchoolCode').Text + '  (' + Trim(SchoolCodeDesc) + ')');

            If GlblParcelMaint_DisplayOldIDUnconverted
              then
                begin
                  Bold := True;
                  Print(#9 + 'Old Print Key: ');
                  Bold := False;
                  Print(ConvertSBLOnlyToOldDashDot(ParcelTable.FieldByName('RemapOldSBL').AsString,
                                                   tbAssessmentYearControl));

                end;  {If GlblParcelMaint_DisplayOldIDUnconverted}

            If (GlblParcelMaint_DisplayAccountNumber or
                glblDisplayAccountNumberOnCard)
              then
                begin
                  Bold := True;
                  Print(#9 + 'Acct #: ');
                  Bold := False;
                  Print(ParcelTable.FieldByName('AccountNo').Text);

                end;  {If GlblParcelMaint_DisplayAccountNumber}

          end
        else
          begin
              {Print the picture.}

            Stream := TMemoryStream.Create;
            Image := TJPEGImage.Create;
            Bitmap := TBitmap.Create;

              {FXX09122002-2: We need to determine the file type first because
                              we can't load a bitmap as a JPEG.}
              {FXX04232003-3(2.07): Make sure that invalid pictures don't cause a problem when print.}

            ImageIsValid := True;
            try
              PMultiImage := TPMultiImage.Create(nil);
              PMultiImage.GetInfoAndType(PictureTable.FieldByName('PictureLocation').Text);

              ImageIsJPEG := ((PMultiImage.BFileType = 'JPG') or
                              (PMultiImage.BFileType = 'JPEG'));

              PMultiImage.Free;
              PMultiImage := nil;
            except
              ImageIsValid := False;
            end;

            If ImageIsValid
              then
                begin
                  try
                    If ImageIsJPEG
                      then
                        begin
                          try
                            Image.LoadFromFile(PictureTable.FieldByName('PictureLocation').Text);
                          except
                            ImageIsValid := False;
                          end;

                          Image.SaveToStream(Stream);
                          Image.DIBNeeded;                   // Convert JPEG to bitmap format

                          Image.SaveToClipboardFormat(Format,Data,Palette);

                             // Load bitmap from clipboard
                          Bitmap.LoadFromClipboardFormat(Format,Data,Palette);

                        end  {If ImageIsJPEG}
                      else
                        try
                          Bitmap.LoadFromFile(PictureTable.FieldByName('PictureLocation').Text);
                        except
                          ImageIsValid := False;
                        end;

                    If ImageIsValid
                      then PrintBitmapRect(0.5,0.5,3.5,3.5,Bitmap);
                    PicturePrinted := True;
                  except
                  end;

                end;  {If ImageIsValid}

            Image.Free;
            Stream.Free;
            Bitmap.Free;

            Image := nil;
            Stream := nil;
            Bitmap := nil;

            Bold := True;
            Print(#9 + #9 + 'Parcel ID: ');
            Bold := False;
            Println(ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)) + '  (' + Trim(SwisCodeDesc) + ')');
            Bold := True;
            Print(#9 + #9 + 'Legal Addr: ');
            Bold := False;
            Println(GetLegalAddressFromTable(ParcelTable));

            Bold := True;
            Print(#9 + #9 + 'Name: ');
            Bold := False;
            Println(ParcelTable.FieldByName('Name1').Text);
            Bold := True;
            Print(#9 + #9 + 'School: ');
            Bold := False;
            Println(ParcelTable.FieldByName('SchoolCode').Text + '  (' + Trim(SchoolCodeDesc) + ')');

            If GlblParcelMaint_DisplayOldIDUnconverted
              then
                begin
                  Bold := True;
                  Print(#9 + #9 + 'Old Print Key: ');
                  Bold := False;
                  Print(ConvertSBLOnlyToOldDashDot(ParcelTable.FieldByName('RemapOldSBL').AsString,
                                                   tbAssessmentYearControl));

                end;  {If GlblParcelMaint_DisplayOldIDUnconverted}

            If (GlblParcelMaint_DisplayAccountNumber or
                glblDisplayAccountNumberOnCard)
              then
                begin
                  Bold := True;
                  Print(#9 + 'Acct #: ');
                  Bold := False;
                  Print(ParcelTable.FieldByName('AccountNo').Text);

                end;  {If GlblParcelMaint_DisplayAccountNumber}

          end;  {else of If PictureTable.EOF}

      If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)
        then
          begin
            Bold := True;
            Println(#9 + '*** INACTIVE ***');
            Bold := False;
          end;  {If (ParcelTable.FieldByName('ActiveFlag').Text = InactiveParcelFlag)}

      Println('');

    end;  {with Sender as TBaseObject do}

end;  {PrintParcelHeader}

{=================================================================================================}
Procedure PrintBaseInformationSection(Sender : TObject;
                                      CodeTable : TTable;
                                      PicturePrinted : Boolean);

var
  NAddrArray : NameAddrArray;
  TempStr : String;
  I : Integer;

begin
  with Sender as TBaseReport, ParcelTable do
    begin
      GetNameAddress(ParcelTable, NAddrArray);

      ClearTabs;
      SetTab(0.3, pjLeft, 3.5, 0, BOXLINENONE, 0);   {Left column}
      SetTab(4.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {Right}
      SetTab(6.1, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Right 2nd col}

      If PicturePrinted
        then
          begin
               {Move the mailing address to the right column and shift down.}

            Bold := True;
            Println(#9 + #9 + 'Mailing Address:');

            Bold := False;
            For I := 1 to 6 do
              Println(#9 + #9 + NAddrArray[I]);

            Bold := True;
            Println(#9 + #9 + 'Property Description');
            Bold := False;
            Println(#9 + #9 + FieldByName('PropDescr1').Text);
            Println(#9 + #9 + FieldByName('PropDescr2').Text);
            Println(#9 + #9 + FieldByName('PropDescr3').Text);

            Bold := True;
            Print(#9 + #9 + 'Bank Code: ');
            Bold := False;
            Print(Take(6, FieldByName('BankCode').Text));
            Bold := True;
            Print(#9 + 'Roll Sect: ');
            Bold := False;
            Println(FieldByName('RollSection').Text);

            Bold := True;
            Print(#9 + #9 + 'Hstd: ');
            Bold := False;
            Print(Take(1, FieldByName('HomesteadCode').Text));
            Bold := True;
            Print(#9 + 'Res %: ');
            Bold := False;
            Println(FormatFloat(IntegerDisplay, FieldByName('ResidentialPercent').AsFloat));

            Bold := True;
            Print(#9 + #9 + 'Prop Class: ');
            Bold := False;
            Println(Take(3, FieldByName('PropertyClassCode').Text) + ' (' +
                    Trim(FieldByName('PropertyClassDesc').Text + ')'));

          end
        else
          begin
              {Name / address and prop desc}

            Bold := True;
            Println(#9 + 'Mailing Address:' +
                    #9 + 'Property Description');
            Bold := False;
            Println(#9 + NAddrArray[1] +
                    #9 + FieldByName('PropDescr1').Text);
            Println(#9 + NAddrArray[2] +
                    #9 + FieldByName('PropDescr2').Text);
            Println(#9 + NAddrArray[3] +
                    #9 + FieldByName('PropDescr3').Text);

            Print(#9 + NAddrArray[4]);
            Bold := True;
            Print(#9 + 'Bank Code: ');
            Bold := False;
            Print(Take(6, FieldByName('BankCode').Text));
            Bold := True;
            Print(#9 + 'Roll Sect: ');
            Bold := False;
            Println(FieldByName('RollSection').Text);

            Print(#9 + NAddrArray[5]);
            Bold := True;
            Print(#9 + 'Hstd: ');
            Bold := False;
            Print(Take(1, FieldByName('HomesteadCode').Text));
            Bold := True;
            Print(#9 + 'Res %: ');
            Bold := False;
            Println(FormatFloat(IntegerDisplay, FieldByName('ResidentialPercent').AsFloat));

            Print(#9 + NAddrArray[6]);
            Bold := True;
            Print(#9 + 'Prop Class: ');
            Bold := False;
            Println(Take(3, FieldByName('PropertyClassCode').Text) + ' (' +
                    Trim(FieldByName('PropertyClassDesc').Text + ')'));

          end;  {else of If PicturePrinted}

      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Left column}
      SetTab(2.3, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Left 2nd col}
      SetTab(4.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {Right}
      SetTab(6.1, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Right 2nd col}

      If (Roundoff(FieldByName('Acreage').AsFloat, 2) > 0)
        then
          begin
            Bold := True;
            Print(#9 + 'Acreage: ');
            Bold := False;
            Print(FormatFloat(DecimalDisplay, FieldByName('Acreage').AsFloat));
            Print(#9 + '');
          end
        else
          begin
            Bold := True;
            Print(#9 + 'Frontage: ');
            Bold := False;
            Print(FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat));
            Bold := True;
            Print(#9 + 'Depth: ');
            Bold := False;
            Print(FormatFloat(DecimalDisplay, FieldByName('Depth').AsFloat));

          end;  {else of If (Roundoff(FieldByName('Acreage').AsFloat, 2) > 0)}

        {CHG12022004-2(2.8.1.1): Show control # if they use it instead.}

      If GlblUseControlNumInsteadOfBook_Page
        then Println('')
        else
          begin
            Bold := True;
            Print(#9 + 'Deed Book: ');
            Bold := False;
            Print(Take(5, FieldByName('DeedBook').Text));
            Bold := True;
            Print(#9 + 'Page: ');
            Bold := False;
            Println(Take(5, FieldByName('DeedPage').Text));

          end;  {else of If GlblUseControlNumInsteadOfBook_Page}

      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BOXLINENONE, 0);   {Left column}
      SetTab(2.3, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Left 2nd col}
      SetTab(4.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {Right}

      Bold := True;
      Print(#9 + 'Coord North: ');
      Bold := False;
      Print(Take(10, FieldByName('GridCordNorth').Text));
      Bold := True;
      Print(#9 + 'East: ');
      Bold := False;
      Print(FieldByName('GridCordEast').Text);
      Bold := True;
      Print(#9 + 'Mortgage Num: ');
      Bold := False;
      Println(FieldByName('MortgageNumber').Text);

      ClearTabs;
      SetTab(0.3, pjLeft, 3.5, 0, BOXLINENONE, 0);   {Left column}
      SetTab(4.0, pjLeft, 3.5, 0, BOXLINENONE, 0);   {Right}
      SetTab(6.1, pjLeft, 1.5, 0, BOXLINENONE, 0);   {Right 2nd col}

      Bold := True;
      Print(#9 + 'Ownership: ');
      Bold := False;
      Print(Take(15, FieldByName('OwnershipDesc').Text));
      Bold := True;
      Print(#9 + 'Land Commitment: ');
      Bold := False;
      TempStr := FieldByName('LandCommitmentDesc').Text;
      If (Deblank(TempStr) = '')
        then TempStr := 'None';
      Println(Take(15, TempStr));

      Bold := True;
      Print(#9 + 'Easement: ');
      Bold := False;
      TempStr := FieldByName('EasementDesc').Text;
      If (Deblank(TempStr) = '')
        then TempStr := 'None';
      Print(Take(15, TempStr));
      Bold := True;
      Print(#9 + 'Commitment End: ');
      Bold := False;
      Println(FieldByName('CommitmentTermYear').Text);

    end;  {with ParcelTable do}

end;  {PrintBaseInformationSection}

{===========================================================================}
Procedure PrintAssessmentSection(Sender : TObject;
                                 SwisSBLKey : String;
                                 ProcessingType : Integer;
                                 EXTotArray : ExemptionTotalsArrayType;
                                 ExemptionCodes,
                                 ExemptionHomesteadCodes,
                                 ResidentialTypes,
                                 CountyExemptionAmounts,
                                 TownExemptionAmounts,
                                 SchoolExemptionAmounts,
                                 VillageExemptionAmounts : TStringList;
                                 BasicSTARAmount,
                                 EnhancedSTARAmount : Comp;
                                 PrintNextYear : Boolean;
                                 Options : OptionsSet);

var
  NYLandVal, NYTotalVal,
  TYLandVal, TYTotalVal,
  PriorLandVal, PriorTotalVal, AssessedVal : Comp;
  FoundNY, FoundTY, FoundPrior : Boolean;
  HistYear : String;
  SchoolTaxableValue, TownTaxableValue,
  CountyTaxableValue, STARAmount : String;
  HstdAssessedVal, NonhstdAssessedVal : Comp;
  HstdEXAmounts, NonhstdEXAmounts : ExemptionTotalsArrayType;

begin
  NYLandVal := 0;
  NYTotalVal := 0;
  TYLandVal := 0;
  TYTotalVal := 0;
  PriorLandVal := 0;
  PriorTotalVal := 0;
  AssessedVal := 0;

  with Sender as TBaseReport do
    begin
      ClearTabs;
      Println('');
      Bold := True;
      SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);   {Prior}
      Println(#9 + 'Assessment Information');
      Println('');

      FoundNY := FindKeyOld(NYAssessmentTable,
                            ['TaxRollYr', 'SwisSBLKey'],
                            [GlblNextYear, SwisSBLKey]);

      If FoundNY
        then
          with NYAssessmentTable do
            begin
              NYLandVal := FieldByName('LandAssessedVal').AsFloat;
              NYTotalVal := FieldByName('TotalAssessedVal').AsFloat;
            end;

      FoundTY := FindKeyOld(TYAssessmentTable,
                            ['TaxRollYr', 'SwisSBLKey'],
                            [GlblThisYear, SwisSBLKey]);

      If FoundTY
        then
          with TYAssessmentTable do
            begin
              TYLandVal := FieldByName('LandAssessedVal').AsFloat;
              TYTotalVal := FieldByName('TotalAssessedVal').AsFloat;
            end;

      HistYear := IntToStr(StrToInt(GlblThisYear) - 1);
      FoundPrior := FindKeyOld(PriorAssessmentTable,
                               ['TaxRollYr', 'SwisSBLKey'],
                               [HistYear, SwisSBLKey]);

      If FoundPrior
        then
          with PriorAssessmentTable do
            begin
              PriorLandVal := FieldByName('LandAssessedVal').AsFloat;
              PriorTotalVal := FieldByName('TotalAssessedVal').AsFloat;
            end
        else
          If FoundTY  {Look in the TY fields if not in history.}
            then
              with TYAssessmentTable do
                begin
                  PriorLandVal := FieldByName('PriorLandValue').AsFloat;
                  PriorTotalVal := FieldByName('PriorTotalValue').AsFloat;
                end;

        {FXX05132009-2(2.20.1.1)[D1494]: Don't print NY values if user is restricted from seeing them.}
        {FXX10122009-1(2.20.1.20)[D1561]: The NY value was not printing.}

      If (GlblUserIsSearcher and
          (not SearcherCanSeeNYValues))
        then PrintNextYear := False;

         {Year headers}

      Bold := True;

      ClearTabs;
      SetTab(0.3, pjCenter, 2.3, 0, BoxLineAll, 25);   {Prior}
      SetTab(3.0, pjCenter, 2.3, 0, BoxLineAll, 25);   {TY}
      SetTab(5.7, pjCenter, 2.3, 0, BoxLineAll, 25);   {NY}

        {FXX12081999-1: Make sure that if they are not allowed to see NY,
                        we don't print it.}

      Print(#9 + HistYear +
            #9 + GlblThisYear);

      If PrintNextYear
        then Println(#9 + GlblNextYear)
        else Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 1.1, 0, BoxLineAll, 25);   {Land}
      SetTab(1.4, pjCenter, 1.2, 0, BoxLineAll, 25);   {Total}
      SetTab(3.0, pjCenter, 1.1, 0, BoxLineAll, 25);   {Land}
      SetTab(4.1, pjCenter, 1.2, 0, BoxLineAll, 25);   {Total}
      SetTab(5.7, pjCenter, 1.1, 0, BoxLineAll, 25);   {Land}
      SetTab(6.8, pjCenter, 1.2, 0, BoxLineAll, 25);   {Total}

      Print(#9 + 'Land' +
            #9 + 'Total' +
            #9 + 'Land' +
            #9 + 'Total');

      If PrintNextYear
        then Println(#9 + 'Land' +
                     #9 + 'Total')
        else Println('');

      ClearTabs;
      SetTab(0.3, pjRight, 1.1, 2, BoxLineAll, 0);   {Land}
      SetTab(1.4, pjRight, 1.2, 2, BoxLineAll, 0);   {Total}
      SetTab(3.0, pjRight, 1.1, 2, BoxLineAll, 0);   {Land}
      SetTab(4.1, pjRight, 1.2, 2, BoxLineAll, 0);   {Total}
      SetTab(5.7, pjRight, 1.1, 2, BoxLineAll, 0);   {Land}
      SetTab(6.8, pjRight, 1.2, 2, BoxLineAll, 0);   {Total}

      Bold := False;

      Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, PriorLandVal) +
            #9 + FormatFloat(NoDecimalDisplay_BlankZero, PriorTotalVal) +
            #9 + FormatFloat(NoDecimalDisplay_BlankZero, TYLandVal) +
            #9 + FormatFloat(NoDecimalDisplay_BlankZero, TYTotalVal));

      If PrintNextYear
        then Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, NYLandVal) +
                     #9 + FormatFloat(NoDecimalDisplay_BlankZero, NYTotalVal))
        else Println('');

        {Taxable values}

      case ProcessingType of
        History : AssessedVal := PriorTotalVal;
        ThisYear : AssessedVal := TYTotalVal;
        NextYear : AssessedVal := NYTotalVal;
      end;

        {If they are not allowed to see NY, then show TY taxable values.}

      If not PrintNextYear
        then AssessedVal := TYTotalVal;

      Bold := True;
      Println('');

      ClearTabs;
      SetTab(1.3, pjCenter, 1.2, 2, BOXLINEAll, 25);   {County}
      SetTab(2.7, pjCenter, 1.2, 2, BOXLINEAll, 25);   {Town}
      SetTab(4.1, pjCenter, 1.2, 2, BOXLINEAll, 25);   {School}
      SetTab(5.5, pjCenter, 1.2, 2, BOXLINEAll, 25);   {STAR}

      Bold := True;
      Println(#9 + 'County Taxable' +
              #9 + GetMunicipalityTypeName(GlblMunicipalityType) + ' Taxable'+
              #9 + 'School Taxable' +
              #9 + 'STAR Amount');

      Bold := False;
      ClearTabs;
      SetTab(1.3, pjRight, 1.2, 2, BOXLINEAll, 0);   {County}
      SetTab(2.7, pjRight, 1.2, 2, BOXLINEAll, 0);   {Town}
      SetTab(4.1, pjRight, 1.2, 2, BOXLINEAll, 0);   {School}
      SetTab(5.5, pjRight, 1.2, 2, BOXLINEAll, 0);   {STAR}

        {CHG09192001-2: Allow them to select which taxable values to show.}

      If (ptSchoolTaxable in Options)
        then
          begin
            SchoolTaxableValue := FormatFloat(CurrencyDisplayNoDollarSign,
                                              (AssessedVal - EXTotArray[EXSchool]));
            STARAmount := FormatFloat(CurrencyDisplayNoDollarSign,
                                      (BasicSTARAmount + EnhancedSTARAmount));
          end
        else
          begin
            SchoolTaxableValue := 'N/A';
            STARAmount := 'N/A';
          end;

      If (ptTownTaxable in Options)
        then TownTaxableValue := FormatFloat(CurrencyDisplayNoDollarSign,
                                             (AssessedVal - EXTotArray[EXTown]))
        else TownTaxableValue := 'N/A';

      If (ptCountyTaxable in Options)
        then CountyTaxableValue := FormatFloat(CurrencyDisplayNoDollarSign,
                                               (AssessedVal - EXTotArray[EXCounty]))
        else CountyTaxableValue := 'N/A';

      Println(#9 + CountyTaxableValue +
              #9 + TownTaxableValue +
              #9 + SchoolTaxableValue +
              #9 + STARAmount);

      Println('');

        {FXX05072002-2: Print classified information if this is a split parcel.}

      If FindKeyOld(ClassTable, ['TaxRollYr', 'SwisSBLKey'],
                    [GetTaxRollYearForProcessingType(ProcessingType), SwisSBLKey])
        then
          begin
            ClearTabs;
            Println('');
            Bold := True;
            SetTab(0.1, pjCenter, 7.8, 0, BOXLINENone, 0);   {Prior}
            Println(#9 + GetTaxRollYearForProcessingType(ProcessingType) +
                         'Class Information');
            Println('');

            ClearTabs;
            SetTab(0.3, pjCenter, 0.7, 2, BOXLINEAll, 25);   {Hsdt\Nonhstd Column}
            SetTab(1.0, pjCenter, 0.6, 2, BOXLINEAll, 25);   {Acres}
            SetTab(1.6, pjCenter, 0.6, 2, BOXLINEAll, 25);   {Land %}
            SetTab(2.2, pjCenter, 1.0, 2, BOXLINEAll, 25);   {Land Val}
            SetTab(3.2, pjCenter, 0.6, 2, BOXLINEAll, 25);   {Total %}
            SetTab(3.8, pjCenter, 1.1, 2, BOXLINEAll, 25);   {Total Val}
            SetTab(4.9, pjCenter, 1.1, 2, BOXLINEAll, 25);   {County Taxable}
            SetTab(6.0, pjCenter, 1.1, 2, BOXLINEAll, 25);   {Town Taxable}
            SetTab(7.1, pjCenter, 1.1, 2, BOXLINEAll, 25);   {School Taxable}

            Println(#9 + #9 + 'Acres' +
                    #9 + 'Land %' +
                    #9 + 'Land Value' +
                    #9 + 'Total %' +
                    #9 + 'Total Value' +
                    #9 + 'County Taxable' +
                    #9 + 'Town Taxable' +
                    #9 + 'School Taxable');

            ClearTabs;
            SetTab(0.3, pjLeft, 0.7, 2, BOXLINEAll, 0);   {Hsdt\Nonhstd Column}
            SetTab(1.0, pjRight, 0.6, 2, BOXLINEAll, 0);   {Acres}
            SetTab(1.6, pjRight, 0.6, 2, BOXLINEAll, 0);   {Land %}
            SetTab(2.2, pjRight, 1.0, 2, BOXLINEAll, 0);   {Land Val}
            SetTab(3.2, pjRight, 0.6, 2, BOXLINEAll, 0);   {Total %}
            SetTab(3.8, pjRight, 1.1, 2, BOXLINEAll, 0);   {Total Val}
            SetTab(4.9, pjRight, 1.1, 2, BOXLINEAll, 0);   {County Taxable}
            SetTab(6.0, pjRight, 1.1, 2, BOXLINEAll, 0);   {Town Taxable}
            SetTab(7.1, pjRight, 1.1, 2, BOXLINEAll, 0);   {School Taxable}

            with ClassTable do
              begin
                HstdAssessedVal := FieldByName('HstdTotalVal').AsFloat;
                NonhstdAssessedVal := FieldByName('NonhstdTotalVal').AsFloat;

                GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                                       ExemptionHomesteadCodes,
                                                       CountyExemptionAmounts,
                                                       TownExemptionAmounts,
                                                       SchoolExemptionAmounts,
                                                       VillageExemptionAmounts,
                                                       HstdEXAmounts,
                                                       NonhstdEXAmounts);

                Println(#9 + 'Hstd' +
                        #9 + FormatFloat(DecimalEditDisplay,
                                         FieldByName('HstdAcres').AsFloat) +
                        #9 + FormatFloat(DecimalEditDisplay,
                                         FieldByName('HstdLandPercent').AsFloat) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('HstdLandVal').AsFloat) +
                        #9 + FormatFloat(DecimalEditDisplay,
                                         FieldByName('HstdTotalPercent').AsFloat) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('HstdTotalVal').AsFloat) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         (HstdAssessedVal - HstdExAmounts[EXCounty])) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         (HstdAssessedVal - HstdExAmounts[EXTown])) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         (HstdAssessedVal - HstdExAmounts[EXSchool])));

                Println(#9 + 'Nonhstd' +
                        #9 + FormatFloat(DecimalEditDisplay,
                                         FieldByName('NonhstdAcres').AsFloat) +
                        #9 + FormatFloat(DecimalEditDisplay,
                                         FieldByName('NonhstdLandPercent').AsFloat) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('NonhstdLandVal').AsFloat) +
                        #9 + FormatFloat(DecimalEditDisplay,
                                         FieldByName('NonhstdTotalPercent').AsFloat) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         FieldByName('NonhstdTotalVal').AsFloat) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         (NonhstdAssessedVal - NonhstdExAmounts[EXCounty])) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         (NonhstdAssessedVal - NonhstdExAmounts[EXTown])) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                         (NonhstdAssessedVal - NonhstdExAmounts[EXSchool])));

              end;  {with ClassTable do}

          end;  {If FindKeyOld(ClassTable ...}

    end;  {with Sender as TBaseReport do}

end;  {PrintAssessmentSection}

{===========================================================================}
Procedure PrintExemptionSection(Sender : TObject;
                                AssessmentYear : String;
                                SwisSBLKey : String;
                                ExemptionCodes,
                                ExemptionHomesteadCodes,
                                ResidentialTypes,
                                CountyExemptionAmounts,
                                TownExemptionAmounts,
                                SchoolExemptionAmounts,
                                VillageExemptionAmounts : TStringList;
                                BasicSTARAmount,
                                EnhancedSTARAmount : Comp);

var
  I : Integer;

begin
  If (Roundoff(BasicSTARAmount, 0) > 0)
    then
      begin
        ExemptionCodes.Add(BasicSTARExemptionCode);
        CountyExemptionAmounts.Add('0');
        TownExemptionAmounts.Add('0');
        SchoolExemptionAmounts.Add(FloatToStr(BasicSTARAmount));
        VillageExemptionAmounts.Add('0');

      end;  {If (Roundoff(BasicSTARAmount, 0) > 0)}

  If (Roundoff(EnhancedSTARAmount, 0) > 0)
    then
      begin
        ExemptionCodes.Add(EnhancedSTARExemptionCode);
        CountyExemptionAmounts.Add('0');
        TownExemptionAmounts.Add('0');
        SchoolExemptionAmounts.Add(FloatToStr(EnhancedSTARAmount));
        VillageExemptionAmounts.Add('0');

      end;  {If (Roundoff(EnhancedSTARAmount, 0) > 0)}

  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
      ClearTabs;
      SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);   {Prior}
      Println(#9 + 'Exemption Information');
      Println('');

      If (ExemptionCodes.Count = 0)
        then
          begin
            Bold := False;
            ClearTabs;
            SetTab(0.3, pjLeft, 2.0, 0, BOXLINENone, 0);   {None}
            Println(#9 + 'No exemptions.');
          end
        else
          begin
            ClearTabs;
            SetTab(0.9, pjCenter, 0.6, 0, BoxLineAll, 25);   {EX Code}
            SetTab(1.5, pjCenter, 1.1, 0, BoxLineAll, 25);   {EX Desc}
            SetTab(2.6, pjCenter, 1.1, 0, BoxLineAll, 25);   {County}
            SetTab(3.7, pjCenter, 1.1, 0, BoxLineAll, 25);   {Town}
            SetTab(4.8, pjCenter, 1.1, 0, BoxLineAll, 25);   {School}
            SetTab(5.9, pjCenter, 1.1, 0, BoxLineAll, 25);   {Village}

            Println(#9 + 'Code' +
                    #9 + 'Description' +
                    #9 + 'County' +
                    #9 + GetMunicipalityTypeName(GlblMunicipalityType) +
                    #9 + 'School' +
                    #9 + 'Village');

            ClearTabs;
            SetTab(0.9, pjLeft, 0.6, 4, BoxLineAll, 0);   {EX Code}
            SetTab(1.5, pjLeft, 1.1, 4, BoxLineAll, 0);   {EX Desc}
            SetTab(2.6, pjRight, 1.1, 4, BoxLineAll, 0);   {County}
            SetTab(3.7, pjRight, 1.1, 4, BoxLineAll, 0);   {Town}
            SetTab(4.8, pjRight, 1.1, 4, BoxLineAll, 0);   {School}
            SetTab(5.9, pjRight, 1.1, 4, BoxLineAll, 0);   {Village}

            Bold := False;

            For I := 0 to (ExemptionCodes.Count - 1) do
              begin
                FindKeyOld(ExemptionCodeTable, ['EXCode'],
                           [ExemptionCodes[I]]);

                Println(#9 + ExemptionCodes[I] +
                        #9 + ExemptionCodeTable.FieldByName('Description').Text +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         StrToFloat(CountyExemptionAmounts[I])) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         StrToFloat(TownExemptionAmounts[I])) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         StrToFloat(SchoolExemptionAmounts[I])) +
                        #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                         StrToFloat(VillageExemptionAmounts[I])));

              end;  {For I := 0 to (ExemptionCodes.Count - 1) do}

          end;  {else of If (ExemptionCodes.Count = 0)}

    end;  {with Sender as TBaseReport do}

end;  {PrintExemptionSection}

{===========================================================================}
Procedure PrintSales(Sender : TObject;
                     SwisSBLKey : String);

var
  Done, FirstTimeThrough : Boolean;
  NumSales : Integer;
  TempValidStr, TempSaleType : String;

begin
  Done := False;
  FirstTimeThrough := True;
  NumSales := 0;

  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
      ClearTabs;
      SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);   {Prior}
      Println(#9 + 'Sales Information');
      Println('');

    end;  {with Sender as TBaseReport do}

  SetRangeOld(SalesTable, ['SwisSBLKey', 'SaleNumber'],
              [SwisSBLKey, '0'], [SwisSBLKey, '32000']);

  SalesTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SalesTable.Next;

    If SalesTable.EOF
      then Done := True;

    If not Done
      then
        begin
          NumSales := NumSales + 1;

          with Sender as TBaseReport, SalesTable do
            begin
              If (NumSales = 1)
                then
                  begin
                    ClearTabs;
                    SetTab(0.3, pjCenter, 0.2, 0, BoxLineAll, 25);   {#}
                    SetTab(0.5, pjCenter, 1.0, 0, BoxLineAll, 25);   {Sale Price}
                    SetTab(1.5, pjCenter, 0.8, 0, BoxLineAll, 25);   {Sale Date}
                    SetTab(2.3, pjCenter, 0.5, 0, BoxLineAll, 25);   {Valid}
                    SetTab(2.8, pjCenter, 1.0, 0, BoxLineAll, 25);   {Sale type}
                    SetTab(3.8, pjCenter, 1.4, 0, BoxLineAll, 25);   {Old Owner}

                      {CHG12022004-2(2.8.1.1): Show control # if they use it instead.}

                    If GlblUseControlNumInsteadOfBook_Page
                      then SetTab(5.2, pjCenter, 1.0, 0, BoxLineAll, 25) {Control #}
                      else
                        begin
                          SetTab(5.2, pjCenter, 0.5, 0, BoxLineAll, 25);   {Deed Book}
                          SetTab(5.7, pjCenter, 0.5, 0, BoxLineAll, 25);   {Deed page}
                        end;

                    SetTab(6.2, pjCenter, 0.8, 0, BoxLineAll, 25);   {Deed type}
                    SetTab(7.0, pjCenter, 0.8, 0, BoxLineAll, 25);   {Deed date}

                    Print(#9 + '#' +
                          #9 + 'Sale Price' +
                          #9 + 'Sale Date' +
                          #9 + 'Valid' +
                          #9 + 'Sale Type' +
                          #9 + 'Old Owner');

                      {CHG12022004-2(2.8.1.1): Show control # if they use it instead.}

                    If GlblUseControlNumInsteadOfBook_Page
                      then Print(#9 + 'Control #')
                      else Print(#9 + 'Book' +
                                 #9 + 'Page');

                    Println(#9 + 'Deed Type' +
                            #9 + 'Deed Date');

                    Bold := False;

                    ClearTabs;
                    SetTab(0.3, pjRight, 0.2, 0, BoxLineAll, 0);   {#}
                    SetTab(0.5, pjRight, 1.0, 4, BoxLineAll, 0);   {Sale Price}
                    SetTab(1.5, pjCenter, 0.8, 0, BoxLineAll, 0);   {Sale Date}
                    SetTab(2.3, pjCenter, 0.5, 0, BoxLineAll, 0);   {Valid}
                    SetTab(2.8, pjLeft, 1.0, 4, BoxLineAll, 0);   {Sale type}
                    SetTab(3.8, pjLeft, 1.4, 4, BoxLineAll, 0);   {Old Owner}

                      {CHG12022004-2(2.8.1.1): Show control # if they use it instead.}

                    If GlblUseControlNumInsteadOfBook_Page
                      then SetTab(5.2, pjLeft, 1.0, 0, BoxLineAll, 0) {Control #}
                      else
                        begin
                          SetTab(5.2, pjLeft, 0.5, 0, BoxLineAll, 0);   {Deed Book}
                          SetTab(5.7, pjLeft, 0.5, 0, BoxLineAll, 0);   {Deed page}
                        end;

                    SetTab(6.2, pjLeft, 0.8, 4, BoxLineAll, 0);   {Deed type}
                    SetTab(7.0, pjCenter, 0.8, 0, BoxLineAll, 0);   {Deed date}

                  end;  {If (NumSales = 1)}

              If FieldByName('ValidSale').AsBoolean
                then TempValidStr := 'Yes'
                else TempValidStr := 'No';

              TempSaleType := '';

              case Take(1, FieldByName('SaleTypeCode').Text)[1] of
                '1' : TempSaleType := 'Land';
                '2' : TempSaleType := 'Building';
                '3' : TempSaleType := 'Land\Bldg';
              end;  {case FieldByName('SaleTypeCode').Text[1] of}

              Print(#9 + FieldByName('SaleNumber').Text +
                    #9 + FormatFloat(NoDecimalDisplay_BlankZero,
                                     FieldByName('SalePrice').AsFloat) +
                    #9 + FieldByName('SaleDate').Text +
                    #9 + TempValidStr +
                    #9 + TempSaleType +
                    #9 + Take(14, FieldByName('OldOwnerName').Text));

                {CHG12022004-2(2.8.1.1): Show control # if they use it instead.}

              If GlblUseControlNumInsteadOfBook_Page
                then Print(#9 + FieldByName('ControlNo').Text)
                else Print(#9 + FieldByName('DeedBook').Text +
                           #9 + FieldByName('DeedPage').Text);

              Println(#9 + Take(10, FieldByName('DeedTypeDesc').Text) +
                      #9 + FieldByName('DeedDate').Text);

            end;  {with Sender as TBaseReport, SalesTable do}

        end;  {If not Done}

  until Done;

  If (NumSales = 0)
    then
      with Sender as TBaseReport do
        begin
          Bold := False;
          ClearTabs;
          SetTab(0.3, pjLeft, 2.0, 0, BOXLINENone, 0);   {None}
          Println(#9 + 'No recorded sales.');

        end;  {If (NumSales = 0)}

end;  {PrintSales}

{===============================================================================}
Procedure PrintSpecialDistrictSectionHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
      ClearTabs;
      SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);   {Prior}
      Println(#9 + 'Special District Information');
      Println('');

      ClearTabs;
      SetTab(1.0, pjCenter, 0.6, 0, BoxLineAll, 25);   {SD Code}
      SetTab(1.6, pjCenter, 1.6, 0, BoxLineAll, 25);   {SD Desc}
      SetTab(3.2, pjCenter, 0.3, 0, BoxLineAll, 25);   {Calc code}
      SetTab(3.5, pjCenter, 0.3, 0, BoxLineAll, 25);   {Percent}
      SetTab(3.8, pjCenter, 1.0, 0, BoxLineAll, 25);   {Units}
      SetTab(4.8, pjCenter, 1.0, 0, BoxLineAll, 25);   {2nd Units}
      SetTab(5.8, pjCenter, 1.2, 0, BoxLineAll, 25);   {Amount}

        {CHG12022004-3(2.8.1.1): Show extended amounts on the print out.}

      If GlblShowExtendedSDAmounts
        then SetTab(7.0, pjCenter, 1.2, 0, BoxLineAll, 25); {Extended Amount}

      Print(#9 + 'Code' +
            #9 + 'Description' +
            #9 + 'Calc' +
            #9 + '%' +
            #9 + 'Units' +
            #9 + 'Secondary Units' +
            #9 + 'Amount');

        {CHG12022004-3(2.8.1.1): Show extended amounts on the print out.}

      If GlblShowExtendedSDAmounts
        then Println(#9 + 'Taxable Val')
        else Println('');

      Bold := False;

      ClearTabs;
      SetTab(1.0, pjLeft, 0.6, 4, BoxLineAll, 0);   {SD Code}
      SetTab(1.6, pjLeft, 1.6, 4, BoxLineAll, 0);   {SD Desc}
      SetTab(3.2, pjCenter, 0.3, 0, BoxLineAll, 0);   {Calc code}
      SetTab(3.5, pjRight, 0.3, 4, BoxLineAll, 0);   {Percent}
      SetTab(3.8, pjRight, 1.0, 4, BoxLineAll, 0);   {Units}
      SetTab(4.8, pjRight, 1.0, 4, BoxLineAll, 0);   {2nd Units}
      SetTab(5.8, pjRight, 1.2, 4, BoxLineAll, 0);   {Amount}

        {CHG12022004-3(2.8.1.1): Show extended amounts on the print out.}

      If GlblShowExtendedSDAmounts
        then SetTab(7.0, pjRight, 1.2, 0, BoxLineAll, 0); {Extended Amount}

    end;  {with Sender as TBaseReport do}

end;  {PrintSpecialDistrictSectionHeader}

{===========================================================================}
Procedure PrintSpecialDistrictSection(    Sender : TObject;
                                          AssessmentYear : String;
                                          ProcessingType : Integer;
                                          SwisSBLKey : String;
                                          Options : OptionsSet;
                                      var PicturePrinted : Boolean);

var
  Done, FirstTimeThrough : Boolean;
  NumSDs : Integer;
  TempAmountStr : String;
  SDExtensionCodes, SDCC_OMFlags,
  SDValues, HomesteadCodesList, slAssessedValues : TStringList;
  ParcelExemptionList, ExemptionCodeList : TList;
  AssessmentTable : TTable;

begin
  Done := False;
  FirstTimeThrough := True;
  NumSDs := 0;
  AssessmentTable := nil;

  SetRangeOld(SDTable, ['TaxRollYr', 'SwisSBLKey', 'SDistCode'],
              [AssessmentYear, SwisSBLKey, '     '],
              [AssessmentYear, SwisSBLKey, 'ZZZZZ']);

  SDTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else SDTable.Next;

    If SDTable.EOF
      then Done := True;

    If not Done
      then
        begin
          NumSDs := NumSDs + 1;

          with Sender as TBaseReport, SDTable do
            begin
              If (LinesLeft < 8)
                then
                  begin
                    NewPage;
                    PrintParcelHeader(Sender, AssessmentYear, Options, PicturePrinted);
                    PrintSpecialDistrictSectionHeader(Sender);
                  end
                else
                  If (NumSDs = 1)
                    then PrintSpecialDistrictSectionHeader(Sender);

              FindKeyOld(SDCodeTable, ['SDistCode'],
                         [FieldByName('SDistCode').Text]);

              TempAmountStr := '';

              If (Roundoff(FieldByName('CalcAmount').AsFloat, 2) > 0)
                then
                  If (SDCodeTable.FieldByName('DistrictType').Text = SDExtCatF)
                    then TempAmountStr := FormatFloat(DecimalDisplay_BlankZero,
                                                      FieldByName('CalcAmount').AsFloat)
                    else TempAmountStr := FormatFloat(NoDecimalDisplay_BlankZero,
                                                      FieldByName('CalcAmount').AsFloat);

              Print(#9 + FieldByName('SDistCode').Text +
                    #9 + Take(17, SDCodeTable.FieldByName('Description').Text) +
                    #9 + FieldByName('CalcCode').Text +
                    #9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('SDPercentage').AsFloat) +
                    #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('PrimaryUnits').AsFloat) +
                    #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('SecondaryUnits').AsFloat) +
                    #9 + TempAmountStr);

                {CHG12022004-3(2.8.1.1): Show extended amounts on the print out.}

              If GlblShowExtendedSDAmounts
                then
                  begin
                    SDExtensionCodes := TStringList.Create;
                    SDCC_OMFlags := TStringList.Create;
                    SDValues := TStringList.Create;
                    ParcelExemptionList := TList.Create;
                    ExemptionCodeList := TList.Create;
                    HomesteadCodesList := TStringList.Create;
                    slAssessedValues := TStringList.Create;

                    case ProcessingType of
                      History : AssessmentTable := PriorAssessmentTable;
                      ThisYear : AssessmentTable := TYAssessmentTable;
                      NextYear : AssessmentTable := NYAssessmentTable;
                    end;

                    LoadExemptions(AssessmentYear, SwisSBLKey,
                                   ParcelExemptionList, ExemptionCodeList,
                                   ExemptionTable, ExemptionCodeTable);

                    CalculateSpecialDistrictAmounts(ParcelTable, AssessmentTable,
                                                    ClassTable, SDTable, SDCodeTable,
                                                    ParcelExemptionList,
                                                    ExemptionCodeList,
                                                    SDExtensionCodes,
                                                    SDCC_OMFlags,
                                                    slAssessedValues,
                                                    SDValues,
                                                    HomesteadCodesList);

                    try
                      Println(#9 + SDValues[0]);
                    except
                    end;

                    SDExtensionCodes.Free;
                    SDCC_OMFlags.Free;
                    SDValues.Free;
                    HomesteadCodesList.Free;
                    slAssessedValues.Free;
                    FreeTList(ParcelExemptionList, SizeOf(ParcelExemptionRecord));
                    FreeTList(ExemptionCodeList, SizeOf(ExemptionCodeRecord));

                  end
                else Println('');

            end;  {with Sender as TBaseReport, SDsTable do}

        end;  {If not Done}

  until Done;

  If (NumSDs = 0)
    then
      with Sender as TBaseReport do
        begin
          Bold := False;
          ClearTabs;
          SetTab(0.3, pjLeft, 2.0, 0, BOXLINENone, 0);   {None}
          Println(#9 + 'No Special Districts.');

        end;  {with Sender as TBaseReport do}

end;  {PrintSpecialDistrictSection}

{===========================================================================}
{===============  INVENTORY   ==============================================}
{===========================================================================}
Procedure PrintSiteHeader(    Sender : TObject;
                              AssessmentYear : String;
                              SiteNumber : Integer;
                              Residential : Boolean;
                              SiteContinued : Boolean;
                              Options : OptionsSet;
                          var PicturePrinted : Boolean);

var
  TempStr : String;

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;

        {FXX04272001-3: Cutting off a few lines of the bldg in a few cases,
                        had to increase the linesleft.}

      If (LinesLeft < 30)
        then
          begin
            NewPage;
            PrintParcelHeader(Sender, AssessmentYear, Options, PicturePrinted);
            SetTab(0.1, pjCenter, 7.8, 0, BOXLINENone, 0);   {Prior}
          end
        else SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);

      Println('');
      Bold := True;

      If Residential
        then TempStr := 'Residential Site ' + IntToStr(SiteNumber)
        else TempStr := 'Commercial Site ' + IntToStr(SiteNumber);

      If SiteContinued
        then TempStr := TempStr + ' (continued)';

      Italic := True;
      Println(#9 + TempStr);
      Italic := False;

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintSiteHeader}

{===========================================================================}
Procedure PrintLandSectionHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
      ClearTabs;
      SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);   {Prior}
      Println('');
      Println(#9 + 'Land Information');
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 0.2, 0, BoxLineAll, 0);   {#}
      SetTab(0.5, pjCenter, 1.2, 0, BoxLineAll, 0);   {Land type}
      SetTab(1.7, pjCenter, 0.5, 0, BoxLineAll, 0);   {Frontage}
      SetTab(2.2, pjCenter, 0.5, 0, BoxLineAll, 0);   {Depth}
      SetTab(2.7, pjCenter, 0.8, 0, BoxLineAll, 0);   {Acres}
      SetTab(3.5, pjCenter, 0.8, 0, BoxLineAll, 0);   {Sq Ft}
      SetTab(4.3, pjCenter, 0.8, 0, BoxLineAll, 0);   {Influence}
      SetTab(5.1, pjCenter, 0.4, 0, BoxLineAll, 0);   {Soil Rating}
      SetTab(5.5, pjCenter, 0.7, 0, BoxLineAll, 0);   {Waterfront}
      SetTab(6.2, pjCenter, 1.0, 0, BoxLineAll, 0);   {Land val}
      SetTab(7.2, pjCenter, 0.7, 0, BoxLineAll, 0);   {Unit Val}

      Println(#9 + '#' +
              #9 + 'Land Type' +
              #9 + 'Frntg' +
              #9 + 'Depth' +
              #9 + 'Acres' +
              #9 + 'Sq Feet' +
              #9 + 'Influence' +
              #9 + 'Soil' +
              #9 + 'Wtrfrnt' +
              #9 + 'Land Val' +
              #9 + 'Unit Val');

      Bold := False;

      ClearTabs;
      SetTab(0.3, pjCenter, 0.2, 4, BoxLineAll, 0);   {#}
      SetTab(0.5, pjLeft, 1.2, 4, BoxLineAll, 0);   {Land type}
      SetTab(1.7, pjRight, 0.5, 4, BoxLineAll, 0);   {Frontage}
      SetTab(2.2, pjRight, 0.5, 4, BoxLineAll, 0);   {Depth}
      SetTab(2.7, pjRight, 0.8, 4, BoxLineAll, 0);   {Acres}
      SetTab(3.5, pjRight, 0.8, 4, BoxLineAll, 0);   {Sq Ft}
      SetTab(4.3, pjLeft, 0.8, 4, BoxLineAll, 0);   {Influence}
      SetTab(5.1, pjLeft, 0.4, 4, BoxLineAll, 0);   {Soil Rating}
      SetTab(5.5, pjLeft, 0.7, 4, BoxLineAll, 0);   {Waterfront}
      SetTab(6.2, pjRight, 1.0, 4, BoxLineAll, 0);   {Land val}
      SetTab(7.2, pjRight, 0.7, 4, BoxLineAll, 0);   {Unit Val}

    end;  {with Sender as TBaseReport do}

end;  {PrintLandSectionHeader}

{===========================================================================}
Procedure PrintImprovementSectionHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
      ClearTabs;
      SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);   {Prior}
      Println('');
      Println(#9 + 'Improvement Information');
      Println('');

      ClearTabs;
      SetTab(0.3, pjCenter, 0.2, 0, BoxLineAll, 0);   {#}
      SetTab(0.5, pjCenter, 1.2, 0, BoxLineAll, 0);   {Structue}
      SetTab(1.7, pjCenter, 0.4, 0, BoxLineAll, 0);   {Year Built}
      SetTab(2.1, pjCenter, 0.4, 0, BoxLineAll, 0);   {Dimensions}
      SetTab(2.5, pjCenter, 0.6, 0, BoxLineAll, 0);   {Dim 1}
      SetTab(3.1, pjCenter, 0.6, 0, BoxLineAll, 0);   {Dim 2}
      SetTab(3.7, pjCenter, 0.4, 0, BoxLineAll, 0);   {Qty}
      SetTab(4.1, pjCenter, 0.3, 0, BoxLineAll, 0);   {Grade}
      SetTab(4.4, pjCenter, 0.4, 0, BoxLineAll, 0);   {Cond}
      SetTab(4.8, pjCenter, 0.6, 0, BoxLineAll, 0);   {Func Obs}
      SetTab(5.4, pjCenter, 0.6, 0, BoxLineAll, 0);   {% Good}
      SetTab(6.0, pjCenter, 1.0, 0, BoxLineAll, 0);   {RCN}
      SetTab(7.0, pjCenter, 1.0, 0, BoxLineAll, 0);   {RCN - Depreciation}

      Println(#9 + '#' +
              #9 + 'Structure' +
              #9 + 'Year' +
              #9 + 'Dim' +
              #9 + 'Dim 1' +
              #9 + 'Dim 2' +
              #9 + 'Qty' +
              #9 + 'Grd' +
              #9 + 'Cond' +
              #9 + 'Fnc Obs' +
              #9 + '% Good' +
              #9 + 'Rplc Cost' +
              #9 + 'Less Dprc');

      Bold := False;

      ClearTabs;
      SetTab(0.3, pjCenter, 0.2, 4, BoxLineAll, 0);   {#}
      SetTab(0.5, pjLeft, 1.2, 4, BoxLineAll, 0);   {Structue}
      SetTab(1.7, pjLeft, 0.4, 4, BoxLineAll, 0);   {Year Built}
      SetTab(2.1, pjLeft, 0.4, 4, BoxLineAll, 0);   {Dimensions}
      SetTab(2.5, pjRight, 0.6, 4, BoxLineAll, 0);   {Dim 1}
      SetTab(3.1, pjRight, 0.6, 4, BoxLineAll, 0);   {Dim 2}
      SetTab(3.7, pjRight, 0.4, 4, BoxLineAll, 0);   {Qty}
      SetTab(4.1, pjCenter, 0.3, 4, BoxLineAll, 0);   {Grade}
      SetTab(4.4, pjCenter, 0.4, 4, BoxLineAll, 0);   {Cond}
      SetTab(4.8, pjRight, 0.6, 4, BoxLineAll, 0);   {Func Obs}
      SetTab(5.4, pjRight, 0.6, 4, BoxLineAll, 0);   {% Good}
      SetTab(6.0, pjRight, 1.0, 4, BoxLineAll, 0);   {RCN}
      SetTab(7.0, pjRight, 1.0, 4, BoxLineAll, 0);   {RCN - Depreciation}

    end;  {with Sender as TBaseReport do}

end;  {PrintImprovementSectionHeader}

{===========================================================================}
Procedure PrintItem(Sender : TObject;
                    Header : String;
                    Item : String;
                    Description : String;
                    PrintDescription : Boolean;
                    IssueCarriageReturn : Boolean);

begin
  with Sender as TBaseReport do
    begin
      Bold := True;
      Print(#9 + Header);
      Bold := False;
      Print(Item);

      If (PrintDescription and
          (Deblank(Description) <> ''))
        then Print(' (' + Trim(Description) + ')');

      If IssueCarriageReturn
        then Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintItem}

{===========================================================================}
Procedure PrintResidentialSite(Sender : TObject;
                               ResSiteTable : TTable);

begin
  with Sender as TBaseReport, ResSiteTable do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 3.7, 0, BOXLINENone, 0);   {Col 1}
      SetTab(4.2, pjLeft, 3.7, 0, BOXLINENone, 0);   {Col 2}

      PrintItem(Sender, 'Prop Cls: ', FieldByName('PropertyClassCode').Text,
                FieldByName('PropertyClassDesc').Text, True, False);
      PrintItem(Sender, 'Neighborhood: ', FieldByName('NeighborhoodCode').Text,
                FieldByName('NeighborhoodDesc').Text, True, True);

      PrintItem(Sender, 'Desirability: ', FieldByName('DesirabilityCode').Text,
                FieldByName('DesirabilityDesc').Text, True, False);
      PrintItem(Sender, 'Nbhd Rating: ', FieldByName('NghbrhdRatingCode').Text,
                FieldByName('NghbrhdRatingDesc').Text, True, True);

      PrintItem(Sender, 'Zoning: ', FieldByName('ZoningCode').Text,
                FieldByName('ZoningDesc').Text, True, False);
      PrintItem(Sender, 'Nbhd Type: ', FieldByName('NghbrhdTypeCode').Text,
                FieldByName('NghbrhdTypeDesc').Text, True, True);

      PrintItem(Sender, 'Sewer: ', FieldByName('SewerTypeCode').Text,
                FieldByName('SewerTypeDesc').Text, True, False);
      PrintItem(Sender, 'Water: ', FieldByName('WaterSupplyCode').Text,
                FieldByName('WaterSupplyDesc').Text, True, True);

      PrintItem(Sender, 'Utilities: ', FieldByName('UtilityTypeCode').Text,
                FieldByName('UtilityTypeDesc').Text, True, False);
      PrintItem(Sender, 'Road: ', FieldByName('RoadTypeCode').Text,
                FieldByName('RoadTypeDesc').Text, True, True);

      PrintItem(Sender, 'Route #: ', FieldByName('RouteNumber').Text,
                '', False, False);
      PrintItem(Sender, 'Phys Change: ', FieldByName('PhysicalChangeCode').Text,
                FieldByName('PhysicalChangeDesc').Text, True, True);

      PrintItem(Sender, 'Elevation: ', FieldByName('ElevationCode').Text,
                FieldByName('ElevationDesc').Text, True, False);
      PrintItem(Sender, 'Traffic: ', FieldByName('TrafficCode').Text,
                FieldByName('TrafficDesc').Text, True, True);

      If GlblShowInventoryValues
        then
          begin
            PrintItem(Sender, 'Land Val: ',
                      FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('FinalLandValue').AsFloat),
                      '', False, False);
            PrintItem(Sender, 'Total Val: ',
                      FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('FinalTotalValue').AsFloat),
                      '', False, True);

          end;  {If GlblShowInventoryValues}

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintResidentialSite}

{===========================================================================}
Procedure PrintResidentialBuilding(Sender : TObject;
                                   ResBldgTable : TTable);

begin
  with Sender as TBaseReport, ResBldgTable do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 3.7, 0, BOXLINENone, 0);   {Col 1}
      SetTab(4.2, pjLeft, 3.7, 0, BOXLINENone, 0);   {Col 2}

      PrintItem(Sender, 'Bldg Style: ', FieldByName('BuildingStyleCode').Text,
                FieldByName('BuildingStyleDesc').Text, True, False);
      PrintItem(Sender, 'Ext Wall: ', FieldByName('ExtWallMaterialCode').Text,
                FieldByName('ExtWallMaterialDesc').Text, True, True);

      PrintItem(Sender, 'Condition: ', FieldByName('ConditionCode').Text,
                FieldByName('ConditionDesc').Text, True, False);
      PrintItem(Sender, 'Grade: ', FieldByName('OverallGradeCode').Text,
                FieldByName('OverallGradeDesc').Text, True, True);

      PrintItem(Sender, 'Heat: ', FieldByName('HeatTypeCode').Text,
                FieldByName('HeatTypeDesc').Text, True, False);
      PrintItem(Sender, 'Basement: ', FieldByName('BasementTypeCode').Text,
                FieldByName('BasementTypeDesc').Text, True, True);

      ClearTabs;
      SetTab(0.3, pjLeft, 2.5, 0, BOXLINENone, 0);   {Col 1}
      SetTab(2.9, pjLeft, 2.5, 0, BOXLINENone, 0);   {Col 2}
      SetTab(5.5, pjLeft, 2.5, 0, BOXLINENone, 0);   {Col 3}

      PrintItem(Sender, 'Fuel: ', FieldByName('FuelTypeCode').Text,
                FieldByName('FuelTypeDesc').Text, True, False);
      PrintItem(Sender, 'Porch: ', FieldByName('PorchTypeCode').Text,
                FieldByName('PorchTypeDesc').Text, True, False);
      PrintItem(Sender, 'Central Air: ', BoolToStr(FieldByName('CentralAir').AsBoolean),
                '', False, True);

        {CHG08082002-3: Add Year remodeled, detached garage capacity and
                        1/2 baths.}

      PrintItem(Sender, 'Year Built: ', FieldByName('ActualYearBuilt').Text,
                '', False, False);
      PrintItem(Sender, 'Year Remodeled: ', FieldByName('RemodelYear').Text,
                '', False, False);
      PrintItem(Sender, 'Porch Area: ', FieldByName('PorchArea').Text,
                '', False, True);

      PrintItem(Sender, 'Garages: ', FormatFloat(IntegerDisplay, FieldByName('AttachedGarCapacity').AsInteger),
                '', False, False);
      PrintItem(Sender, 'Bsmt Garages: ', FormatFloat(IntegerDisplay, FieldByName('BasementGarCapacity').AsInteger),
                '', False, False);
      PrintItem(Sender, 'Dtch Garages: ', FormatFloat(IntegerDisplay, FieldByName('DetachedGarCapacity').AsInteger),
                '', False, True);

      PrintItem(Sender, 'Stories: ', FormatFloat(_1DecimalDisplay, FieldByName('NumberOfStories').AsFloat),
                '', False, False);
      PrintItem(Sender, 'Rooms: ', FormatFloat(IntegerDisplay, FieldByName('NumberOfRooms').AsInteger),
                '', False, False);
      PrintItem(Sender, 'Bedrooms: ', FormatFloat(IntegerDisplay, FieldByName('NumberOfBedrooms').AsInteger),
                '', False, True);

      PrintItem(Sender, 'Bathrooms: ', FormatFloat(_1DecimalDisplay, FieldByName('NumberOfBathrooms').AsFloat),
                '', False, False);
      PrintItem(Sender, '1/2 Baths: ', FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('NumHalfBathrooms').AsFloat),
                '', False, False);
      PrintItem(Sender, 'Bathroom Qual: ', FieldByName('BathroomQualityCode').Text,
                FieldByName('BathroomQualityDesc').Text, True, True);

      PrintItem(Sender, 'Kitchens: ', FormatFloat(IntegerDisplay, FieldByName('NumberOfKitchens').AsInteger),
                '', False, False);
      PrintItem(Sender, 'Kitchen Qual: ', FieldByName('KitchenQualityCode').Text,
                FieldByName('KitchenQualityDesc').Text, True, False);
      PrintItem(Sender, 'Fireplaces: ', FormatFloat(IntegerDisplay, FieldByName('NumberOfFireplaces').AsInteger),
                '', False, True);

      PrintItem(Sender, '1st Story: ', FormatFloat(IntegerDisplay, FieldByName('FirstStoryArea').AsInteger),
                '', False, False);
      PrintItem(Sender, '2nd Story: ', FormatFloat(IntegerDisplay, FieldByName('SecondStoryArea').AsInteger),
                '', False, False);
      PrintItem(Sender, '3rd Story: ', FormatFloat(IntegerDisplay, FieldByName('ThirdStoryArea').AsInteger),
                '', False, True);

      PrintItem(Sender, '1/2 Story: ', FormatFloat(IntegerDisplay, FieldByName('HalfStoryArea').AsInteger),
                '', False, False);
      PrintItem(Sender, '3/4 Story: ', FormatFloat(IntegerDisplay, FieldByName('ThreeQuarterStoryAre').AsInteger),
                '', False, False);
      PrintItem(Sender, 'Fin Over Garage: ', FormatFloat(IntegerDisplay, FieldByName('FinishedAreaOverGara').AsInteger),
                '', False, True);

      PrintItem(Sender, 'Fin Attic: ', FormatFloat(IntegerDisplay, FieldByName('FinishedAtticArea').AsInteger),
                '', False, False);
      PrintItem(Sender, 'Fin Bsmt: ', FormatFloat(IntegerDisplay, FieldByName('FinishedBasementArea').AsInteger),
                '', False, False);
      PrintItem(Sender, 'Fin Rec Rm: ', FormatFloat(IntegerDisplay, FieldByName('FinishedRecRoom').AsInteger),
                '', False, True);

      PrintItem(Sender, 'Unfin 1/2: ', FormatFloat(IntegerDisplay, FieldByName('UnfinishedHalfStory').AsInteger),
                '', False, False);
      PrintItem(Sender, 'Unfin 3/4: ', FormatFloat(IntegerDisplay, FieldByName('Unfinished3_4Story').AsInteger),
                '', False, False);
      PrintItem(Sender, 'Unfin Room: ', FormatFloat(IntegerDisplay, FieldByName('UnfinishedRoom').AsInteger),
                '', False, True);

      PrintItem(Sender, 'Tot Living Area: ', FormatFloat(IntegerDisplay, FieldByName('SqFootLivingArea').AsInteger),
                '', False, False);

    end;  {with Sender as TBaseReport do}

end;  {PrintResidentialBuilding}

{===========================================================================}
Procedure PrintLand(    Sender : TObject;
                        LandTable : TTable;
                        AssessmentYear : String;
                        SwisSBLKey : String;
                        SiteNumber : Integer;
                        Residential : Boolean;
                        Options : OptionsSet;
                    var PicturePrinted : Boolean);

var
  Done, FirstTimeThrough : Boolean;
  NumLands : Integer;

begin
  NumLands := 0;
  Done := False;
  FirstTimeThrough := True;
  SetRangeOld(LandTable, ['TaxRollYr', 'SwisSBLKey', 'Site', 'LandNumber'],
              [AssessmentYear, SwisSBLKey, IntToStr(SiteNumber), '0'],
              [AssessmentYear, SwisSBLKey, IntToStr(SiteNumber), '32000']);
  LandTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else LandTable.Next;

    If LandTable.EOF
      then Done := True;

    If not Done
      then
        with Sender as TBaseReport, LandTable do
          begin
            NumLands := NumLands + 1;

            If (LinesLeft < 6)
              then
                begin
                  NewPage;
                  PrintParcelHeader(Sender, AssessmentYear, Options,
                                    PicturePrinted);
                  PrintSiteHeader(Sender, AssessmentYear, SiteNumber,
                                  Residential, True, Options, PicturePrinted);
                  PrintLandSectionHeader(Sender);
                end
              else
                If (NumLands = 1)
                  then PrintLandSectionHeader(Sender);

            Println(#9 + FieldByName('LandNumber').Text +
                    #9 + Take(12, FieldByName('LandTypeDesc').Text) +
                    #9 + FormatFloat(IntegerEditDisplay, FieldByName('Frontage').AsInteger) +
                    #9 + FormatFloat(IntegerEditDisplay, FieldByName('Depth').AsInteger) +
                    #9 + FormatFloat(DecimalEditDisplay, FieldByName('Acreage').AsFloat) +
                    #9 + FormatFloat(IntegerEditDisplay, FieldByName('SquareFootage').AsFloat) +
                    #9 + Take(8, FieldByName('InfluenceDesc').Text) +
                    #9 + Take(4, FieldByName('SoilRatingDesc').Text) +
                    #9 + Take(7, FieldByName('InfluenceDesc').Text) +
                    #9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('LandValue').AsFloat) +
                    #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('UnitPrice').AsFloat));

          end;  {with Sender as TBaseReport, LandTable do}

  until Done;

end;  {PrintLand}

{===========================================================================}
Procedure PrintImprovement(    Sender : TObject;
                               ImprovementTable : TTable;
                               AssessmentYear : String;
                               SwisSBLKey : String;
                               SiteNumber : Integer;
                               Residential : Boolean;
                               Options : OptionsSet;
                           var PicturePrinted : Boolean);

var
  Done, FirstTimeThrough : Boolean;
  NumImprovements : Integer;
  TempDimension : String;

begin
  NumImprovements := 0;
  Done := False;
  FirstTimeThrough := True;
  SetRangeOld(ImprovementTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site', 'ImprovementNumber'],
              [AssessmentYear, SwisSBLKey, IntToStr(SiteNumber), '0'],
              [AssessmentYear, SwisSBLKey, IntToStr(SiteNumber), '32000']);
  ImprovementTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ImprovementTable.Next;

    If ImprovementTable.EOF
      then Done := True;

    If not Done
      then
        with Sender as TBaseReport, ImprovementTable do
          begin
            NumImprovements := NumImprovements + 1;

            If (LinesLeft < 6)
              then
                begin
                  NewPage;
                  PrintParcelHeader(Sender, AssessmentYear, Options,
                                    PicturePrinted);
                  PrintSiteHeader(Sender, AssessmentYear, SiteNumber,
                                  Residential, True, Options, PicturePrinted);
                  PrintImprovementSectionHeader(Sender);
                end
              else
                If (NumImprovements = 1)
                  then PrintImprovementSectionHeader(Sender);

            TempDimension := '';

              {FXX06242004-1(MDT): Make sure no exception is raised if the
                                   measure code is blank.}

            try
              case FieldByName('MeasureCode').Text[1] of
                '1' : TempDimension := 'Qty';
                '2' : TempDimension := 'Dim';
                '3' : TempDimension := 'SqFt';
                '4' : TempDimension := '$';
              end;
            except
            end;

            Println(#9 + FieldByName('ImprovementNumber').Text +
                    #9 + Take(16, FieldByName('StructureDesc').Text) +
                    #9 + FieldByName('YearBuilt').Text +
                    #9 + TempDimension +
                    #9 + FormatFloat(IntegerEditDisplay, FieldByName('Dimension1').AsInteger) +
                    #9 + FormatFloat(IntegerEditDisplay, FieldByName('Dimension2').AsInteger) +
                    #9 + FormatFloat(IntegerEditDisplay, FieldByName('Quantity').AsInteger) +
                    #9 + FieldByName('GradeCode').Text +
                    #9 + Take(4, FieldByName('ConditionDesc').Text) +
                    #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('FunctionalObsolescen').AsFloat) +
                    #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('PercentGood').AsFloat) +
                    #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('ReplacementCostNew').AsFloat) +
                    #9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('RCNLessDepreciation').AsFloat));

          end;  {with Sender as TBaseReport, ImprovementTable do}

  until Done;

end;  {PrintImprovement}

{===========================================================================}
Procedure PrintResidentialInventory(    Sender : TObject;
                                        AssessmentYear : String;
                                        SwisSBLKey : String;
                                        Options : OptionsSet;
                                    var PicturePrinted : Boolean);

var
  _Found, FirstTimeThrough, Done : Boolean;
  SiteNumber : Integer;

begin
  FirstTimeThrough := True;
  Done := False;

    {FXX05072002-5: Printing bldg information for multiple sites was
                    not working because there was a range set by the
                    summary screen.}

  ResBldgTable.CancelRange;

    {FXX04132001-4: The index was actually Year/Swis SBL.}

  SetRangeOld(ResSiteTable, ['TaxRollYr', 'SwisSBLKey'],
              [AssessmentYear, SwisSBLKey],
              [AssessmentYear, SwisSBLKey]);
  ResSiteTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ResSiteTable.Next;

    If ResSiteTable.EOF
      then Done := True;

    If not Done
      then
        begin
          SiteNumber := ResSiteTable.FieldByName('Site').AsInteger;

          PrintSiteHeader(Sender, AssessmentYear, SiteNumber, True, False,
                          Options, PicturePrinted);

          PrintResidentialSite(Sender, ResSiteTable);

          _Found := FindKeyOld(ResBldgTable,
                               ['TaxRollYr', 'SwisSBLKey', 'Site'],
                               [AssessmentYear, SwisSBLKey, IntToStr(SiteNumber)]);

          If _Found
            then PrintResidentialBuilding(Sender, ResBldgTable);

          PrintLand(Sender, ResLandTable, AssessmentYear, SwisSBLKey,
                    SiteNumber, True, Options, PicturePrinted);

          PrintImprovement(Sender, ResImprovementTable, AssessmentYear,
                           SwisSBLKey, SiteNumber, True,
                           Options, PicturePrinted);

        end;  {If not Done}

  until Done;

end;  {PrintResidentialInventory}

{===========================================================================}
Procedure PrintCommercialSite(Sender : TObject;
                              ComSiteTable : TTable);

begin
  with Sender as TBaseReport, ComSiteTable do
    begin
      ClearTabs;
      SetTab(0.3, pjLeft, 3.7, 0, BOXLINENone, 0);   {Col 1}
      SetTab(4.2, pjLeft, 3.7, 0, BOXLINENone, 0);   {Col 2}

      PrintItem(Sender, 'Prop Cls: ', FieldByName('PropertyClassCode').Text,
                FieldByName('PropertyClassDesc').Text, True, False);
      PrintItem(Sender, 'Neighborhood: ', FieldByName('NeighborhoodCode').Text,
                FieldByName('NeighborhoodDesc').Text, True, True);

      PrintItem(Sender, 'Used As: ', FieldByName('UsedAsCode').Text,
                FieldByName('UsedAsDesc').Text, True, False);
      PrintItem(Sender, 'Desirability: ', FieldByName('DesirabilityCode').Text,
                FieldByName('DesirabilityDesc').Text, True, True);

      PrintItem(Sender, 'Eff Year Built: ', FieldByName('EffectiveYearBuilt').Text,
                '', False, True);

      PrintItem(Sender, 'Zoning: ', FieldByName('ZoningCode').Text,
                FieldByName('ZoningDesc').Text, True, False);
      PrintItem(Sender, 'Utilities: ', FieldByName('UtilitiesCode').Text,
                FieldByName('UtilitiesDesc').Text, True, True);

      PrintItem(Sender, 'Sewer: ', FieldByName('SewerTypeCode').Text,
                FieldByName('SewerTypeDesc').Text, True, False);
      PrintItem(Sender, 'Water: ', FieldByName('WaterSupplyCode').Text,
                FieldByName('WaterSupplyDesc').Text, True, True);

      PrintItem(Sender, 'Route #: ', FieldByName('RouteNumber').Text,
                '', False, False);
      PrintItem(Sender, 'Valuation Dist: ', FieldByName('ValuationDistCode').Text,
                FieldByName('ValuationDistDesc').Text, True, True);

      PrintItem(Sender, 'Condition: ', FieldByName('ConditionCode').Text,
                FieldByName('ConditionDesc').Text, True, False);
      PrintItem(Sender, 'Grade: ', FieldByName('GradeCode').Text,
                FieldByName('GradeDesc').Text, True, True);

      PrintItem(Sender, 'Land Val: ',
                FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('FinalLandValue').AsFloat),
                '', False, False);
      PrintItem(Sender, 'Total Val: ',
                FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('FinalTotalValue').AsFloat),
                '', False, True);

      Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintCommercialSite}

{===========================================================================}
Procedure PrintCommercialBldgSectionHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
      ClearTabs;

      If (LinesLeft > 50)
        then SetTab(0.1, pjCenter, 7.8, 0, BOXLINENone, 0)
        else SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);   {Prior}
      Println('');
      Println(#9 + 'Commercial Building Information');
      Println('');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 3.6, 0, BoxLineNone, 0);   {Col 1}
      SetTab(4.1, pjLeft, 3.6, 0, BoxLineNone, 0);   {Col 2}

    end;  {with Sender as TBaseReport do}

end;  {PrintCommercialBldgSectionHeader}

{===========================================================================}
Procedure PrintCommercialBldg(    Sender : TObject;
                                  CommercialBldgTable : TTable;
                                  AssessmentYear : String;
                                  SwisSBLKey : String;
                                  SiteNumber : Integer;
                                  Options : OptionsSet;
                              var PicturePrinted : Boolean);

var
  Done, FirstTimeThrough : Boolean;
  NumCommercialBldgs : Integer;

begin
  NumCommercialBldgs := 0;
  Done := False;
  FirstTimeThrough := True;
  SetRangeOld(CommercialBldgTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site', 'BuildingNumber', 'BuildingSection'],
              [AssessmentYear, SwisSBLKey, IntToStr(SiteNumber), '0', '0'],
              [AssessmentYear, SwisSBLKey, IntToStr(SiteNumber), '32000', '32000']);
  CommercialBldgTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else CommercialBldgTable.Next;

    If CommercialBldgTable.EOF
      then Done := True;

    If not Done
      then
        with Sender as TBaseReport, CommercialBldgTable do
          begin
            NumCommercialBldgs := NumCommercialBldgs + 1;

            If (LinesLeft < 12)
              then
                begin
                  NewPage;
                  PrintParcelHeader(Sender, AssessmentYear,
                                    Options, PicturePrinted);
                  PrintSiteHeader(Sender, AssessmentYear, SiteNumber,
                                  False, True, Options, PicturePrinted);
                  PrintCommercialBldgSectionHeader(Sender);
                end
              else
                If (NumCommercialBldgs = 1)
                  then PrintCommercialBldgSectionHeader(Sender)
                  else Println('');

            PrintItem(Sender, 'Bldg Num: ', FieldByName('BuildingNumber').Text,
                      '', False, False);
            PrintItem(Sender, 'Bldg Section: ', FieldByName('BuildingSection').Text,
                      '', False, True);

            PrintItem(Sender, 'Boeckh Model: ', FieldByName('BoeckhModelCode').Text,
                      FieldByName('BoeckhModelDesc').Text, True, False);
            PrintItem(Sender, 'Eff Year Built: ', FieldByName('EffectiveYearBuilt').Text,
                      '', False, True);

            PrintItem(Sender, '# Identical Bldgs: ', FieldByName('NumberIdentBldgs').Text,
                      '', False, False);
            PrintItem(Sender, 'User Adjustment: ',
                      FormatFloat(DecimalDisplay_BlankZero, FieldByName('UserAdjustment').AsFloat),
                      '', False, True);

            PrintItem(Sender, 'Condition: ', FieldByName('ConditionCode').Text,
                      FieldByName('ConditionDesc').Text, True, False);
            PrintItem(Sender, 'Floor Area: ',
                      FormatFloat(IntegerDisplay, FieldByName('GrossFloorArea').AsInteger),
                      '', False, True);

            PrintItem(Sender, 'Const Qual: ', FieldByName('ConstructionQualCode').Text,
                      FieldByName('ConstructionQualDesc').Text, True, False);
            PrintItem(Sender, 'Bldg Perimiter: ',
                      FormatFloat(IntegerDisplay, FieldByName('BuildingPerimeter').AsInteger),
                      '', False, True);

            ClearTabs;
            SetTab(0.3, pjLeft, 2.7, 0, BoxLineNone, 0);   {Col 1}
            SetTab(3.2, pjLeft, 2.2, 0, BoxLineNone, 0);   {Col 2}
            SetTab(5.6, pjLeft, 2.2, 0, BoxLineNone, 0);   {Col 3}

            PrintItem(Sender, '# Stories: ',
                      FormatFloat(IntegerDisplay, FieldByName('NumberStories').AsFloat),
                      '', False, False);
            PrintItem(Sender, 'Story Height: ',
                      FormatFloat(IntegerDisplay, FieldByName('StoryHeight').AsFloat),
                      '', False, False);
            PrintItem(Sender, '# Elevators: ',
                      FormatFloat(IntegerDisplay, FieldByName('NumberOfElevators').AsFloat),
                      '', False, True);

            PrintItem(Sender, 'Basement: ', FieldByName('BasementTypeCode').Text,
                      FieldByName('BasementTypeDesc').Text, True, False);
            PrintItem(Sender, 'Bsmt Perim: ',
                      FormatFloat(IntegerDisplay, FieldByName('BasementPerimeter').AsFloat),
                      '', False, False);
            PrintItem(Sender, 'Bsmt Sq Ft: ',
                      FormatFloat(IntegerDisplay, FieldByName('BasementSquareFeet').AsFloat),
                      '', False, True);

            PrintItem(Sender, 'Wall A %:  ',
                      FormatFloat(DecimalDisplay_BlankZero, FieldByName('WallAPercent').AsFloat),
                      '', False, False);
            PrintItem(Sender, 'Wall B%:  ',
                      FormatFloat(DecimalDisplay_BlankZero, FieldByName('WallBPercent').AsFloat),
                      '', False, False);
            PrintItem(Sender, 'Wall C%:  ',
                      FormatFloat(DecimalDisplay_BlankZero, FieldByName('WallCPercent').AsFloat),
                      '', False, True);

            PrintItem(Sender, 'Air Cond %: ',
                      FormatFloat(DecimalDisplay_BlankZero, FieldByName('AirCondPercent').AsFloat),
                      '', False, False);
            PrintItem(Sender, 'Sprinkler %: ',
                      FormatFloat(DecimalDisplay_BlankZero, FieldByName('SprinklerPercent').AsFloat),
                      '', False, False);
            PrintItem(Sender, 'Alarm %: ',
                      FormatFloat(DecimalDisplay_BlankZero, FieldByName('AlarmPercent').AsFloat),
                      '', False, True);

          end;  {with Sender as TBaseReport, CommercialBldgTable do}

  until Done;

end;  {PrintCommercialBldg}

{===========================================================================}
Procedure PrintRentSectionHeader(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      Println('');
      Bold := True;
      ClearTabs;
      SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);   {Prior}
      Println('');
      Println(#9 + 'Rent Information');
      Println('');
      Bold := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 3.6, 0, BoxLineNone, 0);   {Col 1}
      SetTab(4.1, pjLeft, 3.6, 0, BoxLineNone, 0);   {Col 2}

    end;  {with Sender as TBaseReport do}

end;  {PrintRentSectionHeader}

{===========================================================================}
Procedure PrintRent(    Sender : TObject;
                        RentTable : TTable;
                        AssessmentYear : String;
                        SwisSBLKey : String;
                        SiteNumber : Integer;
                        Options : OptionsSet;
                    var PicturePrinted : Boolean);

var
  Done, FirstTimeThrough : Boolean;
  NumRents : Integer;

begin
  NumRents := 0;
  Done := False;
  FirstTimeThrough := True;
  SetRangeOld(RentTable,
              ['TaxRollYr', 'SwisSBLKey', 'Site', 'UseNumber'],
              [AssessmentYear, SwisSBLKey, IntToStr(SiteNumber), '0'],
              [AssessmentYear, SwisSBLKey, IntToStr(SiteNumber), '32000']);
  RentTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else RentTable.Next;

    If RentTable.EOF
      then Done := True;

    If not Done
      then
        with Sender as TBaseReport, RentTable do
          begin
            NumRents := NumRents + 1;

            If (LinesLeft < 6)
              then
                begin
                  NewPage;
                  PrintParcelHeader(Sender, AssessmentYear,
                                    Options, PicturePrinted);
                  PrintSiteHeader(Sender, AssessmentYear, SiteNumber,
                                  False, True, Options, PicturePrinted);
                  PrintRentSectionHeader(Sender);
                end
              else
                If (NumRents = 1)
                  then PrintRentSectionHeader(Sender)
                  else Println('');

            PrintItem(Sender, 'Rent Num: ', FieldByName('UseNumber').Text,
                      '', False, False);
            PrintItem(Sender, 'Valuation Dist: ', FieldByName('ValuationDistCode').Text,
                      FieldByName('ValuationDistDesc').Text, True, True);

            PrintItem(Sender, 'Used As: ', FieldByName('UsedAsCode').Text,
                      FieldByName('UsedAsDesc').Text, True, False);
            PrintItem(Sender, 'Rentable Area: ',
                      FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('TotalRentableArea').AsFloat),
                      '', False, True);

            PrintItem(Sender, 'Unit Type: ', FieldByName('UnitType_NonAptCode').Text,
                      FieldByName('UnitType_NonAptDesc').Text, True, False);
            PrintItem(Sender, 'Rent Type: ', FieldByName('RentTypeCode').Text,
                      FieldByName('RentTypeDesc').Text, True, True);

            PrintItem(Sender, 'Total Units: ',
                      FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('TotalUnits').AsFloat),
                      '', False, False);
            PrintItem(Sender, 'Total Rent: ',
                      FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('TotalRent').AsFloat),
                      '', False, True);

              {Only show apartment fields if this is an apartment.}

            If (FieldByName('UsedAsCode').Text[1] = 'A')
              then
                begin
                  ClearTabs;
                  SetTab(0.3, pjCenter, 2.7, 0, BoxLineAll, 0);   {Col 1}
                  SetTab(3.2, pjCenter, 2.2, 0, BoxLineAll, 0);   {Col 2}
                  SetTab(5.6, pjCenter, 2.2, 0, BoxLineAll, 0);   {Col 3}

                  PrintItem(Sender, 'Apt Area -> Eff/1 Bed: ',
                            FormatFloat(IntegerDisplay, FieldByName('AreaEff1BedApt').AsInteger),
                            '', False, False);
                  PrintItem(Sender, '2 Bed: ', FormatFloat(IntegerDisplay, FieldByName('Area2BedApt').AsInteger),
                            '', False, False);
                  PrintItem(Sender, '3 Bed: ', FormatFloat(IntegerDisplay, FieldByName('Area3BedApt').AsInteger),
                            '', False, True);

                  PrintItem(Sender, 'Total Apts -> Eff/1 Bed: ',
                            FormatFloat(IntegerDisplay, FieldByName('TotalEff1Bed').AsInteger),
                            '', False, False);
                  PrintItem(Sender, '2 Bed: ', FormatFloat(IntegerDisplay, FieldByName('Total2Bed').AsInteger),
                            '', False, False);
                  PrintItem(Sender, '3 Bed: ', FormatFloat(IntegerDisplay, FieldByName('Total3Bed').AsInteger),
                            '', False, True);

                end;  {If (FieldByName('UsedAsCode').Text[1] = 'A')}

          end;  {with Sender as TBaseReport, RentTable do}

  until Done;

end;  {PrintRent}

{===========================================================================}
Procedure PrintIncomeExpense(    Sender : TObject;
                                 ComIncExpTable : TTable;
                                 AssessmentYear : String;
                                 SwisSBLKey : String;
                                 SiteNumber : Integer;
                                 Options : OptionsSet;
                             var PicturePrinted : Boolean);

begin
  with Sender as TBaseReport, ComIncExpTable do
    begin
      ClearTabs;

      If (LinesLeft < 25)
        then
          begin
            NewPage;
            PrintParcelHeader(Sender, AssessmentYear,
                              Options, PicturePrinted);
            PrintSiteHeader(Sender, AssessmentYear, SiteNumber,
                            False, True, Options, PicturePrinted);
            SetTab(0.1, pjCenter, 7.8, 0, BOXLINENone, 0);
          end
        else SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);

      Println('');
      Bold := True;
      Println(#9 + 'Commercial Income\Expense');

      Println('');

      Italic := True;
      ClearTabs;
      SetTab(0.3, pjCenter, 2.4, 0, BOXLINENone, 0);  {Col1 label}
      SetTab(4.0, pjCenter, 2.4, 0, BOXLINENone, 0);  {Col2 label}
      Println(#9 + 'Income' +
              #9 + 'Expenses');
      Bold := False;
      Italic := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.3, 0, BOXLINENone, 0);  {Col1 label}
      SetTab(1.6, pjRight, 1.1, 0, BOXLINENone, 0);  {Col1 amount}
      SetTab(4.0, pjLeft, 1.3, 0, BOXLINENone, 0);  {Col2 label}
      SetTab(5.3, pjRight, 1.1, 0, BOXLINENone, 0);  {Col2 amount}

      PrintItem(Sender, 'Rent: ', '',
                '', False, False);
      Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('GrossRentalIncome').AsFloat));
      PrintItem(Sender, 'Expense Type: ', '', '', False, False);
      PrintItem(Sender, '', FieldByName('ExpenseTypeCode').Text,
                FieldByName('ExpenseTypeDesc').Text, True, True);

      PrintItem(Sender, 'Vac/Crd Loss: ', '',
                '', False, False);
      Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('VacancyOrCreditLoss').AsFloat));
      PrintItem(Sender, 'Management: ', '',
                '', False, False);
      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('ManagementExpenses').AsFloat));

      PrintItem(Sender, 'Additional: ', '',
                '', False, False);
      Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('AdditionalIncome').AsFloat));
      PrintItem(Sender, 'Insurance: ', '',
                '', False, False);
      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('InsuranceExpenses').AsFloat));

      PrintItem(Sender, 'Eff Gross Inc: ', '',
                '', False, False);
      Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('EffectiveGrossInc').AsFloat));
      PrintItem(Sender, 'Bldg Service: ', '',
                '', False, False);
      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('BldgSvcExpenses').AsFloat));

      PrintItem(Sender, 'Investment Set: ', '', '', False, False);
      PrintItem(Sender, '', FieldByName('InvestmentSetCode').Text,
                FieldByName('InvestmentSetDesc').Text, True, False);
      PrintItem(Sender, 'Utilities: ', '',
                '', False, False);
      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('UtilityExpenses').AsFloat));

      PrintItem(Sender, 'Invsmt Period: ', '',
                '', False, False);
      Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('InvestmentPeriod').AsFloat));
      PrintItem(Sender, 'Misc Exp: ', '',
                '', False, False);
      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('MiscCosts').AsFloat));

      PrintItem(Sender, 'Equity Yld %: ', '',
                '', False, False);
      Print(#9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('EquityYieldPercent').AsFloat));
      PrintItem(Sender, 'Total Exp: ', '',
                '', False, False);
      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('TotalExpenses').AsFloat));

      PrintItem(Sender, 'Equity Dividend: ', '',
                '', False, False);
      Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('EquityDividend').AsFloat));
      PrintItem(Sender, 'Rsrv For Rplc: ', '',
                '', False, False);
      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('ReserveForReplacemen').AsFloat));

      Print(#9 + #9);
      PrintItem(Sender, 'Net Oper Inc: ', '',
                '', False, False);
      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('NetOperatingIncome').AsFloat));

      Println('');
      ClearTabs;
      Bold := True;
      Italic := True;
      SetTab(0.3, pjCenter, 2.4, 0, BOXLINENone, 0);  {Col1 label}
      SetTab(4.0, pjCenter, 2.4, 0, BOXLINENone, 0);  {Col2 label}
      Println(#9 + 'Mortgage 1' +
              #9 + 'Mortgage 2');
      Bold := False;
      Italic := False;

      ClearTabs;
      SetTab(0.3, pjLeft, 1.3, 0, BOXLINENone, 0);  {Col1 label}
      SetTab(1.6, pjRight, 1.1, 0, BOXLINENone, 0);  {Col1 amount}
      SetTab(4.0, pjLeft, 1.3, 0, BOXLINENone, 0);  {Col2 label}
      SetTab(5.3, pjRight, 1.1, 0, BOXLINENone, 0);  {Col2 amount}

      PrintItem(Sender, '% Total Inv: ', '',
                '', False, False);
      Print(#9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('1stMortPercentTotInv').AsFloat));
      PrintItem(Sender, '% Total Inv: ', '',
                '', False, False);
      Println(#9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('2ndMortPercentTotInv').AsFloat));

      PrintItem(Sender, 'Term: ', '',
                '', False, False);
      Print(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('1stMortTerm').AsFloat));
      PrintItem(Sender, 'Term: ', '',
                '', False, False);
      Println(#9 + FormatFloat(NoDecimalDisplay_BlankZero, FieldByName('2ndMortTerm').AsFloat));

      PrintItem(Sender, 'Int Rate: ', '',
                '', False, False);
      Print(#9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('1stMortIntRate').AsFloat));
      PrintItem(Sender, 'Int Rate: ', '',
                '', False, False);
      Println(#9 + FormatFloat(DecimalDisplay_BlankZero, FieldByName('2ndMortIntRate').AsFloat));

      ClearTabs;
      SetTab(0.3, pjLeft, 3.6, 0, BOXLINENone, 0);  {Col1 label}
      SetTab(4.0, pjLeft, 3.6, 0, BOXLINENone, 0);  {Col2 label}

      PrintItem(Sender, 'Alt Name: ', FieldByName('AlternateName').Text,
                '', False, False);
      PrintItem(Sender, 'Alt Addr: ', FieldByName('AlternateAddress').Text,
                '', False, True);

      Println('');
      PrintItem(Sender, 'App\Dep: ', FieldByName('AppDepCode').Text,
                FieldByName('AppDepDesc').Text, True, False);
      PrintItem(Sender, 'Data Use: ', FieldByName('DataUseCode').Text,
                FieldByName('DataUseDesc').Text, True, True);

      PrintItem(Sender, 'App\Dep %: ',
                FormatFloat(DecimalDisplay_BlankZero, FieldByName('AppDepPercent').AsFloat),
                '', False, False);
      PrintItem(Sender, 'Rent Restricted: ',
                BoolToStr(FieldByName('RentRestricted').AsBoolean),
                '', False, True);

    end;  {with Sender as TBaseReport, ComIncExpTable do}

end;  {PrintIncomeExpense}

{===========================================================================}
Procedure PrintCommercialInventory(    Sender : TObject;
                                       AssessmentYear : String;
                                       SwisSBLKey : String;
                                       Options : OptionsSet;
                                   var PicturePrinted : Boolean);

var
  Found, FirstTimeThrough, Done : Boolean;
  SiteNumber : Integer;

begin
  FirstTimeThrough := True;
  Done := False;

    {FXX04132001-4: The index was actually Year/Swis SBL.}

  SetRangeOld(ComSiteTable,
              ['TaxRollYr', 'SwisSBLKey'],
              [AssessmentYear, SwisSBLKey],
              [AssessmentYear, SwisSBLKey]);
  ComSiteTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else ComSiteTable.Next;

    If ComSiteTable.EOF
      then Done := True;

    If not Done
      then
        begin
          SiteNumber := ComSiteTable.FieldByName('Site').AsInteger;

          PrintSiteHeader(Sender, AssessmentYear, SiteNumber,
                          False, False, Options, PicturePrinted);

          PrintCommercialSite(Sender, ComSiteTable);

          PrintCommercialBldg(Sender, ComBldgTable, AssessmentYear, SwisSBLKey,
                              SiteNumber, Options, PicturePrinted);

          PrintLand(Sender, ComLandTable, AssessmentYear, SwisSBLKey,
                    SiteNumber, False, Options, PicturePrinted);

          PrintImprovement(Sender, ComImprovementTable, AssessmentYear, SwisSBLKey,
                           SiteNumber, False, Options, PicturePrinted);

          PrintRent(Sender, ComRentTable, AssessmentYear, SwisSBLKey,
                    SiteNumber, Options, PicturePrinted);

          Found := FindKeyOld(ComIncExpTable,
                              ['TaxRollYr', 'SwisSBLKey', 'Site'],
                              [AssessmentYear, SwisSBLKey, IntToStr(SiteNumber)]);

          If Found
            then PrintIncomeExpense(Sender, ComIncExpTable, AssessmentYear, SwisSBLKey,
                                    SiteNumber, Options, PicturePrinted);

        end;  {If not Done}

  until Done;

end;  {PrintCommercialInventory}

{===========================================================================}
Procedure PrintNotes(Sender : TObject;
                     SwisSBLKey : String;
                     AssessmentYear : String;
                     Options : OptionsSet;
                     PicturePrinted : Boolean);

{CHG03282002-11: Allow them to print notes.}

var
  Done, FirstTimeThrough, NewPageStarted : Boolean;
  NumNotes : Integer;
  DBMemoBuf: TDBMemoBuf;

begin
  Done := False;
  FirstTimeThrough := True;
  NumNotes := 0;

  NotesTable.IndexDefs.Update;

  If _Compare(NotesTable.IndexDefs.Count, 0, coEqual)
    then _SetFilter(NotesTable, 'SwisSBLKey = ' + FormatFilterString(SwisSBLKey))
    else
      begin
        NotesTable.IndexName := 'BYSWISSBLKEY_NOTENUMBER';
        SetRangeOld(NotesTable, ['SwisSBLKey', 'NoteNumber'],
                    [SwisSBLKey, '1'], [SwisSBLKey, '32000']);

      end;  {else of If _Compare(NotesTable...}

  NotesTable.First;

  repeat
    If FirstTimeThrough
      then FirstTimeThrough := False
      else NotesTable.Next;

    If NotesTable.EOF
      then Done := True;

    If not Done
      then
        begin
          NumNotes := NumNotes + 1;

          with Sender as TBaseReport, NotesTable do
            begin
              NewPageStarted := False;

                {See if we need to go to a new page.}

              DBMemoBuf := TDBMemoBuf.Create;
              DBMemoBuf.Field := TMemoField(NotesTable.FieldByName('Note'));

              DBMemoBuf.PrintStart := 0.5;
              DBMemoBuf.PrintEnd := 7.9;

              If ((LinesLeft - MemoLines(DBMemoBuf) - 1) < 5)
                then
                  begin
                    NewPageStarted := True;
                    NewPage;
                    PrintParcelHeader(Sender, AssessmentYear, Options, PicturePrinted);

                  end;  {If ((LinesLeft + DBMemoBuf.MemoLines + 1) < 5)}

              If ((NumNotes = 1) or
                  NewPageStarted)
                then
                  begin
                    Println('');
                    Bold := True;
                    ClearTabs;
                    SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);   {Prior}
                    Println(#9 + 'Notes');
                    Println('');

                    ClearTabs;
                    SetTab(0.3, pjCenter, 0.2, 0, BoxLineAll, 0);   {#}
                    SetTab(0.5, pjCenter, 1.0, 0, BoxLineAll, 0);   {Date Entered}
                    SetTab(1.5, pjCenter, 1.0, 0, BoxLineAll, 0);   {Time Entered}
                    SetTab(2.5, pjCenter, 1.0, 0, BoxLineAll, 0);   {Entered by}
                    SetTab(3.5, pjCenter, 1.0, 0, BoxLineAll, 0);   {Note Code}
                    SetTab(4.5, pjCenter, 0.4, 0, BoxLineAll, 0);   {Type}
                    SetTab(4.9, pjCenter, 1.0, 0, BoxLineAll, 0);   {Date Due}
                    SetTab(5.9, pjCenter, 1.1, 0, BoxLineAll, 0);   {Responsible}
                    SetTab(7.0, pjCenter, 0.4, 0, BoxLineAll, 0);   {Open}

                    Println(#9 + '#' +
                            #9 + 'Date Entered' +
                            #9 + 'Time Entered' +
                            #9 + 'Entered by' +
                            #9 + 'Note Code' +
                            #9 + 'Type' +
                            #9 + 'Date Due' +
                            #9 + 'Responsible' +
                            #9 + 'Open');

                    Bold := False;

                  end;  {If (NumNotes = 1)}

                {Print the info.}

              ClearTabs;
              SetTab(0.3, pjLeft, 0.2, 4, BoxLineAll, 0);   {#}
              SetTab(0.5, pjLeft, 1.0, 4, BoxLineAll, 0);   {Date Entered}
              SetTab(1.5, pjLeft, 1.0, 4, BoxLineAll, 0);   {Time Entered}
              SetTab(2.5, pjLeft, 1.0, 4, BoxLineAll, 0);   {Entered by}
              SetTab(3.5, pjLeft, 1.0, 4, BoxLineAll, 0);   {Note Code}
              SetTab(4.5, pjCenter, 0.4, 0, BoxLineAll, 0);   {Type}
              SetTab(4.9, pjLeft, 1.0, 4, BoxLineAll, 0);   {Date Due}
              SetTab(5.9, pjLeft, 1.1, 4, BoxLineAll, 0);   {Responsible}
              SetTab(7.0, pjCenter, 0.4, 0, BoxLineAll, 0);   {Open}

              Print(#9 + FieldByName('NoteNumber').Text +
                    #9 + FieldByName('DateEntered').Text +
                    #9 + TimeToStr(FieldByName('TimeEntered').AsDateTime) +
                    #9 + FieldByName('EnteredByUserID').Text +
                    #9 + FieldByName('TransactionCode').Text +
                    #9 + FieldByName('NoteTypeCode').Text +
                    #9 + FieldByName('DueDate').Text +
                    #9 + FieldByName('UserResponsible').Text);

              If (FieldByName('NoteTypeCode').Text = 'T')
                then
                  begin
                    If (FieldByName('NoteOpen').AsBoolean = True)
                      then Println(#9 + 'X')
                      else Println(#9 + '');
                  end
                else Println(#9 + '');

              PrintMemo(DBMemoBuf, 0, False);
              Println('');
              DBMemoBuf.Free;

            end;  {with Sender as TBaseReport, NotesTable do}

        end;  {If not Done}

  until Done;

end;  {PrintNotes}

(*
{===========================================================================}
Procedure PrintPermits(Sender : TObject;
                     SwisSBLKey : String;
                     AssessmentYear : String;
                     Options : OptionsSet;
                     PicturePrinted : Boolean);

var
  Done, FirstTimeThrough, NewPageStarted : Boolean;
  NumPermits : Integer;
  DBMemoBuf: TDBMemoBuf;
  PASPermitsTable : TTable;

begin
  FirstTimeThrough := True;
  NumPermits := 0;
  PASPermitsTable := nil;

  try
    PASPermitsTable := TTable.Create(nil);

    with PASPermitsTable do
      begin
        DatabaseName := 'PASSystem';
        TableType := ttDBase;
        TableName := PASPermitsTableName;
        Open;

      end;  {with PASPermitsTable do}

  except
  end;

  PASPermitsTable.IndexName := 'BYSWISSBLKEY_PERMITDATE';
  _SetRange(PASPermitsTable, [SwisSBLKey, '1/1/1900'], [SwisSBLKey, '1/1/2500'], '', []);

  PASPermitsTable.First;

  with PASPermitsTable do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If not Done
        then
          begin
            NumPermits := NumPermits + 1;

            with Sender as TBaseReport do
              begin
                NewPageStarted := False;

                  {See if we need to go to a new page.}

                DBMemoBuf := TDBMemoBuf.Create;
                DBMemoBuf.Field := TMemoField(FieldByName('WorkDescription'));

                DBMemoBuf.PrintStart := 0.5;
                DBMemoBuf.PrintEnd := 7.9;

                If ((LinesLeft - MemoLines(DBMemoBuf) - 1) < 5)
                  then
                    begin
                      NewPageStarted := True;
                      NewPage;
                      PrintParcelHeader(Sender, AssessmentYear, Options, PicturePrinted);

                    end;  {If ((LinesLeft + DBMemoBuf.MemoLines + 1) < 5)}

                If ((NumPermits = 1) or
                    NewPageStarted)
                  then
                    begin
                      Println('');
                      Bold := True;
                      ClearTabs;
                      SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);   {Prior}
                      Println(#9 + 'Permits');
                      Println('');

                      ClearTabs;
                      SetTab(0.3, pjCenter, 1.1, 0, BoxLineAll, 25);   {Permit #}
                      SetTab(1.4, pjCenter, 1.0, 0, BoxLineAll, 25);   {Permit Date}
                      SetTab(2.4, pjCenter, 1.0, 0, BoxLineAll, 25);   {Cost}
                      SetTab(3.4, pjCenter, 0.7, 0, BoxLineAll, 25);   {Inspected}
                      SetTab(4.1, pjCenter, 0.7, 0, BoxLineAll, 25);   {Entered}
                      SetTab(4.8, pjCenter, 0.7, 0, BoxLineAll, 25);   {CO Issued}

                      Println(#9 + 'Permit #' +
                              #9 + 'Permit Date' +
                              #9 + 'Cost' +
                              #9 + 'Inspected' +
                              #9 + 'Entered' +
                              #9 + 'CO Issued');

                      Bold := False;

                    end;  {If (NumPermits = 1)}

                  {Print the info.}

                ClearTabs;
                SetTab(0.3, pjLeft, 1.1, 4, BoxLineAll, 0);   {Permit #}
                SetTab(1.4, pjLeft, 1.0, 4, BoxLineAll, 0);   {Permit Date}
                SetTab(2.4, pjRight, 1.0, 4, BoxLineAll, 0);   {Cost}
                SetTab(3.4, pjCenter, 0.7, 4, BoxLineAll, 0);   {Inspected}
                SetTab(4.1, pjCenter, 0.7, 4, BoxLineAll, 0);   {Entered}
                SetTab(4.8, pjCenter, 0.7, 4, BoxLineAll, 0);   {CO Issued}

                Println(#9 + FieldByName('PermitNumber').Text +
                        #9 + FieldByName('PermitDate').Text +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign, FieldByName('Cost').AsInteger) +
                        #9 + BoolToChar_Blank_X(FieldByName('Inspected').AsBoolean) +
                        #9 + BoolToChar_Blank_X(FieldByName('Entered').AsBoolean) +
                        #9 + BoolToChar_Blank_X(FieldByName('COIssued').AsBoolean));

                PrintMemo(DBMemoBuf, 0, False);
                Println('');
                DBMemoBuf.Free;

              end;  {with Sender as TBaseReport, PermitsTable do}

          end;  {If not Done}

    until Done;

  try
    PASPermitsTable.Close;
    PASPermitsTable.Free;
  except
  end;

end;  {PrintPermits} *)

{===========================================================================}
Procedure PrintPermits_Municity(Sender : TObject;
                                SwisSBLKey : String;
                                AssessmentYear : String;
                                Options : OptionsSet;
                                PicturePrinted : Boolean);

var
  Done, FirstTimeThrough, NewPageStarted : Boolean;
  NumPermits : Integer;
  DBMemoBuf: TDBMemoBuf;
  adoPermits : TADOQuery;
  fConstCost : Double;

begin
  try
    adoPermits := TADOQuery.Create(nil);
    adoPermits.ConnectionString := 'FILE NAME=' + GlblDrive + ':' + GlblProgramDir + 'pasMunicity.udl';
  except
  end;

  with adoPermits do
    try
      IF Active THEN
      BEGIN
        if (EOF or BOF) then First;
        Close;
      END; {IF Active}

      with SQL do begin
        Clear;
        Add('SELECT Parcels.SwisSBLKey,');
        Add(' Parcels.Parcel_ID,');
        Add(' ParcelPermitMap.Parcel_ID AS MapParcelID,');
        Add(' ParcelPermitMap.Permit_ID,');
        Add(' Permits.Permit_ID AS PermitsPermitID,');
        Add(' Permits.PermitNo,');
        Add(' Permits.PermitDate,');
        Add(' Permits.ApplicaDate1,');
        Add(' Permits.CertOccupancyDate,');
        Add(' Permits.Description,');
        Add(' Permits.PermStatus,');
        Add(' Permits.PermitType,');
        Add(' Permits.ConstCost,');
        Add(' Permits.AssessorTempDate1,');
        Add(' Permits.AssessorTempDate2,');
        Add(' Permits.AssessorNextInspDate, ');
        Add(' Permits.AssessorOfficeClosed,');
        Add(' Permits.Deleted');
        Add('FROM Parcels');
        Add(' INNER JOIN ParcelPermitMap ON (Parcels.Parcel_ID = ParcelPermitMap.Parcel_ID)');
        Add(' INNER JOIN Permits ON (ParcelPermitMap.Permit_ID = Permits.Permit_ID)');
        Add('WHERE (Parcels.SwisSBLKey = ' + FormatSQLString(SwisSBLKey) + ') and ');
        Add('      ((Permits.Deleted is null) or (Permits.Deleted = 0))');
        Add('ORDER BY Permits.PermitDate DESC');
      end; {with SQL do begin}

      Open;

    except
    end; {adoPermits}

  FirstTimeThrough := True;
  NumPermits := 0;

  adoPermits.First;

  with adoPermits do
    repeat
      If FirstTimeThrough
        then FirstTimeThrough := False
        else Next;

      Done := EOF;

      If not Done
        then
          begin
            NumPermits := NumPermits + 1;

            with Sender as TBaseReport do
              begin
                NewPageStarted := False;

                  {See if we need to go to a new page.}

                DBMemoBuf := TDBMemoBuf.Create;
                DBMemoBuf.Field := TMemoField(FieldByName('Description'));

                DBMemoBuf.PrintStart := 0.5;
                DBMemoBuf.PrintEnd := 7.9;

                If ((LinesLeft - MemoLines(DBMemoBuf) - 1) < 5)
                  then
                    begin
                      NewPageStarted := True;
                      NewPage;
                      PrintParcelHeader(Sender, AssessmentYear, Options, PicturePrinted);

                    end;  {If ((LinesLeft + DBMemoBuf.MemoLines + 1) < 5)}

                If ((NumPermits = 1) or
                    NewPageStarted)
                  then
                    begin
                      Println('');
                      Bold := True;
                      ClearTabs;
                      SetTab(0.1, pjCenter, 7.8, 0, BOXLINETop, 0);   {Prior}
                      Println(#9 + 'Permits');
                      Println('');

                      ClearTabs;
                      SetTab(0.3, pjCenter, 1.1, 0, BoxLineAll, 25);   {Permit #}
                      SetTab(1.4, pjCenter, 1.0, 0, BoxLineAll, 25);   {Permit Date}
                      SetTab(2.4, pjCenter, 1.0, 0, BoxLineAll, 25);   {Cost}
                      SetTab(3.4, pjCenter, 1.0, 0, BoxLineAll, 25);   {Perm Type}
                      SetTab(4.4, pjCenter, 1.0, 0, BoxLineAll, 25);   {Perm Status}
                      SetTab(5.4, pjCenter, 1.0, 0, BoxLineAll, 25);   {CO Date}

                      Println(#9 + 'Permit #' +
                              #9 + 'Permit Date' +
                              #9 + 'Cost' +
                              #9 + 'Perm Type' +
                              #9 + 'Perm Status' +
                              #9 + 'CO Issued');

                      Bold := False;

                    end;  {If (NumPermits = 1)}

                  {Print the info.}

                ClearTabs;
                SetTab(0.3, pjLeft, 1.1, 4, BoxLineAll, 0);   {Permit #}
                SetTab(1.4, pjLeft, 1.0, 4, BoxLineAll, 0);   {Permit Date}
                SetTab(2.4, pjRight, 1.0, 4, BoxLineAll, 0);   {Cost}
                SetTab(3.4, pjCenter, 1.0, 4, BoxLineAll, 0);   {Permit Type}
                SetTab(4.4, pjCenter, 1.0, 4, BoxLineAll, 0);   {Permit Status}
                SetTab(5.4, pjCenter, 1.0, 4, BoxLineAll, 0);   {CO Date}

                try
                  fConstCost := FieldByName('ConstCost').AsFloat;
                except
                  fConstCost := 0;
                end;

                (*sCertificateDate := GetMunicityCODateForPermit(ADOQuery2,
                                                               FieldByName('PermitsPermitID').AsString,
                                                               FieldByName('MapParcelID').AsString); *)

                Println(#9 + FieldByName('PermitNo').Text +
                        #9 + FieldByName('PermitDate').Text +
                        #9 + FormatFloat(DecimalDisplay_BlankZero, fConstCost) +
                        #9 + FieldByName('PermitType').AsString +
                        #9 + FieldByName('PermStatus').AsString +
                        #9 + FieldByName('CertOccupancyDate').AsString);

                PrintMemo(DBMemoBuf, 0, False);
                Println('');
                DBMemoBuf.Free;

              end;  {with Sender as TBaseReport, PermitsTable do}

          end;  {If not Done}

    until Done;

  try
    adoPermits.Close;
    adoPermits.Free;
  except
  end;

end;  {PrintPermits}

{===========================================================================}
Procedure PrintParcel(Sender : TObject;
                      AssessmentYear : String;
                      ProcessingType : Integer;
                      SwisSBLKey : String;
                      Options : OptionsSet);

var
  CodeTable : TTable;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  BasicSTARAmount, EnhancedSTARAmount : Comp;
  EXTotArray : ExemptionTotalsArrayType;
  PrintNextYear : Boolean;
  PicturePrinted : Boolean;

begin
  CodeTable := TTable.Create(nil);
  PicturePrinted := False;

  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;

  EXTotArray := TotalExemptionsForParcel(AssessmentYear, SwisSBLKey,
                           ExemptionTable,
                           ExemptionCodeTable,
                           ParcelTable.FieldByName('HomesteadCode').Text,
                           'A',
                           ExemptionCodes,
                           ExemptionHomesteadCodes,
                           ResidentialTypes,
                           CountyExemptionAmounts,
                           TownExemptionAmounts,
                           SchoolExemptionAmounts,
                           VillageExemptionAmounts,
                           BasicSTARAmount, EnhancedSTARAmount);

  PrintParcelHeader(Sender, AssessmentYear, Options, PicturePrinted);

    {First print the base information if they want to see it.}

  If (ptBaseInformation in Options)
    then PrintBaseInformationSection(Sender, CodeTable, PicturePrinted);

    {FXX12081999-1: Make sure that if they are not allowed to see NY,
                    we don't print it.}

  If (ptAssessments in Options)
    then
      begin
        PrintNextYear := (ptPrintNextYear in Options);

        PrintAssessmentSection(Sender, SwisSBLKey,
                               ProcessingType, EXTotArray,
                               ExemptionCodes,
                               ExemptionHomesteadCodes,
                               ResidentialTypes,
                               CountyExemptionAmounts,
                               TownExemptionAmounts,
                               SchoolExemptionAmounts,
                               VillageExemptionAmounts,
                               BasicSTARAmount, EnhancedSTARAmount,
                               PrintNextYear, Options);

      end;  {If (ptAssessments in Options)}

  If (ptExemptions in Options)
    then PrintExemptionSection(Sender, AssessmentYear, SwisSBLKey,
                               ExemptionCodes,
                               ExemptionHomesteadCodes,
                               ResidentialTypes,
                               CountyExemptionAmounts,
                               TownExemptionAmounts,
                               SchoolExemptionAmounts,
                               VillageExemptionAmounts,
                               BasicSTARAmount, EnhancedSTARAmount);

    {FXX07192001-1: After an F5 print, it was not resetting the range.}

  ExemptionTable.CancelRange;
  SetRangeOld(ExemptionTable,
              ['TaxRollYr', 'SwisSBLKey', 'ExemptionCode'],
              [AssessmentYear, SwisSBLKey, '     '],
              [AssessmentYear, SwisSBLKey, '99999']);

  If (ptSpecialDistricts in Options)
    then PrintSpecialDistrictSection(Sender, AssessmentYear,
                                     ProcessingType, SwisSBLKey,
                                     Options, PicturePrinted);

  If (ptSales in Options)
    then PrintSales(Sender, SwisSBLKey);

  If (ptResidentialInventory in Options)
    then PrintResidentialInventory(Sender, AssessmentYear, SwisSBLKey,
                                   Options, PicturePrinted);

  If (ptCommercialInventory in Options)
    then PrintCommercialInventory(Sender, AssessmentYear, SwisSBLKey,
                                  Options, PicturePrinted);

    {CHG03282002-11: Allow them to print notes.}

  If (ptNotes in Options)
    then PrintNotes(Sender, SwisSBLKey, AssessmentYear,
                    Options, PicturePrinted);

     {CHG04302006-1(2.9.7.1): Allow the for permit printing.}

  If (ptPermits in Options)
    then PrintPermits_Municity(Sender, SwisSBLKey, AssessmentYear,
                               Options, PicturePrinted);

  CodeTable.Close;
  CodeTable.Free;

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;

end;  {PrintParcel}

{===========================================================================}
Procedure PrintSketch(tbSketch : TTable;
                      sSwisSBLKey : String);

begin
  If (GlblUsesSketches and
      (tbSketch = nil))
  then
  begin
    tbSketch := TTable.Create(nil);

    with tbSketch do
    try
      DatabaseName := 'PASSystem';
      TableType := ttDBase;
      TableName := SketchTableName;
      IndexName := 'BYSWISSBLKEY_SKETCHNUMBER';
      Open;
    except
    end;

    try
      SketchPanel := TPanel.Create(nil);
      ApexXv4 := TExchange2X.Create(SketchPanel);

      with ApexXv4 do
        begin
          Align := alClient;
          AreaPage := 0;
          CurrentPage := 1;
          Color := clWhite;
          Parent := SketchPanel;
          ShowHint := True;
          StartMinimized := True;
          ShowSplashScreen := False;
          SketchForm := $2000;

        end;  {with ApexXv4 do}

    except
    end;

    ApexInstalled := True;

    If GlblUserIsSearcher
      then ApexInstalled := False;

    If ApexInstalled
      then ApexInstalled := ApexIsInstalledOnComputer;

  end;  {If GlblUsesSketches}

  _SetRange(tbSketch, [sSwisSBLKey, 0], [sSwisSBLKey, 9999], '', []);

  If _Compare(tbSketch.RecordCount, 0, coGreaterThan)
  then
    with tbSketch, ApexXV4 do
    try
      First;
      CloseSketch;
      OpenSketchFile(GetSketchLocation(tbSketch, ApexInstalled));
      UpdateSketchData;
      Refresh;
      Application.ProcessMessages;
      (*ApexPrint;*)
      RunDDEMacro('File;Print');
      CloseSketch;
      CloseApex;
    except
    end;

end;  {PrintSketch}

(*
{===========================================================================}
Procedure PrintPropertyCard(tbPropertyCard : TTable;
                            sSwisSBLKey : String);

begin
  If (tbPropertyCard = nil)
  then
  begin
    tbPropertyCard := TTable.Create(nil);

    with tbPropertyCard do
    try
      DatabaseName := 'PASSystem';
      TableType := ttDBase;
      TableName := PropertyCardTableName;
      IndexName := 'BYSWISSBLKEY_DOCUMENTNUMBER';
      Open;
    except
    end;

  end;


  _SetRange(tbPropertyCard, [sSwisSBLKey, 0], [sSwisSBLKey, 9999], '', []);

  If _Compare(tbPropertyCard.RecordCount, 0, coGreaterThan)
  then
    with tbPropertyCard do
    try
      Last;

      try
        Printer.Refresh;
        Image := TPMultiImage.Create(nil);
        Image.GetInfoAndType(FieldByName('DocumentLocation').Text);
        Image.ImageName := FieldByName('DocumentLocation').AsString;

        PrintImage(Image, Application.Handle, 0, 0, Printer.PageWidth, Printer.PageHeight,
                   0, 999, False);

        Image.Free;
        Image := nil;
      except
      end;

    except
    end;

end;  {PrintPropertyCard}  *)

{===========================================================================}
Procedure PrintAParcel(Sender : TObject;  {Report printer\filer}
                       SwisSBLKey : String;
                       ProcessingType : Integer;
                       Options : OptionsSet);

var
  SBLRec : SBLRecord;
  AssessmentYear : String;

begin
  AssessmentYear := GetTaxRollYearForProcessingType(ProcessingType);

    {Create and open all tables.}

  PriorAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                                 History);
  TYAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                              ThisYear);
  NYAssessmentTable := FindTableInDataModuleForProcessingType(DataModuleAssessmentTableName,
                                                              NextYear);
  ExemptionCodeTable := FindTableInDataModuleForProcessingType(DataModuleExemptionCodeTableName,
                                                               ProcessingType);
  ExemptionTable := FindTableInDataModuleForProcessingType(DataModuleExemptionTableName,
                                                           ProcessingType);
  SDCodeTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictCodeTableName,
                                                        ProcessingType);
  SDTable := FindTableInDataModuleForProcessingType(DataModuleSpecialDistrictTableName,
                                                    ProcessingType);
  ParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                        ProcessingType);
  ClassTable := FindTableInDataModuleForProcessingType(DataModuleClassTableName,
                                                       ProcessingType);
  SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                          ProcessingType);
  SalesTable := FindTableInDataModuleForProcessingType(DataModuleSalesTableName,
                                                       NoProcessingType);
  SchoolCodeTable := FindTableInDataModuleForProcessingType(DataModuleSchoolCodeTableName,
                                                            ProcessingType);
  SwisCodeTable := FindTableInDataModuleForProcessingType(DataModuleSwisCodeTableName,
                                                          ProcessingType);
  ParcelTable := FindTableInDataModuleForProcessingType(DataModuleParcelTableName,
                                                        ProcessingType);

  If (ptCommercialInventory in Options)
    then
      begin
        ComSiteTable := FindTableInDataModuleForProcessingType(DataModuleCommercialSiteTableName,
                                                               ProcessingType);
        ComBldgTable := FindTableInDataModuleForProcessingType(DataModuleCommercialBuildingTableName,
                                                               ProcessingType);
        ComLandTable := FindTableInDataModuleForProcessingType(DataModuleCommercialLandTableName,
                                                               ProcessingType);
        ComImprovementTable := FindTableInDataModuleForProcessingType(DataModuleCommercialImprovementTableName,
                                                                      ProcessingType);
        ComRentTable := FindTableInDataModuleForProcessingType(DataModuleCommercialRentTableName,
                                                               ProcessingType);
        ComIncExpTable := FindTableInDataModuleForProcessingType(DataModuleCommercialIncomeExpenseTableName,
                                                                 ProcessingType);

      end;  {If (ptCommercialInventory in Options)}

  If (ptResidentialInventory in Options)
    then
      begin
        ResForestTable := FindTableInDataModuleForProcessingType(DataModuleResidentialForestTableName,
                                                                 ProcessingType);
        ResLandTable := FindTableInDataModuleForProcessingType(DataModuleResidentialLandTableName,
                                                               ProcessingType);
        ResImprovementTable := FindTableInDataModuleForProcessingType(DataModuleResidentialImprovementTableName,
                                                                      ProcessingType);
        ResBldgTable := FindTableInDataModuleForProcessingType(DataModuleResidentialBuildingTableName,
                                                               ProcessingType);
        ResSiteTable := FindTableInDataModuleForProcessingType(DataModuleResidentialSiteTableName,
                                                               ProcessingType);

      end;  {If (ptResidentialInventory in Options)}

  tbAssessmentYearControl := FindTableInDataModuleForProcessingType(DataModuleAssessmentYearControlTableName,
                                                                    ProcessingType);

  SalesTable.IndexName := SalesTableSwisSBL_SalesNumberKey;
(*  ComSiteTable.IndexName := InventoryYear_SwisSBLKey;
  ComBldgTable.IndexName := InventoryYear_SwisSBLKey;
  ComLandTable.IndexName := InventoryYear_SwisSBLKey;
  ComImprovementTable.IndexName := InventoryYear_SwisSBLKey;
  ComRentTable.IndexName := InventoryYear_SwisSBLKey;
  ComIncExpTable.IndexName := InventoryYear_SwisSBLKey;
  ResForestTable.IndexName := InventoryYear_SwisSBLKey;
  ResLandTable.IndexName := InventoryYear_SwisSBLKey;
  ResImprovementTable.IndexName := InventoryYear_SwisSBLKey;
  ResBldgTable.IndexName := InventoryYear_SwisSBLKey;
  ResSiteTable.IndexName := InventoryYear_SwisSBLKey; *)
  ParcelTable.IndexName := ParcelTable_Year_Swis_SBLKey;
  PriorAssessmentTable.IndexName := OtherTableYear_SwisSBLKey;
  TYAssessmentTable.IndexName := OtherTableYear_SwisSBLKey;
  NYAssessmentTable.IndexName := OtherTableYear_SwisSBLKey;
  ClassTable.IndexName := OtherTableYear_SwisSBLKey;
  ExemptionTable.IndexName := ExemptionTableYear_SwisSBL_EXKey;
  SDTable.IndexName := SDTableYear_SwisSBL_SDKey;
  SchoolCodeTable.IndexName := 'BYSCHOOLCODE';
  SwisCodeTable.IndexName := 'BYSWISCODE';
  ExemptionCodeTable.IndexName := 'BYEXCODE';
  SDCodeTable.IndexName := 'BYSDISTCODE';

  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  with SBLRec do
    FindKeyOld(ParcelTable,
               ['TaxRollYr', 'SwisCode', 'Section',
                'Subsection', 'Block', 'Lot', 'Sublot',
                'Suffix'],
               [AssessmentYear, SwisCode, Section, Subsection,
                Block, Lot, Sublot, Suffix]);

  If not NotesTable.Active
    then
      try
        NotesTable.Open;
      except
      end;

  PrintParcel(Sender, AssessmentYear, ProcessingType, SwisSBLKey, Options);

(*  If (ptPropertyCard in Options)
  then PrintPropertyCard(tbPropertyCard, SwisSBLKey);  *)

  If (ptSketches in Options)
  then PrintSketch(tbSketch, SwisSBLKey);

end;  {PrintAParcel}

initialization

    {CHG03282002-11: Allow them to print notes.}

  NotesTable := TTable.Create(nil);

  with NotesTable do
  try
    DatabaseName := 'PropertyAssessmentSystem';
    TableType := ttDBase;
    TableName := NotesTableName;
    Open;
  except
  end;


finalization
  try
    NotesTable.Close;
    NotesTable.Free;
    tbSketch.Close;
    tbSketch.Free;
    SketchPanel.Free;
    //ApexXv4.CloseApex;
    ApexXv4.Free;
  except
  end;

  try
    tbPropertyCard.Close;
    tbPropertyCard.Free;
  except
  end;

end.