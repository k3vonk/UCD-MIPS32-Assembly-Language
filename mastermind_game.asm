#		Write and verify a MIP32 assembly language program that will play Mastermind, a code breaking game.
#		To begin, the program should generate a random code containing 4 decimal digits. The code must not
#		include any repeated digits. The code generated should be printed to the Mars Run I/O pane. The program
#		should then randomly generate a series of guesses for the code. All guesses should be printed. Every guess
#		should be accompanied by an evaluation of the guess. The evaluation is a letter sequence: B (black)
#		indicates a correct digit in the correct position; W (white) indicates a correct digit in the wrong position; and _
#		(underscore) indicates an incorrect digit. The program should terminate when a guess is correct.
#		
#		An example run:
#		1234
#		1354 :: BW_W
#		9234 :: _BBB
#		1234 :: BBBB
#
#		The assembly code should be well structured into subroutines.

# Author: Ga Jun Young
			
			.data
number:			.ascii "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
			.space 4
rand_4:			.asciiz ""
			.space 4
eval:			.asciiz "____"	
			.space 4
seperate:		.asciiz " :: "
			.space 4
guess:			.asciiz ""
			.space 4
ans:			.asciiz "0"		
			.text
			
			.globl main
main:			# Generate 4 unique numbers
			la $a0, rand_4
			jal generate_4
			jal reset
			
			# Print to screen - rand_4
			la $a0, rand_4
			li $v0, 4
			syscall
			# Print to screen - /n
			la $a0, 10
			li $v0, 11
			syscall
			
			# Generate 4 unique numbers - GUESS
repeat:			la $a0, guess
			jal generate_4
			jal reset
			
			# Insert W, B, _ into the right positions
			jal check
			
			#Print to screen - Guess :: eval\n
			la $a0, guess
			li $v0, 4
			syscall
			la $a0, seperate
			li $v0, 4
			syscall
			la $a0, eval
			li $v0, 4
			syscall
			la $a0, 10
			li $v0, 11
			syscall
			
			# ans - holds the number of B in the string. If B total = 4, then stop the loop
			la $t0, ans
			lb $t1, 0($t0)
			bne $t1, 52, repeat
			
			li $v0, 10 		# system call for exit
 			syscall 		# Exit!	
 
 		
 				
#========================= GENERATE FOUR UNIQUE NUMBERS ============================#		
generate_4:		add $t0, $zero, $a0	# Address of the parameter input

			li $t2, 0		# Counter = 0	
			li $a1, 10		# a1 = 10 
			
four_times:		
do:			la $t1, number
			li $v0, 42		# rand(10)
			syscall
			
			add $t1, $t1, $a0	# Offset of number array
			lb $t3, 0($t1)		# Load the value from the array
			
			beq $t3, 0, do		# Do while loop, if t3 = null
			
			sb $t3, 0($t0)		# Store the number into rand_4
			sb $zero, 0($t1)	# Store null into that array index
		
			addi $t0, $t0, 1	# rand_4++
			addi $t2, $t2, 1	# Counter++
			bne $t2, 4, four_times
			jr $ra
		
#=========================== RESET ============================================#
reset:			la $t0, number		# resets the number array with 0-9 digits
			li $t1, 0

ten_times:		addi $t2, $t1, 48
			sb $t2, 0($t0)
			
			addi $t1, $t1, 1
			addi $t0, $t0, 1
			bne $t1, 10, ten_times
			jr $ra

#========================== CHECK ============================================#	
check:			la $t0, guess
			la $t1, rand_4
			la $t2, eval
			
			li $t3, 0			# t3 = 0
			
			li $t4, 87			# W
			li $t5, 66			# B
			li $t6, 95			# _
			
			li $t7, 48			# Counter
for_outer:		lb $s0, 0($t0)			# guess[i]
			lb $s1, 0($t1)			# rand_4[i]
			
			bne $s0, $s1, else_outer	# if(guess[i] == rand_4[i]) else_outer
			sb $t5, 0($t2)			# eval[i] = B
			addi $t7, $t7, 1		# Counter++
			j end_inner
			
else_outer:		li $s2, 0			# j = 0
			la $s3, rand_4			# starting address of rand_4 again for inner loop
			
for_inner:		lb $s4, 0($s3)			# rand_4[j]
			
			bne $s0, $s4, else_inner	# if (guess[i] == rand_4[j])	else eval[i] = _
			sb $t4, 0($t2)			# eval[i] = W
			j end_inner
			
else_inner:		sb $t6, 0($t2)			# eval[i] = _
			
			addi $s2, $s2, 1		# rand_4++ (j)
			addi $s3, $s3, 1
			bne $s2, 4, for_inner

end_inner:		addi $t0, $t0, 1		# guess++
			addi $t1, $t1, 1		# rand_4++ (i)
			addi $t2, $t2, 1		# eval++
			addi $t3, $t3, 1		# i++
					
			bne $t3, 4, for_outer
			
			# Counter stored into ans
			la $t0, ans
			sb $t7, 0($t0)
	
			jr $ra
			

			

			
