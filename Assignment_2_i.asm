# Program: Max & Min in Float & Integer Arrays (Assignment 2)
# Name: Brianna Drew
# Username: briannadrew
# ID: 0622446
# Date Created: 02/12/19
# Last Modified: 02/24/19

.data
     intArray: .word 3, 53, -76, 34, 643, -234, 143, 2, -33, 64 # array of 10 integers
     floatArray: .float 43.53, 45.2244, 25, 64.035, 328, 23.85, 23.86544, 93.4, 46.6543256, 0.00345 # array of 10 floats
     
     # text to be displayed for presentation purposes
     intMinOut: .asciiz "The smallest number in the integer array is: "
     intMaxOut: .asciiz "\nThe largest number in the integer array is: "
     intRangeOut: .asciiz "\nThe range of the integer array is: "
     floatMinOut: .asciiz "\n\nThe smallest number in the float array is: "
     floatMaxOut: .asciiz "\nThe largest number in the float array is: "
     floatRangeOut: .asciiz "\nThe range of the float array is: "
.text

main:
     la $t0, intArray # load address of intArray into $t0
     addi $t1, $zero, 0 # set $t1 to 0 (0 for 0th element of array and for our loop counter)
     lw $t3, intArray($zero) # load the 0th element of the integer array into $t3
     
     intRange:
     	jal findSmallest # call findSmallest procedure

	la $t4, ($t3) # load smallest integer in the array into $t4 to calculate range later
     	la $a0, intMinOut # print message introducing the smallest integer in the integer array
     	li $v0, 4
     	syscall
     	move $a0, $t3 # move smallest integer in the array to printable register
     	li $v0, 1 # print the smallest integer in the array
     	syscall
     
     	addi $t1, $zero, 0 # reset counter to 0
     	jal findLargest # call findLargest procedure
     
  	la $t5, ($t3) # load largest integer in the array into $t5 to calculate range later
     	la $a0, intMaxOut # print message introducing the largest integer in the integer array
     	li $v0, 4
     	syscall
     	move $a0, $t3 # move the largest integer in the array to printable register
     	li $v0, 1 # print the largest integer in the array
     	syscall
     	
     	la $a0, intRangeOut # print message introducing the range of the integer array
     	li $v0, 4
     	syscall
     	sub $t4, $t5, $t4 # calculate the range between the smallest integer and the largest integer in the array
     	move $a0, $t4 # move the range of the integer array to printable register
     	li $v0, 1 # print the range of the integer array
     	syscall
     	j floatRange # jump to floatRange procedure
     	     	
     floatRange:
	la $t0, floatArray # load address of floatArray into $t0
	addi $t1, $zero, 0 # reset counter to 0
	l.s $f0, floatArray($zero) # load the 0th element of the float array into $f0
	
	jal findFSmallest # call findFSmallest procedure
	
     	la $a0, floatMinOut # print message introducing the smallest float in the float array
     	li $v0, 4
     	syscall
     	mov.s $f12, $f0 # move the smallest float in the array into printable register
     	li $v0, 2 # print the smallest float in the array
     	syscall
     	mov.s $f4, $f12 # move the smallest float in the array into $f5 to calculate range later
     	
     	addi $t1, $zero, 0 # reset counter to 0
     	jal findFLargest # call findFLargest procedure
     	
     	la $a0, floatMaxOut # print message introducing the largest float in the float array
     	li $v0, 4
     	syscall
     	mov.s $f12, $f0 # move the  largest float in the array into printable register
     	li $v0, 2 # print the largest float in the array
     	syscall
     	mov.s $f6, $f12 # move the largest float in the array into $f6 to calculate range later
     	
     	la $a0, floatRangeOut # print message introducing the range of the float range
     	li $v0, 4
     	syscall
     	sub.s $f4, $f6, $f4 # calculate between the smallest float and the largest float in the array
     	mov.s $f12, $f4 # move the range of the float array into printable register
     	li $v0, 2 # print the range of the float array
     	syscall

     	b end # branch to end macro to end program

findSmallest:
         beq $t1, 40, doneSmallest # when the counter reaches 40, jump to doneSmallest as we have went through all integers in the array (4 bits x 10 integers = 40)
         lw $t2, intArray($t1) # load the current integer in the array into $t2 (based on our counter $t1)
         blt $t2, $t3, setSmallest # branch to setSmallest if the current integer in the array is less than the current smallest integer in the array
         addi $t1, $t1, 4 # increase $t1 by 4 (bits)
         j findSmallest # jump back to restart findSmallest (recursively)
         
setSmallest:
         move $t3, $t2 # set current integer in the array as the smallest
         j findSmallest # jump back to restart findSmallest
         
doneSmallest:
         jr $ra  # jump back to where we left off in intRange in main
         
findLargest:
	beq $t1, 40, doneLargest # when the counter reaches 40, jump to doneLargest as we have went through all integers in the array (4 bits x 10 integers = 40)
	lw $t2, intArray($t1) # load the current integer in the array into $t2 (based on our counter $t1)
	bgt $t2, $t3, setLargest # branch to setLargest if the current integer in the array is greater than the current largest integer in the array
	addi $t1, $t1, 4 # increase $t1 by 4 (bits)
	j findLargest # jump back to restart findLargest (recursively)
	
setLargest:
	move $t3, $t2 # set current integer in the array as the largest
	j findLargest # jump back to restart findLargest
	
doneLargest:
	jr $ra # jump back to where we left off in intRange in main
	
findFSmallest:
	beq $t1, 40, doneFSmallest # when the counter reaches 40, jump to doneFSmallest as we have went through all floats in the array (4 bits x 10 floats = 40)
	l.s $f2, floatArray($t1) # load the current float in the array into $f2 (based on our counter $t1)
	c.lt.s $f2, $f0 # if the current float in the array is less than the current largest float in the array, the statement is true
	bc1t setFSmallest  # branch to setFSmallest if the above statement is true
	addi $t1, $t1, 4 # increase $t1 by 4 (bits)
	j findFSmallest # jump back to restart findFSmallest (recursively)
	
setFSmallest:
	mov.s $f0, $f2 # set current float in the array as the smallest
	j findFSmallest # jump back to restart findFSmallest
	
doneFSmallest:
	jr $ra # jump back to where we left off in floatRange in main

findFLargest:
	beq $t1, 40, doneFLargest # when the counter reaches 40, jump to doneFLargest as we have went through all floats in the array (4 bits x 10 floats = 40)
	l.s $f2, floatArray($t1) # load the current float in the array into $f2 (based on our counter $t1)
	c.le.s $f2, $f0 # if the current float in the array is less than or equal to the current largest float in the array, the statement is true
	bc1f setFLargest # branch to setFLargest if the above statement is false (if the current float in the array is greater than the current largest float in the array)
	addi $t1, $t1, 4 # increase $t1 (counter) by 4 (bits)
	j findFLargest # jump back to restart findFLargest (recursively)

setFLargest:
	mov.s $f0, $f2 # set current float in the array as the largest
	j findFLargest # jump back to restart findFLargest

doneFLargest:
	jr $ra # jump back to where we left off in floatRange in main
	
end: #end macro to end program when finished
     .macro done
     li $v0, 10
     syscall
     .end_macro
     done
