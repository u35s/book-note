; haribote-os
; TAB=4
CYLS	EQU		0x0ff0			; 设定启动区 
LEDS	EQU		0x0ff1
VMODE	EQU		0x0ff2			; 
SCRNX	EQU		0x0ff4			; 分辨率X
SCRNY	EQU		0x0ff6			; 分辨率Y
VRAM	EQU		0x0ff8			; 图像缓冲区的开始地址

		ORG 0x8200
		MOV AL,0x13         ;VGA显卡,320x200x8位彩色
		MOV AH,0x00
		INT 0x10
		MOV		BYTE [VMODE],8	; 这个程序将要装载到什么地方呢
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200
		MOV		DWORD [VRAM],0xa0000

		MOV		AH,0x02
		INT		0x16 			; keyboard BIOS
		MOV		[LEDS],AL
fin:
	HLT
	JMP fin
