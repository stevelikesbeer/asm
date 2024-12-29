; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib

ExitProcess     PROTO, dwExitCode:DWORD
MessageBoxA     PROTO, 
                    hWnd:DWORD,                         ; handle of the window, can be null since we're using console
                    lpText:PTR BYTE,                    ; the string inside of the box
                    lpCaption:PTR BYTE,                 ; string, dialog box title
                    uType:DWORD                         ; contents and behavior

                    ; Contents and Behavior The uType parameter holds a bit-mapped integer combining three
                    ; types of options: buttons to display, icons, and default button choice. 

                    ; Several button combinations are possible:
                    ; • MB_OK
                    ; • MB_OKCANCEL
                    ; • MB_YESNO
                    ; • MB_YESNOCANCEL
                    ; • MB_RETRYCANCEL
                    ; • MB_ABORTRETRYIGNORE
                    ; • MB_CANCELTRYCONTINUE

                    ; Default Button You can choose which button will be automatically selected if the user presses the
                    ; Enter key. The choices are MB_DEFBUTTON1 (the default), MB_DEFBUTTON2, MB_
                    ; DEFBUTTON3, and MB_DEFBUTTON4. Buttons are numbered from the left, starting with 1

                    ; Icons Four icon choices are available. Sometimes more than one constant produces the same
                    ; icon:
                    ; • Stop-sign: MB_ICONSTOP, MB_ICONHAND, or MB_ICONERROR
                    ; • Question mark (?): MB_ICONQUESTION
                    ; • Information symbol (i): MB_ICONINFORMATION, MB_ICONASTERISK
                    ; • Exclamation point (!): MB_ICONEXCLAMATION, MB_ICONWARNING

                    ; Return Value If MessageBoxA fails, it returns zero. Otherwise, it returns an integer specifying
                    ; which button the user clicked when closing the box. They are stored in EAX

.data
        TestMessage BYTE "This is my first message box without irvine",0
        CaptionMessage BYTE "Testing... ok", 0
.code
main PROC
                                ; irvine equ null to 0
        Invoke      MessageBoxA, 0, ADDR TestMessage, ADDR CaptionMessage, 2+40h

        Invoke      ExitProcess,0
main ENDP
END main


;------------- Message Box Constants ---------------

; ; Icons:
; MB_ICONHAND            = 10h
; MB_ICONQUESTION        = 20h
; MB_ICONEXCLAMATION     = 30h
; MB_ICONASTERISK        = 40h
; MB_USERICON            = 80h
; MB_ICONWARNING         = MB_ICONEXCLAMATION
; MB_ICONERROR           = MB_ICONHAND
; MB_ICONINFORMATION     = MB_ICONASTERISK
; MB_ICONSTOP            = MB_ICONHAND

; ; Buttons:
; MB_OK         = 0
; MB_OKCANCEL   = 1
; MB_ABORTRETRYIGNORE = 2
; MB_YESNOCANCEL = 3
; MB_YESNO       = 4
; MB_RETRYCANCEL = 5
; MB_CANCELTRYCONTINUE = 6
; MB_HELP        =  4000h          ; does not close the window

; ; Select the default button:
; MB_DEFBUTTON1 = 0
; MB_DEFBUTTON2 = 100h
; MB_DEFBUTTON3 = 200h
; MB_DEFBUTTON4 = 300h

; ; Modal control buttons:
; MB_APPLMODAL     =  0
; MB_SYSTEMMODAL   =  1000h ; dialog floats above all windows
; MB_TASKMODAL     =  2000h

; ; Return values:
; OK               = 1
; CANCEL           = 2
; ABORT            = 3
; RETRY            = 4
; IGNORE           = 5
; YES              = 6
; NO               = 7
; CLOSE            = 8
; HELP             = 9
; TRYAGAIN         = 10
; CONTINUE         = 11
; TIMEOUT          = 32000