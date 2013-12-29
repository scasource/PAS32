unit Blprtunt;

interface

USES Types, Glblvars, SysUtils, WinTypes, WinProcs, BtrvDlg,
     Messages, Dialogs, Forms, wwTable, Classes, DB, DBTables, EXTCtrls,
     Controls,DBCtrls,StdCtrls, PASTypes, WinUtils, GlblCnst, Utilitys,
     wwDBLook, Graphics, RPBase, RPDefine,  wwdbGrid, PASUTILS,
     UTILEXSD, UTILBILL, RPrinter, RPFiler, DataAccessUnit;

Function PrintOneHastingsBill(Sender : TObject;
                              ReportPrinter : TReportPrinter;
                              ReportFiler : TReportFiler;
                              ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                              SwisSBLKey : String;
                              FormattedSwisSBLKey : String;
                              SchoolCodeTable,
                              SwisCodeTable,
                              CollectionLookupTable,
                              tb_Header,
                              BLGeneralTaxTable,
                              BLSpecialDistrictTaxTable,
                              BLExemptionTaxTable,
                              BLSpecialFeeTaxTable,
                              BillParameterTable : TTable;
                              SDCodeDescList,
                              EXCodeDescList,
                              PropertyClassDescList,
                              GeneralRateList,
                              SDRateList,
                              SpecialFeeRateList : TList;
                              ArrearsMessage : TStringList;
                              ThirdPartyNotificationTable : TTable;
                              CurrentlyPrintingThirdPartyNotices : Boolean;
                              TopSectionStart,
                              BaseDetailsStart,
                              BottomSectionStart : Double) : Boolean;


Function PrintOneWesleyBill(Sender : TObject;
                              ReportPrinter : TReportPrinter;
                              ReportFiler : TReportFiler;
                              ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                              SwisSBLKey : String;
                              FormattedSwisSBLKey : String;
                              SchoolCodeTable,
                              SwisCodeTable,
                              CollectionLookupTable,
                              tb_Header,
                              BLGeneralTaxTable,
                              BLSpecialDistrictTaxTable,
                              BLExemptionTaxTable,
                              BLSpecialFeeTaxTable,
                              BillParameterTable,
                              ParcelTable : TTable;
                              SDCodeDescList,
                              EXCodeDescList,
                              PropertyClassDescList,
                              GeneralRateList,
                              SDRateList,
                              SpecialFeeRateList : TList;
                              ArrearsMessage : TStringList;
                              ThirdPartyNotificationTable : TTable;
                              CurrentlyPrintingThirdPartyNotices : Boolean;
                              TopSectionStart : Double) : Boolean;

Function PrintOneSomersTownBill(Sender : TObject;
                                ReportPrinter : TReportPrinter;
                                ReportFiler : TReportFiler;
                                ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                                SwisSBLKey : String;
                                FormattedSwisSBLKey : String;
                                SchoolCodeTable,
                                SwisCodeTable,
                                CollectionLookupTable,
                                tb_Header,
                                BLGeneralTaxTable,
                                BLSpecialDistrictTaxTable,
                                BLExemptionTaxTable,
                                BLSpecialFeeTaxTable,
                                BillParameterTable,
                                ParcelTable : TTable;
                                SDCodeDescList,
                                EXCodeDescList,
                                PropertyClassDescList,
                                GeneralRateList,
                                SDRateList,
                                SpecialFeeRateList : TList;
                                ArrearsMessage : TStringList;
                                ThirdPartyNotificationTable : TTable;
                                CurrentlyPrintingThirdPartyNotices : Boolean;
                                TopSectionStart,
                                BaseDetailsStart,
                                BottomSectionStart : Double) : Boolean;

Function PrintOneSomersSchoolBill(Sender : TObject;
                                  ReportPrinter : TReportPrinter;
                                  ReportFiler : TReportFiler;
                                  ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                                  SwisSBLKey : String;
                                  FormattedSwisSBLKey : String;
                                  SchoolCodeTable,
                                  SwisCodeTable,
                                  CollectionLookupTable,
                                  tb_Header,
                                  BLGeneralTaxTable,
                                  BLSpecialDistrictTaxTable,
                                  BLExemptionTaxTable,
                                  BLSpecialFeeTaxTable,
                                  BillParameterTable,
                                  ParcelTable : TTable;
                                  SDCodeDescList,
                                  EXCodeDescList,
                                  PropertyClassDescList,
                                  GeneralRateList,
                                  SDRateList,
                                  SpecialFeeRateList : TList;
                                  ArrearsMessage : TStringList;
                                  ThirdPartyNotificationTable : TTable;
                                  CurrentlyPrintingThirdPartyNotices : Boolean;
                                  TopSectionStart,
                                  BaseDetailsStart,
                                  BottomSectionStart : Double) : Boolean;

Function PrintOneRyeBill(Sender : TObject;
                         ReportPrinter : TReportPrinter;
                         ReportFiler : TReportFiler;
                         ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                         CollectionType : String;
                         SwisSBLKey : String;
                         FormattedSwisSBLKey : String;
                         SchoolCodeTable,
                         SwisCodeTable,
                         CollectionLookupTable,
                         tb_Header,
                         BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         BillParameterTable,
                         ParcelTable : TTable;
                         SDCodeDescList,
                         EXCodeDescList,
                         PropertyClassDescList,
                         GeneralRateList,
                         SDRateList,
                         SpecialFeeRateList : TList;
                         ArrearsMessage : TStringList;
                         ThirdPartyNotificationTable : TTable;
                         CurrentlyPrintingThirdPartyNotices : Boolean) : Boolean;

Function PrintOneMtPleasantSchoolBill(ReportPrinter : TReportPrinter;
                                      ReportFiler : TReportFiler;
                                      ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                                      SwisSBLKey : String;
                                      FormattedSwisSBLKey : String;
                                      SchoolCodeTable,
                                      SwisCodeTable,
                                      CollectionLookupTable,
                                      tb_Header,
                                      BLGeneralTaxTable,
                                      BLSpecialDistrictTaxTable,
                                      BLExemptionTaxTable,
                                      BLSpecialFeeTaxTable,
                                      BillParameterTable : TTable;
                                      SDCodeDescList,
                                      EXCodeDescList,
                                      PropertyClassDescList,
                                      GeneralRateList,
                                      SDRateList,
                                      SpecialFeeRateList : TList;
                                      ArrearsMessage : TStringList;
                                      ThirdPartyNotificationTable : TTable;
                                      CurrentlyPrintingThirdPartyNotices : Boolean;
                                      MPSchoolBaseDetailsStart : Double;
                                      TopSectionStart : Double) : Boolean;

Function PrintOneMtPleasantTownBill(ReportPrinter : TReportPrinter;
                                    ReportFiler : TReportFiler;
                                    ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                                    SwisSBLKey : String;
                                    FormattedSwisSBLKey : String;
                                    SchoolCodeTable,
                                    SwisCodeTable,
                                    CollectionLookupTable,
                                    tb_Header,
                                    BLGeneralTaxTable,
                                    BLSpecialDistrictTaxTable,
                                    BLExemptionTaxTable,
                                    BLSpecialFeeTaxTable,
                                    BillParameterTable : TTable;
                                    SDCodeDescList,
                                    EXCodeDescList,
                                    PropertyClassDescList,
                                    GeneralRateList,
                                    SDRateList,
                                    SpecialFeeRateList : TList;
                                    ArrearsMessage : TStringList;
                                    ThirdPartyNotificationTable : TTable;
                                    CurrentlyPrintingThirdPartyNotices : Boolean;
                                    TopSectionStart,
                                    BaseDetailsStart : Double) : Boolean;

Function PrintOneLawrenceBill(Sender : TObject;
                              SwisSBLKey : String;
                              SwisCodeTable,
                              CollectionLookupTable,
                              tb_Header,
                              BLGeneralTaxTable,
                              BLSpecialDistrictTaxTable,
                              BLExemptionTaxTable,
                              BLSpecialFeeTaxTable,
                              BillParameterTable,
                              ParcelTable : TTable;
                              SDCodeDescList,
                              EXCodeDescList,
                              PropertyClassDescList,
                              GeneralRateList,
                              SDRateList,
                              SpecialFeeRateList : TList;
                              ArrearsMessage : TStringList;
                              ThirdPartyNotificationTable : TTable;
                              CurrentlyPrintingThirdPartyNotices : Boolean;
                              TopSectionStart : Double) : Boolean;

Procedure AddOneBrookvilleRAVEBill(SwisSBLKey : String;
                                   RAVEBillCollectionInfoTable,
                                   RAVEBillHeaderInfoTable,
                                   RAVEBillBaseSDDetailsTable,
                                   RAVEBillEXDetailsTable,
                                   tb_Header,
                                   BLGeneralTaxTable,
                                   BLExemptionTaxTable,
                                   BLSpecialDistrictTaxTable,
                                   BLSpecialFeeTaxTable,
                                   BillControlTable,
                                   BillParameterTable,
                                   SwisCodeTable : TTable;
                                   GeneralRateList,
                                   SDRateList,
                                   SpecialFeeRateList,
                                   BillControlDetailList,
                                   PropertyClassDescList,
                                   RollSectionDescList,
                                   EXCodeDescList,
                                   SDCodeDescList,
                                   SwisCodeDescList,
                                   SchoolCodeDescList,
                                   SDExtCodeDescList,
                                   GnTaxList,
                                   SDTaxList,
                                   SpTaxList,
                                   ExTaxList : TList;
                                   ArrearsMessage : TStringList);

Procedure AddOneScarsdaleRAVEBill(SwisSBLKey : String;
                                  CollectionType : String;
                                  AssessmentYear : String;
                                  CollectionNumber : Integer;
                                  RAVEBillCollectionInfoTable,
                                  RAVEBillHeaderInfoTable,
                                  RAVELeviesTable,
                                  RAVEBillEXDetailsTable,
                                  tb_Header,
                                  BLGeneralTaxTable,
                                  BLExemptionTaxTable,
                                  BLSpecialDistrictTaxTable,
                                  BLSpecialFeeTaxTable,
                                  BillControlTable,
                                  BillParameterTable,
                                  BillArrearsTable,
                                  SchoolCodeTable,
                                  SwisCodeTable : TTable;
                                  GeneralRateList,
                                  SDRateList,
                                  SpecialFeeRateList,
                                  BillControlDetailList,
                                  PropertyClassDescList,
                                  RollSectionDescList,
                                  EXCodeDescList,
                                  SDCodeDescList,
                                  SwisCodeDescList,
                                  SchoolCodeDescList,
                                  SDExtCodeDescList,
                                  GnTaxList,
                                  SDTaxList,
                                  SpTaxList,
                                  ExTaxList : TList;
                                  ArrearsMessage : TStringList);

Procedure AddOneStandardRAVEBill(SwisSBLKey : String;
                                 CollectionType : String;
                                 AssessmentYear : String;
                                 CollectionNumber : Integer;
                                 RAVEBillCollectionInfoTable,
                                 RAVEBillHeaderInfoTable,
                                 RAVELeviesTable,
                                 RAVEBillEXDetailsTable,
                                 RAVELevyChangeTable,
                                 tb_Header,
                                 tb_GeneralTaxes,
                                 tb_Exemptions,
                                 tb_SpecialDistricts,
                                 tb_SpecialFees,
                                 BillControlTable,
                                 BillParameterTable,
                                 BillArrearsTable,
                                 SchoolCodeTable,
                                 SwisCodeTable,
                                 LastYearGeneralTaxTable,
                                 LastYearSpecialDistrictTaxTable,
                                 GeneralTaxRateTable,
                                 ThirdPartyNotificationTable,
                                 AssessmentYearControlTable : TTable;
                                 CurrentlyPrintingThirdPartyNotices : Boolean;
                                 GeneralRateList,
                                 SDRateList,
                                 SpecialFeeRateList,
                                 BillControlDetailList,
                                 PropertyClassDescList,
                                 RollSectionDescList,
                                 EXCodeDescList,
                                 SDCodeDescList,
                                 SwisCodeDescList,
                                 SchoolCodeDescList,
                                 SDExtCodeDescList,
                                 GnTaxList,
                                 SDTaxList,
                                 SpTaxList,
                                 ExTaxList : TList;
                                 ArrearsMessage : TStringList;
                                 BillsPrinted : LongInt;
                                 TaxRatePerHundred : Boolean;
                                 PadDetailLines : Boolean;
                                 OldSwisSBLKey : String;
                                 bDisplayCommasInExemptionAmount : Boolean;
                                 sTaxRateDisplayFormat : String;
                                 bUserDefinedPrintOrder : Boolean;
                                 bIncludeOrCurrentOwner : Boolean);

implementation

{======================================================================}
Procedure PrintOneHastingsPage(    Sender : TObject;
                                   BaseReportObject : TBaseReport;
                                   SwisSBLKey : String;
                                   FormattedSwisSBLKey : String;
                                   GnTaxList,
                                   SDTaxList,
                                   SpTaxList,
                                   ExTaxList : TList;
                                   SchoolCodeTable,
                                   SwisCodeTable,
                                   CollectionLookupTable,
                                   tb_Header,
                                   BLGeneralTaxTable,
                                   BLSpecialDistrictTaxTable,
                                   BLExemptionTaxTable,
                                   BLSpecialFeeTaxTable,
                                   BillParameterTable : TTable;
                                   SDCodeDescList,
                                   EXCodeDescList,
                                   PropertyClassDescList,
                                   GeneralRateList,
                                   SDRateList,
                                   SpecialFeeRateList : TList;
                                   ArrearsMessage : TStringList;
                                   ThirdPartyNotificationTable : TTable;
                                   CurrentlyPrintingThirdPartyNotices : Boolean;
                                   TopSectionStart,
                                   BaseDetailsStart,
                                   BottomSectionStart : Double;
                               var PageNo,
                                   SDIndex : Integer);
{DS: Special version for village of Hastings-on-hudson ny - must be made into dll for production
     jmg 4/21/1999}

const
  Topmarg = 3;  {blank lines at top of page}
  MaxTaxLinesPerPage = 2;  {was 26 special for hastings is 2 village tax and one
                            space afterward}

var
  Index, I, J, RateIndex,LinesPrinted : Integer;
  NAddrArray : NameAddrArray;
  TempEXCode : String;
  UniformPercentValue,
  Temprl, TempReal, STARSavings : Double;
  TempStr : String;
  EXAppliesArray : ExemptionAppliesArrayType;
  TempPtr : SDistTaxPtr;
  TempStr2 : String;
  CL1List,
  CL2List,
  CL3List,
  CL4List,
  CL5List,
  CL6List,
  CL7List : TStringList;
  SchoolCode : String;
  SwisCode : String;
  LastSDCode, TaxableValStr : String;
  iLowMarketValue, iHighMarketValue : LongInt;

begin
  {create string list for printing parallel non-related data }
    {across the page; eg Name/addr info in cl1list, ex data }
    {in CL2List}

  CL1List := TStringList.Create;
  CL2List := TStringList.Create;
  CL3List := TStringList.Create;
  CL4List := TStringList.Create;
  CL5List := TStringList.Create;
  CL6List := TStringList.Create;
  CL7List := TStringList.Create;

  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}
      (*  see gotoxy call below
      For I := 1 to TopMarg do
        Println('');  {Skip down to first line that we actually print - Swis Code}
      *)
    end;  {with Sender as TBaseReport do}

  with Sender as TBaseReport, tb_Header do
    begin
        {print the bill on the form}
         {>>> TAX MAP}

         {CHG03101999-2: Make the bill printing into a seperate DLL.}
         {Need to pass in formatted parcel ID since DLL will not have access to segment layouts.}
       {Print Swis Code}
       ClearTabs;
       gotoxy(0.1, TopSectionStart);  {Position to correct spoton page}
       Println('');
       SetTab(3.3,pjleft,2.0,0,BoxLineNone, 0);
       PrintLn('');
       PrintLn(#9 + FieldByName('SwisCode').Text);

       {Next tax map number without swiscode}
       Println(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));


        {If this is after the 1st page, don't print loc, dim, prop class, rs, or warrant.
         Instead, print page # }

      If (PageNo = 1)
        then
          begin
              {>>> PROP LOCATION      }

            Println(#9 + GetLegalAddressFromTable(tb_Header));

                {>>> DIMENSIONS      }

            If ((FieldByName('HstdAcreage').AsFloat > 0.0) or
                (FieldByName('NonHstdAcreage').AsFloat > 0.0))
              then Println(#9 + 'ACRES: ' +
                                FormatFloat(DecimalDisplay, (FieldByName('HstdAcreage').AsFloat) +
                                                            (FieldByName('NonHstdAcreage').AsFloat)))
              else Println(#9 + 'FRONTAGE: ' +
                                FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) +
                                ', DEPTH: ' +
                                FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat)) ;


                {>>> PROPERTY CLASS }

            ClearTabs;
            SetTab(3.6,pjleft,2.0,0,BoxLineNone, 0);
            Println(#9 + FieldByName('PropertyClassCode').Text + ' - ' +
                  UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                              PropertyClassDescList)));

                {>>> ROLL SECTION }

            Println(#9 + FieldByName('RollSection').Text);

                {>>> WARRANT DATE  }

            Println(#9 + BillParameterTable.FieldByName('WarrantDate').AsString);
          end  {PageNo = 1}
        else
          begin  {This leg should never execute for hastings}
            ClearTabs;
            SetTab(7.0, pjLeft, 1.0, 0, BOXLINENone, 0);   {Page #}
            Println('');
            Println('');
            Println('');
            Println(#9 + 'Page: ' + IntToStr(PageNo));
            Println('');

          end;  {else of If (PageNo > 1)}

          {>>> SPACE }
         Println('  ');

       {If this is the first page, print the name and address. Otherwise,
        print continued.}

     If (PageNo = 1)
       then
         begin
             {CHG01092002-1: 3rd party notices.}

           If CurrentlyPrintingThirdPartyNotices
             then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
             else GetNameAddress(tb_Header, NAddrArray);

               {fill in clist1 with name addr info}

           For I := 1 to 6 do
             CL1List.Add(NaddrArray[I]);
         end
       else
         begin
           CL1List.Add('*********   CONTINUED   *********');

           For I := 2 to 6 do
             CL1List.Add('');

         end;  {else of If (PageNo = 1)}

       {First line is hdr for exemptions.}

     CL2List.Add('');
     CL3List.Add('');
     CL4List.Add('');
     CL5List.Add('');

         {Now fill in exemptions}

      For I := 0 to (ExTaxList.Count - 1) do
        begin
          TempExCode := ExemptTaxPtr(ExTaxList[I])^.EXCode;
          EXAppliesArray := EXApplies(TempEXCode, False);

            {Exemption applies to town or town and county.}

          If EXAppliesArray[EXTown]
            then
              begin
               CL2List.Add(Take(10, ExemptTaxPtr(ExTaxList[I])^.Description));
               CL3List.Add(ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL4List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.TownAmount));

             end;  {If EXAppliesArray[EXSchool]}

            {If county only, print the county amount.}

          If (EXAppliesArray[EXCounty] and
              (not EXAppliesArray[EXTown]))
            then
              begin
               CL2List.Add(Take(10, ExemptTaxPtr(ExTaxList[I])^.Description));
               CL3List.Add(ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL4List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.CountyAmount));

             end;  {If EXAppliesArray[EXCounty]}

          CL5List.Add(FormatFloat(IntegerDisplay,
                                  ExemptTaxPtr(ExTaxList[I])^.FullValue));

        end;  {For I := 0 to (ExTaxList.Count - 1) do}

          {pad out rest of exemption columns to 6 lines to match Naddr clist}

      For I := (ExTaxList.Count) to 6 do
        begin
          CL2List.Add('');
          CL3List.Add('');
          CL4List.Add('');
          CL5List.Add('');
        end;

         {>>> NAME/ADDR AND EXEMPTIONS >>>}

      ClearTabs;
      SetTab(1.1, pjLeft, 3.2, 0, BOXLINENone, 0);   {Name / address}
      SetTab(5.0, pjLeft, 0.9, 0, BOXLINENone, 0);   {EX DESCR}
      SetTab(6.0, pjLeft, 0.4, 0, BOXLINENone, 0);   {EX CODE}
      SetTab(6.5, pjRight, 0.75, 0, BOXLINENone, 0); {EX Amount}
      SetTab(7.4, pjRight, 0.8, 0, BOXLINENone, 0); {Full value}

      For I := 0 to 5 do
        Println(#9 + CL1List[I] +
                #9 + CL2List[I] +
                #9 + CL3List[I] +
                #9 + CL4List[I] +
                #9 + CL5List[I]);

        {>>> Estimated state aid }
      ClearTabs;
      SetTab(0.8, pjRight,1.5, 0, BoxLineNone, 0);

      RateIndex := FindGeneralRate(-1, 'TO', '552607', GeneralRateList);

      If (RateIndex = -1)
        then RateIndex := FindGeneralRate(-1, 'VI', '552607', GeneralRateList);

      For I := 1 to 3 do
        Println('');

      ClearTabs;
      SetTab(0.8, pjRight, 1.5, 0, BOXLINENone, 0);   {tax year}
      SetTab(3.8, pjLeft, 1.5, 0, BOXLINENone, 0);   {fiscal year}

      Println(#9 + FormatFloat(CurrencyNormalDisplay,
                               GeneralRatePointer(GeneralRateList[RateIndex])^.EstimatedStateAid) +
              #9 + BillParameterTable.FieldByName('FiscalYear').Text);

        {>>> TAX YR, BillNo  }

      {Print Tax Year and Fiscal Year}
      Println(#9 + BillParameterTable.FieldByname('TaxYear').Text +
              #9 + DezeroOnLeft(FieldByName('BillNo').Text));

      {Next is bank code and bill number}
      Println(#9 + FieldByName('BankCode').Text);

         {>>> ASSESSMENT ROLL DATE }
         {FXX03181999-3: Had hardcoded town outside - need to
                         send in actual swis code.}

(*      RateIndex := FindGeneralRate(-1, 'TO', FieldByName('SwisCode').Text, GeneralRateList); *)
(*      RateIndex := FindGeneralRate(-1, 'VI', FieldByName('SwisCode').Text, GeneralRateList);*)
      Println(#9 + BillParameterTable.FieldByName('AssessmentRollDate').Text);

      GotoXY(1, BaseDetailsStart);

      {>>> PRINT TAX LINE }
      ClearTabs;
      SetTab(0.4, pjLeft, 1.8, 0, BOXLINENone, 0);   {purpose}
      SetTab(2.3, pjRight, 1.0, 0, BOXLINENone, 0);   {total levy}
      SetTab(3.6, pjRight, 0.5, 0, BOXLINENone, 0);   {% inc /dcr}
      SetTab(4.0, pjRight, 1.2, 0, BOXLINENone, 0);   {tax val}
      SetTab(5.3, pjRight, 0.2, 0, BOXLINENone, 0);   {extension}
      SetTab(5.6, pjRight, 1.0, 0, BOXLINENone, 0);   {tax rate}
      SetTab(6.7, pjRight, 1.0, 0, BOXLINENone, 0);   {tax amt}

      LinesPrinted := 0;

      If (PageNo = 1)
        then
          For I := 0 to (GnTaxList.Count - 1) do
            with GeneralTaxPtr(GnTaxList[I])^ do
              begin
                SwisCode := FieldByName('SwisCode').Text;

                  {Only search on the first 4 digits of swis code.}

                If (GeneralTaxType = 'CO')
                  then SwisCode := Take(4, SwisCode);

                RateIndex := FindGeneralRate(GeneralTaxPtr(GnTaxList[I])^.PrintOrder,
                                             GeneralTaxType, SwisCode, GeneralRateList);

                with GeneralRatePointer(GeneralRateList[RateIndex])^ do
                  begin
                    Println(#9 + (*Take(20, Description)*) Take(17,' ') + {In hastings, the description is already on the
                                                                           Bill form}
                            #9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy) +
                            #9 + FormatFloat(DecimalDisplay,
                                             ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                         PriorTaxLevy)) +
                            #9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal) +
                            #9 +
                            #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                            #9 + FormatFloat(DecimalDisplay, TaxAmount));

                  end;  {with GeneralRatePointer(GeneralRateList[RateIndex])^ do}

              LinesPrinted := LinesPrinted + 1;

            end;  {with GeneralTaxPtr(GnTaxList[I])^ do}

        {Print the SDs. - -  There are no SD's for hastings}

      LastSDCode := '';

      while ((SDIndex <= (SDTaxList.Count - 1)) and
             (LinesPrinted < MaxTaxLinesPerPage)) do
        with SDistTaxPtr(SDTaxList[SDIndex])^ do
          begin
            FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, Index);

            TaxRate := SDRatePointer(SDRateList[Index])^.HomesteadRate;

            If (Roundoff(TaxRate, 6) > 0.000000)
              then
                begin
                  Print(#9 + Take(17, Description));

                    {Only print levy amts for 1st extension of code.}

                  with SDRatePointer(SDRateList[Index])^ do
                    If (LastSDCode <> SDistTaxPtr(SDTaxList[SDIndex])^.SDistCode)
                      then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy) +
                                 #9 + FormatFloat(DecimalDisplay,
                                                  ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                              PriorTaxLevy)))
                      else Print(#9 + #9);


                  If (SDistTaxPtr(SDTaxList[SDIndex])^.ExtCode = 'TO')
                    then TaxableValStr := FormatFloat(CurrencyDisplayNoDollarSign, SdValue)
                    else TaxableValStr := FormatFloat(DecimalDisplay, SdValue);

                  Println(#9 + TaxableValStr +
                          #9 + SDistTaxPtr(SDTaxList[SDIndex])^.ExtCode +
                          #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                          #9 + FormatFloat(DecimalDisplay, SDAmount));

                  LastSDCode := SDistTaxPtr(SDTaxList[SDIndex])^.SDistCode;

                  LinesPrinted := LinesPrinted + 1;

                end;  {If (Roundoff(TaxRate, 0) > 0)}

            SDIndex := SDIndex + 1;

          end;  { with SDistTaxPtr(SDTaxList[I])^ do}

        {Now finish spacing through the tax section.}

      For I := (LinesPrinted + 1) to MaxTaxLinesPerPage do
        Println('');

      LinesPrinted := 0;

        {CHG03161999-1: Print arrears message on bill.}
        {Do we need to print an arrears message at the end?}

      If ((SDIndex > (SDTaxList.Count - 1)) and
          FieldByName('ArrearsFlag').AsBoolean)
        then
          For I := 0 to (ArrearsMessage.Count - 1) do
            begin
              Println(#9 + ArrearsMessage[I]);
              LinesPrinted := LinesPrinted + 1;
            end;

          {FXX03181999-2: Only 3 spaces.}

         {>>> 3 SPACES }

      For I := (LinesPrinted + 1) to 2 do
        Println('');


         {>>> FULL MARKET VALUE }

         {FXX07061998-2: Get the uniform % of value from the swis code table.}

     FindKeyOld(SwisCodeTable, ['SwisCode'],
                [FieldByName('SwisCode').Text]);

       {CHG05062010(2.24.1.3)[F]: Add a full market value range.}

     UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
(*     TempReal := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                   FieldByName('NonHstdTotalVal').AsFloat),
                                  SwisCodeTable,
                                  tb_Header.FieldByName('PropertyClassCode').Text,
                                  ' ', True); *)

     iLowMarketValue := ComputeFullValue((FieldByName('HstdTotalVal').AsInteger +
                                          FieldByName('NonHstdTotalVal').AsInteger),
                                         BillParameterTable.FieldByName('HighUniformPercent').AsFloat);
     iHighMarketValue := ComputeFullValue((FieldByName('HstdTotalVal').AsInteger +
                                           FieldByName('NonHstdTotalVal').AsInteger),
                                          BillParameterTable.FieldByName('LowUniformPercent').AsFloat);

     ClearTabs;
     SetTab(1.5, pjLeft, 4.0, 0, BOXLINENone, 0);   {Full mkt Valuation date}
     SetTab(4.7, pjLeft, 1.8, 0, BOXLINENone, 0);   {Calculated full mkt value}
     Println(#9 + BillParameterTable.FieldByName('FullMktValueDate').AsString +
                  ' to be between ' + FormatFloat(CurrencyNormalDisplay, iLowMarketValue) +
                  ' and ' + FormatFloat(CurrencyNormalDisplay, iHighMarketValue));

      {>>> ASSESSED VALUE and assessed value date}
     ClearTabs;
     SetTab(2.6, pjLeft, 1.3, 0, BOXLINENone, 0);   {Assessed Value}
     SetTab(4.7, pjLeft, 1.8, 0, BOXLINENone, 0);   {Assessed Value Date}

     Println(#9 + BillParameterTable.FieldByName('AssessmentRollDate').Text +
             #9 + FormatFloat(IntegerDisplay, (FieldByName('HstdTotalVal').AsFloat +
                                                 FieldByName('NonHstdTotalVal').AsFloat)));

         {>>> UNIF % VALUE  & date due}
     ClearTabs;
     SetTab(2.25, pjLeft, 1.0, 0, BOXLINENone, 0);   {Uniform Percent of value}
     Println(#9 + FormatFloat(DecimalDisplay, UniformPercentValue));
     (*
     PrintLn(''); {Skip a line here}
     *)
     ClearTabs;
     SetTab(5.7, pjright, 1.0, 0, BOXLINENone, 0);   {Box at right}
     SetTab(6.8, pjright, 1.0, 0, BOXLINENone, 0);   {}
     {First line in box are amounts 1H and 2H}
     Println(#9 + FormatFloat(DecimalDisplay,FieldByName('TaxPayment1').AsFloat) +
             #9 + FormatFloat(DecimalDisplay,FieldByName('Taxpayment2').AsFloat));
     {Next Line in box is penalty - just put out underscores}
     Println('');    {Skip this line, the underscores are now on the form}
     Println(#9 + FormatFloat(DecimalDisplay,FieldByName('TaxPayment1').AsFloat) +
             #9 + FormatFloat(DecimalDisplay,FieldByName('Taxpayment2').AsFloat));
     ClearTabs;
     SetTab(5.7, pjRight, 1.0, 0, BOXLINENone, 0);   {Box at right}
     SetTab(6.8, pjRight, 1.0, 0, BOXLINENone, 0);   {}

     Println(#9 + CollectionLookupTable.FieldbyName('PayDate1').Text +
             #9 + CollectionLookupTable.FieldByName('PayDate2').Text);


      GotoXY(1, BottomSectionStart);
       {Only print the stub if this is page 1.}

      If (PageNo = 1)
        then
          begin
              {>>> 2 SPACES }

           ClearTabs;
           SetTab(5.2, pjLeft, 1.5, 0, boxLineNone, 0);
           PrintLn(#9 + BillParameterTable.FieldByName('TaxYear').Text);
           Println(' '); {Skip one line (Stub line 4)}

           {Tax map #}

            ClearTabs;
            SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   { 2h stub sbl}
            Println(#9 + FormattedSwisSBLKey);

              {>>> 2 SPACES }

            For I := 1 to 2 do
              Println('');

               {>>> PROP LOCATION}

            ClearTabs;
            SetTab(1.0, pjLeft, 3.0, 0, BOXLINENone, 0);   {PROP LOC}
            Println(#9 + GetLegalAddressFromTable(tb_Header));

              {>>> BILL NO, BANK CODE}
            ClearTabs;
            SetTab(4.4, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
            SetTab(6.7, pjLeft, 1.0, 0, BOXLINENone, 0);   {BANK CODE}
            Println(#9 + DezeroOnLeft(tb_Header.FieldByName('BillNo').Text) +
                    #9 + tb_Header.FieldByName('BankCode').Text);

              {>>>  1 SPACE}
              Println('');

                {>>> AMOUNT DUE - First stub as amount due 2H}

            ClearTabs;
            SetTab(1.0, pjRight, 1.0, 0, BOXLINENone, 0);   {BILL NO}
            Println(#9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment2').AsFloat));

              {>>> 2 SPACES }

            For I := 1 to 2 do
              Println('');

               {>>> NAME LINE 1}

            ClearTabs;
            SetTab(1.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Due Date}
            SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {date/addr}

            Println(#9 + CollectionLookupTable.FieldByName('PayDate2').Text +
                    #9 + NAddrArray[1]);

            ClearTabs;
            SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {date/addr}

            For I := 2 to 6 do
              Println(#9 + NAddrArray[I]);

            {Two more spaces to bottom of stub 1}
            For I := 1 to 2 do
               Println('');

            {End of stub 1, begin stub 2}
           {>>> 2 SPACES }

            For I := 1 to 2 do
               Println('');  {Space down to asessment roll year}
           ClearTabs;
           SetTab(5.2, pjLeft, 1.5, 0, boxLineNone, 0);
           PrintLn(#9 + BillParameterTable.FieldByName('TaxYear').Text);
           Println(' '); {Skip one line (Stub line 4)}

            {Tax map #}
            ClearTabs;
            SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   { 2h stub sbl}
            Println(#9 + FormattedSwisSBLKey);

              {>>> 2 SPACES }

            For I := 1 to 2 do
              Println('');

               {>>> PROP LOCATION}

            ClearTabs;
            SetTab(1.0, pjLeft, 3.0, 0, BOXLINENone, 0);   {PROP LOC}
            Println(#9 + GetLegalAddressFromTable(tb_Header));

              {>>> BILL NO, BANK CODE}
            ClearTabs;
            SetTab(4.4, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
            SetTab(6.7, pjLeft, 1.0, 0, BOXLINENone, 0);   {BANK CODE}

            Println(#9 + DezeroOnLeft(tb_Header.FieldByName('BillNo').Text) +
                    #9 + tb_Header.FieldByName('BankCode').Text);

              {>>> 1 SPACE}
              Println('');

                {>>> AMOUNT DUE - Second and final stub has amount due 1h}

            ClearTabs;
            SetTab(1.0, pjRight, 1.0, 0, BOXLINENone, 0);   {BILL NO}
            Println(#9 + FormatFloat(DecimalDisplay, FieldByName('Taxpayment1').AsFloat));

              {>>> 2 SPACES }

            For I := 1 to 2 do
              Println('');

               {>>> NAME LINE 1}

            ClearTabs;
            SetTab(1.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Due Date}
            SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {date/addr}

            Println(#9 + CollectionLookupTable.FieldByName('PayDate1').Text +
                    #9 + NAddrArray[1]);

            ClearTabs;
            SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {date/addr}

            For I := 2 to 5 do
              Println(#9 + NAddrArray[I]);
           {Special Message on Last Stub - Only for 1999-2000, to be
            removed later}
            ClearTabs;
            SetTab(3.6, pjLeft, 4.0, 0, boxlineNone,0);
            Bold := True;
              {CHG05162000-3: Remove temporary address info.}
            Println('');
            Println('');
(*            Println(#9 + 'Village Hall is temporarily located at 615 Broadway, Hastings-On-Hudson.');
            PrintLn(#9 + 'Please return first half payment to that address.  Thanks.'); *)
            Bold := false;

          end;  {If (PageNo = 1)}

      Newpage;

    end;  {with Sender as TBaseReport do}

  CL1List.Free;
  CL2List.Free;
  CL3List.Free;
  CL4List.Free;
  CL5List.Free;
  CL6List.Free;
  CL7List.Free;

  PageNo := PageNo + 1;

end;  {PrintOneHastingsPage}

{======================================================================}
Function PrintOneHastingsBill(Sender : TObject;
                              ReportPrinter : TReportPrinter;
                              ReportFiler : TReportFiler;
                              ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                              SwisSBLKey : String;
                              FormattedSwisSBLKey : String;
                              SchoolCodeTable,
                              SwisCodeTable,
                              CollectionLookupTable,
                              tb_Header,
                              BLGeneralTaxTable,
                              BLSpecialDistrictTaxTable,
                              BLExemptionTaxTable,
                              BLSpecialFeeTaxTable,
                              BillParameterTable : TTable;
                              SDCodeDescList,
                              EXCodeDescList,
                              PropertyClassDescList,
                              GeneralRateList,
                              SDRateList,
                              SpecialFeeRateList : TList;
                              ArrearsMessage : TStringList;
                              ThirdPartyNotificationTable : TTable;
                              CurrentlyPrintingThirdPartyNotices : Boolean;
                              TopSectionStart,
                              BaseDetailsStart,
                              BottomSectionStart : Double) : Boolean;

var
  Quit : Boolean;
  PageNo, SDIndex : Integer;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  BaseReportObject : TBaseReport;

begin
  Quit := False;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

  If (ReportObjectToUse = 'P')
    then BaseReportObject := ReportPrinter
    else BaseReportObject := ReportFiler;

  with BaseReportObject do
    begin

         {Load the tax data  for this parcel}

      LoadTaxesForParcel(SwisSBLKey,
                         BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         SDCodeDescList, EXCodeDescList,
                         GeneralRateList, SDRateList,
                         SpecialFeeRateList, GnTaxList,
                         SDTaxList, SpTaxList, ExTaxList, Quit);

      PageNo := 1;
      SDIndex := 0;

      repeat
        PrintOneHastingsPage(Sender, BaseReportObject, SwisSBLKey, FormattedSwisSBLKey,
                             GnTaxList, SDTaxList, SpTaxList, ExTaxList,
                             SchoolCodeTable, SwisCodeTable,
                             CollectionLookupTable,
                             tb_Header,
                             BLGeneralTaxTable,
                             BLSpecialDistrictTaxTable,
                             BLExemptionTaxTable,
                             BLSpecialFeeTaxTable,
                             BillParameterTable,
                             SDCodeDescList,
                             EXCodeDescList,
                             PropertyClassDescList,
                             GeneralRateList,
                             SDRateList,
                             SpecialFeeRateList,
                             ArrearsMessage,
                             ThirdPartyNotificationTable,
                             CurrentlyPrintingThirdPartyNotices,
                             TopSectionStart, BaseDetailsStart,
                             BottomSectionStart, PageNo, SDIndex);

      until (SDIndex >= (SDTaxList.Count - 1))

    end;  {with BaseReportObject do}

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

  Result := Quit;

end;  {PrintOneHastingsBill}

{==========================================================================}
{======================== WESLEY HILLS ====================================}
{==========================================================================}

{======================================================================}
Function ConvertSwisSBLToNewDashDot(SwisSBLKey : String) : String;

var
  SBLRec : SBLRecord;
  TempStr, TempSublot, TempSuffix : String;

begin
  SBLRec := ExtractSwisSBLFromSwisSBLKey(SwisSBLKey);

  TempSublot := DezeroOnLeft(SBLRec.Sublot);
  TempSuffix := DezeroOnLeft(SBLRec.Suffix);

  with SBLRec do
    begin
      TempStr := DezeroOnLeft(Section);
      Result := TempStr + '.';

      TempStr := DezeroOnLeft(Subsection);
      Result := Result + TempStr + '-';

      TempStr := DezeroOnLeft(Block);
      Result := Result + TempStr + '-';

      TempStr := DezeroOnLeft(Lot);
      Result := Result + TempStr;

      If ((TempSublot <> '') or
          (TempSuffix <> ''))
        then Result := TempStr + '.';

      TempStr := DezeroOnLeft(Sublot);
      Result := Result + TempStr;

      If (TempSuffix <> '')
        then
          begin
            Result := Result + '-';
            TempStr := DezeroOnLeft(Suffix);
            Result := Result + TempStr;

          end;  {If (TempSuffix <> '')}

    end;  {with SBLRec do}

end;  {ConvertSwisSBLToNewDashDot}

{======================================================================}
Procedure PrintOneWesleyPage(    Sender : TObject;
                                 BaseReportObject : TBaseReport;
                                 SwisSBLKey : String;
                                 FormattedSwisSBLKey : String;
                                 GnTaxList,
                                 SDTaxList,
                                 SpTaxList,
                                 ExTaxList : TList;
                                 SchoolCodeTable,
                                 SwisCodeTable,
                                 CollectionLookupTable,
                                 tb_Header,
                                 BLGeneralTaxTable,
                                 BLSpecialDistrictTaxTable,
                                 BLExemptionTaxTable,
                                 BLSpecialFeeTaxTable,
                                 BillParameterTable,
                                 ParcelTable : TTable;
                                 SDCodeDescList,
                                 EXCodeDescList,
                                 PropertyClassDescList,
                                 GeneralRateList,
                                 SDRateList,
                                 SpecialFeeRateList : TList;
                                 ArrearsMessage : TStringList;
                                 ThirdPartyNotificationTable : TTable;
                                 CurrentlyPrintingThirdPartyNotices : Boolean;
                             var PageNo,
                                 SDIndex : Integer;
                                 TopSectionStart : Double);

const
  Topmarg = 3;  {blank lines at top of page}
  MaxTaxLinesPerPage = 8;

var
  Index, I, J, RateIndex,LinesPrinted : Integer;
  NAddrArray : NameAddrArray;
  TempEXCode : String;
  UniformPercentValue,
  Temprl, TempReal, STARSavings : Double;
  TempStr : String;
  EXAppliesArray : ExemptionAppliesArrayType;
  TempPtr : SDistTaxPtr;
  TempStr2 : String;
  CL1List,
  CL2List,
  CL3List,
  CL4List,
  CL5List,
  CL6List,
  CL7List : TStringList;
  SchoolCode : String;
  SwisCode : String;
  LastSDCode, TaxableValStr : String;
  SBLRec : SBLRecord;

begin
  {create string list for printing parallel non-related data }
    {across the page; eg Name/addr info in cl1list, ex data }
    {in CL2List}

  CL1List := TStringList.Create;
  CL2List := TStringList.Create;
  CL3List := TStringList.Create;
  CL4List := TStringList.Create;
  CL5List := TStringList.Create;
  CL6List := TStringList.Create;
  CL7List := TStringList.Create;

  with Sender as TBaseReport do
    begin
      Bold := True;
      ClearTabs;
      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}
    end;  {with Sender as TBaseReport do}

  with Sender as TBaseReport, tb_Header do
    begin
       {print the bill on the form}
        {>>> TAX MAP}

        {CHG03101999-2: Make the bill printing into a seperate DLL.}
        {Need to pass in formatted parcel ID since DLL will not have access to segment layouts.}
      {Print Swis Code}
      ClearTabs;
      gotoxy(0.1, TopSectionStart);  {Position to correct spoton page}
      Println('');
      Println('');
      SetTab(3.5,pjleft,2.0,0,BoxLineNone, 0);

      {Next tax map number without swiscode}
      Println(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));

        {If this is after the 1st page, don't print loc, dim, prop class, rs, or warrant.
         Instead, print page # }

      If (PageNo = 1)
        then
          begin
              {>>> PROP LOCATION      }

            Println(#9 + GetLegalAddressFromTable(tb_Header));

                {>>> DIMENSIONS      }
                {FXX05282004-1(2.07l5): The frontage was printing in the depth field.}

            If ((FieldByName('HstdAcreage').AsFloat > 0.0) or
                (FieldByName('NonHstdAcreage').AsFloat > 0.0))
              then Println(#9 + 'ACRES: ' +
                                FormatFloat(DecimalDisplay, (FieldByName('HstdAcreage').AsFloat) +
                                                            (FieldByName('NonHstdAcreage').AsFloat)))
              else Println(#9 + 'FRONTAGE: ' +
                                FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) +
                                ', DEPTH: ' +
                                FormatFloat(DecimalDisplay, FieldByName('Depth').AsFloat)) ;

                {>>> PROPERTY CLASS }

            Println(#9 + FieldByName('PropertyClassCode').Text + ' - ' +
                  UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                              PropertyClassDescList)));

                {>>> ROLL SECTION }

            Println(#9 + FieldByName('RollSection').Text);

                {>>> WARRANT DATE  }

            Println(#9 + BillParameterTable.FieldByName('WarrantDate').AsString);
          end  {PageNo = 1}
        else
          begin  {This leg should never execute for Wesley}
            ClearTabs;
            SetTab(7.0, pjLeft, 1.0, 0, BOXLINENone, 0);   {Page #}
            Println('');
            Println('');
            Println('');
            Println(#9 + 'Page: ' + IntToStr(PageNo));
            Println('');

          end;  {else of If (PageNo > 1)}

          {>>> SPACE }
      Println('');

         {If this is the first page, print the name and address. Otherwise,
          print continued.}

      If (PageNo = 1)
        then
          begin
             {CHG01092002-1: 3rd party notices.}

           If CurrentlyPrintingThirdPartyNotices
             then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
             else GetNameAddress(tb_Header, NAddrArray);

                 {fill in clist1 with name addr info}

            For I := 1 to 6 do
              CL1List.Add(NaddrArray[I]);
          end
        else
          begin
            CL1List.Add('*********   CONTINUED   *********');

            For I := 2 to 6 do
              CL1List.Add('');

          end;  {else of If (PageNo = 1)}

       {First line is hdr for exemptions.}

      CL2List.Add('   ');
      CL3List.Add('   ');
      CL4List.Add('   ');

         {Now fill in exemptions}

      For I := 0 to (ExTaxList.Count - 1) do
        begin
          TempExCode := ExemptTaxPtr(ExTaxList[I])^.EXCode;
          EXAppliesArray := EXApplies(TempEXCode, False);

            {Exemption applies to town or town and county.}

          If EXAppliesArray[EXTown]
            then
              begin
               CL2List.Add(Take(10, ExemptTaxPtr(ExTaxList[I])^.Description));
               CL3List.Add(ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL4List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.TownAmount));

             end;  {If EXAppliesArray[EXSchool]}

            {If county only, print the county amount.}

          If (EXAppliesArray[EXCounty] and
              (not EXAppliesArray[EXTown]))
            then
              begin
               CL2List.Add(Take(10, ExemptTaxPtr(ExTaxList[I])^.Description));
               CL3List.Add(ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL4List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.CountyAmount));

             end;  {If EXAppliesArray[EXCounty]}

        end;  {For I := 0 to (ExTaxList.Count - 1) do}

          {pad out rest of exemption columns to 6 lines to match Naddr clist}

      For I := (ExTaxList.Count) to 6 do
        begin
          CL2List.Add('   ');
          CL3List.Add('   ');
          CL4List.Add('   ');
        end;

         {>>> NAME/ADDR AND EXEMPTIONS >>>}

      ClearTabs;
      SetTab(1.3, pjLeft, 3.2, 0, BOXLINENone, 0);   {nAME/ADDR}
      SetTab(5.2, pjLeft, 1.0, 0, BOXLINENone, 0);   {EX DESCR}
      SetTab(6.3, pjLeft, 0.5, 0, BOXLINENone, 0);   {EX CODE}
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {eX amt}

      For I := 0 to 5 do
        Println(#9 + CL1List[I] +
                #9 + CL2List[I] +
                #9 + CL3List[I] +
                #9 + CL4List[I]);

       {>>> 3 SPACES }

      For I := 1 to 2 do
        Println('  ');

      ClearTabs;
      SetTab(1.0, pjRight,1.5, 0, BoxLineNone, 0);

        {>>> TAX YR, BillNo  }

      ClearTabs;
      SetTab(1.0, pjRight, 1.5, 0, BOXLINENone, 0);   {tax year}
      SetTab(4.0, pjLeft, 1.5, 0, BOXLINENone, 0);   {Bill No}
      {Print Tax Year and Fiscal Year}
      Println(#9 + BillParameterTable.FieldByname('TaxYear').Text +
              #9 + DezeroOnLeft(FieldByName('BillNo').Text));

        {Next is bank code and bill number}
      ClearTabs;
      SetTab(1.0, pjRight, 1.5, 0, BOXLINENone, 0);   {tax year}
      SetTab(3.0, pjLeft, 2.0, 0, BOXLINENone, 0);   {Bill No}
      RateIndex := FindGeneralRate(-1, 'VI', FieldByName('SwisCode').Text, GeneralRateList);
      Println(#9 + FieldByName('BankCode').Text +
              #9 + 'ESTIMATED STATE AID:  ' +
                   FormatFloat(CurrencyNormalDisplay,
                               GeneralRatePointer(GeneralRateList[RateIndex])^.EstimatedStateAid));

         {>>> ASSESSMENT ROLL DATE }
         {FXX03181999-3: Had hardcoded town outside - need to
                         send in actual swis code.}
      ClearTabs;
      SetTab(1.0, pjRight, 1.5, 0, BOXLINENone, 0);   {tax year}
      SetTab(4.0, pjLeft, 1.5, 0, BOXLINENone, 0);   {Bill No}

      Println(#9 + BillParameterTable.FieldByName('AssessmentRollDate').Text);

      Println(#9 + BillParameterTable.FieldByName('FiscalYear').Text +
              #9 + FieldByName('SchoolDistCode').Text);

        {>>> 3 SPACES }

      For I := 1 to 5 do
        Println('');

      {>>> PRINT TAX LINE }
      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BOXLINENone, 0);   {purpose}
      SetTab(2.5, pjRight, 1.0, 0, BOXLINENone, 0);   {total levy}
      SetTab(3.8, pjRight, 0.5, 0, BOXLINENone, 0);   {% inc /dcr}
      SetTab(4.2, pjRight, 1.2, 0, BOXLINENone, 0);   {tax val}
      SetTab(5.5, pjRight, 0.2, 0, BOXLINENone, 0);   {extension}
      SetTab(5.8, pjRight, 1.0, 0, BOXLINENone, 0);   {tax rate}
      SetTab(6.9, pjRight, 1.0, 0, BOXLINENone, 0);   {tax amt}

      LinesPrinted := 0;

      If (PageNo = 1)
        then
          For I := 0 to (GnTaxList.Count - 1) do
            with GeneralTaxPtr(GnTaxList[I])^ do
              begin
                SwisCode := FieldByName('SwisCode').Text;

                  {Only search on the first 4 digits of swis code.}

                If (GeneralTaxType = 'CO')
                  then SwisCode := Take(4, SwisCode);

                RateIndex := FindGeneralRate(GeneralTaxPtr(GnTaxList[I])^.PrintOrder,
                                             GeneralTaxType, SwisCode, GeneralRateList);

                with GeneralRatePointer(GeneralRateList[RateIndex])^ do
                  begin
                    Println(#9 + (*Take(20, Description)*) Take(20,' ') + {In Wesley, the description is already on the
                                                                           Bill form}
                            #9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy) +
                            #9 + FormatFloat(DecimalDisplay,
                                             ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                         PriorTaxLevy)) +
                            #9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal) +
                            #9 +
                            #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                            #9 + FormatFloat(DecimalDisplay, TaxAmount));

                  end;  {with GeneralRatePointer(GeneralRateList[RateIndex])^ do}

              LinesPrinted := LinesPrinted + 1;

            end;  {with GeneralTaxPtr(GnTaxList[I])^ do}

        {Print the SDs. - -  There are no SD's for Wesley}

      LastSDCode := '';

      while ((SDIndex <= (SDTaxList.Count - 1)) and
             (LinesPrinted < MaxTaxLinesPerPage)) do
        with SDistTaxPtr(SDTaxList[SDIndex])^ do
          begin
            FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, Index);

            TaxRate := SDRatePointer(SDRateList[Index])^.HomesteadRate;

            If (Roundoff(TaxRate, 6) > 0.000000)
              then
                begin
                  Print(#9 + Take(20, Description));

                    {Only print levy amts for 1st extension of code.}

                  with SDRatePointer(SDRateList[Index])^ do
                    If (LastSDCode <> SDistTaxPtr(SDTaxList[SDIndex])^.SDistCode)
                      then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy) +
                                 #9 + FormatFloat(DecimalDisplay,
                                                  ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                              PriorTaxLevy)))
                      else Print(#9 + #9);


                  If (SDistTaxPtr(SDTaxList[SDIndex])^.ExtCode = 'TO')
                    then TaxableValStr := FormatFloat(CurrencyDisplayNoDollarSign, SdValue)
                    else TaxableValStr := FormatFloat(DecimalDisplay, SdValue);

                  Println(#9 + TaxableValStr +
                          #9 + SDistTaxPtr(SDTaxList[SDIndex])^.ExtCode +
                          #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                          #9 + FormatFloat(DecimalDisplay, SDAmount));

                  LastSDCode := SDistTaxPtr(SDTaxList[SDIndex])^.SDistCode;

                  LinesPrinted := LinesPrinted + 1;

                end;  {If (Roundoff(TaxRate, 0) > 0)}

            SDIndex := SDIndex + 1;

          end;  { with SDistTaxPtr(SDTaxList[I])^ do}

        {For this year only - print new SBL.}

      SBLRec := ExtractSwisSBLFromSwisSBLKey(FieldByName('SwisCode').Text +
                                             FieldByName('SBLKey').Text);

      with SBLRec do
        FindKeyOld(ParcelTable,
                   ['TaxRollYr', 'SwisCode', 'Section', 'Subsection',
                    'Block', 'Lot', 'Sublot', 'Suffix'],
                   [GlblThisYear, SwisCode, Section, Subsection, Block,
                             Lot, Sublot, Suffix]);
      ClearTabs;
      SetTab(1.2, pjLeft, 2.0, 0, BOXLINENone, 0);   {purpose}
(*      Println(#9 + ConvertSwisSBLToNewDashDot(ParcelTable.FieldByName('RemapOldSBL').Text));*)
      Println('');
      Println('');

        {Now finish spacing through the tax section.}

      For I := (LinesPrinted + 1) to MaxTaxLinesPerPage do
        Println('');

        {Now print the property valuation section.}

     FindKeyOld(SwisCodeTable, ['SwisCode'],
                [FieldByName('SwisCode').Text]);

     UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
     TempReal := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                   FieldByName('NonHstdTotalVal').AsFloat),
                                  SwisCodeTable,
                                  tb_Header.FieldByName('PropertyClassCode').Text,
                                  ' ', True);

     ClearTabs;
     SetTab(0.3, pjLeft, 4.0, 0, BOXLINENone, 0);   {Full mkt Val}
     SetTab(6.8, pjLeft, 1.1, 0, BOXLINENone, 0);   { 1H TAX}
     Println(#9 + #9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment1').AsFloat));
     Println(#9 + 'Full Market Value - ' +
                  BillParameterTable.FieldByName('FullMktValueDate').Text + ':   ' +
                  FormatFloat(CurrencyNormalDisplay, TempReal));

         {>>> ASSESSED VALUE }

     Println(#9 + 'Assessed Value - ' +
              BillParameterTable.FieldByName('AssessmentRollDate').Text + ':  ' +
              FormatFloat(CurrencyNormalDisplay, (FieldByName('HstdTotalVal').AsFloat +
                                             FieldByName('NonHstdTotalVal').AsFloat)));

         {>>> UNIF % VALUE  & 1H/2h AMOUNTS}

      Println(#9 + 'Uniform Pct. of Value for Assessments: ' +
                   FormatFloat(DecimalDisplay, UniformPercentValue));
      Println(#9 + #9 + CollectionLookupTable.FieldByName('PayDate1').Text);

      Println('');
      Println('');

          {>>> TAX DUE DATES }

       {Only print the stub if this is page 1.}

      If (PageNo = 1)
        then
          begin
              {>>> 2 SPACES }

            For I := 1 to 5 do
               Println('');

           {Tax map #}

            ClearTabs;
            SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   { 2h stub sbl}
            Println(#9 + FormattedSwisSBLKey);

              {>>> 2 SPACES }

            For I := 1 to 2 do
              Println('');

               {>>> PROP LOCATION}

            ClearTabs;
            SetTab(1.2, pjLeft, 3.0, 0, BOXLINENone, 0);   {PROP LOC}
            SetTab(4.4, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
            SetTab(6.7, pjLeft, 1.0, 0, BOXLINENone, 0);   {BANK CODE}
            Println(#9 + GetLegalAddressFromTable(tb_Header) +
                    #9 + tb_Header.FieldByName('BankCode').Text +
                    #9 + DezeroOnLeft(tb_Header.FieldByName('BillNo').Text));

              {>>>  1 SPACE}
            Println('');
            Println('');

                {>>> AMOUNT DUE - First stub as amount due 2H}

            ClearTabs;
            SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {BILL NO}
            Println(#9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment1').AsFloat));

              {>>> 2 SPACES }

            For I := 1 to 2 do
              Println('');

               {>>> NAME LINE 1}

            ClearTabs;
            SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {Due Date}
            SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {date/addr}

            Println(#9 + CollectionLookupTable.FieldByName('PayDate1').Text +
                    #9 + NAddrArray[1]);

            ClearTabs;
            SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {date/addr}

            For I := 2 to 6 do
              Println(#9 + NAddrArray[I]);

          end;  {If (PageNo = 1)}

      Newpage;

    end;  {with Sender as TBaseReport do}

  CL1List.Free;
  CL2List.Free;
  CL3List.Free;
  CL4List.Free;
  CL5List.Free;
  CL6List.Free;
  CL7List.Free;

  PageNo := PageNo + 1;

end;  {PrintOneWesleyPage}

{======================================================================}
Function PrintOneWesleyBill(Sender : TObject;
                              ReportPrinter : TReportPrinter;
                              ReportFiler : TReportFiler;
                              ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                              SwisSBLKey : String;
                              FormattedSwisSBLKey : String;
                              SchoolCodeTable,
                              SwisCodeTable,
                              CollectionLookupTable,
                              tb_Header,
                              BLGeneralTaxTable,
                              BLSpecialDistrictTaxTable,
                              BLExemptionTaxTable,
                              BLSpecialFeeTaxTable,
                              BillParameterTable,
                              ParcelTable : TTable;
                              SDCodeDescList,
                              EXCodeDescList,
                              PropertyClassDescList,
                              GeneralRateList,
                              SDRateList,
                              SpecialFeeRateList : TList;
                              ArrearsMessage : TStringList;
                              ThirdPartyNotificationTable : TTable;
                              CurrentlyPrintingThirdPartyNotices : Boolean;
                              TopSectionStart : Double) : Boolean;

var
  Quit : Boolean;
  PageNo, SDIndex : Integer;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  BaseReportObject : TBaseReport;

begin
  Quit := False;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

  If (ReportObjectToUse = 'P')
    then BaseReportObject := ReportPrinter
    else BaseReportObject := ReportFiler;

  with BaseReportObject do
    begin

         {Load the tax data  for this parcel}

      LoadTaxesForParcel(SwisSBLKey,
                         BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         SDCodeDescList, EXCodeDescList,
                         GeneralRateList, SDRateList,
                         SpecialFeeRateList, GnTaxList,
                         SDTaxList, SpTaxList, ExTaxList, Quit);

      PageNo := 1;
      SDIndex := 0;

      repeat
        PrintOneWesleyPage(Sender, BaseReportObject, SwisSBLKey, FormattedSwisSBLKey,
                             GnTaxList, SDTaxList, SpTaxList, ExTaxList,
                             SchoolCodeTable, SwisCodeTable,
                             CollectionLookupTable,
                             tb_Header,
                             BLGeneralTaxTable,
                             BLSpecialDistrictTaxTable,
                             BLExemptionTaxTable,
                             BLSpecialFeeTaxTable,
                             BillParameterTable,
                             ParcelTable,
                             SDCodeDescList,
                             EXCodeDescList,
                             PropertyClassDescList,
                             GeneralRateList,
                             SDRateList,
                             SpecialFeeRateList,
                             ArrearsMessage,
                             ThirdPartyNotificationTable,
                             CurrentlyPrintingThirdPartyNotices,
                             PageNo, SDIndex, TopSectionStart);

      until (SDIndex >= (SDTaxList.Count - 1))

    end;  {with BaseReportObject do}

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

  Result := Quit;

end;  {PrintOneWesleyBill}


{======================================================================}
Procedure PrintOneSomersTownPage(    Sender : TObject;
                                     BaseReportObject : TBaseReport;
                                     SwisSBLKey : String;
                                     FormattedSwisSBLKey : String;
                                     GnTaxList,
                                     SDTaxList,
                                     SpTaxList,
                                     ExTaxList : TList;
                                     SchoolCodeTable,
                                     SwisCodeTable,
                                     CollectionLookupTable,
                                     tb_Header,
                                     BLGeneralTaxTable,
                                     BLSpecialDistrictTaxTable,
                                     BLExemptionTaxTable,
                                     BLSpecialFeeTaxTable,
                                     BillParameterTable,
                                     ParcelTable : TTable;
                                     SDCodeDescList,
                                     EXCodeDescList,
                                     PropertyClassDescList,
                                     GeneralRateList,
                                     SDRateList,
                                     SpecialFeeRateList : TList;
                                     ArrearsMessage : TStringList;
                                     ThirdPartyNotificationTable : TTable;
                                     CurrentlyPrintingThirdPartyNotices : Boolean;
                                     TopSectionStart,
                                     BaseDetailsStart,
                                     BottomSectionStart : Double;
                                 var PageNo,
                                     SDIndex : Integer);

const
  Topmarg = 3;  {blank lines at top of page}
  MaxTaxLinesPerPage = 20;

var
  Index, I, J, RateIndex,LinesPrinted : Integer;
  NAddrArray : NameAddrArray;
  TempEXCode : String;
  UniformPercentValue,
  Temprl, TempReal, STARSavings : Double;
  TempStr : String;
  EXAppliesArray : ExemptionAppliesArrayType;
  TempPtr : SDistTaxPtr;
  TempStr2 : String;
  CL1List,
  CL2List,
  CL3List,
  CL4List,
  CL5List,
  CL6List,
  CL7List : TStringList;
  SchoolCode : String;
  SwisCode : String;
  LastSDCode, TaxableValStr : String;
  SBLRec : SBLRecord;

begin
  {create string list for printing parallel non-related data }
    {across the page; eg Name/addr info in cl1list, ex data }
    {in CL2List}

  CL1List := TStringList.Create;
  CL2List := TStringList.Create;
  CL3List := TStringList.Create;
  CL4List := TStringList.Create;
  CL5List := TStringList.Create;
  CL6List := TStringList.Create;
  CL7List := TStringList.Create;

  with Sender as TBaseReport do
    begin
      Bold := True;

    end;  {with Sender as TBaseReport do}

  with Sender as TBaseReport, tb_Header do
    begin
       {print the bill on the form}
        {>>> TAX MAP}

        {CHG03101999-2: Make the bill printing into a seperate DLL.}
        {Need to pass in formatted parcel ID since DLL will not have access to segment layouts.}
      {Print Swis Code}
      ClearTabs;
      gotoxy(0.1,TopSectionStart);  {Position to correct spoton page}

      ClearTabs;
      SetTab(3.6, pjLeft, 1.0, 0, BOXLINENone, 0);
      SetTab(4.8, pjLeft, 2.0, 0, BOXLINENone, 0);
      SetTab(7.3, pjLeft, 0.8, 0, BOXLINENone, 0);

      Print(#9 + BillParameterTable.FieldByname('TaxYear').Text);
      Print(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));
      Println(#9 + DezeroOnLeft(FieldByName('BillNo').Text));


      ClearTabs;
      SetTab(4.2, pjLeft, 2.5, 0, BOXLINENone, 0);
      SetTab(7.65, pjLeft, 1.0, 0, BOXLINENone, 0);

      Print(#9 + GetLegalAddressFromTable(tb_Header));
      Println( #9 + FieldByName('BankCode').Text);


      If ((FieldByName('HstdAcreage').AsFloat > 0.0) or
                (FieldByName('NonHstdAcreage').AsFloat > 0.0))
        then Print(#9 +  'Acres: ' + FormatFloat(DecimalDisplay, (FieldByName('HstdAcreage').AsFloat) +
                        (FieldByName('NonHstdAcreage').AsFloat)))
        else Print(#9 + 'FRONTAGE: ' +
                        FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) +
                        ', DEPTH: ' +
                        FormatFloat(DecimalDisplay, FieldByName('Depth').AsFloat));

      Println (#9 + FieldByName('RollSection').Text);

      ClearTabs;
      SetTab(4.2, pjLeft, 2.0, 0, BOXLINENone, 0);
      SetTab(7.1, pjLeft, 1.1, 0, BOXLINENone, 0);

      Print(#9 + FieldByName('PropertyClassCode').Text + ' - ' +
                 UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                  PropertyClassDescList)));
      Println(#9 + BillParameterTable.FieldByName('WarrantDate').AsString);
      ClearTabs;
      SetTab(6.2, pjleft, 2.0, 0, BOXLINENone, 0);

      Println(#9 + BillParameterTable.FieldByName('FiscalYear').Text);
      Println('');

       {CHG01092002-1: 3rd party notices.}

      If CurrentlyPrintingThirdPartyNotices
        then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
        else GetNameAddress(tb_Header, NAddrArray);

                 {fill in clist1 with space and name addr info}
      CL1List.Add('  ');
      For I := 1 to 6 do
       begin
         CL1List.Add(NaddrArray[I]);
       end;


         {Now fill in exemptions}

      For I := 0 to (ExTaxList.Count - 1) do
        begin
          TempExCode := ExemptTaxPtr(ExTaxList[I])^.EXCode;
          EXAppliesArray := EXApplies(TempEXCode, False);

            {Exemption applies to town or town and county.}

          If EXAppliesArray[EXTown]
            then
              begin
               CL2List.Add(Take(18, ExemptTaxPtr(ExTaxList[I])^.Description)+ ' ' +
                           ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL3List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.TownAmount));
               Case ExemptTaxPtr(ExTaxList[I])^.ExCode[5] of
                '0','1': CL5List.Add('County, Town');
                '2','5':  CL5List.Add('County');
                '3','6':  CL5List.Add('Town');
               end;
              end;  {If EXAppliesArray[EXSchool]}

            {If county only, print the county amount.}

          If (EXAppliesArray[EXCounty] and
              (not EXAppliesArray[EXTown]))
            then
              begin
               CL2List.Add(Take(20, ExemptTaxPtr(ExTaxList[I])^.Description)+ ' ' +
               ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL3List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.CountyAmount));
               Case ExemptTaxPtr(ExTaxList[I])^.ExCode[5] of
                '0','1': CL5List.Add('County, Town');
                '2','5':  CL5List.Add('County');
                '3','6':  CL5List.Add('Town');
               end;
              end;  {If EXAppliesArray[EXCounty]}

          CL4List.Add(FormatFloat(CurrencyDisplayNoDollarSign, ExemptTaxPtr(ExTaxList[I])^.FullValue));

        end;  {For I := 0 to (ExTaxList.Count - 1) do}

          {pad out rest of exemption columns to 6 lines to match Naddr clist}

      For I := (ExTaxList.Count) to 7 do
        begin
          CL2List.Add('');
          CL3List.Add('');
          CL4List.Add('');
          CL5List.Add('');

        end;  {For I := (ExTaxList.Count) to 7 do}

         {>>> NAME/ADDR AND EXEMPTIONS >>>}

      ClearTabs;
      SetTab(0.9, pjleft, 2.5, 0, BOXLINENone, 0);
      SetTab(3.5, pjLeft, 1.7, 0, BOXLINENone, 0);
      SetTab(5.1, pjRight, 1.0, 0, BOXLINENone, 0);
      SetTab(6.1, pjRight, 1.0, 0, BoxLineNone, 0);
      SetTab(7.25, pjLeft, 1.2, 0, BOXLINENone, 0);

      For I := 0 to 5 do
        Println(#9 + CL1List[I] +
                #9 + CL2List[I] +
                #9 + CL3List[I] +
                #9 + CL4List[I] +
                #9 + CL5List[I]);


      ClearTabs;
      SetTab(0.9, pjleft, 2.2, 0, BOXLINENone, 0);
      SetTab(4.1, pjLeft, 1.0, 0, BOXLINENone, 0);
      SetTab(5.2, pjLeft, 1.0, 0, BOXLINENone, 0);
      SetTab(7.2, pjLeft, 1.0, 0, BOXLINENone, 0);

    UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
    TempReal := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                   FieldByName('NonHstdTotalVal').AsFloat),
                                  SwisCodeTable,
                                  tb_Header.FieldByName('PropertyClassCode').Text,
                                  ' ', True);
        {Market Value}
     Print(#9 + CL1List[6] +
           #9 + BillParameterTable.FieldByName('FullMktValueDate').AsString);
     Print(#9 + FormatFloat(CurrencyNormalDisplay, TempReal));
         {>>> ASSESSED VALUE }
     Println(#9 + FormatFloat(CurrencyDisplayNoDollarSign, (FieldByName('HstdTotalVal').AsFloat +
                                             FieldByName('NonHstdTotalVal').AsFloat)));
     {Header line}
     Println('');
     GotoXY(1, BaseDetailsStart);

      {>>> PRINT TAX LINE }
     ClearTabs;
     SetTab(0.4, pjLeft, 2.0, 0, BOXLINENone, 0);   {purpose}
     SetTab(2.5, pjRight, 1.0, 0, BOXLINENone, 0);   {total levy}
     SetTab(3.7, pjRight, 0.5, 0, BOXLINENone, 0);   {% inc /dcr}
     SetTab(4.4, pjRight, 1.0, 0, BOXLINENone, 0);   {tax val}
{    SetTab(5.5, pjRight, 0.2, 0, BOXLINENone, 0);   {extension}
     SetTab(5.5, pjRight, 1.0, 0, BOXLINENone, 0);   {tax rate}
     SetTab(7.1, pjRight, 1.0, 0, BOXLINENone, 0);   {tax amt}

     LinesPrinted := 0;

     For I := 0 to (GnTaxList.Count - 1) do
        with GeneralTaxPtr(GnTaxList[I])^ do
          begin
            SwisCode := FieldByName('SwisCode').Text;

                  {Only search on the first 4 digits of swis code.}
              If (GeneralTaxType = 'CO')
                then SwisCode := Take(4, SwisCode);

            RateIndex := FindGeneralRate(GeneralTaxPtr(GnTaxList[I])^.PrintOrder,
                                             GeneralTaxType, SwisCode, GeneralRateList);

            with GeneralRatePointer(GeneralRateList[RateIndex])^ do
               begin
                 Print(#9 + (Take(20, Description)));
                 Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy));
                 Print(#9 + FormatFloat(DecimalDisplay,
                                             ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                         PriorTaxLevy)));
                 Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal));
                 Print(#9 + FormatFloat(ExtendedDecimalDisplay, TaxRate));
                 Println(#9 + FormatFloat(CurrencyDecimalDisplay, TaxAmount));

                 end;  {with GeneralRatePointer(GeneralRateList[RateIndex])^ do}

            LinesPrinted := LinesPrinted + 1;

          end;  {with GeneralTaxPtr(GnTaxList[I])^ do}

        {Print the SDs}

      LastSDCode := '';

      while ((SDIndex <= (SDTaxList.Count - 1)) and
             (LinesPrinted < MaxTaxLinesPerPage)) do
        with SDistTaxPtr(SDTaxList[SDIndex])^ do
          begin
            FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, Index);

            TaxRate := SDRatePointer(SDRateList[Index])^.HomesteadRate;

            If (Roundoff(TaxRate, 6) > 0.000000)
              then
                begin
                  Print(#9 + Take(20, Description));

                    {Only print levy amts for 1st extension of code.}

                  with SDRatePointer(SDRateList[Index])^ do
                    If (LastSDCode <> SDistTaxPtr(SDTaxList[SDIndex])^.SDistCode)
                      then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy) +
                                 #9 + FormatFloat(DecimalDisplay,
                                                  ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                              PriorTaxLevy)))
                      else Print(#9 + #9);


                  If (SDistTaxPtr(SDTaxList[SDIndex])^.ExtCode = 'TO')
                    then TaxableValStr := FormatFloat(CurrencyDisplayNoDollarSign, SdValue)
                    else TaxableValStr := FormatFloat(DecimalDisplay, SdValue);

                  Println(#9 + TaxableValStr +
                          #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                          #9 + FormatFloat(CurrencyDecimalDisplay, SDAmount));

                  LastSDCode := SDistTaxPtr(SDTaxList[SDIndex])^.SDistCode;

                  LinesPrinted := LinesPrinted + 1;

                end;  {If (Roundoff(TaxRate, 0) > 0)}

            SDIndex := SDIndex + 1;

          end;  { with SDistTaxPtr(SDTaxList[I])^ do}

        {FXX03222003-1(2.06q1): Print arrears message on bill.}
        {Do we need to print an arrears message at the end?}

      If FieldByName('ArrearsFlag').AsBoolean
        then
          begin
            Println('');
            LinesPrinted := LinesPrinted + 1;

            For I := 0 to (ArrearsMessage.Count - 1) do
              begin
                Println(#9 + ArrearsMessage[I]);
                LinesPrinted := LinesPrinted + 1;
              end;

          end;  {If FieldByName('ArrearsFlag').AsBoolean}

         {Now finish spacing through the tax section.}

      For I := (LinesPrinted + 1) to (MaxTaxLinesPerPage - 4) do
        Println('');

      Println('');
      Println('');
        
        {CHG03202009-1(2.17.1.10): Bill Change}
        {CHG03222011-1(2.26.1.47): Remove Bill change.}

      (*Println('');
      Println(#9 + 'THE APPLICATION DEADLINE FOR ANY EXEMPTION ON YOUR PROPERTY TAXES HAS BEEN CHANGED');
      Println(#9 + 'TO MAY 1ST.  IF YOU HAVE ANY QUESTIONS PLEASE CALL THE ASSESSOR' + '''' + 'S OFFICE 914-277-3504.');
      Println(''); *)
      gotoxy(0.1,BottomSectionStart);  {Position to correct spoton page}


      For I := 1 to 4 do
        Println('');

      Println('');
      Println('');
      Println('');

      ClearTabs;
      SetTab(4.7, pjleft, 0.5, 0, BOXLINENone, 0);   {uniform perc}
      SetTab(7.1, pjRight, 1.0, 0, BOXLINENone, 0);   {tax amt}

      Print(#9 + FormatFloat(DecimalDisplay, UniformPercentValue));
      Println(#9 + FormatFloat(CurrencyDecimalDisplay, FieldByName('TaxPayment1').AsFloat));
      Println(#9 + #9 + CollectionLookupTable.FieldByName('PayDate1').Text);

      Println ('');
      Println ('');
      Println ('');

      ClearTabs;
      SetTab(1.1, pjLeft, 3.0, 0, BOXLINENone, 0);  {Stub Tab}
      SetTab(7.1, pjRight, 1.0, 0, BOXLINENone, 0);   {Full Payment}

      Println(#9 + DezeroOnLeft(tb_Header.FieldByName('BillNo').Text));
      Println('');
      Println(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));
      Print(#9 + GetLegalAddressFromTable(tb_Header));
      Println(#9 +FormatFloat(CurrencyDecimalDisplay, FieldByName('TaxPayment1').AsFloat));
            If ((FieldByName('HstdAcreage').AsFloat > 0.0) or
                (FieldByName('NonHstdAcreage').AsFloat > 0.0))
        then Println(#9 +  'Acres: ' + FormatFloat(DecimalDisplay, (FieldByName('HstdAcreage').AsFloat) +
                        (FieldByName('NonHstdAcreage').AsFloat)))
        else Println(#9 + 'FRONTAGE: ' +
                        FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) +
                        ', DEPTH: ' +
                        FormatFloat(DecimalDisplay, FieldByName('Depth').AsFloat));

      Println(#9 + FieldByName('PropertyClassCode').Text + ' - ' +
                   UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                    PropertyClassDescList)));
      Println(#9 + tb_Header.FieldByName('BankCode').Text);
      Println('');
      Println('');
       {CHG01092002-1: 3rd party notices.}

      If CurrentlyPrintingThirdPartyNotices
        then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
        else GetNameAddress(tb_Header, NAddrArray);

      For I := 1 to 6 do
        begin
          Print(#9 + CL1List[I]);

          If (I = 5)
            then Println(#9 + CollectionLookupTable.FieldByName('PayDate1').Text)
            else Println('');

        end;  {For I := 1 to 6 do}


      Newpage;

    end;  {with Sender as TBaseReport do}

  CL1List.Free;
  CL2List.Free;
  CL3List.Free;
  CL4List.Free;
  CL5List.Free;
  CL6List.Free;
  CL7List.Free;

  PageNo := PageNo + 1;
end;  {PrintOneSomersTownPage}

{======================================================================}
Function PrintOneSomersTownBill(Sender : TObject;
                                ReportPrinter : TReportPrinter;
                                ReportFiler : TReportFiler;
                                ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                                SwisSBLKey : String;
                                FormattedSwisSBLKey : String;
                                SchoolCodeTable,
                                SwisCodeTable,
                                CollectionLookupTable,
                                tb_Header,
                                BLGeneralTaxTable,
                                BLSpecialDistrictTaxTable,
                                BLExemptionTaxTable,
                                BLSpecialFeeTaxTable,
                                BillParameterTable,
                                ParcelTable : TTable;
                                SDCodeDescList,
                                EXCodeDescList,
                                PropertyClassDescList,
                                GeneralRateList,
                                SDRateList,
                                SpecialFeeRateList : TList;
                                ArrearsMessage : TStringList;
                                ThirdPartyNotificationTable : TTable;
                                CurrentlyPrintingThirdPartyNotices : Boolean;
                                TopSectionStart,
                                BaseDetailsStart,
                                BottomSectionStart : Double) : Boolean;

var
  Quit : Boolean;
  PageNo, SDIndex : Integer;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  BaseReportObject : TBaseReport;

begin
  Quit := False;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

  If (ReportObjectToUse = 'P')
    then BaseReportObject := ReportPrinter
    else BaseReportObject := ReportFiler;

  with BaseReportObject do
    begin

         {Load the tax data  for this parcel}

      LoadTaxesForParcel(SwisSBLKey,
                         BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         SDCodeDescList, EXCodeDescList,
                         GeneralRateList, SDRateList,
                         SpecialFeeRateList, GnTaxList,
                         SDTaxList, SpTaxList, ExTaxList, Quit);

      PageNo := 1;
      SDIndex := 0;

      repeat
        PrintOneSomersTownPage(Sender, BaseReportObject, SwisSBLKey, FormattedSwisSBLKey,
                               GnTaxList, SDTaxList, SpTaxList, ExTaxList,
                               SchoolCodeTable, SwisCodeTable,
                               CollectionLookupTable,
                               tb_Header,
                               BLGeneralTaxTable,
                               BLSpecialDistrictTaxTable,
                               BLExemptionTaxTable,
                               BLSpecialFeeTaxTable,
                               BillParameterTable,
                               ParcelTable,
                               SDCodeDescList,
                               EXCodeDescList,
                               PropertyClassDescList,
                               GeneralRateList,
                               SDRateList,
                               SpecialFeeRateList,
                               ArrearsMessage,
                               ThirdPartyNotificationTable,
                               CurrentlyPrintingThirdPartyNotices,
                               TopSectionStart, BaseDetailsStart,
                               BottomSectionStart,
                               PageNo, SDIndex);

      until (SDIndex >= (SDTaxList.Count - 1))

    end;  {with BaseReportObject do}

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

  Result := Quit;

end;  {PrintOneSomersTownBill}

{======================================================================}
Procedure PrintOneSomersSchoolPage(    Sender : TObject;
                                       BaseReportObject : TBaseReport;
                                       SwisSBLKey : String;
                                       FormattedSwisSBLKey : String;
                                       GnTaxList,
                                       SDTaxList,
                                       SpTaxList,
                                       ExTaxList : TList;
                                       SchoolCodeTable,
                                       SwisCodeTable,
                                       CollectionLookupTable,
                                       tb_Header,
                                       BLGeneralTaxTable,
                                       BLSpecialDistrictTaxTable,
                                       BLExemptionTaxTable,
                                       BLSpecialFeeTaxTable,
                                       BillParameterTable,
                                       ParcelTable : TTable;
                                       SDCodeDescList,
                                       EXCodeDescList,
                                       PropertyClassDescList,
                                       GeneralRateList,
                                       SDRateList,
                                       SpecialFeeRateList : TList;
                                       ArrearsMessage : TStringList;
                                       ThirdPartyNotificationTable : TTable;
                                       CurrentlyPrintingThirdPartyNotices : Boolean;
                                       TopSectionStart,
                                       BaseDetailsStart,
                                       BottomSectionStart : Double;
                                   var PageNo,
                                       SDIndex : Integer);

const
  Topmarg = 3;  {blank lines at top of page}
  MaxTaxLinesPerPage = 20;  {Was 21 needs to end a little sooner}

var
  Index, I, J, RateIndex,LinesPrinted : Integer;
  NAddrArray : NameAddrArray;
  TempEXCode : String;
  UniformPercentValue,
  Temprl, TempReal, STARSavings : Double;
  TempStr : String;
  EXAppliesArray : ExemptionAppliesArrayType;
  TempPtr : SDistTaxPtr;
  TempStr2 : String;
  CL1List,
  CL2List,
  CL3List,
  CL4List,
  CL5List,
  CL6List,
  CL7List : TStringList;
  SchoolCode : String;
  SwisCode : String;
  LastSDCode, TaxableValStr : String;
  SBLRec : SBLRecord;

begin
  {create string list for printing parallel non-related data }
    {across the page; eg Name/addr info in cl1list, ex data }
    {in CL2List}

  CL1List := TStringList.Create;
  CL2List := TStringList.Create;
  CL3List := TStringList.Create;
  CL4List := TStringList.Create;
  CL5List := TStringList.Create;
  CL6List := TStringList.Create;
  CL7List := TStringList.Create;

  with Sender as TBaseReport do
    begin
      Bold := True;

    end;  {with Sender as TBaseReport do}

  with Sender as TBaseReport, tb_Header do
    begin
       {print the bill on the form}
        {>>> TAX MAP}

        {CHG03101999-2: Make the bill printing into a seperate DLL.}
        {Need to pass in formatted parcel ID since DLL will not have access to segment layouts.}
        {FXX08282003-1(2.07i): Soften up the starting position.}

      {Print Swis Code}
      ClearTabs;
      gotoxy(0.1,TopSectionStart);  {Position to correct spoton page}
      Println('');


      ClearTabs;
      SetTab(3.6, pjLeft, 1.0, 0, BOXLINENone, 0);
      SetTab(4.8, pjLeft, 2.0, 0, BOXLINENone, 0);
      SetTab(7.3, pjLeft, 0.8, 0, BOXLINENone, 0);

      Print(#9 + BillParameterTable.FieldByname('TaxYear').Text);
      Print(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));
      Println(#9 + DezeroOnLeft(FieldByName('BillNo').Text));


      ClearTabs;
      SetTab(4.2, pjLeft, 2.5, 0, BOXLINENone, 0);
      SetTab(7.65, pjLeft, 1.0, 0, BOXLINENone, 0);

      Print(#9 + GetLegalAddressFromTable(tb_Header));
      Println( #9 + FieldByName('BankCode').Text);


      If ((FieldByName('HstdAcreage').AsFloat > 0.0) or
                (FieldByName('NonHstdAcreage').AsFloat > 0.0))
        then Print(#9 +  'Acres: ' + FormatFloat(DecimalDisplay, (FieldByName('HstdAcreage').AsFloat) +
                        (FieldByName('NonHstdAcreage').AsFloat)))
        else Print(#9 + 'FRONTAGE: ' +
                        FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) +
                        ', DEPTH: ' +
                        FormatFloat(DecimalDisplay, FieldByName('Depth').AsFloat));

      Println (#9 + FieldByName('RollSection').Text);

      ClearTabs;
      SetTab(4.2, pjLeft, 2.0, 0, BOXLINENone, 0);
      SetTab(7.1, pjLeft, 1.1, 0, BOXLINENone, 0);

      Print(#9 + FieldByName('PropertyClassCode').Text + ' - ' +
                 Take(15, UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                           PropertyClassDescList))));
      Println(#9 + BillParameterTable.FieldByName('WarrantDate').AsString);
      ClearTabs;
      SetTab(6.2, pjleft, 2.0, 0, BOXLINENone, 0);

      Println(#9 + BillParameterTable.FieldByName('FiscalYear').Text);
      Println('');

       {CHG01092002-1: 3rd party notices.}

      If CurrentlyPrintingThirdPartyNotices
        then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
        else GetNameAddress(tb_Header, NAddrArray);

                 {fill in clist1 with space and name addr info}
      CL1List.Add('  ');
      For I := 1 to 6 do
       begin
         CL1List.Add(NaddrArray[I]);
       end;

         {Now fill in exemptions}
         {One blank line.}

      CL2List.Add('');
      CL3List.Add('');
      CL4List.Add('');
      CL5List.Add('');

      For I := 0 to (ExTaxList.Count - 1) do
        begin
          TempExCode := ExemptTaxPtr(ExTaxList[I])^.EXCode;
          EXAppliesArray := EXApplies(TempEXCode, False);

          If EXAppliesArray[EXSchool]
            then
              begin
               CL2List.Add(Take(20, ExemptTaxPtr(ExTaxList[I])^.Description)+ ' ' +
               ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL3List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.SchoolAmount));
               CL5List.Add('SCHOOL');

              end;  {If EXAppliesArray[EXCounty]}

          CL4List.Add(FormatFloat(CurrencyDisplayNoDollarSign, ExemptTaxPtr(ExTaxList[I])^.FullValue));

        end;  {For I := 0 to (ExTaxList.Count - 1) do}

          {pad out rest of exemption columns to 6 lines to match Naddr clist}

      For I := (ExTaxList.Count) to 7 do
        begin
          CL2List.Add('');
          CL3List.Add('');
          CL4List.Add('');
          CL5List.Add('');

        end;  {For I := (ExTaxList.Count) to 7 do}

         {>>> NAME/ADDR AND EXEMPTIONS >>>}

      ClearTabs;
      SetTab(0.9, pjleft, 2.5, 0, BOXLINENone, 0);
      SetTab(3.5, pjLeft, 1.7, 0, BOXLINENone, 0);
      SetTab(5.1, pjRight, 1.0, 0, BOXLINENone, 0);
      SetTab(6.1, pjRight, 1.0, 0, BoxLineNone, 0);
      SetTab(7.25, pjLeft, 1.2, 0, BOXLINENone, 0);

      For I := 0 to 5 do
        Println(#9 + CL1List[I] +
                #9 + CL2List[I] +
                #9 + CL3List[I] +
                #9 + CL4List[I] +
                #9 + CL5List[I]);

(*        end;  {For I := 0 to (ExTaxList.Count - 1) do}

          {pad out rest of exemption columns to 6 lines to match Naddr clist}

      For I := (ExTaxList.Count) to 7 do
        begin
          CL2List.Add('   ');
          CL3List.Add('   ');
          CL4List.Add('   ');
        end;

         {>>> NAME/ADDR AND EXEMPTIONS >>>}

      ClearTabs;
      SetTab(0.9, pjleft, 1.0, 0, BOXLINENone, 0);
      SetTab(3.6, pjleft, 1.7, 0, BOXLINENone, 0);
      SetTab(5.4, pjRight, 1.5, 0, BOXLINENone, 0);
      SetTab(7.1, pjleft, 1.2, 0, BOXLINENone, 0);

      For I := 0 to 5 do
        Println(#9 + CL1List[I] +
                #9 + CL2List[I] +
                #9 + CL3List[I] +
                #9 + CL4List[I]); *)

      ClearTabs;
      SetTab(0.9, pjleft, 2.2, 0, BOXLINENone, 0);
      SetTab(4.1, pjLeft, 1.0, 0, BOXLINENone, 0);
      SetTab(5.2, pjRight, 1.0, 0, BOXLINENone, 0);
      SetTab(7.2, pjLeft, 1.0, 0, BOXLINENone, 0);


    UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
    TempReal := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                   FieldByName('NonHstdTotalVal').AsFloat),
                                  SwisCodeTable,
                                  tb_Header.FieldByName('PropertyClassCode').Text,
                                  ' ', True);
        {Market Value}
       {CHG08232007-1(2.11.3.7): Don't display the uniform % of value and move the
                                 full market value over.}

     Println(#9 + CL1List[6]+
             #9 + BillParameterTable.FieldByName('FullMktValueDate').AsString +
             #9 + FormatFloat(CurrencyNormalDisplay, TempReal) +
             #9 + FormatFloat(CurrencyDisplayNoDollarSign, (FieldByName('HstdTotalVal').AsFloat +
                                             FieldByName('NonHstdTotalVal').AsFloat)));
{End of top section, begin details}
Gotoxy(0.1,BaseDetailsStart);
     {Header line}
     Println('');

      {>>> PRINT TAX LINE }
     ClearTabs;
     SetTab(0.4, pjLeft, 2.0, 0, BOXLINENone, 0);   {purpose}
     SetTab(2.5, pjRight, 1.0, 0, BOXLINENone, 0);   {total levy}
     SetTab(3.8, pjRight, 0.5, 0, BOXLINENone, 0);   {% inc /dcr}
     SetTab(4.5, pjRight, 1.0, 0, BOXLINENone, 0);   {tax val}
     SetTab(5.5, pjRight, 1.0, 0, BOXLINENone, 0);   {tax rate}
     SetTab(7.1, pjRight, 1.0, 0, BOXLINENone, 0);   {tax amt}

     LinesPrinted := 0;

     For I := 0 to (GnTaxList.Count - 1) do
        with GeneralTaxPtr(GnTaxList[I])^ do
          begin
            SwisCode := FieldByName('SwisCode').Text;

                  {Only search on the first 4 digits of swis code.}
              If (GeneralTaxType = 'CO')
                then SwisCode := Take(4, SwisCode);

            RateIndex := FindGeneralRate(GeneralTaxPtr(GnTaxList[I])^.PrintOrder,
                                             GeneralTaxType, SwisCode, GeneralRateList);

            with GeneralRatePointer(GeneralRateList[RateIndex])^ do
               begin
                 Print(#9 + (Take(20, Description)));
                 Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy));
                 Print(#9 + FormatFloat(DecimalDisplay,
                                             ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                         PriorTaxLevy)));
                 Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal));
                 Print(#9 + FormatFloat(ExtendedDecimalDisplay, TaxRate));
                 Println(#9 + FormatFloat(CurrencyDecimalDisplay, TaxAmount));

                 end;  {with GeneralRatePointer(GeneralRateList[RateIndex])^ do}

            LinesPrinted := LinesPrinted + 1;

          end;  {with GeneralTaxPtr(GnTaxList[I])^ do}

        {Print the SDs}

      LastSDCode := '';

      while ((SDIndex <= (SDTaxList.Count - 1)) and
             (LinesPrinted < MaxTaxLinesPerPage)) do
        with SDistTaxPtr(SDTaxList[SDIndex])^ do
          begin
            FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, Index);

            TaxRate := SDRatePointer(SDRateList[Index])^.HomesteadRate;

            If (Roundoff(TaxRate, 6) > 0.000000)
              then
                begin
                  Print(#9 + Take(20, Description));

                    {Only print levy amts for 1st extension of code.}

                  with SDRatePointer(SDRateList[Index])^ do
                    If (LastSDCode <> SDistTaxPtr(SDTaxList[SDIndex])^.SDistCode)
                      then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy) +
                                 #9 + FormatFloat(DecimalDisplay,
                                                  ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                              PriorTaxLevy)))
                      else Print(#9 + #9);


                  If (SDistTaxPtr(SDTaxList[SDIndex])^.ExtCode = 'TO')
                    then TaxableValStr := FormatFloat(CurrencyDisplayNoDollarSign, SdValue)
                    else TaxableValStr := FormatFloat(DecimalDisplay, SdValue);

                  Println(#9 + TaxableValStr +
                          #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                          #9 + FormatFloat(CurrencyDecimalDisplay, SDAmount));

                  LastSDCode := SDistTaxPtr(SDTaxList[SDIndex])^.SDistCode;

                  LinesPrinted := LinesPrinted + 1;

                end;  {If (Roundoff(TaxRate, 0) > 0)}

            SDIndex := SDIndex + 1;

          end;  { with SDistTaxPtr(SDTaxList[I])^ do}

        {CHG03161999-1: Print arrears message on bill.}
        {Do we need to print an arrears message at the end?}

      If FieldByName('ArrearsFlag').AsBoolean
        then
          begin
            Println('');
            LinesPrinted := LinesPrinted + 1;

            For I := 0 to (ArrearsMessage.Count - 1) do
              begin
                Println(#9 + ArrearsMessage[I]);
                LinesPrinted := LinesPrinted + 1;
              end;

          end;  {If FieldByName('ArrearsFlag').AsBoolean}

         {Now finish spacing through the tax section.}

      For I := (LinesPrinted + 1) to MaxTaxLinesPerPage do
        begin
          try
            If (I = 5) or (I = 6) then
            Begin
            If ((I = 5) and {Moved from Line 17 to line 5 and bolded}
                (Roundoff(GeneralTaxPtr(GnTaxList[0])^.STARSavings, 2) > 0))
              then
              Begin
              Bold := True;
              Print(#9 + '  LESS STAR TAX SAVINGS');
              {Move $$ Amt to right most column.}
              Print(#9 + #9 + #9 + #9 + #9 + FormatFloat(CurrencyDecimalDisplay,
                                            GeneralTaxPtr(GnTaxList[0])^.STARSavings));
              Bold := False;
              Println('');
              End {Star savings > 0}
              else Println('');  {Case of no star savings}
            If ((I= 6) and  (Roundoff(GeneralTaxPtr(GnTaxList[0])^.STARSavings, 2) > 0))
              then
              Begin
               Bold := True;
               Print(#9 + 'Note: This year''s STAR Savings generally may not exceed last year''s by more than 2%');
               Bold := False;
               Println('');
              End
              Else Println('');
            End  {I is 5 or 6 }
            Else Println(''); {blank line always if not line 5 or 6}
          except
          end;
        end;  {For I := (LinesPrinted + 1) to MaxTaxLinesPerPage do}

      GotoXY(1, BottomSectionStart);
      ClearTabs;
      SetTab(6.05, pjLeft, 0.7, 0, BOXLINENone, 0);   {Date}
      SetTab(6.8, pjRight, 1.35, 0, BOXLINENone, 0);   {tax amt}
      Bold := True;
      Print(#9 + #9 + FormatFloat(CurrencyDecimalDisplay,
                                    FieldByName('TotalTaxOwed').AsFloat));
      Bold := False;
      Println('');
      Println('');
      SetFont('Times Roman', 9);
      Bold := True;
      Print(#9 + CollectionLookupTable.FieldByName('PayDate1').Text);
      SetFont('Times Roman', 10);
      Bold := True;
      Println(#9 + FormatFloat(CurrencyDecimalDisplay, FieldByName('TaxPayment1').AsFloat));

      //Println('');
      SetFont('Times Roman', 9);
      Bold := True;
      Print(#9 + CollectionLookupTable.FieldByName('PayDate2').Text);
      SetFont('Times Roman', 10);
      Bold := True;
      Println(#9 + FormatFloat(CurrencyDecimalDisplay, FieldByName('TaxPayment2').AsFloat));

      //For I := 1 to 2 do  {Was 3}
      For I := 1 to 3 do  {Was 3}
        Println ('');

        {Stub 2}

      ClearTabs;
      SetTab(1.1, pjLeft, 3.0, 0, BOXLINENone, 0);  {Stub Tab}
      SetTab(5.25, pjRight, 1.25, 0, BOXLINENone, 0);   {Full Payment}
      SetTab(6.9, pjRight, 1.25, 0, BOXLINENone, 0);   {Half Payment}

      Println(#9 + DezeroOnLeft(tb_Header.FieldByName('BillNo').Text));
      Println('');
      Println('');
      Println(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text) +
              #9 + FormatFloat(CurrencyDecimalDisplay, FieldByName('TotalTaxOwed').AsFloat) +
              #9 + FormatFloat(CurrencyDecimalDisplay, FieldByName('TaxPayment2').AsFloat));
      Println(#9 + GetLegalAddressFromTable(tb_Header));

      If ((FieldByName('HstdAcreage').AsFloat > 0.0) or
          (FieldByName('NonHstdAcreage').AsFloat > 0.0))
        then Println(#9 + 'Acres: ' +
                          FormatFloat(DecimalDisplay, (FieldByName('HstdAcreage').AsFloat +
                                                       FieldByName('NonHstdAcreage').AsFloat)))
        else Println(#9 + 'FRONTAGE: ' +
                          FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) +
                          ', DEPTH: ' +
                          FormatFloat(DecimalDisplay, FieldByName('Depth').AsFloat));

      Println(#9 + FieldByName('PropertyClassCode').Text + ' - ' +
                   UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                                PropertyClassDescList)));
      Println(#9 + tb_Header.FieldByName('BankCode').Text);
      Println('');

        {CHG01092002-1: 3rd party notices.}

      If CurrentlyPrintingThirdPartyNotices
        then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
        else GetNameAddress(tb_Header, NAddrArray);

      For I := 1 to 6 do
        begin
          Print(#9 + CL1List[I]);

          If (I = 5)
            then Println(#9 + #9 + CollectionLookupTable.FieldByName('PayDate2').Text)
            else Println('');

        end;  {For I := 1 to 6 do}

        {Stub 1}

      For I := 1 to 3 do
        Println ('');

      ClearTabs;
      SetTab(1.1, pjLeft, 3.0, 0, BOXLINENone, 0);  {Stub Tab}
      SetTab(5.25, pjRight, 1.25, 0, BOXLINENone, 0);   {Full Payment}
      SetTab(6.9, pjRight, 1.25, 0, BOXLINENone, 0);   {Half Payment}

      Println(#9 + DezeroOnLeft(tb_Header.FieldByName('BillNo').Text));
      Println('');
      Println('');
      Println(#9 + ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text) +
              #9 + FormatFloat(CurrencyDecimalDisplay, FieldByName('TotalTaxOwed').AsFloat) +
              #9 + FormatFloat(CurrencyDecimalDisplay, FieldByName('TaxPayment1').AsFloat));

      Println(#9 + GetLegalAddressFromTable(tb_Header));

      If ((FieldByName('HstdAcreage').AsFloat > 0.0) or
          (FieldByName('NonHstdAcreage').AsFloat > 0.0))
        then Println(#9 + 'Acres: ' +
                          FormatFloat(DecimalDisplay, (FieldByName('HstdAcreage').AsFloat +
                                                       FieldByName('NonHstdAcreage').AsFloat)))
        else Println(#9 + 'FRONTAGE: ' +
                          FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) +
                          ', DEPTH: ' +
                          FormatFloat(DecimalDisplay, FieldByName('Depth').AsFloat));

      Println(#9 + FieldByName('PropertyClassCode').Text + ' - ' +
                   UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                                PropertyClassDescList)));
      Println(#9 + tb_Header.FieldByName('BankCode').Text);
      Println('');

        {CHG01092002-1: 3rd party notices.}

      If CurrentlyPrintingThirdPartyNotices
        then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
        else GetNameAddress(tb_Header, NAddrArray);

      For I := 1 to 6 do
        begin
          Print(#9 + CL1List[I]);

          If (I = 6)
            then Println(#9 + #9 + CollectionLookupTable.FieldByName('PayDate1').Text)
            else Println('');

        end;  {For I := 1 to 6 do}

(*      GotoXY(3.5, 2.75);
      Print(BillParameterTable.FieldByName('FullMktValueDate').AsString); *)

      NewPage;

    end;  {with Sender as TBaseReport do}

  CL1List.Free;
  CL2List.Free;
  CL3List.Free;
  CL4List.Free;
  CL5List.Free;
  CL6List.Free;
  CL7List.Free;

  PageNo := PageNo + 1;

end;  {PrintOneSomersSchoolPage}

{======================================================================}
Function PrintOneSomersSchoolBill(Sender : TObject;
                                  ReportPrinter : TReportPrinter;
                                  ReportFiler : TReportFiler;
                                  ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                                  SwisSBLKey : String;
                                  FormattedSwisSBLKey : String;
                                  SchoolCodeTable,
                                  SwisCodeTable,
                                  CollectionLookupTable,
                                  tb_Header,
                                  BLGeneralTaxTable,
                                  BLSpecialDistrictTaxTable,
                                  BLExemptionTaxTable,
                                  BLSpecialFeeTaxTable,
                                  BillParameterTable,
                                  ParcelTable : TTable;
                                  SDCodeDescList,
                                  EXCodeDescList,
                                  PropertyClassDescList,
                                  GeneralRateList,
                                  SDRateList,
                                  SpecialFeeRateList : TList;
                                  ArrearsMessage : TStringList;
                                  ThirdPartyNotificationTable : TTable;
                                  CurrentlyPrintingThirdPartyNotices : Boolean;
                                  TopSectionStart,
                                  BaseDetailsStart,
                                  BottomSectionStart : Double) : Boolean;

var
  Quit : Boolean;
  PageNo, SDIndex : Integer;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  BaseReportObject : TBaseReport;

begin
  Quit := False;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

  If (ReportObjectToUse = 'P')
    then BaseReportObject := ReportPrinter
    else BaseReportObject := ReportFiler;

  with BaseReportObject do
    begin

         {Load the tax data  for this parcel}

      LoadTaxesForParcel(SwisSBLKey,
                         BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         SDCodeDescList, EXCodeDescList,
                         GeneralRateList, SDRateList,
                         SpecialFeeRateList, GnTaxList,
                         SDTaxList, SpTaxList, ExTaxList, Quit);

      PageNo := 1;
      SDIndex := 0;

      repeat
        PrintOneSomersSchoolPage(Sender, BaseReportObject, SwisSBLKey, FormattedSwisSBLKey,
                                 GnTaxList, SDTaxList, SpTaxList, ExTaxList,
                                 SchoolCodeTable, SwisCodeTable,
                                 CollectionLookupTable,
                                 tb_Header,
                                 BLGeneralTaxTable,
                                 BLSpecialDistrictTaxTable,
                                 BLExemptionTaxTable,
                                 BLSpecialFeeTaxTable,
                                 BillParameterTable,
                                 ParcelTable,
                                 SDCodeDescList,
                                 EXCodeDescList,
                                 PropertyClassDescList,
                                 GeneralRateList,
                                 SDRateList,
                                 SpecialFeeRateList,
                                 ArrearsMessage,
                                 ThirdPartyNotificationTable,
                                 CurrentlyPrintingThirdPartyNotices,
                                 TopSectionStart, BaseDetailsStart, BottomSectionStart,
                                 PageNo, SDIndex);

      until (SDIndex >= (SDTaxList.Count - 1))

    end;  {with BaseReportObject do}

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

  Result := Quit;

end;  {PrintOneSomersSchoolBill}

{===================================================================}
Procedure SetRyeFourColTabs(Sender : TObject);

begin
  with Sender as TBaseReport do
    begin
      ClearTabs;
      SetTab(0.4, pjLeft, 2.0,0, BoxLineNone, 0); {}
      SetTab(2.7, pjLeft,1.5, 0, BoxLineNone,0);  {}
      SetTab(5.1, pjright,1.5, 0, BoxLineNone,0);  {}
      SetTab(6.5, pjright,1.5, 0, BoxLineNone,0);
      SetTab(7.0, pjRight,1.0, 0, BoxLineNone,0);  {note: only used on one line}

   end;  {with Sender as TBaseReport do}

end;  {SetRyeFourColTabs}

{================================================================}
Procedure PrintRyeExemptions(Sender : TObject;
                             CollectionType : String;
                             SwisSBLKey : String;
                             NAddrArray : NameAddrArray;
                             ExemptionTable : TTable;
                             StarSavings : Extended);

var
  I, LinesPrinted, NaddrNo : Integer;
  TempExemptionAmount : Double;

begin
  LinesPrinted := 0;

  ExemptionTable.cancelrange;
  SetRangeOld(ExemptionTable,
              ['SwisSBLKey', 'EXCode', 'HomesteadCode'],
              [SwisSBLKey,'00000',' '],
              [SwisSBLKey, '99999', ' ']);

  with Sender as TBaseReport do
    begin
    {assumes two sets of columns}
      NaddrNo := 5;
      repeat
        If (ExemptionTable.fieldByName('ExCode').Text = '')
          then
            case NaddrNo of
             5 :
               begin
                Println(#9 + '     ' + NAddrArray[5]);
                Println(#9 + '     ' + NAddrArray[6]);
                LinesPrinted := 2;
               end;
             6 :  begin
                    Println(#9 + '     ' + NAddrArray[6]);
                    LinesPrinted := LinesPrinted + 1;
                  end;

             7,8 : begin
                       Println('');
                       LinesPrinted := LinesPrinted + 1;
                     end;
            end
          else
            begin
              If (NaddrNo > 6)
                then Print(#9)
                else Print(#9 + '     ' + NAddrArray[NaddrNo]);

              If (CollectionType = 'CO')
                then TempExemptionAmount := ExemptionTable.FieldByName('CountyAmount').AsFloat
                else
                  If (CollectionType = 'SC')
                    then TempExemptionAmount := ExemptionTable.FieldByName('SchoolAmount').AsFloat
                    else TempExemptionAmount := ExemptionTable.FieldByName('TownAmount').AsFloat;

              Println(#9 + ExemptionTable.fieldByName('ExCode').AsString +
                      #9 + FormatFloat(CurrencyNormalDisplay, TempExemptionAmount) +
                      #9 + FormatFloat(CurrencyNormalDisplay, ExemptionTable.FieldByName('FullValue').AsInteger));

              LinesPrinted := LinesPrinted + 1;

            end;  {else of If (ExemptionTable.fieldByName('ExCode').Text = '')}

        NaddrNo := (NaddrNo + 1);
        ExemptionTable.Next;

      until ExemptionTable.EOF;

      For I := (LinesPrinted + 1) to 5 do
        If ((I = 5) and
            (CollectionType = 'SC') and
            (Roundoff(STARSavings, 0) > 0))
          then
            begin
              with Sender as TBaseReport do
                begin
                  ClearTabs;
                  SetTab(5.1, pjLeft,1.5, 0, BoxLineNone,0);  {}
                  SetTab(6.5, pjright,1.5, 0, BoxLineNone,0);

                  Println(#9 + 'STAR Savings' +
                          #9 + FormatFloat(DecimalDisplay,
                                           STARSavings));
                  SetRyeFourColTabs(Sender);

                end;  {with Sender as TBaseReport do}

            end
          else Println('');

    end;  {with Sender as TBaseReport do}

end;  {PrintRyeExemptions}

{======================================================================}
Procedure PrintOneRyePage(    Sender : TObject;
                              BaseReportObject : TBaseReport;
                              CollectionType : String;
                              SwisSBLKey : String;
                              FormattedSwisSBLKey : String;
                              GnTaxList,
                              SDTaxList,
                              SpTaxList,
                              ExTaxList : TList;
                              SchoolCodeTable,
                              SwisCodeTable,
                              CollectionLookupTable,
                              tb_Header,
                              BLGeneralTaxTable,
                              BLSpecialDistrictTaxTable,
                              BLExemptionTaxTable,
                              BLSpecialFeeTaxTable,
                              BillParameterTable,
                              ParcelTable : TTable;
                              SDCodeDescList,
                              EXCodeDescList,
                              PropertyClassDescList,
                              GeneralRateList,
                              SDRateList,
                              SpecialFeeRateList : TList;
                              ArrearsMessage : TStringList;
                              ThirdPartyNotificationTable : TTable;
                              CurrentlyPrintingThirdPartyNotices : Boolean;
                          var PageNo,
                              SDIndex : Integer);

const
  Topmarg = 3;  {blank lines at top of page}
  MaxTaxLinesPerPage = 8;

var
  Index, I, J, RateIndex,LinesPrinted : Integer;
  NAddrArray : NameAddrArray;
  TempEXCode : String;
  UniformPercentValue,
  Temprl, TempReal : Double;
  TempStr : String;
  EXAppliesArray : ExemptionAppliesArrayType;
  TempPtr : SDistTaxPtr;
  TempStr2 : String;
  CL1List,
  CL2List,
  CL3List,
  CL4List,
  CL5List,
  CL6List,
  CL7List : TStringList;
  SchoolCode : String;
  SwisCode : String;
  LastSDCode, TaxableValStr : String;
  SBLRec : SBLRecord;
  STARSavings : Extended;

begin
  {create string list for printing parallel non-related data }
    {across the page; eg Name/addr info in cl1list, ex data }
    {in CL2List}

  CL1List := TStringList.Create;
  CL2List := TStringList.Create;
  CL3List := TStringList.Create;
  CL4List := TStringList.Create;
  CL5List := TStringList.Create;
  CL6List := TStringList.Create;
  CL7List := TStringList.Create;

  with Sender as TBaseReport do
    begin
      Bold := false;
      ClearTabs;
      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}
    end;  {with Sender as TBaseReport do}

  with Sender as TBaseReport, tb_Header do
    begin
      SetFont('Courier',12);
      Bold := false;
      Underline := true;
      CRLF;
      CRLF;

      PrintCenter('CITY OF RYE * STATEMENT OF TAXES * FISCAL YEAR ' +
                  BillParameterTable.fieldByName('FiscalYear').AsString,(PageWidth / 2));
      CRLF;
      PrintCenter('DETACH AND RETURN THIS PORTION WITH YOUR REMITTANCE',(PageWidth / 2));
      CRLF;
      PrintCenter('OR RETURN THE ENTIRE BILL IF YOU NEED A RECEIPT',(PageWidth / 2));
      CRLF;
      CRLF;
      SetFont('Courier',10);
      Underline := false;
      SetRyeFourColTabs(Sender);

      Print(#9 + 'Parcel Number: '+ ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text));

      Println(#9 + #9 +#9 +'Date Payment Due:  ' + CollectionLookupTable.FieldByName('PayDate1').AsString);

      Println(#9 + 'Bill Number: ' + DeZeroOnLeft(fieldByName('Billno').AsString));
(*              #9 + #9 +
              #9 + 'Delinquency Date:  ' + BillParameterTable.FieldByName('DelinquencyDate').Text); *)
      CRLF;
      Underline := true;
      Print(#9 + 'Property Owner/Location');
      Underline := false;
      Println(#9 + 'Bank Code: ' + tb_Header.FieldByName('BankCode').Text);

      Println(#9 + tb_Header.FieldBYName('Name1').Text);

      Println(#9 + GetLegalAddressFromTable(tb_Header) +
              #9 + #9 +
              #9 + 'Tax Amt Payable:  ' +
                   FormatFloat(DecimalDisplay, FieldByName('TaxPayment1').AsFloat));

      Println(#9 + 'RYE, NY 10580');

      CRLF;
      CRLF;
      CRLF;
      CRLF;
      Println('');
      Println('');

         {FXX01182001-1: Move the 'City of Rye' down 1 line, but take away 1 line after.}

      SetFont('Courier',12);
      Bold:= false;
      Underline := true;

      PrintCenter('CITY OF RYE',(PageWidth / 2));
      CRLF;
      SetFont('Courier',10);

      CRLF;
      Underline := false;

        {Print an arrears message if the parcel has arrears.}

      LinesPrinted := 0;

      If FieldByName('ArrearsFlag').AsBoolean
        then
          For I := 0 to (ArrearsMessage.Count - 1) do
            begin
              Println(#9 + ArrearsMessage[I]);
              LinesPrinted := LinesPrinted + 1;
            end;

      For I := (LinesPrinted + 1) to 6 do
        Println(#9 + '');

        PrintCenter('Parcel Number: '+ ConvertSBLOnlyToDashDot(FieldByName('SBLKey').Text),(PageWidth / 2));
        CRLF;
        CRLF;
        Print(#9 + 'Bank Code: ' +
                   tb_Header.FieldByName('BankCode').Text );
        Underline := True;

        Println(#9 + #9 + #9 +'Property Owner/Location');
        Print(#9 + 'Warrant Date' + #9 + 'Est. State Aid');
        Underline := False;

        Println(#9 + #9 + tb_Header.FieldBYName('Name1').Text);
        Print(#9 + BillParameterTable.FieldByName('WarrantDate').AsString);

        RateIndex := FindGeneralRate(-1, GeneralTaxPtr(GnTaxList[0])^.GeneralTaxType,
                                     tb_Header.FieldByName('SwisCode').Text,
                                     GeneralRateList);

        Print(#9 + FormatFloat(CurrencyNormalDisplay,
                               GeneralRatePointer(GeneralRateList[RateIndex])^.EstimatedStateAid));

        Println(#9 + #9 + GetLegalAddressFromTable(tb_Header));
        Println(#9 + #9 + #9 + #9 + 'RYE, NY 10580');
        CRLF;
        Println(#9 + #9 + #9 + #9 + 'Bill Number:  ' + DeZeroOnLeft(tb_Header.FieldByName('BillNo').Text));
        CRLF;

          {CHG01092002-1: 3rd party notices.}

        If CurrentlyPrintingThirdPartyNotices
          then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
          else GetNameAddress(tb_Header, NAddrArray);

        Println(#9 + '     ' + NAddrArray[1]);
        Println(#9 + '     ' + NAddrArray[2]);

          {CHG08222007-1(2.11.3.5)[I1079]: Add full value of exemption to bill.}

        ClearTabs;
        SetTab(0.4, pjLeft, 3.0,0, BoxLineNone, 0); {}
        SetTab(4.8, pjright,1.2, 0, BoxLineNone,0);
        SetTab(6.1, pjRight,1.0, 0, BoxLineNone,0);
        SetTab(7.2, pjRight,1.0, 0, BoxLineNone,0);

        Print(#9 + '     ' + NAddrArray[3]);
        Println(#9 + 'Exemption' +
                #9 + #9 + 'Full');

        Print(#9 + '     ' + NAddrArray[4]);
        Underline := True;
        Println(#9 + 'Code' +
                #9 + 'Amount' +
                #9 + 'Value');
        Underline := False;

        If (CollectionType = 'SC')
          then STARSavings := GeneralTaxPtr(GnTaxList[0])^.StarSavings
          else STARSavings := 0;

        PrintRyeExemptions(Sender, CollectionType,
                           FieldbyName ('SwisCode').text + FieldByName ('SBLKey').text,
                           NaddrArray, BLExemptionTaxTable,
                           STARSavings);

        SetRyeFourColTabs(Sender);

        CRLF;
        FindKeyOld(SwisCodeTable, ['SwisCode'],
                   [FieldByName('SwisCode').Text]);

        UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
        TempReal := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                      FieldByName('NonHstdTotalVal').AsFloat),
                                     SwisCodeTable,
                                     tb_Header.FieldByName('PropertyClassCode').Text,
                                     ' ', True);
        CRLF;
        If ((CollectionType = 'SC') and
            (GeneralTaxPtr(GnTaxList[0])^.StarSavings > 0))
        then
        begin
          CRLF;
          Println(#9 + '    Note: This year' + '''' + 's STAR tax savings generally may not exceed last year' +
                       '''' + 's by more than 2%.');
          CRLF;
        end;

        Println(#9 + 'Uniform Percentage:   ' +
                     FormatFloat(DecimalEditDisplay,
                                 SwisCodeTable.FieldByName('UniformPercentValue').AsFloat));

        Println(#9 + 'Est Full Market Value: ' +
                     FormatFloat(CurrencyDisplayNoDollarSign, TempReal));
        Println(#9 + 'Tax Year:   ' + BillParameterTable.FieldByName('TaxYear').Text);
        CRLF;
        PrintCenter ('->-> IMPORTANT: PLEASE READ INFORMATION ON THE BACK OF THIS BILL <-<-',(PageWidth / 2));
        CRLF;
        CRLF;

        ClearTabs;
        SetTab(0.5, pjLeft,   1.8,0, BoxLineNone, 0); {Levy Description}
        SetTab(1.9, pjCenter, 1.2,0, BoxLineNone, 0); {Assessed Valuation}
        SetTab(3.1, pjCenter, 1.1,0, boxLineNone, 0); { Taxable Value}
        SetTab(4.3, pjcenter,  1.0,0, BoxLineNone, 0); {Tax Rate}
        SetTab(5.5, pjright,  1.0,0, BoxLineNone, 0); {Total Tax Amount}
        SetTab(6.7, pjright,  1.0,0, BoxLineNone, 0); {AmountDue}
        SetTab(6.9, pjright,  1.2,0, BoxLineNone, 0); {Extra space}

        Println(#9 + 'LEVY' +
                #9 + 'ASSESSED' +
                #9 + 'TAXABLE' +
                #9 + 'TAX' +
                #9 + 'TOTAL TAX' +
                #9 + 'AMOUNTS');
        Underline := True;
        Println(#9 + 'DESCRIPTION' +
                #9 + 'VALUATION'+
                #9 + 'VALUE' +
                #9 + 'RATE' +
                #9 + 'AMOUNT' +
                #9 + 'DUE');
        Underline := False;

        For I := 0 to (GnTaxList.Count - 1) do
          with GeneralTaxPtr(GnTaxList[I])^ do
            begin
              SwisCode := FieldByName('SwisCode').Text;

                {Only search on the first 4 digits of swis code.}

              If (GeneralTaxType = 'CO')
                then SwisCode := Take(4, SwisCode);

              RateIndex := FindGeneralRate(GeneralTaxPtr(GnTaxList[I])^.PrintOrder,
                                           GeneralTaxType, SwisCode, GeneralRateList);

              with GeneralRatePointer(GeneralRateList[RateIndex])^ do
                begin
                  Print(#9 + (Take(20, Description)) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign, FieldByName('HstdTotalVal').asFloat) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal) +
                        #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                        #9 + FormatFloat(DecimalDisplay, TaxAmount));

                  LinesPrinted := 0;

                  If (I = 0)
                    then Println(#9 + FormatFloat(DecimalDisplay, FieldbyName ('TotalTaxOwed').asFloat))
                    else Println(#9);

                end;  {with GeneralRatePointer(GeneralRateList[RateIndex])^ do}

              LinesPrinted := LinesPrinted + 1;

            end;  {with GeneralTaxPtr(GnTaxList[I])^ do}

        LastSDCode := '';

        while ((SDIndex <= (SDTaxList.Count - 1)) and
               (LinesPrinted < MaxTaxLinesPerPage)) do
          with SDistTaxPtr(SDTaxList[SDIndex])^ do
            begin
              FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, Index);

              TaxRate := SDRatePointer(SDRateList[Index])^.HomesteadRate;

              If (Roundoff(TaxRate, 6) > 0.000000)
                then
                  begin
                    Print(#9 + Take(20, Description)+
                          #9 + FormatFloat(CurrencyDisplayNoDollarSign,
                                           FieldbyName('HstdTotalVal').asFloat));  {assessed valuation}

                      {Only print levy amts for 1st extension of code.}

                    If (SDistTaxPtr(SDTaxList[SDIndex])^.ExtCode = 'TO')
                      then TaxableValStr := FormatFloat(CurrencyDisplayNoDollarSign, SdValue)
                      else TaxableValStr := FormatFloat(DecimalDisplay, SdValue);

                    Print(#9 + TaxableValStr +
                          #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate));

                    with SDRatePointer(SDRateList[Index])^ do
                      begin
                        Println(#9 + FormatFloat(DecimalDisplay, SDAmount));
                        LinesPrinted := LinesPrinted + 1;
                     end;

                  end;  {If (Roundoff(TaxRate, 0) > 0)}

              SDIndex := SDIndex + 1;

            end;  { with SDistTaxPtr(SDTaxList[I])^ do}

        CRLF;
        Println(#9 + #9 + #9 + #9 +
                #9 + 'Tax Amt Payable:' +
                #9 + FormatFloat(DecimalDisplay,
                                 FieldByName('TaxPayment1').AsFloat));

        NewPage;

    end;  {with Sender as TBaseReport, tb_Header do}

  CL1List.Free;
  CL2List.Free;
  CL3List.Free;
  CL4List.Free;
  CL5List.Free;
  CL6List.Free;
  CL7List.Free;

  PageNo := PageNo + 1;

end;  {PrintOneRyePage}

{======================================================================}
Function PrintOneRyeBill(Sender : TObject;
                         ReportPrinter : TReportPrinter;
                         ReportFiler : TReportFiler;
                         ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                         CollectionType : String;
                         SwisSBLKey : String;
                         FormattedSwisSBLKey : String;
                         SchoolCodeTable,
                         SwisCodeTable,
                         CollectionLookupTable,
                         tb_Header,
                         BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         BillParameterTable,
                         ParcelTable : TTable;
                         SDCodeDescList,
                         EXCodeDescList,
                         PropertyClassDescList,
                         GeneralRateList,
                         SDRateList,
                         SpecialFeeRateList : TList;
                         ArrearsMessage : TStringList;
                         ThirdPartyNotificationTable : TTable;
                         CurrentlyPrintingThirdPartyNotices : Boolean) : Boolean;

var
  Quit : Boolean;
  PageNo, SDIndex : Integer;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  BaseReportObject : TBaseReport;

begin
  Quit := False;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

  If (ReportObjectToUse = 'P')
    then BaseReportObject := ReportPrinter
    else BaseReportObject := ReportFiler;

  with BaseReportObject do
    begin

         {Load the tax data  for this parcel}

      LoadTaxesForParcel(SwisSBLKey,
                         BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         SDCodeDescList, EXCodeDescList,
                         GeneralRateList, SDRateList,
                         SpecialFeeRateList, GnTaxList,
                         SDTaxList, SpTaxList, ExTaxList, Quit);

      PageNo := 1;
      SDIndex := 0;

      repeat
        PrintOneRyePage(Sender, BaseReportObject,
                        CollectionType, SwisSBLKey, FormattedSwisSBLKey,
                        GnTaxList, SDTaxList, SpTaxList, ExTaxList,
                        SchoolCodeTable, SwisCodeTable,
                        CollectionLookupTable,
                        tb_Header,
                        BLGeneralTaxTable,
                        BLSpecialDistrictTaxTable,
                        BLExemptionTaxTable,
                        BLSpecialFeeTaxTable,
                        BillParameterTable,
                        ParcelTable,
                        SDCodeDescList,
                        EXCodeDescList,
                        PropertyClassDescList,
                        GeneralRateList,
                        SDRateList,
                        SpecialFeeRateList,
                        ArrearsMessage,
                        ThirdPartyNotificationTable,
                        CurrentlyPrintingThirdPartyNotices,
                        PageNo, SDIndex);

      until (SDIndex >= (SDTaxList.Count - 1))

    end;  {with BaseReportObject do}

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

  Result := Quit;

end;  {PrintOneRyeCityBill}

{======================================================================}
Function PrintOneMtPleasantSchoolBill_Old(ReportPrinter : TReportPrinter;
                                      ReportFiler : TReportFiler;
                                      ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                                      SwisSBLKey : String;
                                      FormattedSwisSBLKey : String;
                                      SchoolCodeTable,
                                      SwisCodeTable,
                                      CollectionLookupTable,
                                      tb_Header,
                                      BLGeneralTaxTable,
                                      BLSpecialDistrictTaxTable,
                                      BLExemptionTaxTable,
                                      BLSpecialFeeTaxTable,
                                      BillParameterTable : TTable;
                                      SDCodeDescList,
                                      EXCodeDescList,
                                      PropertyClassDescList,
                                      GeneralRateList,
                                      SDRateList,
                                      SpecialFeeRateList : TList;
                                      ArrearsMessage : TStringList;
                                      ThirdPartyNotificationTable : TTable;
                                      CurrentlyPrintingThirdPartyNotices : Boolean;
                                      MPSchoolBaseDetailsStart : Double;
                                      TopSectionStart : Double) : Boolean;

const
  Topmarg = 4;  {blank lines at top of page}

var
  Quit, ValidEntry : Boolean;
  LinesPrinted, Index, I, J, RateIndex : Integer;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  NAddrArray : NameAddrArray;
  TempEXCode : String;
  UniformPercentValue,
  Temprl, TempReal, STARSavings : Double;
  TempStr : String;
  EXAppliesArray : ExemptionAppliesArrayType;
  TempPtr : SDistTaxPtr;
  TempStr2 : String;
  CL1List,
  CL2List,
  CL3List,
  CL4List,
  CL5List,
  CL6List,
  CL7List : TStringList;
  BaseReportObject : TBaseReport;

begin
  Quit := False;

  SwisCodeTable.First;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

  {create string list for printing parallel non-related data }
    {across the page; eg Name/addr info in cl1list, ex data }
    {in CL2List}

  CL1List := TStringList.Create;
  CL2List := TStringList.Create;
  CL3List := TStringList.Create;
  CL4List := TStringList.Create;
  CL5List := TStringList.Create;
  CL6List := TStringList.Create;
  CL7List := TStringList.Create;

  If (ReportObjectToUse = 'P')
    then BaseReportObject := ReportPrinter
    else BaseReportObject := ReportFiler;

  with BaseReportObject, tb_Header do
    begin
         {Load the tax data  for this parcel}

      LoadTaxesForParcel(SwisSBLKey, BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         SDCodeDescList, EXCodeDescList,
                         GeneralRateList, SDRateList,
                         SpecialFeeRateList, GnTaxList,
                         SDTaxList, SpTaxList, ExTaxList, Quit);

      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('MS Serif', 10);

        {print the bill on the form}

        {SCROLL DOWN TO FIRST PRINT LINE}

(*      For I := 1 to TopMarg do
        Println(''); *)

        {FXX08082001-4: Due to changes in the bill form, the top margin is
                        different.}
        {FXX07262004-1(2.07l5): Honor top section setting.}

      GotoXY(0.1, TopSectionStart);

         {>>> TAX MAP            }

         {CHG03101999-2: Make the bill printing into a seperate DLL.}
         {Need to pass in formatted parcel ID since DLL will not have access to segment layouts.}

      Bold := True;
      ClearTabs;
      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}
      PrintLn(#9 + FormattedSwisSBLKey);

        {>>> PROP LOCATION      }

      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}
      Println(#9 + GetLegalAddressFromTable(tb_Header));

          {>>> DIMENSIONS      }

      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}

      If ((FieldByName('HstdAcreage').AsFloat > 0.0) or
          (FieldByName('NonHstdAcreage').AsFloat > 0.0))
        then Println(#9 + 'ACRES: ' +
                          FormatFloat(DecimalDisplay, (FieldByName('HstdAcreage').AsFloat) +
                                                      (FieldByName('NonHstdAcreage').AsFloat)))
        else Println(#9 + 'FRONTAGE: ' +
                          FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) +
                          ', DEPTH: ' +
                          FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat)) ;

          {>>> PROPERTY CLASS }

      Println(#9 + FieldByName('PropertyClassCode').Text + ' - ' +
            UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                        PropertyClassDescList)));

          {>>> ROLL SECTION }

      Println(#9 + FieldByName('RollSection').Text);

          {>>> WARRANT DATE  }

      Println(#9 + BillParameterTable.FieldByName('WarrantDate').AsString);

          {>>> SPACES }

      For I := 1 to 2 do
       Println('  ');

         {CHG01092002-1: 3rd party notices.}

     If CurrentlyPrintingThirdPartyNotices
       then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
       else GetNameAddress(tb_Header, NAddrArray);

         {fill in clist1 with name addr info}

     For I := 1 to 6 do
       CL1List.Add(NaddrArray[I]);

       {First line is hdr for exemptions.}

     CL2List.Add('');
     CL3List.Add('');
     CL4List.Add('');
     CL5List.Add('');

         {Now fill in exemptions}

      For I := 0 to (ExTaxList.Count - 1) do
        begin
          TempExCode := ExemptTaxPtr(ExTaxList[I])^.EXCode;
          EXAppliesArray := EXApplies(TempEXCode, False);

          If EXAppliesArray[EXSchool]
            then
              begin
               CL2List.Add(Take(10, ExemptTaxPtr(ExTaxList[I])^.Description));
               CL3List.Add(ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL4List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.SchoolAmount));

               CL5List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.FullValue));

             end;  {If EXAppliesArray[EXSchool]}

        end;  {For I := 0 to (ExTaxList.Count - 1) do}

          {pad out rest of exemption columns to 6 lines to match Naddr clist}

      For I := (ExTaxList.Count) to 6 do
        begin
          CL2List.Add('');
          CL3List.Add('');
          CL4List.Add('');
          CL5List.Add('');
        end;

         {>>> NAME/ADDR AND EXEMPTIONS >>>}

(*      ClearTabs;
      SetTab(1.3, pjLeft, 3.2, 0, BOXLINENone, 0);   {nAME/ADDR}
      SetTab(5.2, pjLeft, 1.0, 0, BOXLINENone, 0);   {EX DESCR}
      SetTab(6.3, pjLeft, 0.5, 0, BOXLINENone, 0);   {EX CODE}
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {eX amt} *)

         {>>> NAME/ADDR AND EXEMPTIONS >>>}
         {CHG08052007-1(2.11.2.12): Add full value of exemption.}

      ClearTabs;
      SetTab(1.3, pjLeft, 3.2, 0, BOXLINENone, 0);   {Name / addr}
      SetTab(5.0, pjLeft, 0.95, 0, BOXLINENone, 0);  {Ex description}
      SetTab(6.0, pjLeft, 0.45, 0, BOXLINENone, 0);  {Ex code}
      SetTab(6.4, pjRight, 0.8, 0, BOXLINENone, 0);  {Ex amount}
      SetTab(7.3, pjRight, 0.9, 0, BOXLINENone, 0);  {Full value}

      For I := 0 to 5 do
        Println(#9 + CL1List[I] +
                #9 + CL2List[I] +
                #9 + CL3List[I] +
                #9 + CL4List[I] +
                #9 + CL5List[I]);

       {>>> 3 SPACES }

      For I := 1 to 3 do
        Println('  ');

         {>>> STATE AID  }

         {Ignore the swis code for the school billing.}

      RateIndex := FindGeneralRate(-1, 'SC', '', GeneralRateList);
        {FXX08082001-5: Increase the size of the first column by 0.2 to avoid overwriting label.}

      ClearTabs;
      SetTab(1.0, pjRight, 1.7, 0, BOXLINENone, 0);   {sTATE AID}
      Println(#9 + FormatFloat(CurrencyNormalDisplay,
                               GeneralRatePointer(GeneralRateList[0])^.EstimatedStateAid));

        {>>> TAX YR, FISCAL YR  }

      ClearTabs;
      SetTab(1.0, pjRight, 1.7, 0, BOXLINENone, 0);   {tax year}
      SetTab(4.2, pjLeft, 1.5, 0, BOXLINENone, 0);   {fiscal year}
      Println(#9 + BillParameterTable.FieldByname('TaxYear').Text +
              #9 + BillParameterTable.FieldByName('FiscalYear').Text);

         {>>> BANK CODE AND BILLNO }

      Println(#9 + FieldByName('BankCode').Text + #9 +
                   DezeroOnLeft(FieldByName('BillNo').Text));

         {>>> ASSESSMENT ROLL DATE & NYS SCHL FINANCE CODE}
         {FXX08131998-2: For now, just get tax finance code from
                         school table so don't have to recalculate.}

      FindKeyOld(SchoolCodeTable, ['SchoolCode'],
                 [FieldByName('SchoolDistCode').Text]);
      TempStr2 := SchoolCodeTable.FieldByName('TaxFinanceCode').Text;

      Println(#9 + BillParameterTable.FieldByName('AssessmentRollDate').Text +
              #9 + TempStr2{FieldByName('TaxFinanceCode').Text});

        {>>> 4 SPACES }

      For I := 1 to 4 do
        Println('  ');

      LinesPrinted := 0;

           {>>> PRINT TAX LINE }

      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BOXLINENone, 0);   {purpose}
      SetTab(2.5, pjRight, 1.0, 0, BOXLINENone, 0);   {total levy}
      SetTab(3.8, pjRight, 0.5, 0, BOXLINENone, 0);   {% inc /dcr}
      SetTab(4.6, pjRight, 1.0, 0, BOXLINENone, 0);   {tax val}
      SetTab(5.7, pjRight, 1.0, 0, BOXLINENone, 0);   {tax rate}
      SetTab(6.8, pjRight, 1.2, 0, BOXLINENone, 0);   {tax amt}

      If (GnTaxList.Count > 0)
        then
          For I := 0 to (GnTaxList.Count - 1) do
            begin
              LinesPrinted := LinesPrinted + 1;

              with GeneralTaxPtr(GnTaxList[I])^,
                 GeneralRatePointer(GeneralRateList[I])^ do
                Println(#9 + Take(20, Description) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy) +
                        #9 + FormatFloat(DecimalDisplay,
                                         ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                     PriorTaxLevy)) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal) +
                        #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                        #9 + FormatFloat(DecimalDisplay, TaxAmount));

            end;  {For I := 0 to (GnTaxList.Count - 1) do}

        {FXX08101998-1: Print the SDs if rs 9.}
        {CHG07312003-1(2.07h): Actually, they have now switched from rs 9 and need to see the
                               special district taxes on any bill.}

      If (SDTaxList.Count > 0)
(*          (FieldByName('RollSection').Text = '9'))*)
        then
          For I := 0 to (SDTaxList.Count - 1) do
            with SDistTaxPtr(SDTaxList[I])^ do
              begin
                LinesPrinted := LinesPrinted + 1;
                FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, Index);

                TaxRate := SDRatePointer(SDRateList[Index])^.HomesteadRate;

                If (Roundoff(TaxRate, 6) > 0.000000)
                  then Println(#9 + Take(20, Description) +
                               #9 + #9 + #9 + #9 +
                               #9 + FormatFloat(DecimalDisplay, SDAmount));

              end;  { with SDistTaxPtr(SDTaxList[I])^ do}

        {CHG03161999-1: Print arrears message on bill.}
        {Do we need to print an arrears message at the end?}

      If FieldByName('ArrearsFlag').AsBoolean
        then
          begin
            Println('');
            LinesPrinted := LinesPrinted + 1;

            For I := 0 to (ArrearsMessage.Count - 1) do
              begin
                Println(#9 + ArrearsMessage[I]);
                LinesPrinted := LinesPrinted + 1;
              end;

          end;  {If FieldByName('ArrearsFlag').AsBoolean}

         {>>> 5 SPACES }
         {FXX07091998-5: Try 5 spaces instead of 4.}
         {FXX07131998-1: Go back to 4 spaces for new form.}

      For I := 1 to (5 - LinesPrinted) do
        Println('');

         {>>> FULL MARKET VALUE }

         {FXX07061998-2: Get the uniform % of value from the swis code table.}

     FindKeyOld(SwisCodeTable, ['SwisCode'],
                [FieldByName('SwisCode').Text]);

     UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
     TempReal := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                   FieldByName('NonHstdTotalVal').AsFloat),
                                  SwisCodeTable,
                                  tb_Header.FieldByName('PropertyClassCode').Text,
                                  ' ', True);

       {CHG08062002-3: Move the half paid amounts and due date up 1 line and
                       bring the whole section down.}

     GotoXY(1, MPSchoolBaseDetailsStart);

       {FXX08132008-1(2.15.1.4): Move the rightmost column.}
       {FXX08182009-1(2.20.1.13): Move the 2 right columns 0.2 inches right.}

     ClearTabs;
     SetTab(0.3, pjLeft, 4.0, 0, BOXLINENone, 0);   { uNIF % VAL}
     SetTab(5.9, pjLeft, 1.1, 0, BOXLINENone, 0);   { 1H TAX}
     SetTab(7.3, pjLeft, 1.1, 0, BOXLINENone, 0);   { 2H TAX}
     Println(#9 + 'Full Market Value - ' +
                  BillParameterTable.FieldByName('FullMktValueDate').Text + ':   ' +
                  FormatFloat(CurrencyNormalDisplay, TempReal) +
             #9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment1').AsFloat) +
             #9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment2').AsFloat));

         {>>> ASSESSED VALUE }

     Println(#9 + 'Assessed Value - ' +
              BillParameterTable.FieldByName('AssessmentRollDate').Text + ':  ' +
              FormatFloat(CurrencyNormalDisplay, (FieldByName('HstdTotalVal').AsFloat +
                                             FieldByName('NonHstdTotalVal').AsFloat)));

         {>>> UNIF % VALUE  & 1H/2h AMOUNTS}

      Println(#9 + 'Uniform Pct. of Value for Assessments: ' +
             FormatFloat(DecimalDisplay, UniformPercentValue));

        {>>> STAR AMT (If applicable) }

      If (GnTaxList.Count = 0)
        then STARSavings := 0
        else STARSavings := GeneralTaxPtr(GnTaxList[0])^.StarSavings;

      If (Roundoff(STARSavings, 2) > 0)
        then
          begin
            Println(#9 + 'Your tax savings this year resulting from the New York' +
                    #9 + CollectionLookupTable.FieldByName('PayDate1').Text + #9 +
                         CollectionLookupTable.FieldByName('PayDate2').Text);

            Println(#9 + 'State school tax relief (STAR) program is: ' +
                         FormatFloat(DecimalDisplay, StarSavings));
         end
       else
         begin
           Println(#9 +
                   #9 + CollectionLookupTable.FieldByName('PayDate1').Text + #9 +
                        CollectionLookupTable.FieldByName('PayDate2').Text );
           Println('');
         end;

      For I := 1 to 4 do
         Println('');

(*               PrintStub(Sender, tb_Header, SwisSBLKey, NAddrArray,
                FieldByName('TaxPayment2').AsFloat,
                CollectionLookupTable.FieldByName('PayDate2').Text); *)

        {FXX07301998-1: Have to print stubs not in subroutine because
                        of HP8000 print problem.}
        {Print stub for 2nd half.}

      ClearTabs;
      SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   { 2h stub sbl}
      Println(#9 + FormattedSwisSBLKey);

        {>>> 2 SPACES }

      For I := 1 to 2 do
        Println('');

         {>>> PROP LOCATION}

      ClearTabs;
      SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   {PROP LOC}
      Println(#9 + GetLegalAddressFromTable(tb_Header));

        {>>> BILL NO, BANK CODE}
        {CHG08062002-1: Vicki wants the school code to the left
                        of the bill number.}

      ClearTabs;
      SetTab(4.4, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      SetTab(6.6, pjLeft, 1.0, 0, BOXLINENone, 0);   {BANK CODE}
      Println(#9 + tb_Header.FieldByName('BankCode').Text +
              #9 + '   (' + Copy(FieldByName('SchoolDistCode').Text, 3, 4) + ') ' +
                   DezeroOnLeft(tb_Header.FieldByName('BillNo').Text));

          {>>> SPACE 1 LINE}

      Println('');

          {>>> AMOUNT DUE}

      ClearTabs;
      SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment2').AsFloat));

        {>>> SPACE 1 LINE}

      Println('');

         {>>> NAME LINE 1}

      ClearTabs;
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + NAddrArray[1]);

         {>>> DATE DUE AND NAME LINE 2}

      ClearTabs;
      SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {DATE DUE}
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + CollectionLookupTable.FieldByName('PayDate2').Text +
              #9 + NAddrArray[2]);

          {>>> REST OF NAME DATA }

      ClearTabs;
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      For I := 3 to 6 do
        Println(#9 +  NAddrArray[I]);

       {>>> 7 SPACES }

      For I := 1 to 7 do
        Println('');

        {Print stub for 1st half.}

      ClearTabs;
      SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   { 2h stub sbl}
      Println(#9 + FormattedSwisSBLKey);

        {>>> 2 SPACES }

      For I := 1 to 2 do
        Println('');

         {>>> PROP LOCATION}

      ClearTabs;
      SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   {PROP LOC}
      Println(#9 + GetLegalAddressFromTable(tb_Header));

        {>>> BILL NO, BANK CODE}
        {CHG08062002-1: Vicki wants the school code to the left
                        of the bill number.}

      ClearTabs;
      SetTab(4.4, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      SetTab(6.6, pjLeft, 1.0, 0, BOXLINENone, 0);   {BANK CODE}
      Println(#9 + tb_Header.FieldByName('BankCode').Text +
              #9 + '   (' + Copy(FieldByName('SchoolDistCode').Text, 3, 4) + ') ' +
                   DezeroOnLeft(tb_Header.FieldByName('BillNo').Text));

          {>>> SPACE 1 LINE}

      Println('');

          {>>> AMOUNT DUE}

      ClearTabs;
      SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment1').AsFloat));

        {>>> SPACE 1 LINE}

      Println('');

         {>>> NAME LINE 1}

      ClearTabs;
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + NAddrArray[1]);

         {>>> DATE DUE AND NAME LINE 2}

      ClearTabs;
      SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {DATE DUE}
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + CollectionLookupTable.FieldByName('PayDate1').Text +
              #9 + NAddrArray[2]);

          {>>> REST OF NAME DATA }

      ClearTabs;
      SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      For I := 3 to 6 do
        Println(#9 +  NAddrArray[I]);

      Newpage;

    end;  {with Sender as TBaseReport do}

  CL1List.Free;
  CL2List.Free;
  CL3List.Free;
  CL4List.Free;
  CL5List.Free;
  CL6List.Free;
  CL7List.Free;

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

  Result := Quit;

end;  {PrintOneMtPleasantSchoolBill_Old}

{======================================================================}
Function PrintOneMtPleasantSchoolBill(ReportPrinter : TReportPrinter;
                                      ReportFiler : TReportFiler;
                                      ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                                      SwisSBLKey : String;
                                      FormattedSwisSBLKey : String;
                                      SchoolCodeTable,
                                      SwisCodeTable,
                                      CollectionLookupTable,
                                      tb_Header,
                                      BLGeneralTaxTable,
                                      BLSpecialDistrictTaxTable,
                                      BLExemptionTaxTable,
                                      BLSpecialFeeTaxTable,
                                      BillParameterTable : TTable;
                                      SDCodeDescList,
                                      EXCodeDescList,
                                      PropertyClassDescList,
                                      GeneralRateList,
                                      SDRateList,
                                      SpecialFeeRateList : TList;
                                      ArrearsMessage : TStringList;
                                      ThirdPartyNotificationTable : TTable;
                                      CurrentlyPrintingThirdPartyNotices : Boolean;
                                      MPSchoolBaseDetailsStart : Double;
                                      TopSectionStart : Double) : Boolean;

const
  Topmarg = 4;  {blank lines at top of page}

var
  Quit, ValidEntry : Boolean;
  LinesPrinted, Index, I, J, RateIndex : Integer;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  NAddrArray : NameAddrArray;
  TempEXCode : String;
  UniformPercentValue,
  Temprl, TempReal, STARSavings : Double;
  TempStr : String;
  EXAppliesArray : ExemptionAppliesArrayType;
  TempPtr : SDistTaxPtr;
  TempStr2 : String;
  CL1List,
  CL2List,
  CL3List,
  CL4List,
  CL5List,
  CL6List,
  CL7List : TStringList;
  BaseReportObject : TBaseReport;

begin
  Quit := False;

  SwisCodeTable.First;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

  {create string list for printing parallel non-related data }
    {across the page; eg Name/addr info in cl1list, ex data }
    {in CL2List}

  CL1List := TStringList.Create;
  CL2List := TStringList.Create;
  CL3List := TStringList.Create;
  CL4List := TStringList.Create;
  CL5List := TStringList.Create;
  CL6List := TStringList.Create;
  CL7List := TStringList.Create;

  If (ReportObjectToUse = 'P')
    then BaseReportObject := ReportPrinter
    else BaseReportObject := ReportFiler;

  with BaseReportObject, tb_Header do
    begin
         {Load the tax data  for this parcel}

      LoadTaxesForParcel(SwisSBLKey, BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         SDCodeDescList, EXCodeDescList,
                         GeneralRateList, SDRateList,
                         SpecialFeeRateList, GnTaxList,
                         SDTaxList, SpTaxList, ExTaxList, Quit);

      try
        STARSavings := GeneralTaxPtr(GnTaxList[0])^.StarSavings;
      except
        STARSavings := 0;
      end;

      SetPen(clBlack, psSolid, 1, pmCopy); { Set pen to 1 dot width }
      SetFont('MS Serif', 10);

        {print the bill on the form}

        {SCROLL DOWN TO FIRST PRINT LINE}

(*      For I := 1 to TopMarg do
        Println(''); *)

        {FXX08082001-4: Due to changes in the bill form, the top margin is
                        different.}
        {FXX07262004-1(2.07l5): Honor top section setting.}

      GotoXY(0.1, TopSectionStart);

         {>>> TAX MAP            }

         {CHG03101999-2: Make the bill printing into a seperate DLL.}
         {Need to pass in formatted parcel ID since DLL will not have access to segment layouts.}

      Bold := True;
      ClearTabs;
      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}
      PrintLn(#9 + FormattedSwisSBLKey);

        {>>> PROP LOCATION      }

      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}
      Println(#9 + GetLegalAddressFromTable(tb_Header));

          {>>> DIMENSIONS      }

      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}

      If ((FieldByName('HstdAcreage').AsFloat > 0.0) or
          (FieldByName('NonHstdAcreage').AsFloat > 0.0))
        then Println(#9 + 'ACRES: ' +
                          FormatFloat(DecimalDisplay, (FieldByName('HstdAcreage').AsFloat) +
                                                      (FieldByName('NonHstdAcreage').AsFloat)))
        else Println(#9 + 'FRONTAGE: ' +
                          FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) +
                          ', DEPTH: ' +
                          FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat)) ;

          {>>> PROPERTY CLASS }

      Println(#9 + FieldByName('PropertyClassCode').Text + ' - ' +
            UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                        PropertyClassDescList)));

          {>>> ROLL SECTION }

      Println(#9 + FieldByName('RollSection').Text);

          {>>> WARRANT DATE  }

      Println(#9 + BillParameterTable.FieldByName('WarrantDate').AsString);

          {>>> SPACES }

      GotoXY(0.1, TopSectionStart + 0.55);

      For I := 1 to 5 do
        Println('');

         {CHG01092002-1: 3rd party notices.}

     If CurrentlyPrintingThirdPartyNotices
       then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
       else GetNameAddress(tb_Header, NAddrArray);

         {fill in clist1 with name addr info}

     For I := 1 to 6 do
       CL1List.Add(NaddrArray[I]);

       {First line is hdr for exemptions.}

     CL2List.Add('');
     CL3List.Add('');
     CL4List.Add('');
     CL5List.Add('');

         {Now fill in exemptions}

      For I := 0 to (ExTaxList.Count - 1) do
        begin
          TempExCode := ExemptTaxPtr(ExTaxList[I])^.EXCode;
          EXAppliesArray := EXApplies(TempEXCode, False);

          If EXAppliesArray[EXSchool]
            then
              begin
               CL2List.Add(Take(10, ExemptTaxPtr(ExTaxList[I])^.Description));
               CL3List.Add(ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL4List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.SchoolAmount));

               CL5List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.FullValue));

             end;  {If EXAppliesArray[EXSchool]}

        end;  {For I := 0 to (ExTaxList.Count - 1) do}

          {pad out rest of exemption columns to 6 lines to match Naddr clist}

      For I := (ExTaxList.Count) to 6 do
        begin
          CL2List.Add('');
          CL3List.Add('');
          CL4List.Add('');
          CL5List.Add('');
        end;

         {>>> NAME/ADDR AND EXEMPTIONS >>>}

(*      ClearTabs;
      SetTab(1.3, pjLeft, 3.2, 0, BOXLINENone, 0);   {nAME/ADDR}
      SetTab(5.2, pjLeft, 1.0, 0, BOXLINENone, 0);   {EX DESCR}
      SetTab(6.3, pjLeft, 0.5, 0, BOXLINENone, 0);   {EX CODE}
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {eX amt} *)

         {>>> NAME/ADDR AND EXEMPTIONS >>>}
         {CHG08052007-1(2.11.2.12): Add full value of exemption.}

      ClearTabs;
      SetTab(1.3, pjLeft, 3.2, 0, BOXLINENone, 0);   {Name / addr}
      SetTab(5.0, pjLeft, 0.95, 0, BOXLINENone, 0);  {Ex description}
      SetTab(6.0, pjLeft, 0.45, 0, BOXLINENone, 0);  {Ex code}
      SetTab(6.4, pjRight, 0.8, 0, BOXLINENone, 0);  {Ex amount}
      SetTab(7.3, pjRight, 0.9, 0, BOXLINENone, 0);  {Full value}

      For I := 0 to 5 do
        Println(#9 + CL1List[I] +
                #9 + CL2List[I] +
                #9 + CL3List[I] +
                #9 + CL4List[I] +
                #9 + CL5List[I]);

       {>>> 3 SPACES }

      For I := 1 to 3 do
        Println('');

         {>>> STATE AID  }

         {Ignore the swis code for the school billing.}

      RateIndex := FindGeneralRate(-1, 'SC', '', GeneralRateList);
        {FXX08082001-5: Increase the size of the first column by 0.2 to avoid overwriting label.}

      ClearTabs;
      SetTab(1.0, pjRight, 1.7, 0, BOXLINENone, 0);   {sTATE AID}
      Println(#9 + FormatFloat(CurrencyNormalDisplay,
                               GeneralRatePointer(GeneralRateList[0])^.EstimatedStateAid));

        {>>> TAX YR, FISCAL YR  }

      ClearTabs;
      SetTab(1.0, pjRight, 1.7, 0, BOXLINENone, 0);   {tax year}
      SetTab(6.25, pjLeft, 1.5, 0, BOXLINENone, 0);   {fiscal year}
      Println(#9 + BillParameterTable.FieldByname('TaxYear').Text +
              #9 + BillParameterTable.FieldByName('FiscalYear').Text);

         {>>> BANK CODE AND BILLNO }

      Println(#9 + FieldByName('BankCode').Text + #9 +
                   DezeroOnLeft(FieldByName('BillNo').Text));

         {>>> ASSESSMENT ROLL DATE & NYS SCHL FINANCE CODE}
         {FXX08131998-2: For now, just get tax finance code from
                         school table so don't have to recalculate.}

      FindKeyOld(SchoolCodeTable, ['SchoolCode'],
                 [FieldByName('SchoolDistCode').Text]);
      TempStr2 := SchoolCodeTable.FieldByName('TaxFinanceCode').Text;

      Println(#9 + BillParameterTable.FieldByName('AssessmentRollDate').Text +
              #9 + TempStr2{FieldByName('TaxFinanceCode').Text});

        {>>> 4 SPACES }

      For I := 1 to 4 do
        Println('  ');

      LinesPrinted := 0;

           {>>> PRINT TAX LINE }

      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BOXLINENone, 0);   {purpose}
      SetTab(2.5, pjRight, 1.0, 0, BOXLINENone, 0);   {total levy}
      SetTab(3.8, pjRight, 0.5, 0, BOXLINENone, 0);   {% inc /dcr}
      SetTab(4.75, pjRight, 1.0, 0, BOXLINENone, 0);   {tax val}
      SetTab(6.0, pjRight, 1.0, 0, BOXLINENone, 0);   {tax rate}
      SetTab(7.0, pjRight, 1.2, 0, BOXLINENone, 0);   {tax amt}

      If (GnTaxList.Count > 0)
        then
          For I := 0 to (GnTaxList.Count - 1) do
            begin
              LinesPrinted := LinesPrinted + 1;

              with GeneralTaxPtr(GnTaxList[I])^,
                 GeneralRatePointer(GeneralRateList[I])^ do
                Println(#9 + Take(20, Description) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy) +
                        #9 + FormatFloat(DecimalDisplay,
                                         ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                     PriorTaxLevy)) +
                        #9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal) +
                        #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                        #9 + FormatFloat(DecimalDisplay, TaxAmount));

            end;  {For I := 0 to (GnTaxList.Count - 1) do}

        {FXX08101998-1: Print the SDs if rs 9.}
        {CHG07312003-1(2.07h): Actually, they have now switched from rs 9 and need to see the
                               special district taxes on any bill.}

      If (SDTaxList.Count > 0)
(*          (FieldByName('RollSection').Text = '9'))*)
        then
          For I := 0 to (SDTaxList.Count - 1) do
            with SDistTaxPtr(SDTaxList[I])^ do
              begin
                LinesPrinted := LinesPrinted + 1;
                FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, Index);

                TaxRate := SDRatePointer(SDRateList[Index])^.HomesteadRate;

                If (Roundoff(TaxRate, 6) > 0.000000)
                  then Println(#9 + Take(20, Description) +
                               #9 + #9 + #9 + #9 +
                               #9 + FormatFloat(DecimalDisplay, SDAmount));

              end;  { with SDistTaxPtr(SDTaxList[I])^ do}

        {CHG03161999-1: Print arrears message on bill.}
        {Do we need to print an arrears message at the end?}

      If FieldByName('ArrearsFlag').AsBoolean
        then
          begin
            Println('');
            LinesPrinted := LinesPrinted + 1;

            For I := 0 to (ArrearsMessage.Count - 1) do
              begin
                Println(#9 + ArrearsMessage[I]);
                LinesPrinted := LinesPrinted + 1;
              end;

          end;  {If FieldByName('ArrearsFlag').AsBoolean}

         {>>> 5 SPACES }
         {FXX07091998-5: Try 5 spaces instead of 4.}
         {FXX07131998-1: Go back to 4 spaces for new form.}

      For I := 1 to 2 do
      begin
        Println('');
        LinesPrinted := LinesPrinted + 1;
      end;

        {>>> STAR AMT (If applicable) }

      ClearTabs;
      SetTab(0.3, pjLeft, 6.5, 0, BOXLINENone, 0);   {purpose}
      SetTab(7.0, pjRight, 1.2, 0, BOXLINENone, 0);   {tax amt}
      If (Roundoff(STARSavings, 2) > 0)
        then
          begin
            Println(#9 + 'Your tax savings this year resulting from the New York State school tax relief (STAR) program is:' +
                    #9 + FormatFloat(DecimalDisplay, -1 * STARSavings));
            Println(#9 + '  NOTE: This year''s STAR tax savings generally may not exceed last year''s by more than 2%.');
         end
       else
         begin
           For I := 1 to 2 do
           Println('');
         end;

      Println('');
      ClearTabs;
      SetTab(5.8, pjLeft, 1.0, 0, BOXLINENone, 0);   {purpose}
      SetTab(7.0, pjRight, 1.2, 0, BOXLINENone, 0);   {tax amt}
      Println(#9 + 'TOTAL TAX DUE: ' +
              #9 + FormatFloat(DecimalDisplay, FieldByName('TotalTaxOwed').AsFloat));

      LinesPrinted := LinesPrinted + 4;

      For I := 1 to (8 - LinesPrinted) do
        Println('');

         {>>> FULL MARKET VALUE }

         {FXX07061998-2: Get the uniform % of value from the swis code table.}

     FindKeyOld(SwisCodeTable, ['SwisCode'],
                [FieldByName('SwisCode').Text]);

     UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
     TempReal := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                   FieldByName('NonHstdTotalVal').AsFloat),
                                  SwisCodeTable,
                                  tb_Header.FieldByName('PropertyClassCode').Text,
                                  ' ', True);

       {CHG08062002-3: Move the half paid amounts and due date up 1 line and
                       bring the whole section down.}

     GotoXY(1, MPSchoolBaseDetailsStart);

     For I := 1 to 4 do
     Println('');

       {FXX08132008-1(2.15.1.4): Move the rightmost column.}
       {FXX08182009-1(2.20.1.13): Move the 2 right columns 0.2 inches right.}

     ClearTabs;
     SetTab(0.3, pjLeft, 4.0, 0, BOXLINENone, 0);   { uNIF % VAL}
     SetTab(5.9, pjLeft, 1.1, 0, BOXLINENone, 0);   { 1H TAX}
     SetTab(7.3, pjLeft, 1.1, 0, BOXLINENone, 0);   { 2H TAX}
     Println(#9 + 'Full Market Value - ' +
                  BillParameterTable.FieldByName('FullMktValueDate').Text + ':   ' +
                  FormatFloat(CurrencyNormalDisplay, TempReal));

         {>>> ASSESSED VALUE }

     Println(#9 + 'Assessed Value - ' +
              BillParameterTable.FieldByName('AssessmentRollDate').Text + ':  ' +
              FormatFloat(CurrencyNormalDisplay, (FieldByName('HstdTotalVal').AsFloat +
                                             FieldByName('NonHstdTotalVal').AsFloat)));

         {>>> UNIF % VALUE  & 1H/2h AMOUNTS}

      Println(#9 + 'Uniform Pct. of Value for Assessments: ' +
             FormatFloat(DecimalDisplay, UniformPercentValue));

     For I := 1 to 2 do
     Println(''); 

     ClearTabs;
     SetTab(5.9, pjLeft, 1.1, 0, BOXLINENone, 0);   { 1H TAX}
     SetTab(7.3, pjLeft, 1.1, 0, BOXLINENone, 0);   { 2H TAX}
     Println(#9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment1').AsFloat) +
             #9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment2').AsFloat));

     For I := 1 to 3 do
       Println('');

     Println(#9 + CollectionLookupTable.FieldByName('PayDate1').Text +
             #9 + CollectionLookupTable.FieldByName('PayDate2').Text );

      For I := 1 to 3 do
         Println('');

(*               PrintStub(Sender, tb_Header, SwisSBLKey, NAddrArray,
                FieldByName('TaxPayment2').AsFloat,
                CollectionLookupTable.FieldByName('PayDate2').Text); *)

        {FXX07301998-1: Have to print stubs not in subroutine because
                        of HP8000 print problem.}
        {Print stub for 2nd half.}

        {=================  STUB 2 ====================}

      ClearTabs;
      SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   { 2h stub sbl}
      SetTab(5.75, pjLeft, 2.0, 0, BOXLINENone, 0);   {BANK CODE}
      Println(#9 + FormattedSwisSBLKey +
              #9 + '   (' + Copy(FieldByName('SchoolDistCode').Text, 3, 4) + ') ' +
                   DezeroOnLeft(tb_Header.FieldByName('BillNo').Text));

         {>>> PROP LOCATION}

      ClearTabs;
      SetTab(1.5, pjLeft, 4.0, 0, BOXLINENone, 0);   {PROP LOC}
      Println(#9 + GetLegalAddressFromTable(tb_Header));

        {>>> BILL NO, BANK CODE}
        {CHG08062002-1: Vicki wants the school code to the left
                        of the bill number.}

      ClearTabs;
      SetTab(1.2, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + tb_Header.FieldByName('BankCode').Text);


          {>>> SPACE 1 LINE}

      For I := 1 to 2 do
        Println('');

         {>>> NAME LINE 1}

      ClearTabs;
      SetTab(1.3, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      SetTab(6.1, pjLeft, 1.0, 0, BOXLINENone, 0);
      Println(#9 + NAddrArray[1] +
              #9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment2').AsFloat));

          {>>> REST OF NAME DATA }

      ClearTabs;
      SetTab(1.3, pjLeft, 1.0, 0, BOXLINENone, 0);   {DATE DUE}
      SetTab(7.4, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      For I := 2 to 6 do
      begin
        Print(#9 +  NAddrArray[I]);

        If (I = 4)
        then Println(#9 + CollectionLookupTable.FieldByName('PayDate2').Text)
        else Println('');
      end;

       {>>> 7 SPACES }

        {=================  STUB 1 ====================}

      For I := 1 to 5 do
        Println('');

        {Print stub for 1st half.}

      ClearTabs;
      SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   { 1st stub sbl}
      SetTab(5.75, pjLeft, 2.0, 0, BOXLINENone, 0);   {BANK CODE}
      Println(#9 + FormattedSwisSBLKey +
              #9 + '   (' + Copy(FieldByName('SchoolDistCode').Text, 3, 4) + ') ' +
                   DezeroOnLeft(tb_Header.FieldByName('BillNo').Text));

         {>>> PROP LOCATION}

      ClearTabs;
      SetTab(1.5, pjLeft, 4.0, 0, BOXLINENone, 0);   {PROP LOC}
      Println(#9 + GetLegalAddressFromTable(tb_Header));

        {>>> BILL NO, BANK CODE}

      ClearTabs;
      SetTab(1.2, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      Println(#9 + tb_Header.FieldByName('BankCode').Text);


          {>>> SPACE 1 LINE}

      For I := 1 to 2 do
        Println('');

         {>>> NAME LINE 1}

      ClearTabs;
      SetTab(1.3, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      SetTab(6.1, pjLeft, 1.0, 0, BOXLINENone, 0);
      Println(#9 + NAddrArray[1] +
              #9 + FormatFloat(DecimalDisplay, FieldByName('TaxPayment1').AsFloat));

          {>>> REST OF NAME DATA }

      ClearTabs;
      SetTab(1.3, pjLeft, 1.0, 0, BOXLINENone, 0);   {DATE DUE}
      SetTab(7.4, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
      For I := 2 to 6 do
      begin
        Print(#9 +  NAddrArray[I]);

        If (I = 4)
        then Println(#9 + CollectionLookupTable.FieldByName('PayDate1').Text)
        else Println('');
      end;

      Newpage;

    end;  {with Sender as TBaseReport do}

  CL1List.Free;
  CL2List.Free;
  CL3List.Free;
  CL4List.Free;
  CL5List.Free;
  CL6List.Free;
  CL7List.Free;

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

  Result := Quit;

end;  {PrintOneMtPleasantSchoolBill}


{======================================================================}
Procedure PrintOneMtPleasantTownPage(    Sender : TObject;
                                         BaseReportObject : TBaseReport;
                                         SwisSBLKey : String;
                                         FormattedSwisSBLKey : String;
                                         GnTaxList,
                                         SDTaxList,
                                         SpTaxList,
                                         ExTaxList : TList;
                                         SchoolCodeTable,
                                         SwisCodeTable,
                                         CollectionLookupTable,
                                         tb_Header,
                                         BLGeneralTaxTable,
                                         BLSpecialDistrictTaxTable,
                                         BLExemptionTaxTable,
                                         BLSpecialFeeTaxTable,
                                         BillParameterTable : TTable;
                                         SDCodeDescList,
                                         EXCodeDescList,
                                         PropertyClassDescList,
                                         GeneralRateList,
                                         SDRateList,
                                         SpecialFeeRateList : TList;
                                         ArrearsMessage : TStringList;
                                         TopSectionStart,
                                         BaseDetailsStart : Double;
                                     var PageNo,
                                         SDIndex : Integer);

const
  Topmarg = 4;  {blank lines at top of page}
  MaxTaxLinesPerPage = 26;

var
  Index, I, J, RateIndex, LinesPrinted : Integer;
  NAddrArray : NameAddrArray;
  TempEXCode : String;
  UniformPercentValue,
  Temprl, TempReal, STARSavings : Double;
  TempStr : String;
  EXAppliesArray : ExemptionAppliesArrayType;
  TempPtr : SDistTaxPtr;
  TempStr2 : String;
  CL1List,
  CL2List,
  CL3List,
  CL4List,
  CL5List,
  CL6List,
  CL7List : TStringList;
  SchoolCode : String;
  SwisCode : String;
  LastSDCode, TaxableValStr : String;

begin
  {create string list for printing parallel non-related data }
    {across the page; eg Name/addr info in cl1list, ex data }
    {in CL2List}

  CL1List := TStringList.Create;
  CL2List := TStringList.Create;
  CL3List := TStringList.Create;
  CL4List := TStringList.Create;
  CL5List := TStringList.Create;
  CL6List := TStringList.Create;
  CL7List := TStringList.Create;

  with Sender as TBaseReport do
    begin
      GotoXY(1, TopSectionStart);
      Bold := True;
      ClearTabs;
      SetTab(3.7, pjLeft, 4.0, 0, BOXLINENone, 0);   {Line}

      For I := 1 to TopMarg do
        Println('');

    end;  {with Sender as TBaseReport do}

  with Sender as TBaseReport, tb_Header do
    begin
        {print the bill on the form}
         {>>> TAX MAP}

         {CHG03101999-2: Make the bill printing into a seperate DLL.}
         {Need to pass in formatted parcel ID since DLL will not have access to segment layouts.}

      PrintLn(#9 + FormattedSwisSBLKey);

        {If this is after the 1st page, don't print loc, dim, prop class, rs, or warrant.
         Instead, print page #.}

      If (PageNo = 1)
        then
          begin
              {>>> PROP LOCATION      }

            Println(#9 + GetLegalAddressFromTable(tb_Header));

                {>>> DIMENSIONS      }

            If ((FieldByName('HstdAcreage').AsFloat > 0.0) or
                (FieldByName('NonHstdAcreage').AsFloat > 0.0))
              then Println(#9 + 'ACRES: ' +
                                FormatFloat(DecimalDisplay, (FieldByName('HstdAcreage').AsFloat) +
                                                            (FieldByName('NonHstdAcreage').AsFloat)))
              else Println(#9 + 'FRONTAGE: ' +
                                FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat) +
                                ', DEPTH: ' +
                                FormatFloat(DecimalDisplay, FieldByName('Frontage').AsFloat)) ;


                {>>> PROPERTY CLASS }

            Println(#9 + FieldByName('PropertyClassCode').Text + ' - ' +
                  UpcaseStr(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                              PropertyClassDescList)));

                {>>> ROLL SECTION }

            Println(#9 + FieldByName('RollSection').Text);

                {>>> WARRANT DATE  }

            Println(#9 + BillParameterTable.FieldByName('WarrantDate').AsString);
          end
        else
          begin
            ClearTabs;
            SetTab(7.0, pjLeft, 1.0, 0, BOXLINENone, 0);   {Page #}
            Println('');
            Println('');
            Println('');
            Println(#9 + 'Page: ' + IntToStr(PageNo));
            Println('');

          end;  {else of If (PageNo > 1)}

          {>>> SPACES }

      For I := 1 to 2 do
       Println('');

       {If this is the first page, print the name and address. Otherwise,
        print continued.}

     If (PageNo = 1)
       then
         begin
           GetNameAddress(tb_Header, NAddrArray);

               {fill in clist1 with name addr info}

           For I := 1 to 6 do
             CL1List.Add(NaddrArray[I]);
         end
       else
         begin
           CL1List.Add('*********   CONTINUED   *********');

           For I := 2 to 6 do
             CL1List.Add('');

         end;  {else of If (PageNo = 1)}

       {First line is hdr for exemptions.}

     CL2List.Add('');
     CL3List.Add('');
     CL4List.Add('');
     CL5List.Add('');

         {Now fill in exemptions}

      For I := 0 to (ExTaxList.Count - 1) do
        begin
          TempExCode := ExemptTaxPtr(ExTaxList[I])^.EXCode;
          EXAppliesArray := EXApplies(TempEXCode, False);

            {Exemption applies to town or town and county.}

          If EXAppliesArray[EXTown]
            then
              begin
               CL2List.Add(Take(10, ExemptTaxPtr(ExTaxList[I])^.Description));
               CL3List.Add(ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL4List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.TownAmount));

             end;  {If EXAppliesArray[EXSchool]}

            {If county only, print the county amount.}

          If (EXAppliesArray[EXCounty] and
              (not EXAppliesArray[EXTown]))
            then
              begin
               CL2List.Add(Take(10, ExemptTaxPtr(ExTaxList[I])^.Description));
               CL3List.Add(ExemptTaxPtr(ExTaxList[I])^.EXCode);
               CL4List.Add(FormatFloat(IntegerDisplay,
                                       ExemptTaxPtr(ExTaxList[I])^.CountyAmount));

             end;  {If EXAppliesArray[EXCounty]}

          CL5List.Add(FormatFloat(IntegerDisplay,
                                  ExemptTaxPtr(ExTaxList[I])^.FullValue));


        end;  {For I := 0 to (ExTaxList.Count - 1) do}

          {pad out rest of exemption columns to 6 lines to match Naddr clist}

      For I := (ExTaxList.Count) to 6 do
        begin
          CL2List.Add('');
          CL3List.Add('');
          CL4List.Add('');
          CL5List.Add('');
        end;

         {>>> NAME/ADDR AND EXEMPTIONS >>>}
         {CHG03902007-1(2.11.1.17): Add full value of exemption.} 

      ClearTabs;
      SetTab(1.3, pjLeft, 3.2, 0, BOXLINENone, 0);   {nAME/ADDR}
      SetTab(5.0, pjLeft, 0.95, 0, BOXLINENone, 0);   {Ex description}
      SetTab(6.0, pjLeft, 0.45, 0, BOXLINENone, 0);   {Ex code}
      SetTab(6.4, pjRight, 0.8, 0, BOXLINENone, 0);   {Ex amount}
      SetTab(7.3, pjRight, 0.9, 0, BOXLINENone, 0);   {Full value}

      For I := 0 to 5 do
        Println(#9 + CL1List[I] +
                #9 + CL2List[I] +
                #9 + CL3List[I] +
                #9 + CL4List[I] +
                #9 + CL5List[I]);

       {>>> 2 SPACES }

      For I := 1 to 2 do
        Println('  ');

        {>>> TAX YR, BillNo  }

      ClearTabs;
      SetTab(1.0, pjRight, 1.5, 0, BOXLINENone, 0);   {tax year}
      SetTab(4.3, pjLeft, 1.5, 0, BOXLINENone, 0);   {fiscal year}
      Println(#9 + BillParameterTable.FieldByname('TaxYear').Text +
              #9 + DezeroOnLeft(FieldByName('BillNo').Text));

         {>>> BANK CODE AND County state aid}

         {Strike out CITY.}
         {CHG03112002-1: Get rid of city strikeout.}

(*      ClearTabs;
      SetTab(3.57, pjLeft, 0.5, 0, BOXLINENone, 0);   {tax year}
      Print(#9 + 'XXX Cnty');*)

      ClearTabs;
      SetTab(1.0, pjRight, 1.5, 0, BOXLINENone, 0);   {tax year}
      SetTab(4.3, pjLeft, 1.5, 0, BOXLINENone, 0);   {fiscal year}

      RateIndex := FindGeneralRate(-1, 'CO', '5534', GeneralRateList);

      Println(#9 + FieldByName('BankCode').Text +
              #9 + FormatFloat(CurrencyNormalDisplay,
                               GeneralRatePointer(GeneralRateList[RateIndex])^.EstimatedStateAid));

         {>>> ASSESSMENT ROLL DATE & State aid town}
         {FXX03181999-3: Had hardcoded town outside - need to
                         send in actual swis code.}

      RateIndex := FindGeneralRate(-1, 'TO', FieldByName('SwisCode').Text, GeneralRateList);

      Println(#9 + BillParameterTable.FieldByName('AssessmentRollDate').Text +
              #9 + FormatFloat(CurrencyNormalDisplay,
                               GeneralRatePointer(GeneralRateList[RateIndex])^.EstimatedStateAid));

        {Fiscal year and school code.}

      SchoolCode := FieldByName('SchoolDistCode').Text;
      SchoolCodeTable.FindKey([SchoolCode]);

      Println(#9 + BillParameterTable.FieldByName('FiscalYear').Text +
              #9 + SchoolCode + '  (' + RTrim(SchoolCodeTable.FieldByName('SchoolName').Text) + ')');

        {>>> 4 SPACES }

      For I := 1 to 4 do
        Println('  ');

      GotoXY(1, BaseDetailsStart);

           {>>> PRINT TAX LINE }

      ClearTabs;
      SetTab(0.3, pjLeft, 2.0, 0, BOXLINENone, 0);   {purpose}
      SetTab(2.5, pjRight, 1.0, 0, BOXLINENone, 0);   {total levy}
      SetTab(3.8, pjRight, 0.5, 0, BOXLINENone, 0);   {% inc /dcr}
      SetTab(4.2, pjRight, 1.2, 0, BOXLINENone, 0);   {tax val}
      SetTab(5.5, pjRight, 0.2, 0, BOXLINENone, 0);   {extension}
      SetTab(5.8, pjRight, 1.0, 0, BOXLINENone, 0);   {tax rate}
      SetTab(7.0, pjRight, 1.1, 0, BOXLINENone, 0);   {tax amt}

      LinesPrinted := 0;

      If (PageNo = 1)
        then
          For I := 0 to (GnTaxList.Count - 1) do
            with GeneralTaxPtr(GnTaxList[I])^ do
              begin
                SwisCode := FieldByName('SwisCode').Text;

                  {Only search on the first 4 digits of swis code.}

                If (GeneralTaxType = 'CO')
                  then SwisCode := Take(4, SwisCode);

                RateIndex := FindGeneralRate(GeneralTaxPtr(GnTaxList[I])^.PrintOrder,
                                             GeneralTaxType, SwisCode, GeneralRateList);

                with GeneralRatePointer(GeneralRateList[RateIndex])^ do
                  begin
                    Println(#9 + Take(20, Description) +
                            #9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy) +
                            #9 + FormatFloat(DecimalDisplay,
                                             ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                         PriorTaxLevy)) +
                            #9 + FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal) +
                            #9 +
                            #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                            #9 + FormatFloat(DecimalDisplay, TaxAmount));

                  end;  {with GeneralRatePointer(GeneralRateList[RateIndex])^ do}

              LinesPrinted := LinesPrinted + 1;

            end;  {with GeneralTaxPtr(GnTaxList[I])^ do}

        {Print the SDs.}

      LastSDCode := '';

      while ((SDIndex <= (SDTaxList.Count - 1)) and
             (LinesPrinted < MaxTaxLinesPerPage)) do
        with SDistTaxPtr(SDTaxList[SDIndex])^ do
          begin
            FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, Index);

            TaxRate := SDRatePointer(SDRateList[Index])^.HomesteadRate;

            If (Roundoff(TaxRate, 4) > 0.0000)
              then
                begin
                  Print(#9 + Take(20, Description));

                    {Only print levy amts for 1st extension of code.}

                  with SDRatePointer(SDRateList[Index])^ do
                    If (LastSDCode <> SDistTaxPtr(SDTaxList[SDIndex])^.SDistCode)
                      then Print(#9 + FormatFloat(CurrencyDisplayNoDollarSign, CurrentTaxLevy) +
                                 #9 + FormatFloat(DecimalDisplay,
                                                  ComputeTaxLevyPercentChange(CurrentTaxLevy,
                                                                              PriorTaxLevy)))
                      else Print(#9 + #9);


                  If (SDistTaxPtr(SDTaxList[SDIndex])^.ExtCode = 'TO')
                    then TaxableValStr := FormatFloat(CurrencyDisplayNoDollarSign, SdValue)
                    else TaxableValStr := FormatFloat(DecimalDisplay, SdValue);

                  Println(#9 + TaxableValStr +
                          #9 + SDistTaxPtr(SDTaxList[SDIndex])^.ExtCode +
                          #9 + FormatFloat(ExtendedDecimalDisplay, TaxRate) +
                          #9 + FormatFloat(DecimalDisplay, SDAmount));

                  LastSDCode := SDistTaxPtr(SDTaxList[SDIndex])^.SDistCode;

                  LinesPrinted := LinesPrinted + 1;

                end;  {If (Roundoff(TaxRate, 0) > 0)}

            SDIndex := SDIndex + 1;

          end;  { with SDistTaxPtr(SDTaxList[I])^ do}

        {Now finish spacing through the tax section.}

      For I := (LinesPrinted + 1) to MaxTaxLinesPerPage do
        Println('');


      LinesPrinted := 0;

        {CHG03161999-1: Print arrears message on bill.}
        {Do we need to print an arrears message at the end?}

      If ((SDIndex > (SDTaxList.Count - 1)) and
          FieldByName('ArrearsFlag').AsBoolean)
        then
          For I := 0 to (ArrearsMessage.Count - 1) do
            begin
              Println(#9 + ArrearsMessage[I]);
              LinesPrinted := LinesPrinted + 1;
            end;

          {FXX03181999-2: Only 3 spaces.}

         {>>> 3 SPACES }

      For I := (LinesPrinted + 1) to 3 do
        Println('');

        {Amount due}

      ClearTabs;
      SetTab(6.7, pjLeft, 1.1, 0, BOXLINENone, 0);   {Amount due}
      Println(#9 + FormatFloat(DecimalDisplay, FieldByName('TotalTaxOwed').AsFloat));

         {>>> FULL MARKET VALUE }

         {FXX07061998-2: Get the uniform % of value from the swis code table.}

     SwisCodeTable.FindKey([FieldByName('SwisCode').Text]);

     UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
     TempReal := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                   FieldByName('NonHstdTotalVal').AsFloat),
                                  SwisCodeTable,
                                  tb_Header.FieldByName('PropertyClassCode').Text,
                                  ' ', True);

     ClearTabs;
     SetTab(0.3, pjLeft, 4.0, 0, BOXLINENone, 0);   {Full mkt Val}
     SetTab(6.7, pjLeft, 1.1, 0, BOXLINENone, 0);   {Amount due}
     Println(#9 + 'Full Market Value - ' +
              BillParameterTable.FieldByName('FullMktValueDate').Text + ':   ' +
              FormatFloat(CurrencyNormalDisplay, TempReal));

         {>>> ASSESSED VALUE }

     Println(#9 + 'Assessed Value - ' +
              BillParameterTable.FieldByName('AssessmentRollDate').Text + ':  ' +
              FormatFloat(CurrencyNormalDisplay, (FieldByName('HstdTotalVal').AsFloat +
                                             FieldByName('NonHstdTotalVal').AsFloat)) +
              #9 + FormatFloat(DecimalDisplay, FieldByName('TotalTaxOwed').AsFloat));

         {>>> UNIF % VALUE  & date due}

      Println(#9 + 'Uniform Pct. of Value for Assessments: ' +
             FormatFloat(DecimalDisplay, UniformPercentValue) +
             #9 + CollectionLookupTable.FieldByName('PayDate1').Text);

        {Only print the stub if this is page 1.}

      If (PageNo = 1)
        then
          begin
              {>>> 9 SPACES }

            For I := 1 to 7 do
               Println('');

              {Tax map #}

            ClearTabs;
            SetTab(1.2, pjLeft, 4.0, 0, BOXLINENone, 0);   { 2h stub sbl}
            Println(#9 + FormattedSwisSBLKey);

              {>>> 2 SPACES }

            For I := 1 to 2 do
              Println('');

               {>>> PROP LOCATION}

            ClearTabs;
            SetTab(1.2, pjLeft, 3.0, 0, BOXLINENone, 0);   {PROP LOC}
            SetTab(4.4, pjLeft, 1.0, 0, BOXLINENone, 0);   {BILL NO}
            SetTab(6.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {BANK CODE}
            Print(#9 + GetLegalAddressFromTable(tb_Header));

              {>>> BILL NO, BANK CODE}

            Println(#9 + tb_Header.FieldByName('BankCode').Text +
                    #9 + DezeroOnLeft(tb_Header.FieldByName('BillNo').Text));

              {>>> 2 SPACE}

            For I := 1 to 2 do
              Println('');

                {>>> AMOUNT DUE}

            ClearTabs;
            SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {BILL NO}
            Println(#9 + FormatFloat(DecimalDisplay, FieldByName('TotalTaxOwed').AsFloat));

              {>>> 2 SPACES }
              {CHG03092004-1(2.07l2): Move the address info up 2 lines (but not the pay date.}

(*            For I := 1 to 2 do
              Println(''); *)

               {>>> NAME LINE 1}

            ClearTabs;
            SetTab(1.2, pjRight, 1.0, 0, BOXLINENone, 0);   {BILL NO}
            SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {date/addr}

            For I := 1 to 2 do
              Println(#9 +
                      #9 + NAddrArray[I]);

            Println(#9 + CollectionLookupTable.FieldByName('PayDate1').Text +
                    #9 + NAddrArray[3]);

            ClearTabs;
            SetTab(4.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {date/addr}

            For I := 4 to 6 do
              Println(#9 + NAddrArray[I]);

          end;  {If (PageNo = 1)}

      Newpage;

    end;  {with Sender as TBaseReport do}

  CL1List.Free;
  CL2List.Free;
  CL3List.Free;
  CL4List.Free;
  CL5List.Free;
  CL6List.Free;
  CL7List.Free;

  PageNo := PageNo + 1;

end;  {PrintOneMtPleasantTownPage}

{=====================================================================}
Function PrintOneMtPleasantTownBill(ReportPrinter : TReportPrinter;
                                    ReportFiler : TReportFiler;
                                    ReportObjectToUse : Char;  {(P)rinter or (F)iler}
                                    SwisSBLKey : String;
                                    FormattedSwisSBLKey : String;
                                    SchoolCodeTable,
                                    SwisCodeTable,
                                    CollectionLookupTable,
                                    tb_Header,
                                    BLGeneralTaxTable,
                                    BLSpecialDistrictTaxTable,
                                    BLExemptionTaxTable,
                                    BLSpecialFeeTaxTable,
                                    BillParameterTable : TTable;
                                    SDCodeDescList,
                                    EXCodeDescList,
                                    PropertyClassDescList,
                                    GeneralRateList,
                                    SDRateList,
                                    SpecialFeeRateList : TList;
                                    ArrearsMessage : TStringList;
                                    ThirdPartyNotificationTable : TTable;
                                    CurrentlyPrintingThirdPartyNotices : Boolean;
                                    TopSectionStart,
                                    BaseDetailsStart : Double) : Boolean;

var
  Quit : Boolean;
  PageNo, SDIndex : Integer;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  BaseReportObject : TBaseReport;

begin
  Quit := False;
  Result := True;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

  If (ReportObjectToUse = 'P')
    then BaseReportObject := ReportPrinter
    else BaseReportObject := ReportFiler;

  with BaseReportObject do
    begin

         {Load the tax data  for this parcel}

      LoadTaxesForParcel(SwisSBLKey,
                         BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         SDCodeDescList, EXCodeDescList,
                         GeneralRateList, SDRateList,
                         SpecialFeeRateList, GnTaxList,
                         SDTaxList, SpTaxList, ExTaxList, Quit);

      PageNo := 1;
      SDIndex := 0;

      repeat
        PrintOneMtPleasantTownPage(BaseReportObject, BaseReportObject, SwisSBLKey, FormattedSwisSBLKey,
                                   GnTaxList, SDTaxList, SpTaxList, ExTaxList,
                                   SchoolCodeTable, SwisCodeTable,
                                   CollectionLookupTable,
                                   tb_Header,
                                   BLGeneralTaxTable,
                                   BLSpecialDistrictTaxTable,
                                   BLExemptionTaxTable,
                                   BLSpecialFeeTaxTable,
                                   BillParameterTable,
                                   SDCodeDescList,
                                   EXCodeDescList,
                                   PropertyClassDescList,
                                   GeneralRateList,
                                   SDRateList,
                                   SpecialFeeRateList,
                                   ArrearsMessage,
                                   TopSectionStart,
                                   BaseDetailsStart,
                                   PageNo, SDIndex);

      until (SDIndex >= (SDTaxList.Count - 1))

    end;  {with BaseReportObject do}

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

end;  {PrintOneMtPleasantTownBill}

{=====================================================================}
Function PrintOneLawrenceBill(Sender : TObject;
                              SwisSBLKey : String;
                              SwisCodeTable,
                              CollectionLookupTable,
                              tb_Header,
                              BLGeneralTaxTable,
                              BLSpecialDistrictTaxTable,
                              BLExemptionTaxTable,
                              BLSpecialFeeTaxTable,
                              BillParameterTable,
                              ParcelTable : TTable;
                              SDCodeDescList,
                              EXCodeDescList,
                              PropertyClassDescList,
                              GeneralRateList,
                              SDRateList,
                              SpecialFeeRateList : TList;
                              ArrearsMessage : TStringList;
                              ThirdPartyNotificationTable : TTable;
                              CurrentlyPrintingThirdPartyNotices : Boolean;
                              TopSectionStart : Double) : Boolean;

var
  TotalSpecialDistricts, UniformPercentValue, TempReal : Double;
  Section, Block, SubBlock, Lot, Suffix : String;
  TotalExemptions, AssessedValue : LongInt;
  Quit : Boolean;
  GnTaxList, SDTaxList, SpTaxList, ExTaxList : TList;
  I : Integer;
  NAddrArray : NameAddrArray;

begin
  Quit := False;

  GnTaxList := TList.Create;
  SDTaxList := TList.Create;
  SpTaxList := TList.Create;
  ExTaxList := TList.Create;

  with Sender as TBaseReport, tb_Header do
    begin
      LoadTaxesForParcel(SwisSBLKey,
                         BLGeneralTaxTable,
                         BLSpecialDistrictTaxTable,
                         BLExemptionTaxTable,
                         BLSpecialFeeTaxTable,
                         SDCodeDescList, EXCodeDescList,
                         GeneralRateList, SDRateList,
                         SpecialFeeRateList, GnTaxList,
                         SDTaxList, SpTaxList, ExTaxList, Quit);

      Section := DezeroOnLeft(Copy(SwisSBLKey, 7, 3));
      Block := Copy(SwisSBLKey, 13, 3);

      SubBlock := Copy(SwisSBLKey, 17, 3);
      If (Deblank(SubBlock) <> '')
        then Block := Block + '-' + SubBlock;

(*      Lot := Copy(SwisSBLKey, 20, 3);
      Suffix := Copy(SwisSBLKey, 23, 4);
      If (Deblank(Suffix) <> '')
        then Lot := Lot + '-' + Suffix;*)

        {FXX05092003-4(2.07a): Print the bank code above the parcel ID.}

      GotoXY(1, 0.75);
      Bold := False;
      ClearTabs;
      SetTab(0.6, pjLeft, 1.3, 0, BOXLINENone, 0);   {Bank code}
      Print(#9 + FieldByName('BankCode').Text);

        {FXX05092003-3(2.07a): Instead of the lot, print the lot group.}

      Lot := FieldByName('AdditionalLots').Text;

      If FieldByName('ArrearsFlag').AsBoolean
        then
          begin
            GotoXY(1, 0.75);
            Bold := True;
            ClearTabs;
            SetTab(7.0, pjLeft, 1.3, 0, BOXLINENone, 0);   {Arrears}
            SetFont('Times New Roman', 14);
            FontColor := clRed;
            Println(#9 + 'ARREARS');

          end;  {If FieldByName('ArrearsFlag').AsBoolean}

      GotoXY(1, TopSectionStart);
      Bold := True;
      SetFont('Times New Roman', 12);
      FontColor := clBlack;

      ClearTabs;
      SetTab(1.25, pjLeft, 1.0, 0, BOXLINENone, 0);   {Col 1}
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Col 2}

      UniformPercentValue := SwisCodeTable.FieldByName('UniformPercentValue').AsFloat;
      TempReal := ComputeFullValue((FieldByName('HstdTotalVal').AsFloat +
                                    FieldByName('NonHstdTotalVal').AsFloat),
                                   SwisCodeTable,
                                  FieldByName('PropertyClassCode').Text,
                                   ' ', True);
      AssessedValue := FieldByName('HstdTotalVal').AsInteger +
                       FieldByName('NonHstdTotalVal').AsInteger;

      Println(#9 + FieldByName('AccountNumber').Text +
              #9 + FormatFloat(CurrencyNormalDisplay, TempReal));

      Println(#9 +
              #9 + FormatFloat(DecimalDisplay, UniformPercentValue));

      ClearTabs;
      SetTab(0.95, pjLeft, 1.0, 0, BOXLINENone, 0);   {Col 1}
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Col 2}

      Println(#9 + Section +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, AssessedValue));

      Println(#9 + Block);

      TotalExemptions := 0;

      For I := 0 to (EXTaxList.Count - 1) do
        TotalExemptions := TotalExemptions +
                           Trunc(ExemptTaxPtr(ExTaxList[I])^.TownAmount);
      Println(#9 + Lot +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, TotalExemptions));

      ClearTabs;
      SetTab(5, pjRight, 1.75, 0, BOXLINENone, 0);   {Col 1}
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Col 2}

      TempReal := ComputeFullValue(TotalExemptions,
                                   SwisCodeTable,
                                   FieldByName('PropertyClassCode').Text,
                                   ' ', True);

      Println(#9 + 'FULL VALUE:' +
              #9 + FormatFloat(CurrencyDisplayNoDollarSign, TempReal));

      ClearTabs;
      SetTab(1.7, pjLeft, 1.5, 0, BOXLINENone, 0);   {Col 1}
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Col 2}

        {There is only 1 base tax in Lawrence.}

      Println(#9 + GetLegalAddressFromTable(tb_Header) +
              #9 + FormatFloat(CurrencyNormalDisplay,
                               GeneralTaxPtr(GnTaxList[0])^.TaxableVal));

        {FXX05092003-1(2.07a): The rate is per 100 in Lawrence.}

      Println(#9 +
              #9 + FormatFloat(ExtendedDecimalDisplay,
                               (GeneralTaxPtr(GnTaxList[0])^.TaxRate / 10)));

      ClearTabs;
      SetTab(1.125, pjLeft, 1.0, 0, BOXLINENone, 0);   {Col 1}
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Col 2}

     If CurrentlyPrintingThirdPartyNotices
       then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
       else GetNameAddress(tb_Header, NAddrArray);

        {FXX05092003-2(2.07a): Move the address down 1 line.}

      Println('');

      Print(#9 + NAddrArray[1]);
      try
        Println(#9 + FormatFloat(CurrencyDecimalDisplay,
                                 GeneralTaxPtr(GnTaxList[0])^.TaxAmount));
      except
        Println('');
      end;

        {There is only 1 SD in Lawrence - Sewer.}

      TotalSpecialDistricts := 0;
      For I := 0 to (SDTaxList.Count - 1) do
        TotalSpecialDistricts := TotalSpecialDistricts + SDistTaxPtr(SDTaxList[I])^.SDAmount;

      Print(#9 + NAddrArray[2]);
      try
        Println(#9 + FormatFloat(CurrencyDecimalDisplay, TotalSpecialDistricts));
      except
        Println('');
      end;

      Println(#9 + NAddrArray[3]);

      Println(#9 + NAddrArray[4] +
              #9 + FormatFloat(CurrencyDecimalDisplay,
                               (FieldByName('TaxPayment1').AsFloat +
                                FieldByName('TaxPayment2').AsFloat)));

      Println(#9 + NAddrArray[5]);
      Println(#9 + NAddrArray[6]);

        {Move to the second half stub.}

      For I := 1 to 8 do
        Println('');

      ClearTabs;
      SetTab(5.5, pjLeft, 1.0, 0, BOXLINENone, 0);   {Col 1}
      Println(#9 + FieldByName('AccountNumber').Text);
      Println('');

      ClearTabs;
      SetTab(5.25, pjLeft, 1.0, 0, BOXLINENone, 0);   {Col 1}
      Println(#9 + Section);
      Println(#9 + Block);
      Println(#9 + Lot);

      Println('');

      ClearTabs;
      SetTab(5.7, pjLeft, 1.0, 0, BOXLINENone, 0);   {Col 1}
      Println(#9 + FieldByName('Name1').Text);

      Println('');

      ClearTabs;
      SetTab(5.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {Col 1}
      Println(#9 + GetLegalAddressFromTable(tb_Header));

      Println('');

      ClearTabs;
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Col 1}
      Println(#9 + FormatFloat(CurrencyDecimalDisplay,
                               FieldByName('TaxPayment2').AsFloat));

        {First stub}

      For I := 1 to 10 do
        Println('');

      ClearTabs;
      SetTab(5.5, pjLeft, 1.0, 0, BOXLINENone, 0);   {Col 1}
      Println(#9 + FieldByName('AccountNumber').Text);
      Println('');

      ClearTabs;
      SetTab(5.25, pjLeft, 1.0, 0, BOXLINENone, 0);   {Col 1}
      Println(#9 + Section);
      Println(#9 + Block);
      Println(#9 + Lot);

      Println('');

      ClearTabs;
      SetTab(5.7, pjLeft, 1.0, 0, BOXLINENone, 0);   {Col 1}
      Println(#9 + FieldByName('Name1').Text);

      Println('');

      ClearTabs;
      SetTab(5.9, pjLeft, 1.0, 0, BOXLINENone, 0);   {Col 1}
      Println(#9 + GetLegalAddressFromTable(tb_Header));

      Println('');

      ClearTabs;
      SetTab(7.0, pjRight, 1.0, 0, BOXLINENone, 0);   {Col 1}
      Println(#9 + FormatFloat(CurrencyDecimalDisplay,
                               FieldByName('TaxPayment1').AsFloat));

      NewPage;

    end;  {with Sender as TBaseReport, tb_Header do}

  FreeTList(GnTaxList, SizeOf(GeneralTaxRecord));
  FreeTList(SDTaxList, SizeOf(SDistTaxRecord));
  FreeTList(SpTaxList, SizeOf(SPFeeTaxRecord));
  FreeTList(ExTaxList, SizeOf(ExemptTaxRecord));

end;  {PrintOneLawrenceBill}

{================================================================}
Procedure AddOneBrookvilleRAVEBill(SwisSBLKey : String;
                                   RAVEBillCollectionInfoTable,
                                   RAVEBillHeaderInfoTable,
                                   RAVEBillBaseSDDetailsTable,
                                   RAVEBillEXDetailsTable,
                                   tb_Header,
                                   BLGeneralTaxTable,
                                   BLExemptionTaxTable,
                                   BLSpecialDistrictTaxTable,
                                   BLSpecialFeeTaxTable,
                                   BillControlTable,
                                   BillParameterTable,
                                   SwisCodeTable : TTable;
                                   GeneralRateList,
                                   SDRateList,
                                   SpecialFeeRateList,
                                   BillControlDetailList,
                                   PropertyClassDescList,
                                   RollSectionDescList,
                                   EXCodeDescList,
                                   SDCodeDescList,
                                   SwisCodeDescList,
                                   SchoolCodeDescList,
                                   SDExtCodeDescList,
                                   GnTaxList,
                                   SDTaxList,
                                   SpTaxList,
                                   ExTaxList : TList;
                                   ArrearsMessage : TStringList);

var
  PercentChange, UniformPercentValue : Double;
  NAddrArray : NameAddrArray;
  LandValue, TotalValue, ExemptionTotal : LongInt;
  I : Integer;
  E : TObject;

begin
    {Do we need to add the overall collection info (i.e. fiscal year)?}

  If (RAVEBillCollectionInfoTable.RecordCount = 0)
    then
      with RAVEBillCollectionInfoTable do
        try
          Insert;
          FieldByName('TaxYear').Text := BillParameterTable.FieldByName('TaxYear').Text;
          FieldByName('DueDate').Text := BillControlTable.FieldByName('PayDate1').Text;
          FieldByName('WarrantDate').Text := BillParameterTable.FieldByName('WarrantDate').Text;
          FieldByName('FiscalYear').Text := BillParameterTable.FieldByName('FiscalYear').Text;
          FieldByName('EndOfCollectionDate').Text := BillParameterTable.FieldByName('EndOfCollectionDate').Text;

          try
            UniformPercentValue := PCodeRecord(SwisCodeDescList[0])^.UniformPercentOfValue;
          except
            UniformPercentValue := 0;
          end;

          FieldByName('UniformPercentValue').Text := FormatFloat(DecimalEditDisplay, UniformPercentValue);

          with GeneralRatePointer(GeneralRateList[0])^ do
            begin
              FieldByName('TotalTaxLevy').Text := FormatFloat(CurrencyNormalDisplay, CurrentTaxLevy);
              PercentChange := ((CurrentTaxLevy - PriorTaxLevy) / PriorTaxLevy) * 100;
              FieldByName('PercentChange').Text := FormatFloat(DecimalEditDisplay, PercentChange);
              FieldByName('EstimatedStateAid').Text := FormatFloat(CurrencyNormalDisplay, EstimatedStateAid);
              FieldByName('VillageRate').Text := FormatFloat(_3DecimalEditDisplay, (HomesteadRate / 10));

            end;  {with GerneralRatePointer(GeneralRateList[0])^ do}

          For I := 0 to (SDRateList.Count - 1) do
            with SDRatePointer(SDRateList[I])^ do
              begin
                If (SDistCode = 'CSWMP')
                  then FieldByName('CSFireRate').Text := FormatFloat(_3DecimalEditDisplay, (HomesteadRate / 10));

                If (SDistCode = 'NRWCH')
                  then FieldByName('ENFireRate').Text := FormatFloat(_3DecimalEditDisplay, (HomesteadRate / 10));

                If (SDistCode = 'RSLYN')
                  then FieldByName('NBFireRate').Text := FormatFloat(_3DecimalEditDisplay, (HomesteadRate / 10));

              end;  {with SDistTaxPtr(SDRateList[I])^ do}

          Post;
        except
          E := ExceptObject;
          MessageDlg('Error posting RAVE collection information.' + #13 +
                     'Exception: ' + Exception(E).Message, mtError, [mbOK], 0);
        end;

    {Now add the bill header information (i.e. the non-detail information for this bill such as mailing addr, AV.}

  with RAVEBillHeaderInfoTable do
    try
      Insert;
      FieldByName('ParcelID').Text := ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20));
      FieldByName('PropertyID').Text := tb_Header.FieldByName('AccountNumber').Text;
      FieldByName('LegalAddress').Text := GetLegalAddressFromTable(tb_Header);

      GetNameAddress(tb_Header, NAddrArray);
      FieldByName('NameAddr1').Text := NAddrArray[1];
      FieldByName('NameAddr2').Text := NAddrArray[2];
      FieldByName('NameAddr3').Text := NAddrArray[3];
      FieldByName('NameAddr4').Text := NAddrArray[4];
      FieldByName('NameAddr5').Text := NAddrArray[5];
      FieldByName('NameAddr6').Text := NAddrArray[6];

      FieldByName('LegalAddress').Text := GetLegalAddressFromTable(tb_Header);
      FieldByName('BankCode').Text := tb_Header.FieldByName('BankCode').Text;

      with tb_Header do
        begin
          LandValue := FieldByName('HstdLandVal').AsInteger + FieldByName('NonhstdLandVal').AsInteger;
          TotalValue := FieldByName('HstdTotalVal').AsInteger + FieldByName('NonhstdTotalVal').AsInteger;
        end;

      ExemptionTotal := Trunc(SumTableColumn(BLExemptionTaxTable, 'TownAmount'));

      FieldByName('LandValue').Text := FormatFloat(CurrencyDisplayNoDollarSign, LandValue);
      FieldByName('TotalValue').Text := FormatFloat(CurrencyDisplayNoDollarSign, TotalValue);
      FieldByName('ExemptionTotal').Text := FormatFloat(NoDecimalDisplay_BlankZero, ExemptionTotal);
      FieldByName('TaxableValue').Text := FormatFloat(CurrencyDisplayNoDollarSign, (TotalValue - ExemptionTotal));
      FieldByName('BankCode').Text := tb_Header.FieldByName('BankCode').Text;

      If (GnTaxList.Count > 0)
        then FieldByName('VillageTax').Text := FormatFloat(CurrencyDecimalDisplay,
                                                           GeneralTaxPtr(GnTaxList[0])^.TaxAmount);

      If (SDTaxList.Count > 0)
        then
          with SDistTaxPtr(SDTaxList[0])^ do
            begin
              If (SDistCode = 'CSWMP')
                then FieldByName('SpecialDistrictCode').Text := 'CS';

              If (SDistCode = 'NRWCH')
                then FieldByName('SpecialDistrictCode').Text := 'EN';

              If (SDistCode = 'RSLYN')
                then FieldByName('SpecialDistrictCode').Text := 'NB';

              FieldByName('SpecialDistrictTotal').Text := FormatFloat(CurrencyDecimalDisplay, SDAmount);

            end;  {with SDistTaxPtr(SDTaxList[0])^ do}

      FieldByName('TotalDue').Text := FormatFloat(CurrencyDecimalDisplay,
                                                  tb_Header.FieldByName('TotalTaxOwed').AsFloat);

      FindKeyOld(SwisCodeTable, ['SwisCode'], [Copy(SwisSBLKey, 1, 6)]);

      FieldByName('FullLandValue').AsString := FormatFloat(CurrencyDisplayNoDollarSign,
                                                           ComputeFullValue(LandValue,
                                                                            SwisCodeTable,
                                                                            tb_Header.FieldByName('PropertyClassCode').Text,
                                                                            ' ', False));

      FieldByName('FullAssessedValue').AsString := FormatFloat(CurrencyDisplayNoDollarSign,
                                                               ComputeFullValue(TotalValue,
                                                                                SwisCodeTable,
                                                                                tb_Header.FieldByName('PropertyClassCode').Text,
                                                                                ' ', False));
      FieldByName('FullExemptionValue').AsString := FormatFloat(NoDecimalDisplay_BlankZero,
                                                                ComputeFullValue(ExemptionTotal,
                                                                                 SwisCodeTable,
                                                                                 tb_Header.FieldByName('PropertyClassCode').Text,
                                                                                 ' ', False));

      Post;
    except
      E := ExceptObject;
      MessageDlg('Error posting RAVE bill header information for ' +
                 FieldByName('ParcelID').Text + '.' + #13 +
                 'Exception: ' + Exception(E).Message, mtError, [mbOK], 0);
    end;

    {Now add the base and special district details.}

    {Finally add the exemption details.}

end;  {AddOneBrookvilleRAVEBill}

{================================================================}
Function ComputeAmountDueWithPenalty(BillControlTable : TTable;
                                     TotalTaxOwed : Double;
                                     PaymentNumber : Integer) : Double;

var
  TempFieldName : String;
  PenaltyPercent : Double;

begin
  TempFieldName := 'PenPercent' + IntToStr(PaymentNumber);

  try
    PenaltyPercent := BillControlTable.FieldByName(TempFieldName).AsFloat;
    Result := TotalTaxOwed * (1 + (PenaltyPercent / 100));
  except
    Result := 0;
  end;

end;  {ComputeAmountDueWithPenalty}

{================================================================}
Function GetPenaltyPercent(BillControlTable : TTable;
                           PaymentNumber : Integer) : Double;

var
  TempFieldName : String;

begin
  TempFieldName := 'PenPercent' + IntToStr(PaymentNumber);

  try
    Result := BillControlTable.FieldByName(TempFieldName).AsFloat;
  except
    Result := 0;
  end;

end;  {GetPenaltyPercent}

{================================================================}
Procedure AddOneScarsdaleRAVEBill(SwisSBLKey : String;
                                  CollectionType : String;
                                  AssessmentYear : String;
                                  CollectionNumber : Integer;
                                  RAVEBillCollectionInfoTable,
                                  RAVEBillHeaderInfoTable,
                                  RAVELeviesTable,
                                  RAVEBillEXDetailsTable,
                                  tb_Header,
                                  BLGeneralTaxTable,
                                  BLExemptionTaxTable,
                                  BLSpecialDistrictTaxTable,
                                  BLSpecialFeeTaxTable,
                                  BillControlTable,
                                  BillParameterTable,
                                  BillArrearsTable,
                                  SchoolCodeTable,
                                  SwisCodeTable : TTable;
                                  GeneralRateList,
                                  SDRateList,
                                  SpecialFeeRateList,
                                  BillControlDetailList,
                                  PropertyClassDescList,
                                  RollSectionDescList,
                                  EXCodeDescList,
                                  SDCodeDescList,
                                  SwisCodeDescList,
                                  SchoolCodeDescList,
                                  SDExtCodeDescList,
                                  GnTaxList,
                                  SDTaxList,
                                  SpTaxList,
                                  ExTaxList : TList;
                                  ArrearsMessage : TStringList);

var
  Interest1, Interest2, Interest3,
  PercentChange, UniformPercentValue, Acreage, STARSavings,
  TotalDue_DueDate2, TotalDue_DueDate3, TotalDue_DueDate4 : Double;
  NAddrArray : NameAddrArray;
  MaxLevyLines, MaxExemptionLines,
  CurrentLevy, PriorLevy, DetailsPrinted, AssessedValue,
  LandValue, TotalValue, TempAmount, FullMarketValue : LongInt;
  I, BillPrintOrder, RateIndex : Integer;
  E : TObject;
  Done, FirstTimeThrough : Boolean;
  EXAppliesArray : ExemptionAppliesArrayType;
  AssessedValueStr, sCheckPayTo,
  STARSavingsMessage, Dimensions,
  SpecialDistrictValueString, TaxType,
  sSTARSavingsLabel, sSTARSavingsNote : String;

begin
  If _Compare(CollectionType, 'SC', coEqual)
  then MaxLevyLines := 3
  else MaxLevyLines := 5;

  MaxExemptionLines := 4;

    {Do we need to add the overall collection info (i.e. fiscal year)?}

  try
    UniformPercentValue := PCodeRecord(SwisCodeDescList[0])^.UniformPercentOfValue;
  except
    UniformPercentValue := 0;
  end;

  If (RAVEBillCollectionInfoTable.RecordCount = 0)
    then
      begin
        sCheckPayTo := 'Village of Scarsdale';

        If _Compare(CollectionType, [VillageTaxType], coEqual)
          then TaxType := 'Village Tax';

        If _Compare(CollectionType, [MunicipalTaxType], coEqual)
          then
            begin
              TaxType := 'County Tax';
              sCheckPayTo := 'Town of Scarsdale';
            end;

        If _Compare(CollectionType, SchoolTaxType, coEqual)
          then TaxType := 'School Tax';

        Interest1 := GetPenaltyPercent(BillControlTable, 2);
        Interest2 := GetPenaltyPercent(BillControlTable, 3);
        Interest3 := GetPenaltyPercent(BillControlTable, 4);

        _Locate(SchoolCodeTable, [tb_Header.FieldByName('SchoolDistCode').Text], '', []);

        _InsertRecord(RAVEBillCollectionInfoTable,
                      ['TaxYear', 'DueDate1',
                       'DueDate2', 'DueDate3',
                       'DueDate4', 'WarrantDate',
                       'FiscalYear',  'EndOfCollectionDate',
                       'UniformPercentValue',
                       'EstimatedStateAid',
                       'TaxType', 'BillingDate',
                       'NYFinanceCode', 'EndOfNoPenalty_Date',
                       'AssessmentYear',
                       'EndOfNoPenalty_DateLong',
                       'DropboxEndDate',
                       'Interest1',
                       'Interest2',
                       'Interest3',
                       'CheckPayTo'],
                      [BillParameterTable.FieldByName('TaxYear').Text, BillControlTable.FieldByName('PayDate1').Text,
                       BillControlTable.FieldByName('PayDate2').Text, BillControlTable.FieldByName('PayDate3').Text,
                       BillControlTable.FieldByName('PayDate4').Text, BillParameterTable.FieldByName('WarrantDate').Text,
                       BillParameterTable.FieldByName('FiscalYear').Text, BillParameterTable.FieldByName('EndOfCollectionDate').Text,
                       FormatFloat(DecimalEditDisplay, UniformPercentValue),
                       FormatFloat(CurrencyNormalDisplay, GeneralRatePointer(GeneralRateList[0])^.EstimatedStateAid),
                       TaxType, BillParameterTable.FieldByName('BillingDate').Text,
                       SchoolCodeTable.FieldByName('TaxFinanceCode').Text,
                       BillParameterTable.FieldByName('EndOfNoPenalty_Date').Text,
                       AssessmentYear,
                       FormatDateTime(LongDateAbbreviatedFormat, BillParameterTable.FieldByName('EndOfNoPenalty_Date').AsDateTime),
                       BillParameterTable.FieldByName('DropboxEndDate').Text,
                       FormatFloat(IntegerDisplay, Interest1) + '% Penalty',
                       FormatFloat(IntegerDisplay, Interest2) + '% Penalty',
                       FormatFloat(IntegerDisplay, Interest3) + '% Penalty',
                       sCheckPayTo], []);

      end;  {If (RAVEBillCollectionInfoTable.RecordCount = 0)}

    {Now add the bill header information (i.e. the non-detail information for this bill such as mailing addr, AV.}

  with tb_Header do
    begin
      GetNameAddress(tb_Header, NAddrArray);
      LandValue := FieldByName('HstdLandVal').AsInteger + FieldByName('NonhstdLandVal').AsInteger;
      TotalValue := FieldByName('HstdTotalVal').AsInteger + FieldByName('NonhstdTotalVal').AsInteger;

      TotalDue_DueDate2 := ComputeAmountDueWithPenalty(BillControlTable, FieldByName('TotalTaxOwed').AsFloat, 2);
      TotalDue_DueDate3 := ComputeAmountDueWithPenalty(BillControlTable, FieldByName('TotalTaxOwed').AsFloat, 3);
      TotalDue_DueDate4 := ComputeAmountDueWithPenalty(BillControlTable, FieldByName('TotalTaxOwed').AsFloat, 4);

      Dimensions := '';
      Acreage := FieldByName('HstdAcreage').AsFloat + FieldByName('NonHstdAcreage').AsFloat;

      If (Acreage > 0)
        then Dimensions := FormatFloat(DecimalEditDisplay, Acreage) + ' ac'
        else
          If ((FieldByName('Frontage').AsFloat > 0) or
              (FieldByName('Depth').AsFloat > 0))
            then Dimensions := FormatFloat(DecimalEditDisplay, FieldByName('Frontage').AsFloat) + ' x ' +
                               FormatFloat(DecimalEditDisplay, FieldByName('Depth').AsFloat);

     FullMarketValue := Trunc(ComputeFullValue(TotalValue, SwisCodeTable,
                                               FieldByName('PropertyClassCode').Text,
                                               ' ', True));

      STARSavings := 0;
      STARSavingsMessage := '';

      If _Compare(GnTaxList.Count, 0, coGreaterThanOrEqual)
        then
          begin
            STARSavings := GeneralTaxPtr(GnTaxList[0])^.STARSavings;

            If _Compare(STARSavings, 0, coGreaterThan)
              then
              begin
                STARSavingsMessage := 'Your tax savings this year resulting from the New York' +
                                      ' State School Tax Relief (STAR) program is: ' +
                                      FormatFloat(CurrencyDecimalDisplay, STARSavings);
                sSTARSavingsLabel := 'TOTAL SAVINGS DUE TO THE STAR EXEMPTION:';
                sSTARSavingsNote := 'Note: This year' + '''' + 's STAR tax savings generally may not exceed last year' + '''' + 's by more than 2%.';
              end;

          end;  {If _Compare(GnTaxList.Count, 0, coGreaterThanOrEqual)}

      _InsertRecord(RAVEBillHeaderInfoTable,
                    ['ParcelID', 'SwisCode',
                     'SchoolCode', 'SchoolName',
                     'AccountNumber', 'LegalAddress', 'BillNumber',
                     'PropertyClassCode',
                     'PropertyClassDesc',
                     'Dimensions', 'RollSection',
                     'NameAddr1', 'NameAddr2', 'NameAddr3', 'NameAddr4', 'NameAddr5', 'NameAddr6',
                     'BankCode', 'LandValue', 'AssessedValue',
                     'FullMarketValue',
                     'CASSBarCode',
                     'STARSavings',
                     'TotalDue',
                     'TotalDue_DueDate2',
                     'TotalDue_DueDate3',
                     'TotalDue_DueDate4',
                     'STARSavingsLabel',
                     'STARSavingsNote'],
                    [ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)), Copy(SwisSBLKey, 1, 6),
                     FieldByName('SchoolDistCode').Text, Trim(SchoolCodeTable.FieldByName('SchoolName').Text),
                     FieldByName('AccountNumber').AsString, GetLegalAddressFromTable(tb_Header), FieldByName('BillNo').AsString,
                     FieldByName('PropertyClassCode').AsString,
                     ANSIUpperCase(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                          PropertyClassDescList)),
                     Dimensions, FieldByName('RollSection').AsString,
                     NAddrArray[1], NAddrArray[2], NAddrArray[3], NAddrArray[4], NAddrArray[5], NAddrArray[6],
                     FieldByName('BankCode').AsString, FormatFloat(CurrencyDisplayNoDollarSign, LandValue),
                     FormatFloat(CurrencyDisplayNoDollarSign, TotalValue),
                     FormatFloat(CurrencyDisplayNoDollarSign, FullMarketValue),
                     FieldByName('CASSBarCode').Text,
                     FormatFloat(DecimalDisplay_BlankZero, STARSavings),
                     FormatFloat(DecimalDisplay, tb_Header.FieldByName('TotalTaxOwed').AsFloat),
                     FormatFloat(DecimalDisplay, TotalDue_DueDate2),
                     FormatFloat(DecimalDisplay, TotalDue_DueDate3),
                     FormatFloat(DecimalDisplay, TotalDue_DueDate4),
                     sSTARSavingsLabel,
                     sSTARSavingsNote], [irSuppressPost]);

      If FieldByName('ArrearsFlag').AsBoolean
        then RAVEBillHeaderInfoTable.FieldByName('DelinquentMessage').Assign(BillArrearsTable.FieldByName('ArrearsMessage'));

      RAVEBillHeaderInfoTable.Post;

    end;  {with tb_Header do}

  BillPrintOrder := RAVEBillHeaderInfoTable.FieldByName('PrintOrder').AsInteger;
  DetailsPrinted := 0;

    {Now add the base and special district details.}

  For I := 0 to (GnTaxList.Count - 1) do
    with GeneralTaxPtr(GnTaxList[I])^ do
      begin
        Inc(DetailsPrinted);
        RateIndex := FindGeneralRate(PrintOrder, GeneralTaxType,
                                     tb_Header.FieldByName('SwisCode').Text, GeneralRateList);

        _InsertRecord(RAVELeviesTable,
                      ['PrintOrder', 'LineOrder', 'LevyDescription',
                       'TotalTaxLevy',
                       'PercentChange',
                       'AssessedValue',
                       'TaxableValue',
                       'TaxRate',
                       'TaxAmount'],
                      [BillPrintOrder, (I + 1), Description,
                       FormatFloat(CurrencyDisplayNoDollarSign,
                                   GeneralRatePointer(GeneralRateList[RateIndex])^.CurrentTaxLevy),
                       FormatFloat(DecimalDisplay,
                                   ComputeTaxLevyPercentChange(GeneralRatePointer(GeneralRateList[RateIndex])^.CurrentTaxLevy,
                                                               GeneralRatePointer(GeneralRateList[RateIndex])^.PriorTaxLevy)),
                       RAVEBillHeaderInfoTable.FieldByName('AssessedValue').AsString,
                       FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal),
                       FormatFloat(ExtendedDecimalDisplay, TaxRate),
                       FormatFloat(DecimalDisplay, TaxAmount)], []);

      end;  {with GeneralTaxPtr(GnTaxList[I])^ do}

  For I := 0 to (SDTaxList.Count - 1) do
    with SDistTaxPtr(SDTaxList[I])^ do
      begin
        Inc(DetailsPrinted);
        FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, RateIndex);

        TaxRate := SDRatePointer(SDRateList[RateIndex])^.HomesteadRate;
        CurrentLevy := Trunc(SDRatePointer(SDRateList[RateIndex])^.CurrentTaxLevy);
        PriorLevy := Trunc(SDRatePointer(SDRateList[RateIndex])^.PriorTaxLevy);

        If (Roundoff(TaxRate, 6) > 0.000000)
          then
            begin
              AssessedValueStr := StringReplace(RAVEBillHeaderInfoTable.FieldByName('AssessedValue').AsString,
                                                '$', '', [rfReplaceAll]);
              AssessedValueStr := StringReplace(AssessedValueStr, ',', '', [rfReplaceAll]);
              try
                AssessedValue := StrToInt(AssessedValueStr);
              except
                AssessedValue := 0;
              end;

              If _Compare(ExtCode, SDistEcTO, coEqual)
                then SpecialDistrictValueString := FormatFloat(CurrencyDisplayNoDollarSign, SdValue)
                else
                  begin
                    SpecialDistrictValueString := FormatFloat(DecimalDisplay, SdValue);
                    AssessedValue := 0;
                  end;

              _InsertRecord(RAVELeviesTable,
                            ['PrintOrder', 'LineOrder', 'LevyDescription',
                             'TotalTaxLevy',
                             'PercentChange',
                             'AssessedValue',
                             'TaxableValue', 'TaxRate', 'TaxAmount'],
                            [BillPrintOrder, (I + 1), Description,
                             FormatFloat(NoDecimalDisplay_BlankZero, CurrentLevy),
                             FormatFloat(DecimalEditDisplay_BlankZero,
                                         ComputeTaxLevyPercentChange(CurrentLevy, PriorLevy)),
                             FormatFloat(NoDecimalDisplay_BlankZero, AssessedValue),
                             SpecialDistrictValueString,
                             FormatFloat(ExtendedDecimalDisplay, TaxRate),
                             FormatFloat(DecimalDisplay, SDAmount)], []);

            end;  {If (Roundoff(TaxRate, 6) > 0.000000)}

      end;  {with SDistTaxPtr(SDTaxList[I])^ do}

  For I := (DetailsPrinted + 1) to MaxLevyLines do
    _InsertRecord(RAVELeviesTable, ['PrintOrder', 'LineOrder'], [BillPrintOrder, I], []);

    {Finally add the exemption details.}

  For I := 0 to (EXTaxList.Count - 1) do
    with ExemptTaxPtr(ExTaxList[I])^ do
      begin
        EXAppliesArray := EXApplies(EXCode, False);

        If _Compare(CollectionType, SchoolTaxType, coEqual)
          then TempAmount := Trunc(SchoolAmount)
          else
            If EXAppliesArray[EXTown]
              then TempAmount := Trunc(TownAmount)
              else TempAmount := Trunc(CountyAmount);

        _InsertRecord(RAVEBillEXDetailsTable,
                      ['PrintOrder', 'ExemptionCode', 'ExemptionDescription', 'TaxPurpose',
                       'Amount', 'FullValue'],
                      [BillPrintOrder, EXCode, Description, GetExemptionTypeDescription(EXCode),
                       FormatFloat(CurrencyDisplayNoDollarSign, TempAmount),
                       FormatFloat(CurrencyDisplayNoDollarSign, FullValue)], []);

      end;  {with ExemptTaxPtr(ExTaxList[I])^ do}

  For I := (EXTaxList.Count + 1) to MaxExemptionLines do
    _InsertRecord(RAVEBillEXDetailsTable, ['PrintOrder', 'LineOrder'], [BillPrintOrder, I], []);

end;  {AddOneScarsdaleRAVEBill}

{================================================================}
Procedure AddOneStandardRAVEBill(SwisSBLKey : String;
                                 CollectionType : String;
                                 AssessmentYear : String;
                                 CollectionNumber : Integer;
                                 RAVEBillCollectionInfoTable,
                                 RAVEBillHeaderInfoTable,
                                 RAVELeviesTable,
                                 RAVEBillEXDetailsTable,
                                 RAVELevyChangeTable,
                                 tb_Header,
                                 tb_GeneralTaxes,
                                 tb_Exemptions,
                                 tb_SpecialDistricts,
                                 tb_SpecialFees,
                                 BillControlTable,
                                 BillParameterTable,
                                 BillArrearsTable,
                                 SchoolCodeTable,
                                 SwisCodeTable,
                                 LastYearGeneralTaxTable,
                                 LastYearSpecialDistrictTaxTable,
                                 GeneralTaxRateTable,
                                 ThirdPartyNotificationTable,
                                 AssessmentYearControlTable : TTable;
                                 CurrentlyPrintingThirdPartyNotices : Boolean;
                                 GeneralRateList,
                                 SDRateList,
                                 SpecialFeeRateList,
                                 BillControlDetailList,
                                 PropertyClassDescList,
                                 RollSectionDescList,
                                 EXCodeDescList,
                                 SDCodeDescList,
                                 SwisCodeDescList,
                                 SchoolCodeDescList,
                                 SDExtCodeDescList,
                                 GnTaxList,
                                 SDTaxList,
                                 SpTaxList,
                                 ExTaxList : TList;
                                 ArrearsMessage : TStringList;
                                 BillsPrinted : LongInt;
                                 TaxRatePerHundred : Boolean;
                                 PadDetailLines : Boolean;
                                 OldSwisSBLKey : String;
                                 bDisplayCommasInExemptionAmount : Boolean;
                                 sTaxRateDisplayFormat : String;
                                 bUserDefinedPrintOrder : Boolean;
                                 bIncludeOrCurrentOwner : Boolean);

var
  TotalBase, TotalFee,
  MainTaxRate, PercentChange, TotalPriorTax,
  UniformPercentValue, Acreage, PriorTax,
  _TaxRate, PriorTaxRate, TaxRatePercentChange, STARSavings,
  fPercentChange, MainLevyPercentChange : Double;
  NAddrArray, LegalNameAddressArray : NameAddrArray;
  FullExemptionValue, EstimatedStateAidCounty,
  CurrentLevy, PriorLevy, DetailsPrinted, _EstimatedStateAid,
  LandValue, TotalValue, TempAmount, FullMarketValue : LongInt;
  I, BillPrintOrder, RateIndex, Index, iTotalExemptions,
  iSeniorExemptionAmount, iVeteransExemptionAmount, MainTaxLevy, iLineOrder : Integer;
  E : TObject;
  Done, FirstTimeThrough : Boolean;
  EXAppliesArray : ExemptionAppliesArrayType;
  TotalDueString, Dimensions, Scanline,
  STARSavingsMessage, TaxCode, PriorTaxYear,
  SpecialDistrictValueString, TaxType,
  sDisplayFormat, AdditionalLotsString, sTaxTypeIndicator : String;
  SBLRec : SBLRecord;

const
  MaxLevyLines = 4;
  MaxExemptionLines = 3;

begin
  If _Compare(sTaxRateDisplayFormat, coBlank)
    then sTaxRateDisplayFormat := ExtendedDecimalDisplay;

  MainTaxRate := 0;
  MainTaxLevy := 0;
  MainLevyPercentChange := 0;
  TotalPriorTax := 0;

    {Do we need to add the overall collection info (i.e. fiscal year)?}

  try
    UniformPercentValue := PCodeRecord(SwisCodeDescList[0])^.UniformPercentOfValue;
  except
    UniformPercentValue := 0;
  end;

  GetLegalNameAddress(tb_Header, SwisCodeTable,
                      LegalNameAddressArray, True);

  If (RAVEBillCollectionInfoTable.RecordCount = 0)
    then
      begin
        If (_Compare(CollectionType, [CountyTaxType, MunicipalTaxType], coEqual) and
            _Compare(CollectionNumber, 2, coEqual))
          then TaxType := 'County Tax';

        If (_Compare(CollectionType, [TownTaxType, MunicipalTaxType], coEqual) and
            _Compare(CollectionNumber, 1, coEqual))
          then TaxType := 'City Tax';

        If _Compare(CollectionType, SchoolTaxType, coEqual)
          then TaxType := 'School Tax';

        _Locate(SchoolCodeTable, [tb_Header.FieldByName('SchoolDistCode').Text], '', []);

        PriorTaxYear := BillParameterTable.FieldByName('TaxYear').AsString;

        If _Compare(PriorTaxYear, coNotBlank)
          then
            If _Compare(Pos('-', PriorTaxYear), 0, coGreaterThan)
              then
                begin
                  PriorTaxYear := Copy(PriorTaxYear, 1, 4);
                  PriorTaxYear := IncrementNumericString(PriorTaxYear, -1) + '-' + PriorTaxYear;
                end
              else PriorTaxYear := IncrementNumericString(PriorTaxYear, -1);

          {Get the state aid amounts.}

        EstimatedStateAidCounty := 0;
        _EstimatedStateAid := 0;

        For I := 0 to (GeneralRateList.Count - 1) do
          with GeneralRatePointer(GeneralRateList[I])^ do
            begin
              If (GeneralTaxType = CountyTaxType)
                then
                  begin
                    try
                      EstimatedStateAidCounty := Trunc(EstimatedStateAid);
                    except
                    end;

                  end;  {If (GeneralTaxType = CountyTaxType)}

              If (_Compare(GeneralTaxType, [TownTaxType, VillageTaxType, MunicipalTaxType,
                                            SchoolTaxType], coEqual) and
                  _Compare(EstimatedStateAid, 0, coGreaterThan))
                then
                  begin
                    try
                      _EstimatedStateAid := Trunc(EstimatedStateAid);
                    except
                    end;

                  end;  {If _Compare(GeneralTaxType,...}

              If _Compare(_EstimatedStateAid, 0, coEqual)
                then _EstimatedStateAid := EstimatedStateAidCounty;

            end;  {with GeneralRatePointer(GeneralRateList[I])^ do}

        _InsertRecord(RAVEBillCollectionInfoTable,
                      ['TaxYear', 'DueDate1',
                       'DueDate2',
                       'DueDate3',
                       'DueDate4',
                       'WarrantDate',
                       'FiscalYear',
                       'UniformPercentValue',
                       'EstimatedStateAid',
                       'TaxType',
                       'PriorTaxYear',
                       'NYFinanceCode',
                       'AssessmentYear',
                       'ValuationDate',
                       'ValuationDateLong',
                       'DueDate1Long',
                       'DueDate2Long',
                       'DueDate3Long',
                       'DueDate4Long',
                       'BillingDate',
                       'EstimatedStateAidCounty',
                       'EndOfNoPenalty_Date',
                       'TaxableStatusDate',
                       'LienDate'],
                      [BillParameterTable.FieldByName('TaxYear').Text,
                       BillControlTable.FieldByName('PayDate1').Text,
                       BillControlTable.FieldByName('PayDate2').Text,
                       BillControlTable.FieldByName('PayDate3').Text,
                       BillControlTable.FieldByName('PayDate4').Text,
                       BillParameterTable.FieldByName('WarrantDate').Text,
                       BillParameterTable.FieldByName('FiscalYear').Text,
                       FormatFloat(DecimalEditDisplay, UniformPercentValue),
                       FormatFloat(CurrencyNormalDisplay, _EstimatedStateAid),
                       ANSIUpperCase(TaxType),
                       PriorTaxYear,
                       SchoolCodeTable.FieldByName('TaxFinanceCode').Text,
                       GlblThisYear,
                       BillParameterTable.FieldByName('FullMktValueDate').AsString,
                       FormatDateTime(LongDateAbbreviatedFormat, BillParameterTable.FieldByName('FullMktValueDate').AsDateTime),
                       FormatDateTime(LongDateAbbreviatedFormat, BillControlTable.FieldByName('PayDate1').AsDateTime),
                       FormatDateTime(LongDateAbbreviatedFormat, BillControlTable.FieldByName('PayDate2').AsDateTime),
                       FormatDateTime(LongDateAbbreviatedFormat, BillControlTable.FieldByName('PayDate3').AsDateTime),
                       FormatDateTime(LongDateAbbreviatedFormat, BillControlTable.FieldByName('PayDate4').AsDateTime),
                       BillParameterTable.FieldByName('BillingDate').AsString,
                       FormatFloat(CurrencyNormalDisplay, EstimatedStateAidCounty),
                       BillParameterTable.FieldByName('EndOfNoPenalty_Date').AsString,
                       AssessmentYearControlTable.FieldByName('TaxableStatusDate').AsString,
                       BillParameterTable.FieldByName('LienDate').AsString],
                       []);

      end;  {If (RAVEBillCollectionInfoTable.RecordCount = 0)}

    {Now add the bill header information (i.e. the non-detail information for this bill such as mailing addr, AV.}

  with tb_Header do
    begin
      If CurrentlyPrintingThirdPartyNotices
        then GetNameAddress(ThirdPartyNotificationTable, NAddrArray)
        else
          If bIncludeOrCurrentOwner
          then GetNameAddress_OrCurrentOwner(tb_Header, NAddrArray)
          else GetNameAddress(tb_Header, NAddrArray);

      _Locate(SchoolCodeTable, [FieldByName('SchoolDistCode').Text], '', []);
      LandValue := FieldByName('HstdLandVal').AsInteger + FieldByName('NonhstdLandVal').AsInteger;
      TotalValue := FieldByName('HstdTotalVal').AsInteger + FieldByName('NonhstdTotalVal').AsInteger;

      Dimensions := '';
      Acreage := FieldByName('HstdAcreage').AsFloat + FieldByName('NonHstdAcreage').AsFloat;

      If (Acreage > 0)
        then Dimensions := FormatFloat(DecimalEditDisplay, Acreage) + ' ac'
        else
          If ((FieldByName('Frontage').AsFloat > 0) or
              (FieldByName('Depth').AsFloat > 0))
            then Dimensions := FormatFloat(DecimalEditDisplay, FieldByName('Frontage').AsFloat) + ' x ' +
                               FormatFloat(DecimalEditDisplay, FieldByName('Depth').AsFloat);

      FullMarketValue := Trunc(ComputeFullValue(TotalValue, SwisCodeTable,
                                                FieldByName('PropertyClassCode').Text,
                                                ' ', True));

      TotalDueString := FormatFloat(CurrencyDecimalDisplay, tb_Header.FieldByName('TotalTaxOwed').AsFloat);

      AdditionalLotsString := FieldByName('AdditionalLots').AsString;

      If _Compare(AdditionalLotsString, coNotBlank)
        then AdditionalLotsString := 'ADDL LOTS: ' + AdditionalLotsString;

      STARSavings := 0;
      STARSavingsMessage := '';

      If _Compare(GnTaxList.Count, 0, coGreaterThan)
        then
          begin
            STARSavings := GeneralTaxPtr(GnTaxList[0])^.STARSavings;

            If _Compare(STARSavings, 0, coGreaterThan)
              then STARSavingsMessage := 'Your tax savings this year resulting from the New York' +
                                         ' State School Tax Relief (STAR) program is: ' +
                                         FormatFloat(CurrencyDecimalDisplay, STARSavings);

          end;  {If _Compare(GnTaxList.Count, 0, coGreaterThanOrEqual)}

      If (_Compare(CollectionType, [CountyTaxType, MunicipalTaxType], coEqual) and
          _Compare(CollectionNumber, 2, coEqual))
        then sTaxTypeIndicator := '2';

      If (_Compare(CollectionType, [TownTaxType, MunicipalTaxType], coEqual) and
          _Compare(CollectionNumber, 1, coEqual))
        then sTaxTypeIndicator := '1';

      If _Compare(CollectionType, SchoolTaxType, coEqual)
        then sTaxTypeIndicator := '3';

      Scanline := FieldByName('BillNo').AsString + ' ';
     (* Scanline := Copy(SwisSBLKey, 7, 20) + ' '; *)

      Scanline := Scanline +
                  ShiftRightAddZeroes(IntToStr(Round(FieldByName('TaxPayment1').AsFloat * 100)), 12) + ' ' +
                  sTaxTypeIndicator;

(*      Scanline := Scanline +
                  ShiftRightAddZeroes(IntToStr(Round(FieldByName('TotalTaxOwed').AsFloat * 100)), 12); *)
      Scanline := Scanline + ' ' +
                  CalculateCheckDigit_Mod10_7532(StringReplace(Scanline, ' ', '', [rfReplaceAll]));

      TaxCode := '';

      try
        Index := Pos(':', FieldByName('PropDescr3').AsString);

        If _Compare(Index, 0, coGreaterThan)
          then TaxCode := Trim(Copy(FieldByName('PropDescr3').AsString, (Index + 1), 200));

      except
      end;

      TotalBase := 0;

      For I := 0 to (SDTaxList.Count - 1) do
        with SDistTaxPtr(SDTaxList[I])^ do
          TotalBase := TotalBase + SDAmount;

      For I := 0 to (GnTaxList.Count - 1) do
        with GeneralTaxPtr(GnTaxList[I])^ do
          TotalBase := TotalBase + TaxAmount;

      _SetRange(tb_SpecialFees, [SwisSBLKey, 0], [SwisSBLKey, 9999], '', []);
      TotalFee := SumTableColumn(tb_SpecialFees, 'TaxAmount');

      iTotalExemptions := 0;
      For I := 0 to (EXTaxList.Count - 1) do
        with ExemptTaxPtr(ExTaxList[I])^ do
        begin
          EXAppliesArray := EXApplies(EXCode, False);

          If EXAppliesArray[EXTown]
            then TempAmount := Trunc(TownAmount)
            else
              If EXAppliesArray[EXCounty]
                then TempAmount := Trunc(CountyAmount)
                else TempAmount := Trunc(SchoolAmount);

          iTotalExemptions := iTotalExemptions + TempAmount;

        end;  {with ExemptTaxPtr(ExTaxList[I])^ do}

      SBLRec := ExtractSBLFromSBLKey(FieldByName('SBLKey').AsString);

      _InsertRecord(RAVEBillHeaderInfoTable,
                    ['ParcelID', 'PrintOrder', 'SwisCode',
                     'SchoolCode', 'SchoolName',
                     'AccountNumber', 'LegalAddress', 'BillNumber',
                     'PropertyClassCode',
                     'PropertyClassDesc',
                     'Dimensions', 'RollSection', 'AdditionalLots',
                     'NameAddr1', 'NameAddr2', 'NameAddr3', 'NameAddr4', 'NameAddr5', 'NameAddr6',
                     'BankCode', 'LandValue', 'AssessedValue',
                     'FullMarketValue',
                     'TotalDue',
                     'TotalDue_DueDate1',
                     'TotalDue_DueDate2',
                     'TotalDue_DueDate3',
                     'TotalDue_DueDate4',
                     'PropertyNameAddr1', 'PropertyNameAddr2',
                     'PropertyNameAddr3', 'PropertyNameAddr4',
                     'STARSavings', 'Scanline',
                     'STARSavingsMessage', 'TaxCode',
                     'OldParcelID', 'TownName',
                     'TotalBase',
                     'TotalFee',
                     'ScannerBarCode',
                     'TotalExemptions',
                     'TaxCode',
                     'MasticDistrict',
                     'MasticSection',
                     'MasticBlock',
                     'MasticLot'],
                    [ConvertSBLOnlyToDashDot(Copy(SwisSBLKey, 7, 20)), BillsPrinted, Copy(SwisSBLKey, 1, 6),
                     DezeroOnLeft(FieldByName('SchoolDistCode').Text), Trim(SchoolCodeTable.FieldByName('SchoolName').Text),
                     FieldByName('AccountNumber').AsString, GetLegalAddressFromTable(tb_Header), FieldByName('BillNo').AsString,
                     FieldByName('PropertyClassCode').AsString,
                     ANSIUpperCase(GetDescriptionFromList(FieldByName('PropertyClassCode').Text,
                                                          PropertyClassDescList)),
                     Dimensions, FieldByName('RollSection').AsString, AdditionalLotsString,
                     NAddrArray[1], NAddrArray[2], NAddrArray[3], NAddrArray[4], NAddrArray[5], NAddrArray[6],
                     FieldByName('BankCode').AsString, FormatFloat(CurrencyDisplayNoDollarSign, LandValue),
                     FormatFloat(CurrencyDisplayNoDollarSign, TotalValue),
                     FormatFloat(CurrencyNormalDisplay, FullMarketValue),
                     FormatFloat(CurrencyDecimalDisplay, FieldByName('TotalTaxOwed').AsFloat),
                     FormatFloat(CurrencyDecimalDisplay, FieldByName('TaxPayment1').AsFloat),
                     FormatFloat(CurrencyDecimalDisplay, FieldByName('TaxPayment2').AsFloat),
                     FormatFloat(CurrencyDecimalDisplay, FieldByName('TaxPayment3').AsFloat),
                     FormatFloat(CurrencyDecimalDisplay, FieldByName('TaxPayment4').AsFloat),
                     LegalNameAddressArray[1], LegalNameAddressArray[2],
                     LegalNameAddressArray[3], LegalNameAddressArray[4],
                     FormatFloat(CurrencyDecimalDisplay, STARSavings), Scanline,
                     STARSavingsMessage, TaxCode,
                     ConvertSwisSBLToOldDashDotNoSwis(OldSwisSBLKey,
                                                      AssessmentYearControlTable),
                     SwisCodeTable.FieldByName('MunicipalityName').AsString,
                     FormatFloat(CurrencyDecimalDisplay, TotalBase),
                     FormatFloat(CurrencyDecimalDisplay, TotalFee),
                     FieldByName('BillNo').AsString,
                     FormatFloat(IntegerDisplay, iTotalExemptions),
                     TaxCode,
                     SBLRec.Section,
                     SBLRec.Block,
                     SBLRec.Lot,
                     SBLRec.Sublot + '.' + SBLRec.Suffix],
                     [irSuppressPost]);

      If FieldByName('ArrearsFlag').AsBoolean
        then RAVEBillHeaderInfoTable.FieldByName('DelinquentMessage').Assign(BillArrearsTable.FieldByName('ArrearsMessage'));

    end;  {with tb_Header do}

  BillPrintOrder := BillsPrinted;
  DetailsPrinted := 0;

    {Now add the base and special district details.}

  For I := 0 to (GnTaxList.Count - 1) do
    with GeneralTaxPtr(GnTaxList[I])^ do
      begin
        Inc(DetailsPrinted);
        RateIndex := FindGeneralRate(PrintOrder, GeneralTaxType,
                                     tb_Header.FieldByName('SwisCode').Text, GeneralRateList);

        If TaxRatePerHundred
          then _TaxRate := TaxRate / 10
          else _TaxRate := TaxRate;

        PriorTaxRate := 0;
        TaxRatePercentChange := 0;

        fPercentChange := ComputePercent(GeneralRatePointer(GeneralRateList[RateIndex])^.CurrentTaxLevy,
                                         GeneralRatePointer(GeneralRateList[RateIndex])^.PriorTaxLevy);

        If _Compare(I, 0, coEqual)
          then
          begin
            MainTaxRate := _TaxRate;
            MainTaxLevy := Trunc(GeneralRatePointer(GeneralRateList[RateIndex])^.CurrentTaxLevy);
            MainLevyPercentChange := fPercentChange;
          end
          else TotalDueString := '';

        If _Locate(GeneralTaxRateTable,
                   [IncrementNumericString(BillParameterTable.FieldByName('TaxRollYr').AsString, -1),
                    CollectionType, CollectionNumber, PrintOrder], '', [])
          then
            begin
              PriorTaxRate := GeneralTaxRateTable.FieldByName('HomesteadRate').AsFloat;
              TaxRatePercentChange := ComputePercent(_TaxRate, PriorTaxRate);
            end;

        If bUserDefinedPrintOrder
        then iLineOrder := GeneralRatePointer(GeneralRateList[RateIndex])^.BillPrintOrder
        else iLineOrder := DetailsPrinted;

        _InsertRecord(RAVELeviesTable,
                      ['PrintOrder', 'LineOrder', 'LevyDescription',
                       'TotalTaxLevy',
                       'PercentChange',
                       'AssessedValue',
                       'TaxableValue',
                       'TaxRate',
                       'PriorTaxRate',
                       'TaxRatePercentChange',
                       'TaxAmount',
                       'TotalDue'],
                      [BillPrintOrder, iLineOrder, Description,
                       FormatFloat(CurrencyDisplayNoDollarSign,
                                   GeneralRatePointer(GeneralRateList[RateIndex])^.CurrentTaxLevy),
                       FormatFloat(DecimalDisplay, fPercentChange),
                       RAVEBillHeaderInfoTable.FieldByName('AssessedValue').AsString,
                       FormatFloat(CurrencyDisplayNoDollarSign, TaxableVal),
                       FormatFloat(sTaxRateDisplayFormat, _TaxRate),
                       FormatFloat(sTaxRateDisplayFormat, PriorTaxRate),
                       FormatFloat(PercentageDisplay_2Decimals, TaxRatePercentChange),
                       FormatFloat(CurrencyDecimalDisplay, TaxAmount),
                       TotalDueString], []);

        PriorTax := 0;

        If RAVELevyChangeTable.Active
          then
            begin
              If _Locate(LastYearGeneralTaxTable,
                         [SwisSBLKey, HomesteadCode, PrintOrder], '', [])
                then
                  begin
                    PriorTax := LastYearGeneralTaxTable.FieldByName('TaxAmount').AsFloat;
                    TotalPriorTax := TotalPriorTax + PriorTax;
                  end;

              _InsertRecord(RAVELevyChangeTable,
                            ['PrintOrder', 'LineOrder', 'LevyDescription',
                             'PriorTax', 'CurrentTax',
                             'DollarChange', 'PercentChange'],
                            [BillPrintOrder, DetailsPrinted, Description,
                             FormatFloat(CurrencyDecimalDisplay, PriorTax),
                             FormatFloat(CurrencyDecimalDisplay, TaxAmount),
                             FormatFloat(CurrencyDecimalDisplay, (TaxAmount - PriorTax)),
                             FormatFloat(DecimalDisplay, ComputePercent(TaxAmount, PriorTax)) + '%'], []);

            end;  {If RAVELevyChangeTable.Active}

      end;  {with GeneralTaxPtr(GnTaxList[I])^ do}

  For I := 0 to (SDTaxList.Count - 1) do
    with SDistTaxPtr(SDTaxList[I])^ do
      begin
        Inc(DetailsPrinted);
        FoundSDRate(SDRateList, SDistCode, ExtCode, CMFlag, RateIndex);

        TaxRate := SDRatePointer(SDRateList[RateIndex])^.HomesteadRate;

        If TaxRatePerHundred
          then _TaxRate := TaxRate / 10
          else _TaxRate := TaxRate;

        CurrentLevy := Trunc(SDRatePointer(SDRateList[RateIndex])^.CurrentTaxLevy);
        PriorLevy := Trunc(SDRatePointer(SDRateList[RateIndex])^.PriorTaxLevy);

        If (Roundoff(TaxRate, 6) > 0.000000)
          then
            begin
              If _Compare(ExtCode, SDistEcTO, coEqual)
                then SpecialDistrictValueString := FormatFloat(CurrencyDisplayNoDollarSign, SdValue)
                else SpecialDistrictValueString := FormatFloat(DecimalDisplay, SdValue);

              If bUserDefinedPrintOrder
              then iLineOrder := SDRatePointer(SDRateList[RateIndex])^.BillPrintOrder
              else iLineOrder := DetailsPrinted;

              _InsertRecord(RAVELeviesTable,
                            ['PrintOrder', 'LineOrder', 'LevyDescription',
                             'TotalTaxLevy',
                             'PercentChange',
                             'AssessedValue',
                             'TaxableValue', 'TaxRate', 'TaxAmount'],
                            [BillPrintOrder, iLineOrder, Description,
                             FormatFloat(CurrencyDisplayNoDollarSign, CurrentLevy),
                             FormatFloat(DecimalDisplay,
                                         ComputePercent(CurrentLevy, PriorLevy)),
                             RAVEBillHeaderInfoTable.FieldByName('AssessedValue').AsString,
                             SpecialDistrictValueString,
                             FormatFloat(sTaxRateDisplayFormat, _TaxRate),
                             FormatFloat(CurrencyDecimalDisplay, SDAmount)], []);

              If RAVELevyChangeTable.Active
                then
                  begin
                    PriorTax := 0;

                    If _Locate(LastYearSpecialDistrictTaxTable,
                               [SwisSBLKey, SDistCode, HomesteadCode, ExtCode], '', [])
                      then
                        begin
                          PriorTax := LastYearSpecialDistrictTaxTable.FieldByName('TaxAmount').AsFloat;
                          TotalPriorTax := TotalPriorTax + PriorTax;
                        end;

                    _InsertRecord(RAVELevyChangeTable,
                                  ['PrintOrder', 'LineOrder', 'LevyDescription',
                                   'PriorTax', 'CurrentTax',
                                   'DollarChange', 'PercentChange'],
                                  [BillPrintOrder, DetailsPrinted, Description,
                                   FormatFloat(CurrencyDecimalDisplay, PriorTax),
                                   FormatFloat(CurrencyDecimalDisplay, SDAmount),
                                   FormatFloat(CurrencyDecimalDisplay, (SDAmount - PriorTax)),
                                   FormatFloat(DecimalDisplay, ComputePercent(SDAmount, PriorTax)) + '%'], []);

                  end;  {If RAVELevyChangeTable.Active}

            end;  {If (Roundoff(TaxRate, 6) > 0.000000)}

      end;  {with SDistTaxPtr(SDTaxList[I])^ do}

  If PadDetailLines
    then
      For I := (DetailsPrinted + 1) to MaxLevyLines do
        _InsertRecord(RAVELeviesTable, ['PrintOrder', 'LineOrder'], [BillPrintOrder, I], []);

    {Finally add the exemption details.}

  If bDisplayCommasInExemptionAmount
    then sDisplayFormat := CurrencyDisplayNoDollarSign
    else sDisplayFormat := NoDecimalDisplay;

  iSeniorExemptionAmount := 0;
  iVeteransExemptionAmount := 0;

  For I := 0 to (EXTaxList.Count - 1) do
    with ExemptTaxPtr(ExTaxList[I])^ do
      begin
        EXAppliesArray := EXApplies(EXCode, False);

        If EXAppliesArray[EXTown]
          then TempAmount := Trunc(TownAmount)
          else
            If EXAppliesArray[EXCounty]
              then TempAmount := Trunc(CountyAmount)
              else TempAmount := Trunc(SchoolAmount);

        with tb_Header do
          FullExemptionValue := Trunc(ComputeFullValue(TempAmount, SwisCodeTable,
                                                       FieldByName('PropertyClassCode').Text,
                                                       ' ', True));

        If _Compare(ExCode, '4180', coStartsWith)
        then iSeniorExemptionAmount := Trunc(TownAmount);

        If _Compare(ExCode, '411', coStartsWith)
        then iVeteransExemptionAmount := Trunc(TownAmount);

        _InsertRecord(RAVEBillEXDetailsTable,
                      ['PrintOrder', 'LineOrder',
                       'ExemptionCode', 'ExemptionDescription', 'TaxPurpose',
                       'Amount',
                       'FullValue',
                       'Savings'],
                      [BillPrintOrder, (I + 1),
                       EXCode, Description, GetExemptionTypeDescription(EXCode),
                       FormatFloat(sDisplayFormat, TempAmount),
                       FormatFloat(CurrencyDisplayNoDollarSign, FullExemptionValue),
                       FormatFloat(CurrencyDecimalDisplay,
                                   Roundoff(((TempAmount / 1000) * MainTaxRate), 2))], []);

      end;  {with ExemptTaxPtr(ExTaxList[I])^ do}

  If PadDetailLines
    then
      For I := (EXTaxList.Count + 1) to MaxExemptionLines do
        _InsertRecord(RAVEBillEXDetailsTable, ['PrintOrder', 'LineOrder'], [BillPrintOrder, I], []);

  with RAVEBillHeaderInfoTable do
    begin
      try
        FieldByName('TotalPriorTax').Text := FormatFloat(CurrencyDecimalDisplay, TotalPriorTax);
        FieldByName('TotalDollarChange').Text := FormatFloat(CurrencyDecimalDisplay,
                                                             (tb_Header.FieldByName('TotalTaxOwed').AsFloat - TotalPriorTax));
        FieldByName('TotalPercentChange').Text := FormatFloat(DecimalDisplay,
                                                              ComputePercent(tb_Header.FieldByName('TotalTaxOwed').AsFloat, TotalPriorTax)) + '%';
      except
      end;

      try
        FieldByName('MainLevyPercentChange').Text := FormatFloat(DecimalDisplay, MainLevyPercentChange);
        FieldByName('MainTaxRate').Text := FormatFloat(sTaxRateDisplayFormat, MainTaxRate);
        FieldByName('MainTaxLevy').Text := FormatFloat(CurrencyDisplayNoDollarSign, MainTaxLevy);
        FieldByName('VeteranExAmt').AsString := FormatFloat(NoDecimalDisplay_BlankZero, iVeteransExemptionAmount);
        FieldByName('SeniorExAmt').AsString := FormatFloat(NoDecimalDisplay_BlankZero, iSeniorExemptionAmount);
      except
      end;

      try
        Post;
      except
        Cancel;
      end;

    end;  {with RAVEBillHeaderInfoTable do}

end;  {AddOneStandardRAVEBill}

end.