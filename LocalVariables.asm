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
    FirstNumber DWORD 10
    SecondNumber DWORD 5
.code
main PROC
        push        FirstNumber
        push        SecondNumber
        call        procedureTest

        Invoke      ExitProcess,0                       ; I could also "push 0", then "call ExitProcess" but i might have to change the prototype
main ENDP

X_local EQU DWORD PTR [ebp-4]                           ; Or I can define more readable versions 
Y_local EQU DWORD PTR [ebp-8]                           ; This would make it sooo much more readable.
                                                        ; I could do the same thing for the parameters. 
procedureTest PROC ; if we use the stack for arguments, we can't use "uses" because that messes with the stack frame and messes up our offsets for the arguments
        push        ebp
        mov         ebp, esp

        ; set local variables
        sub         esp, 8                              ; "make room" for local variables. The room is already there we're just extending what we consider the stack frame manually
        mov         DWORD PTR [ebp - 4], 3              ; first local variable, |          mov  X_local, 4
        mov         DWORD PTR [ebp - 8], 1              ; second local variable |          mov  Y_local, 1

        ; get parameters
        mov         eax, [ebp+8]                        ; first number
        mov         ebx, [ebp+12]                       ; second number

        ; remove local variables. This must be done before we pop ebp to the previous stack frame or else we'll pop the local variable values into ebp
        mov         esp, ebp

        pop         ebp 
        ret         8
procedureTest ENDP

localKeywordTest PROC
        LOCAL       tmp:DWORD                           ; The LOCAL MACRO also sets up the prologue. 
                                                        ; it does the following:
                                                        ;   push ebp
                                                        ;   mov  ebp, esp
                                                        ;   sub  esp, 4    (technically I think it adds 0FFFFFFFCh or -4) to make space for local variable DWORD
                                                        ; It also makes tmp = [ebp -4]
                                                        ; It also adds "leave" to the epilogue, popping ebp 
        xor         eax,eax                             ; clear out eax
        mov         tmp, eax                            ; assign a blank value to tmp. I think this is required

        ret
localKeywordTest ENDP
END main