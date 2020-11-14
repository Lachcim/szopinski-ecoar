# remove characters preceded by digits

        .data
buf:    .byte 0:255                 # prepare string buffer and its length
buflen: .word 255

        .text
        li      $v0, 8              # call read_string
        la      $a0, buf            # specify target buffer
        lbu     $a1, buflen         # specify buffer length
        syscall
        
        li      $t0, 1              # currently processed string index
        lbu     $t1, buf            # preceding character
        li      $v0, 11             # prepare to call print_char
        
        move    $a0, $t1            # print first character
        syscall
        
iterst: lbu     $a0, buf($t0)       # dereference char pointer
        beqz    $a0, stop           # stop if end reached
        
        bltu    $t1, 48, print      # print if not preceded by a digit
        bgtu    $t1, 57, print
        j       cont                # otherwise skip

print:  syscall                     # call print_char
cont:   move    $t1, $a0            # update preceding character
        addiu   $t0, $t0, 1         # increment string index
        j       iterst              # reiterate
        
stop:   li      $v0, 10             # exit program
        syscall
