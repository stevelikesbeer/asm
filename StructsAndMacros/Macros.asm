; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

ExitProcess     PROTO, dwExitCode:DWORD

; A lot of times its best to start macros with m so we know its a macro
mPrintX MACRO                                           ; where ever the macro is called, the assembler preprocessor 'injects' this code there
        mov         al, 'X'                             ; this is called inline expansion
        call        WriteChar                           ;; two semi-colons means the comments won't get added to the expansion
ENDM

; Macro parameters are named placeholders for text arguments passed to the
; caller. The arguments may in fact be integers, variable names, or other values, but the preproces-
; sor treats them as text.

mPutChar MACRO char
        push        eax
        mov         al, char
        call        WriteChar
        pop         eax
ENDM

mPutCharReq MACRO char:REQ                      ;; Req means the argument is required. Otherwise it will just expand with empty if its not provided
                                                ;;  arguments are treateded as strings, so empty will not cause assmebly-time errors
        ECHO        Expanding the mPutCharReq macro  ;; echo prints a message to the console during assembly only
        push        eax                         
        mov         al, char
        call        WriteChar
        pop         eax
ENDM

; To avoid problems caused by label redefinitions, you can apply the LOCAL
; directive to labels inside a macro definition. When a label is marked LOCAL, the preprocessor
; converts the label’s name to a unique identifier each time the macro is expanded. 
        ; local LabelOfSomeKind

makeString MACRO text
        LOCAL string
        .data
        string BYTE text,0
ENDM

;   ===calling it twice===
; .data
; 1 ??0000 BYTE "Hello",0
; makeString "Goodbye"
; 1 .data
; 1 ??0001 BYTE "Goodbye",0

; The label names produced by the assembler take the form ??nnnn, where nnnn is a unique integer
; The LOCAL directive should also be used for code labels in macros.


;Macros often contain both code and data. The following mWrite macro, for example, displays a
;literal string on the console:
mWrite MACRO text
        LOCAL string ;; local label
        .data
        string BYTE text,0 ;; define the string
        .code
        push edx
        mov edx,OFFSET string
        call WriteString
        pop edx
ENDM

; mWrite "Please enter your first name"
; mWrite "Please enter your last name"


WriteString     PROTO   ; edx
Crlf            PROTO
WriteChar       PROTO

.data

.code
main PROC
        mPrintX
        call        Crlf
        call        Crlf
        mPutChar    'A'
        call        Crlf
        call        Crlf
        mPutCharReq 'R'
        Invoke      ExitProcess,0
main ENDP
END main