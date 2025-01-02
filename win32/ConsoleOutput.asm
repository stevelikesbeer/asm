; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib

; Win 32 console:
;   The COORD structure holds the coordinates of a character cell in the console
;   screen buffer. The origin of the coordinate system (0,0) is at the top left cell
COORD STRUCT
        X           WORD ?
        Y           WORD ?
COORD ENDS

SMALL_RECT STRUCT
        LEFT        WORD ?
        TOP         WORD ?
        RIGHT       WORD ?
        BOTTOM      WORD ?
SMALL_RECT ENDS

; The WriteConsole function writes a string to the console window at the current cursor position
; and leaves the cursor just past the last character written. It acts upon standard ASCII control char-
; acters such as tab, carriage return, and line feed. The string does not have to be null-terminated.
WriteConsoleA   PROTO,
                    hConsoleOutput:DWORD,
                    lpBuffer:PTR BYTE,
                    nNumberOfCharsToWrite:DWORD,
                    lpNumberOfCharsWritten:PTR DWORD,
                    lpReserved:DWORD

GetStdHandle    PROTO,
                    nStdHandle:DWORD

ExitProcess     PROTO, dwExitCode:DWORD

.data
        Crlf            EQU <0dh, 0ah>
        ConsoleHandle   DWORD 0
        BytesWritten    DWORD ?
        MessageToWrite  BYTE "This program is a simple demonstration of "
                        BYTE "console mode output, using the GetStdHandle "
                        BYTE "and WriteConsoleA functions", Crlf
        MessageSize     DWORD ($-MessageToWrite)

.code
main PROC
        Invoke      GetStdHandle, -11
        mov         ConsoleHandle, eax

        Invoke      WriteConsoleA, 
                        ConsoleHandle,
                        ADDR MessageToWrite,
                        MessageSize,
                        ADDR BytesWritten,
                        0

        Invoke      ExitProcess,0
main ENDP
END main