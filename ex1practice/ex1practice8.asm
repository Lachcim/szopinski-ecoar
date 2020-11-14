# capitalize every third lowercase letter

        .data
buf:    .byte 0:255                 # prepare string buffer and its length
buflen: .word 255

        .text
        li      $v0, 8              # call read_string
        la      $a0, buf            # specify target buffer
        lbu     $a1, buflen         # specify buffer length
        syscall
        
        li      $t0, 0              # currently processed string index
        li      $t1, 2              # strikes - tolerated lowercase letters
        li      $v0, 11             # prepare to call print_char
        
iterst: lbu     $a0, buf($t0)       # dereference char pointer
        beqz    $a0, stop           # stop if end reached
        
        bltu    $a0, 97, cont       # print if not a lowercase letter
        bgtu    $a0, 122, cont
        
        bnez    $t1, strike         # print as is if there are strikes left
        xor     $a0, $a0, 32        # make char lowercase
        li      $t1, 2              # reset strikes
        j       cont

strike: addiu   $t1, $t1, -1        # decrement number of strikes
cont:   syscall                     # call print_char
        addiu   $t0, $t0, 1         # increment string index
        j       iterst              # reiterate
        
stop:   li      $v0, 10             # exit program
        syscall
