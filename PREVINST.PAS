unit Previnst;

 interface

 uses
  WinTypes, WinProcs, SysUtils;

 type
  PHWND = ^HWND;
  function EnumFunc(Wnd:HWND; TargetWindow:PHWND): bool; export;
  procedure GotoPreviousInstance;

 implementation

  function EnumFunc(Wnd:HWND; TargetWindow:PHWND): bool;
  var
    ClassName : array[0..30] of char;
  begin
    Result := true;
    if GetWindowWord(Wnd,GWW_HINSTANCE) = hPrevInst then
       begin
       GetClassName(Wnd,ClassName,30);
       if StrIComp(ClassName,'TApplication') = 0 then
          begin
          TargetWindow^ := Wnd;
          Result := false;
          end;
       end;
  end;

  procedure GotoPreviousInstance;
  var
    PrevInstWnd : HWND;
  begin
    PrevInstWnd := 0;
    EnumWindows(@EnumFunc,longint(@PrevInstWnd));
    if PrevInstWnd <> 0 then
       if IsIconic(PrevInstWnd) then
          ShowWindow(PrevInstWnd,SW_RESTORE)
       else
          BringWindowToTop(PrevInstWnd);
  end;

  end.

