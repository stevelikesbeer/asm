.386
.model flat, stdcall


IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib
 
 WriteInt PROTO
 Crlf       PROTO

.code
; sort array
            ; array pointer
            ; array length
SortArray PROC
        push        ebp
        mov         ebp, esp
        sub         esp, 4                              ; you CAN do it this way, just with modern cpus it's more efficient to push/pop
        pushad

        mov         ecx, [ebp+8]
        mov         eax, 0

L1:     mov         [ebp-4], ecx                        ; we need an outer counter and an inner counter. Save the state before entering inner loop
        mov         ecx, [ebp+8]                        ; create a new inner counter
        dec         ecx                                 ; On bubble sort we dont want to go through the last iteration because last element + DWORD is out of bounds of the array
        mov         esi, [ebp+12]                       ; reset esi to the head of the array
L2:     mov         eax, [esi]                          ; get current element
        cmp         eax, [esi+TYPE DWORD]               ; compare with next element
        jb          J2                                  ; if current < next, then just continue the loop
        xchg        eax, [esi+TYPE DWORD]               ; if current > next, swap them
        mov         [esi], eax

J2:     add         esi, TYPE DWORD
        loop        L2
        mov         ecx, [ebp-4]                        ; restore the outer counter
        loop        L1

        popad
        add         esp, 4
        pop         ebp
        ret
SortArray ENDP
END