#Hoang Tran (2021495360)
#This program is implemented a bottom-up approach method to sort an array.
#It will sort neighbort and put them into two sublists
#then it will move the counter back to the midpoint, and start compare the element in each sublist again by pair,
#then it will use the method from the project2 as a subroutine method to merge and sort until there is only one list left.
#basically, it will increase the sublist's size from smaller till it larger then the original size then it will end the prog and generate output
#since it is not a recursive program, it is an iterative program when it come to sort and merge.

.data
first: .space 100     #.word 6, 5, 9, 1, 7, 0, -3, 2
subb: .space 100			#max 8
subs: .space 100
size:		.word 8				
merged:      .space 100		#max 16 elements total
sinput: .asciiz "Enter size of an array to sort: "
input: .asciiz "Enter integer to sort: \n"
resultMsg:  .asciiz " The new list is: "

.text
.globl main
main:
	la $s0, first			#load addresses of unsorted- list
	la $a0, sinput		#loads input size text into $a0
	li $v0, 4        
	syscall
	li $v0, 5     
	syscall
	move $t5, $v0  
	move $t8, $v0
input_loops:
	beq $t5,$t0,start		#once it reaches the size then start the prog
	la $a0, input			#loads input text into $a0
	li $v0, 4        
	syscall         
	li $v0, 5       
	syscall         
	addi $t0,$t0,1
	sw $v0, ($s0)		#stores input into array
	addi $s0, $s0,4		#hop one
	j input_loops
start:
	#define constant and counter
	la $s0, first
	la $a1, subb
	la $a2, subs
	la $a3, merged
	srl $t5, $t5, 1			#find the midpoint
	li $t6, 0
	li $t0, 0
	li $t7, 1
	j loop
reset1:#consider each reset is one loop
	addi $s0, $s0, -16 		#move the pointer
	la $a1, subb
	la $a2, subs
	li $t0, 0
	divu $t3, $t5, 2
	j store
reset2:
	la $a1, subb
	la $a2, subs
	li $t0, 0
	li $t4, 0
	j kloop
reset3:
	#addi $a3, $a3, -16
	la $s2, ($a3)
	la $s0, first
	la $a1, subb
	la $a2, subs
	li $t0, 0
	divu $t3, $t5, 2
	j store
reset4:	
	la $a3, merged
	la $s0, first
	move $s0, $a3
	la $a1, subb
	la $a2, subs 								 
	bgt $t3, $t5, end
	sll $t3, $t3, 1
	sll $t5, $t5, 1
	li $t0, 0
	li $t4, 0
	j store

kloop:
	beq $t0, $t3, lc1		#either i or j reach the size of the list, will go to end
	beq $t4, $t3, lc2		#if it reached the end of the list, go to end
	# initialize pointers
	lw $t1, 0($a1)		#load 1st element
	lw $t2, 0($a2)
	#compare the elements from 2 lists, 
    	ble $t1, $t2, m2		#first less than second, go to m1
	sw $t2, ($a3)  		#copy element from second to merged
	addiu $a2, $a2, 4		#hop to next element of the second
	addiu $a3, $a3, 4		#hop to next element of the merged
	addi $t0, $t0, 1		#increment i=+1	
	j kloop		
m2:				#merging 
	sw $t1, ($a3)	 	#copy element from first to merged
	addiu $a1, $a1, 4		#hop to next element of the first
	addiu $a3, $a3, 4		#hop to next element of the merged
	addi $t4, $t4, 1		#increment j=+1
	j kloop
lc1:
	sw $t1, ($a3)		#copy the last element(s) from first to mergedl
	addiu $a3, $a3, 4		#hop to next element of the merged
	addiu $t6, $t6, 1		#hop to next element of the merged
	bge $t6, $t3, reset4
	sll $t7, $t7, 2
	bge $t7, $t8, op		#check the counter if if larger than original size
	j reset3
lc2:
	sw $t2, ($a3)		#copy the last element(s) from second to merged
	addiu $a3, $a3, 4		#hop to next element of the merged
	addiu $t6, $t6, 1		#hop to next element of the merged
	bge $t6, $t3, reset4
	sll $t7, $t7, 2
	bge $t7, $t8, op
	j reset3
store:#this is where the sublists happened
	beq $t0, $t3, store2		#check counter
	lw $t1, 0($s0)
	sw $t1, 0($a1)		#store to first sublist
	addi $a1, $a1, 4
	addi $s0, $s0, 4
	addi $t0, $t0, 1
	j store		    	
store2:
	beq $t0, $t5 reset2
	lw $t1, 0($s0)
	sw $t1, 0($a2)		#store to second sublists
	addi $s0, $s0, 4
	addi $a2, $a2, 4
	addi $t0, $t0, 1
	j store2
loop:
	beq $t0, $t5, reset1		#condition to check if it reaches the midpoint 
	lw $t1, 0($s0)	
	lw $t2, 4($s0)
	j swap
swap:	
    	ble $t1, $t2, m1		#first less than second, go to m1
	sw $t1, 4($s0)		#swap
	sw $t2, 0($s0)
	addi $s0, $s0, 8		#hop next two
	addi $t0, $t0, 1		#increment counter	
	j loop			
m1:	
	sw $t1, 0($s0)		#swap
	sw $t2, 4($s0)	
	addi $s0, $s0, 8		#hop next two
	addi $t0, $t0, 1		#increment counter
	j loop	
op:#output 
	li $v0, 4
	la $a0, resultMsg		#load the address of the result message
	syscall
	
	la $a3, merged
	li $t7, 0			#initialize z
	lw $t5, size
show:
	lw $t8, ($a3)			#load an element from the merged
	li $v0, 1
	move $a0, $t8		#set it to an integer
	syscall

	addi $t7, $t7, 1		#increment z+=1
	addi $a3, $a3, 4		#hop to next element of the merged

	beq $t7, $t5, end		#if it reached the end of the list, go to end

	li $v0, 11
	li $a0, ' '
	syscall
	j show
end:
        #exit program
        li $v0, 10
        syscall
