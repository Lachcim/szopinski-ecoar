; LOCATOR.ASM
; Searches the bitmap buffer for the next marker. Returns coordinates in eax and
; edx, returns -1 if there are no more markers.

SECTION .data

nexti:  dd          322                     ; index to start the search at

SECTION .text
        GLOBAL locate_marker

locate_marker:
        push        ebp                     ; create new stack frame
        mov         ebp, esp
        push        esi                     ; preserve registers
        sub         esp, 4                  ; align stack
        
        mov         esi, [ebp + 8]          ; set esi as pointer to start location
        add         esi, [nexti]
        
.seek:  mov         al, [esi]               ; dereference source pointer
        cmp         al, 1                   ; if not black, continue search                  
        jne         .scont
        
        mov         [esp], esi              ; call validation subroutine and obtain (width - 1)
        call        validate_marker
        
        cmp         eax, 0                  ; if the width is negative, the marker is invalid
        js          .sinvl

        mov         ecx, [nexti]            ; save current index
        add         DWORD [nexti], eax      ; increment start index
        add         DWORD [nexti], 1
        
        add         eax, ecx                ; get index of arm intersection (current index + width - 1)
        mov         edx, 0                  ; divide by buffer width to obtain coordinates
        mov         ecx, 322
        div         ecx
        dec         eax                     ; subtract buffer margin
        dec         edx
        jmp         .exit                   ; return to caller
        
.sinvl  not         eax                     ; invert ~width to obtain (width - 1)
        add         esi, eax                ; add (width - 1) to pointer and index
        add         DWORD [nexti], eax
        
.scont: inc         esi                     ; increment source pointer and index
        inc         DWORD [nexti]
        
        cmp         DWORD [nexti], 77602    ; if index reached margin, fail
        je          .fail
        jmp         .seek                   ; otherwise seek next marker
        
.fail:  mov         eax, -1
.exit:  add         esp, 4                  ; restore stack pointer
        pop         esi                     ; restore registers
        mov         esp, ebp                ; restore old stack frame
        pop         ebp
        ret

validate_marker:
        push        ebp                     ; create new stack frame
        mov         ebp, esp
        
        mov         eax, 1
        
        mov         esp, ebp                ; restore old stack frame
        pop         ebp
        ret
