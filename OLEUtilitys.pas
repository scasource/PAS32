unit OLEUtilitys;

interface

procedure InitWP;
procedure DoneWP;
procedure OpenWPTemplate (WpFilename:string);
procedure OpenWPFile (FileName : string);
procedure CloseWPDocument(WpFileName:string);
function FindFieldInWPDocument():string;
procedure TypeTextInWP (aText : string);

var
   objWP : variant;

implementation

uses ComObj, SysUtils;

procedure InitWP;
begin
   if varIsEmpty (objWP) then
      ObjWP := CreateOleObject('WordPerfect.PerfectScript');
end;

procedure DoneWP;
begin
   ObjWP := unassigned;
end;

procedure OpenWPTemplate (WpFilename:string);
begin
    InitWP;
//    p := MainForm.TemplateFolder + WPFilename;
    ObjWP.FileOpen( WPFilename, 4 );
    ObjWP.Quit;
end;

procedure CloseWPDocument(WpFileName:string);
var
   p : string;
begin
    InitWP;
    p := WpFilename;
    objWP.FileSave( p , 4 , 2 );
    objWP.CloseNoSave (0);
    ObjWP.Quit;
end;

function FindFieldInWPDocument():string;
var
   s : string;
   PosStart, PosEnd: integer;
begin
   InitWP;
   try
        ObjWP.SearchString( '<<' );
        ObjWP.SearchNext(  0 );
        PosStart:= ObjWP.EnvGetSelStartEx;
        ObjWP.SearchString ('>>')  ;
        ObjWP.SearchNext (0 );
        PosEnd := ObjWP.EnvGetSelEndEx;
        ObjWP.SetSelEx( PosStart ,PosEnd );
        s := ObjWP.EnvGetSelTextEx;

        delete (s, 1, 2);
        setlength (s, length(s)-2);

     except
        on exception do
        begin
           s := '';
        end;
     end;
   result := s;
   ObjWP.Quit;
end;

procedure OpenWPFile (FileName : string);
begin
   InitWP;
   try
      ObjWP.FileOpen (FileName);
      ObjWP.AppMaximize;
   except
      on exception do ; // ignore exceptions
   end;
   ObjWP.Quit;
end;
procedure TypeTextInWP (aText : string);
begin
   InitWP;
   try
        ObjWP.Type (aText);
   except
      on exception do ; // ignore exceptions
   end;
   ObjWP.Quit;
end;

end.
