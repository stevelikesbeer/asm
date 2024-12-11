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
RandomRange     PROTO   ; eax is the upper bound, result is ax
Crlf            PROTO
DumpRegs        PROTO

.data
    count = 100
    theArray WORD count DUP(?) 

.code
main PROC

        push        OFFSET theArray                     ; push a reference to the array
        push        count                               ; push the length
        call        GenerateRandomNumbers

        push        OFFSET theArray                     ; push a reference to the array
        push        count                               ; push the length
        call        PrintResults

        Invoke      ExitProcess,0
main ENDP

; input: 1) array reference 2) array length
GenerateRandomNumbers PROC
        push        ebp
        mov         ebp, esp

        ; save the registers
        pushad

        mov         ecx, [ebp+8]                        ; move the array element count into the counter register
        mov         esi, [ebp+12]                       ; keep a copy of the array reference in esi

        cmp         ecx, 0
        je          L2

L1:     mov         eax, 10000h
        call        RandomRange
        mov         [esi], ax
        add         esi, TYPE WORD

        loop        L1

        ; restore the registers
 L2:    popad

        pop         ebp                                 ; reset ebp to the previous stack frame base
        ret         8                                   ; add 8 to esp to remove the arguments from the stack
GenerateRandomNumbers ENDP

PrintResults PROC
        push        ebp
        mov         ebp, esp

        ; save the registers
        pushad

        mov         ecx, [ebp +  8]                     ; array count
        mov         esi, [ebp + 12]                     ; array reference
        mov         ebx, TYPE WORD                      ; for WriteHexB, it says how much of eax to write

L1:     movzx       eax, WORD PTR [esi]
        call        WriteHexB
        call        Crlf
        add         esi, TYPE WORD 

        loop        L1

        ; restore the registers
        popad

        pop         ebp
        ret         8
PrintResults ENDP
END main