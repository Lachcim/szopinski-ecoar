; FIND_MARKERS.ASM
; Main function exposed to C. Allocates bitmap buffer and coordinates work.
; Modifies input buffers and returns the number of found markers (or an error
; code).

SECTION .text
        GLOBAL find_markers
        EXTERN read_bitmap
        EXTERN calloc
        EXTERN free
        
find_markers:
        push        ebp                     ; create new stack frame
        mov         ebp, esp
        
        push        ebx                     ; preserve callee-saved registers
        push        esi
        push        edi
        sub         esp, 12                 ; maintain constant stack alignment
        
        mov         [esp + 4], DWORD 1      ; allocate memory for a 322*242 bitmap buffer
        mov         [esp], DWORD 77924      ; num (322*242) times size (1)
        call        calloc
        
        mov         ebx, DWORD [ebp + 8]    ; load address of raw buffer
        mov         [esp + 4], ebx
        mov         [esp], eax              ; load address of newly allocated bitmap buffer
        call        read_bitmap             ; parse raw buffer into bitmap buffer
        
        cmp         eax, 0                  ; return if bitmap read failed (negative eax)
        js          .exit
        
        mov         ebx, [ebp + 12]         ; set third xpos to 123
        lea         ebx, [ebx + 8]
        mov         DWORD [ebx], 123
        
.exit:  mov         ebx, eax                ; preserve return value across call
        call        free                    ; free bitmap buffer
        mov         eax, ebx                ; restore return value
        
        add         esp, 12                 ; restore stack pointer
        pop         edi                     ; restore callee-saved registers
        pop         esi
        pop         ebx
        
        mov         esp, ebp                ; restore old stack frame
        pop         ebp
        ret
