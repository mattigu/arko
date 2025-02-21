getnum: getnum.o scandec.o
	cc -m32 -o getnum getnum.o scandec.o

getnum.o:
	cc -m32 -c getnum.c

scandec.o:
	nasm -f elf32 scandec.s
clean:
	rm *.o getnum
# EXEFILE = getnum
# OBJECTS = scandec.o getnum.o
# CCFMT = -m32
# NASMFMT = -f elf32
# CCOPT =
# NASMOPT = -w+all

# .c.o:
# 	cc $(CCFMT) $(CCOPT) -c $<

# .s.o:
# 	nasm $(NASMFMT) $(NASMOPT) -l $*.lst $<

# $(EXEFILE): $(OBJECTS)
# 	cc $(CCFMT) -o $@ $^

# clean:
# 	rm *.o *.lst $(EXEFILE)