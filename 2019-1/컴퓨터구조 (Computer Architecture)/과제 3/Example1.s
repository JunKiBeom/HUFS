.text
.globl main
main:
    la $t2, fvar
    lw $s0, 0($t2) #f
    lw $s1, 4($t2) #g
    lw $s2, 8($t2) #h
    lw $s3, 12($t2) #i
    lw $s4, 16($t2) #j

    add $t0, $s1, $s2  #t0=g+h
    add $t1, $s3, $s4  #t1=i+j
    sub $s0, $t0, $t1  #f=t0-t1

    sw $s0, 0($t2)

     move $a0, $s0
    li $v0, 1 # syscall 1
    syscall   # print

.data
fvar: .word   0
gvar: .word   10
hvar: .word   -5
ivar: .word   6
jvar: .word   3