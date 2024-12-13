; for extern, I need to convert all files to obj files individually, then link them manually...
; ml /c /coff _prompt.asm _arraysum.asm _display.asm sum_main.asm
;       /c prevents automatic linking, /coff just keeps them as objectfiles?
; link sum_main.obj _prompt.obj _arraysum.obj _display.obj /subsystem:console
;       OMG ^ THE ORDER MATTERS, the entry has to be the first obj file listed

.386
.model flat, stdcall
.stack 4096

IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

EXTERN  PromptForIntegers@0:PROC                        ; Extern tells the assembler to create a blank address for the missing procedure 
                                                        ; that the linker will fill in later
EXTERN  ArraySum@0:PROC
EXTERN  DisplaySum@0:PROC

; redefine external for readability
PromptForIntegers   EQU PromptForIntegers@0             ; the @0 means how many arguments (*4) were declared using the inline PROC method
ArraySum            EQU ArraySum@0                      ;  I'm explicitly getting the arguments with [ebp + x], so it's always @0
DisplaySum          EQU DisplaySum@0

ExitProcess         PROTO, dwExitCode:DWORD

.data
        COUNT = 3 ; the number of integers to request and sum
        MessageInputPrompt  BYTE "Please enter an integer: ",0
        MessageSumResponse  BYTE "The sum of your integers is: ",0

        ArrayBuffer         DWORD COUNT DUP(?) 
        Sum                 DWORD ?
.code
main PROC
        ; arraysize: + 16, arraybuffer: +12,  MessageInputPromp: +8
        push        COUNT
        push        OFFSET ArrayBuffer
        push        OFFSET MessageInputPrompt
        call        PromptForIntegers
        add         esp, 12

        ; arraysize: +12, arrayBuffer+8
        push        COUNT
        push        OFFSET ArrayBuffer
        call        ArraySum
        add         esp, 8
        mov         Sum, eax

        ; Sum: +12, prompt+8
        push        Sum
        push        OFFSET MessageSumResponse
        call        DisplaySum
        add         esp, 8

        Invoke      ExitProcess,0
main ENDP
END main