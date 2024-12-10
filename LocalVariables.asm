; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

ExitProcess     PROTO, dwExitCode:DWORD

WriteInt        PROTO   ; eax
WriteString     PROTO   ; edx
WriteChar       PROTO   ; al
WriteBin        PROTO   ; eax
WriteBinB       PROTO   ; eax for binary, ebx for size (TYPE WORD for example)
WriteHex        PROTO   ; eax also
WriteHexB       PROTO   ; eax for hex, ebx for size
Crlf            PROTO
DumpRegs        PROTO

.data
    FirstNumber DWORD 10
    SecondNumber DWORD 5
.code
main PROC
        push        FirstNumber
        push        SecondNumber
        call        procedureTest

        Invoke      ExitProcess,0
main ENDP
procedureTest PROC ; if we use the stack for arguments, we can't use "uses" because that messes with the stack frame and messes up our offsets for the arguments
        push        ebp
        mov         ebp, esp

        ; set local variables
        mov         DWORD PTR [ebp - 4], 3              ; first local variable
        mov         DWORD PTR [ebp - 8], 1              ; second local variable

        ; get parameters
        mov         eax, [ebp+8]                        ; first number
        mov         ebx, [ebp+12]                       ; second number

        ; remove local variables. This must be done before we pop ebp to the previous stack frame or else we'll pop the local variable values into ebp
        mov         esp, ebp

        pop         ebp 
        ret         8
procedureTest ENDP
END main