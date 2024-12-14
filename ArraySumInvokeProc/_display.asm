Include sum.inc

.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                   DisplaySum 
; Description: Prints the message prompt and the sum 
;               to the console
;
; Input:
;    ptrPrompt:PTR BYTE
;    theSum:DWORD
;
; Output: None
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DisplaySum PROC,
        ptrPrompt:PTR BYTE,
        theSum:DWORD

        ; prologue
        pushad

        mov         edx, ptrPrompt
        call        WriteString
        mov         eax, theSum
        call        WriteInt
        call        Crlf

        ; epilogue
        popad
        ret
DisplaySum ENDP
END