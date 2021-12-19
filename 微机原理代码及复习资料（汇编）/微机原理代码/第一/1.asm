DATAS SEGMENT
    ;此处输入数据段代码
    CR DB 0DH,0AH,'$'  ;换行回车
    STR1 DB 'YES$'
    STR2 DB 'NO$'
    STR3 DB 'please input again$'  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    AGAIN:
    MOV AH,1   
    INT 21H
    ;输出换行
    MOV DX,OFFSET CR
    MOV AH,9   ;调用DOS功能，该功能为显示DS：DX地址处的字符
    INT 21H
    ;判断
    CMP AL,59H
    JE YES  ;等于跳转
    CMP AL,79H
    JE YES
    CMP AL,4EH
    JE NO
    
    CMP AL,6EH
    JE NO
    
    erro:
    MOV DX,OFFSET STR3
    MOV AH,9
    INT 21H
    JMP AGAIN
    
    
    YES:
    MOV DX,OFFSET STR1
    MOV AH,9
    INT 21H
    JMP LAST
    
    NO:
    MOV DX,OFFSET STR2
    MOV AH,9
    INT 21H
    JMP LAST
    
    LAST:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


