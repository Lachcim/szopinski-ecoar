c_source = $(wildcard *.c)
asm_source = $(wildcard *.asm)

c_objects = $(c_source:.c=.o)
asm_objects = $(asm_source:.asm=.o)

find_markers: $(c_objects) $(asm_objects)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -m32 -o $@
	
%.o: %.c
	$(CC) -c $(CFLAGS) $^ -m32 -o $@

%.o: %.asm
	nasm -f elf -o $@ $^

.PHONY: clean
clean:
	rm -f *.o
	rm -f find_markers
