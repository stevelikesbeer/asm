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

.code
main PROC
        ;******************************** ASCII AND UNPACKED ARITHMETIC *******************************************
        ; Add the digit strings directly by successively adding each pair of ASCII digits (2+6, 0+5, 4+2, and 3+1). 
        ; The sum is an ASCII digit string, so it can be directly displayed on the screen.

        ; The second option requires the use of specialized instructions that adjust the sum after adding
        ; each pair of ASCII digits. Four instructions that deal with ASCII addition, subtraction, multiplication
        ; and division are as follows
        ;
        ;   AAA (ASCII adjust after addition)
        ;   AAS (ASCII adjust after subtraction)
        ;   AAM (ASCII adjust after multiplication)
        ;   AAD (ASCII adjust before division)
        ;
        ; ASCII addition and subtraction permit operands to be in ASCII format or unpacked decimal format.
        ; Only unpacked decimal numbers can be used for multiplication and division
        ;       
        ; What is ascii vs unpacked? In ascii its their hex or binary representation. In unpacked, we drop the   
        ;      first 4 bits of each pair and convert them to 0
        ; For example: 33 34 30 32   is ascii for 3402
        ; The unpacked version we drop the first 4 bits of each pair:
        ;     33 34 30 32     ASCII      (0011 0011: 3, 0011 0100: 4, 0011 0000: 0, 0011 0010: 2 )
        ;     03 04 00 02     Unpacked   (0000 0011: 3, 0000 0100: 4, 0000 0000: 0, 0000 0010: 2 )
        ;**********************************************************************************************************

        ; === *** AAA Instruction *** ===
        ; AAA converts AL to two unpacked decimal digits and stores them in AH and AL.
        mov         ah, 0                               ; clear the upper byte of AX
        mov         al, '8'                             ; AX = 0038h    
        add         al, '2'                             ; add 32h   AX =  006A
        aaa                                             ; AX = 0100h   How does it do this? I dont think verys simply, it just knows 6A unpacked is 0100 (or '8'+'2' = unpacked 0100h ready to be xored)
        or          ax, 3030h                           ; AX = 3130h = '10' (Convert to ascii)


        ; ===
        Invoke      ExitProcess,0
main ENDP
END main