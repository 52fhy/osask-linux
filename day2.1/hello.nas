;hello.nas
	org 0x7c00;跳转到内存地址0x7c00处
	; org指令只会在编译期影响到内存寻址指令的编译（编译器会把所有程序用到的 段内偏移地址自动加上org后跟的数值），而其自身并不会被编译成机器码

fat12:
	;设定fat12格式
	jmp entry  ;jmp的本质是设置CS:IP，指示CPU下一步的执行命令地址
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

; 程序核心
entry:
	MOV      AX,0              ; 初始化寄存器
	MOV      SS, AX  ;SS栈段寄存器
	MOV      DS, AX  ;DS数据段寄存器
	MOV      ES, AX  ;ES附加段段寄存器
	
	MOV      SP,0x7c00  ;SP栈指针寄存器
	MOV      SI, msg	;SI源变址寄存器。将msg标签的首地址赋值给SI

putloop:
	MOV      AL, [SI]      ;把SI地址的1个字节的内容读入AL中
	ADD      SI,1              ; 给SI加1
	CMP      AL,0   ;AL=0吗
	JE       fin    ;上一句判断AL=0成立时执行；否则继续往下执行
	MOV      AH,0x0e          ; 显示一个文字
	MOV      BX,15             ; 指定字符颜色
	INT      0x10              ; 调用显卡BIOS
	JMP      putloop

fin:
	HLT                        ; 让CPU停止，等待指令
	JMP      fin               ; 无限循环

msg:
	DB       0x0a       		; 换行
	DB       "hello, world"
	DB       0x0a              ; 换行 代码：LF ASCII码：\ n
	DB 		 0x0d			   ; 回车 代码：CR ASCII码：\ r  

endpart:
	times 510-($-$$) db 0  ; 等同于 RESB  0x1fe-($-$$)
	db 0x55, 0xaa