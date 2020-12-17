# VALIDATOR.ASM
# Checks whether found chunks are valid markers.

        .text
        .globl validate_chunk
        
validate_chunk:
        lh      $t0, 0($a0)         # load chunk boundaries into registers
        lh      $t1, 2($a0)
        lh      $t2, 4($a0)
        lh      $t3, 6($a0)
        
        sub     $t0, $t1, $t0       # calculate chunk width and height
        sub     $t1, $t3, $t2
        bne     $t0, $t1, reject    # reject if chunk is not square
        
        li      $v0, 1              # all tests passed, return 1
        jr      $ra
        
reject: li      $v0, 0              # return 0 on validation failure
        jr      $ra
