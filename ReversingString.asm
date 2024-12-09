.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

WriteString PROTO

;include libraries because no vs
IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

.data
    message BYTE "Hello this is the message",0
    messageLength = ($ - message) - 1

.code
main PROC
    mov ecx, messageLength
    mov esi,0

    PushLoop:
        movzx eax, message[esi]
        push eax
        inc esi
    loop Pushloop

    mov ecx, messageLength
    mov esi,0
    PopLoop:
        pop eax
        mov message[esi], al
        inc esi
    loop PopLoop

    mov edx, OFFSET message
    call WriteString

    Invoke ExitProcess,0
main ENDP
END main