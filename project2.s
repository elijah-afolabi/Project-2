#ID:02764894
#02764894 % 11 = 0
#26+0 = 26
#β is 'p' and Δ is 'P'.



.data


    .space 1001
Input:
    .asciiz "\Input String\n"
Output:
    .asciiz "\Output String: "
   
.text

main:

   
    li $v0, 8   #loads the value 8 into register $v0 which is the op code for print string 
   
    la $a0, Input #load address Input from memory and store it into argument register 0
    
    li $a1, 1001


    syscall #reads register $v0 for op code, sees 4 and prints the string located in $a0

      
     
     removeLeading:                   #Remove leading spaces
	li $t8, 32                       #Save space character to t8
	lb $t9, 0($a0)
	beq $t8, $t9, removeFirst
	move $t2, $a0
	j removeTrailing

         

      removeFirst:
	addi $a0, $a0, 1
	j removeLeading
	
	removeTrailing:
	li $t3, 10			      #Check for line feed character
	lb $t9, 0($a0)
	beqz $t9, obtainedLastValidCharacter 		  #End loop if null character is reached
    	beq $t9, $t3, obtainedLastValidCharacter         #End loop if end-of-line is detected
	bne $t9, $t8, saveIndex
	addi $a0, $a0, 1
	j removeTrailing
	


        obtainedLastValidCharacter:
	sb $zero, 1($t1)
	
	checkLength:   #Count the characters in the string
	move $a0, $t2
	addi $t0, $t0, 0  #Initialize count to zero
	addi $t1, $t1, 10  #Save line feed character to t1
	add $t4, $t4, $a0  #Preserve the content of a0


         

         lengthLoop:
	lb $t2, 0($a0)   #Load the next character to t2
	beqz $t2, done   #End loop if null character is reached
	beq $t2, $t1, done   #End loop if end-of-line is detected
	addi $a0, $a0, 1   #Increment the string pointer
	addi $t0, $t0, 1
	j lengthLoop



     finish:
     beqz $t0, nullError   #Branch to null error if length is 0
     slti $t3, $t0, 5      #Check that count is less than 5
     beqz $t3, lengthError #Branch to length error if length is 5 or more
     move $a0, $t4
     j checkString

     

    nullError:
	li $v0, 4
	la $a0, emptyError
	syscall
	j exit

      lengthError:
       li $v0, 4
       la $a0, tooLongError
        syscall
       j exit




      
   

    checkString:
	lb $t5, 0($a0)
	beqz $t5, conversionInitializations  #End loop if null character is reached
	beq $t5, $t1, conversionInitializations  #End loop if end-of-line character is detected
	slti $t6, $t5, 48    #Check if the character is less than 0 (Invalid input)
	bne $t6, $zero, baseError
	slti $t6, $t5, 58    #Check if the character is less than 58->9 (Valid input)
	bne $t6, $zero, Increment
	slti $t6, $t5, 65    #Check if the character is less than 65->A (Invalid input)
	bne $t6, $zero, baseError
	slti $t6, $t5, 81   #Check if the character is less than 80->Q(Valid input)
	bne $t6, $zero, Increment
	slti $t6, $t5, 97    #Check if the character is less than 97->a(Invalid input)
	bne $t6, $zero, baseError
	slti $t6, $t5, 113  #Check if the character is less than 113->q(Valid input)
	bne $t6, $zero, Increment
	bgt $t5, 112, baseError   #Check if the character is greater than 112->p(Invalid input)


        Increment:
	addi $a0, $a0, 1
	j checkString
        
        
        baseError:
    
        li $v0, 4
	la $a0, wrongBaseError
	syscall
	j exit
    
conversionInitializations:
	move $a0, $t4
	addi $t7, $t7, 0  #Initialize decimal sum to zero
	add $s0, $s0, $t0
	addi $s0, $s0, -1	
	li $s3, 3
	li $s2, 2
	li $s1, 1
	li $s5, 0
      
        
 convertString:
        lb $s4, 0($a0)
	beqz $s4, displaySum
	beq $s4, $t1, displaySum
	slti $t6, $s4, 58
	bne $t6, $zero, zeroToNine
	slti $t6, $s4, 81
	bne $t6, $zero, AToP
	slti $t6, $s4, 113
	bne $t6, $zero, aTop

zeroToNine:
    addi $s4, $s4, -48
    j nextStep
AToP:
    addi $s4, $s4, -55
    j nextStep
aTop:
    addi $s4, $s4, -87
       


        
nextStep:
        beq $s0, $s3, thirdPower
	beq $s0, $s2, secondPower
	beq $s0, $s1, firstPower
	beq $s0, $s5, zeroPower



thirdPower:
	li $s6, 17576
	mult $s4, $s6
	mflo $s7
	add $t7, $t7, $s7
	addi $s0, $s0, -1
	addi $a0, $a0, 1
	j convertString

secondPower:
	li $s6, 676
	mult $s4, $s6
	mflo $s7
	add $t7, $t7, $s7
	addi $s0, $s0, -1
	addi $a0, $a0, 1
	j convertString
         

displaySum:
       li $v0, 1
       move $a0, $t7
       syscall

exit:
       li $v0, 10
       syscall
    
      
