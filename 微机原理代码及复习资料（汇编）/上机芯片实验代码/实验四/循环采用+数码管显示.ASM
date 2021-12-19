DATA SEGMENT
    IN0 EQU 298H
    IN1 EQU 299H
    ENTER DB 0DH,0AH,'$'

;;;;;;;;;8255+数码管;;;;;;;;;;
    PORT_A EQU 288H;对A口地址赋值
    PRRT_C EQU 28AH;对C口地址赋值
    PORT_CONTROL EQU 28BH;对控制端地址进行赋值
    PORT_Init EQU 80H;对8255进行初始数据赋值
    PARA_WORD DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH;'$'将段码存储在一个变量中
DATA ENDS

CODE SEGMENT
     ASSUME CS:CODE,DS:DATA
START:MOV AX,DATA
MOV DS,AX
;;;;;;初始化8255;;;;;;;;;;;;
    MOV DX,PORT_CONTROL;将控制端口的数据给DL
    MOV AL,PORT_Init;将初始化的数据给AL
    OUT DX,AL;将数据输出,8255A口始化完毕

;;;;;;;;;ADC开始采样;;;;;
     MOV DX,IN0
     OUT DX,AL;产生ALE,START信号，启动转化内容与AL无关
;;;;;;;;延时等待，等待ADC芯片工作完成;;;;;;;
     MOV CX,0FFH
     myDELAY:
     LOOP myDELAY
     
     MOV AX,0;将AX寄存器赋值0
     IN AL,DX;读取adc的数值并且把它保存在AL中
     MOV SI,AX;将adc数值给SI方便后续操作
     CALL DISP
     
     ;判断是否有按键按下，如果有则跳出程序
     MOV AH,6
     MOV DL,0FFH
     INT 21H
     JZ  START 
     MOV AH,4CH
     INT 21H
;;;;;;;;;;显示处理子函数;;;;;;;;
     DISP PROC NEAR
     ;;;;;;;;;除法求百位过程;;;;;;;;;;;
     MOV AX,SI;将数据给AX寄存器准备进行除法
     MOV CL,100;第一步先除100将百位数挖出来
     DIV CL;除法操作，因为cl中是8位的，因此AH存余数，AL存商
     PUSH AL;将此刻原始百位数值保存起来
     ADD AL,30H;将百位转化位ASCII码
    ;;;;;;;;数据显示百位;;;;;;;;;;
     MOV DL,AL;将数据给DL寄存器准备输出;;;
     MOV AH,02H;;;;;;2号调用
     INT 21H
     ;;;;;;;数码管显示百位;;;;;;;;;
     MOV AL,0100B;将输出位数从cl给al
     MOV DX,PRRT_C;将端口C的值给dx
     OUT DX,AL;将位码从pc口输出
     POP AL;将原始的百位恢复
     MOV BX,OFFSET PARA_WORD
     XLAT;XLAT指令是汇编语言查表指令，英文缩写为XLAT，是一种指令程序。操作是以DS:[BX+AL]为地址，提取存储器中的一个字节再送入AL。
     MOV DX,PORT_A
     OUT DX,AL;显示
     ;;;;;;熄灭数码管以便消除余晖;;;;;
     MOV AL,00H
     MOV DX,PORT_A
     OUT DX,AL
     ;;;;;;;;除法求十位和个位过程;;;;;;;
     MOV AX,SI;将数据给AX寄存器准备进行除法
     MOV CL,10;除10,将个位和十位挖出来
     DIV CL;除法操作，因为cl中是8位的，因此AH存余数，AL存商
     PUSH AH;将原始个位压入堆栈
     ADD AH,30H;将个位位转化位ASCII码
     MOV CH,AH;将个位保存在CH中准备后续输出
     MOV AH,00H;将AX的高位复位以便求十位
     MOV CL,10;
     DIV CL;除法操作，因为cl中是8位的，因此AH存余数，AL存商
     PUSH AH;将原始十位压入堆栈
     ADD AH,30H;将十位转化为ASCII码
     ;;;;;;;;数据显示十位和个位;;;;;;;
     MOV DL,AH;将十位数据给DX寄存器
     MOV AH,02H;二号调用
     INT 21H
     MOV DL,CH;将个位位数据给DX寄存器
     MOV AH,02H;二号调用
     INT 21H
;;;;;;数码管显示十位;;;;;;;;;
     MOV AL,0010B;将输出位数从cl给al
     MOV DX,PRRT_C;将端口C的值给dx
     OUT DX,AL;将位码从pc口输出
     POP AH;将原始的十位恢复
     MOV BX,OFFSET PARA_WORD
     XLAT;XLAT指令是汇编语言查表指令，英文缩写为XLAT，是一种指令程序。操作是以DS:[BX+AL]为地址，提取存储器中的一个字节再送入AL。
     MOV DX,PORT_A
     OUT DX,AL;显示
     ;;;;;;熄灭数码管以便消除余晖;;;;;
     MOV AL,00H
     MOV DX,PORT_A
     OUT DX,AL
;;;;;;数码管显示个位;;;;;;;;;
     MOV AL,0001B;将输出位数从cl给al
     MOV DX,PRRT_C;将端口C的值给dx
     OUT DX,AL;将位码从pc口输出
     POP AH;将原始的个位恢复
     MOV BX,OFFSET PARA_WORD
     XLAT;XLAT指令是汇编语言查表指令，英文缩写为XLAT，是一种指令程序。操作是以DS:[BX+AL]为地址，提取存储器中的一个字节再送入AL。
     MOV DX,PORT_A
     OUT DX,AL;显示
     ;;;;;;熄灭数码管以便消除余晖;;;;;
     MOV AL,00H
     MOV DX,PORT_A
     OUT DX,AL
     ;;;;;;;;换行;;;;;
     MOV DX,OFFSET ENTER
     MOV AH,09H
     INT 21H
     RET
     DISP ENDP
CODE ENDS
END STARS
