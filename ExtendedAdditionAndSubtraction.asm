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
    firstArray  BYTE 34h,12h,98h,74h,06h,0A4h,0B2h,0A2h
    secondArray BYTE 02h,45h,23h,00h,00h,087h,010h,080h
    sum         BYTE 9 dup(0)                           ; 9 because we want it one byte larger than the arrays to store the last carry flag
.code
main PROC
        ;***************************** Add with carry and subtract with borrow **********************
        ;* In C++, writing a program that adds two 1024-bit integers would not be                   *
        ;* easy. But in assembly language, the ADC (add with carry) and SBB (subtract with borrow)  *
        ;* instructions are well suited to this type of problem                                     *
        ;********************************************************************************************

        ; *** === ADC Instruction === ***
        ;    The ADC (add with carry) instruction adds both a source operand and the contents of the Carry
        ;    flag to a destination operand. The instruction formats are the same as for the ADD instruction,
        ;    and the operands must be the same size:
        ;        ADC reg,reg
        ;        ADC mem,reg
        ;        ADC reg,mem
        ;        ADC mem,imm
        ;        ADC reg,imm


        ;Simple Example: the following instructions add two 8-bit integers (FFh + FFh), producing a 16-bit sum in DL:AL, which is 01FEh
        mov         dl, 0
        mov         al, 0FFh
        add         al, 0FFh                            ; This is too big for al register, so the carry flag is set
        adc         dl, 0                               ; this is adding 0 to dl, plus the carry flag, producing 01:al (dl:al)

        ; using the Extended_Add PROC
        mov         esi, OFFSET firstArray
        mov         edi, OFFSET secondArray
        mov         ebx, OFFSET sum
        mov         ecx, LENGTHOF firstArray
        call        Extended_Add

        ; display the results
        mov         esi, OFFSET sum
        mov         ecx, LENGTHOF sum
        call        Display_Sum 
        call        Crlf

        ; *** === SBB Instruction === ***
        ; The SBB (subtract with borrow) instruction subtracts both a source operand and the value of the
        ;   Carry flag from a destination operand.
        ;        SBB reg,reg
        ;        SBB mem,reg
        ;        SBB reg,mem
        ;        SBB mem,imm
        ;        SBB reg,imm

        ;Simple Example: 64-bit subtraction. It sets EDX:EAX to 0000000700000001h and subtracts 2 from this value. 
        ;               The lower 32 bits are subtracted first, setting the Carry flag. 
        ;               Then the upper 32 bits are subtracted, including the Carry flag

        mov         edx, 7                              ; upper half 
        mov         eax, 1                              ; lower half    so, 7:1
        sub         eax, 2                              ; subtract 2    cant subtract 2 from eax alone so we move up to edx also
        SBB         edx, 0                              ; the carry flag is set on previous instruction. Now, subtract the carry flag from edx


        Invoke      ExitProcess,0
main ENDP

;--------------------------------------------------------
;                   Extended_Add PROC
;
; Calculates the sum of two extended integers stored as arrays of bytes.
;
; Receives: ESI and EDI point to the two integer arrays.
;           EBX points to a variable that will hold the sum.
;           ECX indicates the number of bytes to be added.
;
; NOTE: Storage for the sum must be one byte longer than the input operands.
;
; Returns: nothing
;--------------------------------------------------------
Extended_Add PROC
        pushad
        clc                                             ; clear the Carry flag

L1:     mov al,[esi]                                    ; get the first integer
        adc al,[edi]                                    ; add the second integer
        pushfd                                          ; save the Carry flag
        mov [ebx],al                                    ; store partial sum

        ; advance all three pointers
        add esi,1                                       
        add edi,1
        add ebx,1

        popfd                                           ; restore the Carry flag
        loop L1                                         ; repeat the loop

        mov byte ptr [ebx],0                            ; clear high byte of sum
        adc byte ptr [ebx],0                            ; add any leftover carry
        popad

        ret
Extended_Add ENDP



Display_Sum PROC
        pushad

        ; point to the last array element
        add esi,ecx
        sub esi,TYPE BYTE
        mov ebx,TYPE BYTE

L1:     mov al,[esi]                                    ; get an array byte
        call WriteHexB                                  ; display it
        sub esi,TYPE BYTE                               ; point to previous byte
        loop L1

        popad
        ret
Display_Sum ENDP
END main