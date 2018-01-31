.data
.text

.global start

start:
#根据版本可能需要改为callq_main
callq main
pop   %rbx
movq  $1, %rax
int   $0x80

.include "main.s"
