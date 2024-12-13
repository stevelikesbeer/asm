.model flat, stdcall

IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib
;Include C:\Irvine\Irvine32.inc

.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                       ArraySum
; Calculates the sum of an array of 32 bit integers 
;  
;
; Input: 
;       ptrArray:PTR DWORD   +8
;       arraySize:DWORD     +12
; Returns: EAX = sum
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ArraySum PROC
        ; symbolic constants
        ptrArray    EQU [ebp + 8]
        arraySize   EQU [ebp + 12]

        ; prologue
        push        ebp
        mov         ebp, esp
        push        ecx
        push        esi

        ; if array is of size 0, just exit procedure
        mov         ecx, arraySize
        cmp         ecx, 0
        jle         J1

        mov         esi, ptrArray
        mov         eax, 0
        
L1:     add         eax, [esi]
        add         esi, 4
        loop        L1

        ; epilogue
        pop         esi
        pop         ecx
J1:     pop         ebp
        ret
ArraySum ENDP
END