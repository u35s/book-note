; hello-os
; TAB=4
CYLS	EQU		10

		ORG		0x7c00          ;ָ�������װ�ص�ַ
;��������Ǳ�׼FAT12��ʽ����ר�õĴ���
		JMP		entry
		DB		 0x90
		DB		"HARIBOTE"		; �����������ƿ�����������ַ��� 
		DW		512				; ÿ��ɽ��(sector)�Ĵ�С(����Ϊ512�ֽ�)
		DB		1				; ��(cluster)�Ĵ�С(����Ϊһ������)
		DW		1				; FAT����ʼλ��(һ��ӵ�һ��������ʼ)
		DB		2				; FAT�ĸ���(����Ϊ2)
		DW		224				; ��Ŀ¼�Ĵ�С(һ�����224��)
		DW		2880			; �ô��̵Ĵ�С(������2880����)
		DB		0xf0			; ���̵�����(������0xf0)
		DW		9				; FAT�ĳ���(������9����)
		DW		18				; һ���ŵ�(track)�м�������(������18)
		DW		2				; ��ͷ��(������2)
		DD		0				; ��ʹ�÷���,������0
		DD		2880			; ��дһ�δ��̴�С
		DB		0,0,0x29		; ���岻��,�̶�
		DD		0xffffffff		; (������)������
		DB		"HELLO-OS   "	; ���̵�����(11�ֽ�)
		DB		"FAT12   "		; ���̸�ʽ����(8�ֽ�)
		TIMES	18	DB 0		; �ȿճ�18�ֽ�

;��������
entry:
		MOV		AX,0			; ��ʼ���Ĵ���
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0	;����0
		MOV		DH,0	;��ͷ0
		MOV     CL,2	;����2

readloop:
		MOV		SI,0    ;��¼ʧ�ܴ����ļĴ���
retry:
		MOV		AH,0x02 ;����
		MOV		AL,1	;һ������
		MOV		BX,0	
		MOV		DL,0x00 ;A������
		INT		0x13	;����bios
		JNC		next    ;û����Ļ���ת��next
		ADD		SI,1	;��SI��1
		CMP		SI,5	;�Ƚ�SI��5
		JAE		error
		MOV		AH,0x00
		MOV		DL,0x00	;A������
		INT		0x13	;����������
		JMP		retry
next:
		MOV		AX,ES	;���ڴ��ַ����0x200
		MOV		AX,0x0020
		MOV		ES,AX	;��Ϊû��add es,0x020ָ��,����������΢�Ƹ���
		ADD		CL,1	;��CL���1
		CMP		CL,18	;�Ƚ�CL��18
		JBE		readloop;���cl <= 18 ��ת��readloop
		MOV		CL,1	;
		ADD		DH,1	;
		CMP		DH,2	;
		JB		readloop;���DH < 2,����ת��readloop
		MOV		DH,0	;
		ADD		CH,1	;
		CMP		CH,CYLS	
		JB		readloop;���ch < cyls,����ת��readloop
fin:
		HLT						; ��cpuֹͣ,�ȴ�ָ��
		JMP		fin				; ����ѭ��
error:
		MOV		SI,msg
;��Ϣ��ʾ����
putloop:
		MOV		AL,[SI]
		ADD		SI,1			; ��SI��1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; ��ʾһ������
		MOV		BX,15			; ָ���ַ���ɫ
		INT		0x10			; �����Կ�bios
		JMP		putloop
msg:
		DB		0x0a, 0x0a		; ��������
		DB		"load error"
		DB		0x0a			; ����
		DB		0

		TIMES	0x1fe-($-$$) DB 0	; ��д0x00,ֱ�� 0x1fe  ������0x7dfe�Ǵ��,����һ��

		DB		0x55, 0xaa
