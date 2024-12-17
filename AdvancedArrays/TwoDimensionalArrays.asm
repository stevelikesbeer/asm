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

EXTERN          CalculateRowSum@0:PROC

.data
    twodimensionalArray BYTE    4, 6, 7,  1,  2, 3
    RowSize = ($ - twodimensionalArray)
                        BYTE    62h, 32h, 0Bh,  0AAh, 20h,  39h
                        BYTE    88h, 23h, 0DDh, 81h,  77h,  0C2h
                        BYTE    3, 3, 3, 3,  3,  2
.code
main PROC
        ; Arugments (Table Offset, Row Size, Row Index) Returns: Sum EAX
        push        OFFSET twodimensionalArray
        push        RowSize
        push        3
        call        CalculateRowSum@0                   ; returns eax
        add         esp, 12                             ; remove arguments from stack

        call        WriteInt

        Invoke      ExitProcess,0
main ENDP


END main