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
        
        mov         esi, [ebp + 8]          ; set esi as pointer to start location
        add         esi, [nexti]
        
.seek:  mov         al, [esi]               ; dereference source pointer
        cmp         al, 1                   ; if not black, continue search                  
        jne         .scont
        
        mov         eax, [nexti]
        mov         edx, 0
        mov         ecx, 322
        div         ecx
        add         DWORD [nexti], 1
        jmp         .exit
        
.scont: inc         esi                     ; increment source pointer and index
        inc         DWORD [nexti]
        
        cmp         DWORD [nexti], 77601    ; if index reached margin, fail
        je          .fail
        jmp         .seek                   ; otherwise seek next marker
        
.fail:  mov         eax, -1
.exit:  pop         esi                     ; restore registers
        mov         esp, ebp                ; restore old stack frame
        pop         ebp
        ret
