## AT&T与Intel汇编语法比较

* 前缀 intel汇编语法中，寄存器和立即数都没有前缀，但是AT&T的汇编语法中，寄存器的前缀为%，立即数的前缀为$,

```Assembly
mov eax, 8 (Intel)
movl $8, %eax (AT&T)

mov eax, ebx (Intel)
movl %ebx, %eax (AT&T)
```

* 操作数方向 Intel和AT&T的操作数方向相反，Intel汇编中的第一个操作数为目的操作数，第二个为源操作数
AT&T汇编第一个为源操作数，第二个为目的操作数 

* 操作数位宽 Intel汇编中，由特定的字符指定操作数的位宽，例如BYTE PTR,WORD PTR,DWORD PTR来表示.
在AT&T汇编中，由操作码最后一个字符来指定操作数的位宽，b,w,l分别代表8，16，32位

```Assembly 
mov al, byte ptr bar (Intel)
movb %al, bar (AT&T)
```

* 间接寻址方式 
segreg:[base+index*scale+disp] (Intel)
segreg: disp(base,index,scale) (AT&T)

```C
struct test {
	int a;
	int b;
}
struct test bar[10];
```
假设现在要访问数组第6项的成员b,使用默认的段寄存器，对应的汇编代码如下：

```Assembly
# base表示数组基地址，对应本例中的bar
# index表示数组索引，对应本例中的第6项，就是5
# scale是结构体的大小，本例中大小为8字节
# disp是结构体内的偏移量，本例中b的偏移量为4
mov eax dword ptr [bar+5*8+4] (Intel)
movl 4(bar,5,8), %eax (AT&T)
```
