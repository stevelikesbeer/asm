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
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                       FillArrayAlphabet
; Description: Fills an array with random letters from the 
;               alphabet. Array Size must be 26
; Input:
;   PTR to array: +12, DWORD
;   Array Length: +8, DWORD. Must be 26
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FillArrayAlphabet PROC
        push        ebp
        mov         ebp, esp
        pushad
        mov         ecx, [ebp+8]
        mov         esi, [ebp+12]

        call        Randomize                           ; Generates a random seed for RandomRange or else we get non-random numbers
L1:     mov         eax, 26
        call        RandomRange                         ; does indeed generate random number between 0-25

        mov         ebx, [OFFSET LookupTable+eax*TYPE DWORD]    ; find a random item from the lookup table, store it in ebx.
        cmp         ebx, UsedSymbol                     ; Check if a character has been used already
        jne         J1                                  ; If it wasn't used before, continue down the loop body
        jmp         L1                                  ; If it has been used before, jump to the top of the loop and try finding another letter

J1:     mov         [esi], ebx                          ; fill the input array

        ; used items in the look up table get -, so they can't be used in the future.
        mov         edx, UsedSymbol
        mov         [OFFSET LookupTable+eax*TYPE DWORD], edx
        add         esi, TYPE DWORD
        loop        L1
        popad
        pop         ebp
        ret
FillArrayAlphabet ENDP
END