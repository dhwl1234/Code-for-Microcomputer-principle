DATAS SEGMENT
    ;�˴��������ݶδ���  
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
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
    ;�˴��������δ���
    ;��������
    MOV DX,OFFSET PEOPLE
    MOV AH,10
    INT 21H
    
    ;����
    MOV DX,OFFSET CR
    MOV AH,9
    INT 21H
    
    ;��ʼ��
    MOV CX,0      ;�ж�����
    MOV CL,INPUTLONG;��¼ʵ�������ַ����ĳ���
    MOV BX,0        ;��ָ�����
    
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
    
    ;����ַ�
    MOV DX,OFFSET RESULTDATA
    MOV AH,9
    INT 21H
    
    
    
    
    
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


