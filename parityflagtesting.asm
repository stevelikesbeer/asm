.386
.model flat,stdcall
.stack 4096

ExitProcess PROTO, dwExitProcess:DWORD
DumpRegs PROTO

IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

.data
    data DWORD 01001011110101000111010101011011b ; PF=1 when odd number of set bits
.code
main PROC
    mov eax, 0FFFFFFFFh
    mov al, BYTE PTR [data]
    xor al, BYTE PTR [data+1]
    xor al, BYTE PTR [data+2]
    xor al, BYTE PTR [data+3]

    call DumpRegs
    INVOKE ExitProcess,0
main ENDP
END main