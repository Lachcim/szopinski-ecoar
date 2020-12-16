# BMPREADER.ASM
# Reads the BMP file into a bitmap.

        .data
buffer: .byte   0:192               # buffer for file contents

        # error strings for bmp parser
err1:   .asciiz "Couldn't open input file"
err2:   .asciiz "Unrecognized file format"
err3:   .asciiz "Unsupported BMP format"
err4:   .asciiz "Only 24-bit BMP files are supported"

        .text
        .globl read_bitmap
        
read_bitmap:
        move    $t8, $a1            # move arguments to temp registers
        move    $t9, $a2
        
        li      $v0, 13             # open input file for reading
        li      $a1, 0              # (fname in $a0)
        li      $a2, 0
        syscall
        
        bltz    $v0, dsper1         # handle errors when opening file
        move    $a0, $v0            # move file descriptor to first argument
        
        li      $v0, 14             # read bmp header
        la      $a1, buffer
        li      $a2, 54
        syscall
        
        lh      $t0, buffer         # check bmp marker
        bne     $t0, 0x4D42, dsper2 
        ulw     $t0, buffer + 14    # check header size
        bne     $t0, 40, dsper3
        ulw     $t0, buffer + 30    # check compression
        bnez    $t0, dsper3
        lh      $t0, buffer + 28    # check bpp
        bne     $t0, 24, dsper4
        
        ulw     $t0, buffer + 18     # extract width and height
        usw     $t0, 0($t9)
        ulw     $t0, buffer + 22
        usw     $t0, 0($a3)
        
        li      $v0, 16             # close file
        syscall
        
        jr      $ra                 # return to caller
        
dsper1: la      $a0, err1           # load error message to $a0 and print it
        j       perr
dsper2: la      $a0, err2
        j perr
dsper3: la      $a0, err3
        j perr
dsper4: la      $a0, err4

perr:   li      $v0, 4              # print error
        syscall
        li      $v0, 17             # exit with code 1
        li      $a0, 1
        syscall
