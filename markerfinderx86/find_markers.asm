; FIND_MARKERS.ASM
; Main function exposed to C. Allocates bitmap buffer and coordinates work.
; Modifies input buffers and returns the number of found markers (or an error
; code).

SECTION .text
        GLOBAL find_markers
        EXTERN malloc
        EXTERN free
        
find_markers:
        push        ebp                 ; create new stack frame
        mov         ebp, esp
        push        ebx                 ; preserve callee-saved registers

        push        77924               ; allocate memory for a 322*242 bitmap buffer
        call        malloc
        add         esp, 4
        push        eax                 ; save buffer address
        
        call        free                ; free bitmap buffer
        add         esp, 4              ; pop buffer address from pointer
        
        mov         eax, [ebp + 12]     ; set third xpos to 123
        lea         eax, [eax + 8]
        mov         DWORD [eax], 123
        mov         eax, 4
        
        pop         ebx                 ; restore callee-saved registers
        mov         esp, ebp            ; restore old stack frame
        pop         ebp
        ret
