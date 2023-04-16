SHELL=/bin/sh
AS=i686-elf-as
CC=i686-elf-gcc
CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS=-ffreestanding -O2 -nostdlib
BOOT=boot.s
KERNEL=kernel.c
LD=link.ld

all:boot.o
all:kernel.o
all:toy_os.bin

boot.o: $(BOOT)
	$(AS) $(BOOT) -o boot.o

kernel.o: $(KERNEL)
	$(CC) -c $(KERNEL) -o kernel.o $(CFLAGS)

toy_os.bin: $(LD) $(BOOT) $(KERNEL)
	$(CC) -T $(LD) -o toy_os.bin $(LDFLAGS) $(BOOT) $(KERNEL) -lgcc

$(SHELL) != grub-file --is-x86-multiboot toy_os.bin
$(SHELL) != mkdir -p iso/boot/grub
$(SHELL) != cp grub.cfg iso/boot/grub/grub.cfg
$(SHELL) != grub-mkrescue -o toyos.iso iso

clean:
	rm -r iso/ boot.o kernel.o toyos.iso toy_os.bin
