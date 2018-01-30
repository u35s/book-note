	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 13
	.globl	_HariMain
	.p2align	4, 0x90
_HariMain:                              ## @HariMain
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi0:
	.cfi_def_cfa_offset 16
Lcfi1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi2:
	.cfi_def_cfa_register %rbp
	jmp	LBB0_1
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	jmp	LBB0_1
	.cfi_endproc


.subsections_via_symbols
