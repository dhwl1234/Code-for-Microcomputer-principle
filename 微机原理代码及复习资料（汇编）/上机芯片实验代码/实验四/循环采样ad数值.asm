DATA SEGMENT
    IN0 EQU 298H
    IN1 EQU 299H
    ENTER DB 0DH,0AH,'$'
DATA ENDS

CODE SEGMENT
     ASSUME CS:CODE,DS:DATA
START:
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
     ADD AL,30H;将百位转化位ASCII码
    ;;;;;;;;数据显示百位;;;;;;;;;;
     MOV DL,AL;将数据给DL寄存器准备输出;;;
     MOV AH,02H;;;;;;2号调用
     INT 21H
     ;;;;;;;;除法求十位和个位过程;;;;;;;
     MOV AX,SI;将数据给AX寄存器准备进行除法
     MOV CL,10;除10,将个位和十位挖出来
     DIV CL;除法操作，因为cl中是8位的，因此AH存余数，AL存商
     ADD AH,30H;将个位位转化位ASCII码
     MOV CH,AH;将个位保存在CH中准备后续输出
     ADD AL,30H;将十位转化为ASCII码
     ;;;;;;;;数据显示十位和个位;;;;;;;
     MOV DL,AL;将十位数据给DX寄存器
     MOV AH,02H;二号调用
     INT 21H
     MOV DL,CH;将个位位数据给DX寄存器
     MOV AH,02H;二号调用
     INT 21H
     ;;;;;;;;换行;;;;;
     MOV DX,OFFSET ENTER
     MOV AH,09H
     INT 21H
     RET
     DISP ENDP
CODE ENDS
END STARS
