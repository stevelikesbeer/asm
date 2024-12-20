.386
.model flat, stdcall

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib
 
RandomRange PROTO   ; pass in eax, returns eax
Randomize   PROTO

.data
        AlphabetLength      = 26
        LookupTable         DWORD 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
        LookupTableStatus   BYTE AlphabetLength DUP(0) 
        UsedSymbol          BYTE 1
.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                       FillArrayAlphabet
; Description: Fills an array with random letters from the 
;               alphabet. 
; Input:
;   PTR to array: +12, DWORD
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FillArrayAlphabet PROC
        push        ebp
        mov         ebp, esp
        pushad
        mov         ecx, AlphabetLength
        mov         esi, [ebp+8]

        call        Randomize                           ; Generates a random seed for RandomRange or else we get non-random numbers
L1:     mov         eax, AlphabetLength
        call        RandomRange                         ; does indeed generate random number between 0-25

        mov         bl, LookupTableStatus[eax]          ; Check to see if the Letter has been used yet
        cmp         bl, UsedSymbol                      
        jne         J1                                  ; If it wasn't used before, continue down the loop body
        jmp         L1                                  ; If it has been used before, jump to the top of the loop and try finding another letter

J1:     mov         ebx, LookupTable[eax*TYPE DWORD]    ; The letter wasn't used. Grab it from the lookup table and 
        mov         [esi], ebx                          ; insert it into input array

        ; Update the Lookup Table Status to remove the Letter from the list of allowed letters
        mov         bl, UsedSymbol
        mov         LookupTableStatus[eax], bl
        add         esi, TYPE DWORD
        loop        L1

        ;reset Lookup Status array
        mov         al, 0
        mov         ecx, AlphabetLength
        mov         esi, OFFSET LookupTableStatus
L2:     mov         BYTE PTR[esi],al
        add         esi, 1
        loop        L2

        popad
        pop         ebp
        ret
FillArrayAlphabet ENDP
END