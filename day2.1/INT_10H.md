**INT 10h**，**INT 10H**或**INT 16**是[BIOS中断调用](https://zh.m.wikipedia.org/wiki/BIOS中斷呼叫)的第10H功能的简写， 在基于[x86](https://zh.m.wikipedia.org/wiki/X86)的计算机系统中属于第17[中断向量](https://zh.m.wikipedia.org/wiki/中断向量)。[BIOS](https://zh.m.wikipedia.org/wiki/BIOS)通常在此建立了一个[中断处理程序](https://zh.m.wikipedia.org/w/index.php?title=中断处理程序&action=edit&redlink=1)提供了[实模式](https://zh.m.wikipedia.org/wiki/实模式)下的视频服务。此类服务包括设置显示模式，字符和字符串输出，和基本图形（在图形模式下的读取和写入[像素](https://zh.m.wikipedia.org/wiki/像素)）功能。要使用这个功能的调用，在寄存器AH赋予子功能号，其它的寄存器赋予其它所需的参数，并用指令INT 10H调用。INT 10H的执行速度是相当缓慢的，所以很多程序都绕过这个[BIOS](https://zh.m.wikipedia.org/wiki/BIOS)例程而直接访问显示硬件。设置显示模式并不经常使用，可以通过[BIOS](https://zh.m.wikipedia.org/wiki/BIOS)来实现，而一个游戏在屏幕上绘制图形，需要做得很快，所以直接访问显存比用BIOS调用每个像素更适合。

## 支持功能列表[编辑](https://zh.m.wikipedia.org/w/index.php?title=INT_10H&action=edit&section=1)

|             功能              |   功能代码    |                             参数                             |                             返回                             |
| :---------------------------: | :-----------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|         设置显示模式          |    AH=00H     |                         AL=显示模式                          |               AL=显示模式标志/CRT控制模式字节                |
|       设置文本方式光标        |    AH=01H     | CH=行扫描开始，CL=行扫描结束 通常一个字符单元有8个扫描行（0-7）。所以，CX=0607H是一个正常的光标，CX=0007H是一个完整块光标。如果设置CH的第5位，这通常意味着“隐藏光标”，所以CX=2607H是一种无形光标。  有些显示卡有16条扫描线（00H-0Fh）。  有些显示卡不使用CH的第5位，对于这种情况，可以尝试行扫描开始大于行扫描结束（如：CX=0706h） 。 |                                                              |
|         设置光标位置          |    AH=02H     |                    BH=页码，DH=行，DL=列                     |                                                              |
|      获取光标位置和形状       |    AH=03H     |                           BX=页码                            |       AX=0，CH=行扫描开始，CL=行扫描结束，DH=行，DL=列       |
| 读取光笔位置（VGA系统不工作） |    AH=04H     |                                                              | AH=状态（0=无触发，1=触发），BX=X像素，CH=Y像素，CL=像素行模式（0FH-10H），DH=字符Y，DL=字符X |
|        选择活动显示页         |    AH=05H     |                           AL=页码                            |                                                              |
|         向上滚动窗口          |    AH=06H     | AL=滚动的行（0=清除，被用于CH，CL，DH，DL）， BH=背景颜色和前景颜色，BH=43H，意义为背景颜色为红色，前景颜色为青色。请参考 [BIOS颜色属性](https://zh.m.wikipedia.org/w/index.php?title=BIOS颜色属性&action=edit&redlink=1)。 CH=高行数，CL=左列数，DH=低行数，DL=右列数 |                                                              |
|         向下滚动窗口          |    AH=07H     |                         参考向上滚动                         |                                                              |
|  读光标所在位置的字符和属性   |    AH=08H     |                           BH=页码                            |                       AH=颜色，AL=字符                       |
|  在当前光标位置写字符和属性   |    AH=09H     |          AL=字符，BH=页码，BL=颜色，CX=多次打印字符          |                                                              |
|      在光标位置写入字符       |    AH=0AH     |              AL=字符，BH=页码，CX=多次打印字符               |                                                              |
|       设置背景/边框颜色       | AH=0BH,BH=00H |        BL=背景/边框颜色（边框颜色只能在文本模式设置）        |                                                              |
|          设置调色板           | AH=0BH,BH=01H | BL=调色板ID（只使用于[CGA](https://zh.m.wikipedia.org/wiki/CGA)，但现在的显示卡都支持多个或所有模式。） |                                                              |
|          写图形像素           |    AH=0CH     |                 AL=颜色，BH=页码 CX=x，DX=y                  |                                                              |
|          读图形像素           |    AH=0DH     |                     BH=页码，CX=x，DX=y                      |                           AL=颜色                            |
|        电传打字机输出         |    AH=0EH     |        AL=字符，BH=页码，BL=颜色（只适用于图形模式）         |                                                              |
|       获取当前显示模式        |    AH=0FH     |                                                              | AH＝屏幕字符的列数`         AL＝显示模式(参见功能00H中的说明)         BH＝页码 ` |
| 写字符串（EGA+，最低PC AT ）  |    AH=13H     | AL=写模式，BH=页码，BL=颜色，CX=字符串长度，DH=行，DL=列，ES:BP=字符串偏移量 |                                                              |

## 参考[编辑](https://zh.m.wikipedia.org/w/index.php?title=INT_10H&action=edit&section=2)

- [INT 10h from Ralf Brown Interrupt List, online version](http://www.ctyme.com/intr/int-10.htm)（[页面存档备份](https://web.archive.org/web/20150519025759/http://www.ctyme.com/intr/int-10.htm)，存于[互联网档案馆](https://zh.m.wikipedia.org/wiki/互联网档案馆)）
- [INT 10h on www.ousob.com](https://web.archive.org/web/20121212035831/http://www.ousob.com/ng/asm/ng6f862.php)