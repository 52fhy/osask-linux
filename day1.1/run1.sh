nasm -o hello1.img hello1.asm
qemu-system-i386 -drive file=hello1.img,if=floppy