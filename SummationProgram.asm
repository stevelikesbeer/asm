.386
.model flat,stdcall
.stack 4096

IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

ExitProcess PROTO, dwExitCode:DWORD

Clrscr PROTO
ReadInt PROTO
WriteString PROTO
WriteInt PROTO

INTEGER_COUNT = 3

.data
    requestMessage BYTE "Please enter an integer: ",0
    answerMessage BYTE "The sum of the integers is: ",0
    arrayBuffer DWORD INTEGER_COUNT DUP(?)

.code
main PROC
    call Clrscr

    mov esi, OFFSET arrayBuffer
    mov ecx, LENGTHOF arrayBuffer

    call RequestInteger
    call SumIntegerArray
    call WriteResults

    Invoke ExitProcess,0
main ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Displays Message and requests ints into array
; esi: array pointer
; edx: string
; ecx: Array length
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RequestInteger PROC uses eax ecx esi edx
    mov edx, OFFSET requestMessage
    requestIntLoop:
        call WriteString                ; edx
        call ReadInt                    ; eax
        mov [esi], eax
        add esi, TYPE DWORD
    loop requestIntLoop

    ret
RequestInteger ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Sums an array
; ecx: array length
; esi array pointer
; returns eax
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SumIntegerArray PROC uses esi ecx
    mov eax,0

    summationLoop:
        add eax, [esi]
        add esi, TYPE DWORD
    loop summationLoop

    ret
SumIntegerArray ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;   Writes the Result
;   string: edx
;   integer: eax
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
WriteResults PROC uses eax edx
    mov edx, OFFSET answerMessage
    call WriteString
    call WriteInt

    ret
WriteResults ENDP

END main