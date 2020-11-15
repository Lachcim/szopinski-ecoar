# remove all but the first letter from each sequence of capitals

        .data
buf:    .byte 0:255                 # prepare string buffer and its length
buflen: .word 255

        .text
        li      $v0, 8              # call read_string
        la      $a0, buf            # specify target buffer
        lbu     $a1, buflen         # specify buffer length
        syscall
        
        li      $t0, 0              # currently processed string index
        li      $t1, 1              # tolerance - allowed capital letter
        li      $v0, 11             # prepare to call print_char
        
iterst: lbu     $a0, buf($t0)       # dereference char pointer
        beqz    $a0, stop           # stop if end reached
        
        bltu    $a0, 65, reset      # print if not a capital
        bgtu    $a0, 90, reset
        
        beqz    $t1, skip           # if there is no tolerance left, skip letter
        li      $t1, 0              # set tolerance to zero
        j       allow               # allow this capital

reset:  li      $t1, 1              # reset tolerance
allow:  syscall                     # print character
skip:   addiu   $t0, $t0, 1         # increment string index
        j       iterst              # reiterate
        
stop:   li      $v0, 10             # exit program
        syscall
