; ml xx.asm -link /subsystem:windows <----NOTICE
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
Include winapp.inc

;hWnd is a handle to the current window
MessageBoxA     PROTO,
                    hWnd:DWORD,
                    lpText:PTR BYTE,
                    lpCaption:PTR BYTE,
                    uType:DWORD

ExitProcess     PROTO, 
                    dwExitCode:DWORD

; Every Windows application needs a startup procedure, usually named WinMain, which is
; responsible for the following tasks:
; • Get a handle to the current program.
; • Load the program’s icon and mouse cursor.
; • Register the program’s main window class and identify the procedure that will process event
;   messages for the window.
; • Create the main window.
; • Show and update the main window.
; • Begin a loop that receives and dispatches messages. The loop continues until the user closes
;   the application window.
; WinMain contains a message processing loop that calls GetMessage to retrieve the next
; available message from the program’s message queue. If GetMessage retrieves a WM_QUIT
; message, it returns zero, telling WinMain that it’s time to halt the program. For all other messages,
; WinMain passes them to the DispatchMessage function, which forwards them to the pro-
; gram’s WinProc procedure


; The WinProc procedure receives and processes all event messages relating to a window. Most
; events are initiated by the user by clicking and dragging the mouse, pressing keyboard keys, and
; so on. This procedure’s job is to decode each message, and if the message is recognized, to carry
; out application-oriented tasks relating to the message.

.data
        AppLoadMsgTitle     BYTE "Application Loaded",0
        AppLoadMsgText      BYTE "This window displays when the WM_CREATE message is received",0

        PopupTitle          BYTE "Popup Window",0
        PopupText           BYTE "This window was activated by a WM_LBUTTONDOWN message",0

        GreetTitle          BYTE "Main Window Active",0
        GreetText           BYTE "This window is shown immediately after CreateWindow and UpdateWindow are called.",0

        CloseMsg            BYTE "WM_CLOSE message received",0

        ErrorTitle          BYTE "Error",0

        WindowName          BYTE "ASM Windows App",0
        className           BYTE "ASMWin",0

        ; Define the Application's Window class structure.
        MainWin WNDCLASS <0,WinProc,0,0,0,0,0, 5,0,className> ; 5 is the color from graphwin.inc

        msg MSGStruct <>    ; this is used for event handling messages
        hMainWnd DWORD ?
        hInstance DWORD ?
.code
WinMain PROC ; notice the main function name changed for subsystem:windows

        ; we need to get a handle for the parent program, remember, all windows and sub programs need to be a child of the parent program
        Invoke      GetModuleHandleA, 0
        mov         hInstance, eax
        mov         MainWin.hInstance, eax  ; pass that handle into our window struct that we'll use to create a new window

        ; load the programs icon and cursor. I guess we have to do this manually
        Invoke      LoadIconA, 0, 32512; IDI_APPLICATION     = 32512 from winuser.h
        mov         MainWin.hIcon, eax ; pass the icon into our window struct that we'll use to create a new window
        Invoke      LoadCursorA, 0, 07f00h ;IDC_ARROW           = 07f00h from winuser.h
        mov         MainWin.hCursor, eax

        ; Register the window class
        Invoke      RegisterClassA, ADDR MainWin ; pass the struct to the kernel to register the class / window
        ; Check for success
        .IF eax == 0
            ;call    ErrorHandler
            jmp     J1
        .ENDIF
        
        ; create the applications main window
        Invoke      CreateWindowExA, 
                                0, 
                                ADDR className, 
                                ADDR WindowName, 
                                MAIN_WINDOW_STYLE,
                                80000000h,80000000h,80000000h,80000000h,; CW_USEDEFAULT = 80000000h default window size & position
                                0,
                                0,
                                hInstance,
                                0
        ; Check for success
        .IF eax == 0
            ;call    ErrorHandler
            jmp     J1
        .ENDIF

        ; save the window handle
        mov         hMainWnd, eax       ; I guess when we created a window it gave us a handle. Maybe use it for cleaning up?
        ;show and draw the window
        Invoke      ShowWindow, hMainWnd, 05h; SW_SHOW = 05h probably from some .h file
        Invoke      UpdateWindow, hMainWnd

        ; Display a greeting message
        Invoke      MessageBoxA, hMainWnd, ADDR GreetText, ADDR GreetTitle, 0 ; MB_OK = 0 (the button)

        ; Begin the programs continuous Message Handling loop
L1:     Invoke      GetMessageA, ADDR msg, 0,0,0

        ; Quit if no more messages
        .IF eax == 0
            jmp     J1
        .ENDIF

        ; relay the message to the kernel which then forwards it to our programs winproc handler (which we gave to the kernel in the create window struct)
        Invoke      DispatchMessageA, ADDR msg
        jmp         L1

J1:     Invoke      ExitProcess,0
WinMain ENDP

WinProc PROC, hWnd:DWORD, localMsg:DWORD, wParam:DWORD, lParam:DWORD
        mov         eax, localMsg
        .IF eax == 0201h;  WM_LBUTTONDOWN      =  0201h     ; left mouse button down
            Invoke      MessageBoxA, hWnd, ADDR PopupText, ADDR PopupTitle, 0 ; MB_OK = 0
            jmp         J2
        .ELSEIF eax == 01h;  WM_CREATE           =  01h     ; create window
            Invoke      MessageBoxA, hWnd, ADDR AppLoadMsgText, ADDR AppLoadMsgTitle, 0 ; MB_OK = 0
            jmp         J2
        .ELSEIF eax == 0010h; WM_CLOSE            =  0010h      ; close window
            Invoke      MessageBoxA, hWnd, ADDR CloseMsg, ADDR WindowName, 0 ; MB_OK = 0
            Invoke      PostQuitMessage, 0 ; tells the window to terminate the app
            jmp         J2
        .ELSE   ; I think we need to forward the message on to the kernel if it's not something we handle
            Invoke      DefWindowProcA, hWnd, localMsg, wParam, lParam ; default windows message handler
            jmp         J2
        .ENDIF
J2:     ret
WinProc ENDP

ErrorHandler PROC
    .data
        pErrorMsg       DWORD ? ; ptr to error message
        messageID       DWORD ?
    .code
        ; get the error id
        Invoke          GetLastError
        mov             messageID, eax

        ; get the error string
        Invoke          FormatMessageA, 100h + 1000h, ;FORMAT_MESSAGE_ALLOCATE_BUFFER + FORMAT_MESSAGE_FROM_SYSTEM
                            0, messageID, 0, ADDR pErrorMsg, 0,0

        ; display the error message
        Invoke          MessageBoxA, 0, pErrorMsg, ADDR ErrorTitle,
                           010h +  0h; MB_ICONERROR           =  010h   ; stop sign icon + 0h MB_OK

        Invoke          LocalFree, pErrorMsg
        ret
ErrorHandler ENDP
END WinMain