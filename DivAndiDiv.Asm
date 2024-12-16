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
        Message8bitUnsignedDivision     BYTE "8 bit unsigned division (83h/2 = 41 with 1 remainder): ",0
        Message16bitUnsignedDivision    BYTE "16 bit unsigned division (8003h/100h = 80 with 03 remainder): ",0
        Message32bitUnsignedDivision    BYTE "32 bit unsigned division (8003h/100h = 08003000 with 00000020 remainder): ",0

        Message8bitSignedDivision     BYTE "8 bit signed division (-48/5): ",0
        Message16bitSignedDivision    BYTE "16 bit signed division (-5000/256): ",0
        Message32bitSignedDivision    BYTE "32 bit signed division (50000/-256): ",0

        MessageSignExtensionExample     BYTE "Sign extension Examples: ",0
        MessageCBW                      BYTE "CBW (Sign Extending 9Bh AX): ",0
        MessageCWD                      BYTE "CWD (Sign Extending FF9Bh DX:AX): ",0
        MessageCDQ                      BYTE "CDQ (Sign Extending FFFFFF9Bh EDX:EAX): ",0          
        MessageQuotient                 BYTE "Quotient: ",0
        MessageRemainder                BYTE "Remainder: ",0

        Dividend32bit   QWORD 0000000800300020h
        Divisor32Bit    DWORD 00000100h
        
        ; for sign extension examples
        ByteVal         SBYTE   -101                    ; 9Bh
        WordVal         SWORD   -101                    ; FF9Bh
        DWordVal        SDWORD  -101                    ; FFFFFF9Bh

        ; for idiv examples
        SByteValiDiv     SBYTE -48
        SWordValiDiv     SWORD -5000
        SDwordValiDiv    SDWORD +50000

        PARITY_FLAG     = 0004h
        CARRY_FLAG      = 0001h
        ZERO_FLAG       = 0040h
        SIGN_FLAG       = 0080h
        OVERFLOW_FLAG   = 0800h
.code
main PROC
;=============================================================
;    Dividend   Divisor     Quotient    Remainder
;    AX         reg/mem8    AL          AH
;    DX:AX      reg/mem16   AX          DX
;    EDX:EAX    reg/mem32   EAX         EDX
;
;    DIV reg/mem8       the reg/mems are the "Divisor"
;    DIV reg/mem16
;    DIV reg/mem32
;=============================================================
;
;*************=== UNSIGNED DIVISION ===*****************
;*******************************************************
;=== 8 BIT UNSIGNED DIVISION ===
        mov         eax, 0
        mov         ebx, 0
        mov         ecx, 0
        mov         edx, 0

        mov         edx, OFFSET Message8bitUnsignedDivision
        call        WriteString
        mov         ax, 83h                             ; move 83h as the dividend into AX (WORD, not BYTE?)
        mov         bl, 2                               ; move 2 into the byte bl register. I guess this means the divisor is 8 bit
        div         bl

        call        Crlf
        mov         edx, OFFSET MessageQuotient
        call        WriteString

        mov         cl, ah                              ; save the remainder so when we write hex, only the quotient is written
        mov         ah, 0                               ; clear the high byte
        mov         ebx, TYPE BYTE
        call        WriteHexB
        call        Crlf
        mov         edx, OFFSET MessageRemainder
        call        WriteString
        mov         al, cl
        call        WriteHexB
        call        Crlf
;=== 16 BIT UNSIGNED DIVISION ===
        mov         eax, 0
        call        Crlf
        mov         edx, OFFSET Message16bitUnsignedDivision
        call        WriteString

        mov         dx, 0                               ; 16 bit division uses DX:AX as the Dividend, so if I only use AX, I still have to Clear DX
        mov         ax, 8003h
        mov         bx, 100h
        div         bx                                  ; so AX is the quotient, dx is the remainder. The remainder is always the high byte/word/DWORD
        
        mov         cx, dx                              ; dx is the remainder but I need edx for Writing Strings, so store it somewhere else
        call        Crlf
        mov         edx, OFFSET MessageQuotient
        call        WriteString
        mov         ebx, TYPE WORD                      ; for WriteHexB it needs a size
        call        WriteHexB
        call        Crlf

        mov         edx, OFFSET MessageRemainder
        call        WriteString
        mov         ax, cx
        call        WriteHexB
        call        Crlf
        call        Crlf

;=== 32 BIT UNSIGNED DIVISION ===
;EDX:EAX     dividend, and EDX is the remainder and EAX is the quotient
        mov         edx, OFFSET Message32bitUnsignedDivision
        call        WriteString
        call        Crlf
        mov         edx, DWORD PTR Dividend32bit + 4    ; Move the high DWORD of Dividend32bit into edx
        mov         eax, DWORD PTR Dividend32bit
        mov         ebx, Divisor32Bit
        div         ebx                                 ; edx is remainder, eax is quotient

        mov         ecx, edx
        mov         edx, OFFSET MessageQuotient
        call        WriteString
        mov         ebx, TYPE DWORD
        call        WriteHexB
        call        Crlf
        mov         edx, OFFSET MessageRemainder
        call        WriteString
        mov         eax, ecx
        call        WriteHexB
        call        Crlf
;
;*************=== UNSIGNED DIVISION ===*****************
;*******************************************************
; === SIGN EXTENSION INSTRUCTIONS ===
;   cbw = convert byte to word
;   cwd = convert word to dword
;   cdq = convert dword to qword
;   Examples
;       cbw extends the sign bit of AL into AH
;
;=== CBW ===
        call        Crlf
        mov         edx, OFFSET MessageSignExtensionExample
        call        WriteString
        call        Crlf
        mov         eax, 0

        mov         al, ByteVal                         ; AL = 9Bh
        cbw                                             ; AX = FF9Bh (Sign extension into AH)

        mov         edx, OFFSET MessageCBW
        call        WriteString
        mov         ebx, TYPE WORD
        call        WriteHexB
;=== CWD ===
        mov         eax, 0
        call        Crlf
        mov         edx, OFFSET MessageCWD
        call        WriteString
        mov         ax, WordVal                         ; AX = FF9Bh
        cwd                                             ; DX:AX = FFFF:FF9Bh
        mov         ebx, TYPE WORD
        mov         cx, ax                              ; we want to write dx hex first so save ax somewhere
        mov         ax, dx                              ; move dx into ax so WriteHexB can write it
        call        WriteHexB
        mov         al, 3Ah
        call        WriteChar
        mov         ax, cx                              ; move the original ax back into ax
        call        WriteHexB
        call        Crlf
;=== CDQ ===
        ; edx:eax    
        mov         edx, OFFSET MessageCDQ
        call        WriteString

        mov         eax, DWordVal                       ; FFFFFF9Bh
        cdq                                             ; EDX:EAX   FFFFFFFF:FFFFFF9Bh
        mov         ecx, eax
        mov         eax, edx
        call        WriteHex
        mov         al, 3Ah
        call        WriteChar
        mov         eax, ecx
        call        WriteHex
        call        Crlf
        call        Crlf
 
;=== *** IDIV *** ===
;   idiv is the same as div, except we have to sign extend before doing the division.
;***
; === 8 bit signed idiv ===
        mov         eax, 0
        mov         al, SByteValiDiv                    ; -48
        cbw
        mov         bl, +5
        idiv        bl                                  ; (remainder) AH = -3. (quotient) AL = -9

        mov         edx, OFFSET Message8bitSignedDivision
        call        WriteString
        call        Crlf

        mov         edx, OFFSET MessageQuotient
        call        WriteString
        mov         bh, ah
        movsx       eax, al
        call        WriteInt
        call        Crlf

        mov         edx, OFFSET MessageRemainder
        call        WriteString
        mov         al, bh
        movsx       eax, al
        call        WriteInt
        call        Crlf
        call        Crlf

; === 16 bit signed idiv ===
        mov         eax, 0

        ; do the division
        mov         ax, SWordValiDiv                    ; - 5000
        mov         bx, +256                            ; 256
        cwd                                             ; sign extend ax into dx
        idiv        bx                                  ; dx:ax, -136:-19    remainder:quotient

        ; write 16 bit header info
        mov         cx, dx                              ; keep a copy of dx(remainder), while we use edx to write a string
        mov         edx, OFFSET Message16bitSignedDivision
        call        WriteString
        call        Crlf

        ; write quotient message and print the quotient
        mov         edx, OFFSET MessageQuotient
        call        WriteString
        movsx       eax,ax                              ; sign extend ax so when we call WriteInt it prints the correct number
        call        WriteInt
        call        Crlf

        ; write remainder message and print the remainder
        mov         edx, OFFSET MessageRemainder
        call        WriteString
        mov         ax, cx                              ; move the remainder into ax, and write it on screen
        movsx       eax, ax
        call        WriteInt
        call        Crlf
        call        Crlf

; === 32 bit signed idiv ===

        mov         eax, SDwordValiDiv                  ; 50,000
        mov         ebx, -256
        cdq                                             ; sign extend eax into edx
        idiv        ebx                                 ; EDX:EAX Remainder:Quotient   80:-195

        mov         ebx, edx                            ; save the remainder while we print MessageSignExtensionExample

        mov         edx, OFFSET Message32bitSignedDivision
        call        WriteString
        call        Crlf

        mov         edx, OFFSET MessageQuotient
        call        WriteString
        call        WriteInt                            ; eax has the quotient
        call        Crlf

        mov         edx, OFFSET MessageRemainder
        call        WriteString
        mov         eax, ebx                            ; move the remainder into eax so we can WriteInt
        call        WriteInt

; === *** DIVIDE OVERFLOW *** ===
; This will cause everything to break and a cpu interrupt to occur and the program to halt. Keep it commented out
;       I guess it doesn't crash the program, only dividing by 0 will
;           okay dividing by 0 won't either? We'll move on
;
;   IF YOU ARE WORRIED ABOUT DIVIDING BY 0, DO A test THEN JUMP IF ITS EQUAL TO 0 (OR A COMP)
;       mov         ax, 1000h
;       mov         bl, 10h
;       div         bl

        Invoke      ExitProcess,0
main ENDP

;=============================================================
;=============================================================
; input:  cx - flag type / mask
; output: cl - flag status (0 or 1) as char
getFlag PROC    uses edx eax
        pushf
        pop         ax
        pushf
        mov         dx, cx                          ; safe flag type
        mov         cl, 30h                         ; 00110000b bin for char 0, 30h 
        test        ax, dx                          ; clear all bits except for the correct flag bit
        jz          J1                              ; if that bit is not set, jump to keep outbit as 30h / char 0
        or          cl, 01h                         ; turn it into a 1
J1:     popf
        ret
getFlag ENDP

END main