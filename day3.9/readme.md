day3.9
hello.nas里代码没有变。

这里是导入C语言了。原作者用了一堆工具：cc1.exe,gas2nask.exe等。
这些工具是从linux下改造到windows下的。
为什么不在linux下用linux下的工具呢？
这也正是我动手在fedora下实践《30天》的原因。

创建kernel目录，在里面添加entry.S，screen.c，mmu.h等代码。和原作者说的一样，这里我们不求理解，要到后面才能完全理解这里做了什么。
这里唯一的目标就是，能够导入C语言并使用。
makefile对应做了修改：添加了kernel目录下的makefile；外层的makefile调用内层的makefile；
运行的时候也相应调整为（在外层运行）:
make
sudo make copy
sudo make run (这里现在也需要权限了)

注意里层的makefile编写的时候，gcc的参数-m32表示编译为32位，因为x86架构无法运行64位程序；ld的参数-m elf_i386也是为32位设定的。
如果你用来开发的电脑是32位的，那么不写这两个参数也是ok的。

原作者的C语言代码为bootpack.c,这里修改为main.c，并且函数名因为entry.S中的设定，main.c中修改为bootmain


======================
在代码的调式过程中，遇到一个问题，已经解决了，分享一下：
makefile中的run部分，用的是qemu命令：
qemu-system-i386 file-kernel,if=floppy
但是当我写成:
qemu-system-i386 file-kernel, if=floppy
就会报错说：
drive with bus=0, unit=0 (index=0) exists

空格、缩进什么的真的很重要。。。


