;haribote.nas
CYLS EQU 0x0ff0		; 设定启动区
LEDS EQU 0x0ff1
VMODE EQU 0x0ff2	 ; 关于颜色数目的信息。颜色的位数。
SCRNX EQU 0x0ff4	; 分辨率的X（screen x）
SCRNY EQU 0x0ff6	; 分辨率的Y（screen y）
VRAM EQU 0x0ff8	    ; 图像缓冲区的开始地址

	org 0xc400  ;0x4400+0x8000 = 0xc400

	mov al, 0x13 ; VGA显卡，320x200x8位彩色	
	mov ah, 0x00 ;设置显示模式
	int 0x10

	mov byte [VMODE], 8	; 记录画面模式
	mov word [SCRNX], 320
	mov word [SCRNY], 200
	mov dword [VRAM], 0x000a0000	;在INT 0x10的说明的最后写着，这种画面模式下“VRAM是0xa0000～0xaffff的64KB”。

	;用BIOS取得键盘上各种LED指示灯的状态
	mov ah, 0x02
	int 0x16	; keyboard BIOS
	mov [LEDS], al

	mov si, mymsg		;!!!哦，让我们来显示自己的字符吧！
	call putchar

fin:
	hlt
	jmp fin

; 该段代码可以理解为是字符串显示函数。使用call调用
putchar:
	;原作者真是无聊，3.8节竟然依然是黑框框。
	;那么我们就来做点修改，显示一些字符吧!
	mov al, [si]
	mov ah, 0x0e
	mov bx, 15
	int 0x10

	add si, 1
	cmp al, 0
	je over

	jmp putchar
	
over:
	ret

mymsg:
	db 0x0a, 0x0d
	db "========="
	db 0x0a, 0x0d
	db "Hey, man~~~I'm ChrisZZ"
	db 0x0a, 0x0d
	db "my kernel is running"
	db 0x00
