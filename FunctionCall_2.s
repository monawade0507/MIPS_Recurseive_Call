.data
	prompt:  .asciiz "Number to square: "
	prompt2: .asciiz "Number of squares to sum: "
	return:  .asciiz "Square: "
	return2: .asciiz "Sum of the first n sqaures"
	test:	    .asciiz "Testing location"
.text
.globl main

main: 
	# Print the string asking of "Number of squares to sum: "
	li $v0, 4
	la $a0, prompt2
	syscall

	# capture user input
	li $v0, 5
	syscall

	# store the value in a register
	move $s0, $v0
	move $a0, $s0

	# store the function 'square' is $ra
	jal sumSquare

	# Exit
	li $v0, 10
	syscall

sumSquare:
	# allocate space on the stack 
	addi $sp $sp, -8
	sw   $ra, 4($sp)
	sw   $a1, 0($sp)
	
	# store the passed in argument in a register
	move $t3, $a0			# store user's input

	# initialize temp registers to be used
	add $t4, $t4, $0		# $t4 is used to store the sum
	add $t5, $t5, $0		# $t5 = 0; used for counter

	Loop2: beq $t5, $t3, Exit2
		move $a1, $t3
		jal  square
		add  $t4, $t4, $v0
		addi $t5, $t5, 1
		j Loop2

	Exit2:
	# Print the string asking of "Number of squares to sum: "
	li $v0, 1
	move $a0, $t4
	syscall
	
	# transfer control back to the caller -> main
	jr $ra

square:
	# store the passed in argument in a register
	move $t0, $a1			# store user's input

	# initialize variables to use in the loop
	add $t1, $t1, $0		# $t1 is used to store the sum
	add $t2, $t2, $t0		# $t2 = $t0; used for counter

	Loop: beq $t2, $0, Exit
		add  $t1, $t1, $t0
		addi $t2, $t2, -1
		j Loop
	Exit:

	# print the value back out
	li $v0, 1
	move $a0, $t1
	syscall

	# restore 
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	

	# transfer control back to the caller  -> sumSquares
	jr $ra

	