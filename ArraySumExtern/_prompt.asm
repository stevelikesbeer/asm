;.model flat, stdcall

IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

Include C:\Irvine\Irvine32.inc
;WriteString     PROTO   ; edx
;ReadInt         PROTO   ; eax
;Crlf            PROTO

.code
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                 PromptForIntegers
; Prompts the user for an array of integers and fills 
;  the array with the user's input
;
; Input: 
;       ptrPrompt:PTR BYTE  +8
;       ptrArray:PTR BYTE   +12
;       arraySize:DWORD     +16
; Returns: Nothing
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PromptForIntegers PROC
        ; symbolic constants
        arraySize EQU [ebp + 16]
        ptrArray  EQU [ebp + 12]
        ptrPrompt EQU [ebp + 8]
        
        ; set up prologue
        push        ebp
        mov         ebp, esp
        pushad

        ; Verify array size is larger than 0
        mov         ecx, arraySize
        cmp         ecx, 0
        jle         J1

        mov         edx, ptrPrompt
        mov         esi, ptrArray

L1:     call        WriteString
        call        ReadInt
        call        Crlf
        mov         [esi], eax
        add         esi, 4
        loop        L1

        ; epilogue
J1:     popad
        pop         ebp
        ret
PromptForIntegers ENDP
END

; ml /c /coff _prompt.asm
; lib /out:_prompt.lib _prompt.obj

; OHH I CAN GET RID OF the below error BY GETTING RID OF THE ENTRY POINT HERE. It seems okay if I do this and convert it to obj with /coff
;
; warning LNK4258: directive '/ENTRY:PromptForIntegers@0' not compatible with switch '/ENTRY:main@0'; ignored
; this is given when assembling and linking sum_main.asm  how to get rid of it