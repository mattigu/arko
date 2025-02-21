CC=gcc
CFLAGS=-m64 -Wall

all: main.o f.o
	$(CC) $(CFLAGS) main.o f.o -o f -lSDL2 -g -fPIE -no-pie

main.o:	main.c
	$(CC) $(CFLAGS) -c main.c -o main.o -g

f.o: f.s
	nasm -f elf64 f.s

clean:
	rm -rf *.o f