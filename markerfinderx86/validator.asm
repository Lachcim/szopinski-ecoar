; VALIDATOR.ASM
; Check whether the given pointer points to a valid marker. Returns (width - 1)
; on success and (-width) on failure.

SECTION .text
        GLOBAL validate_marker

validate_marker:
        push        ebp                     ; create new stack frame
        mov         ebp, esp
        push        esi                     ; preserve registers
        push        edi
        sub         esp, 8                  ; local variables
        
        mov         ecx, 0                  ; get marker width
        mov         esi, [ebp + 8]          ; move start pointer to esi
.width: inc         ecx                     ; increment counter and pointer
        inc         esi
        mov         al, [esi]               ; dereference pointer
        cmp         al, 1                   ; iterate until white encountered
        je          .width
        mov         DWORD [esp + 4], ecx    ; save width
        
        sub         esi, 323                ; move to above top right corner
.top:   mov         al, [esi]               ; check clearance above horizontal arm
        cmp         al, 0
        jne         .fail
        dec         esi
        loop        .top
        
        mov         esi, [ebp + 8]          ; return to top left
.girth: inc         ecx                     ; get marker girth
        add         esi, 322
        mov         al, [esi]
        cmp         al, 1
        je          .girth
        mov         DWORD [esp], ecx        ; save girth
        
        mov         eax, [esp + 4]          ; load marker width
        shl         ecx, 1                  ; multiply girth by 2
        cmp         eax, ecx                ; if width != 2girth, fail
        jne         .fail
        shr         ecx, 1
        
        jmp         .ok
        
.fail:  mov         eax, [esp + 4]          ; return -width
        neg         eax
        jmp         .exit
        
.ok:    mov         eax, [esp + 4]          ; return (width - 1)
        dec         eax

.exit:  add         esp, 8                  ; pop local variables
        pop         edi                     ; restore registers
        pop         esi                     ; restore registers
        mov         esp, ebp                ; restore old stack frame
        pop         ebp
        ret
