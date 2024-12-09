.386                                    ; minimum cpu required for this program
.model flat,stdcall                     ; tells which memory segmentation model to use (flat), convention used for passing parameters (stdcall enables the calling of MS-Windows functions)
.stack 4096                             ;
ExitProcess PROTO, dwExitCode:DWORD     ; prototype windows function that halts the current program (probably in kernel32?)
DumpRegs PROTO                          ; prototype for the irvine call

;these are required because im not using visual studio
INCLUDELIB  C:\Irvine\Kernel32.lib
INCLUDELIB  C:\Irvine\User32.lib     ; I think this is only included because irvine32 lib needs to implement some of its prototypes
INCLUDELIB  C:\Irvine\Irvine32.lib

.data
    val1 DWORD 10000h
    val2 DWORD 40000h
    val3 DWORD 20000h
    finalVal DWORD ?


.code                       ; code segment
main PROC                   ; create a procedure called main
    mov eax, val1
    add eax, val2
    sub eax, val3
    mov finalVal, eax
    call DumpRegs           ; this is from the irvine32 lib, i should probably learn how to do this myself

    INVOKE ExitProcess,0    ; INVOKE is an assembler directive that calls a procedure, passing argument 0 to ExitProcess

main ENDP                   ; end the main procedure
END main                    ; tell the assembler that the program is finished and the entry point is the main procedure




COMMENT !
ml /c masm32bit.asm     WHERE /c disabled auto-linking, so it can be done in a separate command, it can more useful
ml /coff \Masm32\test.asm -link /subsystem:console
/coff is apparently an older obj type
-link /subsystem:console      this is the part that defines the subsystem

Proper command: ml masm32bit.asm -link /subsystem:console
!