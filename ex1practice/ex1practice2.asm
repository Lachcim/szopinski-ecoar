# print longest substring of digits in a string

        .data
buf:    .byte 0:255                 # prepare string buffer and its length
buflen: .word 255

        .text
        li      $v0, 8              # call read_string
        la      $a0, buf            # specify target buffer
        lbu     $a1, buflen         # specify buffer length
        syscall
        
        li      $t0, 0              # currently processed string index
        
        li      $s0, 0              # best substring index
        li      $s1, 0              # best substring length
        li      $s2, 0              # curent substring index
        li      $s3, 0              # curent substring length
        
iterst: lbu     $t1, buf($t0)       # load current character into $t1
        beq     $t1, $zero, stop    # stop if there are no more characters
        
        bltu    $t1, 48, snip       # if not a digit, snip current substring
        bgtu    $t1, 57, snip
        
        movz    $s2, $t0, $s3       # set current substring index if the current length is zero
        addiu   $s3, $s3, 1         # increment current substring length
        j       cont                # iterate loop without snipping
        
snip:   bleu    $s3, $s1, reset     # compare current to best score
        move    $s0, $s2            # note new best index
        move    $s1, $s3            # note new best length
reset:  li      $s3, 0              # reset current substring length

cont:   addiu   $t0, $t0, 1         # increment string index
        j       iterst              # iterate loop
        
stop:   add     $s1, $s0, $s1       # calculate best substring end
        sb      $zero, buf($s1)     # insert terminator after substring 
        li      $v0, 4              # call print_string
        la      $a0, buf($s0)       # print buffer starting from substring index
        syscall
        li      $v0, 10             # exit program
        syscall
