; haribote-os
; TAB=4
	ORG 0x8200
	MOV AL,0x13
	MOV AH,0x00
	INT 0x10
fin:
	HLT
	JMP fin
