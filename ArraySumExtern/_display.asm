IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

;WriteString     PROTO
;WriteInt        PROTO
;Crlf            PROTO
Include C:\Irvine\Irvine32.inc

.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                       DisplaySum
; Displays the sum of the array along with a message 
;  
;
; Input: 
;       thePrompt:PTR BYTE   +8
;       theSum:DWORD     +12
; Returns: EAX = sum
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DisplaySum PROC
        theSum      EQU [ebp + 12]
        thePrompt   EQU [ebp + 8]

        push        ebp
        mov         ebp, esp
        pushad

        mov         eax, thePrompt
        call        WriteString
        mov         eax, theSum
        call        WriteInt
        call        Crlf

        popad
        pop         ebp
        ret
DisplaySum ENDP
END