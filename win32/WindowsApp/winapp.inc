; The POINT structure specifies the X and Y coordinates of a point on the screen, measured in
; pixels. It can be used, for example, to locate graphic objects, windows, and mouse clicks:
POINT STRUCT
        ptX         DWORD ?
        ptY         DWORD ?
POINT ENDS

; The MSGStruct structure defines the data needed for an MS-Windows message
MSGStruct STRUCT
        msgWnd      DWORD ?
        msgMessage  DWORD ?
        msgWparam   DWORD ?
        msgLparam   DWORD ?
        msgTime     DWORD ?
        msgPt       POINT <>
MSGStruct ENDS

; The WNDCLASS structure defines a window class. Each window in a program must belong
; to a class, and each program must define a window class for its main window. This class is registered
; with the operating system before the main window can be shown
WNDCLASS STRUCT
        style       DWORD ? ; window style options
        lpfnWinProc DWORD ? ; pointer to WinProc function
        cbClsExtra  DWORD ? ; shared memory
        cbWndExtra  DWORD ? ; number of extra bytes
        hInstance   DWORD ? ; handle to current program
        hIcon       DWORD ? ; handle to icon
        hCursor     DWORD ? ; handle to cursor
        hbrBackground DWORD ? ; handle to background brush
        lpszMenuName DWORD ? ; pointer to menu name
        lpszClassName DWORD ? ; pointer to WinClass name
WNDCLASS ENDS
; • style is a conglomerate of different style options, such as WS_CAPTION and WS_BORDER,
;   that control the window’s appearance and behavior.
; • lpfnWndProc is a pointer to a function (in our program) that receives and processes event mes-
;   sages triggered by the user.
; • cbClsExtra refers to shared memory used by all windows belonging to the class. Can be null.
; • cbWndExtra specifies the number of extra bytes to allocate following the window instance.
; • hInstance holds a handle to the current program instance.
; • hIcon and hCursor hold handles to icon and cursor resources for the current program.
; • hbrBackground holds a handle to a background (color) brush.
; • lpszMenuName points to a menu name.
; • lpszClassName points to a null-terminated string containing the window’s class name.

; This basically gets a handle to the current process, so that we can pass it into our WNDCLASS when we build it.
; remember all windows have to be children of the main process
GetModuleHandleA PROTO,
    pString:PTR BYTE


; we need to manually load the cursor I guess? Maybe it's the cursor icon?
LoadCursorA PROTO,  ; load a cursor resource
    hInstance:DWORD,
    pString:PTR BYTE

; Load the program Icon
LoadIconA PROTO,    ; loan an icon resource
    hInstance:DWORD,
    pString:PTR BYTE


RegisterClassA PROTO,   ; register a new window class
    pWndClass:PTR WNDCLASS


; This is called after RegisterClassA
CreateWindowExA PROTO,  ; create and register a window class (thi is what the book says, but isn't it arleady registered?)
    exWinStyle:DWORD,
    className:PTR BYTE,
    winName:PTR BYTE,
    winStyle:DWORD,
    X:DWORD,
    Y:DWORD,
    rWidth:DWORD,
    rHeight:DWORD,
    hWndParent:DWORD,
    hMenu:DWORD,
    hInstance:DWORD,
    lpParam:DWORD


;Window style I'm stealing from the book, too much to keep track of
WS_VISIBLE          =     10000000h
WS_DLGFRAME         =     00400000h
WS_BORDER           =     00800000h
WS_CAPTION          =     WS_BORDER+WS_DLGFRAME
WS_SYSMENU          =     00080000h
WS_MAXIMIZEBOX      =     00010000h
WS_MINIMIZEBOX      =     00020000h
WS_THICKFRAME       =     00040000h
MAIN_WINDOW_STYLE = WS_VISIBLE + WS_DLGFRAME + WS_CAPTION + WS_BORDER + WS_SYSMENU  + WS_MAXIMIZEBOX + WS_MINIMIZEBOX + WS_THICKFRAME

; To show the window we registered and created
ShowWindow PROTO,   ; show a window
    hWnd:DWORD,
    showState:DWORD

; I guess we have to redraw it? I wonder why
UpdateWindow PROTO, ; draw(redraw) a window
    hWnd:DWORD


MessageBoxA     PROTO, 
                    hWnd:DWORD,                         ; handle of the window, can be null since we're using console
                    lpText:PTR BYTE,                    ; the string inside of the box
                    lpCaption:PTR BYTE,                 ; string, dialog box title
                    uType:DWORD                         ; contents and behavior

; This gets the next message from the window
GetMessageA PROTO,
    lpMsg:PTR BYTE,         ; Store the message locally
    hWnd:DWORD,             ; I think this is used to specify different windows?
    firstMsg:DWORD,
    lastMsg:DWORD

DispatchMessageA PROTO, ; dispatch a message to the application. I think this sends the message to the kernel, 
     pMsg:PTR BYTE      ; which then forwards it to our message handler outlined in the struct we used to create the window
    
PostQuitMessage PROTO,  ; tell Windows to terminate the app
    exitCode:DWORD

DefWindowProcA PROTO,   ; default Windows message handler
    hWnd:DWORD,
    locMsg:DWORD,
    wParam:DWORD,
    lParam:DWORD

GetLastError   PROTO    ; windows procedure

;    string explaining the error. To do that, call the FormatMessage function
FormatMessageA PROTO,
                dwFlags:DWORD,
                lpSource:DWORD,
                dwMsgID:DWORD,
                dwLanguageID:DWORD,
                lpBuffer:PTR BYTE,
                nSize:DWORD,
                va_list:DWORD

LocalFree   PROTO,
                hMem:DWORD