# BMPREADER.ASM
# Reads the BMP file into a bitmap.

        .data
buffer: .byte   0:192               # buffer for file contents

        # error strings for bmp parser
err1:   .asciiz "Couldn't open input file"
err2:   .asciiz "BMP header not supported"
err3:   .asciiz "Only 24-bit BMP files are supported"

        .text
        .globl read_bitmap
        
read_bitmap:
        move    $t0, $a1            # move arguments to temp registers
        move    $t1, $a2
        
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
        
        li      $v0, 16             # close file
        syscall
        
        jr      $ra                 # return to caller
        
dsper1: la      $a0, err1           # load error message to $a0 and print it
        j       perr
dsper2: la      $a0, err2
        j perr
dsper3: la      $a0, err3

perr:   li      $v0, 4              # print error
        syscall
        li      $v0, 17             # exit with code 1
        li      $a0, 1
        syscall
