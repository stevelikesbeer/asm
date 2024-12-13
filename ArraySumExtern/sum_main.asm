.386
.model flat, stdcall
.stack 4096

IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

; I can't figure out how to assemble and link separately, I think he tied his together with Irvine32.inc
IncludeLib _prompt.Lib
;IncludeLib _arraysum.lib
;Include _display.asm

;EXTERN  PromptForIntegers@0:PROC
;EXTERN  _ArraySum@0:PROC
;EXTERN  DisplaySum@0:PROC

; redefine external for readability
;PromptForIntegers   EQU PromptForIntegers@0
;ArraySum            EQU _ArraySum@0
;DisplaySum          EQU DisplaySum@0

;Include C:\Irvine\Irvine32.inc

ExitProcess PROTO, dwExitCode:DWORD
PromptForIntegers PROTO

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
       ; push        COUNT
       ; push        OFFSET ArrayBuffer
       ; call        ArraySum
       ; add         esp, 8
       ; mov         Sum, eax

        ; Sum: +12, prompt+8
        ;push        Sum
        ;push        OFFSET MessageSumResponse
        ;call        DisplaySum
        ;add         esp, 8

        Invoke      ExitProcess,0
main ENDP
END main