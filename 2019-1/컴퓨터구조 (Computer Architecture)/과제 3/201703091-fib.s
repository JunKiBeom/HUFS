.text
.globl main

main:
    addi	$sp, $sp, -8
    sw      $ra, 0($sp)

    la		$t5, n
    lw		$s2, 0($t5)     # n
    sw      $s2, 4($sp)     # save n because n will be 0 in fib (static/global value)
    lw      $a1, 4($t5)     # res
    jal     fib

    move    $a1, $v0        # return value
    lw      $s2, 4($sp)     # load n

    li	    $v0, 4		# set $v0(syscall number) to 4 for printing a string
	la	    $a0, msg1		# set $a0 to the addresss of the string
	syscall

	li	    $v0, 1		# set $v0(syscall number) to 1 for printing an integer
	move    $a0, $s2        # set $a0 to the addresss of n($s2)
    syscall

    li	    $v0, 4		# set $v0(syscall number) to 4 for printing a string
	la	    $a0, msg2		# set $a0 to the addresss of the string
	syscall

    li	    $v0, 1		# set $v0(syscall number) to 1 for printing an integer
    move    $a0, $a1        # set $a0 to the addresss of res($a1)
    syscall

    lw      $ra, 0($sp)     # return $ra
    addi    $sp, $sp, 8     # $sp
    jr      $ra             # jump $ra

    li      $v0, 10     # program exit
    syscall

fib:
    addi    $sp, $sp, -40
    sw      $s0, 0($sp)     # save $s0
    sw      $s1, 4($sp)     # save $s1
    sw      $ra, 8($sp)     # save $ra

    slti    $t0, $s2, 2     # if $s2 is less than 2 >> $t0=1, not less than 2 >> $t0=0
    beq     $t0, $zero, ELSE    # if $t0 == $zero (0), goto ELSE
    add     $v0, $zero, $s2      # if not goto ELSE, $v0 = $zero (0) + $s2
    j EXIT                      # goto EXIT

    ELSE: 
        addi $s0, $s2, 0
        addi $s2, $s2, -2
        jal fib

        addi $s1, $v0, 0
        addi $s2, $s0, -1
        jal fib

        add  $v0, $s1, $v0

    EXIT:                      # EXIT restore the values
    lw      $s0, 0($sp)
    lw      $s1, 4($sp)
    lw      $ra, 8($sp)
    addi    $sp, $sp, 40

    jr      $ra                # $ra

.data
n:      .word 5
res:    .word 0
msg1:	.asciiz	"Fibonacci value of "
msg2:   .asciiz " = "
