.globl	main
.data 	
    Input:	.string "Input a number:\n"
    Output:	.string "The damage:\n" 
.text
main:
    addi x18,x0,21	#put 21 into x18
    addi x19,x0,11	#put 11 into x19
    addi x20,x0,1	#put 1 into x20
    addi x21,x0,5	#put 5 into x21
    addi x22,x0,0	#result 
    la a0, Input	
    li a7,4		#4 PrintStirng
    ecall
    li a7,5		#5 ReadInt,stored in a0
    ecall
    jal x1 func		#call recursive func
    
    la a0,Output	
    li a7,4		#4 PrintStirng
    ecall
    mv a0,x22		#move x22(result) into a0
    li a7,1		#1 printint
    ecall
    li a7,10		#10 exit
    ecall
func:			#x is input number stored in a0
    blt a0,x0,else	#if(x<0) branch to else
    beq a0,x0,xeq0	#if(x==0) branch to xeq0
    beq a0,x20,xeq1 	#if(x==1) branch to xeq1
    blt a0,x19,xle10	#if(x<11) branch to xle10. range (1<x<=10) equal 1<x<11
    blt a0,x18,xle20	#if(x<21) branch to xle20. range (10<x<=20) equal 10<x<21
    bge a0,x18,xbg20	#if(x>=21) branch to xbg20
else:
    addi x22,x22,-1	#return -1
    jalr x0,0(x1)
xeq0:
    addi x22,x22,1	#return 1
    jalr x0,0(x1)
xeq1:
    addi x22,x22,5	#return 5
    jalr x0,0(x1)
xle10:
    addi  sp, sp, -8	#allocate space for saved register
    sw    x1, 0(sp)	#store x1(return address)   
    sw    a0, 4(sp)	#store origin x   
    addi  a0, a0, -1	#x-1
    jal   x1, func	#call func(x-1)
    
    lw    x26, 4(sp)   #load origin x into x26
    sw    a0,4(sp)    	#store result of func(x-1) into stack
    addi  a0, x26, -2	#x-2  
    jal   x1, func 	#call func(x-2)
    lw    x26,4(sp)	#load result of func(x-1) into x26
    add   a0,a0,x26	#func(x-1)+func(x-2)
    lw    x1,0(sp)	#load x1
    addi  sp,sp,8	#Deallocate space for saved register
    jalr  x0,0(x1)	#return first call func(x)
xle20:
    addi  sp, sp, -8      
    sw    x1, 0(sp)        
    sw    a0, 4(sp)        
    addi  a0, a0, -2    #x-2
    jal   x1, func	#call func(x-2)
    
    lw    x26, 4(sp)    
    sw    a0,4(sp)    
    addi  a0, x26, -3	#x-3  
    jal   x1, func	#call func(x-3)
    lw    x26,4(sp)
    add   a0,a0,x26	#func(x-3)+func(x-3)
    lw    x1,0(sp)
    addi  sp,sp,8
    jalr  x0,0(x1)
xbg20:
    addi  sp, sp, -8      
    sw    x1, 0(sp)        
    sw    a0, 4(sp)
    slli  x22,a0,1	#x22=2*x
                        
    div   a0, a0, x21	#x/5 
    jal   x1, func	#call func(x/5)
    sw    a0,4(sp) 
    add   a0,a0,x22	#func(x/5)+2*x
    lw    x1,0(sp)
    addi  sp,sp,8
    jalr  x0,0(x1)
    
    
    
