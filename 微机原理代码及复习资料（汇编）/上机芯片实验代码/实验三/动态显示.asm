DATA SEGMENT
    MESS DB 'Pulse Interrupt！',0DH,0AH,'$'
;;;;;;;;;数码管;;;;;;;;;;;;;
    PORT_A EQU 288H;对A口地址赋值
    PRRT_C EQU 28AH;对C口地址赋值
    PORT_CONTROL EQU 28BH;对控制端地址进行赋值
    PORT_Init EQU 80H;对8255进行初始数据赋值
    POSITION_WORD DB 01H,02H,'$';C口输出的位码
    PARA_WORD DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH;'$'将段码存储在一个变量中
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,CS
    MOV DS,AX
;;;;;;初始化8255;;;;;;;;;;;;
    MOV DX,PORT_CONTROL;将控制端口的数据给DL
    MOV AL,PORT_Init;将初始化的数据给AL
    OUT DX,AL;将数据输出,8255A口始化完毕

;;;;;;写中断向量表,设置中断向量;;;;;;;;;
    MOV DX,OFFSET INT3;中断子程序入口偏移量。DS:DX=中断向量，AL=中断型号
    MOV AX,250BH    ;25H号功能，0B是端口号
    INT 21H         ;将DX映射的中断向量放到表类型为0BH的中断向量中

;;;;;;设置中断掩码，21H为中断屏蔽器地址;;;;;;
    CLI            ;CPU清中断标志
    IN AL,21H      ;设置中断屏蔽OCW1,注意是基地址
    AND AL,0F7H    ;1被屏蔽，0未屏蔽，只让IRQ3未屏蔽
    OUT 21H,AL     ;将设置给8259A

;;;;;;;;;;初始化循环次数;;;;;;;;
    MOV CL,0      ;设置循环次数
    STI            ;CPU开中断

   myloop:
   ;;;;;;数据管显示;;;;;;;;;
   
    MOV AX,CX
    MOV DL,10
    DIV DL

    PUSH AX

    MOV AL,AH
    MOV B  X,OFFSET PARA_WORD
    XLAT
    MOV DX,PORT_A
    OUT DX,AL


    MOV AL,0;将输出位数从cl给al
    MOV BX,OFFSET POSITION_WORD;取偏移地址
    XLAT;重新赋值AL
    MOV DX,PRRT_C;将端口C的值给dx
    OUT DX,AL;将位码从pc口输出

    
   
    MOV AL,00H
    MOV DX,PORT_A
    OUT DX,AL

    POP AX

    MOV BX,OFFSET PARA_WORD
    XLAT
    MOV DX,PORT_A
    OUT DX,AL


    MOV AL,1;将输出位数从cl给al
    MOV BX,OFFSET POSITION_WORD;取偏移地址
    XLAT;重新赋值AL
    MOV DX,PRRT_C;将端口C的值给dx
    OUT DX,AL;将位码从pc口输出


    CMP CL,20
    JNE myloop ;循环等待脉冲输入
    MOV AH,4CH  ;结束进程
    INT 21H
;;;;;;;;;;中断子程序;;;;;;;;;;;;
INT3:
    MOV AX,DATA
    MOV DS,AX
;;;;;;;显示消息;;;;;;;;
    MOV DX,OFFSET MESS
    MOV AH,09H
    INT 21H
    INC CL;CL数字加一
;;;;;;发送EOI结束中断;;;;;
    MOV AL,20H   ;中断结束命令OCW2，注意是偶地址
    OUT 20H,AL   ;主片8259中断命令寄存器地址
    CMP CL,20
    STI
    IRET

CODE ENDS
END START