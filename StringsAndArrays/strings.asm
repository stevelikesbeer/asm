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

.code
main PROC
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;==============================================================================
;                  *** Five Groups of String Instructions ***
; The following instructions implicitly use ESI, EDI, or both registers to 
; address memory. References to the accumulator imply the use of AL, AX, or EAX
;
; ESI is the SOURCE
; EDI is the DESTINATION
;
;===
; MOVSB, MOVSW, MOVSD:
;   * Move string data: 
;       Copy data from memory addressed by ESI to memory addressed by EDI.
;===   
; CMPSB, CMPSW, CMPSD 
;   * Compare strings: 
;       Compare the contents of two memory locations addressed by ESI and EDI.
;===       
; SCASB, SCASW, SCASD 
;   * Scan string: 
;       Compare the accumulator (AL, AX, or EAX) to the contents of memory 
;       addressed by EDI.
;===       
; STOSB, STOSW, STOSD 
;   * Store string data: 
;       Store the accumulator contents into memory addressed by EDI.
;===
; LODSB, LODSW, LODSD 
;   * Load accumulator from string: 
;       Load memory addressed by ESI into the accumulator.
;
;==============================================================================
;                           *** REPEAT INSTRUCTION ***
; By itself, a string primitive instruction processes only a single memory
; value or pair of values. If you add a repeat prefix, the instruction 
; repeats, using ECX as a counter. The repeat prefix permits you to process an 
; entire array using a single instruction
;===
;REP 
;   Repeat while ECX > 0
;REPZ, REPE 
;   Repeat while the Zero flag is set and ECX > 0
;REPNZ, REPNE 
;   Repeat while the Zero flag is clear and ECX > 0
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Invoke      ExitProcess,0
main ENDP
END main