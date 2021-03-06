DATAS SEGMENT
    STR1 DB 'PLEASE INPUT STRING$'
    STR2 DB 'PLEASE INPUT ANOTHER STRING $'
    STR3 DB 'MATCH!$'
    STR4 DB 'NO MATCH!$'
    ;第一次输入的字符串
    BUF1 DB  30 
    DB ?
    DB 30 DUP('$')
    ;第二次输入的字符串
    BUF2 DB 30 
    DB ?
    DB 30 DUP('?')
    ;回车
    CR  DB 0AH,0DH,'$'    
DATAS ENDS

STACKS SEGMENT
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
MOV AX,DATAS
MOV DS,AX
;输入第一个字符串
MOV DX,OFFSET STR1
MOV AH,09H
INT 21H
MOV DX,OFFSET CR
MOV AH,09H
INT 21H
MOV DX,OFFSET BUF1
MOV AH,0AH
INT 21H
MOV DX,OFFSET CR
MOV AH,09H
INT 21H
;输入第二个字符串
MOV DX,OFFSET STR2
MOV AH,09H
INT 21H
MOV DX,OFFSET CR
MOV AH,09H
INT 21H
MOV DX,OFFSET BUF2
MOV AH,0AH
INT 21H
MOV DX,OFFSET CR
MOV AH,09H
INT 21H

;初始化
MOV CL,BUF1[1]
MOV DL,BUF2[1]
CMP CX,DX
JNZ  NOMATCH

XOR SI,SI

COMPARE:
MOV BL,BUF1[2+SI]
MOV DL,BUF2[2+SI]
CMP BL,DL

JZ MATCHPART


JMP NOMATCH




MATCHPART:
INC SI
DEC CX
JNZ COMPARE


MATCHALL:
MOV DX,OFFSET STR3
MOV AH,09H
INT 21H
JMP EXIT

NOMATCH:
MOV DX,OFFSET STR4
MOV AH,09H
INT 21H
JMP EXIT

EXIT:
MOV AH,4CH
INT 21H

CODES ENDS
END START