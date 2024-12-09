.386
.model flat,stdcall
.stack 4096

IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

ExitProcess PROTO, dwExitCode:DWORD
WriteString PROTO   
WriteInt PROTO
DumpRegs PROTO
Crlf PROTO

.data
    array DWORD 10,60,20,33,72,89,45,65,72,18
    arraySize DWORD ($ - array) / TYPE array
    sum DWORD ?
    sample DWORD 50
    greaterThanOrEqualMessage BYTE "eax is greater than or equal to ebx",0
    lessThanMessage BYTE "eax is less than ebx",0
    routineOneMessage BYTE "This is routine 1",0
    routineTwoMessage BYTE "This is routine 2",0
    routineThreeMessage BYTE "This is route 3",0
    valOneMessage BYTE "The value of val1 is: ",0
    valTwoMessage BYTE "The value of val 2 is: ",0
    val1 DWORD 20
    val2 DWORD 25
.code
main PROC

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; efficient if satement with default value
;==============================================
; message = <>;
; if eax >= ebx
;   message = <>;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
COMMENT !
    mov eax, 1
    mov ebx, 2
    mov edx, OFFSET lessThanMessage             ; give edx a default value

    cmp eax,ebx
    jb  WriteMessage
    mov edx, OFFSET greaterThanOrEqualMessage   ; if the statement is true (eax >= ebx), update message

    WriteMessage:
        call WriteString

    Invoke  ExitProcess,0
!

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; efficient if else satement
;==============================================
; if op1 > op2 then
;   call Routine1
; else
;   call Routine2
; end if
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
COMMENT !
    mov eax, 1
    mov ebx, 2
    cmp eax, ebx
    ja EaxLargerThanEbx
    call Routine2           ; eax <= ebx
    jmp Exit
    EaxLargerThanEbx:
        call Routine1

    Exit:
        Invoke ExitProcess,0
!
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; efficient if else & if else nested satement
;==============================================
; if op1 == op2 then
;   if X > Y then
;       call Routine1
;   else
;       call Routine2
;   end if
; else
;   call Routine3
; end if
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
COMMENT!
    mov eax, 1
    cmp eax, 1
    jne NotEqual
; PROCESS NESTED CONDITIONAL IF EQUAL
    mov ebx, 3
    cmp ebx, 4
    jbe BelowOrEqual    ; if ebx <= 
    call Routine1   ; if ebx >  
    jmp Quit
    BelowOrEqual:       ; if ebx <=
        call Routine2
        jmp Quit
; END NESTED CONDITIONAL
    NotEqual:
        call Routine3

    Quit:
        Invoke ExitProcess,0
!
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Logical AND including short-circuit
;==============================================
; if (al > bl) AND (bl > cl) then
;   call Routine1
; end if
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
COMMENT!
    mov eax, 0A0000000h
    mov ebx, 90000000h
    mov ecx, 80000000h

    cmp eax, ebx
    jbe Quit
    cmp ebx, ecx
    jbe Quit
    call Routine1
    Quit:
        Invoke ExitProcess,0
!
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Logical OR Operator
;==============================================
; if (al > bl) OR (bl > cl) then
;   call Routine1
; end if
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
COMMENT!
    mov eax, 0A0000000h
    mov ebx, 90000000h
    mov ecx, 0F0000000h

    cmp eax, ebx
    ja TrueStatement
    cmp ebx, ecx
    jbe Quit

    TrueStatement:
        call Routine1
    Quit:
        Invoke ExitProcess,0
!
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; While Loop
;==============================================
; while( val1 < val2 )
; {
;   val1++;
;   val2--;
; }
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
COMMENT!
    mov eax, val1
    BegineWhile:
        cmp eax, val2
        jnl EndWhile
        inc eax
        dec val2
        jmp BegineWhile
    EndWhile:
    mov val1, eax

    mov edx, OFFSET valOneMessage
    call WriteString
    mov eax, val1
    call WriteInt

    mov edx, OFFSET valTwoMessage
    call WriteString
    mov eax, val2
    call WriteInt

    Invoke ExitProcess,0
!
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Nested Conditional inside While Loop
;==============================================
; int array[] = {10,60,20,33,72,89,45,65,72,18};
; int sample = 50;
; int ArraySize = sizeof array / sizeof sample;
; int index = 0;
; int sum = 0;
; while( index < ArraySize )
; {
;   if( array[index] > sample )
;   {
;       sum += array[index];
;   }
;   index++;
; }
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
COMMENT! THIS IS MY VERSION:
    mov eax,0               ; SUM
    mov ecx, arraySize
    mov esi, 0              ; COUNTER / index
    mov edx, sample
    BeginWhile:
        cmp esi, ecx
        jnb EndWhile

        ;IF
        cmp array[esi *4], edx
        jna EndTheIf
            add eax, array[esi*4]
        EndTheIf:

        inc esi
        jmp BeginWhile
    EndWhile:
    call WriteInt
    Invoke ExitProcess,0
!
COMMENT!
; this is their version
    mov     eax,0               ; sum
    mov     edx,sample
    mov     esi,0               ; index
    mov     ecx,arraySize
L1: cmp     esi,ecx             ; if esi < ecx
    jl      L2
    jmp     L5
L2: cmp     array[esi*4], edx   ; if array[esi] > edx
    jg      L3
    jmp     L4
L3: add     eax,array[esi*4]
L4: inc     esi
    jmp     L1
L5: mov     sum,eax

    call    WriteInt
    Invoke  ExitProcess,0

!
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; If AND/OR else
;==============================================
; if( ebx > ecx AND ebx > edx) OR ( edx > eax ) then
;   X = 1
; else
;   X = 2
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        mov     eax, 4
        mov     ebx, 2
        mov     ecx, 1
        mov     edx, 1

        cmp     ebx, ecx
        jna     L1                  ; The first AND was false, try the ORs
        cmp     ebx, edx
        jna     L1                  ; the Second AND was false, try the ORs
        jmp     L2                  ; both ANDS were true, skip the ORs and jump to L2
L1:     cmp     edx, eax            ; ORs
        ja      L2                  ; If OR was true, Jump to L2
        call    Routine1            ; nothing was true
        jmp     Quit                
L2:     call    Routine2            ; one block was true
Quit:   Invoke  ExitProcess, 0
main ENDP

;==============================================
;==============================================
Routine1 PROC uses edx
    mov edx, OFFSET routineOneMessage
    call WriteString
    ret
Routine1 ENDP

Routine2 PROC uses edx
    mov edx, OFFSET routineTwoMessage
    call WriteString
    ret
Routine2 ENDP

Routine3 PROC uses edx
    mov edx, OFFSET routineThreeMessage
    call WriteString    
    ret
Routine3 ENDP
END main