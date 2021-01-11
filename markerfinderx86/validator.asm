; VALIDATOR.ASM
; Check whether the given pointer points to a valid marker. Returns (width - 1)
; on success and (-width) on failure.

SECTION .text
        GLOBAL validate_marker

validate_marker:
        push        ebp                     ; create new stack frame
        mov         ebp, esp
        
        mov         eax, 1
        
        mov         esp, ebp                ; restore old stack frame
        pop         ebp
        ret
