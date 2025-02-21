	.data
buf2:	.space 32 
buf: 	.space 32 # wherever the last useful data in header is 

path: 	.asciz "1.bmp"
path_out:.asciz "blurred.bmp"

	.eqv exit, 10 
	.eqv close_file, 57
		

	.macro read_by_byte
	# t0 adress of the start where
	# modifies t1 and t2
	
	addi 	t0, t0, 3
	lbu	t2, (t0)
	slli 	t2, t2, 8
	
	addi 	t0, t0, -1
	lbu	t1, (t0)
	add	t2, t2, t1
	slli 	t2, t2, 8
	
	addi 	t0, t0, -1
	lbu	t1, (t0)
	add	t2, t2, t1
	slli 	t2, t2, 8
	
	addi 	t0, t0, -1
	lbu	t1, (t0)
	add	t2, t2, t1

	mv	t0, t2
	.end_macro

	.text
	
	.globl openheader
	
	
openheader:	#open bmp file handle (read)
	la 	s0, buf
	li	a7, 1024
	la 	a0, path
	li 	a1, 0
	ecall 
	mv 	t0, a0 # descriptor at t0
	
read:   # read file
	la	a1, buf
	li 	a2, 32 # max amount to read
	li 	a7, 63
	ecall

	#close file
	mv	a0, t0
	li	a7, close_file
	ecall
	
printd: # reading first letter of file for testing
	lbu 	a0, (s0)
	li 	a7, 11
	ecall


get_header_info: # this section is done by macro since it's cleaner but could be done with less instructions without it
	
	addi	t0, s0, 0x2 # offset where file lenght is
	read_by_byte
	mv 	s6, t0
	
	addi 	t0, s0, 0xA # offset where the offset of pixel array starts
	read_by_byte
	mv 	s1, t0
	
	
	addi	t0, s0, 0x12 # offset of the width of bitmap(left to right)(word)
	read_by_byte
	mv 	s2, t0

	
	addi 	t0, s0, 0x16 # offset of the height of bitmap(bottom to top)(word)
	read_by_byte
	mv 	s3, t0

	
	addi 	s4, s0, 0x1C # offset of number of bits per pixel(half word)(later changed to bytes)
	lh 	s4, (s4)
	
	
calculate_pad: #row size equation from wiki
	mul	t0, s4, s2
	addi 	t0, t0, 31
	srli	t0, t0, 5 	
	slli	t0, t0, 2
	#row size with pad at t0(bytes)
	
	srli	s4, s4, 3 # changing to bytes instead of bits per pixel
	mul 	s9, s2, s4
	
	sub	s8, t0, s9 # amount of padding in bytes at s8
	
allocate_memory:
	
	# main memory for bmp
	li 	a7, 9
	mv	a0, s6
	ecall 	
	mv 	s7, a0
	
	#memory for 2 last rows 
	mv	a0, s9
	slli	a0, a0, 1

	ecall 	
	mv 	s0, a0

read_full_bmp:
	# opens file
	la 	a0, path
	li 	a1, 0
	li 	a7, 1024
	ecall
	mv	t0, a0
	
	# reads from file
	mv	a1, s7
	mv	a2, s6 # max amount to read is file lenght
	li 	a7, 63
	ecall
	
	mv	a0, t0
	li	a7, close_file
	ecall

#s11 - sum of all
#s10 - two last rows counter
#s9 - number of bytes in row without pad
#s8 - pixel padding after each row
#s7 - main heap memory adress
#s6 - file lenght in bytes
#s5 - spacing of 5 pixels in bytes
#s4 - number of bytes per pixel (prob not needed tbh)
#s3 - height of bitmap(bottom to top) in pixels
#s2 - width of bitmap(left to right) in pixels
#s1 - offset of pixel array
#s0 - heap address of 2 last 
	
setup: 

	# calculating spacing
	mv	s5, s4
	slli	s5, s5, 2
	add	s5, s5, s4 


	add	t0, s7, s1 # t0 current pixel to blur address
	
	mv	t1, t0 # current pixel used to blur address
	sub	t1, t1, s4
	sub	t1, t1, s4
	
	mv	t3, s0 # t3 - current pixel used to blur in the 2 row heap address
	sub	t3, t3, s4
	sub	t3, t3, s4
	 
	la	t4, buf2 # t4 - 25 byte buffer address
	
	li 	t2, 3
	
	mv	t5, s0 # adress to which pixel will save in 2 row heap
	mv 	t6, s9 # how many bytes in row left
	li	s10, 2
	
	# s11 - sum of all
	mv 	s11, zero
	li	a2, 5

	b write_bmp
# a2 used as loop counter 
load_pixel_from_buf1: #first buffer row
	lbu	a1, (t3)
	sb	a1, (t4)
	add	s11, s11, a1

	
	add	t3, t3, s4
	addi	t4, t4, 1
	addi	a2, a2, -1
	bnez	a2, load_pixel_from_buf1
	
	add	t3, t3, s9 # adding row size
	sub	t3, t3, s4
	li	a2, 5

load_pixel_from_buf2: #second buffer row
	lbu	a1, (t3)
	sb	a1, (t4)
	add	s11, s11, a1

	sub	t3, t3, s4
	addi	t4, t4, 1
	addi	a2, a2, -1
	bnez	a2, load_pixel_from_buf2
	
	li	a2, 5
	
load_pixel_from_main1:
	lbu	a1, (t1)
	sb	a1, (t4)
	add	s11, s11, a1
	
	add	t1, t1, s4
	addi	t4, t4, 1
	addi	a2, a2, -1
	bnez	a2, load_pixel_from_main1
	li	a2, 5
	
	# lining up next row
	sub	t1, t1, s5
	#sub	t1, t1, s4
	add	t1, t1, s9 
	add 	t1, t1, s8
	
	addi	t2, t2, -1
	bnez	t2, load_pixel_from_main1


	
	
# this section will subtract 5 lowest and 5 highest from s11
#ASSSUMPTIONS
	# buffer of 25 filled completely, adress is at the end of it

selection_setup:
	la	a1, buf2
	la	a2, buf2
	lbu	a0, (t1)

	addi	a3, t4, 1
	li	a5, 24
	li 	a6, 5 # counter to only sort 5 elements
#a0 current lowest
#a1 current lowest adress
#a2 already sorted +1 pointer
#a3 current number address
lf_lowest:
	lbu	a4, (a3)
	addi	a3, a3, 1
	addi	a5, a5, -1
	beqz	a5, next_iter
	bgt	a4, a0, lf_lowest
	
new_lowest:
	addi	a1, a3, -1
	mv	a0, a4
	b	lf_lowest
		
next_iter:
	#swap lowest
	lbu	a7, (a2) #a7 temp
	sb	a7, (a1)
	sb	a0, (a2)
	sub	s11, s11, a0
	
	addi 	a6, a6, -1

	addi	a2, a2, 1
	mv	a1, a2
	lbu	a0, (a2)	
	addi	a3, a2, 1
	addi	a5, a6, 19

	bnez	a6, lf_lowest 


selection_setup_reverse:
	la	a2, buf2
	addi	a2, a2, 24

	mv	a1, a2
	lbu	a0, (a2)
	addi	a3, a2, -1
	
	li 	a5, 19
	li	a6, 5
#a0 current highest
#a1 current highest adress
#a2 already sorted +1 pointer
#a3 current number address
lf_highest:
	lbu	a4, (a3)
	addi	a3, a3, -1
	addi	a5, a5, -1
	beqz	a5, next_iter_r
	blt	a4, a0, lf_highest
	
new_highest:
	addi	a1, a3, 1
	mv	a0, a4
	b	lf_highest
		
next_iter_r:
	#swap lowest
	lbu	a7, (a2) #a7 temp
	sb	a7, (a1)
	sb	a0, (a2)
	sub	s11, s11, a0 # removing from s11
	
	addi 	a6, a6, -1

	addi	a2, a2, -1
	mv	a1, a2
	lbu	a0, (a2)
	addi	a3, a2, -1
	addi	a5, a6, 13

	bnez	a6, lf_highest # if a6 not zero continue loop
	#setup loop
	
save_pixel: # s11 now holds median
	#save pixel to buffer
	lbu	a7, (t0)
	sb	a7, (t5)

	#save blurred pixel to main
	li 	a0, 15
	divu	s11, s11, a0
	sb	s11, (t0)

check_row:
	addi	t6, t6, -1
	beqz	t6, row_ended
	# row doesn't end actions
	
	addi	t5, t5, 1

	# setting up t3 back to the correct spot
	sub	t3, t3, s9
	add 	t3, t3, s4
	addi 	t3, t3, 1
	
	b next_byte


row_ended:
	addi 	s3, s3, -1 #  rows counter
	beqz	s3, write_bmp 
	# row ended
	add 	t0, t0, s8 # adds padding to skip row
	mv	t6, s9 # reset bytes in row counter

	
	# setting up t3
	mv	t3, s0
	sub	t3, t3, s4
	sub	t3, t3, s4
	
	# setting up t5 overwritten below everysecond row
	addi	t5, t5, 1
	
	addi	s10, s10, -1
	bnez	s10, next_byte
	# if the pointer in 2 row buffer is at the end reset it and set t3 and t5
	li	s10, 2
	mv	t5, s0
	
	
	
next_byte: # changes that happen whether or not row ended
	addi	t0, t0, 1 # next blur target
	mv 	s11, zero # resetting sum
	# resetting counters
	li	a2, 5
	li 	t2, 3
	la	t4, buf2 # t4 - 25 byte buffer address
	
	# setting up t1 back to the correct spot
	mv	t1, t0
	sub	t1, t1, s4
	sub	t1, t1, s4
	
	
	b	load_pixel_from_buf1
	
write_bmp:
	la 	a0, path_out 
	li 	a1, 1
	li 	a7, 1024
	ecall
	mv	t0, a0
	
	mv	a1, s7
	mv	a2, s6 # max amount to write
	li 	a7, 64
	ecall
	mv	a0, t0
	li 	a7, close_file
	ecall
	
end:
	li	a7, exit
	ecall
