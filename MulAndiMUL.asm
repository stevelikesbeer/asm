; ml MulAndDiv.asm -link /subsystem:console
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
WriteHex        PROTO
Crlf            PROTO
DumpRegs        PROTO

.data
        MessageCarryFlagSet         BYTE "Carry flag is: ",0
        MessageOverflowFlagSet      BYTE "Overflow flag: ",0

        Message8BitMulMultipliers   BYTE "8 bit multipliers: 05h * 10h (AX): ",0
        Message16BitMulMultipliers  BYTE "16 bit multipliers: 2000h * 0100h (DX:AX): ",0
        Message32BitMulMultipliers  BYTE "32 bit multipliers: 12345h * 1000h (EDX:EAX): ",0

        Message8BitiMulSingleMultipliersPositive  BYTE "8 bit single multipliers (Positive): 48 * 4: ",0
        Message8BitiMulSingleMultipliersNegative  BYTE "8 bit single multipliers (Negative): -4 * 4: ",0
        Message16BitiMulSingleMultipliersPositive BYTE "16 bit single multipliers (Positive): 48 * 4: ",0
        Message32BitiMulSingleMultipliersNegative BYTE "32 bit single multipliers (Negative): 4823424 * -423: ",0

		MessageiMulTwoOperands			BYTE "Two Operand Examples w/o overflow: ",0	
		MessageiMulTwoOperandsOverflow	BYTE "Two Operand Examples WITH overflow: ",0	
		MessageTwoOperands1 			BYTE "(16bit) -16*2 = -32: ",0
		MessageTwoOperands2 			BYTE "(32bit) -16*2 = -32: ",0
		MessageTwoOperands3 			BYTE "(16bit) Previous answer * 2: ",0
		MessageTwoOperands4 			BYTE "(32bit) Previous answer * 2: ",0
		MessageTwoOperands5 			BYTE "-32000 * 2 = -64000: ",0

        MessageMulInstructions      BYTE "******* MUL INSTRUCTIONS  *********",0
        MessageiMulInstructions     BYTE "******* IMUL INSTRUCTIONS *********",0
        MessageStarSeparator        BYTE "***********************************",0

        FlagValue       BYTE    ?
        FlagValue2      BYTE    ?
        TmpWordStorage  WORD    ?
        TmpDWordStorage DWORD   ?
		word1			SWORD	4

        PARITY_FLAG     = 0004h
        CARRY_FLAG      = 0001h
        ZERO_FLAG       = 0040h
        SIGN_FLAG       = 0080h
        OVERFLOW_FLAG   = 0800h
.code
main PROC
;
        ;================================================== Mul ===============================================================
        ;======================================================================================================================
        ; MUL sets the Carry and Overflow flags if the upper half of the product is not equal to zero
        ;
        ; the destination must be twice as large as the multipliers. 
        ;   the multipliers must be the same size
        ;
        ;   al  -> ax
        ;   ax  -> dx:ax
        ;   eax -> edx:eax 
        ;   remember dNa
        ;=======================================================================================================================

        ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MUL 8 bit multipliers ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        call        Crlf
        call        Crlf
        mov         edx, OFFSET MessageStarSeparator
        call        WriteString
        call        Crlf
        mov         edx, OFFSET MessageMulInstructions
        call        WriteString
        call        Crlf
        mov         edx, OFFSET MessageStarSeparator
        call        WriteString
        call        Crlf
        call        Crlf

        mov         eax, 0
        mov         ebx, 0
        mov         cx, CARRY_FLAG

        mov         edx, OFFSET Message8BitMulMultipliers
        call        WriteString

        ; === DO THE MULTIPICATION ===
        mov         al, 05h                             ; 8 bit multiplier
        mov         bl, 10h                             ; 8 bit multiplier
        mul         bl                                  ; the carry flag is clear because the high bits on ax are clear 0050h,0000 0000 0101 0000
        ; ~~~ GET CARRY FLAG AND STORE IT ~~~
        call        getFlag
        mov         FlagValue, cl

        ; === WRITE BINARY RESULTS TO CONSOLE === 
        mov         ebx, TYPE WORD                      ; set the size that WriteBinB will write to console
        call        CrlfSafe
        call        WriteBinB                           ; write eax to console, limited by ebx size
        call        CrlfSafe

        ; === WRITE STRING AND FLAG STATUS TO CONSOLE ===
        mov         edx, OFFSET MessageCarryFlagSet
        call        WriteString
        mov         al, FlagValue                       ; mov the flag into al
        call        WriteChar
        call        CrlfSafe
        call        CrlfSafe
        ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MUL 16 bit multipliers ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        mov         edx, OFFSET Message16BitMulMultipliers
        call        WriteString
        mov         eax, 0
        mov         edx, 0

        ; === DO THE MULTIPLYING ===
        mov         ax, 2000h                           ; 16 bit multiplier 2000h
        mov         bx, 0100h                           ; 16 bit multiplier. I can't use imm values    0100h
        mul         bx                                  ; ax * bx = DX:AX, 2000h*0100h = 0020 0000  DX is set so the carry flag should be too
    
        ; === GET THE FLAG VALUE ===
        call        CrlfSafe
        mov         cx, CARRY_FLAG                      ; set flag for getFlag
        call        getFlag                             ; stores flag in cl
        mov         FlagValue, cl                       ; store flag for later use

        ; === PRINT THE BINARY ANSWER AS CHARS TO CONSOLE ===
        mov         ebx, TYPE WORD                      ; How many bytes WriteBinB will print
        mov         TmpWordStorage, ax                  ; save ax so we can print it second
        mov         ax, dx                              ; move dx into ax so we can print it first
        call        WriteBinB                           ; print ax (original dx)
        mov         al, 20h                             ; put a space between the two words
        call        WriteChar                           ; put a space between the two words
        mov         ax, TmpWordStorage                  ; move the original ax back into ax
        call        WriteBinB                           ; print the original ax

        ; === PRINT THE MESSAGE AND FLAG VALUE ===
        mov         edx, OFFSET MessageCarryFlagSet
        call        CrlfSafe
        call        WriteString
        mov         al, FlagValue                       ; mov cl into the al register so writechar can write it
        call        WriteChar
        call        CrlfSafe
        call        CrlfSafe
        ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MUL 32 bit multipliers ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        mov         eax, 0
        mov         ebx, 0
        mov         ecx, 0
        mov         edx, 0

        ; === DO THE MULTIPLYING ===
        mov         eax, 12345h                         ; 32 bit multiplier 
        mov         ebx, 1000h                          ; 32 bit multiplier
        mul         ebx                                 ; EDX:EAX 00000000 12345000h CF=0

        ; === SAVE THE FLAG VALUE ===
        mov         cx, CARRY_FLAG
        call        getFlag
        mov         FlagValue, cl

        ; === PRINT THE HEX OF EDX:EAX TO THE SCREEN ===
        mov         TmpDWordStorage, eax                ; we want to print edx first so temporarily store this
        mov         eax, edx                            ; we want to print edx first, prepare
        mov         edx, OFFSET Message32BitMulMultipliers ; print helpful header
        call        WriteString                         ; uses edx value
        call        CrlfSafe
        call        WriteHex                            ; writes eax
        mov         al, 20h                             ; put a space between the two
        call        WriteChar
        mov         eax, TmpDWordStorage                ; move the original eax back
        call        WriteHex                            ; write eax

        ; === WRITE FLAG ===
        call        Crlf
        mov         edx, OFFSET MessageCarryFlagSet
        call        WriteString
        mov         al, FlagValue
        call        WriteChar

        ;================================================== iMul ===============================================================
        ;=======================================================================================================================
        ; IMUL preserves the sign of the product. It does this by sign extending the
        ;   highest bit of the lower half of the product into the upper bits of the product. 
        ;
        ; There are three variations of iMul, 
        ;    1) one that takes one operand
        ;    2) two operands 
        ;    3) three operands
        ;
        ; Carry and Overflow flags are set if the upper half of the product is not a sign extension of
        ; the lower half. You can use this information to decide whether to ignore the upper half of the product   
        ; 
        ;=== One Operand Variation ===
        ;   IMUL reg/mem8 ; AX = AL * reg/mem8
        ;   IMUL reg/mem16 ; DX:AX = AX * reg/mem16
        ;   IMUL reg/mem32 ; EDX:EAX = EAX * reg/mem32
        ;
        ;=== Two Operand Variation ===
        ; The two-operand version of the IMUL instruction stores the product in the first operand, which must be a register
        ;   IMUL reg16,reg/mem16
        ;   IMUL reg16,imm8
        ;   IMUL reg16,imm16
        ;
        ;   IMUL reg32,reg/mem32
        ;   IMUL reg32,imm8
        ;   IMUL reg32,imm32
        ;
        ;=== Three Operand Variation ===
        ; The three-operand formats store the product in the first operand.
        ; The second operand can be a 16-bit register or memory operand, which is multiplied by the third
        ; operand, an 8- or 16-bit immediate value
        ;
        ;   IMUL reg16,reg/mem16,imm8
        ;   IMUL reg16,reg/mem16,imm16
        ;
        ;   IMUL reg32,reg/mem32,imm8
        ;   IMUL reg32,reg/mem32,imm32
        ;=====
        ; *** Important about TWO and THREE OPERAND opperations ***
        ; The two-operand and three-operand formats truncate the product to the length of the destination. If significant digits
        ;   are lost, the Overflow and Carry flags are set. Be sure to check one of these flags after performing an IMUL operation with two operands
        ;
        ; ALL Variations: The Carry and Overflow flags will not indicate whether the upper half of the product is Zero.
        ;=======================================================================================================================
        call        Crlf
        call        Crlf
        mov         edx, OFFSET MessageStarSeparator
        call        WriteString
        call        Crlf
        mov         edx, OFFSET MessageiMulInstructions
        call        WriteString
        call        Crlf
        mov         edx, OFFSET MessageStarSeparator
        call        WriteString
        call        Crlf
        call        Crlf

        ; ****=== SINGLE OPERAND 8 BIT POSITIVE (No Sign Extension) ===**** 
        mov         eax, 0
        mov         ebx, 0
        mov         ecx, 0
        mov         edx, 0

        ; === PRINT HEADER ===
        mov         edx, OFFSET Message8BitiMulSingleMultipliersPositive
        call        WriteString
        call        Crlf

        ; === DO THE MULTIPLICATION ===
        mov         al, 48
        mov         bl, 4
        imul        bl                                  ; AX = 00C0h, OF = 1, CF = 1

        ; === SAVE FLAG VALUES ===
        mov         cx, CARRY_FLAG
        call        getFlag
        mov         FlagValue, cl
        mov         cx, OVERFLOW_FLAG
        call        getFlag
        mov         FlagValue2, cl

        ; === PRINT RESULTS ===
        ; 0000 0000 : 1100 0000   ah:al (or ax), so ah is not sign extension of the MSB of al, so we CAN'T ignore ah (CF/OF = 1)
        ; if we did ignore it, 1100 0000 would be -64 (incorrect) instead of 192 (correct)
        mov         ebx, TYPE WORD
        call        WriteBinB                           ; eax, ebx = type
        call        CrlfSafe

        ; === PRINT FLAG VALUES ===
        mov         edx, OFFSET MessageCarryFlagSet
        call        WriteString
        mov         al, FlagValue
        call        WriteChar                           ; carry flag set if not sign extended
        call        CrlfSafe
        mov         edx, OFFSET MessageOverflowFlagSet
        call        WriteString
        mov         al, FlagValue2
        call        WriteChar                           ; overflow flag set if not sign extended
        call        Crlf

        ; ****=== SINGLE OPERAND 8 BIT Negative (Sign Extension) ===**** 
        mov         eax, 0
        mov         ebx, 0
        mov         ecx, 0
        mov         edx, 0

        ; === PRINT HEADER ===
        mov         edx, OFFSET Message8BitiMulSingleMultipliersNegative
        call        Crlf
        call        WriteString
        call        Crlf

        ; === DO THE MULTIPLICATION ===
        mov         al, -4
        mov         bl, 4
        imul        bl          ; AX = -16, or FFF0h  or 11111111 11110000

        ; === SAVE FLAG VALUES ===
        mov         cx, CARRY_FLAG
        call        getFlag
        mov         FlagValue, cl
        mov         cx, OVERFLOW_FLAG
        call        getFlag
        mov         FlagValue2, cl

        ; === PRINT RESULTS ===
        ; 1111 1111 : 1111 0000   ah:al (or ax), so ah is a sign extension of the MSB of al, so we can ignore it (CF/OF = 0)
        mov         ebx, TYPE WORD
        call        WriteBinB
        call        Crlf

        ; === PRINT FLAG VALUES ===
        mov         edx, OFFSET MessageCarryFlagSet
        call        WriteString
        mov         al, FlagValue
        call        WriteChar
        call        Crlf
        mov         edx, OFFSET MessageOverflowFlagSet
        call        WriteString
        mov         al, FlagValue2
        call        WriteChar
        call        Crlf

        ; ****=== SINGLE OPERAND 16 BIT POSITIVE (Sign Extension) ===**** 
        call        Crlf
        mov         edx, OFFSET Message16BitiMulSingleMultipliersPositive
        call		WriteString
		call		Crlf

		mov			eax, 0
		mov			ebx, 0
		mov			ecx, 0
		mov			edx, 0

		; === DO THE MULTIPLICATION ===
		mov			ax, 48
		mov			bx, 4
		imul		bx				; DX:AX = 000000C0h, OF = 0 because it is sign extended

		; === SAVE FLAG VALUES ===
		mov			cx, CARRY_FLAG
		call		getFlag
		mov			FlagValue, cl
		mov			cx, OVERFLOW_FLAG
		call		getFlag
		mov			FlagValue2, cl

		; === PRINT RESULTS ===
		mov			ecx, eax			; We want to print edx first, so save a copy of eax somewhere safe since WriteBinB uses eax
		mov			eax, edx			; move edx into eax so we can call write bin and print it first
		mov			ebx, TYPE WORD		; tell WriteBinB to only print the lower word of eax
		call		WriteBinB			; print the original edx
		mov			al, 20h				; lets throw a space between the two
		call		WriteChar
		mov			eax, ecx			; lets print the original eax, move it back into place
		call		WriteBinB

		; === PRINT THE FLAGS === ; this is sign extended because the MSB in AX is the same as all values in DX
		call		Crlf
		mov			edx, OFFSET MessageCarryFlagSet
		call		WriteString
		mov			al, FlagValue
		call		WriteChar
		call		Crlf
		mov			edx, OFFSET MessageOverflowFlagSet
		call		WriteString
		mov			al, FlagValue2
		call		WriteChar
		call		Crlf

		; ****=== SINGLE OPERAND 32 BIT Negative (Sign Extension) ===**** 
		call		Crlf
		mov			edx, OFFSET Message32BitiMulSingleMultipliersNegative
		call		WriteString
		call		Crlf

		mov			eax, 0
		mov			ebx, 0
		mov			ecx, 0
		mov			edx, 0

		; === DO THE MULTIPLICATION ===
		mov			eax, 4823424
		mov			ebx, -434
		imul		ebx				; EDX:EAX FFFFFFFF:86635D80h		IS sign extended because 8h in the MSB is 10 bin 

		; === SAVE THE FLAGS ===
		mov			cx, CARRY_FLAG
		call		getFlag
		mov			FlagValue, cl
		mov			cx, OVERFLOW_FLAG
		call		getFlag
		mov			FlagValue2, cl

		; === PRINT THE RESULTS ===
		mov			ecx, eax
		mov			eax, edx
		call		WriteHex
		mov			al, 3Ah
		call		WriteChar
		mov			eax, ecx
		call		WriteHex
		call		Crlf

		; === PRINT THE FLAGS ===  flags are 0 because it IS sign extended (8h = 10b), so we can ignore upper DWORD
		mov			edx, OFFSET MessageCarryFlagSet
		call		WriteString
		mov			al, FlagValue
		call		Writechar
		call		Crlf
		mov			edx, OFFSET MessageOverflowFlagSet
		call		WriteString
		mov			al, FlagValue2
		call		WriteChar
		call		Crlf
		call		Crlf
;
		; ****=== TWO OPERANDS  IMUL ===**** 
		; none of these overflow
		mov 		ax,-16 		; AX = -16
		mov 		bx,2 		; BX = 2
		imul 		bx,ax 		; BX = -32
		imul 		bx,2 		; BX = -64
		;imul 		bx,word1 	; BX = -256	, dword1 not set
		mov 		eax,-16 	; EAX = -16
		mov 		ebx,2 		; EBX = 2
		imul 		ebx,eax 	; EBX = -32
		imul 		ebx,2 		; EBX = -64
		;imul 		ebx,dword1 	; EBX = -256 , dword1 not set

		; === MULTIPLY TWO 16 BIT OPERANDS === 
		mov			edx, OFFSET MessageiMulTwoOperands
		call		WriteString
		call		Crlf
		mov			edx, OFFSET MessageTwoOperands1		; 16 bit -16 * 2
		call		WriteString
		mov			eax, 0
		mov			ax, -16
		mov			bx, 2
		imul		bx, ax
		mov			cx, OVERFLOW_FLAG
		call		getFlag
		mov			FlagValue, cl
		movsx		eax, bx
		call		WriteInt
		;call		Crlf
		mov			al, 20h
		call		WriteChar
		mov			edx, OFFSET MessageOverflowFlagSet
		call		WriteString
		mov			al, FlagValue
		call		WriteChar
		call		Crlf
		mov			edx, OFFSET MessageTwoOperands3		; 16 bit previous answer * 2
		call		WriteString
		imul		bx, 2
		mov			cx, OVERFLOW_FLAG
		call		getFlag
		mov			FlagValue, cl
		movsx		eax, bx
		call		WriteInt
		mov			al, 20h
		call		WriteChar
		mov			edx, OFFSET MessageOverflowFlagSet
		call		WriteString
		mov			al, FlagValue
		call		WriteChar
		call		Crlf
		call		Crlf

		; === MULTIPLY TWO 32 BIT OPERANDS === 
		mov			edx, OFFSET MessageTwoOperands2		; 32 bit -16 * 2
		call		WriteString
		mov			eax, -16
		mov			ebx, 2
		imul		ebx, eax
		mov			cx, OVERFLOW_FLAG
		call		getFlag
		mov			FlagValue, cl
		mov			eax, ebx
		call		WriteInt
		mov			al, 20h
		call		WriteChar
		mov			edx, OFFSET MessageOverflowFlagSet
		call		WriteString
		mov			al, FlagValue
		call		WriteChar
		call		Crlf
		mov			edx, OFFSET MessageTwoOperands4		; 32 bit previous answer * 2
		call		WriteString
		imul		ebx, 2

		;save flag
		mov			cx, OVERFLOW_FLAG
		call		getFlag
		mov			FlagValue, cl

		; write answer
		mov			eax, ebx
		call		WriteInt

		; write flag
		mov			al, 20h
		call		WriteChar
		mov			edx, OFFSET MessageOverflowFlagSet
		call		WriteString
		mov			al, FlagValue
		call		WriteChar
		call		Crlf
		call		Crlf

		; === 16 BIT TWO OPERANDS WITH OVERFLOW ===
		mov			edx, OFFSET MessageiMulTwoOperandsOverflow
		call		WriteString
		call		Crlf
		mov			edx, OFFSET MessageTwoOperands5
		call		WriteString
		mov			bx, -32000
		imul		bx, 2
		mov			cx, OVERFLOW_FLAG
		call		getFlag
		mov			FlagValue, cl

		movsx		eax, bx
		call		WriteInt
		mov			al, 20h
		call		WriteChar
		mov			edx, OFFSET MessageOverflowFlagSet
		call		WriteString
		mov			al, FlagValue
		call		WriteChar
		call		Crlf
		call		Crlf

		; ****=== TWO OPERANDS  IMUL ===****
		; last one overflows, no fancy printing to screen here
		imul bx,word1,-16 ; BX = -64
		imul ebx,dword1,-16 ; EBX = -64
		imul ebx,dword1,-2000000000 ; OF = 1


        Invoke      ExitProcess,0
main ENDP

WriteBinSafe PROC
        pushfd
        call        WriteBin
        popfd
        ret
WriteBinSafe ENDP

CrlfSafe PROC
        pushfd
        call        Crlf
        popfd
        ret
CrlfSafe ENDP

; input:  cx - flag type 
; output: cl - flag status (0 or 1) as char
getFlag PROC    uses edx eax
        pushf
        pop     ax
        pushf
        mov     dx, cx                          ; safe flag type
        mov     cl, 30h                         ; 00110000b bin for char 0, 30h 
        test    ax, dx                          ; clear all bits except for the correct flag bit
        jz      J1                              ; if that bit is not set, jump to keep outbit as 30h / char 0
        or      cl, 01h                         ; turn it into a 1
J1:     popf
        ret
getFlag ENDP

END main