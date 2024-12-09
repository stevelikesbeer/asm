INCLUDE C:\Irvine\Irvine32.inc

;these are required because im not using visual studio
INCLUDELIB  C:\Irvine\Kernel32.lib
INCLUDELIB  C:\Irvine\User32.lib
INCLUDELIB  C:\Irvine\Irvine32.lib

.code                       ; code segment
main PROC                   ; create a procedure called main
    mov eax, 10000h
    add eax, 40000h
    sub eax, 20000h
    call DumpRegs           ; this is from the irvine32 lib, i should probably learn how to do this myself

    exit

main ENDP                   ; end the main procedure
END main                    ; tell the assembler that the program is finished and the entry point is the main procedure

COMMENT !
ml /c masm32bit.asm     WHERE /c disabled auto-linking, so it can be done in a separate command, it can more useful
ml /coff \Masm32\test.asm -link /subsystem:console
/coff is apparently an older obj type
-link /subsystem:console      this is the part that defines the subsystem

Proper command: ml masm32bit.asm -link /subsystem:console
!