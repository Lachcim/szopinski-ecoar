# MAIN.ASM
# The entry point of the program.

        .data
imgbuf: .byte   0:76799             # buffer for the bitmap
bounds: .half   0:3                 # chunk boundaries: xmin, xmax, ymin, ymax
fname:  .asciiz "input.bmp"         # input filename
comma:  .asciiz ", "                # comma for coordinate printing

        .text
        la      $a0, fname          # obtain bitmap
        la      $a1, imgbuf
        jal     read_bitmap
        
        la      $a0, bounds         # prepare bounds and bitmap buffer as arguments
        la      $a1, imgbuf
        
findnx: jal     find_chunk          # find chunk in the bitmap
        beqz    $v0, exit           # exit if there are no more chunks
        
        jal     validate_chunk      # check whether the chunk is a valid marker
        beqz    $v0, findnx         # continue if not
        
        jal     print               # print coordinates of valid marker
        j       findnx              # reiterate

exit:   li      $v0, 10             # exit program
        syscall

print:  move    $t0, $a0            # save argument

        li      $v0, 1              # print integer
        lh      $a0, 2($t0)         # load xmax (for marker 2)
        syscall
        li      $v0, 4              # print string
        la      $a0, comma          # comma space combo
        syscall
        li      $v0, 1              # print integer
        lh      $a0, 4($t0)         # load ymin (for marker 2)
        syscall
        li      $v0, 11             # print character
        li      $a0, 10             # line feed
        syscall
        
        move    $a0, $t0            # restore argument
        jr      $ra                 # return to caller
