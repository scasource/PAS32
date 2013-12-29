unit Rtcalcul;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DBCtrls, DBTables, DB, Buttons, Grids,
  Wwdbigrd, Wwdbgrid, ExtCtrls, WwTable, Wwdatsrc, Menus,types,
  PasTypes,Prog, Glblcnst(*, Progress*);

type
  TRollTotalCalculateForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    CloseButton: TBitBtn;
    TitleLabel: TLabel;
    ScrollBox2: TScrollBox;
    BitBtn1: TBitBtn;
    StartButton: TBitBtn;
    ProcessingYearRadioGroup: TRadioGroup;
    HistoryEdit: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UnitName : String;
    FormAccessRights : Integer;  {Read only or read write, based on security level?}
                                {Values = raReadOnly, raReadWrite}

    Procedure InitializeForm;

  end;

Procedure CreateRollTotals(ProcessingType : Integer;
                           TaxRollYr : String;
                           ProgressDialog : TProgressDialog;
                           CallingForm : TForm;
                           TrialRun,
                           ShowCompletionMessage : Boolean);

implementation

uses GlblVars, WinUtils, Utilitys,PasUtils, UTILEXSD, DataAccessUnit;

Type
    {FXX02101999-4: Add land value to swis and school totals.}

  RtSwis = record
    TaxRollYr : String;
    SwisCode  : String;
    RollSection : String;
    HomeSteadCode : String;
    ParcelCount   : Longint;
    PartCount     : LongInt;
    LandValue : Double;
    AssessedValue : Double;
    CountyTaxable : Double;
    TownTaxable   : Double;
    VillageTaxable: Double;

  end;  {RtSwis = Record}

  RTSwisPtr = ^RtSwis;

    {CHG07291999-1: Add STAR values and taxable vals to on-line totals.}

  RTSchoolRec = record
    TaxRollYr : String;
    SwisCode : String;
    SchoolCode  : String;
    HomeSteadCode : String;
    ParcelCount   : Longint;
    PartCount     : LongInt;
    LandValue : Double;
    AssessedValue : Double;
    SchoolTaxable : Double;
    RelevyCount   : LongInt;
    SchoolRelevyAmount: Extended;
    BasicStarAmount,
    EnhancedStarAmount : Double;
    BasicStarCount,
    EnhancedStarCount : LongInt;
  end;  {RTSchoolLRec = Record}

  RTSchoolPtr = ^RTSchoolRec;

  RTEXCode = record
    TaxRollYr : String;
    SwisCode : String;
    ExCode  : String;
    HomeSteadCode : String;
    ParcelCount   : Longint;
    PartCount     : LongInt;
    CountyExAmount : Double;
    TownExAmount   : Double;
    VillageExAmount   : Double;
    SchoolExAmount: Double;
  end;  {RTEXCode = record}

  RTExCodePtr = ^RtExCode;

  RTSDCode = record
    TaxRollYr : String;
    SwisCode : String;
    SDCode  : String;
    SDExtensionCode : String;
    SDCCOMFlg   : String;
    HomeSteadCode : String;
    SplitDistrict : Boolean;
    ParcelCount   : Longint;
    PartCount : LongInt;
    TaxableValue : Double;
    AssessedValue : Double;
  end;  {RTSDCode = record}

  RTSDCodePtr = ^RTSDCode;


  RTVillageRelevyRec = record
    TaxRollYr : String;
    SwisCode : String;
    HomeSteadCode : String;
    RelevyCount   : LongInt;
    RelevyAmount: Double;
  end;  {RTVillageRelevyLRec = Record}

  RTVillageRelevyPtr = ^RTVillageRelevyRec;

  RTRS9 = record
    TaxRollYr : String;
    SwisCode : String;
    SDCode  : String;
    ParcelCount   : Longint;
    Amount : Double;
  end;  {RTRS9 = record}

  RTRS9Ptr = ^RTRS9;

{$R *.DFM}

{========================================================}
Procedure TRollTotalCalculateForm.FormActivate(Sender: TObject);

begin
  SetFormStateMaximized(Self);
end;

{========================================================}
Procedure TRollTotalCalculateForm.InitializeForm;

{FXX05022000-1: Allow for history recalc by SCA user only.}

begin
  If (Take(10, GlblUserName) = Take(10, 'SCABOAT'))
    then
      begin
        ProcessingYearRadioGroup.Items.Add('History');
        HistoryEdit.Visible := True;
      end;

end;  {InitializeForm}

{===================================================================}
Function FoundSwisTotRec(    SwisList : Tlist;
                             TaxRollYr : String;
                             SwisCode : String;
                             RollSection : String;
                             HomeSteadCode : String;
                         var TotIdx : Integer) : Boolean;

{Searches swis tlist for a matching entry and returns the index if found.}

var
  I : Integer;
  Foundit : Boolean;

begin
  Foundit := False;

  For I := 0 to (SwisList.Count - 1) do
    If ((Take(4,RTSwisPtr(SwisList[I])^.TaxRollYr)) =
                               (Take(4,TAxrollYr)) )
                              AND
       ((Take(6,RTSwisPtr(SwisList[I])^.SwisCode)) =
                               (Take(6,SwisCode)))
                              AND
       ((Take(1,RTSwisPtr(SwisList[I])^.RollSection)) = (Take(1,RollSection)))
                              AND
       ((Take(1,RTSwisPtr(SwisList[I])^.HomeSteadCode)) = (Take(1,HomeSteadCode)))
      then
        begin
          TotIdx := I;
          FoundIt := True;
        end;

  FoundSwisTotRec := Foundit;

end;  {FoundSwisTotRec}

{===================================================================}
Procedure UpdateSwisTotals(SwisList : TList;
                           TaxRollYr : String;
                           SwisCode : String;
                           RollSection,
                           HomesteadCode : String;
                           LandVal,
                           AssessedVal : Comp;
                           EXAmounts : ExemptionTotalsArrayType;
                           SplitParcel : Boolean);

{Update the Swis totals record with this amount for this swis\rs\homestead code.}

var
  Index : Integer;
  SwisPtr : RTSwisPtr;

begin
  If not FoundSwisTotRec(SwisList, TaxRollYr, SwisCode,
                         RollSection, HomesteadCode, Index)
    then
      begin
           {Create a new entry in the list.}

        New(SwisPtr);

        SwisPtr^.TaxRollYr := TaxRollYr;
        SwisPtr^.SwisCode := SwisCode;
        SwisPtr^.RollSection := RollSection;
        SwisPtr^.HomeSteadCode := HomesteadCode;
        SwisPtr^.ParcelCount := 0;
        SwisPtr^.PartCount := 0;
          {FXX02101999-4: Add land value to swis and school totals.}
        SwisPtr^.LandValue := 0;
        SwisPtr^.AssessedValue := 0;
        SwisPtr^.CountyTaxable := 0;
        SwisPtr^.TownTaxable := 0;
        SwisPtr^.VillageTaxable := 0;

        SwisList.Add(SwisPtr);

          {Now find the new record so that we can update the totals below.}

        FoundSwisTotRec(SwisList, TaxRollYr, SwisCode,
                        RollSection, HomesteadCode, Index);

      end;  {If not FoundSwisTotRec}

      {Now update the amount fields.}

    {FXX11071997-4: Store the part amounts for split parcels seperate
                    from the parcel count.}
    {FXX11091997-2: Pass in the split parcel flag seperately.}

  If SplitParcel
    then RTSwisPtr(SwisList[Index])^.PartCount :=
             RTSwisPtr(SwisList[Index])^.PartCount + 1
    else RTSwisPtr(SwisList[Index])^.ParcelCount :=
             RTSwisPtr(SwisList[Index])^.ParcelCount + 1;

    {FXX02101999-4: Add land value to swis and school totals.}

  RTSwisPtr(SwisList[Index])^.LandValue :=
      RTSwisPtr(SwisList[Index])^.LandValue + LandVal;

  RTSwisPtr(SwisList[Index])^.AssessedValue :=
      RTSwisPtr(SwisList[Index])^.AssessedValue + AssessedVal;

    {FXX05261998-3: Don't let a taxable value decrease below 0.}

  RTSwisPtr(SwisList[Index])^.CountyTaxable :=
                          RTSwisPtr(SwisList[Index])^.CountyTaxable +
                          CalculateTaxableVal(AssessedVal, EXAmounts[EXCounty]);

  RTSwisPtr(SwisList[Index])^.TownTaxable :=
                          RTSwisPtr(SwisList[Index])^.TownTaxable +
                          CalculateTaxableVal(AssessedVal, EXAmounts[EXTown]);

  RTSwisPtr(SwisList[Index])^.VillageTaxable :=
                          RTSwisPtr(SwisList[Index])^.VillageTaxable +
                          CalculateTaxableVal(AssessedVal, EXAmounts[EXVillage]);

end;  {UpdateSwisTotals}

{===================================================================}
Function FoundSchoolTotRec(    SchoolList : Tlist;
                               TaxRollYr : String;
                               SwisCode,
                               SchoolCode : String;
                               HomesteadCode : String;
                           var TotIdx : Integer) : Boolean;

{Searches School tlist for a matching entry and returns the index if found.}

var
  I : Integer;
  Foundit : Boolean;

begin
  Foundit := False;

  For I := 0 to (SchoolList.Count - 1) do
    If ((Take(4,RTSchoolPtr(SchoolList[I])^.TaxRollYr)) =
                               (Take(4,TAxrollYr)) )
                              AND
       ((Take(6,RTSchoolPtr(SchoolList[I])^.SwisCode)) =
                               (Take(6,SwisCode)))
                              AND
       ((Take(6,RTSchoolPtr(SchoolList[I])^.SchoolCode)) =
                               (Take(6,SchoolCode)))
                              AND
       ((Take(1,RTSchoolPtr(SchoolList[I])^.HomeSteadCode)) = (Take(1,HomeSteadCode)))
      then
        begin
          TotIdx := I;
          FoundIt := True;
        end;

  FoundSchoolTotRec := Foundit;

end;  {FoundSchoolTotRec}

{===================================================================}
Procedure UpdateSchoolTotals(SchoolList : TList;
                             TaxRollYr : String;
                             SwisCode,
                             SchoolCode : String;
                             HomesteadCode : String;
                             LandVal,
                             AssessedVal : Comp;
                             SchoolRelevyAmount : Extended;
                             EXAmounts : ExemptionTotalsArrayType;
                             BasicSTARAmount,
                             EnhancedSTARAmount : Comp;
                             SplitParcel : Boolean);

{Update the school totals record with this amount for this Swis\School\homestead code.}
{CHG07291999-1: Add STAR values and taxable vals to on-line totals.}

var
  Index : Integer;
  SchoolPtr : RTSchoolPtr;
  ExtractFile : TextFile;

begin
(*  AssignFile(ExtractFile, 'c:\temp\schooltotals.txt');
  Append(ExtractFile); *)
    {FXX08181999-9: Some Nonhstd residences get STAR (i.e. 411),
                    but don't double count for splits.}

  If (SplitParcel and
      (HomesteadCode = 'N'))
    then
      begin
        EnhancedSTARAmount := 0;
        BasicSTARAmount := 0;
      end;

  If not FoundSchoolTotRec(SchoolList, TaxRollYr, SwisCode, SchoolCode,
                           HomesteadCode, Index)
    then
      begin
           {Create a new entry in the list.}

        New(SchoolPtr);

        SchoolPtr^.TaxRollYr := TaxRollYr;
        SchoolPtr^.SwisCode := SwisCode;
        SchoolPtr^.SchoolCode := SchoolCode;
        SchoolPtr^.HomeSteadCode := HomesteadCode;
        SchoolPtr^.ParcelCount := 0;
        SchoolPtr^.PartCount := 0;

          {FXX02101999-4: Add land value to swis and school totals.}

        SchoolPtr^.LandValue := 0;
        SchoolPtr^.AssessedValue := 0;
        SchoolPtr^.SchoolTaxable := 0;
        SchoolPtr^.BasicSTARAmount := 0;
        SchoolPtr^.EnhancedSTARAmount := 0;
        SchoolPtr^.BasicSTARCount := 0;
        SchoolPtr^.EnhancedSTARCount := 0;
        SchoolPtr^.RelevyCount := 0;
        SchoolPtr^.SchoolRelevyAmount := 0;

        SchoolList.Add(SchoolPtr);

          {Now find the new record so that we can update the totals below.}

        FoundSchoolTotRec(SchoolList, TaxRollYr, SwisCode, SchoolCode,
                           HomesteadCode, Index);

      end;  {If not FoundSchoolTotRec}

      {Now update the amount fields.}

    {FXX11071997-4: Store the part amounts for split parcels seperate
                    from the parcel count.}
    {FXX11091997-2: Pass in the split parcel flag seperately.}

  If SplitParcel
    then RTSchoolPtr(SchoolList[Index])^.PartCount :=
             RTSchoolPtr(SchoolList[Index])^.PartCount + 1
    else RTSchoolPtr(SchoolList[Index])^.ParcelCount :=
             RTSchoolPtr(SchoolList[Index])^.ParcelCount + 1;

    {FXX02101999-4: Add land value to swis and school totals.}

  RTSchoolPtr(SchoolList[Index])^.LandValue :=
      RTSchoolPtr(SchoolList[Index])^.LandValue + LandVal;

  RTSchoolPtr(SchoolList[Index])^.AssessedValue :=
      RTSchoolPtr(SchoolList[Index])^.AssessedValue + AssessedVal;

(*  WritelnCommaDelimitedLine(ExtractFile,
                            [SchoolCode, AssessedVal]); *)

  RTSchoolPtr(SchoolList[Index])^.BasicSTARAmount :=
      RTSchoolPtr(SchoolList[Index])^.BasicSTARAmount + BasicSTARAmount;

  RTSchoolPtr(SchoolList[Index])^.EnhancedSTARAmount :=
      RTSchoolPtr(SchoolList[Index])^.EnhancedSTARAmount + EnhancedSTARAmount;

  If (Roundoff(EnhancedSTARAmount, 0) > 0)
    then RTSchoolPtr(SchoolList[Index])^.EnhancedSTARCount :=
            RTSchoolPtr(SchoolList[Index])^.EnhancedSTARCount + 1;

  If (Roundoff(BasicSTARAmount, 0) > 0)
    then RTSchoolPtr(SchoolList[Index])^.BasicSTARCount :=
            RTSchoolPtr(SchoolList[Index])^.BasicSTARCount + 1;

  RTSchoolPtr(SchoolList[Index])^.SchoolTaxable :=
                          RTSchoolPtr(SchoolList[Index])^.SchoolTaxable +
                          CalculateTaxableVal(AssessedVal, EXAmounts[EXSchool]);

     {If there is a school relevy, add the amount.}

  If (Roundoff(SchoolRelevyAmount, 2) > 0)
    then
      begin
        RTSchoolPtr(SchoolList[Index])^.RelevyCount :=
                          RTSchoolPtr(SchoolList[Index])^.RelevyCount + 1;
        RTSchoolPtr(SchoolList[Index])^.SchoolRelevyAmount :=
                          RTSchoolPtr(SchoolList[Index])^.SchoolRelevyAmount + SchoolRelevyAmount;

      end;  {If (Roundoff(SchoolRelevyAmount, 2) > 0)}

(*  CloseFile(ExtractFile); *)

end;  {UpdateSchoolTotals}

{===================================================================}
Function FoundExCodeTotRec(    ExCodeList : Tlist;
                               TaxRollYr : String;
                               SwisCode  : String;
                               ExCode : String;
                               HomeSteadCode : String;
                           var TotIdx : Integer) : Boolean;

{Search the exemption code list for a matching entry and return the
 index if it is found.}

var
  I : Integer;
  Foundit : Boolean;

begin
  Foundit := False;

  For I := 0 to (ExCodeList.Count - 1) do
    If ((Take(4,RTExCodePtr(ExCodeList[I])^.TaxRollYr)) =
                               (Take(4,TAxrollYr)) )
                           AND
       ((Take(6,RTExCodePtr(ExCodeList[I])^.SwisCode)) =
                               (Take(6,SwisCode)))
                              AND
       ((Take(5,RTExCodePtr(ExCodeList[I])^.ExCode)) =
                               (Take(5,ExCode)))
                              AND
       ((Take(1,RTExCodePtr(ExCodeList[I])^.HomeSteadCode)) =
                  (Take(1,HomeSteadCode)))
      then
        begin
          TotIdx := I;
          FoundIt := True;
        end;

  FoundExCodeTotRec := Foundit;

end;  {FoundExCodeTotRec}

{===================================================================}
Procedure UpdateExemptionTotals(EXCodeList : TList;
                                TaxRollYr : String;
                                SwisCode : String;
                                ExemptionCode : String;
                                HomesteadCode : String;
                                CountyExemptionAmount,
                                TownExemptionAmount,
                                SchoolExemptionAmount,
                                VillageExemptionAmount : Comp;
                                SplitParcel : Boolean);

{For each exemption code, update the totals.}

var
  Index : Integer;
  ExCodePtr : RTExCodePtr;

begin
  If not FoundEXCodeTotRec(EXCodeList, TaxRollYr, SwisCode, ExemptionCode,
                           HomesteadCode, Index)
    then
      begin
           {Create a new entry in the list.}

        New(EXCodePtr);

        EXCodePtr^.TaxRollYr := TaxRollYr;
        EXCodePtr^.SwisCode := SwisCode;
        EXCodePtr^.EXCode := ExemptionCode;
        EXCodePtr^.HomesteadCode := HomesteadCode;
        EXCodePtr^.ParcelCount := 0;
        EXCodePtr^.PartCount := 0;
        EXCodePtr^.CountyEXAmount := 0;
        EXCodePtr^.TownEXAmount := 0;
        EXCodePtr^.VillageEXAmount := 0;
        EXCodePtr^.SchoolEXAmount := 0;

        EXCodeList.Add(EXCodePtr);

          {Now find the new record so that we can update the totals below.}

        FoundEXCodeTotRec(EXCodeList, TaxRollYr, SwisCode, ExemptionCode,
                          HomesteadCode, Index);

      end;  {If not FoundEXTotRec}

      {Now update the amount fields.}

    {FXX11071997-4: Store the part amounts for split parcels seperate
                    from the parcel count.}
    {FXX11091997-2: Pass in the split parcel flag seperately.}

  If SplitParcel
    then RTEXCodePtr(EXCodeList[Index])^.PartCount :=
             RTEXCodePtr(EXCodeList[Index])^.PartCount + 1
    else RTEXCodePtr(EXCodeList[Index])^.ParcelCount :=
             RTEXCodePtr(EXCodeList[Index])^.ParcelCount + 1;

  RTEXCodePtr(EXCodeList[Index])^.CountyEXAmount :=
            RTEXCodePtr(EXCodeList[Index])^.CountyEXAmount + CountyExemptionAmount;

  RTEXCodePtr(EXCodeList[Index])^.TownEXAmount :=
            RTEXCodePtr(EXCodeList[Index])^.TownEXAmount + TownExemptionAmount;

  RTEXCodePtr(EXCodeList[Index])^.VillageEXAmount :=
            RTEXCodePtr(EXCodeList[Index])^.VillageEXAmount + VillageExemptionAmount;

  RTEXCodePtr(EXCodeList[Index])^.SchoolEXAmount :=
            RTEXCodePtr(EXCodeList[Index])^.SchoolEXAmount + SchoolExemptionAmount;


end;  {UpdateExemptionTotals}

{===================================================================}
Function FoundSDCodeTotRec(    SDCodeList : Tlist;
                               _TaxRollYr : String;
                               _SwisCode  : String;
                               _SDCode : String;
                               _SDExtensionCode : String;
                               _SDCComFlg : String;
                               _HomesteadCode : String;
                               _SplitDistrict : Boolean;
                           var TotIdx : Integer) : Boolean;

{Search the SD list for a matching entry and return the
index if it is found.}
{FXX11041997-1: SD code totals should not have homestead code.}

var
  I : Integer;
  FoundIt : Boolean;

begin
  Foundit := False;

    {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

  For I := 0 to (SDCodeList.Count - 1) do
    with RTSDCodePtr(SDCodeList[I])^ do
    If ((Take(4, TaxRollYr) = Take(4, _TaxRollYr)) and
        (Take(6, SwisCode) = Take(6, _SwisCode)) and
        (Take(5, SDCode) = Take(5, _SDCode)) and
        (Take(2, SDExtensionCode) = Take(2, _SDExtensionCode)) and
        (Take(1, SDCCOMFlg) = Take(1, _SDCCOMFlg)) and
        ((not SplitDistrict) or
         (Trim(HomesteadCode) = _HomesteadCode)))
      then
        begin
          TotIdx := I;
          FoundIt := True;
        end;

  FoundSDCodeTotRec := FoundIt;

end;  {FoundSDCodeTotRec}

{===================================================================}
Function FoundRS9TotRec(    RS9List : Tlist;
                            TaxRollYr : String;
                            SwisCode  : String;
                            SDCode : String;
                        var TotIdx : Integer) : Boolean;

{Search the SD list for a matching entry and return the
index if it is found.}
{CHG08021999-2: Add roll section 9 totals.}

var
  I : Integer;
  FoundIt : Boolean;

begin
  Foundit := False;

  For I := 0 to (RS9List.Count - 1) do
    If ((Take(4, RTRS9Ptr(RS9List[I])^.TaxRollYr) = Take(4, TaxRollYr)) and
        (Take(6, RTRS9Ptr(RS9List[I])^.SwisCode) = Take(6, SwisCode)) and
        (Take(5, RTRS9Ptr(RS9List[I])^.SDCode) = Take(5, SDCode)))
      then
        begin
          TotIdx := I;
          FoundIt := True;
        end;

  FoundRS9TotRec := FoundIt;

end;  {FoundRS9TotRec}

{===================================================================}
Procedure UpdateSDTotals(SDCodeList,
                         RS9List : TList;
                         TaxRollYr : String;
                         SwisCode  : String;
                         RollSection : String;
                         SDCode : String;
                         ExtensionCode : String;
                         CCOMFlag : String;
                         HomesteadCode : String;
                         SplitDistrict : Boolean;
                         AssessedValue : Double;
                         TaxableValue : Double;
                         SplitParcel : Boolean);

{For each SD code\Extension\CCOM, update the totals.}
{FXX11041997-1: SD code totals should not have homestead code.}

var
  Index : Integer;
  SDCodePtr : RTSDCodePtr;
  RS9Ptr : RTRS9Ptr;

begin
    {CHG05102009-1(2.20.1.1)[F925]: Add the assessed value to the roll totals print.}

  If not FoundSDCodeTotRec(SDCodeList, TaxRollYr, SwisCode, SDCode,
                           ExtensionCode, CCOMFlag,
                           HomesteadCode, SplitDistrict, Index)
    then
      begin
           {Create a new entry in the list.}

        New(SDCodePtr);

        SDCodePtr^.TaxRollYr := TaxRollYr;
        SDCodePtr^.SwisCode := SwisCode;
        SDCodePtr^.SDCode := SDCode;
        SDCodePtr^.ParcelCount := 0;
        SDCodePtr^.PartCount := 0;
        SDCodePtr^.SDExtensionCode := Take(2, ExtensionCode);
        SDCodePtr^.SDCCOMFlg := Take(1, CCOMFlag);
        SDCodePtr^.TaxableValue := 0;
        SDCodePtr^.AssessedValue := 0;
        SDCodePtr^.HomeSteadCode := HomesteadCode;
        SDCodePtr^.SplitDistrict := SplitDistrict;

        SDCodeList.Add(SDCodePtr);

          {Now find the new record so that we can update the totals below.}

        FoundSDCodeTotRec(SDCodeList, TaxRollYr, SwisCode, SDCode,
                          ExtensionCode, CCOMFlag, HomesteadCode, SplitDistrict, Index);

      end;  {If not FoundSDTotRec}

      {Now update the amount fields.}

  RTSDCodePtr(SDCodeList[Index])^.ParcelCount :=
            RTSDCodePtr(SDCodeList[Index])^.ParcelCount + 1;

  If SplitParcel
    then RTSDCodePtr(SDCodeList[Index])^.PartCount :=
            RTSDCodePtr(SDCodeList[Index])^.PartCount + 1;

  RTSDCodePtr(SDCodeList[Index])^.TaxableValue :=
            RTSDCodePtr(SDCodeList[Index])^.TaxableValue + TaxableValue;

    {FXX03052010[I7077](2.22.2.2): The assessed value of the special district report was showing the taxable value.}

  RTSDCodePtr(SDCodeList[Index])^.AssessedValue :=
            RTSDCodePtr(SDCodeList[Index])^.AssessedValue + AssessedValue;

    {CHG08021999-2: Add roll section 9 totals.}

  If (RollSection = '9')
    then
      begin
        If not FoundRS9TotRec(RS9List, TaxRollYr, SwisCode, SDCode, Index)
          then
            begin
                 {Create a new entry in the list.}

              New(RS9Ptr);

              RS9Ptr^.TaxRollYr := TaxRollYr;
              RS9Ptr^.SwisCode := SwisCode;
              RS9Ptr^.SDCode := SDCode;
              RS9Ptr^.ParcelCount := 0;
              RS9Ptr^.Amount := 0;

              RS9List.Add(RS9Ptr);

                {Now find the new record so that we can update the totals below.}

              FoundRS9TotRec(RS9List, TaxRollYr, SwisCode, SDCode, Index);

            end;  {If not FoundSDTotRec}

            {Now update the amount fields.}

        RTRS9Ptr(RS9List[Index])^.ParcelCount :=
                  RTRS9Ptr(RS9List[Index])^.ParcelCount + 1;

        RTRS9Ptr(RS9List[Index])^.Amount :=
                  RTRS9Ptr(RS9List[Index])^.Amount + TaxableValue;

      end;  {If (RollSection = '9')}

end;  {UpdateSDTotals}

{CHG12091998-1:  Village relevy totals.}
{===================================================================}
Function FoundVillageRelevyTotRec(    VillageRelevyList : Tlist;
                                      TaxRollYr : String;
                                      SwisCode : String;
                                      HomesteadCode : String;
                                  var TotIdx : Integer) : Boolean;

{Searches VillageRelevy tlist for a matching entry and returns the index if found.}

var
  I : Integer;
  Foundit : Boolean;

begin
  Foundit := False;

  For I := 0 to (VillageRelevyList.Count - 1) do
    If ((Take(4,RTVillageRelevyPtr(VillageRelevyList[I])^.TaxRollYr)) =
                               (Take(4,TAxrollYr)) )
                              AND
       ((Take(6,RTVillageRelevyPtr(VillageRelevyList[I])^.SwisCode)) =
                               (Take(6,SwisCode)))
                              AND
       ((Take(1,RTVillageRelevyPtr(VillageRelevyList[I])^.HomeSteadCode)) = (Take(1,HomeSteadCode)))
      then
        begin
          TotIdx := I;
          FoundIt := True;
        end;

  FoundVillageRelevyTotRec := Foundit;

end;  {FoundVillageRelevyTotRec}

{===================================================================}
Procedure UpdateVillageRelevyTotals(VillageRelevyList : TList;
                                    TaxRollYr : String;
                                    SwisCode : String;
                                    HomesteadCode : String;
                                    VillageRelevy : Extended);

{Update the VillageRelevy totals record with this amount for this Swis\VillageRelevy\homestead code.}

var
  Index : Integer;
  VillageRelevyPtr : RTVillageRelevyPtr;

begin
  If not FoundVillageRelevyTotRec(VillageRelevyList, TaxRollYr, SwisCode,
                           HomesteadCode, Index)
    then
      begin
           {Create a new entry in the list.}

        New(VillageRelevyPtr);

        VillageRelevyPtr^.TaxRollYr := TaxRollYr;
        VillageRelevyPtr^.SwisCode := SwisCode;
        VillageRelevyPtr^.HomeSteadCode := HomesteadCode;
        VillageRelevyPtr^.RelevyCount := 0;
        VillageRelevyPtr^.RelevyAmount := 0;

        VillageRelevyList.Add(VillageRelevyPtr);

          {Now find the new record so that we can update the totals below.}

        FoundVillageRelevyTotRec(VillageRelevyList, TaxRollYr, SwisCode, HomesteadCode, Index);

      end;  {If not FoundVillageRelevyTotRec}

      {Now update the amount fields.}

  RTVillageRelevyPtr(VillageRelevyList[Index])^.RelevyCount :=
             RTVillageRelevyPtr(VillageRelevyList[Index])^.RelevyCount + 1;

  RTVillageRelevyPtr(VillageRelevyList[Index])^.RelevyAmount :=
                      RTVillageRelevyPtr(VillageRelevyList[Index])^.RelevyAmount + VillageRelevy;

end;  {UpdateVillageRelevyTotals}

{========================================================================}
Procedure StoreRollTotals(ProcessingType : Integer;
                          AssessmentYear : String;
                          SwisList,
                          SchoolList,
                          EXCodeList,
                          SDCodeList,
                          VillageRelevyList,
                          RS9List : TList);

{Now actually store the roll total records which were just calculated.}

var
  I, ListLimit, TotIdx : Integer;
  RTSwisTable: TTable;
  RTSchoolTable: TTable;
  RTExTable: TTable;
  RTSdTable: TTable;
  RTVillageRelevyTable: TTable;
  RTRS9Table : TTable;
  Quit : Boolean;

begin
  RTSwisTable := TTable.Create(nil);
  RTSchoolTable := TTable.Create(nil);
  RTExTable := TTable.Create(nil);
  RTSdTable := TTable.Create(nil);
  RTVillageRelevyTable := TTable.Create(nil);
  RTRS9Table := TTable.Create(nil);

  OpenTableForProcessingType(RTSwisTable, RTBySwisCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(RTSchoolTable, RTBySchoolCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(RTEXTable, RTByEXCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(RTSDTable, RTBySDCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(RTVillageRelevyTable, RTByVillageRelevyTableName,
                             ProcessingType, Quit);

    {FXX02022000-2: Wrong table name.}

  OpenTableForProcessingType(RTRS9Table, RTByRS9TableName,
                             ProcessingType, Quit);

    {First delete the old roll total tables.}
    {FXX05032000-5: Need to set range on the delete tables for history recalc.}

  RTSwisTable.IndexName := 'BYTAXROLLYR';
  SetRangeOld(RTSwisTable, ['TaxRollYr'], [AssessmentYear], [AssessmentYear]);

  RTSchoolTable.IndexName := 'BYTAXROLLYR';
  SetRangeOld(RTSchoolTable, ['TaxRollYr'], [AssessmentYear], [AssessmentYear]);

  RTExTable.IndexName := 'BYTAXROLLYR';
  SetRangeOld(RTExTable, ['TaxRollYr'], [AssessmentYear], [AssessmentYear]);

  RTSdTable.IndexName := 'BYTAXROLLYR';
  SetRangeOld(RTSdTable, ['TaxRollYr'], [AssessmentYear], [AssessmentYear]);

  RTVillageRelevyTable.IndexName := 'BYTAXROLLYR';
  SetRangeOld(RTVillageRelevyTable, ['TaxRollYr'], [AssessmentYear], [AssessmentYear]);

  RTRS9Table.IndexName := 'BYTAXROLLYR';
  SetRangeOld(RTRS9Table, ['TaxRollYr'], [AssessmentYear], [AssessmentYear]);

  DeleteTableRange(RTSwisTable);
  DeleteTableRange(RTSchoolTable);
  DeleteTableRange(RTExTable);
  DeleteTableRange(RTSDTable);
  DeleteTableRange(RTVillageRelevyTable);
  DeleteTableRange(RTRS9Table);

  RTSwisTable.CancelRange;
  RTSchoolTable.CancelRange;
  RTExTable.CancelRange;
  RTSdTable.CancelRange;
  RTVillageRelevyTable.CancelRange;
  RTRS9Table.CancelRange;

    {Now actually store the roll total records.}

  ListLimit := SwisList.Count - 1;

  For Totidx := 0 to ListLimit do
    with RTSwisTable, RTSwisPtr(SwisList[TotIdx])^ do
      begin
        Insert;

        FieldByName('TaxRollYr').Text := TaxRollYr;
        FieldByName('SwisCode').Text := SwisCode;
        FieldByName('RollSection').Text := RollSection;
        FieldByName('HomesteadCode').Text := HomeSteadCode;
        FieldByName('ParcelCount').AsInteger := ParcelCount;
        FieldByName('PartCount').AsInteger := PartCount;

          {FXX02101999-4: Add land value to swis and school totals.}

        FieldByName('LandValue').AsFloat := LandValue;
        FieldByName('AssessedValue').AsFloat := AssessedValue;
        FieldByName('CountyTaxable').AsFloat := CountyTaxable;
        FieldByName('TownTaxable').AsFloat := TownTaxable;
        FieldByName('VillageTaxable').AsFloat := VillageTaxable;

        try
          Post;
        except
          SystemSupport(085, RTSwisTable, 'Error Adding Swis Roll Totals Record.',
                        'RTCalcul', GlblErrorDlgBox);
        end;

      end;  {For Totidx := 0 to ListLimit do}


    {Now store the school roll totals.}

  ListLimit := SchoolList.Count - 1;

  For TotIdx := 0 to ListLimit do
    with RTSchoolTable, RTSchoolPtr(SchoolList[TotIdx])^ do
      begin
        Insert;

        FieldByName('TaxRollYr').Text := TaxRollYr;
        FieldByName('SwisCode').Text := SwisCode;
        FieldByName('SchoolCode').Text := SchoolCode;
        FieldByName('HomesteadCode').Text := HomesteadCode;
        FieldByName('ParcelCount').AsInteger := ParcelCount;
        FieldByName('PartCount').AsInteger := PartCount;

          {FXX02101999-4: Add land value to swis and school totals.}

        FieldByName('LandValue').AsFloat := LandValue;
        FieldByName('AssessedValue').AsFloat := AssessedValue;
        FieldByName('SchoolTaxable').AsFloat := SchoolTaxable;
        FieldByName('RelevyCount').AsFloat := RelevyCount;
        FieldByName('SchoolRelevyAmt').AsFloat := SchoolRelevyAmount;

          {CHG07291999-1: Add STAR values and taxable vals to on-line totals.}

        FieldByName('BasicSTARAmount').AsFloat := BasicSTARAmount;
        FieldByName('EnhancedSTARAmount').AsFloat := EnhancedSTARAmount;
        FieldByName('BasicSTARCount').AsFloat := BasicSTARCount;
        FieldByName('EnhancedSTARCount').AsFloat := EnhancedSTARCount;

      try
        Post;
      except
         SystemSupport(090, RTSchoolTable, 'Error Adding School Roll Totals Record',
                       'RTCalcul', GlblErrorDlgBox);
      end;

    end;  {For Totidx := 0 to ListLimit do}

      {Now add the exemption roll totals.}

  ListLimit := ExCodeList.Count - 1;

  For TotIdx := 0 to ListLimit do
    with RTEXTable, RTExCodePtr(ExCodeList[TotIdx])^ do
      begin
        Insert;

        FieldByName('TaxRollYr').Text := TaxRollYr;
        FieldByName('SwisCode').Text := SwisCode;
        FieldByName('ExCode').Text := ExCode;
        FieldByName('HomesteadCode').Text := HomesteadCode;
        FieldByName('ParcelCount').AsInteger := ParcelCount;
        FieldByName('PartCount').AsInteger := PartCount;
        FieldByName('CountyExAmount').AsFloat := CountyEXAmount;
        FieldByName('TownExAmount').AsFloat := TownExAmount;
        FieldByName('SchoolExAmount').AsFloat := SchoolExAmount;
        FieldByName('VillageExAmount').AsFloat := VillageExAmount;

        try
          Post;
        except
          SystemSupport(095, RTExTable, 'Error Adding Exemption Roll Totals Record.',
                        'RTCalcul', GlblErrorDlgBox);
        end;

      end;  {For Totidx := 0 to ListLimit do}

     {Finally add the SD roll total records.}
     {FXX11041997-1: SD code totals should not have homestead code.}

  ListLimit := SdCodeList.Count - 1;

  For TotIdx := 0 to ListLimit do
    with RTSDTable, RTSDCodePtr(SdCodeList[TotIdx])^ do
      begin
        RTSDTable.Insert;

        FieldByName('TaxRollYr').Text := TaxRollYr;
        FieldByName('SwisCode').Text := SwisCode;
        FieldByName('SdCode').Text := SDCode;
        FieldByName('ExtensionCode').Text := SDExtensionCode;
        FieldByName('CCOMFlg').Text := Take(1,SDCCOMFlg);
        FieldByName('ParcelCount').AsInteger := ParcelCount;
        FieldByName('TaxableValue').AsFloat := TaxableValue;
        FieldByName('AssessedValue').AsFloat := AssessedValue;

          {CHG09122004-1(2.8.0.11): Add homestead split to SD Calcs}

        FieldByName('HomesteadCode').Text := HomesteadCode;
        FieldByName('SplitDistrict').AsBoolean := SplitDistrict;

        try
          FieldByName('PartCount').AsInteger := PartCount;
        except
        end;

        Try
          RTSDTable.Post
        Except
           SystemSupport(100, RTSDTable, 'Error Adding Spcl. Dist. Roll Totals Record.',
                         'RTCalcul', GlblErrorDlgBox);
        end;

      end;  {For Totidx := 0 to ListLimit do}

  For I := 0 to (VillageRelevyList.Count - 1) do
    with RTVillageRelevyTable, RTVillageRelevyPtr(VillageRelevyList[I])^ do
      begin
        Insert;
        FieldByName('TaxRollYr').Text := TaxRollYr;
        FieldByName('SwisCode').Text := SwisCode;
        FieldByName('HomesteadCode').Text := HomesteadCode;
        FieldByName('VillageRelevyAmount').AsFloat := RelevyAmount;
        FieldByName('VillageRelevyCount').AsInteger := RelevyCount;

        try
          Post;
        except
          SystemSupport(101, RTVillageRelevyTable, 'Error posting village relevy table.',
                        'RTCalcul', GlblErrorDlgBox);
        end;

      end;  {with RTVillageRelevyTable, RTVillageRelevyPtr(VillageRelevyList[I])^ do}

    {CHG08021999-2: Add roll section 9 totals.}

  ListLimit := RS9List.Count - 1;

  For TotIdx := 0 to ListLimit do
    with RTRS9Table, RTRS9Ptr(RS9List[TotIdx])^ do
      begin
        RTRS9Table.Insert;

        FieldByName('TaxRollYr').Text := TaxRollYr;
        FieldByName('SwisCode').Text := SwisCode;
        FieldByName('SDCode').Text := SDCode;
        FieldByName('Amount').AsFloat := Amount;
        FieldByName('ParcelCount').AsInteger := ParcelCount;

        try
          RTRS9Table.Post;
        except
          SystemSupport(100, RTRS9Table, 'Error Adding RS9 Roll Totals Record',
                        'RTCalcul', GlblErrorDlgBox);
        end;

      end;  {For Totidx := 0 to ListLimit do}

  RTSwisTable.Close;
  RTSchoolTable.Close;
  RTExTable.Close;
  RTSdTable.Close;
  RTVillageRelevyTable.Close;
  RTRS9Table.Close;

  RTSwisTable.Free;
  RTSchoolTable.Free;
  RTExTable.Free;
  RTSdTable.Free;
  RTVillageRelevyTable.Free;
  RTRS9Table.Free;

end;  {StoreRollTotals}

{===================================================================}
Procedure CreateRollTotals(ProcessingType : Integer;
                           TaxRollYr : String;
                           ProgressDialog : TProgressDialog;
                           CallingForm : TForm;
                           TrialRun,
                           ShowCompletionMessage : Boolean);

{Create the roll totals for all parcels for swis, school, exemption, and
 special district in memory lists.}
{CHG08021999-2: Add roll section 9 totals.}

var
  SwisSBLKey : String;
  Quit, Done, FirstTimeThrough,
  Found, ClassRecFound, SplitParcel : Boolean;
  I, J : Integer;
  RollSection, sResult, HomesteadCode,
  TempHomesteadCode, SchoolCode, SwisCode : String;
  HstdAssessedVal, NonhstdAssessedVal,
  HstdLandVal, NonhstdLandVal : Comp;
  SchoolRelevyAmount, VillageRelevyAmount : Double;
  HstdAcres, NonhstdAcres : Real;
  Cancelled, AssessmentRecordFound, ClassRecordFound : Boolean;
  HstdEXAmounts, NonhstdEXAmounts, EXAmounts : ExemptionTotalsArrayType;
  ExemptionCodes,
  ExemptionHomesteadCodes,
  ResidentialTypes,
  CountyExemptionAmounts,
  TownExemptionAmounts,
  SchoolExemptionAmounts,
  VillageExemptionAmounts : TStringList;
  SDAmounts : TList;
  RecCount : LongInt;
  ErrorFile : TextFile;
  BasicSTARAmount, EnhancedSTARAmount, FullSTARAmount,
  AssessedValue, LandValue, TotalAssessedVal : Comp;
  AssessmentTable: TTable;
  ParcelTable: TTable;
  ParcelExemptionTable: TTable;
  SDCodeTable: TTable;
  ParcelSDTable: TTable;
  ExemptionCodeTable: TTable;
  ClassTable: TTable;
  SwisCodeTable: TTable;
  tbAudit : TTable;
  SchoolList,
  SwisList,
  ExCodeList,
  SDCodeList,
  RS9List,
  VillageRelevyList : TList;  {Memory lists to hold the roll totals as they are being generated.}
  ExtractFile : TextFile;

begin
  TotalAssessedVal := 0;
  Done := False;
  FirstTimeThrough := True;
  RecCount := 0;
(*  AssignFile(ErrorFile, 'RTERROR.TXT');
  Rewrite(ErrorFile);
  AssignFile(ExtractFile, 'c:\temp\41131.txt');
  Rewrite(ExtractFile);    *)

  AssessmentTable := TTable.Create(nil);
  ParcelTable := TTable.Create(nil);
  ParcelExemptionTable := TTable.Create(nil);
  SDCodeTable := TTable.Create(nil);
  ParcelSDTable := TTable.Create(nil);
  ExemptionCodeTable := TTable.Create(nil);
  ClassTable := TTable.Create(nil);
  SwisCodeTable := TTable.Create(nil);
  tbAudit := TTable.Create(nil);

  OpenTableForProcessingType(AssessmentTable, AssessmentTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelTable, ParcelTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelExemptionTable, ExemptionsTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SDCodeTable, SDistCodeTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ParcelSDTable, SpecialDistrictTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ExemptionCodeTable, ExemptionCodesTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(ClassTable, ClassTableName,
                             ProcessingType, Quit);
  OpenTableForProcessingType(SwisCodeTable, SwisCodeTableName,
                             ProcessingType, Quit);

    {CHG05072009-1(2.20.1.1)[F414]: Log roll totals calculation.}

  _OpenTable(tbAudit, AuditTableName, '', '',
             noProcessingType, []);
  _InsertRecord(tbAudit,
                ['Date', 'LabelName', 'NewValue', 'TaxRollYr',
                 'Time', 'User'],
                [DateToStr(Date), 'Roll Total Calc', 'Start', TaxRollYr,
                 TimeToStr(Now), GlblUserName], []);

  AssessmentTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  ClassTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';
  ParcelExemptionTable.IndexName := 'BYYEAR_SWISSBLKEY_EXCODE';
  ParcelSDTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY_SD';
  ExemptionCodeTable.IndexName := 'BYEXCODE';
  SDCodeTable.IndexName := 'BYSDISTCODE';

  ProgressDialog.UserLabelCaption := 'Calculating roll totals.';
  ProgressDialog.Start(GetRecordCount(ParcelTable), True, True);

   {create bySwis roll totals tlist to keep running totals}

  SwisList   := TList.Create;
  SchoolList := TList.Create;
  ExCodeList := TList.Create;
  SDCodeList := TList.Create;
  VillageRelevyList := TList.Create;
  RS9List := TList.Create;

  ExemptionCodes := TStringList.Create;
  ExemptionHomesteadCodes := TStringList.Create;
  ResidentialTypes := TStringList.Create;
  CountyExemptionAmounts := TStringList.Create;
  TownExemptionAmounts := TStringList.Create;
  SchoolExemptionAmounts := TStringList.Create;
  VillageExemptionAmounts := TStringList.Create;
  SDAmounts := TList.Create;

  ParcelTable.IndexName := 'BYTAXROLLYR_SWISSBLKEY';

    {FXX05022000-1: Allow for history recalc by SCA user only.}

  If (ProcessingType = History)
    then SetRangeOld(ParcelTable,
                     ['TaxRollYr', 'SwisCode', 'Section',
                      'Subsection', 'Block', 'Lot', 'Sublot', 'Suffix'],
                     [TaxRollYr, '', '', '', '', '', '', ''],
                     [TaxRollYr, '999999', '', '', '', '', '', '']);

  ParcelTable.First;

  repeat
    RecCount := RecCount + 1;
    Application.ProcessMessages;

    If FirstTimeThrough
      then FirstTimeThrough := False
      else ParcelTable.Next;

    If ParcelTable.EOF
      then Done := True;

    Application.ProcessMessages;
    ProgressDialog.Update(CallingForm,
                          ConvertSwisSBLToDashDot(ExtractSSKey(ParcelTable)));

      {FXX04292009-1(2.20.1.1)[F608]: Give a warning if a parcel does not have a roll section or school code.}
      {FXX07082009-1(2.20.1.10)[D1552]: Don't give a warning if the parcel is inactive.}

    If (ParcelIsActive(ParcelTable) and
        _Compare(ParcelTable.FieldByName('RollSection').AsString, coBlank))
      then
        begin
          MessageDlg('Parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey) + ' does not have a roll section.' + #13 +
                     'Please correct this and recalculate the totals.', mtError, [mbOK], 0);
          Done := True;
        end;

    If (ParcelIsActive(ParcelTable) and
        _Compare(ParcelTable.FieldByName('SchoolCode').AsString, coBlank))
      then
        begin
          MessageDlg('Parcel ' + ConvertSwisSBLToDashDot(SwisSBLKey) + ' does not have a school code.' + #13 +
                     'Please correct this and recalculate the totals.', mtError, [mbOK], 0);
          Done := True;
        end;

      {Figure out the roll totals for this parcel.}

    If not Done
      then
        begin
          SwisSBLKey := ExtractSSKey(ParcelTable);
          SwisCode := ParcelTable.FieldByName('SwisCode').Text;
          SchoolCode := ParcelTable.FieldByName('SchoolCode').Text;
          RollSection := ParcelTable.FieldByName('RollSection').Text;
          SchoolRelevyAmount := ParcelTable.FieldByName('SchoolRelevy').AsFloat;

             {CHG12091998-1:  Village relevy totals.}
             {FXX12161998-1: Had school relevy instead of village.}

          VillageRelevyAmount := ParcelTable.FieldByName('VillageRelevy').AsFloat;

          If (Roundoff(VillageRelevyAmount, 2) > 0)
            then UpdateVillageRelevyTotals(VillageRelevyList, TaxRollYr, SwisCode,
                                           HomesteadCode, VillageRelevyAmount);

          ExemptionCodes.Clear;
          ExemptionHomesteadCodes.Clear;
          ResidentialTypes.Clear;
          CountyExemptionAmounts.Clear;
          TownExemptionAmounts.Clear;
          SchoolExemptionAmounts.Clear;
          VillageExemptionAmounts.Clear;
          ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

            {There is now only one assessment record per year, so we will do a find key
             instead of a set range.}

          Found := FindKeyOld(AssessmentTable,
                              ['TaxRollYr', 'SwisSBLKey'],
                              [TaxRollYr, SwisSBLKey]);

          ClassRecFound := FindKeyOld(ClassTable,
                                      ['TaxRollYr', 'SwisSBLKey'],
                                      [TaxRollYr, SwisSBLKey]);

            {Figure out the homestead and non homestead assessed values.
             If this is not a classified swis, then the amount will
             be returned in the homestead assessed value.}

          CalculateHstdAndNonhstdAmounts(TaxRollYr, SwisSBLKey,
                                         AssessmentTable,
                                         ClassTable, ParcelTable,
                                         HstdAssessedVal, NonhstdAssessedVal,
                                         HstdLandVal, NonhstdLandVal,
                                         HstdAcres, NonhstdAcres,
                                         AssessmentRecordFound,
                                         ClassRecordFound);

            {CHG08021999-2: Add roll section 9 totals.}

          If (Found and
              (ParcelTable.FieldByName('ActiveFlag').Text <> InactiveParcelFlag) and
              (Deblank(ParcelTable.FieldByName('RollSection').Text) <> ''))
            then
              begin
                  {Calculate the total exemptions.}
                  {CHG12011997-2: STAR support}
                  {FXX02091998-1: Pass the residential type of each exemption.}

                EXAmounts := TotalExemptionsForParcel(TaxRollYr, SwisSBLKey,
                                                      ParcelExemptionTable,
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
                                                      BasicSTARAmount,
                                                      EnhancedSTARAmount);

                  {Now calculate the SD amounts for this parcel.}

                TotalSpecialDistrictsForParcel(TaxRollYr,
                                               SwisSBLKey,
                                               ParcelTable,
                                               AssessmentTable,
                                               ParcelSDTable,
                                               SDCodeTable,
                                               ParcelExemptionTable,
                                               ExemptionCodeTable,
                                               SDAmounts);

                GetHomesteadAndNonhstdExemptionAmounts(ExemptionCodes,
                                                       ExemptionHomesteadCodes,
                                                       CountyExemptionAmounts,
                                                       TownExemptionAmounts,
                                                       SchoolExemptionAmounts,
                                                       VillageExemptionAmounts,
                                                       HstdEXAmounts,
                                                       NonhstdEXAmounts);

(*                If (_Compare(RollSection, '8', coEqual) and
                    _Compare(((HstdAssessedVal + NonhstdAssessedVal) -
                              (HstdEXAmounts[EXTown] + NonhstdEXAmounts[EXTown])), 0, coGreaterThan))
                  then MessageDlg('RS 8 parcel with TV > 0.', mtError, [mbOK], 0); *)

                  {First update the swis roll totals.}
                  {FXX11051997-2: We need to update the roll totals even
                                  if the av is zero so that the parcel counts
                                  match.}

                HomesteadCode := Take(1, ParcelTable.FieldByName('HomesteadCode').Text);
                SplitParcel := (HomesteadCode = 'S');

                If (ParcelTable.FieldByName('RollSection').Text <> '9')
                  then
                    begin
                      If (HomesteadCode[1] in ['H', 'S', ' '])  {Is hstd, blnk, split.}
                        then
                          begin
                            TempHomesteadCode := HomesteadCode;

                              {If split, this is the hstd part.}

                            If (TempHomesteadCode = 'S')
                              then TempHomesteadCode := 'H';

                              {FXX02101999-4: Add land value to swis and school totals.}

                            UpdateSwisTotals(SwisList, TaxRollYr, SwisCode,
                                             RollSection, TempHomesteadCode,
                                             HstdLandVal, HstdAssessedVal, HstdEXAmounts,
                                             SplitParcel);

                          end;  {If (HomesteadCode[1] in ['H', 'S', ' ']}

                      If (HomesteadCode[1] in ['N', 'S'])  {Or is Nonhstd or split only.}
                        then
                          begin
                            TempHomesteadCode := HomesteadCode;

                              {If split, this is the Nonhstd part.}

                            If (TempHomesteadCode = 'S')
                              then TempHomesteadCode := 'N';

                              {FXX02101999-4: Add land value to swis and school totals.}

                            UpdateSwisTotals(SwisList, TaxRollYr, SwisCode,
                                             RollSection, TempHomesteadCode,
                                             NonhstdLandVal, NonhstdAssessedVal, NonhstdEXAmounts,
                                             SplitParcel);

                          end;  {If (HomesteadCode[1] in ['N', 'S'])}

                        {Next update the school roll totals.}
                        {CHG07291999-1: Add STAR values and taxable vals to on-line totals.
                                        Note that the STAR amounts always apply to hstd.}


                      If (HomesteadCode[1] in ['H', 'S', ' '])  {Is hstd, blnk, split.}
                        then
                          begin
                            TempHomesteadCode := HomesteadCode;

                              {If split, this is the hstd part.}

                            If (TempHomesteadCode = 'S')
                              then TempHomesteadCode := 'H';

                              {FXX02221998-1: The exemption amounts passed
                                              in should be the homestead and
                                              non-homestead.}
                              {FXX02101999-4: Add land value to swis and school totals.}

(*                            WritelnCommaDelimitedLine(ExtractFile,
                                                      [SwisSBLKey,
                                                       SchoolCode,
                                                       HstdAssessedVal]); *)

                            UpdateSchoolTotals(SchoolList, TaxRollYr, SwisCode,
                                               SchoolCode, TempHomesteadCode,
                                               HstdLandVal, HstdAssessedVal,
                                               SchoolRelevyAmount, HstdEXAmounts,
                                               BasicSTARAmount, EnhancedSTARAmount,
                                               SplitParcel);

                          end;  {If (HomesteadCode[1] in ['H', 'S', ' '])}

                      If (HomesteadCode[1] in ['N', 'S'])  {Is Nonhstd or split.}
                        then
                          begin
                            TempHomesteadCode := HomesteadCode;

                              {If split, this is the Nonhstd part.}
                              {FXX12151999-2: Don't double count school relevies for split parcels.}

                            If (TempHomesteadCode = 'S')
                              then
                                begin
                                  TempHomesteadCode := 'N';
                                  SchoolRelevyAmount := 0;
                                end;

                              {FXX02221998-1: The exemption amounts passed
                                              in should be the homestead and
                                              non-homestead.}
                              {FXX02101999-4: Add land value to swis and school totals.}

(*                            WritelnCommaDelimitedLine(ExtractFile,
                                                      [SwisSBLKey,
                                                       SchoolCode,
                                                       NonhstdAssessedVal]); *)

                            UpdateSchoolTotals(SchoolList, TaxRollYr, SwisCode,
                                               SchoolCode, TempHomesteadCode,
                                               NonhstdLandVal, NonhstdAssessedVal,
                                               SchoolRelevyAmount, NonhstdEXAmounts,
                                               BasicSTARAmount, EnhancedSTARAmount, SplitParcel);

                          end;  {If (HomesteadCode[1] in ['N', 'S'])}

                         {Now update each exemption.}
                         {CHG12011997-2: STAR support. Calculate the STAR
                                         exemption amounts seperately.}

                      For I := 0 to (ExemptionCodes.Count - 1) do
                      begin
                        (*If _Compare(ExemptionCodes[I], '41131', coEqual)
                        then Writeln(ExtractFile, SwisSBLKey, TownExemptionAmounts[I]); *)

                        UpdateExemptionTotals(EXCodeList, TaxRollYr, SwisCode,
                                              ExemptionCodes[I],
                                              ExemptionHomesteadCodes[I],
                                              StrToFloat(CountyExemptionAmounts[I]),
                                              StrToFloat(TownExemptionAmounts[I]),
                                              StrToFloat(SchoolExemptionAmounts[I]),
                                              StrToFloat(VillageExemptionAmounts[I]),
                                              SplitParcel);

                      end;

                        {CHG12011997-2: STAR support. Adjust STAR exemptions as separate since
                                        they are not stored in the SchoolExemptionAmounts.}

                        {FXX12041997-4: Record full, unadjusted STAR amount.}
                        {FXX05281998-2: Actually, record adjusted amount.}

                      If (Roundoff(BasicSTARAmount, 0) > 0)
                        then
                          begin
      (*                      CalculateSTARAmount(TaxRollYr, '41854', SwisCode,
                                                SwisCodeTable, ParcelTable,
                                                (NonhstdAssessedVal + HstdAssessedVal),
                                                SchoolExemptionAmounts,
                                                FullSTARAmount);

                               {If this is a coop or mobile home, use the amount that they
                                entered. If it is not, use the full amount, since it will
                                always be at least the full amount.}

                            If not PropertyIsCoopOrMobileHomePark(ParcelTable)
                              then BasicSTARAmount := FullSTARAmount; *)

                            UpdateExemptionTotals(ExCodeList, TaxRollYr, SwisCode,
                                                  '41854', ' ', 0, 0,
                                                  BasicSTARAmount, 0,
                                                  SplitParcel);

                          end;  {If (Roundoff(BasicSTARAmount, 0) > 0)}

                        {FXX12041997-4: Record full, unadjusted STAR amount.}

                      If (Roundoff(EnhancedSTARAmount, 0) > 0)
                        then
                          begin
      (*                      CalculateSTARAmount(TaxRollYr, '41834', SwisCode,
                                                SwisCodeTable, ParcelTable,
                                                (NonhstdAssessedVal + HstdAssessedVal),
                                                SchoolExemptionAmounts,
                                                FullSTARAmount);

                               {If this is a coop or mobile home, use the amount that they
                                entered. If it is not, use the full amount, since it will
                                always be at least the full amount.}

                            If not PropertyIsCoopOrMobileHomePark(ParcelTable)
                              then BasicSTARAmount := FullSTARAmount; *)

                            UpdateExemptionTotals(ExCodeList, TaxRollYr, SwisCode,
                                                   '41834', '', 0, 0,
                                                   EnhancedSTARAmount, 0,
                                                   SplitParcel);

                          end;  {If (Roundoff(EnhancedSTARAmount, 0) > 0)}

                    end;  {If (ParcelTable.FieldByName('RollSection').Text <> '9')}

                    {Now update each special district.}

                For I := 0 to (SDAmounts.Count - 1) do
                  with PParcelSDValuesRecord(SDAmounts[I])^ do
                    For J := 1 to 10 do
                      If (_Compare(SDValues[J], coNotBlank) and
                          _Compare(SDExtensionCodes[J], coNotBlank))
                        then UpdateSDTotals(SDCodeList, RS9List, TaxRollYr, SwisCode,
                                            ParcelTable.FieldByName('RollSection').Text,
                                            SDCode, SDExtensionCodes[J],
                                            SDCC_OMFlags[J], HomesteadCodes[J],
                                            SplitDistrict,
                                            StrToFloat(AssessedValues[J]),
                                            StrToFloat(SDValues[J]),
                                            SplitParcel);

              end  {If (Found and ...}
            else
              begin
                AssessedValue := AssessmentTable.FieldByName('TotalAssessedVal').AsFloat;
                TotalAssessedVal := TotalAssessedVal + AssessedValue;
              end;

        end;  {If not Done}

    Cancelled := ProgressDialog.Cancelled;

  until (Done or Cancelled);

  ExemptionCodes.Free;
  ExemptionHomesteadCodes.Free;
  ResidentialTypes.Free;
  CountyExemptionAmounts.Free;
  TownExemptionAmounts.Free;
  SchoolExemptionAmounts.Free;
  VillageExemptionAmounts.Free;
  ClearTList(SDAmounts, SizeOf(ParcelSDValuesRecord));
  FreeTList(SDAmounts, SizeOf(ParcelSDValuesRecord));

  (*CloseFile(ExtractFile); *)

    {Now store the roll totals if we ran to completion.}

  If Done
    then
      begin
        CallingForm.Cursor := crHourglass;
        Application.ProcessMessages;
        StoreRollTotals(ProcessingType, TaxRollYr, SwisList, SchoolList, EXCodeList,
                        SDCodeList, VillageRelevyList, RS9List);
        CallingForm.Cursor := crDefault;

      end;  {If Done}

  If Cancelled
    then MessageDlg('The roll totals calculation was cancelled.', mtWarning, [mbOK], 0);

    {CHG05072009-1(2.20.1.1)[F414]: Log roll totals calculation.}

  If Cancelled
    then sResult := 'Cancelled'
    else sResult := 'Successful';

  _InsertRecord(tbAudit,
                ['Date', 'LabelName', 'NewValue', 'LabelName',
                 'TaxRollYr', 'Time', 'User'],
                [DateToStr(Date), 'Roll Total Calc', 'End', sResult,
                 TaxRollYr, TimeToStr(Now), GlblUserName], []);

    {Free up the totals TLists.}

  FreeTList(SwisList, SizeOf(RtSwis));
  FreeTList(SchoolList, SizeOf(RTSchoolRec));
  FreeTlist(ExCodeList, SizeOf(RTEXCode));
  FreeTlist(SDCodeList, SizeOf(RTSDCode));
  FreeTlist(RS9List, SizeOf(RTRS9));
  FreeTList(VillageRelevyList, SizeOf(RTVillageRelevyRec));

  If ShowCompletionMessage
    then
      If Done
        then MessageDlg('The roll totals were calculated successfully.',
                        mtInformation, [mbOK], 0)
        else MessageDlg('The roll totals were NOT calculated successfully.' + #13 +
                        'Please try again.', mtError, [mbOK], 0);

(*  Writeln(ErrorFile, FormatFloat(CurrencyDisplayNoDollarSign, TotalAssessedVal));
  CloseFile(ErrorFile);*)

  AssessmentTable.Close;
  ParcelTable.Close;
  ParcelExemptionTable.Close;
  SDCodeTable.Close;
  ParcelSDTable.Close;
  ExemptionCodeTable.Close;
  ClassTable.Close;
  SwisCodeTable.Close;
  tbAudit.Close;

  AssessmentTable.Free;
  ParcelTable.Free;
  ParcelExemptionTable.Free;
  SDCodeTable.Free;
  ParcelSDTable.Free;
  ExemptionCodeTable.Free;
  ClassTable.Free;
  SwisCodeTable.Free;
  tbAudit.Free;

  ProgressDialog.Finish;

end;  {CreateRollTotals}

{========================================================================}
Procedure TRollTotalCalculateForm.StartButtonClick(Sender: TObject);

var
  ProcessingType : Integer;  {This Year, NextYear}
  TaxRollYr : String;

begin
  ProcessingType := GlblProcessingType;
  
  case ProcessingYearRadioGroup.ItemIndex of
    0 : begin
          ProcessingType := ThisYear;
          TaxRollYr := GlblThisYear;
        end;

    1 : begin
          ProcessingType := NextYear;
          TaxRollYr := GlblNextYear;
        end;

    2 : begin
          ProcessingType := History;
          TaxRollYr := HistoryEdit.Text;
        end;

  end;  {case ProcessingYearRadioGroup.ItemIndex of}

  CreateRollTotals(ProcessingType, TaxRollYr, ProgressDialog, Self, False, True);

end;  {StartButtonClick}

{===================================================================}
Procedure TRollTotalCalculateForm.FormClose(    Sender: TObject;
                                            var Action: TCloseAction);

{Close all tables and free all lists.}

begin
    {Free up the child window and set the ClosingAForm Boolean to
     true so that we know to delete the tab.}

  Action := caFree;
  GlblClosingAForm := True;
  GlblClosingFormCaption := Caption;

end;  {FormClose}



end.