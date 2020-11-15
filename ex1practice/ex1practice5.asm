# print the number of encountered sequences of digits

        .data
buf:    .byte 0:255                 # prepare string buffer and its length
buflen: .word 255

        .text
        li      $v0, 8              # call read_string
        la      $a0, buf            # specify target buffer
        lbu     $a1, buflen         # specify buffer length
        syscall
        
        li      $t0, 0              # currently processed string index
        li      $t1, 0              # whether a sequence has started
        li      $v0, 1              # prepare to print answer
        li      $a0, 0              # number of found sequences
        
iterst: lbu     $t2, buf($t0)       # load current character into $t1
        beqz    $t2, stop           # stop if there are no more characters
        
        bltu    $t2, 48, snip       # if not a digit, end sequence
        bgtu    $t2, 57, snip

        bnez    $t1, cont           # if the sequence has already started, continue
        li      $t1, 1              # mark sequence as started
        addiu   $a0, $a0, 1         # increment number of found sequences
        j       cont

snip:   li      $t1, 0              # mark sequence as ended
cont:   addiu   $t0, $t0, 1         # increment string index
        j       iterst              # iterate loop
        
stop:   syscall
        li      $v0, 10             # exit program
        syscall
