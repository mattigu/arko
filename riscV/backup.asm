	.data
	
buffer:	.space 100
	.text
	
main:
	la	a0, buffer
	li	a1, 100
	li	a7, 8
	ecall
	
	
	la 	t0, buffer
	la	t2, buffer
	li 	s0, 'A'
	li	s1, 'z'
	
search_letter:
	lb 	t1, (t0) # t1 - letter value 
	beqz 	t1, end
	blt	t1, s0, write
	bgt	t1, s1, write
	
	
# letter detected
search_odd:
	andi	t3, t1, 1
	# t3 is 0 if even
	bnez 	t3, next
	# t3 is uneven here needs to get deleted
write:
	sb	t1, (t2) 
	addi	t2, t2, 1
	
next:
	addi 	t0, t0, 1
	b 	search_letter

end:
	#adding null
	sb	zero, (t2)

print:
	la	a0, buffer
	li 	a7, 4
	ecall

exit:
	li 	a7, 10
	ecall