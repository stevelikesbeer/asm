.386
.model flat, stdcall

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib
 
RandomRange PROTO   ; pass in eax, returns eax
Randomize   PROTO

.data
        LookupTable DWORD 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' 
        UsedSymbol DWORD '-'
.code
; fill array
            ; array pointer
            ; array length
FillArray PROC
        push        ebp
        mov         ebp, esp
        pushad

        mov         ecx, [ebp+8]
        mov         esi, [ebp+12]

        call        Randomize                           ; Generates a random seed for RandomRange or else we get non-random numbers

L1:     
J4:     mov         eax, 26
        call        RandomRange                         ; does indeed generate random number between 0-25

        mov         ebx, [OFFSET LookupTable+eax*TYPE DWORD]    ; find a random item from the lookup table, store it in ebx. This works.

        ; check if it's a previously used character, if it was already used, jump to the top and try to find another random
        cmp         ebx, UsedSymbol                            
        jne         J1        
        jmp         J4                                  

J1:     mov         [esi], ebx                          ; fill the input array

        ; used items in the look up table get -, so they can't be used in the future.
        mov         edx, UsedSymbol
        mov         [OFFSET LookupTable+eax*TYPE DWORD], edx
       
        add         esi, TYPE DWORD
        loop        L1
        
        popad
        pop         ebp
        ret
FillArray ENDP
END