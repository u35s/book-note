; hello-os
; TAB=4

		ORG		0x7c00          ;ָ�������װ�ص�ַ
;��������Ǳ�׼FAT12��ʽ����ר�õĴ���
		JMP		entry
		DB		 0x90
		DB		"HELLOIPL"		; �����������ƿ�����������ַ��� 
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
		MOV		ES,AX

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
fin:
		HLT						; ��cpuֹͣ,�ȴ�ָ��
		JMP		fin				; ����ѭ��

msg:
		DB		0x0a, 0x0a		; ��������
		DB		"hello, world"
		DB		0x0a			; ����
		DB		0

		TIMES	0x1fe-($-$$) DB 0	; ��д0x00,ֱ�� 0x1fe  ������0x7dfe�Ǵ��,����һ��

		DB		0x55, 0xaa

;���������������ⲿ�ֵ����

		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		TIMES	4600 DB 0
		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		TIMES	1469432 DB 0
