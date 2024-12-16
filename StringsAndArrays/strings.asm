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
        MessageStringMove BYTE "===Moving Strings===", 0
        MessageStringComparison BYTE "===Comparison Strings===", 0
        MessageStringScanning BYTE "===Scanning Strings===",0
        MessageStringSto BYTE "===Storing Strings===",0
        MessageStringsLod BYTE "===Loading Strings===",0
        
        MessageNotFound BYTE "The character was not found",0
        MessageFound BYTE "The character was found at location: ",0

        COUNT = 10
        emptyString BYTE COUNT DUP(?)

        lodArray DWORD 1,2,3,4,5,6,7,8,9,10
        lodMultiplier DWORD 10
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
        mov         edx, OFFSET MessageStringMove
        call        WriteString
        call        Crlf

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
        mov         edx, OFFSET MessageStringComparison
        call        WriteString
        call        Crlf

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
        repe        cmpsb                               ; repe is rep while equal, when something is not equal or ecx =0, it exits the loop
        jne         J3                                  ; I can also use jne instead of jnz for clarity
        mov         edx, OFFSET MessageEqual
        call        WriteString
        jmp         J4
J3:     mov         edx, OFFSET MessageNotEqual
        call        WriteString
J4:     call        Crlf
        call        Crlf
; SCASB SCASW SCASD
;   Compare a value in AL/AX/EAX to a byte, word, or doubleword, respectively, addressed by EDI. 
;   The instructions are useful when looking for a single value in a string or array. 
        mov         edx, OFFSET MessageStringScanning
        call        WriteString
        call        Crlf
 
        ; finding character
        mov         edi, OFFSET firstString
        mov         al, "o"
        mov         ecx, LENGTHOF firstString

        cld
        repne       scasb                               ; repeat while not equal
        jnz         J5                                  ; jump if not found
        mov         edx, OFFSET MessageFound
        call        WriteString
        ; This is what I came up with to find the proper index of the item
        mov         eax, LENGTHOF firstString
        sub         eax, ecx
        call        WriteInt
        call        Crlf

        ; This looks like another way to find the index, 0 based
        ; What does this actually do? 
        ; original: 0004
        ; edi is incremented until it finds the correct place
        ; 0004, 0005, 0006, 0007 until it finds it, lets say its at 0007
        ; we want to know the index so we do 0004-0007
        ; this gives us -3, then we not it and get 3
        ; it sounds like we should subtract eax FROM edi (i did, next block example)
        mov         eax, OFFSET firstString             ; move the memory location into eax of the original string
        sub         eax, edi                            ; subtract the edi memory address from the original
        not         eax                                 
        call        WriteInt

        ; yes this works too but we must dec edi like the book asked to get to 0 based index
        call        Crlf
        dec         edi                                 ; dec because the NEXT index is pointed toat by edi when repe finishes
        mov         eax, edi
        sub         eax, OFFSET firstString
        call        WriteInt

        jmp         J6
J5:     mov         edx, OFFSET MessageNotFound
        call        WriteString
J6:     call        Crlf

; STOSB STOSW STOSD
;   contents of AL/AX/EAX, respectively, in memory at the offset pointed to by EDI
;   When used with the REP prefix, these instructions are useful for filling all elements of a string or array with a single value
        call        Crlf
        mov         edx, OFFSET MessageStringSto
        call        WriteString
        call        Crlf
        mov         eax, 0
        mov         al, 'a'
        mov         edi, OFFSET emptyString
        mov         ecx, COUNT
        cld         ; set the direction flag to have rep increment
        rep         stosb
        mov         edx, OFFSET emptyString
        call        WriteString
        call        Crlf

; LODSB LODSW LODSD
;    load a byte or word from memory at ESI into AL/AX/EAX, respectively
;    The REP prefix is rarely used with LODS because each new value loaded into the
;    accumulator overwrites its previous contents. Instead, LODS is used to load a single value
;
; In the next example, LODSB substitutes for the following two instructions
;       mov al,[esi] ; move byte into AL
;       inc esi ; point to next byte
        cld
        call        Crlf
        mov         edx, OFFSET MessageStringsLod
        call        WriteString
        call        Crlf

        mov         esi, OFFSET lodArray                ; load this each esi into eax
        mov         edi, esi                            ; when storing, store from eax into edi (or the same lodArray index)
        mov         ecx, LENGTHOF lodArray              ; used for L1 loop, since we aren't using any reps, this is fine

L1:     lodsd                                           ; load esi into eax (eax because lodsD the d means dword)
        mul         lodMultiplier                       ; multiply eax by lodMultiplier (10)
        stosd                                           ; store eax into edi (same element as esi)
        loop        L1                                  ; keep going until there are no more elements

        ; print the results
        mov         esi, OFFSET lodArray
        mov         ecx, LENGTHOF lodArray
L2:     mov         eax, [esi]
        call        WriteInt
        mov         al, 2Ch                             ; print a comma
        call        WriteChar
        mov         al, 20h                             ; print a space
        add         esi, TYPE DWORD
        loop        L2

        Invoke      ExitProcess,0
main ENDP
END main