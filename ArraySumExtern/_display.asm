.model flat, stdcall

WriteString     PROTO
WriteInt        PROTO
Crlf            PROTO

.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                       DisplaySum
; Displays the sum of the array along with a message 
;  
;
; Input: 
;       thePrompt:PTR BYTE   +8
;       theSum:DWORD     +12
; Returns: Nothing
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DisplaySum PROC
        theSum      EQU [ebp + 12]
        thePrompt   EQU [ebp + 8]

        push        ebp
        mov         ebp, esp
        pushad

        mov         edx, thePrompt
        call        WriteString
        mov         eax, theSum
        call        WriteInt
        call        Crlf

        popad
        pop         ebp
        ret
DisplaySum ENDP
END