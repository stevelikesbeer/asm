;---------------------------------------------------------------------------------------------------------------------|
; Function              Description
; GetProcessHeap        Returns a 32-bit integer handle to the program’s existing heap area in EAX. If the
;                       function succeeds, it returns a handle to the heap in EAX. If it fails, the return value in
;                       EAX is NULL.
;
; HeapAlloc             Allocates a block of memory from a heap. If it succeeds, the return value in EAX contains
;                       the address of the memory block. If it fails, the returned value in EAX is NULL.
;
; HeapCreate            Creates a new heap and makes it available to the calling program. If the function succeeds,
;                       it returns a handle to the newly created heap in EAX. If it fails, the return value
;                       in EAX is NULL.
;
; HeapDestroy           Destroys the specified heap object and invalidates its handle. If the function succeeds,
;                       the return value in EAX is nonzero.
;
; HeapFree              Frees a block of memory previously allocated from a heap, identified by its address
;                       and heap handle. If the block is freed successfully, the return value is nonzero.
;
; HeapReAlloc           Reallocates and resizes a block of memory from a heap. If the function succeeds, the
;                       return value is a pointer to the reallocated memory block. If the function fails and you
;                       have not specified HEAP_GENERATE_EXCEPTIONS, the return value is NULL.
;
; HeapSize              Returns the size of a memory block previously allocated by a call to HeapAlloc or
;                       HeapReAlloc. If the function succeeds, EAX contains the size of the allocated memory
;                       block, in bytes. If the function fails, the return value is SIZE_T – 1. (SIZE_T equals
;                       the maximum number of bytes to which a pointer can point.)
;---------------------------------------------------------------------------------------------------------------------|
;
;======================================================================================================================
; GetProcessHeap GetProcessHeap is sufficient if you’re content to use the default heap
; owned by the current program. It has no parameters, and the return value in EAX is the heap
; handle:
; GetProcessHeap PROTO

; .data
;         hHeap       DWORD ? ; it's really handle instead of dword, but i don't want to include irvine stuff
; .code
;         INVOKE      GetProcessHeap
;         .IF eax == NULL ; cannot get handle
;             jmp quit
;         .ELSE
;             mov hHeap,eax ; handle is OK
;         .ENDIF
;======================================================================================================================
;
; HeapCreate HeapCreate lets you create a new private heap for the current program:
; HeapCreate PROTO,
;         flOptions:DWORD, ; heap allocation options
;         dwInitialSize:DWORD, ; initial heap size, in bytes
;         dwMaximumSize:DWORD ; maximum heap size, in bytes

; Set flOptions to NULL. Set dwInitialSize to the initial heap size, in bytes. The value is rounded
; up to the next page boundary. When calls to HeapAlloc exceed the initial heap size, it will grow
; as large as the value you specify in the dwMaximumSize parameter (rounded up to the next page
; boundary). After calling it, a null return value in EAX indicates the heap was not created. The fol-
; lowing is a sample call to HeapCreat

; HEAP_START = 2000000 ; 2 MB
; HEAP_MAX = 400000000 ; 400 MB

; .data
;         hHeap HANDLE ? ; handle to heap
; .code
;         INVOKE HeapCreate, 0, HEAP_START, HEAP_MAX
;         .IF eax == NULL ; heap not created
;             call WriteWindowsMsg ; show error message? Is this from irvine I think
;             jmp quit
;         .ELSE
;             mov hHeap,eax ; handle is OK
;         .ENDIF
;======================================================================================================================
;
; HeapDestroy HeapDestroy destroys an existing private heap (one created by HeapCreate).
; Pass it a handle to the heap:
; HeapDestroy PROTO,
;           hHeap:DWORD ; heap handle
; If it fails to destroy the heap, EAX equals NULL

; .data
;         hHeap HANDLE ? ; handle to heap
; .code
;         INVOKE HeapDestroy, hHeap
;         .IF eax == NULL
;           call WriteWindowsMsg ; show error message
;         .ENDIF
;======================================================================================================================
; 
; HeapAlloc HeapAlloc allocates a memory block from an existing heap:
; HeapAlloc PROTO,
;           hHeap:HANDLE, ; handle to private heap block
;           dwFlags:DWORD, ; heap allocation control flags
;           dwBytes:DWORD ; number of bytes to allocate

; Pass the following arguments:
; • hHeap, a 32-bit handle to a heap that was initialized by GetProcessHeap or HeapCreate.
; • dwFlags, a doubleword containing one or more flag values. You can optionally set it to
;   HEAP_ZERO_MEMORY, which sets the memory block to all zeros.
; • dwBytes, a doubleword indicating the size of the heap, in bytes.
; If HeapAlloc succeeds, EAX contains a pointer to the new storage; if it fails, the value returned
; in EAX is NULL. The following statements allocate a 1000-byte array from the heap identified by hHeap and set its 
; values to all zeros:
;
; .data
;       hHeap HANDLE ? ; heap handle
;       pArray DWORD ? ; pointer to array
; .code
;       INVOKE HeapAlloc, hHeap, HEAP_ZERO_MEMORY, 1000
;       .IF eax == NULL
;           mWrite "HeapAlloc failed"
;           jmp quit
;       .ELSE
;           mov pArray,eax
;       .ENDIF
;======================================================================================================================

; HeapFree The HeapFree function frees a block of memory previously allocated from a heap,
; identified by its address and heap handle:
; HeapFree PROTO,
;           hHeap:HANDLE,
;           dwFlags:DWORD,
;           lpMem:DWORD
; The first argument is a handle to the heap containing the memory block; the second argument is
; usually zero; the third argument is a pointer to the block of memory to be freed. If the block is
; freed successfully, the return value is nonzero. If the block cannot be freed, the function returns
; zero. Here is a sample call:
;
; INVOKE HeapFree, hHeap, 0, pArray
;======================================================================================================================
;
;***Error Handling*** If you encounter an error when calling HeapCreate, HeapDestroy, or GetProcessHeap
;                     you can get details by calling the GetLastError API function.
;
; **The HeapAlloc function, on the other hand, does not set a system error code when it fails, so
;   you cannot call GetLastError