# Using built in Bitmap Display Tool to create pattern based on 8-bit number. Starting from 0 up-to 255.
# Author: Ga Jun Young

		.data
white:		.word 0x00FFFFFF
black:		.word 0x00000000

		.text
		.globl main

main:			li	$t0, 255			# First Binary Pattern
			li	$t1, 2				# Division value
			li	$t2, 0				# Counter = 0
			lw 	$s0, white			# Color white
			lw	$s1, black			# Color black
		
			addi	$sp, $sp, -36			# Move sp down	
			addi	$t4, $t0, 0			# $t4 = 255		
convert_bin:		div	$t4, $t1			# Decimal/2 hi = binary, lo = result
			mfhi	$t3				# Binary
			mflo	$t4				# Remainder 
			sw	$t3, ($sp)			# Store Binary to stack
		
			addi	$sp, $sp, 4			# Increase stack address
			addi	$t2, $t2, 1			# Counter++
			bne	$t4, $zero, convert_bin

append_0:		beq	$t2, 8, reverse			# Check if there are 8 bits 
			sw 	$zero, ($sp)			# Append 0 bits if the digit didn't return 8 bits
			
			addi	$sp, $sp, 4			
			addi	$t2, $t2, 1
			j 	append_0

reverse: 		addi    $sp, $sp, -4			# Decrease my stack pointer
white_color:		beq 	$t2, $zero, Repeat
			lw	$t3, ($sp)			# Load the reverse 8 bit
			beq	$t3, 1, black_color		# If it is 1 = black	
   			sw 	$s0, white($t5)			# Store white into the address $s2
   			
   			addi	$t5, $t5, 4			# Increase my storage address
			addi    $sp, $sp, -4			# Decrease my stack pointer
			addi 	$t2, $t2, -1			# Counter--
			j white_color				# Continue to reverse
			
black_color:		sw 	$s1, black($t5)			# Store black into the address $s2

			addi	$t5, $t5, 4
			addi    $sp, $sp, -4
			addi 	$t2, $t2, -1
			j white_color
			
			
Repeat:			addi 	$t0, $t0, -1			# Decimal--
			beq 	$t0, -1, End			# if not in the range 255-0
			addi	$sp, $sp, -36			# Move sp down
			addi	$t4, $t0, 0			# $t4 = Decimal
			j convert_bin

End:			li	$v0, 10
			syscall	
			
