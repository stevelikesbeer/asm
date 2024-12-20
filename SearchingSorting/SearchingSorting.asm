; ml SearchingSorting.asm printArray.asm fillArray.asm bubblesort.asm promptUser.asm binarySearch.asm printResults.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

ExitProcess     PROTO, dwExitCode:DWORD
Crlf            PROTO
WriteString PROTO

Extern FillArrayAlphabet@0:PROC
Extern PrintArray@0:PROC
Extern BubbleSort@0:PROC
Extern PromptUserChar@0:PROC
Extern BinarySearch@0:PROC
Extern PrintResults@0:PROC
Extern PromptUserYesNo@0:PROC

.data
        COUNT = 26
        MainArray DWORD COUNT DUP('-')

        MessageUnsortedArray    BYTE "The unsorted array is: ",0
        MessageSortedArray      BYTE "The sorted array is: ",0
        MessagePromptChar       BYTE "Please enter a character: ",0
        MessageSuccess          BYTE "Found Item at index: ",0
        MessageFailure          BYTE "Could not find item.",0
        MessageRestart          BYTE "Would you Like to restart? (y/n): ",0
.code
main PROC
        ; FillArrayAlphabet (PTRArray:DWORD, ArrayLength:DWORD)
J1:     push        OFFSET MainArray
        push        COUNT
        call        FillArrayAlphabet@0
        add         esp, 8

        ; PrintArray (PTRArray:DWORD, ArrayLength:DWORD, PTRMessage:DWORD)
        push        OFFSET MainArray
        push        COUNT
        push        OFFSET MessageUnsortedArray
        call        PrintArray@0
        add         esp, 12

        ; SortArray (PTRArray:DWORD, ArrayLength:DWORD)
        push        OFFSET MainArray
        push        COUNT
        call        BubbleSort@0
        sub         esp, 8
        
        ; PrintArray (PTRArray:DWORD, ArrayLength:DWORD, PTRMessage:DWORD)
        push        OFFSET MainArray
        push        COUNT
        push        OFFSET MessageSortedArray
        call        PrintArray@0
        add         esp, 12

        ; PromptUserChar(PTR to Message) Returns: EAX of entered character
        push        OFFSET MessagePromptChar
        call        PromptUserChar@0
        add         esp, 4

        ; SearchArray (PTRArray:DWORD, ArrayLength:DWORD, SearchItem:DWORD) Returns: EAX of Index
        push        OFFSET MainArray
        push        COUNT
        push        eax
        call        BinarySearch@0
        add         esp, 12

        ; PrintResults(Index of found item:DWORD,PTR to success message, PTR to failure Message)
        push        eax
        push        OFFSET MessageSuccess
        push        OFFSET MessageFailure
        call        PrintResults@0
        add         esp, 12

        ; PromptUserYesNo(PTR to message) Returns: Eax=1:yes, Eax=0:no
        push        OFFSET MessageRestart
        call        PromptUserYesNo@0
        add         esp, 4
        cmp         eax, 1
        je          J1

        Invoke      ExitProcess,0
main ENDP
END main