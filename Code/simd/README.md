## SIMD
SIMD全称Single Instruction Multiple Data，单指令多数据流，能够复制多个操作数，并把它们打包在大型寄存器的一组指令集。

SIMD在性能上的优势：
以加法指令为例，单指令单数据（SISD）的CPU对加法指令译码后，执行部件先访问内存，取得第一个操作数；之后再一次访问内存，取得第二个操作数；随后才能进行求和运算。而在SIMD型的CPU中，指令译码后几个执行部件同时访问内存，一次性获得所有操作数进行运算。这个特点使SIMD特别适合于多媒体应用等数据密集型运算。

在c和go目录下分别有c语言和go语言内嵌汇编利用simd指令的例子

##go语言内嵌汇编说明

### The middot and (SB)

Function names in Go assembly files start with a middot character (·). The function declaration starts like this:

```Assembly
TEXT ·addsd(SB)
```
TEXT means that the following is meant for the text section of the binary (runnable code).
Next comes the middot · then the name of the function. Immediately after the name the extra (SB) is required.
This means “static base” and is an artifact of the Plan9 assembly format.
The real reason, from the Plan9 ASM documentation, 
is that functions and static data are located at offsets relative to the beginning of the start address of the program.

I literally copy-paste the middot every time. Who has a middot key?

### To NOSPLIT or not to NOSPLIT
The asm doc says this about NOSPLIT:

> NOSPLIT = 4 (For TEXT items.) Don’t insert the preamble to check if the stack must be split. 
The frame for the routine, plus anything it calls, must fit in the spare space at the top of the stack segment.
Used to protect routines such as the stack splitting code itself.

In this function’s case, we can add NOSPLIT because the function doesn’t use any stack space at all beyond the arguments it receives.
The annotation was probably not strictly necessary, but it’s fine to use in this case.
At this point I’m still not sure how the “spare space” at the top of the stack works and I haven’t found a good bit of documentation to tell me.

### How much stack space?

If your function requires more space than you have registers, you may need to spill on to the stack temporarily.
In this case, you need to tell the compiler how much extra space you need in bytes. 
This function doesn’t need that many temporary variables, so it doesn’t spill out of the registers.
That means we can use $0 as our stack space. The stack space is the last thing we need on the declaration line.

At this point we have one line done!

```Asembly
Text ·addsd(SB),4,$0
```
I have 4 written instead of NOSPLIT because I wasn’t quite doing things right. I’ll get to that in the next section.

[link](https://blog.sgmansfield.com/2017/04/a-foray-into-go-assembly-programming/)
