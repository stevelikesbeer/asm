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
    twodimensionalArray BYTE    01FFh, 0C2Ah, 0001h,  0004h,  0A000h, 1800h,
    RowSize = ($-twodimensionalArray)
                                6262h, 3201h, 0B03h,  0AAAAh, 0020h,  3939h,
                                8888h, 2323h, 0DDDDh, 7481h,  7777h,  0C321h,
                                7492h, 4769h, 0C492h, 4721h,  8471h,  0A455h
.code
main PROC

        Invoke      ExitProcess,0
main ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Calculates the sum of a row in a byte matrix.
; Receives: EBX = table offset, EAX = row index,
; ECX = row size, in bytes.
; Returns: EAX holds the sum.
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CalculateRowSum PROC

CalculateRowSum ENDP
END main