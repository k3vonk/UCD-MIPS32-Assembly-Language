#To Encrypt and Decrypt a string
#Author: Ga Jun Young
			.data
Zero:			.asciiz "ZE"		
One:			.asciiz "ON"
Two:			.asciiz "TW"
Three:			.asciiz "TH"
Four:			.asciiz	"FO"
Five:			.asciiz "FI"
Six:			.asciiz "SI"
Seven:			.asciiz "SE"
Eight:			.asciiz "EI"
Nine:			.asciiz "NI"
			
Num:		.word Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine

			.space 32
Input:			.ascii "16440714."		#Full stop termination
			.space 32
Encry_Output:		.ascii ""
			.space 32
Decry_Output:		.ascii ""
			.space 32
Reverse:		.ascii ""
			
			
			.text
			.globl main
main:			la $a0, Input		# a0 = *Input
			la $a1, Encry_Output	# a1 = *Encry_Output
			jal encryption		# Encryption subroutine
			
			la $a0, Encry_Output	# a0 = *Encry_Output
			la $a1, Decry_Output	# a1 = *Decry_Output
			jal decryption
			
			
			li $v0, 10 		# system call for exit
 			syscall 		# Exit!	
 			
#======================= SUBROUTINE ENCRYPTION ===========================================		
encryption: 		#SETUP
			addi $t0, $a0, 0	# t0 = Input
			addi $t1, $a1, 0	# t1 = Output
			la $t2, Num		# t2 = *Num
			
			addi $sp, $sp, 0	# stack
			li $t3, 0		# t3 = Counter
			
			#ENCRPYPTION WITHOUT REVERSE INTO SP
while_encry:		lb $t4, 0($t0)		# Input[0]
			beq $t4, 46, reverse_encry	#Input[i] == '.' ?
			addi $t4, $t4, -48	# ASCII - 48 to get the range between 0 and 9
			
			#If(a[i] < 0 || a[i] > 9) loop
			blt  $t4, 0, Increment		
			bgt  $t4, 9, Increment	

			#Obtain Num[i] & load its content
			mul $t4, $t4, 4		
			add $t2, $t2, $t4	
			lw $t5, 0($t2)		
			
			#Add encrypted characters to the sp 
			lb $a0, 0($t5)
			sb $a0, 0($sp)		
			lb $a0, 1($t5)
			sb $a0, 1($sp)	
			
			addi $sp, $sp, -2	# SP - 2
			addi $t3, $t3, 2	# Counter + 2 [Added 2 characters to sp]
			sub $t2, $t2, $t4	# Reset array 	
			
Increment:		addi $t0, $t0, 1	# Next character in Input
			j while_encry
			
reverse_encry:		addi $sp, $sp, 2	# sp position with the first character

while_reverse:		beq $t3, 0, append_fs	# t3 == 0 exit subroutine
			
			# Store Encryption to Encry_Output in Reverse
			lb $a0, 0($sp)	
			sb $a0, 0($t1)
			
			addi $t1, $t1, 1	#Encry_Output++
			addi $t3, $t3, -1	#Counter--
			addi $sp, $sp, 1	#sp++
			j while_reverse
			
append_fs:		li $a0, 46		# '.'
			sb $a0, 0($t1)		# Append '.' to the end of the string
			
			#Display
#			la $a0, Encry_Output
#			li $v0, 4
#			syscall
			jr $ra
			
#======================= SUBROUTINE DECRYPTION ===========================================	
decryption: 		#SETUP
			addi $t0, $a0, 0 	# t0 = Encry_Output
			addi $t1, $a1, 0	# t1 = Decry_Output
			la $t2, Num		# t2 = *Num
			
			addi $sp, $sp, 0	# sp
			li $t4, 0		# Counter
			
			#Find captials from the input
only_capitals:		lb $a0, 0($t0)		# Load each character 

			# If(a[i] < 65 || a[i] > 90) Increment else store the character
			blt  $a0, 65, Increment_		
			bgt  $a0, 90, Increment_
			
			sb $a0, 0($sp)
			
			addi $sp, $sp, -1	# sp--
			addi $t4, $t4, 1	# Counter++

Increment_:		addi $t0, $t0, 1	# Input++
			bne $a0, 46, only_capitals	#Check the string until '.' terminated
			
			addi $sp, $sp, 1 	#sp first character position
			la $t3, Reverse		#Stores reverse string
			
			#Reverse sp with the capitals
reverse_:		beq $t4, 1, reverse_dif
			lb $a0, 0($sp)			#Include Odd strings - fix
			sb $a0, 1($t3)
			j calc
reverse_dif:		lb $a0, 0($sp)
			sb $a0, 0($t3)
			
calc:			addi $t4, $t4, -1
			beq $t4, 0, reverse_end		#counter == 0 finish reversing
			
			lb $a0, 1($sp)
			sb $a0, 0($t3)
			
			addi $t4, $t4, -1
			addi $t3, $t3, 2
			addi $sp, $sp, 2	# Walk through sp

			bne $t4, 0, reverse_	# Reverse until counter == 0
			
			j other
			#Append '.'
reverse_end:		addi $t3, $t3, 1
other:			li $a0, 46	
			sb $a0, 0($t3)	
				
			#Display the reverse String
#			la $a0, Reverse 
#			li $v0, 4
#			syscall	


			#===== Decrypt Into Numeric Values======
			la $t3, Reverse 	# Point back to the start of Reverse address
			
into_num:		# Load its first two characters
			lb $a0, 0($t3)
			lb $a1, 1($t3)
			
			beq  $a0, 46, append_fs_d		
			beq  $a1, 46, append_fs_d	# If(Reverse[i] == '.' || Reverse[i+1] == '.') finish
			li $t4, 9			# Index for array
			li $t5, 57
			
			#Obtain Num[i] & load its content
loop_through_num:	mul $t7, $t4, 4		
			add $t2, $t2, $t7	
			lw $t6, 0($t2)	

			#Load Num[i] characters
			lb $a2, 0($t6)
			lb $a3, 1($t6)
			
			bne $a0, $a2, next_num_i	#if (array[index] != Two characters)
			bne $a1, $a3, next_num_i
			
			#Store ASCII into OUTPUT
			sb $t5, 0($t1)
			
			addi $t1, $t1, 1	#Decry_Output++
			addi $t3, $t3, 2	#Reverse += 2
			sub $t2, $t2, $t7	# Reset array 
			j into_num
			
next_num_i:		sub $t2, $t2, $t7	# Reset array 
			addi $t4, $t4, -1
			addi $t5, $t5, -1	# Reduce ascii
			bne $t4, -1, loop_through_num
			
			#If comparison doesn't exist, move to next pair of characters in reverse
			addi $t3, $t3, 1
			j into_num
			
append_fs_d:		li $a0, 46		# '.'
			sb $a0, 0($t1)		# Append '.' to the end of the string
			
			#Display
#			la $a0, Decry_Output
#			li $v0, 4
#			syscall
			jr $ra
