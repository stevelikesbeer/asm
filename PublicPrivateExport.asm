; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096



IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

ExitProcess     PROTO, dwExitCode:DWORD

OPTION PROC:PRIVATE                                     ; all procedures become private by default. Normally they're all public by default
PUBLIC main ;, otherProc, anotherProc                   ;  I can name all public procedures here. 

EXTERN sub1@0:PROC                                      ; The EXTERN directive, used when calling a procedure outside the current module, 
                                                        ; identifies the procedure’s name and stack frame size. Use this *OR* PROTO+INVOKE
                                                        ;
                                                        ; The @n suffix at the end of a procedure name identifies the total stack space 
                                                        ; used by declared parameters. @0 for no parameters, add 4 bytes for every
                                                        ; additional parameter
                                                        ;
                                                        ; When the assembler discovers a missing procedure in a source file (identified by a CALL
                                                        ; instruction), its default behavior is to issue an error message. Instead, 
                                                        ; EXTERN tells the assembler to create a blank address for the procedure. 
                                                        ; The linker resolves the missing address when it creates the program’s executable file
                                                        ;
                                                        ; *** IF I PLAN ON CALLING THE METHOD WITH INVOKE, I DON'T NEED EXTERN, JUST THE PROTOTYPE.
                                                        ;     IF I PLAN ON CALLING IT WITH CALL, I JUST NEED EXTERN AND NO PROTOTYPE

.data

.code
main PROC ;PUBLIC                                        ; If all procedures are private using the above directive, 
                                                        ; be sure to make the entry public
                                                        ;   I'm using the PUBLIC directive above to name all the public methods  in one 
                                                        ;   place so I can comment out THIS public on main

        Invoke      ExitProcess,0
main ENDP

testProc PROC                                           ; This is automatically private because of the directive at the top

        ret
testProc ENDP

testProcPub PROC PUBLIC                                 ; this procedure is going to be public 

        ret
testProcPub ENDP
END main