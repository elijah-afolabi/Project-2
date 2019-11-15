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


         

    





      
   

    checkString:
    move $t5, $t6
    #beqz $t5, conversionInitializations  #End loop if null character is reached
    #beq $t5, $t1, conversionInitializations  #End loop if end-of-line character is detected
    slti $t6, $t5, 48    #Check if the character is less than 0 (Invalid input)
    bne $t6, $zero, baseError
    slti $t6, $t5, 58    #Check if the character is less than 58->9 (Valid input)
    bne $t6, $zero, convert
    slti $t6, $t5, 65    #Check if the character is less than 65->A (Invalid input)
    bne $t6, $zero, baseError
    slti $t6, $t5, 80    #Check if the character is less than 80->P(Valid input)
    bne $t6, $zero, convert
    slti $t6, $t5, 97    #Check if the character is less than 97->a(Invalid input)
    bne $t6, $zero, convert
    slti $t6, $t5, 113   #Check if the character is less than 112->p(Valid input)
    bne $t6, $zero, convert
    bgt $t5, 80, baseError #Check if the character is greater than 112->p(Invalid input)
        
        
        baseError:
    
    addi $t7, $t7, 0
    
    j loopstarts
    
    
      
        
        convert:
    move $s4, $t5
    
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
        j nextStep


        
        nextStep:
        add $t7, $t7, $s4
         j loopstarts
         

displaySum:
li $v0, 1
move $a0, $t7
syscall

exit:
       li $v0, 10
       syscall
    
      
