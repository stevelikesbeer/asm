; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

ExitProcess     PROTO, dwExitCode:DWORD

WriteString     PROTO   ; edx
Crlf            PROTO   ;
ReadChar        PROTO   ;
WriteChar       PROTO

.code
; PromptUser
;   input: message pointer :DWORD
;   output: eax
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

        and          eax, 000000FFh
        pop         edx
        pop         ebp
        ret
PromptUserChar ENDP
END