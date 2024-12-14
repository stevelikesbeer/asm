; ml /c /coff Sum_main.asm _display.asm _arraySum.asm _prompt.asm
; link Sum_main.obj _display.obj _arraySum.obj _prompt.obj /subsystem:console
;
; Note: I do not have to assemble or link sum.inc because it's included (or automatically "connected") to the other files
;       ALSO make sure the main entry is the first file listed while linking.
;
;   BETTER WAY:
;   I can do the assembling and linking with one command:
;   ml Sum_main.asm _display.asm _arraySum.asm _prompt.asm -link /subsystem:console

.stack 4096

Include sum.inc

.data
        COUNT = 3
        MessageEnterInteger BYTE "Enter an Integer: ",0
        MessageSumIs        BYTE "The sum is: ",0
        ArrayBuffer         DWORD COUNT DUPE(?)
        TheSum              DWORD ?
.code
main PROC
        Invoke      PromptForInteger, COUNT, OFFSET ArrayBuffer, OFFSET MessageEnterInteger
        Invoke      ArraySum, COUNT, OFFSET ArrayBuffer
        mov         TheSum, eax
        Invoke      DisplaySum, TheSum, OFFSET MessageSumIs

        Invoke      ExitProcess, 0
main ENDP
END main