unit Utw_cap;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Dll96v1,
  StdCtrls;

type
  TTwainCaps = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    eMinValue: TEdit;
    eMaxValue: TEdit;
    eStepSize: TEdit;
    eDefaultValue: TEdit;
    eCurrentValue: TEdit;
    lMinValue: TLabel;
    LMaxValue: TLabel;
    LStepSize: TLabel;
    LDefaultValue: TLabel;
    LCurrentValue: TLabel;
    Label4: TLabel;
    eSmallInt: TEdit;
    lSmallInt: TLabel;
    eLongint: TEdit;
    LLongint: TLabel;
    eDouble: TEdit;
    lDouble: TLabel;
    eBoolean: TEdit;
    LBoolean: TLabel;
    LPchar: TLabel;
    EPchar: TEdit;
    EMeaning: TEdit;
    LMeaning: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
    CapList : TList;
  public
    { Public declarations }
  procedure FreeCapList;
  Function GetStrValueOfCap(Capabil : SmallInt; Value : SmallInt) : String;
  function Caps(CapChar        : PChar;
                CapShort       : SmallInt;
                CapLong        : LongInt;
                CapFloat       : Double;
                TWON           : SmallInt;
                TWTYPE         : SmallInt;
                RgMinValue     : LongInt;
                RgMaxValue     : LongInt;
                RgStepSize     : LongInt;
                RgDefaultValue : LongInt;
                RgCurrentValue : LongInt;
                Capabil        : SmallInt) : SmallInt;
  end;

var
  TwainCaps: TTwainCaps;

implementation

{$R *.DFM}

function CapsCallBackfunction (CapChar        : PChar;
                               CapShort       : SmallInt;
                               CapLong        : LongInt;
                               CapFloat       : Double;
                               TWON           : SmallInt;
                               TWTYPE         : SmallInt;
                               RgMinValue     : LongInt;
                               RgMaxValue     : LongInt;
                               RgStepSize     : LongInt;
                               RgDefaultValue : LongInt;
                               RgCurrentValue : LongInt;
                               Capabil        : SmallInt;
                               d_object       : longint) : SmallInt; CDECL; export;
begin
     result:=0;
     if d_object <> 0 then result:=TTwainCaps(d_object).Caps(CapChar,
                                                             CapShort,
                                                             CapLong,
                                                             CapFloat,
                                                             TWON,
                                                             TWTYPE,
                                                             RgMinValue,
                                                             RgMaxValue,
                                                             RgStepSize,
                                                             RgDefaultValue,
                                                             RgCurrentValue,
                                                             Capabil);
end;


function TTwainCaps.Caps(CapChar        : PChar;
                         CapShort       : SmallInt;
                         CapLong        : LongInt;
                         CapFloat       : Double;
                         TWON           : SmallInt;
                         TWTYPE         : SmallInt;
                         RgMinValue     : LongInt;
                         RgMaxValue     : LongInt;
                         RgStepSize     : LongInt;
                         RgDefaultValue : LongInt;
                         RgCurrentValue : LongInt;
                         Capabil        : SmallInt) : SmallInt;
var
 MyCap      : PCapRecord;
begin
 New(MyCap);
 with MyCap^ do begin
    _CapChar       :=String(CapChar);
    _CapShort      :=CapShort;
    _CapLong       :=CapLong;
    _CapFloat      :=CapFloat;
    _TWON          :=TWON;
    _TWTYPE        :=TWTYPE;
    _RgMinValue    :=RgMinValue;
    _RgMaxValue    :=RgMaxValue;
    _RgStepSize    :=RgStepSize;
    _RgDefaultValue:=RgDefaultValue;
    _RgCurrentValue:=RgCurrentValue;
    _Capabil       :=Capabil;
 end;
 CapList.Add(MyCap);
 ListBox1.Items.Add(GetTwainCapName(Capabil));
 result:=1;
end;


procedure TTwainCaps.Button1Click(Sender: TObject);
var
 Capp : Array[0..255] of SmallInt;
begin
 Capp[0]:=CAP_XFERCOUNT;
 Capp[1]:=ICAP_COMPRESSION;
 Capp[2]:=ICAP_PIXELTYPE;
 Capp[3]:=ICAP_UNITS;
 Capp[4]:=ICAP_XFERMECH;
 Capp[5]:=CAP_AUTHOR;
 Capp[6]:=CAP_CAPTION;
 Capp[7]:=CAP_FEEDERENABLED;
 Capp[8]:=CAP_FEEDERLOADED;
 Capp[9]:=CAP_TIMEDATE;
 Capp[10]:=CAP_EXTENDEDCAPS;
 Capp[11]:=CAP_AUTOFEED;
 Capp[12]:=CAP_CLEARPAGE;
 Capp[13]:=CAP_FEEDPAGE;
 Capp[14]:=CAP_REWINDPAGE;
 Capp[15]:=CAP_INDICATORS;
 Capp[16]:=CAP_SUPPORTEDCAPSEXT;
 Capp[17]:=CAP_PAPERDETECTABLE;
 Capp[18]:=CAP_UICONTROLLABLE;
 Capp[19]:=CAP_DEVICEONLINE;
 Capp[20]:=CAP_AUTOSCAN;
 Capp[21]:=CAP_THUMBNAILSENABLED;
 Capp[22]:=CAP_DUPLEX;
 Capp[23]:=CAP_DUPLEXENABLED;
 Capp[24]:=CAP_ENABLEDSUIONLY;
 Capp[25]:=CAP_CUSTOMDSDATA;
 Capp[26]:=CAP_ENDORSER;
 Capp[27]:=CAP_JOBCONTROL;
 Capp[28]:=ICAP_AUTOBRIGHT;
 Capp[29]:=ICAP_BRIGHTNESS;
 Capp[30]:=ICAP_CONTRAST;
 Capp[31]:=ICAP_CUSTHALFTONE;
 Capp[32]:=ICAP_EXPOSURETIME;
 Capp[33]:=ICAP_FILTER;
 Capp[34]:=ICAP_FLASHUSED;
 Capp[35]:=ICAP_GAMMA;
 Capp[36]:=ICAP_HALFTONES;
 Capp[37]:=ICAP_HIGHLIGHT;
 Capp[38]:=ICAP_IMAGEFILEFORMAT;
 Capp[39]:=ICAP_LAMPSTATE;
 Capp[40]:=ICAP_LIGHTSOURCE;
 Capp[41]:=ICAP_ORIENTATION;
 Capp[42]:=ICAP_PHYSICALWIDTH;
 Capp[43]:=ICAP_PHYSICALHEIGHT;
 Capp[44]:=ICAP_SHADOW;
 Capp[45]:=ICAP_FRAMES;
 Capp[46]:=ICAP_XNATIVERESOLUTION;
 Capp[47]:=ICAP_YNATIVERESOLUTION;
 Capp[48]:=ICAP_XRESOLUTION;
 Capp[49]:=ICAP_YRESOLUTION;
 Capp[50]:=ICAP_MAXFRAMES;
 Capp[51]:=ICAP_TILES;
 Capp[52]:=ICAP_BITORDER;
 Capp[53]:=ICAP_CCITTKFACTOR;
 Capp[54]:=ICAP_LIGHTPATH;
 Capp[55]:=ICAP_PIXELFLAVOR;
 Capp[56]:=ICAP_PLANARCHUNKY;
 Capp[57]:=ICAP_ROTATION;
 Capp[58]:=ICAP_SUPPORTEDSIZES;
 Capp[59]:=ICAP_THRESHOLD;
 Capp[60]:=ICAP_XSCALING;
 Capp[61]:=ICAP_YSCALING;
 Capp[62]:=ICAP_BITORDERCODES;
 Capp[63]:=ICAP_PIXELFLAVORCODES;
 Capp[64]:=ICAP_JPEGPIXELTYPE;
 Capp[65]:=ICAP_TIMEFILL;
 Capp[66]:=ICAP_BITDEPTH;
 Capp[67]:=ICAP_BITDEPTHREDUCTION;
 Capp[68]:=ICAP_UNDEFINEDIMAGESIZE;
 Capp[69]:=ICAP_IMAGEDATASET;
 Capp[70]:=ICAP_EXTIMAGEINFO;
 Capp[71]:=ICAP_MINIMUMHEIGHT;
 Capp[72]:=ICAP_MINIMUMWIDTH;

 FreeCapList;
 ListBox1.Clear;
 Screen.Cursor:=crHourGlass;
 GetTwainCapabilities(@Capp, 73,  LongInt(Self), CapsCallBackfunction);
 Screen.Cursor:=crDefault;
end;

procedure TTwainCaps.FormCreate(Sender: TObject);
begin
     CapList :=TList.Create;
end;

procedure TTwainCaps.FreeCapList;
Var
 I      : Integer;
begin
 for i:=CapList.Count-1 downto 0 do begin
    Dispose(PCapRecord(CapList.Items[i]));
    CapList.Items[i]:=nil;
 end;
 CapList.Pack;
end;


procedure TTwainCaps.FormDestroy(Sender: TObject);
begin
     FreeCapList;
     CapList.Free;
end;

procedure TTwainCaps.ListBox1Click(Sender: TObject);
var
 MyCap  : PCapRecord;
begin
  //get pointer Caprecord from list
  MyCap:= CapList.Items[ListBox1.ItemIndex];
  //Reset Values
  eMinValue.Visible:=False;
  eMaxValue.Visible:=False;
  eStepSize.Visible:=False;
  eDefaultValue.Visible:=False;
  eCurrentValue.Visible:=False;
  lMinValue.Visible:=False;
  lMaxValue.Visible:=False;
  lStepSize.Visible:=False;
  lDefaultValue.Visible:=False;
  lCurrentValue.Visible:=False;
  Label4.Visible:=False;
  eSmallInt.Visible:=False;
  lSmallInt.Visible:=False;
  eLongint.Visible:=False;
  LLongint.Visible:=False;
  eDouble.Visible:=False;
  lDouble.Visible:=False;
  eBoolean.Visible:=False;
  LBoolean.Visible:=False;
  LPchar.Visible:=False;
  EPchar.Visible:=False;
  EMeaning.Visible:=False;
  LMeaning.Visible:=False;

  //Set Data Type
  case MyCap^._TWTYPE of
    TWTY_INT32  : Begin
                       Edit1.Text:='TWTY_IN32';
                       eLongint.Visible:=True;
                       LLongint.Visible:=True;
                       eLongint.Text:=IntToStr(MyCap^._CapLong);
                       EMeaning.Text:=GetStrValueOfCap(MyCap^._Capabil, MyCap^._CapLong);
                       If EMeaning.Text <>'' then begin
                          EMeaning.Visible:=True;
                          LMeaning.Visible:=True;
                       end;
                  end;
    TWTY_UINT32 : Begin
                       Edit1.Text:='TWTY_UINT32';
                       eLongint.Visible:=True;
                       LLongint.Visible:=True;
                       eLongint.Text:=IntToStr(MyCap^._CapLong);
                       EMeaning.Text:=GetStrValueOfCap(MyCap^._Capabil, MyCap^._CapLong);
                       If EMeaning.Text <>'' then begin
                          EMeaning.Visible:=True;
                          LMeaning.Visible:=True;
                       end;
                  end;
    TWTY_INT8   : Begin
                       Edit1.Text:='TWTY_INT8';
                       eSmallInt.Visible:=True;
                       lSmallInt.Visible:=True;
                       eSmallInt.Text:=IntToStr(MyCap^._CapShort);
                       EMeaning.Text:=GetStrValueOfCap(MyCap^._Capabil, MyCap^._CapShort);
                       If EMeaning.Text <>'' then begin
                          EMeaning.Visible:=True;
                          LMeaning.Visible:=True;
                       end;
                  end;
    TWTY_INT16  : Begin
                       Edit1.Text:='TWTY_INT16';
                       eSmallInt.Visible:=True;
                       lSmallInt.Visible:=True;
                       eSmallInt.Text:=IntToStr(MyCap^._CapShort);
                       EMeaning.Text:=GetStrValueOfCap(MyCap^._Capabil, MyCap^._CapShort);
                       If EMeaning.Text <>'' then begin
                          EMeaning.Visible:=True;
                          LMeaning.Visible:=True;
                       end;
                  end;
    TWTY_UINT8  : Begin
                       Edit1.Text:='TWTY_UINT8';
                       eSmallInt.Visible:=True;
                       lSmallInt.Visible:=True;
                       eSmallInt.Text:=IntToStr(MyCap^._CapShort);
                       EMeaning.Text:=GetStrValueOfCap(MyCap^._Capabil, MyCap^._CapShort);
                       If EMeaning.Text <>'' then begin
                          EMeaning.Visible:=True;
                          LMeaning.Visible:=True;
                       end;
                  end;
    TWTY_UINT16 : Begin
                       Edit1.Text:='TWTY_UINT16';
                       eSmallInt.Visible:=True;
                       lSmallInt.Visible:=True;
                       eSmallInt.Text:=IntToStr(MyCap^._CapShort);
                       EMeaning.Text:=GetStrValueOfCap(MyCap^._Capabil, MyCap^._CapShort);
                       If EMeaning.Text <>'' then begin
                          EMeaning.Visible:=True;
                          LMeaning.Visible:=True;
                       end;
                  end;
    TWTY_BOOL   : Begin
                       Edit1.Text:='TWTY_BOOL';
                       eBoolean.Visible:=True;
                       LBoolean.Visible:=True;
                       if MyCap^._CapShort = 0 then eBoolean.Text:='FALSE' else eBoolean.Text:='TRUE'
                  end;
    TWTY_FIX32  : Begin
                       Edit1.Text:='TWTY_FIX32';
                       eDouble.Visible:=True;
                       lDouble.Visible:=True;
                       eDouble.Text:=FloatToStr(MyCap^._CapFloat);
                  end;
    TWTY_FRAME  : Begin
                       Edit1.Text:='TWTY_FRAME';
                  end;
    TWTY_STR32  : Begin
                       Edit1.Text:='TWTY_STR32';
                       LPchar.Visible:=True;
                       EPchar.Visible:=True;
                       EPchar.Text:=MyCap^._CapChar;
                  end;
    TWTY_STR64  : Begin
                       Edit1.Text:='TWTY_STR64';
                       LPchar.Visible:=True;
                       EPchar.Visible:=True;
                       EPchar.Text:=MyCap^._CapChar;
                  end;
    TWTY_STR128 : Begin
                       Edit1.Text:='TWTY_STR128';
                       LPchar.Visible:=True;
                       EPchar.Visible:=True;
                       EPchar.Text:=MyCap^._CapChar;
                  end;
    TWTY_STR255 : Begin
                       Edit1.Text:='TWTY_STR255';
                       LPchar.Visible:=True;
                       EPchar.Visible:=True;
                       EPchar.Text:=MyCap^._CapChar;
                  end;
  end;


  //Set Container type
  case MyCap^._TWON of
       TWON_ARRAY:       begin
                              Edit2.Text:='TWON_ARRAY';
                         end;
       TWON_ENUMERATION: begin
                              Edit2.Text:='TWON_ENUMERATION';
                         end;
       TWON_ONEVALUE:    begin
                              Edit2.Text:='TWON_ONEVALUE';
                         end;
       TWON_RANGE:       begin
                              eDouble.Visible:=False;
                              lDouble.Visible:=False;
                              eLongint.Visible:=False;
                              LLongint.Visible:=False;
                              Edit2.Text:='TWON_RANGE';
                              eMinValue.Text:=IntToStr(MyCap^._RgMinValue);
                              eMaxValue.Text:=IntToStr(MyCap^._RgMaxValue);
                              eStepSize.Text:=IntToStr(MyCap^._RgStepSize);
                              eDefaultValue.Text:=IntToStr(MyCap^._RgDefaultValue);
                              eCurrentValue.Text:=IntToStr(MyCap^._RgCurrentValue);
                              eMinValue.Visible:=True;
                              eMaxValue.Visible:=True;
                              eStepSize.Visible:=True;
                              eDefaultValue.Visible:=True;
                              eCurrentValue.Visible:=True;
                              lMinValue.Visible:=True;
                              lMaxValue.Visible:=True;
                              lStepSize.Visible:=True;
                              lDefaultValue.Visible:=True;
                              lCurrentValue.Visible:=True;
                              Label4.Visible:=True;
                         end;
  end;

end;


Function TTwainCaps.GetStrValueOfCap(Capabil : SmallInt; Value : SmallInt) : String;
begin
   Result:='';
    Case Capabil of
        ICAP_BITDEPTHREDUCTION:
                               Case Value of
                                     0: Result:='TWBR_THRESHOLD';
                                     1: Result:='TWBR_HALFTONE';
                                     2: Result:='TWBR_CUSTHALFTONE';
                                     3: Result:='TWBR_DIFFUSION';
                                 end;

        ICAP_BITDEPTH:         Result:='Possible Bits per Pixels of ICAP_PIXELTYPE';

        ICAP_BITORDER:
                               Case Value of
                                     0: Result:='LSB_FIRST (Least Significant Byte first';
                                     1: Result:='MSB_FIRST (Most Significant Byte first';
                                 end;

        ICAP_BITORDERCODES:
                               Case Value of
                                     0: Result:='LSB_FIRST (CCITT Only. Least Significant Byte first';
                                     1: Result:='MSB_FIRST (CCITT Only. Most Significant Byte first';
                                 end;

        ICAP_COMPRESSION:
                               Case Value of
                                     0: Result:='Device can Hardware Compress to NONE';
                                     1: Result:='Device can Hardware Compress to PACKBITS';
                                     2: Result:='Device can Hardware Compress to GROUP31D';
                                     3: Result:='Device can Hardware Compress to GROUP31DEOL';
                                     4: Result:='Device can Hardware Compress to GROUP32D';
                                     5: Result:='Device can Hardware Compress to GROUP4';
                                     6: Result:='Device can Hardware Compress to JPEG';
                                     7: Result:='Device can Hardware Compress to LZW';
                                 end;

        ICAP_FILTER:
                               Case Value of
                                     0: Result:='Can Subtract RED';
                                     1: Result:='Can Subtract GREEN';
                                     2: Result:='Can Subtract BLUE';
                                     3: Result:='Can Subtract NONE';
                                     4: Result:='Can Subtract WHITE';
                                     5: Result:='Can Subtract CYAN';
                                     6: Result:='Can Subtract MAGENTA';
                                     7: Result:='Can Subtract YELLOW';
                                     8: Result:='Can Subtract BLACK';
                                 end;

        ICAP_IMAGEFILEFORMAT:
                               Case Value of
                                     0: Result:='Device can Hardware Compress to TIFF Tagged Image File Format';
                                     1: Result:='Device can Hardware Compress to PICT Macintosh PICT';
                                     2: Result:='Device can Hardware Compress to BMP Windows Bitmap';
                                     3: Result:='Device can Hardware Compress to XBM X-Windows Bitmap';
                                     4: Result:='Device can Hardware Compress to JFIF JPEG File Interchange Format';
                                 end;

        ICAP_JPEGPIXELTYPE:
                               Case Value of
                                     0: Result:='Support Jpeg Color Descriptor of BW';
                                     1: Result:='Support Jpeg Color Descriptor of GRAY';
                                     2: Result:='Support Jpeg Color Descriptor of RGB';
                                     3: Result:='Support Jpeg Color Descriptor of PALETTE';
                                     4: Result:='Support Jpeg Color Descriptor of CMY';
                                     5: Result:='Support Jpeg Color Descriptor of CMYK';
                                     6: Result:='Support Jpeg Color Descriptor of YUV';
                                     7: Result:='Support Jpeg Color Descriptor of YUVK';
                                     8: Result:='Support Jpeg Color Descriptor of CIEXYZ';
                                 end;

        ICAP_LIGHTPATH:
                               Case Value of
                                     0: Result:='Can Capture Image REFLECTIVE';
                                     1: Result:='Can Capture Image TRANSMISSIVE';
                                 end;

        ICAP_LIGHTSOURCE:
                               Case Value of
                                     0: Result:='Can Apply Light Source of RED';
                                     1: Result:='Can Apply Light Source of GREEN';
                                     2: Result:='Can Apply Light Source of BLUE';
                                     3: Result:='Can Apply Light Source of NONE';
                                     4: Result:='Can Apply Light Source of WHITE';
                                     5: Result:='Can Apply Light Source of UV';
                                     6: Result:='Can Apply Light Source of IR';
                                 end;

        ICAP_ORIENTATION:
                               Case Value of
                                     0: Result:='Device Can Rotate 0 Degrees (Portait)';
                                     1: Result:='Device Can Rotate 90 Degrees';
                                     2: Result:='Device Can Rotate 180 Degrees';
                                     3: Result:='Device Can Rotate 270 Degrees (LandScape)';
                                 end;

        ICAP_PIXELFLAVOR:
                               Case Value of
                                     0: Result:='Make darkest pixel CHOCOLATE';
                                     1: Result:='Make lightest pixel VANILLA';
                                 end;

        ICAP_PIXELFLAVORCODES:
                               Case Value of
                                     0: Result:='CCITT Only. Make darkest pixel CHOCOLATE';
                                     1: Result:='CCITT Only. Make lightest pixel VANILLA';
                                 end;

        ICAP_PIXELTYPE:
                               Case Value of
                                     0: Result:='Device Supports BW Compression';
                                     1: Result:='Device Supports GRAY Compression';
                                     2: Result:='Device Supports RGB Compression';
                                     3: Result:='Device Supports PALETTE Compression';
                                     4: Result:='Device Supports CMY Compression';
                                     5: Result:='Device Supports CMYK Compression';
                                     6: Result:='Device Supports YUV Compression';
                                     7: Result:='Device Supports YUVK Compression';
                                     8: Result:='Device Supports CIEXYZ Compression';
                                 end;

        ICAP_PLANARCHUNKY:
                               Case Value of
                                     0: Result:='Color Identify is CHUNKY';
                                     1: Result:='Color Identify is PLANAR';
                                 end;

        ICAP_SUPPORTEDSIZES:
                               Case Value of
                                     0: Result:='Device Supports Size NONE';
                                     1: Result:='Device Supports Size A4LETTER';
                                     2: Result:='Device Supports Size B5LETTER';
                                     3: Result:='Device Supports Size USLETTER';
                                     4: Result:='Device Supports Size USLEGAL';
                                     5: Result:='Device Supports Size A5';
                                     6: Result:='Device Supports Size B4';
                                     7: Result:='Device Supports Size B6';
                                     8: Result:='Device Supports Size B';
                                     9: Result:='Device Supports Size USLEDGER';
                                    10: Result:='Device Supports Size USEXECUTIVE';
                                    11: Result:='Device Supports Size A3';
                                    12: Result:='Device Supports Size B3';
                                    13: Result:='Device Supports Size A6';
                                    14: Result:='Device Supports Size C4';
                                    15: Result:='Device Supports Size C5';
                                    16: Result:='Device Supports Size C6';

                                 end;

        ICAP_UNITS:
                               Case Value of
                                     0: Result:='Device Supports Measure Units of INCHES';
                                     1: Result:='Device Supports Measure Units of CENTIMETERS';
                                     2: Result:='Device Supports Measure Units of PICAS';
                                     3: Result:='Device Supports Measure Units of POINTS';
                                     4: Result:='Device Supports Measure Units of TWIPS';
                                     5: Result:='Device Supports Measure Units of PIXELS';
                                 end;

        ICAP_XFERMECH:
                               Case Value of
                                     0: Result:='Device Supports the image transfer Natively (DIB)';
                                     1: Result:='Device Supports the image transfer To File (TIF , JPG, Etc.)';
                                     2: Result:='Device Supports the image transfer To Memory (TIF , JPG, Etc.)';
                                 end;

        CAP_JOBCONTROL:
                               Case Value of
                                     0: Result:='No job control';
                                     1: Result:='Detect and include job separator and continue scanning';
                                     2: Result:='Detect and include job separator and stop scanning';
                                     3: Result:='Detect and exclude job separator and continue scanning';
                                     4: Result:='Detect and exclude job separator and stop scanning';
                                 end;

    end;


end;


end.

