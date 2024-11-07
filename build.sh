#! /bin/sh

if i686-elf-as boot.s -o boot.o; then 
	echo the bootloader is assembled
else
	echo the bootloader is not assembled
fi

if i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra; then
	echo the kernel is compiled
else
	echo the kernel is not compiled
fi

if i686-elf-gcc -T link.ld -o toy_os.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc; then
	echo the linking is done
else
	echo the linking is not done
fi

if grub-file --is-x86-multiboot toy_os.bin; then
	echo the file is bootable
else
	echo the file is not bootable
fi

mkdir -p iso/boot/grub
cp toy_os.bin iso/boot/toy_os.bin
cp grub.cfg iso/boot/grub/grub.cfg
grub-mkrescue -o toyos.iso iso
