; There are FOUR types of Conditional Jumps
; listed as follows:
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Specific Flag Values
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; jz    ; jump if zero,         ZF = 1
; jnz   ; jump if not zero,     ZF = 0
; jc    ; jump if carry         CF = 1      ; carry is set when doing non-signed addition but can be ignored during signed arithmetic
; jnc   ; jump if not carry     CF = 0
; jo    ; jump if overflow      OF = 1      ; overflow is set when doing signed arithmetic but can be ignored if doing non-signed
; jno   ; jump if not overflow  OF = 0
; js    ; jump if signed        SF = 1
; jns   ; jump if not signed    SF = 0
; jp    ; jump if parity        PF = 1      ; EVEN # of 1s
; jnp   ; jump if not parity    PF = 0      ; ODD # of 1s
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Equality between Operands or (E)CX
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;   THESE FOLLOW THE cmp leftOp, rightOp INSTRUCTION    ; it follows leftOp < rightOp concept
;
; je    ; Jump if equal (leftOp == rightOp)             ; they also do this after the sub command? so maybe it's not just after cmp
; jne   ; Jump if not equal (leftOp != rightOp)         ; ^
; jcxz  ; Jump if cx register = 0
; jecxz ; jump if ecx register = 0
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Comparison of Unsigned Operands
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    THESE FOLLOW THE cmp leftOp, rightOp INSTRUCTION    ; it follows leftOp < rightOp concept
;
;================= These are the same instructions ================
; JA    ; jump if above                         ; leftOp > rightOp
; JAE   ; Jump if above         or equal        ; leftOp >= rightOp
;
; JNB   ; Jump if not below                     ; leftOp >= rightOp
; JNBE  ; jump if not below and not equal       ; leftOp > rightOp
;=================  These are the same instructions ================
; JB    ; Jump if below                         ; leftOp < rightOp
; JBE   ; Jump if below         or equal        ; leftOp <= rightOp
;
; JNA   ; Jump if not above                     ; leftOp <= rightOp
; JNAE  ; Jump if not above     or equal        ; leftOp < rightOp
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Comparison of Signed Operands
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    THESE FOLLOW THE cmp leftOp, rightOp INSTRUCTION    ; it follows leftOp < rightOp concept
;
;================= These are the same instructions ================
; JG    ; Jump if greater than                  ; leftOp > rightOp
; JGE   ; Jump if greater than      or Equal    ; leftOp >= rightOp
;
; JNL   ; Jump if not less than                 ; leftOp >= rightOp
; JNLE  ; Jump if not less than     or Equal    ; leftOp > rightOp
;================= These are the same instructions ================
; JL    ; Jump if less than                     ; leftOp < rightOp
; JLE   ; Jump if less than         or Equal    ; leftOp <= rightOp
; 
; JNG   Jump if not greater than                ; leftOp <= rightOp
; JNGE  Jump if not greater than    or Equal    ; leftOp < rightOp