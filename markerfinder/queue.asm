# QUEUE.ASM
# A fixed-size FIFO data structure.

        .data
queue:  .word   0:479               # underlying memory block
qstart: .half   0                   # first element of the queue
qend:   .half   0                   # next available element of the queue

        .text
        .globl queue_push
        .globl queue_pop
        
queue_push:
        lh      $t9, qend           # load queue end position
        
        sw      $a0, queue($t9)     # store value at end pointer
        
        beq     $t9, 1916, rollov   # roll over if end of array reached
        
        add,    $t9, $t9, 4         # increment end position
        sh      $t9, qend           # save end position
        jr      $ra                 # return

rollov: sh      $zero, qend         # set end position to zero
        jr      $ra                 # return
        
queue_pop:
        jr      $ra
