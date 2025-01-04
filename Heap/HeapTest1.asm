; Allocate heap space for 1000 byte array fill it and display it.
.386
.model flat,stdcall
.stack 4096

Include include.inc

GetProcessHeap PROTO

HeapAlloc PROTO,
          hHeap:DWORD, ; handle to private heap block
          dwFlags:DWORD, ; heap allocation control flags
          dwBytes:DWORD ; number of bytes to allocate

HeapFree PROTO,
          hHeap:DWORD,
          dwFlags:DWORD,
          lpMem:DWORD

.data
        ARRAY_SIZE = 1000
        FILL_VAL EQU 0FFh

        hHeap       DWORD ? ; DWORD should really be HANDLE (in C)
        pArray      DWORD ? 
        newHeap     DWORD ?
        message1    BYTE "The heap size is: ",0
.code
main PROC
        Invoke      GetProcessHeap
        .IF eax == NULL
            call    WriteWindowsMsg
            jmp     Quit
        .ELSE
            mov     hHeap, eax
        .ENDIF

        call        AllocateArray
        jnc         ArrayOkay                           ; carry flag not set, allocate must've been successful
        call        WriteWindowsMsg                     ; if it was unsuccessful, write the error message and quit
        jmp         Quit

ArrayOkay:
        call        FillArray
        call        DisplayArray
        call        Crlf

        ; free the array
        Invoke      HeapFree, hHeap, 0, pArray

Quit:   Invoke      ExitProcess,0
main ENDP

AllocateArray PROC USES eax
        Invoke      HeapAlloc, hHeap,HEAP_ZERO_MEMORY, ARRAY_SIZE ;HEAP_ZERO_MEMORY = 00000008h
        .IF eax == NULL
            stc
        .ELSE
            clc
            mov     pArray, eax                         ; save the pointer of the head of the memory we allocated to pArray
        .ENDIF

        ret
AllocateArray ENDP

FillArray PROC uses ecx esi
        mov         ecx, ARRAY_SIZE
        mov         esi, pArray
L1:     mov         BYTE PTR [esi], FILL_VAL
        inc         esi
        loop        L1
        ret
FillArray ENDP

DisplayArray PROC uses ecx esi ebx eax
        mov         ecx, ARRAY_SIZE
        mov         esi, pArray
L1:     mov         al, [esi]
        mov         ebx, TYPE BYTE
        call        WriteHexB
        inc         esi
        loop        L1

        ret
DisplayArray ENDP
END main