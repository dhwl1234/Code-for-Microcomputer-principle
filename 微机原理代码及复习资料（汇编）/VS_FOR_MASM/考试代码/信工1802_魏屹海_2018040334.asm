DATAS SEGMENT
    STR1 DB 'PLEASE INPUT A STRING$'
    STR2 DB 'The length of the string is:$'
    STR3 DB 'The number of the English letters is:$'
    STR4 DB 'The converted string is:$'
    CR DB 0DH,0AH,'$'

    ;第一次输入的字符
    BUF DB 30
    DB ?
    DB 30 DUP('$')
    RESULT DB 30 DUP('$')
DATAS ENDS


STACKS SEGMENT
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
MOV AX,DATAS
MOV DS,AX

;第一问
;显示
MOV DX,OFFSET STR1
MOV AH,09H
INT 21H
MOV DX,OFFSET CR
MOV AH,09H
INT 21H
;输入
MOV DX,OFFSET BUF
MOV AH,0AH
INT 21H
MOV DX,OFFSET CR
MOV AH,09H
INT 21H

;显示实际的长度
MOV SI,0
MOV BL,BUF[1]
;除法转换
;显示
MOV DX,OFFSET STR2
MOV AH,09H
INT 21H

MOV SI,BX
MOV AX,SI;SI是要操作的数据
MOV CL,10
DIV CL
ADD AH,30H
MOV CH ,AH
ADD AL,30H
MOV DL,AL;div相除，若除数为8位，AH存余，AL存商
MOV AH,02H
INT 21H
MOV DL,CH
MOV AH,02H
INT 21H
;输出十位
MOV DX,OFFSET CR
MOV AH,09H
INT 21H
;第一问完成

;第二问
;初始化
MOV CX,0
MOV CL,BUF[1]
MOV SI,0
MOV DI,0
;判断
DEAL:
MOV BL,BUF[2+DI]
CMP BL,'A'
JL EXIT
CMP BL,'z'
JG EXIT

INC SI

EXIT:
INC DI
DEC CL
JNZ DEAL

MOV DX,OFFSET STR3
MOV AH,09H
INT 21H

;除法转换
MOV AX,SI;SI是要操作的数据
MOV CL,10
DIV CL
ADD AH,30H
MOV CH ,AH
ADD AL,30H
MOV DL,AL;div相除，若除数为8位，AH存余，AL存商
MOV AH,02H
INT 21H
MOV DL,CH
MOV AH,02H
INT 21H
MOV DX,OFFSET CR
MOV AH,09H
INT 21H
;输出十位
;第二问完成

;第三问
MOV CX,0
MOV CL,BUF[1]
MOV SI,0
MOV DI,0
;判断
DEAL1:
MOV BL,BUF[2+DI]
CMP BL,'0'
JL EXIT1
CMP BL,'9'
JG EXIT1

MOV RESULT[DI],'*'
JMP EXIT2

EXIT1:
MOV RESULT[DI],BL
INC DI
DEC CL
JNZ DEAL1
MOV DX,OFFSET STR4
MOV AH,09H
INT 21H
MOV DX,OFFSET RESULT
MOV AH,09H
INT 21H
MOV DX,OFFSET CR
MOV AH,09H
INT 21H

JMP OUT1

EXIT2:
INC DI
DEC CL
JNZ DEAL1
MOV DX,OFFSET STR4
MOV AH,09H
INT 21H
MOV DX,OFFSET RESULT
MOV AH,09H
INT 21H
MOV DX,OFFSET CR
MOV AH,09H
INT 21H


OUT1:
MOV AH,4CH
INT 21H

CODES ENDS
END START