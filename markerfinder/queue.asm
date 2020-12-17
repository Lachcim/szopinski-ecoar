# QUEUE.ASM
# A fixed-size FIFO data structure.

        .data
queue:  .word   0:479               # underlying memory block
qstart: .half   0                   # first element of the queue
qend:   .half   0                   # next available element of the queue

        .text
        .globl queue_push
        .globl queue_pop
        .globl queue_empty
        
queue_push:
        lh      $t9, qend           # load queue end position
        sw      $a0, queue($t9)     # store value at end pointer
        
        la      $t8, qend           # specify quend as store destination
        j       increm              # jump to incrementing subroutine
        
queue_pop:
        lh      $t9, qstart         # load queue start position
        lw      $v0, queue($t9)     # load value from start pointer to return register
        
        la      $t8, qstart         # specify qstart as store destination and proceed to incrementing subroutine
        
increm: beq     $t9, 1916, rollov   # roll over if end of array reached

        add     $t9, $t9, 4         # increment index
        sh      $t9, 0($t8)         # store index at destination
        jr      $ra                 # return to caller

rollov: sh      $zero, 0($t8)       # reset index and store it at destination
        jr      $ra                 # return to caller

queue_empty:
        lh      $t9, qstart         # load queue start position
        lh      $t8, qend           # load queue end position
        
        beq     $t9, $t8, empty     # if empty, return 1, otherwise return 0
        li      $v0, 0
        jr      $ra
        
empty:  li      $v0, 1
        jr      $ra
