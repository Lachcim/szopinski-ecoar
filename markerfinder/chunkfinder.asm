# CHUNKFINDER.ASM
# Finds chunks of black pixels using a BFS algorithm.

        .data
nextin: .word   0                   # next start index for chunk search

        .text
        .globl  find_chunk
        
find_chunk:
        lw      $s0, nextin         # load next index to check
        add     $t0, $a1, $s0       # obtain pointer to buffer at index

pxloop: beq     $s0, 76799, fail    # stop search if end of buffer reached
        
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
        
        # todo
        
        move    $a0, $s6            # restore arguments and return to caller
        move    $a1, $s5
        move    $ra, $s4
        jr      $ra
