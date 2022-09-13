根据P29和P24-25写成
代码的功能：读取软盘的第一个扇区(512byte)到内存0x7c00的地方

为什么是0x7c00，是因为当年PC机器出来的时候IBM的大叔们规定的。

来自 IBM PC 5150 开发团队的解释是：

- 他们在设计系统时以内存最小为 32KiB 为目标
- 他们希望在 32KiB 之内流出更多的空间给 OS 来完成自身的引导
- 8086/8088 使用 0x0-0x3FF 来存放中断矢量，紧随其后的是 BIOS 的数据段
- 引导扇区(boot sector) 是 512字节，并且引导引导程序的栈大小为 512字节
- 所以 BIOS 将引导程序载入到 0x7c00 位置，引导程序将使用 32KiB 的最后 1024B 的内容
- 在 OS 载入完成后，引导扇区在内存中占据的内容将不再被使用，因此 OS 和应用程序可是使用这块内存。在 OS 载入后，内存中的情形类似:

```
+--------------------- 0x0
| Interrupts vectors
+--------------------- 0x400
| BIOS data area
+--------------------- 0x5??
| OS load area
+--------------------- 0x7C00
| Boot sector
+--------------------- 0x7E00
| Boot data/stack
+--------------------- 0x7FFF
| (not used)
+--------------------- (...)
```

运行helloos.img：

``` bash
sudo apt install nasm qeum qeum-system-x86
qemu-system-i386 -drive file=helloos.img,if=floppy
```



寄存器：

- AX——accumulator，累加寄存器
- CX——counter，计数寄存器
- DX——data，数据寄存器
- BX——base，基址寄存器
- SP——stack pointer，栈指针寄存器
- BP——base pointer，基址指针寄存器
- SI——source index，源变址寄存器
- DI——destination index，目的变址寄存器

这些寄存器全都是16位寄存器，因此可以存储16位的二进制数。虽然它们都有上面这种正式名称，但在平常使用的时候，人们往往用简单的英文字母来代替，称它们为“AX寄存器”、“SI寄存器”等。



另一方面，CPU中还有8个8位寄存器。

- AL——累加寄存器低位（accumulator low）
- CL——计数寄存器低位（counter low）
- DL——数据寄存器低位（data low）
- BL——基址寄存器低位（base low）
- AH——累加寄存器高位（accumulator high）
- CH——计数寄存器高位（counter high）
- DH——数据寄存器高位（data high）
- BH——基址寄存器高位（base high）



EAX, ECX, EDX, EBX, ESP, EBP, ESI, EDI这些就是32位寄存器。



段寄存器：

- ES——附加段寄存器（extra segment）
- CS——代码段寄存器（code segment）
- SS——栈段寄存器（stack segment）
- DS——数据段寄存器（data segment）
- FS——没有名称（segment part 2）
- GS——没有名称（segment part 3）
