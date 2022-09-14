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



显卡中断：
- INT 0x10 = Video display functions (including VESA/VBE)
- INT 0x13 = mass storage (disk, floppy) access
- INT 0x15 = memory size functions
- INT 0x16 = keyboard functions

不幸的是，RBIL 没有明确指出哪些 BIOS 功能是“通用的”（在某种意义上）。也就是说，那些总是可用的，每个人都在使用的。部分原因是“标准” BIOS 功能随着时间的推移而增长，所以如果您回溯到足够长的时间，您通常会发现一台几乎不支持任何特定 BIOS 功能的计算机。但肯定有一套在大多数当前操作系统中普遍使用。

- INT 0x10, AH = 1 -- 设置光标
- INT 0x10, AH = 3 -- 光标位置
- INT 0x10, AH = 0xE -- 显示字符
- INT 0x10, AH = 0xF -- 获取视频页面和模式
- INT 0x10, AH = 0x11 -- 设置 8x8 字体
- INT 0x10, AH = 0x12 -- 检测 EGA/VGA
- INT 0x10, AH = 0x13 -- 显示字符串
- INT 0x10, AH = 0x1200 -- 备用打印屏幕
- INT 0x10, AH = 0x1201 -- 关闭光标仿真
- INT 0x10, AX = 0x4F00 -- 显存大小
- INT 0x10, AX = 0x4F01 -- VESA 获取模式信息调用
- INT 0x10, AX = 0x4F02 -- 选择 VESA 视频模式
- INT 0x10, AX = 0x4F0A -- VESA 2.0 保护模式接口



- INT 0x11 -- 硬件检测

（有关这些 BIOS 函数调用的更多详细信息， 请参阅[使用 BIOS 的 ATA ）](https://wiki.osdev.org/ATA_in_x86_RealMode_(BIOS))

- INT 0x13, AH = 0 -- 重置软盘/硬盘
- INT 0x13, AH = 2 -- CHS模式下读软盘/硬盘
- INT 0x13, AH = 3 -- 在 CHS 模式下写入软盘/硬盘
- INT 0x13, AH = 0x15 -- 检测第二个磁盘
- INT 0x13, AH = 0x41 -- 测试是否存在 INT 13 扩展
- INT 0x13, AH = 0x42 -- LBA方式读硬盘
- INT 0x13, AH = 0x43 -- LBA方式写硬盘


（有关这些 BIOS 函数调用的更多详细信息， 请参阅[检测内存 (x86) ）](https://wiki.osdev.org/Detecting_Memory_(x86))

- INT 0x12 -- 获得低内存大小
- INT 0x15, EAX = 0xE820 -- 获取完整的内存映射
- INT 0x15, AX = 0xE801 -- 获取连续内存大小
- INT 0x15, AX = 0xE881 -- 获取连续内存大小
- INT 0x15, AH = 0x88 -- 获取连续内存大小



- INT 0x15, AH = 0xC0 -- 检测 MCA 总线
- INT 0x15, AX = 0x0530 -- 检测 APM BIOS
- INT 0x15，AH = 0x5300——APM 检测
- INT 0x15, AX = 0x5303 -- APM 使用 32 位连接
- INT 0x15，AX = 0x5304——APM 断开连接



- INT 0x16, AH = 0 -- 读取键盘扫描码（阻塞）
- INT 0x16, AH = 1 -- 读取键盘扫描码（非阻塞）
- INT 0x16, AH = 3 -- 键盘重复率



https://wiki.osdev.org/BIOS  