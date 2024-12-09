.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
DumpRegs PROTO

;including because im doing command line and not visual studio
IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

.data
    int1 dword 30000h
    int2 dword 20000h
    int3 dword 70000h
.code
main PROC
    mov eax, int3
    sub eax, int2
    sub eax, int1
    call DumpRegs
    Invoke ExitProcess,0
main ENDP
END main