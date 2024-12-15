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
WriteChar       PROTO   ; al
WriteBin        PROTO   ; eax
WriteBinB       PROTO   ; eax for binary, ebx for size (TYPE WORD for example)
WriteHex        PROTO   ; eax also
WriteHexB       PROTO   ; eax for hex, ebx for size
Crlf            PROTO
DumpRegs        PROTO

.data
        firstString BYTE "This is some string data!", 0
        secondString BYTE LENGTHOF firstString DUP(?)
        thirdString  BYTE "This is pretty Cool!", 0
        fourthString BYTE "This is pretty Cool!", 0
        fifthString BYTE "This is pretty cool", 0

        MessageEqual BYTE "They are equal!", 0
        MessageNotEqual BYTE "They are not equal", 0
.code
main PROC
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;==============================================================================
;                  *** Five Groups of String Instructions ***
; The following instructions implicitly use ESI, EDI, or both registers to 
; address memory. References to the accumulator imply the use of AL, AX, or EAX
;
; ESI is the SOURCE
; EDI is the DESTINATION
;
;===
; MOVSB, MOVSW, MOVSD:
;   * Move string data: 
;       Copy data from memory addressed by ESI to memory addressed by EDI.
;===   
; CMPSB, CMPSW, CMPSD 
;   * Compare strings: 
;       Compare the contents of two memory locations addressed by ESI and EDI.
;===       
; SCASB, SCASW, SCASD 
;   * Scan string: 
;       Compare the accumulator (AL, AX, or EAX) to the contents of memory 
;       addressed by EDI.
;===       
; STOSB, STOSW, STOSD 
;   * Store string data: 
;       Store the accumulator contents into memory addressed by EDI.
;===
; LODSB, LODSW, LODSD 
;   * Load accumulator from string: 
;       Load memory addressed by ESI into the accumulator.
;
;==============================================================================
;                           *** REPEAT INSTRUCTION ***
; By itself, a string primitive instruction processes only a single memory
; value or pair of values. If you add a repeat prefix, the instruction 
; repeats, using ECX as a counter. The repeat prefix permits you to process an 
; entire array using a single instruction
;===
; REP 
;   Repeat while ECX > 0
; REPZ, REPE 
;   Repeat while the Zero flag is set and ECX > 0
; REPNZ, REPNE 
;   Repeat while the Zero flag is clear and ECX > 0
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


; Move string instructions: MOVSB, MOVSW, and MOVSD
        cld                                             ; clear the direction flag (more on this later)
        mov         esi, OFFSET firstString
        mov         edi, OFFSET secondString
        mov         ecx, LENGTHOF firstString

        ; repeat prefix first tests ECX > 0 before executing the MOVSB instruction. If ECX = 0,
        ; the instruction is ignored and control passes to the next line in the program
        rep         movsb
        ; rep increments (or decrements) esi and edi. After the move, esi and edi point to one position (b,w, or d)
        ;     beyond the end of each array

        ; confirm results
        mov         edx, OFFSET secondString
        call        WriteString
        call        Crlf
        call        Crlf

        ; ESI and EDI are automatically incremented when MOVSB repeats. This behavior is controlled
        ; by the CPU’s Direction flag
        ; 
        ;                       *** DIRECTION FLAG ***
        ; String primitive instructions increment or decrement ESI and EDI based on the state of the Direction flag
        ; The Direction flag can be explicitly modified using the CLD and STD instructions:
        ;       CLD : clear Direction flag (forward direction)
        ;       STD : set Direction flag (reverse direction)
        ;
        ; ___________________________________________________________________________________________
        ; |     Value of the Direction Flag     |   Effect on ESI and EDI   |   Address Sequence    |
        ; -------------------------------------------------------------------------------------------
        ; |             Clear (CLD)             |       Incremented         |       Low-high        |
        ; -------------------------------------------------------------------------------------------
        ; |             Set (STD)               |       Decremented         |       High-low        |
        ; -------------------------------------------------------------------------------------------

; Compare string instructions: CMPSB CMPSW CMPSD
        ; test when two strings are equal
        mov         esi, OFFSET thirdString
        mov         edi, OFFSET fourthString
        mov         ecx, LENGTHOF thirdString
        cld
        repe        cmpsb                               ; if they're equal ZF should be set
        jnz         J1                                  ; if zero is not set, jump to not equal message
        mov         edx, OFFSET MessageEqual
        call        WriteString
        jmp         J2
J1:     mov         edx, OFFSET MessageNotEqual
        call        WriteString
J2:     call        Crlf

        ; test when two strings are not equal
        mov         edi, OFFSET fifthString
        mov         ecx, LENGTHOF fifthString
        cld
        repe        cmpsb
        jne         J3                                  ; I can also use jne instead of jnz for clarity
        mov         edx, OFFSET MessageEqual
        call        WriteString
        jmp         J4
J3:     mov         edx, OFFSET MessageNotEqual
        call        WriteString
J4:
        Invoke      ExitProcess,0
main ENDP
END main