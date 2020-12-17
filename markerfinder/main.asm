# MAIN.ASM
# The entry point of the program.

        .data
imgbuf: .byte   0:76799             # buffer for the bitmap
imgw:   .half   0                   # bitmap width
imgh:   .half   0                   # bitmap height

bounds: .half   0:3                 # boundaries of chunk: xmin, xmax, ymin, ymax

fname:  .asciiz "input.bmp"         # input filename

        .text
        la      $a0, fname          # obtain bitmap
        la      $a1, imgbuf
        la      $a2, imgw
        la      $a3, imgh
        jal     read_bitmap
        
        la      $a0, bounds         # find next chunk
        jal     find_chunk
        
        li      $v0, 10             # exit
        syscall
