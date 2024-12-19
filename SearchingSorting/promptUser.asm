; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

WriteString     PROTO   ; edx
Crlf            PROTO   ;
ReadChar        PROTO   ;
WriteChar       PROTO

.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                       PromptUserChar
; Description: Promps the user to enter a character
; Input:
;   PTR to Message: +12, DWORD
; Output: EAX contains the character
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PromptUserChar PROC
        push        ebp
        mov         ebp, esp
        push        edx

        call        Crlf
        mov         edx, [ebp+8]
        call        WriteString
        call        ReadChar
        call        WriteChar
        call        Crlf

        and         eax, 000000FFh                      ; We're only using AH, so zero out the rest of eax so we don't get junk
        pop         edx
        pop         ebp
        ret
PromptUserChar ENDP
END