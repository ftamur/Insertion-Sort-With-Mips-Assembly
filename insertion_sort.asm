#####################################################################
#                                                                   #
# Name: Firat Tamur                               					#
# 		                                            			    #
#####################################################################

# This file serves as a template for creating 
# your MIPS assembly code for assignment 2

.eqv MAX_LEN_BYTES 400

#====================================================================
# Variable definitions
#====================================================================


.data

arg_err_msg:       				.asciiz   "Argument error"
input_msg:         				.asciiz   "Input integers\n"
  
#  You can define other data as per your need. 

# string variables:
array_size_message: 			.asciiz "Enter 0-99 number for array size: "
newline:						.asciiz "\n"
sorted_msg:						.asciiz "Sorted List:\n"
sorted_without_duplicate_msg: 	.asciiz "\nSorted list without duplicates:\n"
list_sum_msg: 					.asciiz "\nList sum:\n"
space:							.asciiz " "

# array info variables:
array_size: 					.word 0 				# keeping array size
array_size_new:					.word 0 				# keeping new array size after remove duplicates
input_array:					.space MAX_LEN_BYTES


.text
.globl main

    main:
        #
        # Main program entry
        #
        #
        # Main body
        # 
    
        # Check for command line arguments count and validity
        
        jal check_Arg_Count
        
        # Check for first argument to be n
        
        jal check_First_Is_N
        
        # Converts the input size string to int and store it.
        
        jal check_ArraySize_and_Store
        
        # functions
        
        jal Data_Input                      # reads input array
        jal sort_data                       # sorts data
        jal print_w_dup                     # prints sorted data with duplicateds
        jal remove_duplicates               # removes duplicates
        jal print_wo_dup                    # prints without duplicated
		jal printListSum                    # prints list sum
        
	exit:
		# The end signal for program.
      	li $v0, 10
       	syscall
       	
    check_Arg_Count:
    
    	# Mars takes argv count into $a0.
    	# Here, I am checking if $a0 == 2 else go to Arg_err.
    
    	# move the arguments count to $t0.
    	move $t0, $a0
    	
    	# creating 2 for comparison.
    	addi $t1, $zero, 2
 		
 		# go to argument error if count is not equal 2.
    	bne $t0, $t1, Arg_Err
    
    	jr $ra
    	
    check_First_Is_N:
    	
    	# load first argv into $t0.
    	lw $t0, 0($a1) 					# takes the first argv value
    	
    	
		lb $t1, 0($t0)					# takes the first character of input
		lb $t2, 1($t0)					# takes the second character of input
	
		# add ascii codes of '-' and 'n' to compare with first argv
		addi $t4, $zero, 45 			# the ascii value for '-'
		addi $t5, $zero, 110			# the ascii value for 'n'
	
		bne $t1, $t4, Arg_Err			# checks if first character equals to '-' else go to Arg_Err
		bne $t2, $t5, Arg_Err			# checks if second character equals to 'n' else go to Arg_Err
			
		jr $ra
		
	check_ArraySize_and_Store:
	
		lw $t0, 4($a1)					# loads the array size from argv as string.
		
		# takes first and second character of the second argv.
		lb $t1, 0($t0)
		lb $t2, 1($t0)
		
		# 0 ascii code -> 48
		addi $t4, $zero, 48
	
		# We do not accept input array list size with zero at first digit of number.
		# if the first digit is zero go to arg_err.
		beq $t1, $t4, Arg_Err
	
		if_check:
		
			# if 2. character is zero -means end of string- we have a digit.
			# else it means that we have a number between 1-99 and go to else part.
			bne $t2, $zero, else_check
	
			# getting value of the digit by subtract 48 from its ascii code.
			subi $t1, $t1, 48
			
			# Here, when we analyze the ascii code we that if we subtract 48 from the digits ascii
			# code we get the number value of the digits. 
			
			# For example 0's ascii code is 48. If we subract 48 we get 0 as number value.
			
			# Check if it is digit
			addi $t6, $zero, 10
			bge $t1, $t6, Arg_Err
			blt $t1, $zero, Arg_Err 
		
			# store array size to use later.
			sw $t1, array_size
		
			j exit_if_check

		else_check:
	
			# because 2.character is not end of string it must be digit too.
			lb $t3, 2($t0)
		
			# Here, We accept 1-99 as the input size for our array.
			# That's why if user enter 100 or larger we will raise Argument error. 
			# We think that because our input array size 400 byte -means 100 word-.
			# if string length longer than 2 go to argument error.
			bne $t3, $zero, Arg_Err
		
			# getting value of 2. digit number by subtract 48 from its ascii code.
		
			# 10s digit
			subi $t1, $t1, 48
			
			# check if it is digit
			addi $t6, $zero, 10
			bge $t1, $t6, Arg_Err 
			blt $t1, $zero, Arg_Err 
		
			# multipy with 10
			addi $t5, $zero, 10
			mul $t1, $t1, $t5
		
			# 1s digit
			subi $t2, $t2, 48
			
			# check if it digit
			addi $t6, $zero, 10
			bge $t2, $t6, Arg_Err 
			blt $t2, $zero, Arg_Err 
		
			# total number
			add $t1, $t1, $t2
		
			# store array size to use later.
			sw $t1, array_size
	
		exit_if_check:		
			
		jr $ra
    
    Data_Input:
    
    # Get integers from user as per value of n
    
    ##################  YOUR CODE  ####################   
 
 		li $v0, 4
 		la $a0, input_msg
 		syscall
 
        # load the array size
        lw $t0, array_size
      
        # creating i for while loop
        addi $t1, $zero, 0		# t1 is i value for while loop.
        
        while_data_input:
            
            bge $t1, $t0, exit_data_input
            
            # read number
            li $v0, 5
            syscall
            
            # move the user input to $t2.
            move $t2, $v0
            
            # store the number to array
            # find the index for the array by multiply with 4 with sll by 2.
            sll $t3, $t1, 2
            sw $t2, input_array($t3)
          
            # i++
            addi $t1, $t1, 1
            
            j while_data_input
		
	    exit_data_input:
	
        	jr $ra					# jump to $ra
        
   
  	# Insertion sort begins here
    sort_data:

        ##################  YOUR CODE  ####################
    
        # create i value
        addi $t0, $zero, 1 		# t0 is i value
        
        # create j value
        addi $t1, $zero, 0    	# t1 is j value
    
        # laod array size
        lw $t2, array_size		# t2 is array size
        
        while_sort_data:
        
            # check i < array size
            bge $t0, $t2, exit_sort_data
            
            # current element
            sll $t3, $t0, 2 				# multipy i with 4 find index of array.
            lw $t4, input_array($t3)		# $t4 stores current element
            
            # j = i - 1
            subi $t1, $t0, 1
            
            # arr[j]
            sll $t3, $t1, 2					# multipy j with 4 find index of array.
            lw $t5, input_array($t3)		# $t5 stores the arr[j]
            
            while_inner:
                
                sge $t6, $t1, 0  				# sets $t5 1 if j >= 0 else 0
                slt $t7, $t4, $t5				# sets $t6 1 if current < arr[j] else 0.
                
                and $t8, $t6, $t7				# check j >= 0 and arr[j] > current element
                beq $t8, $zero, exit_inner		# if j < 0 or arr[j] <= current element exit.
                
                # j + 1
                addi $t3, $t1, 1
                
                # arr[j+1] = arr[j]				
                sll $t3, $t3, 2 				# multipy j+1 with 4 find index of array for arr[j+1]
                sw $t5, input_array($t3)		# arr[j] = $t5 store to $t3 = arr[j+1]
                
                # j - 1
                subi $t1, $t1, 1
                
                # update arr[j]
                sll $t3, $t1, 2					# multipy j with 4 find index of array.
                lw $t5, input_array($t3)
                
                j while_inner
                        
            exit_inner:
            
                # j + 1
                addi $t3, $t1, 1
                
                # arr[j+1] = current element
                sll $t3, $t3, 2	
                sw $t4, input_array($t3)
            
                # i++
                addi $t0, $t0, 1
                
                j while_sort_data
                
        exit_sort_data:

        jr $ra
        
       		
    remove_duplicates:
    
        ##################  YOUR CODE  ####################

        # Print sorted list with and without duplicates
        
        # keep j = 0
        addi $t0, $zero, 0
        
        # keep i = 0
        addi $t1, $zero, 0
        
        # load arraysize
        lw $t2, array_size
        
        # n = n -1
        subi $t2, $t2, 1
        
        while_remove_duplicates:
            
            # check if i < n - 1
            bgeu $t1, $t2 exit_remove_duplicates
            
            # arr[i]
            sll $t3, $t1, 2
            lw $t4, input_array($t3)
            
            # arr[i+1]
            addi $t3, $t1, 1
            sll $t3, $t3, 2
            lw $t5, input_array($t3) 
            
            # check of arr[i] != arr[i+1]
            beq $t4, $t5 else
            
            # arr[j] = arr[i]
            sll $t3, $t0, 2 
            sw $t4, input_array($t3)
            
            # j++
            addi $t0, $t0, 1
            
            else:
            
            addi $t1, $t1, 1
            
            j while_remove_duplicates
            
        exit_remove_duplicates:
    
            # arr[n-1]
            sll $t1, $t2, 2
            lw $t3, input_array($t1)
            
            # arr[j] = arr[n-1]
            sll $t4, $t0, 2
            sw $t3, input_array($t4)
            
            # j++
            addi $t0, $t0, 1
            
            # store new size of input array
		    sw $t0, array_size_new

            jr		$ra					# jump to $ra


    print_w_dup:

    ##################  YOUR CODE  ####################
        
        # print the sorted_msg
        li $v0, 4
        la $a0, sorted_msg
        syscall

        # print sorted array
        
        # load array size
        lw $t0, array_size
            
        # create index variable
        addi $t1, $zero, 0
        
        # create i value
        addi $t2, $zero, 0
        
        while_print_array:
                
            bge $t2, $t0, exit_print_array
            
            # print current number
            li $v0, 1
            lw $a0, input_array($t1)
            syscall
            
            # leave a space between them
            li $v0, 4
            la $a0, space
            syscall 
            
            # increate index value by adding 4
            addi $t1, $t1, 4
            
            # i++
            addi $t2, $t2, 1
            
            j while_print_array
            
        exit_print_array:
        
        jr	$ra
           
    print_wo_dup:

    ##################  YOUR CODE  ####################
    
        # print sorted array
        # This methods also find summation of the number in the list while printing them.
        
        # display the sorted_without_duplicate_msg
        li $v0, 4
        la $a0, sorted_without_duplicate_msg
        syscall
        
        # load array size
        lw $t0, array_size_new
        
        # Keep the list sum
        addi $s0, $zero, 0
            
        # create index variable
        addi $t1, $zero, 0
        
        # create i value
        addi $t2, $zero, 0
        
        while_print_array_new:
                
            bge $t2, $t0, exit_print_array_new
            
            # print current number
            li $v0, 1
            lw $a0, input_array($t1)
            syscall
            
            # add current element to sum
            add $s0, $s0, $a0
            
            # leave a space between them
            li $v0, 4
            la $a0, space
            syscall 
            
            # increate index value by adding 4
            addi $t1, $t1, 4
            
            # i++
            addi $t2, $t2, 1
            
            j while_print_array_new
            
            
        exit_print_array_new:

        jr $ra			
        

  
	# Perform reduction
   
   ##################  YOUR CODE  ####################

    printListSum:

        # display the list_sum_msg
        li $v0, 4
        la $a0, list_sum_msg
        syscall 

        # Print sum 
        # We calculated the list sum in the function print_wo_dup and stored in the $s0.
        li  $v0, 1
        addi $a0, $s0, 0      # $s0 contains the sum  
        syscall

        jr $ra	
        
        
	Arg_Err:

        # Error message when no input arguments specified
        # or when argument format is not valid
        la $a0, arg_err_msg
        li $v0, 4
        syscall
        j exit

         
