# remove the specified range from string

        .data
buf:    .byte 0:255                 # prepare string buffer and its length
buflen: .word 255

        .text
        li      $v0, 8              # call read_string
        la      $a0, buf            # specify target buffer
        lbu     $a1, buflen         # specify buffer length
        syscall
        
        li      $v0, 5              # call read_int
        syscall
        move    $s0, $v0            # store first range endpoint
        li      $v0, 5              # call read_int again
        syscall
        move    $s1, $v0            # store second range endpoint
        
        bleu    $s0, $s1, start     # reorder endpoints if needed
        move    $t0, $s0
        move    $s0, $s1
        move    $s1, $t0
        
start:  li      $t0, 0              # string iterator
        li      $v0, 11             # prepare to call print_char

iterst: lbu     $a0, buf($t0)       # dereference operator
        beqz    $a0, stop           # stop if there are no more characters
        
        bltu    $t0, $s0, cont      # if outside of range, print
        bgtu    $t0, $s1, cont
        j       skip                # otherwise, skip
        
cont:   syscall                     # call print_char
skip:   addiu   $t0, $t0, 1         # increment string index
        j       iterst              # iterate loop
        
stop:   li      $v0, 10             # exit program
        syscall
