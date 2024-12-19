.386
.model flat, stdcall

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

WriteString     PROTO   ; edx
WriteDec        PROTO   
Crlf            PROTO

.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                       PrintResults
; Description: Prints a success or failure message along with
;               the index of found item if success 
; Input:
;   Index of found item: +16, DWORD
;   PTR to success Message: +12
;   PTR to failure Message: +8
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; print results
            ; Index of found item, -1 if failure
            ; pointer to success message
            ; pointer to failure message
PrintResults PROC
        push        ebp
        mov         ebp, esp
        pushad

        mov         ebx, -1
        cmp         ebx, [ebp+16]
        je          J1  
        mov         edx, [ebp+12]
        call        WriteString
        mov         eax, [ebp+16]
        call        WriteDec
        jmp         J2
J1:     mov         edx, [ebp+8]                        ; could not find item
        call        WriteString
J2:     call        Crlf

        popad
        pop         ebp
        ret
PrintResults ENDP
END