	.eqv	print_string, 4
	.eqv 	print_int, 1
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
	
	la 	s2, buf
	li 	s0, '0'
	li 	s1, '9'
	
	la 	t0, buf
	la 	t1, buf
	
	
# s0 - string adress string

checklen: 
	lbu 	t2, (t1)
	addi 	t1, t1, 1
	bnez 	t2, checklen
	addi  	t1, t1, -3

# t1 last byte of string
# t0 first byte of string

lookfordigit:
	lbu 	t2, (t0) # t2 current symbol 
	addi 	t0, t0, 1
	bgeu    t0, t1 print
	bgtu 	t2, s1, lookfordigit
	bltu 	t2, s0, lookfordigit
	
lfdigitreverse:
	lbu	t3, (t1) # t3 current symbol rev order
	addi 	t1, t1, -1
	bleu 	t1, t0, print
	bgtu 	t3, s1, lfdigitreverse
	bltu 	t3, s0, lfdigitreverse
	
swap:
	# values at adresses t4, t5 need to be swapped
	addi	t4, t0, -1
	addi	t5, t1, 1
	sb 	t2, (t5) 
	sb 	t3, (t4)
	b 	lookfordigit


print:
	#something to a0
	la	a0, buf
	li 	a7, print_string
	ecall
	
exits:
	li 	a7, exit
	ecall
