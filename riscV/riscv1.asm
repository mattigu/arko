	.eqv	print_string, 4
	.eqv	get_string, 8
	.eqv	exit, 10
	
	.data
prompt:	.asciz	"Input text:\n"
buf:	.space	100
result:	.asciz	"Results:\n"

	.text
main:
	la	a0, prompt		# prints "Input text: "
	li	a7, print_string	
	ecall
	
	la	a0, buf			# gets string
	li	a1, 100
	li	a7, get_string
	ecall
	
	la	t0, buf			
			
	li	t2, '0'			
	li	t3, '9'
	
	
	
	
findnum:
	lbu	t1, (t0)		# loads first character into t1	
	beqz 	t1, repr		# if t1 is \0 then branch to repr 
	bltu	t1, t2, next		# if not num then branch to not_num
	bgtu	t1, t3, next		# as above
	
swapswap:
	sub	t1, t1, t2		# sub ascii value of '0'
	sub	t1, t3, t1		# sub from ascii value of '9' number idk	
	sb	t1, (t0)		
	
next: 
	addi	t0, t0, 1
	b	findnum

repr:
  	la 	a0, result
    	li 	a7, 4
    	ecall

	la 	a0, buf
    	li 	a7, 4
    	ecall

exits:
	li 	a7, exit
	ecall
