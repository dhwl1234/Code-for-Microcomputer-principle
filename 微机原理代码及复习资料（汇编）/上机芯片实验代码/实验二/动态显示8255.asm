DATA SEGMENT
    PORT_A EQU 288H;对A口数据赋值
    PRRT_C EQU 28AH;对C口数据赋值
    PORT_CONTROL EQU 28BH;对控制端数据进行赋值
    PORT_Init EQU 80H;对8255进行初始数据赋值
    PARA_WORD DB 6DH,6DH,5BH,7FH;将段码存储在一个变量中
    POSITION_WORD DB 01H,02H,04H,08H;C口输出的位码
DATA ENDS



CODE SEGMENT
    ASSUME DS:DATA,CS:CODE
    START:MOV AX,DATA
MOV DS,AX
;;;;;;;;;;;;;初始化8255;;;;;;;;;;;
    MOV DX,PORT_CONTROL;将控制端口的数据给DL
    MOV AL,PORT_Init;将初始化的数据给AL
    OUT DX,AL;将数据输出,8255初始化完毕
    MOV CL,03H;循环输出的标志
;;;;;;;;;;主函数;;;;;;;;;;;;;;;;;
MYLOOP:
    MOV AL,CL;将输出位数从cl给al
    MOV BX,OFFSET POSITION_WORD;取偏移地址
    XLAT;重新赋值AL
    MOV DX,PRRT_C;将端口C的值给dx
    OUT DX,AL;将位码从pc口输出

    MOV AL,CL
    MOV BX,OFFSET PARA_WORD
    XLAT
    MOV DX,PORT_A
    OUT DX,AL
   
    MOV AL,00H
    MOV DX,PORT_A
    OUT DX,AL

   

    DEC CL
    CMP CL,11111111B
    JNE MYLOOP
    MOV CL,03H
JMP MYLOOP


CODE ENDS
END START
		