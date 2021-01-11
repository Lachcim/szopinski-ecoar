# scan the string for the bigest unsigned decimal number, print it

        .data
buf:    .byte 0:255                 # prepare string buffer and its length
buflen: .word 255

        .text
        li      $v0, 8              # call read_string
        la      $a0, buf            # specify target buffer
        lbu     $a1, buflen         # specify buffer length
        syscall
        
        li      $t0, 0              # currently processed string index
        li      $t1, 0              # currently read number
        li      $a0, 0              # biggest read number
        li      $t2, 10             # multiplication constant
        
iterst: lbu     $t3, buf($t0)       # dereference char pointer
        beqz    $t3, stop           # stop if end reached
        
        bltu    $t3, 48, snip       # snip if not a digit
        bgtu    $t3, 57, snip
        
        mul     $t1, $t1, $t2       # multiply current number by 10
        addiu   $t3, $t3, -48       # convert char to digit
        addu    $t1, $t1, $t3       # add new digit to current number
        
        j       cont                # reiterate
     
snip:   bleu    $t1, $a0, reset     # compare current number to biggest number
        move    $a0, $t1            # update biggest number
reset:  li      $t1, 0              # reset current number

cont:   addiu   $t0, $t0, 1         # increment string index
        j       iterst              # reiterate

stop:   li      $v0, 1              # print the biggest number
        syscall
        li      $v0, 10             # exit program
        syscall
