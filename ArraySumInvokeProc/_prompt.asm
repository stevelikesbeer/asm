Include sum.inc

.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                   PromptForInteger 
; Description: 
;   Prompt the user to enter an integer arraySize
;   number of times
;
; Input:    prtPrompt:PTR BYTE,
;           ptrArray:PTR DWORD,
;           arraySize: DWORD
;
; Output: ptrArray
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PromptForInteger PROC,
        ptrPrompt:PTR BYTE,
        ptrArray: PTR DWORD,
        arraySize:DWORD

        pushad

        mov         edx, ptrPrompt
        mov         esi, ptrArray
        mov         ecx, arraySize
        cmp         ecx,0                               ; If arraysize is 0, just exit the process nothing else to do
        jle         J1

L1:     call        WriteString
        call        ReadInt
        call        Crlf
        mov         [esi], eax
        add         esi, 4
        loop        L1

J1:     popad
        ret
PromptForInteger ENDP
END