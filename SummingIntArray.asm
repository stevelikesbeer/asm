.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD
WriteHex PROTO

;include because i'm not using visual studio
IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

.data
    arrayOfIntegers DWORD 10000h, 20000h, 20000h, 40000h

.code
main PROC
    mov esi,OFFSET arrayOfIntegers     ; starting position, offset passes the pointer, otherwise it passes the value
    mov ecx,LENGTHOF arrayOfIntegers   ; ecx is always the default counter and the loop goes until ecx hits 0. Set a starting value.
    mov eax, 0                         ; summation

    SummationLoop:
        add eax, [esi]                  ; the brackets dereferences the pointer, e.g. passing its value
        add esi, TYPE arrayOfIntegers   ; type of the array is dword, or 4 bytes

    loop SummationLoop

    call WriteHex                       ; reads from eax

    INVOKE ExitProcess,0
main ENDP
END main