; FIND_MARKERS.ASM
; Main function exposed to C. Allocates bitmap buffer and coordinates work.
; Modifies input buffers and returns the number of found markers (or an error
; code).

SECTION .text
        GLOBAL find_markers
        EXTERN read_bitmap
        EXTERN malloc
        EXTERN free
        
find_markers:
        push        ebp                 ; create new stack frame
        mov         ebp, esp
        push        ebx                 ; preserve callee-saved registers

        push        77924               ; allocate memory for a 322*242 bitmap buffer
        call        malloc
        add         esp, 4              ; pop buffer size from stack
        push        eax                 ; push buffer address to stack
        
        sub         esp, 8              ; align stack
        push        eax                 ; push address of bitmap buffer again
        push        DWORD [ebp + 8]     ; push address of raw buffer
        call        read_bitmap         ; parse raw buffer into bitmap buffer
        add         esp, 16             ; pop arguments and padding from stack
        
        cmp         eax, 0              ; return if bitmap read failed (negative eax)
        js          exit
        
        mov         ebx, [ebp + 12]     ; set third xpos to 123
        lea         ebx, [ebx + 8]
        mov         DWORD [ebx], 123
        
exit:   mov         ebx, eax            ; preserve return value across call
        call        free                ; free bitmap buffer
        add         esp, 4              ; pop buffer address from pointer
        mov         eax, ebx            ; restore return value
        
        pop         ebx                 ; restore callee-saved registers
        mov         esp, ebp            ; restore old stack frame
        pop         ebp
        ret
