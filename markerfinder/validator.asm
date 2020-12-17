# VALIDATOR.ASM
# Checks whether found chunks are valid markers.

        .text
        .globl validate_chunk
        
validate_chunk:
        lh      $s0, 0($a0)         # load chunk boundaries into registers
        lh      $s1, 2($a0)
        lh      $s2, 4($a0)
        lh      $s3, 6($a0)
        
        sub     $s4, $s1, $s0       # calculate chunk width and height (minus 1)
        sub     $t0, $s3, $s2
        bne     $s4, $t0, reject    # reject if chunk is not square
        
        mul     $t0, $s3, 320       # obtain pointer to lower left corner of chunk
        add     $t0, $t0, $s0
        add     $t0, $t0, $a1
        
        lb      $t1, 0($t0)         # reject if corner is black
        beq     $t1, 2, reject      # code 2: black and belonging to this chunk
        
        j       accept
        
accept: li      $v0, 1              # return 1 on validation success
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
        
finish: jr      $ra
