	.text
	.globl	main
main:
	# 1. print string code
	li	$v0, 4		# set $v0(syscall number) to 4 for printing a string
	la	$a0, msg		# set $a0 to the addresss of the string
	syscall

	# 2. print an integer
	li	$v0, 1		# set $v0(syscall number) to 1 for printing an integer
	li	$a0, 777		# set $a0 to a value to print (here, for example, 777)
	syscall


	# 3. exit 
	li	$v0, 10		# syscall exit to terminate the program
	syscall

	.data
msg:	.asciiz	"Hello World... "
	