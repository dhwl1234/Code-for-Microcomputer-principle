DATAS SEGMENT
    ;此处输入数据段代码  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    PEOPLE DB 50
    INPUTLONG DB ?
    INPUTDATA DB 50 DUP(?)
    RESULTDATA DB 50 DUP(?)
    CR DB 0DH,0AH,'$' 
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    ;键入数据
    MOV DX,OFFSET PEOPLE
    MOV AH,10
    INT 21H
    
    ;换行
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H
    
    ;初始化
    MOV CX,0      ;判断数据
    MOV CL,INPUTLONG;记录实际输入字符串的长度
    MOV BX,0        ;将指针归零
    
    DEAL:
    MOV AL,INPUTDATA[BX]
    CMP AL,41H
    JB NEXT
    CMP AL,5AH
    JA NEXT
    ADD AL,20H
    
    NEXT:
    MOV RESULTDATA[BX],AL
    INC BX
    LOOP DEAL
    
    ;输出字符
    MOV DX,OFFSET RESULTDATA
    MOV AH,9
    INT 21H
    
    
    
    
    
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


