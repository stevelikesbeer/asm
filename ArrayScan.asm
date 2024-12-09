.386
.model flat, stdcall
.stack 4096

IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\IrvIne\Irvine32.lib

ExitProcess PROTO, dwExitCode:DWORD
WriteInt PROTO      ;eax
WriteString PROTO   ;edx
Crlf PROTO

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; finds the first non-zero integer and writes it to console ~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.data
    intArray SWORD 0,0,0,0,10,20,35,-12,66,4,0
    ;intArray SWORD 1,0,0,0                             ; alternate test data
    ;intArray SWORD 0,0,0,0                             ; alternate test data
    ;intArray SWORD 0,0,0,1                             ; alternate test data
    noneMsg BYTE "A non-zero value was not found",0

.code
main PROC
    mov ecx, LENGTHOF intArray
    mov ebx, OFFSET intArray

    ArrayScanLoop:
        cmp WORD PTR [ebx],0    ; compare 0 to the each element, if they match, the zero flag is cleared
        jnz Found               ; if 0 does not equal the element, the zero flag is set and do a jump
        add ebx, 2              ; sword
    loop ArrayScanLoop
    jmp NotFound

    Found:
        movsx eax, SWORD PTR [ebx]  ; expand sword to DWORD, movsx is for signed, movzx is for nonsigned
        call WriteInt
        jmp Quit
    NotFound:
        mov edx, OFFSET noneMsg
    Quit:
        call Crlf
        INVOKE ExitProcess,0
main ENDP
END main