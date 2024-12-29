; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib      ; for dumpmem

ExitProcess     PROTO, dwExitCode:DWORD
GetStdHandle    PROTO, nStdHandle:DWORD

DumpMem         PROTO

; Console Input Buffer 
; The Win32 console has an input buffer containing an array of input
; event records. Each input event, such as a keystroke, mouse movement, or mouse-button click,
; creates an input record in the console’s input buffer. High-level input functions such as
; ReadConsole filter and process the input data, returning only a stream of characters

ReadConsoleA     PROTO,
                    hConsoleInput:DWORD,                ; it would normally be HANDLE instead of dword, but irvine equ's handle to dword
                    lpBuffer:PTR BYTE,                  ; pointer to the buffer
                    nNumberOfCharsToRead:DWORD,         ; number of chars to read
                    lpNumberOfCharsToRead:PTR DWORD,    ; pointer to number of bytes to read
                    lpReserved:DWORD                    ; not used
                ; hConsoleInput is a valid console input handle returned by the GetStdHandle function. 
                ; lpBuffer parameter is the offset of a character array. 
                ; nNumberOfCharsToRead is a 32-bit integer specifying the maximum number of characters to read. 
                ; lpNumberOfCharsRead is a pointer to a doubleword that permits the function to fill in, 
                ;   when it returns, a count of the number of characters placed in the buffer.
                ; The last parameter is not used, so pass the value zero

                ; When calling ReadConsoleA, include two extra bytes in your input buffer to hold the end-of-
                ; line characters. If you want the input buffer to contain a null-terminated string, replace the byte
                ; containing 0Dh with a null byte. This is exactly what is done by the ReadString procedure from
                ; Irvine32.lib
BUFFER_SIZE = 80
.data
        Buffer      BYTE BUFFER_SIZE DUP(?), 0, 0
        StdInHandle DWORD ?
        BytesRead   DWORD ?
.code
main PROC
        Invoke      GetStdHandle, -10 ; -11 is output handle, do I want the input handle? Yes, -10 is the input handle
        mov         StdInHandle, eax
        Invoke      ReadConsoleA, StdInHandle, ADDR Buffer, BUFFER_SIZE, ADDR BytesRead, 0

        ; display the buffer, irvine thingy
        mov         esi, OFFSET Buffer
        mov         ecx, BytesRead
        mov         ebx, TYPE Buffer
        call        DumpMem
        Invoke      ExitProcess,0
main ENDP
END main