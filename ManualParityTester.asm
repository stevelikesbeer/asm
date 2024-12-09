.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

ExitProcess PROTO, dwExitCode:DWORD
WriteInt PROTO      ; eax
WriteString PROTO   ; edx
WriteChar PROTO     ; al
Crlf PROTO
DumpRegs PROTO
WriteBin PROTO

COMMENT!
One way to calculate the parity of a 32-bit number in EAX is to use a loop that
shifts each bit into the Carry flag and accumulates a count of the number of times the Carry
flag was set. Write a code that does this, and set the Parity flag accordingly.
!

.data
    randomBinaryNumber DWORD 10101010101011010101110111011110b
    
    messageDefaultParityFlag BYTE "The default Parity Flag Reads: ",0
    messageCustomParityFlag BYTE "My parity calculation shows: ",0

    PARITY_FLAG = 04h
    CARRY_FLAG  = 01h
    ZERO_FLAG   = 40h
    SIGN_FLAG   = 80h

.code
main PROC
        ;==== show parity using the default parity flag ====
        mov     edx, OFFSET messageDefaultParityFlag
        call    WriteString

        mov     bl, PARITY_FLAG                 ; sets flag type for getFlag procedure
        mov     eax, randomBinaryNumber
        and     eax, eax                        ; set parity flag 
        call    getFlag                         ; returns flag in al as char
        call    WriteChar                       ; writes char from al
        call    Crlf
        
        ;===   calculate parity using carry flag and shift calculation ====
        mov     ecx, TYPE randomBinaryNumber*8  ; calculate number of bits in randomBinaryNumber, use it as a counter
        mov     edx, randomBinaryNumber
        mov     eax, 0                          ; number of 1s / sum

L1:     shr     edx, 1                          ; push next bit into carry flag
        jnc     Next                            ; if carry flag is not set, there is nothing to add and move on to the next bit
        inc     eax                             ; if carry flag is set, add it to our sum
Next:    
        loop L1

        ;=== Write results of custom parity checker ===
        mov     edx, OFFSET messageCustomParityFlag
        call    WriteString
        test     eax,1                           ; get the value of the LSB (bit 0) to determine even or oddness of eax   
        jz      J1
        mov     al, 30h                         ; if eax is even (set bit 0), parity flag should be set to 0
        jmp     J2
J1:     mov     al, 31h                         ; if eax is even (cleared bit 0), parity flag should be set to 1
J2:     call    WriteChar

        Invoke  ExitProcess,0
main ENDP

; input:  bl - flag type 
; output: al - flag status (0 or 1) as char
getFlag PROC
        lahf
        mov     al, 30h                         ; 00110000b bin for char 0, 30h 
        test    ah, bl                          ; clear all bits except for the correct flag bit
        jz      J1                              ; if that bit is not set, jump to keep outbit as 30h / char 0
        or      al, 01h                         ; turn it into a 1
J1:     sahf
        ret
getFlag ENDP

END main

