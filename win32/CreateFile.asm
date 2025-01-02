; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib

ExitProcess     PROTO, dwExitCode:DWORD

; The CreateFile function either creates a new file or opens an existing file. If successful, it returns a
; handle to the open file; otherwise, it returns a special constant named INVALID_HANDLE_VALUE (-1)
CreateFileA     PROTO,
                    lpFileName:PTR BYTE,
                    dwDesiredAccess:DWORD,
                    dwShareMode:DWORD,
                    lpSecurityAttributes:DWORD, 
                    dwCreationDisposition:DWORD,
                    dwFlagsAndAttributes:DWORD,
                    hTemplateFile:DWORD
;   |-------------------------------------------------------------------------------------------------------------|
;   | Parameter              | Description                                                                        |
;   |-------------------------------------------------------------------------------------------------------------|
;   | lpFileName             | Points to a null-terminated string containing either a partial or fully qualified  |
;   |                        | filename (drive:\ path\ filename).                                                 |
;   | dwDesiredAccess        | Specifies how the file will be accessed (reading or writing).                      |
;   | dwShareMode            | Controls the ability for multiple programs to access the file while it is          |
;   |                        | open.                                                                              |
;   | lpSecurityAttributes   | Points to a security structure controlling security rights.                        |
;   | dwCreationDisposition  | Specifies what action to take when a file exists or does not exist.                |
;   | dwFlagsAndAttributes   | Holds bit flags specifying file attributes such as archive, encrypted, hidden,     |
;   |                        | normal, system, and temporary.                                                     |
;   | hTemplateFile          | Contains an optional handle to a template file that supplies file attributes       |
;   |                        | and extended attributes for the file being created; when not using this            |
;   |                        | parameter, set it to zero                                                          |
;   |-------------------------------------------------------------------------------------------------------------|

WriteFile           PROTO,
                        hFile:DWORD,;handle to previously opened file
                        lpBuffer:PTR BYTE,
                        nNumberOfBytesToWrite:DWORD,
                        lpNumberOfBytesWritten:PTR DWORD,
                        lpOverlapped:PTR DWORD ; ptr to async information. null for synchronous

; close a currently opened file
CloseHandle         PROTO,
                        hObject:DWORD
.data
        FileName        BYTE "test.txt",0
        TextToWrite     BYTE "Well, this is the first file that I want to write ",0dh,0ah ; ahh this is how
                        BYTE "I'm not sure how to insert crlf in the middle here... hmmm"
        TextSize        DWORD ($-TextToWrite)
        BytesWritten    DWORD ?

        FileHandle      DWORD 0
.code
main PROC

        Invoke      CreateFileA,
                        ADDR FileName,
                        40000000h,; GENERIC_WRITE = 40000000h in irvine
                        0,; do not share = 0
                        0,; security attributes is null
                        2,; create_always = 2 from windows.h
                        80h,; File_attribute_normal = 80h (probably from windows.h)
                        0; no template
        mov         FileHandle, eax
        Invoke      WriteFile,
                        FileHandle, ; if CreateFileA was successful, eax contains valid handle. Otherwise it contains -1
                        ADDR TextToWrite,
                        TextSize,
                        ADDR BytesWritten,
                        0

        Invoke      CloseHandle, FileHandle

        Invoke      ExitProcess,0
main ENDP
END main