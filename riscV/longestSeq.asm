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
	
	la 	t0, buf # stores buf
	
	li 	s0, '9'
	li 	s1, '0'
	# t0 - current symbol address
	# t1 - current symbol value
	# t2 - current seq lenght 
	# t3 - adress of current seq
	# t4 - address of current longest seq of digits  
	# t5 - longest sequence lenght
checksym:
	lbu 	t1, (t0) 

	beqz 	t1, print
	bgtu	t1, s0, notdigit 
	bltu 	t1, s1, notdigit
	bnez	t3, countdigit # skips overwriting current t3 below if it's not the first digit in a seq
	mv 	t3, t0
	
countdigit:
	addi 	t2, t2, 1 
	bleu	t2, t5, next
	
updatelongest:
	mv 	t4, t3
	mv	t5, t2
	b 	next

notdigit:
	mv	t2, zero
	mv	t3, zero
	
next: 
	addi 	t0, t0, 1
	b 	checksym

print:
	# crashes when no numbers but too eepy
	# before printing add a null sing at the end
	add	t6, t4, t5 # prob should use older now not used 't' registers
	sb   	zero, (t6)
	mv	a0, t4
	li 	a7, print_string
	ecall
	
exits:
	li 	a7, exit
	ecall
