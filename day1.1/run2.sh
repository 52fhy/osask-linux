nasm -o hello2.img hello2.asm
qemu-system-i386 -drive file=hello2.img,if=floppy