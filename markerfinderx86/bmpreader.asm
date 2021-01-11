; BMPREADER.ASM
; Parses raw input buffer into abstract bitmap buffer.

SECTION .text
        GLOBAL read_bitmap
        
read_bitmap:
        push        ebp                     ; create new stack frame
        mov         ebp, esp
        push        esi                     ; save registers
        push        edi
        
        mov         esi, DWORD [ebp + 8]    ; set pointer to start of buffer
        
        mov         ax, WORD [esi]          ; verify BMP header
        cmp         ax, 0x4D42
        jne         .fail2
        mov         eax, DWORD [esi + 14]   ; verify header size
        cmp         eax, 40
        jne         .fail3
        mov         eax, DWORD [esi + 30]   ; verify compression
        cmp         eax, 0
        jne         .fail3
        mov         ax, WORD [esi + 28]     ; verify bit depth
        cmp         ax, 24
        jne         .fail4
        
        push        DWORD [esi + 18]        ; image width
        push        DWORD [esi + 22]        ; line counter initialized to height
        mov         ecx, DWORD [esp + 4]    ; column counter initialized to width
        
        add         esi, 54                 ; move source pointer to first pixel
        mov         eax, 322                ; set destination pointer to lower left corner
        mul         DWORD [esp]             ; plus a margin of one column and one row
        add         eax, 1
        mov         edi, DWORD [ebp + 12]   ; initialize as start of buffer and add offset
        add         edi, eax
        
        mov         eax, DWORD [esp + 4]    ; calculate padding bytes as width mod 3
        and         eax, 3
        
.paint: cmp         BYTE [esi], 0           ; check any RGB component for a nonzero value
        jnz         .pcont
        cmp         BYTE [esi + 1], 0
        jnz         .pcont
        cmp         BYTE [esi + 2], 0
        jnz         .pcont

        mov         [edi], BYTE 1           ; if pixel is all black, mark as 1 in bitmap

.pcont: add         esi, 3                  ; increment src and dst pointers
        inc         edi
        loop        .paint                  ; loop until end of line reached
        
        sub         edi, 322                ; reset dst pointer to start of previous line
        sub         edi, DWORD [esp + 4]
        mov         ecx, DWORD [esp + 4]    ; reset column counter to image width
        add         esi, eax                ; skip padding bytes
        
        sub         DWORD [esp], 1          ; decrement line counter
        cmp         DWORD [esp], 0          ; loop until top line reached
        jnz         .paint
        
        sub         esp, 8                  ; pop width and line counter
        mov         eax, 0                  ; return zero on success
        jmp         .exit
        
.fail2: mov         eax, -2                 ; labels for failing with the given code
        jmp         .exit
.fail3: mov         eax, -3
        jmp         .exit
.fail4: mov         eax, -4
        
.exit:  pop         edi                     ; restore registers
        pop         esi
        mov         esp, ebp                ; restore old stack frame
        pop         ebp
        ret
