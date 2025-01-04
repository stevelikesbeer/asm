; The following example (Heaptest2.asm) uses dynamic memory allocation to repeatedly allocate
; large blocks of memory until the heap size is exceeded

.386
.model flat,STDCALL
.stack 4096

Include include.inc

HeapCreate PROTO,
        flOptions:DWORD, ; heap allocation options
        dwInitialSize:DWORD, ; initial heap size, in bytes
        dwMaximumSize:DWORD ; maximum heap size, in bytes

HeapAlloc PROTO,
          hHeap:HANDLE, ; handle to private heap block
          dwFlags:DWORD, ; heap allocation control flags
          dwBytes:DWORD ; number of bytes to allocate

HeapDestroy PROTO,
          hHeap:DWORD ; heap handle

.data
        HEAP_START = 2000000    ; 2MB
        HEAP_MAX   = 400000000  ; 400MB
        BLOCK_SIZE = 500000     ; .5MB

        hHeap       HANDLE ?
        pData       DWORD ?

        str1        BYTE 0dh,0ah, "Memory Allocation Failed. ", 0dh, 0ah, 0
.code
main PROC
        Invoke      HeapCreate, 0, HEAP_START, HEAP_MAX
        .IF eax == NULL
            call    WriteWindowsMsg
            call    Crlf
            jmp     Quit
        .ELSE
            mov     hHeap, eax
        .ENDIF

        mov         ecx, 2000
L1:     call        AllocateBlock
        .IF CARRY?                                      ; the CARRY? operator is a masm operator used with IF, ELSE, or REPEAT
            call    Crlf
            call    WriteWindowsMsg
            mov     edx, OFFSET str1
            call    WriteString
            jmp     Quit
        .ELSE
            mov     al, '.'
            call    WriteChar
        .ENDIF
        loop        L1
Quit:   Invoke      HeapDestroy, hHeap
        .IF eax == NULL
            call    WriteWindowsMsg
            call    crlf
        .ENDIF

    Invoke      ExitProcess, 0
main ENDP

AllocateBlock PROC uses ecx
        Invoke      HeapAlloc, hHeap, 0, BLOCK_SIZE
        .IF eax == NULL
            stc
        .ELSE
            clc
            mov     pData, eax
        .ENDIF

        ret
AllocateBlock ENDP
END main