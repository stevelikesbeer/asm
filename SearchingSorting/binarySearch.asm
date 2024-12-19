.386
.model flat, stdcall

.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                       SearchArray
; Description: Searches an array of DWORDS using Binary Search
; Input:
;   PTR to array to be searched: +16, DWORD
;   Array Length: + 12, DWORD
;   Search Term: +8, DWORD
; Returns: EAX holds index if found, -1 if not found.
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SearchArray PROC
        push        ebp
        mov         ebp, esp
        push        ebx
        push        ecx
        push        edx
        push        edi
        push        esi

        mov         eax, -1                             ; store the default index value in a local variable
        mov         edx, [ebp+8]                        ; search term
        mov         ecx, [ebp+16]                       ; array head
        mov         esi, 0                              ; start index
        mov         edi, [ebp+12]                       ; end index   

J1:     mov         ebx, edi                            ; startIndex+EndIndex/2 = midpoint
        add         ebx, esi
        shr         ebx, 1
        
        cmp         [ecx+ebx*TYPE DWORD], edx           ; ecx = original array head, ebx is the current index. edx is search term
        je          J2                                  ; did we find the item? If so jump to J2
        lahf                                            ; so save the flags so we can reuse its results below                         

        cmp         esi, edi                            ; if startpoint == endpoint and the item is not found, 
        je          J3                                  ; then the item is not in the array. go to epilogue

        sahf
        jl          J4                                  ; midpoint < requested item, jump to assignment area

        mov         edi, ebx                            ; midpoint > requested item, we need to make midpoint the new endpoint
        jmp         J1
J4:     mov         esi, ebx                            ; midpoint < requested item, we need to make the midpoint the new startpiont
        jmp         J1

J2:     mov         eax, ebx                            ; J2: Item found, Update found index value

J3:     pop         esi                                 
        pop         edi
        pop         edx
        pop         ecx
        pop         ebx
        pop         ebp
        ret
SearchArray ENDP
END