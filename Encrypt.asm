.386
.model flat, stdcall
.stack 4096

IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

ExitProcess PROTO, dwExitCode:DWORD
WriteString PROTO   ;edx
ReadString PROTO    ;edx is buffer, ecx is size of buffer, output eax - number of characters read
Crlf PROTO

KEY = 239
BUFFERMAX = 128

.data
    buffer BYTE BUFFERMAX+1 DUP(0)
    inputMessage BYTE "Please enter a string: ",0
    cipherMessage BYTE "The cipher of your string is: ",0
    decryptMessage BYTE "The decrypted message is: ",0
    charactersRead DWORD ?
.code
main PROC
    
    call getInputStringFromUser

    call encryptionAlgo                     ;encrypt
    mov edx, OFFSET cipherMessage
    call displayBuffer

    call encryptionAlgo                     ;decrypt
    mov edx, OFFSET decryptMessage
    call displayBuffer

    INVOKE ExitProcess,0
main ENDP

getInputStringFromUser PROC
    pushad
    mov edx, OFFSET inputMessage
    call WriteString
    mov edx, OFFSET buffer
    mov ecx, SIZEOF buffer
    call ReadString
    mov charactersRead, eax
    popad
    ret
getInputStringFromUser ENDP

encryptionAlgo PROC
    pushad
    mov ecx, charactersRead
    mov esi, 0

    ByteIterationLoop:
        xor buffer[esi], KEY
        inc esi
    loop ByteIterationLoop
    popad
    ret
encryptionAlgo ENDP

displayBuffer PROC
    pushad
    call WriteString
    mov edx, OFFSET buffer
    call WriteString
    call Crlf
    popad
    ret
displayBuffer ENDP
END main