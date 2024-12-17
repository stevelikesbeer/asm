.386
.model flat, stdcall

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Calculates the sum of a row in a byte matrix.
; Receives:
; Table Offset: +16
; Row Size: + 12
; Row Index: +8
; Returns: EAX holds the sum.
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.code
CalculateRowSum PROC
        ; prologue
        push        ebp
        mov         ebp, esp
        sub         esp, 4                              ; create room for local variable
        push        ebx
        push        ecx
        push        edx
        push        esi

        ; === Create base in [base + offset] formula ===
        ; Calculate relative row offset in bytes. Take the row size * row index
        mov         eax, [ebp + 12]                   
        mul         DWORD PTR [ebp + 8]

        ; calculate absolute offset of the row:
        ; To convert relative row offset to absolute, we add it to the table offset.
        ;       If the table offset is at memory location 0020h, we add relative row offset to it (30 bytes for example (10 row size * third row))
        ;       The address in our program memory where we find the row is 003Eh (62d = table offset (32d or 0020h) + relative row offset (30d, 001Eh)
        mov         ebx, [ebp + 16]
        add         ebx, eax                            ; This is creating the base of [base + offset], where base is the absolute row offset, and offset is the column index (calculate later)

        ; === Set up the loop ===
        mov         eax, 0                              ; zero it out to hold our sum
        mov         esi, 0                              ; This will be our column index, we'll inc it every loop. 
        mov         ecx, [ebp + 12]                     ; row size / loop counter

L1:     movzx       edx, BYTE PTR [ebx + esi]           ; the source is a byte, we need to convert it to a dword and zero out MSBs
        add         [ebp-4], edx                        
        inc         esi         
        loop        L1

        mov         eax, [ebp-4]                        ; set return value

        ; epilogue
        pop         esi
        pop         edx
        pop         ebx
        pop         ecx
        add         esp, 4                              ; remove local variable
        pop         ebp
        ret
CalculateRowSum ENDP
END