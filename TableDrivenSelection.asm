.386
.model flat, stdcall
.stack 4096

IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

ExitProcess PROTO, dwExitCode:DWORD
ReadChar PROTO      ;al
WriteString PROTO   ;edx
Crlf PROTO

.data
    CaseTable BYTE 'A'
        DWORD Process_A
    EntrySize = ($ - CaseTable)
        BYTE 'B'
        DWORD Process_B
        BYTE 'C'
        DWORD Process_C
        BYTE 'D'
        DWORD Process_D
    NumberOfEntries = ($ - CaseTable) / EntrySize
    UserPrompt BYTE "Press capital A,B,C, or D: ",0

    ProcessAMessage BYTE "Process_A was called! ",0
    ProcessBMessage BYTE "Process_B was called! ",0
    ProcessCMessage BYTE "Process_C was called! ",0
    ProcessDMessage BYTE "Process_D was called! ",0
    InvalidEntryMessage BYTE "You entered an invalid character! ",0
.code
main PROC
        mov         edx, OFFSET UserPrompt          ; WriteString uses the value from edx
        call        WriteString                     ; call Irvine32's WriteString procedure
        call        Crlf
        call        ReadChar                        ; gets stored in al
        mov         ecx, NumberOfEntries            ; counter
        mov         edx, OFFSET CaseTable
L1:     cmp         al, BYTE PTR [edx]
        je          L2                              ; if we find the character in the array, call the next process
        add         edx, EntrySize                  ; Move to the next char in the array (skipping the processes)
        loop        L1                              ; Keep looping until we find the character in the array
        call        Invalid_Entry                   ; If we finish the loop (ecx = 0 implied), then we never jump and get here
        jmp         Quit                            ; Don't fall through to L2
L2:     call        NEAR PTR [edx+1]                ; near ptr allows me to call a process with a  pointer, edx + 1 because we want to skip char and call the next process
Quit:   Invoke      ExitProcess,0                   
main ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Invalid_Entry PROC
        mov         edx, OFFSET InvalidEntryMessage
        call        WriteString
        ret
Invalid_Entry ENDP

Process_A PROC
        mov         edx, OFFSET ProcessAMessage
        call        WriteString
        ret
Process_A ENDP

Process_B PROC
        mov         edx, OFFSET ProcessBMessage
        call        WriteString
        ret
Process_B ENDP

Process_C PROC
        mov         edx, OFFSET ProcessCMessage
        call        WriteString
        ret
Process_C ENDP

Process_D PROC
        mov         edx, OFFSET ProcessDMessage
        call        WriteString
        ret
Process_D ENDP

END main