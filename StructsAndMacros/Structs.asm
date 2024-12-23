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

COORD STRUCT 
        X           WORD    ?   ; offset 00
        Y           WORD    ?   ; offset 02
COORD ENDS

; unaligned
; Employee STRUCT
;         IdNum       BYTE "00000000"
;         LastName    BYTE 30 DUP(0)
;         Years       WORD 0
;         SalaryHistory   DWORD 0,0,0,0
; Employee ENDS


; Aligning Structure Fields
;   For best memory I/O performance, structure members should be aligned to addresses matching
;   their data types. Otherwise, the CPU will require more time to access the members. For examample
;   a doubleword member should be aligned on a doubleword boundary.

;      |---------------------------------------------------------------------|
;      | Member Type        |     Alignment                                  |
;      |---------------------------------------------------------------------|
;      | BYTE, SBYTE        |     Align on 8-bit (byte) boundary             |
;      | WORD, SWORD        |     Align on 16-bit (word) boundary            |
;      | DWORD, SDWORD      |     Align on 32-bit (doubleword) boundary      |
;      | QWORD              |     Align on 64-bit (quadword) boundary        |
;      | REAL4              |     Align on 32-bit (doubleword) boundary      |
;      | REAL8              |     Align on 64-bit (quadword) boundary        |
;      | structure          |     Largest alignment requirement of any member|
;      | union              |     Alignment requirement of the first member  |
;      |---------------------------------------------------------------------|

; aligned
Employee STRUCT
        IdNum           BYTE "00000000"
        LastName        BYTE 30 DUP(0)
        ALIGN           WORD
        Years           WORD 0
        ALIGN           DWORD
        SalaryHistory   DWORD 0,0,0,0
Employee ENDS


.data
        worker      Employee <>     ; Default Initializers (whats written above in the struct)
        point1      COORD <>        ; Default initializers (X=? Y=?)
        point2      COORD <20>      ; X = 20
        point3      COORD <5,10>    ; x = 5, Y = 5
                                            ; When the initializer for a string is shorter than the field, the remaining spaces are padded with 0s
        person1     Employee <"55252253">   ; Override the first default argument (IdNum)
        person2     Employee {"55252253"}   ; Override the first default argument (IdNum)
        person3     Employee <,"Jones">     ; skip the first argument and place the second
        person4     Employee <,,,2 DUP(20000)> ; For an array field we can initialize some or all of the elements. If we only initialize some, the rest are filled with 0s
        
        ALIGN       WORD
        NumPoints = 3
        allPoints   COORD NumPoints DUP(<0,0>)      ; Array of structures

        ;         Aligning Structure Variables
        ; For best processor performance, align structure variables on memory boundaries equal to the largest structure member.
        ;
        ; The Employee structure contains DWORD fields, so the following definition uses that alignment
        ALIGN       DWORD
        person5     Employee <>

        ; indexed operations
        department Employee 5 DUP(<>)
.code
main PROC
        ; references to members
        mov         dx, worker.Years
        mov         worker.SalaryHistory, 20000
        mov         [worker.SalaryHistory+4], 30000     ; second salary

        mov         edx, OFFSET worker.LastName

        mov         esi, OFFSET worker
        mov         ax, (Employee PTR [esi]).Years      ; THE PTR IS REQUIRED IF THE OFFSET IS IN A REGISTER

        ; THIS WON'T COMPILE
        ;mov        ax, [esi].Years

        ; indexed operations
        mov         esi, TYPE Employee                  ; index = 1
        mov         department[esi].Years, 4

        ; looping
        mov         edi, OFFSET allPoints
        mov         ecx, NumPoints
        mov         ax, 1                               ; starting x and y operations
L1:     mov         (COORD PTR allPoints[edi]).X, ax
        mov         (COORD PTR allPoints[edi]).Y, ax
        add         edi, TYPE COORD
        inc         ax
        loop        L1
        
        Invoke      ExitProcess,0
main ENDP
END main