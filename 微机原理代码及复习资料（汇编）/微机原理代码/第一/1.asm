DATAS SEGMENT
    ;�˴��������ݶδ���
    CR DB 0DH,0AH,'$'  ;���лس�
    STR1 DB 'YES$'
    STR2 DB 'NO$'
    STR3 DB 'please input again$'  
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    AGAIN:
    MOV AH,1   
    INT 21H
    ;�������
    MOV DX,OFFSET CR
    MOV AH,9   ;����DOS���ܣ��ù���Ϊ��ʾDS��DX��ַ�����ַ�
    INT 21H
    ;�ж�
    CMP AL,59H
    JE YES  ;������ת
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


