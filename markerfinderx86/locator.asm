; LOCATOR.ASM
; Searches the bitmap buffer for the next marker. Returns coordinates in eax and
; edx, returns -1 if there are no more markers.

SECTION .data
        EXTERN buf
        EXTERN bufw
        EXTERN bufsiz

nexti:  dd          322                     ; index to start the search at

SECTION .text
        GLOBAL locate_marker
        EXTERN validate_marker

locate_marker:
        push        ebp                     ; create new stack frame
        mov         ebp, esp
        push        esi                     ; preserve registers
        sub         esp, 4                  ; align stack
        
        mov         esi, [buf]              ; set esi as pointer to start location
        add         esi, [nexti]
        
.seek:  mov         al, [esi]               ; dereference source pointer
        cmp         al, 1                   ; if not black, continue search                  
        jne         .cont
        
        mov         [esp], esi              ; call validation subroutine and obtain (width - 1)
        call        validate_marker
        
        cmp         eax, 0                  ; if the width is negative, the marker is invalid
        js          .inval

        mov         ecx, [nexti]            ; save current index
        add         [nexti], eax            ; increment start index
        add         [nexti], DWORD 1
        
        add         eax, ecx                ; get index of arm intersection (current index + width - 1)
        mov         edx, 0                  ; divide by buffer width to obtain coordinates
        mov         ecx, [bufw]
        div         ecx
        dec         eax                     ; subtract buffer margin
        dec         edx
        jmp         .exit                   ; return to caller
        
.inval  not         eax                     ; invert -width to obtain (width - 1)
        add         esi, eax                ; add (width - 1) to pointer and index
        add         [nexti], eax
        
.cont:  inc         esi                     ; increment source pointer and index
        inc         DWORD [nexti]
        
        mov         eax, [bufsiz]           ; if index reached end of buffer, fail
        cmp         [nexti], eax
        je          .fail
        jmp         .seek                   ; otherwise seek next marker
        
.fail:  mov         eax, -1
.exit:  add         esp, 4                  ; restore stack pointer
        pop         esi                     ; restore registers
        mov         esp, ebp                ; restore old stack frame
        pop         ebp
        ret
