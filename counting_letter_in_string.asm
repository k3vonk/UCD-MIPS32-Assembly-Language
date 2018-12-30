# MIPS32 assembly language program that counts the number of occurence of a letter in a string
# Author: Ga Jun Young

		.data
DataIn: 	.asciiz	"Write and verify a MIPS32 assembly language program that counts the number of occurrences of letters in a string./n"
		.align 	3
Array:		.word	0:26
		.text
		.globl main
main:		la	$t0, DataIn		# address = &DataIn
		li	$t1, 10			# term = /n (ASCII)	
		li 	$s1, 26			# $s1 = 26, sentinal value       
		la 	$s2, Array 		# $s2 starts at base address of the array and is the address of each element
		
		#Initialization
		li 	$s0, 0			# i = 0	
For:		bge 	$s0, $s1, End_for	# if i >= 26 end forloop
		sw  	$zero, ($s2)		# Assigning values to array
		addi 	$s2, $s2, 4		# Next address of the array
		addi 	$s0, $s0, 1		# i++
		j For

		#Reset to base address
End_for:	mul 	$s0, $s1, -4		# Offset
		add 	$s2, $s2, $s0		# Original Address
		
		#Loop through ASCII of the string	
Loop:		lb 	$t3, 0($t0)
		lb      $s0, 1($t0) 
		bne 	$t3, 47, Do_body	
		beq	$s0, 110, End_loop	#if '/n' end loop
		
Do_body:	#Check if ASCII is a capital letter
		blt	$t3, 65, Increment		
		bgt	$t3, 122, Increment	# If(letter < 65 || letter > 122) loop
		
		ble	$t3, 90, A_Z		# Check if it is a capital
		
		subi	$t3, $t3, 32		# Capitalize the letter    
		bge	$t3, 65, A_Z		# Check if it is a letter
		j Increment	
		
A_Z:		subi	$t3, $t3, 65		# a = letter - 65
		mul	$s4, $t3, 4		# a * 4 = offset
		add	$s2, $s2, $s4		# *a[0] + offset = actual address needed to increment
		lw	$t4, 0($s2)		# address a[i]
		addi	$t4, $t4, 1		# a[i]++
		sw	$t4, 0($s2)		#Store the incremented value into the array
		
		#reset
		mul	$s4, $s4, -1		# reset offset
		add	$s2, $s2, $s4		# base address
					
Increment:	addi	$t0, $t0, 1		#address++
		j Loop
		
End_loop:	li 	$s0, 65
Print_Loop:	add 	$a0, $s0, $zero
		jal	PrintString		#print letter
		
		li 	$a0, 32
		jal	PrintString		#Print space
		
		lw	$a0, ($s2)
		jal	PrintInteger

		li	$a0, 10
		jal	PrintString		#Print new line
		
		addi	$s0, $s0, 1
		addi 	$s2, $s2, 4		# Next address of the array
		bne	$s0, 91, Print_Loop	#Printing from A - Z
		li	$v0, 10
		syscall
		
			
PrintString:	li	$v0, 11
		syscall				#syscall 11 is print 
		jr 	$ra
		
PrintInteger:	li	$v0, 1			#Syscall to print integer
		syscall
		jr 	$ra
		

