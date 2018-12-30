# With Loop process all elements of the array
# Author: Ga Jun Young 
 	
 	.data # data goes in data segment
D1: 	.word 1,2,4 # data stored in words
D2: 	.word 5,6,8
D3: 	.word 0,0,0
 	.text # code goes in text segment
 	.globl main # must be global symbol
main: 	la $t0, D1 # load address pseudo-instruction
 	la $t1, D2
 	la $t2, D3
 	
 	#D1	
 	addi $t6, $zero, 0
 	addi $t7, $zero, 3
 Loop: 	lw $t3, 0($t0)
 	add $t0, $t0, 4
 	addi $t6, $t6, +1
 	bne $t6, $t7, Loop
 	
 	#D2
 	addi $t6, $zero, 0
 	addi $t7, $zero, 3
 Loop2: lw $t4, 0($t1)
 	add $t1, $t1, 4
 	addi $t6, $t6, +1
 	bne $t6, $t7, Loop2
 	
 	#D3
 	addi $t6, $zero, 0
 	addi $t7, $zero, 3
 Loop3: lw $t5, 0($t2)
 	add $t2, $t2, 4
 	addi $t6, $t6, +1
 	bne $t6, $t7, Loop3
 	#
 #Exit: #ends the program
 	li $v0, 10 # system call for exit
 	syscall # Exit!
