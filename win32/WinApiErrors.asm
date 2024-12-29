; ml xx.asm -link /subsystem:console
.386
.model flat,stdcall
.stack 4096

IncludeLib  C:\Irvine\Kernel32.lib
IncludeLib  C:\Irvine\User32.lib
;IncludeLib  C:\Irvine\Irvine32.lib

ExitProcess     PROTO, dwExitCode:DWORD

; If a Windows API function returns an error value (such as NULL), you can call the GetLastError
;    API function to get more information about the error. It returns a 32-bit integer error code in
;    EAX. DWORD

; MS-Windows has a large number of error codes, so you’ll probably want to obtain a message
;    string explaining the error. To do that, call the FormatMessage function
FormatMessageA PROTO,
                dwFlags:DWORD,
                lpSource:DWORD,
                dwMsgID:DWORD,
                dwLanguageID:DWORD,
                lpBuffer:PTR BYTE,
                nSize:DWORD,
                va_list:DWORD

                ; • dwFlags, doubleword integer that holds formatting options, including how to interpret the
                ;   lpSource parameter. It specifies how to handle line breaks, as well as the maximum width of a formatted
                ;    output line. The recommended values are FORMAT_MESSAGE_ALLOCATE_BUFFER + FORMAT_MESSAGE_FROM_SYSTEM (the backslash in the book is a line continuation)
                ;           Error Handler Variables
                ;               FORMAT_MESSAGE_ALLOCATE_BUFFER     = 100h
                ;               FORMAT_MESSAGE_FROM_SYSTEM         = 1000h
                ; 
                ; • lpSource, a pointer to the location of the message definition. Given the dwFlags setting we
                ; recommend, set lpSource to NULL (0).
                ;
                ; • dwMsgID, the integer doubleword returned by calling GetLastError.
                ;
                ; • dwLanguageID, a language identifier. If you set it to zero, the message will be language neutral,
                ;   or it will correspond to the user’s default locale.
                ;
                ; • lpBuffer (output parameter), a pointer to a buffer that receives the null-terminated message
                ; string. Because we use the FORMAT_MESSAGE_ALLOCATE_BUFFER option, the buffer
                ; is allocated automatically.
                ;
                ; • nSize, which can be used to specify a buffer to hold the message string. You can set this
                ; parameter to 0 if you use the options for dwFlags suggested above.
                ;
                ; • va_list, a pointer to an array of values that can be inserted in a formatted message. Because
                ; we are not formatting error messages, this parameter can be NULL (0).
GetLastError   PROTO
LocalFree   PROTO,
                hMem:DWORD
.data
        MsgID DWORD ?
        pErrorMsg DWORD ?
.code
main PROC
        call        GetLastError
        mov         MsgID, eax
;NULL EQU 0
        Invoke      FormatMessageA, 100h + 1000h, 0, MsgID, 0, ADDR pErrorMsg, 0, 0

        ; release storage allocated by format message
        Invoke      LocalFree, pErrorMsg
        
        Invoke      ExitProcess,0
main ENDP
END main