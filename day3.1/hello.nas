;hello.nas
	org 0x7c00;跳转到内存地址0x7c00处

fat12:
	;设定fat12格式
	jmp entry
	db 0x90
	db "chris_zz";	8bytes
	dw 512
	db 1
	dw 1
	db 2
	dw 224
	dw 2880
	db 0xf0
	dw 9
	dw 18
	dw 2
	dd 0
	dd 2880
	db 0,0,0x29
	dd 0xffffffff
	db "My First OS"
	db "FAT12   "

entry:
	;程序主要部分
	MOV      AX,0              ; 初始化寄存器
	MOV      SS, AX  ;SS栈段寄存器
	MOV      DS, AX  ;DS数据段寄存器
	MOV      ES, AX  ;ES附加段段寄存器
	
	MOV      SP,0x7c00  ;SP栈指针寄存器
	MOV      SI, msg	;SI源变址寄存器。将msg标签的首地址赋值给SI

	;call putloop		;!!!本次添加部分
						;这句本来写的是jmp putloop,后来到3.7天的时候发现和书上的现象对应不上，而且3.5天的0000:4400处的连续3个字符也不是F4 EB FD
						;现在修改jmp为call,后面的这两个现象就能够对应上了!

	mov ax, 0x0820	;!!!本次添加部分
	mov es, ax		;!!!本次添加部分
	mov ch, 0		;!!!本次添加部分 柱面0
	mov dh, 0		;!!!本次添加部分 磁头0
	mov cl, 2		;!!!本次添加部分 扇区2

	mov ah, 0x02	;!!!本次添加部分 ah=0x02读盘
	mov al, 1		;!!!本次添加部分 1个扇区
	mov bx, 0		;!!!本次添加部分
	mov dl, 0x00	;!!!本次添加部分 a驱动器
	int 0x13		;!!!本次添加部分  调用磁盘BIOS中断
	jc error		;!!!本次添加部分。JC，是“jump if carry”的缩写，意思是如果进位标志（carry flag）是1的话，就跳转

putloop:
	;循环显示字符
	;通过0x10中断，显示一个字符
	MOV      AL, [SI]      ;把SI地址的1个字节的内容读入AL中
	ADD      SI,1              ; 给SI加1
	CMP      AL,0   		;判断AL=0吗？
	JE       fin   			 ;上一句判断AL=0成立时执行；否则继续往下执行
	MOV      AH,0x0e          ; 显示一个文字
	MOV      BX,15             ; 指定字符颜色
	INT      0x10              ; 调用显卡BIOS
	JMP      putloop

fin:
	;当需要显示的信息都显示完毕，那么进入死循环
	hlt
	jmp fin

msg:
	;设定需要显示的字符
	db 0x0a, 0x0a
	db "============="
	db 0x0a
	db 0x0d
	db "Nice day ~~~"
	db 0x0a
	db 0x0d
	db "This is my first 0S"
	db 0x0a
	db 0x0d
	db "copyright GPL"
	db 0x0a
	db 0x0d
	db "AUTHOR: ChrisZZ"
	db 0x0a
	db 0x0d
	db "blog:http://chriszz.sinaapp.com"
	db 0x0a
	db 0x0d
	db 0

error:
	;!!!本次添加部分
	db 0x0a, 0x0a
	db "XXXXXXXXXXX"
	db 0x0a, 0x0d
	db "error occured"
	db 0x0a, 0x0d

endpart:
	times 510-($-$$) db 0
	db 0x55, 0xaa
