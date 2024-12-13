; ml SearchingSorting.asm printArray.asm fillArray.asm bubblesort.asm promptUser.asm binarySearch.asm printResults.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
IncludeLib  C:\Irvine\Irvine32.lib

ExitProcess     PROTO, dwExitCode:DWORD

Extern FillArrayAlphabet@0:PROC
Extern PrintArray@0:PROC
Extern SortArray@0:PROC
Extern PromptUserChar@0:PROC
Extern SearchArray@0:PROC
Extern PrintResults@0:PROC

.data
        COUNT = 26
        MainArray DWORD COUNT DUP('-')

        MessageUnsortedArray    BYTE "The unsorted array is: ",0
        MessageSortedArray      BYTE "The sorted array is: ",0
        MessagePromptChar       BYTE "Please enter a character: ",0
        MessageSuccess          BYTE "Found Item at index: ",0
        MessageFailure          BYTE "Could not find item.",0
.code
main PROC
        ; FillArrayAlphabet (PTRArray:DWORD, ArrayLength:DWORD)
        push        OFFSET MainArray
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
        call        SortArray@0
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
        call        SearchArray@0
        add         esp, 12

        ; PrintResults(Index of found item:DWORD,PTR to success message, PTR to failure Message)
        push        eax
        push        OFFSET MessageSuccess
        push        OFFSET MessageFailure
        call        PrintResults@0
        add         esp, 12

        Invoke      ExitProcess,0
main ENDP
END main