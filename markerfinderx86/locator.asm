; LOCATOR.ASM
; Searches the bitmap buffer for the next marker. Returns coordinates in eax and
; edx, returns -1 if there are no more markers.

SECTION .text
        GLOBAL locate_marker

locate_marker:
        mov         eax, -1
        ret
