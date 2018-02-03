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

## gcc内嵌汇编
linux内核源代码中,许多c代码内嵌汇编语句，这是通过关键字asm来实现的，形式如下

```C
static inline unsigned long native_read_cr2(void)
{
	unsigned long val;
yy	asm volatile("movl %%cr2,%0,\n\t" : "=r" (val));
	return val;
}
```

其中asm表示汇编指令开始，由于gcc在编译优化阶段，可能调整指令顺序，关键字volatile阻止gcc对这里的内嵌汇编指令进行优化。
另外在内核代码中常常还看到__asm__,__volatile__,他们的作用和asm,volatile是一样的，仅仅是防止现有的c代码中含有asm，volatile

```Assembly
asm volatile(assembler template : output : input : clobber);
```
其中assembler template为汇编指令部分，例如上例中的"mvol %%cr2,%0". output是输出部分，input是输入部分，clobber是被修改的部分。
汇编指令中的数字和前缀%表示样板操作数。例如%0，%1等，用来依次指代后面的输出部分，输入部分等样板操作数。
由于这些样板操作数使用了%，因此寄存器前面要加两个%。

为什么要这样呢，这是由于汇编指令中常常需要使用寄存器，但是寄存器是由gcc在编译时分配的，
由于访问寄存器要比访问内存快，因此当gcc对一个代码块进行优化时，通常把空闲的寄存器分配给被频繁访问的变量，
假设有以下代码块：

```C
int f()
{
	......
	int i;
	int total = 0;
	for (i = 0;i < 100; i++) {
		total += i;
	}
	......
	return total;
}
```
上面的代码块中，i和total都是被频繁访问的变量，因此gcc可能会为他妈分配两个空闲的寄存器，
例如把eax和ecx分配给i和total,这样在整个for循环只需对寄存器进行操作。如果在for循环之前所有的寄存器已经分配出去了，
此时就没有空闲的寄存器，gcc可能插入一条指令把某个寄存器的值写回到对应的内存变量中,
然后把这个寄存器分配给变量i,需要注意的是，这里讨论的是可能，因此程序员在任何时候都不知道哪个寄存器是空闲的。

我们再来看一个例子，汇编指令` bts n, ADDR `,可以把地址为ADDR的内存单元的第n位设置为1.其中ADDR是一个内存变量,
而n必须是立即数或寄存器,如果要在c代码中之间嵌入这条指令，而n是通过计算的得到的结果(n不是立即数),
这时就需要腾出一个寄存器来，而程序员不能预测到gcc在编译时对寄存器的分配情况。所以gcc的内嵌汇编提供一个模板，
来指导gcc该如何处理。下面是c代码中内嵌btsl指令的示例。

```C
static inline void set_bit(int nr, void *addr)
{
	asm("btsl %1,%0" : "+m" (*(u32 *)addr) : "Ir" (nr));
}
```
在这个例子中，输出部分为addr,输入部分为nr,没有损坏部分，修饰符"+m"限定指针指向一个可读写的内存单元，
"Ir"指定nr必须是一个立即数，或者是一个寄存器，当某段代码调用set_bit时传递的参数nr在内存中，这时候gcc必须分配一个寄存器，
并且插入一条指令把内存中的值加载到这个寄存器中。如果没有空闲的寄存器，那么gcc就要插入一条指令把某个寄存器保存到对应的内存中，
腾出这个寄存器来保存参数nr的值，最后再插入一条指令恢复这个寄存器的值。
在指令部分中的%0表示addr对应的操作数，%1表示nr对应的操作数，现在假设某段代码调用set_bit时传递的参数nr在内存中，gcc在代码生成时，
产生类似下面这样的代码：

```Assembly
# 腾出eax寄存器
pushl %eax;
movl nr, %eax;
# 假设（ebp-8）就是指针addr指向的内存单元地址
bts %eax, -8(ebp);
# 恢复寄存器
popl %eax
```

通过这个例子就可以理解gcc内嵌汇编复杂的原因了，理解完这个之后看一个更复杂的例子。

```C
#define mov_blk(src,dest,numwords)
__asm__ __volatile__ (
	"cld\n\t"
	"rep\n\t"
	"movsl"
	:
	: "S" (src), "D" (dest), "c" (numwords)
	: "%ecx", "%esi", "%edi" 
)
```
我们知道，串操作指令movs可以把ESI寄存器指向的内存块复制到edi指向的内存块,复制的字节数由ecx寄存器指定。
所以在执行rep movsl之前需要初始化esi,edi,ecx,但是上面这段代码并没有设置这几个寄存器，这是gcc自动完成的。
输入参数"S" (src)指定参数src必须保存到esi,D,C为edi,ecx
在损坏部分,%ecx,%esi,%edi说明汇编指令部分会改变这几个寄存器的值，如果之前这几个寄存器被分配给其他变量，
在代码前面gcc会插入汇编指令保存这个寄存器，在代码后gcc又会插入代码恢复这几个寄存器的值
