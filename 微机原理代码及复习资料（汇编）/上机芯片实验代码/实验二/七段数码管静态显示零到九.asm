 DATA SEGMENT
    PORT_A EQU 288H;对A口地址赋值
    PRRT_C EQU 28AH;对C口地址赋值
    PORT_CONTROL EQU 28BH;对控制端地址进行赋值
    PORT_Init EQU 80H;对8255进行初始数据赋值
    POSITION_Init EQU 01H;对位码进行初始数据赋值
    PARA_WORD DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH;'$'将段码存储在一个变量中

DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
    START:MOV AX,DATA
   MOV DS,AX

   ;;;;;;;;;初始化8255;;;;;;;;;;;
    MOV DX,PORT_CONTROL;将控制端口的数据给DL
    MOV AL,PORT_Init;将初始化的数据给AL
    OUT DX,AL;将数据输出,8255初始化完毕
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MOV CL,00H;对于段码的数值的变化
    
;;;;;;;主函数;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MYLOOP:;主函数
   MOV DX,PRRT_C;将C口的地址给DX
    MOV AL,POSITION_Init
    OUT DX,AL;将位码输出
    MOV AL,CL
    LEA BX, PARA_WORD;将段码变量的偏移地址给BX
   ; XLAT;XLAT指令是汇编语言查表指令，英文缩写为XLAT，是一种指令程序。操作是以DS:[BX+AL]为地址，提取存储器中的一个字节再送入AL。
   XLAT
    MOV DX,PORT_A;将A口的地址给DL
    OUT DX,AL;将数据从A口输出
    INC CL
    CMP CL,0AH
    JNE DELAY
    MOV CL,00H
    JMP DELAY
    ;;;;;;;;
    
;;;;;;;;;;延迟函数;;;;;;;;;;;;;;;;;
DELAY:;延迟函数
    MOV SI,0
    WT1:MOV DI,100
    WT2:DEC DI
    JNZ WT2
    DEC SI
    CMP SI,0
    JE MYLOOP
    JMP WT1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    

CODE ENDS
END START
		