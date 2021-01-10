; BMPREADER.ASM
; Parses raw input buffer into abstract bitmap buffer.

SECTION .text
        GLOBAL read_bitmap
        
read_bitmap:
        push        ebp                     ; create new stack frame
        mov         ebp, esp
        push        ebx                     ; save registers
        push        esi
        push        edi
        
        mov         esi, DWORD [ebp + 8]    ; set pointer to start of buffer
        
        mov         ax, WORD [esi]          ; verify BMP header
        cmp         ax, 0x4D42
        jne         fail2
        mov         eax, DWORD [esi + 14]   ; verify header size
        cmp         eax, 40
        jne         fail3
        mov         eax, DWORD [esi + 30]   ; verify compression
        cmp         eax, 0
        jne         fail3
        mov         ax, WORD [esi + 28]     ; verify bit depth
        cmp         ax, 24
        jne         fail4
        
        mov         eax, 7
        jmp         exit
        
fail2:  mov         eax, -2                 ; labels for failing with the given code
        jmp         exit
fail3:  mov         eax, -3
        jmp         exit
fail4:  mov         eax, -4
        
exit:   pop         edi                     ; restore registers
        pop         esi
        pop         ebx
        mov         esp, ebp                ; restore old stack frame
        pop         ebp
        ret
