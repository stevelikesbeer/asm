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

myProc          PROTO   x: DWORD, y: DWORD

WriteStackFrame PROTO,
                        numParam:DWORD,                 ; number of passed parameters
                        numLocalVal: DWORD,             ; number of DWordLocal variables
                        numSavedReg: DWORD              ; number of saved registers

.data

.code
main PROC
        mov         eax, 0EAEAEAEAh
        mov         ebx, 0EBEBEBEBh
        INVOKE      myProc, 1111h, 2222h                ; pass two integer arguments

        Invoke      ExitProcess,0
main ENDP

myProc PROC USES eax ebx,
                        x: DWORD, y: DWORD
        LOCAL       a:DWORD, b:DWORD
        PARAMS      = 2
        LOCALS      = 2
        SAVED_REGS  = 2
        mov         a,0AAAAh
        mov         b,0BBBBh
        INVOKE      WriteStackFrame, PARAMS, LOCALS, SAVED_REGS

        ret
myProc ENDP
END main