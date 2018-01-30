# 目的:本程序查找一组数据中的最大值 

# 变量: 寄存器有以下用途:

# %edi 保存正在检测的数据索引项
# %ebx 当前已经找到的最大值
# %eax 当前数据项

# 使用以下内存位置
#
# data_items: 包含数据项,0表示数据结束
# 

.section .data

# data_items是一个指代其后位置的标签,接下来是一条指令,该指令以.long开始
# 这会让汇编程序为之后的数字列表保留内存。data_items是第一个数字的位置。
# 因为data_items是标签,在我们的程序中每当引用这个地址时,就可以使用data_item符号.
# 而汇编程序将在汇编时以数字起始处的地址取代它,例如:指令 movl data_items,%eax
# 会将3移入%eax。除了.long,还可以保留.byte,.int,.long,.ascii
data_items:
    .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section .text
.global _start

_start:
    movl $0,%edi                   # 将0移入索引寄存器
    movl data_items(,%edi,4), %eax # 加载数据的第一个字节,索引寻址方式,movl 起始地址(,%索引寄存器,字长)
    movl %eax,%ebx                 # 由于这是第一项,%eax就是最大值

start_loop:
    cmpl $0,%eax    # 检测是否到达数据末尾
    je loop_exit    # jump equal
    incl %edi       # 加载下一个值
    movl data_items(,%edi,4), %eax
    cmpl %ebx,%eax
    jle start_loop  # 若新数据项不大于原最大值,则跳到循环起始处,(jump less equal)
    movl %eax,%ebx  # 将新值移到最大值
    jmp start_loop  # 跳到循环开始处
loop_exit:
    # %ebx是系统调用exit的状态码,已经存放了最大值
    movl $1,%eax
    int $0x80
