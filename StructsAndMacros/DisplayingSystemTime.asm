; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

COORD STRUCT
        X WORD ?
        Y WORD ?
COORD ENDS

SYSTEMTIME STRUCT
        wYear WORD ?
        wMonth WORD ?
        wDayOfWeek WORD ?
        wDay WORD ?
        wHour WORD ?
        wMinute WORD ?
        wSecond WORD ?
        wMilliseconds WORD ?
SYSTEMTIME ENDS

STD_OUTPUT_HANDLE = -11
HANDLE TEXTEQU <DWORD>

ExitProcess     PROTO, dwExitCode:DWORD
GetLocalTime    PROTO, lpSystemTime:PTR SYSTEMTIME
GetStdHandle    PROTO, nStdHandle:DWORD
SetConsoleCursorPosition PROTO, hConsoleOutput:HANDLE, dwCursorPosition:COORD

WriteDec        PROTO   ; eax
WriteString     PROTO   ; edx
Crlf            PROTO

.data
        sysTime         SYSTEMTIME <>
        consoleHandle   DWORD ?
        xYPosition      COORD <10,5>
        colonString     BYTE ":",0
.code
main PROC
        INVOKE      GetLocalTime, ADDR sysTime
        INVOKE      GetStdHandle, STD_OUTPUT_HANDLE
        mov         consoleHandle, eax
        INVOKE      SetConsoleCursorPosition, consoleHandle, xYPosition 

        mov         edx, OFFSET colonString             ; this only displays in the console, not the built in powershell
        movzx       eax, sysTime.wHour                  ; oh it does show in powershell, but I definitely have to clear it first (clear cmd)
        call        WriteDec      
        call        WriteString
        movzx       eax, sysTime.wMinute
        call        WriteDec
        call        WriteString
        movzx       eax, sysTime.wSecond
        call        WriteDec
        call        Crlf
        INVOKE      ExitProcess,0
main ENDP
END main