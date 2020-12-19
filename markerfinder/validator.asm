# VALIDATOR.ASM
# Checks whether found chunks are valid markers.

        .text
        .globl validate_chunk
        
validate_chunk:
        move    $s5, $ra            # remember return address
        
        lh      $s0, 0($a0)         # load chunk boundaries into registers
        lh      $s1, 2($a0)
        lh      $s2, 4($a0)
        lh      $s3, 6($a0)
        
        sub     $s4, $s1, $s0       # calculate chunk width and height (minus 1)
        sub     $t0, $s3, $s2
        bne     $s4, $t0, reject    # reject if chunk is not square
        
        mul     $t0, $s2, 320       # obtain pointer to upper right corner of chunk
        add     $t0, $t0, $s1
        add     $t0, $t0, $a1
        
        lb      $t1, 0($t0)         # reject if corner isn't black
        bne     $t1, 2, reject      # code 2: black and belonging to this chunk
        
        li      $t2, 0              # current radius
        li      $t3, 0              # white encountered
        
radlop: lb      $t1, 0($t0)         # probe pixel at intersection
        beq     $t1, 2, nowhit      # if pixel isn't black, raise the white encountered flag
        li      $t3, 1

nowhit: move    $t4, $t0            # pointer state at intersecton
        move    $t5, $t2            # arm offset
        
hor:    jal     check               # perform check for horizontal arm
        add     $t0, $t0, -1        # move pointer left
        add     $t5, $t5, 1         # increment arm offset
        bgt     $t5, $s4, restor    # repeat until end of chunk
        j       hor
        
restor: beq     $t2, $s4, radend    # no vertical arm at final radius, finish check
        add     $t0, $t4, 320       # move pointer to start of vertical arm
        add     $t5, $t2, 1         # set arm offset to current radius plus one
        
vert:   jal     check               # perform check for vertical arm
        add     $t0, $t0, 320       # move pointer down
        add     $t5, $t5, 1         # increment arm offset
        bgt     $t5, $s4, radcnt    # repeat until end of chunk
        j       vert
        
check:  lb      $t1, 0($t0)         # probe pixel
        beq     $t3, 1, black       # branch to black check if white encountered
        bne     $t1, 2, reject      # if white, reject
        jr      $ra                 # return to loop
black:  beq     $t1, 2, reject      # if black, reject
        jr      $ra                 # return to loop
        
radcnt: add     $t2, $t2, 1         # increment radius
        add     $t0, $t4, 319       # move pointer to next radius
        j       radlop              # reiterate
        
radend: beqz    $t3, reject         # if scan ended without encountering a white pixel, reject
        li      $v0, 1              # all tests passed, return 1
        j       mark_as_done
        
reject: li      $v0, 0              # return 0 on failure

mark_as_done:
        move    $t0, $s0            # mark chunk as validated, overwrite all 2s with 3s
        move    $t1, $s2            # scan from top left
        
        mul     $t2, $t1, 320       # obtain pointer to top left
        add     $t2, $t2, $t0
        add     $t2, $t2, $a1
        
ovwlop: lb      $t3, 0($t2)         # dereference pointer
        bne     $t3, 2, ovcont      # continue if not 2
        li      $t3, 3              # write 3 to pointer
        sb      $t3, 0($t2)
        
ovcont: beq     $t0, $s1, nxtlin    # move to next line if end reached
        add     $t2, $t2, 1         # increment pointer
        add     $t0, $t0, 1         # increment x
        j       ovwlop
        
nxtlin: beq     $t1, $s3, finish    # finish if end of chunk reached
        add     $t2, $t2, 320       # line feed
        sub     $t2, $t2, $s4       # carriage return
        add     $t1, $t1, 1         # increment y
        move    $t0, $s0            # reset x
        j       ovwlop
        
finish: jr      $s5                 # return to main
