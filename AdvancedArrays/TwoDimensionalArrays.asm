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

    tableD              DWORD 10h, 20h, 30h, 40h, 50h
    Rowsize2 = ($ - tableD)
                        DWORD 60h, 70h, 90h, 90h, 0A0h
                        DWORD 0B0h, 0C0h, 0D0h, 0E0h, 0F0h
.code
main PROC
        ; Arugments (Table Offset, Row Size, Row Index) Returns: Sum EAX
        push        OFFSET twodimensionalArray
        push        RowSize
        push        3
        call        CalculateRowSum@0                   ; returns eax
        add         esp, 12                             ; remove arguments from stack

        call        WriteInt
        call        Crlf
        call        Crlf


        ; Base-Index-Displacement
        ;   this is another way to access different rows I guess
        mov         ebx, Rowsize2                           ; rowsize2 = 20d
        mov         esi, 2                                  ; esi = 2
        mov         eax, tableD[ebx + esi * TYPE tableD]    ; [20 + 2 * 4] = [20 + 8] = [28]. 28/dword = 7. So the 7th index base 0. Is this really clear how this is useful? not exactly...

        mov         ebx, TYPE BYTE                      ; this realy could be deleted because we are dealing with DWORDS, but our data in the tableD table is really only bytes for simplicity
        call        WriteHexB         

        Invoke      ExitProcess,0
main ENDP


END main