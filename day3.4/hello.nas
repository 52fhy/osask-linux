;hello.nas
CYLS EQU 10		;!!!本次添加部分
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
	mov ax, 0
	mov ss, ax
	mov ds, ax
	mov es, ax

	mov sp, 0x7c00

	mov si, msg
	call putloop

readsector:
	;为了方便，我把这段代码起名为readsector
	mov ax, 0x0820
	mov es, ax
	mov ch, 0	;柱面0
	mov dh, 0	;磁头0
	mov cl, 2	;扇区2
readloop:	;循环
	mov si, 0

retry:
	mov ah, 0x02	;ah=0x02读盘
	mov al, 1		;1个扇区
	mov bx, 0	
	mov dl, 0x00	;a驱动器
	int 0x13
	jnc next	;如果没有出错，那么跳转到next部分
	add si, 1
	cmp si, 5
	jae error
	mov ah, 0x00	;BIOS系统复为
	mov dl, 0x00
	int 0x13
	jmp retry

next:
	;读完18个扇区中剩余部分
	;要读下一个扇区，只需给CL加1，给ES加上0x20就行了;es附加段寄存器加了0x0020,相当于地址向后偏移了0x0200,也就是512B,一个扇区的大小
	mov ax, es
	add ax, 0x0020
	mov es, ax	;因为没有add es,0x0020指令,这里借用ax
	add cl, 1	;扇区+1
	cmp cl, 18	;循环直到扇区18
	jbe readloop	;如果<=18跳转
	;!!!本次添加部分:
	mov cl, 1	;扇区1
	add dh, 1	;磁头+1
	cmp dh, 2	;直到磁头=2
	jb readloop	;如果<2跳转
	mov dh, 0	;磁头0
	add ch, 1	;柱面+1
	cmp ch, CYLS	;直到柱面=10
	jb readloop	;如果<2跳转
	;!!!添加完毕
	;现在启动区程序已经写得差不多了。如果算上系统加载时自动装载的启动扇区，那现在我们已经能够把软盘最初的10× 2× 18× 512=184320 byte=180KB内容完整无误地装载到内存里了

putloop:
	;循环显示字符
	;通过0x10中断，显示一个字符
	mov al, [si]
	add si, 1
	cmp al, 0
	je fin
	mov ah, 0x0e
	mov bx, 10
	int 0x10
	jmp putloop

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
	db 0x0a, 0x0a
	db "XXXXXXXXXXX"
	db 0x0a, 0x0d
	db "error occured"
	db 0x0a, 0x0d

endpart:
	times 510-($-$$) db 0
	db 0x55, 0xaa
