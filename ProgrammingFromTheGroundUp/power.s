# 目的: 展示函数如何工作的程序
# 本程序将计算 2^3 + 5^2

# 主程序中的所有内容都存储在寄存器中
# 因此数据段中不含任何内容
.section .data

.section .text

# 目的: 本函数用于计算一个数的幂
# 参数: 第一个参数,底数
#       第二个参数,底数的指数
# 输出: 以返回值的形式给出结果
# 注意: 指数必须大于1
# 变量: %ebx 保存底数 
#       %ecx 保存指数
#       -4(%ebp) 保存当前结果
#       %eax 用于暂时存储
.type power, @function
power:
    #jmp exit
    pushl %ebp       #保留旧基址指针
    movl  %esp, %ebp #将基址指针设为栈指针,当前指向旧基址指针
    subl  $4, %esp   #移动当前位置向下增长一个字节,-4(%ebp),用来做临时变量
    movl  8(%ebp), %ebx #函数调用会push eip,然后跳转,所以是8
    movl  12(%ebp), %ecx 
    movl  %ebx, -4(%ebp) #存储当前结果

power_loop_start:
    cmpl $1, %ecx   #如果是一次方,那么我们已经获得结果
    je end_power 
    decl %ecx
    movl -4(%ebp), %eax  #将当前结果移入%eax
    imull %ebx, %eax     #将当前结果与底数相乘
    movl %eax, -4(%ebp)  #保存当前结果
    jmp power_loop_start

end_power:
    movl -4(%ebp), %eax #返回值移入%eax
    movl %ebp, %esp     #恢复栈指针
    popl %ebp  
    ret

.global _start

_start:
    pushl $3
    pushl $2
    call power
    addl $8, %esp   #将栈指针向后移动
    pushl %eax
    pushl $2
    pushl $5
    call power
    addl $8, %esp   #将栈指针向后移动
    popl %ebx       #第二个答案已经在%eax中,我们之前已经将第一个答案存储到栈中,所以现在可以将其弹出到%ebx
    addl %eax, %ebx #将两者相加,结果在%ebx中  
    jmp exit

exit:
    movl $1, %eax
    int $0x80
