	.data 
array: 				.space 400
string1: 			.asciiz "Nhap do dai mang: "
string_element_open: 		.asciiz "Nhap a["
string_element_close:		.asciiz "]: "
string_open: 			.asciiz "a["
string_close:			.asciiz "] = "
escape_sequence:		.asciiz "\n"
string_input_notification: 	.asciiz "NHAP CAC PHAN TU CUA MANG\n"
string_output_notification:	.asciiz "CAC PHAN TU CUA MANG: "
string_space:			.asciiz " "
string_median:			.asciiz "\nPHAN TU TRUNG VI: "
string_menu:			.asciiz "\nMENU CAC LOAI THUAT TOAN SORT MANG\n0. Bubble sort\n1. Selection sort\n2. Insertion sort\nMoi chon thuat toan: "
	.text
 main:
 	li	$t6, 1		# constant value 1
 	li 	$t7, 101 	# over_size = 101, size >= over_size || size <= 0 => read_size_loop
 input:
	 print_input_notification:
 		li 	$v0, 4
 		
 		la 	$a0, string_input_notification
 		syscall
 	# input size of array
 	print_string1:
 		li 	$v0, 4
 
 		la 	$a0, string1
 		syscall 
 	
 	read_size:
 		li 	$v0, 5
 	
 		syscall
 		add 	$s0, $zero, $v0 	# size: $s0
 	
 	check_size:	
 		slt 	$t1, $s0, $t7	# size < 101 ?
 		beq 	$t1, $zero, input
 		
 		slt 	$t1, $s0, $t6 	# size <= 0 ?
 		bne 	$t1, $zero, input
 	read_elements:
 		# index : $t1
 		addi 	$t1, $zero, 0	# index $t1 = 0
 		la	$t0, array 	# load address to $t0
 		read_loop:
 			beq 	$t1, $s0, end_read_loop # index = size => break
 			
 			print_string_element_open:
 				li	$v0, 4
 				
 				la	$a0, string_element_open
 				syscall
 			print_index:
 				li 	$v0, 1
 				
 				add	$a0, $zero, $t1
 				syscall
 			print_string_element_close:
 				li 	$v0, 4
 				
 				la 	$a0, string_element_close
 				syscall
 			read_element:	# $t8 <=> array[$t1]
 				li 	$v0, 5
 				
 				syscall 
 				add 	$t8, $zero, $v0
 				
 				slt 	$t2, $t8, $t6	# arr[index] < 1 ?
 				bne 	$t2, $zero, read_loop
 				
 				sw 	$t8, 0($t0)
 				
 			addi 	$t0, $t0, 4 
 			addi	$t1, $t1, 1
 			j 	read_loop
 		end_read_loop:
 	
 	print_menu:
 		li 	$v0, 4
 		la	$a0, string_menu
 		syscall
 		
 	read_option:
 		li 	$v0, 5
 		syscall
 		add 	$s2, $zero, $v0 	# option : $s2
 			
 end_input:
 
 switch_case:
 	beq 	$s2, $zero, bubble_sort
 	beq 	$s2, $t6, selection_sort
 	j 	insertion_sort
 
 bubble_sort:
	li 	$t1, 0		# i = 0
	 	
 	loop_i:
 		beq	$t1, $s0, done_loop_i
 		li 	$s1, 0 	# boolean swap = 0 -> false else swap = 1 -> true
 		li 	$t2, 0	# j = 0
 		
 		la 	$t0, array 	# load address of array into $t0
 		sub 	$s3, $s0, 1	
 		loop_j:
 			beq 	$t2, $s3, done_loop_j	# for j from 0 to n - 1
 			
 			lw	$t8, 0($t0) 	# $t8 <-- a[j]
 			lw 	$t9, 4($t0)	# $t9 <-- a[j + 1]
 			
 			slt 	$t4, $t9, $t8	# $t4 = 1 --> a[j] > a[j + 1]
 			beq 	$t4, $zero, end_swap_if 
 				swap:
 					sw 	$t9, 0($t0)
 					sw 	$t8, 4($t0)
 				li	$s1, 1
 			end_swap_if:
 				 
 			addi 	$t2, $t2, 1
 			addi 	$t0, $t0, 4
 			j	loop_j
 		done_loop_j:
 		
 		beq 	$s1, $zero, done_loop_i
 		addi	$t1, $t1, 1
 		j 	loop_i
 	done_loop_i:
 	j 	output
 end_bubble_sort:
 	
 selection_sort:
 	li 	$t1, 0		# i = 0
 	la	$t0, array	
 	
 	loop_i_1:
 		beq 	$t1, $s0, end_loop_i_1
 		
 		lw 	$t7, 0($t0)		# lw $t7 = a[i]
 		add 	$t8, $zero, $t7		# value of a[mini]
 		add 	$t2, $zero, $t1		# j: $t2 = i
 		add 	$s1, $zero, $t1		# mini: $s1 = i
 		add 	$t5, $zero, $t0		
 		
 		loop_j_1:
 			beq 	$t2, $s0, end_loop_j_1
 			
 			lw 	$t9, 0($t5)		# t9 <-- a[j]
 			slt 	$t4, $t9, $t8
 			beq 	$t4, $zero, continue_loop_j_1 	# if a[j] < a[mini] then mini = j, $t8 = a[j]
 				add 	$s1, $zero, $t2	
 				add 	$t8, $zero, $t9
 			continue_loop_j_1:
 			
 			addi 	$t2, $t2, 1
 			addi 	$t5, $t5, 4
 			j	loop_j_1
 		end_loop_j_1:
 		
 		beq	$t1, $s1, continue_loop_i_1 
 			sw 	$t8, 0($t0)
 			la 	$t4, array
 			sll 	$s1, $s1, 2
 			add 	$s1, $s1, $t4
 			sw 	$t7, 0($s1)
 		continue_loop_i_1:
 		
 		addi 	$t1, $t1, 1
 		addi 	$t0, $t0, 4
 		j 	loop_i_1
 	end_loop_i_1:
 	j 	output
 end_selection_sort: 

 insertion_sort:
 	la	$t0, array	# base address of array for i
 	addi 	$t0, $t0, 4	# address of a[1]
 	li 	$t1, 1		# i = 1
 	
 	loop_i_2:
 		beq 	$t1, $s0, end_loop_i_2
 		
 		sub 	$t2, $t1, 1	# j ($t2) = i - 1
 		lw 	$t8, 0($t0)	# t ($t8) = a[i]
 		# get address of a[i - 1] for j
 		add 	$t5, $zero, $t0
 		addi	$t5, $t5, -4
 		
 		while: 	# break when j < 0 or t >= a[j]
 			slt 	$t4, $t2, $zero	
 			bne	$t4, $zero, done
 			
 			lw 	$t9, 0($t5)	# $t9 = a[j]
 			
 			slt 	$t4, $t8, $t9
 			beq 	$t4, $zero, done
			
 			sw 	$t9, 4($t5) 	# a[j + 1] = a[j]
 			addi 	$t2, $t2, -1	# j--
 			addi 	$t5, $t5, -4	# move to a[j - 1] address
 			j 	while
 		done:
 		sw	$t8, 4($t5)
 		addi 	$t1, $t1, 1
 		addi 	$t0, $t0, 4
 		j 	loop_i_2
 	end_loop_i_2:
 	j 	output
 end_insertion_sort:

 output:
 	print_output_notification:
 		li 	$v0, 4
 		
 		la 	$a0, string_output_notification
 		syscall
 	
 	print_elements:
 		la	$t0, array
 		li 	$t1, 0
 		
 		for_elements:
 			beq 	$t1, $s0, done_for_elements
 			
 			lw 	$t8, 0($t0)
 			
 			print_element:
 				li	$v0, 1
 				add	$a0, $zero, $t8
 				syscall
 			
 			li 	$v0, 4
 			la	$a0, string_space
 			syscall
 			
 			addi 	$t1, $t1, 1
 			addi 	$t0, $t0, 4
 			j	for_elements
 		done_for_elements:
 		
 	print_median:
 		li	$v0, 4
 		la 	$a0, string_median
 		syscall
 		
 		# median pos : (n - 1) div 2
 		subi	$s0, $s0, 1
 		srl	$s0, $s0, 1
 		sll 	$s0, $s0, 2
 		la 	$t0, array
 		add 	$s0, $s0, $t0
 		lw 	$t4, 0($s0)
 		
 		li 	$v0, 1
 		add	$a0, $zero, $t4
 		syscall 
 	
 exit:
 	li 	$v0, 10
 	syscall	
