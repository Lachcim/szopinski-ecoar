# CHUNKFINDER.ASM
# Finds chunks of black pixels using a BFS algorithm.

        .data
nextin: .word   0                   # next start index for chunk search

        .text
        .globl  find_chunk
        
find_chunk:
        lw      $s0, nextin         # load next index to check
        add     $t0, $a1, $s0       # obtain pointer to buffer at index

pxloop: beq     $s0, 76800, fail    # stop search if end of buffer reached
        
        lb      $t1, 0($t0)         # dereference buffer pointer
        bne     $t1, 1, cont        # continue if pixel not black
        
        move    $s7, $ra            # call chunk exploring subroutine
        jal     explore_chunk
        move    $ra, $s7
        
        add     $s0, $s0, 1         # increment index for next call
        li      $v0, 1              # return 1 when a chunk was found
        j       stop                # stop loop

cont:   add     $s0, $s0, 1         # increment index and pointer
        add     $t0, $t0, 1
        j       pxloop              # reiterate
        
fail:   li      $v0, 0              # return 0 if there are no more chunks
stop:   sw      $s0, nextin         # save next index to check
        jr      $ra                 # return to caller

explore_chunk:
        move    $s6, $a0            # save arguments and return address
        move    $s5, $a1            # will be used for queue calls
        move    $s4, $ra
        
        div     $zero, $s0, 320     # calculate start x/y by dividing index by buffer width
        mfhi    $a0
        mflo    $a1        
        jal     queue_push          # add initial position to BFS queue
        
        li      $t0, 320            # chunk boundaries: xmin, xmax, ymin, ymax
        li      $t1, 0
        li      $t2, 240
        li      $t3, 0
        
exloop: jal     queue_pop           # pop next pixel from queue

        mul     $t4, $v1, 320       # calculate the pixel's index in buffer
        add     $t4, $t4, $v0
        add     $t4, $t4, $s5       # turn index into pointer
        lb      $t5, 0($t4)         # dereference pointer
        
        bne     $t5, 1, skip        # skip pixel if not black
        li      $t5, 2
        sb      $t5, 0($t4)         # mark pixel as explored (code 2)
        
        bge     $v0, $t0, noxmin    # update chunk boundaries, starting from x min
        move    $t0, $v0
noxmin: bge     $v1, $t2, noymin    # y min
        move    $t2, $v1
noymin: ble     $v0, $t1, noxmax    # x max
        move    $t1, $v0
noxmax: ble     $v1, $t3, noymax    # y max
        move    $t3, $v1
        
noymax: beqz    $v0, noleft         # add left neighbor to queue
        add     $a0, $v0, -1
        move    $a1, $v1
        jal     queue_push
noleft: beqz    $v1, noup           # add upper neighbor
        move    $a0, $v0
        add     $a1, $v1, -1
        jal     queue_push
noup:   beq     $v0, 319, norigh    # add right neighbor
        add     $a0, $v0, 1
        move    $a1, $v1
        jal     queue_push
norigh: beq     $v1, 239, skip      # add bottom neighbor
        move    $a0, $v0
        add     $a1, $v1, 1
        jal     queue_push
        
skip:   jal     queue_empty         # break if there are no more pixels to explore
        beqz    $v0, exloop
        
        sh      $t0, 0($s6)         # store chunk boundaries
        sh      $t1, 2($s6)
        sh      $t2, 4($s6)
        sh      $t3, 6($s6)
        
        move    $a0, $s6            # restore arguments and return to caller
        move    $a1, $s5
        move    $ra, $s4
        jr      $ra
