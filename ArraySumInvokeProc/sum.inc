.386
.model flat, stdcall

IncludeLib C:\Irvine\Kernel32.lib
IncludeLib C:\Irvine\User32.lib
IncludeLib C:\Irvine\Irvine32.lib

ExitProcess PROTO, dwExitCode:DWORD

PromptForInteger PROTO
    prtPrompt:PTR BYTE,
    ptrArray:PTR DWORD,
    arraySize: DWORD

ArraySum PROTO
    ptrArray:PTR DWORD,
    arraySize:DWORD

DisplaySum PROTO
    ptrPrompt:PTR BYTE
    theSum:DWORD

WriteInt        PROTO   ; eax
WriteString     PROTO   ; edx
WriteChar       PROTO   ; al
WriteBin        PROTO   ; eax
WriteBinB       PROTO   ; eax for binary, ebx for size (TYPE WORD for example)
WriteHex        PROTO   ; eax also
WriteHexB       PROTO   ; eax for hex, ebx for size
RandomRange     PROTO   ; eax is the upper bound, result is ax
Crlf            PROTO
DumpRegs        PROTO
ReadInt         PROTO   ; eax