; ml DividingByShifting.asm -link /subsystem:console
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
        ; 32 / 16 = 2
        mov         eax, 32
        ; 16 = 2^4
        shr         eax, 4
        call        WriteInt
        call        Crlf

        ; 200 / 50 = 4
        mov         eax, 200
        mov         ebx, eax
        mov         edx, eax        ; keep safe
        ; 50 = 2^5 which is 32, 50-32= 18 so 2^4 which is 16, 18-16 = 2, so 2^1
        ; I THINK YOU CAN ONLY DIVIDE BY 2^N
        shr         eax, 5   ; gives me 0000 0110     or 6
        ;shr         eax, 3 ; should be ebx


;
        ;sub         eax, ebx
        ;mov         ebx, edx
        ;shr         ebx, 1
        ;sub         eax, ebx
        call        WriteInt


        Invoke      ExitProcess,0
main ENDP
END main