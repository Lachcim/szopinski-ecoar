# MAIN.ASM
# The entry point of the program.

        .data
imgbuf: .byte   0:76799             # buffer for the bitmap
imgw:   .byte   0                   # bitmap width
imgh:   .byte   0                   # bitmap height

queue:  .word   0:479               # queue data structure for the BFS
qstart: .half   0                   # first element of the queue
qend:   .half   0                   # next available element of the queue

xmin:   .half   0                   # boundaries of the black group
xmax:   .half   0                   # as discovered by the BFS
ymin:   .half   0
ymax:   .half   0

fname:  .asciiz "input.bmp"         # input filename

        .text
        la      $a0, fname
        la      $a1, imgbuf         # obtain bitmap
        la      $a2, imgw
        la      $a3, imgh
        jal     read_bitmap
        
        li      $v0, 10             # exit
        syscall
