# BMPREADER.ASM
# Reads the BMP file into a bitmap.

        .data
buffer: .byte   0:54                # buffer for file contents

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
        
        ulw     $t0, buffer + 18    # extract width and height
        usw     $t0, 0($t9)
        ulw     $t1, buffer + 22
        usw     $t1, 0($a3)
        
skprnd: add     $t2, $t1, -1        # obtain pointer to the first pixel
        mul     $t2, $t2, 320       # (lower left corner of the bitmap)
        add     $t2, $t2, $t8       # imgbuf + (height - 1) * 320
        
        mul     $t1, $t0, $t1       # calculate the number of pixels to be read (width * height)
        li      $t3, 0              # position in the current line
        
        not     $t4, $t0            # calculate line feed / carriage return offset
        add     $t4, $t4, -319      # -(width + 1) - 319 = -320 - width
 
readpx: li      $a2, 3              # limit read bytes to 3
        li      $v0, 14             # read single pixel from the file
        syscall
        
        lb      $t5, buffer + 0     # check all components of pixel
        bnez    $t5, calcin         # if any of them is greater than zero,
        lb      $t5, buffer + 1     # mark the pixel as non-black (0, equivalent
        bnez    $t5, calcin         # to no-op due to buffer initialization)
        lb      $t5, buffer + 2
        bnez    $t5, calcin
        
        li      $t5, 1              # set the buffer at the pointer to 1
        sb      $t5, 0($t2)
        
calcin: add     $t2, $t2, 1         # increment the buffer pointer
        add     $t3, $t3, 1         # increment the position within line
        
        bne     $t3, $t0, cont      # if end of line reached
        add     $t2, $t2, $t4       # move pointer to start of prev line
        li      $t3, 0              # reset position in line
        
        beqz    $t5, cont           # read and discard byte padding, if there is any
        and     $a2, $t0, 3         # calculate byte padding as the remainder of (width / 4)
        li      $v0, 14             
        syscall

cont:   add     $t1, $t1, -1        # decrement pixel counter
        bgtz    $t1, readpx         # reiterate until there are no more pixels to read
        
        li      $v0, 16             # close the file and return to caller
        syscall
        jr      $ra
        
dsper1: la      $a0, err1           # load error message to $a0 and print it
        j       perr
dsper2: la      $a0, err2
        j perr
dsper3: la      $a0, err3
        j perr
dsper4: la      $a0, err4

perr:   li      $v0, 16             # close file
        syscall
        li      $v0, 4              # print error
        syscall
        li      $v0, 17             # exit with code 1
        li      $a0, 1
        syscall
