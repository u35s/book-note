## 进入保护模式

movx x可以是下面的字符

* "" 自动识别
* l  32位
* w  16位
* b  8位

第一种是80286所使用的LMSW指令,后来的80386及更高型号的CPU为了保持向后兼容,都保留了这个指令。这个指令只能影响最低的4 bit,即PE,MP,EM和TS,对其它的没有影响

```
movw $0x0001, %ax #protected mode(PE) bit
lmsw %ax 
```

第二种是Intel所建议的在80386以后的CPU上使用的进入PM的方式,即通过移动MOV指令。MOV指令可以设置CR0寄存器的所有域的值。

```
movl %cr0,%eax 
xorb $0x01,%al 
movl %eax,%cr0
```
