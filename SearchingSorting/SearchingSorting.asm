; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

ExitProcess     PROTO, dwExitCode:DWORD

WriteInt        PROTO   ; eax
WriteString     PROTO   ; edx
WriteChar       PROTO   ; al
WriteBin        PROTO   ; eax
WriteBinB       PROTO   ; eax for binary, ebx for size (TYPE WORD for example)
WriteHex        PROTO   ; eax also
WriteHexB       PROTO   ; eax for hex, ebx for size
Crlf            PROTO
DumpRegs        PROTO

.data

.code
main PROC
        ; fill array
            ; array pointer
            ; array length

        ; print array
            ; array pointer
            ; array length
            ; pointer to message

        ; sort array
            ; array pointer
            ; array length

        ; print array;
            ; array pointer
            ; array length
            ; pointer to message

        ; search array
            ; array pointer
            ; array length
            ; search item

            ; returns eax of index

        ; print index
            ; ptr to message
            ; index of found message
        Invoke      ExitProcess,0
main ENDP
END main