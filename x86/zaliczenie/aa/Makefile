# getlastdigits: getlastdigits.o leavelastndig.o
# 	cc -m32 -o getlastdigits getlastdigits.o leavelastndig.o

# getlastdigits.o:
# 	cc -m32 -c getlastdigits.c

# leavelastndig.o:
# 	nasm -f elf32 leavelastndig.s
# clean:
# 	rm *.o getlastdigits

EXEFILE = getlastdigits
OBJECTS = getlastdigits.o leavelastndig.o
CCFMT = -m32
NASMFMT = -f elf32
CCOPT =
NASMOPT = -w+all

.c.o:
	cc $(CCFMT) $(CCOPT) -c $<

.s.o:
	nasm $(NASMFMT) $(NASMOPT) -l $*.lst $<

$(EXEFILE): $(OBJECTS)
	cc $(CCFMT) -o $@ $^

clean:
	rm *.o *.lst $(EXEFILE)