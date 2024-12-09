.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

ExitProcess PROTO, dwExitCode:DWORD
WriteInt PROTO      ; eax
WriteString PROTO   ; edx
WriteChar PROTO     ; al
Crlf PROTO

.data

.code
main PROC
        ; multiply 20 by 36, which should be 720
        mov             eax, 20
        mov             ebx, eax
        ; 2^5 is 32, + 2^2 is 4, total is 36, so I think i need to shift twice both against the default value
        shl             eax, 5
        shl             ebx, 2
        add             eax, ebx
        call            WriteInt               
        call            Crlf   

        ; multiply 20 x 30, = 600
        mov             eax, 20
        mov             ebx, eax
        mov             edx, eax        ; keep safe
        ; first shift is 2^4 which is 16, then i have 14 left. so 2^3 is 8, 6 left. 2^2 4, 2^1
        shl             eax, 4
        shl             ebx, 3
        add             eax, ebx
        mov             ebx, edx
        shl             ebx, 2
        add             eax, ebx
        mov             ebx, edx
        shl             ebx, 1
        add             eax, ebx
        call            WriteInt

        Invoke          ExitProcess,0
main ENDP
END main