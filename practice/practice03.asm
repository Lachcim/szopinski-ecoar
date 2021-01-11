# reverse the order of digits in a string

        .data
buf:    .byte 0:255                 # prepare string buffer and its length
buflen: .word 255

        .text
        li      $v0, 8              # call read_string
        la      $a0, buf            # specify target buffer
        lbu     $a1, buflen         # specify buffer length
        syscall
        
        li      $t0, -1             # forward string iterator, start before first char
        lbu     $t1, buflen         # reverse string iterator, start at terminator
        jal     incfor              # make iterators point to first digits
        jal     increv
        
iterst: bge     $t0, $t1, stop      # iterate until the iterators pass each other

        sb      $t3 buf($t0)        # swap digits, $t2 and $t3 are dereferenced iterators
        sb      $t2 buf($t1)
        
        jal     incfor              # increment iterators and reiterate
        jal     increv
        j       iterst

stop:   li      $v0, 4              # print the rearranged string
        syscall
        li      $v0, 10             # exit program
        syscall
        
# increment the forward iterator
incfor: addiu   $t0, $t0, 1         # increment the iterator    
        beq     $t0, 255, retfor    # return if end reached
        lbu     $t2, buf($t0)       # dereference
        bltu    $t2, 48, incfor     # increment again if not a digit
        bgtu    $t2, 57, incfor
retfor: jr      $ra                 # return to caller
        
# increment the reverse iterator
increv: addiu   $t1, $t1, -1        # same as before
        beq     $t1, -1, retrev
        lbu     $t3, buf($t1)
        bltu    $t3, 48, increv
        bgtu    $t3, 57, increv
retrev: jr      $ra
