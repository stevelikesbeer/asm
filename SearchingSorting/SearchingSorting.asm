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
Crlf            PROTO

Extern FillArray@0:PROC
Extern PrintArray@0:PROC
;Extern SortArray@0:PROC
;Extern SearchArray@0:PROC

.data
        COUNT = 26
        MainArray DWORD COUNT DUP('-')
        ;LookupTable DWORD 'd', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' 

        MessageUnsortedArray BYTE "The unsorted array is: ",0
.code
main PROC
        ; fill array
            ; array pointer
            ; array length
        push        OFFSET MainArray
        push        COUNT
        call        FillArray@0
        add         esp, 8;12

        ; print array
            ; array pointer
            ; array length
            ; pointer to message
        push        OFFSET MainArray
        push        COUNT
        push        OFFSET MessageUnsortedArray
        call        PrintArray@0
        add         esp, 12


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