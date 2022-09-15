mov ah, 0x0e
mov al, 'H'
int 0x10
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
int 0x10
mov al, 'o'
int 0x10
mov al, 0x20
int 0x10
mov al, 'w'
int 0x10
mov al, 'o'
int 0x10
mov al, 'r'
int 0x10
mov al, 'l'
int 0x10
mov al, 'd'
int 0x10
mov al, '!'
int 0x10
mov al, 0x20
int 0x10
mov al, 'o'
int 0x10
mov al, 'w'
int 0x10
mov al, 'o'
int 0x10
jmp $
times 510 - ($-$$) db 0
dw 0xaa55

; 这里面的$表示当前指令的地址，$$表示程序的起始地址(也就是最开始的7c00)，所以$-$$就等于本条指令之前的所有字节数。
; 510-($-$$)的效果就是，填充了这些0之后，从程序开始到最后一个0，一共是510个字节。
; 再加上最后的dw两个字节(0xaa55是结束标志)，整段程序的大小就是512个字节，刚好占满一个扇区。