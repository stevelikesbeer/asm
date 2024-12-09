; ml StackParameters.asm -link /subsystem:console
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
        val1            DWORD 6
        val2            DWORD 5

.code
main PROC
        push            val1                            ; push 6
        push            val2                            ; push 5
        call            AddTwo
        call            WriteInt
        ;add             esp, 8                          ; remove the two 4 byte parameters from the runtime stack by moving esp back
                                                        ; we don't have to walk back esp I don't think if we use ret #

        Invoke          ExitProcess,0
main ENDP
AddTwo PROC
        push            ebp                             ; prologue, push ebp onto the stack to preserve its existing value (the base of the previous stack frame)
        mov             ebp, esp                        ; ebp is set to the same value as esp to become the base of the new stack frame
                                                        
        ; Right now the stack frame loooks like this:
        ;  -------------------------
        ;  |            6          |
        ;  -------------------------
        ;  |            5          |
        ;  -------------------------
        ;  |     return address    | <----- call pushes the return address onto the stack.      Return addy is 4 bytes on the stack
        ;  -------------------------
        ;  |        ebp            | <---- EBP, ESP point here                                          EBP is 4 bytes on the stack
        ;  -------------------------
        ;                                                                                               so both are DWORD. 
        ; AddTwo could push additional registers on the stack without altering the offsets of the stack
        ;       parameters from EBP. ESP would change value, but EBP would not.
        ;
        ; Lets do the function body
        mov             eax, [ebp + 12]                 ; second parameter, when stack parameters are referenced this way, they're called Explicit Stack Parameters
        add             eax, [ebp + 8]                  ; first parameter, explicit stack parameter. Symbolic stack parameter would be setting it as some kind of variable? But I think it's EQU so something interpreted by assembler at assemble time?        
        ;call            DumpRegs

        pop             ebp                             ; return the ebp to the original ebp (move it to the previous stack frame since this one is done)

        ;ret                                             ; pop return address off stack and let the instruction pointer continue after the procedure call

        ret             8                               ; We can also specify the number of bytes to add to ebp to remove the arguments we pushed before the procedure call
                                                        ; I think in C style we can't do this because we can pass a variable number of arguments, but we are using std style
AddTwo ENDP
END main