; BMPREADER.ASM
; Parses raw input buffer into abstract bitmap buffer. Allocates the buffer.

SECTION .data
        EXTERN buf
        EXTERN bufw
        EXTERN bufsiz

SECTION .text
        GLOBAL read_bitmap
        EXTERN calloc
        
read_bitmap:
        push        ebp                     ; create new stack frame
        mov         ebp, esp
        push        esi                     ; save registers
        push        edi
        
        mov         esi, [ebp + 8]          ; set pointer to start of raw buffer
        
        mov         ax, [esi]               ; verify BMP header
        cmp         ax, 0x4D42
        jne         .fail2
        mov         eax, [esi + 14]         ; verify header size
        cmp         eax, 40
        jne         .fail3
        mov         eax, [esi + 30]         ; verify compression
        cmp         eax, 0
        jne         .fail3
        mov         ax, [esi + 28]          ; verify bit depth
        cmp         ax, 24
        jne         .fail4
        
        mov         eax, [esi + 18]         ; set bitmap buffer parameters
        add         eax, 2
        mov         [bufw], eax             ; width = image width + 2
        mov         eax, [esi + 22]         ; height = image height + 2
        add         eax, 2
        mul         DWORD [bufw]            ; multiply bufh by bufw to obtain size
        mov         [bufsiz], eax
        
        sub         esp, 16                 ; align stack
        mov         [esp + 4], DWORD 1      ; element size
        mov         [esp], eax              ; element count (bufsize)
        call        calloc                  ; allocate bitmap buffer
        add         esp, 16                 ; pop arguments and padding
        mov         [buf], eax              ; set static buffer pointer
        
        push        DWORD [esi + 18]        ; image width
        push        DWORD [esi + 22]        ; line counter initialized to height
        mov         ecx, [esp + 4]          ; column counter initialized to width
        
        add         esi, 54                 ; move source pointer to first pixel
        mov         eax, [bufw]             ; set destination pointer to lower left corner
        mul         DWORD [esp]             ; plus a margin of one column and one row
        add         eax, 1
        mov         edi, [buf]              ; initialize as start of buffer and add offset
        add         edi, eax
        
        mov         eax, [esp + 4]          ; calculate padding bytes as width mod 3
        and         eax, 3
        
.paint: cmp         [esi], BYTE 0           ; check any RGB component for a nonzero value
        jnz         .pcont
        cmp         [esi + 1], BYTE 0
        jnz         .pcont
        cmp         [esi + 2], BYTE 0
        jnz         .pcont

        mov         [edi], BYTE 1           ; if pixel is all black, mark as 1 in bitmap

.pcont: add         esi, 3                  ; increment src and dst pointers
        inc         edi
        loop        .paint                  ; loop until end of line reached
        
        sub         edi, [bufw]             ; reset dst pointer to start of previous line
        sub         edi, [esp + 4]
        mov         ecx, [esp + 4]          ; reset column counter to image width
        add         esi, eax                ; skip padding bytes
        
        sub         [esp], DWORD 1          ; decrement line counter
        cmp         [esp], DWORD 0          ; loop until top line reached
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
