; FIND_MARKERS.ASM
; Main function exposed to C. Allocates bitmap buffer and coordinates work.
; Modifies input buffers and returns the number of found markers (or an error
; code).

SECTION .text
        GLOBAL find_markers
        EXTERN read_bitmap
        EXTERN locate_marker
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
        
        mov         ebx, [ebp + 8]          ; load address of raw buffer
        mov         [esp + 4], ebx
        mov         [esp], eax              ; load address of newly allocated bitmap buffer
        call        read_bitmap             ; parse raw buffer into bitmap buffer
        
        mov         ebx, eax                ; set error code as return value
        cmp         ebx, 0                  ; return if bitmap read failed (non-zero error code)
        jne         .exit
        
        mov         ebx, 0                  ; marker counter
        mov         esi, [ebp + 12]         ; xpos iterator
        mov         edi, [ebp + 16]         ; ypos iterator
        
.find:  call        locate_marker           ; find next marker
        cmp         eax, -1                 ; if there are none, exit
        je          .exit
        
        mov         [esi], edx              ; append to xpos and ypos
        mov         [edi], eax
        
        inc         ebx                     ; increment counter and iterators
        add         esi, 4
        add         edi, 4
        jmp         .find                   ; reiterate
        
.exit:  call        free                    ; free bitmap buffer
        mov         eax, ebx                ; return marker counter
        
        add         esp, 12                 ; restore stack pointer
        pop         edi                     ; restore callee-saved registers
        pop         esi
        pop         ebx
        
        mov         esp, ebp                ; restore old stack frame
        pop         ebp
        ret
