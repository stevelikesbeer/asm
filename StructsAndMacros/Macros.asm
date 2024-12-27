; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

ExitProcess     PROTO, dwExitCode:DWORD

; A lot of times its best to start macros with m so we know its a macro
mPrintX MACRO                                            ; where ever the macro is called, the assembler preprocessor 'injects' this code there
        mov         al, 'X'                             ; this is called inline expansion
        call        WriteChar
ENDM

WriteString     PROTO   ; edx
Crlf            PROTO
WriteChar       PROTO

.data

.code
main PROC
        mPrintX
        Invoke      ExitProcess,0
main ENDP
END main