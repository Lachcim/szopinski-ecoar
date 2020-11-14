# replace all digits in a string with their complement to 9

        .data
buf:    .byte 0:255                 # prepare string buffer and its length
buflen: .word 255

        .text
        li      $v0, 8              # call read_string
        la      $a0, buf            # specify target buffer
        lbu     $a1, buflen         # specify buffer length
        syscall
        
        li      $t0, 0              # store currently processed string index in $t0
        li      $v0, 11             # prepare to call print_char
        
iterst: lbu     $a0, buf($t0)       # load current character into $a0 for future printing

        beqz    $a0, stop    # stop if there are no more characters
        bltu    $a0, 48, cont       # continue if not a digit
        bgtu    $a0, 57, cont

        not     $a0, $a0            # calculate (-digit + 1)
        addiu   $a0, $a0, 106       # calculate (105 - digit)
        
cont:   syscall                     # call print_char
        addiu   $t0, $t0, 1         # increment string index
        j       iterst              # iterate loop
        
stop:   li      $v0, 10             # exit program
        syscall
