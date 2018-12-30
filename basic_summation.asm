# Summation of i + x[i] up to N - 1
# Author: Ga Jun Young

            .data
DataIn:     .word       1,6,4,4,0,7,1,4
Len:        .word       8
CheckSum:   .word       55
            .text       
            .globl      main
main:       la          $t0, DataIn         # t0 = *DataIn
            la          $t1, Len            # t1 = *Len
            lw          $t2, 0($t1)         # t2 = Len (counter)
            li          $t3, 0              # t3 = 0  (total)
            li 		$t8, 0		    # i = 0
            
 Loop:      lw          $t4, 0($t0)         # t4 = DataIn
            add         $t3, $t3, $t4       # y = y + DataIN  
            add      	$t3, $t3, $t8	    # y = y + i
            addi        $t0, $t0, 4         # *DataIn = *DataIn + 4
            addi        $t8, $t8, +1        # counter - counter -1
            bne         $t8, $t2, Loop      # if counter != 8 then goto Loop
 
            li          $v0, 10             # system call for exit
            syscall                         # Exit!     
                    
