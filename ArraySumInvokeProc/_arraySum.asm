Include sum.inc

.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                   ArraySum 
; Description: Adds up all the elemnts of an array of 
;               size arraySize
;
; Input:
;    ptrArray:PTR DWORD,
;    arraySize:DWORD
;
; Output: EAX as the sum
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ArraySum PROC
        ptrArray:PTR DWORD,
        arraySize:DWORD

        push        ecx                                 ; we want to push the individual registers we use so the caller can count on us not affecting them
        push        esi

        mov         eax, 0
        mov         esi, ptrArray

        ; If arraysize is 0, just exit the procedure
        mov         ecx, arraySize
        cmp         ecx, 0
        jle         J1

L1:     add         eax, [esi]
        add         esi, 4
        loop        L1

J1:     pop         esi
        pop         ecx
        ret
ArraySum ENDP
END