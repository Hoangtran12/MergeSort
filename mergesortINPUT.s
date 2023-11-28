
#This program is implemented a bottom-up approach method to sort an array.
#It will sort neighbort and put them into two sublists
#then it will move the counter back to the midpoint, and start compare the element in each sublist again by pair,
#then it will use the method from the project2 as a subroutine method to merge and sort until there is only one list left.
#since it is not a recursive program, it is an iterative program when it come to sort and merge.

.data
first: .space 100     #.word 6, 5, 9, 1, 7, 0, -3, 2
subb: .space 32			#max 8
subs: .space 32
size:		.word 8				
merged:      .space 64		#max 16 elements total
sinput: .asciiz "Enter size of an array to sort: "
input: .asciiz "Enter integer to sort: \n"
resultMsg:  .asciiz " The new list is: "

.text
.globl main

main:
	la $s0, first		#load addresses of unsorted- list
	la $a0, sinput		#loads input size text into $a0
	li $v0, 4        
	syscall
	li $v0, 5     
	syscall
	move $t5, $v0  
input_loops:
	beq $t5,$t0,start	#once it reaches the size then start the prog
	la $a0, input   	#loads input text into $a0
	li $v0, 4        
	syscall         
	li $v0, 5       
	syscall         
	addi $t0,$t0,1
	sw $v0, ($s0)   	#stores input into array
	addi $s0, $s0,4  	#hop one
	j input_loops 
start:
	#reset pointer of all lists
	la $s0, first
	la $a1, subb
	la $a2, subs
	la $a3, merged
	li $t0, 0		#initialize couter
	srl $t5, $t5, 1		#find the midpoint
	j loop
loop:
	beq $t0, $t5, mj	#once at midpoint, start merging
	# initialize pointers
	lw $t1, 0($s0)	
	lw $t2, 4($s0)
	j iloop
iloop:	
    	ble $t1, $t2, m1	#first less than second, go to m1
	sw $t1, 4($a3)		#perform swap
	sw $t2, 0($a3)
	addi $s0, $s0, 8	#hop next two
	addiu $a3, $a3, 8	#hop next two
	addi $t0, $t0, 1	#increment counter	
	j loop			
m1:				#merging 
	sw $t1, 0($a3)		
	sw $t2, 4($a3)		
	addiu $a3, $a3, 8	
	addi $s0, $s0, 8	
	addi $t0, $t0, 1	
	j loop	
mj: 	
	#reset pointer and counter
	la $a3, merged	
	li $t0, 0 		
	srl $t5, $t5, 1
	j mi
mi:
	beq $t0, $t5 mjj	#check counter
	lw $t1, 0($a3)
	sw $t1, 0($a1)		#store to first sublist
	addi $a3, $a3, 4
	addi $a1, $a1, 4
	addi $t0, $t0, 1
	j mi			    	
mjj: 
	li $t0, 0		#reset counter for second sublists
	j mii
mii:
	beq $t0, $t5 last
	lw $t1, 0($a3)
	sw $t1, 0($a2)		#store to second sublists
	addi $a3, $a3, 4
	addi $a2, $a2, 4
	addi $t0, $t0, 1
	j mii			
last:	
	#reset counter and pointer
	la $a1, subb
	la $a2, subs
	la $a3, merged
	li $t0, 0
	li $t3, 0
kloop:				#subroutine using PROJECT 2
	beq $t0, $t5, lc1	#either i or j reach the size of the list, will go to end
	beq $t3, $t5, lc2	#if it reached the end of the list, go to end
	# initialize pointers
	lw $t1, 0($a1)		#load 1st element
	lw $t2, 0($a2)
	#compare the elements from 2 lists, 
    	ble $t1, $t2, m2	#first less than second, go to m2
	sw $t2, ($a3)  		#copy element from second to merged
	addiu $a2, $a2, 4	#hop to next element of the second
	addiu $a3, $a3, 4	#hop to next element of the merged
	addi $t0, $t0, 1	#increment counter	
	j kloop			
m2:				#merging 
	sw $t1, ($a3)	 	#copy element from first to merged
	addiu $a1, $a1, 4	#hop to next element of the first
	addiu $a3, $a3, 4	#hop to next element of the merged
	addi $t3, $t3, 1	#increment counter
	j kloop			#back to loop
lc1:
	sw $t1, ($a3)		#copy the last element(s) from first to merged
	addiu $a3, $a3, 4	
	j mj2
lc2:
	sw $t2, ($a3)		#copy the last element(s) from second to merged
	addiu $a3, $a3, 4	#hop to next element of the merged
	j mj2
mj2: 	
	#reset counter and pointer			
	la $a1, subb
	la $a2, subs
	li $t0, 0 		
	j mi2
mi2:
	beq $t0, $t5 mjj2	#check condition
	lw $t1, 0($a3)
	sw $t1, 0($a1)		#store to first sublist
	addi $a3, $a3, 4
	addi $a1, $a1, 4
	addi $t0, $t0, 1
	j mi2			    	
mjj2: 
	li $t0, 0
	j mii2
mii2:
	beq $t0, $t5 last2
	lw $t1, 0($a3)
	sw $t1, 0($a2)		#store to second sublists
	addi $a3, $a3, 4
	addi $a2, $a2, 4
	addi $t0, $t0, 1
	j mii2

last2:	la $a1, subb
	la $a2, subs
	add $a3, $a3, -16
	li $t4, 0
	li $t0, 0
	li $t3, 0
zloop:				#subroutine
	beq $t0, $t5, lc11	#either i or j reach the size of the list, will go to end
	beq $t3, $t5, lc22	#f it reached the end of the list, go to end
	# initialize pointers
	lw $t1, 0($a1)		#load 1st element
	lw $t2, 0($a2)
	
	#compare the elements from 2 lists, 
    	ble $t1, $t2, m3	#first less than second, go to m1
	sw $t2, ($a3)  		#copy element from second to merged
	addiu $a2, $a2, 4	#hop to next element of the second
	addiu $a3, $a3, 4	#hop to next element of the merged
	addi $t0, $t0, 1	#increment i=+1	
	j zloop			
m3:				#merging 
	sw $t1, ($a3)	 	#copy element from first to merged
	addiu $a1, $a1, 4	#hop to next element of the first
	addiu $a3, $a3, 4	#hop to next element of the merged
	addi $t3, $t3, 1	#increment j=+1
	j zloop			
lc11:
	sw $t1, ($a3)		#copy the last element(s) from first to merged
	j last3
lc22:
	sw $t2, ($a3)		#copy the last element(s) from second to merged
	j last3
last3:
	#reset
	la $a1, subb
	la $a2, subs
	la $a3, merged
	li $t0, 0 		
	sll $t5, $t5, 1		#adjust the array size for last mergesort
	j mi3
mi3:
	beq $t0, $t5 mjj3	#check counter
	lw $t1, 0($a3)
	sw $t1, 0($a1)		#store to first sublist
	addi $a3, $a3, 4
	addi $a1, $a1, 4
	addi $t0, $t0, 1
	j mi3			    	
mjj3: 
	li $t0, 0
	j mii3
mii3:
	beq $t0, $t5 reset33
	lw $t1, 0($a3)
	sw $t1, 0($a2)		#store to second sublists
	addi $a3, $a3, 4
	addi $a2, $a2, 4
	addi $t0, $t0, 1
	j mii3

reset33:la $a1, subb
	la $a2, subs
	la $a3 merged
	li $t4, 0
	li $t0, 0
	li $t3, 0
hloop:
	beq $t0, $t5, lc111	#ither i or j reach the size of the list, will go to end
	beq $t3, $t5, lc222	#f it reached the end of the list, go to end
	# initialize pointers
	lw $t1, 0($a1)		#load 1st element
	lw $t2, 0($a2)
    	ble $t1, $t2, m4	#first less than second, go to m4
	sw $t2, ($a3)  		#copy element from second to merged
	addiu $a2, $a2, 4	#hop to next element of the second
	addiu $a3, $a3, 4	#hop to next element of the merged
	addi $t0, $t0, 1	#increment i=+1	
	j hloop
m4:				#merging 
	sw $t1, ($a3)	 	#copy element from first to merged
	addiu $a1, $a1, 4	#hop to next element of the first
	addiu $a3, $a3, 4	#hop to next element of the merged
	addi $t3, $t3, 1	#increment j=+1
	j hloop		
lc111:
	sw $t1, ($a3)		#copy the last element(s) from first to merged
	j op
lc222:
	sw $t2, ($a3)		#copy the last element(s) from second to merged
	j op	    	
op:				#output 
	li $v0, 4
	la $a0, resultMsg	#load the address of the result message
	syscall
	
	la $a3, merged
	li $t7, 0		#initialize z
	lw $t5, size
show:
	lw $t8, ($a3)		#load an element from the merged
	li $v0, 1
	move $a0, $t8		#set it to an integer
	syscall

	addi $t7, $t7, 1	#increment z+=1
	addi $a3, $a3, 4	#hop to next element of the merged

	beq $t7, $t5, end	#if it reached the end of the list, go to end

	li $v0, 11
	li $a0, ' '
	syscall
	j show
end:
        #exit program
        li $v0, 10
        syscall
