.386
.model flat, stdcall

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

WriteString     PROTO   ; edx
WriteChar       PROTO   ; al
Crlf            PROTO

.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                       PrintArray
; Description: Prints an array with elements separated by commas
; Input:
;   PTR to array: +16, DWORD
;   Array Length: +12, DWORD
;   PTR to message: +8
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PrintArray PROC
        push        ebp
        mov         ebp, esp
        pushad

        call        Crlf
        mov         edx, [ebp+8]
        call        WriteString
        call        Crlf

        mov         ecx, [ebp+12]
        mov         esi, [ebp+16]
        
L1:     mov         al, BYTE PTR [esi]
        call        WriteChar
        cmp         ecx, 1                              ; don't print a comma after the last element
        je          J1
        mov         al, 2Ch                             ; print a comma
        call        WriteChar
        mov         al, 20h                             ; print a space
        call        WriteChar
        add         esi, TYPE DWORD
        loop        L1
        
J1:     call        Crlf
        popad
        pop         ebp
        ret
PrintArray ENDP
END