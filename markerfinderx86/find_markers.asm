; FIND_MARKERS.ASM
; Main function exposed to C. Modifies input buffers and returns the number of
; found markers (or an error code).

SECTION .data  
        GLOBAL buf
        GLOBAL bufw
        GLOBAL bufsiz

buf:    dd          0                       ; pointer to bitmap buffer
bufw:   dd          0                       ; buffer width and size
bufsiz: dd          0

SECTION .text
        GLOBAL find_markers
        EXTERN read_bitmap
        EXTERN locate_marker
        EXTERN free
        
find_markers:
        push        ebp                     ; create new stack frame
        mov         ebp, esp
        
        push        ebx                     ; preserve callee-saved registers
        push        esi
        push        edi
        sub         esp, 12                 ; maintain constant stack alignment
        
        mov         ebx, [ebp + 8]          ; load address of raw buffer
        mov         [esp], ebx              ; pass it as argument to read_bitmap
        call        read_bitmap             ; parse raw buffer into bitmap buffer
        
        mov         ebx, eax                ; set error code as return value
        cmp         ebx, 0                  ; return if bitmap read failed (non-zero error code)
        jne         .exit
        
        mov         ebx, 0                  ; marker counter
        mov         esi, [ebp + 12]         ; xpos iterator
        mov         edi, [ebp + 16]         ; ypos iterator
        
.find:  call        locate_marker           ; find next marker
        cmp         eax, -1                 ; if there are none, exit
        je          .stop
        
        mov         [esi], edx              ; append to xpos and ypos
        mov         [edi], eax
        
        inc         ebx                     ; increment counter and iterators
        add         esi, 4
        add         edi, 4
        jmp         .find                   ; reiterate
        
.stop:  mov         eax, [buf]              ; load buffer pointer as argument to free
        mov         [esp], eax
        call        free                    ; free bitmap buffer
        
.exit:  mov         eax, ebx                ; return marker counter or error code
        
        add         esp, 12                 ; restore stack pointer
        pop         edi                     ; restore callee-saved registers
        pop         esi
        pop         ebx
        
        mov         esp, ebp                ; restore old stack frame
        pop         ebp
        ret
